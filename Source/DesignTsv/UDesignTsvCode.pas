unit UDesignTsvCode;

interface

{$I stbasis.inc}

uses Windows, Forms, UDesignTsvData, UMainUnited, Classes, UDesignTsvDm, graphics, dialogs,
     IBDatabase, IBQuery, Controls, tsvHint, db, SysUtils, IBServices, stdctrls,
     comctrls, tsvDesignCore;

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
procedure EditInterfaceViewAdditionalLogItemProc(Owner: Pointer; LogItemHandle: THandle); stdcall;
procedure EditInterfaceGetDesignPaletteProc(Owner: Pointer; PGDP: PGetDesignPalette); stdcall;
procedure EditInterfaceGetDesignPaletteProcForGetComponentClass(Owner: Pointer; PGDP: PGetDesignPalette); stdcall;
procedure EditInterfaceGetDesignPropertyTranslateProc(Owner: Pointer; PGDPT: PGetDesignPropertyTranslate); stdcall;
procedure EditInterfaceGetDesignPropertyRemoveProc(Owner: Pointer; PGDPR: PGetDesignPropertyRemove); stdcall;

// Export
procedure InitAll_;stdcall;
procedure GetInfoLibrary_(P: PInfoLibrary);stdcall;
procedure RefreshLibrary_;stdcall;
procedure SetConnection_(IBDbase: TIBDatabase; IBTran: TIBTransaction;
                         IBDBSecurity: TIBDatabase; IBTSecurity: TIBTransaction);stdcall;


implementation

uses Menus,tsvDbGrid, UDesignTsvOptions, IBSQLMonitor,
     URBInterface, dbtree, UEditRBInterface,
     URBMenu, URBToolBar, URBToolbutton, URBInterfacePermission, tsvSecurity;

//******************* Internal ************************

procedure InitAll_; stdcall;
begin
 try

  dm:=Tdm.Create(nil);
  fmOptions:=TfmOptions.Create(nil);
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

  isInitAll:=true;

 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure DeInitAll;
begin
 try
  if not isInitAll then exit;

  FreeAndNil(fmRBInterface);
  FreeAndNil(fmRBMenu);
  FreeAndNil(fmRBToolbar);
  FreeAndNil(fmRBToolbutton);
  FreeAndNil(fmRBInterfacePermission);

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
  if ToolButtonHandle=hToolButtonInterface then MenuClickProc(hMenuInterface);
  if ToolButtonHandle=hToolButtonMenu then MenuClickProc(hMenuMenu);
  if ToolButtonHandle=hToolButtonToolbar then MenuClickProc(hMenuToolbar);
  if ToolButtonHandle=hToolButtonToolbutton then MenuClickProc(hMenuToolbutton);
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
  if (hMenuInterface<>MENU_INVALID_HANDLE)or
     (hMenuMenu<>MENU_INVALID_HANDLE)or
     (hMenuToolBar<>MENU_INVALID_HANDLE)or
     (hMenuToolbutton<>MENU_INVALID_HANDLE) then begin
   tbar1:=CreateToolBarLocal('Создание интерфейсов','Панель создания интерфейсов',0);
   ListToolBarHandles.Add(Pointer(tbar1));
   if hMenuInterface<>MENU_INVALID_HANDLE then
    hToolButtonInterface:=CreateToolButtonLocal(tbar1,'Интерфейсы',NameRbkInterface,0,ToolButtonClickProc);
   if hMenuMenu<>MENU_INVALID_HANDLE then
    hToolButtonMenu:=CreateToolButtonLocal(tbar1,'Меню',NameRbkMenu,1,ToolButtonClickProc);
   if hMenuToolBar<>MENU_INVALID_HANDLE then
    hToolButtonToolbar:=CreateToolButtonLocal(tbar1,'Панели инструментов',NameRbkToolBar,2,ToolButtonClickProc);
   if hMenuToolbutton<>MENU_INVALID_HANDLE then
    hToolButtonToolbutton:=CreateToolButtonLocal(tbar1,'Элементы панелей инструментов',NameRbkToolbutton,3,ToolButtonClickProc);
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
  ListOptionHandles.Clear;
  hOptionRBooks:=CreateOptionLocal(OPTION_ROOT_HANDLE,ConstOptionRBooks,-1);
  ListOptionHandles.Add(Pointer(hOptionRBooks));
  if hMenuInterface<>MENU_INVALID_HANDLE then begin
   hOptionRBInterface:=CreateOptionLocal(hOptionRBooks,NameRbkInterface,0);
   hOptionScript:=CreateOptionLocal(hOptionRBInterface,ConstOptionScript,-1);
   hOptionForms:=CreateOptionLocal(hOptionRBInterface,ConstOptionForms,-1);
   hOptionDocs:=CreateOptionLocal(hOptionRBInterface,ConstOptionDocs,-1);
  end;
end;

procedure BeforeSetOptionProc(OptionHandle: THandle);stdcall;

  procedure BeforeSetOption;
  var
    wc: TWinControl;
  begin
     if OptionHandle=hOptionScript then begin
      wc:=FindControl(_GetOptionParentWindow(hOptionScript));
      if isValidPointer(wc) then begin
       fmOptions.pc.ActivePage:=fmOptions.tsScript;
       fmOptions.pnScript.Parent:=wc;
      end;
     end;
     if OptionHandle=hOptionForms then begin
      wc:=FindControl(_GetOptionParentWindow(hOptionForms));
      if isValidPointer(wc) then begin
       fmOptions.pc.ActivePage:=fmOptions.tsForms;
       fmOptions.pnForms.Parent:=wc;
      end;
     end;
     if OptionHandle=hOptionDocs then begin
      wc:=FindControl(_GetOptionParentWindow(hOptionDocs));
      if isValidPointer(wc) then begin
       fmOptions.pc.ActivePage:=fmOptions.tsDocs;
       fmOptions.pnDocs.Parent:=wc;
      end;
     end;
  end;

begin
  fmOptions.Visible:=true;
  fmOptions.LoadFromIni(OptionHandle);
  BeforeSetOption;
end;

procedure AfterSetOptionProc(OptionHandle: THandle; isOk: Boolean);stdcall;

  procedure AfterSetOption;
  begin
     if OptionHandle=hOptionScript then begin
      fmOptions.pnScript.Parent:=fmOptions.tsScript;
      if isOk then
        if fmRBInterface<>nil then begin
          fmRBInterface.SetParamsFromOptions(0);
        end;
     end;
     if OptionHandle=hOptionForms then begin
      fmOptions.pnForms.Parent:=fmOptions.tsForms;
      if isOk then
        if fmRBInterface<>nil then begin
          fmRBInterface.SetParamsFromOptions(1);
        end;
     end;
     if OptionHandle=hOptionDocs  then
      fmOptions.pnDocs.Parent:=fmOptions.tsDocs;
  end;

begin
  AfterSetOption;
  if isOK then fmOptions.SaveToIni(OptionHandle)
  else fmOptions.LoadFromIni(OptionHandle);
  fmOptions.Visible:=false;
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
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);

  if MenuHandle=hMenuInterface then ViewInterface(hInterfaceRbkInterface,@TPRBI);
  if MenuHandle=hMenuMenu then ViewInterface(hInterfaceRbkMenu,@TPRBI);
  if MenuHandle=hMenuToolbar then ViewInterface(hInterfaceRbkToolbar,@TPRBI);
  if MenuHandle=hMenuToolbutton then ViewInterface(hInterfaceRbkToolbutton,@TPRBI);
  if MenuHandle=hMenuInterfacePermission then ViewInterface(hInterfaceRbkInterfacePermission,@TPRBI);
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
  isFreeServiceInterfaces: Boolean;
  isFreeService: Boolean;
begin
  ListMenuHandles.Clear;
  hMenuService:=CreateMenuLocal(MENU_ROOT_HANDLE,ConstsMenuService,PChar(ChangeString(ConstsMenuService,'&','')));
  ListMenuHandles.Add(Pointer(hMenuService));

  hMenuServiceInterfaces:=CreateMenuLocal(hMenuService,'Создание интерфейсов','Создание интерфейсов',tcmAddFirst);
  hMenuInterface:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkInterface) then
   hMenuInterface:=CreateMenuLocal(hMenuServiceInterfaces,'Интерфейсы',NameRbkInterface,tcmAddLast,MENU_INVALID_HANDLE,0,0,MenuClickProc);
  hMenuMenu:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkMenu) then
   hMenuMenu:=CreateMenuLocal(hMenuServiceInterfaces,'Меню',NameRbkMenu,tcmAddLast,MENU_INVALID_HANDLE,1,0,MenuClickProc);
  hMenuToolBar:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkToolBar) then
   hMenuToolBar:=CreateMenuLocal(hMenuServiceInterfaces,'Панели инструментов',NameRbkToolbar,tcmAddLast,MENU_INVALID_HANDLE,2,0,MenuClickProc);
  hMenuToolbutton:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkToolbutton) then
   hMenuToolbutton:=CreateMenuLocal(hMenuServiceInterfaces,'Элементы панелей инструментов',NameRbkToolbutton,tcmAddLast,MENU_INVALID_HANDLE,3,0,MenuClickProc);
  hMenuInterfacePermission:=MENU_INVALID_HANDLE; 
  if isPermissionOnInterfaceView(hInterfaceRbkInterfacePermission) then
   hMenuInterfacePermission:=CreateMenuLocal(hMenuServiceInterfaces,'Права интерфейсов',NameRbkInterfacePermission,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  isFreeServiceInterfaces:=(hMenuServiceInterfaces<>MENU_INVALID_HANDLE)and
                           (hMenuInterface=MENU_INVALID_HANDLE)and
                           (hMenuMenu=MENU_INVALID_HANDLE)and
                           (hMenuToolBar=MENU_INVALID_HANDLE)and
                           (hMenuToolbutton=MENU_INVALID_HANDLE)and
                           (hMenuInterfacePermission=MENU_INVALID_HANDLE);
  if isFreeServiceInterfaces then
    if _FreeMenu(hMenuServiceInterfaces) then hMenuServiceInterfaces:=MENU_INVALID_HANDLE;

  isFreeService:=(hMenuService<>MENU_INVALID_HANDLE)and
                 (hMenuServiceInterfaces=MENU_INVALID_HANDLE);
  if isFreeService then
    if _FreeMenu(hMenuService) then ;
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
  hInterfaceRbkInterface:=CreateLocalInterface(NameRbkInterface,NameRbkInterface);
  CreateLocalPermission(hInterfaceRbkInterface,tbInterface,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkInterface,tbInterface,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkInterface,tbInterface,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkInterface,tbInterface,ttpDelete,false,ttiaDelete);

  hInterfaceRbkMenu:=CreateLocalInterface(NameRbkMenu,NameRbkMenu);
  CreateLocalPermission(hInterfaceRbkMenu,tbMenu,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkMenu,tbInterface,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkMenu,tbMenu,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkMenu,tbMenu,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkMenu,tbMenu,ttpDelete,false,ttiaDelete);

  hInterfaceRbkToolbar:=CreateLocalInterface(NameRbkToolbar,NameRbkToolbar);
  CreateLocalPermission(hInterfaceRbkToolbar,tbToolbar,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkToolbar,tbToolbar,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkToolbar,tbToolbar,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkToolbar,tbToolbar,ttpDelete,false,ttiaDelete);

  hInterfaceRbkToolbutton:=CreateLocalInterface(NameRbkToolbutton,NameRbkToolbutton);
  CreateLocalPermission(hInterfaceRbkToolbutton,tbToolbutton,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkToolbutton,tbToolBar,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkToolbutton,tbInterface,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkToolbutton,tbToolbutton,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkToolbutton,tbToolbutton,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkToolbutton,tbToolbutton,ttpDelete,false,ttiaDelete);

  hInterfaceRbkInterfacePermission:=CreateLocalInterface(NameRbkInterfacePermission,NameRbkInterfacePermission);
  CreateLocalPermission(hInterfaceRbkInterfacePermission,tbInterfacePermission,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkInterfacePermission,tbInterface,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkInterfacePermission,tbInterfacePermission,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkInterfacePermission,tbInterfacePermission,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkInterfacePermission,tbInterfacePermission,ttpDelete,false,ttiaDelete);

end;

function CreateAndViewInterface(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBInterface=nil then
       fmRBInterface:=TfmRBInterface.Create(Application);
     fmRBInterface.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBInterface;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBInterface.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkInterface,Param);
  end;
end;

function CreateAndViewMenu(MenuHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBMenu=nil then
       fmRBMenu:=TfmRBMenu.Create(Application);
     fmRBMenu.InitMdiChildParams(MenuHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBMenu;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBMenu.Create(nil);
       fm.InitModalParams(MenuHandle,Param);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkMenu,Param);
  end;
end;

function CreateAndViewToolbar(ToolbarHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBToolbar=nil then
       fmRBToolbar:=TfmRBToolbar.Create(Application);
     fmRBToolbar.InitMdiChildParams(ToolbarHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBToolbar;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBToolbar.Create(nil);
       fm.InitModalParams(ToolbarHandle,Param);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkToolbar,Param);
  end;
end;

function CreateAndViewToolbutton(ToolbuttonHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBToolbutton=nil then
       fmRBToolbutton:=TfmRBToolbutton.Create(Application);
     fmRBToolbutton.InitMdiChildParams(ToolbuttonHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBToolbutton;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBToolbutton.Create(nil);
       fm.InitModalParams(ToolbuttonHandle,Param);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkToolbutton,Param);
  end;
end;

function CreateAndViewInterfacePermission(InterfacePermissionHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBInterfacePermission=nil then
       fmRBInterfacePermission:=TfmRBInterfacePermission.Create(Application);
     fmRBInterfacePermission.InitMdiChildParams(InterfacePermissionHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBInterfacePermission;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBInterfacePermission.Create(nil);
       fm.InitModalParams(InterfacePermissionHandle,Param);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkInterfacePermission,Param);
  end;
end;

function ViewInterface(InterfaceHandle: THandle; Param: Pointer): Boolean; stdcall;
begin
  Result:=false;
  if InterfaceHandle=hInterfaceRbkInterface then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewInterface(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkMenu then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewMenu(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkToolbar then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewToolbar(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkToolbutton then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewToolbutton(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkInterfacePermission then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewInterfacePermission(InterfaceHandle,Param);
  end;

end;

function isPermissionOnInterfaceView(InterfaceHandle: THandle): Boolean;
var
    isRemove: Boolean;
begin
    isRemove:=false;
    if InterfaceHandle=hInterfaceRbkInterface then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBInterface)
      else if fmRBInterface<>nil then begin
       fmRBInterface.SetInterfaceHandle(InterfaceHandle);
       fmRBInterface.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkMenu then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBMenu)
      else if fmRBMenu<>nil then begin
       fmRBMenu.SetInterfaceHandle(InterfaceHandle);
       fmRBMenu.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkToolbar then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBToolbar)
      else if fmRBToolbar<>nil then begin
       fmRBToolbar.SetInterfaceHandle(InterfaceHandle);
       fmRBToolbar.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkToolbutton then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBToolbutton)
      else if fmRBToolbutton<>nil then begin
       fmRBToolbutton.SetInterfaceHandle(InterfaceHandle);
       fmRBToolbutton.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkInterfacePermission then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBInterfacePermission)
      else if fmRBInterfacePermission<>nil then begin
       fmRBInterfacePermission.SetInterfaceHandle(InterfaceHandle);
       fmRBInterfacePermission.ActiveQuery(true);
      end;
    end;
    result:=not isRemove;
end;

function GetEditRBInterfaceByInterpreterHandle(InterpreterHandle: THandle): TfmEditRBInterface;
var
  i: Integer;
  fm: TfmEditRBInterface;
begin
  Result:=nil;
  for i:=0 to ListEditInterfaceForms.Count-1 do begin
    fm:=TfmEditRBInterface(ListEditInterfaceForms.Items[i]);
    if fm.InterpreterHandle=InterpreterHandle then begin
      Result:=fm;
      exit;
    end;
  end;
end;

procedure EditInterfaceViewAdditionalLogItemProc(Owner: Pointer; LogItemHandle: THandle); stdcall;
var
  i: Integer;
  fm: TfmEditRBInterface;
  P: Pointer;
begin
  for i:=0 to ListEditInterfaceForms.Count-1 do begin
    fm:=TfmEditRBInterface(ListEditInterfaceForms.Items[i]);
    P:=fm.GetInfoInterpreterPos(LogItemHandle);
    if P<>nil then fm.ViewInfoInterpreterPos(P);
  end;
end;

function GetEditRBInterfaceByLink(Owner: Pointer): TfmEditRBInterface;
var
  i: Integer;
  fm: TfmEditRBInterface;
begin
  Result:=nil;
  for i:=0 to ListEditInterfaceForms.Count-1 do begin
    fm:=TfmEditRBInterface(ListEditInterfaceForms.Items[i]);
    if fm=Owner then begin
      Result:=fm;
      exit;
    end;
  end;
end;

procedure EditInterfaceGetDesignPaletteProc(Owner: Pointer; PGDP: PGetDesignPalette); stdcall;
var
  fm: TfmEditRBInterface;
begin
  fm:=GetEditRBInterfaceByLink(Owner);
  if fm<>nil then
    if fm.DTC<>nil then
     fm.DTC.GetDesignPaletteProc(PGDP);
end;

procedure EditInterfaceGetDesignPaletteProcForGetComponentClass(Owner: Pointer; PGDP: PGetDesignPalette); stdcall;
var
  fm: TfmEditRBInterface;
begin
  fm:=GetEditRBInterfaceByLink(Owner);
  if fm<>nil then
    if fm.DTC<>nil then
     fm.DTC.GetDesignPaletteProcForGetComponentClass(PGDP);
end;

procedure EditInterfaceGetDesignPropertyTranslateProc(Owner: Pointer; PGDPT: PGetDesignPropertyTranslate); stdcall;
var
  fm: TfmEditRBInterface;
begin
  fm:=GetEditRBInterfaceByLink(Owner);
  if fm<>nil then
    if fm.DOI<>nil then
     fm.DOI.GetDesignPropertyTranslateProc(PGDPT);
end;

procedure EditInterfaceGetDesignPropertyRemoveProc(Owner: Pointer; PGDPR: PGetDesignPropertyRemove); stdcall;
var
  fm: TfmEditRBInterface;
begin
  fm:=GetEditRBInterfaceByLink(Owner);
  if fm<>nil then
    if fm.DOI<>nil then
     fm.DOI.GetDesignPropertyRemoveProc(PGDPR);
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
