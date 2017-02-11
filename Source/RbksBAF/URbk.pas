unit URbk;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, DBGrids, ExtCtrls, Db, DBCtrls, IBDatabase,
  IBCustomDataSet, IBQuery, Buttons, UMainUnited, URbkEdit, tsvDbGrid;

type
  PFilterParams = ^TFilterParams;
  TFilterParams = packed record
    FieldName : String;
    GridName: String;
    filterValue: String;
    Period1: String;
    period2: String;
  end;

  TFmRbk = class(TForm)
    PnFind: TPanel;
    PnOk: TPanel;
    PnWorkArea: TPanel;
    PnSqlBtn: TPanel;
    EdFind: TEdit;
    Lbfind: TLabel;
    DBNav: TDBNavigator;
    DS: TDataSource;
    RbkQuery: TIBQuery;
    RbkTrans: TIBTransaction;
    PnModify: TPanel;
    BtInsert: TButton;
    BtEdit: TButton;
    BtDel: TButton;
    PnOption: TPanel;
    BtRefresh: TButton;
    BtMore: TButton;
    BtFilter: TBitBtn;
    BtOptions: TButton;
    LbRecCount: TLabel;
    BtOk: TBitBtn;
    BtClose: TButton;
    PnGrid: TPanel;
    procedure FormResize(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtInsertClick(Sender: TObject);
    procedure BtCloseClick(Sender: TObject);
    procedure BtEditClick(Sender: TObject);
    procedure BtDelClick(Sender: TObject);
    procedure BtRefreshClick(Sender: TObject);
    procedure EdFindChange(Sender: TObject);
    procedure BtFilterClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BtOptionsClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BtMoreClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    LastKey: Word;
    FhInterface: THandle;
    NewLeft,NewTop,NewWidth,NewHeight: Integer;
    NewWindowState: TWindowState;
    procedure CMShowingChanged(var Message: TMessage); message CM_SHOWINGCHANGED;
    procedure SetNewPosition;
  protected
    procedure GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort); virtual;/// что значит "virtual"?
    procedure GridDblClick(Sender: TObject); virtual;
    procedure LoadFromIni;dynamic;
    procedure SaveToIni;dynamic;
    procedure LoadFormProp;
  public
    FilterValues: Tlist;
    TableName, StandartSQl, FilterSQL, OrderSQL: String;
    isPerm:Boolean; //есть ли доступ на Select
    ViewSelect:Boolean;
    FilterInSide: Boolean;
    Grid: TNewDbGrid;
    DeletingRec: String;
    IsLocate:Boolean;
    procedure AlignFindEdit;
    procedure CreateSQl(TabName: string);
    procedure InsertRecord;
    procedure UpdateRecord;
    procedure DeleteRecord;
    procedure RefreshQuery(ChekPerm:Boolean);
    procedure SetFilter;
    procedure ViewBtFiltered;
    procedure ModReslt(Sender:TObject);
    procedure Locate(TabId:Integer);
    procedure FilterValuesFree;
    function CheckPermission: Boolean;
    Function GetFilterPointer(GridName:String): pointer;
    procedure CreateFilterString; Virtual;

    procedure InitMdiChildParams(hInterface: THandle);
    procedure InitModalParams(InterfaceHandle: THandle; Param: PParamRBookInterface);
    procedure ReturnModalParams(Param: PParamRBookInterface);

    procedure InitOnlyDataParams(Param: PParamRBookInterface);
    procedure ReturnOnlyDataParams(Param: PParamRBookInterface);

    procedure SetInterfaceHandle(Value: THandle);
    procedure SetLastOrderFromTypeSort(FieldName: string; TypeSort: TTypeColumnSort);
    { Public declarations }
  end;


implementation
uses Uconst, UFuncProc, UAdjust;
{$R *.DFM}

procedure TFmRbk.FormActivate(Sender: TObject);
begin
  AlignFindEdit;
//  _AddToLastOpenEntryes(TypeEntry);
  if [fsModal] <> FormState then BtOk.Visible:=false else
    BtOk.Visible:=true;
  if not (FilterSQL='') then ViewBtFiltered;
end;

procedure TFmRbk.FormResize(Sender: TObject);
begin
  AlignFindEdit;
end;

procedure TFmRbk.AlignFindEdit;
begin
  edfind.left:=lbFind.Width;
  edfind.Width:=Grid.width - lbFind.Width;
end;

procedure TFmRbk.CreateSQl(TabName: string);
begin
  CreateFilterString;
  TableName:=TabName;
  StandartSQl:='Select * From '+TabName+' ';
end;


procedure TFmRbk.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=Cafree;
  Application.Hint:='';
end;


procedure TFmRbk.InsertRecord;
begin
  fmRbkEdit:=TfmRbkEdit.Create(Application);
  fmRbkEdit.Caption:=CaptionAdd;
  try
    fmRbkEdit.EditGen(Grid.Columns,TableName, '', false);
    if fmRbkEdit.ShowModal = mrOk then
    begin
      RefreshQuery(true);
      Locate(fmRbkEdit.Locate_id);
    end;
  finally
  fmRbkEdit.Release;
  fmRbkEdit:=Nil;
  end;
end;

procedure TFmRbk.BtInsertClick(Sender: TObject);
begin
  InsertRecord;
end;

procedure TFmRbk.BtCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFmRbk.BtEditClick(Sender: TObject);
begin
  UpdateRecord;
end;

function TFmRbk.CheckPermission: Boolean;
begin
  isPerm:=_isPermission(Pchar(TableName),SelConst);
  if not ViewSelect then
  begin
    BtInsert.Enabled:=isPerm and _isPermission(Pchar(TableName),InsConst);
    BtEdit.Enabled:=isPerm and _isPermission(Pchar(TableName),UpdConst);
    BtDel.Enabled:=isPerm and _isPermission(Pchar(TableName),DelConst);
    BtMore.Enabled:=isPerm;
    BtFilter.Enabled:=isPerm;
    PnOption.Enabled:=isPerm;
  end else begin
   PnModify.Visible:=false;
  end;
  Result:=isPerm;
end;


procedure TFmRbk.UpdateRecord;
var
  id:String;
begin
  fmRbkEdit:=TfmRbkEdit.Create(Application);
  fmRbkEdit.Caption:=CaptionChange;
  try
    id:=RbkQuery.fieldByName(TableName+'_id').AsString;
    fmRbkEdit.EditGen(Grid.Columns, TableName,Id, true);
    if fmRbkEdit.ShowModal = mrOk then
    begin
      RefreshQuery(true);
      Locate(StrToInt(Id));
    end;
  finally
  fmRbkEdit.Release;
  fmRbkEdit:=Nil;
  end;
end;

procedure TFmRbk.DeleteRecord;
var
  DelQ: TIbQuery;
begin
  if RbkQuery.IsEmpty then exit;
  if DeleteWarning(Application.Handle,DeletingRec)=mrYes then
  begin
    DelQ:=TIbQuery.Create(nil);
    DelQ.Database:=IbDb;
    DelQ.Transaction:=RbkTrans;
    DelQ.SQL.Add('Delete from '+TableName+' where '+TableName+
      '_id = '+RbkQuery.fieldByName(TableName+'_id').AsString);
    try
      DelQ.Transaction.Active:=true;
      DelQ.ExecSQL;
      DelQ.Transaction.CommitRetaining;
      RefreshQuery(true);
    finally
      DelQ.Free;
    end;
  end;
end;

procedure TFmRbk.BtDelClick(Sender: TObject);
begin
  DeleteRecord;
end;

procedure TFmRbk.RefreshQuery(ChekPerm:Boolean);
var
  i:integer;
begin
  if not CheckPermission then Exit;
  RbkQuery.Transaction.Active:=false;
  RbkQuery.Transaction.Active:=true;
  RbkQuery.Close;
  RbkQuery.SQL.Clear;
  RbkQuery.SQL.Add(StandartSQl+FilterSQL+OrderSQL);
  Screen.Cursor:=crHourGlass;
  RbkQuery.Open;
  i:=GetRecordCount(RbkQuery);
  LbRecCount.Caption:='¬сего выбрано: '+IntToStr(i);
  IsLocate:=true;
  if i>15000 then
  begin
    ShowWarning(Application.Handle,
    ' оличество строк справочника превышает 15000'+#13+
    'дл€ оптимальной работы справочника рекомендуем'+#13+
    'примен€ть фильтр!!!');
    IsLocate:=false;
  end;
  Screen.Cursor:=crDefault;
  
end;

procedure TFmRbk.BtRefreshClick(Sender: TObject);
begin
  RefreshQuery(true);
end;

procedure TFmRbk.EdFindChange(Sender: TObject);
begin
  RbkQuery.Locate(Grid.SelectedField.FieldName,
    trim(EdFind.text),[lopartialkey, loCaseInsensitive]);
end;

procedure TFmRbk.SetFilter;
var
  I: Integer;
  ed: Tedit;
  ct: TControl;
  P: PFilterParams;
begin
  try
    FmRbkEdit:=TFmRbkEdit.create(nil);
    FmRbkEdit.Caption:=CaptionFilter;
    FmRbkEdit.btClear.Visible:=true;
    FmRbkEdit.EditGen(Grid.Columns,TableName,'',false);
    FmRbkEdit.PnFilter.Visible:=true;
    for i:=0 to FmRbkEdit.ListControls.Count-1 do
    begin
      ct:=FmRbkEdit.ListControls.Items[i];
      if ct is TEdit then begin
        ed:=TEdit(ct);
        P:=GetFilterPointer(Ed.Name);
        if P<>nil then Ed.Text:=P.filterValue;
      end;
    end;
    FmRbkEdit.CBInsideFilter.Checked:=FilterInSide;
    FmRbkEdit.BtPost.OnClick:=FmRbkEdit.ApplyFilter;
    if FmRbkEdit.ShowModal = mrOk then
    begin
      FilterInSide:=FmRbkEdit.CBInsideFilter.Checked;
      for i:=0 to FmRbkEdit.ListControls.Count-1 do
      begin
        ct:=FmRbkEdit.ListControls.Items[i];
        if ct is TEdit then
        begin
          ed:=TEdit(ct);
          P:=GetFilterPointer(Ed.Name);
          P.filterValue:=Trim(Ed.Text);
        end;
      end;
      CreateFilterString;
      RefreshQuery(false);
      ViewBtFiltered;
    end;
  finally
    FreeAndNil(FmRbkEdit);
  end;
end;

procedure TFmRbk.BtFilterClick(Sender: TObject);
begin
  SetFilter;
end;

procedure TFmRbk.FormKeyPress(Sender: TObject; var Key: Char);
begin
  _MainFormKeyPress(Key);
end;

procedure TFmRbk.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  _MainFormKeyUp(Key,Shift);
end;

procedure TFmRbk.BtOptionsClick(Sender: TObject);
begin
  SetAdjustColumns(Grid.Columns);
end;

procedure TFmRbk.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=LastKey then begin
   LastKey:=0;
   exit;
  end;
  if Shift=[] then begin
   case Key of
    VK_F2: if (PnModify.Visible) and (BtInsert.Enabled) then BtInsert.Click;

    VK_F3: if (PnModify.Visible) and (BtEdit.Enabled) then  BtEdit.Click;

    VK_F4: if (PnModify.Visible) and (BtDel.Enabled) then BtDel.Click;

    VK_F5: if BtRefresh.Enabled then  BtRefresh.Click;

    VK_F6: if BtMore.Enabled then  BtMore.Click;

    VK_F7: if BtFilter.Enabled then BtFilter.Click;

    VK_F8: if BtOptions.Enabled then BtOptions.Click;

    VK_UP,VK_DOWN: Grid.SetFocus;
   end;
  end;
  _MainFormKeyDown(Key,Shift);
  LastKey:=Key;
end;

procedure TFmRbk.ModReslt(Sender:TObject);
begin
  ModalResult:=mrOk;
end;

procedure TFmRbk.BtMoreClick(Sender: TObject);
begin
  fmRbkEdit:=TfmRbkEdit.Create(Application);
  fmRbkEdit.Caption:=CaptionView;
  try
    fmRbkEdit.PnEdit.Enabled:=false;
    fmRbkEdit.BtPost.Visible:=false;
    fmRbkEdit.BtCancel.Caption:=CaptionClose;
    fmRbkEdit.EditGen(Grid.Columns, '','', true);
    if fmRbkEdit.ShowModal = mrOk then
    begin

    end;
  finally
    fmRbkEdit.Release;
    fmRbkEdit:=Nil;
  end;
end;

procedure TFmRbk.FormCreate(Sender: TObject);
begin
  ViewSelect:=not _GetOptions.isEditRBOnSelect;

  Left:=Screen.width div 2-Width div 2;
  Top:=Screen.Height div 2-Height div 2;
  NewLeft:=Left;
  NewTop:=Top;
  NewWidth:=Width;
  NewHeight:=Height;
  NewWindowState:=WindowState;
//  WindowState:=wsMinimized;
  LoadFormProp;

  RbkTrans.AddDatabase(IBDB);
  Ibdb.AddTransaction(RbkTrans);
  RbkQuery.DataBase:=IbDb;
  RbkQuery.Transaction:=RbkTrans;

  FilterValues:=Tlist.create;
  Grid:=TNewdbGrid.Create(self);
  Grid.Parent:=pnGrid;
  Grid.Align:=alClient;
  Grid.Width:=pnGrid.Width-PnModify.Width;
  Grid.DataSource:=ds;
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
  Grid.ReadOnly:=true;
  Grid.OnKeyDown:=FormKeyDown;
  Grid.OnTitleClickWithSort:=GridTitleClickWithSort;
  Grid.OnDblClick:=GridDblClick;
  Grid.TabOrder:=1;
  PnModify.TabOrder:=2;
end;

procedure TFmRbk.ViewBtFiltered;
begin
  if FilterSQL<>'' then
  begin
    BtFilter.Font.Size:=9;
    BtFilter.Font.Color:=_getoptions.RbFilterColor;
  end else
  begin
    BtFilter.Font.Color:=clWindowText;
    BtFilter.Font.Size:=8;
  end;
end;

procedure TFmRbk.Locate(TabId:Integer);
begin
  if IsLocate then
  RbkQuery.Locate(TableName+'_id', TabId,[loCaseInsensitive]);
end;

procedure TFmRbk.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort); 
begin
//
end;

procedure TFmRbk.GridDblClick(Sender: TObject);
begin
  //
end;


procedure TFmRbk.FormDestroy(Sender: TObject);
begin
  SaveToIni;
  Grid.Free;
  _OnVisibleInterface(FhInterface,false);
 FilterValuesFree;
end;

procedure TFmRbk.SaveToIni;
var
  I:integer;
  P:PFilterParams;
  procedure SaveFormProp;
  begin
    if FormState=[fsCreatedMDIChild] then
    begin
     Writeparam(ClassName,'Left',Left);
     Writeparam(ClassName,'Top',Top);
     Writeparam(ClassName,'Width',Width);
     Writeparam(ClassName,'Height',Height);
     Writeparam(ClassName,'WindowState',Integer(WindowState));
    end;
  end;
    procedure SaveGridProp;
    var
      i: Integer;
      cl: TColumn;
    begin
      if Grid=nil then exit;
      if Grid.Columns.Count=0 then exit;
      for i:=0 to Grid.Columns.Count-1 do begin
        cl:=Grid.Columns.Items[i];
        Writeparam(ClassName,'ColumnID'+inttostr(i),cl.ID);
        Writeparam(ClassName,'ColumnIndex'+inttostr(i),cl.Index);
        Writeparam(ClassName,'ColumnWidth'+inttostr(i),cl.Width);
        Writeparam(ClassName,'ColumnVisible'+inttostr(i),cl.Visible);
      end;
    end;

begin
 inherited;
 try
   Writeparam(ClassName,'FilterInSide', FilterInSide);
   For i:=0 to FilterValues.Count-1 do
   begin
     P:=FilterValues[i];
     Writeparam(ClassName,P.FieldName,P.filterValue);
     Writeparam(ClassName,P.FieldName+'_Per1',P.Period1);
//     else Fi.DeleteKey(ClassName,P.FieldName+'_Per1');
     Writeparam(ClassName,P.FieldName+'_Per2',P.Period2);
//     else Fi.DeleteKey(ClassName,P.FieldName+'_Per2');
   end;
   SaveGridProp;
   SaveFormProp;
 except
 end;
end;

procedure TFmRbk.LoadFromIni;
var
  P:PFilterParams;
  I:integer;
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
  inherited;
  try
   FilterInSide:=ReadParam(ClassName,'FilterInSide',false);
   For i:=0 to FilterValues.Count-1 do
   begin
     P:=FilterValues[i];
     P.filterValue:=ReadParam(ClassName,P.FieldName,'');
     P.Period1:=ReadParam(ClassName,P.FieldName+'_Per1','');
     P.period2:=ReadParam(ClassName,P.FieldName+'_Per2','');
   end;
   LoadGridProp;
   CreateFilterString;
  except

 end;
 end;

procedure TFmRbk.FilterValuesFree;
var
  i: integer;
  P: PFilterParams;
begin
  if FilterValues.Count <> 0 then
  for i:=FilterValues.Count-1 to 0 do
  begin
    P:=FilterValues[i];
    FilterValues.Remove(P);
    Dispose(P);
  end;
  FilterValues.free;
end;


Function TFmRbk.GetFilterPointer(GridName:String): pointer;
var
  i:integer;
  P: PFilterParams;
begin
  Result:=nil;
  for i:=0 to FilterValues.Count-1 do
  begin
    P:=FilterValues[i];
    if UpperCase(P.GridName)=UpperCase(GridName) then
    begin
     Result:=P;
     Break;
    end;
  end;
end;


procedure TFmRbk.CreateFilterString;
var
  i:integer;
  P: PFilterParams;
  S:String;
  LeftQuote, RightQuote:String;
begin
  RightQuote:='%';
  if not FilterInSide then LeftQuote:='' else LeftQuote:='%';
  for i:=0 to FilterValues.Count-1 do
  begin
    P:=FilterValues[i];
    if P.filterValue<>'' then
    begin
      if S<>'' then S:= S+' and ';
      S:=S+'Upper('+P.FieldName+') like '+QuotedStr(LeftQuote+
           AnsiUpperCase(P.filterValue)+RightQuote);
    end;
    if (P.Period1<>'')and(P.Period2<>'') then
    begin
      if S<>'' then S:= S+' and ';
      S:=S+P.FieldName+' between '+QuotedStr(P.Period1)+' and '+
      QuotedStr(P.Period2);
    end else
    if P.Period1<>'' then
    begin
      if S<>'' then S:= S+' and ';
      S:=S+P.FieldName+' >='+QuotedStr(P.Period1);
    end else
    if P.Period2<>'' then
    begin
      if S<>'' then S:= S+' and ';
      S:=S+P.FieldName+' <='+QuotedStr(P.Period2);
    end;
  end;
  if S<>'' then FilterSQL:=' where '+S else FilterSQL:='';
end;

procedure TfmRBk.CMShowingChanged(var Message: TMessage);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then SetNewPosition;
end;

procedure TfmRBk.SetNewPosition;
begin
  Left:=NewLeft;
  Top:=NewTop;
  Width:=NewWidth;
  Height:=NewHeight;
  WindowState:=NewWindowState;
end;


procedure TfmRBk.LoadFormProp;
begin
  NewLeft:=ReadParam(ClassName,'Left',Left);
  NewTop:=ReadParam(ClassName,'Top',Top);
  NewWidth:=ReadParam(ClassName,'Width',Width);
  NewHeight:=ReadParam(ClassName,'Height',Height);
  NewWindowState:=TWindowState(ReadParam(ClassName,'WindowState',
    Integer(WindowState)));
end;

procedure TfmRBk.InitMdiChildParams(hInterface: THandle);
begin
   _OnVisibleInterface(hInterface,true);
   FhInterface:=hInterface;
   ViewSelect:=false;
   RefreshQuery(true);
   FormStyle:=fsMDIChild;
   if WindowState=wsMinimized then begin
    WindowState:=wsNormal;
   end;
   BringToFront;
   Show;
end;

procedure TfmRBk.InitModalParams(InterfaceHandle: THandle; Param: PParamRBookInterface);
begin
  FhInterface:=InterfaceHandle;
  BtClose.Cancel:=true;
  btOk.OnClick:=ModReslt;
  btClose.Caption:=CaptionCancel;
  btOk.Visible:=true;
  Grid.OnDblClick:=ModReslt;
  Grid.MultiSelect:=Param.Visual.MultiSelect;
  BorderIcons:=BorderIcons-[biMinimize];
  WindowState:=wsNormal;
  FilterSQL:=PrepearWhereString(Param.Condition.WhereStr);
  OrderSQL:=PrepearOrderString(Param.Condition.OrderStr);
  RefreshQuery(true);
  with Param.Locate do begin
    if KeyFields<>nil then begin
      if VarType(KeyValues)<>varEmpty then
       RbkQuery.Locate(KeyFields,KeyValues,Options);
    end;
  end;
end;


procedure TfmRBk.ReturnModalParams(Param: PParamRBookInterface);
var
  i,j: Integer;
begin
  if RbkQuery.IsEmpty then exit;
  RbkQuery.DisableControls;
  try
   SetLength(Param.Result,RbkQuery.FieldCount);
   for i:=0 to RbkQuery.FieldCount-1 do
     Param.Result[i].FieldName:=RbkQuery.Fields[i].FieldName;
   if Param.Visual.MultiSelect then begin
     for i:=0 to RbkQuery.FieldCount-1 do begin
       for j:=0 to Grid.SelectedRows.Count-1 do begin
         SetLength(Param.Result[i].Values,Grid.SelectedRows.Count);
         RbkQuery.GotoBookmark(pointer(Grid.SelectedRows.Items[j]));
         Param.Result[i].Values[j]:=RbkQuery.Fields[i].Value;
       end;
     end;
    end else begin
      for i:=0 to RbkQuery.FieldCount-1 do begin
         SetLength(Param.Result[i].Values,1);
         Param.Result[i].Values[0]:=RbkQuery.Fields[i].Value;
      end;
    end;
  finally
   RbkQuery.EnableControls;
  end;
end;

procedure TfmRBk.SetInterfaceHandle(Value: THandle);
begin
  FhInterface:=Value;
end;

procedure TfmRBk.InitOnlyDataParams(Param: PParamRBookInterface);
begin
  FilterSQL:=PrepearWhereString(Param.Condition.WhereStr);
  OrderSQL:=PrepearOrderString(Param.Condition.OrderStr);
  RefreshQuery(false);
end;

procedure TfmRBk.ReturnOnlyDataParams(Param: PParamRBookInterface);
begin
  FillParamRBookInterfaceFromDataSet(RbkQuery,Param,[]);
end;

procedure TfmRBk.SetLastOrderFromTypeSort(FieldName: string; TypeSort: TTypeColumnSort);
begin
  case TypeSort of
    tcsNone:  OrderSQL:='';
    tcsAsc: OrderSQL:=' Order by '+FieldName+' asc ';
    tcsDesc: OrderSQL:=' Order by '+FieldName+' desc ';
  end;
end;


end.
