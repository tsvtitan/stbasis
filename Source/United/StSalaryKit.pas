unit StSalaryKit;

{$I stbasis.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URptMain, OleCtnrs, StdCtrls, Buttons, ExtCtrls, Excel97, ComCtrls, IBQuery,
  IBDatabase, Db, IBCustomDataSet, Grids, DBGrids, Spin, DateUtil, USalaryVAVDAta;

type

// TStCalendar=class(TRxCalendar)
  PInfoChargeTree=^TInfoChargeTree;
  TInfoChargeTree=packed record
                       chargetree_id: Integer; //
                       charge_id: Integer; //
                       parent_id: Integer; //
                       chargename:String; //Наименование начисления
                       algorithm_id:Integer; //ID Алгоритма начисления
                       typefactorworktime:Integer; //
                       typebaseamount:Integer;//
                       typepercent:Integer;//
                       typemultiply:Integer;//
                       bs_amountmonthsback:Integer;//
                       bs_totalamountmonths:Integer;//
                       bs_divideamountperiod:Integer;//
                       bs_multiplyfactoraverage:Currency;//
                       bs_salary:Currency;//
                       bs_tariffrate:Currency;//
                       bs_averagemonthsbonus:Currency;//
                       bs_annualbonuses:Currency;//
                       bs_minsalary:Currency;//
                       krv_typeratetime:Integer;//
                       krv_amountmonthsback:Integer;//
                       krv_totalamountmonths:Integer;//
                       u_besiderowtable:Integer;//
                       typepay_id:Integer;//ID вида доплаты
                       name: string;//Наименование алгоритма
                       tmps:string;//
                       fallsintototal:Integer;//Входит в итого?
                       fixedamount:Currency;//Фикс. сумма
                       fixedrateathours:Currency;//Фикс. норма в часах
                       fixedpercent:Currency;//Фикс. процент
      ListParent: TList;
      List: TList;

      end;

// private

// public

// end;

  procedure CalculateInit(DB:TIBDatabase);
  procedure CalculateDone;
  procedure FillGridColumns (ds:TDataSet; dbg: TDBGrid); ///:TColumn; //Функция заполнения Grid'a
  function recurseListnew(List: TList; tmps: string;charge_id:integer):PInfoChargeTree;
  function CreatePrivelege (emplant_id:integer;Year:string;SP,DP:Double): bool; //Функция создания записи о льготах по месту работы
  function GetOklad (emplant_id:integer): double; //Функция получения оклада по месту работы
  function GetBaseSumm     (P: PInfoChargeTree; empplant_id:integer;Summ:currency): currency;//Функция получения базовой суммы для начисления
  function GetNormWorkTime (P: PInfoChargeTree; empplant_id:integer;NormWorkTime:double): double;//Функция получения коэффициента нормы рабочего времени
  function GetFaktWorkTime (P: PInfoChargeTree; empplant_id:integer;FaktWorkTimeDays:double;FaktWorkTimeHours:double): double;//Функция получения фактического отработанного времени
  function GetPercent      (P: PInfoChargeTree; empplant_id:integer;Percent:Double): double;//Функция получения процента на начисление
  function GetCurrentYear (CalcPeriod_ID:Integer): String;//Функция получения года любого периода
  function GetCurrentMonth(CalcPeriod_ID:Integer):Integer ;//Функция получения месяца любого периода
  function GetTypeCategory (qr: TIBQuery) : integer;//Функция получения типа категории 1:Оклад, 2:Тариф, 3:Сдельная
  function GetCategory (emplant_id:integer) : integer;//Функция получения категории 1:Основной, 2:Совместитель
  function GetMROT (date_:Tdate) : double;//Функция получения размера минимальной оплаты труда
  function GetStazhOM (OnDate:Tdate;emp_id:integer) : double;//Функция получения стажа в месяцах по основному месту работы
  function GetPercentNalog (List:TList;i:integer;emplant_id:integer): double;//Функция получения процента районного коэффициента
  function GetWorking (CalcPeriod:Integer;emplant_id:integer): boolean;//Функция получения работал человек в период или нет
//  function GetIDCurCalcPeriod (qr: TIBQuery): Integer;//Функция получения ID текущего периода
  function GetIDPrevCalcPeriod : Integer;//Функция получения ID текущего периода &&&&&&&&&&&&&&&&&&&&&

  function GetIDCurCalcPeriod : Integer;//Функция получения ID текущего периода
  function GetIDNextCalcPeriod : Integer;//Функция получения ID следующего периода
  function GetStatusCurCalcPeriod : Integer;//Функция получения статуса текущего периода
  function GetCurCalcPeriodStartDate  : TdateTime;//Функция получения даты начала текущего периода
  function GetNewCalcPeriod : TdateTime;//Функция получения даты нового периода
  function GetCalcPeriodStartDate (calcperiod_id:Integer): TdateTime;//Функция получения даты начала любого периода
  function GetQuantityOfDependent (emplant_id:integer) : integer;//Получение количества иждевенцев
  function GetAnyCalendarID(InDate:Tdate):Integer;
  function GetCalendar_ID(emplant_id:integer;InDate:Tdate):Integer;
  function GetOnSalary(empplant_id:integer;calcperiod_id:Integer;charge_id:integer):Currency;    //Возвращает начисления входящие в данное начисление
//  function GetRadioCase: Integer;
  //  function GetPercentNalog (List:TList;i:integer;emplant_id:integer; qr: TIBQuery): double;//Функция получения процента подоходного налога
  function GetCalcPeriodByDate(D:TDateTime):Integer;//Функция получения ID
//  function FillGridColumns (ds:TDataSet):TColumn;//Функция заполнения Grid'a

implementation

uses {USalaryVAVCode,}URptThread,comobj,UMainUnited,ActiveX,
     {USalaryVAVData, }StCalendarUtil{,USalaryVAVOptions};

function GetOnSalary(empplant_id:integer;calcperiod_id:Integer;charge_id:integer):Currency;    //Возвращает начисления входящие в данное начисление
begin
 Result:=0;
end;

function _ViewInterfaceFromName(Name: PChar; Param: Pointer): Boolean; stdcall;
                                external MainExe name ConstViewInterfaceFromName;

{function _ViewEntryFromMain(TypeEntry: TTypeEntry; Params: Pointer;
                            isModal: Boolean; OnlyData: Boolean=false):Boolean;stdcall;
                         external MainExe name ConstViewEntryFromMain;
 }
const
  //Включенное кеширование данных существенно ускоряет процессы
  //получения данных, но создаёт проблемму их актуальности
  CacheHoliday:Boolean=True;
  CacheCarry:Boolean=True;

var
//  dbSTBasis: TIBDatabase;
//  quHoliday:TIBQuery;
//  quCarry:TIBQuery;
//  trInternal:TIBTransaction;
//  isCalendarUtilInit:Boolean=False;
  WorkDB:TIBDatabase=nil;
  TrRead,TrWrite:TIBTransaction;


procedure CalculateInit(DB:TIBDatabase);
begin
 CalculateDone;

 WorkDB:=DB;
 if WorkDB<>nil then
 begin
  TrRead:=TIBTransaction.Create(nil);
  TrRead.DefaultDatabase:=DB;
  TrRead.Params.Add('read_committed');
  TrRead.Params.Add('rec_version');
  TrRead.Params.Add('nowait');
  TrRead.DefaultAction:=TARollback;

  TrWrite:=TIBTransaction.Create(nil);
  TrWrite.DefaultDatabase:=DB;
  TrWrite.Params.Add('read_committed');
  TrWrite.Params.Add('rec_version');
  TrWrite.Params.Add('nowait');
  TrWrite.DefaultAction:=TARollback;
 end;
end;

procedure CalculateDone;
begin
 if TrRead<>nil then FreeAndNil(TrRead);
 if TrWrite<>nil then FreeAndNil(TrWrite);
 WorkDB:=nil;
end;

//////////////////////////////////////////////////////////////////
//Получение оклада из карточки места работы
//////////////////////////////////////////////////////////////////
function GetOklad (emplant_id:integer): double;
var
//        i:integer;
        qrnew: TIBQuery;
        newsql:string;
        oklad:double;
begin

  Result:=-1;
  if WorkDB=nil then Exit;

//  qrnew:=TIBQuery.Create(nil);

 oklad:=0;
  //Получение оклада
  qrnew:=TIBQuery.Create(nil);
  try
   qrnew.Database:=WorkDB;//qr.Database;
   qrnew.Transaction:=TrRead;//qr.Transaction;
   newsql:= 'select e.name as name,  factpay.pay from empplant em join factpay fp  on fp.empplant_id='+ IntToStr(emplant_id) +' join emp e on em.emp_id=e.emp_id';
   qrnew.SQL.Add(newsql);
//   qrnew.DataSource:=qr.DataSource;
//   qrnew.Params.AssignValues(qr.Params);
   qrnew.Active:=true;
        if not qrnew.IsEmpty then begin
        //   if qrnew.RecordCount=1 then begin
             oklad:=qrnew.FieldByName('pay').AsInteger;
        end;
   finally
   qrnew.free;
//   Screen.Cursor:=crDefault;
   end;
     Result:=oklad;
end;


//////////////////////////////////////////////////////////////////
//Получение базовой суммы для расчета
//////////////////////////////////////////////////////////////////
function GetBaseSumm (P: PInfoChargeTree;empplant_id:integer;Summ:currency): currency;
var
    schedule_id: Integer;    
  ResultSumm :currency;
  BaseSumm:currency;
  i:Integer;
  qrnew:TIBQuery;
  sqls:String;
   FactDay:double;
   FactEvening:double;
   FactNight:double;
   Fact:double;
   calcstartdate:TDate;
 calcenddate:TDate;
 NormaDay:double;
NormaEvening:double;
NormaNight:double;
   Norma:double;
//    Ps: PScheduleParams;
  ////////////////////////////////////
  //Added by Volkov
  IDs1,IDs2:TRecordsIDs;
  ////////////////////////////////////
begin
  SetLength(IDs1,1);
  SetLength(IDs2,1);
  ResultSumm :=0;
  case P.typebaseamount of
//Ввод суммы вручную (все поля БС скрыты)
  0:  begin
//При вводе напрямую или в постоянные
  ResultSumm:=Summ;
      end;
//Фикс сумма (все поля БС скрыты)
  1:  begin
//Берем значение из таблицы начислений удержаний
  ResultSumm:=P.fixedamount;
      end;
//Сальдо на начало периода (все поля БС скрыты)
  2:  begin
     ResultSumm:=Summ;
      end;
//Из персональной карточки (оклад,тариф,среднемес премия,годовая премия, мин зарплата)
  3:  begin
       ResultSumm:=P.bs_salary*GetOklad(empplant_id);
       ResultSumm:=ResultSumm+P.bs_minsalary*GetMROT(now);
      end;
//Вычисляемая (все)
  4:  begin

       ResultSumm:=P.bs_salary*GetOklad(empplant_id);
       ResultSumm:=ResultSumm+P.bs_minsalary*GetMROT(now);


  if WorkDB=nil then Exit;

  qrnew:=TIBQuery.Create(nil);
  try
   qrnew.Database:=WorkDB;//qr.Database;
   qrnew.Transaction:=TrRead;//qr.Transaction;
        sqls:='select SUM(sal.summa) as summa'+
              ' from ' + tbSalary + ' sal'+
              ' join ' + tbcalcperiod + ' cp on sal.calcperiod_id = cp.calcperiod_id '+
              ' join ' + tbcalcperiod + ' cp1 on  sal.correctperiod_id = cp1.calcperiod_id'+
              ' join ' + tbemp + ' e on  sal.creatoremp_id = e.emp_id'+
              ' join ' + tbemp + ' ee on  sal.modifycatoremp_id = ee.emp_id'+
              ' join ' + tbcharge + ' ch on  sal.charge_id in (select ch.charge_id from charge where ch.flag=0)'+
              ' where sal.empplant_id ='+ inttostr(empplant_id)+' '+
              ' and sal.calcperiod_id in (select cp.calcperiod_id from '+tbCalcperiod+
              ' where cp.startdate >= ''' +DateToStr(IncMonth(GetCurCalcPeriodStartDate,-(P.bs_amountmonthsback)))+''' and '+
              ' cp.startdate <''' +DateToStr(GetCurCalcPeriodStartDate)+''') ';
   qrnew.SQL.Add(sqls);
   qrnew.Active:=true;
        if not qrnew.IsEmpty then begin
             BaseSumm:=qrnew.FieldByName('SUMMA').AsInteger;
        end;
   finally
   qrnew.free;
//   Screen.Cursor:=crDefault;
   end;
   calcstartdate:=GetCurCalcPeriodStartDate;
   calcenddate:=IncMonth(calcstartdate,-(P.bs_amountmonthsback));;

   IDs1[0]:=11;
   IDs2[0]:=1;
   FactDay:=GetActualTime(EmpPlant_id,IDs1,IDs2,calcstartdate, calcenddate,True);
   IDs2[0]:=2;
   FactEvening:=GetActualTime(EmpPlant_id,IDs1,IDs2,calcstartdate, calcenddate,True);
   IDs2[0]:=3;
   FactNight:=GetActualTime(EmpPlant_id,IDs1,IDs2,calcstartdate, calcenddate,True);
   Fact:=FactDay+FactEvening+FactNight;


   ResultSumm:=BaseSumm/Fact;




      end;
//Сложное начисление
  5:  begin
     ResultSumm:=Summ;
      end;
  6:  begin
     //Получить текущий календарь и график
   calcstartdate:=GetCurCalcPeriodStartDate;
   calcenddate:=IncMonth(calcstartdate,1)-1;;
 try
  schedule_id:= GetCalendar_ID(empplant_id,calcstartdate) ;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;



   IDs2[0]:=1;
NormaDay:=GetNormalTime(Schedule_id,IDs2,calcstartdate, calcenddate,True,[dtOrdinary,dtFree,dtHoliday]);
   IDs2[0]:=2;
NormaEvening:=GetNormalTime(Schedule_id,IDs2,calcstartdate, calcenddate,True,[dtOrdinary,dtFree,dtHoliday]);
   IDs2[0]:=3;
NormaNight:=GetNormalTime(Schedule_id,IDs2,calcstartdate, calcenddate,True,[dtOrdinary,dtFree,dtHoliday]);


   Norma:=NormaDay+NormaEvening+NormaNight;
   //Получаю факт по табелю по отработанным дням
//GetActualTime(EmpPlant_id,Absence_id,Shift_id:Integer;StartDate,EndDate:TDateTime):Double;
   IDs2[0]:=1;
   FactDay:=GetActualTime(EmpPlant_id,IDs1,IDs2,calcstartdate, calcenddate,True);
   IDs2[0]:=2;
   FactEvening:=GetActualTime(EmpPlant_id,IDs1,IDs2,calcstartdate, calcenddate,True);
   IDs2[0]:=3;
   FactNight:=GetActualTime(EmpPlant_id,IDs1,IDs2,calcstartdate, calcenddate,True);
   Fact:=FactDay+FactEvening+FactNight;


  //Проверить когда принят на работу (в табеле)
  //Проверить уволен-ли? (в табеле)
  //Проверить были среди месяца повышения или понижения?
  //Получить его фактический оклад за месяц
        if (norma<>0) then
        ResultSumm:= (GetOklad(empplant_id)/norma)*(FactDAy+FactEvening*1.5+FactNight*2)
        else
        ResultSumm:= 0
        
  end;
  end;
  Result:=ResultSumm;
end;

//////////////////////////////////////////////////////////////////
//Вычисление нормы рабочего времени
//////////////////////////////////////////////////////////////////
function GetNormWorkTime (P: PInfoChargeTree; empplant_id:integer;NormWorkTime:double): double;
var
  ResNormWorkTime :double;
//    Ps: PScheduleParams;
    schedule_id: Integer;    
   calcstartdate:TDate;
 calcenddate:TDate;
 NormaDay:double;
NormaEvening:double;
NormaNight:double;
   Norma:double;

   ////////////////////////////
   IDs1:TRecordsIDs;
   ////////////////////////////
begin
  ResNormWorkTime:=1;
  case P.typefactorworktime of
//Неиспользуется (все поля скрыты)
  0:  begin
      end;
//Из графика раб времени (вид нормо-времени)
  1:  begin
   //Получить текущий календарь и график
    //Получаю норму по графику
//GetNormalTime(Schedule_id,Shift_id:Integer;StartDate,EndDate:TDateTime):Double;
 calcstartdate:=GetCurCalcPeriodStartDate;
 calcenddate:=IncMonth(calcstartdate,1)-1;
 try
  schedule_id:= GetCalendar_ID(empplant_id,calcstartdate) ;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;

 setLength(IDs1,1);
 IDs1[0]:=1;
 NormaDay:=GetNormalTime(Schedule_id,IDs1,calcstartdate, calcenddate,True,[dtOrdinary,dtFree,dtHoliday]);
 IDs1[0]:=2;
NormaEvening:=GetNormalTime(Schedule_id,IDs1,calcstartdate, calcenddate,True,[dtOrdinary,dtFree,dtHoliday]);
 IDs1[0]:=3;
NormaNight:=GetNormalTime(Schedule_id,IDs1,calcstartdate, calcenddate,True,[dtOrdinary,dtFree,dtHoliday]);


Norma:=NormaDay+NormaEvening+NormaNight;
ResNormWorkTime:=Norma;

      end;
//Фикс норма (все поля скрыты)
  2:  begin
//Берем значение из таблицы начислений удержаний
  ResNormWorkTime:=P.fixedrateathours;
      end;
//Вычисляется (все)
  3:  begin
     //Необходимо доделать

      end;
  end;
  Result:=ResNormWorkTime;
end;

//////////////////////////////////////////////////////////////////
//Вычисление фактически отработанного времени
//////////////////////////////////////////////////////////////////
function GetFaktWorkTime (P: PInfoChargeTree; empplant_id:integer;FaktWorkTimeDays:double;FaktWorkTimeHours:double): double;
var
  ResFaktWorkTime :double;
   FactDay:double;
   FactEvening:double;
   FactNight:double;
   Fact:double;
   calcstartdate:TDate;
 calcenddate:TDate;
//  i:integer;
 ////////////////////////////
  //Added by Volkov
  IDs1,IDs2:TRecordsIDs;
 ////////////////////////////
begin
 calcstartdate:=GetCurCalcPeriodStartDate;
 calcenddate:=IncMonth(calcstartdate,1)-1;


   SetLength(IDs1,1);
   SetLength(IDs2,1);
   IDs1[0]:=11;
   IDs2[0]:=1;

  ResFaktWorkTime:=1;
//  P:=List.Items[i];
  case P.typemultiply of
//Неиспользуется (все поля скрыты)
  0:  begin
      end;
//Рабочие дни (все поля скрыты)
  1:  begin
   IDs2[0]:=1;
   FactDay:=GetActualTime(EmpPlant_id,IDs1,IDs2,calcstartdate, calcenddate, True);
   IDs2[0]:=2;
   FactEvening:=GetActualTime(EmpPlant_id,IDs1,IDs2,calcstartdate, calcenddate, True);
   IDs2[0]:=3;
   FactNight:=GetActualTime(EmpPlant_id,IDs1,IDs2,calcstartdate, calcenddate, True);
   Fact:=FactDay+FactEvening+FactNight;
   ResFaktWorkTime:=Fact;
      end;

//Рабочие часы (все поля скрыты)
  2:  begin
   IDs2[0]:=1;
   FactDay:=GetActualTime(EmpPlant_id,IDs1,IDs2,calcstartdate, calcenddate, True);
   IDs2[0]:=2;
   FactEvening:=GetActualTime(EmpPlant_id,IDs1,IDs2,calcstartdate, calcenddate, True);
   IDs2[0]:=3;
   FactNight:=GetActualTime(EmpPlant_id,IDs1,IDs2,calcstartdate, calcenddate, True);
   Fact:=FactDay+FactEvening+FactNight;
   ResFaktWorkTime:=Fact;
      end;
//Из колонки табеля (Вид неявки)
  3:  begin
   IDs2[0]:=1;
   IDs1[0]:=P.u_besiderowtable;
   FactDay:=GetActualTime(EmpPlant_id,IDs1,IDs2,calcstartdate, calcenddate, True);
   IDs2[0]:=2;
   FactEvening:=GetActualTime(EmpPlant_id,IDs1,IDs2,calcstartdate, calcenddate, True);
   IDs2[0]:=3;
   FactNight:=GetActualTime(EmpPlant_id,IDs1,IDs2,calcstartdate, calcenddate, True);
   Fact:=FactDay+FactEvening+FactNight;
   ResFaktWorkTime:=Fact;
      end;
  4:  begin
  //Берем значение из таблицы начислений удержаний
  ResFaktWorkTime:=P.fixedamount;
      end;
  end;
  Result:=ResFaktWorkTime;
end;

//////////////////////////////////////////////////////////////////
//Получение процента на начисление
//////////////////////////////////////////////////////////////////
function GetPercent (P: PInfoChargeTree; empplant_id:integer;Percent:Double): double;
var
  ResPercent :double;
  StazhOM:Double;
        qrnew: TIBQuery;
        newsql:string;

begin
  ResPercent:=-100;  
  case P.typepercent of
//Неиспользуется (все поля скрыты)
  0:  begin
      end;
//Фикс процент (все поля скрыты)
  1:  begin
//Берем значение из таблицы начислений удержаний
  ResPercent:=P.fixedpercent;
      end;
//Ввод процента вручную (все поля скрыты)
  2:  begin
       ResPercent:=percent;
      end;
//Процент больничного листа (все поля скрыты)
  3:  begin
       ResPercent:=percent;
      end;
//Фикс процент доплат от стажа умноженный на процент больничного листа (Процент доплат от стажа)
  4:  begin
           StazhOM:=GetStazhOM(GetCurCalcPeriodStartDate,empplant_id);
           
      end;
//Из таблицы процентов от стажа(Процент доплат от стажа)
  5:  begin

  Result:=-1;
  if WorkDB=nil then Exit;

  qrnew:=TIBQuery.Create(nil);
  try
        StazhOM:=GetStazhOM(GetCurCalcPeriodStartDate,empplant_id);
   qrnew.Database:=WorkDB;//qr.Database;
   qrnew.Transaction:=TrRead;//qr.Transaction;
   newsql:=         'select * from EXPERIENCEPERCENT ex where typepay_id = '+IntToStr(P.typepay_id)+ 'and  ex.EXPERIENCE <= '+FloatToStr(StazhOM) +' order by ex.EXPERIENCE DESC';
   qrnew.SQL.Add(newsql);
//   qrnew.DataSource:=qr.DataSource;
//   qrnew.Params.AssignValues(qr.Params);
   qrnew.Active:=true;
        if not qrnew.IsEmpty then begin
        //   if qrnew.RecordCount=1 then begin
             ResPercent:=qrnew.FieldByName('PERCENT').AsCurrency;
        end;
   finally
   qrnew.free;
//   Screen.Cursor:=crDefault;
   end;
      end;
  end;
  Result:=ResPercent;
end;
//***************************************************************************


function GetCurrentYear(CalcPeriod_ID:Integer):String ;
var
 Present: TDateTime;
  Year, Month, Day: Word;

begin

  Present:= GetCalcPeriodStartDate (CalcPeriod_ID);
  DecodeDate(Present, Year, Month, Day);
  //  IntToStr(Month)
//  IntToStr(Year);

 Result:=IntToStr(Year);
end;

function GetCurrentMonth(CalcPeriod_ID:Integer):Integer ;
var
 Present: TDateTime;
  Year, Month, Day: Word;
begin
  Present:= GetCalcPeriodStartDate (CalcPeriod_ID);
  DecodeDate(Present, Year, Month, Day);
  Result:=Month;
end;


function GetTypeCategory(qr: TIBQuery) : integer;//Функция получения категории
var
  TPRBI: TParamRBookInterface;
// P: PConstParams;
 i1,i2,i3:integer;
begin
//  GetMem(P,sizeof(TConstParams));
 try
   FillChar(TPRBI,SizeOf(TPRBI),0);
   TPRBI.Visual.TypeView:=tviOnlyData;
//   TPRBI.Locate.KeyFields:='calcperiod_id';
//   TPRBI.Locate.KeyValues:=calcperiod_id;
   TPRBI.Locate.Options:=[loCaseInsensitive];
   if _ViewInterfaceFromName(NameConst,@TPRBI) then begin
        //Если оклад
        if (qr.FieldBYName('CATEGORY_ID').AsInteger =GetFirstValueFromParamRBookInterface(@TPRBI,'salarycategorytype_id'))
                then Result:=1;
        //Если тариф
        if (qr.FieldBYName('CATEGORY_ID').AsInteger =GetFirstValueFromParamRBookInterface(@TPRBI,'tariffcategorytype_id'))
                then Result:=2;
        //Если сдельная
        if (qr.FieldBYName('CATEGORY_ID').AsInteger =GetFirstValueFromParamRBookInterface(@TPRBI,'pieceworkcategorytype_id'))
                then Result:=3;
   end;
  finally
//   FreeMem(P,sizeof(TConstParams));
//   fm.Free;
  end;
end;

function GetMROT (date_:Tdate):double;
var
        i:integer;
        qrnew: TIBQuery;
        newsql:string;
        mrot:double;
begin
 mrot:=0;
  Result:=-1;
  if WorkDB=nil then Exit;

  qrnew:=TIBQuery.Create(nil);
  try
   qrnew.Database:=WorkDB;//qr.Database;
   qrnew.Transaction:=TrRead;//qr.Transaction;
   newsql:= 'select  * from MROT where startdate<''' + DateToStr(date_) +''''+' and enddate > '''+DateToStr(date_)+'''';
   qrnew.SQL.Add(newsql);
//   qrnew.DataSource:=qr.DataSource;
//   qrnew.Params.AssignValues(qr.Params);
   qrnew.Active:=true;
        if not qrnew.IsEmpty then begin
        //   if qrnew.RecordCount=1 then begin
             mrot:=qrnew.FieldByName('SUMMA').AsInteger;
        end;
   finally
   qrnew.free;
   Screen.Cursor:=crDefault;
   end;
     Result:=mrot;
 end;

function GetStazhOM (OnDate:TDate;emp_id:integer) : double;
var
        i:integer;
        qrnew: TIBQuery;
        newsql:string;
        StazhOM:double;
        datestart_:Tdate;
begin
   StazhOM:=0;
  Result:=-1;
  if WorkDB=nil then Exit;

  qrnew:=TIBQuery.Create(nil);
  try
   qrnew.Database:=WorkDB;//qr.Database;
   qrnew.Transaction:=TrRead;//qr.Transaction;
   newsql:= 'select  datestart from emplaborbook where emp_id =' + IntToStr(emp_id) +' and mainprof =1';
   qrnew.SQL.Add(newsql);
//   qrnew.DataSource:=qr.DataSource;
//   qrnew.Params.AssignValues(qr.Params);
   qrnew.Active:=true;
        if not qrnew.IsEmpty then begin
             datestart_:=qrnew.FieldByName('datestart').AsInteger;
             StazhOM:=MonthsBetween(OnDate,datestart_);
        end;
   finally
   qrnew.free;
   Screen.Cursor:=crDefault;
   end;
     Result:=StazhOM;
 end;
function GetPercentNalog (List:TList;i:integer;emplant_id:integer): double;//Функция получения процента налога
begin
end;

function GetWorking (CalcPeriod:Integer;emplant_id:integer): boolean;
var
        Working:boolean;
        qrnew: TIBQuery;
        newsql:string;
        StazhOM:double;
        datestart_:Tdate;
begin
   Working:=false;
{

select * from empplant em where em.emp_id = 77
and em.datestart < (select startdate from calcperiod cp where cp.calcperiod_id =2)
and (em.releasedate is null or em.releasedate > (select enddate from calcperiod cp where cp.calcperiod_id =2))
  select m1.summa from mrot m1 where
 (m1.startdate=(select max(m2.startdate) from mrot m2 where m2.startdate < '02.01.2000'))
}
//  Result:=-1;
  if WorkDB=nil then Exit;

  qrnew:=TIBQuery.Create(nil);
  try
   qrnew.Database:=WorkDB;//qr.Database;
   qrnew.Transaction:=TrRead;//qr.Transaction;
//   newsql:= 'select  datestart from emplaborbook where emp_id =' + IntToStr(emp_id) +' and mainprof =1';
   qrnew.SQL.Add(newsql);
//   qrnew.DataSource:=qr.DataSource;
//   qrnew.Params.AssignValues(qr.Params);
   qrnew.Active:=true;
        if not qrnew.IsEmpty then begin
        //   if qrnew.RecordCount=1 then begin
             datestart_:=qrnew.FieldByName('datestart').AsInteger;
             //int let=365*5+floor(5/4);
             Working:=true;
        end;
   finally
   qrnew.free;
   Screen.Cursor:=crDefault;
   end;
     Result:=Working;
 end;


function GetNewCalcPeriod ():TdateTime;
var
        NewDate:Tdate;
        qrnew: TIBQuery;
        newsql:string;
        StazhOM:double;
begin
  Result:=-1;
  if WorkDB=nil then Exit;

  qrnew:=TIBQuery.Create(nil);
  try
   qrnew.Database:=WorkDB;//qr.Database;
   qrnew.Transaction:=TrRead;//qr.Transaction;
   newsql:= 'select max(startdate) from calcperiod';
   qrnew.SQL.Add(newsql);
//   qrnew.DataSource:=qr.DataSource;
//   qrnew.Params.AssignValues(qr.Params);
   qrnew.Active:=true;
        if not qrnew.IsEmpty then begin
             NewDate:=qrnew.FieldByName('MAX').AsDAteTime;
        end;
   finally
   qrnew.free;
   Screen.Cursor:=crDefault;
   end;

     NewDate:=IncDate(NewDate,0,1,0);
     Result:=NewDate;
 end;
//function GetIDCurCalcPeriod (qr: TIBQuery ):Integer;//Функция получения ID текущего периода
function GetIDCurCalcPeriod :Integer;//Функция получения ID текущего периода
var
        IDCurCalcPeriod:Integer;
        qrnew: TIBQuery;
        newsql:string;
//        StazhOM:double;
begin
  Result:=GetCurCalcPeriodID(WorkDB);
  exit;
  Result:=-1;
  if WorkDB=nil then Exit;

  qrnew:=TIBQuery.Create(nil);
  try
   qrnew.Database:=WorkDB;//qr.Database;
   qrnew.Transaction:=TrRead;//qr.Transaction;
   newsql:= 'select * from calcperiod where status = 2 or  status = 1';
{            0: fm.LStatus.Caption:='Не использован';
            1: fm.LStatus.Caption:='Межпериодный';
            2: fm.LStatus.Caption:='Период открыт';
            3: fm.LStatus.Caption:='Период закрыт';}
   qrnew.SQL.Add(newsql);
//   qrnew.DataSource:=qr.DataSource;
//   qrnew.Params.AssignValues(qr.Params);
   qrnew.Active:=true;
        if not qrnew.IsEmpty then begin
             IDCurCalcPeriod:=qrnew.FieldByName('CalcPeriod_ID').AsInteger;
        end;
   finally
   qrnew.free;
   Screen.Cursor:=crDefault;
   end;
     Result:=IDCurCalcPeriod;
 end;
//*******************************************************************************

  function GetStatusCurCalcPeriod (): Integer;//
var
        StatusCurCalcPeriod:Integer;
        qrnew: TIBQuery;
        newsql:string;
begin
  Result:=-1;
  if WorkDB=nil then Exit;

  qrnew:=TIBQuery.Create(nil);
  try
   qrnew.Database:=WorkDB;//qr.Database;
   qrnew.Transaction:=TrRead;//qr.Transaction;
   newsql:= 'select * from calcperiod where  calcperiod_id= '+ IntToStr(GetIDCurCalcPeriod ({qrnew}));
{            0: fm.LStatus.Caption:='Не использован';
            1: fm.LStatus.Caption:='Межпериодный';
            2: fm.LStatus.Caption:='Период открыт';
            3: fm.LStatus.Caption:='Период закрыт';}
   qrnew.SQL.Add(newsql);
//   qrnew.DataSource:=qr.DataSource;
//   qrnew.Params.AssignValues(qr.Params);
   qrnew.Active:=true;
        if not qrnew.IsEmpty then begin
             StatusCurCalcPeriod:=qrnew.FieldByName('status').AsInteger;
        end;
   finally
   qrnew.free;
   Screen.Cursor:=crDefault;
   end;
     Result:=StatusCurCalcPeriod;
 end;

//*******************************************************************************
  function GetIDNextCalcPeriod : Integer;//Функция получения ID следующего периода
var
        IDNextCalcPeriod:Integer;
        qrnew: TIBQuery;
        newsql:string;
        DateNewPeriod:TdateTime;
begin
  Result:=-1;
  if WorkDB=nil then Exit;

  qrnew:=TIBQuery.Create(nil);
  try
   qrnew.Database:=WorkDB;//qr.Database;
   qrnew.Transaction:=TrRead;//qr.Transaction;

//Сначала нахожу текущий период
//Определяю дату следующего периода
//Опредедяю ID следующего периода

  DateNewPeriod:=IncMonth(GetCurCalcPeriodStartDate (),1);


   newsql:= 'select * from calcperiod where startdate = '''+DateTimeToStr(DateNewPeriod)+'''';
{            0: fm.LStatus.Caption:='Не использован';
            1: fm.LStatus.Caption:='Межпериодный';
            2: fm.LStatus.Caption:='Период открыт';
            3: fm.LStatus.Caption:='Период закрыт';}
   qrnew.SQL.Add(newsql);
//   qrnew.DataSource:=qr.DataSource;
//   qrnew.Params.AssignValues(qr.Params);
   qrnew.Active:=true;
        if not qrnew.IsEmpty then begin
             IDNextCalcPeriod:=qrnew.FieldByName('CalcPeriod_ID').AsInteger;
        end
        else
        ShowMessage('Пополните справочник рассчетных периодов.');

   finally
   qrnew.free;
   Screen.Cursor:=crDefault;
   end;
     Result:=IDNextCalcPeriod;
 end;

//*******************************************************************************
function GetCalcPeriodByDate(D:TDateTime):Integer;//Функция получения ID
var
   qrnew: TIBQuery;
   newsql:string;
begin
 Result:=-1;
 if WorkDB=nil then Exit;
 qrnew:=TIBQuery.Create(nil);
 try
  qrnew.Database:=WorkDB;//qr.Database;
  qrnew.Transaction:=TrRead;//qr.Transaction;
  newsql:=Format('select * from calcperiod where startdate <= ''%s'' order by startdate desc',[DateTimeToStr(D)]);
  qrnew.SQL.Add(newsql);
  qrnew.Active:=true;
  if not qrnew.IsEmpty then begin
   Result:=qrnew.FieldByName('CalcPeriod_ID').AsInteger;
  end
 finally
  qrnew.free;
  Screen.Cursor:=crDefault;
 end;
end;

  function GetCalcPeriodStartDate (calcperiod_id:Integer): TdateTime;//Функция получения даты начала любого периода
var
        CalcPeriodStartDate:TDate;
        qrnew: TIBQuery;
        newsql:string;
begin
  Result:=-1;
  if WorkDB=nil then Exit;

  qrnew:=TIBQuery.Create(nil);
  try
   qrnew.Database:=WorkDB;//qr.Database;
   qrnew.Transaction:=TrRead;//qr.Transaction;
   newsql:= 'select * from calcperiod where calcperiod_id='+ IntToStr(calcperiod_id);
   qrnew.SQL.Add(newsql);
   qrnew.Active:=true;
        if not qrnew.IsEmpty then begin
             CalcPeriodStartDate:=qrnew.FieldByName('startdate').AsDateTime;
        end;
   finally
   qrnew.free;
   Screen.Cursor:=crDefault;
   end;
     Result:=CalcPeriodStartDate;
 end;


  function GetCurCalcPeriodStartDate : TdateTime;//Функция получения даты начала текущего периода
var
        CurCalcPeriodStartDate:TDate;
        qrnew: TIBQuery;
        newsql:string;
//        StazhOM:double;
begin
  Result:=-1;
  if WorkDB=nil then Exit;

  qrnew:=TIBQuery.Create(nil);
  try
   qrnew.Database:=WorkDB;//qr.Database;
   qrnew.Transaction:=TrRead;//qr.Transaction;
   newsql:= 'select * from calcperiod where status = 2 or  status = 1';
{            0: fm.LStatus.Caption:='Не использован';
            1: fm.LStatus.Caption:='Межпериодный';
            2: fm.LStatus.Caption:='Период открыт';
            3: fm.LStatus.Caption:='Период закрыт';}
   qrnew.SQL.Add(newsql);
//   qrnew.DataSource:=qr.DataSource;
//   qrnew.Params.AssignValues(qr.Params);
   qrnew.Active:=true;
        if not qrnew.IsEmpty then begin
             CurCalcPeriodStartDate:=qrnew.FieldByName('startdate').AsDateTime;
        end;
   finally
   qrnew.free;
   Screen.Cursor:=crDefault;
   end;
     Result:=CurCalcPeriodStartDate;
 end;


  {

select * from empplant em where em.emp_id = 77
and em.datestart < (select startdate from calcperiod cp where cp.calcperiod_id =2)
and (em.releasedate is null or em.releasedate > (select enddate from calcperiod cp where cp.calcperiod_id =2))
  select m1.summa from mrot m1 where
 (m1.startdate=(select max(m2.startdate) from mrot m2 where m2.startdate < '02.01.2000'))
}

//-----------------------------------------------------------------------------
function CreatePrivelege (emplant_id:integer;Year:string;SP,DP:Double): bool; //Функция создания записи о льготах по месту работы
var
        i:integer;
        qrnew: TIBQuery;
        sqls,id:string;
        oklad:double;
begin

  Result:=false;
  if WorkDB=nil then Exit;
   try
   qrnew.Database:=WorkDB;//qr.Database;
   qrnew.Transaction:=TrWrite;//qr.Transaction;

    id:=inttostr(GetGenId(WorkDB,tbPrivelege,1));
    qrnew.Transaction.Active:=true;

    sqls:='Insert into '+tbPrivelege ;
    sqls:=sqls+      ' (Privelege_id,empplant_id,year_,sp,dp)';
    sqls:=sqls+      ' values '+' ('+id+','+ IntToStr(emplant_id) + ','+year+','+
    QuotedStr(ChangeChar(FloatToStr(sp),',','.'))+','+QuotedStr(ChangeChar(FloatToStr(dp),',','.'))+')';
    qrnew.SQL.Clear;
    qrnew.SQL.Add(sqls);
    qrnew.ExecSQL;
    qrnew.Transaction.Commit;
   finally
   qrnew.free;
   Screen.Cursor:=crDefault;
   end;
Result:=true;
end;
//-----------------------------------------------------------------------------

function recurseListnew(List: TList; tmps: string;charge_id:integer):PInfoChargeTree;
var
  i: Integer;
  P: PInfoChargeTree;
  Pnew: PInfoChargeTree;
begin
 Pnew:=nil;
 for i:=0 to List.Count-1 do
 begin
  P:=List.Items[i];
  if P.charge_id=charge_id then
  begin
//    new(Pnew);
   Pnew:=List.Items[i];
   if P.List<>nil then
    Pnew.List:=P.List
   else Pnew.List:=nil;
   break;
  end;
  //    mm.Lines.Add(tmps+P.chargename);
  if P.List<>nil then
   Pnew:=recurseListnew(P.List,tmps+'--',charge_id);
  if Pnew<>nil then
  begin
   Result:=Pnew;
   exit;
  end
 end;
 Result:=Pnew;
end;
//----------------------------------------------------------------------------

function GetCategory (emplant_id:integer) : integer;//Функция получения категории 1:Основной, 2:Совместитель
var
//        i:integer;
        qrnew: TIBQuery;
        newsql:string;
        Category:integer;
begin

  Result:=-1;
  if WorkDB=nil then Exit;

  qrnew:=TIBQuery.Create(nil);

 Category:=-1;
  //Получение оклада
  qrnew:=TIBQuery.Create(nil);
  try
   qrnew.Database:=WorkDB;//qr.Database;
   qrnew.Transaction:=TrRead;//qr.Transaction;
   newsql:= 'select * from empplant where empplant_id='+ IntToStr(emplant_id);
   qrnew.SQL.Add(newsql);
//   qrnew.DataSource:=qr.DataSource;
//   qrnew.Params.AssignValues(qr.Params);
   qrnew.Active:=true;
        if not qrnew.IsEmpty then begin
        //   if qrnew.RecordCount=1 then begin
             Category:=qrnew.FieldByName('Category_id').AsInteger;
        end;
   finally
   qrnew.free;
   Screen.Cursor:=crDefault;
   end;
     case Category of 
     1: begin Result:=1; end;//Основные (оклад) 
     3:Result:=2; //Совместители (оклад)
     5:Result:=3; //Основные (тариф)
     7:Result:=4; //Совместители (тариф)         
     end;
  
end;
function GetQuantityOfDependent (emplant_id:integer) : integer;
var
//        i:integer;
        qrnew: TIBQuery;
        newsql:string;
        QuantityOfDependent:Integer;
        Father:Integer;
begin

 Result:=-1;
 try
  if WorkDB=nil then Exit;

  //qrnew:=TIBQuery.Create(nil);

 QuantityOfDependent:=0;
  //Получение оклада
  qrnew:=TIBQuery.Create(nil);
  try
   qrnew.Database:=WorkDB;//qr.Database;
   qrnew.Transaction:=TrRead;//qr.Transaction;
   newsql:= '   select COUNT(ch.EMP_ID) from CHILDREN ch'+
        ' join EMp em on em.EMP_ID =ch.EMP_ID'+
        ' join EMPPLANT ep on ep.EMP_ID=em.EMP_ID'+
        ' where ep.EMPPLANT_ID in (select ee.EMPPLANT_ID from empplant ee where EMpplant_ID ='+IntToStr(emplant_id)+
        ' and ch.TYPERELATION_ID = 6 or ch.TYPERELATION_ID = 7)';
   qrnew.SQL.Add(newsql);
//   qrnew.DataSource:=qr.DataSource;
//   qrnew.Params.AssignValues(qr.Params);
   qrnew.Active:=true;
        if not qrnew.IsEmpty then begin
        //   if qrnew.RecordCount=1 then begin
             QuantityOfDependent:=qrnew.FieldByName('count').AsInteger;
        end;
//Определяю есть ли муж/жена
Father:=0;
   qrnew.Database:=WorkDB;//qr.Database;
   qrnew.Transaction:=TrRead;//qr.Transaction;
   qrnew.SQL.Clear;
   newsql:= '   select COUNT(ch.EMP_ID) from CHILDREN ch'+
        ' join EMp em on em.EMP_ID =ch.EMP_ID'+
        ' join EMPPLANT ep on ep.EMP_ID=em.EMP_ID'+
        ' where ep.EMPPLANT_ID in (select ee.EMPPLANT_ID from empplant ee where EMpplant_ID ='+IntToStr(emplant_id)+
        ' and ch.TYPERELATION_ID = 0 or ch.TYPERELATION_ID = 1)';
   qrnew.SQL.Add(newsql);
//   qrnew.DataSource:=qr.DataSource;
//   qrnew.Params.AssignValues(qr.Params);
   qrnew.Active:=true;
        if not qrnew.IsEmpty then begin
        //   if qrnew.RecordCount=1 then begin
             Father:=qrnew.FieldByName('count').AsInteger;
        end;

   finally
     qrnew.free;
     Screen.Cursor:=crDefault;
   end;
    if  (Father=0) then QuantityOfDependent:=QuantityOfDependent*2;

     Result:=QuantityOfDependent; //Совместители (тариф)
  except
  end;   
end;

//Возвращает ид тукущего календаря
function GetAnyCalendarID(InDate:Tdate):Integer;
var quCalendar:TIBQuery;
    trTemp:TIBTransaction;
begin
  Result:=-1;
  if WorkDB=nil then Exit;
 try
  quCalendar:=TIBQuery.Create(nil);
  quCalendar.Database:=Workdb;
  trTemp:=TIBTransaction.Create(nil);
  trTemp.DefaultDatabase:=Workdb;
  trTemp.Params.Add('read_committed');
  trTemp.Params.Add('rec_version');
  trTemp.Params.Add('nowait');
  trTemp.DefaultAction:=TARollback;
  quCalendar.Transaction:=trTemp;
  try
   quCalendar.SQL.Text:='select calendar_id from calendar order by startdate';
   try
    quCalendar.Open;
    quCalendar.last;
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
  function GetCalendar_ID(emplant_id:integer;InDate:Tdate):Integer;
var
//        i:integer;
        qrnew: TIBQuery;
        newsql:string;
        Calendar_ID:Integer;
begin

  Result:=-1;
  if WorkDB=nil then Exit;

//  qrnew:=TIBQuery.Create(nil);

 Calendar_ID:=0;
  //Получение оклада
  qrnew:=TIBQuery.Create(nil);
  try
   qrnew.Database:=WorkDB;//qr.Database;
   qrnew.Transaction:=TrRead;//qr.Transaction;
   newsql:= 'select ems.schedule_id as schedule_id from empplantschedule ems '+
                ' join schedule sh on ems.schedule_id = sh.schedule_id '+
                ' join calendar cal on cal.calendar_id=sh.calendar_id '+
                ' where cal.startdate <= '''+DateToStr(InDate) + '''' +
                ' and ems.empplant_id='+IntToStr(emplant_id)+
                ' order by cal.startdate desc' ;
    qrnew.SQL.Add(newsql);
//   qrnew.DataSource:=qr.DataSource;
//   qrnew.Params.AssignValues(qr.Params);
   qrnew.Active:=true;
        if not qrnew.IsEmpty then begin
        //   if qrnew.RecordCount=1 then begin
             Calendar_ID:=qrnew.FieldByName('schedule_id').AsInteger;
        end;
   finally
   qrnew.free;
   Screen.Cursor:=crDefault;
   end;
     Result:=Calendar_ID; //Совместители (тариф)
     end;



//function GetIDCurCalcPeriod (qr: TIBQuery ):Integer;//Функция получения ID текущего периода
function GetIDPrevCalcPeriod :Integer;//Функция получения ID текущего периода
var
        IDCurCalcPeriod:Integer;
        qrnew: TIBQuery;
        newsql:string;
//        StazhOM:double;
begin
  Result:=GetCurCalcPeriodID(WorkDB);
  exit;
 end;
//*******************************************************************************
//   FillGridColumns(IBQ,dbg2);
procedure FillGridColumns (ds:TDataSet; dbg: TDBGrid);//:TColumn;//Функция заполнения Grid'a
var
    locds: TDataSet;
    locCol:TColumn;
    cl: TColumn;
    qrnew: TIBQuery;
    newsql:string;
    i:integer;
    TC:TCollection;
begin
// Result:=-1;
  if WorkDB=nil then Exit;
  //Список колонок
  qrnew:=TIBQuery.Create(nil);
  try
   qrnew.Database:= WorkDB;//qr.Database;
   qrnew.Transaction:=TrRead;//qr.Transaction;
   newsql:= 'select R.RDB$RELATION_NAME, R.RDB$FIELD_POSITION, R.RDB$FIELD_NAME,t.rdb$type_name , r.rdb$description ,'+
            ' F.RDB$FIELD_LENGTH, F.RDB$FIELD_SCALE, F.RDB$FIELD_SUB_TYPE'+
            ' from RDB$FIELDS F, RDB$RELATION_FIELDS R , rdb$types T'+
            ' where F.RDB$FIELD_NAME = R.RDB$FIELD_SOURCE and R.RDB$SYSTEM_FLAG = 0 and'+
            ' T.rdb$field_name = ''RDB$FIELD_TYPE'' and t.rdb$type = f.rdb$field_type'+
            ' order by R.RDB$RELATION_NAME, R.RDB$FIELD_POSITION';
   qrnew.SQL.Add(newsql);
   qrnew.Active:=true;
        if not qrnew.IsEmpty then begin
              for i:=0 to ds.FieldCount-1 do
                begin
                  qrnew.First;
                  if qrnew.Locate('RDB$FIELD_NAME',Trim(ds.Fields[i].FieldName),[loPartialKey]) then
                    if (Trim(qrnew.FieldByName('rdb$description').AsString)<>'') then
                      begin
                          cl:=dbg.Columns.Add;
                          cl.FieldName:=Trim(qrnew.FieldByName('RDB$FIELD_NAME').AsString);
                          cl.Title.Caption:=Trim(qrnew.FieldByName('rdb$description').AsString);
                          case qrnew.FieldByName('RDB$FIELD_LENGTH').AsInteger of
                            1..50: cl.Width:=50;
                            250..5000 :cl.Width:=250;
                          else
                            cl.Width:=qrnew.FieldByName('RDB$FIELD_LENGTH').AsInteger;
                          end;
                      end;
                end;

        end;
   except
   end;

 end;

end.
