unit CalHolidayEdit;

{$I stbasis.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Mask, ToolEdit, StdCtrls, IBDatabase, Db, IBCustomDataSet,
  IBQuery;

type
  TfrmCalHolidayEdit = class(TForm)
    Label1: TLabel;
    Label11: TLabel;
    EditHolidayName: TEdit;
    EditCurDate: TEdit;
    Label2: TLabel;
    EditHolidayDate: TDateEdit;
    Button1: TButton;
    Button2: TButton;
    quTemp: TIBQuery;
    trTemp: TIBTransaction;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
   CurID:Integer;
   CurCalendarDate:TDateTime;
   DoSQLStr:String;
   GetNewID:Boolean;
  public
  end;

function AddCalendarHoliday(Calendar_ID:Integer):Boolean;
function EditCalendarHoliday(Calendar_ID,Holiday_ID:Integer):Boolean;
function DeleteCalendarHoliday(Calendar_ID,Holiday_ID:Integer):Boolean;

implementation

uses DateUtil, CalendarData, UMainUnited;

{$R *.DFM}

function AddCalendarHoliday(Calendar_ID:Integer):Boolean;
var
  frmCalHolidayEdit: TfrmCalHolidayEdit;
begin
 Result:=False;
 frmCalHolidayEdit:=TfrmCalHolidayEdit.Create(Application);
 with frmCalHolidayEdit do
 try
  ChangeDatabase(frmCalHolidayEdit,dbSTBasis);
  CurID:=Calendar_ID;
  quTemp.SQL.Text:=Format('select startdate from calendar where calendar_id=%d',[Calendar_ID]);
  if not trTemp.InTransaction then trTemp.StartTransaction;
  try
   quTemp.Open;
   if quTemp.IsEmpty then raise Exception.Create('Указанный календарь не существует.')
   else CurCalendarDate:=quTemp.FieldByName('startdate').AsDateTime;
  finally
   quTemp.Close;
   trTemp.Commit;
  end;
  Caption:='Добавить праздник';
  EditCurDate.Text:=FormatDateTime('dd mmmm yyyyг.',CurCalendarDate);
  DoSQLStr:='insert into holiday (name,holiday,holiday_id,calendar_id) values (''%s'',CAST(''%s'' AS DATE),%d,%d)';
  GetNewID:=True;
  Result:=frmCalHolidayEdit.ShowModal=mrOK;
 finally
  frmCalHolidayEdit.Free;
 end;
end;

function EditCalendarHoliday(Calendar_ID,Holiday_ID:Integer):Boolean;
var
  frmCalHolidayEdit: TfrmCalHolidayEdit;
begin
 Result:=False;
 frmCalHolidayEdit:=TfrmCalHolidayEdit.Create(Application);
 with frmCalHolidayEdit do
 try
  ChangeDatabase(frmCalHolidayEdit,dbSTBasis);
  CurID:=Holiday_ID;
  quTemp.SQL.Text:=Format('select startdate from calendar where calendar_id=%d',[Calendar_ID]);
  if not trTemp.InTransaction then trTemp.StartTransaction;
  try
   quTemp.Open;
   if quTemp.IsEmpty then raise Exception.Create('Указанный календарь не существует.')
   else CurCalendarDate:=quTemp.FieldByName('startdate').AsDateTime;
  finally
   quTemp.Close;
   trTemp.Commit;
  end;
  quTemp.SQL.Text:=Format('select name,holiday from holiday where holiday_id=%d',[Holiday_ID]);
  if not trTemp.InTransaction then trTemp.StartTransaction;
  try
   quTemp.Open;
   if quTemp.IsEmpty then raise Exception.Create('Нет данных для отображения.')
   else begin
    EditHolidayName.Text:=quTemp.FieldByName('name').AsString;
    EditHolidayDate.Date:=quTemp.FieldByName('holiday').AsDateTime;
   end;
  finally
   quTemp.Close;
   trTemp.Commit;
  end;
  Caption:='Изменить праздник';
  EditCurDate.Text:=FormatDateTime('dd mmmm yyyyг.',CurCalendarDate);
  DoSQLStr:='update holiday set name=''%s'',holiday=CAST(''%s'' AS DATE),holiday_id=%d where holiday_id=%d';
  GetNewID:=False;
  Result:=frmCalHolidayEdit.ShowModal=mrOK;
 finally
  frmCalHolidayEdit.Free;
 end;
end;

function DeleteCalendarHoliday(Calendar_ID,Holiday_ID:Integer):Boolean;
var
  frmCalHolidayEdit: TfrmCalHolidayEdit;
  HolidayName:String;
  HolidayCalendar:TDateTime;
begin
 Result:=False;
 frmCalHolidayEdit:=TfrmCalHolidayEdit.Create(Application);
 with frmCalHolidayEdit do
 try
  ChangeDatabase(frmCalHolidayEdit,dbSTBasis);
  quTemp.SQL.Text:=Format('select startdate from calendar where calendar_id=%d',[Calendar_ID]);
  if not trTemp.InTransaction then trTemp.StartTransaction;
  quTemp.Open;
  if quTemp.IsEmpty then raise Exception.Create('Указанный календарь не существует.')
   else HolidayCalendar:=quTemp.FieldByName('startdate').AsDateTime;
  quTemp.Close;
  quTemp.SQL.Text:=Format('select name from holiday where holiday_id=%d',[Holiday_ID]);
  quTemp.Open;
  if quTemp.IsEmpty then raise Exception.Create('Нет данных для отображения.')
   else HolidayName:=quTemp.FieldByName('name').AsString;
  quTemp.Close;
  if Application.MessageBox(PChar(Format('Удалить праздник "%s" календаря от %s?',[HolidayName,FormatDateTime('dd mmmm yyyyг.',HolidayCalendar)])),'Подтверждение',mb_YesNo+mb_IconQuestion)=mrYes then
  begin
   quTemp.SQL.Text:=Format('delete from holiday where holiday_id=%d',[Holiday_ID]);
   if not trTemp.InTransaction then trTemp.StartTransaction;
   try
    quTemp.ExecSQL;
    trTemp.Commit;
    Result:=True;
   except
    trTemp.Rollback;
   end;
  end;
 finally
  frmCalHolidayEdit.Free;
 end;
end;

procedure TfrmCalHolidayEdit.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var Holiday_ID:Integer;
begin
 CanClose:=True;
 if ModalResult=mrOK then
 begin
  if EditHolidayDate.Date=0 then
  begin
   ShowInfo(Handle,Format('Укажите значение в поле "%s".',[Label2.Caption]));
   EditHolidayDate.SetFocus;
   CanClose:=False;
   Exit;
  end;
  if GetNewID then Holiday_ID:=GetGenId(dbSTBasis,'holiday',1) else Holiday_ID:=CurID;
  quTemp.SQL.Text:=Format(DoSQLStr,[EditHolidayName.Text,FormatDateTime('dd/mm/yyyy',EncodeDate(ExtractYear(CurCalendarDate),ExtractMonth(EditHolidayDate.Date),ExtractDay(EditHolidayDate.Date))),
                          Holiday_ID,CurID]);
  if not trTemp.InTransaction then trTemp.StartTransaction;
  try
   quTemp.ExecSQL;
   trTemp.Commit;
  except
   trTemp.Rollback;
   CanClose:=False;
   {$IFDEF DEBUG}
   Raise;
   {$ENDIF}
  end;
 end;
end;

end.
