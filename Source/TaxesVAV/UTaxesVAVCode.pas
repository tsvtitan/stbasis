unit UTaxesVAVCode;

interface

{$I stbasis.inc}

uses Windows, Forms, UTaxesVAVData, UMainUnited, Classes, UTaxesVAVDm, graphics, dialogs,
     IBDatabase, IBQuery, Controls, TSVHint, db, SysUtils, IBServices, stdctrls,
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
procedure ClearListToolBarHandles;
procedure ToolButtonClickProc(ToolButtonHandle: THandle);stdcall;
procedure AddToListToolBarHandles;
procedure ClearListOptionHandles;
procedure AddToListOptionRootHandles;
procedure BeforeSetOptionProc(OptionHandle: THandle);stdcall;
procedure AfterSetOptionProc(OptionHandle: THandle; isOK: Boolean);stdcall;


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

uses ActiveX,Menus,TSVDbGrid,dbtree,URBLinkSummPercent,URBTreeTaxes,
     URBTaxesType,UTaxesVAVOptions;

//******************* Internal ************************

procedure InitAll_;stdcall;
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

  FreeAndNil(fmRBTaxesType);
  FreeAndNil(fmRBLinkSummPercent);
  FreeAndNil(fmRBTreeTaxes);  

  FreeAndNil(fmOptions);

  ClearListMenuHandles;
  ListMenuHandles.free;

  ClearListOptionHandles;
  ListOptionHandles.Free;

  ClearListToolBarHandles;
  ListToolBarHandles.Free;

  ClearListInterfaceHandles;
  ListInterfaceHandles.Free;

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
  if ToolButtonHandle=hToolButtonRbkLinkSummPercent then MenuClickProc(hMenuRbkLinkSummPercent);
  if ToolButtonHandle=hToolButtonRbkTaxesType then MenuClickProc(hMenuRbkTaxesType);
  if ToolButtonHandle=hToolButtonRbkTreeTaxes then MenuClickProc(hMenuRbkTreeTaxes);
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
  if (hMenuRbkLinkSummPercent<>MENU_INVALID_HANDLE) or
     (hMenuRbkTreeTaxes<>MENU_INVALID_HANDLE) or
     (hMenuRbkTaxesType<>MENU_INVALID_HANDLE)
     then begin
   tbar1:=CreateToolBarLocal('Налоги','Панель налогов',0);
   ListToolBarHandles.Add(Pointer(tbar1));
   if hMenuRbkLinkSummPercent<>MENU_INVALID_HANDLE then
    hToolButtonRbkLinkSummPercent:=CreateToolButtonLocal(tbar1,'Соотношения сумма-процент',NameRbkLinkSummPercent,2,ToolButtonClickProc);
   if hMenuRbkTaxesType<>MENU_INVALID_HANDLE then
    hToolButtonRbkTaxesType:=CreateToolButtonLocal(tbar1,'Виды налогов',NameRbkTaxesType,1,ToolButtonClickProc);
   if hMenuRbkTreeTaxes<>MENU_INVALID_HANDLE then
    hToolButtonRbkTreeTaxes:=CreateToolButtonLocal(tbar1,'Зависимости налогов',NameRbkTreeTaxes,3,ToolButtonClickProc);
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
end;

procedure BeforeSetOptionProc(OptionHandle: THandle);stdcall;
begin
end;

procedure AfterSetOptionProc(OptionHandle: THandle; isOK: Boolean);stdcall;
begin
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


  if MenuHandle=hMenuRbkTaxesType then ViewInterface(hInterfaceRbkTaxesType,@TPRBI);
  if MenuHandle=hMenuRbkTreeTaxes then ViewInterface(hInterfaceRbkTreeTaxes,@TPRBI);
  if MenuHandle=hMenuRbkLinkSummPercent then ViewInterface(hInterfaceRbkLinkSummPercent,@TPRBI);
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
  isFreeTaxes: Boolean;
  isFreeRBooks: Boolean;
begin
  hMenuRBooks:=CreateMenuLocal(MENU_ROOT_HANDLE,ConstsMenuRBooks,PChar(ChangeString(ConstsMenuRBooks,'&','')),
                               tcmInsertBefore,_GetMenuHandleFromName(MENU_ROOT_HANDLE,ConstsMenuService));
  ListMenuHandles.Add(Pointer(hMenuRBooks));

  hMenuTaxes:=CreateMenuLocal(hMenuRBooks,ConstsMenuTaxes,ConstsMenuTaxes,tcmAddFirst);

  hMenuRbkTaxesType:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkTaxesType) then
   hMenuRbkTaxesType:=CreateMenuLocal(hMenuTaxes,'Виды налогов',NameRbkTaxesType,tcmAddLast,MENU_INVALID_HANDLE,1,0,MenuClickProc);

  hMenuRbkTreeTaxes:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkTreeTaxes) then
   hMenuRbkTreeTaxes:=CreateMenuLocal(hMenuTaxes,'Зависимости налогов',NameRbkTreeTaxes,tcmAddLast,MENU_INVALID_HANDLE,2,0,MenuClickProc);

  hMenuRbkLinkSummPercent:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkLinkSummPercent) then
   hMenuRbkLinkSummPercent:=CreateMenuLocal(hMenuTaxes,'Соотношения сумма-процент',NameRbkLinkSummPercent,tcmAddLast,MENU_INVALID_HANDLE,3,0,MenuClickProc);

  isFreeTaxes:=(hMenuTaxes<>MENU_INVALID_HANDLE)and
               (hMenuRbkTaxesType=MENU_INVALID_HANDLE)and
               (hMenuRbkTreeTaxes=MENU_INVALID_HANDLE)and
               (hMenuRbkLinkSummPercent=MENU_INVALID_HANDLE);

  if isFreeTaxes then
    if _FreeMenu(hMenuTaxes) then hMenuTaxes:=MENU_INVALID_HANDLE;

  isFreeRBooks:=(hMenuRBooks<>MENU_INVALID_HANDLE)and
                (hMenuTaxes=MENU_INVALID_HANDLE);
  if isFreeRBooks then
    if _FreeMenu(hMenuRBooks) then hMenuRBooks:=MENU_INVALID_HANDLE;

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

  hInterfaceRbkTaxesType:=CreateLocalInterface(NameRbkTaxesType,NameRbkTaxesType);
  CreateLocalPermission(hInterfaceRbkTaxesType,tbTaxesType,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkTaxesType,tbTaxesType,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkTaxesType,tbTaxesType,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkTaxesType,tbTaxesType,ttpDelete,false,ttiaDelete);

  hInterfaceRbkTreeTaxes:=CreateLocalInterface(NameRbkTreeTaxes,NameRbkTreeTaxes);
  CreateLocalPermission(hInterfaceRbkTreeTaxes,tbTreeTaxes,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkTreeTaxes,tbTreeTaxes,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkTreeTaxes,tbTreeTaxes,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkTreeTaxes,tbTreeTaxes,ttpDelete,false,ttiaDelete);

  hInterfaceRbkLinkSummPercent:=CreateLocalInterface(NameRbkLinkSummPercent,NameRbkLinkSummPercent);
  CreateLocalPermission(hInterfaceRbkLinkSummPercent,tbLinkSummPercent,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkLinkSummPercent,tbLinkSummPercent,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkLinkSummPercent,tbLinkSummPercent,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkLinkSummPercent,tbLinkSummPercent,ttpDelete,false,ttiaDelete);

end;


function CreateAndViewTaxesType(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBTaxesType=nil then
       fmRBTaxesType:=TfmRBTaxesType.Create(Application);
     fmRBTaxesType.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBTaxesType;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBTaxesType.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkTaxesType,Param);
  end;
end;

function CreateAndViewTreeTaxes(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBTreeTaxes=nil then
       fmRBTreeTaxes:=TfmRBTreeTaxes.Create(Application);
     fmRBTreeTaxes.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBTreeTaxes;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBTreeTaxes.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkTreeTaxes,Param);
  end;
end;

function CreateAndViewLinkSummPercent(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBLinkSummPercent=nil then
       fmRBLinkSummPercent:=TfmRBLinkSummPercent.Create(Application);
     fmRBLinkSummPercent.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBLinkSummPercent;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBLinkSummPercent.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkLinkSummPercent,Param);
  end;
end;

function ViewInterface(InterfaceHandle: THandle; Param: Pointer): Boolean; stdcall;
begin
  Result:=false;
  if InterfaceHandle=hInterfaceRbkTaxesType then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewTaxesType(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkTreeTaxes then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewTreeTaxes(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkLinkSummPercent then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewLinkSummPercent(InterfaceHandle,Param);
  end;
end;

function isPermissionOnInterfaceView(InterfaceHandle: THandle): Boolean;
var
    isRemove: Boolean;
begin
    isRemove:=false;
    if InterfaceHandle=hInterfaceRbkTaxesType then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBTaxesType)
      else if fmRBTaxesType<>nil then begin
       fmRBTaxesType.SetInterfaceHandle(InterfaceHandle);
       fmRBTaxesType.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkTreeTaxes then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBTreeTaxes)
      else if fmRBTreeTaxes<>nil then begin
       fmRBTreeTaxes.SetInterfaceHandle(InterfaceHandle);
       fmRBTreeTaxes.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkLinkSummPercent then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBLinkSummPercent)
      else if fmRBLinkSummPercent<>nil then begin
       fmRBLinkSummPercent.SetInterfaceHandle(InterfaceHandle);
       fmRBLinkSummPercent.ActiveQuery(true);
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
