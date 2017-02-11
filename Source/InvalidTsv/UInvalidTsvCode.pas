unit UInvalidTsvCode;

interface

{$I stbasis.inc}

uses Windows, Forms, UInvalidTsvData, UMainUnited, Classes, UInvalidTsvDm, graphics, dialogs,
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

// Import

implementation

uses ActiveX,Menus,tsvDbGrid,dbtree, URBMainTreeView,

     URBInvalidCategory, URBViewPlace,URBInvalidGroup,URBPhysician,
     URBInvalid,URBVisit,URBBranch,

     UInvalidTsvOptions;

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

  FreeAndNil(fmRBInvalidCategory);
  FreeAndNil(fmRBViewPlace);
  FreeAndNil(fmRBInvalidGroup);
  FreeAndNil(fmRBPhysician);
  FreeAndNil(fmRBInvalid);
  FreeAndNil(fmRBVisit);
  FreeAndNil(fmRBBranch);

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
  if ToolButtonHandle=hToolButtonRbkInvalidCategory then MenuClickProc(hMenuRbkInvalidCategory);
  if ToolButtonHandle=hToolButtonRbkViewPlace then MenuClickProc(hMenuRbkViewPlace);
  if ToolButtonHandle=hToolButtonRbkInvalidGroup then MenuClickProc(hMenuRbkInvalidGroup);
  if ToolButtonHandle=hToolButtonRbkPhysician then MenuClickProc(hMenuRbkPhysician);
  if ToolButtonHandle=hToolButtonRbkInvalid then MenuClickProc(hMenuRbkInvalid);
  if ToolButtonHandle=hToolButtonRbkVisit then MenuClickProc(hMenuRbkVisit);
  if ToolButtonHandle=hToolButtonRbkBranch then MenuClickProc(hMenuRbkBranch);
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

{var
  tBar1: THandle;}
begin
{  if (hMenuRbkInvalidCategory<>MENU_INVALID_HANDLE)or
     (hMenuRbkViewPlace<>MENU_INVALID_HANDLE)or
     (hMenuRbkInvalidGroup<>MENU_INVALID_HANDLE)or
     (hMenuRbkPhysician<>MENU_INVALID_HANDLE)or
     (hMenuRbkInvalid<>MENU_INVALID_HANDLE)or
     (hMenuRbkVisit<>MENU_INVALID_HANDLE) then begin
   tbar1:=CreateToolBarLocal('Учет инвалидов','Панель учета инвалидов',0);
   ListToolBarHandles.Add(Pointer(tbar1));
   if hMenuRbkInvalidCategory<>MENU_INVALID_HANDLE then
    hToolButtonRbkInvalidCategory:=CreateToolButtonLocal(tbar1,'Категории инвалидов',NameRbkInvalidCategory,0,ToolButtonClickProc);
   if hMenuRbkViewPlace<>MENU_INVALID_HANDLE then
    hToolButtonRbkViewPlace:=CreateToolButtonLocal(tbar1,'Места осмотров',NameRbkViewPlace,1,ToolButtonClickProc);
   if hMenuRbkInvalidGroup<>MENU_INVALID_HANDLE then
    hToolButtonRbkInvalidGroup:=CreateToolButtonLocal(tbar1,'Группы инвалидности',NameRbkInvalidGroup,3,ToolButtonClickProc);
   if hMenuRbkPhysician<>MENU_INVALID_HANDLE then
    hToolButtonRbkPhysician:=CreateToolButtonLocal(tbar1,'Врачи',NameRbkPhysician,3,ToolButtonClickProc);
   if hMenuRbkInvalid<>MENU_INVALID_HANDLE then
    hToolButtonRbkInvalid:=CreateToolButtonLocal(tbar1,'Инвалиды',NameRbkInvalid,4,ToolButtonClickProc);
   if hMenuRbkVisit<>MENU_INVALID_HANDLE then
    hToolButtonRbkVisit:=CreateToolButtonLocal(tbar1,'Посещения',NameRbkVisit,5,ToolButtonClickProc);
   _RefreshToolBar(tbar1);
  end;}    
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

  if MenuHandle=hMenuRbkInvalidCategory then ViewInterface(hInterfaceRbkInvalidCategory,@TPRBI);
  if MenuHandle=hMenuRbkViewPlace then ViewInterface(hInterfaceRbkViewPlace,@TPRBI);
  if MenuHandle=hMenuRbkInvalidGroup then ViewInterface(hInterfaceRbkInvalidGroup,@TPRBI);
  if MenuHandle=hMenuRbkPhysician then ViewInterface(hInterfaceRbkPhysician,@TPRBI);
  if MenuHandle=hMenuRbkInvalid then ViewInterface(hInterfaceRbkInvalid,@TPRBI);
  if MenuHandle=hMenuRbkVisit then ViewInterface(hInterfaceRbkVisit,@TPRBI);
  if MenuHandle=hMenuRbkBranch then ViewInterface(hInterfaceRbkBranch,@TPRBI);

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
  isFreeData: Boolean;
  isFreeRBooks: Boolean;
begin
  hMenuRBooks:=CreateMenuLocal(MENU_ROOT_HANDLE,ConstsMenuRBooks,PChar(ChangeString(ConstsMenuRBooks,'&','')),
                               tcmInsertBefore,_GetMenuHandleFromName(MENU_ROOT_HANDLE,ConstsMenuService));
  ListMenuHandles.Add(Pointer(hMenuRBooks));

  hMenuRbkInvalidCategory:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkInvalidCategory) then
   hMenuRbkInvalidCategory:=CreateMenuLocal(hMenuRBooks,'Категории инвалидов',NameRbkInvalidCategory,tcmAddLast,MENU_INVALID_HANDLE,0,0,MenuClickProc);

  hMenuRbkViewPlace:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkViewPlace) then
   hMenuRbkViewPlace:=CreateMenuLocal(hMenuRBooks,'Места осмотров',NameRbkViewPlace,tcmAddLast,MENU_INVALID_HANDLE,1,0,MenuClickProc);

  hMenuRbkInvalidGroup:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkInvalidGroup) then
   hMenuRbkInvalidGroup:=CreateMenuLocal(hMenuRBooks,'Группы инвалидности',NameRbkInvalidGroup,tcmAddLast,MENU_INVALID_HANDLE,2,0,MenuClickProc);

  hMenuRbkPhysician:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkPhysician) then
   hMenuRbkPhysician:=CreateMenuLocal(hMenuRBooks,'Врачи',NameRbkPhysician,tcmAddLast,MENU_INVALID_HANDLE,3,0,MenuClickProc);

  hMenuRbkBranch:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkBranch) then
   hMenuRbkBranch:=CreateMenuLocal(hMenuRBooks,'Отделения поликлиники',NameRbkBranch,tcmAddLast,MENU_INVALID_HANDLE,0,0,MenuClickProc);


  isFreeRBooks:=(hMenuRBooks<>MENU_INVALID_HANDLE)and
                (hMenuRbkInvalidCategory=MENU_INVALID_HANDLE)and
                (hMenuRbkViewPlace=MENU_INVALID_HANDLE)and
                (hMenuRbkInvalidGroup=MENU_INVALID_HANDLE)and
                (hMenuRbkBranch=MENU_INVALID_HANDLE)and
                (hMenuRbkPhysician=MENU_INVALID_HANDLE);
  if isFreeRBooks then
    if _FreeMenu(hMenuRBooks) then hMenuRBooks:=MENU_INVALID_HANDLE;

  hMenuData:=CreateMenuLocal(MENU_ROOT_HANDLE,'&Данные','Данные',
                               tcmInsertBefore,hMenuRBooks);
  ListMenuHandles.Add(Pointer(hMenuData));

  hMenuRbkInvalid:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkInvalid) then
   hMenuRbkInvalid:=CreateMenuLocal(hMenuData,'Инвалиды',NameRbkInvalid,tcmAddLast,MENU_INVALID_HANDLE,4,0,MenuClickProc);

  hMenuRbkVisit:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkVisit) then
   hMenuRbkVisit:=CreateMenuLocal(hMenuData,'Учет посещений',NameRbkVisit,tcmAddLast,MENU_INVALID_HANDLE,5,0,MenuClickProc);

  isFreeData:=(hMenuData<>MENU_INVALID_HANDLE)and
              (hMenuRbkInvalid=MENU_INVALID_HANDLE)and
              (hMenuRbkVisit=MENU_INVALID_HANDLE);
  if isFreeData then
    if _FreeMenu(hMenuData) then hMenuData:=MENU_INVALID_HANDLE;
    
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
  hInterfaceRbkInvalidCategory:=CreateLocalInterface(NameRbkInvalidCategory,NameRbkInvalidCategory);
  CreateLocalPermission(hInterfaceRbkInvalidCategory,tbInvalidCategory,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkInvalidCategory,tbInvalidCategory,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkInvalidCategory,tbInvalidCategory,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkInvalidCategory,tbInvalidCategory,ttpDelete,false,ttiaDelete);

  hInterfaceRbkViewPlace:=CreateLocalInterface(NameRbkViewPlace,NameRbkViewPlace);
  CreateLocalPermission(hInterfaceRbkViewPlace,tbViewPlace,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkViewPlace,tbViewPlace,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkViewPlace,tbViewPlace,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkViewPlace,tbViewPlace,ttpDelete,false,ttiaDelete);

  hInterfaceRbkInvalidGroup:=CreateLocalInterface(NameRbkInvalidGroup,NameRbkInvalidGroup);
  CreateLocalPermission(hInterfaceRbkInvalidGroup,tbInvalidGroup,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkInvalidGroup,tbInvalidGroup,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkInvalidGroup,tbInvalidGroup,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkInvalidGroup,tbInvalidGroup,ttpDelete,false,ttiaDelete);

  hInterfaceRbkPhysician:=CreateLocalInterface(NameRbkPhysician,NameRbkPhysician);
  CreateLocalPermission(hInterfaceRbkPhysician,tbPhysician,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPhysician,tbPhysician,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkPhysician,tbPhysician,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkPhysician,tbPhysician,ttpDelete,false,ttiaDelete);

  hInterfaceRbkInvalid:=CreateLocalInterface(NameRbkInvalid,NameRbkInvalid);
  CreateLocalPermission(hInterfaceRbkInvalid,tbInvalid,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkInvalid,tbInvalid,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkInvalid,tbInvalid,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkInvalid,tbInvalid,ttpDelete,false,ttiaDelete);

  hInterfaceRbkVisit:=CreateLocalInterface(NameRbkVisit,NameRbkVisit);
  CreateLocalPermission(hInterfaceRbkVisit,tbVisit,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkVisit,tbSick,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkVisit,tbSickGroup,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkVisit,tbInvalidCategory,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkVisit,tbInvalid,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkVisit,tbPhysician,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkVisit,tbViewPlace,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkVisit,tbInvalidGroup,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkVisit,tbBranch,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkVisit,tbVisit,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkVisit,tbVisit,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkVisit,tbVisit,ttpDelete,false,ttiaDelete);

  hInterfaceRbkBranch:=CreateLocalInterface(NameRbkBranch,NameRbkBranch);
  CreateLocalPermission(hInterfaceRbkBranch,tbBranch,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkBranch,tbBranch,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkBranch,tbBranch,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkBranch,tbBranch,ttpDelete,false,ttiaDelete);

end;

function CreateAndViewInvalidCategory(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBInvalidCategory=nil then
       fmRBInvalidCategory:=TfmRBInvalidCategory.Create(Application);
     fmRBInvalidCategory.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBInvalidCategory;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBInvalidCategory.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkInvalidCategory,Param);
  end;
end;

function CreateAndViewViewPlace(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBViewPlace=nil then
       fmRBViewPlace:=TfmRBViewPlace.Create(Application);
     fmRBViewPlace.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBViewPlace;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBViewPlace.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkViewPlace,Param);
  end;
end;

function CreateAndViewInvalidGroup(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBInvalidGroup=nil then
       fmRBInvalidGroup:=TfmRBInvalidGroup.Create(Application);
     fmRBInvalidGroup.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBInvalidGroup;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBInvalidGroup.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkInvalidGroup,Param);
  end;
end;

function CreateAndViewPhysician(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBPhysician=nil then
       fmRBPhysician:=TfmRBPhysician.Create(Application);
     fmRBPhysician.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBPhysician;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBPhysician.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkPhysician,Param);
  end;
end;

function CreateAndViewInvalid(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBInvalid=nil then
       fmRBInvalid:=TfmRBInvalid.Create(Application);
     fmRBInvalid.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBInvalid;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBInvalid.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkInvalid,Param);
  end;
end;

function CreateAndViewVisit(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBVisit=nil then
       fmRBVisit:=TfmRBVisit.Create(Application);
     fmRBVisit.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBVisit;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBVisit.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkVisit,Param);
  end;
end;

function CreateAndViewBranch(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBBranch=nil then
       fmRBBranch:=TfmRBBranch.Create(Application);
     fmRBBranch.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBBranch;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBBranch.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkBranch,Param);
  end;
end;

function ViewInterface(InterfaceHandle: THandle; Param: Pointer): Boolean; stdcall;
begin
  Result:=false;
  if InterfaceHandle=hInterfaceRbkInvalidCategory then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewInvalidCategory(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkViewPlace then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewViewPlace(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkInvalidGroup then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewInvalidGroup(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkPhysician then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewPhysician(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkInvalid then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewInvalid(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkVisit then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewVisit(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkBranch then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewBranch(InterfaceHandle,Param);
  end;
end;

function isPermissionOnInterfaceView(InterfaceHandle: THandle): Boolean;
var
    isRemove: Boolean;
begin
    isRemove:=false;
    if InterfaceHandle=hInterfaceRbkInvalidCategory then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBInvalidCategory)
      else if fmRBInvalidCategory<>nil then begin
       fmRBInvalidCategory.SetInterfaceHandle(InterfaceHandle);
       fmRBInvalidCategory.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkViewPlace then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBViewPlace)
      else if fmRBViewPlace<>nil then begin
       fmRBViewPlace.SetInterfaceHandle(InterfaceHandle);
       fmRBViewPlace.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkInvalidGroup then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBInvalidGroup)
      else if fmRBInvalidGroup<>nil then begin
       fmRBInvalidGroup.SetInterfaceHandle(InterfaceHandle);
       fmRBInvalidGroup.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkPhysician then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBPhysician)
      else if fmRBPhysician<>nil then begin
       fmRBPhysician.SetInterfaceHandle(InterfaceHandle);
       fmRBPhysician.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkInvalid then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBInvalid)
      else if fmRBInvalid<>nil then begin
       fmRBInvalid.SetInterfaceHandle(InterfaceHandle);
       fmRBInvalid.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkVisit then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBVisit)
      else if fmRBVisit<>nil then begin
       fmRBVisit.SetInterfaceHandle(InterfaceHandle);
       fmRBVisit.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkBranch then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBBranch)
      else if fmRBBranch<>nil then begin
       fmRBBranch.SetInterfaceHandle(InterfaceHandle);
       fmRBBranch.ActiveQuery(true);
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
