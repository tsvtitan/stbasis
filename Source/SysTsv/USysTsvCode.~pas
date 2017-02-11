unit USysTsvCode;

interface

{$I stbasis.inc}

uses Windows, Forms, USysTsvData, UMainUnited, Classes, USysTsvDm, graphics, dialogs,
     IBDatabase, IBQuery, Controls, tsvHint, db, SysUtils, IBServices, stdctrls,
     comctrls;

// Internal


procedure DeInitAll;
procedure ClearListEditInterfaceForms;
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

// Export
procedure InitAll_;stdcall;
procedure GetInfoLibrary_(P: PInfoLibrary);stdcall;
procedure RefreshLibrary_;stdcall;
procedure SetConnection_(IBDbase: TIBDatabase; IBTran: TIBTransaction;
                         IBDBSecurity: TIBDatabase; IBTSecurity: TIBTransaction);stdcall;


implementation

uses Menus,tsvDbGrid, USysTsvOptions, USysTsvForToolBars, IBSQLMonitor,
     URBUsers,URBApp, URBUserApp,UJRError,UJRSqlOperation,URBUsersEmp,
     URBAppPermColumn, dbtree, 
     USrvPermission, tsvSecurity;

//******************* Internal ************************

procedure InitAll_; stdcall;
begin
 try
  dm:=Tdm.Create(nil);
  fmOptions:=TfmOptions.Create(nil);
  fmForToolBars:=TfmForToolBars.Create(nil);
  testControl:=TComboBox.Create(nil);

  ListInterfaceHandles:=TList.Create;
  AddToListInterfaceHandles;

  ListMenuHandles:=Tlist.Create;
  AddToListMenuRootHandles;

  ListOptionHandles:=TList.Create;
  AddToListOptionRootHandles;

  ListToolBarHandles:=TList.Create;
  AddToListToolBarHandles;

  ListEditInterfaceForms:=TList.Create;

  fmOptions.LoadFromIni(OPTION_INVALID_HANDLE);

  isInitAll:=true;

 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure DeInitAll;
begin
 try
  if not isInitAll then exit;

  FreeAndNil(fmForToolBars);
  FreeAndNil(fmRBUsers);
  FreeAndNil(fmRBApp);
  FreeAndNil(fmRBUserApp);
  FreeAndNil(fmJRError);
  FreeAndNil(fmJRSqlOperation);
  FreeAndNil(fmRBUsersEmp);
  FreeAndNil(fmRBAppPermColumn);
  FreeAndNil(fmSrvPermission);

  FreeAndNil(fmOptions);

  ClearListEditInterfaceForms;
  ListEditInterfaceForms.Free;

  ClearListMenuHandles;
  ListMenuHandles.free;

  ClearListOptionHandles;
  ListOptionHandles.Free;

  ClearListToolBarHandles;
  ListToolBarHandles.Free;

  ClearListInterfaceHandles;
  ListInterfaceHandles.Free;

  dm.Free;

  testControl.Free;

 except
//  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure ClearListEditInterfaceForms;
var
  i: Integer;
  fm: TForm;
begin
  for i:=0 to ListEditInterfaceForms.Count-1 do begin
    fm:=ListEditInterfaceForms.Items[i];
    fm.Free;
  end;
  ListEditInterfaceForms.Clear;
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
  if ToolButtonHandle=hToolButtonUsers then MenuClickProc(hMenuUsers);
  if ToolButtonHandle=hToolButtonApp then MenuClickProc(hMenuApp);
  if ToolButtonHandle=hToolButtonUsersEmp then MenuClickProc(hMenuUsersEmp);
  if ToolButtonHandle=hToolButtonAppPermColumn then MenuClickProc(hMenuAppPermColumn);
  if ToolButtonHandle=hToolButtonJournalError then MenuClickProc(hMenuJournalError);
  if ToolButtonHandle=hToolButtonJournalSqlOperation then MenuClickProc(hMenuJournalSqlOperation);
  if ToolButtonHandle=hToolButtonSrvPermission then MenuClickProc(hMenuSrvPermission);
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
  tbar1: THandle;
begin
  if (hMenuServiceSystemRBooks<>MENU_INVALID_HANDLE)or
     (hMenuServiceJournals<>MENU_INVALID_HANDLE) then begin
   tbar1:=CreateToolBarLocal('Администрирование','Панель администрования',0);
   ListToolBarHandles.Add(Pointer(tbar1));
   if hMenuUsers<>MENU_INVALID_HANDLE then
    hToolButtonUsers:=CreateToolButtonLocal(tbar1,'Пользователи',NameRbkUsers,0,ToolButtonClickProc);
   if hMenuApp<>MENU_INVALID_HANDLE then
    hToolButtonApp:=CreateToolButtonLocal(tbar1,'Приложения',NameRbkApp,1,ToolButtonClickProc);
   if hMenuUsersEmp<>MENU_INVALID_HANDLE then
    hToolButtonUsersEmp:=CreateToolButtonLocal(tbar1,'Пользователи-Сотрудники',NameRbkUsersEmp,5,ToolButtonClickProc);
   if hMenuSrvPermission<>MENU_INVALID_HANDLE then
    hToolButtonSrvPermission:=CreateToolButtonLocal(tbar1,'Права',NameSrvPermission,7,ToolButtonClickProc);
   if hMenuAppPermColumn<>MENU_INVALID_HANDLE then begin
    hToolButtonAppPermColumn:=CreateToolButtonLocal(tbar1,'Права на колонки',NameRbkAppPermColumn,4,ToolButtonClickProc);
    CreateToolButtonLocal(tbar1,'','',-1,nil,tbseSeparator);
   end;
   if hMenuJournalError<>MENU_INVALID_HANDLE then
    hToolButtonJournalError:=CreateToolButtonLocal(tbar1,'Журнал ошибок',NameJrnError,2,ToolButtonClickProc);
   if hMenuJournalSqlOperation<>MENU_INVALID_HANDLE then begin
    hToolButtonJournalSqlOperation:=CreateToolButtonLocal(tbar1,'Журнал SQL операций',NameJrnSqlOperation,3,ToolButtonClickProc);
   end; 
   _RefreshToolBar(tBar1);
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
end;

procedure BeforeSetOptionProc(OptionHandle: THandle);stdcall;

  procedure BeforeSetOption;
  begin
  end;

begin
  fmOptions.Visible:=true;
  fmOptions.LoadFromIni(OptionHandle);
  BeforeSetOption;
end;

procedure AfterSetOptionProc(OptionHandle: THandle; isOk: Boolean);stdcall;

  procedure AfterSetOption;
  begin
  end;

begin
 try
  AfterSetOption;

  if isOK then fmOptions.SaveToIni(OptionHandle)
  else fmOptions.LoadFromIni(OptionHandle);

  fmOptions.Visible:=false;

 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
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
  TPJI: TParamJournalInterface;
  TPSI: TParamServiceInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  FillChar(TPJI,SizeOf(TPJI),0);
  FillChar(TPSI,SizeOf(TPSI),0);
  
  if MenuHandle=hMenuUsers then ViewInterface(hInterfaceRbkUsers,@TPRBI);
  if MenuHandle=hMenuApp then ViewInterface(hInterfaceRbkApp,@TPRBI);
  if MenuHandle=hMenuUserApp then ViewInterface(hInterfaceRbkUserApp,@TPRBI);
  if MenuHandle=hMenuUsersEmp then ViewInterface(hInterfaceRbkUsersEmp,@TPRBI);
  if MenuHandle=hMenuAppPermColumn then ViewInterface(hInterfaceRbkAppPermColumn,@TPRBI);

  if MenuHandle=hMenuJournalError then ViewInterface(hInterfaceJrnError,@TPJI);
  if MenuHandle=hMenuJournalSqlOperation then ViewInterface(hInterfaceJrnSqlOperation,@TPJI);

  if MenuHandle=hMenuSrvPermission then ViewInterface(hInterfaceSrvPermission,@TPSI);
  
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
  hMenuService: THandle;
  isFreeServiceSystemRBooks: Boolean;
  isFreeServiceJournals: Boolean;
  isFreeService: Boolean;
begin
  ListMenuHandles.Clear;
  hMenuService:=CreateMenuLocal(MENU_ROOT_HANDLE,ConstsMenuService,PChar(ChangeString(ConstsMenuService,'&','')));
  ListMenuHandles.Add(Pointer(hMenuService));
  hMenuServiceSystemRBooks:=CreateMenuLocal(hMenuService,'Системные справочники','Системные справочники',tcmAddFirst);
  hMenuUsers:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkUsers) then
   hMenuUsers:=CreateMenuLocal(hMenuServiceSystemRBooks,'Пользователи',NameRbkUsers,tcmAddLast,MENU_INVALID_HANDLE,0,ShortCut(Word('U'),[ssCtrl]),MenuClickProc);
  hMenuApp:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkApp) then
   hMenuApp:=CreateMenuLocal(hMenuServiceSystemRBooks,'Приложения',NameRbkApp,tcmAddLast,MENU_INVALID_HANDLE,1,0,MenuClickProc);
  hMenuUserApp:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkUserApp) then
   hMenuUserApp:=CreateMenuLocal(hMenuServiceSystemRBooks,'Приложения доступные пользователям',NameRbkUserApp,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);
  hMenuUsersEmp:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkUsersEmp) then
   hMenuUsersEmp:=CreateMenuLocal(hMenuServiceSystemRBooks,'Пользователи-Сотрудники',NameRbkUsersEmp,tcmAddLast,MENU_INVALID_HANDLE,5,0,MenuClickProc);
  hMenuSrvPermission:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceSrvPermission) then
   hMenuSrvPermission:=CreateMenuLocal(hMenuServiceSystemRBooks,'Права',NameSrvPermission,tcmAddLast,MENU_INVALID_HANDLE,7,0,MenuClickProc);
  hMenuAppPermColumn:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkAppPermColumn) then
   hMenuAppPermColumn:=CreateMenuLocal(hMenuServiceSystemRBooks,'Права на колонки',NameRbkAppPermColumn,tcmAddLast,MENU_INVALID_HANDLE,4,0,MenuClickProc);

  hMenuServiceJournals:=CreateMenuLocal(hMenuService,'Журналы','Журналы',tcmInsertAfter,hMenuServiceSystemRBooks);
  hMenuJournalError:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceJrnError) then
   hMenuJournalError:=CreateMenuLocal(hMenuServiceJournals,'Журнал ошибок',NameJrnError,tcmAddLast,MENU_INVALID_HANDLE,2,0,MenuClickProc);
  hMenuJournalSqlOperation:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceJrnSqlOperation) then
   hMenuJournalSqlOperation:=CreateMenuLocal(hMenuServiceJournals,'Журнал SQL операций',NameJrnSqlOperation,tcmAddLast,MENU_INVALID_HANDLE,3,0,MenuClickProc);

  isFreeServiceSystemRBooks:=(hMenuServiceSystemRBooks<>MENU_INVALID_HANDLE)and
                             (hMenuUsers=MENU_INVALID_HANDLE)and
                             (hMenuApp=MENU_INVALID_HANDLE)and
                             (hMenuUserApp=MENU_INVALID_HANDLE)and
                             (hMenuUsersEmp=MENU_INVALID_HANDLE)and
                             (hMenuSrvPermission=MENU_INVALID_HANDLE)and
                             (hMenuAppPermColumn=MENU_INVALID_HANDLE);
  if isFreeServiceSystemRBooks then
    if _FreeMenu(hMenuServiceSystemRBooks) then hMenuServiceSystemRBooks:=MENU_INVALID_HANDLE;

  isFreeServiceJournals:=(hMenuServiceJournals<>MENU_INVALID_HANDLE)and
                         (hMenuJournalError=MENU_INVALID_HANDLE)and
                         (hMenuJournalSqlOperation=MENU_INVALID_HANDLE);
  if isFreeServiceJournals then
    if _FreeMenu(hMenuServiceJournals) then hMenuServiceJournals:=MENU_INVALID_HANDLE;

  isFreeService:=(hMenuService<>MENU_INVALID_HANDLE)and
                 (hMenuServiceSystemRBooks=MENU_INVALID_HANDLE)and
                 (hMenuServiceJournals=MENU_INVALID_HANDLE);
  if isFreeService then
    if _FreeMenu(hMenuService) then ;//hMenuService:=MENU_INVALID_HANDLE;
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
  hInterfaceRbkUsers:=CreateLocalInterface(NameRbkUsers,NameRbkUsers);
  CreateLocalPermission(hInterfaceRbkUsers,tbUsers,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkUsers,tbUsers,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkUsers,tbUsers,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkUsers,tbUsers,ttpUpdate,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkUsers,tbUsers,ttpDelete,false,ttiaDelete);

  hInterfaceRbkApp:=CreateLocalInterface(NameRbkApp,NameRbkApp);
  CreateLocalPermission(hInterfaceRbkApp,tbApp,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkApp,tbApp,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkApp,tbApp,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkApp,tbApp,ttpDelete,false,ttiaDelete);

  hInterfaceRbkUserApp:=CreateLocalInterface(NameRbkUserApp,NameRbkUserApp);
  CreateLocalPermission(hInterfaceRbkUserApp,tbUsers,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkUserApp,tbUserApp,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkUserApp,tbApp,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkUserApp,tbUserApp,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkUserApp,tbUserApp,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkUserApp,tbUserApp,ttpDelete,false,ttiaDelete);

{  hInterfaceRbkUsersEmp:=CreateLocalInterface(NameRbkUsersEmp,NameRbkUsersEmp);
  CreateLocalPermission(hInterfaceRbkUsersEmp,tbUsersEmp,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkUsersEmp,tbEmp,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkUsersEmp,tbUsers,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkUsersEmp,tbUsersEmp,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkUsersEmp,tbUsersEmp,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkUsersEmp,tbUsersEmp,ttpDelete,false,ttiaDelete);}

  hInterfaceSrvPermission:=CreateLocalInterface(NameSrvPermission,NameSrvPermission);
  CreateLocalPermission(hInterfaceSrvPermission,tbApp,ttpSelect,false);

{  hInterfaceRbkAppPermColumn:=CreateLocalInterface(NameRbkAppPermColumn,NameRbkAppPermColumn);
  CreateLocalPermission(hInterfaceRbkAppPermColumn,tbAppPermColumn,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkAppPermColumn,tbApp,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkAppPermColumn,tbAppPermColumn,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkAppPermColumn,tbAppPermColumn,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkAppPermColumn,tbAppPermColumn,ttpDelete,false,ttiaDelete);}

  hInterfaceJrnError:=CreateLocalInterface(NameJrnError,NameJrnError,ttiJournal);
  CreateLocalPermission(hInterfaceJrnError,tbJournalError,ttpSelect,false);
  CreateLocalPermission(hInterfaceJrnError,tbUsers,ttpSelect,false);
  CreateLocalPermission(hInterfaceJrnError,tbJournalError,ttpDelete,false,ttiaDelete);

{  hInterfaceJrnSqlOperation:=CreateLocalInterface(NameJrnSqlOperation,NameJrnSqlOperation,ttiJournal);
  CreateLocalPermission(hInterfaceJrnSqlOperation,tbJournalSqlOperation,ttpSelect,false);
  CreateLocalPermission(hInterfaceJrnSqlOperation,tbUsers,ttpSelect,false);
  CreateLocalPermission(hInterfaceJrnSqlOperation,tbJournalSqlOperation,ttpDelete,false,ttiaDelete);}

end;

function CreateAndViewUsers(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBUsers=nil then
       fmRBUsers:=TfmRBUsers.Create(Application);
     fmRBUsers.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBUsers;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBUsers.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDBSec,SQLRbkUsers,Param);
  end;
end;

function CreateAndViewApp(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBApp=nil then
       fmRBApp:=TfmRBApp.Create(Application);
     fmRBApp.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBApp;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBApp.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDBSec,SQLRbkApp,Param);
  end;
end;

function CreateAndViewUserApp(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBUserApp=nil then
       fmRBUserApp:=TfmRBUserApp.Create(Application);
     fmRBUserApp.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBUserApp;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBUserApp.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDBSec,SQLRbkUserApp,Param);
  end;
end;

function CreateAndViewUsersEmp(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBUsersEmp=nil then
       fmRBUsersEmp:=TfmRBUsersEmp.Create(Application);
     fmRBUsersEmp.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBUsersEmp;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBUsersEmp.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkUsersEmp,Param);
  end;
end;

function CreateAndViewAppPermColumn(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBAppPermColumn=nil then
       fmRBAppPermColumn:=TfmRBAppPermColumn.Create(Application);
     fmRBAppPermColumn.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBAppPermColumn;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBAppPermColumn.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDBSec,SQLRbkAppPermColumn,Param);
  end;
end;

function CreateAndViewJournalError(InterfaceHandle: THandle; Param: PParamJournalInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmJRError=nil then
       fmJRError:=TfmJRError.Create(Application);
     fmJRError.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmJRError;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmJRError.Create(nil);
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
    tviOnlyData: Result:=QueryForParamJournalInterface(IBDBSec,SQLJrnError,Param);
  end;
end;

function CreateAndViewJournalSqlOperation(InterfaceHandle: THandle; Param: PParamJournalInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmJRSqlOperation=nil then
       fmJRSqlOperation:=TfmJRSqlOperation.Create(Application);
     fmJRSqlOperation.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmJRSqlOperation;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmJRSqlOperation.Create(nil);
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
    tviOnlyData: Result:=QueryForParamJournalInterface(IBDBSec,SQLJrnSqlOperation,Param);
  end;
end;

function CreateAndViewSrvPermission(InterfaceHandle: THandle; Param: PParamServiceInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmSrvPermission=nil then
       fmSrvPermission:=TfmSrvPermission.Create(Application);
     fmSrvPermission.InitMdiChildParams(InterfaceHandle,Param);
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
  if InterfaceHandle=hInterfaceRbkUsers then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewUsers(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkApp then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewApp(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkUserApp then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewUserApp(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkUsersEmp then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewUsersEmp(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkAppPermColumn then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewAppPermColumn(InterfaceHandle,Param);
  end;

  if InterfaceHandle=hInterfaceJrnError then begin
    if not isValidPointer(Param,SizeOf(TParamJournalInterface)) then exit;
    Result:=CreateAndViewJournalError(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceJrnSqlOperation then begin
    if not isValidPointer(Param,SizeOf(TParamJournalInterface)) then exit;
    Result:=CreateAndViewJournalSqlOperation(InterfaceHandle,Param);
  end;

  if InterfaceHandle=hInterfaceSrvPermission then begin
    if not isValidPointer(Param,SizeOf(TParamServiceInterface)) then exit;
    Result:=CreateAndViewSrvPermission(InterfaceHandle,Param);
  end;
end;

function isPermissionOnInterfaceView(InterfaceHandle: THandle): Boolean;
var
    isRemove: Boolean;
begin
    isRemove:=false;
    if InterfaceHandle=hInterfaceRbkUsers then begin
      isRemove:=not _isPermissionOnInterface(hInterfaceRbkUsers,ttiaView);
      if isRemove then FreeAndNil(fmRBUsers)
      else if fmRBUsers<>nil then begin
       fmRBUsers.SetInterfaceHandle(InterfaceHandle);
       fmRBUsers.ActiveQuery(true);
      end; 
    end;
    if InterfaceHandle=hInterfaceRbkApp then begin
      isRemove:=not _isPermissionOnInterface(hInterfaceRbkApp,ttiaView);
      if isRemove then FreeAndNil(fmRBApp)
      else if fmRBApp<>nil then begin
       fmRBApp.SetInterfaceHandle(InterfaceHandle);
       fmRBApp.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkUserApp then begin
      isRemove:=not _isPermissionOnInterface(hInterfaceRbkUserApp,ttiaView);
      if isRemove then FreeAndNil(fmRBUserApp)
      else if fmRBUserApp<>nil then begin
       fmRBUserApp.SetInterfaceHandle(InterfaceHandle);
       fmRBUserApp.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceJrnError then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmJRError)
      else if fmJRError<>nil then begin
       fmJRError.SetInterfaceHandle(InterfaceHandle);
       fmJRError.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceJrnSqlOperation then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmJRSqlOperation)
      else if fmJRSqlOperation<>nil then begin
       fmJRSqlOperation.SetInterfaceHandle(InterfaceHandle);
       fmJRSqlOperation.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkUsersEmp then begin
      isRemove:=not _isPermissionOnInterface(hInterfaceRbkUsersEmp,ttiaView);
      if isRemove then FreeAndNil(fmRBUsersEmp)
      else if fmRBUsersEmp<>nil then begin
       fmRBUsersEmp.SetInterfaceHandle(InterfaceHandle);
       fmRBUsersEmp.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkAppPermColumn then begin
      isRemove:=not _isPermissionOnInterface(hInterfaceRbkAppPermColumn,ttiaView);
      if isRemove then FreeAndNil(fmRBAppPermColumn)
      else if fmRBAppPermColumn<>nil then begin
       fmRBAppPermColumn.SetInterfaceHandle(InterfaceHandle);
       fmRBAppPermColumn.ActiveQuery(true);
      end;
    end;

    if InterfaceHandle=hInterfaceSrvPermission then begin
      isRemove:=not _isPermissionOnInterface(hInterfaceSrvPermission,ttiaView);
      if isRemove then FreeAndNil(fmSrvPermission)
      else if fmSrvPermission<>nil then begin
       fmSrvPermission.SetInterfaceHandle(InterfaceHandle);
       fmSrvPermission.ActiveQuery(true);
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
  P.Programmers:=LibraryProgrammers;

  FSecurity.LoadDb;
  P.StopLoad:=not FSecurity.Check([sctInclination,sctRunCount]);
  P.Condition:=PChar(FSecurity.Condition);
  FSecurity.DecRunCount;
  FSecurity.SaveDb;
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
    ClearListEditInterfaceForms;
    
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
