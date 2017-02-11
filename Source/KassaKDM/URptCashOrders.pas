unit URptCashOrders;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URptMain, Db, IBCustomDataSet, IBQuery, IBDatabase, StdCtrls, Buttons,
  ExtCtrls,Excel97,OleCtnrs;

type
  TfmRptCashOrders = class(TfmRptMain)
    lCO: TLabel;
    eCO: TEdit;
    bCO: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bibBreakClick(Sender: TObject);
    procedure bibCOClick(Sender: TObject);
  private
    procedure OnRptTerminate(Sender: TObject);
  public
    NDS,NP: string;
    doc_id,ico_id,mainbk,emp_id: integer;
    summa_debit,summa_credit,co_date,ondoc_id: string;
    doc_name,account_kassa,account_korac,basis,append,cashier,emp: string;
    procedure LoadFromIni;override;
    procedure SaveToIni;override;
    procedure GenerateReport;override;
  end;

var
  fmRptCashOrders: TfmRptCashOrders;

implementation

uses UKassaKDMCode,URptThread,comobj,UMainUnited,ActiveX,
     UKassaKDMData;

type
  TRptExcelThreadCO=class(TRptExcelThread)
  private
    PBHandle: LongWord;
  public
    fmParent: TfmRptCashOrders;
    procedure Execute;override;
    procedure ExecuteInCO;
    procedure ExecuteOutCO;
    destructor Destroy;override;
  end;

var
  Rpt: TRptExcelThreadCO;

{$R *.DFM}

procedure TfmRptCashOrders.FormCreate(Sender: TObject);
begin
 inherited;
 try
  Caption:=NameRptCashOrders;

  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRptCashOrders.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(Rpt);
  if FormState=[fsCreatedMDIChild] then
   fmRptCashOrders:=nil;
end;

procedure TfmRptCashOrders.LoadFromIni;
begin
 inherited;
 try
    doc_id := ReadParam(ClassName,'doc_id',doc_id);
    doc_name := ReadParam(ClassName,'doc_name',doc_name);
    ico_id := ReadParam(ClassName,'ico_id',ico_id);
    mainbk := ReadParam(ClassName,'mainbk',mainbk);
    summa_debit := ReadParam(ClassName,'summa_debit',summa_debit);
    summa_credit := ReadParam(ClassName,'summa_credit',summa_credit);
    account_kassa := ReadParam(ClassName,'account_kassa',account_kassa);
    account_korac := ReadParam(ClassName,'account_korac',account_korac);
    basis := ReadParam(ClassName,'basis',basis);
    append := ReadParam(ClassName,'append',append);
    cashier := ReadParam(ClassName,'cashier',cashier);
    emp := ReadParam(ClassName,'emp',emp);
    co_date := ReadParam(ClassName,'co_date',co_date);
    eCO.Text := doc_name + '  №'+IntToStr(ico_id);
    emp_id := ReadParam(ClassName,'emp_id',emp_id);
    ondoc_id := ReadParam(ClassName,'ondoc_id',ondoc_id);
    NDS := ReadParam(ClassName,'NDS',NDS);
    NP := ReadParam(ClassName,'NP',NP);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRptCashOrders.SaveToIni;
begin
 inherited;
 try
    WriteParam(ClassName,'doc_id',doc_id);
    WriteParam(ClassName,'doc_name',doc_name);
    WriteParam(ClassName,'ico_id',ico_id);
    WriteParam(ClassName,'mainbk',mainbk);
    WriteParam(ClassName,'summa_debit',summa_debit);
    WriteParam(ClassName,'summa_credit',summa_credit);
    WriteParam(ClassName,'account_kassa',account_kassa);
    WriteParam(ClassName,'account_korac',account_korac);
    WriteParam(ClassName,'basis',basis);
    WriteParam(ClassName,'append',append);
    WriteParam(ClassName,'cashier',cashier);
    WriteParam(ClassName,'emp',emp);
    WriteParam(ClassName,'co_date',co_date);
    WriteParam(ClassName,'emp_id',emp_id);
    WriteParam(ClassName,'ondoc_id',ondoc_id);
    WriteParam(ClassName,'NDS',NDS);
    WriteParam(ClassName,'NP',NP);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRptCashOrders.OnRptTerminate(Sender: TObject);
begin
  FreeAndNil(Rpt);
  bibBreakClick(nil);
end;

procedure TfmRptCashOrders.GenerateReport;
begin
  if Rpt<>nil then exit;
  Rpt:=TRptExcelThreadCO.Create;
  Rpt.fmParent:=Self;
  Rpt.OnTerminate:=OnRptTerminate;
  Rpt.Resume;
end;

procedure TfmRptCashOrders.bibBreakClick(Sender: TObject);
begin
  if Rpt<>nil then
    Rpt.Terminate;
  inherited;
end;

procedure TfmRptCashOrders.bibCOClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='ico_id;dok_id';
  TPRBI.Locate.KeyValues:=VarArrayOf([ico_id,doc_id]);
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkCashOrders,@TPRBI) then begin
   doc_id := GetFirstValueFromParamRBookInterface(@TPRBI,'dok_id');
   ico_id := GetFirstValueFromParamRBookInterface(@TPRBI,'ico_id');
   mainbk := GetFirstValueFromParamRBookInterface(@TPRBI,'co_mainbookkeeper');
   summa_debit := GetFirstValueFromParamRBookInterface(@TPRBI,'co_debit');
   summa_credit := GetFirstValueFromParamRBookInterface(@TPRBI,'co_kredit');
   doc_name := GetFirstValueFromParamRBookInterface(@TPRBI,'dok_name');
   account_kassa := GetFirstValueFromParamRBookInterface(@TPRBI,'pa_groupid');
   account_korac := GetFirstValueFromParamRBookInterface(@TPRBI,'pa_groupid1');
   basis := GetFirstValueFromParamRBookInterface(@TPRBI,'cb_text');
   append := GetFirstValueFromParamRBookInterface(@TPRBI,'ca_text');
   cashier := GetFirstValueFromParamRBookInterface(@TPRBI,'fname');
   emp := GetFirstValueFromParamRBookInterface(@TPRBI,'fname1');
   co_date := GetFirstValueFromParamRBookInterface(@TPRBI,'co_date');
   eCO.Text := doc_name + '  №'+IntToStr(ico_id);
   emp_id := GetFirstValueFromParamRBookInterface(@TPRBI,'co_emp_id');
   ondoc_id := GetFirstValueFromParamRBookInterface(@TPRBI,'co_persondoctype_id');
   NDS := GetFirstValueFromParamRBookInterface(@TPRBI,'co_nds');
   NP := GetFirstValueFromParamRBookInterface(@TPRBI,'co_np');
  end;
end;

destructor TRptExcelThreadCO.Destroy;
begin
  inherited;
  _FreeProgressBar(PBHandle);
end;

procedure TRptExcelThreadCO.ExecuteInCO;
var
  Wb: OleVariant;
  Sh: OleVariant;
  Data: OleVariant;
  Range: OleVariant;
  sqls: string;
  RecCount: Integer;
  Row,Column,i: Integer;
  dx,dy: Integer;
  TCPB: TCreateProgressBar;
  TSPBS: TSetProgressBarStatus;
  str,nds1,np1: string;
  qr: TIBQuery;
begin
 try
  _SetSplashStatus(ConstReportExecute);
  qr := TIBQuery.Create(nil);
  qr.Database := IBDB;
  qr.Transaction := IBT;
  try
   if CoInitialize(nil)<>S_OK then exit;
   try
    if not CreateReport then exit;
    TCPB.Min:=1;
    TCPB.Max:=14;
    TCPB.Hint:='';
    TCPB.Color:=clRed;
    PBHandle:=_CreateProgressBar(@TCPB);
    Wb:=Excel.Workbooks.Open(_GetOptions.DirTemp+'\'+'InCO.xls');
    Sh:=Wb.Sheets.Item[1];
    //формируем название организации;
    sqls := 'select * from '+tbConstex;
    qr.SQL.Clear;
    qr.SQL.Add(sqls);
    qr.Open;
    if qr.Locate('Name','Предприятие',[loCaseInsensitive]) then begin
      sqls := 'select * from '+tbPlant+
              ' where plant_id='+Trim(qr.FieldByName('VALUETABLE').AsString);
      qr.SQL.Clear;
      qr.SQL.Add(sqls);
      qr.Open;
      if not qr.IsEmpty then begin
        Sh.Range[Sh.Cells[7,1],Sh.Cells[7,1]].Value := qr.FieldByName('Fullname').AsString;
        Sh.Range[Sh.Cells[3,12],Sh.Cells[3,12]].Value := qr.FieldByName('smallname').AsString;
        TSPBS.Progress:=1;
        TSPBS.Hint:='';
        _SetProgressBarStatus(PBHandle,@TSPBS);
      end
    end;
   //конец
   Sh.Range[Sh.Cells[12,6],Sh.Cells[12,6]].Value := fmRptCashOrders.ico_id;
   TSPBS.Progress:=2;
   TSPBS.Hint:='';
   _SetProgressBarStatus(PBHandle,@TSPBS);
   Sh.Range[Sh.Cells[12,8],Sh.Cells[12,8]].Value := fmRptCashOrders.co_date;
   TSPBS.Progress:=3;
   TSPBS.Hint:='';
   _SetProgressBarStatus(PBHandle,@TSPBS);
   Sh.Range[Sh.Cells[18,1],Sh.Cells[18,1]].Value := fmRptCashOrders.account_kassa;
   TSPBS.Progress:=4;
   TSPBS.Hint:='';
   _SetProgressBarStatus(PBHandle,@TSPBS);
   Sh.Range[Sh.Cells[18,4],Sh.Cells[18,4]].Value := fmRptCashOrders.account_korac;
   TSPBS.Progress:=5;
   TSPBS.Hint:='';
   _SetProgressBarStatus(PBHandle,@TSPBS);
   //формирование полного имени сотрудника
   sqls := 'select * from '+tbEmp+
           ' where emp_id='+IntToStr(fmRptCashOrders.emp_id);
   qr.SQL.Clear;
   qr.SQL.Add(sqls);
   qr.Open;
   if not qr.IsEmpty then begin
     Sh.Range[Sh.Cells[10,12],Sh.Cells[10,12]].Value := fmRptCashOrders.emp+' '+
     qr.FieldByName('name').AsString+' '+qr.FieldByName('sname').AsString;
     Sh.Range[Sh.Cells[20,3],Sh.Cells[20,3]].Value := fmRptCashOrders.emp+' '+
     qr.FieldByName('name').AsString+' '+qr.FieldByName('sname').AsString;
   end;
   TSPBS.Progress:=7;
   TSPBS.Hint:='';
   _SetProgressBarStatus(PBHandle,@TSPBS);
   //конец
   Sh.Range[Sh.Cells[22,3],Sh.Cells[22,3]].Value := fmRptCashOrders.basis;
   TSPBS.Progress:=8;
   TSPBS.Hint:='';
   _SetProgressBarStatus(PBHandle,@TSPBS);
   Sh.Range[Sh.Cells[12,12],Sh.Cells[12,12]].Value := fmRptCashOrders.append;
   TSPBS.Progress:=9;
   TSPBS.Hint:='';
   _SetProgressBarStatus(PBHandle,@TSPBS);
   //формирование главного бухгалтера
   sqls := 'select * from '+tbEmp+
           ' where emp_id='+IntToStr(fmRptCashOrders.mainbk);
   qr.SQL.Clear;
   qr.SQL.Add(sqls);
   qr.Open;
   if not qr.IsEmpty then begin
     Sh.Range[Sh.Cells[33,7],Sh.Cells[33,7]].Value := qr.FieldByName('fname').AsString;
     Sh.Range[Sh.Cells[33,13],Sh.Cells[33,13]].Value := qr.FieldByName('fname').AsString;
     TSPBS.Progress:=10;
     TSPBS.Hint:='';
     _SetProgressBarStatus(PBHandle,@TSPBS);
   end;
   //конец
   Sh.Range[Sh.Cells[36,7],Sh.Cells[36,7]].Value := fmRptCashOrders.cashier;
   TSPBS.Progress:=11;
   TSPBS.Hint:='';
   _SetProgressBarStatus(PBHandle,@TSPBS);
   Sh.Range[Sh.Cells[36,13],Sh.Cells[36,13]].Value := fmRptCashOrders.cashier;
   TSPBS.Progress:=12;
   TSPBS.Hint:='';
   _SetProgressBarStatus(PBHandle,@TSPBS);
   Sh.Range[Sh.Cells[18,6],Sh.Cells[18,6]].Value := fmRptCashOrders.summa_debit;
   TSPBS.Progress:=13;
   TSPBS.Hint:='';
   _SetProgressBarStatus(PBHandle,@TSPBS);
   //формируем поле "в том числе"
   nds1:='0';
   if fmRptCashOrders.NDS<>'' then nds1:=fmRptCashOrders.NDS;
   np1:='0';
   if fmRptCashOrders.NP<>'' then np1:=fmRptCashOrders.NP;
   Sh.Range[Sh.Cells[29,'C'],Sh.Cells[29,'C']].Value := 'НДС:'+nds1+'  НП:'+np1;
   Sh.Range[Sh.Cells[23,'L'],Sh.Cells[23,'L']].Value := 'НДС:'+nds1+'  НП:'+np1;
   TSPBS.Progress:=14;
   TSPBS.Hint:='';
   _SetProgressBarStatus(PBHandle,@TSPBS);
   //конец
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
   qr.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TRptExcelThreadCO.Execute;
var
  rs: TResourceStream;
begin
  rs:=nil;
  try
    if AnsiUpperCase(fmRptCashOrders.doc_name)='ПРИХОДНЫЙ КАССОВЫЙ ОРДЕР' then begin
      rs:=TResourceStream.Create(HInstance,'RPTINCO','REPORT');
      if not FileExists(_GetOptions.DirTemp+'\'+'InCO.xls') then
        rs.SaveToFile(_GetOptions.DirTemp+'\'+'InCO.xls');
      ExecuteInCO;
    end
    else begin
      rs:=TResourceStream.Create(HInstance,'RPTOUTCO','REPORT');
      if not FileExists(_GetOptions.DirTemp+'\'+'OutCO.xls') then
        rs.SaveToFile(_GetOptions.DirTemp+'\'+'OutCO.xls');
      ExecuteOutCO;
    end;
  finally
    rs.Free;
  end;
end;

procedure TRptExcelThreadCO.ExecuteOutCO;
var
  Wb: OleVariant;
  Sh: OleVariant;
  Data: OleVariant;
  Range: OleVariant;
  sqls: string;
  RecCount: Integer;
  Row,Column,i: Integer;
  dx,dy: Integer;
  TCPB: TCreateProgressBar;
  TSPBS: TSetProgressBarStatus;
  str: string;
  qr: TIBQuery;
  boss_id: integer;
begin
 try
  _SetSplashStatus(ConstReportExecute);
  qr := TIBQuery.Create(nil);
  qr.Database := IBDB;
  qr.Transaction := IBT;
  try
   if CoInitialize(nil)<>S_OK then exit;
   try
    if not CreateReport then exit;
    TCPB.Min:=1;
    TCPB.Max:=17;
    TCPB.Hint:='';
    TCPB.Color:=clRed;
    PBHandle:=_CreateProgressBar(@TCPB);
    Wb:=Excel.Workbooks.Open(_GetOptions.DirTemp+'\'+'OutCO.xls');
    Sh:=Wb.Sheets.Item[1];
    //формируем название организации;
    sqls := 'select * from '+tbConstex;
    qr.SQL.Clear;
    qr.SQL.Add(sqls);
    qr.Open;
    if qr.Locate('NAME','Руководитель',[loCaseInsensitive]) then begin
      boss_id := qr.FieldByName('VALUETABLE').AsInteger;
      Sh.Range[Sh.Cells[33,'AA'],Sh.Cells[33,'AA']].Value := qr.FieldByName('NOTE').AsString;
      TSPBS.Progress:=1;
      TSPBS.Hint:='';
      _SetProgressBarStatus(PBHandle,@TSPBS);
    end;
    if qr.Locate('NAME','Предприятие',[loCaseInsensitive]) then begin
      sqls := 'select * from '+tbPlant+
              ' where plant_id='+Trim(qr.FieldByName('VALUETABLE').AsString);
      qr.SQL.Clear;
      qr.SQL.Add(sqls);
      qr.Open;
      if not qr.IsEmpty then begin
        Sh.Range[Sh.Cells[8,'A'],Sh.Cells[8,'A']].Value := qr.FieldByName('Fullname').AsString;
        TSPBS.Progress:=2;
        TSPBS.Hint:='';
        _SetProgressBarStatus(PBHandle,@TSPBS);
      end
    end;
   //конец
   Sh.Range[Sh.Cells[14,'BG'],Sh.Cells[14,'BG']].Value := fmRptCashOrders.ico_id;
   TSPBS.Progress:=3;
   TSPBS.Hint:='';
   _SetProgressBarStatus(PBHandle,@TSPBS);
   Sh.Range[Sh.Cells[14,'BU'],Sh.Cells[14,'BU']].Value := fmRptCashOrders.co_date;
   TSPBS.Progress:=4;
   TSPBS.Hint:='';
   _SetProgressBarStatus(PBHandle,@TSPBS);
   Sh.Range[Sh.Cells[19,'AM'],Sh.Cells[19,'AM']].Value := fmRptCashOrders.account_kassa;
   TSPBS.Progress:=5;
   TSPBS.Hint:='';
   _SetProgressBarStatus(PBHandle,@TSPBS);
   Sh.Range[Sh.Cells[19,'P'],Sh.Cells[19,'P']].Value := fmRptCashOrders.account_korac;
   TSPBS.Progress:=6;
   TSPBS.Hint:='';
   _SetProgressBarStatus(PBHandle,@TSPBS);
   //формирование полного имени сотрудника
   sqls := 'select * from '+tbEmp+
           ' where emp_id='+IntToStr(fmRptCashOrders.emp_id);
   qr.SQL.Clear;
   qr.SQL.Add(sqls);
   qr.Open;
   if not qr.IsEmpty then
     Sh.Range[Sh.Cells[21,'N'],Sh.Cells[21,'N']].Value := fmRptCashOrders.emp+' '+
     qr.FieldByName('name').AsString+' '+qr.FieldByName('sname').AsString;
   TSPBS.Progress:=7;
   TSPBS.Hint:='';
   _SetProgressBarStatus(PBHandle,@TSPBS);
   //конец
   //формирование руководителя организации
   sqls := 'select * from '+tbEmp+
           ' where emp_id='+IntToStr(boss_id);
   qr.SQL.Clear;
   qr.SQL.Add(sqls);
   qr.Open;
   if not qr.IsEmpty then
     Sh.Range[Sh.Cells[33,'BH'],Sh.Cells[33,'BH']].Value := qr.FieldByName('fname').AsString;
   TSPBS.Progress:=8;
   TSPBS.Hint:='';
   _SetProgressBarStatus(PBHandle,@TSPBS);
   //конец
   Sh.Range[Sh.Cells[23,'N'],Sh.Cells[23,'N']].Value := fmRptCashOrders.basis;
   TSPBS.Progress:=9;
   TSPBS.Hint:='';
   _SetProgressBarStatus(PBHandle,@TSPBS);
   Sh.Range[Sh.Cells[29,'O'],Sh.Cells[29,'O']].Value := fmRptCashOrders.append;
   TSPBS.Progress:=10;
   TSPBS.Hint:='';
   _SetProgressBarStatus(PBHandle,@TSPBS);
   //формирование главного бухгалтера
   sqls := 'select * from '+tbEmp+
           ' where emp_id='+IntToStr(fmRptCashOrders.mainbk);
   qr.SQL.Clear;
   qr.SQL.Add(sqls);
   qr.Open;
   if not qr.IsEmpty then begin
     Sh.Range[Sh.Cells[35,'AM'],Sh.Cells[35,'AM']].Value := qr.FieldByName('fname').AsString;
     TSPBS.Progress:=11;
     TSPBS.Hint:='';
     _SetProgressBarStatus(PBHandle,@TSPBS);
   end;
   //конец
   Sh.Range[Sh.Cells[47,'AN'],Sh.Cells[47,'AN']].Value := fmRptCashOrders.cashier;
   TSPBS.Progress:=12;
   TSPBS.Hint:='';
   _SetProgressBarStatus(PBHandle,@TSPBS);
   Sh.Range[Sh.Cells[41,'C'],Sh.Cells[41,'C']].Value := FormatDateTime('dd',StrToDate(fmRptCashOrders.co_date));;
   TSPBS.Progress:=13;
   TSPBS.Hint:='';
   _SetProgressBarStatus(PBHandle,@TSPBS);
   Sh.Range[Sh.Cells[41,'J'],Sh.Cells[41,'J']].Value := FormatDateTime('mmmm',StrToDate(fmRptCashOrders.co_date));;
   TSPBS.Progress:=14;
   TSPBS.Hint:='';
   _SetProgressBarStatus(PBHandle,@TSPBS);
   Sh.Range[Sh.Cells[41,'AL'],Sh.Cells[41,'AL']].Value := FormatDateTime('yyyy',StrToDate(fmRptCashOrders.co_date));;
   TSPBS.Progress:=15;
   TSPBS.Hint:='';
   _SetProgressBarStatus(PBHandle,@TSPBS);
   Sh.Range[Sh.Cells[19,'AV'],Sh.Cells[19,'AV']].Value := fmRptCashOrders.summa_credit;
   TSPBS.Progress:=16;
   TSPBS.Hint:='';
   _SetProgressBarStatus(PBHandle,@TSPBS);
   //формироваие документа выдачи
   sqls := 'select pdt.smallname as namedoc,epd.serial,epd.num,epd.datewhere,p.smallname from '+tbEmpPersonDoc+' epd,'+tbPlant+' p,'+tbPersonDocType+' pdt'+
           ' where epd.emp_id='+IntToStr(fmRptCashOrders.emp_id)+' and '+
           'epd.persondoctype_id='+fmRptCashOrders.ondoc_id+' and '+
           'epd.persondoctype_id=pdt.persondoctype_id and '+
           'epd.plant_id=p.plant_id ';
   qr.SQL.Clear;
   qr.SQL.Add(sqls);
   qr.Open;
   if not qr.IsEmpty then begin
     Sh.Range[Sh.Cells[43,'E'],Sh.Cells[43,'E']].Value := Trim(qr.FieldByName('namedoc').AsString)+' серия:'+
     Trim(qr.FieldByName('serial').AsString)+' номер:'+Trim(qr.FieldByName('num').AsString);
     Sh.Range[Sh.Cells[45,'A'],Sh.Cells[45,'A']].Value := 'Дата выдачи:'+Trim(qr.FieldByName('datewhere').AsString)+' Выдан:'+Trim(qr.FieldByName('smallname').AsString);
   end;
   TSPBS.Progress:=17;
   TSPBS.Hint:='';
   _SetProgressBarStatus(PBHandle,@TSPBS);
   //конец
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
   qr.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

end.
