{***********************************************************
                R&A Library
                   RAI2
       Copyright (C) 1998-2001 R&A

       component   : RAI2Program and more..
       description : R&A Interpreter version 2

       author      : Andrei Prygounkov
       e-mail      : a.prygounkov@gmx.de
       www         : http://ralib.hotbox.ru


   additional programming:
   -------------------------
       author      : olej
       e-mail      : olej@atlas.cz (private)
                     olej@asset.sk
                     http://go.to/aolej
************************************************************}
{$INCLUDE RA.INC}

{ history (R&A Library versions):
  1.10:
   - first release;
  1.12:
   - method HandleException removed as bugged;
   - method UpdateExceptionPos now fill error message
     with error Unit name and Line pos;
   - fixed bug in TRAI2Unit.Assignment method;
   - new public property BaseErrLine used in UpdateExceptionPos;
  1.17.7:
   - local "const" statement for functions;
   - global variables and constants - scope on all units - not normal !;
   - OnGetValue and OnSetValue now called before call to Adapter;
   - fixed bug with "Break" statement inside "for" loop;
  1.17.10:
   - fixed(?) bug with "begin/end" statement in "else" part of "if" statement;
   - fixed few bugs in ole automation support;
  1.21.2 (RALib 1.21 Update 2):
   - fixed bug with multiple external functions defintions
     (greetings to Peter Fischer-Haaser)
   - fixed AV-bug in TRAI2Function.InFunction1 if errors in source occured
     (greetings to Andre N Belokon)
  1.21.4 (RALib 1.21 Update 4):
   - fixed bugs in "if" and "while" with "begin" statements;
   - "div" and "mod" now working;
  1.21.6 (RALib 1.21 Update 6):
   - fixed bug with incorrect error line and unit name if erorr
     occured in used unit
     (greetings to Dmitry Mokrushin)
   - add parameters check (not fully functional - only count checked)
     in source fucntion calls;
  1.31.2 (RALib 1.31 Update 2):
   - fixed bug: sometimes compare-operators ('=', '>', ...)
     in expressions do not working.
  1.31.4 (RALib 1.31 Update 4):
   - fixed bug: plus and minus operators after symbol ']' not working.
  1.31.5 (RALib 1.31 Update 5):
   - function Statement1 is changed; this remove many bugs and add new ones.
   - fixed many bug in exception handling statements and in nested
     "begin/end" statements;
   - fixed error with source function with TObject (and descendants)
     returning values;
  1.41.1:
   - another fix for bug with incorrect error line and unit name
     if erorr occurred in used unit;
   - fixed bug with "break" statement;
   - "exit" statement;
   - "repeat" loop;
  1.50:
   - behavior of "UseGlobalAdapter" property was changed; in previous versions
     each TRAI2Expression component creates its own copy of GlobalAdapter and
     then manage it own copy, but now TRAI2Expression manages two adapters:
     own and global, so GlobalRAI2Adapter now is used by all TRAI2Expressions;
     performance of "Compile" function increased (there is no necessity
     more to Assign adapters) (20 msec on my machine with rai2_all unit)
     and memory requirement decreased;
   - sorting in TRAI2Adapter dramatically increase its performance speed;
   - fixed bug in "except/on" statement;
  1.51:
   - arrays as local and global variables. supports simple types (integer,
     double, string, tdatetime, object).
     Added by Andrej Olejnik (olej@asset.sk);
   - type conversion with integer, string, TObject,... keywords;
  1.51.2:
   - array support was rewritten;
     enhanced indexes support: default indexed properties,
     access to chars in strings. Many changes are made to make this possible:
     new methods: GetElement, SetElement;
   - record support is simplified;
   - new property TRAI2Expression.Error provide extended error information
     about non-interpreter errors.
   - "case" statement; not fully implemented - only one expression for one block.
  1.52:
   - TRAI2Expression.RAI2Adapter property renamed to Adapter;
   - new public property TRAI2Expression.SharedAdapter, setting to
     GlobalRAI2Adapter by default. This allows to create set of global adapters,
     shared between TRAI2Expression components;
   - property TRAI2Expression.GlobalAdapter removed; setting SharedAdapter
     to nil has same effect as GlobalAdapter := False;
   - fixed memory bug in event handling;
   - new: unit name in uses list can be placed in quotes and contains any symbols;
   - fixed bug: selector in case-statement not working with variables (only constants)
  1.53:
   - fixed bug: "Type mistmatch error" in expressions with OleAutomation objects;
   - fixed bug: error while assign function's result to object's published property; 
   - call to external functions (placed in dll) in previous versions always
     return integer, now it can return boolean, if declared so;
  1.54:
   - new: in call to external function var-parameters are supported for
     integer type;
   - new: after call to external function (placed in dll) last win32 error
     is restored correctly; in previous versions it was overriden by call to
     FreeLibrary;
   - fixed bug: memory leak: global variables and constants not allways be freed;
  1.60:
   - bug fixed in case-statement;
   - new: global variables and constants in different units now can have
     identical names;
   - new: constants, variables and functions can have prefix with unit name
     and point to determine appropriate unit;
   - new: class declaration for forms (needed for TRAI2Fm component);
   - bug fixed: record variables do not work;
  1.61:
   - bug fixed: variable types are not always kept the same when
     assigning values to them;
     thanks to Ritchie Annand (RitchieA@malibugroup.com);
   - bug fixed: exceptions, raised in dll calls produce AV.
     fix: exception of class Exception is raised.
   - new internal: LocalVars property in TRAI2Function (it is used in TRAI2Fm).
  2.00:
   - Delphi 6 compatibility;
   - Kylix 1 compatibility;
   - exception handling was rewriten in more portable way,
     ChangeTopException function is not used anymore;
   - fixed bug: intefrace section was not processed correct
     (Thanks to Ivan Ravin);



{.$DEFINE RAI2_DEBUG}

{$IFDEF RA_VCL}
  {$DEFINE RAI2_OLEAUTO}
{$ENDIF RA_VCL}

unit RAI2;

interface

uses SysUtils, Classes, RAI2Parser, tsvInterpreterCore
{$IFDEF RA_D6H}
  , Variants
{$ENDIF RA_D6H}
{$IFDEF MSWINDOWS}
  , Windows
{$ENDIF MSWINDOWS}
  ;

type


  TArgs = class;

  TRAI2GetValue = procedure(Sender: TObject; Identifer: string; var Value: Variant;
    Args: TArgs; var Done: Boolean) of object;
  TRAI2SetValue = procedure(Sender: TObject; Identifer: string;
    const Value: Variant; Args: TArgs; var Done: Boolean) of object;
  TRAI2GetUnitSource = procedure(UnitName: string; var Source: string;
    var Done: Boolean) of object;
  TRAI2Error=procedure(Sender: TObject)of object;

//  TRAI2AdapterGetValue = procedure(var Value: Variant; Args: TArgs);
  TRAI2AdapterGetValue = TInterpreterReadProc;
//  TRAI2AdapterSetValue = procedure(const Value: Variant; Args: TArgs);
  TRAI2AdapterSetValue =TInterpreterWriteProc;
  
  TRAI2AdapterNewRecord = procedure(var Value: Pointer);
  TRAI2AdapterDisposeRecord = procedure(const Value: Pointer);
  TRAI2AdapterCopyRecord = procedure(var Dest: Pointer; const Source: Pointer);

  TOpenArray = array[0..MaxArgs] of TVarRec;
  TTypeArray = array[0..MaxArgs] of Word;
  TNameArray = array[0..MaxArgs] of string;
  PValueArray = ^TValueArray;
  PTypeArray = ^TTypeArray;
  PNameArray = ^TNameArray;

  TArgs = class(TArguments)
  private
    VarNames: TNameArray;
    HasVars: Boolean;
  public
    Identifer: string;
    Types: TTypeArray;
    Names: TNameArray;
    HasResult: Boolean; { = False, if result not needed - used by calls
                          to ole automation servers }
    Assignment: Boolean; { internal }
    ObjTyp: Word; { varObject, varClass, varUnknown }

    Indexed: Boolean; // if True then Args contain Indexes to Identifer
    ReturnIndexed: Boolean; // established by GetValue function, indicating
                            // what Args used as indexed (matters only if Indexed = True)
  public
    destructor Destroy; override;
    procedure Clear;
    procedure OpenArray(const Index: Integer);
    procedure Delete(const Index: Integer);
  private
   { open array parameter support }
    { allocates memory only if necessary }
    OAV: ^TValueArray; { open array values }
  public
   { open array parameter support }
    OA: ^TOpenArray; { open array }
    OAS: Integer; { open array size }
  end;

 { function descriptor }
  TRAI2FunDesc = class
  private
    FUnitName: string;
    FIdentifer: string;
    FClassIdentifer: string;  { class name, if function declared as
                                TClassIdentifer.Identifer}
    FParamCount: Integer;  { - 1..MaxArgs }
    FParamTypes: TTypeArray;
    FParamNames: TNameArray;
    FParamPrefixes: TNameArray;
    FResTyp: Word;
    FPosBeg: Integer; { position in source }
    FPosEnd: Integer;

    function GetParamName(Index: Integer): string;
    function GetParamType(Index: Integer): Word;
    function GetParamPrefix(Index: Integer): string;
  public
    property UnitName: string read FUnitName;
    property Identifer: string read FIdentifer;
    property ClassIdentifer: string read FClassIdentifer;
    property ParamCount: Integer read FParamCount;
    property ParamTypes[Index: Integer]: Word read GetParamType;
    property ParamNames[Index: Integer]: string read GetParamName;
    property ParamPrefixes[Index: Integer]: string read GetParamPrefix;
    property ResTyp: Word read FResTyp;
    property PosBeg: Integer read FPosBeg;
    property PosEnd: Integer read FPosEnd;
  end;

  TSimpleEvent = procedure of object;
  TRAI2Expression = class;
  ERAI2Error = class;

  TRAI2EventClass = class of TEvent;

 { variable holder }
  TRAI2Var = class
  public
    UnitName: string;
    Identifer: string;
    Typ: string;
    VTyp: Word;
    Value: Variant;
  public
    destructor Destroy; override;
  end;

 { variables list }
  TRAI2VarList = class(TList)
  public
    destructor Destroy; override;
    procedure Clear; {$IFDEF RA_D35H} override; {$ENDIF}
    procedure AddVar(UnitName, Identifer, Typ: string; VTyp: Word;
      const Value: Variant);
    function FindVar(const UnitName, Identifer: string): TRAI2Var;
    procedure DeleteVar(const UnitName, Identifer: string);
    function GetValue(Identifer: string; var Value: Variant; Args: TArgs)
      : Boolean;
    function SetValue(Identifer: string; const Value: Variant; Args: TArgs)
      : Boolean;
  end;
 { notes about TRAI2VarList implementation:
   - list must allows to contain more than one Var with same names;
   - FindVar must return last added Var with given name;
   - DeleteVar must delete last added Var with given name; }

  TRAI2Identifer = class
  public
    UnitName: string;
    Identifer: string;
    Data: Pointer;  // provided by user when call to adapter's addxxx methods
  end;

  TRAI2IdentiferList = class(TList)
  private
    FDuplicates: TDuplicates;
  public
    function IndexOf(const UnitName, Identifer: string): TRAI2Identifer;
    function Find(const Identifer: string; var Index: Integer): Boolean;
    procedure Sort;
    property Duplicates: TDuplicates read FDuplicates write FDuplicates;
  end;

  TRAI2RecField = record
    Identifer: string;
    Offset: Integer;
    Typ: Word;
  end;

  TCallConvention = set of (ccFastCall, ccStdCall, ccCDecl, ccDynamic,
    ccVirtual, ccClass);

  TTypeAdd=(ttaLast,ttaFirst);  

 { TRAI2Adapter - route RAI2 calls to Delphi functions }
  TRAI2Adapter = class
  private
    FOwner: TRAI2Expression;
    FSrcUnitList: TRAI2IdentiferList; // rai2-units sources
    FExtUnitList: TRAI2IdentiferList; // internal units; like "system" in delphi
    FGetList: TRAI2IdentiferList;     // methods
    FSetList: TRAI2IdentiferList;     // write properties
    FIGetList: TRAI2IdentiferList;    // read indexed properties
    FISetList: TRAI2IdentiferList;    // write indexed properties
    FIDGetList: TRAI2IdentiferList;   // read default indexed properties
    FIDSetList: TRAI2IdentiferList;   // write default indexed properties
    FDGetList: TRAI2IdentiferList;    // direct get list
    FClassList: TRAI2IdentiferList;   // delphi classes
    FConstList: TRAI2IdentiferList;   // delphi consts
    FFunList: TRAI2IdentiferList;     // functions, procedures
    FRecList: TRAI2IdentiferList;     // records
    FRecGetList: TRAI2IdentiferList;  // read record field
    FRecSetList: TRAI2IdentiferList;  // write record field
    FOnGetList: TRAI2IdentiferList;   // chain
    FOnSetList: TRAI2IdentiferList;   // chain
    FSrcFunList: TRAI2IdentiferList;  // functions, procedures in rai2-source
    FExtFunList: TRAI2IdentiferList;
    FEventHandlerList: TRAI2IdentiferList; // events
    FEventList: TRAI2IdentiferList;
    FSrcVarList: TRAI2VarList;         // variables, constants in rai2-source
    FSrcClassList: TRAI2IdentiferList; // rai2-source classes
    FhInterpreter: THandle;

    FSorted: Boolean;
    procedure CheckArgs(var Args: TArgs; ParamCount: Integer;
      var ParamTypes: TTypeArray);
    function GetRec(RecordType: string): TObject;
   {$IFDEF RAI2_OLEAUTO}
    function DispatchCall(Identifer: string; var Value: Variant;
      Args: TArgs; Get: Boolean; isRef: Boolean=false): Boolean; stdcall;
   {$ENDIF RAI2_OLEAUTO}
    function GetValueRTTI(Identifer: string; var Value: Variant;
      Args: TArgs): Boolean;
    function SetValueRTTI(Identifer: string; const Value: Variant;
      Args: TArgs): Boolean;
  protected
    procedure CheckAction(Expression: TRAI2Expression; Args: TArgs;
      Data: Pointer); virtual;
    function GetValue(Expression: TRAI2Expression; Identifer: string;
      var Value: Variant; Args: TArgs): Boolean; virtual;
    function SetValue(Expression: TRAI2Expression; Identifer: string;
      const Value: Variant; Args: TArgs): Boolean; virtual;
    function GetElement(Expression: TRAI2Expression; const Variable: Variant;
      var Value: Variant; var Args: TArgs): Boolean; virtual;
    function SetElement(Expression: TRAI2Expression; var Variable: Variant;
      const Value: Variant; var Args: TArgs): Boolean; virtual;
    function SetRecord(var Value: Variant): Boolean; virtual;
    function NewRecord(const RecordType: string; var Value: Variant)
      : Boolean; virtual;
    procedure CurUnitChanged(NewUnitName: string; var Source: string); virtual;
    function UnitExists(const Identifer: string): Boolean; virtual;
    function IsEvent(Obj: TObject; const Identifer: string): Boolean; virtual;
    procedure ClearSource; dynamic;
    procedure ClearNonSource; dynamic;
    procedure Sort; dynamic;
  protected
    { for internal use }
    procedure AddSrcClass(RAI2SrcClass: TRAI2Identifer); virtual;
    function GetSrcClass(Identifer: string): TRAI2Identifer; virtual;
  public
    constructor Create(AOwner: TRAI2Expression);
    destructor Destroy; override;
    procedure Clear; dynamic;
    procedure Assign(Source: TRAI2Adapter); dynamic;
    procedure AddSrcUnit(Identifer: string; Source: string; UsesList: string);
      dynamic;
    procedure AddSrcUnitEx(Identifer: string; Source: string; UsesList: string;
      Data: Pointer); dynamic;
    procedure AddExtUnit(Identifer: string); dynamic;
    procedure AddExtUnitEx(Identifer: string; Data: Pointer); dynamic;
    procedure AddClass(UnitName: string; ClassType: TClass; Identifer: string);
      dynamic;
    procedure AddClassEx(UnitName: string; ClassType: TClass; Identifer: string;
      Data: Pointer); dynamic;
    procedure AddGet(ClassType: TClass; Identifer: string;
      GetFunc: TRAI2AdapterGetValue; ParamCount: Integer;
      ParamTypes: array of Word; ResTyp: Word); dynamic;
    procedure AddGetEx(ClassType: TClass; Identifer: string;
      GetFunc: TRAI2AdapterGetValue; ParamCount: Integer;
      ParamTypes: array of Word; ResTyp: Word; Data: Pointer); dynamic;
    procedure AddSet(ClassType: TClass; Identifer: string;
      SetFunc: TRAI2AdapterSetValue; ParamCount: Integer;
      ParamTypes: array of Word); dynamic;
    procedure AddSetEx(ClassType: TClass; Identifer: string;
      SetFunc: TRAI2AdapterSetValue; ParamCount: Integer;
      ParamTypes: array of Word; Data: Pointer); dynamic;
    procedure AddIGet(ClassType: TClass; Identifer: string;
      GetFunc: TRAI2AdapterGetValue; ParamCount: Integer;
      ParamTypes: array of Word; ResTyp: Word); dynamic;
    procedure AddIGetEx(ClassType: TClass; Identifer: string;
      GetFunc: TRAI2AdapterGetValue; ParamCount: Integer;
      ParamTypes: array of Word; ResTyp: Word; Data: Pointer); dynamic;
    procedure AddISet(ClassType: TClass; Identifer: string;
      SetFunc: TRAI2AdapterSetValue; ParamCount: Integer;
      ParamTypes: array of Word); dynamic;
    procedure AddISetEx(ClassType: TClass; Identifer: string;
      SetFunc: TRAI2AdapterSetValue; ParamCount: Integer;
      ParamTypes: array of Word; Data: Pointer); dynamic;
    procedure AddIDGet(ClassType: TClass;
      GetFunc: TRAI2AdapterGetValue; ParamCount: Integer;
      ParamTypes: array of Word; ResTyp: Word); dynamic;
    procedure AddIDGetEx(ClassType: TClass;
      GetFunc: TRAI2AdapterGetValue; ParamCount: Integer;
      ParamTypes: array of Word; ResTyp: Word; Data: Pointer); dynamic;
    procedure AddIDSet(ClassType: TClass;
      SetFunc: TRAI2AdapterSetValue; ParamCount: Integer;
      ParamTypes: array of Word); dynamic;
    procedure AddIDSetEx(ClassType: TClass;
      SetFunc: TRAI2AdapterSetValue; ParamCount: Integer;
      ParamTypes: array of Word; Data: Pointer); dynamic;
    procedure AddFun(UnitName: string; Identifer: string;
      GetFunc: TRAI2AdapterGetValue; ParamCount: Integer;
      ParamTypes: array of Word; ResTyp: Word); dynamic;
    procedure AddFunEx(UnitName: string; Identifer: string;
      GetFunc: TRAI2AdapterGetValue; ParamCount: Integer;
      ParamTypes: array of Word; ResTyp: Word; Data: Pointer); dynamic;
   { function AddDGet under construction - don't use it }
    procedure AddDGet(ClassType: TClass; Identifer: string;
      GetFunc: Pointer; ParamCount: Integer; ParamTypes: array of Word;
      ResTyp: Word; CallConvention: TCallConvention); dynamic;
    procedure AddDGetEx(ClassType: TClass; Identifer: string;
      GetFunc: Pointer; ParamCount: Integer; ParamTypes: array of Word;
      ResTyp: Word; CallConvention: TCallConvention; Data: Pointer); dynamic;
    procedure AddRec(UnitName: string; Identifer: string; RecordSize: Integer;
      Fields: array of TRAI2RecField; CreateFunc: TRAI2AdapterNewRecord;
      DestroyFunc: TRAI2AdapterDisposeRecord; CopyFunc: TRAI2AdapterCopyRecord);
      dynamic;
    procedure AddRecEx(UnitName: string; Identifer: string; RecordSize: Integer;
      Fields: array of TRAI2RecField; CreateFunc: TRAI2AdapterNewRecord;
      DestroyFunc: TRAI2AdapterDisposeRecord; CopyFunc: TRAI2AdapterCopyRecord;
      Data: Pointer); dynamic;
    procedure AddRecGet(UnitName: string; RecordType: string; Identifer: string;
      GetFunc: TRAI2AdapterGetValue; ParamCount: Integer;
      ParamTypes: array of Word; ResTyp: Word); dynamic;
    procedure AddRecGetEx(UnitName: string; RecordType: string; Identifer: string;
      GetFunc: TRAI2AdapterGetValue; ParamCount: Integer;
      ParamTypes: array of Word; ResTyp: Word; Data: Pointer); dynamic;
    procedure AddRecSet(UnitName: string; RecordType: string; Identifer: string;
      SetFunc: TRAI2AdapterSetValue; ParamCount: Integer;
      ParamTypes: array of Word); dynamic;
    procedure AddRecSetEx(UnitName: string; RecordType: string; Identifer: string;
      SetFunc: TRAI2AdapterSetValue; ParamCount: Integer;
      ParamTypes: array of Word; Data: Pointer); dynamic;
    procedure AddConst(UnitName: string; Identifer: string; Value: Variant);
      dynamic;
    procedure AddConstEx(UnitName: string; Identifer: string; Value: Variant;
      Data: Pointer; TypeAdd: TTypeAdd=ttaLast); dynamic;

    // function or procedure from Library;
    procedure AddExtFun(UnitName: string; Identifer: string; DllInstance: HINST;
      DllName: string; FunName: string; FunIndex: integer; ParamCount: Integer;
      ParamTypes: array of Word; ResTyp: Word); dynamic;
    procedure AddExtFunEx(UnitName: string; Identifer: string; DllInstance: HINST;
      DllName: string; FunName: string; FunIndex: integer; ParamCount: Integer;
      ParamTypes: array of Word; ResTyp: Word; Data: Pointer); dynamic;
    procedure AddSrcFun(UnitName: string; Identifer: string;
      PosBeg, PosEnd: integer; ParamCount: Integer; ParamTypes: array of Word;
      ParamNames: array of string; ResTyp: Word; Data: Pointer); dynamic;
    procedure AddSrcFunEx(UnitName: string; Identifer: string;
      PosBeg, PosEnd: integer; ParamCount: Integer; ParamTypes: array of Word;
      ParamNames: array of string; ResTyp: Word; Data: Pointer); dynamic;
    procedure AddHandler(UnitName: string; Identifer: string;
      EventClass: TRAI2EventClass; Code: Pointer); dynamic;
    procedure AddHandlerEx(UnitName: string; Identifer: string;
      EventClass: TRAI2EventClass; Code: Pointer; Data: Pointer); dynamic;
    procedure AddEvent(UnitName: string; ClassType: TClass;
      Identifer: string); dynamic;
    procedure AddEventEx(UnitName: string; ClassType: TClass;
      Identifer: string; Data: Pointer); dynamic;
    procedure AddSrcVar(UnitName: string; Identifer, Typ: string; VTyp: Word;
      const Value: Variant); dynamic;
    procedure AddOnGet(Method: TRAI2GetValue); dynamic;
    procedure AddOnSet(Method: TRAI2SetValue); dynamic;

    function NewEvent(const UnitName: string; const FunName, EventType: string;
                      AOwner: TRAI2Expression; AObject: TObject): TSimpleEvent; virtual;
    function FindEvent(const UnitName: string; const FunName, EventType: string;
                      AOwner: TRAI2Expression; AObject: TObject): TSimpleEvent; virtual;
    function FindFunDesc(const UnitName: string; const Identifer: string): TRAI2FunDesc; virtual;


    property GetList: TRAI2IdentiferList read FGetList;     // read properties
    property SetList: TRAI2IdentiferList read FSetList;     // write properties
    property IGetList: TRAI2IdentiferList read FIGetList;    // read indexed properties
    property ISetList: TRAI2IdentiferList read FISetList;    // write indexed properties
    property IDGetList: TRAI2IdentiferList read FIDGetList;   // read default indexed properties
    property IDSetList: TRAI2IdentiferList read FIDSetList;   // write default indexed properties
    property DGetList: TRAI2IdentiferList read FDGetList;    // direct get list
    property ClassList: TRAI2IdentiferList read FClassList;   // delphi classes
    property ConstList: TRAI2IdentiferList read FConstList;   // delphi consts
    property FunList: TRAI2IdentiferList read FFunList;     //property functions, procedures
    property RecList: TRAI2IdentiferList read FRecList;     // records
    property RecGetList: TRAI2IdentiferList read FRecGetList;  // read recordproperty ield
    property RecSetList: TRAI2IdentiferList read FRecSetList;  // write recordproperty ield
    property OnGetList: TRAI2IdentiferList read FOnGetList;   // chain
    property OnSetList: TRAI2IdentiferList read FOnSetList;   // chain
    property SrcFunList: TRAI2IdentiferList read FSrcFunList;  //property functions, procedures in rai2-source
    property ExtFunList: TRAI2IdentiferList read FExtFunList;
    property EventHandlerList: TRAI2IdentiferList read FEventHandlerList;
    property EventList: TRAI2IdentiferList read FEventList;
    property SrcVarList: TRAI2VarList read FSrcVarList;         // variables, constants in rai2-source
    property SrcClassList: TRAI2IdentiferList read FSrcClassList; // rai2-source classes

    property hInterpreter: THandle read FhInterpreter write FhInterpreter; 
  end;

  TStackPtr = - 1..99;

 { Expression evaluator }
  TRAI2Expression = class(TComponent)
  private
    Parser: TRAI2Parser;
    FVResult: Variant;
    ExpStack: array[0..99] of Variant;
    ExpStackPtr: TStackPtr;
    Token1: Variant;
    FBacked: Boolean;
    TTyp1: TTokenTyp;
    TokenStr1: string;
    PrevTTyp: TTokenTyp;
    AllowAssignment: Boolean;
    FArgs: TArgs; { data }
    Args: TArgs; { pointer to current }
    FPStream: TStream; { parsed source }
    FParsed: Boolean;
    FAdapter: TRAI2Adapter;
    FSharedAdapter: TRAI2Adapter;
    FCompiled: Boolean;
    FBaseErrLine: Integer;
    FOnGetValue: TRAI2GetValue;
    FOnSetValue: TRAI2SetValue;
    FOnError: TRAI2Error;
    FLastError: ERAI2Error;
    isReset: Boolean;
    function GetSource: string;
    procedure SetSource(Value: string);
    procedure SetCurPos(Value: Integer);
    function GetCurPos: Integer;
    function GetTokenStr: string;
    procedure ReadArgs;
    procedure InternalGetValue(Obj: Pointer; ObjTyp: Word; var Result: Variant);
    procedure InternalSetValue(const Identifer: string);

    function CallFunction(const FunName: string;
      Args: TArgs; Params: array of Variant): Variant; virtual; abstract;
{    function CallFunctionEx(Instance: TObject; const UnitName: string;
      const FunName: string; Args: TArgs; Params: array of Variant)
      : Variant; virtual; abstract;}
    function CallFunctionEx(Instance: TObject; const UnitName: string;
      const FunName: string; Args: TArguments; Params: array of Variant)
      : Variant; virtual; abstract;
    function GetCurLine: Integer;
  protected
    procedure UpdateExceptionPos(E: Exception; const UnitName: string);
    procedure Init; dynamic;
    procedure ErrorExpected(Exp: string);
    procedure ErrorNotImplemented(Message: string);
    function PosBeg: Integer;
    function PosEnd: Integer;
    procedure Back;
    procedure SafeBack; {? please don't use ?}
    function CreateAdapter: TRAI2Adapter; dynamic;

    procedure ParseToken;
    procedure ReadToken;
    procedure WriteToken;
    procedure Parse;

    function Expression1: Variant;
    function Expression2(const ExpType: Word): Variant;
    function SetExpression1: Variant;

    procedure NextToken;
    function GetValue(Identifer: string; var Value: Variant;
      var Args: TArgs): Boolean; virtual;
    function SetValue(Identifer: string; const Value: Variant;
      var Args: TArgs): Boolean; virtual;
    function GetElement(const Variable: Variant; var Value: Variant;
      var Args: TArgs): Boolean; virtual;
    function SetElement(const Identifer: string; var Variable: Variant; const Value: Variant;
      var Args: TArgs): Boolean; virtual;
    procedure SourceChanged; dynamic;
    procedure SetAdapter(Adapter: TRAI2Adapter);
    property Token: Variant read Token1;
    property TTyp: TTokenTyp read TTyp1;
    property TokenStr: string read GetTokenStr;
    property CurPos: Integer read GetCurPos write SetCurPos;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Run; dynamic;
    procedure Reset; dynamic;
    
    property Source: string read GetSource write SetSource;
    property VResult: Variant read FVResult;
    property OnGetValue: TRAI2GetValue read FOnGetValue write FOnGetValue;
    property OnSetValue: TRAI2SetValue read FOnSetValue write FOnSetValue;
    property OnError: TRAI2Error read FOnError write FOnError; 
    property Adapter: TRAI2Adapter read FAdapter;
    property SharedAdapter: TRAI2Adapter read FSharedAdapter;
    property BaseErrLine: Integer read FBaseErrLine write FBaseErrLine;
    property LastError: ERAI2Error read FLastError;
    property CurLine: Integer Read GetCurLine;
  end;

  TParserState = record
    CurPos: Integer;
    Token: Variant;
    TTyp: TTokenTyp;
    PrevTTyp: TTokenTyp;
    Backed: Boolean;
    AllowAssignment: Boolean;
  end;

  TRAI2AddVarFunc = procedure (UnitName: string; Identifer,
    Typ: string; VTyp: Word; const Value: Variant) of object;

 { Function executor }
  TRAI2Function = class(TRAI2Expression)
  private
    FCurUnitName: string;
    FCurInstance: TObject;
    FBreak, FContinue, FExit: Boolean;
    FunStack: TList;
    FunContext: Pointer; { PFunContext }
    SS: TStrings;
    StateStack: array[0..99] of TParserState;
    StateStackPtr: TStackPtr;
    FEventList: TList;
    function GetLocalVars: TRAI2VarList;
  protected
    procedure Init; override;
    procedure PushState;
    procedure PopState;
    procedure RemoveState;

    procedure InFunction1(FunDesc: TRAI2FunDesc);
    procedure DoOnStatement; virtual;
    procedure Statement1;
    procedure SkipStatement1;
    procedure SkipToEnd1;
    procedure SkipToUntil1;
    procedure SkipIdentifer1;
    procedure FindToken1(TTyp1: TTokenTyp);
    procedure Var1(AddVarFunc: TRAI2AddVarFunc);
    procedure Const1(AddVarFunc: TRAI2AddVarFunc);
    procedure Identifer1;
    procedure Begin1;
    procedure If1;
    procedure While1;
    procedure Repeat1;
    procedure For1;
    procedure Case1;
    procedure Try1;
    procedure Raise1;

    procedure InternalSetValue(const Identifer: string);
    function GetValue(Identifer: string; var Value: Variant;
      var Args: TArgs): Boolean; override;
    function SetValue(Identifer: string; const Value: Variant;
      var Args: TArgs): Boolean; override;
    property LocalVars: TRAI2VarList read GetLocalVars;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Run; override;
    property CurUnitName: string read FCurUnitName;
    property CurInstance: TObject read FCurInstance;

    function NewEvent(const UnitName: string; const FunName, EventType: string;  Instance: TObject): TSimpleEvent;

  end;

  TUnitSection = (usUnknown, usInterface, usImplementation, usInitialization,
    usFinalization);

 { Unit executor }
  TRAI2Unit = class(TRAI2Function)
  private
    FClearUnits: boolean;
    FEventHandlerList: TList;
    FOnGetUnitSource: TRAI2GetUnitSource;
    FUnitSection: TUnitSection;
  protected
    procedure Init; override;
    procedure ReadFunHeader(FunDesc: TRAI2FunDesc);
    procedure Uses1(var UsesList: string);
    procedure ReadUnit(const UnitName: string);
    procedure Function1;
    procedure Unit1;
    procedure Type1;
    procedure Class1(const Identifer: string);
    function GetValue(Identifer: string; var Value: Variant;
      var Args: TArgs): Boolean; override;
    function SetValue(Identifer: string; const Value: Variant;
      var Args: TArgs): Boolean; override;
    function GetUnitSource(UnitName: string; var Source: string): boolean;
      dynamic;
    procedure ExecFunction(Fun: TRAI2FunDesc);
    procedure SourceChanged; override;
    function GetMainFunction: TRAI2FunDesc; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Run; override;
    procedure DeclareExternalFunction(const Declaration: string);
    procedure Compile;
    function CallFunction(const FunName: string; Args: TArgs;
      Params: array of Variant): Variant; override;
{    function CallFunctionEx(Instance: TObject; const UnitName: string;
      const FunName: string; Args: TArgs; Params: array of Variant)
      : Variant; override;}
    function CallFunctionEx(Instance: TObject; const UnitName: string;
      const FunName: string; Args: TArguments; Params: array of Variant)
      : Variant; override;
    function FunctionExists(const UnitName: string; const FunName: string)
      : boolean;
    property OnGetUnitSource: TRAI2GetUnitSource read FOnGetUnitSource
      write FOnGetUnitSource;
    property UnitSection: TUnitSection read FUnitSection;
  end;

 { main RAI2 component }
  TRAI2Program = class(TRAI2Unit)
  private
    FPas: TStrings;
    FOnStatement: TNotifyEvent;
    procedure SetPas(Value: TStrings);
  protected
    procedure DoOnStatement; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Run; override;
  published
    property Pas: TStrings read FPas write SetPas;
    property OnGetValue;
    property OnSetValue;
    property OnGetUnitSource;
    property OnStatement: TNotifyEvent read FOnStatement write FOnStatement;
  end;

  ERAI2Error = class(Exception)
  private
    FExceptionPos: Boolean;
    FErrCode: integer;
    FErrPos: integer;
    FErrName: string;
    FErrName2: string;
    FErrUnitName: string;
    FErrLine: Integer;
    FMessage1: string;
  public
    constructor Create(const AErrCode: integer; const AErrPos: integer;
      const AErrName, AErrName2: string);
    procedure Assign(E: Exception);
    procedure Clear;
    property ErrCode: integer read FErrCode;
    property ErrPos: integer read FErrPos;
    property ErrName: string read FErrName;
    property ErrName2: string read FErrName2;
    property ErrUnitName: string read FErrUnitName;
    property ErrLine: Integer read FErrLine;
    property Message1: string read FMessage1;
  end;

  {Error raising routines}
  procedure RAI2Error(const AErrCode: integer; const AErrPos: integer);
  procedure RAI2ErrorN(const AErrCode: integer; const AErrPos: integer;
    const AErrName: string);
  procedure RAI2ErrorN2(const AErrCode: integer; const AErrPos: integer;
    const AErrName1, AErrName2: string);

  {Utilities functions}
  //function LoadStr2(const ResID: Integer): string;
  function SubStr(const S : string; const index : integer; const Separator : string) : string;

   { RFD - RecordFieldDefinition - return record needed for TRAI2Adapter.AddRec
     Fields parameter }
  function RFD(Identifer: string; Offset: Integer; Typ: Word): TRAI2RecField;

  procedure NotImplemented(Message: string);
  
   { clear list of TObject }
  procedure ClearList(List: TList);



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

 { R2V - create record holder and put it into variant }
function R2V(ARecordType: string; ARec: Pointer): Variant;

 { V2R - returns pointer to record from variant, containing record holder }
function V2R(const V: Variant): Pointer;

 { P2R - returns pointer to record from record holder, typically Args.Obj }
function P2R(const P: Pointer): Pointer;

 { S2V - converts integer to set and put it into variant }
function S2V(const I: Integer): Variant;

 { V2S - give a set from variant and converts it to integer }
function V2S(V: Variant): Integer;

procedure V2OA(V: Variant; var OA: TOpenArray; var OAValues: TValueArray;
  var Size: Integer);

function TypeName2VarTyp(TypeName: string): Word;
function VarType2TypeName(VType: Word): string;

 { copy variant variable with all rai2 variant extension }
procedure RAI2VarCopy(var Dest: Variant; const Source: Variant);

function RAI2VarAsType(const V : Variant; const VarType : integer) : Variant;

 { properly free var variable and set it content to empty }
procedure RAI2VarFree(var V: Variant);

 { compare strings }
function Cmp(const S1, S2 : string) : boolean;

var
  GlobalRAI2Adapter: TRAI2Adapter = nil;

const

  prArgsNoCheck = -1;
  noInstance = HINST(0);
  RFDNull: TRAI2RecField = (Identifer: ''; Offset: 0; Typ: 0);

 {RAI2 error codes}

  ieOk = 0; { Okay - no errors }
  ieUnknown = 1;
  ieInternal = 2;
  ieUserBreak = 3; { internal }
  ieRaise = 4; { internal }
  ieErrorPos = 5;
  ieExternal = 6; { non-interpreter error }
  ieAccessDenied = 7;

  { register-time errors }
  ieRegisterBase = 30;
  ieRecordNotDefined = ieRegisterBase + 1;

  { run-time errors }
  ieRuntimeBase = 50;
  ieStackOverFlow = ieRuntimeBase + 2;
  ieTypeMistmatch = ieRuntimeBase + 3;
  ieIntegerOverflow = ieRuntimeBase + 4;
  ieMainUndefined = ieRuntimeBase + 5;
  ieUnitNotFound = ieRuntimeBase + 6;
  ieEventNotRegistered = ieRuntimeBase + 7;
  ieDfmNotFound = ieRuntimeBase + 8;

  { syntax errors (now run-timed) }
  ieSyntaxBase = 100;
  ieBadRemark = ieSyntaxBase + 1; { Bad remark - detected by parser }
  ieIdentiferExpected = ieSyntaxBase + 2;
  ieExpected = ieSyntaxBase + 3;
  ieUnknownIdentifer = ieSyntaxBase + 4;
  ieBooleanRequired = ieSyntaxBase + 5;
  ieClassRequired = ieSyntaxBase + 6;
  ieNotAllowedBeforeElse = ieSyntaxBase + 7;
  ieIntegerRequired = ieSyntaxBase + 8;
  ieROCRequired = ieSyntaxBase + 9;
  ieMissingOperator = ieSyntaxBase + 10;
  ieIdentiferRedeclared = ieSyntaxBase + 11;

 { array indexes }
  ieArrayBase = 170;
  ieArrayIndexOutOfBounds = ieArrayBase + 1;
  ieArrayTooManyParams = ieArrayBase + 2;
  ieArrayNotEnoughParams = ieArrayBase + 3;
  ieArrayBadDimension= ieArrayBase + 4;
  ieArrayBadRange = ieArrayBase + 5;
  ieArrayRequired = ieArrayBase + 6;

 { function call errors (now run-timed) }
  ieFunctionBase = 180;
  ieTooManyParams = ieFunctionBase + 1;
  ieNotEnoughParams = ieFunctionBase + 2;
  ieIncompatibleTypes = ieFunctionBase + 3;
  ieDllErrorLoadLibrary = ieFunctionBase + 4;
  ieDllInvalidArgument = ieFunctionBase + 5;
  ieDllInvalidResult = ieFunctionBase + 6;
  ieDllFunctionNotFound = ieFunctionBase + 7;
  ieDirectInvalidArgument = ieFunctionBase + 8;
  ieDirectInvalidResult = ieFunctionBase + 9;
  ieDirectInvalidConvention = ieFunctionBase + 10;


{$IFDEF RAI2_OLEAUTO}
  ieOleAuto = ieFunctionBase + 21;
{$ENDIF}

  ieUserBase = $300;

  irExpression = 301;
  irIdentifer = 302;
  irDeclaration = 303;
  irEndOfFile = 304;
  irClass = 305;

type

  TRAI2Const = class(TRAI2Identifer)
  public
    Value: Variant;
  end;

  TRAI2Class = class(TRAI2Identifer)
  public
    ClassType: TClass;
  end;

  TParamCount = - 1..MaxArgs;

  TRAI2Method = class(TRAI2Identifer)
  public
    ClassType: TClass;
    ParamCount: TParamCount;
    ParamTypes: TTypeArray; { varInteger, varString, .. }
    ResTyp: Word; { varInteger, varString, .. }
    Func: Pointer; { TRAI2AdapterGetValue or TRAI2AdapterSetValue }
  end;

  TRAI2EventDesc = class(TRAI2Identifer)
  private
    EventClass: TRAI2EventClass;
    Code: Pointer;
  end;

 { interpreter function }
  TRAI2SrcFun = class(TRAI2Identifer)
  public
    FunDesc: TRAI2FunDesc;
    constructor Create;
    destructor Destroy; override;
  end;

 { external function }
  TRAI2ExtFun = class(TRAI2SrcFun)
  private
    DllInstance: HINST;
    DllName: string;
    FunName: string;
     {or}
    FunIndex: integer;
    function CallDll(Args: TArgs): Variant;
  end;
  
implementation

uses TypInfo, RAI2Const
{$IFNDEF RA_D3H}
  , Ole2 { IUnknown in Delphi 2 }
{$ENDIF}
{$IFDEF RAI2_OLEAUTO}
  , OleConst
{$IFDEF RA_D3H}
  , ActiveX, ComObj
{$ELSE}
  , OleAuto
{$ENDIF RA_D3H}
{$ENDIF RAI2_OLEAUTO}
  ;


{$R rai2.res} { error messages }


{ internal structures }
type

 { Adapter classes - translates data from RAI2 calls to Delphi functions }

  TRAI2SrcUnit = class(TRAI2Identifer)
  private
    Source: string;
    UsesList: TNameArray;
  end;


  TRAI2DMethod = class(TRAI2Method)
  private
    ResTyp: Word;
    CallConvention: TCallConvention;
  end;

  TRAI2RecFields = array[0..MaxRecFields] of TRAI2RecField;

  TRAI2Record = class(TRAI2Identifer)
  private
    RecordSize: Integer; { sizeof(Rec^) }
    FieldCount: Integer;
    Fields: TRAI2RecFields;
    CreateFunc: TRAI2AdapterNewRecord;
    DestroyFunc: TRAI2AdapterDisposeRecord;
    CopyFunc: TRAI2AdapterCopyRecord;
  end;

  TRAI2RecMethod = class(TRAI2Identifer)
  private
    RAI2Record: TRAI2Record;
    ParamCount: TParamCount;
    ParamTypes: TTypeArray; { varInteger, varString and so one .. }
    ResTyp: Word; { varInteger, varString, .. }
    Func: Pointer; { TRAI2AdapterGetValue or TRAI2AdapterSetValue }
  end;

  TRAI2RecHolder = class(TRAI2Identifer)
  private
    RecordType: string;
    RAI2Record: TRAI2Record;
    Rec: Pointer; { data }
  public
    constructor Create(ARecordType: string; ARec: Pointer);
    destructor Destroy; override;
  end;

  PMethod = ^TMethod;


 { function context - stack }
  PFunContext = ^TFunContext;
  TFunContext = record
    PrevFunContext: PFunContext;
    LocalVars: TRAI2VarList;
    Fun: TRAI2SrcFun;
  end;


{$IFDEF RA_D2}
 { TStringStream - reduced implementation from Delphi 3 classes.pas }
  TStringStream = class(TStream)
  private
    FDataString: string;
    FPosition: Integer;
  protected
    procedure SetSize(NewSize: Longint);
  public
    constructor Create(const AString: string);
    function Read(var Buffer; Count: Longint): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    function Seek(Offset: Longint; Origin: Word): Longint; override;
  end;

  PDouble = ^Double;
  PSmallInt = ^SmallInt;
{$ENDIF RA_D2}

{$IFDEF RA_CLX}
type
  DWORD = longint;
  PBool = PBoolean;
{$ENDIF RA_CLX}

{$IFDEF RAI2_DEBUG}
var
  ObjCount: Integer = 0;

{$ENDIF}


function LoadStr2(const ResID: Integer): string;
var
  i: Integer;
begin

  for i := Low(RAI2Errors) to High(RAI2Errors) do
    if RAI2Errors[i].ID = ResID then
    begin
      Result := RAI2Errors[i].Description;
      Break;
    end;
end;

procedure NotImplemented(Message: string);
begin
  RAI2ErrorN(ieInternal, -1,  Message + ' not implemented');
end; 

procedure RAI2Error(const AErrCode: integer; const AErrPos: integer);
begin
  raise ERAI2Error.Create(AErrCode, AErrPos, '', '');
end; { RAI2Error }

procedure RAI2ErrorN(const AErrCode: integer; const AErrPos: integer;
  const AErrName: string);
begin
  raise ERAI2Error.Create(AErrCode, AErrPos, AErrName, '');
end; { RAI2ErrorN }

procedure RAI2ErrorN2(const AErrCode: integer; const AErrPos: integer;
  const AErrName1, AErrName2: string);
begin
  raise ERAI2Error.Create(AErrCode, AErrPos, AErrName1, AErrName2);
end; { RAI2ErrorN2 }

constructor ERAI2Error.Create(const AErrCode: integer;
  const AErrPos: integer; const AErrName, AErrName2: string);
begin
  inherited Create('');
  FErrCode := AErrCode;
  FErrPos := AErrPos;
  FErrName := AErrName;
  FErrName2 := AErrName2;
  { function LoadStr don't work sometimes :-( }
  Message := Format(LoadStr2(ErrCode), [ErrName, ErrName2]);
  FMessage1 := Message;
end; { Create }

procedure ERAI2Error.Assign(E: Exception);
begin
  Message := E.Message;
  if E is ERAI2Error then
  begin
    FErrCode := (E as ERAI2Error).FErrCode;
    FErrPos := (E as ERAI2Error).FErrPos;
    FErrName := (E as ERAI2Error).FErrName;
    FErrName2 := (E as ERAI2Error).FErrName2;
    FMessage1 := (E as ERAI2Error).FMessage1;
  end;
end;

procedure ERAI2Error.Clear;
begin
  FExceptionPos := False;
  FErrName := '';
  FErrName2 := '';
  FErrPos := -1;
  FErrLine := -1;
  FErrUnitName := '';
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

function R2V(ARecordType: string; ARec: Pointer): Variant;
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
   { rai2 thinks about all function parameters, started
     with '[' symbol that they are open arrays;
     but it may be set constant, so we must convert it now }
    Result := 0;
    for i := VarArrayLowBound(V, 1) to VarArrayHighBound(V, 1) do
      Result := Result or 1 shl Integer(V[i]);
  end;
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
end;

function RFD(Identifer: string; Offset: Integer; Typ: Word)
  : TRAI2RecField;
begin
  Result.Identifer := Identifer;
  Result.Offset := Offset;
  Result.Typ := Typ;
end;

//RWare: added check for "char", otherwise function with ref variable 
//of type char causes AV, like KeyPress event handler    
function TypeName2VarTyp(TypeName: string): Word;
begin
  if Cmp(TypeName, 'integer') or Cmp(TypeName, 'longint') or
     Cmp(TypeName, 'dword')then
    Result := varInteger
  else if Cmp(TypeName, 'word') or Cmp(TypeName, 'smallint') then
    Result := varSmallInt
  else if Cmp(TypeName, 'byte') then
    Result := varByte
  else if Cmp(TypeName, 'wordbool') or Cmp(TypeName, 'boolean') or
     Cmp(TypeName, 'bool') then
    Result := varBoolean
  else if Cmp(TypeName, 'string') or Cmp(TypeName, 'PChar') or
    Cmp(TypeName, 'ANSIString') or Cmp(TypeName, 'ShortString')
      or Cmp(TypeName, 'char') then {+RWare}
    Result := varString
  else if Cmp(TypeName, 'double') then
    Result := varDouble
  else if Cmp(TypeName, 'tdatetime') or Cmp(TypeName, 'tdate') or
    Cmp(TypeName, 'ttime')then
    Result := varDate
  else if Cmp(TypeName, 'tobject') then
    Result := varObject
  else if Cmp(TypeName, 'pointer') then
    Result := varPointer
  else
    Result := varEmpty;
end; { TypeName2VarTyp }

function VarType2TypeName(VType: Word): string;
begin
     Result:='';
     case VType of
        varEmpty:    Result:='Unassigned';
        varNull:     Result:='Null';
        varSmallint: Result:='Smallint';
        varInteger:  Result:='Integer';
        varSingle:   Result:='Single';
        varDouble:   Result:='Double';
        varCurrency: Result:='Currency';
        varDate:     Result:='Date';
        varOleStr:   Result:='OleStr';
        varDispatch: Result:='Dispatch';
        varError:    Result:='Error';
        varBoolean:  Result:='Boolean';
        varVariant:  Result:='Variant';
        varUnknown:  Result:='Unknown';
        varByte:     Result:='Byte';
        varStrArg:   Result:='StrArg';
        varString:   Result:='String';
        varAny:      Result:='Any';
        varTypeMask: Result:='TypeMask';
        varArray:    Result:='Array';
        varByRef:    Result:='ByRef';
        varObject:   Result:='TObject';
//        varClass:    Result:='Class';
        varPointer:  Result:='Pointer';
        varSet:      Result:='Set';
//        varArray:    Result:='Array';
        varRecord:   Result:='Record';
      end;
end;

procedure ClearList(List: TList);
var
  i: Integer;
begin
  if not Assigned(List) then Exit;
  for i := 0 to List.Count - 1 do { Iterate }
    TObject(List[i]).Free;
  List.Clear;
end; { ClearList }

procedure ClearMethodList(List: TList);
var
  i: Integer;
begin
  for i := 0 to List.Count - 1 do { Iterate }
    Dispose(PMethod(List[i]));
  List.Clear;
end; { ClearMethodList }


{$IFNDEF RA_D3H}

constructor TStringStream.Create(const AString: string);
begin
  inherited Create;
  FDataString := AString;
end;

function TStringStream.Read(var Buffer; Count: Longint): Longint;
begin
  Result := Length(FDataString) - FPosition;
  if Result > Count then Result := Count;
  Move(PChar(@FDataString[FPosition + 1])^, Buffer, Result);
  Inc(FPosition, Result);
end;

function TStringStream.Write(const Buffer; Count: Longint): Longint;
begin
  Result := Count;
  SetLength(FDataString, (FPosition + Result));
  Move(Buffer, PChar(@FDataString[FPosition + 1])^, Result);
  Inc(FPosition, Result);
end;

function TStringStream.Seek(Offset: Longint; Origin: Word): Longint;
begin
  case Origin of
    soFromBeginning: FPosition := Offset;
    soFromCurrent: FPosition := FPosition + Offset;
    soFromEnd: FPosition := Length(FDataString) - Offset;
  end;
  Result := FPosition;
end;

procedure TStringStream.SetSize(NewSize: Longint);
begin
  SetLength(FDataString, NewSize);
  if FPosition > NewSize then FPosition := NewSize;
end;
{$ENDIF}

{$IFNDEF RA_D3H}
function AnsiStrIComp(S1, S2: PChar): Integer;
begin
  Result := CompareString(LOCALE_USER_DEFAULT, NORM_IGNORECASE, S1, -1,
    S2, -1) - 2;
end;

function AnsiStrLIComp(S1, S2: PChar; MaxLen: Cardinal): Integer;
begin
  Result := CompareString(LOCALE_USER_DEFAULT, NORM_IGNORECASE,
    S1, MaxLen, S2, MaxLen) - 2;
end;
{$ENDIF RA_D3H}

{************* Some code from RAUtils unit **************}
function SubStr(const S : string; const index : integer; const Separator : string) : string;
 {Вырезает подстроку. Подстроки разделяются символом Sep}
var
  i : integer;
  pB, pE : PChar;
begin
  Result := '';
  if ((index < 0) or ((index = 0) and (Length(S) > 0) and (S[1] = Separator))) or
    (Length(S) = 0) then exit;
  pB := PChar(S);
  for i := 1 to index do begin
    pB := StrPos(pB, PChar(Separator));
    if pB = nil then exit;
    pB := pB+Length(Separator);
    if pB[0] = #0 then exit;
  end;
  pE := StrPos(pB+1, PChar(Separator));
  if pE = nil then pE := PChar(S)+Length(S);
  if not (ANSIStrLIComp(pB, PChar(Separator), Length(Separator)) = 0) then
    SetString(Result, pB, pE-pB);
end;
{
function GetLineByPos(const S : string; const Pos : integer) : integer;
var
  i : integer;
begin
  if Length(S) < Pos then Result := -1
  else begin
    i := 1;
    Result := 0;
    while (i <= Pos) do begin
      if S[i] = #13 then inc(Result);
      inc(i);
    end;
  end;
end;
}
function GetLineByPos(const S : string; const Pos : integer) : integer;
var
  i: Integer;
begin
  if Length(S) < Pos then Result := -1
  else begin
    i := 1;
    Result := 0;
    while (i <= Pos) do begin
      if S[i] = #13 then inc(Result);
      inc(i);
    end;
  end;
end;

function Cmp(const S1, S2 : string) : boolean;
begin
{$IFDEF RA_VCL}
  // Direct call to CompareString is faster when ANSICompareText.
  Result := (Length(S1) = Length(S2)) and
    (CompareString(LOCALE_USER_DEFAULT, NORM_IGNORECASE, PChar(S1),
     -1, PChar(S2), -1) = 2);
{$ENDIF RA_VCL}
{$IFDEF RA_CLX}
  Result := ANSICompareText(S1, S2) = 0;
{$ENDIF RA_CLX}
end;    { Cmp }
{################## from RAUtils unit ##################}

{************* Some code from RAStream unit **************}
procedure StringSaveToStream(Stream : TStream; S : string);
var
  L : integer;
  P : PChar;
begin
  L := Length(S);
  Stream.WriteBuffer(L, sizeof(L));
  P := PChar(S);
  Stream.WriteBuffer(P^, L);
end;

function StringLoadFromStream(Stream : TStream) : string;
var
  L : integer;
  P : PChar;
begin
  Stream.ReadBuffer(L, sizeof(L));
  SetLength(Result, L);
  P := PChar(Result);
  Stream.ReadBuffer(P^, L);
end;

procedure IntSaveToStream(Stream : TStream; int : integer);
begin
  Stream.WriteBuffer(int, sizeof(int));
end;

function IntLoadFromStream(Stream : TStream) : integer;
begin
  Stream.ReadBuffer(Result, sizeof(Result));
end;

procedure WordSaveToStream(Stream : TStream; int : Word);
begin
  Stream.WriteBuffer(int, sizeof(int));
end;

function WordLoadFromStream(Stream : TStream) : Word;
begin
  Stream.ReadBuffer(Result, sizeof(Result));
end;

procedure ExtendedSaveToStream(Stream : TStream; Ext : Extended);
begin
  Stream.WriteBuffer(Ext, sizeof(Ext));
end;

function ExtendedLoadFromStream(Stream : TStream) : Extended;
begin
  Stream.ReadBuffer(Result, sizeof(Result));
end;

procedure BoolSaveToStream(Stream : TStream; bool : boolean);
var
  B : integer;
begin
  B := integer(bool);
  Stream.WriteBuffer(B, sizeof(B));
end;

function BoolLoadFromStream(Stream : TStream) : boolean;
var
  B : integer;
begin
  Stream.ReadBuffer(B, sizeof(B));
  Result := boolean(B);
end;
{################## from RAStream unit ##################}


{$IFDEF RAI2_OLEAUTO}
{************* Some code from Delphi's OleAuto unit **************}
const
{$IFDEF RA_D3H}
{ Maximum number of dispatch arguments }

  MaxDispArgs = 64;
{$ENDIF RA_D3H}

{ Special variant type codes }

  varStrArg = $0048;

{ Parameter type masks }

  atVarMask = $3F;
  atTypeMask = $7F;
  atByRef = $80;

{ Call GetIDsOfNames method on the given IDispatch interface }

(*procedure GetIDsOfNames(Dispatch: IDispatch; Names: PChar;
  NameCount: Integer; DispIDs: PDispIDList);
var
  I, N: Integer;
  Ch: WideChar;
  P: PWideChar;
  NameRefs: array[0..MaxDispArgs - 1] of PWideChar;
  WideNames: array[0..1023] of WideChar;
  R: Integer;
begin
  I := 0;
  N := 0;
  repeat
    P := @WideNames[I];
    if N = 0 then NameRefs[0] := P else NameRefs[NameCount - N] := P;
    repeat
      Ch := WideChar(Names[I]);
      WideNames[I] := Ch;
      Inc(I);
    until Char(Ch) = #0;
    Inc(N);
  until N = NameCount;
  R := Dispatch.GetIDsOfNames(GUID_NULL, @NameRefs, NameCount, LOCALE_SYSTEM_DEFAULT, DispIDs);
  if R <> 0 then
    raise EOleError.CreateFmt(SNoMethod, [Names]);
end;

{ Central call dispatcher }

procedure DispatchInvokeEx(const Dispatch: IDispatch; CallDesc: PCallDesc;
  DispIDs: PDispIDList; Params: Pointer; Result: PVariant);
type
  PVarArg = ^TVarArg;
  TVarArg = array[0..3] of DWORD;
  TStringDesc = record
    BStr: PWideChar;
    PStr: PString;
  end;
var
  I, J, K, ArgType, ArgCount, StrCount, DispID, InvKind, Status: Integer;
  VarFlag: Byte;
  ParamPtr: ^Integer;
  ArgPtr, VarPtr: PVarArg;
  DispParams: TDispParams;
  ExcepInfo: TExcepInfo;
  Strings: array[0..MaxDispArgs - 1] of TStringDesc;
  Args: array[0..MaxDispArgs - 1] of TVarArg;
begin
  StrCount := 0;
  try
    ArgCount := CallDesc^.ArgCount;
    if ArgCount <> 0 then
    begin
      ParamPtr := Params;
      ArgPtr := @Args[ArgCount];
      I := 0;
      repeat
        Dec(Integer(ArgPtr), SizeOf(TVarData));
        ArgType := CallDesc^.ArgTypes[I] and atTypeMask;
        VarFlag := CallDesc^.ArgTypes[I] and atByRef;
        if ArgType = varError then
        begin
          ArgPtr^[0] := varError;
          ArgPtr^[2] := DWORD(DISP_E_PARAMNOTFOUND);
        end else
        begin
          if ArgType = varStrArg then
          begin
            with Strings[StrCount] do
              if VarFlag <> 0 then
              begin
                BStr := StringToOleStr(PString(ParamPtr^)^);
                PStr := PString(ParamPtr^);
                ArgPtr^[0] := varOleStr or varByRef;
                ArgPtr^[2] := Integer(@BStr);
              end else
              begin
                BStr := StringToOleStr(PString(ParamPtr)^);
                PStr := nil;
                ArgPtr^[0] := varOleStr;
                ArgPtr^[2] := Integer(BStr);
              end;
            Inc(StrCount);
          end else
          if VarFlag <> 0 then
          begin
            if (ArgType = varVariant) and
              (PVarData(ParamPtr^)^.VType = varString) then
              VarCast(PVariant(ParamPtr^)^, PVariant(ParamPtr^)^, varOleStr);
            ArgPtr^[0] := ArgType or varByRef;
            ArgPtr^[2] := ParamPtr^;
          end else
          if ArgType = varVariant then
          begin
            if PVarData(ParamPtr)^.VType = varString then
            begin
              with Strings[StrCount] do
              begin
                BStr := StringToOleStr(string(PVarData(ParamPtr^)^.VString));
                PStr := nil;
                ArgPtr^[0] := varOleStr;
                ArgPtr^[2] := Integer(BStr);
              end;
              Inc(StrCount);
            end else
            begin
              VarPtr := PVarArg(ParamPtr);
              ArgPtr^[0] := VarPtr^[0];
              ArgPtr^[1] := VarPtr^[1];
              ArgPtr^[2] := VarPtr^[2];
              ArgPtr^[3] := VarPtr^[3];
              Inc(Integer(ParamPtr), 12);
            end;
          end else
          begin
            ArgPtr^[0] := ArgType;
            ArgPtr^[2] := ParamPtr^;
            if (ArgType >= varDouble) and (ArgType <= varDate) then
            begin
              Inc(Integer(ParamPtr), 4);
              ArgPtr^[3] := ParamPtr^;
            end;
          end;
          Inc(Integer(ParamPtr), 4);
        end;
        Inc(I);
      until I = ArgCount;
    end;
    DispParams.rgvarg := @Args;
    DispParams.rgdispidNamedArgs := @DispIDs[1];
    DispParams.cArgs := ArgCount;
    DispParams.cNamedArgs := CallDesc^.NamedArgCount;
    DispID := DispIDs[0];
    InvKind := CallDesc^.CallType;
    if InvKind = DISPATCH_PROPERTYPUT then
    begin
      if Args[0][0] and varTypeMask = varDispatch then
        InvKind := DISPATCH_PROPERTYPUTREF;
      DispIDs[0] := DISPID_PROPERTYPUT;
      Dec(Integer(DispParams.rgdispidNamedArgs), SizeOf(Integer));
      Inc(DispParams.cNamedArgs);
    end else
      if (InvKind = DISPATCH_METHOD) and (ArgCount = 0) and (Result <> nil) then
        InvKind := DISPATCH_METHOD or DISPATCH_PROPERTYGET;
    Status := Dispatch.Invoke(DispID, GUID_NULL, 0, InvKind, DispParams,
      Result, @ExcepInfo, nil);
    if Status <> 0 then DispatchInvokeError(Status, ExcepInfo);
    J := StrCount;
    while J <> 0 do
    begin
      Dec(J);
      with Strings[J] do
        if PStr <> nil then OleStrToStrVar(BStr, PStr^);
    end;
  finally
    K := StrCount;
    while K <> 0 do
    begin
      Dec(K);
      SysFreeString(Strings[K].BStr);
    end;
  end;
end;

procedure VarDispInvoke(Result: PVariant; const Instance: Variant;
  Names: PChar; CallDesc: PCallDesc; ParamTypes: Pointer); cdecl;

  procedure RaiseException;
  begin
    raise EOleError.CreateRes(@SVarNotObject);
  end;

var
  DispIDs: array[0..MaxDispArgs - 1] of Integer;
  Dispatch: Pointer;
begin
  if TVarData(Instance).VType = varDispatch then
    Dispatch := TVarData(Instance).VDispatch
  else if TVarData(Instance).VType = (varDispatch or varByRef) then
    Dispatch := Pointer(TVarData(Instance).VPointer^)
  else RaiseException;
  GetIDsOfNames(IDispatch(Dispatch), Names, CallDesc^.NamedArgCount + 1, @DispIDs);
  if Result <> nil then VarClear(Result^);
  DispatchInvokeEx(IDispatch(Dispatch), CallDesc, @DispIDs, ParamTypes, Result);
end;*)


procedure DispatchInvoke(const Dispatch: IDispatch; CallDesc: PCallDesc;
  DispIDs: PDispIDList; Params: Pointer; Result: PVariant);
type
  PVarArg = ^TVarArg;
  TVarArg = array[0..3] of DWORD;
  TStringDesc = record
    BStr: PWideChar;
    PStr: PString;
  end;
var
  I, J, K, ArgType, ArgCount, StrCount, DispID, InvKind, Status: Integer;
  VarFlag: Byte;
  ParamPtr: ^Integer;
  ArgPtr, VarPtr: PVarArg;
  DispParams: TDispParams;
  ExcepInfo: TExcepInfo;
  Strings: array[0..MaxDispArgs - 1] of TStringDesc;
  Args: array[0..MaxDispArgs - 1] of TVarArg;
begin
  StrCount := 0;
  try
    ArgCount := CallDesc^.ArgCount;
    if ArgCount <> 0 then
    begin
      ParamPtr := Params;
      ArgPtr := @Args[ArgCount];
      I := 0;
      repeat
        Dec(Integer(ArgPtr), SizeOf(TVarData));
        ArgType := CallDesc^.ArgTypes[I] and atTypeMask;
        VarFlag := CallDesc^.ArgTypes[I] and atByRef;
        if ArgType = varError then
        begin
          ArgPtr^[0] := varError;
          ArgPtr^[2] := DWORD(DISP_E_PARAMNOTFOUND);
        end else
        begin
          if ArgType = varStrArg then
          begin
            with Strings[StrCount] do
              if VarFlag <> 0 then
              begin
                BStr := StringToOleStr(PString(ParamPtr^)^);
                PStr := PString(ParamPtr^);
                ArgPtr^[0] := varOleStr or varByRef;
                ArgPtr^[2] := Integer(@BStr);
              end else
              begin
                BStr := StringToOleStr(PString(ParamPtr)^);
                PStr := nil;
                ArgPtr^[0] := varOleStr;
                ArgPtr^[2] := Integer(BStr);
              end;
            Inc(StrCount);
          end else
          if VarFlag <> 0 then
          begin
            if (ArgType = varVariant) and
              (PVarData(ParamPtr^)^.VType = varString) then
              VarCast(PVariant(ParamPtr^)^, PVariant(ParamPtr^)^, varOleStr);
            ArgPtr^[0] := ArgType or varByRef;
            ArgPtr^[2] := ParamPtr^;
          end else
          if ArgType = varVariant then
          begin
            if PVarData(ParamPtr)^.VType = varString then
            begin
              with Strings[StrCount] do
              begin
                BStr := StringToOleStr(string(PVarData(ParamPtr^)^.VString));
                PStr := nil;
                ArgPtr^[0] := varOleStr;
                ArgPtr^[2] := Integer(BStr);
              end;
              Inc(StrCount);
            end else
            begin
              VarPtr := PVarArg(ParamPtr);
              ArgPtr^[0] := VarPtr^[0];
              ArgPtr^[1] := VarPtr^[1];
              ArgPtr^[2] := VarPtr^[2];
              ArgPtr^[3] := VarPtr^[3];
              Inc(Integer(ParamPtr), 12);
            end;
          end else
{          if ArgType = VT_SAFEARRAY then begin
            DispParams.rgvarg^[0].vt:=VT_ARRAY or VT_UI1;
            DispParams.rgvarg^[0].parray:=ParamPtr;
          end else}
          begin
            ArgPtr^[0] := ArgType;
            ArgPtr^[2] := ParamPtr^;
            if (ArgType >= varDouble) and (ArgType <= varDate) then
            begin
              Inc(Integer(ParamPtr), 4);
              ArgPtr^[3] := ParamPtr^;
            end;
          end;
          Inc(Integer(ParamPtr), 4);
        end;
        Inc(I);
      until I = ArgCount;
    end;
    DispParams.rgvarg := @Args;
    DispParams.rgdispidNamedArgs := @DispIDs[1];
    DispParams.cArgs := ArgCount;
    DispParams.cNamedArgs := CallDesc^.NamedArgCount;
    DispID := DispIDs[0];
    InvKind := CallDesc^.CallType;
    if InvKind = DISPATCH_PROPERTYPUT then
    begin
      if Args[0][0] and varTypeMask = varDispatch then
        InvKind := DISPATCH_PROPERTYPUTREF;
      DispIDs[0] := DISPID_PROPERTYPUT;
      Dec(Integer(DispParams.rgdispidNamedArgs), SizeOf(Integer));
      Inc(DispParams.cNamedArgs);
    end else
      if (InvKind = DISPATCH_METHOD) and (ArgCount = 0) and (Result <> nil) then
        InvKind := DISPATCH_METHOD or DISPATCH_PROPERTYGET;
    Status := Dispatch.Invoke(DispID, GUID_NULL, 0, InvKind, DispParams,
      Result, @ExcepInfo, nil);
    if Status <> 0 then DispatchInvokeError(Status, ExcepInfo);
    J := StrCount;
    while J <> 0 do
    begin
      Dec(J);
      with Strings[J] do
        if PStr <> nil then OleStrToStrVar(BStr, PStr^);
    end;
  finally
    K := StrCount;
    while K <> 0 do
    begin
      Dec(K);
      SysFreeString(Strings[K].BStr);
    end;
  end;
end;

{ Call GetIDsOfNames method on the given IDispatch interface }

procedure GetIDsOfNames(const Dispatch: IDispatch; Names: PChar;
  NameCount: Integer; DispIDs: PDispIDList);

  procedure RaiseNameException;
  begin
    raise EOleError.CreateResFmt(@SNoMethod, [Names]);
  end;

type
  PNamesArray = ^TNamesArray;
  TNamesArray = array[0..0] of PWideChar;
var
  N, SrcLen, DestLen: Integer;
  Src: PChar;
  Dest: PWideChar;
  NameRefs: PNamesArray;
  StackTop: Pointer;
  Temp: Integer;
  Disp: IDispatch;
  outCount: Integer;
begin
  Src := Names;
  N := 0;
  asm
    MOV  StackTop, ESP
    MOV  EAX, NameCount
    INC  EAX
    SHL  EAX, 2  // sizeof pointer = 4
    SUB  ESP, EAX
    LEA  EAX, NameRefs
    MOV  [EAX], ESP
  end;
  repeat
    SrcLen := StrLen(Src);
    DestLen := MultiByteToWideChar(0, 0, Src, SrcLen, nil, 0) + 1;
    asm
      MOV  EAX, DestLen
      ADD  EAX, EAX
      ADD  EAX, 3      // round up to 4 byte boundary
      AND  EAX, not 3
      SUB  ESP, EAX
      LEA  EAX, Dest
      MOV  [EAX], ESP
    end;
    if N = 0 then NameRefs[0] := Dest else NameRefs[NameCount - N] := Dest;
    MultiByteToWideChar(0, 0, Src, SrcLen, Dest, DestLen);
    Dest[DestLen-1] := #0;
    Inc(Src, SrcLen+1);
    Inc(N);
  until N = NameCount;

  outCount:=0;
  Dispatch.GetTypeInfoCount(outCount);
  if outCount>0 then outCount:=outCount+1-1;

  Dispatch.QueryInterface(IDispatch,Disp);
  if Disp<>nil then begin
    Temp := Dispatch.GetIDsOfNames(GUID_NULL, NameRefs, NameCount, GetThreadLocale, DispIDs);
//    Temp := Disp.GetIDsOfNames(GUID_NULL, NameRefs, NameCount, LOCALE_SYSTEM_DEFAULT, DispIDs);
    if Temp = Integer(DISP_E_UNKNOWNNAME) then RaiseNameException else OleCheck(Temp);
  end;
  asm
    MOV  ESP, StackTop
  end;
end;

{ Central call dispatcher }

procedure VarDispInvoke(Result: PVariant; const Instance: Variant;
  CallDesc: PCallDesc; Params: Pointer); cdecl;

  procedure RaiseException;
  begin
    raise EOleError.CreateRes(@SVarNotObject);
  end;

var
  Dispatch: Pointer;
  DispIDs: array[0..MaxDispArgs - 1] of Integer;
//  DispIDs: TDispIDList;
begin
  if TVarData(Instance).VType = varDispatch then
    Dispatch := TVarData(Instance).VDispatch
  else if TVarData(Instance).VType = (varDispatch or varByRef) then
    Dispatch := Pointer(TVarData(Instance).VPointer^)
  else RaiseException;
  GetIDsOfNames(IDispatch(Dispatch), @CallDesc^.ArgTypes[CallDesc^.ArgCount], CallDesc^.NamedArgCount + 1, @DispIDs);
  if Result <> nil then VarClear(Result^);
  DispatchInvoke(IDispatch(Dispatch), CallDesc, @DispIDs, Params, Result);
end;


{################## from OleAuto unit ##################}
{$ENDIF RAI2_OLEAUTO}

type
  TFunc = procedure; far;
  TiFunc = function: integer; far;
  TfFunc = function: boolean; far;
  TwFunc = function: word; far;

function CallDllIns(Ins: HINST; FuncName: string; Args: TArgs;
  ParamDesc: TTypeArray; ResTyp: Word): Variant;
var
{  Func: procedure; far;
  iFunc: function: integer; far;
  fFunc: function: boolean; far;
  wFunc: function: word; far; }
  Func : TFunc ;
  iFunc: TiFunc;
  fFunc: TfFunc;
  wFunc: TwFunc;
  i: integer;
  Aint: integer;
 // Abyte : byte;
  Aword : word;              
  Apointer: pointer;
  Str: string;
begin
  Result := Null;
  Func := GetProcAddress(Ins, PChar(FuncName));
  iFunc := @Func; fFunc := @Func; wFunc := @Func;
  if @Func <> nil then
  begin

    try

      for i := Args.Count - 1 downto 0 do { 'stdcall' call conversion }
      begin
        if (ParamDesc[i] and varByRef) = 0 then
          case ParamDesc[i] of
            varInteger,{ ttByte,} varBoolean:
              begin Aint := Args.Values[i]; asm push Aint end; end;
            varSmallInt:
              begin Aword := Word(Args.Values[i]); asm push Aword end; end;
            varString:
              begin Apointer := PChar(string(Args.Values[i])); asm push Apointer end; end;
            else
              RAI2ErrorN(ieDllInvalidArgument, -1, FuncName);
          end
        else
          case ParamDesc[i] and not varByRef of
            varInteger,{ ttByte,} varBoolean:
              begin Apointer := @TVarData(Args.Values[i]).vInteger; asm push Apointer end; end;
            varSmallInt:
              begin Apointer := @TVarData(Args.Values[i]).vSmallInt; asm push Apointer end; end;
            else
              RAI2ErrorN(ieDllInvalidArgument, -1, FuncName);
          end
      end;

      case ResTyp of
        varSmallInt:
          Result := wFunc;
        varInteger:
          Result := iFunc;
        varBoolean:
          Result := Boolean(integer(fFunc));
        varEmpty:
          Func;
        else
          RAI2ErrorN(ieDllInvalidResult, -1, FuncName);
      end;

    except
      on E: ERAI2Error do
        raise E;
      on E: Exception do
      begin
        Str := E.Message;
        UniqueString(Str);
        raise Exception.Create(Str);
      end;
    end;

  end
  else
    RAI2Error(ieDllFunctionNotFound, -1);
end;

function CallDll(DllName, FuncName: string; Args: TArgs;
  ParamDesc: TTypeArray; ResTyp: Word): Variant;
var
  Ins: HINST;
  LastError: DWORD;
begin
  Result := false;
  Ins := LoadLibrary(PChar(DllName));
  if Ins = 0 then
    RAI2ErrorN(ieDllErrorLoadLibrary, -1, DllName);
  try
    Result := CallDllIns(Ins, FuncName, Args, ParamDesc, ResTyp);
    LastError := GetLastError;
  finally { wrap up }
    FreeLibrary(Ins);
  end; { try/finally }
  SetLastError(LastError);
end;

procedure ConvertParamTypes(InParams: array of Word; var OutParams: TTypeArray);
var
  i: Integer;
begin
  for i := Low(InParams) to High(InParams) do { Iterate }
    OutParams[i] := InParams[i];
end; { ConvertParamTypes }

procedure ConvertParamNames(InParams: array of string;
  var OutParams: TNameArray);
var
  i: Integer;
begin
  for i := Low(InParams) to High(InParams) do { Iterate }
    OutParams[i] := InParams[i];
end; { ConvertParamTypes }

{ ************************* Array support ************************* }

const
  {Max avalaible dimension for arrays}
  RAI2_MAX_ARRAY_DIMENSION = 10;

type

  TRAI2ArrayValues = array[0..RAI2_MAX_ARRAY_DIMENSION - 1] of Integer;

  PRAI2ArrayRec = ^TRAI2ArrayRec;
  TRAI2ArrayRec = packed record
    Dimension: Integer; {number of dimensions}
    BeginPos: TRAI2ArrayValues; {starting range for all dimensions}
    EndPos: TRAI2ArrayValues; {ending range for all dimensions}
    ItemType: Integer; {array type}
    ElementSize: Integer; {size of element in bytes}
    Size: Integer; {number of elements in array}
    Memory: Pointer; {pointer to memory representation of array}
  end;
  
function GetArraySize(Dimension: Integer; BeginPos,
  EndPos: TRAI2ArrayValues): Integer;
var
  A: Integer;
begin
  Result := 1;
  for A := 0 to Dimension - 1 do
  begin
    Result := Result * ((EndPos[A] - BeginPos[A]) + 1);
  end;
end;

{Calculate starting position of element in memory}

function GetArrayOffset(Dimension: Integer; BeginPos, EndPos: TRAI2ArrayValues;
  Element: TRAI2ArrayValues): Integer;
var
  A: Integer;
  LastDim: Integer;
begin
  Result := 0;
  LastDim := 1;
  for A := 0 to Dimension - 1 do
  begin
    if (Element[A] < BeginPos[A]) or (Element[A] > EndPos[A]) then
      RAI2Error(ieArrayIndexOutOfBounds, -1);
    Result := Result + (LastDim * (Element[A] - BeginPos[A]));
    LastDim := LastDim * (EndPos[A] - BeginPos[A] + 1);
  end;
end;

{Allocate memory for new array}

function RAI2ArrayInit(const Dimension: Integer; const BeginPos,
  EndPos: TRAI2ArrayValues; const ItemType: Integer): PRAI2ArrayRec;
var
  PP: PRAI2ArrayRec;
  SS: TStringList;
  AA: Integer;
  ArraySize: Integer;
begin
  if (Dimension < 1) or (Dimension > MaxArgs) then
    RAI2Error(ieArrayBadDimension, -1);
  for AA := 0 to Dimension - 1 do
  begin
    if not (BeginPos[AA] <= EndPos[AA]) then
      RAI2Error(ieArrayBadRange, -1);
  end;

  New(PP);
  PP^.BeginPos := BeginPos;
  PP^.EndPos := EndPos;
  PP^.ItemType := ItemType;
  ArraySize := GetArraySize(Dimension, BeginPos, EndPos);
  PP^.Size := ArraySize;
  PP^.Dimension := Dimension;
  case ItemType of
    varInteger, varObject:
      begin
        PP^.ElementSize := SizeOf(Integer);
      end;
    varDouble:
      begin
        PP^.ElementSize := SizeOf(Double);
      end;
    varByte:
      begin
        PP^.ElementSize := SizeOf(Byte);
      end;
    varSmallInt:
      begin
        PP^.ElementSize := SizeOf(varSmallInt);
      end;
    varDate:
      begin
        PP^.ElementSize := SizeOf(Double);
      end;
    varString:
      begin
        PP^.ElementSize := 0;
        SS := TStringList.Create;
        for AA := 1 to ArraySize do
          SS.Add('');
        PP^.Memory := SS;
      end;
  end;
  if ItemType <> varString then
  begin
    GetMem(PP^.Memory, ArraySize * PP^.ElementSize);
    //ZeroMemory(PP^.Memory, ArraySize * PP^.ElementSize);
    FillChar(PP^.Memory^, ArraySize * PP^.ElementSize, 0);
  end;
  Result := PP;
end;

{Free memory for array}

procedure RAI2ArrayFree(RAI2ArrayRec: PRAI2ArrayRec);
begin
  if not Assigned(RAI2ArrayRec) then Exit;
  if (RAI2ArrayRec^.ItemType <> varString) then
  begin
    FreeMem(RAI2ArrayRec^.Memory, (RAI2ArrayRec^.Size) *
      RAI2ArrayRec^.ElementSize);
    Dispose(RAI2ArrayRec);
  end
  else
  begin
    TStringList(RAI2ArrayRec^.Memory).Clear;
    TStringList(RAI2ArrayRec^.Memory).Free;
    Dispose(RAI2ArrayRec);
  end;
end;

{Set element for array}

procedure RAI2ArraySetElement(Element: TRAI2ArrayValues; Value: Variant;
  RAI2ArrayRec: PRAI2ArrayRec);
var
  Offset: Integer;
begin
  if RAI2ArrayRec^.Dimension > 1 then
    Offset := GetArrayOffset(RAI2ArrayRec^.Dimension, RAI2ArrayRec^.BeginPos,
      RAI2ArrayRec^.EndPos, Element)
  else
    Offset := Element[0] - RAI2ArrayRec^.BeginPos[0];
  case RAI2ArrayRec^.ItemType of
    varInteger:
      PInteger(Pointer(Integer(RAI2ArrayRec^.Memory) +
        (Offset * RAI2ArrayRec^.ElementSize)))^ := Value;
    varDouble:
      PDouble(Pointer(Integer(RAI2ArrayRec^.Memory) +
        (Offset * RAI2ArrayRec^.ElementSize)))^ := Value;
    varByte:
      PByte(Pointer(Integer(RAI2ArrayRec^.Memory) +
        (Offset * RAI2ArrayRec^.ElementSize)))^ := Value;
    varSmallInt:
      PSmallInt(Pointer(Integer(RAI2ArrayRec^.Memory) +
        (Offset * RAI2ArrayRec^.ElementSize)))^ := Value;
    varDate:
      PDouble(Pointer(Integer(RAI2ArrayRec^.Memory) +
        (Offset * RAI2ArrayRec^.ElementSize)))^ := Value;
    varString:
      begin
        Value := VarAsType(Value, varString);
        TStringList(RAI2ArrayRec^.Memory).Strings[Offset] := Value;
      end;
    varObject:
      PInteger(Pointer(Integer(RAI2ArrayRec^.Memory) +
        (Offset * RAI2ArrayRec^.ElementSize)))^ := TVarData(Value).VInteger;
  end;
end;

{Get element for array}

function RAI2ArrayGetElement(Element: TRAI2ArrayValues; RAI2ArrayRec:
  PRAI2ArrayRec): Variant;
var
  Offset: Integer;
begin
  if RAI2ArrayRec^.Dimension > 1 then
    Offset := GetArrayOffset(RAI2ArrayRec^.Dimension, RAI2ArrayRec^.BeginPos,
      RAI2ArrayRec^.EndPos, Element)
  else
    Offset := Element[0] - RAI2ArrayRec^.BeginPos[0];
  case RAI2ArrayRec^.ItemType of
    varInteger:
      Result := Integer(Pointer(Integer(RAI2ArrayRec^.Memory) + ((Offset) *
        RAI2ArrayRec^.ElementSize))^);
    varDouble:
      Result := Double(Pointer(Integer(RAI2ArrayRec^.Memory) + ((Offset) *
        RAI2ArrayRec^.ElementSize))^);
    varByte:
      Result := Byte(Pointer(Integer(RAI2ArrayRec^.Memory) + ((Offset) *
        RAI2ArrayRec^.ElementSize))^);
    varSmallInt:
      Result := SmallInt(Pointer(Integer(RAI2ArrayRec^.Memory) + ((Offset) *
        RAI2ArrayRec^.ElementSize))^);
    varDate:
      Result := TDateTime(Pointer(Integer(RAI2ArrayRec^.Memory) + ((Offset) *
        RAI2ArrayRec^.ElementSize))^);
    varString:
      Result := TStringList(RAI2ArrayRec^.Memory).Strings[Offset];
    varObject:
      begin
        Result := Integer(Pointer(Integer(RAI2ArrayRec^.Memory) + ((Offset) *
          RAI2ArrayRec^.ElementSize))^);
        TVarData(Result).VType := varObject;
      end;
  end;
end;

{ ########################## Array support ########################## }

{ ************************ extended variants ************************ }

function RAI2VarAsType(const V : Variant; const VarType : integer) : Variant;
begin
  if TVarData(V).VType in [varEmpty, varNull] then
  begin
    case VarType of
      varString,
      varOleStr    : Result := '';
      varInteger,
      varSmallint,
      varByte      : Result := 0;
      varBoolean   : Result := false;
      varSingle,
      varDouble,
      varCurrency,
      varDate      : Result := 0.0;
      varVariant   : Result := Null;
      else Result := VarAsType(V, VarType);
    end;
  end else
  begin
    case TVarData(V).VType of
      varInteger:
{        if (TVarData(V).VType = varType) then
          Result := Integer(V = True)
        else
          Result := Integer(V);}
        Result:=VarAsType(V, TVarData(V).VType);
      varArray:
        begin
          TVarData(Result) := TVarData(V);
          TVarData(Result).VType := VarType;
        end;
      /////////////////////
      varDate: begin
        Result:=VarAsType(V, TVarData(V).VType);
      end;
      varString: begin
        Result:=VarAsType(V, TVarData(V).VType);
      end;
      else
        Result := VarAsType(V, VarType);
    end;
  end;
end;

procedure RAI2VarCopy(var Dest: Variant; const Source: Variant);
begin
  if (TVarData(Source).VType=varRecord)or
     (TVarData(Source).VType=varArray) then
    TVarData(Dest) := TVarData(Source)
  else
    Dest := Source;
end;

procedure RAI2VarFree(var V: Variant);
begin
  case TVarData(V).VType of
    varArray:
      RAI2ArrayFree(PRAI2ArrayRec(TVarData(V).vPointer));
    varRecord:
      TRAI2RecHolder(TVarData(V).VPointer).Free;
  end;
  V := Null;
end;

{
function VarAsType2(const V: Variant; VarType: Integer): Variant;
begin
  if TVarData(V).VType = varNull then
    Result := VarAsType(Unassigned,VarType)
  else
    Result := VarAsType(V,VarType);
end;
}

function Var2Type(V : Variant; const VarType : integer) : variant;
begin
  if TVarData(V).VType in [varEmpty, varNull] then
  begin
    case VarType of
      varString,
      varOleStr    : Result := '';
      varInteger,
      varSmallint,
      varByte      : Result := 0;
      varBoolean   : Result := false;
      varSingle,
      varDouble,
      varCurrency,
      varDate      : Result := 0.0;
      varVariant   : Result := Null;
      else Result := VarAsType(V, VarType);
    end;
  end else
    Result := VarAsType(V, VarType);
  if (VarType = varInteger) and (TVarData(V).VType = varBoolean) then
    Result := Integer(V = True);
end;
{ ######################## extended variants ######################## }


{ ************************** TRAI2Var ************************** }
destructor TRAI2Var.Destroy;
begin
  RAI2VarFree(Value);
  inherited Destroy;
end;

{ ************************** TRAI2VarList ************************** }

destructor TRAI2VarList.Destroy;
begin
 {$IFNDEF RA_D4H}
  Clear;
 {$ENDIF}
  inherited Destroy;
end;

procedure TRAI2VarList.Clear;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    TRAI2Var(Items[i]).Free;
  inherited Clear;
end;

procedure TRAI2VarList.AddVar(UnitName, Identifer, Typ: string; VTyp: Word;
  const Value: Variant);
var
  VarRec: TRAI2Var;
begin
  if FindVar(UnitName, Identifer) <> nil then
    RAI2ErrorN(ieIdentiferRedeclared, -1, Identifer);
  VarRec := TRAI2Var.Create;
  VarRec.Identifer := Identifer;
  VarRec.UnitName := UnitName;
  RAI2VarCopy(VarRec.Value, Value);
  VarRec.Typ := Typ;
  VarRec.VTyp := VTyp;
  Insert(0, VarRec);
end;

function TRAI2VarList.FindVar(const UnitName, Identifer: string): TRAI2Var;
{ if UnitName = '', any unit allowed}
var
  i: Integer;
begin
  for i := 0 to Count - 1 do { Iterate }
  begin
    Result := TRAI2Var(Items[i]);
    if Cmp(Result.Identifer, Identifer) and
       (Cmp(Result.UnitName, UnitName) or (UnitName = '')) then
      Exit;
  end;
  Result := nil;
end;

procedure TRAI2VarList.DeleteVar(const UnitName, Identifer: string);
var
  i: Integer;
  VarRec: TRAI2Var;
begin
  for i := 0 to Count - 1 do { Iterate }
  begin
    VarRec := TRAI2Var(Items[i]);
    if Cmp(VarRec.Identifer, Identifer) and
       (Cmp(VarRec.UnitName, UnitName) or (UnitName = '')) then
    begin
      RAI2VarFree(VarRec.Value);
      VarRec.Free;
      Delete(i);
      Exit;
    end;
  end;
end; { DeleteVar }

function TRAI2VarList.GetValue(Identifer: string; var Value: Variant;
  Args: TArgs): Boolean;
var
  V: TRAI2Var;
begin
  if (Args.Obj = nil) then
    V := FindVar('', Identifer)
  else if (Args.ObjTyp = varObject) and (Args.Obj is TRAI2SrcUnit) then
    V := FindVar((Args.Obj as TRAI2SrcUnit).Identifer, Identifer)
  else
    V := nil;
  Result := V <> nil;
  if Result then
    RAI2VarCopy(Value, V.Value);
end; { GetValue }

(*
function TRAI2VarList.SetValue(Identifer: string; const Value: Variant;
  Args: TArgs): Boolean;
var
  V: TRAI2Var;
begin
  V := FindVar('', Identifer);
  Result := (V <> nil) and (Args.Obj = nil);
  if Result then
    RAI2VarCopy(V.Value, Value);
end; { SetValue }
*)

function TRAI2VarList.SetValue(Identifer: string; const Value: Variant;
  Args: TArgs): Boolean;
var
  V: TRAI2Var;
begin
  V := FindVar('', Identifer);
  Result := (V <> nil) and (Args.Obj = nil);
  if Result then
    { If 0, then it's probably an object }
    { If a Variant, then we don't care about typecasting }
    { We only want to typecast if the types are not the same, for speed }
    if (V.VTyp<>0) and
       (V.VTyp<>varVariant) and
       (TVarData(Value).VType<>V.VTyp) then
    begin
      { Is it a passed-by-reference variable? }
      if (V.VTyp and VarByRef>0) then
      begin
        RAI2VarCopy(V.Value, RAI2VarAsType(Value,V.VTyp and not VarByRef));
        V.VTyp := V.VTyp or VarByRef;
      end
      else
        RAI2VarCopy(V.Value, RAI2VarAsType(Value,V.VTyp))
    end
    else
      RAI2VarCopy(V.Value, Value);
end; { SetValue }

{ ************************** TAdapter ************************** }

 { TRAI2FunDesc }
function TRAI2FunDesc.GetParamType(Index: Integer): Word;
begin
  Result := FParamTypes[Index];
end;

function TRAI2FunDesc.GetParamName(Index: Integer): string;
begin
  Result := FParamNames[Index];
end;

function TRAI2FunDesc.GetParamPrefix(Index: Integer): string;
begin
  Result := ParamPrefixes[Index];
end;

 { TRAI2RecHolder }
constructor TRAI2RecHolder.Create(ARecordType: string; ARec: Pointer);
begin
  RecordType := ARecordType;
  Rec := ARec;
 {$IFDEF RAI2_DEBUG}
  inc(ObjCount);
 {$ENDIF RAI2_DEBUG}
end; { Create }

destructor TRAI2RecHolder.Destroy;
begin
  if Assigned(RAI2Record) then
  begin
    if Assigned(RAI2Record.DestroyFunc) then
      RAI2Record.DestroyFunc(Rec)
    else
      FreeMem(Rec, RAI2Record.RecordSize);
  end
  else
    RAI2Error(ieInternal, -1);
  inherited Destroy;
 {$IFDEF RAI2_DEBUG}
  dec(ObjCount);
 {$ENDIF RAI2_DEBUG}
end;

{ TRAI2SrcFun }
constructor TRAI2SrcFun.Create;
begin
  inherited Create;
  FunDesc := TRAI2FunDesc.Create;
end;

destructor TRAI2SrcFun.Destroy;
begin
  FunDesc.Free;
  inherited Destroy;
end;

 { TRAI2ExtFun }
function TRAI2ExtFun.CallDll(Args: TArgs): Variant;
begin
  if DllInstance > 0 then
    Result := RAI2.CallDllIns(DllInstance, FunName, Args, FunDesc.FParamTypes,
      FunDesc.ResTyp)
  else
    Result := RAI2.CallDll(DllName, FunName, Args, FunDesc.FParamTypes,
      FunDesc.ResTyp)
end;


{************************ TRAI2Event ************************}

(*constructor TRAI2Event.Create(AOwner: Pointer; AInstance: TObject; AUnitName, AFunName: PChar);
begin
  inherited Create(AOwner,AInstance,AUnitName,AFunName);
end;

function TRAI2Event.CallFunction(Args: TArguments; Params: array of Variant)
  : Variant;
var
  i: Integer;
  NV: Variant;
begin
  if Owner=nil then exit;
  if Args = nil then
    Args := Self.Args;
  TArgs(Args).Clear;
  for i := Low(Params) to High(Params) do { Iterate }
  begin
    Args.Values[TArgs(Args).Count] := Params[i];
    inc(TArgs(Args).Count);
  end; { for }
  NV := Null;
  Result := TRAI2Expression(Owner).CallFunctionEx(Instance, UnitName, FunName, TArgs(Args), NV);
end;

*)
{######################## TRAI2Event ########################}

{ TIdentiferList }

function TRAI2IdentiferList.Find(const Identifer: string; var Index: Integer)
  : Boolean;
var
  L, H, I, C: Integer;
begin
  Result := False;
  L := 0;
  H := Count - 1;
  while L <= H do
  begin
    I := (L + H) shr 1;
    C := AnsiStrIComp(PChar(TRAI2Identifer(List[I]).Identifer), PChar(Identifer));
    if C < 0 then L := I + 1 else
    begin
      H := I - 1;
      if C = 0 then
      begin
        Result := True;
        if Duplicates <> dupAccept then L := I;
      end;
    end;
  end;
  Index := L;
end;

procedure TRAI2IdentiferList.Sort;

  function SortIdentifer(Item1, Item2: Pointer): Integer;
  begin
    { function AnsiStrIComp about 30% faster when AnsiCompareText }
    { Result := AnsiCompareText(TRAI2Identifer(Item1).Identifer,
       TRAI2Identifer(Item2).Identifer); }
    Result := AnsiStrIComp(PChar(TRAI2Identifer(Item1).Identifer),
      PChar(TRAI2Identifer(Item2).Identifer));
  end;

begin
  inherited Sort(@SortIdentifer);
end;

function TRAI2IdentiferList.IndexOf(const UnitName, Identifer: string)
  : TRAI2Identifer;
var
  i: Integer;
begin
  for i := Count - 1 downto 0 do
  begin
    Result := TRAI2Identifer(Items[i]);
    if Cmp(Result.Identifer, Identifer) and
      ( Cmp(Result.UnitName, UnitName) or (UnitName = '')) then
      Exit;
  end;
  Result := nil;
end;

{************************ TRAI2Adapter ************************}

constructor TRAI2Adapter.Create(AOwner: TRAI2Expression);
begin
  FOwner := AOwner;
  FSrcUnitList := TRAI2IdentiferList.Create;
  FExtUnitList := TRAI2IdentiferList.Create;
  FGetList := TRAI2IdentiferList.Create;
  FSetList := TRAI2IdentiferList.Create;
  FIGetList := TRAI2IdentiferList.Create;
  FISetList := TRAI2IdentiferList.Create;
  FIDGetList := TRAI2IdentiferList.Create;
  FIDSetList := TRAI2IdentiferList.Create;
  FDGetList := TRAI2IdentiferList.Create;
  FClassList := TRAI2IdentiferList.Create;
  FConstList := TRAI2IdentiferList.Create;
  FFunList := TRAI2IdentiferList.Create;
  FRecList := TRAI2IdentiferList.Create;
  FRecGetList := TRAI2IdentiferList.Create;
  FRecSetList := TRAI2IdentiferList.Create;
  FOnGetList := TRAI2IdentiferList.Create;
  FOnSetList := TRAI2IdentiferList.Create;
  FExtFunList := TRAI2IdentiferList.Create;
  FSrcFunList := TRAI2IdentiferList.Create;
  FEventHandlerList := TRAI2IdentiferList.Create;
  FEventList := TRAI2IdentiferList.Create;
  FSrcVarList := TRAI2VarList.Create;
  FSrcClassList := TRAI2IdentiferList.Create;

  FGetList.Duplicates := dupAccept;
  FSetList.Duplicates := dupAccept;
  FIGetList.Duplicates := dupAccept;
  FISetList.Duplicates := dupAccept;
end;

destructor TRAI2Adapter.Destroy;
begin
  Clear;
  FSrcUnitList.Free;
  FExtUnitList.Free;
  FGetList.Free;
  FSetList.Free;
  FIGetList.Free;
  FISetList.Free;
  FIDGetList.Free;
  FIDSetList.Free;
  FDGetList.Free;
  FClassList.Free;
  FConstList.Free;
  FFunList.Free;
  FRecList.Free;
  FRecGetList.Free;
  FRecSetList.Free;
  FOnGetList.Free;
  FOnSetList.Free;
  FExtFunList.Free;
  FSrcFunList.Free;
  FEventHandlerList.Free;
  FEventList.Free;
  FSrcVarList.Free;
  FSrcClassList.Free;
  inherited Destroy;
end;

{ clear source }

procedure TRAI2Adapter.ClearSource;
begin
  ClearList(FSrcUnitList);
  ClearList(FSrcFunList);
  FSrcVarList.Clear;
  ClearList(FSrcClassList);
end;

{ clear all except source }

procedure TRAI2Adapter.ClearNonSource;
begin
  ClearList(FExtUnitList);
  ClearList(FGetList);
  ClearList(FSetList);
  ClearList(FIGetList);
  ClearList(FISetList);
  ClearList(FIDGetList);
  ClearList(FIDSetList);
  ClearList(FDGetList);
  ClearList(FClassList);
  ClearList(FConstList);
  ClearList(FFunList);
  ClearList(FRecList);
  ClearList(FRecGetList);
  ClearList(FRecSetList);
  ClearList(FExtFunList);
  ClearList(FEventHandlerList);
  ClearList(FEventList);
  ClearMethodList(FOnGetList);
  ClearMethodList(FOnSetList);
end;

{ clear all }

procedure TRAI2Adapter.Clear;
begin
  ClearSource;
  ClearNonSource;
end;

procedure TRAI2Adapter.Assign(Source: TRAI2Adapter);
var
  i: Integer;
begin
  if Source = Self then Exit;

  for i := 0 to Source.FGetList.Count - 1 do { Iterate }
    with TRAI2Method(Source.FGetList[i]) do
      AddGetEx(ClassType, Identifer, Func, ParamCount, ParamTypes, ResTyp, Data);
  for i := 0 to Source.FSetList.Count - 1 do { Iterate }
    with TRAI2Method(Source.FSetList[i]) do
      AddSetEx(ClassType, Identifer, Func, ParamCount, ParamTypes, Data);
  for i := 0 to Source.FIGetList.Count - 1 do { Iterate }
    with TRAI2Method(Source.FIGetList[i]) do
      AddIGetEx(ClassType, Identifer, Func, ParamCount, ParamTypes, ResTyp, Data);
  for i := 0 to Source.FISetList.Count - 1 do { Iterate }
    with TRAI2Method(Source.FISetList[i]) do
      AddISetEx(ClassType, Identifer, Func, ParamCount, ParamTypes, Data);
  for i := 0 to Source.FIDGetList.Count - 1 do { Iterate }
    with TRAI2Method(Source.FIDGetList[i]) do
      AddIDGetEx(ClassType, Func, ParamCount, ParamTypes, ResTyp, Data);
  for i := 0 to Source.FIDSetList.Count - 1 do { Iterate }
    with TRAI2Method(Source.FIDSetList[i]) do
      AddIDSetEx(ClassType, Func, ParamCount, ParamTypes, Data);
  for i := 0 to Source.FDGetList.Count - 1 do { Iterate }
    with TRAI2DMethod(Source.FDGetList[i]) do
      AddDGetEx(ClassType, Identifer, Func, ParamCount, ParamTypes, ResTyp,
        CallConvention, Data);
  for i := 0 to Source.FFunList.Count - 1 do { Iterate }
    with TRAI2Method(Source.FFunList[i]) do
      AddFunEx(UnitName, Identifer, Func, ParamCount, ParamTypes, ResTyp, Data);
  for i := 0 to Source.FExtUnitList.Count - 1 do { Iterate }
    with TRAI2Identifer(Source.FExtUnitList[i]) do
      AddExtUnitEx(Identifer, Data);
  for i := 0 to Source.FClassList.Count - 1 do { Iterate }
    with TRAI2Class(Source.FClassList[i]) do
      AddClassEx(UnitName, ClassType, Identifer, Data);
  for i := 0 to Source.FConstList.Count - 1 do { Iterate }
    with TRAI2Const(Source.FConstList[i]) do
      AddConstEx(UnitName, Identifer, Value, Data);
  for i := 0 to Source.FRecList.Count - 1 do { Iterate }
    with TRAI2Record(Source.FRecList[i]) do
      AddRecEx(UnitName, Identifer, RecordSize, Fields, CreateFunc,
        DestroyFunc, CopyFunc, Data);
  for i := 0 to Source.FRecGetList.Count - 1 do { Iterate }
    with TRAI2RecMethod(Source.FRecGetList[i]) do
      AddRecGetEx(UnitName, RAI2Record.Identifer, Identifer, Func, ParamCount,
        ParamTypes, ResTyp, Data);
  for i := 0 to Source.FRecSetList.Count - 1 do { Iterate }
    with TRAI2RecMethod(Source.FRecSetList[i]) do
      AddRecSetEx(UnitName, RAI2Record.Identifer, Identifer, Func, ParamCount,
        ParamTypes, Data);
  for i := 0 to Source.FExtFunList.Count - 1 do { Iterate }
    with TRAI2ExtFun(Source.FExtFunList[i]) do
      AddExtFunEx(UnitName, Identifer, DllInstance, DllName, FunName, FunIndex,
        FunDesc.FParamCount, FunDesc.FParamTypes, FunDesc.FResTyp, Data);
  for i := 0 to Source.FEventHandlerList.Count - 1 do { Iterate }
    with TRAI2EventDesc(Source.FEventHandlerList[i]) do
      AddHandlerEx(UnitName, Identifer, EventClass, Code, Data);
  for i := 0 to Source.FEventList.Count - 1 do { Iterate }
    with TRAI2Class(Source.FEventList[i]) do
      AddEventEx(UnitName, ClassType, Identifer, Data);
  for i := 0 to Source.FOnGetList.Count - 1 do { Iterate }
    AddOnGet(TRAI2GetValue(PMethod(Source.FOnGetList[i])^));
  for i := 0 to Source.FOnSetList.Count - 1 do { Iterate }
    AddOnSet(TRAI2SetValue(PMethod(Source.FOnSetList[i])^));
end;

procedure TRAI2Adapter.AddSrcUnit(Identifer: string; Source: string;
  UsesList: string);
begin
  AddSrcUnitEx(Identifer, Source, UsesList, nil);
end;

{ if unit with name 'Identifer' allready exists its source will be replaced }
procedure TRAI2Adapter.AddSrcUnitEx(Identifer: string; Source: string;
  UsesList: string; Data: Pointer);
var
  RAI2Unit: TRAI2SrcUnit;
  S: string;
  i: Integer;
  RAI2Identifer: TRAI2Identifer;
begin
  RAI2Unit := nil;
  for i := 0 to FSrcUnitList.Count - 1 do { Iterate }
  begin
    RAI2Identifer := TRAI2Identifer(FSrcUnitList.Items[i]);
    if Cmp(RAI2Identifer.Identifer, Identifer) then
    begin
      RAI2Unit := TRAI2SrcUnit(FSrcUnitList.Items[i]);
      Break;
    end;
  end; { for }
  if RAI2Unit = nil then
  begin
    RAI2Unit := TRAI2SrcUnit.Create;
    FSrcUnitList.Add(RAI2Unit);
  end;

  if RAI2Unit.Source = '' then
  begin
    RAI2Unit.Identifer := Identifer;
    RAI2Unit.Source := Source;
    RAI2Unit.Data := Data;
    i := 0;
    S := Trim(SubStr(UsesList, i, ','));
    while S <> '' do
    begin
      RAI2Unit.UsesList[i] := S;
      inc(i);
      S := Trim(SubStr(UsesList, i, ','));
    end; { while }
  end;
end;

procedure TRAI2Adapter.AddExtUnit(Identifer: string);
begin
  AddExtUnitEx(Identifer, nil);
end;

procedure TRAI2Adapter.AddExtUnitEx(Identifer: string; Data: Pointer);
var
  RAI2Unit: TRAI2Identifer;
begin
  RAI2Unit := TRAI2Identifer.Create;
  RAI2Unit.Identifer := Identifer;
  RAI2Unit.Data := Data;
  FExtUnitList.Add(RAI2Unit);
end;

procedure TRAI2Adapter.AddClass(UnitName: string; ClassType: TClass;
  Identifer: string);
begin
  AddClassEx(UnitName, ClassType, Identifer, nil);
end;

procedure TRAI2Adapter.AddClassEx(UnitName: string; ClassType: TClass;
  Identifer: string; Data: Pointer);
var
  RAI2Class: TRAI2Class;
begin
  RAI2Class := TRAI2Class.Create;
  RAI2Class.ClassType := ClassType;
  RAI2Class.Identifer := Identifer;
  RAI2Class.Data := Data;
  FClassList.Add(RAI2Class);
  FSorted:=false;  // Ivan_ra
end;

procedure TRAI2Adapter.AddGet(ClassType: TClass; Identifer: string;
  GetFunc: TRAI2AdapterGetValue; ParamCount: Integer; ParamTypes: array of Word;
  ResTyp: Word);
begin
  AddGetEx(ClassType, Identifer, GetFunc, ParamCount, ParamTypes, ResTyp, nil);
end;

procedure TRAI2Adapter.AddGetEx(ClassType: TClass; Identifer: string;
  GetFunc: TRAI2AdapterGetValue; ParamCount: Integer; ParamTypes: array of Word;
  ResTyp: Word; Data: Pointer);
var
  RAI2Method: TRAI2Method;
begin
  RAI2Method := TRAI2Method.Create;
  RAI2Method.ClassType := ClassType;
  RAI2Method.Identifer := Identifer;
  RAI2Method.Func := @GetFunc;
  RAI2Method.ParamCount := ParamCount;
  RAI2Method.ResTyp := ResTyp;
  RAI2Method.Data := Data;
  ConvertParamTypes(ParamTypes, RAI2Method.ParamTypes);
  FGetList.Add(RAI2Method);
  FSorted:=false;  // Ivan_ra
end;

procedure TRAI2Adapter.AddIGet(ClassType: TClass; Identifer: string;
  GetFunc: TRAI2AdapterGetValue; ParamCount: Integer; ParamTypes: array of Word;
  ResTyp: Word);
begin
  AddIGetEx(ClassType, Identifer, GetFunc, ParamCount, ParamTypes, ResTyp, nil);
end;

procedure TRAI2Adapter.AddIGetEx(ClassType: TClass; Identifer: string;
  GetFunc: TRAI2AdapterGetValue; ParamCount: Integer; ParamTypes: array of Word;
  ResTyp: Word; Data: Pointer);
var
  RAI2Method: TRAI2Method;
begin
  RAI2Method := TRAI2Method.Create;
  RAI2Method.ClassType := ClassType;
  RAI2Method.Identifer := Identifer;
  RAI2Method.Func := @GetFunc;
  RAI2Method.ParamCount := ParamCount;
  RAI2Method.ResTyp := ResTyp;
  RAI2Method.Data := Data;
  ConvertParamTypes(ParamTypes, RAI2Method.ParamTypes);
  FIGetList.Add(RAI2Method);
  FSorted:=false;  // Ivan_ra
end;

procedure TRAI2Adapter.AddIDGet(ClassType: TClass;
  GetFunc: TRAI2AdapterGetValue; ParamCount: Integer; ParamTypes: array of Word;
  ResTyp: Word);
begin
  AddIDGetEx(ClassType, GetFunc, ParamCount, ParamTypes, ResTyp, nil);
end;

procedure TRAI2Adapter.AddIDGetEx(ClassType: TClass;
  GetFunc: TRAI2AdapterGetValue; ParamCount: Integer; ParamTypes: array of Word;
  ResTyp: Word; Data: Pointer);
var
  RAI2Method: TRAI2Method;
begin
  RAI2Method := TRAI2Method.Create;
  RAI2Method.ClassType := ClassType;
  RAI2Method.Func := @GetFunc;
  RAI2Method.ParamCount := ParamCount;
  RAI2Method.ResTyp := ResTyp;
  RAI2Method.Data := Data;
  ConvertParamTypes(ParamTypes, RAI2Method.ParamTypes);
  FIDGetList.Add(RAI2Method);
end;

procedure TRAI2Adapter.AddDGet(ClassType: TClass; Identifer: string;
  GetFunc: Pointer; ParamCount: Integer; ParamTypes: array of Word;
  ResTyp: Word; CallConvention: TCallConvention);
begin
  AddDGetEx(ClassType, Identifer, GetFunc, ParamCount, ParamTypes, ResTyp,
    CallConvention, nil);
end;

procedure TRAI2Adapter.AddDGetEx(ClassType: TClass; Identifer: string;
  GetFunc: Pointer; ParamCount: Integer; ParamTypes: array of Word;
  ResTyp: Word; CallConvention: TCallConvention; Data: Pointer);
var
  RAI2Method: TRAI2DMethod;
begin
  RAI2Method := TRAI2DMethod.Create;
  RAI2Method.ClassType := ClassType;
  RAI2Method.Identifer := Identifer;
  RAI2Method.Func := GetFunc;
  RAI2Method.ParamCount := ParamCount;
  RAI2Method.ResTyp := ResTyp;
  RAI2Method.Data := Data;
  ConvertParamTypes(ParamTypes, RAI2Method.ParamTypes);
  RAI2Method.CallConvention := CallConvention;
  FDGetList.Add(RAI2Method);
end;

procedure TRAI2Adapter.AddSet(ClassType: TClass; Identifer: string;
  SetFunc: TRAI2AdapterSetValue; ParamCount: Integer; ParamTypes: array of Word);
begin
  AddSetEx(ClassType, Identifer, SetFunc, ParamCount, ParamTypes, nil);
end;

procedure TRAI2Adapter.AddSetEx(ClassType: TClass; Identifer: string;
  SetFunc: TRAI2AdapterSetValue; ParamCount: Integer; ParamTypes: array of Word;
  Data: Pointer);
var
  RAI2Method: TRAI2Method;
begin
  RAI2Method := TRAI2Method.Create;
  RAI2Method.ClassType := ClassType;
  RAI2Method.Identifer := Identifer;
  RAI2Method.Func := @SetFunc;
  RAI2Method.ParamCount := ParamCount;
  RAI2Method.Data := Data;
  ConvertParamTypes(ParamTypes, RAI2Method.ParamTypes);
  FSetList.Add(RAI2Method);
  FSorted:=false;  // Ivan_ra
end;

procedure TRAI2Adapter.AddISet(ClassType: TClass; Identifer: string;
  SetFunc: TRAI2AdapterSetValue; ParamCount: Integer; ParamTypes: array of Word);
begin
  AddISetEx(ClassType, Identifer, SetFunc, ParamCount, ParamTypes, nil);
end;

procedure TRAI2Adapter.AddISetEx(ClassType: TClass; Identifer: string;
  SetFunc: TRAI2AdapterSetValue; ParamCount: Integer; ParamTypes: array of Word;
  Data: Pointer);
var
  RAI2Method: TRAI2Method;
begin
  RAI2Method := TRAI2Method.Create;
  RAI2Method.ClassType := ClassType;
  RAI2Method.Identifer := Identifer;
  RAI2Method.Func := @SetFunc;
  RAI2Method.ParamCount := ParamCount;
  RAI2Method.Data := Data;
  ConvertParamTypes(ParamTypes, RAI2Method.ParamTypes);
  FISetList.Add(RAI2Method);
  FSorted:=false;  // Ivan_ra
end;

procedure TRAI2Adapter.AddIDSet(ClassType: TClass;
  SetFunc: TRAI2AdapterSetValue; ParamCount: Integer; ParamTypes: array of Word);
begin
  AddIDSetEx(ClassType, SetFunc, ParamCount, ParamTypes, nil);
end;

procedure TRAI2Adapter.AddIDSetEx(ClassType: TClass;
  SetFunc: TRAI2AdapterSetValue; ParamCount: Integer; ParamTypes: array of Word;
  Data: Pointer);
var
  RAI2Method: TRAI2Method;
begin
  RAI2Method := TRAI2Method.Create;
  RAI2Method.ClassType := ClassType;
  RAI2Method.Func := @SetFunc;
  RAI2Method.ParamCount := ParamCount;
  RAI2Method.Data := Data;
  ConvertParamTypes(ParamTypes, RAI2Method.ParamTypes);
  FIDSetList.Add(RAI2Method);
end;

procedure TRAI2Adapter.AddFun(UnitName: string; Identifer: string;
  GetFunc: TRAI2AdapterGetValue; ParamCount: Integer; ParamTypes: array of Word;
  ResTyp: Word);
begin
  AddFunEx(UnitName, Identifer, GetFunc, ParamCount, ParamTypes, ResTyp, nil);
end;

procedure TRAI2Adapter.AddFunEx(UnitName: string; Identifer: string;
  GetFunc: TRAI2AdapterGetValue; ParamCount: Integer; ParamTypes: array of Word;
  ResTyp: Word; Data: Pointer);
var
  RAI2Method: TRAI2Method;
begin
  RAI2Method := TRAI2Method.Create;
  RAI2Method.Identifer := Identifer;
  RAI2Method.Func := @GetFunc;
  RAI2Method.ParamCount := ParamCount;
  RAI2Method.ResTyp := ResTyp;
  RAI2Method.Data := Data;
  RAI2Method.UnitName:=UnitName;
  ConvertParamTypes(ParamTypes, RAI2Method.ParamTypes);
  FFunList.Add(RAI2Method);
  FSorted:=false;  // Ivan_ra
end;

procedure TRAI2Adapter.AddRec(UnitName: string; Identifer: string;
  RecordSize: Integer; Fields: array of TRAI2RecField;
  CreateFunc: TRAI2AdapterNewRecord; DestroyFunc: TRAI2AdapterDisposeRecord;
  CopyFunc: TRAI2AdapterCopyRecord);
begin
  AddRecEx(UnitName, Identifer, RecordSize, Fields, CreateFunc, DestroyFunc,
    CopyFunc, nil);
end;

procedure TRAI2Adapter.AddRecEx(UnitName: string; Identifer: string;
  RecordSize: Integer; Fields: array of TRAI2RecField;
  CreateFunc: TRAI2AdapterNewRecord; DestroyFunc: TRAI2AdapterDisposeRecord;
  CopyFunc: TRAI2AdapterCopyRecord; Data: Pointer);
var
  RAI2Record: TRAI2Record;
  i: Integer;
begin
  RAI2Record := TRAI2Record.Create;
  RAI2Record.Identifer := Identifer;
  RAI2Record.RecordSize := RecordSize;
  RAI2Record.CreateFunc := CreateFunc;
  RAI2Record.DestroyFunc := DestroyFunc;
  RAI2Record.CopyFunc := CopyFunc;
  RAI2Record.Data := Data;
  RAI2Record.UnitName:=UnitName;
  for i := Low(Fields) to High(Fields) do { Iterate }
    RAI2Record.Fields[i] := Fields[i];
  RAI2Record.FieldCount := High(Fields) - Low(Fields) + 1;
  FRecList.Add(RAI2Record);
end;

procedure TRAI2Adapter.AddRecGet(UnitName: string; RecordType: string;
  Identifer: string; GetFunc: TRAI2AdapterGetValue;
  ParamCount: Integer; ParamTypes: array of Word; ResTyp: Word);
begin
  AddRecGetEx(UnitName, RecordType, Identifer, GetFunc, ParamCount,
    ParamTypes, ResTyp, nil);
end;

procedure TRAI2Adapter.AddRecGetEx(UnitName: string; RecordType: string;
  Identifer: string; GetFunc: TRAI2AdapterGetValue;
  ParamCount: Integer; ParamTypes: array of Word; ResTyp: Word; Data: Pointer);
var
  RecMethod: TRAI2RecMethod;
begin
  RecMethod := TRAI2RecMethod.Create;
  RecMethod.RAI2Record := GetRec(RecordType) as TRAI2Record;
  RecMethod.Identifer := Identifer;
  RecMethod.Func := @GetFunc;
  RecMethod.ParamCount := ParamCount;
  RecMethod.ResTyp := ResTyp;
  RecMethod.Data := Data;
  RecMethod.UnitName:=UnitName;
  ConvertParamTypes(ParamTypes, RecMethod.ParamTypes);
  FRecGetList.Add(RecMethod);
end;

procedure TRAI2Adapter.AddRecSet(UnitName: string; RecordType: string;
  Identifer: string; SetFunc: TRAI2AdapterSetValue;
  ParamCount: Integer; ParamTypes: array of Word);
begin
  AddRecSetEx(UnitName, RecordType, Identifer, SetFunc, ParamCount, ParamTypes,
    nil);
end;

procedure TRAI2Adapter.AddRecSetEx(UnitName: string; RecordType: string;
  Identifer: string; SetFunc: TRAI2AdapterSetValue;
  ParamCount: Integer; ParamTypes: array of Word; Data: Pointer);
var
  RecMethod: TRAI2RecMethod;
begin
  RecMethod := TRAI2RecMethod.Create;
  RecMethod.RAI2Record := GetRec(RecordType) as TRAI2Record;
  RecMethod.Identifer := Identifer;
  RecMethod.Func := @SetFunc;
  RecMethod.ParamCount := ParamCount;
  RecMethod.Data := Data;
  RecMethod.UnitName:=UnitName;
  ConvertParamTypes(ParamTypes, RecMethod.ParamTypes);
  FRecSetList.Add(RecMethod);
end;

procedure TRAI2Adapter.AddConst(UnitName: string; Identifer: string;
  Value: Variant);
begin
  AddConstEx(UnitName, Identifer, Value, nil);
end;

procedure TRAI2Adapter.AddConstEx(UnitName: string; Identifer: string;
  Value: Variant; Data: Pointer; TypeAdd: TTypeAdd=ttaLast);
var
  RAI2Const: TRAI2Const;
begin
  RAI2Const := TRAI2Const.Create;
  RAI2Const.Identifer := Identifer;
  RAI2Const.Value := Value;
  RAI2Const.Data := Data;
  RAI2Const.UnitName:=UnitName;
  case TypeAdd of
    ttaLast: FConstList.Add(RAI2Const);
    ttaFirst: FConstList.Insert(0,RAI2Const);
  end;
  FSorted:=false;  // Ivan_ra
end;

procedure TRAI2Adapter.AddExtFun(UnitName: string; Identifer: string;
  DllInstance: HINST; DllName: string; FunName: string; FunIndex: integer;
  ParamCount: Integer; ParamTypes: array of Word; ResTyp: Word);
begin
  AddExtFunEx(UnitName, Identifer, DllInstance, DllName, FunName, FunIndex,
    ParamCount, ParamTypes, ResTyp, nil);
end;

procedure TRAI2Adapter.AddExtFunEx(UnitName: string; Identifer: string;
  DllInstance: HINST; DllName: string; FunName: string; FunIndex: integer;
  ParamCount: Integer; ParamTypes: array of Word; ResTyp: Word; Data: Pointer);
var
  RAI2ExtFun: TRAI2ExtFun;
begin
  RAI2ExtFun := TRAI2ExtFun.Create;
  RAI2ExtFun.FunDesc.FUnitName := UnitName;
  RAI2ExtFun.Identifer := Identifer;
  RAI2ExtFun.DllInstance := DllInstance;
  RAI2ExtFun.DllName := DllName;
  RAI2ExtFun.FunName := FunName;
  RAI2ExtFun.FunIndex := FunIndex;
  RAI2ExtFun.FunDesc.FParamCount := ParamCount;
  RAI2ExtFun.FunDesc.FResTyp := ResTyp;
  RAI2ExtFun.Data := Data;
  RAI2ExtFun.UnitName:=UnitName;
  ConvertParamTypes(ParamTypes, RAI2ExtFun.FunDesc.FParamTypes);
  FExtFunList.Add(RAI2ExtFun);
end;

procedure TRAI2Adapter.AddSrcFun(UnitName: string; Identifer: string;
  PosBeg, PosEnd: integer; ParamCount: Integer; ParamTypes: array of Word;
  ParamNames: array of string; ResTyp: Word; Data: Pointer);
begin
  AddSrcFunEx(UnitName, Identifer, PosBeg, PosEnd, ParamCount, ParamTypes,
    ParamNames, ResTyp, nil);
end;

procedure TRAI2Adapter.AddSrcFunEx(UnitName: string; Identifer: string;
  PosBeg, PosEnd: integer; ParamCount: Integer; ParamTypes: array of Word;
  ParamNames: array of string; ResTyp: Word; Data: Pointer);
var
  RAI2SrcFun: TRAI2SrcFun;
begin
  RAI2SrcFun := TRAI2SrcFun.Create;
  RAI2SrcFun.FunDesc.FUnitName := UnitName;
  RAI2SrcFun.FunDesc.FIdentifer := Identifer;
  RAI2SrcFun.FunDesc.FPosBeg := PosBeg;
  RAI2SrcFun.FunDesc.FPosEnd := PosEnd;
  RAI2SrcFun.FunDesc.FParamCount := ParamCount;
  RAI2SrcFun.FunDesc.FResTyp := ResTyp;
  RAI2SrcFun.Identifer := Identifer;
  RAI2SrcFun.Data := Data;
  RAI2SrcFun.UnitName:=UnitName;
  ConvertParamTypes(ParamTypes, RAI2SrcFun.FunDesc.FParamTypes);
  ConvertParamNames(ParamNames, RAI2SrcFun.FunDesc.FParamNames);
  RAI2SrcFun.FunDesc.FResTyp := ResTyp;
  FSrcFunList.Add(RAI2SrcFun);
end;

procedure TRAI2Adapter.AddHandler(UnitName: string; Identifer: string;
  EventClass: TRAI2EventClass; Code: Pointer);
begin
  AddHandlerEx(UnitName, Identifer, EventClass, Code, nil);
end;

procedure TRAI2Adapter.AddHandlerEx(UnitName: string; Identifer: string;
  EventClass: TRAI2EventClass; Code: Pointer; Data: Pointer);
var
  RAI2EventDesc: TRAI2EventDesc;
begin
  RAI2EventDesc := TRAI2EventDesc.Create;
  RAI2EventDesc.UnitName := UnitName;
  RAI2EventDesc.Identifer := Identifer;
  RAI2EventDesc.EventClass := EventClass;
  RAI2EventDesc.Code := Code;
  RAI2EventDesc.Data := Data;
  RAI2EventDesc.UnitName:=UnitName;
  FEventHandlerList.Add(RAI2EventDesc);
end;

procedure TRAI2Adapter.AddEvent(UnitName: string; ClassType: TClass;
  Identifer: string);
begin
  AddEventEx(UnitName, ClassType, Identifer, nil);
end;

procedure TRAI2Adapter.AddEventEx(UnitName: string; ClassType: TClass;
  Identifer: string; Data: Pointer);
var
  RAI2Event: TRAI2Class;
begin
  RAI2Event := TRAI2Class.Create;
  RAI2Event.UnitName := UnitName;
  RAI2Event.Identifer := Identifer;
  RAI2Event.ClassType := ClassType;
  RAI2Event.Data := Data;
  RAI2Event.UnitName:=UnitName;
  FEventList.Add(RAI2Event);
end;

procedure TRAI2Adapter.AddSrcVar(UnitName: string; Identifer, Typ: string;
  VTyp: Word; const Value: Variant);
begin
  FSrcVarList.AddVar(UnitName, Identifer, Typ, VTyp, Value);
end;

procedure TRAI2Adapter.AddSrcClass(RAI2SrcClass: TRAI2Identifer);
begin
  FSrcClassList.Add(RAI2SrcClass);
end;

function TRAI2Adapter.GetSrcClass(Identifer: string): TRAI2Identifer;
begin
  Result := FSrcClassList.IndexOf('', Identifer);
end;

procedure TRAI2Adapter.AddOnGet(Method: TRAI2GetValue);
var
  PM: PMethod;
begin
  New(PM);
  PM^ := TMethod(Method);
  FOnGetList.Add(PM);
end;

procedure TRAI2Adapter.AddOnSet(Method: TRAI2SetValue);
var
  PM: PMethod;
begin
  New(PM);
  PM^ := TMethod(Method);
  FOnSetList.Add(PM);
end;

function TRAI2Adapter.GetRec(RecordType: string): TObject;
var
  i: Integer;
begin
  for i := 0 to FRecList.Count - 1 do { Iterate }
  begin
    Result := FRecList[i];
    if Cmp(TRAI2Record(Result).Identifer, RecordType) then
      Exit;
  end; { for }
  //RAI2ErrorN(ieRecordNotDefined, -1, RecordType);
  Result := nil;
end; { GetRec }

procedure TRAI2Adapter.CheckArgs(var Args: TArgs; ParamCount: Integer;
  var ParamTypes: TTypeArray);
var
  i: Integer;
begin
  if ParamCount = prArgsNoCheck then Exit;
  if Args.Count > ParamCount then
    RAI2Error(ieTooManyParams, -1);

// by TSV
 { if Args.Count < ParamCount then
    RAI2Error(ieNotEnoughParams, -1); }

  Args.HasVars := False;
  Args.Types := ParamTypes;
  for i := 0 to Args.Count - 1 do { Iterate }
    if (Args.VarNames[i] <> '') and
      ((ParamTypes[i] and varByRef) <> 0) then
    begin
      Args.HasVars := True;
      Break;
    end;
end; { CheckArgs }

procedure TRAI2Adapter.CheckAction(Expression: TRAI2Expression; Args: TArgs;
  Data: Pointer);
begin
  // abstract
end; { CheckAction }

function TRAI2Adapter.FindFunDesc(const UnitName: string;
  const Identifer: string): TRAI2FunDesc;
var
  i: Integer;
begin
  for i := FSrcFunList.Count - 1 downto 0 do { Iterate }
  begin
    Result := TRAI2SrcFun(FSrcFunList.Items[i]).FunDesc;
    if Cmp(Result.Identifer, Identifer) and
       (Cmp(Result.UnitName, UnitName) or (UnitName = '')) then
      Exit;
  end; { for }
  if UnitName <> '' then
    Result := FindFunDesc('', Identifer)
  else
    Result := nil;
end; { FindFunDesc }

function TRAI2Adapter.GetValue(Expression: TRAI2Expression; Identifer: string;
  var Value: Variant; Args: TArgs): Boolean;

  function GetMethod: boolean;
  var
    i: Integer;
    RAI2Method: TRAI2Method;
  begin
    Result := GetValueRTTI(Identifer, Value, Args);
    if Result then Exit;
    if FGetList.Find(Identifer, i) then
      for i := i to FGetList.Count - 1 do { Iterate }
      begin
        RAI2Method := TRAI2Method(FGetList[i]);
        if Assigned(RAI2Method.Func) and
          (((Args.ObjTyp = varObject) and
          (Args.Obj is RAI2Method.ClassType)) or
          ((Args.ObjTyp = varClass) and
          (TClass(Args.Obj) = RAI2Method.ClassType))) {?!} then
        begin
          Args.Identifer := Identifer;
          CheckAction(Expression, Args, RAI2Method.Data);
          CheckArgs(Args, RAI2Method.ParamCount, RAI2Method.ParamTypes);
          TRAI2AdapterGetValue(RAI2Method.Func)(Value, Args);
          Result := True;
          Exit;
        end;
        if not Cmp(RAI2Method.Identifer, Identifer) then Break;
      end;
    if Cmp(Identifer, 'Free') then
    begin
      Result := True;
      Args.Obj.Free;
      Args.Obj := nil;
      Value := Null;
      Exit;
    end;
  end; {  }

  function IGetMethod: boolean;
  var
    i: Integer;
    RAI2Method: TRAI2Method;
  begin
    if FIGetList.Find(Identifer, i) then
      for i := i to FIGetList.Count - 1 do { Iterate }
      begin
        RAI2Method := TRAI2Method(FIGetList[i]);
        if Assigned(RAI2Method.Func) and
          (((Args.ObjTyp = varObject) and
          (Args.Obj is RAI2Method.ClassType)) or
          ((Args.ObjTyp = varClass) and
          (TClass(Args.Obj) = RAI2Method.ClassType))) {?!} then
        begin
          Args.Identifer := Identifer;
          CheckAction(Expression, Args, RAI2Method.Data);
          CheckArgs(Args, RAI2Method.ParamCount, RAI2Method.ParamTypes);
          TRAI2AdapterGetValue(RAI2Method.Func)(Value, Args);
          Result := True;
          Args.ReturnIndexed := True;
          Exit;
        end;
        if not Cmp(RAI2Method.Identifer, Identifer) then Break;
      end;
    Result := False;
  end; {  }

  { function DGetMethod is under construction }
  function DGetMethod: boolean;
  var
    RAI2Method: TRAI2DMethod;
    i, j: Integer;
    Aint: integer;
    Aword : word;
    iRes: integer;
    Func: Pointer;
    REAX, REDX, RECX: Integer;
  begin
    Result := False;
    iRes := 0; { satisfy compiler }
    for i := 0 to FDGetList.Count - 1 do    { Iterate }
    begin
      RAI2Method := TRAI2DMethod(FDGetList[i]);
      Func := RAI2Method.Func;
      if Assigned(RAI2Method.Func) and
         (((Args.ObjTyp = varObject) and
          (Args.Obj is RAI2Method.ClassType)) { or
          ((Args.ObjTyp = varClass) and
          (TClass(Args.Obj) = RAI2Method.ClassType))})  and
         Cmp(RAI2Method.Identifer, Identifer) then
      begin
        Args.Identifer := Identifer;
        CheckAction(Expression, Args, RAI2Method.Data);
        CheckArgs(Args, RAI2Method.ParamCount, RAI2Method.ParamTypes);
        if ccFastCall in RAI2Method.CallConvention then
        begin
         { !!! Delphi fast-call !!! }

         { push parameters to stack }
          for j := 2 to RAI2Method.ParamCount - 1 do
            case RAI2Method.ParamTypes[j] of
              varInteger, varObject, varPointer, varBoolean{?}:
                begin Aint := Args.Values[j]; asm push Aint end; end;
              varSmallInt:
                begin Aword := Word(Args.Values[j]); asm push Aword end; end;
              else
                RAI2ErrorN(ieDirectInvalidArgument, -1, Identifer);
            end;
          REAX := Integer(Args.Obj);
          if RAI2Method.ParamCount > 0 then
            case RAI2Method.ParamTypes[0] of
              varInteger, varObject, varPointer, varBoolean, varSmallInt,
              varString:
                REDX := TVarData(Args.Values[0]).vInteger;
              else
                RAI2ErrorN(ieDirectInvalidArgument, -1, Identifer);
            end;
          if RAI2Method.ParamCount > 1 then
            case RAI2Method.ParamTypes[1] of
              varInteger, varObject, varPointer, varBoolean, varSmallInt,
              varString:
                RECX := TVarData(Args.Values[1]).vInteger
              else
                RAI2ErrorN(ieDirectInvalidArgument, -1, Identifer);
            end;
          case RAI2Method.ResTyp of
            varSmallInt, varInteger, varBoolean, varEmpty, varObject,
            varPointer:
              asm
                mov      EAX, REAX
                mov      EDX, REDX
                mov      ECX, RECX
                call     Func
                mov      iRes, EAX
              end;
            else
              RAI2ErrorN(ieDirectInvalidResult, -1, Identifer);
          end;
         { clear result }
          case RAI2Method.ResTyp of
            varInteger, varObject:
              Value := iRes;
            varSmallInt:
              Value := iRes and $0000FFFF;
            varBoolean:
              begin
                Value := iRes and $000000FF;
                TVarData(Value).VType := varBoolean;
              end;
            varEmpty:
              Value := Null;
          end;
        end
        else
          RAI2ErrorN(ieDirectInvalidConvention, -1, Identifer);
        Result := True;
        Exit;
      end;
    end;
  end;    {  }

  function GetRecord: Boolean;
  var
    i: Integer;
    RAI2Record: TRAI2Record;
    Rec: PChar;
    RAI2RecMethod: TRAI2RecMethod;
  begin
    Result := False;
    RAI2Record := (Args.Obj as TRAI2RecHolder).RAI2Record;
    for i := 0 to RAI2Record.FieldCount - 1 do { Iterate }
      if Cmp(RAI2Record.Fields[i].Identifer, Identifer) then
      begin
        Rec := P2R(Args.Obj);
        with RAI2Record.Fields[i] do
          case Typ of { }
            varInteger:
              Value := PInteger(Rec + Offset)^;
            varSmallInt:
              Value := SmallInt(PWord(Rec + Offset)^);
            varBoolean:
              Value := PBool(Rec + Offset)^;
            varString:
              Value := PString(Rec + Offset)^;
          end; { case }
        Result := True;
        Exit;
      end; { for }
    for i := 0 to FRecGetList.Count - 1 do { Iterate }
    begin
      RAI2RecMethod := TRAI2RecMethod(FRecGetList[i]);
      if (RAI2RecMethod.RAI2Record = RAI2Record) and
        Cmp(RAI2RecMethod.Identifer, Identifer) then
      begin
        Args.Identifer := Identifer;
        CheckArgs(Args, RAI2RecMethod.ParamCount, RAI2RecMethod.ParamTypes);
        TRAI2AdapterGetValue(RAI2RecMethod.Func)(Value, Args);
        Result := True;
        Exit;
      end;
    end
  end;

  function GetConst: boolean;
  var
    i: Integer;
    RAI2Const: TRAI2Const;
  begin
    if Cmp(Identifer, 'nil') then
    begin
      Value := P2V(nil);
      Result := True;
      Exit;
    end;
    if Cmp(Identifer, 'Null') then
    begin
      Value := Null;
      Result := True;
      Exit;
    end;
    Result := FConstList.Find(Identifer, i);
    if Result then
    begin
      RAI2Const := TRAI2Const(FConstList[i]);
      CheckAction(Expression, Args, RAI2Const.Data);
      Value := RAI2Const.Value;
    end;
  end; {  }

  function GetClass: boolean;
  var
    i: Integer;
    RAI2Class: TRAI2Class;
  begin
    Result := FClassList.Find(Identifer, i);
    if Result then
    begin
      RAI2Class := TRAI2Class(FClassList[i]);
      if Args.Count = 0 then
        Value := C2V(RAI2Class.ClassType)
      else
        if Args.Count = 1 then
       { typecasting }
        begin
          CheckAction(Expression, Args, RAI2Class.Data);
          Value := Args.Values[0];
          if TVarData(Value).VType <> varClass then
            TVarData(Value).VType := varObject;
        end
        else
          RAI2Error(ieTooManyParams, -1);
    end;
  end; {  }

  function GetFun: boolean;
  var
    i: Integer;
    RAI2Method: TRAI2Method;
  begin
    Result := FFunList.Find(Identifer, i);
    if Result then
    begin
      RAI2Method := TRAI2Method(FFunList[i]);
      if Cmp(RAI2Method.Identifer, Identifer) then
      begin
        Args.Identifer := Identifer;
        CheckAction(Expression, Args, RAI2Method.Data);
        CheckArgs(Args, RAI2Method.ParamCount, RAI2Method.ParamTypes);
        TRAI2AdapterGetValue(RAI2Method.Func)(Value, Args);
      end;
    end;
  end; {  }

  function GetExtFun: boolean;
  var
    i: Integer;
    RAI2ExtFun: TRAI2ExtFun;
  begin
    for i := 0 to FExtFunList.Count - 1 do { Iterate }
    begin
      RAI2ExtFun := TRAI2ExtFun(FExtFunList[i]);
      if Cmp(RAI2ExtFun.Identifer, Identifer) then
      begin
        Args.Identifer := Identifer;
        CheckAction(Expression, Args, RAI2ExtFun.Data);
        CheckArgs(Args, RAI2ExtFun.FunDesc.ParamCount,
          RAI2ExtFun.FunDesc.FParamTypes);
        Value := RAI2ExtFun.CallDll(Args);
        Result := True;
        Exit;
      end;
    end;
    Result := False;
  end; {  }

  function GetSrcVar: boolean;
  begin
    Result := FSrcVarList.GetValue(Identifer, Value, Args);
  end; {  }

  function GetSrcUnit: boolean;
  var
    i: Integer;
    RAI2SrcUnit: TRAI2SrcUnit;
    FParams: TTypeArray;
  begin
    for i := 0 to FSrcUnitList.Count - 1 do { Iterate }
    begin
      RAI2SrcUnit := TRAI2SrcUnit(FSrcUnitList[i]);
      if Cmp(RAI2SrcUnit.Identifer, Identifer) then
      begin
        CheckArgs(Args, 0, FParams);
        Value := O2V(RAI2SrcUnit);
        Result := True;
        Exit;
      end;
    end;
    Result := False;
  end; {  }

 {$IFDEF RAI2_OLEAUTO}
  function GetOleAutoFun: boolean;
  var
    FParams: TTypeArray;
  begin
    Result := False;
    if Cmp(Identifer, 'CreateOleObject') or
      Cmp(Identifer, 'GetActiveOleObject') or
      Cmp(Identifer, 'GetOleObject') then
    begin
      FParams[0] := varString;
      CheckArgs(Args, 1, FParams);
      if Cmp(Identifer, 'CreateOleObject') then
        Value := CreateOleObject(Args.Values[0])
      else if Cmp(Identifer, 'CreateOleObject') then
        Value := GetActiveOleObject(Args.Values[0])
      else { GetOleObject }
      begin
        try
          Value := GetActiveOleObject(Args.Values[0])
        except
          on E: EOleError do
            Value := CreateOleObject(Args.Values[0])
        end;
      end;
      Result := True;
      Exit;
    end;
  end; {  }
{$ENDIF RAI2_OLEAUTO}

  function TypeCast: Boolean;
  var
    VT: Word;
  begin
    VT := TypeName2VarTyp(Identifer);
    Result := VT <> varEmpty;
    if Result then
    begin
      Value := Args.Values[0];
      TVarData(Value).VType := VT;
    end;
  end;

var
  i: Integer;
begin
  Result := True;
  if not FSorted then Sort;

  if Args.Indexed then
  begin
    if (Args.Obj <> nil) and (Args.ObjTyp in [varObject, varClass]) then begin
      if IGetMethod then Exit;
    end else if Args.ObjTyp = varDispatch then begin
      Result := DispatchCall(Identifer, Value, Args, true, false);
      if Result then Exit;
    end;
  end
  else
  begin
    if Args.Obj <> nil then
    begin
     { methods }
      if Args.ObjTyp in [varObject, varClass] then
        if GetMethod or DGetMethod then Exit else
      else if Args.ObjTyp = varRecord then
        if (Args.Obj is TRAI2RecHolder) and GetRecord then Exit else
      else if Args.ObjTyp = varDispatch then
     { Ole automation call }
      begin
      {$IFDEF RAI2_OLEAUTO}
        Result := DispatchCall(Identifer, Value, Args, True, false);
        if Result then Exit;
      {$ELSE}
        NotImplemented('Ole automation call');
      {$ENDIF RAI2_OLEAUTO}
      end;
    end
    else {if Args.Obj = nil then }
    begin
     { classes }
      if GetClass then Exit;
     { constants }
      if GetConst then Exit;
     { classless functions and procedures }
      if GetFun then Exit;
     { external functions }
      if GetExtFun then Exit;
     {$IFDEF RAI2_OLEAUTO}
//      if GetOleAutoFun then Exit;
     {$ENDIF RAI2_OLEAUTO}
      if TypeCast then Exit;
    end;
  end;

 { source variables and constants }
  if GetSrcVar then Exit;

  if GetSrcUnit then Exit;

  for i := 0 to FOnGetList.Count - 1 do { Iterate }
  begin
    TRAI2GetValue(FOnGetList[i]^)(Self, Identifer, Value, Args, Result);
    if Result then Exit;
  end;
  Result := False;
end;

function TRAI2Adapter.SetValue(Expression: TRAI2Expression; Identifer: string;
  const Value: Variant; Args: TArgs): Boolean;

  function SetMethod: boolean;
  var
    i: Integer;
    RAI2Method: TRAI2Method;
  begin
    Result := SetValueRTTI(Identifer, Value, Args);
    if Result then Exit;
    for i := 0 to FSetList.Count - 1 do { Iterate }
    begin
      RAI2Method := TRAI2Method(FSetList[i]);
      if Assigned(RAI2Method.Func) and
        (Args.Obj is RAI2Method.ClassType) and
        Cmp(RAI2Method.Identifer, Identifer) then
      begin
        Args.Identifer := Identifer;
        CheckAction(Expression, Args, RAI2Method.Data);
        CheckArgs(Args, RAI2Method.ParamCount, RAI2Method.ParamTypes);
        TRAI2AdapterSetValue(RAI2Method.Func)(Value, Args);
        Result := True;
        Exit;
      end;
    end;
  end; {  }

  function ISetMethod: boolean;
  var
    i: Integer;
    RAI2Method: TRAI2Method;
  begin
    Result := False;
    if FISetList.Find(Identifer, i) then
      for i := i to FISetList.Count - 1 do { Iterate }
      begin
        RAI2Method := TRAI2Method(FISetList[i]);
        if Assigned(RAI2Method.Func) and
          (Args.Obj is RAI2Method.ClassType) and
          Cmp(RAI2Method.Identifer, Identifer) then
        begin
          Args.Identifer := Identifer;
          CheckAction(Expression, Args, RAI2Method.Data);
          CheckArgs(Args, RAI2Method.ParamCount, RAI2Method.ParamTypes);
          TRAI2AdapterSetValue(RAI2Method.Func)(Value, Args);
          Result := True;
          Args.ReturnIndexed := True;
          Exit;
        end;
        if not Cmp(RAI2Method.Identifer, Identifer) then Break;
      end;
  end; {  }

  function SetRecord: boolean;
  var
    i: Integer;
    RAI2Record: TRAI2Record;
    RAI2RecMethod: TRAI2RecMethod;
    Rec: PChar;
  begin
    Result := False;
    RAI2Record := (Args.Obj as TRAI2RecHolder).RAI2Record;
    for i := 0 to RAI2Record.FieldCount - 1 do { Iterate }
      if Cmp(RAI2Record.Fields[i].Identifer, Identifer) then
      begin
        Rec := P2R(Args.Obj);
        with RAI2Record.Fields[i] do
          case Typ of { }
            varInteger:
              PInteger(Rec + Offset)^ := Value;
            varSmallInt:
              PWord(Rec + Offset)^ := Word(Value);
            varBoolean:
              PBool(Rec + Offset)^ := Value;
          end; { case }
        Result := True;
        Exit;
      end; { for }
    for i := 0 to FRecSetList.Count - 1 do { Iterate }
    begin
      RAI2RecMethod := TRAI2RecMethod(FRecSetList[i]);
      if (RAI2RecMethod.RAI2Record = RAI2Record) and
        Cmp(RAI2RecMethod.Identifer, Identifer) then
      begin
        Args.Identifer := Identifer;
        CheckArgs(Args, RAI2RecMethod.ParamCount, RAI2RecMethod.ParamTypes);
        TRAI2AdapterSetValue(RAI2RecMethod.Func)(Value, Args);
        Result := True;
        Exit;
      end;
    end
  end; {  }

  function SetSrcVar: boolean;
  begin
    Result := FSrcVarList.SetValue(Identifer, Value, Args);
  end; {  }

var
  i: Integer;
{$IFDEF RAI2_OLEAUTO}
  V: Variant;
{$ENDIF RAI2_OLEAUTO}
begin
  Result := True;
  if not FSorted then Sort;

  if Args.Indexed then
  begin
    if (Args.Obj <> nil) and (Args.ObjTyp in [varObject, varClass]) then begin
      if ISetMethod then Exit;
    end else if Args.ObjTyp = varDispatch then begin
      V := Value;
      Result := DispatchCall(Identifer, V, Args, False, false);
      if Result then Exit;
    end;
  end
  else
  begin
    if Args.Obj <> nil then
    begin
     { methods }
      if Args.ObjTyp in [varObject, varClass] then
        if SetMethod then Exit else
      else if Args.ObjTyp = varRecord then
        if (Args.Obj is TRAI2RecHolder) and SetRecord then Exit else
      else if Args.ObjTyp = varDispatch then
     { Ole automation call }
      begin
       {$IFDEF RAI2_OLEAUTO}
        V := Value;
        Result := DispatchCall(Identifer, V, Args, False, false);
        if Result then Exit;
       {$ELSE}
        NotImplemented('Ole automation call');
       {$ENDIF RAI2_OLEAUTO}
      end;
    end;
  end;

  { source variables and constants }
  if SetSrcVar then Exit;

  for i := 0 to FOnSetList.Count - 1 do { Iterate }
  begin
    TRAI2SetValue(FOnSetList[i]^)(Self, Identifer, Value, Args, Result);
    if Result then Exit;
  end;
  Result := False;
end;

function TRAI2Adapter.GetElement(Expression: TRAI2Expression;
  const Variable: Variant; var Value: Variant; var Args: TArgs): Boolean;

  function GetID: boolean;
  var
    i: Integer;
    RAI2Method: TRAI2Method;
    Obj: TObject;
  begin
    Obj := V2O(Variable);
    for i := 0 to FIDGetList.Count - 1 do    { Iterate }
    begin
      RAI2Method := TRAI2Method(FIDGetList[i]);
      if Obj is RAI2Method.ClassType then
      begin
        Args.Obj := Obj;
        CheckAction(Expression, Args, RAI2Method.Data);
        CheckArgs(Args, RAI2Method.ParamCount, RAI2Method.ParamTypes);
        TRAI2AdapterGetValue(RAI2Method.Func)(Value, Args);
        Result := True;
        Exit;
      end;
    end;
    Result := False;
  end;

begin
  Result := True;
  { defaul indexed properties }
  if TVarData(Variable).VType = varObject then
  begin
    if GetID then Exit;
    Result := False;
  end
  else
    Result := False;
end;

function TRAI2Adapter.SetElement(Expression: TRAI2Expression;
  var Variable: Variant; const Value: Variant; var Args: TArgs): Boolean;

  function SetID: boolean;
  var
    i: Integer;
    RAI2Method: TRAI2Method;
    Obj: TObject;
  begin
    Obj := V2O(Variable);
    for i := 0 to FIDSetList.Count - 1 do    { Iterate }
    begin
      RAI2Method := TRAI2Method(FIDSetList[i]);
      if Obj is RAI2Method.ClassType then
      begin
        Args.Obj := Obj;
        CheckAction(Expression, Args, RAI2Method.Data);
        CheckArgs(Args, RAI2Method.ParamCount, RAI2Method.ParamTypes);
        TRAI2AdapterSetValue(RAI2Method.Func)(Value, Args);
        Result := True;
        Exit;
      end;
    end;
    Result := False;
  end;

begin
  Result := True;
  { defaul indexed properties }
  if TVarData(Variable).VType = varObject then
  begin
    if SetID then Exit;
    Result := False;
  end
  else
    Result := False;
end;

function TRAI2Adapter.SetRecord(var Value: Variant): Boolean;
var
  RecHolder: TRAI2RecHolder;
begin
  if TVarData(Value).VType = varRecord then
  begin
    RecHolder := TRAI2RecHolder(TVarData(Value).vPointer);
    RecHolder.RAI2Record := TRAI2Record(GetRec(RecHolder.RecordType));
    Result := Assigned(RecHolder.RAI2Record);
  end
  else
    Result := False;
end;

function TRAI2Adapter.NewRecord(const RecordType: string;
  var Value: Variant): Boolean;
var
  i, j: Integer;
  RAI2Record: TRAI2Record;
  Rec: PChar;
begin
  for i := 0 to FRecList.Count - 1 do { Iterate }
  begin
    RAI2Record := TRAI2Record(FRecList[i]);
    if Cmp(RAI2Record.Identifer, RecordType) then
    begin
      if Assigned(RAI2Record.CreateFunc) then
        RAI2Record.CreateFunc(Pointer(Rec))
      else
      begin
        GetMem(Rec, RAI2Record.RecordSize);
        for j := 0 to RAI2Record.FieldCount - 1 do { Iterate }
          if RAI2Record.Fields[j].Typ = varString then
            PString(PString(Rec + RAI2Record.Fields[j].Offset)^) := @EmptyStr;
      end;
      RAI2VarCopy(Value, R2V(RecordType, Rec));                               
      Result := SetRecord(Value);
      Exit;
    end;
  end; { for }
  Result := False;
end;

{$IFDEF RAI2_OLEAUTO}

function TRAI2Adapter.DispatchCall(Identifer: string; var Value: Variant;
  Args: TArgs; Get: Boolean; isRef: Boolean): Boolean; stdcall;
var
  CallDesc: TCallDesc;
  ParamTypes: array[0..MaxDispArgs * 4 - 1] of Byte;
//  ParamsPtr: Pointer absolute ParamTypes;
  Ptr: Integer;
  TypePtr: Integer;

  procedure AddParam(Param: Variant);

    procedure AddParam1(Typ: Byte; ParamSize: Integer; var Param);
    begin
     { CallDesc.ArgTypes[Ptr] := Typ;
      Move(Param, ParamTypes[Ptr], ParamSize);
      inc(Ptr, ParamSize); }
      CallDesc.ArgTypes[TypePtr] := Typ;
      Move(Param, ParamTypes[Ptr], ParamSize);
      inc(Ptr, ParamSize);
      inc(TypePtr);
    end;

  var
    Int: Integer;
    Wrd: WordBool;
    Poin: Pointer;
    Dbl: Double;
    TempDisp : IDispatch;
{    V: Variant;
    T: Integer;}
  begin
{    if VarIsArray(Param) then begin
      V:=Param[0];
      T:=TVarData(V).VType;
      AddParam1(T,sizeof(TSafeArray),PSafeArray(TVarData(V).VArray));
      exit;
    end;}
    case TVarData(Param).VType of
      varPointer: begin
         Poin:=V2P(Param);
         AddParam1(varStrArg, SizeOf(Poin),Poin);
      end;
      varEmpty: begin
         AddParam1(varEmpty, SizeOf(TVarData(Param).VUnknown), TVarData(Param).VUnknown);
      end;
      varNull: begin
         AddParam1(varNull, SizeOf(TVarData(Param).VUnknown), TVarData(Param).VUnknown);
      end;
      varInteger:
        begin
          Int := Param;
          AddParam1(varInteger, sizeof(Int), Int);
        end;
      varString:
        begin
          Poin := V2P(Param);
          AddParam1(varStrArg, sizeof(Poin), Poin);
        end;
      varOleStr:
        begin
          Poin := V2P(Param);
          AddParam1(varOleStr, sizeof(Poin), Poin);
        end;  
      varBoolean:
        begin
          Wrd := WordBool(Param);
          AddParam1(varBoolean, sizeof(Wrd), Wrd);
        end;
      varDouble:
        begin
          Dbl := (Param);
          AddParam1(varDouble, sizeof(Dbl), Dbl);
        end;
      varDispatch:
        begin
          TempDisp:=IDispatch(TVarData(Param).VDispatch);
          if TempDisp<>nil then
            AddParam1(varDispatch, sizeof(TempDisp), TempDisp);
        end;

    end;
  end; { AddParam1 }

var
  PVRes: PVariant;
  Names: string;
  i: Integer;
  Disp: Variant;
begin
  Result := True;
 {Call mathod through Ole Automation}
  with CallDesc do
  begin
    if not isRef then begin
     if Get then
      CallType := DISPATCH_METHOD or DISPATCH_PROPERTYGET
     else
      CallType := DISPATCH_PROPERTYPUT;
    end else begin
      CallType:=DISPATCH_PROPERTYPUTREF;
    end;

    ArgCount := Args.Count;
    NamedArgCount := 0; { named args not supported by RAI2 }
  end;
  Names := Identifer + #00;
  Ptr := 0;
  TypePtr := 0;
  if not Get then
  begin
    AddParam(Value);
    inc(CallDesc.ArgCount);
  end;
  for i := 0 to Args.Count - 1 do
    AddParam(Args.Values[i]);
  Value := Null;
 { When calling procedures(without result) PVRes must be nil }
  if Args.HasResult and Get then
    PVRes := @Value
  else
    PVRes := nil;
  try
   { call }

    TVarData(Disp).VType:=varDispatch or varByRef;
    TVarData(Disp).VPointer:=@Args.Obj;

    Move(Pointer(Names)^,Pointer(@CallDesc.ArgTypes[CallDesc.ArgCount])^,Length(Names));

    VarDispInvoke(PVRes, Disp, @CallDesc, @ParamTypes);
    
//    VarDispInvoke(PVRes, Disp, PChar(Names), @CallDesc, @ParamTypes);
  except
    on E: EOleError do
      RAI2ErrorN2(ieOleAuto, -1, Identifer, E.Message);
  end;
  if Get and (TVarData(Value).VType = varOleStr) then
    Value := VarAsType(Value, varString);
end;
{$ENDIF RAI2_OLEAUTO}

function TRAI2Adapter.GetValueRTTI(Identifer: string; var Value: Variant;
  Args: TArgs): Boolean;
var
  TypeInf: PTypeInfo;
  PropInf: PPropInfo;
  PropTyp: TypInfo.TTypeKind;
begin
  Result := False;
  if (Args.ObjTyp <> varObject) or (Args.Obj = nil) then Exit;
  TypeInf := Args.Obj.ClassInfo;
  if TypeInf = nil then Exit;
  PropInf := GetPropInfo(TypeInf, Identifer);
  if PropInf = nil then Exit;

  PropTyp := PropInf.PropType^.Kind;
  case PropTyp of
    tkInteger, tkEnumeration:
      Value := GetOrdProp(Args.Obj, PropInf);
    tkChar, tkWChar:
      Value := Char(GetOrdProp(Args.Obj, PropInf));
    tkFloat: begin
      Value := GetFloatProp(Args.Obj, PropInf);
{      if PropInf.PropType^=TypeInfo(TDateTime) then
         Value:= VarAsType(Result, varDate);}
    end;
    tkString, tkLString{$IFDEF RA_D3H}, tkWString{$ENDIF RA_D3H}:
      Value := GetStrProp(Args.Obj, PropInf);
    tkClass:
      Value := O2V(TObject(GetOrdProp(Args.Obj, PropInf)));
    tkSet:
      Value := S2V(GetOrdProp(Args.Obj, PropInf));
    tkVariant:
      Value:=GetVariantProp(Args.Obj, PropInf);
  else
    Exit;
  end;
  if PropInf^.PropType^.Name = 'Boolean' then
    TVarData(Value).VType := varBoolean;
  if (PropInf^.PropType^.Name = 'TDate')or
     (PropInf^.PropType^.Name = 'TTime')or
     (PropInf^.PropType^.Name = 'TDateTime') then
    TVarData(Value).VType := varDate;
  Result := True;
end;

function TRAI2Adapter.SetValueRTTI(Identifer: string; const Value: Variant;
  Args: TArgs): Boolean;
var
  TypeInf: PTypeInfo;
  PropInf: PPropInfo;
  PropTyp: TypInfo.TTypeKind;
  Obj: TObject;
begin
  Result := False;
  if (Args.ObjTyp <> varObject) or (Args.Obj = nil) then Exit;
  Obj := Args.Obj;
  TypeInf := Obj.ClassInfo;
  if TypeInf = nil then Exit;
  PropInf := GetPropInfo(TypeInf, Identifer);
  if PropInf = nil then Exit;
  PropTyp := PropInf.PropType^.Kind;
  case PropTyp of
    tkInteger, tkEnumeration:
      SetOrdProp(Args.Obj, PropInf, Var2Type(Value, varInteger));
    tkChar, tkWChar:
      SetOrdProp(Args.Obj, PropInf, integer(string(Value)[1]));
    tkFloat:
      SetFloatProp(Args.Obj, PropInf, Value);
    tkString, tkLString{$IFDEF RA_D3H}, tkWString{$ENDIF RA_D3H}:
      SetStrProp(Args.Obj, PropInf, VarToStr(Value));
    tkClass:
      SetOrdProp(Args.Obj, PropInf, integer(V2O(Value)));
    tkSet:
      SetOrdProp(Args.Obj, PropInf, V2S(Value));
    tkVariant:
      SetVariantProp(Args.Obj, PropInf, Value);  
  else
    Exit;
  end;
  Result := True;
end;

procedure TRAI2Adapter.CurUnitChanged(NewUnitName: string; var Source: string);
var
  i: Integer;
  RAI2UnitSource: TRAI2SrcUnit;
begin
  for i := 0 to FSrcUnitList.Count - 1 do { Iterate }
  begin
    RAI2UnitSource := TRAI2SrcUnit(FSrcUnitList.Items[i]);
    if Cmp(TRAI2SrcUnit(RAI2UnitSource).Identifer, NewUnitName) then
    begin
      Source := TRAI2SrcUnit(RAI2UnitSource).Source;
      Exit;
    end;
  end; { for }
  Source := '';
end;

function TRAI2Adapter.UnitExists(const Identifer: string): Boolean;
var
  RAI2Identifer: TRAI2Identifer;
  i: Integer;
begin
  Result := True;
  for i := 0 to FSrcUnitList.Count - 1 do { Iterate }
  begin
    RAI2Identifer := TRAI2Identifer(FSrcUnitList.Items[i]);
    if Cmp(RAI2Identifer.Identifer, Identifer) then
      Exit;
  end; { for }
  for i := 0 to FExtUnitList.Count - 1 do { Iterate }
  begin
    RAI2Identifer := TRAI2Identifer(FExtUnitList.Items[i]);
    if Cmp(RAI2Identifer.Identifer, Identifer) then
      Exit;
  end; { for }
  Result := False;
end;

function TRAI2Adapter.NewEvent(const UnitName: string; const FunName,
  EventType: string; AOwner: TRAI2Expression; AObject: TObject): TSimpleEvent;
var
  Event: TEvent;
  i: Integer;
  RAI2EventDesc: TRAI2EventDesc;
begin
  for i := 0 to FEventHandlerList.Count - 1 do { Iterate }
  begin
    RAI2EventDesc := TRAI2EventDesc(FEventHandlerList.Items[i]);
    if Cmp(RAI2EventDesc.Identifer, EventType) then
    begin
      Event := RAI2EventDesc.EventClass.Create(FhInterpreter,AObject,PChar(FunName));
      TMethod(Result).Code := RAI2EventDesc.Code;
      TMethod(Result).Data := Event;
      Exit;
    end;
  end; { for }
  Result := nil; { satisfy compiler }
end; { NewEvent }

function TRAI2Adapter.FindEvent(const UnitName: string; const FunName,
  EventType: string; AOwner: TRAI2Expression; AObject: TObject): TSimpleEvent;
{var
  Event: TEvent;
  i: Integer;
  RAI2EventDesc: TRAI2EventDesc;}
begin
(*  for i := 0 to FEventHandlerList.Count - 1 do { Iterate }
  begin
    RAI2EventDesc := TRAI2EventDesc(FEventHandlerList.Items[i]);
    if Cmp(RAI2EventDesc.Identifer, EventType) then  begin
     RAI2EventDesc.
      if Cmp()
      Event := RAI2EventDesc.EventClass.Create(FhInterpreter,AObject,PChar(FunName));
      TMethod(Result).Code := RAI2EventDesc.Code;
      TMethod(Result).Data := Event;
      Exit;
    end;
  end; { for }*)
  Result := nil; { satisfy compiler }
end; { NewEvent }

function TRAI2Adapter.IsEvent(Obj: TObject; const Identifer: string)
  : Boolean;
var
  RAI2Class: TRAI2Class;
  i: Integer;
begin
  for i := 0 to FEventList.Count - 1 do { Iterate }
  begin
    RAI2Class := TRAI2Class(FEventList[i]);
    if (Obj is RAI2Class.ClassType) and
      Cmp(RAI2Class.Identifer, Identifer) then
    begin
      Result := True;
      Exit;
    end;
  end;
  Result := False;
end;

procedure TRAI2Adapter.Sort;
begin
  FConstList.Sort;
  FClassList.Sort;
  FFunList.Sort;
  FGetList.Sort;
  FSetList.Sort;
  FIGetList.Sort;
  FISetList.Sort;
  FSorted := True;
end;


{ ************************* TArgs ************************* }

procedure TArgs.Clear;
begin
  Count := 0;
  Obj := nil;
  ObjTyp := 0;
  HasVars := False;
  Indexed := False;
  ReturnIndexed := False;
end;

destructor TArgs.Destroy;
begin
  if OA <> nil then Dispose(OA);
  if OAV <> nil then Dispose(OAV);
  inherited Destroy;
end; { Destroy }

procedure TArgs.OpenArray(const index: Integer);
begin
  if OA = nil then New(OA);
  if OAV = nil then New(OAV);
  V2OA(Values[index], OA^, OAV^, OAS);
end;

procedure TArgs.Delete(const Index: Integer);
var
  i: Integer;
begin
  for i := Index to Count - 2 do
  begin
    Types[i] := Types[i + 1];
    Values[i] := Values[i + 1];
    Names[i] := Names[i + 1];
  end;
  dec(Count);
end;

{ ************************* TRAI2Expression ************************* }

constructor TRAI2Expression.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Parser := TRAI2Parser.Create;
  FPStream := TStringStream.Create('');
  FArgs := TArgs.Create;
  FAdapter := CreateAdapter;
  FSharedAdapter := GlobalRAI2Adapter;
  FLastError := ERAI2Error.Create(-1, -1, '', '');
  AllowAssignment := True;
end; { Create }

destructor TRAI2Expression.Destroy;
begin
  RAI2VarFree(FVResult);
  FAdapter.Free;
  FArgs.Free;
  FPStream.Free;
  Parser.Free;
  FLastError.Free;
  inherited Destroy;
end; { Destroy }

procedure TRAI2Expression.UpdateExceptionPos(E: Exception; const UnitName: string);

  procedure NONAME1(E: ERAI2Error);
  begin
    if not E.FExceptionPos then
    begin
      if E.FErrPos = -1 then
        E.FErrPos := CurPos;
      if E.FErrUnitName = '' then
        E.FErrUnitName := UnitName;
      if E.FErrUnitName <> '' then
      begin
        E.FErrLine := GetLineByPos(Parser.Source, E.FErrPos) + BaseErrLine;
        E.Message := Format(LoadStr2(ieErrorPos),
          [E.FErrUnitName, E.FErrLine, E.FMessage1]);
        E.FExceptionPos := True;
      end;
    end;
  end;

begin
  if E is ERAI2Error then
  begin
    NONAME1(E as ERAI2Error);
    FLastError.Assign(E as ERAI2Error);
    if Assigned(FOnError) then FOnError(Self); 
  end
  else if not FLastError.FExceptionPos then
  begin
    FLastError.FErrCode := ieExternal;
    FLastError.Message := E.Message;
    FLastError.FMessage1 := E.Message;
    NONAME1(FLastError);
    if Assigned(FOnError) then FOnError(Self);
  end;
end; { UpdateExceptionPos }

procedure TRAI2Expression.Init;
begin
  FVResult := Null;
  ExpStackPtr := -1;
 // Parse;
  Parser.Init;
  FBacked := False;
  Args := FArgs;
//  FAdapter.ClearNonSource;
  FLastError.Clear;
end; { Init }

function TRAI2Expression.GetSource: string;
begin
  Result := Parser.Source;
end; { GetSource }

procedure TRAI2Expression.SetSource(Value: string);
begin
  Parser.Source := Value;
  SourceChanged;
end; { SetSource }

procedure TRAI2Expression.SourceChanged;
begin
end; { SourceChanged }

procedure TRAI2Expression.SetAdapter(Adapter: TRAI2Adapter);
begin
  FAdapter := Adapter;
end; { SetAdapter }

procedure TRAI2Expression.SetCurPos(Value: Integer);
begin
  if FParsed then
    FPStream.Position := Value
  else
    Parser.Pos := Value;
  FBacked := False;
end; { SetCurPos }

function TRAI2Expression.GetCurPos: Integer;
begin
  if FParsed then
    Result := FPStream.Position
  else
    Result := Parser.Pos;
end; { GetCurPos }

procedure TRAI2Expression.ErrorExpected(Exp: string);
begin
  if TokenStr <> '' then
    RAI2ErrorN2(ieExpected, PosBeg, Exp, '''' + TokenStr + '''')
  else
    RAI2ErrorN2(ieExpected, PosBeg, Exp, LoadStr2(irEndOfFile));
end; { ErrorExpected }

procedure TRAI2Expression.ErrorNotImplemented(Message: string);
begin
  RAI2ErrorN(ieInternal, PosBeg, Message + ' not implemented');
end; { ErrorNotImplemented }

function TRAI2Expression.PosBeg: Integer;
begin
  Result := CurPos - Length(TokenStr);
end; { PosBeg }

function TRAI2Expression.PosEnd: Integer;
begin
  Result := CurPos;
end; { PosEnd }

function TRAI2Expression.GetTokenStr: string;
begin
  if FParsed and (TTyp <> ttUnknown) then
    Result := TypToken(TTyp)
  else
    Result := TokenStr1;
end; { GetTokenStr }

procedure TRAI2Expression.Parse;
begin
{$IFNDEF RA_D2}
  FPStream.Size := 0;
{$ELSE}
  (FPStream as TStringStream).SetSize(0);
{$ENDIF}
  FPStream.Position := 0;
  Parser.Init;
  repeat
    ParseToken;
    WriteToken;
  until TTyp1 = ttEmpty;
  FParsed := True;
  FPStream.Position := 0;
end; { Parse }

procedure TRAI2Expression.WriteToken;
begin
  WordSaveToStream(FPStream, Word(TTyp1));
  case TTyp1 of
    ttInteger:
      IntSaveToStream(FPStream, Token1);
    ttString:
      StringSaveToStream(FPStream, Token1);
    ttTrue, ttFalse:
      BoolSaveToStream(FPStream, Token1);
    ttDouble:
      ExtendedSaveToStream(FPStream, Token1);
    ttIdentifer:
      StringSaveToStream(FPStream, Token1);
    ttUnknown:
      StringSaveToStream(FPStream, TokenStr1);
  end;
end; { WriteToken }

procedure TRAI2Expression.ReadToken;
begin
  TTyp1 := SmallInt(WordLoadFromStream(FPStream));
  case TTyp1 of
    ttInteger:
      Token1 := IntLoadFromStream(FPStream);
    ttString:
      Token1 := StringLoadFromStream(FPStream);
    ttTrue, ttFalse:
      Token1 := BoolLoadFromStream(FPStream);
    ttDouble:
      Token1 := ExtendedLoadFromStream(FPStream);
    ttIdentifer:
      Token1 := StringLoadFromStream(FPStream);
    ttUnknown:
      TokenStr1 := StringLoadFromStream(FPStream);
  end;
end; { ReadParsed }

procedure TRAI2Expression.NextToken;
begin
  if FBacked then
    FBacked := False
  else
  begin
    PrevTTyp := TTyp1;
    if FParsed then
      ReadToken
    else
      ParseToken;
  end;
end; { NextToken }

procedure TRAI2Expression.ParseToken;
var
  OldDecimalSeparator: char;
  Dob: Extended;
  Int: Integer;
  Stub: Integer;
begin
  TokenStr1 := Parser.Token;
  TTyp1 := TokenTyp(TokenStr1);
  case TTyp of { }
    ttInteger:
      begin
        Val(TokenStr1, Int, Stub);
        Token1 := Int;
      end;
    ttDouble:
      begin
        OldDecimalSeparator := DecimalSeparator;
        DecimalSeparator := '.';
        if not TextToFloat(PChar(TokenStr1), Dob, fvExtended) then
        begin
          DecimalSeparator := OldDecimalSeparator;
          RAI2Error(ieInternal, -1);
        end
        else
          DecimalSeparator := OldDecimalSeparator;
        Token1 := Dob;
      end;
    ttString:
      Token1 := Copy(TokenStr, 2, Length(TokenStr1) - 2);
    ttFalse:
      Token1 := False;
    ttTrue:
      Token1 := True;
    ttIdentifer:
      Token1 := TokenStr1;
    {-----olej-----}
    ttArray:
      Token1 := TokenStr1;
    {-----olej-----}
  end; { case }
end; { ParseToken }

procedure TRAI2Expression.Back;
begin
//  RAI2Error(ieInternal, -2);
  if FBacked then
    RAI2Error(ieInternal, -1);
  FBacked := True;
end; { Back }

procedure TRAI2Expression.SafeBack;
begin
  if not FBacked then
    Back;
end; { SafeBack }

function TRAI2Expression.CreateAdapter: TRAI2Adapter;
begin
  Result := TRAI2Adapter.Create(Self);
end; { CreateAdapter }

function TRAI2Expression.Expression1: Variant;

  procedure PushExp(var Value: Variant);
  begin
    inc(ExpStackPtr);
    if ExpStackPtr > High(ExpStack) then
      RAI2Error(ieInternal, -1);
    RAI2VarCopy(ExpStack[ExpStackPtr], Value);
  end; { PushExp }

  function PopExp: Variant;
  begin
    if ExpStackPtr = -1 then
      RAI2Error(ieInternal, -1);
    RAI2VarCopy(Result, ExpStack[ExpStackPtr]);
    dec(ExpStackPtr);
  end; { PopExp }

  { function Expression called recursively very often, so placing it
    as local function (not class method) improve performance }
  function Expression(const OpTyp: TTokenTyp): Variant;
  var
    Tmp: Variant;
  begin
    Result := Unassigned;
    if OpTyp <> ttUnknown then
      NextToken;
    while True do
    begin
      case TTyp of { }
        ttInteger, ttDouble, ttString, ttFalse, ttTrue, ttIdentifer:
          begin
            Result := Token;
            if TTyp = ttIdentifer then
            begin
              Args.Clear;
              InternalGetValue(nil, 0, Result);
            end;
            NextToken;
            if TTyp in [ttInteger, ttDouble, ttString,
              ttFalse, ttTrue, ttIdentifer] then
              RAI2Error(ieMissingOperator, PosEnd {!!});
            if Prior(TTyp) < Prior(OpTyp) then
              Exit;
          end;
        ttMul:
          if priorMul > Prior(OpTyp) then
            Result := PopExp * Expression(TTyp)
          else Exit;
        ttPlus:
         { proceed differently depending on a types }
          if not (PrevTTyp in [ttInteger, ttDouble, ttString, ttFalse, ttTrue,
            ttIdentifer, ttRB, ttRS]) then
           { unar plus }
            Result := Expression(ttNot {highest priority})
          else
            if priorPlus > Prior(OpTyp) then
            begin
              Tmp := PopExp;
              if TVarData(Tmp).VType = varSet then
              begin
                Result := TVarData(Tmp).VInteger or
                  TVarData(Expression(TTyp)).VInteger;
                TVarData(Result).VType := varSet;
              end else if PrevTTyp=ttString then begin
                Result:=tmp+String(Expression(TTyp));
              end else
                Result := Tmp + Expression(TTyp)
            end else Exit;
        ttMinus:
         { proceed differently depending on a types }
          if not (PrevTTyp in [ttInteger, ttDouble, ttString, ttFalse, ttTrue,
            ttIdentifer, ttRB, ttRS]) then
           { unar minus }
            Result := -Expression(ttNot {highest priority})
          else
            if priorMinus > Prior(OpTyp) then
            begin
              Tmp := PopExp;
              if TVarData(Tmp).VType = varSet then
              begin
                Result := TVarData(Tmp).VInteger and not
                  TVarData(Expression(TTyp)).VInteger;
                TVarData(Result).VType := varSet;
              end else 
                Result := Tmp - Expression(TTyp)
            end else Exit;
        ttDiv:
          if priorDiv > Prior(OpTyp) then
            Result := PopExp / Expression(TTyp)
          else Exit;
        ttIntDiv:
          if priorIntDiv > Prior(OpTyp) then
            Result := PopExp div Expression(TTyp)
          else Exit;
        ttMod:
          if priorMod > Prior(OpTyp) then
            Result := PopExp mod Expression(TTyp)
          else Exit;
        ttOr:
          if priorOr > Prior(OpTyp) then
            Result := PopExp or Expression(TTyp)
          else Exit;
        ttAnd:
          if priorAnd > Prior(OpTyp) then
            Result := PopExp and Expression(TTyp)
          else Exit;
        ttNot:
         { 'Not' has highest priority, so we have not need to check this }
         // if priorNot > Prior(OpTyp) then
          Result := not Expression(TTyp);
         //  else Exit;
        ttEqu:
         { proceed differently depending on a types }
          if priorEqu > Prior(OpTyp) then
          begin
            Tmp := PopExp;
            if TVarData(Tmp).VType in [varObject, varClass, varSet, varPointer] then
              Result := TVarData(Tmp).VInteger =
                TVarData(Expression(TTyp)).VInteger
            else
              Result := Tmp = Expression(TTyp)
          end else Exit;
        ttNotEqu:
         { proceed differently depending on a types }
          if priorNotEqu > Prior(OpTyp) then
          begin
            Tmp := PopExp;
            if TVarData(Tmp).VType in [varObject, varClass, varSet, varPointer] then
              Result := TVarData(Tmp).VInteger <>
                TVarData(Expression(TTyp)).VInteger
            else
              Result := Tmp <> Expression(TTyp)
          end else Exit;
        ttGreater:
          if priorGreater > Prior(OpTyp) then
            Result := PopExp > Expression(TTyp)
          else Exit;
        ttLess:
          if priorLess > Prior(OpTyp) then
            Result := PopExp < Expression(TTyp)
          else Exit;
        ttEquLess:
          if priorEquLess > Prior(OpTyp) then
            Result := PopExp <= Expression(TTyp)
          else Exit;
        ttEquGreater:
          if priorEquGreater > Prior(OpTyp) then
            Result := PopExp >= Expression(TTyp)
          else Exit;
        ttLB:
          begin
            Result := Expression(TTyp);
            if TTyp1 <> ttRB then
              ErrorExpected(''')''');
            NextToken;
          end;
        ttRB:
          exit;
{          if TVarData(Result).VType = varEmpty then
            ErrorExpected(LoadStr2(irExpression))
          else Exit;                             }
        ttLS:
          begin
            NextToken;
            Result := SetExpression1;
            if TTyp1 <> ttRS then
              ErrorExpected(''']''');
            NextToken;
          end;
        ttRS:
          exit;
         { if TVarData(Result).VType = varEmpty then
            ErrorExpected(LoadStr2(irExpression))
          else Exit;  }
      else
{        if TVarData(Result).VType = varEmpty then
          ErrorExpected(LoadStr2(irExpression))
        else Exit;                             }
        exit;
      end; { case }
      PushExp(Result);
    end;
  end; { Expression }
var
  OldExpStackPtr: Integer;
begin
  Result := Null;
  try
    OldExpStackPtr := ExpStackPtr;
    try
      Expression(ttUnknown);
      RAI2VarCopy(Result, PopExp);
    finally
      ExpStackPtr := OldExpStackPtr;
    end;
  except
    on E: EVariantError do
      RAI2Error(ieTypeMistmatch, CurPos);
  end; { try/except }
end; { Expression1 }

function TRAI2Expression.Expression2(const ExpType: Word): Variant;
var
  ErrPos: Integer;
begin
  ErrPos := PosBeg;
  try
    AllowAssignment:= False;
    Result := Expression1;
  finally
    AllowAssignment := True;
  end;
  if TVarData(Result).VType <> ExpType then
    case ExpType of { }
      varInteger:
        RAI2Error(ieIntegerRequired, ErrPos);
      varBoolean:
        RAI2Error(ieBooleanRequired, ErrPos);
    else
      RAI2Error(ieUnknown, ErrPos);
    end; { case }
end; { Expression2 }

{ calulate sets expressions, such as: [fsBold, fsItalic] }

function TRAI2Expression.SetExpression1: Variant;
var
  V1: Variant;
begin
  Result := 0;
  while True do
  begin
    case TTyp of { }
      ttIdentifer, ttInteger:
        begin
          if TTyp = ttInteger then
            Result := Result or Integer(Token)
          else
          begin
            Args.Clear;
            InternalGetValue(nil, 0, V1);
            if VarType(V1) <> varInteger then
              RAI2Error(ieIntegerRequired, PosBeg);
            Result := Result or 1 shl Integer(V1);
          end;
          NextToken; { skip ',' }
          if TTyp = ttCol then
            NextToken
          else if TTyp = ttRS then
            Break
          else
            ErrorExpected(''']''');
        end;
      ttRS:
        Break;
    else
      Break;
    end;
  end;
  TVarData(Result).VType := varSet;
end; { SetExpression1 }

procedure TRAI2Expression.ReadArgs;

  function ReadOpenArray: Variant;
  var
    Values: TValueArray;
    i: Integer;
  begin
   { open array or set constant }
    NextToken;
    Values[0] := Expression1;
    i := 1;
    while TTyp = ttCol do
    begin
      NextToken;
      Args.Clear;
      Values[i] := Expression1;
      inc(i);
    end; { while }
    if TTyp <> ttRS then
      ErrorExpected(''']''');
    Result := VarArrayCreate([0, i-1], varVariant);
    for i := 0 to i - 1 do { Iterate }
      Result[i] := Values[i];
    NextToken;
  end;

var
  LocalArgs: TArgs;
  i: Integer;
  SK: TTokenTyp;
begin
  LocalArgs := Args;
  Args := TArgs.Create;
  Args.hInterpreter:=Adapter.hInterpreter;
  Args.Indexed := LocalArgs.Indexed;
  try
    i := 0;
    if TTyp = ttLB then
      SK := ttRB
    else { if TTyp = ttLS then }
      SK := ttRS;

    NextToken;
    if TTyp = ttIdentifer then
      LocalArgs.VarNames[i] := Token else
      LocalArgs.VarNames[i] := '';

    Args.Clear;
    if TTyp = ttLS then
      LocalArgs.Values[i] := ReadOpenArray
//added check to recognize C style (), like "NextToken()"
//RWare: if token ')', skip and exit
    else if TTyp = ttRB then begin
      NextToken;
      Exit;
    end else
      RAI2VarCopy(LocalArgs.Values[i], Expression1);

    while TTyp = ttCol do
    begin
      inc(i);
      NextToken;
      if TTyp = ttIdentifer then
        LocalArgs.VarNames[i] := Token else
        LocalArgs.VarNames[i] := '';
      Args.Clear;
      if TTyp = ttLS then
        LocalArgs.Values[i] := ReadOpenArray else
        RAI2VarCopy(LocalArgs.Values[i], Expression1);
    end; { while }
    if TTyp <> SK then
      if SK = ttRB then
        ErrorExpected(''')''') else ErrorExpected(''']''');
    NextToken;
    LocalArgs.Count := i + 1;
  finally { wrap up }
    Args.Free;
    Args := LocalArgs;
  end; { try/finally }
end; { ReadArgs }

procedure TRAI2Expression.InternalGetValue(Obj: Pointer; ObjTyp: Word;
  var Result: Variant);

  procedure UpdateVarParams;
  var
    i, C: Integer;
  begin
    if not Args.HasVars then Exit;
    C := Args.Count;
    Args.Obj := nil;
    Args.ObjTyp := 0;
    Args.Count := 0;
    for i := 0 to C - 1 do { Iterate }
      if (Args.VarNames[i] <> '') and ((Args.Types[i] and varByRef) <> 0) then
      {  if not } SetValue(Args.VarNames[i], Args.Values[i], Args) {then
          RAI2ErrorN(ieUnknownIdentifer, PosBeg, Args.VarNames[i])};
    Args.HasVars := False;
  end; { SetVarParams }

var
  Identifer: string;
  V: Variant;
begin
  Identifer := Token;
  NextToken;
  Args.Indexed := TTyp = ttLS;
  if TTyp in [ttLB, ttLS] then
    ReadArgs
  else
    Args.Count := 0;
  Args.Obj := Obj;
  Args.ObjTyp := ObjTyp;
  if (TTyp = ttColon) and AllowAssignment then
  begin
    if Args.ObjTyp=varDispatch then begin
      NextToken;
      if TTyp <> ttEqu then
        ErrorExpected('''=''');
      NextToken;
      InternalSetValue(Identifer);
      
    end;
    Back;
    Token1 := Identifer; {!!!!!!!!!!!!!!}
    { Args.Obj, Args.ObjTyp, Args.Count needed in caller }
    Exit;
  end;

  { need result if object field or method or assignment }
  Args.HasResult := (TTyp in [ttPoint, ttRB, ttCol, ttNot..ttEquLess]) or
    Args.Assignment;
  Args.ReturnIndexed := False;

  if GetValue(Identifer, Result, Args) then
  begin
    if TVarData(Result).VType = varRecord then
      if not (FAdapter.SetRecord(Result) or
        (Assigned(GlobalRAI2Adapter) and (FAdapter <> GlobalRAI2Adapter) and
         GlobalRAI2Adapter.SetRecord(Result))) then
        RAI2ErrorN(ieRecordNotDefined, -1, 'Unknown RecordType');
   { Args.HasVars may be changed in previous call to GetValue }
    if Args.HasVars then
      UpdateVarParams;
    if Args.Indexed and not Args.ReturnIndexed then
    begin
      if not GetElement(Result, Result, Args) then
       { problem }
        RAI2Error(ieArrayRequired, PosBeg);
    end;
  end
  else
    RAI2ErrorN(ieUnknownIdentifer, PosBeg {?}, Identifer);

  Args.Obj := nil;
  Args.ObjTyp := 0;
  Args.Count := 0;

 { Args.Obj, Args.ObjTyp, Args.Count NOT needed in caller }

  if TTyp = ttPoint then { object field or method }
  begin
    NextToken;
    if TTyp <> ttIdentifer then
      ErrorExpected(LoadStr2(irIdentifer));
    if not (TVarData(Result).VType in
      [varObject, varClass, varRecord, varDispatch]) then
      RAI2Error(ieROCRequired, PosBeg);

    V := Null;
    InternalGetValue(TVarData(Result).vPointer, TVarData(Result).VType, V);
    Result := V;

    NextToken;
  end;

  Back;
end; { InternalGetValue }

procedure TRAI2Expression.InternalSetValue(const Identifer: string);
var
  MyArgs: TArgs;
  Variable: Variant;
begin
 { normal (not method) assignmnent }
 { push args }
  MyArgs := Args;
  Args := TArgs.Create;
  Args.hInterpreter:=Adapter.hInterpreter;
  
  try
    Args.Assignment := True;
    FVResult := Expression1;
  finally { wrap up }
   { pop args }
    Args.Free;
    Args := MyArgs;
  end; { try/finally }
  if Args.Indexed then
  begin
    MyArgs := TArgs.Create;
    MyArgs.hInterpreter:=Adapter.hInterpreter;
    try
      if GetValue(Identifer, Variable, MyArgs) then
      begin
        if not SetElement(Identifer, Variable, FVResult, Args) then
         { problem }
          RAI2Error(ieArrayRequired, PosBeg);
        if (TVarData(Variable).VType = varString) and
            not SetValue(Identifer, Variable, MyArgs) then
          RAI2ErrorN(ieUnknownIdentifer, PosBeg, Identifer);
      end
      else if not SetValue(Identifer, FVResult, Args) then
        RAI2ErrorN(ieUnknownIdentifer, PosBeg, Identifer);
    finally
      MyArgs.Free;
    end;
  end
  else if not SetValue(Identifer, FVResult, Args) then
    RAI2ErrorN(ieUnknownIdentifer, PosBeg, Identifer);
end; { InternalSetValue }

function TRAI2Expression.GetElement(const Variable: Variant; var Value: Variant;
  var Args: TArgs): Boolean;
var
  II2: Integer;
  VV: TRAI2ArrayValues;
  PP: PRAI2ArrayRec;
  Bound,i: Integer;
  d: Integer;
  V: Variant;
  h,l: Integer;
begin
  Result := False;
  if Args.Count <> 0 then
  begin
    if VarIsArray(Variable) then begin
      V:=Variable[0];
      d:=VarArrayDimCount(V);
      h:=VarArrayHighBound(V,d);
      l:=VarArrayLowBound(V,d);
      if Args.Count > 1 then
        RAI2Error(ieArrayTooManyParams, -1)
      else if Args.Count < 1 then
        RAI2Error(ieArrayNotEnoughParams, -1);
      for i:=0 to Args.Count-1 do begin
        Bound:=Args.Values[i];
        if Bound<l then
          RAI2Error(ieArrayIndexOutOfBounds, -1);
        if Bound>h then
          RAI2Error(ieArrayIndexOutOfBounds, -1);
        Value:=V[Bound];
      end;
      Result := True;
      exit;
    end;
    case TVarData(Variable).VType of
      varString:
        begin
          if Args.Count > 1 then
            RAI2Error(ieArrayTooManyParams, -1);
            if Length(Variable) = 0 then
              raise ERangeError.Create('range check error');
          Value := string(Variable)[integer(Args.Values[0])];
          Result := True;
        end;
      varArray:
        begin
          {Get array value}
          PP := PRAI2ArrayRec(Integer(RAI2VarAsType(Variable, varInteger)));
          if Args.Count > PP.Dimension then
            RAI2Error(ieArrayTooManyParams, -1)
          else if Args.Count < PP.Dimension then
            RAI2Error(ieArrayNotEnoughParams, -1);
          for II2 := 0 to Args.Count - 1 do
          begin
            Bound := Args.Values[II2];
            if Bound < PP.BeginPos[II2] then
              RAI2Error(ieArrayIndexOutOfBounds, -1)
            else if Bound > PP.EndPos[II2] then
              RAI2Error(ieArrayIndexOutOfBounds, -1);
            VV[II2] := Args.Values[II2];
          end;
          Value := RAI2ArrayGetElement(VV, PP);
          Result := True;
        end;
      varObject, varClass:
        begin
          Result := FAdapter.GetElement(Self, Variable, Value, Args);
          if not Result and Assigned(FSharedAdapter) then
            Result := FSharedAdapter.GetElement(Self, Variable, Value, Args);
        end;
      varDispatch: begin
        if Args.ObjTyp=varDispatch then begin
          Result:=true;
          exit;
        end;  
      end;
      varNull: begin
        if Args.ObjTyp=varDispatch then begin
          Result:=true;
          exit;
        end;
      end;
      else
       { problem }
        RAI2Error(ieArrayRequired, CurPos);
    end;
  end;
end;

function TRAI2Expression.SetElement(const Identifer: string; var Variable: Variant; const Value: Variant;
  var Args: TArgs): Boolean;
var
  II2: Integer;
  VV: TRAI2ArrayValues;
  PP: PRAI2ArrayRec;
  Bound,i: Integer;
  d,h,l: Integer;
  V: Variant;
begin
  Result := False;
  if Args.Count <> 0 then
  begin
    if VarIsArray(Variable) then begin
      V:=Variable[0];
      d:=VarArrayDimCount(V);
      h:=VarArrayHighBound(V,d);
      l:=VarArrayLowBound(V,d);
       if Args.Count > 1 then
         RAI2Error(ieArrayTooManyParams, -1)
       else if Args.Count < 1 then
         RAI2Error(ieArrayNotEnoughParams, -1);
       for i:=0 to Args.Count-1 do begin
         Bound:=Args.Values[i];
         if Bound<l then
           RAI2Error(ieArrayIndexOutOfBounds, -1);
         if Bound>h then
           RAI2Error(ieArrayIndexOutOfBounds, -1);
         V[Bound]:=Value;
       end;
       Variable[0]:=V;
       Result := SetValue(Identifer, Variable, Args);
      exit;
    end;
    case TVarData(Variable).VType of
      varString:
        begin
          if Args.Count > 1 then
            RAI2Error(ieArrayTooManyParams, -1);
          string(TVarData(Variable).vString)[integer(Args.Values[0])] := string(Value)[1];
          Result := True;
        end;
      varArray:
        begin
          {Get array value}
          PP := PRAI2ArrayRec(Integer(RAI2VarAsType(Variable, varInteger)));
          if Args.Count > PP.Dimension then
            RAI2Error(ieArrayTooManyParams, -1)
          else if Args.Count < PP.Dimension then
            RAI2Error(ieArrayNotEnoughParams, -1);
          for II2 := 0 to Args.Count - 1 do
          begin
            Bound := Args.Values[II2];
            if Bound < PP.BeginPos[II2] then
              RAI2Error(ieArrayIndexOutOfBounds, -1)
            else if Bound > PP.EndPos[II2] then
              RAI2Error(ieArrayIndexOutOfBounds, -1);
            VV[II2] := Args.Values[II2];
          end;
          RAI2ArraySetElement(VV, Value, PP);
          Result := True;
        end;
      varObject, varClass:
        begin
          Result := FAdapter.SetElement(Self, Variable, Value, Args);
          if not Result and Assigned(FSharedAdapter) then
            Result := FSharedAdapter.SetElement(Self, Variable, Value, Args);
        end;
      else
       { problem }
        RAI2Error(ieArrayRequired, CurPos);
    end;
  end;
end;

function TRAI2Expression.GetValue(Identifer: string; var Value: Variant;
  var Args: TArgs): Boolean;
begin
  try
    Result := FAdapter.GetValue(Self, Identifer, Value, Args);
    if not Result and Assigned(FSharedAdapter) then
      Result := FSharedAdapter.GetValue(Self, Identifer, Value, Args);
  except
    on E: Exception do
    begin
      UpdateExceptionPos(E, '');
      raise;
    end;
  end;
  if not Result and Assigned(FOnGetValue) then
    FOnGetValue(Self, Identifer, Value, Args, Result);
end; { GetValue }

function TRAI2Expression.SetValue(Identifer: string; const Value: Variant;
  var Args: TArgs): Boolean;
begin
  try
    Result := FAdapter.SetValue(Self, Identifer, Value, Args);
    if not Result and Assigned(FSharedAdapter) then
      Result := FSharedAdapter.SetValue(Self, Identifer, Value, Args);
  except
    on E: ERAI2Error do
    begin
      E.FErrPos := PosBeg;
      raise;
    end;
  end;
  if not Result and Assigned(FOnSetValue) then
    FOnSetValue(Self, Identifer, Value, Args, Result);
end; { SetValue }

procedure TRAI2Expression.Run;
begin
  Init;
  NextToken;
  FVResult := Expression1;
end; { Run }

function TRAI2Expression.GetCurLine: Integer;
begin
  Result:=GetLineByPos(Parser.Source,Parser.Pos);
end;

procedure TRAI2Expression.Reset;
begin
  isReset:=true;
end;

{ ************************ TRAI2Function ************************ }

constructor TRAI2Function.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FunStack := TList.Create;
  SS := TStringList.Create;
  FEventList := TList.Create;
end; { Create }

destructor TRAI2Function.Destroy;
begin
  SS.Free;
  FunStack.Free;
  ClearList(FEventList);
  FEventList.Free;
  inherited Destroy;
end; { Destroy }

procedure TRAI2Function.Init;
begin
  inherited Init;
  FBreak := False;
  FContinue := False;
  FunStack.Clear;
  StateStackPtr := -1;
  FCurUnitName := '';
  FCurInstance := nil;
end; { Init }

procedure TRAI2Function.PushState;
begin
  inc(StateStackPtr);
  if StateStackPtr > High(StateStack) then
    RAI2Error(ieInternal, -1);
  StateStack[StateStackPtr].Token := Token1;
  StateStack[StateStackPtr].TTyp := TTyp1;
  StateStack[StateStackPtr].PrevTTyp := PrevTTyp;
  StateStack[StateStackPtr].Backed := FBacked;
  StateStack[StateStackPtr].CurPos := CurPos;
  StateStack[StateStackPtr].AllowAssignment := AllowAssignment;
end; { PushState }

procedure TRAI2Function.PopState;
begin
  if StateStackPtr = -1 then
    RAI2Error(ieInternal, -1);
  CurPos := StateStack[StateStackPtr].CurPos;
  Token1 := StateStack[StateStackPtr].Token;
  TTyp1 := StateStack[StateStackPtr].TTyp;
  PrevTTyp := StateStack[StateStackPtr].PrevTTyp;
  FBacked := StateStack[StateStackPtr].Backed;
  AllowAssignment := StateStack[StateStackPtr].AllowAssignment;
  dec(StateStackPtr);
end; { PopState }

procedure TRAI2Function.RemoveState;
begin
  dec(StateStackPtr);
end; { RemoveState }

function TRAI2Function.GetLocalVars: TRAI2VarList;
begin
  if (FunContext<>nil) then
    Result := PFunContext(FunContext).LocalVars
  else
    Result := nil;
end;

procedure TRAI2Function.InFunction1(FunDesc: TRAI2FunDesc);
var
  FunArgs: TArgs;
  VarNames: PNameArray;

  procedure EnterFunction;
  var
    FC: PFunContext;
    i: Integer;
  begin
    New(PFunContext(FC));
    FillChar(FC^, sizeof(FC^), 0);
    New(VarNames);
    PFunContext(FC).PrevFunContext := FunContext;
    FunContext := FC;
    PFunContext(FunContext).LocalVars := TRAI2VarList.Create;
    FunStack.Add(FunContext);
    FVResult := Null;
    if FunDesc <> nil then
    begin
      Args.HasVars := False;
      Args.Types := FunDesc.FParamTypes;
      for i := 0 to Args.Count - 1 do { Iterate }
      begin
        PFunContext(FunContext).LocalVars.AddVar('', FunDesc.FParamNames[i], '', FunDesc.FParamTypes[i], Args.Values[i]);
        VarNames^ := FunDesc.FParamNames;
        Args.HasVars := Args.HasVars or ((FunDesc.FParamTypes[i] and varByRef) <> 0);
      end;
      if FunDesc.ResTyp > 0 then
        PFunContext(FunContext).LocalVars.AddVar('', 'Result', '',
          FunDesc.ResTyp, Var2Type(Null, FunDesc.ResTyp));
    end
    else
      PFunContext(FunContext).LocalVars.AddVar('', 'Result', '', varVariant,
        Null);
    FunArgs := Args;
    Args := TArgs.Create;
    Args.hInterpreter:=Adapter.hInterpreter;

  end; { EnterFunction }

  procedure LeaveFunction(Ok: boolean);

    procedure UpdateVarParams;
    var
      i, C: Integer;
    begin
      if not Args.HasVars then Exit;
      C := Args.Count;
      Args.Obj := nil;
      Args.ObjTyp := 0;
      Args.Count := 0;
      for i := 0 to C - 1 do { Iterate }
        if (VarNames[i] <> '') and
          ((Args.Types[i] and varByRef) <> 0) then
          GetValue(VarNames[i], Args.Values[i], Args);
    end; { SetVarParams }

  var
    FC: PFunContext;
    C: Integer;
  begin
    Args.Free;
    Args := FunArgs;
    if Ok then
    begin
      C := Args.Count;
      UpdateVarParams;
      Args.Count := 0;
      if (FunDesc = nil) or (FunDesc.ResTyp > 0) then
        PFunContext(FunContext).LocalVars.GetValue('Result', FVResult, Args);
      Args.Count := C;
    end;
    FC := PFunContext(FunContext).PrevFunContext;
    PFunContext(FunContext).LocalVars.Free;
    Dispose(PFunContext(FunContext));
    Dispose(VarNames);
    FunStack.Delete(FunStack.Count - 1);
    FunContext := FC;
  end; { LeaveFunction }

begin
 { allocate stack }
  EnterFunction;
  try
    FExit := False;
    while True do
    begin
      case TTyp of { }
        ttBegin:
          begin
            Begin1;
            if (TTyp <> ttSemicolon) and not FExit then
              ErrorExpected(''';''');
            Break;
          end;
        ttVar:
          Var1(PFunContext(FunContext).LocalVars.AddVar);
        ttConst:
          Const1(PFunContext(FunContext).LocalVars.AddVar);
      else
        ErrorExpected('''' + kwBEGIN + '''');
      end; { case }
      NextToken;
    end; { while }
    LeaveFunction(True);
    FExit := False;
  except
    on E: Exception do
    begin
     { if (E is ERAI2Error) and (Fun <> nil) and
        ((E as ERAI2Error).ErrUnitName = '') then }
      if FunDesc <> nil then
        UpdateExceptionPos(E, FunDesc.UnitName)
      else
        UpdateExceptionPos(E, '');
      LeaveFunction(False);
      FExit := False;
      raise;
    end;
  end; { try/finally }
end; { InFunction1 }

function TRAI2Function.GetValue(Identifer: string; var Value: Variant;
  var Args: TArgs): Boolean;
begin
  Result := False;
 { check in local variables }
  try
    if FunContext <> nil then
      Result := PFunContext(FunContext).LocalVars.GetValue(Identifer, Value, Args);
  except
    on E: Exception do
    begin
      if Assigned(PFunContext(FunContext).Fun) then
        UpdateExceptionPos(E, PFunContext(FunContext).Fun.UnitName)
      else
        UpdateExceptionPos(E, '');
      raise;
    end;
  end;
  if not Result then
    Result := inherited GetValue(Identifer, Value, Args);
end; { GetValue }

function TRAI2Function.SetValue(Identifer: string; const Value: Variant;
  var Args: TArgs): Boolean;
begin
  Result := False;
 { check in local variables }
  try
    if FunContext <> nil then
      Result := PFunContext(FunContext).LocalVars.SetValue(Identifer, Value, Args);
  except
    on E: Exception do
    begin
      if Assigned(PFunContext(FunContext).Fun) then
        UpdateExceptionPos(E, PFunContext(FunContext).Fun.UnitName)
      else
        UpdateExceptionPos(E, '');
      raise;
    end;
  end;
  if not Result then
    Result := inherited SetValue(Identifer, Value, Args);
end; { SetValue }

procedure TRAI2Function.DoOnStatement;
begin
end;

{ exit: current position set to next token }

procedure TRAI2Function.Statement1;
begin
  DoOnStatement;
  case TTyp of { }
    ttIdentifer:
     { assignment or function call }
      begin
        Identifer1;
        if not (TTyp in [ttSemicolon, ttEnd, ttElse, ttUntil, ttFinally, ttExcept]) then
          ErrorExpected(''';''');
       // Back;
      end;
    ttSemicolon:
      ; // Back;
    ttEnd:
      ; // Back;
    ttBegin:
      Begin1;
    ttIf:
      If1;
    ttElse:
      Exit;
    ttWhile:
      While1;
    ttRepeat:
      Repeat1;
    ttFor:
      For1;
    ttBreak:
      FBreak := True;
    ttContinue:
      FContinue := True;
    ttTry:
      Try1;
    ttRaise:
      Raise1;
    ttExit:
      FExit := True;
    ttCase:
      Case1;
    else
      ErrorExpected(''';''');
  end; { case }
end; { Statement1 }

{ exit: current position set to next token }
{ very simple version, many syntax errors are not found out }

procedure TRAI2Function.SkipStatement1;
begin
  case TTyp of { }
    ttEmpty:
      ErrorExpected('''' + kwEND + '''');
    ttIdentifer:
      SkipIdentifer1;
    ttSemicolon:
      NextToken;
    ttEnd:
      NextToken;
    ttIf:
      begin
        FindToken1(ttThen);
        NextToken;
        SkipStatement1;
        if TTyp = ttElse then
        begin
          NextToken;
          SkipStatement1;
        end;
        Exit;
      end;
    ttElse:
      Exit;
    ttWhile, ttFor:
      begin
        FindToken1(ttDo);
        NextToken;
        SkipStatement1;
        Exit;
      end;
    ttRepeat:
      begin
        SkipToUntil1;
        SkipIdentifer1;
        Exit;
      end;
    ttBreak, ttContinue:
      NextToken;
    ttBegin:
      begin
        SkipToEnd1;
        Exit;
      end;
    ttTry:
      begin
        SkipToEnd1;
        Exit;
      end;
    ttFunction, ttProcedure:
      ErrorExpected('''' + kwEND + '''');
    ttRaise:
      begin
        NextToken;
        SkipIdentifer1;
      end;
    ttExit:
      NextToken;
    ttCase:
      begin
        SkipToEnd1;
        Exit;
      end;
  end; { case }
end; { SkipStatement1 }

{ out: current position set to token after end }

procedure TRAI2Function.SkipToEnd1;
begin
  while True do
  begin
    NextToken;
    if TTyp = ttEnd then
    begin
      NextToken;
      Break;
    end
    else if TTyp in [ttBegin, ttTry, ttCase] then
      SkipToEnd1
    else if TTyp = ttEmpty then
      ErrorExpected('''' + kwEND + '''')
    else
      SkipStatement1;
    if TTyp = ttEnd then
    begin
      NextToken;
      Break;
    end;
  end;
end; { SkipToEnd }

{ out: current position set to token after end }

procedure TRAI2Function.SkipToUntil1;
begin
  while True do
  begin
    NextToken;
    if TTyp = ttUntil then
    begin
      NextToken;
      Break;
    end
    else if TTyp = ttEmpty then
      ErrorExpected('''' + kwUNTIL + '''')
    else
      SkipStatement1;
    if TTyp = ttUntil then
    begin
      NextToken;
      Break;
    end;
  end;
end; { SkipToEnd }

{exit: current position set to next token after assignment or function call }

procedure TRAI2Function.SkipIdentifer1;
begin
  while True do
    case TTyp of { }
      ttEmpty:
        ErrorExpected('''' + kwEND + '''');
      ttIdentifer..ttBoolean, ttLB, ttRB, ttCol, ttPoint, ttLS, ttRS,
        ttNot..ttEquLess, ttTrue, ttFalse:
        NextToken;
      ttSemicolon, ttEnd, ttElse, ttUntil, ttFinally, ttExcept, ttDo, ttOf:
        Break;
      ttColon:
        { 'case' or assignment }
        begin
          NextToken;
          if TTyp <> ttEqu then
          begin
            Back;
            Break;
          end;
        end;
      else
        ErrorExpected(LoadStr2(irExpression))
    end; { case }
end; { SkipIdentifer1 }

procedure TRAI2Function.FindToken1(TTyp1: TTokenTyp);
begin
  while not (TTyp in [TTyp1, ttEmpty]) do
    NextToken;
  if TTyp = ttEmpty then
    ErrorExpected('''' + kwEND + '''');
end; { FindToken }

function TRAI2Function.NewEvent(const UnitName: string; const FunName,
  EventType: string; Instance: TObject): TSimpleEvent;
begin
  Result := FAdapter.NewEvent(UnitName, FunName, EventType, Self, Instance);
  if not Assigned(Result) then
    Result := GlobalRAI2Adapter.NewEvent(UnitName, FunName, EventType, Self, Instance);
  if not Assigned(Result) then
    RAI2ErrorN(ieEventNotRegistered, -1, EventType);
end; { NewEvent }


procedure TRAI2Function.InternalSetValue(const Identifer: string);
var
  FunDesc: TRAI2FunDesc;
  PropInf: PPropInfo;
  FunName: string;
  PopSt: Boolean;
  MyArgs: TArgs;
  Variable: Variant;
  Method: TMethod;
begin
  { may be event assignment }
  if (Args.Obj <> nil) and (Args.ObjTyp = varObject) then
  begin
    FunDesc := FAdapter.FindFunDesc(FCurUnitName, Token);
    if FunDesc <> nil then
    begin
      PushState;
      PopSt := True;
      try
        NextToken;
        if not (TTyp in [ttFirstExpression..ttLastExpression] - [ttSemicolon]) then
        begin
          FunName := Token;
          PropInf := GetPropInfo(Args.Obj.ClassInfo, Identifer);
          if Assigned(PropInf) and (PropInf.PropType^.Kind = tkMethod) then
          begin
           { method assignment }
            Method := TMethod(NewEvent(FCurUnitName, FunName,
              PropInf^.PropType^.Name, FCurInstance));
            SetMethodProp(Args.Obj, PropInf, Method);
            FEventList.Add(Method.Data);

            PopSt := False;
            Exit;
          end
          else
            if FAdapter.IsEvent(Args.Obj, Identifer) then { chek only local adapter }
            begin
              if not SetValue(Identifer, FunName, Args) then
                RAI2ErrorN(ieUnknownIdentifer, PosBeg, Identifer);
              PopSt := False;
              Exit;
            end;
        end;
      finally
        if PopSt then
          PopState
        else
          RemoveState;
      end;
      //Exit;
    end;
  end;
 { normal (not method) assignmnent }
 { push args }
  MyArgs := Args;
  Args := TArgs.Create;
  Args.hInterpreter:=Adapter.hInterpreter;

  try
    Args.Assignment := True;
    FVResult := Expression1;
  finally { wrap up }
   { pop args }
    Args.Free;
    Args := MyArgs;
  end; { try/finally }
  if Args.Indexed then
  begin
    MyArgs := TArgs.Create;
    MyArgs.hInterpreter:=Adapter.hInterpreter;
    try
      if GetValue(Identifer, Variable, MyArgs) then
      begin
        if not SetElement(Identifer, Variable, FVResult, Args) then
         { problem }
          RAI2Error(ieArrayRequired, PosBeg);
        if (TVarData(Variable).VType = varString) and
            not SetValue(Identifer, Variable, MyArgs) then
          RAI2ErrorN(ieUnknownIdentifer, PosBeg, Identifer);
      end
      else if not SetValue(Identifer, FVResult, Args) then
        RAI2ErrorN(ieUnknownIdentifer, PosBeg, Identifer);
    finally
      MyArgs.Free;
    end;
  end
  else if not SetValue(Identifer, FVResult, Args) then
    RAI2ErrorN(ieUnknownIdentifer, PosBeg, Identifer);
end; { InternalSetValue }

procedure TRAI2Function.Identifer1;
var
  Identifer: string;
begin
  Identifer := Token;
  Args.Clear;
  NextToken;
  if TTyp <> ttColon then
  begin
    Back;
    Args.Assignment := False;
    InternalGetValue(nil, 0, FVResult);
    Identifer := Token; { Back! }
    NextToken;
  end;
  if TTyp = ttColon then { assignment }
  begin
    NextToken;
    if TTyp <> ttEqu then
      ErrorExpected('''=''');
    NextToken;
    InternalSetValue(Identifer);
  end;
end; { Identifer1 }

{exit: current position set to next token after "end"}
procedure TRAI2Function.Begin1;
begin
  NextToken;
  while True do
  begin
    case TTyp of { }
      ttEnd:
        begin
          NextToken;
          Exit;
        end;
      ttElse, ttDo:
        ErrorExpected('statement');
      ttSemicolon:
        begin
          DoOnStatement;
          NextToken;
        end;
      ttIdentifer, ttBegin, ttIf, ttWhile, ttFor, ttRepeat,
        ttBreak, ttContinue, ttTry, ttRaise, ttExit, ttCase:
        Statement1;
      else
        ErrorExpected('''' + kwEND + '''');
    end; { case }
    if FBreak or FContinue or FExit then
      Exit;
  end;
end; { Begin1 }

{exit: current position set to next token after if block }

procedure TRAI2Function.If1;
var
  Condition: Variant;
begin
  NextToken;
  Condition := Expression2(varBoolean);
  if TTyp <> ttThen then
    ErrorExpected('''' + kwTHEN + '''');
  NextToken;
  if TVarData(Condition).VBoolean then
  begin
    Statement1;
   // NextToken; {!!!????}
    if TTyp = ttElse then
    begin
      NextToken;
      SkipStatement1;
     // Back; {!!!????}
    end;
  end
  else
  begin
    SkipStatement1;
    if TTyp = ttElse then
    begin
      NextToken;
      Statement1;
    end
   { else
    if TTyp = ttSemicolon then
    begin
      NextToken;
      if TTyp = ttElse then
        RAI2Error(ieNotAllowedBeforeElse, PosBeg)
    end; }
  end;
end; { If1 }

{exit: current position set to next token after loop }

procedure TRAI2Function.While1;
var
  WhileCurPos: Integer;
  WhilePos: Integer;
  Condition: Variant;
begin
  PushState;
  try
    WhilePos := PosEnd;
    WhileCurPos := CurPos;
    while True do
    begin
      NextToken;
      Condition := Expression1;
      if TVarData(Condition).VType <> varBoolean then
        RAI2Error(ieBooleanRequired, WhilePos);
      if TTyp <> ttDo then
        ErrorExpected('''' + kwDO + '''');
      NextToken;
      if TVarData(Condition).VBoolean then
      begin
        FContinue := False;
        FBreak := False;
        Statement1;
        if FBreak or FExit then
          Break;
      end
      else
        Break;
      CurPos := WhileCurPos;
    end; { while }
  finally
    PopState;
  end;
  SkipStatement1;
  FContinue := False;
  FBreak := False;
end; { While1 }

{exit: current position set to next token after loop }

procedure TRAI2Function.Repeat1;
var
  RepeatCurPos: Integer;
  Condition: Variant;
begin
  RepeatCurPos := CurPos;
  while True do
  begin
    NextToken;
    case TTyp of
      ttElse, ttDo:
        ErrorExpected('statement');
      ttSemicolon:
        DoOnStatement;
      ttIdentifer, ttBegin, ttIf, ttWhile, ttFor, ttRepeat,
        ttBreak, ttContinue, ttTry, ttRaise, ttExit, ttCase:
        begin
          FContinue := False;
          FBreak := False;
          Statement1;
          if FBreak or FExit then
            Break;
        end;
      ttUntil:
        begin
          NextToken;
          Condition := Expression1;
          if TVarData(Condition).VType <> varBoolean then
            RAI2Error(ieBooleanRequired, CurPos);
          if TVarData(Condition).VBoolean then
            Break
          else
            CurPos := RepeatCurPos;
        end;
    else
      ErrorExpected('''' + kwUNTIL + '''');
    end;
  end; { while }
  if FBreak or FExit then
  begin
    SkipToUntil1;
    SkipIdentifer1;
  end;
  FContinue := False;
  FBreak := False;
end; { Repeat1 }

{exit: current position set to next token after loop }
procedure TRAI2Function.For1;
var
  i: Integer;
  DoCurPos: Integer;
  iBeg, iEnd: Integer;
  LoopVariable: string;
begin
  NextToken;
  if TTyp <> ttIdentifer then
    ErrorExpected(LoadStr2(irIdentifer));
 // CheckLocalIdentifer;
  LoopVariable := Token;
  NextToken;
  if TTyp <> ttColon then
    ErrorExpected(''':''');
  NextToken;
  if TTyp <> ttEqu then
    ErrorExpected('''=''');
  NextToken;
  iBeg := Expression2(varInteger);
  if TTyp <> ttTo then
    ErrorExpected('''' + kwTO + '''');
  NextToken;
  iEnd := Expression2(varInteger);
  if TTyp <> ttDo then
    ErrorExpected('''' + kwDO + '''');
  DoCurPos := CurPos;
  NextToken;
  for i := iBeg to iEnd do { Iterate }
  begin
    Args.Clear;
    if not SetValue(LoopVariable, i, Args) then
      RAI2ErrorN(ieUnknownIdentifer, PosBeg, LoopVariable);
    FContinue := False;
    FBreak := False;
    Statement1;
    if FBreak or FExit then
    begin
      CurPos := DoCurPos;
      NextToken;
      Break;
    end;
    CurPos := DoCurPos;
    NextToken;
  end; { for }
  SkipStatement1;
  FContinue := False;
  FBreak := False;
end; { For1 }

{exit: current position set to next token after case }
procedure TRAI2Function.Case1;
var
  Selector, Expression: Integer;
begin
  NextToken;
  Selector := Expression2(varInteger);
  if TTyp <> ttOf then
    ErrorExpected('''' + kwOF + '''');
  while True do
  begin
    NextToken;
    case TTyp of
      ttIdentifer, ttInteger:
        begin
          Expression := Expression2(varInteger);
          if TTyp <> ttColon then
            ErrorExpected('''' + ':' + '''');
          NextToken;
          if Expression = Selector then
          begin
            Statement1;
            SkipToEnd1;
            Break;
          end
          else
            SkipStatement1;
        end;    
      ttElse:
        begin
          NextToken;
          Statement1;
          SkipToEnd1;
          Break;
        end;
      ttEnd:
        Break;
      else
        ErrorExpected('''' + kwEND + '''');
    end;
  end;
end;

procedure TRAI2Function.Var1(AddVarFunc: TRAI2AddVarFunc);
var
  i: Integer;
  Value: Variant;
  TypName: string;
  Typ: Word;
  {----olej----}
  {Temporary for array type}
  ArrayBegin, ArrayEnd: TRAI2ArrayValues;
  ArrayType: Integer;
  V: Variant;
  Dimension: Integer;
  Minus: Boolean;
  {----olej----}
begin
  repeat
    Typ := varEmpty;
    ArrayType := varEmpty;
    Dimension := 0;
    SS.Clear;
    repeat
      NextToken;
      if TTyp <> ttIdentifer then
        ErrorExpected(LoadStr2(irIdentifer));
      SS.Add(Token);
      NextToken;
    until TTyp <> ttCol;
    if TTyp <> ttColon then
      ErrorExpected(''':''');
    NextToken;
    TypName := Token;
    if TTyp = ttIdentifer then
      Typ := TypeName2VarTyp(TypName)
    else if TTyp = ttArray then
      Typ := varArray
    else
      ErrorExpected(LoadStr2(irIdentifer));

    {***** olej *****}
    {Get Array variables params}
    {This is code is not very clear}
    if Typ = varArray then
    begin
      NextToken;
      if TTyp <> ttLs then
        ErrorExpected('''[''');
      {Parse Array Range}
      Dimension := 0;
      repeat
        NextToken;
        Minus := False;
        if (Trim(TokenStr1) = '-') then
        begin
          Minus := True;
          NextToken;
        end;
        if Pos('..', TokenStr1) < 1 then
          ErrorExpected('''..''');
        try
          ArrayBegin[Dimension] :=
            StrToInt(Copy(TokenStr1, 1, Pos('..', TokenStr1) - 1));
          ArrayEnd[Dimension] :=
            StrToInt(Copy(TokenStr1, Pos('..', TokenStr1) + 2, Length(TokenStr1)));
          if Minus then ArrayBegin[Dimension] := ArrayBegin[Dimension] * (-1);
        except
          ErrorExpected('''Integer Value''');
        end;
        if (Dimension < 0) or (Dimension > MaxArgs) then
          RAI2Error(ieArrayBadDimension, CurPos);
        if not (ArrayBegin[Dimension] <= ArrayEnd[Dimension]) then
          RAI2Error(ieArrayBadRange, CurPos);
      {End Array Range}
        NextToken;
        Inc(Dimension);
      until TTyp <> ttCol; { , }

      if TTyp <> ttRs then
        ErrorExpected(''']''');
      NextToken;
      if TTyp <> ttOf then
        ErrorExpected('''' + kwOF + '''');
      NextToken;
      ArrayType := TypeName2VarTyp(Token);
      if ArrayType = varEmpty then
        ErrorNotImplemented(Token + ' array type');
    end;
    {end: var A:array[1..200] of integer, parsing}
    {##### olej #####}
    for i := 0 to SS.Count - 1 do { Iterate }
    begin
      Value := Null;
      TVarData(Value).VType := varEmpty;
     { may be record }
      if not FAdapter.NewRecord(TypName, Value) then
        GlobalRAI2Adapter.NewRecord(TypName, Value);
      {***** olej *****}
      {Create array with arrayType}
      if Typ = varArray then
      begin
        V := Integer(RAI2ArrayInit(Dimension, ArrayBegin, ArrayEnd, ArrayType));
        TVarData(V).VType := varArray;
        AddVarFunc(FCurUnitName, SS[i], TypName, varArray, V);
      end
      else
      begin
        if (TVarData(Value).VType = varEmpty) and (Typ <> 0) then
          Value := Var2Type(Value, Typ);
        AddVarFunc(FCurUnitName, SS[i], TypName, Typ, Value);
      end;
     {end - array is allocated}
     {##### olej #####}
    end;
    SS.Clear;
    NextToken;
    if TTyp <> ttSemicolon then
      ErrorExpected(''';''');
    NextToken;
    Back;
  until TTyp <> ttIdentifer;
end; { Var1 }

procedure TRAI2Function.Const1(AddVarFunc: TRAI2AddVarFunc);
var
  Identifer: string;
  Value: Variant;
begin
  repeat
    NextToken;
    if TTyp <> ttIdentifer then
      ErrorExpected(LoadStr2(irIdentifer));
    Identifer := Token;
    NextToken;
    if TTyp <> ttEqu then
      ErrorExpected('=');
    NextToken;
    Value := Expression1;

    AddVarFunc(FCurUnitName, Identifer, '', varEmpty, Value);
    if TTyp <> ttSemicolon then
      ErrorExpected(''';''');
    NextToken;
    Back;
  until TTyp <> ttIdentifer;
end; { Const1 }

procedure TRAI2Function.Try1;

var
  ReRaiseException: Boolean;

  procedure FindFinallyExcept;
  begin
    while True do
    begin
      case TTyp of { }
        ttEmpty:
          ErrorExpected('''' + kwEND + '''');
        ttSemicolon: ;
        ttFinally, ttExcept:
          Exit;
      else
        SkipStatement1;
      end;
      NextToken;
    end;
  end; { FindFinallyExcept }

  procedure Except1(E: Exception);
  var
    ExceptionClassName, ExceptionVarName: string;
    ExceptionClass: TClass;
    V: Variant;

    function On1: boolean;
    begin
      NextToken;
      if TTyp <> ttIdentifer then
        ErrorExpected(LoadStr2(irIdentifer));
      ExceptionClassName := Token;
      NextToken;
      if TTyp = ttColon then
      begin
        NextToken;
        if TTyp <> ttIdentifer then
          ErrorExpected(LoadStr2(irIdentifer));
        ExceptionVarName := ExceptionClassName;
        ExceptionClassName := Token;
        NextToken;
      end;
      Args.Clear;
      if not GetValue(ExceptionClassName, V, Args) then
        RAI2ErrorN(ieUnknownIdentifer, PosBeg {?}, ExceptionClassName);
      if VarType(V) <> varClass then
        RAI2Error(ieClassRequired, PosBeg {?});
      ExceptionClass := V2C(V);
      if TTyp <> ttDo then
        ErrorExpected('''' + kwDO + '''');
      Result := E is ExceptionClass;
      if Result then
       { do this 'on' section }
      begin
        NextToken;
        PFunContext(FunContext).LocalVars.AddVar('', ExceptionVarName,
          ExceptionClassName, varObject, O2V(E));
        try
          Statement1;
        finally { wrap up }
          PFunContext(FunContext).LocalVars.DeleteVar('', ExceptionVarName);
        end; { try/finally }
        SkipToEnd1;
      end
      else
      begin
        NextToken;
        SkipStatement1;
       { if TTyp = ttSemicolon then
          NextToken; }
      end;
    end; { On1 }

  begin
    NextToken;
    if TTyp = ttOn then
    begin
      if On1 then
      begin
        ReRaiseException := False;
        Exit;
      end;
      while True do
      begin
        NextToken;
        case TTyp of { }
          ttEmpty:
            ErrorExpected('''' + kwEND + '''');
          ttOn:
            if On1 then
            begin
              ReRaiseException := False;
              Exit;
            end;
          ttEnd:
            begin
              ReRaiseException := True;
              Exit;
            end;
          ttElse:
            begin
              NextToken;
              Statement1;
              NextToken;
              if TTyp = ttSemicolon then
                NextToken;
              if TTyp <> ttEnd then
                ErrorExpected('''' + kwEND + '''');
              Exit;
            end;
        else
          ErrorExpected('''' + kwEND + '''');
        end; { case }
      end; { while }
    end
    else
    begin
      Back;
      Begin1;
    end;
  end; { Except1 }

  procedure DoFinallyExcept(E: Exception);
  begin
    case TTyp of { }
      ttFinally:
       { do statements up to 'end' }
        begin
          Begin1;
          if E <> nil then
          begin
            ReRaiseException := True;
          end;
        end;
      ttExcept:
        begin
          if E = nil then
           { skip except section }
            SkipToEnd1
          else
           { except section }
          begin
            try
              Except1(E);
            except
              on E1: ERAI2Error do
                if E1.ErrCode = ieRaise then
                  ReRaiseException := True;
                else
                  raise;
            end;
          end;
        end;
    end;
  end; { DoFinallyExcept }

begin
  while True do
  begin
    NextToken;
    case TTyp of { }
      ttFinally:
        begin
          DoFinallyExcept(nil);
          Exit;
        end;
      ttExcept:
        begin
          DoFinallyExcept(nil);
          Exit;
        end;
      ttSemicolon:
        DoOnStatement;
      ttIdentifer, ttBegin, ttIf, ttWhile, ttFor, ttRepeat,
        ttBreak, ttContinue, ttTry, ttRaise, ttExit, ttCase:
        begin
          try
            Statement1;
            if FBreak or FContinue or FExit then
            begin
              FindFinallyExcept;
              DoFinallyExcept(nil);
              Exit;
            end;
          except
            on E: Exception do
            begin
              FindFinallyExcept;

              ReRaiseException := False;
              DoFinallyExcept(E);

              if ReRaiseException then
                raise
              else
                Exit;
            end;
          end; { try/finally }
        end;
    else
      ErrorExpected('''' + kwFINALLY + '''');
    end; { case }
  end;
end; { Try1 }

procedure TRAI2Function.Raise1;
var
  V: Variant;
begin
  NextToken;
  case TTyp of
    ttEmpty, ttSemicolon, ttEnd, ttBegin, ttElse, ttFinally, ttExcept:
     { re-raising exception }
      raise ERAI2Error.Create(ieRaise, PosBeg, '', '');
    ttIdentifer:
      begin
        InternalGetValue(nil, 0, V);
        if VarType(V) <> varObject then
          RAI2Error(ieClassRequired, PosBeg {?});
        raise V2O(V);
      end;
  else
    RAI2Error(ieClassRequired, PosBeg {?});
  end;
end; { Raise1 }

procedure TRAI2Function.Run;
begin
  Init;
  NextToken;
  InFunction1(nil);
end; { Run }


{************************ TRAI2Unit **************************}

constructor TRAI2Unit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FClearUnits := True;
  FEventHandlerList := TList.Create;
end; { Create }

destructor TRAI2Unit.Destroy;
begin
  ClearList(FEventHandlerList);
  FEventHandlerList.Free;
  inherited Destroy;
end; { Destroy }

procedure TRAI2Unit.Init;
begin
  inherited Init;
  if FClearUnits then
  begin
    FAdapter.ClearSource;
    FUnitSection := usUnknown;
    ClearList(FEventHandlerList);
  end;
end; { Init }

procedure TRAI2Unit.ReadFunHeader(FunDesc: TRAI2FunDesc);
var
  TypName: string;

  procedure ReadParams;
  var
    VarParam, ConstParam, OutParam: boolean;
    ParamType: string;
    iBeg: integer;
  begin
    while True do
    begin
      VarParam := False;
      ConstParam:=False;
      OutParam:=false;
      NextToken;
      FunDesc.FParamNames[FunDesc.ParamCount] := Token;
      if TTyp = ttRB then
        Break;
      if TTyp = ttVar then
      begin
        VarParam := True;
        NextToken;
      end;
      if TTyp = ttConst then begin
        ConstParam := True;
        NextToken;
      end;
      if TTyp = ttOut then begin
        OutParam := True;
        NextToken;
      end;
    {  if TTyp = ttConst then
        NextToken; }
      iBeg := FunDesc.ParamCount;
      while True do
      begin
        case TTyp of
          ttIdentifer:
            FunDesc.FParamNames[FunDesc.ParamCount] := Token;
          ttSemicolon: Break;
          ttRB: Exit;
          ttColon:
            begin
              NextToken;
              if TTyp <> ttIdentifer then
                ErrorExpected(LoadStr2(irIdentifer));
              ParamType := Token;
              while True do
              begin
                if TTyp = ttRB then
                  Back;
                if TTyp in [ttRB, ttSemicolon] then
                  Break;
                NextToken;
              end; { while }
              inc(FunDesc.FParamCount);
              while iBeg < FunDesc.FParamCount do
              begin
                FunDesc.FParamTypes[iBeg] := TypeName2VarTyp(ParamType);
                FunDesc.FParamPrefixes[iBeg]:='';
                if VarParam then
                  FunDesc.FParamPrefixes[iBeg]:=kwVar;
                if ConstParam then
                  FunDesc.FParamPrefixes[iBeg]:=kwCONST;
                if OutParam then
                  FunDesc.FParamPrefixes[iBeg]:=kwOUT;

                if VarParam then
                  FunDesc.FParamTypes[iBeg] := FunDesc.FParamTypes[iBeg] or varByRef;
                inc(iBeg);
              end;
              Break;
            end;
          ttCol:
            inc(FunDesc.FParamCount);
        end;
        NextToken;
      end; { while }
    end; { while }
  end;

var
  Fun: boolean;
begin
  Fun := TTyp = ttFunction;
  NextToken;
  if TTyp <> ttIdentifer then
    ErrorExpected(LoadStr2(irIdentifer));
  FunDesc.FIdentifer := Token;
  NextToken;
  if TTyp = ttPoint then
  begin
    FunDesc.FClassIdentifer := FunDesc.FIdentifer;
    NextToken;
    if TTyp <> ttIdentifer then
      ErrorExpected(LoadStr2(irIdentifer));
    FunDesc.FIdentifer := Token;
    NextToken;
  end;
  FunDesc.FResTyp := varEmpty;
  FunDesc.FParamCount := 0;
  if TTyp = ttLB then
  begin
   //  NextToken;
    ReadParams;
    NextToken;
  end;
  if Fun then
    if (TTyp = ttColon) then
    begin
      NextToken;
      if TTyp <> ttIdentifer then
        ErrorExpected(LoadStr2(irIdentifer));
      TypName := Token;
      FunDesc.FResTyp := TypeName2VarTyp(TypName);
      if FunDesc.FResTyp = 0 then
        FunDesc.FResTyp := varVariant;
      NextToken;
    end
    else
      ErrorExpected(''':''');
  if TTyp <> ttSemicolon then
    ErrorExpected(''';''');
end; { ReadFunHeader }

procedure TRAI2Unit.Function1;
var
  FunDesc: TRAI2FunDesc;
  FunName: string;
  FunIndex: integer;
  DllName: string;
  LastTTyp:TTokenTyp; // Ivan_ra
begin
  FunDesc := TRAI2FunDesc.Create;
  try
    ReadFunHeader(FunDesc);
    FunDesc.FPosBeg := CurPos;
    LastTTyp:=TTyp; // Ivan_ra
    NextToken;
    if TTyp = ttExternal then
    begin
      NextToken;
      if TTyp = ttString then
        DllName := Token
      else if TTyp = ttIdentifer then
      begin
        Args.Clear;
        if not GetValue(Token, FVResult, Args) then
          RAI2ErrorN(ieUnknownIdentifer, PosBeg, Token);
        DllName := vResult;
      end
      else
        ErrorExpected('''string constant'''); {DEBUG!!!}
      NextToken;
      if TTyp <> ttIdentifer then
        ErrorExpected('''name'' or ''index''');
      FunIndex := -1;
      FunName := '';
      if Cmp(Token, 'name') then
      begin
        NextToken;
        if TTyp = ttString then
          FunName := Token
        else
          ErrorExpected('''string constant'''); {DEBUG!!!}
      end
      else
        if Cmp(Token, 'index') then
        begin
          NextToken;
          if TTyp = ttInteger then
            FunIndex := Token
          else
            ErrorExpected('''integer constant'''); {DEBUG!!!}
        end
        else
          ErrorExpected('''name'' or ''index''');
      with FunDesc do
        FAdapter.AddExtFun(FCurUnitName {??!!}, FIdentifer, noInstance, DllName,
          FunName, FunIndex, FParamCount, FParamTypes, FResTyp);
      NextToken;
    end
    // Ivan_ra start
    else
    if FUnitSection = usInterface then begin
      CurPos:=FunDesc.FPosBeg;
      TTyp1:=LastTTyp;
    end
    // Ivan_ra finish
    else
    begin
      FindToken1(ttBegin);
      SkipToEnd1;
      with FunDesc do
        FAdapter.AddSrcFun(FCurUnitName {??!!}, FIdentifer, FPosBeg, CurPos,
          FParamCount, FParamTypes, FParamNames, FResTyp, nil);
    end;
  finally
    FunDesc.Free;
  end;
end; { Function1 }

procedure TRAI2Unit.ReadUnit(const UnitName: string);
var
  OldUnitName: string;
  OldSource: string;
  S: string;
begin
  if FAdapter.UnitExists(UnitName) then Exit;
  FAdapter.AddSrcUnit(FCurUnitName, '', '');
  OldUnitName := FCurUnitName;
  OldSource := Source;
  PushState;
  try
    try
      if not GetUnitSource(UnitName, S) then
        RAI2ErrorN(ieUnitNotFound, PosBeg, UnitName);
      FCurUnitName := UnitName;
      Source := S;
      NextToken;
      if TTyp <> ttUnit then
        ErrorExpected('''' + kwUNIT + '''');
      Unit1;
    except
      on E: Exception do
      begin
        UpdateExceptionPos(E, FCurUnitName);
        raise;
      end;
    end
  finally { wrap up }
    FCurUnitName := OldUnitName;
    Source := OldSource;
    PopState;
  end; { try/finally }
end; { ReadUnit }

procedure TRAI2Unit.Uses1(var UsesList: string);
begin
  NextToken;
  if not (TTyp in [ttIdentifer, ttString]) then
    ErrorExpected(LoadStr2(irIdentifer));
  UsesList := Token;
  ReadUnit(Token);
  while True do
  begin
    NextToken;
    if TTyp = ttIn then
    begin
      { ignore }
      NextToken;
      NextToken;
    end;
    if TTyp = ttSemicolon then
      Exit;
    if TTyp <> ttCol then
      ErrorExpected(''',''');
    NextToken;
    if not (TTyp in [ttIdentifer, ttString]) then
      ErrorExpected(LoadStr2(irIdentifer));
    UsesList := UsesList + ',';
    ReadUnit(Token);
  end; { while }
end; { Uses1 }

procedure TRAI2Unit.Unit1;
var
  UsesList: string;
begin
  NextToken;
  if TTyp <> ttIdentifer then
    ErrorExpected(LoadStr2(irIdentifer));
  FCurUnitName := Token;
  NextToken;
  if TTyp <> ttSemicolon then
    ErrorExpected(''';''');
  UsesList := '';
  NextToken;
  while True do
  begin
    case TTyp of { }
      ttEmpty:
        ErrorExpected('''' + kwEND + '''');
      ttFunction, ttProcedure:
        begin
          Function1;
          if TTyp <> ttSemicolon then
            ErrorExpected(''';''');
        end;
      ttEnd:
        Break;
      ttUses:
        Uses1(UsesList);
      ttVar:
        Var1(FAdapter.AddSrcVar);
      ttConst:
        Const1(FAdapter.AddSrcVar);
      ttInterface:
        FUnitSection := usInterface;
      ttImplementation:
        FUnitSection := usImplementation;
      ttType:
        Type1;
      else
        ErrorExpected(LoadStr2(irDeclaration));
    end; { case }
    NextToken;
  end; { while }
  if TTyp <> ttEnd then
    ErrorExpected('''' + kwEND + '''');
  NextToken;
  if TTyp <> ttPoint then
    ErrorExpected('''.''');
  FAdapter.AddSrcUnit(FCurUnitName, Source, UsesList);
end; { Unit1 }

procedure TRAI2Unit.Type1;
var
  Identifer: string;
begin
  NextToken;
  if TTyp <> ttIdentifer then
    ErrorExpected(LoadStr2(irIdentifer));
  Identifer := Token;
  NextToken;
  if TTyp <> ttEqu then
    ErrorExpected('''=''');
  NextToken;
  case TTyp of
    ttClass:
      Class1(Identifer);
    else
     { only class declaration for form is supported }
      ErrorExpected(LoadStr2(irClass));
  end;
end;

procedure TRAI2Unit.Class1(const Identifer: string);
var
  RAI2SrcClass: TRAI2Identifer;
begin
  NextToken;
  if TTyp <> ttLB then
    ErrorExpected('''(''');
  NextToken;
  if TTyp <> ttIdentifer then
    ErrorExpected(LoadStr2(irIdentifer));
  NextToken;
  if TTyp <> ttRB then
    ErrorExpected(''')''');
  FindToken1(ttEnd);
  NextToken;
  if TTyp <> ttSemicolon then
    ErrorExpected(''';''');
  RAI2SrcClass := TRAI2Identifer.Create;
  RAI2SrcClass.UnitName := FCurUnitName;
  RAI2SrcClass.Identifer := Identifer;
  FAdapter.AddSrcClass(RAI2SrcClass);
end;

function TRAI2Unit.GetMainFunction: TRAI2FunDesc;
begin
  Result:=nil;
end;

procedure TRAI2Unit.Run;
var
  FunDesc: TRAI2FunDesc;
begin
  Init;
  NextToken;
  case TTyp of { }
    ttVar, ttBegin:
      InFunction1(nil);
    ttFunction, ttProcedure:
      Function1;
    ttUnit:
      begin
        try
          Unit1;
        except
          on E: Exception do
          begin
            UpdateExceptionPos(E, FCurUnitName);
            raise;
          end;
        end;
        FCompiled := True;
       { execute main function }
        FunDesc := GetMainFunction;
        if FunDesc = nil then
          RAI2Error(ieMainUndefined, -1);
        CurPos := FunDesc.PosBeg;
        NextToken;
        Args.Clear;
        InFunction1(FunDesc);
      end;
    else
      FVResult := Expression1;
  end; { case }
  FCompiled := True;
end; { Run }

procedure TRAI2Unit.Compile;
begin
  Init;
  try
    NextToken;
    if TTyp <> ttUnit then
      ErrorExpected('''' + kwUNIT + '''');
    Unit1;
  except
    on E: Exception do
    begin
      UpdateExceptionPos(E, FCurUnitName);
      raise;
    end;
  end;
  FCompiled := True;
end; { Compile }

procedure TRAI2Unit.SourceChanged;
begin
  inherited SourceChanged;
end; { SourceChanged }

function TRAI2Unit.GetValue(Identifer: string; var Value: Variant;
  var Args: TArgs): Boolean;
var
  FunDesc: TRAI2FunDesc;
  OldArgs: TArgs;
begin
  Result := inherited GetValue(Identifer, Value, Args);
  if Result then Exit;
  if Args.Obj = nil then
    FunDesc := FAdapter.FindFunDesc(FCurUnitName, Identifer)
  else begin
   if (Args.Obj is TClass) then FunDesc := nil
   else if (Args.Obj is TRAI2SrcUnit) then  FunDesc := FAdapter.FindFunDesc((Args.Obj as TRAI2SrcUnit).Identifer,Identifer)
   else FunDesc := nil;
  end;  

  Result := FunDesc <> nil;
  if Result then
  begin
    FAdapter.CheckArgs(Args, FunDesc.FParamCount, FunDesc.FParamTypes); {not tested !}
    OldArgs := Self.Args;
    try
      Self.Args := Args;
      ExecFunction(FunDesc);
    finally
      Self.Args := OldArgs;
    end;
    Value := FVResult;
  end;
end; { GetValue }

function TRAI2Unit.SetValue(Identifer: string; const Value: Variant;
  var Args: TArgs): Boolean;
begin
  Result := inherited SetValue(Identifer, Value, Args);
end; { SetValue }

function TRAI2Unit.GetUnitSource(UnitName: string; var Source: string): boolean;
begin
  Result := False;
  if Assigned(FOnGetUnitSource) then
    FOnGetUnitSource(UnitName, Source, Result);
end; { GetUnitSource }

procedure TRAI2Unit.DeclareExternalFunction(const Declaration: string);
var
  OldSource: string;
  OldPos: integer;
begin
  Source := Declaration;
  OldSource := Source;
  OldPos := Parser.Pos;
  try
    NextToken;
    if not (TTyp in [ttFunction, ttProcedure]) then
      ErrorExpected('''' + kwFUNCTION + ''' or ''' + kwPROCEDURE + '''');
    Function1;
  finally { wrap up }
    Source := OldSource;
    Parser.Pos := OldPos;
  end; { try/finally }
end; { DeclareExternalFunction }

procedure TRAI2Unit.ExecFunction(Fun: TRAI2FunDesc);
var
  OldUnitName: string;
  S: string;
begin
  PushState;
  AllowAssignment := True;
  OldUnitName := FCurUnitName;
  try
    if not Cmp(FCurUnitName, Fun.UnitName) then
    begin
      FCurUnitName := Fun.UnitName;
      FAdapter.CurUnitChanged(FCurUnitName, S);
      Source := S;
    end;
    CurPos := Fun.PosBeg;
    NextToken;
//    try
      InFunction1(Fun);
{    except
      on E: Exception do
      begin
        UpdateExceptionPos(E, FCurUnitName);
        raise;
      end;
    end;  }
  finally { wrap up }
    if not Cmp(FCurUnitName, OldUnitName) then
    begin
      FCurUnitName := OldUnitName;
      FAdapter.CurUnitChanged(FCurUnitName, S);
      Source := S;
    end;
    PopState;
  end; { try/finally }
end; { ExecFunction }

function TRAI2Unit.CallFunction(const FunName: string; Args: TArgs;
  Params: array of Variant): Variant;
begin
  Result := CallFunctionEx(nil, '', FunName, Args, Params);
end; { CallFunction }

{function TRAI2Unit.CallFunctionEx(Instance: TObject; const UnitName: string;
  const FunName: string; Args: TArgs; Params: array of Variant): Variant;}
function TRAI2Unit.CallFunctionEx(Instance: TObject; const UnitName: string;
  const FunName: string; Args: TArguments; Params: array of Variant): Variant;
var
  FunDesc: TRAI2FunDesc;
  i,ls: Integer;
  OldArgs: TArgs;
  OldInstance: TObject;
begin
  if not FCompiled then Compile;
  OldInstance := FCurInstance;
  try
    FCurInstance := Instance;
    FunDesc := FAdapter.FindFunDesc(UnitName, FunName);
    if FunDesc <> nil then
    begin
      OldArgs := Self.Args;
      if Args = nil then
      begin
        Self.Args.Clear;
        for i := Low(Params) to High(Params) do { Iterate }
        begin
          Self.Args.Values[Self.Args.Count] := Params[i];
          inc(Self.Args.Count);
        end; { for }
      end
      else begin
        Self.Args.Clear;
        ls:=Low(Args.Values);
        for i := ls to ls+Args.Count-1 do { Iterate }
        begin
          Self.Args.Values[Self.Args.Count] := Args.Values[i];
          inc(Self.Args.Count);
        end; { for }
      end;
      try
       { simple init }
        FBreak := False;
        FContinue := False;
        FLastError.Clear;

        ExecFunction(FunDesc);

        Result := FVResult;
      finally
        ls:=Low(Self.Args.Values);
        for i := ls to ls+Self.Args.Count-1 do { Iterate }
        begin
          Args.Values[i] := Self.Args.Values[i];
        end; { for }
        Self.Args := OldArgs;
      end;
    end
    else
      RAI2ErrorN(ieUnknownIdentifer, -1, FunName);
  finally
    FCurInstance := OldInstance;
  end;
end; { CallFunctionEx }

function TRAI2Unit.FunctionExists(const UnitName: string; const FunName: string)
  : boolean;
begin
  Result := FAdapter.FindFunDesc(UnitName, FunName) <> nil;
end; { FunctionExists }

{######################## TRAI2Unit ##########################}


{*********************** TRAI2Program ***********************}

type
  TRAI2ProgramStrings = class(TStringList)
  private
    FRAI2Program: TRAI2Program;
  protected
    procedure Changed; override;
  end;

procedure TRAI2ProgramStrings.Changed;
begin
  FRAI2Program.Source := Text;
end;

constructor TRAI2Program.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPas := TRAI2ProgramStrings.Create;
  (FPas as TRAI2ProgramStrings).FRAI2Program := Self;
end; { Create }

destructor TRAI2Program.Destroy;
begin
  FPas.Free;
  inherited Destroy;
end; { Destroy }

procedure TRAI2Program.SetPas(Value: TStrings);
begin
  FPas.Assign(Value);
end;

procedure TRAI2Program.DoOnStatement;
begin
  if Assigned(FOnStatement) then
    FOnStatement(Self);
end;

procedure TRAI2Program.Run;
{var
  UsesList: string;}
begin
{  if AnsiStrLIComp(PChar(Parser.Source), 'program ', Length('program ')) <> 0 then
  begin}
{    Parser.Source:='unit Main; '+#13#10+
                   Parser.Source+#13#10+
                   'end.';}
    inherited Run;
    Exit;
//  end;
(*  Init;
  NextToken;
  while True do
  begin
    case TTyp of { }
      ttEmpty:
        ErrorExpected('''' + kwEND + '''');
      ttFunction, ttProcedure:
        begin
          Function1;
          if TTyp <> ttSemicolon then
            ErrorExpected(''';''');
        end;
      ttEnd:
        Break;
      ttUses:
        Uses1(UsesList);
      ttVar:
        Var1(FAdapter.AddSrcVar);
      ttConst:
        Const1(FAdapter.AddSrcVar);
      ttInterface:
        FUnitSection := usInterface;
      ttImplementation:
        FUnitSection := usImplementation;
      ttType:
        Type1;
      ttProgram:
        begin
          NextToken;
          FCurUnitName := Token;
          NextToken;
          if TTyp <> ttSemicolon then
            ErrorExpected(''';''');
        end;
      ttBegin:
        Break;
      else
        ErrorExpected('''' + kwEND + '''');
    end; { case }
    NextToken;
  end;
  FCompiled := True;
  FAdapter.AddSrcUnit(FCurUnitName, Source, UsesList);
 { execute program function }
{  FunDesc := FAdapter.FindFunDesc(FCurUnitName, 'program');
  if FunDesc <> nil then
  begin
    CurPos := FunDesc.PosBeg;
    NextToken;
    InFunction1(FunDesc);
  end; }
  try
    Begin1;
    if (TTyp <> ttPoint) then
      ErrorExpected('''.''');
  except
    on E: Exception do
    begin
      UpdateExceptionPos(E, FCurUnitName);
      raise;
    end;
  end;*)
end; { Run }


{$IFDEF RAI2_OLEAUTO}
var
  OleInitialized: Boolean;
{$ENDIF RAI2_OLEAUTO}
{ TRAI2FunDesc }

initialization
  GlobalRAI2Adapter := TRAI2Adapter.Create(nil);
{$IFDEF RAI2_OLEAUTO}
  OleInitialized := OleInitialize(nil) = S_OK;
{$ENDIF RAI2_OLEAUTO}
finalization
{$IFDEF RAI2_OLEAUTO}
  if OleInitialized then OleUnInitialize;
{$ENDIF RAI2_OLEAUTO}
{$IFDEF RAI2_DEBUG}
  if ObjCount <> 0 then
    Windows.MessageBox(0, PChar('Memory leak in RAI2.pas'#13 +
      'ObjCount = ' + IntToStr(ObjCount)),
      'RAI2 Internal Error', MB_ICONERROR); 
{$ENDIF}
  GlobalRAI2Adapter.Free;
end.


