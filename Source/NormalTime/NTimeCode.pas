unit NTimeCode;

{$I stbasis.inc}

interface

uses Windows, Forms, UMainUnited, Classes,
     IBDatabase, IBQuery, IBServices, Graphics, DBGrids;

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

//Service routines
procedure CheckColumnsPermission(TableName: String;Columns: TDBGridColumns);

type
  TScheduleAction=(saScheduleEdit,saScheduleSelect);
  TShiftAction=(saShiftEdit,saShiftSelect);
  TNetAction=(naNetEdit,naNetSelect);
  TClassAction=(caClassEdit,caClassSelect);
  TAbsenceAction=(aaAbsenceEdit,aaAbsenceSelect);
  TCategoryAction=(caCategoryEdit,caCategorySelect);
  TCategoryTypeAction=(ctCategoryTypeEdit,ctCategoryTypeSelect);
  TSeatClassAction=(scSeatClassEdit,scSeatClassSelect);

implementation

uses SysUtils, StrUtils, Controls, NTimeData, NTimeSchedule, NTimeShift, OTIZNet,
     OTIZAbsence, OTIZCategory, OTIZClass, OTIZSeatClass, OTIZCategoryType, tsvHint, StCalendarUtil;

procedure GetInfoLibrary_(P: PInfoLibrary);stdcall;
begin
  if P=nil then exit;
  P.Hint:='—одержит следующие справочники:'+#13+'нормы часов, смены';
  P.TypeLib:=ttleDefault;
end;

function CreateAndViewSchedule(InterfaceHandle: THandle; Params: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    Result:=false;
    try
     if frmSchedule=nil then
      frmSchedule:=TfrmSchedule.Create(Application,InterfaceHandle,saScheduleEdit,Params);
     frmSchedule.BringToFront;
     frmSchedule.Show;
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfrmSchedule;
   begin
    Result:=false;
    try
     fm:=nil;
     try
      fm:=TfrmSchedule.Create(Application,InterfaceHandle,saScheduleSelect,Params);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(dbSTBasis,'select * from schedule ',Params);
  end;
end;

function CreateAndViewShift(InterfaceHandle: THandle; Params: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    Result:=false;
    try
     if frmShift=nil then
      frmShift:=TfrmShift.Create(Application,InterfaceHandle,saShiftEdit,Params);
     frmShift.BringToFront;
     frmShift.Show;
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfrmShift;
   begin
    Result:=false;
    try
     fm:=nil;
     try
      fm:=TfrmShift.Create(Application,InterfaceHandle,saShiftSelect,Params);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(dbSTBasis,'select * from shift ',Params);
  end;
end;

function CreateAndViewNet(InterfaceHandle: THandle; Params: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    Result:=false;
    try
     if frmNet=nil then
      frmNet:=TfrmNet.Create(Application,InterfaceHandle,naNetEdit,Params);
     frmNet.BringToFront;
     frmNet.Show;
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfrmNet;
   begin
    Result:=false;
    try
     fm:=nil;
     try
      fm:=TfrmNet.Create(Application,InterfaceHandle,naNetSelect,Params);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(dbSTBasis,'select * from net ',Params);
  end;
end;

function CreateAndViewClass(InterfaceHandle: THandle; Params: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    Result:=false;
    try
     if frmClass=nil then
      frmClass:=TfrmClass.Create(Application,InterfaceHandle,caClassEdit,Params);
     frmClass.BringToFront;
     frmClass.Show;
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfrmClass;
   begin
    Result:=false;
    try
     fm:=nil;
     try
      fm:=TfrmClass.Create(Application,InterfaceHandle,caClassSelect,Params);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(dbSTBasis,'select * from class ',Params);
  end;
end;

function CreateAndViewAbsence(InterfaceHandle: THandle; Params: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    Result:=false;
    try
     if frmAbsence=nil then
      frmAbsence:=TfrmAbsence.Create(Application,InterfaceHandle,aaAbsenceEdit,Params);
     frmAbsence.BringToFront;
     frmAbsence.Show;
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfrmAbsence;
   begin
    Result:=false;
    try
     fm:=nil;
     try
      fm:=TfrmAbsence.Create(Application,InterfaceHandle,aaAbsenceSelect,Params);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(dbSTBasis,'select * from absence ',Params);
  end;
end;

function CreateAndViewCategory(InterfaceHandle: THandle; Params: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    Result:=false;
    try
     if frmCategory=nil then
      frmCategory:=TfrmCategory.Create(Application,InterfaceHandle,caCategoryEdit,Params);
     frmCategory.BringToFront;
     frmCategory.Show;
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfrmCategory;
   begin
    Result:=false;
    try
     fm:=nil;
     try
      fm:=TfrmCategory.Create(Application,InterfaceHandle,caCategorySelect,Params);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(dbSTBasis,'select * from category ',Params);
  end;
end;

function CreateAndViewSeatClass(InterfaceHandle: THandle; Params: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    Result:=false;
    try
     if frmSeatClass=nil then
      frmSeatClass:=TfrmSeatClass.Create(Application,InterfaceHandle,scSeatClassEdit,Params);
     frmSeatClass.BringToFront;
     frmSeatClass.Show;
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfrmSeatClass;
   begin
    Result:=false;
    try
     fm:=nil;
     try
      fm:=TfrmSeatClass.Create(Application,InterfaceHandle,scSeatClassSelect,Params);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(dbSTBasis,'select * from seatclass ',Params);
  end;
end;

function CreateAndViewCategoryType(InterfaceHandle: THandle; Params: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    Result:=false;
    try
     if frmCategoryType=nil then
      frmCategoryType:=TfrmCategoryType.Create(Application,InterfaceHandle,ctCategoryTypeEdit,Params);
     frmCategoryType.BringToFront;
     frmCategoryType.Show;
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfrmCategoryType;
   begin
    Result:=false;
    try
     fm:=nil;
     try
      fm:=TfrmCategoryType.Create(Application,InterfaceHandle,ctCategoryTypeSelect,Params);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(dbSTBasis,'select * from categorytype ',Params);
  end;
end;

procedure SetConnection_(IBDbase: TIBDatabase; IBTran: TIBTransaction;
                         IBDBSecurity: TIBDatabase; IBTSecurity: TIBTransaction);stdcall;
begin
 dbSTBasis:=IBDbase;
 trDefault:=IBTran;
 ChangeDataBase(dmNormalTime,dbSTBasis);
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

  if InterfaceHandle=hInterfaceRbkSchedule then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewSchedule(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkShift then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewShift(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkNet then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewNet(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkClass then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewClass(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkAbsence then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewAbsence(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkCategory then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewCategory(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkCategoryType then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewCategoryType(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkSeatClass then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewSeatClass(InterfaceHandle,Param);
  end;
end;

procedure MenuClickProc(MenuHandle: THandle);stdcall;
var
  TPRBI: TParamRBookInterface;
//  TPRI: TParamReportInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
//  FillChar(TPRI,SizeOf(TPRI),0);
  if MenuHandle=hMenuRBooksSchedule then ViewInterface(hInterfaceRbkSchedule,@TPRBI);
  if MenuHandle=hMenuRBooksShift then ViewInterface(hInterfaceRbkShift,@TPRBI);
  if MenuHandle=hMenuRBooksNet then ViewInterface(hInterfaceRbkNet,@TPRBI);
  if MenuHandle=hMenuRBooksClass then ViewInterface(hInterfaceRbkClass,@TPRBI);
  if MenuHandle=hMenuRBooksAbsence then ViewInterface(hInterfaceRbkAbsence,@TPRBI);
  if MenuHandle=hMenuRBooksCategory then ViewInterface(hInterfaceRbkCategory,@TPRBI);
  if MenuHandle=hMenuRBooksCategoryType then ViewInterface(hInterfaceRbkCategoryType,@TPRBI);
  if MenuHandle=hMenuRBooksSeatClass then ViewInterface(hInterfaceRbkSeatClass,@TPRBI);
end;

procedure ToolButtonClickProc(ToolButtonHandle: THandle);stdcall;
begin
 if ToolButtonHandle=hToolButtonSchedule then MenuClickProc(hMenuRBooksSchedule);
 if ToolButtonHandle=hToolButtonShift then MenuClickProc(hMenuRBooksShift);
 if ToolButtonHandle=hToolButtonNet then MenuClickProc(hMenuRBooksNet);
 if ToolButtonHandle=hToolButtonClass then MenuClickProc(hMenuRBooksClass);
 if ToolButtonHandle=hToolButtonAbsence then MenuClickProc(hMenuRBooksAbsence);
 if ToolButtonHandle=hToolButtonCategory then MenuClickProc(hMenuRBooksCategory);
 if ToolButtonHandle=hToolButtonCategoryType then MenuClickProc(hMenuRBooksCategoryType);
 if ToolButtonHandle=hToolButtonSeatClass then MenuClickProc(hMenuRBooksSeatClass);
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
     dmNormalTime.ilNormalTime.GetBitmap(ImageIndex,Image);
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

  hMenuRBooksSchedule:=MENU_INVALID_HANDLE;
  if _isPermissionOnInterface(hInterfaceRbkSchedule,ttiaView) then
  begin
   hMenuRBooksSchedule:=CreateMenuLocal(hMenuRBooks,MenuItemCaptionSchedule,MenuItemHintSchedule,tcmAddLast,MENU_INVALID_HANDLE,0,0,MenuClickProc);
   if frmSchedule<>nil then
    frmSchedule.DoRefresh(True);
  end
  else FreeAndNil(frmSchedule);

  hMenuRBooksShift:=MENU_INVALID_HANDLE;
  if _isPermissionOnInterface(hInterfaceRbkShift,ttiaView) then
  begin
   hMenuRBooksShift:=CreateMenuLocal(hMenuRBooks,MenuItemCaptionShift,MenuItemHintShift,tcmAddLast,MENU_INVALID_HANDLE,1,0,MenuClickProc);
   if frmShift<>nil then
    frmShift.DoRefresh;
  end
  else FreeAndNil(frmShift);

  if _isPermissionOnInterface(hInterfaceRbkNet,ttiaView) then
  begin
   hMenuRBooksNet:=CreateMenuLocal(hMenuRBooks,MenuItemCaptionNet,MenuItemHintNet,tcmAddLast,MENU_INVALID_HANDLE,2,0,MenuClickProc);
   if frmNet<>nil then
    frmNet.DoRefresh;
  end
  else FreeAndNil(frmNet);

  if _isPermissionOnInterface(hInterfaceRbkClass,ttiaView) then
  begin
   hMenuRBooksClass:=CreateMenuLocal(hMenuRBooks,MenuItemCaptionClass,MenuItemHintClass,tcmAddLast,MENU_INVALID_HANDLE,3,0,MenuClickProc);
   if frmClass<>nil then
    frmClass.DoRefresh;
  end
  else FreeAndNil(frmClass);

  if _isPermissionOnInterface(hInterfaceRbkAbsence,ttiaView) then
  begin
   hMenuRBooksAbsence:=CreateMenuLocal(hMenuRBooks,MenuItemCaptionAbsence,MenuItemHintAbsence,tcmAddLast,MENU_INVALID_HANDLE,4,0,MenuClickProc);
   if frmAbsence<>nil then
    frmAbsence.DoRefresh;
  end
  else FreeAndNil(frmAbsence);

  if _isPermissionOnInterface(hInterfaceRbkCategory,ttiaView) then
  begin
   hMenuRBooksCategory:=CreateMenuLocal(hMenuRBooks,MenuItemCaptionCategory,MenuItemHintCategory,tcmAddLast,MENU_INVALID_HANDLE,5,0,MenuClickProc);
   if frmCategory<>nil then
    frmCategory.DoRefresh;
  end
  else FreeAndNil(frmCategory);

  if _isPermissionOnInterface(hInterfaceRbkCategoryType,ttiaView) then
  begin
   hMenuRBooksCategoryType:=CreateMenuLocal(hMenuRBooks,MenuItemCaptionCategoryType,MenuItemHintCategoryType,tcmAddLast,MENU_INVALID_HANDLE,5,0,MenuClickProc);
   if frmCategoryType<>nil then
    frmCategoryType.DoRefresh;
  end
  else FreeAndNil(frmCategoryType);

  if _isPermissionOnInterface(hInterfaceRbkSeatClass,ttiaView) then
  begin
   hMenuRBooksSeatClass:=CreateMenuLocal(hMenuRBooks,MenuItemCaptionSeatClass,MenuItemHintSeatClass,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);
   if frmSeatClass<>nil then
    frmSeatClass.DoRefresh;
  end
  else FreeAndNil(frmSeatClass);
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

  hInterfaceRbkSchedule:=CreateLocalInterface(IntNameSchedule,IntHintSchedule);
  hInterfaceRbkShift:=CreateLocalInterface(IntNameShift,IntHintShift);
  hInterfaceRbkNet:=CreateLocalInterface(IntNameNet,IntHintNet);
  hInterfaceRbkClass:=CreateLocalInterface(IntNameClass,IntHintClass);
  hInterfaceRbkAbsence:=CreateLocalInterface(IntNameAbsence,IntHintAbsence);
  hInterfaceRbkCategory:=CreateLocalInterface(IntNameCategory,IntHintCategory);
  hInterfaceRbkCategoryType:=CreateLocalInterface(IntNameCategoryType,IntHintCategoryType);
  hInterfaceRbkSeatClass:=CreateLocalInterface(IntNameSeatClass,IntHintSeatClass);
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
    dmNormalTime.ilNormalTime.GetBitmap(ImageIndex,Image);
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
  if (hMenuRBooksSchedule<>MENU_INVALID_HANDLE) or
     (hMenuRBooksNet<>MENU_INVALID_HANDLE) or
     (hMenuRBooksShift<>MENU_INVALID_HANDLE) or
     (hMenuRBooksClass<>MENU_INVALID_HANDLE) or
     (hMenuRBooksAbsence<>MENU_INVALID_HANDLE) or
     (hMenuRBooksCategory<>MENU_INVALID_HANDLE) or
     (hMenuRBooksCategoryType<>MENU_INVALID_HANDLE) or
     (hMenuRBooksSeatClass<>MENU_INVALID_HANDLE)
  then
  begin
   tbar1:=CreateToolBarLocal('ќ“и«','',0);
   ListToolBarHandles.Add(Pointer(tbar1));
   if hMenuRBooksSchedule<>MENU_INVALID_HANDLE then
    hToolButtonSchedule:=CreateToolButtonLocal(tbar1,MenuItemCaptionSchedule,MenuItemHintSchedule,0,ToolButtonClickProc);
   if hMenuRBooksShift<>MENU_INVALID_HANDLE then
    hToolButtonShift:=CreateToolButtonLocal(tbar1,MenuItemCaptionShift,MenuItemHintShift,1,ToolButtonClickProc);
   if hMenuRBooksNet<>MENU_INVALID_HANDLE then
    hToolButtonNet:=CreateToolButtonLocal(tbar1,MenuItemCaptionNet,MenuItemHintNet,2,ToolButtonClickProc);
   if hMenuRBooksClass<>MENU_INVALID_HANDLE then
    hToolButtonClass:=CreateToolButtonLocal(tbar1,MenuItemCaptionClass,MenuItemHintClass,3,ToolButtonClickProc);
   if hMenuRBooksAbsence<>MENU_INVALID_HANDLE then
    hToolButtonAbsence:=CreateToolButtonLocal(tbar1,MenuItemCaptionAbsence,MenuItemHintAbsence,4,ToolButtonClickProc);
   if hMenuRBooksCategory<>MENU_INVALID_HANDLE then
    hToolButtonCategory:=CreateToolButtonLocal(tbar1,MenuItemCaptionCategory,MenuItemHintCategory,5,ToolButtonClickProc);
   if hMenuRBooksCategoryType<>MENU_INVALID_HANDLE then
    hToolButtonCategoryType:=CreateToolButtonLocal(tbar1,MenuItemCaptionCategoryType,MenuItemHintCategoryType,5,ToolButtonClickProc);
   if hMenuRBooksSeatClass<>MENU_INVALID_HANDLE then
    hToolButtonSeatClass:=CreateToolButtonLocal(tbar1,MenuItemCaptionSeatClass,MenuItemHintSeatClass,-1,ToolButtonClickProc);

   _RefreshToolBar(tbar1);
  end;
end;

{function _isPermissionColumn(sqlObject: PChar; FieldName: PChar; sqlOperator: PChar): Boolean;
begin
 Result:=(FieldName<>'northfactor') and (FieldName<>'regionfactor') and (FieldName<>'maxpay') and (FieldName<>'class_id');
// Result:=True;
end;}

procedure CheckColumnsPermission(TableName: String;Columns: TDBGridColumns);
var I,C:Integer;
    S:String;
begin
 Columns.BeginUpdate;
 for I:=Columns.Count downto 1 do
 begin
  S:=Columns[I-1].FieldName;
  Columns[I-1].FieldName:=DelChars(S,'!');
 end;
 C:=0;
 for I:=Columns.Count downto 1 do
  if not _isPermissionColumn(PChar(TableName),PChar(Columns[I-1].FieldName),SelConst) then Inc(C);
 if C=Columns.Count then
 begin
{  for I:=Columns.Count downto 1 do
   Columns[I-1].FieldName:='!'+Columns[I-1].FieldName;}
 end
 else
  for I:=Columns.Count downto 1 do
   if not _isPermissionColumn(PChar(TableName),PChar(Columns[I-1].FieldName),SelConst) then
    Columns[I-1].FieldName:='!'+Columns[I-1].FieldName;
//    Columns.Delete(I-1);
 Columns.EndUpdate;
end;

procedure DeInitAll;
begin
 if isInitData then
 try
  if frmCategoryType<>nil then FreeAndNil(frmCategoryType);
  if frmSeatClass<>nil then FreeAndNil(frmSeatClass);
  if frmCategory<>nil then FreeAndNil(frmCategory);
  if frmAbsence<>nil then FreeAndNil(frmAbsence);
  if frmClass<>nil then FreeAndNil(frmClass);
  if frmNet<>nil then FreeAndNil(frmNet);
  if frmShift<>nil then FreeAndNil(frmShift);
  if frmSchedule<>nil then FreeAndNil(frmSchedule);
  if dmNormalTime<>nil then FreeAndNil(dmNormalTime);

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
  dmNormalTime:=TdmNormalTime.Create(nil);

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
