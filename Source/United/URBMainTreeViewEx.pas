unit URBMainTreeViewEx;

interface

{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, DBCtrls, Grids, DBGrids, Buttons,
  IBCustomDataSet, IBQuery, IBTable, comctrls, VirtualTrees, VirtualDBTree,
  ImgList, Db, menus, IBDatabase, UMainUnited, IBEvents, IBSQLMonitor,
  tsvTVNavigatorEx, UMainForm;

type
  TfmRBMainTreeViewEx = class(TfmMainForm,IAdditionalRBForm)
    pnTreeViewBack: TPanel;
    ds: TDataSource;
    Mainqr: TIBQuery;
    pnBut: TPanel;
    pnModal: TPanel;
    bibFilter: TButton;
    bibView: TButton;
    bibRefresh: TButton;
    pnSQL: TPanel;
    bibAdd: TButton;
    bibChange: TButton;
    bibDel: TButton;
    bibAdjust: TButton;
    pnFind: TPanel;
    Label1: TLabel;
    pnBottom: TPanel;
    bibOk: TButton;
    DBNav: TDBNavigator;
    lbCount: TLabel;
    bibClose: TButton;
    edSearch: TEdit;
    IBTran: TIBTransaction;
    IL: TImageList;
    pnTreeView: TPanel;
    pmTV: TPopupMenu;
    procedure FormCreate(Sender: TObject);
    procedure bibCloseClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure edSearchKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure bibFilterClick(Sender: TObject);
    procedure pmTVPopup(Sender: TObject);
  private
    FhInterface: THandle;
    LastKey: Word;
    procedure SetPositionEdSearch;
    procedure FillTreeViewPopupMenu;
  protected
    DefLastOrderStr: string;
    procedure LoadFromIni; override;
    procedure SaveToIni; override;
    procedure ViewCount;dynamic;
    procedure ActiveQuery(CheckPerm: Boolean);dynamic;
    procedure SetImageFilter(FilterOn: Boolean);dynamic;
    procedure TreeViewDblClick(Sender: TObject); virtual;
    procedure TreeViewKeyPress(Sender: TObject; var Key: Char); virtual;
    procedure TreeViewOnGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode;
                                      Kind: TVTImageKind; Column: Integer;  var Ghosted: Boolean; var ImageIndex: Integer);
    function CheckPermission: Boolean; dynamic;
    function GetFilterString: string; dynamic;
    function GetSql: string; dynamic;
    function GetLastOrderStr: string;
    procedure TreeViewChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    function CheckDataSelect: Boolean; dynamic;
    procedure ShowingChanged; override;
  public
    TVNavigator: TTVNavigatorEx;
    TreeView: TVirtualDBTree;
    CursorColor: TColor;
    WhereString: string;
    SQLString: string;
    LastOrderStr: String;
    ViewSelect: Boolean;
    FilterInSide: Boolean;
    isPerm: Boolean;
    procedure MR(Sender: TObject);
    procedure SetInterfaceHandle(Value: THandle);
    procedure InitMdiChildParams(hInterface: THandle; Param: PParamRBookInterface);dynamic;
    procedure InitModalParams(hInterface: THandle; Param: PParamRBookInterface); dynamic;
    procedure ReturnModalParams(Param: PParamRBookInterface); dynamic;

    function Locate(const KeyFields: string; const KeyValues: Variant; Options: TLocateOptions): Boolean; dynamic;
  end;

var
  fmRBMainTreeViewEx: TfmRBMainTreeViewEx;

implementation

uses tsvAdjust;

{$R *.DFM}

procedure TfmRBMainTreeViewEx.FormCreate(Sender: TObject);
begin
 try
  inherited;

  ViewSelect:=not _GetOptions.isEditRBOnSelect;

  TreeView:=TVirtualDBTree.Create(nil);
  TreeView.Parent:=pnTreeView;
  AssignFont(_GetOptions.RBTableFont,TreeView.Font);
  CursorColor:=_GetOptions.RBTableCursorColor;
  TreeView.Align:=alClient;
  TreeView.Width:=pnTreeView.Width-pnSQL.Width;
  TreeView.Images:=IL;
  TreeView.DataSource:=ds;
  TreeView.Margin:=2;
  TreeView.DefaultNodeHeight:=16;
  TreeView.OnKeyDown:=FormKeyDown;
  TreeView.OnDblClick:=TreeViewDblClick;
  TreeView.OnChange:=TreeViewChange;
  TreeView.OnKeyPress:=TreeViewKeyPress;
  TreeView.OnGetImageIndex:=TreeViewOnGetImageIndex;
  TreeView.PopupMenu:=pmTV;

  TreeView.TabOrder:=1;
  pnBut.TabOrder:=2;

  pnBut.Visible:=_GetOptions.VisibleEditPanel;
  pnFind.Visible:=_GetOptions.VisibleFindPanel;
  
  TVNavigator:=TTVNavigatorEx.Create(nil);
  TVNavigator.Parent:=pnBottom;
  TVNavigator.TreeView:=TreeView;
  TVNavigator.VisibleButtons:=TTVButtonSet(DBNav.VisibleButtons);
  TVNavigator.SetBounds(DBNav.Left,DBNav.Top,DBNav.Width,DBNav.Height);
  TVNavigator.Hints.Assign(DBNav.Hints);
  
  DBNav.DataSource:=nil;
  DBNav.Visible:=false;

  SetPositionEdSearch;

 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBMainTreeViewEx.bibCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmRBMainTreeViewEx.FormDestroy(Sender: TObject);
begin
 try
   inherited;
   _OnVisibleInterface(FhInterface,false);
   CloseAllSql(Self);
   TreeView.Parent:=nil;
   TreeView.Free;
   TVNavigator.Free;
 except
  raise;
 end;
end;

procedure TfmRBMainTreeViewEx.FormKeyDown(Sender: TObject; var Key: Word;
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
      if bibAdd.Enabled then
        bibAdd.Click;
    end;
    VK_F3: begin
     if pnSQL.Visible then
      if bibChange.Enabled then
        bibChange.Click;
    end;
    VK_F4: begin
     if pnSQL.Visible then
      if bibDel.Enabled then
       bibDel.Click;
    end;
    VK_F5: begin
     if bibRefresh.Enabled then
      bibRefresh.Click;
    end; 
    VK_F6: begin
     if bibView.Enabled then
       bibView.Click;
    end; 
    VK_F7: begin
     if bibFilter.Enabled then
      bibFilter.Click;
    end; 
    VK_F8: begin
     if bibAdjust.Enabled then
      bibAdjust.Click;
    end;
    VK_F9: begin
      edSearch.SetFocus;
    end;
    VK_UP,VK_DOWN: //TreeView.SetFocus;
   end;
  end; 
  inherited;
  LastKey:=Key;
end;

function TfmRBMainTreeViewEx.CheckDataSelect: Boolean;
begin
  Result:=Mainqr.Active and not Mainqr.IsEmpty;
end;

procedure TfmRBMainTreeViewEx.MR(Sender: TObject);
begin
  if CheckDataSelect then
   ModalResult:=mrOk;
end;

procedure TfmRBMainTreeViewEx.FormResize(Sender: TObject);
begin
  SetPositionEdSearch;
end;

procedure TfmRBMainTreeViewEx.SetPositionEdSearch;
begin
  edSearch.Width:=pnTreeView.Width-edSearch.Left-pnTreeView.BorderWidth;
end;

procedure TfmRBMainTreeViewEx.ViewCount;
begin
 if MainQr.Active then
  lbCount.Caption:=ViewCountText+inttostr(GetRecordCount(Mainqr));
end;

procedure TfmRBMainTreeViewEx.ActiveQuery(CheckPerm: Boolean);
begin
end;

procedure TfmRBMainTreeViewEx.SetImageFilter(FilterOn: Boolean);
begin
  if FilterOn or (Trim(WhereString)<>'') then begin
    bibfilter.Font.Color:=_GetOptions.RbFilterColor;
  end else begin
    bibfilter.Font.Color:=clWindowText;
  end;
  lbCount.Font.Color:=bibfilter.Font.Color;
end;

procedure TfmRBMainTreeViewEx.TreeViewDblClick(Sender: TObject);
var
  nd: PVirtualNode;
begin
  nd:=TreeView.FocusedNode;
  if nd=nil then exit;
  if not nd.ChildCount>0 then begin
   if not Mainqr.Active then exit;
   if Mainqr.RecordCount=0 then exit;
   if pnSQL.Visible and bibChange.Enabled then begin
    bibChange.Click;
   end else bibView.Click;
  end; 
end;

function TfmRBMainTreeViewEx.CheckPermission: Boolean;
begin
  isPerm:=_isPermissionOnInterface(FhInterface,ttiaView);
  bibOk.Enabled:=isPerm;
  if not ViewSelect then begin
   bibChange.Enabled:=isPerm and _isPermissionOnInterface(FhInterface,ttiaChange);
   bibAdd.Enabled:=isPerm and _isPermissionOnInterface(FhInterface,ttiaAdd);
   bibDel.Enabled:=isPerm and _isPermissionOnInterface(FhInterface,ttiaDelete);
   bibView.Enabled:=isPerm;
   bibFilter.Enabled:=isPerm;
   bibAdjust.Enabled:=isPerm;
  end else begin
   pnSQL.Visible:=false;
  end;
  Result:=isPerm;
end;

procedure TfmRBMainTreeViewEx.LoadFromIni;
begin
  inherited;
end;

procedure TfmRBMainTreeViewEx.SaveToIni;
begin
  inherited;
end;

procedure TfmRBMainTreeViewEx.InitMdiChildParams(hInterface: THandle; Param: PParamRBookInterface);
begin
   _OnVisibleInterface(hInterface,true);
   FhInterface:=hInterface;
   ViewSelect:=false;
   WhereString:=PrepearWhereString(Param.Condition.WhereStr);
   LastOrderStr:=PrepearOrderString(Param.Condition.OrderStr);
   if Trim(LastOrderStr)='' then  LastOrderStr:=DefLastOrderStr;
   ActiveQuery(true);
   Locate(Param.Locate.KeyFields,Param.Locate.KeyValues,Param.Locate.Options);
   FormStyle:=fsMDIChild;
   if WindowState=wsMinimized then
     WindowState:=wsNormal;
   BringToFront;
   Show;
end;

procedure TfmRBMainTreeViewEx.edSearchKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
 OldAfterScroll: TDataSetNotifyEvent;   
begin
 try
  if not isValidKey(Char(Key))or(Key=VK_BACK) then exit;
  if MainQr.IsEmpty then exit;
  Screen.Cursor:=crHourGlass;
  OldAfterScroll:=MainQr.AfterScroll;
  MainQr.AfterScroll:=nil;
  try
   MainQr.Locate(TreeView.ViewFieldName,Trim(edSearch.Text),[loCaseInsensitive,loPartialKey]);
  finally
   MainQr.AfterScroll:=OldAfterScroll;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBMainTreeViewEx.edSearchKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_UP,VK_DOWN: TreeView.SetFocus;
  end;
  FormKeyDown(Sender,Key,Shift);
end;

procedure TfmRBMainTreeViewEx.TreeViewChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  TVNavigator.SetEnableButtons;
end;

procedure TfmRBMainTreeViewEx.FillTreeViewPopupMenu;

  procedure CreateMenuItem(bt: TButton);
  var
    mi: TMenuItem;
  begin
    mi:=TMenuItem.Create(nil);
    if bt<>nil then begin
     mi.Caption:=bt.Caption;
     mi.Hint:=bt.Hint;
     mi.OnClick:=bt.OnClick;
     mi.Visible:=bt.Visible;
     mi.Enabled:=bt.Enabled;
    end else begin
     mi.Caption:='-';
    end;
    pmTV.Items.Add(mi);
  end;

  procedure FillFromControl(wt: TWinControl);
  var
    ct: TControl;
    i: Integer;
  begin
    for i:=0 to wt.ControlCount-1 do begin
      ct:=wt.Controls[i];
      if ct is TWinControl then
        FillFromControl(TWinControl(ct));
      if ct is TButton then
        CreateMenuItem(TButton(ct));
    end;
  end;

begin
  pmTV.Items.Clear;
  FillFromControl(pnSQL);
  CreateMenuItem(nil);
  FillFromControl(pnModal);
end;

function TfmRBMainTreeViewEx.GetFilterString: string;
begin
  Result:=WhereString;
end;

procedure TfmRBMainTreeViewEx.bibFilterClick(Sender: TObject);
begin
  WhereString:='';
end;

function TfmRBMainTreeViewEx.GetSql: string;
begin
  Result:=SQLString;
end;

function TfmRBMainTreeViewEx.GetLastOrderStr: string;
begin
  Result:=LastOrderStr;
end;

procedure TfmRBMainTreeViewEx.SetInterfaceHandle(Value: THandle);
begin
  FhInterface:=Value;
end;

procedure TfmRBMainTreeViewEx.InitModalParams(hInterface: THandle; Param: PParamRBookInterface);
begin
  FhInterface:=hInterface;
  bibClose.Cancel:=true;
  bibOk.OnClick:=MR;
  bibClose.Caption:=CaptionCancel;
  bibOk.Visible:=true;
  TreeView.OnDblClick:=MR;
  if Param.Visual.MultiSelect then
    TVirtualTreeOptions(TreeView.TreeOptions).SelectionOptions:=TVirtualTreeOptions(TreeView.TreeOptions).SelectionOptions+[toMultiSelect]
  else TVirtualTreeOptions(TreeView.TreeOptions).SelectionOptions:=TVirtualTreeOptions(TreeView.TreeOptions).SelectionOptions-[toMultiSelect];
  BorderIcons:=BorderIcons-[biMinimize];
  WindowState:=wsNormal;
  WhereString:=PrepearWhereString(Param.Condition.WhereStr);
  LastOrderStr:=PrepearOrderString(Param.Condition.OrderStr);
  if Trim(LastOrderStr)='' then  LastOrderStr:=DefLastOrderStr;
  ActiveQuery(true);
  Locate(Param.Locate.KeyFields,Param.Locate.KeyValues,Param.Locate.Options);
end;

procedure TfmRBMainTreeViewEx.ReturnModalParams(Param: PParamRBookInterface);
var
  Bookmarks: array of Pointer;
  bm: Pointer;
begin
  if MainQr.IsEmpty then exit;
  bm:=MainQr.GetBookmark;
  SetLength(Bookmarks,Length(Bookmarks)+1);
  Bookmarks[Length(Bookmarks)-1]:=bm;

  FillParamRBookInterfaceFromDataSet(MainQr,Param,Bookmarks);
end;

procedure TfmRBMainTreeViewEx.pmTVPopup(Sender: TObject);
begin
  FillTreeViewPopupMenu;
end;

procedure TfmRBMainTreeViewEx.TreeViewKeyPress(Sender: TObject; var Key: Char);
begin
  if isValidKey(Key) then begin
   edSearch.SetFocus;
   edSearch.Text:=Key;
   edSearch.SelStart:=Length(edSearch.Text);
   if Assigned(edSearch.OnKeyPress) then
    edSearch.OnKeyPress(Sender,Key);
  end;
end;

function TfmRBMainTreeViewEx.Locate(const KeyFields: string; const KeyValues: Variant; Options: TLocateOptions): Boolean;
var
  s: string;
  Pos: Integer;
begin
  Result:=false;
  if not MainQr.Active then exit;
  if TVarData(KeyValues).VType=varEmpty then exit;
  Screen.Cursor:=crHourGlass;
  try
    Result:=MainQr.Locate(KeyFields,KeyValues,Options);
    s:=GetFirstWord(KeyFields,[';'],Pos);
  finally
   Screen.Cursor:=crDefault;
  end;
end;

procedure TfmRBMainTreeViewEx.ShowingChanged;
begin
  SetPositionEdSearch;
end;

procedure TfmRBMainTreeViewEx.TreeViewOnGetImageIndex(Sender: TBaseVirtualTree;
    Node: PVirtualNode; Kind: TVTImageKind; Column: Integer;  var Ghosted: Boolean; var ImageIndex: Integer);
begin
  case Kind of
    ikNormal,ikSelected: begin
       if Node.ChildCount=0 then begin
         ImageIndex:=2;
       end else begin
         if Kind=ikNormal then
          ImageIndex:=0
         else ImageIndex:=1;
       end;
    end;
  end;
end;

end.
