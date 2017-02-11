unit UEditRBAddCharge;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase,
  ComCtrls, IB, Mask, ToolEdit, CurrEdit;

type
  TfmEditRBAddCharge = class(TfmEditRB)
    lbTabelCol: TLabel;
    lbCalcPeriod: TLabel;
    edCalcPeriod: TEdit;
    bibCalcperiod: TBitBtn;
    lbCharge: TLabel;
    edTabelCol: TEdit;
    bibTabelCol: TBitBtn;
    lbSumma: TLabel;
    edCharge: TEdit;
    bibCharge: TBitBtn;
    lbPercent: TLabel;
    lbHours: TLabel;
    lbDays: TLabel;
    cedPercent: TCurrencyEdit;
    cedHours: TCurrencyEdit;
    cedDays: TCurrencyEdit;
    cedSumma: TCurrencyEdit;
    procedure edhousenumChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edConnectionTypeChange(Sender: TObject);
    procedure dtpBirthdateChange(Sender: TObject);

    procedure edStreetChange(Sender: TObject);
    procedure edhousenumKeyPress(Sender: TObject; var Key: Char);
    procedure bibCalcperiodClick(Sender: TObject);


procedure edCalcPeriodKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);

    procedure edChargeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edTabelColKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure bibChargeClick(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;

  public
    ChargeFlag: Integer;
    CalcPeriod_id: Integer;
    correctperiod_id: Integer;
    empplant_id: Integer;
    Charge_id: Integer;
    percent:Double;
    hours:Double;
    days:Double;
    summa:Double;
    itemcreatedate:Tdate;
    creatoremp_id : Integer;
    itemmodifydate:Tdate;
    modificatoremp_id: Integer;
    algorithm_id: Integer;
    typebaseamount: Integer;
           typepercent: Integer;
           typemultiply: Integer;
           typefactorworktime: Integer;

    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBAddCharge: TfmEditRBAddCharge;

implementation

uses USalaryVAVCode, USalaryVAVData, UMainUnited, UOTSalary, UTreeBuilding, StSalaryKit;

{$R *.DFM}

procedure TfmEditRBAddCharge.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBAddCharge.AddToRBooks: Boolean;
var
  P: PInfoConnectUser;
  qr: TIBQuery;
  sqls: string;
  id: string;
begin
 Result:=false;

  getMem(P,sizeof(TInfoConnectUser));
  try
   ZeroMemory(P,sizeof(TInfoConnectUser));
   _GetInfoConnectUser(P);
   creatoremp_id:=P.Emp_id;

  finally
    FreeMem(P,sizeof(TInfoConnectUser));
   end;

 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try

    id:=inttostr(GetGenId(IBDB,tbSalary,1));
    qr.Database:=IBDB;
    qr.Transaction:=ibtran;
    qr.Transaction.Active:=true;
    sqls:='Insert into '+tbsalary+
          ' (salary_id,CalcPeriod_id,correctperiod_id,empplant_id,Charge_id,percent,'+
          'hours,days,basesumm,itemcreatedate,creatoremp_id,itemmodifydate,modifycatoremp_id) values '+
          ' ('+id+','+
//Текущий период
                              inttostr(CalcPeriod_id)+',';
//Корректируемый период
                if (CalcPeriod_id=correctperiod_id) then
                        begin
                        sqls:=sqls+'0'+',';
                        end
                else
                        begin
          sqls:=sqls+GetStrFromCondition(Trim(edCalcPeriod.text)<>'',
                              inttostr(correctperiod_id),
                              'null')+',';
                        end;
//Место работы
                        sqls:=sqls+IntToStr(empplant_id)+','+
//Вид начисления
          GetStrFromCondition(Trim(edCharge.text)<>'',
                              Floattostr(Charge_id),
                              'null')+',';
//Процент
          if (cedPercent.Value=0) then
          sqls:=sqls + 'null,'
          else
          sqls:=sqls + QuotedStr(ChangeChar(FloatToStr(cedPercent.Value),',','.'))+',';
//Часы
          if (cedHours.Value=0) then
          sqls:=sqls + 'null,'
          else
          sqls:=sqls + QuotedStr(ChangeChar(FloatToStr(cedHours.Value),',','.'))+',';
//Дни
          if (cedDays.Value=0) then
          sqls:=sqls + 'null,'
          else
          sqls:=sqls + QuotedStr(ChangeChar(FloatToStr(cedDays.Value),',','.'))+',';
//Сумма
          if (cedSumma.Value=0) then
          sqls:=sqls + 'null,'
          else
          sqls:=sqls + QuotedStr(ChangeChar(FloatToStr(cedSumma.Value),',','.'))+',';

//Дата создания
          sqls:=sqls + ''''+DateToStr(Now)+''','+
//Создатель
          IntToStr(creatoremp_id)+','+
//          inttostr(emp_id)+','+
//Дата модификации
          ''''+DateToStr(Now)+''','+
//Модификатор
          IntToStr(creatoremp_id)+
          ')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

//    fmRBEmp.ActiveEmpStreet(false);
//    fmRBEmp.qrEmpStreet.Locate('empstreet_id',id,[LocaseInsensitive]);
    Result:=true;
  finally
    qr.Free;
    Screen.Cursor:=crDefault;
  end;
 except
  on E: EIBInterBaseError do begin
    TempStr:=TranslateIBError(E.Message);
    ShowError(Handle,TempStr);
    Assert(false,TempStr);
  end;
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmEditRBAddCharge.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBAddCharge.UpdateRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id: string;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try

    id:=fmOTSalary.qrChargeOn.FieldByName('Salary_id').AsString;
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbSalary+
          'CalcPeriod_id='+inttostr(CalcPeriod_id)+
          ' correctperiod_id=';
                if (CalcPeriod_id=correctperiod_id) then
                        begin
                        sqls:=sqls+'0'+',';
                        end
                else
                        begin
          sqls:=sqls+GetStrFromCondition(Trim(edCalcPeriod.text)<>'',
                              inttostr(correctperiod_id),
                              'null');
                        end;
          sqls:=sqls+', empplant_id='+IntToStr(empplant_id)+','+
          ', Charge_id=' +
          GetStrFromCondition(Trim(edCharge.text)<>'',
                              Floattostr(Charge_id),
                              'null')+','+
          ', percent='+ FloatToStr(cedPercent.Value)+','+
          ', hours=' + FloatToStr(cedHours.Value)+','+
          ', days=' + FloatToStr(cedDays.Value)+','+
          ', basesumm=' + FloatToStr(cedSumma.Value)+','+
          ', itemmodifydate=' + ''''+DateToStr(Now)+''','+
          ', modifycatoremp_id='+ IntToStr(creatoremp_id)+
          ' where salary_id='+id;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    fmOTSalary.ActiveEmpPlantChargeOn(false);
    fmOTSalary.qrChargeOn.Locate('salary_id',id,[LocaseInsensitive]);

    Result:=true;
  finally
    qr.Free;
    Screen.Cursor:=crDefault;
  end;
 except
  on E: EIBInterBaseError do begin
    TempStr:=TranslateIBError(E.Message);
    ShowError(Handle,TempStr);
    Assert(false,TempStr);
  end;
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmEditRBAddCharge.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end;
  ModalResult:=mrOk;
end;

function TfmEditRBAddCharge.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edCalcPeriod.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbCalcPeriod.Caption]));
    bibCalcperiod.SetFocus;
    Result:=false;
    exit;
  end;
{  if (trim(edTown.Text)='')and(trim(edPlaceMent.Text)='') then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbTown.Caption]));
    bibTown.SetFocus;
    Result:=false;
    exit;
  end;
  if (trim(edTown.Text)<>'')and(trim(edPlaceMent.Text)<>'') then begin
    ShowError(Handle,Format(ConstFieldEmpty,[lbPlaceMent.Caption]));
    bibPlaceMent.SetFocus;
    Result:=false;
    exit;
  end;

{  if trim(edCharge.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbCharge.Caption]));
    bibCharge.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edState.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbState.Caption]));
    bibState.SetFocus;
    Result:=false;
    exit;
  end;}
{  if trim(edStreet.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbStreet.Caption]));
    bibStreet.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edTypeLive.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbTypeLive.Caption]));
    bibTypeLive.SetFocus;
    Result:=false;
    exit;
  end;}

end;

procedure TfmEditRBAddCharge.edhousenumChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBAddCharge.FormCreate(Sender: TObject);
var
  qr: TIBQuery;
  TPRBI: TParamRBookInterface;
begin
  inherited;
  qr:=TIBQuery.Create(nil);
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

    qr.Database:=IBDB;
    qr.Transaction:=ibtran;
    qr.Transaction.Active:=true;

  calcperiod_id:=GetIDCurCalcPeriod;

   FillChar(TPRBI,SizeOf(TPRBI),0);
   TPRBI.Visual.TypeView:=tviOnlyData;
   TPRBI.Locate.KeyFields:='calcperiod_id';
   TPRBI.Locate.KeyValues:=calcperiod_id;
   TPRBI.Locate.Options:=[loCaseInsensitive];
   if _ViewInterfaceFromName(NameCalcPeriod,@TPRBI) then begin
      calcperiod_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'calcperiod_id');
      correctperiod_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'calcperiod_id');
      edCalcPeriod.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
   end;

  if (fmOTSalary.PC2.ActivePageIndex=0) then
        begin
         fmEditRBAddCharge.Caption:='Выберите начисление';
         ChargeFlag:=0;
        end;
  if (fmOTSalary.PC2.ActivePageIndex=1) then
        begin
         fmEditRBAddCharge.Caption:='Выберите удержание';
         ChargeFlag:=1;
        end;
//  if (fmOTSalary.PC2.ActivePageIndex=2) then  fmEditRBAddCharge.Caption:='Выберите начисление'


 bibCharge.SetFocus;

{  edCalcPeriod.MaxLength:=DomainNameLength;
  edstate.MaxLength:=DomainNameLength;
  edtown.MaxLength:=DomainNameLength;
  edplacement.MaxLength:=DomainNameLength;
  edStreet.MaxLength:=DomainNameLength;

  edhousenum.MaxLength:=DomainSmallNameLength;
  edbuildnum.MaxLength:=DomainSmallNameLength;
  edflatnum.MaxLength:=DomainSmallNameLength;

  edTypeLive.MaxLength:=DomainNameLength;
 }
 end;

procedure TfmEditRBAddCharge.edConnectionTypeChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBAddCharge.dtpBirthdateChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;


procedure TfmEditRBAddCharge.edStreetChange(Sender: TObject);
begin
  ChangeFlag:=true;

end;

procedure TfmEditRBAddCharge.edhousenumKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (not (Key in ['0'..'9']))and((Integer(Key)<>VK_Back)) then Key:=#0;
end;


procedure TfmEditRBAddCharge.bibCalcperiodClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
   FillChar(TPRBI,SizeOf(TPRBI),0);
   TPRBI.Visual.TypeView:=tvibvModal;
   TPRBI.Locate.KeyFields:='calcperiod_id';
   TPRBI.Locate.KeyValues:=correctperiod_id;
   TPRBI.Locate.Options:=[loCaseInsensitive];
   if _ViewInterfaceFromName(NameCalcPeriod,@TPRBI) then begin
    ChangeFlag:=true;
      correctperiod_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'calcperiod_id');
      edCalcPeriod.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
   end;
end;

procedure TfmEditRBAddCharge.edCalcPeriodKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    edCalcPeriod.Text:='';
    ChangeFlag:=true;
    CalcPeriod_id:=0;
  end;
end;

procedure TfmEditRBAddCharge.edTabelColKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    edTabelCol.Text:='';
    ChangeFlag:=true;
//    TabelCol_id:=0;
  end;
end;


procedure TfmEditRBAddCharge.edChargeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    edCharge.Text:='';
    ChangeFlag:=true;
    Charge_id:=0;
  end;
end;

procedure TfmEditRBAddCharge.bibChargeClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
algorithm_id:=0;
   FillChar(TPRBI,SizeOf(TPRBI),0);
   TPRBI.Visual.TypeView:=tvibvModal;
   TPRBI.Locate.KeyFields:='charge_id';
   TPRBI.Locate.KeyValues:=charge_id;
   TPRBI.Locate.Options:=[loCaseInsensitive];
   if _ViewInterfaceFromName(NameRbkCharge,@TPRBI) then begin
     ChangeFlag:=true;
     charge_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'charge_id');
     edCharge.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
     algorithm_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'algorithm_id');
   end;
if (algorithm_id<>0) then
        begin
           FillChar(TPRBI,SizeOf(TPRBI),0);
           TPRBI.Visual.TypeView:=tviOnlyData;
           TPRBI.Locate.KeyFields:='algorithm_id';
           TPRBI.Locate.KeyValues:=algorithm_id;
           TPRBI.Locate.Options:=[loCaseInsensitive];
           if _ViewInterfaceFromName(NameAlgorithm,@TPRBI) then begin
                   typebaseamount:=GetFirstValueFromParamRBookInterface(@TPRBI,'typebaseamount');
                   typepercent:=GetFirstValueFromParamRBookInterface(@TPRBI,'typepercent');
                   typemultiply:=GetFirstValueFromParamRBookInterface(@TPRBI,'typemultiply');
                   typefactorworktime:=GetFirstValueFromParamRBookInterface(@TPRBI,'typefactorworktime');
           end;
        end;
//Ввод суммы вручную
      if (typebaseamount=0) then begin
          cedSumma.Visible:=true;
          cedSumma.Enabled:=true;
          lbSumma.Visible:=true;
      end
      else
      begin
          cedSumma.Visible:=false;
          cedSumma.Enabled:=false;
          lbSumma.Visible:=false;
      end;
//Ввод процента вручную
      if (typepercent=2) then begin
          cedPercent.Visible:=true;
          cedPercent.Enabled:=true;
          lbPercent.Visible:=true;
      end
      else
      begin
          cedPercent.Visible:=false;
          cedPercent.Enabled:=false;
          lbPercent.Visible:=false;
      end;
//Ввод процента вручную
      if (typemultiply=3) then begin
          edTabelCol.Visible:=true;
          edTabelCol.Enabled:=true;
          lbTabelCol.Visible:=true;
      end
      else
      begin
          edTabelCol.Visible:=false;
          edTabelCol.Enabled:=false;
          lbTabelCol.Visible:=false;
      end;

end;

end.
