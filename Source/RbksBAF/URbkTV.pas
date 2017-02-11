unit URbkTV;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBCtrls, StdCtrls, Buttons, ExtCtrls, dbtree, comctrls, Db, IBDatabase,
  IBCustomDataSet, IBQuery, ImgList, UMainUnited, iniFiles;

type
  TFmRbkTV = class(TForm)
    pnFind: TPanel;
    Label1: TLabel;
    edFind: TEdit;
    pnBottom: TPanel;
    lbCount: TLabel;
    btOk: TBitBtn;
    DBNav: TDBNavigator;
    btClose: TBitBtn;
    pnTV: TPanel;
    IBQ: TIBQuery;
    RbkTran: TIBTransaction;
    DS: TDataSource;
    IL: TImageList;
    PnBtns: TPanel;
    pnSQL: TPanel;
    btInsert: TBitBtn;
    btEdit: TBitBtn;
    btDel: TBitBtn;
    pnModal: TPanel;
    btFilter: TBitBtn;
    btMore: TBitBtn;
    btRefresh: TBitBtn;
    btAdjust: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btCloseClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btOkClick(Sender: TObject);
    procedure edFindKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edFindKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormResize(Sender: TObject);
  private
    LastKey: Word;
    NewLeft,NewTop,NewWidth,NewHeight: Integer;
    NewWindowState: TWindowState;
    FhInterface: THandle;
    procedure SetPositionEdFind;
    procedure SetNewPosition;
    procedure CMShowingChanged(var Message: TMessage); message CM_SHOWINGCHANGED;
  protected
    procedure LoadFromIni; dynamic;
    procedure SaveToIni;dynamic;
    procedure ViewCount;dynamic;
    procedure ActiveQuery(CheckPerm: Boolean);dynamic;
    procedure SetImageFilter(FilterOn: Boolean);dynamic;
    procedure SetImageToTreeNodes;dynamic;
    procedure TVDblClick(Sender: TObject); virtual;
    procedure TVExpanding(Sender: TObject; Node: TTreeNode;
                                var AllowExpansion: Boolean);
    procedure TVExpanded(Sender: TObject; Node: TTreeNode);
    procedure TVCustomDraw(Sender : TObject; TreeNode : TTreeNode;
                                 AFont : TFont; Var AColor, ABkColor : TColor);
    function CheckPermission: Boolean; virtual;
    procedure DataClose;
  public
    TV: TDBTreeView;
    WhereStr, LastOrderStr: String;
    ViewSelect: Boolean;
    FilterInSide: Boolean;
    isPerm: Boolean;
    procedure InitMdiChildParams(hInterface: THandle);
    procedure InitModalParams(InterfaceHandle: THandle; Param: PParamRBookInterface);
    procedure ReturnModalParams(Param: PParamRBookInterface);

    procedure InitOnlyDataParams(Param: PParamRBookInterface);
    procedure ReturnOnlyDataParams(Param: PParamRBookInterface);

    procedure SetInterfaceHandle(Value: THandle);
    procedure MR(Sender: TObject);

  end;

var
  FmRbkTV: TFmRbkTV;

implementation
uses UFuncProc, Uconst, UAdjust;
{$R *.DFM}

procedure TFmRbkTV.MR(Sender: TObject);
begin
  ModalResult:=mrOk;
end;


procedure TFmRbkTV.FormCreate(Sender: TObject);
begin
 try
  Left:=Screen.width div 2-Width div 2;
  Top:=Screen.Height div 2-Height div 2;
  NewLeft:=Left;
  NewTop:=Top;
  NewWidth:=Width;
  NewHeight:=Height;
  NewWindowState:=WindowState;

  WindowState:=wsMinimized;
  TV:=TDBTreeView.CreateParented(pnTV.Handle);
  TV.Parent:=pnTV;
  TV.Align:=alClient;
  TV.Width:=pnTV.Width-pnSQL.Width;
  TV.Images:=IL;
  TV.ReadOnly:=true;
  TV.DataSource:=ds;
  TV.OnKeyDown:=FormKeyDown;
  TV.OnDblClick:=TVDblClick;
  TV.HideSelection:=false;
{  TV.OnExpanding:=TVExpanding;
  TV.OnExpanded:=TVExpanded;}
  TV.OnCustomDraw:=TVCustomDraw;
  TV.TabOrder:=1;
  pnBtns.TabOrder:=2;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TFmRbkTV.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=LastKey then begin
   LastKey:=0;
   exit;
  end;
  if Shift=[] then begin
   case Key of
    VK_F2: begin
     if pnSQL.Visible then
      if btInsert.Enabled then
        btInsert.Click;
    end;
    VK_F3: begin
     if pnSQL.Visible then
      if btEdit.Enabled then
        btEdit.Click;
    end;
    VK_F4: begin
     if pnSQL.Visible then
      if btDel.Enabled then
       btDel.Click;
    end;
    VK_F5: begin
     if btRefresh.Enabled then
      btRefresh.Click;
    end;
    VK_F6: begin
     if btMore.Enabled then
       btMore.Click;
    end;
    VK_F7: begin
     if btFilter.Enabled then
      btFilter.Click;
    end;
    VK_F8: begin
     if btAdjust.Enabled then
      btAdjust.Click;
    end;
    VK_UP,VK_DOWN: TV.SetFocus;
   end;
  end;
  _MainFormKeyDown(Key,Shift);
  LastKey:=Key;
end;

procedure TFmRbkTV.TVDblClick(Sender: TObject);
var
  nd: TTreeNode;
begin
  nd:=TV.Selected;
  if nd=nil then exit;
  if not nd.HasChildren then begin
   if not IbQ.Active then exit;
   if IbQ.RecordCount=0 then exit;
   if pnSQL.Visible and BtEdit.Enabled then begin
    BtEdit.Click;
   end else BtMore.Click;
  end;
end;

procedure TFmRbkTV.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//  if FormState=[fsCreatedMDIChild] then _RemoveFromLastOpenEntryes();
  Action:=cafree;
end;

procedure TFmRbkTV.btCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFmRbkTV.FormDestroy(Sender: TObject);
begin
  try
    SaveToIni;
    DataClose;
    TV.Free;
  except
    {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

procedure TFmRbkTV.DataClose;
begin
  Screen.Cursor:=crHourGlass;
  TV.Items.BeginUpdate;
  try
   IbQ.Active:=false;
  finally
   TV.Items.EndUpdate;
   Screen.Cursor:=crDefault;
  end;
end;




procedure TFmRbkTV.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  _MainFormKeyUp(Key,Shift);
end;

procedure TFmRbkTV.FormKeyPress(Sender: TObject; var Key: Char);
begin
  _MainFormKeyPress(Key);
end;

procedure TFmRbkTV.btOkClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TfmRBkTV.TVCustomDraw(Sender : TObject; TreeNode : TTreeNode;
                                 AFont : TFont; Var AColor, ABkColor : TColor);
begin
 if (TreeNode=TV.Selected) and (Not TV.Focused) then
 begin
   AbkColor:=clHighlight;
   AColor:=clHighlightText;
 end;
end;


procedure TFmRbkTV.SetPositionEdFind;
begin
  edFind.Width:=TV.Width-edFind.Left;
end;

procedure TFmRbkTV.SetNewPosition;
begin
  Left:=NewLeft;
  Top:=NewTop;
  Width:=NewWidth;
  Height:=NewHeight;
  WindowState:=NewWindowState;
end;

procedure TFmRbkTV.CMShowingChanged(var Message: TMessage);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then SetNewPosition;
end;

procedure TFmRbkTV.LoadFromIni;
var
  fi: TIniFile;

  procedure LoadFormProp;
  begin
    NewLeft:=ReadParam(ClassName,'Left',Left);
    NewTop:=fi.ReadInteger(ClassName,'Top',Top);
    NewWidth:=fi.ReadInteger(ClassName,'Width',Width);
    NewHeight:=fi.ReadInteger(ClassName,'Height',Height);
    NewWindowState:=TWindowState(fi.ReadInteger(ClassName,'WindowState',
      Integer(WindowState)));
  end;

begin
  try
    try
      LoadFormProp;
    finally
      fi.free;
    end;
  except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

procedure TFmRbkTV.SaveToIni;
var
  fi: TIniFile;

  procedure SaveFormProp;
  begin
    if FormState=[fsCreatedMDIChild] then begin
     fi.WriteInteger(ClassName,'Left',Left);
     fi.WriteInteger(ClassName,'Top',Top);
     fi.WriteInteger(ClassName,'Width',Width);
     fi.WriteInteger(ClassName,'Height',Height);
     fi.WriteInteger(ClassName,'WindowState',Integer(WindowState));
    end;
  end;

begin
  try
    fi:=nil;
    try
      SaveFormProp;
    finally
      fi.free;
    end;
  except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

procedure TFmRbkTV.ViewCount;
begin
 if IbQ.Active then
  lbCount.Caption:='Всего выбрано: '+inttostr(GetRecordCount(IbQ));
end;

procedure TFmRbkTV.ActiveQuery(CheckPerm: Boolean);
begin
  DataClose;
end;

procedure TFmRbkTV.SetImageFilter(FilterOn: Boolean);
begin
  if FilterOn then btFilter.Font.Color:=_getoptions.RbFilterColor  else
    btFilter.Font.Color:=clWindowText;
end;

procedure TFmRbkTV.SetImageToTreeNodes;
var
  i: Integer;
  ND: TTreeNode;
begin
  for i:=0 to TV.Items.Count-1 do
  begin
    ND:=TV.Items[i];
    if nd.HasChildren then
    begin
     ND.ImageIndex:=0;
     ND.SelectedIndex:=1;
    end else
    begin
     ND.ImageIndex:=2;
     ND.SelectedIndex:=2;
    end;
  end;
end;

procedure TFmRbkTV.TVExpanding(Sender: TObject; Node: TTreeNode; var AllowExpansion:
  Boolean);
begin
  TV.OnDblClick:=nil;
end;

procedure TFmRbkTV.TVExpanded(Sender: TObject; Node: TTreeNode);
begin
  TV.OnDblClick:=TVDblClick;
end;

function TFmRbkTV.CheckPermission: Boolean;
begin
  Result:=false;
end;


procedure TFmRbkTV.edFindKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=LastKey then begin
   LastKey:=0;
   exit;
  end;
  if Shift=[] then begin
   case Key of
    VK_F2: begin
     if pnSQL.Visible then
      if btInsert.Enabled then  btInsert.Click;
    end;
    VK_F3: begin
     if pnSQL.Visible then
      if btEdit.Enabled then    btEdit.Click;
    end;
    VK_F4: begin
     if pnSQL.Visible then  if btDel.Enabled then   btDel.Click;
    end;
    VK_F5: begin
     if btRefresh.Enabled then btRefresh.Click;
    end;
    VK_F6: begin
     if btMore.Enabled then btMore.Click;
    end;
    VK_F7: begin
     if btFilter.Enabled then btFilter.Click;
    end;
    VK_F8: begin
     if btAdjust.Enabled then   btAdjust.Click;
    end;
    VK_UP,VK_DOWN: ;//TreeView.SetFocus;
   end;
  end;
  _MainFormKeyDown(Key,Shift);
  LastKey:=Key;
end;

procedure TFmRbkTV.edFindKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 try
   if IbQ.isEmpty then exit;
   IbQ.Locate(TV.ListField,Trim(edFind.Text),[loPartialKey]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TFmRbkTV.InitMdiChildParams(hInterface: THandle);
begin
   _OnVisibleInterface(hInterface,true);
   FhInterface:=hInterface;
   ViewSelect:=false;
   ActiveQuery(true);
   FormStyle:=fsMDIChild;
   if WindowState=wsMinimized then begin
    WindowState:=wsNormal;
   end;
   BringToFront;
   Show;
end;

procedure TFmRbkTV.InitModalParams(InterfaceHandle: THandle; Param: PParamRBookInterface);
begin
  FhInterface:=InterfaceHandle;
  BtClose.Cancel:=true;
  btOk.OnClick:=MR;
  btClose.Caption:=CaptionCancel;
  btOk.Visible:=true;
  Tv.OnDblClick:=MR;
//  Tv.Items. MultiSelect:=Param.Visual.MultiSelect;
  BorderIcons:=BorderIcons-[biMinimize];
  WindowState:=wsNormal;
  WhereStr:=PrepearWhereString(Param.Condition.WhereStr);
  LastOrderStr:=PrepearOrderString(Param.Condition.OrderStr);
  ActiveQuery(true);
  with Param.Locate do begin
    if KeyFields<>nil then
      IbQ.Locate(KeyFields,KeyValues,Options);
  end;
end;

procedure TFmRbkTV.ReturnModalParams(Param: PParamRBookInterface);
var
  i,j: Integer;
begin
  if IbQ.IsEmpty then exit;
  IbQ.DisableControls;
  try
   SetLength(Param.Result,IbQ.FieldCount);
   for i:=0 to IbQ.FieldCount-1 do
   begin
     Param.Result[i].FieldName:=IbQ.Fields[i].FieldName;
     SetLength(Param.Result[i].Values,1);
     Param.Result[i].Values[0]:=IbQ.Fields[i].Value;
   {if Param.Visual.MultiSelect then begin
     for i:=0 to IbQ.FieldCount-1 do begin
       for j:=0 to Grid.SelectedRows.Count-1 do begin
         SetLength(Param.Result[i].Values,Grid.SelectedRows.Count);
         IbQ.GotoBookmark(pointer(Grid.SelectedRows.Items[j]));
         Param.Result[i].Values[j]:=IbQ.Fields[i].Value;
       end;
     end;
    end else
    begin
      for i:=0 to IbQ.FieldCount-1 do begin
         SetLength(Param.Result[i].Values,1);
         Param.Result[i].Values[0]:=IbQ.Fields[i].Value;
      end;
    end;}
    end;
  finally
   IbQ.EnableControls;
  end;
end;


procedure TFmRbkTV.InitOnlyDataParams(Param: PParamRBookInterface);
begin
  WhereStr:=PrepearWhereString(Param.Condition.WhereStr);
  LastOrderStr:=PrepearOrderString(Param.Condition.OrderStr);
  ActiveQuery(false);
end;

procedure TFmRbkTV.ReturnOnlyDataParams(Param: PParamRBookInterface);
begin
  FillParamRBookInterfaceFromDataSet(IbQ,Param,[]);
end;


procedure TFmRbkTV.FormResize(Sender: TObject);
begin
  SetPositionEdFind;
end;

procedure TFmRbkTV.SetInterfaceHandle(Value: THandle);
begin
  FhInterface:=Value;
end;


end.
