unit UJRMainGrid;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, DBCtrls, Grids, DBGrids, Buttons,
  tsvDbGrid, IBCustomDataSet, IBQuery, IBTable,
  ImgList, Db, menus, IBDatabase, UMainUnited, IBEvents, IBSQLMonitor,
  IBUpdateSQL, UMainForm;

type
  TfmJRMainGrid = class(TfmMainForm,IAdditionalJRForm)
    pnMain: TPanel;
    ds: TDataSource;
    Mainqr: TIBQuery;
    pnBut: TPanel;
    pnFind: TPanel;
    lbSearch: TLabel;
    pnBottom: TPanel;
    bibOk: TButton;
    DBNav: TDBNavigator;
    lbCount: TLabel;
    bibClose: TButton;
    edSearch: TEdit;
    IBTran: TIBTransaction;
    pnGrid: TPanel;
    pmGrid: TPopupMenu;
    IBUpd: TIBUpdateSQL;
    pnModal: TPanel;
    bibRefresh: TButton;
    bibClear: TButton;
    bibFilter: TButton;
    bibAdjust: TButton;
    procedure FormCreate(Sender: TObject);
    procedure bibCloseClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure bibAdjustClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
    procedure edSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edSearchKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure pmGridPopup(Sender: TObject);
  private
    procedure SetPositionEdSearch;
    procedure FillGridPopupMenu;
  protected
    FhInterface: THandle;
    LastKey: Word;
    procedure LoadFromIni; override;
    procedure SaveToIni;override;
    procedure ViewCount;dynamic;
    procedure ActiveQuery(CheckPerm: Boolean);dynamic;
    procedure SetImageFilter(FilterOn: Boolean);dynamic;
    procedure GridTitleClick(Column: TColumn); virtual;
    procedure GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort); virtual;
    procedure GridDblClick(Sender: TObject); virtual;
    procedure GridKeyPress(Sender: TObject; var Key: Char); virtual;
    function CheckPermission: Boolean; dynamic;
    function GetFilterString: string; dynamic;
    function GetSql: string; dynamic;
    function GetLastOrderStr: string;
    function GetFilterStringNoRemoved: string; dynamic;
    function CheckDataSelect: Boolean; dynamic;
  public
    WhereString: string;
    WhereStringNoRemoved: string;
    SQLString: string;
    LastOrderStr: String;
    ViewSelect: Boolean;
    FilterInSide: Boolean;
    isPerm: Boolean;
    Grid: TNewdbGrid;
    procedure MR(Sender: TObject);
    procedure SetInterfaceHandle(Value: THandle);
    procedure InitMdiChildParams(hInterface: THandle; Param: PParamJournalInterface);
    procedure InitModalParams(hInterface: THandle; Param: PParamJournalInterface); dynamic;
    procedure ReturnModalParamsFromDataSetAndGrid(DataSet: TDataSet; Grd: TNewDbGrid; Param: PParamJournalInterface);
    procedure ReturnModalParams(Param: PParamJournalInterface); dynamic;
    procedure SetLastOrderFromTypeSort(FieldName: string; TypeSort: TTypeColumnSort);

    function LocateByRefreshParam(Param: PParamRefreshJournalInterface): Boolean; dynamic;
    function Locate(const KeyFields: string; const KeyValues: Variant; Options: TLocateOptions): Boolean; dynamic;
    
  end;

var
  fmJRMainGrid: TfmJRMainGrid;

implementation

uses tsvAdjust;

{$R *.DFM}

procedure TfmJRMainGrid.FormCreate(Sender: TObject);
begin
 try
  inherited;
  ViewSelect:=not _GetOptions.isEditRBOnSelect;
  Grid:=TNewdbGrid.Create(self);
  Grid.Parent:=pnGrid;
  Grid.Align:=alClient;
  Grid.Width:=pnGrid.Width-pnBut.Width;
  Grid.DataSource:=ds;
  Grid.RowSelected.Visible:=true;
  Grid.VisibleRowNumber:=_GetOptions.VisibleRowNumber;
  AssignFont(_GetOptions.RBTableFont,Grid.Font);
  Grid.TitleFont.Assign(Grid.Font);
  Grid.RowSelected.Font.Assign(Grid.Font);
  Grid.RowSelected.Brush.Style:=bsClear;
  Grid.RowSelected.Brush.Color:=_GetOptions.RBTableRecordColor;
  Grid.RowSelected.Font.Color:=clWhite;
  Grid.RowSelected.Pen.Style:=psClear;
  Grid.CellSelected.Visible:=true;
  Grid.CellSelected.Brush.Color:=_GetOptions.RBTableCursorColor;
  Grid.CellSelected.Font.Assign(Grid.Font);
  Grid.CellSelected.Font.Color:=clHighlightText;
  Grid.TitleCellMouseDown.Font.Assign(Grid.Font);
  Grid.Options:=Grid.Options-[dgEditing]-[dgTabs];
  Grid.RowSizing:=true;
  Grid.ReadOnly:=true;
  Grid.OnKeyDown:=FormKeyDown;
  Grid.OnTitleClick:=GridTitleClick;
  Grid.OnTitleClickWithSort:=GridTitleClickWithSort;
  Grid.OnDblClick:=GridDblClick;
  Grid.OnKeyPress:=GridKeyPress;
  Grid.PopupMenu:=pmGrid;
  Grid.TabOrder:=1;
  pnBut.TabOrder:=2;


  SetPositionEdSearch;

 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmJRMainGrid.bibCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmJRMainGrid.FormDestroy(Sender: TObject);
begin
 try
  inherited;
   _OnVisibleInterface(FhInterface,false);
  CloseAllSql(Self);
  Grid.Free;
 except
  raise;
 end;
end;

procedure TfmJRMainGrid.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=LastKey then begin
   LastKey:=0;
   exit;
  end;
  if Shift=[] then begin
   case Key of
    VK_F5: begin
     if bibRefresh.Enabled then
      bibRefresh.Click;
    end; 
    VK_F7: begin
     if bibFilter.Enabled then
      bibFilter.Click;
    end; 
    VK_F8: begin
     if bibAdjust.Enabled then
      bibAdjust.Click;
    end; 
    VK_UP,VK_DOWN: Grid.SetFocus;
    VK_F9: begin
      edSearch.SetFocus;
    end;
   end;
  end;
  inherited;
  LastKey:=Key;
end;

function TfmJRMainGrid.CheckDataSelect: Boolean;
begin
  Result:=Mainqr.Active and not Mainqr.IsEmpty;
end;

procedure TfmJRMainGrid.MR(Sender: TObject);
begin
  if CheckDataSelect then
   ModalResult:=mrOk;
end;

procedure TfmJRMainGrid.FormResize(Sender: TObject);
begin
  SetPositionEdSearch;
end;

procedure TfmJRMainGrid.SetPositionEdSearch;
begin
  edSearch.Width:=Grid.Width-edSearch.Left;
end;

procedure TfmJRMainGrid.bibAdjustClick(Sender: TObject);
begin
  SetAdjust(Grid.Columns,nil);
end;

procedure TfmJRMainGrid.ViewCount;
begin
 if MainQr.Active then
  lbCount.Caption:=ViewCountText+inttostr(GetRecordCount(Mainqr));
end;

procedure TfmJRMainGrid.ActiveQuery(CheckPerm: Boolean);
begin
end;

procedure TfmJRMainGrid.SetImageFilter(FilterOn: Boolean);
begin
  if FilterOn or (Trim(WhereString)<>'') then begin
    bibfilter.Font.Color:=_GetOptions.RbFilterColor;
  end else begin
    bibfilter.Font.Color:=clWindowText;
  end;
end;

procedure TfmJRMainGrid.GridTitleClick(Column: TColumn);
begin
end;

procedure TfmJRMainGrid.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
begin
end;

procedure TfmJRMainGrid.GridDblClick(Sender: TObject);
begin
end;

function TfmJRMainGrid.CheckPermission: Boolean;
begin
  isPerm:=_isPermissionOnInterface(FhInterface,ttiaView);
  bibOk.Enabled:=isPerm;
  if not ViewSelect then begin
   bibClear.Enabled:=isPerm and _isPermissionOnInterface(FhInterface,ttiaDelete);
   bibFilter.Enabled:=isPerm;
   bibAdjust.Enabled:=isPerm;
  end else begin
  end;
  Result:=isPerm;
end;

procedure TfmJRMainGrid.LoadFromIni;

  procedure LoadGridProp;
  var
    i: Integer;
    cl: TColumn;
    id: Integer;
  begin
    if Grid=nil then exit;
    if Grid.Columns.Count=0 then exit;
    for i:=0 to Grid.Columns.Count-1 do begin
      id:=ReadParam(ClassName,'ColumnID'+inttostr(i),i);
      cl:=TColumn(Grid.Columns.FindItemID(id));
      if cl<>nil then begin
       cl.Index:=ReadParam(ClassName,'ColumnIndex'+inttostr(i),cl.Index);
       cl.Width:=ReadParam(ClassName,'ColumnWidth'+inttostr(i),cl.Width);
       cl.Visible:=ReadParam(ClassName,'ColumnVisible'+inttostr(i),cl.Visible);
      end;
    end;
  end;

begin
  try
    inherited;
    LoadGridProp;
    Grid.DefaultRowHeight:=ReadParam(ClassName,'GridRowHeight',Grid.DefaultRowHeight);
  except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

procedure TfmJRMainGrid.SaveToIni;

  procedure SaveGridProp;
  var
    i: Integer;
    cl: TColumn;
  begin
    if Grid=nil then exit;
    if Grid.Columns.Count=0 then exit;
    for i:=0 to Grid.Columns.Count-1 do begin
      cl:=Grid.Columns.Items[i];
      WriteParam(ClassName,'ColumnID'+inttostr(i),cl.ID);
      WriteParam(ClassName,'ColumnIndex'+inttostr(i),cl.Index);
      WriteParam(ClassName,'ColumnWidth'+inttostr(i),cl.Width);
      WriteParam(ClassName,'ColumnVisible'+inttostr(i),cl.Visible);
    end;
  end;

begin
  try
    inherited;
    SaveGridProp;
    WriteParam(ClassName,'GridRowHeight',Grid.DefaultRowHeight);
  except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

procedure TfmJRMainGrid.InitMdiChildParams(hInterface: THandle; Param: PParamJournalInterface);
begin
   _OnVisibleInterface(hInterface,true);
   FhInterface:=hInterface;
   ViewSelect:=false;
   WhereString:=PrepearWhereString(Param.Condition.WhereStr);
   LastOrderStr:=PrepearOrderString(Param.Condition.OrderStr);
   WhereStringNoRemoved:=PrepearWhereStringNoRemoved(Param.Condition.WhereStrNoRemoved);
   ActiveQuery(true);
   Locate(Param.Locate.KeyFields,Param.Locate.KeyValues,Param.Locate.Options);
   FormStyle:=fsMDIChild;
   if WindowState=wsMinimized then
    WindowState:=wsNormal;
   BringToFront;
   Show;
end;

procedure TfmJRMainGrid.FillGridPopupMenu;

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
    pmGrid.Items.Add(mi);
  end;

  procedure FillFromControl(wt: TWinControl);
  var
   ct: TControl;
   i: Integer;
   list: TList;
  begin
   list:=TList.Create;
   try
    wt.GetTabOrderList(list);
    for i:=0 to list.Count-1 do begin
      ct:=list.Items[i];
      if ct is TWinControl then
        FillFromControl(TWinControl(ct));
      if ct is TButton then
        CreateMenuItem(TButton(ct));
    end;
   finally
    list.Free;
   end; 
  end;

begin
  pmGrid.Items.Clear;
  FillFromControl(pnBut);
end;

procedure TfmJRMainGrid.InitModalParams(hInterface: THandle; Param: PParamJournalInterface);
begin
  FhInterface:=hInterface;
  bibClose.Cancel:=true;
  bibOk.OnClick:=MR;
  bibClose.Caption:=CaptionCancel;
  bibOk.Visible:=true;
  Grid.OnDblClick:=MR;
  Grid.MultiSelect:=Param.Visual.MultiSelect;
  BorderIcons:=BorderIcons-[biMinimize];
  WindowState:=wsNormal;
  WhereString:=PrepearWhereString(Param.Condition.WhereStr);
  LastOrderStr:=PrepearOrderString(Param.Condition.OrderStr);
  WhereStringNoRemoved:=PrepearWhereStringNoRemoved(Param.Condition.WhereStrNoRemoved);
  ActiveQuery(true);
  Locate(Param.Locate.KeyFields,Param.Locate.KeyValues,Param.Locate.Options);
end;

procedure TfmJRMainGrid.ReturnModalParamsFromDataSetAndGrid(DataSet: TDataSet; Grd: TNewDbGrid; Param: PParamJournalInterface);
var
  i: Integer;
  Bookmarks: array of Pointer;
  bm: Pointer;
begin
  if DataSet=nil then exit;
  if Grd=nil then exit;
  if DataSet.IsEmpty then exit;
  if Grd.SelectedRows.Count>0 then begin
    for i:=0 to Grd.SelectedRows.Count-1 do begin
      SetLength(Bookmarks,Length(Bookmarks)+1);
      Bookmarks[Length(Bookmarks)-1]:=Pointer(Grd.SelectedRows.Items[i]);
    end;
  end else begin
    bm:=DataSet.GetBookmark;
    SetLength(Bookmarks,Length(Bookmarks)+1);
    Bookmarks[Length(Bookmarks)-1]:=bm;
  end;

  FillParamJournalInterfaceFromDataSet(DataSet,Param,Bookmarks);
end;

procedure TfmJRMainGrid.ReturnModalParams(Param: PParamJournalInterface);
begin
  ReturnModalParamsFromDataSetAndGrid(MainQr,Grid,Param);
end;

function TfmJRMainGrid.GetFilterString: string;
begin
  Result:=WhereString;
end;

function TfmJRMainGrid.GetFilterStringNoRemoved: string;
begin
  Result:=WhereStringNoRemoved;
end;

function TfmJRMainGrid.GetSql: string;
begin
  Result:=SQLString;
end;

function TfmJRMainGrid.GetLastOrderStr: string;
begin
  Result:=LastOrderStr;
end;

procedure TfmJRMainGrid.SetLastOrderFromTypeSort(FieldName: string; TypeSort: TTypeColumnSort);
begin
  case TypeSort of
    tcsNone:  LastOrderStr:='';
    tcsAsc: LastOrderStr:=' Order by '+FieldName+' asc ';
    tcsDesc: LastOrderStr:=' Order by '+FieldName+' desc ';
  end;
end;

procedure TfmJRMainGrid.SetInterfaceHandle(Value: THandle);
begin
  FhInterface:=Value;
end;

procedure TfmJRMainGrid.bibFilterClick(Sender: TObject);
begin
  WhereString:='';
end;

procedure TfmJRMainGrid.edSearchKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_UP,VK_DOWN: Grid.SetFocus;
  end;
  FormKeyDown(Sender,Key,Shift);
end;

procedure TfmJRMainGrid.edSearchKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  OldAfterScroll: TDataSetNotifyEvent;   
begin
 try
  if not isValidKey(Char(Key))or(Key=VK_BACK) then exit;
  if MainQr.IsEmpty then exit;
  if grid.SelectedField=nil then exit;
  Screen.Cursor:=crHourGlass;
  OldAfterScroll:=MainQr.AfterScroll;
  MainQr.AfterScroll:=nil;
  try
   MainQr.Locate(grid.SelectedField.FullName,Trim(edSearch.Text),[loCaseInsensitive,loPartialKey]);
  finally
   MainQr.AfterScroll:=OldAfterScroll;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmJRMainGrid.pmGridPopup(Sender: TObject);
begin
   FillGridPopupMenu;
end;

procedure TfmJRMainGrid.GridKeyPress(Sender: TObject; var Key: Char);
begin
  if isValidKey(Key) then begin
   edSearch.SetFocus;
   edSearch.Text:=Key;
   edSearch.SelStart:=Length(edSearch.Text);
   if Assigned(edSearch.OnKeyPress) then
    edSearch.OnKeyPress(Sender,Key);
  end;  
end;

function TfmJRMainGrid.Locate(const KeyFields: string; const KeyValues: Variant; Options: TLocateOptions): Boolean;
var
  s: string;
  Pos: Integer;
begin
  Result:=false;
  if not MainQr.Active then exit;
  Screen.Cursor:=crHourGlass;
  try
    MainQr.Locate(KeyFields,KeyValues,Options);
    s:=GetFirstWord(KeyFields,[';'],Pos);
    if Trim(s)<>'' then Grid.SelectedField:=MainQr.FieldByName(s);
  finally
   Screen.Cursor:=crDefault;
  end;
end;

function TfmJRMainGrid.LocateByRefreshParam(Param: PParamRefreshJournalInterface): Boolean;
begin
  Result:=Locate(Param.Locate.KeyFields,Param.Locate.KeyValues,Param.Locate.Options);
end;


end.
