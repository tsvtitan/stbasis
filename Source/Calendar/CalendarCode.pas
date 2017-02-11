unit CalendarCode;

{$I stbasis.inc}

interface

uses Windows, Forms, Graphics, UMainUnited, Classes, IBDatabase, IBQuery, IBServices;

procedure DeInitAll;

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

type
  TCalendarAction=(caCalendarEdit,caCalendarSelect,caHolidaySelect,caCarrySelect);
  TActualTimeAction=(aaActualTimeEdit);
  TRoundTypeAction=(rtRoundTypeEdit,rtRoundTypeSelect);
  TChargeGroupAction=(cgChargeGroupEdit,cgChargeGroupSelect);

implementation

uses SysUtils, Controls, CalendarData, CalendarEdit,
     CalendarView, ActualTime, ChargeGroup, RoundType, stCalendarUtil, tsvHint;

procedure GetInfoLibrary_(P: PInfoLibrary);stdcall;
begin
  if P=nil then exit;
  P.Hint:='Содержит следующие справочники:'+#13+
          'календари, праздники, переносы выходных,'+#13+
          'фактические отработки,'+#13+
          'виды округлений, группы начислений';
  P.TypeLib:=ttleDefault;
end;

function CreateAndViewCalendar(InterfaceHandle: THandle; Params: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    Result:=false;
    try
     if frmCalendar=nil then
      frmCalendar:=TfrmCalendar.Create(Application,InterfaceHandle,caCalendarEdit,Params);
     frmCalendar.BringToFront;
     frmCalendar.Show;
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfrmCalendar;
   begin
    Result:=false;
    try
     fm:=nil;
     try
      fm:=TfrmCalendar.Create(Application,InterfaceHandle,caCalendarSelect,Params);
      Result:=fm.ShowModal=mrOK;
     finally
      fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Params.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(dbSTBasis,'select * from calendar ',Params);
  end;
end;

function CreateAndViewCalendarView(InterfaceHandle: THandle; Params: PParamServiceInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    Result:=false;
    try
     if frmCalendarView=nil then
      frmCalendarView:=TfrmCalendarView.Create(Application,InterfaceHandle,Params);
     frmCalendarView.BringToFront;
     frmCalendarView.Show;
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
 Result:=CreateAndViewAsMDIChild;
end;

function CreateAndViewActualTime(InterfaceHandle: THandle; Params: PParamServiceInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    Result:=false;
    try
     if frmActualTime=nil then
      frmActualTime:=TfrmActualTime.Create(Application,InterfaceHandle,aaActualTimeEdit,Params);
     frmActualTime.BringToFront;
     frmActualTime.Show;
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
 Result:=CreateAndViewAsMDIChild;
end;

function CreateAndViewChargeGroup(InterfaceHandle: THandle; Params: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    Result:=false;
    try
     if frmChargeGroup=nil then
      frmChargeGroup:=TfrmChargeGroup.Create(Application,InterfaceHandle,cgChargeGroupEdit,Params);
     frmChargeGroup.BringToFront;
     frmChargeGroup.Show;
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfrmChargeGroup;
   begin
    Result:=false;
    try
     fm:=nil;
     try
      fm:=TfrmChargeGroup.Create(Application,InterfaceHandle,cgChargeGroupSelect,Params);
      Result:=fm.ShowModal=mrOK;
     finally
      fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Params.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(dbSTBasis,'select * from chargegroup ',Params);
  end;
end;

function CreateAndViewRoundType(InterfaceHandle: THandle; Params: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    Result:=false;
    try
     if frmRoundType=nil then
      frmRoundType:=TfrmRoundType.Create(Application,InterfaceHandle,rtRoundTypeEdit,Params);
     frmRoundType.BringToFront;
     frmRoundType.Show;
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfrmRoundType;
   begin
    Result:=false;
    try
     fm:=nil;
     try
      fm:=TfrmRoundType.Create(Application,InterfaceHandle,rtRoundTypeSelect,Params);
      Result:=fm.ShowModal=mrOK;
     finally
      fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Params.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(dbSTBasis,'select * from roundtype ',Params);
  end;
end;

{
begin
   tte_rbksHoliday:frmModalCalendar:=TfrmCalendar.Create(Application,TypeEntry,caHolidaySelect,Params);
   tte_rbksCarry:frmModalCalendar:=TfrmCalendar.Create(Application,TypeEntry,caCarrySelect,Params);
end;}

procedure SetConnection_(IBDbase: TIBDatabase; IBTran: TIBTransaction;
                         IBDBSecurity: TIBDatabase; IBTSecurity: TIBTransaction);stdcall;
begin
 dbSTBasis:=IBDbase;
 trDefault:=IBTran;
 ChangeDataBase(dmCalendar,dbSTBasis);
 InitCalendarUtil(IBDbase);
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

procedure ClearListInterfaceHandles;
var
  i: Integer;
begin
  for i:=0 to ListInterfaceHandles.Count-1 do begin
    _FreeInterface(THandle(ListInterfaceHandles.Items[i]));
  end;
  ListInterfaceHandles.Clear;
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

function ViewInterface(InterfaceHandle: THandle; Param: Pointer): Boolean; stdcall;
begin
  Result:=false;

  if InterfaceHandle=hInterfaceRbkCalendar then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewCalendar(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkCalendarView then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewCalendarView(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkActualTime then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewActualTime(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkChargeGroup then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewChargeGroup(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkRoundType then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewRoundType(InterfaceHandle,Param);
  end;
end;

procedure MenuClickProc(MenuHandle: THandle);stdcall;
var
  TPRBI: TParamRBookInterface;
//  TPRI: TParamReportInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
//  FillChar(TPRI,SizeOf(TPRI),0);
  if MenuHandle=hMenuRBooksCalendar then ViewInterface(hInterfaceRbkCalendar,@TPRBI);
  if MenuHandle=hMenuRBooksCalendarView then ViewInterface(hInterfaceRbkCalendarView,@TPRBI);
  if MenuHandle=hMenuRBooksActualTime then ViewInterface(hInterfaceRbkActualTime,@TPRBI);
  if MenuHandle=hMenuRBooksChargeGroup then ViewInterface(hInterfaceRbkChargeGroup,@TPRBI);
  if MenuHandle=hMenuRBooksRoundType then ViewInterface(hInterfaceRbkRoundType,@TPRBI);
end;

procedure ToolButtonClickProc(ToolButtonHandle: THandle);stdcall;
begin
 if ToolButtonHandle=hToolButtonCalendar then MenuClickProc(hMenuRBooksCalendar);
 if ToolButtonHandle=hToolButtonCalendarView then MenuClickProc(hMenuRBooksCalendarView);
 if ToolButtonHandle=hToolButtonActualTime then MenuClickProc(hMenuRBooksActualTime);
 if ToolButtonHandle=hToolButtonChargeGroup then MenuClickProc(hMenuRBooksChargeGroup);
 if ToolButtonHandle=hToolButtonRoundType then MenuClickProc(hMenuRBooksRoundType);
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
     dmCalendar.ilCalendar.GetBitmap(ImageIndex,Image);
     CMLocal.Bitmap:=Image;
    end;
    Result:=_CreateMenu(ParentHandle,@CMLocal);
   finally
     Image.Free;
   end;
  end;

begin
  ListMenuHandles.Clear;

  hMenuRBooks:=CreateMenuLocal(MENU_ROOT_HANDLE,ConstsMenuRBooks,PChar(ChangeString(ConstsMenuRBooks,'&','')),
                               tcmInsertBefore,_GetMenuHandleFromName(MENU_ROOT_HANDLE,ConstsMenuService));
  ListMenuHandles.Add(Pointer(hMenuRBooks));

  hMenuService:=CreateMenuLocal(MENU_ROOT_HANDLE,ConstsMenuOperations,PChar(ChangeString(ConstsMenuOperations,'&','')),
                                tcmInsertBefore,_GetMenuHandleFromName(MENU_ROOT_HANDLE,ConstsMenuService));
  ListMenuHandles.Add(Pointer(hMenuService));

  hMenuRBooksCalendar:=MENU_INVALID_HANDLE;
  if _isPermissionOnInterface(hInterfaceRbkCalendar,ttiaView) then
  begin
   hMenuRBooksCalendar:=CreateMenuLocal(hMenuRBooks,MenuItemCaptionCalendarEdit,MenuItemHintCalendarEdit,tcmAddLast,MENU_INVALID_HANDLE,0,0,MenuClickProc);
   if frmCalendar<>nil then
    frmCalendar.DoRefresh;
  end
  else FreeAndNil(frmCalendar);

  hMenuRBooksCalendarView:=MENU_INVALID_HANDLE;
  if _isPermissionOnInterface(hInterfaceRbkCalendarView,ttiaView) then
  begin
   hMenuRBooksCalendarView:=CreateMenuLocal(hMenuService,MenuItemCaptionCalendarView,MenuItemHintCalendarView,tcmAddLast,MENU_INVALID_HANDLE,0,0,MenuClickProc);
   if frmCalendarView<>nil then
    frmCalendarView.UpdateView;
  end
  else FreeAndNil(frmCalendarView);

  if _isPermissionOnInterface(hInterfaceRbkActualTime,ttiaView) then
  begin
   hMenuRBooksActualTime:=CreateMenuLocal(hMenuRBooks,MenuItemCaptionActualTime,MenuItemHintActualTime,tcmAddLast,MENU_INVALID_HANDLE,1,0,MenuClickProc);
   if frmActualTime<>nil then
    frmActualTime.DoRefresh;
  end
  else FreeAndNil(frmActualTime);

  if _isPermissionOnInterface(hInterfaceRbkChargeGroup,ttiaView) then
  begin
   hMenuRBooksChargeGroup:=CreateMenuLocal(hMenuRBooks,MenuItemCaptionChargeGroup,MenuItemHintChargeGroup,tcmAddLast,MENU_INVALID_HANDLE,2,0,MenuClickProc);
   if frmChargeGroup<>nil then
    frmChargeGroup.DoRefresh;
  end
  else FreeAndNil(frmChargeGroup);

  if _isPermissionOnInterface(hInterfaceRbkRoundType,ttiaView) then
  begin
   hMenuRBooksRoundType:=CreateMenuLocal(hMenuRBooks,MenuItemCaptionRoundType,MenuItemHintRoundType,tcmAddLast,MENU_INVALID_HANDLE,3,0,MenuClickProc);
   if frmRoundType<>nil then
    frmRoundType.DoRefresh;
  end
  else FreeAndNil(frmRoundType);
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

  hInterfaceRbkCalendar:=CreateLocalInterface(IntNameCalendar,IntHintCalendar);
  hInterfaceRbkCalendarView:=CreateLocalInterface(IntNameCalendarView,IntHintCalendarView);
{  CreateLocalPermission(hInterfaceRbkRelease,tbRelease,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkRelease,tbRelease,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkRelease,tbRelease,ttpInsert,false,ttiaAdd);}
  hInterfaceRbkActualTime:=CreateLocalInterface(IntNameActualTime,IntHintActualTime);
  hInterfaceRbkChargeGroup:=CreateLocalInterface(IntNameChargeGroup,IntHintChargeGroup);
  hInterfaceRbkRoundType:=CreateLocalInterface(IntNameRoundType,IntHintRoundType);
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
    dmCalendar.ilCalendar.GetBitmap(ImageIndex,Image);
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
  ListToolBarHandles.Clear;
  if (hMenuRBooksCalendar<>MENU_INVALID_HANDLE) or
//     (hMenuRBooksCalendarView<>MENU_INVALID_HANDLE) or
     (hMenuRBooksActualTime<>MENU_INVALID_HANDLE){ or
     (hMenuRBooksChargeGroup<>MENU_INVALID_HANDLE) or
     (hMenuRBooksRoundType<>MENU_INVALID_HANDLE)}
  then
  begin
   tbar1:=CreateToolBarLocal(tlbCaptionActualTime,tlbHintActualTime,0);
   ListToolBarHandles.Add(Pointer(tbar1));
   if hMenuRBooksCalendar<>MENU_INVALID_HANDLE then
    hToolButtonCalendar:=CreateToolButtonLocal(tbar1,MenuItemCaptionCalendarEdit,MenuItemHintCalendarEdit,0,ToolButtonClickProc);
{   if hMenuRBooksCalendarView<>MENU_INVALID_HANDLE then
    hToolButtonCalendarView:=CreateToolButtonLocal(tbar1,MenuItemCaptionCalendarView,MenuItemHintCalendarView,0,ToolButtonClickProc);}
   if hMenuRBooksActualTime<>MENU_INVALID_HANDLE then
    hToolButtonActualTime:=CreateToolButtonLocal(tbar1,MenuItemCaptionActualTime,MenuItemHintActualTime,1,ToolButtonClickProc);
{   if hMenuRBooksChargeGroup<>MENU_INVALID_HANDLE then
    hToolButtonChargeGroup:=CreateToolButtonLocal(tbar1,MenuItemCaptionChargeGroup,MenuItemHintChargeGroup,2,ToolButtonClickProc);
   if hMenuRBooksRoundType<>MENU_INVALID_HANDLE then
    hToolButtonRoundType:=CreateToolButtonLocal(tbar1,MenuItemCaptionRoundType,MenuItemHintRoundType,3,ToolButtonClickProc);}

   _RefreshToolBar(tbar1);
  end;
end;

procedure DeInitAll;
begin
 if isInitData then
 try
  if frmRoundType<>nil then FreeAndNil(frmRoundType);
  if frmChargeGroup<>nil then FreeAndNil(frmChargeGroup);
  if frmActualTime<>nil then FreeAndNil(frmActualTime);
  if frmCalendarView<>nil then FreeAndNil(frmCalendarView);
  if frmCalendar<>nil then FreeAndNil(frmCalendar);
  if dmCalendar<>nil then FreeAndNil(dmCalendar);

  ClearListMenuHandles;
  ListMenuHandles.free;

{  ClearListOptionHandles;
  ListOptionHandles.Free;}

  ClearListToolBarHandles;
  ListToolBarHandles.Free;

  ClearListInterfaceHandles;
  ListInterfaceHandles.Free;

  DoneCalendarUtil;

 except
 end;
end;

procedure InitAll_;
begin
 try
  dmCalendar:=TdmCalendar.Create(nil);

  ListInterfaceHandles:=TList.Create;
  AddToListInterfaceHandles;

  ListMenuHandles:=Tlist.Create;
  AddToListMenuRootHandles;

{  ListOptionHandles:=TList.Create;
  AddToListOptionRootHandles;}

  ListToolBarHandles:=TList.Create;
  AddToListToolBarHandles;

  isInitData:=True;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
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

{    ClearListOptionHandles;
    AddToListOptionRootHandles;}

{    FreeAndNil(fmOptions);
    fmOptions:=TfmOptions.Create(nil);
    fmOptions.ParentWindow:=Application.Handle;}

    ClearListToolBarHandles;
    AddToListToolBarHandles;
  finally
    Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

end.
