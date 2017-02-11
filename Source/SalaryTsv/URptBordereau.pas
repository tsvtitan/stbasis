unit URptBordereau;

interface
{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URptMain, OleCtnrs, StdCtrls, Buttons, ExtCtrls, Excel97, ComCtrls, IBQuery,
  IBDatabase, Db, IBCustomDataSet;

type
  TfmRptBordereau = class(TfmRptMain)
    grbCase: TGroupBox;
    rbAll: TRadioButton;
    rbEmp: TRadioButton;
    rbDepart: TRadioButton;
    edEmp: TEdit;
    bibEmp: TBitBtn;
    eddepart: TEdit;
    bibDepart: TBitBtn;
    grbThatDo: TGroupBox;
    rbCreateNew: TRadioButton;
    rbSelectExist: TRadioButton;
    cmbBordereau: TComboBox;
    lbSelectExist: TLabel;
    lbPeriod: TLabel;
    lbTypeBordereau: TLabel;
    lbNumBordereau: TLabel;
    edPeriod: TEdit;
    bibPeriod: TBitBtn;
    bibCurPeriod: TBitBtn;
    edTypeBordereau: TEdit;
    bibTypeBordereau: TBitBtn;
    edNumBordereau: TEdit;
    chbSendPayDesk: TCheckBox;
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
    procedure bibTypeBordereauClick(Sender: TObject);
    procedure rbCreateNewClick(Sender: TObject);
    procedure chbSendPayDeskClick(Sender: TObject);
  private
    procedure OnRptTerminate(Sender: TObject);
    function GetRadioCase: Integer;
    procedure SetRadioCase(Index: Integer);
    function CheckFieldsFill: Boolean;
    procedure ClearBordereaus;
    procedure FillBordereaus;
  public
    startdate,enddate: TDateTime;
    CurCalcPeriod_id: Integer;
    new_calcperiod_id: Integer;
    new_typebordereau_id: Integer;
    new_percent: Currency;
    new_periodsback: Integer;
    emp_id: Integer;
    depart_id: Integer;

    procedure LoadFromIni;override;
    procedure SaveToIni;override;
    procedure GenerateReport;override;
    function GetMainSqlString: string;
  end;

var
  fmRptBordereau: TfmRptBordereau;

implementation

uses USalaryTsvCode,URptThread,comobj,UMainUnited,ActiveX,
     USalaryTsvData, DateUtil;

type
  PInfoBordereau=^TInfoBordereau;
  TInfoBordereau=packed record
    calcperiod_id: Integer;
    calcperiodname: string;
    typebordereau_id: Integer;
    typebordereauname: string;
    num: string;
    periodsback: Integer;
    percent: Currency;
  end;

type
  TRptExcelThreadLocal=class(TRptExcelThread)
  private
    PBHandle: LongWord;
  public
    fmParent: TfmRptBordereau;
    procedure Execute;override;
    destructor Destroy;override;
  end;

var
  Rpt: TRptExcelThreadLocal;

{$R *.DFM}

procedure TfmRptBordereau.FormCreate(Sender: TObject);
begin
 inherited;
 try
  Caption:=NameRptBordereau;

  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  CurCalcPeriod_id:=GetCurCalcPeriodID(IBDB);
  bibCurPeriodClick(nil);

  edPeriod.MaxLength:=DomainNameLength;
  edEmp.MaxLength:=DomainNameLength+DomainSmallNameLength+DomainSmallNameLength+2;
  eddepart.MaxLength:=DomainNameLength;
  edTypeBordereau.MaxLength:=DomainNameLength;
  edNumBordereau.MaxLength:=DomainSmallNameLength;

  FillBordereaus;

  LoadFromIni;

  rbCreateNewClick(nil);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRptBordereau.FormDestroy(Sender: TObject);
begin
  inherited;
  ClearBordereaus;
  FreeAndNil(Rpt);
  if FormState=[fsCreatedMDIChild] then
   fmRptBordereau:=nil;
end;

procedure TfmRptBordereau.LoadFromIni;

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

  function SetTypeBordereau: string;
  var
    TPRBI: TParamRBookInterface;
  begin
   Result:='';
   FillChar(TPRBI,SizeOf(TPRBI),0);
   TPRBI.Visual.TypeView:=tviOnlyData;
   TPRBI.Condition.WhereStr:=PChar(' typebordereau_id='+inttostr(new_typebordereau_id)+' ');
   if _ViewInterfaceFromName(NameRbkTypeBordereau,@TPRBI) then begin
     new_typebordereau_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'typebordereau_id');
     new_percent:=GetFirstValueFromParamRBookInterface(@TPRBI,'percent');
     new_periodsback:=GetFirstValueFromParamRBookInterface(@TPRBI,'periodsback');
     edTypeBordereau.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
   end;
  end;

begin
 inherited;
 try
    rbCreateNew.Checked:=ReadParam(ClassName,'CreateNew',rbCreateNew.Checked);
    rbSelectExist.Checked:=ReadParam(ClassName,'SelectExist',rbSelectExist.Checked);

    chbSendPayDesk.Checked:=ReadParam(ClassName,'sendpaydesk',chbSendPayDesk.Checked);
    edNumBordereau.Text:=ReadParam(ClassName,'numbordereau',edNumBordereau.Text);
    new_typebordereau_id:=ReadParam(ClassName,'typebordereau_id',new_typebordereau_id);
    if new_typebordereau_id<>0 then SetTypeBordereau;
    emp_id:=ReadParam(ClassName,'emp_id',emp_id);
    if emp_id<>0 then SetEmpName;
    depart_id:=ReadParam(ClassName,'depart_id',depart_id);
    if depart_id<>0 then SetDepartName;
    SetRadioCase(ReadParam(ClassName,'case',GetRadioCase));


 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRptBordereau.SaveToIni;
begin
 inherited;
 try
    WriteParam(ClassName,'CreateNew',rbCreateNew.Checked);
    WriteParam(ClassName,'SelectExist',rbSelectExist.Checked);
    WriteParam(ClassName,'sendpaydesk',chbSendPayDesk.Checked);
    WriteParam(ClassName,'numbordereau',edNumBordereau.Text);
    WriteParam(ClassName,'typebordereau_id',new_typebordereau_id);
    WriteParam(ClassName,'emp_id',emp_id);
    WriteParam(ClassName,'depart_id',depart_id);
    WriteParam(ClassName,'case',GetRadioCase);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRptBordereau.OnRptTerminate(Sender: TObject);
begin
  FreeAndNil(Rpt);
  bibBreakClick(nil);
end;

procedure TfmRptBordereau.GenerateReport;
begin
  if Rpt<>nil then exit;
  Rpt:=TRptExcelThreadLocal.Create;
  Rpt.fmParent:=Self;
  Rpt.OnTerminate:=OnRptTerminate;
  Rpt.Resume;
end;

procedure TfmRptBordereau.bibBreakClick(Sender: TObject);
begin
  if Rpt<>nil then
    Rpt.Terminate;
  inherited;  
end;

procedure TfmRptBordereau.bibPeriodClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='calcperiod_id';
  TPRBI.Locate.KeyValues:=new_calcperiod_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkCalcPeriod,@TPRBI) then begin
   new_calcperiod_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'calcperiod_id');
   edPeriod.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
   startdate:=GetFirstValueFromParamRBookInterface(@TPRBI,'startdate');
   enddate:=IncMonth(startdate,CalcSalaryPeriodStep)-1;
  end;
end;

procedure TfmRptBordereau.bibEmpClick(Sender: TObject);
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

procedure TfmRptBordereau.bibDepartClick(Sender: TObject);
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

procedure TfmRptBordereau.rbAllClick(Sender: TObject);
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

procedure TfmRptBordereau.bibCurPeriodClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  new_calcperiod_id:=CurCalcperiod_id;
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Locate.KeyFields:='calcperiod_id';
  TPRBI.Locate.KeyValues:=new_calcperiod_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkCalcPeriod,@TPRBI) then begin
   startdate:=GetFirstValueFromParamRBookInterface(@TPRBI,'startdate');
   enddate:=IncMonth(startdate,CalcSalaryPeriodStep)-1;
   new_calcperiod_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'calcperiod_id');
   edPeriod.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

function TfmRptBordereau.GetRadioCase: Integer;
begin
  Result:=-1;
  if rbAll.Checked then Result:=0;
  if rbEmp.Checked then Result:=1;
  if rbDepart.Checked then Result:=2;
end;

procedure TfmRptBordereau.SetRadioCase(Index: Integer);
begin
  case Index of
    0: rbAllClick(rbAll);
    1: rbAllClick(rbEmp);
    2: rbAllClick(rbDepart);
  end;
end;

procedure TfmRptBordereau.bibClearClick(Sender: TObject);
begin
  bibCurPeriodClick(nil);
  new_typebordereau_id:=0;
  edTypeBordereau.Text:='';
  emp_id:=0;
  edEmp.Text:='';
  depart_id:=0;
  eddepart.Text:='';
  rbAllClick(rbAll);
  rbCreateNew.checked:=true;
  rbCreateNewClick(nil);
end;

function TfmRptBordereau.GetMainSqlString: string;

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

  function GetPeriodsBack(lperiodsback: Integer; lcalcperiod_id: string): String;
  var
   sqls: string;
   qrnew: TIBQuery;
   tran: TIBTransaction;
   incr: Integer;
  begin
   Result:=')';
   if lperiodsback=0 then exit;
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
     sqls:='select calcperiod_id from '+tbCalcPeriod+
           ' where calcperiod_id<'+lcalcperiod_id+
           ' order by calcperiod_id desc';
     qrnew.SQL.Add(sqls);
     qrnew.Active:=true;
     qrnew.First;
     incr:=0;
     if not qrnew.isEmpty then Result:=' or (';
     while not qrnew.Eof do begin
       if incr=0 then begin
        Result:=Result+'s.calcperiod_id='+qrnew.FieldByName('calcperiod_id').AsString;
       end else begin
        Result:=Result+' or s.calcperiod_id='+qrnew.FieldByName('calcperiod_id').AsString;
       end;
       qrnew.Next;
       inc(incr);
       if (incr+1)>=lperiodsback then break;
     end;
     if not qrnew.isEmpty then Result:=Result+')) ';
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
  ltypebordereau_id: string;
  lpercent: string;
  lperiodsback: Integer;
  lcalcperiod_id: string;
  P: PInfoBordereau;
begin
  if rbCreateNew.checked then begin
    if new_percent<>0 then
     lpercent:='*'+floattostr(new_percent)+'/100';
    ltypebordereau_id:=inttostr(new_typebordereau_id);
    lperiodsback:=new_periodsback;
    lcalcperiod_id:=inttostr(new_calcperiod_id);

    Result:='select s.empplant_id,e.fname as efname,e.name as ename,e.sname as esname,e.tabnum,'+
            'd.name as departname,d.depart_id,'+
            'Sum(s.summa)'+lpercent+' as summ '+
            'from '+tbSalary+' s '+
            'join '+tbCalcPeriod+' cp on s.calcperiod_id=cp.calcperiod_id '+
            'join '+tbEmpPlant+' ep on s.empplant_id=ep.empplant_id '+
            'join '+tbEmp+' e on ep.emp_id=e.emp_id '+
            'join '+tbDepart+' d on ep.depart_id=d.depart_id '+
            'where (s.calcperiod_id in (select tbcp.calcperiod_id '+
            'from '+tbTypeBordereauCalcPeriod+' tbcp where tbcp.typebordereau_id='+ltypebordereau_id+')'+
            GetPeriodsBack(lperiodsback,lcalcperiod_id);

  end;
  if rbSelectExist.Checked then begin
    if cmbBordereau.ItemIndex<>-1 then begin
      P:=PInfoBordereau(cmbBordereau.Items.Objects[cmbBordereau.ItemIndex]);
      if P.percent<>0 then
       lpercent:='*'+floattostr(P.percent)+'/100';
      ltypebordereau_id:=inttostr(P.typebordereau_id);
//      lperiodsback:=P.periodsback;
      lcalcperiod_id:=inttostr(P.calcperiod_id);

      Result:='select b.empplant_id,e.fname as efname,e.name as ename,e.sname as esname,e.tabnum,'+
              'd.name as departname,d.depart_id,'+
              'b.summforpay as summ '+
              'from '+tbBordereau+' b '+
              'join '+tbCalcPeriod+' cp on b.calcperiod_id=cp.calcperiod_id '+
              'join '+tbEmpPlant+' ep on b.empplant_id=ep.empplant_id '+
              'join '+tbEmp+' e on ep.emp_id=e.emp_id '+
              'join '+tbDepart+' d on ep.depart_id=d.depart_id '+
              'where b.calcperiod_id='+lcalcperiod_id+' and '+
              'b.typebordereau_id='+ltypebordereau_id;

    end;
  end;


  Index:=GetRadioCase;
  case Index of
    0: Result:=Result;
    1: Result:=Result+' and e.emp_id='+inttostr(emp_id);
    2: begin
     Result:=Result+' and (d.depart_id='+inttostr(depart_id)+GetFromTree(depart_id)+') ';
    end;
  end;

  if rbCreateNew.checked then begin
   Result:=Result+' group by s.empplant_id,e.fname,e.name,e.sname,e.tabnum,d.name,'+
                  'd.depart_id '+
                  'order by d.depart_id,e.fname,e.name,e.sname';
  end;
  if rbSelectExist.Checked then begin
   Result:=Result+' order by d.depart_id,e.fname,e.name,e.sname';
  end;

end;

procedure TfmRptBordereau.bibGenClick(Sender: TObject);
begin
  if CheckFieldsFill then
   inherited;
end;

procedure TfmRptBordereau.bibTypeBordereauClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='typebordereau_id';
  TPRBI.Locate.KeyValues:=new_typebordereau_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkTypeBordereau,@TPRBI) then begin
   new_typebordereau_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'typebordereau_id');
   edTypeBordereau.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
   new_percent:=GetFirstValueFromParamRBookInterface(@TPRBI,'percent');
   new_periodsback:=GetFirstValueFromParamRBookInterface(@TPRBI,'periodsback');
  end;
end;

procedure TfmRptBordereau.rbCreateNewClick(Sender: TObject);
begin
  if rbCreateNew.Checked then begin

    lbPeriod.Enabled:=true;
    edPeriod.Enabled:=true;
    bibPeriod.Enabled:=true;
    bibCurPeriod.Enabled:=true;
    lbTypeBordereau.Enabled:=true;
    edTypeBordereau.Enabled:=true;
    bibTypeBordereau.Enabled:=true;
    lbNumBordereau.Enabled:=true;
    edNumBordereau.Enabled:=true;
    edNumBordereau.Color:=clWindow;
    chbSendPayDesk.Enabled:=true;

    lbSelectExist.Enabled:=false;
    cmbBordereau.Enabled:=false;
    cmbBordereau.Color:=clBtnFace;

    chbSendPayDeskClick(nil);
  end;
  if rbSelectExist.Checked then begin

    lbPeriod.Enabled:=false;
    edPeriod.Enabled:=false;
    bibPeriod.Enabled:=false;
    bibCurPeriod.Enabled:=false;
    lbTypeBordereau.Enabled:=false;
    edTypeBordereau.Enabled:=false;
    bibTypeBordereau.Enabled:=false;
    lbNumBordereau.Enabled:=false;
    edNumBordereau.Enabled:=false;
    edNumBordereau.Color:=clBtnFace;
    chbSendPayDesk.Enabled:=false;

    lbSelectExist.Enabled:=true;
    cmbBordereau.Enabled:=true;
    cmbBordereau.Color:=clWindow;

    rbEmp.Enabled:=true;
    rbDepart.Enabled:=true;

  end;
end;


procedure TfmRptBordereau.chbSendPayDeskClick(Sender: TObject);
begin
 if chbSendPayDesk.Checked then begin
  rbAllClick(rbAll);
  rbEmp.Enabled:=false;
  rbDepart.Enabled:=false;
 end else begin
  rbEmp.Enabled:=true;
  rbDepart.Enabled:=true;
 end;
end;

function TfmRptBordereau.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if rbCreateNew.checked then begin
    if trim(edPeriod.Text)='' then begin
     ShowErrorEx(Format(ConstFieldNoEmpty,[lbPeriod.Caption]));
     bibPeriod.SetFocus;
     Result:=false;
     exit;
    end;
    if trim(edTypeBordereau.Text)='' then begin
     ShowErrorEx(Format(ConstFieldNoEmpty,[lbTypeBordereau.Caption]));
     bibTypeBordereau.SetFocus;
     Result:=false;
     exit;
    end;
    if trim(edNumBordereau.Text)='' then begin
     ShowErrorEx(Format(ConstFieldNoEmpty,[lbNumBordereau.Caption]));
     edNumBordereau.SetFocus;
     Result:=false;
     exit;
    end;
  end;

  if rbSelectExist.Checked then begin
    if cmbBordereau.ItemIndex=-1 then begin
     ShowErrorEx(Format(ConstFieldNoEmpty,[lbNumBordereau.Caption]));
     cmbBordereau.SetFocus;
     Result:=false;
     exit;
    end;
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

procedure TfmRptBordereau.ClearBordereaus;
var
  P: PInfoBordereau;
  i: Integer;
begin
  for i:=0 to cmbBordereau.Items.Count-1 do begin
    P:=PInfoBordereau(cmbBordereau.Items.Objects[i]);
    Dispose(P);
  end;
  cmbBordereau.Clear;
end;


procedure TfmRptBordereau.FillBordereaus;
var
  sqls: string;
  qrnew: TIBQuery;
  tran: TIBTransaction;
  P: PInfoBordereau;
  tmps: string;
begin
   try
    Screen.Cursor:=crHourGlass;
    ClearBordereaus;
    qrnew:=TIBQuery.Create(nil);
    tran:=TIBTransaction.Create(nil);
    try
     qrnew.Database:=IBDB;
     tran.AddDatabase(IBDB);
     tran.Params.Text:=DefaultTransactionParamsTwo;
     IBDB.AddTransaction(tran);
     qrnew.Transaction:=tran;
     qrnew.Transaction.Active:=true;
     sqls:='select b.calcperiod_id,b.empplant_id,b.typebordereau_id,'+
           'c.name as calcperiodname,tb.name as typebordereauname,b.num,'+
           'tb.periodsback,tb.percent '+
           'from '+tbBordereau+' b '+
           'join '+tbCalcPeriod+' c on b.calcperiod_id=c.calcperiod_id '+
           'join '+tbTypeBordereau+' tb on b.typebordereau_id=tb.typebordereau_id '+
           'group by b.calcperiod_id,b.empplant_id,b.typebordereau_id,'+
           'c.name,tb.name,b.num,tb.periodsback,tb.percent '+
           'order by c.startdate';
     qrnew.SQL.Add(sqls);
     qrnew.Active:=true;
     qrnew.First;
     while not qrNew.Eof do begin
       new(P);
       P.calcperiod_id:=qrNew.FieldByName('calcperiod_id').AsInteger;
       P.calcperiodname:=qrNew.FieldByName('calcperiodname').AsString;
       P.typebordereau_id:=qrNew.FieldByName('typebordereau_id').AsInteger;
       P.typebordereauname:=qrNew.FieldByName('typebordereauname').AsString;
       P.num:=qrNew.FieldByName('num').AsString;
       P.periodsback:=qrNew.FieldByName('periodsback').AsInteger;
       P.percent:=qrNew.FieldByName('percent').AsCurrency;
       tmps:=P.calcperiodname+' - '+P.typebordereauname+' - '+P.num;
       cmbBordereau.items.AddObject(tmps,TObject(P));
       qrnew.Next;
     end;
    finally
     if cmbBordereau.Items.Count<>0 then
        cmbBordereau.ItemIndex:=0;
     tran.free;
     qrnew.free;
     Screen.Cursor:=crDefault;
    end;
  except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
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
  summCur: Currency;
  summAll: Currency;
const
  FontSize=8;
  FontSizeHeader=10;

  procedure CreateEmptyRow;
  begin
    inc(Row);
  end;

  procedure CreateColumn;
  var
    Range: OleVariant;
  begin
    Range:=Sh.Range[Sh.Cells[Row,1],Sh.Cells[Row,3]];
    Range.Borders.LineStyle:=xlContinuous;
    Range.Borders.Weight:=xlThin;
    Sh.Cells[Row,1].Value:='Фамилия И.О.';
    Sh.Cells[Row,1].Font.Size:=FontSize;
    Sh.Cells[Row,2].Value:='Таб.номер';
    Sh.Cells[Row,2].Font.Size:=FontSize;
    Sh.Cells[Row,3].Value:='Сумма';
    Sh.Cells[Row,3].Font.Size:=FontSize;
    inc(Row);
    Range.HorizontalAlignment:=xlHAlignCenter;
    Range.VerticalAlignment:=xlVAlignCenter;
    Range.Columns.AutoFit;
  end;

  procedure CreateColumnHeader;
  var
    tmps: string;
  begin
    tmps:='Отдел: '+qr.FieldByName('departname').AsString;
    Sh.Cells[Row,1].Value:=tmps;
    Sh.Cells[Row,1].Font.Size:=FontSize;
    inc(Row);
    CreateColumn;
  end;

  procedure CreateRow;
  var
    Range: OleVariant;
  begin
    Range:=Sh.Range[Sh.Cells[Row,1],Sh.Cells[Row,3]];
    Range.Borders.LineStyle:=xlContinuous;
    Range.Borders.Weight:=xlThin;
    Sh.Cells[Row,1].Value:=qr.FieldByname('efname').AsString+' '+
                           qr.FieldByname('ename').AsString+' '+
                           qr.FieldByname('esname').AsString; 
    Sh.Cells[Row,1].Font.Size:=FontSize;
    Sh.Cells[Row,2].Value:=qr.FieldByname('tabnum').AsString;
    Sh.Cells[Row,2].Font.Size:=FontSize;
    Sh.Cells[Row,3].Value:=qr.FieldByname('summ').AsCurrency;
    Sh.Cells[Row,3].Font.Size:=FontSize;
    inc(Row);
  end;

  procedure CreateSumm;
  begin
    Sh.Cells[Row,1].Value:='Всего :';
    Sh.Cells[Row,3].Value:=summCur;
    Sh.Cells[Row,1].Font.Size:=FontSize;
    Sh.Cells[Row,3].Font.Size:=FontSize;
    inc(Row);
  end;

  procedure CreateSummAll;
  begin
    Sh.Cells[Row,1].Value:='Всего по ведомости:';
    Sh.Cells[Row,3].Value:=summAll;
    Sh.Cells[Row,1].Font.Size:=FontSize;
    Sh.Cells[Row,3].Font.Size:=FontSize;
    inc(Row);
  end;

  procedure CreateMainHeader;
  var
    tmps: string;
    lTypeBordereauName: string;
    lNum: string;
    lPeriod: string;
    P: PInfoBordereau;
  begin
    if fmParent.rbCreateNew.Checked then begin
      lTypeBordereauName:=Trim(fmParent.edTypeBordereau.Text);
      LNum:=Trim(fmParent.edNumBordereau.Text);
      lPeriod:=Trim(fmParent.edPeriod.Text);
    end;
    if fmParent.rbSelectExist.Checked then begin
     if fmParent.cmbBordereau.ItemIndex<>-1 then begin
      P:=PInfoBordereau(fmParent.cmbBordereau.Items.Objects[fmParent.cmbBordereau.ItemIndex]);
      lTypeBordereauName:=Trim(P.typebordereauname);
      LNum:=Trim(P.num);
      lPeriod:=Trim(P.calcperiodname);
     end;
    end;

    tmps:=lTypeBordereauName+' '+lNum;
    Sh.Cells[Row,1].Value:=tmps;
    Sh.Cells[Row,1].Font.Size:=FontSizeHeader;
    Sh.Cells[Row,1].Font.Bold:=True;
    inc(Row);

    tmps:='на период: '+lPeriod;
    Sh.Cells[Row,1].Value:=tmps;
    Sh.Cells[Row,1].Font.Size:=FontSize;
    inc(Row);
    CreateEmptyRow;
  end;

  procedure CalculateSumm;
  begin
    summCur:=summCur+qr.FieldByName('summ').AsCurrency;
    summAll:=summAll+summCur;
  end;

  procedure InsertCurrentRecord;
  var
   sqls: string;
   qrnew: TIBQuery;
   tran: TIBTransaction;
  begin
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
     sqls:='Insert into '+tbBordereau+
           ' (typebordereau_id,empplant_id,calcperiod_id,summforpay,num) values ('+
           ' '+inttostr(fmParent.new_typebordereau_id)+
           ','+qr.FieldByName('empplant_id').AsString+
           ','+inttostr(fmParent.new_calcperiod_id)+
           ','+ChangeChar(qr.FieldByName('summ').AsString,',','.')+
           ','+QuotedStr(Trim(fmParent.edNumBordereau.text))+')';
     qrnew.SQL.Add(sqls);
     qrnew.ExecSQL;
     tran.Commit;
    finally
     tran.free;
     qrnew.free;
    end;
   except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
   end;
  end;

var
  Range: OleVariant;
  sqls: string;
  RecCount: Integer;
  i: Integer;
  CurDepartID: Integer;
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
    RecCount:=GetRecordCount(fmParent.Mainqr,true);
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
    Sh.PageSetup.Orientation:=xlPortrait;

    i:=0;
    CurDepartID:=0;
    Row:=1;
    summAll:=0;
    qr:=fmParent.Mainqr;
    qr.First;
    CreateMainHeader;
    while not qr.EOF do begin
      if Terminated then exit;
      if fmParent.chbSendPayDesk.Checked then
        InsertCurrentRecord;
      if CurDepartID<>qr.FieldByName('depart_id').AsInteger then begin
        if i<>0 then begin
         CreateSumm;
         CreateEmptyRow;
        end;
        summCur:=0;
        CalculateSumm;
        CreateColumnHeader;
        CurDepartID:=qr.FieldByName('depart_id').AsInteger;
        CreateRow;
      end else begin
        CalculateSumm;
        CreateRow;
      end;
      inc(i);
      
      TSPBS.Progress:=i;
      TSPBS.Hint:='';
      _SetProgressBarStatus(PBHandle,@TSPBS);

      qr.Next;
    end;
    if not qr.isEmpty then begin
      CreateSumm;
      CreateSummAll;
      Range:=Sh.Columns[1];
      Range.Columns.AutoFit;
      Range:=Sh.Columns[2];
      Range.Columns.AutoFit;
      Range:=Sh.Columns[3];
      Range.Columns.AutoFit;
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
