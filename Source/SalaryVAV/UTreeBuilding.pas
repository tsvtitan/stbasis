unit UTreeBuilding;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URptMain, OleCtnrs, StdCtrls, Buttons, ExtCtrls, Excel97, ComCtrls, IBQuery,
  IBDatabase, Db, IBCustomDataSet, Grids, DBGrids, Spin, DateUtil, UMainUnited;


//  procedure CalculateInit(DB:TIBDatabase);
//  procedure CalculateDone;



type
  TfmBuildingTree = class(TfmRptMain)
    qr: TIBQuery;
    IBTransaction: TIBTransaction;
    IBQ1: TIBQuery;
    IBQ2: TIBQuery;
    ibtranCharge: TIBTransaction;
    qrCharge: TIBQuery;
    ibtranChargeConst: TIBTransaction;
    qrChargeConst: TIBQuery;
    qrconst: TIBQuery;
    ibtUpdate: TIBTransaction;
    UpdateQr: TIBQuery;
    qrChargeSumm: TIBQuery;
    qrYearSumm: TIBQuery;
    qrCount: TIBQuery;
    lbPeriod: TLabel;
    edPeriod: TEdit;
    bibPeriod: TBitBtn;
    bibCurPeriod: TBitBtn;
    grbCase: TGroupBox;
    rbAll: TRadioButton;
    rbEmp: TRadioButton;
    rbDepart: TRadioButton;
    edEmp: TEdit;
    bibEmp: TBitBtn;
    eddepart: TEdit;
    bibDepart: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bibBreakClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure bibGenClick(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure bibCurPeriodClick(Sender: TObject);
    procedure bibPeriodClick(Sender: TObject);
    procedure bibEmpClick(Sender: TObject);
    procedure bibDepartClick(Sender: TObject);
    procedure rbAllClick(Sender: TObject);
    procedure bibClearClick(Sender: TObject);
  private
    FhInterface: THandle;
    NewLeft,NewTop,NewWidth,NewHeight: Integer;
    PBHandle: LongWord;
    Listmain,ListTree: TList;
    procedure GetPrivelege (empplant_id:integer);////Функция получения суммы льготы на подоходный налог
    procedure ClearList(List: TList);
    procedure AddToList( ListParent: TList;
                       chargetree_id: Integer;
                       charge_id: Integer;
                       parent_id: Integer;
                       chargename:String;
                       algorithm_id:Integer;
                       typefactorworktime:Integer;
                       typebaseamount:Integer;
                       typepercent:Integer;
                       typemultiply:Integer;
                       bs_amountmonthsback:Integer;
                       bs_totalamountmonths:Integer;
                       bs_divideamountperiod:Integer;
                       bs_multiplyfactoraverage:Currency;
                       bs_salary:Currency;
                       bs_tariffrate:Currency;
                       bs_averagemonthsbonus:Currency;
                       bs_annualbonuses:Currency;
                       bs_minsalary:Currency;
                       krv_typeratetime:Integer;
                       krv_amountmonthsback:Integer;
                       krv_totalamountmonths:Integer;
                       u_besiderowtable:Integer;
                       typepay_id:Integer;
                       name:string;
                       tmps: string;
                       fallsintototal:Integer;//Входит в итого?
                       fixedamount:Currency;//Фикс. сумма
                       fixedrateathours:Currency;//Фикс. норма в часах
                       fixedpercent:Currency;//Фикс. процент
                       List: TList);
   procedure AddFromQuery(List: TList);
   procedure GenerateTree(List,ListParent: TList; ParentId: String;tmps: string);
   procedure recurseList(List: TList; tmps: string;charge_id:integer);
   procedure OnRptTerminate(Sender: TObject);
   function CheckFieldsFill: Boolean;
   procedure SetRadioCase(Index: Integer);

   //   procedure GetAllg(Sender: TObject);
    function GetRadioCase: Integer;
  public
    sex_id: Integer;
    familystate_id: Integer;
    nation_id: Integer;
    borntown_id: Integer;
    oklad : double; //Здесь хранится оклад работника
    mrot: double;
    category: Integer;
    id: Integer;
    ChargeFlag: Integer;
    CalcPeriod_id: Integer;
    correctperiod_id: Integer;
    empplant_id: Integer;
    Charge_id: Integer;
    percent:Double;
    hours:Double;
    days:Double;
    summa:Currency;
    basesumm:Currency;
    itemcreatedate:Tdate;
    creatoremp_id : Integer;
    itemmodifydate:Tdate;
    modificatoremp_id: Integer;
    algorithm_id: Integer;
    typebaseamount: Integer;
           typepercent: Integer;
           typemultiply: Integer;
           typefactorworktime: Integer;
    statuscalcperiod: Integer;
    schedule_id: Integer;

   NormaDay:Double;
   NormaEvening:Double;
   NormaNight:Double;
   Norma:Double;
   Fact:Double;
   FactDay:Double;
   FactEvening:Double;
   FactNight:Double;
setka:Integer;
shift_id:Integer;
net_id:Integer;
k_oplaty:Double;
   Privilegent:Double;
   Dependent:Double;
summ:Double;
 calcstartdate:TdateTime; //Число начала рассчета
 calcenddate:TdateTime; //Число конца рассчета
percentnalog:Double;
MaxSummForPrivelege:Double;
YearSumm:Double; //Валовый доход за год
QuantityOfDependent:Integer;//Количество иждевенцев
OldYearSumm:Double; //Валовый доход c предыдущих мест работы
newid:String;
SummPrivilegent:Double; //Общая сумма скидки
countrec:Integer;// Количество рассчитанных записей
countcalc:Integer;//Количество всего записей
FaktWorkTime:Double;
NormWorkTime:Double;
qq:Integer;//
NeedCalc:Boolean;
Privelege:Currency;

    startdate,enddate: TDateTime;
    CurCalcPeriod_id: Integer;
    emp_id: Integer;
    depart_id: Integer;

    procedure LoadFromIni;override;
    procedure SaveToIni;override;
    procedure GenerateReport;override;
    function GetMainSqlString: string;
    procedure SetInterfaceHandle(Value: THandle);
//    procedure ReturnModalParamsFromDataSetAndGrid(DataSet: TDataSet; Grd: TNewDbGrid; Param: PParamRBookInterface);
    procedure InitMdiChildParams(hInterface: THandle; Param: PParamReportInterface);override;
    procedure InitModalParams(hInterface: THandle; Param: PParamReportInterface); dynamic; // ????
    procedure ReturnModalParams(Param: PParamReportInterface); dynamic;

    //    procedure SetParamsFromOptions;
  end;

var
  fmBuildingTree: TfmBuildingTree;

function GetOnSalary(empplant_id:integer;calcperiod_id:Integer;charge_id:integer):Currency;    //Возвращает начисления входящие в данное начисление

implementation

uses USalaryVAVCode,URptThread,comobj,ActiveX,
     USalaryVAVData, StCalendarUtil,USalaryVAVOptions, StSalaryKit;

type
  TCalcThread=class(TRptExcelThread)
  private
    PBHandle: LongWord;
  public
    fmParent: TfmBuildingTree;
    procedure Execute;override;
    destructor Destroy;override;

  end;

var
  Rpt: TCalcThread;
  WorkDB:TIBDatabase=nil;
  TrRead,TrWrite:TIBTransaction;

{$R *.DFM}



procedure TfmBuildingTree.FormCreate(Sender: TObject);
var
  curdate: TDate;
    P: PInfoConnectUser;
begin
  CalculateInit(IBDB);
  ibtranCharge.AddDatabase(IBDB);
  IBDB.AddTransaction(ibtranCharge);
  qrCharge.Database:=IBDB;
  Listmain:=TList.Create;
  ListTree:=TList.Create;

  qr.Database:=IBDB;
  IBTransaction.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTransaction);
  qr.Active:=true;
 inherited;
 try
  Caption:=NameBuildingTree;

  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  curdate:=_GetDateTimeFromServer;
  CurCalcPeriod_id:=GetCurCalcPeriodID(IBDB);
  bibCurPeriodClick(nil);

  edPeriod.MaxLength:=DomainNameLength;
  edEmp.MaxLength:=DomainNameLength+DomainSmallNameLength+DomainSmallNameLength+2;
  eddepart.MaxLength:=DomainNameLength;

 WorkDB:=IBDB;
 if WorkDB<>nil then
 begin

  TrRead:=TIBTransaction.Create(nil);
  TrRead.DefaultDatabase:=IBDB;
  TrRead.Params.Add('read_committed');
  TrRead.Params.Add('rec_version');
  TrRead.Params.Add('nowait');
  TrRead.DefaultAction:=TARollback;

  TrWrite:=TIBTransaction.Create(nil);
  TrWrite.DefaultDatabase:=IBDB;
  TrWrite.Params.Add('read_committed');
  TrWrite.Params.Add('rec_version');
  TrWrite.Params.Add('nowait');
  TrWrite.DefaultAction:=TARollback;
  end;
  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;



   getMem(P,sizeof(TInfoConnectUser));
  try
   ZeroMemory(P,sizeof(TInfoConnectUser));
   _GetInfoConnectUser(P);
   creatoremp_id:=P.Emp_id;
   modificatoremp_id:=P.Emp_id;
  finally
    FreeMem(P,sizeof(TInfoConnectUser));
   end;

end;

procedure TfmBuildingTree.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(Rpt);
  if FormState=[fsCreatedMDIChild] then
   fmBuildingTree:=nil;
end;

procedure TfmBuildingTree.LoadFromIni;
var
  TPRBI: TParamRBookInterface;
  TPRBId: TParamRBookInterface;
begin
 inherited;
  try
//считываю сотрудника
    emp_id:=ReadParam(ClassName,'emp_id',emp_id);
    if emp_id<>0 then
          begin
           FillChar(TPRBI,SizeOf(TPRBI),0);
           TPRBI.Visual.TypeView:=tviOnlyData;
           TPRBI.Locate.KeyFields:='emp_id';
           TPRBI.Locate.KeyValues:=emp_id;
           TPRBI.Locate.Options:=[loCaseInsensitive];
           if _ViewInterfaceFromName(NameEmp,@TPRBI) then begin
              emp_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'emp_id');
              edEmp.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'fname')
                          +' '+GetFirstValueFromParamRBookInterface(@TPRBI,'name')
                          +' '+GetFirstValueFromParamRBookInterface(@TPRBI,'sname');
           end;
          end;
//считываю отдел
    depart_id:=ReadParam(ClassName,'depart_id',depart_id);
    if depart_id<>0 then
          begin
           FillChar(TPRBId,SizeOf(TPRBId),0);
           TPRBId.Visual.TypeView:=tvibvModal;
           TPRBId.Locate.KeyFields:='depart_id';
           TPRBId.Locate.KeyValues:=depart_id;
           TPRBId.Locate.Options:=[loCaseInsensitive];
           if _ViewInterfaceFromName(NameDepart,@TPRBId) then begin
              depart_id:=GetFirstValueFromParamRBookInterface(@TPRBId,'depart_id');
              eddepart.Text:=GetFirstValueFromParamRBookInterface(@TPRBId,'name');
           end;
          end;

    //считываю как рассчитывать
    SetRadioCase(ReadParam(ClassName,'case',GetRadioCase));
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmBuildingTree.SaveToIni;
begin
 inherited;
  try
    WriteParam(ClassName,'emp_id',emp_id);
    WriteParam(ClassName,'depart_id',depart_id);
    WriteParam(ClassName,'case',GetRadioCase);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmBuildingTree.OnRptTerminate(Sender: TObject);
begin
  FreeAndNil(Rpt);
  ShowInfo(Application.Handle,'Расчет завершен успешно.');
  bibBreakClick(nil);
end;

procedure TfmBuildingTree.GenerateReport;
begin
  if Rpt<>nil then exit;
  Rpt:=TCalcThread.Create;
  Rpt.fmParent:=Self;
  Rpt.OnTerminate:=OnRptTerminate;
  Rpt.Resume;
end;

procedure TfmBuildingTree.bibBreakClick(Sender: TObject);
begin
  if Rpt<>nil then
    Rpt.Terminate;
  inherited;
end;


{ TRptExcelThreadTest }


procedure TfmBuildingTree.ClearList(List: TList);
var
 i: Integer;
 P: PInfoChargeTree;
begin
 for i:=0 to ListMain.Count-1 do begin
  P:=ListMain.Items[i];
  if P.List<>nil then
    ClearList(List);
  dispose(P);
 end;
 List.Clear;
end;

procedure TfmBuildingTree.AddFromQuery(List: TList);
begin
  qr.First;
  while not qr.Eof do begin
    AddToList(ListMain,
               qr.FieldBYName('chargetree_id').AsInteger,
               qr.FieldBYName('charge_id').AsInteger,
               qr.FieldBYName('parent_id').AsInteger,
               qr.FieldBYName('chargename').AsString,
               qr.FieldBYName('algorithm_id').AsInteger,
               qr.FieldBYName('typefactorworktime').AsInteger,
               qr.FieldBYName('typebaseamount').AsInteger,
               qr.FieldBYName('typepercent').AsInteger,
               qr.FieldBYName('typemultiply').AsInteger,
               qr.FieldBYName('bs_amountmonthsback').AsInteger,
               qr.FieldBYName('bs_totalamountmonths').AsInteger,
               qr.FieldBYName('bs_divideamountperiod').AsInteger,
               qr.FieldBYName('bs_multiplyfactoraverage').AsCurrency,
               qr.FieldBYName('bs_salary').AsCurrency,
               qr.FieldBYName('bs_tariffrate').AsCurrency,
               qr.FieldBYName('bs_averagemonthsbonus').AsCurrency,
               qr.FieldBYName('bs_annualbonuses').AsCurrency,
               qr.FieldBYName('bs_minsalary').AsCurrency,
               qr.FieldBYName('krv_typeratetime').AsInteger,
               qr.FieldBYName('krv_amountmonthsback').AsInteger,
               qr.FieldBYName('krv_totalamountmonths').AsInteger,
               qr.FieldBYName('u_besiderowtable').AsInteger,
               qr.FieldBYName('typepay_id').AsInteger,
               qr.FieldBYName('name').AsString,
               qr.FieldBYName('name').AsString,
               qr.FieldBYName('fallsintototal').AsInteger,//Входит в итого?
               qr.FieldBYName('fixedamount').AsCurrency,//Фикс. сумма
               qr.FieldBYName('fixedrateathours').AsCurrency,//Фикс. норма в часах
               qr.FieldBYName('fixedpercent').AsCurrency,//Фикс. процент
               nil);
    qr.Next;
  end;
end;

procedure TfmBuildingTree.GenerateTree(List,ListParent: TList; ParentId: String; tmps: string);
var
 P: PInfoChargeTree;
 lst: TList;
 i: Integer;
 s: string;
begin
 s:=tmps;
 for i:=0 to List.Count-1 do begin
   P:=List.Items[i];
   if inttostr(P.parent_id)=ParentId then begin
     lst:=TList.Create;
     try
       AddToList(ListParent,
                       P.chargetree_id,
                       P.charge_id,
                       P.parent_id,
                       P.chargename,
                       P.algorithm_id,
                       P.typefactorworktime,
                       P.typebaseamount,
                       P.typepercent,
                       P.typemultiply,
                       P.bs_amountmonthsback,
                       P.bs_totalamountmonths,
                       P.bs_divideamountperiod,
                       P.bs_multiplyfactoraverage,
                       P.bs_salary,
                       P.bs_tariffrate,
                       P.bs_averagemonthsbonus,
                       P.bs_annualbonuses,
                       P.bs_minsalary,
                       P.krv_typeratetime,
                       P.krv_amountmonthsback,
                       P.krv_totalamountmonths,
                       P.u_besiderowtable,
                       P.typepay_id,
                       P.name,
                       P.tmps,
                       P.fallsintototal,
                       P.fixedamount,
                       P.fixedrateathours,
                       P.fixedpercent,
                       Lst);
       GenerateTree(List,Lst,inttostr(p.chargetree_id),s+'--');
     finally
//       lst.free;
     end;
   end;
 end;
end;
procedure TfmBuildingTree.AddToList(ListParent: TList;
                       chargetree_id:Integer;
                       charge_id: Integer;
                       parent_id: Integer;
                       chargename:String;
                       algorithm_id:Integer;
                       typefactorworktime:Integer;
                       typebaseamount:Integer;
                       typepercent:Integer;
                       typemultiply:Integer;
                       bs_amountmonthsback:Integer;
                       bs_totalamountmonths:Integer;
                       bs_divideamountperiod:Integer;
                       bs_multiplyfactoraverage:Currency;
                       bs_salary:Currency;
                       bs_tariffrate:Currency;
                       bs_averagemonthsbonus:Currency;
                       bs_annualbonuses:Currency;
                       bs_minsalary:Currency;
                       krv_typeratetime:Integer;
                       krv_amountmonthsback:Integer;
                       krv_totalamountmonths:Integer;
                       u_besiderowtable:Integer;
                       typepay_id:Integer;
                       name: string;
                       tmps: string;
                       fallsintototal:Integer;//Входит в итого?
                       fixedamount:Currency;//Фикс. сумма
                       fixedrateathours:Currency;//Фикс. норма в часах
                       fixedpercent:Currency;//Фикс. процент
                       List: TList);
var
 P: PInfoChargeTree;
begin
 new(P);
 P.chargetree_id:=chargetree_id;
 P.charge_id:=charge_id;
 P.parent_id:=parent_id;
 P.chargename:=chargename;
 P.algorithm_id:=algorithm_id;
 P.typefactorworktime:=typefactorworktime;
 P.typebaseamount:=typebaseamount;
 P.typepercent:=typepercent;
 P.typemultiply:=typemultiply;
 P.bs_amountmonthsback:=bs_amountmonthsback;
 P.bs_totalamountmonths:=bs_totalamountmonths;
 P.bs_divideamountperiod:=bs_divideamountperiod;
 P.bs_multiplyfactoraverage:=bs_multiplyfactoraverage;
 P.bs_salary:=bs_salary;
 P.bs_tariffrate:=bs_tariffrate;
 P.bs_averagemonthsbonus:=bs_averagemonthsbonus;
 P.bs_annualbonuses:=bs_annualbonuses;
 P.bs_minsalary:=bs_minsalary;
 P.krv_typeratetime:=krv_typeratetime;
 P.krv_amountmonthsback:=krv_amountmonthsback;
 P.krv_totalamountmonths:=krv_totalamountmonths;
 P.u_besiderowtable:=u_besiderowtable;
 P.typepay_id:=typepay_id;
 P.name:=name;
 P.tmps:=tmps;
 P.fallsintototal:=fallsintototal;
 P.fixedamount:= fixedamount;
 P.fixedrateathours:= fixedrateathours;
 P.fixedpercent:= fixedpercent;




 P.ListParent:=ListParent;


 if List<>nil then
  P.List:=List
 else P.List:=nil;
 ListParent.Add(P);
end;

procedure TfmBuildingTree.recurseList(List: TList; tmps: string;charge_id:integer);
var
  i: Integer;
  P: PInfoChargeTree;
  Pnew: PInfoChargeTree;  
begin
  Pnew:=0;
  for i:=0 to List.Count-1 do begin
    P:=List.Items[i];
    if P.List<>nil then
     recurseList(P.List,tmps+'--',charge_id);
     if Pnew<>nil then exit;
  end;
end;
procedure TfmBuildingTree.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin

  ClearList(Listmain);
  Listmain.free;
  ClearList(ListTree);
  ListTree.Free;
    inherited;
  end;

procedure TfmBuildingTree.Button4Click(Sender: TObject);
begin

end;

//***************************************************************************
procedure TfmBuildingTree.Button5Click(Sender: TObject);
var
  s:String;
  TPRBIc: TParamRBookInterface;
  TPRBI: TParamRBookInterface;
  qr: TIBQuery;
  sqls: string;
  id: string;

begin
   calcperiod_id:=GetIDCurCalcPeriod();
//Получаю рассчетный период
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='calcperiod_id';
  TPRBI.Locate.KeyValues:=calcperiod_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameCalcPeriod,@TPRBI) then begin
//   ChangeFlag:=true;
     calcperiod_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'calcperiod_id');
     correctperiod_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'calcperiod_id');
     statuscalcperiod:=GetFirstValueFromParamRBookInterface(@TPRBI,'status');
  end;

//Проверка на открытость рассчетного периода
if (statuscalcperiod <> 2) then
        begin
        ShowMessage('Сначала нужно открыть рассчетный период!');
        exit;
        end;

//Получаю список постоянных начислений
  ibtranChargeConst.AddDatabase(IBDB);
  IBDB.AddTransaction(ibtranChargeConst);
  qrChargeConst.Database:=IBDB;
  qrChargeConst.Active:=false;
  qrChargeConst.sql.Clear;
  s:='select * from constcharge'; //Потом добавить условия
    qrChargeConst.sql.Add(s);
    qrChargeConst.Transaction.Active:=false;
    qrChargeConst.Transaction.Active:=true;
    qrChargeConst.Active:=true;



//Получаю список рабочих мест
  ibtranCharge.AddDatabase(IBDB);
  IBDB.AddTransaction(ibtranCharge);
  qrCharge.Database:=IBDB;
  qrCharge.Active:=false;
  qrCharge.sql.Clear;
  s:='select em.empplant_id as empplant_id, e.name as name,  factpay.pay, em.category_id as category,' +
     ' em.datestart, em.releasedate from empplant em ' +
     ' join factpay fp  on fp.empplant_id=em.empplant_id' +
     ' join emp e on em.emp_id=e.emp_id';
    qrCharge.sql.Add(s);
    qrCharge.Transaction.Active:=false;
    qrCharge.Transaction.Active:=true;
    qrCharge.Active:=true;

    //Переношу постоянные начисления в таблицу зарплата
while not qrChargeConst.Eof do
   begin

//Проверяю границы действия
if ((qrChargeConst.FieldBYName('startdate').AsDateTime <= GetNewCalcPeriod)  and
        ((qrChargeConst.FieldBYName('enddate').AsDateTime >= GetCurCalcPeriodStartDate) or
         (qrChargeConst.FieldBYName('enddate').AsDateTime = 0))) then
    begin
    id:=inttostr(GetGenId(IBDB,tbSalary,1));
    qrconst.Database:=IBDB;
    qrconst.Transaction:=ibtran;
    qrconst.Transaction.Active:=true;
    sqls:='Insert into '+tbsalary ;
    sqls:=sqls+      ' (salary_id,CalcPeriod_id,correctperiod_id,empplant_id,Charge_id,percent,';
    sqls:=sqls+      'basesumm,itemcreatedate,creatoremp_id,itemmodifydate,modifycatoremp_id) values '+' ('+id+',';
//Текущий период
    sqls:=sqls+                                    inttostr(CalcPeriod_id)+',0,';
//Место работы
    sqls:=sqls+GetStrFromCondition(qrChargeConst.FieldBYName('empplant_id').AsString<>'',
                              qrChargeConst.FieldBYName('empplant_id').AsString,
                              'null')+',';

//Вид начисления
    sqls:=sqls+GetStrFromCondition(qrChargeConst.FieldBYName('charge_id').AsString<>'',
                              qrChargeConst.FieldBYName('charge_id').AsString,
                              'null')+',';
//Процент
    sqls:=sqls+GetStrFromCondition(qrChargeConst.FieldBYName('percent').AsString<>'',
                              qrChargeConst.FieldBYName('percent').AsString,
                              'null')+',';
//Сумма
    sqls:=sqls+GetStrFromCondition(qrChargeConst.FieldBYName('summa').AsString<>'',
                              qrChargeConst.FieldBYName('summa').AsString,
                              'null')+',';
//Дата создания
    sqls:=sqls+                ''''+DateToStr(Now)+''',';
//Создатель
    sqls:=sqls+                IntToStr(creatoremp_id)+',';
//          inttostr(emp_id)+','+
//Дата модификации
    sqls:=sqls+                ''''+DateToStr(Now)+''',';
//Модификатор
    sqls:=sqls+                IntToStr(creatoremp_id);
    sqls:=sqls+                ')';
    qrconst.SQL.Clear;
    qrconst.SQL.Add(sqls);
    qrconst.ExecSQL;
    qrconst.Transaction.Commit;
   end;
   qrChargeConst.Next;
  end;
end;



procedure TfmBuildingTree.Button9Click(Sender: TObject);
var
//  Ps: PScheduleParams;
  sqls:String;
  ////////////////////////////////////////
  IDs1,IDs2:TRecordsIDs;
  ////////////////////////////////////////
begin
  CalcPeriod_id:=GetIDCurCalcPeriod();
//  InitCalendarUtil(IBDB);
  //Получить рассчетный период
 calcstartdate:=GetCurCalcPeriodStartDate;
 calcenddate:=IncMonth(calcstartdate,1)-1;


  //Получить МРОТ
  mrot:=GetMROT(now);

mainqr.Active:=false;
mainqr.SQL.Text:='select * from '+tbempplant; //Добавить фильтр которые работают в данном периоде
//Перебираем все места работы для сотрудников
mainqr.Active:=true;
mainqr.First;
while not mainqr.Eof do
   begin
empplant_id:=-1;
   category:=-1;
   empplant_id:=mainqr.FieldBYName('empplant_id').AsInteger;
//если уволен то выход
//*****************************************************************************
//Здесь должна быть последовательность функций рассчета з/п   *****************
//*****************************************************************************

  //Получить оклад или тариф это ++++++++
   category:=GetTypeCategory (mainqr);
//Получаю оклад
   oklad:=GetOklad (mainqr.FieldBYName('empplant_id').AsInteger);

   //Получить текущий календарь и график
 try
  schedule_id:= GetCalendar_ID(empplant_id,calcstartdate) ;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;

  //Получить сетку
  setka :=1;
  case net_id of
  1: ;
  3: ;
  5: ;
  end;

  //Получить смену

{  case net_id of
  1: k_oplaty:=fmOptions.cedShiftDay.value ;
  3: k_oplaty:=fmOptions.cedShiftEvening.value ;
  5: k_oplaty:=fmOptions.cedShiftNight.value ;
  end;}

   //Получаю норму по графику
//GetNormalTime(Schedule_id,Shift_id:Integer;StartDate,EndDate:TDateTime):Double;
  SetLength(IDs1,1);
  IDs1[0]:=1;
  NormaDay:=GetNormalTime(Schedule_id,IDs1,calcstartdate, calcenddate,True,[dtOrdinary,dtFree,dtHoliday]);
  IDs1[0]:=2;
NormaEvening:=GetNormalTime(Schedule_id,IDs1,calcstartdate, calcenddate,True,[dtOrdinary,dtFree,dtHoliday]);
  IDs1[0]:=3;
NormaNight:=GetNormalTime(Schedule_id,IDs1,calcstartdate, calcenddate,True,[dtOrdinary,dtFree,dtHoliday]);

   Norma:=NormaDay+NormaEvening+NormaNight;
   //Получаю факт по табелю по отработанным дням
//GetActualTime(EmpPlant_id,Absence_id,Shift_id:Integer;StartDate,EndDate:TDateTime):Double;
   SetLength(IDs2,1);
   IDs2[0]:=11;
  IDs1[0]:=1;
   FactDay:=GetActualTime(EmpPlant_id,IDs2,IDs1,calcstartdate, calcenddate,True);
  IDs1[0]:=2;
   FactEvening:=GetActualTime(EmpPlant_id,IDs2,IDs1,calcstartdate, calcenddate,True);
  IDs1[0]:=3;
   FactNight:=GetActualTime(EmpPlant_id,IDs2,IDs1,calcstartdate, calcenddate,True);
   Fact:=FactDay+FactEvening+FactNight;


  //Проверить когда принят на работу (в табеле)
  //Проверить уволен-ли? (в табеле)
  //Проверить были среди месяца повышения или понижения?
  //Получить его фактический оклад за месяц
   case category of
   1:  begin
        if (norma<>0) then
        oklad:= (oklad/norma)*(FactDAy+FactEvening*1.5+FactNight*2)
        else
        oklad:= 0
        end;
   2:  oklad:= oklad*(FactDAy+FactEvening*1.5+FactNight*2);
   end;


 qrCharge.Active:=false;
//Подгатавливаю список начислений для конкретного места работы
 qrCharge.SQL.Text:='select sal.*, ch.charge_id  from '+ tbsalary +' sal '+
       ' join ' + tbcharge + ' ch on  sal.charge_id in (select ch.charge_id from charge where ch.flag=0)'+
        ' where empplant_id='+
        mainqr.FieldByName('empplant_id').AsString + ' and calcperiod_id=' +IntToStr(GetIDCurCalcPeriod)+
        ' order by ch.charge_id';
 qrCharge.Active:=true;
 qrCharge.First;
while not qrCharge.Eof do
   begin

  //Получить признаки по которым производятся начисления если такие есть
  //Получить количество иждевенцев
  QuantityOfDependent:=0;
  //Получить норму льготы на налог
   Privilegent:=fmOptions.cedPrivilegent.value ;
   Dependent:=fmOptions.cedDependent.value ;
  //Сумма до которой предоставляется льгота
   MaxSummForPrivelege:=fmOptions.ceMaxSummForPrivelege.Value;
  //Получить совокупный годовой доход
//****************************************************************************
//Предусмотреть в будущем начальные остатки с другого места работы
OldYearSumm:=0;
//****************************************************************************
        qrYearSumm.Database:=IBDB;
        qrYearSumm.Transaction:=TrRead;
        sqls:='select SUM(sal.summa) as summa'+
              ' from ' + tbSalary + ' sal'+
              ' join ' + tbcalcperiod + ' cp on sal.calcperiod_id = cp.calcperiod_id '+
              ' join ' + tbcalcperiod + ' cp1 on  sal.correctperiod_id = cp1.calcperiod_id'+
              ' join ' + tbemp + ' e on  sal.creatoremp_id = e.emp_id'+
              ' join ' + tbemp + ' ee on  sal.modifycatoremp_id = ee.emp_id'+
              ' join ' + tbcharge + ' ch on  sal.charge_id in (select ch.charge_id from charge where ch.flag=0)'+
              ' where sal.empplant_id ='+ inttostr(mainqr.fieldbyName('empplant_id').AsInteger)+' '+
              ' and sal.calcperiod_id in (select cp.calcperiod_id from '+tbCalcperiod+' where cp.startdate like ''%' +GetCurrentYear(calcperiod_id)+'%'')';
   qrYearSumm.sql.clear;
   qrYearSumm.sql.Add(sqls);
   qrYearSumm.Active:=true;

        YearSumm:=OldYearSumm+qrYearSumm.FieldByName('summa').AsFloat;

//Нахожу строку с содержащую льготы
        qrYearSumm.Database:=IBDB;
        qrYearSumm.Transaction:=TrRead;
        sqls:='select pr.* '+
              ' from ' + tbPrivelege + ' pr'+
              ' where pr.empplant_id ='+ inttostr(mainqr.fieldbyName('empplant_id').AsInteger)+' '+
              ' and pr.year_ =  ' +GetCurrentYear(calcperiod_id);
   qrYearSumm.sql.clear;
   qrYearSumm.sql.Add(sqls);
   qrYearSumm.Active:=true;


//        YearSumm:=OldYearSumm+qrYearSumm.FieldByName('summa').AsFloat;

        if not qrYearSumm.IsEmpty then
                begin
                end
              else
//Если записей нет добавляю и отбираю
                begin
   qrYearSumm.Active:=false;
    newid:=inttostr(GetGenId(IBDB,tbPrivelege,1));
        qrYearSumm.Database:=IBDB;
        qrYearSumm.Transaction:=TrWrite;
        qrYearSumm.Transaction.Active:=true;
        sqls:='Insert into '+ tbPrivelege + ' (Privelege_id,empplant_id,year_,itemcreatedate,'+
                'creatoremp_id,itemmodifydate,modifycatoremp_id) values '+
                ' ('+newid+','+ inttostr(mainqr.fieldbyName('empplant_id').AsInteger)+','+
                 GetCurrentYear(calcperiod_id)+','+
//Дата создания
          ''''+DateToStr(Now)+''','+
//Создатель
          IntToStr(creatoremp_id)+','+
//          inttostr(emp_id)+','+
//Дата модификации
          ''''+DateToStr(Now)+''','+
//Модификатор
          IntToStr(creatoremp_id)+
          ')';
   qrYearSumm.sql.clear;
   qrYearSumm.sql.Add(sqls);
   qrYearSumm.ExecSQL;
   qrYearSumm.Transaction.Commit;
//Нахожу строку с содержащую льготы
//        TrRead.Commited;
        qrYearSumm.Database:=IBDB;
        qrYearSumm.Transaction:=TrRead;
        sqls:='select pr.* '+
              ' from ' + tbPrivelege + ' pr'+
              ' where pr.empplant_id ='+ inttostr(mainqr.fieldbyName('empplant_id').AsInteger)+' '+
              ' and pr.year_ =  ' +GetCurrentYear(calcperiod_id);
   qrYearSumm.sql.clear;
   qrYearSumm.sql.Add(sqls);
   qrYearSumm.Active:=true;

                end;

   //Добавляю льготы в таблицу      bookmark
   if (YearSumm<MaxSummForPrivelege) then
   begin
    ibtUpdate.AddDatabase(IBDB);
    UpdateQr.Database:=IBDB;
    UpdateQr.Transaction:=ibtUpdate;
    UpdateQr.Transaction.Active:=true;

    sqls:='Update '+tbPrivelege+' set '+
          ' SP'+IntToStr(GetCurrentMonth(CalcPeriod_ID))+' ='+ FloatToStr(Privilegent)+','+
          ' DP'+IntToStr(GetCurrentMonth(CalcPeriod_ID))+' ='+ FloatToStr(Dependent)+',';
          sqls:=sqls+' itemmodifydate=' + ''''+DateToStr(Now)+''','+
          ' modifycatoremp_id='+ IntToStr(creatoremp_id)+
          ' where Privelege_id='+qrYearSumm.FieldByName('Privelege_id').AsString;

    UpdateQr.SQL.Clear;
    UpdateQr.SQL.Add(sqls);
    UpdateQr.ExecSQL;
    UpdateQr.Transaction.Commit;
   //Нахожу обновленную строку  содержащую льготы
//        TrRead.Commited;
        qrYearSumm.Database:=IBDB;
        qrYearSumm.Transaction:=TrRead;
        sqls:='select pr.* '+
              ' from ' + tbPrivelege + ' pr'+
              ' where pr.empplant_id ='+ inttostr(mainqr.fieldbyName('empplant_id').AsInteger)+' '+
              ' and pr.year_ =  ' +GetCurrentYear(calcperiod_id);
   qrYearSumm.sql.clear;
   qrYearSumm.sql.Add(sqls);
   qrYearSumm.Active:=true;

      SummPrivilegent:=qrYearSumm.fieldbyName('SP'+IntToStr(GetCurrentMonth(CalcPeriod_ID))).AsFloat +
                   qrYearSumm.fieldbyName('DP'+IntToStr(GetCurrentMonth(CalcPeriod_ID))).AsFloat;

   end ;




  //Получить стаж  ++++++
  //Получить процент от стажа
  //Получить процент от нужного в виде начисления
  //Получить округление до
  //Получить номер лицевого счета сотрудника
  //Проверить премии

if (qrCharge.FieldByName('charge_id').AsInteger=1) then
        begin
        percent:=0;
        hours:=fact;
        days:=fact/8;
        summa:=oklad;
        end;
//Районный К        
if (qrCharge.FieldByName('charge_id').AsInteger=9000002) then
        begin
        percent:=30;
        hours:=0;
        days:=0;
        qrChargeSumm.Database:=IBDB;
        qrChargeSumm.Transaction:=ibtUpdate;
        sqls:='select SUM(sal.summa) as summa'+
              ' from ' + tbSalary + ' sal'+
              ' join ' + tbcalcperiod + ' cp on sal.calcperiod_id = cp.calcperiod_id '+
              ' join ' + tbcalcperiod + ' cp1 on  sal.correctperiod_id = cp1.calcperiod_id'+
              ' join ' + tbemp + ' e on  sal.creatoremp_id = e.emp_id'+
              ' join ' + tbemp + ' ee on  sal.modifycatoremp_id = ee.emp_id'+
              ' join ' + tbcharge + ' ch on  sal.charge_id in (select ch.charge_id from charge where ch.flag=0)'+
              ' where sal.empplant_id ='+ inttostr(mainqr.fieldbyName('empplant_id').AsInteger)+' '+
              ' and sal.calcperiod_id = ' +IntToStr(calcperiod_id)+ ' and sal.charge_id<> 9000002 and sal.charge_id<> 9000003';
        //     if ()
   qrChargeSumm.sql.clear;
   qrChargeSumm.sql.Add(sqls);
   qrChargeSumm.Active:=true;
        summa:=qrChargeSumm.FieldByName('summa').AsFloat*percent/100;;
        end;
//Северный К
if (qrCharge.FieldByName('charge_id').AsInteger=9000003) then
        begin
        percent:=30;
        hours:=0;
        days:=0;
        qrChargeSumm.Database:=IBDB;
        qrChargeSumm.Transaction:=ibtUpdate;
        sqls:='select SUM(sal.summa) as summa'+
              ' from ' + tbSalary + ' sal'+
              ' join ' + tbcalcperiod + ' cp on sal.calcperiod_id = cp.calcperiod_id '+
              ' join ' + tbcalcperiod + ' cp1 on  sal.correctperiod_id = cp1.calcperiod_id'+
              ' join ' + tbemp + ' e on  sal.creatoremp_id = e.emp_id'+
              ' join ' + tbemp + ' ee on  sal.modifycatoremp_id = ee.emp_id'+
              ' join ' + tbcharge + ' ch on  sal.charge_id in (select ch.charge_id from charge where ch.flag=0)'+
              ' where sal.empplant_id ='+ inttostr(mainqr.fieldbyName('empplant_id').AsInteger)+' '+
              ' and sal.calcperiod_id = ' +IntToStr(calcperiod_id)+ ' and sal.charge_id<> 9000002 and sal.charge_id<> 9000003';
        //     if ()
   qrChargeSumm.sql.clear;
   qrChargeSumm.sql.Add(sqls);
   qrChargeSumm.Active:=true;
        summa:=qrChargeSumm.FieldByName('summa').AsFloat*percent/100;
        end;

    ibtUpdate.AddDatabase(IBDB);
    UpdateQr.Database:=IBDB;
    UpdateQr.Transaction:=ibtUpdate;
    UpdateQr.Transaction.Active:=true;
    sqls:='Update '+tbSalary+' set ';
          if (percent<>0) then sqls:=sqls+' percent='+ FloatToStr(Percent)+',';
          if (hours<>0) then sqls:=sqls+' hours=' + FloatToStr(hours)+',';
          if (days<>0) then sqls:=sqls+' days=' + FloatToStr(days)+',';
          if (summa<>0) then sqls:=sqls+' summa=' + QuotedStr(ChangeChar(FloatToStr(Summa),',','.'))+',';
          if (BaseSumm<>0) then sqls:=sqls+' basesumm=' + QuotedStr(ChangeChar(FloatToStr(BaseSumm),',','.'))+',';
          sqls:=sqls+' itemmodifydate=' + ''''+DateToStr(Now)+''','+
          ' modifycatoremp_id='+ IntToStr(creatoremp_id)+
          ' where salary_id='+qrCharge.FieldByName('Salary_id').AsString;
    UpdateQr.SQL.Clear;
    UpdateQr.SQL.Add(sqls);
    UpdateQr.ExecSQL;
    UpdateQr.Transaction.Commit;
   qrCharge.Next;
   end;

//Удержания
//------------------------------------------------------------------------------
{Проверить совокупный доход и дать или не дать льготы}

//------------------------------------------------------------------------------



 qrCharge.Active:=false;
//Подгатавливаю список удержаний для конкретного места работы
 qrCharge.SQL.Text:='select sal.*, ch.charge_id  from '+ tbsalary +' sal '+
       ' join ' + tbcharge + ' ch on  sal.charge_id in (select ch.charge_id from charge where ch.flag=1)'+
        ' where empplant_id='+
        mainqr.FieldByName('empplant_id').AsString + ' and calcperiod_id=' +IntToStr(GetIDCurCalcPeriod)+
        ' order by ch.charge_id';
 qrCharge.Active:=true;
 qrCharge.First;
while not qrCharge.Eof do
   begin

  //Получить признаки по которым производятся начисления если такие есть
  //Получить количество иждевенцев
  //Получить норму льготы на налог
   Privilegent:=fmOptions.cedPrivilegent.value ;
   Dependent:=fmOptions.cedDependent.value ;
  //Получить совокупный годовой доход
  //Получить стаж  ++++++
  //Получить процент от стажа
  //Получить процент от нужного в виде начисления
  //Получить округление до
  //Получить номер лицевого счета сотрудника
  //Проверить премии
//Подоходный налог
if (qrCharge.FieldByName('charge_id').AsInteger=100) then
        begin
        percent:=13;
        hours:=0;
        days:=0;
        qrChargeSumm.Database:=IBDB;
        qrChargeSumm.Transaction:=ibtUpdate;
        sqls:='select SUM(sal.summa) as summa'+
              ' from ' + tbSalary + ' sal'+
              ' join ' + tbcalcperiod + ' cp on sal.calcperiod_id = cp.calcperiod_id '+
              ' join ' + tbcalcperiod + ' cp1 on  sal.correctperiod_id = cp1.calcperiod_id'+
              ' join ' + tbemp + ' e on  sal.creatoremp_id = e.emp_id'+
              ' join ' + tbemp + ' ee on  sal.modifycatoremp_id = ee.emp_id'+
              ' join ' + tbcharge + ' ch on  sal.charge_id in (select ch.charge_id from charge where ch.flag=0)'+
              ' where sal.empplant_id ='+ inttostr(mainqr.fieldbyName('empplant_id').AsInteger)+' '+
              ' and sal.calcperiod_id = ' +IntToStr(calcperiod_id)+ ' and sal.charge_id<> 100';
        //     if ()
   qrChargeSumm.sql.clear;
   qrChargeSumm.sql.Add(sqls);
   qrChargeSumm.Active:=true;
        basesumm:=qrChargeSumm.FieldByName('summa').AsFloat-(SummPrivilegent);
        summa:= Round(basesumm*percent/100);
        if (summa<0) then summa:=0; 
        end;

    ibtUpdate.AddDatabase(IBDB);
    UpdateQr.Database:=IBDB;
    UpdateQr.Transaction:=ibtUpdate;
    UpdateQr.Transaction.Active:=true;
    sqls:='Update '+tbSalary+' set ';
          if (percent<>0) then sqls:=sqls+' percent='+ QuotedStr(ChangeChar(FloatToStr(Percent),',','.'))+',';
          if (hours<>0) then sqls:=sqls+' hours=' + QuotedStr(ChangeChar(FloatToStr(hours),',','.'))+',';
          if (days<>0) then sqls:=sqls+' days=' + QuotedStr(ChangeChar(FloatToStr(days),',','.'))+',';
          if (summa<>0) then sqls:=sqls+' summa=' + QuotedStr(ChangeChar(FloatToStr(Summa),',','.'))+',';
          if (basesumm<>0) then sqls:=sqls+' basesumm=' + QuotedStr(ChangeChar(FloatToStr(baseSumm),',','.'))+',';     
          sqls:=sqls+' itemmodifydate=' + ''''+DateToStr(Now)+''','+
          ' modifycatoremp_id='+ IntToStr(creatoremp_id)+
          ' where salary_id='+qrCharge.FieldByName('Salary_id').AsString;
    UpdateQr.SQL.Clear;
    UpdateQr.SQL.Add(sqls);
    UpdateQr.ExecSQL;
    UpdateQr.Transaction.Commit;
   qrCharge.Next;
   end;
   mainqr.Next;
   end;
   DoneCalendarUtil;
end;
//-----------------------------------------------------------------------------
procedure TfmBuildingTree.bibGenClick(Sender: TObject);
begin
   if CheckFieldsFill then
   inherited;
end;
//-----------------------------------------------------------------------------
procedure TfmBuildingTree.Button6Click(Sender: TObject);
begin
end;

//----------------------------------------------------------------------------
procedure TfmBuildingTree.GetPrivelege (empplant_id:integer);
var
//  Ps: PScheduleParams;
  sqls:String;
begin

  //Получить количество иждевенцев
  QuantityOfDependent:=0;
  //Получить норму льготы на налог
   Privilegent:=fmOptions.cedPrivilegent.value ;
   Dependent:=fmOptions.cedDependent.value ;
  //Сумма до которой предоставляется льгота
   MaxSummForPrivelege:=fmOptions.ceMaxSummForPrivelege.Value;
  //Получить совокупный годовой доход
//****************************************************************************
//Предусмотреть в будущем начальные остатки с другого места работы
OldYearSumm:=0;
//****************************************************************************
        qrYearSumm.Database:=IBDB;
        qrYearSumm.Transaction:=TrRead;
        sqls:='select SUM(sal.summa) as summa'+
              ' from ' + tbSalary + ' sal'+
              ' join ' + tbcalcperiod + ' cp on sal.calcperiod_id = cp.calcperiod_id '+
              ' join ' + tbcalcperiod + ' cp1 on  sal.correctperiod_id = cp1.calcperiod_id'+
              ' join ' + tbemp + ' e on  sal.creatoremp_id = e.emp_id'+
              ' join ' + tbemp + ' ee on  sal.modifycatoremp_id = ee.emp_id'+
              ' join ' + tbcharge + ' ch on  sal.charge_id in (select ch.charge_id from charge where ch.flag=0)'+
              ' where sal.empplant_id ='+ inttostr(mainqr.fieldbyName('empplant_id').AsInteger)+' '+
              ' and sal.calcperiod_id in (select cp.calcperiod_id from '+tbCalcperiod+' where cp.startdate like ''%' +GetCurrentYear(calcperiod_id)+'%'')';
   qrYearSumm.sql.clear;
   qrYearSumm.sql.Add(sqls);
   qrYearSumm.Active:=true;

        YearSumm:=OldYearSumm+qrYearSumm.FieldByName('summa').AsFloat;

//Нахожу строку с содержащую льготы
        qrYearSumm.Database:=IBDB;
        qrYearSumm.Transaction:=TrRead;
        sqls:='select pr.* '+
              ' from ' + tbPrivelege + ' pr'+
              ' where pr.empplant_id ='+ inttostr(mainqr.fieldbyName('empplant_id').AsInteger)+' '+
              ' and pr.year_ =  ' +GetCurrentYear(calcperiod_id);
   qrYearSumm.sql.clear;
   qrYearSumm.sql.Add(sqls);
   qrYearSumm.Active:=true;


//        YearSumm:=OldYearSumm+qrYearSumm.FieldByName('summa').AsFloat;

        if not qrYearSumm.IsEmpty then
                begin
                end
              else
//Если записей нет добавляю и отбираю
                begin
   qrYearSumm.Active:=false;
    newid:=inttostr(GetGenId(IBDB,tbPrivelege,1));
        qrYearSumm.Database:=IBDB;
        qrYearSumm.Transaction:=TrWrite;
        qrYearSumm.Transaction.Active:=true;
        sqls:='Insert into '+ tbPrivelege + ' (Privelege_id,empplant_id,year_,itemcreatedate,'+
                'creatoremp_id,itemmodifydate,modifycatoremp_id) values '+
                ' ('+newid+','+ inttostr(mainqr.fieldbyName('empplant_id').AsInteger)+','+
                 GetCurrentYear(calcperiod_id)+','+
//Дата создания
          ''''+DateToStr(Now)+''','+
//Создатель
          IntToStr(creatoremp_id)+','+
//          inttostr(emp_id)+','+
//Дата модификации
          ''''+DateToStr(Now)+''','+
//Модификатор
          IntToStr(creatoremp_id)+
          ')';
   qrYearSumm.sql.clear;
   qrYearSumm.sql.Add(sqls);
   qrYearSumm.ExecSQL;
   qrYearSumm.Transaction.Commit;
//Нахожу строку с содержащую льготы
//        TrRead.Commited;
        qrYearSumm.Database:=IBDB;
        qrYearSumm.Transaction:=TrRead;
        sqls:='select pr.* '+
              ' from ' + tbPrivelege + ' pr'+
              ' where pr.empplant_id ='+ inttostr(mainqr.fieldbyName('empplant_id').AsInteger)+' '+
              ' and pr.year_ =  ' +GetCurrentYear(calcperiod_id);
   qrYearSumm.sql.clear;
   qrYearSumm.sql.Add(sqls);
   qrYearSumm.Active:=true;

                end;

   If ((GetCategory(mainqr.fieldbyName('empplant_id').AsInteger)=1)
     or (GetCategory(mainqr.fieldbyName('empplant_id').AsInteger)=3)) then
   //Добавляю льготы в таблицу     
   if (YearSumm<MaxSummForPrivelege) then
   begin
   // ibtUpdate.AddDatabase(IBDB);
    UpdateQr.Database:=IBDB;
    UpdateQr.Transaction:=ibtUpdate;
    UpdateQr.Transaction.Active:=true;

    sqls:='Update '+tbPrivelege+' set '+
          ' SP'+IntToStr(GetCurrentMonth(CalcPeriod_ID))+' ='+ FloatToStr(Privilegent)+','+
          ' DP'+IntToStr(GetCurrentMonth(CalcPeriod_ID))+' ='+
             FloatToStr(Dependent*GetQuantityOfDependent(mainqr.fieldbyName('empplant_id').AsInteger))+',';
    sqls:=sqls+' itemmodifydate=' + ''''+DateToStr(Now)+''','+
          ' modifycatoremp_id='+ IntToStr(creatoremp_id)+
          ' where Privelege_id='+qrYearSumm.FieldByName('Privelege_id').AsString;

    UpdateQr.SQL.Clear;
    UpdateQr.SQL.Add(sqls);
    UpdateQr.ExecSQL;
    UpdateQr.Transaction.Commit;
   //Нахожу обновленную строку  содержащую льготы
//        TrRead.Commited;
        qrYearSumm.Database:=IBDB;
        qrYearSumm.Transaction:=TrRead;
        sqls:='select pr.* '+
              ' from ' + tbPrivelege + ' pr'+
              ' where pr.empplant_id ='+ inttostr(mainqr.fieldbyName('empplant_id').AsInteger)+' '+
              ' and pr.year_ =  ' +GetCurrentYear(calcperiod_id);
   qrYearSumm.sql.clear;
   qrYearSumm.sql.Add(sqls);
   qrYearSumm.Active:=true;

      SummPrivilegent:=qrYearSumm.fieldbyName('SP'+IntToStr(GetCurrentMonth(CalcPeriod_ID))).AsFloat +
                   qrYearSumm.fieldbyName('DP'+IntToStr(GetCurrentMonth(CalcPeriod_ID))).AsFloat;

   end ;

end;
//------------------------------------------------------------------------------
procedure TfmBuildingTree.bibCurPeriodClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
   calcperiod_id:=CurCalcperiod_id;
   FillChar(TPRBI,SizeOf(TPRBI),0);
   TPRBI.Visual.TypeView:=tviOnlyData;
   TPRBI.Locate.KeyFields:='calcperiod_id';
   TPRBI.Locate.KeyValues:=calcperiod_id;
   TPRBI.Locate.Options:=[loCaseInsensitive];
   if _ViewInterfaceFromName(NameCalcPeriod,@TPRBI) then begin
//    ChangeFlag:=true;
      calcperiod_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'calcperiod_id');
      edPeriod.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
      startdate:=GetFirstValueFromParamRBookInterface(@TPRBI,'startdate');
      enddate:=IncMonth(startdate,CalcSalaryPeriodStep)-1;
   end;
end;
//------------------------------------------------------------------------------
procedure TfmBuildingTree.bibPeriodClick(Sender: TObject);
var
//  P: PCalcPeriodParams;
  TPRBI: TParamRBookInterface;
Begin  
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='calcperiod_id';
  TPRBI.Locate.KeyValues:=calcperiod_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameCalcPeriod,@TPRBI) then begin
//   ChangeFlag:=true;
     calcperiod_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'calcperiod_id');
     edPeriod.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
     startdate:=GetFirstValueFromParamRBookInterface(@TPRBI,'startdate');
     enddate:=IncMonth(startdate,CalcSalaryPeriodStep)-1;
  end;
end;
//------------------------------------------------------------------------------
procedure TfmBuildingTree.bibEmpClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
           FillChar(TPRBI,SizeOf(TPRBI),0);
           TPRBI.Visual.TypeView:=tvibvModal;
           TPRBI.Locate.KeyFields:='emp_id';
           TPRBI.Locate.KeyValues:=emp_id;
           TPRBI.Locate.Options:=[loCaseInsensitive];
           if _ViewInterfaceFromName(NameEmp,@TPRBI) then begin
              emp_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'emp_id');
              edEmp.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'fname')
                          +' '+GetFirstValueFromParamRBookInterface(@TPRBI,'name')
                          +' '+GetFirstValueFromParamRBookInterface(@TPRBI,'sname');
           end;
end;
//------------------------------------------------------------------------------
procedure TfmBuildingTree.bibDepartClick(Sender: TObject);
var
  TPRBId: TParamRBookInterface;
begin
           FillChar(TPRBId,SizeOf(TPRBId),0);
           TPRBId.Visual.TypeView:=tvibvModal;
           TPRBId.Locate.KeyFields:='depart_id';
           TPRBId.Locate.KeyValues:=depart_id;
           TPRBId.Locate.Options:=[loCaseInsensitive];
           if _ViewInterfaceFromName(NameDepart,@TPRBId) then begin
              depart_id:=GetFirstValueFromParamRBookInterface(@TPRBId,'depart_id');
              eddepart.Text:=GetFirstValueFromParamRBookInterface(@TPRBId,'name');
           end;
end;
//------------------------------------------------------------------------------
function TfmBuildingTree.GetRadioCase: Integer;
begin
  Result:=-1;
  if rbAll.Checked then Result:=0;
  if rbEmp.Checked then Result:=1;
  if rbDepart.Checked then Result:=2;
end;

procedure TfmBuildingTree.rbAllClick(Sender: TObject);
begin
  edEmp.Enabled:=false;
  bibEmp.Enabled:=false;
  edDepart.Enabled:=false;
  bibDepart.Enabled:=false;

  if Sender=rbAll then begin
  end;
  if Sender=rbEmp then begin
   edEmp.Enabled:=true;
   bibEmp.Enabled:=true;
  end;
  if Sender=rbDepart then begin
   edDepart.Enabled:=true;
   bibDepart.Enabled:=true;
  end;
  TRadioButton(Sender).Checked:=true;
end;
//------------------------------------------------------------------------------
function TfmBuildingTree.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if rbEmp.Checked then
   if trim(edEmp.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[rbEmp.Caption]));
    bibEmp.SetFocus;
    Result:=false;
    exit;
   end;
  if rbDepart.Checked then
   if trim(eddepart.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[rbDepart.Caption]));
    bibDepart.SetFocus;
    Result:=false;
    exit;
   end;
end;
//------------------------------------------------------------------------------
procedure TfmBuildingTree.bibClearClick(Sender: TObject);
begin
  bibCurPeriodClick(nil);
  emp_id:=0;
  edEmp.Text:='';
  depart_id:=0;
  eddepart.Text:='';
  rbAllClick(rbAll);
end;

destructor TCalcThread.Destroy;
begin
  inherited;
  try
   _FreeProgressBar(PBHandle);
  except
  end;
end;

procedure TCalcThread.Execute;
var
  Wb: OleVariant;
  Sh: OleVariant;
  qr: TIbQuery;
  Row: Integer;
  summAdd: Currency;
  summDel: Currency;
  TCPB: TCreateProgressBar;
  TSPBS: TSetProgressBarStatus;

const
  FontSize=6;

  function GetNormalTime_Ex: string;
  var
   sqls: string;
   qrnew: TIBQuery;
   tran: TIBTransaction;
  begin
   Result:='';
   try
    Screen.Cursor:=crHourGlass;
    qrnew:=TIBQuery.Create(nil);
    tran:=TIBTransaction.Create(nil);
    try
     qrnew.Database:=IBDB;
     tran.AddDatabase(IBDB);
     tran.Params.Add('read_committed');
     tran.Params.Add('rec_version');
     tran.Params.Add('nowait');
     IBDB.AddTransaction(tran);
     qrnew.Transaction:=tran;
     qrnew.Transaction.Active:=true;
     sqls:='select sum(timecount) as ntime from '+tbNormalTime+
           ' where schedule_id='+qr.FieldByName('schedule_id').AsString+
           ' and workdate<='+QuotedStr(DateTimeToStr(fmParent.enddate))+
           ' and workdate>='+QuotedStr(DateTimeToStr(fmParent.startdate));
     qrnew.SQL.Add(sqls);
     qrnew.Active:=true;
     if not qrnew.IsEmpty then begin
      Result:=qrnew.FieldByName('ntime').AsString;
     end;
    finally
     tran.free;
     qrnew.free;
     Screen.Cursor:=crDefault;
    end;
   except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
   end;
  end;

  procedure ClearSalary;
  var
   sqls: string;
   qrnew: TIBQuery;
   tran: TIBTransaction;
   i,Index:integer;
  begin
   try
    Screen.Cursor:=crHourGlass;
    qrnew:=TIBQuery.Create(nil);
    tran:=TIBTransaction.Create(nil);
    try
     qrnew.Database:=IBDB;
     tran.AddDatabase(IBDB);
     tran.Params.Add('read_committed');
     tran.Params.Add('rec_version');
     tran.Params.Add('nowait');
     IBDB.AddTransaction(tran);
     qrnew.Transaction:=tran;
     qrnew.Transaction.Active:=true;
//     sqls:='update salary set calculated =0 where calcperiod_id=' +IntToStr(GetIDCurCalcPeriod);
     sqls:=' update salary sal set calculated =0 where';
//           'sal.EMPPLANT_ID in (select empplant_id from empplant ep where ep.EMP_ID=77)'


  if fmparent.rbAll.Checked then Index:=0;
  if fmparent.rbEmp.Checked then Index:=1;
  if fmparent.rbDepart.Checked then Index:=2;


          case Index of
            0: sqls:=sqls;
            1: sqls:=sqls+' sal.EMPPLANT_ID in (select empplant_id from empplant ep where ep.EMP_ID='+inttostr(fmparent.emp_id)+' and ';
            2: sqls:=sqls+' sal.EMPPLANT_ID in (select empplant_id from empplant ep where ep.DEPART_ID='+inttostr(fmparent.depart_id)+' and ';
          end;
           sqls:=sqls+' sal.CALCPERIOD_ID='+IntToStr(GetIDCurCalcPeriod);


     qrnew.SQL.Add(sqls);
     qrnew.Active:=true;
     tran.Commit;
     if not qrnew.IsEmpty then begin
//      Result:=qrnew.FieldByName('ntime').AsString;
     end;
    finally
     tran.free;
     qrnew.free;
     Screen.Cursor:=crDefault;
    end;
   except
  // {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
   end;
  end;



  function GetActualTime_Ex: string;
  var
   sqls: string;
   qrnew: TIBQuery;
   tran: TIBTransaction;
  begin
   Result:='';
   try
    Screen.Cursor:=crHourGlass;
    qrnew:=TIBQuery.Create(nil);
    tran:=TIBTransaction.Create(nil);
    try
     qrnew.Database:=IBDB;
     tran.AddDatabase(IBDB);
     tran.Params.Add('read_committed');
     tran.Params.Add('rec_version');
     tran.Params.Add('nowait');
     IBDB.AddTransaction(tran);
     qrnew.Transaction:=tran;
     qrnew.Transaction.Active:=true;
     sqls:='select sum(timecount) as atime from '+tbActualTime+
           ' where empplant_id='+qr.FieldByName('empplant_id').AsString+
           ' and absence_id='+inttostr(CalcSalaryAbsenceId)+
           ' and workdate<='+QuotedStr(DateTimeToStr(fmParent.enddate))+
           ' and workdate>='+QuotedStr(DateTimeToStr(fmParent.startdate));
     qrnew.SQL.Add(sqls);
     qrnew.Active:=true;
     if not qrnew.IsEmpty then begin
      Result:=qrnew.FieldByName('atime').AsString;
     end;
    finally
     tran.free;
     qrnew.free;
     Screen.Cursor:=crDefault;
    end;
   except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
   end;
  end;

var
  Range: OleVariant;
//  sqls: string;
  RecCount: Integer;
//  i: Integer;
//  CurEmpPlantId: Integer;
//  CurFlag: Integer;
//  CurY: Integer;
  qrNew: TIBQuery;
  period_id: Integer;
  i,iter: Integer;
  P: PInfoChargeTree;
  Pnew,PP: PInfoChargeTree;
  sqls,newsql:String;
  CalcPeriod_id: Integer;
  summ:Double;
 calcstartdate:TdateTime; //Число начала рассчета
 calcenddate:TdateTime; //Число конца рассчета
percentnalog:Double;
countrec:Integer;// Количество рассчитанных записей
countcalc:Integer;//Количество всего записей
    sex_id: Integer;
    familystate_id: Integer;
    nation_id: Integer;
    borntown_id: Integer;
    oklad : double; //Здесь хранится оклад работника
    mrot: double;
    category: Integer;
    id: Integer;
    ChargeFlag: Integer;
    correctperiod_id: Integer;
    empplant_id: Integer;
    Charge_id: Integer;
    percent:Double;
    hours:Double;
    days:Double;
    summa:Currency;
    basesumm:Currency;
    itemcreatedate:Tdate;
    itemmodifydate:Tdate;
    algorithm_id: Integer;
    typebaseamount: Integer;
           typepercent: Integer;
           typemultiply: Integer;
           typefactorworktime: Integer;
    statuscalcperiod: Integer;
    schedule_id: Integer;

   NormaDay:Double;
   NormaEvening:Double;
   NormaNight:Double;
   Norma:Double;
   Fact:Double;
   FactDay:Double;
   FactEvening:Double;
   FactNight:Double;
setka:Integer;
shift_id:Integer;
net_id:Integer;
k_oplaty:Double;
   Privilegent:Double;
   Dependent:Double;


MaxSummForPrivelege:Double;
YearSumm:Double; //Валовый доход за год
QuantityOfDependent:Integer;//Количество иждевенцев
OldYearSumm:Double; //Валовый доход c предыдущих мест работы
newid:String;
SummPrivilegent:Double; //Общая сумма скидки

FaktWorkTime:Double;
NormWorkTime:Double;
qq:Integer;//
NeedCalc:Boolean;
Privelege:Currency;

    startdate,enddate: TDateTime;
    CurCalcPeriod_id: Integer;
    emp_id: Integer;
    depart_id: Integer;



begin
 try
  try
   if CoInitialize(nil)<>S_OK then exit;
   try
    _SetSplashStatus(ConstSqlExecute);

    fmParent.Mainqr.Active:=false;
    fmParent.Mainqr.SQL.Clear;
    fmParent.Mainqr.Transaction.Active:=true;
    sqls:=fmParent.GetMainSqlString;

    fmParent.Mainqr.SQL.Add(sqls);
    fmParent.Mainqr.Active:=true;
    RecCount:=GetRecordCount(fmParent.Mainqr);
    RecCount:=RecCount+1;
    if RecCount=0 then exit;

    TCPB.Min:=1;
    TCPB.Max:=RecCount;
    TCPB.Hint:='';
    TCPB.Color:=clRed;
    PBHandle:=_CreateProgressBar(@TCPB);


//    _SetSplashStatus(ConstReportExecute);
//    PBHandle:=_CreateProgressBar(1,RecCount,'',clred,nil);


//begin

  ClearSalary;

  period_id:=GetIDCurCalcPeriod;
  fmparent.qr.DisableControls;
{  new(Pnew);
  new(PP);}
  CalcPeriod_id:=GetIDCurCalcPeriod();
//  InitCalendarUtil(IBDB);
  //Получить рассчетный период
  calcstartdate:=GetCurCalcPeriodStartDate;
  calcenddate:=IncMonth(calcstartdate,1)-1;

  try
{        new(Pnew);
        new(PP);
 }
        //Заполнение дерева
//        fmparent.qr.DisableControls;
        fmBuildingTree.AddFromQuery(fmparent.Listmain);
        fmBuildingTree.GenerateTree(fmparent.ListMain,fmparent.ListTree,'0','');
//        fmparent.qr.EnableControls;

//        PBHandle:=_CreateProgressBar(1,GetRecordCount(fmparent.Mainqr),'',clred,nil);

       fmparent.ibtUpdate.AddDatabase(IBDB);
       fmparent.ibtUpdate.Params.Text:=DefaultTransactionParamsTwo;
       IBDB.AddTransaction(fmparent.ibtUpdate);
       fmparent.UpdateQr.Database:=IBDB;
       fmparent.UpdateQr.Transaction:=fmparent.ibtUpdate;

        while not fmparent.mainqr.Eof do
           BEGIN


      TSPBS.Progress:=fmparent.mainqr.RecordCount;
      TSPBS.Hint:='';
      _SetProgressBarStatus(PBHandle,@TSPBS);
                //Подгатавливаю список начислений для конкретного места работы
                fmparent.qrCharge.Active:=false;
                fmparent.qrCharge.SQL.Text:='select sal.*, ch.charge_id  from '+ tbsalary +' sal '+
                                ' join ' + tbcharge + ' ch on  sal.charge_id in (select ch.charge_id from charge where ch.flag=0)'+
                                ' where empplant_id='+fmparent.mainqr.FieldByName('empplant_id').AsString +
                                ' and calcperiod_id=' +IntToStr(GetIDCurCalcPeriod)+
                                ' order by ch.charge_id';
                fmparent.qrCharge.Active:=true;
                fmparent.qrCharge.first;
                countrec:=GetRecordCount(fmparent.qrCharge);
                countcalc:=0;
                iter:=0;
                while not (countrec=countcalc) do
                BEgin
                        iter:=iter+1;
                        if (iter>1000) then
                        begin
                        ShowMessage('Неудается завершить рассчет. Проверьте справочник зависимостей начислений.');
                        exit;
                        end;
                        fmparent.qrcharge.First;
                        while not fmparent.qrCharge.Eof do
                                begin
                                percent:=0;
                                hours:=0;
                                days:=0;
                                summa:=0;
                                basesumm:=0;
                                //Если не рассчитано
                                if (fmparent.qrCharge.FieldByName('calculated').AsInteger=0) then
                                        begin
//                                        Pnew:=nil;
        Pnew:=recurseListNew(fmparent.ListTree,'',fmparent.qrCharge.FieldByName('charge_id').AsInteger);
                                      if (Pnew<>nil)and(Pnew.List<>nil) then
                                        if (Pnew.List.Count=0) then
                                                begin
                                                //Если конечная ветвь без дочерей
                                                basesumm:=GetBaseSumm(Pnew,fmparent.mainqr.FieldByName('empplant_id').AsInteger,fmparent.qrCharge.FieldByName('basesumm').AsCurrency);
                                                percent:= GetPercent(Pnew,fmparent.mainqr.FieldByName('empplant_id').AsInteger,fmparent.qrCharge.FieldByName('percent').AsFloat);
                                                NormWorkTime:=GetNormWorkTime(Pnew,fmparent.mainqr.FieldByName('empplant_id').AsInteger,0);
                                                FaktWorkTime:=GetFaktWorkTime(Pnew,fmparent.mainqr.FieldByName('empplant_id').AsInteger,fmparent.qrCharge.FieldByName('days').AsFloat,fmparent.qrCharge.FieldByName('hours').AsFloat);
                                                if (NormWorkTime=0) then summa:=0 else
                                                summa:=((basesumm/NormWorkTime)*FaktWorkTime)*ABS(percent)/100;

                                                //Записываю изменения в запись (рассчет)
                                                fmparent.UpdateQr.Transaction.Active:=true;
                                                sqls:='Update '+tbSalary+' set ';
                                                        if (percent>0) then sqls:=sqls+' percent='+ ChangeChar(FloatToStr(Percent),',','.')+',';
                                                        if (hours>0) then sqls:=sqls+' hours=' + ChangeChar(FloatToStr(hours),',','.')+',';
                                                        if (days>0) then sqls:=sqls+' days=' + ChangeChar(FloatToStr(days),',','.')+',';
                                                        if (basesumm<>0) then sqls:=sqls+' basesumm=' + ChangeChar(FloatToStr(BASESumm),',','.')+',';
                                                        if (summa<>0) then sqls:=sqls+' summa=' + ChangeChar(FloatToStr(Summa),',','.')+',';
                                                        sqls:=sqls+' calculated=1, ';
                                                        sqls:=sqls+' itemmodifydate=' + ''''+DateToStr(Now)+''','+
                                                        ' modifycatoremp_id='+ IntToStr(fmparent.creatoremp_id)+
                                                        ' where salary_id='+fmparent.qrCharge.FieldByName('Salary_id').AsString;
                                                        fmparent.UpdateQr.SQL.Clear;
                                                        fmparent.UpdateQr.SQL.Add(sqls);
                                                        try
                                                            fmparent.UpdateQr.ExecSQL;
                                                        except
                                                           raise //{$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
                                                        end;
                                                        fmparent.UpdateQr.Transaction.Commit;
                                                end
                                                else
                                                begin
                                                //Если имеются вложения
                                                NeedCalc:=true;
                                                BaseSumm:=0;
                                                for i:=0 to Pnew.List.Count-1 do
                                                        begin
                                                        PP:=Pnew.List.Items[i];
                                                        fmparent.IBQ2.Active:=false;
                                                        fmparent.IBQ2.Database:=WorkDB;//qr.Database;
                                                        fmparent.IBQ2.Transaction:=TrRead;//qr.Transaction;
                                                        fmparent.IBQ2.Transaction.Active:=false;//qr.Transaction;
                                                        fmparent.IBQ2.Transaction.Active:=true;
                                                        newsql:='select sal.*, ch.charge_id  from '+ tbsalary +' sal '+
                                                                ' join ' + tbcharge + ' ch on  sal.charge_id in (select ch.charge_id from charge where ch.flag=0)'+
                                                                ' where empplant_id='+ fmparent.mainqr.FieldByName('empplant_id').AsString +
                                                                ' and calcperiod_id=' +IntToStr(GetIDCurCalcPeriod)+
                                                                ' and charge_id=' +IntToStr(PP.charge_id);
                                                        fmparent.IBQ2.SQL.Clear;
                                                        fmparent.IBQ2.SQL.Add(newsql);
                                                        fmparent.IBQ2.Active:=true;
                                                        if not fmparent.IBQ2.IsEmpty then
                                                                begin
                                                                if (fmparent.IBQ2.FieldByName('calculated').AsInteger=0) then NeedCalc:=false ;
                                                                basesumm:=basesumm+fmparent.IBQ2.FieldByName('summa').AsCurrency;
                                                                end;
                                                        end;
                                                if (NeedCalc) then
                                                        begin
                                                        basesumm:=GetBaseSumm(Pnew,fmparent.mainqr.FieldByName('empplant_id').AsInteger,basesumm);
                                                        percent:= GetPercent(Pnew,fmparent.mainqr.FieldByName('empplant_id').AsInteger,fmparent.qrCharge.FieldByName('percent').AsFloat);
                                                        NormWorkTime:=GetNormWorkTime(Pnew,fmparent.mainqr.FieldByName('empplant_id').AsInteger,0);
                                                        FaktWorkTime:=GetFaktWorkTime(Pnew,fmparent.mainqr.FieldByName('empplant_id').AsInteger,fmparent.qrCharge.FieldByName('days').AsFloat,fmparent.qrCharge.FieldByName('hours').AsFloat);
                                                        if (NormWorkTime=0) then summa :=0 else
                                                        summa:=(basesumm/NormWorkTime)*FaktWorkTime*(ABS(percent)/100);
                                                        //Записываю изменения в запись (рассчет)
                                                        fmparent.UpdateQr.Transaction.Active:=true;
                                                        sqls:='Update '+tbSalary+' set ';
                                                                if (percent>0) then sqls:=sqls+' percent='+ ChangeChar(FloatToStr(Percent),',','.')+',';
                                                                if (hours>0) then sqls:=sqls+' hours=' + ChangeChar(FloatToStr(hours),',','.')+',';
                                                                if (days>0) then sqls:=sqls+' days=' + ChangeChar(FloatToStr(days),',','.')+',';
                                                                if (basesumm<>0) then sqls:=sqls+' basesumm=' + ChangeChar(FloatToStr(baseSumm),',','.')+',';
                                                                if (summa<>0) then sqls:=sqls+' summa=' + ChangeChar(FloatToStr(Summa),',','.')+',';
                                                                sqls:=sqls+' calculated=1, ';
                                                                sqls:=sqls+' itemmodifydate=' + ''''+DateToStr(Now)+''','+
                                                                ' modifycatoremp_id='+ IntToStr(fmparent.creatoremp_id)+
                                                                ' where salary_id='+fmparent.qrCharge.FieldByName('Salary_id').AsString;
                                                        fmparent.UpdateQr.SQL.Clear;
                                                        fmparent.UpdateQr.SQL.Add(sqls);
                                                        try
                                                         fmparent.UpdateQr.ExecSQL;
                                                         fmparent.UpdateQr.Transaction.Commit;
                                                        except
                                                        end;

                                                       end;
                                               end;

                                        end;
                                fmparent.qrCharge.Next;
                                end;
                fmparent.qrCount.Database:=IBDB;
                fmparent.qrCount.Transaction:=TrRead;
                fmparent.qrCount.Transaction.Active:=true;
                sqls:='select sum(calculated) as countcalc from '+tbSalary+' sal '+
                      ' join ' + tbcharge + ' ch on  sal.charge_id in (select ch.charge_id from charge where ch.flag=0)'+
                      ' where empplant_id='+fmparent.mainqr.FieldByName('empplant_id').AsString +
                      ' and calcperiod_id=' +IntToStr(GetIDCurCalcPeriod);
                fmparent.qrCount.SQL.Clear;
                fmparent.qrCount.SQL.Add(sqls);
                fmparent.qrCount.Open;
                countcalc:=fmparent.qrCount.FieldByName('countcalc').AsInteger;
                ENd;

//********************************************************************************
//Подгатавливаю список удержаний для конкретного места работы
//********************************************************************************
                //Подгатавливаю список удержаний для конкретного места работы
                fmparent.qrCharge.Active:=false;
                fmparent.qrCharge.SQL.Text:='select sal.*, ch.charge_id  from '+ tbsalary +' sal '+
                                ' join ' + tbcharge + ' ch on  sal.charge_id in (select ch.charge_id from charge where ch.flag=1)'+
                                ' where empplant_id='+fmparent.mainqr.FieldByName('empplant_id').AsString +
                                ' and calcperiod_id=' +IntToStr(GetIDCurCalcPeriod)+
                                ' order by ch.charge_id';
                fmparent.qrCharge.Active:=true;
                fmparent.qrCharge.first;
                countrec:=GetRecordCount(fmparent.qrCharge);
                countcalc:=0;

                while not (countrec=countcalc) do
                BEgin
                        fmparent.qrcharge.First;
                        while not fmparent.qrCharge.Eof do
                                begin
                                percent:=0;
                                hours:=0;
                                days:=0;
                                summa:=0;
                                basesumm:=0;
                                //Если не рассчитано
                                if (fmparent.qrCharge.FieldByName('calculated').AsInteger=0) then
                                        begin
                                      Pnew:=recurseListNew(fmparent.ListTree,'',fmparent.qrCharge.FieldByName('charge_id').AsInteger);
                                      if (Pnew<>nil)and(Pnew.List<>nil) then
                                        if (Pnew.List.Count=0) then
                                                begin
                                                //Если конечная ветвь без дочерей
                                                basesumm:=GetBaseSumm(Pnew,fmparent.mainqr.FieldByName('empplant_id').AsInteger,fmparent.qrCharge.FieldByName('basesumm').AsCurrency);
                                                percent:= GetPercent(Pnew,fmparent.mainqr.FieldByName('empplant_id').AsInteger,fmparent.qrCharge.FieldByName('percent').AsFloat);
                                                NormWorkTime:=GetNormWorkTime(Pnew,fmparent.mainqr.FieldByName('empplant_id').AsInteger,0);
                                                FaktWorkTime:=GetFaktWorkTime(Pnew,fmparent.mainqr.FieldByName('empplant_id').AsInteger,fmparent.qrCharge.FieldByName('days').AsFloat,fmparent.qrCharge.FieldByName('hours').AsFloat);
                                                //Если подоходный то скидку
                                                if (Pnew.charge_id=100) then
                                                        begin
                                                        SummPrivilegent:=0;
                                                        fmparent.GetPrivelege(fmparent.mainqr.FieldByName('empplant_id').AsInteger);
                                                        basesumm:=basesumm-SummPrivilegent;
                                                        summa:= Round(basesumm*percent/100);
                                                        if (summa<0) then summa:=0;
                                                        end
                                                        else
                                                if (NormWorkTime = 0) THEN summa:=0 else
                                                summa:=((basesumm/NormWorkTime)*FaktWorkTime)*ABS(percent)/100;

                                                //Записываю изменения в запись (рассчет)
                                                fmparent.UpdateQr.Transaction.Active:=true;
                                                sqls:='Update '+tbSalary+' set ';
                                                        if (percent>0) then sqls:=sqls+' percent='+ ChangeChar(FloatToStr(Percent),',','.')+',';
                                                        if (hours>0) then sqls:=sqls+' hours=' + ChangeChar(FloatToStr(hours),',','.')+',';
                                                        if (days>0) then sqls:=sqls+' days=' + ChangeChar(FloatToStr(days),',','.')+',';
                                                        if (basesumm<>0) then sqls:=sqls+' basesumm=' + ChangeChar(FloatToStr(baseSumm),',','.')+',';
                                                        if (summa<>0) then sqls:=sqls+' summa=' + ChangeChar(FloatToStr(Summa),',','.')+',';
                                                        sqls:=sqls+' calculated=1, ';
                                                        sqls:=sqls+' itemmodifydate=' + ''''+DateToStr(Now)+''','+
                                                        ' modifycatoremp_id='+ IntToStr(fmparent.creatoremp_id)+
                                                        ' where salary_id='+fmparent.qrCharge.FieldByName('Salary_id').AsString;
                                                        fmparent.UpdateQr.SQL.Clear;
                                                        fmparent.UpdateQr.SQL.Add(sqls);
                                                       try
                                                        fmparent.UpdateQr.ExecSQL;
                                                        fmparent.UpdateQr.Transaction.Commit;
                                                       except
                                                       end;


                                                end
                                                else
                                                begin
                                                //Если имеются вложения
                                                NeedCalc:=true;
                                                BaseSumm:=0;
                                                for i:=0 to Pnew.List.Count-1 do
                                                        begin
                                                        PP:=Pnew.List.Items[i];
                                                        fmparent.IBQ2.Active:=false;
                                                        fmparent.IBQ2.Database:=WorkDB;//qr.Database;
                                                        fmparent.IBQ2.Transaction:=TrRead;//qr.Transaction;
                                                        fmparent.IBQ2.Transaction.Active:=false;//qr.Transaction;
                                                        fmparent.IBQ2.Transaction.Active:=true;
                                                        newsql:='select sal.*, ch.charge_id  from '+ tbsalary +' sal '+
                                                                ' join ' + tbcharge + ' ch on  sal.charge_id in (select ch.charge_id from charge where ch.flag=0)'+
                                                                ' where empplant_id='+ fmparent.mainqr.FieldByName('empplant_id').AsString +
                                                                ' and calcperiod_id=' +IntToStr(GetIDCurCalcPeriod)+
                                                                ' and charge_id=' +IntToStr(PP.charge_id);
                                                        fmparent.IBQ2.SQL.Clear;
                                                        fmparent.IBQ2.SQL.Add(newsql);
                                                        fmparent.IBQ2.Active:=true;
                                                        if not fmparent.IBQ2.IsEmpty then
                                                                begin
                                                                if (fmparent.IBQ2.FieldByName('calculated').AsInteger=0) then NeedCalc:=false ;
                                                                basesumm:=basesumm+fmparent.IBQ2.FieldByName('summa').AsCurrency;
                                                                end;
                                                 end;
                                                if (NeedCalc) then
                                                        begin
                                                        basesumm:=GetBaseSumm(Pnew,fmparent.mainqr.FieldByName('empplant_id').AsInteger,basesumm);
                                                        percent:= GetPercent(Pnew,fmparent.mainqr.FieldByName('empplant_id').AsInteger,fmparent.qrCharge.FieldByName('percent').AsFloat);
                                                        NormWorkTime:=GetNormWorkTime(Pnew,fmparent.mainqr.FieldByName('empplant_id').AsInteger,0);
                                                        FaktWorkTime:=GetFaktWorkTime(Pnew,fmparent.mainqr.FieldByName('empplant_id').AsInteger,fmparent.qrCharge.FieldByName('days').AsFloat,fmparent.qrCharge.FieldByName('hours').AsFloat);
                                                if (Pnew.charge_id=100) then
                                                        begin
                                                        SummPrivilegent:=0;
                                                        fmparent.GetPrivelege(fmparent.mainqr.FieldByName('empplant_id').AsInteger);
                                                        basesumm:=basesumm-SummPrivilegent;
                                                        summa:= Round(basesumm*percent/100);
                                                        if (summa<0) then summa:=0;
                                                        end
                                                        else
                                                if (NormWorkTime = 0) THEN summa:=0 else
                                                summa:=((basesumm/NormWorkTime)*FaktWorkTime)*ABS(percent)/100;
                                                        //Записываю изменения в запись (рассчет)
                                                        fmparent.UpdateQr.Transaction.Active:=true;
                                                        sqls:='Update '+tbSalary+' set ';
                                                                if (percent>0) then sqls:=sqls+' percent='+ ChangeChar(FloatToStr(Percent),',','.')+',';
                                                                if (hours>0) then sqls:=sqls+' hours=' + ChangeChar(FloatToStr(hours),',','.')+',';
                                                                if (days>0) then sqls:=sqls+' days=' + ChangeChar(FloatToStr(days),',','.')+',';
                                                                if (basesumm<>0) then sqls:=sqls+' basesumm=' + ChangeChar(FloatToStr(BASESumm),',','.')+',';
                                                                if (summa<>0) then sqls:=sqls+' summa=' + ChangeChar(FloatToStr(Summa),',','.')+',';
                                                                sqls:=sqls+' calculated=1, ';
                                                                sqls:=sqls+' itemmodifydate=' + ''''+DateToStr(Now)+''','+
                                                                ' modifycatoremp_id='+ IntToStr(fmparent.creatoremp_id)+
                                                                ' where salary_id='+fmparent.qrCharge.FieldByName('Salary_id').AsString;
                                                        fmparent.UpdateQr.SQL.Clear;
                                                        fmparent.UpdateQr.SQL.Add(sqls);
                                                       try
                                                        fmparent.UpdateQr.ExecSQL;
                                                        fmparent.UpdateQr.Transaction.Commit;
                                                       except
                                                       end;

                                                     end;
                                                end;

                                        end;
                                fmparent.qrCharge.Next;
                                end;
                fmparent.qrCount.Database:=IBDB;
                fmparent.qrCount.Transaction:=TrRead;
                fmparent.qrCount.Transaction.Active:=true;
                sqls:='select sum(calculated) as countcalc from '+tbSalary+' sal '+
                      ' join ' + tbcharge + ' ch on  sal.charge_id in (select ch.charge_id from charge where ch.flag=1)'+
                      ' where empplant_id='+fmparent.mainqr.FieldByName('empplant_id').AsString +
                      ' and calcperiod_id=' +IntToStr(GetIDCurCalcPeriod);
                fmparent.qrCount.SQL.Clear;
                fmparent.qrCount.SQL.Add(sqls);
                fmparent.qrCount.Open;
                countcalc:=fmparent.qrCount.FieldByName('countcalc').AsInteger;
              ENd;


        fmparent.mainqr.Next;
        END;
  finally

  fmparent.ibtUpdate.RemoveDatabase(fmparent.ibtUpdate.FindDatabase(IBDB));
  IBDB.RemoveTransaction(IBDB.FindTransaction(fmparent.ibtUpdate));


  fmparent.ClearList(fmparent.Listmain);
  fmparent.ClearList(fmparent.ListTree);

  end;
  //  _FreeProgressBar(PBHandle);
//end;


   finally
    DoTerminate;
   end;
  finally
   CoUninitialize;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;
//------------------------------------------------------------------------------
function TfmBuildingTree.GetMainSqlString: string;
var
  Index: Integer;
begin
   Result:=' select * from ' + tbempplant +' ep'+
           ' join ' + tbDepart + ' d on ep.depart_id=d.depart_id ';
         Index:=GetRadioCase;
          case Index of
            0: Result:=Result;
            1: Result:=Result+' where ep.EMP_ID ='+inttostr(emp_id);
            2: Result:=Result+' where ep.depart_id='+inttostr(depart_id);
          end;
  Result:=Result+' order by ep.empplant_id';
end;
//------------------------------------------------------------------------------
procedure  TfmBuildingTree.SetRadioCase(Index: Integer);
begin
  case Index of
    0: rbAllClick(rbAll);
    1: rbAllClick(rbEmp);
    2: rbAllClick(rbDepart);
  end;
end;
//------------------------------------------------------------------------------
 function GetOnSalary(empplant_id:integer;calcperiod_id:Integer;charge_id:integer):Currency;
var
  qrNew: TIBQuery;
  period_id: Integer;
  i,iter: Integer;
  P: PInfoChargeTree;
  Pnew,PP: PInfoChargeTree;
  sqls,newsql:String;
  totalsumm:Currency;
begin
  REsult:= 0;
    totalsumm:=0;
    fmBuildingTree:=TfmBuildingTree.Create(nil);
  try
     period_id:=CalcPeriod_id;
//     new(Pnew);
//     new(PP);
     try
        new(Pnew);
        new(PP);
        //Заполнение дерева
        fmBuildingTree.AddFromQuery(fmBuildingTree.Listmain);
        fmBuildingTree.GenerateTree(fmBuildingTree.ListMain,fmBuildingTree.ListTree,'0','');
        fmBuildingTree.mainqr.Active:=false;
        //Перебираем все места работы для сотрудников
        fmBuildingTree.mainqr.SQL.Text:='select * from '+tbempplant + ' where empplant_id='+IntToStr(empplant_id);

                         //Добавить фильтр которые работают в данном периоде
        //Перебираем все места работы для сотрудников
        fmBuildingTree.mainqr.Active:=true;
        fmBuildingTree.mainqr.First;

//        while not fmBuildingTree.mainqr.Eof do
           BEGIN
              //Подгатавливаю список начислений для конкретного места работы
                fmBuildingTree.qrCharge.Active:=false;
                fmBuildingTree.qrCharge.SQL.Text:='select sal.*, ch.charge_id  from '+ tbsalary +' sal '+
                                ' join ' + tbcharge + ' ch on  sal.charge_id in (select ch.charge_id from charge where ch.flag=0)'+
                                ' where empplant_id='+fmBuildingTree.mainqr.FieldByName('empplant_id').AsString +
                                ' and calcperiod_id=' + IntToStr(period_id) +
                                ' order by ch.charge_id';
                fmBuildingTree.qrCharge.Active:=true;
                fmBuildingTree.qrCharge.first;
                fmBuildingTree.countrec:=GetRecordCount(fmBuildingTree.qrCharge);
                fmBuildingTree.countcalc:=0;
                iter:=0;
//                while not (fmBuildingTree.countrec=fmBuildingTree.countcalc) do
                BEgin
                        iter:=iter+1;
                        if (iter>1000) then
                        begin
                        ShowMessage('Неудается завершить рассчет. Проверьте справочник зависимостей начислений.');
                        exit;
                        end;
                        fmBuildingTree.qrcharge.First;
//                        while not fmBuildingTree.qrCharge.Eof do
                                begin
//                                if  (fmBuildingTree.qrCharge.FieldByName('charge_id').AsInteger<>charge_id) then
//                                begin
//                                fmBuildingTree.qrCharge.Next;
//                                end
//                                else
                                begin
                                        Pnew:=nil;
                                        Pnew:=recurseListNew(fmBuildingTree.ListTree,'',charge_id);
                                        if (Pnew.List.Count=0) then
                                                begin
                                                   //Если конечная ветвь без дочерей
                                                    totalsumm:=totalsumm+fmBuildingTree.qrCharge.FieldByName('SUMMA').AsCurrency;
                                                end
                                                else
                                                begin
                                                //Если имеются вложения
                                                for i:=0 to Pnew.List.Count-1 do
                                                        begin
                                                        PP:=Pnew.List.Items[i];
                                                        fmBuildingTree.IBQ2.Active:=false;
                                                        fmBuildingTree.IBQ2.Database:=WorkDB;//qr.Database;
                                                        fmBuildingTree.IBQ2.Transaction:=TrRead;//qr.Transaction;
                                                        fmBuildingTree.IBQ2.Transaction.Active:=false;//qr.Transaction;
                                                        fmBuildingTree.IBQ2.Transaction.Active:=true;
                                                        newsql:='select sal.*, ch.charge_id  from '+ tbsalary +' sal '+
                                                                ' join ' + tbcharge + ' ch on  sal.charge_id in (select ch.charge_id from charge where ch.flag=0)'+
                                                                ' where empplant_id='+ fmBuildingTree.mainqr.FieldByName('empplant_id').AsString +
                                                                ' and calcperiod_id=' +IntToStr(period_id)+
                                                                ' and charge_id=' +IntToStr(PP.charge_id);
                                                        fmBuildingTree.IBQ2.SQL.Clear;
                                                        fmBuildingTree.IBQ2.SQL.Add(newsql);
                                                        fmBuildingTree.IBQ2.Active:=true;
                                                        if not fmBuildingTree.IBQ2.IsEmpty then
                                                                begin
                                                                totalsumm:=totalsumm+fmBuildingTree.IBQ2.FieldByName('summa').AsCurrency;
                                                                end;
                                                        end;
                                        end;
 //                               fmBuildingTree.qrCharge.Next;
                                end;
                                end;
                ENd;

 //       fmBuildingTree.mainqr.Next;
        END;
  finally
  Dispose(Pnew);
  Dispose(PP);
  fmBuildingTree.ClearList(fmBuildingTree.Listmain);
//  Listmain.free;
  fmBuildingTree.ClearList(fmBuildingTree.ListTree);
//  ListTree.Free;

//  qr.EnableControls;
  end;
//end;
finally
 fmBuildingTree.Free;
 fmBuildingTree:=nil;
end;
Result:=totalsumm;
end;

procedure TfmBuildingTree.SetInterfaceHandle(Value: THandle);
begin
  FhInterface:=Value;
end;


procedure TfmBuildingTree.ReturnModalParams(Param: PParamReportInterface);
begin
//  ReturnModalParamsFromDataSetAndGrid(MainQr,Grid,Param);
end;

procedure TfmBuildingTree.InitMdiChildParams(hInterface: THandle; Param: PParamReportInterface);
begin
   FhInterface:=hInterface;
//   ViewSelect:=false;
///   WhereString:=PrepearWhereString(Param.Condition.WhereStr);
//   LastOrderStr:=PrepearOrderString(Param.Condition.OrderStr);
//   ActiveQuery(true);
{   with Param.Locate do begin
    if KeyFields<>nil then
      MainQr.Locate(KeyFields,KeyValues,Options);
   end;}
   FormStyle:=fsMDIChild;
   if WindowState=wsMinimized then begin
    WindowState:=wsNormal;
   end;
   BringToFront;
   Show;
end;

procedure TfmBuildingTree.InitModalParams(hInterface: THandle; Param: PParamReportInterface);
begin
  FhInterface:=hInterface;
//  bibClose.Cancel:=true;
//  bibOk.OnClick:=MR;
//  bibClose.Caption:=CaptionCancel;
//  bibOk.Visible:=true;
//  Grid.OnDblClick:=MR;
//  Grid.MultiSelect:=Param.Visual.MultiSelect;
  BorderIcons:=BorderIcons-[biMinimize];
  WindowState:=wsNormal;
//  WhereString:=PrepearWhereString(Param.Condition.WhereStr);
//  LastOrderStr:=PrepearOrderString(Param.Condition.OrderStr);
//  ActiveQuery(true);
{  with Param.Locate do begin
    if KeyFields<>nil then
//      MainQr.Locate(KeyFields,KeyValues,Options);
  end;}
end;

end.
// Button1.Caption:=FloatToStr(GetOnSalary(60,53,755));

