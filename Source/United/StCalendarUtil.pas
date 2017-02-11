unit StCalendarUtil;

{$I stbasis.inc}

interface

uses IBDatabase, IBCustomDataSet, DB, IBQuery;

type

 TDayType=(dtOrdinary,dtFree,dtHoliday);
 TDayTypes=set of TDayType;

 TRecordsIDs=array of Integer;

procedure InitCalendarUtil(DB:TIBDatabase);
procedure DoneCalendarUtil;
function isCalendarUtilInit:Boolean;

function GetCurrentCalendarID:Integer;
function GelLastDateForCalendar(Calendar_ID:Integer):TDateTime;

function GetNormalTime(Schedule_id:Integer;Shift_ids:TRecordsIDs;StartDate,EndDate:TDateTime;GetInHour:Boolean;IncludeDayTypes:TDayTypes):Double;
function GetActualTime(EmpPlant_id:Integer;Absence_ids,Shift_ids:TRecordsIDs;StartDate,EndDate:TDateTime;GetInHour:Boolean):Double;
function GetActualOverTime(EmpPlant_id:Integer;Absence_ids,Shift_ids:TRecordsIDs;StartDate,EndDate:TDateTime;OverTimeScope:Double):Double;

function FillActualTimePeriod(EmpPlant_ids,Shift_ids:TRecordsIDs;StartDate,EndDate:TDateTime;Absence_id:Integer;AValue:Double):Boolean;
function CopyActualTimeFromNormalTime(EmpPlant_ids:TRecordsIDs;StartDate,EndDate:TDateTime;Absence_id:Integer):Boolean;

//Получить график для сотрудника !!!!! АНДРЕЙ, ЧТО ДЕЛАТЬ? !!!!!
function GetEmpPlantSchedule(EmpPlant_Id:Integer):Integer;

function GetStandardCalendarNormForSchedule(Schedule_ID:Integer):Double;
function GetCalculateCalendarNormForSchedule(Schedule_ID:Integer):Double;
function IsHoliday(D:TDateTime):Boolean;
function IsFreeDay(D:TDateTime):Boolean;
function IsLastDay(D:TDateTime):Boolean;
function GetWorkingDaysInMonth(D:TDateTime):Byte;
//function GetNormalWorkingHoursInMonth(D:TDateTime):Double;
function GetExceptWorkingHoursInMonthForWeek(D:TDateTime;WeekID:Integer):Double;
function IsCarryingFrom(D:TDateTime):Boolean;
function IsCarryingTo(D:TDateTime):Boolean;
function IsPrevDayWeekendAndHoliday(D:TDateTime):Boolean;

implementation

uses SysUtils, DateUtil, UMainUnited, StrUtils;

const
  //Включенное кеширование данных существенно ускоряет процессы
  //получения данных, но создаёт проблемму их актуальности
  CacheHoliday:Boolean=True;
  CacheCarry:Boolean=True;

  tbActualTime='actualtime';
  tbNormalTime='normaltime';

var
  dbSTBasis: TIBDatabase;
  quHoliday:TIBQuery;
  quCarry:TIBQuery;
  trInternal:TIBTransaction;
  isCalendarUtilInit_Var:Boolean=False;

procedure InitCalendarUtil(DB:TIBDatabase);
begin
 DoneCalendarUtil;
 dbSTBasis:=DB;
 quHoliday:=TIBQuery.Create(nil);
 quHoliday.Database:=DB;
 quCarry:=TIBQuery.Create(nil);
 quCarry.Database:=DB;
 trInternal:=TIBTransaction.Create(nil);
 trInternal.DefaultDatabase:=DB;
 trInternal.Params.Add('read_committed');
 trInternal.Params.Add('rec_version');
 trInternal.Params.Add('nowait');
 trInternal.DefaultAction:=TARollback;
 quHoliday.Transaction:=trInternal;
 quCarry.Transaction:=trInternal;
 isCalendarUtilInit_Var:=True;
end;

procedure DoneCalendarUtil;
begin
 isCalendarUtilInit_Var:=False;
 if (quHoliday<>nil) and quHoliday.Active then quHoliday.Close;
 if (quCarry<>nil) and quCarry.Active then quCarry.Close;
 FreeAndNil(quHoliday);
 FreeAndNil(quCarry);
 FreeAndNil(trInternal);
end;

function isCalendarUtilInit:Boolean;
begin
 Result:=isCalendarUtilInit_Var;
end;

//Возвращает ид тукущего календаря
function GetCurrentCalendarID:Integer;
var quCalendar:TIBQuery;
    trTemp:TIBTransaction;
begin
 Result:=-1;
 if not isCalendarUtilInit then Exit;
 try
  quCalendar:=TIBQuery.Create(nil);
  quCalendar.Database:=dbSTBasis;
  trTemp:=TIBTransaction.Create(nil);
  trTemp.DefaultDatabase:=dbSTBasis;
  trTemp.Params.Add('read_committed');
  trTemp.Params.Add('rec_version');
  trTemp.Params.Add('nowait');
  trTemp.DefaultAction:=TARollback;
  quCalendar.Transaction:=trTemp;
  try
   quCalendar.SQL.Text:='select calendar_id from calendar order by startdate';
   try
    quCalendar.Open;
    quCalendar.Last;
    Result:=quCalendar.FieldByName('calendar_id').AsInteger;
   finally
    quCalendar.Close;
   end;
  finally
   quCalendar.Free;
   trTemp.Free;
  end;
 except
 end;
end;

//Возвращает для календаря-Calendar_ID дату последнего дня
function GelLastDateForCalendar(Calendar_ID:Integer):TDateTime;
var quCalendar:TIBQuery;
    trTemp:TIBTransaction;
    Start:TDateTime;
begin
 Result:=0;
 if not isCalendarUtilInit then Exit;
 try
  quCalendar:=TIBQuery.Create(nil);
  quCalendar.Database:=dbSTBasis;
  trTemp:=TIBTransaction.Create(nil);
  trTemp.DefaultDatabase:=dbSTBasis;
  trTemp.Params.Add('read_committed');
  trTemp.Params.Add('rec_version');
  trTemp.Params.Add('nowait');
  trTemp.DefaultAction:=TARollback;
  quCalendar.Transaction:=trTemp;
  try
   quCalendar.SQL.Text:='select calendar_id,startdate from calendar order by startdate';
   try
    quCalendar.Open;
    if quCalendar.Locate('calendar_id',Calendar_Id,[]) then
    begin
     Start:=quCalendar.FieldByName('startdate').AsDateTime;
     quCalendar.Next;
     Result:=quCalendar.FieldByName('startdate').AsDateTime;
     if Start=Result then Result:=EncodeDate(ExtractYear(Start),12,31) else Result:=IncDay(Result,-1);
    end;
   finally
    quCalendar.Close;
   end;
  finally
   quCalendar.Free;
   trTemp.Free;
  end;
 except
 end;
end;

//Возвращает сумму норм времени для диапазона дат, графика-Schedule_id, смены-Shift_id
//Если GetInHour=true то в часах иначе в днях
//dtOrdinary включить обычные дни
//dtFree     включить выходные
//dtHoliday  включить праздники
// !!!!!!!!!!!!!!!
// !!!!!!!!!!!!!!!    Если Shift_id = -1 то для всех смен !!!!!!!!!!!!!!!!!!!!!!!!!!
// !!!!!!!!!!!!!!!
function GetNormalTime(Schedule_id:Integer;Shift_ids:TRecordsIDs;StartDate,EndDate:TDateTime;GetInHour:Boolean;IncludeDayTypes:TDayTypes):Double;
var quNTimeSelect:TIBQuery;
    trTemp:TIBTransaction;
    WorkDate:TDateTime;
    DoInc,FreeDay,Holiday:Boolean;
    S2:String;
    I:Integer;
begin
 Result:=0;
 if not isCalendarUtilInit then Exit;
 if IncludeDayTypes=[] then Exit;
 if not ValidDate(StartDate) or not ValidDate(EndDate) then Exit;
 try
  quNTimeSelect:=TIBQuery.Create(nil);
  quNTimeSelect.Database:=dbSTBasis;
  trTemp:=TIBTransaction.Create(nil);
  trTemp.DefaultDatabase:=dbSTBasis;
  trTemp.Params.Add('read_committed');
  trTemp.Params.Add('rec_version');
  trTemp.Params.Add('nowait');
  trTemp.DefaultAction:=TARollback;
  quNTimeSelect.Transaction:=trTemp;
  try
//   if GetInHour then S1:='sum(timecount)' else S1:='count(timecount)';
{   if not (IncludeDayTypes=[dtOrdinary,dtFree,dtHoliday]) then
   begin
   end; }
   if Shift_ids=nil then S2:=''
   else begin
    S2:='and (';
    for I:=Low(Shift_ids) to High(Shift_ids) do
     S2:=S2+'(shift_id='+IntToStr(shift_ids[I])+') or ';
    Delete(S2,Length(S2)-3,4);
    S2:=S2+')';
   end;
   quNTimeSelect.SQL.Text:=Format('select timecount,workdate from normaltime where (schedule_id=%d) %s and (workdate>=cast(''%s'' as date)) and (workdate<=cast(''%s'' as date)) ',[Schedule_id,S2,
    FormatDateTime('dd/mm/yyyy',StartDate),
    FormatDateTime('dd/mm/yyyy',EndDate)
    ]);
   try
    quNTimeSelect.Open;
    while not quNTimeSelect.EOF do
    begin
     WorkDate:=quNTimeSelect.FieldByName('workdate').AsDateTime;
     Holiday:=IsHoliday(WorkDate);
     FreeDay:=(IsFreeDay(WorkDate) and not Holiday) or IsCarryingTo(WorkDate) or IsPrevDayWeekendAndHoliday(WorkDate);

     DoInc:=(Holiday and (dtHoliday in IncludeDayTypes)) or
            (FreeDay and (dtFree in IncludeDayTypes)) or
            (((not FreeDay and not Holiday) or IsCarryingFrom(WorkDate)) and (dtOrdinary in IncludeDayTypes));

     if DoInc then
     begin
      if GetInHour then
       Result:=Result+quNTimeSelect.FieldByName('timecount').AsFloat
      else Result:=Result+1;
     end;

     quNTimeSelect.Next;
    end;
   finally
    quNTimeSelect.Close;
   end;
  finally
   quNTimeSelect.Free;
   trTemp.Free;
  end;
 except
 end;
end;

//Возвращает сумму часов сотрудника EmpPlant_id для вида неявки Absence_id
//по определённой смене из диапазона дат
// !!!!!!!!!!!!!!!
// !!!!!!!!!!!!!!!    Если Shift_id = nil то для всех смен !!!!!!!!!!!!!!!!!!!!!!!!!!
// !!!!!!!!!!!!!!!
function GetActualTime(EmpPlant_id:Integer;Absence_ids,Shift_ids:TRecordsIDs;StartDate,EndDate:TDateTime;GetInHour:Boolean):Double;
var quATimeSelect:TIBQuery;
    trTemp:TIBTransaction;
    S1,S2,S3:String;
    I:Integer;
begin
 Result:=0;
 if not isCalendarUtilInit then Exit;
 if not ValidDate(StartDate) or not ValidDate(EndDate) then Exit;
 try
  quATimeSelect:=TIBQuery.Create(nil);
  quATimeSelect.Database:=dbSTBasis;
  trTemp:=TIBTransaction.Create(nil);
  trTemp.DefaultDatabase:=dbSTBasis;
  trTemp.Params.Add('read_committed');
  trTemp.Params.Add('rec_version');
  trTemp.Params.Add('nowait');
  trTemp.DefaultAction:=TARollback;
  quATimeSelect.Transaction:=trTemp;
  try
   if GetInHour then S1:='sum(timecount)' else S1:='count(timecount)';
   if Shift_ids=nil then S2:=''
   else begin
    S2:='and (';
    for I:=Low(Shift_ids) to High(Shift_ids) do
     S2:=S2+'(shift_id='+IntToStr(shift_ids[I])+') or ';
    Delete(S2,Length(S2)-3,4);
    S2:=S2+')';
   end;
   if Absence_ids=nil then S3:=''
   else begin
    S3:='and (';
    for I:=Low(Absence_ids) to High(Absence_ids) do
     S3:=S3+'(absence_id='+IntToStr(Absence_ids[I])+') or ';
    Delete(S3,Length(S3)-3,4);
    S3:=S3+')';
   end;
   quATimeSelect.SQL.Text:=Format('select %s as atime from actualtime where (empplant_id=%d) %s %s and (workdate>=cast(''%s'' as date)) and (workdate<=cast(''%s'' as date))',[S1,EmpPlant_id,S2,S3,
    FormatDateTime('dd/mm/yyyy',StartDate),
    FormatDateTime('dd/mm/yyyy',EndDate)
    ]);
   try
    quATimeSelect.Open;
    Result:=quATimeSelect.FieldByName('atime').AsFloat;
   finally
    quATimeSelect.Close;
   end;
  finally
   quATimeSelect.Free;
   trTemp.Free;
  end;
 except
 end;
end;

function GetActualOverTime(EmpPlant_id:Integer;Absence_ids,Shift_ids:TRecordsIDs;StartDate,EndDate:TDateTime;OverTimeScope:Double):Double;
var I:Integer;
    D:TDateTime;
    One:Double;
begin
 Result:=0;
 if not isCalendarUtilInit then Exit;
 if not ValidDate(StartDate) or not ValidDate(EndDate) then Exit;
 for I:=1 to DaysBetween(StartDate,EndDate) do
 begin
  D:=IncDay(StartDate,I-1);
  One:=GetActualTime(EmpPlant_id,Absence_ids,Shift_ids,D,D,True)-GetNormalTime(GetEmpPlantSchedule(EmpPlant_id),Shift_ids,D,D,True,[dtOrdinary,dtFree,dtHoliday])-OverTimeScope;
  if One>0 then Result:=Result+One;
 end;
end;

//Заполнить период фактов отработки для указанных сотрудников указанным видом неявки
// !!!!!!!!!!!!
// ВНИМАНИЕ! Если AValue=0 то старые данные удаляются а новые не добавляются т.е. "очистка"
function FillActualTimePeriod(EmpPlant_ids,Shift_ids:TRecordsIDs;StartDate,EndDate:TDateTime;Absence_id:Integer;AValue:Double):Boolean;
var quATimeChange:TIBQuery;
    trTemp:TIBTransaction;
    I,J,K,NewID:Integer;
    S:String;
    D:TDateTime;
begin
 Result:=False;
 if not isCalendarUtilInit then Exit;
 if (EmpPlant_ids=nil) or (Shift_ids=nil) or not ValidDate(StartDate) or not ValidDate(EndDate) then Exit;
 try
  quATimeChange:=TIBQuery.Create(nil);
  quATimeChange.Database:=dbSTBasis;
  trTemp:=TIBTransaction.Create(nil);
  trTemp.DefaultDatabase:=dbSTBasis;
  trTemp.Params.Add('read_committed');
  trTemp.Params.Add('rec_version');
  trTemp.Params.Add('nowait');
  trTemp.DefaultAction:=TARollback;
  quATimeChange.Transaction:=trTemp;
  try
   S:='delete from actualtime where empplant_id in (';
   for I:=Low(EmpPlant_ids) to High(EmpPlant_ids) do
    S:=S+IntToStr(EmpPlant_ids[I])+',';
   Delete(S,Length(S),1);
   S:=S+') and shift_id in (';
   for I:=Low(Shift_ids) to High(Shift_ids) do
    S:=S+IntToStr(Shift_ids[I])+',';
   Delete(S,Length(S),1);
   S:=S+') and (absence_id=%d) and (workdate>=cast(''%s'' as date)) and (workdate<=cast(''%s'' as date))';

   quATimeChange.SQL.Text:=Format(S,[Absence_id,
    FormatDateTime('dd/mm/yyyy',StartDate),
    FormatDateTime('dd/mm/yyyy',EndDate)
    ]);
   if not trTemp.InTransaction then trTemp.StartTransaction;
   try
    quATimeChange.ExecSQL;
    trTemp.Commit;
    Result:=True;
   except
    trTemp.Rollback;
   end;
   if Result and (AValue<>0) then
   try
    for I:=Low(EmpPlant_ids) to High(EmpPlant_ids) do
     for J:=Low(Shift_ids) to High(Shift_ids) do
      for K:=1 to DaysBetween(StartDate,EndDate) do
      begin
       NewID:=GetGenId(dbSTBasis,tbActualTime,1);
       D:=IncDay(StartDate,K-1);
       quATimeChange.SQL.Text:=Format('insert into actualtime (actualtime_id,shift_id,empplant_id,absence_id,workdate,timecount) values (%d,%d,%d,%d,CAST(''%s'' AS DATE),%s)',
        [NewID,Shift_ids[J],empplant_ids[I],Absence_id,
        FormatDateTime('dd/mm/yyyy',D),
        ReplaceStr(FloatToStr(AValue),',','.')]);
       quATimeChange.ExecSQL;
      end;
    trTemp.Commit;
   except
    trTemp.Rollback;
    Result:=False;
   end;
  finally
   quATimeChange.Free;
   trTemp.Free;
  end;
 except
 end;
end;

function GetEmpPlantSchedule(EmpPlant_Id:Integer):Integer;
var quEmpSelect:TIBQuery;
    trTemp:TIBTransaction;
begin
 Result:=0;
 if not isCalendarUtilInit then Exit;
 try
  quEmpSelect:=TIBQuery.Create(nil);
  quEmpSelect.Database:=dbSTBasis;
  trTemp:=TIBTransaction.Create(nil);
  trTemp.DefaultDatabase:=dbSTBasis;
  trTemp.Params.Add('read_committed');
  trTemp.Params.Add('rec_version');
  trTemp.Params.Add('nowait');
  trTemp.DefaultAction:=TARollback;
  quEmpSelect.Transaction:=trTemp;
  try
   quEmpSelect.SQL.Text:=Format('select schedule_id from empplantschedule where empplant_id=%d order by empplantschedule_id',[EmpPlant_id]);
   try
    quEmpSelect.Open;
    if not quEmpSelect.IsEmpty then
    begin
     quEmpSelect.Last;
     Result:=quEmpSelect.FieldByName('schedule_id').AsInteger;
    end;
   finally
    quEmpSelect.Close;
   end;
  finally
   quEmpSelect.Free;
   trTemp.Free;
  end;
 except
 end;
end;

//Копируем нормы в факт для сотрудников EmpPlant_ids в диапазоне дат
function CopyActualTimeFromNormalTime(EmpPlant_ids:TRecordsIDs;StartDate,EndDate:TDateTime;Absence_id:Integer):Boolean;
var quATimeChange,quNTimeSelect:TIBQuery;
    trTemp:TIBTransaction;
    I,NewID:Integer;
    S:String;
//    D:TDateTime;
begin
 Result:=False;
 if not isCalendarUtilInit then Exit;
 if (EmpPlant_ids=nil) or not ValidDate(StartDate) or not ValidDate(EndDate) then Exit;
 try
  quATimeChange:=TIBQuery.Create(nil);
  quATimeChange.Database:=dbSTBasis;
  quNTimeSelect:=TIBQuery.Create(nil);
  quNTimeSelect.Database:=dbSTBasis;
  trTemp:=TIBTransaction.Create(nil);
  trTemp.DefaultDatabase:=dbSTBasis;
  trTemp.Params.Add('read_committed');
  trTemp.Params.Add('rec_version');
  trTemp.Params.Add('nowait');
  trTemp.DefaultAction:=TARollback;
  quATimeChange.Transaction:=trTemp;
  quNTimeSelect.Transaction:=trInternal;
  try
   S:='delete from actualtime where empplant_id in (';
   for I:=Low(EmpPlant_ids) to High(EmpPlant_ids) do
    S:=S+IntToStr(EmpPlant_ids[I])+',';
   Delete(S,Length(S),1);
   S:=S+') and (workdate>=cast(''%s'' as date)) and (workdate<=cast(''%s'' as date))';

   quATimeChange.SQL.Text:=Format(S,[
    FormatDateTime('dd/mm/yyyy',StartDate),FormatDateTime('dd/mm/yyyy',EndDate)]);
   if not trTemp.InTransaction then trTemp.StartTransaction;
   try
    quATimeChange.ExecSQL;
    trTemp.Commit;
    Result:=True;
   except
    trTemp.Rollback;
   end;
   if Result then
   try
    for I:=Low(EmpPlant_ids) to High(EmpPlant_ids) do
    begin
     S:='select * from normaltime where (schedule_id=%d) and (workdate>=cast(''%s'' as date)) and (workdate<=cast(''%s'' as date))';
     quNTimeSelect.SQL.Text:=Format(S,[GetEmpPlantSchedule(EmpPlant_ids[I]),FormatDateTime('dd/mm/yyyy',StartDate),
                                        FormatDateTime('dd/mm/yyyy',EndDate)]);
     quNTimeSelect.Close;
     quNTimeSelect.Open;
     while not quNTimeSelect.EOF do
     begin
       NewID:=GetGenId(dbSTBasis,tbActualTime,1);
       quATimeChange.SQL.Text:=Format('insert into actualtime (actualtime_id,shift_id,empplant_id,absence_id,workdate,timecount) values (%d,%d,%d,%d,CAST(''%s'' AS DATE),%s)',
        [NewID,quNTimeSelect.FieldByName('shift_id').AsInteger,empplant_ids[I],Absence_id,
        FormatDateTime('dd/mm/yyyy',quNTimeSelect.FieldByName('workdate').AsDateTime),
        ReplaceStr(FloatToStr(quNTimeSelect.FieldByName('timecount').AsFloat),',','.')]);
       quATimeChange.ExecSQL;
      quNTimeSelect.Next;
     end;
    end;
    trTemp.Commit;
   except
    trTemp.Rollback;
    Result:=False;
   end;
  finally
   quATimeChange.Free;
   quNTimeSelect.Free;
   trTemp.Free;
  end;
 except
 end;
end;

//Возвращает календарную норму для календаря-Schedule_ID
function GetStandardCalendarNormForSchedule(Schedule_ID:Integer):Double;
var First,Last:TDateTime;
    Temp:TIBQuery;
    trTemp:TIBTransaction;
    CurCalendarID:Integer;
    AvgYear:Double;
begin
 Result:=0;
 if not isCalendarUtilInit then Exit;
 Temp:=TIBQuery.Create(nil);
 Temp.Database:=dbSTBasis;
 trTemp:=TIBTransaction.Create(nil);
 trTemp.DefaultDatabase:=dbSTBasis;
 trTemp.Params.Add('read_committed');
 trTemp.Params.Add('rec_version');
 trTemp.Params.Add('nowait');
 trTemp.DefaultAction:=TARollback;
 Temp.Transaction:=trTemp;
 try
  CurCalendarID:=-1;
  AvgYear:=0;
  Temp.SQL.Text:=Format('select calendar_id,avgyear from schedule where schedule_id=%d',[Schedule_ID]);
  try
   Temp.Open;
   if not Temp.IsEmpty then
   begin
    CurCalendarID:=Temp.FieldByName('calendar_id').AsInteger;
    AvgYear:=Temp.FieldByName('avgyear').AsFloat;
   end; 
  finally
   Temp.Close;
  end;
  if CurCalendarID>-1 then
  begin
   Temp.SQL.Text:='select calendar_id,startdate from calendar order by startdate';
   try
    Temp.Open;
    if Temp.Locate('calendar_id',CurCalendarID,[]) then
    begin
     First:=Temp.FieldByName('startdate').AsDateTime;
     Temp.Next;
     Last:=Temp.FieldByName('startdate').AsDateTime;
     if Last=First then Last:=EncodeDate(ExtractYear(First),12,31) else Last:=IncDay(Last,-1);
     Result:=MonthsBetween(First,Last)*AvgYear;
    end;
   finally
    Temp.Close;
   end;
  end;
 finally
  Temp.Free;
  trTemp.Free;
 end;
end;

//Возвращает расчётную календарную норму для календаря-Schedule_ID
function GetCalculateCalendarNormForSchedule(Schedule_ID:Integer):Double;
var Temp:TIBQuery;
    trTemp:TIBTransaction;
begin
 Result:=0;
 if not isCalendarUtilInit then Exit;
 Temp:=TIBQuery.Create(nil);
 Temp.Database:=dbSTBasis;
 trTemp:=TIBTransaction.Create(nil);
 trTemp.DefaultDatabase:=dbSTBasis;
 trTemp.Params.Add('read_committed');
 trTemp.Params.Add('rec_version');
 trTemp.Params.Add('nowait');
 trTemp.DefaultAction:=TARollback;
 Temp.Transaction:=trTemp;
 try
  Temp.SQL.Text:=Format('select sum(timecount) as summa from normaltime where schedule_id=%d',[Schedule_ID]);
  try
   Temp.Open;
   Result:=Temp.FieldByName('summa').AsFloat;
  finally
   Temp.Close;
  end;
 finally
  Temp.Free;
  trTemp.Free;
 end;
end;

//Определение поподания дня на праздник с учётом всех календарей
function IsHoliday(D:TDateTime):Boolean;
begin
 Result:=False;
 if not isCalendarUtilInit then Exit;
// if ValidDate(D) then
 if CacheHoliday then
 try
  if not quHoliday.Active then
  begin
   quHoliday.SQL.Text:='select holiday from holiday order by holiday';
   quHoliday.Open;
  end;
  Result:=quHoliday.Locate('holiday',D,[]);
 except
 end else
 try
  quHoliday.SQL.Text:=Format('select count(holiday_id) as reccount from holiday where holiday=CAST(''%s'' as date)',[FormatDateTime('dd/mm/yyyy',D)]);
  try
   quHoliday.Open;
   Result:=quHoliday.FieldByName('reccount').AsInteger>0;
  finally
   quHoliday.Close;
  end;
 except
 end;
end;

//Последний день месяца?
function IsLastDay(D:TDateTime):Boolean;
var Year,Month1,Month2,Day:Word;
begin
 Result:=False;
 if ValidDate(D) then
 begin
  DecodeDate(D,Year,Month1,Day);
  DecodeDate(IncDay(D,1),Year,Month2,Day);
  Result:=not (Month1=Month2);
 end;
end;

//Выходной?
function IsFreeDay(D:TDateTime):Boolean;
begin
 Result:=ValidDate(D) and ((DayOfWeek(D)=1) or (DayOfWeek(D)=7));
end;

//Возвращает кол-во рабочих дней месяца
function GetWorkingDaysInMonth(D:TDateTime):Byte;
var Y,M,Day,A:Word;
begin
 Result:=0;
 if ValidDate(D) then
 begin
  DecodeDate(D,Y,M,Day);
  for A:=1 to DaysPerMonth(Y,M) do
  begin
   if (not IsFreeDay(EncodeDate(Y,M,A))) and (not IsHoliday(EncodeDate(Y,M,A))) then
    Inc(Result);
   if (IsFreeDay(EncodeDate(Y,M,A))) and (IsHoliday(EncodeDate(Y,M,A))) then
    Dec(Result);
  end;
 end;
end;

{function GetNormalWorkingHoursInMonth(D:TDateTime):Double;
var Y,M,Day,A:Word;
begin
 Result:=0;
 DecodeDate(D,Y,M,Day);
 with CalendarDataModule do
 for A:=1 to DaysPerMonth(Y,M) do
 begin
  if (not IsFreeDay(EncodeDate(Y,M,A))) and (not IsHoliday(EncodeDate(Y,M,A))) then
   if (IsHoliday(IncDay(EncodeDate(Y,M,A),1))) or (DayOfWeek(EncodeDate(Y,M,A))=6) then Result:=Result+taWeeks.FieldByName('Friday').AsFloat
   else Result:=Result+taWeeks.FieldByName('WorkDay').AsFloat;
  if (IsFreeDay(EncodeDate(Y,M,A))) and (IsHoliday(EncodeDate(Y,M,A))) then
   Result:=Result-taWeeks.FieldByName('WorkDay').AsFloat;
 end;
end; }

//Возвращает кол-во рабочих часов (с учётом исключений) в месяц для определённой рабочей недели
function GetExceptWorkingHoursInMonthForWeek(D:TDateTime;WeekID:Integer):Double;
{var Y,M,Day,A:Word;
    E:Real;}
begin
 Result:=0;
{ DecodeDate(D,Y,M,Day);
 with CalendarDataModule do
 for A:=1 to DaysPerMonth(Y,M) do
 begin
  E:=IsExceptDate(taWeeksID.Value,EncodeDate(Y,M,A));
  if E<>-1 then Result:=Result+E else
  begin
   if IsCarryingTo(EncodeDate(Y,M,A)) then Continue;
   if (not IsFreeDay(EncodeDate(Y,M,A))) and (not IsHoliday(EncodeDate(Y,M,A))) then
    if (IsHoliday(IncDay(EncodeDate(Y,M,A),1))) or (DayOfWeek(EncodeDate(Y,M,A))=6) then Result:=Result+taWeeks.FieldByName('Friday').AsFloat
    else Result:=Result+taWeeks.FieldByName('WorkDay').AsFloat;
   if (IsFreeDay(EncodeDate(Y,M,A))) and (IsHoliday(EncodeDate(Y,M,A))) then
    Result:=Result-taWeeks.FieldByName('WorkDay').AsFloat;
  end;
 end;}
end;

function IsCarryingFrom(D:TDateTime):Boolean;
begin
 Result:=False;
 if not isCalendarUtilInit then Exit;
// if ValidDate(D) then
 if CacheCarry then
 try
  if not quCarry.Active then
  begin
   quCarry.SQL.Text:='select carry_id,fromdate,todate from carry';
   quCarry.Open;
  end;
  Result:=quCarry.Locate('fromdate',D,[]);
 except
 end else
 try
  quCarry.SQL.Text:=Format('select count(carry_id) as reccount from carry where fromdate=CAST(''%s'' as date)',[FormatDateTime('dd/mm/yyyy',D)]);
  try
   quCarry.Open;
   Result:=quCarry.FieldByName('reccount').AsInteger>0;
  finally
   quCarry.Close;
  end;
 except
 end;
end;

function IsCarryingTo(D:TDateTime):Boolean;
begin
 Result:=False;
 if not isCalendarUtilInit then Exit;
// if ValidDate(D) then
 if CacheCarry then
 try
  if not quCarry.Active then
  begin
   quCarry.SQL.Text:='select carry_id,fromdate,todate from carry';
   quCarry.Open;
  end;
  Result:=quCarry.Locate('todate',D,[]);
 except
 end else
 try
  quCarry.SQL.Text:=Format('select count(carry_id) as reccount from carry where todate=CAST(''%s'' as date)',[FormatDateTime('dd/mm/yyyy',D)]);
  try
   quCarry.Open;
   Result:=quCarry.FieldByName('reccount').AsInteger>0;
  finally
   quCarry.Close;
  end;
 except
 end;
end;

//Празник попавший на выходной
function IsPrevDayWeekendAndHoliday(D:TDateTime):Boolean;
var DOld:TDateTime;
//    TheDay:Word;
    Flag:Boolean;
begin
// Result:=False;
{ if IsWeekend(ACol, ARow) then Exit;
 TheDay:=FMonthOffset + ACol + (ARow - 1) * 7;
 if (TheDay < 1) or (TheDay > DaysThisMonth) then Exit;
 D:=EncodeDate(Year,Month,TheDay);}
 DOld:=D;
 D:=IncDay(D,-1);//Взять предыдущий день
 if IsFreeDay(D) then//Выходной ?
 begin
  Flag:=IsHoliday(D);//Праздник ?
  D:=IncDay(D,-1);//Взять ещё днём раньше
  //Если один из дней одновременно то...
  Result:=(IsFreeDay(D) and IsHoliday(D)) or Flag;
 end
 else
 begin
  D:=IncDay(DOld,-2);
  Flag:=IsFreeDay(D) and IsHoliday(D);
  D:=IncDay(D,-1);
  Result:=Flag and (IsFreeDay(D) and IsHoliday(D));
 end;
end;

initialization
 quHoliday:=nil;
 quCarry:=nil;
 trInternal:=nil;
end.
