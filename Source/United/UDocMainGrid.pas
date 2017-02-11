unit UDocMainGrid;

interface

{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, DBCtrls, Grids, DBGrids, Buttons,
  tsvDbGrid, IBCustomDataSet, IBQuery, IBTable,
  ImgList, Db, menus, IBDatabase, UMainUnited, IBEvents, IBSQLMonitor,
  IBUpdateSQL, ComCtrls, RxMemDS, IB, UMainForm;

type

  TfmDocMainGrid = class(TfmMainForm,IAdditionalDocForm)
    ds: TDataSource;
    pnBottom: TPanel;
    bibOk: TButton;
    bibClose: TButton;
    IBTran: TIBTransaction;
    pmGrid: TPopupMenu;
    pnTop: TPanel;
    lbNumber: TLabel;
    edNumber: TEdit;
    lbDate: TLabel;
    dtpDate: TDateTimePicker;
    pcMain: TPageControl;
    tsRequisitions: TTabSheet;
    tsData: TTabSheet;
    pnBackGrid: TPanel;
    pnBut: TPanel;
    bibAdjust: TButton;
    bibDel: TButton;
    bibChange: TButton;
    bibAdd: TButton;
    pnGrid: TPanel;
    pnFind: TPanel;
    lbSearch: TLabel;
    edSearch: TEdit;
    pnBottomGrid: TPanel;
    DBNav: TDBNavigator;
    lbCount: TLabel;
    bibConduct: TButton;
    bibPrint: TButton;
    bibNumber: TButton;
    bibView: TButton;
    procedure FormCreate(Sender: TObject);
    procedure bibCloseClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure bibAdjustClick(Sender: TObject);
    procedure edSearchKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure pmGridPopup(Sender: TObject);
    procedure bibNumberClick(Sender: TObject);
    procedure edNumberKeyPress(Sender: TObject; var Key: Char);
    procedure edNumberChange(Sender: TObject);
    procedure dtpDateChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private

    LastKey: Word;
    function GetTypeOperationName(ATypeOperation: TTypeOperationDocument): string;
  protected
    FhInterfaceHead: THandle;
    FhInterfaceRecord: THandle;
    TypeOperation: TTypeOperationDocument;
    ChangeFlag: Boolean;
    DocumentId: Integer;
    DocumentNumber: Integer;
    DocumentDate: TDateTime;
    DocumentPrefix: String;
    DocumentSufix: String;
    TypeDocId: Integer;
    ListDeleteRecords: TList;

    procedure LoadFromIni; override;
    procedure SaveToIni; override;
    procedure ViewCount;dynamic;
    procedure GridTitleClick(Column: TColumn); virtual;
    procedure GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort); virtual;
    procedure GridDblClick(Sender: TObject); virtual;
    procedure GridKeyPress(Sender: TObject; var Key: Char); virtual;
    function CheckPermissionHead: Boolean; dynamic;
    function CheckPermissionRecord: Boolean; dynamic;
    function CheckPermissionPrint: Boolean; dynamic;
    function CheckPermissionConduct: Boolean; dynamic;
    procedure FillGridPopupMenu; dynamic;
    procedure SetPositionEdSearch;
    procedure ShowingChanged; override;
    function CheckFieldsFill: Boolean; virtual;
    function CheckDataFill: Boolean; dynamic;

    procedure AddClick(Sender: TObject); dynamic;
    procedure ChangeClick(Sender: TObject); dynamic;
    function AddHeadAndRecord: Boolean; dynamic;
    function ChangeHeadAndRecord: Boolean; dynamic;
    procedure RefreshNeededInterface; virtual;
    function AddToJournalDocument(IBDB: TIBDatabase): Boolean; dynamic;
    function ChangeJournalDocument(IBDB: TIBDatabase): Boolean; dynamic;
    procedure AddOrChangeRecord; virtual;
    procedure DeleteRecords; virtual;
  public
    SQLString: string;
    FilterInSide: Boolean;
    Grid: TNewdbGrid;
    MemTable: TRxMemoryData;
    procedure SaveGridProp(ClsName: string; Grd: TDBGrid);
    procedure LoadGridProp(ClsName: string; Grd: TDBGrid);
    procedure MR(Sender: TObject);
    procedure SetInterfaceHandles(ValueHead,ValueRecord: THandle);
    procedure ReturnParamsFromDataSetAndGrid(DataSet: TDataSet; Grd: TNewDbGrid; Param: PParamDocumentInterface);
    procedure InitMdiChildParams(hInterfaceHead,hInterfaceRecord: THandle; Param: PParamDocumentInterface); dynamic;
    procedure InitModalParams(hInterfaceHead,hInterfaceRecord: THandle; Param: PParamDocumentInterface); dynamic;
    procedure ReturnModalParams(Param: PParamDocumentInterface); dynamic;
    procedure ActiveQuery(CheckPerm: Boolean);dynamic;
  end;

var
  fmDocMainGrid: TfmDocMainGrid;

implementation

uses tsvAdjust;

{$R *.DFM}

var
  TempStr: string;
const
  tbDocum='Docum';
  fmtDocumentCaption='%s - %s';

procedure TfmDocMainGrid.FormCreate(Sender: TObject);
begin
 try
  inherited;
  
  MemTable:=TRxMemoryData.Create(nil);

  Grid:=TNewdbGrid.Create(self);
  Grid.Parent:=pnGrid;
  Grid.Align:=alClient;
  Grid.Width:=pnGrid.Width-pnBut.Width;
  Grid.DataSource:=ds;
  Grid.Name:='Grid';
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
 // Grid.Options:=Grid.Options+[dgMultiSelect];
  Grid.RowSizing:=false;
  Grid.ReadOnly:=true;
  Grid.OnKeyDown:=FormKeyDown;
  Grid.OnTitleClick:=GridTitleClick;
  Grid.OnTitleClickWithSort:=GridTitleClickWithSort;
  Grid.OnDblClick:=GridDblClick;
  Grid.OnKeyPress:=GridKeyPress;
  Grid.TabOrder:=1;
  Grid.PopupMenu:=pmGrid;
  pnBut.TabOrder:=2;

  pcMain.ActivePageIndex:=0;
  
  ds.DataSet:=MemTable;

  bibChange.Enabled:=false;
  bibAdd.Enabled:=false;
  bibDel.Enabled:=false;
  bibAdjust.Enabled:=false;

  ListDeleteRecords:=TList.Create;

  SetPositionEdSearch;

 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
//  TControl(edSearch).Align:=alClient;
end;

procedure TfmDocMainGrid.bibCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmDocMainGrid.FormDestroy(Sender: TObject);
begin
 try
  inherited;
  _OnVisibleInterface(FhInterfaceHead,false);
  CloseAllSql(Self);
  Grid.Free;
  MemTable.Free;
  ListDeleteRecords.Free;
 except
  raise;
 end; 
end;

procedure TfmDocMainGrid.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=LastKey then begin
   LastKey:=0;
   exit;
  end;
  if Shift=[] then begin
   case Key of
    VK_F2: begin
     if pcMain.ActivePage=tsData then
      if bibAdd.Enabled then
        bibAdd.Click;
    end;
    VK_F3: begin
     if pcMain.ActivePage=tsData then
      if bibChange.Enabled then
        bibChange.Click;
    end;
    VK_F4: begin
     if pcMain.ActivePage=tsData then
      if bibDel.Enabled then
       bibDel.Click;
    end;
    VK_F5: begin
    end;
    VK_F6: begin
     if pcMain.ActivePage=tsData then
      if bibView.Enabled then
       bibView.Click;
    end;
    VK_F7: begin
    end;
    VK_F8: begin
     if pcMain.ActivePage=tsData then
      if bibAdjust.Enabled then
       bibAdjust.Click;
    end;
    VK_UP,VK_DOWN: begin
    end;
    VK_F9: begin
     if pcMain.ActivePage=tsData then
      edSearch.SetFocus;
    end;
   end;
  end;
  inherited;
  LastKey:=Key;
end;

procedure TfmDocMainGrid.MR(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TfmDocMainGrid.FormResize(Sender: TObject);
begin
  SetPositionEdSearch;
end;

procedure TfmDocMainGrid.SetPositionEdSearch;
begin
  edSearch.Width:=pnGrid.Width-edSearch.Left;
end;

procedure TfmDocMainGrid.bibAdjustClick(Sender: TObject);
begin
  SetAdjust(Grid.Columns,nil);
end;

procedure TfmDocMainGrid.ViewCount;
begin
 if MemTable.Active then
  lbCount.Caption:=ViewCountTextDocument+inttostr(MemTable.RecordCount);
end;

procedure TfmDocMainGrid.ActiveQuery(CheckPerm: Boolean);
begin
  MemTable.Active:=false;
  if CheckPerm then begin
   CheckPermissionRecord;
   if not CheckPermissionHead then exit;
  end;
end;

procedure TfmDocMainGrid.GridTitleClick(Column: TColumn);
begin
end;

procedure TfmDocMainGrid.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
begin
end;

procedure TfmDocMainGrid.GridDblClick(Sender: TObject);
begin
end;

function TfmDocMainGrid.CheckPermissionHead: Boolean;
var
  isPerm: Boolean;
begin
  isPerm:=_isPermissionOnInterface(FhInterfaceHead,ttiaView);
  case TypeOperation of
    todAdd: isPerm:=isPerm and _isPermissionOnInterface(FhInterfaceHead,ttiaAdd);
    todChange: isPerm:=isPerm and _isPermissionOnInterface(FhInterfaceHead,ttiaChange);
  end;
  bibOk.Enabled:=isPerm;
  Result:=isPerm;
end;

function TfmDocMainGrid.CheckPermissionRecord: Boolean;
var
  isPerm: Boolean;
begin
  isPerm:=_isPermissionOnInterface(FhInterfaceRecord,ttiaView);
  bibChange.Enabled:=isPerm and _isPermissionOnInterface(FhInterfaceRecord,ttiaChange) and not (TypeOperation=todView);
  bibAdd.Enabled:=isPerm and _isPermissionOnInterface(FhInterfaceRecord,ttiaAdd) and not (TypeOperation=todView);
  bibDel.Enabled:=isPerm and _isPermissionOnInterface(FhInterfaceRecord,ttiaDelete) and not (TypeOperation=todView);
  bibView.Enabled:=isPerm;
  bibAdjust.Enabled:=isPerm;
  Result:=isPerm;
end;

function TfmDocMainGrid.CheckPermissionPrint: Boolean;
begin
  Result:=false;
end;

function TfmDocMainGrid.CheckPermissionConduct: Boolean;
begin
  Result:=false;
end;

procedure TfmDocMainGrid.LoadGridProp(ClsName: string; Grd: TDBGrid);
var
  def: string;
  tmps: string;
  ms: TMemoryStream;
begin
  if Grd=nil then exit;
  ms:=TMemoryStream.Create;
  try
    Grd.Columns.SaveToStream(ms);
    SetLength(def,ms.Size);
    Move(ms.Memory^,Pointer(def)^,ms.Size);
    tmps:=HexStrToStr(ReadParam(ClsName,Grd.Name+'Columns',StrToHexStr(def)));
    ms.Clear;
    ms.SetSize(Length(tmps));
    Move(Pointer(tmps)^,ms.Memory^,Length(tmps));
    try
     Grd.Columns.LoadFromStream(ms);
    except
    end;
  finally
    ms.Free;
  end;
end;

procedure TfmDocMainGrid.LoadFromIni;

  procedure LoadColumnSort;
  begin

  end;

begin
  try
    inherited;
    LoadGridProp(ClassName,TDBGrid(Grid));
    LoadColumnSort;
  except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

procedure TfmDocMainGrid.SaveGridProp(ClsName: string; Grd: TDBGrid);
var
  tmps: string;
  ms: TMemoryStream;
begin
  if Grd=nil then exit;
  ms:=TMemoryStream.Create;
  try
    Grd.Columns.SaveToStream(ms);
    SetLength(tmps,ms.Size);
    Move(ms.Memory^,Pointer(tmps)^,ms.Size);
    WriteParam(ClsName,Grd.Name+'Columns',StrToHexStr(tmps));
  finally
    ms.Free;
  end;
end;

procedure TfmDocMainGrid.SaveToIni;

  procedure SaveColumnSort;
  begin
  end;

begin
  try
    inherited;
    SaveGridProp(ClassName,TDBGrid(Grid));
    SaveColumnSort;
  except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

function TfmDocMainGrid.GetTypeOperationName(ATypeOperation: TTypeOperationDocument): string;
begin
  Result:='';
  case ATypeOperation of
    todAdd: Result:='добавление';
    todChange: Result:='изменение';
    todView: Result:='просмотр';
  end;
end;

procedure TfmDocMainGrid.InitMdiChildParams(hInterfaceHead,hInterfaceRecord: THandle; Param: PParamDocumentInterface);
begin
//  _OnVisibleInterface(hInterfaceHead,true);
  FhInterfaceHead:=hInterfaceHead;
  FhInterfaceRecord:=hInterfaceRecord;
  TypeOperation:=Param.TypeOperation;
  case TypeOperation of
    todAdd: begin
      TypeDocId:=Param.Head.TypeDocId;
      bibPrint.Enabled:=CheckPermissionPrint;
      bibConduct.Enabled:=CheckPermissionConduct;
      bibOk.OnClick:=AddClick;
      bibOk.Visible:=true;
      bibClose.Cancel:=true;
      bibClose.Caption:=CaptionCancel;
    end;
    todChange: begin
      DocumentId:=Param.Head.DocumentId;
      DocumentNumber:=Param.Head.DocumentNumber;
      edNumber.Text:=inttostr(DocumentNumber);
      DocumentDate:=Param.Head.DocumentDate;
      dtpDate.Date:=DocumentDate;
      DocumentPrefix:=Param.Head.DocumentPrefix;
      DocumentSufix:=Param.Head.DocumentSufix;
      TypeDocId:=Param.Head.TypeDocId;
      bibPrint.Enabled:=CheckPermissionPrint;
      bibConduct.Enabled:=CheckPermissionConduct;
      bibOk.OnClick:=ChangeClick;
      bibOk.Visible:=true;
      bibClose.Cancel:=true;
      bibClose.Caption:=CaptionCancel;
    end;
    todView: begin
      DocumentId:=Param.Head.DocumentId;
      DocumentNumber:=Param.Head.DocumentNumber;
      edNumber.Text:=inttostr(DocumentNumber);
      DocumentDate:=Param.Head.DocumentDate;
      dtpDate.Date:=DocumentDate;
      DocumentPrefix:=Param.Head.DocumentPrefix;
      DocumentSufix:=Param.Head.DocumentSufix;
      TypeDocId:=Param.Head.TypeDocId;
      bibNumber.Enabled:=false;
      bibConduct.Visible:=false;
      bibOk.OnClick:=nil;
      bibOk.Visible:=false;
      bibClose.Cancel:=true;
      bibClose.Caption:=CaptionClose;
    end;
  end;
  Caption:=Format(fmtDocumentCaption,[Caption,GetTypeOperationName(TypeOperation)]);
  ActiveQuery(true);
  FormStyle:=fsMDIChild;
  if WindowState=wsMinimized then begin
    WindowState:=wsNormal;
  end;
  BringToFront;
  Show;
  ChangeFlag:=false;
end;

procedure TfmDocMainGrid.ShowingChanged;
begin
  SetPositionEdSearch;
end;

procedure TfmDocMainGrid.edSearchKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
 OldAfterScroll: TDataSetNotifyEvent;
begin
 try
  if not isValidKey(Char(Key))or(Key=VK_BACK) then exit;
  if MemTable.IsEmpty then exit;
  if grid.SelectedField=nil then exit;
  Screen.Cursor:=crHourGlass;
  OldAfterScroll:=MemTable.AfterScroll;
  MemTable.AfterScroll:=nil;
  try
   MemTable.Locate(grid.SelectedField.FullName,Trim(edSearch.Text),[loCaseInsensitive,loPartialKey]);
  finally
   MemTable.AfterScroll:=OldAfterScroll;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmDocMainGrid.edSearchKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_UP,VK_DOWN: Grid.SetFocus;
  end;
  FormKeyDown(Sender,Key,Shift);
end;

procedure TfmDocMainGrid.FillGridPopupMenu;

  procedure CreateMenuItem(bt: TButton);
  var
    mi: TMenuItem;
  begin
    mi:=TMenuItem.Create(nil);
    if bt<>nil then begin
     mi.Caption:=bt.Caption;
     mi.Hint:=bt.Hint;
     mi.OnClick:=bt.OnClick;
     mi.Visible:=bt.Visible and bt.Showing;
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

procedure TfmDocMainGrid.InitModalParams(hInterfaceHead,hInterfaceRecord: THandle; Param: PParamDocumentInterface);
begin
  FhInterfaceHead:=hInterfaceHead;
  FhInterfaceRecord:=hInterfaceRecord;
  TypeOperation:=Param.TypeOperation;
  case TypeOperation of
    todAdd: begin
      TypeDocId:=Param.Head.TypeDocId;
      bibPrint.Enabled:=CheckPermissionPrint;
      bibConduct.Enabled:=CheckPermissionConduct;
      bibOk.OnClick:=AddClick;
      bibOk.Visible:=true;
      bibClose.Cancel:=true;
      bibClose.Caption:=CaptionCancel;
    end;
    todChange: begin
      DocumentId:=Param.Head.DocumentId;
      DocumentNumber:=Param.Head.DocumentNumber;
      edNumber.Text:=inttostr(DocumentNumber);
      DocumentDate:=Param.Head.DocumentDate;
      dtpDate.Date:=DocumentDate;
      DocumentPrefix:=Param.Head.DocumentPrefix;
      DocumentSufix:=Param.Head.DocumentSufix;
      TypeDocId:=Param.Head.TypeDocId;
      bibPrint.Enabled:=CheckPermissionPrint;
      bibConduct.Enabled:=CheckPermissionConduct;
      bibOk.OnClick:=ChangeClick;
      bibOk.Visible:=true;
      bibClose.Cancel:=true;
      bibClose.Caption:=CaptionCancel;
    end;
    todView: begin
      DocumentId:=Param.Head.DocumentId;
      DocumentNumber:=Param.Head.DocumentNumber;
      edNumber.Text:=inttostr(DocumentNumber);
      DocumentDate:=Param.Head.DocumentDate;
      dtpDate.Date:=DocumentDate;
      DocumentPrefix:=Param.Head.DocumentPrefix;
      DocumentSufix:=Param.Head.DocumentSufix;
      TypeDocId:=Param.Head.TypeDocId;
      bibNumber.Enabled:=false;
      bibConduct.Visible:=false;
      bibOk.OnClick:=nil;
      bibOk.Visible:=false;
      bibClose.Cancel:=true;
      bibClose.Caption:=CaptionClose;
    end;
  end;
  Caption:=Format(fmtDocumentCaption,[Caption,GetTypeOperationName(TypeOperation)]);
  ActiveQuery(true);
  BorderIcons:=BorderIcons-[biMinimize];
  WindowState:=wsNormal;
  ChangeFlag:=false;
end;

procedure TfmDocMainGrid.ReturnParamsFromDataSetAndGrid(DataSet: TDataSet; Grd: TNewDbGrid; Param: PParamDocumentInterface);
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

  FillParamDocumentInterfaceFromDataSet(DataSet,Param,Bookmarks);
end;

procedure TfmDocMainGrid.ReturnModalParams(Param: PParamDocumentInterface);
begin
  ReturnParamsFromDataSetAndGrid(MemTable,Grid,Param);
end;

procedure TfmDocMainGrid.SetInterfaceHandles(ValueHead,ValueRecord: THandle);
begin
  FhInterfaceHead:=ValueHead;
  FhInterfaceRecord:=ValueRecord;
end;

procedure TfmDocMainGrid.pmGridPopup(Sender: TObject);
begin
  FillGridPopupMenu;
end;

procedure TfmDocMainGrid.GridKeyPress(Sender: TObject; var Key: Char);
begin
  if isValidKey(Key) then begin
   edSearch.SetFocus;
   edSearch.Text:=Key;
   edSearch.SelStart:=Length(edSearch.Text);
   if Assigned(edSearch.OnKeyPress) then
    edSearch.OnKeyPress(Sender,Key);
  end;
end;

function TfmDocMainGrid.CheckFieldsFill: Boolean;
begin
  Result:=false;
end;

function TfmDocMainGrid.CheckDataFill: Boolean;
var
  but: Integer;
begin
  Result:=MemTable.Active and not MemTable.IsEmpty;
  if not Result then begin
   but:=MessageDlg(ConstDocCheckDataFill,mtWarning,[mbYes,mbNo],0);
   if but=mrNo then begin
     pcMain.ActivePage:=tsData;
     if edSearch.CanFocus then edSearch.SetFocus;
     exit;
   end else Result:=true;
  end;
end;

procedure TfmDocMainGrid.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not CheckDataFill then exit;
  if not AddHeadAndRecord then exit;
  ModalResult:=mrOk;
  if not (fsModal in FormState) then Close;
end;

procedure TfmDocMainGrid.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not CheckDataFill then exit;
   if not ChangeHeadAndRecord then exit;
  end;
  ModalResult:=mrOk;
  if not (fsModal in FormState) then Close;
end;

function TfmDocMainGrid.AddHeadAndRecord: Boolean;
begin
  Result:=false;
end;

function TfmDocMainGrid.ChangeHeadAndRecord: Boolean;
begin
  Result:=false;
end;

procedure TfmDocMainGrid.bibNumberClick(Sender: TObject);
begin
  edNumber.Text:='';
  DocumentPrefix:='';
  DocumentSufix:='';
  ChangeFlag:=true;
end;

procedure TfmDocMainGrid.edNumberKeyPress(Sender: TObject; var Key: Char);
begin
  if (not (Key in ['0'..'9']))and((Integer(Key)<>VK_Back)) then Key:=#0;
end;

procedure TfmDocMainGrid.edNumberChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmDocMainGrid.dtpDateChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmDocMainGrid.RefreshNeededInterface;
begin
end;

function TfmDocMainGrid.AddToJournalDocument(IBDB: TIBDatabase): Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id: string;
  CU: TInfoConnectUser;
  dt: TDateTime;
begin
 Result:=false;
 try
  qr:=TIBQuery.Create(nil);
  try

    FillChar(CU,SizeOf(TInfoConnectUser),0);
    _GetInfoConnectUser(@CU);
    dt:=_GetDateTimeFromServer;

    qr.Database:=IBDB;
    qr.ParamCheck:=false;
    qr.Transaction:=ibtran;
    qr.Transaction.Active:=true;
    id:=inttostr(GetGenId(IBDB,tbDocum,1));
    DocumentId:=Strtoint(id);
    
    sqls:='Insert into '+tbDocum+
          ' (docum_id,typedoc_id,num,prefix,sufix,datedoc,whoadd,dateadd,whochange,datechange) values'+
          ' ('+id+
          ','+inttostr(TypeDocId)+
          ','+QuotedStr(Trim(edNumber.Text))+
          ','+QuotedStr(Trim(DocumentPrefix))+
          ','+QuotedStr(Trim(DocumentSufix))+
          ','+QuotedStr(DateToStr(dtpDate.Date))+
          ','+inttostr(CU.User_id)+
          ','+QuotedStr(DateTimeToStr(dt))+
          ','+inttostr(CU.User_id)+
          ','+QuotedStr(DateTimeToStr(dt))+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;

    Result:=true;
  finally
    qr.Free;
  end;
 except
    on E: EIBInterBaseError do begin
        TempStr:=TranslateIBError(E.Message);
        ShowErrorEx(TempStr);
        Assert(false,TempStr);
    end;
    {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

function TfmDocMainGrid.ChangeJournalDocument(IBDB: TIBDatabase): Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id: String;
  CU: TInfoConnectUser;
  dt: TDateTime;
begin
 Result:=false;
 try
  qr:=TIBQuery.Create(nil);
  try

    FillChar(CU,SizeOf(TInfoConnectUser),0);
    _GetInfoConnectUser(@CU);
    dt:=_GetDateTimeFromServer;

    id:=inttostr(DocumentId);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbDocum+
          ' set num='+QuotedStr(Trim(edNumber.Text))+
          ', prefix='+QuotedStr(Trim(DocumentPrefix))+
          ', sufix='+QuotedStr(Trim(DocumentSufix))+
          ', typedoc_id='+inttostr(TypeDocId)+
          ', datedoc='+QuotedStr(DateToStr(dtpDate.Date))+
          ', whochange='+inttostr(CU.User_id)+
          ', datechange='+QuotedStr(DateTimeToStr(dt))+
          ' where docum_id='+id;
    qr.SQL.Add(sqls);
    qr.ExecSQL;

    Result:=true;
  finally
    qr.Free;
  end;
 except
  on E: EIBInterBaseError do begin
    TempStr:=TranslateIBError(E.Message);
    ShowErrorEx(TempStr);
    Assert(false,TempStr);
  end;
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message);{$ENDIF}
 end;
end;

procedure TfmDocMainGrid.AddOrChangeRecord;
begin
end;

procedure TfmDocMainGrid.DeleteRecords;
begin
end;

procedure TfmDocMainGrid.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  but: Integer;  
begin
  if ModalResult=mrOk then exit;
  if ChangeFlag and (ModalResult=mrCancel) then begin
    case TypeOperation of
      todAdd,todChange: begin
       but:=ShowQuestionEx(ConstEditRbChangeCloseQuery);
       CanClose:=(but=mrYes);
      end;
    end;
  end;
end;

end.



