unit StAverages;

interface

uses StCalendarUtil;
{
  Sick CalculateType
        1       Расчёт пособия по общему заболеванию
        2       Расчёт пособия по уходу за больным
        3       Расчёт пособия при бытовой травме
        4       Расчёт пособия по беременности и родам
        5       Расчёт пособия при рождении ребёнка
        6       Расчёт пособия  по проф. заболеванию
}
{
  Sick CalculateSubType
        1               Простой смертный
        2               Одинокие, вдовы и т.д.
        3               Ребёнок до 3-х, инвалид до 16-ти
}
{
  Sick CalculateTimeType
        1               По дням
        2               По часам
}
type
  TEmployeeSickInfo=packed record
   Emp_id:Integer;//Сотрудник
   EmpPlant_id:Integer;//Сотрудник
   StartDate,EndDate:TDateTime;//Период болезни
   WorkAbsence_ids:TRecordsIDs;
   Oklad:Currency;//Оклад
   OkladFlag:Boolean;
   PayPercent:Integer;//Процент оплаты от стажа
   CalculateType,CalculateSubType:Integer;
   CalculateTimeType:Integer;
   WithoutPay:Boolean;//Без оплаты
  end;

  TSickItem=packed record
   FDate:TDateTime;
   SickDaysCount:Integer;
   SickHoursCount:Double;
   NormalDaysCount:Integer;
   NormalHoursCount:Double;
   CalendarDays:Integer;
   WithoutPay:Boolean;
   PayPercent:Integer;
   OnePay:Currency;
  end;

  TSick=array of TSickItem;

  TSalaryInfoItem=packed record
   Month:TDateTime;
   ODays:Word;
   NDays:Word;
   OHours:Double;
   NHours:Double;
   Pay:Currency;
  end;

  TSalaryInfo=array of TSalaryInfoItem;

{
  Leave CalculateType
        1       Расчёт ежегодного отпуска
        2       Расчёт ученического отпуска
        3       Расчёт компенсации уволенному
        4       Расчёт прочих средних
        5       Расчёт социального отпуска
        6       Расчёт отпуска ликвидатору аварии на ЧАЭС
        7       Расчёт компенсации работающему
}

{
  Leave CalculateSubType
        1               По 6-ти дневной рабочей неделе
        2               Суммированный учёт
        3               По календарным дням
}

  TEmployeeLeaveInfo=packed record
   Emp_id:Integer;//Сотрудник
   EmpPlant_id:Integer;//Сотрудник
   StartDate,EndDate:TDateTime;//Период болезни
   WorkAbsence_ids:TRecordsIDs;
   Oklad:Currency;//Оклад
   OkladFlag:Boolean;
   PayPercent:Integer;//Процент оплаты от стажа
   CalculateType,CalculateSubType:Integer;
  end;

  TLeaveItem=packed record
   FDate:TDateTime;
   LeaveDaysCount:Integer;
   LeaveHoursCount:Double;
   NormalDaysCount:Integer;
   NormalHoursCount:Double;
   CalendarDays:Integer;
   OnePay:Currency;
  end;

  TLeave=array of TLeaveItem;

procedure CalculateSickList(Emp:TEmployeeSickInfo;var CalcShift:Integer;var ASalaryInfo:TSalaryInfo;var ASick:TSick;var AveragePay,AllPay:Currency);
procedure CalculateLeaveList(Emp:TEmployeeLeaveInfo;var CalcShift:Integer;var ASalaryInfo:TSalaryInfo;var ALeave:TLeave;var AveragePay,Lucre,AllPay:Currency);

implementation

uses UMainUnited, Math, SysUtils, Windows, Forms, DateUtil, StSalaryKit;

//Круто округлить
function CoolRound(F:Extended;N:Byte):Extended;
begin
 if N=0 then Result:=Round(F) else
  Result:=Int((F+0.5/IntPower(10,N))*IntPower(10,N))/IntPower(10,N);
end;

function Get_Sick_Magic_Code:Integer;
begin
 //755 ИД вида начисления для больничных
 Result:=755;
end;

function Get_Leave_Magic_Code:Integer;
begin
 //??? ИД вида начисления
 Result:=0;
end;

function GetSalary(AEmpPlant_id:Integer;AMonth:TDateTime;N:Integer):Currency;
begin
 try
  Result:=GetOnSalary(AEmpPlant_id,GetCalcPeriodByDate(AMonth),N);
 except
  Result:=0;
  ShowInfo(0,'Исключение в функции расчёта зар. платы.');
 end;
end;

//Число минимальных Рождение ребёнка
function GetSickConst01:Integer;
begin
 Result:=15;
end;

//Районный коэффициент Рождение ребёнка
function GetSickConst02:Double;
begin
 Result:=1.3;
end;

//Процент оплаты за последующие дни Уход за больным
function GetSickConst03:Integer;
begin
 Result:=50;
end;

//Кол-во дней полной оплаты Уход за больным
function GetSickConst04:Integer;
begin
 Result:=7;
end;

//Кол-во дней полной оплаты для вдов и т.д. Уход за больным
function GetSickConst05:Integer;
begin
 Result:=10;
end;

//Кол-во не оплачиваемых дней Бытовая травма
function GetSickConst06:Integer;
begin
 Result:=5;
end;

//Кол-во мин. зар. плат мат. помощи
function GetLeaveConst08:Integer;
begin
 Result:=12;
end;

//Пятидневная рабочая неделя или шестидневная рабочая неделя
function GetLeaveConst09:Integer;
begin
 Result:=5;
end;

//Среднемесячное кол-во дней при расчёте по 5-ти или 6-ти дневной раб. неделе
function GetLeaveConst13:Double;
begin
 Result:=25.25;
end;

//Среднемесячное кол-во дней при расчёте по календарным дням
function GetLeaveConst14:Double;
begin
 Result:=29.6;
end;

function GetMinPay(AMonth:TDateTime):Currency;
begin
 Result:=GetMROT(AMonth);
end;

procedure CalculateSickList(Emp:TEmployeeSickInfo;var CalcShift:Integer;var ASalaryInfo:TSalaryInfo;var ASick:TSick;var AveragePay,AllPay:Currency);

var S,F:TDateTime;
    RecurseCount:Integer;

procedure AddSickDataRecord(var ASick:TSick;const D:TDateTime;PeriodInDays:Integer;PeriodInHours:Double;const ACalendarDays:Integer;const Percent:Integer;const AWithOutPay:Boolean);
var NewID:Integer;
    S,F:TDateTime;
begin
 NewID:=High(ASick)+2;
 SetLength(ASick,NewID);
 with ASick[NewID-1] do
 begin
  FDate:=D;
  if PeriodInDays<0 then PeriodInDays:=0;
  SickDaysCount:=PeriodInDays;
  if PeriodInHours<0 then PeriodInHours:=0;
  SickHoursCount:=PeriodInHours;
  S:=EncodeDate(ExtractYear(D),ExtractMonth(D),1);
  F:=IncMonth(S,1);
  F:=IncDay(F,-1);
  NormalDaysCount:=Round(GetNormalTime(GetEmpPlantSchedule(Emp.EmpPlant_id),nil,S,F,False,[dtOrdinary,dtFree,dtHoliday]));
  NormalHoursCount:=GetNormalTime(GetEmpPlantSchedule(Emp.EmpPlant_id),nil,S,F,True,[dtOrdinary,dtFree,dtHoliday]);
  CalendarDays:=ACalendarDays;
  WithoutPay:=AWithOutPay;
  PayPercent:=Percent;
  OnePay:=0;
 end;
end;

procedure GetSalaries(N:Integer);
var StartDate:TDateTime;
begin
 CalcShift:=N;
 Inc(RecurseCount);
 StartDate:=IncMonth(Emp.StartDate,N);
 ASalaryInfo[0].Pay:=0;
 ASalaryInfo[1].Pay:=0;
 ASalaryInfo[0].Month:=IncMonth(StartDate,-1);
 ASalaryInfo[1].Month:=IncMonth(StartDate,-2);
 if (not Emp.WithoutPay) and (Emp.CalculateType<>5) then
 begin
  ASalaryInfo[0].Pay:=GetSalary(Emp.EmpPlant_id,ASalaryInfo[0].Month,Get_Sick_Magic_Code);
  ASalaryInfo[1].Pay:=GetSalary(Emp.EmpPlant_id,ASalaryInfo[1].Month,Get_Sick_Magic_Code);
 end else Exit;
 if (ASalaryInfo[0].Pay=0) and (ASalaryInfo[1].Pay=0) then
 begin
  if RecurseCount=5 then Exit;
  GetSalaries(N-1);
  Exit;
 end;
end;

procedure PrepareSickListPeriod;
var StartDate,EndDate:TDateTime;
    PeriodInHours:Double;
    I,PeriodInDays,Percent,CalendarDays:Integer;
    Y,M,D:Word;
begin
 PeriodInDays:=0;
 PeriodInHours:=0;
 CalendarDays:=0;
 Percent:=Emp.PayPercent;

 StartDate:=Emp.StartDate;
 EndDate:=Emp.EndDate;

 if (Emp.CalculateType=2) then
  case Emp.CalculateSubType of
   1:begin//Уход за больным
      I:=0;
      while (StartDate<=EndDate) and (I<GetSickConst04) do
      begin
       Inc(CalendarDays);
       if (not IsFreeDay(StartDate)) and (not IsHoliday(StartDate)) then
       begin
        Inc(PeriodInDays);
        if (DayOfWeek(StartDate)=6) or (IsHoliday(IncDay(StartDate,1))) then
         PeriodInHours:=PeriodInHours+7
        else
         PeriodInHours:=PeriodInHours+8.25;
       end
       else
        if (IsFreeDay(StartDate)) and (IsHoliday(StartDate)) then
        begin
         Dec(PeriodInDays);
         PeriodInHours:=PeriodInHours-8.25;
        end;
       if IsLastDay(StartDate) then
       begin//Заполнение периодов нетрудоспособ.
        AddSickDataRecord(ASick,StartDate,PeriodInDays,PeriodInHours,CalendarDays,Percent,False);
        PeriodInDays:=0;
        PeriodInHours:=0;
        CalendarDays:=0;
       end;
       StartDate:=IncDay(StartDate,1);
       Inc(I);
      end;
      if PeriodInDays>0 then//Заполнение LAST периодa нетрудоспособ.
       AddSickDataRecord(ASick,StartDate,PeriodInDays,PeriodInHours,CalendarDays,Percent,False);
      Percent:=GetSickConst03;
     end;
   2:begin//Одинокие, вдовы и т.д.
      I:=0;
      while (StartDate<=EndDate) and (I<GetSickConst05) do
      begin
       Inc(CalendarDays);
       if (not IsFreeDay(StartDate)) and (not IsHoliday(StartDate)) then
       begin
        Inc(PeriodInDays);
        if (DayOfWeek(StartDate)=6) or (IsHoliday(IncDay(StartDate,1))) then
         PeriodInHours:=PeriodInHours+7
        else
         PeriodInHours:=PeriodInHours+8.25;
       end
       else
        if (IsFreeDay(StartDate)) and (IsHoliday(StartDate)) then
        begin
         Dec(PeriodInDays);
         PeriodInHours:=PeriodInHours-8.25;
        end;
       if IsLastDay(StartDate) then
       begin//Заполнение периодов нетрудоспособ.
        AddSickDataRecord(ASick,StartDate,PeriodInDays,PeriodInHours,CalendarDays,Percent,False);
        PeriodInDays:=0;
        PeriodInHours:=0;
        CalendarDays:=0;
       end;
       StartDate:=IncDay(StartDate,1);
       Inc(I);
      end;
      if PeriodInDays>0 then//Заполнение LAST периодa нетрудоспособ.
       AddSickDataRecord(ASick,StartDate,PeriodInDays,PeriodInHours,CalendarDays,Percent,False);
      Percent:=GetSickConst03;
     end;
   end;// END CASE

 if (Emp.CalculateType=3) then
 begin
  I:=GetSickConst06;
  while (StartDate<=EndDate) and (I>0) do
  begin
   Inc(CalendarDays);
   if (not IsFreeDay(StartDate)) and (not IsHoliday(StartDate)) then
   begin
    Inc(PeriodInDays);
    if (DayOfWeek(StartDate)=6) or (IsHoliday(IncDay(StartDate,1))) then
     PeriodInHours:=PeriodInHours+7
    else
     PeriodInHours:=PeriodInHours+8.25;
   end
   else
    if (IsFreeDay(StartDate)) and (IsHoliday(StartDate)) then
    begin
     Dec(PeriodInDays);
     PeriodInHours:=PeriodInHours-8.25;
    end;
   if not IsHoliday(StartDate) then Dec(I);
   if IsLastDay(StartDate) then//Заполнение периодов нетрудоспособ.
   begin
    AddSickDataRecord(ASick,StartDate,PeriodInDays,PeriodInHours,CalendarDays,Percent,True);
    PeriodInDays:=0;
    PeriodInHours:=0;
    CalendarDays:=0;
   end;
   StartDate:=IncDay(StartDate,1);
  end;
  if PeriodInDays>0 then//Заполнение LAST периодa нетрудоспособ.
   AddSickDataRecord(ASick,StartDate,PeriodInDays,PeriodInHours,CalendarDays,Percent,True);
 end;

 PeriodInDays:=0;PeriodInHours:=0;CalendarDays:=0;
 if Emp.CalculateType<>5 then
 begin
  while StartDate<=EndDate do
  begin
   Inc(CalendarDays);
   if (not IsFreeDay(StartDate)) and (not IsHoliday(StartDate)) then
   begin
    Inc(PeriodInDays);
    if (DayOfWeek(StartDate)=6) or (IsHoliday(IncDay(StartDate,1))) then
     PeriodInHours:=PeriodInHours+7
    else
     PeriodInHours:=PeriodInHours+8.25;
   end
   else
    if (IsFreeDay(StartDate)) and (IsHoliday(StartDate)) then
    begin
     Dec(PeriodInDays);
     PeriodInHours:=PeriodInHours-8.25;
    end;
   if IsLastDay(StartDate) then
   begin//Заполнение периодов нетрудоспособ.
    AddSickDataRecord(ASick,StartDate,PeriodInDays,PeriodInHours,CalendarDays,Percent,False);
    PeriodInDays:=0;
    PeriodInHours:=0;
    CalendarDays:=0;
   end;
   StartDate:=IncDay(StartDate,1);
  end;
  if PeriodInDays>0 then//Заполнение LAST периодa нетрудоспособ.
   AddSickDataRecord(ASick,StartDate,PeriodInDays,PeriodInHours,CalendarDays,Percent,False);
 end
 else
 begin//5 type
  DecodeDate(StartDate,Y,M,D);
  //Месяц нетрудоспособ.
  AddSickDataRecord(ASick,EncodeDate(Y,M,1),0,0,0,0,False);
 end;
end;

procedure DoCalculate;
var I:Integer;
    AveragePayOld:Currency;
begin
 if Emp.CalculateType=5 then
 begin//Расчёт при рождении ребёнка
  AveragePay:=0;
  AllPay:=CoolRound(GetSickConst01*GetSickConst02*GetMinPay(Emp.StartDate),CurrencyDecimals);
  ASick[0].OnePay:=AllPay;//Общая сумма пособия
 end
 else
 begin//Расчёт по средним
  AveragePay:=0;
  if not Emp.WithoutPay then
  case Emp.CalculateTimeType of
   //По дням
   1:if (ASalaryInfo[0].ODays+ASalaryInfo[1].ODays)<>0 then
      AveragePay:=(ASalaryInfo[0].Pay+ASalaryInfo[1].Pay)/(ASalaryInfo[0].ODays+ASalaryInfo[1].ODays);
   //По часам
   2:if (ASalaryInfo[0].OHours+ASalaryInfo[1].OHours)<>0 then
      AveragePay:=(ASalaryInfo[0].Pay+ASalaryInfo[1].Pay)/(ASalaryInfo[0].OHours+ASalaryInfo[1].OHours);
  end;
  AveragePay:=CoolRound(AveragePay,CurrencyDecimals);
  AveragePayOld:=AveragePay;
  AllPay:=0;
  //Заполнение месяцев нетрудоспособности
  for I:=Low(ASick) to High(ASick) do
  begin
   AveragePay:=AveragePayOld;
   if not Emp.WithoutPay then
    if ((Emp.CalculateType=1) and (Emp.CalculateSubType<>2)) or
     (Emp.CalculateType=2) or
     ((Emp.CalculateType=3) and (Emp.CalculateSubType<>2)) then
    begin//Проверка на двойной тариф
     case Emp.CalculateTimeType of
      1:if Emp.OkladFlag then
        begin//Оклад
         if ASick[I].NormalDaysCount<>0 then
         begin
          if AveragePay>(Emp.Oklad*2/ASick[I].NormalDaysCount) then
           AveragePay:=Emp.Oklad*2/ASick[I].NormalDaysCount;
         end;
        end
        else
        begin//Тариф
         if (ASick[I].NormalDaysCount<>0) or (ASick[I].NormalHoursCount<>0) then
         begin
          if AveragePay>(Emp.Oklad*ASick[I].NormalHoursCount*2/ASick[I].NormalDaysCount) then
           AveragePay:=Emp.Oklad*ASick[I].NormalHoursCount*2/ASick[I].NormalDaysCount;
         end
        end;
      2:if Emp.OkladFlag then
        begin//Оклад
         if ASick[I].NormalHoursCount<>0 then
         begin
          if AveragePay>(Emp.Oklad*2/ASick[I].NormalHoursCount) then
           AveragePay:=Emp.Oklad*2/ASick[I].NormalHoursCount;
         end;
        end
        else
        begin//Тариф
         if AveragePay>(Emp.Oklad*2) then
          AveragePay:=Emp.Oklad*2;
        end;
     end;
    end;
   if not ASick[I].WithoutPay then
    case Emp.CalculateTimeType of
     1:ASick[I].OnePay:=CoolRound(ASick[I].SickDaysCount*AveragePay/100*ASick[I].PayPercent,CurrencyDecimals);
     2:ASick[I].OnePay:=CoolRound(ASick[I].SickHoursCount*AveragePay/100*ASick[I].PayPercent,CurrencyDecimals);
    end
   else ASick[I].OnePay:=0;
   AllPay:=AllPay+ASick[I].OnePay;
  end;
  AllPay:=CoolRound(AllPay,CurrencyDecimals);
 end;
end;

begin
 //Корректируем процент, вдруг ошибка :-)
 case Emp.CalculateType of
  1:if Emp.CalculateSubType>1 then Emp.PayPercent:=100;
  3:if Emp.CalculateSubType>1 then Emp.PayPercent:=100;
  4:Emp.PayPercent:=100;
  5:Emp.PayPercent:=0;
  6:Emp.PayPercent:=100;
 end;
 //Кол-во сдвигов при получении зар.платы
 RecurseCount:=0;
 CalcShift:=0;

 //Для расчёта больничных 2 месяца
 SetLength(ASalaryInfo,2);
 //Периодов болезни пока нет
 SetLength(ASick,0);
 //Заполняем ASalaryInfo
 GetSalaries(0);
 PrepareSickListPeriod;
 S:=EncodeDate(ExtractYear(ASalaryInfo[0].Month),ExtractMonth(ASalaryInfo[0].Month),1);
 F:=IncMonth(S,1);
 F:=IncDay(F,-1);
 ASalaryInfo[0].ODays:=Round(GetActualTime(Emp.EmpPlant_id,Emp.WorkAbsence_ids,nil,S,F,False));
 ASalaryInfo[0].OHours:=GetActualTime(Emp.EmpPlant_id,Emp.WorkAbsence_ids,nil,S,F,True);
 S:=EncodeDate(ExtractYear(ASalaryInfo[1].Month),ExtractMonth(ASalaryInfo[1].Month),1);
 F:=IncMonth(S,1);
 F:=IncDay(F,-1);
 ASalaryInfo[1].ODays:=Round(GetActualTime(Emp.EmpPlant_id,Emp.WorkAbsence_ids,nil,S,F,False));
 ASalaryInfo[1].OHours:=GetActualTime(Emp.EmpPlant_id,Emp.WorkAbsence_ids,nil,S,F,True);
 DoCalculate;
end;

procedure CalculateLeaveList(Emp:TEmployeeLeaveInfo;var CalcShift:Integer;var ASalaryInfo:TSalaryInfo;var ALeave:TLeave;var AveragePay,Lucre,AllPay:Currency);

var S,F:TDateTime;
    RecurseCount:Integer;

procedure AddLeaveDataRecord(var ALeave:TLeave;const D:TDateTime;PeriodInDays:Integer;PeriodInHours:Double;const ACalendarDays:Integer);
var NewID:Integer;
    S,F:TDateTime;
begin
 NewID:=High(ALeave)+2;
 SetLength(ALeave,NewID);
 with ALeave[NewID-1] do
 begin
  FDate:=D;
  if PeriodInDays<0 then PeriodInDays:=0;
  LeaveDaysCount:=PeriodInDays;
  if PeriodInHours<0 then PeriodInHours:=0;
  LeaveHoursCount:=PeriodInHours;
  S:=EncodeDate(ExtractYear(D),ExtractMonth(D),1);
  F:=IncMonth(S,1);
  F:=IncDay(F,-1);
  NormalDaysCount:=Round(GetNormalTime(GetEmpPlantSchedule(Emp.EmpPlant_id),nil,S,F,False,[dtOrdinary,dtFree,dtHoliday]));
  NormalHoursCount:=GetNormalTime(GetEmpPlantSchedule(Emp.EmpPlant_id),nil,S,F,True,[dtOrdinary,dtFree,dtHoliday]);
  CalendarDays:=ACalendarDays;
  OnePay:=0;
 end;
end;

procedure GetSalaries(N:Integer);
var StartDate:TDateTime;
begin
 CalcShift:=N;
 Inc(RecurseCount);
 StartDate:=IncMonth(Emp.StartDate,N);
 ASalaryInfo[0].Month:=IncMonth(StartDate,-1);
 ASalaryInfo[1].Month:=IncMonth(StartDate,-2);
 ASalaryInfo[2].Month:=IncMonth(StartDate,-3);
 ASalaryInfo[0].Pay:=GetSalary(Emp.EmpPlant_id,ASalaryInfo[0].Month,Get_Leave_Magic_Code);
 ASalaryInfo[1].Pay:=GetSalary(Emp.EmpPlant_id,ASalaryInfo[1].Month,Get_Leave_Magic_Code);
 ASalaryInfo[2].Pay:=GetSalary(Emp.EmpPlant_id,ASalaryInfo[2].Month,Get_Leave_Magic_Code);
 if (ASalaryInfo[0].Pay=0) and (ASalaryInfo[1].Pay=0) and (ASalaryInfo[2].Pay=0) then
 begin
  if RecurseCount=5 then Exit;
  GetSalaries(N-1);
  Exit;
 end;
end;

procedure PrepareLeaveListPeriod;
var StartDate,EndDate:TDateTime;
    PeriodInHours,FridayInc,WorkInc:Double;
    A,CalendarDays,Period:Integer;
begin
// GotoLModesRecord(taLeaveStaffCMode.Value-1);
 Period:=0;PeriodInHours:=0;CalendarDays:=0;A:=1;
 StartDate:=Emp.StartDate;
 EndDate:=Emp.EndDate;
 if Emp.CalculateType in [1,2,4,5,6] then
 begin
  WorkInc:=8.25;
  FridayInc:=7;
  while StartDate<=EndDate do
  begin
   if not IsHoliday(StartDate) then Inc(CalendarDays);

   if Emp.CalculateType<>4 then
   begin
    if (DayOfWeek(StartDate)<>1) and (not IsHoliday(StartDate)) then
     Inc(Period)
    else
     if (DayOfWeek(StartDate)=1) and (IsHoliday(StartDate)) then
      Dec(Period);
   end else//Если это общие средние
   if (not IsFreeDay(StartDate)) and (not IsHoliday(StartDate)) then
   begin
    Inc(Period);
   end else
    if (IsFreeDay(StartDate)) and (IsHoliday(StartDate)) then Dec(Period);

   if Emp.CalculateSubType=3 then Period:=CalendarDays;//В расчёте по календ. дням они равны

   if (not IsFreeDay(StartDate)) and (not IsHoliday(StartDate)) then
   begin
    if (DayOfWeek(StartDate)=6) or (IsHoliday(IncDay(StartDate,1))) then
     PeriodInHours:=PeriodInHours+FridayInc//Прибавить в зависимости от разряд-сетки
    else
     PeriodInHours:=PeriodInHours+WorkInc;
   end else
    if (IsFreeDay(StartDate)) and (IsHoliday(StartDate)) then
    begin
     PeriodInHours:=PeriodInHours-WorkInc;
    end;

   if IsLastDay(StartDate) then
   begin//Заполнение периодов
    AddLeaveDataRecord(ALeave,StartDate,Period,PeriodInHours,CalendarDays);
    Inc(A);if A>3 then A:=3;
    Period:=0;
    PeriodInHours:=0;
    CalendarDays:=0;
   end;
   StartDate:=IncDay(StartDate,1);
  end;
  if CalendarDays>0 then//Заполнение LAST периодa
   AddLeaveDataRecord(ALeave,StartDate,Period,PeriodInHours,CalendarDays);
 end else
 begin
  AddLeaveDataRecord(ALeave,StartDate,0,0,0);
 end;
end;

procedure DoCalculate;
var I:Integer;
    AveragePayOld:Currency;
    MonthHour,Cooficient,Znamenatel:Double;
begin
 //Расчёт по средним
 MonthHour:=166.7;
 //Материальная помощь
 if Emp.CalculateType in [1,3,7] then
  Lucre:=CoolRound(Emp.PayPercent*GetMinPay(Emp.StartDate)*GetLeaveConst08/100,CurrencyDecimals);
 if GetLeaveConst09=5 then Cooficient:=1.2 else Cooficient:=1;
 AveragePay:=ASalaryInfo[0].Pay+ASalaryInfo[1].Pay+ASalaryInfo[2].Pay;//Числитель
 case Emp.CalculateSubType of
  //По 6 дневной
  1:begin
     Znamenatel:=0;
     if ASalaryInfo[0].ODays=ASalaryInfo[0].NDays then Znamenatel:=Znamenatel+GetLeaveConst13 else Znamenatel:=Znamenatel+ASalaryInfo[0].ODays*Cooficient;
     if ASalaryInfo[1].ODays=ASalaryInfo[1].NDays then Znamenatel:=Znamenatel+GetLeaveConst13 else Znamenatel:=Znamenatel+ASalaryInfo[1].ODays*Cooficient;
     if ASalaryInfo[2].ODays=ASalaryInfo[2].NDays then Znamenatel:=Znamenatel+GetLeaveConst13 else Znamenatel:=Znamenatel+ASalaryInfo[2].ODays*Cooficient;
     AveragePay:=AveragePay/Znamenatel;
    end;
  //Суммированный
  2:begin
     Znamenatel:=0;
     if ASalaryInfo[0].OHours=ASalaryInfo[0].NHours then Znamenatel:=Znamenatel+MonthHour else Znamenatel:=Znamenatel+ASalaryInfo[0].OHours;
     if ASalaryInfo[1].OHours=ASalaryInfo[1].NHours then Znamenatel:=Znamenatel+MonthHour else Znamenatel:=Znamenatel+ASalaryInfo[1].OHours;
     if ASalaryInfo[2].OHours=ASalaryInfo[2].NHours then Znamenatel:=Znamenatel+MonthHour else Znamenatel:=Znamenatel+ASalaryInfo[2].OHours;
     AveragePay:=AveragePay/Znamenatel;
    end;
  //По календарным
  3:begin
     Znamenatel:=0;
     if ASalaryInfo[0].ODays=ASalaryInfo[0].NDays then Znamenatel:=Znamenatel+GetLeaveConst14 else Znamenatel:=Znamenatel+ASalaryInfo[0].ODays;
     if ASalaryInfo[1].ODays=ASalaryInfo[1].NDays then Znamenatel:=Znamenatel+GetLeaveConst14 else Znamenatel:=Znamenatel+ASalaryInfo[1].ODays;
     if ASalaryInfo[2].ODays=ASalaryInfo[2].NDays then Znamenatel:=Znamenatel+GetLeaveConst14 else Znamenatel:=Znamenatel+ASalaryInfo[2].ODays;
     AveragePay:=AveragePay/Znamenatel;
    end;
 end;
 AveragePay:=CoolRound(AveragePay,CurrencyDecimals);
 AveragePayOld:=AveragePay;
 AllPay:=0;
 //Заполнение месяцев нетрудоспособности
 for I:=Low(ALeave) to High(ALeave) do
 begin
  AveragePay:=AveragePayOld;
  case Emp.CalculateSubType of
   1,3:ALeave[I].OnePay:=CoolRound(ALeave[I].LeaveDaysCount*AveragePay,CurrencyDecimals);
   2:ALeave[I].OnePay:=CoolRound(ALeave[I].LeaveHoursCount*AveragePay,CurrencyDecimals);
  end;
  AllPay:=AllPay+ALeave[I].OnePay;
 end;
 AllPay:=CoolRound(AllPay,CurrencyDecimals);
end;

begin
 //Ученический всегда в календарных
 if Emp.CalculateType=2 then Emp.CalculateSubType:=3;

 //Кол-во сдвигов при получении зар.платы
 RecurseCount:=0;
 CalcShift:=0;

 //Для расчёта 3 месяца
 SetLength(ASalaryInfo,3);
 //Периодов пока нет
 SetLength(ALeave,0);
 //Заполняем ASalaryInfo
 GetSalaries(0);
 PrepareLeaveListPeriod;
 S:=EncodeDate(ExtractYear(ASalaryInfo[0].Month),ExtractMonth(ASalaryInfo[0].Month),1);
 F:=IncMonth(S,1);
 F:=IncDay(F,-1);
 ASalaryInfo[0].ODays:=Round(GetActualTime(Emp.EmpPlant_id,Emp.WorkAbsence_ids,nil,S,F,False));
 ASalaryInfo[0].OHours:=GetActualTime(Emp.EmpPlant_id,Emp.WorkAbsence_ids,nil,S,F,True);
 ASalaryInfo[0].NDays:=Round(GetNormalTime(GetEmpPlantSchedule(Emp.EmpPlant_id),nil,S,F,False,[dtOrdinary,dtFree,dtHoliday]));
 ASalaryInfo[0].NHours:=GetNormalTime(GetEmpPlantSchedule(Emp.EmpPlant_id),nil,S,F,True,[dtOrdinary,dtFree,dtHoliday]);
 S:=EncodeDate(ExtractYear(ASalaryInfo[1].Month),ExtractMonth(ASalaryInfo[1].Month),1);
 F:=IncMonth(S,1);
 F:=IncDay(F,-1);
 ASalaryInfo[1].ODays:=Round(GetActualTime(Emp.EmpPlant_id,Emp.WorkAbsence_ids,nil,S,F,False));
 ASalaryInfo[1].OHours:=GetActualTime(Emp.EmpPlant_id,Emp.WorkAbsence_ids,nil,S,F,True);
 ASalaryInfo[1].NDays:=Round(GetNormalTime(GetEmpPlantSchedule(Emp.EmpPlant_id),nil,S,F,False,[dtOrdinary,dtFree,dtHoliday]));
 ASalaryInfo[1].NHours:=GetNormalTime(GetEmpPlantSchedule(Emp.EmpPlant_id),nil,S,F,True,[dtOrdinary,dtFree,dtHoliday]);
 S:=EncodeDate(ExtractYear(ASalaryInfo[2].Month),ExtractMonth(ASalaryInfo[2].Month),1);
 F:=IncMonth(S,1);
 F:=IncDay(F,-1);
 ASalaryInfo[2].ODays:=Round(GetActualTime(Emp.EmpPlant_id,Emp.WorkAbsence_ids,nil,S,F,False));
 ASalaryInfo[2].OHours:=GetActualTime(Emp.EmpPlant_id,Emp.WorkAbsence_ids,nil,S,F,True);
 ASalaryInfo[3].NDays:=Round(GetNormalTime(GetEmpPlantSchedule(Emp.EmpPlant_id),nil,S,F,False,[dtOrdinary,dtFree,dtHoliday]));
 ASalaryInfo[3].NHours:=GetNormalTime(GetEmpPlantSchedule(Emp.EmpPlant_id),nil,S,F,True,[dtOrdinary,dtFree,dtHoliday]);
 DoCalculate;
end;

end.

