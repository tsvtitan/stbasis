unit UWizJobAccept;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  MainWizard, PageMngr, ExtCtrls, StdCtrls, ComCtrls, Grids, Buttons, Mask,
  IBDatabase, Db, IBCustomDataSet, IBQuery;

type
  TFmWizJobAccept = class(TfmMainWizard)
    ReadIBQ: TIBQuery;
    IBTRead: TIBTransaction;
    WriteIBQ: TIBQuery;
    IBTWrite: TIBTransaction;
    TSMain: TTabSheet;
    LbAbout: TLabel;
    LbFName: TLabel;
    LbName: TLabel;
    LbSName: TLabel;
    LbBirthDay: TLabel;
    LbNation: TLabel;
    EdFName: TEdit;
    EdName: TEdit;
    EdSName: TEdit;
    dpBirthDate: TDateTimePicker;
    edNationname: TEdit;
    BtCallNation: TButton;
    TS2: TTabSheet;
    LbSeniority: TLabel;
    LbPersCardNum: TLabel;
    LbTabNum: TLabel;
    LbINN: TLabel;
    Label2: TLabel;
    EdPersCardNum: TEdit;
    EdTabNum: TEdit;
    EdINN: TEdit;
    DPSeniotity: TDateTimePicker;
    TSPassport: TTabSheet;
    Label3: TLabel;
    lbSerial: TLabel;
    lbNum: TLabel;
    lbDateWhere: TLabel;
    lbPlantName: TLabel;
    lbhousenum: TLabel;
    lbbuildnum: TLabel;
    lbflatnum: TLabel;
    lbStreet: TLabel;
    lbTypeLive: TLabel;
    Label6: TLabel;
    dtpDateWhere: TDateTimePicker;
    edPlantName: TEdit;
    btCallPlantName: TBitBtn;
    msedSerial: TMaskEdit;
    msedNum: TMaskEdit;
    edhousenum: TEdit;
    edbuildnum: TEdit;
    edflatnum: TEdit;
    edStreet: TEdit;
    btCallStreet: TBitBtn;
    edTypeLive: TEdit;
    btCallTypeLive: TBitBtn;
    TSDiplom: TTabSheet;
    Label4: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    lbProfession: TLabel;
    lbTypeStud: TLabel;
    lbEduc: TLabel;
    lbCraft: TLabel;
    lbFinishDate: TLabel;
    lbSchool: TLabel;
    edNum: TEdit;
    dtpDiplomDateWhere: TDateTimePicker;
    edProfession: TEdit;
    btCallProfession: TBitBtn;
    edTypeStud: TEdit;
    btCallTypeStud: TBitBtn;
    edEduc: TEdit;
    btCallEduc: TBitBtn;
    edCraft: TEdit;
    btCallCraft: TBitBtn;
    dtpFinishDate: TDateTimePicker;
    edSchool: TEdit;
    btCallSchool: TBitBtn;
    TSEmpPlant: TTabSheet;
    lbCategory: TLabel;
    lbNet: TLabel;
    lbClass: TLabel;
    lbReasonDocum: TLabel;
    lbSeat: TLabel;
    lbDepart: TLabel;
    lbOrderDocum: TLabel;
    lbProf: TLabel;
    lbschedule: TLabel;
    lbDateStart: TLabel;
    Label9: TLabel;
    edNet: TEdit;
    btCallNet: TBitBtn;
    edClass: TEdit;
    btCallClass: TBitBtn;
    edReasonDocum: TEdit;
    btCallReasonDocum: TBitBtn;
    edCategory: TEdit;
    btCallCategory: TBitBtn;
    edSeat: TEdit;
    btCallSeat: TBitBtn;
    edDepart: TEdit;
    btCallDepart: TBitBtn;
    edOrderDocum: TEdit;
    btCallOrderDocum: TBitBtn;
    edProf: TEdit;
    btCallProf: TBitBtn;
    edschedule: TEdit;
    btCallschedule: TBitBtn;
    dtpDateStart: TDateTimePicker;
    lbSex: TLabel;
    edSex: TEdit;
    btCallSex: TBitBtn;
    lbConnectionString: TLabel;
    lbConnectionType: TLabel;
    edConnectionString: TEdit;
    edConnectionType: TEdit;
    btCallConnectionType: TBitBtn;
    Label5: TLabel;
    btCallTabNumNext: TBitBtn;
    grbBorn: TGroupBox;
    lbCountry: TLabel;
    lbregion: TLabel;
    lbstate: TLabel;
    lbTown: TLabel;
    lbplacement: TLabel;
    edCountry: TEdit;
    btCallCountry: TBitBtn;
    edregion: TEdit;
    btCallRegion: TBitBtn;
    edstate: TEdit;
    btCallState: TBitBtn;
    edtown: TEdit;
    btCallTown: TBitBtn;
    edplacement: TEdit;
    btCallPlacement: TBitBtn;
    lbFamilyState: TLabel;
    EdFamilyStateName: TEdit;
    btCallFamState: TButton;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btCallFamStateClick(Sender: TObject);
    procedure BtCallNationClick(Sender: TObject);
    procedure btCallPlantNameClick(Sender: TObject);
    procedure btCallProfessionClick(Sender: TObject);
    procedure btCallTypeStudClick(Sender: TObject);
    procedure btCallEducClick(Sender: TObject);
    procedure btCallCraftClick(Sender: TObject);
    procedure btCallSchoolClick(Sender: TObject);
    procedure btCallNetClick(Sender: TObject);
    procedure btCallClassClick(Sender: TObject);
    procedure btCallCategoryClick(Sender: TObject);
    procedure btCallSeatClick(Sender: TObject);
    procedure btCallDepartClick(Sender: TObject);
    procedure btCallOrderDocumClick(Sender: TObject);
    procedure btCallProfClick(Sender: TObject);
    procedure btCallscheduleClick(Sender: TObject);
    procedure btCallTypeLiveClick(Sender: TObject);
    procedure btCallStreetClick(Sender: TObject);
    procedure btFinishClick(Sender: TObject);
    procedure btCallSexClick(Sender: TObject);
    procedure btCallConnectionTypeClick(Sender: TObject);
    procedure btPriorClick(Sender: TObject);
    procedure btNextClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure btCallTabNumNextClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btCallCountryClick(Sender: TObject);
    procedure btCallRegionClick(Sender: TObject);
    procedure btCallStateClick(Sender: TObject);
    procedure btCallTownClick(Sender: TObject);
    procedure btCallPlacementClick(Sender: TObject);
    procedure edtownKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edplacementKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    PermEmpPersDoc, PermEmpStreet,
    PermEmpDiplom, PermEmpPlant, PermEmpConnect:Boolean;
  protected
    function GetWhereStr(TypeEntry: Integer): string;

  public
    Emp_id, Sex_id, familyState_id, nation_id, Country_id, EmpPassport_id,Street_id,
    typelive_id, Region_id, State_id, town_id, placement_id,
    profession_id, Plant_id, typestud_id, educ_id, craft_id,
    school_id, CurPlant_id:integer;
    regioncode: string;
    statecode: string;
    ConstPlaceCode, towncode: string;
    ConstEmpTownCode, placementcode: string;

    //тип связи с сотрудником
    connectiontype_id,
    //места работы сотрудника
    net_id, class_id, reasondocum_id, category_id, seat_id,
    depart_id, orderdocum_id, motive_id, prof_id, schedule_id,
    motivedocum_id: Integer;

    ChangeFlag:Boolean;
    procedure SetEmpConstant;
    procedure GetEmpPassport_Id;
    procedure PrepareSQL;
    procedure AddNewEmp;
    procedure CheckPermission;
    procedure SetPageCNTRFocus;
    procedure SetPassportMasks;

    function CheckEmpData:Boolean;
    function CheckEmpPassport:Boolean;
    function CheckEmpStreet:Boolean;
    function CheckEmpDiplom:Boolean;
    function CheckEmpPlant:Boolean;
    function CheckEmpConnect:Boolean;

    function getEmpSQL:string;
    function getEmpPassportSQL:string;
    function getEmpStreetSQL:string;
    function getEmpDiplomSQl:String;
    function getEmpPlantSQl:String;
    function getEmpConnectSQl:String;
    function GetNextTabNum: String;
    { Public declarations }
  end;

var
  FmWizJobAccept: TFmWizJobAccept;

implementation
Uses UMainUnited, UfuncProc, Uconst, StCalendarUtil;

{$R *.DFM}

procedure TFmWizJobAccept.FormDestroy(Sender: TObject);
begin
  inherited;
  IBTRead.RemoveDatabases;
  IBTWrite.RemoveDatabases;
  FmWizJobAccept:=nil;
end;

procedure TFmWizJobAccept.FormCreate(Sender: TObject);
begin
  inherited;
  PrepareSQL;
  CheckPermission;
  SetEmpConstant;
end;

procedure TFmWizJobAccept.btCallFamStateClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='FamState_id';
  TPRBI.Locate.KeyValues:=Fam_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameTypeDoc,@TPRBI) then begin
    ChangeFlag:=true;
    TypeDoc_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'TypeDoc_id');
    EdTypeDoc.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'Name');
  end;
end;

procedure TFmWizJobAccept.BtCallNationClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='Nation_ID';
  TPRBI.Locate.KeyValues:=nation_id;
  TPRBI.Locate.Options:=[];
  if _ViewInterfaceFromName(NameRbkNation,@TPRBI) then begin
    nation_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'Nation_ID');
    edNationname.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'Name');
  end;
end;

procedure TFmWizJobAccept.btCallPlantNameClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='Plant';
  TPRBI.Locate.KeyValues:=Plant_id;
  TPRBI.Locate.Options:=[];
  if _ViewInterfaceFromName(NameRbkPlant,@TPRBI) then begin
    Plant_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'Plant_id');
    edPlantName.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'Name');
  end;
end;

procedure TFmWizJobAccept.btCallProfessionClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='profession_id';
  TPRBI.Locate.KeyValues:=Plant_id;
  TPRBI.Locate.Options:=[];
  if _ViewInterfaceFromName(NameRbkprofession,@TPRBI) then begin
    profession_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'profession_id');
    edProfession.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'Name');
  end;
end;

procedure TFmWizJobAccept.btCallTypeStudClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='TypeStud_id';
  TPRBI.Locate.KeyValues:=TypeStud_id;
  TPRBI.Locate.Options:=[];
  if _ViewInterfaceFromName(NameRbkTypeStud,@TPRBI) then begin
    TypeStud_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'TypeStud_id');
    edTypeStud.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'Name');
  end;
end;

procedure TFmWizJobAccept.btCallEducClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='Educ_id';
  TPRBI.Locate.KeyValues:=Educ_id;
  TPRBI.Locate.Options:=[];
  if _ViewInterfaceFromName(NameRbkEduc,@TPRBI) then begin
    Educ_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'Educ_id');
    edEduc.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'Name');
  end;
end;

procedure TFmWizJobAccept.btCallCraftClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='Craft_id';
  TPRBI.Locate.KeyValues:=Craft_id;
  TPRBI.Locate.Options:=[];
  if _ViewInterfaceFromName(NameRbkCraft,@TPRBI) then begin
    Craft_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'Craft_id');
    edCraft.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'Name');
  end;
end;

procedure TFmWizJobAccept.btCallSchoolClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='School_id';
  TPRBI.Locate.KeyValues:=School_id;
  TPRBI.Locate.Options:=[];
  if _ViewInterfaceFromName(NameRbkSchool,@TPRBI) then begin
    School_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'School_id');
    edSchool.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'Name');
  end;
end;

procedure TFmWizJobAccept.btCallNetClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='Net_id';
  TPRBI.Locate.KeyValues:=Net_id;
  TPRBI.Locate.Options:=[];
  if _ViewInterfaceFromName(NameRbkNet,@TPRBI) then begin
    Net_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'Net_id');
    edNet.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'Name');
  end;
end;

procedure TFmWizJobAccept.btCallClassClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='Net_id';
  TPRBI.Locate.KeyValues:=Net_id;
  TPRBI.Locate.Options:=[];
  if _ViewInterfaceFromName(NameRbkNet,@TPRBI) then begin
    Net_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'Net_id');
    edNet.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'Name');
  end;
end;

procedure TFmWizJobAccept.btCallCategoryClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='Category_id';
  TPRBI.Locate.KeyValues:=Category_id;
  TPRBI.Locate.Options:=[];
  if _ViewInterfaceFromName(NameRbkCategory,@TPRBI) then begin
    Category_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'Category_id');
    edCategory.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'Name');
  end;
end;

procedure TFmWizJobAccept.btCallSeatClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='Seat_id';
  TPRBI.Locate.KeyValues:=Seat_id;
  TPRBI.Locate.Options:=[];
  if _ViewInterfaceFromName(NameRbkSeat,@TPRBI) then begin
    Seat_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'Seat_id');
    edSeat.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'Name');
  end;
end;

procedure TFmWizJobAccept.btCallDepartClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='Depart_id';
  TPRBI.Locate.KeyValues:=Depart_id;
  TPRBI.Locate.Options:=[];
  if _ViewInterfaceFromName(NameRbkDepart,@TPRBI) then begin
    Depart_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'Depart_id');
    edDepart.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'Name');
  end;
end;

procedure TFmWizJobAccept.btCallOrderDocumClick(Sender: TObject);
var
  P: PDocumParams;
begin
 try
  getMem(P,sizeof(TDocumParams));
  try
   ZeroMemory(P,sizeof(TDocumParams));
   P.docum_id:=orderdocum_id;
   if _ViewEntryFromMain(tte_rbksdocum,p,true) then
   begin
     orderdocum_id:=P.docum_id;
     edOrderDocum.Text:=P.num;
   end;
  finally
    FreeMem(P,sizeof(TDocumParams));
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TFmWizJobAccept.btCallProfClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='Prof_id';
  TPRBI.Locate.KeyValues:=Prof_id;
  TPRBI.Locate.Options:=[];
  if _ViewInterfaceFromName(NameRbkProf,@TPRBI) then begin
    Prof_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'Prof_id');
    edProf.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'Name');
  end;
end;

procedure TFmWizJobAccept.btCallscheduleClick(Sender: TObject);
var
  P: PScheduleParams;
begin
 try
  getMem(P,sizeof(TScheduleParams));
  InitCalendarUtil(IBDB);
  try
   ZeroMemory(P,sizeof(TScheduleParams));
   P.Schedule_ID:=schedule_id;
   P.Calendar_ID:=GetCurrentCalendarID;
   if _ViewEntryFromMain(tte_rbksSchedule,p,true) then begin
     ChangeFlag:=true;
     schedule_id:=P.Schedule_ID;
     edschedule.Text:=P.Name;
   end;
  finally
    DoneCalendarUtil;
    FreeMem(P,sizeof(TScheduleParams));
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TFmWizJobAccept.btCallTypeLiveClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='TypeLive_id';
  TPRBI.Locate.KeyValues:=TypeLive_id;
  TPRBI.Locate.Options:=[];
  if _ViewInterfaceFromName(NameRbkTypeLive,@TPRBI) then begin
    TypeLive_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'TypeLive_id');
    edTypeLive.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'Name');
  end;
end;

procedure TFmWizJobAccept.btCallStreetClick(Sender: TObject);
  function GetWhereStr:String;
  begin
    Result:='';
    if ConstPlaceCode<>'' then
      Result:=' where code like '+QuotedStr(ConstPlaceCode+'%');
    if ConstEmpTownCode<>'' then
      Result:=' where code like '+QuotedStr(ConstEmpTownCode+'%');
  end;
var
  P: PStreetParams;
begin
 try
  getMem(P,sizeof(TStreetParams));
  try
   ZeroMemory(P,sizeof(TStreetParams));
   P.Street_id:=Street_id;
   if Trim(edStreet.text)='' then StrCopy(P.wherestr,Pchar(GetWhereStr));
   if _ViewEntryFromMain(tte_rbksstreet,p,true) then begin
     Street_id:=P.Street_id;
     edStreet.Text:=P.StreetName;
   end;
  finally
    FreeMem(P,sizeof(TStreetParams));
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TFmWizJobAccept.GetEmpPassport_Id;
var
  P:PConstParams;
begin
 try
  getMem(P,sizeof(TConstParams));
  try
   ZeroMemory(P,sizeof(TConstParams));
   if _ViewEntryFromMain(tte_const,P,true,true) then
     EmpPassport_id:=P.emppassport_id;
     SetPassportMasks;
  finally
    FreeMem(P,sizeof(TConstParams));
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;

end;

procedure TFmWizJobAccept.PrepareSQL;
begin
  IBTRead.AddDatabase(IBDB);
  IbDb.AddTransaction(IBTRead);
  ReadIBQ.Transaction:=IBTRead;
  ReadIBQ.Database:=IbDb;

  IBTWrite.AddDatabase(IBDB);
  IbDb.AddTransaction(IBTWrite);
  WriteIBQ.Transaction:=IBTWrite;
  WriteIBQ.Database:=IbDb;
end;


//------------  добавление нового сотрудника  ------------
procedure TFmWizJobAccept.AddNewEmp;
var
  EmpSQL, EmpPassportSQL, EmpStreetSQL,
  EmpDiplomSQL, EmpPlantSQL, EmpConnectSQL:String;
begin
  EmpSQL:=GetEmpSQL;
  EmpPassportSQL:=GetEmpPassportSQL;
  EmpStreetSQL:=GetEmpStreetSQL;
  EmpDiplomSQL:=getEmpDiplomSQl;
  EmpPlantSQL:=getEmpPlantSQl;
  EmpConnectSQL:=getEmpConnectSQl;
  IBTWrite.StartTransaction;
  try
    WriteIBQ.SQL.Text:=EmpSQL;
    WriteIBQ.ExecSQL;
    if PermEmpPersDoc and (EmpPassportSQL<>'') then
    begin
      WriteIBQ.SQL.Text:=EmpPassportSQL;
      WriteIBQ.ExecSQL;
    end;
    if PermEmpStreet and (EmpStreetSQL<>'') then
    begin
      WriteIBQ.SQL.Text:=EmpStreetSQL;
      WriteIBQ.ExecSQL;
    end;
    if PermEmpDiplom and (EmpDiplomSQL<>'') then
    begin
      WriteIBQ.SQL.Text:=EmpDiplomSQL;
      WriteIBQ.ExecSQL;
    end;
    if PermEmpPlant and (EmpPlantSQL<>'') then
    begin
      WriteIBQ.SQL.Text:=EmpPlantSQL;
      WriteIBQ.ExecSQL;
    end;
    if PermEmpConnect and (EmpConnectSQL<>'') then
    begin
      WriteIBQ.SQL.Text:=EmpConnectSQL;
      WriteIBQ.ExecSQL;
    end;
    IBTWrite.Commit;
    Close;
  except
    IBTWrite.Rollback;
  end;

end;
//*************

function TFmWizJobAccept.CheckEmpData: Boolean;
begin
  Result:=true;
  if trim(edFname.Text)='' then
  begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbFname.Caption]));
    Pc.ActivePageIndex:=0;
    SetBtnsEnable;
    edFname.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edname.Text)='' then
  begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbname.Caption]));
    Pc.ActivePageIndex:=0;
    SetBtnsEnable;
    edname.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edsname.Text)='' then
  begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbsname.Caption]));
    Pc.ActivePageIndex:=0;
    SetBtnsEnable;
    edsname.SetFocus;
    Result:=false;
    exit;
  end;

  if trim(edSex.Text)='' then
  begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbSex.Caption]));
    Pc.ActivePageIndex:=0;
    SetBtnsEnable;
    btCallSex.SetFocus;
    Result:=false;
    exit;
  end;

  if trim(edNationname.Text)='' then
  begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbNation.Caption]));
    Pc.ActivePageIndex:=0;
    SetBtnsEnable;
    btCallNation.SetFocus;
    Result:=false;
    exit;
  end;

  if trim(edCountry.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbCountry.Caption]));
    Pc.ActivePageIndex:=0;
    SetBtnsEnable;
    btCallCountry.SetFocus;
    Result:=false;
    exit;
  end;
  if (trim(edTown.Text)='')and(trim(edPlaceMent.Text)='') then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbTown.Caption]));
    Pc.ActivePageIndex:=0;
    SetBtnsEnable;
    btCallTown.SetFocus;
    Result:=false;
    exit;
  end;
  if (trim(edTown.Text)<>'')and(trim(edPlaceMent.Text)<>'') then begin
    ShowError(Handle,Format(ConstFieldEmpty,[lbPlaceMent.Caption]));
    Pc.ActivePageIndex:=0;
    SetBtnsEnable;
    btCallPlaceMent.SetFocus;
    Result:=false;
    exit;
  end;

  if trim(edFamilyStateName.Text)='' then
  begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbFamilyState.Caption]));
    Pc.ActivePageIndex:=1;
    SetBtnsEnable;
    btCallFamState.SetFocus;
    Result:=false;
    exit;
  end;

  if trim(edTabNum.Text)='' then
  begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbTabNum.Caption]));
    Pc.ActivePageIndex:=1;
    SetBtnsEnable;
    EdTabNum.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edPerscardnum.Text)='' then
  begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbPerscardnum.Caption]));
    Pc.ActivePageIndex:=1;
    SetBtnsEnable;
    edPerscardnum.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edInn.Text)<>'' then
  begin
    if Length(Trim(edInn.Text))<>DomainINNLength then
    begin
     ShowError(Handle,Format(ConstFieldLengthInvalid,[lbInn.Caption,DomainINNLength]));
     Pc.ActivePageIndex:=1;
     SetBtnsEnable;
     edInn.SetFocus;
     Result:=false;
     exit;
    end;
    if not isInteger(edInn.Text) then
    begin
      ShowError(Handle,Format(ConstFieldFormatInvalid,[lbInn.Caption]));
      Pc.ActivePageIndex:=1;
      SetBtnsEnable;
      edInn.SetFocus;
      Result:=false;
      exit;
    end;
  end;
end;


function TFmWizJobAccept.GetEmpSQL:string;
begin
  Emp_id:=GetGenId(IBDB,tbEmp,1);
  Result:='Insert into '+tbEmp+
    ' (emp_id, sex_id,familystate_id, nation_id, fname,'+
    ' name, sname, perscardnum, tabnum, birthdate,'+
    ' continioussenioritydate,inn, country_id, region_id,'+
          'state_id, town_id, placement_id) values '+
    ' ('+
    IntToStr(Emp_id)+','+
    inttostr(Sex_id)+','+
    inttostr(familystate_id)+','+
    inttostr(nation_id)+','+
    QuotedStr(Trim(edFname.Text))+','+
    QuotedStr(Trim(edname.Text))+','+
    QuotedStr(Trim(edSname.Text))+','+
    QuotedStr(Trim(edPerscardnum.Text))+','+
    Trim(edTabNum.Text)+','+
    QuotedStr(DateToStr(dpBirthDate.Date))+','+
    QuotedStr(DateToStr(DPSeniotity.Date))+','+
    GetStrFromCondition(Trim(EdINN.Text)<>'', QuotedStr(Trim(EdINN.Text)), 'null')+', '+
    GetStrFromCondition(Trim(edCountry.Text)<>'',inttostr(country_id),'null')+','+
    GetStrFromCondition(Trim(edRegion.Text)<>'',inttostr(region_id),'null')+','+
    GetStrFromCondition(Trim(edState.Text)<>'',inttostr(state_id),'null')+','+
    GetStrFromCondition(Trim(edTown.Text)<>'',inttostr(town_id),'null')+','+
    GetStrFromCondition(Trim(edplacement.Text)<>'',inttostr(placement_id),'null')+
     ')';

end;


function TFmWizJobAccept.GetEmpPassportSQL:string;
begin
  if not CheckEmpPassport then Result:='' else
  Result:='Insert into '+tbEmpPersonDoc+
    ' (persondoctype_id,emp_id,plant_id,serial,num,datewhere) values '+
    ' ('+
    inttostr(EmpPassport_id)+','+
    inttostr(emp_id)+','+
    inttostr(plant_id)+','+
    QuotedStr(Trim(msedSerial.Text))+','+
    QuotedStr(Trim(msedNum.Text))+','+
    GetStrFromCondition(dtpDateWhere.Checked,
    QuotedStr(DateTimeToStr(dtpDateWhere.Date)),'null')+')';
end;


function TFmWizJobAccept.GetEmpStreetSQL:string;
var
  id: string;
begin
  if not CheckEmpStreet then Result:='' else
  begin
    id:=inttostr(GetGenId(IBDB,tbEmpStreet,1));
    Result:='Insert into '+tbEmpStreet+
      ' (empstreet_id,street_id,emp_id,typelive_id,housenum,buildnum,flatnum) values '+
      ' ('+
      id+','+
      inttostr(street_id)+','+
      inttostr(emp_id)+','+
      inttostr(typelive_id)+','+
      QuotedStr(Trim(edhousenum.Text))+','+
      GetStrFromCondition(Trim(edbuildnum.Text)<>'',
        QuotedStr(Trim(edbuildnum.Text)),'null')+', '+
      QuotedStr(Trim(edflatnum.Text))+')';
  end;
end;

function TFmWizJobAccept.getEmpDiplomSQl:String;
var
  id: string;
begin
  if not CheckEmpDiplom then result:='' else
  begin
    id:=inttostr(GetGenId(IBDB,tbDiplom,1));
    Result:='Insert into '+tbDiplom+
      ' (emp_id,diplom_id,educ_id,school_id,craft_id,typestud_id,'+
      'profession_id,num,datewhere,finishdate) values '+
      ' ('+
      inttostr(emp_id)+','+
      id+','+
      inttostr(educ_id)+','+
      inttostr(school_id)+','+
      inttostr(craft_id)+','+
      inttostr(typestud_id)+','+
      inttostr(profession_id)+','+
      QuotedStr(Trim(edNum.Text))+','+
      QuotedStr(DateTimeToStr(dtpDiplomDateWhere.Date))+','+
      QuotedStr(DateTimeToStr(dtpFinishDate.Date))+
      ')';
  end;
end;

function TFmWizJobAccept.getEmpPlantSQl:String;
var
  id: string;
begin
  if not CheckEmpPlant then result:='' else
  begin
    id:=inttostr(GetGenId(IBDB,tbEmpPlant,1));
    Result:='Insert into '+tbEmpPlant+
      ' (empplant_id,emp_id,net_id,class_id,plant_id,reasondocum_id,'+
      'category_id,seat_id,depart_id,orderdocum_id,prof_id,'+
      'datestart) values '+
      ' ('+
      id+','+
      inttostr(emp_id)+','+
      inttostr(net_id)+','+
      inttostr(class_id)+','+
      inttostr(CurPlant_id{plant_id})+','+
      inttostr(reasondocum_id)+','+
      inttostr(category_id)+','+
      inttostr(seat_id)+','+
      inttostr(depart_id)+','+
      inttostr(orderdocum_id)+','+
      inttostr(prof_id)+','+
      QuotedStr(DateTimeToStr(dtpDateStart.Date))+')';
  end;
end;

function TFmWizJobAccept.getEmpConnectSQl:String;
var
  id: string;
begin
  if not CheckEmpConnect then Result:='' else
  begin
    id:=inttostr(GetGenId(IBDB,tbEmpConnect,1));
    Result:='Insert into '+tbEmpConnect+
          ' (empconnect_id,connectiontype_id,emp_id,connectstring) values '+
          ' ('+
          id+','+
          inttostr(connectiontype_id)+','+
          inttostr(emp_id)+','+
          QuotedStr(Trim(edConnectionString.Text))+')';
  end;
end;

procedure TFmWizJobAccept.btFinishClick(Sender: TObject);
begin
  if CheckEmpData=false then exit;
  AddNewEmp;
end;

function TFmWizJobAccept.CheckEmpPassport:Boolean;
begin
  Result:=true;
  if trim(edPlantName.Text)='' then
  begin
    //ShowError(Handle,Format(ConstFieldNoEmpty,[lbPlantName.Caption]));
    //btCallPlantName.SetFocus;
    Result:=false;
    exit;
  end;
end;


function TFmWizJobAccept.CheckEmpStreet:Boolean;
begin
  Result:=true;
  if trim(edhousenum.Text)='' then
  begin
    {ShowError(Handle,Format(ConstFieldNoEmpty,[lbNum.Caption]));
    edNum.SetFocus;}
    Result:=false;
    exit;
  end;
  if trim(edStreet.Text)='' then
  begin
    {ShowError(Handle,Format(ConstFieldNoEmpty,[lbStreet.Caption]));
    btCallStreet.SetFocus;}
    Result:=false;
    exit;
  end;
  if trim(edTypeLive.Text)='' then
  begin
    {ShowError(Handle,Format(ConstFieldNoEmpty,[lbTypeLive.Caption]));
    btCallTypeLive.SetFocus;}
    Result:=false;
    exit;
  end;
end;

function TFmWizJobAccept.CheckEmpDiplom:Boolean;
begin
  Result:=true;
  if trim(edProfession.Text)='' then
  begin
    {ShowError(Handle,Format(ConstFieldNoEmpty,[lbProfession.Caption]));
    btCallProfession.SetFocus;}
    Result:=false;
    exit;
  end;
  if trim(edTypeStud.Text)='' then
  begin
    {ShowError(Handle,Format(ConstFieldNoEmpty,[lbTypeStud.Caption]));
    btCallTypeStud.SetFocus;}
    Result:=false;
    exit;
  end;
  if trim(edEduc.Text)='' then begin
    {ShowError(Handle,Format(ConstFieldNoEmpty,[lbEduc.Caption]));
    btCallEduc.SetFocus;}
    Result:=false;
    exit;
  end;
  if trim(edCraft.Text)='' then
  begin
    {ShowError(Handle,Format(ConstFieldNoEmpty,[lbCraft.Caption]));
    btCallCraft.SetFocus;}
    Result:=false;
    exit;
  end;
  if trim(edSchool.Text)='' then
  begin
    {ShowError(Handle,Format(ConstFieldNoEmpty,[lbSchool.Caption]));
    bibSchool.SetFocus;}
    Result:=false;
    exit;
  end;
  if trim(edNum.Text)='' then
  begin
    {ShowError(Handle,Format(ConstFieldNoEmpty,[lbNum.Caption]));
    edNum.SetFocus;}
    Result:=false;
    exit;
  end;
end;


function TFmWizJobAccept.CheckEmpPlant:Boolean;
begin
  Result:=true;
  if trim(ednet.Text)='' then
  begin
    {ShowError(Handle,Format(ConstFieldNoEmpty,[lbNet.Caption]));
    btCallnet.SetFocus;}
    Result:=false;
    exit;
  end;
  if trim(edClass.Text)='' then
  begin
    {ShowError(Handle,Format(ConstFieldNoEmpty,[lbClass.Caption]));
    btCallClass.SetFocus;}
    Result:=false;
    exit;
  end;
  if trim(edReasonDocum.Text)='' then
  begin
    {ShowError(Handle,Format(ConstFieldNoEmpty,[lbReasonDocum.Caption]));
    btCallReasonDocum.SetFocus;}
    Result:=false;
    exit;
  end;
  if trim(edCategory.Text)='' then
  begin
    {ShowError(Handle,Format(ConstFieldNoEmpty,[lbCategory.Caption]));
    btCallCategory.SetFocus;}
    Result:=false;
    exit;
  end;
  if trim(edSeat.Text)='' then
  begin
    {ShowError(Handle,Format(ConstFieldNoEmpty,[lbSeat.Caption]));
    btCallSeat.SetFocus;}
    Result:=false;
    exit;
  end;
  if trim(edDepart.Text)='' then
  begin
    {ShowError(Handle,Format(ConstFieldNoEmpty,[lbDepart.Caption]));
    btCallDepart.SetFocus;}
    Result:=false;
    exit;
  end;
  if trim(edOrderDocum.Text)='' then
  begin
    {ShowError(Handle,Format(ConstFieldNoEmpty,[lbOrderDocum.Caption]));
    btCallOrderDocum.SetFocus;}
    Result:=false;
    exit;
  end;
  if trim(edProf.Text)='' then
  begin
    {ShowError(Handle,Format(ConstFieldNoEmpty,[lbprof.Caption]));
    btCallprof.SetFocus;}
    Result:=false;
    exit;
  end;
{  if trim(edschedule.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbschedule.Caption]));
    btCallschedule.SetFocus;
    Result:=false;
    exit;
  end;}

end;

function TFmWizJobAccept.CheckEmpConnect:Boolean;
begin
  Result:=true;
  if trim(edConnectionType.Text)='' then
  begin
    {ShowError(Handle,Format(ConstFieldNoEmpty,[lbConnectionType.Caption]));
    bibConnectionType.SetFocus;}
    Result:=false;
    exit;
  end;
  if trim(edConnectionString.Text)='' then
  begin
    {ShowError(Handle,Format(ConstFieldNoEmpty,[lbConnectionString.Caption]));
    edConnectionString.SetFocus;}
    Result:=false;
    exit;
  end;
end;


procedure TFmWizJobAccept.btCallSexClick(Sender: TObject);
var
  P: PSexParams;
begin
 try
  getMem(P,sizeof(TSexParams));
  try
   ZeroMemory(P,sizeof(TSexParams));
   P.sex_id:=sex_id;
   if _ViewEntryFromMain(tte_rbkssex,p,true) then begin
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

procedure TFmWizJobAccept.btCallConnectionTypeClick(Sender: TObject);
var
  P: PConnectiontypeParams;
begin
 try
  getMem(P,sizeof(TConnectiontypeParams));
  try
   ZeroMemory(P,sizeof(TConnectiontypeParams));
   P.connectiontype_id:=connectiontype_id;
   if _ViewEntryFromMain(tte_rbksconnectiontype,p,true) then
   begin
     connectiontype_id:=P.connectiontype_id;
     edConnectionType.Text:=P.name;
   end;
  finally
    FreeMem(P,sizeof(TConnectiontypeParams));
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TFmWizJobAccept.CheckPermission;
begin
  PermEmpPersDoc:=_isPermission(tbEmpPersonDoc,InsConst);
  msedSerial.Enabled:=PermEmpPersDoc;
  msedNum.Enabled:=PermEmpPersDoc;
  dtpDateWhere.Enabled:=PermEmpPersDoc;
  btCallPlantName.Enabled:=PermEmpPersDoc;
  edPlantName.Enabled:=PermEmpPersDoc;
  if PermEmpPersDoc then getEmpPassport_id;

  PermEmpStreet:=_isPermission(tbEmpStreet,InsConst);
  edbuildnum.Enabled:=PermEmpStreet;
  edflatnum.Enabled:=PermEmpStreet;
  edflatnum.Enabled:=PermEmpStreet;
  btCallTypeLive.Enabled:=PermEmpStreet;
  btCallStreet.Enabled:=PermEmpStreet;

  PermEmpConnect:=_isPermission(tbEmpConnect ,InsConst);
  edConnectionType.Enabled:=PermEmpConnect;
  edConnectionString.Enabled:=PermEmpConnect;
  btCallConnectionType.Enabled:=PermEmpConnect;

  PermEmpDiplom:=_isPermission(tbDiplom,InsConst);
  if not PermEmpDiplom then TSDiplom.PageControl:=nil else
  begin
    TSDiplom.PageControl:=PC;
    TSDiplom.PageIndex:=3;
  end;

  PermEmpPlant:=_isPermission(tbEmpPlant,InsConst);
  if not PermEmpPlant then TSEmpPlant.PageControl:=nil else
    TSEmpPlant.PageControl:=PC;

  PC.ActivePage:=TSMain;
  SetPageCNTRFocus;
  SetBtnsEnable;
end;

procedure TFmWizJobAccept.SetPageCNTRFocus;
begin
  if (pc.ActivePage = TsMain) and (EdFName.Showing) then EdFName.SetFocus;
  if pc.ActivePage = TS2 then
  begin
    if DPSeniotity.Enabled then
    DPSeniotity.SetFocus else if btCallConnectionType.Enabled then
      btCallConnectionType.Setfocus;
  end;

  if pc.ActivePage = TSPassport then
  begin
   if msedSerial.Enabled then msedSerial.Setfocus else
     if btCallTypeLive.Enabled then btCallTypeLive.SetFocus;
  end;

  if pc.ActivePage = TSDiplom then
  begin
    if btCallProfession.Enabled then btCallProfession.SetFocus;
  end;

  if pc.ActivePage = TSEmpPlant then
  begin
    if btCallNet.Enabled then btCallNet.SetFocus;
  end;
end;

procedure TFmWizJobAccept.btPriorClick(Sender: TObject);
begin
  inherited;
  SetPageCNTRFocus;
end;

procedure TFmWizJobAccept.btNextClick(Sender: TObject);
begin
  inherited;
  SetPageCNTRFocus;
end;

procedure TFmWizJobAccept.btCloseClick(Sender: TObject);
begin
  if ShowQuestion(Application.Handle,
   'Выйти из помошника без сохранения данных?')=mrYes then Close;
end;

procedure TFmWizJobAccept.SetPassportMasks;
var
  P: PPersonDocTypeParams;
begin
 try
  getMem(P,sizeof(TPersonDocTypeParams));
  try
   ZeroMemory(P,sizeof(TPersonDocTypeParams));
   P.id:=EmpPassport_id;
   if _ViewEntryFromMain(tte_rbkspersondoctype,P,true,true) then
   begin
     msedSerial.EditMask:=P.maskSeries;
     msedNum.EditMask:=P.masknum;
   end;
  finally
    FreeMem(P,sizeof(TPersonDocTypeParams));
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TFmWizJobAccept.btCallTabNumNextClick(Sender: TObject);
begin
  edTabNum.Text:=GetNextTabNum;
end;


function TFmWizJobAccept.GetNextTabNum: String;
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
    qr.Transaction:=IBTRead;
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


procedure TFmWizJobAccept.FormActivate(Sender: TObject);
begin
  inherited;
  SetPageCNTRFocus;
end;

procedure TFmWizJobAccept.btCallCountryClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='Country_id';
  TPRBI.Locate.KeyValues:=Country_id;
  TPRBI.Locate.Options:=[];
  if _ViewInterfaceFromName(NameRbkCountry,@TPRBI) then begin
    nation_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'Country_ID');
    edCountry.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'Name');
  end;
end;

procedure TFmWizJobAccept.btCallRegionClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='Region_id';
  TPRBI.Locate.KeyValues:=Region_id;
  TPRBI.Locate.Options:=[];
  if _ViewInterfaceFromName(NameRbkRegion,@TPRBI) then begin
    Region_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'Region_id');
    edregion.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'Name');
  end;
end;

procedure TFmWizJobAccept.btCallStateClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='State_id';
  TPRBI.Locate.KeyValues:=State_id;
  TPRBI.Locate.Options:=[];
  if _ViewInterfaceFromName(NameRbkState,@TPRBI) then begin
    State_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'State_id');
    edState.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'Name');
  end;
end;

procedure TFmWizJobAccept.btCallTownClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='Town_id';
  TPRBI.Locate.KeyValues:=Town_id;
  TPRBI.Locate.Options:=[];
  if _ViewInterfaceFromName(NameRbkTown,@TPRBI) then begin
    Town_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'Town_id');
    edTown.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'Name');
  end;
end;

procedure TFmWizJobAccept.btCallPlacementClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='Placement_id';
  TPRBI.Locate.KeyValues:=Placement_id;
  TPRBI.Locate.Options:=[];
  if _ViewInterfaceFromName(NameRbkPlacement,@TPRBI) then begin
    Placement_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'Placement_id');
    edplacement.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'Name');
  end;
end;


function TFmWizJobAccept.GetWhereStr(TypeEntry: Integer): string;
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

procedure TFmWizJobAccept.SetEmpConstant;
var
  P: PConstParams;
begin
 try
  GetMem(P,sizeof(TConstParams));
  try
    ZeroMemory(P,sizeof(TConstParams));
    if _ViewEntryFromMain(tte_const,p,false,true) then
    begin
      country_id:=P.country_id;
      edCountry.Text:=P.countryname;
      region_id:=P.region_id;
      regioncode:=P.regioncode;
      edregion.Text:=P.regionname;
      state_id:=P.state_id;
      statecode:=P.statecode;
      edstate.Text:=P.statename;
      town_id:=P.town_id;
      ConstEmpTownCode:=P.towncode;
      towncode:=P.towncode;
      edtown.Text:=P.townname;
      placement_id:=P.placement_id;
      placementcode:=P.placementcode;
      ConstPlaceCode:=P.placementcode;
      CurPlant_id:=P.plant_id;
      edplacement.Text:=P.placementname;
    end;
  finally
    FreeMem(P,sizeof(TConstParams));
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;
procedure TFmWizJobAccept.edtownKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    edtown.Clear;
    ChangeFlag:=true;
    town_id:=0;
    towncode:='';
  end;
end;

procedure TFmWizJobAccept.edplacementKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    edplacement.Clear;
    ChangeFlag:=true;
    placement_id:=0;
    placementcode:='';
  end;
end;

end.
