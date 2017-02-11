unit UStoreTsvCode;

interface

{$I stbasis.inc}

uses Windows, Forms, UStoreTsvData, UMainUnited, Classes, UStoreTsvDm, graphics, dialogs,
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

     URBUnitOfMeasure,URBTypeOfPrice,URBGTD,URBNomenclatureGroup,
     URBNomenclature,
     UStoreTsvOptions;

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

  FreeAndNil(fmRBUnitOfMeasure);
  FreeAndNil(fmRBTypeOfPrice);
  FreeAndNil(fmRBGTD);
  FreeAndNil(fmRBNomenclatureGroup);
  FreeAndNil(fmRBNomenclature);

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
  if ToolButtonHandle=hToolButtonRbkUnitOfMeasure then MenuClickProc(hMenuRbkUnitOfMeasure);
  if ToolButtonHandle=hToolButtonRbkNomenclatureGroup then MenuClickProc(hMenuRbkNomenclatureGroup);
  if ToolButtonHandle=hToolButtonRbkNomenclature then MenuClickProc(hMenuRbkNomenclature);
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
  if (hMenuRbkUnitOfMeasure<>MENU_INVALID_HANDLE)or
     (hMenuRbkNomenclatureGroup<>MENU_INVALID_HANDLE) then begin
   tbar1:=CreateToolBarLocal('Склад','Панель склада',0);
   ListToolBarHandles.Add(Pointer(tbar1));
   if hMenuRbkUnitOfMeasure<>MENU_INVALID_HANDLE then
    hToolButtonRbkUnitOfMeasure:=CreateToolButtonLocal(tbar1,'Единицы измерений',NameRbkUnitOfMeasure,0,ToolButtonClickProc);
   if hMenuRbkNomenclatureGroup<>MENU_INVALID_HANDLE then
    hToolButtonRbkNomenclatureGroup:=CreateToolButtonLocal(tbar1,'Группы номенклатуры',NameRbkNomenclatureGroup,1,ToolButtonClickProc);
   if hMenuRbkNomenclature<>MENU_INVALID_HANDLE then
    hToolButtonRbkNomenclature:=CreateToolButtonLocal(tbar1,'Номенклатура',NameRbkNomenclature,2,ToolButtonClickProc);
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

  if MenuHandle=hMenuRbkUnitOfMeasure then ViewInterface(hInterfaceRbkUnitOfMeasure,@TPRBI);
  if MenuHandle=hMenuRbkTypeOfPrice then ViewInterface(hInterfaceRbkTypeOfPrice,@TPRBI);
  if MenuHandle=hMenuRbkGTD then ViewInterface(hInterfaceRbkGTD,@TPRBI);
  if MenuHandle=hMenuRbkNomenclatureGroup then ViewInterface(hInterfaceRbkNomenclatureGroup,@TPRBI);
  if MenuHandle=hMenuRbkNomenclature then ViewInterface(hInterfaceRbkNomenclature,@TPRBI);
  
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

  hMenuRbkNomenclature:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkNomenclature) then
   hMenuRbkNomenclature:=CreateMenuLocal(hMenuStore,'Номенклатура',NameRbkNomenclature,tcmAddLast,MENU_INVALID_HANDLE,2,0,MenuClickProc);

  hMenuRbkUnitOfMeasure:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkUnitOfMeasure) then
   hMenuRbkUnitOfMeasure:=CreateMenuLocal(hMenuStore,'Единицы измерений',NameRbkUnitOfMeasure,tcmAddLast,MENU_INVALID_HANDLE,0,0,MenuClickProc);

  hMenuRbkTypeOfPrice:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkTypeOfPrice) then
   hMenuRbkTypeOfPrice:=CreateMenuLocal(hMenuStore,'Типы цен',NameRbkTypeOfPrice,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuRbkGTD:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkGTD) then
   hMenuRbkGTD:=CreateMenuLocal(hMenuStore,'ГТД',NameRbkGTD,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuRbkNomenclatureGroup:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkNomenclatureGroup) then
   hMenuRbkNomenclatureGroup:=CreateMenuLocal(hMenuStore,'Группы номенклатуры',NameRbkNomenclatureGroup,tcmAddLast,MENU_INVALID_HANDLE,1,0,MenuClickProc);


  isFreeStore:=(hMenuStore<>MENU_INVALID_HANDLE)and
               (hMenuRbkNomenclature<>MENU_INVALID_HANDLE)and
               (hMenuRbkUnitOfMeasure=MENU_INVALID_HANDLE)and
               (hMenuRbkTypeOfPrice=MENU_INVALID_HANDLE)and
               (hMenuRbkGTD=MENU_INVALID_HANDLE)and
               (hMenuRbkNomenclatureGroup=MENU_INVALID_HANDLE);
               
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
  hInterfaceRbkUnitOfMeasure:=CreateLocalInterface(NameRbkUnitOfMeasure,NameRbkUnitOfMeasure);
  CreateLocalPermission(hInterfaceRbkUnitOfMeasure,tbUnitOfMeasure,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkUnitOfMeasure,tbUnitOfMeasure,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkUnitOfMeasure,tbUnitOfMeasure,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkUnitOfMeasure,tbUnitOfMeasure,ttpDelete,false,ttiaDelete);

  hInterfaceRbkTypeOfPrice:=CreateLocalInterface(NameRbkTypeOfPrice,NameRbkTypeOfPrice);
  CreateLocalPermission(hInterfaceRbkTypeOfPrice,tbTypeOfPrice,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkTypeOfPrice,tbTypeOfPrice,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkTypeOfPrice,tbTypeOfPrice,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkTypeOfPrice,tbTypeOfPrice,ttpDelete,false,ttiaDelete);

  hInterfaceRbkGTD:=CreateLocalInterface(NameRbkGTD,NameRbkGTD);
  CreateLocalPermission(hInterfaceRbkGTD,tbGTD,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkGTD,tbGTD,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkGTD,tbGTD,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkGTD,tbGTD,ttpDelete,false,ttiaDelete);

  hInterfaceRbkNomenclatureGroup:=CreateLocalInterface(NameRbkNomenclatureGroup,NameRbkNomenclatureGroup);
  CreateLocalPermission(hInterfaceRbkNomenclatureGroup,tbNomenclatureGroup,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkNomenclatureGroup,tbNomenclatureGroup,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkNomenclatureGroup,tbNomenclatureGroup,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkNomenclatureGroup,tbNomenclatureGroup,ttpDelete,false,ttiaDelete);

  hInterfaceRbkNomenclature:=CreateLocalInterface(NameRbkNomenclature,NameRbkNomenclature);
  CreateLocalPermission(hInterfaceRbkNomenclature,tbNomenclature,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkNomenclature,tbNomenclatureGroup,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkNomenclature,tbGTD,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkNomenclature,tbCountry,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkNomenclature,tbNomenclature,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkNomenclature,tbNomenclature,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkNomenclature,tbNomenclature,ttpDelete,false,ttiaDelete);

  hInterfaceRbkNomenclatureProperties:=CreateLocalInterface(NameRbkNomenclatureProperties,NameRbkNomenclatureProperties);
  CreateLocalPermission(hInterfaceRbkNomenclatureProperties,tbNomenclatureValueProperties,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkNomenclatureProperties,tbNomenclature,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkNomenclatureProperties,tbValueProperties,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkNomenclatureProperties,tbProperties,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkNomenclatureProperties,tbNomenclatureValueProperties,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkNomenclatureProperties,tbNomenclatureValueProperties,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkNomenclatureProperties,tbNomenclatureValueProperties,ttpDelete,false,ttiaDelete);

  hInterfaceRbkNomenclatureUnitOfMeasure:=CreateLocalInterface(NameRbkNomenclatureUnitOfMeasure,NameRbkNomenclatureUnitOfMeasure);
  CreateLocalPermission(hInterfaceRbkNomenclatureUnitOfMeasure,tbNomenclatureUnitOfMeasure,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkNomenclatureUnitOfMeasure,tbNomenclature,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkNomenclatureUnitOfMeasure,tbUnitOfMeasure,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkNomenclatureUnitOfMeasure,tbNomenclatureUnitOfMeasure,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkNomenclatureUnitOfMeasure,tbNomenclatureUnitOfMeasure,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkNomenclatureUnitOfMeasure,tbNomenclatureUnitOfMeasure,ttpDelete,false,ttiaDelete);

  hInterfaceRbkNomenclatureTypeOfPrice:=CreateLocalInterface(NameRbkNomenclatureTypeOfPrice,NameRbkNomenclatureTypeOfPrice);
  CreateLocalPermission(hInterfaceRbkNomenclatureTypeOfPrice,tbNomenclatureTypeOfPrice,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkNomenclatureTypeOfPrice,tbNomenclature,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkNomenclatureTypeOfPrice,tbTypeOfPrice,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkNomenclatureTypeOfPrice,tbUnitOfMeasure,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkNomenclatureTypeOfPrice,tbCurrency,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkNomenclatureTypeOfPrice,tbNomenclatureTypeOfPrice,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkNomenclatureTypeOfPrice,tbNomenclatureTypeOfPrice,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkNomenclatureTypeOfPrice,tbNomenclatureTypeOfPrice,ttpDelete,false,ttiaDelete);

end;

function CreateAndViewUnitOfMeasure(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBUnitOfMeasure=nil then
       fmRBUnitOfMeasure:=TfmRBUnitOfMeasure.Create(Application);
     fmRBUnitOfMeasure.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBUnitOfMeasure;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBUnitOfMeasure.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkUnitOfMeasure,Param);
  end;
end;

function CreateAndViewTypeOfPrice(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBTypeOfPrice=nil then
       fmRBTypeOfPrice:=TfmRBTypeOfPrice.Create(Application);
     fmRBTypeOfPrice.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBTypeOfPrice;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBTypeOfPrice.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkTypeOfPrice,Param);
  end;
end;

function CreateAndViewGTD(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBGTD=nil then
       fmRBGTD:=TfmRBGTD.Create(Application);
     fmRBGTD.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBGTD;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBGTD.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkGTD,Param);
  end;
end;

function CreateAndViewNomenclatureGroup(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBNomenclatureGroup=nil then
       fmRBNomenclatureGroup:=TfmRBNomenclatureGroup.Create(Application);
     fmRBNomenclatureGroup.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBNomenclatureGroup;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBNomenclatureGroup.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkNomenclatureGroup,Param);
  end;
end;

function CreateAndViewNomenclature(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBNomenclature=nil then
       fmRBNomenclature:=TfmRBNomenclature.Create(Application);
     fmRBNomenclature.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBNomenclature;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBNomenclature.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkNomenclature,Param);
  end;
end;


function ViewInterface(InterfaceHandle: THandle; Param: Pointer): Boolean; stdcall;
begin
  Result:=false;
  if InterfaceHandle=hInterfaceRbkUnitOfMeasure then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewUnitOfMeasure(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkTypeOfPrice then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewTypeOfPrice(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkGTD then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewGTD(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkNomenclatureGroup then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewNomenclatureGroup(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkNomenclature then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewNomenclature(InterfaceHandle,Param);
  end;
end;

function isPermissionOnInterfaceView(InterfaceHandle: THandle): Boolean;
var
    isRemove: Boolean;
begin
    isRemove:=false;
    if InterfaceHandle=hInterfaceRbkUnitOfMeasure then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBUnitOfMeasure)
      else if fmRBUnitOfMeasure<>nil then begin
       fmRBUnitOfMeasure.SetInterfaceHandle(InterfaceHandle);
       fmRBUnitOfMeasure.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkTypeOfPrice then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBTypeOfPrice)
      else if fmRBTypeOfPrice<>nil then begin
       fmRBTypeOfPrice.SetInterfaceHandle(InterfaceHandle);
       fmRBTypeOfPrice.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkGTD then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBGTD)
      else if fmRBGTD<>nil then begin
       fmRBGTD.SetInterfaceHandle(InterfaceHandle);
       fmRBGTD.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkNomenclatureGroup then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBNomenclatureGroup)
      else if fmRBNomenclatureGroup<>nil then begin
       fmRBNomenclatureGroup.SetInterfaceHandle(InterfaceHandle);
       fmRBNomenclatureGroup.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkNomenclature then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBNomenclature)
      else if fmRBNomenclature<>nil then begin
       fmRBNomenclature.SetInterfaceHandle(InterfaceHandle);
       fmRBNomenclature.TreeView.DataSource:=nil;
       fmRBNomenclature.ActiveQueryTreeView;
       fmRBNomenclature.ActiveQuery(true);
       fmRBNomenclature.ActiveQueryDetail(true);
       fmRBNomenclature.TreeView.DataSource:=fmRBNomenclature.dsGroup;
       fmRBNomenclature.TreeView.FullCollapse;
       fmRBNomenclature.LocateToFirstNode;
       SetImageToTreeNodesByTreeView(fmRBNomenclature.TreeView);
       fmRBNomenclature.TreeView.Invalidate;
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
