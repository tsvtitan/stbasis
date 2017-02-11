unit NTimeInfo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Db, RxMemDS, Grids, DBGrids, RXDBCtrl, Placemnt, IBDatabase,
  IBCustomDataSet, IBQuery, StdCtrls, ExtCtrls, Buttons;

type
  TftmNTimeInfo = class(TForm)
    mdInfo: TRxMemoryData;
    mdInfoName: TStringField;
    GridInfo: TRxDBGrid;
    dsInfo: TDataSource;
    mdInfoCommonSumma: TFloatField;
    quShiftSelect: TIBQuery;
    trRead: TIBTransaction;
    Panel1: TPanel;
    ButtonRefresh: TButton;
    Label1: TLabel;
    LabelSchedule: TLabel;
    Label3: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    ComboBoxCalendar: TComboBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mdInfoCalcFields(DataSet: TDataSet);
    procedure ButtonRefreshClick(Sender: TObject);
    procedure GridInfoGetCellParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; Highlight: Boolean);
    procedure GridInfoTitleBtnClick(Sender: TObject; ACol: Integer;
      Field: TField);
    procedure Panel1Resize(Sender: TObject);
    procedure SpeedButtonsClick(Sender: TObject);
    procedure ComboBoxCalendarChange(Sender: TObject);
  private
    FSchedule_id:Integer;
    FInfoInHour:Boolean;
    FStartDate,FEndDate:TDateTime;
  public
   procedure DoUpdate;//(EmpPlant_id:Integer;StartDate,EndDate:TDateTime);
  end;

procedure ShowNormalInfo(ScheduleName:String;Schedule_id:Integer;StartDate,EndDate:TDateTime);
procedure HideNormalInfo;

implementation

{$R *.DFM}

uses DateUtil, UMainUnited, NTimeData, StCalendarUtil;

var ftmNTimeInfo:TftmNTimeInfo;

procedure ShowNormalInfo(ScheduleName:String;Schedule_id:Integer;StartDate,EndDate:TDateTime);
var I:Integer;
begin
 if ftmNTimeInfo=nil then
  ftmNTimeInfo:=TftmNTimeInfo.Create(Application);
 if ftmNTimeInfo<>nil then
 with ftmNTimeInfo do
 begin
  LabelSchedule.Caption:=ScheduleName;
  FSchedule_id:=Schedule_id;
  FStartDate:=StartDate;
  FEndDate:=EndDate;
  FInfoInHour:=True;
  ComboBoxCalendar.Items.Clear;
  ComboBoxCalendar.Items.Add('Весь календарь с '+FormatDateTime('dd mmmm yyyyг.',StartDate)+' по '+FormatDateTime('dd mmmm yyyyг.',EndDate));
  for I:=1 to Round(MonthsBetween(StartDate,EndDate)) do
   ComboBoxCalendar.Items.Add('За месяц '+FormatDateTime('mmmm yyyyг.',IncMonth(StartDate,I-1)));
  ComboBoxCalendar.ItemIndex:=0;
  ftmNTimeInfo.DoUpdate;
  ftmNTimeInfo.Show;
 end;
end;

procedure HideNormalInfo;
begin
 if ftmNTimeInfo<>nil then
 begin
  ftmNTimeInfo.Free;
  ftmNTimeInfo:=nil;
 end;
end;

procedure TftmNTimeInfo.DoUpdate;//(EmpPlant_id:Integer;StartDate,EndDate:TDateTime);
var A:Integer;
    F1:TFloatField;
    StartDate,EndDate:TDateTime;
    IDs1:TRecordsIDs;
begin
 SetLength(IDs1,1);
 if quShiftSelect.Active then quShiftSelect.Close;
// if quAbsenceSelect.Active then quAbsenceSelect.Close;
 try
  quShiftSelect.Open;
//  quAbsenceSelect.Open;
 except
  Exit;
 end;
 mdInfo.DisableControls;
 mdInfo.EmptyTable;
 mdInfo.Close;
 try
  for A:=mdInfo.Fields.Count downto 1 do
   if mdInfo.Fields[A-1].Tag>0 then mdInfo.Fields[A-1].Free;
  GridInfo.Columns.RebuildColumns;

  quShiftSelect.First;A:=1;
  while not quShiftSelect.EOF do
  begin
   F1:=TFloatField.Create(mdInfo);
   F1.Name:='mdInfoShift'+quShiftSelect.FieldByName(fldShiftShiftID).AsString;
   F1.DisplayLabel:=quShiftSelect.FieldByName(fldShiftName).AsString;
   F1.FieldKind:=fkData;
   F1.FieldName:='Shift'+IntToStr(A);
   F1.DataSet:=mdInfo;
   F1.Tag:=quShiftSelect.FieldByName(fldShiftShiftID).AsInteger;

   quShiftSelect.Next;
   Inc(A);
  end;

  GridInfo.Columns.RebuildColumns;

  for A:=1 to GridInfo.Columns.Count do
   if UpperCase(GridInfo.Columns[A-1].Field.FullName)='NAME' then
    GridInfo.Columns[A-1].Width:=200;

  for A:=1 to GridInfo.Columns.Count do
   if UpperCase(GridInfo.Columns[A-1].Field.FullName)='COMMONSUMMA' then
   begin
    GridInfo.Columns[A-1].Index:=GridInfo.Columns.Count-1;
    Break;
   end;

 except
 end;
 try
  mdInfo.Open;
 except
 end;

 if ComboBoxCalendar.ItemIndex=0 then
 begin
  StartDate:=FStartDate;
  EndDate:=FEndDate;
 end
 else
 begin
  StartDate:=IncMonth(FStartDate,ComboBoxCalendar.ItemIndex-1);
  EndDate:=IncMonth(StartDate,1);
  EndDate:=EncodeDate(ExtractYear(EndDate),ExtractMonth(EndDate),1);
  EndDate:=IncDay(EndDate,-1);
 end;
 try
  mdInfo.Append;
  mdInfo.FieldByName('Name').AsString:='Рабочие';
  for A:=1 to mdInfo.Fields.Count do
   if mdInfo.Fields[A-1].Tag>0 then
   begin
    IDs1[0]:=mdInfo.Fields[A-1].Tag;
    mdInfo.Fields[A-1].AsFloat:=GetNormalTime(FSchedule_ID,IDs1,StartDate,EndDate,FInfoInHour,[dtOrdinary]);
   end;
  mdInfo.Post;
  mdInfo.Append;
  mdInfo.FieldByName('Name').AsString:='Выходные';
  for A:=1 to mdInfo.Fields.Count do
   if mdInfo.Fields[A-1].Tag>0 then
   begin
    IDs1[0]:=mdInfo.Fields[A-1].Tag;
    mdInfo.Fields[A-1].AsFloat:=GetNormalTime(FSchedule_ID,IDs1,StartDate,EndDate,FInfoInHour,[dtFree]);
   end; 
  mdInfo.Post;
  mdInfo.Append;
  mdInfo.FieldByName('Name').AsString:='Праздничные';
  for A:=1 to mdInfo.Fields.Count do
   if mdInfo.Fields[A-1].Tag>0 then
   begin
    IDs1[0]:=mdInfo.Fields[A-1].Tag;
    mdInfo.Fields[A-1].AsFloat:=GetNormalTime(FSchedule_ID,IDs1,StartDate,EndDate,FInfoInHour,[dtHoliday]);
   end; 
  mdInfo.Post;
  mdInfo.Append;
  mdInfo.FieldByName('Name').AsString:='Календарные';
  for A:=1 to mdInfo.Fields.Count do
   if mdInfo.Fields[A-1].Tag>0 then
   begin
    IDs1[0]:=mdInfo.Fields[A-1].Tag;
    mdInfo.Fields[A-1].AsFloat:=GetNormalTime(FSchedule_ID,IDs1,StartDate,EndDate,FInfoInHour,[dtOrdinary,dtFree,dtHoliday]);
   end; 
  mdInfo.Post;
 except
 end;

 if not mdInfo.IsEmpty then mdInfo.First;
 mdInfo.EnableControls;
end;

procedure TftmNTimeInfo.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 Action:=caFree;
end;

procedure TftmNTimeInfo.FormDestroy(Sender: TObject);
begin
 ftmNTimeInfo:=nil;
end;

procedure TftmNTimeInfo.FormCreate(Sender: TObject);
begin
 ChangeDatabase(Self,dbSTBasis);
 AssignFont(_GetOptions.RBTableFont,GridInfo.Font);
 GridInfo.TitleFont.Assign(GridInfo.Font);
end;

procedure TftmNTimeInfo.mdInfoCalcFields(DataSet: TDataSet);
var A:Integer;
    S:Double;
begin
 S:=0;
 for A:=1 to DataSet.Fields.Count do
  if DataSet.Fields[A-1].Tag>0 then
   S:=S+DataSet.Fields[A-1].AsFloat;
 DataSet.FieldByName('CommonSumma').AsFloat:=S;
end;

procedure TftmNTimeInfo.ButtonRefreshClick(Sender: TObject);
begin
 DoUpdate;
end;

procedure TftmNTimeInfo.GridInfoGetCellParams(Sender: TObject;
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

procedure TftmNTimeInfo.GridInfoTitleBtnClick(Sender: TObject;
  ACol: Integer; Field: TField);
begin
 mdInfo.SortOnFields(Field.FullName);
end;

procedure TftmNTimeInfo.Panel1Resize(Sender: TObject);
begin
 ComboBoxCalendar.Width:=Panel1.Width-ComboBoxCalendar.Left-ButtonRefresh.Width-8;
end;

procedure TftmNTimeInfo.SpeedButtonsClick(Sender: TObject);
begin
 FInfoInHour:=SpeedButton1.Down;
 DoUpdate;
end;

procedure TftmNTimeInfo.ComboBoxCalendarChange(Sender: TObject);
begin
 DoUpdate;
end;

end.
