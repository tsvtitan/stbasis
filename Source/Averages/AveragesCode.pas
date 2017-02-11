unit AveragesCode;

{$I stbasis.inc}

interface

uses Windows, Forms, Graphics, UMainUnited, Classes,
     IBDatabase, IBQuery, IBServices;


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

implementation

uses Sysutils, Controls, AveragesData, tsvHint, StCalendarUtil,
     UOTAveragesLeave, UOTAveragesSick, StSalaryKit, AveragesOptions;

type
  TAveragesOptionsItem=(tao01,tao02,tao03,tao04,tao05,taoNone,taoSick,taoLeave);

var
  isInitData: Boolean=false;

procedure GetInfoLibrary_(P: PInfoLibrary);stdcall;
begin
 if P=nil then exit;
 P.Hint:='Расчёт по средним и всё, что с ним связано.';
 P.TypeLib:=ttleDefault;
end;

procedure SetConnection_(IBDbase: TIBDatabase; IBTran: TIBTransaction;
                         IBDBSecurity: TIBDatabase; IBTSecurity: TIBTransaction);stdcall;
begin
 dbSTBasis:=IBDbase;
 trDefault:=IBTran;
 ChangeDataBase(dmAverages,dbSTBasis);
 InitCalendarUtil(IBDbase);
 CalculateInit(IBDbase);
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

procedure ClearListOptionHandles;
var
  i: Integer;
begin
  for i:=0 to ListOptionHandles.Count-1 do begin
    _FreeOption(THandle(ListOptionHandles.Items[i]));
  end;
  ListOptionHandles.Clear;
end;

function CreateAndViewAverageSickList(InterfaceHandle: THandle; Params: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    Result:=false;
    try
     if fmOTAveragesSick=nil then
      fmOTAveragesSick:=TfmOTAveragesSick.Create(Application,InterfaceHandle,nil);
     fmOTAveragesSick.BringToFront;
     fmOTAveragesSick.Show;
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
 Result:=false;
 case Params.Visual.TypeView of
  tviMdiChild: Result:=CreateAndViewAsMDIChild;
  tvibvModal: Result:=False;
  tviOnlyData: Result:=False;
 end;
end;

function CreateAndViewAverageLeaveList(InterfaceHandle: THandle; Params: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    Result:=false;
    try
     if fmOTAveragesLeave=nil then
      fmOTAveragesLeave:=TfmOTAveragesLeave.Create(Application,InterfaceHandle,nil);
     fmOTAveragesLeave.BringToFront;
     fmOTAveragesLeave.Show;
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
 Result:=false;
 case Params.Visual.TypeView of
  tviMdiChild: Result:=CreateAndViewAsMDIChild;
  tvibvModal: Result:=False;
  tviOnlyData: Result:=False;
 end;
end;

function ViewInterface(InterfaceHandle: THandle; Param: Pointer): Boolean; stdcall;
begin
  Result:=false;

  if InterfaceHandle=hInterfaceAverageSickList then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewAverageSickList(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceAverageLeaveList then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewAverageLeaveList(InterfaceHandle,Param);
  end;
end;

procedure MenuClickProc(MenuHandle: THandle);stdcall;
var TPRBI:TParamRBookInterface;
begin
 FillChar(TPRBI,SizeOf(TPRBI),0);
 if MenuHandle=hMenuAverageSickList then ViewInterface(hInterfaceAverageSickList,@TPRBI);
 if MenuHandle=hMenuAverageLeaveList then ViewInterface(hInterfaceAverageLeaveList,@TPRBI);
end;

procedure ToolButtonClickProc(ToolButtonHandle: THandle);stdcall;
begin
 if ToolButtonHandle=hToolButtonAverageSickList then MenuClickProc(hMenuAverageSickList);
 if ToolButtonHandle=hToolButtonAverageLeaveList then MenuClickProc(hMenuAverageLeaveList);
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
     dmAverages.ilAverages.GetBitmap(ImageIndex,Image);
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

  hMenuAverageSickList:=MENU_INVALID_HANDLE;
  if _isPermissionOnInterface(hInterfaceAverageSickList,ttiaView) then
  begin
   hMenuAverageSickList:=CreateMenuLocal(hMenuRBooks,'Листки нетрудоспособности','Листки нетрудоспособности',tcmAddLast,MENU_INVALID_HANDLE,1,0,MenuClickProc);
   if fmOTAveragesSick<>nil then
    fmOTAveragesSick.DoRefresh(False);
  end
  else FreeAndNil(fmOTAveragesSick);

  hMenuAverageLeaveList:=MENU_INVALID_HANDLE;
  if _isPermissionOnInterface(hInterfaceAverageLeaveList,ttiaView) then
  begin
   hMenuAverageLeaveList:=CreateMenuLocal(hMenuRBooks,'Общие средние','Общие средние',tcmAddLast,MENU_INVALID_HANDLE,2,0,MenuClickProc);
   if fmOTAveragesLeave<>nil then
    fmOTAveragesLeave.DoRefresh(False);
  end
  else FreeAndNil(fmOTAveragesLeave);
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

  hInterfaceAverageSickList:=CreateLocalInterface('AverageSickList','');
  hInterfaceAverageLeaveList:=CreateLocalInterface('AverageLeaveList','');
{  CreateLocalPermission(hInterfaceRbkRelease,tbRelease,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkRelease,tbRelease,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkRelease,tbRelease,ttpInsert,false,ttiaAdd);}
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
    dmAverages.ilAverages.GetBitmap(ImageIndex,Image);
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
  if (hMenuAverageSickList<>MENU_INVALID_HANDLE) or
     (hMenuAverageLeaveList<>MENU_INVALID_HANDLE)
  then
  begin
   tbar1:=CreateToolBarLocal('Средние','',0);
   ListToolBarHandles.Add(Pointer(tbar1));
   if hMenuAverageSickList<>MENU_INVALID_HANDLE then
    hToolButtonAverageSickList:=CreateToolButtonLocal(tbar1,'Листки нетрудоспособности','Листки нетрудоспособности',1,ToolButtonClickProc);
   if hMenuAverageLeaveList<>MENU_INVALID_HANDLE then
    hToolButtonAverageLeaveList:=CreateToolButtonLocal(tbar1,'Общие средние','Общие средние',2,ToolButtonClickProc);

   _RefreshToolBar(tbar1);
  end;
end;

procedure BeforeSetOptionProc(OptionHandle: THandle);stdcall;

{  procedure BeforeSetOption;
  var
    wc: TWinControl;
  begin
    if OptionHandle=hOptionEmp then begin
     wc:=FindControl(_GetOptionParentWindow(hOptionEmp));
     if isValidPointer(wc) then begin
      fmOptions.pc.ActivePage:=fmOptions.tsRBEmp;
      fmOptions.pnRBEmp.Parent:=wc;
     end;
    end;
  end;}

begin
 frmAveragesOptions.Visible:=true;
//  BeforeSetOption;
end;

procedure AfterSetOptionProc(OptionHandle: THandle; isOk: Boolean);stdcall;

  procedure AfterSetOption;
  begin
//     if OptionHandle=hOptionEmp then begin
{      fmOptions.pnRBEmp.Parent:=fmOptions.tsRBEmp;
      if fmRBEmp<>nil then fmRBEmp.SetParamsFromOptions;
     end;}
  end;

begin
   AfterSetOption;

//   if isOK then frmAveragesOptions.SaveToIni;

   frmAveragesOptions.Visible:=false;

  if isOk then begin
{    if fmRBRelease<>nil then SetProperties(fmRBRelease);
    if fmRBBlackList<>nil then SetProperties(fmRBBlackList);
    if fmRBTreeHeading<>nil then begin
     SetProperties(fmRBTreeHeading);
     fmRBTreeHeading.CursorColor:=_GetOptions.RBTableCursorColor;
    end;
    if fmRBKeyWords<>nil then SetProperties(fmRBKeyWords);
    if fmRBAnnouncement<>nil then SetProperties(fmRBAnnouncement);
    if fmRBAnnouncementDubl<>nil then SetProperties(fmRBAnnouncementDubl);}
  end;

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
     dmAverages.ilAverages.GetBitmap(ImageIndex,Image);
     OCLocal.Bitmap:=Image;
    end;
    Result:=_CreateOption(ParentHandle,@OCLocal);
   finally
     Image.Free;
   end;
  end;

begin
  ListOptionHandles.Clear;
{  hOptionRBooks:=CreateOptionLocal(OPTION_ROOT_HANDLE,ConstOptionRBooks,-1);
  ListOptionHandles.Add(Pointer(hOptionRBooks));
  if hMenuRBooksEmp<>MENU_INVALID_HANDLE then begin
   hOptionEmp:=CreateOptionLocal(hOptionRBooks,NameRbkEmp,2);
  end;}
end;

procedure DeInitAll;
begin
 if isInitData then
 try
  DoneCalendarUtil;
  CalculateDone;

  if frmAveragesOptions<>nil then FreeAndNil(frmAveragesOptions);
  if fmOTAveragesLeave<>nil then FreeAndNil(fmOTAveragesLeave);
  if fmOTAveragesSick<>nil then FreeAndNil(fmOTAveragesSick);
  if dmAverages<>nil then FreeAndNil(dmAverages);

  ClearListMenuHandles;
  ListMenuHandles.free;

  ClearListOptionHandles;
  ListOptionHandles.Free;

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
  dmAverages:=TdmAverages.Create(nil);

  ListInterfaceHandles:=TList.Create;
  AddToListInterfaceHandles;

  ListMenuHandles:=Tlist.Create;
  AddToListMenuRootHandles;

  ListOptionHandles:=TList.Create;
  AddToListOptionRootHandles;

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

    ClearListOptionHandles;
    AddToListOptionRootHandles;

    if frmAveragesOptions<>nil then FreeAndNil(frmAveragesOptions);
    frmAveragesOptions:=TfrmAveragesOptions.Create(nil);
    frmAveragesOptions.ParentWindow:=Application.Handle;

    ClearListToolBarHandles;
    AddToListToolBarHandles;
  finally
    Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

{procedure BeforeSetOptions_;stdcall;

  procedure BeforeSetOptions(List: TList);
  var
    i: Integer;
    P: PInfoOption;
  begin
    if list=nil then exit;
    for i:=0 to List.Count-1 do begin
      P:=List.Items[i];
      if P<>nil then begin
       case TAveragesOptionsItem(P.Index) of
        taoNone:begin
         frmAveragesOptions.PageControl.ActivePage:=frmAveragesOptions.TabSheet3;
         Windows.SetParent(frmAveragesOptions.PanelNoneOptions.Handle,P.ParentWindow);
        end;
        taoSick:begin
         frmAveragesOptions.PageControl.ActivePage:=frmAveragesOptions.TabSheet1;
         Windows.SetParent(frmAveragesOptions.PanelSickOptions.Handle,P.ParentWindow);
        end;
        taoLeave:begin
         frmAveragesOptions.PageControl.ActivePage:=frmAveragesOptions.TabSheet2;
         Windows.SetParent(frmAveragesOptions.PanelLeaveOptions.Handle,P.ParentWindow);
        end;
       end;
       if P.List<>nil then
        BeforeSetOptions(P.List);
      end;
    end;
  end;

begin
 try
  frmAveragesOptions.Show;
  BeforeSetOptions(ListOptionsRoot);
 except
 end;
end;

procedure AfterSetOptions_(isOK: Boolean);stdcall;

  procedure AfterSetOptions(List: TList);
  var
    i: Integer;
    P: PInfoOption;
  begin
    if list=nil then exit;
    for i:=0 to List.Count-1 do begin
      P:=List.Items[i];
      if P<>nil then begin
       case TAveragesOptionsItem(P.Index) of
        taoNone:begin
         Windows.SetParent(frmAveragesOptions.PanelNoneOptions.Handle,frmAveragesOptions.TabSheet3.Handle);
        end;
        taoSick:begin
         Windows.SetParent(frmAveragesOptions.PanelSickOptions.Handle,frmAveragesOptions.TabSheet1.Handle);
        end;
        taoLeave:begin
         Windows.SetParent(frmAveragesOptions.PanelLeaveOptions.Handle,frmAveragesOptions.TabSheet2.Handle);
        end;
       end;
       if P.List<>nil then
        AfterSetOptions(P.List);
      end;
    end;
  end;

begin
 try
  AfterSetOptions(ListOptionsRoot);
  frmAveragesOptions.Hide;
  if isOk then begin
  end;
 except
 end;
end;}

end.
