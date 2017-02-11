unit UTestTsvCode;

interface

{$I stbasis.inc}

uses Windows, Forms, UTestTsvData, UMainUnited, Classes, UTestTsvDm, graphics, dialogs,
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


implementation

uses ActiveX,Menus,tsvDbGrid,dbtree,
     URBCurrency, URBRateCurrency,
     URptEmpUniversal;

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
  
  FreeAndNil(fmRBCurrency);
  FreeAndNil(fmRBRateCurrency);

  FreeAndNil(fmRptEmpUniversal);

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

  if MenuHandle=hMenuRBooksCurrency then ViewInterface(hInterfaceRbkCurrency,@TPRBI);
  if MenuHandle=hMenuRBooksRateCurrency then ViewInterface(hInterfaceRbkRateCurrency,@TPRBI);

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
  isFreeMenuRBooksFinances: Boolean;
  isFreeMenuRptsStaff: Boolean;
  isFreeMenuRBooks: Boolean;
  isFreeMenuRpts: Boolean;

begin
  ListMenuHandles.Clear;

  hMenuRBooks:=CreateMenuLocal(MENU_ROOT_HANDLE,ConstsMenuRBooks,PChar(ChangeString(ConstsMenuRBooks,'&','')),
                               tcmInsertBefore,_GetMenuHandleFromName(MENU_ROOT_HANDLE,ConstsMenuService));
  ListMenuHandles.Add(Pointer(hMenuRBooks));
  hMenuRBooksFinances:=CreateMenuLocal(hMenuRBooks,ConstsMenuFinances,ConstsMenuFinances,tcmAddFirst);
  hMenuRBooksCurrency:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkCurrency) then
   hMenuRBooksCurrency:=CreateMenuLocal(hMenuRBooksFinances,'Валюты',NameRbkCurrency,tcmAddLast,MENU_INVALID_HANDLE,0,0,MenuClickProc);
  hMenuRBooksRateCurrency:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkRateCurrency) then
   hMenuRBooksRateCurrency:=CreateMenuLocal(hMenuRBooksFinances,'Курсы валют',NameRbkRateCurrency,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuRpts:=CreateMenuLocal(MENU_ROOT_HANDLE,ConstsMenuReports,PChar(ChangeString(ConstsMenuReports,'&','')),
                               tcmInsertBefore,_GetMenuHandleFromName(MENU_ROOT_HANDLE,ConstsMenuService));
  ListMenuHandles.Add(Pointer(hMenuRpts));
  hMenuRptsStaff:=CreateMenuLocal(hMenuRpts,ConstsMenuRptStaff,ConstsMenuRptStaff,tcmAddFirst);
  hMenuRptsEmpUniversal:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRptEmpUniversal) then
   hMenuRptsEmpUniversal:=CreateMenuLocal(hMenuRptsStaff,'Сотрудники',NameRptEmpUniversal,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  isFreeMenuRBooksFinances:=(hMenuRBooksFinances<>MENU_INVALID_HANDLE)and
                            (hMenuRBooksCurrency=MENU_INVALID_HANDLE)and
                            (hMenuRBooksRateCurrency=MENU_INVALID_HANDLE);
  if isFreeMenuRBooksFinances then
    if _FreeMenu(hMenuRBooksFinances) then hMenuRBooksFinances:=MENU_INVALID_HANDLE;

  isFreeMenuRptsStaff:=(hMenuRptsStaff<>MENU_INVALID_HANDLE)and
                       (hMenuRptsEmpUniversal=MENU_INVALID_HANDLE);
  if isFreeMenuRptsStaff then
    if _FreeMenu(hMenuRptsStaff) then hMenuRptsStaff:=MENU_INVALID_HANDLE;


  isFreeMenuRBooks:=(hMenuRBooks<>MENU_INVALID_HANDLE)and
                    (hMenuRBooksFinances=MENU_INVALID_HANDLE);
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

  hInterfaceRptEmpUniversal:=CreateLocalInterface(NameRptEmpUniversal,NameRptEmpUniversal,ttiReport);
  CreateLocalPermission(hInterfaceRptEmpUniversal,tbEmp,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptEmpUniversal,tbFamilystate,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptEmpUniversal,tbNation,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptEmpUniversal,tbTown,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptEmpUniversal,tbSex,ttpSelect,false);

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

  if InterfaceHandle=hInterfaceRbkCurrency then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewCurrency(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkRateCurrency then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewRateCurrency(InterfaceHandle,Param);
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
