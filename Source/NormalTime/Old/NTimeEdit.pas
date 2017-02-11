unit NTimeEdit;

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
    LookupCalendar: TRxLookupEdit;
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
    Panel6: TPanel;
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
    quNormalTimeSelect: TIBQuery;
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
    procedure GridScheduleDblClick(Sender: TObject);
    procedure quCalSelectCalcFields(DataSet: TDataSet);
    procedure GridNormalTimeEditChange(Sender: TObject);
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

uses TypInfo, SysUtils, NTimeData, UMainUnited, DateUtil, StCalendarUtil;

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
   DefaultCalendarSelectStr:='select calendar_id,startdate from calendar ';
  else begin
   DefaultCalendarSelectStr:='select calendar_id,startdate from calendar where calendar_id=:calendar_id ';
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

procedure TfrmSchedule.RecreateNormalTimeGrid;
var D,Last:TDateTime;
    A:Integer;
    F:TFloatField;
begin
 mdNormalTime.DisableControls;
 Screen.Cursor:=crHourGlass;
 mdNormalTime.EmptyTable;
 mdNormalTime.Close;
 try
  for A:=mdNormalTime.Fields.Count downto 1 do
   if mdNormalTime.Fields[A-1].Tag>0 then mdNormalTime.Fields[A-1].Free;
  quShiftSelect.First;A:=1;
  while not quShiftSelect.EOF do
  begin
   F:=TFloatField.Create(mdNormalTime);
   F.Name:='mdNormalTime'+quShiftSelect.FieldByName('name').AsString;
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

  D:=quCalSelect.FieldByName('startdate').AsDateTime;
  Last:=EncodeDate(ExtractYear(D),12,31);
  while D<=Last do
  begin
   mdNormalTime.Append;
   mdNormalTimeScheduleDate.AsDateTime:=D;
   if IsHoliday(D) then
    mdNormalTimeInfo.AsString:='праздник';
   if IsFreeday(D) then
    mdNormalTimeInfo.AsString:='выходной';
   if IsCarryingTo(D) then
    mdNormalTimeInfo.AsString:='пер. выходной';
   if IsCarryingFrom(D) then
    mdNormalTimeInfo.AsString:='';
   if quNormalTimeSelect.Locate('workdate',D,[]) then
    for A:=mdNormalTime.Fields.Count downto 1 do
     if mdNormalTime.Fields[A-1].Tag=quNormalTimeSelect.FieldByName('shift_id').AsInteger then
     begin
      mdNormalTime.Fields[A-1].AsFloat:=quNormalTimeSelect.FieldByName('timecount').AsFloat;
      Break;
     end;
   mdNormalTime.Post;
   D:=IncDay(D,1);
  end;
  if not mdNormalTime.Locate('ScheduleDate',quNormalTimeSelect.FieldByName('workdate').AsDateTime,[]) then
   mdNormalTime.First;
 except
 end;
 Screen.Cursor:=crDefault;
 mdNormalTime.EnableControls;
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
  LastNormalTime:=quNormalTimeSelect.Bookmark;
 end;
 if quCalSelect.Active then quCalSelect.Close;
 quCalSelect.SQL.Text:=DefaultCalendarSelectStr;

 if ScheduleParams<>nil then
  case ScheduleAction of
   saScheduleSelect:quCalSelect.ParamByName('calendar_id').AsInteger:=PScheduleParams(ScheduleParams)^.Calendar_ID;
  end;

 if quScheduleSelect.Active then quScheduleSelect.Close;
 if quNormalTimeSelect.Active then quNormalTimeSelect.Close;
 if quShiftSelect.Active then quShiftSelect.Close;

 if not trRead.InTransaction then trRead.StartTransaction;

 try
  quCalSelect.Open;

  quScheduleSelect.Open;

  if ScheduleAction=saScheduleEdit then
  begin
   quNormalTimeSelect.Open;
   quShiftSelect.Open;
  end;

  trRead.CommitRetaining;
 except
  trRead.RollbackRetaining;
  {$IFDEF DEBUG}
  Raise;
  {$ENDIF}
 end;

 try
  quCalSelect.Bookmark:=LastCalendar;
  quScheduleSelect.Bookmark:=LastSchedule;
  quNormalTimeSelect.Bookmark:=LastNormalTime;
 except
 end;

 LookupCalendar.LookupValue:=quCalSelect.FieldByName('calendar_id').AsString;

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

procedure TfrmSchedule.CommonAfterScroll(DataSet: TDataSet);
begin
 if Refreshing then Exit;
 case DataSet.Tag of
  1:begin
     LastCalendar:=quCalSelect.Bookmark;
     LookupCalendar.LookupValue:=quCalSelect.FieldByName('calendar_id').AsString;
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
  2:LastSchedule:=quScheduleSelect.Bookmark;
  3:LastNormalTime:=quNormalTimeSelect.Bookmark;
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
end;

procedure TfrmSchedule.GridScheduleDblClick(Sender: TObject);
begin
 if (ScheduleAction=saScheduleSelect) and ButtonOK.Enabled then ButtonOK.Click;
end;

procedure TfrmSchedule.quCalSelectCalcFields(DataSet: TDataSet);
begin
 DataSet.FieldByName('startdatestr').AsString:=FormatDateTime('dd mmmm yyyyг.',DataSet.FieldByName('startdate').AsDateTime);
end;

procedure TfrmSchedule.GridNormalTimeEditChange(Sender: TObject);
begin
 //
end;

end.
