unit UMainData;

interface

{$I stbasis.inc}

uses Windows, controls, comctrls, UMainUnited, Sysutils, menus, Classes, IBDatabase, Forms,
     USplash, TsvGauge,graphics, messages, toolwin, typinfo, dsgnintf, inifiles,
     IBSQLMonitor, tsvInterpreterCore, tsvDesignCore, tsvLog, tsvSecurity;


type

  PInfoAboutMarquee=^TInfoAboutMarquee;
  TInfoAboutMarquee=packed record
    Text: string;
  end;

  PInfoLibraryInterpreter=^TInfoLibraryInterpreter;
  TInfoLibraryInterpreter=packed record
    GUID: String;
    Hint: String;
    CreateProc: TCreateInterpreterProc;
    RunProc: TRunInterpreterProc;
    ResetProc: TResetInterpreterProc;
    FreeProc: TFreeInterpreterProc;
    IsValidProc: TIsValidInterpreterProc;
    SetParamsProc: TSetInterpreterParamsProc;
    CallFunProc: TCallInterpreterFunProc;
    GetCreateInterfaceNameProc: TGetCreateInterfaceNameProc;
    GetInterpreterIdentifersProc: TGetInterpreterIdentifersProc;
  end;

  PInfoInterpreterProcParam=^TInfoInterpreterProcParam;
  TInfoInterpreterProcParam=packed record
    ParamText: String;
    ParamType: DWord;
  end;

  PInfoInterpreterClassMethod=^TInfoInterpreterClassMethod;
  TInfoInterpreterClassMethod=packed record
    Identifer: string;
    Proc: TInterpreterReadProc;
    ListProcParams: TList;
    ProcResultType: TInterpreterProcParam;
    Hint: string;
  end;

  PInfoInterpreterClassProperty=^TInfoInterpreterClassProperty;
  TInfoInterpreterClassProperty=packed record
    Identifer: string;
    ReadProc: TInterpreterReadProc;
    ListReadProcParams: TList;
    ReadProcResultType: TInterpreterProcParam;
    WriteProc: TInterpreterWriteProc;
    ListWriteProcParams: TList;
    isIndexProperty: Boolean;
    Hint: string;
  end;

  PInfoInterpreterClass=^TInfoInterpreterClass;
  TInfoInterpreterClass=packed record
    ClassType: TClass;
    Hint: string;
    ListMethods: TList;
    ListProperties: TList;
  end;

  PInfoInterpreterConst=^TInfoInterpreterConst;
  TInfoInterpreterConst=packed record
    Identifer: String;
    Value: Variant;
    TypeInfo: Pointer;
    Hint: string;
  end;

  PInfoInterpreterFun=^TInfoInterpreterFun;
  TInfoInterpreterFun=TInfoInterpreterClassMethod;

  PInfoInterpreterVar=^TInfoInterpreterVar;
  TInfoInterpreterVar=packed record
    Identifer: String;
    Value: Variant;
    TypeValue: Variant;
    TypeText: String;
    Hint: string;
  end;

  PInfoInterpreterEvent=^TInfoInterpreterEvent;
  TInfoInterpreterEvent=packed record
    Identifer: string;
    Hint: string;
    EventClass: TEventClass;
    EventProc: Pointer;
  end;

  PInfoDesignFormTemplate=^TInfoDesignFormTemplate;
  TInfoDesignFormTemplate=packed record
    Name: string;
    Hint: string;
    GetFormProc: TGetDesignFormProc;
  end;

  PInfoDesignCodeTemplate=^TInfoDesignCodeTemplate;
  TInfoDesignCodeTemplate=packed record
    Name: string;
    Hint: string;
    GetCodeProc: TGetDesignCodeProc;
  end;

  PInfoDesignComponentEditor=^TInfoDesignComponentEditor;
  TInfoDesignComponentEditor=packed record
    ComponentClass: TComponentClass;
    ComponentEditor: TComponentEditorClass;
  end;

  PInfoDesignPropertyEditor=^TInfoDesignPropertyEditor;
  TInfoDesignPropertyEditor=packed record
    PropertyType: PTypeInfo;
    ComponentClass: TClass;
    PropertyName: String;
    EditorClass: TPropertyEditorClass;
  end;

  PInfoDesignPropertyRemove=^TInfoDesignPropertyRemove;
  TInfoDesignPropertyRemove=packed record
    Name: PChar;
    Cls: TPersistentClass;
  end;

  PInfoDesignPropertyTranslate=^TInfoDesignPropertyTranslate;
  TInfoDesignPropertyTranslate=packed record
    Real: String;
    Translate: String;
    Cls: TPersistentClass;
  end;

  PInfoLib=^TInfoLib;
  TInfoLib=packed record
    Active: Boolean;
    LibHandle: THandle;
    FileSize: Integer;
    ExeName: String;
    Hint: String;
    RefreshLibrary: TRefreshLibraryProc;
    SetConnection: TSetConnectionProc;
    TypeLib: TTypeLib;
    Programmers: String;
    StopLoad: Boolean;
    Condition: String;
  end;

  PInfoDesignPaletteButton=^TInfoDesignPaletteButton;
  TInfoDesignPaletteButton=packed record
    Hint: String;
    Cls: TPersistentClass;
    Bitmap: TBitmap;
    UseForInterfaces: TSetTypeInterface;
  end;

  PInfoDesignPalette=^TInfoDesignPalette;
  TInfoDesignPalette=packed record
    Name: String;
    Hint: String;
    ListButtons: TList;
  end;

  PInfoAdditionalLogItem=^TInfoAdditionalLogItem;
  TInfoAdditionalLogItem=packed record
    Owner: Pointer;
    LogItemIndex: Integer;
    ImageIndex: Integer;
    TypeAdditionalLogItem: TTypeAdditionalLogItem;
    ViewAdditionalLogItemProc: TViewAdditionalLogItemProc;
  end;

  PInfoAdditionalLog=^TInfoAdditionalLog;
  TInfoAdditionalLog=packed record
    ListChild: TList;
    LogIndex: Integer;
    Limit: Integer;
    ViewAdditionalLogOptionProc: TViewAdditionalLogOptionProc; 
  end;
  
{  PInfoLogItem=^TInfoLogItem;
  TInfoLogItem=packed record
    Text: string;
    TypeLogItem: TTypeLogItem;
    ViewLogItemProc: TViewLogItemProc;
    DateTime: TDateTime;
    ListIndex: Integer;
  end;}

  PUserParams=^TUserParams;
  TUserParams=packed record
    user_name: array[0..128-1] of char;
    name: array[0..DomainNameLength-1] of char;
  end;


  PInfoInterface=^TInfoInterface;
  TInfoInterface=packed record
    Name: string;
    Hint: string;
    ViewInterface: TViewInterfaceProc;
    TypeInterface: TTypeInterface;
    RefreshInterface: TRefreshInterfaceProc;
    Visible: Boolean;
    ViewActionPerm: TStringList;
    AddActionPerm: TStringList;
    ChangeActionPerm: TStringList;
    DeleteActionPerm: TStringList;
    AutoRun: Boolean;
    CloseInterface: TCloseInterfaceProc;
    ExecProcInterface: TExecProcInterfaceProc;
  end;

  TNewMenuItem=class;
  
  PInfoMenu=^TInfoMenu;
  TInfoMenu=packed record
    Name: string;
    Hint: string;
    List: TList;
    Bitmap: TBitmap;
    ShortCut: TShortCut;
    MenuClickProc: TMenuClickProc;
    SelfMenuItem: TNewMenuItem;
    MenuItem: TNewMenuItem;
  end;

  PInfoOption=^TInfoOption;
  TInfoOption=packed record
    Name: string;
    List: TList;
    Bitmap: TBitmap;
    SelfTabSheet: TTabSheet;
    SelfTreeNode: TTreeNode;
    TabSheet: TTabSheet;
    TreeNode: TTreeNode;
    BeforeSetOptionProc: TBeforeSetOptionProc;
    AfterSetOptionProc: TAfterSetOptionProc;
    CheckOptionProc: TCheckOptionProc;
  end;

  TNewToolBar=class;
  TTBMenuItem=class;

  PInfoToolButton=^TInfoToolButton;
  TInfoToolButton=packed record
    Name: string;
    Hint: string;
    ShortCut: TShortCut;
    Bitmap: TBitmap;
    ToolButtonClickProc: TToolButtonClickProc;
    Style: TToolButtonStyleEx;
    Control: TControl;
  end;

  PInfoToolBar=^TInfoToolBar;
  TInfoToolBar=packed record
    Name: string;
    Hint: string;
    Width,Height,Left,Top: Integer;
    Position: TToolBarPosition;
    ShortCut: TShortCut;
    RowCount: Integer;
    Visible: Boolean;
    ZOrder: Integer;
    List: TList;
    SelfToolBar: TNewToolBar;
    SelfImageList: TImageList;
    SelfMenuItem: TMenuItem;
    ToolBar: TNewToolBar;
    ImageList: TImageList;
    MenuItem: TMenuItem;
  end;

  TNewToolButton=class(TToolButton)
    public
      P: PInfoToolButton;
  end;

  TNewToolBar=class(TToolBar)
    private
      procedure CMVisibleChanged(var Message: TMessage); message CM_VISIBLECHANGED;
    public
      isMiClick: Boolean;
      ParentHandle: THandle;
      P: PInfoToolBar;
      mi: TTBMenuItem;
      constructor Create(AOwner: TComponent);override;
      destructor Destroy;override;
      procedure AlignControls(AControl: TControl; var Rect: TRect); override;

  end;

  TTBMenuItem=class(TMenuItem)
    public
      tb: TNewToolBar;
  end;
  
  TTypeSetOptions=(tsoNone,tsoGeneral,tsoDataBase,tsoShortCut,tsoLibrary,
                   tsoConsts,tsoRBooks,tsoDirs);
                   
  TTypeTranslateText=(tttUpper,tttLower,tttRussian,tttEnglish,tttFirstUpper,tttTrimSpaceForOne);
  TTypeHotKeys=(thkNone,thkMenu,thkNewMenu,thkTbMenu,
                thkUpper,thkLower,
                thkRussian,thkEnglish,thkFirstUpper,thkTrimSpaceForOne);
  
  TNewMenuItem=class(TMenuItem)
    public
      P: PInfoMenu;
  end;

  TMenuProgressBar=class(TMenuItem)
    public
//      P: PInfoProgressBarMenu;
  end;

  TNewTsvGauge=class(TTsvGauge)
    public
      PopMenu: TPopupMenu;
  end;  

  PInfoCachePerm=^TInfoCachePerm;
  TInfoCachePerm=packed record
    ObjName: string;
    Operator: string;
    Perm: Boolean;
  end;

  PInfoCachePermColumn=^TInfoCachePermColumn;
  TInfoCachePermColumn=packed record
    ObjName: string;
    ObjColumn: string;
    Operator: string;
    Perm: Boolean;
  end;

  PInfoProgressBar=^TInfoProgressBar;
  TInfoProgressBar=packed record
    Min,Max: Integer;
    Hint: String;
    Color: TColor;
    Gag: TNewtsvGauge;
    PopupMenu: TPopupMenu;
  end;

  PLibraryInfo=^TLibraryInfo;
  TLibraryInfo=packed record
    Active: Boolean;
  end;

  PNodeHotKey=^TNodeHotKey;
  TNodeHotKey=packed record
    TypeHotKey: TTypeHotKeys;
    PData: Pointer;
    tmpShortCut: TShortCut;
  end;

  TTypeCellConst=(tccUnknown,tccDefaultProperty,tccLeaveAbsence,tccRefreshCourseAbsence,
                  tccEmpStaffBoss,tccDefaultCurrency,tccEmpAccount,tccEmpBoss,
                  tccPlant,tccPlantPFRcode,tccIMNScode,tccRoundto,tccEmpPassport,
                  tccTariffCategoryType,tccSalaryCategoryType,tccPieceWorkCategoryType,
                  tccCountry,tccRegion,tccState,tccTown,tccPlaceMent,tccCalcPeriod);

  PInfoCellConst=^TInfoCellConst;
  TInfoCellConst=packed record
    TypeCellConst: TTypeCellConst;
    Value: Variant;
    Hint: String;
  end;

  TMainFormBounds=packed record
    Left,Top,Width,Height: Integer;
    State: TWindowState; 
  end;

  TTSVMemIniFile=class(TMemIniFile)
  public
    constructor Create;
    destructor Destroy; override;
    procedure SaveToStream(Stream: TStream);
    procedure SaveToFile(FileName: string);
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromFile(FileName: string);
  end;

  TComponentFont=class(TComponent)
  private
    FFont: TFont;
    procedure SetFont(Value: TFont);
  public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy; override;
    procedure SetFontFromHexStr(HexStr: string);
    function GetFontAsHexStr: String;
  published
    property Font: TFont read FFont write SetFont;
  end;

 (* TIBDataBaseEx=class(TIBDataBase)
  private
    FConnected: Boolean;
    FDBName: TIBFileName;
    FDBParams: TStrings;
    FLoginPrompt: Boolean;
    FDefaultTransaction: TIBTransaction;
  public
    property Connected: Boolean read FConnected;
    property DatabaseName: TIBFileName read FDBName;
    property Params: TStrings read FDBParams;
    property LoginPrompt: Boolean read FLoginPrompt;
    property DefaultTransaction: TIBTransaction read FDefaultTransaction;
  published
{    property IdleTimer: Integer read GetIdleTimer write SetIdleTimer;
    property SQLDialect : Integer read GetSQLDialect write SetSQLDialect;
    property DBSQLDialect : Integer read FDBSQLDialect;
    property TraceFlags: TTraceFlags read FTraceFlags write FTraceFlags;
    property AllowStreamedConnected : Boolean read FAllowStreamedConnected write FAllowStreamedConnected default true;}
  end;*)

  
var
  MessageID: DWord;

  FSecurity: TtsvSecurity;
  isAppLoaded: Boolean=false;
  MutexHan: THandle;
  MainCaption: String='СТБазис';
  ListLibs: TList;
  MainDataBaseName: string;
  SecurityDataBaseName: string;
  UserName: String;
  UserPass: string;
  UserId: Integer;
  AppId: Integer;
  AppName: string;
  SqlUserName: string;
  SqlRole: string;
  EmpName: string;
  Emp_id: Integer;
  SQLMonitor: TIBSQLMonitor;
  IBDB: TIBDataBase;
  IBT: TIBTransaction;
  IBDBLogin: TIBDataBase;
  IBTLogin: TIBTransaction;
  TempStr: String;
  ListDialogClasses: TStringList;
  fmSplash: TfmSplash;
  ListCachePermission: TList;
  ListCachePermissionColumn: TList;
  ListProgressBars: TList;
  ListOptions: TList;
  ListErrorClasses: TStringList;
  ListToolBars: TList;
  ListToolBarsMain: TList;
  ListMenus: TList;
  ListMenusMain: TList;
  ListInterfaces: TList;
  ListAdditionalLogs: TList;
  ListDesignPalettes: TList;
  ListDesignPropertyTranslates: TList;
  ListDesignPropertyRemoves: TList;
  ListDesignPropertyEditors: TList;
  ListDesignComponentEditors: TList;
  ListDesignCodeTemplates: TList;
  ListDesignFormTemplates: TList;
  ListInterpreterConsts: TList;
  ListInterpreterClasses: TList;
  ListInterpreterFuns: TList;
  ListInterpreterEvents: TList;
  ListInterpreterVars: TList;
  ListLibraryInterpreters: TList;
  ListAboutMarquees: TList;
  ListRunInterfaces: TStringList;
  ListTempLogItems: TStringList;
  MemIniFile: TTSVMemIniFile;
  MnOption: TMainOption;
  RBTableFont: TFont;
  FormFont: TFont;
  TempDir: String;
  LogFileName: String;
  MainLog: TLog;
  VisibleLog: Boolean;
  CheckMoreApplications: Boolean=true;

  isLastOpen: Boolean=true;
  isViewSplash: Boolean=true;
  isMaximizedMainWindow: Boolean=true;
  isRefreshEntyes: Boolean=false;
  isRebootProgram: Boolean=false;
  isLogChecked: array[0..3] of Boolean;
  isLogShowDateTime: Boolean;
  isVisibleSplash: Boolean=true;
  isVisibleSplashVerison: Boolean=true;
  isVisibleSplashStatus: Boolean=true;


  // Switches
  SwitchNewConnect: string='/newconnect';
  SwitchNoOptions: string='/nooptions';
  SwitchPathFile: string='/pathfile';
  SwitchPackFile: string='/packfile';
  SwitchInclination: String='/inclination';
  SwitchRuncount: String='/runcount';
  SwitchUpdateServer: String='/updateserver';

  isSwitchNewConnect: Boolean=false;
  isSwitchNoOptions: Boolean=false;
  isSwitchPathFile: Boolean=false;
  isSwitchPackFile: Boolean=false;
  isSwitchInclination: Boolean=false;
  isSwitchRuncount: Boolean=false;
  isSwitchUpdateServer: Boolean=false;

  SwitchPathFileParam1: string;
  SwitchPackFileParam1: string;
  SwitchUpdateServerParam1: string;
  SwitchUpdateServerParam2: string;
  SwitchUpdateServerParam3: string;


  // Hot Keys
  HotKeyUpperCase: TShortCut;
  HotKeyLowerCase: TShortCut;
  HotKeyToRussian: TShortCut;
  HotKeyToEnglish: TShortCut;
  HotKeyFirstUpperCase: TShortCut;
  HotKeyTrimSpaceForOne: TShortCut;
  tmpBounds: TMainFormBounds;


  // Handles

  hToolBarStandart: THandle;

  hToolButtonFileRefresh: THandle;
  hToolButtonFileLogin: THandle;
  hToolButtonViewLog: Thandle;
  hToolButtonConst: THandle;
  hToolButtonServiceChangePassword: THandle;
  hToolButtonServiceOptions: THandle;
  hToolButtonWindowsLast: Thandle;
  hToolButtonWindowsCascade: THandle;
  hToolButtonWindowsVert: THandle;
  hToolButtonWindowsGoriz: THandle;
  hToolButtonWindowsCloseAll: THandle;
  hToolButtonHelpAbout: THandle;

  hMenuFile: THandle;
  hMenuFileRefresh: THandle;
  hMenuFileLogin: THandle;
  hMenuFileExit: THandle;
  hMenuEdit: THandle;
  hMenuView: THandle;
  hMenuViewLog: THandle;
  hMenuViewToolBars: THandle;
  hMenuRBooks: THandle;
  hMenuReports: THandle;
  hMenuDocums: THandle;
  hMenuOperations: THandle;
  hMenuService: THandle;
  hMenuConst: THandle;
  hMenuQuery: Thandle;
  hMenuServiceBCP: THandle;
  hMenuServiceChangePassword: THandle;
  hMenuServiceOptions: THandle;
  hMenuWindows: THandle;
  hMenuWindowsLast: THandle;
  hMenuWindowsCascade: THandle;
  hMenuWindowsVert: THandle;
  hMenuWindowsGoriz: THandle;
  hMenuWindowsMinAll: THandle;
  hMenuWindowsResAll: THandle;
  hMenuWindowsCloseAll: THandle;
  hMenuHelp: THandle;
  hMenuHelpAbout: THandle;

  hOptionGeneral: THandle;
  hOptionDataBase: THandle;
  hOptionDirs: THandle;
  hOptionShortCut: THandle;
  hOptionLibrary: THandle;
  hOptionConst: THandle;
  hOptionRBooks: THandle;
  hOptionLog: THandle;
  hOptionSqlMonitor: THandle;
  hOptionInterfaces: THandle;
  hOptionVisual: THandle;
  hOptionLast: Thandle;

  hInterfaceConst: THandle;
  hInterfaceQuery: THandle;
  hInterfaceLast: THandle;

  hAdditionalLogMain: THandle;
  hAdditionalLogSqlMonitor: THandle;
  hAdditionalLogLast: THandle;

  hAboutUseLibsAndProgrammers: THandle;
  
  CurrentHandle: THandle=0;


const

  // db Objects
  tbConsts='const';
  tbConstEx='constex';
  tbUserApp='usersapp';
  tbApp='app';
  tbSysUser_Privileges='rdb$user_privileges';
  tbSysRelations='rdb$relations';
  tbSysRelation_fields='rdb$relation_fields';
  tbAppPermColumn='apppermcolumn';
  tbUsersEmp='usersemp';
  tbEmp='emp';
  tbUsers='users';
  tbUserOptions='useroptions';
  tbJournalError='journalerror';
  tbJournalSqlOperation='journalsqloperation';
  tbProperty='property';
  tbAbsence='absence';
  tbCurrency='currency';
  tbPlant='plant';
  tbPersonDocType='PersonDocType';
  tbCategoryType='categorytype';
  tbCountry='country';
  tbState='state';
  tbRegion='region';
  tbTown='town';
  tbPlaceMent='placement';
  tbCalcPeriod='calcperiod';


const
  ConstHotKeyUpperCase=100;
  ConstHotKeyLowerCase=101;
  ConstHotKeyToRussian=102;
  ConstHotKeyToEnglish=103;
  ConstHotKeyFirstUpperCase=104;
  ConstHotKeyTrimSpaceForOne=105;



const
  CompanyName='© NextSoft 2000-2007. Все права защищены.';
  CompanyTel='т.8-3912-932332, www.nextsoft.ru, stbasis@nextsoft.ru';
  CompanyWeb='http://www.nextsoft.ru';

const

  STBasisMutex='STBasisMutex';
  STBasisMutexLoadDll='STBasisMutexLoadDll';
  STBasisMutexUpdateNeedLibSecurity='STBasisMutexUpdateNeedLibSecurity';
  ConstApplicationExists='Приложение <%s> уже запущено,'+#13+'запустить еще копию ?';
  ConstInterbaseNotExists='Установите Interbase Client.';
  ConstSplashStatusServerSearch='Поиск сервера ...';
  ConstSplashStatusServerConnect='Соединение с сервером ...';
  ConstSplashStatusLoginToProgramm='Идентификация ...';
  ConstSplashStatusLoading='Загрузка ...';
  ConstSplashStatusUnloading='Выгрузка ...';
  ConstEmptyTemDir='Очистка временной директории ...';
  ConstSaveDataIni='Сохранение настроек ...';
  ConstGenerateMenu='Создание меню ...';
  ConstGenerateToolBar='Создание панелей инструментов ...';
  ConstGenerateOption='Создание настроек ...';
  ConstOpenLastEntry='Почти все готово ...';
  ConstMenuOptionsName='&Настройка';
  ConstMenuOptionsHint='Настройки программы';
  ConstMenuOptionsHintImageIndex=46;
  ConstMenuChangePasswordName='&Смена пароля';
  ConstMenuChangePasswordHint='Сменить пароль текущего пользователя';
  ConstMenuChangePasswordImageIndex=66;
  ConstSelectDir='Выберите директорию';
  ConstCheckPermission='Проверка прав';
  ConstEmptyDir='Очистка временной директории';


  ConstHintHidePause=4000;
  ConstSectionMain='Main';
  ConstSectionLastOpen='LastOpen';
  ConstSectionLibraryActive='LibraryActive';
  ConstSectionHotKey='HotKey';
  ConstSectionOptions='Main Options';
  ConstSectionLogin='Login';
  ConstSectionIfaces='Interfaces';

  ConstToolBar='tb';
  ConstSectionLog='Program Log';
  ConstLogItemCaptionWidth=92;
  ConstCaptionMainLog='Основной';

  LayoutRussian='00000419';
  LayoutEnglish='00000409';

  ConstOptionGeneral='Общие';
  ConstOptionDataBase='База данных';
  ConstOptionShortCut='Горячие клавиши';
  ConstOptionAny='Разное';
  ConstOptionLibrary='Библиотеки';
  ConstOptionDirs='Директории';
  ConstOptionLog='Лог сообщений';
  ConstOptionSqlMonitor='SQL монитор';
  ConstOptionInterfaces='Интерфейсы';
  ConstOptionVisual='Визуальные';

  ConstMainLogHint='Лог, предназначенный для регистрации основный сообщений';
  ConstAdditionalLogSQLMonitorHint='SQL монитор';

  ConstAdditionalLogSqlMonitor=ConstOptionSqlMonitor;
  ConstSQLMonitorCommandUnknown='Unknown';

  ConstMenuGroupToolBar=1;


  ConstColorFilter=clRed;
  ConstColorFocused=clInfoBk;
  ConstColorLabelFocused=clRed;



  /// ImageIndex
  ConstImageIndexQuestion=72;

  // File Extension
  ConstExtModules='*.dll';

  // names

  NameRbkConst='Справочник констант';
  NameRbkQuery='Запрос';
  NameRbkProperty='Справочник групп сотрудников';
  NameRbkAbsence='Справочник видов неявок';
  NameRbkEmp='Справочник сотрудников';
  NameRbkCurrency='Справочник валют';
  NameRbkPlant='Справочник контрагентов';
  NameRbkPersonDocType='Справочник видов документов удостоверяющих личность';
  NameRbkCategoryType='Справочник типов категорий';
  NameRbkCountry='Справочник стран';
  NameRbkRegion='Справочник краев и областей';
  NameRbkTown='Справочник городов';
  NameRbkState='Справочник районов';
  NameRbkPlacement='Справочник населённых пунктов';
  NameRbkCalcPeriod='Расчетные периоды';

  // SQL
  SQLRbkConst='Select * from '+tbConstEx;

  // Formats

  fmtDateTimeLog='hh:nn:ss dd.mm.yyyy';
  fmtLog='%s: %s';
  fmtErrorMessage='Программа совершила критичную ошибку <%s>, продолжить работу ?';
  fmtInterfaceAlreadyExists='Интерфейс <%s> уже существует.';
  fmtInterfaceNotfound='Интерфейс <%s> не найден.';
  fmtInterfaceHandleNotfound='Интерфейс <%d> не найден.';
  fmtInterfaceViewProcIsBad='Функция вызова интерфейса <%s> неверна.';
  fmtInterfaceViewProcSuccess='Вызов интерфейса <%s> прошел успешно.';
  fmtInterfaceViewProcBegin='Вызов интерфейса <%s>.';
  fmtInterfaceRefreshProcIsBad='Функция обновления интерфейса <%s> неверна.';
  fmtInterfaceCloseProcIsBad='Функция закрытия интерфейса <%s> неверна.';
  fmtInterfaceCloseProcSuccess='Закрытие интерфейса <%s> прошло успешно.';
  fmtInterfaceExecProcProcIsBad='Функция выполнения процедуры интерфейса <%s> неверна.';
  fmtInterfaceExecProcSuccess='Выполнение процедуры интерфейса <%s> прошло успешно.';
  fmtInterfaceExecProcBegin='Выполнение процедуры интерфейса <%s>.';
  fmtInterfacePermission='%s: %s';
  fmtLibraryInterpreterAlreadyExists='Интерпретатор <%s> уже существует.';
  fmtCheckPerm='Проверка прав <%s> на <%s>';
  fmtCheckPermInterfaceSuccess='Проверка прав <%s> на <%s> (объект: %s оператор: %s) прошло успешно.';
  fmtCheckPermInterfaceFailed='Проверка прав <%s> на <%s> (объект: %s оператор: %s) прошло с ошибкой: право не доступно.';
  fmtCreateMenuError='Ошибка создания меню <%s>: %s';
  fmtCreateToolBarError='Ошибка создания панели инструментов <%s>: %s';
  fmtCreateToolButtonError='Ошибка создания кнопки панели инструментов <%s>: %s';
  fmtLoadingLibrarySuccess='Загрузка библиотеки %s прошла успешно.';
  fmtStartLoadLibrary='Начало загрузки библиотеки %s ...';
  fmtLoadingLibraryFailed='Загрузка библиотеки %s не произошло.';

  SRebootProgram='Изменения вступять только после перезапуска программы. Закрыть программу?';
  
  // Default ext

  dfeXML='.xml';
  dfePrm='.prm';
  dfeLog='.log';

  // Filters

  fltXML='Файлы XML (*.xml)|*.xml';
  fltParams='Файлы настроек (*.prm)|*.prm';
  fltLog='Файлы лога (*.log)|*.log';

  // Field Size

  UserOptionsFieldSectionSize=35;
  UserOptionsFieldParamSize=35;

  ReaderBuffer=4096;
  WriterBuffer=ReaderBuffer;

  // About Marquees
  
  ConstAboutMarqueeWarning='Внимание!'+
                            #13+'Данная программа защищена '+
                            #13+'законами об авторских правах'+
                            #13+'и международными соглашениями.'+
                            #13+'Незаконное воспроизведение или '+
                            #13+'распространение данной программы'+
                            #13+'или любой её части влечет'+
                            #13+'гражданскую и уголовную ответственность.';

   // SQL
   SGrantToPublic='grant select, update, insert, delete on USERS to PUBLIC';                            

implementation

{ TNewToolBar }

constructor TNewToolBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  isMiClick:=true;
  Flat:=true;
  AutoSize:=true;
  DragKind:=dkDock;
  DragMode:=dmAutomatic;
  EdgeBorders:=[];
end;

destructor TNewToolBar.Destroy;
begin
  inherited Destroy;
end;

procedure TNewToolBar.CMVisibleChanged(var Message: TMessage);
begin
  if isMiClick then
   if mi<>nil then
    if Assigned(mi.OnClick) then
      mi.OnClick(mi);
  inherited;
end;

procedure TNewToolBar.AlignControls(AControl: TControl; var Rect: TRect);
begin
  inherited;
end;

{ TTSVMemIniFile }

constructor TTSVMemIniFile.Create;
begin
  inherited Create('');
end;

destructor TTSVMemIniFile.Destroy;
begin
  inherited Destroy;
end;

procedure TTSVMemIniFile.SaveToStream(Stream: TStream);
var
  List: TStringList;
begin
  List := TStringList.Create;
  try
    GetStrings(List);
    List.SaveToStream(Stream);
  finally
    List.Free;
  end;
end;

procedure TTSVMemIniFile.SaveToFile(FileName: string);
var
  fs: TFileStream;
begin
  fs:=nil;
  try
    fs:=TFileStream.Create(FileName,fmCreate);
    SaveToStream(fs);
  finally
    fs.Free;
  end;
end;

procedure TTSVMemIniFile.LoadFromStream(Stream: TStream);
var
  List: TStringList;
begin
  List := TStringList.Create;
  try
    List.LoadFromStream(Stream);
    SetStrings(List);
  finally
    List.Free;
  end;
end;

procedure TTSVMemIniFile.LoadFromFile(FileName: string);
var
  fs: TFileStream;
begin
  fs:=nil;
  try
    fs:=TFileStream.Create(FileName,fmOpenRead);
    LoadFromStream(fs);
  finally
    fs.Free;
  end;
end;


{ TComponentFont }

constructor TComponentFont.Create(AOwner: TComponent);
begin
  inHerited Create(AOwner);
  FFont:=TFont.Create;
end;

destructor TComponentFont.Destroy;
begin
  FFont.Free;
  inherited;
end;

procedure TComponentFont.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TComponentFont.SetFontFromHexStr(HexStr: string);
var
  Realstr: string;
  ms: TMemoryStream;
begin
  ms:=TMemoryStream.Create;
  try
    Realstr:=HexStrToStr(HexStr);
    try
      ms.SetSize(Length(Realstr));
      Move(Pointer(Realstr)^,ms.Memory^,ms.Size);
      ms.Position:=0;
      ms.ReadComponent(Self);
    except
    end;
  finally
    ms.Free;
  end;
end;

function TComponentFont.GetFontAsHexStr: String;
var
  ms: TMemoryStream;
  tmps: string;
begin
  ms:=TMemoryStream.Create;
  try
    ms.WriteComponent(Self);
    SetLength(tmps,ms.Size);
    Move(ms.Memory^,Pointer(tmps)^,ms.Size);
    tmps:=StrToHexStr(tmps);
    Result:=tmps;
  finally
    ms.Free;
  end;
end;



end.
