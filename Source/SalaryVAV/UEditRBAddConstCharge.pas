unit UEditRBAddConstCharge;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase,
  ComCtrls, IB, Mask, ToolEdit, CurrEdit;

type
  TfmEditRBAddConstCharge = class(TfmEditRB)
    lbCharge: TLabel;
    lbSumma: TLabel;
    edCharge: TEdit;
    bibCharge: TBitBtn;
    lbPercent: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    dtpStartDate: TDateTimePicker;
    dtpEndDate: TDateTimePicker;
    cedPercent: TCurrencyEdit;
    cedSumma: TCurrencyEdit;
    procedure FormCreate(Sender: TObject);
    procedure edConnectionTypeChange(Sender: TObject);

    procedure edChargeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure bibChargeClick(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;

  public
    constcharge_id: Integer;
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
  fmEditRBAddConstCharge: TfmEditRBAddConstCharge;

implementation

uses USalaryVAVCode, USalaryVAVData, UMainUnited, UOTSalary, UTreeBuilding,
  UEditRBAddCharge;

{$R *.DFM}

procedure TfmEditRBAddConstCharge.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBAddConstCharge.AddToRBooks: Boolean;
var
  P: PInfoConnectUser;
  qr: TIBQuery;
  sqls: string;
  id: string;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try


  getMem(P,sizeof(TInfoConnectUser));
  try
   ZeroMemory(P,sizeof(TInfoConnectUser));
   _GetInfoConnectUser(P);
   creatoremp_id:=P.Emp_id;

  finally
    FreeMem(P,sizeof(TInfoConnectUser));
   end;


    id:=inttostr(GetGenId(IBDB,tbconstcharge,1));
    qr.Database:=IBDB;
    qr.Transaction:=ibtran;
    qr.Transaction.Active:=true;
    sqls:='Insert into '+tbconstcharge+
          ' (constcharge_id,empplant_id,Charge_id,startdate, enddate,'+
          'summa,percent,itemcreatedate,creatoremp_id,itemmodifydate,modifycatoremp_id) values '+
          ' ('+id+','+
//Место работы
                              IntToStr(empplant_id)+','+
//Вид начисления
          GetStrFromCondition(Trim(edCharge.text)<>'',
                              inttostr(Charge_id),
                              'null')+',';
//Дата начала
                                if (dtpStartDate.Checked) then
                                begin
                                  sqls:=sqls + ''''+DateToStr(dtpStartDate.date)+''','
                                  end
                                  else
                                  sqls:=sqls + 'null,';
//Дата конца
                                if (dtpEndDate.Checked) then
                                begin
                                  sqls:=sqls + ''''+DateToStr(dtpEndDate.date)+''','
                                  end
                                  else
                                  sqls:=sqls + 'null,';
//Сумма
          if (cedSumma.Value=0) then
          sqls:=sqls + 'null,'
          else
          sqls:=sqls + QuotedStr(ChangeChar(FloatToStr(cedSumma.Value),',','.'))+',';
//Процент
          if (cedPercent.Value=0) then
          sqls:=sqls + 'null,'
          else
          sqls:=sqls + QuotedStr(ChangeChar(FloatToStr(cedPercent.Value),',','.'))+',';
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

procedure TfmEditRBAddConstCharge.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBAddConstCharge.UpdateRBooks: Boolean;
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
//
//


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

procedure TfmEditRBAddConstCharge.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end;
  ModalResult:=mrOk;
end;

function TfmEditRBAddConstCharge.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edCharge.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbCharge.Caption]));
    bibCharge.SetFocus;
    Result:=false;
    exit;
  end;
end;


procedure TfmEditRBAddConstCharge.FormCreate(Sender: TObject);
var
  qr: TIBQuery;
//  P: PCalcPeriodParams;
begin
  inherited;
  qr:=TIBQuery.Create(nil);
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

    qr.Database:=IBDB;
    qr.Transaction:=ibtran;
    qr.Transaction.Active:=true;
  dtpStartDate.Checked:=true;
 dtpStartDate.DateTime:=fmOTSalary.qrEmpPlant.fieldbyName('datestart').AsDateTime;
 bibCharge.SetFocus;
 end;

procedure TfmEditRBAddConstCharge.edConnectionTypeChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBAddConstCharge.edChargeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    edCharge.Text:='';
    ChangeFlag:=true;
    Charge_id:=0;
  end;
end;

procedure TfmEditRBAddConstCharge.bibChargeClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
algorithm_id:=0;
   FillChar(TPRBI,SizeOf(TPRBI),0);
   TPRBI.Visual.TypeView:=tvibvModal;
   TPRBI.Locate.KeyFields:='charge_id';
   TPRBI.Locate.KeyValues:=charge_id;
   TPRBI.Locate.Options:=[loCaseInsensitive];
   if _ViewInterfaceFromName(NameCharge,@TPRBI) then begin
      ChangeFlag:=true;
      charge_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'charge_id');
      edCharge.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
      algorithm_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'algorithm_id');
   end;
if (algorithm_id<>0) then
        begin
         try
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
         except
           {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
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
end;

end.
