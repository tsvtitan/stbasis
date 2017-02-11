unit URBMainTreeView;

interface

{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, DBCtrls, Grids, DBGrids, Buttons,
  IBCustomDataSet, IBQuery, IBTable, comctrls, dbtree,
  ImgList, Db, menus, IBDatabase, UMainUnited, IBEvents, IBSQLMonitor,
  tsvTVNavigator, tsvComCtrls, UMainForm;

type
  TfmRBMainTreeView = class(TfmMainForm,IAdditionalRBForm)
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
    procedure LoadFromIni; override;
    procedure SaveToIni; override;
    procedure ViewCount;dynamic;
    procedure ActiveQuery(CheckPerm: Boolean);dynamic;
    procedure SetImageFilter(FilterOn: Boolean);dynamic;
    procedure SetImageToTreeNodes;dynamic;
    procedure TreeViewDblClick(Sender: TObject); virtual;
    procedure TreeViewKeyPress(Sender: TObject; var Key: Char); virtual;
    procedure TreeViewExpanding(Sender: TObject; Node: TTreeNode;
                                var AllowExpansion: Boolean);
    procedure TreeViewExpanded(Sender: TObject; Node: TTreeNode);
    procedure TreeViewCustomDraw(Sender : TObject; TreeNode : TTreeNode;
                                 AFont : TFont; Var AColor, ABkColor : TColor);
    function CheckPermission: Boolean; dynamic;
    function GetFilterString: string; dynamic;
    function GetSql: string; dynamic;
    function GetLastOrderStr: string;
    procedure DataClose;
    procedure LocateToFirstNode;
    procedure TreeViewChange(Sender: TObject; Node: TTreeNode);
    procedure TreeViewAdvancedCustomDrawItem(
                 Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState;
                 Stage: TCustomDrawStage; var PaintImages, DefaultDraw: Boolean);
    function CheckDataSelect: Boolean; dynamic;             
  public
    TVNavigator: TTVNavigator;
    TreeView: TDBTreeView;
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

  end;

var
  fmRBMainTreeView: TfmRBMainTreeView;

procedure SetImageToTreeNodesByTreeView(TreeView: TTSVCustomTreeView);

implementation

uses tsvAdjust;

{$R *.DFM}

procedure SetImageToTreeNodesByTreeView(TreeView: TTSVCustomTreeView);
var
  i: Integer;
  nd: TTreeNode;
begin
  for i:=0 to TreeView.Items.Count-1 do begin
    nd:=TreeView.Items[i];
    if nd.HasChildren then begin
     nd.ImageIndex:=0;
     nd.SelectedIndex:=1;
    end else begin
     nd.ImageIndex:=2;
     nd.SelectedIndex:=2;
    end;
  end;
end;


procedure TfmRBMainTreeView.FormCreate(Sender: TObject);
begin
 try
  inherited;

  ViewSelect:=not _GetOptions.isEditRBOnSelect;

  TreeView:=TDBTreeView.Create(nil);
  TreeView.Parent:=pnTreeView;
  AssignFont(_GetOptions.RBTableFont,TreeView.Font);
  CursorColor:=_GetOptions.RBTableCursorColor;
  TreeView.Align:=alClient;
  TreeView.Width:=pnTreeView.Width-pnSQL.Width;
  TreeView.Images:=IL;
  TreeView.ReadOnly:=true;
  TreeView.DataSource:=ds;
  TreeView.HideSelection:=false;
  TreeView.OnKeyDown:=FormKeyDown;
  TreeView.OnDblClick:=TreeViewDblClick;
  TreeView.OnChange:=TreeViewChange;
  TreeView.OnKeyPress:=TreeViewKeyPress;
  TreeView.PopupMenu:=pmTV;

{  TreeView.OnExpanding:=TreeViewExpanding;
  TreeView.OnExpanded:=TreeViewExpanded;
  TreeView.OnCustomDraw:=TreeViewCustomDraw;}

//  TreeView.OnAdvancedCustomDrawItem:=TreeViewAdvancedCustomDrawItem;
  TreeView.TabOrder:=1;
  pnBut.TabOrder:=2;

  pnBut.Visible:=_GetOptions.VisibleEditPanel;
  pnFind.Visible:=_GetOptions.VisibleFindPanel;
  

  TVNavigator:=TTVNavigator.Create(nil);
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

procedure TfmRBMainTreeView.bibCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmRBMainTreeView.FormDestroy(Sender: TObject);
begin
 try
  inherited;
   _OnVisibleInterface(FhInterface,false);
  CloseAllSql(Self);
  DataClose;
  TVNavigator.Free;
  TreeView.Parent:=nil;
  TreeView.Free;

 except
  raise;
 end;
end;

procedure TfmRBMainTreeView.FormKeyDown(Sender: TObject; var Key: Word;
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

function TfmRBMainTreeView.CheckDataSelect: Boolean;
begin
  Result:=Mainqr.Active and not Mainqr.IsEmpty;
end;

procedure TfmRBMainTreeView.MR(Sender: TObject);
begin
  if CheckDataSelect then
   ModalResult:=mrOk;
end;

procedure TfmRBMainTreeView.FormResize(Sender: TObject);
begin
  SetPositionEdSearch;
end;

procedure TfmRBMainTreeView.SetPositionEdSearch;
begin
  edSearch.Width:=pnTreeView.Width-edSearch.Left-pnTreeView.BorderWidth;
end;

procedure TfmRBMainTreeView.ViewCount;
begin
 if MainQr.Active then
  lbCount.Caption:=ViewCountText+inttostr(GetRecordCount(Mainqr));
end;

procedure TfmRBMainTreeView.DataClose;
begin
  TreeView.Items.BeginUpdate;
  try
   Mainqr.Active:=false;
  finally
   TreeView.Items.EndUpdate;
  end;
end;

procedure TfmRBMainTreeView.ActiveQuery(CheckPerm: Boolean);
begin
  DataClose;
end;

procedure TfmRBMainTreeView.SetImageFilter(FilterOn: Boolean);
begin
  if FilterOn or (Trim(WhereString)<>'') then begin
    bibfilter.Font.Color:=_GetOptions.RbFilterColor;
  end else begin
    bibfilter.Font.Color:=clWindowText;
  end;
  lbCount.Font.Color:=bibfilter.Font.Color;
end;

procedure TfmRBMainTreeView.TreeViewDblClick(Sender: TObject);
var
  nd: TTreeNode;
begin
  nd:=TreeView.Selected;
  if nd=nil then exit;
  if not nd.HasChildren then begin
   if not Mainqr.Active then exit;
   if Mainqr.RecordCount=0 then exit;
   if pnSQL.Visible and bibChange.Enabled then begin
    bibChange.Click;
   end else bibView.Click;
  end; 
end;

function TfmRBMainTreeView.CheckPermission: Boolean;
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

procedure TfmRBMainTreeView.LoadFromIni;
begin
  try
    inherited;
  except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

procedure TfmRBMainTreeView.SaveToIni;
begin
  try
   inherited;
  except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

procedure TfmRBMainTreeView.InitMdiChildParams(hInterface: THandle; Param: PParamRBookInterface);
begin
   _OnVisibleInterface(hInterface,true);
   FhInterface:=hInterface;
   ViewSelect:=false;
   WhereString:=PrepearWhereString(Param.Condition.WhereStr);
   LastOrderStr:=PrepearOrderString(Param.Condition.OrderStr);
   ActiveQuery(true);
   TreeView.DataSource:=nil;
   FormStyle:=fsMDIChild;
   TreeView.DataSource:=ds;
   TreeView.FullCollapse;
   LocateToFirstNode;
   with Param.Locate do begin
    if KeyFields<>nil then begin
      MainQr.Locate(KeyFields,KeyValues,Options); 
    end;  
   end;
   if WindowState=wsMinimized then
     WindowState:=wsNormal;
   BringToFront;
   Show;
   SetImageToTreeNodes;
   TreeView.Invalidate;
end;

procedure TfmRBMainTreeView.SetImageToTreeNodes;
begin
  SetImageToTreeNodesByTreeView(TreeView);
end;

procedure TfmRBMainTreeView.TreeViewExpanding(Sender: TObject; Node: TTreeNode;
                                var AllowExpansion: Boolean);
begin
  TreeView.OnDblClick:=nil;
end;

procedure TfmRBMainTreeView.TreeViewExpanded(Sender: TObject; Node: TTreeNode);
begin
  TreeView.OnDblClick:=TreeViewDblClick;
end;

procedure TfmRBMainTreeView.TreeViewCustomDraw(Sender : TObject; TreeNode : TTreeNode;
                                 AFont : TFont; Var AColor, ABkColor : TColor);
{var
  rt: TRect;}
begin
{ if (TreeNode=TreeView.Selected) then begin
//   AbkColor:=clBtnFace;
  if (Not TreeView.Focused)  then begin
    AbkColor:=clHighlight;
    AColor:=clHighlightText;
  end else begin
    AbkColor:=CursorColor;
    AColor:=clHighlightText;
  end;
 end; }
end;

procedure TfmRBMainTreeView.edSearchKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 try
  if not isValidKey(Char(Key))or(Key=VK_BACK) then exit;
  if MainQr.isEmpty then exit;
  MainQr.Locate(TreeView.ListField,Trim(edSearch.Text),[loCaseInsensitive,loPartialKey]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBMainTreeView.edSearchKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_UP,VK_DOWN: TreeView.SetFocus;
  end;
  FormKeyDown(Sender,Key,Shift);
end;

procedure TfmRBMainTreeView.LocateToFirstNode;
var
  val: Variant;
begin
  if Mainqr.IsEmpty then exit;
  if TreeView.Items.Count=0 then exit;
  val:=TreeView.DBTreeNodes.GetKeyFieldValue(TreeView.Items[0]);
  Mainqr.locate(TreeView.KeyField,val,[loCaseInsensitive]);
//  TVNavigator.SetEnableButtons;
end;

procedure TfmRBMainTreeView.TreeViewAdvancedCustomDrawItem(
  Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState;
  Stage: TCustomDrawStage; var PaintImages, DefaultDraw: Boolean);
var
  rt: Trect;
  oldBrush: TBrush;
begin
 oldBrush:=TBrush.Create;
 try
  if GetFocus<>TreeView.Handle then begin
    if Node=TreeView.Selected then begin
      oldBrush.Assign(TreeView.Canvas.Brush);
      TreeView.Canvas.Brush.Style:=bsSolid;
      TreeView.Canvas.Brush.Color:=clBtnFace;
      rt:=Node.DisplayRect(true);
      TreeView.Canvas.FillRect(rt);
      TreeView.Canvas.Brush.Style:=bsClear;
      TreeView.Canvas.Font.Color:=clWindowText;
      TreeView.Canvas.TextOut(rt.Left+2,rt.top+1,node.text);
      TreeView.Canvas.Brush.Assign(oldBrush);
    end else begin
     DefaultDraw:=true;
    end;
  end else begin
    if Node=TreeView.Selected then begin
     oldBrush.Assign(TreeView.Canvas.Brush);
     TreeView.Canvas.Brush.Style:=bsSolid;
     TreeView.Canvas.Brush.Color:=CursorColor;
     rt:=Node.DisplayRect(true);
     TreeView.Canvas.FillRect(rt);
     TreeView.Canvas.Brush.Style:=bsClear;
     TreeView.Canvas.Font.Color:=clHighlightText;
     TreeView.Canvas.TextOut(rt.Left+2,rt.top+1,node.text);
     TreeView.Canvas.DrawFocusRect(rt);
     TreeView.Canvas.Brush.Assign(oldBrush);
    end else begin
     DefaultDraw:=true;
    end;
  end;
 finally
  oldBrush.Free;
 end;
end;

procedure TfmRBMainTreeView.TreeViewChange(Sender: TObject; Node: TTreeNode);
begin
  TVNavigator.SetEnableButtons;
end;

procedure TfmRBMainTreeView.FillTreeViewPopupMenu;

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

function TfmRBMainTreeView.GetFilterString: string;
begin
  Result:=WhereString;
end;

procedure TfmRBMainTreeView.bibFilterClick(Sender: TObject);
begin
  WhereString:='';
end;

function TfmRBMainTreeView.GetSql: string;
begin
  Result:=SQLString;
end;

function TfmRBMainTreeView.GetLastOrderStr: string;
begin
  Result:=LastOrderStr;
end;

procedure TfmRBMainTreeView.SetInterfaceHandle(Value: THandle);
begin
  FhInterface:=Value;
end;

procedure TfmRBMainTreeView.InitModalParams(hInterface: THandle; Param: PParamRBookInterface);
begin
  FhInterface:=hInterface;
  bibClose.Cancel:=true;
  bibOk.OnClick:=MR;
  bibClose.Caption:=CaptionCancel;
  bibOk.Visible:=true;
  TreeView.OnDblClick:=MR;
//  Grid.MultiSelect:=Param.Visual.MultiSelect;
  BorderIcons:=BorderIcons-[biMinimize];
  WindowState:=wsNormal;
  WhereString:=PrepearWhereString(Param.Condition.WhereStr);
  LastOrderStr:=PrepearOrderString(Param.Condition.OrderStr);
  ActiveQuery(true);
  with Param.Locate do begin
    if KeyFields<>nil then
      MainQr.Locate(KeyFields,KeyValues,Options);
  end;
end;

procedure TfmRBMainTreeView.ReturnModalParams(Param: PParamRBookInterface);
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

procedure TfmRBMainTreeView.pmTVPopup(Sender: TObject);
begin
  FillTreeViewPopupMenu;
end;

procedure TfmRBMainTreeView.TreeViewKeyPress(Sender: TObject; var Key: Char); 
begin
  if isValidKey(Key) then begin
   edSearch.SetFocus;
   edSearch.Text:=Key;
   edSearch.SelStart:=Length(edSearch.Text);
   if Assigned(edSearch.OnKeyPress) then
    edSearch.OnKeyPress(Sender,Key);
  end;  
end;


end.
