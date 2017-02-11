unit UStaffTsvCode;

interface

{$I stbasis.inc}

uses Windows, Forms, UStaffTsvData, UMainUnited, Classes, UStaffTsvDm, graphics, dialogs,
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
procedure AfterSetOptionProc(OptionHandle: THandle; isOK: Boolean);stdcall;
function isPermissionOnInterfaceView(InterfaceHandle: THandle): Boolean;

// Export
procedure InitAll_;stdcall;
procedure GetInfoLibrary_(P: PInfoLibrary);stdcall;
procedure RefreshLibrary_;stdcall;
procedure SetConnection_(IBDbase: TIBDatabase; IBTran: TIBTransaction;
                         IBDBSecurity: TIBDatabase; IBTSecurity: TIBTransaction);stdcall;

// Import
function _isPermission(sqlObject: PChar; sqlOperator: PChar): Boolean;stdcall;
                         external MainExe name ConstisPermission;
function _isPermissionSecurity(sqlObject: PChar; sqlOperator: PChar): Boolean;stdcall;
                         external MainExe name ConstisPermissionSecurity;
function _isPermissionColumn(sqlObject,objColumn,sqlOperator: PChar): Boolean;stdcall;
                         external MainExe name ConstisPermissionColumn;

procedure _SetSplashStatus(Status: Pchar);stdcall;
                         external MainExe name ConstSetSplashStatus;
procedure _GetProtocolAndServerName(DataBaseStr: Pchar; var Protocol: TProtocol;
                                   var ServerName: Pchar);stdcall;
                         external MainExe name ConstGetProtocolAndServerName;
procedure _GetInfoConnectUser(P: PInfoConnectUser);stdcall;
                         external MainExe name ConstGetInfoConnectUser;
procedure _AddErrorToJournal(Error: PChar; ClassError: TClass);stdcall;
                         external MainExe name ConstAddErrorToJournal;
procedure _AddSqlOperationToJournal(Name,Hint: PChar);stdcall;
                         external MainExe name ConstAddSqlOperationToJournal;
function _GetDateTimeFromServer: TDateTime;stdcall;
                         external MainExe name ConstGetDateTimeFromServer;
                         
function _CreateProgressBar(PCPB: PCreateProgressBar): THandle;stdcall;
                            external MainExe name ConstCreateProgressBar;
function _FreeProgressBar(ProgressBarHandle: THandle): Boolean;stdcall;
                          external MainExe name ConstFreeProgressBar;
procedure _SetProgressBarStatus(ProgressBarHandle: THandle; PSPBS: PSetProgressBarStatus);stdcall;
                                external MainExe name ConstSetProgressBarStatus;

function _ViewEnterPeriod(P: PInfoEnterPeriod): Boolean;stdcall;
                         external MainExe name ConstViewEnterPeriod;
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

function _ClearLog: Boolean;stdcall;
                   external MainExe name ConstClearLog;
procedure _ViewLog(Visible: Boolean);stdcall;
                   external MainExe name ConstViewLog;
function _CreateLogItem(PCLI: PCreateLogItem): THandle;stdcall;
                        external MainExe name ConstCreateLogItem;
function _FreeLogItem(LogItemHandle: THandle): Boolean;stdcall;
                      external MainExe name ConstFreeLogItem;
                                       

implementation

uses ActiveX,Menus,tsvDbGrid,dbtree,

     URBProfession, URBTypeStud, URBEduc, URBCraft,
     URBSciencename, URBLanguage, URBKnowlevel, URBMilrank, URBRank,
     URBGroupmil, URBConnectiontype, URBFamilystate, URBProperty, URBEmp,
     URBPlant, URBSchool, URBReady, URBTypeRelation, URBTypeLive, URBSex,
     URBCurrency, URBRateCurrency, URBSick, URBTypeEncouragements,URBTypeResQual,
     URBBustripstous, URBAddAccount, URBTypeReferences,

     UStaffTsvOptions,

     URptEmpUniversal;

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

  isInitAll:=true;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure DeInitAll;
begin
 try
  if not isInitAll then exit;
  
  FreeAndNil(fmRBEmp);
  FreeAndNil(fmRBEmpConnect);
  FreeAndNil(fmRBProfession);
  FreeAndNil(fmRBTypeStud);
  FreeAndNil(fmRBEduc);
  FreeAndNil(fmRBCraft);
  FreeAndNil(fmRBSciencename);
  FreeAndNil(fmRBLanguage);
  FreeAndNil(fmRBKnowlevel);
  FreeAndNil(fmRBMilrank);
  FreeAndNil(fmRBRank);
  FreeAndNil(fmRBGroupmil);
  FreeAndNil(fmRBConnectiontype);
  FreeAndNil(fmRBFamilystate);
  FreeAndNil(fmRBProperty);
  FreeAndNil(fmRBPlant);
  FreeAndNil(fmRBSchool);
  FreeAndNil(fmRBReady);
  FreeAndNil(fmRBTypeRelation);
  FreeAndNil(fmRBTypeLive);
  FreeAndNil(fmRBSex);
  FreeAndNil(fmRBCurrency);
  FreeAndNil(fmRBRateCurrency);
  FreeAndNil(fmRBSick);
  FreeAndNil(fmRBTypeEncouragements);
  FreeAndNil(fmRBTypeResQual);
  FreeAndNil(fmRBBustripstous);
  FreeAndNil(fmRBTypeReferences);

  FreeAndNil(fmRptEmpUniversal);

  FreeAndNil(fmOptions);
  
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
//  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure ClearListToolBarHandles;
var
  i: Integer;
begin
  for i:=0 to ListToolBarHandles.Count-1 do begin
    _FreeToolBar(THandle(ListToolBarHandles.Items[i]));
  end;
  ListToolBarHandles.Clear;
end;

procedure ToolButtonClickProc(ToolButtonHandle: THandle);stdcall;
begin
  if ToolButtonHandle=hToolButtonEmp then MenuClickProc(hMenuRBooksEmp);
end;

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
  if (hMenuRBooksEmp<>MENU_INVALID_HANDLE) then begin
   tbar1:=CreateToolBarLocal('Кадры','Панель кадров',0);
   ListToolBarHandles.Add(Pointer(tbar1));
   if hMenuRBooksEmp<>MENU_INVALID_HANDLE then
    hToolButtonEmp:=CreateToolButtonLocal(tbar1,'Сотрудники',NameRbkEmp,2,ToolButtonClickProc);
   _RefreshToolBar(tbar1);
  end;
end;

procedure ClearListOptionHandles;
var
  i: Integer;
begin
  for i:=0 to ListOptionHandles.Count-1 do begin
    _FreeOption(THandle(ListOptionHandles.Items[i]));
  end;
  ListOptionHandles.Clear;
end;

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
  if hMenuRBooksEmp<>MENU_INVALID_HANDLE then begin
   hOptionEmp:=CreateOptionLocal(hOptionRBooks,NameRbkEmp,2);
  end;
end;

procedure BeforeSetOptionProc(OptionHandle: THandle);stdcall;

  procedure BeforeSetOption;
  var
    wc: TWinControl;
  begin
    if OptionHandle=hOptionEmp then begin
     wc:=FindControl(_GetOptionParentWindow(hOptionEmp));
     if isValidPointer(wc) then begin
      fmOptions.pc.ActivePage:=fmOptions.tsRBEmp;
      fmOptions.pnRBEmp.Parent:=wc;
     end;
    end;   
  end;

begin
  fmOptions.Visible:=true;
  fmOptions.LoadFromIni;
  BeforeSetOption;
end;

procedure AfterSetOptionProc(OptionHandle: THandle; isOK: Boolean);stdcall;

  procedure AfterSetOption;
  begin
     if OptionHandle=hOptionEmp then begin
      fmOptions.pnRBEmp.Parent:=fmOptions.tsRBEmp;
      if fmRBEmp<>nil then fmRBEmp.SetParamsFromOptions; 
     end;
  end;

begin
   AfterSetOption;

   if isOK then fmOptions.SaveToIni;

   fmOptions.Visible:=false;

  if isOk then begin
    if fmRBEmp<>nil then SetProperties(fmRBEmp);
    if fmRBProfession<>nil then SetProperties(fmRBProfession);
    if fmRBTypeStud<>nil then SetProperties(fmRBTypeStud);
    if fmRBEduc<>nil then SetProperties(fmRBEduc);
    if fmRBCraft<>nil then SetProperties(fmRBCraft);
    if fmRBSciencename<>nil then SetProperties(fmRBSciencename);
    if fmRBLanguage<>nil then SetProperties(fmRBLanguage);
    if fmRBKnowlevel<>nil then SetProperties(fmRBKnowlevel);
    if fmRBMilrank<>nil then SetProperties(fmRBMilrank);
    if fmRBRank<>nil then SetProperties(fmRBRank);
    if fmRBGroupmil<>nil then SetProperties(fmRBGroupmil);
    if fmRBConnectiontype<>nil then SetProperties(fmRBConnectiontype);
    if fmRBFamilystate<>nil then SetProperties(fmRBFamilystate);
    if fmRBProperty<>nil then begin
     SetProperties(fmRBProperty);
     fmRBProperty.CursorColor:=_GetOptions.RBTableCursorColor;
    end;
    if fmRBPlant<>nil then SetProperties(fmRBPlant);
    if fmRBSchool<>nil then SetProperties(fmRBSchool);
    if fmRBReady<>nil then SetProperties(fmRBReady);
    if fmRBTypeRelation<>nil then SetProperties(fmRBTypeRelation);
    if fmRBTypeLive<>nil then SetProperties(fmRBTypeLive);
    if fmRBSex<>nil then SetProperties(fmRBSex);
    if fmRBCurrency<>nil then SetProperties(fmRBCurrency);
    if fmRBRateCurrency<>nil then SetProperties(fmRBRateCurrency);
    if fmRBSick<>nil then SetProperties(fmRBSick);
    if fmRBTypeEncouragements<>nil then SetProperties(fmRBTypeEncouragements);
    if fmRBTypeResQual<>nil then SetProperties(fmRBTypeResQual);
    if fmRBBustripstous<>nil then SetProperties(fmRBBustripstous);
    if fmRBTypeReferences<>nil then SetProperties(fmRBTypeReferences);
  end;

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

procedure MenuClickProc(MenuHandle: THandle);stdcall;
var
  TPRBI: TParamRBookInterface;
  TPRI: TParamReportInterface;
{  TCLI: TCreateLogItem;
  h: THandle;}
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  FillChar(TPRI,SizeOf(TPRI),0);

  if MenuHandle=hMenuTest then begin
{    TCLI.Text:='Test';
    TCLI.TypeLogItem:=tliConfirmation;
    TCLI.ViewLogItemProc:=nil;
    h:=_CreateLogItem(@TCLI);
    _ViewLog(true);
    Sleep(3000);
    _FreeLogItem(h);}
  end;

  if MenuHandle=hMenuRBooksEmp then ViewInterface(hInterfaceRbkEmp,@TPRBI);
  if MenuHandle=hMenuRBooksProfession then ViewInterface(hInterfaceRbkProfession,@TPRBI);
  if MenuHandle=hMenuRBooksTypeStud then ViewInterface(hInterfaceRbkTypeStud,@TPRBI);
  if MenuHandle=hMenuRBooksEduc then ViewInterface(hInterfaceRbkEduc,@TPRBI);
  if MenuHandle=hMenuRBooksCraft then ViewInterface(hInterfaceRbkCraft,@TPRBI);
  if MenuHandle=hMenuRBooksSciencename then ViewInterface(hInterfaceRbkSciencename,@TPRBI);
  if MenuHandle=hMenuRBooksLanguage then ViewInterface(hInterfaceRbkLanguage,@TPRBI);
  if MenuHandle=hMenuRBooksKnowLevel then ViewInterface(hInterfaceRbkKnowLevel,@TPRBI);
  if MenuHandle=hMenuRBooksMilRank then ViewInterface(hInterfaceRbkMilRank,@TPRBI);
  if MenuHandle=hMenuRBooksRank then ViewInterface(hInterfaceRbkRank,@TPRBI);
  if MenuHandle=hMenuRBooksGroupmil then ViewInterface(hInterfaceRbkGroupmil,@TPRBI);
  if MenuHandle=hMenuRBooksConnectiontype then ViewInterface(hInterfaceRbkConnectiontype,@TPRBI);
  if MenuHandle=hMenuRBooksFamilystate then ViewInterface(hInterfaceRbkFamilystate,@TPRBI);
  if MenuHandle=hMenuRBooksProperty then ViewInterface(hInterfaceRbkProperty,@TPRBI);
  if MenuHandle=hMenuRBooksPlant then ViewInterface(hInterfaceRbkPlant,@TPRBI);
  if MenuHandle=hMenuRBooksSchool then ViewInterface(hInterfaceRbkSchool,@TPRBI);
  if MenuHandle=hMenuRBooksReady then ViewInterface(hInterfaceRbkReady,@TPRBI);
  if MenuHandle=hMenuRBooksTypeRelation then ViewInterface(hInterfaceRbkTypeRelation,@TPRBI);
  if MenuHandle=hMenuRBooksTypeLive then ViewInterface(hInterfaceRbkTypeLive,@TPRBI);
  if MenuHandle=hMenuRBooksSex then ViewInterface(hInterfaceRbkSex,@TPRBI);
  if MenuHandle=hMenuRBooksCurrency then ViewInterface(hInterfaceRbkCurrency,@TPRBI);
  if MenuHandle=hMenuRBooksRateCurrency then ViewInterface(hInterfaceRbkRateCurrency,@TPRBI);
  if MenuHandle=hMenuRBooksSick then ViewInterface(hInterfaceRbkSick,@TPRBI);
  if MenuHandle=hMenuRBooksTypeEncouragements then ViewInterface(hInterfaceRbkTypeEncouragements,@TPRBI);
  if MenuHandle=hMenuRBooksTypeResQual then ViewInterface(hInterfaceRbkTypeResQual,@TPRBI);
  if MenuHandle=hMenuRBooksBustripstous then ViewInterface(hInterfaceRbkBustripstous,@TPRBI);
  if MenuHandle=hMenuRBooksTypeReferences then ViewInterface(hInterfaceRbkTypeReferences,@TPRBI);

  if MenuHandle=hMenuRptsEmpUniversal then ViewInterface(hInterfaceRptEmpUniversal,@TPRI);

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
  isFreeMenuRBooksEducations: Boolean;
  isFreeMenuRBooksMilitaryes: Boolean;
  isFreeMenuRBooksAny: Boolean;
  isFreeMenuRBooksFinances: Boolean;
  isFreeMenuRBooksATE: Boolean;
  isFreeMenuRptsStaff: Boolean;
  isFreeMenuRBooksStaff: Boolean;
  isFreeMenuRBooks: Boolean;
  isFreeMenuRpts: Boolean;
   
begin
  ListMenuHandles.Clear;
  {hMenuTest:=CreateMenuLocal(MENU_ROOT_HANDLE,'Test','',tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);
  ListMenuHandles.Add(Pointer(hMenuTest));  }

  hMenuRBooks:=CreateMenuLocal(MENU_ROOT_HANDLE,ConstsMenuRBooks,PChar(ChangeString(ConstsMenuRBooks,'&','')),
                               tcmInsertBefore,_GetMenuHandleFromName(MENU_ROOT_HANDLE,ConstsMenuService));
  ListMenuHandles.Add(Pointer(hMenuRBooks));
  hMenuRBooksStaff:=CreateMenuLocal(hMenuRBooks,ConstsMenuStaff,ConstsMenuStaff,tcmAddFirst);
  CreateMenuLocal(hMenuRBooksStaff,ConstsMenuSeparator,'');
  hMenuRBooksEmp:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkEmp) then
   hMenuRBooksEmp:=CreateMenuLocal(hMenuRBooksStaff,'Сотрудники',NameRbkEmp,tcmAddLast,MENU_INVALID_HANDLE,2,ShortCut(Word('S'),[ssCtrl]),MenuClickProc);
  hMenuRBooksProperty:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkProperty) then
   hMenuRBooksProperty:=CreateMenuLocal(hMenuRBooksStaff,'Группы сотрудников',NameRbkProperty,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuRBooksEducations:=CreateMenuLocal(hMenuRBooksStaff,ConstsMenuEducation,'Справочники по образованиям',tcmAddFirst);
  hMenuRBooksProfession:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkProfession) then
   hMenuRBooksProfession:=CreateMenuLocal(hMenuRBooksEducations,'Специальности по диплому',NameRbkProfession,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);
  hMenuRBooksTypeStud:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkTypeStud) then
   hMenuRBooksTypeStud:=CreateMenuLocal(hMenuRBooksEducations,'Виды обучений',NameRbkTypeStud,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);
  hMenuRBooksEduc:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkEduc) then
   hMenuRBooksEduc:=CreateMenuLocal(hMenuRBooksEducations,'Виды образований',NameRbkEduc,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);
  hMenuRBooksCraft:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkCraft) then
   hMenuRBooksCraft:=CreateMenuLocal(hMenuRBooksEducations,'Квалификации по диплому',NameRbkCraft,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);
  hMenuRBooksSciencename:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkSciencename) then
   hMenuRBooksSciencename:=CreateMenuLocal(hMenuRBooksEducations,'Ученые звания',NameRbkSciencename,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);
  hMenuRBooksLanguage:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkLanguage) then
   hMenuRBooksLanguage:=CreateMenuLocal(hMenuRBooksEducations,'Иностранные языки',NameRbkLanguage,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);
  hMenuRBooksKnowLevel:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkKnowLevel) then
   hMenuRBooksKnowLevel:=CreateMenuLocal(hMenuRBooksEducations,'Уровни знаний',NameRbkKnowlevel,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);
  hMenuRBooksSchool:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkSchool) then
   hMenuRBooksSchool:=CreateMenuLocal(hMenuRBooksEducations,'Учебные заведения',NameRbkSchool,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuRBooksMilitaryes:=CreateMenuLocal(hMenuRBooksStaff,ConstsMenuMilitary,'Справочники по воинскому учету',tcmAddFirst);
  hMenuRBooksMilRank:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkMilRank) then
   hMenuRBooksMilRank:=CreateMenuLocal(hMenuRBooksMilitaryes,'Воинские звания',NameRbkMilrank,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);
  hMenuRBooksRank:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkRank) then
   hMenuRBooksRank:=CreateMenuLocal(hMenuRBooksMilitaryes,'Воинский состав',NameRbkRank,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);
  hMenuRBooksGroupmil:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkGroupmil) then
   hMenuRBooksGroupmil:=CreateMenuLocal(hMenuRBooksMilitaryes,'Группы воинского учета',NameRbkGroupmil,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);
  hMenuRBooksReady:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkReady) then
   hMenuRBooksReady:=CreateMenuLocal(hMenuRBooksMilitaryes,'Годность военнообязанных',NameRbkReady,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuRBooksAny:=CreateMenuLocal(hMenuRBooksStaff,ConstsMenuAny,'Другие справочники',tcmAddFirst);
  hMenuRBooksTypeReferences:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkTypeReferences) then
   hMenuRBooksTypeReferences:=CreateMenuLocal(hMenuRBooksAny,'Виды справок',NameRbkTypeReferences,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);
  hMenuRBooksConnectiontype:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkConnectiontype) then
   hMenuRBooksConnectiontype:=CreateMenuLocal(hMenuRBooksAny,'Средства связи',NameRbkConnectiontype,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);
  hMenuRBooksTypeRelation:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkTypeRelation) then
   hMenuRBooksTypeRelation:=CreateMenuLocal(hMenuRBooksAny,'Категории родственников',NameRbkTypeRelation,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);
  hMenuRBooksFamilystate:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkFamilystate) then
   hMenuRBooksFamilystate:=CreateMenuLocal(hMenuRBooksAny,'Семейные положения',NameRbkFamilystate,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);
  hMenuRBooksTypeEncouragements:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkTypeEncouragements) then
   hMenuRBooksTypeEncouragements:=CreateMenuLocal(hMenuRBooksAny,'Виды поощрений',NameRbkTypeEncouragements,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);
  hMenuRBooksSex:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkSex) then
   hMenuRBooksSex:=CreateMenuLocal(hMenuRBooksAny,'Пол',NameRbkSex,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);
  hMenuRBooksSick:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkSick) then
   hMenuRBooksSick:=CreateMenuLocal(hMenuRBooksAny,'Болезни',NameRbkSick,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);
  hMenuRBooksTypeResQual:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkTypeResQual) then
   hMenuRBooksTypeResQual:=CreateMenuLocal(hMenuRBooksAny,'Типы результатов аттестации',NameRbkTypeResQual,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);
  hMenuRBooksBustripstous:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkBustripstous) then
   hMenuRBooksBustripstous:=CreateMenuLocal(hMenuRBooksAny,'Командировки к нам',NameRbkBustripstous,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuRBooksFinances:=CreateMenuLocal(hMenuRBooks,ConstsMenuFinances,ConstsMenuFinances,tcmAddFirst);
  hMenuRBooksPlant:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkPlant) then
   hMenuRBooksPlant:=CreateMenuLocal(hMenuRBooksFinances,'Контрагенты',NameRBkPlant,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);
  hMenuRBooksCurrency:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkCurrency) then
   hMenuRBooksCurrency:=CreateMenuLocal(hMenuRBooksFinances,'Валюты',NameRbkCurrency,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);
  hMenuRBooksRateCurrency:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkRateCurrency) then
   hMenuRBooksRateCurrency:=CreateMenuLocal(hMenuRBooksFinances,'Курсы валют',NameRbkRateCurrency,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuRBooksATE:=CreateMenuLocal(hMenuRBooks,ConstsMenuATE,ConstsMenuATE,tcmAddFirst);
  hMenuRBooksTypeLive:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkTypeLive) then
   hMenuRBooksTypeLive:=CreateMenuLocal(hMenuRBooksATE,'Виды проживаний',NameRbkTypeLive,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuRpts:=CreateMenuLocal(MENU_ROOT_HANDLE,ConstsMenuReports,PChar(ChangeString(ConstsMenuReports,'&','')),
                               tcmInsertBefore,_GetMenuHandleFromName(MENU_ROOT_HANDLE,ConstsMenuService));
  ListMenuHandles.Add(Pointer(hMenuRpts));
  hMenuRptsStaff:=CreateMenuLocal(hMenuRpts,ConstsMenuRptStaff,ConstsMenuRptStaff,tcmAddFirst);
  hMenuRptsEmpUniversal:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRptEmpUniversal) then
   hMenuRptsEmpUniversal:=CreateMenuLocal(hMenuRptsStaff,'Сотрудники',NameRptEmpUniversal,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);


  isFreeMenuRBooksEducations:=(hMenuRBooksEducations<>MENU_INVALID_HANDLE)and
                              (hMenuRBooksProfession=MENU_INVALID_HANDLE)and
                              (hMenuRBooksTypeStud=MENU_INVALID_HANDLE)and
                              (hMenuRBooksEduc=MENU_INVALID_HANDLE)and
                              (hMenuRBooksCraft=MENU_INVALID_HANDLE)and
                              (hMenuRBooksLanguage=MENU_INVALID_HANDLE)and
                              (hMenuRBooksKnowLevel=MENU_INVALID_HANDLE)and
                              (hMenuRBooksSchool=MENU_INVALID_HANDLE);
  if isFreeMenuRBooksEducations then
    if _FreeMenu(hMenuRBooksEducations) then hMenuRBooksEducations:=MENU_INVALID_HANDLE;

  isFreeMenuRBooksMilitaryes:=(hMenuRBooksMilitaryes<>MENU_INVALID_HANDLE)and
                              (hMenuRBooksMilRank=MENU_INVALID_HANDLE)and
                              (hMenuRBooksRank=MENU_INVALID_HANDLE)and
                              (hMenuRBooksGroupmil=MENU_INVALID_HANDLE)and
                              (hMenuRBooksReady=MENU_INVALID_HANDLE);
  if isFreeMenuRBooksMilitaryes then
    if _FreeMenu(hMenuRBooksMilitaryes) then hMenuRBooksMilitaryes:=MENU_INVALID_HANDLE;

  isFreeMenuRBooksAny:=(hMenuRBooksAny<>MENU_INVALID_HANDLE)and
                       (hMenuRBooksTypeReferences=MENU_INVALID_HANDLE)and
                       (hMenuRBooksConnectiontype=MENU_INVALID_HANDLE)and
                       (hMenuRBooksFamilystate=MENU_INVALID_HANDLE)and
                       (hMenuRBooksTypeEncouragements=MENU_INVALID_HANDLE)and
                       (hMenuRBooksSex=MENU_INVALID_HANDLE)and
                       (hMenuRBooksSick=MENU_INVALID_HANDLE)and
                       (hMenuRBooksTypeResQual=MENU_INVALID_HANDLE)and
                       (hMenuRBooksBustripstous=MENU_INVALID_HANDLE);
  if isFreeMenuRBooksAny then
    if _FreeMenu(hMenuRBooksAny) then hMenuRBooksAny:=MENU_INVALID_HANDLE;

  isFreeMenuRBooksFinances:=(hMenuRBooksFinances<>MENU_INVALID_HANDLE)and
                            (hMenuRBooksPlant=MENU_INVALID_HANDLE)and
                            (hMenuRBooksCurrency=MENU_INVALID_HANDLE)and
                            (hMenuRBooksRateCurrency=MENU_INVALID_HANDLE);
  if isFreeMenuRBooksFinances then
    if _FreeMenu(hMenuRBooksFinances) then hMenuRBooksFinances:=MENU_INVALID_HANDLE;

  isFreeMenuRBooksATE:=(hMenuRBooksATE<>MENU_INVALID_HANDLE)and
                       (hMenuRBooksTypeLive=MENU_INVALID_HANDLE);
  if isFreeMenuRBooksATE then
    if _FreeMenu(hMenuRBooksATE) then hMenuRBooksATE:=MENU_INVALID_HANDLE;

  isFreeMenuRptsStaff:=(hMenuRptsStaff<>MENU_INVALID_HANDLE)and
                       (hMenuRptsEmpUniversal=MENU_INVALID_HANDLE);
  if isFreeMenuRptsStaff then
    if _FreeMenu(hMenuRptsStaff) then hMenuRptsStaff:=MENU_INVALID_HANDLE;


  isFreeMenuRBooksStaff:=(hMenuRBooksStaff<>MENU_INVALID_HANDLE)and
                         (hMenuRBooksEmp=MENU_INVALID_HANDLE)and
                         (hMenuRBooksProperty=MENU_INVALID_HANDLE)and
                         (hMenuRBooksEducations=MENU_INVALID_HANDLE)and
                         (hMenuRBooksMilitaryes=MENU_INVALID_HANDLE)and
                         (hMenuRBooksAny=MENU_INVALID_HANDLE);
  if isFreeMenuRBooksStaff then
    if _FreeMenu(hMenuRBooksStaff) then hMenuRBooksStaff:=MENU_INVALID_HANDLE;


  isFreeMenuRBooks:=(hMenuRBooks<>MENU_INVALID_HANDLE)and
                    (hMenuRBooksStaff=MENU_INVALID_HANDLE)and
                    (hMenuRBooksFinances=MENU_INVALID_HANDLE)and
                    (hMenuRBooksATE=MENU_INVALID_HANDLE);
  if isFreeMenuRBooks then
    if _FreeMenu(hMenuRBooks) then hMenuRBooks:=MENU_INVALID_HANDLE;

  isFreeMenuRpts:=(hMenuRpts<>MENU_INVALID_HANDLE)and
                  (hMenuRptsStaff=MENU_INVALID_HANDLE);
  if isFreeMenuRpts then
    if _FreeMenu(hMenuRpts) then hMenuRpts:=MENU_INVALID_HANDLE;

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
  
  hInterfaceRbkEmp:=CreateLocalInterface(NameRbkEmp,NameRbkEmp);
  CreateLocalPermission(hInterfaceRbkEmp,tbEmp,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmp,tbFamilystate,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmp,tbNation,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmp,tbCountry,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmp,tbRegion,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmp,tbState,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmp,tbTown,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmp,tbPlaceMent,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmp,tbEmpPlant,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmp,tbSex,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmp,tbEmp,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkEmp,tbEmp,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkEmp,tbEmp,ttpDelete,false,ttiaDelete);

  hInterfaceRbkEmpConnect:=CreateLocalInterface(NameRbkEmpConnect,NameRbkEmpConnect);
  CreateLocalPermission(hInterfaceRbkEmpConnect,tbEmpConnect,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpConnect,tbConnectiontype,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpConnect,tbEmpConnect,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkEmpConnect,tbEmpConnect,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkEmpConnect,tbEmpConnect,ttpDelete,false,ttiaDelete);

  hInterfaceRbkEmpSciencename:=CreateLocalInterface(NameRbkEmpSciencename,NameRbkEmpSciencename);
  CreateLocalPermission(hInterfaceRbkEmpSciencename,tbEmpSciencename,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpSciencename,tbSciencename,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpSciencename,tbSchool,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpSciencename,tbEmpSciencename,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkEmpSciencename,tbEmpSciencename,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkEmpSciencename,tbEmpSciencename,ttpDelete,false,ttiaDelete);

  hInterfaceRbkEmpLanguage:=CreateLocalInterface(NameRbkEmpLanguage,NameRbkEmpLanguage);
  CreateLocalPermission(hInterfaceRbkEmpLanguage,tbEmpLanguage,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpLanguage,tbLanguage,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpLanguage,tbKnowlevel,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpLanguage,tbEmpLanguage,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkEmpLanguage,tbEmpLanguage,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkEmpLanguage,tbEmpLanguage,ttpDelete,false,ttiaDelete);

  hInterfaceRbkEmpChildren:=CreateLocalInterface(NameRbkEmpChildren,NameRbkEmpChildren);
  CreateLocalPermission(hInterfaceRbkEmpChildren,tbEmpChildren,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpChildren,tbTypeRelation,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpChildren,tbSex,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpChildren,tbEmpChildren,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkEmpChildren,tbEmpChildren,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkEmpChildren,tbEmpChildren,ttpDelete,false,ttiaDelete);

  hInterfaceRbkEmpProperty:=CreateLocalInterface(NameRbkEmpProperty,NameRbkEmpProperty);
  CreateLocalPermission(hInterfaceRbkEmpProperty,tbEmpProperty,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpProperty,tbEmpProperty,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkEmpProperty,tbEmpProperty,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkEmpProperty,tbEmpProperty,ttpDelete,false,ttiaDelete);

  hInterfaceRbkEmpStreet:=CreateLocalInterface(NameRbkEmpStreet,NameRbkEmpStreet);
  CreateLocalPermission(hInterfaceRbkEmpStreet,tbEmpStreet,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpStreet,tbCountry,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpStreet,tbState,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpStreet,tbRegion,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpStreet,tbPlaceMent,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpStreet,tbStreet,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpStreet,tbTown,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpStreet,tbTypeLive,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpStreet,tbEmpStreet,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkEmpStreet,tbEmpStreet,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkEmpStreet,tbEmpStreet,ttpDelete,false,ttiaDelete);

  hInterfaceRbkEmpPersonDoc:=CreateLocalInterface(NameRbkEmpPersonDoc,NameRbkEmpPersonDoc);
  CreateLocalPermission(hInterfaceRbkEmpPersonDoc,tbEmpPersonDoc,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpPersonDoc,tbPersonDocType,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpPersonDoc,tbPlant,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpPersonDoc,tbEmpPersonDoc,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkEmpPersonDoc,tbEmpPersonDoc,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkEmpPersonDoc,tbEmpPersonDoc,ttpDelete,false,ttiaDelete);

  hInterfaceRbkEmpMilitary:=CreateLocalInterface(NameRbkEmpMilitary,NameRbkEmpMilitary);
  CreateLocalPermission(hInterfaceRbkEmpMilitary,tbMilitary,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpMilitary,tbPlant,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpMilitary,tbGroupmil,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpMilitary,tbRank,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpMilitary,tbMilRank,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpMilitary,tbReady,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpMilitary,tbMilitary,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkEmpMilitary,tbMilitary,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkEmpMilitary,tbMilitary,ttpDelete,false,ttiaDelete);

  hInterfaceRbkEmpDiplom:=CreateLocalInterface(NameRbkEmpDiplom,NameRbkEmpDiplom);
  CreateLocalPermission(hInterfaceRbkEmpDiplom,tbDiplom,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpDiplom,tbProfession,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpDiplom,tbTypeStud,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpDiplom,tbEduc,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpDiplom,tbCraft,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpDiplom,tbSchool,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpDiplom,tbDiplom,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkEmpDiplom,tbDiplom,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkEmpDiplom,tbDiplom,ttpDelete,false,ttiaDelete);

  hInterfaceRbkEmpBiography:=CreateLocalInterface(NameRbkEmpBiography,NameRbkEmpBiography);
  CreateLocalPermission(hInterfaceRbkEmpBiography,tbBiography,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpBiography,tbBiography,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkEmpBiography,tbBiography,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkEmpBiography,tbBiography,ttpDelete,false,ttiaDelete);

  hInterfaceRbkEmpPhoto:=CreateLocalInterface(NameRbkEmpPhoto,NameRbkEmpPhoto);
  CreateLocalPermission(hInterfaceRbkEmpPhoto,tbPhoto,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpPhoto,tbPhoto,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkEmpPhoto,tbPhoto,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkEmpPhoto,tbPhoto,ttpDelete,false,ttiaDelete);

  hInterfaceRbkEmpPlant:=CreateLocalInterface(NameRbkEmpPlant,NameRbkEmpPlant);
  CreateLocalPermission(hInterfaceRbkEmpPlant,tbEmpPlant,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpPlant,tbNet,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpPlant,tbClass,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpPlant,tbPlant,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpPlant,tbDocum,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpPlant,tbSeat,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpPlant,tbDepart,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpPlant,tbMotive,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpPlant,tbProf,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpPlant,tbSchedule,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpPlant,tbEmpPlant,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkEmpPlant,tbEmpPlant,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkEmpPlant,tbFactPay,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkEmpPlant,tbEmpPlantSchedule,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkEmpPlant,tbEmpPlant,ttpDelete,false,ttiaDelete);

  hInterfaceRbkEmpFaceAccount:=CreateLocalInterface(NameRbkEmpFaceAccount,NameRbkEmpFaceAccount);
  CreateLocalPermission(hInterfaceRbkEmpFaceAccount,tbEmpFaceAccount,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpFaceAccount,tbCurrency,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpFaceAccount,tbBank,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpFaceAccount,tbEmpFaceAccount,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkEmpFaceAccount,tbEmpFaceAccount,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkEmpFaceAccount,tbEmpFaceAccount,ttpDelete,false,ttiaDelete);

  hInterfaceRbkEmpSickList:=CreateLocalInterface(NameRbkEmpSickList,NameRbkEmpSickList);
  CreateLocalPermission(hInterfaceRbkEmpSickList,tbEmpSickList,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpSickList,tbSick,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpSickList,tbAbsence,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpSickList,tbEmpSickList,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkEmpSickList,tbEmpSickList,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkEmpSickList,tbEmpSickList,ttpDelete,false,ttiaDelete);

  hInterfaceRbkEmpLaborBook:=CreateLocalInterface(NameRbkEmpLaborBook,NameRbkEmpLaborBook);
  CreateLocalPermission(hInterfaceRbkEmpLaborBook,tbEmpLaborBook,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpLaborBook,tbProf,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpLaborBook,tbPlant,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpLaborBook,tbMotive,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpLaborBook,tbEmpLaborBook,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkEmpLaborBook,tbEmpLaborBook,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkEmpLaborBook,tbEmpLaborBook,ttpDelete,false,ttiaDelete);

  hInterfaceRbkEmpRefreshCourse:=CreateLocalInterface(NameRbkEmpRefreshCourse,NameRbkEmpRefreshCourse);
  CreateLocalPermission(hInterfaceRbkEmpRefreshCourse,tbEmpRefreshCourse,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpRefreshCourse,tbProf,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpRefreshCourse,tbPlant,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpRefreshCourse,tbDocum,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpRefreshCourse,tbAbsence,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpRefreshCourse,tbEmpRefreshCourse,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkEmpRefreshCourse,tbEmpRefreshCourse,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkEmpRefreshCourse,tbEmpRefreshCourse,ttpDelete,false,ttiaDelete);

  hInterfaceRbkEmpLeave:=CreateLocalInterface(NameRbkEmpLeave,NameRbkEmpLeave);
  CreateLocalPermission(hInterfaceRbkEmpLeave,tbEmpLeave,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpLeave,tbDocum,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpLeave,tbTypeLeave,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpLeave,tbAbsence,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpLeave,tbEmpLeave,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkEmpLeave,tbEmpLeave,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkEmpLeave,tbEmpLeave,ttpDelete,false,ttiaDelete);

  hInterfaceRbkEmpQual:=CreateLocalInterface(NameRbkEmpQual,NameRbkEmpQual);
  CreateLocalPermission(hInterfaceRbkEmpQual,tbEmpQual,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpQual,tbDocum,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpQual,tbTypeResQual,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpQual,tbEmpQual,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkEmpQual,tbEmpQual,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkEmpQual,tbEmpQual,ttpDelete,false,ttiaDelete);

  hInterfaceRbkEmpEncouragements:=CreateLocalInterface(NameRbkEmpEncouragements,NameRbkEmpEncouragements);
  CreateLocalPermission(hInterfaceRbkEmpEncouragements,tbEmpEncouragements,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpEncouragements,tbDocum,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpEncouragements,tbTypeEncouragements,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpEncouragements,tbEmpEncouragements,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkEmpEncouragements,tbEmpEncouragements,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkEmpEncouragements,tbEmpEncouragements,ttpDelete,false,ttiaDelete);

  hInterfaceRbkEmpBustripsfromus:=CreateLocalInterface(NameRbkEmpBustripsfromus,NameRbkEmpBustripsfromus);
  CreateLocalPermission(hInterfaceRbkEmpBustripsfromus,tbEmpBustripsfromus,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpBustripsfromus,tbDocum,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpBustripsfromus,tbAbsence,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpBustripsfromus,tbEmpBustripsfromus,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkEmpBustripsfromus,tbEmpBustripsfromus,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkEmpBustripsfromus,tbEmpBustripsfromus,ttpDelete,false,ttiaDelete);

  hInterfaceRbkEmpReferences:=CreateLocalInterface(NameRbkEmpReferences,NameRbkEmpReferences);
  CreateLocalPermission(hInterfaceRbkEmpReferences,tbEmpReferences,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpReferences,tbTypeReferences,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmpReferences,tbEmpReferences,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkEmpReferences,tbEmpReferences,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkEmpReferences,tbEmpReferences,ttpDelete,false,ttiaDelete);
  
  hInterfaceRbkProfession:=CreateLocalInterface(NameRbkProfession,NameRbkProfession);
  CreateLocalPermission(hInterfaceRbkProfession,tbProfession,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEmp,tbProfession,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkEmp,tbProfession,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkEmp,tbProfession,ttpDelete,false,ttiaDelete);

  hInterfaceRbkTypeStud:=CreateLocalInterface(NameRbkTypeStud,NameRbkTypeStud);
  CreateLocalPermission(hInterfaceRbkTypeStud,tbTypeStud,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkTypeStud,tbTypeStud,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkTypeStud,tbTypeStud,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkTypeStud,tbTypeStud,ttpDelete,false,ttiaDelete);

  hInterfaceRbkEduc:=CreateLocalInterface(NameRbkEduc,NameRbkEduc);
  CreateLocalPermission(hInterfaceRbkEduc,tbEduc,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkEduc,tbEduc,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkEduc,tbEduc,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkEduc,tbEduc,ttpDelete,false,ttiaDelete);

  hInterfaceRbkCraft:=CreateLocalInterface(NameRbkCraft,NameRbkCraft);
  CreateLocalPermission(hInterfaceRbkCraft,tbCraft,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkCraft,tbCraft,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkCraft,tbCraft,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkCraft,tbCraft,ttpDelete,false,ttiaDelete);

  hInterfaceRbkSciencename:=CreateLocalInterface(NameRbkSciencename,NameRbkSciencename);
  CreateLocalPermission(hInterfaceRbkSciencename,tbSciencename,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkSciencename,tbSciencename,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkSciencename,tbSciencename,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkSciencename,tbSciencename,ttpDelete,false,ttiaDelete);

  hInterfaceRbkLanguage:=CreateLocalInterface(NameRbkLanguage,NameRbkLanguage);
  CreateLocalPermission(hInterfaceRbkLanguage,tbLanguage,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkLanguage,tbLanguage,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkLanguage,tbLanguage,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkLanguage,tbLanguage,ttpDelete,false,ttiaDelete);

  hInterfaceRbkKnowLevel:=CreateLocalInterface(NameRbkKnowLevel,NameRbkKnowLevel);
  CreateLocalPermission(hInterfaceRbkKnowLevel,tbKnowLevel,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkKnowLevel,tbKnowLevel,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkKnowLevel,tbKnowLevel,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkKnowLevel,tbKnowLevel,ttpDelete,false,ttiaDelete);

  hInterfaceRbkMilRank:=CreateLocalInterface(NameRbkMilRank,NameRbkMilRank);
  CreateLocalPermission(hInterfaceRbkMilRank,tbMilRank,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkMilRank,tbMilRank,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkMilRank,tbMilRank,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkMilRank,tbMilRank,ttpDelete,false,ttiaDelete);

  hInterfaceRbkRank:=CreateLocalInterface(NameRbkRank,NameRbkRank);
  CreateLocalPermission(hInterfaceRbkRank,tbRank,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkRank,tbRank,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkRank,tbRank,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkRank,tbRank,ttpDelete,false,ttiaDelete);

  hInterfaceRbkGroupmil:=CreateLocalInterface(NameRbkGroupmil,NameRbkGroupmil);
  CreateLocalPermission(hInterfaceRbkGroupmil,tbGroupmil,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkGroupmil,tbGroupmil,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkGroupmil,tbGroupmil,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkGroupmil,tbGroupmil,ttpDelete,false,ttiaDelete);

  hInterfaceRbkConnectiontype:=CreateLocalInterface(NameRbkConnectiontype,NameRbkConnectiontype);
  CreateLocalPermission(hInterfaceRbkConnectiontype,tbConnectiontype,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkConnectiontype,tbConnectiontype,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkConnectiontype,tbConnectiontype,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkConnectiontype,tbConnectiontype,ttpDelete,false,ttiaDelete);

  hInterfaceRbkFamilystate:=CreateLocalInterface(NameRbkFamilystate,NameRbkFamilystate);
  CreateLocalPermission(hInterfaceRbkFamilystate,tbFamilystate,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkFamilystate,tbFamilystate,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkFamilystate,tbFamilystate,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkFamilystate,tbFamilystate,ttpDelete,false,ttiaDelete);

  hInterfaceRbkProperty:=CreateLocalInterface(NameRbkProperty,NameRbkProperty);
  CreateLocalPermission(hInterfaceRbkProperty,tbProperty,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkProperty,tbProperty,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkProperty,tbProperty,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkProperty,tbProperty,ttpDelete,false,ttiaDelete);

  hInterfaceRbkAddAccount:=CreateLocalInterface(NameRbkAddAccount,NameRbkAddAccount);
  CreateLocalPermission(hInterfaceRbkAddAccount,tbAddAccount,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkAddAccount,tbPlant,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkAddAccount,tbBank,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkAddAccount,tbAddAccount,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkAddAccount,tbAddAccount,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkAddAccount,tbAddAccount,ttpDelete,false,ttiaDelete);

  hInterfaceRbkPlant:=CreateLocalInterface(NameRbkPlant,NameRbkPlant);
  CreateLocalPermission(hInterfaceRbkPlant,tbPlant,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPlant,tbBank,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPlant,tbPlant,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkPlant,tbPlant,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkPlant,tbPlant,ttpDelete,false,ttiaDelete);

  hInterfaceRbkSchool:=CreateLocalInterface(NameRbkSchool,NameRbkSchool);
  CreateLocalPermission(hInterfaceRbkSchool,tbSchool,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkSchool,tbTown,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkSchool,tbSchool,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkSchool,tbSchool,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkSchool,tbSchool,ttpDelete,false,ttiaDelete);

  hInterfaceRbkReady:=CreateLocalInterface(NameRbkReady,NameRbkReady);
  CreateLocalPermission(hInterfaceRbkReady,tbReady,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkReady,tbReady,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkReady,tbReady,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkReady,tbReady,ttpDelete,false,ttiaDelete);

  hInterfaceRbkTypeRelation:=CreateLocalInterface(NameRbkTypeRelation,NameRbkTypeRelation);
  CreateLocalPermission(hInterfaceRbkTypeRelation,tbTypeRelation,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkTypeRelation,tbTypeRelation,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkTypeRelation,tbTypeRelation,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkTypeRelation,tbTypeRelation,ttpDelete,false,ttiaDelete);

  hInterfaceRbkTypeLive:=CreateLocalInterface(NameRbkTypeLive,NameRbkTypeLive);
  CreateLocalPermission(hInterfaceRbkTypeLive,tbTypeLive,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkTypeLive,tbTypeLive,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkTypeLive,tbTypeLive,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkTypeLive,tbTypeLive,ttpDelete,false,ttiaDelete);

  hInterfaceRbkSex:=CreateLocalInterface(NameRbkSex,NameRbkSex);
  CreateLocalPermission(hInterfaceRbkSex,tbSex,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkSex,tbSex,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkSex,tbSex,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkSex,tbSex,ttpDelete,false,ttiaDelete);

  hInterfaceRbkCurrency:=CreateLocalInterface(NameRbkCurrency,NameRbkCurrency);
  CreateLocalPermission(hInterfaceRbkCurrency,tbCurrency,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkCurrency,tbCurrency,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkCurrency,tbCurrency,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkCurrency,tbCurrency,ttpDelete,false,ttiaDelete);

  hInterfaceRbkRateCurrency:=CreateLocalInterface(NameRbkRateCurrency,NameRbkRateCurrency);
  CreateLocalPermission(hInterfaceRbkRateCurrency,tbRateCurrency,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkRateCurrency,tbCurrency,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkRateCurrency,tbRateCurrency,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkRateCurrency,tbRateCurrency,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkRateCurrency,tbRateCurrency,ttpDelete,false,ttiaDelete);

  hInterfaceRbkSick:=CreateLocalInterface(NameRbkSick,NameRbkSick);
  CreateLocalPermission(hInterfaceRbkSick,tbSick,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkSick,tbSick,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkSick,tbSick,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkSick,tbSick,ttpDelete,false,ttiaDelete);

  hInterfaceRbkTypeEncouragements:=CreateLocalInterface(NameRbkTypeEncouragements,NameRbkTypeEncouragements);
  CreateLocalPermission(hInterfaceRbkTypeEncouragements,tbTypeEncouragements,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkTypeEncouragements,tbTypeEncouragements,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkTypeEncouragements,tbTypeEncouragements,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkTypeEncouragements,tbTypeEncouragements,ttpDelete,false,ttiaDelete);

  hInterfaceRbkTypeResQual:=CreateLocalInterface(NameRbkTypeResQual,NameRbkTypeResQual);
  CreateLocalPermission(hInterfaceRbkTypeResQual,tbTypeResQual,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkTypeResQual,tbTypeResQual,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkTypeResQual,tbTypeResQual,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkTypeResQual,tbTypeResQual,ttpDelete,false,ttiaDelete);

  hInterfaceRbkBustripstous:=CreateLocalInterface(NameRbkBustripstous,NameRbkBustripstous);
  CreateLocalPermission(hInterfaceRbkBustripstous,tbBustripstous,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkBustripstous,tbPlant,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkBustripstous,tbSeat,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkBustripstous,tbBustripstous,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkBustripstous,tbBustripstous,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkBustripstous,tbBustripstous,ttpDelete,false,ttiaDelete);

  hInterfaceRbkTypeReferences:=CreateLocalInterface(NameRbkTypeReferences,NameRbkTypeReferences);
  CreateLocalPermission(hInterfaceRbkTypeReferences,tbTypeReferences,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkTypeReferences,tbTypeReferences,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkTypeReferences,tbTypeReferences,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkTypeReferences,tbTypeReferences,ttpDelete,false,ttiaDelete);

  hInterfaceRptEmpUniversal:=CreateLocalInterface(NameRptEmpUniversal,NameRptEmpUniversal,ttiReport);
  CreateLocalPermission(hInterfaceRptEmpUniversal,tbEmp,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptEmpUniversal,tbFamilystate,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptEmpUniversal,tbNation,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptEmpUniversal,tbTown,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptEmpUniversal,tbSex,ttpSelect,false);

end;

function CreateAndViewEmp(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBEmp=nil then
       fmRBEmp:=TfmRBEmp.Create(Application);
     fmRBEmp.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBEmp;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBEmp.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkEmp,Param);
  end;
end;

function CreateAndViewEmpConnect(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBEmpConnect=nil then
       fmRBEmpConnect:=TfmRBEmpConnect.Create(Application);
     fmRBEmpConnect.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBEmpConnect;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBEmpConnect.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkEmpConnect,Param);
  end;
end;

function CreateAndViewEmpSciencename(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;
begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: ;
    tvibvModal: ;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkEmpSciencename,Param);
  end;
end;

function CreateAndViewEmpLanguage(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;
begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: ;
    tvibvModal: ;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkEmpLanguage,Param);
  end;
end;

function CreateAndViewEmpChildren(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;
begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: ;
    tvibvModal: ;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkEmpChildren,Param);
  end;
end;

function CreateAndViewEmpProperty(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;
begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: ;
    tvibvModal: ;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkEmpProperty,Param);
  end;
end;

function CreateAndViewEmpStreet(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;
begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: ;
    tvibvModal: ;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkEmpStreet,Param);
  end;
end;

function CreateAndViewEmpPersonDoc(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;
begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: ;
    tvibvModal: ;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkEmpPersonDoc,Param);
  end;
end;

function CreateAndViewEmpMilitary(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;
begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: ;
    tvibvModal: ;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkEmpMilitary,Param);
  end;
end;

function CreateAndViewEmpDiplom(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;
begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: ;
    tvibvModal: ;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkEmpDiplom,Param);
  end;
end;

function CreateAndViewEmpBiography(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;
begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: ;
    tvibvModal: ;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkEmpBiography,Param);
  end;
end;

function CreateAndViewEmpPhoto(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;
begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: ;
    tvibvModal: ;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkEmpPhoto,Param);
  end;
end;

function CreateAndViewEmpPlant(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;
begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: ;
    tvibvModal: ;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkEmpPlant,Param);
  end;
end;

function CreateAndViewEmpFaceAccount(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;
begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: ;
    tvibvModal: ;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkEmpFaceAccount,Param);
  end;
end;

function CreateAndViewEmpSickList(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;
begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: ;
    tvibvModal: ;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkEmpSickList,Param);
  end;
end;

function CreateAndViewEmpLaborBook(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;
begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: ;
    tvibvModal: ;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkEmpLaborBook,Param);
  end;
end;

function CreateAndViewEmpRefreshCourse(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;
begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: ;
    tvibvModal: ;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkEmpRefreshCourse,Param);
  end;
end;

function CreateAndViewEmpLeave(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;
begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: ;
    tvibvModal: ;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkEmpLeave,Param);
  end;
end;

function CreateAndViewEmpQual(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;
begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: ;
    tvibvModal: ;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkEmpQual,Param);
  end;
end;

function CreateAndViewEmpEncouragements(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;
begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: ;
    tvibvModal: ;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkEmpEncouragements,Param);
  end;
end;

function CreateAndViewEmpBustripsfromus(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;
begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: ;
    tvibvModal: ;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkEmpBustripsfromus,Param);
  end;
end;

function CreateAndViewEmpReferences(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;
begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: ;
    tvibvModal: ;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkEmpReferences,Param);
  end;
end;

function CreateAndViewProfession(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBProfession=nil then
       fmRBProfession:=TfmRBProfession.Create(Application);
     fmRBProfession.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBProfession;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBProfession.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkProfession,Param);
  end;
end;

function CreateAndViewTypeStud(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBTypeStud=nil then
       fmRBTypeStud:=TfmRBTypeStud.Create(Application);
     fmRBTypeStud.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBTypeStud;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBTypeStud.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkTypeStud,Param);
  end;
end;

function CreateAndViewEduc(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBEduc=nil then
       fmRBEduc:=TfmRBEduc.Create(Application);
     fmRBEduc.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBEduc;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBEduc.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkEduc,Param);
  end;
end;

function CreateAndViewCraft(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBCraft=nil then
       fmRBCraft:=TfmRBCraft.Create(Application);
     fmRBCraft.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBCraft;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBCraft.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkCraft,Param);
  end;
end;

function CreateAndViewSciencename(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBSciencename=nil then
       fmRBSciencename:=TfmRBSciencename.Create(Application);
     fmRBSciencename.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBSciencename;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBSciencename.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkSciencename,Param);
  end;
end;

function CreateAndViewLanguage(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBLanguage=nil then
       fmRBLanguage:=TfmRBLanguage.Create(Application);
     fmRBLanguage.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBLanguage;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBLanguage.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkLanguage,Param);
  end;
end;

function CreateAndViewKnowLevel(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBKnowLevel=nil then
       fmRBKnowLevel:=TfmRBKnowLevel.Create(Application);
     fmRBKnowLevel.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBKnowLevel;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBKnowLevel.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkKnowLevel,Param);
  end;
end;

function CreateAndViewMilRank(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBMilRank=nil then
       fmRBMilRank:=TfmRBMilRank.Create(Application);
     fmRBMilRank.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBMilRank;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBMilRank.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkMilRank,Param);
  end;
end;

function CreateAndViewRank(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBRank=nil then
       fmRBRank:=TfmRBRank.Create(Application);
     fmRBRank.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBRank;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBRank.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkRank,Param);
  end;
end;

function CreateAndViewGroupmil(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBGroupmil=nil then
       fmRBGroupmil:=TfmRBGroupmil.Create(Application);
     fmRBGroupmil.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBGroupmil;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBGroupmil.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkGroupmil,Param);
  end;
end;

function CreateAndViewConnectiontype(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBConnectiontype=nil then
       fmRBConnectiontype:=TfmRBConnectiontype.Create(Application);
     fmRBConnectiontype.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBConnectiontype;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBConnectiontype.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkConnectiontype,Param);
  end;
end;

function CreateAndViewFamilystate(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBFamilystate=nil then
       fmRBFamilystate:=TfmRBFamilystate.Create(Application);
     fmRBFamilystate.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBFamilystate;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBFamilystate.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkFamilystate,Param);
  end;
end;

function CreateAndViewProperty(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBProperty=nil then
       fmRBProperty:=TfmRBProperty.Create(Application);
     fmRBProperty.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBProperty;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBProperty.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkProperty,Param);
  end;
end;


function CreateAndViewAddAccount(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBAddAccount=nil then
       fmRBAddAccount:=TfmRBAddAccount.Create(Application);
     fmRBAddAccount.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBAddAccount;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBAddAccount.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkAddAccount,Param);
  end;
end;

function CreateAndViewPlant(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBPlant=nil then
       fmRBPlant:=TfmRBPlant.Create(Application);
     fmRBPlant.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBPlant;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBPlant.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkPlant,Param);
  end;
end;

function CreateAndViewSchool(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBSchool=nil then
       fmRBSchool:=TfmRBSchool.Create(Application);
     fmRBSchool.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBSchool;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBSchool.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkSchool,Param);
  end;
end;

function CreateAndViewReady(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBReady=nil then
       fmRBReady:=TfmRBReady.Create(Application);
     fmRBReady.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBReady;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBReady.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkReady,Param);
  end;
end;

function CreateAndViewTypeRelation(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBTypeRelation=nil then
       fmRBTypeRelation:=TfmRBTypeRelation.Create(Application);
     fmRBTypeRelation.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBTypeRelation;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBTypeRelation.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkTypeRelation,Param);
  end;
end;

function CreateAndViewTypeLive(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBTypeLive=nil then
       fmRBTypeLive:=TfmRBTypeLive.Create(Application);
     fmRBTypeLive.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBTypeLive;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBTypeLive.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkTypeLive,Param);
  end;
end;

function CreateAndViewSex(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBSex=nil then
       fmRBSex:=TfmRBSex.Create(Application);
     fmRBSex.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBSex;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBSex.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkSex,Param);
  end;
end;

function CreateAndViewCurrency(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBCurrency=nil then
       fmRBCurrency:=TfmRBCurrency.Create(Application);
     fmRBCurrency.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBCurrency;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBCurrency.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkCurrency,Param);
  end;
end;

function CreateAndViewRateCurrency(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBRateCurrency=nil then
       fmRBRateCurrency:=TfmRBRateCurrency.Create(Application);
     fmRBRateCurrency.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBRateCurrency;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBRateCurrency.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkRateCurrency,Param);
  end;
end;

function CreateAndViewSick(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBSick=nil then
       fmRBSick:=TfmRBSick.Create(Application);
     fmRBSick.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBSick;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBSick.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkSick,Param);
  end;
end;

function CreateAndViewTypeEncouragements(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBTypeEncouragements=nil then
       fmRBTypeEncouragements:=TfmRBTypeEncouragements.Create(Application);
     fmRBTypeEncouragements.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBTypeEncouragements;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBTypeEncouragements.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkTypeEncouragements,Param);
  end;
end;

function CreateAndViewTypeResQual(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBTypeResQual=nil then
       fmRBTypeResQual:=TfmRBTypeResQual.Create(Application);
     fmRBTypeResQual.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBTypeResQual;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBTypeResQual.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkTypeResQual,Param);
  end;
end;

function CreateAndViewBustripstous(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBBustripstous=nil then
       fmRBBustripstous:=TfmRBBustripstous.Create(Application);
     fmRBBustripstous.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBBustripstous;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBBustripstous.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkBustripstous,Param);
  end;
end;

function CreateAndViewTypeReferences(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBTypeReferences=nil then
       fmRBTypeReferences:=TfmRBTypeReferences.Create(Application);
     fmRBTypeReferences.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBTypeReferences;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBTypeReferences.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkTypeReferences,Param);
  end;
end;

function CreateAndViewRptEmpUniversal(InterfaceHandle: THandle; Param: PParamReportInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRptEmpUniversal=nil then
       fmRptEmpUniversal:=TfmRptEmpUniversal.Create(Application);
     fmRptEmpUniversal.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=CreateAndViewAsMDIChild;
end;

function ViewInterface(InterfaceHandle: THandle; Param: Pointer): Boolean; stdcall;
begin
  Result:=false;

  // RBooks

  if InterfaceHandle=hInterfaceRbkEmp then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewEmp(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkEmpConnect then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewEmpConnect(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkEmpSciencename then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewEmpSciencename(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkEmpLanguage then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewEmpLanguage(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkEmpChildren then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewEmpChildren(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkEmpProperty then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewEmpProperty(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkEmpStreet then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewEmpStreet(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkEmpPersonDoc then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewEmpPersonDoc(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkEmpMilitary then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewEmpMilitary(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkEmpDiplom then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewEmpDiplom(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkEmpBiography then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewEmpBiography(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkEmpPhoto then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewEmpPhoto(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkEmpPlant then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewEmpPlant(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkEmpFaceAccount then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewEmpFaceAccount(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkEmpSickList then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewEmpSickList(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkEmpLaborBook then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewEmpLaborBook(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkEmpRefreshCourse then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewEmpRefreshCourse(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkEmpLeave then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewEmpLeave(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkEmpQual then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewEmpQual(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkEmpEncouragements then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewEmpEncouragements(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkEmpBustripsfromus then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewEmpBustripsfromus(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkEmpReferences then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewEmpReferences(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkProfession then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewProfession(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkTypeStud then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewTypeStud(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkEduc then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewEduc(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkCraft then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewCraft(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkSciencename then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewSciencename(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkLanguage then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewLanguage(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkKnowLevel then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewKnowLevel(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkMilRank then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewMilRank(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkRank then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewRank(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkGroupmil then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewGroupmil(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkConnectiontype then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewConnectiontype(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkFamilystate then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewFamilystate(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkProperty then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewProperty(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkAddAccount then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewAddAccount(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkPlant then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewPlant(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkSchool then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewSchool(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkReady then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewReady(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkTypeRelation then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewTypeRelation(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkTypeLive then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewTypeLive(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkSex then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewSex(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkCurrency then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewCurrency(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkRateCurrency then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewRateCurrency(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkSick then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewSick(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkTypeEncouragements then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewTypeEncouragements(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkTypeResQual then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewTypeResQual(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkBustripstous then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewBustripstous(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkTypeReferences then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewTypeReferences(InterfaceHandle,Param);
  end;

  // Reports

  if InterfaceHandle=hInterfaceRptEmpUniversal then begin
    if not isValidPointer(Param,SizeOf(TParamReportInterface)) then exit;
    Result:=CreateAndViewRptEmpUniversal(InterfaceHandle,Param);
  end;
end;

function isPermissionOnInterfaceView(InterfaceHandle: THandle): Boolean;
var
    isRemove: Boolean;
begin
    isRemove:=false;
    if InterfaceHandle=hInterfaceRbkEmp then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBEmp)
      else if fmRBEmp<>nil then begin
       fmRBEmp.SetInterfaceHandle(InterfaceHandle);
       fmRBEmp.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkEmpConnect then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBEmpConnect)
      else if fmRBEmpConnect<>nil then begin
       fmRBEmpConnect.CurInterface:=InterfaceHandle;
       fmRBEmpConnect.SetInterfaceHandle(hInterfaceRbkEmp);
       fmRBEmpConnect.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkEmpSciencename then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    end;
    if InterfaceHandle=hInterfaceRbkEmpLanguage then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    end;
    if InterfaceHandle=hInterfaceRbkEmpChildren then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    end;
    if InterfaceHandle=hInterfaceRbkEmpProperty then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    end;
    if InterfaceHandle=hInterfaceRbkEmpStreet then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    end;
    if InterfaceHandle=hInterfaceRbkEmpPersonDoc then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    end;
    if InterfaceHandle=hInterfaceRbkEmpMilitary then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    end;
    if InterfaceHandle=hInterfaceRbkEmpDiplom then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    end;
    if InterfaceHandle=hInterfaceRbkEmpBiography then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    end;
    if InterfaceHandle=hInterfaceRbkEmpPhoto then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    end;
    if InterfaceHandle=hInterfaceRbkEmpPlant then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    end;
    if InterfaceHandle=hInterfaceRbkEmpFaceAccount then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    end;
    if InterfaceHandle=hInterfaceRbkEmpSickList then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    end;
    if InterfaceHandle=hInterfaceRbkEmpLaborBook then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    end;
    if InterfaceHandle=hInterfaceRbkEmpRefreshCourse then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    end;
    if InterfaceHandle=hInterfaceRbkEmpLeave then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    end;
    if InterfaceHandle=hInterfaceRbkEmpQual then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    end;
    if InterfaceHandle=hInterfaceRbkEmpEncouragements then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    end;
    if InterfaceHandle=hInterfaceRbkEmpBustripsfromus then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    end;
    if InterfaceHandle=hInterfaceRbkEmpReferences then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    end;
    if InterfaceHandle=hInterfaceRbkProfession then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBProfession)
      else if fmRBProfession<>nil then begin
       fmRBProfession.SetInterfaceHandle(InterfaceHandle);
       fmRBProfession.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkTypeStud then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBTypeStud)
      else if fmRBTypeStud<>nil then begin
       fmRBTypeStud.SetInterfaceHandle(InterfaceHandle);
       fmRBTypeStud.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkEduc then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBEduc)
      else if fmRBEduc<>nil then begin
       fmRBEduc.SetInterfaceHandle(InterfaceHandle);
       fmRBEduc.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkCraft then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBCraft)
      else if fmRBCraft<>nil then begin
       fmRBCraft.SetInterfaceHandle(InterfaceHandle);
       fmRBCraft.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkSciencename then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBSciencename)
      else if fmRBSciencename<>nil then begin
       fmRBSciencename.SetInterfaceHandle(InterfaceHandle);
       fmRBSciencename.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkLanguage then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBLanguage)
      else if fmRBLanguage<>nil then begin
       fmRBLanguage.SetInterfaceHandle(InterfaceHandle);
       fmRBLanguage.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkKnowLevel then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBKnowLevel)
      else if fmRBKnowLevel<>nil then begin
       fmRBKnowLevel.SetInterfaceHandle(InterfaceHandle);
       fmRBKnowLevel.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkMilRank then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBMilRank)
      else if fmRBMilRank<>nil then begin
       fmRBMilRank.SetInterfaceHandle(InterfaceHandle);
       fmRBMilRank.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkRank then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBRank)
      else if fmRBRank<>nil then begin
       fmRBRank.SetInterfaceHandle(InterfaceHandle);
       fmRBRank.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkGroupmil then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBGroupmil)
      else if fmRBGroupmil<>nil then begin
       fmRBGroupmil.SetInterfaceHandle(InterfaceHandle);
       fmRBGroupmil.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkConnectiontype then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBConnectiontype)
      else if fmRBConnectiontype<>nil then begin
       fmRBConnectiontype.SetInterfaceHandle(InterfaceHandle);
       fmRBConnectiontype.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkFamilystate then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBFamilystate)
      else if fmRBFamilystate<>nil then begin
       fmRBFamilystate.SetInterfaceHandle(InterfaceHandle);
       fmRBFamilystate.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkProperty then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBProperty)
      else if fmRBProperty<>nil then begin
       fmRBProperty.SetInterfaceHandle(InterfaceHandle);
       fmRBProperty.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkAddAccount then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBAddAccount)
      else if fmRBAddAccount<>nil then begin
       fmRBAddAccount.SetInterfaceHandle(InterfaceHandle);
       fmRBAddAccount.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkPlant then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBPlant)
      else if fmRBPlant<>nil then begin
       fmRBPlant.SetInterfaceHandle(InterfaceHandle);
       fmRBPlant.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkSchool then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBSchool)
      else if fmRBSchool<>nil then begin
       fmRBSchool.SetInterfaceHandle(InterfaceHandle);
       fmRBSchool.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkReady then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBReady)
      else if fmRBReady<>nil then begin
       fmRBReady.SetInterfaceHandle(InterfaceHandle);
       fmRBReady.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkTypeRelation then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBTypeRelation)
      else if fmRBTypeRelation<>nil then begin
       fmRBTypeRelation.SetInterfaceHandle(InterfaceHandle);
       fmRBTypeRelation.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkTypeLive then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBTypeLive)
      else if fmRBTypeLive<>nil then begin
       fmRBTypeLive.SetInterfaceHandle(InterfaceHandle);
       fmRBTypeLive.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkSex then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBSex)
      else if fmRBSex<>nil then begin
       fmRBSex.SetInterfaceHandle(InterfaceHandle);
       fmRBSex.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkCurrency then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBCurrency)
      else if fmRBCurrency<>nil then begin
       fmRBCurrency.SetInterfaceHandle(InterfaceHandle);
       fmRBCurrency.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkRateCurrency then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBRateCurrency)
      else if fmRBRateCurrency<>nil then begin
       fmRBRateCurrency.SetInterfaceHandle(InterfaceHandle);
       fmRBRateCurrency.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkSick then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBSick)
      else if fmRBSick<>nil then begin
       fmRBSick.SetInterfaceHandle(InterfaceHandle);
       fmRBSick.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkTypeEncouragements then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBTypeEncouragements)
      else if fmRBTypeEncouragements<>nil then begin
       fmRBTypeEncouragements.SetInterfaceHandle(InterfaceHandle);
       fmRBTypeEncouragements.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkTypeResQual then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBTypeResQual)
      else if fmRBTypeResQual<>nil then begin
       fmRBTypeResQual.SetInterfaceHandle(InterfaceHandle);
       fmRBTypeResQual.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkBustripstous then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBBustripstous)
      else if fmRBBustripstous<>nil then begin
       fmRBBustripstous.SetInterfaceHandle(InterfaceHandle);
       fmRBBustripstous.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkTypeReferences then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBTypeReferences)
      else if fmRBTypeReferences<>nil then begin
       fmRBTypeReferences.SetInterfaceHandle(InterfaceHandle);
       fmRBTypeReferences.ActiveQuery(true);
      end;
    end;

    if InterfaceHandle=hInterfaceRptEmpUniversal then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRptEmpUniversal)
      else if fmRptEmpUniversal<>nil then begin
       fmRptEmpUniversal.SetInterfaceHandle(InterfaceHandle);
      end;
    end;
    result:=not isRemove;
end;


//********************* end of Internal *****************


//********************* Export *************************

procedure GetInfoLibrary_(P: PInfoLibrary);stdcall;
begin
  if P=nil then exit;
  P.Hint:=LibraryHint;
  P.TypeLib:=MainTypeLib;
end;

procedure SetAppAndScreen_(A: TApplication; S: TScreen);stdcall;
begin
  Application:=A;
  Screen:=S;
  fmOptions.ParentWindow:=A.Handle;
end;

procedure SetConnection_(IBDbase: TIBDatabase; IBTran: TIBTransaction;
                         IBDBSecurity: TIBDatabase; IBTSecurity: TIBTransaction);stdcall;
begin
  IBDB:=IBDbase;
  IBT:=IBTran;
  IBDBSec:=IBDBSecurity;
  IBTSec:=IBTSecurity;
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
