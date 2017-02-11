unit URptAccountSheets;

interface
{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URptMain, OleCtnrs, StdCtrls, Buttons, ExtCtrls, Excel97, ComCtrls, IBQuery,
  IBDatabase, Db, IBCustomDataSet;

type
  TfmRptAccountSheets = class(TfmRptMain)
    grbCase: TGroupBox;
    rbAll: TRadioButton;
    rbEmp: TRadioButton;
    rbDepart: TRadioButton;
    lbPeriod: TLabel;
    edPeriod: TEdit;
    bibPeriod: TBitBtn;
    bibCurPeriod: TBitBtn;
    edEmp: TEdit;
    bibEmp: TBitBtn;
    eddepart: TEdit;
    bibDepart: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bibBreakClick(Sender: TObject);
    procedure bibPeriodClick(Sender: TObject);
    procedure rbAllClick(Sender: TObject);
    procedure bibEmpClick(Sender: TObject);
    procedure bibDepartClick(Sender: TObject);
    procedure bibCurPeriodClick(Sender: TObject);
    procedure bibClearClick(Sender: TObject);
    procedure bibGenClick(Sender: TObject);
  private
    procedure OnRptTerminate(Sender: TObject);
    function GetRadioCase: Integer;
    procedure SetRadioCase(Index: Integer);
    function CheckFieldsFill: Boolean;
  public
    startdate,enddate: TDateTime;
    CurCalcPeriod_id: Integer;
    calcperiod_id: Integer;
    emp_id: Integer;
    depart_id: Integer;

    procedure LoadFromIni;override;
    procedure SaveToIni;override;
    procedure GenerateReport;override;
    function GetMainSqlString: string;
    function GetWorkBookName: String;
  end;

var
  fmRptAccountSheets: TfmRptAccountSheets;

implementation

uses USalaryTsvCode,URptThread,comobj,UMainUnited,ActiveX,
     USalaryTsvData, DateUtil;

type
  TRptExcelThreadLocal=class(TRptExcelThread)
  private
    PBHandle: LongWord;
  public
    fmParent: TfmRptAccountSheets;
    procedure Execute;override;
    destructor Destroy;override;
  end;

var
  Rpt: TRptExcelThreadLocal;

{$R *.DFM}

procedure TfmRptAccountSheets.FormCreate(Sender: TObject);
begin
 inherited;
 try
  Caption:=NameRptAccountSheets;

  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  CurCalcPeriod_id:=GetCurCalcPeriodID(IBDB);
  bibCurPeriodClick(nil);
  
  edPeriod.MaxLength:=DomainNameLength;
  edEmp.MaxLength:=DomainNameLength+DomainSmallNameLength+DomainSmallNameLength+2;
  eddepart.MaxLength:=DomainNameLength;

  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRptAccountSheets.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(Rpt);
  if FormState=[fsCreatedMDIChild] then
   fmRptAccountSheets:=nil;
end;

procedure TfmRptAccountSheets.LoadFromIni;

  function SetDepartName: string;
  var
    TPRBI: TParamRBookInterface;
  begin
   Result:='';
   FillChar(TPRBI,SizeOf(TPRBI),0);
   TPRBI.Visual.TypeView:=tviOnlyData;
   TPRBI.Condition.WhereStr:=PChar(' depart_id='+inttostr(depart_id)+' ');
   if _ViewInterfaceFromName(NameRbkDepart,@TPRBI) then begin
     depart_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'bank_id');
     eddepart.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
   end;
  end;

  function SetEmpName: string;
  var
    TPRBI: TParamRBookInterface;
  begin
   Result:='';
   FillChar(TPRBI,SizeOf(TPRBI),0);
   TPRBI.Visual.TypeView:=tviOnlyData;
   TPRBI.Condition.WhereStr:=PChar(' emp_id='+inttostr(emp_id)+' ');
   if _ViewInterfaceFromName(NameRbkEmp,@TPRBI) then begin
     emp_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'emp_id');
     edEmp.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'fname')+' '+
                 GetFirstValueFromParamRBookInterface(@TPRBI,'name')+' '+
                 GetFirstValueFromParamRBookInterface(@TPRBI,'sname');
   end;
  end;
  
begin
 inherited;
 try
    emp_id:=ReadParam(ClassName,'emp_id',emp_id);
    if emp_id<>0 then SetEmpName;
    depart_id:=ReadParam(ClassName,'depart_id',depart_id);
    if depart_id<>0 then SetDepartName;
    SetRadioCase(ReadParam(ClassName,'case',GetRadioCase));
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRptAccountSheets.SaveToIni;
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

procedure TfmRptAccountSheets.OnRptTerminate(Sender: TObject);
begin
  FreeAndNil(Rpt);
  bibBreakClick(nil);
end;

procedure TfmRptAccountSheets.GenerateReport;
begin
  if Rpt<>nil then exit;
  Rpt:=TRptExcelThreadLocal.Create;
  Rpt.fmParent:=Self;
  Rpt.OnTerminate:=OnRptTerminate;
  Rpt.Resume;
end;

procedure TfmRptAccountSheets.bibBreakClick(Sender: TObject);
begin
  if Rpt<>nil then
    Rpt.Terminate;
  inherited;  
end;

procedure TfmRptAccountSheets.bibPeriodClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='calcperiod_id';
  TPRBI.Locate.KeyValues:=calcperiod_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkCalcPeriod,@TPRBI) then begin
   calcperiod_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'calcperiod_id');
   edPeriod.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
   startdate:=GetFirstValueFromParamRBookInterface(@TPRBI,'startdate');
   enddate:=IncMonth(startdate,CalcSalaryPeriodStep)-1;
  end;
end;

procedure TfmRptAccountSheets.bibEmpClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='emp_id';
  TPRBI.Locate.KeyValues:=emp_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkEmp,@TPRBI) then begin
   emp_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'emp_id');
   edEmp.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'fname')+' '+
               GetFirstValueFromParamRBookInterface(@TPRBI,'name')+' '+
               GetFirstValueFromParamRBookInterface(@TPRBI,'sname');
  end;
end;

procedure TfmRptAccountSheets.bibDepartClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='depart_id';
  TPRBI.Locate.KeyValues:=depart_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkDepart,@TPRBI) then begin
   depart_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'depart_id');
   eddepart.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmRptAccountSheets.rbAllClick(Sender: TObject);
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

procedure TfmRptAccountSheets.bibCurPeriodClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  calcperiod_id:=CurCalcperiod_id;
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Locate.KeyFields:='calcperiod_id';
  TPRBI.Locate.KeyValues:=calcperiod_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkCalcPeriod,@TPRBI) then begin
   startdate:=GetFirstValueFromParamRBookInterface(@TPRBI,'startdate');
   enddate:=IncMonth(startdate,CalcSalaryPeriodStep)-1;
   calcperiod_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'calcperiod_id');
   edPeriod.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

function TfmRptAccountSheets.GetRadioCase: Integer;
begin
  Result:=-1;
  if rbAll.Checked then Result:=0;
  if rbEmp.Checked then Result:=1;
  if rbDepart.Checked then Result:=2;
end;

procedure TfmRptAccountSheets.SetRadioCase(Index: Integer);
begin
  case Index of
    0: rbAllClick(rbAll);
    1: rbAllClick(rbEmp);
    2: rbAllClick(rbDepart);
  end;
end;

procedure TfmRptAccountSheets.bibClearClick(Sender: TObject);
begin
  bibCurPeriodClick(nil);
  emp_id:=0;
  edEmp.Text:='';
  depart_id:=0;
  eddepart.Text:='';
  rbAllClick(rbAll);
end;

function TfmRptAccountSheets.GetMainSqlString: string;

  function GetFromTree(curdepart_id: Integer): String;
  var
   sqls: string;
   qrnew: TIBQuery;
   tran: TIBTransaction;
  begin
   Result:='';
   try
    qrnew:=TIBQuery.Create(nil);
    tran:=TIBTransaction.Create(nil);
    try
     qrnew.Database:=IBDB;
     tran.AddDatabase(IBDB);
     tran.Params.Text:=DefaultTransactionParamsTwo;
     IBDB.AddTransaction(tran);
     qrnew.Transaction:=tran;
     qrnew.Transaction.Active:=true;
     sqls:='select * from '+tbDepart+
           ' where parent_id='+Inttostr(curdepart_id);
     qrnew.SQL.Add(sqls);
     qrnew.Active:=true;
     qrnew.First;
     while not qrnew.Eof do begin
       Result:=Result+' or depart_id='+qrnew.FieldByName('depart_id').AsString+
               GetFromTree(qrnew.FieldByName('depart_id').AsInteger);
       qrnew.Next;
     end;
    finally
     tran.free;
     qrnew.free;
    end;
   except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
   end;
  end; 
  
var
  Index: Integer;
begin
  Result:='select c2.name as correctperiodname,'+
          'd.name as departname,e.tabnum,fp.pay,'+
          'e.fname||'' ''||e.name||'' ''||e.sname as fio,'+
          'ch.shortname as chargename,s.days,s.hours,'+
          's.percent,s.summa,s.empplant_id,ch.flag,'+
          'eps.schedule_id'+
          ' from '+tbSalary+' s'+
          ' join '+tbCalcPeriod+' c2 on s.correctperiod_id=c2.calcperiod_id'+
          ' join '+tbEmpPlant+' ep on s.empplant_id=ep.empplant_id'+
          ' join '+tbEmp+' e on ep.emp_id=e.emp_id'+
          ' join '+tbDepart+' d on ep.depart_id=d.depart_id'+
          ' join '+tbFactPay+' fp on s.empplant_id=fp.empplant_id'+
          ' join '+tbCharge+' ch on s.charge_id=ch.charge_id'+
          ' left join '+tbEmpPlantSchedule+' eps on ep.empplant_id=eps.empplant_id'+
          ' where fp.factpay_id=(select max(n1.factpay_id)'+
          ' from '+tbFactPay+' n1 where n1.empplant_id=ep.empplant_id)';
  Result:=Result+' and s.calcperiod_id='+inttostr(calcperiod_id)+
                 ' and eps.schedule_id=(select max(s1.schedule_id) from '+tbEmpPlantSchedule+
                 ' s1 where s1.empplant_id=ep.empplant_id)';

  Index:=GetRadioCase;
  case Index of
    0: Result:=Result;
    1: Result:=Result+' and e.emp_id='+inttostr(emp_id);
    2: begin
     Result:=Result+' and (d.depart_id='+inttostr(depart_id)+GetFromTree(depart_id)+') ';
    end; 
  end;
  Result:=Result+' order by ep.empplant_id,ch.flag,ch.charge_id';
end;

function TfmRptAccountSheets.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edPeriod.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbPeriod.Caption]));
    bibPeriod.SetFocus;
    Result:=false;
    exit;
  end;
  if rbEmp.Checked then
   if trim(edEmp.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[rbEmp.Caption]));
    bibEmp.SetFocus;
    Result:=false;
    exit;
   end;
  if rbDepart.Checked then
   if trim(eddepart.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[rbDepart.Caption]));
    bibDepart.SetFocus;
    Result:=false;
    exit;
   end;
end;

procedure TfmRptAccountSheets.bibGenClick(Sender: TObject);
begin
  if CheckFieldsFill then
   inherited;
end;

function TfmRptAccountSheets.GetWorkBookName: String;
var
  Index: Integer;
begin
  Result:='Расчетные листы за: '+edPeriod.Text;
  Index:=GetRadioCase;
  case Index of
    0: Result:=Result;
    1: Result:=Result+' Сотруднику: '+edEmp.Text;
    2: Result:=Result+' Отделу: '+edDepart.text;
  end;
  Result:=Result+' от '+DateTimeToStr(_GetDateTimeFromServer);
end;

{ TRptExcelThreadTest }

destructor TRptExcelThreadLocal.Destroy;
begin
  inherited;
  _FreeProgressBar(PBHandle);
end;

procedure TRptExcelThreadLocal.Execute;
var
  Wb: OleVariant;
  Sh: OleVariant;
  qr: TIbQuery;
  Row: Integer;
  summAdd: Currency;
  summDel: Currency;
const
  FontSize=6;

  procedure CreateColumn(Flag: Boolean);
  var
    tmps: string;
    Range: OleVariant;
  begin
    tmps:='вид начисления';
    if flag then tmps:='вид удержания';
    Range:=Sh.Range[Sh.Cells[Row,1],Sh.Cells[Row,6]];
    Range.Borders.LineStyle:=xlContinuous;
    Range.Borders.Weight:=xlThin;
    Sh.Cells[Row,1].Value:='п.корр.';
    Sh.Cells[Row,1].Font.Size:=FontSize;
    Sh.Cells[Row,2].Value:=tmps;
    Sh.Cells[Row,2].Font.Size:=FontSize;
    Sh.Cells[Row,3].Value:='дни';
    Sh.Cells[Row,3].Font.Size:=FontSize;
    Sh.Cells[Row,4].Value:='часы';
    Sh.Cells[Row,4].Font.Size:=FontSize;
    Sh.Cells[Row,5].Value:='процент';
    Sh.Cells[Row,5].Font.Size:=FontSize;
    Sh.Cells[Row,6].Value:='сумма';
    Sh.Cells[Row,6].Font.Size:=FontSize;
    inc(Row);
    Range.HorizontalAlignment:=xlHAlignCenter;
    Range.VerticalAlignment:=xlVAlignCenter;
    Range.Columns.AutoFit;
  end;

  function GetNormalTime_Ex: string;
  var
   sqls: string;
   qrnew: TIBQuery;
   tran: TIBTransaction;
  begin
   Result:='';
   try
//    Screen.Cursor:=crHourGlass;
    qrnew:=TIBQuery.Create(nil);
    tran:=TIBTransaction.Create(nil);
    try
     qrnew.Database:=IBDB;
     tran.AddDatabase(IBDB);
     tran.Params.Text:=DefaultTransactionParamsTwo;
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
//     Screen.Cursor:=crDefault;
    end;
   except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
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
//    Screen.Cursor:=crHourGlass;
    qrnew:=TIBQuery.Create(nil);
    tran:=TIBTransaction.Create(nil);
    try
     qrnew.Database:=IBDB;
     tran.AddDatabase(IBDB);
     tran.Params.Text:=DefaultTransactionParamsTwo;
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
//     Screen.Cursor:=crDefault;
    end;
   except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
   end;
  end;

  procedure CreateHeader;
  var
    tmps: string;
  begin
    tmps:='Лицевой счет за: '+fmParent.edPeriod.Text;
    Sh.Cells[Row,1].Value:=tmps;
    Sh.Cells[Row,1].Font.Size:=FontSize;
    inc(Row);

    tmps:='Таб.№'+qr.FieldByName('tabnum').AsString+
          ' '+qr.FieldByName('departname').AsString+
          ' '+qr.FieldByName('fio').AsString;
    Sh.Cells[Row,1].Value:=tmps;
    Sh.Cells[Row,1].Font.Size:=FontSize;
    inc(Row);

    tmps:='Оклад: '+qr.FieldByName('pay').AsString+
          ' Норма времени: '+GetNormalTime_Ex+
          ' Факт:'+GetActualTime_Ex;
    Sh.Cells[Row,1].Value:=tmps;
    Sh.Cells[Row,1].Font.Size:=FontSize;
    inc(Row);

    CreateColumn(false);
  end;

  procedure CreateRows;
  var
    Range: OleVariant;
  begin
    Range:=Sh.Range[Sh.Cells[Row,1],Sh.Cells[Row,6]];
    Range.Borders.LineStyle:=xlContinuous;
    Range.Borders.Weight:=xlThin;
    Sh.Cells[Row,1].Value:=qr.FieldByname('correctperiodname').AsString;
    Sh.Cells[Row,1].Font.Size:=FontSize;
    Sh.Cells[Row,2].Value:=qr.FieldByname('chargename').AsString;
    Sh.Cells[Row,2].Font.Size:=FontSize;
    Sh.Cells[Row,3].Value:=qr.FieldByname('days').AsInteger;
    Sh.Cells[Row,3].Font.Size:=FontSize;
    Sh.Cells[Row,4].Value:=qr.FieldByname('hours').AsInteger;
    Sh.Cells[Row,4].Font.Size:=FontSize;
    Sh.Cells[Row,5].Value:=qr.FieldByname('percent').AsFloat;
    Sh.Cells[Row,5].Font.Size:=FontSize;
    Sh.Cells[Row,6].Value:=qr.FieldByname('summa').AsCurrency;
    Sh.Cells[Row,6].Font.Size:=FontSize;
    inc(Row);
  end;

  procedure CreateEmptyRow;
  begin
    inc(Row);
  end;

  procedure CreateSumm(Flag: Integer);
  begin
    case Flag of
      0: begin
       Sh.Cells[Row,1].Value:='Всего начислено:';
       Sh.Cells[Row,6].Value:=summAdd;
      end;
      1: begin
       Sh.Cells[Row,1].Value:='Всего удержано:';
       Sh.Cells[Row,6].Value:=summDel;
      end;
    end;
    Sh.Cells[Row,1].Font.Size:=FontSize;
    Sh.Cells[Row,6].Font.Size:=FontSize;
    inc(Row);
  end;

  procedure CalculateSumm(Flag: Integer);
  begin
    case Flag of
      0: begin
       summAdd:=summAdd+qr.FieldByName('summa').AsCurrency;
      end;
      1: begin
       summDel:=summDel+qr.FieldByName('summa').AsCurrency;
      end;
    end;
  end;

  procedure CreateSummAll;
  var
    curVal: Currency;
    Range: OleVariant;
  begin
    curVal:=0;

    Sh.Cells[Row,1].Value:='К выдаче:';
    Sh.Cells[Row,1].Font.Size:=FontSize;
    Sh.Cells[Row,6].Value:=summAdd-summDel;
    Sh.Cells[Row,6].Font.Size:=FontSize;
    inc(Row);

    Sh.Cells[Row,1].Value:='Доход облагаемый:';
    Sh.Cells[Row,1].Font.Size:=FontSize;
    Sh.Cells[Row,6].Value:=curVal;
    Sh.Cells[Row,6].Font.Size:=FontSize;
    inc(Row);

    Sh.Cells[Row,1].Value:='Подоходный налог:';
    Sh.Cells[Row,1].Font.Size:=FontSize;
    Sh.Cells[Row,6].Value:=curVal;
    Sh.Cells[Row,6].Font.Size:=FontSize;
    inc(Row);

    Sh.Cells[Row,1].Value:='Hеоблагаемая сумма:';
    Sh.Cells[Row,1].Font.Size:=FontSize;
    Sh.Cells[Row,6].Value:=curVal;
    Sh.Cells[Row,6].Font.Size:=FontSize;
    inc(Row);

    Sh.Cells[Row,1].Value:='Районый+северный облаг.:';
    Sh.Cells[Row,1].Font.Size:=FontSize;
    Sh.Cells[Row,6].Value:=curVal;
    Sh.Cells[Row,6].Font.Size:=FontSize;
    inc(Row);

    Sh.Cells[Row,1].Value:='Hалог район+сев:';
    Sh.Cells[Row,1].Font.Size:=FontSize;
    Sh.Cells[Row,6].Value:=curVal;
    Sh.Cells[Row,6].Font.Size:=FontSize;

    inc(Row);
    Sh.Rows[Row].RowHeight:=3;
    Range:=Sh.Range[Sh.Cells[Row,1],Sh.Cells[Row,6]];
    Range.Borders[xlEdgeBottom].LineStyle:=xlDash;
    inc(Row);
    Sh.Rows[Row].RowHeight:=3;

  end;

  procedure CopyRange(StartY,FinishY,StartX,FinishX,ToY,ToX: Integer);
  var
    RangeFrom: OleVariant;
    RangeTo: OleVariant;
  begin
    RangeFrom:=Sh.Range[Sh.Cells[StartY,StartX],Sh.Cells[FinishY,FinishX]];
    RangeTo:=Sh.Cells[ToY,ToX];
    RangeFrom.Copy(RangeTo);
    RangeTo.Value:='Расчетный лист за: '+fmParent.edPeriod.Text;
  end;

var
  Range: OleVariant;
  sqls: string;
  RecCount: Integer;
  i: Integer;
  CurEmpPlantId: Integer;
  CurFlag: Integer;
  CurY: Integer;
  TCPB: TCreateProgressBar;
  TSPBS: TSetProgressBarStatus;
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

    _SetSplashStatus(ConstReportExecute);

    TCPB.Min:=1;
    TCPB.Max:=RecCount;
    TCPB.Hint:='';
    TCPB.Color:=clRed;
    PBHandle:=_CreateProgressBar(@TCPB);

    if not CreateReport then exit;
    Wb:=Excel.Workbooks.Add;
    Sh:=Wb.Sheets.Item[1];
//    Sh.Name:=fmParent.GetWorkBookName;
    Sh.PageSetup.Orientation:=xlPortrait;

    summAdd:=0;
    summDel:=0;
    Row:=1;
    CurY:=Row;
    i:=0;
    CurEmpPlantId:=0;
    CurFlag:=0;
    qr:=fmParent.Mainqr;
    qr.First;
    while not qr.EOF do begin
      if Terminated then exit;
      if CurEmpPlantId<>qr.FieldByName('empplant_id').AsInteger then begin
        if i<>0 then begin
         CreateSumm(CurFlag);
         CreateSummAll;
         CreateEmptyRow;
         CopyRange(CurY,Row,1,6,CurY,9);
         CurY:=Row;
        end;
        summAdd:=0;
        summDel:=0;
        CalculateSumm(qr.FieldByName('flag').AsInteger);
        CreateHeader;
        CurEmpPlantId:=qr.FieldByName('empplant_id').AsInteger;
        CurFlag:=0;
        CreateRows;
      end else begin
        if CurFlag<>qr.FieldByName('flag').AsInteger then begin
          CreateSumm(CurFlag);
          CalculateSumm(qr.FieldByName('flag').AsInteger);
          CreateColumn(true);
          CurFlag:=qr.FieldByName('flag').AsInteger;
          CreateRows;
        end else begin
          CalculateSumm(qr.FieldByName('flag').AsInteger);
          CreateRows;
        end;
      end;
      inc(i);
      _SetSplashStatus(PChar('Расчетный лист: '+qr.FieldByName('fio').AsString));

      TSPBS.Progress:=i;
      TSPBS.Hint:='';
      _SetProgressBarStatus(PBHandle,@TSPBS);

      qr.Next;
    end;
    if not qr.isEmpty then begin
      CreateSumm(CurFlag);
      CreateSummAll;
      CopyRange(CurY,Row,1,6,CurY,9);

      Range:=Sh.Columns[2];
      Range.Columns.AutoFit;
      Range:=Sh.Columns[3];
      Range.Columns.AutoFit;
      Range:=Sh.Columns[4];
      Range.Columns.AutoFit;
      Range:=Sh.Columns[5];
      Range.Columns.AutoFit;
      Range:=Sh.Columns[6];
      Range.Columns.AutoFit;

      Range:=Sh.Columns[7];
      Range.ColumnWidth:=0.5;
      Range.Borders[xlEdgeRight].LineStyle:=xlDash;
      Range:=Sh.Columns[8];
      Range.ColumnWidth:=0.5;

      Sh.Columns[9].ColumnWidth:=Sh.Columns[1].ColumnWidth;
      Sh.Columns[10].ColumnWidth:=Sh.Columns[2].ColumnWidth;
      Sh.Columns[11].ColumnWidth:=Sh.Columns[3].ColumnWidth;
      Sh.Columns[12].ColumnWidth:=Sh.Columns[4].ColumnWidth;
      Sh.Columns[13].ColumnWidth:=Sh.Columns[5].ColumnWidth;
      Sh.Columns[14].ColumnWidth:=Sh.Columns[6].ColumnWidth;
    end;

   finally
    if not VarIsEmpty(Excel) then begin
     Excel.ActiveWindow.WindowState:=xlMaximized;
     Excel.Visible:=true;
     Excel.WindowState:=xlMaximized;
    end;
    DoTerminate;
   end;
  finally
   CoUninitialize;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;


end.
