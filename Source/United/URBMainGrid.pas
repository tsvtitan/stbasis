unit URBMainGrid;

interface

{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, DBCtrls, Grids, DBGrids, Buttons,
  tsvDbGrid, IBCustomDataSet, IBQuery, IBTable,
  ImgList, Db, menus, IBDatabase, UMainUnited, IBEvents, IBSQLMonitor,
  IBUpdateSQL, UMainForm, tsvDbOrder, tsvDbFilter, XPMan;

type
  TTypeSetValuesToEditForm=(tefNone,tefNextRecord,tefPriorRecord);

  TfmRBMainGrid=class;
  TfmRbMainGridClass=class of TfmRBMainGrid;

  TfmRBMainGrid = class(TfmMainForm,IAdditionalRBForm)
    pnBackGrid: TPanel;
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
    pnGrid: TPanel;
    pmGrid: TPopupMenu;
    IBUpd: TIBUpdateSQL;
    hbfsgh1: TMenuItem;
    bibPreview: TButton;
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
    procedure bibFilterClick(Sender: TObject);
    procedure pmGridPopup(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibPreviewClick(Sender: TObject);
  private
    LastKey: Word;
    FRecordCount: Integer;
    FDefaultOrders: TtsvDbOrders;
    FFilters: TtsvDbFilters;
    FTypeEdit: TTypeEditRBook;
    FDefaultGridColumns: TDbGridColumns;
    procedure FillMenus(Items: TMenuItem);
    procedure miOnAdvancedDrawItem(Sender: TObject; ACanvas: TCanvas;
                                     ARect: TRect; State: TOwnerDrawState);

  protected
    FhInterface: THandle;
//    DefLastOrderStr: string;
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
    function GetFilterStringNoRemoved: string; dynamic;
    function GetSql: string; dynamic;
    function GetLastOrderStr: string;
    procedure FillGridPopupMenu; dynamic;
    procedure SetPositionEdSearch; virtual;
    procedure ShowingChanged; override;
    function CheckDataSelect: Boolean; dynamic;

    function GetDefaultOrdersName: string; dynamic;
    function GetFiltersName: string; dynamic;

    function SetValuesToEditForm(TypeSetValuesToEditForm: TTypeSetValuesToEditForm):Boolean; dynamic;

    procedure PrintPreview; dynamic;
    procedure RptExcelPreviewOnTerminate(Sender: TObject);
    procedure InternalAddClick; virtual;
  public
    Database: TIbDatabase;
    EditForm: TForm;
    WhereString: string;
    WhereStringNoRemoved: string;
    SQLString: string;
    LastOrderStr: String;
    ViewSelect: Boolean;
    FilterInSide: Boolean;
    isPerm: Boolean;
    Grid: TNewdbGrid;
    FEdit: array of TRBookEdit;

    procedure SaveGridProp(ClsName: string; Grd: TDBGrid); virtual;
    procedure LoadGridProp(ClsName: string; Grd: TDBGrid); virtual;

    procedure SaveDbOrders(ClsName: string; DbOrders: TtsvDbOrders); virtual;
    procedure LoadDbOrders(ClsName: string; DbOrders: TtsvDbOrders); virtual;

    procedure SaveDbFilters(ClsName: string; DbFilters: TtsvDbFilters); virtual;
    procedure LoadDbFilters(ClsName: string; DbFilters: TtsvDbFilters); virtual;

    procedure MR(Sender: TObject);
    procedure SetInterfaceHandle(Value: THandle);
    procedure ReturnModalParamsFromDataSetAndGrid(DataSet: TDataSet; Grd: TNewDbGrid; Param: PParamRBookInterface);
    procedure InitMdiChildParams(hInterface: THandle; Param: PParamRBookInterface);dynamic;
    procedure InitModalParams(hInterface: THandle; Param: PParamRBookInterface); dynamic;
    procedure ReturnModalParams(Param: PParamRBookInterface); dynamic;
    procedure SetLastOrderFromTypeSort(FieldName: string; TypeSort: TTypeColumnSort);

    function LocateByRefreshParam(Param: PParamRefreshRBookInterface): Boolean; dynamic;
    function Locate(const KeyFields: string; const KeyValues: Variant; Options: TLocateOptions): Boolean; dynamic;

    function GetLocateValueByName(Param: PParamRBookInterface; LocateName: string): Variant;
    function NextRecord: Boolean; dynamic;
    function PriorRecord: Boolean; dynamic;
    function DeleteRecord(const Message,TableName,FieldName,Value: string): Boolean; dynamic;

    property RecordCount: Integer read FRecordCount;
    property DefaultOrders: TtsvDbOrders read FDefaultOrders;
    property Filters: TtsvDbFilters read FFilters;
    property DefaultGridColumns: TDbGridColumns read FDefaultGridColumns;
  end;

var
  fmRBMainGrid: TfmRBMainGrid;


implementation

uses tsvAdjust, IB, ActiveX, comobj, URptThread, Excel97;

type
  TRptExcelPreview=class(TRptExcelThread)
  private
    FCurPB: THandle;
    procedure FreeCurPB;
    procedure DisableControls;
    procedure EnableControls;
  public
    fmParent: TfmRBMainGrid;
    procedure Execute;override;
    destructor Destroy;override;
  end;

var
  RptExcelPreview: TRptExcelPreview;

var
  TempStr: string;

{$R *.DFM}

{ TRptExcelThreadPms_Price }

destructor TRptExcelPreview.Destroy;
begin
  inherited;
  FreeCurPB;
end;

procedure TRptExcelPreview.FreeCurPB;
begin
  _FreeProgressBar(FCurPB);
end;

procedure TRptExcelPreview.DisableControls;
begin
  fmParent.Mainqr.DisableControls;
end;

procedure TRptExcelPreview.EnableControls;
begin
  fmParent.Mainqr.EnableControls;
end;

procedure TRptExcelPreview.Execute;

  function GetNumberFormatLocal(Field: TField; Default: String): String;
  begin
    Result:=Default;
    case Field.DataType of
      ftString,ftUnknown,ftWideString,ftBCD: Result:='@';
      ftSmallint,ftInteger,ftWord,ftLargeint,ftAutoInc,ftBytes: Result:='0';
      ftFloat: Result:='0.00';
//      ftDate: Result:='dd/mm/yy';
//      ftTime: Result:='h:mm:ss;@';
//      ftDateTime: Result:='dd/mm/yy h:mm:ss;@';
//      ftCurrency: Result:='#,##0.00$';
    end;
  end;

  procedure Preview;
  var
    b: TBookmark;
    i: Integer;
    cl: TColumn;
    ListColumn: TList;
    Data: Variant;
    incy: Integer;
    TCPB: TCreateProgressBar;
    TSPBS: TSetProgressBarStatus;
    pbh: THandle;
    s: string;
    Wb,Sh: OleVariant;
    OldAfterScroll: TDataSetNotifyEvent;
  begin
    Screen.Cursor:=crHourGlass;
    ListColumn:=TList.Create;
    Synchronize(DisableControls);
    OldAfterScroll:=fmParent.Mainqr.AfterScroll;
    fmParent.Mainqr.AfterScroll:=nil;
    b:=fmParent.Mainqr.GetBookmark;
    try
      Wb:=Excel.WorkBooks.Add;
      Sh:=Wb.Sheets.Item[1];
      Sh.Name:=Copy(fmParent.Caption,1,31);
      for i:=0 to fmParent.grid.Columns.Count-1 do begin
        cl:=fmParent.grid.Columns.Items[i];
        if (cl.Field<>nil)and(cl.Visible) then begin
          ListColumn.Add(cl);
          Sh.Cells[1,ListColumn.Count].Value:=cl.Title.Caption;
          Sh.Cells[1,ListColumn.Count].Interior.Color:=ColorToRGB(cl.Title.Color);
          Sh.Cells[1,ListColumn.Count].Font.Name:=cl.Title.Font.Name;
          Sh.Cells[1,ListColumn.Count].Font.Color:=ColorToRGB(cl.Title.Font.Color);
          Sh.Cells[1,ListColumn.Count].Font.Size:=cl.Title.Font.Size;
          Sh.Cells[1,ListColumn.Count].Font.Bold:=fsBold in cl.Title.Font.Style;
          Sh.Cells[1,ListColumn.Count].Font.Italic:=fsItalic in cl.Title.Font.Style;
          Sh.Cells[1,ListColumn.Count].Columns.ColumnWidth:=cl.Width/fmParent.Grid.Canvas.TextWidth('H');
        end;
      end;

      fmParent.Mainqr.FetchAll;
      FillChar(TCPB,SizeOf(TCPB),0);
      Data:=VarArrayCreate([1,fmParent.Mainqr.RecordCount,1,ListColumn.Count],varVariant);
      fmParent.Mainqr.First;
      incy:=1;
      TCPB.Min:=1;
      TCPB.Max:=fmParent.Mainqr.RecordCount;
      TCPB.Color:=clBlue;
      pbh:=_CreateProgressBar(@TCPB);
      FCurPB:=pbh;

      while not fmParent.Mainqr.Eof do begin
        for i:=0 to ListColumn.Count-1 do begin
          Data[incy,i+1]:=TColumn(ListColumn.Items[i]).Field.Value;
        end;
        FillChar(TSPBS,SizeOf(TSPBS),0);
        TSPBS.Progress:=incy;
        TSPBS.Max:=TCPB.Max;
        _SetProgressBarStatus(pbh,@TSPBS);
        inc(incy);
        fmParent.Mainqr.Next;
      end;

      Sh.Range[Sh.Cells[2,1],Sh.Cells[fmParent.Mainqr.RecordCount+1,ListColumn.Count]].Value:=Data;

      if not fmParent.Mainqr.IsEmpty then begin
        for i:=0 to ListColumn.Count-1 do begin
          cl:=TColumn(ListColumn.Items[i]);
          s:=Sh.Range[Sh.Cells[2,i+1],Sh.Cells[2,i+1]].NumberFormat;
          Sh.Range[Sh.Cells[2,i+1],Sh.Cells[fmParent.Mainqr.RecordCount+1,i+1]].NumberFormat:=GetNumberFormatLocal(cl.Field,s);
          Sh.Range[Sh.Cells[2,i+1],Sh.Cells[fmParent.Mainqr.RecordCount+1,i+1]].Font.Name:=cl.Font.Name;
          Sh.Range[Sh.Cells[2,i+1],Sh.Cells[fmParent.Mainqr.RecordCount+1,i+1]].Font.Color:=ColorToRGB(cl.Font.Color);
          Sh.Range[Sh.Cells[2,i+1],Sh.Cells[fmParent.Mainqr.RecordCount+1,i+1]].Font.Size:=cl.Font.Size;
          Sh.Range[Sh.Cells[2,i+1],Sh.Cells[fmParent.Mainqr.RecordCount+1,i+1]].Font.Bold:=fsBold in cl.Font.Style;
          Sh.Range[Sh.Cells[2,i+1],Sh.Cells[fmParent.Mainqr.RecordCount+1,i+1]].Font.Italic:=fsItalic in cl.Font.Style;
        end;
      end;
    
    //    Sh.Range[Sh.Cells[1,1],Sh.Cells[Mainqr.RecordCount+1,ListColumn.Count]].Columns.AutoFit;

      Sh.Activate;
    finally
      fmParent.Mainqr.GotoBookmark(b);
      fmParent.Mainqr.AfterScroll:=OldAfterScroll;
      Synchronize(EnableControls);
      ListColumn.Free;
      Synchronize(FreeCurPB);
      Screen.Cursor:=crDefault;
    end;
  end;


var
  TCLI: TCreateLogItem;
begin
   if CoInitialize(nil)<>S_OK then exit;
   try
     try
       if not CreateReport(false) then exit;
       Preview;
     except
      {$IFDEF DEBUG}
        on E: Exception do begin
         try
           TCLI.ViewLogItemProc:=nil;
           TCLI.TypeLogItem:=tliError;
           TCLI.Text:=PChar(E.message);
           _CreateLogItem(@TCLI);
           Assert(false,E.message);
         except
           Application.HandleException(nil);
         end;
        end;
      {$ENDIF}
     end;
   finally
     if not VarIsEmpty(Excel) then begin
       if not VarIsEmpty(Excel.ActiveWindow) then
         Excel.ActiveWindow.WindowState:=xlMaximized;
       Excel.Visible:=true;
       Excel.WindowState:=xlMaximized;
       Excel.WindowState:=xlMaximized;
     end;
     CoUninitialize;
     DoTerminate;
   end;
end;   

{ TfmRBMainGrid }

procedure TfmRBMainGrid.FormCreate(Sender: TObject);
begin
 try
  inherited;

  FDefaultGridColumns:=TDBGridColumns.Create(nil,TColumn);
  FDefaultOrders:=TtsvDbOrders.Create(Self);
  FFilters:=TtsvDbFilters.Create(Self);
  FFilters.TypeFilter:=_GetOptions.TypeFilter;

  ViewSelect:=not _GetOptions.isEditRBOnSelect;

  Grid:=TNewdbGrid.Create(self);
  Grid.Parent:=pnGrid;
  Grid.Align:=alClient;
  Grid.Width:=pnGrid.Width-pnSQL.Width;
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
  Grid.RowSizing:=true;
  Grid.ReadOnly:=true;
  Grid.OnKeyDown:=FormKeyDown;
  Grid.OnTitleClick:=GridTitleClick;
  Grid.OnTitleClickWithSort:=GridTitleClickWithSort;
  Grid.OnDblClick:=GridDblClick;
  Grid.OnKeyPress:=GridKeyPress;
  Grid.TabOrder:=1;
  Grid.PopupMenu:=pmGrid;
  pnBut.TabOrder:=2;
  pnBut.Visible:=_GetOptions.VisibleEditPanel;
  pnFind.Visible:=_GetOptions.VisibleFindPanel;


  SetPositionEdSearch;



 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBMainGrid.bibCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmRBMainGrid.FormDestroy(Sender: TObject);
begin
 try
  inherited;
  FreeAndNil(RptExcelPreview);
  _OnVisibleInterface(FhInterface,false);
  CloseAllSql(Self);
  FFilters.Free;
  FDefaultOrders.Free;
  Grid.Free;
  FDefaultGridColumns.Free;
 except
  raise;
 end;
end;

procedure TfmRBMainGrid.FormKeyDown(Sender: TObject; var Key: Word;
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
    VK_F10: begin
      if bibPreview.Enabled then
       bibPreview.Click;
    end;
    VK_UP,VK_DOWN: begin
//      Grid.SetFocus;
    end;
    VK_F9: begin
      edSearch.SetFocus;
    end;
   end;
  end; 
  inherited;
  LastKey:=Key;
end;

function TfmRBMainGrid.CheckDataSelect: Boolean;
begin
  Result:=Mainqr.Active and not Mainqr.IsEmpty;
end;

procedure TfmRBMainGrid.MR(Sender: TObject);
begin
  if CheckDataSelect then
    ModalResult:=mrOk;
end;

procedure TfmRBMainGrid.FormResize(Sender: TObject);
begin
  SetPositionEdSearch;
end;

procedure TfmRBMainGrid.SetPositionEdSearch;
begin
  edSearch.Width:=pnGrid.Width-edSearch.Left-pnGrid.BorderWidth;
end;

procedure TfmRBMainGrid.bibAdjustClick(Sender: TObject);
begin

  if SetAdjust(Grid.Columns,FDefaultOrders,FDefaultGridColumns) then begin
    LastOrderStr:=PrepearOrderString(FDefaultOrders.GetOrderString); 
    if bibRefresh.Enabled then
      bibRefresh.Click;
  end;
end;

procedure TfmRBMainGrid.ViewCount;
begin
 if MainQr.Active then begin
   FRecordCount:=GetRecordCount(Mainqr);
   lbCount.Caption:=ViewCountText+inttostr(FRecordCount);
 end; 
end;

procedure TfmRBMainGrid.ActiveQuery(CheckPerm: Boolean);
begin
end;

procedure TfmRBMainGrid.SetImageFilter(FilterOn: Boolean);
begin
  if FilterOn or (Trim(WhereString)<>'') then begin
    bibfilter.Font.Color:=_GetOptions.RbFilterColor;
  end else begin
    bibfilter.Font.Color:=clWindowText;
  end;
  lbCount.Font.Color:=bibfilter.Font.Color;
end;

procedure TfmRBMainGrid.GridTitleClick(Column: TColumn);
begin
end;

procedure TfmRBMainGrid.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
begin
end;

procedure TfmRBMainGrid.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
    bibChange.Click;
  end else bibView.Click;
end;

function TfmRBMainGrid.CheckPermission: Boolean;
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
   bibPreview.Enabled:=isPerm and ExistsExcel;
  end else begin
   pnSQL.Visible:=false;
  end;
  Result:=isPerm;
  
end;

procedure TfmRBMainGrid.LoadGridProp(ClsName: string; Grd: TDBGrid);
var
  def: string; 
  tmps: string;
  ms: TMemoryStream;
begin
  if Grd=nil then exit;
  ms:=TMemoryStream.Create;
  try
    FDefaultGridColumns.Assign(Grd.Columns);
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

procedure TfmRBMainGrid.LoadDbOrders(ClsName: string; DbOrders: TtsvDbOrders);
var
  def: string;
  tmps: string;
  ms: TMemoryStream;
begin
  if DbOrders=nil then exit;
  ms:=TMemoryStream.Create;
  try
    DbOrders.SaveToStream(ms);
    SetLength(def,ms.Size);
    Move(ms.Memory^,Pointer(def)^,ms.Size);
    tmps:=HexStrToStr(ReadParam(ClsName,GetDefaultOrdersName,StrToHexStr(def)));
    ms.Clear;
    ms.SetSize(Length(tmps));
    Move(Pointer(tmps)^,ms.Memory^,Length(tmps));
    try
      DbOrders.LoadFromStream(ms);
    except
    end;
  finally
    LastOrderStr:=PrepearOrderString(DefaultOrders.GetOrderString);
     ms.Free;
  end;
end;

procedure TfmRBMainGrid.LoadDbFilters(ClsName: string; DbFilters: TtsvDbFilters);
var
  def: string;
  tmps: string;
  ms: TMemoryStream;
begin
  if DbFilters=nil then exit;
  ms:=TMemoryStream.Create;
  try
    DbFilters.TypeFilter:=_GetOptions.TypeFilter;
    DbFilters.SaveToStream(ms);
    SetLength(def,ms.Size);
    Move(ms.Memory^,Pointer(def)^,ms.Size);
    tmps:=HexStrToStr(ReadParam(ClsName,GetFiltersName,StrToHexStr(def)));
    ms.Clear;
    ms.SetSize(Length(tmps));
    Move(Pointer(tmps)^,ms.Memory^,Length(tmps));
    try
      DbFilters.LoadFromStream(ms);
      DbFilters.TypeFilter:=_GetOptions.TypeFilter;
    except
    end;
  finally
    ms.Free;
  end;
end;

procedure TfmRBMainGrid.LoadFromIni;

  procedure LoadColumnSort;
  begin

  end;

begin
  try
    inherited;
    LoadGridProp(ClassName,TDBGrid(Grid));
    LoadDbOrders(ClassName,DefaultOrders);
    LoadDbFilters(ClassName,Filters);
    LoadColumnSort;
    Grid.DefaultRowHeight:=ReadParam(ClassName,'GridRowHeight',Grid.DefaultRowHeight);
  except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

procedure TfmRBMainGrid.SaveGridProp(ClsName: string; Grd: TDBGrid);
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

procedure TfmRBMainGrid.SaveDbOrders(ClsName: string; DbOrders: TtsvDbOrders);
var
  tmps: string;
  ms: TMemoryStream;
begin
  if DbOrders=nil then exit;
  ms:=TMemoryStream.Create;
  try
    DbOrders.SaveToStream(ms);
    SetLength(tmps,ms.Size);
    Move(ms.Memory^,Pointer(tmps)^,ms.Size);
    WriteParam(ClsName,GetDefaultOrdersName,StrToHexStr(tmps));
  finally
    ms.Free;
  end;
end;

procedure TfmRBMainGrid.SaveDbFilters(ClsName: string; DbFilters: TtsvDbFilters);
var
  tmps: string;
  ms: TMemoryStream;
begin
  if DbFilters=nil then exit;
  ms:=TMemoryStream.Create;
  try
    DbFilters.TypeFilter:=_GetOptions.TypeFilter;
    DbFilters.SaveToStream(ms);
    SetLength(tmps,ms.Size);
    Move(ms.Memory^,Pointer(tmps)^,ms.Size);
    WriteParam(ClsName,GetFiltersName,StrToHexStr(tmps));
  finally
    ms.Free;
  end;
end;

procedure TfmRBMainGrid.SaveToIni;

  procedure SaveColumnSort;
  begin
  end;

begin
  try
    inherited;
    SaveGridProp(ClassName,TDBGrid(Grid));
    SaveDbOrders(ClassName,DefaultOrders);
    SaveDbFilters(ClassName,Filters);
    SaveColumnSort;
    WriteParam(ClassName,'GridRowHeight',Grid.DefaultRowHeight);
  except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

procedure TfmRBMainGrid.InitMdiChildParams(hInterface: THandle; Param: PParamRBookInterface);
var
  i: Integer;
begin
   _OnVisibleInterface(hInterface,true);
   FhInterface:=hInterface;
   ViewSelect:=false;
   WhereString:=PrepearWhereString(Param.Condition.WhereStr);
   LastOrderStr:=PrepearOrderString(Param.Condition.OrderStr);
   WhereStringNoRemoved:=PrepearWhereStringNoRemoved(Param.Condition.WhereStrNoRemoved);
   SQLString:=Param.SQL.Select;
   FTypeEdit:=Param.Visual.TypeEdit;
   SetLength(FEdit,Length(Param.Edit));
   for i:=0 to Length(Param.Edit)-1 do begin
     FEdit[i].FieldName:=Param.Edit[i].FieldName;
     FEdit[i].FieldValue:=Param.Edit[i].FieldValue;
   end;
   if Trim(LastOrderStr)='' then  LastOrderStr:=PrepearOrderString(FDefaultOrders.GetOrderString);
   if Trim(WhereString)='' then WhereString:=PrepearWhereString(FFilters.GetFilterString);
   ActiveQuery(true);
//   FillMenus(miEdit);
   Locate(Param.Locate.KeyFields,Param.Locate.KeyValues,Param.Locate.Options);
   FormStyle:=fsMDIChild;
   if WindowState=wsMinimized then begin
    WindowState:=wsNormal;
   end;
   BringToFront;
   Show;
   case FTypeEdit of
     terbAdd: InternalAddClick;
   end;
end;

procedure TfmRBMainGrid.ShowingChanged;
begin
  SetPositionEdSearch;
end;

procedure TfmRBMainGrid.edSearchKeyUp(Sender: TObject; var Key: Word;
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

procedure TfmRBMainGrid.edSearchKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_UP,VK_DOWN: Grid.SetFocus;
  end;
  FormKeyDown(Sender,Key,Shift);
end;

procedure TfmRBMainGrid.miOnAdvancedDrawItem(Sender: TObject; ACanvas: TCanvas;
                                             ARect: TRect; State: TOwnerDrawState);
begin
  if Sender is TMenuItem then begin
    if not (odSelected in State) then begin
      ACanvas.Font.Color:=TMenuItem(Sender).Tag;
    end;
  end;
end;

procedure TfmRBMainGrid.FillMenus(Items: TMenuItem);

  function GetShortCutByBut(bt: TButton): TShortCut;
  begin
    Result:=0;
    if bt=bibAdd then Result:=ShortCut(VK_F2,[]);
    if bt=bibChange then Result:=ShortCut(VK_F3,[]);
    if bt=bibDel then Result:=ShortCut(VK_F4,[]);
    if bt=bibRefresh then Result:=ShortCut(VK_F5,[]);
    if bt=bibView then Result:=ShortCut(VK_F6,[]);
    if bt=bibFilter then Result:=ShortCut(VK_F7,[]);
    if bt=bibAdjust then Result:=ShortCut(VK_F8,[]);
  end;

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
     mi.Tag:=bt.Font.Color;
     mi.ShortCut:=GetShortCutByBut(bt);
     mi.OnAdvancedDrawItem:=miOnAdvancedDrawItem;
    end else begin
     mi.Caption:='-';
    end;
    Items.Add(mi);
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
  Items.Clear;
  FillFromControl(pnSQL);
  CreateMenuItem(nil);
  FillFromControl(pnModal);
end;

procedure TfmRBMainGrid.FillGridPopupMenu;
begin
  FillMenus(pmGrid.Items);
end;

procedure TfmRBMainGrid.InitModalParams(hInterface: THandle; Param: PParamRBookInterface);
var
  i: Integer;
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
  SQLString:=Param.SQL.Select;
  FTypeEdit:=Param.Visual.TypeEdit;
  SetLength(FEdit,Length(Param.Edit));
  for i:=0 to Length(Param.Edit)-1 do begin
    FEdit[i].FieldName:=Param.Edit[i].FieldName;
    FEdit[i].FieldValue:=Param.Edit[i].FieldValue;
  end;
  if Trim(LastOrderStr)='' then  LastOrderStr:=PrepearOrderString(FDefaultOrders.GetOrderString);
  if Trim(WhereString)='' then WhereString:=PrepearWhereString(FFilters.GetFilterString);
  ActiveQuery(true);
  Locate(Param.Locate.KeyFields,Param.Locate.KeyValues,Param.Locate.Options);
  case FTypeEdit of
    terbAdd: begin
      InternalAddClick;
    end;  
  end;
end;

procedure TfmRBMainGrid.InternalAddClick;
begin
  if bibAdd.Enabled then begin
    bibAdd.Click;
  end;
end;

procedure TfmRBMainGrid.ReturnModalParamsFromDataSetAndGrid(DataSet: TDataSet; Grd: TNewDbGrid; Param: PParamRBookInterface);
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

  FillParamRBookInterfaceFromDataSet(DataSet,Param,Bookmarks);
end;

procedure TfmRBMainGrid.ReturnModalParams(Param: PParamRBookInterface);
begin
  ReturnModalParamsFromDataSetAndGrid(MainQr,Grid,Param);
end;

function TfmRBMainGrid.GetFilterString: string;
var
  s: string;
begin
  s:=PrepearWhereString(FFilters.GetFilterString);
  if Trim(s)<>'' then
    WhereString:=s;
  s:=PrepearWhereStringNoRemoved(WhereStringNoRemoved);
  if Trim(s)<>'' then
    if Trim(WhereString)<>'' then
      WhereString:=WhereString+' AND '+s
    else
      WhereString:=PrepearWhereString(s);
  Result:=WhereString;
end;

function TfmRBMainGrid.GetFilterStringNoRemoved: string;
begin
  Result:=WhereStringNoRemoved;
end;

procedure TfmRBMainGrid.bibFilterClick(Sender: TObject);
begin
  WhereString:='';
end;

function TfmRBMainGrid.GetSql: string;
begin
  Result:=SQLString;
end;

function TfmRBMainGrid.GetLastOrderStr: string;
begin
  Result:=LastOrderStr;
end;

procedure TfmRBMainGrid.SetLastOrderFromTypeSort(FieldName: string; TypeSort: TTypeColumnSort);
begin
  case TypeSort of
    tcsNone:  LastOrderStr:=PrepearOrderString(FDefaultOrders.GetOrderString);
    tcsAsc: LastOrderStr:=' ORDER BY '+FieldName+' ASC ';
    tcsDesc: LastOrderStr:=' ORDER BY '+FieldName+' DESC ';
  end;
end;

procedure TfmRBMainGrid.SetInterfaceHandle(Value: THandle);
begin
  FhInterface:=Value;
end;

procedure TfmRBMainGrid.pmGridPopup(Sender: TObject);
begin
  FillGridPopupMenu;
end;

procedure TfmRBMainGrid.GridKeyPress(Sender: TObject; var Key: Char);
begin
  if isValidKey(Key) then begin
   if edSearch.Showing then begin
     edSearch.SetFocus;
     edSearch.Text:=Key;
     edSearch.SelStart:=Length(edSearch.Text);
     if Assigned(edSearch.OnKeyPress) then
      edSearch.OnKeyPress(Sender,Key);
   end;   
  end;
end;

function TfmRBMainGrid.Locate(const KeyFields: string; const KeyValues: Variant; Options: TLocateOptions): Boolean;
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
    if Trim(s)<>'' then Grid.SelectedField:=MainQr.FieldByName(s);
  finally
   Screen.Cursor:=crDefault;
  end;
end;

function TfmRBMainGrid.LocateByRefreshParam(Param: PParamRefreshRBookInterface): Boolean;
begin
  Result:=Locate(Param.Locate.KeyFields,Param.Locate.KeyValues,Param.Locate.Options);
end;

function TfmRBMainGrid.GetLocateValueByName(Param: PParamRBookInterface; LocateName: string): Variant;
var
  Pos: Integer;
  FieldName: string;
begin
  Result:=Null;
  if Param=nil then exit;
  if Param.Locate.KeyFields=nil then exit;
  Pos := 1;
  while Pos <= Length(Param.Locate.KeyFields) do begin
    FieldName := ExtractFieldName(Param.Locate.KeyFields, Pos);
    if AnsiUpperCase(FieldName)=AnsiUpperCase(LocateName) then begin
      if VarIsArray(Param.Locate.KeyValues) then begin
       Result:=Param.Locate.KeyValues[Pos];
       exit;
      end else begin
       Result:=Param.Locate.KeyValues;
       exit;
      end;
    end;
  end;
end;

function TfmRBMainGrid.NextRecord: Boolean;
begin
  Result:=SetValuesToEditForm(tefNextRecord);
end;

function TfmRBMainGrid.PriorRecord: Boolean;
begin
  Result:=SetValuesToEditForm(tefPriorRecord);
end;

function TfmRBMainGrid.SetValuesToEditForm(TypeSetValuesToEditForm: TTypeSetValuesToEditForm):Boolean;
begin
  Result:=false;
  if not isValidPointer(EditForm) then exit;
  if Mainqr.isEmpty then exit;
  case TypeSetValuesToEditForm of
    tefNone:;
    tefNextRecord: begin
     if Mainqr.Eof then exit;
      Mainqr.Next;
    end;
    tefPriorRecord: begin
     if Mainqr.Bof then exit;
      Mainqr.Prior;
    end;
  end;
  Result:=true;
end;

procedure TfmRBMainGrid.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

function TfmRBMainGrid.GetDefaultOrdersName: string;
begin
  Result:='DefaultOrders';
end;

function TfmRBMainGrid.GetFiltersName: string;
begin
  Result:='Filters';
end;

function TfmRBMainGrid.DeleteRecord(const Message,TableName,FieldName,Value: string): Boolean;
var
  but: Integer;

  function DeleteRecord: Boolean;
  var
    qr: TIBQuery;
    tran: TIBTransaction;
    sqls: string;
  begin
   Screen.Cursor:=crHourGlass;
   qr:=TIBQuery.Create(nil);
   tran:=TIBTransaction.Create(nil);
   try
    result:=false;
    try
     tran.AddDatabase(Database);
     Database.AddTransaction(tran);
     tran.Params.Text:=DefaultTransactionParamsTwo;
     qr.Database:=Database;
     qr.Transaction:=tran;
     qr.Transaction.Active:=true;
     sqls:='Delete from '+TableName+' where '+FieldName+'='+Value;
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;

     if Mainqr.UpdateObject=IBUpd then begin
       IBUpd.DeleteSQL.Clear;
       IBUpd.DeleteSQL.Add(sqls);
       Mainqr.Delete;
     end;  

     ViewCount;

     Result:=true;
    except
     on E: EIBInterBaseError do begin
        TempStr:=TranslateIBError(E.Message);
        ShowErrorEx(TempStr);
        Assert(false,TempStr);
     end;
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   finally
    tran.Free; 
    qr.Free;
    Screen.Cursor:=crDefault;
   end;

  end;

begin
  Result:=false;
  if Mainqr.RecordCount=0 then exit;
  but:=DeleteWarningEx(Message);
  if but=mrYes then
    Result:=DeleteRecord;
end;

procedure TfmRBMainGrid.PrintPreview;
begin
  if not Mainqr.Active then exit;
  if RptExcelPreview<>nil then exit;
  Self.Enabled:=false;
  bibPreview.Enabled:=false;
  RptExcelPreview:=TRptExcelPreview.Create;
  RptExcelPreview.fmParent:=Self;
  RptExcelPreview.OnTerminate:=RptExcelPreviewOnTerminate;
  RptExcelPreview.Resume;
end;

procedure TfmRBMainGrid.RptExcelPreviewOnTerminate(Sender: TObject);
begin
  FreeAndNil(RptExcelPreview);
  bibPreview.Enabled:=true;
  Self.Enabled:=true;
end;

procedure TfmRBMainGrid.bibPreviewClick(Sender: TObject);
begin
  PrintPreview;
end;

end.



