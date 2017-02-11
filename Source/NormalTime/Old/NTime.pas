unit NTime;

{$I stbasis.inc}

interface

uses
  Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs, NTimeCode,
  Placemnt, StdCtrls, Mask, ToolEdit, RxLookup, ExtCtrls, Db, RxMemDS,
  Grids, DBGrids, RXDBCtrl, IBCustomDataSet, IBQuery, ComCtrls, IBDatabase,
  DBCtrls;

type
  TfrmSchedule = class(TForm)
    FormStorage: TFormStorage;
    PanelTop: TPanel;
    Label1: TLabel;
    PanelBottom: TPanel;
    PanelClose: TPanel;
    Button1: TButton;
    mdNormalTime: TRxMemoryData;
    dsNormalTime: TDataSource;
    GridSchedule: TRxDBGrid;
    Splitter: TSplitter;
    ButtonSchAdd: TButton;
    ButtonSchEdit: TButton;
    ButtonSchDelete: TButton;
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
    ButtonRefreshTop: TButton;
    quScheduleSelect: TIBQuery;
    dsScheduleSelect: TDataSource;
    quShiftSelect: TIBQuery;
    PanelSelecting: TPanel;
    ButtonRefresh: TButton;
    btnGridColsSet: TButton;
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
    Label7: TLabel;
    quNTimeChange: TIBQuery;
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
  private
    { Private declarations }
   ScheduleAction:TScheduleAction;
   ScheduleParams:Pointer;
   Refreshing:Boolean;
   DefaultCalendarSelectStr:String;
   function GetLastCalendar:String;
   procedure SetLastCalendar(L:String);
   function GetLastSchedule:String;
   procedure SetLastSchedule(L:String);
   function GetLastNormalTime:String;
   procedure SetLastNormalTime(L:String);
   procedure UpdateScheduleInfo;
  public
    { Public declarations }
   constructor Create(AOwner:TComponent;AScheduleAction:TScheduleAction;AParams:Pointer); virtual;
   procedure RecreateNormalTimeGrid;
   procedure DoRefresh(FirstOnce:Boolean);
   property LastCalendar:String read GetLastCalendar write SetLastCalendar;
   property LastSchedule:String read GetLastSchedule write SetLastSchedule;
   property LastNormalTime:String read GetLastNormalTime write SetLastNormalTime;
  end;

var
  frmSchedule: TfrmSchedule;

implementation

{$R *.DFM}

uses TypInfo, SysUtils, StrUtils, NTimeData, UMainUnited, DateUtil, StCalendarUtil,
  NTimeScheduleEdit, UAdjust;

constructor TfrmSchedule.Create(AOwner: TComponent;AScheduleAction:TScheduleAction;AParams:Pointer);
begin
 ScheduleAction:=AScheduleAction;
 ScheduleParams:=AParams;
 inherited Create(AOwner);

 FormStorage.IniFileName:=_GetIniFileName;
 FormStorage.IniSection:=Copy(GetEnumName(TypeInfo(TScheduleAction),Integer(ScheduleAction)),3,100);
 FormStorage.Active:=True;

 if ScheduleAction=saScheduleEdit then begin
   Caption:='Графики норм';
   PanelSelecting.Visible:=False;
   FormStyle:=fsMDIChild;
 end
 else begin
  case ScheduleAction of
   saScheduleSelect:Caption:='Выбор графика';
  end;
  if ScheduleAction=saScheduleSelect then
  begin
   GridNormalTime.Visible:=False;
   GridSchedule.Align:=alClient;
  end;
  PanelTop.Visible:=False;
  Splitter.Visible:=False;
  PanelSelecting.Visible:=True;
  PanelClose.Visible:=False;
  PanelOKCancel.Visible:=True;
  BorderStyle:=bsSizeable;
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

 DoRefresh(True);//This is first refresh!!!

 case ScheduleAction of
  saScheduleSelect:begin
   if not quScheduleSelect.IsEmpty then
    {PageControl.Pages[0].}Caption:=Format('Графики календаря от %s',[FormatDateTime('dd mmmm yyyyг.',quCalSelect.FieldByName('startdate').AsDateTime)]);
   if ScheduleParams<>nil then
    quScheduleSelect.Locate('schedule_id',PScheduleParams(ScheduleParams)^.Schedule_ID,[]);
  end;
 end;
end;

procedure TfrmSchedule.FormDestroy(Sender: TObject);
begin
 if ScheduleAction=saScheduleEdit then frmSchedule:=nil;
end;

procedure TfrmSchedule.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 if ScheduleAction=saScheduleEdit then Action:=caFree;
 if (ModalResult=mrOK) and (ScheduleParams<>nil) then
 case ScheduleAction of
  saScheduleSelect:begin
   PScheduleParams(ScheduleParams)^.Schedule_ID:=quScheduleSelect.FieldByName('schedule_id').AsInteger;
   PScheduleParams(ScheduleParams)^.AvgYear:=quScheduleSelect.FieldByName('avgyear').AsFloat;
   PScheduleParams(ScheduleParams)^.Name:=quScheduleSelect.FieldByName('name').AsString;
  end;
 end;
 Application.Hint:='';
end;

procedure TfrmSchedule.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
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
 LookupCalendar.Width:=PanelTop.Width-LookupCalendar.Left-4;
end;

procedure TfrmSchedule.mdNormalTimeScheduleDateChange(Sender: TField);
var NewID:Integer;
begin
 quNTimeChange.SQL.Text:=Format('delete from normaltime where (shift_id=%d) and (schedule_id=%d) and (workdate=CAST(''%s'' AS DATE))',[Sender.Tag,quScheduleSelect.FieldByName('schedule_id').AsInteger,mdNormalTimeScheduleDate.AsString]);
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
  NewID:=GetGenId(dbSTBasis,'normaltime',1);
  quNTimeChange.SQL.Text:=Format('insert into normaltime (normaltime_id,shift_id,schedule_id,workdate,timecount) values (%d,%d,%d,CAST(''%s'' AS DATE),%s)',[NewID,Sender.Tag,quScheduleSelect.FieldByName('schedule_id').AsInteger,mdNormalTimeScheduleDate.AsString,ReplaceStr(Sender.AsString,',','.')]);
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
    A:Integer;
    F:TFloatField;
    CurNormalTime:Double;
    B:String;
begin
 //Объявляем о начале рефреша
 Refreshing:=True;
 mdNormalTime.DisableControls;
 PanelWait.BringToFront;

 PanelTop.Enabled:=False;
 PanelBottom.Enabled:=False;
 GridSchedule.Enabled:=False;

 mdNormalTime.EmptyTable;
 mdNormalTime.Close;
 try
  for A:=mdNormalTime.Fields.Count downto 1 do
   if mdNormalTime.Fields[A-1].Tag>0 then mdNormalTime.Fields[A-1].Free;
  for A:=1 to GridNormalTime.Columns.Count do
    GridNormalTime.Columns[A-1].ReadOnly:=False;
  quShiftSelect.First;A:=1;
  while not quShiftSelect.EOF do
  begin
   F:=TFloatField.Create(mdNormalTime);
   F.Name:='mdNormalTimeShift'+quShiftSelect.FieldByName('shift_id').AsString;
   F.DisplayLabel:=quShiftSelect.FieldByName('name').AsString;
   F.FieldKind:=fkData;
   F.FieldName:='Shift'+IntToStr(A);
   F.Tag:=quShiftSelect.FieldByName('shift_id').AsInteger;
   F.DataSet:=mdNormalTime;
   quShiftSelect.Next;
   Inc(A);
  end;
 except
 end;
 try
  mdNormalTime.Open;
 except
 end;
 if not quScheduleSelect.IsEmpty then
 try
  B:=quCalSelect.Bookmark;
  quCalSelect.DisableControls;
  D:=quCalSelect.FieldByName('startdate').AsDateTime;
  quCalSelect.Next;
  Last:=quCalSelect.FieldByName('startdate').AsDateTime;
  if Last=D then Last:=EncodeDate(ExtractYear(D),12,31) else Last:=IncDay(Last,-1);
  quCalSelect.Bookmark:=B;
  quCalSelect.EnableControls;
  ProgressBar.Position:=0;
  ProgressBar.Max:=DaysBetween(D,Last);
  while D<=Last do
  begin
   mdNormalTime.Append;
   mdNormalTimeScheduleDate.AsDateTime:=D;
   if IsFreeday(D) then
    mdNormalTimeInfo.AsString:='выходной';
   if IsCarryingFrom(D) then
    mdNormalTimeInfo.AsString:='';
   if IsCarryingTo(D) then
    mdNormalTimeInfo.AsString:='пер. выходной';
   if IsHoliday(D) then
    mdNormalTimeInfo.AsString:='праздник';
   for A:=1 to mdNormalTime.Fields.Count do
    if mdNormalTime.Fields[A-1].Tag>0 then
    begin
     CurNormalTime:=GetNormalTime(quScheduleSelect.FieldByName('schedule_id').AsInteger,mdNormalTime.Fields[A-1].Tag,D);
     if CurNormalTime>0 then  mdNormalTime.Fields[A-1].AsFloat:=CurNormalTime;
    end;
   mdNormalTime.Post;
   ProgressBar.StepIt;
   Application.ProcessMessages;
   D:=IncDay(D,1);
  end;
  if not mdNormalTime.Locate('ScheduleDate',0,[]) then
   mdNormalTime.First;
  for A:=mdNormalTime.Fields.Count downto 1 do
   if mdNormalTime.Fields[A-1].Tag>0 then mdNormalTime.Fields[A-1].OnChange:=mdNormalTimeScheduleDateChange;

  GridNormalTime.Color:=clWindow;
 except
 end else GridNormalTime.Color:=clBtnFace;
 GridNormalTime.Enabled:=not quScheduleSelect.IsEmpty;

 PanelTop.Enabled:=True;
 PanelBottom.Enabled:=True;
 GridSchedule.Enabled:=True;

 UpdateScheduleInfo;

 mdNormalTime.EnableControls;
 PanelWait.SendToBack;

 for A:=1 to GridNormalTime.Columns.Count do
  if GridNormalTime.Columns[A-1].Field.Tag=0 then
   GridNormalTime.Columns[A-1].ReadOnly:=True;

 Refreshing:=False;
end;

procedure TfrmSchedule.DoRefresh(FirstOnce:Boolean);
var I:Integer;
begin
 //Объявляем о начале рефреша
 Refreshing:=True;
 //При первом разе запоминать в ini ненадо!
 if not FirstOnce then
 begin
  LastCalendar:=quCalSelect.Bookmark;
  LastSchedule:=quScheduleSelect.Bookmark;
//  LastNormalTime:=quNormalTimeSelect.Bookmark;
 end;
 if quCalSelect.Active then quCalSelect.Close;
 quCalSelect.SQL.Text:=DefaultCalendarSelectStr;

 if ScheduleParams<>nil then
  case ScheduleAction of
   saScheduleSelect:quCalSelect.ParamByName('calendar_id').AsInteger:=PScheduleParams(ScheduleParams)^.Calendar_ID;
  end;

 if quScheduleSelect.Active then quScheduleSelect.Close;
// if quNormalTimeSelect.Active then quNormalTimeSelect.Close;
 if quShiftSelect.Active then quShiftSelect.Close;

 if not trRead.InTransaction then trRead.StartTransaction;

 try
  quCalSelect.Open;

  quScheduleSelect.Open;

  if ScheduleAction=saScheduleEdit then
  begin
//   quNormalTimeSelect.Open;
   quShiftSelect.Open;
  end;

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
  LookupCalendar.Items.AddObject(quCalSelect.FieldByName('startdatestr').AsString,Pointer(quCalSelect.FieldByName('calendar_id').AsInteger));
  quCalSelect.Next;
 end;

 try
  quCalSelect.Bookmark:=LastCalendar;
  quScheduleSelect.Bookmark:=LastSchedule;
//  quNormalTimeSelect.Bookmark:=LastNormalTime;
 except
 end;

 try
  for I:=1 to LookupCalendar.Items.Count do
   if Integer(LookupCalendar.Items.Objects[I-1])=quCalSelect.FieldByName('calendar_id').AsInteger then
   begin
    LookupCalendar.ItemIndex:=I-1;
    Break;
   end;
 except
 end;

 RecreateNormalTimeGrid;

 for I:=1 to ComponentCount do
  if Components[I-1] is TRxDBGrid then
   with Components[I-1] as TRxDBGrid do
   if DataSource.DataSet.Active then
   try
    SelectedRows.Clear;
    SelectedRows.CurrentRowSelected:=True;
   except
   end;

 if ScheduleAction=saScheduleEdit then
 begin
  ButtonSchAdd.Enabled:=_isPermission(tbSchedule,InsConst);
  ButtonSchEdit.Enabled:=_isPermission(tbSchedule,UpdConst);
  ButtonSchDelete.Enabled:=_isPermission(tbSchedule,DelConst);
 end;

 case ScheduleAction of
  saScheduleSelect:ButtonOK.Enabled:=not quScheduleSelect.IsEmpty;
 end;

 Refreshing:=False;
end;

function TfrmSchedule.GetLastCalendar:String;
begin
 try
  Result:=HexStrToString(FormStorage.StoredValue['LastCalendar']);
 except
  Result:='';
 end;
end;

procedure TfrmSchedule.SetLastCalendar(L:String);
begin
 try
  FormStorage.StoredValue['LastCalendar']:=StringToHexStr(L);
 except
 end;
end;

function TfrmSchedule.GetLastSchedule:String;
begin
 try
  Result:=HexStrToString(FormStorage.StoredValue['LastSchedule']);
 except
  Result:='';
 end;
end;

procedure TfrmSchedule.SetLastSchedule(L:String);
begin
 try
  FormStorage.StoredValue['LastSchedule']:=StringToHexStr(L);
 except
 end;
end;

function TfrmSchedule.GetLastNormalTime:String;
begin
 try
  Result:=HexStrToString(FormStorage.StoredValue['LastNormalTime']);
 except
  Result:='';
 end;
end;

procedure TfrmSchedule.SetLastNormalTime(L:String);
begin
 try
  FormStorage.StoredValue['LastNormalTime']:=StringToHexStr(L);
 except
 end;
end;

procedure TfrmSchedule.ButtonRefreshTopClick(Sender: TObject);
begin
 DoRefresh(False);
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
 D1:=GetStandardCalendarNormForSchedule(quScheduleSelect.FieldByName('schedule_id').AsInteger);
 D2:=GetCalculateCalendarNormForSchedule(quScheduleSelect.FieldByName('schedule_id').AsInteger);
 Edit1.Text:=FloatToStr(D1);
 Edit2.Text:=FloatToStr(D2);
 if D2>=D1 then Label4.Caption:='Образующаяся переработка' else Label4.Caption:='Образующаяся недоработка';
 Edit3.Text:=FloatToStr(Abs(D2-D1));
end;

procedure TfrmSchedule.CommonAfterScroll(DataSet: TDataSet);
begin
 if Refreshing then Exit;
 case DataSet.Tag of
  1:begin
     LastCalendar:=quCalSelect.Bookmark;
//     LookupCalendar.LookupValue:=quCalSelect.FieldByName('calendar_id').AsString;
     //Переделать!!!!!!!!
{     if GridCalendar.DataSource.DataSet.Active then
     begin
      GridCalendar.SelectedRows.Clear;
      GridCalendar.SelectedRows.CurrentRowSelected:=True;
     end;
     if GridHoliday.DataSource.DataSet.Active then
     begin
      GridHoliday.SelectedRows.Clear;
      GridHoliday.SelectedRows.CurrentRowSelected:=True;
     end;
     if GridCarry.DataSource.DataSet.Active then
     begin
      GridCarry.SelectedRows.Clear;
      GridCarry.SelectedRows.CurrentRowSelected:=True;
     end;}
    end;
  2:begin
     LastSchedule:=quScheduleSelect.Bookmark;
     RecreateNormalTimeGrid;
    end;
//  3:LastNormalTime:=quNormalTimeSelect.Bookmark;
 end;
end;

procedure TfrmSchedule.GridNormalTimeGetCellParams(Sender: TObject;
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
 if (Field.DataSet=mdNormalTime) and (Field.Tag=0) then begin Background:=clBtnFace; AFont.Color:=clBtnText end;
end;

procedure TfrmSchedule.quCalSelectCalcFields(DataSet: TDataSet);
begin
 DataSet.FieldByName('startdatestr').AsString:=FormatDateTime('dd mmmm yyyyг.',DataSet.FieldByName('startdate').AsDateTime);
end;

procedure TfrmSchedule.ButtonSchAddClick(Sender: TObject);
begin
 if ScheduleAction<>saScheduleEdit then Exit;
 if quCalSelect.IsEmpty then Exit;
 if AddSchedule(quCalSelect.FieldByName('calendar_id').AsInteger) then
  DoRefresh(False);
end;

procedure TfrmSchedule.ButtonSchEditClick(Sender: TObject);
begin
 if ScheduleAction=saScheduleEdit then
 begin
  if quCalSelect.IsEmpty or quScheduleSelect.IsEmpty then Exit;
  if EditSchedule(quCalSelect.FieldByName('calendar_id').AsInteger,quScheduleSelect.FieldByName('schedule_id').AsInteger) then
   DoRefresh(False);
 end;
 if (ScheduleAction=saScheduleSelect) and ButtonOK.Enabled then ButtonOK.Click;
end;

procedure TfrmSchedule.ButtonSchDeleteClick(Sender: TObject);
begin
 if ScheduleAction<>saScheduleEdit then Exit;
 if quCalSelect.IsEmpty or quScheduleSelect.IsEmpty then Exit;
 if DeleteSchedule(quCalSelect.FieldByName('calendar_id').AsInteger,quScheduleSelect.FieldByName('schedule_id').AsInteger) then
  DoRefresh(False);
end;

procedure TfrmSchedule.btnGridColsSetClick(Sender: TObject);
begin
 SetAdjustColumns(GridSchedule.Columns);
end;

procedure TfrmSchedule.LookupCalendarChange(Sender: TObject);
begin
 try
  quCalSelect.Locate('calendar_id',Integer(LookupCalendar.Items.Objects[LookupCalendar.ItemIndex]),[]);
  if quScheduleSelect.IsEmpty then RecreateNormalTimeGrid;
 except
 end;
end;

end.
