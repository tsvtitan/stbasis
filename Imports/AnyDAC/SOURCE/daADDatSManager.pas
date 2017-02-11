{-------------------------------------------------------------------------------}
{ AnyDAC Local Data Storage classes                                             }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit daADDatSManager;

interface

uses
  Windows, Classes,
  daADStanIntf, daADStanError, daADStanUtil;

type
  TADDatSObject = class;
  TADDatSObjectClass = class of TADDatSObject;
  TADDatSNamedObject = class;
  TADDatSList = class;
  TADDatSNamedList = class;
  TADDatSColumn = class;
  TADDatSColumnList = class;
  TADDatSColumnSublist = class;
  TADDatSConstraintBase = class;
  TADDatSConstraintList = class;
  TADDatSUniqueConstraint = class;
  TADDatSForeignKeyConstraint = class;
  TADDatSCheckConstraint = class;
  TADDatSRelation = class;
  TADDatSRelationList = class;
  TADDatSMechBase = class;
  TADDatSViewMechList = class;
  TADDatSMechSort = class;
  TADDatSMechRowState = class;
  TADDatSMechRange = class;
  TADDatSMechFilter = class;
  TADDatSMechError = class;
  TADDatSMechDetails = class;
  TADDatSMechChilds = class;
  TADDatSMechMaster = class;
  TADDatSMechParent = class;
  TADDatSRow = class;
  TADDatSRowListBase = class;
  TADDatSNestedRowList = class;
  TADDatSTableRowList = class;
  TADDatSViewRowList = class;
  TADDatSView = class;
  TADDatSViewList = class;
  TADDatSAggregateValue = class;
  TADDatSAggregate = class;
  TADDatSAggregateList = class;
  TADDatSTable = class;
  TADDatSTableList = class;
  TADDatSUpdatesJournal = class;
  TADDatSManager = class;
  IADDataTableCallback = interface;

  TADDatSNotificationKind = (
    snObjectInserting, snObjectInserted, snObjectRemoving, snObjectRemoved,
    snColumnDefChanged, snObjectNameChanged, snMechanismStateChanged,
    snViewUpdated, snRowStateChanged, snRowErrorStateChanged, snRowDataChanged);
  TADDatSNotificationReason = (srMetaChange, srDataChange);

  TADDatSColumnThings = set of (ctCalcs, ctExps, ctDefs, ctInvars, ctComp);

  TADDatSColumnsCalculateEvent = procedure (ARow: TADDatSRow) of object;

  TADDatSMechanismKind = (mkFilter, mkSort, mkHasList, mkHasRow);
  TADDatSMechanismKinds = set of TADDatSMechanismKind;

  TADDatSRowVersion = (rvDefault, rvCurrent, rvOriginal, rvPrevious, rvProposed);
  TADDatSRowState = (
    rsInitializing,
    rsDetached, rsInserted, rsDeleted, rsModified, rsUnchanged,
    rsEditing, rsCalculating, rsChecking, rsDestroying, rsForceWrite,
    rsImportingCurent, rsImportingOriginal, rsImportingProposed);
  TADDatSRowStates = set of TADDatSRowState;

  TADDatSProcessNestedRowsMethod = procedure (ARow: TADDatSRow) of object;

  TADDatSConstraintRule = (crCascade, crRestrict, crNullify);
  TADDatSConstraintARRule = (arNone, arCascade);

  TADDatSMergeOption = (goNone);
  TADDatSMergeOptions = set of TADDatSMergeOption;

  TADDatSViewState = (vsOutdated);
  TADDatSViewStates = set of TADDatSViewState;

  TADDatSViewCreator = (
    vcUser,
    vcUniqueConstraint, vcForeignKeyConstraint, vcChildRelation,
      vcDefaultView, vcErrorView, vcChangesView, vcSelectView,
    vcDataSetIndex, vcDataSetTempIndex, vcDataSetFilter, vsDataSetDelta);

  TADDatSViewProcessRowStatus = (psAccepted, psRejected, psUnchanged);
  TADDatSViewUpdateInfoKind = (vuRowAdded, vuRowChanged, vuRowDeleted);
  PDEDataViewUpdateInfo = ^TADDatSViewUpdateInfo;
  TADDatSViewUpdateInfo = record
    FKind: TADDatSViewUpdateInfoKind;
    FIndex: Integer;
    FOldIndex: Integer;
    FRow: TADDatSRow;
  end;

  TADDatSGroupPosition = (gpFirst, gpMiddle, gpLast);
  TADDatSGroupPositions = set of TADDatSGroupPosition;

  TADSortOption = (soNoCase, soNullLess, soDescending, soUnique, soPrimary);
  TADSortOptions = set of TADSortOption;

  TADLocateOption = (loPartial, loNearest, loNoCase, loLast, loExcludeKeyRow,
    loUseRowID);
  TADLocateOptions = set of TADLocateOption;

  TADCompareRowsProc = function (ARow1, ARow2: TADDatSRow;
    AColumnCount: Integer; AOptions: TADCompareDataOptions): Integer of object;

  TADFilterRowEvent = function (AMech: TADDatSMechFilter; ARow: TADDatSRow;
    AVersion: TADDatSRowVersion): Boolean of object;

  TADDatSHandleMode = (lmNone, lmMove, lmHavyMove, lmFetching,
    lmHavyFetching, lmDestroying, lmRefreshing);

  TADDatSCheckTime = (ctAtEditEnd, ctAtColumnChange);

  TADDatSRefCounter = class(TObject)
  private
    FRefs: Integer;
    FOwner: TObject;
  public
    constructor Create(AOwner: TObject);
    destructor Destroy; override;
    procedure CountRef(AInit: Integer = 1);
    procedure AddRef;
    procedure RemRef;
    property Refs: Integer read FRefs;
  end;

  TADDatSNotifyParam = record
    FKind: TADDatSNotificationKind;
    FReason: TADDatSNotificationReason;
    FParam1, FParam2: LongWord;
  end;
  PDEDatSNotifyParam = ^TADDatSNotifyParam;

  PDEDataObject = ^TADDatSObject;
  TADDatSObject = class (TObject)
  private
    FOwner: TADDatSObject;
    FLockNotificationCount: Word;
    // following fields must be in TADDatSRow, but moved
    // here to pack FLockNotificationCount, FRowPriorState and
    // FRowState into double word
    FRowPriorState: TADDatSRowState;
    FRowState: TADDatSRowState;
  protected
    function GetList: TADDatSList; virtual;
    function GetOwnerByClass(AClass: TADDatSObjectClass): TADDatSObject;
    function GetManager: TADDatSManager; virtual;
    function GetTable: TADDatSTable; virtual;
    procedure HandleNotification(AParam: PDEDatSNotifyParam); virtual;
    procedure Notify(AParam: PDEDatSNotifyParam); overload; virtual;
    procedure Notify(AKind: TADDatSNotificationKind;
      AReason: TADDatSNotificationReason; AParam1, AParam2: LongWord); overload;
    procedure LockNotification;
    procedure UnlockNotification;
    procedure DoListInserted; virtual;
    procedure DoListInserting; virtual;
    procedure DoListRemoved(ANewOwner: TADDatSObject); virtual;
    procedure DoListRemoving; virtual;
    function GetIndex: Integer; virtual;
  public
    constructor Create; overload; virtual;
    destructor Destroy; override;
    procedure Assign(AObj: TADDatSObject); virtual;
    function IsEqualTo(AObj: TADDatSObject): Boolean; virtual;
    function IndexOf(AObj: TADDatSObject): Integer; overload; virtual;
    property Index: Integer read GetIndex;
    property Owner: TADDatSObject read FOwner;
    property List: TADDatSList read GetList;
    property Manager: TADDatSManager read GetManager;
    property Table: TADDatSTable read GetTable;
  end;

  TADDatSNamedObject = class (TADDatSObject)
  private
    FName: String;
    FPrevName: String;
    function GetNamedList: TADDatSNamedList;
    procedure SetName(const AValue: String);
    procedure SetDefaultName;
  protected
    property PrevName: String read FPrevName;
  public
    constructor Create; override;
    procedure Assign(AObj: TADDatSObject); override;
    function IsEqualTo(AObj: TADDatSObject): Boolean; override;
    property Name: String read FName write SetName;
    property NamedList: TADDatSNamedList read GetNamedList;
  end;

  TADDatSBindedObject = class (TADDatSNamedObject)
  private
    FSourceName: String;
    FSourceID: Integer;
  public
    constructor Create; override;
    procedure Assign(AObj: TADDatSObject); override;
    property SourceName: String read FSourceName write FSourceName;
    property SourceID: Integer read FSourceID write FSourceID;
  end;

  TADDatSList = class (TADDatSObject)
  private
    FArray: array of TADDatSObject;
    FCapacity, FCount: Integer;
    FOwnObjects: Boolean;
    FMinimumCapacity: Integer;
    function GetItemsI(AIndex: Integer): TADDatSObject;
    procedure SetCapacity(const AValue: Integer);
    procedure SetMinimumCapacity(const AValue: Integer);
  protected
    FDefaultReason: TADDatSNotificationReason;
    procedure AddEx(AObj: TADDatSObject);
    function AddObject(AObj: TADDatSObject): Integer;
    procedure AddObjectAt(AObj: TADDatSObject; APosition: Integer); virtual;
    procedure Notify(AParam: PDEDatSNotifyParam); override;
    procedure HandleNotification(AParam: PDEDatSNotifyParam); override;
    procedure Copy(ASource: TADDatSList);
    property Capacity: Integer read FCapacity write SetCapacity;
  public
    constructor Create; overload; override;
    destructor Destroy; override;
    procedure Assign(AObj: TADDatSObject); override;
    procedure Clear; virtual;
    function ContainsObj(AObj: TADDatSObject): Boolean;
    function IndexOf(AObj: TADDatSObject): Integer; override;
    function IsEqualTo(AObj: TADDatSObject): Boolean; override;
    function Remove(AObj: TADDatSObject; ANotDestroy: Boolean = False): Integer;
    procedure RemoveAt(AIndex: Integer; ANotDestroy: Boolean = False); virtual;
    procedure Move(AFromIndex, AToIndex: Integer);
    property Count: Integer read FCount;
    property ItemsI[AIndex: Integer]: TADDatSObject read GetItemsI; default;
    property OwnObjects: Boolean read FOwnObjects write FOwnObjects default False;
    property MinimumCapacity: Integer read FMinimumCapacity write SetMinimumCapacity default 0;
  end;

  TADDatSNamedList = class (TADDatSList)
  private
    FNamesIndex: TADStringList;
    function GetItemsI(AIndex: Integer): TADDatSNamedObject;
    function Find(const AName: String; var AIndex: Integer): Boolean;
    function FindRealIndex(const AName: String; var AIndex: Integer): Boolean;
    procedure ErrorNameNotFound(const AName: String);
  protected
    procedure CheckUniqueName(const AName: String; ASelf: TADDatSNamedObject);
    procedure Notify(AParam: PDEDatSNotifyParam); override;
    procedure AddObjectAt(AObj: TADDatSObject; APosition: Integer); override;
  public
    constructor Create; overload; override;
    destructor Destroy; override;
    function ContainsName(const AName: String): Boolean;
    function IndexOfName(const AName: String): Integer;
    function ItemByName(const AName: String): TADDatSNamedObject;
    procedure RemoveByName(const AName: String);
    function BuildUniqueName(const AName: String): String;
    property ItemsI[AIndex: Integer]: TADDatSNamedObject read GetItemsI; default;
    property ItemsS[const AName: String]: TADDatSNamedObject read ItemByName;
  end;

  TADDatSBindedList = class (TADDatSNamedList)
  private
    function GetItemsI(AIndex: Integer): TADDatSBindedObject;
  public
    function ItemByName(const AName: String): TADDatSBindedObject;
    function IndexOfSourceID(AID: Integer): Integer;
    function IndexOfSourceName(const AName: String): Integer;
    property ItemsI[AIndex: Integer]: TADDatSBindedObject read GetItemsI; default;
    property ItemsS[const AName: String]: TADDatSBindedObject read ItemByName;
  end;

  TADDatSColumn = class (TADDatSBindedObject)
  private
    FIndex: Integer;
    FAttributes: TADDataAttributes;
    FAutoIncrement: Boolean;
    FAutoIncrementSeed: Integer;
    FAutoIncrementStep: Integer;
    FCaption: String;
    FDataType: TADDataType;
    FExpression: String;
    FOptions: TADDataOptions;
    FPrecision: Integer;
    FSize: LongWord;
    FEvaluator: IADStanExpressionEvaluator;
    FScale: Integer;
    FSourceDataType: TADDataType;
    FSourcePrecision: Integer;
    FSourceScale: Integer;
    FSourceSize: LongWord;
    FSourceDataTypeName: String;
    FOriginName: String;
    function GetCaption: String;
    function GetColumnList: TADDatSColumnList;
    function GetReadOnly: Boolean;
    procedure SetAttributes(const AValue: TADDataAttributes);
    procedure SetAutoIncrement(const AValue: Boolean);
    procedure SetAutoIncrementSeed(const AValue: Integer);
    procedure SetAutoIncrementStep(const AValue: Integer);
    procedure SetCaption(const AValue: String);
    procedure SetDataType(const AValue: TADDataType);
    procedure SetExpression(const AValue: String);
    procedure SetOptions(const AValue: TADDataOptions);
    procedure SetPrecision(const AValue: Integer);
    procedure SetSize(const AValue: LongWord);
    procedure SetScale(const AValue: Integer);
    function GetNestedTable: TADDatSTable;
    function GetParentColumn: TADDatSColumn;
    function GetAllowDBNull: Boolean;
    procedure SetAllowDBNull(const AValue: Boolean);
    function GetUnique: Boolean;
    procedure SetUnique(const AValue: Boolean);
    procedure UpdateUniqueKey(AUnique: Boolean);
    procedure SetReadOnly(const AValue: Boolean);
    procedure DefinitionChanging;
    procedure SetServerAutoIncrement(const Value: Boolean);
    function GetDisplayWidth: Integer;
    function GetStorageSize: Integer;
    function GetServerAutoIncrement: Boolean;
  protected
    procedure DefinitionChanged;
    procedure Notify(AParam: PDEDatSNotifyParam); override;
    procedure DoListInserting; override;
    procedure DoListInserted; override;
    procedure DoListRemoving; override;
    function GetIndex: Integer; override;
  public
    constructor Create; overload; override;
    constructor Create(const AName: String; AType: TADDataType = dtAnsiString;
      const AExpression: String = ''); overload;
    procedure Assign(AObj: TADDatSObject); override;
    function IsAutoIncrementType(const AValue: TADDataType): Boolean;
    // ro
    property ColumnList: TADDatSColumnList read GetColumnList;
    property DisplayWidth: Integer read GetDisplayWidth;
    property Index: Integer read GetIndex;
    property NestedTable: TADDatSTable read GetNestedTable;
    property ParentColumn: TADDatSColumn read GetParentColumn;
    property StorageSize: Integer read GetStorageSize;
    // rw
    property AllowDBNull: Boolean read GetAllowDBNull write SetAllowDBNull
      default True;
    property Attributes: TADDataAttributes read FAttributes write
      SetAttributes default [caAllowNull];
    property AutoIncrement: Boolean read FAutoIncrement write SetAutoIncrement
      default False;
    property ServerAutoIncrement: Boolean read GetServerAutoIncrement
      write SetServerAutoIncrement default False;
    property AutoIncrementSeed: Integer read FAutoIncrementSeed write
      SetAutoIncrementSeed default 1;
    property AutoIncrementStep: Integer read FAutoIncrementStep write
      SetAutoIncrementStep default 1;
    property Caption: String read GetCaption write SetCaption;
    property DataType: TADDataType read FDataType write SetDataType
      default dtUnknown;
    property Expression: String read FExpression write SetExpression;
    property Options: TADDataOptions read FOptions write SetOptions
      default [coAllowNull, coInUpdate, coInWhere];
    property Precision: Integer read FPrecision write SetPrecision default 0;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property Scale: Integer read FScale write SetScale default 0;
    property Size: LongWord read FSize write SetSize default 50;
    property SourceDataType: TADDataType read FSourceDataType write FSourceDataType;
    property SourcePrecision: Integer read FSourcePrecision write FSourcePrecision;
    property SourceScale: Integer read FSourceScale write FSourceScale;
    property SourceSize: LongWord read FSourceSize write FSourceSize;
    property SourceDataTypeName: String read FSourceDataTypeName
      write FSourceDataTypeName;
    property SourceDirectory: String read FSourceDataTypeName
      write FSourceDataTypeName;
    property OriginName: String read FOriginName write FOriginName;
    property Unique: Boolean read GetUnique write SetUnique default False;
  end;

  TADDatSTableExpressionDS = class(TInterfacedObject, IADStanExpressionDataSource)
  private
    FTable: TADDatSTable;
    FRow: TADDatSRow;
  protected
    // IADStanExpressionDataSource
    function GetVarIndex(const AName: String): Integer; virtual;
    function GetVarType(AIndex: Integer): TADDataType; virtual;
    function GetVarScope(AIndex: Integer): TADExpressionScopeKind; virtual;
    function GetVarData(AIndex: Integer): Variant; virtual;
    procedure SetVarData(AIndex: Integer; const AValue: Variant); virtual;
    function GetSubAggregateValue(AIndex: Integer): Variant; virtual;
    function GetPosition: Pointer; virtual;
    procedure SetPosition(AValue: Pointer); virtual;
    function GetRowNum: Integer; virtual;
  public
    constructor Create(ATable: TADDatSTable);
  end;

  TADArrayOfInteger = array of Integer;
  TADArrayOfLongWord = array of LongWord;
  TADArrayOfByte = array of Byte;
  TADDatSColumnList = class (TADDatSBindedList)
  private
    FAutoIncs: TADArrayOfInteger;
    FDataOffsets: TADArrayOfLongWord;
    FNullOffsets: TADArrayOfLongWord;
    FNullMasks: TADArrayOfByte;
    FFetchedOffset: Integer;
    FFetchedSize: Integer;
    FInvariantMap: TADArrayOfInteger;
    FInvariantOffset: Integer;
    FInvariantSize: Integer;
    FInvariants: Integer;
    FParentRowRefCol: Integer;
    FParentCol: Integer;
    FHasThings: TADDatSColumnThings;
    FOnCalcColumns: TADDatSColumnsCalculateEvent;
    FInlineDataSize: Word;
    FRowsPool: TADMemPool;
    FBuffsPool: TADMemPool;
    function GetCurrValues(AIndex: Integer): Integer;
    function GetItemsI(AIndex: Integer): TADDatSColumn;
    procedure UpdateLayout(ARowInstanceSize: Integer);
    procedure SetInlineDataSize(const AValue: Word);
    function GetStorageSize: LongWord;
  protected
    procedure CheckUpdateLayout(ARowInstanceSize: Integer);
    procedure TerminateLayout;
    procedure Notify(AParam: PDEDatSNotifyParam); override;
    procedure HandleNotification(AParam: PDEDatSNotifyParam); override;
    procedure AddObjectAt(AObj: TADDatSObject; APosition: Integer); override;
  public
    constructor CreateForTable(ATable: TADDatSTable);
    procedure Assign(AObj: TADDatSObject); override;
    function Add(AObj: TADDatSColumn): Integer; overload;
    function Add(const AName: String; AType: TADDataType = dtAnsiString;
      const AExpression: String = ''): TADDatSColumn; overload;
    procedure RemoveAt(AIndex: Integer; ANotDestroy: Boolean = False); override;
    function ColumnByName(const AName: String): TADDatSColumn;
    property CurrValues[AIndex: Integer]: Integer read GetCurrValues;
    property ItemsI[AIndex: Integer]: TADDatSColumn read GetItemsI; default;
    property ItemsS[const AName: String]: TADDatSColumn read ColumnByName;
    property DataOffsets: TADArrayOfLongWord read FDataOffsets;
    property NullOffsets: TADArrayOfLongWord read FNullOffsets;
    property NullMasks: TADArrayOfByte read FNullMasks;
    property ParentRowRefCol: Integer read FParentRowRefCol;
    property ParentCol: Integer read FParentCol;
    property StorageSize: LongWord read GetStorageSize;
    property RowsPool: TADMemPool read FRowsPool;
    property BuffsPool: TADMemPool read FBuffsPool;
    property OnCalcColumns: TADDatSColumnsCalculateEvent read FOnCalcColumns
      write FOnCalcColumns;
    property InlineDataSize: Word read FInlineDataSize write SetInlineDataSize;
  end;

  TADDatSColumnSublist = class (TObject)
  private
    FArray: array of TADDatSColumn;
    FNames: String;
    function GetCount: Integer;
    function GetItemsI(AIndex: Integer): TADDatSColumn;
    procedure Add(ACol: TADDatSColumn);
  public
    function HandleNotification(AParam: PDEDatSNotifyParam): Boolean;
    procedure Clear;
    procedure Fill(AObject: TADDatSObject; const AFields: String;
      ACaseInsensitiveColumnList: TADDatSColumnSublist = nil;
      ADescendingColumnList: TADDatSColumnSublist = nil);
    function IndexOf(AColumn: TADDatSColumn): Integer;
    function FindColumn(const AName: String): TADDatSColumn;
    function Matches(AList: TADDatSColumnSublist; ACount: Integer = -1): Boolean;
    property Count: Integer read GetCount;
    property ItemsI[AIndex: Integer]: TADDatSColumn read GetItemsI; default;
    property ItemsS[const AName: String]: TADDatSColumn read FindColumn;
    property Names: String read FNames;
  end;

  TADDatSConstraintBase = class (TADDatSNamedObject)
  private
    FEnforce: Boolean;
    FLastActualEnforce: Boolean;
    FMessage: String;
    FCheckTime: TADDatSCheckTime;
    FRely: Boolean;
    function GetActualEnforce: Boolean;
    function GetConstraintList: TADDatSConstraintList;
    procedure SetEnforce(const AValue: Boolean);
  protected
    procedure DoCheck(ARow: TADDatSRow; AProposedState:
      TADDatSRowState); virtual;
    procedure DoListInserted; override;
    procedure DoListRemoved(ANewOwner: TADDatSObject); override;
    procedure DoEnforceUpdated; virtual;
    procedure EnforceUpdated;
    function CheckRow(ARow: TADDatSRow): Boolean; virtual;
  public
    constructor Create; overload; override;
    destructor Destroy; override;
    procedure Assign(AObj: TADDatSObject); override;
    function IsEqualTo(AObj: TADDatSObject): Boolean; override;
    procedure Check(ARow: TADDatSRow; AProposedState: TADDatSRowState;
      ATime: TADDatSCheckTime);
    procedure CheckAll;
    property ActualEnforce: Boolean read GetActualEnforce;
    property ConstraintList: TADDatSConstraintList read GetConstraintList;
    property Enforce: Boolean read FEnforce write SetEnforce default True;
    property Rely: Boolean read FRely write FRely default True;
    property CheckTime: TADDatSCheckTime read FCheckTime write FCheckTime default ctAtEditEnd;
    property Message: String read FMessage write FMessage;
  end;

  TADDatSConstraintList = class (TADDatSNamedList)
  private
    FEnforce: Boolean;
    function GetItemsI(AIndex: Integer): TADDatSConstraintBase;
    procedure SetEnforce(const AValue: Boolean);
  protected
    procedure EnforceUpdated;
    procedure HandleNotification(AParam: PDEDatSNotifyParam); override;
  public
    constructor CreateForTable(ATable: TADDatSTable);
    procedure Assign(AObj: TADDatSObject); override;
    function Add(AObj: TADDatSConstraintBase): Integer; overload;
    // UK
    function AddUK(const AName: String; AColumn: TADDatSColumn;
      APrimaryKey: Boolean {$IFDEF AnyDAC_D6Base} = True {$ENDIF}): TADDatSUniqueConstraint; overload;
    function AddUK(const AName: String; const AColumns: array of TADDatSColumn;
      APrimaryKey: Boolean {$IFDEF AnyDAC_D6Base} = True {$ENDIF}): TADDatSUniqueConstraint; overload;
    function AddUK(const AName: String; const AColumnNames: String;
      APrimaryKey: Boolean {$IFDEF AnyDAC_D6Base} = True {$ENDIF}): TADDatSUniqueConstraint; overload;
    // FK
    function AddFK(const AName: String; APrimaryKeyColumn,
      AForeignKeyColumn: TADDatSColumn): TADDatSForeignKeyConstraint; overload;
    function AddFK(const AName: String; const APrimaryKeyColumns,
      AForeignKeyColumns: array of TADDatSColumn): TADDatSForeignKeyConstraint; overload;
    function AddFK(const AName: String; const AParentTableName, APrimaryKeyColumns,
      AForeignKeyColumns: String): TADDatSForeignKeyConstraint; overload;
    function AddFK(const AName: String; AParentTable: TADDatSTable;
      const APrimaryKeyColumns, AForeignKeyColumns: String): TADDatSForeignKeyConstraint; overload;
    // CHK
    function AddChk(const AName, AExpression: String; const AMessage: String = '';
      ACheckTime: TADDatSCheckTime = ctAtEditEnd): TADDatSCheckConstraint; overload;
    procedure Check(ARow: TADDatSRow; AProposedState: TADDatSRowState;
      ATime: TADDatSCheckTime);
    function ConstraintByName(const AName: String): TADDatSConstraintBase;
    function FindUnique(const AFields: String): TADDatSUniqueConstraint;
    function FindPrimaryKey: TADDatSUniqueConstraint;
    procedure CheckAll;
    property Enforce: Boolean read FEnforce write SetEnforce default True;
    property ItemsI[AIndex: Integer]: TADDatSConstraintBase read GetItemsI; default;
    property ItemsS[const AName: String]: TADDatSConstraintBase read ConstraintByName;
  end;

  TADDatSUniqueConstraint = class (TADDatSConstraintBase)
  private
    FColumnNames: String;
    FColumns: TADDatSColumnSublist;
    FOptions: TADSortOptions;
    function GetColumnCount: Integer;
    function GetColumns(AIndex: Integer): TADDatSColumn;
    procedure SetColumnNames(const AValue: String);
    procedure SetOptions(const AValue: TADSortOptions);
    function GetIsPrimaryKey: Boolean;
    procedure SetIsPrimaryKey(const AValue: Boolean);
    function GetUniqueSortedView: TADDatSView;
  protected
    procedure DoCheck(ARow: TADDatSRow;
      AProposedState: TADDatSRowState); override;
    procedure DoEnforceUpdated; override;
    procedure HandleNotification(AParam: PDEDatSNotifyParam); override;
  public
    constructor Create; overload; override;
    constructor Create(AColumn: TADDatSColumn;
      APrimaryKey: Boolean {$IFDEF AnyDAC_D6Base} = False {$ENDIF}); overload;
    constructor Create(const AColumns: array of TADDatSColumn;
      APrimaryKey: Boolean {$IFDEF AnyDAC_D6Base} = False {$ENDIF}); overload;
    constructor Create(const AName: String; AColumn: TADDatSColumn;
      APrimaryKey: Boolean {$IFDEF AnyDAC_D6Base} = False {$ENDIF}); overload;
    constructor Create(const AName: String; const AColumns: array of TADDatSColumn;
      APrimaryKey: Boolean {$IFDEF AnyDAC_D6Base} = False {$ENDIF}); overload;
    constructor Create(const AName, AColumnNames: String;
      APrimaryKey: Boolean {$IFDEF AnyDAC_D6Base} = False {$ENDIF}); overload;
    destructor Destroy; override;
    procedure Assign(AObj: TADDatSObject); override;
    function IsEqualTo(AObj: TADDatSObject): Boolean; override;
    property ColumnNames: String read FColumnNames write SetColumnNames;
    property ColumnCount: Integer read GetColumnCount;
    property Columns[AIndex: Integer]: TADDatSColumn read GetColumns;
    property Options: TADSortOptions read FOptions write SetOptions;
    property IsPrimaryKey: Boolean read GetIsPrimaryKey write SetIsPrimaryKey;
  end;

  TADDatSForeignKeyConstraint = class (TADDatSConstraintBase)
  private
    FColumnNames: String;
    FColumns: TADDatSColumnSublist;
    FDeleteRule: TADDatSConstraintRule;
    FRelatedColumnNames: String;
    FRelatedColumns: TADDatSColumnSublist;
    FRelatedTable: TADDatSTable;
    FUpdateRule: TADDatSConstraintRule;
    FParentMessage: String;
    FRelatedTableName: String;
    FCascadingRows: TList;
    FAcceptRejectRule: TADDatSConstraintARRule;
    FFieldValueRequired: Boolean;
    FInsertRule: TADDatSConstraintRule;
    function GetColumnCount: Integer;
    function GetColumns(AIndex: Integer): TADDatSColumn;
    function GetRelatedColumnCount: Integer;
    function GetRelatedColumns(AIndex: Integer): TADDatSColumn;
    procedure SetColumnNames(const AValue: String);
    procedure SetRelatedColumnNames(const AValue: String);
    procedure SetRelatedTable(const AValue: TADDatSTable);
    function GetChildSortedView: TADDatSView;
    function GetMasterSortedView: TADDatSView;
  protected
    function CheckRow(ARow: TADDatSRow): Boolean; override;
    procedure DoCheck(ARow: TADDatSRow; AProposedState:
      TADDatSRowState); override;
    procedure DoInsertAssignParentValues(AParentRow, AChildRow: TADDatSRow);
    procedure DoEnforceUpdated; override;
    procedure HandleNotification(AParam: PDEDatSNotifyParam); override;
  public
    constructor Create; override;
    constructor Create(AParentColumn, AChildColumn: TADDatSColumn;
      ADeleteRule: TADDatSConstraintRule {$IFDEF AnyDAC_D6Base} = crCascade {$ENDIF};
      AUpdateRule: TADDatSConstraintRule {$IFDEF AnyDAC_D6Base} = crRestrict {$ENDIF}); overload;
    constructor Create(const AParentColumns, AChildColumns: array of TADDatSColumn;
      ADeleteRule: TADDatSConstraintRule {$IFDEF AnyDAC_D6Base} = crCascade {$ENDIF};
      AUpdateRule: TADDatSConstraintRule {$IFDEF AnyDAC_D6Base} = crRestrict {$ENDIF}); overload;
    constructor Create(const AName: String; AParentColumn, AChildColumn: TADDatSColumn;
      ADeleteRule: TADDatSConstraintRule {$IFDEF AnyDAC_D6Base} = crCascade {$ENDIF};
      AUpdateRule: TADDatSConstraintRule {$IFDEF AnyDAC_D6Base} = crRestrict {$ENDIF}); overload;
    constructor Create(const AName: String; const AParentColumns, AChildColumns: array of TADDatSColumn;
      ADeleteRule: TADDatSConstraintRule {$IFDEF AnyDAC_D6Base} = crCascade {$ENDIF};
      AUpdateRule: TADDatSConstraintRule {$IFDEF AnyDAC_D6Base} = crRestrict {$ENDIF}); overload;
    constructor Create(const AName, AParentTableName, AParentColumnNames,
      AChildColumnNames: String;
      ADeleteRule: TADDatSConstraintRule {$IFDEF AnyDAC_D6Base} = crCascade {$ENDIF};
      AUpdateRule: TADDatSConstraintRule {$IFDEF AnyDAC_D6Base} = crRestrict {$ENDIF}); overload;
    constructor Create(const AName: String; AParentTable: TADDatSTable;
      const AParentColumnNames, AChildColumnNames: String;
      ADeleteRule: TADDatSConstraintRule {$IFDEF AnyDAC_D6Base} = crCascade {$ENDIF};
      AUpdateRule: TADDatSConstraintRule {$IFDEF AnyDAC_D6Base} = crRestrict {$ENDIF}); overload;
    destructor Destroy; override;
    procedure Assign(AObj: TADDatSObject); override;
    function IsEqualTo(AObj: TADDatSObject): Boolean; override;
    // ro
    property ColumnCount: Integer read GetColumnCount;
    property Columns[AIndex: Integer]: TADDatSColumn read GetColumns;
    property RelatedColumnCount: Integer read GetRelatedColumnCount;
    property RelatedColumns[AIndex: Integer]: TADDatSColumn read GetRelatedColumns;
    // rw
    property ColumnNames: String read FColumnNames write SetColumnNames;
    property DeleteRule: TADDatSConstraintRule read FDeleteRule
      write FDeleteRule default crCascade;
    property InsertRule: TADDatSConstraintRule read FInsertRule
      write FInsertRule default crCascade;
    property ParentMessage: String read FParentMessage write FParentMessage;
    property RelatedColumnNames: String read FRelatedColumnNames
      write SetRelatedColumnNames;
    property RelatedTable: TADDatSTable read FRelatedTable
      write SetRelatedTable;
    property UpdateRule: TADDatSConstraintRule read FUpdateRule
      write FUpdateRule default crCascade;
    property AcceptRejectRule: TADDatSConstraintARRule read FAcceptRejectRule
      write FAcceptRejectRule default arCascade;
    property FieldValueRequired: Boolean read FFieldValueRequired write
      FFieldValueRequired default False;
  end;

  TADDatSCheckConstraint = class (TADDatSConstraintBase)
  private
    FEvaluator: IADStanExpressionEvaluator;
    FExpression: String;
    procedure SetExpression(const AValue: String);
  protected
    procedure DoCheck(ARow: TADDatSRow; AProposedState:
      TADDatSRowState); override;
    procedure DoEnforceUpdated; override;
    procedure HandleNotification(AParam: PDEDatSNotifyParam); override;
  public
    constructor Create(const AExpression: string); overload;
    constructor Create(const AName, AExpression: string; const AMessage: String = '';
      ACheckTime: TADDatSCheckTime = ctAtEditEnd); overload;
    procedure Assign(AObj: TADDatSObject); override;
    function IsEqualTo(AObj: TADDatSObject): Boolean; override;
    property Expression: String read FExpression write SetExpression;
  end;

  TADDatSRelation = class (TADDatSNamedObject)
  private
    FChildColumnNames: String;
    FChildColumns: TADDatSColumnSublist;
    FChildKeyConstraint: TADDatSForeignKeyConstraint;
    FChildTable: TADDatSTable;
    FNested: Boolean;
    FParentColumnNames: String;
    FParentColumns: TADDatSColumnSublist;
    FParentKeyConstraint: TADDatSUniqueConstraint;
    FParentTable: TADDatSTable;
    function GetChildColumnCount: Integer;
    function GetChildColumns(AIndex: Integer): TADDatSColumn;
    function GetIsDefined: Boolean;
    function GetParentColumnCount: Integer;
    function GetParentColumns(AIndex: Integer): TADDatSColumn;
    function GetRelationList: TADDatSRelationList;
    procedure SetChildColumnNames(const AValue: String);
    procedure SetChildKeyConstraint(const AValue: TADDatSForeignKeyConstraint);
    procedure SetChildTable(const AValue: TADDatSTable);
    procedure SetNested(const AValue: Boolean);
    procedure SetParentColumnNames(const AValue: String);
    procedure SetParentKeyConstraint(const AValue: TADDatSUniqueConstraint);
    procedure SetParentTable(const AValue: TADDatSTable);
    procedure Check;
  protected
    procedure HandleNotification(AParam: PDEDatSNotifyParam); override;
  public
    constructor Create; override;
    constructor Create(const ARelationName: String; AParentColumn,
      AChildColumn: TADDatSColumn; ANested: Boolean {$IFDEF AnyDAC_D6Base} = False {$ENDIF};
      ACreateConstraints: Boolean {$IFDEF AnyDAC_D6Base} = True {$ENDIF}); overload;
    constructor Create(const ARelationName: String; const AParentColumns,
      AChildColumns: array of TADDatSColumn; ANested: Boolean {$IFDEF AnyDAC_D6Base} = False {$ENDIF};
      ACreateConstraints: Boolean {$IFDEF AnyDAC_D6Base} = True {$ENDIF}); overload;
    constructor Create(const ARelationName: String; APK: TADDatSUniqueConstraint;
      AFK: TADDatSForeignKeyConstraint); overload;
    destructor Destroy; override;
    function BuildChildKeyConstraint: TADDatSForeignKeyConstraint;
    function BuildParentKeyConstraint: TADDatSUniqueConstraint;
    procedure Assign(AObj: TADDatSObject); override;
    property ChildColumnCount: Integer read GetChildColumnCount;
    property ChildColumnNames: String read FChildColumnNames write
      SetChildColumnNames;
    property ChildColumns[AIndex: Integer]: TADDatSColumn read
      GetChildColumns;
    property ChildKeyConstraint: TADDatSForeignKeyConstraint read
      FChildKeyConstraint write SetChildKeyConstraint;
    property ChildTable: TADDatSTable read FChildTable write SetChildTable;
    property IsDefined: Boolean read GetIsDefined;
    property Nested: Boolean read FNested write SetNested;
    property ParentColumnCount: Integer read GetParentColumnCount;
    property ParentColumnNames: String read FParentColumnNames write
      SetParentColumnNames;
    property ParentColumns[AIndex: Integer]: TADDatSColumn read
      GetParentColumns;
    property ParentKeyConstraint: TADDatSUniqueConstraint read
      FParentKeyConstraint write SetParentKeyConstraint;
    property ParentTable: TADDatSTable read FParentTable write SetParentTable;
    property RelationList: TADDatSRelationList read GetRelationList;
  end;

  TADDatSRelationArray = array of TADDatSRelation;

  TADDatSRelationList = class (TADDatSNamedList)
  private
    function GetItemsI(AIndex: Integer): TADDatSRelation;
  protected
    procedure HandleNotification(AParam: PDEDatSNotifyParam); override;
  public
    constructor CreateForManager(AManager: TADDatSManager);
    function Add(AObj: TADDatSRelation): Integer; overload;
    function Add(const ARelName: String; AParentColumn, AChildColumn:
      TADDatSColumn; ANested: Boolean = False;
      ACreateConstraints: Boolean = True): TADDatSRelation; overload;
    function Add(AParentColumn, AChildColumn: TADDatSColumn;
      ANested: Boolean = False; ACreateConstraints: Boolean = True):
      TADDatSRelation; overload;
    function Add(const ARelName: String; const AParentColumns, AChildColumns:
      array of TADDatSColumn; ANested: Boolean {$IFDEF AnyDAC_D6Base} = False {$ENDIF};
      ACreateConstraints: Boolean {$IFDEF AnyDAC_D6Base} = True {$ENDIF}): TADDatSRelation; overload;
    function Add(const AParentColumns, AChildColumns: array of TADDatSColumn;
      ANested: Boolean {$IFDEF AnyDAC_D6Base} = False {$ENDIF};
      ACreateConstraints: Boolean {$IFDEF AnyDAC_D6Base} = True {$ENDIF}): TADDatSRelation; overload;
    function Add(const ARelName: String; APK: TADDatSUniqueConstraint;
      AFK: TADDatSForeignKeyConstraint): TADDatSRelation; overload;
    function FindRelation(AParentTable, AChildTable: TADDatSTable;
      AMBNested: Boolean): TADDatSRelation; overload;
    function FindRelation(AParentTable: TADDatSTable;
      AObjColumn: TADDatSColumn): TADDatSRelation; overload;
    function FindRelation(ANestedTable: TADDatSTable): TADDatSRelation; overload;
    function RelationByName(const AName: String): TADDatSRelation;
    function GetRelationsForTable(AParentRelations: Boolean;
      ATable: TADDatSTable): TADDatSRelationArray;
    property ItemsI[AIndex: Integer]: TADDatSRelation read GetItemsI; default;
    property ItemsS[const AName: String]: TADDatSRelation read RelationByName;
  end;

  TADDatSMechSortSource = (ssColumns, ssExpression, ssRowId);
  IADDataMechSort = interface (IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2019}']
    // private
    function GetSortOptions: TADSortOptions;
    function GetSortColumnList: TADDatSColumnSublist;
    function GetSortDescendingColumnList: TADDatSColumnSublist;
    function GetSortCaseInsensitiveColumnList: TADDatSColumnSublist;
    function GetSortSource: TADDatSMechSortSource;
    // public
    procedure Sort(AList: TADDatSRowListBase);
    function SortingOn(const AColumnNames: String;
      ARequiredOptions, AProhibitedOptions: TADSortOptions): Boolean; overload;
    function SortingOn(AKeyColumnList: TADDatSColumnSublist; AKeyColumnCount: Integer;
      ARequiredOptions, AProhibitedOptions: TADSortOptions): Boolean; overload;
    function CompareRows(ARow1, ARow2: TADDatSRow;
      AColumnCount: Integer; AOptions: TADCompareDataOptions): Integer; overload;
    function CompareRows(ARow1, ARow2: TADDatSRow;
      AColumnCount: Integer): Integer; overload;
    function Search(ARowList: TADDatSRowListBase; AKeyRow: TADDatSRow;
      AKeyColumnList, AKeyColumnList2: TADDatSColumnSublist; AKeyColumnCount: Integer;
      AOptions: TADLocateOptions; var AIndex: Integer; var AFound: Boolean;
      ARowVersion: TADDatSRowVersion = rvDefault): Integer;
    property SortOptions: TADSortOptions read GetSortOptions;
    property SortColumnList: TADDatSColumnSublist read GetSortColumnList;
    property SortDescendingColumnList: TADDatSColumnSublist read GetSortDescendingColumnList;
    property SortCaseInsensitiveColumnList: TADDatSColumnSublist read GetSortCaseInsensitiveColumnList;
    property SortSource: TADDatSMechSortSource read GetSortSource;
  end;

  TADDatSMechBase = class (TADDatSObject)
  private
    FPrevActualActive, FActive: Boolean;
    FLocator: Boolean;
    procedure SetActive(const AValue: Boolean);
    function GetView: TADDatSView;
    function GetViewList: TADDatSViewList;
  protected
    FKinds: TADDatSMechanismKinds;
    function GetActualActive: Boolean; virtual;
    procedure DoListInserted; override;
    procedure DoListRemoving; override;
    procedure DoListRemoved(ANewOwner: TADDatSObject); override;
    procedure DoActiveChanged; virtual;
    procedure CheckActiveChanged;
    function GetTable: TADDatSTable; override;
    function GetRowsRange(var ARowList: TADDatSRowListBase; var ABeginInd,
      AEndInd: Integer): Boolean; virtual;
    function AcceptRow(ARow: TADDatSRow; AVersion: TADDatSRowVersion):
      Boolean; virtual;
  public
    procedure Assign(AObj: TADDatSObject); override;
    // ro
    property Table: TADDatSTable read GetTable;
    property View: TADDatSView read GetView;
    property ViewList: TADDatSViewList read GetViewList;
    property ActualActive: Boolean read GetActualActive;
    property Kinds: TADDatSMechanismKinds read FKinds;
    // rw
    property Active: Boolean read FActive write SetActive default False;
    property Locator: Boolean read FLocator write FLocator default False;
  end;
  TADDatSMechBaseClass = class of TADDatSMechBase;

  TADDatSViewMechList = class (TADDatSList)
  private
    function GetItemsI(AIndex: Integer): TADDatSMechBase;
  protected
    procedure HandleNotification(AParam: PDEDatSNotifyParam); override;
  public
    constructor CreateForView(AView: TADDatSView);
    function AcceptRow(ARow: TADDatSRow; AVersion: TADDatSRowVersion):
      Boolean;
    function Add(AObj: TADDatSMechBase): Integer;
    function AddSort(const AColumns: String; const ADescColumns: String = '';
      const ACaseInsColumns: String = ''; AOptions: TADSortOptions = []): TADDatSMechSort; overload;
    function AddSort(const AExpression: String; AOptions: TADSortOptions): TADDatSMechSort; overload;
    function AddStates(AStates: TADDatSRowStates = [rsInitializing, rsInserted,
      rsModified, rsUnchanged, rsEditing, rsCalculating, rsChecking]): TADDatSMechRowState;
    function AddFilter(const AExpression: String; AOptions:
      TADExpressionOptions = []; AEvent: TADFilterRowEvent = nil): TADDatSMechFilter;
    function AddError: TADDatSMechError;
    function AddDetail(AParentRel: TADDatSRelation;
      AParentRow: TADDatSRow): TADDatSMechDetails;
    procedure Clear; override;
    property ItemsI[AIndex: Integer]: TADDatSMechBase read GetItemsI; default;
  end;

  TADDatSMechSort = class (TADDatSMechBase, IUnknown, IADDataMechSort)
  private
    FCaseInsensitiveColumnList: TADDatSColumnSublist;
    FCaseInsensitiveColumns: String;
    FColumnList: TADDatSColumnSublist;
    FColumns: String;
    FDescendingColumnList: TADDatSColumnSublist;
    FDescendingColumns: String;
    FSortOptions: TADSortOptions;
    FExpression: String;
    FEvaluator: IADStanExpressionEvaluator;
    FSortSource: TADDatSMechSortSource;
    FSortOptionsChanged: Boolean;
    FUniqueKey: TADDatSUniqueConstraint;
    procedure SetCaseInsensitiveColumns(const AValue: String);
    procedure SetColumns(const AValue: String);
    procedure SetDescendingColumns(const AValue: String);
    procedure SetSortOptions(const AValue: TADSortOptions);
    procedure SetExpression(const AValue: String);
    function CreateUniqueConstraint: TADDatSUniqueConstraint;
    function MatchOptions(ARequiredOptions, AProhibitedOptions: TADSortOptions): Boolean;
  protected
    procedure DoActiveChanged; override;
    procedure HandleNotification(AParam: PDEDatSNotifyParam); override;
    // IUnknown
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    // IADDataMechSortGS
    function GetSortOptions: TADSortOptions;
    function GetSortColumnList: TADDatSColumnSublist;
    function GetSortDescendingColumnList: TADDatSColumnSublist;
    function GetSortCaseInsensitiveColumnList: TADDatSColumnSublist;
    function GetSortSource: TADDatSMechSortSource;
    procedure Sort(AList: TADDatSRowListBase);
    function SortingOn(const AColumnNames: String; ARequiredOptions,
      AProhibitedOptions: TADSortOptions): Boolean; overload;
    function SortingOn(AKeyColumnList: TADDatSColumnSublist; AKeyColumnCount: Integer;
      ARequiredOptions, AProhibitedOptions: TADSortOptions): Boolean; overload;
    function CompareRows(ARow1, ARow2: TADDatSRow;
      AColumnCount: Integer; AOptions: TADCompareDataOptions): Integer; overload;
    function CompareRows(ARow1, ARow2: TADDatSRow;
      AColumnCount: Integer): Integer; overload;
    function Search(ARowList: TADDatSRowListBase; AKeyRow: TADDatSRow;
      AKeyColumnList, AKeyColumnList2: TADDatSColumnSublist; AKeyColumnCount: Integer;
      AOptions: TADLocateOptions; var AIndex: Integer; var AFound: Boolean;
      ARowVersion: TADDatSRowVersion = rvDefault): Integer;
  public
    constructor Create; overload; override;
    constructor Create(const AColumns: String; const ADescColumns: String = '';
      const ACaseInsColumns: String = ''; AOptions: TADSortOptions = []); overload;
    constructor Create(const AExpression: String; AOptions: TADSortOptions); overload;
    destructor Destroy; override;
    procedure Assign(AObj: TADDatSObject); override;
    function IsEqualTo(AObj: TADDatSObject): Boolean; override;
    property Expression: String read FExpression write SetExpression;
    property Columns: String read FColumns write SetColumns;
    property DescendingColumns: String read FDescendingColumns write SetDescendingColumns;
    property CaseInsensitiveColumns: String read FCaseInsensitiveColumns
      write SetCaseInsensitiveColumns;
    property SortOptions: TADSortOptions read GetSortOptions write SetSortOptions default [];
    property SortColumnList: TADDatSColumnSublist read GetSortColumnList;
    property SortDescendingColumnList: TADDatSColumnSublist read GetSortDescendingColumnList;
    property SortCaseInsensitiveColumnList: TADDatSColumnSublist read GetSortCaseInsensitiveColumnList;
    property SortSource: TADDatSMechSortSource read FSortSource;
  end;

  TADDatSMechRowState = class (TADDatSMechBase)
  private
    FRowStates: TADDatSRowStates;
    procedure SetRowStates(const AValue: TADDatSRowStates);
  public
    constructor Create; overload; override;
    constructor Create(AStates: TADDatSRowStates); overload;
    procedure Assign(AObj: TADDatSObject); override;
    function IsEqualTo(AObj: TADDatSObject): Boolean; override;
    function AcceptRow(ARow: TADDatSRow; AVersion: TADDatSRowVersion):
      Boolean; override;
    property RowStates: TADDatSRowStates read FRowStates write SetRowStates;
  end;

  TADDatSMechRange = class (TADDatSMechBase)
  private
    FBottom: TADDatSRow;
    FTop: TADDatSRow;
    FBottomExclusive: Boolean;
    FTopExclusive: Boolean;
    FSortMech: IADDataMechSort;
    FBottomColumnCount, FTopColumnCount: Integer;
    procedure SetBottom(const AValue: TADDatSRow);
    procedure SetTop(const AValue: TADDatSRow);
    procedure SetBottomExclusive(const AValue: Boolean);
    procedure SetTopExclusive(const AValue: Boolean);
    procedure SetSortMech(const AValue: IADDataMechSort);
    procedure SetBottomColumnCount(const AValue: Integer);
    procedure SetTopColumnCount(const AValue: Integer);
  protected
    FTopColumnList: TADDatSColumnSublist;
    FBottomColumnList: TADDatSColumnSublist;
    procedure DoActiveChanged; override;
    function NoRangeNoRecords: Boolean; virtual;
    function GetRowsRange(var ARowList: TADDatSRowListBase; var ABeginInd,
      AEndInd: Integer): Boolean; override;
    function AcceptRow(ARow: TADDatSRow; AVersion: TADDatSRowVersion):
      Boolean; override;
  public
    constructor Create; overload; override;
    procedure Assign(AObj: TADDatSObject); override;
    function IsEqualTo(AObj: TADDatSObject): Boolean; override;
    property Bottom: TADDatSRow read FBottom write SetBottom;
    property Top: TADDatSRow read FTop write SetTop;
    property BottomExclusive: Boolean read FBottomExclusive write SetBottomExclusive;
    property TopExclusive: Boolean read FTopExclusive write SetTopExclusive;
    property SortMech: IADDataMechSort read FSortMech write SetSortMech;
    property BottomColumnCount: Integer read FBottomColumnCount write SetBottomColumnCount;
    property TopColumnCount: Integer read FTopColumnCount write SetTopColumnCount;
  end;

  TADDatSMechFilter = class (TADDatSMechBase)
  private
    FExpression: String;
    FOptions: TADExpressionOptions;
    FEvaluator: IADStanExpressionEvaluator;
    FOnFilterRow: TADFilterRowEvent;
    procedure SetExpression(const AValue: String);
    procedure SetOptions(const AValue: TADExpressionOptions);
    procedure SetOnFilterRow(const AValue: TADFilterRowEvent);
  protected
    procedure DoActiveChanged; override;
  public
    constructor Create; overload; override;
    constructor Create(const AExpression: String;
      AOptions: TADExpressionOptions = []; AEvent: TADFilterRowEvent = nil); overload;
    procedure Assign(AObj: TADDatSObject); override;
    function IsEqualTo(AObj: TADDatSObject): Boolean; override;
    function AcceptRow(ARow: TADDatSRow; AVersion: TADDatSRowVersion):
      Boolean; override;
    property Expression: String read FExpression write SetExpression;
    property Options: TADExpressionOptions read FOptions write SetOptions default [];
    property OnFilterRow: TADFilterRowEvent read FOnFilterRow write SetOnFilterRow;
  end;

  TADDatSMechError = class (TADDatSMechBase)
  public
    constructor Create; overload; override;
    constructor CreateErr(ADummy: Integer = 0);
    function AcceptRow(ARow: TADDatSRow; AVersion: TADDatSRowVersion):
      Boolean; override;
  end;

  TADDatSMechDetails = class (TADDatSMechRange)
  private
    FParentRelation: TADDatSRelation;
    FParentRow: TADDatSRow;
    procedure SetParentRelation(const AValue: TADDatSRelation);
    procedure SetParentRow(const AValue: TADDatSRow);
  protected
    function GetActualActive: Boolean; override;
    procedure DoActiveChanged; override;
    function NoRangeNoRecords: Boolean; override;
  public
    constructor Create(AParentRel: TADDatSRelation;
      AParentRow: TADDatSRow); overload;
    procedure Assign(AObj: TADDatSObject); override;
    function IsEqualTo(AObj: TADDatSObject): Boolean; override;
    property ParentRelation: TADDatSRelation read FParentRelation
      write SetParentRelation;
    property ParentRow: TADDatSRow read FParentRow write SetParentRow;
  end;

  TADDatSMechChilds = class (TADDatSMechBase)
  private
    FParentRow: TADDatSRow;
    FRefCol: Integer;
    FRefColType: TADDataType;
    FRefRow: TADDatSNestedRowList;
    procedure SetParentRow(const AValue: TADDatSRow);
  protected
    procedure DoActiveChanged; override;
    function GetRowsRange(var ARowList: TADDatSRowListBase; var ABeginInd,
      AEndInd: Integer): Boolean; override;
    function AcceptRow(ARow: TADDatSRow; AVersion: TADDatSRowVersion):
      Boolean; override;
  public
    constructor Create; overload; override;
    constructor Create(AParentRow: TADDatSRow); overload;
    procedure Assign(AObj: TADDatSObject); override;
    property ParentRow: TADDatSRow read FParentRow write SetParentRow;
  end;

  TADDatSMechMaster = class (TADDatSMechRange)
  private
    FChildRelation: TADDatSRelation;
    FChildRow: TADDatSRow;
    procedure SetChildRelation(const AValue: TADDatSRelation);
    procedure SetChildRow(const AValue: TADDatSRow);
  protected
    function GetActualActive: Boolean; override;
    procedure DoActiveChanged; override;
    function NoRangeNoRecords: Boolean; override;
  public
    constructor Create(AChildRel: TADDatSRelation;
      AChildRow: TADDatSRow); overload;
    procedure Assign(AObj: TADDatSObject); override;
    function IsEqualTo(AObj: TADDatSObject): Boolean; override;
    property ChildRelation: TADDatSRelation read FChildRelation
      write SetChildRelation;
    property ChildRow: TADDatSRow read FChildRow write SetChildRow;
  end;

  TADDatSMechParent = class (TADDatSMechBase)
  private
    FChildRow: TADDatSRow;
    FParentRow: TADDatSRowListBase;
    procedure SetChildRow(const AValue: TADDatSRow);
  protected
    procedure DoActiveChanged; override;
    function GetActualActive: Boolean; override;
    function GetRowsRange(var ARowList: TADDatSRowListBase;
      var ABeginInd, AEndInd: Integer): Boolean; override;
    function AcceptRow(ARow: TADDatSRow; AVersion: TADDatSRowVersion):
      Boolean; override;
  public
    constructor Create; overload; override;
    constructor Create(AChildRow: TADDatSRow); overload;
    procedure Assign(AObj: TADDatSObject); override;
    property ChildRow: TADDatSRow read FChildRow write SetChildRow;
  end;

  PDEDataRowExtraInfo = ^TADDatSRowExtraInfo;
  TADDatSRowExtraInfo = packed record
    FCheckColumn: Integer;
    FCheckValue: PByte;
    FCheckLen: LongWord;
    FRowException: EADException;
    FLockID: LongWord;
  end;

  TADDatSBlobCache = class(TObject)
  public
    function Allocate(ASize: LongWord): Pointer;
    procedure Release(APtr: Pointer; ASize: LongWord);
  end;

  TADDatSCompareRowsCacheItem = record
    FpBuff: PByte;
    FLen: Integer;
    FOpts: TADCompareDataOptions;
    FIsNull: Boolean;
    FInit: Boolean;
  end;
  TADDatSCompareRowsCache = array of TADDatSCompareRowsCacheItem;

  TADDatSRow = class (TADDatSObject)
  private
    FTable: TADDatSTable;
    FpOriginal: PByte;
    FpCurrent: PByte;
    FpProposed: PByte;
    // following fields must be here, but moved to TADDatSObject to pack
    // FLockNotificationCount, FRowPriorState and FRowState into double word
    // FRowPriorState: TADDatSRowState;
    // RowState: TADDatSRowState;
    FNextChange, FPriorChange: TADDatSRow;
    FRowID, FChangeNumber: LongWord;
    FExtraInfo: PDEDataRowExtraInfo;
    function GetHasErrors: Boolean;
    function GetRowList: TADDatSTableRowList;
    procedure CalculateColumns(ADefaults: Boolean);
    function CheckWrite(AColumn: Integer): PByte;
    procedure InternalInitComplexData(ABuffer: PByte);
    procedure AllocInvariants;
    procedure FreeInvariants;
    function GetInvariantObject(AColumn: Integer): TADDatSObject;
    procedure SetInvariantObject(AColumn: Integer; AObj: TADDatSObject);
    function GetParentRow: TADDatSRow;
    procedure SetParentRow(ARow: TADDatSRow);
    function GetNestedRow(AColumn: Integer): TADDatSRow;
    procedure SetNestedRow(AColumn: Integer; ARow: TADDatSRow);
    function GetNestedRows(AColumn: Integer): TADDatSNestedRowList;
    procedure ConstrainChildRow(AProposedState: TADDatSRowState);
    procedure ConstrainParentRow(AProposedState: TADDatSRowState);
    procedure CancelNestedRows;
    procedure ClearNestedRows;
    procedure AcceptNestedChanges;
    procedure ClearNestedErrors;
    procedure ProcessNestedRows(AMethod: TADDatSProcessNestedRowsMethod);
    procedure RejectNestedChanges;
    procedure AllocFetchedMarks;
    procedure SetFetchedMarks(AOn: Boolean);
    function GetRowError: EADException;
    function SetRowError(const AValue: EADException): Boolean;
    procedure SetRowErrorPrc(const AValue: EADException);
    procedure DoNRDelete(ARow: TADDatSRow);
    procedure DoNREndModify(ARow: TADDatSRow);
    procedure DoNRCancel(ARow: TADDatSRow);
    procedure DoNRFree(ARow: TADDatSRow);
    procedure DoNRAcceptChanges(ARow: TADDatSRow);
    procedure DoNRClearErrors(ARow: TADDatSRow);
    procedure DoNRRejectChanges(ARow: TADDatSRow);
    procedure DoNRDetache(ARow: TADDatSRow);
    function GetDataI(AColumn: Integer;
      AVersion: TADDatSRowVersion): Variant;
    function GetDataO(AColumn: TADDatSColumn;
      AVersion: TADDatSRowVersion): Variant;
    procedure CheckNoInfo;
    function GetRowInfo(AForce: Boolean): Pointer;
    function GetCheckInfo(ACheckColumn: Integer; var ACheckValue: PByte;
      var ACheckLen: LongWord): Boolean;
    procedure SetCheckInfo(ACheckColumn: Integer; ACheckValue: PByte;
      ACheckLen: Integer);
    function SkipConstraintCheck: Boolean;
    procedure CascadeAcceptReject(AAccept: Boolean);
    function GetDBLockID: LongWord;
    procedure InternalCalculateColumns(ADefaults: Boolean; ACols: TADDatSColumnList);
    procedure InternalAssignDefaults(ACols: TADDatSColumnList);
  protected
    class function CreateInstance(ATable: TADDatSTable;
      ASetToDefaults: Boolean): TADDatSRow;
    procedure DoListInserted; override;
    procedure DoListInserting; override;
    procedure DoListRemoved(ANewOwner: TADDatSObject); override;
    procedure DoListRemoving; override;
    function AllocBuffer: PByte;
    procedure CleanupBuffer(ABuffer: PByte);
    procedure CopyBuffer(ADestination, ASource: PByte);
    procedure FreeBuffer(var ApBuffer: PByte);
    function GetBlobData(ABuffer: PByte; AColumn: Integer; var ApData: PByte;
      var ALen: Integer): Boolean;
    function GetBuffer(AVersion: TADDatSRowVersion): PByte;
    function GetIsNull(ABuffer: PByte; AColumn: Integer): Boolean;
    function GetTable: TADDatSTable; override;
    function GetManager: TADDatSManager; override;
    procedure InitBuffer(ABuffer: PByte);
    function SetBlobData(ABuffer: PByte; AColumn: Integer; ApData: PByte;
      ALength: Integer): PByte;
    procedure SetIsNull(ABuffer: PByte; AColumn: Integer; AValue: Boolean);
    procedure SetFetched(AColumn: Integer; AValue: Boolean);
    function GetFetched(AColumn: Integer): Boolean;
    procedure RegisterChange;
    procedure UnregisterChange;
  public
    constructor CreateForTable(ATable: TADDatSTable; ASetToDefaults: Boolean);
    destructor Destroy; override;
    procedure FreeInstance; override;
    procedure AcceptChanges(AUseCascade: Boolean = True);
    procedure AssignDefaults;
    procedure BeginEdit;
    procedure CancelEdit;
    procedure CheckRowConstraints(AProposedState: TADDatSRowState);
    procedure CheckColumnConstraints;
    procedure Clear(ASetColsToDefaults: Boolean);
    procedure ClearErrors;
    function CompareColumnVersions(AColumn: Integer;
      AVersion1, AVersion2: TADDatSRowVersion): Boolean;
    function CompareColumnsVersions(AColumns: TADDatSColumnSublist;
      AVersion1, AVersion2: TADDatSRowVersion): Boolean;
    function CompareData(AColumn: Integer; ABuff1: Pointer; ADataLen1: Integer;
      ABuff2: Pointer; ADataLen2: Integer; AOptions: TADCompareDataOptions):
      Integer;
    function CompareRows(AColumns, ADescendingColumns,
      ACaseInsensitiveColumns: TADDatSColumnSublist; AColumnCount: Integer;
      ARow2: TADDatSRow; AColumns2: TADDatSColumnSublist;
      AVersion: TADDatSRowVersion; AOptions: TADCompareDataOptions;
      var ACache: TADDatSCompareRowsCache): Integer; overload;
    function CompareRows(ARow2: TADDatSRow; AVersion: TADDatSRowVersion;
      AOptions: TADCompareDataOptions): Integer; overload;
    function CompareRowsExp(const AEvaluator: IADStanExpressionEvaluator;
      ARow2: TADDatSRow; AVersion: TADDatSRowVersion;
      AOptions: TADCompareDataOptions): Integer;
    procedure Delete(ANotDestroy: Boolean = False);
    procedure EndEdit;
    function GetChildRows(const AChildRelationName: String): TADDatSView; overload;
    function GetChildRows(AChildTable: TADDatSTable): TADDatSView; overload;
    function GetChildRows(AChildRelation: TADDatSRelation): TADDatSView; overload;
    function GetParentRows(const AParentRelationName: String): TADDatSView; overload;
    function GetParentRows(AParentTable: TADDatSTable): TADDatSView; overload;
    function GetParentRows(AParentRelation: TADDatSRelation): TADDatSView; overload;
    function GetData(const AColumnName: String;
      AVersion: TADDatSRowVersion = rvDefault): Variant; overload;
    function GetData(AColumn: Integer;
      AVersion: TADDatSRowVersion = rvDefault): Variant; overload;
    function GetData(AColumn: TADDatSColumn;
      AVersion: TADDatSRowVersion = rvDefault): Variant; overload;
    function GetData(AColumn: Integer; AVersion: TADDatSRowVersion; var
      ABuff: Pointer; ABuffLen: LongWord; var ADataLen: LongWord; AByVal:
      Boolean): Boolean; overload;
    function HasVersion(AVersion: TADDatSRowVersion): Boolean;
    procedure RejectChanges(AUseCascade: Boolean = True);
    procedure SetData(AColumn: Integer; const AValue: Variant); overload;
    procedure SetData(AColumn: TADDatSColumn; const AValue: Variant); overload;
    procedure SetData(AColumn: Integer; ABuff: Pointer; ADataLen: LongWord); overload;
    procedure SetValues(const AValues: array of Variant);
    function WriteBlobDirect(AColumn, ABlobLen: Integer): PByte;
    procedure BeginForceWrite;
    procedure EndForceWrite;
    procedure DBLock(ALockID: LongWord = $FFFFFFFF);
    procedure DBUnlock;
    function DumpRow(AWithColNames: Boolean = False;
      AVersion: TADDatSRowVersion = rvDefault): String; virtual;
    property DBLockID: LongWord read GetDBLockID;
    property ParentRow: TADDatSRow read GetParentRow write SetParentRow;
    property NestedRow[AColumn: Integer]: TADDatSRow read GetNestedRow write SetNestedRow;
    property NestedRows[AColumn: Integer]: TADDatSNestedRowList read GetNestedRows;
    property Fetched[AColumn: Integer]: Boolean read GetFetched write SetFetched;
    property HasErrors: Boolean read GetHasErrors;
    property RowError: EADException read GetRowError write SetRowErrorPrc;
    property RowList: TADDatSTableRowList read GetRowList;
{$WARNINGS OFF}
    property RowState: TADDatSRowState read FRowState;
    property RowPriorState: TADDatSRowState read FRowPriorState;
{$WARNINGS ON}
    property ValueI[AColumn: Integer; AVersion: TADDatSRowVersion]: Variant read GetDataI;
    property ValueO[AColumn: TADDatSColumn; AVersion: TADDatSRowVersion]: Variant read GetDataO; default;
    property Table: TADDatSTable read FTable;
  end;
  PADDatSRow = ^TADDatSRow;

  TADDatSRowListBase = class (TADDatSList)
  private
    function GetItemsI(AIndex: Integer): TADDatSRow;
    procedure InternalSort1(L, R: Integer; ACompareRowsProc: TADCompareRowsProc;
      AOpts: TADCompareDataOptions);
    procedure InternalSort2(L, H: Integer; ACompareRowsProc: TADCompareRowsProc;
      AOpts: TADCompareDataOptions);
    procedure InternalSort(L, R: Integer; ACompareRowsProc: TADCompareRowsProc;
      AOpts: TADCompareDataOptions);
  protected
    procedure HandleNotification(AParam: PDEDatSNotifyParam); override;
  public
    constructor Create; override;
    function Add(ARow: TADDatSRow): Integer;
    procedure AddAt(ARow: TADDatSRow; APosition: Integer);
    procedure Sort(ACompareRowsProc: TADCompareRowsProc; AOpts: TADCompareDataOptions);
    procedure CheckDuplicates(ACompareRowsProc: TADCompareRowsProc; AOpts: TADCompareDataOptions);
    function GetValuesList(const AColumnName, ADelimiter, ANullName: String): String;
    function DumpCol(ACol: Integer; AWithColNames: Boolean = False): String; virtual;
    property ItemsI[AIndex: Integer]: TADDatSRow read GetItemsI; default;
  end;

  TADDatSNestedRowList = class (TADDatSRowListBase)
  protected
    procedure AddObjectAt(AObj: TADDatSObject; APosition: Integer); override;
  public
    procedure RemoveAt(AIndex: Integer; ANotDestroy: Boolean = False); override;
    constructor CreateForRow(ARow: TADDatSRow);
  end;

  TADDatSRowListWithAggregates = class (TADDatSRowListBase)
  private
    FAggregateValues: TList;
    FAggregateSlots: TBits;
    FAggregateSlotAllocated: Integer;
    FAggregateSlotUsed: Integer;
  protected
    procedure RemoveAggregatesRow(ARowIndex: Integer);
    procedure AddAggregatesRow(ARowIndex: Integer);
    procedure DeleteAggregates;
    procedure ClearAggregate(var AIndex: Integer);
    procedure DeleteAggregate(var AIndex: Integer);
    function AllocateAggregate: Integer;
    procedure AttachAggregate(ARowIndex, AValIndex: Integer; AObj: TADDatSAggregateValue);
    function FetchAggregate(ARowIndex, AValIndex: Integer): TADDatSAggregateValue;
    procedure DetachAggregate(ARowIndex, AValIndex: Integer);
    procedure AddObjectAt(AObj: TADDatSObject; APosition: Integer); override;
  public
    procedure RemoveAt(AIndex: Integer; ANotDestroy: Boolean = False); override;
    constructor Create; overload; override;
    destructor Destroy; override;
  end;

  TADDatSAggregateValue = class (TObject)
  private
    FRefCnt: TADDatSRefCounter;
    FValue: Variant;
    FSubValues: TADVariantArray;
    function GetRefs: Integer;
  protected
    procedure AddRef;
    procedure RemRef;
  public
    constructor Create(ASubAggregateCnt: Integer);
    constructor CreateCopy(AValue: TADDatSAggregateValue);
    destructor Destroy; override;
    procedure Clear;
    property Value: Variant read FValue;
    property Refs: Integer read GetRefs;
  end;

  TADDatSAggregateState = (agActual, agMinMax, agPrepared);
  TADDatSAggregateStates = set of TADDatSAggregateState;

  TADDatSSubAggregate = record
    FKind: TADAggregateKind;
    FValueIndex: Integer;
    FCountIndex: Integer;
  end;

  TADDatSAggregate = class (TADDatSNamedObject)
  private
    FExpression: String;
    FEvaluator: IADStanExpressionEvaluator;
    FActive: Boolean;
    FGroupingLevel: Integer;
    FValueIndex: Integer;
    FState: TADDatSAggregateStates;
    FSubAggregates: array of TADDatSSubAggregate;
    FSubAggregateValues: Integer;
    FCurrentRow: Integer;
    FRefs: TADDatSRefCounter;
    FPrevActualActive: Boolean;
    function GetActualActive: Boolean;
    procedure SetActive(const AValue: Boolean);
    procedure SetExpression(const AValue: String);
    procedure SetGroupingLevel(const AValue: Integer);
    procedure IncAggVals(AKind: TADAggregateKind;
      const AVal: Variant; var AAggVal, AAggCnt: Variant);
    procedure DecAggVals(AKind: TADAggregateKind;
      const AVal: Variant; var AAggVal, AAggCnt: Variant);
    function GetSubAggregateValue(ASubAggregateIndex: Integer): Variant;
    function GetRows: TADDatSRowListWithAggregates;
    function GetValue(ARowIndex: Integer): Variant;
    procedure SetEvaluatorToRow(ARows: TADDatSRowListWithAggregates; ARowIndex: Integer);
    procedure ClearGroup(ARowIndex: Integer; var AGroupFrom, AGroupTo: Integer);
    procedure CalcGroup(AGroupFrom, AGroupTo, AExclude: Integer);
    procedure CalcAll;
    function GetSortMech: IADDataMechSort;
    function GetView: TADDatSView;
    procedure CheckActiveChanged;
    procedure IncRow(ARows: TADDatSRowListWithAggregates;
      ARowIndex: Integer; AVal: TADDatSAggregateValue);
    procedure DecRow(ARows: TADDatSRowListWithAggregates;
      ARowIndex: Integer; AVal: TADDatSAggregateValue);
    function GetIsRefCounted: Boolean;
    function GetDataType: TADDataType;
  protected
    procedure Prepare;
    procedure Unprepare;
    procedure RowInserted(ARowIndex: Integer);
    procedure RowDeleted(ARowIndex: Integer);
    procedure RowUpdated(ARowIndex, AOldRowIndex: Integer);
    procedure DoListInserted; override;
    procedure DoListRemoving; override;
  public
    constructor Create; overload; override;
    constructor Create(const AName, AExpression: String;
      AGroupingLevel: Integer = 0); overload;
    destructor Destroy; override;
    procedure Assign(AObj: TADDatSObject); override;
    function IsEqualTo(AObj: TADDatSObject): Boolean; override;
    procedure CountRef(AInit: Integer = 1);
    procedure AddRef;
    procedure RemRef;
    procedure Recalc;
    procedure Update;
    // ro
    property ActualActive: Boolean read GetActualActive;
    property SortMech: IADDataMechSort read GetSortMech;
    property Rows: TADDatSRowListWithAggregates read GetRows;
    property View: TADDatSView read GetView;
    property State: TADDatSAggregateStates read FState;
    property DataType: TADDataType read GetDataType;
    property Value[ARowIndex: Integer]: Variant read GetValue;
    property IsRefCounted: Boolean read GetIsRefCounted;
    // rw
    property Expression: String read FExpression write SetExpression;
    property GroupingLevel: Integer read FGroupingLevel write SetGroupingLevel default 0;
    property Active: Boolean read FActive write SetActive default False;
  end;

  TADDatSAggregateList = class (TADDatSNamedList)
  private
    function GetItemsI(AIndex: Integer): TADDatSAggregate;
  protected
    procedure RowInserted(ARowIndex: Integer);
    procedure RowDeleted(ARowIndex: Integer);
    procedure RowUpdated(ARowIndex, AOldRowIndex: Integer);
  public
    constructor CreateForView(AOwner: TADDatSView);
    function Add(AObj: TADDatSAggregate): Integer; overload;
    function Add(const AName, AExpression: String;
      AGroupingLevel: Integer = 0): TADDatSAggregate; overload;
    function AggregateByName(const AName: String): TADDatSAggregate;
    procedure Update;
    procedure Recalc;
    property ItemsI[AIndex: Integer]: TADDatSAggregate read GetItemsI;
    property ItemsS[const AName: String]: TADDatSAggregate read AggregateByName;
  end;

  TADDatSViewRowList = class (TADDatSRowListWithAggregates)
  public
    constructor CreateForView(AView: TADDatSView);
  end;

  TADDatSView = class (TADDatSNamedObject)
  private
    FActive: Boolean;
    FPrevActualActive: Boolean;
    FMechanisms: TADDatSViewMechList;
    FRows: TADDatSRowListBase;
    FSourceView: TADDatSView;
    FState: TADDatSViewStates;
    FCreator: TADDatSViewCreator;
    FRefs: TADDatSRefCounter;
    FAggregates: TADDatSAggregateList;
    FSortingMechanism: IADDataMechSort;
    FProposedPosition: Integer;
    FLastUpdatePosition: Integer;
    procedure CheckRebuild;
    procedure InvalidateRebuild;
    function GetActual: Boolean;
    function GetViewList: TADDatSViewList;
    function ProcessRow(ARow: TADDatSRow; var ANewPos, AOldPos: Integer;
      AAdding: Boolean): TADDatSViewProcessRowStatus;
    procedure SetActive(const AValue: Boolean);
    procedure SetSourceView(const AValue: TADDatSView);
    procedure UpdateSortingMechanism(AExcludeView: TADDatSView);
    function GetGroupingLevel: Integer;
    function GetRowFilter: String;
    function GetRowStateFilter: TADDatSRowStates;
    function GetSort: String;
    procedure SetRowFilter(const AValue: String);
    procedure SetRowStateFilter(const AValue: TADDatSRowStates);
    procedure SetSort(const AValue: String);
    function GetMechanismByClass(AClass: TADDatSMechBaseClass;
      AKind: TADDatSMechanismKind): TADDatSMechBase;
    procedure CheckActiveChanged;
    function GetIsRefCounted: Boolean;
    function GetActualActive: Boolean;
    procedure DoRowAdded(ARow: TADDatSRow);
    procedure DoRowChanged(ARow: TADDatSRow);
    procedure DoRowDeleted(ARow: TADDatSRow);
  protected
    procedure DoListInserted; override;
    procedure DoListRemoving; override;
    procedure HandleNotification(AParam: PDEDatSNotifyParam); override;
    function GetTable: TADDatSTable; override;
  public
    constructor Create; overload; override;
    constructor Create(ATable: TADDatSTable; const AFilter: String = '';
      const ASort: String = ''; AStates: TADDatSRowStates = []); overload;
    constructor Create(ATable: TADDatSTable; const ABaseName: String;
      ACreator: TADDatSViewCreator; ACountRef: Boolean = True); overload;
    destructor Destroy; override;
    procedure Assign(AObj: TADDatSObject); override;
    function IsEqualTo(AObj: TADDatSObject): Boolean; override;
    procedure CountRef(AInit: Integer = 1);
    procedure AddRef;
    procedure RemRef;
    procedure Clear;
    procedure Rebuild;
    function Search(AKeyRow: TADDatSRow; AKeyColumnList,
      AKeyColumnList2: TADDatSColumnSublist; AKeyColumnCount: Integer;
      AOptions: TADLocateOptions; var AIndex: Integer; var AFound: Boolean;
      ARowVersion: TADDatSRowVersion = rvDefault): Integer;
    function IndexOf(AKeyRow: TADDatSRow; ARowVersion: TADDatSRowVersion = rvDefault): Integer; overload;
    function Find(const AValues: array of Variant;
      AOptions: TADLocateOptions {$IFDEF AnyDAC_D6Base} = [] {$ENDIF}): Integer; overload;
    function Find(ARow: TADDatSRow;
      AOptions: TADLocateOptions {$IFDEF AnyDAC_D6Base} = [] {$ENDIF}): Integer; overload;
    function Find(const AValues: array of Variant; const AColumns: String;
      AOptions: TADLocateOptions {$IFDEF AnyDAC_D6Base} = [] {$ENDIF}): Integer; overload;
    function Find(ARow: TADDatSRow; const AColumns: String;
      AOptions: TADLocateOptions {$IFDEF AnyDAC_D6Base} = [] {$ENDIF}): Integer; overload;
    function Locate(var ARowIndex: Integer; AGoForward: Boolean = True;
      ARestart: Boolean = False): Boolean;
    function GetGroupState(ARecordIndex, AGroupingLevel: Integer): TADDatSGroupPositions;
    procedure DeleteAll;
    // ro
    property ActualActive: Boolean read GetActualActive;
    property Actual: Boolean read GetActual;
    property SortingMechanism: IADDataMechSort read FSortingMechanism;
    property GroupingLevel: Integer read GetGroupingLevel;
    property Mechanisms: TADDatSViewMechList read FMechanisms;
    property Rows: TADDatSRowListBase read FRows;
    property ViewList: TADDatSViewList read GetViewList;
    property Aggregates: TADDatSAggregateList read FAggregates;
    property IsRefCounted: Boolean read GetIsRefCounted;
    property LastUpdatePosition: Integer read FLastUpdatePosition;
    // rw
    property Active: Boolean read FActive write SetActive;
    property Creator: TADDatSViewCreator read FCreator write FCreator;
    property SourceView: TADDatSView read FSourceView write SetSourceView;
    property RowFilter: String read GetRowFilter write SetRowFilter;
    property RowStateFilter: TADDatSRowStates read GetRowStateFilter
      write SetRowStateFilter default [];
    property Sort: String read GetSort write SetSort;
    property ProposedPosition: Integer read FProposedPosition
      write FProposedPosition;
  end;

  TADDatSViewList = class (TADDatSNamedList)
  private
    FActive: Boolean;
    function GetItemsI(AIndex: Integer): TADDatSView;
    procedure SetActive(const AValue: Boolean);
  protected
    procedure HandleNotification(AParam: PDEDatSNotifyParam); override;
  public
    constructor CreateForTable(ATable: TADDatSTable);
    procedure Assign(AObj: TADDatSObject); override;
    function Add(AObj: TADDatSView): Integer; overload;
    function Add(const AName: String): TADDatSView; overload;
    procedure Clear; override;
    function ViewByName(const AName: String): TADDatSView;
    function FindSortedView(const AColumns: String;
      ARequiredOptions, AProhibitedOptions: TADSortOptions): TADDatSView;
    procedure Rebuild;
    property ItemsI[AIndex: Integer]: TADDatSView read GetItemsI; default;
    property ItemsS[const AName: String]: TADDatSView read ViewByName;
    property Active: Boolean read FActive write SetActive;
  end;

  TADDatSTableRowList = class (TADDatSRowListWithAggregates)
  private
    FLastRowID: LongWord;
    FRowIDOrdered: Boolean;
  protected
    procedure AddObjectAt(AObj: TADDatSObject; APosition: Integer); override;
  public
    constructor CreateForTable(ATable: TADDatSTable);
    function Add(const AValues: array of Variant): TADDatSRow; overload;
    procedure RemoveAt(AIndex: Integer; ANotDestroy: Boolean = False); override;
    function IndexOf(AObj: TADDatSObject): Integer; override;
    procedure Clear; override;
    property Capacity;
  end;

  IADDataTableCallback = interface (IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2020}']
    procedure DescribeColumn(AColumn: TADDatSColumn; var AOptions: TADDataOptions);
  end;

  TADDatSTable = class (TADDatSBindedObject)
  private
    FColumns: TADDatSColumnList;
    FConstraints: TADDatSConstraintList;
    FDefaultView: TADDatSView;
    FErrors: TADDatSView;
    FChanges: TADDatSView;
    FRows: TADDatSTableRowList;
    FViews: TADDatSViewList;
    FUpdates: TADDatSUpdatesJournal;
    FUpdatesRegistry: Boolean;
    FDataHandleMode: TADDatSHandleMode;
    FRefs: TADDatSRefCounter;
    FManager: TADDatSManager;
    FLocale: LCID;
    FCaseSensitive: Boolean;
    FNested: Boolean;
    FBlobs: TADDatSBlobCache;
    FCallback: IADDataTableCallback;
    function GetDefaultView: TADDatSView;
    function GetEnforceConstraints: Boolean;
    function GetHasErrors: Boolean;
    function GetTableList: TADDatSTableList;
    procedure SetEnforceConstraints(const AValue: Boolean);
    procedure SetMinimumCapacity(const AValue: Integer);
    function GetChanges2: TADDatSView;
    function GetChildRelations: TADDatSRelationArray;
    function GetParentRelations: TADDatSRelationArray;
    procedure SetLocale(const AValue: LCID);
    procedure SetCaseSensitive(const AValue: Boolean);
    function GetPrimaryKey: String;
    procedure SetPrimaryKey(const AValue: String);
    function GetMinimumCapacity: Integer;
    function GetIsRefCounted: Boolean;
  protected
    procedure HandleNotification(AParam: PDEDatSNotifyParam); override;
    function GetTable: TADDatSTable; override;
    function GetManager: TADDatSManager; override;
    procedure DoListInserted; override;
    procedure DoListRemoving; override;
    procedure DoListRemoved(ANewOwner: TADDatSObject); override;
    function FindRowByPK(ARow: TADDatSRow): Integer;
    procedure CheckStructureChanging;
  public
    constructor Create; overload; override;
    constructor Create(const AName: String); overload;
    destructor Destroy; override;
    procedure AddRef;
    procedure CountRef(AInit: Integer = 1);
    procedure RemRef;
    procedure Assign(AObj: TADDatSObject); override;
    function IsEqualTo(AObj: TADDatSObject): Boolean; override;
    procedure AcceptChanges;
    procedure BeginLoadData(ADataHandleMode: TADDatSHandleMode = lmHavyMove);
    procedure Clear;
    function Compute(const AExpression, AFilter: String): Variant;
    function Copy: TADDatSTable;
    procedure EndLoadData;
    function GetChangesView(ARowStates: TADDatSRowStates =
      [rsInserted, rsDeleted, rsModified]): TADDatSView;
    function GetChanges(ARowStates: TADDatSRowStates =
      [rsInserted, rsDeleted, rsModified]): TADDatSTable;
    function GetErrors: TADDatSView;
    function HasChanges(ARowStates: TADDatSRowStates): Boolean;
    procedure ImportRow(ASrcRow: TADDatSRow);
    procedure Import(ASrcRow: TADDatSRow; ADestRow: TADDatSRow = nil); overload;
    procedure Import(ARowList: TADDatSRowListBase); overload;
    procedure Import(AView: TADDatSView); overload;
    procedure Import(ATable: TADDatSTable); overload;
    function LoadDataRow(const AValues: array of Variant; AAcceptChanges: Boolean = False): TADDatSRow;
    function NewRow(ASetToDefaults: Boolean {$IFDEF AnyDAC_D6Base} = True {$ENDIF}): TADDatSRow; overload;
    function NewRow(ASetToDefaults: Boolean; const AParentRows: array of TADDatSRow): TADDatSRow; overload;
    function NewRow(const AValues: array of Variant; ASetToDefaults: Boolean {$IFDEF AnyDAC_D6Base} = True {$ENDIF}): TADDatSRow; overload;
    procedure RejectChanges;
    procedure Reset;
    function Select(const AFilter: String = ''; const ASort: String = '';
      AStates: TADDatSRowStates = []): TADDatSView;
    // ro
    property Changes: TADDatSView read GetChanges2;
    property ChildRelations: TADDatSRelationArray read GetChildRelations;
    property Columns: TADDatSColumnList read FColumns;
    property Constraints: TADDatSConstraintList read FConstraints;
    property DataHandleMode: TADDatSHandleMode read FDataHandleMode;
    property DefaultView: TADDatSView read GetDefaultView;
    property Errors: TADDatSView read GetErrors;
    property HasErrors: Boolean read GetHasErrors;
    property ParentRelations: TADDatSRelationArray read GetParentRelations;
    property Rows: TADDatSTableRowList read FRows;
    property Manager: TADDatSManager read FManager;
    property TableList: TADDatSTableList read GetTableList;
    property Views: TADDatSViewList read FViews;
    property Updates: TADDatSUpdatesJournal read FUpdates;
    property UpdatesRegistry: Boolean read FUpdatesRegistry;
    property IsRefCounted: Boolean read GetIsRefCounted;
    // rw
    property Callback: IADDataTableCallback read FCallback write FCallback;
    property CaseSensitive: Boolean read FCaseSensitive write SetCaseSensitive
      default True;
    property EnforceConstraints: Boolean read GetEnforceConstraints write
      SetEnforceConstraints default True;
    property Locale: LCID read FLocale write SetLocale default LOCALE_USER_DEFAULT;
    property MinimumCapacity: Integer read GetMinimumCapacity write SetMinimumCapacity
      default 0;
    property Nested: Boolean read FNested write FNested;
    property PrimaryKey: String read GetPrimaryKey write SetPrimaryKey;
  end;

  TADDatSTableList = class (TADDatSBindedList)
  private
    function GetItemsI(AIndex: Integer): TADDatSTable;
  public
    constructor CreateForManager(AManager: TADDatSManager);
    function Add(AObj: TADDatSTable): Integer; overload;
    function Add(const AName: String = ''): TADDatSTable; overload;
    function TableByName(const AName: String): TADDatSTable;
    property ItemsI[AIndex: Integer]: TADDatSTable read GetItemsI; default;
    property ItemsS[const AName: String]: TADDatSTable read TableByName;
  end;

  PDEDataUpdateItem = ^TADDatSUpdateItem;
  TADDatSUpdateItem = packed record
    Row: TADDatSRow;
    ChangeNumber: Integer;
  end;

  TADDatSUpdatesJournal = class (TObject)
  private
    FChangeNumber: LongWord;
    FOwner: TADDatSObject;
    FFirstChange, FLastChange, FTmpNextRow: TADDatSRow;
    procedure SetSavePoint(const AValue: LongWord);
  public
    constructor Create(AOwner: TADDatSObject);
    function RegisterRow(ARow: TADDatSRow): Integer;
    procedure UnregisterRow(ARow: TADDatSRow);
    procedure AcceptChanges(AOwner: TADDatSObject = nil);
    procedure RejectChanges(AOwner: TADDatSObject = nil);
    function HasChanges(AOwner: TADDatSObject = nil): Boolean;
    function FirstChange(AOwner: TADDatSObject = nil): TADDatSRow;
    function NextChange(ACurRow: TADDatSRow; AOwner: TADDatSObject = nil): TADDatSRow;
    function LastChange(AOwner: TADDatSObject = nil): TADDatSRow;
    function GetCount(AOwner: TADDatSObject = nil): Integer;
    property SavePoint: LongWord read FChangeNumber write SetSavePoint;
  end;

  TADStreamFormat = (sfXMLDiffGram, sfXMLStandard,
    sfBinDiffGram, sfBinStandard);
  TADDatSTableArray = array of TADDatSTable;

  TADDatSManager = class (TADDatSNamedObject)
  private
    FEnforceConstraints: Boolean;
    FRelations: TADDatSRelationList;
    FTables: TADDatSTableList;
    FUpdates: TADDatSUpdatesJournal;
    FUpdatesRegistry: Boolean;
    FRefs: TADDatSRefCounter;
    FCaseSensitive: Boolean;
    FLocale: LCID;
    function GetHasErrors: Boolean;
    procedure SetEnforceConstraints(const AValue: Boolean);
    function GetRootTables: TADDatSTableArray;
    procedure SetUpdatesRegistry(const AValue: Boolean);
    procedure SetCaseSensitive(const AValue: Boolean);
    procedure SetLocale(const AValue: LCID);
    function GetIsRefCounted: Boolean;
    function GetRefs: Integer;
  protected
    procedure HandleNotification(AParam: PDEDatSNotifyParam); override;
    function GetManager: TADDatSManager; override;
  public
    constructor Create; overload; override;
    destructor Destroy; override;
    procedure Assign(AObj: TADDatSObject); override;
    function IsEqualTo(AObj: TADDatSObject): Boolean; override;
    procedure CountRef(AInit: Integer = 1);
    procedure AddRef;
    procedure RemRef;
    procedure AcceptChanges;
    procedure BeginLoadData(ADataHandleMode: TADDatSHandleMode = lmHavyMove);
    procedure Clear;
    function Copy: TADDatSManager;
    procedure EndLoadData;
    function HasChanges(ARowStates: TADDatSRowStates): Boolean;
    procedure Merge(ARow: TADDatSRow; AOptions: TADDatSMergeOptions); overload;
    procedure Merge(AManager: TADDatSManager; AOptions: TADDatSMergeOptions); overload;
    procedure Merge(ATable: TADDatSTable; AOptions: TADDatSMergeOptions); overload;
    procedure RejectChanges; 
    procedure Reset;
    procedure SaveToStream(AStream: TStream; AFormat: TADStreamFormat);
    procedure LoadFromStream(AStream: TStream; AFormat: TADStreamFormat);
    // ro
    property HasErrors: Boolean read GetHasErrors;
    property Relations: TADDatSRelationList read FRelations;
    property Tables: TADDatSTableList read FTables;
    property Updates: TADDatSUpdatesJournal read FUpdates;
    property RootTables: TADDatSTableArray read GetRootTables;
    property IsRefCounted: Boolean read GetIsRefCounted;
    property Refs: Integer read GetRefs;
    // rw
    property CaseSensitive: Boolean read FCaseSensitive write SetCaseSensitive
      default True;
    property EnforceConstraints: Boolean read FEnforceConstraints
      write SetEnforceConstraints default True;
    property Locale: LCID read FLocale write SetLocale default LOCALE_USER_DEFAULT;
    property UpdatesRegistry: Boolean read FUpdatesRegistry
      write SetUpdatesRegistry default False;
  end;

var
  ADEmptyCC: TADDatSCompareRowsCache;

implementation

Uses
  SysUtils,
{$IFDEF AnyDAC_D6Base}
  Variants,
  {$IFDEF AnyDAC_D6}
  FmtBcd, SqlTimSt,
  {$ENDIF}
{$ELSE}
  ActiveX, ComObj, DB,
{$ENDIF}
  daADStanConst, daADStanFactory, daADStanResStrs;

type
  TADBlobData = record
    FData: PByte;
    FLength: Integer;
  end;
  PDEBlobData = ^TADBlobData;

{-------------------------------------------------------------------------------}
{- TADDatSRefCounter                                                           -}
{-------------------------------------------------------------------------------}
constructor TADDatSRefCounter.Create(AOwner: TObject);
begin
  ASSERT(AOwner <> nil);
  inherited Create;
  FRefs := -1;
  FOwner := AOwner;
end;

{-------------------------------------------------------------------------------}
destructor TADDatSRefCounter.Destroy;
begin
  FRefs := -1;
  FOwner := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRefCounter.CountRef(AInit: Integer);
begin
  ASSERT(AInit >= 0);
  if FRefs = -1 then
    FRefs := AInit;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRefCounter.AddRef;
begin
  if FRefs >= 0 then
    Inc(FRefs);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRefCounter.RemRef;
begin
  if FRefs > 0 then begin
    Dec(FRefs);
    if FRefs = 0 then
      FOwner.Free;
  end;
end;

{-------------------------------------------------------------------------------}
{- TADDatSObject                                                               -}
{-------------------------------------------------------------------------------}
constructor TADDatSObject.Create;
begin
  inherited Create;
end;

{-------------------------------------------------------------------------------}
destructor TADDatSObject.Destroy;
begin
  if (FOwner <> nil) and (FOwner is TADDatSList) then
    TADDatSList(FOwner).Remove(Self, True);
  FOwner := nil;
  FLockNotificationCount := 0;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSObject.Assign(AObj: TADDatSObject);
begin
  // nothing
  ASSERT(False);
end;
    
{-------------------------------------------------------------------------------}
function TADDatSObject.IndexOf(AObj: TADDatSObject): Integer;
begin
  Result := -1;
end;

{-------------------------------------------------------------------------------}
function TADDatSObject.GetIndex: Integer;
begin
  if FOwner <> nil then
    Result := FOwner.IndexOf(Self)
  else
    Result := 0;
end;

{-------------------------------------------------------------------------------}
function TADDatSObject.GetList: TADDatSList;
begin
  Result := TADDatSList(GetOwnerByClass(TADDatSList));
end;

{-------------------------------------------------------------------------------}
function TADDatSObject.GetOwnerByClass(AClass: TADDatSObjectClass): TADDatSObject;
begin
  ASSERT(AClass <> nil);
  Result := Owner;
  while (Result <> nil) and not Result.ClassType.InheritsFrom(AClass) do
    Result := Result.Owner;
end;

{-------------------------------------------------------------------------------}
function TADDatSObject.GetManager: TADDatSManager;
begin
  Result := TADDatSManager(GetOwnerByClass(TADDatSManager));
end;

{-------------------------------------------------------------------------------}
function TADDatSObject.GetTable: TADDatSTable;
begin
  Result := TADDatSTable(GetOwnerByClass(TADDatSTable));
end;

{-------------------------------------------------------------------------------}
procedure TADDatSObject.HandleNotification(AParam: PDEDatSNotifyParam);
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
function TADDatSObject.IsEqualTo(AObj: TADDatSObject): Boolean;
begin
  Result := ((Self = nil) and (AObj = nil) or
    (Self <> nil) and (AObj <> nil) and (Self.ClassType = AObj.ClassType));
end;

{-------------------------------------------------------------------------------}
procedure TADDatSObject.LockNotification;
begin
  ASSERT(FLockNotificationCount < $FFFF);
  Inc(FLockNotificationCount);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSObject.Notify(AKind: TADDatSNotificationKind;
  AReason: TADDatSNotificationReason; AParam1, AParam2: LongWord);
var
  rParam: TADDatSNotifyParam;
begin
  with rParam do begin
    FKind := AKind;
    FReason := AReason;
    FParam1 := AParam1;
    FParam2 := AParam2;
  end;
  Notify(@rParam);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSObject.Notify(AParam: PDEDatSNotifyParam);
begin
  if FLockNotificationCount = 0 then
    // MSGOPT second condition is only for optimization
    if (Owner <> nil) and (AParam^.FKind <> snObjectInserting) then
      Owner.Notify(AParam)
    else
      HandleNotification(AParam);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSObject.UnlockNotification;
begin
  if FLockNotificationCount > 0 then
    Dec(FLockNotificationCount);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSObject.DoListInserted;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADDatSObject.DoListInserting;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADDatSObject.DoListRemoved(ANewOwner: TADDatSObject);
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADDatSObject.DoListRemoving;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
{- TADDatSList                                                                 -}
{-------------------------------------------------------------------------------}
constructor TADDatSList.Create;
begin
  inherited Create;
end;

{-------------------------------------------------------------------------------}
destructor TADDatSList.Destroy;
begin
  LockNotification;
  Clear;
  SetLength(FArray, 0);
  FCount := 0;
  FCapacity := 0;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADDatSList.AddObject(AObj: TADDatSObject): Integer;
begin
  Result := Count;
  AddObjectAt(AObj, -1);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSList.AddEx(AObj: TADDatSObject);
begin
  try
    AddObjectAt(AObj, -1);
  except
    AObj.Free;
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSList.AddObjectAt(AObj: TADDatSObject; APosition: Integer);
var
  oList: TADDatSList;
  prevOwnObjects: Boolean;
begin
  ASSERT((AObj <> nil) and (
    not OwnObjects or
    (AObj.Owner = nil) or
    (AObj.Owner = Owner)
  ));
  ASSERT((APosition >= -1) and (APosition <= FCount));
  if OwnObjects then begin
    Notify(snObjectInserting, FDefaultReason, Integer(Self), Integer(AObj));
    if (AObj.Owner <> nil) and (AObj.Owner is TADDatSList) then begin
      oList := TADDatSList(AObj.Owner);
      prevOwnObjects := oList.OwnObjects;
      oList.OwnObjects := False;
      try
        oList.Remove(AObj);
      finally
        oList.OwnObjects := prevOwnObjects;
      end;
    end;
  end;
  if FCapacity = FCount then begin
    if FCapacity > 64 then
      Inc(FCapacity, FCapacity div 4)
    else if FCapacity > 8 then
      Inc(FCapacity, 16)
    else
      Inc(FCapacity, 4);
    SetLength(FArray, FCapacity);
  end;
  if (APosition = -1) or (APosition = FCount) then
    FArray[FCount] := AObj
  else begin
    ADMove(FArray[APosition], FArray[APosition + 1], (FCount - APosition) * SizeOf(TADDatSObject));
    FArray[APosition] := AObj;
  end;
  Inc(FCount);
  if OwnObjects then begin
    AObj.FOwner := Self;
    Notify(snObjectInserted, FDefaultReason, Integer(Self), Integer(AObj));
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSList.Copy(ASource: TADDatSList);
begin
  FArray := System.Copy(ASource.FArray);
  FCount := ASource.FCount;
  FCapacity := ASource.FCapacity;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSList.Assign(AObj: TADDatSObject);
var
  i: Integer;
  oObj: TADDatSObject;
begin
  ASSERT(FOwnObjects);
  Clear;
  if AObj is TADDatSList then begin
    MinimumCapacity := TADDatSList(AObj).MinimumCapacity;
    Capacity := TADDatSList(AObj).Capacity;
    for i := 0 to TADDatSList(AObj).Count - 1 do begin
      oObj := TADDatSObjectClass(TADDatSList(AObj).ItemsI[i].ClassType).Create;
      AddObject(oObj);
      oObj.Assign(TADDatSList(AObj).ItemsI[i]);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSList.Clear;
begin
  if OwnObjects then
    while Count > 0 do
      RemoveAt(Count - 1)
  else
    FCount := 0;
  Capacity := MinimumCapacity;
end;

{-------------------------------------------------------------------------------}
function TADDatSList.ContainsObj(AObj: TADDatSObject): Boolean;
begin
  Result := IndexOf(AObj) <> -1;
end;

{-------------------------------------------------------------------------------}
function TADDatSList.GetItemsI(AIndex: Integer): TADDatSObject;
begin
  ASSERT((AIndex >= 0) and (AIndex < FCount));
  Result := FArray[AIndex];
end;

{-------------------------------------------------------------------------------}
procedure TADDatSList.Notify(AParam: PDEDatSNotifyParam);
begin
  with AParam^ do
    if FParam1 = LongWord(Self) then
      case FKind of
      snObjectRemoving:
        TADDatSObject(FParam2).DoListRemoving;
      snObjectRemoved:
        TADDatSObject(FParam2).DoListRemoved(Owner);
      snObjectInserting:
        TADDatSObject(FParam2).DoListInserting;
      snObjectInserted:
        TADDatSObject(FParam2).DoListInserted;
      end;
  inherited Notify(AParam);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSList.HandleNotification(AParam: PDEDatSNotifyParam);
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    FArray[i].HandleNotification(AParam);
end;

{-------------------------------------------------------------------------------}
function TADDatSList.IndexOf(AObj: TADDatSObject): Integer;
begin
  ASSERT(AObj <> nil);
  Result := ADIndexOf(FArray, FCount, AObj);
end;

{-------------------------------------------------------------------------------}
function TADDatSList.IsEqualTo(AObj: TADDatSObject): Boolean;
var
  i: Integer;
begin
  Result := inherited IsEqualTo(AObj);
  if Result then begin
    ASSERT(AObj <> nil);
    Result := (Count = TADDatSList(AObj).Count);
    if Result then begin
      for i := 0 to Count - 1 do
        if not ItemsI[i].IsEqualTo(TADDatSList(AObj).ItemsI[i]) then begin
          Result := False;
          Exit;
       end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSList.Remove(AObj: TADDatSObject; ANotDestroy: Boolean = False): Integer;
begin
  Result := IndexOf(AObj);
  if Result <> -1 then
    RemoveAt(Result, ANotDestroy);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSList.RemoveAt(AIndex: Integer; ANotDestroy: Boolean = False);
var
  oObj: TADDatSObject;
begin
  ASSERT((AIndex >= 0) and (AIndex < FCount));
  oObj := FArray[AIndex];
  if OwnObjects then
    Notify(snObjectRemoving, FDefaultReason, Integer(Self), Integer(oObj));
  if FCount - AIndex - 1 > 0 then
    ADMove(FArray[AIndex + 1], FArray[AIndex], (FCount - AIndex - 1) * SizeOf(TADDatSObject));
  Dec(FCount);
  if OwnObjects then begin
    oObj.FOwner := nil;
    try
      Notify(snObjectRemoved, FDefaultReason, Integer(Self), Integer(oObj));
    finally
      if not ANotDestroy then
        oObj.Free;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSList.SetCapacity(const AValue: Integer);
begin
  ASSERT((AValue <= MAXINT div SizeOf(Pointer)) and (AValue >= 0));
  if FCapacity <> AValue then begin
    SetLength(FArray, AValue);
    FCapacity := AValue;
    if FCount > FCapacity then
      FCount := FCapacity;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSList.SetMinimumCapacity(const AValue: Integer);
begin
  ASSERT((AValue <= MAXINT div SizeOf(Pointer)) and (AValue >= 0));
  if FMinimumCapacity <> AValue then begin
    FMinimumCapacity := AValue;
    if FMinimumCapacity > Capacity then
      Capacity := FMinimumCapacity;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSList.Move(AFromIndex, AToIndex: Integer);
var
  oObj: TADDatSObject;
begin
  ASSERT((AFromIndex >= 0) and (AFromIndex < FCount));
  ASSERT((AToIndex >= 0) and (AToIndex < FCount));
  oObj := FArray[AFromIndex];
  if AFromIndex < AToIndex then
    ADMove(FArray[AFromIndex + 1], FArray[AFromIndex], (AToIndex - AFromIndex) * SizeOf(TADDatSObject))
  else if AFromIndex > AToIndex then
    ADMove(FArray[AToIndex], FArray[AToIndex + 1], (AFromIndex - AToIndex) * SizeOf(TADDatSObject));
  FArray[AToIndex] := oObj;
end;

{-------------------------------------------------------------------------------}
{- TADDatSNamedObject                                                          -}
{-------------------------------------------------------------------------------}
constructor TADDatSNamedObject.Create;
begin
  inherited Create;
  SetDefaultName;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSNamedObject.Assign(AObj: TADDatSObject);
var
  oList: TADDatSNamedList;
begin
  if AObj is TADDatSNamedObject then begin
    oList := NamedList;
    if oList <> nil then
      Name := oList.BuildUniqueName(TADDatSNamedObject(AObj).Name)
    else
      Name := TADDatSNamedObject(AObj).Name;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSNamedObject.IsEqualTo(AObj: TADDatSObject): Boolean;
begin
  Result := inherited IsEqualTo(AObj);
  if Result then begin
    ASSERT(AObj <> nil);
    Result := TADDatSNamedObject(AObj).Name = Name;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSNamedObject.GetNamedList: TADDatSNamedList;
begin
  Result := TADDatSNamedList(GetOwnerByClass(TADDatSNamedList));
end;

{-------------------------------------------------------------------------------}
procedure TADDatSNamedObject.SetDefaultName;
var
  s: String;
begin
  s := UpperCase(ClassName);
  if (Length(s) > 9) and (Copy(s, 1, 7) = 'TADDATA') and (Copy(s, Length(s) - 1, 2) = '') then
    s := Copy(ClassName, 8, Length(s) - 9)
  else
    s := ClassName;
  FName := s;
  FPrevName := '';
end;

{-------------------------------------------------------------------------------}
procedure TADDatSNamedObject.SetName(const AValue: String);
var
  oList: TADDatSNamedList;
begin
  if FName <> AValue then begin
    oList := NamedList;
    if oList <> nil then
      oList.CheckUniqueName(AValue, Self);
    FPrevName := FName;
    FName := AValue;
    try
      try
        if FPrevName <> '' then
          Notify(snObjectNameChanged, srMetaChange, Integer(Self), Integer(PrevName));
      except
        FName := FPrevName;
        raise;
      end;
    finally
      FPrevName := FName;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
{- TADDatSNamedList                                                            -}
{-------------------------------------------------------------------------------}
constructor TADDatSNamedList.Create;
begin
  inherited Create;
  FNamesIndex := TADStringList.Create;
  FNamesIndex.Duplicates := dupAccept;
  FNamesIndex.Sorted := True;
  FDefaultReason := srMetaChange;
end;

{-------------------------------------------------------------------------------}
destructor TADDatSNamedList.Destroy;
begin
  inherited Destroy;
  FreeAndNil(FNamesIndex);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSNamedList.AddObjectAt(AObj: TADDatSObject; APosition: Integer);
begin
  ASSERT(AObj <> nil);
  with TADDatSNamedObject(AObj) do
    if FPrevName = '' then
      Name := BuildUniqueName(Name);
  inherited AddObjectAt(AObj, APosition);
end;

{-------------------------------------------------------------------------------}
function TADDatSNamedList.Find(const AName: String; var AIndex: Integer): Boolean;
begin
  Result := FNamesIndex.Find({$IFDEF AnyDAC_NOLOCALE_META} UpperCase {$ELSE} AnsiUpperCase {$ENDIF}
    (AName), AIndex);
  if not Result then
    AIndex := -1;
end;

{-------------------------------------------------------------------------------}
function TADDatSNamedList.FindRealIndex(const AName: String;
  var AIndex: Integer): Boolean;
begin
  Result := Find(AName, AIndex);
  if Result then
    AIndex := TADDatSNamedObject(FNamesIndex.Objects[AIndex]).Index;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSNamedList.CheckUniqueName(const AName: String; ASelf: TADDatSNamedObject);
  procedure ErrorDubName;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_DuplicatedName, [AName]);
  end;
var
  i: Integer;
begin
  i := -1;
  if (AName <> '') and FindRealIndex(AName, i) and (ASelf <> ItemsI[i]) then
    ErrorDubName;
end;

{-------------------------------------------------------------------------------}
function TADDatSNamedList.ContainsName(const AName: String): Boolean;
var
  i: Integer;
begin
  i := -1;
  Result := Find(AName, i);
end;

{-------------------------------------------------------------------------------}
function TADDatSNamedList.GetItemsI(AIndex: Integer): TADDatSNamedObject;
begin
  ASSERT((AIndex >= 0) and (AIndex < FCount));
  Result := TADDatSNamedObject(FArray[AIndex]);
end;

{-------------------------------------------------------------------------------}
function TADDatSNamedList.IndexOfName(const AName: String): Integer;
begin
  Result := -1;
  FindRealIndex(AName, Result);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSNamedList.ErrorNameNotFound(const AName: String);
begin
  ADException(Self, [S_AD_LDatS], er_AD_NameNotFound, [AName]);
end;

{-------------------------------------------------------------------------------}
function TADDatSNamedList.ItemByName(const AName: String): TADDatSNamedObject;
var
  i: Integer;
begin
  i := -1;
  if not Find(AName, i) then
    ErrorNameNotFound(AName);
  Result := TADDatSNamedObject(FNamesIndex.Objects[i]);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSNamedList.Notify(AParam: PDEDatSNotifyParam);

  procedure DoObjectChanged;
  var
    sName: String;
    i: Integer;
  begin
    with AParam^ do
      if FKind = snObjectInserting then begin
        sName := TADDatSNamedObject(FParam2).Name;
        if sName <> '' then
          CheckUniqueName(sName, TADDatSNamedObject(FParam2));
      end
      else if FKind = snObjectRemoved then begin
        sName := TADDatSNamedObject(FParam2).Name;
        i := -1;
        if (sName <> '') and FNamesIndex.Find(
           {$IFDEF AnyDAC_NOLOCALE_META} UpperCase {$ELSE} AnsiUpperCase {$ENDIF}(sName), i) then
          FNamesIndex.Delete(i);
      end
      else if FKind = snObjectInserted then begin
        sName := TADDatSNamedObject(FParam2).Name;
        if sName <> '' then
          FNamesIndex.AddObject(
            {$IFDEF AnyDAC_NOLOCALE_META} UpperCase {$ELSE} AnsiUpperCase {$ENDIF}(sName), TADDatSNamedObject(FParam2));
      end;
  end;

  procedure DoObjectRenamed;
  var
    oObj: TADDatSNamedObject;
    sPrevName: String;
    i: Integer;
  begin
    oObj := TADDatSNamedObject(AParam^.FParam1);
    if oObj.List = Self then begin
      sPrevName := String(Pointer(AParam^.FParam2));
      if sPrevName <> '' then begin
        i := -1;
        if FNamesIndex.Find(
           {$IFDEF AnyDAC_NOLOCALE_META} UpperCase {$ELSE} AnsiUpperCase {$ENDIF}(sPrevName), i) then
          FNamesIndex.Delete(i);
      end;
      if oObj.Name <> '' then
        FNamesIndex.AddObject(
          {$IFDEF AnyDAC_NOLOCALE_META} UpperCase {$ELSE} AnsiUpperCase {$ENDIF}(oObj.Name), oObj);
    end;
  end;

begin
  with AParam^ do
    if FParam1 = LongWord(Self) then
      DoObjectChanged
    else if FKind = snObjectNameChanged then
      DoObjectRenamed;
  inherited Notify(AParam);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSNamedList.RemoveByName(const AName: String);
var
  i: Integer;
begin
  i := IndexOfName(AName);
  if i = -1 then
    ErrorNameNotFound(AName);
  RemoveAt(i);
end;

{-------------------------------------------------------------------------------}
function TADDatSNamedList.BuildUniqueName(const AName: String): String;
var
  i: Integer;
begin
  Result := AName;
  i := 0;
  while ContainsName(Result) do begin
    Inc(i);
    Result := AName + '_' + IntToStr(i);
  end;
end;

{-------------------------------------------------------------------------------}
{- TADDatSBindedObject                                                         -}
{-------------------------------------------------------------------------------}
constructor TADDatSBindedObject.Create;
begin
  inherited Create;
  FSourceName := Name;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSBindedObject.Assign(AObj: TADDatSObject);
begin
  inherited Assign(AObj);
  if AObj is TADDatSBindedObject then begin
    FSourceName := TADDatSBindedObject(AObj).FSourceName;
    FSourceID := TADDatSBindedObject(AObj).FSourceID;
  end;
end;

{-------------------------------------------------------------------------------}
{- TADDatSBindedList                                                           -}
{-------------------------------------------------------------------------------}
function TADDatSBindedList.ItemByName(const AName: String): TADDatSBindedObject;
begin
  Result := TADDatSBindedObject(inherited ItemByName(AName));
end;

{-------------------------------------------------------------------------------}
function TADDatSBindedList.GetItemsI(AIndex: Integer): TADDatSBindedObject;
begin
  ASSERT((AIndex >= 0) and (AIndex < FCount));
  Result := TADDatSBindedObject(FArray[AIndex]);
end;

{-------------------------------------------------------------------------------}
function TADDatSBindedList.IndexOfSourceName(const AName: String): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Count - 1 do
    if {$IFDEF AnyDAC_NOLOCALE_META} ADCompareText {$ELSE} AnsiCompareText {$ENDIF}
       (ItemsI[i].SourceName, AName) = 0 then begin
      Result := i;
      Break;
    end;
end;

{-------------------------------------------------------------------------------}
function TADDatSBindedList.IndexOfSourceID(AID: Integer): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Count - 1 do
    if ItemsI[i].SourceID = AID then begin
      Result := i;
      Break;
    end;
end;

{-------------------------------------------------------------------------------}
{- TADDatSColumn                                                               -}
{-------------------------------------------------------------------------------}
constructor TADDatSColumn.Create;
begin
  inherited Create;
  FAttributes := [caAllowNull];
  FOptions := [coAllowNull, coInUpdate, coInWhere];
  FAutoIncrementSeed := 1;
  FAutoIncrementStep := 1;
  FIndex := -1;
end;

{-------------------------------------------------------------------------------}
constructor TADDatSColumn.Create(const AName: String;
  AType: TADDataType = dtAnsiString; const AExpression: String = '');
begin
  Create;
  if AName <> '' then
    Name := AName;
  DataType := AType;
  Expression := AExpression;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumn.Assign(AObj: TADDatSObject);
begin
  DefinitionChanging;
  inherited Assign(AObj);
  if AObj is TADDatSColumn then begin
    FAttributes := TADDatSColumn(AObj).FAttributes;
    FAutoIncrement := TADDatSColumn(AObj).FAutoIncrement;
    FAutoIncrementSeed := TADDatSColumn(AObj).FAutoIncrementSeed;
    FAutoIncrementStep := TADDatSColumn(AObj).FAutoIncrementStep;
    FCaption := TADDatSColumn(AObj).FCaption;
    FDataType := TADDatSColumn(AObj).FDataType;
    FExpression := TADDatSColumn(AObj).FExpression;
    FOptions := TADDatSColumn(AObj).FOptions;
    FPrecision := TADDatSColumn(AObj).FPrecision;
    FSize := TADDatSColumn(AObj).FSize;
    FScale := TADDatSColumn(AObj).FScale;
    FSourceDataType := TADDatSColumn(AObj).FSourceDataType;
    FSourcePrecision := TADDatSColumn(AObj).FSourcePrecision;
    FSourceScale := TADDatSColumn(AObj).FSourceScale;
    FSourceSize := TADDatSColumn(AObj).FSourceSize;
    FSourceDataTypeName := TADDatSColumn(AObj).FSourceDataTypeName;
    FOriginName := TADDatSColumn(AObj).FOriginName;
    FEvaluator := nil;
    DefinitionChanged;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumn.DefinitionChanged;
begin
  Notify(snColumnDefChanged, srMetaChange, Integer(Self), 0);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumn.DefinitionChanging;
var
  oTab: TADDatSTable;
begin
  oTab := Table;
  if oTab <> nil then
    oTab.CheckStructureChanging;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumn.Notify(AParam: PDEDatSNotifyParam);
begin
  inherited Notify(AParam);
  with AParam^ do
    if (FKind = snObjectNameChanged) and (FParam1 = LongWord(Self)) then begin
      if FSourceName = String(Pointer(FParam2)) then
        FSourceName := Name;
      if FOriginName = String(Pointer(FParam2)) then
        FOriginName := Name;
    end;
end;

{-------------------------------------------------------------------------------}
function TADDatSColumn.GetCaption: String;
begin
  if FCaption = '' then
    Result := Name
  else
    Result := FCaption;
end;

{-------------------------------------------------------------------------------}
function TADDatSColumn.GetNestedTable: TADDatSTable;
var
  oManager: TADDatSManager;
  oRel: TADDatSRelation;
begin
  Result := nil;
  oManager := Manager;
  if oManager <> nil then begin
    oRel := oManager.Relations.FindRelation(Table, Self);
    if oRel <> nil then
      Result := oRel.ChildTable;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSColumn.GetParentColumn: TADDatSColumn;
var
  oManager: TADDatSManager;
  oRel: TADDatSRelation;
begin
  Result := nil;
  oManager := Manager;
  if oManager <> nil then begin
    oRel := oManager.Relations.FindRelation(Table);
    if oRel <> nil then
      Result := oRel.ParentColumns[0];
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSColumn.GetColumnList: TADDatSColumnList;
begin
  Result := List as TADDatSColumnList;
end;

{-------------------------------------------------------------------------------}
function TADDatSColumn.GetReadOnly: Boolean;
var
  eOptions: TADDataOptions;
begin
  eOptions := Options;
  with Table do
    if Assigned(Callback) then
      Callback.DescribeColumn(Self, eOptions);
  Result := coReadOnly in eOptions;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumn.SetReadOnly(const AValue: Boolean);
begin
  if AValue then
    Options := Options + [coReadOnly]
  else
    Options := Options - [coReadOnly];
end;

{-------------------------------------------------------------------------------}
function TADDatSColumn.GetStorageSize: Integer;
  procedure ErrorColTypeUndef;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_ColTypeUndefined, [Name]);
  end;
begin
  Result := 0;
  if caBlobData in Attributes then
    Result := Sizeof(TADBlobData)
  else if not (DataType in C_AD_InvariantDataTypes) then
    case DataType of
    dtUnknown:      ErrorColTypeUndef;
    dtBoolean:      Result := Sizeof(WordBool);
    dtSByte:        Result := Sizeof(ShortInt);
    dtInt16:        Result := Sizeof(SmallInt);
    dtInt32:        Result := Sizeof(Integer);
    dtInt64:        Result := Sizeof(Int64);
    dtByte:         Result := Sizeof(Byte);
    dtUInt16:       Result := Sizeof(Word);
    dtUInt32:       Result := Sizeof(LongWord);
    dtUInt64:       Result := Sizeof(UInt64);
    dtDouble:       Result := Sizeof(Double);
    dtCurrency:     Result := Sizeof(Currency);
    dtBCD,
    dtFmtBCD:       Result := Sizeof(TADBcd);
    dtDateTime:     Result := Sizeof(TADDateTimeData);
    dtDateTimeStamp:Result := Sizeof(TADSQLTimeStamp);
    dtTime:         Result := Sizeof(Longint);
    dtDate:         Result := Sizeof(Longint);
    dtAnsiString:   Result := SizeOf(Word) + Size * SizeOf(AnsiChar) + SizeOf(AnsiChar);
    dtByteString:   Result := SizeOf(Word) + Size * SizeOf(Byte);
    dtWideString:   Result := SizeOf(Word) + Size * SizeOf(WideChar) + SizeOf(WideChar);
    dtGUID:         Result := Sizeof(TGUID);
    dtObject:       Result := Sizeof(IADDataStoredObject);
    else            ASSERT(False);
    end;
end;

{-------------------------------------------------------------------------------}
function TADDatSColumn.GetDisplayWidth: Integer;
begin
  case DataType of
  dtBoolean:      Result := 5;
  dtSByte:        Result := 4;
  dtInt16:        Result := 6;
  dtInt32:        Result := 11;
  dtInt64:        Result := 21;
  dtByte:         Result := 3;
  dtUInt16:       Result := 5;
  dtUInt32:       Result := 10;
  dtUInt64:       Result := 20;
  dtDouble:       if Precision > 0 then Result := Precision + 2 else Result := 18;
  dtCurrency:     if Precision > 0 then Result := Precision + 2 else Result := 22;
  dtBCD:          if Precision > 0 then Result := Precision + 2 else Result := 18;
  dtFmtBCD:       if Precision > 0 then Result := Precision + 2 else Result := 38;
  dtDateTime:     Result := 27;
  dtDateTimeStamp:Result := 27;
  dtTime:         Result := 11;
  dtDate:         Result := 16;
  dtAnsiString:   Result := Size;
  dtByteString:   Result := Size * 2;
  dtWideString:   Result := Size;
  dtGUID:         Result := C_AD_GUIDStrLen;
  else            Result := 20;
  end;
  if Result < Length(Caption) then
    Result := Length(Caption)
  else if Result > 25 then
    Result := 25;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumn.SetAttributes(const AValue: TADDataAttributes);
var
  ePrevAttrs: TADDataAttributes;
begin
  if FAttributes <> AValue then begin
    DefinitionChanging;
    ePrevAttrs := FAttributes;
    FAttributes := AValue;
    if (caCalculated in ePrevAttrs) and not (caCalculated in FAttributes) then
      Expression := '';
    if FDataType in C_AD_NonSearchableDataTypes then
      Exclude(FAttributes, caSearchable);
    if not (caAllowNull in ePrevAttrs) and (caAllowNull in FAttributes) then
      Include(FOptions, coAllowNull)
    else if (caAllowNull in ePrevAttrs) and not (caAllowNull in FAttributes) then
      Exclude(FOptions, coAllowNull);
    if not (caReadOnly in ePrevAttrs) and (caReadOnly in FAttributes) then
      Include(FOptions, coReadOnly)
    else if (caReadOnly in ePrevAttrs) and not (caReadOnly in FAttributes) then
      Exclude(FOptions, coReadOnly);
    DefinitionChanged;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumn.SetAutoIncrement(const AValue: Boolean);
begin
  if FAutoIncrement <> AValue then begin
    DefinitionChanging;
    FAutoIncrement := AValue;
    if FAutoIncrement and not IsAutoIncrementType(FDataType) then
      FDataType := dtUInt32;
    DefinitionChanged;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSColumn.GetServerAutoIncrement: Boolean;
begin
  Result := AutoIncrement and
    (Attributes * [caAutoInc, caAllowNull] = [caAutoInc, caAllowNull]) and
    (Options * [coAfterInsChanged, coInUpdate] = [coAfterInsChanged]) and
    (AutoIncrementSeed = -1) and (AutoIncrementStep = -1);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumn.SetServerAutoIncrement(const Value: Boolean);
begin
  SetAutoIncrement(Value);
  if Value then begin
    Attributes := Attributes + [caAutoInc, caAllowNull];
    Options := Options + [coAfterInsChanged] - [coInUpdate];
    AutoIncrementSeed := -1;
    AutoIncrementStep := -1;
  end
  else begin
    Attributes := Attributes - [caAutoInc];
    Options := Options - [coAfterInsChanged] + [coInUpdate];
    AutoIncrementSeed := 1;
    AutoIncrementStep := 1;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumn.SetAutoIncrementSeed(const AValue: Integer);
begin
  if FAutoIncrementSeed <> AValue then begin
    DefinitionChanging;
    FAutoIncrementSeed := AValue;
    DefinitionChanged;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumn.SetAutoIncrementStep(const AValue: Integer);
begin
  if FAutoIncrementStep <> AValue then begin
    DefinitionChanging;
    FAutoIncrementStep := AValue;
    DefinitionChanged;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumn.SetCaption(const AValue: String);
begin
  if FCaption <> AValue then begin
    if AValue = Name then
      FCaption := ''
    else
      FCaption := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSColumn.IsAutoIncrementType(const AValue: TADDataType): Boolean;
begin
  Result := AValue in [dtSByte, dtInt16, dtInt32, dtInt64,
                       dtByte, dtUInt16, dtUInt32, dtUInt64,
                       dtDouble, dtBCD, dtFmtBCD];
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumn.SetDataType(const AValue: TADDataType);
  procedure CantChangeDataType;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_CantChngColType, [Name]);
  end;
var
  ePrevDataType: TADDataType;
begin
  if FDataType <> AValue then begin
    DefinitionChanging;
    if Table <> nil then begin
      if Table.Rows.Count > 0 then
        CantChangeDataType;
    end;
    ePrevDataType := FDataType;
    FDataType := AValue;
    if not IsAutoIncrementType(FDataType) then
      FAutoIncrement := False;
    if FDataType in [dtAnsiString, dtWideString, dtByteString] then
      if ColumnList <> nil then
        with ColumnList do
          if InlineDataSize = 0 then
            FSize := MAXINT
          else
            FSize := InlineDataSize
      else
        FSize := 50
    else
      FSize := 0;
    if FDataType in C_AD_NonSearchableDataTypes then
      Exclude(FAttributes, caSearchable);
    if FDataType in C_AD_BlobTypes then
      Include(FAttributes, caBlobData)
    else
      Exclude(FAttributes, caBlobData);
    case FDataType of
    dtDouble:   FPrecision := 16;
    dtCurrency: FPrecision := 20;
    dtBCD,
    dtFmtBCD:   FPrecision := 64;
    else        FPrecision := 0;
    end;
    if FSourceDataType = ePrevDataType then
      FSourceDataType := AValue;
    DefinitionChanged;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumn.SetExpression(const AValue: String);
var
  oCols: TADDatSColumnList;
  oParser: IADStanExpressionParser;
begin
  if FExpression <> AValue then begin
    FExpression := AValue;
    FEvaluator := nil;
    if SourceID <= 0 then
      if AValue <> '' then begin
        FAttributes := FAttributes + [caReadOnly, caCalculated];
        FOptions := FOptions + [coReadOnly];
      end
      else
        FAttributes := FAttributes - [caCalculated];
    oCols := GetColumnList;
    if (FExpression = '') or (oCols = nil) or (Length(oCols.FDataOffsets) = 0) then
      DefinitionChanged
    else begin
      with oCols do
        FHasThings := FHasThings + [ctExps, ctDefs, ctCalcs];
      ADCreateInterface(IADStanExpressionParser, oParser);
      FEvaluator := oParser.Prepare(TADDatSTableExpressionDS.Create(Table),
        Expression, [], [poDefaultExpr], Name);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumn.SetOptions(const AValue: TADDataOptions);
var
  lUKChng: Boolean;
begin
  if FOptions <> AValue then begin
    lUKChng := (coUnique in Options) <> (coUnique in AValue);
    FOptions := AValue;
    if lUKChng and (Table <> nil) then
      UpdateUniqueKey(coUnique in AValue);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumn.SetPrecision(const AValue: Integer);
begin
  if FPrecision <> AValue then begin
    DefinitionChanging;
    if FPrecision = FSourcePrecision then begin
      FPrecision := AValue;
      FSourcePrecision := AValue;
    end
    else
      FPrecision := AValue;
    DefinitionChanged;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumn.SetScale(const AValue: Integer);
begin
  if FScale <> AValue then begin
    DefinitionChanging;
    if FScale = FSourceScale then begin
      FScale := AValue;
      FSourceScale := AValue;
    end
    else
      FScale := AValue;
    DefinitionChanged;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumn.SetSize(const AValue: LongWord);
begin
  if FSize <> AValue then begin
    DefinitionChanging;
    if FSize = FSourceSize then begin
      FSize := AValue;
      FSourceSize := AValue;
    end
    else
      FSize := AValue;
    DefinitionChanged;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSColumn.GetAllowDBNull: Boolean;
var
  eOptions: TADDataOptions;
begin
  eOptions := Options;
  with Table do
    if Callback <> nil then
      Callback.DescribeColumn(Self, eOptions);
  Result := coAllowNull in eOptions;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumn.SetAllowDBNull(const AValue: Boolean);
begin
  if AValue then
    Options := Options + [coAllowNull]
  else
    Options := Options - [coAllowNull];
end;

{-------------------------------------------------------------------------------}
function TADDatSColumn.GetUnique: Boolean;
begin
  Result := coUnique in Options;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumn.SetUnique(const AValue: Boolean);
begin
  if AValue then
    Options := Options + [coUnique]
  else
    Options := Options - [coUnique];
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumn.UpdateUniqueKey(AUnique: Boolean);
var
  oCons: TADDatSConstraintList;
  oCon: TADDatSConstraintBase;
  i: Integer;
begin
  oCons := Table.Constraints;
  if oCons = nil then
    Exit;
  oCon := nil;
  for i := 0 to oCons.Count - 1 do begin
    oCon := oCons.ItemsI[i];
    if (oCon is TADDatSUniqueConstraint) and
       (TADDatSUniqueConstraint(oCon).ColumnCount = 1) and
       (TADDatSUniqueConstraint(oCon).Columns[0] = Self) then
      Break
    else
      oCon := nil;
  end;
  if AUnique then begin
    try
      if oCon = nil then
        oCons.AddUK('', Self, False)
      else
        oCon.Enforce := True;
    except
      Exclude(FOptions, coUnique);
      raise;
    end;
  end
  else begin
    if oCon <> nil then
      oCon.Free;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumn.DoListInserting;
begin
  DefinitionChanging;
  inherited DoListInserting;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumn.DoListInserted;
begin
  inherited DoListInserted;
  if Unique then
    UpdateUniqueKey(True);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumn.DoListRemoving;
begin
  DefinitionChanging;
  inherited DoListRemoving;
  if Unique then
    UpdateUniqueKey(False);
end;

{-------------------------------------------------------------------------------}
function TADDatSColumn.GetIndex: Integer;
begin
  Result := FIndex;
  if Result = -1 then
    Result := inherited GetIndex;
end;

{-------------------------------------------------------------------------------}
{- TADDatSTableExpressionDS                                                    -}
{-------------------------------------------------------------------------------}
constructor TADDatSTableExpressionDS.Create(ATable: TADDatSTable);
begin
  ASSERT(ATable <> nil);
  inherited Create;
  FTable := ATable;
end;

{-------------------------------------------------------------------------------}
function TADDatSTableExpressionDS.GetPosition: Pointer;
begin
  Result := FRow;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTableExpressionDS.SetPosition(AValue: Pointer);
begin
  FRow := TADDatSRow(AValue);
end;

{-------------------------------------------------------------------------------}
function TADDatSTableExpressionDS.GetRowNum: Integer;
begin
  ASSERT(FRow <> nil);
  Result := FRow.Index + 1;
end;

{-------------------------------------------------------------------------------}
function TADDatSTableExpressionDS.GetSubAggregateValue(AIndex: Integer): Variant;
begin
  Result := Unassigned;
  ASSERT(False);
end;

{-------------------------------------------------------------------------------}
function TADDatSTableExpressionDS.GetVarIndex(const AName: String): Integer;
begin
  Result := FTable.Columns.IndexOfName(AName);
end;

{-------------------------------------------------------------------------------}
function TADDatSTableExpressionDS.GetVarType(AIndex: Integer): TADDataType;
begin
  Result := FTable.Columns[AIndex].DataType;
end;

{-------------------------------------------------------------------------------}
function TADDatSTableExpressionDS.GetVarScope(AIndex: Integer): TADExpressionScopeKind;
begin
  Result := ckField;
end;

{-------------------------------------------------------------------------------}
function TADDatSTableExpressionDS.GetVarData(AIndex: Integer): Variant;
begin
  ASSERT(FRow <> nil);
  Result := FRow.GetData(AIndex, rvDefault);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTableExpressionDS.SetVarData(AIndex: Integer;
  const AValue: Variant);
begin
  ASSERT(FRow <> nil);
  FRow.SetData(AIndex, AValue);
end;

{-------------------------------------------------------------------------------}
{- TADDatSColumnList                                                           -}
{-------------------------------------------------------------------------------}
constructor TADDatSColumnList.CreateForTable(ATable: TADDatSTable);
begin
  ASSERT(ATable <> nil);
  inherited Create;
  FOwner := ATable;
  OwnObjects := True;
  FInlineDataSize := IDefInrecDataSize;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumnList.Assign(AObj: TADDatSObject);
begin
  inherited Assign(AObj);
  if AObj is TADDatSColumnList then begin
    OnCalcColumns := TADDatSColumnList(AObj).OnCalcColumns;
    InlineDataSize := TADDatSColumnList(AObj).InlineDataSize;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSColumnList.Add(AObj: TADDatSColumn): Integer;
begin
  Result := AddObject(AObj);
end;

{-------------------------------------------------------------------------------}
function TADDatSColumnList.Add(const AName: String;
  AType: TADDataType = dtAnsiString; const AExpression: String = ''): TADDatSColumn;
begin
  Result := TADDatSColumn.Create(AName, AType, AExpression);
  AddEx(Result);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumnList.AddObjectAt(AObj: TADDatSObject; APosition: Integer);
var
  oTab: TADDatSTable;
begin
  oTab := Table;
  if oTab <> nil then
    oTab.CheckStructureChanging;
  inherited AddObjectAt(AObj, APosition);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumnList.RemoveAt(AIndex: Integer; ANotDestroy: Boolean = False);
var
  oTab: TADDatSTable;
begin
  oTab := Table;
  if oTab <> nil then
    oTab.CheckStructureChanging;
  inherited RemoveAt(AIndex, ANotDestroy);
end;

{-------------------------------------------------------------------------------}
function TADDatSColumnList.ColumnByName(const AName: String): TADDatSColumn;
begin
  Result := TADDatSColumn(inherited ItemByName(AName));
end;

{-------------------------------------------------------------------------------}
function TADDatSColumnList.GetCurrValues(AIndex: Integer): Integer;
begin
  if ItemsI[AIndex].AutoIncrement then
    Result := FAutoIncs[AIndex]
  else
    Result := 0;
end;

{-------------------------------------------------------------------------------}
function TADDatSColumnList.GetItemsI(AIndex: Integer): TADDatSColumn;
begin
  ASSERT((AIndex >= 0) and (AIndex < FCount));
  Result := TADDatSColumn(FArray[AIndex]);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumnList.Notify(AParam: PDEDatSNotifyParam);
begin
  with AParam^ do begin
    if (FKind = snColumnDefChanged) and (TADDatSColumn(TADDatSObject(FParam1)).List = Self) or
       (FKind = snObjectInserted) and (TADDatSObject(FParam1) = Self) or
       (FKind = snObjectRemoved) and (TADDatSObject(FParam1) = Self) then
      TerminateLayout;
    // MSGOPT this condition is only for optimization
    if FKind <> snColumnDefChanged then
      inherited Notify(AParam);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumnList.HandleNotification(AParam: PDEDatSNotifyParam);
begin
  // MSGOPT nothing - just exit
  // if AParam^.FReason = srDataChange then
  //   Exit;
  // inherited HandleNotification(AParam);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumnList.SetInlineDataSize(const AValue: Word);
begin
  if FInlineDataSize <> AValue then begin
    FInlineDataSize := AValue;
    TerminateLayout;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumnList.CheckUpdateLayout(ARowInstanceSize: Integer);
begin
  if Length(FDataOffsets) = 0 then
    UpdateLayout(ARowInstanceSize);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumnList.UpdateLayout(ARowInstanceSize: Integer);
  procedure ErrorNoCols;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_NoColsDefined, []);
  end;
  procedure ErrorRowSinglePar;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_RowMayHaveSingleParent, []);
  end;
var
  iOffset, iAutoIncs: Integer;
  i: Integer;
  oParentCol: TADDatSColumn;
  oParser: IADStanExpressionParser;
begin
  if Count = 0 then
    ErrorNoCols;
  try
    SetLength(FDataOffsets, Count + 1);
    SetLength(FNullOffsets, Count);
    SetLength(FNullMasks, Count);
    iOffset := 0;
    iAutoIncs := 0;
    FInvariants := 0;
    FParentRowRefCol := -1;
    FParentCol := -1;
    FHasThings := [];
    oParser := nil;
    for i := 0 to Count - 1 do
      with ItemsI[i] do begin
        FIndex := i;
        if DataType in C_AD_StrTypes then
          if Size > InlineDataSize then
            Include(FAttributes, caBlobData);
        FDataOffsets[i] := iOffset;
        Inc(iOffset, StorageSize);
        if AutoIncrement then
          Inc(iAutoIncs);
        if DataType = dtParentRowRef then begin
          if FParentRowRefCol <> -1 then
            ErrorRowSinglePar
          else
            FParentRowRefCol := i;
          oParentCol := ParentColumn;
          if oParentCol <> nil then
            FParentCol := oParentCol.Index;
        end;
        if DataType in C_AD_InvariantDataTypes then begin
          Inc(FInvariants);
          Include(FHasThings, ctInvars);
        end;
        if caCalculated in Attributes then
          Include(FHasThings, ctCalcs)
        else if Expression <> '' then
          Include(FHasThings, ctExps);
        if (Expression <> '') or AutoIncrement then
          Include(FHasThings, ctDefs);
        if (caBlobData in FAttributes) or (DataType = dtObject) then
          Include(FHasThings, ctComp);
      end;
    FDataOffsets[Count] := iOffset;
    for i := 0 to Count - 1 do begin
      FNullOffsets[i] := iOffset + i div 8;
      FNullMasks[i] := Byte(1 shl (i mod 8));
    end;
    if iAutoIncs <> 0 then begin
      SetLength(FAutoIncs, Count);
      for i := 0 to Count - 1 do
        with ItemsI[i] do
          if AutoIncrement then
            FAutoIncs[i] := AutoIncrementSeed - AutoIncrementStep;
    end;
    if FInvariants <> 0 then begin
      SetLength(FInvariantMap, Count);
      FInvariants := 0;
      for i := 0 to Count - 1 do
        with ItemsI[i] do
          if DataType in C_AD_InvariantDataTypes then begin
            FInvariantMap[i] := FInvariants;
            Inc(FInvariants);
          end;
    end;
    for i := 0 to Count - 1 do
      with ItemsI[i] do
        if Expression <> '' then begin
          if oParser = nil then
            ADCreateInterface(IADStanExpressionParser, oParser);
          FEvaluator := oParser.Prepare(TADDatSTableExpressionDS.Create(Table),
            Expression, [], [poDefaultExpr], Name);
        end;
    FFetchedOffset := ARowInstanceSize;
    FFetchedSize := ((Count + 7) div 8) * SizeOf(Byte);
    if FInvariants <> 0 then begin
      FInvariantOffset := FFetchedOffset + FFetchedSize;
      FInvariantSize := FInvariants * SizeOf(LongWord);
    end
    else begin
      FInvariantOffset := -1;
      FInvariantSize := 0;
    end;
    FRowsPool := TADMemPool.Create(ARowInstanceSize + FFetchedSize + FInvariantSize, 1024, 0);
    FBuffsPool := TADMemPool.Create(StorageSize, 1024, 0);
  except
    TerminateLayout;
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumnList.TerminateLayout;
var
  i: Integer;
begin
  if Length(FDataOffsets) <> 0 then begin
    FParentRowRefCol := -1;
    FParentCol := -1;
    FFetchedOffset := 0;
    FFetchedSize := 0;
    FInvariantOffset := -1;
    FInvariantSize := 0;
    FInvariants := 0;
    FHasThings := [];
    SetLength(FDataOffsets, 0);
    SetLength(FNullOffsets, 0);
    SetLength(FNullMasks, 0);
    SetLength(FAutoIncs, 0);
    SetLength(FInvariantMap, 0);
    for i := 0 to Count - 1 do
      with ItemsI[i] do begin
        FIndex := -1;
        FEvaluator := nil;
      end;
    FreeAndNil(FRowsPool);
    FreeAndNil(FBuffsPool);
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSColumnList.GetStorageSize: LongWord;
begin
  Result := DataOffsets[Count] + LongWord((Count + 7) div 8);
end;

{-------------------------------------------------------------------------------}
{- TADDatSColumnSublist                                                        -}
{-------------------------------------------------------------------------------}
procedure TADDatSColumnSublist.Clear;
begin
  SetLength(FArray, 0);
  FNames := '';
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumnSublist.Add(ACol: TADDatSColumn);
begin
  SetLength(FArray, Length(FArray) + 1);
  FArray[Length(FArray) - 1] := ACol;
end;

{-------------------------------------------------------------------------------}
// field[:[D][A][N]];
procedure TADDatSColumnSublist.Fill(AObject: TADDatSObject;
  const AFields: String; ACaseInsensitiveColumnList: TADDatSColumnSublist = nil;
  ADescendingColumnList: TADDatSColumnSublist = nil);
var
  oCols: TADDatSColumnList;
  oCol: TADDatSColumn;
  i, j, jFrom: Integer;
  lNoCase, lDesc: Boolean;
  sItem: String;
begin
  ASSERT((AObject <> nil) and (AObject.Table <> nil));
  Clear;
  oCols := AObject.Table.Columns;
  if AFields = '*' then begin
    SetLength(FArray, oCols.Count);
    for i := 0 to oCols.Count - 1 do begin
      FArray[i] := oCols.ItemsI[i];
      if FNames <> '' then
        FNames := FNames + ';';
      FNames := FNames + FArray[i].Name;
    end;
  end
  else begin
    i := 1;
    while i <= Length(AFields) do begin
      sItem := ADExtractFieldName(AFields, i);
      j := Pos(':', sItem);
      lNoCase := False;
      lDesc := False;
      if j <> 0 then begin
        jFrom := j;
        while j <= Length(sItem) do begin
          case sItem[j] of
          'n', 'N': lNoCase := True;
          'd', 'D': lDesc := True;
          end;
          Inc(j);
        end;
        sItem := Copy(sItem, 1, jFrom - 1);
      end;
      oCol := oCols.ColumnByName(sItem);
      Add(oCol);
      if lNoCase and (ACaseInsensitiveColumnList <> nil) then
        ACaseInsensitiveColumnList.Add(oCol);
      if lDesc and (ADescendingColumnList <> nil) then
        ADescendingColumnList.Add(oCol);
    end;
    FNames := AFields;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSColumnSublist.GetCount: Integer;
begin
  Result := Length(FArray);
end;

{-------------------------------------------------------------------------------}
function TADDatSColumnSublist.GetItemsI(AIndex: Integer): TADDatSColumn;
begin
  ASSERT((AIndex >= 0) and (AIndex < Length(FArray)));
  Result := TADDatSColumn(FArray[AIndex]);
end;

{-------------------------------------------------------------------------------}
function TADDatSColumnSublist.HandleNotification(AParam: PDEDatSNotifyParam): Boolean;
begin
  with AParam^ do
    if (FReason = srMetaChange) and (
         (FKind = snObjectNameChanged) and (IndexOf(TADDatSColumn(FParam1)) <> -1) or
// MSGOPT        (FKind = snObjectInserted) and (IndexOf(TADDatSColumn(FParam2)) <> -1) or
         (FKind = snObjectRemoved) and (IndexOf(TADDatSColumn(FParam2)) <> -1)
       ) then
      Result := True
    else
      Result := False;
end;

{-------------------------------------------------------------------------------}
function TADDatSColumnSublist.IndexOf(AColumn: TADDatSColumn): Integer;
begin
  ASSERT(AColumn <> nil);
  Result := ADIndexOf(FArray, -1, AColumn);
end;

{-------------------------------------------------------------------------------}
function TADDatSColumnSublist.FindColumn(const AName: String): TADDatSColumn;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
    if {$IFDEF AnyDAC_NOLOCALE_META} ADCompareText {$ELSE} AnsiCompareText {$ENDIF}
       (FArray[i].Name, AName) = 0 then begin
      Result := FArray[i];
      Exit;
    end;
end;

{-------------------------------------------------------------------------------}
function TADDatSColumnSublist.Matches(AList: TADDatSColumnSublist;
  ACount: Integer): Boolean;
var
  iCnt, i: Integer;
begin
  if AList = nil then
    iCnt := -1
  else if ACount = -1 then
    iCnt := AList.Count
  else
    iCnt := ACount;
  if iCnt > Count then
    Result := False
  else begin
    Result := True;
    for i := 0 to iCnt - 1 do
      if FArray[i] <> AList.FArray[i] then begin
        Result := False;
        Break;
      end;
  end;
end;

{-------------------------------------------------------------------------------}
{- TADDatSConstraintBase                                                       -}
{-------------------------------------------------------------------------------}
constructor TADDatSConstraintBase.Create;
begin
  inherited Create;
  FEnforce := True;
  FRely := True;
  FLastActualEnforce := ActualEnforce;
end;

{-------------------------------------------------------------------------------}
destructor TADDatSConstraintBase.Destroy;
begin
  Enforce := False;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSConstraintBase.Assign(AObj: TADDatSObject);
begin
  inherited Assign(AObj);
  if AObj is TADDatSConstraintBase then begin
    Rely := TADDatSConstraintBase(AObj).Rely;
    Enforce := TADDatSConstraintBase(AObj).Enforce;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSConstraintBase.IsEqualTo(AObj: TADDatSObject): Boolean;
begin
  Result := inherited IsEqualTo(AObj);
  if Result then
    Result := (Rely = TADDatSConstraintBase(AObj).Rely);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSConstraintBase.Check(ARow: TADDatSRow; AProposedState:
  TADDatSRowState; ATime: TADDatSCheckTime);
begin
  ASSERT(ARow <> nil);
  if ActualEnforce and (ATime = CheckTime) and CheckRow(ARow) then
    DoCheck(ARow, AProposedState);
end;

{-------------------------------------------------------------------------------}
function TADDatSConstraintBase.CheckRow(ARow: TADDatSRow): Boolean;
begin
  // nothing
  Result := True;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSConstraintBase.DoCheck(ARow: TADDatSRow;
  AProposedState: TADDatSRowState);
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADDatSConstraintBase.CheckAll;
var
  oRows: TADDatSTableRowList;
  i: Integer;
begin
  oRows := Table.Rows;
  for i := 0 to oRows.Count - 1 do
    DoCheck(oRows[i], rsChecking);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSConstraintBase.DoEnforceUpdated;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADDatSConstraintBase.EnforceUpdated;
begin
  if FLastActualEnforce <> ActualEnforce then begin
    FLastActualEnforce := ActualEnforce;
    try
      DoEnforceUpdated;
      if ActualEnforce and not Rely then
        CheckAll;
    except
      Enforce := False;
      raise;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSConstraintBase.SetEnforce(const AValue: Boolean);
begin
  if FEnforce <> AValue then begin
    FEnforce := AValue;
    EnforceUpdated;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSConstraintBase.DoListInserted;
begin
  EnforceUpdated;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSConstraintBase.DoListRemoved(ANewOwner: TADDatSObject);
begin
  EnforceUpdated;
end;

{-------------------------------------------------------------------------------}
function TADDatSConstraintBase.GetActualEnforce: Boolean;
begin
  Result := Enforce and (ConstraintList <> nil);
  if Result then begin
    Result := ConstraintList.Enforce;
    if Result and (Manager <> nil) then
      Result := Manager.EnforceConstraints;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSConstraintBase.GetConstraintList: TADDatSConstraintList;
begin
  Result := List as TADDatSConstraintList;
end;

{-------------------------------------------------------------------------------}
{- TADDatSConstraintList                                                       -}
{-------------------------------------------------------------------------------}
constructor TADDatSConstraintList.CreateForTable(ATable: TADDatSTable);
begin
  ASSERT(ATable <> nil);
  inherited Create;
  FOwner := ATable;
  OwnObjects := True;
  FEnforce := True;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSConstraintList.Assign(AObj: TADDatSObject);
begin
  Clear;
  if AObj is TADDatSConstraintList then
    Enforce := False;
  inherited Assign(AObj);
  if AObj is TADDatSConstraintList then
    Enforce := TADDatSConstraintList(AObj).Enforce;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSConstraintList.HandleNotification(AParam: PDEDatSNotifyParam);
begin
  if AParam^.FReason = srDataChange then
    Exit;
  inherited HandleNotification(AParam);
end;

{-------------------------------------------------------------------------------}
function TADDatSConstraintList.Add(AObj: TADDatSConstraintBase): Integer;
begin
  Result := AddObject(AObj);
end;

{-------------------------------------------------------------------------------}
function TADDatSConstraintList.AddUK(const AName: String; AColumn: TADDatSColumn;
  APrimaryKey: Boolean): TADDatSUniqueConstraint;
begin
  Result := AddUK(AName, [AColumn], APrimaryKey);
end;

{-------------------------------------------------------------------------------}
function TADDatSConstraintList.AddUK(const AName: String;
  const AColumns: array of TADDatSColumn; APrimaryKey: Boolean): TADDatSUniqueConstraint;
begin
  Result := TADDatSUniqueConstraint.Create(AName, AColumns, APrimaryKey);
  AddEx(Result);
end;

{-------------------------------------------------------------------------------}
function TADDatSConstraintList.AddUK(const AName, AColumnNames: String;
  APrimaryKey: Boolean): TADDatSUniqueConstraint;
begin
  Result := TADDatSUniqueConstraint.Create(AName, AColumnNames, APrimaryKey);
  AddEx(Result);
end;

{-------------------------------------------------------------------------------}
function TADDatSConstraintList.AddFK(const AName: String;
  APrimaryKeyColumn, AForeignKeyColumn: TADDatSColumn): TADDatSForeignKeyConstraint;
begin
  Result := AddFK(AName, [APrimaryKeyColumn], [AForeignKeyColumn]);
end;

{-------------------------------------------------------------------------------}
function TADDatSConstraintList.AddFK(const AName: String;
  const APrimaryKeyColumns, AForeignKeyColumns: array of TADDatSColumn): TADDatSForeignKeyConstraint;
begin
  Result := TADDatSForeignKeyConstraint.Create(AName, APrimaryKeyColumns,
    AForeignKeyColumns, crCascade, crRestrict);
  AddEx(Result);
end;

{-------------------------------------------------------------------------------}
function TADDatSConstraintList.AddFK(const AName, AParentTableName, APrimaryKeyColumns,
  AForeignKeyColumns: String): TADDatSForeignKeyConstraint;
begin
  Result := TADDatSForeignKeyConstraint.Create(AName, AParentTableName,
    APrimaryKeyColumns, AForeignKeyColumns, crCascade, crRestrict);
  AddEx(Result);
end;

{-------------------------------------------------------------------------------}
function TADDatSConstraintList.AddFK(const AName: String; AParentTable: TADDatSTable;
  const APrimaryKeyColumns, AForeignKeyColumns: String): TADDatSForeignKeyConstraint;
begin
  Result := TADDatSForeignKeyConstraint.Create(AName, AParentTable,
    APrimaryKeyColumns, AForeignKeyColumns, crCascade, crRestrict);
  AddEx(Result);
end;

{-------------------------------------------------------------------------------}
function TADDatSConstraintList.AddChk(const AName, AExpression: String;
  const AMessage: String = ''; ACheckTime: TADDatSCheckTime = ctAtEditEnd): TADDatSCheckConstraint;
begin
  Result := TADDatSCheckConstraint.Create(AName, AExpression, AMessage, ACheckTime);
  AddEx(Result);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSConstraintList.Check(ARow: TADDatSRow; AProposedState:
  TADDatSRowState; ATime: TADDatSCheckTime);
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    ItemsI[i].Check(ARow, AProposedState, ATime);
end;

{-------------------------------------------------------------------------------}
function TADDatSConstraintList.ConstraintByName(const AName: String):
  TADDatSConstraintBase;
begin
  Result := TADDatSConstraintBase(inherited ItemByName(AName));
end;

{-------------------------------------------------------------------------------}
procedure TADDatSConstraintList.EnforceUpdated;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    ItemsI[i].EnforceUpdated;
end;

{-------------------------------------------------------------------------------}
function TADDatSConstraintList.GetItemsI(AIndex: Integer): TADDatSConstraintBase;
begin
  ASSERT((AIndex >= 0) and (AIndex < FCount));
  Result := TADDatSConstraintBase(FArray[AIndex]);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSConstraintList.SetEnforce(const AValue: Boolean);
begin
  if FEnforce <> AValue then begin
    FEnforce := AValue;
    EnforceUpdated;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSConstraintList.FindUnique(
  const AFields: String): TADDatSUniqueConstraint;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
    if ItemsI[i] is TADDatSUniqueConstraint then
      if {$IFDEF AnyDAC_NOLOCALE_META} ADCompareText {$ELSE} AnsiCompareText {$ENDIF}
         (AFields, TADDatSUniqueConstraint(ItemsI[i]).ColumnNames) = 0 then begin
        Result := TADDatSUniqueConstraint(ItemsI[i]);
        Break;
      end;
end;

{-------------------------------------------------------------------------------}
function TADDatSConstraintList.FindPrimaryKey: TADDatSUniqueConstraint;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
    if ItemsI[i] is TADDatSUniqueConstraint then
      if TADDatSUniqueConstraint(ItemsI[i]).IsPrimaryKey then begin
        Result := TADDatSUniqueConstraint(ItemsI[i]);
        Break;
      end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSConstraintList.CheckAll;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    with ItemsI[i] do
      if ActualEnforce and not Rely then
        try
          CheckAll;
        except
          Enforce := False;
        end;
end;

{-------------------------------------------------------------------------------}
{- TADDatSUniqueConstraint                                                     -}
{-------------------------------------------------------------------------------}
constructor TADDatSUniqueConstraint.Create;
begin
  inherited Create;
  FColumns := TADDatSColumnSublist.Create;
  FOptions := [soUnique];
end;

{-------------------------------------------------------------------------------}
constructor TADDatSUniqueConstraint.Create(AColumn: TADDatSColumn;
  APrimaryKey: Boolean);
begin
  Create('', [AColumn], APrimaryKey);
end;

{-------------------------------------------------------------------------------}
constructor TADDatSUniqueConstraint.Create(
  const AColumns: array of TADDatSColumn; APrimaryKey: Boolean);
begin
  Create('', AColumns, APrimaryKey);
end;

{-------------------------------------------------------------------------------}
constructor TADDatSUniqueConstraint.Create(const AName: String;
  AColumn: TADDatSColumn; APrimaryKey: Boolean);
begin
  Create(AName, [AColumn], APrimaryKey);
end;

{-------------------------------------------------------------------------------}
constructor TADDatSUniqueConstraint.Create(const AName: String;
  const AColumns: array of TADDatSColumn; APrimaryKey: Boolean);
var
  s: String;
  i: Integer;
begin
  ASSERT(AColumns[Low(AColumns)] <> nil);
  s := AColumns[Low(AColumns)].Name;
  for i := Low(AColumns) + 1 to High(AColumns) do begin
    ASSERT(AColumns[i] <> nil);
    s := s + ';' + AColumns[i].Name;
  end;
  Create(AName, s, APrimaryKey);
end;

{-------------------------------------------------------------------------------}
constructor TADDatSUniqueConstraint.Create(const AName,
  AColumnNames: String; APrimaryKey: Boolean);
begin
  Create;
  if AName <> '' then
    Name := AName;
  ColumnNames := AColumnNames;
  if APrimaryKey then
    Options := Options + [soPrimary];
  Enforce := True;
end;

{-------------------------------------------------------------------------------}
destructor TADDatSUniqueConstraint.Destroy;
begin
  Enforce := False;
  FreeAndNil(FColumns);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSUniqueConstraint.Assign(AObj: TADDatSObject);
begin
  inherited Assign(AObj);
  if AObj is TADDatSUniqueConstraint then begin
    ColumnNames := TADDatSUniqueConstraint(AObj).ColumnNames;
    Options := TADDatSUniqueConstraint(AObj).Options;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSUniqueConstraint.IsEqualTo(AObj: TADDatSObject): Boolean;
begin
  Result := inherited IsEqualTo(AObj);
  if Result then begin
    ASSERT(AObj <> nil);
    Result := (ColumnNames = TADDatSUniqueConstraint(AObj).ColumnNames) and
              (Options = TADDatSUniqueConstraint(AObj).Options);
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSUniqueConstraint.GetUniqueSortedView: TADDatSView;
begin
  Result := Table.Views.FindSortedView(ColumnNames, Options -
    [soNullLess, soDescending], []);
  if Result = nil then begin
    Result := TADDatSView.Create(Table, C_AD_SysNamePrefix + 'UC_' + Name,
      vcUniqueConstraint, False);
    try
      Result.Mechanisms.AddSort(ColumnNames, '', '', Options);
      Result.Active := True;
    except
      Result.Free;
      raise;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSUniqueConstraint.DoCheck(ARow: TADDatSRow; AProposedState: TADDatSRowState);
  procedure ErrorViolated;
  begin
    if Message <> '' then
      ADException(Self, [S_AD_LDatS], er_AD_DuplicateRows, [Message, 0])
    else
      ADException(Self, [S_AD_LDatS], er_AD_DuplicateRows, [Name, 1]);
  end;
var
  oView: TADDatSView;
  iPos: Integer;
  lFound: Boolean;
  eOpts: TADLocateOptions;
begin
  if AProposedState in [rsInserted, rsModified] then begin
    oView := GetUniqueSortedView;
    eOpts := [loExcludeKeyRow];
    if soNoCase in Options then
      Include(eOpts, loNoCase);
    lFound := False;
    iPos := -1;
    oView.Search(ARow, nil, nil, -1, eOpts, iPos, lFound);
    if lFound then
      ErrorViolated;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSUniqueConstraint.DoEnforceUpdated;
  procedure InvalidUniqueKey;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_BadUniqueKey, [Name]);
  end;
var
  i: Integer;
begin
  if not ActualEnforce then begin
    if soPrimary in Options then
      for i := 0 to FColumns.Count - 1 do
        with FColumns[i] do begin
          if not (caAutoInc in FAttributes) then
            Include(FAttributes, caAllowNull);
          Exclude(FOptions, coInKey);
        end;
    FColumns.Clear;
  end
  else begin
    FColumns.Fill(Self, FColumnNames);
    if FColumns.Count = 0 then
      InvalidUniqueKey;
    if soPrimary in Options then
      for i := 0 to FColumns.Count - 1 do
        with FColumns[i] do begin
          if not (caAutoInc in FAttributes) then
            Exclude(FAttributes, caAllowNull);
          Include(FOptions, coInKey);
        end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSUniqueConstraint.GetColumnCount: Integer;
begin
  Result := FColumns.Count;
end;

{-------------------------------------------------------------------------------}
function TADDatSUniqueConstraint.GetColumns(AIndex: Integer):
  TADDatSColumn;
begin
  Result := FColumns.ItemsI[AIndex];
end;

{-------------------------------------------------------------------------------}
procedure TADDatSUniqueConstraint.HandleNotification(AParam: PDEDatSNotifyParam);
begin
  if (FColumns <> nil) and FColumns.HandleNotification(AParam) then
    Enforce := False;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSUniqueConstraint.SetColumnNames(const AValue: String);
begin
  if FColumnNames <> AValue then begin
    FColumnNames := AValue;
    Enforce := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSUniqueConstraint.SetOptions(const AValue: TADSortOptions);
begin
  if FOptions <> AValue then begin
    FOptions := AValue;
    Enforce := False;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSUniqueConstraint.GetIsPrimaryKey: Boolean;
begin
  Result := soPrimary in Options;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSUniqueConstraint.SetIsPrimaryKey(const AValue: Boolean);
begin
  if AValue then
    Options := Options + [soPrimary]
  else
    Options := Options - [soPrimary];
end;

{-------------------------------------------------------------------------------}
{- TADDatSForeignKeyConstraint                                                 -}
{-------------------------------------------------------------------------------}
constructor TADDatSForeignKeyConstraint.Create;
begin
  inherited Create;
  FDeleteRule := crCascade;
  FUpdateRule := crCascade;
  FInsertRule := crCascade;
  FAcceptRejectRule := arCascade;
  FColumns := TADDatSColumnSublist.Create;
  FRelatedColumns := TADDatSColumnSublist.Create;
  FCascadingRows := TList.Create;
end;

{-------------------------------------------------------------------------------}
constructor TADDatSForeignKeyConstraint.Create(const AName: String;
  AParentColumn, AChildColumn: TADDatSColumn; ADeleteRule,
  AUpdateRule: TADDatSConstraintRule);
begin
  Create(AName, [AParentColumn], [AChildColumn], ADeleteRule, AUpdateRule);
end;

{-------------------------------------------------------------------------------}
constructor TADDatSForeignKeyConstraint.Create(AParentColumn,
  AChildColumn: TADDatSColumn; ADeleteRule,
  AUpdateRule: TADDatSConstraintRule);
begin
  Create('', [AParentColumn], [AChildColumn], ADeleteRule, AUpdateRule);
end;

{-------------------------------------------------------------------------------}
constructor TADDatSForeignKeyConstraint.Create(const AParentColumns,
  AChildColumns: array of TADDatSColumn; ADeleteRule,
  AUpdateRule: TADDatSConstraintRule);
begin
  Create('', AParentColumns, AChildColumns, ADeleteRule, AUpdateRule);
end;

{-------------------------------------------------------------------------------}
constructor TADDatSForeignKeyConstraint.Create(const AName: String;
  const AParentColumns, AChildColumns: array of TADDatSColumn; ADeleteRule,
  AUpdateRule: TADDatSConstraintRule);
var
  s: String;
  i: Integer;
begin
  Create;
  if AName <> '' then
    Name := AName;
  ASSERT(AParentColumns[Low(AParentColumns)] <> nil);
  RelatedTable := AParentColumns[Low(AParentColumns)].Table;
  s := AParentColumns[Low(AParentColumns)].Name;
  for i := Low(AParentColumns) + 1 to High(AParentColumns) do begin
    ASSERT(AParentColumns[i] <> nil);
    s := s + ';' + AParentColumns[i].Name;
  end;
  RelatedColumnNames := s;
  ASSERT(AChildColumns[Low(AChildColumns)] <> nil);
  s := AChildColumns[Low(AChildColumns)].Name;
  for i := Low(AChildColumns) + 1 to High(AChildColumns) do begin
    ASSERT(AChildColumns[i] <> nil);
    s := s + ';' + AChildColumns[i].Name;
  end;
  ColumnNames := s;
  DeleteRule := ADeleteRule;
  UpdateRule := AUpdateRule;
  Enforce := True;
end;

{-------------------------------------------------------------------------------}
constructor TADDatSForeignKeyConstraint.Create(const AName,
  AParentTableName, AParentColumnNames, AChildColumnNames: String;
  ADeleteRule, AUpdateRule: TADDatSConstraintRule);
begin
  Create;
  if AName <> '' then
    Name := AName;
  FRelatedTableName := AParentTableName;
  RelatedColumnNames := AParentColumnNames;
  ColumnNames := AChildColumnNames;
  DeleteRule := ADeleteRule;
  UpdateRule := AUpdateRule;
  Enforce := True;
end;

{-------------------------------------------------------------------------------}
constructor TADDatSForeignKeyConstraint.Create(const AName: String;
  AParentTable: TADDatSTable; const AParentColumnNames, AChildColumnNames: String;
  ADeleteRule, AUpdateRule: TADDatSConstraintRule);
begin
  Create;
  if AName <> '' then
    Name := AName;
  RelatedTable := AParentTable;
  RelatedColumnNames := AParentColumnNames;
  ColumnNames := AChildColumnNames;
  DeleteRule := ADeleteRule;
  UpdateRule := AUpdateRule;
  Enforce := True;
end;

{-------------------------------------------------------------------------------}
destructor TADDatSForeignKeyConstraint.Destroy;
begin
  Enforce := False;
  FreeAndNil(FColumns);
  FreeAndNil(FRelatedColumns);
  FRelatedTable := nil;
  FreeAndNil(FCascadingRows);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSForeignKeyConstraint.Assign(AObj: TADDatSObject);
begin
  inherited Assign(AObj);
  if AObj is TADDatSForeignKeyConstraint then begin
    ColumnNames := TADDatSForeignKeyConstraint(AObj).ColumnNames;
    RelatedColumnNames := TADDatSForeignKeyConstraint(AObj).RelatedColumnNames;
    if TADDatSForeignKeyConstraint(AObj).RelatedTable <> nil then
      FRelatedTableName := TADDatSForeignKeyConstraint(AObj).RelatedTable.Name
    else
      FRelatedTableName := '';
    FRelatedTable := nil;
    DeleteRule := TADDatSForeignKeyConstraint(AObj).DeleteRule;
    UpdateRule := TADDatSForeignKeyConstraint(AObj).UpdateRule;
    ParentMessage := TADDatSForeignKeyConstraint(AObj).ParentMessage;
    AcceptRejectRule := TADDatSForeignKeyConstraint(AObj).AcceptRejectRule;
    FieldValueRequired := TADDatSForeignKeyConstraint(AObj).FieldValueRequired;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSForeignKeyConstraint.IsEqualTo(AObj: TADDatSObject):
  Boolean;
begin
  Result := inherited IsEqualTo(AObj);
  if Result then
    Result := (ColumnNames = TADDatSForeignKeyConstraint(AObj).ColumnNames) and
              (RelatedColumnNames = TADDatSForeignKeyConstraint(AObj).RelatedColumnNames) and
              (RelatedTable = TADDatSForeignKeyConstraint(AObj).RelatedTable) and
              (DeleteRule = TADDatSForeignKeyConstraint(AObj).DeleteRule) and
              (UpdateRule = TADDatSForeignKeyConstraint(AObj).UpdateRule) and
              (ParentMessage = TADDatSForeignKeyConstraint(AObj).ParentMessage) and
              (AcceptRejectRule = TADDatSForeignKeyConstraint(AObj).AcceptRejectRule) and
              (FieldValueRequired = TADDatSForeignKeyConstraint(AObj).FieldValueRequired);
end;

{-------------------------------------------------------------------------------}
function TADDatSForeignKeyConstraint.GetChildSortedView: TADDatSView;
begin
  Result := Table.Views.FindSortedView(ColumnNames, [], [soNoCase]);
  if Result = nil then begin
    Result := TADDatSView.Create(Table, C_AD_SysNamePrefix + 'FKC_' + Name,
      vcForeignKeyConstraint, False);
    try
      Result.Mechanisms.AddSort(ColumnNames);
      Result.Active := True;
    except
      Result.Free;
      raise;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSForeignKeyConstraint.GetMasterSortedView: TADDatSView;
begin
  Result := RelatedTable.Views.FindSortedView(RelatedColumnNames, [], [soNoCase]);
  if Result = nil then begin
    Result := TADDatSView.Create(RelatedTable, C_AD_SysNamePrefix + 'FKM_' + Name,
      vcForeignKeyConstraint, False);
    try
      Result.Mechanisms.AddSort(RelatedColumnNames);
      Result.Active := True;
    except
      Result.Free;
      raise;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSForeignKeyConstraint.CheckRow(ARow: TADDatSRow): Boolean;
begin
  Result := (FCascadingRows.IndexOf(ARow) = -1);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSForeignKeyConstraint.DoCheck(ARow: TADDatSRow;
  AProposedState: TADDatSRowState);
var
  oMasterView, oChildView: TADDatSView;
  iPos: Integer;
  lFound: Boolean;
  oRowList: TList;

  procedure SelectChildRows;
  var
    oRow: TADDatSRow;
  begin
    oRowList := TList.Create;
    repeat
      oRow := oChildView.Rows.ItemsI[iPos];
      if oRow.RowState = rsChecking then
        ADException(Self, [S_AD_LDatS], er_AD_FoundCascadeLoop, [Name]);
      oRowList.Add(oRow);
      Inc(iPos);
    until (iPos >= oChildView.Rows.Count) or
          (ARow.CompareRows(FRelatedColumns, nil, nil, -1, oChildView.Rows.ItemsI[iPos],
                            FColumns, rvPrevious, [], ADEmptyCC) <> 0);
  end;

  procedure DeleteChildRows;
  var
    i: Integer;
    oCurRow: TADDatSRow;
  begin
    for i := 0 to oRowList.Count - 1 do begin
      oCurRow := TADDatSRow(oRowList[i]);
      if not (oCurRow.RowState in [rsDeleted, rsDetached, rsInitializing]) then begin
        FCascadingRows.Add(oCurRow);
        try
          oCurRow.Delete;
        finally
          FCascadingRows.Remove(oCurRow);
        end;
      end;
    end;
  end;

  procedure NullifyChildRows;
  var
    i, j: Integer;
    oCurRow: TADDatSRow;
    lNeedEndEdit: Boolean;
    pBuff: Pointer;
    iLen: LongWord;
  begin
    iLen := 0;
    pBuff := nil;
    for i := 0 to oRowList.Count - 1 do begin
      oCurRow := TADDatSRow(oRowList[i]);
      if not (oCurRow.RowState in [rsDeleted, rsDetached, rsInitializing]) then begin
        FCascadingRows.Add(oCurRow);
        try
          lNeedEndEdit := False;
          try
            for j := 0 to FColumns.Count - 1 do begin
              if oCurRow.GetData(FColumns.ItemsI[j].Index, rvDefault, pBuff, 0, iLen, False) then begin
                if oCurRow.RowState <> rsEditing then begin
                  oCurRow.BeginEdit;
                  lNeedEndEdit := True;
                end;
                oCurRow.SetData(FColumns.ItemsI[j].Index, nil, 0);
              end;
            end;
            if lNeedEndEdit then
              oCurRow.EndEdit;
          except
            if lNeedEndEdit then
              oCurRow.CancelEdit;
            raise;
          end;
        finally
          FCascadingRows.Remove(oCurRow);
        end;
      end;
    end;
  end;

  procedure UpdateChildRows;
  var
    i, j: Integer;
    iLen: LongWord;
    pData: Pointer;
    oCurRow: TADDatSRow;
    lNeedEndEdit: Boolean;
  begin
    iLen := 0;
    pData := nil;
    for i := 0 to oRowList.Count - 1 do begin
      oCurRow := TADDatSRow(oRowList[i]);
      if not (oCurRow.RowState in [rsDeleted, rsDetached, rsInitializing]) then begin
        FCascadingRows.Add(oCurRow);
        try
          lNeedEndEdit := False;
          try
            if ARow.CompareRows(FRelatedColumns, nil, nil, -1, oCurRow,
                                FColumns, rvDefault, [], ADEmptyCC) <> 0 then
              for j := 0 to FColumns.Count - 1 do begin
                if oCurRow.RowState <> rsEditing then begin
                  oCurRow.BeginEdit;
                  lNeedEndEdit := True;
                end;
                ARow.GetData(FRelatedColumns.ItemsI[j].Index, rvDefault, pData, 0, iLen, False);
                oCurRow.SetData(FColumns.ItemsI[j].Index, pData, iLen);
              end;
            if lNeedEndEdit then
              oCurRow.EndEdit;
          except
            if lNeedEndEdit then
              oCurRow.CancelEdit;
            raise;
          end;
        finally
          FCascadingRows.Remove(oCurRow);
        end;
      end;
    end;
  end;

  procedure AcceptChildRows(AAccept: Boolean);
  var
    i: Integer;
    oCurRow: TADDatSRow;
  begin
    for i := 0 to oRowList.Count - 1 do begin
      oCurRow := TADDatSRow(oRowList[i]);
      if AAccept then
        oCurRow.AcceptChanges
      else
        oCurRow.RejectChanges;
    end;
  end;

  function CheckNotNull(AColumns: TADDatSColumnSublist): Boolean;
  var
    i: Integer;
    pBuff: Pointer;
    iLen: LongWord;
  begin
    Result := True;
    if FFieldValueRequired then begin
      iLen := 0;
      pBuff := nil;
      for i := 0 to AColumns.Count - 1 do
        if not ARow.GetData(AColumns.ItemsI[i].Index, rvDefault, pBuff, 0, iLen, False) then begin
          Result := False;
          Break;
        end;
    end;
  end;

  procedure ErrorHasChildRows;
  begin
    if ParentMessage <> '' then
      ADException(Self, [S_AD_LDatS], er_AD_HasChildRows, [ParentMessage, 0])
    else
      ADException(Self, [S_AD_LDatS], er_AD_HasChildRows, [Name, 1]);
  end;

  procedure ErrorNoMasterRow;
  begin
    if Message <> '' then
      ADException(Self, [S_AD_LDatS], er_AD_NoMasterRow, [Message, 0])
    else
      ADException(Self, [S_AD_LDatS], er_AD_NoMasterRow, [Name, 1]);
  end;

begin
  if RelatedTable = nil then
    Exit;
  oRowList := nil;
  iPos := -1;
  lFound := False;
  try
    // --- master table
    if ARow.Table = RelatedTable then begin
      oChildView := GetChildSortedView;
      case AProposedState of
      rsInitializing,
      rsDetached,
      rsDeleted:
        case DeleteRule of
        crRestrict:
          if CheckNotNull(FRelatedColumns) then begin
            oChildView.Search(ARow, nil, FRelatedColumns, -1, [], iPos, lFound, rvDefault);
            if lFound then
              ErrorHasChildRows;
          end;
        crCascade:
          begin
            oChildView.Search(ARow, nil, FRelatedColumns, -1, [], iPos, lFound, rvPrevious);
            if lFound then begin
              SelectChildRows;
              DeleteChildRows;
            end;
          end;
        crNullify:
          begin
            oChildView.Search(ARow, nil, FRelatedColumns, -1, [], iPos, lFound, rvPrevious);
            if lFound then begin
              SelectChildRows;
              NullifyChildRows;
            end;
          end;
        end;
      rsModified:
        case UpdateRule of
        crRestrict:
          if CheckNotNull(FRelatedColumns) then begin
            oChildView.Search(ARow, nil, FRelatedColumns, -1, [], iPos, lFound, rvPrevious);
            if lFound and not ARow.CompareColumnsVersions(FRelatedColumns, rvPrevious, rvDefault) then
              ErrorHasChildRows;
          end;
        crCascade:
          begin
            oChildView.Search(ARow, nil, FRelatedColumns, -1, [], iPos, lFound, rvPrevious);
            if lFound then begin
              SelectChildRows;
              UpdateChildRows;
            end;
          end;
        crNullify:
          begin
            oChildView.Search(ARow, nil, FRelatedColumns, -1, [], iPos, lFound, rvPrevious);
            if lFound then begin
              SelectChildRows;
              NullifyChildRows;
            end;
          end;
        end;
      rsUnchanged,
      rsDestroying:
        if AcceptRejectRule = arCascade then begin
          oChildView.Search(ARow, nil, FRelatedColumns, -1, [], iPos, lFound, rvDefault);
          if lFound then begin
            SelectChildRows;
            AcceptChildRows(AProposedState = rsUnchanged);
          end;
        end;
      end;
    end
    // --- child table
    else if ARow.Table = Table then begin
      if (AProposedState in [rsInserted, rsModified]) and CheckNotNull(FColumns) then begin
        oMasterView := GetMasterSortedView;
        oMasterView.Search(ARow, nil, FColumns, -1, [], iPos, lFound);
        if not lFound then
          ErrorNoMasterRow;
      end;
    end;
  finally
    FreeAndNil(oRowList);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSForeignKeyConstraint.DoInsertAssignParentValues(AParentRow,
  AChildRow: TADDatSRow);
var
  i: Integer;
  iLen: LongWord;
  pData: Pointer;
begin
  iLen := 0;
  pData := nil;
  for i := 0 to FColumns.Count - 1 do begin
    AParentRow.GetData(FRelatedColumns.ItemsI[i].Index, rvDefault, pData, 0, iLen, False);
    AChildRow.SetData(FColumns.ItemsI[i].Index, pData, iLen);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSForeignKeyConstraint.DoEnforceUpdated;
  procedure InvalidForeignKey;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_BadForeignKey, [Name]);
  end;
var
  oManager: TADDatSManager;
  i: Integer;
begin
  if not ActualEnforce then begin
    FColumns.Clear;
    FRelatedColumns.Clear;
  end
  else begin
    if FRelatedTableName <> '' then begin
      oManager := Manager;
      if oManager <> nil then begin
        FRelatedTable := oManager.Tables.TableByName(FRelatedTableName);
        FRelatedTableName := '';
      end;
    end;
    FColumns.Fill(Self, FColumnNames);
    FRelatedColumns.Fill(FRelatedTable, FRelatedColumnNames);
    if (FRelatedTable = nil) or (FRelatedTable.Manager <> Manager) or
       (FColumns.Count = 0) or (FColumns.Count <> FRelatedColumns.Count) or
       FColumns.Matches(FRelatedColumns) then
      InvalidForeignKey;
    for i := 0 to FColumns.Count - 1 do
      if FColumns[i].DataType <> FRelatedColumns[i].DataType then
        InvalidForeignKey;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSForeignKeyConstraint.GetColumnCount: Integer;
begin
  Result := FColumns.Count;
end;

{-------------------------------------------------------------------------------}
function TADDatSForeignKeyConstraint.GetColumns(AIndex: Integer): TADDatSColumn;
begin
  Result := FColumns.ItemsI[AIndex];
end;

{-------------------------------------------------------------------------------}
function TADDatSForeignKeyConstraint.GetRelatedColumnCount: Integer;
begin
  Result := FRelatedColumns.Count;
end;

{-------------------------------------------------------------------------------}
function TADDatSForeignKeyConstraint.GetRelatedColumns(AIndex: Integer): TADDatSColumn;
begin
  Result := FRelatedColumns.ItemsI[AIndex];
end;

{-------------------------------------------------------------------------------}
procedure TADDatSForeignKeyConstraint.HandleNotification(AParam: PDEDatSNotifyParam);
begin
  if (FColumns <> nil) and FColumns.HandleNotification(AParam) or
     (FRelatedColumns <> nil) and FRelatedColumns.HandleNotification(AParam) then
    Enforce := False
  else
    with AParam^ do
      if (FKind = snObjectRemoved) and (FParam2 = LongWord(RelatedTable)) then
        RelatedTable := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSForeignKeyConstraint.SetColumnNames(const AValue: String);
begin
  if FColumnNames <> AValue then begin
    FColumnNames := AValue;
    Enforce := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSForeignKeyConstraint.SetRelatedColumnNames(const AValue: String);
begin
  if FRelatedColumnNames <> AValue then begin
    FRelatedColumnNames := AValue;
    Enforce := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSForeignKeyConstraint.SetRelatedTable(const AValue: TADDatSTable);
begin
  if FRelatedTable <> AValue then begin
    FRelatedTable := AValue;
    Enforce := False;
  end;
end;

{-------------------------------------------------------------------------------}
{- TADDatSCheckConstraint                                                      -}
{-------------------------------------------------------------------------------}
constructor TADDatSCheckConstraint.Create(const AExpression: string);
begin
  Create('', AExpression);
end;

{-------------------------------------------------------------------------------}
constructor TADDatSCheckConstraint.Create(const AName, AExpression: string;
  const AMessage: String = ''; ACheckTime: TADDatSCheckTime = ctAtEditEnd);
begin
  Create;
  if AName <> '' then
    Name := AName;
  Expression := AExpression;
  Message := AMessage;
  CheckTime := ACheckTime;
  Enforce := True;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSCheckConstraint.Assign(AObj: TADDatSObject);
begin
  inherited Assign(AObj);
  if AObj is TADDatSCheckConstraint then
    Expression := TADDatSCheckConstraint(AObj).Expression;
end;

{-------------------------------------------------------------------------------}
function TADDatSCheckConstraint.IsEqualTo(AObj: TADDatSObject): Boolean;
begin
  Result := inherited IsEqualTo(AObj);
  if Result then
    Result := (Expression = TADDatSCheckConstraint(AObj).Expression);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSCheckConstraint.DoCheck(ARow: TADDatSRow; AProposedState: TADDatSRowState);
  procedure ErrorCheckViolated;
  begin
    if Message <> '' then
      ADException(Self, [S_AD_LDatS], er_AD_CheckViolated, [Message, 0])
    else
      ADException(Self, [S_AD_LDatS], er_AD_CheckViolated, [Name, 1]);
  end;
begin
  if (AProposedState in [rsInserted, rsModified]) and (CheckTime = ctAtEditEnd) or
     (AProposedState in [rsEditing, rsImportingCurent, rsImportingOriginal,
      rsImportingProposed]) and (CheckTime = ctAtColumnChange) then begin
    FEvaluator.DataSource.Position := ARow;
    try
      if not FEvaluator.Evaluate then
        ErrorCheckViolated;
    finally
      FEvaluator.DataSource.Position := nil;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSCheckConstraint.DoEnforceUpdated;
var
  oParser: IADStanExpressionParser;
begin
  if ActualEnforce then begin
    ADCreateInterface(IADStanExpressionParser, oParser);
    FEvaluator := oParser.Prepare(TADDatSTableExpressionDS.Create(Table),
      Expression, [],  [poCheck], '');
  end
  else
    FEvaluator := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSCheckConstraint.HandleNotification(AParam: PDEDatSNotifyParam);
begin
  with AParam^ do
    if (FEvaluator <> nil) and
       FEvaluator.HandleNotification(Word(FKind), Word(FReason), FParam1, FParam2) then
      Enforce := False;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSCheckConstraint.SetExpression(const AValue: String);
begin
  if FExpression <> AValue then begin
    FExpression := AValue;
    Enforce := False;
  end;
end;

{-------------------------------------------------------------------------------}
{- TADDatSRelation                                                             -}
{-------------------------------------------------------------------------------}
constructor TADDatSRelation.Create;
begin
  inherited Create;
  FChildColumns := TADDatSColumnSublist.Create;
  FParentColumns := TADDatSColumnSublist.Create;
end;

{-------------------------------------------------------------------------------}
constructor TADDatSRelation.Create(const ARelationName: String;
  AParentColumn, AChildColumn: TADDatSColumn; ANested: Boolean;
  ACreateConstraints: Boolean);
begin
  Create(ARelationName, [AParentColumn], [AChildColumn], ANested, ACreateConstraints);
end;

{-------------------------------------------------------------------------------}
constructor TADDatSRelation.Create(const ARelationName: String;
  const AParentColumns, AChildColumns: array of TADDatSColumn; ANested: Boolean;
  ACreateConstraints: Boolean);
var
  s: String;
  i: Integer;
begin
  Create;
  if ARelationName <> '' then
    Name := ARelationName;
  ASSERT(AParentColumns[Low(AParentColumns)] <> nil);
  ParentTable := AParentColumns[Low(AParentColumns)].Table;
  s := AParentColumns[Low(AParentColumns)].Name;
  for i := Low(AParentColumns) + 1 to High(AParentColumns) do begin
    ASSERT(AParentColumns[i] <> nil);
    s := s + ';' + AParentColumns[i].Name;
  end;
  ParentColumnNames := s;
  ASSERT(AChildColumns[Low(AChildColumns)] <> nil);
  ChildTable := AChildColumns[Low(AChildColumns)].Table;
  s := AChildColumns[Low(AChildColumns)].Name;
  for i := Low(AChildColumns) + 1 to High(AChildColumns) do begin
    ASSERT(AChildColumns[i] <> nil);
    s := s + ';' + AChildColumns[i].Name;
  end;
  ChildColumnNames := s;
  Nested := ANested;
  if ACreateConstraints then begin
    FParentKeyConstraint := BuildParentKeyConstraint;
    FChildKeyConstraint := BuildChildKeyConstraint;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSRelation.BuildChildKeyConstraint: TADDatSForeignKeyConstraint;
begin
  ASSERT((ChildColumnNames <> '') and (ParentColumnNames <> '') and
    (ParentTable <> nil) and (ChildTable <> nil));
  Result := ChildTable.Constraints.AddFK('', ParentTable, ParentColumnNames,
    ChildColumnNames);
end;

{-------------------------------------------------------------------------------}
function TADDatSRelation.BuildParentKeyConstraint: TADDatSUniqueConstraint;
begin
  ASSERT((ParentColumnNames <> '') and (ParentTable <> nil));
  Result := ParentTable.Constraints.AddUK('', ParentColumnNames, True);
end;

{-------------------------------------------------------------------------------}
constructor TADDatSRelation.Create(const ARelationName: String;
  APK: TADDatSUniqueConstraint; AFK: TADDatSForeignKeyConstraint);
begin
  Create;
  if ARelationName <> '' then
    Name := ARelationName;
  ParentKeyConstraint := APK;
  ChildKeyConstraint := AFK;
end;

{-------------------------------------------------------------------------------}
destructor TADDatSRelation.Destroy;
begin
  FreeAndNil(FParentColumns);
  FParentTable := nil;
  FParentKeyConstraint := nil;
  FreeAndNil(FChildColumns);
  FChildTable := nil;
  FChildKeyConstraint := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRelation.Assign(AObj: TADDatSObject);
var
  srcManager: TADDatSManager;
  destManager: TADDatSManager;
begin
  inherited Assign(AObj);
  if AObj is TADDatSRelation then begin
    ChildColumnNames := TADDatSRelation(AObj).ChildColumnNames;
    ParentColumnNames := TADDatSRelation(AObj).ParentColumnNames;
    Nested := TADDatSRelation(AObj).Nested;
    srcManager := TADDatSRelation(AObj).Manager;
    destManager := Manager;
    if srcManager = destManager then begin
      ChildTable := TADDatSRelation(AObj).ChildTable;
      ChildKeyConstraint := TADDatSRelation(AObj).ChildKeyConstraint;
      ParentTable := TADDatSRelation(AObj).ParentTable;
      ParentKeyConstraint := TADDatSRelation(AObj).ParentKeyConstraint;
    end
    else if destManager <> nil then begin
      { TODO -cSCH : destManager most probably here is NIL }
      ChildTable := destManager.Tables.TableByName(TADDatSRelation(AObj).ChildTable.Name);
      ChildKeyConstraint := ChildTable.Constraints.ConstraintByName(
        TADDatSRelation(AObj).ChildKeyConstraint.Name) as TADDatSForeignKeyConstraint;
      ParentTable := destManager.Tables.TableByName(TADDatSRelation(AObj).ParentTable.Name);
      ParentKeyConstraint := ChildTable.Constraints.ConstraintByName(
        TADDatSRelation(AObj).ParentKeyConstraint.Name) as TADDatSUniqueConstraint;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRelation.Check;
  procedure ErrorBadRelation;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_BadRelation, [Name]);
  end;
var
  i: Integer;
begin
  if Nested then begin
    if (FChildTable <> nil) and (FChildTable = FParentTable) then
      ErrorBadRelation;
    if (FChildColumns.Count > 1) or
       (FChildColumns.Count = 1) and (FChildColumns.ItemsI[0].DataType <> dtParentRowRef) then
      ErrorBadRelation;
    if (FParentColumns.Count > 1) or
       (FParentColumns.Count = 1) and not (FParentColumns.ItemsI[0].DataType in
        [dtRowSetRef, dtCursorRef, dtRowRef, dtArrayRef]) then
      ErrorBadRelation;
  end
  else begin
    for i := 0 to FChildColumns.Count - 1 do
      if FChildColumns.ItemsI[i].DataType = dtParentRowRef then
        ErrorBadRelation;
    for i := 0 to FParentColumns.Count - 1 do
      if FParentColumns.ItemsI[i].DataType in
         [dtRowSetRef, dtCursorRef, dtRowRef, dtArrayRef] then
        ErrorBadRelation;
    if (FChildTable <> nil) and (FParentTable <> nil) and
       (FChildColumns.Count > 0) and (FParentColumns.Count > 0) and
       (FChildTable = FParentTable) and FChildColumns.Matches(FParentColumns) then
      ErrorBadRelation;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSRelation.GetChildColumnCount: Integer;
begin
  Result := FChildColumns.Count;
end;

{-------------------------------------------------------------------------------}
function TADDatSRelation.GetChildColumns(AIndex: Integer): TADDatSColumn;
begin
  Result := FChildColumns.ItemsI[AIndex];
end;

{-------------------------------------------------------------------------------}
function TADDatSRelation.GetIsDefined: Boolean;
begin
  Result := (FParentTable <> nil) and (FChildTable <> nil) and
    (FParentColumnNames <> '') and (FParentColumns.Count > 0) and
    (FChildColumnNames <> '') and (FChildColumns.Count > 0);
end;

{-------------------------------------------------------------------------------}
function TADDatSRelation.GetParentColumnCount: Integer;
begin
  Result := FParentColumns.Count;
end;

{-------------------------------------------------------------------------------}
function TADDatSRelation.GetParentColumns(AIndex: Integer): TADDatSColumn;
begin
  Result := FParentColumns.ItemsI[AIndex];
end;

{-------------------------------------------------------------------------------}
function TADDatSRelation.GetRelationList: TADDatSRelationList;
begin
  Result := List as TADDatSRelationList;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRelation.HandleNotification(AParam: PDEDatSNotifyParam);
begin
  if (FChildColumns <> nil) and FChildColumns.HandleNotification(AParam) then
    ChildColumnNames := '';
  if (FParentColumns <> nil) and FParentColumns.HandleNotification(AParam) then
    ParentColumnNames := '';
  with AParam^ do
    if FKind = snObjectRemoved then begin
      if TADDatSObject(FParam2) = ParentTable then
        ParentTable := nil
      else if TADDatSObject(FParam2) = ParentKeyConstraint then
        ParentKeyConstraint := nil
      else if TADDatSObject(FParam2) = ChildTable then
        ChildTable := nil
      else if TADDatSObject(FParam2) = ChildKeyConstraint then
        ChildKeyConstraint := nil;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRelation.SetChildColumnNames(const AValue: String);
begin
  if FChildColumnNames <> AValue then begin
    FChildColumnNames := AValue;
    FChildColumns.Fill(FChildTable, FChildColumnNames);
    try
      Check;
    except
      ChildColumnNames := '';
      raise;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRelation.SetChildKeyConstraint(const AValue:
  TADDatSForeignKeyConstraint);
begin
  if FChildKeyConstraint <> AValue then begin
    FChildKeyConstraint := AValue;
    if FChildKeyConstraint <> nil then begin
      Nested := False;
      ChildTable := FChildKeyConstraint.Table;
      ChildColumnNames := FChildKeyConstraint.ColumnNames;
      ParentTable := FChildKeyConstraint.RelatedTable;
      ParentColumnNames := FChildKeyConstraint.RelatedColumnNames;
      Nested := False;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRelation.SetChildTable(const AValue: TADDatSTable);
begin
  if FChildTable <> AValue then begin
    FChildTable := AValue;
    if FChildTable <> nil then begin
      FChildColumns.Fill(FChildTable, FChildColumnNames);
      try
        Check;
      except
        ChildTable := nil;
        raise;
      end;
    end
    else
      FChildColumns.Clear;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRelation.SetNested(const AValue: Boolean);
begin
  if FNested <> AValue then begin
    FNested := AValue;
    try
      Check;
    except
      FNested := not FNested;
      raise;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRelation.SetParentColumnNames(const AValue: String);
begin
  if FParentColumnNames <> AValue then begin
    FParentColumnNames := AValue;
    FParentColumns.Fill(FParentTable, FParentColumnNames);
    try
      Check;
    except
      ParentColumnNames := '';
      raise;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRelation.SetParentKeyConstraint(const AValue: TADDatSUniqueConstraint);
begin
  if FParentKeyConstraint <> AValue then begin
    FParentKeyConstraint := AValue;
    if FParentKeyConstraint <> nil then begin
      Nested := False;
      ParentTable := FParentKeyConstraint.Table;
      ParentColumnNames := FParentKeyConstraint.ColumnNames;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRelation.SetParentTable(const AValue: TADDatSTable);
begin
  if FParentTable <> AValue then begin
    FParentTable := AValue;
    if FParentTable <> nil then begin
      FParentColumns.Fill(FParentTable, FParentColumnNames);
      try
        Check;
      except
        ParentTable := nil;
        raise;
      end;
    end
    else
      FParentColumns.Clear;
  end;
end;

{-------------------------------------------------------------------------------}
{- TADDatSRelationList                                                         -}
{-------------------------------------------------------------------------------}
constructor TADDatSRelationList.CreateForManager(AManager: TADDatSManager);
begin
  ASSERT(AManager <> nil);
  inherited Create;
  FOwner := AManager;
  OwnObjects := True;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRelationList.HandleNotification(AParam: PDEDatSNotifyParam);
begin
  if AParam^.FReason = srDataChange then
    Exit;
  inherited HandleNotification(AParam);
end;

{-------------------------------------------------------------------------------}
function TADDatSRelationList.Add(AObj: TADDatSRelation): Integer;
begin
  Result := AddObject(AObj);
end;

{-------------------------------------------------------------------------------}
function TADDatSRelationList.Add(AParentColumn, AChildColumn: TADDatSColumn;
  ANested, ACreateConstraints: Boolean): TADDatSRelation;
begin
  Result := TADDatSRelation.Create('', AParentColumn, AChildColumn, ANested,
    ACreateConstraints);
  AddEx(Result);
end;

{-------------------------------------------------------------------------------}
function TADDatSRelationList.Add(const ARelName: String;
  AParentColumn, AChildColumn: TADDatSColumn; ANested,
  ACreateConstraints: Boolean): TADDatSRelation;
begin
  Result := TADDatSRelation.Create(ARelName, AParentColumn, AChildColumn,
    ANested, ACreateConstraints);
  AddEx(Result);
end;

{-------------------------------------------------------------------------------}
function TADDatSRelationList.Add(const AParentColumns, AChildColumns: array of TADDatSColumn;
  ANested, ACreateConstraints: Boolean): TADDatSRelation;
begin
  Result := TADDatSRelation.Create('', AParentColumns, AChildColumns, ANested,
    ACreateConstraints);
  AddEx(Result);
end;

{-------------------------------------------------------------------------------}
function TADDatSRelationList.Add(const ARelName: String;
  const AParentColumns, AChildColumns: array of TADDatSColumn;
  ANested, ACreateConstraints: Boolean): TADDatSRelation;
begin
  Result := TADDatSRelation.Create(ARelName, AParentColumns, AChildColumns,
    ANested, ACreateConstraints);
  AddEx(Result);
end;

{-------------------------------------------------------------------------------}
function TADDatSRelationList.Add(const ARelName: String;
  APK: TADDatSUniqueConstraint;
  AFK: TADDatSForeignKeyConstraint): TADDatSRelation;
begin
  Result := TADDatSRelation.Create(ARelName, APK, AFK);
  AddEx(Result);
end;

{-------------------------------------------------------------------------------}
function TADDatSRelationList.FindRelation(AParentTable, AChildTable:
  TADDatSTable; AMBNested: Boolean): TADDatSRelation;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
    with ItemsI[i] do
      if (ParentTable = AParentTable) and (ChildTable = AChildTable) and
         (not AMBNested or AMBNested and Nested) then begin
        if IsDefined then begin
          Result := ItemsI[i];
          Break;
        end
        else if Result = nil then
          Result := ItemsI[i];
      end;
end;

{-------------------------------------------------------------------------------}
function TADDatSRelationList.FindRelation(AParentTable: TADDatSTable;
  AObjColumn: TADDatSColumn): TADDatSRelation;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
    with ItemsI[i] do
      if (ParentTable = AParentTable) and (ParentColumnCount = 1) and
         (ChildColumnCount = 1) and (ParentColumns[0] = AObjColumn) and Nested then begin
        if IsDefined then begin
          Result := ItemsI[i];
          Break;
        end
        else if Result = nil then
          Result := ItemsI[i];
      end;
end;

{-------------------------------------------------------------------------------}
function TADDatSRelationList.FindRelation(ANestedTable: TADDatSTable): TADDatSRelation;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
    with ItemsI[i] do
      if (ChildTable = ANestedTable) and (ParentColumnCount = 1) and
         (ChildColumnCount = 1) and Nested then begin
        if IsDefined then begin
          Result := ItemsI[i];
          Break;
        end
        else if Result = nil then
          Result := ItemsI[i];
      end;
end;

{-------------------------------------------------------------------------------}
function TADDatSRelationList.GetItemsI(AIndex: Integer): TADDatSRelation;
begin
  ASSERT((AIndex >= 0) and (AIndex < FCount));
  Result := TADDatSRelation(FArray[AIndex]);
end;

{-------------------------------------------------------------------------------}
function TADDatSRelationList.RelationByName(const AName: String):
  TADDatSRelation;
begin
  Result := TADDatSRelation(inherited ItemByName(AName));
end;

{-------------------------------------------------------------------------------}
function TADDatSRelationList.GetRelationsForTable(AParentRelations: Boolean;
  ATable: TADDatSTable): TADDatSRelationArray;
var
  iCount, i: Integer;
begin
  SetLength(Result, 32);
  iCount := 0;
  for i := 0 to Count - 1 do
    if AParentRelations and (ItemsI[i].ChildTable = ATable) or
       not AParentRelations and (ItemsI[i].ParentTable = ATable) then begin
      if Length(Result) = iCount then
        SetLength(Result, Length(Result) + 32);
      Result[iCount] := ItemsI[i];
      Inc(iCount);
    end;
  SetLength(Result, iCount);
end;

{-------------------------------------------------------------------------------}
{- TADDatSMechBase                                                             -}
{-------------------------------------------------------------------------------}
procedure TADDatSMechBase.Assign(AObj: TADDatSObject);
begin
  if AObj is TADDatSMechBase then
    Active := TADDatSMechBase(AObj).Active;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechBase.GetRowsRange(var ARowList: TADDatSRowListBase;
  var ABeginInd, AEndInd: Integer): Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechBase.AcceptRow(ARow: TADDatSRow; AVersion:
  TADDatSRowVersion): Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechBase.GetActualActive: Boolean;
begin
  Result := Active and (View <> nil) and View.ActualActive;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechBase.CheckActiveChanged;
begin
  if FPrevActualActive <> ActualActive then begin
    DoActiveChanged;
    FPrevActualActive := ActualActive;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechBase.DoActiveChanged;
begin
  if not Locator then
    Notify(snMechanismStateChanged, srMetaChange, Integer(Self), 0);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechBase.SetActive(const AValue: Boolean);
begin
  if FActive <> AValue then begin
    FActive := AValue;
    CheckActiveChanged;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechBase.DoListInserted;
begin
  CheckActiveChanged;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechBase.DoListRemoving;
begin
  Active := False;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechBase.DoListRemoved(ANewOwner: TADDatSObject);
begin
  CheckActiveChanged;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechBase.GetTable: TADDatSTable;
var
  oView: TADDatSView;
begin
  oView := View;
  if oView <> nil then
    Result := oView.Table
  else
    Result := nil;
  ASSERT((Result = nil) or (Result is TADDatSTable));
end;

{-------------------------------------------------------------------------------}
function TADDatSMechBase.GetView: TADDatSView;
begin
  if (Owner <> nil) and (Owner.Owner <> nil) then
    Result := TADDatSView(Owner.Owner)
  else
    Result := nil;
  ASSERT((Result = nil) or (Result is TADDatSView));
end;

{-------------------------------------------------------------------------------}
function TADDatSMechBase.GetViewList: TADDatSViewList;
var
  oView: TADDatSView;
begin
  oView := View;
  if oView <> nil then
    Result := oView.ViewList
  else
    Result := nil;
  ASSERT((Result = nil) or (Result is TADDatSViewList));
end;

{-------------------------------------------------------------------------------}
{- TADDatSViewMechList                                                         -}
{-------------------------------------------------------------------------------}
constructor TADDatSViewMechList.CreateForView(AView: TADDatSView);
begin
  ASSERT(AView <> nil);
  inherited Create;
  FOwner := AView;
  OwnObjects := True;
  FDefaultReason := srMetaChange;
end;

{-------------------------------------------------------------------------------}
function TADDatSViewMechList.AcceptRow(ARow: TADDatSRow; AVersion:
  TADDatSRowVersion): Boolean;
var
  i: Integer;
begin
  Result := True;
  for i := 0 to Count - 1 do
    if not ItemsI[i].AcceptRow(ARow, AVersion) then begin
      Result := False;
      Exit;
    end;
end;

{-------------------------------------------------------------------------------}
function TADDatSViewMechList.Add(AObj: TADDatSMechBase): Integer;
begin
  Result := AddObject(AObj);
end;

{-------------------------------------------------------------------------------}
function TADDatSViewMechList.AddFilter(const AExpression: String;
  AOptions: TADExpressionOptions; AEvent: TADFilterRowEvent): TADDatSMechFilter;
begin
  Result := TADDatSMechFilter.Create(AExpression, AOptions, AEvent);
  AddEx(Result);
end;

{-------------------------------------------------------------------------------}
function TADDatSViewMechList.AddSort(const AColumns, ADescColumns,
  ACaseInsColumns: String; AOptions: TADSortOptions): TADDatSMechSort;
begin
  Result := TADDatSMechSort.Create(AColumns, ADescColumns,
    ACaseInsColumns, AOptions);
  AddEx(Result);
end;

{-------------------------------------------------------------------------------}
function TADDatSViewMechList.AddSort(const AExpression: String;
  AOptions: TADSortOptions): TADDatSMechSort;
begin
  Result := TADDatSMechSort.Create(AExpression, AOptions);
  AddEx(Result);
end;

{-------------------------------------------------------------------------------}
function TADDatSViewMechList.AddStates(
  AStates: TADDatSRowStates): TADDatSMechRowState;
begin
  Result := TADDatSMechRowState.Create(AStates);
  AddEx(Result);
end;

{-------------------------------------------------------------------------------}
function TADDatSViewMechList.AddError: TADDatSMechError;
begin
  Result := TADDatSMechError.CreateErr;
  AddEx(Result);
end;

{-------------------------------------------------------------------------------}
function TADDatSViewMechList.AddDetail(AParentRel: TADDatSRelation;
  AParentRow: TADDatSRow): TADDatSMechDetails;
begin
  Result := TADDatSMechDetails.Create(AParentRel, AParentRow);
  AddEx(Result);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSViewMechList.Clear;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    ItemsI[i].Active := False;
  inherited Clear;
end;

{-------------------------------------------------------------------------------}
function TADDatSViewMechList.GetItemsI(AIndex: Integer): TADDatSMechBase;
begin
  ASSERT((AIndex >= 0) and (AIndex < FCount));
  Result := TADDatSMechBase(FArray[AIndex]);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSViewMechList.HandleNotification(AParam: PDEDatSNotifyParam);
begin
  if AParam^.FReason = srDataChange then
    Exit;
  inherited HandleNotification(AParam);
end;

{-------------------------------------------------------------------------------}
{- TADDatSMechSort                                                             -}
{-------------------------------------------------------------------------------}
constructor TADDatSMechSort.Create;
begin
  inherited Create;
  FKinds := [mkSort];
  FColumnList := TADDatSColumnSublist.Create;
end;

{-------------------------------------------------------------------------------}
constructor TADDatSMechSort.Create(const AColumns, ADescColumns,
  ACaseInsColumns: String; AOptions: TADSortOptions);
begin
  Create;
  Columns := AColumns;
  DescendingColumns := ADescColumns;
  CaseInsensitiveColumns := ACaseInsColumns;
  SortOptions := AOptions;
  Active := True;
end;

{-------------------------------------------------------------------------------}
constructor TADDatSMechSort.Create(const AExpression: String;
  AOptions: TADSortOptions);
begin
  Create;
  Expression := AExpression;
  SortOptions := AOptions;
  Active := True;
end;

{-------------------------------------------------------------------------------}
destructor TADDatSMechSort.Destroy;
begin
  FreeAndNil(FColumnList);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechSort.Assign(AObj: TADDatSObject);
begin
  if AObj is TADDatSMechSort then begin
    Columns := TADDatSMechSort(AObj).Columns;
    DescendingColumns := TADDatSMechSort(AObj).DescendingColumns;
    CaseInsensitiveColumns := TADDatSMechSort(AObj).CaseInsensitiveColumns;
    SortOptions := TADDatSMechSort(AObj).SortOptions;
    Expression := TADDatSMechSort(AObj).Expression;
  end;
  inherited Assign(AObj);
end;

{-------------------------------------------------------------------------------}
function TADDatSMechSort.IsEqualTo(AObj: TADDatSObject): Boolean;
begin
  Result := inherited IsEqualTo(AObj);
  if Result then begin
    ASSERT(AObj <> nil);
    Result := (Columns = TADDatSMechSort(AObj).Columns) and
      (DescendingColumns = TADDatSMechSort(AObj).DescendingColumns) and
      (CaseInsensitiveColumns = TADDatSMechSort(AObj).CaseInsensitiveColumns) and
      (SortOptions = TADDatSMechSort(AObj).SortOptions) and
      (Expression = TADDatSMechSort(AObj).Expression);
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechSort._AddRef: Integer;
begin
  Result := 1;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechSort._Release: Integer;
begin
  Result := 1;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechSort.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechSort.CreateUniqueConstraint: TADDatSUniqueConstraint;
begin
  Result := TADDatSUniqueConstraint.Create;
  Result.Rely := True;
  Result.Name := Table.Constraints.BuildUniqueName(C_AD_SysNamePrefix + 'UC_' + View.Name);
  Result.ColumnNames := Columns;
  Result.Options := SortOptions;
  Table.Constraints.Add(Result);
  Result.Enforce := True;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechSort.DoActiveChanged;
var
  oParser: IADStanExpressionParser;
begin
  if ActualActive then begin
    FUniqueKey := nil;
    if FExpression <> '' then
      FSortSource := ssExpression
    else if (FColumns <> '') and (FColumns <> '#') then
      FSortSource := ssColumns
    else
      FSortSource := ssRowId;
    if not FSortOptionsChanged then
      if not Table.CaseSensitive then
        FSortOptions := FSortOptions + [soNoCase];
    case FSortSource of
    ssColumns:
      begin
        FCaseInsensitiveColumnList := TADDatSColumnSublist.Create;
        FDescendingColumnList := TADDatSColumnSublist.Create;
        try
          if FCaseInsensitiveColumns <> '' then
            FCaseInsensitiveColumnList.Fill(Self, FCaseInsensitiveColumns);
          if FDescendingColumns <> '' then
            FDescendingColumnList.Fill(Self, FDescendingColumns);
          FColumnList.Fill(Self, FColumns, FCaseInsensitiveColumnList,
            FDescendingColumnList);
        finally
          if FCaseInsensitiveColumnList.Count = 0 then
            FreeAndNil(FCaseInsensitiveColumnList);
          if FDescendingColumnList.Count = 0 then
            FreeAndNil(FDescendingColumnList);
        end;
        if [soUnique, soPrimary] * SortOptions <> [] then
          if Table.Constraints.FindUnique(FColumns) = nil then
            FUniqueKey := CreateUniqueConstraint;
      end;
    ssExpression:
      begin
        ADCreateInterface(IADStanExpressionParser, oParser);
        FEvaluator := oParser.Prepare(TADDatSTableExpressionDS.Create(Table),
          Expression, [], [poDefaultExpr], '');
      end;
    end;
  end
  else begin
    if FColumnList <> nil then
      FColumnList.Clear;
    FreeAndNil(FCaseInsensitiveColumnList);
    FreeAndNil(FDescendingColumnList);
    FEvaluator := nil;
    FreeAndNil(FUniqueKey);
  end;
  inherited DoActiveChanged;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechSort.Search(ARowList: TADDatSRowListBase;
  AKeyRow: TADDatSRow; AKeyColumnList, AKeyColumnList2: TADDatSColumnSublist;
  AKeyColumnCount: Integer; AOptions: TADLocateOptions; var AIndex: Integer;
  var AFound: Boolean; ARowVersion: TADDatSRowVersion): Integer;
var
  iMid: Integer;
  iFirstNo, iLastNo: Integer;
  oRow: TADDatSRow;
  iOpts: TADCompareDataOptions;
  oKeyColumns: TADDatSColumnSublist;
  oCache: TADDatSCompareRowsCache;
  lOnKeyRow, lUseRowId: Boolean;

  function CompareRows(ARow1, ARow2: TADDatSRow): Integer;
  begin
    case FSortSource of
    ssColumns:
      Result := ARow1.CompareRows(oKeyColumns, FDescendingColumnList,
        FCaseInsensitiveColumnList, AKeyColumnCount, ARow2, AKeyColumnList2,
        ARowVersion, iOpts, oCache);
    ssExpression:
      Result := ARow1.CompareRowsExp(FEvaluator, ARow2, ARowVersion, iOpts);
    else
      Result := 0;
    end;
    if lUseRowId and (Result = 0) then
      if ARow1.FRowID < ARow2.FRowID then
        Result := -1
      else if ARow1.FRowID > ARow2.FRowID then
        Result := 1
      else
        Result := 0;
  end;

begin
  ASSERT((ARowList <> nil) and (AKeyRow <> nil));
  Result := 0;
  AIndex := -1;
  AFound := False;
  iFirstNo := 0;
  iLastNo := ARowList.Count - 1;
  iOpts := [coCache];
  iMid := -1;
  lOnKeyRow := False;
  lUseRowId := (loUseRowID in AOptions) and ([soUnique, soPrimary] * FSortOptions = []) or
    (FSortSource = ssRowID);
  if AKeyColumnList = nil then
    oKeyColumns := FColumnList
  else
    oKeyColumns := AKeyColumnList;
  if loNoCase in AOptions then
    Include(iOpts, coNoCase);
  if soNullLess in SortOptions then
    Include(iOpts, coNullLess);
  if soDescending in SortOptions then
    Include(iOpts, coDescending);
  if loPartial in AOptions then
    Include(iOpts, coPartial);
  while iFirstNo <= iLastNo do begin
    iMid := (iFirstNo + iLastNo) div 2;
    oRow := ARowList.ItemsI[iMid];
    if (loExcludeKeyRow in AOptions) and (oRow = AKeyRow) then begin
      if iMid < iLastNo then begin
        Inc(iMid);
        oRow := ARowList.ItemsI[iMid];
      end
      else if iMid > iFirstNo then begin
        Dec(iMid);
        oRow := ARowList.ItemsI[iMid];
      end
      else begin
        lOnKeyRow := True;
        Result := -1;
        Dec(iMid);
        Break;
      end;
    end;
    if oRow <> nil then
      Result := CompareRows(oRow, AKeyRow);
    if Result > 0 then
      iLastNo := iMid - 1
    else if Result < 0 then
      iFirstNo := iMid + 1
    else begin
      if loLast in AOptions then
        while iMid < ARowList.Count - 1 do begin
          Inc(iMid);
          oRow := ARowList.ItemsI[iMid];
          Result := CompareRows(oRow, AKeyRow);
          if Result <> 0 then begin
            Dec(iMid);
            Break;
          end;
        end
      else
        while iMid > 0 do begin
          Dec(iMid);
          oRow := ARowList.ItemsI[iMid];
          Result := CompareRows(oRow, AKeyRow);
          if Result <> 0 then begin
            Inc(iMid);
            Break;
          end;
        end;
      Result := 0;
      AFound := True;
      Break;
    end;
  end;
  if iFirstNo >= ARowList.Count then
    AIndex := ARowList.Count
  else if iLastNo < 0 then
    AIndex := -1
  else if iMid < 0 then
    AIndex := iFirstNo
  else if iMid >= ARowList.Count then
    AIndex := iLastNo
  else if ARowList.Count <> 0 then begin
    AIndex := iMid;
    if (lOnKeyRow or (Result = -1)) and (loLast in AOptions) then
      if coDescending in iOpts then begin
        if Result = -1 then
          Dec(AIndex)
        else if Result = 1 then
          Inc(AIndex);
      end
      else begin
        if Result = -1 then
          Inc(AIndex)
        else if Result = 1 then
          Dec(AIndex);
      end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechSort.HandleNotification(AParam: PDEDatSNotifyParam);
begin
  with AParam^ do
    if (FColumnList <> nil) and
         FColumnList.HandleNotification(AParam) or
       (FDescendingColumnList <> nil) and
         FDescendingColumnList.HandleNotification(AParam) or
       (FCaseInsensitiveColumnList <> nil) and
         FCaseInsensitiveColumnList.HandleNotification(AParam) or
       (FEvaluator <> nil) and
         FEvaluator.HandleNotification(Word(FKind), Word(FReason), FParam1, FParam2) then
      Active := False
    else if FKind = snObjectRemoved then
      if FParam2 = LongWord(FUniqueKey) then
        FUniqueKey := nil
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechSort.SetCaseInsensitiveColumns(const AValue: String);
begin
  if FCaseInsensitiveColumns <> AValue then begin
    FCaseInsensitiveColumns := AValue;
    Active := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechSort.SetColumns(const AValue: String);
begin
  if FColumns <> AValue then begin
    FColumns := AValue;
    FExpression := '';
    Active := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechSort.SetExpression(const AValue: String);
begin
  if FExpression <> AValue then begin
    FExpression := AValue;
    FColumns := '';
    FCaseInsensitiveColumns := '';
    FDescendingColumns := '';
    Active := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechSort.SetDescendingColumns(const AValue: String);
begin
  if FDescendingColumns <> AValue then begin
    FDescendingColumns := AValue;
    Active := False;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechSort.GetSortOptions: TADSortOptions;
begin
  Result := FSortOptions;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechSort.SetSortOptions(const AValue: TADSortOptions);
begin
  if FSortOptions <> AValue then begin
    FSortOptions := AValue;
    FSortOptionsChanged := True;
    Active := False;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechSort.CompareRows(ARow1, ARow2: TADDatSRow;
  AColumnCount: Integer; AOptions: TADCompareDataOptions): Integer;
begin
  case FSortSource of
  ssColumns:
    Result := ARow1.CompareRows(FColumnList, FDescendingColumnList,
      FCaseInsensitiveColumnList, AColumnCount, ARow2, nil, rvDefault,
      AOptions, ADEmptyCC);
  ssExpression:
    Result := ARow1.CompareRowsExp(FEvaluator, ARow2, rvDefault, AOptions);
  else
    Result := 0;
  end;
  // pokr: учту "родной" порядок сортировки
  if (FSortSource = ssRowId) or ((Result = 0) and
     (AColumnCount < 0) and ([soUnique, soPrimary] * FSortOptions = [])) then
    if ARow1.FRowID < ARow2.FRowID then
      Result := -1
    else if ARow1.FRowID > ARow2.FRowID then
      Result := 1
    else
      Result := 0;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechSort.CompareRows(ARow1, ARow2: TADDatSRow;
  AColumnCount: Integer): Integer;
var
  iOpts: TADCompareDataOptions;
begin
  iOpts := [];
  if soNoCase in SortOptions then
    Include(iOpts, coNoCase);
  if soNullLess in SortOptions then
    Include(iOpts, coNullLess);
  if soDescending in SortOptions then
    Include(iOpts, coDescending);
  Result := CompareRows(ARow1, ARow2, AColumnCount, iOpts);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechSort.Sort(AList: TADDatSRowListBase);
var
  iOpts: TADCompareDataOptions;
begin
  iOpts := [];
  if soNoCase in SortOptions then
    Include(iOpts, coNoCase);
  if soNullLess in SortOptions then
    Include(iOpts, coNullLess);
  if soDescending in SortOptions then
    Include(iOpts, coDescending);
  AList.Sort(CompareRows, iOpts);
  if ([soUnique, soPrimary] * SortOptions <> []) and (GetSortSource <> ssRowId) then
    AList.CheckDuplicates(CompareRows, iOpts);
end;

{-------------------------------------------------------------------------------}
function TADDatSMechSort.MatchOptions(ARequiredOptions, AProhibitedOptions: TADSortOptions): Boolean;

  function NormOpts(AOpts: TADSortOptions): TADSortOptions;
  begin
    if [soUnique, soPrimary] * AOpts <> [] then
      Result := AOpts + [soUnique, soPrimary]
    else
      Result := AOpts;
  end;

var
  eSortOpts, eReqOpts, eProhOpts: TADSortOptions;
begin
  eSortOpts := NormOpts(SortOptions);
  eReqOpts := NormOpts(ARequiredOptions);
  eProhOpts := NormOpts(AProhibitedOptions);
  Result := (eSortOpts * eReqOpts = eReqOpts) and (eSortOpts * eProhOpts = []);
end;

{-------------------------------------------------------------------------------}
function TADDatSMechSort.SortingOn(const AColumnNames: String;
  ARequiredOptions, AProhibitedOptions: TADSortOptions): Boolean;
begin
  Result := (Pos(AColumnNames, Columns) = 1) and (
    (Length(AColumnNames) = Length(Columns)) or
    (Columns[Length(AColumnNames) + 1] = ';')
  ) and MatchOptions(ARequiredOptions, AProhibitedOptions);
end;

{-------------------------------------------------------------------------------}
function TADDatSMechSort.SortingOn(AKeyColumnList: TADDatSColumnSublist;
  AKeyColumnCount: Integer; ARequiredOptions, AProhibitedOptions: TADSortOptions): Boolean;
begin
  Result := (SortSource = ssColumns) and
    SortColumnList.Matches(AKeyColumnList, AKeyColumnCount) and
    MatchOptions(ARequiredOptions, AProhibitedOptions);
end;

{-------------------------------------------------------------------------------}
function TADDatSMechSort.GetSortCaseInsensitiveColumnList: TADDatSColumnSublist;
begin
  Result := FCaseInsensitiveColumnList;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechSort.GetSortColumnList: TADDatSColumnSublist;
begin
  Result := FColumnList;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechSort.GetSortDescendingColumnList: TADDatSColumnSublist;
begin
  Result := FDescendingColumnList;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechSort.GetSortSource: TADDatSMechSortSource;
begin
  Result := FSortSource;
end;

{-------------------------------------------------------------------------------}
{- TADDatSMechRowState                                                         -}
{-------------------------------------------------------------------------------}
constructor TADDatSMechRowState.Create;
begin
  inherited Create;
  FKinds := [mkFilter];
end;

{-------------------------------------------------------------------------------}
constructor TADDatSMechRowState.Create(AStates: TADDatSRowStates);
begin
  Create;
  RowStates := AStates;
  Active := True;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechRowState.AcceptRow(ARow: TADDatSRow; AVersion:
  TADDatSRowVersion): Boolean;
begin
  ASSERT(ARow <> nil);
  Result := ARow.RowState in RowStates;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechRowState.Assign(AObj: TADDatSObject);
begin
  if AObj is TADDatSMechRowState then
    RowStates := TADDatSMechRowState(AObj).RowStates;
  inherited Assign(AObj);
end;

{-------------------------------------------------------------------------------}
function TADDatSMechRowState.IsEqualTo(AObj: TADDatSObject): Boolean;
begin
  Result := inherited IsEqualTo(AObj);
  if Result then begin
    ASSERT(AObj <> nil);
    Result := RowStates = TADDatSMechRowState(AObj).RowStates;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechRowState.SetRowStates(const AValue: TADDatSRowStates);
begin
  if FRowStates <> AValue then begin
    FRowStates := AValue;
    Active := False;
  end;
end;

{-------------------------------------------------------------------------------}
{- TADDatSMechRange                                                            -}
{-------------------------------------------------------------------------------}
constructor TADDatSMechRange.Create;
begin
  inherited Create;
  FKinds := [mkFilter];
  BottomColumnCount := -1;
  BottomExclusive := False;
  TopColumnCount := -1;
  TopExclusive := False;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechRange.Assign(AObj: TADDatSObject);
begin
  if AObj is TADDatSMechRange then begin
    SortMech := TADDatSMechRange(AObj).SortMech;
    BottomExclusive := TADDatSMechRange(AObj).BottomExclusive;
    TopExclusive := TADDatSMechRange(AObj).TopExclusive;
    BottomColumnCount := TADDatSMechRange(AObj).BottomColumnCount;
    TopColumnCount := TADDatSMechRange(AObj).TopColumnCount;
    if (TADDatSMechRange(AObj).Top <> nil) and
       (TADDatSMechRange(AObj).Top.Table <> Table) then
      Top := TADDatSMechRange(AObj).Top
    else
      Top := nil;
    if (TADDatSMechRange(AObj).Bottom <> nil) and
       (TADDatSMechRange(AObj).Bottom.Table <> Table) then
      Bottom := TADDatSMechRange(AObj).Bottom
    else
      Bottom := nil;
  end;
  inherited Assign(AObj);
end;

{-------------------------------------------------------------------------------}
function TADDatSMechRange.IsEqualTo(AObj: TADDatSObject): Boolean;
begin
  Result := inherited IsEqualTo(AObj);
  if Result then begin
    ASSERT(AObj <> nil);
    Result :=
      (SortMech = TADDatSMechRange(AObj).SortMech) and
      (BottomExclusive = TADDatSMechRange(AObj).BottomExclusive) and
      (TopExclusive = TADDatSMechRange(AObj).TopExclusive) and
      (BottomColumnCount = TADDatSMechRange(AObj).BottomColumnCount) and
      (TopColumnCount = TADDatSMechRange(AObj).TopColumnCount);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechRange.DoActiveChanged;
var
  oView: TADDatSView;
begin
  if ActualActive then
    if SortMech = nil then begin
      oView := View;
      if oView <> nil then
        FSortMech := oView.SortingMechanism;
    end;
  inherited DoActiveChanged;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechRange.NoRangeNoRecords: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechRange.GetRowsRange(var ARowList: TADDatSRowListBase;
  var ABeginInd, AEndInd: Integer): Boolean;
var
  iOpts: TADLocateOptions;
  iRes: Integer;
  lTemp: Boolean;
begin
  if (SortMech <> nil) and ((Top <> nil) or (Bottom <> nil)) then begin
    iOpts := [loPartial, loNearest];
    if soNoCase in SortMech.SortOptions then
      Include(iOpts, loNoCase);
    if Bottom <> nil then begin
      lTemp := False;
      iRes := SortMech.Search(ARowList, Bottom, nil, FBottomColumnList,
        FBottomColumnCount, iOpts, ABeginInd, lTemp);
      if iRes > 0 then
        Dec(AEndInd);
    end;
    if Top <> nil then
      SortMech.Search(ARowList, Top, nil, FTopColumnList,
        FTopColumnCount, iOpts + [loLast], AEndInd, lTemp);
    Result := True;
  end
  else begin
    if NoRangeNoRecords then begin
      Result := True;
      ABeginInd := 0;
      AEndInd := -1;
    end
    else
      Result := False;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechRange.AcceptRow(ARow: TADDatSRow; AVersion:
  TADDatSRowVersion): Boolean;
var
  iOpts: TADCompareDataOptions;
  iRes: Integer;
begin
  Result := not NoRangeNoRecords;
  if SortMech <> nil then begin
    iOpts := [];
    if soNoCase in SortMech.SortOptions then
      Include(iOpts, coNoCase);
    if soNullLess in SortMech.SortOptions then
      Include(iOpts, coNullLess);
    if soDescending in SortMech.SortOptions then
      Include(iOpts, coDescending);
    if Bottom <> nil then begin
      iRes := ARow.CompareRows(SortMech.SortColumnList, SortMech.SortDescendingColumnList,
        SortMech.SortCaseInsensitiveColumnList, FBottomColumnCount, Bottom, FBottomColumnList,
        rvDefault, iOpts, ADEmptyCC);
      Result := (iRes > 0) or (iRes = 0) and not BottomExclusive;
    end;
    if Result and (Top <> nil) then begin
      iRes := ARow.CompareRows(SortMech.SortColumnList, SortMech.SortDescendingColumnList,
        SortMech.SortCaseInsensitiveColumnList, FTopColumnCount, Top, FTopColumnList,
        rvDefault, iOpts, ADEmptyCC);
      Result := (iRes < 0) or (iRes = 0) and not TopExclusive;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechRange.SetBottom(const AValue: TADDatSRow);
begin
  if FBottom <> AValue then begin
    FBottom := AValue;
    Active := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechRange.SetTop(const AValue: TADDatSRow);
begin
  if FTop <> AValue then begin
    FTop := AValue;
    Active := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechRange.SetBottomExclusive(const AValue: Boolean);
begin
  if FBottomExclusive <> AValue then begin
    FBottomExclusive := AValue;
    Active := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechRange.SetTopExclusive(const AValue: Boolean);
begin
  if FTopExclusive <> AValue then begin
    FTopExclusive := AValue;
    Active := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechRange.SetSortMech(const AValue: IADDataMechSort);
begin
  FSortMech := AValue;
  Active := False;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechRange.SetBottomColumnCount(const AValue: Integer);
begin
  if FBottomColumnCount <> AValue then begin
    FBottomColumnCount := AValue;
    Active := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechRange.SetTopColumnCount(const AValue: Integer);
begin
  if FTopColumnCount <> AValue then begin
    FTopColumnCount := AValue;
    Active := False;
  end;
end;

{-------------------------------------------------------------------------------}
{- TADDatSMechFilter                                                           -}
{-------------------------------------------------------------------------------}
constructor TADDatSMechFilter.Create;
begin
  inherited Create;
  FKinds := [mkFilter];
  FOptions := [];
end;

{-------------------------------------------------------------------------------}
constructor TADDatSMechFilter.Create(const AExpression: String;
  AOptions: TADExpressionOptions; AEvent: TADFilterRowEvent);
begin
  Create;
  Options := AOptions;
  Expression := AExpression;
  OnFilterRow := AEvent;
  Active := True;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechFilter.Assign(AObj: TADDatSObject);
begin
  if AObj is TADDatSMechFilter then begin
    Options := TADDatSMechFilter(AObj).Options;
    Expression := TADDatSMechFilter(AObj).Expression;
    OnFilterRow := TADDatSMechFilter(AObj).OnFilterRow;
  end;
  inherited Assign(AObj);
end;

{-------------------------------------------------------------------------------}
function TADDatSMechFilter.IsEqualTo(AObj: TADDatSObject): Boolean;
begin
  Result := inherited IsEqualTo(AObj);
  if Result then begin
    ASSERT(AObj <> nil);
    Result := (Expression = TADDatSMechFilter(AObj).Expression) and
      (Options = TADDatSMechFilter(AObj).Options) and
      (TMethod(OnFilterRow).Code <> TMethod(OnFilterRow).Code) and
      (TMethod(OnFilterRow).Data <> TMethod(OnFilterRow).Data);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechFilter.DoActiveChanged;
var
  oParser: IADStanExpressionParser;
begin
  if ActualActive and (Expression <> '') then begin
    ADCreateInterface(IADStanExpressionParser, oParser);
    FEvaluator := oParser.Prepare(TADDatSTableExpressionDS.Create(Table),
      Expression, FOptions, [poCheck], '');
  end
  else
    FEvaluator := nil;
  inherited DoActiveChanged;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechFilter.AcceptRow(ARow: TADDatSRow; AVersion:
  TADDatSRowVersion): Boolean;
begin
  Result := True;
  if FEvaluator <> nil then begin
    FEvaluator.DataSource.Position := ARow;
    try
      Result := FEvaluator.Evaluate;
    finally
      FEvaluator.DataSource.Position := nil;
    end;
  end;
  if Result and Assigned(FOnFilterRow) then
    Result := FOnFilterRow(Self, ARow, AVersion);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechFilter.SetExpression(const AValue: String);
begin
  if FExpression <> AValue then begin
    FExpression := AValue;
    Active := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechFilter.SetOptions(const AValue: TADExpressionOptions);
begin
  if FOptions <> AValue then begin
    FOptions := AValue;
    Active := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechFilter.SetOnFilterRow(const AValue: TADFilterRowEvent);
begin
  if (TMethod(AValue).Code <> TMethod(FOnFilterRow).Code) or
     (TMethod(AValue).Data <> TMethod(FOnFilterRow).Data) then begin
    FOnFilterRow := AValue;
    Active := False;
  end;
end;

{-------------------------------------------------------------------------------}
{- TADDatSMechError                                                            -}
{-------------------------------------------------------------------------------}
constructor TADDatSMechError.Create;
begin
  inherited Create;
  FKinds := [mkFilter];
end;

{-------------------------------------------------------------------------------}
constructor TADDatSMechError.CreateErr(ADummy: Integer);
begin
  Create;
  Active := True;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechError.AcceptRow(ARow: TADDatSRow; AVersion:
  TADDatSRowVersion): Boolean;
begin
  Result := ARow.HasErrors;
end;

{-------------------------------------------------------------------------------}
{- TADDatSMechDetails                                                          -}
{-------------------------------------------------------------------------------}
constructor TADDatSMechDetails.Create(
  AParentRel: TADDatSRelation; AParentRow: TADDatSRow);
begin
  Create;
  ParentRelation := AParentRel;
  ParentRow := AParentRow;
  Active := True;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechDetails.Assign(AObj: TADDatSObject);
var
  oManager: TADDatSManager;
begin
  if AObj is TADDatSMechDetails then begin
    oManager := Manager;
    if oManager = TADDatSMechDetails(AObj).Manager then
      ParentRelation := TADDatSMechDetails(AObj).ParentRelation
    else
      ParentRelation := oManager.Relations.RelationByName(
        TADDatSMechDetails(AObj).ParentRelation.Name);
    if (TADDatSMechDetails(AObj).ParentRow <> nil) and
       (TADDatSMechDetails(AObj).ParentRow.Table <> Table) then
      ParentRow := TADDatSMechDetails(AObj).ParentRow
    else
      ParentRow := nil;
  end;
  inherited Assign(AObj);
end;

{-------------------------------------------------------------------------------}
function TADDatSMechDetails.IsEqualTo(AObj: TADDatSObject): Boolean;
begin
  Result := inherited IsEqualTo(AObj);
  if Result then begin
    ASSERT(AObj <> nil);
    Result := ParentRelation = TADDatSMechDetails(AObj).ParentRelation;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechDetails.GetActualActive: Boolean;
begin
  Result := inherited GetActualActive and
    (ParentRelation <> nil);
end;

{-------------------------------------------------------------------------------}
function TADDatSMechDetails.NoRangeNoRecords: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechDetails.DoActiveChanged;
var
  i: Integer;
begin
  if ActualActive then begin
    FBottom := ParentRow;
    FTop := ParentRow;
    FTopColumnList := ParentRelation.FParentColumns;
    FBottomColumnList := ParentRelation.FParentColumns;
    FSortMech := nil;
  end
  else begin
    FBottom := nil;
    FTop := nil;
    FTopColumnList := nil;
    FBottomColumnList := nil;
    FSortMech := nil;
  end;
  inherited DoActiveChanged;
  if ActualActive and (SortMech <> nil) then
    if SortMech.GetSortColumnList.Count <> ParentRelation.FChildColumns.Count then
      FSortMech := nil
    else
      for i := 0 to SortMech.GetSortColumnList.Count - 1 do
        if SortMech.GetSortColumnList.ItemsI[i] <> ParentRelation.FChildColumns.ItemsI[i] then begin
          FSortMech := nil;
          Break;
        end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechDetails.SetParentRelation(const AValue: TADDatSRelation);
begin
  if FParentRelation <> AValue then begin
    FParentRelation := AValue;
    Active := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechDetails.SetParentRow(const AValue: TADDatSRow);
begin
  if FParentRow <> AValue then begin
    FParentRow := AValue;
    Active := False;
  end;
end;

{-------------------------------------------------------------------------------}
{- TADDatSMechChilds                                                           -}
{-------------------------------------------------------------------------------}
constructor TADDatSMechChilds.Create;
begin
  inherited Create;
  FKinds := [mkFilter, mkHasList];
end;

{-------------------------------------------------------------------------------}
constructor TADDatSMechChilds.Create(AParentRow: TADDatSRow);
begin
  Create;
  ParentRow := AParentRow;
  Active := True;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechChilds.Assign(AObj: TADDatSObject);
begin
  if AObj is TADDatSMechChilds then
    if (TADDatSMechChilds(AObj).ParentRow <> nil) and
       (TADDatSMechChilds(AObj).ParentRow.Table <> Table) then
      ParentRow := TADDatSMechChilds(AObj).ParentRow
    else
      ParentRow := nil;
  inherited Assign(AObj);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechChilds.SetParentRow(const AValue: TADDatSRow);
begin
  if FParentRow <> AValue then begin
    FParentRow := AValue;
    Active := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechChilds.DoActiveChanged;
var
  oRel: TADDatSRelation;
begin
  if ActualActive and (ParentRow <> nil) then begin
    oRel := Manager.Relations.FindRelation(ParentRow.Table, Table, True);
    if oRel = nil then
      Active := False
    else begin
      FRefCol := oRel.FParentColumns.ItemsI[0].Index;
      FRefColType := oRel.ParentTable.Columns.ItemsI[FRefCol].DataType;
    end;
  end
  else begin
    FRefCol := -1;
    FRefColType := dtUnknown;
  end;
  if ActualActive and (FRefColType in [dtRowRef, dtArrayRef]) then
    FRefRow := TADDatSNestedRowList.CreateForRow(nil)
  else
    FreeAndNil(FRefRow);
  inherited DoActiveChanged;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechChilds.GetRowsRange(var ARowList: TADDatSRowListBase;
  var ABeginInd, AEndInd: Integer): Boolean;
var
  oRow: TADDatSRow;
begin
  if ParentRow = nil then
    AEndInd := -1
  else begin
    case FRefColType of
    dtRowSetRef, dtCursorRef:
      ARowList := ParentRow.NestedRows[FRefCol];
    dtRowRef, dtArrayRef:
      begin
        FRefRow.Clear;
        oRow := ParentRow.NestedRow[FRefCol];
        if oRow <> nil then
          FRefRow.Add(oRow);
        ARowList := FRefRow;
      end;
    end;
    AEndInd := ARowList.Count - 1;
  end;
  ABeginInd := 0;
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechChilds.AcceptRow(ARow: TADDatSRow;
  AVersion: TADDatSRowVersion): Boolean;
begin
  Result := False;
  if ParentRow <> nil then
    case FRefColType of
    dtRowSetRef, dtCursorRef:
      Result := (ParentRow.NestedRows[FRefCol].ContainsObj(ARow));
    dtRowRef, dtArrayRef:
      Result := (ParentRow.NestedRow[FRefCol] = ARow);
    end;
end;

{-------------------------------------------------------------------------------}
{- TADDatSMechMaster                                                           -}
{-------------------------------------------------------------------------------}
constructor TADDatSMechMaster.Create(AChildRel: TADDatSRelation;
  AChildRow: TADDatSRow);
begin
  inherited Create;
  ChildRelation := AChildRel;
  ChildRow := AChildRow;
  Active := True;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechMaster.Assign(AObj: TADDatSObject);
var
  oManager: TADDatSManager;
begin
  if AObj is TADDatSMechMaster then begin
    oManager := Manager;
    if oManager = TADDatSMechMaster(AObj).Manager then
      ChildRelation := TADDatSMechMaster(AObj).ChildRelation
    else
      ChildRelation := oManager.Relations.RelationByName(
        TADDatSMechMaster(AObj).ChildRelation.Name);
    if (TADDatSMechMaster(AObj).ChildRow <> nil) and
       (TADDatSMechMaster(AObj).ChildRow.Table <> Table) then
      ChildRow := TADDatSMechMaster(AObj).ChildRow
    else
      ChildRow := nil;
  end;
  inherited Assign(AObj);
end;

{-------------------------------------------------------------------------------}
function TADDatSMechMaster.IsEqualTo(AObj: TADDatSObject): Boolean;
begin
  Result := inherited IsEqualTo(AObj);
  if Result then begin
    ASSERT(AObj <> nil);
    Result := ChildRelation = TADDatSMechMaster(AObj).ChildRelation;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechMaster.GetActualActive: Boolean;
begin
  Result := inherited GetActualActive and
    (ChildRelation <> nil);
end;

{-------------------------------------------------------------------------------}
function TADDatSMechMaster.NoRangeNoRecords: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechMaster.DoActiveChanged;
var
  i: Integer;
begin
  if ActualActive then begin
    FBottom := ChildRow;
    FTop := ChildRow;
    FTopColumnList := ChildRelation.FChildColumns;
    FBottomColumnList := ChildRelation.FChildColumns;
    FSortMech := nil;
  end
  else begin
    FBottom := nil;
    FTop := nil;
    FTopColumnList := nil;
    FBottomColumnList := nil;
    FSortMech := nil;
  end;
  inherited DoActiveChanged;
  if ActualActive and (SortMech <> nil) then
    if SortMech.GetSortColumnList.Count <> ChildRelation.FParentColumns.Count then
      FSortMech := nil
    else
      for i := 0 to SortMech.GetSortColumnList.Count - 1 do
        if SortMech.GetSortColumnList.ItemsI[i] <> ChildRelation.FParentColumns.ItemsI[i] then begin
          FSortMech := nil;
          Break;
        end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechMaster.SetChildRelation(const AValue: TADDatSRelation);
begin
  if FChildRelation <> AValue then begin
    FChildRelation := AValue;
    Active := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechMaster.SetChildRow(const AValue: TADDatSRow);
begin
  if FChildRow <> AValue then begin
    FChildRow := AValue;
    Active := False;
  end;
end;

{-------------------------------------------------------------------------------}
{- TADDatSMechParent                                                           -}
{-------------------------------------------------------------------------------}
constructor TADDatSMechParent.Create;
begin
  inherited Create;
  FKinds := [mkFilter, mkHasRow];
end;

{-------------------------------------------------------------------------------}
constructor TADDatSMechParent.Create(AChildRow: TADDatSRow);
begin
  Create;
  ChildRow := AChildRow;
  Active := True;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechParent.Assign(AObj: TADDatSObject);
begin
  if AObj is TADDatSMechParent then
    if (TADDatSMechParent(AObj).ChildRow <> nil) and
       (TADDatSMechParent(AObj).ChildRow.Table <> Table) then
      ChildRow := TADDatSMechParent(AObj).ChildRow
    else
      ChildRow := nil;
  inherited Assign(AObj);
end;

{-------------------------------------------------------------------------------}
function TADDatSMechParent.GetActualActive: Boolean;
begin
  Result := inherited GetActualActive and (ChildRow <> nil);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechParent.SetChildRow(const AValue: TADDatSRow);
begin
  if FChildRow <> AValue then begin
    FChildRow := AValue;
    Active := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechParent.DoActiveChanged;
begin
  if ActualActive then begin
    FParentRow := TADDatSRowListBase.Create;
    FParentRow.Add(ChildRow.ParentRow);
  end
  else
    FreeAndNil(FParentRow);
  inherited DoActiveChanged;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechParent.GetRowsRange(var ARowList: TADDatSRowListBase;
  var ABeginInd, AEndInd: Integer): Boolean;
begin
  ARowList := FParentRow;
  AEndInd := 0;
  ABeginInd := 0;
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechParent.AcceptRow(ARow: TADDatSRow;
  AVersion: TADDatSRowVersion): Boolean;
begin
  Result := (ARow = FParentRow.ItemsI[0]);
end;

{-------------------------------------------------------------------------------}
{ TADDatSBlobCache                                                              }
{-------------------------------------------------------------------------------}
function TADDatSBlobCache.Allocate(ASize: LongWord): Pointer;
begin
  GetMem(Result, ASize);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSBlobCache.Release(APtr: Pointer; ASize: LongWord);
begin
  FreeMem(APtr, ASize);
end;

{-------------------------------------------------------------------------------}
{- TADDatSRow                                                                  -}
{-------------------------------------------------------------------------------}
constructor TADDatSRow.CreateForTable(ATable: TADDatSTable; ASetToDefaults: Boolean);
begin
  ASSERT(ATable <> nil);
  inherited Create;
  FOwner := ATable;
  FTable := ATable;
  FRowID := $FFFFFFFF;
  FChangeNumber := $FFFFFFFF;
  FRowState := rsDetached;
  FRowPriorState := rsDetached;
  FpProposed := AllocBuffer;
  AllocFetchedMarks;
  AllocInvariants;
  if ASetToDefaults then
    AssignDefaults;
  with FTable do
    SetFetchedMarks(not (DataHandleMode in [lmHavyFetching, lmFetching, lmRefreshing]));
end;

{-------------------------------------------------------------------------------}
class function TADDatSRow.CreateInstance(ATable: TADDatSTable;
  ASetToDefaults: Boolean): TADDatSRow;
var
  p: Pointer;
  oCols: TADDatSColumnList;
begin
  ASSERT(ATable <> nil);
  oCols := ATable.Columns;
  oCols.CheckUpdateLayout(InstanceSize);
  p := oCols.RowsPool.Alloc;
  Result := TADDatSRow(InitInstance(p));
  Result.CreateForTable(ATable, ASetToDefaults);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.FreeInstance;
begin
  ASSERT((Table <> nil) and (Table.Columns <> nil) and (Table.Columns.RowsPool <> nil));
  CleanupInstance;
  Table.Columns.RowsPool.Release(Self);
end;

{-------------------------------------------------------------------------------}
destructor TADDatSRow.Destroy;
begin
  CancelEdit;
  FRowPriorState := RowState;
  FRowState := rsDestroying;
  if Table.Columns.ParentRowRefCol <> -1 then
    ParentRow := nil;
  ClearErrors;
  FreeBuffer(FpCurrent);
  FreeBuffer(FpOriginal);
  FreeBuffer(FpProposed);
  FreeInvariants;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.CheckNoInfo;
begin
  with FExtraInfo^ do
    if (FRowException = nil) and (FCheckColumn = -1) and (FLockID = 0) then begin
      FreeMem(FExtraInfo);
      FExtraInfo := nil;
    end;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetRowInfo(AForce: Boolean): Pointer;
begin
  if (FExtraInfo = nil) and AForce then begin
    GetMem(FExtraInfo, SizeOf(TADDatSRowExtraInfo));
    with FExtraInfo^ do begin
      FRowException := nil;
      FCheckColumn := -1;
      FLockID := 0;
    end;
  end;
  Result := FExtraInfo;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.AllocBuffer: PByte;
begin
  ASSERT(Table.Columns.BuffsPool <> nil);
  Result := Table.Columns.BuffsPool.Alloc;
  try
    InitBuffer(Result);
  except
    Table.Columns.BuffsPool.Release(Result);
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.FreeBuffer(var ApBuffer: PByte);
begin
  if ApBuffer <> nil then begin
    ASSERT(Table.Columns.BuffsPool <> nil);
    CleanupBuffer(ApBuffer);
    Table.Columns.BuffsPool.Release(ApBuffer);
    ApBuffer := nil;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.AllocInvariants;
var
  oCols: TADDatSColumnList;
  i: Integer;
begin
  oCols := Table.Columns;
  if oCols.FInvariants <> 0 then
    for i := 0 to oCols.Count - 1 do
      case oCols.ItemsI[i].DataType of
      dtRowSetRef,
      dtCursorRef:     SetInvariantObject(i, TADDatSNestedRowList.CreateForRow(Self));
      dtRowRef,
      dtArrayRef,
      dtParentRowRef:  SetInvariantObject(i, nil);
      end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.FreeInvariants;
var
  oCols: TADDatSColumnList;
  oNestedRowList: TADDatSNestedRowList;
  oNestedRow: TADDatSRow;
  i, j: Integer;
begin
  oCols := Table.Columns;
  if oCols.FInvariants <> 0 then
    for i := 0 to oCols.Count - 1 do
      case oCols.ItemsI[i].DataType of
      dtRowSetRef, dtCursorRef:
        begin
          oNestedRowList := NestedRows[i];
          for j := oNestedRowList.Count - 1 downto 0 do begin
            oNestedRow := oNestedRowList.ItemsI[j];
            if oNestedRow <> nil then begin
              oNestedRow.ParentRow := nil;
              oNestedRow.Free;
            end;
          end;
          oNestedRowList.Free;
          SetInvariantObject(i, nil);
        end;
      dtRowRef, dtArrayRef:
        begin
          oNestedRow := NestedRow[i];
          if oNestedRow <> nil then begin
            oNestedRow.ParentRow := nil;
            oNestedRow.Free;
          end;
          SetInvariantObject(i, nil);
        end;
      dtParentRowRef:
        SetInvariantObject(i, nil);
      end;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetInvariantObject(AColumn: Integer): TADDatSObject;
var
  oCols: TADDatSColumnList;
begin
  oCols := Table.Columns;
  ASSERT((AColumn >= 0) and (AColumn < oCols.Count));
  ASSERT((oCols.ItemsI[AColumn].DataType in C_AD_InvariantDataTypes) and
         (oCols.FInvariantOffset <> -1));
  Result := TADDatSObject(PLongWord(PChar(Self) + oCols.FInvariantOffset +
    SizeOf(LongWord) * oCols.FInvariantMap[AColumn])^);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.SetInvariantObject(AColumn: Integer; AObj: TADDatSObject);
var
  oCols: TADDatSColumnList;
begin
  oCols := Table.Columns;
  ASSERT((AColumn >= 0) and (AColumn < oCols.Count));
  ASSERT((oCols.ItemsI[AColumn].DataType in C_AD_InvariantDataTypes) and
         ((oCols.FInvariantOffset <> -1)));
  PLongWord(PChar(Self) + oCols.FInvariantOffset +
    SizeOf(LongWord) * oCols.FInvariantMap[AColumn])^ := LongWord(AObj);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.AllocFetchedMarks;
var
  oCols: TADDatSColumnList;
begin
  oCols := Table.Columns;
  ADFillChar((PChar(Self) + oCols.FFetchedOffset)^, oCols.FFetchedSize, #0);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.SetFetchedMarks(AOn: Boolean);
var
  C: Byte;
  oCols: TADDatSColumnList;
begin
  oCols := Table.Columns;
  if AOn then
    C := $FF
  else
    C := 0;
  ADFillChar((PChar(Self) + oCols.FFetchedOffset)^, oCols.FFetchedSize, Char(C));
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.InternalAssignDefaults(ACols: TADDatSColumnList);
var
  i: Integer;
  pVal: Pointer;
  i8Val: Shortint;
  i16Val: Smallint;
  i32Val: Integer;
  i64Val: Int64;
  dVal: Double;
  bcdVal: TADBcd;
{$IFNDEF AnyDAC_D6}
  cVal: Currency;
{$ENDIF}
  eTmpPriorRowState: TADDatSRowState;
begin
  eTmpPriorRowState := FRowPriorState;
  FRowPriorState := RowState;
  FRowState := rsInitializing;
  try
    for i := 0 to ACols.Count - 1 do begin
      with ACols, ItemsI[i] do
        if AutoIncrement then begin
          FAutoIncs[i] := FAutoIncs[i] + AutoIncrementStep;
          case DataType of
          dtByte,
          dtSByte:
            begin
              i8Val := ShortInt(FAutoIncs[i]);
              pVal := @i8Val;
            end;
          dtUInt16,
          dtInt16:
            begin
              i16Val := SmallInt(FAutoIncs[i]);
              pVal := @i16Val;
            end;
          dtUInt32,
          dtInt32:
            begin
              i32Val := FAutoIncs[i];
              pVal := @i32Val;
            end;
          dtUInt64,
          dtInt64:
            begin
              i64Val := FAutoIncs[i];
              pVal := @i64Val;
            end;
          dtDouble:
            begin
              dVal := FAutoIncs[i];
              pVal := @dVal;
            end;
          dtBCD,
          dtFmtBCD:
            begin
{$IFDEF AnyDAC_D6}
              bcdVal := VarToBcd(FAutoIncs[i]);
              pVal := @bcdVal;
{$ELSE}
              cVal := FAutoIncs[i];
              CurrToBCD(cVal, bcdVal);
              pVal := @bcdVal;
{$ENDIF}
            end;
          else
            pVal := nil;
          end;
          SetData(i, pVal, 0);
        end;
    end;
  finally
    FRowState := RowPriorState;
    FRowPriorState := eTmpPriorRowState;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.AssignDefaults;
var
  oCols: TADDatSColumnList;
begin
  with Table do begin
    oCols := Columns;
    if not (ctDefs in oCols.FHasThings) or
       (DataHandleMode in [lmHavyFetching, lmFetching, lmRefreshing]) then
      Exit;
  end;
  InternalAssignDefaults(oCols);
  if ctExps in oCols.FHasThings then
    InternalCalculateColumns(True, oCols);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.BeginEdit;

  procedure ErrorCantEdit;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_CantBeginEdit, []);
  end;

var
  oList: TADDatSTableRowList;
  pCurBuff: PByte;
begin
  if not (RowState in [rsInserted, rsModified, rsUnchanged]) then
    ErrorCantEdit;
  oList := RowList;
  if oList <> nil then begin
    FpProposed := AllocBuffer;
    pCurBuff := GetBuffer(rvCurrent);
    if pCurBuff <> nil then
      CopyBuffer(FpProposed, pCurBuff);
    FRowPriorState := RowState;
    FRowState := rsEditing;
    Notify(snRowStateChanged, srDataChange, Integer(Self), 0);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.CancelEdit;
begin
  if RowState = rsEditing then begin
    CancelNestedRows;
    FreeBuffer(FpProposed);
    FRowState := RowPriorState;
    Notify(snRowStateChanged, srDataChange, Integer(Self), 0);
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.SkipConstraintCheck: Boolean;
begin
  Result := (Owner = nil) or not (Table.DataHandleMode in [lmNone, lmRefreshing]) or
    (RowState = rsChecking);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.CascadeAcceptReject(AAccept: Boolean);
var
  oTab, oPKTab: TADDatSTable;
  oManager: TADDatSManager;
  oCons: TADDatSConstraintBase;
  i, j: Integer;
  eProposedState: TADDatSRowState;
begin
  if SkipConstraintCheck then
    Exit;
  oTab := Table;
  oManager := Manager;
  if AAccept then
    eProposedState := rsUnchanged
  else
    eProposedState := rsDestroying;
  if (oManager <> nil) and oManager.EnforceConstraints then
    for i := 0 to oManager.Tables.Count - 1 do begin
      oPKTab := oManager.Tables.ItemsI[i];
      if oPKTab.EnforceConstraints then
        for j := 0 to oPKTab.Constraints.Count - 1 do begin
          oCons := oPKTab.Constraints.ItemsI[j];
          if (oCons is TADDatSForeignKeyConstraint) and
             (TADDatSForeignKeyConstraint(oCons).RelatedTable = oTab) then
            oCons.Check(Self, eProposedState, ctAtEditEnd);
        end;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.CheckRowConstraints(AProposedState: TADDatSRowState);
var
  oTab, oPKTab: TADDatSTable;
  oManager: TADDatSManager;
  oCons: TADDatSConstraintBase;
  oCol: TADDatSColumn;
  i, j: Integer;
  pBuff: PByte;
  eTempState, eTempPriorState: TADDatSRowState;

  procedure ErrorNotNull;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_RowColMBNotNull, [oCol.Name]);
  end;

begin
  if SkipConstraintCheck then
    Exit;
  eTempState := RowState;
  eTempPriorState := RowPriorState;
  FRowPriorState := FRowState;
  FRowState := rsChecking;
  try
    ConstrainChildRow(AProposedState);
    ConstrainParentRow(AProposedState);
    oTab := Table;
    oManager := Manager;
    if oTab.EnforceConstraints and ((oManager = nil) or oManager.EnforceConstraints) then begin
      if AProposedState in [rsInserted, rsModified] then begin
        pBuff := GetBuffer(rvDefault);
        for i := 0 to oTab.Columns.Count - 1 do begin
          oCol := oTab.Columns.ItemsI[i];
          if not oCol.AllowDBNull and GetIsNull(pBuff, i) then
            ErrorNotNull;
        end;
      end;
      oTab.Constraints.Check(Self, AProposedState, ctAtEditEnd);
    end;
    if (oManager <> nil) and oManager.EnforceConstraints then
      for i := 0 to oManager.Tables.Count - 1 do begin
        oPKTab := oManager.Tables.ItemsI[i];
        if oPKTab.EnforceConstraints then
          for j := 0 to oPKTab.Constraints.Count - 1 do begin
            oCons := oPKTab.Constraints.ItemsI[j];
            if (oCons is TADDatSForeignKeyConstraint) and
               (TADDatSForeignKeyConstraint(oCons).RelatedTable = oTab) then
              oCons.Check(Self, AProposedState, ctAtEditEnd);
          end;
      end;
  finally
    FRowState := eTempState;
    FRowPriorState := eTempPriorState;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.CheckColumnConstraints;
var
  oTab: TADDatSTable;
  oManager: TADDatSManager;
  eTempState, eTempPriorState: TADDatSRowState;
begin
  if SkipConstraintCheck then
    Exit;
  eTempState := RowState;
  eTempPriorState := RowPriorState;
  FRowPriorState := FRowState;
  FRowState := rsChecking;
  try
    oTab := Table;
    oManager := Manager;
    if oTab.EnforceConstraints and ((oManager = nil) or oManager.EnforceConstraints) then
      oTab.Constraints.Check(Self, rsEditing, ctAtColumnChange);
  finally
    FRowState := eTempState;
    FRowPriorState := eTempPriorState;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.InternalInitComplexData(ABuffer: PByte);
var
  oCols: TADDatSColumnList;
  i: Integer;
begin
  if ABuffer <> nil then begin
    oCols := Table.Columns;
    if ctComp in oCols.FHasThings then
      for i := 0 to oCols.Count - 1 do begin
        with oCols.ItemsI[i] do
          if caBlobData in Attributes then
            SetBlobData(ABuffer, i, nil, 0)
          else if DataType = dtObject then
            PDEDataStoredObject(PChar(ABuffer) + oCols.DataOffsets[i])^ := nil;
      end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.CleanupBuffer(ABuffer: PByte);
begin
  if ABuffer <> nil then begin
    InternalInitComplexData(ABuffer);
    ADFillChar(ABuffer^, Table.Columns.StorageSize, #0);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.Clear(ASetColsToDefaults: Boolean);
var
  lWasDetached: Boolean;
begin
  lWasDetached := (RowState in [rsDetached, rsInitializing]) or
    (RowState = rsForceWrite) and (RowPriorState = rsDetached);
  LockNotification;
  try
    if RowState = rsEditing then
      CancelEdit;
    UnregisterChange;
    if RowState <> rsForceWrite then
      FRowPriorState := rsDetached;
    if Owner is TADDatSTable then begin
      if RowState <> rsForceWrite then
        FRowState := rsDetached;
      FreeBuffer(FpCurrent);
      if FpProposed <> nil then
        CleanupBuffer(FpProposed)
      else
        FpProposed := AllocBuffer;
    end
    else begin
      if RowState <> rsForceWrite then
        FRowState := rsInserted;
      FreeBuffer(FpProposed);
      if FpCurrent <> nil then
        CleanupBuffer(FpCurrent)
      else
        FpCurrent := AllocBuffer;
    end;
    FreeBuffer(FpOriginal);
    ClearNestedRows;
    ClearErrors;
    SetFetchedMarks(True);
    if ASetColsToDefaults then
      AssignDefaults;
  finally
    UnlockNotification;
    if not lWasDetached then
      Notify(snRowStateChanged, srDataChange, Integer(Self), 0);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.ClearErrors;
begin
  ClearNestedErrors;
  if SetRowError(nil) then
    Notify(snRowErrorStateChanged, srDataChange, Integer(Self), 0);
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.CompareColumnVersions(AColumn: Integer;
  AVersion1, AVersion2: TADDatSRowVersion): Boolean;
var
  pBuff1, pBuff2: Pointer;
  iLen1, iLen2: LongWord;
  lIsNull1, lIsNull2: Boolean;
begin
  iLen1 := 0;
  iLen2 := 0;
  pBuff1 := nil;
  pBuff2 := nil;
  lIsNull1 := not GetData(AColumn, AVersion1, pBuff1, 0, iLen1, False);
  lIsNull2 := not GetData(AColumn, AVersion2, pBuff2, 0, iLen2, False);
  if lIsNull1 and lIsNull2 then
    Result := True
  else if not lIsNull1 and not lIsNull2 then
    Result := (CompareData(AColumn, pBuff1, iLen1, pBuff2, iLen2, []) = 0)
  else
    Result := False;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.CompareColumnsVersions(AColumns: TADDatSColumnSublist;
  AVersion1, AVersion2: TADDatSRowVersion): Boolean;
var
  i: Integer;
begin
  Result := True;
  for i := 0 to AColumns.Count - 1 do
    if not CompareColumnVersions(AColumns.ItemsI[i].Index, AVersion1, AVersion2) then begin
      Result := False;
      Break;
    end;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.CompareData(AColumn: Integer; ABuff1: Pointer;
    ADataLen1: Integer; ABuff2: Pointer; ADataLen2: Integer; AOptions:
    TADCompareDataOptions): Integer;

  procedure ErrorColIsNotSearch;
  begin
    with Table.Columns.ItemsI[AColumn] do
      ADException(Self, [S_AD_LDatS], er_AD_ColIsNotSearchable, [Name]);
  end;

{$IFNDEF AnyDAC_D6}
  function GetBCDDiff(ABuff1, ABuff2: Pointer): Extended;
  var
    buff: array[0 .. 100] of Char;
    iSz: Integer;
    s1, s2: String;
  begin
    iSz := 0;
    ADBCD2Str(buff, iSz, PADBcd(ABuff1)^, DecimalSeparator);
    SetString(s1, buff, iSz);
    ADBCD2Str(buff, iSz, PADBcd(ABuff2)^, DecimalSeparator);
    SetString(s2, buff, iSz);
    Result := StrToFloat(s1) - StrToFloat(s2);
  end;
{$ENDIF}  

var
  iLen: Integer;
  iFlag: Integer;
  iDiff: Integer;
  i: Integer;
  D: Double;
  P: Double;
{$IFNDEF AnyDAC_D6}
  crVal1, crVal2: Currency;
  E: Extended;
{$ENDIF}
begin
  ASSERT((Self <> nil) and (ABuff1 <> nil) and (ABuff2 <> nil));
  with Table.Columns.ItemsI[AColumn] do begin
    case DataType of
    dtBoolean:
      Result := Integer(PWordBool(ABuff1)^) - Integer(PWordBool(ABuff2)^);
    dtSByte:
      if PShortInt(ABuff1)^ > PShortInt(ABuff2)^ then
        Result := 1
      else if PShortInt(ABuff1)^ < PShortInt(ABuff2)^ then
        Result := -1
      else
        Result := 0;
    dtInt16:
      if PSmallInt(ABuff1)^ > PSmallInt(ABuff2)^ then
        Result := 1
      else if PSmallInt(ABuff1)^ < PSmallInt(ABuff2)^ then
        Result := -1
      else
        Result := 0;
    dtInt32:
      if PInteger(ABuff1)^ > PInteger(ABuff2)^ then
        Result := 1
      else if PInteger(ABuff1)^ < PInteger(ABuff2)^ then
        Result := -1
      else
        Result := 0;
    dtInt64:
      if PInt64(ABuff1)^ > PInt64(ABuff2)^ then
        Result := 1
      else if PInt64(ABuff1)^ < PInt64(ABuff2)^ then
        Result := -1
      else
        Result := 0;
    dtByte:
      if PByte(ABuff1)^ > PByte(ABuff2)^ then
        Result := 1
      else if PByte(ABuff1)^ < PByte(ABuff2)^ then
        Result := -1
      else
        Result := 0;
    dtUInt16:
      if PWord(ABuff1)^ > PWord(ABuff2)^ then
        Result := 1
      else if PWord(ABuff1)^ < PWord(ABuff2)^ then
        Result := -1
      else
        Result := 0;
    dtUInt32:
      begin
        if PLongWord(ABuff1)^ > PLongWord(ABuff2)^ then
          Result := 1
        else if PLongWord(ABuff1)^ < PLongWord(ABuff2)^ then
          Result := -1
        else
          Result := 0;
      end;
    dtUInt64:
      Result := ADCompareUInt64(PUInt64(ABuff1)^, PUInt64(ABuff2)^);
    dtDouble:
      begin
        D := PDouble(ABuff1)^ - PDouble(ABuff2)^;
        if D > 0.0000000000001 then
          Result := 1
        else if D < -0.0000000000001 then
          Result := -1
        else
          Result := 0;
      end;
    dtCurrency:
      if PCurrency(ABuff1)^ > PCurrency(ABuff2)^ then
        Result := 1
      else if PCurrency(ABuff1)^ < PCurrency(ABuff2)^ then
        Result := -1
      else
        Result := 0;
    dtBCD,
    dtFmtBCD:
{$IFDEF AnyDAC_D6}
      begin
        Result := BcdCompare(PADBcd(ABuff1)^, PADBcd(ABuff2)^);
        if Result > 0 then
          Result := 1
        else if Result < 0 then
          Result := -1;
      end;
{$ELSE}
      begin
        crVal1 := 0.0;
        crVal2 := 0.0;
        if BCDToCurr(PADBcd(ABuff1)^, crVal1) and BCDToCurr(PADBcd(ABuff2)^, crVal2) then
          if crVal1 > crVal2 then
            Result := 1
          else if crVal1 < crVal2 then
            Result := -1
          else
            Result := 0
        else begin
          E := GetBCDDiff(ABuff1, ABuff2);
          if E > 0.0000000000001 then
            Result := 1
          else if E < -0.0000000000001 then
            Result := -1
          else
            Result := 0;
        end;
      end;
{$ENDIF}
    dtDate,
    dtTime:
      if PLongint(ABuff1)^ > PLongint(ABuff2)^ then
        Result := 1
      else if PLongint(ABuff1)^ < PLongint(ABuff2)^ then
        Result := -1
      else
        Result := 0;
    dtDateTime:
      begin
        P := PADDateTimeData(ABuff1)^.DateTime - PADDateTimeData(ABuff2)^.DateTime;
        if P > 0.0000000000001 then
          Result := 1
        else if P < -0.0000000000001 then
          Result := -1
        else
          Result := 0;
      end;
    dtDateTimeStamp:
      if PADSQLTimeStamp(ABuff1)^.Year > PADSQLTimeStamp(ABuff2)^.Year then
        Result := 1
      else if PADSQLTimeStamp(ABuff1)^.Year < PADSQLTimeStamp(ABuff2)^.Year then
        Result := -1
      else if PADSQLTimeStamp(ABuff1)^.Month > PADSQLTimeStamp(ABuff2)^.Month then
        Result := 1
      else if PADSQLTimeStamp(ABuff1)^.Month < PADSQLTimeStamp(ABuff2)^.Month then
        Result := -1
      else if PADSQLTimeStamp(ABuff1)^.Day > PADSQLTimeStamp(ABuff2)^.Day then
        Result := 1
      else if PADSQLTimeStamp(ABuff1)^.Day < PADSQLTimeStamp(ABuff2)^.Day then
        Result := -1
      else if PADSQLTimeStamp(ABuff1)^.Hour > PADSQLTimeStamp(ABuff2)^.Hour then
        Result := 1
      else if PADSQLTimeStamp(ABuff1)^.Hour < PADSQLTimeStamp(ABuff2)^.Hour then
        Result := -1
      else if PADSQLTimeStamp(ABuff1)^.Minute > PADSQLTimeStamp(ABuff2)^.Minute then
        Result := 1
      else if PADSQLTimeStamp(ABuff1)^.Minute < PADSQLTimeStamp(ABuff2)^.Minute then
        Result := -1
      else if PADSQLTimeStamp(ABuff1)^.Second > PADSQLTimeStamp(ABuff2)^.Second then
        Result := 1
      else if PADSQLTimeStamp(ABuff1)^.Second < PADSQLTimeStamp(ABuff2)^.Second then
        Result := -1
      else if PADSQLTimeStamp(ABuff1)^.Fractions > PADSQLTimeStamp(ABuff2)^.Fractions then
        Result := 1
      else if PADSQLTimeStamp(ABuff1)^.Fractions < PADSQLTimeStamp(ABuff2)^.Fractions then
        Result := -1
      else
        Result := 0;
    dtAnsiString, dtMemo, dtHMemo:
      begin
        iLen := ADataLen1;
        if iLen > ADataLen2 then
          iLen := ADataLen2;
{$IFDEF AnyDAC_NOLOCALE_DATA}
        if coNoCase in AOptions then
          Result := StrLIComp(PChar(ABuff1), PChar(ABuff2), iLen)
        else
          Result := StrLComp(PChar(ABuff1), PChar(ABuff2), iLen);
        if Result > 0 then
          Result := 1
        else if Result < 0 then
          Result := -1;
{$ELSE}
        if coNoCase in AOptions then
          iFlag := NORM_IGNORECASE or SORT_STRINGSORT
        else
          iFlag := SORT_STRINGSORT;
        SetLastError(0);
        Result := CompareStringA(Self.Table.Locale, iFlag, PAnsiChar(ABuff1), iLen,
          PAnsiChar(ABuff2), iLen) - 2;
        if GetLastError <> 0 then
  {$IFDEF AnyDAC_D6Base}
          RaiseLastOSError;
  {$ELSE}
          RaiseLastWin32Error;
  {$ENDIF}
{$ENDIF}
        if (Result = 0) and not (coPartial in AOptions) then
          if ADataLen1 > ADataLen2 then
            Result := 1
          else if ADataLen1 < ADataLen2 then
            Result := -1;
      end;
    dtWideString, dtWideMemo, dtWideHMemo:
      begin
        iLen := ADataLen1;
        if iLen > ADataLen2 then
          iLen := ADataLen2;
        if coNoCase in AOptions then
          iFlag := NORM_IGNORECASE or SORT_STRINGSORT
        else
          iFlag := SORT_STRINGSORT;
        SetLastError(0);
        Result := CompareStringW(Self.Table.Locale, iFlag, PWideChar(ABuff1), iLen,
          PWideChar(ABuff2), iLen) - 2;
        if GetLastError <> 0 then
{$IFDEF AnyDAC_D6Base}
            RaiseLastOSError;
{$ELSE}
            RaiseLastWin32Error;
{$ENDIF}
        if (Result = 0) and not (coPartial in AOptions) then
          if ADataLen1 > ADataLen2 then
            Result := 1
          else if ADataLen1 < ADataLen2 then
            Result := -1;
      end;
    dtByteString, dtBlob, dtHBlob, dtHBFile:
      begin
        iLen := ADataLen1;
        if iLen > ADataLen2 then
          iLen := ADataLen2;
        Result := 0;
        for i := 0 to iLen - 1 do begin
          iDiff := ShortInt((PChar(ABuff1) + i)^) - ShortInt((PChar(ABuff2) + i)^);
          if iDiff > 0 then begin
            Result := 1;
            Break;
          end
          else if iDiff < 0 then begin
            Result := -1;
            Break;
          end;
        end;
        if Result = 0 then
          if ADataLen1 > ADataLen2 then
            Result := 1
          else if ADataLen1 < ADataLen2 then
            Result := -1;
      end;
    dtGUID:
      begin
        if PGUID(ABuff1)^.D1 < PGUID(ABuff2)^.D1 then
          Result := -1
        else if PGUID(ABuff1)^.D1 > PGUID(ABuff2)^.D1 then
          Result := 1
        else if PGUID(ABuff1)^.D2 < PGUID(ABuff2)^.D2 then
          Result := -1
        else if PGUID(ABuff1)^.D2 > PGUID(ABuff2)^.D2 then
          Result := 1
        else if PGUID(ABuff1)^.D3 < PGUID(ABuff2)^.D3 then
          Result := -1
        else if PGUID(ABuff1)^.D3 > PGUID(ABuff2)^.D3 then
          Result := 1
        else begin
          Result := 0;
          for i := 0 to 7 do begin
            if PGUID(ABuff1)^.D4[i] < PGUID(ABuff2)^.D4[i] then begin
              Result := -1;
              Break;
            end
            else if PGUID(ABuff1)^.D4[i] > PGUID(ABuff2)^.D4[i] then begin
              Result := 1;
              Break;
            end;
          end;
        end;
      end;
    dtObject:
      Result := PDEDataStoredObject(ABuff1)^.Compare(PDEDataStoredObject(ABuff2)^, AOptions);
    else
      if not (caSearchable in Attributes) then
        ErrorColIsNotSearch;
      Result := 0;
    end;
  end;
  if coDescending in AOptions then
    Result := - Result;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.CompareRows(AColumns, ADescendingColumns,
    ACaseInsensitiveColumns: TADDatSColumnSublist; AColumnCount: Integer;
    ARow2: TADDatSRow; AColumns2: TADDatSColumnSublist;
    AVersion: TADDatSRowVersion; AOptions: TADCompareDataOptions;
    var ACache: TADDatSCompareRowsCache): Integer;
  procedure ErrorCantCompareRows;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_CantCompareRows, []);
  end;
var
  pBuff1, pBuff2: Pointer;
  iLen1, iLen2: LongWord;
  lIsNull1, lIsNull2: Boolean;
  i, iCol1, iCol2: Integer;
  iColCount: Integer;
  iOpts: TADCompareDataOptions;
  oCol1, oCol2: TADDatSColumn;
begin
  if (Self = nil) or (ARow2 = nil) or
     (AColumns2 <> nil) and (AColumns = nil) then
    ErrorCantCompareRows;

  Result := 0;
  if AColumnCount = -1 then
    if AColumns = nil then
      iColCount := Table.Columns.Count
    else
      iColCount := AColumns.Count
  else
    iColCount := AColumnCount;
  if AColumns2 <> nil then begin
    if AColumns2.Count < iColCount then
      iColCount := AColumns2.Count;
  end
  else if ARow2.Table.Columns.Count < iColCount then
    iColCount := ARow2.Table.Columns.Count;

  if (coCache in AOptions) and (Length(ACache) = 0) then
    SetLength(ACache, iColCount);

  for i := 0 to iColCount - 1 do begin
    if AColumns = nil then begin
      oCol1 := Table.Columns.ItemsI[i];
      iCol1 := i;
    end
    else begin
      oCol1 := AColumns.ItemsI[i];
      iCol1 := oCol1.Index;
    end;
    if AColumns2 = nil then begin
      oCol2 := ARow2.Table.Columns.ItemsI[iCol1];
      iCol2 := iCol1;
    end
    else begin
      oCol2 := AColumns2.ItemsI[i];
      iCol2 := oCol2.Index;
    end;
    if oCol1.DataType <> oCol2.DataType then
      ErrorCantCompareRows;
    if oCol1.DataType in C_AD_InvariantDataTypes then
      Result := 0
    else begin
      iLen1 := 0;
      pBuff1 := nil;
      iLen2 := 0;
      pBuff2 := nil;
      lIsNull1 := not GetData(iCol1, AVersion, pBuff1, 0, iLen1, False);
      if not (coCache in AOptions) or not ACache[i].FInit then begin
        lIsNull2 := not ARow2.GetData(iCol2, AVersion, pBuff2, 0, iLen2, False);
        iOpts := AOptions;
        if (ADescendingColumns <> nil) and (ADescendingColumns.IndexOf(oCol1) <> -1) then
          Include(iOpts, coDescending);
        if (ACaseInsensitiveColumns <> nil) and (ACaseInsensitiveColumns.IndexOf(oCol1) <> -1) then
          Include(iOpts, coNoCase);
        if (coCache in AOptions) and not ACache[i].FInit then
          with ACache[i] do begin
            FIsNull := lIsNull2;
            FpBuff := pBuff2;
            FLen := iLen2;
            FOpts := iOpts;
            FInit := True;
          end
      end
      else with ACache[i] do begin
        lIsNull2 := FIsNull;
        pBuff2 := FpBuff;
        iLen2 := FLen;
        iOpts := FOpts;
      end;

      if not lIsNull1 and not lIsNull2 then
        Result := CompareData(iCol1, pBuff1, iLen1, pBuff2, iLen2, iOpts)
      else if not lIsNull1 and lIsNull2 then
        if (coNullLess in iOpts) and not (coDescending in iOpts) then
          Result := 1
        else
          Result := -1
      else if lIsNull1 and not lIsNull2 then
        if (coNullLess in iOpts) and not (coDescending in iOpts) then
          Result := -1
        else
          Result := 1
      else // if lIsNull1 and lIsNull2 then
        Result := 0;
    end;
    if Result <> 0 then
      Break;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.CompareRows(ARow2: TADDatSRow;
  AVersion: TADDatSRowVersion; AOptions: TADCompareDataOptions): Integer;
begin
  Result := CompareRows(nil, nil, nil, -1, ARow2, nil, AVersion, AOptions, ADEmptyCC);
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.CompareRowsExp(const AEvaluator: IADStanExpressionEvaluator;
  ARow2: TADDatSRow; AVersion: TADDatSRowVersion; AOptions: TADCompareDataOptions): Integer;
var
  V1, V2: Variant;
  lIsNull1, lIsNull2: Boolean;
begin
  ASSERT((Self <> nil) and (AEvaluator <> nil));
  AEvaluator.DataSource.Position := Self;
  V1 := AEvaluator.Evaluate;
  lIsNull1 := VarIsNull(V1) or VarIsEmpty(V1);
  AEvaluator.DataSource.Position := ARow2;
  V2 := AEvaluator.Evaluate;
  lIsNull2 := VarIsNull(V1) or VarIsEmpty(V1);
  if lIsNull1 and lIsNull2 then
    Result := 0
  else if not lIsNull1 and lIsNull2 then
    if (coNullLess in AOptions) and not (coDescending in AOptions) then
      Result := 1
    else
      Result := -1
  else if lIsNull1 and not lIsNull2 then
    if (coNullLess in AOptions) and not (coDescending in AOptions) then
      Result := -1
    else
      Result := 1
  else begin
    if V1 > V2 then
      Result := 1
    else if V1 < V2 then
      Result := -1
    else
      Result := 0;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.CopyBuffer(ADestination, ASource: PByte);
var
  oCols: TADDatSColumnList;
  oCol: TADDatSColumn;
  i: Integer;
  pSrc: PByte;
  pDest: PByte;
  iLen: Integer;
begin
  if ADestination <> nil then begin
    CleanupBuffer(ADestination);
    if ASource <> nil then begin
      oCols := Table.Columns;
      for i := 0 to oCols.Count - 1 do begin
        if GetIsNull(ASource, i) then
          SetIsNull(ADestination, i, True)
        else begin
          SetIsNull(ADestination, i, False);
          pSrc := PByte(PChar(ASource) + oCols.DataOffsets[i]);
          pDest := PByte(PChar(ADestination) + oCols.DataOffsets[i]);
          oCol := oCols.ItemsI[i];
          if caBlobData in oCol.Attributes then begin
            iLen := 0;
            GetBlobData(ASource, i, pSrc, iLen);
            SetBlobData(ADestination, i, pSrc, iLen);
          end
          else
            case oCol.DataType of
            dtBoolean:      PWordBool(pDest)^ := PWordBool(pSrc)^;
            dtSByte:        PShortInt(pDest)^ := PShortInt(pSrc)^;
            dtInt16:        PSmallInt(pDest)^ := PSmallInt(pSrc)^;
            dtInt32:        PInteger(pDest)^ := PInteger(pSrc)^;
            dtInt64:        PInt64(pDest)^ := PInt64(pSrc)^;
            dtByte:         PByte(pDest)^ := PByte(pSrc)^;
            dtUInt16:       PWord(pDest)^ := PWord(pSrc)^;
            dtUInt32:       PLongWord(pDest)^ := PLongWord(pSrc)^;
            dtUInt64:       PUInt64(pDest)^ := PUInt64(pSrc)^;
            dtDouble:       PDouble(pDest)^ := PDouble(pSrc)^;
            dtCurrency:     PCurrency(pDest)^ := PCurrency(pSrc)^;
            dtBCD,
            dtFmtBCD:       PADBcd(pDest)^ := PADBcd(pSrc)^;
            dtDateTime:     PADDateTimeData(pDest)^ := PADDateTimeData(pSrc)^;
            dtDateTimeStamp:PADSQLTimeStamp(pDest)^ := PADSQLTimeStamp(pSrc)^;
            dtTime:         PLongint(pDest)^ := PLongint(pSrc)^;
            dtDate:         PLongint(pDest)^ := PLongint(pSrc)^;
            dtAnsiString:   ADMove(pSrc^, pDest^, PWord(pSrc)^ * SizeOf(AnsiChar) + SizeOf(Word) + SizeOf(AnsiChar));
            dtByteString:   ADMove(pSrc^, pDest^, PWord(pSrc)^ * SizeOf(Byte) + SizeOf(Word));
            dtWideString:   ADMove(pSrc^, pDest^, PWord(pSrc)^ * SizeOf(WideChar) + SizeOf(Word) + SizeOf(WideChar));
            dtGUID:         PGUID(pDest)^ := PGUID(pSrc)^;
            dtObject:       PDEDataStoredObject(pDest)^ := PDEDataStoredObject(pSrc)^;
            end;
        end;
      end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetChildRows(const AChildRelationName: String): TADDatSView;
  procedure ErrorCantGetChildRows;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_CantCreateChildView, [AChildRelationName]);
  end;
var
  oManager: TADDatSManager;
begin
  oManager := Manager;
  if oManager = nil then
    ErrorCantGetChildRows;
  Result := GetChildRows(Manager.Relations.RelationByName(AChildRelationName));
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetChildRows(AChildTable: TADDatSTable): TADDatSView;
  procedure ErrorCantGetChildRows;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_CantCreateChildView, [S_AD_NotFound]);
  end;
var
  oRel: TADDatSRelation;
begin
  ASSERT(AChildTable <> nil);
  if (Manager = nil) or (AChildTable.Manager <> Manager) then
    ErrorCantGetChildRows;
  oRel := Manager.Relations.FindRelation(Table, AChildTable, False);
  if (oRel = nil) or (not oRel.Nested and (oRel.ChildKeyConstraint = nil)) then
    ErrorCantGetChildRows;
  Result := GetChildRows(oRel);
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetChildRows(AChildRelation: TADDatSRelation): TADDatSView;
  procedure ErrorCantGetChildRows;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_CantCreateChildView, [AChildRelation.Name]);
  end;
var
  oChildTab: TADDatSTable;
  oSrtView: TADDatSView;
begin
  ASSERT(AChildRelation <> nil);
  if (AChildRelation.ChildKeyConstraint = nil) or
     (AChildRelation.ParentTable <> Table) or
     not AChildRelation.IsDefined then
    ErrorCantGetChildRows;
  oChildTab := AChildRelation.ChildTable;
  Result := TADDatSView.Create(oChildTab, C_AD_SysNamePrefix + 'CHLD',
    vcChildRelation, False);
  try
    if AChildRelation.Nested then
      Result.Mechanisms.AddEx(TADDatSMechChilds.Create(Self))
    else begin
      oSrtView := oChildTab.Views.FindSortedView(AChildRelation.ChildColumnNames, [], []);
      if oSrtView <> nil then
        Result.SourceView := oSrtView
      else
        Result.SourceView := AChildRelation.ChildKeyConstraint.GetChildSortedView;
      Result.Mechanisms.AddEx(TADDatSMechDetails.Create(AChildRelation, Self));
    end;
    Result.Active := True;
  except
    Result.Free;
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetParentRows(const AParentRelationName: String): TADDatSView;
  procedure ErrorCantGetParentRows;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_CantCreateParentView, [AParentRelationName]);
  end;
var
  oManager: TADDatSManager;
begin
  oManager := Manager;
  if oManager = nil then
    ErrorCantGetParentRows;
  Result := GetParentRows(Manager.Relations.RelationByName(AParentRelationName));
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetParentRows(AParentTable: TADDatSTable): TADDatSView;
  procedure ErrorCantGetParentRows;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_CantCreateParentView, [S_AD_NotFound]);
  end;
var
  oRel: TADDatSRelation;
begin
  ASSERT(AParentTable <> nil);
  if (Manager = nil) or (AParentTable.Manager <> Manager) then
    ErrorCantGetParentRows;
  oRel := Manager.Relations.FindRelation(AParentTable, Table, False);
  if (oRel = nil) or (not oRel.Nested and (oRel.ParentKeyConstraint = nil)) then
    ErrorCantGetParentRows;
  Result := GetParentRows(oRel);
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetParentRows(AParentRelation: TADDatSRelation): TADDatSView;
  procedure ErrorCantGetParentRows;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_CantCreateParentView, [AParentRelation.Name]);
  end;
var
  oParentTab: TADDatSTable;
  oSrtView: TADDatSView;
begin
  ASSERT(AParentRelation <> nil);
  if (AParentRelation.ParentKeyConstraint = nil) or
     (AParentRelation.ChildTable <> Table) or
     not AParentRelation.IsDefined then
    ErrorCantGetParentRows;
  oParentTab := AParentRelation.ParentTable;
  Result := TADDatSView.Create(oParentTab, C_AD_SysNamePrefix + 'PRNT',
    vcChildRelation, False);
  try
    if AParentRelation.Nested then
      Result.Mechanisms.AddEx(TADDatSMechParent.Create(Self))
    else begin
      oSrtView := oParentTab.Views.FindSortedView(AParentRelation.ParentColumnNames, [], []);
      if oSrtView <> nil then
        Result.SourceView := oSrtView
      else
        Result.SourceView := AParentRelation.ParentKeyConstraint.GetUniqueSortedView;
      Result.Mechanisms.AddEx(TADDatSMechMaster.Create(AParentRelation, Self));
    end;
    Result.Active := True;
  except
    Result.Free;
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.InternalCalculateColumns(ADefaults: Boolean; ACols: TADDatSColumnList);
var
  i: Integer;
  eTmpPriorRowState: TADDatSRowState;
begin
  eTmpPriorRowState := FRowPriorState;
  FRowPriorState := RowState;
  FRowState := rsCalculating;
  try
    for i := 0 to ACols.Count - 1 do
      with ACols.ItemsI[i] do
        if ((caCalculated in Attributes) or ADefaults) and (FEvaluator <> nil) then begin
          FEvaluator.DataSource.Position := Self;
          try
            FEvaluator.Evaluate;
          finally
            FEvaluator.DataSource.Position := nil;
          end;
        end;
    if not ADefaults then
      if Assigned(ACols.OnCalcColumns) then
        ACols.OnCalcColumns(Self);
  finally
    FRowState := RowPriorState;
    FRowPriorState := eTmpPriorRowState;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.CalculateColumns(ADefaults: Boolean);
var
  oCols: TADDatSColumnList;
begin
  oCols := Table.Columns;
  if not ADefaults and not (ctCalcs in oCols.FHasThings) or
     ADefaults and not (ctExps in oCols.FHasThings) then
    Exit;
  InternalCalculateColumns(ADefaults, oCols);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.Delete(ANotDestroy: Boolean = False);
  procedure ErrorRowCantBeDeleted;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_RowCantBeDeleted, []);
  end;
var
  oList: TADDatSTableRowList;
begin
  if RowState in [rsDeleted, rsInitializing, rsDetached, rsCalculating,
                  rsChecking, rsForceWrite] then
    ErrorRowCantBeDeleted
  else if RowState = rsInserted then begin
    UnregisterChange;
    oList := RowList;
    if oList <> nil then
      oList.Remove(Self, ANotDestroy);
  end
  else begin
    CheckRowConstraints(rsDeleted);
    LockNotification;
    try
      CancelEdit;
      FRowState := rsDeleted;
    finally
      UnlockNotification;
    end;
    Notify(snRowStateChanged, srDataChange, Integer(Self), 0);
    RegisterChange;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.DoListInserting;
  procedure ErrorRowCantBeInserted;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_RowCantBeInserted, []);
  end;
begin
  if not (RowState in [rsInitializing, rsDetached, rsInserted, 
                       rsImportingCurent, rsImportingOriginal, rsImportingProposed]) then
    ErrorRowCantBeInserted;
  CheckRowConstraints(rsInserted);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.DoListInserted;
begin
  FTable := GetTable;
  if FRowID = $FFFFFFFF then begin
    FRowID := FTable.Rows.FLastRowID;
    ASSERT(FTable.Rows.FLastRowID <> $FFFFFFFF);
    Inc(FTable.Rows.FLastRowID);
  end;
  if FTable.DataHandleMode in [lmHavyFetching, lmFetching, lmRefreshing] then begin
    FRowState := rsUnchanged;
    FpOriginal := FpProposed;
    FpProposed := nil;
  end
  else if not (RowState in [rsImportingCurent, rsImportingOriginal, rsImportingProposed]) then begin
    FRowState := rsInserted;
    FpCurrent := FpProposed;
    FpProposed := nil;
    RegisterChange;
  end
  else
    RegisterChange;
  CalculateColumns(False);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.DoListRemoving;
  procedure ErrorRowCantBeDeleted;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_RowCantBeDeleted, []);
  end;
begin
  if RowState = rsDestroying then
    Exit;
  if RowState = rsEditing then
    CancelEdit;
  if (Table.DataHandleMode <> lmDestroying) and
     not (RowState in [rsInserted, rsDeleted]) then
    ErrorRowCantBeDeleted;
  CheckRowConstraints(rsDetached);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.DoListRemoved(ANewOwner: TADDatSObject);
begin
  if RowState <> rsDestroying then begin
    ASSERT(FpProposed = nil);
    FRowState := rsDetached;
    FpProposed := FpCurrent;
    FpCurrent := nil;
  end;
  FOwner := ANewOwner;
  FTable := GetTable;
  UnregisterChange;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.EndEdit;
var
  pOrig: PByte;
begin
  if RowState = rsEditing then begin
    if (RowPriorState = rsInserted) or (RowPriorState = rsModified) then begin
      CheckRowConstraints(rsModified);
      pOrig := FpOriginal;
      FpOriginal := FpCurrent;
      try
        FpCurrent := FpProposed;
        FpProposed := nil;
        FRowState := RowPriorState;
        if FRowState = rsInserted then
          FRowPriorState := rsDetached
        else if FRowState = rsModified then
          FRowPriorState := rsUnchanged;
        Notify(snRowStateChanged, srDataChange, Integer(Self), 0);
      finally
        FreeBuffer(FpOriginal);
        FpOriginal := pOrig;
      end;
      RegisterChange;
    end
    else if RowPriorState = rsUnchanged then begin
      CheckRowConstraints(rsModified);
      FpCurrent := FpProposed;
      FpProposed := nil;
      FRowState := rsModified;
      Notify(snRowStateChanged, srDataChange, Integer(Self), 0);
      RegisterChange;
    end;
    CalculateColumns(False);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.RegisterChange;
var
  oManager: TADDatSManager;
begin
  oManager := Manager;
  if (oManager <> nil) and oManager.UpdatesRegistry then begin
    if oManager.Updates <> nil then
      oManager.Updates.RegisterRow(Self);
  end
  else
    if Table.Updates <> nil then
      Table.Updates.RegisterRow(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.UnregisterChange;
var
  oManager: TADDatSManager;
begin
  oManager := Manager;
  if (oManager <> nil) and oManager.UpdatesRegistry then begin
    if oManager.Updates <> nil then
      oManager.Updates.UnregisterRow(Self);
  end
  else
    if Table.Updates <> nil then
      Table.Updates.UnregisterRow(Self);
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetBlobData(ABuffer: PByte; AColumn: Integer; var
  ApData: PByte; var ALen: Integer): Boolean;
var
  oCols: TADDatSColumnList;
  oCol: TADDatSColumn;
  pBlobData: PDEBlobData;

  procedure ErrorColMBBlob;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_ColMBBlob, [oCol.Name]);
  end;

begin
  Result := False;
  if ABuffer <> nil then begin
    oCols := Table.Columns;
    oCol := oCols.ItemsI[AColumn];
    if not (caBlobData in oCol.Attributes) then
      ErrorColMBBlob;
    if GetIsNull(ABuffer, AColumn) then begin
      if @ApData <> nil then
        ApData := nil;
      if @ALen <> nil then
        ALen := 0;
    end
    else begin
      Result := True;
      pBlobData := PDEBlobData(PChar(ABuffer) + oCols.DataOffsets[AColumn]);
      if @ApData <> nil then
        ApData := pBlobData^.FData;
      if @ALen <> nil then
        ALen := pBlobData^.FLength;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetBuffer(AVersion: TADDatSRowVersion): PByte;
var
  iRowState: TADDatSRowState;
begin
  if RowState in [rsInitializing, rsCalculating, rsChecking, rsForceWrite] then
    iRowState := RowPriorState
  else
    iRowState := RowState;
  case iRowState of
  rsImportingCurent:
    Result := FpCurrent;
  rsImportingOriginal:
    Result := FpOriginal;
  rsImportingProposed:
    Result := FpProposed;
  rsDetached:
    case AVersion of
    rvDefault:  Result := FpProposed;
    rvCurrent:  Result := FpProposed;
    rvOriginal: Result := nil;
    rvPrevious: Result := FpProposed;
    rvProposed: Result := FpProposed;
    else        Result := nil;
    end;
  rsInserted:
    case AVersion of
    rvDefault:  Result := FpCurrent;
    rvCurrent:  Result := FpCurrent;
    rvOriginal: Result := nil;
    rvPrevious: if FpOriginal <> nil then
                  Result := FpOriginal
                else
                  Result := FpCurrent;
    rvProposed: Result := nil;
    else        Result := nil;
    end;
  rsDeleted:
    case AVersion of
    rvDefault:  Result := FpOriginal;
    rvCurrent:  Result := nil;
    rvOriginal: Result := FpOriginal;
    rvPrevious: Result := FpCurrent;
    rvProposed: Result := nil;
    else        Result := nil;
    end;
  rsModified:
    case AVersion of
    rvDefault:  Result := FpCurrent;
    rvCurrent:  Result := FpCurrent;
    rvOriginal: Result := FpOriginal;
    rvPrevious: Result := FpOriginal;
    rvProposed: Result := nil;
    else        Result := nil;
    end;
  rsUnchanged:
    case AVersion of
    rvDefault:  Result := FpOriginal;
    rvCurrent:  Result := FpOriginal;
    rvOriginal: Result := FpOriginal;
    rvPrevious: Result := FpOriginal;
    rvProposed: Result := nil;
    else        Result := nil;
    end;
  rsEditing:
    case AVersion of
    rvDefault:  Result := FpProposed;
    rvCurrent:  Result := FpProposed;
    rvOriginal: if (RowPriorState = rsDeleted) or (RowPriorState = rsModified) or
                   (RowPriorState = rsUnchanged) then
                  Result := FpOriginal
                else
                  Result := nil;
    rvPrevious: if FpCurrent <> nil then
                  Result := FpCurrent
                else
                  Result := FpOriginal;
    rvProposed: Result := FpProposed;
    else        Result := nil;
    end;
  else
    Result := nil;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetCheckInfo(ACheckColumn: Integer; var ACheckValue: PByte;
  var ACheckLen: LongWord): Boolean;
var
  pInfo: PDEDataRowExtraInfo;
begin
  pInfo := GetRowInfo(False);
  Result := False;
  if pInfo <> nil then
    with pInfo^ do
      if FCheckColumn = ACheckColumn then begin
        ACheckValue := FCheckValue;
        ACheckLen := FCheckLen;
        Result := True;
      end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.SetCheckInfo(ACheckColumn: Integer; ACheckValue: PByte;
  ACheckLen: Integer);
var
  pInfo: PDEDataRowExtraInfo;
begin
  pInfo := GetRowInfo(ACheckColumn <> -1);
  if pInfo <> nil then begin
    with pInfo^ do begin
      FCheckColumn := ACheckColumn;
      FCheckValue := ACheckValue;
      FCheckLen := ACheckLen;
    end;
    if ACheckColumn = -1 then
      CheckNoInfo;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetDataI(AColumn: Integer;
  AVersion: TADDatSRowVersion): Variant;
begin
  Result := GetData(AColumn, AVersion);
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetDataO(AColumn: TADDatSColumn;
  AVersion: TADDatSRowVersion): Variant;
begin
  Result := GetData(AColumn, AVersion);
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetData(AColumn: TADDatSColumn;
  AVersion: TADDatSRowVersion = rvDefault): Variant;
begin
  Result := GetData(AColumn.Index, AVersion);
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetData(AColumn: Integer;
  AVersion: TADDatSRowVersion = rvDefault): Variant;
var
  pBuff, p: Pointer;
  iLen: LongWord;
  S: AnsiString;
  WS: WideString;
{$IFNDEF AnyDAC_D6}
  crVal: Currency;
{$ENDIF}  
begin
  pBuff := nil;
  iLen := 0;
  if not GetData(AColumn, AVersion, pBuff, 0, iLen, False) then
    Result := Null
  else
    case Table.Columns.ItemsI[AColumn].DataType of
    dtBoolean:
      Result := PWordBool(pBuff)^;
    dtSByte:
      Result := PShortInt(pBuff)^;
    dtInt16:
      Result := PSmallInt(pBuff)^;
    dtInt32:
      Result := PInteger(pBuff)^;
    dtInt64:
{$IFDEF AnyDAC_D6Base}
      Result := PInt64(pBuff)^;
{$ELSE}
      begin
        TVarData(Result).VType := varInt64;
        Decimal(Result).lo64 := PInt64(pBuff)^;
      end;
{$ENDIF}
    dtByte:
      Result := PByte(pBuff)^;
    dtUInt16:
      Result := PWord(pBuff)^;
    dtUInt32:
{$IFDEF AnyDAC_D6Base}
      Result := PLongWord(pBuff)^;
{$ELSE}
      Result := PInteger(pBuff)^;
{$ENDIF}
    dtUInt64:
{$IFDEF AnyDAC_D6Base}
      Result := PUInt64(pBuff)^;
{$ELSE}
      begin
        TVarData(Result).VType := varInt64;
        Decimal(Result).lo64 := PUInt64(pBuff)^;
      end;
{$ENDIF}
    dtDouble:
      Result := PDouble(pBuff)^;
    dtCurrency:
      Result := PCurrency(pBuff)^;
    dtBCD,
    dtFmtBCD:
{$IFDEF AnyDAC_D6}
      Result := VarFMTBcdCreate(PADBcd(pBuff)^);
{$ELSE}
      begin
        crVal := 0.0;
        BCDToCurr(PADBcd(pBuff)^, crVal);
        Result := crVal;
      end;
{$ENDIF}
    dtDateTime:
      Result := TimeStampToDateTime(MSecsToTimeStamp(PADDateTimeData(pBuff)^.DateTime));
    dtDateTimeStamp:
{$IFDEF AnyDAC_D6}
      Result := VarSQLTimeStampCreate(PADSQLTimeStamp(pBuff)^);
{$ELSE}
      Result := ADSQLTimeStampToDateTime(PADSQLTimeStamp(pBuff)^);
{$ENDIF}
    dtTime:
{$IFDEF AnyDAC_D6}
      Result := VarSQLTimeStampCreate(ADTime2SQLTimeStamp(PLongint(pBuff)^));
{$ELSE}
      Result := ADTime2DateTime(PLongint(pBuff)^);
{$ENDIF}
    dtDate:
{$IFDEF AnyDAC_D6}
      Result := VarSQLTimeStampCreate(ADDate2SQLTimeStamp(PLongint(pBuff)^));
{$ELSE}
      Result := ADDate2DateTime(PLongint(pBuff)^);
{$ENDIF}
    dtByteString:
      begin
        Result := VarArrayCreate([0, iLen - 1], varByte);
        p := VarArrayLock(Result);
        try
          ADMove(pBuff^, p^, iLen);
        finally
          VarArrayUnlock(Result);
        end;
      end;
    dtAnsiString, dtMemo, dtHMemo, dtBlob, dtHBlob, dtHBFile:
      begin
        SetString(S, PAnsiChar(pBuff), iLen);
        Result := S;
      end;
    dtWideString, dtWideMemo, dtWideHMemo:
      begin
        SetString(WS, PWideChar(pBuff), iLen);
        Result := WS;
      end;
    dtGUID:
      Result := GUIDToString(PGUID(pBuff)^);
    dtObject:
      Result := PDEDataStoredObject(pBuff)^;
    end;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetData(const AColumnName: String;
  AVersion: TADDatSRowVersion = rvDefault): Variant;
begin
  Result := GetData(Table.Columns.ColumnByName(AColumnName).Index, AVersion);
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetData(AColumn: Integer; AVersion:
  TADDatSRowVersion; var ABuff: Pointer; ABuffLen: LongWord; var ADataLen:
  LongWord; AByVal: Boolean): Boolean;
var
  iLen: LongWord;
  oCols: TADDatSColumnList;
  oCol: TADDatSColumn;
  pSrc: PByte;
  pBuff: PByte;
  lColumnChecking: Boolean;

  procedure ErrorFixedLenDataMismatch;
  begin
    ADataLen := 0;
    ADException(Self, [S_AD_LDatS], er_AD_FixedLenDataMismatch, [oCol.Name]);
  end;

  procedure ProcessVariableDataByVal(AActualLength, AItemLength, AZeros: LongWord; AActualData: PByte);
  begin
    if ABuffLen = 0 then
      iLen := AActualLength
    else begin
      iLen := ABuffLen div AItemLength - AZeros;
      if iLen > AActualLength then
        iLen := AActualLength;
    end;
    ADataLen := iLen;
    if ABuff <> nil then begin
      ADMove(AActualData, ABuff^, iLen * AItemLength);
      if AZeros = 1 then
        (PChar(ABuff) + iLen * AItemLength)^ := #0
      else if AZeros = 2 then begin
        (PChar(ABuff) + iLen * AItemLength)^ := #0;
        (PChar(ABuff) + iLen * AItemLength + 1)^ := #0;
      end;
    end;
  end;

  procedure ProcessVariableDataByRef(AActualLength, AItemLength, AZeros: LongWord; AActualData: PByte);
  begin
    if ABuffLen = 0 then
      iLen := AActualLength
    else begin
      iLen := ABuffLen div AItemLength - AZeros;
      if iLen > AActualLength then
        iLen := AActualLength;
    end;
    ADataLen := iLen;
    ABuff := AActualData;
  end;

  procedure ErrorCantOperateInvObj;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_CantOperateInvObj, [oCol.Name]);
  end;

begin
  ASSERT(Self <> nil);
  oCols := Table.Columns;
  ASSERT(Length(oCols.FDataOffsets) <> 0);
  ASSERT((AColumn >= 0) and (AColumn < oCols.Count));
  oCol := TADDatSColumn(oCols.FArray[AColumn]);
//???  oCol := oCols.ItemsI[AColumn];

  pSrc := nil;
  iLen := 0;
  lColumnChecking := (RowState = rsChecking) and GetCheckInfo(AColumn, pSrc, iLen);
  if lColumnChecking then begin
    if pSrc = nil then begin
      ADataLen := 0;
      if not AByVal then
        ABuff := nil;
      Result := False;
      Exit;
    end;
  end
  else begin
    pBuff := GetBuffer(AVersion);
    if (pBuff = nil) or
       ((PByte(PChar(pBuff) + oCols.NullOffsets[AColumn])^ and oCols.NullMasks[AColumn]) = 0) then begin
//???       GetIsNull(pBuff, AColumn) then begin
      ADataLen := 0;
      if not AByVal then
        ABuff := nil;
      Result := False;
      Exit;
    end;
    pSrc := PByte(PChar(pBuff) + oCols.DataOffsets[AColumn]);
  end;

  Result := True;
  if AByVal then
    if caBlobData in oCol.Attributes then
      if oCol.DataType in [dtWideString, dtWideMemo, dtWideHMemo] then
        ProcessVariableDataByVal(PDEBlobData(pSrc)^.FLength, SizeOf(WideChar), 0,
          PDEBlobData(pSrc)^.FData)
      else
        ProcessVariableDataByVal(PDEBlobData(pSrc)^.FLength, SizeOf(AnsiChar), 0,
          PDEBlobData(pSrc)^.FData)
    else
      case oCol.DataType of
      dtBoolean:
        begin
          ADataLen := SizeOf(WordBool);
          if (ABuffLen <> ADataLen) and (ABuffLen <> 0) then
            ErrorFixedLenDataMismatch
          else if ABuff <> nil then
            PWordBool(ABuff)^ := PWordBool(pSrc)^;
        end;
      dtSByte:
        begin
          ADataLen := SizeOf(ShortInt);
          if (ABuffLen <> ADataLen) and (ABuffLen <> 0) then
            ErrorFixedLenDataMismatch
          else if ABuff <> nil then
            PShortInt(ABuff)^ := PShortInt(pSrc)^;
        end;
      dtInt16:
        begin
          ADataLen := SizeOf(SmallInt);
          if (ABuffLen <> ADataLen) and (ABuffLen <> 0) then
            ErrorFixedLenDataMismatch
          else if ABuff <> nil then
            PSmallInt(ABuff)^ := PSmallInt(pSrc)^;
        end;
      dtInt32:
        begin
          ADataLen := SizeOf(Integer);
          if (ABuffLen <> ADataLen) and (ABuffLen <> 0) then
            ErrorFixedLenDataMismatch
          else if ABuff <> nil then
            PInteger(ABuff)^ := PInteger(pSrc)^;
        end;
      dtInt64:
        begin
          ADataLen := SizeOf(Int64);
          if (ABuffLen <> ADataLen) and (ABuffLen <> 0) then
            ErrorFixedLenDataMismatch
          else if ABuff <> nil then
            PInt64(ABuff)^ := PInt64(pSrc)^;
        end;
      dtByte:
        begin
          ADataLen := SizeOf(Byte);
          if (ABuffLen <> ADataLen) and (ABuffLen <> 0) then
            ErrorFixedLenDataMismatch
          else if ABuff <> nil then
            PByte(ABuff)^ := PByte(pSrc)^;
        end;
      dtUInt16:
        begin
          ADataLen := SizeOf(Word);
          if (ABuffLen <> ADataLen) and (ABuffLen <> 0) then
            ErrorFixedLenDataMismatch
          else if ABuff <> nil then
            PWord(ABuff)^ := PWord(pSrc)^;
        end;
      dtUInt32:
        begin
          ADataLen := SizeOf(LongWord);
          if (ABuffLen <> ADataLen) and (ABuffLen <> 0) then
            ErrorFixedLenDataMismatch
          else if ABuff <> nil then
            PLongWord(ABuff)^ := PLongWord(pSrc)^;
        end;
      dtUInt64:
        begin
          ADataLen := SizeOf(UInt64);
          if (ABuffLen <> ADataLen) and (ABuffLen <> 0) then
            ErrorFixedLenDataMismatch
          else if ABuff <> nil then
            PUInt64(ABuff)^ := PUInt64(pSrc)^;
        end;
      dtDouble:
        begin
          ADataLen := SizeOf(Double);
          if (ABuffLen <> ADataLen) and (ABuffLen <> 0) then
            ErrorFixedLenDataMismatch
          else if ABuff <> nil then
            PDouble(ABuff)^ := PDouble(pSrc)^;
        end;
      dtCurrency:
        begin
          ADataLen := SizeOf(Currency);
          if (ABuffLen <> ADataLen) and (ABuffLen <> 0) then
            ErrorFixedLenDataMismatch
          else if ABuff <> nil then
            PCurrency(ABuff)^ := PCurrency(pSrc)^;
        end;
      dtBCD,
      dtFmtBCD:
        begin
          ADataLen := SizeOf(TADBcd);
          if (ABuffLen <> ADataLen) and (ABuffLen <> 0) then
            ErrorFixedLenDataMismatch
          else if ABuff <> nil then
            PADBcd(ABuff)^ := PADBcd(pSrc)^;
        end;
      dtDateTime:
        begin
          ADataLen := SizeOf(TADDateTimeData);
          if (ABuffLen <> ADataLen) and (ABuffLen <> 0) then
            ErrorFixedLenDataMismatch
          else if ABuff <> nil then
            PADDateTimeData(ABuff)^ := PADDateTimeData(pSrc)^;
        end;
      dtDateTimeStamp:
        begin
          ADataLen := SizeOf(TADSQLTimeStamp);
          if (ABuffLen <> ADataLen) and (ABuffLen <> 0) then
            ErrorFixedLenDataMismatch
          else if ABuff <> nil then
            PADSQLTimeStamp(ABuff)^ := PADSQLTimeStamp(pSrc)^;
        end;
      dtTime,
      dtDate:
        begin
          ADataLen := SizeOf(Longint);
          if (ABuffLen <> ADataLen) and (ABuffLen <> 0) then
            ErrorFixedLenDataMismatch
          else if ABuff <> nil then
            PLongint(ABuff)^ := PLongint(pSrc)^;
        end;
      dtAnsiString:
        if lColumnChecking then
          ProcessVariableDataByVal(iLen, SizeOf(AnsiChar), 1, pSrc)
        else
          ProcessVariableDataByVal(PWord(pSrc)^, SizeOf(AnsiChar), 1, PByte(PChar(pSrc) + SizeOf(Word)));
      dtByteString:
        if lColumnChecking then
          ProcessVariableDataByVal(iLen, SizeOf(Byte), 1, pSrc)
        else
          ProcessVariableDataByVal(PWord(pSrc)^, SizeOf(Byte), 0, PByte(PChar(pSrc) + SizeOf(Word)));
      dtWideString:
        if lColumnChecking then
          ProcessVariableDataByVal(iLen, SizeOf(WideChar), 1, pSrc)
        else
          ProcessVariableDataByVal(PWord(pSrc)^, SizeOf(WideChar), 1, PByte(PChar(pSrc) + SizeOf(Word)));
      dtGUID:
        begin
          ADataLen := SizeOf(TGUID);
          if (ABuffLen <> ADataLen) and (ABuffLen <> 0) then
            ErrorFixedLenDataMismatch
          else if ABuff <> nil then
            PGUID(ABuff)^ := PGUID(pSrc)^;
        end;
      dtObject:
        begin
          ADataLen := SizeOf(IADDataStoredObject);
          if (ABuffLen <> ADataLen) and (ABuffLen <> 0) then
            ErrorFixedLenDataMismatch
          else if ABuff <> nil then
            PDEDataStoredObject(ABuff)^ := PDEDataStoredObject(pSrc)^;
        end;
      dtRowSetRef,
      dtCursorRef,
      dtRowRef,
      dtArrayRef,
      dtParentRowRef:
        ErrorCantOperateInvObj;
      end
  else
    if caBlobData in oCol.Attributes then
      if oCol.DataType in [dtWideString, dtWideMemo, dtWideHMemo] then
        ProcessVariableDataByRef(PDEBlobData(pSrc)^.FLength, SizeOf(WideChar), 0,
          PDEBlobData(pSrc)^.FData)
      else
        ProcessVariableDataByRef(PDEBlobData(pSrc)^.FLength, SizeOf(AnsiChar), 0,
          PDEBlobData(pSrc)^.FData)
    else
      case oCol.DataType of
      dtAnsiString:
        if lColumnChecking then
          ProcessVariableDataByRef(iLen, SizeOf(AnsiChar), 1, pSrc)
        else
          ProcessVariableDataByRef(PWord(pSrc)^, SizeOf(AnsiChar), 1, PByte(PChar(pSrc) + SizeOf(Word)));
      dtByteString:
        if lColumnChecking then
          ProcessVariableDataByRef(iLen, SizeOf(Byte), 1, pSrc)
        else
          ProcessVariableDataByRef(PWord(pSrc)^, SizeOf(Byte), 0, PByte(PChar(pSrc) + SizeOf(Word)));
      dtWideString:
        if lColumnChecking then
          ProcessVariableDataByRef(iLen, SizeOf(WideChar), 1, pSrc)
        else
          ProcessVariableDataByRef(PWord(pSrc)^, SizeOf(WideChar), 1, PByte(PChar(pSrc) + SizeOf(Word)));
      dtRowSetRef,
      dtCursorRef,
      dtRowRef,
      dtArrayRef,
      dtParentRowRef:
        ErrorCantOperateInvObj;
      else
        begin
          ADataLen := oCols.DataOffsets[AColumn + 1] - oCols.DataOffsets[AColumn];
          if (ABuffLen <> ADataLen) and (ABuffLen <> 0) then
            ErrorFixedLenDataMismatch;
          ABuff := pSrc;
        end;
      end;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetHasErrors: Boolean;
begin
  Result := GetRowError <> nil;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetIsNull(ABuffer: PByte; AColumn: Integer): Boolean;
var
  oCols: TADDatSColumnList;
  oObj: TADDatSObject;
begin
  oCols := Table.Columns;
  ASSERT((AColumn >= 0) and (AColumn < oCols.Count));
  case oCols.ItemsI[AColumn].DataType of
  dtRowSetRef,
  dtCursorRef,
  dtRowRef,
  dtParentRowRef:
    Result := GetInvariantObject(AColumn) <> nil;
  dtArrayRef:
    begin
      oObj := GetInvariantObject(AColumn);
      Result := oObj <> nil;
      if Result then
        Result := (oObj as TADDatSNestedRowList).Count <> 0;
    end;
  else
    Result := (PByte(PChar(ABuffer) + oCols.NullOffsets[AColumn])^ and oCols.NullMasks[AColumn]) = 0;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetRowList: TADDatSTableRowList;
begin
  if (Owner <> nil) and (Owner.ClassType = TADDatSTableRowList) then
    Result := TADDatSTableRowList(Owner)
  else
    Result := nil;
  ASSERT((Result = nil) or (Owner <> nil) and (Owner is TADDatSTableRowList));
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetTable: TADDatSTable;
begin
  if FOwner.ClassType = TADDatSTable then
    Result := TADDatSTable(FOwner)
  else
    Result := TADDatSTable(FOwner.FOwner);
  ASSERT((Result <> nil) and (Result is TADDatSTable));
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetManager: TADDatSManager;
begin
  Result := Table.Manager;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.HasVersion(AVersion: TADDatSRowVersion): Boolean;
begin
  Result := (GetBuffer(AVersion) <> nil);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.InitBuffer(ABuffer: PByte);
begin
  if ABuffer <> nil then begin
    ADFillChar(ABuffer^, Table.Columns.StorageSize, #0);
    // We dont need following call, if to follow rule - zeroed
    // memory area is empty data value for any data type.
    // InternalInitComplexData(ABuffer);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.AcceptChanges(AUseCascade: Boolean = True);
  procedure ErrorCantPerform;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_OperCNBPerfInState, []);
  end;
var
  oList: TADDatSTableRowList;
begin
  AcceptNestedChanges;
  if RowState = rsEditing then
    EndEdit;
  if RowState in [rsInitializing, rsCalculating, rsChecking, rsForceWrite] then
    ErrorCantPerform;
  UnregisterChange;
  if AUseCascade then
    CascadeAcceptReject(True);
  case RowState of
  rsInserted:
    begin
      FpOriginal := FpCurrent;
      FpCurrent := nil;
      FRowState := rsUnchanged;
      Notify(snRowStateChanged, srDataChange, Integer(Self), 0);
    end;
  rsDeleted:
    begin
      oList := RowList;
      if oList <> nil then
        oList.Remove(self);
    end;
  rsModified:
    begin
      FreeBuffer(FpOriginal);
      FpOriginal := FpCurrent;
      FpCurrent := nil;
      FRowState := rsUnchanged;
      Notify(snRowStateChanged, srDataChange, Integer(Self), 0);
    end;
  end;
  if DBLockID <> 0 then
    DBUnlock;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.RejectChanges(AUseCascade: Boolean = True);
  procedure ErrorCantPerform;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_OperCNBPerfInState, []);
  end;
var
  oList: TADDatSTableRowList;
begin
  RejectNestedChanges;
  if RowState = rsEditing then
    CancelEdit;
  if RowState in [rsInitializing, rsCalculating, rsChecking, rsForceWrite] then
    ErrorCantPerform;
  UnregisterChange;
  if AUseCascade then
    CascadeAcceptReject(False);
  case RowState of
  rsInserted:
    begin
      oList := RowList;
      if oList <> nil then
        oList.Remove(Self);
    end;
  rsDeleted:
    begin
      FreeBuffer(FpCurrent);
      FRowState := rsUnchanged;
      Notify(snRowStateChanged, srDataChange, Integer(Self), 0);
    end;
  rsModified:
    begin
      FreeBuffer(FpCurrent);
      FRowState := rsUnchanged;
      Notify(snRowStateChanged, srDataChange, Integer(Self), 0);
    end;
  end;
  if DBLockID <> 0 then
    DBUnlock;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.SetBlobData(ABuffer: PByte; AColumn: Integer;
  ApData: PByte; ALength: Integer): PByte;
var
  pBlobData: PDEBlobData;
  oCols: TADDatSColumnList;
  oCol: TADDatSColumn;
  iZeroAddOn, iUnitSize: Integer;
  p: PChar;

  procedure ErrorColMBBlob;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_ColMBBLob, [oCol.Name]);
  end;

begin
  Result := nil;
  if ABuffer <> nil then begin
    oCols := Table.Columns;
    oCol := oCols.ItemsI[AColumn];
    if not (caBlobData in oCol.Attributes) then
      ErrorColMBBlob;
    pBlobData := PDEBlobData(PChar(ABuffer) + oCols.DataOffsets[AColumn]);
    case oCol.DataType of
    dtAnsiString:
      begin
        iUnitSize := SizeOf(AnsiChar);
        iZeroAddOn := iUnitSize;
      end;
    dtWideString:
      begin
        iUnitSize := SizeOf(WideChar);
        iZeroAddOn := SizeOf(WideChar);
      end;
    dtWideMemo, dtWideHMemo:
      begin
        iUnitSize := SizeOf(WideChar);
        iZeroAddOn := 0;
      end;
    dtMemo, dtHMemo:
      begin
        iUnitSize := SizeOf(AnsiChar);
        iZeroAddOn := 0;
      end;
    else // dtBlob, dtHBlob, dtHBFile, dtByteString:
      begin
        iUnitSize := SizeOf(Byte);
        iZeroAddOn := 0;
      end;
    end;
    if pBlobData^.FData <> nil then
      if ALength <> pBlobData^.FLength then begin
        Table.FBlobs.Release(pBlobData^.FData, pBlobData^.FLength * iUnitSize + iZeroAddOn);
        pBlobData^.FData := nil;
        pBlobData^.FLength := 0;
      end;
    if ALength <> 0 then begin
      if ALength <> pBlobData^.FLength then begin
        pBlobData^.FData := Table.FBlobs.Allocate(ALength * iUnitSize + iZeroAddOn);
        pBlobData^.FLength := ALength;
      end;
      Result := pBlobData^.FData;
    end;
    if (ApData <> nil) and (ALength <> 0) then begin
      ADMove(ApData^, pBlobData^.FData^, ALength * iUnitSize);
      if iZeroAddOn > 0 then begin
        p := PChar(pBlobData^.FData) + ALength * iUnitSize;
        if iZeroAddOn = 1 then
          p^ := #0
        else
          while iZeroAddOn > 0 do begin
            p^ := #0;
            Inc(p);
            Dec(iZeroAddOn);
          end;
      end;
    end;
    SetIsNull(ABuffer, AColumn, ALength = 0);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.BeginForceWrite;
begin
  ASSERT(RowState in [rsDetached, rsInitializing]);
  FRowState := rsForceWrite;
  FRowPriorState := rsDetached;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.EndForceWrite;
begin
  ASSERT(RowState = rsForceWrite);
  FRowState := rsDetached;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.CheckWrite(AColumn: Integer): PByte;
  procedure CheckUpdatable;
  var
    oCol: TADDatSColumn;
  begin
    oCol := Table.Columns.ItemsI[AColumn];
    if not (oCol.DataType in C_AD_InvariantDataTypes) and
       not (RowState in [rsCalculating, rsInitializing, rsDetached, rsEditing, rsForceWrite,
                         rsImportingCurent, rsImportingOriginal, rsImportingProposed]) then
      ADException(Self, [S_AD_LDatS], er_AD_RowNotInEditableState, []);
    if oCol.ReadOnly and
       not (RowState in [rsCalculating, rsInitializing, rsForceWrite,
                         rsImportingCurent, rsImportingOriginal, rsImportingProposed]) then
      ADException(Self, [S_AD_LDatS], er_AD_ColIsReadOnly, [oCol.Name]);
  end;
begin
  if Table.DataHandleMode = lmNone then
    CheckUpdatable;
  Result := GetBuffer(rvDefault);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.SetData(AColumn: Integer; ABuff: Pointer; ADataLen: LongWord);
const
  GUID_NULL: TGUID = '{00000000-0000-0000-0000-000000000000}';
var
  oCols: TADDatSColumnList;
  oCol: TADDatSColumn;
  pBuff: PByte;
  pSrc: PByte;
  pCh: PChar;
  lIsNull, lFetching: Boolean;

  procedure ErrorCantOperateInvObj;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_CantOperateInvObj, [oCol.Name]);
  end;

  procedure ErrorFixedLenDataMismatch;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_FixedLenDataMismatch, [oCol.Name, ADataLen, oCol.Size]);
  end;

  procedure ErrorVarLenDataMismatch;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_VarLenDataMismatch, [oCol.Name, ADataLen, oCol.Size]);
  end;

  procedure ValidateValue;
  begin
    if SkipConstraintCheck then
      Exit;
    SetCheckInfo(AColumn, PByte(ABuff), ADataLen);
    try
      CheckColumnConstraints;
    finally
      SetCheckInfo(-1, nil, 0);
    end;
  end;

  procedure ProcessFixedLength(ATypeLen: LongWord);
  begin
    if (ADataLen <> 0) and (ADataLen <> ATypeLen) then
      ErrorFixedLenDataMismatch;
    if not lFetching then
      ValidateValue;
  end;

  procedure ProcessVarLength;
  begin
    if ADataLen > oCol.Size then
      ErrorVarLenDataMismatch;
    if not lFetching then
      ValidateValue;
  end;

begin
  ASSERT(Self <> nil);
  oCols := Table.Columns;
  ASSERT(Length(oCols.FDataOffsets) <> 0);
  oCol := oCols.ItemsI[AColumn];

  pBuff := CheckWrite(AColumn);
  if pBuff = nil then
    Exit;
  pSrc := PByte(PChar(pBuff) + oCols.DataOffsets[AColumn]);
  lIsNull := (ABuff = nil);

  with Table do
    lFetching := DataHandleMode in [lmHavyFetching, lmFetching, lmRefreshing];
  if caBlobData in oCol.Attributes then begin
    if not lFetching then
      ValidateValue;
    SetBlobData(pBuff, AColumn, ABuff, ADataLen);
    if lFetching then
      SetFetched(AColumn, True);
  end
  else begin
    case oCol.DataType of
    dtBoolean:
      begin
        ProcessFixedLength(SizeOf(WordBool));
        if ABuff <> nil then
          PWordBool(pSrc)^ := PWordBool(ABuff)^
        else
          PWordBool(pSrc)^ := False;
      end;
    dtSByte:
      begin
        ProcessFixedLength(SizeOf(ShortInt));
        if ABuff <> nil then
          PShortInt(pSrc)^ := PShortInt(ABuff)^
        else
          PShortInt(pSrc)^ := 0;
      end;
    dtInt16:
      begin
        ProcessFixedLength(SizeOf(SmallInt));
        if ABuff <> nil then
          PSmallInt(pSrc)^ := PSmallInt(ABuff)^
        else
          PSmallInt(pSrc)^ := 0;
      end;
    dtInt32:
      begin
        ProcessFixedLength(SizeOf(Integer));
        if ABuff <> nil then
          PInteger(pSrc)^ := PInteger(ABuff)^
        else
          PInteger(pSrc)^ := 0;
      end;
    dtInt64:
      begin
        ProcessFixedLength(SizeOf(Int64));
        if ABuff <> nil then
          PInt64(pSrc)^ := PInt64(ABuff)^
        else
          PInt64(pSrc)^ := 0;
      end;
    dtByte:
      begin
        ProcessFixedLength(SizeOf(Byte));
        if ABuff <> nil then
          PByte(pSrc)^ := PByte(ABuff)^
        else
          PByte(pSrc)^ := 0;
      end;
    dtUInt16:
      begin
        ProcessFixedLength(SizeOf(Word));
        if ABuff <> nil then
          PWord(pSrc)^ := PWord(ABuff)^
        else
          PWord(pSrc)^ := 0;
      end;
    dtUInt32:
      begin
        ProcessFixedLength(SizeOf(Integer));
        if ABuff <> nil then
          PLongWord(pSrc)^ := PLongWord(ABuff)^
        else
          PLongWord(pSrc)^ := 0;
      end;
    dtUInt64:
      begin
        ProcessFixedLength(SizeOf(UInt64));
        if ABuff <> nil then
          PUInt64(pSrc)^ := PUInt64(ABuff)^
        else
          PUInt64(pSrc)^ := 0;
      end;
    dtDouble:
      begin
        ProcessFixedLength(SizeOf(Double));
        if ABuff <> nil then
          PDouble(pSrc)^ := PDouble(ABuff)^
        else
          PDouble(pSrc)^ := 0.0;
      end;
    dtCurrency:
      begin
        ProcessFixedLength(SizeOf(Currency));
        if ABuff <> nil then
          PCurrency(pSrc)^ := PCurrency(ABuff)^
        else
          PCurrency(pSrc)^ := 0.0;
      end;
    dtBCD,
    dtFmtBCD:
      begin
        ProcessFixedLength(SizeOf(TADBcd));
        if ABuff <> nil then
          PADBcd(pSrc)^ := PADBcd(ABuff)^
        else
{$IFDEF AnyDAC_D6}
          PADBcd(pSrc)^ := NullBcd;
{$ELSE}
          ADFillChar(PADBcd(pSrc)^, SizeOf(TADBcd), #0);
{$ENDIF}
      end;
    dtDateTime:
      begin
        ProcessFixedLength(SizeOf(TADDateTimeData));
        if ABuff <> nil then
          PADDateTimeData(pSrc)^ := PADDateTimeData(ABuff)^
        else
          PADDateTimeData(pSrc)^.DateTime := 0.0;
      end;
    dtDateTimeStamp:
      begin
        ProcessFixedLength(SizeOf(TADSQLTimeStamp));
        if ABuff <> nil then
          PADSQLTimeStamp(pSrc)^ := PADSQLTimeStamp(ABuff)^
        else
{$IFDEF AnyDAC_D6}
          PADSQLTimeStamp(pSrc)^ := NullSQLTimeStamp;
{$ELSE}
          ADFillChar(PADSQLTimeStamp(pSrc)^, SizeOf(TADSQLTimeStamp), #0);
{$ENDIF}
      end;
    dtTime:
      begin
        ProcessFixedLength(SizeOf(Longint));
        if ABuff <> nil then
          PLongint(pSrc)^ := PLongint(ABuff)^
        else
          PLongint(pSrc)^ := 0;
      end;
    dtDate:
      begin
        ProcessFixedLength(SizeOf(Longint));
        if ABuff <> nil then
          PLongint(pSrc)^ := PLongint(ABuff)^
        else
          PLongint(pSrc)^ := 0;
      end;
    dtAnsiString:
      begin
        ProcessVarLength;
        if ABuff <> nil then begin
          PWord(pSrc)^ := Word(ADataLen);
          ADMove(ABuff^, (PChar(pSrc) + SizeOf(Word))^, ADataLen * SizeOf(AnsiChar));
          (PChar(pSrc) + SizeOf(Word) + ADataLen * SizeOf(AnsiChar))^ := #0;
        end
        else begin
          PWord(pSrc)^ := 0;
          (PChar(pSrc) + SizeOf(Word))^ := #0;
        end;
      end;
    dtByteString:
      begin
        ProcessVarLength;
        if ABuff <> nil then begin
          PWord(pSrc)^ := Word(ADataLen);
          ADMove(ABuff^, (PChar(pSrc) + SizeOf(Word))^, ADataLen * SizeOf(Byte));
        end
        else
          PWord(pSrc)^ := 0;
      end;
    dtWideString:
      begin
        ProcessVarLength;
        if ABuff <> nil then begin
          PWord(pSrc)^ := Word(ADataLen);
          ADMove(ABuff^, (PChar(pSrc) + SizeOf(Word))^, ADataLen * SizeOf(WideChar));
          pCh := PChar(pSrc) + SizeOf(Word) + ADataLen * SizeOf(WideChar);
          pCh^ := #0;
          (pCh + 1)^ := #0;
        end
        else begin
          PWord(pSrc)^ := 0;
          pCh := PChar(pSrc) + SizeOf(Word);
          pCh^ := #0;
          (pCh + 1)^ := #0;
        end;
      end;
    dtGUID:
      begin
        ProcessFixedLength(SizeOf(TGUID));
        if ABuff <> nil then
          PGUID(pSrc)^ := PGUID(ABuff)^
        else
          PGUID(pSrc)^ := GUID_NULL;
      end;
    dtObject:
      begin
        ProcessFixedLength(SizeOf(IADDataStoredObject));
        if ABuff <> nil then
          PDEDataStoredObject(pSrc)^ := PDEDataStoredObject(ABuff)^
        else
          PDEDataStoredObject(pSrc)^ := nil;
      end;
    dtRowSetRef,
    dtCursorRef,
    dtRowRef,
    dtArrayRef,
    dtParentRowRef:
      ErrorCantOperateInvObj;
    end;
    SetIsNull(pBuff, AColumn, lIsNull);
    if lFetching then
      SetFetched(AColumn, True);
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.WriteBlobDirect(AColumn: Integer; ABlobLen: Integer): PByte;
var
  pBuff: PByte;
  oCol: TADDatSColumn;

  procedure ErrorColMBBlob;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_ColMBBLob, [oCol.Name]);
  end;

begin
  ASSERT(Self <> nil);
  oCol := Table.Columns.ItemsI[AColumn];
  if not (caBlobData in oCol.Attributes) then
    ErrorColMBBlob;
  pBuff := CheckWrite(AColumn);
  Result := SetBlobData(pBuff, AColumn, nil, ABlobLen);
  with Table do
    if DataHandleMode in [lmHavyFetching, lmFetching, lmRefreshing] then
      SetFetched(AColumn, True);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.SetData(AColumn: TADDatSColumn; const AValue: Variant);
begin
  SetData(AColumn.Index, AValue);
end;

{-------------------------------------------------------------------------------}
{$IFNDEF AnyDAC_D6Base}
type
  EVariantTypeCastError = EVariantError;
{$ENDIF}
  
procedure TADDatSRow.SetData(AColumn: Integer; const AValue: Variant);
var
  iLen: Integer;
  pData: Pointer;
  L: WordBool;
  iSB: ShortInt;
  i16: SmallInt;
  i32: Integer;
  i64: Int64;
  iB: Byte;
  iU16: Word;
  iU32: LongWord;
  iU64: UInt64;
  D: Double;
  C: Currency;
  rBCD: TADBcd;
  T: TADSQLTimeStamp;
  DT: TDateTime;
  MS: TADDateTimeData;
  S: AnsiString;
  WS: WideString;
  lUnlock: Boolean;
  rGUID: TGUID;

  procedure TypeIncompatError(E: EVariantTypeCastError);
  var
    s: String;
  begin
    try
      s := AValue;
    except
      s := '???';
    end;
    ADException(Self, [S_AD_LDatS], er_AD_TypeIncompat,
      [s, Table.Columns.ItemsI[AColumn].Name, E.Message]);
  end;

begin
  iLen := 0;
  pData := nil;
  lUnlock := False;
  try
    try
      if not VarIsNull(AValue) and not VarIsEmpty(AValue) then
        case Table.Columns.ItemsI[AColumn].DataType of
        dtBoolean:
          begin
            L := AValue;
            pData := @L;
          end;
        dtSByte:
          begin
            iSB := AValue;
            pData := @iSB;
          end;
        dtInt16:
          begin
            i16 := AValue;
            pData := @i16;
          end;
        dtInt32:
          begin
            i32 := AValue;
            pData := @i32;
          end;
        dtInt64:
          begin
{$IFDEF AnyDAC_D6Base}
            i64 := AValue;
{$ELSE}
            if TVarData(AValue).VType = varInt64 then
              i64 := Decimal(AValue).lo64
            else begin
              i32 := AValue;
              i64 := i32;
            end;
{$ENDIF}
            pData := @i64;
          end;
        dtByte:
          begin
            iB := AValue;
            pData := @iB;
          end;
        dtUInt16:
          begin
            iU16 := AValue;
            pData := @iU16;
          end;
        dtUInt32:
          begin
            iU32 := AValue;
            pData := @iU32;
          end;
        dtUInt64:
          begin
{$IFDEF AnyDAC_D6Base}
            iU64 := AValue;
{$ELSE}
            if TVarData(AValue).VType = varInt64 then
              iU64 := Decimal(AValue).lo64
            else begin
              iU32 := AValue;
              iU64 := iU32;
            end;
{$ENDIF}
            pData := @iU64;
          end;
        dtDouble:
          begin
            D := AValue;
            pData := @D;
          end;
        dtCurrency:
          begin
            C := AValue;
            pData := @C;
          end;
        dtBCD,
        dtFmtBCD:
          begin
{$IFDEF AnyDAC_D6}
            rBCD := VarToBcd(AValue);
{$ELSE}
            CurrToBCD(AValue, rBCD);
{$ENDIF}
            pData := @rBCD;
          end;
        dtDateTime:
          begin
            DT := VarAsType(AValue, varDate);
            MS.DateTime := TimeStampToMSecs(DateTimeToTimeStamp(DT));
            pData := @MS;
          end;
        dtDateTimeStamp:
          begin
{$IFDEF AnyDAC_D6}
            T := VarToSQLTimeStamp(AValue);
{$ELSE}
            T := ADDateTimeToSQLTimeStamp(AValue);
{$ENDIF}
            pData := @T;
          end;
        dtTime:
          begin
{$IFDEF AnyDAC_D6}
            i32 := ADSQLTimeStamp2Time(VarToSQLTimeStamp(AValue));
{$ELSE}
            i32 := ADDateTime2Time(AValue);
{$ENDIF}
            pData := @i32;
          end;
        dtDate:
          begin
{$IFDEF AnyDAC_D6}
            i32 := ADSQLTimeStamp2Date(VarToSQLTimeStamp(AValue));
{$ELSE}
            i32 := ADDateTime2Date(AValue);
{$ENDIF}
            pData := @i32;
          end;
        dtByteString, dtAnsiString, dtMemo, dtHMemo, dtBlob, dtHBlob, dtHBFile:
          begin
            if VarIsArray(AValue) then begin
              pData := VarArrayLock(AValue);
              lUnlock := True;
              iLen := VarArrayHighBound(AValue, 1) + 1;
            end
            else begin
              S := AValue;
              pData := PChar(S);
              iLen := Length(S);
            end;
          end;
        dtWideString, dtWideMemo, dtWideHMemo:
          begin
            WS := AValue;
            pData := PWideChar(WS);
            iLen := Length(WS);
          end;
        dtRowSetRef,
        dtCursorRef,
        dtRowRef,
        dtArrayRef,
        dtParentRowRef:
          pData := nil;
        dtGUID:
          begin
            S := AValue;
            rGUID := StringToGUID(S);
            pData := @rGUID;
          end;
        dtObject:
          begin
            if VarType(AValue) = varUnknown then
              pData := @(TVarData(AValue).VUnknown)
          end;
        end;
      SetData(AColumn, pData, iLen);
    except
      on E: EVariantTypeCastError do
        TypeIncompatError(E);
    end;
  finally
    if lUnlock then
      VarArrayUnlock(AValue);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.SetValues(const AValues: array of Variant);
var
  i: Integer;
begin
  for i := Low(AValues) to High(AValues) do
    if not VarIsEmpty(AValues[i]) then
      SetData(i, AValues[i]);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.SetIsNull(ABuffer: PByte; AColumn: Integer; AValue:
  Boolean);
var
  oCols: TADDatSColumnList;
  pNullsByte: PByte;
begin
  oCols := Table.Columns;
  ASSERT((AColumn >= 0) and (AColumn < oCols.Count));
  pNullsByte := PByte(PChar(ABuffer) + oCols.NullOffsets[AColumn]);
  if AValue then
    pNullsByte^ := pNullsByte^ and not oCols.NullMasks[AColumn]
  else
    pNullsByte^ := pNullsByte^ or oCols.NullMasks[AColumn];
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetFetched(AColumn: Integer): Boolean;
var
  oCols: TADDatSColumnList;
begin
  oCols := Table.Columns;
  ASSERT((AColumn >= 0) and (AColumn < oCols.Count));
  Result := (PByte(PChar(Self) + oCols.FFetchedOffset + AColumn div 8)^
    and (1 shl (AColumn mod 8))) <> 0;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.SetFetched(AColumn: Integer; AValue: Boolean);
var
  oCols: TADDatSColumnList;
  pFetchedByte: PByte;
begin
  oCols := Table.Columns;
  ASSERT((AColumn >= 0) and (AColumn < oCols.Count));
  pFetchedByte := PByte(PChar(Self) + oCols.FFetchedOffset + AColumn div 8);
  if AValue then
    pFetchedByte^ := pFetchedByte^ or Byte(1 shl (AColumn mod 8))
  else
    pFetchedByte^ := pFetchedByte^ and not Byte(1 shl (AColumn mod 8));
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetRowError: EADException;
var
  pInfo: PDEDataRowExtraInfo;
begin
  pInfo := GetRowInfo(False);
  if pInfo <> nil then
    Result := pInfo^.FRowException
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.SetRowError(const AValue: EADException): Boolean;
var
  pInfo: PDEDataRowExtraInfo;
begin
  Result := False;
  pInfo := GetRowInfo(AValue <> nil);
  if pInfo <> nil then begin
    if pInfo^.FRowException <> nil then begin
      Result := True;
      FreeAndNil(pInfo^.FRowException);
    end;
    if AValue <> nil then
      AValue.Duplicate(pInfo^.FRowException)
    else
      CheckNoInfo;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.SetRowErrorPrc(const AValue: EADException);
begin
  SetRowError(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.DBLock(ALockID: LongWord = $FFFFFFFF);
var
  pInfo: PDEDataRowExtraInfo;
begin
  pInfo := GetRowInfo(True);
  if pInfo^.FLockID <> 0 then
    ADException(Self, [S_AD_LDatS], er_AD_RecLocked, []);
  pInfo^.FLockID := ALockID;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.DBUnlock;
var
  pInfo: PDEDataRowExtraInfo;
begin
  pInfo := GetRowInfo(False);
  if pInfo <> nil then begin
    if pInfo^.FLockID = 0 then
      ADException(Self, [S_AD_LDatS], er_AD_RecNotLocked, []);
    pInfo^.FLockID := 0;
    CheckNoInfo;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetDBLockID: LongWord;
var
  pInfo: PDEDataRowExtraInfo;
begin
  pInfo := GetRowInfo(False);
  if pInfo <> nil then
    Result := pInfo^.FLockID
  else
    Result := 0;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetParentRow: TADDatSRow;
  procedure ErrorRowIsNotNested;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_RowIsNotNested, []);
  end;
var
  oCols: TADDatSColumnList;
begin
  oCols := Table.Columns;
  if oCols.ParentRowRefCol = -1 then
    ErrorRowIsNotNested;
  Result := GetInvariantObject(oCols.ParentRowRefCol) as TADDatSRow;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.SetParentRow(ARow: TADDatSRow);
  procedure ErrorRowIsNotNested;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_RowIsNotNested, []);
  end;
  procedure ErrorCantSetParentRow;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_CantSetParentRow, []);
  end;
var
  oCols: TADDatSColumnList;
  oManager: TADDatSManager;
  oRel: TADDatSRelation;
  oParentCol: TADDatSColumn;
  oParentRow: TADDatSRow;
begin
  oCols := Table.Columns;
  oManager := Table.Manager;
  if (oCols.ParentRowRefCol = -1) or (oManager = nil) then
    ErrorRowIsNotNested;
  if ARow = nil then begin
    oParentRow := TADDatSRow(GetInvariantObject(oCols.ParentRowRefCol));
    if oParentRow = nil then
      Exit;
    oRel := oManager.Relations.FindRelation(oParentRow.Table, Table, True);
  end
  else begin
    oParentRow := TADDatSRow(GetInvariantObject(oCols.ParentRowRefCol));
    if oParentRow = ARow then
      Exit;
    oRel := oManager.Relations.FindRelation(ARow.Table, Table, True);
  end;
  if (oParentRow <> nil) and (ARow <> nil) or
     (oRel = nil) or
     (ARow <> nil) and (oRel.ParentTable <> ARow.Table) then
    ErrorCantSetParentRow;
  oParentCol := oRel.ParentColumns[0];
  CheckWrite(oCols.ParentRowRefCol);
  if ARow = nil then begin
    if RowState <> rsDestroying then
      oParentRow.CheckWrite(oParentCol.Index);
  end
  else
    ARow.CheckWrite(oParentCol.Index);
  SetInvariantObject(oCols.ParentRowRefCol, ARow);
  case oParentCol.DataType of
  dtRowSetRef,
  dtCursorRef:
    if ARow = nil then
      TADDatSNestedRowList(oParentRow.GetInvariantObject(oParentCol.Index)).Remove(Self)
    else
      TADDatSNestedRowList(ARow.GetInvariantObject(oParentCol.Index)).Add(Self);
  dtRowRef,
  dtArrayRef:
    if ARow = nil then
      oParentRow.SetInvariantObject(oParentCol.Index, nil)
    else
      ARow.SetInvariantObject(oParentCol.Index, Self);
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetNestedRow(AColumn: Integer): TADDatSRow;
var
  oCol: TADDatSColumn;

  procedure ErrorColIsNotRef;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_ColumnIsNotRef, [oCol.Name]);
  end;

begin
  oCol := Table.Columns.ItemsI[AColumn];
  if not (oCol.DataType in [dtRowRef, dtArrayRef]) then
    ErrorColIsNotRef;
  Result := GetInvariantObject(AColumn) as TADDatSRow;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.SetNestedRow(AColumn: Integer; ARow: TADDatSRow);
var
  oCol: TADDatSColumn;

  procedure ErrorColIsNotRef;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_ColumnIsNotRef, [oCol.Name]);
  end;

begin
  oCol := Table.Columns.ItemsI[AColumn];
  if not (oCol.DataType in [dtRowRef, dtArrayRef]) then
    ErrorColIsNotRef;
  ARow.SetParentRow(Self);
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetNestedRows(AColumn: Integer): TADDatSNestedRowList;
var
  oCol: TADDatSColumn;

  procedure ErrorColIsNotSetRef;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_ColumnIsNotSetRef, [oCol.Name]);
  end;

begin
  oCol := Table.Columns.ItemsI[AColumn];
  if not (oCol.DataType in [dtRowSetRef, dtCursorRef]) then
    ErrorColIsNotSetRef;
  Result := GetInvariantObject(AColumn) as TADDatSNestedRowList;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.ConstrainChildRow(AProposedState: TADDatSRowState);
  procedure ErrorRowCantInsert;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_RowCantBeInserted, []);
  end;
var
  oParentRow: TADDatSRow;
begin
  if not (Table.DataHandleMode in [lmNone, lmRefreshing]) or
     (Table.Columns.ParentRowRefCol = -1) then
    Exit;
  oParentRow := ParentRow;
  if AProposedState = rsInserted then
    if (oParentRow = nil) or (oParentRow.RowState in [rsInitializing, rsDetached, rsDeleted]) then
      ErrorRowCantInsert;
  if (oParentRow <> nil) and (oParentRow.RowState = rsUnchanged) then
    oParentRow.BeginEdit;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.ProcessNestedRows(AMethod: TADDatSProcessNestedRowsMethod);
var
  oCols: TADDatSColumnList;
  oNestedRows: TADDatSNestedRowList;
  oNestedRow: TADDatSRow;
  i, j: Integer;
begin
  oCols := Table.Columns;
  if ctInvars in oCols.FHasThings then
    for i := 0 to oCols.Count - 1 do
      case oCols.ItemsI[i].DataType of
      dtRowSetRef, dtCursorRef:
        begin
          oNestedRows := NestedRows[i];
          for j := oNestedRows.Count - 1 downto 0 do begin
            oNestedRow := oNestedRows.ItemsI[j];
            if oNestedRow <> nil then
              AMethod(oNestedRow);
          end;
        end;
      dtRowRef, dtArrayRef:
        begin
          oNestedRow := NestedRow[i];
          if oNestedRow <> nil then
            AMethod(oNestedRow);
        end;
      end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.DoNRDelete(ARow: TADDatSRow);
begin
  ARow.Delete;
end;

procedure TADDatSRow.DoNRDetache(ARow: TADDatSRow);
begin
  ARow.Delete(True);
end;

procedure TADDatSRow.DoNREndModify(ARow: TADDatSRow);
begin
  case ARow.RowState of
  rsEditing:  ARow.EndEdit;
  rsInitializing,
  rsDetached: ARow.Table.Rows.Add(ARow);
  end;
end;

procedure TADDatSRow.ConstrainParentRow(AProposedState: TADDatSRowState);
begin
  if not (Table.DataHandleMode in [lmNone, lmRefreshing]) then
    Exit;
  case AProposedState of
  rsInitializing,
  rsDetached:             ProcessNestedRows(DoNRDetache);
  rsDeleted:              ProcessNestedRows(DoNRDelete);
  rsInserted, rsModified: ProcessNestedRows(DoNREndModify);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.DoNRCancel(ARow: TADDatSRow);
begin
  if ARow.RowState = rsEditing then
    ARow.CancelEdit;
end;

procedure TADDatSRow.CancelNestedRows;
begin
  ProcessNestedRows(DoNRCancel);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.DoNRFree(ARow: TADDatSRow);
begin
  ARow.Free;
end;

procedure TADDatSRow.ClearNestedRows;
begin
  ProcessNestedRows(DoNRFree);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.DoNRAcceptChanges(ARow: TADDatSRow);
begin
  ARow.AcceptChanges;
end;

procedure TADDatSRow.AcceptNestedChanges;
begin
  ProcessNestedRows(DoNRAcceptChanges);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.DoNRClearErrors(ARow: TADDatSRow);
begin
  ARow.ClearErrors;
end;

procedure TADDatSRow.ClearNestedErrors;
begin
  ProcessNestedRows(DoNRClearErrors);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.DoNRRejectChanges(ARow: TADDatSRow);
begin
  ARow.RejectChanges;
end;

procedure TADDatSRow.RejectNestedChanges;
begin
  ProcessNestedRows(DoNRRejectChanges);
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.DumpRow(AWithColNames: Boolean; AVersion: TADDatSRowVersion): String;
var
  i: Integer;
  V: Variant;
begin
  if AWithColNames then
    Result := Table.Name + ': '
  else
    Result := '';
  for i := 0 to Table.Columns.Count - 1 do begin
    if i > 0 then
      Result := Result + '; ';
    if AWithColNames then
      Result := Result + Table.Columns[i].Name + ': ';
    V := GetData(i, AVersion);
    if VarIsNull(V) then
      Result := Result + '<null>'
    else if Table.Columns[i].DataType <> dtTime then
      Result := Result + VarToStr(V)
    else
      Result := Result + TimeToStr(VarAsType(V, varDate));
  end;
end;

{-------------------------------------------------------------------------------}
{- TADDatSRowListBase                                                          -}
{-------------------------------------------------------------------------------}
constructor TADDatSRowListBase.Create;
begin
  inherited Create;
  FDefaultReason := srDataChange;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRowListBase.HandleNotification(AParam: PDEDatSNotifyParam);
begin
  // MSGOPT nothing - just exit
  // inherited HandleNotification(AParam);
end;

{-------------------------------------------------------------------------------}
function TADDatSRowListBase.Add(ARow: TADDatSRow): Integer;
begin
  Result := AddObject(ARow);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRowListBase.AddAt(ARow: TADDatSRow; APosition: Integer);
begin
  AddObjectAt(ARow, APosition);
end;

{-------------------------------------------------------------------------------}
function TADDatSRowListBase.GetItemsI(AIndex: Integer): TADDatSRow;
begin
  ASSERT((AIndex >= 0) and (AIndex < FCount));
  Result := TADDatSRow(FArray[AIndex]);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRowListBase.InternalSort1(L, R: Integer;
  ACompareRowsProc: TADCompareRowsProc; AOpts: TADCompareDataOptions);
var
  I, J: Integer;
  P, T: TADDatSRow;
begin
  if R - L > 4 then begin
    I := (R + L) div 2;
    if ACompareRowsProc(TADDatSRow(FArray[L]), TADDatSRow(FArray[I]), -1, AOpts) > 0 then begin
      T := TADDatSRow(FArray[I]);
      FArray[I] := FArray[L];
      FArray[L] := T;
    end;
    if ACompareRowsProc(TADDatSRow(FArray[L]), TADDatSRow(FArray[R]), -1, AOpts) > 0 then begin
      T := TADDatSRow(FArray[R]);
      FArray[R] := FArray[L];
      FArray[L] := T;
    end;
    if ACompareRowsProc(TADDatSRow(FArray[I]), TADDatSRow(FArray[R]), -1, AOpts) > 0 then begin
      T := TADDatSRow(FArray[R]);
      FArray[R] := FArray[I];
      FArray[I] := T;
    end;
    J := R - 1;
    T := TADDatSRow(FArray[J]);
    FArray[J] := FArray[I];
    FArray[I] := T;
    I := L;
    P := TADDatSRow(FArray[J]);
    while True do begin
      Inc(I);
      Dec(J);
      while (I <= R) and (ACompareRowsProc(TADDatSRow(FArray[I]), P, -1, AOpts) < 0) do
        Inc(I);
      while (J >= L) and (ACompareRowsProc(TADDatSRow(FArray[J]), P, -1, AOpts) > 0) do
        Dec(J);
      if J < I then
        Break;
      T := TADDatSRow(FArray[J]);
      FArray[J] := FArray[I];
      FArray[I] := T;
    end;
    if I <= R then begin
      T := TADDatSRow(FArray[R - 1]);
      FArray[R - 1] := FArray[I];
      FArray[I] := T;
    end;
    InternalSort1(L, J, ACompareRowsProc, AOpts);
    InternalSort1(I + 1, R, ACompareRowsProc, AOpts);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRowListBase.InternalSort2(L, H: Integer;
  ACompareRowsProc: TADCompareRowsProc; AOpts: TADCompareDataOptions);
var
  I, J: Integer;
  P: TADDatSRow;
begin
  for I := L + 1 to H do begin
    P := TADDatSRow(FArray[I]);
    J := I;
    while (J > L) and (ACompareRowsProc(TADDatSRow(FArray[J - 1]), P, -1, AOpts) > 0) do begin
      FArray[J] := FArray[J - 1];
      Dec(J);
    end;
    FArray[J] := P;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRowListBase.InternalSort(L, R: Integer;
  ACompareRowsProc: TADCompareRowsProc; AOpts: TADCompareDataOptions);
begin
  InternalSort1(L, R, ACompareRowsProc, AOpts);
  InternalSort2(L, R, ACompareRowsProc, AOpts);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRowListBase.Sort(ACompareRowsProc: TADCompareRowsProc;
  AOpts: TADCompareDataOptions);
begin
  if FCount > 1 then
    InternalSort(0, FCount - 1, ACompareRowsProc, AOpts);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRowListBase.CheckDuplicates(ACompareRowsProc:
    TADCompareRowsProc; AOpts: TADCompareDataOptions);
  procedure ErrorDubRows;
  var
    sName: String;
  begin
    if (Owner <> nil) and (Owner is TADDatSNamedObject) then
      sName := TADDatSNamedObject(Owner).Name
    else
      sName := '';
    ADException(Self, [S_AD_LDatS], er_AD_DuplicateRows, [sName, 1]);
  end;
var
  i: Integer;
begin
  ASSERT(Assigned(ACompareRowsProc));
  for i := 1 to Count - 1 do
    if ACompareRowsProc(ItemsI[i - 1], ItemsI[i], -1, AOpts) = 0 then
      ErrorDubRows;
end;

{-------------------------------------------------------------------------------}
function TADDatSRowListBase.GetValuesList(const AColumnName, ADelimiter, ANullName: String): String;
var
  i: Integer;
  v: Variant;
  s: String;
begin
  Result := '';
  for i := 0 to Count - 1 do begin
    if i > 0 then
      Result := Result + ADelimiter;
    v := ItemsI[i].GetData(AColumnName);
    if VarIsNull(v) then
      s := ANullName
    else
      s := v;
    Result := Result + s;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSRowListBase.DumpCol(ACol: Integer; AWithColNames: Boolean): String;
var
  s: String;
begin
  s := Table.Columns.ItemsI[ACol].Name;
  if AWithColNames then
    Result := s + ': ';
  Result := Result + GetValuesList(s, '; ', '<null>');
end;

{-------------------------------------------------------------------------------}
{ TADDatSRowListWithAggregates                                                  }
{-------------------------------------------------------------------------------}
type
  TADAggVals = array [0 .. 1023] of TADDatSAggregateValue;
  PDEAggVals = ^TADAggVals;

constructor TADDatSRowListWithAggregates.Create;
begin
  inherited Create;
end;

{-------------------------------------------------------------------------------}
destructor TADDatSRowListWithAggregates.Destroy;
begin
  if FAggregateValues <> nil then begin
    DeleteAggregates;
    FreeAndNil(FAggregateValues);
    FreeAndNil(FAggregateSlots);
  end;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRowListWithAggregates.RemoveAggregatesRow(ARowIndex: Integer);
var
  j: Integer;
  pAggs: PDEAggVals;
begin
  ASSERT(FAggregateValues <> nil);
  pAggs := PDEAggVals(FAggregateValues[ARowIndex]);
  if pAggs <> nil then begin
    for j := 0 to FAggregateSlotUsed - 1 do
      if pAggs^[j] <> nil then begin
        pAggs^[j].RemRef;
        pAggs^[j] := nil;
      end;
    FreeMem(pAggs, FAggregateSlotAllocated * SizeOf(TADDatSAggregateValue));
    FAggregateValues[ARowIndex] := nil;
  end;
  FAggregateValues.Delete(ARowIndex);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRowListWithAggregates.AddAggregatesRow(ARowIndex: Integer);
var
  i: Integer;
  pAggs: PDEAggVals;
begin
  ASSERT(FAggregateValues <> nil);
  if ARowIndex = -1 then
    ARowIndex := FAggregateValues.Count;
  GetMem(pAggs, FAggregateSlotAllocated * SizeOf(TADDatSAggregateValue));
  FAggregateValues.Insert(ARowIndex, pAggs);
  for i := 0 to FAggregateSlotAllocated - 1 do
    pAggs^[i] := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRowListWithAggregates.AddObjectAt(AObj: TADDatSObject;
  APosition: Integer);
begin
  inherited AddObjectAt(AObj, APosition);
  if FAggregateSlotAllocated > 0 then
    AddAggregatesRow(APosition);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRowListWithAggregates.RemoveAt(AIndex: Integer;
  ANotDestroy: Boolean);
begin
  inherited RemoveAt(AIndex, ANotDestroy);
  if FAggregateSlotAllocated > 0 then
    RemoveAggregatesRow(AIndex);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRowListWithAggregates.DeleteAggregates;
var
  i: Integer;
begin
  if FAggregateValues <> nil then begin
    for i := FAggregateValues.Count - 1 downto 0 do
      RemoveAggregatesRow(i);
    for i := 0 to FAggregateSlots.Size - 1 do
      FAggregateSlots.Bits[i] := False;
    FAggregateSlotAllocated := 0;
    FAggregateSlotUsed := 0;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRowListWithAggregates.ClearAggregate(var AIndex: Integer);
var
  i: Integer;
  pAggs: PDEAggVals;
begin
  ASSERT(FAggregateValues <> nil);
  for i := 0 to FAggregateValues.Count - 1 do begin
    pAggs := PDEAggVals(FAggregateValues[i]);
    if (pAggs <> nil) and (pAggs^[AIndex] <> nil) then begin
      pAggs^[AIndex].RemRef;
      pAggs^[AIndex] := nil;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRowListWithAggregates.DeleteAggregate(var AIndex: Integer);
begin
  ASSERT(FAggregateValues <> nil);
  try
    ClearAggregate(AIndex);
  finally
    FAggregateSlots.Bits[AIndex] := False;
    if AIndex = FAggregateSlotUsed - 1 then
      Dec(FAggregateSlotUsed);
    AIndex := -1;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSRowListWithAggregates.AllocateAggregate: Integer;
var
  i, j: Integer;
  pAggs: PDEAggVals;

  procedure ErrorTooManyAggs;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_TooManyAggs, []);
  end;

begin
  if FAggregateSlots = nil then begin
    FAggregateSlots := TBits.Create;
    FAggregateSlots.Size := C_AD_MaxAggsPerView;
    FAggregateValues := TList.Create;
  end;
  Result := FAggregateSlots.OpenBit;
  if Result = FAggregateSlots.Size then
    ErrorTooManyAggs;
  FAggregateSlots.Bits[Result] := True;
  while FAggregateValues.Count < Count do
    FAggregateValues.Add(nil);
  if Result >= FAggregateSlotAllocated then begin
    for i := 0 to Count - 1 do begin
      pAggs := PDEAggVals(FAggregateValues[i]);
      ReallocMem(pAggs, (Result + 4) * SizeOf(TADDatSAggregateValue));
      FAggregateValues[i] := pAggs;
      for j := FAggregateSlotAllocated to Result + 4 - 1 do
        pAggs^[j] := nil;
    end;
    FAggregateSlotAllocated := Result + 4;
  end;
  for i := 0 to Count - 1 do
    PDEAggVals(FAggregateValues[i])^[Result] := nil;
  if Result >= FAggregateSlotUsed then
    FAggregateSlotUsed := Result + 1;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRowListWithAggregates.AttachAggregate(ARowIndex,
  AValIndex: Integer; AObj: TADDatSAggregateValue);
begin
  ASSERT(FAggregateValues <> nil);
  AObj.AddRef;
  PDEAggVals(FAggregateValues[ARowIndex])^[AValIndex] := AObj;
end;

{-------------------------------------------------------------------------------}
function TADDatSRowListWithAggregates.FetchAggregate(ARowIndex,
  AValIndex: Integer): TADDatSAggregateValue;
begin
  ASSERT(FAggregateValues <> nil);
  Result := PDEAggVals(FAggregateValues[ARowIndex])^[AValIndex];
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRowListWithAggregates.DetachAggregate(ARowIndex,
  AValIndex: Integer);
var
  oObj: TADDatSAggregateValue;
begin
  ASSERT(FAggregateValues <> nil);
  oObj := FetchAggregate(ARowIndex, AValIndex);
  oObj.RemRef;
  PDEAggVals(FAggregateValues[ARowIndex])^[AValIndex] := nil;
end;

{-------------------------------------------------------------------------------}
{ TADDatSAggregateValue                                                         }
{-------------------------------------------------------------------------------}
constructor TADDatSAggregateValue.Create(ASubAggregateCnt: Integer);
begin
  inherited Create;
  FRefCnt := TADDatSRefCounter.Create(Self);
  FRefCnt.CountRef;
  SetLength(FSubValues, ASubAggregateCnt);
  Clear;
end;

{-------------------------------------------------------------------------------}
constructor TADDatSAggregateValue.CreateCopy(AValue: TADDatSAggregateValue);
var
  i: Integer;
begin
  Create(Length(AValue.FSubValues));
  FValue := AValue.Value;
  for i := 0 to Length(AValue.FSubValues) - 1 do
    FSubValues[i] := AValue.FSubValues[i];
end;

{-------------------------------------------------------------------------------}
destructor TADDatSAggregateValue.Destroy;
begin
  FreeAndNil(FRefCnt);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregateValue.Clear;
var
  i: Integer;
begin
  for i := 0 to Length(FSubValues) - 1 do
    FSubValues[i] := Null;
  FValue := Null;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregateValue.AddRef;
begin
  FRefCnt.AddRef;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregateValue.RemRef;
begin
  FRefCnt.RemRef;
end;

{-------------------------------------------------------------------------------}
function TADDatSAggregateValue.GetRefs: Integer;
begin
  Result := FRefCnt.Refs;
end;

{-------------------------------------------------------------------------------}
{ TADDatSAggregateExpressionDS                                                  }
{-------------------------------------------------------------------------------}
type
  TADDatSAggregateExpressionDS = class(TADDatSTableExpressionDS)
  private
    FView: TADDatSView;
    FAggregate: TADDatSAggregate;
  protected
    function GetVarIndex(const AName: String): Integer; override;
    function GetVarType(AIndex: Integer): TADDataType; override;
    function GetVarScope(AIndex: Integer): TADExpressionScopeKind; override;
    function GetVarData(AIndex: Integer): Variant; override;
    function GetSubAggregateValue(AIndex: Integer): Variant; override;
    function GetRowNum: Integer; override;
  public
    constructor Create(AView: TADDatSView; AAggregate: TADDatSAggregate);
  end;

{-------------------------------------------------------------------------------}
constructor TADDatSAggregateExpressionDS.Create(AView: TADDatSView; AAggregate: TADDatSAggregate);
begin
  inherited Create(AView.Table);
  FView := AView;
  FAggregate := AAggregate;
end;

{-------------------------------------------------------------------------------}
function TADDatSAggregateExpressionDS.GetRowNum: Integer;
begin
  Result := FView.Rows.IndexOf(FRow) + 1;
end;

{-------------------------------------------------------------------------------}
function TADDatSAggregateExpressionDS.GetSubAggregateValue(AIndex: Integer): Variant;
begin
  Result := FAggregate.GetSubAggregateValue(AIndex);
end;

{-------------------------------------------------------------------------------}
function TADDatSAggregateExpressionDS.GetVarIndex(const AName: String): Integer;
begin
  Result := inherited GetVarIndex(AName);
  if Result = -1 then begin
    Result := FView.Aggregates.IndexOfName(AName);
    if Result <> -1 then
      Result := FTable.Columns.Count + Result;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSAggregateExpressionDS.GetVarType(AIndex: Integer): TADDataType;
begin
  if AIndex < FTable.Columns.Count then
    Result := inherited GetVarType(AIndex)
  else
    Result := FView.Aggregates.ItemsI[AIndex - FTable.Columns.Count].DataType;
end;

{-------------------------------------------------------------------------------}
function TADDatSAggregateExpressionDS.GetVarScope(AIndex: Integer): TADExpressionScopeKind;
begin
  if AIndex < FTable.Columns.Count then
    Result := inherited GetVarScope(AIndex)
  else
    Result := ckAgg;
end;

{-------------------------------------------------------------------------------}
function TADDatSAggregateExpressionDS.GetVarData(AIndex: Integer): Variant;
begin
  if AIndex < FTable.Columns.Count then
    Result := inherited GetVarData(AIndex)
  else
    Result := FView.Aggregates.ItemsI[AIndex - FTable.Columns.Count].Value[FView.Rows.IndexOf(FRow)];
end;

{-------------------------------------------------------------------------------}
{ TADDatSAggregate                                                              }
{-------------------------------------------------------------------------------}
constructor TADDatSAggregate.Create;
begin
  inherited Create;
  FValueIndex := -1;
  FRefs := TADDatSRefCounter.Create(Self);
end;

{-------------------------------------------------------------------------------}
constructor TADDatSAggregate.Create(const AName, AExpression: String;
  AGroupingLevel: Integer);
begin
  Create;
  if AName <> '' then
    Name := AName;
  Expression := AExpression;
  GroupingLevel := AGroupingLevel;
  Active := True;
end;

{-------------------------------------------------------------------------------}
destructor TADDatSAggregate.Destroy;
begin
  Unprepare;
  FreeAndNil(FRefs);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.Assign(AObj: TADDatSObject);
begin
  inherited Assign(AObj);
  if AObj is TADDatSAggregate then begin
    Expression := TADDatSAggregate(AObj).Expression;
    GroupingLevel := TADDatSAggregate(AObj).GroupingLevel;
    Active := TADDatSAggregate(AObj).Active;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSAggregate.IsEqualTo(AObj: TADDatSObject): Boolean;
begin
  Result := inherited IsEqualTo(AObj);
  if Result then begin
    ASSERT(AObj <> nil);
    Result := (Expression = TADDatSAggregate(AObj).Expression) and
      (GroupingLevel = TADDatSAggregate(AObj).GroupingLevel) and
      (Active = TADDatSAggregate(AObj).Active);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.CountRef(AInit: Integer = 1);
begin
  FRefs.CountRef(AInit);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.AddRef;
begin
  FRefs.AddRef;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.RemRef;
begin
  FRefs.RemRef;
end;

{-------------------------------------------------------------------------------}
function TADDatSAggregate.GetIsRefCounted: Boolean;
begin
  Result := FRefs.FRefs >= 0;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.CheckActiveChanged;
begin
  if FPrevActualActive <> ActualActive then begin
    Unprepare;
    FPrevActualActive := ActualActive;
    if FPrevActualActive then
      Update;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.SetActive(const AValue: Boolean);
begin
  if FActive <> AValue then begin
    FActive := AValue;
    CheckActiveChanged;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.DoListInserted;
begin
  CheckActiveChanged;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.DoListRemoving;
begin
  Active := False;
end;

{-------------------------------------------------------------------------------}
function TADDatSAggregate.GetActualActive: Boolean;
var
  oView: TADDatSView;
begin
  oView := View;
  Result := Active and (oView <> nil) and oView.ActualActive;
end;

{-------------------------------------------------------------------------------}
function TADDatSAggregate.GetView: TADDatSView;
begin
  Result := TADDatSView(GetOwnerByClass(TADDatSView));
end;

{-------------------------------------------------------------------------------}
function TADDatSAggregate.GetRows: TADDatSRowListWithAggregates;
var
  oView: TADDatSView;
begin
  oView := View;
  if oView <> nil then
    Result := TADDatSViewRowList(oView.Rows)
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
function TADDatSAggregate.GetSortMech: IADDataMechSort;
var
  oView: TADDatSView;
begin
  oView := View;
  if oView <> nil then
    Result := oView.SortingMechanism
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.SetExpression(const AValue: String);
begin
  if FExpression <> AValue then begin
    FExpression := AValue;
    FActive := False;
    CheckActiveChanged;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.SetGroupingLevel(const AValue: Integer);
begin
  ASSERT(AValue >= 0);
  if FGroupingLevel <> AValue then begin
    FGroupingLevel := AValue;
    FActive := False;
    CheckActiveChanged;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.Unprepare;
var
  oRows: TADDatSRowListWithAggregates;
begin
  if agPrepared in FState then
    try
      oRows := Rows;
      if oRows <> nil then
        oRows.DeleteAggregate(FValueIndex);
      SetLength(FSubAggregates, 0);
      FEvaluator := nil;
    finally
      FState := [];
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.Prepare;
  procedure TooMuchGrouping;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_GrpLvlExceeds, [Name]);
  end;
var
  i: Integer;
  oRows: TADDatSRowListWithAggregates;
  oSortMech: IADDataMechSort;
  oParser: IADStanExpressionParser;
begin
  if not (agPrepared in FState) then begin
    FState := [];
    oRows := Rows;
    oSortMech := SortMech;
    if oSortMech <> nil then
      case oSortMech.SortSource of
      ssExpression:
        if 1 < FGroupingLevel then
          TooMuchGrouping;
      ssRowId:
        if 0 < FGroupingLevel then
          TooMuchGrouping;
      ssColumns:
        if oSortMech.SortColumnList.Count < FGroupingLevel then
          TooMuchGrouping;
      end
    else if FGroupingLevel > 0 then
      TooMuchGrouping;
    try
      ADCreateInterface(IADStanExpressionParser, oParser);
      FEvaluator := oParser.Prepare(TADDatSAggregateExpressionDS.Create(View, Self),
        Expression, [], [poAggregate, poDefaultExpr], '');
      SetLength(FSubAggregates, FEvaluator.SubAggregateCount);
      FSubAggregateValues := 0;
      for i := 0 to FEvaluator.SubAggregateCount - 1 do begin
        FSubAggregates[i].FKind := FEvaluator.SubAggregateKind[i];
        FSubAggregates[i].FValueIndex := FSubAggregateValues;
        Inc(FSubAggregateValues);
        case FSubAggregates[i].FKind of
        akAvg:
          begin
            FSubAggregates[i].FCountIndex := FSubAggregateValues;
            Inc(FSubAggregateValues);
          end;
        akMin, akMax:
          begin
            FSubAggregates[i].FCountIndex := -1;
            Include(FState, agMinMax);
          end;
        else
          FSubAggregates[i].FCountIndex := -1;
        end;
      end;
      FValueIndex := oRows.AllocateAggregate;
    except
      FEvaluator := nil;
      SetLength(FSubAggregates, 0);
      if FValueIndex <> -1 then
        oRows.DeleteAggregate(FValueIndex);
      raise;
    end;
    Include(FState, agPrepared);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.Recalc;
begin
  if ActualActive then
    CalcAll
  else
    Exclude(FState, agActual);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.Update;
begin
  if not (agActual in FState) and ActualActive then
    CalcAll;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.IncAggVals(AKind: TADAggregateKind;
  const AVal: Variant; var AAggVal, AAggCnt: Variant);
begin
  case AKind of
  akSum:
    if VarIsNull(AAggVal) then
      AAggVal := AVal
    else if not VarIsNull(AVal) then
      AAggVal := ADFixFMTBcdAdd(AAggVal, AVal);
  akAvg:
    begin
      if VarIsNull(AAggVal) then
        AAggVal := AVal
      else if not VarIsNull(AVal) then
        AAggVal := ADFixFMTBcdAdd(AAggVal, AVal);
      if not VarIsNull(AVal) then
        if VarIsNull(AAggCnt) then
          AAggCnt := 1
        else
          AAggCnt := AAggCnt + 1;
    end;
  akCount:
    if not VarIsNull(AVal) then
      if VarIsNull(AAggVal) then
        AAggVal := 1
      else
        AAggVal := AAggVal + 1;
  akMin:
    if VarIsNull(AAggVal) then
      AAggVal := AVal
    else if not VarIsNull(AVal) and (AAggVal > AVal) then
      AAggVal := AVal;
  akMax:
    if VarIsNull(AAggVal) then
      AAggVal := AVal
    else if not VarIsNull(AVal) and (AAggVal < AVal) then
      AAggVal := AVal;
  akFirst:
    if VarIsNull(AAggVal) then
      if not VarIsNull(AVal) then
        AAggVal := AVal;
  akLast:
    if not VarIsNull(AVal) then
      AAggVal := AVal;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.DecAggVals(AKind: TADAggregateKind;
  const AVal: Variant; var AAggVal, AAggCnt: Variant);
begin
  if VarIsNull(AAggVal) or VarIsNull(AVal) then
    Exit;
  case AKind of
  akSum:
    AAggVal := ADFixFMTBcdSub(AAggVal, AVal);
  akAvg:
    begin
      AAggVal := ADFixFMTBcdSub(AAggVal, AVal);
      AAggCnt := AAggCnt - 1;
      if AAggCnt = 0 then begin
        AAggVal := Null;
        AAggCnt := Null;
      end;
    end;
  akCount:
    begin
      AAggVal := AAggVal - 1;
      if AAggVal = 0 then
        AAggVal := Null;
    end;
  akMin:
    ;
  akMax:
    ;
  akFirst:
    ;
  akLast:
    ;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.SetEvaluatorToRow(ARows: TADDatSRowListWithAggregates;
  ARowIndex: Integer);
begin
  FCurrentRow := ARowIndex;
  FEvaluator.DataSource.Position := ARows.ItemsI[ARowIndex];
end;

{-------------------------------------------------------------------------------}
function TADDatSAggregate.GetSubAggregateValue(ASubAggregateIndex: Integer): Variant;
var
  oVal: TADDatSAggregateValue;
  vCnt, vVal: Variant;
begin
  Result := Null;
  oVal := Rows.FetchAggregate(FCurrentRow, FValueIndex);
  with FSubAggregates[ASubAggregateIndex] do begin
    vVal := oVal.FSubValues[FValueIndex];
    if not VarIsNull(vVal) and not VarIsEmpty(vVal) then
      if FKind = akAvg then begin
        vCnt := oVal.FSubValues[FCountIndex];
        if not VarIsNull(vCnt) then
          Result := ADFixFMTBcdDiv(vVal, vCnt);
      end
      else
        Result := vVal;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.ClearGroup(ARowIndex: Integer; var AGroupFrom, AGroupTo: Integer);
var
  oRows: TADDatSRowListWithAggregates;
  oSortMech: IADDataMechSort;
  i, j: Integer;
  oVal, oLastVal: TADDatSAggregateValue;
begin
  oRows := Rows;
  oSortMech := SortMech;
  if (GroupingLevel > 0) and (oSortMech <> nil) then begin
    AGroupFrom := ARowIndex;
    while (AGroupFrom > 0) and
          (oSortMech.CompareRows(oRows.ItemsI[AGroupFrom], oRows.ItemsI[AGroupFrom - 1], GroupingLevel) = 0) do
      Dec(AGroupFrom);
    AGroupTo := ARowIndex;
    while (AGroupTo < oRows.Count - 1) and
          (oSortMech.CompareRows(oRows.ItemsI[AGroupTo], oRows.ItemsI[AGroupTo + 1], GroupingLevel) = 0) do
      Inc(AGroupTo);
  end
  else begin
    AGroupFrom := 0;
    AGroupTo := oRows.Count - 1;
  end;
  oLastVal := nil;
  for i := AGroupFrom to AGroupTo do begin
    oVal := oRows.FetchAggregate(i, FValueIndex);
    if oVal = nil then begin
      if oLastVal = nil then
        for j := i + 1 to AGroupTo do begin
          oLastVal := oRows.FetchAggregate(j, FValueIndex);
          if oLastVal <> nil then
            Break;
        end;
      if oLastVal = nil then
        oVal := TADDatSAggregateValue.Create(FSubAggregateValues)
      else
        oVal := oLastVal;
      oRows.AttachAggregate(i, FValueIndex, oVal);
    end;
    if oLastVal <> oVal then begin
      ASSERT(oLastVal = nil);
      oVal.Clear;
      oLastVal := oVal;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.CalcGroup(AGroupFrom, AGroupTo, AExclude: Integer);
var
  oRows: TADDatSRowListWithAggregates;
  oVal, oLastVal: TADDatSAggregateValue;
  j, i: Integer;
  V, vTmp: Variant;
begin
  oRows := Rows;
  for j := 0 to Length(FSubAggregates) - 1 do
    for i := AGroupFrom to AGroupTo do
      if i <> AExclude then begin
        oVal := oRows.FetchAggregate(i, FValueIndex);
        SetEvaluatorToRow(oRows, i);
        V := FEvaluator.EvaluateSubAggregateArg(j);
        with FSubAggregates[j] do
          if FKind = akAvg then
            IncAggVals(FKind, V, oVal.FSubValues[FValueIndex], oVal.FSubValues[FCountIndex])
          else begin
            vTmp := Unassigned;
            IncAggVals(FKind, V, oVal.FSubValues[FValueIndex], vTmp);
          end;
      end;
  oLastVal := nil;
  for i := AGroupFrom to AGroupTo do
    if i <> AExclude then begin
      oVal := oRows.FetchAggregate(i, FValueIndex);
      if oLastVal <> oVal then begin
        SetEvaluatorToRow(oRows, i);
        oVal.FValue := FEvaluator.Evaluate;
        oLastVal := oVal;
      end;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.CalcAll;
var
  oRows: TADDatSRowListWithAggregates;
  oVal: TADDatSAggregateValue;
  i, iLevel: Integer;
  oSortMech: IADDataMechSort;
  lBreak: Boolean;
begin
  oRows := Rows;
  if agPrepared in FState then
    oRows.ClearAggregate(FValueIndex)
  else
    Prepare;
  oSortMech := SortMech;
  iLevel := GroupingLevel;
  oVal := nil;
  for i := 0 to oRows.Count - 1 do begin
    if oVal = nil then
      lBreak := True
    else if (iLevel > 0) and (oSortMech <> nil) then
      lBreak := (oSortMech.CompareRows(oRows.ItemsI[i], oRows.ItemsI[i - 1], iLevel) <> 0)
    else
      lBreak := False;
    if lBreak then
      oVal := TADDatSAggregateValue.Create(FSubAggregateValues);
    oRows.AttachAggregate(i, FValueIndex, oVal);
    if lBreak then
      oVal.RemRef;
  end;
  CalcGroup(0, oRows.Count - 1, -1);
  Include(FState, agActual);
end;

{-------------------------------------------------------------------------------}
function TADDatSAggregate.GetDataType: TADDataType;
begin
  if FEvaluator = nil then
    Result := dtUnknown
  else
    Result := FEvaluator.DataType;
end;

{-------------------------------------------------------------------------------}
function TADDatSAggregate.GetValue(ARowIndex: Integer): Variant;
begin
  if agPrepared in FState then
    Result := Rows.FetchAggregate(ARowIndex, FValueIndex).Value
  else
    Result := Unassigned;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.IncRow(ARows: TADDatSRowListWithAggregates;
  ARowIndex: Integer; AVal: TADDatSAggregateValue);
var
  i: Integer;
  V, vTmp: Variant;
begin
  SetEvaluatorToRow(ARows, ARowIndex);
  for i := 0 to Length(FSubAggregates) - 1 do begin
    V := FEvaluator.EvaluateSubAggregateArg(i);
    with FSubAggregates[i] do
      if FKind = akAvg then
        IncAggVals(FKind, V, AVal.FSubValues[FValueIndex], AVal.FSubValues[FCountIndex])
      else begin
        vTmp := Unassigned;
        IncAggVals(FKind, V, AVal.FSubValues[FValueIndex], vTmp);
      end;
  end;
  AVal.FValue := FEvaluator.Evaluate;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.DecRow(ARows: TADDatSRowListWithAggregates;
  ARowIndex: Integer; AVal: TADDatSAggregateValue);
var
  i: Integer;
  V, vTmp: Variant;
begin
  SetEvaluatorToRow(ARows, ARowIndex);
  for i := 0 to Length(FSubAggregates) - 1 do begin
    V := FEvaluator.EvaluateSubAggregateArg(i);
    with FSubAggregates[i] do
      if FKind = akAvg then
        DecAggVals(FKind, V, AVal.FSubValues[FValueIndex], AVal.FSubValues[FCountIndex])
      else begin
        vTmp := Unassigned;
        DecAggVals(FKind, V, AVal.FSubValues[FValueIndex], vTmp);
      end;
  end;
  AVal.FValue := FEvaluator.Evaluate;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.RowInserted(ARowIndex: Integer);
var
  oRows: TADDatSRowListWithAggregates;
  oSortMech: IADDataMechSort;
  i: Integer;
  oVal: TADDatSAggregateValue;
begin
  if ActualActive then begin
    oRows := Rows;
    oSortMech := SortMech;
    if (GroupingLevel > 0) and (oSortMech <> nil) then begin
      if (ARowIndex > 0) and
         (oSortMech.CompareRows(oRows.ItemsI[ARowIndex], oRows.ItemsI[ARowIndex - 1], GroupingLevel) = 0) then
        i := ARowIndex - 1
      else if (ARowIndex < oRows.Count - 1) and
              (oSortMech.CompareRows(oRows.ItemsI[ARowIndex], oRows.ItemsI[ARowIndex + 1], GroupingLevel) = 0) then
        i := ARowIndex + 1
      else
        i := -1;
    end
    else
      if ARowIndex > 0 then
        i := ARowIndex - 1
      else if ARowIndex < oRows.Count - 1 then
        i := ARowIndex + 1
      else
        i := -1;
    if i = -1 then
      oVal := TADDatSAggregateValue.Create(FSubAggregateValues)
    else
      oVal := oRows.FetchAggregate(i, FValueIndex);
    oRows.AttachAggregate(ARowIndex, FValueIndex, oVal);
    if i = -1 then
      oVal.RemRef;
    IncRow(oRows, ARowIndex, oVal);
  end
  else
    Exclude(FState, agActual);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.RowDeleted(ARowIndex: Integer);
var
  oVal: TADDatSAggregateValue;
  oRows: TADDatSRowListWithAggregates;
  iFrom, iTo: Integer;
begin
  if ActualActive then begin
    oRows := Rows;
    oVal := oRows.FetchAggregate(ARowIndex, FValueIndex);
    if oVal.Refs > 1 then
      if agMinMax in FState then begin
        iFrom := -1;
        iTo := -1;
        ClearGroup(ARowIndex, iFrom, iTo);
        CalcGroup(iFrom, iTo, ARowIndex);
      end
      else
        DecRow(oRows, ARowIndex, oVal);
    oRows.DetachAggregate(ARowIndex, FValueIndex);
  end
  else
    Exclude(FState, agActual);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.RowUpdated(ARowIndex, AOldRowIndex: Integer);
var
//  oRows: TADDatSRowListWithAggregates;
  iFrom, iTo: Integer;
//  oVal: TADDatSAggregateValue;
begin
  if ActualActive then begin
{ TODO -cDATSMANAGER :
If after EndEdit we can remember row data before edit, then we
can incrementally update aggregates. Now code is commented out. }
//    if agMinMax in FState then begin
      iFrom := -1;
      iTo := -1;
      ClearGroup(AOldRowIndex, iFrom, iTo);
      CalcGroup(iFrom, iTo, -1);
      if (ARowIndex < iFrom) or (ARowIndex > iTo) then begin
        ClearGroup(ARowIndex, iFrom, iTo);
        CalcGroup(iFrom, iTo, -1);
      end;
//    end
//    else begin
//      oRows := Rows;
//      oVal := oRows.FetchAggregate(AOldRowIndex, FValueIndex);
//      DecRow(oRows, AOldRowIndex, oVal);
//      oVal := oRows.FetchAggregate(ARowIndex, FValueIndex);
//      IncRow(oRows, ARowIndex, oVal);
//    end;
  end
  else
    Exclude(FState, agActual);
end;

{-------------------------------------------------------------------------------}
{ TADDatSAggregateList                                                          }
{-------------------------------------------------------------------------------}
constructor TADDatSAggregateList.CreateForView(AOwner: TADDatSView);
begin
  ASSERT(AOwner <> nil);
  inherited Create;
  OwnObjects := True;
  FOwner := AOwner;
end;

{-------------------------------------------------------------------------------}
function TADDatSAggregateList.Add(AObj: TADDatSAggregate): Integer;
begin
  Result := AddObject(AObj);
end;

{-------------------------------------------------------------------------------}
function TADDatSAggregateList.Add(const AName, AExpression: String;
  AGroupingLevel: Integer): TADDatSAggregate;
begin
  Result := TADDatSAggregate.Create(AName, AExpression, AGroupingLevel);
  AddEx(Result);
end;

{-------------------------------------------------------------------------------}
function TADDatSAggregateList.GetItemsI(AIndex: Integer): TADDatSAggregate;
begin
  ASSERT((AIndex >= 0) and (AIndex < FCount));
  Result := TADDatSAggregate(FArray[AIndex]);
end;

{-------------------------------------------------------------------------------}
function TADDatSAggregateList.AggregateByName(const AName: String): TADDatSAggregate;
begin
  Result := TADDatSAggregate(ItemByName(AName));
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregateList.RowInserted(ARowIndex: Integer);
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    ItemsI[i].RowInserted(ARowIndex);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregateList.RowUpdated(ARowIndex, AOldRowIndex: Integer);
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    ItemsI[i].RowUpdated(ARowIndex, AOldRowIndex);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregateList.RowDeleted(ARowIndex: Integer);
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    ItemsI[i].RowDeleted(ARowIndex);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregateList.Update;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    ItemsI[i].Update;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregateList.Recalc;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    ItemsI[i].Recalc;
end;

{-------------------------------------------------------------------------------}
{- TADDatSTableRowList                                                         -}
{-------------------------------------------------------------------------------}
constructor TADDatSTableRowList.CreateForTable(ATable: TADDatSTable);
begin
  ASSERT(ATable <> nil);
  inherited Create;
  FOwner := ATable;
  OwnObjects := True;
  FRowIDOrdered := True;
end;

{-------------------------------------------------------------------------------}
function TADDatSTableRowList.Add(const AValues: array of Variant): TADDatSRow;
begin
  Result := Table.NewRow(AValues, True);
  Add(Result);
end;

{-------------------------------------------------------------------------------}
function TADDatSTableRowList.IndexOf(AObj: TADDatSObject): Integer;
var
  iFirstNo, iLastNo: Integer;
  iObjRowId: LongWord;
  oRow: TADDatSRow;
begin
  ASSERT(AObj <> nil);
  if FRowIDOrdered then begin
    iFirstNo := 0;
    iLastNo := FCount - 1;
    iObjRowId := TADDatSRow(AObj).FRowID;
    if iObjRowId = $FFFFFFFF then begin
      Result := -1;
      Exit;
    end;
    while iFirstNo <= iLastNo do begin
      Result := (iFirstNo + iLastNo) div 2;
      oRow := TADDatSRow(FArray[Result]);
      if oRow.FRowID > iObjRowId then
        iLastNo := Result - 1
      else if oRow.FRowID < iObjRowId then
        iFirstNo := Result + 1
      else
        Exit;
    end;
    Result := -1;
  end
  else
    Result := inherited IndexOf(AObj);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTableRowList.Clear;
begin
  inherited Clear;
  FLastRowID := 0;
  FRowIDOrdered := True;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTableRowList.AddObjectAt(AObj: TADDatSObject;
  APosition: Integer);
begin
  inherited AddObjectAt(AObj, APosition);
  if not ((APosition = -1) or (APosition = Count - 1)) then
    FRowIDOrdered := False;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTableRowList.RemoveAt(AIndex: Integer;
  ANotDestroy: Boolean);
begin
  inherited RemoveAt(AIndex, ANotDestroy);
  if Count = 0 then
    FRowIDOrdered := True;
end;

{-------------------------------------------------------------------------------}
{- TADDatSViewRowList                                                          -}
{-------------------------------------------------------------------------------}
constructor TADDatSViewRowList.CreateForView(AView: TADDatSView);
begin
  ASSERT(AView <> nil);
  inherited Create;
  FOwner := AView;
  OwnObjects := False;
  LockNotification;
end;

{-------------------------------------------------------------------------------}
{- TADDatSNestedRowList                                                        -}
{-------------------------------------------------------------------------------}
constructor TADDatSNestedRowList.CreateForRow(ARow: TADDatSRow);
begin
  ASSERT(ARow <> nil);
  inherited Create;
  FOwner := ARow;
  OwnObjects := False;
  LockNotification;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSNestedRowList.AddObjectAt(AObj: TADDatSObject;
  APosition: Integer);
begin
  ASSERT(AObj <> nil);
  TADDatSRow(AObj).ParentRow := TADDatSRow(FOwner);
  inherited AddObjectAt(AObj, APosition);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSNestedRowList.RemoveAt(AIndex: Integer;
  ANotDestroy: Boolean);
begin
  ItemsI[AIndex].ParentRow := nil;
  inherited RemoveAt(AIndex, ANotDestroy);
end;

{-------------------------------------------------------------------------------}
{- TADDatSView                                                                 -}
{-------------------------------------------------------------------------------}
constructor TADDatSView.Create;
begin
  inherited Create;
  FRows := TADDatSViewRowList.CreateForView(Self);
  FMechanisms := TADDatSViewMechList.CreateForView(Self);
  FAggregates := TADDatSAggregateList.CreateForView(Self);
  FState := [vsOutdated];
  FRefs := TADDatSRefCounter.Create(Self);
  FProposedPosition := -1;
end;

{-------------------------------------------------------------------------------}
constructor TADDatSView.Create(ATable: TADDatSTable; const AFilter, ASort: String;
  AStates: TADDatSRowStates);
begin
  ASSERT(ATable <> nil);
  Create;
  if ASort <> '' then
    Mechanisms.AddSort(ASort);
  if AFilter <> '' then
    Mechanisms.AddFilter(AFilter);
  if AStates <> [] then
    Mechanisms.AddStates(AStates)
  else // filter out deleted rows
    Mechanisms.AddStates([rsInserted, rsModified, rsUnchanged,
      rsInitializing, rsEditing, rsCalculating, rsChecking]);
  Active := True;
  ATable.Views.AddObjectAt(Self, -1);
end;

{-------------------------------------------------------------------------------}
constructor TADDatSView.Create(ATable: TADDatSTable;
  const ABaseName: String; ACreator: TADDatSViewCreator;
  ACountRef: Boolean);
begin
  ASSERT(ATable <> nil);
  Create;
  if ABaseName <> '' then
    Name := ATable.Views.BuildUniqueName(ABaseName);
  Creator := ACreator;
  ATable.Views.AddEx(Self);
  if ACountRef then
    CountRef;
end;

{-------------------------------------------------------------------------------}
destructor TADDatSView.Destroy;
begin
  Active := False;
  FreeAndNil(FRows);
  FreeAndNil(FMechanisms);
  FreeAndNil(FAggregates);
  FreeAndNil(FRefs);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSView.Assign(AObj: TADDatSObject);
begin
  Active := False;
  inherited Assign(AObj);
  if AObj is TADDatSView then begin
    Creator := TADDatSView(AObj).Creator;
    SourceView := TADDatSView(AObj).SourceView;
    Mechanisms.Assign(TADDatSView(AObj).Mechanisms);
    Active := TADDatSView(AObj).Active;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSView.IsEqualTo(AObj: TADDatSObject): Boolean;
begin
  Result := inherited IsEqualTo(AObj);
  if Result then begin
    ASSERT(AObj <> nil);
    Result := (SourceView = TADDatSView(AObj).SourceView) and
      Mechanisms.IsEqualTo(TADDatSView(AObj).Mechanisms);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSView.CountRef(AInit: Integer = 1);
begin
  FRefs.CountRef(AInit);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSView.AddRef;
begin
  FRefs.AddRef;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSView.RemRef;
begin
  FRefs.RemRef;
end;

{-------------------------------------------------------------------------------}
function TADDatSView.GetIsRefCounted: Boolean;
begin
  Result := FRefs.FRefs >= 0;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSView.CheckRebuild;
begin
  if ActualActive and (vsOutdated in FState) then
    Rebuild;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSView.InvalidateRebuild;
begin
  FState := FState + [vsOutdated];
  CheckRebuild;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSView.Clear;
begin
  try
    Rows.Clear;
    ProposedPosition := -1;
    FLastUpdatePosition := -1;
  finally
    FState := FState + [vsOutdated];
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSView.DoRowAdded(ARow: TADDatSRow);
var
  iNewPos, iOldPos: Integer;
  info: TADDatSViewUpdateInfo;
begin
  if not ActualActive then begin
    FState := FState + [vsOutdated];
    ProposedPosition := -1;
    FLastUpdatePosition := -1;
    Exit;
  end;
  iNewPos := -1;
  iOldPos := -1;
  if ProcessRow(ARow, iNewPos, iOldPos, True) = psAccepted then begin
    info.FRow := ARow;
    info.FIndex := iNewPos;
    info.FKind := vuRowAdded;
    Notify(snViewUpdated, srDataChange, Integer(Self), Integer(@info));
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSView.DoRowChanged(ARow: TADDatSRow);
var
  iNewPos, iOldPos: Integer;
  info: TADDatSViewUpdateInfo;
  ePS: TADDatSViewProcessRowStatus;
begin
  if not ActualActive then begin
    FState := FState + [vsOutdated];
    ProposedPosition := -1;
    FLastUpdatePosition := -1;
    Exit;
  end;
  iNewPos := -1;
  iOldPos := -1;
  ePS := ProcessRow(ARow, iNewPos, iOldPos, False);
  if ePS = psAccepted then begin
    info.FRow := ARow;
    info.FIndex := iNewPos;
    if iOldPos <> -1 then begin
      info.FKind := vuRowChanged;
      info.FOldIndex := iOldPos;
    end
    else
      info.FKind := vuRowAdded;
    Notify(snViewUpdated, srDataChange, Integer(Self), Integer(@info));
  end
  else if (ePS = psRejected) and (iOldPos <> -1) then begin
    info.FRow := ARow;
    info.FIndex := iOldPos;
    info.FKind := vuRowDeleted;
    Notify(snViewUpdated, srDataChange, Integer(Self), Integer(@info));
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSView.DoRowDeleted(ARow: TADDatSRow);
var
  i: Integer;
  info: TADDatSViewUpdateInfo;
begin
  if not ActualActive then begin
    FState := FState + [vsOutdated];
    ProposedPosition := -1;
    FLastUpdatePosition := -1;
    Exit;
  end;
  i := ProposedPosition;
  ProposedPosition := -1;
  FLastUpdatePosition := -1;
  if (i = -1) or (Rows.ItemsI[i] <> ARow) then
    i := IndexOf(ARow);
  if i <> -1 then begin
    Aggregates.RowDeleted(i);
    Rows.RemoveAt(i);
    info.FRow := ARow;
    info.FIndex := i;
    info.FKind := vuRowDeleted;
    Notify(snViewUpdated, srDataChange, Integer(Self), Integer(@info));
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSView.GetActual: Boolean;
begin
  Result := not (vsOutdated in FState);
end;

{-------------------------------------------------------------------------------}
function TADDatSView.GetViewList: TADDatSViewList;
begin
  if Owner <> nil then
    Result := TADDatSViewList(Owner)
  else
    Result := nil;
  ASSERT((Result = nil) or (Result is TADDatSViewList));
end;

{-------------------------------------------------------------------------------}
function TADDatSView.GetTable: TADDatSTable;
begin
  if (Owner <> nil) and (Owner.Owner <> nil) then
    Result := TADDatSTable(Owner.Owner)
  else
    Result := nil;
  ASSERT((Result = nil) or (Result is TADDatSTable));
end;

{-------------------------------------------------------------------------------}
procedure TADDatSView.HandleNotification(AParam: PDEDatSNotifyParam);
var
  pInfo: PDEDataViewUpdateInfo;
  oTab: TADDatSTable;
  oView, oViewMsg: TADDatSView;
begin
  if Mechanisms <> nil then
    Mechanisms.HandleNotification(AParam);
  if Aggregates <> nil then
    Aggregates.HandleNotification(AParam);
  with AParam^ do
    if FKind = snMechanismStateChanged then begin
      oViewMsg := TADDatSMechBase(FParam1).View;
      oView := Self;
      while (oView <> nil) and (oView <> oViewMsg) do
        oView := oView.SourceView;
      if oView <> nil then begin
        UpdateSortingMechanism(nil);
        InvalidateRebuild;
      end;
    end
    else if (FKind = snObjectRemoving) and (TADDatSObject(FParam2) is TADDatSView) then begin
      oViewMsg := TADDatSView(FParam2);
      if SourceView = oViewMsg then
        SourceView := nil
      else if oViewMsg <> Self then begin
        oView := Self;
        while (oView <> nil) and (oView <> oViewMsg) do
          oView := oView.SourceView;
        if oView <> nil then
          UpdateSortingMechanism(oViewMsg);
      end;
    end
    else begin
      oTab := Table;
      if oTab <> nil then
        if SourceView = nil then
          case FKind of
          snObjectInserted:
            if (TADDatSList(FParam1) is TADDatSTableRowList) and
               (TADDatSTableRowList(FParam1) = oTab.Rows) then
              DoRowAdded(TADDatSRow(FParam2));
          snObjectRemoved:
            if (TADDatSList(FParam1) is TADDatSTableRowList) and
               (TADDatSTableRowList(FParam1) = oTab.Rows) then
              DoRowDeleted(TADDatSRow(FParam2));
          snRowStateChanged, snRowErrorStateChanged, snRowDataChanged:
            if (TADDatSRow(FParam1).Table = oTab) and
               ((FKind <> snRowStateChanged) or
                 not (TADDatSRow(FParam1).RowState in
                      [rsEditing,
                       rsImportingCurent, rsImportingOriginal, rsImportingProposed])) then
              DoRowChanged(TADDatSRow(FParam1));
          end
        else
          if (FKind = snViewUpdated) and (TADDatSView(FParam1) = SourceView) then begin
            pInfo := PDEDataViewUpdateInfo(FParam2);
            case pInfo^.FKind of
            vuRowAdded:
              DoRowAdded(pInfo^.FRow);
            vuRowDeleted:
              DoRowDeleted(pInfo^.FRow);
            vuRowChanged:
              DoRowChanged(pInfo^.FRow);
            end;
          end;
    end;
end;

{-------------------------------------------------------------------------------}
function TADDatSView.ProcessRow(ARow: TADDatSRow; var ANewPos, AOldPos: Integer;
  AAdding: Boolean): TADDatSViewProcessRowStatus;
var
  i: Integer;
  lFound: Boolean;
  oMech: TADDatSMechBase;
begin
  Result := psAccepted;
  FLastUpdatePosition := -1;
  if AAdding then begin
    AOldPos := -1;
    ANewPos := ProposedPosition;
  end
  else begin
    AOldPos := ProposedPosition;
    ProposedPosition := -1;
    if (AOldPos = -1) or (Rows.ItemsI[AOldPos] <> ARow) then
      AOldPos := IndexOf(ARow, rvPrevious);
    ANewPos := AOldPos;
  end;
  for i := 0 to Mechanisms.Count - 1 do begin
    oMech := Mechanisms.ItemsI[i];
    if oMech.ActualActive and (mkFilter in oMech.Kinds) and not oMech.Locator then
      if not oMech.AcceptRow(ARow, rvDefault) then begin
        Result := psRejected;
        Break;
      end;
  end;
  if Result = psAccepted then begin
    if ((SortingMechanism = nil) or (SortingMechanism.SortSource = ssRowId))
       and not AAdding and (AOldPos <> -1) then
      Result := psUnchanged
    else begin
      if (SortingMechanism = nil) and AAdding then begin
        lFound := True;
        if ANewPos = -1 then
          ANewPos := Rows.Count;
      end
      else begin
        Search(ARow, nil, nil, -1, [loNearest, loLast, loExcludeKeyRow, loUseRowID],
          ANewPos, lFound, rvDefault);
        if ANewPos = -1 then
          ANewPos := 0
        else if lFound then
          Inc(ANewPos);
      end;
      if AOldPos <> ANewPos then begin
        if AOldPos <> -1 then begin
          Rows.RemoveAt(AOldPos);
          if ANewPos > AOldPos then
            Dec(ANewPos);
        end;
        Rows.AddAt(ARow, ANewPos);
      end;
    end;
    if AOldPos = -1 then
      Aggregates.RowInserted(ANewPos)
    else
      Aggregates.RowUpdated(ANewPos, AOldPos);
    FLastUpdatePosition := ANewPos;
  end
  else if (Result = psRejected) and (AOldPos <> -1) then begin
    Aggregates.RowDeleted(AOldPos);
    Rows.RemoveAt(AOldPos);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSView.Rebuild;
var
  i: Integer;
  j: Integer;
  lAccepted: Boolean;
  oMech: TADDatSMechBase;
  oRows: TADDatSRowListBase;
  iNewBegin, iBegin, iNewEnd, iEnd: Integer;
  oSortMech: IADDataMechSort;
  oRow: TADDatSRow;
begin
  Clear;
  if SourceView <> nil then
    oRows := SourceView.Rows
  else if Table <> nil then
    oRows := Table.Rows
  else
    Exit;
  try
    iBegin := 0;
    iEnd := oRows.Count - 1;
    if iEnd >= 0 then begin
      // filter rows
      for j := 0 to Mechanisms.Count - 1 do begin
        oMech := Mechanisms.ItemsI[j];
        if oMech.ActualActive then begin
          if mkHasList in oMech.Kinds then begin
            // expecting, here oRows will set to nested rows list
            if oMech.GetRowsRange(oRows, iBegin, iEnd) then
              Break;
          end
          else if (mkFilter in oMech.Kinds) and not oMech.Locator then begin
            iNewBegin := iBegin;
            iNewEnd := iEnd;
            if oMech.GetRowsRange(oRows, iNewBegin, iNewEnd) then begin
              if iNewBegin > iBegin then
                iBegin := iNewBegin;
              if iNewEnd < iEnd then
                iEnd := iNewEnd;
            end;
          end;
        end;
      end;
      for i := iBegin to iEnd do begin
        oRow := oRows.ItemsI[i];
        if not (oRow.RowState in [rsEditing, rsChecking]) then begin
          lAccepted := True;
          for j := 0 to Mechanisms.Count - 1 do begin
            oMech := Mechanisms.ItemsI[j];
            if oMech.ActualActive and (mkFilter in oMech.Kinds) and not oMech.Locator then
              if not oMech.AcceptRow(oRow, rvDefault) then begin
                lAccepted := False;
                Break;
              end;
          end;
          if lAccepted then
            Rows.Add(oRow);
        end;
      end;
      // sort rows
      for j := 0 to Mechanisms.Count - 1 do begin
        oMech := Mechanisms.ItemsI[j];
        if oMech.ActualActive and (mkSort in oMech.Kinds) and
           Supports(oMech, IADDataMechSort, oSortMech) then
          oSortMech.Sort(Rows);
      end;
    end;
    FState := FState - [vsOutdated];
    Aggregates.Recalc;
  except
    Clear;
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSView.GetActualActive: Boolean;
var
  oViewList: TADDatSViewList;
begin
  oViewList := ViewList;
  Result := Active and (Table <> nil) and
    ((oViewList = nil) or oViewList.Active) and
    ((SourceView = nil) or SourceView.Active and (SourceView.Table = Table));
end;

{-------------------------------------------------------------------------------}
procedure TADDatSView.CheckActiveChanged;
var
  i: Integer;
begin
  if FPrevActualActive <> ActualActive then begin
    FPrevActualActive := ActualActive;
    LockNotification;
    try
      for i := 0 to Mechanisms.Count - 1 do
        if mkSort in Mechanisms.ItemsI[i].Kinds then
          Mechanisms.ItemsI[i].CheckActiveChanged;
      UpdateSortingMechanism(nil);
      for i := 0 to Mechanisms.Count - 1 do
        if not (mkSort in Mechanisms.ItemsI[i].Kinds) then
          Mechanisms.ItemsI[i].CheckActiveChanged;
    finally
      UnlockNotification;
    end;
    if FPrevActualActive then
      CheckRebuild
    else
      FState := FState + [vsOutdated];
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSView.DoListInserted;
begin
  CheckActiveChanged;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSView.DoListRemoving;
begin
  Active := False;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSView.SetActive(const AValue: Boolean);
begin
  if FActive <> AValue then begin
    FActive := AValue;
    CheckActiveChanged;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSView.SetSourceView(const AValue: TADDatSView);
begin
  ASSERT(AValue <> Self);
  if FSourceView <> AValue then begin
    Active := False;
    FSourceView := AValue;
    if (AValue <> nil) and (AValue.Index > Index) then
      Table.Views.Move(AValue.Index, Index);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSView.UpdateSortingMechanism(AExcludeView: TADDatSView);
var
  i: Integer;
begin
  if Mechanisms = nil then
    Exit;
  PPointer(@FSortingMechanism)^ := nil;
  i := Mechanisms.Count - 1;
  while (i >= 0) and not (Mechanisms.ItemsI[i].ActualActive and
        (mkSort in Mechanisms.ItemsI[i].Kinds) and
        Supports(Mechanisms.ItemsI[i], IADDataMechSort, FSortingMechanism)) do
    Dec(i);
  if i = -1 then
    if (SourceView <> nil) and (SourceView <> AExcludeView) then begin
      SourceView.UpdateSortingMechanism(AExcludeView);
      FSortingMechanism := SourceView.SortingMechanism;
    end;
end;

{-------------------------------------------------------------------------------}
function TADDatSView.Search(AKeyRow: TADDatSRow;
  AKeyColumnList, AKeyColumnList2: TADDatSColumnSublist; AKeyColumnCount: Integer;
  AOptions: TADLocateOptions; var AIndex: Integer; var AFound: Boolean;
  ARowVersion: TADDatSRowVersion = rvDefault): Integer;
var
  i: Integer;
  eProhibitSortOpts: TADSortOptions;
  eCompOpts: TADCompareDataOptions;
  oRow: TADDatSRow;
  oCache: TADDatSCompareRowsCache;
begin
  ASSERT(AKeyRow <> nil);
  AIndex := -1;
  Result := -1;
  AFound := False;
  oCache := nil;
(*
  Ind Src	Ok
  S	  S	  +	  Src
  S	  I	  +	  Src
  I	  S	  -	  -
  I	  I	  +	  Src

  loNoCase -> [], []
           -> [], [soNoCase]
*)
  eProhibitSortOpts := [];
  if not (loNoCase in AOptions) then
    Include(eProhibitSortOpts, soNoCase);
  if (SortingMechanism <> nil) and (
      (AKeyColumnList = nil) or
      SortingMechanism.SortingOn(AKeyColumnList, AKeyColumnCount, [], eProhibitSortOpts)
     ) then
    Result := SortingMechanism.Search(Rows, AKeyRow, AKeyColumnList, AKeyColumnList2,
      AKeyColumnCount, AOptions, AIndex, AFound, ARowVersion)
  else begin
    if (AKeyRow.RowState = rsUnchanged) and
       (AKeyRow.RowPriorState in [rsInitializing, rsDetached]) and
       (Table.DataHandleMode in [lmHavyFetching, lmFetching]) then begin
      // fetching - not in a list yet
    end
    else if AKeyRow.Owner = Table.Rows then begin
      AIndex := IndexOf(AKeyRow, ARowVersion);
      if AIndex <> -1 then begin
        Result := 0;
        AFound := True;
      end;
    end
    else begin
      eCompOpts := [coCache];
      if loPartial in AOptions then
        Include(eCompOpts, coPartial);
      if loNoCase in AOptions then
        Include(eCompOpts, coNoCase);
      for i := 0 to Rows.Count - 1 do begin
        oRow := Rows.ItemsI[i];
        if (oRow <> AKeyRow) or not (loExcludeKeyRow in AOptions) then
          if (oRow = AKeyRow) or
             (oRow.CompareRows(AKeyColumnList, nil, nil, AKeyColumnCount,
                               AKeyRow, AKeyColumnList2, ARowVersion, eCompOpts,
                               oCache) = 0) then begin
            AIndex := i;
            AFound := True;
            Result := 0;
            Break;
          end;
      end;
    end;
    if not AFound and (loNearest in AOptions) then begin
      AIndex := Rows.Count;
      Result := 1;
      AFound := False;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSView.Find(const AValues: array of Variant;
  AOptions: TADLocateOptions): Integer;
var
  oRow: TADDatSRow;
  i: Integer;
begin
  ASSERT(Table <> nil);
  if SortingMechanism = nil then begin
    Result := -1;
    Exit;
  end;
  oRow := Table.NewRow(False);
  try
    oRow.BeginForceWrite;
    for i := Low(AValues) to High(AValues) do
      oRow.SetData(SortingMechanism.SortColumnList[i - Low(AValues)], AValues[i]);
    oRow.EndForceWrite;
    Result := Find(oRow, AOptions);
  finally
    oRow.Free;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSView.Find(ARow: TADDatSRow; AOptions: TADLocateOptions): Integer;
var
  lFound: Boolean;
begin
  ASSERT(Table <> nil);
  if SortingMechanism = nil then begin
    Result := -1;
    Exit;
  end;
  lFound := False;
  Search(ARow, nil, nil, -1, AOptions, Result, lFound);
  if not lFound then
    Result := -1;
end;

{-------------------------------------------------------------------------------}
function TADDatSView.Find(const AValues: array of Variant; const AColumns: String;
  AOptions: TADLocateOptions): Integer;
var
  oRow: TADDatSRow;
  i: Integer;
  lFound: Boolean;
  oKeyCols: TADDatSColumnSublist;
begin
  ASSERT(Table <> nil);
  oKeyCols := TADDatSColumnSublist.Create;
  try
    oKeyCols.Fill(Self, AColumns);
    oRow := Table.NewRow(False);
    try
      oRow.BeginForceWrite;
      for i := 0 to oKeyCols.Count - 1 do
        oRow.SetData(oKeyCols.ItemsI[i], AValues[i]);
      oRow.EndForceWrite;
      lFound := False;
      Result := -1;
      Search(oRow, oKeyCols, nil, -1, AOptions, Result, lFound);
      if not lFound then
        Result := -1;
    finally
      oRow.Free;
    end;
  finally
    oKeyCols.Free;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSView.Find(ARow: TADDatSRow; const AColumns: String;
  AOptions: TADLocateOptions): Integer;
var
  lFound: Boolean;
  oKeyCols: TADDatSColumnSublist;
begin
  ASSERT(Table <> nil);
  oKeyCols := TADDatSColumnSublist.Create;
  try
    oKeyCols.Fill(Self, AColumns);
    lFound := False;
    Result := -1;
    Search(ARow, oKeyCols, nil, -1, AOptions, Result, lFound);
    if not lFound then
      Result := -1;
  finally
    oKeyCols.Free;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSView.IndexOf(AKeyRow: TADDatSRow; ARowVersion: TADDatSRowVersion): Integer;
var
  iIndex: Integer;
  lFound: Boolean;
begin
  ASSERT(AKeyRow <> nil);
  if (Table.FDefaultView = Self) and
     (AKeyRow.FRowID < LongWord(Rows.Count)) and (Rows.ItemsI[AKeyRow.FRowID] = AKeyRow) then
    Result := AKeyRow.FRowID
  else if (SortingMechanism <> nil) and
          (SortingMechanism.SortOptions * [soUnique, soPrimary] <> []) then begin
    lFound := False;
    iIndex := -1;
    SortingMechanism.Search(Rows, AKeyRow, nil, nil, -1, [], iIndex, lFound, ARowVersion);
    if lFound then
      Result := iIndex
    else
      Result := -1;
  end
  else
    Result := Rows.IndexOf(AKeyRow);
end;

{-------------------------------------------------------------------------------}
function TADDatSView.GetGroupState(ARecordIndex, AGroupingLevel: Integer): TADDatSGroupPositions;
var
  lMiddle: Boolean;
begin
  Result := [];
  lMiddle := True;
  if (ARecordIndex <= 0) or (AGroupingLevel <> 0) and (SortingMechanism <> nil) and (ARecordIndex < Rows.Count) and
     (SortingMechanism.CompareRows(Rows[ARecordIndex - 1], Rows[ARecordIndex], AGroupingLevel) <> 0) then begin
    Include(Result, gpFirst);
    lMiddle := False;
  end;
  if (ARecordIndex >= Rows.Count - 1) or (AGroupingLevel <> 0) and (SortingMechanism <> nil) and (ARecordIndex >= 0) and
     (SortingMechanism.CompareRows(Rows[ARecordIndex], Rows[ARecordIndex + 1], AGroupingLevel) <> 0) then begin
    Include(Result, gpLast);
    lMiddle := False;
  end;
  if lMiddle then
    Include(Result, gpMiddle);
end;

{-------------------------------------------------------------------------------}
function TADDatSView.GetGroupingLevel: Integer;
begin
  Result := 0;
  if SortingMechanism <> nil then
    case SortingMechanism.SortSource of
    ssColumns:    Result := SortingMechanism.SortColumnList.Count;
    ssExpression: Result := 1;
    end;
end;

{-------------------------------------------------------------------------------}
function TADDatSView.GetMechanismByClass(AClass: TADDatSMechBaseClass;
  AKind: TADDatSMechanismKind): TADDatSMechBase;
var
  i: Integer;
  oMech: TADDatSMechBase;
begin
  Result := nil;
  for i := 0 to Mechanisms.Count - 1 do begin
    oMech := Mechanisms[i];
    if (AKind in oMech.Kinds) and (oMech is AClass) then begin
      Result := oMech;
      Exit;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSView.GetRowFilter: String;
var
  oFlt: TADDatSMechFilter;
begin
  oFlt := TADDatSMechFilter(GetMechanismByClass(TADDatSMechFilter, mkFilter));
  if oFlt = nil then
    Result := ''
  else
    Result := oFlt.Expression;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSView.SetRowFilter(const AValue: String);
var
  oFlt: TADDatSMechFilter;
begin
  oFlt := TADDatSMechFilter(GetMechanismByClass(TADDatSMechFilter, mkFilter));
  if oFlt = nil then
    Mechanisms.AddFilter(AValue)
  else begin
    oFlt.Expression := AValue;
    oFlt.Active := True;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSView.GetRowStateFilter: TADDatSRowStates;
var
  oState: TADDatSMechRowState;
begin
  oState := TADDatSMechRowState(GetMechanismByClass(TADDatSMechRowState, mkFilter));
  if oState = nil then
    Result := [rsInitializing .. rsImportingProposed]
  else
    Result := oState.RowStates;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSView.SetRowStateFilter(const AValue: TADDatSRowStates);
var
  oState: TADDatSMechRowState;
begin
  oState := TADDatSMechRowState(GetMechanismByClass(TADDatSMechRowState, mkFilter));
  if oState = nil then
    Mechanisms.AddStates(AValue)
  else begin
    oState.RowStates := AValue;
    oState.Active := True;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSView.GetSort: String;
var
  oSort: TADDatSMechSort;
begin
  oSort := TADDatSMechSort(GetMechanismByClass(TADDatSMechSort, mkSort));
  if oSort = nil then
    Result := ''
  else
    Result := oSort.Columns;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSView.SetSort(const AValue: String);
var
  oSort: TADDatSMechSort;
begin
  oSort := TADDatSMechSort(GetMechanismByClass(TADDatSMechSort, mkSort));
  if oSort = nil then
    Mechanisms.AddSort(AValue)
  else begin
    oSort.Columns := AValue;
    oSort.Active := True;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSView.Locate(var ARowIndex: Integer; AGoForward, ARestart: Boolean): Boolean;
var
  i, iMechs: Integer;
  oRow: TADDatSRow;
  oMech: TADDatSMechBase;
begin
  if ARestart then
    if AGoForward then
      ARowIndex := 0
    else
      ARowIndex := Rows.Count - 1
  else
    if AGoForward then
      Inc(ARowIndex)
    else
      Dec(ARowIndex);
  Result := False;
  iMechs := Mechanisms.Count - 1;
  while (ARowIndex < Rows.Count) and (ARowIndex >= 0) do begin
    oRow := Rows[ARowIndex];
    i := 0;
    while i <= iMechs do begin
      oMech := Mechanisms.ItemsI[i];
      if oMech.Locator and oMech.ActualActive and
         not oMech.AcceptRow(oRow, rvDefault) then
        Break;
      Inc(i);
    end;
    if i = iMechs + 1 then begin
      Result := True;
      Exit;
    end;
    if AGoForward then
      Inc(ARowIndex)
    else
      Dec(ARowIndex);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSView.DeleteAll;
var
  i: Integer;
begin
  for i := Rows.Count - 1 downto 0 do
    Rows.ItemsI[i].Delete;
end;

{-------------------------------------------------------------------------------}
{- TADDatSViewList                                                             -}
{-------------------------------------------------------------------------------}
constructor TADDatSViewList.CreateForTable(ATable: TADDatSTable);
begin
  ASSERT(ATable <> nil);
  inherited Create;
  FActive := True;
  FOwner := ATable;
  OwnObjects := True;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSViewList.Assign(AObj: TADDatSObject);
begin
  Active := False;
  inherited Assign(AObj);
  if AObj is TADDatSViewList then
    Active := TADDatSViewList(AObj).Active;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSViewList.HandleNotification(AParam: PDEDatSNotifyParam);
begin
  with AParam^ do
    if (FReason = srDataChange) and
       (TADDatSTable(Owner).DataHandleMode in [lmHavyMove, lmHavyFetching]) then
      Exit;
  inherited HandleNotification(AParam);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSViewList.SetActive(const AValue: Boolean);
var
  i: Integer;
begin
  if FActive <> AValue then begin
    FActive := AValue;
    if FActive then
      for i := 0 to Count - 1 do
        ItemsI[i].CheckRebuild;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSViewList.Add(AObj: TADDatSView): Integer;
begin
  Result := AddObject(AObj);
end;

{-------------------------------------------------------------------------------}
function TADDatSViewList.Add(const AName: String): TADDatSView;
begin
  Result := TADDatSView.Create;
  Result.Name := AName;
  Result.Active := True;
  AddEx(Result);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSViewList.Clear;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    ItemsI[i].Active := False;
  inherited Clear;
end;

{-------------------------------------------------------------------------------}
function TADDatSViewList.GetItemsI(AIndex: Integer): TADDatSView;
begin
  ASSERT((AIndex >= 0) and (AIndex < FCount));
  Result := TADDatSView(FArray[AIndex]);
end;

{-------------------------------------------------------------------------------}
function TADDatSViewList.ViewByName(const AName: String): TADDatSView;
begin
  Result := TADDatSView(inherited ItemByName(AName));
end;

{-------------------------------------------------------------------------------}
function TADDatSViewList.FindSortedView(const AColumns: String;
  ARequiredOptions, AProhibitedOptions: TADSortOptions): TADDatSView;
var
  i: Integer;
  oView: TADDatSView;
  oSortMech: IADDataMechSort;
begin
  Result := nil;
  for i := 0 to Count - 1 do begin
    oView := ItemsI[i];
    if oView.Actual and (oView.Mechanisms.Count = 1) and
       (oView.Mechanisms.ItemsI[0].Kinds = [mkSort]) and
       Supports(oView.Mechanisms.ItemsI[0], IADDataMechSort, oSortMech) and
       oSortMech.SortingOn(AColumns, ARequiredOptions, AProhibitedOptions) then begin
      Result := oView;
      Break;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSViewList.Rebuild;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    ItemsI[i].Rebuild;
end;

{-------------------------------------------------------------------------------}
{- TADDatSTable                                                                -}
{-------------------------------------------------------------------------------}
constructor TADDatSTable.Create;
begin
  inherited Create;
  FColumns := TADDatSColumnList.CreateForTable(Self);
  FConstraints := TADDatSConstraintList.CreateForTable(Self);
  FRows := TADDatSTableRowList.CreateForTable(Self);
  FViews := TADDatSViewList.CreateForTable(Self);
  FUpdates := TADDatSUpdatesJournal.Create(Self);
  FUpdatesRegistry := True;
  FRefs := TADDatSRefCounter.Create(Self);
  FLocale := LOCALE_USER_DEFAULT;
  FCaseSensitive := True;
  FBlobs := TADDatSBlobCache.Create;
end;

{-------------------------------------------------------------------------------}
constructor TADDatSTable.Create(const AName: String);
begin
  Create;
  if AName <> '' then
    Name := AName;
end;

{-------------------------------------------------------------------------------}
destructor TADDatSTable.Destroy;
begin
  FViews.Clear;
  FConstraints.Clear;
  FDataHandleMode := lmDestroying;
  FreeAndNil(FUpdates);
  FreeAndNil(FViews);
  FreeAndNil(FRows);
  FreeAndNil(FConstraints);
  FreeAndNil(FColumns);
  FDefaultView := nil;
  FErrors := nil;
  FreeAndNil(FRefs);
  FreeAndNil(FBlobs);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.Assign(AObj: TADDatSObject);
begin
  Reset;
  inherited Assign(AObj);
  if AObj is TADDatSTable then begin
    Rows.MinimumCapacity := TADDatSTable(AObj).Rows.MinimumCapacity;
    FCaseSensitive := TADDatSTable(AObj).CaseSensitive;
    FLocale := TADDatSTable(AObj).Locale;
    FUpdatesRegistry := TADDatSTable(AObj).FUpdatesRegistry;
    Columns.Assign(TADDatSTable(AObj).Columns);
    Views.Assign(TADDatSTable(AObj).Views);
    if TADDatSTable(AObj).FDefaultView <> nil then
      FDefaultView := Views.ViewByName(TADDatSTable(AObj).FDefaultView.Name);
    if TADDatSTable(AObj).FErrors <> nil then
      FErrors := Views.ViewByName(TADDatSTable(AObj).FErrors.Name);
    if TADDatSTable(AObj).FChanges <> nil then
      FDefaultView := Views.ViewByName(TADDatSTable(AObj).FChanges.Name);
    Constraints.Assign(TADDatSTable(AObj).Constraints);
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.IsEqualTo(AObj: TADDatSObject): Boolean;
begin
  Result := inherited IsEqualTo(AObj);
  if Result then
    Result := (MinimumCapacity = TADDatSTable(AObj).MinimumCapacity) and
      (CaseSensitive = TADDatSTable(AObj).CaseSensitive) and
      (Locale = TADDatSTable(AObj).Locale) and
      (EnforceConstraints = TADDatSTable(AObj).EnforceConstraints) and
      Columns.IsEqualTo(TADDatSTable(AObj).Columns) and
      Constraints.IsEqualTo(TADDatSTable(AObj).Constraints) and
      (UpdatesRegistry = TADDatSTable(AObj).FUpdatesRegistry);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.CountRef(AInit: Integer = 1);
begin
  FRefs.CountRef(AInit);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.AddRef;
begin
  FRefs.AddRef;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.RemRef;
begin
  FRefs.RemRef;
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.GetIsRefCounted: Boolean;
begin
  Result := FRefs.FRefs >= 0;
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.GetTable: TADDatSTable;
begin
  Result := Self;
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.GetManager: TADDatSManager;
begin
  Result := FManager;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.CheckStructureChanging;
begin
  if (DataHandleMode <> lmDestroying) and (Rows.Count > 0) then
    ADException(Self, [S_AD_LDatS], er_AD_CantChangeTableStruct, [Name]);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.DoListRemoving;
begin
  if FDataHandleMode = lmDestroying then
    Exit;
  Views.Active := False;
  Reset;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.DoListRemoved(ANewOwner: TADDatSObject);
begin
  FManager := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.DoListInserted;
begin
  inherited DoListInserted;
  FManager := inherited GetManager;
  if Manager <> nil then
    FUpdatesRegistry := not Manager.UpdatesRegistry;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.AcceptChanges;
var
  i: Integer;
  lastState: TADDatSRowState;
begin
  if UpdatesRegistry then
    Updates.AcceptChanges(Self)
  else begin
    i := 0;
    while i < Rows.Count do begin
      lastState := Rows.ItemsI[i].RowState;
      Rows.ItemsI[i].AcceptChanges;
      if lastState <> rsDeleted then
        Inc(i);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.BeginLoadData(ADataHandleMode: TADDatSHandleMode);
var
  i: Integer;
  oChildTab: TADDatSTable;
begin
  if FDataHandleMode <> lmNone then
    Exit;
  Columns.CheckUpdateLayout(TADDatSRow.InstanceSize);
  if ADataHandleMode in [lmHavyFetching, lmHavyMove, lmDestroying] then
    LockNotification;
  if ADataHandleMode <> lmRefreshing then
    Constraints.Enforce := False;
  if ADataHandleMode in [lmHavyFetching, lmHavyMove, lmDestroying] then
    Views.Active := False;
  FDataHandleMode := ADataHandleMode;
  if ctInvars in Columns.FHasThings then
    for i := 0 to Columns.Count - 1 do
      with Columns.ItemsI[i] do
        if DataType in [dtRowSetRef, dtCursorRef, dtRowRef, dtArrayRef] then begin
          oChildTab := NestedTable;
          if oChildTab <> nil then
            oChildTab.BeginLoadData(ADataHandleMode);
        end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.EndLoadData;
var
  i: Integer;
  oChildTab: TADDatSTable;
  lGlobalChanges, lRefreshing: Boolean;
begin
  if FDataHandleMode = lmNone then
    Exit;
  if ctInvars in Columns.FHasThings then
    for i := 0 to Columns.Count - 1 do
      with Columns.ItemsI[i] do
        if DataType in [dtRowSetRef, dtCursorRef, dtRowRef, dtArrayRef] then begin
          oChildTab := NestedTable;
          if oChildTab <> nil then
            oChildTab.EndLoadData;
        end;
  lGlobalChanges := (FDataHandleMode in [lmHavyFetching, lmHavyMove, lmDestroying]);
  lRefreshing := (FDataHandleMode = lmRefreshing);
  FDataHandleMode := lmNone;
  if lGlobalChanges then
    try
      Views.Active := True;
      Views.Rebuild;
    except
    end;
  if not lRefreshing then
    Constraints.Enforce := True;
  if lGlobalChanges then
    UnlockNotification;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.Clear;
begin
  if (FDataHandleMode = lmDestroying) or (Rows.Count = 0) then
    Exit;
  BeginLoadData(lmDestroying);
  try
    Rows.Clear;
  finally
    EndLoadData;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.Copy: TADDatSTable;
var
  i: Integer;
begin
  Result := TADDatSTable.Create;
  try
    Result.Assign(Self);
    Result.BeginLoadData;
    for i := 0 to Rows.Count - 1 do
      Result.Import(Rows.ItemsI[i]);
    Result.EndLoadData;
  except
    Result.Free;
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.GetDefaultView: TADDatSView;
begin
  if FDefaultView = nil then begin
    FDefaultView := TADDatSView.Create(Self);
    try
      FDefaultView.Creator := vcDefaultView;
      FDefaultView.Name := Views.BuildUniqueName(C_AD_SysNamePrefix + 'ADF');
    except
      FreeAndNil(FDefaultView);
      raise;
    end;
  end;
  Result := FDefaultView;
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.GetEnforceConstraints: Boolean;
begin
  Result := Constraints.Enforce;
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.GetErrors: TADDatSView;
begin
  if FErrors = nil then begin
    FErrors := TADDatSView.Create(Self, C_AD_SysNamePrefix + 'ERR',
      vcErrorView, False);
    try
      FErrors.Mechanisms.AddError;
      FErrors.Active := True;
    except
      FreeAndNil(FErrors);
      raise;
    end;
  end;
  Result := FErrors;
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.GetHasErrors: Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to Rows.Count - 1 do
    if Rows.ItemsI[i].HasErrors then begin
      Result := True;
      Exit;
    end;
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.GetTableList: TADDatSTableList;
begin
  Result := List as TADDatSTableList;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.HandleNotification(AParam: PDEDatSNotifyParam);
begin
  with AParam^ do begin
    if (FReason = srDataChange) and (DataHandleMode in [lmHavyMove, lmHavyFetching]) then
      Exit;
    if Columns <> nil then
      Columns.HandleNotification(AParam);
    if Constraints <> nil then
      Constraints.HandleNotification(AParam);
    if Rows <> nil then
      Rows.HandleNotification(AParam);
    if Views <> nil then
      Views.HandleNotification(AParam);
    if FKind = snObjectRemoved then
      if FParam2 = LongWord(FDefaultView) then
        FDefaultView := nil
      else if FParam2 = LongWord(FErrors) then
        FErrors := nil
      else if FParam2 = LongWord(FChanges) then
        FChanges := nil;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.HasChanges(ARowStates: TADDatSRowStates): Boolean;
var
  i: Integer;
begin
  if UpdatesRegistry then
    Result := Updates.HasChanges(Self)
  else begin
    Result := False;
    for i := 0 to Rows.Count - 1 do
      if Rows.ItemsI[i].RowState in ARowStates then begin
        Result := True;
        Break;
      end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.GetChangesView(ARowStates: TADDatSRowStates): TADDatSView;
begin
  if FChanges = nil then begin
    FChanges := TADDatSView.Create(Self, C_AD_SysNamePrefix + 'CHV',
      vcChangesView, False);
    try
      FChanges.Mechanisms.AddStates(ARowStates);
      FChanges.Active := True;
    except
      FreeAndNil(FChanges);
      raise;
    end;
  end;
  Result := FChanges;
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.GetChanges2: TADDatSView;
begin
  Result := GetChangesView;
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.GetChanges(ARowStates: TADDatSRowStates): TADDatSTable;
begin
  Result := TADDatSTable.Create;
  Result.Assign(Self);
  Result.Import(GetChangesView(ARowStates));
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.Select(const AFilter, ASort: String;
  AStates: TADDatSRowStates): TADDatSView;
begin
  Result := TADDatSView.Create(Self, AFilter, ASort, AStates);
  Result.Name := Views.BuildUniqueName(C_AD_SysNamePrefix + 'SEL');
  Result.Creator := vcSelectView;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.ImportRow(ASrcRow: TADDatSRow);
begin
  Import(ASrcRow, nil);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.Import(ASrcRow: TADDatSRow; ADestRow: TADDatSRow = nil);
var
  oSrcTab: TADDatSTable;
  iDestColInd, iSrcColInd: Integer;
  i, iAssignMode: Integer;

  procedure AssignColData(ABuffKind: TADDatSRowState);
  var
    iPriorSrcRowState, iPriorDestRowState: TADDatSRowState;
    iLen: LongWord;
    pBuff: Pointer;
  begin
    iPriorSrcRowState := ASrcRow.RowState;
    iPriorDestRowState := ADestRow.RowState;
    ASrcRow.FRowState := ABuffKind;
    ADestRow.FRowState := ABuffKind;
    try
      if ASrcRow.GetBuffer(rvDefault) <> nil then begin
        if ADestRow.GetBuffer(rvDefault) = nil then
          case ABuffKind of
          rsImportingCurent:
            begin
              ASSERT(ADestRow.FpCurrent = nil);
              ADestRow.FpCurrent := ADestRow.AllocBuffer;
            end;
          rsImportingOriginal:
            begin
              ASSERT(ADestRow.FpOriginal = nil);
              ADestRow.FpOriginal := ADestRow.AllocBuffer;
            end;
          rsImportingProposed:
            begin
              ASSERT(ADestRow.FpProposed = nil);
              ADestRow.FpProposed := ADestRow.AllocBuffer;
            end;
          end;
        if iAssignMode = 1 then
          ADestRow.SetData(iDestColInd, ASrcRow.GetData(iSrcColInd, rvDefault))
        else if iAssignMode = 2 then begin
          iLen := 0;
          pBuff := nil;
          ASrcRow.GetData(iSrcColInd, rvDefault, pBuff, 0, iLen, False);
          ADestRow.SetData(iDestColInd, pBuff, iLen);
        end;
      end;
    finally
      ASrcRow.FRowState := iPriorSrcRowState;
      ADestRow.FRowState := iPriorDestRowState;
    end;
  end;

  procedure ImportNestedRows;
  var
    oSrcNestedRow, oDestNestedRow: TADDatSRow;
    oDestNestedTab: TADDatSTable;
    oSrcNestedRows: TADDatSNestedRowList;
    j: Integer;
  begin
    if iAssignMode = 2 then begin
      case oSrcTab.Columns.ItemsI[iSrcColInd].DataType of
      dtRowRef, dtArrayRef:
        begin
          oSrcNestedRow := ASrcRow.NestedRow[iSrcColInd];
          if oSrcNestedRow <> nil then begin
            oDestNestedTab := Columns.ItemsI[iDestColInd].NestedTable;
            oDestNestedRow := oDestNestedTab.NewRow(True);
            try
              oDestNestedRow.ParentRow := ADestRow;
              oDestNestedTab.Import(oSrcNestedRow, oDestNestedRow);
            except
              oDestNestedRow.Free;
              raise;
            end;
          end;
        end;
      dtRowSetRef, dtCursorRef:
        begin
          oSrcNestedRows := ASrcRow.NestedRows[iSrcColInd];
          if oSrcNestedRows.Count <> 0 then begin
            oDestNestedTab := Columns.ItemsI[iDestColInd].NestedTable;
            for j := 0 to oSrcNestedRows.Count - 1 do begin
              oDestNestedRow := oDestNestedTab.NewRow(True);
              try
                oDestNestedRow.ParentRow := ADestRow;
                oDestNestedTab.Import(oSrcNestedRows.ItemsI[j], oDestNestedRow);
              except
                oDestNestedRow.Free;
                raise;
              end;
            end;
          end;
        end;
      end;
    end;
  end;

begin
  ASSERT((ASrcRow <> nil) and (ASrcRow <> ADestRow) and
         ((ADestRow = nil) or (ADestRow.Table = Self)));
  oSrcTab := ASrcRow.Table;
  if ADestRow = nil then
    ADestRow := NewRow(True)
  else begin
    if ASrcRow.FpOriginal = nil then
      ADestRow.FreeBuffer(ADestRow.FpOriginal);
    if ASrcRow.FpCurrent = nil then
      ADestRow.FreeBuffer(ADestRow.FpCurrent);
    if ASrcRow.FpProposed = nil then
      ADestRow.FreeBuffer(ADestRow.FpProposed);
  end;
  try
    for i := 0 to oSrcTab.Columns.Count - 1 do begin
      if oSrcTab = Self then begin
        iAssignMode := 2;
        iDestColInd := i;
        iSrcColInd := i;
      end
      else begin
        iDestColInd := Columns.IndexOfName(oSrcTab.Columns.ItemsI[i].Name);
        if iDestColInd = -1 then begin
          iAssignMode := 0;
          iSrcColInd := -1;
        end
        else begin
          iSrcColInd := i;
          if oSrcTab.Columns.ItemsI[i].DataType = Columns.ItemsI[iDestColInd].DataType then
            iAssignMode := 2
          else
            iAssignMode := 1;
        end;
      end;
      if oSrcTab.Columns.ItemsI[i].DataType in [dtRowSetRef, dtCursorRef,
         dtRowRef, dtArrayRef, dtParentRowRef] then
        ImportNestedRows
      else begin
        AssignColData(rsImportingCurent);
        AssignColData(rsImportingOriginal);
        AssignColData(rsImportingProposed);
      end;
    end;
    if not ((ASrcRow.RowState in [rsInitializing, rsDetached]) or
            (ASrcRow.RowState = rsForceWrite) and (ASrcRow.RowPriorState = rsDetached)) and
       ((ADestRow.RowState in [rsInitializing, rsDetached]) or
        (ADestRow.RowState = rsForceWrite) and (ADestRow.RowPriorState = rsDetached)) then begin
      // sign, that we are importing row, not a real rowstate
      if ASrcRow.RowState in [rsUnchanged, rsDeleted] then
        ADestRow.FRowState := rsImportingOriginal
      else
        ADestRow.FRowState := rsImportingCurent;
      Rows.Add(ADestRow);
    end;
    ADestRow.FRowState := ASrcRow.RowState;
    ADestRow.FRowPriorState := ASrcRow.RowPriorState;
    ADestRow.RowError := ASrcRow.RowError;
    if not ((ADestRow.RowState in [rsInitializing, rsDetached]) or
            (ADestRow.RowState = rsForceWrite) and (ADestRow.RowPriorState = rsDetached)) then begin
      if ADestRow.RowState <> rsInserted then
        ADestRow.Notify(snRowStateChanged, srDataChange, Integer(ADestRow), 0);
      if ADestRow.RowError <> nil then
        ADestRow.Notify(snRowErrorStateChanged, srDataChange, Integer(ADestRow), 0);
      if ADestRow.RowState in [rsInserted, rsDeleted, rsModified] then
        ADestRow.RegisterChange;
    end;
    if not ((ADestRow.RowState in [rsEditing, rsInitializing, rsDetached]) or
            (ADestRow.RowState = rsForceWrite) and (ADestRow.RowPriorState = rsDetached)) and
       (ADestRow.FpProposed <> nil) then
      ADestRow.FreeBuffer(ADestRow.FpProposed);
  except
    ADestRow.Free;
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.Import(ARowList: TADDatSRowListBase);
var
  i: Integer;
begin
  ASSERT(ARowList <> nil);
  BeginLoadData;
  try
    for i := 0 to ARowList.Count - 1 do
      Import(ARowList.ItemsI[i]);
  finally
    EndLoadData;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.Import(AView: TADDatSView);
begin
  ASSERT(AView <> nil);
  Import(AView.Rows);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.Import(ATable: TADDatSTable);
begin
  ASSERT(ATable <> nil);
  Import(ATable.Rows);
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.NewRow(ASetToDefaults: Boolean): TADDatSRow;
begin
  Result := TADDatSRow.CreateInstance(Self, ASetToDefaults);
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.NewRow(const AValues: array of Variant;
  ASetToDefaults: Boolean): TADDatSRow;
begin
  Result := NewRow(ASetToDefaults);
  Result.SetValues(AValues);
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.NewRow(ASetToDefaults: Boolean;
  const AParentRows: array of TADDatSRow): TADDatSRow;
var
  oCons: TADDatSConstraintBase;
  i, j: Integer;
begin
  Result := NewRow(ASetToDefaults);
  for i := Low(AParentRows) to High(AParentRows) do
    if AParentRows[i] <> nil then
      for j := 0 to Constraints.Count - 1 do begin
        oCons := Constraints.ItemsI[j];
        if (oCons is TADDatSForeignKeyConstraint) and oCons.ActualEnforce and
           (TADDatSForeignKeyConstraint(oCons).InsertRule = crCascade) and
           (TADDatSForeignKeyConstraint(oCons).RelatedTable = AParentRows[i].Table) then
          TADDatSForeignKeyConstraint(oCons).DoInsertAssignParentValues(AParentRows[i], Result);
      end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.RejectChanges;
var
  i: Integer;
  lastState: TADDatSRowState;
begin
  if UpdatesRegistry then
    Updates.RejectChanges(Self)
  else begin
    i := 0;
    while i < Rows.Count do begin
      lastState := Rows.ItemsI[i].RowState;
      Rows.ItemsI[i].RejectChanges;
      if lastState <> rsInserted then
        Inc(i);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.GetChildRelations: TADDatSRelationArray;
var
  oManager: TADDatSManager;
begin
  oManager := Manager;
  if oManager <> nil then
    Result := oManager.Relations.GetRelationsForTable(False, Self);
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.GetParentRelations: TADDatSRelationArray;
var
  oManager: TADDatSManager;
begin
  oManager := Manager;
  if oManager <> nil then
    Result := oManager.Relations.GetRelationsForTable(True, Self);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.Reset;
var
  i: Integer;
  oRels: TADDatSRelationArray;
begin
  oRels := nil;
  if FDataHandleMode = lmDestroying then
    Exit;
  FDataHandleMode := lmDestroying;
  try
    Constraints.Clear;
    Views.Clear;
    Rows.Clear;
    oRels := ParentRelations;
    for i := 0 to Length(oRels) - 1 do
      oRels[i].Free;
    oRels := ChildRelations;
    for i := 0 to Length(oRels) - 1 do
      oRels[i].Free;
    Columns.Clear;
  finally
    FDataHandleMode := lmNone;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.SetEnforceConstraints(const AValue: Boolean);
begin
  Constraints.Enforce := AValue;
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.GetMinimumCapacity: Integer;
begin
  Result := Rows.MinimumCapacity;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.SetMinimumCapacity(const AValue: Integer);
begin
  Rows.MinimumCapacity := AValue;
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.LoadDataRow(const AValues: array of Variant;
  AAcceptChanges: Boolean): TADDatSRow;
var
  oNewRow, oTrgRow: TADDatSRow;
  i: Integer;
begin
  i := -1;
  Result := nil;
  oNewRow := NewRow(AValues, True);
  try
    i := FindRowByPK(oNewRow);
    if i = -1 then begin
      Rows.Add(oNewRow);
      if AAcceptChanges then
        oNewRow.AcceptChanges;
      Result := oNewRow;
    end
    else begin
      oTrgRow := Rows[i];
      oTrgRow.CancelEdit;
      oTrgRow.BeginEdit;
      try
        oTrgRow.SetValues(AValues);
        oTrgRow.EndEdit;
      except
        oTrgRow.CancelEdit;
        raise;
      end;
      if AAcceptChanges then
        oTrgRow.AcceptChanges;
      Result := oTrgRow;
    end;
  finally
    if i <> -1 then
      oNewRow.Free;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.FindRowByPK(ARow: TADDatSRow): Integer;
var
  oKey: TADDatSUniqueConstraint;
  oView: TADDatSView;
begin
  oKey := Constraints.FindPrimaryKey();
  if oKey = nil then
    Result := -1
  else begin
    oView := oKey.GetUniqueSortedView();
    Result := oView.Find(ARow, []);
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.Compute(const AExpression, AFilter: String): Variant;
var
  oView: TADDatSView;
begin
  oView := Select(AFilter);
  try
    if oView.Rows.Count = 0 then
      Result := Null
    else
      Result := oView.Aggregates.Add('', AExpression).Value[0];
  finally
    oView.Free;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.SetLocale(const AValue: LCID);
begin
  if FLocale <> AValue then begin
    FLocale := AValue;
    Views.Rebuild;
    Constraints.CheckAll;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.SetCaseSensitive(const AValue: Boolean);
begin
  if FCaseSensitive <> AValue then begin
    FCaseSensitive := AValue;
    Views.Rebuild;
    Constraints.CheckAll;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.GetPrimaryKey: String;
var
  oKey: TADDatSUniqueConstraint;
begin
  oKey := Constraints.FindPrimaryKey();
  if oKey <> nil then
    Result := oKey.ColumnNames
  else
    Result := '';
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.SetPrimaryKey(const AValue: String);
var
  oKey: TADDatSUniqueConstraint;
begin
  if PrimaryKey <> AValue then begin
    oKey := Constraints.FindPrimaryKey();
    if AValue = '' then begin
      if oKey <> nil then
        oKey.Free;
    end
    else if oKey <> nil then begin
      oKey.ColumnNames := AValue;
      oKey.Enforce := True;
    end
    else
      Constraints.AddUK(Constraints.BuildUniqueName(C_AD_SysNamePrefix + 'PK'), AValue, True);
  end;
end;

{-------------------------------------------------------------------------------}
{- TADDatSTableList                                                            -}
{-------------------------------------------------------------------------------}
constructor TADDatSTableList.CreateForManager(AManager: TADDatSManager);
begin
  ASSERT(AManager <> nil);
  inherited Create;
  FOwner := AManager;
  OwnObjects := True;
end;

{-------------------------------------------------------------------------------}
function TADDatSTableList.Add(AObj: TADDatSTable): Integer;
begin
  Result := AddObject(AObj);
end;

{-------------------------------------------------------------------------------}
function TADDatSTableList.Add(const AName: String): TADDatSTable;
begin
  Result := TADDatSTable.Create(AName);
  AddEx(Result);
end;

{-------------------------------------------------------------------------------}
function TADDatSTableList.GetItemsI(AIndex: Integer): TADDatSTable;
begin
  ASSERT((AIndex >= 0) and (AIndex < FCount));
  Result := TADDatSTable(FArray[AIndex]);
end;

{-------------------------------------------------------------------------------}
function TADDatSTableList.TableByName(const AName: String): TADDatSTable;
begin
  Result := TADDatSTable(inherited ItemByName(AName));
end;

{-------------------------------------------------------------------------------}
{- TADDatSUpdatesJournal                                                       -}
{-------------------------------------------------------------------------------}
constructor TADDatSUpdatesJournal.Create(AOwner: TADDatSObject);
begin
  ASSERT(AOwner <> nil);
  inherited Create;
  FOwner := AOwner;
end;

{-------------------------------------------------------------------------------}
function TADDatSUpdatesJournal.HasChanges(AOwner: TADDatSObject): Boolean;
begin
  Result := FirstChange(AOwner) <> nil;
end;

{-------------------------------------------------------------------------------}
function TADDatSUpdatesJournal.FirstChange(AOwner: TADDatSObject): TADDatSRow;
var
  iMode: Integer;
  lFound: Boolean;
begin
  Result := FFirstChange;
  if AOwner = nil then
    iMode := 0
  else if AOwner is TADDatSTable then
    iMode := 1
  else
    iMode := 2;
  lFound := False;
  while (Result <> nil) and not lFound do begin
    case iMode of
    0: lFound := True;
    1: lFound := (Result.Table = AOwner);
    2: lFound := (Result.Manager = AOwner);
    end;
    if not lFound then
      Result := Result.FNextChange;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSUpdatesJournal.NextChange(ACurRow: TADDatSRow;
  AOwner: TADDatSObject): TADDatSRow;
var
  iMode: Integer;
  lFound: Boolean;
begin
  if ACurRow = nil then begin
    Result := nil;
    Exit;
  end;
  Result := ACurRow.FNextChange;
  if AOwner = nil then
    iMode := 0
  else if AOwner is TADDatSTable then
    iMode := 1
  else
    iMode := 2;
  lFound := False;
  while (Result <> nil) and not lFound do begin
    case iMode of
    0: lFound := True;
    1: lFound := (Result.Table = AOwner);
    2: lFound := (Result.Manager = AOwner);
    end;
    if not lFound then
      Result := Result.FNextChange;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSUpdatesJournal.LastChange(AOwner: TADDatSObject): TADDatSRow;
var
  iMode: Integer;
  lFound: Boolean;
begin
  Result := FLastChange;
  if AOwner = nil then
    iMode := 0
  else if AOwner is TADDatSTable then
    iMode := 1
  else
    iMode := 2;
  lFound := False;
  while (Result <> nil) and not lFound do begin
    case iMode of
    0: lFound := True;
    1: lFound := (Result.Table = AOwner);
    2: lFound := (Result.Manager = AOwner);
    end;
    if not lFound then
      Result := Result.FPriorChange;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSUpdatesJournal.RegisterRow(ARow: TADDatSRow): Integer;
begin
  ASSERT(ARow <> nil);
  if ARow.FChangeNumber <> $FFFFFFFF then begin
    Result := ARow.FChangeNumber;
    Exit;
  end;
  ARow.FChangeNumber := FChangeNumber;
  if FFirstChange = nil then begin
    FLastChange := ARow;
    FFirstChange := ARow;
    ARow.FNextChange := nil;
    ARow.FPriorChange := nil;
  end
  else begin
    FLastChange.FNextChange := ARow;
    ARow.FPriorChange := FLastChange;
    ARow.FNextChange := nil;
    FLastChange := ARow;
  end;
  Result := FChangeNumber;
  ASSERT(FChangeNumber <> $FFFFFFFF);
  Inc(FChangeNumber);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSUpdatesJournal.UnregisterRow(ARow: TADDatSRow);
begin
  ASSERT(ARow <> nil);
  if ARow.FNextChange <> nil then
    ARow.FNextChange.FPriorChange := ARow.FPriorChange;
  if ARow.FPriorChange <> nil then
    ARow.FPriorChange.FNextChange := ARow.FNextChange;
  if FFirstChange = ARow then
    FFirstChange := ARow.FNextChange;
  if FLastChange = ARow then
    FLastChange := ARow.FPriorChange;
  if FTmpNextRow = ARow then
    FTmpNextRow := ARow.FNextChange;
  ARow.FChangeNumber := $FFFFFFFF;
  ARow.FPriorChange := nil;
  ARow.FNextChange := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSUpdatesJournal.SetSavePoint(const AValue: LongWord);
var
  oRow, oPriorRow: TADDatSRow;
begin
  oRow := FLastChange;
  while (oRow <> nil) and (oRow.FChangeNumber >= AValue) do begin
    oPriorRow := oRow.FPriorChange;
    oRow.RejectChanges;
    oRow := oPriorRow;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSUpdatesJournal.AcceptChanges(AOwner: TADDatSObject);
var
  oRow: TADDatSRow;
  iMode: Integer;
begin
  ASSERT(FTmpNextRow = nil);
  if AOwner = nil then
    iMode := 0
  else if AOwner is TADDatSTable then
    iMode := 1
  else
    iMode := 2;
  oRow := FFirstChange;
  try
    while oRow <> nil do begin
      FTmpNextRow := oRow.FNextChange;
      case iMode of
      0:
        oRow.AcceptChanges;
      1:
        if oRow.Table = AOwner then
          oRow.AcceptChanges;
      2:
        if oRow.Manager = AOwner then
          oRow.AcceptChanges;
      end;
      oRow := FTmpNextRow;
    end;
  finally
    FTmpNextRow := nil;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSUpdatesJournal.RejectChanges(AOwner: TADDatSObject);
begin
  SetSavePoint(0);
end;

{-------------------------------------------------------------------------------}
function TADDatSUpdatesJournal.GetCount(AOwner: TADDatSObject = nil): Integer;
var
  oRow, oNextRow: TADDatSRow;
  iMode: Integer;
begin
  if AOwner = nil then
    iMode := 0
  else if AOwner is TADDatSTable then
    iMode := 1
  else
    iMode := 2;
  oRow := FFirstChange;
  Result := 0;
  while oRow <> nil do begin
    oNextRow := oRow.FNextChange;
    case iMode of
    0:
      Inc(Result);
    1:
      if oRow.Table = AOwner then
        Inc(Result);
    2:
      if oRow.Manager = AOwner then
        Inc(Result);
    end;
    oRow := oNextRow;
  end;
end;

{-------------------------------------------------------------------------------}
{- TADDatSManager                                                              -}
{-------------------------------------------------------------------------------}
constructor TADDatSManager.Create;
begin
  inherited Create;
  FUpdates := TADDatSUpdatesJournal.Create(Self);
  FTables := TADDatSTableList.CreateForManager(Self);
  FRelations := TADDatSRelationList.CreateForManager(Self);
  FEnforceConstraints := True;
  FUpdatesRegistry := False;
  FRefs := TADDatSRefCounter.Create(Self);
  FCaseSensitive := True;
  FLocale := LOCALE_USER_DEFAULT;
end;

{-------------------------------------------------------------------------------}
destructor TADDatSManager.Destroy;
begin
  FreeAndNil(FUpdates);
  FreeAndNil(FTables);
  FreeAndNil(FRelations);
  FreeAndNil(FRefs);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSManager.Assign(AObj: TADDatSObject);
begin
  Reset;
  inherited Assign(AObj);
  if AObj is TADDatSManager then begin
    CaseSensitive := TADDatSManager(AObj).CaseSensitive;
    Locale := TADDatSManager(AObj).Locale;
    EnforceConstraints := TADDatSManager(AObj).EnforceConstraints;
    UpdatesRegistry := TADDatSManager(AObj).UpdatesRegistry;
    Tables.Assign(TADDatSManager(AObj).Tables);
    Relations.Assign(TADDatSManager(AObj).Relations);
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSManager.IsEqualTo(AObj: TADDatSObject): Boolean;
begin
  Result := inherited IsEqualTo(AObj);
  if Result then
    Result := (CaseSensitive = TADDatSManager(AObj).CaseSensitive) and
      (Locale = TADDatSManager(AObj).Locale) and
      (EnforceConstraints = TADDatSManager(AObj).EnforceConstraints) and
      (UpdatesRegistry = TADDatSManager(AObj).UpdatesRegistry) and
      Tables.IsEqualTo(TADDatSManager(AObj).Tables) and
      Relations.IsEqualTo(TADDatSManager(AObj).Relations);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSManager.CountRef(AInit: Integer = 1);
begin
  FRefs.CountRef(AInit);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSManager.AddRef;
begin
  FRefs.AddRef;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSManager.RemRef;
begin
  FRefs.RemRef;
end;

{-------------------------------------------------------------------------------}
function TADDatSManager.GetIsRefCounted: Boolean;
begin
  Result := FRefs.FRefs >= 0;
end;

{-------------------------------------------------------------------------------}
function TADDatSManager.GetRefs: Integer;
begin
  Result := FRefs.FRefs;
end;

{-------------------------------------------------------------------------------}
function TADDatSManager.GetManager: TADDatSManager;
begin
  Result := Self;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSManager.AcceptChanges;
var
  i: Integer;
begin
  if UpdatesRegistry then
    Updates.AcceptChanges(Self)
  else
    for i := 0 to Tables.Count - 1 do
      Tables.ItemsI[i].AcceptChanges;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSManager.Clear;
var
  i: Integer;
begin
  for i := 0 to Tables.Count - 1 do
    Tables.ItemsI[i].Clear;
end;

{-------------------------------------------------------------------------------}
function TADDatSManager.Copy: TADDatSManager;
var
  i: Integer;
  j: Integer;
  oSrcTab: TADDatSTable;
  oDestTab: TADDatSTable;
begin
  Result := TADDatSManager.Create;
  try
    Result.Assign(Self);
    for i := 0 to Tables.Count - 1 do begin
      oSrcTab := Tables.ItemsI[i];
      oDestTab := Result.Tables.ItemsI[i];
      oDestTab.BeginLoadData;
      try
        for j := 0 to oSrcTab.Rows.Count - 1 do
          oDestTab.Import(oSrcTab.Rows.ItemsI[j]);
      finally
        oDestTab.EndLoadData;
      end;
    end;
  except
    Result.Free;
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSManager.BeginLoadData(ADataHandleMode: TADDatSHandleMode);
var
  i: Integer;
begin
  for i := 0 to Tables.Count - 1 do
    Tables.ItemsI[i].BeginLoadData(ADataHandleMode);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSManager.EndLoadData;
var
  i: Integer;
begin
  for i := 0 to Tables.Count - 1 do
    Tables.ItemsI[i].EndLoadData;
end;

{-------------------------------------------------------------------------------}
function TADDatSManager.GetHasErrors: Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to Tables.Count - 1 do
    if Tables.ItemsI[i].HasErrors then begin
      Result := True;
      Exit;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSManager.HandleNotification(AParam: PDEDatSNotifyParam);
begin
  if Relations <> nil then
    Relations.HandleNotification(AParam);
  if Tables <> nil then
    Tables.HandleNotification(AParam);
end;

{-------------------------------------------------------------------------------}
function TADDatSManager.HasChanges(ARowStates: TADDatSRowStates): Boolean;
var
  i: Integer;
begin
  if UpdatesRegistry then
    Result := Updates.HasChanges(Self)
  else begin
    Result := False;
    for i := 0 to Tables.Count - 1 do
      if Tables.ItemsI[i].HasChanges(ARowStates) then begin
        Result := True;
        Exit;
      end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSManager.Merge(ARow: TADDatSRow; AOptions:
  TADDatSMergeOptions);
begin
  { TODO -cDATSMANAGER : Implement DataManager.Merge (1) }
end;

{-------------------------------------------------------------------------------}
procedure TADDatSManager.Merge(AManager: TADDatSManager; AOptions:
  TADDatSMergeOptions);
begin
  { TODO -cDATSMANAGER : Implement DataManager.Merge (2) }
end;

{-------------------------------------------------------------------------------}
procedure TADDatSManager.Merge(ATable: TADDatSTable; AOptions:
  TADDatSMergeOptions);
begin
  { TODO -cDATSMANAGER : Implement DataManager.Merge (3) }
end;

{-------------------------------------------------------------------------------}
procedure TADDatSManager.RejectChanges;
var
  i: Integer;
begin
  if UpdatesRegistry then
    Updates.RejectChanges(Self)
  else
    for i := 0 to Tables.Count - 1 do
      Tables.ItemsI[i].RejectChanges;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSManager.Reset;
begin
  Tables.Clear;
  Relations.Clear;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSManager.SetEnforceConstraints(const AValue: Boolean);
var
  i: Integer;
begin
  if FEnforceConstraints <> AValue then begin
    FEnforceConstraints := AValue;
    for i := 0 to Tables.Count - 1 do
      Tables.ItemsI[i].Constraints.EnforceUpdated;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSManager.SetUpdatesRegistry(const AValue: Boolean);
  procedure ErrorCantSetUpdReg;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_CantSetUpdReg, [Name]);
  end;
var
  i: Integer;
begin
  if UpdatesRegistry <> AValue then begin
    for i := 0 to Tables.Count - 1 do
      if Tables.ItemsI[i].HasChanges([rsInserted, rsDeleted, rsModified]) then
        ErrorCantSetUpdReg;
    for i := 0 to Tables.Count - 1 do
      Tables.ItemsI[i].FUpdatesRegistry := not AValue;
    FUpdatesRegistry := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
function DoCompRootTabs(Item1, Item2: Pointer): Integer;
begin
  Result := TADDatSTable(Item1).SourceID - TADDatSTable(Item2).SourceID;
end;

function TADDatSManager.GetRootTables: TADDatSTableArray;
var
  i, j: Integer;
  lInRoot: Boolean;
  oList: TList;
begin
  oList := TList.Create;
  try
    for i := 0 to Tables.Count - 1 do begin
      lInRoot := True;
      for j := 0 to Relations.Count - 1 do
        if Relations.ItemsI[j].ChildTable = Tables.ItemsI[i] then begin
          lInRoot := False;
          Break;
        end;
      if lInRoot then
        oList.Add(Tables.ItemsI[i]);
    end;
    if oList.Count > 1 then
      oList.Sort(DoCompRootTabs);
    SetLength(Result, oList.Count);
    for i := 0 to oList.Count - 1 do
      Result[i] := oList[i];
  finally
    oList.Free;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSManager.SetCaseSensitive(const AValue: Boolean);
var
  i: Integer;
begin
  if FCaseSensitive <> AValue then begin
    FCaseSensitive := AValue;
    for i := 0 to Tables.Count - 1 do
      Tables[i].CaseSensitive := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSManager.SetLocale(const AValue: LCID);
var
  i: Integer;
begin
  if FLocale <> AValue then begin
    FLocale := AValue;
    for i := 0 to Tables.Count - 1 do
      Tables[i].Locale := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSManager.LoadFromStream(AStream: TStream;
  AFormat: TADStreamFormat);
begin
  { TODO -cDATSMANAGER : Implement LoadFromStream }
end;

{-------------------------------------------------------------------------------}
procedure TADDatSManager.SaveToStream(AStream: TStream;
  AFormat: TADStreamFormat);
begin
  { TODO -cDATSMANAGER : Implement SaveToStream }
end;

end.


