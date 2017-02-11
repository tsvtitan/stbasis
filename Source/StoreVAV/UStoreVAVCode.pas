unit UStoreVAVCode;

interface

{$I stbasis.inc}

uses Windows, Forms, UStoreVAVData, UMainUnited, Classes, UStoreVAVDm, graphics, dialogs,
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
procedure AfterSetOptionProc(OptionHandle: THandle; isOk: Boolean);stdcall;


// Export
procedure InitAll_;stdcall;
procedure GetInfoLibrary_(P: PInfoLibrary);stdcall;
procedure RefreshLibrary_;stdcall;
procedure SetConnection_(IBDbase: TIBDatabase; IBTran: TIBTransaction;
                         IBDBSecurity: TIBDatabase; IBTSecurity: TIBTransaction);stdcall;


implementation

uses ActiveX,Menus,TSVDbGrid,dbtree,
     URBRespondents,URBStoreType,URBValueProperties,URBProperties,
     UStoreVAVOptions,URBReasons,URBStorePlace;

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

  FreeAndNil(fmRBRespondents);
  FreeAndNil(fmRBStoreType);
  FreeAndNil(fmRBValueProperties);
  FreeAndNil(fmRBProperties);
  FreeAndNil(fmRBStorePlace);
  FreeAndNil(fmRBReasons);

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
  if ToolButtonHandle=hToolButtonRbkRespondents then MenuClickProc(hMenuRbkRespondents);
  if ToolButtonHandle=hToolButtonRbkValueProperties then MenuClickProc(hMenuRbkValueProperties);
  if ToolButtonHandle=hToolButtonRbkStoreType then MenuClickProc(hMenuRbkStoreType);
  if ToolButtonHandle=hToolButtonRbkProperties then MenuClickProc(hMenuRbkProperties);
  if ToolButtonHandle=hToolButtonRbkReasons then MenuClickProc(hMenuRbkReasons);
  if ToolButtonHandle=hToolButtonRbkStorePlace then MenuClickProc(hMenuRbkStorePlace);
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
  if (hMenuRbkRespondents<>MENU_INVALID_HANDLE)or
     (hMenuRbkValueProperties<>MENU_INVALID_HANDLE) or
     (hMenuRbkProperties<>MENU_INVALID_HANDLE) or
     (hMenuRbkStoreType<>MENU_INVALID_HANDLE)
     then begin
   tbar1:=CreateToolBarLocal('Склад','Панель склада',0);
   ListToolBarHandles.Add(Pointer(tbar1));
   if hMenuRbkRespondents<>MENU_INVALID_HANDLE then
    hToolButtonRbkRespondents:=CreateToolButtonLocal(tbar1,'Материально-ответственные лица',NameRbkRespondents,0,ToolButtonClickProc);
   if hMenuRbkValueProperties<>MENU_INVALID_HANDLE then
    hToolButtonRbkValueProperties:=CreateToolButtonLocal(tbar1,'Значения свойств',NameRbkValueProperties,2,ToolButtonClickProc);
   if hMenuRbkStoreType<>MENU_INVALID_HANDLE then
    hToolButtonRbkStoreType:=CreateToolButtonLocal(tbar1,'Виды мест хранения',NameRbkStoreType,1,ToolButtonClickProc);
   if hMenuRbkProperties<>MENU_INVALID_HANDLE then
    hToolButtonRbkProperties:=CreateToolButtonLocal(tbar1,'Свойства товара',NameRbkProperties,3,ToolButtonClickProc);
   if hMenuRbkReasons<>MENU_INVALID_HANDLE then
    hToolButtonRbkReasons:=CreateToolButtonLocal(tbar1,'Причины списания',NameRbkReasons,4,ToolButtonClickProc);
   if hMenuRbkStorePlace<>MENU_INVALID_HANDLE then
    hToolButtonRbkStorePlace:=CreateToolButtonLocal(tbar1,'Места хранения',NameRbkStorePlace,5,ToolButtonClickProc);
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

procedure AfterSetOptionProc(OptionHandle: THandle; isOk: Boolean);stdcall;
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

  if MenuHandle=hMenuRbkRespondents then ViewInterface(hInterfaceRbkRespondents,@TPRBI);
  if MenuHandle=hMenuRbkStoreType then ViewInterface(hInterfaceRbkStoreType,@TPRBI);
  if MenuHandle=hMenuRbkProperties then ViewInterface(hInterfaceRbkProperties,@TPRBI);
  if MenuHandle=hMenuRbkValueProperties then ViewInterface(hInterfaceRbkValueProperties,@TPRBI);
  if MenuHandle=hMenuRbkReasons then ViewInterface(hInterfaceRbkReasons,@TPRBI);
  if MenuHandle=hMenuRbkStorePlace then ViewInterface(hInterfaceRbkStorePlace,@TPRBI);
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
  isFreeStore: Boolean;
  isFreeRBooks: Boolean;
begin
  hMenuRBooks:=CreateMenuLocal(MENU_ROOT_HANDLE,ConstsMenuRBooks,PChar(ChangeString(ConstsMenuRBooks,'&','')),
                               tcmInsertBefore,_GetMenuHandleFromName(MENU_ROOT_HANDLE,ConstsMenuService));
  ListMenuHandles.Add(Pointer(hMenuRBooks));

  hMenuStore:=CreateMenuLocal(hMenuRBooks,ConstsMenuStore,ConstsMenuStore,tcmAddFirst);

  hMenuRbkRespondents:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkRespondents) then
   hMenuRbkRespondents:=CreateMenuLocal(hMenuStore,'Материально-ответственные лица',NameRbkRespondents,tcmAddLast,MENU_INVALID_HANDLE,0,0,MenuClickProc);

  hMenuRbkStoreType:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkStoreType) then
   hMenuRbkStoreType:=CreateMenuLocal(hMenuStore,'Виды мест хранения',NameRbkStoreType,tcmAddLast,MENU_INVALID_HANDLE,1,0,MenuClickProc);

  hMenuRbkProperties:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkProperties) then
   hMenuRbkProperties:=CreateMenuLocal(hMenuStore,'Свойства товаров',NameRbkProperties,tcmAddLast,MENU_INVALID_HANDLE,2,0,MenuClickProc);

  hMenuRbkValueProperties:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkValueProperties) then
   hMenuRbkValueProperties:=CreateMenuLocal(hMenuStore,'Значения свойств',NameRbkValueProperties,tcmAddLast,MENU_INVALID_HANDLE,3,0,MenuClickProc);

  hMenuRbkReasons:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkReasons) then
   hMenuRbkReasons:=CreateMenuLocal(hMenuStore,'Причины списания',NameRbkReasons,tcmAddLast,MENU_INVALID_HANDLE,4,0,MenuClickProc);

  hMenuRbkStorePlace:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkStorePlace) then
   hMenuRbkStorePlace:=CreateMenuLocal(hMenuStore,'Места хранения',NameRbkStorePlace,tcmAddLast,MENU_INVALID_HANDLE,5,0,MenuClickProc);

  isFreeStore:=(hMenuStore<>MENU_INVALID_HANDLE)and
               (hMenuRbkRespondents=MENU_INVALID_HANDLE)and
               (hMenuRbkStoreType=MENU_INVALID_HANDLE)and
               (hMenuRbkProperties=MENU_INVALID_HANDLE)and
               (hMenuRbkValueProperties=MENU_INVALID_HANDLE) and
               (hMenuRbkReasons=MENU_INVALID_HANDLE) and
               (hMenuRbkStorePlace=MENU_INVALID_HANDLE);

  if isFreeStore then
    if _FreeMenu(hMenuStore) then hMenuStore:=MENU_INVALID_HANDLE;

  isFreeRBooks:=(hMenuRBooks<>MENU_INVALID_HANDLE)and
                (hMenuStore=MENU_INVALID_HANDLE);
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
  hInterfaceRbkRespondents:=CreateLocalInterface(NameRbkRespondents,NameRbkRespondents);
  CreateLocalPermission(hInterfaceRbkRespondents,tbRespondents,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkRespondents,tbRespondents,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkRespondents,tbRespondents,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkRespondents,tbRespondents,ttpDelete,false,ttiaDelete);

  hInterfaceRbkStoreType:=CreateLocalInterface(NameRbkStoreType,NameRbkStoreType);
  CreateLocalPermission(hInterfaceRbkStoreType,tbStoreType,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkStoreType,tbStoreType,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkStoreType,tbStoreType,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkStoreType,tbStoreType,ttpDelete,false,ttiaDelete);

  hInterfaceRbkProperties:=CreateLocalInterface(NameRbkProperties,NameRbkProperties);
  CreateLocalPermission(hInterfaceRbkProperties,tbProperties,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkProperties,tbProperties,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkProperties,tbProperties,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkProperties,tbProperties,ttpDelete,false,ttiaDelete);

  hInterfaceRbkValueProperties:=CreateLocalInterface(NameRbkValueProperties,NameRbkValueProperties);
  CreateLocalPermission(hInterfaceRbkValueProperties,tbValueProperties,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkValueProperties,tbValueProperties,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkValueProperties,tbValueProperties,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkValueProperties,tbValueProperties,ttpDelete,false,ttiaDelete);

  hInterfaceRbkReasons:=CreateLocalInterface(NameRbkReasons,NameRbkReasons);
  CreateLocalPermission(hInterfaceRbkReasons,tbReasons,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkReasons,tbReasons,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkReasons,tbReasons,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkReasons,tbReasons,ttpDelete,false,ttiaDelete);

  hInterfaceRbkStorePlace:=CreateLocalInterface(NameRbkStorePlace,NameRbkStorePlace);
  CreateLocalPermission(hInterfaceRbkStorePlace,tbStorePlace,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkStorePlace,tbStorePlace,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkStorePlace,tbStorePlace,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkStorePlace,tbStorePlace,ttpDelete,false,ttiaDelete);

end;

function CreateAndViewRespondents(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBRespondents=nil then
       fmRBRespondents:=TfmRBRespondents.Create(Application);
     fmRBRespondents.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBRespondents;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBRespondents.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkRespondents,Param);
  end;
end;

function CreateAndViewStoreType(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBStoreType=nil then
       fmRBStoreType:=TfmRBStoreType.Create(Application);
     fmRBStoreType.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBStoreType;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBStoreType.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkStoreType,Param);
  end;
end;

function CreateAndViewProperties(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBProperties=nil then
       fmRBProperties:=TfmRBProperties.Create(Application);
     fmRBProperties.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBProperties;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBProperties.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkProperties,Param);
  end;
end;

function CreateAndViewValueProperties(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBValueProperties=nil then
       fmRBValueProperties:=TfmRBValueProperties.Create(Application);
     fmRBValueProperties.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBValueProperties;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBValueProperties.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkValueProperties,Param);
  end;
end;

function CreateAndViewReasons(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBReasons=nil then
       fmRBReasons:=TfmRBReasons.Create(Application);
     fmRBReasons.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBReasons;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBReasons.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkReasons,Param);
  end;
end;

function CreateAndViewStorePlace(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBStorePlace=nil then
       fmRBStorePlace:=TfmRBStorePlace.Create(Application);
     fmRBStorePlace.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBStorePlace;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBStorePlace.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkStorePlace,Param);
  end;
end;

function ViewInterface(InterfaceHandle: THandle; Param: Pointer): Boolean; stdcall;
begin
  Result:=false;
  if InterfaceHandle=hInterfaceRbkRespondents then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewRespondents(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkStoreType then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewStoreType(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkProperties then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewProperties(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkValueProperties then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewValueProperties(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkReasons then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewReasons(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkStorePlace then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewStorePlace(InterfaceHandle,Param);
  end;

end;

function isPermissionOnInterfaceView(InterfaceHandle: THandle): Boolean;
var
    isRemove: Boolean;
begin
    isRemove:=false;
    if InterfaceHandle=hInterfaceRbkRespondents then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBRespondents)
      else if fmRBRespondents<>nil then begin
       fmRBRespondents.SetInterfaceHandle(InterfaceHandle);
       fmRBRespondents.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkStoreType then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBStoreType)
      else if fmRBStoreType<>nil then begin
       fmRBStoreType.SetInterfaceHandle(InterfaceHandle);
       fmRBStoreType.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkProperties then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBProperties)
      else if fmRBProperties<>nil then begin
       fmRBProperties.SetInterfaceHandle(InterfaceHandle);
       fmRBProperties.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkValueProperties then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBValueProperties)
      else if fmRBValueProperties<>nil then begin
       fmRBValueProperties.SetInterfaceHandle(InterfaceHandle);
       fmRBValueProperties.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkReasons then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBReasons)
      else if fmRBReasons<>nil then begin
       fmRBReasons.SetInterfaceHandle(InterfaceHandle);
       fmRBReasons.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkStorePlace then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBStorePlace)
      else if fmRBStorePlace<>nil then begin
       fmRBStorePlace.SetInterfaceHandle(InterfaceHandle);
       fmRBStorePlace.ActiveQuery(true);
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
