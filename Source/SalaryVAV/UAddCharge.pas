unit UAddCharge;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase,
  ComCtrls, IB;

type
  TfmEditRBCharge = class(TfmEditRB)
    lbhousenum: TLabel;
    edhousenum: TEdit;
    lbbuildnum: TLabel;
    edbuildnum: TEdit;
    lbflatnum: TLabel;
    edflatnum: TEdit;
    lbStreet: TLabel;
    edStreet: TEdit;
    bibStreet: TBitBtn;
    lbTypeLive: TLabel;
    edTypeLive: TEdit;
    bibTypeLive: TBitBtn;
    lbCalcPeriod: TLabel;
    edCalcPeriod: TEdit;
    bibCalcperiod: TBitBtn;
    lbCharge: TLabel;
    edCharge: TEdit;
    bibCharge: TBitBtn;
    lbstate: TLabel;
    edstate: TEdit;
    bibstate: TBitBtn;
    lbTown: TLabel;
    edtown: TEdit;
    bibtown: TBitBtn;
    lbplacement: TLabel;
    edplacement: TEdit;
    bibplacement: TBitBtn;
    procedure edhousenumChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edConnectionTypeChange(Sender: TObject);
    procedure dtpBirthdateChange(Sender: TObject);
    procedure bibStreetClick(Sender: TObject);
    procedure edStreetChange(Sender: TObject);
    procedure edhousenumKeyPress(Sender: TObject; var Key: Char);
    procedure bibTypeLiveClick(Sender: TObject);
    procedure bibCalcperiodClick(Sender: TObject);
    procedure bibChargeClick(Sender: TObject);
    procedure bibstateClick(Sender: TObject);
    procedure bibtownClick(Sender: TObject);
    procedure bibplacementClick(Sender: TObject);
    procedure edtownKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edplacementKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edstateKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edChargeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edStreetKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
    function GetWhereStr(TypeEntry: Integer): string;
  public
    emp_id: Integer;
    country_id: Integer;
    Charge_id: Integer;
    state_id: Integer;
    town_id: Integer;
    placement_id: Integer;
    street_id: Integer;
    Chargecode: string;
    statecode: string;
    towncode: string;
    placementcode: string;
    streetcode: string;
    oldstreet_id: Integer;
    typelive_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBCharge: TfmEditRBCharge;

implementation

uses USalaryVAVCode, USalaryVAVData, UMainUnited, UOTSalary;

{$R *.DFM}

procedure TfmEditRBCharge.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBCharge.AddToRBooks: Boolean;
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

    id:=inttostr(GetGenId(IBDB,tbEmpStreet,1));
    qr.Database:=IBDB;
    qr.Transaction:=ibtran;
    qr.Transaction.Active:=true;
    sqls:='Insert into '+tbEmpStreet+
          ' (empstreet_id,country_id,Charge_id,state_id,town_id,placement_id,'+
          'street_id,emp_id,typelive_id,housenum,buildnum,flatnum) values '+
          ' ('+
          id+','+
          inttostr(country_id)+','+
          GetStrFromCondition(Trim(edCharge.text)<>'',
                              inttostr(Charge_id),
                              'null')+','+
          GetStrFromCondition(Trim(edState.text)<>'',
                              inttostr(state_id),
                              'null')+','+
          GetStrFromCondition(Trim(edTown.text)<>'',
                              inttostr(town_id),
                              'null')+','+
          GetStrFromCondition(Trim(edPlaceMent.text)<>'',
                              inttostr(placement_id),
                              'null')+','+
          GetStrFromCondition(Trim(edStreet.text)<>'',
                              inttostr(street_id),
                              'null')+','+
          inttostr(emp_id)+','+
          inttostr(typelive_id)+','+
          QuotedStr(Trim(edhousenum.Text))+','+
          QuotedStr(Trim(edbuildnum.Text))+','+
          QuotedStr(Trim(edflatnum.Text))+
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

procedure TfmEditRBCharge.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBCharge.UpdateRBooks: Boolean;
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

    id:=fmRBEmp.qrEmpStreet.FieldByName('empstreet_id').AsString;
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbEmpStreet+
          ' set emp_id='+inttostr(emp_id)+
          ', country_id='+inttostr(country_id)+
          ', Charge_id='+GetStrFromCondition(Trim(edCharge.text)<>'',
                                           inttostr(Charge_id),
                                           'null')+
          ', state_id='+GetStrFromCondition(Trim(edState.text)<>'',
                                           inttostr(state_id),
                                           'null')+
          ', town_id='+GetStrFromCondition(Trim(edTown.text)<>'',
                                           inttostr(town_id),
                                           'null')+
          ', placement_id='+GetStrFromCondition(Trim(edPlaceMent.text)<>'',
                                                inttostr(placement_id),
                                                'null')+
          ', street_id='+GetStrFromCondition(Trim(edStreet.text)<>'',
                                             inttostr(street_id),
                                             'null')+
          ', typelive_id='+inttostr(typelive_id)+
          ', housenum='+QuotedStr(Trim(edhousenum.Text))+
          ', buildnum='+QuotedStr(Trim(edbuildnum.Text))+
          ', flatnum='+QuotedStr(Trim(edflatnum.Text))+
          ' where empstreet_id='+id;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    fmRBEmp.ActiveEmpStreet(false);
    fmRBEmp.qrEmpStreet.Locate('empstreet_id',id,[LocaseInsensitive]);
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

procedure TfmEditRBCharge.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBCharge.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edCalcPeriod.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbCountry.Caption]));
    bibCalcperiod.SetFocus;
    Result:=false;
    exit;
  end;
  if (trim(edTown.Text)='')and(trim(edPlaceMent.Text)='') then begin
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
 } if trim(edTypeLive.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbTypeLive.Caption]));
    bibTypeLive.SetFocus;
    Result:=false;
    exit;
  end;
  
end;

procedure TfmEditRBCharge.edhousenumChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBCharge.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edCalcPeriod.MaxLength:=DomainNameLength;
  edstate.MaxLength:=DomainNameLength;
  edtown.MaxLength:=DomainNameLength;
  edplacement.MaxLength:=DomainNameLength;
  edStreet.MaxLength:=DomainNameLength;

  edhousenum.MaxLength:=DomainSmallNameLength;
  edbuildnum.MaxLength:=DomainSmallNameLength;
  edflatnum.MaxLength:=DomainSmallNameLength;

  edTypeLive.MaxLength:=DomainNameLength;
  
end;

procedure TfmEditRBCharge.edConnectionTypeChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBCharge.dtpBirthdateChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBCharge.bibStreetClick(Sender: TObject);
var
  P: PStreetParams;
begin
 try
  getMem(P,sizeof(TStreetParams));
  try
   ZeroMemory(P,sizeof(TStreetParams));
   P.Street_id:=Street_id;
   StrCopy(P.wherestr,Pchar(GetWhereStr(Integer(tte_rbksstreet))));
   if _ViewEntryFromMain(tte_rbksstreet,p,true) then begin
     ChangeFlag:=true;
     Street_id:=P.Street_id;
     StreetCode:=P.Code;
     edStreet.Text:=P.StreetName;
   end;
  finally
    FreeMem(P,sizeof(TStreetParams));
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end; 
end;

procedure TfmEditRBCharge.edStreetChange(Sender: TObject);
begin
  ChangeFlag:=true;

end;

procedure TfmEditRBCharge.edhousenumKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (not (Key in ['0'..'9']))and((Integer(Key)<>VK_Back)) then Key:=#0;
end;

procedure TfmEditRBCharge.bibTypeLiveClick(Sender: TObject);
var
  P: PTypeLiveParams;
begin
 try
  getMem(P,sizeof(TTypeLiveParams));
  try
   ZeroMemory(P,sizeof(TTypeLiveParams));
   P.typelive_id:=typelive_id;
   if ViewEntry_(tte_rbkstypelive,p,true) then begin
     ChangeFlag:=true;
     typelive_id:=P.typelive_id;
     edTypeLive.Text:=P.name;
   end;
  finally
    FreeMem(P,sizeof(TTypeLiveParams));
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end; 
end;

procedure TfmEditRBCharge.bibCalcperiodClick(Sender: TObject);
var
  P: PCountryParams;
begin
 try
  getMem(P,sizeof(TCountryParams));
  try
   ZeroMemory(P,sizeof(TCountryParams));
   P.Country_id:=Country_id;
   if _ViewEntryFromMain(tte_calcperiod,p,true) then begin
     ChangeFlag:=true;
     calcperiod_id:=P.calcperiod_id;
     edCalcPeriod.Text:=P.name;
   end;
  finally
    FreeMem(P,sizeof(TCountryParams));
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end; 
end;

procedure TfmEditRBCharge.bibChargeClick(Sender: TObject);
var
  P: PChargeParams;
begin
 try
  getMem(P,sizeof(TChargeParams));
  try
   ZeroMemory(P,sizeof(TChargeParams));
   P.Charge_id:=Charge_id;
   if _ViewEntryFromMain(tte_rbksCharge,p,true) then begin
     ChangeFlag:=true;
     Charge_id:=P.Charge_id;
     ChargeCode:=P.Code;
     edCharge.Text:=P.ChargeName;
   end;
  finally
    FreeMem(P,sizeof(TChargeParams));
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end; 
end;

procedure TfmEditRBCharge.bibstateClick(Sender: TObject);
var
  P: PStateParams;
begin
 try
  getMem(P,sizeof(TStateParams));
  try
   ZeroMemory(P,sizeof(TStateParams));
   P.State_id:=State_id;
   StrCopy(P.wherestr,Pchar(GetWhereStr(Integer(tte_rbksState))));
   if _ViewEntryFromMain(tte_rbksState,p,true) then begin
     ChangeFlag:=true;
     State_id:=P.State_id;
     StateCode:=P.Code;
     edState.Text:=P.StateName;
   end;
  finally
    FreeMem(P,sizeof(TStateParams));
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmEditRBCharge.bibtownClick(Sender: TObject);
var
  P: PTownParams;
begin
 try
  getMem(P,sizeof(TTownParams));
  try
   ZeroMemory(P,sizeof(TTownParams));
   P.Town_id:=Town_id;
   StrCopy(P.wherestr,Pchar(GetWhereStr(Integer(tte_rbksTown))));
   if _ViewEntryFromMain(tte_rbksTown,p,true) then begin
     ChangeFlag:=true;
     Town_id:=P.Town_id;
     TownCode:=P.Code;
     edTown.Text:=P.TownName;
   end;
  finally
    FreeMem(P,sizeof(TTownParams));
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmEditRBCharge.bibplacementClick(Sender: TObject);
var
  P: PPlaceMentParams;
begin
 try
  getMem(P,sizeof(TPlaceMentParams));
  try
   ZeroMemory(P,sizeof(TPlaceMentParams));
   P.PlaceMent_id:=PlaceMent_id;
   StrCopy(P.wherestr,Pchar(GetWhereStr(Integer(tte_rbksplacement))));
   if _ViewEntryFromMain(tte_rbksPlaceMent,p,true) then begin
     ChangeFlag:=true;
     PlaceMent_id:=P.PlaceMent_id;
     PlaceMentCode:=P.Code;
     edPlaceMent.Text:=P.PlaceMentName;
   end;
  finally
    FreeMem(P,sizeof(TPlaceMentParams));
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmEditRBCharge.edtownKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    edtown.Text:='';
    ChangeFlag:=true;
    town_id:=0;
    towncode:='';
  end;
end;

procedure TfmEditRBCharge.edplacementKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    edplacement.Text:='';
    ChangeFlag:=true;
    placement_id:=0;
    placementcode:='';
  end;
end;

procedure TfmEditRBCharge.edstateKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    edstate.Text:='';
    ChangeFlag:=true;
    state_id:=0;
    statecode:='';
  end;
end;

procedure TfmEditRBCharge.edChargeKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    edCharge.Text:='';
    ChangeFlag:=true;
    Charge_id:=0;
    Chargecode:='';
  end;
end;

function TfmEditRBCharge.GetWhereStr(TypeEntry: Integer): string;
var
 tt: TTypeEntry;
begin
  Result:='';
  tt:=TTypeEntry(TypeEntry);
  case tt of
    tte_rbksstate: begin
      Result:=' where code like '+QuotedStr(Copy(ChargeCode,1,2)+'%');
    end;
    tte_rbkstown: begin
      if trim(StateCode)<>'' then
       Result:=' where code like '+QuotedStr(Copy(StateCode,1,5)+'%')
      else if trim(ChargeCode)<>'' then
       Result:=' where code like '+QuotedStr(Copy(ChargeCode,1,2)+'%');
    end;
    tte_rbksplacement: begin
      if trim(StateCode)<>'' then
       Result:=' where code like '+QuotedStr(Copy(StateCode,1,5)+'%')
      else if trim(ChargeCode)<>'' then
       Result:=' where code like '+QuotedStr(Copy(ChargeCode,1,2)+'%');
    end;
    tte_rbksstreet: begin
      if trim(ChargeCode)<>'' then Result:=' where code like '+QuotedStr(Copy(ChargeCode,1,2)+'%');
      if trim(StateCode)<>'' then Result:=' where code like '+QuotedStr(Copy(StateCode,1,5)+'%');
      if Trim(PlaceMentCode)<>'' then Result:=' where code like '+QuotedStr(Copy(PlaceMentCode,1,11)+'%');
      if Trim(TownCode)<>'' then Result:=' where code like '+QuotedStr(Copy(TownCode,1,11)+'%');
    end;
  end;

end;

procedure TfmEditRBCharge.edStreetKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    edstreet.Text:='';
    ChangeFlag:=true;
    street_id:=0;
    streetcode:='';
  end;
end;

end.
