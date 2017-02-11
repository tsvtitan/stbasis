unit UEditRBEmp;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase,
  ComCtrls, IB;

type
  TfmEditRBEmp = class(TfmEditRB)
    lbTabNum: TLabel;
    edTabNum: TEdit;
    lbContinioussenioritydate: TLabel;
    bibTabNumNext: TBitBtn;
    dtpContinioussenioritydate: TDateTimePicker;
    lbFName: TLabel;
    lbName: TLabel;
    lbSName: TLabel;
    lbSex: TLabel;
    lbBirthDate: TLabel;
    lbPerscardnum: TLabel;
    lbFamilyStateName: TLabel;
    lbNationname: TLabel;
    lbInn: TLabel;
    edFname: TEdit;
    edName: TEdit;
    edSname: TEdit;
    dtpBirthDate: TDateTimePicker;
    edPerscardnum: TEdit;
    edFamilyStateName: TEdit;
    bibFamilyStateName: TBitBtn;
    edNationname: TEdit;
    bibNationname: TBitBtn;
    edSex: TEdit;
    bibSex: TBitBtn;
    edInn: TEdit;
    grbBorn: TGroupBox;
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
    procedure edTabNumChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edTabNumKeyPress(Sender: TObject; var Key: Char);
    procedure bibFamilyStateNameClick(Sender: TObject);
    procedure bibNationnameClick(Sender: TObject);
    procedure bibSexClick(Sender: TObject);
    procedure bibTabNumNextClick(Sender: TObject);
    procedure bibCountryClick(Sender: TObject);
    procedure bibregionClick(Sender: TObject);
    procedure bibstateClick(Sender: TObject);
    procedure bibtownClick(Sender: TObject);
    procedure bibplacementClick(Sender: TObject);
    procedure edregionKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edstateKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtownKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edplacementKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
    function GetNextTabNum: String;
    procedure bibPlaceMentNameClick(Sender: TObject);
    function GetWhereStr(TypeEntry: Integer): string;
  public
    oldemp_id: Integer;
    familystate_id: Integer;
    nation_id: Integer;
    country_id: Integer;
    region_id: Integer;
    state_id: Integer;
    town_id: Integer;
    placement_id: Integer;
    regioncode: string;
    statecode: string;
    towncode: string;
    placementcode: string;
    sex_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBEmp: TfmEditRBEmp;

implementation

uses USalaryVAVCode, USalaryVAVData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBEmp.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBEmp.AddToRBooks: Boolean;
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
    qr.Database:=IBDB;
    qr.Transaction:=ibtran;
    qr.Transaction.Active:=true;
    id:=inttostr(GetGenId(IBDB,tbEmp,1));
    sqls:='Insert into '+tbEmp+
          ' (emp_id, sex_id,familystate_id, nation_id,fname,'+
          ' name, sname, perscardnum, tabnum, birthdate,'+
          ' continioussenioritydate,inn,country_id,region_id,'+
          'state_id,town_id,placement_id) values '+
          ' ('+
          id+','+
          inttostr(sex_id)+','+
          inttostr(familystate_id)+','+
          inttostr(nation_id)+','+
          QuotedStr(Trim(edFname.Text))+','+
          QuotedStr(Trim(edname.Text))+','+
          QuotedStr(Trim(edSname.Text))+','+
          QuotedStr(Trim(edPerscardnum.Text))+','+
          Trim(edTabNum.Text)+','+
          QuotedStr(DateTimeToStr(dtpBirthDate.Date))+','+
          QuotedStr(DateTimeToStr(dtpContinioussenioritydate.Date))+','+
          GetStrFromCondition(Trim(edInn.Text)<>'',
                              QuotedStr(Trim(edInn.Text)),
                              'null')+','+
          GetStrFromCondition(Trim(edCountry.Text)<>'',
                              inttostr(country_id),
                              'null')+','+
          GetStrFromCondition(Trim(edRegion.Text)<>'',
                              inttostr(region_id),
                              'null')+','+
          GetStrFromCondition(Trim(edState.Text)<>'',
                              inttostr(state_id),
                              'null')+','+
          GetStrFromCondition(Trim(edTown.Text)<>'',
                              inttostr(town_id),
                              'null')+','+
          GetStrFromCondition(Trim(edplacement.Text)<>'',
                              inttostr(placement_id),
                              'null')+
          ')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldemp_id:=strtoint(id);

    _AddSqlOperationToJournal(PChar(ConstInsert),PChar(sqls));

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

procedure TfmEditRBEmp.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBEmp.UpdateRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id: String;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try

    id:=inttostr(oldemp_id);//fmRBEmp.MainQr.FieldByName('emp_id').AsString;
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbEmp+
          ' set familystate_id='+inttostr(familystate_id)+
          ', sex_id='+inttostr(sex_id)+
          ', nation_id='+inttostr(nation_id)+
          ', fname='+QuotedStr(Trim(edFname.Text))+
          ', name='+QuotedStr(Trim(edname.Text))+
          ', sname='+QuotedStr(Trim(edSname.Text))+
          ', perscardnum='+QuotedStr(Trim(edPerscardnum.Text))+
          ', tabnum='+Trim(edTabNum.Text)+
          ', birthdate='+QuotedStr(DateTimeToStr(dtpBirthDate.Date))+
          ', continioussenioritydate='+QuotedStr(DateTimeToStr(dtpContinioussenioritydate.Date))+
          ', inn='+GetStrFromCondition(Trim(edInn.Text)<>'',
                                       QuotedStr(Trim(edInn.Text)),
                                       'null')+
          ', country_id='+GetStrFromCondition(Trim(edCountry.Text)<>'',
                                              inttostr(country_id),
                                              'null')+
          ', region_id='+GetStrFromCondition(Trim(edregion.Text)<>'',
                                              inttostr(region_id),
                                              'null')+
          ', state_id='+GetStrFromCondition(Trim(edstate.Text)<>'',
                                              inttostr(state_id),
                                              'null')+
          ', town_id='+GetStrFromCondition(Trim(edtown.Text)<>'',
                                              inttostr(town_id),
                                              'null')+
          ', placement_id='+GetStrFromCondition(Trim(edplacement.Text)<>'',
                                              inttostr(placement_id),
                                              'null')+
          ' where emp_id='+id;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    _AddSqlOperationToJournal(PChar(ConstUpdate),PChar(sqls));

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

procedure TfmEditRBEmp.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBEmp.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edTabNum.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbTabNum.Caption]));
    edTabNum.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edFname.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbFname.Caption]));
    edFname.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edname.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbname.Caption]));
    edname.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edsname.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbsname.Caption]));
    edsname.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edSex.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbSex.Caption]));
    bibSex.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edPerscardnum.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbPerscardnum.Caption]));
    edPerscardnum.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edInn.Text)<>'' then begin
   if Length(Trim(edInn.Text))<>ConstEmpInnLength then begin
    ShowError(Handle,Format(ConstFieldLengthInvalid,[lbInn.Caption,ConstEmpInnLength]));
    edInn.SetFocus;
    Result:=false;
    exit;
   end;
   if not isInteger(edInn.Text) then begin
     ShowError(Handle,Format(ConstFieldFormatInvalid,[lbInn.Caption]));
     edInn.SetFocus;
     Result:=false;
     exit;
   end;
  end;
  if trim(edFamilyStateName.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbFamilyStateName.Caption]));
    bibFamilyStateName.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edNationname.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbNationname.Caption]));
    bibNationname.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edCountry.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbCountry.Caption]));
    bibCountry.SetFocus;
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
end;

procedure TfmEditRBEmp.edTabNumChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBEmp.FormCreate(Sender: TObject);
var
  curdate: TDate;
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);


  curdate:=_GetDateTimeFromServer;
  edTabNum.MaxLength:=9;
  edFname.MaxLength:=DomainNameLength;
  edName.MaxLength:=DomainSmallNameLength;
  edSname.MaxLength:=DomainSmallNameLength;
  edSex.MaxLength:=DomainNameLength;
  edPerscardnum.MaxLength:=DomainSmallNameLength;
  edInn.MaxLength:=12;
  dtpBirthDate.Date:=curdate;
  edFamilyStateName.MaxLength:=DomainNameLength;
  edNationname.MaxLength:=DomainNameLength;
  dtpContinioussenioritydate.Date:=curdate;

  edCountry.MaxLength:=DomainNameLength;
  edstate.MaxLength:=DomainNameLength;
  edtown.MaxLength:=DomainNameLength;
  edplacement.MaxLength:=DomainNameLength;
  
end;

procedure TfmEditRBEmp.edTabNumKeyPress(Sender: TObject; var Key: Char);
begin
  if (not (Key in ['0'..'9']))and((Integer(Key)<>VK_Back)) then Key:=#0;
end;

procedure TfmEditRBEmp.bibFamilyStateNameClick(Sender: TObject);
var
  P: PFamilyStateParams;
begin
 try
  getMem(P,sizeof(TFamilyStateParams));
  try
   ZeroMemory(P,sizeof(TFamilyStateParams));
   P.familystate_id:=familystate_id;
   if _ViewEntryFromMain(tte_rbksfamilystate,p,true) then begin
     ChangeFlag:=true;
     familystate_id:=P.familystate_id;
     edFamilyStateName.Text:=P.name;
   end;
  finally
    FreeMem(P,sizeof(TFamilyStateParams));
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end; 
end;

procedure TfmEditRBEmp.bibNationnameClick(Sender: TObject);
var
  P: PNationParams;
begin
 try
  getMem(P,sizeof(TNationParams));
  try
   ZeroMemory(P,sizeof(TNationParams));
   P.id:=nation_id;
   if _ViewEntryFromMain(tte_rbksnation,p,true) then begin
     ChangeFlag:=true;
     nation_id:=P.id;
     edNationname.Text:=P.Name;
   end;
  finally
    FreeMem(P,sizeof(TNationParams));
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end; 
end;

procedure TfmEditRBEmp.bibSexClick(Sender: TObject);
var
  P: PSexParams;
begin
 try
  getMem(P,sizeof(TSexParams));
  try
   ZeroMemory(P,sizeof(TSexParams));
   P.sex_id:=sex_id;
   if _ViewEntryFromMain(tte_rbkssex,p,true) then begin
     ChangeFlag:=true;
     sex_id:=P.sex_id;
     edSex.Text:=P.name;
   end;
  finally
    FreeMem(P,sizeof(TSexParams));
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end; 
end;

procedure TfmEditRBEmp.bibTabNumNextClick(Sender: TObject);
begin
  edTabNum.Text:=GetNextTabNum;
end;

function TfmEditRBEmp.GetNextTabNum: String;
var
  qr: TIBQuery;
  sqls: string;
begin
 Result:='0';
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try
    qr.Database:=IBDB;
    qr.Transaction:=ibtran;
    qr.Transaction.Active:=true;
    sqls:='Select Max(tabnum) as tabnum from '+tbEmp;
    qr.SQL.Add(sqls);
    qr.Active:=true;
    if not qr.IsEmpty then
     Result:=inttostr(qr.FieldByName('tabnum').AsInteger+1); 
  finally
    qr.Free;
    Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmEditRBEmp.bibPlaceMentNameClick(Sender: TObject);
begin
end;

procedure TfmEditRBEmp.bibCountryClick(Sender: TObject);
var
  P: PCountryParams;
begin
 try
  getMem(P,sizeof(TCountryParams));
  try
   ZeroMemory(P,sizeof(TCountryParams));
   P.Country_id:=Country_id;
   if _ViewEntryFromMain(tte_rbkscountry,p,true) then begin
     ChangeFlag:=true;
     Country_id:=P.Country_id;
     edCountry.Text:=P.CountryName;
   end;
  finally
    FreeMem(P,sizeof(TCountryParams));
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end; 
end;

procedure TfmEditRBEmp.bibregionClick(Sender: TObject);
var
  P: PRegionParams;
begin
 try
  getMem(P,sizeof(TRegionParams));
  try
   ZeroMemory(P,sizeof(TRegionParams));
   P.Region_id:=Region_id;
   if _ViewEntryFromMain(tte_rbksRegion,p,true) then begin
     ChangeFlag:=true;
     Region_id:=P.Region_id;
     RegionCode:=P.Code;
     edRegion.Text:=P.RegionName;
   end;
  finally
    FreeMem(P,sizeof(TRegionParams));
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end; 
end;

procedure TfmEditRBEmp.bibstateClick(Sender: TObject);
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

procedure TfmEditRBEmp.bibtownClick(Sender: TObject);
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

procedure TfmEditRBEmp.bibplacementClick(Sender: TObject);
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

function TfmEditRBEmp.GetWhereStr(TypeEntry: Integer): string;
var
 tt: TTypeEntry;
begin
  Result:='';
  tt:=TTypeEntry(TypeEntry);
  case tt of
    tte_rbksstate: begin
      Result:=' where code like '+QuotedStr(Copy(RegionCode,1,2)+'%');
    end;
    tte_rbkstown: begin
      if trim(StateCode)<>'' then
       Result:=' where code like '+QuotedStr(Copy(StateCode,1,5)+'%')
      else if trim(RegionCode)<>'' then
       Result:=' where code like '+QuotedStr(Copy(RegionCode,1,2)+'%');
    end;
    tte_rbksplacement: begin
      if trim(StateCode)<>'' then
       Result:=' where code like '+QuotedStr(Copy(StateCode,1,5)+'%')
      else if trim(RegionCode)<>'' then
       Result:=' where code like '+QuotedStr(Copy(RegionCode,1,2)+'%');
    end;
    tte_rbksstreet: begin
      if trim(RegionCode)<>'' then Result:=' where code like '+QuotedStr(Copy(RegionCode,1,2)+'%');
      if trim(StateCode)<>'' then Result:=' where code like '+QuotedStr(Copy(StateCode,1,5)+'%');
      if Trim(PlaceMentCode)<>'' then Result:=' where code like '+QuotedStr(Copy(PlaceMentCode,1,11)+'%');
      if Trim(TownCode)<>'' then Result:=' where code like '+QuotedStr(Copy(TownCode,1,11)+'%');
    end;
  end;

end;


procedure TfmEditRBEmp.edregionKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    edregion.Text:='';
    ChangeFlag:=true;
    region_id:=0;
    regioncode:='';
  end;
end;

procedure TfmEditRBEmp.edstateKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    edstate.Text:='';
    ChangeFlag:=true;
    state_id:=0;
    statecode:='';
  end;
end;

procedure TfmEditRBEmp.edtownKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    edtown.Text:='';
    ChangeFlag:=true;
    town_id:=0;
    towncode:='';
  end;
end;

procedure TfmEditRBEmp.edplacementKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    edplacement.Text:='';
    ChangeFlag:=true;
    placement_id:=0;
    placementcode:='';
  end;
end;

end.
