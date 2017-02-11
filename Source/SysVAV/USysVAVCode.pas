unit USysVAVCode;

interface

{$I stbasis.inc}

uses Windows, Forms, USysVAVData, UMainUnited, Classes, USysVAVDm, graphics, dialogs,
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



implementation

uses ActiveX,Menus,TSVDbGrid,dbtree,
     USysVAVOptions,URBTypeNumerator,URBUsersGroup;

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


  FreeAndNil(fmRBTypeNumerator);
  FreeAndNil(fmRBUsersGroup);

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
  if ToolButtonHandle=hToolButtonRbkNumerators then MenuClickProc(hMenuRbkNumerators);
  if ToolButtonHandle=hToolButtonRbkUsersGroup then MenuClickProc(hMenuRbkUsersGroup);  
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
  if (hMenuRbkNumerators<>MENU_INVALID_HANDLE)
     then begin
   tbar1:=CreateToolBarLocal('Настройки','Панель настроек',0);
   ListToolBarHandles.Add(Pointer(tbar1));
   if hMenuRbkNumerators<>MENU_INVALID_HANDLE then
    hToolButtonRbkNumerators:=CreateToolButtonLocal(tbar1,'Нумераторы',NameRbkNumerators,0,ToolButtonClickProc);
   if hMenuRbkUsersGroup<>MENU_INVALID_HANDLE then
    hToolButtonRbkUsersGroup:=CreateToolButtonLocal(tbar1,'Доступ',NameRbkUsersGroup,1,ToolButtonClickProc);

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

  if MenuHandle=hMenuRbkNumerators then ViewInterface(hInterfaceRbkNumerators,@TPRBI);
  if MenuHandle=hMenuRbkUsersGroup then ViewInterface(hInterfaceRbkUsersGroup,@TPRBI);  
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
  isFreeSys: Boolean;
  isFreeRBooks: Boolean;
begin
  hMenuRBooks:=CreateMenuLocal(MENU_ROOT_HANDLE,ConstsMenuService,PChar(ChangeString(ConstsMenuService,'&','')),
                               tcmAddFirst);
  ListMenuHandles.Add(Pointer(hMenuRBooks));

  hMenuSys:=CreateMenuLocal(hMenuRBooks,ConstsMenuTune,ConstsMenuTune,tcmAddLast);

  hMenuRbkNumerators:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkNumerators) then
   hMenuRbkNumerators:=CreateMenuLocal(hMenuSys,'Нумераторы',NameRbkNumerators,tcmAddLast,MENU_INVALID_HANDLE,0,0,MenuClickProc);

  hMenuRbkUsersGroup:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkUsersGroup) then
   hMenuRbkUsersGroup:=CreateMenuLocal(hMenuSys,'Доступ к данным',NameRbkUsersGroup,tcmAddLast,MENU_INVALID_HANDLE,1,0,MenuClickProc);


  isFreeSys:=(hMenuSys<>MENU_INVALID_HANDLE)and
               (hMenuRbkNumerators=MENU_INVALID_HANDLE) and
               (hMenuRbkUsersGroup=MENU_INVALID_HANDLE);

  if isFreeSys then
    if _FreeMenu(hMenuSys) then hMenuSys:=MENU_INVALID_HANDLE;

  isFreeRBooks:=(hMenuRBooks<>MENU_INVALID_HANDLE)and
                (hMenuSys=MENU_INVALID_HANDLE);
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
  hInterfaceRbkNumerators:=CreateLocalInterface(NameRbkNumerators,NameRbkNumerators);
  CreateLocalPermission(hInterfaceRbkNumerators,tbNumerators,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkNumerators,tbNumerators,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkNumerators,tbNumerators,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkNumerators,tbNumerators,ttpDelete,false,ttiaDelete);

  CreateLocalPermission(hInterfaceRbkNumerators,tbTypeNumerator,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkNumerators,tbTypeNumerator,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkNumerators,tbTypeNumerator,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkNumerators,tbTypeNumerator,ttpDelete,false,ttiaDelete);

  CreateLocalPermission(hInterfaceRbkNumerators,tbLinkTypeDocNumerator,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkNumerators,tbLinkTypeDocNumerator,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkNumerators,tbLinkTypeDocNumerator,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkNumerators,tbLinkTypeDocNumerator,ttpDelete,false,ttiaDelete);

  hInterfaceRbkTypeNumerator:=CreateLocalInterface(NameRbkTypeNumerator,NameRbkTypeNumerator);
  CreateLocalPermission(hInterfaceRbkNumerators,tbTypeNumerator,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkNumerators,tbTypeNumerator,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkNumerators,tbTypeNumerator,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkNumerators,tbTypeNumerator,ttpDelete,false,ttiaDelete);

  hInterfaceRbkUsersGroup:=CreateLocalInterface(NameRbkUsersGroup,NameRbkUsersGroup);
  CreateLocalPermission(hInterfaceRbkUsersGroup,tbUsersGroup,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkUsersGroup,tbUsersGroup,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkUsersGroup,tbUsersGroup,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkUsersGroup,tbUsersGroup,ttpDelete,false,ttiaDelete);

  CreateLocalPermission(hInterfaceRbkUsersGroup,tbUsersInGroup,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkUsersGroup,tbUsersInGroup,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkUsersGroup,tbUsersInGroup,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkUsersGroup,tbUsersInGroup,ttpDelete,false,ttiaDelete);

  CreateLocalPermission(hInterfaceRbkUsersGroup,tbUsersAccessRights,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkUsersGroup,tbUsersAccessRights,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkUsersGroup,tbUsersAccessRights,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkUsersGroup,tbUsersAccessRights,ttpDelete,false,ttiaDelete);

end;

function CreateAndViewNumerators(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBTypeNumerator=nil then
       fmRBTypeNumerator:=TfmRBTypeNumerator.Create(Application);
     fmRBTypeNumerator.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBTypeNumerator;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=fmRBTypeNumerator.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkNumerators,Param);
  end;
end;

function CreateAndViewTypeNumerator(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    exit;
    result:=false;
    try
     if fmRBTypeNumerator=nil then
       fmRBTypeNumerator:=TfmRBTypeNumerator.Create(Application);
     fmRBTypeNumerator.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBTypeNumerator;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBTypeNumerator.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkTypeNumerator,Param);
  end;
end;

function CreateAndViewUsersGroup(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
//    exit;
    result:=false;
    try
     if fmRBUsersGroup=nil then
       fmRBUsersGroup:=TfmRBUsersGroup.Create(Application);
     fmRBUsersGroup.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBUsersGroup;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBUsersGroup.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkUsersGroup,Param);
  end;
end;


function ViewInterface(InterfaceHandle: THandle; Param: Pointer): Boolean; stdcall;
begin
  Result:=false;
  if InterfaceHandle=hInterfaceRbkNumerators then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewNumerators(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkTypeNumerator then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewTypeNumerator(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkUsersGroup then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewUsersGroup(InterfaceHandle,Param);
  end;

end;

function isPermissionOnInterfaceView(InterfaceHandle: THandle): Boolean;
var
    isRemove: Boolean;
begin
    isRemove:=false;
    if InterfaceHandle=hInterfaceRbkNumerators then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBTypeNumerator)
      else if fmRBTypeNumerator<>nil then begin
       fmRBTypeNumerator.SetInterfaceHandle(InterfaceHandle);
       fmRBTypeNumerator.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkTypeNumerator then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBTypeNumerator)
      else if fmRBTypeNumerator<>nil then begin
       fmRBTypeNumerator.SetInterfaceHandle(InterfaceHandle);
       fmRBTypeNumerator.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkUsersGroup then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBUsersGroup)
      else if fmRBUsersGroup<>nil then begin
       fmRBUsersGroup.SetInterfaceHandle(InterfaceHandle);
       fmRBUsersGroup.ActiveQuery(true);
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
