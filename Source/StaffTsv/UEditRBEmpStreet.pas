unit UEditRBEmpStreet;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase,
  ComCtrls, IB, URBEmp;

type
  TfmEditRBEmpStreet = class(TfmEditRB)
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
    lbCountry: TLabel;
    edCountry: TEdit;
    bibCountry: TBitBtn;
    lbregion: TLabel;
    edregion: TEdit;
    bibregion: TBitBtn;
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
    procedure bibCountryClick(Sender: TObject);
    procedure bibregionClick(Sender: TObject);
    procedure bibstateClick(Sender: TObject);
    procedure bibtownClick(Sender: TObject);
    procedure bibplacementClick(Sender: TObject);
    procedure edtownKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edplacementKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edstateKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edregionKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edStreetKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
    function GetWhereStr(Index: Integer): string;
  public
    ParentEmpForm: TfmRBEmpMain;
    emp_id: Integer;
    country_id: Integer;
    region_id: Integer;
    state_id: Integer;
    town_id: Integer;
    placement_id: Integer;
    street_id: Integer;
    regioncode: string;
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
  fmEditRBEmpStreet: TfmEditRBEmpStreet;

implementation

uses UStaffTsvCode, UStaffTsvData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBEmpStreet.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBEmpStreet.AddToRBooks: Boolean;
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
          ' (empstreet_id,country_id,region_id,state_id,town_id,placement_id,'+
          'street_id,emp_id,typelive_id,housenum,buildnum,flatnum) values '+
          ' ('+
          id+','+
          inttostr(country_id)+','+
          GetStrFromCondition(Trim(edregion.text)<>'',
                              inttostr(region_id),
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

    ParentEmpForm.ActiveEmpStreet(false);
    ParentEmpForm.qrEmpStreet.Locate('empstreet_id',id,[LocaseInsensitive]);
    Result:=true;
  finally
    qr.Free;
    Screen.Cursor:=crDefault;
  end;
 except
  on E: EIBInterBaseError do begin
    TempStr:=TranslateIBError(E.Message);
    ShowErrorEx(TempStr);
    Assert(false,TempStr);
  end;
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmEditRBEmpStreet.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBEmpStreet.UpdateRBooks: Boolean;
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

    id:=ParentEmpForm.qrEmpStreet.FieldByName('empstreet_id').AsString;
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbEmpStreet+
          ' set emp_id='+inttostr(emp_id)+
          ', country_id='+inttostr(country_id)+
          ', region_id='+GetStrFromCondition(Trim(edregion.text)<>'',
                                           inttostr(region_id),
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

    ParentEmpForm.ActiveEmpStreet(false);
    ParentEmpForm.qrEmpStreet.Locate('empstreet_id',id,[LocaseInsensitive]);
    Result:=true;
  finally
    qr.Free;
    Screen.Cursor:=crDefault;
  end;
 except
  on E: EIBInterBaseError do begin
    TempStr:=TranslateIBError(E.Message);
    ShowErrorEx(TempStr);
    Assert(false,TempStr);
  end;
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmEditRBEmpStreet.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBEmpStreet.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edCountry.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbCountry.Caption]));
    bibCountry.SetFocus;
    Result:=false;
    exit;
  end;
  if (trim(edTown.Text)='')and(trim(edPlaceMent.Text)='') then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbTown.Caption]));
    bibTown.SetFocus;
    Result:=false;
    exit;
  end;
  if (trim(edTown.Text)<>'')and(trim(edPlaceMent.Text)<>'') then begin
    ShowErrorEx(Format(ConstFieldEmpty,[lbPlaceMent.Caption]));
    bibPlaceMent.SetFocus;
    Result:=false;
    exit;
  end;

{  if trim(edRegion.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbRegion.Caption]));
    bibRegion.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edState.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbState.Caption]));
    bibState.SetFocus;
    Result:=false;
    exit;
  end;}
{  if trim(edStreet.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbStreet.Caption]));
    bibStreet.SetFocus;
    Result:=false;
    exit;
  end;
 } if trim(edTypeLive.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbTypeLive.Caption]));
    bibTypeLive.SetFocus;
    Result:=false;
    exit;
  end;
  
end;

procedure TfmEditRBEmpStreet.edhousenumChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpStreet.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edCountry.MaxLength:=DomainNameLength;
  edstate.MaxLength:=DomainNameLength;
  edtown.MaxLength:=DomainNameLength;
  edplacement.MaxLength:=DomainNameLength;
  edStreet.MaxLength:=DomainNameLength;

  edhousenum.MaxLength:=DomainSmallNameLength;
  edbuildnum.MaxLength:=DomainSmallNameLength;
  edflatnum.MaxLength:=DomainSmallNameLength;

  edTypeLive.MaxLength:=DomainNameLength;
  
end;

procedure TfmEditRBEmpStreet.edConnectionTypeChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpStreet.dtpBirthdateChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpStreet.bibStreetClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='Street_id';
  TPRBI.Locate.KeyValues:=Street_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  TPRBI.Condition.WhereStr:=Pchar(GetWhereStr(3));
  if _ViewInterfaceFromName(NameRbkStreet,@TPRBI) then begin
   ChangeFlag:=true;
   Street_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'Street_id');
   StreetCode:=GetFirstValueFromParamRBookInterface(@TPRBI,'Code');
   edStreet.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'Name');
  end;
end;

procedure TfmEditRBEmpStreet.edStreetChange(Sender: TObject);
begin
  ChangeFlag:=true;

end;

procedure TfmEditRBEmpStreet.edhousenumKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (not (Key in ['0'..'9']))and((Integer(Key)<>VK_Back)) then Key:=#0;
end;

procedure TfmEditRBEmpStreet.bibTypeLiveClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='typelive_id';
  TPRBI.Locate.KeyValues:=typelive_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkTypeLive,@TPRBI) then begin
   ChangeFlag:=true;
   typelive_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'typelive_id');
   edTypeLive.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBEmpStreet.bibCountryClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='Country_id';
  TPRBI.Locate.KeyValues:=Country_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkCountry,@TPRBI) then begin
   ChangeFlag:=true;
   Country_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'Country_id');
   edCountry.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBEmpStreet.bibregionClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='Region_id';
  TPRBI.Locate.KeyValues:=Region_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkRegion,@TPRBI) then begin
   ChangeFlag:=true;
   Region_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'Region_id');
   regioncode:=GetFirstValueFromParamRBookInterface(@TPRBI,'code');
   edRegion.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBEmpStreet.bibstateClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='State_id';
  TPRBI.Locate.KeyValues:=State_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  TPRBI.Condition.WhereStr:=Pchar(GetWhereStr(0));
  if _ViewInterfaceFromName(NameRbkState,@TPRBI) then begin
   ChangeFlag:=true;
   State_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'State_id');
   StateCode:=GetFirstValueFromParamRBookInterface(@TPRBI,'code');
   edState.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBEmpStreet.bibtownClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='Town_id';
  TPRBI.Locate.KeyValues:=Town_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  TPRBI.Condition.WhereStr:=Pchar(GetWhereStr(1));
  if _ViewInterfaceFromName(NameRbkTown,@TPRBI) then begin
   ChangeFlag:=true;
   Town_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'Town_id');
   TownCode:=GetFirstValueFromParamRBookInterface(@TPRBI,'Code');
   edTown.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBEmpStreet.bibplacementClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='PlaceMent_id';
  TPRBI.Locate.KeyValues:=PlaceMent_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  TPRBI.Condition.WhereStr:=Pchar(GetWhereStr(2));
  if _ViewInterfaceFromName(NameRbkPlacement,@TPRBI) then begin
   ChangeFlag:=true;
   PlaceMent_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'PlaceMent_id');
   PlaceMentCode:=GetFirstValueFromParamRBookInterface(@TPRBI,'Code');
   edPlaceMent.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBEmpStreet.edtownKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    edtown.Text:='';
    ChangeFlag:=true;
    town_id:=0;
    towncode:='';
  end;
end;

procedure TfmEditRBEmpStreet.edplacementKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    edplacement.Text:='';
    ChangeFlag:=true;
    placement_id:=0;
    placementcode:='';
  end;
end;

procedure TfmEditRBEmpStreet.edstateKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    edstate.Text:='';
    ChangeFlag:=true;
    state_id:=0;
    statecode:='';
  end;
end;

procedure TfmEditRBEmpStreet.edregionKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    edregion.Text:='';
    ChangeFlag:=true;
    region_id:=0;
    regioncode:='';
  end;
end;

function TfmEditRBEmpStreet.GetWhereStr(Index: Integer): string;
begin
  Result:='';
  case Index of
    0: begin
      Result:=' where code like '+QuotedStr(Copy(RegionCode,1,2)+'%');
    end;
    1: begin
      if trim(StateCode)<>'' then
       Result:=' where code like '+QuotedStr(Copy(StateCode,1,5)+'%')
      else if trim(RegionCode)<>'' then
       Result:=' where code like '+QuotedStr(Copy(RegionCode,1,2)+'%');
    end;
    2: begin
      if trim(StateCode)<>'' then
       Result:=' where code like '+QuotedStr(Copy(StateCode,1,5)+'%')
      else if trim(RegionCode)<>'' then
       Result:=' where code like '+QuotedStr(Copy(RegionCode,1,2)+'%');
    end;
    3: begin
      if trim(RegionCode)<>'' then Result:=' where code like '+QuotedStr(Copy(RegionCode,1,2)+'%');
      if trim(StateCode)<>'' then Result:=' where code like '+QuotedStr(Copy(StateCode,1,5)+'%');
      if Trim(PlaceMentCode)<>'' then Result:=' where code like '+QuotedStr(Copy(PlaceMentCode,1,11)+'%');
      if Trim(TownCode)<>'' then Result:=' where code like '+QuotedStr(Copy(TownCode,1,11)+'%');
    end;
  end;
                 
end;

procedure TfmEditRBEmpStreet.edStreetKeyDown(Sender: TObject;
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
