unit USalaryTsvCode;

interface

{$I stbasis.inc}

uses Windows, Forms, USalaryTsvData, UMainUnited, Classes, USalaryTsvDm, graphics, dialogs,
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

implementation

uses ActiveX,Menus,tsvDbGrid,dbtree,

     URBAlgorithm,URBCharge,URBChargeTree,URBTypeBordereau,

     USalaryTsvOptions,

     URptAccountSheets, URptBordereau;

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

  isInitAll:=true;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure DeInitAll;
begin
 try
  if not isInitAll then exit;

  FreeAndNil(fmRBAlgorithm);
  FreeAndNil(fmRBCharge);
  FreeAndNil(fmRBChargeTree);
  FreeAndNil(fmRBTypeBordereau);

  FreeAndNil(fmRptAccountSheets);
  FreeAndNil(fmRptBordereau);

  FreeAndNil(fmOptions);

  ClearListMenuHandles;
  ListMenuHandles.free;

  ClearListInterfaceHandles;
  ListInterfaceHandles.Free;

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

  if MenuHandle=hMenuAlgorithm then ViewInterface(hInterfaceRbkAlgorithm,@TPRBI);
  if MenuHandle=hMenuCharge then ViewInterface(hInterfaceRbkCharge,@TPRBI);
  if MenuHandle=hMenuChargeTree then ViewInterface(hInterfaceRbkChargeTree,@TPRBI);
  if MenuHandle=hMenuTypeBordereau then ViewInterface(hInterfaceRbkTypeBordereau,@TPRBI);

  if MenuHandle=hMenuBordereau then ViewInterface(hInterfaceRptBordereau,@TPRI);
  if MenuHandle=hMenuRptAccountSheets then ViewInterface(hInterfaceRptAccountSheets,@TPRI);
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
  isFreeSalary: Boolean;
  isFreeRptSalary: Boolean;
  isFreeRBooks: Boolean;
  isFreeReports: Boolean;
begin
  ListMenuHandles.Clear;
  hMenuRBooks:=CreateMenuLocal(MENU_ROOT_HANDLE,ConstsMenuRBooks,PChar(ChangeString(ConstsMenuRBooks,'&','')),
                               tcmInsertBefore,_GetMenuHandleFromName(MENU_ROOT_HANDLE,ConstsMenuService));
  ListMenuHandles.Add(Pointer(hMenuRBooks));

  hMenuSalary:=CreateMenuLocal(hMenuRBooks,ConstsMenuSalary,ConstsMenuSalary,tcmAddFirst);

  hMenuAlgorithm:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkAlgorithm) then
   hMenuAlgorithm:=CreateMenuLocal(hMenuSalary,'Алгоритмы',NameRbkAlgorithm,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuCharge:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkCharge) then
   hMenuCharge:=CreateMenuLocal(hMenuSalary,'Начисления и удержания',NameRbkCharge,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuChargeTree:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkChargeTree) then
   hMenuChargeTree:=CreateMenuLocal(hMenuSalary,'Зависимости начислений',NameRbkChargeTree,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuTypeBordereau:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkTypeBordereau) then
   hMenuTypeBordereau:=CreateMenuLocal(hMenuSalary,'Виды ведомостей',NameRbkTypeBordereau,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuReports:=CreateMenuLocal(MENU_ROOT_HANDLE,ConstsMenuReports,PChar(ChangeString(ConstsMenuReports,'&','')),
                               tcmInsertBefore,_GetMenuHandleFromName(MENU_ROOT_HANDLE,ConstsMenuService));
  ListMenuHandles.Add(Pointer(hMenuReports));

  hMenuRptSalary:=CreateMenuLocal(hMenuReports,ConstsMenuSalary,ConstsMenuSalary,tcmAddFirst);

  hMenuBordereau:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRptBordereau) then
   hMenuBordereau:=CreateMenuLocal(hMenuRptSalary,'Ведомости',NameRptBordereau,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuRptAccountSheets:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRptAccountSheets) then
   hMenuRptAccountSheets:=CreateMenuLocal(hMenuRptSalary,'Расчетные листы',NameRptAccountSheets,tcmAddLast,MENU_INVALID_HANDLE,1,0,MenuClickProc);

  isFreeSalary:=(hMenuSalary<>MENU_INVALID_HANDLE)and
                (hMenuAlgorithm=MENU_INVALID_HANDLE)and
                (hMenuCharge=MENU_INVALID_HANDLE)and
                (hMenuChargeTree=MENU_INVALID_HANDLE)and
                (hMenuTypeBordereau=MENU_INVALID_HANDLE);
  if isFreeSalary then
    if _FreeMenu(hMenuSalary) then hMenuSalary:=MENU_INVALID_HANDLE;

  isFreeRptSalary:=(hMenuRptSalary<>MENU_INVALID_HANDLE)and
                   (hMenuBordereau=MENU_INVALID_HANDLE)and
                   (hMenuRptAccountSheets=MENU_INVALID_HANDLE);
  if isFreeRptSalary then
    if _FreeMenu(hMenuRptSalary) then hMenuRptSalary:=MENU_INVALID_HANDLE;

  isFreeRBooks:=(hMenuRBooks<>MENU_INVALID_HANDLE)and
                (hMenuSalary=MENU_INVALID_HANDLE);
  if isFreeRBooks then
    if _FreeMenu(hMenuRBooks) then hMenuRBooks:=MENU_INVALID_HANDLE;

  isFreeReports:=(hMenuReports<>MENU_INVALID_HANDLE)and
                 (hMenuRptSalary=MENU_INVALID_HANDLE);
  if isFreeReports then
    if _FreeMenu(hMenuReports) then hMenuReports:=MENU_INVALID_HANDLE;
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
  hInterfaceRbkAlgorithm:=CreateLocalInterface(NameRbkAlgorithm,NameRbkAlgorithm);
  CreateLocalPermission(hInterfaceRbkAlgorithm,tbAlgorithm,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkAlgorithm,tbAbsence,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkAlgorithm,tbExperiencepercent,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkAlgorithm,tbAlgorithm,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkAlgorithm,tbAlgorithm,ttpUpdate,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkAlgorithm,tbAlgorithm,ttpDelete,false,ttiaDelete);

  hInterfaceRbkCharge:=CreateLocalInterface(NameRbkCharge,NameRbkCharge);
  CreateLocalPermission(hInterfaceRbkCharge,tbCharge,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkCharge,tbStandartoperation,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkCharge,tbChargeGroup,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkCharge,tbRoundType,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkCharge,tbAlgorithm,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkCharge,tbCharge,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkCharge,tbCharge,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkCharge,tbCharge,ttpDelete,false,ttiaDelete);

  hInterfaceRbkChargeTree:=CreateLocalInterface(NameRbkChargeTree,NameRbkChargeTree);
  CreateLocalPermission(hInterfaceRbkChargeTree,tbChargeTree,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkChargeTree,tbCharge,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkChargeTree,tbChargeTree,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkChargeTree,tbChargeTree,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkChargeTree,tbChargeTree,ttpDelete,false,ttiaDelete);

  hInterfaceRbkTypeBordereau:=CreateLocalInterface(NameRbkTypeBordereau,NameRbkTypeBordereau);
  CreateLocalPermission(hInterfaceRbkTypeBordereau,tbTypeBordereau,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkTypeBordereau,tbCharge,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkTypeBordereau,tbTypeBordereauCalcPeriod,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkTypeBordereau,tbTypeBordereau,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkTypeBordereau,tbTypeBordereauCalcPeriod,ttpUpdate,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkTypeBordereau,tbTypeBordereauCalcPeriod,ttpUpdate,false,ttiaDelete);
  CreateLocalPermission(hInterfaceRbkTypeBordereau,tbTypeBordereau,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkTypeBordereau,tbTypeBordereauCalcPeriod,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkTypeBordereau,tbTypeBordereau,ttpDelete,false,ttiaDelete);
  CreateLocalPermission(hInterfaceRbkTypeBordereau,tbTypeBordereauCalcPeriod,ttpDelete,false,ttiaDelete);

  hInterfaceRptBordereau:=CreateLocalInterface(NameRptBordereau,NameRptBordereau,ttiReport);
  CreateLocalPermission(hInterfaceRptBordereau,tbBordereau,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptBordereau,tbCalcPeriod,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptBordereau,tbEmpPlant,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptBordereau,tbTypeBordereau,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptBordereau,tbTypeBordereauCalcPeriod,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptBordereau,tbEmp,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptBordereau,tbSalary,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptBordereau,tbDepart,ttpSelect,false);

  hInterfaceRptAccountSheets:=CreateLocalInterface(NameRptAccountSheets,NameRptAccountSheets,ttiReport);
  CreateLocalPermission(hInterfaceRptAccountSheets,tbSalary,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptAccountSheets,tbCalcPeriod,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptAccountSheets,tbEmpPlant,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptAccountSheets,tbEmp,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptAccountSheets,tbDepart,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptAccountSheets,tbFactPay,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptAccountSheets,tbCharge,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptAccountSheets,tbEmpPlantSchedule,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptAccountSheets,tbNormalTime,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptAccountSheets,tbSalary,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptAccountSheets,tbActualTime,ttpSelect,false);

end;

function CreateAndViewAlgorithm(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBAlgorithm=nil then
       fmRBAlgorithm:=TfmRBAlgorithm.Create(Application);
     fmRBAlgorithm.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBAlgorithm;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBAlgorithm.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkAlgorithm,Param);
  end;
end;

function CreateAndViewCharge(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBCharge=nil then
       fmRBCharge:=TfmRBCharge.Create(Application);
     fmRBCharge.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBCharge;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBCharge.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkCharge,Param);
  end;
end;

function CreateAndViewChargeTree(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBChargeTree=nil then
       fmRBChargeTree:=TfmRBChargeTree.Create(Application);
     fmRBChargeTree.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBChargeTree;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBChargeTree.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkChargeTree,Param);
  end;
end;

function CreateAndViewTypeBordereau(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBTypeBordereau=nil then
       fmRBTypeBordereau:=TfmRBTypeBordereau.Create(Application);
     fmRBTypeBordereau.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBTypeBordereau;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBTypeBordereau.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkTypeBordereau,Param);
  end;
end;

function CreateAndViewRptBordereau(InterfaceHandle: THandle; Param: PParamReportInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRptBordereau=nil then
       fmRptBordereau:=TfmRptBordereau.Create(Application);
     fmRptBordereau.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=CreateAndViewAsMDIChild;
end;

function CreateAndViewRptAccountSheets(InterfaceHandle: THandle; Param: PParamReportInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRptAccountSheets=nil then
       fmRptAccountSheets:=TfmRptAccountSheets.Create(Application);
     fmRptAccountSheets.InitMdiChildParams(InterfaceHandle,Param);
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
  if InterfaceHandle=hInterfaceRbkAlgorithm then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewAlgorithm(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkCharge then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewCharge(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkChargeTree then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewChargeTree(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkTypeBordereau then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewTypeBordereau(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRptBordereau then begin
    if not isValidPointer(Param,SizeOf(TParamReportInterface)) then exit;
    Result:=CreateAndViewRptBordereau(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRptAccountSheets then begin
    if not isValidPointer(Param,SizeOf(TParamReportInterface)) then exit;
    Result:=CreateAndViewRptAccountSheets(InterfaceHandle,Param);
  end;
end;

function isPermissionOnInterfaceView(InterfaceHandle: THandle): Boolean;
var
    isRemove: Boolean;
begin
    isRemove:=false;
    if InterfaceHandle=hInterfaceRbkAlgorithm then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBAlgorithm)
      else if fmRBAlgorithm<>nil then begin
       fmRBAlgorithm.SetInterfaceHandle(InterfaceHandle);
       fmRBAlgorithm.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkCharge then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBCharge)
      else if fmRBCharge<>nil then begin
       fmRBCharge.SetInterfaceHandle(InterfaceHandle);
       fmRBCharge.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkChargeTree then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBChargeTree)
      else if fmRBChargeTree<>nil then begin
       fmRBChargeTree.SetInterfaceHandle(InterfaceHandle);
       fmRBChargeTree.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkTypeBordereau then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBTypeBordereau)
      else if fmRBTypeBordereau<>nil then begin
       fmRBTypeBordereau.SetInterfaceHandle(InterfaceHandle);
       fmRBTypeBordereau.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRptBordereau then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRptBordereau)
      else if fmRptBordereau<>nil then begin
       fmRptBordereau.SetInterfaceHandle(InterfaceHandle);
      end;
    end;
    if InterfaceHandle=hInterfaceRptAccountSheets then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRptAccountSheets)
      else if fmRptAccountSheets<>nil then begin
       fmRptAccountSheets.SetInterfaceHandle(InterfaceHandle);
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

    FreeAndNil(fmOptions);
    fmOptions:=TfmOptions.Create(nil);
    fmOptions.ParentWindow:=Application.Handle;
    
  finally
    Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end; 
end;

//**************** end of Export *************************

end.
