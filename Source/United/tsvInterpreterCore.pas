unit tsvInterpreterCore;

interface

uses Windows, Classes, UMainUnited, Graphics, db;

const
  INTERPRETER_INVALID_HANDLE=0;
  INTERPRETERCONST_INVALID_HANDLE=0;
  INTERPRETERCLASS_INVALID_HANDLE=0;
  INTERPRETERCLASSMETHOD_INVALID_HANDLE=0;
  INTERPRETERCLASSPROPERTY_INVALID_HANDLE=0;
  INTERPRETERFUN_INVALID_HANDLE=0;
  INTERPRETEREVENT_INVALID_HANDLE=0;
  INTERPRETERVAR_INVALID_HANDLE=0;
  LIBRARYINTERPRETER_INVALID_HANDLE=0;

const
  ConstIsValidInterpreterConst='IsValidInterpreterConst';
  ConstCreateInterpreterConst='CreateInterpreterConst';
  ConstFreeInterpreterConst='FreeInterpreterConst';
  ConstGetInterpreterConsts='GetInterpreterConsts';
  ConstIsValidInterpreterClass='IsValidInterpreterClass';
  ConstCreateInterpreterClass='CreateInterpreterClass';
  ConstFreeInterpreterClass='FreeInterpreterClass';
  ConstCreateInterpreterClassProperty='CreateInterpreterClassProperty';
  ConstFreeInterpreterClassProperty='FreeInterpreterClassProperty';
  ConstCreateInterpreterClassMethod='CreateInterpreterClassMethod';
  ConstFreeInterpreterClassMethod='FreeInterpreterClassMethod';
  ConstGetInterpreterClasses='GetInterpreterClasses';
  ConstIsValidInterpreterFun='IsValidInterpreterFun';
  ConstCreateInterpreterFun='CreateInterpreterFun';
  ConstFreeInterpreterFun='FreeInterpreterFun';
  ConstGetInterpreterFuns='GetInterpreterFuns';
  ConstIsValidInterpreterEvent='IsValidInterpreterEvent';
  ConstCreateInterpreterEvent='CreateInterpreterEvent';
  ConstFreeInterpreterEvent='FreeInterpreterEvent';
  ConstGetInterpreterEvents='GetInterpreterEvents';
  ConstIsValidInterpreterVar='IsValidInterpreterVar';
  ConstCreateInterpreterVar='CreateInterpreterVar';
  ConstFreeInterpreterVar='FreeInterpreterVar';
  ConstGetInterpreterVars='GetInterpreterVars';
  ConstIsValidLibraryInterpreter='IsValidLibraryInterpreter';
  ConstCreateLibraryInterpreter='CreateLibraryInterpreter';
  ConstFreeLibraryInterpreter='FreeLibraryInterpreter';
  ConstGetLibraryInterpreterHandleByGUID='GetLibraryInterpreterHandleByGUID';
  ConstGetLibraryInterpreters='GetLibraryInterpreters';
  ConstCallLibraryInterpreterFun='CallLibraryInterpreterFun';



 { max arguments to functions - small values increase performance }
  MaxArgs = 32;

 { max fields allowed in records }
  MaxRecFields = 32;

const
 { additional variant types - TVarData.VType }
  varObject  = $0010;
  varClass   = $0011;
  varPointer = $0012;
  varSet     = $0013;
//  varArray   = $0014;
  varRecord  = $0015;

type

  TExecProcParam=class(TCollectionItem)
  private
    FParamName: string;
    FValue: Variant;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy;override;
    procedure Assign(Source: TPersistent); override;
  published
    property ParamName: String read FParamName write FParamName;
    property Value: Variant read FValue write FValue;
  end;

  TExecProcParamClass=class of TExecProcParam;

  TExecProcedure=class;

  TExecProcParams=class(TCollection)
  private
    FExecProcedure: TExecProcedure;
    function GetExecProcParam(Index: Integer): TExecProcParam;
    procedure SetExecProcParam(Index: Integer; Value: TExecProcParam);
  protected
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TExecProcedure);
    function  Add: TExecProcParam;
    property Items[Index: Integer]: TExecProcParam read GetExecProcParam write SetExecProcParam;
  end;

  TInterface=class;

  TExecProcedure=class(TPersistent)
  private
    Owner: TInterface;
    FName: string;
    FParams: TExecProcParams;
    FResult: Variant;
    procedure SetParams(Value: TExecProcParams);
  public
    constructor Create(AOwner: TInterface);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Name: string read FName write FName;
    property Params: TExecProcParams read FParams write SetParams;
    property Result: Variant read FResult write FResult;
  end;

  TInterface=class(TComponent)
  private
    FInterfaceName: string;
    FExecProcedure: TExecProcedure;

    procedure SetExecProcedure(Value: TExecProcedure);
  public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy; override;

    function View: Boolean; virtual;
    function Refresh: Boolean; virtual;
    function Close: Boolean; virtual;
    function ExecProc: Boolean; virtual;

    property ExecProcedure: TExecProcedure read FExecProcedure write SetExecProcedure;
    property InterfaceName: string read FInterfaceName write FInterfaceName;
  end;

  TVisual=class(TPersistent)
  private
    Owner: TInterface;
    FTypeView: TTypeViewInterface;
    FMultiSelect: Boolean;
  public
    constructor Create(AOwner: TInterface);
    procedure Assign(Source: TPersistent); override;
  published
    property TypeView: TTypeViewInterface read FTypeView write FTypeView;
    property MultiSelect: Boolean read FMultiSelect write FMultiSelect;
  end;

  TLocate=class(TPersistent)
  private
    Owner: TInterface;
    FKeyFields: String;
    FKeyValues: Variant;
    FOptions: TLocateOptions;
  public
    constructor Create(AOwner: TInterface);
    procedure Assign(Source: TPersistent); override;
  published
    property KeyFields: String read FKeyFields write FKeyFields;
    property KeyValues: Variant read FKeyValues write FKeyValues;
    property Options: TLocateOptions read FOptions write FOptions;
  end;

  TCondition=class(TPersistent)
  private
    Owner: TInterface;
    FOrderStr: TStrings;
    FWhereStr: TStrings;
    procedure SetOrderStr(Value: TStrings);
    procedure SetWhereStr(Value: TStrings);
  public
    constructor Create(AOwner: TInterface);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property OrderStr: TStrings read FOrderStr write SetOrderStr;
    property WhereStr: TStrings read FWhereStr write SetWhereStr;
  end;

  TSql=class(TPersistent)
  private
    Owner: TInterface;
    FSelect: TStrings;
    FInsert: TStrings;
    FUpdate: TStrings;
    FDelete: TStrings;
    procedure SetSelect(Value: TStrings);
    procedure SetInsert(Value: TStrings);
    procedure SetUpdate(Value: TStrings);
    procedure SetDelete(Value: TStrings);
  public
    constructor Create(AOwner: TInterface);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Select: TStrings read FSelect write SetSelect;
    property Insert: TStrings read FInsert write SetInsert;
    property Update: TStrings read FUpdate write SetUpdate;
    property Delete: TStrings read FDelete write SetDelete;
  end;

  TConditionRBook=class(TCondition)
  end;
  
  TiRBookInterface=class(TInterface, IAdditionalComponent)
  private
    FVisual: TVisual;
    FDataSet: TDataSet;
    FLocate: TLocate;
    FCondition: TConditionRBook;
    FSql: TSql;
    procedure SetVisual(Value: TVisual);
    procedure SetCondition(Value: TConditionRBook);
    procedure SetLocate(Value: TLocate);
    procedure SetSql(Value: TSql);
    procedure SetDataSet(Value: TDataSet);
  public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function View: Boolean; override;
    function Refresh: Boolean; override;
  published
    property Visual: TVisual read FVisual write SetVisual;
    property ReturnData: TDataSet read FDataSet write SetDataSet;
    property Condition: TConditionRBook read FCondition write SetCondition;
    property Locate: TLocate read FLocate write SetLocate;
    property Sql: TSql read FSql write SetSql;

    property ExecProcedure;
    property InterfaceName;

  end;

  TiReportInterface=class(TInterface, IAdditionalComponent)
  public
    function View: Boolean; override;
  published
    property ExecProcedure;
    property InterfaceName;
  end;

  TiDocumentInterface=class(TInterface, IAdditionalComponent)
  public
    function View: Boolean; override;
  published
    property ExecProcedure;
    property InterfaceName;
  end;

  TiWizardInterface=class(TInterface, IAdditionalComponent)
  public
    function View: Boolean; override;
  published
    property ExecProcedure;
    property InterfaceName;
  end;

  TConditionJournal=class(TCondition)
  private
    FWhereStrNoRemoved: TStrings;
    procedure SetWhereStrNoRemoved(Value: TStrings);
  public
    constructor Create(AOwner: TInterface);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property WhereStrNoRemoved: TStrings read FWhereStrNoRemoved write SetWhereStrNoRemoved;
  end;

  TiJournalInterface=class(TInterface, IAdditionalComponent)
  private
    FVisual: TVisual;
    FDataSet: TDataSet;
    FLocate: TLocate;
    FCondition: TConditionJournal;
    procedure SetVisual(Value: TVisual);
    procedure SetCondition(Value: TConditionJournal);
    procedure SetLocate(Value: TLocate);
    procedure SetDataSet(Value: TDataSet);
  public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function View: Boolean; override;
    function Refresh: Boolean; override;
  published
    property Visual: TVisual read FVisual write SetVisual;
    property ReturnData: TDataSet read FDataSet write SetDataSet;
    property Condition: TConditionJournal read FCondition write SetCondition;
    property Locate: TLocate read FLocate write SetLocate;

    property ExecProcedure;
    property InterfaceName;
  end;

  TiServiceInterface=class(TInterface, IAdditionalComponent)
  public
    function View: Boolean; override;
  published
    property ExecProcedure;
    property InterfaceName;
  end;

  TiNoneInterface=class(TInterface, IAdditionalComponent)
  public
    function View: Boolean; override;
  published
    property ExecProcedure;
    property InterfaceName;
  end;

  PGetInterpreterConst=^TGetInterpreterConst;
  TGetInterpreterConst=packed record
    Identifer: PChar;
    Value: Variant;
    TypeInfo: Pointer;
    Hint: PChar;
  end;

  TGetInterpreterConstProc=procedure (Owner: Pointer; PGIC: PGetInterpreterConst); stdcall;

  PCreateInterpreterConst=^TCreateInterpreterConst;
  TCreateInterpreterConst=packed record
    Identifer: PChar;
    Value: Variant;
    TypeInfo: Pointer;
    Hint: PChar;
    TypeCreate: TTypeCreate;
  end;

  PGetInterpreterVar=^TGetInterpreterVar;
  TGetInterpreterVar=packed record
    Identifer: PChar;
    Value: Variant;
    TypeValue: Variant;
    TypeText: PChar;
    Hint: PChar;
  end;

  TGetInterpreterVarProc=procedure (Owner: Pointer; PGIV: PGetInterpreterVar); stdcall;

  PCreateInterpreterVar=^TCreateInterpreterVar;
  TCreateInterpreterVar=packed record
    Identifer: PChar;
    Value: Variant;
    TypeValue: Variant;
    TypeText: PChar;
    Hint: PChar;
    TypeCreate: TTypeCreate;
    hCreate: THandle;
  end;

  TValueArray = array[0..MaxArgs] of Variant;

  TArguments=class
  public
    Values: TValueArray;
    Count: Integer;
    Obj: TObject;
    hInterpreter: THandle;
  end;

  TEvent=class
  private
    FhInterpreter: THandle;
    FInstance: TObject;
    FArgs: TArguments;
    FFunName: string;
    function GetArgs: TArguments;
    function GetFunName: PChar;
  protected
    function CallFunction(Params: array of Variant): Variant;
  public
    constructor Create(AhInterpreter: THandle; AInstance: TObject; AFunName: PChar);
    destructor Destroy; override;
    property Args: TArguments read GetArgs;
    property hInterpreter: THandle read FhInterpreter;
    property Instance: TObject read FInstance;
    property FunName: PChar read GetFunName;
  end;   

  TEventClass=class of TEvent;

  TInterpreterReadProc=procedure(var Value: Variant; Args: TArguments);
  TInterpreterWriteProc=procedure(const Value: Variant; Args: TArguments);

  PInterpreterProcParam=^TInterpreterProcParam;
  TInterpreterProcParam=packed record
    ParamText: PChar;
    ParamType: DWord;
  end;

  TArrOfInterpreterProcParam=array of TInterpreterProcParam;

  PGetInterpreterClassMethod=^TGetInterpreterClassMethod;
  TGetInterpreterClassMethod=packed record
    Identifer: PChar;
    Proc: TInterpreterReadProc;
    ProcParams: TArrOfInterpreterProcParam;
    ProcResultType: TInterpreterProcParam;
    Hint: PChar;
  end;

  PGetInterpreterClassProperty=^TGetInterpreterClassProperty;
  TGetInterpreterClassProperty=packed record
    Identifer: PChar;
    ReadProc: TInterpreterReadProc;
    ReadProcParams: TArrOfInterpreterProcParam;
    ReadProcResultType: TInterpreterProcParam;
    WriteProc: TInterpreterWriteProc;
    WriteProcParams: TArrOfInterpreterProcParam;
    isIndexProperty: Boolean;
    Hint: PChar;
  end;

  PGetInterpreterClass=^TGetInterpreterClass;
  TGetInterpreterClass=packed record
    ClassType: TClass;
    Hint: PChar;
    Methods: array of TGetInterpreterClassMethod;
    Properties: array of TGetInterpreterClassProperty;
  end;

  TGetInterpreterClassProc=procedure (Owner: Pointer; PGICL: PGetInterpreterClass); stdcall;

  PCreateInterpreterClass=^TCreateInterpreterClass;
  TCreateInterpreterClass=packed record
    ClassType: TClass;
    Hint: PChar;
    TypeCreate: TTypeCreate;
  end;

  PCreateInterpreterClassMethod=^TCreateInterpreterClassMethod;
  TCreateInterpreterClassMethod=packed record
    Identifer: PChar;
    Proc: TInterpreterReadProc;
    ProcParams: TArrOfInterpreterProcParam;
    ProcResultType: TInterpreterProcParam;
    Hint: PChar;
    TypeCreate: TTypeCreate;
  end;

  PCreateInterpreterClassProperty=^TCreateInterpreterClassProperty;
  TCreateInterpreterClassProperty=packed record
    Identifer: PChar;
    ReadProc: TInterpreterReadProc;
    ReadProcParams: TArrOfInterpreterProcParam;
    ReadProcResultType: TInterpreterProcParam;
    WriteProc: TInterpreterWriteProc;
    WriteProcParams: TArrOfInterpreterProcParam;
    isIndexProperty: Boolean;
    Hint: PChar;
  end;

  PGetInterpreterFun=^TGetInterpreterFun;
  TGetInterpreterFun=TGetInterpreterClassMethod;

  TGetInterpreterFunProc=procedure (Owner: Pointer; PGIF: PGetInterpreterFun); stdcall;

  PCreateInterpreterFun=^TCreateInterpreterFun;
  TCreateInterpreterFun=TCreateInterpreterClassMethod;

  PGetInterpreterEvent=^TGetInterpreterEvent;
  TGetInterpreterEvent=packed record
    Identifer: PChar;
    Hint: PChar;
    EventClass: TEventClass;
    EventProc: Pointer;
    TypeCreate: TTypeCreate;
  end;

  TGetInterpreterEventProc=procedure (Owner: Pointer; PGIE: PGetInterpreterEvent); stdcall;
  
  PCreateInterpreterEvent=^TCreateInterpreterEvent;
  TCreateInterpreterEvent=packed record
    Identifer: PChar;
    Hint: PChar;
    EventClass: TEventClass;
    EventProc: Pointer;
    TypeCreate: TTypeCreate;
  end;


  TTypeMessageInterpreterProc=(tmiWarning,tmiHint,tmiError,tmiOk);
  TMessageInterpreterProc=procedure (Owner: Pointer; InterpreterHandle: THandle; TypeMessage: TTypeMessageInterpreterProc;
                                     Line,Pos: Integer; UnitName,Message: PChar);stdcall;

  PGetInterpreterUnit=^TGetInterpreterUnit;
  TGetInterpreterUnit=packed record
    Code: PChar;
  end;

  TGetInterpreterUnitProc=procedure (Owner: Pointer; PGIU: PGetInterpreterUnit); stdcall;
  TGetInterpreterUnitsProc=procedure (Owner,ProcOwner: Pointer; Proc: TGetInterpreterUnitProc); stdcall;

  PGetInterpreterForm=^TGetInterpreterForm;
  TGetInterpreterForm=packed record
    Form: PChar;
  end;

  TGetInterpreterFormProc=procedure (Owner: Pointer; PGIF: PGetInterpreterForm); stdcall;
  TGetInterpreterFormsProc=procedure (Owner,ProcOwner: Pointer; Proc: TGetInterpreterFormProc); stdcall;

  PGetInterpreterDocument=^TGetInterpreterDocument;
  TGetInterpreterDocument=packed record
    DocumentName: PChar;
    DocumentSize: Integer;
    Document: Pointer;
    DocumentClass: PChar;
  end;
  
  TGetInterpreterDocumentProc=procedure (Owner: Pointer; PGID: PGetInterpreterDocument; var isBreak: Boolean); stdcall;
  TGetInterpreterDocumentsProc=procedure (Owner,ProcOwner: Pointer; Proc: TGetInterpreterDocumentProc); stdcall;

  PCreateInterpreter=^TCreateInterpreter;
  TCreateInterpreter=packed record
  end;

  TOnRunInterpreterProc=procedure (Owner: Pointer); stdcall;
  TOnResetInterpreterProc=procedure (Owner: Pointer); stdcall;
  TOnFreeInterpreterProc=procedure (Owner: Pointer); stdcall;

  PSetInterpreterParam=^TSetInterpreterParam;
  TSetInterpreterParam=packed record
    MessageProc: TMessageInterpreterProc;
    GetUnitsProc: TGetInterpreterUnitsProc;
    GetFormsProc: TGetInterpreterFormsProc;
    GetDocumentsProc: TGetInterpreterDocumentsProc;
    OnRunProc: TOnRunInterpreterProc;
    OnResetProc: TOnResetInterpreterProc;
    OnFreeProc: TOnFreeInterpreterProc;
    hInterface: THandle;
    Param: Pointer;
    isExecProc: Boolean;
    ExecProcParams: Pointer;
  end;

  TCreateInterpreterProc=function (PCI: PCreateInterpreter): THandle; stdcall;
  TRunInterpreterProc=function (InterpreterHandle: THandle): Boolean;stdcall;
  TResetInterpreterProc=function (InterpreterHandle: THandle): Boolean;stdcall;
  TFreeInterpreterProc=function (InterpreterHandle: THandle): Boolean;stdcall;
  TIsValidInterpreterProc=function (InterpreterHandle: THandle): Boolean;stdcall;
  TSetInterpreterParamsProc=function (InterpreterHandle: THandle; Owner: Pointer; PSIP: PSetInterpreterParam): Boolean; stdcall;
  TCallInterpreterFunProc=function (InterpreterHandle: THandle; Instance: TObject; Args: TArguments; FunName: PChar): Variant; stdcall;
  TGetCreateInterfaceNameProc=function: PChar; stdcall;


   { PInterpreterIdentiferItem=^TInterpreterIdentiferItem;
  TInterpreterIdentiferItem=packed record
    Caption: PChar;
    Brush: TBrush;
    Font: TFont;
    Pen: TPen;
  end;

  PInterpreterIdentiferItemCaption=^TInterpreterIdentiferItemCaption;
  TInterpreterIdentiferItemCaption=packed record
    AutoSize: Boolean;
    Alignment: TAlignment;
    Caption: PChar;
    Brush: TBrush;
    Font: TFont;
    Pen: TPen;
    Width: Integer;
  end;}

  PGetInterpreterIdentiferItemCaption=^TGetInterpreterIdentiferItemCaption;
  TGetInterpreterIdentiferItemCaption=packed record
    AutoSize: Boolean;
    Alignment: TAlignment;
    Caption: PChar;
    Brush: TBrush;
    Font: TFont;
    Pen: TPen;
    Width: Integer;
  end;

  PGetInterpreterIdentiferItem=^TGetInterpreterIdentiferItem;
  TGetInterpreterIdentiferItem=packed record
    Caption: PChar;
    Brush: TBrush;
    Font: TFont;
    Pen: TPen;
    CaptionEx: array of PGetInterpreterIdentiferItemCaption; 
  end;

  TGetInterpreterIdentiferItemProc=procedure(Owner: Pointer; PGIII: PGetInterpreterIdentiferItem); stdcall;

  TGetDesignComponentProc=procedure(Owner: Pointer; Component: TComponent); stdcall;
  TGetDesignComponentsProc=procedure(Owner,ProcOwner: Pointer; Proc: TGetDesignComponentProc); stdcall;

  PGetInterpreterIdentiferParams=^TGetInterpreterIdentiferParams;
  TGetInterpreterIdentiferParams=packed record
    Code: PChar;
    Pos: Integer;
    GetInterpreterIdentiferItemProc: TGetInterpreterIdentiferItemProc;
    DesignClassType: TClass;

    ColorVar: TColor;
    ColorProcedure: TColor;
    ColorFunction: TColor;
    ColorType: TColor;
    ColorProperty: TColor;
    ColorConst: TColor;
    ColorBackGround: TColor;
    ColorCaption: TColor;
    ColorParams: TColor;
    ColorHint: TColor;
  end;

  TGetInterpreterIdentifersProc=procedure (Owner: Pointer; PGIIP: PGetInterpreterIdentiferParams); stdcall;

  PGetLibraryInterpreter=^TGetLibraryInterpreter;
  TGetLibraryInterpreter=packed record
    GUID: PChar;
    Hint: PChar;
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

  TGetLibraryInterpreterProc=procedure (Owner: Pointer; PGLI: PGetLibraryInterpreter); stdcall;

  PCreateLibraryInterpreter=^TCreateLibraryInterpreter;
  TCreateLibraryInterpreter=packed record
    GUID: PChar;
    Hint: PChar;
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

  function _CreateInterpreterConst(PCIC: PCreateInterpreterConst): THandle; stdcall;
                                        external MainExe name ConstCreateInterpreterConst;
  function _FreeInterpreterConst(InterpreterConstHandle: THandle): Boolean; stdcall;
                                      external MainExe name ConstFreeInterpreterConst;
  procedure _GetInterpreterConsts(Owner: Pointer; Proc: TGetInterpreterConstProc); stdcall;
                                  external MainExe name ConstGetInterpreterConsts;

  function _CreateInterpreterClass(PCICL: PCreateInterpreterClass): THandle; stdcall;
                                        external MainExe name ConstCreateInterpreterClass;
  function _FreeInterpreterClass(InterpreterClassHandle: THandle): Boolean; stdcall;
                                      external MainExe name ConstFreeInterpreterClass;
  procedure _GetInterpreterClasses(Owner: Pointer; Proc: TGetInterpreterClassProc); stdcall;
                                   external MainExe name ConstGetInterpreterClasses;

  function _CreateInterpreterClassProperty(InterpreterClassHandle: THandle; PCICL: PCreateInterpreterClassProperty): THandle; stdcall;
                                        external MainExe name ConstCreateInterpreterClassProperty;
  function _FreeInterpreterClassProperty(InterpreterClassPropertyHandle: THandle): Boolean; stdcall;
                                      external MainExe name ConstFreeInterpreterClassProperty;

  function _CreateInterpreterClassMethod(InterpreterClassHandle: THandle; PCICM: PCreateInterpreterClassMethod): THandle; stdcall;
                                        external MainExe name ConstCreateInterpreterClassMethod;
  function _FreeInterpreterClassMethod(InterpreterClassMethodHandle: THandle): Boolean; stdcall;
                                      external MainExe name ConstFreeInterpreterClassMethod;


  function _CreateInterpreterFun(PCIF: PCreateInterpreterFun): THandle; stdcall;
                                 external MainExe name ConstCreateInterpreterFun;
  function _FreeInterpreterFun(InterpreterFunHandle: THandle): Boolean; stdcall;
                               external MainExe name ConstFreeInterpreterFun;
  procedure _GetInterpreterFuns(Owner: Pointer; Proc: TGetInterpreterFunProc); stdcall;
                               external MainExe name ConstGetInterpreterFuns;

  function _CreateInterpreterEvent(PCIE: PCreateInterpreterEvent): THandle; stdcall;
                                 external MainExe name ConstCreateInterpreterEvent;
  function _FreeInterpreterEvent(InterpreterEventHandle: THandle): Boolean; stdcall;
                               external MainExe name ConstFreeInterpreterEvent;
  procedure _GetInterpreterEvents(Owner: Pointer; Proc: TGetInterpreterEventProc); stdcall;
                               external MainExe name ConstGetInterpreterEvents;


  function _CreateInterpreterVar(PCIV: PCreateInterpreterVar): THandle; stdcall;
                                 external MainExe name ConstCreateInterpreterVar;
  function _FreeInterpreterVar(InterpreterVarHandle: THandle): Boolean; stdcall;
                               external MainExe name ConstFreeInterpreterVar;
  procedure _GetInterpreterVars(Owner: Pointer; Proc: TGetInterpreterVarProc); stdcall;
                                external MainExe name ConstGetInterpreterVars;

  function _CreateLibraryInterpreter(PCIL: PCreateLibraryInterpreter): THandle; stdcall;
                                     external MainExe name ConstCreateLibraryInterpreter;
  function _FreeLibraryInterpreter(LibraryInterpreterHandle: THandle): Boolean; stdcall;
                                   external MainExe name ConstFreeLibraryInterpreter;
  function _GetLibraryInterpreterHandleByGUID(GUID: PChar): THandle; stdcall;
                                             external MainExe name ConstGetLibraryInterpreterHandleByGUID;
  procedure _GetLibraryInterpreters(Owner: Pointer; Proc: TGetLibraryInterpreterProc); stdcall;
                                    external MainExe name ConstGetLibraryInterpreters;
  function _CallLibraryInterpreterFun(InterpreterHandle: THandle; Instance: TObject; Args: TArguments; FunName: PChar): Variant; stdcall;
                                      external MainExe name ConstCallLibraryInterpreterFun;

  function GetInterpreterVarObjectByName(Name: string): TObject;
  function GetInterpreterClassByName(Name: string): TClass;                                      
  function ArrPP(PP: array of Variant): TArrOfInterpreterProcParam;
  function PP(ParamText: PChar; ParamType: DWord): PInterpreterProcParam;

   { V2O - converts variant to object }
  function V2O(const V: Variant): TObject;

   { O2V - converts object to variant }
  function O2V(O: TObject): Variant;

   { V2C - converts variant to class }
  function V2C(const V: Variant): TClass;

   { O2V - converts class to variant }
  function C2V(C: TClass): Variant;

   { V2P - converts variant to pointer }
  function V2P(const V: Variant): Pointer;

   { P2V - converts pointer to variant }
  function P2V(P: Pointer): Variant;

   { S2V - converts integer to set and put it into variant }
  function S2V(const I: Integer): Variant;

   { V2S - give a set from variant and converts it to integer }
  function V2S(V: Variant): Integer;

   { R2V - create record holder and put it into variant }
  //function R2V(ARecordType: string; ARec: Pointer): Variant;

   { V2R - returns pointer to record from variant, containing record holder }
  //function V2R(const V: Variant): Pointer;

   { P2R - returns pointer to record from record holder, typically Args.Obj }
  //function P2R(const P: Pointer): Pointer;


  {procedure V2OA(V: Variant; var OA: TOpenArray; var OAValues: TValueArray;
    var Size: Integer);}

implementation

uses SysUtils;

{ TExecProcParam }

constructor TExecProcParam.Create(Collection: TCollection);
begin
  inherited Create(Collection);
end;

destructor TExecProcParam.Destroy;
begin
  inherited Destroy;
end;

procedure TExecProcParam.Assign(Source: TPersistent);
begin
  if Source is TExecProcParam then
  begin
    ParamName:=TExecProcParam(Source).ParamName;
    Value:=TExecProcParam(Source).Value;
  end
  else inherited Assign(Source);
end;

{ TExecProcParams }

constructor TExecProcParams.Create(AOwner: TExecProcedure);
begin
  inherited Create(TExecProcParam);
  FExecProcedure:= AOwner;
end;

function TExecProcParams.GetExecProcParam(Index: Integer): TExecProcParam;
begin
  Result := TExecProcParam(inherited GetItem(Index));
end;

procedure TExecProcParams.SetExecProcParam(Index: Integer; Value: TExecProcParam);
begin
  inherited SetItem(Index, Value);
end;

function TExecProcParams.GetOwner: TPersistent;
begin
  Result := FExecProcedure;
end;

procedure TExecProcParams.Update(Item: TCollectionItem);
begin
  inherited;
end;

function  TExecProcParams.Add: TExecProcParam;
begin
  Result := TExecProcParam(inherited Add);
end;

{ TExecProcedure }

constructor TExecProcedure.Create(AOwner: TInterface);
begin
  Owner:=AOwner;
  FParams:=TExecProcParams.Create(Self);
end;

destructor TExecProcedure.Destroy;
begin
  FParams.Free;
  inherited;
end;

procedure TExecProcedure.Assign(Source: TPersistent);
begin
  if not (Source is TExecProcedure) then exit;
  Name:=TExecProcedure(Source).Name;
  Params.Assign(TExecProcedure(Source).Params);
  Result:=TExecProcedure(Source).Result;
end;

procedure TExecProcedure.SetParams(Value: TExecProcParams);
begin
  FParams.Assign(Value);
end;

{ TInterface }

constructor TInterface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FExecProcedure:=TExecProcedure.Create(Self);
end;

destructor TInterface.Destroy;
begin
  FExecProcedure.Free;
  inherited Destroy
end;

procedure TInterface.SetExecProcedure(Value: TExecProcedure);
begin
  FExecProcedure.Assign(Value);
end;

function TInterface.View: Boolean;
begin
  Result:=false;
end;

function TInterface.Refresh: Boolean;
begin
  Result:=false;
end;

function TInterface.Close: Boolean;
var
  hInterface: THandle;
begin
  hInterface:=_GetInterfaceHandleFromName(PChar(FInterfaceName));
  Result:=_CloseInterface(hInterface);
end;

function TInterface.ExecProc: Boolean;
var
  TPENI: TParamExecProcNoneInterface;
  hInterface: THandle;
  i: Integer;
begin
  Result:=false;
  FillChar(TPENI,SizeOf(TPENI),0);
  TPENI.ProcName:=PChar(FExecProcedure.Name);
  for i:=0 to FExecProcedure.Params.Count-1 do begin
    SetLength(TPENI.Params,Length(TPENI.Params)+1);
    TPENI.Params[Length(TPENI.Params)-1].ParamName:=PChar(FExecProcedure.Params.Items[i].ParamName);
    TPENI.Params[Length(TPENI.Params)-1].Value:=FExecProcedure.Params.Items[i].Value;
  end;
  hInterface:=_GetInterfaceHandleFromName(PChar(FInterfaceName));
  if _ExecProcInterface(hInterface,@TPENI) then begin
    if Length(TPENI.Params)<>FExecProcedure.Params.Count then exit;
    FExecProcedure.Result:=TPENI.Result;
    for i:=0 to FExecProcedure.Params.Count-1 do begin
      FExecProcedure.Params.Items[i].ParamName:=TPENI.Params[Low(TPENI.Params)+i].ParamName;
      FExecProcedure.Params.Items[i].Value:=TPENI.Params[Low(TPENI.Params)+i].Value;
    end;
    Result:=true;
  end;  
end;

{ TVisualRBookInterface }

constructor TVisual.Create(AOwner: TInterface);
begin
  Owner:=AOwner;
end;

procedure TVisual.Assign(Source: TPersistent);
begin
  if not (Source is TVisual) then exit;
  TypeView:=TVisual(Source).TypeView;
  MultiSelect:=TVisual(Source).MultiSelect;
end;

{ TLocate }

constructor TLocate.Create(AOwner: TInterface);
begin
  Owner:=AOwner;
end;

procedure TLocate.Assign(Source: TPersistent);
begin
  if not (Source is TLocate) then exit;
  KeyFields:=TLocate(Source).KeyFields;
  KeyValues:=TLocate(Source).KeyValues;
  Options:=TLocate(Source).Options;
end;

{ TCondition }

constructor TCondition.Create(AOwner: TInterface);
begin
  Owner:=AOwner;
  FOrderStr:=TStringList.Create;
  FWhereStr:=TStringList.Create;
end;

destructor TCondition.Destroy; 
begin
  FWhereStr.Free;
  FOrderStr.Free;
  inherited Destroy;
end;

procedure TCondition.Assign(Source: TPersistent);
begin
  if not (Source is TCondition) then exit;
  OrderStr:=TCondition(Source).OrderStr;
  WhereStr:=TCondition(Source).WhereStr;
end;

procedure TCondition.SetOrderStr(Value: TStrings);
begin
  FOrderStr.Assign(Value);
end;

procedure TCondition.SetWhereStr(Value: TStrings);
begin
  FWhereStr.Assign(Value);
end;

{ TSql }

constructor TSql.Create(AOwner: TInterface);
begin
  Owner:=AOwner;
  FSelect:=TStringList.Create;
  FInsert:=TStringList.Create;
  FUpdate:=TStringList.Create;
  FDelete:=TStringList.Create;
end;

destructor TSql.Destroy;
begin
  FSelect.Free;
  FInsert.Free;
  FUpdate.Free;
  FDelete.Free;
  inherited Destroy;
end;

procedure TSql.Assign(Source: TPersistent);
begin
  if not (Source is TSql) then exit;
  Select:=TSql(Source).Select;
  Insert:=TSql(Source).Insert;
  Update:=TSql(Source).Update;
  Delete:=TSql(Source).Delete;
end;

procedure TSql.SetSelect(Value: TStrings);
begin
  FSelect.Assign(Value);
end;

procedure TSql.SetInsert(Value: TStrings);
begin
  FInsert.Assign(Value);
end;

procedure TSql.SetUpdate(Value: TStrings);
begin
  FUpdate.Assign(Value);
end;

procedure TSql.SetDelete(Value: TStrings);
begin
  FDelete.Assign(Value);
end;

{ TRBookInterface }

constructor TiRBookInterface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FVisual:=TVisual.Create(Self);
  FLocate:=TLocate.Create(Self);
  FCondition:=TConditionRBook.Create(Self);
  FSql:=TSql.Create(Self);
end;

destructor TiRBookInterface.Destroy;
begin
  FSql.Free;
  FCondition.Free;
  FLocate.Free;
  FVisual.Free;
  inherited Destroy;
end;

procedure TiRBookInterface.SetVisual(Value: TVisual);
begin
  FVisual.Assign(Value);
end;

procedure TiRBookInterface.SetCondition(Value: TConditionRBook);
begin
  FCondition.Assign(Value);
end;

procedure TiRBookInterface.SetLocate(Value: TLocate);
begin
  FLocate.Assign(Value);
end;

procedure TiRBookInterface.SetSql(Value: TSql);
begin
  FSql.Assign(Value);
end;

procedure TiRBookInterface.SetDataSet(Value: TDataSet);
begin
  FDataSet:=Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

procedure TiRBookInterface.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FDataSet) then
    FDataSet := nil;
end;

function TiRBookInterface.View: Boolean;
var
  i,j: Integer;
  s,e: Integer;
  fd: TFieldDef;
  TPVRBI: TParamViewRBookInterface;
begin
  FillChar(TPVRBI,SizeOf(TPVRBI),0);

  TPVRBI.Visual.TypeView:=FVisual.TypeView;
  TPVRBI.Visual.MultiSelect:=FVisual.MultiSelect;

  TPVRBI.Locate.KeyFields:=PChar(FLocate.KeyFields);
  TPVRBI.Locate.KeyValues:=FLocate.KeyValues;
  TPVRBI.Locate.Options:=FLocate.Options;

  TPVRBI.Condition.OrderStr:=PChar(FCondition.OrderStr.Text);
  TPVRBI.Condition.WhereStr:=PChar(FCondition.WhereStr.Text);

  TPVRBI.SQL.Select:=PChar(FSql.Select.Text);
  TPVRBI.SQL.Insert:=PChar(FSql.Insert.Text);
  TPVRBI.SQL.Update:=PChar(FSql.Update.Text);
  TPVRBI.SQL.Delete:=PChar(FSql.Delete.Text);

  Result:=_ViewInterfaceFromName(PChar(FInterfaceName),@TPVRBI);
  if FDataSet=nil then exit;
  if Result then begin
     FDataSet.DisableControls;
     try
      if FDataSet.Active then FDataSet.Active:=false;
      FDataSet.Fields.Clear;
      for j:=Low(TPVRBI.Result) to High(TPVRBI.Result) do begin
        fd:=FDataSet.FieldDefs.AddFieldDef;
        fd.DataType:=TPVRBI.Result[j].FieldType;
        fd.Size:=TPVRBI.Result[j].Size;
        fd.CreateField(FDataSet,nil,TPVRBI.Result[j].FieldName);
      end;
      if not FDataSet.Active then FDataSet.Active:=true;
      GetStartAndEndByPRBI(@TPVRBI,s,e);
      for i:=s to e do begin
        FDataSet.Append;
        for j:=Low(TPVRBI.Result) to High(TPVRBI.Result) do begin
          FDataSet.FieldByName(TPVRBI.Result[j].FieldName).Value:=GetValueByPRBI(@TPVRBI,i,TPVRBI.Result[j].FieldName);
        end;
        FDataSet.Post;
      end;
     finally
       FDataSet.EnableControls;
     end;
  end;
end;

function TiRBookInterface.Refresh: Boolean;
var
  TPRRBI: TParamRefreshRBookInterface;
  hInterface: THandle;
begin
  FillChar(TPRRBI,SizeOf(TPRRBI),0);
  TPRRBI.Locate.KeyFields:=PChar(FLocate.KeyFields);
  TPRRBI.Locate.KeyValues:=FLocate.KeyValues;
  TPRRBI.Locate.Options:=FLocate.Options;
  hInterface:=_GetInterfaceHandleFromName(PChar(FInterfaceName));
  Result:=_RefreshInterface(hInterface,@TPRRBI);
end;

{ TiReportInterface }

function TiReportInterface.View: Boolean;
var
  TPVRI: TParamViewReportInterface;
begin
  FillChar(TPVRI,SizeOf(TPVRI),0);
  Result:=_ViewInterfaceFromName(PChar(FInterfaceName),@TPVRI);
end;

{ TiDocumentInterface }

function TiDocumentInterface.View: Boolean;
var
  TPVDI: TParamViewDocumentInterface;
begin
  FillChar(TPVDI,SizeOf(TPVDI),0);
  Result:=_ViewInterfaceFromName(PChar(FInterfaceName),@TPVDI);
end;

{ TiWizardInterface }

function TiWizardInterface.View: Boolean;
var
  TPVWI: TParamViewWizardInterface;
begin
  FillChar(TPVWI,SizeOf(TPVWI),0);
  Result:=_ViewInterfaceFromName(PChar(FInterfaceName),@TPVWI);
end;


{ TConditionJournal }

constructor TConditionJournal.Create(AOwner: TInterface);
begin
  inherited Create(AOwner);
  FWhereStrNoRemoved:=TStringList.Create;
end;

destructor TConditionJournal.Destroy;
begin
  FWhereStrNoRemoved.Free;
  inherited Destroy;
end;

procedure TConditionJournal.Assign(Source: TPersistent);
begin
  inherited Assign(Source);
  if not (Source is TConditionJournal) then exit;
  WhereStrNoRemoved:=TConditionJournal(Source).WhereStrNoRemoved;
end;

procedure TConditionJournal.SetWhereStrNoRemoved(Value: TStrings);
begin
  FWhereStrNoRemoved.Assign(Value);
end;

{ TiJournalInterface }

constructor TiJournalInterface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FVisual:=TVisual.Create(Self);
  FLocate:=TLocate.Create(Self);
  FCondition:=TConditionJournal.Create(Self);
end;

destructor TiJournalInterface.Destroy;
begin
  FCondition.Free;
  FLocate.Free;
  FVisual.Free;
  inherited Destroy;
end;

procedure TiJournalInterface.SetVisual(Value: TVisual);
begin
  FVisual.Assign(Value);
end;

procedure TiJournalInterface.SetCondition(Value: TConditionJournal);
begin
  FCondition.Assign(Value);
end;

procedure TiJournalInterface.SetLocate(Value: TLocate);
begin
  FLocate.Assign(Value);
end;

procedure TiJournalInterface.SetDataSet(Value: TDataSet);
begin
  FDataSet:=Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

procedure TiJournalInterface.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FDataSet) then
    FDataSet := nil;
end;

function TiJournalInterface.View: Boolean;
var
  i,j: Integer;
  s,e: Integer;
  fd: TFieldDef;
  TPVJI: TParamViewJournalInterface;
begin
  FillChar(TPVJI,SizeOf(TPVJI),0);

  TPVJI.Visual.TypeView:=FVisual.TypeView;
  TPVJI.Visual.MultiSelect:=FVisual.MultiSelect;

  TPVJI.Locate.KeyFields:=PChar(FLocate.KeyFields);
  TPVJI.Locate.KeyValues:=FLocate.KeyValues;
  TPVJI.Locate.Options:=FLocate.Options;

  TPVJI.Condition.OrderStr:=PChar(FCondition.OrderStr.Text);
  TPVJI.Condition.WhereStr:=PChar(FCondition.WhereStr.Text);
  TPVJI.Condition.WhereStrNoRemoved:=PChar(FCondition.WhereStrNoRemoved.Text);

  Result:=_ViewInterfaceFromName(PChar(FInterfaceName),@TPVJI);
  if FDataSet=nil then exit;
  if Result then begin
    if ifExistsDataInPJI(@TPVJI) then begin
     FDataSet.DisableControls;
     try
      if FDataSet.Active then FDataSet.Active:=false;
      FDataSet.Fields.Clear;
      for j:=Low(TPVJI.Result) to High(TPVJI.Result) do begin
        fd:=FDataSet.FieldDefs.AddFieldDef;
        fd.DataType:=TPVJI.Result[j].FieldType;
        fd.Size:=TPVJI.Result[j].Size;
        fd.CreateField(FDataSet,nil,TPVJI.Result[j].FieldName);
      end;
      if not FDataSet.Active then FDataSet.Active:=true;
      GetStartAndEndByPJI(@TPVJI,s,e);
      for i:=s to e do begin
        FDataSet.Append;
        for j:=Low(TPVJI.Result) to High(TPVJI.Result) do begin
          FDataSet.FieldByName(TPVJI.Result[j].FieldName).Value:=GetValueByPJI(@TPVJI,i,TPVJI.Result[j].FieldName);
        end;
        FDataSet.Post;
      end;
     finally
       FDataSet.EnableControls;
     end;
    end;
  end;
end;

function TiJournalInterface.Refresh: Boolean;
var
  TPRJI: TParamRefreshJournalInterface;
  hInterface: THandle;
begin
  FillChar(TPRJI,SizeOf(TPRJI),0);
  TPRJI.Locate.KeyFields:=PChar(FLocate.KeyFields);
  TPRJI.Locate.KeyValues:=FLocate.KeyValues;
  TPRJI.Locate.Options:=FLocate.Options;
  hInterface:=_GetInterfaceHandleFromName(PChar(FInterfaceName));
  Result:=_RefreshInterface(hInterface,@TPRJI);
end;

{ TiServiceInterface }

function TiServiceInterface.View: Boolean;
var
  TPVSI: TParamViewServiceInterface;
begin
  FillChar(TPVSI,SizeOf(TPVSI),0);
  Result:=_ViewInterfaceFromName(PChar(FInterfaceName),@TPVSI);
end;

{ TiNoneInterface }

function TiNoneInterface.View: Boolean;
var
  TPVNI: TParamViewNoneInterface;
begin
  FillChar(TPVNI,SizeOf(TPVNI),0);
  Result:=_ViewInterfaceFromName(PChar(FInterfaceName),@TPVNI);
end;


//////////////

type
  PTempInterpreterVar=^TTempInterpreterVar;
  TTempInterpreterVar=packed record
    obj: TObject;
    Name: string;
  end;

procedure GetInterpreterVarProc(Owner: Pointer; PGIV: PGetInterpreterVar); stdcall;
begin
  if not isValidPointer(Owner) then exit;
  if not isValidPointer(PGIV) then exit;
  if TVarData(PGIV.TypeValue).VType=varClass then begin
    if AnsiSameText(PGIV.Identifer,PTempInterpreterVar(Owner).Name) then begin
       PTempInterpreterVar(Owner).obj:=V2O(PGIV.Value);
   end;
  end;
end;

function GetInterpreterVarObjectByName(Name: string): TObject;
var
  TTIV: TTempInterpreterVar;
begin
  FillChar(TTIV,SizeOf(TTIV),0);
  TTIV.Name:=Name;
  _GetInterpreterVars(@TTIV,GetInterpreterVarProc);
  Result:=TTIV.obj;
end;

type
  PTempInterpreterClass=^TTempInterpreterClass;
  TTempInterpreterClass=packed record
    ClassType: TClass;
    Name: string;
  end;

procedure GetInterpreterClassProc(Owner: Pointer; PGIC: PGetInterpreterClass); stdcall;
begin
  if not isValidPointer(Owner) then exit;
  if not isValidPointer(PGIC) then exit;
  if AnsiSameText(PTempInterpreterClass(Owner).Name,PGIC.ClassType.ClassName) then
     PTempInterpreterClass(Owner).ClassType:=PGIC.ClassType;
end;

function GetInterpreterClassByName(Name: string): TClass;
var
  TIC: TTempInterpreterClass;
begin
  FillChar(TIC,SizeOf(TIC),0);
  TIC.Name:=Name;
  _GetInterpreterClasses(@TIC,GetInterpreterClassProc);
  Result:=TIC.ClassType;
end;

function ArrPP(PP: array of Variant): TArrOfInterpreterProcParam;
var
  arr: TArrOfInterpreterProcParam;
  i: Integer;
  sz: Integer;
begin
  SetLength(arr,0);
  Result:=arr;
  sz:=High(PP)-Low(PP);
  if sz=-1 then exit;
  if not Odd(sz) then exit;
  SetLength(arr,sz div 2+1);
  for i:=Low(PP) to High(PP) do begin
   if Odd(i) then begin
     arr[(i-1)div 2].ParamText:=PChar(VarToStr(PP[i-1]));
     arr[(i-1)div 2].ParamType:=PP[i];
   end;
  end;
  Result:=arr;
end;

var
  tipp: TInterpreterProcParam;

function PP(ParamText: PChar; ParamType: DWord): PInterpreterProcParam;
begin
  tipp.ParamText:=ParamText;
  tipp.ParamType:=ParamType;
  Result:=@tipp;
end;

function V2O(const V: Variant): TObject;
begin
  Result := TVarData(V).vPointer;
end;

function O2V(O: TObject): Variant;
begin
  TVarData(Result).VType := varObject;
  TVarData(Result).vPointer := O;
end;

function V2C(const V: Variant): TClass;
begin
  Result := TVarData(V).vPointer;
end;

function C2V(C: TClass): Variant;
begin
  TVarData(Result).VType := varClass;
  TVarData(Result).vPointer := C;
end;

function V2P(const V: Variant): Pointer;
begin
  Result := TVarData(V).vPointer;
end;

function P2V(P: Pointer): Variant;
begin
  TVarData(Result).VType := varPointer;
  TVarData(Result).vPointer := P;
end;

function S2V(const I: Integer): Variant;
begin
  Result := I;
  TVarData(Result).VType := varSet;
end;

function V2S(V: Variant): Integer;
var
  i: Integer;
begin
  if (TVarData(V).VType and System.varArray) = 0 then
    Result := TVarData(V).VInteger
  else
  begin
    Result := 0;
    for i := VarArrayLowBound(V, 1) to VarArrayHighBound(V, 1) do
      Result := Result or 1 shl Integer(V[i]);
  end;
end;

(*function R2V(ARecordType: string; ARec: Pointer): Variant;
begin
  TVarData(Result).vPointer := TRAI2RecHolder.Create(ARecordType, ARec);
  TVarData(Result).VType := varRecord;
end;

function V2R(const V: Variant): Pointer;
begin
  if (TVarData(V).VType <> varRecord) or
    not (TObject(TVarData(V).vPointer) is TRAI2RecHolder) then
    RAI2Error(ieROCRequired, -1);
  Result := TRAI2RecHolder(TVarData(V).vPointer).Rec;
end;

function P2R(const P: Pointer): Pointer;
begin
  if not (TObject(P) is TRAI2RecHolder) then
    RAI2Error(ieROCRequired, -1);
  Result := TRAI2RecHolder(P).Rec;
end;

procedure V2OA(V: Variant; var OA: TOpenArray; var OAValues: TValueArray;
  var Size: Integer);
var
  i: integer;
begin
  if (TVarData(V).VType and varArray) = 0 then
    RAI2Error(ieTypeMistmatch, -1);
  Size := VarArrayHighBound(V, 1) - VarArrayLowBound(V, 1);
  for i := VarArrayLowBound(V, 1) to VarArrayHighBound(V, 1) do { Iterate }
  begin
    case TVarData(V[i]).VType of { }
      varInteger, varSmallInt:
        begin
          OA[i].vInteger := V[i];
          OA[i].VType := vtInteger;
        end;
      varString, varOleStr:
        begin
         // OA[i].vPChar := PChar(string(V[i]));
         // OA[i].VType := vtPChar;
          OAValues[i] := V[i];
          OA[i].vVariant := @OAValues[i];
          OA[i].VType := vtVariant;
        end;
      varBoolean:
        begin
          OA[i].vBoolean := V[i];
          OA[i].VType := vtBoolean;
        end;
      varDouble, varCurrency:
        begin
          OA[i].vExtended := TVarData(V[i]).vPointer;
          OA[i].VType := vtExtended;
        end;
    else
      begin
        OAValues[i] := V[i];
        OA[i].vVariant := @OAValues[i];
        OA[i].VType := vtVariant;
      end;
    end; { case }
  end;
end;*)

{ TEvent }

constructor TEvent.Create(AhInterpreter: THandle; AInstance: TObject; AFunName: PChar);
begin
  FhInterpreter:=AhInterpreter;
  FInstance:=AInstance;
  FFunName:=AFunName;
end;

destructor TEvent.Destroy;
begin
  if FArgs<>nil then
   FArgs.Free;
  inherited Destroy;
end;

function TEvent.GetArgs: TArguments;
begin
  if FArgs=nil then
   FArgs:=TArguments.Create;
  Result:=FArgs;
end;

function TEvent.GetFunName: PChar;
begin
  Result:=PChar(FFunName);
end;

function TEvent.CallFunction(Params: array of Variant): Variant;
var
  i: Integer;
begin
  GetArgs;
  Args.Count:=0;
  Args.hInterpreter:=hInterpreter;
  for i := Low(Params) to High(Params) do begin
    Args.Values[Args.Count] := Params[i];
    inc(Args.Count);
  end; 
  Result:=_CallLibraryInterpreterFun(hInterpreter,Instance,Args,FunName);
end;




end.
