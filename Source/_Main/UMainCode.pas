unit UMainCode;

interface

{$I stbasis.inc}

uses Windows,Forms,SysUtils,Classes,filectrl,Controls,Buttons,menus,UMainData,Dialogs,
     IBDataBase, UServerConnect, ULogin, USplash, UMainUnited,
     IBIntf, IBServices, IBQuery, IBTable, ibblob, db, graphics, Messages,
     comctrls, shlobj, tsvColorBox, inifiles, IBSqlMonitor,
     tsvDesignCore, tsvInterpreterCore;

function InitAll: Boolean;
procedure DeInitAll;
procedure SwitchParams(var IsExit: Boolean);
function MoreApplications: Boolean;
function isCorrectApplicationExeName: Boolean;
procedure SaveLibraryActive(ExeName: String; isActive: Boolean);
function ReadLibraryActive(ExeName: String): Boolean;
procedure GetDirFiles(Dir: String; str: TStringList; Mask: string);
procedure UpdateNeedLibSecurity;
function LoadNeedLib: Boolean;
function UnLoadDLLFromAddress(P: Pointer): Boolean;
procedure SortListDll;
function LoadDll(Dll: string): Boolean;
function GetInfoLib(Dll: string): PInfoLib;
function InListLibs(Dll: string): Boolean; overload;
function InListLibs(LibHandle: THandle): Boolean; overload;
procedure AddToListLibs(LibHandle: THandle; Dll: String; Hint: String;
                        RefreshLibrary: TRefreshLibraryProc;
                        SetConnection: TSetConnectionProc;
                        TypeLib: TTypeLib;
                        Programmers: String;
                        Active: Boolean;
                        StopLoad: Boolean;
                        Condition: String);

function ConnectServer(dbName,usName,usPass,sqlRole: String; WithError: Boolean=true): Boolean;
function GetWinDir: string;
function GetIniFileName: String;
procedure MainLoadFromIni;
procedure MainLoadFromIniAfterCreateAll;
procedure MainSaveToIni;
procedure AddToListDialogClassesAll;
function inListDialogClasses(ClassName: string): Boolean;
function inListErrorClasses(ClassName: string): Boolean;
function GetApplicationExeVersion: string;


function ServerFound: Boolean;
procedure SetSplashImage(Splash: TfmSplash);
function LoginToProgram: Boolean;
function MainConnect(dbName,usName,usPass,sqlRole: String): Boolean;
function SecurityConnect(dbName,usName,usPass,sqlRole: String): Boolean;
procedure RefreshFromBase;
procedure FreeLibs;
function GetSecurityDatabaseName: String;
procedure LoadDataIniFromBase;
procedure SetLoadingSQLMonitorOptions;
procedure SaveDataIniToBase;
function GetCompName: String;
procedure UnRegisterAllHotKeys;
procedure RegisterAllHotKeys;
procedure TranslateText(ttt: TTypeTranslateText);
function TranslateMenuCaption(Caption: string): string;
procedure OpenFirstLevelOnTreeView(TV: TTreeView);
procedure SetImageToTreeNodes(TreeView: TTreeView);
procedure SetEmpNameAndEmpId;
procedure SetMnOption;
function CreateDirEx(dir: String): Boolean;
procedure EmptyDir(dir: string);

function SetDataBaseFromProtocolAndServerName(DataBaseStr: string; Protocol: TProtocol;
                                              ServerName: string): String;
procedure CopyBitmap(bmpFrom,bmpTo: TBitmap);
procedure TransparentBmp(Dc: HDC; Bitmap: HBitmap; xStart: Integer;
                          yStart: Integer; trColor: TColor);

procedure SaveConnectInfo;
procedure LoadConnectInfo;
function LoadPackInfo: Boolean;

function TranslateErrorMessage(Mess: String): string;

procedure GetProtocolAndServerName_(DataBaseStr: PChar; var Protocol: TProtocol;
                                   var ServerName: array of char);stdcall;
procedure MainFormKeyDown_(var Key: Word; Shift: TShiftState);stdcall;
procedure MainFormKeyUp_(var Key: Word; Shift: TShiftState);stdcall;
procedure MainFormKeyPress_(var Key: Char);stdcall;
function GetIniFileName_: PChar;stdcall;
procedure SetSplashStatus_(Status: Pchar);stdcall;
procedure GetInfoConnectUser_(P: PInfoConnectUser);stdcall;
procedure AddErrorToJournal_(Error: PChar; ClassError: TClass); stdcall;
procedure AddSqlOperationToJournal_(Name,Hint: Pchar); stdcall;
function GetDateTimeFromServer_: TDateTime; stdcall;
function GetWorkDate_: TDate; stdcall;
function ViewEnterPeriod_(P: PInfoEnterPeriod): Boolean; stdcall;
function GetOptions_: TMainOption; stdcall;
//function GetListLibs_: TList; stdcall;
procedure GetLibraries_(Owner: Pointer; Proc: TGetLibraryProc); stdcall;
function TestSplash_: Boolean;stdcall;
// ------------------ Permissions -----------------------
function GetPermisionFromCache(ObjName,Operator: string; var Perm: Boolean): Boolean;
procedure AddToListCachePermission(ObjName,Operator: string; Perm: Boolean);
procedure ClearListCachePermission;
function GetPermisionColumnFromCache(ObjName,ObjColumn,Operator: string; var Perm: Boolean): Boolean;
procedure AddToListCachePermissionColumn(ObjName,ObjColumn,Operator: string; Perm: Boolean);
procedure ClearListCachePermissionColumn;
function isPermissionFromDB(DB: TIBDatabase; sqlObject,sqlOperator: String): Boolean;
function isPermission_(sqlObject: PChar; sqlOperator: PChar): Boolean;stdcall;
function isPermissionColumn_(sqlObject,objColumn,sqlOperator: PChar): Boolean;stdcall;
function isPermissionSecurity_(sqlObject: PChar; sqlOperator: PChar): Boolean;stdcall;
// -------------- ProgressBar  -----------------
procedure ClearListProgressBars;
function isValidProgressBar_(ProgressBarHandle: THandle): Boolean;stdcall;
function CreateProgressBar_(PCPB: PCreateProgressBar): THandle;stdcall;
function FreeProgressBar_(ProgressBarHandle: THandle): Boolean;stdcall;
procedure SetProgressBarStatus_(ProgressBarHandle: THandle; PSPBS: PSetProgressBarStatus);stdcall;
// -------------- ToolBar  -----------------
procedure ClearListToolBarsNoMain;
procedure CLearListToolBars;
procedure AddToListToolBars;
procedure ToolButtonClickProc(ToolButtonHandle: THandle); stdcall;
function CreateToolBar_(PCTB: PCreateToolBar): THandle; stdcall;
procedure RefreshToolBars_; stdcall;
function RefreshToolBar_(ToolBarHandle: THandle): Boolean;stdcall;
function FreeToolBar_(ToolBarHandle: THandle): Boolean; stdcall;
function GetToolBarFromToolButton(P: PInfoToolButton): PInfoToolBar;
function CreateToolButton_(ToolBarHandle: THandle; PCTB: PCreateToolButton): THandle; stdcall;
function FreeToolButton_(ToolButtonHandle: THandle): Boolean;stdcall;
function isValidToolBar_(ToolBarHandle: THandle): Boolean; stdcall;
function isValidToolButton_(ToolButtonHandle: THandle): Boolean; stdcall;
procedure PrepearToolBars;
// -------------- Options ---------------------
procedure ClearListOptions;
procedure AddToListOptionsRoot;
function CreateOption_(ParentHandle: THandle; PCO: PCreateOption): THandle;stdcall;
function FreeOption_(OptionHandle: THandle): Boolean;stdcall;
function ViewOption_(OptionHandle: THandle): Boolean; stdcall;
procedure BeforeSetOptionProc(OptionHandle: THandle);stdcall;
procedure AfterSetOptionProc(OptionHandle: THandle; isOk: Boolean);stdcall;
procedure CheckOptionProc(OptionHandle: THandle; var CheckFail: Boolean);stdcall;
function GetOptionParentWindow_(OptionHandle: THandle): THandle;stdcall;
function isValidOption_(OptionHandle: THandle): Boolean; stdcall;
procedure BeforeSetOptions_; stdcall;
procedure AfterSetOptions_(isOk: Boolean); stdcall;
function CheckOptions_: Boolean; stdcall;

// -------------- Menus ---------------------
procedure ClearListMenus;
procedure MenuClickProc(MenuHandle: THandle);stdcall;
procedure AddToListMenusRoot;
function CreateMenu_(ParentHandle: THandle; PCM: PCreateMenu):THandle;stdcall;
function FreeMenu_(MenuHandle: THandle): Boolean;stdcall;
function GetMenuHandleFromName_(ParentHandle: THandle; Name: PChar): THandle;stdcall;
function ViewMenu_(MenuHandle: THandle): Boolean;stdcall;
procedure PrepearMenus;
function isValidMenu_(MenuHandle: THandle): Boolean; stdcall;
// -------------- Interfaces ---------------------
function ViewInterfaceWithDefaultParam(InterfaceHandle: THandle): Boolean;
function RefreshInterfaceWithDefaultParam(InterfaceHandle: THandle): Boolean;
function CloseInterfaceWithDefaultParam(InterfaceHandle: THandle): Boolean;
procedure RunInterfacesWhereAutoRunTrue;
procedure RunInterfacesByListRunInterfaces;
procedure ClearListInterfaces;
function ViewInterface(InterfaceHandle: THandle; Param: Pointer): Boolean; stdcall;
procedure AddToListInterfaces;
function isPermissionOnInterfaceView(InterfaceHandle: THandle): Boolean;
function CreateInterface_(PCI: PCreateInterface): THandle;stdcall;
function FreeInterface_(InterfaceHandle: THandle): Boolean;stdcall;
function GetInterfaceHandleFromName_(Name: PChar): THandle;stdcall;
function ViewInterface_(InterfaceHandle: THandle; Param: Pointer): Boolean; stdcall;
function ViewInterfaceFromName_(Name: PChar; Param: Pointer): Boolean; stdcall;
function RefreshInterface_(InterfaceHandle: THandle; Param: Pointer): Boolean;stdcall;
function CloseInterface_(InterfaceHandle: THandle): Boolean; stdcall;
function ExecProcInterface_(InterfaceHandle: THandle; Param: Pointer): Boolean;stdcall;
function OnVisibleInterface_(InterfaceHandle: THandle; Visible: Boolean): Boolean; stdcall;
function CreatePermissionForInterface_(InterfaceHandle: THandle; PCPFI: PCreatePermissionForInterface): Boolean;stdcall;
function isPermissionOnInterface_(InterfaceHandle: THandle; Action: TTypeInterfaceAction): Boolean; stdcall;
function isValidInterface_(InterfaceHandle: THandle): Boolean; stdcall;
procedure GetInterfaces_(Owner: Pointer; Proc: TGetInterfaceProc); stdcall;
procedure GetInterfacePermissions_(Owner: Pointer; InterfaceHandle: THandle; Proc: TGetInterfacePermissionProc); stdcall;
function GetInterface_(InterfaceHandle: THandle): PGetInterface; stdcall;
// ----------- Logs --------------------------
procedure CreateLogItem(Text: String; TypeLogItem: TTypeLogItem=tliInformation);
function ClearLog_: Boolean;stdcall;
procedure ViewLog_(Visible: Boolean);stdcall;
function CreateLogItem_(PCLI: PCreateLogItem): THandle;stdcall;
function FreeLogItem_(LogItemHandle: THandle): Boolean;stdcall;
function isValidLogItem_(LogItemHandle: THandle): Boolean; stdcall;
// ----------- AdditionalLog --------------------------
procedure ViewAdditionalLogItemProc(AdditionalLogItemHandle: THandle);stdcall;
procedure ViewAdditionalLogOptionProc(AdditionalLogHandle: THandle);stdcall;
procedure ClearListAdditionalLogs;
function CreateAdditionalLog_(PCAL: PCreateAdditionalLog): THandle;stdcall;
function FreeAdditionalLog_(AdditionalLogHandle: THandle): Boolean; stdcall;
function SetParamsToAdditionalLog_(AdditionalLogHandle: THandle; PSPAL: PSetParamsToAdditionalLog): Boolean;stdcall;
function CreateAdditionalLogItem_(AdditionalLogHandle: THandle; PCALI: PCreateAdditionalLogItem): THandle; stdcall;
function FreeAdditionalLogItem_(AdditionalLogItemHandle: THandle): Boolean; stdcall;
function isValidAdditionalLog_(AdditionalLogHandle: THandle): Boolean; stdcall;
function isValidAdditionalLogItem_(AdditionalLogItemHandle: THandle): Boolean; stdcall;
function ClearAdditionalLog_(AdditionalLogHandle: THandle): Boolean; stdcall;
procedure ViewAdditionalLog_(AdditionalLogHandle: THandle; Visible: Boolean); stdcall;
function GetAdditionalLogHandleByLogIndex(LogIndex: Integer): THandle;
// ----------- DesignPalette --------------------------
procedure ClearListDesignPalettes;
function isValidDesignPalette_(DesignPaletteHandle: THandle): Boolean; stdcall;
function isValidDesignPaletteButton_(DesignPaletteButtonHandle: THandle): Boolean; stdcall;
function CreateDesignPalette_(PCDP: PCreateDesignPalette): THandle; stdcall;
function CreateDesignPaletteButton_(DesignPaletteHandle: THandle; PCDPB: PCreateDesignPaletteButton): THandle; stdcall;
function FreeDesignPalette_(DesignPaletteHandle: THandle): Boolean; stdcall;
function FreeDesignPaletteButton_(DesignPaletteButtonHandle: THandle): Boolean; stdcall;
procedure GetDesignPalettes_(Owner: Pointer; Proc: TGetDesignPaletteProc); stdcall;
// ----------- DesignPropertyTranslate --------------------------
procedure ClearListDesignPropertyTranslates;
function isValidDesignPropertyTranslate_(DesignPropertyTranslateHandle: THandle): Boolean; stdcall;
function CreateDesignPropertyTranslate_(PCDPT: PCreateDesignPropertyTranslate): THandle; stdcall;
function FreeDesignPropertyTranslate_(DesignPropertyTranslateHandle: THandle): Boolean; stdcall;
procedure GetDesignPropertyTranslates_(Owner: Pointer; Proc: TGetDesignPropertyTranslateProc); stdcall;
// ----------- DesignPropertyRemove --------------------------
procedure AddToListDesignPropertyRemoves;
procedure ClearListDesignPropertyRemoves;
function isValidDesignPropertyRemove_(DesignPropertyRemoveHandle: THandle): Boolean; stdcall;
function CreateDesignPropertyRemove_(PCDPR: PCreateDesignPropertyRemove): THandle; stdcall;
function FreeDesignPropertyRemove_(DesignPropertyRemoveHandle: THandle): Boolean; stdcall;
procedure GetDesignPropertyRemoves_(Owner: Pointer; Proc: TGetDesignPropertyRemoveProc); stdcall;
// ----------- DesignPropertyEditor --------------------------
procedure ClearListDesignPropertyEditors;
function isValidDesignPropertyEditor_(DesignPropertyEditorHandle: THandle): Boolean; stdcall;
function CreateDesignPropertyEditor_(PCDPE: PCreateDesignPropertyEditor): THandle; stdcall;
function FreeDesignPropertyEditor_(DesignPropertyEditorHandle: THandle): Boolean; stdcall;
// ----------- DesignComponentEditor --------------------------
procedure ClearListDesignComponentEditors;
function isValidDesignComponentEditor_(DesignComponentEditorHandle: THandle): Boolean; stdcall;
function CreateDesignComponentEditor_(PCDCE: PCreateDesignComponentEditor): THandle; stdcall;
function FreeDesignComponentEditor_(DesignComponentEditorHandle: THandle): Boolean; stdcall;
// ----------- DesignCodeTemplate --------------------------
procedure ClearListDesignCodeTemplates;
function isValidDesignCodeTemplate_(DesignCodeTemplateHandle: THandle):Boolean; stdcall;
function CreateDesignCodeTemplate_(PCDCT: PCreateDesignCodeTemplate): THandle; stdcall;
function FreeDesignCodeTemplate_(DesignCodeTemplateHandle: THandle): Boolean; stdcall;
procedure GetDesignCodeTemplates_(Owner: Pointer; Proc: TGetDesignCodeTemplateProc); stdcall;
function GetDesignCodeTemplateCodeByName_(DesignCodeTemplateName: PChar): PChar; stdcall;
// ----------- DesignFormTemplate --------------------------
procedure ClearListDesignFormTemplates;
function isValidDesignFormTemplate_(DesignFormTemplateHandle: THandle):Boolean; stdcall;
function CreateDesignFormTemplate_(PCDFT: PCreateDesignFormTemplate): THandle; stdcall;
function FreeDesignFormTemplate_(DesignFormTemplateHandle: THandle): Boolean; stdcall;
procedure GetDesignFormTemplates_(Owner: Pointer; Proc: TGetDesignFormTemplateProc); stdcall;
function GetDesignFormTemplateFormByName_(DesignFormTemplateName: PChar): PChar; stdcall;

// ----------- ReadAndWriteParams --------------------------
function isExistsParam_(Section,Param: PChar): Boolean; stdcall;
procedure WriteParam_(Section,Param: PChar; Value: Variant); stdcall;
function ReadParam_(Section,Param: PChar; Default: Variant): Variant; stdcall;
procedure ClearParams_; stdcall;
procedure SaveParams_; stdcall;
procedure LoadParams_; stdcall;
function EraseParams_(Section: PChar): Boolean; stdcall;
function SaveParamsToFile_(PSPTF: PSaveParamsToFile): Boolean; stdcall;
function LoadParamsFromFile_(PLPFF: PLoadParamsFromFile): Boolean; stdcall;

// ----------- InterpreterConsts --------------------------
procedure ClearListInterpreterConsts;
function IsValidInterpreterConst_(InterpreterConstHandle: THandle): Boolean; stdcall;
function CreateInterpreterConst_(PCIC: PCreateInterpreterConst): THandle; stdcall;
function FreeInterpreterConst_(InterpreterConstHandle: THandle): Boolean; stdcall;
procedure GetInterpreterConsts_(Owner: Pointer; Proc: TGetInterpreterConstProc); stdcall;
// ----------- InterpreterClasses --------------------------
procedure ClearListInterpreterClasses;
function IsValidInterpreterClass_(InterpreterClassHandle: THandle): Boolean; stdcall;
function CreateInterpreterClass_(PCICL: PCreateInterpreterClass): THandle; stdcall;
function FreeInterpreterClass_(InterpreterClassHandle: THandle): Boolean; stdcall;
function CreateInterpreterClassMethod_(InterpreterClassHandle: THandle; PCICM: PCreateInterpreterClassMethod): THandle; stdcall;
function FreeInterpreterClassMethod_(InterpreterClassMethodHandle: THandle): Boolean; stdcall;
function CreateInterpreterClassProperty_(InterpreterClassHandle: THandle; PCICP: PCreateInterpreterClassProperty): THandle; stdcall;
function FreeInterpreterClassProperty_(InterpreterClassPropertyHandle: THandle): Boolean; stdcall;
procedure GetInterpreterClasses_(Owner: Pointer; Proc: TGetInterpreterClassProc); stdcall;
// ----------- InterpreterFuns --------------------------
procedure ClearListInterpreterFuns;
function IsValidInterpreterFun_(InterpreterFunHandle: THandle): Boolean; stdcall;
function CreateInterpreterFun_(PCIP: PCreateInterpreterFun): THandle; stdcall;
function FreeInterpreterFun_(InterpreterFunHandle: THandle): Boolean; stdcall;
procedure GetInterpreterFuns_(Owner: Pointer; Proc: TGetInterpreterFunProc); stdcall;
// ----------- InterpreterEvents --------------------------
procedure ClearListInterpreterEvents;
function IsValidInterpreterEvent_(InterpreterEventHandle: THandle): Boolean; stdcall;
function CreateInterpreterEvent_(PCIE: PCreateInterpreterEvent): THandle; stdcall;
function FreeInterpreterEvent_(InterpreterEventHandle: THandle): Boolean; stdcall;
procedure GetInterpreterEvents_(Owner: Pointer; Proc: TGetInterpreterEventProc); stdcall;
// ----------- InterpreterVars --------------------------
procedure AddToListInterpreterVars;
procedure ClearListInterpreterVars;
function IsValidInterpreterVar_(InterpreterVarHandle: THandle): Boolean; stdcall;
function CreateInterpreterVar_(PCIV: PCreateInterpreterVar): THandle; stdcall;
function FreeInterpreterVar_(InterpreterVarHandle: THandle): Boolean; stdcall;
procedure GetInterpreterVars_(Owner: Pointer; Proc: TGetInterpreterVarProc); stdcall;
// ----------- LibraryInterpreter --------------------------
procedure ClearListLibraryInterpreters;
function IsValidLibraryInterpreter_(LibraryInterpreterHandle: THandle): Boolean; stdcall;
function CreateLibraryInterpreter_(PCLI: PCreateLibraryInterpreter): THandle; stdcall;
function FreeLibraryInterpreter_(LibraryInterpreterHandle: THandle): Boolean; stdcall;
function GetLibraryInterpreterHandleByGUID_(GUID: PChar): THandle; stdcall;
procedure GetLibraryInterpreters_(Owner: Pointer; Proc: TGetLibraryInterpreterProc); stdcall;
function CallLibraryInterpreterFun_(InterpreterHandle: THandle; Instance: TObject; Args: TArguments; FunName: PChar): Variant; stdcall;
// ----------- AboutMarquee --------------------------
procedure ClearListAboutMarquees;
function IsValidAboutMarquee_(AboutMarqueeHandle: THandle): Boolean; stdcall;
function CreateAboutMarquee_(PCAM: PCreateAboutMarquee): THandle; stdcall;
function FreeAboutMarquee_(AboutMarqueeHandle: THandle): Boolean; stdcall;
procedure GetAboutMarquees_(Owner: Pointer; Proc: TGetAboutMarqueeProc); stdcall;



implementation

uses UMain, tsvgauge, ActiveX, UOptions, UEnterPeriod, UMainOptions,
     tsvDbGrid,  tsvPicture, UChangePassword, UAbout, 
     ULog, extctrls, dsgnintf, IB, tsvLog,
     URBConsts, URBQuery, tsvLogControls, tsvSecurity, tsvCrypter, tsvDb,
     tsvInterbase;

procedure AddToListDialogClassesAll;
begin
  ListDialogClasses.Add('TButton');
  ListDialogClasses.Add('TBitBtn');
end;

function inListDialogClasses(ClassName: string): Boolean;
var
  val: Integer;
begin
  val:=ListDialogClasses.IndexOf(ClassName);
  Result:=val<>-1;
end;

function inListErrorClasses(ClassName: string): Boolean;
var
  val: Integer;
begin
  val:=ListErrorClasses.IndexOf(ClassName);
  Result:=val<>-1;
end;

procedure AddToListErrorClasses;
begin
  ListErrorClasses.Add('EIBError');
//  ListErrorClasses.Add('EIBInterBaseError');
//  ListErrorClasses.Add('EIBClientError');
  ListErrorClasses.Add('EAccessViolation');
end;

function InitAll: Boolean;
var
  TCAM: TCreateAboutMarquee;
begin
  Result:=false;
  FSecurity:=TtsvSecurity.Create;

  if not TryIBLoad then begin
   ShowErrorEx(ConstInterbaseNotExists);
   exit;
  end;
  
  CoInitialize(nil);

  MainLog:=TLog.Create(nil);
  
  MemIniFile:=TTSVMemIniFile.Create;
  ListLibs:=TList.Create;
  ListDialogClasses:=TStringList.Create;

  SQLMonitor:=TIBSQLMonitor.Create(nil);
  SQLMonitor.Enabled:=false;
  SQLMonitor.TraceFlags:=[];

  Application.Name:=ConstApplicationName;
  IBDB:=TIBDataBase.Create(nil);
  TIBDataBase(IBDB).LoginPrompt:=false;
  IBDB.SQLDialect:=3;
  IBDB.Name:=ConstMainDataBaseName;
  IBDB.TraceFlags:=[tfQPrepare, tfQExecute, tfQFetch, tfError, tfStmt, tfConnect, tfTransact, tfBlob, tfService, tfMisc];

  IBT:=TIBTransaction.Create(nil);
  IBT.DefaultDatabase:=IBDB;
  IBT.Params.Text:=DefaultTransactionParamsTwo;
  TIBDataBase(IBDB).DefaultTransaction:=IBT;
  IBT.DefaultAction:=TACommit;

  IBDBLogin:=TIBDataBase.Create(nil);
  IBDBLogin.LoginPrompt:=false;
  IBDBLogin.SQLDialect:=3;
  IBDBLogin.TraceFlags:=[tfQPrepare, tfQExecute, tfQFetch, tfError, tfStmt, tfConnect, tfTransact, tfBlob, tfService, tfMisc];

  IBTLogin:=TIBTransaction.Create(nil);
  IBTLogin.DefaultDatabase:=IBDBLogin;
  IBTLogin.Params.Text:=DefaultTransactionParamsTwo;
  IBDBLogin.DefaultTransaction:=IBTLogin;
  IBTLogin.DefaultAction:=TACommit;

  AddToListDialogClassesAll;

  ListCachePermission:=TList.Create;
  ListCachePermissionColumn:=TList.Create;

  ListErrorClasses:=TStringList.Create;
  AddToListErrorClasses;

  HotKeyUpperCase:=ShortCut(Word('U'),[ssCtrl,ssAlt]);
  HotKeyLowerCase:=ShortCut(Word('L'),[ssCtrl,ssAlt]);
  HotKeyToRussian:=ShortCut(Word('R'),[ssCtrl,ssAlt]);
  HotKeyToEnglish:=ShortCut(Word('E'),[ssCtrl,ssAlt]);
  HotKeyFirstUpperCase:=ShortCut(Word('F'),[ssCtrl,ssAlt]);
  HotKeyTrimSpaceForOne:=ShortCut(Word('T'),[ssCtrl,ssAlt]);

  TempDir:=ExtractFileDir(Application.Exename)+'\Temp';

  RBTableFont:=TFont.Create;
  MnOption.RBTableFont:=RBTableFont;
  MnOption.RBTableRecordColor:=clBlack;
  MnOption.RBTableCursorColor:=clHighlight;
  MnOption.RbFilterColor:=ConstColorFilter;
  MnOption.DirTemp:=PChar(TempDir);
  FormFont:=TFont.Create;
  MnOption.FormFont:=FormFont;
  MnOption.VisibleFindPanel:=true;
  MnOption.VisibleEditPanel:=true;
  MnOption.ElementFocusColor:=ConstColorFocused;
  MnOption.TypeFilter:=tdbfAnd;
  MnOption.ElementLabelFocusColor:=ConstColorLabelFocused;

  tmpBounds.State:=wsMaximized;

  ListProgressBars:=TList.Create;
  ListInterfaces:=TList.Create;
  ListOptions:=TList.Create;
  ListToolBars:=Tlist.Create;
  ListToolBarsMain:=TList.Create;
  ListMenus:=TList.Create;
  ListMenusMain:=TList.Create;
  ListAdditionalLogs:=TList.Create;
  ListDesignPalettes:=TList.Create;
  ListDesignPropertyTranslates:=TList.Create;
  ListDesignPropertyRemoves:=TList.Create;
  ListDesignPropertyEditors:=TList.Create;
  ListDesignComponentEditors:=TList.Create;
  ListDesignCodeTemplates:=TList.Create;
  ListDesignFormTemplates:=TList.Create;
  ListInterpreterConsts:=TList.Create;
  ListInterpreterClasses:=TList.Create;
  ListInterpreterFuns:=TList.Create;
  ListInterpreterEvents:=TList.Create;
  ListInterpreterVars:=TList.Create;
  ListLibraryInterpreters:=TList.Create;
  ListAboutMarquees:=TList.Create;
  ListRunInterfaces:=TStringList.Create;
  ListTempLogItems:=TStringList.Create;

  TCAM.Text:=ConstAboutMarqueeWarning;
  TCAM.TypeCreate:=tcFirst;
  CreateAboutMarquee_(@TCAM);

  Result:=true;
end;

function CreateDirEx(dir: String): Boolean;

  procedure GetDirs(str: TStringList);
  var
    i: Integer;
    s,tmps: string;
  begin
    tmps:='';
    for i:=1 to Length(dir) do begin
      if dir[i]='\' then begin
        s:=tmps;
        str.Add(s);
      end;
      tmps:=tmps+dir[i];
    end;
    str.Add(Dir);
  end;

var
  str: TStringList;
  i: Integer;
  isCreate: Boolean;
begin
  str:=TStringList.Create;
  try
   isCreate:=false;
   GetDirs(str);
   for i:=0 to str.Count-1 do begin
     isCreate:=createdir(str.Strings[i]);
   end;
   Result:=isCreate;
  finally
   str.Free;
  end;
end;

procedure SetMnOption;
begin
  MnOption.DirTemp:=PChar(TempDir);
//  CreateDirEx(TempDir);
end;

procedure ClearListLibs;
var
  i: Integer;
  P: PInfoLib;
begin
  for i:=0 to ListLibs.Count-1 do begin
    P:=ListLibs.Items[i];
    dispose(p);
  end;
  ListLibs.Clear;
end;

procedure ClearListCachePermission;
var
  i: Integer;
  P: PInfoCachePerm;
begin
  for i:=0 to ListCachePermission.Count-1 do begin
   P:=ListCachePermission.Items[i];
   dispose(P);
  end;
  ListCachePermission.Clear;
end;

procedure ClearListCachePermissionColumn;
var
  i: Integer;
  P: PInfoCachePermColumn;
begin
  for i:=0 to ListCachePermissionColumn.Count-1 do begin
   P:=ListCachePermissionColumn.Items[i];
   dispose(P);
  end;
  ListCachePermissionColumn.Clear;
end;

procedure ClearAndFreeListOptionsRoot(List: TList);
var
  i: Integer;
  P: PInfoOption;
begin
  if not isValidPointer(List) then exit;
  for i:=0 to List.Count-1 do begin
    P:=List.Items[i];
    if isValidPointer(P.Bitmap) Then P.Bitmap.Free;
    ClearAndFreeListOptionsRoot(P.List);
    dispose(P);
  end;
  List.Free;
end;

procedure DeInitAll;
begin
  FreeAndNil(fmRBConst);
  IBTLogin.Free;
  IBDBLogin.Free;
  IBT.Free;
  IBDB.Free;
  SQLMonitor.Free;
  ListDialogClasses.Free;
  ClearListLibs;
  ListLibs.Free;
  ClearListCachePermission;
  ListCachePermission.Free;
  ClearListCachePermissionColumn;
  ListCachePermissionColumn.Free;
  ListErrorClasses.Free;
  CoUnInitialize;
  RBTableFont.Free;
  FormFont.Free;
  ClearListProgressBars;
  ListProgressBars.Free;
  ClearListOptions;
  ListOptions.Free;
  ListToolBarsMain.Free;
  ListToolBars.Free;
  ListMenusMain.Free;
  ListMenus.Free;
  ClearListInterfaces;
  ListInterfaces.Free;
  ClearListAdditionalLogs;
  ListAdditionalLogs.Free;
  ClearListDesignPalettes;
  ListDesignPalettes.Free;
  ClearListDesignPropertyTranslates;
  ListDesignPropertyTranslates.Free;
  ClearListDesignPropertyRemoves;
  ListDesignPropertyRemoves.Free;
  ClearListDesignPropertyEditors;
  ListDesignPropertyEditors.Free;
  CLearListDesignComponentEditors;
  ListDesignComponentEditors.Free;
  CLearListDesignCodeTemplates;
  ListDesignCodeTemplates.Free;
  CLearListDesignFormTemplates;
  ListDesignFormTemplates.Free;
  ClearListInterpreterConsts;
  ListInterpreterConsts.Free;
  ClearListInterpreterClasses;
  ListInterpreterClasses.Free;
  ClearListInterpreterFuns;
  ListInterpreterFuns.Free;
  ClearListInterpreterEvents;
  ListInterpreterEvents.Free;
  ClearListInterpreterVars;
  ListInterpreterVars.Free;
  ClearListLibraryInterpreters;
  ListLibraryInterpreters.Free;
  ClearListAboutMarquees;
  ListAboutMarquees.Free;
  ListRunInterfaces.Free;
  ListTempLogItems.Free;
  FreeAndNil(MemIniFile);
  FreeAndNIl(MainLog);
  FSecurity.Free;
end;

procedure UpdateServer;
var
  Database: TIBDataBase;
  Transaction: TIBTransaction;

  procedure GrantToPublic;
  begin
    ExecSql(Database,SGrantToPublic);
  end;

  procedure CreateUserConnect;
  var
    Srvname: array[0..ConstSrvName-1] of char;
    protocol: TProtocol;
    Security: TIBSecurityService;
    i: Integer;
    FlagExists: Boolean;
  begin
    Security:=TIBSecurityService.Create(nil);
    try
      FillChar(Srvname,ConstSrvName,0);
      _GetProtocolAndServerName(PChar(Database.DatabaseName),protocol,Srvname);
      Security.ServerName:=Srvname;
      Security.Protocol:=protocol;
      Security.LoginPrompt:=False;
      Security.Params.Clear;
      Security.Params.Add('user_name='+SwitchUpdateServerParam1);
      Security.Params.Add('password='+SwitchUpdateServerParam2);
      Security.Active:=true;
      if Security.Active then begin
        FlagExists:=false;
        Security.DisplayUser(ConstConnectUserName);
        for i:=0 to Security.UserInfoCount-1 do begin
          if AnsiSameText(Security.UserInfo[i].UserName,ConstConnectUserName) then
             FlagExists:=true;
        end;
        Security.UserName:=ConstConnectUserName;
        Security.Password:=ConstConnectUserPass;
        if not FlagExists then begin
          Security.AddUser;
        end else begin
          Security.ModifyUser;
        end;  
      end;  
    finally
      Security.Free;
    end;  
  end;

begin
  if FileExists(SwitchUpdateServerParam3) then begin
    try
      Database:=TIBDataBase.Create(nil);
      Transaction:=TIBTransaction.Create(nil);
      try
        Database.LoginPrompt:=false;
        Database.SQLDialect:=3;
        Transaction.DefaultDatabase:=Database;
        Transaction.Params.Text:=DefaultTransactionParamsTwo;
        Database.DefaultTransaction:=Transaction;
        Transaction.DefaultAction:=TACommit;

        Database.Connected:=false;
        Database.DatabaseName:=SwitchUpdateServerParam3;
        Database.LoginPrompt:=false;
        Database.Params.Clear;
        Database.Params.Add('user_name='+SwitchUpdateServerParam1);
        Database.Params.Add('password='+SwitchUpdateServerParam2);
        Database.Params.Add(ConstCodePage);

        Database.Connected:=true;
        Transaction.Active:=Database.Connected;

        if Database.Connected then begin
          GrantToPublic;
          CreateUserConnect;
        end;

      finally
        Transaction.Free;
        Database.Free;
      end;
    except
      on E: Exception do begin
        ShowError(Application.Handle,E.Message);
      end;
    end;  
  end;
end;

procedure SwitchParams(var IsExit: Boolean);
var
  i: Integer;
  s: string;
begin
  for i:=0 to ParamCount-1 do begin
    s:=ParamStr(i+1);
    if i=0 then begin
      isSwitchNewConnect:=AnsiSameText(s,SwitchNewConnect);
      isSwitchNoOptions:=AnsiSameText(s,SwitchNoOptions);
      isSwitchPathFile:=AnsiSameText(s,SwitchPathFile);
      isSwitchPackFile:=AnsiSameText(s,SwitchPackFile);
      isSwitchInclination:=AnsiSameText(s,SwitchInclination);
      isSwitchRuncount:=AnsiSameText(s,SwitchRuncount);
      isSwitchUpdateServer:=AnsiSameText(s,SwitchUpdateServer);
    end;
    if i=1 then begin

      if isSwitchPathFile then begin
        SwitchPathFileParam1:=s;
      end else SwitchPathFileParam1:='';

      if isSwitchPackFile then begin
        CheckMoreApplications:=false;
        SwitchPackFileParam1:=s;
      end else SwitchPackFileParam1:='';

      if isSwitchUpdateServer then
        SwitchUpdateServerParam1:=s
      else SwitchUpdateServerParam1:='';

    end;
    if i=2 then begin

      if isSwitchUpdateServer then
        SwitchUpdateServerParam2:=s
      else SwitchUpdateServerParam2:='';

    end;
    if i=3 then begin

      if isSwitchUpdateServer then
        SwitchUpdateServerParam3:=s
      else SwitchUpdateServerParam3:='';

    end;
  end;
  if isSwitchInclination or
     isSwitchRuncount then
    IsExit:=true;

  if isSwitchUpdateServer then begin
    UpdateServer;
    IsExit:=true;
  end;  
end;

function MoreApplications: Boolean;
var
  ret: DWord;
begin
  result:=false;
  MutexHan:=CreateMutex(nil,false,Pchar(STBasisMutex));
  ret:=GetLastError;
  if ret=ERROR_ALREADY_EXISTS then begin
    if  ShowQuestionEx(Format(ConstApplicationExists,[MainCaption]))=mrYes then begin
      Result:=True;
    end else begin
      PostMessage(HWND_BROADCAST, MessageId,0,0);
    end;
  end else result:=true;
end;

function isCorrectApplicationExeName: Boolean;
var
  tmps: string;
begin
  Result:=false;
  try
   tmps:=ExtractFileName(Application.ExeName);
   if AnsiUpperCase(MainExe)=AnsiUpperCase(tmps) then begin
     Result:=true;
   end;
  except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

procedure EmptyDir(dir: string);
var
  str: TStringList;
  pb: THandle;
  TCPB: TCreateProgressBar;
  TSPBS: TSetProgressBarStatus;
  i: Integer;
  S: String;
begin
  str:=TStringList.Create;
  GetDirFiles(dir,str,'*.*');
  if str.Count=0 then exit;
  FillChar(TCPB,SizeOf(TCPB),0);
  TCPB.Min:=0;
  TCPB.Max:=str.Count;
  TCPB.Hint:=ConstEmptyDir;
  pb:=CreateProgressBar_(@TCPB);
  try
    FillChar(TSPBS,SizeOf(TSPBS),0);
    for i:=0 to str.Count-1 do begin
      S:=str.Strings[i];
      FileSetAttr(S,DDL_READWRITE);
      DeleteFile(S);
      TSPBS.Progress:=i;
      TSPBS.Max:=str.Count;
      SetProgressBarStatus_(pb,@TSPBS);
    end;
  finally
    FreeProgressBar_(pb);
    str.Free;
  end;
end;

procedure GetDirFiles(Dir: String; str: TStringList; Mask: string);
var
  AttrWord: Word;
  FMask: string;
  MaskPtr: PChar;
  Ptr: PChar;
  FileInfo: TSearchRec;
  lastdir: string;
begin
  lastdir:=Dir;
  if Trim(Dir)<>'' then begin
    if Dir[Length(Dir)]='\' then
     delete(Dir,Length(Dir),1);
  end;
  if not DirectoryExists(Dir) then exit;
  AttrWord := faAnyFile+SysUtils.faReadOnly+faHidden+faSysFile+faVolumeID+faArchive;
  if not SetCurrentDir(lastdir) then exit;
    FMask:=Mask;
    try
      MaskPtr := PChar(FMask);
      while MaskPtr <> nil do
      begin
        Ptr := StrScan (MaskPtr, ';');
        if Ptr <> nil then
          Ptr^ := #0;
        if FindFirst(MaskPtr, AttrWord, FileInfo) = 0 then
        begin
          repeat
             if (FileInfo.Name<>'.') and (FileInfo.Name<>'..') then begin
               str.Add(ExpandFileName(FileInfo.Name));
             end;
          until FindNext(FileInfo) <> 0;
          FindClose(FileInfo);
        end;
        if Ptr <> nil then
        begin
          Ptr^ := ';';
          Inc (Ptr);
        end;
        MaskPtr := Ptr;
      end;
    finally

    end;
end;

function ReadLibraryActive(ExeName: String): Boolean;
begin
  Result:=false;
  try
    Result:=ReadParam(ConstSectionLibraryActive,ExeName,true);
  except
   {$IFDEF DEBUG} on E: Exception do if isAppLoaded then Assert(false,E.message); {$ENDIF}
  end;
end;

procedure SaveLibraryActive(ExeName: String; isActive: Boolean);
begin
  try
    WriteParam(ConstSectionLibraryActive,ExeName,isActive);
  except
   {$IFDEF DEBUG} on E: Exception do if isAppLoaded then Assert(false,E.message); {$ENDIF}
  end;
end;

procedure UpdateSecurity(Dll: string);
var
  Sec: TtsvSecurity;
  Crypter: TtsvCrypter;
  FileName: String;
  Key: String;
begin
  try
    Sec:=TtsvSecurity.Create;
    Crypter:=TtsvCrypter.Create(nil);
    try
      FileName:=ChangeFileExt(Dll,'.db');
      if FileExists(FileName) then begin
        FileName:=ExtractFileName(FileName);
        FileName:=ChangeFileExt(FileName,'');
        if Length(FileName)>0 then
          FileName:=AnsiUpperCase(FileName[1])+Copy(FileName,2,Length(FileName));
        Key:=Crypter.HashString(FileName,DefaultHashAlgorithm,DefaultHashFormat);
        Sec.Key:=Key;
        Sec.LoadDbByDllFile(dll);
        Sec.SwitchParams;
        Sec.SaveDb;
      end;
    finally
      Crypter.Free;
      Sec.Free;
    end;
  except
  end;   
end;

procedure UpdateNeedLibSecurity;
var
  str: TStringList;
  Dir: string;
  Mask: string;
  i: integer;
  dll: string;
  Ret: DWord;
  AHandle: THandle;
begin
 try
  str:=TStringList.Create;
  AHandle:=0;
  try

    AHandle:=CreateMutex(nil,false,Pchar(STBasisMutexUpdateNeedLibSecurity));
    Ret:=GetLastError;
    if Ret=ERROR_ALREADY_EXISTS then begin
      AHandle:=OpenMutex(SYNCHRONIZE,false,Pchar(STBasisMutexUpdateNeedLibSecurity));
      WaitForSingleObject(AHandle,INFINITE);
    end;

    dir:=EXtractFileDir(Application.ExeName);
    Mask:=ConstExtModules;
    GetDirFiles(dir,str,Mask);
    str.Sort;
    for i:=0 to str.Count-1 do begin
      dll:=str.Strings[i];
      UpdateSecurity(Dll);
    end;
    
  finally
    ReleaseMutex(AHandle);
    str.Free;
  end;
 except
 end;
end;

function LoadNeedLib: Boolean;
var
  str: TStringList;
  Dir: string;
  Mask: string;
  i: integer;
  dll: string;
  Ret: DWord;
  AHandle: THandle;
begin
 Result:=true;
 try
  Screen.Cursor:=crAppStart;
  str:=TStringList.Create;
  AHandle:=0;
  try

    AHandle:=CreateMutex(nil,false,Pchar(STBasisMutexLoadDll));
    Ret:=GetLastError;
    if Ret=ERROR_ALREADY_EXISTS then begin
      AHandle:=OpenMutex(SYNCHRONIZE,false,Pchar(STBasisMutexLoadDll));
      WaitForSingleObject(AHandle,INFINITE);
    end;

    dir:=EXtractFileDir(Application.ExeName);
    Mask:=ConstExtModules;
    GetDirFiles(dir,str,Mask);
    str.Sort;
    for i:=0 to str.Count-1 do begin
      dll:=str.Strings[i];
      MainLog.Write(Format(fmtStartLoadLibrary,[Dll]),tliInformation);
      LoadDll(Dll);
    end;
    SortListDll;
  finally
    ReleaseMutex(AHandle);
    str.Free;
    Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do if isAppLoaded then Assert(false,E.message); {$ENDIF}
 end;
end;

function UnLoadDLLFromAddress(P: Pointer): Boolean;
var
  i: Integer;
  PLib: PInfoLib;
begin
  Result:=false;
  for i:=ListLibs.Count-1 downto 0 do begin
    PLib:=ListLibs.Items[i];
    if (Integer(P)>=Integer(PLib.LibHandle)) and
       (Integer(P)<=(Integer(PLib.LibHandle)+PLib.FileSize)) then begin
       // RemoveLinks
       FreeLibrary(PLib.LibHandle);
       Dispose(PLib);
       ListLibs.Delete(i);
       Result:=true;
    end; 
  end;
end;

function GetInfoLib(Dll: string): PInfoLib;
var
  P: PInfoLib;
  i: Integer;
begin
  Result:=nil;
  for i:=0 to ListLibs.Count-1 do begin
    P:=ListLibs.Items[i];
    if P.ExeName=Dll then begin
      Result:=P;
      exit;
    end;
  end;
end;

function InListLibs(Dll: string): Boolean; overload;
begin
  Result:=GetInfoLib(dll)<>nil;
end;

function InListLibs(LibHandle: THandle): Boolean; overload;
var
  i: Integer;
  P: PInfoLib;
begin
  Result:=false;
  for i:=0 to ListLibs.Count-1 do begin
    P:=ListLibs.Items[i];
    if P.LibHandle=LibHandle then begin
      Result:=true;
      exit;
    end;
  end;
end;

procedure SortListDll;
var
  ListComponents: TList;
  ListInterpreters: TList;
  ListSecurity: TList;
  ListAny: TList;
  i: Integer;
  P: PInfoLib;
begin
  ListComponents:=TList.Create;
  ListInterpreters:=TList.Create;
  ListSecurity:=TList.Create;
  ListAny:=TList.Create;
  try
    for i:=0 to ListLibs.Count-1 do begin
      P:=ListLibs.Items[i];
      case P.TypeLib of
        ttleInterpreter: ListInterpreters.Add(P);
        ttleComponents: ListComponents.Add(P);
        ttleSecurity: ListSecurity.Add(P);
      else
        ListAny.Add(P);
      end;
    end;

    ListLibs.Clear;
    for i:=0 to ListSecurity.Count-1 do
      ListLibs.Add(ListSecurity.Items[i]);
    for i:=0 to ListComponents.Count-1 do
      ListLibs.Add(ListComponents.Items[i]);
    for i:=0 to ListAny.Count-1 do
      ListLibs.Add(ListAny.Items[i]);
    for i:=0 to ListInterpreters.Count-1 do
      ListLibs.Add(ListInterpreters.Items[i]);

  finally
    ListAny.Free;
    ListSecurity.Free;
    ListInterpreters.Free;
    ListComponents.Free;
  end;
end;

function LoadDll(Dll: string): Boolean;
var
  LibH: THandle;
  InitAllDll: TInitAllProc;
  GetInfoLibrary: TGetInfoLibraryProc;
  RefreshLibrary: TRefreshLibraryProc;
  SetConnection: TSetConnectionProc;
  P: PInfoLibrary;
  isUnload: Boolean;
  S: String;
begin
 Result:=false;
 try
  LibH:=0;
  isUnload:=true;
  try
   UpdateSecurity(PChar(Dll));
   LibH:= LoadLibrary(PChar(Dll));
   if LibH=0 then RaiseLastWin32Error;

   @InitAllDll:=GetProcAddress(LibH,Pchar(ConstInitAll));
   if not isValidPointer(@InitAllDll) then begin
     exit;
   end;  

   @GetInfoLibrary:=GetProcAddress(LibH,Pchar(ConstGetInfoLibrary));
   if not IsValidPointer(@GetInfoLibrary) then begin
     exit;
   end;  

   @SetConnection:=GetProcAddress(LibH,Pchar(ConstSetConnection));
   if isValidPointer(@SetConnection) then
     SetConnection(IBDB,IBT,IBDBLogin,IBTLogin);
     
   @RefreshLibrary:=GetProcAddress(LibH,Pchar(ConstRefreshLibrary));

   new(P);
   try
     FillChar(P^,SizeOf(P^),0);
     GetInfoLibrary(p);
     S:=ExtractRelativePath(ExtractFilePath(Application.Exename),Dll);
     isUnload:=not ReadLibraryActive(S);
     if P.StopLoad then
       isUnload:=P.StopLoad;
     if not IsUnload then begin
       InitAllDll;
     end;
     AddToListLibs(LibH,Dll,P.Hint,
                   RefreshLibrary,
                   SetConnection,
                   P.TypeLib,
                   P.Programmers,
                   not isUnload,
                   P.StopLoad,
                   P.Condition);
     Result:=not isUnload;
   finally
     dispose(P);
   end;
  finally
    if isUnload then
     if LibH<>0 then
      FreeLibrary(LibH);
    if Result then
      MainLog.Write(Format(fmtLoadingLibrarySuccess,[Dll]),tliInformation)
    else
      MainLog.Write(Format(fmtLoadingLibraryFailed,[Dll]),tliWarning);    
  end;
 except
  {$IFDEF DEBUG} on E: Exception do if isAppLoaded then Assert(false,E.message); {$ENDIF}
 end;
end;

procedure AddToListLibs(LibHandle: THandle; Dll: String; Hint: String;
                        RefreshLibrary: TRefreshLibraryProc;
                        SetConnection: TSetConnectionProc;
                        TypeLib: TTypeLib;
                        Programmers: String;
                        Active: Boolean;
                        StopLoad: Boolean;
                        Condition: String);

   function GetLocalFileSize: Integer;
   var
     h: THandle;
     lpReOpenBuff: TOFStruct;
   begin
     h:=0;
     try
       h:=OpenFile(PChar(dll),lpReOpenBuff,OF_READ);
       Result:=GetFileSize(h,nil);
     finally
       CloseHandle(h);
     end;
   end;

var
  P: PInfoLib;
begin
 try
  New(P);
  FillChar(P^,sizeof(TInfoLib),0);
  P.Active:=Active;
  P.StopLoad:=StopLoad;
  if StopLoad then begin
    P.LibHandle:=LibHandle;
    P.FileSize:=GetLocalFileSize();
    P.RefreshLibrary:=RefreshLibrary;
    P.SetConnection:=SetConnection;
  end;
//  P.ExeName:=Dll;
  P.ExeName:=ExtractRelativePath(ExtractFilePath(Application.Exename),Dll);
  P.Hint:=Hint;
  P.TypeLib:=TypeLib;
  P.Programmers:=Programmers;
  P.Condition:=Condition;
  ListLibs.Add(P);
 except
  {$IFDEF DEBUG} on E: Exception do if isAppLoaded then Assert(false,E.message); {$ENDIF}
 end; 
end;              

function ConnectServer(dbName,usName,usPass,sqlRole: String; WithError: Boolean=true): Boolean;
var
  IB: TIBDatabase;
begin
  Result:=false;
  try
   IB:=TIBDatabase.Create(nil);
   Screen.Cursor:=crHourGlass;
   try

    IB.DatabaseName:=dbname;
    IB.LoginPrompt:=false;
    IB.Params.Add('user_name='+usName);
    IB.Params.Add('password='+usPass);
    IB.Params.Add(ConstCodePage);
    if trim(sqlRole)<>'' then begin
     IB.Params.Add('sql_role_name='+sqlRole);
    end;
    IB.Connected:=true;
    result:=IB.Connected;
   finally
    IB.Free;
    Screen.Cursor:=crDefault;
   end;
  except
   on E: Exception do begin
     if WithError then
       ShowErrorEx(E.Message);
   end;  
   //{$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

function GetWinDir: string;
var
  wd: PChar;
  WinDir:String;
begin
  Result:='';
  GetMem(wd,256);
  GetWindowsDirectory(wd,256);
  WinDir:=StrPas(wd);
  FreeMem(wd,256);
  result:=WinDir;
end;

function GetIniFileName: String;
var
  s: string;
begin
  s:=GetWinDir+'\'+ExtractFileName(AppliCation.ExeName);
  Delete(s,Length(s)-3,4);
  s:=s+'.ini';
  result:=s;
end;

procedure MainLoadFromIni;


  procedure LoadOptions;
  var
    cf: TComponentFont;
    tmps: string;
  begin
    MnOption.isEditRBOnSelect:=ReadParam_(ConstSectionMain,'isEditRBOnSelect',MnOption.isEditRBOnSelect);
    MnOption.RBTableRecordColor:=ReadParam_(ConstSectionMain,'RBTableRecordColor',MnOption.RBTableRecordColor);
    MnOption.RBTableCursorColor:=ReadParam_(ConstSectionMain,'RBTableCursorColor',MnOption.RBTableCursorColor);
    MnOption.RbFilterColor:=ReadParam_(ConstSectionMain,'RbFilterColor',MnOption.RbFilterColor);
    MnOption.VisibleRowNumber:=ReadParam_(ConstSectionMain,'VisibleRowNumber',MnOption.VisibleRowNumber);
    MnOption.VisibleFindPanel:=ReadParam_(ConstSectionMain,'VisibleFindPanel',MnOption.VisibleFindPanel);
    MnOption.VisibleEditPanel:=ReadParam_(ConstSectionMain,'VisibleEditPanel',MnOption.VisibleEditPanel);
    MnOption.ElementFocusColor:=ReadParam_(ConstSectionMain,'ElementFocusColor',MnOption.ElementFocusColor);
    MnOption.TypeFilter:=ReadParam_(ConstSectionMain,'TypeFilter',MnOption.TypeFilter);
    cf:=TComponentFont.Create(nil);
    try
      tmps:=cf.GetFontAsHexStr;
      cf.SetFontFromHexStr(ReadParam_(ConstSectionMain,'RBTableFont',tmps));
      MnOption.RBTableFont.Assign(cf.Font);
      cf.SetFontFromHexStr(ReadParam_(ConstSectionMain,'FormFont',tmps));
      MnOption.FormFont.Assign(cf.Font);
    finally
      cf.Free;
    end;
  end;

  procedure LoadMainFormBounds;
  begin
    tmpBounds.Left:=ReadParam_(ConstSectionMain,'L',tmpBounds.Left);
    tmpBounds.Top:=ReadParam_(ConstSectionMain,'T',tmpBounds.Top);
    tmpBounds.Width:=ReadParam_(ConstSectionMain,'W',tmpBounds.Width);
    tmpBounds.Height:=ReadParam_(ConstSectionMain,'H',tmpBounds.Height);
    if not isMaximizedMainWindow then
     tmpBounds.State:=TWindowState(ReadParam_(ConstSectionMain,'WS',Integer(tmpBounds.State)))
    else tmpBounds.State:=wsMaximized;
  end;

var
  S: String;
begin
 try
  isLastOpen:=ReadParam_(ConstSectionMain,'isLastOpen',isLastOpen);
  isMaximizedMainWindow:=ReadParam_(ConstSectionMain,'isMaximizedMainWindow',isMaximizedMainWindow);
  S:=MnOption.DirTemp;
  TempDir:=ReadParam_(ConstSectionMain,'TempDir',S);
  LogFileName:=ReadParam_(ConstSectionMain,'LogFileName',LogFileName);
  isVisibleSplash:=ReadParam_(ConstSectionMain,'isVisibleSplash',isVisibleSplash);
  isVisibleSplashVerison:=ReadParam_(ConstSectionMain,'isVisibleSplashVerison',isVisibleSplashVerison);
  isVisibleSplashStatus:=ReadParam_(ConstSectionMain,'isVisibleSplashStatus',isVisibleSplashStatus);

  LoadMainFormBounds;
  SetMnOption;
  LoadOptions;
 except
  {$IFDEF DEBUG} on E: Exception do if isAppLoaded then Assert(false,E.message); {$ENDIF}
 end;
end;

procedure MainLoadFromIniAfterCreateAll;

  procedure LoadLastOpen;
  var
    tmps: string;
    List: TStringList;

    procedure GetListLastOpen;
    var
      Apos: Integer;
      newstr: string;
      val: string;
      curIndex: Integer;
      s: string;
    const
      ch=',';
    begin
      newstr:=tmps;
      if Trim(newstr)='' then exit;
      Apos:=-1;
      while Apos<>0 do begin
        Apos:=Pos(ch,newstr);
        if Apos>0 then begin
          s:=Copy(newstr,1,Apos-1);
          val:=HexStrToStr(s);
          curIndex:=Apos+Length(ch);
          newstr:=Copy(newstr,curIndex,Length(newstr)-APos);
          if List.IndexOf(val)=-1 then
            List.Add(val);
        end else
          List.Add(HexStrToStr(newstr));
      end;
    end;

  var
    i: Integer;
    h: THandle;
  begin
    List:=TStringList.Create;
    try
     tmps:=ReadParam_(ConstSectionMain,'LastOpen','');
     GetListLastOpen;
     for i:=0 to List.Count-1 do begin
       h:=GetInterfaceHandleFromName_(PChar(List.Strings[i]));
       ViewInterfaceWithDefaultParam(h)
     end;
    finally
      List.Free;
    end;
  end;

  procedure LoadHotKey;

     procedure LoadMenuHotKey(miParent: TMenuItem);
     var
       i: Integer;
       mi: TMenuItem;
     begin
       for i:=0 to miParent.Count-1 do begin
         mi:=miParent.Items[i];
         if not (mi is TNewMenuItem) then
          if mi.Visible then
           if mi.Count=0 then begin
            if (mi.Name<>'') and (mi.Caption<>'-') then
             mi.ShortCut:=ReadParam_(ConstSectionHotKey,PChar(mi.Name),mi.ShortCut);
           end else begin
            LoadMenuHotKey(mi);
           end;
       end;
     end;

   var
     i: Integer;
     mi: TMenuItem;
   begin
     for i:=0 to fmMain.mm.Items.Count-1 do begin
       mi:=fmMain.mm.Items[i];
       if not(mi is TNewMenuItem) then
        LoadMenuHotKey(mi);
     end;

     HotKeyUpperCase:=ReadParam_(ConstSectionHotKey,'HotKeyUpperCase',HotKeyUpperCase);
     HotKeyLowerCase:=ReadParam_(ConstSectionHotKey,'HotKeyLowerCase',HotKeyLowerCase);
     HotKeyToRussian:=ReadParam_(ConstSectionHotKey,'HotKeyToRussian',HotKeyToRussian);
     HotKeyToEnglish:=ReadParam_(ConstSectionHotKey,'HotKeyToEnglish',HotKeyToEnglish);
     HotKeyFirstUpperCase:=ReadParam_(ConstSectionHotKey,'HotKeyFirstUpperCase',HotKeyFirstUpperCase);
     HotKeyTrimSpaceForOne:=ReadParam_(ConstSectionHotKey,'HotKeyTrimSpaceForOne',HotKeyTrimSpaceForOne);

     RegisterAllHotKeys;
  end;

begin
 try
  if isLastOpen then LoadLastOpen;
  LoadHotKey;
 except
 end; 
end;

procedure MainSaveToIni;

   procedure SaveLastOpen;
   var
     i: Integer;
     P: PInfoInterface;
     tmps: string;
     incr: Boolean;
   begin
     incr:=false;
     for i:=0 to ListInterfaces.Count-1 do begin
       P:=ListInterfaces.Items[i];
       if P.Visible then begin
        if not incr then tmps:=StrToHexStr(P.Name)
        else tmps:=tmps+','+StrToHexStr(P.Name);
        incr:=true;
       end;
     end;
     WriteParam_(ConstSectionMain,'LastOpen',tmps);
   end;

   procedure SaveLibraryActive;
   var
     i: Integer;
     P: PInfoLib;
   begin
     for i:=0 to ListLibs.Count-1 do begin
       P:=ListLibs.Items[i];
       WriteParam_(ConstSectionLibraryActive,PChar(P.ExeName),P.Active);
     end;
   end;

   procedure SaveHotKey;

     procedure SaveMenuHotKey(miParent: TMenuItem);
     var
       i: Integer;
       mi: TMenuItem;
     begin
       for i:=0 to miParent.Count-1 do begin
         mi:=miParent.Items[i];
         if not (mi is TNewMenuItem) then
          if mi.Visible then
           if mi.Count=0 then begin
            if (mi.Name<>'') and (mi.Caption<>'-') then
             WriteParam_(ConstSectionHotKey,PChar(mi.Name),mi.ShortCut);
           end else begin
            SaveMenuHotKey(mi);
           end;
       end;
     end;

   var
     i: Integer;
     mi: TMenuItem;
   begin
     for i:=0 to fmMain.mm.Items.Count-1 do begin
       mi:=fmMain.mm.Items[i];
       if not(mi is TNewMenuItem) then
        SaveMenuHotKey(mi);
     end;

     WriteParam_(ConstSectionHotKey,'HotKeyUpperCase',HotKeyUpperCase);
     WriteParam_(ConstSectionHotKey,'HotKeyLowerCase',HotKeyLowerCase);
     WriteParam_(ConstSectionHotKey,'HotKeyToRussian',HotKeyToRussian);
     WriteParam_(ConstSectionHotKey,'HotKeyToEnglish',HotKeyToEnglish);
     WriteParam_(ConstSectionHotKey,'HotKeyFirstUpperCase',HotKeyFirstUpperCase);
     WriteParam_(ConstSectionHotKey,'HotKeyTrimSpaceForOne',HotKeyTrimSpaceForOne);

   end;

   procedure SaveOptions;
   var
     cf: TComponentFont;
   begin
     WriteParam_(ConstSectionMain,'isEditRBOnSelect',MnOption.isEditRBOnSelect);
     WriteParam_(ConstSectionMain,'RBTableRecordColor',MnOption.RBTableRecordColor);
     WriteParam_(ConstSectionMain,'RBTableCursorColor',MnOption.RBTableCursorColor);
     WriteParam_(ConstSectionMain,'RbFilterColor',MnOption.RbFilterColor);
     WriteParam_(ConstSectionMain,'VisibleRowNumber',MnOption.VisibleRowNumber);
     WriteParam_(ConstSectionMain,'VisibleFindPanel',MnOption.VisibleFindPanel);
     WriteParam_(ConstSectionMain,'VisibleEditPanel',MnOption.VisibleEditPanel);
     WriteParam_(ConstSectionMain,'ElementFocusColor',MnOption.ElementFocusColor);
     WriteParam_(ConstSectionMain,'TypeFilter',MnOption.TypeFilter);
     cf:=TComponentFont.Create(nil);
     try
       cf.Font.Assign(MnOption.RBTableFont);
       WriteParam_(ConstSectionMain,'RBTableFont',cf.GetFontAsHexStr);
       cf.Font.Assign(MnOption.FormFont);
       WriteParam_(ConstSectionMain,'FormFont',cf.GetFontAsHexStr);
     finally
       cf.Free;
     end;
   end;

   procedure SaveMainFormBounds;
   begin
    if fmMain<>nil then begin
      WriteParam_(ConstSectionMain,'L',fmMain.Left);
      WriteParam_(ConstSectionMain,'T',fmMain.Top);
      WriteParam_(ConstSectionMain,'W',fmMain.Width);
      WriteParam_(ConstSectionMain,'H',fmMain.Height);
      WriteParam_(ConstSectionMain,'WS',Integer(fmMain.WindowState));
    end;
   end;

begin
  WriteParam_(ConstSectionMain,'TempDir',TempDir);
  WriteParam_(ConstSectionMain,'LogFileName',LogFileName);
  WriteParam_(ConstSectionMain,'isLastOpen',isLastOpen);
  WriteParam_(ConstSectionMain,'isMaximizedMainWindow',isMaximizedMainWindow);
  WriteParam_(ConstSectionMain,'isVisibleSplash',isVisibleSplash);
  WriteParam_(ConstSectionMain,'isVisibleSplashVerison',isVisibleSplashVerison);
  WriteParam_(ConstSectionMain,'isVisibleSplashStatus',isVisibleSplashStatus);

  SaveMainFormBounds;
  SaveLastOpen;
  SaveLibraryActive;
  SaveHotKey;
  SaveOptions;
end;

function ServerFound: Boolean;
var
  fm: TfmServerConnect;
begin
  if not isSwitchNewConnect then
    Result:=ConnectServer(MainDataBaseName,ConstConnectUserName,ConstConnectUserPass,'',false)
  else Result:=false;
  try
   if Result then exit;
   fm:=TfmServerConnect.Create(nil);
   try
    if fm.ShowModal=mrOk then begin
     SetSplashStatus_(ConstSplashStatusServerConnect);
     Result:=ConnectServer(fm.ConnectString,ConstConnectUserName,ConstConnectUserPass,'');
     if Result then
       MainDataBaseName:=fm.ConnectString;
    end;
   finally
    fm.Free;
   end;
 except
  {$IFDEF DEBUG} on E: Exception do if isAppLoaded then Assert(false,E.message); {$ENDIF}
 end;
end;

procedure SetSplashImage(Splash: TfmSplash);

  function GetColor(rt: TRect): TColor;
  var
    i,j: Integer;
    clTmp: TColor;
    tmps: string;
  begin
    clTmp:=clBlack;
    for i:=rt.Left to rt.Left+rt.Right do begin
      for j:=rt.Top to rt.Top+rt.Bottom do begin
        clTmp:=clTmp or fmSplash.im.Picture.Bitmap.Canvas.Pixels[i,j];
        tmps:=ColorToString(clTmp);
      end;
    end;
  //  showmessage(tmps);
    Result:=clTmp;
  end;

var
  qr: TIBQuery;
  sqls: string;
  ms: TMemoryStream;
  w,h: Integer;
  newW,newH: Integer;
begin
 if not IBDBLogin.Connected then exit;
// if not isPermissionSecurity_(tbApp,SelConst) then exit;

 if Splash=nil then exit;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  ms:=TMemoryStream.Create;
  try
   qr.Database:=IBDBLogin;
   sqls:='Select * from '+tbApp+
         ' where name='+QuotedStr(Trim(MainCaption));
   qr.SQL.Add(sqls);
   qr.Active:=true;
   if not qr.Active then exit;
   if qr.IsEmpty then exit;
   TBlobField(qr.FieldByName('image')).SaveToStream(ms);
   ms.Position:=0;
   if ms.Size>0 then begin
   
    Splash.im.Picture.Assign(nil);
    TTsvPicture(Splash.im.Picture).LoadFromStream(ms);
    w:=Splash.im.Picture.Width;
    h:=Splash.im.Picture.Height;
    if (w<=Screen.Width)and(h<=Screen.Height) then begin
      if (w>=Splash.ClientWidth)and(h>=Splash.Height) then begin
       newW:=w;
       newH:=h;
       Splash.im.Stretch:=false;
      end else begin
       newW:=Splash.im.Width;
       newH:=Splash.im.Height;
//       fmSplash.im.Stretch:=true;
      end;
    end else begin
      newW:=Splash.im.Width;
      newH:=Splash.im.Height;
  //    fmSplash.im.Stretch:=true;
    end;
    Splash.ClientWidth:=newW;
    Splash.ClientHeight:=newH;
    Splash.Left:=Screen.Width div 2- newW div 2;
    Splash.Top:=Screen.Height div 2- newH div 2;

{    fmSplash.lbStatus.Font.Color:=GetColor(fmSplash.lbStatus.BoundsRect);
    fmSplash.lbVersion.Font.Color:=GetColor(fmSplash.lbVersion.BoundsRect);
    fmSplash.lbMain.Font.Color:=GetColor(fmSplash.lbMain.BoundsRect);  }
   end;
  finally
   ms.Free;
   qr.Free;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG}
   on E: Exception do if isAppLoaded then Assert(false,E.message);
  {$ENDIF}
 end;
end;

function LoginToProgram: Boolean;
var
  fm: TfmLogin;
begin
  Result:=false;
  try
   fm:=TfmLogin.Create(nil);
   try
    if not fm.Prepeare then exit;
    fm.FillUsers;
    SetSplashStatus_(ConstSplashStatusLoginToProgramm);
    if isSwitchPackFile then begin
      fm.cbUsers.ItemIndex:=fm.cbUsers.Items.IndexOf(UserName);
      fm.edPass.Text:=UserPass;
      fm.cbAppEnter(nil);
      fm.cbApp.ItemIndex:=fm.cbApp.Items.IndexOf(AppName);
      fm.bibOkClick(nil);
      Result:=true;
    end else begin
      if fm.ShowModal=mrOk then begin
        Result:=true;
      end;
    end;  
   finally
    fm.Free;
   end;
  except
  {$IFDEF DEBUG} on E: Exception do if isAppLoaded then Assert(false,E.message); {$ENDIF}
  end;  
end;

function MainConnect(dbName,usName,usPass,sqlRole: String): Boolean;
var
  i: integer;
begin
 try
  Screen.Cursor:=crHourGlass;
  try
   for I:=0 to IBDB.TransactionCount-1 do
    if IBDB.Transactions[I]<>nil then
     IBDB.Transactions[I].Active:=False;
   TIBDatabase(IBDB).Connected:=false;
   TIBDataBase(IBDB).DatabaseName:=dbname;
   TIBDataBase(IBDB).LoginPrompt:=false;
   TIBDataBase(IBDB).Params.Clear;
   TIBDataBase(IBDB).Params.Add('user_name='+usName);
   TIBDataBase(IBDB).Params.Add('password='+usPass);
   TIBDataBase(IBDB).Params.Add(ConstCodePage);
   if trim(sqlRole)<>'' then begin
     TIBDataBase(IBDB).Params.Add('sql_role_name='+sqlRole);
   end;

   TIBDatabase(IBDB).Connected:=true;
   result:=TIBDatabase(IBDB).Connected;
   IBT.Active:=result;
  finally
   Screen.Cursor:=crDefault;
  end;
 except
  raise;
 end; 
end;

function SecurityConnect(dbName,usName,usPass,sqlRole: String): Boolean;
var
  i: integer;
begin
 try
  Screen.Cursor:=crHourGlass;
  try
   for I:=0 to IBDBLogin.TransactionCount-1 do
    IBDBLogin.Transactions[I].Active:=False;
   IBDBLogin.Connected:=false;
   IBDBLogin.DatabaseName:=dbname;
   IBDBLogin.LoginPrompt:=false;
   IBDBLogin.Params.Clear;
   IBDBLogin.Params.Add('user_name='+usName);
   IBDBLogin.Params.Add('password='+usPass);
   IBDBLogin.Params.Add(ConstCodePage);
   if trim(sqlRole)<>'' then begin
     IBDBLogin.Params.Add('sql_role_name='+sqlRole);
   end;

   IBDBLogin.Connected:=true;
   result:=IBDBLogin.Connected;
   IBTLogin.Active:=result;
  finally
   Screen.Cursor:=crDefault;
  end;
 except
  raise;
 end; 
end;

procedure UnloadNoUseLibs;
begin
end;

procedure RefreshLibs;
var
  i: Integer;
  P: PInfoLib;
begin
 try
  for i:=0 to ListLibs.Count-1 do begin
    P:=ListLibs.Items[i];
    if isValidPointer(@P.SetConnection) then begin
      P.SetConnection(IBDB,IBT,IBDBLogin,IBTLogin);
    end;
    if isValidPointer(@P.RefreshLibrary) then begin
      P.RefreshLibrary;
    end;
  end;
 except
  raise;
 end;
end;

procedure RefreshFromBase;
var
  CMLocal: TCreateMenu;
  CTBLocal: TCreateToolButton;
  Image: TBitmap;
begin
 try
  Screen.Cursor:=crHourGlass;
  try
   ClearListCachePermission;
   ClearListCachePermissionColumn;

   MainConnect(MainDataBaseName,SqlUserName,UserPass,SqlRole);
   SecurityConnect(SecurityDataBaseName,ConstConnectUserName,ConstConnectUserPass,'');

   if not isPermissionOnInterfaceView(hInterfaceConst) then begin
     if FreeMenu_(hMenuConst) then hMenuConst:=MENU_INVALID_HANDLE;
     if FreeToolButton_(hToolButtonConst) then hToolButtonConst:=TOOLBUTTON_INVALID_HANDLE;
   end else begin
     if not isValidMenu_(hMenuConst) then begin
       Image:=TBitmap.Create;
       try
        FillChar(CMLocal,SizeOf(TCreateMenu),0);
        CMLocal.Name:='&Константы';
        CMLocal.Hint:=NameRbkConst;
        fmMain.ilMM.GetBitmap(75,Image);
        CMLocal.Bitmap:=Image;
        CMLocal.MenuClickProc:=MenuClickProc;
        CMLocal.TypeCreateMenu:=tcmInsertBefore;
        CMLocal.InsertMenuHandle:=hMenuServiceBCP;
        hMenuConst:=CreateMenu_(hMenuService,@CMLocal);
       finally
         Image.Free;
       end; 
     end;
     if isValidToolBar_(hToolBarStandart) then begin
      if (not isValidToolButton_(hToolButtonConst))and(isValidMenu_(hMenuConst)) then begin
        Image:=TBitmap.Create;
        try
          FillChar(CTBLocal,SizeOf(TCreateToolButton),0);
          CTBLocal.Name:=PChar(PInfoMenu(hMenuConst).Name);
          CTBLocal.Hint:=PChar(PInfoMenu(hMenuConst).Hint);
          fmMain.ilMM.GetBitmap(PInfoMenu(hMenuConst).MenuItem.ImageIndex,Image);
          CTBLocal.Bitmap:=Image;
          CTBLocal.ToolButtonClickProc:=ToolButtonClickProc;
          hToolButtonConst:=CreateToolButton_(hToolBarStandart,@CTBLocal);
          RefreshToolBar_(hToolBarStandart);
        finally
          Image.Free;
        end;
       end;                                               
     end;

   end;

   FreeLibs;
   ClearListLibs;
   LoadNeedLib;

   
   RefreshLibs;

   PrepearMenus;
   PrepearToolBars;

 //  RunInterfacesWhereAutoRunTrue;

  finally
   SetSplashStatus_('');
   Screen.Cursor:=crDefault;
  end;
 except
   raise;
 end; 
end;

procedure FreeLibs;
var
  i: Integer;
  P: PInfoLib;
begin
 try
  for i:=0 to ListLibs.Count-1 do begin
    P:=ListLibs.Items[i];
    if P.LibHandle<>0 then begin
      FreeLibrary(P.LibHandle);
    end;
  end;
 except
  //{$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

function GetApplicationExeVersion: string;
var
  dwHandle: THandle;
  dwLen: DWord;
  lpData: Pointer;
  v1,v2,v3,v4: Word;
  tmps: string;
  VerValue: PVSFixedFileInfo;
begin
 Result:='';
 try
  dwLen:=GetFileVersionInfoSize(Pchar(Application.ExeName),dwHandle);
  if dwlen<>0 then begin
   GetMem(lpData, dwLen);
   try
    if GetFileVersionInfo(Pchar(Application.ExeName),dwHandle,dwLen,lpData) then begin
      VerQueryValue(lpData, '\', Pointer(VerValue), dwLen);
      V1 := VerValue.dwFileVersionMS shr 16;
      V2 := VerValue.dwFileVersionMS and $FFFF;
      V3 := VerValue.dwFileVersionLS shr 16;
      V4 := VerValue.dwFileVersionLS and $FFFF;
      tmps:=inttostr(V1)+'.'+inttostr(V2)+'.'+inttostr(V3)+'.'+inttostr(V4);
      result:='Версия '+tmps;
    end;
   finally
     FreeMem(lpData, dwLen);
   end;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end; 
end;

function GetSecurityDatabaseName: String;

  function Prepeare(S: string):String;
  var
    ch: char;
    tmps: string;
    i: Integer;
  begin
    tmps:='';
    for i:=1 to Length(s) do begin
      ch:=s[i];
      if ch='/' then ch:='\';
      tmps:=tmps+ch;
    end;
    Result:=tmps;
  end;

var
  IBSProp: TIBServerProperties;
  srvname: array[0..ConstSrvName-1] of char;
  protocol: TProtocol;
begin
 Result:='';
 try
  Screen.Cursor:=crHourGlass;
  IBSProp:=TIBServerProperties.Create(nil);
  try
   FillChar(srvname,ConstSrvName,0);
   GetProtocolAndServerName_(Pchar(MainDataBaseName),protocol,srvname);
   IBSProp.ServerName:=srvname;
   IBSProp.Protocol:=protocol;
   IBSProp.LoginPrompt:=false;

   IBSProp.Params.Add('user_name='+ConstConnectUserName);
   IBSProp.Params.Add('password='+ConstConnectUserPass);

   IBSProp.Active:=true;
   IBSProp.Options := [ConfigParameters];
   IBSProp.FetchConfigParams;
   Result:=SetDataBaseFromProtocolAndServerName(
             IBSProp.ConfigParams.SecurityDatabaseLocation,protocol,srvname);
   Result:=Prepeare(Result);
  finally
   IBSProp.Free;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure MainFormKeyDown_(var Key: Word; Shift: TShiftState);stdcall;
begin
 try
  if fmMain<>nil then begin
   if Assigned(fmMain.OnKeyDown) then begin
    fmMain.OnKeyDown(nil,key,shift);
   end;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end; 
end;

procedure MainFormKeyUp_(var Key: Word; Shift: TShiftState);stdcall;
begin
 try
  if fmMain<>nil then begin
    if Assigned(fmMain.OnKeyUp) then begin
      fmMain.OnKeyUp(nil,key,shift);
    end;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end; 
end;

procedure MainFormKeyPress_(var Key: Char);stdcall;
begin
 try
  if fmMain<>nil then begin
    if Assigned(fmMain.OnKeyPress) then begin
     fmMain.OnKeyPress(nil,Key);
    end;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

function GetIniFileName_: PChar; stdcall;
begin
  TempStr:=GetIniFileName;
  Result:=Pchar(TempStr);
end;

function isPermission_(sqlObject: PChar; sqlOperator: PChar): Boolean;stdcall;
begin
  Result:=isPermissionFromDB(IBDB,sqlObject,sqlOperator);
end;

procedure AddToListCachePermission(ObjName,Operator: string; Perm: Boolean);
var
  P: PInfoCachePerm;
begin
  New(P);
  P.ObjName:=ObjName;
  P.Operator:=Operator;
  P.Perm:=Perm;
  ListCachePermission.Add(P);
end;

function GetPermisionFromCache(ObjName,Operator: string; var Perm: Boolean): Boolean;

  procedure FindListObjName(List: TList);
  var
    i: Integer;
    P: PInfoCachePerm;
  begin
    for i:=0 to ListCachePermission.Count-1 do begin
      P:=ListCachePermission.Items[i];
      if AnsiSameText(P.ObjName,ObjName) then
       List.Add(P);
    end;
  end;

  function GetPermFromList(List: TList): Boolean;
  var
    i: Integer;
    P: PInfoCachePerm;
  begin
    Result:=false;
    for i:=0 to List.Count-1 do begin
      P:=List.Items[i];
      if P.Operator=Operator then begin
        Result:=true;
        Perm:=P.Perm;
        exit;
      end;
    end;
  end;
  
var
  List: TList;
begin
  List:=TList.Create;
  try
    FindListObjName(List);
    Result:=GetPermFromList(List);
  finally
   List.Free;
  end;
end;

function isPermissionSecurity_(sqlObject: PChar; sqlOperator: PChar): Boolean;stdcall;
var
  qr: TIBQuery;
  sqls: string;
  RecCount: Integer;
  Perm: Boolean;
begin
 Result:=false;
 {$IFDEF NO_USE_PERMISSION}
   Result:=true; 
   exit;
 {$ENDIF}
 try
  if not IBDBLogin.Connected then exit;
  if GetPermisionFromCache(sqlObject,sqlOperator,Perm) then begin
    Result:=Perm;
    exit;
  end;
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try
    qr.Database:=IBDBLogin;
    qr.Transaction.Active:=false;
    qr.Transaction.Active:=true;
    sqls:='select * from '+tbSysUser_Privileges+
          ' where rdb$privilege='''+sqlOperator+''' and '+
          ' rdb$relation_name='''+AnsiUpperCase(sqlObject)+''' and '+
          ' rdb$user='''+AnsiUpperCase(SQLUserName)+'''';
    qr.SQL.Clear;
    qr.SQL.Add(sqls);
    qr.Active:=true;
    RecCount:=GetRecordCount(qr);
    if RecCount<>1 then exit;
    Result:=true;
  finally
    AddToListCachePermission(sqlObject,sqlOperator,Result);
    qr.Free;
    Screen.Cursor:=crDefault;
  end;
 except
 end; 
//  Result:=isPermissionFromDB(IBDBLogin,sqlObject,sqlOperator);
end;

function isPermissionFromDB(DB: TIBDatabase; sqlObject,sqlOperator: String): Boolean;
var
  qr: TIBQuery;
  sqls: string;
  RecCount: Integer;
  Perm: Boolean;
begin
 Result:=false;
 {$IFDEF NO_USE_PERMISSION}
   Result:=true; 
   exit;
 {$ENDIF}
 try
  if not db.Connected then exit;
  sqlObject:=ChangeString(sqlObject,'"','');
  if GetPermisionFromCache(sqlObject,sqlOperator,Perm) then begin
    Result:=Perm;
    exit;
  end;
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try
    qr.Database:=db;
    qr.Transaction.Active:=false;
    qr.Transaction.Active:=true;
    sqls:='select * from '+tbSysUser_Privileges+
          ' where rdb$privilege='''+MigrateConst+''' and '+
          ' rdb$relation_name='''+AnsiUpperCase(SqlRole)+''' and '+
          ' rdb$user='''+AnsiUpperCase(SqlUserName)+'''';
    qr.SQL.Add(sqls);
    qr.Active:=true;
    RecCount:=GetRecordCount(qr);
    if RecCount<1 then exit;
    qr.Active:=false;
    sqls:='select * from '+tbSysUser_Privileges+
          ' where rdb$privilege='''+sqlOperator+''' and '+
          ' rdb$relation_name='''+AnsiUpperCase(sqlObject)+''' and '+
          ' rdb$user='''+AnsiUpperCase(SqlRole)+'''';
    qr.SQL.Clear;
    qr.SQL.Add(sqls);
    qr.Active:=true;
    RecCount:=GetRecordCount(qr);
    if RecCount<1 then exit;
    Result:=true;
  finally
    AddToListCachePermission(sqlObject,sqlOperator,Result);
    qr.Free;
    Screen.Cursor:=crDefault;
  end;
 except
 end;
end;

procedure AddToListCachePermissionColumn(ObjName,ObjColumn,Operator: string; Perm: Boolean);
var
  P: PInfoCachePermColumn;
begin
  New(P);
  P.ObjName:=ObjName;
  P.ObjColumn:=ObjColumn;
  P.Operator:=Operator;
  P.Perm:=Perm;
  ListCachePermissionColumn.Add(P);
end;

function GetPermisionColumnFromCache(ObjName,ObjColumn,Operator: string; var Perm: Boolean): Boolean;

  procedure FindListObjName(List: TList);
  var
    i: Integer;
    P: PInfoCachePermColumn;
  begin
    for i:=0 to ListCachePermissionColumn.Count-1 do begin
      P:=ListCachePermissionColumn.Items[i];
      if (P.ObjName=ObjName)and(P.ObjColumn=ObjColumn) then
       List.Add(P);
    end;
  end;

  function GetPermFromList(List: TList): Boolean;
  var
    i: Integer;
    P: PInfoCachePermColumn;
  begin
    Result:=false;
    for i:=0 to List.Count-1 do begin
      P:=List.Items[i];
      if P.Operator=Operator then begin
        Result:=true;
        Perm:=P.Perm;
        exit;
      end;
    end;
  end;
  
var
  List: TList;
begin
  List:=TList.Create;
  try
    FindListObjName(List);
    Result:=GetPermFromList(List);
  finally
   List.Free;
  end;
end;

function isPermissionColumn_(sqlObject,objColumn,sqlOperator: PChar): Boolean;stdcall;
var
  qr: TIBQuery;
  sqls: string;
  Perm: Boolean;
begin
 Result:=isPermissionSecurity_(sqlObject,sqlOperator);
 try
  if not Result then exit;
//  ClearListCachePermissionColumn;
  if GetPermisionColumnFromCache(sqlObject,objColumn,sqlOperator,Perm) then begin
    Result:=Perm;
    exit;
  end;
  Result:=false;
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try
    qr.Database:=IBDBLogin;
    qr.Transaction.Active:=false;
    qr.Transaction.Active:=true;
    sqls:='select count(*) as ctn from '+tbAppPermColumn+
          ' apc join '+tbApp+' a on apc.app_id=a.app_id'+
          ' where obj='''+AnsiUpperCase(sqlObject)+''' and '+
          ' col='''+AnsiUpperCase(objColumn)+''' and '+
          ' a.name='''+MainCaption+''' and '+
          ' Upper(perm)='''+AnsiUpperCase(sqlOperator)+'''';
    qr.SQL.Add(sqls);
    qr.Active:=true;
    if not qr.IsEmpty then begin
     Result:=qr.FieldByName('ctn').AsInteger>0;
    end;
  finally
    AddToListCachePermissionColumn(sqlObject,objColumn,sqlOperator,Result);
    qr.Free;
    Screen.Cursor:=crDefault;
  end;
 except
 end; 
end;

procedure SetSplashStatus_(Status: Pchar);stdcall;
begin
 try
  if Trim(Status)<>'' then
   CreateLogItem(Status);
  if fmSplash<>nil then begin
//   fmSplash.lbStatus.Caption:='Статус: '+Status;
   fmSplash.lbStatus.Caption:=Status;
   fmSplash.Update;
  end else begin
   if fmMain<>nil then begin
     fmMain.stbStatus.Panels.Items[3].Text:=Status;
     fmMain.Update;
   end;
  end;
 except
   {$IFDEF DEBUG} on E: Exception do if isAppLoaded then Assert(false,E.message); {$ENDIF}
 end;  
end;

procedure GetProtocolAndServerName_(DataBaseStr: PChar; var Protocol: TProtocol;
                                   var ServerName: array of char);stdcall;
var
  APos: Integer;
  newdb: string;
begin
  newdb:=DataBaseStr;
  if FileExists(newdb) then begin
    Protocol:=Local;
    ServerName:='';
    exit;
  end;
  APos:=Pos(':',newdb);
  if APos<>0 then begin
    Protocol:=TCP;
    StrCopy(ServerName,Pchar(Copy(newdb,1,Apos-1)));
    exit;
  end;
  APos:=Pos('@',newdb);
  if APos<>0 then begin
    Protocol:=SPX;
    StrCopy(ServerName,Pchar(Copy(newdb,1,Apos-1)));
    exit;
  end;
  APos:=Pos('\\',newdb);
  if APos<>0 then begin
    Protocol:=NamedPipe;
    StrCopy(ServerName,Pchar(Copy(newdb,1,Apos-1)));
    exit;
  end;
end;

function SetDataBaseFromProtocolAndServerName(DataBaseStr: string; Protocol: TProtocol;
                                              ServerName: string): String;
var
  newdb: string;
begin
  newdb:=DataBaseStr;
  Result:=newdb;
{  if FileExists(newdb) then begin
    Result:=newdb;
    exit;
  end;}
  if Protocol=TCP then begin
    Result:=ServerName+':'+newdb;
    exit;
  end;
  if Protocol=SPX then begin
    Result:=ServerName+'@'+newdb;
    exit;
  end;
  if Protocol=NamedPipe then begin
    Result:=ServerName+'\\'+newdb;
    exit;
  end;
end;

procedure SetEmpNameAndEmpId;
var
  qr: TIBQuery;
  sqls: string;
begin
 if not isPermission_(tbUsersEmp,SelConst) or
    not isPermission_(tbEmp,SelConst) then exit;
 try
  qr:=TIBQuery.Create(nil);
  try
   qr.Database:=IBDB;
   sqls:='Select ue.*,e.fname as efname,e.name as ename,e.sname as esname'+
         ' from '+tbUsersEmp+' ue '+
         ' join '+tbEmp+' e on ue.emp_id=e.emp_id '+
         ' where ue.user_id='+inttostr(UserID);
   qr.SQL.Add(sqls);
   qr.Active:=true;
   if not qr.Active then exit;
   if qr.IsEmpty then exit;
   EmpName:=qr.FieldByName('efname').AsString+' '+
            qr.FieldByName('ename').AsString+' '+
            qr.FieldByName('esname').AsString;
   Emp_Id:=qr.FieldByName('emp_id').AsInteger;         
  finally
   qr.Free;
  end;
 except
  {$IFDEF DEBUG}
   on E: Exception do Assert(false,E.message);
  {$ENDIF}
 end;
end;

procedure GetInfoConnectUser_(P: PInfoConnectUser);stdcall;
begin
  if not isValidPointer(P) then exit;
  StrCopy(P.UserName,Pchar(UserName));
  StrCopy(P.UserPass,Pchar(UserPass));
  StrCopy(P.SqlUserName,Pchar(SqlUserName));
  StrCopy(P.SqlRole,Pchar(SqlRole));
  StrCopy(P.AppName,Pchar(AppName));
  P.User_id:=UserId;
  P.App_id:=AppId;
  SetEmpNameAndEmpId;
  StrCopy(P.EmpName,Pchar(EmpName));
  P.Emp_id:=Emp_id;
end;

procedure SetLoadingSQLMonitorOptions;
var
  TCAL: TCreateAdditionalLog;
  TSPAL: TSetParamsToAdditionalLog;
begin
  if fmMainOptions=nil then exit;
  SQLMonitor.Enabled:=fmMainOptions.chbSQLMonitorEnabled.Checked;
  MonitorHook.Enabled:=SQLMonitor.Enabled;

  if SQLMonitor.Enabled then begin
    if not isValidAdditionalLog_(hAdditionalLogSqlMonitor) then begin
     TCAL.Name:=ConstAdditionalLogSqlMonitor;
     TCAL.Hint:=ConstAdditionalLogSQLMonitorHint;
     TCAL.Limit:=fmMainOptions.udSqlMonitorLimit.Position;
     TCAL.ViewAdditionalLogOptionProc:=ViewAdditionalLogOptionProc;
     hAdditionalLogSqlMonitor:=CreateAdditionalLog_(@TCAL);
    end else begin
     TSPAL.Limit:=fmMainOptions.udSqlMonitorLimit.Position;
     SetParamsToAdditionalLog_(hAdditionalLogSqlMonitor,@TSPAL);
    end; 
  end else begin
    FreeAdditionalLog_(hAdditionalLogSqlMonitor);
  end;
  
  if fmMainOptions.chbSQLPrepear.Checked then SQLMonitor.TraceFlags:=SQLMonitor.TraceFlags+[tfQPrepare]
  else SQLMonitor.TraceFlags:=SQLMonitor.TraceFlags-[tfQPrepare];
  if fmMainOptions.chbSqlExecute.Checked then SQLMonitor.TraceFlags:=SQLMonitor.TraceFlags+[tfQExecute]
  else SQLMonitor.TraceFlags:=SQLMonitor.TraceFlags-[tfQExecute];
  if fmMainOptions.chbSQLFetch.Checked then SQLMonitor.TraceFlags:=SQLMonitor.TraceFlags+[tfQFetch]
  else SQLMonitor.TraceFlags:=SQLMonitor.TraceFlags-[tfQFetch];
  if fmMainOptions.chbSQLError.Checked then SQLMonitor.TraceFlags:=SQLMonitor.TraceFlags+[tfError]
  else SQLMonitor.TraceFlags:=SQLMonitor.TraceFlags-[tfError];
  if fmMainOptions.chbSQLStmt.Checked then SQLMonitor.TraceFlags:=SQLMonitor.TraceFlags+[tfStmt]
  else SQLMonitor.TraceFlags:=SQLMonitor.TraceFlags-[tfStmt];
  if fmMainOptions.chbSQLConnect.Checked then SQLMonitor.TraceFlags:=SQLMonitor.TraceFlags+[tfConnect]
  else SQLMonitor.TraceFlags:=SQLMonitor.TraceFlags-[tfConnect];
  if fmMainOptions.chbSQLTransact.Checked then SQLMonitor.TraceFlags:=SQLMonitor.TraceFlags+[tfTransact]
  else SQLMonitor.TraceFlags:=SQLMonitor.TraceFlags-[tfTransact];
  if fmMainOptions.chbSQLBlob.Checked then SQLMonitor.TraceFlags:=SQLMonitor.TraceFlags+[tfBlob]
  else SQLMonitor.TraceFlags:=SQLMonitor.TraceFlags-[tfBlob];
  if fmMainOptions.chbService.Checked then SQLMonitor.TraceFlags:=SQLMonitor.TraceFlags+[tfService]
  else SQLMonitor.TraceFlags:=SQLMonitor.TraceFlags-[tfService];
  if fmMainOptions.chbSQLMisc.Checked then SQLMonitor.TraceFlags:=SQLMonitor.TraceFlags+[tfMisc]
  else SQLMonitor.TraceFlags:=SQLMonitor.TraceFlags-[tfMisc];
end;

procedure LoadDataIniFromBase;
var
  qr: TIBQuery;
  bls: TStream;
  sqls: string;
begin
 if isSwitchNoOptions then exit; 
 try
  SCreen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try
   qr.Database:=IBDBLogin;
   sqls:='Select inidata from '+tbUsers+' where user_name='+QuotedStr(SqlUserName);
   qr.SQL.Add(sqls);
   qr.Active:=true;
   if not qr.Active then exit;
   if qr.IsEmpty then exit;
   bls:=qr.CreateBlobStream(qr.FieldByName('inidata'),bmRead);
   try
     if bls.Size<>0 then begin
       bls.Position:=0;
       MemIniFile.LoadFromStream(bls);
     end;
   finally
     bls.Free;
   end;
  finally
   qr.Free;
   SCreen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG}
   on E: Exception do Assert(false,E.message);
  {$ENDIF}
 end;
end;

procedure SaveDataIniToBase;
var
  tb: TIBTable;
  tran: TIbTransaction;
  bls: TStream;
begin
  try
    Screen.Cursor:=crHourGlass;
    tran:=TIbTransaction.Create(nil);
    tb:=TIBTable.Create(nil);
    try
      tran.AddDatabase(IBDBLogin);
      IBDBLogin.AddTransaction(tran);
      tran.Params.Text:=DefaultTransactionParamsTwo;
      tb.Database:=IBDBLogin;
      tb.Transaction:=tran;
      tb.Transaction.Active:=true;
      tb.TableName:=AnsiUpperCase(tbUsers);
      tb.Filter:=' user_id='+inttostr(UserId);
      tb.Filtered:=true;
      tb.Active:=true;
      tb.Edit;
       
      bls:=tb.CreateBlobStream(tb.FieldByName('inidata'),bmWrite);
      try
        bls.Position:=0;
        MemIniFile.SaveToStream(bls);
        tb.Post;
        tb.Transaction.Commit;
      finally

//        bls.free;
      end;
    finally
      tb.Free;
      tran.Free;
      Screen.Cursor:=crDefault;
    end;
  except
 // {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

procedure CopyBitmap(bmpFrom,bmpTo: TBitmap);
var
  ms: TMemoryStream;
begin
  ms:=TMemoryStream.Create;
  try
    bmpFrom.SaveToStream(ms);
    ms.Position:=0;
    bmpTo.LoadFromStream(ms);
  finally
    ms.Free;
  end;
end;

procedure TransparentBmp(Dc: HDC; Bitmap: HBitmap; xStart: Integer;
                          yStart: Integer; trColor: TColor);
var bm: Windows.TBitmap;
    hDcTemp: HDC;
    ptSize: TPoint;
    hDcBack, hDcObject, hDcMem, hDcSave: hDc;
    bmAndBack, bmAndObject, bmAndMem, bmSave: HBitmap;
    bmBackOld, bmObjectOld, bmMemOld, bmSaveOld: HBitmap;
    sColor: TColorRef;
begin
 try
 hDcTemp := CreateCompatibleDc(Dc);

 SelectObject(hDcTemp,Bitmap);

 GetObject(Bitmap,Sizeof(bm),@bm);

 ptSize.x := bm.bmWidth;
 ptSize.y := bm.bmHeight;

 //создает временные Dc
 hDcBack := CreateCompatibleDc(Dc);
 hDcObject := CreateCompatibleDc(Dc);
 hDcMem := CreateCompatibleDc(Dc);
 hDcSave := CreateCompatibleDc(Dc);
 //создаем битмапы для каждого DC
 bmAndBack := CreateBitmap(ptSize.x,ptSize.y,1,1,nil);

 bmAndObject := CreateBitmap(ptSize.x,ptSize.y,1,1,nil);

 bmAndMem := CreateCompatibleBitmap(Dc,ptSize.x,ptSize.y);

 bmSave :=  CreateCompatibleBitmap(Dc,ptSize.x,ptSize.y);
 //каждому Dc выбрать витмап для сохранения данных пикселей
 bmBackOld := SelectObject(hDcBack,bmAndBack);

 bmObjectOld := SelectObject(hDcObject,bmAndObject);

 bmMemOld := SelectObject(hDcMem,bmAndMem);

 bmSaveOld := SelectObject(hDcSave,bmSave);

 //установка соответствующего mapping mode
 SetMapMode(hDcTemp,GetMapMode(Dc));
 //сохраняем витмап в темпе, потому что он будет переписан
 BitBlt(HDcSave,0,0,ptSize.x,ptSize.y,HDcTemp,0,0,SRCCOPY);
 //устанавливаем задний план
 sColor := SetBkColor(hDcTemp,trColor);
 //создаем маску
 BitBlt(hDcObject,0,0,ptSize.x,ptSize.y,hDcTemp,0,0,SRCCOPY);
 //устанавливаем задний план обратно в оригинал
 SetBkColor(hDcTemp,sColor);
 //готовим инверсную маску
 BitBlt(hDcBack,0,0,ptSize.x,ptSize.y,hDcObject,0,0,NOTSRCCOPY);
 //копируем задний план основного Dc
 BitBlt(hDcMem,0,0,ptSize.x,ptSize.y,Dc,xStart,yStart,SRCCOPY);
 //
 BitBlt(hDcMem,0,0,ptSize.x,ptSize.y,hDcObject,0,0,SRCAND);
 //
 BitBlt(hDcTemp,0,0,ptSize.x,ptSize.y,hDcBack,0,0,SRCAND);
 //
 BitBlt(hDcMem,0,0,ptSize.x,ptSize.y,hDcTemp,0,0,SRCPAINT);
 //
 BitBlt(Dc,xStart,yStart,ptSize.x,ptSize.y,hDcMem,0,0,SRCCOPY);
 //
 BitBlt(hDcTemp,0,0,ptSize.x,ptSize.y,hDcSave,0,0,SRCCopy);

 DeleteObject(SelectObject(hDcBack,bmBackOld));
 DeleteObject(SelectObject(hDcObject,bmObjectOld));
 DeleteObject(SelectObject(hDcMem,bmMemOld));
 DeleteObject(SelectObject(hDcSave,bmSaveOld));
 DeleteDc(hDcBack);
 DeleteDc(hDcObject);
 DeleteDc(hDcMem);
 DeleteDc(hDcSave);
 DeleteDc(hDcTemp);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

function GetFileConnectInfo: string;
var
  s: string;
begin
  if isSwitchPathFile then
    s:=SwitchPathFileParam1
  else begin
    s:=GetWinDir+'\'+ExtractFileName(AppliCation.ExeName);
    Delete(s,Length(s)-3,4);
    s:=s+'.pth';
  end;  
  Result:=s;
end;

procedure SaveConnectInfo;
var
  str: TStringList;
begin
  if not isSwitchPackFile then begin
    str:=TStringList.Create;
    try
     try
       str.Add(MainDataBaseName);
       str.Add(UserName);
       str.Add(AppName);
       str.SaveToFile(GetFileConnectInfo);
     except
     end;
    finally
      str.Free;
    end;
  end;  
end;

procedure LoadConnectInfo;
var
  str: TStringList;
  s: string;
begin
  if not isSwitchPackFile then begin
    str:=TStringList.Create;
    try
     try
       s:=GetFileConnectInfo;
       if FileExists(s) then begin
        str.LoadFromFile(s);
        if str.Count>=1 then begin
          MainDataBaseName:=str.Strings[0];
          if str.Count>=2 then begin
            UserName:=str.Strings[1];
            if str.Count>=3 then
              AppName:=str.Strings[2];
          end;
        end;
       end;
     except
     end;
    finally
      str.Free;
    end;
  end;  
end;

function LoadPackInfo: Boolean;
var
  Ini: TMemIniFile;
  Ifaces: TStringList;
  Enabled: Boolean;
  i: Integer;
begin
  Result:=false;
  if isSwitchPackFile and
     FileExists(SwitchPackFileParam1) then begin
    Ini:=TMemIniFile.Create(SwitchPackFileParam1);
    Ifaces:=TStringList.Create;
    try
      MainDataBaseName:=Ini.ReadString(ConstSectionLogin,'Database',MainDataBaseName);
      UserName:=Ini.ReadString(ConstSectionLogin,'User',UserName);
      AppName:=Ini.ReadString(ConstSectionLogin,'Application',AppName);
      UserPass:=Ini.ReadString(ConstSectionLogin,'Password',UserPass);

      ListRunInterfaces.Clear;

      Ini.ReadSection(ConstSectionIfaces,Ifaces);
      for i:=0 to Ifaces.Count-1 do begin
        Enabled:=Ini.ReadBool(ConstSectionIfaces,Ifaces[i],false);
        if Enabled then
          ListRunInterfaces.Add(Ifaces[i]);
      end;

      Result:=true;
    finally
      Ifaces.Free;
      Ini.Free;
    end;
  end;
end;

function TranslateErrorMessage(Mess: String): string;
begin
  Result:=Format(fmtErrorMessage,[Mess]);
end;

function GetCompName: String;
var
  a: array[0..255] of char;
  s: DWord;
begin
  FillChar(a,sizeof(a),0);
  s:=sizeof(a);
  GetComputerName(a,s);
  Result:=a;
end;

procedure AddErrorToJournal_(Error: PChar; ClassError: TClass); stdcall;
var
  qr: TIBQuery;
  sqls: string;
  tmps: string;
  tran: TIBTransaction;
begin
  if not isValidPointer(Error) then exit;
  if not isPermissionSecurity_(tbJournalError,InsConst) then exit;
  try
    Screen.Cursor:=crHourGlass;
    tran:=TIBTransaction.Create(nil);
    qr:=TIBQuery.Create(nil);
    try
      tran.AddDatabase(IBDBLogin);
      IBDBLogin.AddTransaction(tran);
      tran.Params.Text:=DefaultTransactionParamsTwo;
      qr.Database:=IBDBLogin;
      qr.ParamCheck:=false;
      qr.Transaction:=tran;
      qr.Transaction.Active:=true;
      tmps:=StrPas(Error);
      sqls:='Insert into '+tbJournalError+
            '(journalerror_id,user_id,hint,indatetime,classerror,compname) values ('+
            inttostr(GetGenId(IBDBLogin,tbJournalError,1))+','+
            inttostr(UserId)+','+
            QuotedStr(tmps)+','+
            QuotedStr(DateTimeToStr(GetDateTimeFromServer_))+','+
            QuotedStr(ClassError.ClassName)+','+
            QuotedStr(GetCompName)+')';
      qr.SQL.Add(sqls);
      qr.ExecSQL;
      qr.Transaction.Commit;
    finally
      qr.Free;
      tran.Free;
      Screen.Cursor:=crDefault;
    end;
  except
  end;
end;

procedure AddSqlOperationToJournal_(Name,Hint: Pchar); stdcall;
var
  qr: TIBQuery;
  sqls: string;
  s1,s2: string;
  tran: TIBTransaction;
begin
  if not isValidPointer(Name) then exit;
  if not isValidPointer(Hint) then exit;
  if not isPermissionSecurity_(tbJournalSqlOperation,InsConst) then exit;
  try
    Screen.Cursor:=crHourGlass;
    tran:=TIBTransaction.Create(nil);
    qr:=TIBQuery.Create(nil);
    try
      tran.AddDatabase(IBDBLogin);
      IBDBLogin.AddTransaction(tran);
      tran.Params.Text:=DefaultTransactionParamsTwo;
      qr.Database:=IBDBLogin;
      qr.Transaction:=tran;
      qr.Transaction.Active:=true;
      s1:=StrPas(Name);
      s2:=StrPas(Hint);
      sqls:='Insert into '+tbJournalSqlOperation+
            '(journalsqloperation_id,user_id,hint,indatetime,name,compname) values ('+
            inttostr(GetGenId(IBDBLogin,tbJournalSqlOperation,1))+','+
            inttostr(UserId)+','+
            QuotedStr(s2)+','+
            QuotedStr(DateTimeToStr(GetDateTimeFromServer_))+','+
            QuotedStr(s1)+','+
            QuotedStr(GetCompName)+')';
      qr.SQL.Add(sqls);
      qr.ExecSQL;
      qr.Transaction.Commit;
    finally
      qr.Free;
      tran.Free;
      Screen.Cursor:=crDefault;
    end;
  except
  end;
end;


function GetDateTimeFromServer_: TDateTime; stdcall;
var
 sqls: string;
 qrnew: TIBQuery;
 tran: TIBTransaction;
begin
 Result:=Now;
 try
  Screen.Cursor:=crHourGlass;
  qrnew:=TIBQuery.Create(nil);
  tran:=TIBTransaction.Create(nil);
  try
   qrnew.Database:=IBDB;
   tran.AddDatabase(IBDB);
   IBDB.AddTransaction(tran);
   qrnew.Transaction:=tran;
   qrnew.Transaction.Active:=true;
//   sqls:='Select '+ConstGetServerDateTime+'() as dt from dual';
   sqls:='Select current_timestamp as dt from dual';
   qrnew.SQL.Add(sqls);
   qrnew.Active:=true;
   if not qrnew.IsEmpty then begin
     Result:=qrnew.FieldByName('dt').AsDateTime;
   end;
  finally
   tran.free;
   qrnew.free;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

function GetWorkDate_: TDate; stdcall;
begin
  if fmMain=nil then
    Result:=GetDateTimeFromServer_
  else Result:=fmMain.dtpWorkDate.Date;
end;

function ViewEnterPeriod_(P: PInfoEnterPeriod): Boolean; stdcall;
var
  fm: TfmEnterPeriod; 
begin
 Result:=false;
 try
  fm:=nil;
  try
    fm:=TfmEnterPeriod.Create(nil);
    if P<>nil then begin
     if P.LoadAndSave then
      fm.LoadPeriod(P);
     fm.SetPeriod(P); 
    end;
    if fm.ShowModal=mrOk then begin
     if P<>nil then begin
      if P.LoadAndSave then
       fm.SavePeriod;
      fm.GetPeriod(P); 
     end;
     Result:=true;
    end;
  finally
    FreeAndNil(fm);
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure UnRegisterAllHotKeys;
begin
  UnregisterHotKey(Application.Handle,ConstHotKeyUpperCase);
  UnregisterHotKey(Application.Handle,ConstHotKeyLowerCase);
  UnregisterHotKey(Application.Handle,ConstHotKeyToRussian);
  UnregisterHotKey(Application.Handle,ConstHotKeyToEnglish);
  UnregisterHotKey(Application.Handle,ConstHotKeyFirstUpperCase);
  UnregisterHotKey(Application.Handle,ConstHotKeyTrimSpaceForOne);
end;

procedure RegisterAllHotKeys;

  function GetMod(Shift: TShiftState): Word;
  begin
    Result:=0;
    if ssCtrl in Shift then inc(Result,MOD_CONTROL);
    if ssAlt in Shift then inc(Result,MOD_ALT);
    if ssShift in Shift then inc(Result,MOD_SHIFT);
  end;

var
  Key: Word;
  Shift: TShiftState;
begin
  UnRegisterAllHotKeys;
  ShortCutToKey(HotKeyUpperCase,Key,Shift);
  RegisterHotKey(Application.Handle,ConstHotKeyUpperCase,GetMod(Shift),Key);
  ShortCutToKey(HotKeyLowerCase,Key,Shift);
  RegisterHotKey(Application.Handle,ConstHotKeyLowerCase,GetMod(Shift),Key);
  ShortCutToKey(HotKeyToRussian,Key,Shift);
  RegisterHotKey(Application.Handle,ConstHotKeyToRussian,GetMod(Shift),Key);
  ShortCutToKey(HotKeyToEnglish,Key,Shift);
  RegisterHotKey(Application.Handle,ConstHotKeyToEnglish,GetMod(Shift),Key);
  ShortCutToKey(HotKeyFirstUpperCase,Key,Shift);
  RegisterHotKey(Application.Handle,ConstHotKeyFirstUpperCase,GetMod(Shift),Key);
  ShortCutToKey(HotKeyTrimSpaceForOne,Key,Shift);
  RegisterHotKey(Application.Handle,ConstHotKeyTrimSpaceForOne,GetMod(Shift),Key);
end;

procedure TranslateText(ttt: TTypeTranslateText);
const
  ENG_up: array[0..39] of char=('Q','W','E','R','T','Y','U','I','O','P',
                                'A','S','D','F','G','H','J','K','L','Z',
                                'X','C','V','B','N','M','`','~','[','{',
                                ']','}',';',':','''','"',',','<','.','>');
  RUS_up: array[0..39] of char=('Й','Ц','У','К','Е','Н','Г','Ш','Щ','З',
                                'Ф','Ы','В','А','П','Р','О','Л','Д','Я',
                                'Ч','С','М','И','Т','Ь','Ё','Ё','Х','Х',
                                'Ъ','Ъ','Ж','Ж','Э','Э','Б','Б','Ю','Ю');
  ENG_lo: array[0..39] of char=('q','w','e','r','t','y','u','i','o','p',
                                'a','s','d','f','g','h','j','k','l','z',
                                'x','c','v','b','n','m','`','`','{','[',
                                '}',']',';',':','''','"',',','<','.','>');
  RUS_lo: array[0..39] of char=('й','ц','у','к','е','н','г','ш','щ','з',
                                'ф','ы','в','а','п','р','о','л','д','я',
                                'ч','с','м','и','т','ь','ё','ё','х','х',
                                'ъ','ъ','ж','ж','э','э','б','б','ю','ю');

  function GetCharFromArray(arr1,arr2: array of char; ch: char): char;
  var
    cur: char;
    i: Integer;
  begin
    Result:=ch;
    for i:=0 to sizeof(arr1)-1 do begin
     cur:=arr1[i];
     if cur=ch then begin
       Result:=arr2[i];
       exit;
     end;
    end;
  end;

  function toRussian(s: string): String;
  var
    i: Integer;
    ch: char;
    tmps: string;
  begin
    Result:=s;
    for i:=1 to Length(s) do begin
      ch:=s[i];
      if IsCharLower(ch) then
       ch:=GetCharFromArray(ENG_lo,RUS_lo,ch)
      else
       ch:=GetCharFromArray(ENG_up,RUS_up,ch);
      tmps:=tmps+ch; 
    end;
    Result:=tmps;
  end;

  function toEnglish(s: string): String;
  var
    i: Integer;
    ch: char;
    tmps: string;
  begin
    Result:=s;
    for i:=1 to Length(s) do begin
      ch:=s[i];
      if IsCharLower(ch) then
       ch:=GetCharFromArray(RUS_lo,ENG_lo,ch)
      else
       ch:=GetCharFromArray(RUS_up,ENG_up,ch);
      tmps:=tmps+ch;
    end;
    Result:=tmps;
  end;

  function toFirstUpper(s: string): string;
  var
    I: Integer;
  begin
    for i:=1 to Length(s) do begin
      if i=1 then begin
        if s[i]<>' ' then begin
          s[i]:=AnsiUpperCase(s)[i];
        end;
      end else
        if (s[i-1]=' ') and (s[i]<>' ')then
          s[i]:=AnsiUpperCase(s)[i];
    end;
    Result:=s;
  end;

  function toTrimSpaceForOne(const s: string): string;
  var
    I: Integer;
    tmps: string;
  begin
    for i:=1 to Length(s) do begin
     if i=1 then begin
       tmps:=s[i];
     end else begin
       if (s[i]<>' ') then
        tmps:=tmps+s[i]
       else
        if (s[i-1]<>' ') then
          tmps:=tmps+s[i];
     end;
    end;
    Result:=tmps;
  end;

  function MAKELANGID(p:Word; s: Word): Word;// ((((WORD) (s)) << 10) | (WORD) (p))  
  begin
    Result:=(s shl 10) or p; 
  end;

var
  wnd: HWND;
  P: Pointer;
  s: String;
  l: Integer;
  pt: TPoint;
begin
  try
   wnd:=GetFocus;
   if wnd=0 then exit;
   l:=GetWindowTextLength(wnd);
   GetCaretPos(pt);
   HideCaret(wnd);
   if l=0 then exit;
   l:=l+1;
   GetMem(P,l);
   try
    GetWindowText(wnd,P,l);
    SetLength(s,l);
    Move(P^,Pointer(s)^,l);
    case ttt of
     tttUpper: s:=AnsiUpperCase(s);
     tttLower: s:=AnsiLowerCase(s);
     tttRussian: begin
      s:=toRussian(s);
      LoadKeyboardLayout(LayoutRussian,KLF_ACTIVATE);
     end;
     tttEnglish: begin
      s:=toEnglish(s);
      LoadKeyboardLayout(LayoutEnglish,KLF_ACTIVATE);
     end;
     tttFirstUpper: s:=toFirstUpper(s);
     tttTrimSpaceForOne: s:=toTrimSpaceForOne(s);
    end;
    SetWindowText(wnd,Pchar(s));
    ShowCaret(wnd);
    SetCaretPos(pt.x,pt.y);
   finally
     FreeMem(P,l);
   end;
  except
  end;
end;

function TranslateMenuCaption(Caption: string): string;
var
  i: Integer;
  ch: Char;
  tmps: string;
begin
  tmps:='';
  for i:=1 to Length(Caption) do begin
    ch:=Caption[i];
    if ch<>'&' then
     tmps:=tmps+ch; 
  end;
  Result:=tmps;
end;

procedure OpenFirstLevelOnTreeView(TV: TTreeView);
var
    nd: TTreeNode;
begin
    nd:=Tv.Items.GetFirstNode;
    if nd<>nil then
     nd.Expand(false);
    while nd<>nil do begin
     nd:=nd.getNextSibling;
     if nd<>nil then
      nd.Expand(false);
    end;
end;

procedure SetImageToTreeNodes(TreeView: TTreeView);
var
  i: Integer;
  nd: TTreeNode;
begin
  for i:=0 to TreeView.Items.Count-1 do begin
    nd:=TreeView.Items[i];
    if nd.ImageIndex<3 then
     if nd.HasChildren then begin
      nd.ImageIndex:=0;
      nd.SelectedIndex:=1;
     end else begin
      nd.ImageIndex:=2;
      nd.SelectedIndex:=2;
     end;
  end;
end;

function GetOptions_: TMainOption; stdcall;
begin
  Result:=MnOption;
end;

procedure GetLibraries_(Owner: Pointer; Proc: TGetLibraryProc); stdcall;
var
  TGL: TGetLibrary;
  P: PInfoLib;
  i: Integer;
begin
  if not isValidPointer(@Proc) then exit;
  for i:=0 to ListLibs.Count-1 do begin
    P:=ListLibs.Items[i];
    FillChar(TGL,SizeOf(TGetLibrary),0);
    TGL.Active:=P.Active;
    TGL.TypeLib:=P.TypeLib;
    TGL.LibHandle:=P.LibHandle;
    Proc(Owner,@TGL);
  end;
end;

{function GetListLibs_: TList; stdcall;
begin
  Result:=ListLibs;
end;}

function TestSplash_: Boolean;stdcall;
begin
  if fmSplash=nil then begin
   fmSplash:=TfmSplash.Create(nil);
   try
    fmSplash.Caption:=MainCaption;
    fmSplash.lbVersion.Visible:=isVisibleSplashVerison;
    fmSplash.lbStatus.Visible:=isVisibleSplashStatus;
    SetSplashImage(fmSplash);
    fmSplash.isTest:=true;
    Result:=fmSplash.ShowModal=mrOk;
   finally
    FreeAndNil(fmSplash);
   end;
  end else begin
    SetSplashImage(fmSplash);
    fmSplash.isTest:=true;
    Result:=fmSplash.ShowModal=mrOk;
  end;
end;

// -------------- ProgressBar  -----------------

procedure ClearListProgressBars;
var
  i: Integer;
  P: PInfoProgressBar;
begin
  for i:=0 to ListProgressBars.Count-1 do begin
    P:=ListProgressBars.Items[i];
    FreeProgressBar_(THandle(P));
  end;
  ListProgressBars.Clear;
end;

function isValidProgressBar_(ProgressBarHandle: THandle): Boolean;stdcall;
begin
  Result:=ListProgressBars.IndexOf(Pointer(ProgressBarHandle))<>-1;
end;

function CreateProgressBar_(PCPB: PCreateProgressBar): THandle;stdcall;
var
  gag: TNewTsvGauge;
  P: PInfoProgressBar;
begin
  Result:=PROGRESSBAR_INVALID_HANDLE;
  if fmMain=nil then exit;
  if not isValidPointer(PCPB,SizeOf(TCreateProgressBar)) then exit;
  new(P);
  FillChar(P^,SizeOf(TInfoProgressBar),0);
  P.Min:=PCPB.Min;
  P.Max:=PCPB.Max;
  P.Hint:=PCPB.Hint;
  P.Color:=PCPB.Color;
  gag:=TNewtsvGauge.Create(nil);
  gag.MinValue:=P.Min;
  gag.MaxValue:=P.Max;
  gag.Hint:=P.Hint;
  gag.StartColor:=P.Color;
  gag.EndColor:=P.Color;
  gag.CenterText:=true;
  gag.ShowPercent:=P.Min<>P.Max;
  P.Gag:=gag;
  ListProgressBars.Add(P);
  Result:=THandle(P);
  fmMain.SetPositionProgressBar;
end;

function FreeProgressBar_(ProgressBarHandle: THandle): Boolean;stdcall;
var
  P: PInfoProgressBar;
begin
  Result:=false;
  if not isValidProgressBar_(ProgressBarHandle) then exit;
  P:=PInfoProgressBar(ProgressBarHandle);
  P.Gag.free;
  ListProgressBars.Remove(P);
  Dispose(P);
  fmMain.SetPositionProgressBar;
  Result:=true;
end;

procedure SetProgressBarStatus_(ProgressBarHandle: THandle; PSPBS: PSetProgressBarStatus)stdcall;
var
  P: PInfoProgressBar;
begin
  if not isValidProgressBar_(ProgressBarHandle) then exit;
  if not isValidPointer(PSPBS,SizeOf(TSetProgressBarStatus)) then exit;
  P:=PInfoProgressBar(ProgressBarHandle);
  P.Gag.Progress:=PSPBS.Progress;
  if PSPBS.Max>P.Gag.MinValue then
    P.Gag.MaxValue:=PSPBS.Max;
  P.Gag.Hint:=PSPBS.Hint;
  P.Gag.ShowPercent:=(ListProgressBars.Count=1) and (P.Gag.MinValue<>P.Gag.Progress);
  fmMain.SetPositionProgressBar;
end;

// -------------- ToolBar  -----------------

procedure ToolButtonClickProc(ToolButtonHandle: THandle); stdcall;
begin
{   if ToolButtonHandle=hToolButtonFileRefresh then ViewMenu_(hMenuFileRefresh);
   if ToolButtonHandle=hToolButtonFileLogin then ViewMenu_(hMenuFileLogin);}
   if ToolButtonHandle=hToolButtonViewLog then ViewMenu_(hMenuViewLog);
   if ToolButtonHandle=hToolButtonConst then ViewMenu_(hMenuConst);
   if ToolButtonHandle=hToolButtonServiceChangePassword then ViewMenu_(hMenuServiceChangePassword);
   if ToolButtonHandle=hToolButtonServiceOptions then ViewMenu_(hMenuServiceOptions);
   if ToolButtonHandle=hToolButtonWindowsLast then ViewMenu_(hMenuWindowsLast);
   if ToolButtonHandle=hToolButtonWindowsCascade then ViewMenu_(hMenuWindowsCascade);
   if ToolButtonHandle=hToolButtonWindowsVert then ViewMenu_(hMenuWindowsVert);
   if ToolButtonHandle=hToolButtonWindowsGoriz then ViewMenu_(hMenuWindowsGoriz);
   if ToolButtonHandle=hToolButtonWindowsCloseAll then ViewMenu_(hMenuWindowsCloseAll);
   if ToolButtonHandle=hToolButtonHelpAbout then ViewMenu_(hMenuHelpAbout);
end;

procedure AddToListToolBars;

  function CreateToolBarLocal(Name,Hint: PChar;
                              ShortCut: TShortCut;
                              Visible: Boolean;
                              Position: TToolBarPosition): THandle;
  var
    CTBLocal: TCreateToolBar;
  begin
    FillChar(CTBLocal,SizeOf(TCreateToolBar),0);
    CTBLocal.Name:=Name;
    CTBLocal.Hint:=Hint;
    CTBLocal.ShortCut:=ShortCut;
    CTBLocal.Visible:=Visible;
    CTBLocal.Position:=Position;
    Result:=CreateToolBar_(@CTBLocal);
  end;

  function CreateToolButtonLocal(TH: THandle; Name,Hint: string;
                                 ImageIndex: Integer=-1; Proc: TToolButtonClickProc=nil;
                                 ShortCut: TShortCut=0;
                                 Style: TToolButtonStyleEx=tbseButton;
                                 Control: TControl=nil): THandle;
  var
   CTBLocal: TCreateToolButton;
   Image: TBitmap;
  begin
   Image:=nil;
   try
    Image:=TBitmap.Create;
    FillChar(CTBLocal,SizeOf(TCreateToolButton),0);
    CTBLocal.Name:=PChar(Name);
    CTBLocal.Hint:=PChar(Hint);
    CTBLocal.ShortCut:=ShortCut;
    if ImageIndex<>-1 then begin
     fmMain.ilMM.GetBitmap(ImageIndex,Image);
     CTBLocal.Bitmap:=Image;
    end;
    CTBLocal.ToolButtonClickProc:=Proc;
    CTBLocal.Style:=Style;
    CTBLocal.Control:=Control;
    Result:=CreateToolButton_(TH,@CTBLocal);
   finally
     Image.Free;
   end;
  end;

var
  tBar1,tBar2,tBar3,tBar4: THandle;
begin
   if fmMain=nil then exit;
   ListToolBarsMain.Clear;
   tBar1:=CreateToolBarLocal('Стандартная','Панель стандартных операций',0,true,tbpTop);
   hToolBarStandart:=tBar1;
   ListToolBarsMain.Add(Pointer(tBar1));
   with fmMain do begin
{     hToolButtonFileRefresh:=CreateToolButtonLocal(tBar1,PInfoMenu(hMenuFileRefresh).Name,PInfoMenu(hMenuFileRefresh).Hint,
                                                   PInfoMenu(hMenuFileRefresh).MenuItem.ImageIndex,ToolButtonClickProc);//,ShortCut(Ord('A'),[ssCtrl]));
     hToolButtonFileLogin:=CreateToolButtonLocal(tBar1,PInfoMenu(hMenuFileLogin).Name,PInfoMenu(hMenuFileLogin).Hint,
                                                 PInfoMenu(hMenuFileLogin).MenuItem.ImageIndex,ToolButtonClickProc);}
     hToolButtonViewLog:=CreateToolButtonLocal(tBar1,PInfoMenu(hMenuViewLog).Name,PInfoMenu(hMenuViewLog).Hint,
                                                 PInfoMenu(hMenuViewLog).MenuItem.ImageIndex,ToolButtonClickProc);
     hToolButtonServiceChangePassword:=CreateToolButtonLocal(tBar1,PInfoMenu(hMenuServiceChangePassword).Name,PInfoMenu(hMenuServiceChangePassword).Hint,
                                                             PInfoMenu(hMenuServiceChangePassword).MenuItem.ImageIndex,ToolButtonClickProc);
     hToolButtonServiceOptions:=CreateToolButtonLocal(tBar1,PInfoMenu(hMenuServiceOptions).Name,PInfoMenu(hMenuServiceOptions).Hint,
                                                      PInfoMenu(hMenuServiceOptions).MenuItem.ImageIndex,ToolButtonClickProc);
     if hMenuConst<>MENU_INVALID_HANDLE then
       hToolButtonConst:=CreateToolButtonLocal(tBar1,PInfoMenu(hMenuConst).Name,PInfoMenu(hMenuConst).Hint,
                                                     PInfoMenu(hMenuConst).MenuItem.ImageIndex,ToolButtonClickProc);

   end;
   RefreshToolBar_(tbar1);
   tBar2:=CreateToolBarLocal('Окна','Панель окон',0,true,tbpTop);
   ListToolBarsMain.Add(Pointer(tBar2));
   with fmMain do begin
     hToolButtonWindowsLast:=CreateToolButtonLocal(tBar2,PInfoMenu(hMenuWindowsLast).Name,PInfoMenu(hMenuWindowsLast).Hint,
                                                      PInfoMenu(hMenuWindowsLast).MenuItem.ImageIndex,ToolButtonClickProc);
     hToolButtonWindowsCascade:=CreateToolButtonLocal(tBar2,PInfoMenu(hMenuWindowsCascade).Name,PInfoMenu(hMenuWindowsCascade).Hint,
                                                      PInfoMenu(hMenuWindowsCascade).MenuItem.ImageIndex,ToolButtonClickProc);
     hToolButtonWindowsVert:=CreateToolButtonLocal(tBar2,PInfoMenu(hMenuWindowsVert).Name,PInfoMenu(hMenuWindowsVert).Hint,
                                                   PInfoMenu(hMenuWindowsVert).MenuItem.ImageIndex,ToolButtonClickProc);
     hToolButtonWindowsGoriz:=CreateToolButtonLocal(tBar2,PInfoMenu(hMenuWindowsGoriz).Name,PInfoMenu(hMenuWindowsGoriz).Hint,
                                                    PInfoMenu(hMenuWindowsGoriz).MenuItem.ImageIndex,ToolButtonClickProc);
     hToolButtonWindowsCloseAll:=CreateToolButtonLocal(tBar2,PInfoMenu(hMenuWindowsCloseAll).Name,PInfoMenu(hMenuWindowsCloseAll).Hint,
                                                       PInfoMenu(hMenuWindowsCloseAll).MenuItem.ImageIndex,ToolButtonClickProc);
   end;
   RefreshToolBar_(tbar2);
   tBar3:=CreateToolBarLocal('Помощь','Панель помощи',0,true,tbpTop);
   ListToolBarsMain.Add(Pointer(tBar3));
   with fmMain do begin
     hToolButtonHelpAbout:=CreateToolButtonLocal(tBar3,PInfoMenu(hMenuHelpAbout).Name,PInfoMenu(hMenuHelpAbout).Hint,
                                                 PInfoMenu(hMenuHelpAbout).MenuItem.ImageIndex,ToolButtonClickProc);
   end;
   RefreshToolBar_(tbar3);
   tBar4:=CreateToolBarLocal('Рабочая дата','Панель рабочей даты',0,false,tbpTop);
   ListToolBarsMain.Add(Pointer(tBar4));
   with fmMain do begin
     CreateToolButtonLocal(tBar4,'','',-1,ToolButtonClickProc,0,tbseControl,pnWorkDate);
   end;
   RefreshToolBar_(tBar4);
end;

procedure ClearListToolBarsNoMain;
var
  i: Integer;
  P: PInfoToolBar;
begin
  for i:=ListToolBars.Count-1 downto 0 do begin
    P:=ListToolBars.Items[i];
    if ListToolBarsMain.IndexOf(P)=-1 then
      FreeToolBar_(THandle(P));
  end;
end;

procedure CLearListToolBars;
var
  i: Integer;
  P: PInfoToolBar;
begin
  for i:=ListToolBars.Count-1 downto 0 do begin
    P:=ListToolBars.Items[i];
    FreeToolBar_(THandle(P));
  end;
end;

function GetToolBarFromName(Name: PChar): PInfoToolBar;
var
  i: Integer;
  P: PInfoToolBar;
begin
  Result:=nil;
  for i:=0 to ListToolBars.Count-1 do begin
    P:=ListToolBars.Items[i];
    if AnsiUpperCase(P.Name)=AnsiUpperCase(Name) then begin
      Result:=P;
      exit;
    end;
  end;
end;

procedure SetToolBarWidthAndHeight(tb: TNewToolBar; RowCount: Integer);
var
  w,h: Integer;
  i: Integer;
  ct: TControl;
begin
  if tb=nil then exit;
  w:=0;
  for i:=0 to tb.ButtonCount-1 do
   if (tb.Buttons[i] is TNewToolButton) then
     w:=w+tb.Buttons[i].Width;
   w:=w div RowCount;

  h:=tb.ButtonHeight*RowCount;
  for i:=0 to tb.ControlCount-1 do begin
    ct:=tb.Controls[i];
    if not (ct is TNewToolButton) then begin
      w:=w+ct.Width;
    end;
  end;
  tb.Width:=w;
  tb.Height:=h;
end;

function CreateToolBar_(PCTB: PCreateToolBar): THandle; stdcall;
var
  list: TList;
  P: PInfoToolBar;
  PExist: PInfoToolBar;
  tb: TNewToolBar;
  mi: TTBMenuItem;
  il: TImageList;
  Section: String;
  rt: TRect;
  TCLI: TCreateLogItem;
begin
  Result:=TOOLBAR_INVALID_HANDLE;
  try
   if fmMain=nil then exit;
   if hMenuViewToolBars=MENU_INVALID_HANDLE then exit;
   if not isValidPointer(PCTB,Sizeof(TCreateToolBar)) then exit;
   if Trim(PCTB.Name)='' then exit;
   New(P);
   FillChar(P^,sizeof(TInfoToolBar),0);
   P.Hint:=PCTB.Hint;
   P.Name:=PCTB.Name;
   Section:=ConstToolBar+''+P.Name;
   P.ShortCut:=ReadParam(Section,'ShortCut',PCTB.ShortCut);
   P.Visible:=ReadParam(Section,'Visible',PCTB.Visible);
   P.Width:=ReadParam(Section,'Width',P.Width);
   P.Height:=ReadParam(Section,'Height',P.Height);
   P.Left:=ReadParam(Section,'Left',P.Left);
   P.Top:=ReadParam(Section,'Top',P.Top);
   P.Position:=TToolBarPosition(ReadParam(Section,'Position',Integer(PCTB.Position)));
   P.ZOrder:=ReadParam(Section,'ZOrder',P.ZOrder);
   P.RowCount:=ReadParam(Section,'RowCount',1);

   List:=TList.Create;
   P.List:=List;
   fmMain.ctrlBarTop.OnBandMove:=nil;
   fmMain.ctrlBarBottom.OnBandMove:=nil;
   PExist:=GetToolBarFromName(PChar(P.Name));
   if PExist=nil then begin
    tb:=TNewToolBar.Create(nil);
    mi:=TTBMenuItem.Create(nil);
    il:=TImageList.Create(nil);
    tb.ParentHandle:=fmMain.Handle;
    tb.isMiClick:=false;
    tb.Parent:=fmMain.ctrlBarTop;
    tb.P:=P;
    tb.Caption:=P.Name;
    tb.Hint:=P.Hint;
    tb.Images:=il;
    tb.PopupMenu:=fmMain.pmViewToolBar;
    tb.AutoSize:=false;
    tb.mi:=mi;
    mi.Caption:=P.Name;
    mi.Hint:=P.Hint;
    mi.tb:=tb;
    mi.Checked:=P.Visible;
    mi.ShortCut:=P.ShortCut;
    mi.OnClick:=fmMain.MenuClickToolBar;
    P.SelfToolBar:=tb;
    P.SelfImageList:=il;
    P.SelfMenuItem:=mi;
    P.ToolBar:=tb;
    P.ImageList:=il;
    P.MenuItem:=mi;
    PInfoMenu(hMenuViewToolBars).MenuItem.Add(mi);
   end else begin
    P.ShortCut:=PExist.ShortCut;
    P.Visible:=PExist.Visible;
    P.Width:=PExist.Width;
    P.Height:=PExist.Height;
    P.Left:=PExist.Left;
    P.Top:=PExist.Top;
    P.Position:=PExist.Position;
    P.ZOrder:=PExist.ZOrder;
    P.RowCount:=PExist.RowCount;
    tb:=PExist.SelfToolBar;
    tb.AutoSize:=false;
    P.ToolBar:=PExist.SelfToolBar;
    P.ImageList:=PExist.SelfImageList;
    P.MenuItem:=PExist.SelfMenuItem;
   end;

   if (P.Left>Screen.Width)or(P.Left<0) then P.Left:=0;
   if (P.Top>Screen.Height)or(P.Top<0) then P.Top:=0;
   rt:=Rect(P.Left,P.Top,P.Left+P.Width,P.Top+P.Height);
   case P.Position of
     tbpFloat: begin
        tb.ManualFloat(Rect(-1000,-1000,0,0));
        tb.Visible:=false;
        tb.HostDockSite.Dock(nil,rt);
        tb.SetBounds(P.Left,P.Top,P.Width,P.Height);
     end;
     tbpTop: begin
        tb.ManualDock(fmMain.ctrlBarTop);
        tb.SetBounds(P.Left,P.Top,P.Width,P.Height);
     end;
     tbpBottom: begin
        tb.ManualDock(fmMain.ctrlBarBottom);
        tb.SetBounds(P.Left,P.Top,P.Width,P.Height);
     end;
   end;
   tb.Visible:=P.Visible;
   tb.OnStartDock:=fmMain.ToolBarStartDock;
   tb.OnEndDock:=fmMain.ToolBarEndDock;
   P.ToolBar.isMiClick:=true;
   fmMain.ctrlBarTop.OnBandMove:=fmMain.ctrlBarTopBandMove;
   fmMain.ctrlBarBottom.OnBandMove:=fmMain.ctrlBarTopBandMove;


   ListToolBars.Add(P);
   Result:=THandle(P);
  except
    on E: Exception do begin
      FillChar(TCLI,SizeOf(TCLI),0);
      TCLI.Text:=PChar(Format(fmtCreateToolBarError,[PCTB.Name,E.Message]));
      TCLI.TypeLogItem:=tliError;
      CreateLogItem_(@TCLI);
    end;
  end;
end;

procedure RefreshToolBars_; stdcall;
begin
  if fmMain=nil then exit;
end;

function RefreshToolBar_(ToolBarHandle: THandle): Boolean;stdcall;
var
  P: PInfoToolBar;
  val: Integer;
begin
  Result:=false;
  P:=Pointer(ToolBarHandle);
  val:=ListToolBars.IndexOf(P);
  if val=-1 then exit;
  if P.RowCount=0 then P.RowCount:=1;
  SetToolBarWidthAndHeight(P.ToolBar,P.RowCount);
  if P.ToolBar<>nil then begin
    P.ToolBar.AutoSize:=true;
//    P.ToolBar.Wrapable:=true;
  end;  
end;

function FreeToolBar_(ToolBarHandle: THandle): Boolean; stdcall;
var
  P: PInfoToolBar;
  PToolButton: PInfoToolButton;
  val: Integer;
  Section: string;
  i: Integer;
  PExist: PInfoToolBar;
  OldVis: Boolean;
begin
  Result:=false;
   P:=Pointer(ToolBarHandle);
   val:=ListToolBars.IndexOf(P);
   if val=-1 then exit;
   Section:=ConstToolBar+''+P.Name;
   WriteParam(Section,'ShortCut',P.ShortCut);
   WriteParam(Section,'Visible',P.Visible);
   WriteParam(Section,'Width',P.Width);
   WriteParam(Section,'Height',P.Height);
   WriteParam(Section,'Left',P.Left);
   WriteParam(Section,'Top',P.Top);
   WriteParam(Section,'Position',Integer(P.Position));
   WriteParam(Section,'ZOrder',P.ZOrder);
   WriteParam(Section,'RowCount',P.RowCount);
   OldVis:=false;
   if P.SelfToolBar<>nil then begin
     OldVis:=P.SelfToolBar.Visible;
     P.SelfToolBar.Visible:=false;
   end;  
   for i:=P.List.Count-1 downto 0 do begin
     PToolButton:=P.List.Items[i];
     FreeToolButton_(THandle(PToolButton));
   end;
   P.List.Free;
   ListToolBars.Remove(P);
   PExist:=GetToolBarFromName(PChar(P.Name));
   if PExist=nil then begin
    if P.SelfToolBar<>nil then P.SelfToolBar.Free;
    if P.SelfImageList<>nil then P.SelfImageList.Free;
    if P.SelfMenuItem<>nil then P.SelfMenuItem.Free;
   end else begin
    PExist.SelfToolBar:=P.SelfToolBar;
    P.SelfToolBar:=nil;
    PExist.SelfImageList:=P.SelfImageList;
    P.SelfImageList:=nil;
    PExist.SelfMenuItem:=P.SelfMenuItem;
    P.SelfMenuItem:=nil;
    if PExist.SelfToolBar<>nil then
      PExist.SelfToolBar.Visible:=OldVis;
   end;
   Dispose(P);
   Result:=true;
end;

function GetToolBarFromToolButton(P: PInfoToolButton): PInfoToolBar;
var
  i: Integer;
  PToolBar: PInfoToolBar;
  val: Integer;
begin
  Result:=nil;
  for i:=0 to ListToolBars.Count-1 do begin
    PToolBar:=ListToolBars.Items[i];
    val:=PToolBar.List.IndexOf(P);
    if val<>-1 then begin
      Result:=PToolBar;
      exit;
    end;
  end;
end;

procedure AddToolButton(tb: TNewToolBar; P: PInfoToolButton);
var
 tbut: TNewToolButton;
 AndMask: TBitmap;
 tmpBitmap: TBitmap;
 rt: TRect;
 isBitmapFail: Boolean;
begin
 AndMask:=TBitmap.Create;
 try
  if not isValidPointer(P.Control) then begin
    tbut:=TNewToolButton.Create(nil);
    tbut.Parent:=tb;
    tbut.Style:=TToolButtonStyle(P.Style);
    tbut.P:=P;
    tbut.OnClick:=fmMain.ToolButtonClick;
    tbut.Caption:=P.Name;
    if P.ShortCut<>0 then
     tbut.Hint:=P.Hint+' ('+ShortCutToText(P.ShortCut)+')'
    else tbut.Hint:=P.Hint;
    tbut.ShowHint:=true;
    case P.Style of
      tbseButton: begin
      end;
      tbseSeparator: begin
        tbut.Width:=7;
      end;
    end;
    tbut.Left:=tb.Buttons[tb.ButtonCount-1].Left+tb.Buttons[tb.ButtonCount-1].Width;
    isBitmapFail:=true;
    if IsValidPointer(P.Bitmap, SizeOf(TBitmap)) then
      isBitmapFail:=P.Bitmap.Empty;
    if not isBitmapFail then begin
      CopyBitmap(P.Bitmap,AndMask);
      AndMask.Mask(AndMask.Canvas.Pixels[0,0]);
      tbut.ImageIndex:=tb.Images.Add(P.Bitmap,AndMask);
    end else begin
      tmpBitmap:=TBitmap.Create;
      try
        fmMain.ilMM.GetBitmap(ConstImageIndexQuestion,tmpBitmap);
        CopyBitmap(tmpBitmap,AndMask);
        AndMask.Mask(AndMask.Canvas.Pixels[0,0]);
        tbut.ImageIndex:=tb.Images.Add(tmpBitmap,AndMask);
      finally
        tmpBitmap.Free;
      end;
    end;
  end else begin
    P.Control.Parent:=tb;
    tb.AlignControls(P.Control,rt);
  end;
 finally
  AndMask.Free;
 end;
end;

function CreateToolButton_(ToolBarHandle: THandle; PCTB: PCreateToolButton): THandle; stdcall;
var
  P: PInfoToolButton;
  PToolBar: PInfoToolBar;
  bmp: TBitmap;
  val: Integer;
  Section: string;
  TCLI: TCreateLogItem;
begin
  Result:=TOOLBUTTON_INVALID_HANDLE;
  try
   if fmMain=nil then exit;
   val:=ListToolBars.IndexOf(Pointer(ToolBarHandle));
   if val=-1 then exit;
   if not isValidPointer(PCTB,SizeOf(TCreateToolButton)) then exit;
   PToolBar:=Pointer(ToolBarHandle);
   new(P);
   FillChar(P^,sizeof(TInfoToolButton),0);
   P.Name:=PCTB.Name;
   P.Hint:=PCTB.Hint;
   Section:=ConstToolBar+''+PToolBar.Name;
   P.ShortCut:=PCTB.ShortCut;
//   P.ShortCut:=ReadParam(Section,P.name+'ShortCut',PCTB.ShortCut);
   if isValidPointer(@PCTB.ToolButtonClickProc) then
     P.ToolButtonClickProc:=PCTB.ToolButtonClickProc;
   P.Style:=PCTB.Style;
   P.Control:=PCTB.Control;
   if isValidPointer(PCTB.Bitmap) then begin
    bmp:=TBitmap.Create;
    bmp.Assign(PCTB.Bitmap);
    P.Bitmap:=bmp;
   end;
   PToolBar.List.Add(P);
   AddToolButton(PToolBar.ToolBar,P);
   Result:=THandle(P);
  except
    on E: Exception do begin
      FillChar(TCLI,SizeOf(TCLI),0);
      TCLI.Text:=PChar(Format(fmtCreateToolButtonError,[PCTB.Name,E.Message]));
      TCLI.TypeLogItem:=tliError;
      CreateLogItem_(@TCLI);
    end;
  end;
end;

function GetToolButton(tb: TNewToolBar; P: PInfoToolButton): TNewToolButton;
var
  i: Integer;
  tbut: TNewToolButton;
begin
  Result:=nil;
  if tb=nil then exit;
  for i:=0 to tb.ButtonCount-1 do begin
    tbut:=TNewToolButton(tb.Buttons[i]);
    if tbut.P=P then begin
      Result:=tbut;
      exit;
    end;
  end; 
end;

function FreeToolButton_(ToolButtonHandle: THandle): Boolean;stdcall;

  procedure SetNewImageIndex(PToolBar: PInfoToolBar; FromPos,DecInc: Integer);
  var
    i: Integer;
    but: TToolButton;
  begin
    if PToolBar.ToolBar=nil then exit;
    for i:=0 to PToolBar.ToolBar.ButtonCount-1 do begin
      but:=PToolBar.ToolBar.Buttons[i];
      if But.ImageIndex=FromPos then But.ImageIndex:=-1;
      if But.ImageIndex>FromPos then
        But.ImageIndex:=But.ImageIndex+DecInc;
    end;
  end;
   
var
  P: PInfoToolButton;
  PToolBar: PInfoToolBar;
  val: Integer;
  tbut: TNewToolButton;
  ind: Integer;
begin
  Result:=false;
  P:=Pointer(ToolButtonHandle);
  PToolBar:=GetToolBarFromToolButton(P);
  if PToolBar=nil then exit;
  val:=PToolBar.List.IndexOf(P);
  if val=-1 then exit;
  tbut:=GetToolButton(PToolBar.ToolBar,P);
  if tbut<>nil then begin
    if tbut.ImageIndex<>-1 then begin
     ind:=tbut.ImageIndex;
     SetNewImageIndex(PToolBar,ind,-1);
     PToolBar.ImageList.Delete(ind);
    end;
    tbut.Free;
  end;
  if P.Control<>nil then
    P.Control.Parent:=nil;
  if P.Bitmap<>nil then
   P.Bitmap.Free;

  PToolBar.List.Remove(P);
  Dispose(P);
end;

function isValidToolBar_(ToolBarHandle: THandle): Boolean; stdcall;
var
  val: Integer;
  P: PInfoToolBar;
begin
  Result:=false;
  P:=Pointer(ToolBarHandle);
  val:=ListToolBars.IndexOf(P);
  if val=-1 then exit;
  Result:=true;
end;

function isValidToolButton_(ToolButtonHandle: THandle): Boolean; stdcall;
var
  P: PInfoToolButton;
  PToolBar: PInfoToolBar;
  val: Integer;
begin
  Result:=false;
  P:=Pointer(ToolButtonHandle);
  PToolBar:=GetToolBarFromToolButton(P);
  if PToolBar=nil then exit;
  val:=PToolBar.List.IndexOf(P);
  if val=-1 then exit;
  Result:=true;
end;

procedure PrepearToolBars;
begin
  if fmMain=nil then exit;
  fmMain.ctrlBarTop.StickControls;
  fmMain.ctrlBarBottom.StickControls;
end;

// -------------- Options ---------------------

procedure ClearListOptions;
var
  i: Integer;
  P: PInfoOption;
begin
  for i:=ListOptions.Count-1 downto 0 do begin
    P:=ListOptions.Items[i];
    FreeOption_(THandle(P));
  end;
end;

procedure AddToListOptionsRoot;

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
    OCLocal.CheckOptionProc:=CheckOptionProc;
    if ImageIndex<>-1 then begin
     fmMainOptions.ilOptions.GetBitmap(ImageIndex,Image);
     OCLocal.Bitmap:=Image;
    end;
    Result:=CreateOption_(ParentHandle,@OCLocal);
   finally
     Image.Free;
   end;
  end;

begin
  hOptionGeneral:=CreateOptionLocal(OPTION_ROOT_HANDLE,ConstOptionGeneral,-1);
  hOptionDataBase:=CreateOptionLocal(hOptionGeneral,ConstOptionDataBase,-1);
  hOptionDirs:=CreateOptionLocal(hOptionGeneral,ConstOptionDirs,-1);
  hOptionShortCut:=CreateOptionLocal(hOptionGeneral,ConstOptionShortCut,-1);
  hOptionLibrary:=CreateOptionLocal(hOptionGeneral,ConstOptionLibrary,0);
  hOptionLog:=CreateOptionLocal(hOptionGeneral,ConstOptionLog,1);
  hOptionSqlMonitor:=CreateOptionLocal(hOptionGeneral,ConstOptionSqlMonitor,-1);
  hOptionInterfaces:=CreateOptionLocal(hOptionGeneral,ConstOptionInterfaces,-1);
  hOptionVisual:=CreateOptionLocal(hOptionGeneral,ConstOptionVisual,-1);
 
  hOptionRBooks:=CreateOptionLocal(OPTION_ROOT_HANDLE,ConstOptionRBooks,-1);
end;

function GetParentListOption(P: PInfoOption; IncludeRoot: Boolean): TList;
var
  isBreak: Boolean;

  function GetLocal(ListParent: TList; PLocal: PInfoOption): TList;
  var
    i: Integer;
    P: PInfoOption;
  begin
    Result:=nil;
    if isBreak then exit;
    for i:=0 to ListParent.Count-1 do begin
      P:=ListParent.Items[i];
      if P=PLocal then begin
        Result:=P.List;
        isBreak:=true;
        exit;
      end else begin
        Result:=GetLocal(P.List,PLocal);
        if Result<>nil then begin
          isBreak:=true;
          exit;
        end;
      end;
    end;
  end;

begin
  if IncludeRoot then
   if THandle(P)=OPTION_ROOT_HANDLE then begin
    Result:=ListOptions;
    exit;
   end;
  isBreak:=false;
  Result:=GetLocal(ListOptions,P);
end;

function GetListOption(P: PInfoOption): TList;
var
  isBreak: Boolean;

  function GetLocal(ListParent: TList; PLocal: PInfoOption): TList;
  var
    i: Integer;
    P: PInfoOption;
  begin
    Result:=nil;
    if isBreak then exit;
    for i:=0 to ListParent.Count-1 do begin
      P:=ListParent.Items[i];
      if P=PLocal then begin
        Result:=ListParent;
        isBreak:=true;
        exit;
      end else begin
        Result:=GetLocal(P.List,PLocal);
        if Result<>nil then begin
          isBreak:=true;
          exit;
        end;
      end;
    end;
  end;

begin
  isBreak:=false;
  Result:=GetLocal(ListOptions,P);
end;

{function GetOptionFromName(Name: PChar; ListLevel: TList): PInfoOption;
var
  isBreak: Boolean;

  function GetLocalOption(ListParent: TList; Name: PChar): PInfoOption;
  var
    i: Integer;
    P: PInfoOption;
  begin
    Result:=nil;
    if isBreak then exit;
    for i:=0 to ListParent.Count-1 do begin
      P:=ListParent.Items[i];
      if (AnsiUpperCase(P.Name)=AnsiUpperCase(Name))and
         (ListParent=ListLevel) then begin
        Result:=P;
        isBreak:=true;
        exit;
      end else begin
        Result:=GetLocalOption(P.List,Name);
        if Result<>nil then begin
          isBreak:=true;
          exit;
        end;
      end;
    end;
  end;

begin
  isBreak:=false;
  Result:=GetLocalOption(ListOptions,Name);
end;                                                                    }

function GetOptionFromNameEx(Name: string; ParentName: string; Pref: string): PInfoOption;

type
  PInfoTemp=^TInfoTemp;
  TInfoTemp=packed record
    Root: string;
    P: PInfoOption;
  end;

  procedure ClearListInfoTemp(List: TList);
  var
    i: Integer;
    P: PInfoTemp;
  begin
    for i:=0 to List.Count-1 do begin
      P:=List.Items[i];
      Dispose(P);
    end;
    List.Clear;
  end;

  procedure FillListInfoTemp(ls,ListCurrent: TList; RootParent: string);
  var
    P: PInfoTemp;
    POption: PInfoOption;
    i: Integer;
  begin
    for i:=0 to ListCurrent.Count-1 do begin
      POption:=ListCurrent.Items[i];
      New(P);
      P.Root:=RootParent+Pref+POption.Name;
      P.P:=POption;
      ls.Add(P);
      FillListInfoTemp(ls,POption.List,P.Root);
    end;
  end;

var
  RootFind: string;
  ls: TList;
  i: Integer;
  P: PInfoTemp;
begin
  Result:=nil;
  RootFind:=ParentName+Pref+Name;
  ls:=TList.Create;
  try
   FillListInfoTemp(ls,ListOptions,'');
   for i:=0 to ls.Count-1 do begin
     P:=ls.Items[i];
     if AnsiUpperCase(P.Root)=AnsiUpperCase(RootFind) then begin
       Result:=P.P;
       exit;
     end;
   end;
  finally
   ClearListInfoTemp(ls);
   ls.Free;
  end;
end;

function GetPathFromOption(Node: TTreeNode; Pref: string): String;
var
  nd: TTreeNode;
begin
  Result:='';
  nd:=Node;
  if nd=nil then exit;
  Result:=Pref+nd.Text;
  while nd.Parent<>nil do begin
    nd:=nd.Parent;
    Result:=nd.Text+Pref+Result;
  end;
end;

function CreateOption_(ParentHandle: THandle; PCO: PCreateOption): THandle;stdcall;
var
  P: PInfoOption;
  ListParent: TList;
  List: TList;
  bmp: TBitmap;
  ndParent: TTreeNode;
  PParent,PExist: PInfoOption;
  AndMask: TBitmap;
  s: string;
begin
  Result:=OPTION_INVALID_HANDLE;
  if fmOptions=nil then exit;
  if not isValidPointer(PCO,Sizeof(TCreateOption)) then exit;
  PParent:=Pointer(ParentHandle);
  ListParent:=GetParentListOption(PParent,true);
  if ListParent=nil then exit;
  if ParentHandle=OPTION_ROOT_HANDLE then begin
    ndParent:=nil;
  end else begin
    ndParent:=PParent.TreeNode;
  end;
  New(P);
  FillChar(P^,Sizeof(TInfoOption),0);
  P.Name:=PCO.Name;
  List:=TList.Create;
  P.List:=List;
  if isValidPointer(@PCO.BeforeSetOptionProc) then
    P.BeforeSetOptionProc:=PCO.BeforeSetOptionProc;
  if isValidPointer(@PCO.AfterSetOptionProc) then
    P.AfterSetOptionProc:=PCO.AfterSetOptionProc;
  if isValidPointer(@PCO.CheckOptionProc) then
    P.CheckOptionProc:=PCO.CheckOptionProc;
  s:=GetPathFromOption(ndParent,'->');
  PExist:=GetOptionFromNameEx(P.Name,s,'->');
  if PExist=nil then begin
   P.SelfTabSheet:=TDefaultTabSheet.Create(nil);
   P.TabSheet:=P.SelfTabSheet;
   P.SelfTabSheet.PageControl:=fmOptions.pg;
   P.SelfTabSheet.TabVisible:=false;
   P.SelfTreeNode:=fmOptions.TV.Items.AddChildObject(ndParent,P.Name,P);
   P.TreeNode:=P.SelfTreeNode;
   if isValidPointer(PCO.Bitmap) then begin
     if not PCO.Bitmap.Empty then begin
      bmp:=TBitmap.Create;
      bmp.Assign(PCO.Bitmap);
      P.Bitmap:=bmp;
      AndMask:=TBitmap.Create;
      try
        CopyBitmap(P.Bitmap,AndMask);
        AndMask.Mask(AndMask.Canvas.Pixels[0,0]);
        P.SelfTreeNode.ImageIndex:=fmOptions.ilTv.Add(P.Bitmap,AndMask);
        P.SelfTreeNode.SelectedIndex:=P.SelfTreeNode.ImageIndex;
        P.SelfTreeNode.StateIndex:=-1;
      finally
        AndMask.Free;
      end;
     end; 
   end;
  end else begin
   P.TabSheet:=PExist.SelfTabSheet;
   P.TreeNode:=PExist.SelfTreeNode;
  end;
  SetImageToTreeNodes(fmOptions.TV);
  ListParent.Add(P);
  Result:=THandle(P);
end;

function isExistsOtherInfoOption(PFound: PInfoOption): Boolean;
var
  isBreak: Boolean;

  function isExistsOtherLocal(ListParent: TList): Boolean;
  var
    i: Integer;
    P: PInfoOption;
  begin
    Result:=false;
    if isBreak then exit;
    for i:=0 to ListParent.Count-1 do begin
      P:=ListParent.Items[i];
      if P<>PFound then begin
        if P.TreeNode=PFound.SelfTreeNode then begin
          P.SelfTreeNode:=PFound.SelfTreeNode;
          Result:=true;
          isBreak:=true;
          exit;
        end else begin
          Result:=isExistsOtherLocal(P.List);
          if Result then begin
            isBreak:=true;
            exit;
          end;
        end;
      end else begin
       Result:=isExistsOtherLocal(P.List);
       if Result then begin
         isBreak:=true;
         exit;
       end;
      end;
    end;
  end;

begin
  isBreak:=false;
  Result:=isExistsOtherLocal(ListOptions);
end;

function FreeOption_(OptionHandle: THandle): Boolean;stdcall;

   procedure SetNewImageIndex(List: TList; FromPos,DecInc: Integer);
   var
     i: Integer;
     P: PInfoOption;
   begin
    try
     for i:=0 to List.Count-1 do begin
       P:=List.Items[i];
       if P.TreeNode<>nil then begin
         if P.TreeNode.ImageIndex>2 then begin
          if P.TreeNode.ImageIndex=FromPos then begin
           P.TreeNode.ImageIndex:=-1;
           P.TreeNode.SelectedIndex:=-1;
          end;
          if P.TreeNode.ImageIndex>FromPos then begin
           P.TreeNode.ImageIndex:=P.TreeNode.ImageIndex+DecInc;
           P.TreeNode.SelectedIndex:=P.TreeNode.SelectedIndex+DecInc;
          end;
         end;
       end;
       SetNewImageIndex(P.List,FromPos,DecInc);
     end;
    except
    end; 
   end;

var
  ListParent: TList;
  i: Integer;
  PParent,P: PInfoOption;
  ind: Integer;
begin
  Result:=false;
  try
   if fmOptions=nil then exit;
   ListParent:=GetListOption(Pointer(OptionHandle));
   if ListParent=nil then exit;
   PParent:=Pointer(OptionHandle);
   for i:=PParent.List.Count-1 downto 0 do begin
    P:=PParent.List.Items[i];
    FreeOption_(THandle(P));
   end;
   if PParent.SelfTabSheet<>nil then PParent.SelfTabSheet.Free;
   if PParent.Bitmap<>nil then PParent.Bitmap.Free;
   if PParent.SelfTreeNode<>nil then begin
    if not isExistsOtherInfoOption(PParent) then begin
     if PParent.SelfTreeNode.ImageIndex>2 then begin
      ind:=PParent.SelfTreeNode.ImageIndex;
      SetNewImageIndex(ListOptions,ind,-1);
      fmOptions.ilTV.Delete(ind);
     end;
     PParent.SelfTreeNode.Delete;
    end;
   end;
   SetImageToTreeNodes(fmOptions.TV);
   ListParent.Remove(PParent);
   PParent.List.Free;
   Dispose(PParent);
   Result:=True;
  finally
  end;
end;

function GetOptionHandleFromNode(nd: TTreeNode): THandle;
var
  isBreak: Boolean;

  function GetLocal(List: TList): PInfoOption;
  var
    i: Integer;
    P: PInfoOption;
  begin
    Result:=nil;
    if isBreak then exit;
    for i:=0 to List.Count-1 do begin
      P:=List.Items[i];
      if P.TreeNode=nd then begin
        Result:=P;
        isBreak:=true;
        exit;
      end else begin
        Result:=GetLocal(P.List);
        if Result<>nil then begin
          isBreak:=true;
          exit;
        end;
      end;
    end;
  end;

begin
  isBreak:=false;
  Result:=THandle(GetLocal(ListOptions));
end;

function ViewOption_(OptionHandle: THandle): Boolean; stdcall;
var
  ListParent: TList;
  P: PInfoOption;
begin
  Result:=false;
  if fmOptions=nil then exit;
  P:=Pointer(OptionHandle);
  ListParent:=GetListOption(P);
  if fsModal in fmOptions.FormState then begin
   if ListParent<>nil then begin
    fmOptions.ViewNode(P.TreeNode);
    Result:=true;
   end; 
   exit;
  end;
  BeforeSetOptions_;
  if (ListParent=nil) then begin
   fmOptions.ViewNode(nil);
  end else begin
   fmOptions.ViewNode(P.TreeNode);
  end;
  Result:=fmOptions.ShowModal=mrOk;
  hOptionLast:=GetOptionHandleFromNode(fmOptions.TV.Selected);
  AfterSetOptions_(Result);
  if isRebootProgram then begin
    if ShowQuestion(fmMain.Handle,SRebootProgram)=mrYes then begin
      fmMain.Close;
    end;
  end;
end;

procedure BeforeSetOptionProc(OptionHandle: THandle);stdcall;

  procedure BeforeSetOptions;
  var
    h: THandle;
    wc: TWinControl;
  begin
     h:=OptionHandle;
     wc:=FindControl(GetOptionParentWindow_(h));
     if isValidPointer(wc) then begin
      if h=hOptionGeneral then begin
        fmMainOptions.pc.ActivePage:=fmMainOptions.tsGeneral;
        fmMainOptions.pnGeneral.Parent:=wc;
        fmMainOptions.chbLastOpen.Checked:=isLastOpen;
        fmMainOptions.chbMaximizeMainWindow.Checked:=isMaximizedMainWindow;
        fmMainOptions.CheckBoxVisibleSplash.Checked:=isVisibleSplash;
        fmMainOptions.CheckBoxVisbleSplashVersion.Checked:=isVisibleSplashVerison;
        fmMainOptions.CheckBoxVisibleSplashStatus.Checked:=isVisibleSplashStatus;
      end;
      if h=hOptionDataBase then begin
        fmMainOptions.pc.ActivePage:=fmMainOptions.tsDataBase;
        fmMainOptions.pnDataBase.Parent:=wc;
        fmMainOptions.edBaseDir.Text:=MainDataBaseName;
      end;
      if h=hOptionShortCut then begin
        fmMainOptions.pc.ActivePage:=fmMainOptions.tsShortCut;
        fmMainOptions.pnShortCut.Parent:=wc;
        fmMainOptions.FillTreeViewHotKeys;
        UnRegisterAllHotKeys;
      end;
      if h=hOptionLibrary then begin
        fmMainOptions.pc.ActivePage:=fmMainOptions.tsLibrary;
        fmMainOptions.pnLibrary.Parent:=wc;
        fmMainOptions.FillCheckListBoxLibrary;
        isRebootProgram:=false;
      end;
      if h=hOptionRBooks then begin
        fmMainOptions.pc.ActivePage:=fmMainOptions.tsRBooks;
        fmMainOptions.pnRBooks.Parent:=wc;
        fmMainOptions.chbEditRBOnSelect.Checked:=MnOption.isEditRBOnSelect;
      end;
      if h=hOptionDirs then begin
        fmMainOptions.pc.ActivePage:=fmMainOptions.tsDirs;
        fmMainOptions.pnDirs.Parent:=wc;
        fmMainOptions.edDirsTemp.Text:=TempDir;
      end;
      if h=hOptionLog then begin
        fmMainOptions.pc.ActivePage:=fmMainOptions.tsLog;
        fmMainOptions.lvLog.HandleNeeded;
        fmMainOptions.lvLog.Items.Item[0].Checked:=isLogChecked[0];
        fmMainOptions.lvLog.Items.Item[1].Checked:=isLogChecked[1];
        fmMainOptions.lvLog.Items.Item[2].Checked:=isLogChecked[2];
        fmMainOptions.lvLog.Items.Item[3].Checked:=isLogChecked[3];
        fmMainOptions.pnLog.Parent:=wc;
        fmMainOptions.chbLogStayOnTop.Checked:=fmLog.FormStyle=fsStayOnTop;
        fmMainOptions.chbLogViewDateTime.Checked:=isLogShowDateTime;
        fmMainOptions.EditLogFile.Text:=LogFileName;
      end;
      if h=hOptionSqlMonitor then begin
        fmMainOptions.pc.ActivePage:=fmMainOptions.tsSqlMonitor;
        fmMainOptions.chbSQLMonitorEnabled.Checked:=SQLMonitor.Enabled;
        fmMainOptions.chbSQLPrepear.Checked:=tfQPrepare in SQLMonitor.TraceFlags;
        fmMainOptions.chbSqlExecute.Checked:=tfQExecute in SQLMonitor.TraceFlags;
        fmMainOptions.chbSQLFetch.Checked:=tfQFetch in SQLMonitor.TraceFlags;
        fmMainOptions.chbSQLError.Checked:=tfError in SQLMonitor.TraceFlags;
        fmMainOptions.chbSQLStmt.Checked:=tfStmt in SQLMonitor.TraceFlags;
        fmMainOptions.chbSQLConnect.Checked:=tfConnect in SQLMonitor.TraceFlags;
        fmMainOptions.chbSQLTransact.Checked:=tfTransact in SQLMonitor.TraceFlags;
        fmMainOptions.chbSQLBlob.Checked:=tfBlob in SQLMonitor.TraceFlags;
        fmMainOptions.chbService.Checked:=tfService in SQLMonitor.TraceFlags;
        fmMainOptions.chbSQLMisc.Checked:=tfMisc in SQLMonitor.TraceFlags;
        fmMainOptions.pnSQLMonitor.Parent:=wc;
      end;
      if h=hOptionInterfaces then begin
        fmMainOptions.pc.ActivePage:=fmMainOptions.tsInterfaces;
        fmMainOptions.FillInterfaces;
        fmMainOptions.pnInterfaces.Parent:=wc;
      end;
      if h=hOptionVisual then begin
        fmMainOptions.pc.ActivePage:=fmMainOptions.tsVisual;
        fmMainOptions.pnVisual.Parent:=wc;
        fmMainOptions.chbRBooksVisibleRowNumber.Checked:=MnOption.VisibleRowNumber;
        fmMainOptions.edRBooksTableFont.Font:=MnOption.RBTableFont;
        fmMainOptions.edRBooksTableFont.Text:=MnOption.RBTableFont.Name;
        fmMainOptions.edVisualForms.Font:=MnOption.FormFont;
        fmMainOptions.edVisualForms.Text:=MnOption.FormFont.Name;
        fmMainOptions.chbViewFindPanel.Checked:=MnOption.VisibleFindPanel;
        fmMainOptions.chbViewEditPanel.Checked:=MnOption.VisibleEditPanel;
        fmMainOptions.chbTypeFilter.Checked:=MnOption.TypeFilter=tdbfAnd;

        fmMainOptions.cmbRBooksTableRecordColor.HandleNeeded;
        TTSVColorBox(fmMainOptions.cmbRBooksTableRecordColor).Selected:=MnOption.RBTableRecordColor;
        fmMainOptions.cmbRBooksTableColorCursor.HandleNeeded;
        TTSVColorBox(fmMainOptions.cmbRBooksTableColorCursor).Selected:=MnOption.RBTableCursorColor;
        fmMainOptions.cmbColorElementFocus.HandleNeeded;
        TTSVColorBox(fmMainOptions.cmbColorElementFocus).Selected:=MnOption.ElementFocusColor;
        fmMainOptions.cmbFilterColor.HandleNeeded;
        TTSVColorBox(fmMainOptions.cmbFilterColor).Selected:=MnOption.RbFilterColor;
      end;
     end;
  end;

begin
 try
   fmMainOptions.Visible:=true;
   fmMainOptions.LoadFromIni(OptionHandle);
   MainLoadFromIni;
//   MainLoadFromIniAfterCreateAll; opening last open interfaces

   BeforeSetOptions;

 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure AfterSetOptionProc(OptionHandle: THandle; isOk: Boolean);stdcall;

  procedure AfterSetOptions;
  var
    h: THandle;
    TSPAL: TSetParamsToAdditionalLog;
  begin
      h:=OptionHandle;
      if h=hOptionGeneral then begin
        if isOk then begin
          isLastOpen:=fmMainOptions.chbLastOpen.Checked;
          isMaximizedMainWindow:=fmMainOptions.chbMaximizeMainWindow.Checked;
          isVisibleSplashVerison:=fmMainOptions.CheckBoxVisbleSplashVersion.Checked;
          isVisibleSplashStatus:=fmMainOptions.CheckBoxVisibleSplashStatus.Checked;
        end;
        fmMainOptions.pc.ActivePage:=fmMainOptions.tsGeneral;
        fmMainOptions.pnGeneral.Parent:=fmMainOptions.tsGeneral;
      end;
      if h=hOptionDataBase then begin
         if isOk then
          if fmMainOptions.edBaseDir.Text<>MainDataBaseName then begin
            MainDataBaseName:=fmMainOptions.edBaseDir.Text;
            if not isRefreshEntyes then isRefreshEntyes:=true;
          end;
          fmMainOptions.pc.ActivePage:=fmMainOptions.tsDataBase;
          fmMainOptions.pnDataBase.Parent:=fmMainOptions.tsDataBase;
      end;
      if h=hOptionShortCut then begin
          if isOk then begin
           fmMainOptions.SetHotKeysFromTreeView;
          end;
          RegisterAllHotKeys;
          fmMainOptions.pc.ActivePage:=fmMainOptions.tsShortCut;
          fmMainOptions.pnShortCut.Parent:=fmMainOptions.tsShortCut.Parent;
       end;
       if h=hOptionLibrary then begin
//          fmMainOptions.ClearLocalDlls;
          if isOk then begin
           fmMainOptions.SetLibraryFromCheckListBox;
//           PrepearMenus;
//           PrepearToolBars;
           if not isRefreshEntyes then begin
             //isRefreshEntyes:=fmMainOptions.isChangeLibrary;
             isRefreshEntyes:=false;
             isRebootProgram:=fmMainOptions.isChangeLibrary;
           end;
          end;
          fmMainOptions.pc.ActivePage:=fmMainOptions.tsLibrary;
          fmMainOptions.pnLibrary.Parent:=fmMainOptions.tsLibrary;
       end;
       if h=hOptionRBooks then begin
          if isOk then begin
            MnOption.isEditRBOnSelect:=fmMainOptions.chbEditRBOnSelect.Checked;
          end;
          fmMainOptions.pc.ActivePage:=fmMainOptions.tsRBooks;
          fmMainOptions.pnRBooks.Parent:=fmMainOptions.tsRBooks;
       end;
       if h=hOptionDirs then begin
          if isOk then begin
            if (DirectoryExists(fmMainOptions.edDirsTemp.Text)) then begin
              TempDir:=fmMainOptions.edDirsTemp.Text;
              SetMnOption;
            end;
            LogFileName:=fmMainOptions.EditLogFile.Text;
          end; 
          fmMainOptions.pc.ActivePage:=fmMainOptions.tsDirs;
          fmMainOptions.pnDirs.Parent:=fmMainOptions.tsDirs;
       end;
       if h=hOptionLog then begin
          if isOk then begin
            fmMainOptions.lvLog.HandleNeeded;
            isLogChecked[0]:=fmMainOptions.lvLog.Items.Item[0].Checked;
            isLogChecked[1]:=fmMainOptions.lvLog.Items.Item[1].Checked;
            isLogChecked[2]:=fmMainOptions.lvLog.Items.Item[2].Checked;
            isLogChecked[3]:=fmMainOptions.lvLog.Items.Item[3].Checked;
            isLogShowDateTime:=fmMainOptions.chbLogViewDateTime.Checked;
            fmLog.ShowOrHideMainLog;
            if fmMainOptions.chbLogStayOnTop.Checked then  fmLog.FormStyle:=fsStayOnTop
            else fmLog.FormStyle:=fsNormal;
            TSPAL.Limit:=fmMainOptions.udLogLimit.Position;
            SetParamsToAdditionalLog_(THandle(ListAdditionalLogs.Items[0]),@TSPAL);
          end;
          fmMainOptions.pc.ActivePage:=fmMainOptions.tsLog;
          fmMainOptions.pnLog.Parent:=fmMainOptions.tsLog;
       end;
       if h=hOptionSqlMonitor then begin
        if isOk then begin
          SetLoadingSQLMonitorOptions;
        end;
        fmMainOptions.pc.ActivePage:=fmMainOptions.tsSqlMonitor;
        fmMainOptions.pnSQLMonitor.Parent:=fmMainOptions.tsSqlMonitor;
       end;
       if h=hOptionInterfaces then begin
        fmMainOptions.pc.ActivePage:=fmMainOptions.tsInterfaces;
        fmMainOptions.pnInterfaces.Parent:=fmMainOptions.tsInterfaces;
       end;
       if h=hOptionVisual then begin
          if isOk then begin
           MnOption.RBTableFont:=fmMainOptions.edRBooksTableFont.Font;
           MnOption.RBTableRecordColor:=TTSVColorBox(fmMainOptions.cmbRBooksTableRecordColor).Selected;
           MnOption.RBTableCursorColor:=TTSVColorBox(fmMainOptions.cmbRBooksTableColorCursor).Selected;
           MnOption.RbFilterColor:=TTSVColorBox(fmMainOptions.cmbFilterColor).Selected;
           MnOption.VisibleRowNumber:=fmMainOptions.chbRBooksVisibleRowNumber.Checked;
           MnOption.FormFont:=fmMainOptions.edVisualForms.Font;
           MnOption.VisibleFindPanel:=fmMainOptions.chbViewFindPanel.Checked;
           MnOption.VisibleEditPanel:=fmMainOptions.chbViewEditPanel.Checked;
           MnOption.ElementFocusColor:=TTSVColorBox(fmMainOptions.cmbColorElementFocus).Selected;
           MnOption.TypeFilter:=Iff(fmMainOptions.chbTypeFilter.Checked,tdbfAnd,tdbfOr);
          end;
          fmMainOptions.pc.ActivePage:=fmMainOptions.tsVisual;
          fmMainOptions.pnVisual.Parent:=fmMainOptions.tsVisual;
       end;
  end;

begin
 try
   if isOk then begin
     fmMainOptions.SaveToIni(OptionHandle);
     MainSaveToIni;
   end else fmMainOptions.LoadFromIni(OptionHandle);
   AfterSetOptions;
   fmMainOptions.Visible:=false;

 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure CheckOptionProc(OptionHandle: THandle; var CheckFail: Boolean);stdcall;
begin
 if OptionHandle=hOptionDirs then 
  CheckFail:=not DirectoryExists(fmMainOptions.edDirsTemp.Text);
  if CheckFail then begin
    ViewOption_(OptionHandle);
    ShowErrorEx('Директория <'+Trim(fmMainOptions.edDirsTemp.Text)+'> не существует.');
    fmMainOptions.edDirsTemp.SetFocus;
  end;  
end;

function GetOptionParentWindow_(OptionHandle: THandle): THandle;stdcall;
var
  P: PInfoOption;
  ListParent: TList;
begin
  Result:=OPTION_INVALID_PARENTWINDOW;
  P:=Pointer(OptionHandle);
  ListParent:=GetListOption(P);
  if ListParent=nil then exit;
  if P.SelfTabSheet=nil then exit;
  Result:=P.SelfTabSheet.Handle;
end;

function isValidOption_(OptionHandle: THandle): Boolean; stdcall;
var
  ListParent: TList;
begin
  Result:=false;
  ListParent:=GetListOption(Pointer(OptionHandle));
  if ListParent=nil then exit;
  Result:=true;
end;

procedure BeforeSetOptions_; stdcall;

   procedure BeforeSetOptionsLocal(List: TList);
   var
     i: Integer;
     P: PInfoOption;
   begin
     for i:=List.Count-1 downto 0 do begin
       P:=List.Items[i];
       if isValidPointer(@P.BeforeSetOptionProc) then begin
         P.BeforeSetOptionProc(THandle(P));
       end;
       BeforeSetOptionsLocal(P.List);
     end;
   end;

begin
 try
  Screen.Cursor:=crHourGlass;
  try
    BeforeSetOptionsLocal(ListOptions);
  finally
    Screen.Cursor:=crDefault;
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure AfterSetOptions_(isOk: Boolean); stdcall;

   procedure AfterSetOptionsLocal(List: TList);
   var
     i: Integer;
     P: PInfoOption;
   begin
     for i:=List.Count-1 downto 0 do begin
       P:=List.Items[i];
       if isValidPointer(@P.AfterSetOptionProc) then begin
         P.AfterSetOptionProc(THandle(P),isOk);
       end;
       AfterSetOptionsLocal(P.List);
     end;
   end;

begin
 try
  Screen.Cursor:=crHourGlass;
  try
    AfterSetOptionsLocal(ListOptions);
  finally
    Screen.Cursor:=crDefault;
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

function CheckOptions_: Boolean; stdcall;
var
  CheckFail: Boolean;

   procedure CheckOptionsLocal(List: TList);
   var
     i: Integer;
     P: PInfoOption;
   begin
     if CheckFail then exit;
     for i:=List.Count-1 downto 0 do begin
       P:=List.Items[i];
       if isValidPointer(@P.CheckOptionProc) then begin
         P.CheckOptionProc(THandle(P),CheckFail);
         if CheckFail then begin
           exit;
         end;
       end;
       CheckOptionsLocal(P.List);
     end;
   end;

begin
  CheckFail:=false;
  Result:=false;
  try
   CheckOptionsLocal(ListOptions);
   Result:=not CheckFail;
  except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;


// -------------- Menus ---------------------

procedure ClearListMenus;
var
  i: Integer;
  P: PInfoMenu;
begin
  for i:=ListMenus.Count-1 downto 0 do begin
    P:=ListMenus.Items[i];
    FreeMenu_(THandle(P));
  end;
end;

procedure MenuClickProc(MenuHandle: THandle);stdcall;
var
  fm: TfmChangePass;
  fmAbout: TfmAbout;
  TPRBI: TParamRBookInterface;
begin
  //ShowMessage(PInfoMenu(MenuHandle).Name);
  if fmMain=nil then exit;
{  if MenuHandle=hMenuFileRefresh then begin
    RefreshFromBase;
  end;
  if MenuHandle=hMenuFileLogin then begin
    SaveDataIniToBase;
    if LoginToProgram then begin
      fmMain.Caption:=MainCaption+' - '+UserName;
      Application.Title:=MainCaption;
      RefreshFromBase;
    end;
  end;}
  if MenuHandle=hMenuFileExit then begin
    fmMain.Close;
  end;
  if MenuHandle=hMenuViewLog then begin
    if not isValidAdditionalLog_(hAdditionalLogLast) then
     hAdditionalLogLast:=hAdditionalLogMain;
    ViewAdditionalLog_(hAdditionalLogLast,true);
  end;
  if MenuHandle=hMenuServiceChangePassword then begin
    fm:=nil;
    try
     fm:=TfmChangePass.Create(nil);
     fm.ShowModal;
    finally
     fm.Free;
    end;
  end;
  if MenuHandle=hMenuServiceOptions then begin
     ViewOption_(hOptionLast);
  end;
  if MenuHandle=hMenuWindowsLast then begin
     FillChar(TPRBI,Sizeof(TPRBI),0);
     ViewInterface_(hInterfaceLast,@TPRBI);
  end;
  if MenuHandle=hMenuWindowsCascade then begin
     fmMain.Cascade;
  end;
  if MenuHandle=hMenuWindowsVert then begin
     fmMain.TileMode:=tbVertical;
     fmMain.Tile;
  end;
  if MenuHandle=hMenuWindowsGoriz then begin
     fmMain.TileMode:=tbHorizontal;
     fmMain.Tile;
  end;
  if MenuHandle=hMenuWindowsMinAll then begin
     fmMain.MinimizeRestoreClose(twofaMinimize);
  end;
  if MenuHandle=hMenuWindowsCloseAll then begin
     fmMain.MinimizeRestoreClose(twofaClose);
  end;
  if MenuHandle=hMenuWindowsResAll then begin
     fmMain.MinimizeRestoreClose(twofaRestore);
  end;
  if MenuHandle=hMenuHelpAbout then begin
     fmAbout:=nil;
     try
      fmAbout:=TfmAbout.Create(nil);
      fmAbout.ShowModal;
     finally
      FreeAndNil(fmAbout);
     end;
  end;
  if MenuHandle=hMenuConst then begin
     FillChar(TPRBI,Sizeof(TPRBI),0);
     ViewInterface_(hInterfaceConst,@TPRBI);
  end; 
  if MenuHandle=hMenuQuery then begin
     FillChar(TPRBI,Sizeof(TPRBI),0);
     ViewInterface_(hInterfaceQuery,@TPRBI);
  end; 
end;

procedure AddToListMenusRoot;

  function CreateMenuLocal(ParentHandle: THandle; Name: PChar;
                           Hint: PChar;
                           TypeCreateMenu: TTypeCreateMenu=tcmAddLast;
                           InsertMenuHandle: THandle=MENU_INVALID_HANDLE;
                           ImageIndex: Integer=-1;
                           ShortCut: TShortCut=0;
                           Proc: TMenuClickProc=nil;
                           GroupIndex: Byte=0): THandle;
  var
   CMLocal: TCreateMenu;
   Image: TBitmap;
  begin
   Image:=nil;
   try
    Image:=TBitmap.Create;
    FillChar(CMLocal,SizeOf(TCreateMenu),0);
    CMLocal.Name:=Name;
    CMLocal.Hint:=Hint;
    CMLocal.MenuClickProc:=Proc;
    CMLocal.ShortCut:=ShortCut;
    CMLocal.TypeCreateMenu:=TypeCreateMenu;
    CMLocal.InsertMenuHandle:=InsertMenuHandle;
    CMLocal.GroupIndex:=GroupIndex;
    if ImageIndex<>-1 then begin
     fmMain.ilMM.GetBitmap(ImageIndex,Image);
     CMLocal.Bitmap:=Image;
    end;
    Result:=CreateMenu_(ParentHandle,@CMLocal);

   finally
     Image.Free;
   end;
  end;

begin
  if fmMain=nil then exit;
  ListMenusMain.Clear;
  fmMain.mm.Items.Clear;
  hMenuFile:=CreateMenuLocal(MENU_ROOT_HANDLE,ConstsMenuFile,PChar(ChangeString(ConstsMenuFile,'&','')),tcmAddFirst,MENU_INVALID_HANDLE,-1,0,nil,1);
  ListMenusMain.Add(Pointer(hMenuFile));
{  hMenuFileRefresh:=CreateMenuLocal(hMenuFile,'&Обновить данные','Обновить данные',tcmAddLast,MENU_INVALID_HANDLE,35,0,MenuClickProc);
  hMenuFileLogin:=CreateMenuLocal(hMenuFile,'&Войти под пользователем','Войти под пользователем',tcmAddLast,MENU_INVALID_HANDLE,71,0,MenuClickProc);
  CreateMenuLocal(hMenuFile,ConstsMenuSeparator,'');}
  hMenuFileExit:=CreateMenuLocal(hMenuFile,'Вы&ход','Выход из программы',tcmAddLast,MENU_INVALID_HANDLE,69,0,MenuClickProc);

  hMenuEdit:=CreateMenuLocal(MENU_ROOT_HANDLE,ConstsMenuEdit,PChar(ChangeString(ConstsMenuEdit,'&','')),tcmAddLast,MENU_INVALID_HANDLE,-1,0,nil,2);
  ListMenusMain.Add(Pointer(hMenuRBooks));

  hMenuView:=CreateMenuLocal(MENU_ROOT_HANDLE,ConstsMenuView,PChar(ChangeString(ConstsMenuView,'&','')),tcmAddLast,MENU_INVALID_HANDLE,-1,0,nil,3);
  ListMenusMain.Add(Pointer(hMenuView));
  hMenuViewLog:=CreateMenuLocal(hMenuView,'Лог сообщений','Лог сообщений',tcmAddFirst,MENU_INVALID_HANDLE,74,0,MenuClickProc);
  CreateMenuLocal(hMenuView,ConstsMenuSeparator,'');
  hMenuViewToolBars:=CreateMenuLocal(hMenuView,'&Панели инструментов','Панели инструментов');

  hMenuRBooks:=CreateMenuLocal(MENU_ROOT_HANDLE,ConstsMenuRBooks,PChar(ChangeString(ConstsMenuRBooks,'&','')),tcmAddLast,MENU_INVALID_HANDLE,-1,0,nil,4);
  ListMenusMain.Add(Pointer(hMenuRBooks));

  hMenuReports:=CreateMenuLocal(MENU_ROOT_HANDLE,ConstsMenuReports,PChar(ChangeString(ConstsMenuReports,'&','')),tcmAddLast,MENU_INVALID_HANDLE,-1,0,nil,5);
  ListMenusMain.Add(Pointer(hMenuReports));

  hMenuDocums:=CreateMenuLocal(MENU_ROOT_HANDLE,ConstsMenuDocums,PChar(ChangeString(ConstsMenuDocums,'&','')),tcmAddLast,MENU_INVALID_HANDLE,-1,0,nil,6);
  ListMenusMain.Add(Pointer(hMenuDocums));

  hMenuOperations:=CreateMenuLocal(MENU_ROOT_HANDLE,ConstsMenuOperations,PChar(ChangeString(ConstsMenuOperations,'&','')),tcmAddLast,MENU_INVALID_HANDLE,-1,0,nil,7);
  ListMenusMain.Add(Pointer(hMenuOperations));

  hMenuService:=CreateMenuLocal(MENU_ROOT_HANDLE,ConstsMenuService,PChar(ChangeString(ConstsMenuService,'&','')),tcmAddLast,MENU_INVALID_HANDLE,-1,0,nil,8);
  ListMenusMain.Add(Pointer(hMenuService));
  hMenuConst:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceConst) then begin
    hMenuConst:=CreateMenuLocal(hMenuService,'&Константы',NameRbkConst,tcmAddLast,MENU_INVALID_HANDLE,75,0,MenuClickProc);
  end;
  hMenuQuery:=CreateMenuLocal(hMenuService,'&Запрос',NameRbkQuery,tcmAddLast,MENU_INVALID_HANDLE,76,0,MenuClickProc);

  hMenuServiceBCP:=CreateMenuLocal(hMenuService,ConstsMenuSeparator,'');
  hMenuServiceChangePassword:=CreateMenuLocal(hMenuService,'&Смена пароля','Сменить пароль',tcmAddLast,MENU_INVALID_HANDLE,66,0,MenuClickProc);
  CreateMenuLocal(hMenuService,ConstsMenuSeparator,'');
  hMenuServiceOptions:=CreateMenuLocal(hMenuService,'&Настройка','Настройки программы',tcmAddLast,MENU_INVALID_HANDLE,46,0,MenuClickProc);

  hMenuWindows:=CreateMenuLocal(MENU_ROOT_HANDLE,ConstsMenuWindows,PChar(ChangeString(ConstsMenuWindows,'&','')),tcmAddLast,MENU_INVALID_HANDLE,-1,0,nil,9);
  ListMenusMain.Add(Pointer(hMenuWindows));
  hMenuWindowsLast:=CreateMenuLocal(hMenuWindows,'&Последнее окно','Вызвать последнее окно',tcmAddLast,MENU_INVALID_HANDLE,73,0,MenuClickProc);
  hMenuWindowsCascade:=CreateMenuLocal(hMenuWindows,'&Каскадом','Расположить окна каскадом',tcmAddLast,MENU_INVALID_HANDLE,62,0,MenuClickProc);
  hMenuWindowsVert:=CreateMenuLocal(hMenuWindows,'&Вертикально','Расположить окна вертикально',tcmAddLast,MENU_INVALID_HANDLE,61,0,MenuClickProc);
  hMenuWindowsGoriz:=CreateMenuLocal(hMenuWindows,'&Горизонтально','Расположить окна горизонтально',tcmAddLast,MENU_INVALID_HANDLE,63,0,MenuClickProc);
  hMenuWindowsMinAll:=CreateMenuLocal(hMenuWindows,'&Свернуть все','Свернуть все окна',tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);
  hMenuWindowsResAll:=CreateMenuLocal(hMenuWindows,'В&осстановить все','Восстановить все окна',tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);
  hMenuWindowsCloseAll:=CreateMenuLocal(hMenuWindows,'&Закрыть все','Закрыть все окна',tcmAddLast,MENU_INVALID_HANDLE,70,0,MenuClickProc);
  if hMenuWindows<>MENU_INVALID_HANDLE then begin
    fmMain.WindowMenu:=PInfoMenu(hMenuWindows).MenuItem;
  end;

  hMenuHelp:=CreateMenuLocal(MENU_ROOT_HANDLE,ConstsMenuHelp,PChar(ChangeString(ConstsMenuHelp,'&','')),tcmAddLast,MENU_INVALID_HANDLE,-1,0,nil,10);
  ListMenusMain.Add(Pointer(hMenuHelp));
  CreateMenuLocal(hMenuHelp,ConstsMenuSeparator,'');
  hMenuHelpAbout:=CreateMenuLocal(hMenuHelp,'О &программе','Информация о программе',tcmAddLast,MENU_INVALID_HANDLE,24,0,MenuClickProc);

{  CreateMenuLocal(MENU_ROOT_HANDLE,ConstsMenuRBooks,PChar(ChangeString(ConstsMenuRBooks,'&','')),
                  tte_None,tcmInsertBefore,hMenuView,-1,0,nil);

  CreateMenuLocal(MENU_ROOT_HANDLE,ConstsMenuDocums,PChar(ChangeString(ConstsMenuDocums,'&','')),
                  tte_None,tcmInsertAfter,hMenuViewToolBars,-1,0,nil);}

end;

function GetParentListMenu(P: PInfoMenu; IncludeRoot: Boolean): TList;
var
  isBreak: Boolean;

  function GetLocal(ListParent: TList; PLocal: PInfoMenu): TList;
  var
    i: Integer;
    P: PInfoMenu;
  begin
    Result:=nil;
    if isBreak then exit;
    for i:=0 to ListParent.Count-1 do begin
      P:=ListParent.Items[i];
      if P=PLocal then begin
        Result:=P.List;
        isBreak:=true;
        exit;
      end else begin
        Result:=GetLocal(P.List,PLocal);
        if Result<>nil then begin
          isBreak:=true;
          exit;
        end;
      end;
    end;
  end;

begin
  if IncludeRoot then
   if THandle(P)=MENU_ROOT_HANDLE then begin
    Result:=ListMenus;
    exit;
   end;
  isBreak:=false;
  Result:=GetLocal(ListMenus,P);
end;

{function GetMenuFromName(Name: PChar; ListLevel: TList): PInfoMenu;
var
  isBreak: Boolean;

  function GetLocalMenu(ListParent: TList; Name: PChar): PInfoMenu;
  var
    i: Integer;
    P: PInfoMenu;
  begin
    Result:=nil;
    if isBreak then exit;
    for i:=0 to ListParent.Count-1 do begin
      P:=ListParent.Items[i];
      if (AnsiUpperCase(P.Name)=AnsiUpperCase(Name))and
         (ListParent=ListLevel)and
         (P.Name<>ConstsMenuSeparator) then begin
        Result:=P;
        isBreak:=true;
        exit;
      end else begin
        Result:=GetLocalMenu(P.List,Name);
        if Result<>nil then begin
          isBreak:=true;
          exit;
        end;
      end;
    end;
  end;

begin
  isBreak:=false;
  Result:=GetLocalMenu(ListMenus,Name);
end;}

function GetMenuFromNameEx(Name: string; ParentName: string; Pref: string): PInfoMenu;

type
  PInfoTemp=^TInfoTemp;
  TInfoTemp=packed record
    Root: string;
    P: PInfoMenu;
  end;

  procedure ClearListInfoTemp(List: TList);
  var
    i: Integer;
    P: PInfoTemp;
  begin
    for i:=0 to List.Count-1 do begin
      P:=List.Items[i];
      Dispose(P);
    end;
    List.Clear;
  end;

  procedure FillListInfoTemp(ls,ListCurrent: TList; RootParent: string);
  var
    P: PInfoTemp;
    PMenu: PInfoMenu;
    i: Integer;
  begin
    for i:=0 to ListCurrent.Count-1 do begin
      PMenu:=ListCurrent.Items[i];
      New(P);
      P.Root:=RootParent+Pref+PMenu.Name;
      P.P:=PMenu;
      ls.Add(P);
      FillListInfoTemp(ls,PMenu.List,P.Root);
    end;
  end;

var
  RootFind: string;
  ls: TList;
  i: Integer;
  P: PInfoTemp;
begin
  Result:=nil;
  if Name=ConstsMenuSeparator then exit;
  RootFind:=ParentName+Pref+Name;
  ls:=TList.Create;
  try
   FillListInfoTemp(ls,ListMenus,'');
   for i:=0 to ls.Count-1 do begin
     P:=ls.Items[i];
     if AnsiUpperCase(P.Root)=AnsiUpperCase(RootFind) then begin
       Result:=P.P;
       exit;
     end;
   end; 
  finally
   ClearListInfoTemp(ls);
   ls.Free;
  end;
end;

function GetRootMenuItem(miParent: TMenuItem; Name: PChar): TMenuItem;
var
  i: Integer;
  mi: TMenuItem;
begin
  Result:=miParent;
  for i:=0 to miParent.Count-1 do begin
    mi:=miParent.Items[i];
    if AnsiUpperCase(mi.Caption)=AnsiUpperCase(Name) then begin
      Result:=mi;
      exit;
    end;
  end;
end;

function GetListMenu(P: PInfoMenu): TList;
var
  isBreak: Boolean;

  function GetLocal(ListParent: TList; PLocal: PInfoMenu): TList;
  var
    i: Integer;
    P: PInfoMenu;
  begin
    Result:=nil;
    if isBreak then exit;
    for i:=0 to ListParent.Count-1 do begin
      P:=ListParent.Items[i];
      if P=PLocal then begin
        Result:=ListParent;
        isBreak:=true;
        exit;
      end else begin
        Result:=GetLocal(P.List,PLocal);
        if Result<>nil then begin
          isBreak:=true;
          exit;
        end;
      end;
    end;
  end;

begin
  isBreak:=false;
  Result:=GetLocal(ListMenus,P);
end;

function GetPathFromMenu(MenuItem: TMenuItem; Pref: string): String;
var
  mi: TMenuITem;
begin
  mi:=MenuItem;
  Result:=mi.Caption;
  while mi.Parent<>nil do begin
    mi:=mi.Parent;
    Result:=mi.Caption+Pref+Result;
  end;
end;

function CreateMenu_(ParentHandle: THandle; PCM: PCreateMenu):THandle;stdcall;
var
  PParent,P: PInfoMenu;
  ListParent: TList;
  List: TList;
  PExist: PInfoMenu;
  Section: string;
  bmp,AndMask: TBitmap;
  miParent: TMenuItem;
  PInsert: PInfoMenu;
  s: string;
  TCLI: TCreateLogItem;
begin
  Result:=MENU_INVALID_HANDLE;
  try
    if fmMain=nil then exit;
    if not IsValidPointer(PCM,sizeof(TCreateMenu)) then exit;
    PParent:=Pointer(ParentHandle);
    ListParent:=GetParentListMenu(PParent,true);
    if ListParent=nil then exit;
    PInsert:=PInfoMenu(PCM.InsertMenuHandle);
    case PCM.TypeCreateMenu of
      tcmInsertBefore,tcmInsertAfter: begin
        if not isValidPointer(PInsert,sizeof(TInfoMenu)) then exit;
        if GetListMenu(PInsert)<>ListParent then exit;
      end;
    end;
    if ParentHandle=MENU_ROOT_HANDLE then begin
      miParent:=fmMain.mm.Items;
    end else begin
      miParent:=PParent.MenuItem;
    end;

    New(P);
    FillChar(P^,Sizeof(TInfoMenu),0);
    P.Name:=PCM.Name;
    P.Hint:=PCM.Hint;
    if isValidPointer(@PCM.MenuClickProc) then
      P.MenuClickProc:=PCM.MenuClickProc;
    Section:=ConstSectionHotKey;
    s:=GetPathFromMenu(miParent,'->');
    if P.Name<>ConstsMenuSeparator then begin
     P.ShortCut:=ReadParam(Section,'Меню'+s+'->'+P.Name,PCM.ShortCut);
    end;
    List:=TList.Create;
    P.List:=List;
    PExist:=GetMenuFromNameEx(P.Name,s,'->');
    if PExist=nil then begin
     P.SelfMenuItem:=TNewMenuItem.Create(nil);
     P.MenuItem:=P.SelfMenuItem;
     P.SelfMenuItem.Caption:=P.Name;
     P.SelfMenuItem.Hint:=P.Hint;
     P.SelfMenuItem.ShortCut:=P.ShortCut;
     P.SelfMenuItem.P:=P;
     P.SelfMenuItem.OnClick:=fmMain.MenuClick;
     P.SelfMenuItem.GroupIndex:=PCM.GroupIndex;
     case PCM.TypeCreateMenu of
       tcmAddLast: begin
        if (miParent.Find(P.Name)=nil)or(P.Name=ConstsMenuSeparator) then
          miParent.Add(P.SelfMenuItem);
       end;
       tcmAddFirst: begin
        if (miParent.Find(P.Name)=nil)or(P.Name=ConstsMenuSeparator) then begin
          miParent.Insert(0,P.SelfMenuItem);
        end;
       end;
       tcmInsertBefore: begin
        if (miParent.Find(P.Name)=nil)or(P.Name=ConstsMenuSeparator)then begin
          miParent.Insert(PInsert.MenuItem.MenuIndex,P.SelfMenuItem);
        end;
       end;
       tcmInsertAfter: begin
        if (miParent.Find(P.Name)=nil)or(P.Name=ConstsMenuSeparator) then begin
          miParent.Insert(PInsert.MenuItem.MenuIndex+1,P.SelfMenuItem);
        end;
       end;
     end;

     if isValidPointer(PCM.Bitmap) then begin
       if not PCM.Bitmap.Empty then begin
        bmp:=TBitmap.Create;
        bmp.Assign(PCM.Bitmap);
        P.Bitmap:=bmp;
        AndMask:=TBitmap.Create;
        try
          CopyBitmap(P.Bitmap,AndMask);
          AndMask.Mask(AndMask.Canvas.Pixels[0,0]);
          P.SelfMenuItem.ImageIndex:=fmMain.ilMM.Add(P.Bitmap,AndMask);
        finally
          AndMask.Free;
        end;
       end;
     end;

    end else begin
     if not PCM.ChangePrevious then begin
       P.MenuItem:=PExist.SelfMenuItem;
     end else begin
       P.SelfMenuItem:=PExist.SelfMenuItem;
       P.MenuItem:=PExist.SelfMenuItem;
       PExist.SelfMenuItem:=nil;
       P.SelfMenuItem.Caption:=P.Name;
       P.SelfMenuItem.Hint:=P.Hint;
       P.SelfMenuItem.ShortCut:=P.ShortCut;
       P.SelfMenuItem.P:=P;
       P.SelfMenuItem.OnClick:=fmMain.MenuClick;

       if isValidPointer(PCM.Bitmap) then begin
         if not PCM.Bitmap.Empty then begin
          bmp:=TBitmap.Create;
          bmp.Assign(PCM.Bitmap);
          P.Bitmap:=bmp;
          AndMask:=TBitmap.Create;
          try
            CopyBitmap(P.Bitmap,AndMask);
            AndMask.Mask(AndMask.Canvas.Pixels[0,0]);
            fmMain.ilMM.Replace(P.SelfMenuItem.ImageIndex,P.Bitmap,AndMask);
          finally
            AndMask.Free;
          end;
         end;
       end;

     end;
    end;

    ListParent.Add(P);
    Result:=THandle(P);
   except
     on E: Exception do begin
       FillChar(TCLI,SizeOf(TCLI),0);
       TCLI.Text:=PChar(Format(fmtCreateMenuError,[PCM.Name,E.Message]));
       TCLI.TypeLogItem:=tliError;
       CreateLogItem_(@TCLI);
     end;
   end;
end;

function isExistsOtherInfoMenu(PFound: PInfoMenu): Boolean;
var
  isBreak: Boolean;

  function isExistsOtherLocal(ListParent: TList): Boolean;
  var
    i: Integer;
    P: PInfoMenu;
  begin
    Result:=false;
    if isBreak then exit;
    for i:=0 to ListParent.Count-1 do begin
      P:=ListParent.Items[i];
      if P<>PFound then begin
        if P.MenuItem=PFound.SelfMenuItem then begin
          P.SelfMenuItem:=PFound.SelfMenuItem;
          Result:=true;
          isBreak:=true;
          exit;
        end else begin
          Result:=isExistsOtherLocal(P.List);
          if Result then begin
            isBreak:=true;
            exit;
          end;
        end;
      end else begin
       Result:=isExistsOtherLocal(P.List);
       if Result then begin
         isBreak:=true;
         exit;
       end;
      end;
    end;
  end;

begin
  isBreak:=false;
  Result:=isExistsOtherLocal(ListMenus);
end;

function FreeMenu_(MenuHandle: THandle): Boolean;stdcall;

   procedure SetNewImageIndex(List: TList; FromPos,DecInc: Integer);
   var
     i: Integer;
     P: PInfoMenu;
   begin
     for i:=0 to List.Count-1 do begin
       P:=List.Items[i];
       if P.MenuItem<>nil then begin
          if P.MenuItem.ImageIndex=FromPos then P.MenuItem.ImageIndex:=-1;
          if P.MenuItem.ImageIndex>FromPos then P.MenuItem.ImageIndex:=P.MenuItem.ImageIndex+DecInc;
       end;
       SetNewImageIndex(P.List,FromPos,DecInc);
     end;
   end;

var
  ListParent: TList;
  i: Integer;
  PFree,P: PInfoMenu;
  ind: Integer;
  Section: string;
  s: string;
begin
  Result:=false;
   if fmMain=nil then exit;
   PFree:=PInfoMenu(MenuHandle);
   ListParent:=GetListMenu(PFree);
   if ListParent=nil then exit;

   Section:=ConstSectionHotKey;
   if PFree.Name<>ConstsMenuSeparator then begin
    s:=GetPathFromMenu(PFree.MenuItem,'->');
    WriteParam(Section,'Меню'+s,PFree.ShortCut);
   end;
   for i:=PFree.List.Count-1 downto 0 do begin
    P:=PFree.List.Items[i];
    FreeMenu_(THandle(P));
   end;
   if PFree.SelfMenuItem<>nil then begin
    if not isExistsOtherInfoMenu(PFree) then begin
     if PFree.SelfMenuItem.ImageIndex<>-1 then begin
      ind:=PFree.SelfMenuItem.ImageIndex;
      SetNewImageIndex(ListMenus,ind,-1);
      fmMain.ilMM.Delete(ind);
     end;
     PFree.SelfMenuItem.Free;
    end;
   end;
   ListParent.Remove(PFree);
   PFree.List.Free;
   Dispose(PFree);
   Result:=True;
end;

function GetMenuHandleFromName_(ParentHandle: THandle; Name: PChar): THandle;stdcall;
var
  PParent,P: PInfoMenu;
  ListParent: TList;
  i: Integer;
begin
  Result:=MENU_INVALID_HANDLE;
  PParent:=Pointer(ParentHandle);
  ListParent:=GetParentListMenu(PParent,true);
  if ListParent=nil then exit;
  for i:=0 to ListParent.Count-1 do begin
    P:=ListParent.Items[i];
    if AnsiUpperCase(P.Name)=AnsiUpperCase(Name) then begin
      Result:=THandle(P);
      exit;
    end;
  end;
end;

function ViewMenu_(MenuHandle: THandle): Boolean;stdcall;
var
  P: PInfoMenu;
  ListMenu: TList;
begin
  Result:=false;
  P:=PInfoMenu(MenuHandle);
  if not isValidPointer(P,SizeOf(TInfoOption)) then exit;
  ListMenu:=GetListMenu(P);
  if ListMenu=nil then exit;
  P.MenuItem.Click;
end;

procedure PrepearMenus;
begin
  if fmMain=nil then exit;
  if isValidMenu_(hMenuEdit) then
   PInfoMenu(hMenuEdit).MenuItem.Visible:=PInfoMenu(hMenuEdit).MenuItem.Count>0;
  if isValidMenu_(hMenuRBooks) then
   PInfoMenu(hMenuRBooks).MenuItem.Visible:=PInfoMenu(hMenuRBooks).MenuItem.Count>0;
  if isValidMenu_(hMenuReports) then
   PInfoMenu(hMenuReports).MenuItem.Visible:=PInfoMenu(hMenuReports).MenuItem.Count>0;
  if isValidMenu_(hMenuDocums) then
   PInfoMenu(hMenuDocums).MenuItem.Visible:=PInfoMenu(hMenuDocums).MenuItem.Count>0;
  if isValidMenu_(hMenuOperations) then
   PInfoMenu(hMenuOperations).MenuItem.Visible:=PInfoMenu(hMenuOperations).MenuItem.Count>0;
end;

function isValidMenu_(MenuHandle: THandle): Boolean; stdcall;
var
  P: PInfoMenu;
  ListParent: TList;
begin
  Result:=false;
  if fmMain=nil then exit;
  P:=PInfoMenu(MenuHandle);
  ListParent:=GetListMenu(P);
  if ListParent=nil then exit;
  Result:=true;
end;

// -------------- Interfaces ---------------------

procedure ClearListInterfaces;
var
  i: Integer;
  P: PInfoInterface;
begin
  for i:=ListInterfaces.Count-1 downto 0 do begin
    P:=ListInterfaces.Items[i];
    FreeInterface_(THandle(P));
  end;
  ListInterfaces.Clear;
end;

(*function CreateAndViewConsts1(InterfaceHandle: Thandle; Param: PParamRBookInterface): Boolean;
var
  qr: TIBQuery;
  sqls: string;
  RecCount: Integer;
begin
  Result:=false;
  try
   if Param.Visual.TypeView<>tviOnlyData then exit;

   Screen.Cursor:=crHourGlass;
   qr:=TIBQuery.Create(nil);
   try
    qr.Database:=IBDB;
    qr.Transaction.Active:=false;
    qr.Transaction.Active:=true;
    sqls:='select c.*, p.name as defaultpropertyname, al.name as leaveabsencename, ar.name as refreshcourseabsencename,'+
          ' es.fname||'' ''||es.name||'' ''||es.sname as staffbossname,'+
          ' dc.name as defaultcurrencyname,'+
          ' ea.fname||'' ''||ea.name||'' ''||ea.sname as accountbossname,'+
          ' eb.fname||'' ''||eb.name||'' ''||eb.sname as bossname,'+
          ' pl.smallname as plantname, pdt.name as passportname,'+
          ' ct1.name as tariffcategorytypename, ct2.name as salarycategorytypename, ct3.name as pieceworkcategorytypename,'+
          ' country.name as countryname,region.name as regionname,'+
          ' state.name as statename,town.name as townname,'+
          ' pm.name as placementname,'+
          ' country.code as countrycode,region.code as regioncode,'+
          ' state.code as statecode,town.code as towncode,'+
          ' pm.code as placementcode, cp.startdate as calcperiodstartdate'+
          ' from '+tbConsts+' c'+
          ' join '+tbProperty+' p on c.defaultproperty_id=p.property_id'+
          ' join '+tbAbsence+' al on c.leaveabsence_id=al.absence_id'+
          ' join '+tbAbsence+' ar on c.refreshcourseabsence_id=ar.absence_id'+
          ' join '+tbEmp+' es on c.empstaffboss_id=es.emp_id'+
          ' join '+tbCurrency+' dc on c.defaultcurrency_id=dc.currency_id'+
          ' join '+tbEmp+' ea on c.empaccount_id=ea.emp_id'+
          ' join '+tbEmp+' eb on c.empboss_id=eb.emp_id'+
          ' join '+tbPlant+' pl on c.plant_id=pl.plant_id'+
          ' join '+tbPersonDocType+' pdt on c.emppassport_id=pdt.persondoctype_id'+
          ' join '+tbCategoryType+' ct1 on c.tariffcategorytype_id=ct1.categorytype_id'+
          ' join '+tbCategoryType+' ct2 on c.salarycategorytype_id=ct2.categorytype_id'+
          ' join '+tbCategoryType+' ct3 on c.pieceworkcategorytype_id=ct3.categorytype_id'+
          ' left join '+tbCountry+' country on c.country_id=country.country_id'+
          ' left join '+tbRegion+' region on c.region_id=region.region_id'+
          ' left join '+tbState+' state on c.state_id=state.state_id'+
          ' left join '+tbTown+' town on c.town_id=town.town_id'+
          ' left join '+tbPlaceMent+' pm on c.placement_id=pm.placement_id'+
          ' left join '+tbCalcPeriod+' cp on c.calcperiod_id=cp.calcperiod_id';
    qr.SQL.Clear;
    qr.SQL.Add(sqls);
    qr.Active:=true;
    RecCount:=GetRecordCount(qr);
    if RecCount<>1 then exit;
    FillParamRBookInterfaceFromDataSet(qr,Param);
    Result:=true;
   finally
    qr.Free;
    Screen.Cursor:=crDefault;
   end;
  except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;*)

function CreateAndViewConst(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBConst=nil then
       fmRBConst:=TfmRBConst.Create(Application);
     fmRBConst.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBConst;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBConst.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkConst,Param);
  end;
end;

function CreateAndViewQuery(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBQuery=nil then
       fmRBQuery:=TfmRBQuery.Create(Application);
     fmRBQuery.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBQuery;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBQuery.Create(nil);
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
    tviOnlyData: begin
      Result:=QueryForParamRBookInterface(IBDB,Param.SQL.Select,Param);
    end;
  end;
end;

function ViewInterfaceWithDefaultParam(InterfaceHandle: THandle): Boolean;
var
  Param: Pointer;
  TPRBI: TParamViewRBookInterface;
  TPRI: TParamViewReportInterface;
  TPWI: TParamViewWizardInterface;
  TPJI: TParamViewJournalInterface;
  TPSI: TParamViewServiceInterface;
  TPDI: TParamViewDocumentInterface;
  TPNI: TParamViewNoneInterface;
begin
  Result:=false;
  if not isValidInterface_(InterfaceHandle) then exit;
  Param:=nil;
  case PInfoInterface(InterfaceHandle).TypeInterface of
   ttiNone: begin
    FillChar(TPNI,SizeOf(TParamNoneInterface),0);
    Param:=@TPNI;
   end;
   ttiRBook: begin
    FillChar(TPRBI,SizeOf(TParamRBookInterface),0);
    Param:=@TPRBI;
   end;
   ttiReport: begin
    FillChar(TPRI,SizeOf(TParamReportInterface),0);
    Param:=@TPRI;
   end;
   ttiWizard: begin
    FillChar(TPWI,SizeOf(TParamWizardInterface),0);
    Param:=@TPWI;
   end;
   ttiJournal: begin
    FillChar(TPJI,SizeOf(TParamJournalInterface),0);
    Param:=@TPJI;
   end;
   ttiService: begin
    FillChar(TPSI,SizeOf(TParamServiceInterface),0);
    Param:=@TPSI;
   end;
   ttiDocument: begin
    FillChar(TPDI,SizeOf(TParamDocumentInterface),0);
    Param:=@TPDI;
   end;
  end;
  ViewInterface_(InterfaceHandle,Param);
end;

function RefreshInterfaceWithDefaultParam(InterfaceHandle: THandle): Boolean;
begin
  Result:=false;
  //RefresInterface_(InterfaceHandle,GetDefaultParam(InterfaceHandle));
end;

function CloseInterfaceWithDefaultParam(InterfaceHandle: THandle): Boolean;
begin
  Result:=CloseInterface_(InterfaceHandle);
end;

procedure RunInterfacesWhereAutoRunTrue;
var
  i: Integer;
  P: PInfoInterface;
begin
  for i:=0 to ListInterfaces.Count-1 do begin
    P:=ListInterfaces.Items[i];
    if P.AutoRun and not P.Visible then begin
      ViewInterfaceWithDefaultParam(THandle(P));
    end;
  end;
end;

procedure RunInterfacesByListRunInterfaces;
var
  i: Integer;
  Handle: THandle;
begin
  for i:=0 to ListRunInterfaces.Count-1 do begin
    Handle:=GetInterfaceHandleFromName_(PChar(ListRunInterfaces[i]));
    ViewInterfaceWithDefaultParam(Handle);
  end;
end;

procedure AddToListInterfaces;

  function CreateLocalInterface(Name,Hint: PChar; TypeInterface: TTypeInterface=ttiRBook): THandle;
  var
    TPCI: TCreateInterface;
  begin
    FillChar(TPCI,SizeOf(TCreateInterface),0);
    TPCI.Name:=Name;
    TPCI.Hint:=Hint;
    TPCI.ViewInterface:=ViewInterface;
    TPCI.TypeInterface:=TypeInterface;
    Result:=CreateInterface_(@TPCI);
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
     Result:=CreatePermissionForInterface_(InterfaceHandle,@TCPFI);
  end;

begin
  hInterfaceConst:=CreateLocalInterface(NameRbkConst,NameRbkConst);
  CreateLocalPermission(hInterfaceConst,tbConstEx);
  CreateLocalPermission(hInterfaceConst,tbConstEx,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceConst,tbConstEx,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceConst,tbConstEx,ttpDelete,false,ttiaDelete);

  hInterfaceQuery:=CreateLocalInterface(NameRbkQuery,NameRbkQuery);
end;

function ViewInterface(InterfaceHandle: THandle; Param: Pointer): Boolean; stdcall;
begin
  Result:=isPermissionOnInterface_(InterfaceHandle,ttiaView);
  if not Result then exit;
  if InterfaceHandle=hInterfaceConst then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewConst(InterfaceHandle,PParamRBookInterface(Param));
  end;
  if InterfaceHandle=hInterfaceQuery then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewQuery(InterfaceHandle,PParamRBookInterface(Param));
  end;
end;

function isPermissionOnInterfaceView(InterfaceHandle: THandle): Boolean;
var
  isRemove: Boolean;
begin
  isRemove:=false;
  if InterfaceHandle=hInterfaceConst then begin
    isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    if isRemove then FreeAndNil(fmRBConst)
    else if fmRBConst<>nil then begin
     fmRBConst.SetInterfaceHandle(InterfaceHandle);
     fmRBConst.ActiveQuery(true);
    end;
  end;
  result:=not isRemove;
end;

function GetInterfaceFromName(Name: PChar): PInfoInterface;
var
  i: Integer;
  P: PInfoInterface;
begin
  Result:=nil;
  for i:=0 to ListInterfaces.Count-1 do begin
    P:=ListInterfaces.Items[i];
    if AnsiUpperCase(P.Name)=AnsiUpperCase(Name) then begin
      Result:=P;
      exit;
    end;
  end;
end;

function CreateInterface_(PCI: PCreateInterface): THandle;stdcall;
var
  P: PInfoInterface;
begin
  Result:=INTERFACE_INVALID_HANDLE;
  if not isValidPointer(PCI,SizeOf(TCreateInterface)) then exit;
  P:=GetInterfaceFromName(PCI.Name);
  if P<>nil then begin
    if not PCI.ChangePrevious then begin
     CreateLogItem(Format(fmtInterfaceAlreadyExists,[P.Name]),tliError);
     exit;
    end else begin
      if not _FreeInterface(THandle(P)) then exit;
    end; 
  end;
  New(P);
  FillChar(P^,SizeOf(TInfoInterface),0);
  P.Name:=PCI.Name;
  P.Hint:=PCI.Hint;
  if isValidPointer(@PCI.ViewInterface) then
    P.ViewInterface:=PCI.ViewInterface;
  P.TypeInterface:=PCI.TypeInterface;
  if isValidPointer(@PCI.RefreshInterface) then
    P.RefreshInterface:=PCI.RefreshInterface;
  if isValidPointer(@PCI.CloseInterface) then
    P.CloseInterface:=PCI.CloseInterface;
  if isValidPointer(@PCI.ExecProcInterface) then
    P.ExecProcInterface:=PCI.ExecProcInterface;
  P.ViewActionPerm:=TStringList.Create;
  P.AddActionPerm:=TStringList.Create;
  P.ChangeActionPerm:=TStringList.Create;
  P.DeleteActionPerm:=TStringList.Create;
  P.AutoRun:=PCI.AutoRun;
  ListInterfaces.Add(P);
  Result:=THandle(P);
end;

function FreeInterface_(InterfaceHandle: THandle): Boolean;stdcall;
var
  P: PInfoInterface;
begin
  Result:=false;
  P:=PInfoInterface(InterfaceHandle);
  if ListInterfaces.IndexOf(P)=-1 then exit;
  ListInterfaces.Remove(P);
  P.ViewActionPerm.Free;
  P.AddActionPerm.Free;
  P.ChangeActionPerm.Free;
  P.DeleteActionPerm.Free;
  Dispose(P);
  Result:=true;
end;

function GetInterfaceHandleFromName_(Name: PChar): THandle;stdcall;
var
  P: PInfoInterface;
begin
  Result:=INTERFACE_INVALID_HANDLE;
  P:=GetInterfaceFromName(Name);
  if P=nil then exit;
  Result:=THandle(P);
end;

function ViewInterface_(InterfaceHandle: THandle; Param: Pointer): Boolean; stdcall;
var
  P: PInfoInterface;
begin
  Result:=false;
  P:=PInfoInterface(InterfaceHandle);
  if ListInterfaces.IndexOf(P)=-1 then begin
    CreateLogItem(Format(fmtInterfaceHandleNotfound,[InterfaceHandle]),tliError);
    exit;
  end;
  if not isValidPointer(@P.ViewInterface) then begin
    CreateLogItem(Format(fmtInterfaceViewProcIsBad,[P.Name]),tliError);
    exit;
  end;
  CreateLogItem(Format(fmtInterfaceViewProcBegin,[P.Name]),tliInformation);
  Result:=P.ViewInterface(THandle(P),Param);
  if Result then
    CreateLogItem(Format(fmtInterfaceViewProcSuccess,[P.Name]),tliInformation);
end;

function ViewInterfaceFromName_(Name: PChar; Param: Pointer): Boolean; stdcall;
var
  P: PInfoInterface;
begin
  Result:=false;
  P:=GetInterfaceFromName(Name);
  if P=nil then begin
    CreateLogItem(Format(fmtInterfaceNotfound,[Name]),tliError);
    exit;
  end;  
  Result:=ViewInterface_(THandle(P),Param);
end;

function RefreshInterface_(InterfaceHandle: THandle; Param: Pointer): Boolean; stdcall;
var
  P: PInfoInterface;
begin
  Result:=false;
  P:=PInfoInterface(InterfaceHandle);
  if ListInterfaces.IndexOf(P)=-1 then begin
    CreateLogItem(Format(fmtInterfaceHandleNotfound,[InterfaceHandle]),tliError);
    exit;
  end;
  if not isValidPointer(@P.RefreshInterface) then begin
    CreateLogItem(Format(fmtInterfaceRefreshProcIsBad,[P.Name]),tliError);
    exit;
  end; 
  Result:=P.RefreshInterface(THandle(P),Param);
end;

function CloseInterface_(InterfaceHandle: THandle): Boolean; stdcall;
var
  P: PInfoInterface;
begin
  Result:=false;
  P:=PInfoInterface(InterfaceHandle);
  if ListInterfaces.IndexOf(P)=-1 then begin
    CreateLogItem(Format(fmtInterfaceHandleNotfound,[InterfaceHandle]),tliError);
    exit;
  end;
  if not isValidPointer(@P.CloseInterface) then begin
    CreateLogItem(Format(fmtInterfaceCloseProcIsBad,[P.Name]),tliError);
    exit;
  end;
  Result:=P.CloseInterface(THandle(P));
  if Result then
    CreateLogItem(Format(fmtInterfaceCloseProcSuccess,[P.Name]),tliInformation);
end;

function ExecProcInterface_(InterfaceHandle: THandle; Param: Pointer): Boolean;stdcall;
var
  P: PInfoInterface;
begin
  Result:=false;
  P:=PInfoInterface(InterfaceHandle);
  if ListInterfaces.IndexOf(P)=-1 then begin
    CreateLogItem(Format(fmtInterfaceHandleNotfound,[InterfaceHandle]),tliError);
    exit;
  end;
  if not isValidPointer(@P.ExecProcInterface) then begin
    CreateLogItem(Format(fmtInterfaceExecProcProcIsBad,[P.Name]),tliError);
    exit;
  end; 
  CreateLogItem(Format(fmtInterfaceExecProcBegin,[P.Name]),tliInformation);
  Result:=P.ExecProcInterface(THandle(P),Param);
  if Result then
    CreateLogItem(Format(fmtInterfaceExecProcSuccess,[P.Name]),tliInformation);
end;

function OnVisibleInterface_(InterfaceHandle: THandle; Visible: Boolean): Boolean; stdcall;
var
  P: PInfoInterface;
begin
  Result:=false;
  P:=PInfoInterface(InterfaceHandle);
  if ListInterfaces.IndexOf(P)=-1 then exit;
  P.Visible:=Visible;
  if Visible then
   hInterfaceLast:=InterfaceHandle;
end;

function CreatePermissionForInterface_(InterfaceHandle: THandle; PCPFI: PCreatePermissionForInterface): Boolean;stdcall;
var
  P: PInfoInterface;
  val: Integer;
  str: TStringList;
  Value: Word;
  s1,s2: string;
begin
  Result:=false;
  if not isValidPointer(PCPFI,SizeOf(TCreatePermissionForInterface)) then exit;
  P:=PInfoInterface(InterfaceHandle);
  if ListInterfaces.IndexOf(P)=-1 then exit;
  str:=nil;
  case PCPFI.Action of
    ttiaView: str:=P.ViewActionPerm;
    ttiaAdd: str:=P.AddActionPerm;
    ttiaChange: str:=P.ChangeActionPerm;
    ttiaDelete: str:=P.DeleteActionPerm;
  end;
  if str=nil then exit;
  val:=str.IndexOf(PCPFI.DBObject);
  if val<>-1 then begin
    Value:=Word(str.Objects[val]);
    if (TTypeDBPermission(LO(Value))=PCPFI.DBPermission)and
       (Boolean(HI(Value))=PCPFI.DBSystem) then exit;
  end;
  s1:=inttohex(Byte(PCPFI.DBSystem),2);
  s2:=inttohex(Byte(PCPFI.DBPermission),2);
  Value:=Word(strtoint('$'+s1+s2));
  Result:=str.AddObject(PCPFI.DBObject,TObject(Pointer(Value)))>0;
end;

function isPermissionOnInterface_(InterfaceHandle: THandle; Action: TTypeInterfaceAction): Boolean; stdcall;
var
  P: PInfoInterface;
  i: Integer;
  str: TStringList;
  DBSystem: Boolean;
  DBPerm: TTypeDBPermission;
  S, S1: String;
begin
  Result:=false;
  P:=PInfoInterface(InterfaceHandle);
  if ListInterfaces.IndexOf(P)=-1 then exit;
  str:=nil;
  case Action of
    ttiaView: str:=P.ViewActionPerm;
    ttiaAdd: str:=P.AddActionPerm;
    ttiaChange: str:=P.ChangeActionPerm;
    ttiaDelete: str:=P.DeleteActionPerm;
  end;
  if str=nil then exit;
  for i:=0 to str.Count-1 do begin
    DBSystem:=Boolean(HI(Word(Pointer(str.Objects[i]))));
    DBPerm:=TTypeDBPermission(LO(Word(Pointer(str.Objects[i]))));
    S:=TranslateInterfaceAction(Action);
    S1:=TranslatePermission(DBPerm);
    if i=0 then SetSplashStatus_(PChar(Format(fmtCheckPerm,[P.Name,S])));
    if DBSystem then begin
      if not isPermissionSecurity_(PChar(str.strings[i]),PChar(S1)) then begin
        CreateLogItem(Format(fmtCheckPermInterfaceFailed,[P.Name,S,str.strings[i],S1]),tliWarning);
        exit;
      end else begin
        CreateLogItem(Format(fmtCheckPermInterfaceSuccess,[P.Name,S,str.strings[i],S1]));
      end; 
    end else begin
      if not isPermission_(PChar(str.strings[i]),PChar(S1)) then begin
        CreateLogItem(Format(fmtCheckPermInterfaceFailed,[P.Name,S,str.strings[i],S1]),tliWarning);
        exit;
      end else begin
        CreateLogItem(Format(fmtCheckPermInterfaceSuccess,[P.Name,S,str.strings[i],S1]));
      end;  
    end;
  end;
  Result:=true;
end;

function isValidInterface_(InterfaceHandle: THandle): Boolean; stdcall;
var
  P: PInfoInterface;
begin
  Result:=false;
  P:=PInfoInterface(InterfaceHandle);
  if ListInterfaces.IndexOf(P)=-1 then exit;
  Result:=true;
end;

procedure GetInterfaces_(Owner: Pointer; Proc: TGetInterfaceProc); stdcall;
var
  TGI: TGetInterface;
  P: PInfoInterface;
  i: Integer;
begin
  if not isValidPointer(@Proc) then exit;
  for i:=0 to ListInterfaces.Count-1 do begin
    P:=ListInterfaces.Items[i];
    FillChar(TGI,SizeOf(TGI),0);
    TGI.Name:=PChar(P.Name);
    TGI.Hint:=PChar(P.Hint);
    TGI.TypeInterface:=P.TypeInterface;
    TGI.hInterface:=THandle(P);
    Proc(Owner,@TGI);
  end;
end;

procedure GetInterfacePermissions_(Owner: Pointer; InterfaceHandle: THandle; Proc: TGetInterfacePermissionProc); stdcall;
var
  PInterface: PInfoInterface;
  TGIP: TGetInterfacePermission;
  str: TStringList;
  j,i: Integer;
  Action: TTypeInterfaceAction;
  DBPerm: TTypeDBPermission;
begin
  if not isValidInterface_(InterfaceHandle) then exit;
  if not isValidPointer(@Proc) then exit;
  PInterface:=PInfoInterface(InterfaceHandle);
  for j:=Integer(ttiaView) to Integer(ttiaDelete) do begin
    Action:=TTypeInterfaceAction(j);
    str:=nil;
    case Action of
      ttiaView: str:=PInterface.ViewActionPerm;
      ttiaAdd: str:=PInterface.AddActionPerm;
      ttiaChange: str:=PInterface.ChangeActionPerm;
      ttiaDelete: str:=PInterface.DeleteActionPerm;
    end;
    for i:=0 to str.Count-1 do begin
      DBPerm:=TTypeDBPermission(LO(Word(Pointer(str.Objects[i]))));
      FillChar(TGIP,SizeOf(TGIP),0);
      TGIP.Action:=Action;
      TGIP.DbObject:=PChar(str.Strings[i]);
      TGIP.DbPerm:=DbPerm;
      Proc(Owner,@TGIP);
    end;
  end;  
end;

var
  TGI: TGetInterface;

function GetInterface_(InterfaceHandle: THandle): PGetInterface; stdcall;
var
  val: Integer;
  P: PInfoInterface;
begin
  Result:=nil;
  P:=PInfoInterface(InterfaceHandle);
  val:=ListInterfaces.IndexOf(P);
  if val<>-1 then begin
    FillChar(TGI,SizeOf(TGI),0);
    TGI.hInterface:=InterfaceHandle;
    TGI.Name:=PChar(P.Name);
    TGI.Hint:=PChar(P.Hint);
    TGI.TypeInterface:=P.TypeInterface;
    Result:=@TGI;
  end;
end;


// -------------- Logs ---------------------

procedure CreateLogItem(Text: String; TypeLogItem: TTypeLogItem);
var
  TCLI: TCreateLogItem;
  i: Integer;
  TL: TTypeLogItem;
begin
  if fmLog=nil then begin
    ListTempLogItems.AddObject(Text,TObject(TypeLogItem));
  end else begin
    for i:=0 to ListTempLogItems.Count-1 do begin
      TL:=TTypeLogItem(ListTempLogItems.Objects[i]);
      FillChar(TCLI,SizeOf(TCLI),0);
      TCLI.Text:=PChar(ListTempLogItems[i]);
      TCLI.TypeLogItem:=TL;
      CreateLogItem_(@TCLI);
    end;
    ListTempLogItems.Clear;

    FillChar(TCLI,SizeOf(TCLI),0);
    TCLI.Text:=PChar(Text);
    TCLI.TypeLogItem:=TypeLogItem;
    CreateLogItem_(@TCLI);
  end;  
end;

function ClearLog_: Boolean;stdcall;
begin
  Result:=ClearAdditionalLog_(hAdditionalLogMain);
end;

procedure ViewLog_(Visible: Boolean);stdcall;
begin
  ViewAdditionalLog_(hAdditionalLogMain,Visible);
end;

function CreateLogItem_(PCLI: PCreateLogItem): THandle;stdcall;
var
  TCALI: TCreateAdditionalLogItem;
  S: string;
  clCur: TColor;
begin
  Result:=LOGITEM_INVALID_HANDLE;
  if fmLog=nil then exit;
  if not isValidPointer(PCLI,SizeOf(TCreateLogItem)) then exit;
  if not (Integer(PCLI.TypeLogItem) in [0..3]) then exit;
  if not isLogChecked[Integer(PCLI.TypeLogItem)] then exit;
  FillChar(TCALI,SizeOf(TCreateAdditionalLogItem),0);
  s:='';
  clCur:=clBlue;
  case PCLI.TypeLogItem of
    tliWarning: begin
      s:=ConstWarning;
      clCur:=clOlive;
    end;
    tliError: begin
      s:=ConstError;
      clCur:=clRed;
    end;
    tliInformation: begin
      s:=ConstInformation;
      clCur:=clBlue;
    end;
    tliConfirmation: begin
      s:=ConstQuestion;
      clCur:=clGreen;
    end;
  end;
  TCALI.MaxRow:=4;
  TCALI.TypeAdditionalLogItem:=TTypeAdditionalLogItem(PCLI.TypeLogItem);
  if isValidPointer(@PCLI.ViewLogItemProc) then
    TCALI.ViewAdditionalLogItemProc:=PCLI.ViewLogItemProc;
  TCALI.Owner:=PCLI.Owner;
  SetLength(TCALI.ArrPCALIC,3);
  New(TCALI.ArrPCALIC[0]);
  New(TCALI.ArrPCALIC[1]);
  New(TCALI.ArrPCALIC[2]);
  try
    FillChar(TCALI.ArrPCALIC[0]^,SizeOf(TCreateAdditionalLogItemCaption),0);
    TCALI.ArrPCALIC[0].Font:=TFont.Create;
    TCALI.ArrPCALIC[0].Font.Color:=clCur;
    TCALI.ArrPCALIC[0].Caption:=PChar(s);
    TCALI.ArrPCALIC[0].Visible:=true;
    TCALI.ArrPCALIC[0].Width:=ConstLogItemCaptionWidth;

    FillChar(TCALI.ArrPCALIC[1]^,SizeOf(TCreateAdditionalLogItemCaption),0);
    TCALI.ArrPCALIC[1].Font:=TFont.Create;
    TCALI.ArrPCALIC[1].Font.Color:=clBtnShadow;
    TCALI.ArrPCALIC[1].Caption:=PChar(FormatDateTime(fmtDateTimeLog,Now));
    TCALI.ArrPCALIC[1].AutoWidth:=true;
    TCALI.ArrPCALIC[1].Visible:=isLogShowDateTime;

    FillChar(TCALI.ArrPCALIC[2]^,SizeOf(TCreateAdditionalLogItemCaption),0);
    TCALI.ArrPCALIC[2].Visible:=true;
    TCALI.ArrPCALIC[2].Caption:=PCLI.Text;

    Result:=CreateAdditionalLogItem_(hAdditionalLogMain,@TCALI);

    if Result<>LOGITEM_INVALID_HANDLE then begin
      MainLog.Write(PCLI.Text,PCLI.TypeLogItem);
    end;

  finally
    TCALI.ArrPCALIC[0].Font.Free;
    Dispose(TCALI.ArrPCALIC[0]);
    TCALI.ArrPCALIC[1].Font.Free;
    Dispose(TCALI.ArrPCALIC[1]);
    Dispose(TCALI.ArrPCALIC[2]);
  end;
end;

function FreeLogItem_(LogItemHandle: THandle): Boolean;stdcall;
begin
  Result:=FreeAdditionalLogItem_(LogItemHandle);
end;

function isValidLogItem_(LogItemHandle: THandle): Boolean; stdcall;
begin
  Result:=isValidAdditionalLogItem_(LogItemHandle);
end;

// ----------- AdditionalLog --------------------------

procedure ViewAdditionalLogItemProc(AdditionalLogItemHandle: THandle);stdcall;
begin
end;

procedure ViewAdditionalLogOptionProc(AdditionalLogHandle: THandle);stdcall;
begin
  if AdditionalLogHandle=hAdditionalLogMain then ViewOption_(hOptionLog);
  if AdditionalLogHandle=hAdditionalLogSqlMonitor then ViewOption_(hOptionSqlMonitor);
end;

procedure ClearListAdditionalLogs;
var
  i: Integer;
  P: PInfoAdditionalLog;
begin
  if fmLog=nil then exit;
  fmLog.Logs.Items.BeginUpdate;
  try
   for i:=ListAdditionalLogs.Count-1 downto 0 do begin
    P:=ListAdditionalLogs.Items[i];
    FreeAdditionalLog_(THandle(P));
   end;
   ListAdditionalLogs.CLear;
  finally
   fmLog.Logs.Items.EndUpdate;
  end;
end;

function CreateAdditionalLog_(PCAL: PCreateAdditionalLog): THandle;stdcall;
var
  P: PInfoAdditionalLog;
  logsitem: TtsvLogsItem;
begin
  Result:=ADDITIONALLOG_INVALID_HANDLE;
  if fmLog=nil then exit;
  if not isValidPointer(PCAL,SizeOf(TCreateAdditionalLog)) then exit;
  New(P);
  FillChar(P^,SizeOf(TInfoAdditionalLog),0);
  P.ListChild:=TList.Create;
  P.Limit:=PCAL.Limit;
  logsitem:=fmLog.Logs.Items.Add;
  logsitem.MultiSelect:=true;
  logsitem.Caption:=PCAL.Name;
  logsitem.Hint:=PCAL.Hint;
  logsitem.Data:=P;
  P.LogIndex:=logsitem.Index;
  if isValidPointer(@PCAL.ViewAdditionalLogOptionProc) then
    P.ViewAdditionalLogOptionProc:=PCAL.ViewAdditionalLogOptionProc;
  ListAdditionalLogs.Add(P);
  Result:=THandle(P);
end;

function FreeAdditionalLog_(AdditionalLogHandle: THandle): Boolean; stdcall;
var
  P: PInfoAdditionalLog;
  PItem: PInfoAdditionalLogItem;
  i: Integer;
begin
  Result:=false;
  if fmLog=nil then exit;
  if not isValidAdditionalLog_(AdditionalLogHandle) then exit;
  P:=PInfoAdditionalLog(AdditionalLogHandle);
  fmLog.Logs.Items.Items[P.LogIndex].Items.BeginUpdate;
  try
   for i:=P.ListChild.Count-1 downto 0 do begin
    PItem:=P.ListChild.Items[i];
    FreeAdditionalLogItem_(THandle(PItem));
   end;
  finally
   fmLog.Logs.Items.Items[P.LogIndex].Items.EndUpdate;
  end;
  fmLog.Logs.Items.Delete(P.LogIndex);
  P.ListChild.Free;
  ListAdditionalLogs.Remove(P);
  Dispose(P);
  Result:=true;
end;

function SetParamsToAdditionalLog_(AdditionalLogHandle: THandle; PSPAL: PSetParamsToAdditionalLog): Boolean;stdcall;
var
  P: PInfoAdditionalLog;
begin
  Result:=false;
  if fmLog=nil then exit;
  if not isValidAdditionalLog_(AdditionalLogHandle) then exit;
  if not isValidPointer(PSPAL,SizeOf(TSetParamsToAdditionalLog)) then exit;
  P:=PInfoAdditionalLog(AdditionalLogHandle);
  P.Limit:=PSPAL.Limit;
  if P.Limit>0 then begin
    if P.Limit<P.ListChild.Count then
     while P.Limit<P.ListChild.Count do begin
       _FreeAdditionalLogItem(THandle(P.ListChild.Items[0]));
     end;
  end;
  Result:=true;
end;
function isValidAdditionalLog_(AdditionalLogHandle: THandle): Boolean; stdcall;
var
  val: Integer;
  P: PInfoAdditionalLog;
begin
  P:=PInfoAdditionalLog(AdditionalLogHandle);
  val:=ListAdditionalLogs.IndexOf(P);
  Result:=val<>-1;
end;

function GetInfoAdditionalLog(PItem: PInfoAdditionalLogItem): PInfoAdditionalLog;
var
  i: Integer;
  P: PInfoAdditionalLog;
  val: Integer;
begin
  Result:=nil;
  for i:=0 to ListAdditionalLogs.Count-1 do begin
    P:=ListAdditionalLogs.Items[i];
    val:=P.ListChild.IndexOf(PItem);
    if Val<>-1 then begin
      Result:=P;
      exit;
    end;
  end;
end;

procedure SetNewLogItemIndexToOther(List: TList);
var
  i: Integer;
  P: PInfoAdditionalLogItem;
begin
  for i:=0 to List.Count-1 do begin
    P:=List.Items[i];
    P.LogItemIndex:=List.Count-1-i;
  end;
end;

function CreateAdditionalLogItem_(AdditionalLogHandle: THandle; PCALI: PCreateAdditionalLogItem): THandle; stdcall;
var
  P: PInfoAdditionalLogItem;
  PParent: PInfoAdditionalLog;
  logitem: TtsvLogItem;
  lic: TtsvLogItemCaption;
  bmp,AndMask: TBitmap;
  i: Integer;
begin
  Result:=ADDITIONALLOGITEM_INVALID_HANDLE;
  if fmLog=nil then exit;
  if fmMainOptions=nil then exit;
  if not isValidPointer(PCALI,SizeOf(TCreateAdditionalLogItem)) then exit;
  if not isValidAdditionalLog_(AdditionalLogHandle) then exit;
  PParent:=PInfoAdditionalLog(AdditionalLogHandle);
  if PParent=nil then exit;
  New(P);
  FillChar(P^,SizeOf(TInfoAdditionalLogItem),0);
  P.TypeAdditionalLogItem:=PCALI.TypeAdditionalLogItem;
  if isValidPointer(@PCALI.ViewAdditionalLogItemProc) then
   P.ViewAdditionalLogItemProc:=PCALI.ViewAdditionalLogItemProc;
  logitem:=fmLog.Logs.Items.Items[PParent.LogIndex].Items.Insert(0);
  P.LogItemIndex:=logitem.Index;
  SetNewLogItemIndexToOther(PParent.ListChild);
  if isValidPointer(PCALI.Brush) then logitem.Brush.Assign(PCALI.Brush);
  if isValidPointer(PCALI.Font) then logitem.Font.Assign(PCALI.Font);
  if isValidPointer(PCALI.Pen) then logitem.Pen.Assign(PCALI.Pen);
  logitem.Alignment:=PCALI.Alignment;
  logitem.Caption:=PCALI.Caption;
  logitem.MaxRow:=PCALI.MaxRow;
  if logitem.MaxRow=0 then logitem.MaxRow:=1;
  logitem.Data:=P;
  P.ImageIndex:=-1;
  P.Owner:=PCALI.Owner;
  case P.TypeAdditionalLogItem of
   taliBitmap: begin
    if isValidPointer(PCALI.Bitmap) then begin
      if not PCALI.Bitmap.Empty then begin
        bmp:=TBitmap.Create;
        AndMask:=TBitmap.Create;
        try
          bmp.Assign(PCALI.Bitmap);
          CopyBitmap(bmp,AndMask);
          AndMask.Mask(AndMask.Canvas.Pixels[0,0]);
          P.ImageIndex:=fmMainOptions.ilLog.Add(bmp,AndMask);
        finally
          AndMask.Free;
          bmp.Free;
        end;
      end;
    end;
   end;
   else begin
    if Integer(P.TypeAdditionalLogItem) in [0..4] then begin
     P.ImageIndex:=Integer(P.TypeAdditionalLogItem);
    end;
   end;
  end;
  logitem.ImageIndex:=P.ImageIndex;
  if isValidPointer(PCALI.ArrPCALIC) then begin
   for i:=Low(PCALI.ArrPCALIC) to High(PCALI.ArrPCALIC) do begin
     if isValidPointer(PCALI.ArrPCALIC[i]) then begin
       lic:=logitem.Captions.Add;
       lic.Caption:=PCALI.ArrPCALIC[i].Caption;
       if isValidPointer(PCALI.ArrPCALIC[i].Brush) then lic.Brush.Assign(PCALI.ArrPCALIC[i].Brush);
       if isValidPointer(PCALI.ArrPCALIC[i].Font) then lic.Font.Assign(PCALI.ArrPCALIC[i].Font);
       if isValidPointer(PCALI.ArrPCALIC[i].Pen) then lic.Pen.Assign(PCALI.ArrPCALIC[i].Pen);
       lic.Alignment:=PCALI.ArrPCALIC[i].Alignment;
       lic.AutoWidth:=PCALI.ArrPCALIC[i].AutoWidth;
       lic.Visible:=PCALI.ArrPCALIC[i].Visible;
       lic.Width:=PCALI.ArrPCALIC[i].Width;
     end;
   end;
  end;
  PParent.ListChild.Add(P);
  if PParent.Limit>0 then
   if PParent.ListChild.Count>PParent.Limit then
      FreeAdditionalLogItem_(THandle(PParent.ListChild.Items[0]));
  Result:=THandle(P);
  Application.ProcessMessages;
end;

function FreeAdditionalLogItem_(AdditionalLogItemHandle: THandle): Boolean; stdcall;

  procedure SetNewImageIndex(List: TList; FromPos,DecInc,LogIndex: Integer);
  var
    P: PInfoAdditionalLogItem;
    i: Integer;
    logitem: TTsvLogItem;
  begin
    for i:=0 to List.Count-1 do begin
      P:=List.Items[i];
      logitem:=fmLog.Logs.Items.Items[LogIndex].Items.Items[P.LogItemIndex];
      if P.ImageIndex>FromPos then begin
        P.ImageIndex:=P.ImageIndex+DecInc;
        logitem.ImageIndex:=P.ImageIndex;
      end;
    end;
  end;

var
  P: PInfoAdditionalLogItem;
  PParent: PInfoAdditionalLog;
begin
  Result:=false;
  if fmLog=nil then exit;
  if fmMainOptions=nil then exit;
  if not isValidAdditionalLogItem_(AdditionalLogItemHandle) then exit;
  P:=PInfoAdditionalLogItem(AdditionalLogItemHandle);
  PParent:=GetInfoAdditionalLog(P);
  if PParent=nil then exit;
  SetNewLogItemIndexToOther(PParent.ListChild);
  fmLog.Logs.Items.Items[PParent.LogIndex].Items.Delete(P.LogItemIndex);
  case P.TypeAdditionalLogItem of
    taliBitmap: begin
      if P.ImageIndex<>-1 then begin
        fmMainOptions.ilLog.Delete(P.ImageIndex);
        SetNewImageIndex(PParent.ListChild,P.ImageIndex,-1,PParent.LogIndex);
      end;
    end;
  end;
  PParent.ListChild.Remove(P);
  Dispose(P);
  Result:=true;
end;

function isValidAdditionalLogItem_(AdditionalLogItemHandle: THandle): Boolean; stdcall;
var
  PParent: PInfoAdditionalLog;
  P: PInfoAdditionalLogItem;
begin
  Result:=false;
  P:=PInfoAdditionalLogItem(AdditionalLogItemHandle);
  PParent:=GetInfoAdditionalLog(P);
  if PParent=nil then exit;
  Result:=true;
end;

function ClearAdditionalLog_(AdditionalLogHandle: THandle): Boolean; stdcall;
var
  P: PInfoAdditionalLog;
  i: Integer;
  PItem: PInfoAdditionalLogItem;
begin
  Result:=false;
  if fmLog=nil then exit;
  if not isValidAdditionalLog_(AdditionalLogHandle) then exit;
  P:=PInfoAdditionalLog(AdditionalLogHandle);
  fmLog.Logs.Items.Items[P.LogIndex].Items.BeginUpdate;
  try
   for i:=P.ListChild.Count-1 downto 0 do begin
    PItem:=P.ListChild.Items[i];
    FreeAdditionalLogItem_(THandle(PItem));
   end;
   Result:=true;
  finally
   fmLog.Logs.Items.Items[P.LogIndex].Items.EndUpdate;
  end;
end;

procedure ViewAdditionalLog_(AdditionalLogHandle: THandle; Visible: Boolean); stdcall;
var
  P: PInfoAdditionalLog;
begin
  if fmLog=nil then exit;
  if not isValidAdditionalLog_(AdditionalLogHandle) then begin
   exit;
  end;
  P:=PInfoAdditionalLog(AdditionalLogHandle);
  fmLog.Logs.ItemIndex:=P.LogIndex;
  try
    if Visible then begin
      if fmLog.HostDockSite<>nil then begin
        VisibleLog:=true;
        fmMain.ShowDockPanel(TPanel(fmLog.HostDockSite), true, fmLog);
      end else begin
        VisibleLog:=false;
        fmLog.Show;
      end;
    end else begin
      if fmLog.HostDockSite<>nil then begin
        VisibleLog:=false;
        fmMain.ShowDockPanel(TPanel(fmLog.HostDockSite), false, fmLog);
      end else begin
        VisibleLog:=false;
        fmLog.Hide;
      end;  
    end;
  finally
  end;  

end;

function GetAdditionalLogHandleByLogIndex(LogIndex: Integer): THandle;
var
  i: Integer;
  P: PInfoAdditionalLog;
begin
  Result:=ADDITIONALLOG_INVALID_HANDLE;
  for i:=0 to ListAdditionalLogs.Count-1 do begin
    P:=ListAdditionalLogs.Items[i];
    if P.LogIndex=LogIndex then begin
      Result:=THandle(P);
      exit;
    end;
  end;
end;

// ----------- DesignPallete --------------------------

procedure ClearListDesignPalettes;
var
  i: Integer;
  P: PInfoDesignPalette;
begin
  for i:=ListDesignPalettes.Count-1 downto 0 do begin
    P:=ListDesignPalettes.Items[i];
    FreeDesignPalette_(THandle(P));
  end;
  ListDesignPalettes.Clear;
end;

function isValidDesignPalette_(DesignPaletteHandle: THandle): Boolean; stdcall;
begin
  Result:=ListDesignPalettes.IndexOf(PInfoDesignPalette(DesignPaletteHandle))<>-1;
end;

function GetListButtons(P: PInfoDesignPaletteButton): TList;
var
  i: Integer;
  PPalette: PInfoDesignPalette;
begin
  Result:=nil;
  for i:=0 to ListDesignPalettes.Count-1 do begin
    PPalette:=ListDesignPalettes.Items[i];
    if PPalette.ListButtons.IndexOf(P)<>-1 then begin
      Result:=PPalette.ListButtons; 
      exit;
    end;
  end;
end;

function isValidDesignPaletteButton_(DesignPaletteButtonHandle: THandle): Boolean; stdcall;
begin
  Result:=GetListButtons(PInfoDesignPaletteButton(DesignPaletteButtonHandle))<>nil;
end;

function CreateDesignPalette_(PCDP: PCreateDesignPalette): THandle; stdcall;
var
  P: PInfoDesignPalette;
begin
  Result:=DESIGNPALETTE_INVALID_HANDLE;
  if not IsValidPointer(PCDP,SizeOf(TCreateDesignPalette)) then exit;
  if PCDP.Name=nil then exit;
  New(P);
  FillChar(P^,SizeOf(TInfoDesignPalette),0);
  P.Name:=PCDP.Name;
  P.Hint:=PCDP.Hint;
  P.ListButtons:=TList.Create;
  ListDesignPalettes.Add(P);
  Result:=THandle(P);
end;

function CreateDesignPaletteButton_(DesignPaletteHandle: THandle; PCDPB: PCreateDesignPaletteButton): THandle; stdcall;
var
  PPalette: PInfoDesignPalette;
  P: PInfoDesignPaletteButton;
begin
  Result:=DESIGNPALETTEBUTTON_INVALID_HANDLE;
  if not isValidDesignPalette_(DesignPaletteHandle) then exit;
  PPalette:=PInfoDesignPalette(DesignPaletteHandle);
  if not isValidPointer(PCDPB,SizeOf(TCreateDesignPaletteButton)) then exit;
  if not isValidPointer(PCDPB.Cls) then exit;
  New(P);
  FillChar(P^,SizeOf(TInfoDesignPaletteButton),0);
  P.Hint:=PCDPB.Hint;
  P.Cls:=PCDPB.Cls;
  P.UseForInterfaces:=PCDPB.UseForInterfaces;
  RegisterClass(P.Cls);
  if isValidPointer(PCDPB.Bitmap) then begin
   P.Bitmap:=TBitmap.Create;
   P.Bitmap.Assign(PCDPB.Bitmap);
  end; 
  PPalette.ListButtons.Add(P);
end;

function FreeDesignPalette_(DesignPaletteHandle: THandle): Boolean; stdcall;
var
  i: Integer;
  P: PInfoDesignPalette;
begin
  Result:=false;
  if not isValidDesignPalette_(DesignPaletteHandle) then exit;
  P:=PInfoDesignPalette(DesignPaletteHandle);
  for i:=P.ListButtons.Count-1 downto 0 do begin
    FreeDesignPaletteButton_(THandle(P.ListButtons.Items[i]));
  end;
  P.ListButtons.Free;
  ListDesignPalettes.Remove(P);
  Dispose(P);
  Result:=true;
end;

function FreeDesignPaletteButton_(DesignPaletteButtonHandle: THandle): Boolean; stdcall;
var
  P: PInfoDesignPaletteButton;
  ListButtons: TList;
begin
  Result:=false;
  P:=PInfoDesignPaletteButton(DesignPaletteButtonHandle);
  ListButtons:=GetListButtons(P);
  if ListButtons=nil then exit;
  UnRegisterClass(P.Cls);
  if P.Bitmap<>nil then P.Bitmap.Free; 
  ListButtons.Remove(P);
  DisPose(P);
  Result:=true;
end;

procedure GetDesignPalettes_(Owner: Pointer; Proc: TGetDesignPaletteProc); stdcall;
var
  i,j: Integer;
  P: PInfoDesignPalette;
  TGDP: TGetDesignPalette;
  PGB: PGetDesignPaletteButton;
  PIB: PInfoDesignPaletteButton;
begin
  if not IsValidPointer(@Proc) then exit;
  for i:=0 to ListDesignPalettes.Count-1 do begin
    P:=ListDesignPalettes.Items[i];
    FillChar(TGDP,SizeOf(TGetDesignPalette),0);
    TGDP.Name:=PChar(P.Name);
    TGDP.Hint:=PChar(P.Hint);
    SetLength(TGDP.Buttons,P.ListButtons.Count);
    for j:=0 to P.ListButtons.Count-1 do begin
      PIB:=P.ListButtons.Items[j];
      New(PGB);
      FillChar(PGB^,SizeOf(TGetDesignPaletteButton),0);
      PGB.Hint:=PChar(PIB.Hint);
      PGB.Cls:=PIB.Cls;
      PGB.UseForInterfaces:=PIB.UseForInterfaces;
      if PIB.Bitmap<>nil then begin
       PGB.Bitmap:=TBitmap.Create;
       PGB.Bitmap.Assign(PIB.Bitmap);
      end; 
      TGDP.Buttons[j]:=PGB;
    end;
    try
     Proc(Owner,@TGDP);
    finally
     for j:=Low(TGDP.Buttons) to High(TGDP.Buttons) do begin
       TGDP.Buttons[j].Bitmap.Free;
       Dispose(TGDP.Buttons[j]);
     end;  
    end;
  end;
end;

// ----------- DesignPropertyTranslate --------------------------

procedure ClearListDesignPropertyTranslates;
var
  i: Integer;
  P: PInfoDesignPropertyTranslate;
begin
  for i:=ListDesignPropertyTranslates.Count-1 downto 0 do begin
    P:=ListDesignPropertyTranslates.Items[i];
    FreeDesignPropertyTranslate_(THandle(P));
  end;
  ListDesignPropertyTranslates.Clear;
end;

function isValidDesignPropertyTranslate_(DesignPropertyTranslateHandle: THandle): Boolean; stdcall;
begin
  Result:=ListDesignPropertyTranslates.IndexOf(Pointer(DesignPropertyTranslateHandle))<>-1;
end;

function CreateDesignPropertyTranslate_(PCDPT: PCreateDesignPropertyTranslate): THandle; stdcall;
var
  P: PInfoDesignPropertyTranslate;
begin
  Result:=DESIGNPROPERTYTRANSLATE_INVALID_HANDLE;
  if not IsValidPointer(PCDPT,SizeOf(TCreateDesignPropertyTranslate)) then exit;
  New(P);
  FillChar(P^,SizeOf(TCreateDesignPropertyTranslate),0);
  P.Real:=PCDPT.Real;
  P.Translate:=PCDPT.Translate;
  P.Cls:=PCDPT.Cls;
  ListDesignPropertyTranslates.Add(P);
  Result:=THandle(P);
end;

function FreeDesignPropertyTranslate_(DesignPropertyTranslateHandle: THandle): Boolean; stdcall;
var
  P: PInfoDesignPropertyTranslate;
begin
  Result:=false;
  if not isValidDesignPropertyTranslate_(DesignPropertyTranslateHandle) then exit;
  P:=PInfoDesignPropertyTranslate(DesignPropertyTranslateHandle);
  ListDesignPropertyTranslates.Remove(P);
  Dispose(P);
  Result:=true;
end;

procedure GetDesignPropertyTranslates_(Owner: Pointer; Proc: TGetDesignPropertyTranslateProc); stdcall;
var
  i: Integer;
  P: PInfoDesignPropertyTranslate;
  TGDPT: TGetDesignPropertyTranslate;
begin
  if not IsValidPointer(@Proc) then exit;
  for i:=0 to ListDesignPropertyTranslates.Count-1 do begin
    P:=ListDesignPropertyTranslates.Items[i];
    FillChar(TGDPT,SizeOf(TGetDesignPropertyTranslate),0);
    TGDPT.Real:=PChar(P.Real);
    TGDPT.Translate:=PChar(P.Translate);
    TGDPT.Cls:=P.Cls;
    Proc(Owner,@TGDPT);
  end;
end;

// ----------- DesignPropertyRemove --------------------------

procedure AddToListDesignPropertyRemoves;

   function CreateDesignPropertyRemoveLocal(Name: PChar; Cls: TPersistentClass=nil): THandle;
   var
     TCDPR: TCreateDesignPropertyRemove;
   begin
     FillChar(TCDPR,SizeOf(TCreateDesignPropertyRemove),0);
     TCDPR.Name:=Name;
     TCDPR.Cls:=Cls;
     Result:=_CreateDesignPropertyRemove(@TCDPR);
   end;

begin
  // Properties

  CreateDesignPropertyRemoveLocal('Name',TIBDatabase);
  CreateDesignPropertyRemoveLocal('Tag',TIBDatabase);
  CreateDesignPropertyRemoveLocal('Connected',TIBDatabase);
  CreateDesignPropertyRemoveLocal('DatabaseName',TIBDatabase);
  CreateDesignPropertyRemoveLocal('Params',TIBDatabase);
  CreateDesignPropertyRemoveLocal('LoginPrompt',TIBDatabase);
  CreateDesignPropertyRemoveLocal('DefaultTransaction',TIBDatabase);
  CreateDesignPropertyRemoveLocal('IdleTimer',TIBDatabase);
  CreateDesignPropertyRemoveLocal('SQLDialect',TIBDatabase);
  CreateDesignPropertyRemoveLocal('DBSQLDialect',TIBDatabase);
  CreateDesignPropertyRemoveLocal('TraceFlags',TIBDatabase);
  CreateDesignPropertyRemoveLocal('AllowStreamedConnected',TIBDatabase);

  CreateDesignPropertyRemoveLocal('Name',TIBTransaction);
  CreateDesignPropertyRemoveLocal('Tag',TIBTransaction);
  CreateDesignPropertyRemoveLocal('Active',TIBTransaction);
  CreateDesignPropertyRemoveLocal('DefaultDatabase',TIBTransaction);
  CreateDesignPropertyRemoveLocal('IdleTimer',TIBTransaction);
  CreateDesignPropertyRemoveLocal('DefaultAction',TIBTransaction);
  CreateDesignPropertyRemoveLocal('Params',TIBTransaction);
  CreateDesignPropertyRemoveLocal('AutoStopAction',TIBTransaction);

end;

procedure ClearListDesignPropertyRemoves;
var
  i: Integer;
  P: PInfoDesignPropertyRemove;
begin
  for i:=ListDesignPropertyRemoves.Count-1 downto 0 do begin
    P:=ListDesignPropertyRemoves.Items[i];
    FreeDesignPropertyRemove_(THandle(P));
  end;
  ListDesignPropertyRemoves.Clear;
end;

function isValidDesignPropertyRemove_(DesignPropertyRemoveHandle: THandle): Boolean; stdcall;
begin
  Result:=ListDesignPropertyRemoves.IndexOf(Pointer(DesignPropertyRemoveHandle))<>-1;
end;

function CreateDesignPropertyRemove_(PCDPR: PCreateDesignPropertyRemove): THandle; stdcall;
var
  P: PInfoDesignPropertyRemove;
begin
  Result:=DESIGNPROPERTYREMOVE_INVALID_HANDLE;
  if not IsValidPointer(PCDPR,SizeOf(TCreateDesignPropertyRemove)) then exit;
  New(P);
  FillChar(P^,SizeOf(TCreateDesignPropertyRemove),0);
  P.Name:=PCDPR.Name;
  P.Cls:=PCDPR.Cls;
  ListDesignPropertyRemoves.Add(P);
  Result:=THandle(P);
end;

function FreeDesignPropertyRemove_(DesignPropertyRemoveHandle: THandle): Boolean; stdcall;
var
  P: PInfoDesignPropertyRemove;
begin
  Result:=false;
  if not isValidDesignPropertyRemove_(DesignPropertyRemoveHandle) then exit;
  P:=PInfoDesignPropertyRemove(DesignPropertyRemoveHandle);
  ListDesignPropertyRemoves.Remove(P);
  Dispose(P);
  Result:=true;
end;

procedure GetDesignPropertyRemoves_(Owner: Pointer; Proc: TGetDesignPropertyRemoveProc); stdcall;
var
  i: Integer;
  P: PInfoDesignPropertyRemove;
  TGDPR: TGetDesignPropertyRemove;
begin
  if not IsValidPointer(@Proc) then exit;
  for i:=0 to ListDesignPropertyRemoves.Count-1 do begin
    P:=ListDesignPropertyRemoves.Items[i];
    FillChar(TGDPR,SizeOf(TGetDesignPropertyRemove),0);
    TGDPR.Name:=PChar(P.Name);
    TGDPR.Cls:=P.Cls;
    Proc(Owner,@TGDPR);
  end;
end;

// ----------- DesignPropertyEditor --------------------------

procedure ClearListDesignPropertyEditors;
var
  i: Integer;
  P: PInfoDesignPropertyEditor;
begin
  for i:=ListDesignPropertyEditors.Count-1 downto 0 do begin
    P:=ListDesignPropertyEditors.Items[i];
    FreeDesignPropertyEditor_(THandle(P));
  end;
  ListDesignPropertyEditors.Clear;
end;

function isValidDesignPropertyEditor_(DesignPropertyEditorHandle: THandle): Boolean; stdcall;
begin
  Result:=ListDesignPropertyEditors.IndexOf(Pointer(DesignPropertyEditorHandle))<>-1;
end;

function CreateDesignPropertyEditor_(PCDPE: PCreateDesignPropertyEditor): THandle; stdcall;
var
  P: PInfoDesignPropertyEditor;
begin
  Result:=DESIGNPROPERTYEDITOR_INVALID_HANDLE;
  if not IsValidPointer(PCDPE,SizeOf(TCreateDesignPropertyEditor)) then exit;
  New(P);
  FillChar(P^,SizeOf(TCreateDesignPropertyEditor),0);
  P.PropertyType:=PCDPE.PropertyType;
  P.ComponentClass:=PCDPE.ComponentClass;
  P.PropertyName:=PCDPE.PropertyName;
  P.EditorClass:=PCDPE.EditorClass;
  RegisterPropertyEditor(P.PropertyType,P.ComponentClass,P.PropertyName,P.EditorClass);
  ListDesignPropertyEditors.Add(P);
  Result:=THandle(P);
end;

function FreeDesignPropertyEditor_(DesignPropertyEditorHandle: THandle): Boolean; stdcall;
var
  P: PInfoDesignPropertyEditor;
begin
  Result:=false;
  if not isValidDesignPropertyEditor_(DesignPropertyEditorHandle) then exit;
  P:=PInfoDesignPropertyEditor(DesignPropertyEditorHandle);
  ListDesignPropertyEditors.Remove(P);
  Dispose(P);
  Result:=true;
end;

// ----------- DesignComponentEditor --------------------------

procedure ClearListDesignComponentEditors;
var
  i: Integer;
  P: PInfoDesignComponentEditor;
begin
  for i:=ListDesignComponentEditors.Count-1 downto 0 do begin
    P:=ListDesignComponentEditors.Items[i];
    FreeDesignComponentEditor_(THandle(P));
  end;
  ListDesignComponentEditors.Clear;
end;

function isValidDesignComponentEditor_(DesignComponentEditorHandle: THandle): Boolean; stdcall;
begin
  Result:=ListDesignComponentEditors.IndexOf(Pointer(DesignComponentEditorHandle))<>-1;
end;

function CreateDesignComponentEditor_(PCDCE: PCreateDesignComponentEditor): THandle; stdcall;
var
  P: PInfoDesignComponentEditor;
begin
  Result:=DESIGNCOMPONENTEDITOR_INVALID_HANDLE;
  if not IsValidPointer(PCDCE,SizeOf(TCreateDesignComponentEditor)) then exit;
  New(P);
  FillChar(P^,SizeOf(TCreateDesignComponentEditor),0);
  P.ComponentClass:=PCDCE.ComponentClass;
  P.ComponentEditor:=PCDCE.ComponentEditor;
  RegisterComponentEditor(P.ComponentClass,P.ComponentEditor);
  ListDesignComponentEditors.Add(P);
  Result:=THandle(P);
end;

function FreeDesignComponentEditor_(DesignComponentEditorHandle: THandle): Boolean; stdcall;
var
  P: PInfoDesignComponentEditor;
begin
  Result:=false;
  if not isValidDesignComponentEditor_(DesignComponentEditorHandle) then exit;
  P:=PInfoDesignComponentEditor(DesignComponentEditorHandle);
  ListDesignComponentEditors.Remove(P);
  Dispose(P);
  Result:=true;
end;

// ----------- DesignCodeTemplate --------------------------

procedure ClearListDesignCodeTemplates;
var
  i: Integer;
  P: PInfoDesignCodeTemplate;
begin
  for i:=ListDesignCodeTemplates.Count-1 downto 0 do begin
    P:=ListDesignCodeTemplates.Items[i];
    FreeDesignCodeTemplate_(THandle(P));
  end;
  ListDesignCodeTemplates.Clear;
end;

function isValidDesignCodeTemplate_(DesignCodeTemplateHandle: THandle):Boolean; stdcall;
begin
  Result:=ListDesignCodeTemplates.IndexOf(Pointer(DesignCodeTemplateHandle))<>-1;
end;

function GetInfoDesignCodeTemplateByName(Name: string): PInfoDesignCodeTemplate;
var
  i: Integer;
  P: PInfoDesignCodeTemplate;
begin
  Result:=nil;
  for i:=0 to ListDesignCodeTemplates.Count-1 do begin
    P:=ListDesignCodeTemplates.Items[i];
    if AnsiSameText(P.Name,Name) then begin
      Result:=P;
      exit;
    end;
  end;
end;

function CreateDesignCodeTemplate_(PCDCT: PCreateDesignCodeTemplate): THandle; stdcall;
var
  P: PInfoDesignCodeTemplate;
begin
  Result:=DESIGNCODETEMPLATE_INVALID_HANDLE;
  if not IsValidPointer(PCDCT,SizeOf(TCreateDesignCodeTemplate)) then exit;
  if Trim(PCDCT.Name)='' then exit;
  if not isValidPointer(@PCDCT.GetCodeProc) then exit;
  if GetInfoDesignCodeTemplateByName(PCDCT.Name)<>nil then exit;
  New(P);
  FillChar(P^,SizeOf(TCreateDesignCodeTemplate),0);
  P.Name:=PCDCT.Name;
  P.Hint:=PCDCT.Hint;
  P.GetCodeProc:=PCDCT.GetCodeProc;
  ListDesignCodeTemplates.Add(P);
  Result:=THandle(P);
end;

function FreeDesignCodeTemplate_(DesignCodeTemplateHandle: THandle): Boolean; stdcall;
var
  P: PInfoDesignCodeTemplate;
begin
  Result:=false;
  if not isValidDesignCodeTemplate_(DesignCodeTemplateHandle) then exit;
  P:=PInfoDesignCodeTemplate(DesignCodeTemplateHandle);
  ListDesignCodeTemplates.Remove(P);
  Dispose(P);
  Result:=true;
end;

procedure GetDesignCodeTemplates_(Owner: Pointer; Proc: TGetDesignCodeTemplateProc); stdcall;
var
  i: Integer;
  P: PInfoDesignCodeTemplate;
  TGDCT: TGetDesignCodeTemplate;
begin
  if not IsValidPointer(@Proc) then exit;
  for i:=0 to ListDesignCodeTemplates.Count-1 do begin
    P:=ListDesignCodeTemplates.Items[i];
    FillChar(TGDCT,SizeOf(TGetDesignCodeTemplate),0);
    TGDCT.Name:=PChar(P.Name);
    TGDCT.Hint:=PChar(P.Hint);
    Proc(Owner,@TGDCT);
  end;
end;

function GetDesignCodeTemplateCodeByName_(DesignCodeTemplateName: PChar): PChar; stdcall;
var
  P: PInfoDesignCodeTemplate;
begin
  Result:=nil;
  P:=GetInfoDesignCodeTemplateByName(DesignCodeTemplateName);
  if P<>nil then begin
    if isValidPointer(@P.GetCodeProc) then
      Result:=P.GetCodeProc(THandle(P));
  end;
end;

// ----------- DesignFormTemplate --------------------------

procedure ClearListDesignFormTemplates;
var
  i: Integer;
  P: PInfoDesignFormTemplate;
begin
  for i:=ListDesignFormTemplates.Count-1 downto 0 do begin
    P:=ListDesignFormTemplates.Items[i];
    FreeDesignFormTemplate_(THandle(P));
  end;
  ListDesignFormTemplates.Clear;
end;

function isValidDesignFormTemplate_(DesignFormTemplateHandle: THandle):Boolean; stdcall;
begin
  Result:=ListDesignFormTemplates.IndexOf(Pointer(DesignFormTemplateHandle))<>-1;
end;

function GetInfoDesignFormTemplateByName(Name: string): PInfoDesignFormTemplate;
var
  i: Integer;
  P: PInfoDesignFormTemplate;
begin
  Result:=nil;
  for i:=0 to ListDesignFormTemplates.Count-1 do begin
    P:=ListDesignFormTemplates.Items[i];
    if AnsiSameText(P.Name,Name) then begin
      Result:=P;
      exit;
    end;
  end;
end;

function CreateDesignFormTemplate_(PCDFT: PCreateDesignFormTemplate): THandle; stdcall;
var
  P: PInfoDesignFormTemplate;
begin
  Result:=DESIGNFORMTEMPLATE_INVALID_HANDLE;
  if not IsValidPointer(PCDFT,SizeOf(TCreateDesignFormTemplate)) then exit;
  if Trim(PCDFT.Name)='' then exit;
  if not isValidPointer(@PCDFT.GetFormProc) then exit;
  if GetInfoDesignFormTemplateByName(PCDFT.Name)<>nil then exit;
  New(P);
  FillChar(P^,SizeOf(TCreateDesignFormTemplate),0);
  P.Name:=PCDFT.Name;
  P.Hint:=PCDFT.Hint;
  P.GetFormProc:=PCDFT.GetFormProc;
  ListDesignFormTemplates.Add(P);
  Result:=THandle(P);
end;

function FreeDesignFormTemplate_(DesignFormTemplateHandle: THandle): Boolean; stdcall;
var
  P: PInfoDesignFormTemplate;
begin
  Result:=false;
  if not isValidDesignFormTemplate_(DesignFormTemplateHandle) then exit;
  P:=PInfoDesignFormTemplate(DesignFormTemplateHandle);
  ListDesignFormTemplates.Remove(P);
  Dispose(P);
  Result:=true;
end;

procedure GetDesignFormTemplates_(Owner: Pointer; Proc: TGetDesignFormTemplateProc); stdcall;
var
  i: Integer;
  P: PInfoDesignFormTemplate;
  TGDFT: TGetDesignFormTemplate;
begin
  if not IsValidPointer(@Proc) then exit;
  for i:=0 to ListDesignFormTemplates.Count-1 do begin
    P:=ListDesignFormTemplates.Items[i];
    FillChar(TGDFT,SizeOf(TGDFT),0);
    TGDFT.Name:=PChar(P.Name);
    TGDFT.Hint:=PChar(P.Hint);
    Proc(Owner,@TGDFT);
  end;
end;

function GetDesignFormTemplateFormByName_(DesignFormTemplateName: PChar): PChar; stdcall;
var
  P: PInfoDesignFormTemplate;
begin
  Result:=nil;
  P:=GetInfoDesignFormTemplateByName(DesignFormTemplateName);
  if P<>nil then begin
    if isValidPointer(@P.GetFormProc) then
      Result:=P.GetFormProc(THandle(P));
  end;
end;

// ----------- ReadAndWriteParams --------------------------

function isExistsParam_(Section,Param: PChar): Boolean; stdcall;
begin
  Result:=false;
  if not isValidPointer(Section) then exit;
  if not isValidPointer(Param) then exit;
  if Assigned(MemIniFile) then
    Result:=MemIniFile.ValueExists(Section,Param);
end;

procedure WriteParam_(Section,Param: PChar; Value: Variant); stdcall;
begin
  if not isValidPointer(Section) then exit;
  if not isValidPointer(Param) then exit;
  if not Assigned(MemIniFile) then exit;
  try
   case VarType(Value) of
    varEmpty:;
    varNull:;
    varSmallint:  MemIniFile.WriteInteger(Section,Param,Value);
    varInteger:   MemIniFile.WriteInteger(Section,Param,Value);
    varSingle:    MemIniFile.WriteFloat(Section,Param,Value);
    varDouble:    MemIniFile.WriteFloat(Section,Param,Value);
    varCurrency:  MemIniFile.WriteFloat(Section,Param,Value);
    varDate:      MemIniFile.WriteDate(Section,Param,Value);
    varOleStr:;
    varDispatch:;
    varError:;
    varBoolean:   MemIniFile.WriteBool(Section,Param,Value);
    varVariant:;
    varUnknown:;
    varByte:      MemIniFile.WriteInteger(Section,Param,Value);
    varStrArg:;
    varString:    MemIniFile.WriteString(Section,Param,Value);
    varAny:;
    varTypeMask:;
    varArray:;
    varByRef:;
   end;
  except
   {$IFDEF DEBUG} on E: Exception do if isAppLoaded then Assert(false,E.message); {$ENDIF}
  end;  
end;

function ReadParam_(Section,Param: PChar; Default: Variant): Variant; stdcall;
begin
  Result:=Default;
  if not isValidPointer(Section) then exit;
  if not isValidPointer(Param) then exit;
  if not Assigned(MemIniFile) then exit;
  try
   case VarType(Default) of
    varEmpty:;
    varNull:;
    varSmallint:  Result:=MemIniFile.ReadInteger(Section,Param,Default);
    varInteger:   Result:=MemIniFile.ReadInteger(Section,Param,Default);
    varSingle:    Result:=MemIniFile.ReadFloat(Section,Param,Default);
    varDouble:    Result:=MemIniFile.ReadFloat(Section,Param,Default);
    varCurrency:  Result:=MemIniFile.ReadFloat(Section,Param,Default);
    varDate:      Result:=MemIniFile.ReadDate(Section,Param,Default);
    varOleStr:;
    varDispatch:;
    varError:;
    varBoolean:   Result:=MemIniFile.ReadBool(Section,Param,Default);
    varVariant:;
    varUnknown:;
    varByte:      Result:=MemIniFile.ReadInteger(Section,Param,Default);
    varStrArg:;
    varString:    Result:=MemIniFile.ReadString(Section,Param,Default);
    varAny:;
    varTypeMask:;
    varArray:;
    varByRef:;
   end;
  except
   {$IFDEF DEBUG} on E: Exception do if isAppLoaded then Assert(false,E.message); {$ENDIF}
  end;
end;

procedure ClearParams_; stdcall;
begin
  if not Assigned(MemIniFile) then exit;
  MemIniFile.Clear;
end;

procedure SaveParams_; stdcall;
begin
  SaveDataIniToBase;
end;

procedure LoadParams_; stdcall;
begin
  LoadDataIniFromBase;
end;

function EraseParams_(Section: PChar): Boolean; stdcall;
begin
  Result:=false;
  if not isValidPointer(Section) then exit;
  if not Assigned(MemIniFile) then exit;
  MemIniFile.EraseSection(Section);
  Result:=not MemIniFile.SectionExists(Section);
end;

function SaveParamsToFile_(PSPTF: PSaveParamsToFile): Boolean; stdcall;
begin
  Result:=false;
  if not IsValidPointer(PSPTF,SizeOf(TSaveParamsToFile)) then exit;
  if not Assigned(MemIniFile) then exit;
  MemIniFile.SaveToFile(PSPTF.FileName);
  Result:=true;
end;

function LoadParamsFromFile_(PLPFF: PLoadParamsFromFile): Boolean; stdcall;
begin
  Result:=false;
  if not IsValidPointer(PLPFF,SizeOf(TLoadParamsFromFile)) then exit;
  if not Assigned(MemIniFile) then exit;
  MemIniFile.LoadFromFile(PLPFF.FileName);
  Result:=true;
end;


// ----------- InterpreterConsts --------------------------

procedure ClearListInterpreterConsts;
var
  i: Integer;
  P: PInfoInterpreterConst;
begin
  for i:=ListInterpreterConsts.Count-1 downto 0 do begin
    P:=ListInterpreterConsts.Items[i];
    FreeInterpreterConst_(THandle(P));
  end;
  ListInterpreterConsts.Clear;
end;

function IsValidInterpreterConst_(InterpreterConstHandle: THandle): Boolean; stdcall;
begin
  Result:=ListInterpreterConsts.IndexOf(Pointer(InterpreterConstHandle))<>-1;
end;

function isExistsInterpreterConst(Identifer: String): Boolean;
var
  i: Integer;
  P: PInfoInterpreterConst;
begin
  Result:=false;
  for i:=0 to ListInterpreterConsts.Count-1 do begin
    P:=ListInterpreterConsts.Items[i];
    if AnsiSameText(P.Identifer,Identifer) then begin
      Result:=true;
      exit;
    end;
  end;
end;

function CreateInterpreterConst_(PCIC: PCreateInterpreterConst): THandle; stdcall;
var
  P: PInfoInterpreterConst;
begin
  Result:=INTERPRETERCONST_INVALID_HANDLE;
  if not IsValidPointer(PCIC,SizeOf(TCreateInterpreterConst)) then exit;
  if Trim(PCIC.Identifer)='' then exit;
  if isExistsInterpreterConst(PCIC.Identifer) then exit;
  New(P);
  FillChar(P^,SizeOf(TInfoInterpreterConst),0);
  P.Identifer:=PCIC.Identifer;
  P.Value:=PCIC.Value;
  P.TypeInfo:=PCIC.TypeInfo;
  P.Hint:=PCIC.Hint;
  case PCIC.TypeCreate of
    tcLast: ListInterpreterConsts.Add(P);
    tcFirst: ListInterpreterConsts.Insert(0,P);
  end;
  Result:=THandle(P);
end;

function FreeInterpreterConst_(InterpreterConstHandle: THandle): Boolean; stdcall;
var
  P: PInfoInterpreterConst;
begin
  Result:=false;
  if not IsValidInterpreterConst_(InterpreterConstHandle) then exit;
  P:=PInfoInterpreterConst(InterpreterConstHandle);
  ListInterpreterConsts.Remove(P);
  Dispose(P);
  Result:=true;
end;

procedure GetInterpreterConsts_(Owner: Pointer; Proc: TGetInterpreterConstProc); stdcall;
var
  i: Integer;
  P: PInfoInterpreterConst;
  TGIC: TGetInterpreterConst;
begin
  if not IsValidPointer(@Proc) then exit;
  for i:=0 to ListInterpreterConsts.Count-1 do begin
    P:=ListInterpreterConsts.Items[i];
    FillChar(TGIC,SizeOf(TGetInterpreterConst),0);
    TGIC.Identifer:=PChar(P.Identifer);
    TGIC.Value:=P.Value;
    TGIC.TypeInfo:=P.TypeInfo;
    TGIC.Hint:=PChar(P.Hint);
    Proc(Owner,@TGIC);
  end;
end;

// ----------- InterpreterClasses --------------------------

procedure ClearListInterpreterClasses;
var
  i: Integer;
  P: PInfoInterpreterClass;
begin
  for i:=ListInterpreterClasses.Count-1 downto 0 do begin
    P:=ListInterpreterClasses.Items[i];
    FreeInterpreterClass_(THandle(P));
  end;
  ListInterpreterClasses.Clear;
end;

function IsValidInterpreterClass_(InterpreterClassHandle: THandle): Boolean; stdcall;
begin
  Result:=ListInterpreterClasses.IndexOf(Pointer(InterpreterClassHandle))<>-1;
end;

function isExistsInterpreterClass(ClassType: TClass): Boolean;
var
  i: Integer;
  P: PInfoInterpreterClass;
begin
  Result:=false;
  for i:=0 to ListInterpreterClasses.Count-1 do begin
    P:=ListInterpreterClasses.Items[i];
    if P.ClassType=ClassType then begin
      Result:=true;
      exit;
    end;
  end;
end;

function CreateInterpreterClass_(PCICL: PCreateInterpreterClass): THandle; stdcall;
var
  P: PInfoInterpreterClass;
begin
  Result:=INTERPRETERCLASS_INVALID_HANDLE;
  if not IsValidPointer(PCICL,SizeOf(TCreateInterpreterClass)) then exit;
  if isExistsInterpreterClass(PCICL.ClassType) then exit;
  New(P);
  FillChar(P^,SizeOf(TInfoInterpreterClass),0);
  P.ClassType:=PCICL.ClassType;
  P.Hint:=PCICL.Hint;
  P.ListMethods:=TList.Create;
  P.ListProperties:=TList.Create;
  case PCICL.TypeCreate of
    tcLast: ListInterpreterClasses.Add(P);
    tcFirst: ListInterpreterClasses.Insert(0,P);
  end;
  Result:=THandle(P);
end;

function FreeInterpreterClass_(InterpreterClassHandle: THandle): Boolean; stdcall;
var
  P: PInfoInterpreterClass;
  i: Integer;
  PMethod: PInfoInterpreterClassMethod;
  PProp: PInfoInterpreterClassProperty;
begin
  Result:=false;
  if not IsValidInterpreterClass_(InterpreterClassHandle) then exit;
  P:=PInfoInterpreterClass(InterpreterClassHandle);
  for i:=P.ListMethods.Count-1 downto 0 do begin
    PMethod:=P.ListMethods.Items[i];
    FreeInterpreterClassMethod_(THandle(PMethod));
  end;
  P.ListMethods.Free;
  for i:=P.ListProperties.Count-1 downto 0 do begin
    PProp:=P.ListProperties.Items[i];
    FreeInterpreterClassProperty_(THandle(PProp));
  end;
  P.ListProperties.Free;
  ListInterpreterClasses.Remove(P);
  Dispose(P);
  Result:=true;
end;

function isExistsInterpreterClassProperty(PClass: PInfoInterpreterClass; Identifer: string): Boolean;
var
  i: Integer;
  P: PInfoInterpreterClassProperty;
begin
  Result:=false;
  for i:=0 to PClass.ListProperties.Count-1 do begin
    P:=PClass.ListProperties.Items[i];
    if AnsiSameText(P.Identifer,Identifer) then begin
      Result:=true;
      exit;
    end;
  end;
end;

function isExistsInterpreterClassMethod(PClass: PInfoInterpreterClass; Identifer: string): Boolean;
var
  i: Integer;
  P: PInfoInterpreterClassMethod;
begin
  Result:=false;
  for i:=0 to PClass.ListMethods.Count-1 do begin
    P:=PClass.ListMethods.Items[i];
    if AnsiSameText(P.Identifer,Identifer) then begin
      Result:=true;
      exit;
    end;
  end;
end;

function isExistsClassPropertyReadProcParam(P: PInfoInterpreterClassProperty; ParamName: string): Boolean;
var
  i: Integer;
  PRead: PInterpreterProcParam;
begin
  Result:=false;
  for i:=0 to P.ListReadProcParams.Count-1 do begin
    PRead:=P.ListReadProcParams.Items[i];
    if AnsiSameText(PRead.ParamText,ParamName) then begin
      Result:=true;
      exit
    end;
  end;
end;

function isExistsClassPropertyWriteProcParam(P: PInfoInterpreterClassProperty; ParamName: string): Boolean;
var
  i: Integer;
  PWrite: PInterpreterProcParam;
begin
  Result:=false;
  for i:=0 to P.ListWriteProcParams.Count-1 do begin
    PWrite:=P.ListWriteProcParams.Items[i];
    if AnsiSameText(PWrite.ParamText,ParamName) then begin
      Result:=true;
      exit
    end;
  end;
end;

function CreateInterpreterClassProperty_(InterpreterClassHandle: THandle; PCICP: PCreateInterpreterClassProperty): THandle; stdcall;
var
  P: PInfoInterpreterClassProperty;
  PClass: PInfoInterpreterClass;
  I: Integer;
  PCreateICPPP: PInterpreterProcParam;
  PInfoICPPP: PInfoInterpreterProcParam;
begin
  Result:=INTERPRETERCLASSPROPERTY_INVALID_HANDLE;
  if not IsValidInterpreterClass_(InterpreterClassHandle) then exit;
  if not IsValidPointer(PCICP,SizeOf(TCreateInterpreterClassProperty)) then exit;
  if Trim(PCICP.Identifer)='' then exit;
  PClass:=PInfoInterpreterClass(InterpreterClassHandle);
  if isExistsInterpreterClassProperty(PClass,PCICP.Identifer) then exit;
  New(P);
  FillChar(P^,SizeOf(TInfoInterpreterClassProperty),0);
  P.Identifer:=PCICP.Identifer;
  P.ReadProc:=PCICP.ReadProc;
  P.ListReadProcParams:=TList.Create;
  for i:=Low(PCICP.ReadProcParams) to High(PCICP.ReadProcParams) do begin
    PCreateICPPP:=@PCICP.ReadProcParams[i];
    if isValidPointer(PCreateICPPP) then begin
     if not isExistsClassPropertyReadProcParam(P,PCreateICPPP.ParamText) then begin
      New(PInfoICPPP);
      FillChar(PInfoICPPP^,Sizeof(TInfoInterpreterProcParam),0);
      PInfoICPPP.ParamText:=PCreateICPPP.ParamText;
      PInfoICPPP.ParamType:=PCreateICPPP.ParamType;
      P.ListReadProcParams.Add(PInfoICPPP);
     end;
    end;
  end;
  P.ReadProcResultType:=PCICP.ReadProcResultType;
  P.WriteProc:=PCICP.WriteProc;
  P.ListWriteProcParams:=TList.Create;
  for i:=Low(PCICP.WriteProcParams) to High(PCICP.WriteProcParams) do begin
    PCreateICPPP:=@PCICP.WriteProcParams[i];
    if isValidPointer(PCreateICPPP) then begin
     if not isExistsClassPropertyWriteProcParam(P,PCreateICPPP.ParamText) then begin
      New(PInfoICPPP);
      FillChar(PInfoICPPP^,Sizeof(TInfoInterpreterProcParam),0);
      PInfoICPPP.ParamText:=PCreateICPPP.ParamText;
      PInfoICPPP.ParamType:=PCreateICPPP.ParamType;
      P.ListWriteProcParams.Add(PInfoICPPP);
     end;
    end;
  end;
  P.isIndexProperty:=PCICP.isIndexProperty;
  P.Hint:=PCICP.Hint;
  PClass.ListProperties.Add(P);
  Result:=THandle(P);
end;

function GetInfoInterpreterClassByProperty(P: PInfoInterpreterClassProperty): PInfoInterpreterClass;
var
  i: Integer;
  val: Integer;
  PClass: PInfoInterpreterClass;
begin
  Result:=nil;
  for i:=0 to ListInterpreterClasses.Count-1 do begin
    PClass:=ListInterpreterClasses.Items[i];
    val:=PClass.ListProperties.IndexOf(P);
    if val<>-1 then begin
      Result:=PClass;
      exit;
    end;
  end;
end;

function FreeInterpreterClassProperty_(InterpreterClassPropertyHandle: THandle): Boolean; stdcall;
var
  PClass: PInfoInterpreterClass;
  P: PInfoInterpreterClassProperty;
  i: Integer;
  PRead,PWrite: PInfoInterpreterProcParam;
begin
  Result:=false;
  P:=PInfoInterpreterClassProperty(InterpreterClassPropertyHandle);
  PClass:=GetInfoInterpreterClassByProperty(P);
  if PClass=nil then exit;
  for i:=0 to P.ListReadProcParams.Count-1 do begin
    PRead:=P.ListReadProcParams.Items[i];
    Dispose(PRead);
  end;
  P.ListReadProcParams.Free;
  for i:=0 to P.ListWriteProcParams.Count-1 do begin
    PWrite:=P.ListWriteProcParams.Items[i];
    Dispose(PWrite);
  end;
  P.ListWriteProcParams.Free;
  PClass.ListProperties.Remove(P);
  Dispose(P);
  Result:=true;
end;

function isExistsClassMethodProcParam(P: PInfoInterpreterClassMethod; ParamName: string): Boolean;
var
  i: Integer;
  PRead: PInterpreterProcParam;
begin
  Result:=false;
  for i:=0 to P.ListProcParams.Count-1 do begin
    PRead:=P.ListProcParams.Items[i];
    if AnsiSameText(PRead.ParamText,ParamName) then begin
      Result:=true;
      exit
    end;
  end;
end;

function CreateInterpreterClassMethod_(InterpreterClassHandle: THandle; PCICM: PCreateInterpreterClassMethod): THandle; stdcall;
var
  P: PInfoInterpreterClassMethod;
  PClass: PInfoInterpreterClass;
  I: Integer;
  PCreateICPPP: PInterpreterProcParam;
  PInfoICPPP: PInfoInterpreterProcParam;
begin
  Result:=INTERPRETERCLASSMETHOD_INVALID_HANDLE;
  if not IsValidInterpreterClass_(InterpreterClassHandle) then exit;
  if not IsValidPointer(PCICM,SizeOf(TCreateInterpreterClassMethod)) then exit;
  if Trim(PCICM.Identifer)='' then exit;
  if not isValidPointer(@PCICM.Proc) then exit;
  PClass:=PInfoInterpreterClass(InterpreterClassHandle);
  if isExistsInterpreterClassMethod(PClass,PCICM.Identifer) then exit;
  New(P);
  FillChar(P^,SizeOf(TInfoInterpreterClassMethod),0);
  P.Identifer:=PCICM.Identifer;
  P.Proc:=PCICM.Proc;
  P.ListProcParams:=TList.Create;
  for i:=Low(PCICM.ProcParams) to High(PCICM.ProcParams) do begin
    PCreateICPPP:=@PCICM.ProcParams[i];
    if isValidPointer(PCreateICPPP) then begin
     if not isExistsClassMethodProcParam(P,PCreateICPPP.ParamText) then begin
      New(PInfoICPPP);
      FillChar(PInfoICPPP^,Sizeof(TInfoInterpreterProcParam),0);
      PInfoICPPP.ParamText:=PCreateICPPP.ParamText;
      PInfoICPPP.ParamType:=PCreateICPPP.ParamType;
      P.ListProcParams.Add(PInfoICPPP);
     end;
    end;
  end;
  P.ProcResultType:=PCICM.ProcResultType;
  P.Hint:=PCICM.Hint;
  PClass.ListMethods.Add(P);
  Result:=THandle(P);
end;

function GetInfoInterpreterClassByMethod(P: PInfoInterpreterClassMethod): PInfoInterpreterClass;
var
  i: Integer;
  val: Integer;
  PClass: PInfoInterpreterClass;
begin
  Result:=nil;
  for i:=0 to ListInterpreterClasses.Count-1 do begin
    PClass:=ListInterpreterClasses.Items[i];
    val:=PClass.ListMethods.IndexOf(P);
    if val<>-1 then begin
      Result:=PClass;
      exit;
    end;
  end;
end;

function FreeInterpreterClassMethod_(InterpreterClassMethodHandle: THandle): Boolean; stdcall;
var
  PClass: PInfoInterpreterClass;
  P: PInfoInterpreterClassMethod;
  i: Integer;
  PProc: PInfoInterpreterProcParam;
begin
  Result:=false;
  P:=PInfoInterpreterClassMethod(InterpreterClassMethodHandle);
  PClass:=GetInfoInterpreterClassByMethod(P);
  if PClass=nil then exit;
  for i:=0 to P.ListProcParams.Count-1 do begin
    PProc:=P.ListProcParams.Items[i];
    Dispose(PProc);
  end;
  P.ListProcParams.Free;
  PClass.ListMethods.Remove(P);
  Dispose(P);
  Result:=true;
end;

procedure GetInterpreterClasses_(Owner: Pointer; Proc: TGetInterpreterClassProc); stdcall;
var
  i,j,x: Integer;
  P: PInfoInterpreterClass;
  TGICL: TGetInterpreterClass;
  PProp: PInfoInterpreterClassProperty;
  PMethod: PInfoInterpreterClassMethod;
  PRead,PWrite: PInfoInterpreterProcParam;
  IndexJ,IndexX: Integer;
begin
  if not IsValidPointer(@Proc) then exit;
  for i:=0 to ListInterpreterClasses.Count-1 do begin
    P:=ListInterpreterClasses.Items[i];
    FillChar(TGICL,SizeOf(TGetInterpreterClass),0);
    TGICL.ClassType:=P.ClassType;
    TGICL.Hint:=PChar(P.Hint);

    for j:=0 to P.ListMethods.Count-1 do begin
      PMethod:=P.ListMethods.Items[j];
      IndexJ:=Length(TGICL.Methods)+1;
      SetLength(TGICL.Methods,IndexJ);
      TGICL.Methods[IndexJ-1].Identifer:=PChar(PMethod.Identifer);
      TGICL.Methods[IndexJ-1].Proc:=PMethod.Proc;
      for x:=0 to PMethod.ListProcParams.Count-1 do begin
        PRead:=PMethod.ListProcParams.Items[x];
        IndexX:=Length(TGICL.Methods[IndexJ-1].ProcParams)+1;
        Setlength(TGICL.Methods[IndexJ-1].ProcParams,IndexX);
        TGICL.Methods[IndexJ-1].ProcParams[IndexX-1].ParamText:=PChar(PRead.ParamText);
        TGICL.Methods[IndexJ-1].ProcParams[IndexX-1].ParamType:=PRead.ParamType;
      end;
      TGICL.Methods[IndexJ-1].ProcResultType:=PMethod.ProcResultType;
      TGICL.Methods[IndexJ-1].Hint:=PChar(PMethod.Hint);
    end;
    
    for j:=0 to P.ListProperties.Count-1 do begin
      PProp:=P.ListProperties.Items[j];
      IndexJ:=Length(TGICL.Properties)+1;
      SetLength(TGICL.Properties,IndexJ);
      TGICL.Properties[IndexJ-1].Identifer:=PChar(PProp.Identifer);
      TGICL.Properties[IndexJ-1].ReadProc:=PProp.ReadProc;
      for x:=0 to PProp.ListReadProcParams.Count-1 do begin
        PRead:=PProp.ListReadProcParams.Items[x];
        IndexX:=Length(TGICL.Properties[IndexJ-1].ReadProcParams)+1;
        Setlength(TGICL.Properties[IndexJ-1].ReadProcParams,IndexX);
        TGICL.Properties[IndexJ-1].ReadProcParams[IndexX-1].ParamText:=PChar(PRead.ParamText);
        TGICL.Properties[IndexJ-1].ReadProcParams[IndexX-1].ParamType:=PRead.ParamType;
      end;
      TGICL.Properties[IndexJ-1].ReadProcResultType:=PProp.ReadProcResultType;
      TGICL.Properties[IndexJ-1].WriteProc:=PProp.WriteProc;
      for x:=0 to PProp.ListWriteProcParams.Count-1 do begin
        PWrite:=PProp.ListWriteProcParams.Items[x];
        IndexX:=Length(TGICL.Properties[IndexJ-1].WriteProcParams)+1;
        Setlength(TGICL.Properties[IndexJ-1].WriteProcParams,IndexX);
        TGICL.Properties[IndexJ-1].WriteProcParams[IndexX-1].ParamText:=PChar(PWrite.ParamText);
        TGICL.Properties[IndexJ-1].WriteProcParams[IndexX-1].ParamType:=PWrite.ParamType;
      end;
      TGICL.Properties[IndexJ-1].Hint:=PChar(PProp.Hint);
      TGICL.Properties[IndexJ-1].isIndexProperty:=PProp.isIndexProperty;
    end;
    try
     Proc(Owner,@TGICL);
    finally
    end; 
  end;
end;

// ----------- InterpreterFuns --------------------------

procedure ClearListInterpreterFuns;
var
  i: Integer;
  P: PInfoInterpreterFun;
begin
  for i:=ListInterpreterFuns.Count-1 downto 0 do begin
    P:=ListInterpreterFuns.Items[i];
    FreeInterpreterFun_(THandle(P));
  end;
  ListInterpreterFuns.Clear;
end;

function IsValidInterpreterFun_(InterpreterFunHandle: THandle): Boolean; stdcall;
begin
  Result:=ListInterpreterFuns.IndexOf(Pointer(InterpreterFunHandle))<>-1;
end;

function isExistsInterpreterFun(Identifer: String): Boolean;
var
  i: Integer;
  P: PInfoInterpreterFun;
begin
  Result:=false;
  for i:=0 to ListInterpreterFuns.Count-1 do begin
    P:=ListInterpreterFuns.Items[i];
    if AnsiSameText(P.Identifer,Identifer) then begin
      Result:=true;
      exit;
    end;
  end;
end;

function isExistsFunProcParam(P: PInfoInterpreterFun; ParamName: string): Boolean;
var
  i: Integer;
  PProc: PInterpreterProcParam;
begin
  Result:=false;
  for i:=0 to P.ListProcParams.Count-1 do begin
    PProc:=P.ListProcParams.Items[i];
    if AnsiSameText(PProc.ParamText,ParamName) then begin
      Result:=true;
      exit
    end;
  end;
end;

function CreateInterpreterFun_(PCIP: PCreateInterpreterFun): THandle; stdcall;
var
  P: PInfoInterpreterFun;
  PCreateICPPP: PInterpreterProcParam;
  PInfoICPPP: PInfoInterpreterProcParam;
  i: Integer;
begin
  Result:=INTERPRETERFUN_INVALID_HANDLE;
  if not IsValidPointer(PCIP,SizeOf(TCreateInterpreterFun)) then exit;
  if Trim(PCIP.Identifer)='' then exit;
  if isExistsInterpreterFun(PCIP.Identifer) then exit;
  if not IsValidPointer(@PCIP.Proc) then exit;
  New(P);
  FillChar(P^,SizeOf(TInfoInterpreterFun),0);
  P.Identifer:=PCIP.Identifer;
  P.Proc:=PCIP.Proc;
  P.ListProcParams:=TList.Create;
  for i:=Low(PCIP.ProcParams) to High(PCIP.ProcParams) do begin
    PCreateICPPP:=@PCIP.ProcParams[i];
    if isValidPointer(PCreateICPPP) then begin
     if not isExistsFunProcParam(P,PCreateICPPP.ParamText) then begin
      New(PInfoICPPP);
      FillChar(PInfoICPPP^,Sizeof(TInfoInterpreterProcParam),0);
      PInfoICPPP.ParamText:=PCreateICPPP.ParamText;
      PInfoICPPP.ParamType:=PCreateICPPP.ParamType;
      P.ListProcParams.Add(PInfoICPPP);
     end;
    end;
  end;
  P.ProcResultType:=PCIP.ProcResultType;
  P.Hint:=PCIP.Hint;
  case PCIP.TypeCreate of
    tcLast: ListInterpreterFuns.Add(P);
    tcFirst: ListInterpreterFuns.Insert(0,P);
  end;
  Result:=THandle(P);
end;

function FreeInterpreterFun_(InterpreterFunHandle: THandle): Boolean; stdcall;
var
  PFun: PInfoInterpreterFun;
  i: Integer;
  PProc: PInfoInterpreterProcParam;
begin
  Result:=false;
  PFun:=PInfoInterpreterFun(InterpreterFunHandle);
  if not IsValidInterpreterFun_(InterpreterFunHandle) then exit;
  for i:=0 to PFun.ListProcParams.Count-1 do begin
    PProc:=PFun.ListProcParams.Items[i];
    Dispose(PProc);
  end;
  PFun.ListProcParams.Free;
  ListInterpreterFuns.Remove(PFun);
  Dispose(PFun);
  Result:=true;
end;

procedure GetInterpreterFuns_(Owner: Pointer; Proc: TGetInterpreterFunProc); stdcall;
var
  i,j: Integer;
  P: PInfoInterpreterFun;
  TGIF: TGetInterpreterFun;
  PProc: PInfoInterpreterProcParam;
begin
  if not IsValidPointer(@Proc) then exit;
  for i:=0 to ListInterpreterFuns.Count-1 do begin
    P:=ListInterpreterFuns.Items[i];
    FillChar(TGIF,SizeOf(TGetInterpreterFun),0);
    TGIF.Identifer:=PChar(P.Identifer);
    TGIF.Proc:=P.Proc;
    for j:=0 to P.ListProcParams.Count-1 do begin
     PProc:=P.ListProcParams.Items[j];
     Setlength(TGIF.ProcParams,j+1);
     TGIF.ProcParams[j].ParamText:=PChar(PProc.ParamText);
     TGIF.ProcParams[j].ParamType:=PProc.ParamType;
    end;
    TGIF.ProcResultType:=P.ProcResultType;
    TGIF.Hint:=PChar(P.Hint);

    try
     Proc(Owner,@TGIF);
    finally
    end;
  end;
end;

// ----------- InterpreterEvents --------------------------

procedure ClearListInterpreterEvents;
var
  i: Integer;
  P: PInfoInterpreterEvent;
begin
  for i:=ListInterpreterEvents.Count-1 downto 0 do begin
    P:=ListInterpreterEvents.Items[i];
    FreeInterpreterEvent_(THandle(P));
  end;
  ListInterpreterEvents.Clear;
end;

function IsValidInterpreterEvent_(InterpreterEventHandle: THandle): Boolean; stdcall;
begin
  Result:=ListInterpreterEvents.IndexOf(Pointer(InterpreterEventHandle))<>-1;
end;

function isExistsInterpreterEvent(Identifer: String): Boolean;
var
  i: Integer;
  P: PInfoInterpreterEvent;
begin
  Result:=false;
  for i:=0 to ListInterpreterEvents.Count-1 do begin
    P:=ListInterpreterEvents.Items[i];
    if AnsiSameText(P.Identifer,Identifer) then begin
      Result:=true;
      exit;
    end;
  end;
end;

function CreateInterpreterEvent_(PCIE: PCreateInterpreterEvent): THandle; stdcall;
var
  P: PInfoInterpreterEvent;
begin
  Result:=INTERPRETEREVENT_INVALID_HANDLE;
  if not IsValidPointer(PCIE,SizeOf(TCreateInterpreterEvent)) then exit;
  if Trim(PCIE.Identifer)='' then exit;
  if isExistsInterpreterEvent(PCIE.Identifer) then exit;
  if not IsValidPointer(@PCIE.EventProc) then exit;
  New(P);
  FillChar(P^,SizeOf(P^),0);
  P.Identifer:=PCIE.Identifer;
  P.EventClass:=PCIE.EventClass;
  P.EventProc:=PCIE.EventProc;
  P.Hint:=PCIE.Hint;
  case PCIE.TypeCreate of
    tcLast: ListInterpreterEvents.Add(P);
    tcFirst: ListInterpreterEvents.Insert(0,P);
  end;
  Result:=THandle(P);
end;

function FreeInterpreterEvent_(InterpreterEventHandle: THandle): Boolean; stdcall;
var
  PEvent: PInfoInterpreterEvent;
begin
  Result:=false;
  PEvent:=PInfoInterpreterEvent(InterpreterEventHandle);
  if not IsValidInterpreterEvent_(InterpreterEventHandle) then exit;
  ListInterpreterEvents.Remove(PEvent);
  Dispose(PEvent);
  Result:=true;
end;

procedure GetInterpreterEvents_(Owner: Pointer; Proc: TGetInterpreterEventProc); stdcall;
var
  i: Integer;
  P: PInfoInterpreterEvent;
  TGIE: TGetInterpreterEvent;
begin
  if not IsValidPointer(@Proc) then exit;
  for i:=0 to ListInterpreterEvents.Count-1 do begin
    P:=ListInterpreterEvents.Items[i];
    FillChar(TGIE,SizeOf(TGetInterpreterEvent),0);
    TGIE.Identifer:=PChar(P.Identifer);
    TGIE.Hint:=PChar(P.Hint);
    TGIE.EventClass:=P.EventClass;
    TGIE.EventProc:=P.EventProc;
    try
     Proc(Owner,@TGIE);
    finally
    end;
  end;
end;

// ----------- InterpreterVars --------------------------

procedure AddToListInterpreterVars;

   function CreateInterpreterVarLocal(Identifer: PChar; Value: Variant; TypeValue: Variant;
                                      TypeText: PChar=nil; Hint: PChar=nil): THandle;
   var
     TCIV: TCreateInterpreterVar;
   begin
     FillChar(TCIV,SizeOf(TCreateInterpreterVar),0);
     TCIV.Identifer:=Identifer;
     TCIV.Value:=Value;
     TCIV.TypeValue:=TypeValue;
     TCIV.TypeText:=TypeText;
     TCIV.Hint:=Hint;
     Result:=_CreateInterpreterVar(@TCIV);
   end;

begin
{  CreateInterpreterVarLocal(ConstMainDataBaseName,O2V(IBDB),C2V(TIBDatabase),'TIBDatabase','Главная база данных');
  CreateInterpreterVarLocal(ConstMainTransactionName,O2V(IBT),C2V(TIBTransaction),'TIBTransaction','Главная транзакция');}
end;

procedure ClearListInterpreterVars;
var
  i: Integer;
  P: PInfoInterpreterVar;
begin
  for i:=ListInterpreterVars.Count-1 downto 0 do begin
    P:=ListInterpreterVars.Items[i];
    FreeInterpreterVar_(THandle(P));
  end;
  ListInterpreterVars.Clear;
end;

function IsValidInterpreterVar_(InterpreterVarHandle: THandle): Boolean; stdcall;
begin
  Result:=ListInterpreterVars.IndexOf(Pointer(InterpreterVarHandle))<>-1;
end;

function isExistsInterpreterVar(Identifer: String): Boolean;
var
  i: Integer;
  P: PInfoInterpreterVar;
begin
  Result:=false;
  for i:=0 to ListInterpreterVars.Count-1 do begin
    P:=ListInterpreterVars.Items[i];
    if AnsiSameText(P.Identifer,Identifer) then begin
      Result:=true;
      exit;
    end;
  end;
end;

function CreateInterpreterVar_(PCIV: PCreateInterpreterVar): THandle; stdcall;
var
  P: PInfoInterpreterVar;
  val: Integer;
begin
  Result:=INTERPRETERVAR_INVALID_HANDLE;
  if not IsValidPointer(PCIV,SizeOf(TCreateInterpreterVar)) then exit;
  if Trim(PCIV.Identifer)='' then exit;
  if isExistsInterpreterVar(PCIV.Identifer) then exit;
  New(P);
  FillChar(P^,SizeOf(TInfoInterpreterVar),0);
  P.Identifer:=PCIV.Identifer;
  P.Value:=PCIV.Value;
  P.TypeValue:=PCIV.TypeValue;
  P.TypeText:=PCIV.TypeText;
  P.Hint:=PCIV.Hint;
  case PCIV.TypeCreate of
    tcLast: ListInterpreterVars.Add(P);
    tcFirst: ListInterpreterVars.Insert(0,P);
    tcAfter: begin
      val:=ListInterpreterVars.IndexOf(PInfoInterpreterVar(PCIV.hCreate));
      if val<>-1 then begin
        ListInterpreterVars.Insert(val+1,P);
      end else ListInterpreterVars.Add(P);
    end;
    tcBefore: begin
      val:=ListInterpreterVars.IndexOf(PInfoInterpreterVar(PCIV.hCreate));
      if val<>-1 then begin
        ListInterpreterVars.Insert(val,P);
      end else ListInterpreterVars.Add(P);
    end;
  end;
  Result:=THandle(P);
end;

function FreeInterpreterVar_(InterpreterVarHandle: THandle): Boolean; stdcall;
var
  P: PInfoInterpreterVar;
begin
  Result:=false;
  if not IsValidInterpreterVar_(InterpreterVarHandle) then exit;
  P:=PInfoInterpreterVar(InterpreterVarHandle);
  ListInterpreterVars.Remove(P);
  Dispose(P);
  Result:=true;
end;

procedure GetInterpreterVars_(Owner: Pointer; Proc: TGetInterpreterVarProc); stdcall;
var
  i: Integer;
  P: PInfoInterpreterVar;
  TGIV: TGetInterpreterVar;
begin
  if not IsValidPointer(@Proc) then exit;
  for i:=0 to ListInterpreterVars.Count-1 do begin
    P:=ListInterpreterVars.Items[i];
    FillChar(TGIV,SizeOf(TGetInterpreterVar),0);
    TGIV.Identifer:=PChar(P.Identifer);
    TGIV.Value:=P.Value;
    TGIV.TypeValue:=P.TypeValue;
    TGIV.TypeText:=PChar(P.TypeText);
    TGIV.Hint:=PChar(P.Hint);
    Proc(Owner,@TGIV);
  end;
end;

// ----------- LibraryInterpreters --------------------------

procedure ClearListLibraryInterpreters;
var
  i: Integer;
  P: PInfoLibraryInterpreter;
begin
  for i:=ListLibraryInterpreters.Count-1 downto 0 do begin
    P:=ListLibraryInterpreters.Items[i];
    FreeLibraryInterpreter_(THandle(P));
  end;
  ListLibraryInterpreters.Clear;
end;

function IsValidLibraryInterpreter_(LibraryInterpreterHandle: THandle): Boolean; stdcall;
begin
  Result:=ListLibraryInterpreters.IndexOf(Pointer(LibraryInterpreterHandle))<>-1;
end;

function isExistsLibraryInterpreter(GUID: String): Boolean;
var
  i: Integer;
  P: PInfoLibraryInterpreter;
begin
  Result:=false;
  for i:=0 to ListLibraryInterpreters.Count-1 do begin
    P:=ListLibraryInterpreters.Items[i];
    if AnsiSameText(P.GUID,GUID) then begin
      Result:=true;
      exit;
    end;
  end;
end;

function CreateLibraryInterpreter_(PCLI: PCreateLibraryInterpreter): THandle; stdcall;
var
  P: PInfoLibraryInterpreter;
begin
  Result:=LIBRARYINTERPRETER_INVALID_HANDLE;
  if not IsValidPointer(PCLI,SizeOf(TCreateLibraryInterpreter)) then exit;
  if Trim(PCLI.GUID)='' then exit;
  if isExistsLibraryInterpreter(PCLI.GUID) then begin
    CreateLogItem(Format(fmtLibraryInterpreterAlreadyExists,[PCLI.Guid]),tliError);
    exit;
  end;  
  New(P);
  FillChar(P^,SizeOf(TInfoLibraryInterpreter),0);
  P.GUID:=PCLI.GUID;
  P.Hint:=PCLI.Hint;
  if isValidPointer(@PCLI.CreateProc) then  P.CreateProc:=PCLI.CreateProc;
  if isValidPointer(@PCLI.RunProc) then  P.RunProc:=PCLI.RunProc;
  if isValidPointer(@PCLI.ResetProc) then  P.ResetProc:=PCLI.ResetProc;
  if isValidPointer(@PCLI.FreeProc) then  P.FreeProc:=PCLI.FreeProc;
  if isValidPointer(@PCLI.IsValidProc) then  P.IsValidProc:=PCLI.IsValidProc;
  if isValidPointer(@PCLI.SetParamsProc) then  P.SetParamsProc:=PCLI.SetParamsProc;
  if isValidPointer(@PCLI.CallFunProc) then  P.CallFunProc:=PCLI.CallFunProc;
  if isValidPointer(@PCLI.GetCreateInterfaceNameProc) then  P.GetCreateInterfaceNameProc:=PCLI.GetCreateInterfaceNameProc;
  if isValidPointer(@PCLI.GetInterpreterIdentifersProc) then  P.GetInterpreterIdentifersProc:=PCLI.GetInterpreterIdentifersProc;
  ListLibraryInterpreters.Add(P);
  Result:=THandle(P);
end;

function FreeLibraryInterpreter_(LibraryInterpreterHandle: THandle): Boolean; stdcall;
var
  P: PInfoLibraryInterpreter;
begin
  Result:=false;
  if not IsValidLibraryInterpreter_(LibraryInterpreterHandle) then exit;
  P:=PInfoLibraryInterpreter(LibraryInterpreterHandle);
  ListLibraryInterpreters.Remove(P);
  Dispose(P);
  Result:=true;
end;

function GetLibraryInterpreterHandleByGUID_(GUID: PChar): THandle; stdcall;
var
  i: Integer;
  P: PInfoLibraryInterpreter; 
begin
  Result:=LIBRARYINTERPRETER_INVALID_HANDLE;
  for i:=0 to ListLibraryInterpreters.Count-1 do begin
    P:=ListLibraryInterpreters.Items[i];
    if AnsiSameText(P.GUID,GUID) then begin
      Result:=THandle(P); 
      exit;
    end;
  end;
end;

procedure GetLibraryInterpreters_(Owner: Pointer; Proc: TGetLibraryInterpreterProc); stdcall;
var
  i: Integer;
  P: PInfoLibraryInterpreter;
  TGLI: TGetLibraryInterpreter;
begin
  if not IsValidPointer(@Proc) then exit;
  for i:=0 to ListLibraryInterpreters.Count-1 do begin
    P:=ListLibraryInterpreters.Items[i];
    FillChar(TGLI,SizeOf(TGetLibraryInterpreter),0);
    TGLI.GUID:=PChar(P.GUID);
    TGLI.Hint:=PChar(P.Hint);
    TGLI.CreateProc:=P.CreateProc;
    TGLI.RunProc:=P.RunProc;
    TGLI.ResetProc:=P.ResetProc;
    TGLI.FreeProc:=P.FreeProc;
    TGLI.IsValidProc:=P.IsValidProc;
    TGLI.SetParamsProc:=P.SetParamsProc;
    TGLI.GetCreateInterfaceNameProc:=P.GetCreateInterfaceNameProc;
    TGLI.GetInterpreterIdentifersProc:=P.GetInterpreterIdentifersProc;
    Proc(Owner,@TGLI);
  end;
end;

function CallLibraryInterpreterFun_(InterpreterHandle: THandle; Instance: TObject; Args: TArguments; FunName: PChar): Variant; stdcall;
var
  i: Integer;
  P: PInfoLibraryInterpreter;
begin
  Result:=Null;
  for i:=0 to ListLibraryInterpreters.Count-1 do begin
    P:=ListLibraryInterpreters.Items[i];
    if isValidPointer(@P.isValidProc) then begin
      if P.IsValidProc(InterpreterHandle) then begin
        if isValidPointer(@P.CallFunProc) then begin
          Result:=P.CallFunProc(InterpreterHandle,Instance,Args,FunName);
          exit;
        end;
      end;
    end;
  end;
end;

// ----------- AboutMarquee --------------------------

procedure ClearListAboutMarquees;
var
  i: Integer;
  P: PInfoAboutMarquee;
begin
  for i:=ListAboutMarquees.Count-1 downto 0 do begin
    P:=ListAboutMarquees.Items[i];
    FreeAboutMarquee_(THandle(P));
  end;
  ListAboutMarquees.Clear;
end;

function IsValidAboutMarquee_(AboutMarqueeHandle: THandle): Boolean; stdcall;
begin
  Result:=ListAboutMarquees.IndexOf(Pointer(AboutMarqueeHandle))<>-1;
end;

function CreateAboutMarquee_(PCAM: PCreateAboutMarquee): THandle; stdcall;
var
  P: PInfoAboutMarquee;
begin
  Result:=ABOUTMARQUEE_INVALID_HANDLE;
  if not IsValidPointer(PCAM,SizeOf(TCreateAboutMarquee)) then exit;
  New(P);
  FillChar(P^,SizeOf(TInfoAboutMarquee),0);
  P.Text:=PCAM.Text;
  case PCAM.TypeCreate of
    tcLast: ListAboutMarquees.Add(P);
    tcFirst: ListAboutMarquees.Insert(0,P);
  end;
  Result:=THandle(P);
end;

function FreeAboutMarquee_(AboutMarqueeHandle: THandle): Boolean; stdcall;
var
  P: PInfoAboutMarquee;
begin
  Result:=false;
  if not IsValidAboutMarquee_(AboutMarqueeHandle) then exit;
  P:=PInfoAboutMarquee(AboutMarqueeHandle);
  ListAboutMarquees.Remove(P);
  Dispose(P);
  Result:=true;
end;

procedure GetAboutMarquees_(Owner: Pointer; Proc: TGetAboutMarqueeProc); stdcall;
var
  i: Integer;
  P: PInfoAboutMarquee;
  TGAM: TGetAboutMarquee;
begin
  if not IsValidPointer(@Proc) then exit;
  for i:=0 to ListAboutMarquees.Count-1 do begin
    P:=ListAboutMarquees.Items[i];
    FillChar(TGAM,SizeOf(TGetAboutMarquee),0);
    TGAM.Text:=PChar(P.Text);
    Proc(Owner,@TGAM);
  end;
end;

exports
   MainFormKeyDown_ name ConstMainFormKeyDown,
   MainFormKeyUp_ name ConstMainFormKeyUp,
   MainFormKeyPress_ name ConstMainFormKeyPress,
//   GetIniFileName_ name ConstGetIniFileName,
   isPermission_ name ConstisPermission,
   isPermissionSecurity_ name ConstisPermissionSecurity,
   SetSplashStatus_ name ConstSetSplashStatus,
   GetProtocolAndServerName_ name ConstGetProtocolAndServerName,
   GetInfoConnectUser_ name ConstGetInfoConnectUser,
   AddErrorToJournal_ name ConstAddErrorToJournal,
   AddSqlOperationToJournal_ name ConstAddSqlOperationToJournal,
   GetDateTimeFromServer_ name ConstGetDateTimeFromServer,
   GetWorkDate_ name ConstGetWorkDate, 
   ViewEnterPeriod_ name ConstViewEnterPeriod,
   GetOptions_ name ConstGetOptions,
   isPermissionColumn_ name ConstisPermissionColumn,
   GetLibraries_ name ConstGetLibraries,
   TestSplash_ name ConstTestSplash,

   isValidProgressBar_ name ConstisValidProgressBar,
   CreateProgressBar_ name ConstCreateProgressBar,
   FreeProgressBar_ name ConstFreeProgressBar,
   SetProgressBarStatus_ name ConstSetProgressBarStatus,

   CreateToolBar_ name ConstCreateToolBar,
   FreeToolBar_ name ConstFreeToolBar,
   CreateToolButton_ name ConstCreateToolButton,
   FreeToolButton_ name ConstFreeToolButton,
   RefreshToolBars_ name ConstRefreshToolBars,
   RefreshToolBar_ name ConstRefreshToolBar,
   isValidToolBar_ name ConstisValidToolBar,
   isValidToolButton_ name ConstisValidToolButton,

   CreateOption_ name ConstCreateOption,
   FreeOption_ name ConstFreeOption,
   ViewOption_ name ConstViewOption,
   GetOptionParentWindow_ name ConstGetOptionParentWindow,
   isValidOption_ name ConstisValidOption,

   CreateMenu_ name ConstCreateMenu,
   FreeMenu_ name ConstFreeMenu,
   GetMenuHandleFromName_ name ConstGetMenuHandleFromName,
   ViewMenu_ name ConstViewMenu,
   isValidMenu_ name ConstisValidMenu,

   CreateInterface_ name ConstCreateInterface,
   FreeInterface_ name ConstFreeInterface,
   GetInterfaceHandleFromName_ name ConstGetInterfaceHandleFromName,
   ViewInterface_ name ConstViewInterface,
   ViewInterfaceFromName_ name ConstViewInterfaceFromName,
   RefreshInterface_ name ConstRefreshInterface,
   CloseInterface_ name ConstCloseInterface,
   ExecProcInterface_ name ConstExecProcInterface,
   OnVisibleInterface_ name ConstOnVisibleInterface,
   CreatePermissionForInterface_ name ConstCreatePermissionForInterface,
   isPermissionOnInterface_ name ConstisPermissionOnInterface,
   isValidInterface_ name ConstisValidInterface,
   GetInterfaces_ name ConstGetInterfaces,
   GetInterfacePermissions_ name ConstGetInterfacePermissions,
   GetInterface_ name ConstGetInterface, 

   ClearLog_ name ConstClearLog,
   ViewLog_ name ConstViewLog,
   CreateLogItem_ name ConstCreateLogItem,
   FreeLogItem_ name ConstFreeLogItem,
   isValidLogItem_ name ConstisValidLogItem,

   CreateAdditionalLog_ name ConstCreateAdditionalLog, 
   FreeAdditionalLog_ name ConstFreeAdditionalLog, 
   SetParamsToAdditionalLog_ name ConstSetParamsToAdditionalLog, 
   CreateAdditionalLogItem_ name ConstCreateAdditionalLogItem, 
   FreeAdditionalLogItem_ name ConstFreeAdditionalLogItem, 
   isValidAdditionalLog_ name ConstisValidAdditionalLog, 
   isValidAdditionalLogItem_ name ConstisValidAdditionalLogItem,
   ClearAdditionalLog_ name ConstClearAdditionalLog, 
   ViewAdditionalLog_ name ConstViewAdditionalLog,

   isValidDesignPalette_ name ConstisValidDesignPalette,
   isValidDesignPaletteButton_ name ConstisValidDesignPaletteButton,
   CreateDesignPalette_ name ConstCreateDesignPalette,
   CreateDesignPaletteButton_ name ConstCreateDesignPaletteButton,
   FreeDesignPalette_ name ConstFreeDesignPalette,
   FreeDesignPaletteButton_ name ConstFreeDesignPaletteButton,
   GetDesignPalettes_ name ConstGetDesignPalettes,

   isValidDesignPropertyTranslate_ name ConstisValidDesignPropertyTranslate,
   CreateDesignPropertyTranslate_ name ConstCreateDesignPropertyTranslate,
   FreeDesignPropertyTranslate_ name ConstFreeDesignPropertyTranslate,
   GetDesignPropertyTranslates_ name ConstGetDesignPropertyTranslates,

   isValidDesignPropertyRemove_ name ConstisValidDesignPropertyRemove,
   CreateDesignPropertyRemove_ name ConstCreateDesignPropertyRemove,
   FreeDesignPropertyRemove_ name ConstFreeDesignPropertyRemove,
   GetDesignPropertyRemoves_ name ConstGetDesignPropertyRemoves,

   isValidDesignPropertyEditor_ name ConstisValidDesignPropertyEditor,
   CreateDesignPropertyEditor_ name ConstCreateDesignPropertyEditor,
   FreeDesignPropertyEditor_ name ConstFreeDesignPropertyEditor,

   isValidDesignComponentEditor_ name ConstisValidDesignComponentEditor,
   CreateDesignComponentEditor_ name ConstCreateDesignComponentEditor,
   FreeDesignComponentEditor_ name ConstFreeDesignComponentEditor,

   isValidDesignCodeTemplate_ name ConstisValidDesignCodeTemplate,
   CreateDesignCodeTemplate_ name ConstCreateDesignCodeTemplate,
   FreeDesignCodeTemplate_ name ConstFreeDesignCodeTemplate,
   GetDesignCodeTemplates_ name ConstGetDesignCodeTemplates,
   GetDesignCodeTemplateCodeByName_ name ConstGetDesignCodeTemplateCodeByName,

   isValidDesignFormTemplate_ name ConstisValidDesignFormTemplate,
   CreateDesignFormTemplate_ name ConstCreateDesignFormTemplate,
   FreeDesignFormTemplate_ name ConstFreeDesignFormTemplate,
   GetDesignFormTemplates_ name ConstGetDesignFormTemplates,
   GetDesignFormTemplateFormByName_ name ConstGetDesignFormTemplateFormByName,

   isExistsParam_ name ConstisExistsParam,
   WriteParam_ name ConstWriteParam,
   ReadParam_ name ConstReadParam,
   ClearParams_ name ConstClearParams,
   SaveParams_ name ConstSaveParams,
   LoadParams_ name ConstLoadParams,
   EraseParams_ name ConstEraseParams,

   IsValidInterpreterConst_ name ConstIsValidInterpreterConst,
   CreateInterpreterConst_ name ConstCreateInterpreterConst,
   FreeInterpreterConst_ name ConstFreeInterpreterConst,
   GetInterpreterConsts_ name ConstGetInterpreterConsts,

   IsValidInterpreterClass_ name ConstIsValidInterpreterClass,
   CreateInterpreterClass_ name ConstCreateInterpreterClass,
   FreeInterpreterClass_ name ConstFreeInterpreterClass,
   CreateInterpreterClassProperty_ name ConstCreateInterpreterClassProperty,
   FreeInterpreterClassProperty_ name ConstFreeInterpreterClassProperty,
   CreateInterpreterClassMethod_ name ConstCreateInterpreterClassMethod,
   FreeInterpreterClassMethod_ name ConstFreeInterpreterClassMethod,
   GetInterpreterClasses_ name ConstGetInterpreterClasses,

   IsValidInterpreterFun_ name ConstIsValidInterpreterFun,
   CreateInterpreterFun_ name ConstCreateInterpreterFun,
   FreeInterpreterFun_ name ConstFreeInterpreterFun,
   GetInterpreterFuns_ name ConstGetInterpreterFuns,

   IsValidInterpreterEvent_ name ConstIsValidInterpreterEvent,
   CreateInterpreterEvent_ name ConstCreateInterpreterEvent,
   FreeInterpreterEvent_ name ConstFreeInterpreterEvent,
   GetInterpreterEvents_ name ConstGetInterpreterEvents,

   IsValidInterpreterVar_ name ConstIsValidInterpreterVar, 
   CreateInterpreterVar_ name ConstCreateInterpreterVar,
   FreeInterpreterVar_ name ConstFreeInterpreterVar,
   GetInterpreterVars_ name ConstGetInterpreterVars,

   IsValidLibraryInterpreter_ name ConstIsValidLibraryInterpreter,
   CreateLibraryInterpreter_ name ConstCreateLibraryInterpreter,
   FreeLibraryInterpreter_ name ConstFreeLibraryInterpreter,
   GetLibraryInterpreterHandleByGUID_ name ConstGetLibraryInterpreterHandleByGUID,
   GetLibraryInterpreters_ name ConstGetLibraryInterpreters,
   CallLibraryInterpreterFun_ name ConstCallLibraryInterpreterFun,

   CreateAboutMarquee_ name ConstCreateAboutMarquee,
   FreeAboutMarquee_ name ConstFreeAboutMarquee,
   GetAboutMarquees_ name ConstGetAboutMarquees;

initialization
  RegisterClass(TBitBtn);


end.

