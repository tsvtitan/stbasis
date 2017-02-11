unit USalaryVAVCode;

interface

{$I stbasis.inc}


uses Windows, Forms, USalaryVAVData, UMainUnited, Classes, USalaryVAVDm, graphics, dialogs,
     IBDatabase, IBQuery, Controls, tsvHint, db, SysUtils, IBServices, stdctrls,
     comctrls, extctrls;


// Internal
procedure DeInitAll;
procedure ClearListInterfaceHandles;
procedure AddToListInterfaceHandles;
function ViewInterface(InterfaceHandle: THandle; Param: Pointer): Boolean; stdcall;
procedure ClearListMenuHandles;
procedure MenuClickProc(MenuHandle: THandle);stdcall;
procedure AddToListMenuRootHandles;
procedure ClearListToolBarHandles;
procedure ToolButtonClickProc(ToolButtonHandle: THandle);stdcall;
procedure AddToListToolBarHandles;
procedure ClearListOptionHandles;
procedure AddToListOptionRootHandles;
procedure BeforeSetOptionProc(OptionHandle: THandle);stdcall;
procedure AfterSetOptionProc(OptionHandle: THandle; isOk: Boolean);stdcall;
function isPermissionOnInterfaceView(InterfaceHandle: THandle): Boolean;
function GetStrFromCondition(isNotEmpty: Boolean; STrue,SFalse: string): string;

// Export
// Обязательные процедуры и функции для подключения к программе StBasis
//--------------------------------------------------------------------------
procedure InitAll_; stdcall; //Инициализация библиотеки
procedure GetInfoLibrary_(P: PInfoLibrary);stdcall; //процедура вызова информации об библиотеке
//procedure RefreshEntryes_;stdcall;
procedure RefreshLibrary_;stdcall;
procedure SetConnection_(IBDbase: TIBDatabase; IBTran: TIBTransaction;
                         IBDBSecurity: TIBDatabase; IBTSecurity: TIBTransaction);stdcall; // установление связи с базой данных

// Import
//--------------------------------------------------------------------------
//<<<<<<<<<<<<  импортируемые процедуры и функции  >>>>>>>>>>>>>>>>>>>>>>>>>
function _isPermission(sqlObject: PChar; sqlOperator: PChar): Boolean;stdcall;
                         external MainExe name ConstisPermission;
function _isPermissionSecurity(sqlObject: PChar; sqlOperator: PChar): Boolean;stdcall;
                         external MainExe name ConstisPermissionSecurity;
procedure _SetSplashStatus(Status: Pchar);stdcall;
                         external MainExe name ConstSetSplashStatus;
procedure _GetProtocolAndServerName(DataBaseStr: Pchar; var Protocol: TProtocol;
                                   var ServerName: array of char);stdcall;
                         external MainExe name ConstGetProtocolAndServerName;
procedure _GetInfoConnectUser(P: PInfoConnectUser);stdcall;
                         external MainExe name ConstGetInfoConnectUser;
procedure _AddErrorToJournal(Error: PChar; ClassError: TClass);stdcall;
                         external MainExe name ConstAddErrorToJournal;
procedure _AddSqlOperationToJournal(Name,Hint: PChar);stdcall;
                         external MainExe name ConstAddSqlOperationToJournal;
function _GetDateTimeFromServer: TDateTime;stdcall;
                         external MainExe name ConstGetDateTimeFromServer;
function _TestSplash: Boolean;stdcall;
                     external MainExe name ConstTestSplash;

function _CreateProgressBar(PCPB: PCreateProgressBar): THandle;stdcall;
                            external MainExe name ConstCreateProgressBar;
function _FreeProgressBar(ProgressBarHandle: THandle): Boolean;stdcall;
                          external MainExe name ConstFreeProgressBar;
procedure _SetProgressBarStatus(ProgressBarHandle: THandle; PSPBS: PSetProgressBarStatus);stdcall;
                                external MainExe name ConstSetProgressBarStatus;

function _CreateToolBar(PCTB: PCreateToolBar): THandle; stdcall;
                        external MainExe name ConstCreateToolBar;
function _RefreshToolBar(ToolBarHandle: THandle): Boolean; stdcall;
                         external MainExe name ConstRefreshToolBar;
function _FreeToolBar(ToolBarHandle: THandle): Boolean; stdcall;
                      external MainExe name ConstFreeToolBar;
function _CreateToolButton(ToolBarHandle: THandle; PCTB: PCreateToolButton): THandle; stdcall;
                           external MainExe name ConstCreateToolButton;
function _FreeToolButton(ToolButtonHandle: THandle): Boolean;stdcall;
                         external MainExe name ConstFreeToolButton;
function _CreateOption(ParentHandle: THandle; PCO: PCreateOption): THandle;stdcall;
                       external MainExe name ConstCreateOption;
function _FreeOption(OptionHandle: THandle): Boolean;stdcall;
                     external MainExe name ConstFreeOption;
function _ViewOption(OptionHandle: THandle): Boolean; stdcall;
                     external MainExe name ConstViewOption;
function _GetOptionParentWindow(OptionHandle: THandle): THandle;stdcall;
                                external MainExe name ConstGetOptionParentWindow;

function _CreateMenu(ParentHandle: THandle; PCM: PCreateMenu):THandle;stdcall;
                     external MainExe name ConstCreateMenu;
function _FreeMenu(MenuHandle: THandle): Boolean;stdcall;
                   external MainExe name ConstFreeMenu;
function _GetMenuHandleFromName(ParentHandle: THandle; Name: PChar): THandle;stdcall;
                                external MainExe name ConstGetMenuHandleFromName;
function _ViewMenu(MenuHandle: THandle): Boolean;stdcall;
                   external MainExe name ConstViewMenu;

function _CreateInterface(PCI: PCreateInterface): THandle;stdcall;
                          external MainExe name ConstCreateInterface;
function _FreeInterface(InterfaceHandle: THandle): Boolean;stdcall;
                        external MainExe name ConstFreeInterface;
function _GetInterfaceHandleFromName(Name: PChar): THandle;stdcall;
                                     external MainExe name ConstGetInterfaceHandleFromName;
function _ViewInterface(InterfaceHandle: THandle; Param: Pointer): Boolean; stdcall;
                        external MainExe name ConstViewInterface;
function _ViewInterfaceFromName(Name: PChar; Param: Pointer): Boolean; stdcall;
                                external MainExe name ConstViewInterfaceFromName;
function _CreatePermissionForInterface(InterfaceHandle: THandle; PCPFI: PCreatePermissionForInterface): Boolean;stdcall;
                                       external MainExe name ConstCreatePermissionForInterface;


implementation

//------------------------------------------------------------------------
uses ActiveX,Menus,dbtree, URptMain,

     USalaryVAVOptions,  MainWizard,UAdjust,UEditRB,URBMainGrid,
     URBMainTreeView, UTreeBuilding, UOTSalary,
     URBCalcPeriod, UEditRBCalcPeriod,
     USalPeriod,URBPrivilege,StSalaryKit,StCalendarUtil;//UJRMain,

//******************* Internal ************************

procedure InitAll_; stdcall;
begin
 try
  CoInitialize(nil);
  dm:=Tdm.Create(nil);
  fmOptions:=TfmOptions.Create(nil);

  ListInterfaceHandles:=TList.Create;
  AddToListInterfaceHandles;

  ListMenuHandles:=Tlist.Create;
  AddToListMenuRootHandles;

  ListOptionHandles:=TList.Create;
  AddToListOptionRootHandles;

  ListToolBarHandles:=TList.Create;
  AddToListToolBarHandles;
  CalculateInit(IBDB);
  InitCalendarUtil(IBDB);

  isInitAll:=true;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

//------------------------------------------------------------------------
procedure DeInitAll;
begin
 try
  if not isInitAll then exit;


  FreeAndNil(fmOptions);
  FreeAndNil(fmOTSalary);
  FreeAndNil(fmRBCalcPeriod);
  FreeAndNil(fmRBPrivelege);
  FreeAndNil(fmBuildingTree);
  FreeAndNil(fmSalPeriod);

//  UnRegisterHotKey(Application.Handle,0);

  CalculateDone;
  DoneCalendarUtil;

  ClearListMenuHandles;
  ListMenuHandles.free;

  ClearListOptionHandles;
  ListOptionHandles.Free;

  ClearListToolBarHandles;
  ListToolBarHandles.Free;

  ClearListInterfaceHandles;
  ListInterfaceHandles.Free;

  dm.Free;
  CoUnInitialize;
 except
  Raise;
//  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;
//--------------------------------------------------------------------------
procedure ClearListToolBarHandles;
var
  i: Integer;
begin
  for i:=0 to ListToolBarHandles.Count-1 do begin
    _FreeToolBar(THandle(ListToolBarHandles.Items[i]));
  end;
  ListToolBarHandles.Clear;
end;
//--------------------------------------------------------------------------
procedure ToolButtonClickProc(ToolButtonHandle: THandle);stdcall;
begin
  if ToolButtonHandle=hToolButtonSalary then MenuClickProc(hMenuOperationsSalary);
end;
//--------------------------------------------------------------------------
procedure AddToListToolBarHandles;

  function CreateToolBarLocal(Name,Hint: PChar;
                              ShortCut: TShortCut;
                              Visible: Boolean=true;
                              Position: TToolBarPosition=tbpTop): THandle;
  var
    CTBLocal: TCreateToolBar;
  begin
    FillChar(CTBLocal,SizeOf(TCreateToolBar),0);
    CTBLocal.Name:=Name;
    CTBLocal.Hint:=Hint;
    CTBLocal.ShortCut:=ShortCut;
    CTBLocal.Visible:=Visible;
    CTBLocal.Position:=Position;
    Result:=_CreateToolBar(@CTBLocal);
  end;

  function CreateToolButtonLocal(TH: THandle; Name,Hint: PChar;
                                 ImageIndex: Integer; Proc: TToolButtonClickProc=nil;
                                 Style: TToolButtonStyleEx=tbseButton;
                                 Control: TControl=nil): THandle;
  var
   CTBLocal: TCreateToolButton;
   Image: TBitmap;
  begin
   Image:=nil;
   try
    Result:=TOOLBUTTON_INVALID_HANDLE;
    Image:=TBitmap.Create;
    FillChar(CTBLocal,SizeOf(TCreateToolButton),0);
    CTBLocal.Name:=Name;
    CTBLocal.Hint:=Hint;
    dm.IL.GetBitmap(ImageIndex,Image);
    CTBLocal.Bitmap:=Image;
    CTBLocal.ToolButtonClickProc:=Proc;
    CTBLocal.Style:=Style;
    CTBLocal.Control:=Control;
    Result:=_CreateToolButton(TH,@CTBLocal);
   finally
     Image.Free;
   end;
  end;

var
  tBar1: THandle;
begin
  ListToolBarHandles.Clear;
  if (hMenuOperationsSalary<>MENU_INVALID_HANDLE) then begin
   tbar1:=CreateToolBarLocal('Рассчет зарплаты','Панель рассчета зарплаты',0);
   ListToolBarHandles.Add(Pointer(tbar1));
   if hMenuOperationsSalary<>MENU_INVALID_HANDLE then
    hToolButtonSalary:=CreateToolButtonLocal(tbar1,'Добавление начислений удержаний',NameSalary,1,ToolButtonClickProc);
   _RefreshToolBar(tbar1);
  end;
end;

//--------------------------------------------------------------------------
procedure ClearListOptionHandles;
var
  i: Integer;
begin
  for i:=0 to ListOptionHandles.Count-1 do begin
    _FreeOption(THandle(ListOptionHandles.Items[i]));
  end;
  ListOptionHandles.Clear;
end;
//--------------------------------------------------------------------------
procedure AddToListOptionRootHandles;

  function CreateOptionLocal(ParentHandle: THandle; Name: PChar;
                             ImageIndex: Integer): THandle;
  var
   OCLocal: TCreateOption;
   Image: TBitmap;
  begin
   Image:=nil;
   try
    Image:=TBitmap.Create;
    FillChar(OCLocal,SizeOf(TCreateOption),0);
    OCLocal.Name:=Name;
    OCLocal.BeforeSetOptionProc:=BeforeSetOptionProc;
    OCLocal.AfterSetOptionProc:=AfterSetOptionProc;
    if ImageIndex<>-1 then begin
     dm.IL.GetBitmap(ImageIndex,Image);
     OCLocal.Bitmap:=Image;
    end;
    Result:=_CreateOption(ParentHandle,@OCLocal);
   finally
     Image.Free;
   end;
  end;

begin
  ListOptionHandles.Clear;
  hOptionRBooks:=CreateOptionLocal(OPTION_ROOT_HANDLE,ConstOptionRBooks,-1);
  ListOptionHandles.Add(Pointer(hOptionRBooks));
  if hMenuOperationsSalary<>MENU_INVALID_HANDLE then begin
   hOptionSalary:=CreateOptionLocal(hOptionRBooks,NameSalary,2);
  end;
end;
//--------------------------------------------------------------------------
procedure BeforeSetOptionProc(OptionHandle: THandle);stdcall;

  procedure BeforeSetOption;
  var
    wc: TWinControl;
  begin
    if OptionHandle=hOptionSalary then begin
     wc:=FindControl(_GetOptionParentWindow(hOptionSalary));
     if isValidPointer(wc) then begin
      fmOptions.pc.ActivePage:=fmOptions.tsRBSalary;
      fmOptions.pnRBSalary.Parent:=wc;
     end;
    end;
  end;

begin
  fmOptions.Visible:=true;
  fmOptions.LoadFromIni;
  BeforeSetOption;
end;
//--------------------------------------------------------------------------
procedure AfterSetOptionProc(OptionHandle: THandle; isOk: Boolean);stdcall;

  procedure AfterSetOption;
  begin
     if OptionHandle=hOptionSalary then begin
      fmOptions.pnRBSalary.Parent:=fmOptions.tsRBSalary;
//      if fmBuildingTree<>nil then fmBuildingTree.SetParamsFromOptions;
     end;
  end;

begin
   AfterSetOption;

   if isOK then fmOptions.SaveToIni;

   fmOptions.Visible:=false;

  if isOk then begin
//    if fmRBEmp<>nil then SetProperties(fmRBEmp);
        end;
//    if fmRBPlant<>nil then SetProperties(fmRBPlant);
  end;
//--------------------------------------------------------------------------
procedure ClearListMenuHandles;
var
  i: Integer;
begin
  for i:=0 to ListMenuHandles.Count-1 do begin
    _FreeMenu(THandle(ListMenuHandles.Items[i]));
  end;
  ListMenuHandles.Clear;
end;
//------------------------------------------------------------------------
procedure MenuClickProc(MenuHandle: THandle);stdcall;
var
  TPRBI: TParamRBookInterface;
  TPRI: TParamReportInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  FillChar(TPRI,SizeOf(TPRI),0);
  if MenuHandle=hMenuOperationsBuildingTree then ViewInterface(hInterfaceBuildingTree,@TPRI);
  if MenuHandle=hMenuOperationsSalPeriod then ViewInterface(hInterfaceSalPeriod,@TPRBI);
  if MenuHandle=hMenuOperationsSalary then ViewInterface(hInterfaceSalary,@TPRBI);
  if MenuHandle=hMenuOperationsCalcPeriod then ViewInterface(hInterfaceCalcPeriod,@TPRBI);
end;
//--------------------------------------------------------------------------
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
    CMLocal.ShortCut:=ShortCut;
    CMLocal.TypeCreateMenu:=TypeCreateMenu;
    CMLocal.InsertMenuHandle:=InsertMenuHandle;
    if ImageIndex<>-1 then begin
     dm.IL.GetBitmap(ImageIndex,Image);
     CMLocal.Bitmap:=Image;
    end;
    Result:=_CreateMenu(ParentHandle,@CMLocal);
   finally
     Image.Free;
   end;
  end;

var
  isFreeMenuOperationsSalary: Boolean;
begin
  ListMenuHandles.Clear;

  hMenuOperations:=CreateMenuLocal(MENU_ROOT_HANDLE,ConstsMenuOperations,PChar(ChangeString(ConstsMenuOperations,'&','')),
                               tcmInsertBefore,_GetMenuHandleFromName(MENU_ROOT_HANDLE,ConstsMenuService));
  ListMenuHandles.Add(Pointer(hMenuOperations));

  hMenuOperations_Salary:=CreateMenuLocal(hMenuOperations,ConstsMenuSalary,ConstsMenuSalary,tcmAddFirst);
//  CreateMenuLocal(hMenuOperations_Salary,ConstsMenuSeparator,'');


   hMenuOperationsBuildingTree:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceBuildingTree) then
   hMenuOperationsBuildingTree:=CreateMenuLocal(hMenuOperations_Salary,'Расчет зарплаты по всем отделам',NameSalary,tcmAddLast,MENU_INVALID_HANDLE,1,ShortCut(Word('C'),[ssCtrl]),MenuClickProc);

   hMenuOperationsSalPeriod:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceSalPeriod) then
   hMenuOperationsSalPeriod:=CreateMenuLocal(hMenuOperations_Salary,'Управление периодами',NameSalPeriod,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

   hMenuOperationsSalary:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceSalary) then
   hMenuOperationsSalary:=CreateMenuLocal(hMenuOperations_Salary,'Добавление начислений и удержаний',NameSalary,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

   hMenuOperationsCalcPeriod:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceCalcPeriod) then
   hMenuOperationsCalcPeriod:=CreateMenuLocal(hMenuOperations_Salary,'Рассчетные периоды',NameCalcPeriod,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  isFreeMenuOperationsSalary:=(hMenuOperationsSalary<>MENU_INVALID_HANDLE)and
                              (hMenuOperationsBuildingTree=MENU_INVALID_HANDLE)and
                              (hMenuOperationsSalPeriod=MENU_INVALID_HANDLE)and
                              (hMenuOperationsSalary=MENU_INVALID_HANDLE)and
                              (hMenuOperationsCalcPeriod=MENU_INVALID_HANDLE);
  if isFreeMenuOperationsSalary then
    if _FreeMenu(hMenuOperationsSalary) then hMenuOperationsSalary:=MENU_INVALID_HANDLE;

end;
//------------------------------------------------------------------------
procedure ClearListInterfaceHandles;
var
  i: Integer;
begin
  for i:=0 to ListInterfaceHandles.Count-1 do begin
    _FreeInterface(THandle(ListInterfaceHandles.Items[i]));
  end;
  ListInterfaceHandles.Clear;
end;
//--------------------------------------------------------------------------
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
  ListInterfaceHandles.Clear;
  
  hInterfaceBuildingTree:=CreateLocalInterface(NameBuildingTree,NameBuildingTree);
  CreateLocalPermission(hInterfaceBuildingTree,tbSalary,ttpSelect,false);
  CreateLocalPermission(hInterfaceBuildingTree,tbSalary,ttpInsert,false);
  CreateLocalPermission(hInterfaceBuildingTree,tbSalary,ttpDelete,false);
  CreateLocalPermission(hInterfaceBuildingTree,tbSalary,ttpUpdate,false);
  CreateLocalPermission(hInterfaceBuildingTree,tbcalcperiod,ttpSelect,false);
  CreateLocalPermission(hInterfaceBuildingTree,tbcalcperiod,ttpUpdate,false);
  CreateLocalPermission(hInterfaceBuildingTree,tbEmp,ttpSelect,false);
  CreateLocalPermission(hInterfaceBuildingTree,tbDepart,ttpSelect,false);
  CreateLocalPermission(hInterfaceBuildingTree,tbAlgorithm,ttpSelect,false);
  CreateLocalPermission(hInterfaceBuildingTree,tbEmpplant,ttpSelect,false);
  CreateLocalPermission(hInterfaceBuildingTree,tbCharge,ttpSelect,false);
  CreateLocalPermission(hInterfaceBuildingTree,tbConstcharge,ttpSelect,false);
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//                    Проверить остальные таблицы
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

  hInterfaceSalPeriod:=CreateLocalInterface(NameSalPeriod,NameSalPeriod);
  CreateLocalPermission(hInterfaceSalPeriod,tbCalcPeriod,ttpSelect,false);
  CreateLocalPermission(hInterfaceSalPeriod,tbCalcPeriod,ttpInsert,false);
  CreateLocalPermission(hInterfaceSalPeriod,tbCalcPeriod,ttpUpdate,false);
  CreateLocalPermission(hInterfaceSalPeriod,tbCalcPeriod,ttpDelete,false);
  CreateLocalPermission(hInterfaceSalPeriod,tbEmp,ttpSelect,false);
  CreateLocalPermission(hInterfaceSalPeriod,tbEmpplant,ttpSelect,false);
  CreateLocalPermission(hInterfaceSalPeriod,tbSalary,ttpSelect,false);
  CreateLocalPermission(hInterfaceSalPeriod,tbCharge,ttpSelect,false);
  CreateLocalPermission(hInterfaceSalPeriod,tbCalcPeriod,ttpSelect,false);
  CreateLocalPermission(hInterfaceSalPeriod,tbSheet,ttpSelect,false);

  hInterfaceSalary:=CreateLocalInterface(NameSalary,NameSalary);
  CreateLocalPermission(hInterfaceSalary,tbEmp,ttpSelect,false);
  CreateLocalPermission(hInterfaceSalary,tbFamilystate,ttpSelect,false);
  CreateLocalPermission(hInterfaceSalary,tbNation,ttpSelect,false);
  CreateLocalPermission(hInterfaceSalary,tbCountry,ttpSelect,false);
  CreateLocalPermission(hInterfaceSalary,tbRegion,ttpSelect,false);
  CreateLocalPermission(hInterfaceSalary,tbState,ttpSelect,false);
  CreateLocalPermission(hInterfaceSalary,tbTown,ttpSelect,false);
  CreateLocalPermission(hInterfaceSalary,tbPlaceMent,ttpSelect,false);
  CreateLocalPermission(hInterfaceSalary,tbEmpPlant,ttpSelect,false);
  CreateLocalPermission(hInterfaceSalary,tbSex,ttpSelect,false);
  CreateLocalPermission(hInterfaceSalary,tbSalary,ttpSelect,false);
  CreateLocalPermission(hInterfaceSalary,tbSalary,ttpInsert,false);
  CreateLocalPermission(hInterfaceSalary,tbSalary,ttpUpdate,false);
  CreateLocalPermission(hInterfaceSalary,tbSalary,ttpDelete,false);
  CreateLocalPermission(hInterfaceSalary,tbAlgorithm,ttpSelect,false);
  CreateLocalPermission(hInterfaceSalary,tbAbsence,ttpSelect,false);
  CreateLocalPermission(hInterfaceSalary,tbNet,ttpSelect,false);
  CreateLocalPermission(hInterfaceSalary,tbClass,ttpSelect,false);
  CreateLocalPermission(hInterfaceSalary,tbPlant,ttpSelect,false);
  CreateLocalPermission(hInterfaceSalary,tbDocum,ttpSelect,false);
  CreateLocalPermission(hInterfaceSalary,tbSeat,ttpSelect,false);
  CreateLocalPermission(hInterfaceSalary,tbDepart,ttpSelect,false);
  CreateLocalPermission(hInterfaceSalary,tbMotive,ttpSelect,false);
  CreateLocalPermission(hInterfaceSalary,tbProf,ttpSelect,false);
  CreateLocalPermission(hInterfaceSalary,tbSchedule,ttpSelect,false);
  CreateLocalPermission(hInterfaceSalary,tbCharge,ttpSelect,false);
  CreateLocalPermission(hInterfaceSalary,tbCalcPeriod,ttpSelect,false);
  CreateLocalPermission(hInterfaceSalary,tbConstcharge,ttpSelect,false);
  CreateLocalPermission(hInterfaceSalary,tbCharge,ttpSelect,false);

//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//                    Проверить остальные таблицы
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  
  hInterfaceCalcPeriod:=CreateLocalInterface(NameCalcPeriod,NameCalcPeriod);
  CreateLocalPermission(hInterfaceCalcPeriod,tbcalcperiod,ttpSelect,false);
  CreateLocalPermission(hInterfaceCalcPeriod,tbcalcperiod,ttpInsert,false);
  CreateLocalPermission(hInterfaceCalcPeriod,tbcalcperiod,ttpUpdate,false);
  CreateLocalPermission(hInterfaceCalcPeriod,tbcalcperiod,ttpDelete,false);
  CreateLocalPermission(hInterfaceCalcPeriod,tbcalcperiod,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceCalcPeriod,tbcalcperiod,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceCalcPeriod,tbcalcperiod,ttpDelete,false,ttiaDelete);
  CreateLocalPermission(hInterfaceCalcPeriod,tbEmp,ttpSelect,false);
  CreateLocalPermission(hInterfaceCalcPeriod,tbEmpplant,ttpSelect,false);
  CreateLocalPermission(hInterfaceCalcPeriod,tbSalary,ttpSelect,false);
  CreateLocalPermission(hInterfaceCalcPeriod,tbCharge,ttpSelect,false);
  CreateLocalPermission(hInterfaceCalcPeriod,tbConstcharge,ttpSelect,false);
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//                    Проверить остальные таблицы
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  hInterfacePrivelege:=CreateLocalInterface(NamePrivelege,NamePrivelege);
  CreateLocalPermission(hInterfacePrivelege,tbPrivelege,ttpSelect,false);
  CreateLocalPermission(hInterfacePrivelege,tbPrivelege,ttpInsert,false);
  CreateLocalPermission(hInterfacePrivelege,tbPrivelege,ttpUpdate,false);
  CreateLocalPermission(hInterfacePrivelege,tbPrivelege,ttpDelete,false);
  CreateLocalPermission(hInterfacePrivelege,tbcalcperiod,ttpSelect,false);
  CreateLocalPermission(hInterfacePrivelege,tbEmp,ttpSelect,false);
  CreateLocalPermission(hInterfacePrivelege,tbEmpplant,ttpSelect,false);
  CreateLocalPermission(hInterfacePrivelege,tbSalary,ttpSelect,false);
  CreateLocalPermission(hInterfacePrivelege,tbCharge,ttpSelect,false);
  CreateLocalPermission(hInterfacePrivelege,tbConstcharge,ttpSelect,false);
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//                    Проверить остальные таблицы
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

end;
//------------------------------------------------------------------------
//--------------------------------------------------------------------------
//------------------------------------------------------------------------
//--------------------------------------------------------------------------
//------------------------------------------------------------------------
//--------------------------------------------------------------------------
//------------------------------------------------------------------------
//------------------------------------------------------------------------

//------------------------------------------------------------------------
function isNotPermission(sqlObject: PChar; sqlOperator: PChar; Security: Boolean): Boolean;
begin
  if not Security then
   Result:=not _isPermission(sqlObject,sqlOperator)
  else
   Result:=not _isPermissionSecurity(sqlObject,sqlOperator);
end;
//------------------------------------------------------------------------
function CreateAndViewSalPeriod(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmSalPeriod=nil then
       fmSalPeriod:=TfmSalPeriod.Create(Application);
     fmSalPeriod.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmSalPeriod;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmSalPeriod.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
        fm.ReturnModalParams(Param);
        Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
//    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkEmp,Param);
  end;
end;
//--------------------------------------------------------------------------
function CreateAndViewBuildingTree(InterfaceHandle: THandle; Param: PParamReportInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmBuildingTree=nil then
        fmBuildingTree:=TfmBuildingTree.Create(Application);
     fmBuildingTree.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmBuildingTree;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmBuildingTree.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
        fm.ReturnModalParams(Param);
        Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=CreateAndViewAsMDIChild;
{  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
//    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkEmp,Param);
  end;}
end;
//------------------------------------------------------------------------
function CreateAndViewSalary(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmOTSalary=nil then
        fmOTSalary:=TfmOTSalary.Create(Application);
     fmOTSalary.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmOTSalary;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmOTSalary.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
        fm.ReturnModalParams(Param);
        Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
//    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkEmp,Param);
  end;
end;
//------------------------------------------------------------------------
function CreateAndViewCalcPeriod(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBCalcPeriod=nil then
        fmRBCalcPeriod:=TfmRBCalcPeriod.Create(Application);
     fmRBCalcPeriod.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBCalcPeriod;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBCalcPeriod.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
        fm.ReturnModalParams(Param);
        Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbCalcPeriod,Param);
  end;
end;
//------------------------------------------------------------------------
function CreateAndViewPrivelege(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBPrivelege=nil then
        fmRBPrivelege:=TfmRBPrivelege.Create(Application);
     fmRBPrivelege.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBPrivelege;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBPrivelege.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
        fm.ReturnModalParams(Param);
        Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbPrivelege,Param);
  end;
end;
//------------------------------------------------------------------------
function ViewInterface(InterfaceHandle: THandle; Param: Pointer): Boolean; stdcall;
begin
  Result:=false;

  // RBooks

  if InterfaceHandle=hInterfaceBuildingTree then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewBuildingTree(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceSalPeriod then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewSalPeriod(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceSalary then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewSalary(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceCalcPeriod then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewCalcPeriod(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfacePrivelege then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewPrivelege(InterfaceHandle,Param);
  end;
end;
//------------------------------------------------------------------------
function isPermissionOnInterfaceView(InterfaceHandle: THandle): Boolean;
var
    isRemove: Boolean;
begin
    isRemove:=false;
    if InterfaceHandle=hInterfaceBuildingTree then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmBuildingTree)
      else if fmBuildingTree<>nil then begin
       fmBuildingTree.SetInterfaceHandle(InterfaceHandle);
//       fmBuildingTree.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceSalPeriod then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    end;
    if InterfaceHandle=hInterfaceSalary then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    end;
    if InterfaceHandle=hInterfaceCalcPeriod then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    end;
    if InterfaceHandle=hInterfacePrivelege then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    end;
    result:=not isRemove;
end;

//------------------------------------------------------------------------
function GetStrFromCondition(isNotEmpty: Boolean; STrue,SFalse: string): string;
begin
 if isNotEmpty then
  Result:=STrue
 else Result:=SFalse;
end;
//********************* end of Internal *****************


//********************* Export *************************

procedure GetInfoLibrary_(P: PInfoLibrary);stdcall;
begin
  if P=nil then exit;
  P.Hint:=LibraryHint;
  P.TypeLib:=MainTypeLib;
end;
//------------------------------------------------------------------------
//------------------------------------------------------------------------
{function ViewEntry_(TypeEntry: TTypeEntry; Params:
                    Pointer; isModal: Boolean; OnlyData: Boolean=false):Boolean;stdcall;
begin
 Result:=false;
 try
  case TypeEntry of
    tte_None:;
    tte_salperiod:         Result:=CreateAndViewSalPeriod(Params,isModal);
    tte_optsBuildingtree:       Result:=CreateAndViewBuildingTree(Params,isModal);
    tte_optssalary:       Result:=CreateAndViewSalary(Params,isModal);
    tte_rbkscalcperiod:         Result:=CreateAndViewCalcPeriod(Params,isModal,onlydata);
    tte_rbksPrivelege:         Result:=CreateAndViewPrivelege(Params,isModal,onlydata);
  end;
 except
  {$IFDEF DEBUG} //on E: Exception do Assert(false,E.message); {$ENDIF}
// end;
//end;
//------------------------------------------------------------------------
procedure SetAppAndScreen_(A: TApplication; S: TScreen);stdcall;
begin
  Application:=A;
  Screen:=S;
  if fmOptions<>nil then
   fmOptions.ParentWindow:=A.Handle;
end;
//------------------------------------------------------------------------
procedure SetConnection_(IBDbase: TIBDatabase; IBTran: TIBTransaction;
                         IBDBSecurity: TIBDatabase; IBTSecurity: TIBTransaction);stdcall;
begin
  IBDB:=IBDbase;
  IBT:=IBTran;
  IBDBSec:=IBDBSecurity;
  IBTSec:=IBTSecurity;
  CalculateInit(IBDbase);
  InitCalendarUtil(IBDbase);
end;
//------------------------------------------------------------------------
//------------------------------------------------------------------------
{   procedure SetNewDbGirdProp(Grid: TNewDBgrid);
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
  end;}
//------------------------------------------------------------------------
  procedure SetTreeViewProp(TV: TDBTreeView);
  begin
    AssignFont(_GetOptions.RBTableFont,TV.Font);
  end;

procedure RefreshLibrary_;stdcall;
begin
 try
  Screen.Cursor:=crHourGlass;
  try
    ClearListInterfaceHandles;
    AddToListInterfaceHandles;

    ClearListMenuHandles;
    AddToListMenuRootHandles;

    ClearListOptionHandles;
    AddToListOptionRootHandles;

    FreeAndNil(fmOptions);
    fmOptions:=TfmOptions.Create(nil);
    fmOptions.ParentWindow:=Application.Handle;

    ClearListToolBarHandles;
    AddToListToolBarHandles;
  finally
    Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;



//**************** end of Export *************************

end.
