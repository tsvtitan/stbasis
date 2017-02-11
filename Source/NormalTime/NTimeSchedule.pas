unit NTimeSchedule;

{$I stbasis.inc}

interface

uses
  Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs, NTimeCode,
  Placemnt, StdCtrls, Mask, ToolEdit, ExtCtrls, Db, RxMemDS,
  Grids, DBGrids, IBCustomDataSet, IBQuery, ComCtrls, IBDatabase,
  DBCtrls, UMainUnited, RXDBCtrl, NTimeData;

type
  TfrmSchedule = class(TForm)
    PanelTop1: TPanel;
    Label1: TLabel;
    PanelBottom: TPanel;
    PanelClose: TPanel;
    Button1: TButton;
    mdNormalTime: TRxMemoryData;
    dsNormalTime: TDataSource;
    GridSchedule: TRxDBGrid;
    Splitter: TSplitter;
    PanelNTime: TPanel;
    GridNormalTime: TRxDBGrid;
    PanelInfo: TPanel;
    GroupBoxInfo: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Panel5: TPanel;
    Label5: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    mdNormalTimeInfo: TStringField;
    quCalSelect: TIBQuery;
    dsCalSelect: TDataSource;
    trRead: TIBTransaction;
    trWrite: TIBTransaction;
    quScheduleSelect: TIBQuery;
    dsScheduleSelect: TDataSource;
    quShiftSelect: TIBQuery;
    PanelOKCancel: TPanel;
    ButtonOK: TButton;
    ButtonCancel: TButton;
    PanelNavigator: TPanel;
    DBNavigator: TDBNavigator;
    LabelCount: TLabel;
    quCalSelectcalendar_id: TIntegerField;
    quCalSelectstartdate: TDateField;
    quCalSelectstartdatestr: TStringField;
    mdNormalTimeScheduleDate: TDateField;
    LookupCalendar: TComboBox;
    PanelWait: TPanel;
    PanelProgress: TPanel;
    ProgressBar: TProgressBar;
    LabelProgress: TLabel;
    quNTimeChange: TIBQuery;
    PanelTop2: TPanel;
    ButtonSchAdd: TButton;
    ButtonSchEdit: TButton;
    ButtonSchDelete: TButton;
    ButtonRefreshTop: TButton;
    quTemp: TIBQuery;
    PanelSelecting: TPanel;
    ButtonRefresh: TButton;
    btnGridColsSet: TButton;
    mdNormalTimeLeft: TIntegerField;
    Bevel1: TBevel;
    Button2: TButton;
    Button3: TButton;
    ButtonInfo: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormResize(Sender: TObject);
    procedure ButtonRefreshTopClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CommonGridEnter(Sender: TObject);
    procedure CommonGridExit(Sender: TObject);
    procedure CommonAfterScroll(DataSet: TDataSet);
    procedure GridNormalTimeGetCellParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; Highlight: Boolean);
    procedure quCalSelectCalcFields(DataSet: TDataSet);
    procedure ButtonSchAddClick(Sender: TObject);
    procedure ButtonSchEditClick(Sender: TObject);
    procedure ButtonSchDeleteClick(Sender: TObject);
    procedure btnGridColsSetClick(Sender: TObject);
    procedure LookupCalendarChange(Sender: TObject);
    procedure mdNormalTimeScheduleDateChange(Sender: TField);
    procedure FormPaint(Sender: TObject);
    procedure GridNormalTimeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure mdNormalTimeLeftGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure GridNormalTimeDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure GridNormalTimeGetBtnParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; var SortMarker: TSortMarker;
      IsDown: Boolean);
    procedure GridScheduleGetCellParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; Highlight: Boolean);
    procedure GridNormalTimeTitleBtnClick(Sender: TObject; ACol: Integer;
      Field: TField);
    procedure GridNormalTimeCellClick(Column: TColumn);
    procedure GridNormalTimeShowEditor(Sender: TObject; Field: TField;
      var AllowEdit: Boolean);
    procedure GridNormalTimeMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure GridNormalTimeMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure GridNormalTimeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ButtonInfoClick(Sender: TObject);
  private
   ScheduleAction:TScheduleAction;
   ScheduleParams:PParamRBookInterface;
   Refreshing:Boolean;
   FirstActive:Boolean;
   FhInterface: THandle;
   FTimeDefValue:TStringList;
   DefaultCalendarSelectStr:String;

   StartSelecting:Boolean;
   StartCopy:Boolean;
   SCol,SRow:Integer;
   LastSelMode:TSetMode;

   procedure UpdateScheduleInfo;
   procedure RecreateNormalTimeGrid;
   /////////
   procedure ClearSelecting(ADataSet:TDataSet);
   procedure SelectAll(ADataSet:TDataSet);
   procedure MouseToCell2(AGrid:TRxDBGrid; X, Y: Integer; var ACol, ARow: Longint);
   function GetHideField(F:TField):TIntegerField;
  public
   constructor Create(AOwner:TComponent;AhInterface: THandle;AScheduleAction:TScheduleAction;AParams:PParamRBookInterface); virtual;
   procedure DoRefresh(ReCreateGrid:Boolean);
  end;

var
  frmSchedule: TfrmSchedule;

implementation

{$R *.DFM}

uses TypInfo, SysUtils, StrUtils, DateUtil, StCalendarUtil,
  NTimeScheduleEdit, UAdjust, NTimeInfo;

constructor TfrmSchedule.Create(AOwner: TComponent;AhInterface: THandle;AScheduleAction:TScheduleAction;AParams:PParamRBookInterface);
begin
 FirstActive:=True;
 ScheduleAction:=AScheduleAction;
 ScheduleParams:=AParams;
 FhInterface:=AhInterface;
 _OnVisibleInterface(FhInterface,True);
 FTimeDefValue:=TStringList.Create;

 FTimeDefValue.Add('1,0');
 FTimeDefValue.Add('2,0');
 FTimeDefValue.Add('3,0');
 FTimeDefValue.Add('4,0');
 FTimeDefValue.Add('5,0');
 FTimeDefValue.Add('6,0');
 FTimeDefValue.Add('7,0');
 FTimeDefValue.Add('8,0');
 FTimeDefValue.Add('9,0');

 inherited Create(AOwner);

 AssignFont(_GetOptions.RBTableFont,GridSchedule.Font);
 GridSchedule.TitleFont.Assign(GridSchedule.Font);
 AssignFont(_GetOptions.RBTableFont,GridNormalTime.Font);
 GridNormalTime.TitleFont.Assign(GridNormalTime.Font);

 if ScheduleAction=saScheduleEdit then begin
   Caption:=CaptionScheduleEdit;
   PanelSelecting.Visible:=False;
   try
    FormStyle:=fsMDIChild;
   except
//    on E:Exception do ShowInfo(0,E.Message);
   end;
 end
 else begin
  Caption:=CaptionScheduleSelect;
  GridNormalTime.Visible:=False;
  GridSchedule.Align:=alClient;
  PanelTop2.Visible:=False;
  PanelTop1.Enabled:=False;
  Splitter.Visible:=False;
  PanelSelecting.Visible:=True;
  PanelClose.Visible:=False;
  PanelOKCancel.Visible:=True;
  BorderIcons:=[biSystemMenu];
 end;
end;

procedure TfrmSchedule.FormCreate(Sender: TObject);
begin
 Refreshing:=False;
 ChangeDatabase(Self,dbSTBasis);

 case ScheduleAction of
  saScheduleEdit:
   DefaultCalendarSelectStr:='select calendar_id,startdate from calendar order by startdate ';
  else begin
   DefaultCalendarSelectStr:='select calendar_id,startdate from calendar where calendar_id=:calendar_id order by startdate ';
  end;
 end;

 DoRefresh(True);

 if ScheduleParams<>nil then
  with ScheduleParams.Locate do
   if KeyFields<>nil then
    try
     quScheduleSelect.Locate(KeyFields,KeyValues,Options);
    except
    end;
end;

procedure TfrmSchedule.FormDestroy(Sender: TObject);
begin
 HideNormalInfo;
 FTimeDefValue.Free;
 if ScheduleAction=saScheduleEdit then frmSchedule:=nil;
 _OnVisibleInterface(FhInterface,False);
end;

procedure TfrmSchedule.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 if ScheduleAction=saScheduleEdit then Action:=caFree;
 if (ModalResult=mrOK) and (ScheduleParams<>nil) then
  ReturnModalParamsFromDataSetAndGrid(quScheduleSelect,GridSchedule,ScheduleParams);
 Application.Hint:='';
 HideNormalInfo;
end;

procedure TfrmSchedule.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if Shift=[] then
 case Key of
  VK_F2:if ButtonSchAdd.Enabled then ButtonSchAdd.Click;      //Add
  VK_F3:if ButtonSchEdit.Enabled then ButtonSchEdit.Click;    //Edit
  VK_F4:if ButtonSchDelete.Enabled then ButtonSchDelete.Click;//Delete
  VK_F5:ButtonRefresh.Click;                            //Refresh
  VK_F6:;                                               //View all
  VK_F7:;                                               //Filter
  VK_F8:if ScheduleAction=saScheduleSelect then btnGridColsSet.Click;  //Setup cols
 end;
 //Clipboard
 //?????????
 ///////////
 _MainFormKeyDown(Key,Shift);
end;

procedure TfrmSchedule.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 _MainFormKeyUp(Key,Shift);
end;

procedure TfrmSchedule.FormKeyPress(Sender: TObject; var Key: Char);
begin
 _MainFormKeyPress(Key);
end;

procedure TfrmSchedule.FormResize(Sender: TObject);
begin
 if ScheduleAction=saScheduleEdit then
  LookupCalendar.Width:=PanelTop1.Width-LookupCalendar.Left-4
 else
  LookupCalendar.Width:=PanelTop1.Width-LookupCalendar.Left-PanelSelecting.Width;
end;

procedure TfrmSchedule.mdNormalTimeScheduleDateChange(Sender: TField);
var NewID:Integer;
begin
 quNTimeChange.SQL.Text:=Format('delete from normaltime where (shift_id=%s) and (schedule_id=%d) and (workdate=CAST(''%s'' AS DATE))',
  [Sender.LookupKeyFields,quScheduleSelect.FieldByName(fldScheduleScheduleID).AsInteger,mdNormalTimeScheduleDate.AsString]);
 if not quNTimeChange.Transaction.InTransaction then quNTimeChange.Transaction.StartTransaction;
 try
  quNTimeChange.ExecSQL;
  quNTimeChange.Transaction.Commit;
 except
  quNTimeChange.Transaction.Rollback;
  Exit;
 end;
 if Sender.AsString<>'' then
 begin
  NewID:=GetGenId(dbSTBasis,tbNormalTime,1);
  quNTimeChange.SQL.Text:=Format('insert into normaltime (normaltime_id,shift_id,schedule_id,workdate,timecount) values (%d,%s,%d,CAST(''%s'' AS DATE),%s)',
   [NewID,Sender.LookupKeyFields,quScheduleSelect.FieldByName(fldScheduleScheduleID).AsInteger,mdNormalTimeScheduleDate.AsString,ReplaceStr(Sender.AsString,',','.')]);
  if not quNTimeChange.Transaction.InTransaction then quNTimeChange.Transaction.StartTransaction;
  try
   quNTimeChange.ExecSQL;
   quNTimeChange.Transaction.Commit;
  except
   quNTimeChange.Transaction.Rollback;
  end;
 end;
 UpdateScheduleInfo;
end;

procedure TfrmSchedule.RecreateNormalTimeGrid;
var D,Last:TDateTime;
    A,CurSchedule:Integer;
    F1:TFloatField;
    F2:TIntegerField;
//    CurNormalTime:Double;
//    B:String;
//    Progress1,Progress2:DWord;
begin
 //Объявляем о начале рефреша
 Refreshing:=True;

 LastSelMode:=TSetMode(smNone);
 StartSelecting:=False;
 StartCopy:=False;

 mdNormalTime.DisableControls;
// PanelWait.BringToFront;

{ PanelTop1.Enabled:=False;
 PanelTop2.Enabled:=False;
 PanelBottom.Enabled:=False;
 GridSchedule.Enabled:=False;}

 mdNormalTime.EmptyTable;
 mdNormalTime.Close;
 try
  for A:=mdNormalTime.Fields.Count downto 1 do
   if (UpperCase(mdNormalTime.Fields[A-1].FullName)<>UpperCase('LEFT')) and
      (UpperCase(mdNormalTime.Fields[A-1].FullName)<>UpperCase('ScheduleDate')) and
      (UpperCase(mdNormalTime.Fields[A-1].FullName)<>UpperCase('Info')) then mdNormalTime.Fields[A-1].Free;

  GridNormalTime.Columns.RebuildColumns;
{  for A:=1 to GridNormalTime.Columns.Count do
    GridNormalTime.Columns[A-1].ReadOnly:=False;}
  quShiftSelect.First;A:=1;
  while not quShiftSelect.EOF do
  begin
   F1:=TFloatField.Create(mdNormalTime);
   F1.Name:='mdNormalTimeShift'+quShiftSelect.FieldByName(fldShiftShiftID).AsString;
   F1.DisplayLabel:=quShiftSelect.FieldByName(fldShiftName).AsString;
   F1.FieldKind:=fkData;
   F1.FieldName:='Shift'+IntToStr(A);
   F1.LookupKeyFields:=quShiftSelect.FieldByName(fldShiftShiftID).AsString;
   F1.KeyFields:='Col'+IntToStr(A);
   F1.DataSet:=mdNormalTime;

   F2:=TIntegerField.Create(mdNormalTime);
   F2.Name:='mdNormalTimeCol'+quShiftSelect.FieldByName(fldShiftShiftID).AsString;
   F2.Visible:=False;
   F2.FieldKind:=fkData;
   F2.FieldName:='Col'+IntToStr(A);
   F2.LookupKeyFields:='';
   F2.KeyFields:='hide';
   F2.DataSet:=mdNormalTime;

   quShiftSelect.Next;
   Inc(A);
  end;
  GridNormalTime.Columns.RebuildColumns;
  for A:=1 to GridNormalTime.Columns.Count do
  begin
   if UpperCase(GridNormalTime.Columns[A-1].Field.FullName)='LEFT' then
    GridNormalTime.Columns[A-1].Width:=16 else
    GridNormalTime.Columns[A-1].Width:=90;
   if GridNormalTime.Columns[A-1].Field.LookupKeyFields<>'' then
    GridNormalTime.Columns[A-1].PickList.Assign(FTimeDefValue);
   if GridNormalTime.Columns[A-1].Field.KeyFields='hide' then
    GridNormalTime.Columns[A-1].Visible:=False;
  end;
 except
 end;
 try
  mdNormalTime.Open;
 except
 end;
 if not quScheduleSelect.IsEmpty then
 try
  CurSchedule:=quScheduleSelect.FieldByName(fldScheduleScheduleID).AsInteger;

  D:=quCalSelect.FieldByName(fldCalendarStartDate).AsDateTime;
  Last:=GelLastDateForCalendar(quCalSelect.FieldByName(fldCalendarCalendarID).AsInteger);

{  ProgressBar.Position:=0;
  ProgressBar.Max:=DaysBetween(D,Last);
  Progress1:=_CreateProgressBar(0,DaysBetween(D,Last),'',clNavy);
  LabelProgress.Caption:='Создание календаря...';
  Application.ProcessMessages;}
  while D<=Last do
  begin
   mdNormalTime.Append;
   mdNormalTimeScheduleDate.AsDateTime:=D;
   if IsFreeday(D) then
    mdNormalTimeInfo.AsString:='выходной';
   if IsCarryingFrom(D) then
    mdNormalTimeInfo.AsString:='';
   if IsCarryingTo(D) or IsPrevDayWeekendAndHoliday(D) then
    mdNormalTimeInfo.AsString:='пер. выходной';
   if IsHoliday(D) then
    mdNormalTimeInfo.AsString:='праздник';
    //Старый и медленный способ
{   for A:=1 to mdNormalTime.Fields.Count do
    if mdNormalTime.Fields[A-1].Tag>0 then
    begin
     CurNormalTime:=GetNormalTime(CurSchedule,mdNormalTime.Fields[A-1].Tag,D);
     if CurNormalTime>0 then  mdNormalTime.Fields[A-1].AsFloat:=CurNormalTime;
    end;}
   mdNormalTime.Post;
{   ProgressBar.StepIt;
   _SetProgressStatus(Progress1,ProgressBar.Position);
//   Application.ProcessMessages;}
   D:=IncDay(D,1);
  end;

//  _FreeProgressBar(Progress);

  //Новый и быстрый способ
{  ProgressBar.Position:=0;
  ProgressBar.Max:=ProgressBar.Max*A;
  Progress2:=_CreateProgressBar(0,ProgressBar.Max,'',clRed);
  LabelProgress.Caption:='Заполнение значений...';
  Application.ProcessMessages;}
  quTemp.SQL.Text:=Format('select workdate,shift_id,timecount from normaltime where schedule_id=%d',[CurSchedule]);
  try
   quTemp.Open;
   while not quTemp.EOF do
   begin
    if mdNormalTime.Locate('ScheduleDate',quTemp.FieldByName(fldNormalTimeWorkDate).AsDateTime,[]) then
    begin
     for A:=1 to mdNormalTime.Fields.Count do
      if mdNormalTime.Fields[A-1].LookupKeyFields=quTemp.FieldByName(fldNormalTimeShiftID).AsString then
      begin
       mdNormalTime.Edit;
       mdNormalTime.Fields[A-1].AsFloat:=quTemp.FieldByName(fldNormalTimeTimeCount).AsFloat;
       mdNormalTime.Post;
      end;
    end;
    quTemp.Next;
{    ProgressBar.StepIt;
   _SetProgressStatus(Progress2,ProgressBar.Position);}
   end;
   quTemp.Close;
  except
  end;

{  _FreeProgressBar(Progress1);
  _FreeProgressBar(Progress2);}

  mdNormalTime.First;
  for A:=mdNormalTime.Fields.Count downto 1 do
   if mdNormalTime.Fields[A-1].LookupKeyFields<>'' then mdNormalTime.Fields[A-1].OnChange:=mdNormalTimeScheduleDateChange;

  GridNormalTime.Color:=clWindow;
 except
 end else GridNormalTime.Color:=clBtnFace;
 GridNormalTime.Enabled:=not quScheduleSelect.IsEmpty;

{ PanelTop1.Enabled:=True;
 PanelTop2.Enabled:=True;
 PanelBottom.Enabled:=True;
 GridSchedule.Enabled:=True;}

 UpdateScheduleInfo;

 mdNormalTime.EnableControls;
// PanelWait.SendToBack;

 try
  GridNormalTime.Col:=3;
 except
 end;
{ for A:=1 to GridNormalTime.Columns.Count do
  if GridNormalTime.Columns[A-1].Field.Tag=0 then
   GridNormalTime.Columns[A-1].ReadOnly:=True;}

 Refreshing:=False;
end;

procedure TfrmSchedule.DoRefresh(ReCreateGrid:Boolean);
var I:Integer;
    LastCalendar,LastSchedule,LastNormalTime:String;
begin
 //Объявляем о начале рефреша
 Refreshing:=True;

 try
  LastCalendar:=quCalSelect.Bookmark;
  LastSchedule:=quScheduleSelect.Bookmark;
  LastNormalTime:=mdNormalTime.Bookmark;
 except
 end;

 if quCalSelect.Active then quCalSelect.Close;
 quCalSelect.SQL.Text:=DefaultCalendarSelectStr;

 if ScheduleParams<>nil then
 try
  case ScheduleAction of
   saScheduleSelect:quCalSelect.ParamByName(fldCalendarCalendarID).AsInteger:=GetCurrentCalendarID;
  end;
 except
 end;

 if quScheduleSelect.Active then quScheduleSelect.Close;
 if quShiftSelect.Active then quShiftSelect.Close;

 if not trRead.InTransaction then trRead.StartTransaction;

 try
  quCalSelect.Open;

  quScheduleSelect.Open;

  if ScheduleAction=saScheduleEdit then quShiftSelect.Open;

  trRead.CommitRetaining;
 except
  trRead.RollbackRetaining;
  {$IFDEF DEBUG}
  Raise;
  {$ENDIF}
 end;

 LookupCalendar.Items.Clear;
 quCalSelect.First;
 while not quCalSelect.EOF do
 begin
  LookupCalendar.Items.AddObject(quCalSelect.FieldByName('startdatestr').AsString,
   Pointer(quCalSelect.FieldByName(fldCalendarCalendarID).AsInteger));
  quCalSelect.Next;
 end;

 try
  quCalSelect.Bookmark:=LastCalendar;
  quScheduleSelect.Bookmark:=LastSchedule;
 except
 end;

 try
  for I:=1 to LookupCalendar.Items.Count do
   if Integer(LookupCalendar.Items.Objects[I-1])=quCalSelect.FieldByName(fldCalendarCalendarID).AsInteger then
   begin
    LookupCalendar.ItemIndex:=I-1;
    Break;
   end;
 except
 end;

 if ReCreateGrid then
  if ScheduleAction=saScheduleEdit then RecreateNormalTimeGrid;

 try
  mdNormalTime.Bookmark:=LastNormalTime;
 except
 end;

 for I:=1 to ComponentCount do
  if Components[I-1] is TRxDBGrid then
   with Components[I-1] as TRxDBGrid do
   if (DataSource<>nil)and (DataSource.DataSet<>nil) and DataSource.DataSet.Active then
   try
    SelectedRows.Clear;
    SelectedRows.CurrentRowSelected:=True;
   except
   end;

  ButtonSchAdd.Enabled:=_isPermission(tbSchedule,InsConst);
  ButtonSchEdit.Enabled:=_isPermission(tbSchedule,UpdConst);
  ButtonSchDelete.Enabled:=_isPermission(tbSchedule,DelConst);

 case ScheduleAction of
  saScheduleSelect:ButtonOK.Enabled:=not quScheduleSelect.IsEmpty;
 end;

 Refreshing:=False;
end;

procedure TfrmSchedule.ButtonRefreshTopClick(Sender: TObject);
begin
 DoRefresh(True);
end;

procedure TfrmSchedule.Button1Click(Sender: TObject);
begin
 if ScheduleAction<>saScheduleEdit then Exit;
 Close;
end;

procedure TfrmSchedule.CommonGridEnter(Sender: TObject);
var C:Integer;
begin
 if Sender is TCustomDBGrid then
 begin
  DBNavigator.DataSource:=TCustomDBGrid(Sender).DataSource;
  if TCustomDBGrid(Sender).DataSource.DataSet is TIBQuery then
   C:=GetRecordCount(TCustomDBGrid(Sender).DataSource.DataSet as TIBQuery)
  else
   if TCustomDBGrid(Sender).DataSource.DataSet is TDataSet then
    C:=TDataSet(TCustomDBGrid(Sender).DataSource.DataSet).RecordCount
   else C:=0;
  LabelCount.Enabled:=True;
  LabelCount.Caption:=ViewCountText+Format('%d',[C]);
 end;
end;

procedure TfrmSchedule.CommonGridExit(Sender: TObject);
begin
 if Sender is TCustomDBGrid then
  DBNavigator.DataSource:=nil;
 LabelCount.Enabled:=False;
end;

procedure TfrmSchedule.UpdateScheduleInfo;
var D1,D2:Double;
begin
 D1:=GetStandardCalendarNormForSchedule(quScheduleSelect.FieldByName(fldScheduleScheduleID).AsInteger);
 D2:=GetCalculateCalendarNormForSchedule(quScheduleSelect.FieldByName(fldScheduleScheduleID).AsInteger);
 Edit1.Text:=FloatToStr(D1);
 Edit2.Text:=FloatToStr(D2);
 if D2=D1 then
 begin
  Label4.Font.Style:=[];
  Label4.Font.Color:=clWindowText;
 end
 else
 begin
  Label4.Font.Style:=[fsBold];
  Label4.Font.Color:=clHighlight;
  if D2>D1 then Label4.Caption:='Образующаяся переработка' else Label4.Caption:='Образующаяся недоработка';
 end;
 Edit3.Text:=FloatToStr(Abs(D2-D1));
end;

procedure TfrmSchedule.CommonAfterScroll(DataSet: TDataSet);
begin
 if Refreshing then Exit;
 case DataSet.Tag of
  2:begin
     if GridSchedule.DataSource.DataSet.Active then
     begin
      GridSchedule.SelectedRows.Clear;
      GridSchedule.SelectedRows.CurrentRowSelected:=True;
     end;
     if ScheduleAction=saScheduleEdit then RecreateNormalTimeGrid;
    end;
  3:begin
     if GridNormalTime.DataSource.DataSet.Active then
     begin
      GridNormalTime.SelectedRows.Clear;
      GridNormalTime.SelectedRows.CurrentRowSelected:=True;
     end;
    end;
 end;
end;

procedure TfrmSchedule.GridScheduleGetCellParams(Sender: TObject;
  Field: TField; AFont: TFont; var Background: TColor; Highlight: Boolean);
var Index:Integer;
begin
 with Sender as TRxDBGrid do
 try
 if SelectedRows.Find(Field.DataSet.Bookmark, Index) then
  if SelectedRows[Index]=Field.DataSet.Bookmark then
   SetSelectedRowParams(AFont,Background);
 with Sender as TRxDBGrid do
 if Highlight then
  if Field.DataSet.IsEmpty then Background:=Color else
   SetSelectedColParams(AFont,Background);
 except
 end;
end;

procedure TfrmSchedule.quCalSelectCalcFields(DataSet: TDataSet);
begin
 DataSet.FieldByName('startdatestr').AsString:=FormatDateTime('dd mmmm yyyyг.',
  DataSet.FieldByName(fldCalendarStartDate).AsDateTime);
end;

procedure TfrmSchedule.ButtonSchAddClick(Sender: TObject);
begin
 if ScheduleAction<>saScheduleEdit then Exit;
 if quCalSelect.IsEmpty then Exit;
 if AddSchedule(quCalSelect.FieldByName(fldCalendarCalendarID).AsInteger) then
  DoRefresh(True);
end;

procedure TfrmSchedule.ButtonSchEditClick(Sender: TObject);
begin
 if ScheduleAction=saScheduleEdit then
 begin
  if quCalSelect.IsEmpty or quScheduleSelect.IsEmpty or (not ButtonSchEdit.Enabled) then Exit;
  if EditSchedule(quCalSelect.FieldByName(fldCalendarCalendarID).AsInteger,
   quScheduleSelect.FieldByName(fldScheduleScheduleID).AsInteger) then
  begin
   DoRefresh(False);
   UpdateScheduleInfo;
  end;
 end;
 if (ScheduleAction=saScheduleSelect) and ButtonOK.Enabled then ButtonOK.Click;
end;

procedure TfrmSchedule.ButtonSchDeleteClick(Sender: TObject);
begin
 if ScheduleAction<>saScheduleEdit then Exit;
 if quCalSelect.IsEmpty or quScheduleSelect.IsEmpty then Exit;
 if DeleteSchedule(quCalSelect.FieldByName(fldCalendarCalendarID).AsInteger,
  quScheduleSelect.FieldByName(fldScheduleScheduleID).AsInteger) then
  DoRefresh(True);
end;

procedure TfrmSchedule.btnGridColsSetClick(Sender: TObject);
begin
 SetAdjustColumns(GridSchedule.Columns);
end;

procedure TfrmSchedule.LookupCalendarChange(Sender: TObject);
begin
 if ScheduleAction<>saScheduleEdit then Exit;
 try
  quCalSelect.Locate(fldCalendarCalendarID,Integer(LookupCalendar.Items.Objects[LookupCalendar.ItemIndex]),[]);
  if quScheduleSelect.IsEmpty then RecreateNormalTimeGrid;
 except
 end;
end;

procedure TfrmSchedule.FormPaint(Sender: TObject);
begin
 if not FirstActive then Exit;
 FirstActive:=False;
 SetMinColumnsWidth(GridSchedule.Columns);
// SetMinColumnsWidth(GridNormalTime.Columns);
end;

procedure TfrmSchedule.GridNormalTimeKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
 if ((Key=VK_DELETE) or (Key=VK_BACK)) and
    (GridNormalTime.DataSource.State=dsBrowse) and
    (GridNormalTime.SelectedField.LookupKeyFields<>'') then
 begin
  GridNormalTime.DataSource.DataSet.Edit;
  GridNormalTime.SelectedField.Clear;
  GridNormalTime.DataSource.DataSet.Post;
 end;
end;

procedure TfrmSchedule.MouseToCell2(AGrid: TRxDBGrid; X, Y: Integer; var ACol, ARow: Longint);
begin
 ACol:=-1;
 ARow:=-1;
 if AGrid=nil then Exit;
 AGrid.MouseToCell(X,Y,ACol,ARow);
 if (AGrid.DataSource<>nil) and (AGrid.DataSource.DataSet<>nil) then
  ARow:=AGrid.DataSource.DataSet.RecNo+(ARow-AGrid.Row);
end;

//Получаем скрытое поле для поля данных или nil
function TfrmSchedule.GetHideField(F:TField):TIntegerField;
var DS:TDataSet;
begin
 DS:=F.DataSet;
 try
  Result:=DS.FieldByName(F.KeyFields) as TIntegerField;
 except
  Result:=nil;
 end;
end;

//Очищаем всё
procedure TfrmSchedule.ClearSelecting(ADataSet:TDataSet);
var B:String;
    I:Integer;
begin
 B:=ADataSet.Bookmark;
 ADataSet.DisableControls;
 ADataSet.First;
 while not ADataSet.EOF do
 begin
  ADataSet.Edit;
  for I:=1 to ADataSet.Fields.Count do
  if (ADataSet.Fields[I-1].KeyFields='hide') or //Только для скрытых полей
     (UpperCase(ADataSet.Fields[I-1].FullName)=UpperCase('LEFT')) then
  begin
   //Убираем выделение строк
   ADataSet.Fields[I-1].AsInteger:=0;
   //Убираем выделение заголовков
   ADataSet.Fields[I-1].Tag:=0;
  end;
  ADataSet.Post;
  ADataSet.Next;
 end;
 ADataSet.EnableControls;
 ADataSet.Bookmark:=B;
end;

//Выделяем всё
procedure TfrmSchedule.SelectAll(ADataSet:TDataSet);
var B:String;
    I:Integer;
begin
 B:=ADataSet.Bookmark;
 ADataSet.DisableControls;
 ADataSet.First;
 while not ADataSet.EOF do
 begin
  ADataSet.Edit;
  for I:=1 to ADataSet.Fields.Count do
  begin
   if ADataSet.Fields[I-1].KeyFields='hide' then//Только для скрытых полей
    //Ставим выделение строки
    ADataSet.Fields[I-1].AsInteger:=1;
   //Выделяем заголовок
   if UpperCase(ADataSet.Fields[I-1].FullName)=UpperCase('LEFT') then
    ADataSet.Fields[I-1].Tag:=1;
  end;
  ADataSet.Post;
  ADataSet.Next;
 end;
 ADataSet.EnableControls;
 ADataSet.Bookmark:=B;
end;

procedure TfrmSchedule.mdNormalTimeLeftGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
 Text:='';
end;

procedure TfrmSchedule.GridNormalTimeDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var R:TRect;
begin
 TRxDBGrid(Sender).DefaultDrawColumnCell(Rect,DataCol,Column,State);
 if UpperCase(Column.Field.FullName)='LEFT' then
 begin
  R:=Rect;
  DrawEdge(TRxDBGrid(Sender).Canvas.Handle,R,EDGE_RAISED,BF_BOTTOMRIGHT);
 end else
 if (gdSelected in State) and (Column.Field.LookupKeyFields<>'') then
 begin
  //У выбранного элемента рисуем красный квадрат
  TRxDBGrid(Sender).Canvas.Brush.Color:=clRed;
  TRxDBGrid(Sender).Canvas.Pen.Color:=clRed;
  TRxDBGrid(Sender).Canvas.Rectangle(Rect.Right-6,Rect.Bottom-6,Rect.Right,Rect.Bottom);
 end;
end;

procedure TfrmSchedule.GridNormalTimeGetBtnParams(Sender: TObject;
  Field: TField; AFont: TFont; var Background: TColor;
  var SortMarker: TSortMarker; IsDown: Boolean);
var WorkField:TIntegerField;
begin
 //Подсветка заголовка если выбрана вся колонка
 WorkField:=GetHideField(Field);
 if (WorkField<>nil) and (WorkField.Tag=1) then
 begin
  Background:=clBlack;
  AFont.Color:=clWhite;
 end;
end;

procedure TfrmSchedule.GridNormalTimeGetCellParams(Sender: TObject;
  Field: TField; AFont: TFont; var Background: TColor; Highlight: Boolean);
var WorkField:TIntegerField;
begin
 WorkField:=GetHideField(Field);
 if WorkField<>nil then
 begin
  //Подсветка выделенной ячейки
  if WorkField.AsInteger=1 then
  begin
   Background:=clTeal;
   AFont.Color:=clWhite;
  end;
  //Подсветка ячейки для копирования
  if WorkField.AsInteger=2 then
  begin
   Background:=clGreen;
   AFont.Color:=clWhite;
  end;
 end;
 //Выбранная ячейка
 if Highlight then
 begin
  Background:=clHighlight;
  AFont.Color:=clWhite;
 end;
 //Крайнее левое поле обрабатываем особо
 if UpperCase(Field.FullName)='LEFT' then
 begin
  Background:=clBtnFace;
  AFont.Color:=clBlack;
  //Подсветка заголовка если выбрана вся строка
  if Field.AsInteger=1 then
  begin
   Background:=clBlack;
   AFont.Color:=clWhite;
  end;
 end;
 if (UpperCase(Field.FullName)=UpperCase('ScheduleDate')) or
    (UpperCase(Field.FullName)=UpperCase('Info')) then
  begin Background:=clInfoBk; AFont.Color:=clBtnText end;
end;

procedure TfrmSchedule.GridNormalTimeTitleBtnClick(Sender: TObject;
  ACol: Integer; Field: TField);
var B:String;
    WorkField:TIntegerField;
begin
 if UpperCase(Field.FullName)=UpperCase('LEFT') then
 begin
  SelectAll(Field.DataSet);
  LastSelMode:=smAll;
 end
 else
 begin
  WorkField:=GetHideField(Field);
  if WorkField<>nil then
  begin
   //Очищаем только если не удерживает CTRL
   if ((GetAsyncKeyState(VK_LCONTROL)=0) and (GetAsyncKeyState(VK_RCONTROL)=0)) or
     (LastSelMode<>smCols) then ClearSelecting(Field.DataSet);
   LastSelMode:=smCols;

   B:=WorkField.DataSet.Bookmark;
   WorkField.DataSet.DisableControls;
   WorkField.DataSet.First;
   while not WorkField.DataSet.EOF do
   begin
    WorkField.DataSet.Edit;
    WorkField.AsInteger:=1;
    WorkField.DataSet.Post;
    WorkField.DataSet.Next;
   end;
   WorkField.Tag:=1;
   WorkField.DataSet.EnableControls;
   WorkField.DataSet.Bookmark:=B;
  end;
 end;
end;

procedure TfrmSchedule.GridNormalTimeCellClick(Column: TColumn);
var I:Integer;
begin
 if UpperCase(Column.Field.FullName)=UpperCase('LEFT') then
 begin
  //Очищаем только если не удерживает CTRL
  if ((GetAsyncKeyState(VK_LCONTROL)=0) and (GetAsyncKeyState(VK_RCONTROL)=0)) or
   (LastSelMode<>smRows) then ClearSelecting(Column.Field.DataSet);
  LastSelMode:=smRows;
  Column.Field.DataSet.Edit;
  for I:=1 to Column.Field.DataSet.Fields.Count do
  begin
   if Column.Field.DataSet.Fields[I-1].KeyFields='hide' then//Только для скрытых полей
    //Выделяем саму ячейку
    Column.Field.DataSet.Fields[I-1].AsInteger:=1;
   if UpperCase(Column.Field.DataSet.Fields[I-1].FullName)=UpperCase('LEFT') then
    Column.Field.DataSet.Fields[I-1].AsInteger:=1
  end;
  Column.Field.DataSet.Post;
 end;
end;

procedure TfrmSchedule.GridNormalTimeShowEditor(Sender: TObject;
  Field: TField; var AllowEdit: Boolean);
begin
 AllowEdit:=(UpperCase(Field.FullName)<>UpperCase('LEFT')) and
            (UpperCase(Field.FullName)<>UpperCase('ScheduleDate')) and
            (UpperCase(Field.FullName)<>UpperCase('Info'));
end;

procedure TfrmSchedule.GridNormalTimeMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 if Button=mbRight then
 begin
  MouseToCell2(TRxDBGrid(Sender),X,Y,SCol,SRow);
  if (SCol>0) and (SRow>0) then
   if TRxDBGrid(Sender).Canvas.Pixels[X,Y]=clRed then StartCopy:=True else
    StartSelecting:=True;
 end;
end;

procedure TfrmSchedule.GridNormalTimeMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var Col,Row,C,R,First,Last:Integer;
    B:String;
    WorkField:TIntegerField;
begin
 MouseToCell2(TRxDBGrid(Sender),X,Y,Col,Row);
// Caption:=IntToStr(Row);
 if (Col>0) and (Row>0) then
 begin
  if StartCopy then
  begin
   ClearSelecting(TRxDBGrid(Sender).DataSource.DataSet);
   if Row>Srow then
    begin First:=SRow;Last:=Row;end
   else
    begin First:=Row;Last:=SRow;end;
   B:=TRxDBGrid(Sender).DataSource.DataSet.Bookmark;
   TRxDBGrid(Sender).DataSource.DataSet.DisableControls;
   for R:=First to Last do
   begin
    TRxDBGrid(Sender).DataSource.DataSet.RecNo:=R;
    TRxDBGrid(Sender).DataSource.DataSet.Edit;
    WorkField:=GetHideField(TRxDBGrid(Sender).Columns[SCol].Field);
    if WorkField<>nil then
     WorkField.AsInteger:=2;
    TRxDBGrid(Sender).DataSource.DataSet.Post;
   end;
   TRxDBGrid(Sender).DataSource.DataSet.EnableControls;
   TRxDBGrid(Sender).DataSource.DataSet.Bookmark:=B;
  end;
  if StartSelecting then
  try
   ClearSelecting(TRxDBGrid(Sender).DataSource.DataSet);
   B:=TRxDBGrid(Sender).DataSource.DataSet.Bookmark;
   TRxDBGrid(Sender).DataSource.DataSet.DisableControls;
   for C:=SCol to Col do
   begin
    for R:=SRow to Row do
    begin
     TRxDBGrid(Sender).DataSource.DataSet.RecNo:=R;
     TRxDBGrid(Sender).DataSource.DataSet.Edit;
     WorkField:=GetHideField(TRxDBGrid(Sender).Columns[C].Field);
     if WorkField<>nil then
      WorkField.AsInteger:=1;
     TRxDBGrid(Sender).DataSource.DataSet.Post;
    end;
    TRxDBGrid(Sender).DataSource.DataSet.EnableControls;
    TRxDBGrid(Sender).DataSource.DataSet.Bookmark:=B;
   end;
  except
   StartSelecting:=False;
  end;
 end;
end;

procedure TfrmSchedule.GridNormalTimeMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var Col,Row,R,First,Last:Integer;
    B,V:String;
begin
 MouseToCell2(TRxDBGrid(Sender),X,Y,Col,Row);
 if (Col>0) and (Row>0) then
  if ((SCol=Col) and (SRow=Row)) or StartCopy then
   ClearSelecting(TRxDBGrid(Sender).DataSource.DataSet);
 if StartSelecting then
 begin
  LastSelMode:=smRectangle;
  StartSelecting:=False;
 end;
 if StartCopy then
 begin
  if Row>Srow then
   begin First:=SRow;Last:=Row;end
  else
   begin First:=Row;Last:=SRow;end;
  B:=TRxDBGrid(Sender).DataSource.DataSet.Bookmark;
  TRxDBGrid(Sender).DataSource.DataSet.DisableControls;
  V:=TRxDBGrid(Sender).Columns[SCol].Field.AsString;
  for R:=First to Last do
  begin
   TRxDBGrid(Sender).DataSource.DataSet.RecNo:=R;
   TRxDBGrid(Sender).DataSource.DataSet.Edit;
   TRxDBGrid(Sender).Columns[SCol].Field.AsString:=V;
   TRxDBGrid(Sender).DataSource.DataSet.Post;
  end;
  TRxDBGrid(Sender).DataSource.DataSet.EnableControls;
  TRxDBGrid(Sender).DataSource.DataSet.Bookmark:=B;
  StartCopy:=False;
 end;
end;

procedure TfrmSchedule.ButtonInfoClick(Sender: TObject);
begin
 if Refreshing then Exit;
 if quScheduleSelect.IsEmpty then Exit;
 ShowNormalInfo(quScheduleSelect.FieldByName('name').AsString,quScheduleSelect.FieldByName('schedule_id').AsInteger,quCalSelect.FieldByName(fldCalendarStartDate).AsDateTime,
  GelLastDateForCalendar(quCalSelect.FieldByName(fldCalendarCalendarID).AsInteger));
end;

end.
