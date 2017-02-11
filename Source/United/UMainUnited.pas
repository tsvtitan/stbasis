unit UMainUnited;

interface

{$I stbasis.inc}

uses Classes, forms, IBDatabase, Windows, stdctrls, IBQuery, graphics, sysutils, controls,
     IBServices, db, dbgrids, comctrls, typinfo, dsgnintf, dialogs, buttons;

//**********************************************************
//******** consts, types, procedure, function  *************
//**********************************************************

type
  TSetOfChar=set of char;

const
  PROGRESSBAR_INVALID_HANDLE=0;
  TOOLBAR_INVALID_HANDLE=0;
  TOOLBUTTON_INVALID_HANDLE=0;
  OPTION_INVALID_HANDLE=0;
  OPTION_INVALID_PARENTWINDOW=0;
  OPTION_ROOT_HANDLE=$FFFFFFFF;
  MENU_INVALID_HANDLE=0;
  MENU_ROOT_HANDLE=$FFFFFFFF;
  INTERFACE_INVALID_HANDLE=0;
  LOGITEM_INVALID_HANDLE=0;
  ADDITIONALLOG_INVALID_HANDLE=0;
  ADDITIONALLOGITEM_INVALID_HANDLE=0;
  ABOUTMARQUEE_INVALID_HANDLE=0;

const
  MainExe='stbasis.exe';

  // Cursor Consts;

  crSizeLR=crSizeWE;
  crSizeTB=crSizeWE;

  // Domain Consts

  ConstSrvName=256;

  DomainNameLength=100;
  DomainShortNameLength=30;
  DomainSmallNameLength=DomainShortNameLength;
  DomainDBObjectName=128;
  DomainNoteLength=255;
  DomainIntegerLength=9;
  DomainNameBik=9;
  DomainNameAccount=20;
  DomainNameMoney=18;
  DomainMoneySize=2;
  DomainMoneyPrecision=15;
  DomainINNLength=12;
  DomainPlantINNLength=10;
  DomainPlantOkonh=5;
  DomainPlantOkpo=8;
  DomainBuhAccountLength=10;
  DomainSqlLength=2000;
  DomainVariant=2000;

//*******Новые админ. тер. единицы
  DomainATICodeLength=11;
  DomainATINameLength=40;
  DomainATISocrLength=10;
  DomainATIGNINMBLength=4;
  DomainATIPostIndexLength=6;
  DomainCountryNameLength=45;
  DomainCountryName1Length=250;
  LengthWhereStr=250;
  CalcSalaryPeriodStep=1; // расчет зарплаты за период 1 месяц
  CalcSalaryAbsenceId=11; // ид неявки часы работы

  ViewCountText='Всего выбрано: ';
  ViewCountTextDocument='Всего по документу: ';

  CaptionAdd='Добавить';
  CaptionDelete='Удалить';
  CaptionChange='Изменить';
  CaptionFilter='Фильтр';
  CaptionView='Подробнее';
  CaptionClose='Закрыть';
  CaptionCancel='Отмена';
  CaptionClear='Очистить';
  CaptionApply='Применить';

  ConstWarning='Предупреждение';
  ConstError='Ошибка';
  ConstQuestion='Подтверждение';
  ConstInformation='Информация';
  ConstFieldNoEmpty='Укажите значение в поле <%s>.';
  ConstFieldEmpty='Поле <%s> должно быть пустым.';
  ConstFieldLengthInvalid='Поле <%s> должно быть %d символов.';
  ConstFieldFormatInvalid='Значение поля <%s> имеет неверный формат.';
  ConstSqlExecute='Обработка запроса ...';
  ConstReportExecute='Формирование отчета ...';
  ConstExcelNotFound='Установите MS Excel.';
  ConstWordNotFound='Установите MS Word.';
  ConstAppTerminate='Сбой работы приложения';
  ConstEditRbAddCloseQuery='Отменить ввод данных ?';
  ConstEditRbChangeCloseQuery='Отменить сделанные изменения ?';
  ConstDocCheckDataFill='Данные по документу не заполнены, продолжить ?';

  ConstSelect='Просмотр';
  ConstInsert='Вставка';
  ConstUpdate='Изменение';
  ConstDelete='Удаление';
  ConstExecute='Запуск';

  SelConst='S';
  DelConst='D';
  UpdConst='U';
  InsConst='I';
  RefConst='R';
  ExecConst='X';
  MigrateConst='M';

{  ConstDBNavigatorWidth=60;
  ConstDBNavigatorHeight=20;}

  ConstMainFormKeyDown='MainFormKeyDown';
  ConstMainFormKeyUp='MainFormKeyUp';
  ConstMainFormKeyPress='MainFormKeyPress';
//  ConstGetIniFileName='GetIniFileName';
  ConstisPermission='isPermission';
  ConstisPermissionSecurity='isPermissionSecurity';
  ConstGetInfoLibrary='GetInfoLibrary';
  ConstGetListEntryRoot='GetListEntryRoot';
  ConstViewEntry='ViewEntry';
  ConstRefreshLibrary='RefreshLibrary';
  ConstSetAppAndScreen='SetAppAndScreen';
  ConstSetConnection='SetConnection';
  ConstSetSplashStatus='SetSplashStatus';
  ConstGetProtocolAndServerName='GetProtocolAndServerName';
  ConstGetInfoConnectUser='GetInfoConnectUser';
  ConstViewEntryFromMain='ViewEntryFromMain';
  ConstAddErrorToJournal='AddErrorToJournal';
  ConstAddSqlOperationToJournal='AddSqlOperationToJournal';
  ConstGetDateTimeFromServer='GetDateTimeFromServer';
  ConstGetWorkDate='GetWorkDate';
  ConstBeforeSetOptions='BeforeSetOptions';
  ConstAfterSetOptions='AfterSetOptions';
  ConstGetListOptionsRoot='GetListOptionsRoot';
  ConstViewEnterPeriod='ViewEnterPeriod';
//  ConstRemoveFromLastOpenEntryes='RemoveFromLastOpenEntryes';
  ConstGetOptions='GetOptions';
  ConstisPermissionColumn='isPermissionColumn';
  ConstGetLibraries='GetLibraries';
  ConstGetInfoInterpreterLibrary='GetInfoInterpreterLibrary';
  ConstGetInfoComponentsLibrary='GetInfoComponentsLibrary';
  ConstTestSplash='TestSplash';
  ConstInitAll='InitAll';
  ConstisValidProgressBar='isValidProgressBar';
  ConstCreateProgressBar='CreateProgressBar';
  ConstFreeProgressBar='FreeProgressBar';
  ConstSetProgressBarStatus='SetProgressBarStatus';
  ConstCreateToolBar='CreateToolBar';
  ConstFreeToolBar='FreeToolBar';
  ConstCreateToolButton='CreateToolButton';
  ConstFreeToolButton='FreeToolButton';
  ConstRefreshToolBars='RefreshToolBars';
  ConstRefreshToolBar='RefreshToolBar';
  ConstisValidToolBar='isValidToolBar';
  ConstisValidToolButton='isValidToolButton';
  ConstCreateOption='CreateOption';
  ConstFreeOption='FreeOption';
  ConstViewOption='ViewOption';
  ConstGetOptionParentWindow='GetOptionParentWindow';
  ConstisValidOption='isValidOption';
  ConstCreateMenu='CreateMenu';
  ConstFreeMenu='FreeMenu';
  ConstGetMenuHandleFromName='GetMenuHandleFromName';
  ConstViewMenu='ViewMenu';
  ConstisValidMenu='isValidMenu';
  ConstCreateInterface='CreateInterface';
  ConstFreeInterface='FreeInterface';
  ConstGetInterfaceHandleFromName='GetInterfaceHandleFromName';
  ConstViewInterface='ViewInterface';
  ConstViewInterfaceFromName='ViewInterfaceFromName';
  ConstRefreshInterface='RefreshInterface';
  ConstCloseInterface='CloseInterface';
  ConstExecProcInterface='ExecProcInterface';
  ConstOnVisibleInterface='OnVisibleInterface';
  ConstCreatePermissionForInterface='CreatePermissionForInterface';
  ConstisPermissionOnInterface='isPermissionOnInterface';
  ConstisValidInterface='isValidInterface';
  ConstGetInterfaces='GetInterfaces';
  ConstGetInterfacePermissions='GetInterfacePermissions';
  ConstGetInterface='GetInterface';
  ConstClearLog='ClearLog';
  ConstViewLog='ViewLog';
  ConstCreateLogItem='CreateLogItem';
  ConstFreeLogItem='FreeLogItem';
  ConstisValidLogItem='isValidLogItem';
  ConstCreateAdditionalLog='CreateAdditionalLog';
  ConstFreeAdditionalLog='FreeAdditionalLog';
  ConstSetParamsToAdditionalLog='SetParamsToAdditionalLog';
  ConstCreateAdditionalLogItem='CreateAdditionalLogItem';
  ConstFreeAdditionalLogItem='FreeAdditionalLogItem';
  ConstisValidAdditionalLog='isValidAdditionalLog';
  ConstisValidAdditionalLogItem='isValidAdditionalLogItem';
  ConstClearAdditionalLog='ClearAdditionalLog';
  ConstViewAdditionalLog='ViewAdditionalLog';
  ConstisExistsParam='isExistsParam';
  ConstWriteParam='WriteParam';
  ConstReadParam='ReadParam';
  ConstClearParams='ClearParams';
  ConstSaveParams='SaveParams';
  ConstLoadParams='LoadParams';
  ConstEraseParams='EraseParams';
  ConstCreateAboutMarquee='CreateAboutMarquee';
  ConstFreeAboutMarquee='FreeAboutMarquee';
  ConstGetAboutMarquees='GetAboutMarquees';


  DefaultTransactionParamsTwo='read_committed'+#13+
                              'rec_version'+#13+
                              'nowait';
  DefaultTransactionParamsThree='read'+#13+
                                'consistency';


  // Ole consts
  ConstExcelOle='Excel.Sheet';
  ConstWordOle='Word.Application';
  ConstMesOperationInaccessible='Операция недоступна';
  ConstMesCallingWasDeclined='Вызов был отклонен';


  ConstConnectUserName='connect';
  ConstConnectUserPass='$connect$';
  ConstCodePagePlus='WIN1251';
  ConstCodePage='lc_ctype='+ConstCodePagePlus;

  ConstApplicationName='Application';
  ConstScreenName='Screen';
  ConstMainDataBaseName='MainDataBase';
  ConstMainTransactionName='MainTransaction';

  // Menu Consts
  ConstsMenuSeparator='-';
  ConstsMenuFile='Файл';
  ConstsMenuView='Вид';
  ConstsMenuEdit='Правка';
  ConstsMenuData='Данные';
  ConstsMenuRBooks='Справочники';
  ConstsMenuOperations='Операции';
  ConstsMenuDocums='Документы';
  ConstsMenuJournals='Журналы';
  ConstsMenuReports='Отчеты';
  ConstsMenuService='Сервис';
  ConstsMenuWindows='Окна';
  ConstsMenuHelp='Помощь';

  ConstsMenuStaff='Кадровые справочники';
  ConstsMenuRptStaff='Кадровые отчеты';
  ConstsMenuRptSalary='Отчеты по зарплате';
  ConstsMenuMilitary='Воинский учет';
  ConstsMenuEducation='Образование';
  ConstsMenuAny='Разное';
  ConstsMenuATE='Административно-территориальные единицы';
  ConstsMenuFinances='Финансы';
  ConstsMenuOtiz='ОТиЗ';
  ConstsMenuTime='Учёт рабочего времени';
  ConstsMenuSalary='Зарплата';
  ConstsMenuSheet='Ведомости';
  ConstsMenuStore='Склад';
  ConstsMenuOTBetweenCalculate='Межрасчётные операции';
  ConstsMenuTaxes='Налоги';
  ConstsMenuDocTurn='Документооборот';
  ConstsMenuTune='Настройки';

  // Option Consts
  ConstOptionLeft=-1000;
  ConstOptionTop=-1000;
  ConstOptionWidth=416;
  ConstOptionHeight=352;
  ConstOptionMinWidth=200;
  ConstOptionMinHeight=200;
  ConstOptionRBooks='Справочники';
  ConstOptionOperations='Операции';
  ConstOptionReports='Отчеты';
  ConstOptionSalary='Расчёт зар. платы';


  // Format

  fmtTableNoRecord='Таблица %s не содержит записей.';



  // ?????????????????/
  NameBetweenCalcSheet='Ведомости по межрассчтеным операциям';
  NameAvansSheet='Ведомости по авансовым выплатам';
  NameSalarySheet='Ведомости зарплаты';


  //Added by Volkov
  msgNoDataForView='Нет данных для отображения.';
  msgCalendarNotExist='Указанный календарь не существует.';
  //ConstFieldNoEmpty

// Procedures and functions

function ShowError(Handle: THandle; Mess: String): Integer;
function ShowErrorQuestion(Handle: THandle; Mess: String): Integer;
function ShowWarning(Handle: THandle; Mess: String): Integer;
function ShowInfo(Handle: THandle; Mess: String): Integer;
function ShowQuestion(Handle: THandle; Mess: String): Integer;
// by Bespalov
function DeleteWarning(Handle: THandle; Mess: String): Integer;

function ShowErrorEx(Mess: String): Integer;
function ShowWarningEx(Mess: String): Integer;
function ShowInfoEx(Mess: String): Integer;
function ShowQuestionEx(Mess: String): Integer;
function ShowYesNoCancelEx(Mess: String): Integer;
function ShowErrorQuestionEx(Mess: String): Integer;
function DeleteWarningEx(Mess: String): Integer;

function GetRecordCount(qr: TIBQuery; Fetch: Boolean=false): Integer;
function GetGenIdByName(DB: TIBDataBase; Name: string; Increment: Integer): Integer;
procedure SetGenIdByName(DB: TIBDataBase; Name: string; Value: Integer);
function GetGenId(DB: TIBDataBase; TableName: string; Increment: Word): Longword;
function TranslateIBError(Message: string): string;

//Added by Volkov
procedure ChangeDataBase(Owner:TComponent;DB:TIBDatabase);
function StringToHexStr(S:String):String;
function HexStrToString(S:String):String;
procedure SetSelectedRowParams(var AFont:TFont;var ABackground:TColor);
procedure SetSelectedColParams(var AFont:TFont;var ABackground:TColor);
procedure SetMinColumnsWidth(Columns: TDBGridColumns);

procedure ClearFields(wt: TWinControl);
function isFloat(const Value: string): Boolean;
function isInteger(const Value: string): Boolean;
function isDate(const Value: string): Boolean;
function isTime(const Value: string): Boolean;
function isDateTime(const Value: string): Boolean;
function ChangeChar(Value: string; chOld, chNew: char): string;
function ChangeString(Value: string; strOld, strNew: string): string;
function StrBetween(InStr: String; S1,S2: string): String;
function GetStrFromCondition(isNotEmpty: Boolean; STrue,SFalse: string): string;
function FieldToVariant(Field: TField): OleVariant;
function TranslateSqlOperator(Operator: String): string;
procedure AssignFont(inFont,outFont: TFont);
procedure CloseAllSql(Owner: TComponent);
function IsValidPointer(P: Pointer; Size: Integer=0): Boolean;
procedure HandleNeededToWinControl(wt: TWinControl);
function StrToHexStr(S:String):String;
function HexStrToStr(S:String):String;
procedure SetProperties(wt: TWinControl);
function PrepearWhereString(WhereString: String): string;
function PrepearWhereStringNoRemoved(WhereString: String): string;
function PrepearOrderString(OrderString: String): string;
function Iff(isTrue: Boolean; TrueValue, FalseValue: Variant): Variant;
procedure WriteParam(const Section,Param: String; Value: Variant);
function ReadParam(const Section,Param: String; Default: Variant): Variant;
function isValidKey(Key: Char): Boolean;
function isValidIntegerKey(Key: Char): Boolean;
function RepeatStr(const S: string; const Count: Int64): string;
function GetDllName: string;
function GetColumnByFieldName(Columns: TDBGridColumns; FieldName: string): TColumn;
function GetUniqueFileName(const Path: string=''; const Ext: String=''): string;
function GetLabelByWinControl(WinControl: TWinControl): TLabel;
function GetRusNameByElementClass(ElementClass: TClass): string;

procedure AddEnglishToWords(AWords: TStringList);
function WordReplace(const S, OldPattern, NewPattern: string; Flags: TReplaceFlags; WordDelim: TSetOfChar): string;
procedure FillWordsByString(S: string; str: TStringList);
function GetFilterString(Str: TStringList; Operator: String): String;
procedure GetDirFiles(Dir: String; FileDirs: TStringList; OnlyFiles, StopFirst: Boolean);

type
  TConvertType=(ctRussian,ctEnglish);

function ConvertExtended(InStr: string; ConvertType: TConvertType): string;


function GetFirstWord(s: string; SetOfChar: TSetOfChar; var Pos: Integer): string;
function GetNextWord(s: string; SetOfChar: TSetOfChar; var Pos: Integer): string;
function GetPrevWord(s: string; SetOfChar: TSetOfChar; var Pos: Integer): string;

/// Need

function GetCurCalcPeriodID(DB : TIBDatabase) : Integer;//Функция получения ID текущего периода


// Types and records
type
   


   THackWinControl=class(TWinControl)
   public
   end;

  IAdditionalForm=interface
  end;

  IAdditionalRBForm=interface(IAdditionalForm)
  end;

  IAdditionalRBEditForm=interface(IAdditionalForm)
  end;

  IAdditionalRptForm=interface(IAdditionalForm)
  end;

  IAdditionalJRForm=interface(IAdditionalForm)
  end;

  IAdditionalSrvForm=interface(IAdditionalForm)
  end;

  IAdditionalDocForm=interface(IAdditionalForm)
  end;

  IAdditionalControl=interface
  end;

  IAdditionalComponent=interface
  end;

  // Libraries


  TTypeLib=(ttleDefault,ttleInterpreter,ttleComponents,ttleSecurity);

  PInfoLibrary=^TInfoLibrary;
  TInfoLibrary=packed record
    Hint: PChar;
    TypeLib: TTypeLib;
    Programmers: PChar;
    StopLoad: Boolean;
    Condition: PChar;
  end;

  PGetLibrary=^TGetLibrary;
  TGetLibrary=packed record
    Active: Boolean;
    TypeLib: TTypeLib;
    LibHandle: THandle;
  end;

  TGetLibraryProc=procedure(Owner: Pointer; PGL: PGetLibrary); stdcall;

  TTypeCreate=(tcLast,tcFirst,tcAfter,tcBefore);

  TForcedNotificationProc=procedure(AForm: TCustomForm;  APersistent: TPersistent;
                                   Operation: TOperation);stdcall;

  PInfoComponentsLibrary=^TInfoComponentsLibrary;
  TInfoComponentsLibrary=packed record
    ForcedNotification: TForcedNotificationProc;
  end;

  TGetInfoComponentsLibraryProc=procedure(P: PInfoComponentsLibrary);stdcall;

  TInitAllProc=procedure ;stdcall;
  TGetInfoLibraryProc=procedure (P: PInfoLibrary);stdcall;
  TRefreshLibraryProc=procedure;stdcall;
  TSetConnectionProc=procedure (IBDbase: TIBDatabase; IBTran: TIBTransaction;
                                IBDBSecurity: TIBDatabase; IBTSecurity: TIBTransaction);stdcall;
  TBeforeSetOptionProc=procedure(OptionHandle: THandle);stdcall;
  TAfterSetOptionProc=procedure(OptionHandle: THandle; isOK: Boolean);stdcall;
  TCheckOptionProc=procedure(OptionHandle: THandle; var CheckFail: Boolean);stdcall;

  TToolButtonClickProc=procedure(ToolButtonHandle: THandle); stdcall;
  TMenuClickProc=procedure(MenuHandle: THandle); stdcall;

  TViewLogItemProc=procedure(Owner: Pointer; LogItemHandle: THandle);stdcall;
  TTypeLogItem=(tliInformation, tliWarning, tliError, tliConfirmation);

  PCreateLogItem=^TCreateLogItem;
  TCreateLogItem=packed record
    Owner: Pointer;
    Text: PChar;
    TypeLogItem: TTypeLogItem;
    ViewLogItemProc: TViewLogItemProc;
  end;

  TViewAdditionalLogOptionProc=procedure(AdditionalLogHandle: THandle);stdcall;

  PSetParamsToAdditionalLog=^TSetParamsToAdditionalLog;
  TSetParamsToAdditionalLog=packed record
    Limit: Integer;
  end;

  PCreateAdditionalLog=^TCreateAdditionalLog;
  TCreateAdditionalLog=packed record
    Name: PChar;
    Hint: PChar;
    Limit: Integer;
    ViewAdditionalLogOptionProc: TViewAdditionalLogOptionProc;
  end;

  PCreateAdditionalLogItemCaption=^TCreateAdditionalLogItemCaption;
  TCreateAdditionalLogItemCaption=packed record
    Alignment: TAlignment;
    Brush: TBrush;
    Font: TFont;
    Pen: TPen;
    Caption: PChar;
    Width: Integer;
    Visible: Boolean;
    AutoWidth: Boolean;
  end;

  TViewAdditionalLogItemProc=procedure(Owner: Pointer; AdditionalLogItemHandle: THandle);stdcall;
  TTypeAdditionalLogItem=(taliInformation, taliWarning, taliError, taliConfirmation, taliSQL, taliBitmap);

  PCreateAdditionalLogItem=^TCreateAdditionalLogItem;
  TCreateAdditionalLogItem=packed record
    Owner: Pointer;
    Alignment: TAlignment;
    Brush: TBrush;
    Font: TFont;
    Pen: TPen;
    Caption: PChar;
    Bitmap: TBitmap;
    MaxRow: Integer;
    ArrPCALIC: array of PCreateAdditionalLogItemCaption;
    TypeAdditionalLogItem: TTypeAdditionalLogItem;  
    ViewAdditionalLogItemProc: TViewAdditionalLogItemProc;
  end;

  TTypeEditRBook=(terbNone,terbAdd,terbChange,terbView,terbFilter);

  TTypeViewInterface=(tviMdiChild,tvibvModal,tviOnlyData);

  PParamNoneInterface=^TParamNoneInterface;
  TParamNoneInterface=packed record
  end;
  PParamViewNoneInterface=PParamNoneInterface;
  TParamViewNoneInterface=TParamNoneInterface;

  PParamRefreshNoneInterface=^TParamRefreshNoneInterface;
  TParamRefreshNoneInterface=packed record
  end;

  TExecProcParam=packed record
    ParamName: PChar;
    Value: Variant;
  end;

  PParamExecProcNoneInterface=^TParamExecProcNoneInterface;
  TParamExecProcNoneInterface=packed record
    ProcName: PChar;
    Params: array of TExecProcParam;
    Result: Variant;
  end;

  TRBookResult=packed record
    FieldName: Variant;
    FieldType: TFieldType;
    Size: Integer;
    Values: array of Variant;
  end;

  TRBookEdit=packed record
    FieldName: Variant;
    FieldValue: Variant;
  end;

  PParamRBookInterface=^TParamRBookInterface;
  TParamRBookInterface=packed record
    Visual: packed record
      TypeView: TTypeViewInterface;
      MultiSelect: Boolean;
      TypeEdit: TTypeEditRBook;
    end;
    Locate: packed record
      KeyFields: PChar;
      KeyValues: Variant;
      Options: TLocateOptions;
    end;
    Condition: packed record
      OrderStr: PChar;
      WhereStr: PChar;
      WhereStrNoRemoved: PChar;
    end;
    SQL: packed record
      Select: PChar;
      Insert: PChar;
      Update: PChar;
      Delete: PChar;
    end;
    Edit: array of TRBookEdit;
    Result: array of TRBookResult;
    Param: Pointer;
  end;
  PParamViewRBookInterface=PParamRBookInterface;
  TParamViewRBookInterface=TParamRBookInterface;

  PParamRefreshRBookInterface=^TParamRefreshRBookInterface;
  TParamRefreshRBookInterface=packed record
    Locate: packed record
      KeyFields: PChar;
      KeyValues: Variant;
      Options: TLocateOptions;
    end;
  end;

  PParamExecProcRBookInterface=PParamExecProcNoneInterface;
  TParamExecProcRBookInterface=TParamExecProcNoneInterface;

  PParamReportInterface=^TParamReportInterface;
  TParamReportInterface=packed record
  end;
  PParamViewReportInterface=PParamReportInterface;
  TParamViewReportInterface=TParamReportInterface;

  PParamRefreshReportInterface=^TParamRefreshReportInterface;
  TParamRefreshReportInterface=packed record
  end;

  PParamExecProcReportInterface=PParamExecProcNoneInterface;
  TParamExecProcReportInterface=TParamExecProcNoneInterface;

  PParamWizardInterface=^TParamWizardInterface;
  TParamWizardInterface=packed record
  end;
  PParamViewWizardInterface=PParamWizardInterface;
  TParamViewWizardInterface=TParamWizardInterface;

  PParamRefreshWizardInterface=^TParamRefreshWizardInterface;
  TParamRefreshWizardInterface=packed record
  end;

  PParamExecProcWizardInterface=PParamExecProcNoneInterface;
  TParamExecProcWizardInterface=TParamExecProcNoneInterface;

  TJournalResult=packed record
    FieldName: Variant;
    FieldType: TFieldType;
    Size: Integer;
    Values: array of Variant;
  end;

  PParamJournalInterface=^TParamJournalInterface;
  TParamJournalInterface=packed record
    Visual: packed record
     TypeView: TTypeViewInterface;
     MultiSelect: Boolean;
    end;
    Locate: packed record
      KeyFields: PChar;
      KeyValues: Variant;
      Options: TLocateOptions;
    end;
    Condition: packed record
      OrderStr: PChar;
      WhereStr: PChar;
      WhereStrNoRemoved: PChar;
    end;
    Result: array of TJournalResult;
  end;
  PParamViewJournalInterface=PParamJournalInterface;
  TParamViewJournalInterface=TParamJournalInterface;

  PParamRefreshJournalInterface=^TParamRefreshJournalInterface;
  TParamRefreshJournalInterface=packed record
    Locate: packed record
      KeyFields: PChar;
      KeyValues: Variant;
      Options: TLocateOptions;
    end;
  end;

  PParamExecProcJournalInterface=PParamExecProcNoneInterface;
  TParamExecProcJournalInterface=TParamExecProcNoneInterface;

  PParamServiceInterface=^TParamServiceInterface;
  TParamServiceInterface=packed record
  end;
  PParamViewServiceInterface=PParamServiceInterface;
  TParamViewServiceInterface=TParamServiceInterface;

  PParamRefreshServiceInterface=^TParamRefreshServiceInterface;
  TParamRefreshServiceInterface=packed record
  end;

  PParamExecProcServiceInterface=PParamExecProcNoneInterface;
  TParamExecProcServiceInterface=TParamExecProcNoneInterface;

  TDocumentResult=packed record
    FieldName: Variant;
    FieldType: TFieldType;
    Size: Integer;
    Values: array of Variant;
  end;

  TTypeOperationDocument=(todAdd,todChange,todView);

  PParamDocumentInterface=^TParamDocumentInterface;
  TParamDocumentInterface=packed record
    Visual: packed record
     TypeView: TTypeViewInterface;
    end;
    TypeOperation: TTypeOperationDocument;
    Head: packed record
     DocumentId: Integer;
     DocumentNumber: Integer;
     DocumentDate: TDateTime;
     DocumentPrefix: PChar;
     DocumentSufix: PChar;
     TypeDocId: Integer;
    end;
    Result: array of TDocumentResult;
  end;
  PParamViewDocumentInterface=PParamDocumentInterface;
  TParamViewDocumentInterface=TParamDocumentInterface;

  PParamRefreshDocumentInterface=^TParamRefreshDocumentInterface;
  TParamRefreshDocumentInterface=packed record
  end;

  PParamExecProcDocumentInterface=PParamExecProcNoneInterface;
  TParamExecProcDocumentInterface=TParamExecProcNoneInterface;

  TTypeDBPermission=(ttpSelect,ttpInsert,ttpUpdate,ttpDelete,ttpExecute);
  TTypeDbOrder=(tdboNone,tdboAsc,tdboDesc);
  TTypeDbFilter=(tdbfAnd,tdbfOr);
  TTypeDbCondition=(tdbcEqual,tdbcGreater,tdbcLess,tdbcNotEqual,tdbcEqualGreater,tdbcEqualLess,tdbcLike,tdbcIsNull,tdbcIsNotNull);
  TTypeInterfaceAction=(ttiaView,ttiaAdd,ttiaChange,ttiaDelete);

  PCreatePermissionForInterface=^TCreatePermissionForInterface;
  TCreatePermissionForInterface=packed record
    Action: TTypeInterfaceAction;
    DBObject: PChar;
    DBSystem: Boolean;
    DBPermission: TTypeDBPermission;
  end;

  TViewInterfaceProc=function(InterfaceHandle: THandle; Param: Pointer):Boolean;stdcall;
  TRefreshInterfaceProc=function(InterfaceHandle: THandle; Param: Pointer):Boolean;stdcall;
  TCloseInterfaceProc=function(InterfaceHandle: THandle): Boolean;stdcall;
  TExecProcInterfaceProc=function(InterfaceHandle: THandle; Param: Pointer): Boolean;stdcall;

  TTypeInterface=(ttiNone,ttiRBook,ttiReport,ttiWizard,ttiJournal,ttiService,ttiDocument,ttiHelp);
  TSetTypeInterface=set of TTypeInterface;

  PCreateInterface=^TCreateInterface;
  TCreateInterface=packed record
    Name: PChar;
    Hint: PChar;
    TypeInterface: TTypeInterface;
    ChangePrevious: Boolean;
    AutoRun: Boolean;
    ViewInterface: TViewInterfaceProc;
    RefreshInterface: TRefreshInterfaceProc;
    CloseInterface: TCloseInterfaceProc;
    ExecProcInterface: TExecProcInterfaceProc; 
  end;

  PGetInterface=^TGetInterface;
  TGetInterface=packed record
    Name: PChar;
    Hint: PChar;
    TypeInterface: TTypeInterface;
    hInterface: THandle;
  end;
                                                                    
  TGetInterfaceProc=procedure(Owner: Pointer; PGI: PGetInterface); stdcall;

  PGetInterfacePermission=^TGetInterfacePermission;
  TGetInterfacePermission=packed record
    Action: TTypeInterfaceAction;
    DbObject: PChar;
    DbPerm: TTypeDBPermission;
  end;
  
  TGetInterfacePermissionProc=procedure(Owner: Pointer; PGIP: PGetInterfacePermission); stdcall; 

  TTypeCreateMenu=(tcmAddFirst,tcmAddLast,tcmInsertBefore,tcmInsertAfter);

  PCreateMenu=^TCreateMenu;
  TCreateMenu=packed record
    Name: PChar;
    Hint: PChar;
    Bitmap: TBitmap;
    ShortCut: TShortCut;
    MenuClickProc: TMenuClickProc;
    TypeCreateMenu: TTypeCreateMenu;
    InsertMenuHandle: THandle;
    ChangePrevious: Boolean;
    GroupIndex: Byte;
  end;

  PCreateOption=^TCreateOption;
  TCreateOption=packed record
    Name: PChar;
    Bitmap: TBitmap;
    BeforeSetOptionProc: TBeforeSetOptionProc;
    AfterSetOptionProc: TAfterSetOptionProc;
    CheckOptionProc: TCheckOptionProc;   
  end;

  TToolButtonStyleEx = (tbseButton, tbseCheck, tbseDropDown,
                        tbseSeparator,tbseDivider,tbseControl);

  PCreateToolButton=^TCreateToolButton;
  TCreateToolButton=packed record
    Name: PChar;
    Hint: PChar;
    ShortCut: TShortCut;
    Bitmap: TBitmap;
    ToolButtonClickProc: TToolButtonClickProc;
    Style: TToolButtonStyleEx;
    Control: TControl;
  end;

  TToolBarPosition=(tbpFloat,tbpTop,tbpBottom);

  PCreateToolBar=^TCreateToolBar;
  TCreateToolBar=packed record
    Name: PChar;
    Hint: PChar;
    ShortCut: TShortCut;
    Visible: Boolean;
    Position: TToolBarPosition;
  end;

  PCreateProgressBar=^TCreateProgressBar;
  TCreateProgressBar=packed record
    Min,Max: Integer;
    Hint: PChar;
    Color: TColor;
  end;

  PSetProgressBarStatus=^TSetProgressBarStatus;
  TSetProgressBarStatus=packed record
    Progress: Integer;
    Max: Integer;
    Hint: PChar;
  end;

  TTypeEnterPeriod=(tepQuarter,tepMonth,tepDay,tepInterval,tepYear);

  PInfoEnterPeriod=^TInfoEnterPeriod;
  TInfoEnterPeriod=packed record
    DateBegin: TDate;
    DateEnd: TDate;
    LoadAndSave: Boolean;
    TypePeriod: TTypeEnterPeriod;
  end;

  PMainOption=^TMainOption;
  TMainOption=packed record
    isEditRBOnSelect: Boolean;
    RBTableFont: TFont;
    RBTableRecordColor: TColor;
    RBTableCursorColor: TColor;
    RbFilterColor: TColor;
    DirTemp: PChar;
    VisibleRowNumber: Boolean;
    FormFont: TFont;
    VisibleFindPanel: Boolean;
    VisibleEditPanel: Boolean;
    ElementFocusColor: TColor;
    TypeFilter: TTypeDbFilter;
    ElementLabelFocusColor: TColor;
  end;


  PCreateAboutMarquee=^TCreateAboutMarquee;
  TCreateAboutMarquee=packed record
    Text: PChar;
    TypeCreate: TTypeCreate;
  end;

  TGetAboutMarquee=TCreateAboutMarquee;
  PGetAboutMarquee=PCreateAboutMarquee;

  TGetAboutMarqueeProc=procedure (Owner: Pointer; PGAM: PGetAboutMarquee); stdcall;


  // Params
  
  PSaveParamsToFile=^TSaveParamsToFile;
  TSaveParamsToFile=packed record
    FileName: PChar;
  end;

  PLoadParamsFromFile=^TLoadParamsFromFile;
  TLoadParamsFromFile=packed record
    FileName: PChar;
  end;

// imports

  PInfoConnectUser=^TInfoConnectUser;
  TInfoConnectUser=packed record
    UserName: array[0..DomainNameLength-1] of char;
    UserPass: array[0..DomainNameLength-1] of char;
    SqlUserName: array[0..128-1] of char;
    SqlRole: array[0..128-1] of char;
    EmpName: array[0..3*DomainNameLength-1] of char;
    Emp_id: Integer;
    User_id: Integer;
    App_id: Integer;
    AppName: array[0..DomainNameLength-1] of char;
  end;


  procedure _MainFormKeyDown(var Key: Word; Shift: TShiftState);stdcall;
                         external MainExe name ConstMainFormKeyDown;
  procedure _MainFormKeyUp(var Key: Word; Shift: TShiftState);stdcall;
                         external MainExe name ConstMainFormKeyUp;
  procedure _MainFormKeyPress(var Key: Char);stdcall;
                         external MainExe name ConstMainFormKeyPress;
  function _GetOptions: TMainOption;stdcall;
                         external MainExe name ConstGetOptions;
  function _OnVisibleInterface(InterfaceHandle: THandle; Visible: Boolean): Boolean; stdcall;
                               external MainExe name ConstOnVisibleInterface;
  function _isPermissionOnInterface(InterfaceHandle: THandle; Action: TTypeInterfaceAction): Boolean; stdcall;
                                    external MainExe name ConstisPermissionOnInterface;

  function _isExistsParam(Section,Param: PChar): Boolean; stdcall;
                          external MainExe name ConstisExistsParam;
  procedure _WriteParam(Section,Param: PChar; Value: Variant); stdcall;
                        external MainExe name ConstWriteParam;
  function _ReadParam(Section,Param: PChar; Default: Variant): Variant; stdcall;
                      external MainExe name ConstReadParam;
  procedure _ClearParams; stdcall; external MainExe name ConstClearParams;
  procedure _SaveParams; stdcall; external MainExe name ConstSaveParams;
  function _EraseParams(Section: PChar): Boolean; stdcall; external MainExe name ConstEraseParams;

  function _isPermission(sqlObject: PChar; sqlOperator: PChar): Boolean;stdcall;
                           external MainExe name ConstisPermission;
  function _isPermissionSecurity(sqlObject: PChar; sqlOperator: PChar): Boolean;stdcall;
                           external MainExe name ConstisPermissionSecurity;
  function _isPermissionColumn(sqlObject,objColumn,sqlOperator: PChar): Boolean;stdcall;
                           external MainExe name ConstisPermissionColumn;

  procedure _SetSplashStatus(Status: Pchar);stdcall;
                           external MainExe name ConstSetSplashStatus;
  procedure _GetProtocolAndServerName(DataBaseStr: Pchar; var Protocol: TProtocol;
                                     ServerName: array of char);stdcall;
                           external MainExe name ConstGetProtocolAndServerName;
  procedure _GetInfoConnectUser(P: PInfoConnectUser);stdcall;
                           external MainExe name ConstGetInfoConnectUser;
  procedure _AddErrorToJournal(Error: PChar; ClassError: TClass);stdcall;
                           external MainExe name ConstAddErrorToJournal;
  procedure _AddSqlOperationToJournal(Name,Hint: PChar);stdcall;
                           external MainExe name ConstAddSqlOperationToJournal;
  function _GetDateTimeFromServer: TDateTime;stdcall;
                           external MainExe name ConstGetDateTimeFromServer;
  function _GetWorkDate: TDate; stdcall;
                          external MainExe name ConstGetWorkDate;
  procedure _GetLibraries(Owner: Pointer; Proc: TGetLibraryProc); stdcall;
                          external MainExe name ConstGetLibraries;
  function _TestSplash: Boolean;stdcall;
                       external MainExe name ConstTestSplash;


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
  function _RefreshInterface(InterfaceHandle: THandle; Param: Pointer): Boolean; stdcall;
                             external MainExe name ConstRefreshInterface;
  function _CloseInterface(InterfaceHandle: THandle): Boolean; stdcall;
                           external MainExe name ConstCloseInterface;
  function _ExecProcInterface(InterfaceHandle: THandle; Param: Pointer): Boolean; stdcall;
                             external MainExe name ConstExecProcInterface;
  function _CreatePermissionForInterface(InterfaceHandle: THandle; PCPFI: PCreatePermissionForInterface): Boolean;stdcall;
                                         external MainExe name ConstCreatePermissionForInterface;
  procedure _GetInterfaces(Owner: Pointer; Proc: TGetInterfaceProc); stdcall;
                           external MainExe name ConstGetInterfaces;
  function _isValidInterface(InterfaceHandle: THandle): Boolean; stdcall;
                             external MainExe name ConstisValidInterface;
  procedure _GetInterfacePermissions(Owner: Pointer; InterfaceHandle: THandle; Proc: TGetInterfacePermissionProc); stdcall;
                                     external MainExe name ConstGetInterfacePermissions;
  function _GetInterface(InterfaceHandle: THandle): PGetInterface; stdcall;
                          external MainExe name ConstGetInterface;

  function _ClearLog: Boolean;stdcall;
                     external MainExe name ConstClearLog;
  procedure _ViewLog(Visible: Boolean);stdcall;
                     external MainExe name ConstViewLog;
  function _CreateLogItem(PCLI: PCreateLogItem): THandle;stdcall;
                          external MainExe name ConstCreateLogItem;
  function _FreeLogItem(LogItemHandle: THandle): Boolean;stdcall;
                        external MainExe name ConstFreeLogItem;

  function _CreateAdditionalLog(PCAL: PCreateAdditionalLog): THandle;stdcall;
                                external MainExe name ConstCreateAdditionalLog;
  function _FreeAdditionalLog(AdditionalLogHandle: THandle): Boolean; stdcall;
                              external MainExe name ConstFreeAdditionalLog;
  function _SetParamsToAdditionalLog(AdditionalLogHandle: THandle; PSPAL: PSetParamsToAdditionalLog): Boolean;stdcall;
                                     external MainExe name ConstSetParamsToAdditionalLog;
  function _CreateAdditionalLogItem(AdditionalLogHandle: THandle; PCALI: PCreateAdditionalLogItem): THandle; stdcall;
                                    external MainExe name ConstCreateAdditionalLogItem;
  function _FreeAdditionalLogItem(AdditionalLogItemHandle: THandle): Boolean; stdcall;
                                  external MainExe name ConstFreeAdditionalLogItem;
  function _isValidAdditionalLog(AdditionalLogHandle: THandle): Boolean; stdcall;
                                 external MainExe name ConstisValidAdditionalLog;
  function _isValidAdditionalLogItem(AdditionalLogItemHandle: THandle): Boolean; stdcall;
                                     external MainExe name ConstisValidAdditionalLogItem;
  function _ClearAdditionalLog(AdditionalLogHandle: THandle): Boolean; stdcall;
                               external MainExe name ConstClearAdditionalLog;
  procedure _ViewAdditionalLog(AdditionalLogHandle: THandle; Visible: Boolean); stdcall;
                               external MainExe name ConstViewAdditionalLog;


  function _CreateAboutMarquee(PCAM: PCreateAboutMarquee): THandle;stdcall;
                                external MainExe name ConstCreateAboutMarquee;
  function _FreeAboutMarquee(AboutMarqueeHandle: THandle): Boolean; stdcall;
                              external MainExe name ConstFreeAboutMarquee;

  function QueryForParamRBookInterface(DB: TIBDataBase; SQL: string; PPRBI: PParamRBookInterface): Boolean;
  procedure FillParamRBookInterfaceFromDataSet(DataSet: TDataSet; PPRBI: PParamRBookInterface; Bookmarks: array of Pointer);
  procedure FillPRBIFromDataSet(DataSet: TDataSet; PPRBI: PParamRBookInterface;  Bookmarks: array of Pointer);
  function ifExistsDataInParamRBookInterface(PPRBI: PParamRBookInterface): Boolean;
  function ifExistsDataInPRBI(PPRBI: PParamRBookInterface): Boolean;
  function GetFirstValueFromParamRBookInterface(PPRBI: PParamRBookInterface; FieldName: Variant; Prepear: Boolean=true): Variant;
  function GetFirstValueFromPRBI(PPRBI: PParamRBookInterface; FieldName: Variant; Prepear: Boolean=true): Variant;
  procedure GetStartAndEndByParamRBookInterface(PPRBI: PParamRBookInterface; var StartValue,EndValue: Integer);
  procedure GetStartAndEndByPRBI(PPRBI: PParamRBookInterface; var StartValue,EndValue: Integer);
  function GetValueByParamRBookInterface(PPRBI: PParamRBookInterface; const Index: Integer;
                                         FieldName: Variant; ValueType: Word): Variant;
  function GetValueByPRBI(PPRBI: PParamRBookInterface; const Index: Integer; FieldName: Variant): Variant;
  function GetFieldTypeByParamRBookInterface(PPRBI: PParamRBookInterface; FieldName: Variant): TFieldType;

  function ifExistsDataInParamJournalInterface(PPJI: PParamJournalInterface): Boolean;
  function ifExistsDataInPJI(PPJI: PParamJournalInterface): Boolean;
  function GetFirstValueFromParamJournalInterface(PPJI: PParamJournalInterface; FieldName: Variant): Variant;
  function GetFirstValueFromPJI(PPJI: PParamJournalInterface; FieldName: Variant): Variant;
  procedure GetStartAndEndByParamJournalInterface(PPJI: PParamJournalInterface; var StartValue,EndValue: Integer);
  procedure GetStartAndEndByPJI(PPJI: PParamJournalInterface; var StartValue,EndValue: Integer);
  function GetValueByParamJournalInterface(PPJI: PParamJournalInterface; const Index: Integer;
                                         FieldName: Variant; ValueType: Word): Variant;
  function GetValueByPJI(PPJI: PParamJournalInterface; const Index: Integer; FieldName: Variant): Variant;

  
  function QueryForParamJournalInterface(DB: TIBDataBase; SQL: string; PPJI: PParamJournalInterface): Boolean;
  procedure FillParamJournalInterfaceFromDataSet(DataSet: TDataSet; PPJI: PParamJournalInterface; Bookmarks: array of Pointer);
  procedure FillPJIFromDataSet(DataSet: TDataSet; PPJI: PParamJournalInterface; Bookmarks: array of Pointer);

  procedure FillParamDocumentInterfaceFromDataSet(DataSet: TDataSet; PPDI: PParamDocumentInterface; Bookmarks: array of Pointer);
  procedure FillPDIFromDataSet(DataSet: TDataSet; PPDI: PParamDocumentInterface; Bookmarks: array of Pointer);


  function TranslatePermission(DBPermission: TTypeDBPermission): string;
  function TranslateInterfaceAction(Action: TTypeInterfaceAction): string;
  function TranslateOrder(DbOrder: TTypeDbOrder): string;
  function TranslateFilter(DbFilter: TTypeDbFilter): string;
  function TranslateCondition(DbCondition: TTypeDbCondition): string;
  function ExistsExcel: Boolean;


////*************************************************************



implementation

uses StrUtils, IBCustomDataSet, tsvDbGrid, dbtree, comobj, FileCtrl;

function ShowError(Handle: THandle; Mess: String): Integer;
begin
 Result:=MessageBox(Handle,Pchar(Mess),ConstError,MB_ICONERROR);
end;

function ShowErrorQuestion(Handle: THandle; Mess: String): Integer;
begin
 Result:=MessageBox(Handle,Pchar(Mess),ConstQuestion,MB_ICONERROR+MB_YESNO);
end;

function ShowWarning(Handle: THandle; Mess: String): Integer;
begin
 Result:=MessageBox(Handle,Pchar(Mess),ConstWarning,MB_ICONWARNING);
end;

function ShowInfo(Handle: THandle; Mess: String): Integer;
begin
 Result:=MessageBox(Handle,Pchar(Mess),ConstInformation,MB_ICONINFORMATION);
end;

function ShowQuestion(Handle: THandle; Mess: String): Integer;
begin
 Result:=MessageBox(Handle,Pchar(Mess),ConstQuestion,MB_ICONQUESTION+MB_YESNO);
end;

function DeleteWarning(Handle: THandle; Mess: String): Integer;
begin
 Result:=ShowQuestion(Handle,CaptionDelete+' '+Mess);
end;

function ShowErrorEx(Mess: String): Integer;
begin
  MessageBeep(MB_ICONERROR);
  Result:=MessageDlg(Mess,mtError,[mbOk],0);
end;

function ShowWarningEx(Mess: String): Integer;
begin
  MessageBeep(MB_ICONWARNING);
  Result:=MessageDlg(Mess,mtWarning,[mbOk],0);
end;

function ShowInfoEx(Mess: String): Integer;
begin
  MessageBeep(MB_ICONINFORMATION);
  Result:=MessageDlg(Mess,mtInformation,[mbOk],0);
end;

function ShowQuestionEx(Mess: String): Integer;
begin
  MessageBeep(MB_ICONQUESTION);
  Result:=MessageDlg(Mess,mtConfirmation,[mbYes,mbNo],0);
end;

function ShowYesNoCancelEx(Mess: String): Integer;
begin
  MessageBeep(MB_ICONQUESTION);
  Result:=MessageDlg(Mess,mtConfirmation,[mbYes,mbNo,mbCancel],0);
end;

function ShowErrorQuestionEx(Mess: String): Integer;
begin
  MessageBeep(MB_ICONQUESTION);
  Result:=MessageDlg(Mess,mtError,[mbYes,mbNo],0);
end;

function DeleteWarningEx(Mess: String): Integer;
begin
  Result:=ShowQuestionEx(CaptionDelete+' '+Mess);
end;

function GetRecordCount(qr: TIBQuery; Fetch: Boolean=false): Integer;
var
 sqls: string;
 Apos,NPos,APos1: Integer;
 newsqls: string;
 qrnew: TIBQuery;
 i: Integer;
 s1,s2,s3: string;
 tmps,tmps1: string;
 scount,fcount: Integer;
const
 from='from';
 orderby='order by';
 union='union';
 select='select';
begin
 Result:=0;
 try
  if not qr.Active then exit;
  sqls:=qr.SQL.Text;
  if Trim(sqls)='' then exit;

  tmps:=sqls;
  scount:=0;
  while true do begin
    Apos:=Pos(AnsiUpperCase(select),AnsiUpperCase(tmps));
    if Apos>0 then begin
      tmps:=Copy(tmps,Apos+Length(select),Length(tmps));
      inc(scount);
      APos1:=Pos(AnsiUpperCase(select),AnsiUpperCase(tmps));
      if APos1>0 then begin
        tmps1:=Copy(tmps,1,APos1-1);
        APos1:=Pos(AnsiUpperCase(from),AnsiUpperCase(tmps1));
        if APos1>0 then
          dec(scount);
      end;
    end else break;
  end;

  NPos:=0;
  tmps:=sqls;
  fcount:=0;
  while true do begin
    Apos:=Pos(AnsiUpperCase(from),AnsiUpperCase(tmps));
    if Apos>0 then begin
      NPos:=NPos+Apos;
      tmps:=Copy(tmps,Apos+Length(from),Length(tmps));
      inc(fcount);
      if fcount=scount then begin
        NPos:=NPos+(fcount-1)*(Length(from)-1);
        break;
      end;
    end else break;
  end;
  APos:=NPos;

  if Apos=0 then exit;
  newsqls:='Select count(*) as ctn '+Copy(sqls,Apos,Length(sqls));
  Apos:=Pos(AnsiUpperCase(union),AnsiUpperCase(newsqls));
  if APos<>0 then begin
    s1:=Copy(newsqls,1,APos-1);
    s2:=Copy(newsqls,APos,Length(newsqls)-APos+1);
    APos:=Pos(AnsiUpperCase(from),AnsiUpperCase(s2));
    if APos<>0 then begin
      s3:='Select count(*) as ctn from '+
          Copy(s2,Apos+Length(from),Length(s2)-Apos-Length(from)+1);
      newsqls:=s1+' '+union+' '+s3;
    end;
  end;

  Apos:=Pos(AnsiUpperCase(orderby),AnsiUpperCase(newsqls));
  if Apos<>0 then begin
    newsqls:=Copy(newsqls,1,APos-1);
  end;
  qrnew:=TIBQuery.Create(nil);
  try
   qrnew.Database:=qr.Database;
   qrnew.ParamCheck:=qr.ParamCheck;
   qrnew.Transaction:=qr.Transaction;
   qrnew.SQL.Add(newsqls);
   qrnew.DataSource:=qr.DataSource;
   qrnew.Params.AssignValues(qr.Params);

   //////////////////////////////////////

   qrnew.Active:=true;
   qrnew.First;
   if not Fetch then begin
    if not qrnew.IsEmpty then begin //Так круче :-)
      while not qrnew.Eof do begin
        Result:=Result+qrnew.FieldByName('ctn').AsInteger;
        qrnew.Next;
      end;
    end;
   end else begin
    i:=0;
    while not qrnew.Eof do begin
      inc(i);
      qrnew.Next;
    end;
    Result:=i;
   end;
  finally
   qrnew.free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure SetGenIdByName(DB: TIBDataBase; Name: string; Value: Integer);
var
  id: Integer;
begin
  id:=GetGenIdByName(DB,Name,Value);
  if id>Value then
    GetGenIdByName(DB,Name,Value-id)
  else
    GetGenIdByName(DB,Name,-id+Value);
end;

function GetGenIdByName(DB: TIBDataBase; Name: string; Increment: Integer): Integer;
var
 sqls: string;
 qrnew: TIBQuery;
 tran: TIBTransaction;
const
 tbDual='DUAL';
begin
 Result:=0;
 try
  Screen.Cursor:=crHourGlass;
  qrnew:=TIBQuery.Create(nil);
  tran:=TIBTransaction.Create(nil);
  try
   qrnew.Database:=DB;
   tran.AddDatabase(DB);
   DB.AddTransaction(tran);
   qrnew.Transaction:=tran;
   qrnew.Transaction.Active:=true;
   sqls:='Select (gen_id('+Name+','+inttostr(Increment)+')) from '+tbDual;
   qrnew.SQL.Add(sqls);
   qrnew.Active:=true;
   if not qrnew.IsEmpty then begin
     Result:=qrnew.FieldByName('gen_id').AsInteger;
   end else
     raise Exception.CreateFmt(fmtTableNoRecord,[tbDual]);
  finally
   tran.free;
   qrnew.free;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

function GetGenId(DB: TIBDataBase; TableName: string; Increment: Word): Longword;
var
  S: String;
begin
  S:=ChangeString(TableName,'"','');
  Result:=GetGenIdByName(DB,'GEN_'+S+'_ID',Increment);
end;

function TranslateIBError(Message: string): string;
var
  str: TStringList;
  APos: Integer;
  tmps: string;
const
  ExceptConst='exception';
  NewConst='Исключение №';
begin
  str:=TStringList.Create;
  try
   str.Text:=Message;
   if str.Count>1 then begin
     tmps:=str.Strings[0];
     APos:=Pos(ExceptConst,tmps);
     if APos<>0 then begin
{      tmps:=NewConst+Copy(tmps,APos+Length(ExceptConst)+1,
                          Length(tmps)-APos+Length(ExceptConst)+1);
      str.Strings[0]:=tmps;}

     end;
     str.Delete(0);
   end;
   Result:=str.Text;
  finally
   str.Free;
  end;
end;

procedure SetSelectedRowParams(var AFont:TFont;var ABackground:TColor);
begin
 AFont.Color:=clWhite;
 ABackground:=_GetOptions.RBTableRecordColor;
end;

procedure SetSelectedColParams(var AFont:TFont;var ABackground:TColor);
begin
 AFont.Color:=clHighlightText;
 ABackground:=_GetOptions.RBTableCursorColor;
end;

function StringToHexStr(S:String):String;
var I:Integer;
begin
 Result:='';
 for I:=1 to Length(S) do
  Result:=Result+IntToHex(Ord(S[I]),2)+'-';
 Delete(Result,Length(Result),1);
end;

function HexStrToString(S:String):String;
var I:Integer;
begin
 SetLength(Result,WordCount(S,['-']));
 for I:=1 to WordCount(S,['-']) do
  Result[I]:=Chr(Hex2Dec(ExtractWord(I,S,['-'])));
end;

procedure ChangeDataBase(Owner:TComponent;DB:TIBDatabase);
var I:Integer;
begin
 with Owner do
 begin
  try
   for I:=1 to ComponentCount do
    if Components[I-1] is TIBTransaction then
     with Components[I-1] as TIBTransaction do DefaultDatabase:=DB;
  except
  end;
  try
   for I:=1 to ComponentCount do
    if Components[I-1] is TIBCustomDataSet then
     with Components[I-1] as TIBCustomDataSet do Database:=DB;
  except
  end;
 end;
end;

procedure SetMinColumnsWidth(Columns: TDBGridColumns);
var I:Integer;
begin
 for I:=1 to Columns.Count do
  Columns[I-1].Width:=90;
end;

procedure ClearFields(wt: TWinControl);
var
  i: Integer;
  ct: TControl;
begin
  if wt=nil then exit;
  for i:=0 to wt.ControlCount-1 do begin
    ct:=wt.Controls[i];
    if ct is TWinControl then begin
      ClearFields(TWinControl(ct));
    end;
    if ct is TEdit then begin
      TEdit(ct).Text:='';
    end;
    if ct is TComboBox then begin
      TComboBox(ct).ItemIndex:=-1;
      TComboBox(ct).Text:='';
    end;
    if ct is TCustomMemo then begin
      TCustomMemo(ct).Clear;
    end;
    if ct is TDateTimePicker then begin
      TDateTimePicker(ct).Checked:=false;
    end;

  end;
end;

function isFloat(const Value: string): Boolean;
var
  ret: Extended;
begin
  Result:=TextToFloat(PChar(Value), ret, fvExtended) and (ret<>Null);
end;

function isInteger(const Value: string): Boolean;
var
  E: Integer;
  ret: Integer;
begin
  Val(Value, ret, E);
  Result:=(E=0)and(ret<>Null);
end;

function isDate(const Value: string): Boolean;
begin
  Result:=false;
  try
    StrToDate(Value);
    Result:=true;
  except
  end;
end;

function isTime(const Value: string): Boolean;
begin
  Result:=false;
  try
    StrToTime(Value);
    Result:=true;
  except
  end;
end;

function isDateTime(const Value: string): Boolean;
begin
  Result:=false;
  try
    StrToDateTime(Value);
    Result:=true;
  except
  end;
end;

function ChangeChar(Value: string; chOld, chNew: char): string;
var
  i: Integer;
  tmps: string;
begin
  for i:=1 to Length(Value) do begin
    if Value[i]=chOld then
     Value[i]:=chNew;
    tmps:=tmps+Value[i];
  end;
  Result:=tmps;
end;

function ChangeString(Value: string; strOld, strNew: string): string;
var
  tmps: string;
  APos: Integer;
  s1,s3: string;
  lOld: Integer;
begin
  Apos:=-1;
  s3:=Value;
  lOld:=Length(strOld);
  while APos<>0 do begin
    APos:=Pos(strOld,s3);
    if APos>0 then begin
      SetLength(s1,APos-1);
      Move(Pointer(s3)^,Pointer(s1)^,APos-1);
      s3:=Copy(s3,APos+lOld,Length(s3)-APos-lOld+1);
      tmps:=tmps+s1+strNew;
    end else
      tmps:=tmps+s3;
  end;
  Result:=tmps;
end;

function StrBetween(InStr: String; S1,S2: string): String;
var
  APos1,APos2: Integer;
begin
  Result:='';
  APos1:=AnsiPos(S1,InStr);
  if APos1>0 then begin
    InStr:=Copy(InStr,APos1+Length(S1),Length(InStr));
    APos2:=AnsiPos(S2,InStr);
    if APos2>0 then begin
      InStr:=Copy(InStr,0,APos2-1);
      Result:=InStr;
    end;
  end;
end;

function GetStrFromCondition(isNotEmpty: Boolean; STrue,SFalse: string): string;
begin
 if isNotEmpty then
  Result:=STrue
 else Result:=SFalse;
end;

function FieldToVariant(Field: TField): OleVariant;
begin
  Result := '';
  case Field.DataType of
    ftString, ftFixedChar, ftWideString, ftMemo, ftFmtMemo: Result := '''' + Field.AsString;
    ftSmallint, ftInteger, ftWord, ftLargeint, ftAutoInc: Result := Field.AsInteger;
    ftFloat, ftCurrency, ftBCD: Result := Field.AsFloat;
    ftBoolean: Result := Field.AsBoolean;
    ftDate, ftTime, ftDateTime: Result := Field.AsDateTime;
  end;
end;

function TranslateSqlOperator(Operator: String): string;
begin
  Result:='';
  if Operator=SelConst then Result:=ConstSelect;
  if Operator=InsConst then Result:=ConstInsert;
  if Operator=UpdConst then Result:=ConstUpdate;
  if Operator=DelConst then Result:=ConstDelete;
end;

procedure AssignFont(inFont,outFont: TFont);
begin
  outFont.FontAdapter:=inFont.FontAdapter;
  outFont.Name:=inFont.Name;
  outFont.PixelsPerInch:=inFont.PixelsPerInch;
  outFont.Charset:=inFont.Charset;
//  outFont.Color:=inFont.Color;
  outFont.Height:=inFont.Height;
  outFont.Pitch:=inFont.Pitch;
  outFont.Size:=inFont.Size;
  outFont.Style:=inFont.Style;
end;

procedure CloseAllSql(Owner: TComponent);
var
  i: Integer;
begin
  for i:=0 to Owner.ComponentCount-1 do begin
   if Owner.Components[i] is TIBQuery then
     TIBQuery(Owner.Components[i]).Active:=false;
   if Owner.Components[i] is TIBTransaction then
      TIBTransaction(Owner.Components[i]).Active:=false;
  end;
end;

//Функция получения ID текущего периода
function GetCurCalcPeriodID(DB: TIBDatabase) : Integer;
var
 sqls: string;
 qrnew: TIBQuery;
 tran: TIBTransaction;
begin
 Result:=-1;
 try
  Screen.Cursor:=crHourGlass;
  qrnew:=TIBQuery.Create(nil);

  tran:=TIBTransaction.Create(nil);
  tran.DefaultDatabase:=DB;
  tran.Params.Text:=DefaultTransactionParamsTwo;
  tran.DefaultAction:=TARollback;
  try
   qrnew.Database:=DB;
   tran.AddDatabase(DB);
   DB.AddTransaction(tran);
   qrnew.Transaction:=tran;
   qrnew.Transaction.Active:=true;
   sqls:='Select * from CalcPeriod where status = 2 or status = 1';
   qrnew.SQL.Add(sqls);
   qrnew.Active:=true;
   if not qrnew.IsEmpty then begin
     Result:=qrnew.FieldByName('calcperiod_id').AsInteger;
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


function IsValidPointer(P: Pointer; Size: Integer=0): Boolean;
begin
  result:=False;
  if P=nil then exit;
  if isBadCodePtr(P) then exit;
  if Size>0 then
   if IsBadReadPtr(P,Size) then exit;
  Result:=true;
end;

procedure HandleNeededToWinControl(wt: TWinControl);
var
  i: Integer;
  ct: TControl;
begin
  for i:=0 to wt.ControlCount-1 do begin
    ct:=wt.Controls[i];
    if ct is TWinControl then begin
      TWinControl(ct).HandleNeeded;
      HandleNeededToWinControl(TWinControl(ct));
    end;
  end;
end;

function StrToHexStr(S:String):String;
var
  i: Integer;
  l: Integer;
begin
  l:=Length(S);
  Result:='';
  for i:=1 to l do
   Result:=Result+IntToHex(Word(S[i]),2);
end;

function HexStrToStr(S:String):String;
var
  l: Integer;
  APos: Integer;
  tmps: string;
begin
  l:=Length(S);
  APos:=1;
  Result:='';
  while APos<(l+1) do begin
    tmps:=Copy(S,APos,2);
    Result:=Result+Char(StrToIntDef('$'+tmps,0));
    inc(APos,2);
  end;
end;

procedure SetNewDbGirdProp(Grid: TNewDBgrid);
begin
   AssignFont(_GetOptions.RBTableFont,Grid.Font);
   Grid.TitleFont.Assign(Grid.Font);
   Grid.RowSelected.Font.Assign(Grid.Font);
   Grid.RowSelected.Brush.Style:=bsClear;
   Grid.RowSelected.Brush.Color:=_GetOptions.RBTableRecordColor;
   Grid.RowSelected.Font.Color:=clWhite;
   Grid.RowSelected.Pen.Style:=psClear;
   Grid.CellSelected.Visible:=true;
   Grid.CellSelected.Brush.Color:=_GetOptions.RBTableCursorColor;
   Grid.CellSelected.Font.Assign(Grid.Font);
   Grid.CellSelected.Font.Color:=clHighlightText;
   Grid.TitleCellMouseDown.Font.Assign(Grid.Font);
   Grid.Invalidate;
end;

procedure SetTreeViewProp(TV: TDBTreeView);
begin
    AssignFont(_GetOptions.RBTableFont,TV.Font);
end;
    
procedure SetProperties(wt: TWinControl);
var
  i: Integer;
  ct: TControl;
begin
  for i:=0 to wt.ControlCount-1 do begin
     ct:=wt.Controls[i];
     if ct is TNewDbGrid then
        SetNewDbGirdProp(TNewDbGrid(ct));
     if ct is TCustomTreeView then
        SetTreeViewProp(TDBTreeView(ct));
     if ct is TWinControl then
        SetProperties(TWinControl(ct));
  end;
end;

function PrepearWhereString(WhereString: String): string;
var
  APos: Integer;
begin
  Result:=WhereString;
  if Trim(WhereString)='' then exit;
  Apos:=AnsiPos('WHERE',AnsiUpperCase(Trim(WhereString)));
  if (Apos=0)or(APos>1) then
    Result:=' where '+WhereString;
end;

function PrepearWhereStringNoRemoved(WhereString: String): string;
var
  APos: Integer;
  tmps: string;
begin
  Result:=WhereString;
  tmps:=Trim(WhereString);
  if tmps='' then exit;
  Apos:=AnsiPos('WHERE',AnsiUpperCase(tmps));
  if (Apos=1) then
    Result:=Copy(tmps,Apos+Length('where'),Length(tmps)-Length('where'));
end;

function PrepearOrderString(OrderString: String): string;
var
  APos: Integer;
begin
  Result:=OrderString;
  if Trim(OrderString)='' then exit;
  Apos:=AnsiPos('ORDER BY',AnsiUpperCase(Trim(OrderString)));
  if (Apos=0)or(APos>1) then
    Result:=' order by '+OrderString+' ';
end;

function QueryForParamRBookInterface(DB: TIBDataBase; SQL: string; PPRBI: PParamRBookInterface): Boolean;
var
   qr: TIBQuery;
   tr: TIBTransaction;
   WhereStr: String;
   OrderStr: String;
   sqls: string;
begin
   Result:=false;
   try
    Screen.Cursor:=crHourGlass;
    qr:=TIBQuery.Create(nil);
    tr:=TIBTransaction.Create(nil);
    try
     qr.Database:=DB;
     tr.AddDatabase(DB);
     tr.Params.Text:=DefaultTransactionParamsTwo;
     DB.AddTransaction(tr);
     qr.Transaction:=tr;
     qr.Transaction.Active:=true;
     WhereStr:=PrepearWhereString(PPRBI.Condition.WhereStr);
     OrderStr:=PrepearOrderString(PPRBI.Condition.OrderStr);
     sqls:=SQL+WhereStr+OrderStr;
     qr.SQL.Add(sqls);
     qr.Active:=true;
     FillParamRBookInterfaceFromDataSet(qr,PPRBI,[]);
     Result:=true;
    finally
     tr.free;
     qr.free;
     Screen.Cursor:=crDefault;
   end;
  except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

procedure FillParamRBookInterfaceFromDataSet(DataSet: TDataSet; PPRBI: PParamRBookInterface;
                                             Bookmarks: array of Pointer);
var
  i,j: Integer;
  bm: Pointer;
  incr: Integer;
begin
  if not isValidPointer(DataSet) then exit;
  if not isValidPointer(PPRBI) then exit;
  if not isValidPointer(@Bookmarks) then exit;

  if not DataSet.active then exit;
  DataSet.DisableControls;
  bm:=nil;
  try
    bm:=DataSet.GetBookmark;
    SetLength(PPRBI.Result,DataSet.FieldCount);
    for i:=0 to DataSet.FieldCount-1 do begin
      PPRBI.Result[i].FieldName:=DataSet.Fields[i].FieldName;
      PPRBI.Result[i].FieldType:=DataSet.Fields[i].DataType;
      PPRBI.Result[i].Size:=DataSet.Fields[i].Size;
    end;
    incr:=0;
    DataSet.First;
    if Length(Bookmarks)=0 then begin
      while not DataSet.Eof do begin
        for i:=0 to DataSet.FieldCount-1 do begin
          SetLength(PPRBI.Result[i].Values,incr+1);
          PPRBI.Result[i].Values[incr]:=DataSet.Fields[i].Value;
        end;
        DataSet.Next;
        Inc(Incr);
      end;
    end else begin
     for i:=0 to DataSet.FieldCount-1 do begin
      for j:=Low(Bookmarks) to High(Bookmarks) do begin
        SetLength(PPRBI.Result[i].Values,Length(Bookmarks));
        DataSet.GotoBookmark(Bookmarks[j]);
        PPRBI.Result[i].Values[j]:=DataSet.Fields[i].Value;
      end;
     end; 
    end;
  finally
    DataSet.GotoBookmark(bm);
    DataSet.EnableControls;
  end;
end;

procedure FillPRBIFromDataSet(DataSet: TDataSet; PPRBI: PParamRBookInterface; Bookmarks: array of Pointer);
begin
  FillParamRBookInterfaceFromDataSet(DataSet,PPRBI,Bookmarks);
end;

function QueryForParamJournalInterface(DB: TIBDataBase; SQL: string; PPJI: PParamJournalInterface): Boolean;
var
   qr: TIBQuery;
   tr: TIBTransaction;
   WhereStr: String;
   OrderStr: String;
   sqls: string;
begin
   Result:=false;
   try
    Screen.Cursor:=crHourGlass;
    qr:=TIBQuery.Create(nil);
    tr:=TIBTransaction.Create(nil);
    try
     qr.Database:=DB;
     tr.AddDatabase(DB);
     tr.Params.Text:=DefaultTransactionParamsTwo;
     DB.AddTransaction(tr);
     qr.Transaction:=tr;
     qr.Transaction.Active:=true;
     WhereStr:=PrepearWhereString(PPJI.Condition.WhereStr);
     OrderStr:=PrepearOrderString(PPJI.Condition.OrderStr);
     sqls:=SQL+WhereStr+OrderStr;
     qr.SQL.Add(sqls);
     qr.Active:=true;
     FillParamJournalInterfaceFromDataSet(qr,PPJI,[]);
     Result:=true;
    finally
     tr.free;
     qr.free;
     Screen.Cursor:=crDefault;
   end;
  except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

procedure FillParamJournalInterfaceFromDataSet(DataSet: TDataSet; PPJI: PParamJournalInterface; Bookmarks: array of Pointer);
var
  i,j: Integer;
  bm: Pointer;
  incr: Integer;
begin
  if not isValidPointer(DataSet) then exit;
  if not isValidPointer(PPJI) then exit;
  if not isValidPointer(@Bookmarks) then exit;

  if not DataSet.active then exit;
  DataSet.DisableControls;
  bm:=nil;
  try
    bm:=DataSet.GetBookmark;
    SetLength(PPJI.Result,DataSet.FieldCount);
    for i:=0 to DataSet.FieldCount-1 do begin
      PPJI.Result[i].FieldName:=DataSet.Fields[i].FieldName;
      PPJI.Result[i].FieldType:=DataSet.Fields[i].DataType;
      PPJI.Result[i].Size:=DataSet.Fields[i].Size;
    end;  
    incr:=0;
    if Length(Bookmarks)=0 then begin
      DataSet.First;
      while not DataSet.Eof do begin
        for i:=0 to DataSet.FieldCount-1 do begin
          SetLength(PPJI.Result[i].Values,incr+1);
          PPJI.Result[i].Values[incr]:=DataSet.Fields[i].Value;
        end;
        DataSet.Next;
        Inc(Incr);
      end;
    end else begin
     for i:=0 to DataSet.FieldCount-1 do begin
      for j:=Low(Bookmarks) to High(Bookmarks) do begin
        SetLength(PPJI.Result[i].Values,Length(Bookmarks));
        DataSet.GotoBookmark(Bookmarks[j]);
        PPJI.Result[i].Values[j]:=DataSet.Fields[i].Value;
      end;
     end; 
    end;  
  finally
    DataSet.GotoBookmark(bm);
    DataSet.EnableControls;
  end;
end;

procedure FillPJIFromDataSet(DataSet: TDataSet; PPJI: PParamJournalInterface; Bookmarks: array of Pointer);
begin
  FillParamJournalInterfaceFromDataSet(DataSet,PPJI,Bookmarks);
end;

function ifExistsDataInParamRBookInterface(PPRBI: PParamRBookInterface): Boolean;
var
  ColumnCount,RowCount: Integer;
  h,l: Integer;
begin
  Result:=false;
  if not isValidPointer(PPRBI) then exit;
  ColumnCount:=High(PPRBI.Result)-Low(PPRBI.Result)+1;
  if ColumnCount<=0 then exit;
  h:=High(PPRBI.Result[Low(PPRBI.Result)].Values);
//  if h<=-1 then h:=0;
  l:=Low(PPRBI.Result[Low(PPRBI.Result)].Values);
//  if l<=-1 then l:=0;
  RowCount:=h-l+1;
  Result:=RowCount>0;
end;

function ifExistsDataInPRBI(PPRBI: PParamRBookInterface): Boolean;
begin
  Result:=ifExistsDataInParamRBookInterface(PPRBI);
end;

function GetFirstValueFromParamRBookInterface(PPRBI: PParamRBookInterface; FieldName: Variant; Prepear: Boolean=true): Variant;
var
  i,j: Integer;
begin
  VarClear(Result);
  if not ifExistsDataInParamRBookInterface(PPRBI) then exit;
  for i:=Low(PPRBI.Result) to High(PPRBI.Result) do begin
    if AnsiUpperCase(PPRBI.Result[i].FieldName)=AnsiUpperCase(FieldName) then begin
      for j:=Low(PPRBI.Result[i].Values) to High(PPRBI.Result[i].Values) do begin
        Result:=PPRBI.Result[i].Values[j];
        if Prepear then begin
          case PPRBI.Result[i].FieldType of
             ftInteger,ftWord,ftSmallint,ftFloat,ftCurrency,
             ftLargeint,ftDate,ftTime,ftDateTime: begin
               if VarType(Result)= varNull then
                 Result:=0;
             end;
             ftString,ftFixedChar,ftWideString,ftGuid: begin
               if VarType(Result)= varNull then
                 Result:='';
             end;
          end;
        end;  
        exit;
      end;
    end;
  end;
end;

function GetFirstValueFromPRBI(PPRBI: PParamRBookInterface; FieldName: Variant; Prepear: Boolean=true): Variant;
begin
  Result:=GetFirstValueFromParamRBookInterface(PPRBI,FieldName,Prepear);
end;

procedure GetStartAndEndByParamRBookInterface(PPRBI: PParamRBookInterface; var StartValue,EndValue: Integer);
var
   dx: Integer;
begin
   if not IsValidPointer(PPRBI) then exit;
   dx:=High(PPRBI.Result)-Low(PPRBI.Result)+1;
   if dx<=0 then exit;
   StartValue:=Low(PPRBI.Result[Low(PPRBI.Result)].Values);
   EndValue:=High(PPRBI.Result[Low(PPRBI.Result)].Values);
end;

procedure GetStartAndEndByPRBI(PPRBI: PParamRBookInterface; var StartValue,EndValue: Integer);
begin
  GetStartAndEndByParamRBookInterface(PPRBI,StartValue,EndValue);
end;

function GetValueByParamRBookInterface(PPRBI: PParamRBookInterface; const Index: Integer;
                                       FieldName: Variant; ValueType: Word): Variant;
var
    i: Integer;
begin
   VarClear(Result);
   if not IsValidPointer(PPRBI) then exit;
   for i:=Low(PPRBI.Result) to High(PPRBI.Result) do begin
      if AnsiUpperCase(PPRBI.Result[i].FieldName)=AnsiUpperCase(FieldName) then begin
        Result:=PPRBI.Result[i].Values[Index];
        case PPRBI.Result[i].FieldType of
           ftInteger,ftWord,ftSmallint,ftFloat,ftCurrency,
           ftLargeint,ftDate,ftTime,ftDateTime: begin
             if VarType(Result)= varNull then
               Result:=0;
           end;
           ftString,ftFixedChar,ftWideString,ftGuid: begin
             if VarType(Result)= varNull then
               Result:='';
           end;
        end;
        exit;
      end;
    end;
end;

function GetValueByPRBI(PPRBI: PParamRBookInterface; const Index: Integer; FieldName: Variant): Variant;
begin
  Result:=GetValueByParamRBookInterface(PPRBI,Index,FieldName,0);
end;

function GetFieldTypeByParamRBookInterface(PPRBI: PParamRBookInterface; FieldName: Variant): TFieldType;
var
  i: Integer;
begin
  Result:=ftUnknown;
  for i:=Low(PPRBI.Result) to High(PPRBI.Result) do begin
    if AnsiUpperCase(PPRBI.Result[i].FieldName)=AnsiUpperCase(FieldName) then begin
      Result:=PPRBI.Result[i].FieldType;
    end;
  end;
end;

function ifExistsDataInParamJournalInterface(PPJI: PParamJournalInterface): Boolean;
var
  ColumnCount,RowCount: Integer;
begin
  Result:=false;
  if not isValidPointer(PPJI) then exit;
  ColumnCount:=High(PPJI.Result)-Low(PPJI.Result)+1;
  if ColumnCount<=0 then exit;
  RowCount:=High(PPJI.Result[Low(PPJI.Result)].Values)-Low(PPJI.Result[Low(PPJI.Result)].Values)+1;
  Result:=RowCount>0;
end;

function ifExistsDataInPJI(PPJI: PParamJournalInterface): Boolean;
begin
  Result:=ifExistsDataInParamJournalInterface(PPJI);
end;

function GetFirstValueFromParamJournalInterface(PPJI: PParamJournalInterface; FieldName: Variant): Variant;
var
  i,j: Integer;
begin
  VarClear(Result);
  if not ifExistsDataInParamJournalInterface(PPJI) then exit;
  for i:=Low(PPJI.Result) to High(PPJI.Result) do begin
    if AnsiUpperCase(PPJI.Result[i].FieldName)=AnsiUpperCase(FieldName) then begin
      for j:=Low(PPJI.Result[i].Values) to High(PPJI.Result[i].Values) do begin
        Result:=PPJI.Result[i].Values[j];
        case PPJI.Result[i].FieldType of
           ftInteger,ftWord,ftSmallint,ftFloat,ftCurrency,
           ftLargeint,ftDate,ftTime,ftDateTime: begin
             if VarType(Result)= varNull then
               Result:=0;
           end;
           ftString,ftFixedChar,ftWideString,ftGuid: begin
             if VarType(Result)= varNull then
               Result:='';
           end;
        end;
        exit;
      end;
    end;
  end;
end;

function GetFirstValueFromPJI(PPJI: PParamJournalInterface; FieldName: Variant): Variant;
begin
  Result:=GetFirstValueFromParamJournalInterface(PPJI,FieldName);
end;

procedure GetStartAndEndByParamJournalInterface(PPJI: PParamJournalInterface; var StartValue,EndValue: Integer);
var
   dx: Integer;
begin
   if not IsValidPointer(PPJI) then exit;
   dx:=High(PPJI.Result)-Low(PPJI.Result)+1;
   if dx<=0 then exit;
   StartValue:=Low(PPJI.Result[Low(PPJI.Result)].Values);
   EndValue:=High(PPJI.Result[Low(PPJI.Result)].Values);
end;

procedure GetStartAndEndByPJI(PPJI: PParamJournalInterface; var StartValue,EndValue: Integer);
begin
  GetStartAndEndByParamJournalInterface(PPJI,StartValue,EndValue);
end;

function GetValueByParamJournalInterface(PPJI: PParamJournalInterface; const Index: Integer;
                                       FieldName: Variant; ValueType: Word): Variant;
var
    i: Integer;
begin
   VarClear(Result);
   if not IsValidPointer(PPJI) then exit;
   for i:=Low(PPJI.Result) to High(PPJI.Result) do begin
      if AnsiUpperCase(PPJI.Result[i].FieldName)=AnsiUpperCase(FieldName) then begin
        Result:=PPJI.Result[i].Values[Index];
        case PPJI.Result[i].FieldType of
           ftInteger,ftWord,ftSmallint,ftFloat,ftCurrency,
           ftLargeint,ftDate,ftTime,ftDateTime: begin
             if VarType(Result)= varNull then
               Result:=0;
           end;
           ftString,ftFixedChar,ftWideString,ftGuid: begin
             if VarType(Result)= varNull then
               Result:='';
           end;
        end;
        exit;
      end;
    end;
end;

function GetValueByPJI(PPJI: PParamJournalInterface; const Index: Integer; FieldName: Variant): Variant;
begin
  Result:=GetValueByParamJournalInterface(PPJI,Index,FieldName,0);
end;

procedure FillParamDocumentInterfaceFromDataSet(DataSet: TDataSet; PPDI: PParamDocumentInterface; Bookmarks: array of Pointer);
var
  i,j: Integer;
  bm: Pointer;
  incr: Integer;
begin
  if not isValidPointer(DataSet) then exit;
  if not isValidPointer(PPDI) then exit;
  if not isValidPointer(@Bookmarks) then exit;
  
  if not DataSet.active then exit;
  DataSet.DisableControls;
  bm:=nil;
  try
    bm:=DataSet.GetBookmark;
    SetLength(PPDI.Result,DataSet.FieldCount);
    for i:=0 to DataSet.FieldCount-1 do begin
      PPDI.Result[i].FieldName:=DataSet.Fields[i].FieldName;
      PPDI.Result[i].FieldType:=DataSet.Fields[i].DataType;
      PPDI.Result[i].Size:=DataSet.Fields[i].Size;
    end;
    incr:=0;
    if Length(Bookmarks)=0 then begin
      DataSet.First;
      while not DataSet.Eof do begin
        for i:=0 to DataSet.FieldCount-1 do begin
          SetLength(PPDI.Result[i].Values,incr+1);
          PPDI.Result[i].Values[incr]:=DataSet.Fields[i].Value;
        end;
        DataSet.Next;
        Inc(Incr);
      end;
    end else begin
     for i:=0 to DataSet.FieldCount-1 do begin
      for j:=Low(Bookmarks) to High(Bookmarks) do begin
        SetLength(PPDI.Result[i].Values,Length(Bookmarks));
        DataSet.GotoBookmark(Bookmarks[j]);
        PPDI.Result[i].Values[j]:=DataSet.Fields[i].Value;
      end;
     end; 
    end;  
  finally
    DataSet.GotoBookmark(bm);
    DataSet.EnableControls;
  end;
end;

procedure FillPDIFromDataSet(DataSet: TDataSet; PPDI: PParamDocumentInterface; Bookmarks: array of Pointer);
begin
  FillParamDocumentInterfaceFromDataSet(DataSet,PPDI,Bookmarks);
end;

function TranslatePermission(DBPermission: TTypeDBPermission): string;
begin
  Result:='';
  Case DBPermission of
    ttpSelect: Result:=SelConst;
    ttpInsert: Result:=InsConst;
    ttpUpdate: Result:=UpdConst;
    ttpDelete: Result:=DelConst;
    ttpExecute: Result:=ExecConst;
  end;
end;

function TranslateOrder(DbOrder: TTypeDbOrder): string;
begin
  Result:='';
  case DbOrder of
    tdboNone: Result:='';
    tdboAsc: Result:='asc';
    tdboDesc: Result:='desc';
  end;
end;

function TranslateFilter(DbFilter: TTypeDbFilter): string;
begin
  Result:='';
  case DbFilter of
    tdbfAnd: Result:='and';
    tdbfOr: Result:='or';
  end;
end;

function TranslateCondition(DbCondition: TTypeDbCondition): string;
begin
  Result:='';
  case DbCondition of
    tdbcEqual: Result:='=';
    tdbcGreater: Result:='>';
    tdbcLess: Result:='<';
    tdbcNotEqual: Result:='<>';
    tdbcEqualGreater: Result:='>=';
    tdbcEqualLess: Result:='<=';
    tdbcLike: Result:=' like ';
    tdbcIsNull: Result:=' is null';
    tdbcIsNotNull: Result:=' is not null';
  end;
end;

function TranslateInterfaceAction(Action: TTypeInterfaceAction): string;
begin
  Result:='';
  Case Action of
    ttiaView: Result:='просмотр';
    ttiaAdd: Result:='вставку';
    ttiaChange: Result:='изменение';
    ttiaDelete: Result:='удаление';
  end;
end;

function Iff(isTrue: Boolean; TrueValue, FalseValue: Variant): Variant;
begin
  if isTrue then Result:=TrueValue
  else Result:=FalseValue;
end;

procedure WriteParam(const Section,Param: String; Value: Variant);
begin
  _WriteParam(PChar(Section),PChar(Param),Value);
end;

function ReadParam(const Section,Param: String; Default: Variant): Variant; 
begin
  Result:=_ReadParam(PChar(Section),PChar(Param),Default);
end;

function isValidKey(Key: Char): Boolean;
begin
  Result:=(Byte(Key) in [byte('A')..byte('z')]) or
          (Byte(Key) in [byte('А')..byte('я')])or
          (Byte(Key) in [byte('0')..byte('9')]);
end;

function isValidIntegerKey(Key: Char): Boolean;
begin
  Result:=(Byte(Key) in [byte('0')..byte('9')]);
end;

function GetFirstWord(s: string; SetOfChar: TSetOfChar; var Pos: Integer): string;
var
  tmps: string;
  i: integer;
begin
  for i:=1 to Length(s) do begin
    if S[i] in SetOfChar then break;
    tmps:=tmps+S[i];
    Pos:=i;
  end;
  Result:=tmps;
end;

function GetNextWord(s: string; SetOfChar: TSetOfChar; var Pos: Integer): string;
var
  i: Integer;
begin
  for i:=1 to Length(s) do begin
    if s[i] in SetOfChar then break;
    Result:=Result+s[i];
    Pos:=i;
  end;
end;

function GetPrevWord(s: string; SetOfChar: TSetOfChar; var Pos: Integer): string;
var
  i: Integer;
begin
  for i:=Length(s) downto 1 do begin
    if s[i] in SetOfChar then break;
    Result:=s[i]+Result;
    Pos:=Length(s)-i;
  end;
end;

function RepeatStr(const S: string; const Count: Int64): string;
var
  i: Integer;
begin
  Result:='';
  for i:=0 to Count-1 do begin
    Result:=Result+S;
  end;
end;

function GetDllName: string;
var
  dllname: array[0..MAX_PATH] of char;
begin
  FillChar(dllname,SizeOf(dllname),0);
  GetModuleFileName(HInstance,@dllname,SizeOf(dllname));
  Result:=dllName;
end;

function GetColumnByFieldName(Columns: TDBGridColumns; FieldName: string): TColumn;
var
  i: Integer;
  cl: TColumn;
begin
  Result:=nil;
  for i:=0 to Columns.Count-1 do begin
    cl:=Columns.Items[i];
    if AnsiSameText(cl.FieldName,FieldName) then begin
      Result:=cl;
      exit;
    end;
  end;
end;

function GetUniqueFileName(const Path: string=''; const Ext: String=''): string;
begin
  Result:=Path+CreateClassID+Ext;
end;

function GetLabelByWinControl(WinControl: TWinControl): TLabel;
var
  i: Integer;
begin
  Result:=nil;
  if WinControl=nil then exit;
  if WinControl.Owner=nil then exit;
  if not (WinControl.Owner is TCustomForm) then exit;
  for i:=0 to TCustomForm(WinControl.Owner).ComponentCount-1 do begin
    if TCustomForm(WinControl.Owner).Components[i] is TLabel then
      if TLabel(TCustomForm(WinControl.Owner).Components[i]).FocusControl=WinControl then begin
        Result:=TLabel(TCustomForm(WinControl.Owner).Components[i]);
        break;
      end;
  end;
end;

function GetRusNameByElementClass(ElementClass: TClass): string;
begin
  Result:='Неизвестный элемент';
  if ElementClass=TLabel then Result:='Метка';
  if ElementClass=TEdit then Result:='Поле ввода';
  if ElementClass=TComboBox then Result:='Выпадающий список';
  if ElementClass=TListBox then Result:='Список';
  if ElementClass=TMemo then Result:='Многострочное поле ввода';
  if ElementClass=TButton then Result:='Кнопка';
  if ElementClass=TBitBtn then Result:='Кнопка';
end;

function ExistsExcel: Boolean;
begin
  Result:=true;
end;

const
  ENG_arr: array[0..17] of char=('E','e','T','O','o','P','p','A','a','H','K','k','X','x','C','c','B','M');
  RUS_arr: array[0..17] of char=('Е','е','Т','О','о','Р','р','А','а','Н','К','к','Х','х','С','с','В','М');

procedure AddEnglishToWords(AWords: TStringList);
var
  i: Integer;
begin
  for i:=0 to Length(Eng_arr)-1 do begin
    AWords.Add(Eng_arr[i]);
  end;
end;

function ConvertExtended(InStr: string; ConvertType: TConvertType): string;

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
      ch:=GetCharFromArray(ENG_arr,RUS_arr,ch);
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
      ch:=GetCharFromArray(RUS_arr,ENG_arr,ch);
      tmps:=tmps+ch;
    end;
    Result:=tmps;
  end;

begin
  Result:=InStr;
  case ConvertType of
    ctRussian: Result:=toRussian(InStr);
    ctEnglish: Result:=toEnglish(InStr);
  end;
end;

function WordReplace(const S, OldPattern, NewPattern: string; Flags: TReplaceFlags; WordDelim: TSetOfChar): string;
var
  SearchStr, Patt, NewStr: string;
  Offset: Integer;
  Ch: Char;
begin
  if rfIgnoreCase in Flags then
  begin
    SearchStr := AnsiUpperCase(S);
    Patt := AnsiUpperCase(OldPattern);
  end else
  begin
    SearchStr := S;
    Patt := OldPattern;
  end;
  NewStr := S;
  Result := '';
  while SearchStr <> '' do
  begin
    Offset := AnsiPos(Patt, SearchStr);
    if Offset = 0 then
    begin
      Result := Result + NewStr;
      Break;
    end;
    Ch:=Copy(SearchStr,Offset+Length(OldPattern),1)[1];
    if Ch in WordDelim then begin
      Result := Result + Copy(NewStr, 1, Offset - 1) + NewPattern;
      NewStr := Copy(NewStr, Offset + Length(OldPattern), MaxInt);
    end else begin
      Result := Result + Copy(NewStr, 1, Offset - 1) + OldPattern;
      NewStr := Copy(NewStr, Offset + Length(OldPattern), MaxInt);
    end;  
    if not (rfReplaceAll in Flags) then
    begin
      Result := Result + NewStr;
      Break;
    end;
    SearchStr := Copy(SearchStr, Offset + Length(Patt), MaxInt);
  end;
end;

procedure FillWordsByString(S: string; str: TStringList);
var
  Pos: Integer;
  word: string;
  incPos: Integer;
  isInc: Boolean;
const
  Separators: set of char = [#00,' ','-',#13, #10,'.',',','/','\', '#', '"', '''','!','?','$','@',
                             ':','+','%','*','(',')',';','=','{','}','[',']', '{', '}', '<', '>'];
begin
  if Trim(S)='' then exit;
  incPos:=0;
  while true do begin
    Pos:=1;
    word:=GetFirstWord(s,Separators,Pos);
    if (s[Pos]=#13)or(s[Pos]=#10) then
      isInc:=false
    else isInc:=true;

    s:=Copy(s,Pos+1,Length(s)-Pos);
    if (Trim(word)<>'')and
       (Length(word)>1) then
          str.AddObject(word,TObject(Pointer(incPos)));
    if Trim(s)='' then exit;

    if isInc then
     incPos:=incPos+Pos;
  end;
end;


function GetFilterString(Str: TStringList; Operator: String): String;
var
  i: Integer;
  Flag: Boolean;
begin
  Result:='';
  Flag:=false;
  for i:=0 to Str.Count-1 do begin
    if Flag and (Str.Strings[i]<>'') then begin
      Result:=Format('%s%s%s',[Result,Operator,Str.Strings[i]]);
    end;
    if not Flag and (Str.Strings[i]<>'') then begin
      Flag:=true;
      Result:=Str.Strings[i];
    end;
  end;
end;

procedure GetDirFiles(Dir: String; FileDirs: TStringList; OnlyFiles, StopFirst: Boolean);
var
  AttrWord: Word;
  FMask: String;
  MaskPtr: PChar;
  Ptr: Pchar;
  FileInfo: TSearchRec;
  S: string;
begin
  if StopFirst then begin
    if FileDirs.Count>0 then
      exit;
  end;
  if not DirectoryExists(Dir) then exit;
  AttrWord :=SysUtils.faAnyFile+
             SysUtils.faReadOnly+
             SysUtils.faHidden+
             SysUtils.faSysFile+
             SysUtils.faVolumeID+
             SysUtils.faDirectory+
             SysUtils.faArchive;
  if SetCurrentDirectory(Pchar(Dir)) then begin
    FMask:='*.*';
    MaskPtr := PChar(FMask);
    while MaskPtr <> nil do begin
      Ptr := StrScan (MaskPtr, ';');
      if Ptr <> nil then
        Ptr^ := #0;
      if FindFirst(MaskPtr, AttrWord, FileInfo) = 0 then begin
        repeat
          S:=Dir+'\'+FileInfo.Name;
          if (FileInfo.Attr and faDirectory <> 0) then begin
            if (FileInfo.Name<>'.') and (FileInfo.Name<>'..') and not OnlyFiles then begin
              with FileInfo.FindData do begin
                GetDirFiles(S,FileDirs,OnlyFiles,StopFirst);
                if not OnlyFiles then begin
                  FileDirs.Add(S);
                  if StopFirst then break;
                end;  
              end;
            end;
          end else begin
            with FileInfo.FindData do begin
              FileDirs.Add(S);
              if StopFirst then break;
            end;  
          end;
        until FindNext(FileInfo) <> 0;
        FindClose(FileInfo);
      end;
      if Ptr <> nil then begin
        Ptr^ := ';';
        Inc (Ptr);
      end;
      MaskPtr := Ptr;
    end;
  end;
end;

end.
