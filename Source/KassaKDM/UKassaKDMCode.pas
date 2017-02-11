unit UKassaKDMCode;

interface

{$I stbasis.inc}

uses Windows, Forms, UKassaKDMData, UMainUnited, Classes, UKassaKDMDM, graphics, dialogs,
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
procedure _GetInterfaces(Owner: Pointer; Proc: TGetInterfaceProc); stdcall;
                                       external MainExe name ConstGetInterfaces; 


implementation


uses ActiveX, Menus, URBCashBasis, URBCashAppend, URBPlanAccounts,
     URBKindSubkonto, URBCashOrders, URBSubkontoSubkonto,URBMagazinePostings,dbtree,tsvDbGrid,
     URptCashOrders;

//******************* Internal ************************
procedure InitAll_; stdcall;
begin
 try
  CoInitialize(nil);
  dm:=Tdm.Create(nil);

  ListInterfaceHandles:=TList.Create;
  AddToListInterfaceHandles;

  ListMenuHandles:=Tlist.Create;
  AddToListMenuRootHandles;

  isInitAll:=true;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure DeInitAll;
begin
 try
  if not isInitAll then exit;

  FreeAndNil(fmRBCashBasis);
  FreeAndNil(fmRBCashAppend);
  FreeAndNil(fmRBKindSubkonto);
  FreeAndNil(fmRBPlanAccounts);
  FreeAndNil(fmRBCashOrders);
  FreeAndNil(fmRBMagazinePostings);
  FreeAndNil(fmRBSubkontoSubkonto);
  FreeAndNil(fmRptCashOrders);


  ClearListMenuHandles;
  ListMenuHandles.free;

  ClearListInterfaceHandles;
  ListInterfaceHandles.Free;

  dm.Free;

  CoUnInitialize;
 except
//  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
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
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  FillChar(TPRI,SizeOf(TPRI),0);

  if MenuHandle=hMenuRBooksCashBasis then ViewInterface(hInterfaceRbkCashBasis,@TPRBI);
  if MenuHandle=hMenuRBooksCashAppend then ViewInterface(hInterfaceRbkCashAppend,@TPRBI);
  if MenuHandle=hMenuRBooksKindSubkonto then ViewInterface(hInterfaceRbkKindSubkonto,@TPRBI);
  if MenuHandle=hMenuRBooksPlanAccounts then ViewInterface(hInterfaceRbkPlanAccounts,@TPRBI);
  if MenuHandle=hMenuRBooksCashOrders then ViewInterface(hInterfaceRbkCashOrders,@TPRBI);
  if MenuHandle=hMenuRBooksMagazinePostings then ViewInterface(hInterfaceRbkMagazinePostings,@TPRBI);
  if MenuHandle=hMenuRBooksSubkontoSubkonto then ViewInterface(hInterfaceRbkSubkontoSubkonto,@TPRBI);
//                hMenuRBooksMagazinePostings
  if MenuHandle=hMenuRptsCashOrders then ViewInterface(hInterfaceRptCashOrders,@TPRI);

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
  isFreeMenuRBooksKassa: Boolean;
  isFreeMenuRptsCashOrders: Boolean;
  isFreeMenuRBooks: Boolean;
  isFreeMenuRpts: Boolean;
  isFreeMenuRptsKassa: Boolean;

begin
  ListMenuHandles.Clear;

  hMenuRBooks:=CreateMenuLocal(MENU_ROOT_HANDLE,ConstsMenuRBooks,PChar(ChangeString(ConstsMenuRBooks,'&','')),
                               tcmInsertBefore,_GetMenuHandleFromName(MENU_ROOT_HANDLE,ConstsMenuService));
  ListMenuHandles.Add(Pointer(hMenuRBooks));
  hMenuRBooksKassa:=CreateMenuLocal(hMenuRBooks,ConstsMenuKassa,ConstsMenuKassa,tcmAddFirst);
  hMenuRBooksCashBasis:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkCashBasis) then
   hMenuRBooksCashBasis:=CreateMenuLocal(hMenuRBooksKassa,'Основания',NameRbkCashBasis,tcmAddLast,MENU_INVALID_HANDLE,0,0,MenuClickProc);
  hMenuRBooksCashAppend:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkCashAppend) then
   hMenuRBooksCashAppend:=CreateMenuLocal(hMenuRBooksKassa,'Приложения',NameRbkCashAppend,tcmAddLast,MENU_INVALID_HANDLE,0,0,MenuClickProc);
  hMenuRBooksKindSubkonto:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkKindSubkonto) then
   hMenuRBooksKindSubkonto:=CreateMenuLocal(hMenuRBooksKassa,'Виды субконто',NameRbkKindSubkonto,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);
  hMenuRBooksPlanAccounts:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkPlanAccounts) then
   hMenuRBooksPlanAccounts:=CreateMenuLocal(hMenuRBooksKassa,'План счетов',NameRbkPlanAccounts,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);
  hMenuRBooksCashOrders:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkCashOrders) then
   hMenuRBooksCashOrders:=CreateMenuLocal(hMenuRBooksKassa,'Кассовые ордера',NameRbkCashOrders,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);
  hMenuRBooksMagazinePostings:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkMagazinePostings) then
   hMenuRBooksMagazinePostings:=CreateMenuLocal(hMenuRBooksKassa,'Журнал проводок',NameRbkMagazinePostings,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);
  hMenuRBooksSubkontoSubkonto:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkSubkontoSubkonto) then
   hMenuRBooksSubkontoSubkonto:=CreateMenuLocal(hMenuRBooksKassa,'Связи субконто',NameRbkSubkontoSubkonto,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuRpts:=CreateMenuLocal(MENU_ROOT_HANDLE,ConstsMenuReports,PChar(ChangeString(ConstsMenuReports,'&','')),
                               tcmInsertBefore,_GetMenuHandleFromName(MENU_ROOT_HANDLE,ConstsMenuService));
  ListMenuHandles.Add(Pointer(hMenuRpts));
  hMenuRptsKassa:=CreateMenuLocal(hMenuRpts,ConstsMenuRptKassa,ConstsMenuRptKassa,tcmAddFirst);
  hMenuRptsCashOrders:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRptCashOrders) then
   hMenuRptsCashOrders:=CreateMenuLocal(hMenuRptsKassa,'Кассовые ордера',NameRptCashOrders,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  isFreeMenuRBooksKassa:=(hMenuRBooksKassa<>MENU_INVALID_HANDLE)and
                            (hMenuRBooksCashBasis=MENU_INVALID_HANDLE)and
                            (hMenuRBooksCashAppend=MENU_INVALID_HANDLE)and
                            (hMenuRBooksKindSubkonto=MENU_INVALID_HANDLE)and
                            (hMenuRBooksPlanAccounts=MENU_INVALID_HANDLE)and
                            (hMenuRBooksCashOrders=MENU_INVALID_HANDLE)and
                            (hMenuRBooksMagazinePostings=MENU_INVALID_HANDLE)and
                            (hMenuRBooksSubkontoSubkonto=MENU_INVALID_HANDLE);
  if isFreeMenuRBooksKassa then
    if _FreeMenu(hMenuRBooksKassa) then hMenuRBooksKassa:=MENU_INVALID_HANDLE;

  isFreeMenuRptsKassa:=(hMenuRptsKassa<>MENU_INVALID_HANDLE)and
                            (hMenuRptsCashOrders=MENU_INVALID_HANDLE);
  if isFreeMenuRptsKassa then
    if _FreeMenu(hMenuRptsKassa) then hMenuRptsKassa:=MENU_INVALID_HANDLE;


  isFreeMenuRBooks:=(hMenuRBooks<>MENU_INVALID_HANDLE)and
                    (hMenuRBooksKassa=MENU_INVALID_HANDLE);
  if isFreeMenuRBooks then
    if _FreeMenu(hMenuRBooks) then hMenuRBooks:=MENU_INVALID_HANDLE;

  isFreeMenuRpts:=(hMenuRpts<>MENU_INVALID_HANDLE)and
                 (hMenuRptsKassa=MENU_INVALID_HANDLE);
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

  hInterfaceRbkCashBasis:=CreateLocalInterface(NameRbkCashBasis,NameRbkCashBasis);
  CreateLocalPermission(hInterfaceRbkCashBasis,tbCashBasis,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkCashBasis,tbCashBasis,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkCashBasis,tbCashBasis,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkCashBasis,tbCashBasis,ttpDelete,false,ttiaDelete);

  hInterfaceRbkCashAppend:=CreateLocalInterface(NameRbkCashAppend,NameRbkCashAppend);
  CreateLocalPermission(hInterfaceRbkCashAppend,tbCashAppend,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkCashAppend,tbCashAppend,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkCashAppend,tbCashAppend,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkCashAppend,tbCashAppend,ttpDelete,false,ttiaDelete);

  hInterfaceRbkKindSubkonto:=CreateLocalInterface(NameRbkKindSubkonto,NameRbkKindSubkonto);
  CreateLocalPermission(hInterfaceRbkKindSubkonto,tbKindSubkonto,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkKindSubkonto,tbKindSubkonto,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkKindSubkonto,tbKindSubkonto,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkKindSubkonto,tbKindSubkonto,ttpDelete,false,ttiaDelete);

  hInterfaceRbkPlanAccounts:=CreateLocalInterface(NameRbkPlanAccounts,NameRbkPlanAccounts);
  CreateLocalPermission(hInterfaceRbkPlanAccounts,tbPlanAccounts,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPlanAccounts,tbPlanAccounts_KindSubkonto,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPlanAccounts,tbPlanAccounts_KindSubkonto,ttpUpdate,false);
  CreateLocalPermission(hInterfaceRbkPlanAccounts,tbPlanAccounts_KindSubkonto,ttpInsert,false);
  CreateLocalPermission(hInterfaceRbkPlanAccounts,tbPlanAccounts_KindSubkonto,ttpDelete,false);
  CreateLocalPermission(hInterfaceRbkPlanAccounts,tbKindSubkonto,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPlanAccounts,tbKindSaldo,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPlanAccounts,tbPlanAccounts,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkPlanAccounts,tbPlanAccounts,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkPlanAccounts,tbPlanAccounts,ttpDelete,false,ttiaDelete);

  hInterfaceRbkCashOrders:=CreateLocalInterface(NameRbkCashOrders,NameRbkCashOrders);
  CreateLocalPermission(hInterfaceRbkCashOrders,tbCashOrders,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkCashOrders,tbDocuments,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkCashOrders,tbPlanAccounts,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkCashOrders,tbCashBasis,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkCashOrders,tbCashAppend,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkCashOrders,tbEmp,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkCashOrders,tbCashOrders,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkCashOrders,tbMagazinePostings,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkCashOrders,tbCashOrders,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkCashOrders,tbMagazinePostings,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkCashOrders,tbCashOrders,ttpDelete,false,ttiaDelete);
  CreateLocalPermission(hInterfaceRbkCashOrders,tbMagazinePostings,ttpDelete,false,ttiaDelete);

  hInterfaceRbkMagazinePostings:=CreateLocalInterface(NameRbkMagazinePostings,NameRbkMagazinePostings);
  CreateLocalPermission(hInterfaceRbkMagazinePostings,tbMagazinePostings,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkMagazinePostings,tbKindSubkonto,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkMagazinePostings,tbPlanAccounts,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkMagazinePostings,tbDocuments,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkMagazinePostings,tbCurrency,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkMagazinePostings,tbMagazinePostings,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkMagazinePostings,tbMagazinePostings,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkMagazinePostings,tbMagazinePostings,ttpDelete,false,ttiaDelete);

  hInterfaceRbkSubkontoSubkonto:=CreateLocalInterface(NameRbkSubkontoSubkonto,NameRbkSubkontoSubkonto);
  CreateLocalPermission(hInterfaceRbkSubkontoSubkonto,tbKindSubkonto,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkSubkontoSubkonto,tbSubkontoSubkonto,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkSubkontoSubkonto,tbSubkontoSubkonto,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkSubkontoSubkonto,tbSubkontoSubkonto,ttpDelete,false,ttiaDelete);

  hInterfaceRptCashOrders:=CreateLocalInterface(NameRptCashOrders,NameRptCashOrders,ttiReport);
  CreateLocalPermission(hInterfaceRptCashOrders,tbCashOrders,ttpSelect,false);

end;

function CreateAndViewCashBasis(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
     result:=false;
     try
      if fmRBCashBasis=nil then
        fmRBCashBasis:=TfmRBCashBasis.Create(Application);
      fmRBCashBasis.InitMdiChildParams(InterfaceHandle,Param);
      Result:=true;
     except
      {$IFDEF DEBUG} on E: Exception do Assert(false,E.message);{$ENDIF}
     end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
     fm: TfmRBCashBasis;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBCashBasis.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
         fm.ReturnModalParams(Param);
         Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message);{$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkCashBasis,Param);
  end;
end;

function CreateAndViewCashAppend(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
     result:=false;
     try
      if fmRBCashAppend=nil then
        fmRBCashAppend:=TfmRBCashAppend.Create(Application);
      fmRBCashAppend.InitMdiChildParams(InterfaceHandle,Param);
      Result:=true;
     except
      {$IFDEF DEBUG} on E: Exception do Assert(false,E.message);{$ENDIF}
     end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
     fm: TfmRBCashAppend;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBCashAppend.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
         fm.ReturnModalParams(Param);
         Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message);{$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkCashAppend,Param);
  end;
end;

function CreateAndViewKindSubkonto(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
     result:=false;
     try
      if fmRBKindSubkonto=nil then
        fmRBKindSubkonto:=TfmRBKindSubkonto.Create(Application);
      fmRBKindSubkonto.InitMdiChildParams(InterfaceHandle,Param);
      Result:=true;
     except
      {$IFDEF DEBUG} on E: Exception do Assert(false,E.message);{$ENDIF}
     end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
     fm: TfmRBKindSubkonto;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBKindSubkonto.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
         fm.ReturnModalParams(Param);
         Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message);{$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkKindSubkonto,Param);
  end;
end;

function CreateAndViewPlanAccounts(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
     result:=false;
     try
      if fmRBPlanAccounts=nil then
        fmRBPlanAccounts:=TfmRBPlanAccounts.Create(Application);
      fmRBPlanAccounts.InitMdiChildParams(InterfaceHandle,Param);
      Result:=true;
     except
      {$IFDEF DEBUG} on E: Exception do Assert(false,E.message);{$ENDIF}
     end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
     fm: TfmRBPlanAccounts;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBPlanAccounts.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
         fm.ReturnModalParams(Param);
         Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message);{$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkPlanAccounts,Param);
  end;
end;


function CreateAndViewCashOrders(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
     result:=false;
     try
      if fmRBCashOrders=nil then
        fmRBCashOrders:=TfmRBCashOrders.Create(Application);
      fmRBCashOrders.InitMdiChildParams(InterfaceHandle,Param);
      Result:=true;
     except
      {$IFDEF DEBUG} on E: Exception do Assert(false,E.message);{$ENDIF}
     end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
     fm: TfmRBCashOrders;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBCashOrders.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
         fm.ReturnModalParams(Param);
         Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message);{$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkCashOrders,Param);
  end;
end;

function CreateAndViewMagazinePostings (InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
     result:=false;
     try
      if fmRBMagazinePostings=nil then
        fmRBMagazinePostings:=TfmRBMagazinePostings.Create(Application);
      fmRBMagazinePostings.InitMdiChildParams(InterfaceHandle,Param);
      Result:=true;
     except
      {$IFDEF DEBUG} on E: Exception do Assert(false,E.message);{$ENDIF}
     end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
     fm: TfmRBMagazinePostings;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBMagazinePostings.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
         fm.ReturnModalParams(Param);
         Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message);{$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkMagazinePostings,Param);
  end;
end;

function CreateAndViewSubkontoSubkonto (InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
     result:=false;
     try
      if fmRBSubkontoSubkonto=nil then
        fmRBSubkontoSubkonto:=TfmRBSubkontoSubkonto.Create(Application);
      fmRBSubkontoSubkonto.InitMdiChildParams(InterfaceHandle,Param);
      Result:=true;
     except
      {$IFDEF DEBUG} on E: Exception do Assert(false,E.message);{$ENDIF}
     end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
     fm: TfmRBSubkontoSubkonto;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBSubkontoSubkonto.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
         fm.ReturnModalParams(Param);
         Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message);{$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkSubkontoSubkonto,Param);
  end;
end;

function CreateAndViewRptCashOrders(InterfaceHandle: THandle; Param: PParamReportInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRptCashOrders=nil then
       fmRptCashOrders:=TfmRptCashOrders.Create(Application);
     fmRptCashOrders.InitMdiChildParams(InterfaceHandle,Param);
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

  if InterfaceHandle=hInterfaceRbkCashBasis then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewCashBasis(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkCashAppend then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewCashAppend(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkKindSubkonto then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewKindSubkonto(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkPlanAccounts then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewPlanAccounts(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkCashOrders then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewCashOrders(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkMagazinePostings then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewMagazinePostings(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkSubkontoSubkonto then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewSubkontoSubkonto(InterfaceHandle,Param);
  end;
  // Reports

  if InterfaceHandle=hInterfaceRptCashOrders then begin
    if not isValidPointer(Param,SizeOf(TParamReportInterface)) then exit;
    Result:=CreateAndViewRptCashOrders(InterfaceHandle,Param);
  end;
end;

function isPermissionOnInterfaceView(InterfaceHandle: THandle): Boolean;
var
    isRemove: Boolean;
begin
    isRemove:=false;
    if InterfaceHandle=hInterfaceRbkCashBasis then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBCashBasis)
      else if fmRBCashBasis<>nil then begin
       fmRBCashBasis.SetInterfaceHandle(InterfaceHandle);
       fmRBCashBasis.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkCashAppend then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBCashAppend)
      else if fmRBCashAppend<>nil then begin
       fmRBCashAppend.SetInterfaceHandle(InterfaceHandle);
       fmRBCashAppend.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkKindSubkonto then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBKindSubkonto)
      else if fmRBKindSubkonto<>nil then begin
       fmRBKindSubkonto.SetInterfaceHandle(InterfaceHandle);
       fmRBKindSubkonto.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkPlanAccounts then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBPlanAccounts)
      else if fmRBPlanAccounts<>nil then begin
       fmRBPlanAccounts.SetInterfaceHandle(InterfaceHandle);
       fmRBPlanAccounts.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkCashOrders then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBCashOrders)
      else if fmRBCashOrders<>nil then begin
       fmRBCashOrders.SetInterfaceHandle(InterfaceHandle);
       fmRBCashOrders.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkMagazinePostings then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBMagazinePostings)
      else if fmRBMagazinePostings<>nil then begin
       fmRBMagazinePostings.SetInterfaceHandle(InterfaceHandle);
       fmRBMagazinePostings.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkSubkontoSubkonto then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBSubkontoSubkonto)
      else if fmRBSubkontoSubkonto<>nil then begin
       fmRBSubkontoSubkonto.SetInterfaceHandle(InterfaceHandle);
       fmRBSubkontoSubkonto.ActiveQuery(true);
      end;
    end;

    if InterfaceHandle=hInterfaceRptCashOrders then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRptCashOrders)
      else if fmRptCashOrders<>nil then begin
       fmRptCashOrders.SetInterfaceHandle(InterfaceHandle);
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

  finally
    Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

//**************** end of Export *************************

end.
