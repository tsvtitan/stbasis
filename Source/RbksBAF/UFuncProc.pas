unit UFuncProc; ///functions and procedures

interface
uses Windows, Forms, buttons, UConst, UMainUnited, classes, IBDatabase, IbQuery, graphics,
     Controls, dbgrids, sysUtils, Db, tsvDbGrid, dbtree, comctrls;

// Обязательные процедуры и функции для подключения к программе StBasis
//--------------------------------------------------------------------------
//процедура вызова информации об библиотеке
procedure InitAll_; stdcall;
procedure GetInfoLibrary_(P:PinfoLibrary); StdCall;// вызов структуры меню из DLL
procedure RefreshLibrary_;stdcall;// подключение DLL к приложению
procedure SetAppAndScreen_(A: TApplication; S: TScreen);stdcall;
procedure MenuClickProc(MenuHandle: THandle); stdcall;
// установление связи с базой данных
procedure SetConnection_(IBDbase: TIBDatabase; IBTran: TIBTransaction;
                         IBDBSecurity: TIBDatabase; IBTSecurity: TIBTransaction);stdcall;
function ViewInterface(InterfaceHandle: THandle; Param: Pointer): Boolean; stdcall;
function _CreateInterface(PCI: PCreateInterface): THandle;stdcall;
                          external MainExe name ConstCreateInterface;
function _CreatePermissionForInterface(InterfaceHandle: THandle; PCPFI: PCreatePermissionForInterface): Boolean;stdcall;
                external MainExe name ConstCreatePermissionForInterface;

function _CreateMenu(ParentHandle: THandle; PCM: PCreateMenu):THandle;stdcall;
                     external MainExe name ConstCreateMenu;
function _GetMenuHandleFromName(ParentHandle: THandle; Name: PChar): THandle;stdcall;
                                external MainExe name ConstGetMenuHandleFromName;
procedure AfterSetOptions_(isOK: Boolean);stdcall;

//--------------------------------------------------------------------------
//<<<<<<<<<<<<  импортируемые процедуры и функции  >>>>>>>>>>>>>>>>>>>>>>>>>
procedure _MainFormKeyDown(var Key: Word; Shift: TShiftState);stdcall;
                         external MainExe name ConstMainFormKeyDown;
procedure _MainFormKeyUp(var Key: Word; Shift: TShiftState);stdcall;
                         external MainExe name ConstMainFormKeyUp;
procedure _MainFormKeyPress(var Key: Char);stdcall;
                         external MainExe name ConstMainFormKeyPress;
//function _GetIniFileName: Pchar;stdcall; external MainExe name ConstGetIniFileName;
function _isPermission(sqlObject: PChar; sqlOperator: PChar): Boolean;stdcall;
                         external MainExe name ConstisPermission;
function _isPermissionSecurity(sqlObject: PChar; sqlOperator: PChar): Boolean;stdcall;
                         external MainExe name ConstisPermissionSecurity;
procedure _SetSplashStatus(Status: Pchar);stdcall;
                         external MainExe name ConstSetSplashStatus;
function _ViewEnterPeriod(P: PInfoEnterPeriod): Boolean;stdcall;
                         external MainExe name ConstViewEnterPeriod;
function _GetDateTimeFromServer: TDateTime;stdcall;
                         external MainExe name ConstGetDateTimeFromServer;
function _ViewInterfaceFromName(Name: PChar; Param: Pointer): Boolean; stdcall;
                                external MainExe name ConstViewInterfaceFromName;
function _FreeInterface(InterfaceHandle: THandle): Boolean;stdcall;
                        external MainExe name ConstFreeInterface;
function _FreeMenu(MenuHandle: THandle): Boolean;stdcall;
                   external MainExe name ConstFreeMenu;
function _CreateProgressBar(Min,Max: Integer;
                            Hint: PChar;
                            Color: TColor=clNavy;
                            List: TList=nil): DWord; stdcall;
                         external MainExe name ConstCreateProgressBar;
procedure _SetProgressStatus(Handle: DWord; Progress: Integer);stdcall;
                         external MainExe name ConstSetProgressBarStatus;
procedure _FreeProgressBar(Handle: DWord);stdcall;
                         external MainExe name ConstFreeProgressBar;
//--------------------------------------------------------------------------

// заполнение списка интерфейсов (справочников)
procedure AddToListInterfaceHandles;
//заполнение списка меню
procedure AddToListMenuRootHandles;
procedure ClearListInterfaceHandles;
procedure ClearListMenuHandles;
function isPermissionOnInterfaceView(InterfaceHandle: THandle): Boolean;


function isNotPermission(sqlObject: PChar; sqlOperator: PChar; Security: Boolean): Boolean;
function CreateAndViewCountry(InterfaceHandle: THandle; Param: PParamRBookInterface):Boolean;
function CreateAndViewStreet(InterfaceHandle: THandle; Param: PParamRBookInterface):Boolean;
function CreateAndViewRegion(InterfaceHandle: THandle; Param: PParamRBookInterface):Boolean;
function CreateAndViewTown(InterfaceHandle: THandle; Param: PParamRBookInterface):Boolean;
function CreateAndViewPlacement(InterfaceHandle: THandle; Param: PParamRBookInterface):Boolean;
function CreateAndViewState(InterfaceHandle: THandle; Param: PParamRBookInterface):Boolean;
function CreateAndViewProf(InterfaceHandle: THandle; Param: PParamRBookInterface):Boolean;
function CreateAndViewNation(InterfaceHandle: THandle; Param: PParamRBookInterface):Boolean;
function CreateAndViewMotive(InterfaceHandle: THandle; Param: PParamRBookInterface):Boolean;
function CreateAndViewPersonDocType(InterfaceHandle: THandle; Param: PParamRBookInterface):Boolean;
function CreateAndViewSeat(InterfaceHandle: THandle; Param: PParamRBookInterface):Boolean;
function CreateAndViewTypeDoc(InterfaceHandle: THandle; Param: PParamRBookInterface):Boolean;
function CreateAndViewTypeLeave(InterfaceHandle: THandle; Param: PParamRBookInterface):Boolean;
function CreateAndViewBank(InterfaceHandle: THandle; Param: PParamRBookInterface):Boolean;
function CreateAndViewDocum(InterfaceHandle: THandle; Param: PParamRBookInterface):Boolean;
function CreateAndViewAccountType(InterfaceHandle: THandle; Param: PParamRBookInterface):Boolean;
function CreateAndViewDepart(InterfaceHandle: THandle; Param: PParamRBookInterface):Boolean;
function CreateAndViewExperiencePercent(InterfaceHandle: THandle; Param: PParamRBookInterface):Boolean;
function CreateAndViewStandartOperation(InterfaceHandle: THandle; Param: PParamRBookInterface):Boolean;
function CreateAndViewStOperation_AcType(InterfaceHandle: THandle; Param: PParamRBookInterface):Boolean;

function CreateAndViewRptsPersCard_T2(InterfaceHandle: THandle; Param: PParamReportInterface): Boolean;
function CreateAndViewRptsEducation(InterfaceHandle: THandle; Param: PParamReportInterface): Boolean;
function CreateAndViewRptsMilRank(InterfaceHandle: THandle; Param: PParamReportInterface): Boolean;

procedure FreeCreatures;


implementation
uses URbk, UrbkEdit, URbkCountry, URbkStreet, URbkRegion, URbkTown,
UrbkPlacement, URbkState, UrbkProf, UrbkNation, UrbkMotive, URbkPersonDocType,
URbkSeat, URbkTypeDoc,URbkTypeLeave, URbkBank, URbkDocum, URbkAccountType,
URbkDepart,URbkExperiencePercent, URbkStandartOperation, URbkStOperation_AcType,
UrptsPersCard_T2, UrptsEducation, UrptsMilRank;{,UWizJobAccept, UrptsPerscard_T2;}

var
  isInitAll: Boolean=false;

procedure GetInfoLibrary_(P:PinfoLibrary); StdCall;
begin
  if P=nil then exit;
  P.Hint:=LibraryHint;
  P.TypeLib:=MainTypeLib;
end;

procedure InitAll_; stdcall;
begin
  ListInterfaceHandles:=TList.Create;
  AddToListInterfaceHandles;

  ListMenuHandles:=Tlist.Create;
  AddToListMenuRootHandles;

  isInitAll:=true;
end;


procedure AddToListInterfaceHandles;

  function CreateLocalInterface(Name,Hint: PChar; TypeInterface: TTypeInterface=ttiRBook): THandle;
  var
    TPCI: TCreateInterface;
  begin
    FillChar(TPCI,SizeOf(TCreateInterface),0);
    TPCI.Name:=Name;
    TPCI.Hint:=Hint;
    TPCI.ViewInterface:=ViewInterface;
    TPCI.TypeInterface:=TypeInterface;
    Result:=_CreateInterface(@TPCI);
    ListInterfaceHandles.Add(Pointer(Result));
  end;

  function CreateLocalPermission(InterfaceHandle: THandle;
                                 DBObject: PChar;
                                 DBPermission: TTypeDBPermission=ttpSelect;
                                 DBSystem: Boolean=false;
                                 Action: TTypeInterfaceAction=ttiaView): Boolean;
  var
     TCPFI: TCreatePermissionForInterface;
  begin
     FillCHar(TCPFI,SizeOf(TCreatePermissionForInterface),0);
     TCPFI.Action:=Action;
     TCPFI.DBObject:=DBObject;
     TCPFI.DBPermission:=DBPermission;
     TCPFI.DBSystem:=DBSystem;
     Result:=_CreatePermissionForInterface(InterfaceHandle,@TCPFI);
  end;


begin
  hInterfaceCountry:=CreateLocalInterface(NameCountry,NameCountry);
  CreateLocalPermission(hInterfaceCountry,tbCountry,ttpSelect,false);
  CreateLocalPermission(hInterfaceCountry,tbCountry,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceCountry,tbCountry,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceCountry,tbCountry,ttpDelete,false,ttiaDelete);

  hInterfaceRegion:=CreateLocalInterface(NameRegion,NameRegion);
  CreateLocalPermission(hInterfaceRegion,tbregion,ttpSelect,false);
  CreateLocalPermission(hInterfaceRegion,tbregion,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRegion,tbregion,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRegion,tbregion,ttpDelete,false,ttiaDelete);

  hInterfaceState:=CreateLocalInterface(NameState,NameState);
  CreateLocalPermission(hInterfaceState,tbState,ttpSelect,false);
  CreateLocalPermission(hInterfaceState,tbState,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceState,tbState,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceState,tbState,ttpDelete,false,ttiaDelete);

  hInterfaceTown:=CreateLocalInterface(NameTown, NameTown);
  CreateLocalPermission(hInterfaceTown,tbTown,ttpSelect,false);
  CreateLocalPermission(hInterfaceTown,tbTown,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceTown,tbTown,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceTown,tbTown,ttpDelete,false,ttiaDelete);

  hInterfaceStreet:=CreateLocalInterface(NameStreet,NameStreet);
  CreateLocalPermission(hInterfaceStreet,tbStreet,ttpSelect,false);
  CreateLocalPermission(hInterfaceStreet,tbStreet,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceStreet,tbStreet,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceStreet,tbStreet,ttpDelete,false,ttiaDelete);

  hInterfacePlacement:=CreateLocalInterface(NamePlacement,NamePlacement);
  CreateLocalPermission(hInterfacePlacement,tbPlacement,ttpSelect,false);
  CreateLocalPermission(hInterfacePlacement,tbPlacement,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfacePlacement,tbPlacement,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfacePlacement,tbPlacement,ttpDelete,false,ttiaDelete);

  hInterfaceProf:=CreateLocalInterface(NameProf,NameProf);
  CreateLocalPermission(hInterfaceProf,tbProf,ttpSelect,false);
  CreateLocalPermission(hInterfaceProf,tbProf,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceProf,tbProf,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceProf,tbProf,ttpDelete,false,ttiaDelete);

  hInterfaceNation:=CreateLocalInterface(NameNation, NameNation);
  CreateLocalPermission(hInterfaceNation,tbNation,ttpSelect,false);
  CreateLocalPermission(hInterfaceNation,tbNation,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceNation,tbNation,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceNation,tbNation,ttpDelete,false,ttiaDelete);

  hInterfaceMotive:=CreateLocalInterface(NameMotive, NameMotive);
  CreateLocalPermission(hInterfaceMotive,tbMotive,ttpSelect,false);
  CreateLocalPermission(hInterfaceMotive,tbMotive,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceMotive,tbMotive,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceMotive,tbMotive,ttpDelete,false,ttiaDelete);

  hInterfacePersonDocType:=CreateLocalInterface(NamePersonDocType, NamePersonDocType);
  CreateLocalPermission(hInterfacePersonDocType,tbPersonDocType,ttpSelect,false);
  CreateLocalPermission(hInterfacePersonDocType,tbPersonDocType,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfacePersonDocType,tbPersonDocType,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfacePersonDocType,tbPersonDocType,ttpDelete,false,ttiaDelete);

  hInterfaceSeat:=CreateLocalInterface(NameSeat, NameSeat);
  CreateLocalPermission(hInterfaceSeat,tbSeat,ttpSelect,false);
  CreateLocalPermission(hInterfaceSeat,tbSeat,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceSeat,tbSeat,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceSeat,tbSeat,ttpDelete,false,ttiaDelete);

{  hInterfaceTypeDoc:=CreateLocalInterface(NameTypeDoc, NameTypeDoc);
  CreateLocalPermission(hInterfaceTypeDoc,tbTypeDoc,ttpSelect,false);
  CreateLocalPermission(hInterfaceTypeDoc,tbTypeDoc,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceTypeDoc,tbTypeDoc,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceTypeDoc,tbTypeDoc,ttpDelete,false,ttiaDelete);}

  hInterfaceTypeLeave:=CreateLocalInterface(NameTypeLeave, NameTypeLeave);
  CreateLocalPermission(hInterfaceTypeLeave,tbTypeLeave,ttpSelect,false);
  CreateLocalPermission(hInterfaceTypeLeave,tbTypeLeave,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceTypeLeave,tbTypeLeave,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceTypeLeave,tbTypeLeave,ttpDelete,false,ttiaDelete);

  hInterfaceBank:=CreateLocalInterface(NameBank, NameBank);
  CreateLocalPermission(hInterfaceBank,tbBank,ttpSelect,false);
  CreateLocalPermission(hInterfaceBank,tbBank,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceBank,tbBank,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceBank,tbBank,ttpDelete,false,ttiaDelete);

{  hInterfaceDocum:=CreateLocalInterface(NameDocum, NameDocum);
  CreateLocalPermission(hInterfaceDocum,tbDocum,ttpSelect,false);
  CreateLocalPermission(hInterfaceDocum,tbDocum,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceDocum,tbDocum,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceDocum,tbDocum,ttpDelete,false,ttiaDelete);}

  hInterfaceAccountType:=CreateLocalInterface(NameAccountType, NameAccountType);
  CreateLocalPermission(hInterfaceAccountType,tbAccountType,ttpSelect,false);
  CreateLocalPermission(hInterfaceAccountType,tbAccountType,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceAccountType,tbAccountType,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceAccountType,tbAccountType,ttpDelete,false,ttiaDelete);

  hInterfaceDepart:=CreateLocalInterface(NameDepart, NameDepart);
  CreateLocalPermission(hInterfaceDepart,tbDepart,ttpSelect,false);
  CreateLocalPermission(hInterfaceDepart,tbDepart,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceDepart,tbDepart,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceDepart,tbDepart,ttpDelete,false,ttiaDelete);

  hInterfaceExperiencePercent:=CreateLocalInterface(NameExperiencePercent, NameExperiencePercent);
  CreateLocalPermission(hInterfaceExperiencePercent,tbExperiencePercent,ttpSelect,false);
  CreateLocalPermission(hInterfaceExperiencePercent,tbExperiencePercent,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceExperiencePercent,tbExperiencePercent,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceExperiencePercent,tbExperiencePercent,ttpDelete,false,ttiaDelete);
  CreateLocalPermission(hInterfaceExperiencePercent,tbTypepay,ttpSelect,false);
  CreateLocalPermission(hInterfaceExperiencePercent,tbTypepay,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceExperiencePercent,tbTypepay,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceExperiencePercent,tbTypepay,ttpDelete,false,ttiaDelete);

  hInterfaceStandartOperation:=CreateLocalInterface(NameStandartOperation, NameStandartOperation);
  CreateLocalPermission(hInterfaceStandartOperation,tbStandartOperation,ttpSelect,false);
  CreateLocalPermission(hInterfaceStandartOperation,tbStandartOperation,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceStandartOperation,tbStandartOperation,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceStandartOperation,tbStandartOperation,ttpDelete,false,ttiaDelete);

  hInterfaceStOperation_AcType:=CreateLocalInterface(NameStOperation_AccountType, NameStOperation_AccountType);
  CreateLocalPermission(hInterfaceStOperation_AcType,tbStOperation_AcType,ttpSelect,false);
  CreateLocalPermission(hInterfaceStOperation_AcType,tbStOperation_AcType,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceStOperation_AcType,tbStOperation_AcType,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceStOperation_AcType,tbStOperation_AcType,ttpDelete,false,ttiaDelete);


//ни дохера ли тут таблиц проверяется?
  hInterfaceRptPersCard_T2 :=CreateLocalInterface(NameRptsPersCard_T2, NameRptsPersCard_T2);
  CreateLocalPermission(hInterfaceRptPersCard_T2,tbEmp,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptPersCard_T2,tbConst,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptPersCard_T2,tbplant,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptPersCard_T2,tbSex,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptPersCard_T2,tbCountry,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptPersCard_T2,tbFamilyState,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptPersCard_T2,tbPersondocType,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptPersCard_T2,tbCountry,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptPersCard_T2,tbSchool,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptPersCard_T2,tbTypeStud,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptPersCard_T2,tbDiplom,ttpSelect,false);

  hInterfaceRptsEducation:=CreateLocalInterface(NameRptsEducation, NameRptsEducation);
  CreateLocalPermission(hInterfaceRptsEducation, tbEduc, ttpSelect,false);
  CreateLocalPermission(hInterfaceRptsEducation, tbDiplom, ttpSelect,false);
  CreateLocalPermission(hInterfaceRptsEducation, tbProfession, ttpSelect,false);
  CreateLocalPermission(hInterfaceRptsEducation, tbEmp, ttpSelect,false);

  hInterfaceRptsMilRank:=CreateLocalInterface(NameRptsMilRank, NameRptsMilRank);
  CreateLocalPermission(hInterfaceRptsMilRank, tbmilRank, ttpSelect,false);
  CreateLocalPermission(hInterfaceRptsMilRank, tbmilitary, ttpSelect,false);
  CreateLocalPermission(hInterfaceRptsMilRank, tbEmp, ttpSelect,false);

end;


function isPermissionOnInterfaceView(InterfaceHandle: THandle): Boolean;
var
    isRemove: Boolean;
begin
    isRemove:=false;
    if InterfaceHandle=hInterfaceCountry then
    begin
      isRemove:=not _isPermissionOnInterface(hInterfaceCountry,ttiaView);
      if isRemove then FreeAndNil(fmRBkCountry)
      else if fmRBkCountry<>nil then begin
       fmRBkCountry.SetInterfaceHandle(InterfaceHandle);
       fmRBkCountry.RefreshQuery(true);
      end;
    end;

    if InterfaceHandle=hInterfaceRegion then
    begin
      isRemove:=not _isPermissionOnInterface(hInterfaceRegion,ttiaView);
      if isRemove then FreeAndNil(fmRBkRegion)
      else if fmRBkRegion<>nil then begin
       fmRBkRegion.SetInterfaceHandle(InterfaceHandle);
       fmRBkRegion.RefreshQuery(true);
      end;
    end;

    if InterfaceHandle=hInterfaceState then
    begin
      isRemove:=not _isPermissionOnInterface(hInterfaceState,ttiaView);
      if isRemove then FreeAndNil(fmRBkState)
      else if fmRBkState<>nil then begin
       fmRBkState.SetInterfaceHandle(InterfaceHandle);
       fmRBkState.RefreshQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceTown then
    begin
      isRemove:=not _isPermissionOnInterface(hInterfaceTown,ttiaView);
      if isRemove then FreeAndNil(fmRBkTown)
      else if fmRBkTown<>nil then begin
       fmRBkTown.SetInterfaceHandle(InterfaceHandle);
       fmRBkTown.RefreshQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceStreet then
    begin
      isRemove:=not _isPermissionOnInterface(hInterfaceStreet,ttiaView);
      if isRemove then FreeAndNil(fmRBkStreet)
      else if fmRBkStreet<>nil then begin
       fmRBkStreet.SetInterfaceHandle(InterfaceHandle);
       fmRBkStreet.RefreshQuery(true);
      end;
    end;

    if InterfaceHandle=hInterfaceprof then
    begin
      isRemove:=not _isPermissionOnInterface(hInterfaceProf,ttiaView);
      if isRemove then FreeAndNil(fmRBkProf)
      else if fmRBkProf<>nil then begin
       fmRBkProf.SetInterfaceHandle(InterfaceHandle);
       fmRBkProf.RefreshQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceNation then
    begin
      isRemove:=not _isPermissionOnInterface(hInterfaceNation,ttiaView);
      if isRemove then FreeAndNil(fmRBkNation)
      else if fmRBkNation<>nil then begin
       fmRBkNation.SetInterfaceHandle(InterfaceHandle);
       fmRBkNation.RefreshQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceMotive then
    begin
      isRemove:=not _isPermissionOnInterface(hInterfaceMotive,ttiaView);
      if isRemove then FreeAndNil(fmRBkMotive)
      else if fmRBkMotive<>nil then begin
       fmRBkMotive.SetInterfaceHandle(InterfaceHandle);
       fmRBkMotive.RefreshQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfacePersonDocType then
    begin
      isRemove:=not _isPermissionOnInterface(hInterfacePersonDocType,ttiaView);
      if isRemove then FreeAndNil(FmRbkPersonDocType)
      else if FmRbkPersonDocType<>nil then begin
       FmRbkPersonDocType.SetInterfaceHandle(InterfaceHandle);
       FmRbkPersonDocType.RefreshQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceSeat then
    begin
      isRemove:=not _isPermissionOnInterface(hInterfaceSeat,ttiaView);
      if isRemove then FreeAndNil(FmRbkSeat)
      else if FmRbkSeat<>nil then
      begin
       FmRbkSeat.SetInterfaceHandle(InterfaceHandle);
       FmRbkSeat.RefreshQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceTypeDoc then
    begin
      isRemove:=not _isPermissionOnInterface(hInterfaceTypeDoc,ttiaView);
      if isRemove then FreeAndNil(FmRbkTypeDoc)
      else if FmRbkTypeDoc<>nil then
      begin
       FmRbkTypeDoc.SetInterfaceHandle(InterfaceHandle);
       FmRbkTypeDoc.RefreshQuery(true);
      end;
    end;

    if InterfaceHandle=hInterfaceTypeLeave then
    begin
      isRemove:=not _isPermissionOnInterface(hInterfaceTypeLeave,ttiaView);
      if isRemove then FreeAndNil(FmRbkTypeLeave)
      else if FmRbkTypeLeave<>nil then
      begin
       FmRbkTypeLeave.SetInterfaceHandle(InterfaceHandle);
       FmRbkTypeLeave.RefreshQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceBank then
    begin
      isRemove:=not _isPermissionOnInterface(hInterfaceBank,ttiaView);
      if isRemove then FreeAndNil(FmRbkBank)
      else if FmRbkBank<>nil then
      begin
       FmRbkBank.SetInterfaceHandle(InterfaceHandle);
       FmRbkBank.RefreshQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceDocum then
    begin
      isRemove:=not _isPermissionOnInterface(hInterfaceDocum,ttiaView);
      if isRemove then FreeAndNil(FmRbkDocum)
      else if FmRbkDocum<>nil then
      begin
       FmRbkDocum.SetInterfaceHandle(InterfaceHandle);
       FmRbkDocum.RefreshQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceAccountType then
    begin
      isRemove:=not _isPermissionOnInterface(hInterfaceAccountType,ttiaView);
      if isRemove then FreeAndNil(FmRbkAccountType)
      else if FmRbkAccountType<>nil then
      begin
       FmRbkAccountType.SetInterfaceHandle(InterfaceHandle);
       FmRbkAccountType.RefreshQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceDepart then
    begin
      isRemove:=not _isPermissionOnInterface(hInterfaceDepart,ttiaView);
      if isRemove then FreeAndNil(FmRbkDepart)
      else if FmRbkDepart<>nil then
      begin
       FmRbkDepart.SetInterfaceHandle(InterfaceHandle);
       FmRbkDepart.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceExperiencePercent then
    begin
      isRemove:=not _isPermissionOnInterface(hInterfaceExperiencePercent,ttiaView);
      if isRemove then FreeAndNil(FmRbkExperiencePercent)
      else if FmRbkExperiencePercent<>nil then
      begin
       FmRbkExperiencePercent.SetInterfaceHandle(InterfaceHandle);
       FmRbkExperiencePercent.RefreshQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceStandartOperation then
    begin
      isRemove:=not _isPermissionOnInterface(hInterfaceStandartOperation,ttiaView);
      if isRemove then FreeAndNil(FmRbkStandartOperation)
      else if FmRbkStandartOperation<>nil then
      begin
       FmRbkStandartOperation.SetInterfaceHandle(InterfaceHandle);
       FmRbkStandartOperation.RefreshQuery(true);
      end;
    end;

    if InterfaceHandle=hInterfaceStOperation_AcType then
    begin
      isRemove:=not _isPermissionOnInterface(hInterfaceStOperation_AcType,ttiaView);
      if isRemove then FreeAndNil(FmRbkStOperation_AcType)
      else if FmRbkStOperation_AcType<>nil then
      begin
       FmRbkStOperation_AcType.SetInterfaceHandle(InterfaceHandle);
       FmRbkStOperation_AcType.RefreshQuery(true);
      end;
    end;

    if InterfaceHandle=hInterfaceRptPersCard_T2 then
    begin
      isRemove:=not _isPermissionOnInterface(hInterfaceRptPersCard_T2,ttiaView);
      if isRemove then FreeAndNil(fmRptsCard_T2);
    end;

    if InterfaceHandle=hInterfaceRptsEducation then
    begin
      isRemove:=not _isPermissionOnInterface(hInterfaceRptsEducation,ttiaView);
      if isRemove then FreeAndNil(fmRptsEducation);
    end;

    if InterfaceHandle=hInterfaceRptsMilRank then
    begin
      isRemove:=not _isPermissionOnInterface(hInterfaceRptsMilRank,ttiaView);
      if isRemove then FreeAndNil(fmRptsMilRank);
    end;
    result:=not isRemove;
end;



procedure AddToListMenuRootHandles;

  function CreateMenuLocal(ParentHandle: THandle; Name: PChar;
                           Hint: PChar;
                           TypeCreateMenu: TTypeCreateMenu=tcmAddLast;
                           InsertMenuHandle: THandle=MENU_INVALID_HANDLE;
                           ImageIndex: Integer=-1;
                           ShortCut: TShortCut=0;
                           Proc: TMenuClickProc=nil): THandle;
  var
   CMLocal: TCreateMenu;
   Image: TBitmap;
  begin
   Image:=nil;
   try
    Result:=MENU_INVALID_HANDLE;
    Image:=TBitmap.Create;
    FillChar(CMLocal,SizeOf(TCreateMenu),0);
    CMLocal.Name:=Name;
    CMLocal.Hint:=Hint;
    CMLocal.MenuClickProc:=Proc;
    CMLocal.TypeCreateMenu:=TypeCreateMenu;
    CMLocal.InsertMenuHandle:=InsertMenuHandle;
//    if ImageIndex<>-1 then begin
//     dm.IL.GetBitmap(ImageIndex,Image);
     CMLocal.Bitmap:=NIL;//Image;
//    end;
    Result:=_CreateMenu(ParentHandle,@CMLocal);
   finally
     Image.Free;
   end;
  end;

var
  hMenuStaff, hMenuAte, hMenuOTIZ, hMenuFinans, hMenuDocs,hMenuStf, hMenuAny : THandle;

  isfreeMenuStaff, isFreeMenuDelimetr, isFreeMenuAte, isFreeMenuOtiz, isfreeMenuFinans,
    isfreeMenuDocs, isfreeMenuStf, isfreeMenuAny, isfreeMenuRptsStaff, isfreeMenuRpts: Boolean;

begin
  ListMenuHandles.Clear;
  hMenuStaff:=CreateMenuLocal(MENU_ROOT_HANDLE,ConstsMenuRBooks,PChar(ChangeString(ConstsMenuRBooks,'&','')),
                              tcmInsertBefore,_GetMenuHandleFromName(MENU_ROOT_HANDLE,ConstsMenuService));
  ListMenuHandles.Add(Pointer(hMenuStaff));

  hMenuAte:=CreateMenuLocal(hMenuStaff,'Административно-территориальные единицы',
    'Административно-территориальные единицы', tcmAddLast);
  ListMenuHandles.Add(Pointer(hMenuAte));

  hMenuCountry:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceCountry) then
   hMenuCountry:=CreateMenuLocal(hMenuAte,'Cтраны',
   NameCountry, tcmAddLast, MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuRegion:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRegion) then
   hMenuRegion:=CreateMenuLocal(hMenuAte,'Края и областей',
   NameRegion, tcmAddLast, MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuState:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceState) then
   hMenuState:=CreateMenuLocal(hMenuAte,'Районы',
   NameState, tcmAddLast, MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuTown:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceTown) then
   hMenuTown:=CreateMenuLocal(hMenuAte,'Города',
   NameTown, tcmAddLast, MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuPlacement:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfacePlacement) then
   hMenuPlacement:=CreateMenuLocal(hMenuAte,'Населённые пункты',
   NamePlacement, tcmAddLast, MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuStreet:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceStreet) then
   hMenuStreet:=CreateMenuLocal(hMenuAte,'Улицы',
   NameStreet, tcmAddLast, MENU_INVALID_HANDLE,-1,0,MenuClickProc);


   isFreeMenuDelimetr:=(hMenuDelimetr<>MENU_INVALID_HANDLE) and (hMenuCountry=MENU_INVALID_HANDLE) and
     (HMenuRegion=MENU_INVALID_HANDLE) and (HMenuState=MENU_INVALID_HANDLE) and
     (HMenuTown=MENU_INVALID_HANDLE) and (HMenuPlacement=MENU_INVALID_HANDLE) and
     (hMenuStreet=MENU_INVALID_HANDLE);

   if isFreeMenuDelimetr then begin
     if _FreeMenu(hMenuDelimetr) then hMenuDelimetr:=MENU_INVALID_HANDLE;
   end else  hMenuDelimetr:=CreateMenuLocal(hMenuAte,'-','', tcmAddLast);

   hMenuNation:=MENU_INVALID_HANDLE;
   if isPermissionOnInterfaceView(hInterfaceNation) then
   hMenuNation:=CreateMenuLocal(hMenuAte,'Национальности', NameNation, tcmAddLast,
    MENU_INVALID_HANDLE,-1,0,MenuClickProc);

   isFreeMenuAte:=(hMenuAte<>MENU_INVALID_HANDLE) and (hMenuDelimetr=MENU_INVALID_HANDLE)and
     (HMenuNation=MENU_INVALID_HANDLE);
   if isFreeMenuAte then if _FreeMenu(hMenuAte) then hMenuAte:=MENU_INVALID_HANDLE;

// ------------------ Отиз ---------------------------------
  hMenuOTIZ:=CreateMenuLocal(hMenuStaff,'ОТИЗ','ОТИЗ', tcmAddLast);


  hMenuSeat:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hMenuSeat) then
  hMenuSeat:=CreateMenuLocal(hMenuOTIZ,'Должности', NameSeat, tcmAddLast,
    MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuDepart:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceDepart) then
  hMenuDepart:=CreateMenuLocal(hMenuOTIZ,'Отделы', NameDepart, tcmAddLast,
    MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuTypeLeave:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceTypeLeave) then
  hMenuTypeLeave:=CreateMenuLocal(hMenuOTIZ,'Виды отпусков', NameTypeLeave, tcmAddLast,
    MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  isFreeMenuOtiz:=(hMenuOTIZ<>MENU_INVALID_HANDLE) and (HMenuSeat=MENU_INVALID_HANDLE)
    and(hMenuDepart=MENU_INVALID_HANDLE) and (hMenuTypeLeave=MENU_INVALID_HANDLE);
  if isFreeMenuOtiz then if _FreeMenu(hMenuOTIZ) then hMenuOTIZ:=MENU_INVALID_HANDLE;

// ------------------ Финансы ------------------------------------
  hMenuFinans:=CreateMenuLocal(hMenuStaff,'Финансы','Финансы', tcmAddLast);

  hMenuBank:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceBank) then
  hMenuBank:=CreateMenuLocal(hMenuFinans,'Банки', NameBank, tcmAddLast,
    MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuAccountType:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceAccountType) then
  hMenuAccountType:=CreateMenuLocal(hMenuFinans,'Виды проводок', NameAccountType, tcmAddLast,
    MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuStandartOperation:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceStandartOperation) then
  hMenuStandartOperation:=CreateMenuLocal(hMenuFinans,'Стандартные операции',
  NameStandartOperation, tcmAddLast, MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuStOperation_AcType:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceStOperation_AcType) then
  hMenuStOperation_AcType:=CreateMenuLocal(hMenuFinans,'Стандартные операции - виды проводок',
  NameStOperation_AccountType, tcmAddLast, MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  isfreeMenuFinans:=(hMenuFinans<>MENU_INVALID_HANDLE) and (hMenuAccountType=MENU_INVALID_HANDLE)and
    (hMenuStandartOperation=MENU_INVALID_HANDLE)and(hMenuStOperation_AcType=MENU_INVALID_HANDLE);
  if isfreeMenuFinans then if _freeMenu(hMenuFinans) then hMenuFinans:=MENU_INVALID_HANDLE;
// -----------------------Документы--------------------------------
  hMenuDocs:=CreateMenuLocal(hMenuStaff,'Документы','Документы', tcmAddLast);

  hMenuMotive:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceMotive) then
  hMenuMotive:=CreateMenuLocal(hMenuDocs,'Причины увольнений', NameMotive, tcmAddLast,
  MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuPersonDocType:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfacePersonDocType) then
  hMenuPersonDocType:=CreateMenuLocal(hMenuDocs,'Виды документов удостоверяющих личность',
   NamePersonDocType, tcmAddLast, MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuTypeDoc:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceTypeDoc) then
  hMenuTypeDoc:=CreateMenuLocal(hMenuDocs,'Виды документов', NameTypeDoc, tcmAddLast,
    MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuDocum:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceDocum) then
  hMenuDocum:=CreateMenuLocal(hMenuDocs,'Документы', NameDocum, tcmAddLast,
    MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  isfreeMenuDocs:=(hMenuDocs<>MENU_INVALID_HANDLE) and (HMenuMotive=MENU_INVALID_HANDLE)and
  (HMenuPersonDocType=MENU_INVALID_HANDLE) and (hMenuTypeDoc=MENU_INVALID_HANDLE)and
  (hMenuDocum=MENU_INVALID_HANDLE);

  if isfreeMenuDocs then if _FreeMenu(hMenuDocs) then hMenuDocs:=MENU_INVALID_HANDLE;

//-------------------------Разное----------------------------------------
  hMenuStf:=CreateMenuLocal(hMenuStaff,ConstsMenuStaff,ConstsMenuStaff,tcmAddFirst);

  HMenuAny:=CreateMenuLocal(hMenuStf,ConstsMenuAny,'Другие справочники',tcmAddFirst);

  hMenuProf:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceProf) then
  hMenuProf:=CreateMenuLocal(hMenuAny,'Профессии', NameProf, tcmAddLast,
  MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuExperiencePercent:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceExperiencePercent) then
  hMenuExperiencePercent:=CreateMenuLocal(hMenuAny,'Проценты от стажа',
  NameExperiencePercent, tcmAddLast, MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  isfreeMenuAny:=(HMenuAny<>MENU_INVALID_HANDLE)and(HMenuProf=MENU_INVALID_HANDLE) and
    (hMenuExperiencePercent=MENU_INVALID_HANDLE);
  if isfreeMenuAny then if _FreeMenu(hMenuAny) then hMenuAny:=MENU_INVALID_HANDLE;

  isfreeMenuStf:=(hMenuStf<>MENU_INVALID_HANDLE) and (hmenuAny=MENU_INVALID_HANDLE);
  if isfreeMenuStf then if _FreeMenu(hMenuStf) then hMenuStf:=MENU_INVALID_HANDLE;


  isfreeMenuStaff:=(hMenuStaff<>MENU_INVALID_HANDLE) and (hMenuAte=MENU_INVALID_HANDLE)
    and (hMenuOTIZ=MENU_INVALID_HANDLE) and (hMenuFinans=MENU_INVALID_HANDLE) and
    (hMenuDocs=MENU_INVALID_HANDLE) and (hMenuStf=MENU_INVALID_HANDLE);

  if isfreeMenuStaff then
    if _FreeMenu(hMenuStaff) then hMenuStaff:=MENU_INVALID_HANDLE;


//-------------------------Отчёты по кадрам-------------------------------------
  hMenuRpts:=CreateMenuLocal(MENU_ROOT_HANDLE,ConstsMenuReports,PChar(ChangeString(ConstsMenuReports,'&','')),
                               tcmInsertBefore,_GetMenuHandleFromName(MENU_ROOT_HANDLE,ConstsMenuService));
  ListMenuHandles.Add(Pointer(hMenuRpts));

  hMenuRptsStaff:=CreateMenuLocal(hMenuRpts,ConstsMenuRptStaff,ConstsMenuRptStaff,tcmAddFirst);

  hMenuRptPersCard_T2:=MENU_INVALID_HANDLE;
  hMenuRptPersCard_T2:=CreateMenuLocal(hMenuRptsStaff,'Личная карточка Т2','Личная карточка Т2',tcmAddFirst,
    MENU_INVALID_HANDLE,-1,0,MenuClickProc);
  hMenuRptsEducation:=MENU_INVALID_HANDLE;
  hMenuRptsEducation:=CreateMenuLocal(hMenuRptsStaff,NameRptsEducation, NameRptsEducation, tcmAddFirst,
    MENU_INVALID_HANDLE,-1,0,MenuClickProc);
  hMenuRptsMilRank:=MENU_INVALID_HANDLE;
  hMenuRptsMilRank:=CreateMenuLocal(hMenuRptsStaff,NameRptsMilRank, NameRptsMilRank, tcmAddLast,
    MENU_INVALID_HANDLE,-1,0,MenuClickProc);
  isfreeMenuRptsStaff:=(hMenuRptsStaff<>MENU_INVALID_HANDLE) and (hMenuRptPersCard_T2=MENU_INVALID_HANDLE)and
    (hMenuRptsEducation=MENU_INVALID_HANDLE)and(hMenuRptsMilRank=MENU_INVALID_HANDLE);
  if isfreeMenuRptsStaff then if _FreeMenu(hMenuRptsStaff) then hMenuRptsStaff:=MENU_INVALID_HANDLE;

  isfreeMenuRpts:=(hMenuRpts<>MENU_INVALID_HANDLE) and (hMenuRptsStaff=MENU_INVALID_HANDLE);
  if isfreeMenuRpts then if _FreeMenu(hMenuRpts) then hMenuRpts:=MENU_INVALID_HANDLE; 
  
end;

function ViewInterface(InterfaceHandle: THandle; Param: Pointer): Boolean; stdcall;
begin
  Result:=false;
  if InterfaceHandle=hInterfaceCountry then
  begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewCountry(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRegion then
  begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewRegion(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceState then
  begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewState(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceTown then
  begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewTown(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceStreet then
  begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewStreet(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfacePlacement then
  begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewPlacement(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceProf then
  begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewProf(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceNation then
  begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewNation(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceMotive then
  begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewMotive(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfacePersonDocType then
  begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewPersondocType(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceSeat then
  begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewSeat(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceTypeDoc then
  begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewTypeDoc(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceTypeLeave then
  begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewTypeLeave(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceBank then
  begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewBank(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceDocum then
  begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewDocum(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceAccountType then
  begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewAccountType(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceDepart then
  begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewDepart(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceExperiencePercent then
  begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewExperiencePercent(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceStandartOperation then
  begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewStandartOperation(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceStOperation_AcType then
  begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewStOperation_AcType(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRptPersCard_T2 then  begin
    if not isValidPointer(Param,SizeOf(TParamReportInterface)) then exit;
    Result:=CreateAndViewRptsPersCard_T2(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRptsEducation then  begin
    if not isValidPointer(Param,SizeOf(TParamReportInterface)) then exit;
    Result:=CreateAndViewRptsEducation(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRptsMilRank then  begin
    if not isValidPointer(Param,SizeOf(TParamReportInterface)) then exit;
    Result:=CreateAndViewRptsMilRank(InterfaceHandle,Param);
  end;
end;

procedure MenuClickProc(MenuHandle: THandle);stdcall;
var
  TPRBI: TParamRBookInterface;
  TPJI: TParamJournalInterface;
  TPRI: TParamReportInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  FillChar(TPJI,SizeOf(TPJI),0);
  if MenuHandle=hMenuCountry then ViewInterface(hInterfaceCountry,@TPRBI);
  if MenuHandle=hMenuStreet then ViewInterface(hInterfaceStreet, @TPRBI);
  if MenuHandle=HMenuRegion then ViewInterface(hInterfaceRegion, @TPRBI);
  if MenuHandle=HMenuTown then ViewInterface(hInterfaceTown, @TPRBI);
  if Menuhandle=HMenuPlacement then ViewInterface(hInterfacePlacement, @TPRBI);
  if Menuhandle=HMenuState then ViewInterface(hInterfaceState, @TPRBI);
  if MenuHandle=HMenuProf then ViewInterface(hInterfaceProf, @TPRBI);
  if MenuHandle=HMenuNation then ViewInterface(hInterfaceNation, @TPRBI);
  if MenuHandle=HMenuMotive then ViewInterface(hInterfaceMotive, @TPRBI);
  if MenuHandle=HMenuPersonDocType then ViewInterface(hInterfacePersonDocType,
    @TPRBI);
  if MenuHandle=HMenuSeat then ViewInterface(hInterfaceSeat, @TPRBI);
  if MenuHandle=HMenuTypeDoc then ViewInterface(hInterfaceTypeDoc, @TPRBI);
  if MenuHandle=HMenuTypeLeave then ViewInterface(hInterfaceTypeLeave, @TPRBI);
  if MenuHandle=HMenuBank then ViewInterface(hInterfaceBank, @TPRBI);
  if MenuHandle=HMenuDocum then ViewInterface(hInterfaceDocum, @TPRBI);
  if MenuHandle=HMenuAccountType then ViewInterface(hInterfaceAccountType, @TPRBI);
  if MenuHandle=HMenuDepart then ViewInterface(hInterfaceDepart, @TPRBI);
  if MenuHandle=HMenuExperiencePercent then ViewInterface(hInterfaceExperiencePercent, @TPRBI);
  if MenuHandle=HMenuStandartOperation then ViewInterface(hInterfaceStandartOperation, @TPRBI);
  if MenuHandle=HMenuStOperation_AcType then ViewInterface(hInterfaceStOperation_AcType, @TPRBI);
  if MenuHandle=hMenuRptPersCard_T2 then ViewInterface(hInterfaceRptPersCard_T2, @TPRI);
  if MenuHandle=hMenuRptsEducation then ViewInterface(hInterfaceRptsEducation, @TPRI);
  if MenuHandle=hMenuRptsMilRank then ViewInterface(hInterfaceRptsMilRank, @TPRI);
end;



procedure RefreshLibrary_;stdcall;
begin
  Screen.Cursor:=crHourGlass;
  try
    ClearListInterfaceHandles;
    AddToListInterfaceHandles;

    ClearListMenuHandles;
    AddToListMenuRootHandles;
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure SetAppAndScreen_(A: TApplication; S: TScreen);stdcall;
begin
  Application:=A;
  Screen:=S;
end;

procedure SetConnection_(IBDbase: TIBDatabase; IBTran: TIBTransaction;
                         IBDBSecurity: TIBDatabase; IBTSecurity: TIBTransaction);stdcall;
begin
  IBDB:=IBDbase;
  IBT:=IBTran;
  IBDBSec:=IBDBSecurity;
  IBTSec:=IBTSecurity;
end;


//                          Вызовы справочников
//----------------------------------------------------------------------------
function CreateAndViewCountry(InterfaceHandle: THandle; Param: PParamRBookInterface):Boolean;
   function CreateAndViewAsMdiChild: Boolean;
   begin
     if FmRbkCountry=nil then FmRbkCountry:=TFmRbkCountry.Create(Application);
     try
       FmRbkCountry.InitMdiChildParams(InterfaceHandle);
       Result:=true;
     except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
     end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
     fm: TFmRbkCountry;
   begin
     Result:=false;
     fm:=nil;
     try
       fm:=TFmRbkCountry.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then
       begin
         fm.ReturnModalParams(Param);
         Result:=true;
       end;
     finally
       fm.Free;
     end;
   end;
begin
  case Param.Visual.TypeView of
    tvibvModal: Result:=CreateAndViewAsModal;
    tviMdiChild: Result:=CreateAndViewAsmdiChild;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkCountry,Param);
  end;
end;


function CreateAndViewStreet(InterfaceHandle: THandle; Param: PParamRBookInterface):Boolean;
   function CreateAndViewAsMdiChild: Boolean;
   begin
     if FmRbkStreet=nil then FmRbkStreet:=TFmRbkStreet.Create(Application);
     try
       FmRbkStreet.InitMdiChildParams(InterfaceHandle);
       Result:=true;
     except
      {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
     end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
     fm: TFmRbkStreet;
   begin
     Result:=false;
     fm:=nil;
     try
       fm:=TFmRbkStreet.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then
       begin
         fm.ReturnModalParams(Param);
         Result:=true;
        end;
     finally
       fm.Free;
     end;
   end;

begin
  case Param.Visual.TypeView of
    tvibvModal:  Result:=CreateAndViewAsModal;
    tviMdiChild: Result:=CreateAndViewAsMdiChild;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkStreet,Param);
  end;
end;


function CreateAndViewRegion(InterfaceHandle: THandle; Param: PParamRBookInterface):Boolean;
   function CreateAndViewAsMdiChild: Boolean;
   begin
     if FmRbkRegion=nil then FmRbkRegion:=TFmRbkRegion.Create(Application);
     try
       FmRbkRegion.InitMdiChildParams(InterfaceHandle);
       Result:=true;
     except
      {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
     end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
     fm: TFmRbkRegion;
   begin
     Result:=false;
     fm:=nil;
     try
       fm:=TFmRbkRegion.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
          fm.ReturnModalParams(Param);
          Result:=true;
        end;
     finally
       fm.Free;
     end;
   end;

begin
  case Param.Visual.TypeView of
    tvibvModal: Result:=CreateAndViewAsModal;
    tviMdiChild: Result:=CreateAndViewAsMdiChild;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkRegion,Param);
  end;
end;


function CreateAndViewTown(InterfaceHandle: THandle; Param: PParamRBookInterface):Boolean;
   function CreateAndViewAsMdiChild: Boolean;
   begin
     if FmRbkTown=nil then FmRbkTown:=TFmRbkTown.Create(Application);
     try
       FmRbkTown.InitMdiChildParams(InterfaceHandle);
       Result:=true;
     except
      {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
     end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
     fm: TFmRbkTown;
   begin
     Result:=false;
     fm:=nil;
     try
       fm:=TFmRbkTown.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
          fm.ReturnModalParams(Param);
          Result:=true;
        end;
     finally
       fm.Free;
     end;
   end;
begin
  case Param.Visual.TypeView of
    tvibvModal: Result:=CreateAndViewAsModal;
    tviMdiChild: Result:=CreateAndViewAsMdiChild;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQlTown,Param);
  end;
end;

function CreateAndViewPlacement(InterfaceHandle: THandle; Param: PParamRBookInterface):Boolean;
   function CreateAndViewAsMdiChild: Boolean;
   begin
     if FmRbkPlacement=nil then FmRbkPlacement:=TFmRbkPlacement.Create(Application);
     try
       FmRbkPlacement.InitMdiChildParams(InterfaceHandle);
       Result:=true;
     except
      {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
     end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
     fm: TFmRbkPlacement;
   begin
     Result:=false;
     fm:=nil;
     try
       fm:=TFmRbkPlacement.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
          fm.ReturnModalParams(Param);
          Result:=true;
        end;
     finally
       fm.Free;
     end;
   end;
begin
  case Param.Visual.TypeView of
    tvibvModal: Result:=CreateAndViewAsModal;
    tviMdiChild: Result:=CreateAndViewAsMdiChild;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLplacement,Param);
  end;
end;


function CreateAndViewState(InterfaceHandle: THandle; Param: PParamRBookInterface):Boolean;
   function CreateAndViewAsMdiChild: Boolean;
   begin
     if fmRbkState=nil then fmRbkState:=TfmRbkState.Create(Application);
     try
       fmRbkState.InitMdiChildParams(InterfaceHandle);
       Result:=true;
     except
      {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
     end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
     fm: TfmRbkState;
   begin
     Result:=false;
     fm:=nil;
     try
       fm:=TfmRbkState.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
          fm.ReturnModalParams(Param);
          Result:=true;
        end;
     finally
       fm.Free;
     end;
   end;
begin
  case Param.Visual.TypeView of
    tvibvModal: Result:=CreateAndViewAsModal;
    tviMdiChild: Result:=CreateAndViewAsMdiChild;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQlstate,Param);
  end;
end;


function CreateAndViewProf(InterfaceHandle: THandle; Param: PParamRBookInterface):Boolean;
   function CreateAndViewAsMdiChild: Boolean;
   begin
     if fmRbkProf=nil then fmRbkProf:=TfmRbkProf.Create(Application);
     try
       fmRbkProf.InitMdiChildParams(InterfaceHandle);
       Result:=true;
     except
      {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
     end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
     fm: TfmRbkProf;
   begin
     Result:=false;
     fm:=nil;
     try
       fm:=TfmRbkProf.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
          fm.ReturnModalParams(Param);
          Result:=true;
        end;
     finally
       fm.Free;
     end;
   end;

begin
  case Param.Visual.TypeView of
    tvibvModal: Result:=CreateAndViewAsModal;
    tviMdiChild: Result:=CreateAndViewAsMdiChild;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQlProf,Param);
  end;
end;


function CreateAndViewNation(InterfaceHandle: THandle; Param: PParamRBookInterface):Boolean;
   function CreateAndViewAsMdiChild: Boolean;
   begin
     if fmRbkNation=nil then fmRbkNation:=TfmRbkNation.Create(Application);
     try
       fmRbkNation.InitMdiChildParams(InterfaceHandle);
       Result:=true;
     except
      {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
     end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
     fm: TfmRbkNation;
   begin
     Result:=false;
     fm:=nil;
     try
       fm:=TfmRbkNation.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
          fm.ReturnModalParams(Param);
          Result:=true;
        end;
     finally
       fm.Free;
     end;
   end;
begin
  case Param.Visual.TypeView of
    tvibvModal: Result:=CreateAndViewAsModal;
    tviMdiChild: Result:=CreateAndViewAsMdiChild;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQlNation,Param);
  end;
end;


function CreateAndViewMotive(InterfaceHandle: THandle; Param: PParamRBookInterface):Boolean;
   function CreateAndViewAsMdiChild: Boolean;
   begin
     if fmRbkMotive=nil then fmRbkMotive:=TfmRbkMotive.Create(Application);
     try
       fmRbkMotive.InitMdiChildParams(InterfaceHandle);
       Result:=true;
     except
      {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
     end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
     fm: TfmRbkMotive;
   begin
     Result:=false;
     fm:=nil;
     try
       fm:=TfmRbkMotive.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
          fm.ReturnModalParams(Param);
          Result:=true;
        end;
     finally
       fm.Free;
     end;
   end;

begin
  case Param.Visual.TypeView of
    tvibvModal: Result:=CreateAndViewAsModal;
    tviMdiChild: Result:=CreateAndViewAsMdiChild;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQlMotive,Param);
  end;
end;


function CreateAndViewPersonDocType(InterfaceHandle: THandle; Param: PParamRBookInterface):Boolean;
   function CreateAndViewAsMdiChild: Boolean;
   begin
     if FmRbkPersonDocType=nil then FmRbkPersonDocType:=TFmRbkPersonDocType.Create(Application);
     try
       FmRbkPersonDocType.InitMdiChildParams(InterfaceHandle);
       Result:=true;
     except
      {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
     end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
     fm: TFmRbkPersonDocType;
   begin
     Result:=false;
     fm:=nil;
     try
       fm:=TFmRbkPersonDocType.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
          fm.ReturnModalParams(Param);
          Result:=true;
        end;
     finally
       fm.Free;
     end;
   end;
begin
  case Param.Visual.TypeView of
    tvibvModal: Result:=CreateAndViewAsModal;
    tviMdiChild: Result:=CreateAndViewAsMdiChild;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQlPersonDocType,Param);
  end;
end;

function CreateAndViewSeat(InterfaceHandle: THandle; Param: PParamRBookInterface):Boolean;
   function CreateAndViewAsMdiChild: Boolean;
   begin
     if FmRbkSeat=nil then FmRbkSeat:=TFmRbkSeat.Create(Application);
     try
       FmRbkSeat.InitMdiChildParams(InterfaceHandle);
       Result:=true;
     except
      {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
     end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
     fm: TFmRbkSeat;
   begin
     Result:=false;
     fm:=nil;
     try
       fm:=TFmRbkSeat.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
          fm.ReturnModalParams(Param);
          Result:=true;
        end;
     finally
       fm.Free;
     end;
   end;

begin
  case Param.Visual.TypeView of
    tvibvModal: Result:=CreateAndViewAsModal;
    tviMdiChild: Result:=CreateAndViewAsMdiChild;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQlSeat,Param);
  end;
end;


function CreateAndViewTypeDoc(InterfaceHandle: THandle; Param: PParamRBookInterface):Boolean;
   function CreateAndViewAsMdiChild: Boolean;
   begin
     if FmRbkTypeDoc=nil then FmRbkTypeDoc:=TFmRbkTypeDoc.Create(Application);
     try
       FmRbkTypeDoc.InitMdiChildParams(InterfaceHandle);
       Result:=true;
     except
      {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
     end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
     fm: TFmRbkTypeDoc;
   begin
     Result:=false;
     fm:=nil;
     try
       fm:=TFmRbkTypeDoc.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then
       begin
          fm.ReturnModalParams(Param);
          Result:=true;
        end;
     finally
       fm.Free;
     end;
   end;
begin
  case Param.Visual.TypeView of
    tvibvModal: Result:=CreateAndViewAsModal;
    tviMdiChild: Result:=CreateAndViewAsMdiChild;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQlTypeDoc,Param);
  end;
end;


function CreateAndViewTypeLeave(InterfaceHandle: THandle; Param: PParamRBookInterface):Boolean;
   function CreateAndViewAsMdiChild: Boolean;
   begin
     if FmRbkTypeLeave=nil then FmRbkTypeLeave:=TFmRbkTypeLeave.Create(Application);
     try
       FmRbkTypeLeave.InitMdiChildParams(InterfaceHandle);
       Result:=true;
     except
      {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
     end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
     fm: TFmRbkTypeLeave;
   begin
     Result:=false;
     fm:=nil;
     try
       fm:=TFmRbkTypeLeave.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
          fm.ReturnModalParams(Param);
          Result:=true;
        end;
     finally
       fm.Free;
     end;
   end;
begin
  case Param.Visual.TypeView of
    tvibvModal: Result:=CreateAndViewAsModal;
    tviMdiChild: Result:=CreateAndViewAsMdiChild;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQlTypeLeave,Param);
  end;
end;


function CreateAndViewBank(InterfaceHandle: THandle; Param: PParamRBookInterface):Boolean;
   function CreateAndViewAsMdiChild: Boolean;
   begin
     if FmRbkBank=nil then FmRbkBank:=TFmRbkBank.Create(Application);
     try
       FmRbkBank.InitMdiChildParams(InterfaceHandle);
       Result:=true;
     except
      {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
     end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
     fm: TFmRbkBank;
   begin
     Result:=false;
     fm:=nil;
     try
       fm:=TFmRbkBank.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
          fm.ReturnModalParams(Param);
          Result:=true;
        end;
     finally
       fm.Free;
     end;
   end;
begin
  case Param.Visual.TypeView of
    tvibvModal: Result:=CreateAndViewAsModal;
    tviMdiChild: Result:=CreateAndViewAsMdiChild;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQlBank,Param);
  end;
end;

function CreateAndViewDocum(InterfaceHandle: THandle; Param: PParamRBookInterface):Boolean;
   function CreateAndViewAsMdiChild: Boolean;
   begin
     if FmRbkDocum=nil then FmRbkDocum:=TFmRbkDocum.Create(Application);
     try
       FmRbkDocum.InitMdiChildParams(InterfaceHandle);
       Result:=true;
     except
      {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
     end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
     fm: TFmRbkDocum;
   begin
     Result:=false;
     fm:=nil;
     try
       fm:=TFmRbkDocum.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
          fm.ReturnModalParams(Param);
          Result:=true;
        end;
     finally
       fm.Free;
     end;
   end;

begin
  case Param.Visual.TypeView of
    tvibvModal: Result:=CreateAndViewAsModal;
    tviMdiChild: Result:=CreateAndViewAsMdiChild;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQlDocum,Param);
  end;
end;

function CreateAndViewAccountType(InterfaceHandle: THandle; Param: PParamRBookInterface):Boolean;
   function CreateAndViewAsMdiChild: Boolean;
   begin
     if FmRbkAccountType=nil then FmRbkAccountType:=TFmRbkAccountType.Create(Application);
     try
       FmRbkAccountType.InitMdiChildParams(InterfaceHandle);
       Result:=true;
     except
      {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
     end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
     fm: TFmRbkAccountType;
   begin
     Result:=false;
     fm:=nil;
     try
       fm:=TFmRbkAccountType.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
          fm.ReturnModalParams(Param);
          Result:=true;
        end;
     finally
       fm.Free;
     end;
   end;
begin
  case Param.Visual.TypeView of
    tvibvModal: Result:=CreateAndViewAsModal;
    tviMdiChild: Result:=CreateAndViewAsMdiChild;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQlAccountType,Param);
  end;
end;


function CreateAndViewDepart(InterfaceHandle: THandle; Param: PParamRBookInterface):Boolean;
   function CreateAndViewAsMdiChild: Boolean;
   begin
     if FmRbkDepart=nil then FmRbkDepart:=TFmRbkDepart.Create(Application);
     try
       FmRbkDepart.InitMdiChildParams(InterfaceHandle);
       Result:=true;
     except
      {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
     end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
     fm: TFmRbkDepart;
   begin
     Result:=false;
     fm:=nil;
     try
       fm:=TFmRbkDepart.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
          fm.ReturnModalParams(Param);
          Result:=true;
        end;
        Result:=true;
     finally
       fm.Free;
     end;
   end;
begin
  case Param.Visual.TypeView of
    tvibvModal: Result:=CreateAndViewAsModal;
    tviMdiChild: Result:=CreateAndViewAsMdiChild;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQlDepart,Param);
  end;
end;

function CreateAndViewExperiencePercent(InterfaceHandle: THandle; Param: PParamRBookInterface):Boolean;
   function CreateAndViewAsMdiChild: Boolean;
   begin
     if FmRbkExperiencePercent=nil then FmRbkExperiencePercent:=TFmRbkExperiencePercent.Create(Application);
     try
       FmRbkExperiencePercent.InitMdiChildParams(InterfaceHandle);
       Result:=true;
     except
      {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
     end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
     fm: TFmRbkExperiencePercent;
   begin
     Result:=false;
     fm:=nil;
     try
       fm:=TFmRbkExperiencePercent.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
          fm.ReturnModalParams(Param);
          Result:=true;
        end;
     finally
       fm.Free;
     end;
   end;
begin
  case Param.Visual.TypeView of
    tvibvModal: Result:=CreateAndViewAsModal;
    tviMdiChild: Result:=CreateAndViewAsMdiChild;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQlexperiencepercent,Param);
  end;
end;

function CreateAndViewStandartOperation(InterfaceHandle: THandle; Param: PParamRBookInterface):Boolean;
   function CreateAndViewAsMdiChild: Boolean;
   begin
     if FmRbkStandartOperation=nil then FmRbkStandartOperation:=TFmRbkStandartOperation.Create(Application);
     try
       FmRbkStandartOperation.InitMdiChildParams(InterfaceHandle);
       Result:=true;
     except
      {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
     end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
     fm: TFmRbkStandartOperation;
   begin
     Result:=false;
     fm:=nil;
     try
       fm:=TFmRbkStandartOperation.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
          fm.ReturnModalParams(Param);
          Result:=true;
        end;
     finally
       fm.Free;
     end;
   end;

begin
  case Param.Visual.TypeView of
    tvibvModal: Result:=CreateAndViewAsModal;
    tviMdiChild: Result:=CreateAndViewAsMdiChild;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQlStandartoperation,Param);
  end;
end;

function CreateAndViewStOperation_AcType(InterfaceHandle: THandle; Param: PParamRBookInterface):Boolean;
   function CreateAndViewAsMdiChild: Boolean;
   begin
     if FmRbkStOperation_AcType=nil then FmRbkStOperation_AcType:=TFmRbkStOperation_AcType.Create(Application);
     try
       FmRbkStOperation_AcType.InitMdiChildParams(InterfaceHandle);
       Result:=true;
     except
      {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
     end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
     fm: TFmRbkStOperation_AcType;
   begin
     Result:=false;
     fm:=nil;
     try
       fm:=TFmRbkStOperation_AcType.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
          fm.ReturnModalParams(Param);
          Result:=true;
        end;
     finally
       fm.Free;
     end;
   end;

begin
  case Param.Visual.TypeView of
    tvibvModal: Result:=CreateAndViewAsModal;
    tviMdiChild: Result:=CreateAndViewAsMdiChild;
    tviOnlyData: Result:=false;//???
  end;
end;

// ------------------------- Вызовы отчётов ------------------------
function CreateAndViewRptsPersCard_T2(InterfaceHandle: THandle; Param: PParamReportInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRptsCard_T2 = nil then
       fmRptsCard_T2:=TfmRptsCard_T2.Create(Application);
     fmRptsCard_T2.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=CreateAndViewAsMDIChild;
end;

function CreateAndViewRptsEducation(InterfaceHandle: THandle; Param: PParamReportInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRptsEducation = nil then
       fmRptsEducation:=TfmRptsEducation.Create(Application);
     fmRptsEducation.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=CreateAndViewAsMDIChild;
end;


function CreateAndViewRptsMilRank(InterfaceHandle: THandle; Param: PParamReportInterface): Boolean;
begin
  result:=false;
  try
   if fmRptsMilRank=nil then fmRptsMilRank:=TfmRptsMilRank.Create(Application);
   fmRptsMilRank.InitMdiChildParams(InterfaceHandle,Param);
   Result:=true;
  except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

procedure FreeCreatures;
begin
  if not isInitAll then exit;
  FreeAndNil(fmRbkRegion);
  FreeAndNil(fmRbkState);
  FreeAndNil(fmRbkTown);
  FreeAndNil(fmRbkPlacement);
  FreeAndNil(fmRbkStreet);
  FreeAndNil(fmRbkProf);
  FreeAndNil(fmRbkNation);
  FreeAndNil(fmRbkMotive);
  FreeAndNil(fmRbkPersonDocType);
  FreeAndNil(fmRbkTypeDoc);
  FreeAndNil(fmRbkTypeLeave);
  FreeAndNil(fmRbkSeat);
  FreeAndNil(fmRbkBank);
  FreeAndNil(fmRbkDocum);
  FreeAndNil(FmRbkAccountType);
  FreeAndNil(fmRbkDepart);
  FreeAndNil(fmRbkStandartOperation);
  FreeAndNil(fmRbkExperiencePercent);
  FreeAndNil(FmRbkStoperation_acType);
  FreeAndNil(fmRptsCard_T2);
  FreeAndNil(fmRptsEducation);
  FreeAndNil(fmRptsMilRank);

  ClearListMenuHandles;
  ListMenuHandles.Free;

  ClearListInterfaceHandles;
  ListInterfaceHandles.Free;


  {FreeAndNil(FmWizJobAccept);
  FreeAndNil(fmRptsCard_T2);}
end;
function isNotPermission(sqlObject: PChar; sqlOperator: PChar; Security: Boolean): Boolean;
begin
  if not Security then
   Result:=not _isPermission(sqlObject,sqlOperator)
  else
   Result:=not _isPermissionSecurity(sqlObject,sqlOperator);
end;

procedure AfterSetOptions_(isOK: Boolean);stdcall;

  procedure SetNewDbGirdProp(Grid: TNewDBgrid);
   begin
     AssignFont(_GetOptions.RBTableFont,Grid.Font);
     Grid.TitleFont.Assign(Grid.Font);
     Grid.RowSelected.Font.Assign(Grid.Font);
     Grid.RowSelected.Brush.Style:=bsClear;
     Grid.RowSelected.Brush.Color:=_GetOptions.RBTableRecordColor;
     Grid.RowSelected.Font.Color:=clWhite;
     Grid.RowSelected.Pen.Style:=psClear;
     Grid.CellSelected.Visible:=true;
     Grid.CellSelected.Brush.Color:=_GetOptions.RBTableCursorColor;
     Grid.CellSelected.Font.Assign(Grid.Font);
     Grid.CellSelected.Font.Color:=clHighlightText;
     Grid.TitleCellMouseDown.Font.Assign(Grid.Font);
     Grid.Invalidate;
  end;

  procedure SetTreeViewProp(TV: TDBTreeView);
  begin
    AssignFont(_GetOptions.RBTableFont,TV.Font);
  end;

  procedure SetProperties(wt: TWinControl);
  var
    i: Integer;
    ct: TControl;
  begin
    for i:=0 to wt.ControlCount-1 do begin
      ct:=wt.Controls[i];
      if ct is TNewDbGrid then
         SetNewDbGirdProp(TNewDbGrid(ct));
      if ct is TCustomTreeView then
         SetTreeViewProp(TDBTreeView(ct));
      if ct is TWinControl then
         SetProperties(TWinControl(ct));
    end;
  end;

begin
 try
//  AfterSetOptions(ListOptionsRoot);
//  fmOptions.CloseIni;
//  fmOptions.Visible:=false;
  if isOk then begin
    if fmRBkCountry<>nil then SetProperties(fmRBkCountry);
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;


procedure ClearListInterfaceHandles;
var
  i: Integer;
begin
  for i:=0 to ListInterfaceHandles.Count-1 do begin
    _FreeInterface(THandle(ListInterfaceHandles.Items[i]));
  end;
  ListInterfaceHandles.Clear;
end;

procedure ClearListMenuHandles;
var
  i: Integer;
begin
  for i:=0 to ListMenuHandles.Count-1 do begin
    _FreeMenu(THandle(ListMenuHandles.Items[i]));
  end;
  ListMenuHandles.Clear;
end;



end.
