{-------------------------------------------------------------------------------}
{ AnyDAC TADDataSet (base TDataSet descendant)                                  }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}
// 1. TADDataSet removes all TADDatSTable.Constraints at open
// 2. Check with wrong filter expression, constraint expression, etc

// 3. DatS objects should be creating/destroying in the same way.
//    Check how they are used in case of TADDatSSeg cloning.
// 4. We should not Define if already prepared and defined

unit daADCompDataSet;

interface

uses
  SysUtils, Classes, DB,
  daADStanIntf, daADStanOption, daADStanError, daADStanParam, 
  daADDatSManager,
  daADDAptIntf,
  daADPhysIntf;

type
{$IFDEF AnyDAC_FPC}
  TUpdateRecordTypes = set of (rtModified, rtInserted, rtDeleted, rtUnmodified);
  TGroupPosInd = (gbFirst, gbMiddle, gbLast);
  TGroupPosInds = set of TGroupPosInd;

  TObjectField = class(TField)
  private
    FFields: TFields;
    FObjectType: String;
  public
    property Fields: TFields read FFields;
    property ObjectType: String read FObjectType write FObjectType;
  end;

  TDataSetField = class(TObjectField)
  private
    FNestedDataSet: TDataSet;
  public
    property NestedDataSet: TDataSet read FNestedDataSet;
  end;
{$ENDIF}

  TADColMapItem = class;
  TADDataSet = class;
  TADMasterDataLink = class;
  TADIndex = class;
  TADIndexes = class;
  TADAggregate = class;
  TADAggregates = class;
  TADTableUpdateOptions = class;
  TADWideMemoField = class;
  TADAutoIncField = class;
  TADBlobStream = class;
  IADDataSet = interface;

  TADColMapItem = class(TObject)
  public
    FColumn: TADDatSColumn;
    FColumnIndex: Integer;
    FPath: array of Integer;
  end;

  TADKeyIndex = (kiLookup, kiRangeStart, kiRangeEnd, kiCurRangeStart,
    kiCurRangeEnd, kiSave);

  PADKeyBuffer = ^TADKeyBuffer;
  TADKeyBuffer = packed record
    Modified: Boolean;
    Exclusive: Boolean;
    FieldCount: Integer;
  end;

  IADDataSet = interface (IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2400}']
    function GetDataView: TADDatSView;
    property DataView: TADDatSView read GetDataView;
  end;

  TADUpdateRecordEvent = procedure (ASender: TDataSet; ARequest: TADPhysUpdateRequest;
    var AAction: TADErrorAction; AOptions: TADPhysUpdateRowOptions) of object;
  TADUpdateErrorEvent = procedure (ASender: TDataSet; AException: EADException;
    ARow: TADDatSRow; ARequest: TADPhysUpdateRequest; var AAction: TADErrorAction) of object;
  TADAfterApplyUpdatesEvent = procedure (DataSet: TADDataSet; AErrors: Integer) of object;
  TADReconcileErrorEvent = procedure(DataSet: TADDataSet; E: EADException;
    UpdateKind: TADDatSRowState; var Action: TADDAptReconcileAction) of object;
  TADDataSetEvent = procedure(DataSet: TADDataSet) of object;
  TADActiveAtRunTime = (arStandard, arInactive, arActive);

  TADMasterDataLink = class(TMasterDataLink)
  private
    FOnMasterFieldsDefined: TNotifyEvent;
{$IFDEF AnyDAC_D7}
    FFireActiveChanged: Boolean;
{$ENDIF}
    FActiveChangedLocked: Boolean;
  protected
    procedure ActiveChanged; override;
{$IFDEF AnyDAC_D7}
    procedure DataEvent(Event: TDataEvent; Info: Longint); override;
{$ENDIF}
  public
    property OnMasterFieldsDefined: TNotifyEvent read FOnMasterFieldsDefined
      write FOnMasterFieldsDefined;
  end;

  TADIndex = class (TCollectionItem)
  private
    FUpdateCount: Integer;
    FActive: Boolean;
    FFilter: String;
    FFields: String;
    FCaseInsFields: String;
    FExpression: String;
    FDescFields: String;
    FFilterOptions: TADExpressionOptions;
    FOptions: TADSortOptions;
    FView: TADDatSView;
    FName: String;
    procedure SetCaseInsFields(const AValue: String);
    procedure SetDescFields(const AValue: String);
    procedure SetExpression(const AValue: String);
    procedure SetFields(const AValue: String);
    procedure SetFilter(const AValue: String);
    procedure SetFilterOptions(const AValue: TADExpressionOptions);
    procedure SetOptions(const AValue: TADSortOptions);
    procedure SetName(const AValue: String);
    procedure IndexChanged;
    procedure SetActive(const AValue: Boolean);
    function GetActualActive: Boolean;
    procedure CreateView;
    procedure DeleteView;
    function GetDataSet: TADDataSet;
    function GetSelected: Boolean;
    procedure SetSelected(const AValue: Boolean);
  protected
    function GetDisplayName: String; override;
    procedure AssignTo(ADest: TPersistent); override;
  public
    destructor Destroy; override;
    procedure Assign(ASource: TPersistent); override;
    procedure BeginUpdate;
    procedure EndUpdate;
    property ActualActive: Boolean read GetActualActive;
    property DataSet: TADDataSet read GetDataSet;
  published
    property Active: Boolean read FActive write SetActive default False;
    property Selected: Boolean read GetSelected write SetSelected default False;
    property Name: String read FName write SetName;
    property Fields: String read FFields write SetFields;
    property CaseInsFields: String read FCaseInsFields write SetCaseInsFields;
    property DescFields: String read FDescFields write SetDescFields;
    property Expression: String read FExpression write SetExpression;
    property Options: TADSortOptions read FOptions write SetOptions default [];
    property Filter: String read FFilter write SetFilter;
    property FilterOptions: TADExpressionOptions read FFilterOptions write SetFilterOptions default [];
  end;

  TADIndexes = class(TCollection)
  private
    FDataSet: TADDataSet;
    function GetItems(AIndex: Integer): TADIndex;
    procedure SetItems(AIndex: Integer; const AValue: TADIndex);
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(ADataSet: TADDataSet);
    function Add: TADIndex;
    function FindIndex(const AName: String): TADIndex;
    function IndexByName(const AName: String): TADIndex;
    function FindIndexForFields(const AFields: String;
      ARequiredOptions: TADSortOptions = [];
      AProhibitedOptions: TADSortOptions = []): TADIndex;
    procedure Build;
    procedure Release;
    property Items[AIndex: Integer]: TADIndex read GetItems write SetItems; default;
  end;

  TADAggregate = class(TCollectionItem)
  private
    FUpdateCount: Integer;
    FExpression: String;
    FGroupingLevel: Integer;
    FIndexName: String;
    FActive: Boolean;
    FAggregate: TADDatSAggregate;
    FName: String;
    function GetActualActive: Boolean;
    function GetDataSet: TADDataSet;
    procedure SetActive(const AValue: Boolean);
    procedure SetExpression(const AValue: String);
    procedure SetGroupingLevel(const AValue: Integer);
    procedure SetIndexName(const AValue: String);
    procedure AggregateChanged;
    procedure CreateAggregate;
    procedure DeleteAggregate;
    function GetValue: Variant;
    function InternalUse(var ARecordIndex: Integer): Boolean;
    function GetInUse: Boolean;
  protected
    function GetDisplayName: String; override;
  public
    destructor Destroy; override;
    procedure Assign(ASource: TPersistent); override;
    procedure BeginUpdate;
    procedure EndUpdate;
    property ActualActive: Boolean read GetActualActive;
    property DataSet: TADDataSet read GetDataSet;
    property Value: Variant read GetValue;
    property InUse: Boolean read GetInUse;
  published
    property Name: String read FName write FName;
    property Expression: String read FExpression write SetExpression;
    property GroupingLevel: Integer read FGroupingLevel write SetGroupingLevel default 0;
    property IndexName: String read FIndexName write SetIndexName;
    property Active: Boolean read FActive write SetActive default False;
  end;

  TADAggregates = class(TCollection)
  private
    FDataSet: TADDataSet;
    FGroupingLevel: Integer;
    function GetItems(AIndex: Integer): TADAggregate;
    procedure SetItems(AIndex: Integer; const AValue: TADAggregate);
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(ADataSet: TADDataSet);
    function Add: TADAggregate;
    function FindAggregate(const AName: String): TADAggregate;
    function AggregateByName(const AName: String): TADAggregate;
    procedure Build;
    procedure Release;
    property Items[AIndex: Integer]: TADAggregate read GetItems write SetItems; default;
    property GroupingLevel: Integer read FGroupingLevel;
  end;

  TADTableUpdateOptions = class(TADUpdateOptions)
  private
    FUpdateTableName: String;
    procedure SetUpdateTableName(const AValue: String);
  public
    procedure Assign(ASource: TPersistent); override;
    procedure RestoreDefaults; override;
  published
    property UpdateTableName: String read FUpdateTableName write
      SetUpdateTableName;
  end;

  TADDataSet = class (
    {$IFNDEF AnyDAC_FPC} TDataSet {$ELSE} TDBDataSet {$ENDIF},
    {$IFNDEF AnyDAC_D6} IUnknown, {$ENDIF} IADDataSet)
  private
    FTable: TADDatSTable;
    FView: TADDatSView;
    FBufferSize: Word;
    FRecordIndex: Integer;
    FRecordIndexToInsert: Integer;
    FColumns: array of TADColMapItem;
    FNewRow: TADDatSRow;
    FForceRecBuffer: PChar;
    FIndexDefs: TIndexDefs;
    FIndexes: TADIndexes;
    FSortView: TADDatSView;
    FFilterView: TADDatSView;
    FSourceView: TADDatSView;
    FKeyBuffersAllocated: Boolean;
    FKeyBuffers: array[TADKeyIndex] of PADKeyBuffer;
    FKeyBuffer: PADKeyBuffer;
    FRangeFrom, FRangeTo: TADDatSRow;
    FRangeFromExclusive, FRangeToExclusive: Boolean;
    FRangeFromFieldCount, FRangeToFieldCount: Integer;
    FIndexName: String;
    FIndexFieldNames: String;
    FUpdateRecordTypes: TUpdateRecordTypes;
    FParentDataSet: TADDataSet;
    FConstDisableCount: Integer;
    FCloneSource: TADDataSet;
    FCachedUpdates: Boolean;
    FOnReconcileError: TADReconcileErrorEvent;
    FOnUpdateRecord: TADUpdateRecordEvent;
    FOnUpdateError: TADUpdateErrorEvent;
    FUnidirectional: Boolean;
    FUnidirRecsPurged: Integer;
    FMasterLink: TADMasterDataLink;
    FLastParentRow: TADDatSRow;
    FLockNoBMK: Boolean;
    FAfterGetParams: TADDataSetEvent;
    FAfterRowRequest: TADDataSetEvent;
    FAfterExecute: TADDataSetEvent;
    FAfterApplyUpdates: TADAfterApplyUpdatesEvent;
    FAfterGetRecords: TADDataSetEvent;
    FBeforeGetParams: TADDataSetEvent;
    FBeforeRowRequest: TADDataSetEvent;
    FBeforeExecute: TADDataSetEvent;
    FBeforeApplyUpdates: TADDataSetEvent;
    FBeforeGetRecords: TADDataSetEvent;
    FSelfOperating: Boolean;
    FClearIndexDefs: Boolean;
    FAggregatesActive: Boolean;
    FIndexesActive: Boolean;
    FAggregates: TADAggregates;
    FFieldAggregates: TADAggregates;
    FActiveAtRunTime: TADActiveAtRunTime;
    FSilentMode: Boolean;
    FDataLoadSave: Pointer;
    FCreatedConstraints: TList;
    FLocateRow: TADDatSRow;
    FLocateColumns: TADDatSColumnSublist;
    FColumnAttributesUpdated: Boolean;
    FTempIndexViews: TList;
{$IFDEF AnyDAC_FPC}
    FDataSetField: TDataSetField;
    FSparseArrays: Boolean;
    FNestedDataSets: TList;
{$ENDIF}
    procedure InitBufferPointers;
    function AddFieldDesc(ADefs: TFieldDefs; AColumn: TADDatSColumn;
        var AFieldId: Integer; APath: TList): TFieldDef;
    procedure AddTableDesc(ADefs: TFieldDefs; ATable: TADDatSTable;
      var AFieldId: Integer; APath: TList);
    procedure SetIndexName(const AValue: String);
    procedure SetIndexFieldNames(const AValue: String);
    procedure RelinkViews;
    function LocateRecord(const AKeyFields: string; const AKeyValues: Variant;
      AOptions: TLocateOptions; var AIndex: Integer): Boolean;
    function GetIndexField(AIndex: Integer): TField;
    function GetIndexFieldCount: Integer;
    procedure AllocKeyBuffers;
    procedure CheckSetKeyMode;
    procedure CheckIndexed;
    procedure FreeKeyBuffers;
    function GetKeyBuffer(AKeyIndex: TADKeyIndex; ACheckCreateRow: Boolean = True): PADKeyBuffer;
    function GetKeyExclusive: Boolean;
    function GetKeyFieldCount: Integer;
    function InitKeyBuffer(ABuffer: PADKeyBuffer): PADKeyBuffer;
    function ClearKeyBuffer(ABuffer: PADKeyBuffer): PADKeyBuffer;
    function GetKeyRow(ABuffer: PADKeyBuffer): TADDatSRow;
    procedure SetKeyRow(ABuffer: PADKeyBuffer; ARow: TADDatSRow);
    function InternalGotoKey(ANearest: Boolean): Boolean;
    procedure PostKeyBuffer(ACommit: Boolean);
    function ResetCursorRange: Boolean;
    function SetCursorRange: Boolean;
    procedure SetKeyBuffer(AKeyIndex: TADKeyIndex; AClear: Boolean);
    procedure SetKeyExclusive(AValue: Boolean);
    procedure SetKeyFieldCount(AValue: Integer);
    procedure SetKeyFields(AKeyIndex: TADKeyIndex;
      const AValues: array of const);
    procedure AssignKeyBuffer(ADest, ASrc: PADKeyBuffer);
    function CompareKeyBuffer(ABuff1, ABuff2: PADKeyBuffer): Boolean;
    procedure ResetViews;
    procedure SetSortView(AView: TADDatSView);
    procedure FilteringUpdated;
    procedure SwitchToIndex(const AFieldNames, AIndexName: String);
    procedure SetUpdateRecordTypes(const AValue: TUpdateRecordTypes);
    function DoFilterRow(AMech: TADDatSMechFilter;
      ARow: TADDatSRow; AVersion: TADDatSRowVersion): Boolean;
    procedure CheckFetchedAll;
    procedure ClearFColumns;
    function GetFieldColumn(ARecBuff: PChar; AFieldNo: Integer;
      var AColumn: TADDatSColumn; var AColumnIndex: Integer;
      var ARow: TADDatSRow; AInitNested: Boolean = False): Boolean; overload;
    procedure SetFetchOptions(const AValue: TADFetchOptions);
    procedure SetFormatOptions(const AValue: TADFormatOptions);
    procedure SetTableUpdateOptions(const AValue: TADTableUpdateOptions);
    function GetData: IADDataSet;
    function GetDelta: IADDataSet;
    procedure SetData(const AValue: IADDataSet);
    procedure SetTableConstraints;
    procedure SetInternalCalcs;
    function IsCS: Boolean;
    function GetConstraintsEnabled: Boolean;
    procedure SetConstraintsEnabled(const AValue: Boolean);
    procedure SetCachedUpdates(const AValue: Boolean);
    function GetSavePoint: Integer;
    procedure SetSavePoint(const AValue: Integer);
    function GetUpdatesPending: Boolean;
    function GetChangeCount: Integer;
    function InternalFetchRows(AAll, AOnDemand: Boolean): Boolean;
    function InternalFetchNested(ANestedTable: TADDatSTable;
      ARowOptions: TADPhysFillRowOptions): Boolean;
    procedure SetUnidirectional(const AValue: Boolean);
    function GetMasterFields: String;
    function GetMasterSource: TDataSource;
    procedure SetMasterFields(const AValue: String);
    procedure SetMasterSource(const AValue: TDataSource);
    procedure CheckDetailRecords;
    procedure CheckMasterRange;
    procedure CheckParentRow;
    procedure RealFilteringUpdated;
    function GetRanged: Boolean;
    procedure SetRanged(const AValue: Boolean);
    procedure ResetIndexes;
    procedure OpenIndexes;
    procedure SetAggregatesActive(const AValue: Boolean);
    procedure SetIndexesActive(const AValue: Boolean);
    function GetGroupingLevel: Integer;
    procedure SetAggregates(const AValue: TADAggregates);
    procedure SetIndexes(const AValue: TADIndexes);
    function GetActiveRecBufRecordIndex(var AIndex: Integer): Boolean;
    procedure SetViewAggregates;
    procedure ResetViewAggregates;
    function IsA: Boolean;
    function IsIS: Boolean;
    function GetFilteredData: IADDataSet;
    procedure RenewColumnMap;
    procedure RenewFieldDesc(AColumn: TADDatSColumn; var AFieldId: Integer);
    procedure RenewTableDesc(ATable: TADDatSTable; var AFieldId: Integer);
    function CreateChildMech: TADDatSMechChilds;
    function CreateFilterMech: TADDatSMechFilter;
    function CreateRangeMech: TADDatSMechRange;
    function CreateStateMech: TADDatSMechRowState;
    procedure ResetTableConstraints;
    procedure SetResourceOptions(const AValue: TADResourceOptions);
    function IsIDS: Boolean;
    procedure SetIndexDefs(const AValue: TIndexDefs);
    procedure UpdateRecordIndex;
    procedure SetParams(const AValue: TADParams);
    function GetParamsCount: Word;
  protected
    // IProviderSupport
    procedure PSExecute; {$IFNDEF AnyDAC_FPC} override; {$ENDIF}
    function PSGetDefaultOrder: TIndexDef; {$IFNDEF AnyDAC_FPC} override; {$ENDIF}
    function PSGetKeyFields: string; {$IFNDEF AnyDAC_FPC} override; {$ENDIF}
    function PSGetTableName: string; {$IFNDEF AnyDAC_FPC} override; {$ENDIF}
    function PSGetIndexDefs(IndexTypes: TIndexOptions = [ixPrimary..ixNonMaintained]): TIndexDefs; {$IFNDEF AnyDAC_FPC} override; {$ENDIF}
    function PSGetUpdateException(E: Exception; Prev: EUpdateError): EUpdateError; {$IFNDEF AnyDAC_FPC} override; {$ENDIF}
    procedure PSReset; {$IFNDEF AnyDAC_FPC} override; {$ENDIF}
    function PSUpdateRecord(AUpdateKind: TUpdateKind; ADelta: TDataSet): Boolean; {$IFNDEF AnyDAC_FPC} override; {$ENDIF}
    // IADDataSet
    function GetDataView: TADDatSView;
  protected
    FAutoCommitUpdates: Boolean;
    FRecordCount: Integer;
    FSourceEOF: Boolean;
{$IFDEF AnyDAC_FPC}
    FInInternalOpen: Boolean;
{$ENDIF}
    function AllocRecordBuffer: PChar; override;
    procedure CheckDeleting;
    procedure CheckEditing;
    procedure CheckInserting;
    procedure CreateFilterView; virtual;
    procedure ClearCalcFields(Buffer: PChar); override;
    procedure CloseBlob(Field: TField); override;
{$IFNDEF AnyDAC_FPC}
    procedure DataConvert(Field: TField; Source, Dest: Pointer; ToNative: Boolean); override;
{$ENDIF}
    procedure DataEvent(Event: TDataEvent; Info: Integer); override;
    procedure DoBeforeInsert; override;
    procedure DoBeforeEdit; override;
    procedure DoBeforeDelete; override;
    procedure FreeRecordBuffer(var Buffer: PChar); override;
    function GetActiveRecBuf(var RecBuf: PChar): Boolean;
    procedure GetBookmarkData(Buffer: PChar; Data: Pointer); override;
    function GetBookmarkFlag(Buffer: PChar): TBookmarkFlag; override;
    function GetRecIndex: Integer;
    function GetRecNo: Integer; override;
    function GetRecord(Buffer: PChar; GetMode: TGetMode;
      DoCheck: Boolean): TGetResult; override;
    function GetRecordCount: Integer; override;
    function GetRecordSize: Word; override;
    procedure InitRecord(Buffer: PChar); override;
    procedure InternalHandleException; override;
    procedure InternalInitFieldDefs; override;
    procedure InternalOpen; override;
    procedure DoAfterOpen; override;
    procedure InternalClose; override;
    procedure InternalAddRecord(Buffer: Pointer; Append: Boolean); override;
    procedure InternalCancel; override;
    procedure InternalDelete; override;
    procedure InternalEdit; override;
    procedure InternalFirst; override;
    procedure InternalGotoBookmark(Bookmark: TBookmark); override;
    procedure InternalInitRecord(Buffer: PChar); override;
    procedure InternalInsert; override;
    procedure InternalLast; override;
    procedure InternalPost; override;
    procedure InternalRefresh; override;
    procedure InternalSetToRecord(Buffer: PChar); override;
    function IsCursorOpen: Boolean; override;
    procedure Loaded; override;
    procedure OpenCursor(InfoQuery: Boolean); override;
    function RowState2UpdateStatus(ARowState: TADDatSRowState): TUpdateStatus;
    procedure SetActive(AValue: Boolean); override;
    procedure SetBookmarkData(Buffer: PChar; Data: Pointer); override;
    procedure SetBookmarkFlag(Buffer: PChar; AValue: TBookmarkFlag); override;
    procedure SetFieldData(Field: TField; Buffer: Pointer); override;
    procedure InternalSetRecNo(AValue: Integer);
    procedure SetRecNo(AValue: Integer); override;
    procedure SetFilterOptions(AValue: TFilterOptions); override;
    procedure SetFilterText(const AValue: string); override;
    procedure SetFiltered(AValue: Boolean); override;
    procedure SetOnFilterRecord(const AValue: TFilterRecordEvent); override;
    function FindRecord(Restart, GoForward: Boolean): Boolean; override;
    function GetDataSource: TDataSource; override;
    procedure UpdateIndexDefs; override;
    function GetIsIndexField(AField: TField): Boolean; override;
{$IFNDEF AnyDAC_FPC}
    procedure ResetAggField(AField: TField); override;
    function GetAggregateValue(AField: TField): Variant; override;
{$ENDIF}
    function GetFieldClass(FieldType: TFieldType): TFieldClass; override;
    // introduced
    procedure MasterDisabled(Sender: TObject); virtual;
    procedure MasterChanged(Sender: TObject); virtual;
    procedure MasterDefined(Sender: TObject); virtual;
    procedure BeginForceRow(ARow: TADDatSRow; AReadWrite, AWithCalcFields: Boolean);
    procedure CheckCachedUpdatesMode; virtual;
    function DoApplyUpdates(ATable: TADDatSTable; AMaxErrors: Integer): Integer; virtual;
    function DoFetch(ATable: TADDatSTable; AAll: Boolean): Integer; overload; virtual;
    function DoFetch(ARow: TADDatSRow; AColumn: Integer;
      ARowOptions: TADPhysFillRowOptions): Boolean; overload; virtual;
    procedure DoMasterDefined; virtual;
    procedure DoMasterReset; virtual;
    procedure DoMasterSetValues(AMasterFieldList: TList); virtual;
    function DoMasterDependent(AMasterFieldList: TList): Boolean; virtual;
    procedure DoSortOrderChanged; virtual;
    procedure DoDefineDatSManager; virtual;
    procedure DoResetDatSManager; virtual;
    procedure DoPrepareSource; virtual;
    procedure DoUnprepareSource; virtual;
    procedure DoOpenSource(AAsyncQuery, AInfoQuery, AStructQuery: Boolean); virtual;
    function DoIsSourceOpen: Boolean; virtual;
    function DoIsSourceAsync: Boolean; virtual;
    procedure DoCloseSource; virtual;
    function DoGetDatSManager: TADDatSManager; virtual;
    procedure DoProcessUpdateRequest(ARequest: TADPhysUpdateRequest;
      AOptions: TADPhysUpdateRowOptions); virtual;
    procedure DoExecuteSource(ATimes, AOffset: Integer); virtual;
    procedure DoUpdateErrorHandler(ARow: TADDatSRow; AException: Exception;
      ARequest: TADPhysUpdateRequest; var AAction: TADErrorAction); virtual;
    procedure DoUpdateRecordHandler(ARow: TADDatSRow; ARequest: TADPhysUpdateRequest;
      AOptions: TADPhysUpdateRowOptions; var AAction: TADErrorAction); virtual;
    procedure DoReconcileErrorHandler(ARow: TADDatSRow; AException: EADException;
      AUpdateKind: TADDatSRowState; var AAction: TADDAptReconcileAction); virtual;
    procedure DoGetParams; virtual;
    procedure DoCloneCursor(AReset, AKeepSettings: Boolean); virtual;
    procedure DoCreateDataSet; virtual;
    procedure InitColumnsFromFieldDefs(ADefs: TFieldDefs; ATable: TADDatSTable;
      ADatSManager: TADDatSManager);
    procedure DoAfterApplyUpdate(AErrors: Integer); virtual;
    procedure ApplyUpdatesComplete(AErrors: Integer);
    procedure DoBeforeApplyUpdate; virtual;
    procedure DoBeforeGetRecords; virtual;
    procedure DoAfterGetRecords; virtual;
    procedure DoBeforeRowRequest; virtual;
    procedure DoAfterRowRequest; virtual;
    procedure DoBeforeExecute; virtual;
    procedure DoAfterExecute; virtual;
    procedure DoBeforeGetParams; virtual;
    procedure DoAfterGetParams; virtual;
    procedure EndForceRow;
    function GetRowVersion: TADDatSRowVersion;
    function GetFetchOptions: TADFetchOptions; virtual; abstract;
    function GetFormatOptions: TADFormatOptions; virtual; abstract;
    function GetUpdateOptions: TADUpdateOptions; virtual; abstract;
    function GetResourceOptions: TADResourceOptions; virtual; abstract;
    function GetTableUpdateOptions: TADTableUpdateOptions;
    function IsForceRowMode: Boolean;
    function GetUpdates: TADDatSUpdatesJournal; virtual;
    function BuildViewForIndex(AIndex: TADIndex): TADDatSView;
    function GetParams: TADParams; virtual;
    procedure SetColumnAttributes;
    procedure StartWait;
    procedure StopWait;
    procedure UpdateRecordCount; virtual;
    property MasterLink: TADMasterDataLink read FMasterLink;
    property Updates: TADDatSUpdatesJournal read GetUpdates;
    property Params: TADParams read GetParams write SetParams stored False;
    property ParamCount: Word read GetParamsCount;
    property FormatOptions: TADFormatOptions read GetFormatOptions write SetFormatOptions;
    property FetchOptions: TADFetchOptions read GetFetchOptions write SetFetchOptions;
    property UpdateOptions: TADTableUpdateOptions read GetTableUpdateOptions write SetTableUpdateOptions;
    property ResourceOptions: TADResourceOptions read GetResourceOptions write SetResourceOptions;
{$IFDEF AnyDAC_FPC}
    property DataSetField: TDataSetField read FDataSetField;
    property SparseArrays: Boolean read FSparseArrays;
    property NestedDataSets: TList read FNestedDataSets;
{$ENDIF}
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddIndex(const AName, AFields, AExpression: string; AOptions: TADSortOptions;
      const ADescFields: string = ''; const ACaseInsFields: string = '');
    procedure ApplyRange;
    function ApplyUpdates(AMaxErrors: Integer = -1): Integer;
    procedure AttachTable(ATable: TADDatSTable; AView: TADDatSView);
    procedure BeginBatch(AWithDelete: Boolean = False);
    procedure EndBatch;
    function BookmarkValid(Bookmark: TBookmark): Boolean; override;
    procedure Cancel; override;
    procedure CancelRange;
    procedure CancelUpdates;
    procedure CloneCursor(ASource: TADDataSet; AReset: Boolean;
      AKeepSettings: Boolean = False); virtual;
    procedure CommitUpdates;
    function CompareBookmarks(Bookmark1, Bookmark2: TBookmark): Integer; override;
    procedure CopyFields(ASource: TDataset; AExcludeNewEmptyValues: Boolean = True);
    procedure CreateDataSet;
    function CreateBlobStream(Field: TField; Mode: TBlobStreamMode): TStream; override;
    function CreateExpression(const AExpr: String;
      AOptions: TADExpressionOptions = []): IADStanExpressionEvaluator;
    procedure DeleteIndex(const AName: string);
    procedure DeleteIndexes;
    procedure DisableConstraints;
    procedure Disconnect(AAbortJob: Boolean = False); virtual;
    procedure EditKey;
    procedure EditRangeEnd;
    procedure EditRangeStart;
    procedure EmptyDataSet;
    procedure EnableConstraints;
    procedure Execute(ATimes: Integer = 0; AOffset: Integer = 0);
    procedure FetchAll;
    procedure FetchBlobs;
    procedure FetchDetails(ADataSetField: TDataSetField = nil);
    procedure FetchParams;
    function FindKey(const AKeyValues: array of const): Boolean;
    procedure FindNearest(const AKeyValues: array of const);
    function FindParam(const AValue: string): TADParam;
    function GetCurrentRecord(Buffer: PChar): Boolean; override;
    procedure GetDetailLinkFields(AMasterFields, ADetailFields: TList); {$IFNDEF AnyDAC_FPC} override; {$ENDIF}
    function GetColumnField(AColumn: TADDatSColumn): TField;
    function GetFieldColumn(AField: TField): TADDatSColumn; overload;
    function GetFieldData(FieldNo: Integer; Buffer: Pointer): Boolean; overload; {$IFNDEF AnyDAC_FPC} override; {$ENDIF}
    function GetFieldData(Field: TField; Buffer: Pointer): Boolean; overload; override;
    function GetGroupState(ALevel: Integer): TGroupPosInds;
    procedure GetIndexNames(AList: TStrings);
    function GetNextPacket: Integer;
    function GetRow(ABuffer: PChar = nil; AForceBufferRead: Boolean = False): TADDatSRow;
    function GetParentRow: TADDatSRow;
    procedure GotoCurrent(ADataSet: TADDataSet);
    function GotoKey: Boolean;
    procedure GotoNearest;
    function IsLinked: Boolean;
    function IsSequenced: Boolean; override;
    function Locate(const AKeyFields: string; const AKeyValues: Variant;
      AOptions: TLocateOptions): Boolean; override;
    function Lookup(const AKeyFields: string; const AKeyValues: Variant;
      const AResultFields: string): Variant; override;
    function ParamByName(const AValue: string): TADParam;
    procedure Post; override;
    function Reconcile: Boolean;
    procedure RefreshRecord;
    procedure RevertRecord;
    procedure SetFieldAttributes(AField: TField; AColumn: TADDatSColumn;
      ASkeepAutoInc: Boolean); overload;
    procedure SetFieldAttributes(AFields: TFields); overload;
    procedure SetFieldAttributes; overload;
{$IFNDEF AnyDAC_FPC}
    procedure SetFieldAutoGenerateValue(AField: TField; AValue: TAutoRefreshFlag);
{$ENDIF}
    procedure SetRangeEnd;
    procedure SetRangeStart;
    procedure SetRange(const AStartValues, AEndValues: array of const);
    procedure SetKey;
    function UndoLastChange(AFollowChange: Boolean): Boolean;
    function UpdateStatus: TUpdateStatus; override;

    property ActiveAtRunTime: TADActiveAtRunTime read FActiveAtRunTime write FActiveAtRunTime default arStandard;
    property Aggregates: TADAggregates read FAggregates write SetAggregates stored IsA;
    property AggregatesActive: Boolean read FAggregatesActive write SetAggregatesActive default False;
    property CachedUpdates: Boolean read FCachedUpdates write SetCachedUpdates default False;
    property ChangeCount: Integer read GetChangeCount;
    property CloneSource: TADDataSet read FCloneSource;
    property Constraints stored IsCS;
    property ConstraintsEnabled: Boolean read GetConstraintsEnabled
      write SetConstraintsEnabled default True;
    property Data: IADDataSet read GetData write SetData;
    property DatSManager: TADDatSManager read DoGetDatSManager;
    property Delta: IADDataSet read GetDelta;
    property FilteredData: IADDataSet read GetFilteredData;
    property GroupingLevel: Integer read GetGroupingLevel;
    property UpdatesPending: Boolean read GetUpdatesPending;
    property IndexDefs: TIndexDefs read FIndexDefs write SetIndexDefs stored IsIDS;
    property Indexes: TADIndexes read FIndexes write SetIndexes stored IsIS;
    property IndexesActive: Boolean read FIndexesActive write SetIndexesActive default True;
    property IndexName: String read FIndexName write SetIndexName;
    property IndexFieldNames: String read FIndexFieldNames write SetIndexFieldNames;
    property IndexFields[AIndex: Integer]: TField read GetIndexField;
    property IndexFieldCount: Integer read GetIndexFieldCount;
    property KeyExclusive: Boolean read GetKeyExclusive write SetKeyExclusive;
    property KeyFieldCount: Integer read GetKeyFieldCount write SetKeyFieldCount;
    property MasterSource: TDataSource read GetMasterSource write SetMasterSource;
    property MasterFields: String read GetMasterFields write SetMasterFields;
    property ParentDataSet: TADDataSet read FParentDataSet;
    property Ranged: Boolean read GetRanged write SetRanged default True;
    property SavePoint: Integer read GetSavePoint write SetSavePoint;
    property SilentMode: Boolean read FSilentMode write FSilentMode default False;
    property SourceEOF: Boolean read FSourceEOF;
    property SourceView: TADDatSView read FSourceView;
    property UpdateRecordTypes: TUpdateRecordTypes read FUpdateRecordTypes write SetUpdateRecordTypes
      default [rtUnmodified, rtModified, rtInserted];
    property Table: TADDatSTable read FTable;
    property Unidirectional: Boolean read FUnidirectional write SetUnidirectional default False;
    property View: TADDatSView read FView;

    property AfterApplyUpdates: TADAfterApplyUpdatesEvent read FAfterApplyUpdates write FAfterApplyUpdates;
    property AfterExecute: TADDataSetEvent read FAfterExecute write FAfterExecute;
    property AfterGetParams: TADDataSetEvent read FAfterGetParams write FAfterGetParams;
    property AfterGetRecords: TADDataSetEvent read FAfterGetRecords write FAfterGetRecords;
    property AfterRowRequest: TADDataSetEvent read FAfterRowRequest write FAfterRowRequest;
    property BeforeApplyUpdates: TADDataSetEvent read FBeforeApplyUpdates write FBeforeApplyUpdates;
    property BeforeExecute: TADDataSetEvent read FBeforeExecute write FBeforeExecute;
    property BeforeGetParams: TADDataSetEvent read FBeforeGetParams write FBeforeGetParams;
    property BeforeGetRecords: TADDataSetEvent read FBeforeGetRecords write FBeforeGetRecords;
    property BeforeRowRequest: TADDataSetEvent read FBeforeRowRequest write FBeforeRowRequest;
    property OnReconcileError: TADReconcileErrorEvent read FOnReconcileError
      write FOnReconcileError;
    property OnUpdateRecord: TADUpdateRecordEvent read FOnUpdateRecord
      write FOnUpdateRecord;
    property OnUpdateError: TADUpdateErrorEvent read FOnUpdateError
      write FOnUpdateError;

{
    procedure LoadFromFile(const FileName: string = '');
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToFile(const FileName: string = ''; Format: TDataPacketFormat = dfBinary);
    procedure SaveToStream(Stream: TStream; Format: TDataPacketFormat = dfBinary);

    property FileName: string read FFileName write SetFileName;
}
  end;

  TADWideMemoField = class(TBlobField)
  private
    function GetAsWideString: WideString;
    procedure SetAsWideString(const AValue: WideString);
  protected
    function GetClassDesc: string; {$IFNDEF AnyDAC_FPC} override; {$ENDIF}
    function GetAsString: String; override;
    procedure SetAsString(const AValue: String); override;
    function GetAsVariant: Variant; override;
    procedure SetVarValue(const AValue: Variant); override;
  public
    constructor Create(AOwner: TComponent); override;
    property Value: WideString read GetAsWideString write SetAsWideString;
  end;

  TADAutoIncField = class(TAutoIncField)
  private
    FAutoIncrementSeed: Integer;
    FAutoIncrementStep: Integer;
    FClientAutoIncrement: Boolean;
    FServerAutoIncrement: Boolean;
    procedure SetAutoIncrementSeed(const AValue: Integer);
    procedure SetAutoIncrementStep(const AValue: Integer);
    procedure SetClientAutoIncrement(const AValue: Boolean);
    procedure SetServerAutoIncrement(const AValue: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
  published
{$IFNDEF AnyDAC_FPC}
    property AutoGenerateValue default DB.arAutoInc;
{$ENDIF}
    property ReadOnly default True;
    property ProviderFlags default [pfInWhere];
    property ClientAutoIncrement: Boolean read FClientAutoIncrement
      write SetClientAutoIncrement default True;
    property ServerAutoIncrement: Boolean read FServerAutoIncrement
      write SetServerAutoIncrement default True;
    property AutoIncrementSeed: Integer read FAutoIncrementSeed write
      SetAutoIncrementSeed default -1;
    property AutoIncrementStep: Integer read FAutoIncrementStep write
      SetAutoIncrementStep default -1;
  end;

  TADBlobStream = class(TMemoryStream)
  private
    FField: TBlobField;
    FDataSet: TADDataSet;
    FBuffer: PChar;
    FModified: Boolean;
    FMode: TBlobStreamMode;
    procedure ReadBlobData;
    procedure CheckWrite;
  protected
    function Realloc(var ANewCapacity: Integer): Pointer; override;
  public
    constructor Create(AField: TBlobField; AMode: TBlobStreamMode);
    destructor Destroy; override;
    procedure Truncate;
    function Write(const ABuffer; ACount: Longint): Longint; override;
  end;

implementation

uses
  Windows, Math,
{$IFNDEF AnyDAC_FPC}
  DBConsts,
{$ENDIF}
{$IFDEF AnyDAC_D6Base}
  Variants,
  {$IFDEF AnyDAC_D6}
  FmtBcd, SqlTimSt,
  {$ENDIF}
{$ELSE}
  ActiveX, ComObj,
{$ENDIF}  
  daADStanUtil, daADStanConst, daADStanFactory,
  daADGUIxIntf;

{$IFDEF AnyDAC_FPC}
const
  SNotEditing = 'Dataset not in edit or insert mode';
  SFieldReadOnly = 'Field ''%s'' cannot be modified';
  SNotIndexField = 'Field ''%s'' is not indexed and cannot be modified';
  SNoFieldIndexes = 'No index currently active';
{$ENDIF}

{-------------------------------------------------------------------------------}
{ TADTableUpdateOptions                                                         }
{-------------------------------------------------------------------------------}
procedure TADTableUpdateOptions.Assign(ASource: TPersistent);
begin
  inherited Assign(ASource);
  if ASource is TADTableUpdateOptions then
    UpdateTableName := TADTableUpdateOptions(ASource).UpdateTableName
end;

{-------------------------------------------------------------------------------}
procedure TADTableUpdateOptions.RestoreDefaults;
begin
  inherited RestoreDefaults;
  FUpdateTableName := '';
end;

{-------------------------------------------------------------------------------}
procedure TADTableUpdateOptions.SetUpdateTableName(const AValue: String);
begin
  FUpdateTableName := AValue;
end;

{-------------------------------------------------------------------------------}
{ TADMasterDataLink                                                             }
{-------------------------------------------------------------------------------}
procedure TADMasterDataLink.ActiveChanged;
begin
  if FActiveChangedLocked then
    Exit;
  if (DataSet <> nil) and Active then
    if Assigned(FOnMasterFieldsDefined) then
      try
        FActiveChangedLocked := True;
        FOnMasterFieldsDefined(Self);
      finally
        FActiveChangedLocked := False;
      end;
  inherited ActiveChanged;
end;

{$IFDEF AnyDAC_D7}
{-------------------------------------------------------------------------------}
procedure TADMasterDataLink.DataEvent(Event: TDataEvent; Info: Integer);
begin
  if (Event = deDataSetChange) and FFireActiveChanged then
    try
      ActiveChanged;
    finally
      FFireActiveChanged := False;
    end;
  inherited DataEvent(Event, Info);
  if Event = deDisabledStateChange then
    FFireActiveChanged := True;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
{ TADDatSTableCallback                                                          }
{-------------------------------------------------------------------------------}
type
  TADDatSTableCallback = class(TInterfacedObject, IADDataTableCallback)
  private
    FDataSet: TADDataSet;
  protected
    // IADDataTableCallbackGS
    procedure DescribeColumn(AColumn: TADDatSColumn;
      var AOptions: TADDataOptions);
  public
    constructor Create(ADataSet: TADDataSet);
  end;

{-------------------------------------------------------------------------------}
constructor TADDatSTableCallback.Create(ADataSet: TADDataSet);
begin
  inherited Create;
  FDataSet := ADataSet;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTableCallback.DescribeColumn(AColumn: TADDatSColumn;
  var AOptions: TADDataOptions);
var
  oFld: TField;
begin
  oFld := FDataSet.GetColumnField(AColumn);
  if oFld <> nil then begin
    if oFld.Required then
      Exclude(AOptions, coAllowNull)
    else
      Include(AOptions, coAllowNull);
    if oFld.ReadOnly then
      Include(AOptions, coReadOnly)
    else
      Exclude(AOptions, coReadOnly);
  end;
end;

{-------------------------------------------------------------------------------}
{ TADDataSet                                                                    }
{-------------------------------------------------------------------------------}
constructor TADDataSet.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FIndexes := TADIndexes.Create(Self);
  FIndexesActive := True;
  FAggregates := TADAggregates.Create(Self);
  FFieldAggregates := TADAggregates.Create(Self);
  FAggregatesActive := False;
  FIndexDefs := TIndexDefs.Create(Self);
  FUpdateRecordTypes := [rtUnmodified, rtModified, rtInserted];
{$IFNDEF AnyDAC_FPC}
  ObjectView := True;
{$ENDIF}
  FSourceEOF := True;
  FMasterLink := TADMasterDataLink.Create(Self);
  FMasterLink.OnMasterChange := MasterChanged;
  FMasterLink.OnMasterDisable := MasterDisabled;
  FMasterLink.OnMasterFieldsDefined := MasterDefined;
  FActiveAtRunTime := arStandard;
  FAutoCommitUpdates := True;
  FCreatedConstraints := TList.Create;
  FTempIndexViews := TList.Create;
  FRecordCount := -1;
end;

{-------------------------------------------------------------------------------}
destructor TADDataSet.Destroy;
begin
  AttachTable(nil, nil);
  FreeAndNil(FIndexDefs);
  FreeAndNil(FAggregates);
  FreeAndNil(FFieldAggregates);
  FreeAndNil(FIndexes);
  ClearFColumns;
  SetLength(FColumns, 0);
  FreeAndNil(FMasterLink);
  FreeAndNil(FCreatedConstraints);
  FreeAndNil(FTempIndexViews);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.DoGetDatSManager: TADDatSManager;
begin
  Result := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.AttachTable(ATable: TADDatSTable;
  AView: TADDatSView);
begin
  Close;
  if FTable <> ATable then begin
    if FTable <> nil then
      FTable.RemRef;
    FTable := ATable;
    if FTable <> nil then
      FTable.AddRef;
  end;
  if FView <> AView then begin
    if FView <> nil then
      FView.RemRef;
    FView := AView;
    if FView <> nil then
      FView.AddRef;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.InternalHandleException;
var
  oWait: IADGUIxWaitCursor;
begin
  ADCreateInterface(IADGUIxWaitCursor, oWait);
  oWait.PopWait;
  try
    ADHandleException;
  finally
    oWait.PushWait;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DataEvent(Event: TDataEvent; Info: Integer);
begin
  if Event = deParentScroll then
    MasterChanged(Self);
  inherited DataEvent(Event, Info);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetFetchOptions(const AValue: TADFetchOptions);
begin
  FetchOptions.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetFormatOptions(const AValue: TADFormatOptions);
begin
  FormatOptions.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetTableUpdateOptions: TADTableUpdateOptions;
begin
  Result := GetUpdateOptions as TADTableUpdateOptions;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetTableUpdateOptions(const AValue: TADTableUpdateOptions);
begin
  UpdateOptions.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetResourceOptions(const AValue: TADResourceOptions);
begin
  ResourceOptions.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.IsSequenced: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetActive(AValue: Boolean);
begin
  if not (csReading in ComponentState) or (csDesigning in ComponentState) or
     (FActiveAtRunTime = arStandard) then
    inherited SetActive(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.Loaded;
begin
  inherited Loaded;
  if FActiveAtRunTime = arActive then
    inherited SetActive(True);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.StartWait;
var
  oWait: IADGUIxWaitCursor;
begin
  if not FSilentMode then begin
    ADCreateInterface(IADGUIxWaitCursor, oWait);
    oWait.StartWait;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.StopWait;
var
  oWait: IADGUIxWaitCursor;
begin
  if not FSilentMode then begin
    ADCreateInterface(IADGUIxWaitCursor, oWait);
    oWait.StopWait;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetParams: TADParams;
begin
  // nothing
  Result := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetParams(const AValue: TADParams);
begin
  GetParams.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.FindParam(const AValue: string): TADParam;
begin
  Result := Params.FindParam(AValue);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.ParamByName(const AValue: string): TADParam;
begin
  Result := Params.ParamByName(AValue);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetParamsCount: Word;
begin
  Result := Word(Params.Count);
end;

{-------------------------------------------------------------------------------}
{ Master/detail }

function TADDataSet.GetMasterFields: String;
begin
  Result := FMasterLink.FieldNames;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetMasterFields(const AValue: String);
begin
  FMasterLink.FieldNames := AValue;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetMasterSource: TDataSource;
begin
  Result := FMasterLink.DataSource;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetMasterSource(const AValue: TDataSource);
begin
  if (AValue <> nil) and (DataSetField <> nil) then
    ADException(Self, [S_AD_LComp, S_AD_LComp_PDS], er_AD_DSNoNestedMasterSource, []);
  if IsLinkedTo(AValue) then
    ADException(Self, [S_AD_LComp, S_AD_LComp_PDS], er_AD_DSCircularDataLink, []);
  if FMasterLink.DataSource <> nil then
    FMasterLink.DataSource.RemoveFreeNotification(Self);
  FMasterLink.DataSource := AValue;
  if FMasterLink.DataSource <> nil then
    FMasterLink.DataSource.FreeNotification(Self);
  DoMasterDefined;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetDataSource: TDataSource;
begin
  Result := FMasterLink.DataSource;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.GetDetailLinkFields(AMasterFields, ADetailFields: TList);

  function AddFieldToList(const AFieldName: string; ADataSet: TDataSet;
    AList: TList): Boolean;
  var
    oField: TField;
  begin
    oField := ADataSet.FindField(AFieldName);
    if oField <> nil then
      AList.Add(oField);
    Result := oField <> nil;
  end;

var
  oIdx: TADIndex;
  i: Integer;
begin
  AMasterFields.Clear;
  ADetailFields.Clear;
  DoMasterDefined;
  if (MasterSource <> nil) and (MasterSource.DataSet <> nil) then begin
    if fiDetails in FetchOptions.Cache then begin
      if MasterFields <> '' then begin
        MasterSource.DataSet.GetFieldList(AMasterFields, MasterFields);
        if IndexName <> '' then
          oIdx := Indexes.FindIndex(IndexName)
        else if IndexFieldNames <> '' then
          oIdx := Indexes.FindIndexForFields(IndexFieldNames, [], [])
        else
          Exit;
        if oIdx <> nil then
          GetFieldList(ADetailFields, oIdx.Fields);
      end;
    end;
  end
  else if Params <> nil then begin
    for i := 0 to Params.Count - 1 do
      if AddFieldToList(Params[i].Name, DataSource.DataSet, AMasterFields) then
        AddFieldToList(Params[i].Name, Self, ADetailFields);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoMasterDefined;
var
  s: String;
  i: Integer;
  oParam: TADParam;
  oField: TField;
begin
  if (MasterFields = '') and (MasterSource <> nil) and
     (MasterSource.DataSet <> nil) and (Params <> nil) then begin
    s := '';
    for i := 0 to MasterSource.DataSet.FieldCount - 1 do begin
      oField := MasterSource.DataSet.Fields[i];
      oParam := Params.FindParam(oField.FieldName);
      if oParam <> nil then begin
        if s <> '' then
          s := s + ';';
        s := s + oField.FieldName;
        if oParam.DataType = ftUnknown then
          oParam.AssignFieldValue(oField, Null);
      end;
    end;
    if s <> '' then
      MasterFields := s;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.MasterDefined(Sender: TObject);
begin
  DoMasterDefined;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoMasterSetValues(AMasterFieldList: TList);
var
  i: Integer;
  oParam: TADParam;
  oField: TField;
begin
  if Params <> nil then
    for i := 0 to AMasterFieldList.Count - 1 do begin
      oField := TField(AMasterFieldList[i]);
      oParam := Params.FindParam(oField.FieldName);
      if oParam <> nil then
        oParam.AssignField(oField);
    end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.DoMasterDependent(AMasterFieldList: TList): Boolean;
var
  i: Integer;
  oParam: TADParam;
  oField: TField;
begin
  Result := False;
  if Params <> nil then
    for i := 0 to AMasterFieldList.Count - 1 do begin
      oField := TField(AMasterFieldList[i]);
      oParam := Params.FindParam(oField.FieldName);
      if oParam <> nil then begin
        Result := True;
        Break;
      end;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoMasterReset;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.MasterDisabled(Sender: TObject);
begin
  if fiDetails in FetchOptions.Cache then
    CancelRange;
  DoMasterReset;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.CheckDetailRecords;

  procedure FetchDetails(AAll: Boolean);
  begin
    if DoMasterDependent(FMasterLink.Fields) then begin
      DoCloseSource;
      DoMasterSetValues(FMasterLink.Fields);
      FSourceEOF := False;
      FUnidirRecsPurged := 0;
      DoOpenSource(False, False, (FTable = nil) or (FTable.Columns.Count = 0));
      InternalFetchRows(AAll, False);
    end;
  end;

begin
  if DataSetField = nil then begin
    if not MasterSource.DataSet.IsEmpty and
       not (MasterSource.DataSet.State in [dsInsert, dsSetKey]) then begin
      if fiDetails in FetchOptions.Cache then begin
        if not Active or (RecordCount = 0) then
          FetchDetails(True);
      end
      else if not DoIsSourceOpen or Active then
        FetchDetails(False);
    end;
    if Active then
      First;
  end
  else begin
    if FetchOptions.Mode in [fmOnDemand, fmAll, fmExactRecsMax] then
      FParentDataSet.FetchDetails;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.CheckMasterRange;
var
  i: Integer;
  iSaveState: TDataSetState;
  oDestFld, oSrcFld: TField;
begin
  if FMasterLink.Active and (FMasterLink.Fields.Count > 0) then begin
    if IndexFieldCount = 0 then
      FetchOptions.Cache := FetchOptions.Cache - [fiDetails];
    if fiDetails in FetchOptions.Cache then begin
      iSaveState := SetTempState(dsSetKey);
      try
        FKeyBuffer := ClearKeyBuffer(GetKeyBuffer(kiRangeStart));
        for i := 0 to FMasterLink.Fields.Count - 1 do begin
          oDestFld := GetIndexField(i);
          oSrcFld := TField(FMasterLink.Fields[i]);
{$IFDEF AnyDAC_D6Base}
          if oDestFld is TLargeintField then
            TLargeintField(oDestFld).Value := oSrcFld.Value
          else
{$ENDIF}
            oDestFld.Assign(oSrcFld);
        end;
        FKeyBuffer^.FieldCount := FMasterLink.Fields.Count;
        FKeyBuffer^.Modified := True;
      finally
        RestoreState(iSaveState);
      end;
      AssignKeyBuffer(FKeyBuffers[kiRangeEnd], FKeyBuffers[kiRangeStart]);
      if SetCursorRange then begin
        CreateFilterView;
        RelinkViews;
      end;
    end
    else
      FTable.Clear;
    if FetchOptions.Mode in [fmOnDemand, fmAll, fmExactRecsMax] then
      CheckDetailRecords;
  end
  else begin
    if fiDetails in FetchOptions.Cache then
      CancelRange;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.CheckParentRow;
begin
  if not Active then
    Exit;
  if GetParentRow <> FLastParentRow then begin
    if FetchOptions.Mode in [fmOnDemand, fmAll, fmExactRecsMax] then
      CheckDetailRecords;
    FilteringUpdated;
    First;
  end
  else begin
    UpdateCursorPos;
    Resync([]);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.MasterChanged(Sender: TObject);
begin
  if MasterSource <> nil then
    CheckMasterRange
  else if DataSetField <> nil then
    CheckParentRow;
end;

{-------------------------------------------------------------------------------}
{ Views management }

procedure TADDataSet.ResetViews;
//var
//  i: Integer;
begin
  if FSourceView <> nil then begin
    FSourceView.RemRef;
    FSourceView := nil;
  end;
  if FFilterView <> nil then begin
    FFilterView.RemRef;
    FFilterView := nil;
  end;
  if FSortView <> nil then begin
    FSortView.RemRef;
    FSortView := nil;
  end;
// ???????  
//  if FTable <> nil then
//    for i := FTable.Views.Count - 1 downto 0 do
//      if FTable.Views.ItemsI[i].Creator in [vcDataSetIndex, vcDataSetTempIndex,
//                                            vcDataSetFilter, vcDefaultView] then
//        FTable.Views.ItemsI[i].RemRef;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.CreateFilterMech: TADDatSMechFilter;
var
  expOpts: TADExpressionOptions;
  evt: TADFilterRowEvent;
begin
  expOpts := [];
  if foCaseInsensitive in FilterOptions then
    Include(expOpts, ekNoCase);
  if not (foNoPartialCompare in FilterOptions) then
    Include(expOpts, ekPartial);
  if Assigned(OnFilterRecord) then
    evt := DoFilterRow
  else
    evt := nil;
  Result := TADDatSMechFilter.Create(Filter, expOpts, evt);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.CreateChildMech: TADDatSMechChilds;
begin
  Result := TADDatSMechChilds.Create(GetParentRow);
  FLastParentRow := Result.ParentRow;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.CreateRangeMech: TADDatSMechRange;
begin
  Result := TADDatSMechRange.Create;
  Result.Bottom := FRangeFrom;
  Result.BottomExclusive := FRangeFromExclusive;
  Result.BottomColumnCount := FRangeFromFieldCount;
  Result.Top := FRangeTo;
  Result.TopExclusive := FRangeToExclusive;
  Result.TopColumnCount := FRangeToFieldCount;
  Result.Active := True;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.CreateStateMech: TADDatSMechRowState;
var
  rowStates: TADDatSRowStates;
begin
  rowStates := [];
  if rtModified in FUpdateRecordTypes then
    Include(rowStates, rsModified);
  if rtInserted in FUpdateRecordTypes then
    Include(rowStates, rsInserted);
  if rtDeleted in FUpdateRecordTypes then
    Include(rowStates, rsDeleted);
  if rtUnmodified in FUpdateRecordTypes then
    Include(rowStates, rsUnchanged);
  Result := TADDatSMechRowState.Create(rowStates);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.CreateFilterView;
var
  oView: TADDatSView;

  procedure CheckView;
  begin
    if oView <> nil then
      Exit;
    oView := TADDatSView.Create(FTable, C_AD_SysNamePrefix + 'FLT',
      vcDataSetFilter, True);
  end;

begin
  oView := nil;
  if FFilterView <> nil then begin
    FFilterView.RemRef;
    FFilterView := nil;
  end;
  try
    if (FParentDataSet <> nil) and (FTable.Manager <> nil) then begin
      CheckView;
      oView.Mechanisms.Add(CreateChildMech);
    end;
    if (FRangeFrom <> nil) or (FRangeTo <> nil) then begin
      CheckView;
      oView.Mechanisms.Add(CreateRangeMech);
    end;
    if Filtered and ((Filter <> '') or Assigned(OnFilterRecord)) then begin
      CheckView;
      oView.Mechanisms.Add(CreateFilterMech);
    end;
    if FUpdateRecordTypes <> [rtUnmodified, rtModified, rtInserted, rtDeleted] then begin
      CheckView;
      oView.Mechanisms.Add(CreateStateMech);
    end;
  except
    if oView <> nil then
      oView.RemRef;
    raise;
  end;
  FFilterView := oView;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.RelinkViews;
var
  oLastRow: TADDatSRow;
begin
  FAggregates.Release;
  FFieldAggregates.Release;
  if FSourceView <> nil then begin
    FSourceView.RemRef;
    FSourceView := nil;
  end;
  if FFilterView <> nil then begin
    if FSortView <> nil then
      FFilterView.SourceView := FSortView
    else
      FFilterView.SourceView := FView;
    FSourceView := FFilterView;
    FSourceView.AddRef;
  end;
  if FSortView <> nil then begin
    FSortView.SourceView := FView;
    FSortView.Active := True;
    if FSourceView = nil then begin
      FSourceView := FSortView;
      FSourceView.AddRef;
    end;
  end;
  if FFilterView <> nil then
    FFilterView.Active := True;
  if FSourceView = nil then begin
    if FView <> nil then
      FSourceView := FView
    else
      FSourceView := FTable.DefaultView;
    FSourceView.AddRef;
  end;
  FAggregates.Build;
  FFieldAggregates.Build;
  FSourceView.Active := True;
  if Active then begin
    oLastRow := GetRow;
    if oLastRow <> nil then
      FRecordIndex := FSourceView.IndexOf(oLastRow);
    FLockNoBMK := True;
    try
      UpdateCursorPos;
      Resync([]);
    finally
      FLockNoBMK := False;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.FilteringUpdated;
begin
  if Active then begin
    CreateFilterView;
    RelinkViews;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetTableConstraints;

  procedure ProcessFields(ATab: TADDatSTable; AConstraints: TCheckConstraints;
    AFields: TFields);
  var
    i: Integer;
    oCol: TADDatSColumn;
  begin
    if AConstraints <> nil then
      for i := 0 to AConstraints.Count - 1 do
        with AConstraints[i] do begin
          if ImportedConstraint <> '' then
            FCreatedConstraints.Add(ATab.Constraints.AddChk('', ImportedConstraint,
              ErrorMessage, ctAtEditEnd));
          if CustomConstraint <> '' then
            FCreatedConstraints.Add(ATab.Constraints.AddChk('', CustomConstraint,
              ErrorMessage, ctAtEditEnd));
        end;
    if AFields <> nil then
      for i := 0 to AFields.Count - 1 do
        with AFields[i] do begin
          if ImportedConstraint <> '' then
            FCreatedConstraints.Add(ATab.Constraints.AddChk('', ImportedConstraint,
              ConstraintErrorMessage, ctAtColumnChange));
          if CustomConstraint <> '' then
            FCreatedConstraints.Add(ATab.Constraints.AddChk('', CustomConstraint,
              ConstraintErrorMessage, ctAtColumnChange));
          if AFields[i] is TObjectField then
            with TObjectField(AFields[i]) do
              if DataType in [ftADT, ftArray] then begin
                oCol := GetFieldColumn(AFields[I]);
                if (DataType = ftArray) and SparseArrays and (Fields[0].DataType = ftADT) then
                  ProcessFields(oCol.NestedTable, nil, TObjectField(Fields[0]).Fields)
                else
                  ProcessFields(oCol.NestedTable, nil, TObjectField(Fields[i]).Fields);
              end;
        end;
  end;

begin
  ProcessFields(FTable, Constraints, Fields);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.ResetTableConstraints;
var
  i: Integer;
begin
  for i := 0 to FCreatedConstraints.Count - 1 do
    TADDatSCheckConstraint(FCreatedConstraints[i]).Free;
  FCreatedConstraints.Clear;
end;

{-------------------------------------------------------------------------------}
{$IFNDEF AnyDAC_FPC}
type
  __TField = class(TComponent)
  private
    FAutoGenerateValue: TAutoRefreshFlag;
  end;
{$ENDIF}

procedure TADDataSet.SetFieldAttributes(AField: TField; AColumn: TADDatSColumn;
  ASkeepAutoInc: Boolean);
var
  oObjFld: TObjectField;
begin
  if AField is TObjectField then begin
    oObjFld := TObjectField(AField);
    oObjFld.ObjectType := AColumn.SourceDataTypeName;
    with oObjFld do
      if DataType in [ftADT, ftArray] then begin
        if (DataType = ftArray) and SparseArrays and (Fields[0].DataType = ftADT) then
          SetFieldAttributes(TObjectField(Fields[0]).Fields)
        else
          SetFieldAttributes(Fields);
      end;
  end;
  if AColumn.SourceName <> '' then
    AField.Origin := AColumn.SourceName;
  if not (ASkeepAutoInc and (AField is TADAutoIncField)) then begin
    AField.ProviderFlags := [];
    if coInUpdate in AColumn.Options then
      AField.ProviderFlags := AField.ProviderFlags + [pfInUpdate];
    if coInWhere in AColumn.Options then
      AField.ProviderFlags := AField.ProviderFlags + [pfInWhere];
    if coInKey in AColumn.Options then
      AField.ProviderFlags := AField.ProviderFlags + [pfInKey];
{$IFNDEF AnyDAC_FPC}
    if __TField(AField).FAutoGenerateValue = DB.arNone then begin
      if caAutoInc in AColumn.Attributes then
        __TField(AField).FAutoGenerateValue := DB.arAutoInc;
      if caCalculated in AColumn.Attributes then
        __TField(AField).FAutoGenerateValue := DB.arDefault;
      if caVolatile in AColumn.Attributes then
        __TField(AField).FAutoGenerateValue := DB.arDefault;
      if caROWID in AColumn.Attributes then
        __TField(AField).FAutoGenerateValue := DB.arDefault;
    end;
{$ENDIF}
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetFieldAttributes(AFields: TFields);
var
  i: Integer;
  oFld: TField;
  oCol: TADDatSColumn;
begin
  for i := 0 to AFields.Count - 1 do begin
    oFld := AFields[i];
    if oFld.FieldNo >= 1 then begin
      oCol := GetFieldColumn(oFld);
      SetFieldAttributes(oFld, oCol, False);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetFieldAttributes;
begin
  SetFieldAttributes(Fields);
end;

{-------------------------------------------------------------------------------}
{$IFNDEF AnyDAC_FPC}
procedure TADDataSet.SetFieldAutoGenerateValue(AField: TField;
  AValue: TAutoRefreshFlag);
begin
  __TField(AField).FAutoGenerateValue := AValue;
  case AValue of
  DB.arNone:
    SetFieldAttributes(AField, GetFieldColumn(AField), False);
  DB.arAutoInc:
    begin
      AField.ProviderFlags := AField.ProviderFlags - [pfInUpdate] +
        [pfInWhere, pfInKey];
      AField.Required := False;
    end;
  DB.arDefault:
    ;
  end;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetColumnAttributes;
var
  i: Integer;
  oCol: TADDatSColumn;
  oFld: TField;
begin
  if FColumnAttributesUpdated then
    Exit;
  FColumnAttributesUpdated := True;
  for i := 0 to Fields.Count - 1 do begin
    oFld := Fields[I];
    if oFld.FieldNo >= 1 then begin
      oCol := GetFieldColumn(Fields[I]);
      if oFld.DefaultExpression <> '' then
        oCol.Expression := oFld.DefaultExpression;
      if not oFld.Required then
        oCol.Attributes := oCol.Attributes + [caAllowNull];
      if oFld is TADAutoIncField then begin
        oCol.AutoIncrement := TADAutoIncField(oFld).ClientAutoIncrement;
        oCol.ServerAutoIncrement := TADAutoIncField(oFld).ServerAutoIncrement;
        oCol.AutoIncrementSeed := TADAutoIncField(oFld).AutoIncrementSeed;
        oCol.AutoIncrementStep := TADAutoIncField(oFld).AutoIncrementStep;
      end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetInternalCalcs;
var
  i, j: Integer;
  oCol: TADDatSColumn;
  oFld: TField;
  iPrecision, iDestScale, iDestPrec: Integer;
  iDestSize: LongWord;
  iDestDataType: TADDataType;
  iDestAttrs: TADDataAttributes;
begin
  for i := 0 to Fields.Count - 1 do
    if Fields[i].FieldKind = fkInternalCalc then begin
      oFld := Fields[i];
      j := FTable.Columns.IndexOfName(oFld.FieldName);
      if j = -1 then
        oCol := TADDatSColumn.Create
      else
        oCol := FTable.Columns.ItemsI[j];
      with oCol do begin
        Name := oFld.FieldName;
        Options := [coAllowNull];
        Attributes := [caAllowNull, caCalculated];
        Expression := oFld.DefaultExpression;
        if oFld.DataType = ftAutoInc then
          AutoIncrement := True;
        if oFld is TFloatField then
          iPrecision := TFloatField(oFld).Precision
        else if oFld is TBCDField then
          iPrecision := TBCDField(oFld).Precision
{$IFDEF AnyDAC_D6}
        else if oFld is TFMTBCDField then
          iPrecision := TFMTBCDField(oFld).Precision
{$ENDIF}          
        else
          iPrecision := 0;
        iDestDataType := dtUnknown;
        iDestScale := 0;
        iDestPrec := 0;
        iDestSize := 0;
        iDestAttrs := [];
        FormatOptions.FieldDef2ColumnDef(oFld.DataType, oFld.Size, iPrecision,
          iDestDataType, iDestScale, iDestPrec, iDestSize, iDestAttrs);
        DataType := iDestDataType;
        Scale := iDestScale;
        Precision := iDestPrec;
        Size := iDestSize;
        Attributes := Attributes + iDestAttrs;
        if not (iDestDataType in C_AD_NonSearchableDataTypes) then
          Attributes := Attributes + [caSearchable];
      end;
      if oCol.Owner = nil then
        FTable.Columns.Add(oCol);
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetSortView(AView: TADDatSView);
begin
  if FSortView <> AView then begin
    if Active then
      ResetCursorRange;
    if FSortView <> nil then
      FSortView.RemRef;
    FSortView := AView;
    if FSortView <> nil then begin
      FSortView.AddRef;
      if State = dsBrowse then
        AllocKeyBuffers;
    end;
    if Active then
      RelinkViews;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.BuildViewForIndex(AIndex: TADIndex): TADDatSView;
begin
  Result := TADDatSView.Create(FTable, AIndex.Name, vcDataSetIndex, True);
  with AIndex do
    try
      if Fields <> '' then
        Result.Mechanisms.AddSort(Fields, DescFields, CaseInsFields, Options)
      else if Expression <> '' then
        Result.Mechanisms.AddSort(Expression, Options);
      if Filter <> '' then
        Result.Mechanisms.AddFilter(Filter, FilterOptions);
      Result.Active := Active;
    except
      Result.Free;
      raise;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SwitchToIndex(const AFieldNames, AIndexName: String);
var
  oView: TADDatSView;
begin
  if (AFieldNames <> '') or (AIndexName <> '') then
    if ((MasterSource = nil) or not (fiDetails in FetchOptions.Cache)) and
       (FetchOptions.Mode in [fmOnDemand, fmAll, fmExactRecsMax]) and
       not (State in [dsInactive, dsOpening]) then
      CheckFetchedAll;
  if AFieldNames <> '' then begin
    oView := FTable.Views.FindSortedView(AFieldNames, [], [soNoCase, soDescending]);
    if oView = nil then begin
      oView := TADDatSView.Create(FTable, C_AD_SysNamePrefix + 'IND_' + AFieldNames,
        vcDataSetTempIndex, True);
      try
        FTempIndexViews.Add(oView);
        oView.Mechanisms.AddSort(AFieldNames, '', '', []);
        oView.Active := True;
      except
        oView.Free;
        raise;
      end;
    end;
    SetSortView(oView);
  end
  else if AIndexName <> '' then begin
    oView := FTable.Views.ViewByName(AIndexName);
    if oView.SortingMechanism = nil then
      ADException(Self, [S_AD_LComp, S_AD_LComp_PDS], er_AD_DSViewNotSorted, [AIndexName]);
    SetSortView(oView);
  end
  else
    SetSortView(nil);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.OpenIndexes;
var
  i: Integer;
begin
  if IndexDefs.Count > 0 then begin
    Indexes.Clear;
    for i := 0 to IndexDefs.Count - 1 do
      Indexes.Add.Assign(IndexDefs[i]);
    FClearIndexDefs := False;
  end
  else begin
    IndexDefs.Updated := False;
    IndexDefs.Update;
    FClearIndexDefs := True;
  end;
  Indexes.Build;
  IndexDefs.Updated := True;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.ResetIndexes;
var
  i: Integer;
begin
  if FClearIndexDefs then
    IndexDefs.Clear
  else
    Indexes.Clear;
  Indexes.Release;
  for i := 0 to FTempIndexViews.Count - 1 do
    TADDatSView(FTempIndexViews[i]).RemRef;
  FTempIndexViews.Clear;
  IndexDefs.Updated := FClearIndexDefs;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.UpdateIndexDefs;
var
  i: Integer;
begin
  if (csDesigning in ComponentState) and (IndexDefs.Count > 0) then
    Exit;
  if not IndexDefs.Updated then begin
    IndexDefs.Clear;
    for i := 0 to Indexes.Count - 1 do
      IndexDefs.AddIndexDef.Assign(Indexes[i]);
    IndexDefs.Updated := True;
  end;
end;

{-------------------------------------------------------------------------------}
{ Open / close }

procedure TADDataSet.DoPrepareSource;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoUnprepareSource;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoDefineDatSManager;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoOpenSource(AAsyncQuery, AInfoQuery, AStructQuery: Boolean);
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
function TADDataSet.DoIsSourceOpen: Boolean;
begin
  Result := False;
  // nothing
end;

{-------------------------------------------------------------------------------}
function TADDataSet.DoIsSourceAsync: Boolean;
begin
  Result := False;
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoCloseSource;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoResetDatSManager;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoExecuteSource(ATimes, AOffset: Integer);
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoGetParams;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoBeforeExecute;
begin
  if Assigned(FBeforeExecute) then
    FBeforeExecute(self);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoAfterExecute;
begin
  if Assigned(FAfterExecute) then
    FAfterExecute(self);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoBeforeGetParams;
begin
  if Assigned(FBeforeGetParams) then
    FBeforeGetParams(self);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoAfterGetParams;
begin
  if Assigned(FAfterGetParams) then                     
    FAfterGetParams(self);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.OpenCursor(InfoQuery: Boolean);
begin
  StartWait;
  try
{$IFNDEF AnyDAC_FPC}
    if Designer <> nil then
      DoResetDatSManager;
{$ENDIF}
    FColumnAttributesUpdated := False;
    FSourceEOF := False;
    FUnidirRecsPurged := 0;
    if DataSetField = nil then begin
      DoMasterDefined;
      if IsLinked then
        DoMasterSetValues(FMasterLink.Fields);
      DoPrepareSource;
      DoDefineDatSManager;
    end
    else begin
      FParentDataSet := DataSetField.DataSet as TADDataSet;
{$IFNDEF AnyDAC_FPC}
      OpenParentDataSet(FParentDataSet);
{$ENDIF}
      FieldDefs.HiddenFields := FParentDataSet.FieldDefs.HiddenFields;
      AttachTable(FParentDataSet.GetFieldColumn(DataSetField).NestedTable, nil);
    end;
    if (DataSetField = nil) and InfoQuery then begin
      DoOpenSource(False, InfoQuery, True);
{$IFDEF AnyDAC_FPC}
      InternalOpen;
{$ELSE}
      inherited OpenCursor(InfoQuery);
{$ENDIF}
    end
    else if (DataSetField = nil) and DoIsSourceAsync then begin
      DoOpenSource(True, InfoQuery, True);
      SetState(dsOpening);
    end
    else begin
{$IFDEF AnyDAC_FPC}
      InternalOpen;
{$ELSE}
      inherited OpenCursor(InfoQuery);
{$ENDIF}
      if (DataSetField = nil) and (NestedDataSets <> nil) and (NestedDataSets.Count > 0) then
        DataEvent(deDataSetChange, 0);
    end;
  finally
    StopWait;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.IsLinked: Boolean;
begin
  Result := (FParentDataSet <> nil) or
    FMasterLink.Active and (FMasterLink.Fields.Count > 0);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.InternalOpen;
var
  lDeferOpen: Boolean;
begin
{$IFDEF AnyDAC_FPC}
  if not FInInternalOpen then begin
    FInInternalOpen := True;
    try
      OpenCursor(False);
    finally
      FInInternalOpen := False;
    end;
    Exit;
  end;
{$ENDIF}
  if FTable = nil then
    ADException(Self, [S_AD_LComp, S_AD_LComp_PDS], er_AD_DSNoDataTable, []);
  if FetchOptions.RecsMax <> -1 then
    FTable.MinimumCapacity := FetchOptions.RecsMax
  else
    FTable.MinimumCapacity := FetchOptions.RowsetSize;
  SetInternalCalcs;
  lDeferOpen := IsLinked and (Table.Columns.Count > 0);
  if (FetchOptions.Mode in [fmOnDemand, fmAll, fmExactRecsMax]) and
     (State <> dsOpening) and not lDeferOpen then
    DoOpenSource(False, False, True);
  OpenIndexes;
  SwitchToIndex(FIndexFieldNames, FIndexName);
  CreateFilterView;
  RelinkViews;
  FRecordIndex := -1;
  if not FieldDefs.Updated then
    FieldDefs.Update
  else
    RenewColumnMap;
  if DefaultFields then
    CreateFields;
  BindFields(True);
  SetViewAggregates;
  SetTableConstraints;
  if DefaultFields then
    SetFieldAttributes
  else
    SetColumnAttributes;
  FTable.Callback := TADDatSTableCallback.Create(Self);
  InitBufferPointers;
  if FSortView <> nil then
    AllocKeyBuffers;
  FTable.Constraints.Enforce := (FConstDisableCount = 0);
  if (FetchOptions.Mode in [fmOnDemand, fmAll, fmExactRecsMax]) and
     (State <> dsOpening) and lDeferOpen then
    MasterChanged(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoAfterOpen;
begin
  if FetchOptions.RecordCountMode = cmTotal then
    GetRecordCount;
  inherited DoAfterOpen;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.InternalClose;
begin
  if FDataLoadSave <> nil then
    EndBatch;
  if FTable <> nil then
    FTable.Callback := nil;
  if IsForceRowMode then
    EndForceRow;
  ResetTableConstraints;
  ResetCursorRange;
  FreeKeyBuffers;
  FRecordCount := -1;
  BindFields(False);
  if DefaultFields then
    DestroyFields;
  ResetViewAggregates;
  ResetIndexes;
  ResetViews;
  FCloneSource := nil;
  FRecordIndex := -1;
  FSourceEOF := True;
  FUnidirRecsPurged := 0;
  FLastParentRow := nil;
  if FLocateRow <> nil then begin
    FreeAndNil(FLocateRow);
    FreeAndNil(FLocateColumns);
  end;
  if FParentDataSet = nil then
    DoCloseSource;
{$IFNDEF AnyDAC_FPC}
  if Designer = nil then
{$ENDIF}
    DoResetDatSManager;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.IsCursorOpen: Boolean;
begin
  Result := (FSourceView <> nil) and FSourceView.ActualActive;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.Execute(ATimes: Integer = 0; AOffset: Integer = 0);
begin
  CheckInactive;
  StartWait;
  try
    DoBeforeExecute;
    DoPrepareSource;
    DoExecuteSource(ATimes, AOffset);
    if not DoIsSourceAsync then
      DoAfterExecute;
  finally
    StopWait;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.FetchParams;
begin
  DoBeforeGetParams;
  DoGetParams;
  DoAfterGetParams;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.Disconnect(AAbortJob: Boolean = False);
begin
  Active := False;
end;

{-------------------------------------------------------------------------------}
{ Field defs }

procedure TADDataSet.ClearFColumns;
var
  i: Integer;
begin
  for i := 0 to Length(FColumns) - 1 do
    TADColMapItem(FColumns[i]).Free;
  SetLength(FColumns, 0);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.AddFieldDesc(ADefs: TFieldDefs; AColumn: TADDatSColumn;
  var AFieldId: Integer; APath: TList): TFieldDef;
var
  i: Integer;
  iSize: LongWord;
  iPrecision: Integer;
  iType: TFieldType;
  sName: String;
  oChildTab: TADDatSTable;
  oColMapItem: TADColMapItem;
begin
  sName := AColumn.Name;
  i := 0;
  while ADefs.IndexOf(sName) >= 0 do begin
    Inc(i);
    sName := Format('%s_%d', [AColumn.Name, i]);
  end;
  iType := ftUnknown;
  iSize := 0;
  iPrecision := 0;
  FormatOptions.ColumnDef2FieldDef(AColumn.DataType, AColumn.Scale,
    AColumn.Precision, AColumn.Size, AColumn.Attributes, iType, iSize, iPrecision);
  if AColumn.DataType in [dtRowSetRef, dtCursorRef, dtRowRef, dtArrayRef] then begin
    oChildTab := AColumn.NestedTable;
    if AColumn.DataType in [dtRowRef, dtArrayRef] then
      iSize := oChildTab.Columns.Count;
  end
  else
    oChildTab := nil;
  Result := TFieldDef.Create(ADefs, sName, iType, iSize, False, AFieldId);
  with Result do begin
    Precision := iPrecision;
    InternalCalcField := caCalculated in AColumn.Attributes;
    Attributes := [];
    if not AColumn.AllowDBNull then
      Attributes := Attributes + [DB.faRequired];
    if AColumn.ReadOnly then
      Attributes := Attributes + [DB.faReadOnly];
    if caInternal in AColumn.Attributes then
      Attributes := Attributes + [DB.faHiddenCol];
    if caUnnamed in AColumn.Attributes then
      Attributes := Attributes + [DB.faUnnamed];
    if caFixedLen in AColumn.Attributes then
      Attributes := Attributes + [DB.faFixed];
  end;
  oColMapItem := TADColMapItem.Create;
  with oColMapItem do begin
    FColumn := AColumn;
    FColumnIndex := AColumn.Index;
    SetLength(FPath, APath.Count);
    for i := 0 to APath.Count - 1 do
      FPath[i] := Integer(APath[i]);
  end;
  FColumns[AFieldID - 1] := oColMapItem;
  Inc(AFieldID);
{$IFNDEF AnyDAC_FPC}
  if (oChildTab <> nil) and not (AColumn.DataType in [dtRowSetRef, dtCursorRef]) then begin
    APath.Add(Pointer(AColumn.Index));
    try
      AddTableDesc(Result.ChildDefs, oChildTab, AFieldID, APath);
    finally
      APath.Delete(APath.Count - 1);
    end;
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.AddTableDesc(ADefs: TFieldDefs; ATable: TADDatSTable;
  var AFieldId: Integer; APath: TList);
var
  i: Integer;
  oCol: TADDatSColumn;
begin
  SetLength(FColumns, Length(FColumns) + ATable.Columns.Count);
  for i := 0 to ATable.Columns.Count - 1 do begin
    oCol := ATable.Columns.ItemsI[i];
    if not (caInternal in oCol.Attributes) then
      AddFieldDesc(ADefs, oCol, AFieldId, APath);
  end;
  if AFieldId - 1 < Length(FColumns) then
    SetLength(FColumns, AFieldId - 1);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.InternalInitFieldDefs;
var
  iFldId: Integer;
  oPath: TList;
begin
  iFldId := 1;
  ClearFColumns;
  FieldDefs.Clear;
  if FTable <> nil then begin
    oPath := TList.Create;
    try
      AddTableDesc(FieldDefs, FTable, iFldId, oPath);
    finally
      oPath.Free;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.RenewFieldDesc(AColumn: TADDatSColumn; var AFieldId: Integer);
var
  oChildTab: TADDatSTable;
begin
  FColumns[AFieldID - 1].FColumn := AColumn;
  Inc(AFieldID);
  if AColumn.DataType in [dtRowRef, dtArrayRef] then begin
    oChildTab := AColumn.NestedTable;
    if oChildTab <> nil then
      RenewTableDesc(oChildTab, AFieldID);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.RenewTableDesc(ATable: TADDatSTable; var AFieldId: Integer);
var
  i: Integer;
  oCol: TADDatSColumn;
begin
  for i := 0 to ATable.Columns.Count - 1 do begin
    oCol := ATable.Columns.ItemsI[i];
    if not (caInternal in oCol.Attributes) then
      RenewFieldDesc(oCol, AFieldId);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.RenewColumnMap;
var
  iFldId: Integer;
begin
  iFldId := 1;
  RenewTableDesc(FTable, iFldId);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetFieldClass(FieldType: TFieldType): TFieldClass;
begin
  if FieldType = ftFmtMemo then
    Result := TADWideMemoField
  else if FieldType = ftAutoInc then
    Result := TADAutoIncField
  else
    Result := inherited GetFieldClass(FieldType);
end;

{-------------------------------------------------------------------------------}
{ Record Functions }

type
  PRecInfo = ^TRecInfo;
  TRecInfo = record
    FRow: TADDatSRow;
    FRowIndex: LongInt;
    FBookmarkFlag: TBookmarkFlag;
  end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.InitBufferPointers;
begin
  BookmarkSize := SizeOf(Pointer);
  FBufferSize := Word(CalcFieldsSize + SizeOf(TRecInfo));
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetRecordSize: Word;
begin
  ASSERT(FTable.Columns.DataOffsets[FTable.Columns.Count] <= $FFFF);
  Result := Word(FTable.Columns.DataOffsets[FTable.Columns.Count]);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.AllocRecordBuffer: PChar;
begin
  Result := AllocMem(FBufferSize);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.FreeRecordBuffer(var Buffer: PChar);
begin
  FreeMem(Buffer);
  Buffer := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.ClearCalcFields(Buffer: PChar);
{$IFNDEF AnyDAC_D10}
var
  i: Integer;
{$ENDIF}
begin
{$IFNDEF AnyDAC_D10}
  for i := 0 to FieldCount - 1 do
    with Fields[i] do
      if (FieldKind in [fkCalculated, fkLookup]) and (DataType = ftWideString) then
        PWideString(Buffer + Offset + 1)^ := '';
{$ENDIF}
  ADFillChar(Buffer^, CalcFieldsSize, #0);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetRow(ABuffer: PChar = nil; AForceBufferRead: Boolean = False): TADDatSRow;
var
  pInfo: PRecInfo;
begin
  if ABuffer = nil then begin
    if not Active or IsEmpty then begin
      Result := nil;
      Exit;
    end
    else if FForceRecBuffer <> nil then
      ABuffer := FForceRecBuffer
    else
      ABuffer := ActiveBuffer;
  end;
  pInfo := PRecInfo(ABuffer + CalcFieldsSize);
  if (pInfo^.FBookmarkFlag in [bfBOF, bfEOF, bfInserted]) and
     not AForceBufferRead and (ABuffer <> FForceRecBuffer) and
     (FNewRow <> nil) then
    Result := FNewRow
  else
    Result := pInfo^.FRow;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetParentRow: TADDatSRow;
begin
  with FParentDataSet do
    if (State <> dsInsert) and (FSourceView <> nil) and (FSourceView.Rows.Count > 0) then
      if Active then
        Result := GetRow
      else
        Result := FSourceView.Rows[0]
    else
      Result := nil;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.RowState2UpdateStatus(ARowState: TADDatSRowState): TUpdateStatus;
const
  rs2us: array [TADDatSRowState] of TUpdateStatus = (usUnmodified, usUnmodified,
    usInserted, usDeleted, usModified, usUnmodified, usUnmodified, usUnmodified,
    usUnmodified, usUnmodified, usUnmodified, usUnmodified, usUnmodified,
    usUnmodified);
begin
  Result := rs2us[ARowState];
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetRecord(Buffer: PChar; GetMode: TGetMode;
  DoCheck: Boolean): TGetResult;
begin
  Result := grOK;
  try
    case GetMode of
    gmCurrent:
      ;
    gmNext:
      begin
        while ((FRecordIndex + 1) >= FSourceView.Rows.Count) and
              InternalFetchRows(False, True) do
          ;
        if (FRecordIndex + 1) >= FSourceView.Rows.Count then
          FRecordIndex := FSourceView.Rows.Count
        else
          Inc(FRecordIndex);
      end;
    gmPrior:
      if FRecordIndex >= 0 then
        Dec(FRecordIndex);
    end;
    if FRecordIndex >= FSourceView.Rows.Count then
      Result := grEOF
    else if FRecordIndex < 0 then
      Result := grBOF
    else if Buffer <> nil then begin
      with PRecInfo(Buffer + CalcFieldsSize)^ do begin
        FRow := FSourceView.Rows.ItemsI[FRecordIndex];
        FRowIndex := FRecordIndex;
        FBookmarkFlag := bfCurrent;
      end;
      GetCalcFields(Buffer);
    end;
  except
    Result := grError;
    if DoCheck then
      raise;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetActiveRecBufRecordIndex(var AIndex: Integer): Boolean;
var
  pRecBuf: PChar;
begin
  Result := False;
  pRecBuf := nil;
  AIndex := -1;
  if GetActiveRecBuf(pRecBuf) then
    with PRecInfo(pRecBuf + CalcFieldsSize)^ do
      if FBookmarkFlag = bfCurrent then begin
        AIndex := FRowIndex;
        Result := True;
      end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetCurrentRecord(Buffer: PChar): Boolean;
begin
  if not IsEmpty and (GetBookmarkFlag(ActiveBuffer) = bfCurrent) then begin
    UpdateCursorPos;
    try
      PRecInfo(Buffer + CalcFieldsSize)^.FRow := FSourceView.Rows.ItemsI[FRecordIndex];
      Result := True;
    except
      Result := False;
    end;
  end
  else
    Result := False;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetRecordCount: Integer;

  procedure UpdateParentCursorPos;
  begin
    if (FParentDataSet <> nil) and (FParentDataSet.State <> dsInsert) then
      FParentDataSet.UpdateCursorPos;
  end;

begin
  Result := 0;
  if not (State in [dsInactive, dsOpening]) then
    case FetchOptions.RecordCountMode of
    cmVisible:
      begin
        UpdateParentCursorPos;
        Result := FSourceView.Rows.Count;
      end;
    cmFetched:
      begin
        UpdateParentCursorPos;
        Result := FUnidirRecsPurged + FTable.Rows.Count;
      end;
    cmTotal:
      begin
        if FRecordCount = -1 then begin
          UpdateParentCursorPos;
          if (FParentDataSet <> nil) and (FTable.Manager <> nil) or
             (FRangeFrom <> nil) or (FRangeTo <> nil) or
             Filtered and ((Filter <> '') or Assigned(OnFilterRecord)) or
             not (rtUnmodified in FUpdateRecordTypes) then begin
            FetchAll;
            FRecordCount := FSourceView.Rows.Count;
          end
          else
            UpdateRecordCount;
        end;
        Result := FRecordCount;
      end;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.UpdateRecordCount;
begin
  FRecordCount := -1;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetRecIndex: Integer;
var
  BufPtr: PChar;
begin
  CheckActive;
  if IsEmpty then
    BufPtr := nil
  else if State = dsCalcFields then
    BufPtr := CalcBuffer
  else
    BufPtr := ActiveBuffer;
  if BufPtr = nil then
    Result := -1
  else
    Result := PRecInfo(BufPtr + CalcFieldsSize).FRowIndex;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetRecNo: Integer;
begin
  Result := FUnidirRecsPurged + GetRecIndex + 1;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.InternalSetRecNo(AValue: Integer);
begin
  Dec(AValue);
  if AValue - FUnidirRecsPurged < 0 then
    FRecordIndex := 0
  else begin
    while (AValue - FUnidirRecsPurged >= FSourceView.Rows.Count) and
          InternalFetchRows(False, True) do
      ;
    if AValue - FUnidirRecsPurged >= FSourceView.Rows.Count then
      FRecordIndex := FSourceView.Rows.Count - 1
    else
      FRecordIndex := AValue - FUnidirRecsPurged;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetRecNo(AValue: Integer);
begin
  CheckBrowseMode;
  if AValue <> RecNo then begin
    DoBeforeScroll;
    InternalSetRecNo(AValue);
    Resync([rmCenter]);
    DoAfterScroll;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetActiveRecBuf(var RecBuf: PChar): Boolean;
begin
  if FForceRecBuffer <> nil then
    RecBuf := FForceRecBuffer
  else if State = dsBrowse then
    if IsEmpty then
      RecBuf := nil
    else
      RecBuf := ActiveBuffer
  else
    case State of
      dsBlockRead, dsNewValue, dsOldValue:
        if IsEmpty then
          RecBuf := nil
        else
          RecBuf := ActiveBuffer;
      dsEdit, dsInsert:
        RecBuf := ActiveBuffer;
      dsSetKey:
        RecBuf := PChar(FKeyBuffer) + SizeOf(TADKeyBuffer);
      dsCalcFields:
        RecBuf := CalcBuffer;
      dsFilter:
        RecBuf := TempBuffer;
    else
      RecBuf := nil;
    end;
  Result := RecBuf <> nil;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.BeginForceRow(ARow: TADDatSRow; AReadWrite, AWithCalcFields: Boolean);
begin
  FForceRecBuffer := AllocRecordBuffer;
  with PRecInfo(FForceRecBuffer + CalcFieldsSize)^ do begin
    FRow := ARow;
    FRowIndex := -1;
    FBookmarkFlag := bfBOF;
  end;
  if AReadWrite then
    ARow.BeginForceWrite;
  if AWithCalcFields then
    GetCalcFields(FForceRecBuffer);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.EndForceRow;
begin
  with PRecInfo(FForceRecBuffer + CalcFieldsSize)^ do
    if FRow.RowState = rsForceWrite then
      FRow.EndForceWrite;
  FreeRecordBuffer(FForceRecBuffer);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.IsForceRowMode: Boolean;
begin
  Result := FForceRecBuffer <> nil;
end;

{-------------------------------------------------------------------------------}
{ Field get / set data }

function TADDataSet.GetRowVersion: TADDatSRowVersion;
begin
  if (State = dsBrowse) or IsForceRowMode then
    Result := rvDefault
  else if State = dsNewValue then
    Result := rvCurrent
  else if State = dsOldValue then
    Result := rvOriginal
  else
    Result := rvDefault;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetFieldColumn(ARecBuff: PChar; AFieldNo: Integer;
  var AColumn: TADDatSColumn; var AColumnIndex: Integer;
  var ARow: TADDatSRow; AInitNested: Boolean): Boolean;
var
  oColMap: TADColMapItem;
  i: Integer;
  prevRow: TADDatSRow;
begin
  oColMap := TADColMapItem(FColumns[AFieldNo - 1]);
  if oColMap = nil then
    Result := False
  else begin
    ARow := GetRow(ARecBuff);
    AColumn := oColMap.FColumn;
    AColumnIndex := oColMap.FColumnIndex;
    prevRow := nil;
    if oColMap.FPath <> nil then
      for i := 0 to Length(oColMap.FPath) - 1 do begin
        if ARow = nil then
          if AInitNested and (prevRow <> nil) then begin
            ARow := AColumn.Table.NewRow(True);
            ARow.ParentRow := prevRow;
          end
          else
            Break;
        prevRow := ARow;
        ARow := ARow.NestedRow[oColMap.FPath[i]];
      end;
    Result := True;
    if ARow = nil then
      if AInitNested and (prevRow <> nil) then begin
        ARow := AColumn.Table.NewRow(True);
        ARow.ParentRow := prevRow;
      end
      else
        Result := False;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetFieldColumn(AField: TField): TADDatSColumn;
var
  iFieldNo: Integer;
begin
  iFieldNo := AField.FieldNo;
  if iFieldNo = 0 then
{$IFNDEF AnyDAC_FPC}
    iFieldNo := FieldDefList.FieldByName(AField.FieldName).FieldNo;
{$ELSE}
    iFieldNo := FieldDefs.Find(AField.FieldName).FieldNo;
{$ENDIF}
  Result := TADColMapItem(FColumns[iFieldNo - 1]).FColumn;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetColumnField(AColumn: TADDatSColumn): TField;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Length(FColumns) - 1 do
    if TADColMapItem(FColumns[i]).FColumn = AColumn then begin
      Result := FieldByNumber(i + 1);
      Break;
    end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetFieldData(FieldNo: Integer; Buffer: Pointer): Boolean;
var
  pRecBuf: PChar;
  oColumn: TADDatSColumn;
  iColIndex: Integer;
  oRow: TADDatSRow;
  pData: Pointer;
  iDataLen: LongWord;
  p: PChar;
  oRows: TADDatSNestedRowList;

  procedure ProcessGUID(ApGUID: PGUID; ABuffer: Pointer);
  var
    s: String;
  begin
    S := GUIDToString(ApGUID^);
    StrCopy(PChar(ABuffer), PChar(S));
  end;

  function ProcessAnsiString(pData: Pointer; iDataLen: Integer; Buffer: Pointer): Boolean;
  begin
    if (caFixedLen in oColumn.Attributes) and (iDataLen > 0) and
       (PChar(pData)[iDataLen - 1] <= ' ') and FormatOptions.StrsTrim then
      repeat
        Dec(iDataLen);
      until (iDataLen = 0) or (PChar(pData)[iDataLen - 1] > ' ');
    if (iDataLen = 0) and FormatOptions.StrsEmpty2Null then
      Result := False
    else begin
      Result := True;
      ADMove(PChar(pData)^, PChar(Buffer)^, iDataLen * SizeOf(AnsiChar));
      (PChar(Buffer) + iDataLen * SizeOf(AnsiChar))^ := #0;
    end;
  end;

  function ProcessWideString(pData: Pointer; iDataLen: Integer; Buffer: Pointer): Boolean;
  begin
    if (caFixedLen in oColumn.Attributes) and (iDataLen > 0) and
       (PWideChar(pData)[iDataLen - 1] <= ' ') and FormatOptions.StrsTrim then
      repeat
        Dec(iDataLen);
      until (iDataLen = 0) or (PWideChar(pData)[iDataLen - 1] > ' ');
    if (iDataLen = 0) and FormatOptions.StrsEmpty2Null then
      Result := False
    else begin
      Result := True;
      ADMove(PWideChar(pData)^, PWideChar(Buffer)^, iDataLen * SizeOf(WideChar));
      p := PChar(Buffer) + iDataLen * SizeOf(WideChar);
      p^ := #0;
      (p + 1)^ := #0;
    end;
  end;

  function ProcessByteString(pData: Pointer; iDataLen: Integer;
    Buffer: Pointer): Boolean;
  begin
    Result := True;
    if caFixedLen in oColumn.Attributes then
      ADMove(PByte(pData)^, PByte(Buffer)^, iDataLen * SizeOf(Byte))
    else begin
      if (iDataLen = 0) and FormatOptions.StrsEmpty2Null then
        Result := False
      else begin
        PWord(Buffer)^ := Word(iDataLen);
        ADMove(PByte(pData)^, PByte(PChar(Buffer) + SizeOf(Word))^, iDataLen * SizeOf(Byte));
      end;
    end;
  end;

begin
  pRecBuf := nil;
  Result := GetActiveRecBuf(pRecBuf);
  if not Result then
    Exit;
  oColumn := nil;
  iColIndex := -1;
  oRow := nil;
  if not GetFieldColumn(pRecBuf, FieldNo, oColumn, iColIndex, oRow) then begin
    Result := False;
    Exit;
  end;
  case oColumn.DataType of
  dtRowSetRef, dtCursorRef:
    begin
      oRows := oRow.NestedRows[iColIndex];
      Result := (oRows <> nil) and (oRows.Count > 0);
    end;
  dtRowRef, dtArrayRef:
    Result := (oRow.NestedRow[iColIndex] <> nil);
  else
    pData := nil;
    iDataLen := 0;
    Result := oRow.GetData(iColIndex, GetRowVersion, pData, 0, iDataLen, False);
    if Result and (Buffer <> nil) then
      case oColumn.DataType of
      dtBoolean:       PWordBool(Buffer)^ := PWordBool(pData)^;
      dtSByte:         PSmallInt(Buffer)^ := PShortInt(pData)^;
      dtInt16:         PSmallInt(Buffer)^ := PSmallInt(pData)^;
      dtInt32:         PLongInt(Buffer)^ := PInteger(pData)^;
      dtInt64:         PLargeInt(Buffer)^ := PInt64(pData)^;
      dtUInt64:        PULargeInt(Buffer)^ := PUInt64(pData)^;
      dtByte:          PWord(Buffer)^ := PByte(pData)^;
      dtUInt16:        PWord(Buffer)^ := PWord(pData)^;
      dtUInt32:        PLongInt(Buffer)^ := PLongWord(pData)^;
      dtDouble:        PDouble(Buffer)^ := PDouble(pData)^;
      dtCurrency:      PDouble(Buffer)^ := PCurrency(pData)^;
{$IFNDEF AnyDAC_FPC}
      dtBCD:           PADBcd(Buffer)^ := PADBcd(pData)^;
{$ELSE}
      dtBCD:           BcdToCurr(PADBcd(pData)^, PCurrency(Buffer)^);
{$ENDIF}
      dtFmtBCD:        PADBcd(Buffer)^ := PADBcd(pData)^;
{$IFDEF AnyDAC_D6Base}
      dtDateTimeStamp: PADSQLTimeStamp(Buffer)^ := PADSQLTimeStamp(pData)^;
{$ELSE}
      dtDateTimeStamp: PADDateTimeData(Buffer)^.DateTime := TimeStampToMSecs(
        DateTimeToTimeStamp(ADSQLTimeStampToDateTime(PADSQLTimeStamp(pData)^)));
{$ENDIF}
      dtDateTime:      PADDateTimeData(Buffer)^.DateTime := PADDateTimeData(pData)^.DateTime;
      dtTime:          PADDateTimeData(Buffer)^.Time := PLongint(pData)^;
      dtDate:          PADDateTimeData(Buffer)^.Date := PLongint(pData)^;
      dtAnsiString:    Result := ProcessAnsiString(pData, iDataLen, Buffer);
      dtWideString:    Result := ProcessWideString(pData, iDataLen, Buffer);
      dtByteString:    Result := ProcessByteString(pData, iDataLen, Buffer);
      dtGUID:          ProcessGUID(PGUID(pData), Buffer);
      dtObject:        PIUnknown(Buffer)^ := PIUnknown(pData)^;
      end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetFieldData(Field: TField; Buffer: Pointer): Boolean;
var
  pRecBuf: PChar;
begin
  if Field.FieldNo > 0 then
    Result := GetFieldData(Field.FieldNo, Buffer)
  else begin
    pRecBuf := nil;
    Result := GetActiveRecBuf(pRecBuf);
    if Result and (State in [dsBrowse, dsEdit, dsInsert, dsCalcFields, dsBlockRead, dsFilter]) then begin
      Inc(pRecBuf, Field.Offset);
      Result := Boolean(pRecBuf[0]);
      if Result and (Buffer <> nil) then
{$IFNDEF AnyDAC_D10}
        if Field.DataType = ftWideString then
          PLongWord(Buffer)^ := PLongWord(pRecBuf + 1)^
        else
{$ENDIF}        
          ADMove(pRecBuf[1], Buffer^, Field.DataSize);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
{$IFNDEF AnyDAC_FPC}
procedure TADDataSet.DataConvert(Field: TField; Source, Dest: Pointer; ToNative: Boolean);
  {$IFNDEF AnyDAC_D10}
var
  l: Integer;
  p: PChar;
  {$ENDIF}
begin
  {$IFNDEF AnyDAC_D10}
  if Field.DataType = ftWideString then
    if Field.FieldKind in [fkCalculated, fkLookup] then
      PLongWord(Dest)^ := PLongWord(Source)^
    else if ToNative then begin
      l := Length(WideString(Source^)) * sizeof(WideChar);
      ADMove(WideString(Source^)[1], PWideChar(Dest)^, l);
      p := PChar(Dest) + l;
      p^ := #0;
      (p + 1)^ := #0;
    end
    else
      SetString(WideString(Dest^), PWideChar(Source), ADWideStrLen(PWideChar(Source)))
  else
  {$ENDIF}
    inherited DataConvert(Field, Source, Dest, ToNative);
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetFieldData(Field: TField; Buffer: Pointer);
var
  pRecBuf: PChar;
  oColumn: TADDatSColumn;
  oRow: TADDatSRow;
  iLen: Integer;
  pData: Pointer;
  shiVal: ShortInt;
  biVal: Byte;
  crVal: Currency;
  iColIndex: Integer;
  rGUID: TGUID;
{$IFNDEF AnyDAC_D6Base}
  rSTS: TADSQLTimeStamp;
{$ENDIF}
{$IFDEF AnyDAC_FPC}
  rBCD: TADBcd;
{$ENDIF}

  procedure NotEditingError;
  begin
    DatabaseError(SNotEditing, Self);
  end;

  procedure FieldROError;
  begin
    DatabaseErrorFmt(SFieldReadOnly, [Field.DisplayName]);
  end;

  procedure NotIndexFieldError;
  begin
    DatabaseErrorFmt(SNotIndexField, [Field.DisplayName]);
  end;

  procedure Buff2GUID(ABuff: PChar; var AGuid: TGUID);
  var
    s: String;
    iLen: Integer;
  begin
    iLen := StrLen(ABuff);
    if (ABuff^ <> '{') and ((ABuff + iLen - 1)^ <> '}') then
      s := Format('{%s}', [ABuff])
    else
      SetString(s, ABuff, iLen);
    AGUID := StringToGUID(s);
  end;

begin
  with Field do begin
    if not IsForceRowMode and not (State in dsWriteModes) then
      NotEditingError;
    pRecBuf := nil;
    GetActiveRecBuf(pRecBuf);
    if FieldNo > 0 then begin
      if State = dsCalcFields then
        NotEditingError;
      if not IsForceRowMode and ReadOnly and not (State in [dsSetKey, dsFilter]) then
        FieldROError;
      if (State = dsSetKey) and (FieldNo < 0) then
        NotIndexFieldError;
      if not IsForceRowMode then
        Validate(Buffer);
      oColumn := nil;
      iColIndex := -1;
      oRow := nil;
      if GetFieldColumn(pRecBuf, FieldNo, oColumn, iColIndex, oRow, True) then begin
        iLen := 0;
        pData := nil;
        if Buffer <> nil then
          case oColumn.DataType of
          dtSByte:
            begin
              shiVal := ShortInt(PSmallInt(Buffer)^);
              pData := @shiVal;
            end;
          dtByte:
            begin
              biVal := Byte(PWord(Buffer)^);
              pData := @biVal;
            end;
          dtCurrency:
            begin
              crVal := PDouble(Buffer)^;
              pData := @crVal;
            end;
          dtAnsiString:
            begin
              iLen := StrLen(PChar(Buffer));
              if (caFixedLen in oColumn.Attributes) and FormatOptions.StrsTrim then
                while (iLen > 0) and (PChar(Buffer)[iLen - 1] = ' ') do
                  Dec(iLen);
              if (iLen = 0) and FormatOptions.StrsEmpty2Null then
                pData := nil
              else
                pData := Buffer;
            end;
          dtWideString:
            begin
              iLen := ADWideStrLen(PWideChar(Buffer));
              if (caFixedLen in oColumn.Attributes) and FormatOptions.StrsTrim then
                while (iLen > 0) and (PWideChar(Buffer)[iLen - 1] = ' ') do
                  Dec(iLen);
              if (iLen = 0) and FormatOptions.StrsEmpty2Null then
                pData := nil
              else
                pData := Buffer;
            end;
          dtByteString:
            begin
              if caFixedLen in oColumn.Attributes then begin
                pData := Buffer;
                iLen := oColumn.Size;
              end
              else begin
                iLen := PWord(Buffer)^;
                if (iLen = 0) and FormatOptions.StrsEmpty2Null then
                  pData := nil
                else
                  pData := PChar(Buffer) + SizeOf(Word);
              end;
            end;
          dtGUID:
            begin
              Buff2GUID(PChar(Buffer), rGUID);
              pData := @rGUID;
            end;
          dtDateTimeStamp:
            begin
{$IFDEF AnyDAC_D6Base}
              pData := Buffer;
{$ELSE}
              rSTS := ADDateTimeToSQLTimeStamp(TimeStampToDateTime(MSecsToTimeStamp(
                PADDateTimeData(Buffer)^.DateTime)));
              pData := @rSTS;
{$ENDIF}
            end;

          dtBCD:
            begin
{$IFNDEF AnyDAC_FPC}
              pData := Buffer;
{$ELSE}
              CurrToBCD(PCurrency(Buffer)^, rBCD);
              pData := @rBCD;
{$ENDIF}
            end;
          dtBoolean,
          dtInt16, dtInt32, dtInt64,
          dtUInt16, dtUInt32, dtUInt64,
          dtTime, dtDate,
          dtDouble,
          dtDateTime,
          dtFmtBCD,
          dtObject:
            pData := Buffer;
          end;
        if oRow.RowState in [rsInserted, rsModified, rsUnchanged] then
          oRow.BeginEdit;
        oRow.SetData(iColIndex, pData, iLen);
      end;
    end
    else begin {fkCalculated, fkLookup}
      Inc(pRecBuf, Offset);
      Boolean(pRecBuf[0]) := LongBool(Buffer);
      if Boolean(pRecBuf[0]) then
{$IFNDEF AnyDAC_D10}
        if Field.DataType = ftWideString then
          PWideString(pRecBuf + 1)^ := PWideString(Buffer)^
        else
{$ENDIF}        
          ADMove(Buffer^, pRecBuf[1], DataSize);
    end;
    if not IsForceRowMode and not (State in [dsCalcFields, dsFilter, dsNewValue]) then
      DataEvent(deFieldChange, Longint(Field));
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.CreateBlobStream(Field: TField; Mode: TBlobStreamMode): TStream;
begin
  Result := TADBlobStream.Create(Field as TBlobField, Mode);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.CloseBlob(Field: TField);
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
{ Fetching }

function TADDataSet.DoFetch(ATable: TADDatSTable; AAll: Boolean): Integer;
begin
  Result := 0; // nothing more
end;

{-------------------------------------------------------------------------------}
function TADDataSet.DoFetch(ARow: TADDatSRow; AColumn: Integer;
  ARowOptions: TADPhysFillRowOptions): Boolean;
begin
  Result := False; // nothing more
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoSortOrderChanged;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoBeforeGetRecords;
begin
  if Assigned(FBeforeGetRecords) then
    FBeforeGetRecords(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoAfterGetRecords;
begin
  if Assigned(FAfterGetRecords) then
    FAfterGetRecords(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoBeforeRowRequest;
begin
  if Assigned(FBeforeRowRequest) then
    FBeforeRowRequest(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoAfterRowRequest;
begin
  if Assigned(FAfterRowRequest) then
    FAfterRowRequest(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetUnidirectional(const AValue: Boolean);
begin
  if FUnidirectional <> AValue then begin
    FUnidirectional := AValue;
    { TODO -cDATASET : If "inherited SetUniDirectional" will be uncommented, then
      GetRecord(buff, ...) will receive as buff - Buffers[FRecordCount], where
      FRecordCount = 1. And FActiveRecord (ActiveBuffer) is 0. So, always will
      read first record. }
    // inherited SetUniDirectional(AValue);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.CheckFetchedAll;
begin
  InternalFetchRows(True, True);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.InternalFetchRows(AAll, AOnDemand: Boolean): Boolean;
begin
  Result := False;
  { TODO -cDATASET : Should we take into account here FetchOptions for NestedDataSet ? }
  { For a while - not. Oracle driver fetches all nested records at once for parent
    field }
  if ((FetchOptions.Mode in [fmOnDemand, fmAll, fmExactRecsMax]) and AOnDemand or
      {(FetchOptions.Mode = fmManual) and} not AOnDemand) then begin
    if FParentDataSet <> nil then
      Result := FParentDataSet.InternalFetchNested(FTable, [foDetails])
    else if not SourceEOF then begin
      if FetchOptions.RowsetSize <> 0 then begin
        StartWait;
        try
          DoBeforeGetRecords;
          repeat
            if Unidirectional then begin
              Inc(FUnidirRecsPurged, FTable.Rows.Count);
              FTable.Clear;
              FRecordIndex := -1;
            end;
            Result := (DoFetch(FTable, AAll) > 0);
          until not AAll or not Result;
          if not Result then
            FSourceEOF := True;
          if Unidirectional and (FSourceView.Rows.Count = 0) then
            ClearBuffers;
          DoAfterGetRecords;
        finally
          StopWait;
        end;
      end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetNextPacket: Integer;
begin
  CheckActive;
  if SourceEOF then
    Result := 0
  else begin
    UpdateCursorPos;
    Result := FTable.Rows.Count;
    if FMasterLink.Active and (FMasterLink.Fields.Count > 0) then
      CheckDetailRecords
    else
      InternalFetchRows(False, False);
    Result := FTable.Rows.Count - Result;
    Resync([]);
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TADDataSet.FetchAll;
begin
  CheckBrowseMode;
  InternalFetchRows(True, True);
  Resync([]);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.InternalFetchNested(ANestedTable: TADDatSTable;
  ARowOptions: TADPhysFillRowOptions): Boolean;
var
  iPrevRowCount: Integer;
  oRow: TADDatSRow;

  procedure CheckNeedFetch(ACheckOpt: TADPhysFillRowOption;
    var ARowOptions: TADPhysFillRowOptions; ADataTypes: TADDataTypes);
  var
    lAllFetched: Boolean;
    i: Integer;
  begin
    if ACheckOpt in ARowOptions then begin
      lAllFetched := True;
      for i := 0 to FTable.Columns.Count - 1 do
        if (FTable.Columns.ItemsI[i].DataType in ADataTypes) and not oRow.Fetched[i] then begin
          lAllFetched := False;
          Break;
        end;
      if lAllFetched then
        Exclude(ARowOptions, ACheckOpt);
    end;
  end;

begin
  UpdateCursorPos;
  oRow := GetRow;
  Result := False;
  if (oRow = nil) or (oRow.RowState in [rsInserted, rsDetached]) then
    Exit;
  if FParentDataSet <> nil then begin
    if ANestedTable = nil then
      Result := FParentDataSet.InternalFetchNested(FTable, ARowOptions + [foDetails])
    else begin
      if not oRow.Fetched[ANestedTable.Columns.ParentCol] then begin
        iPrevRowCount := ANestedTable.Rows.Count;
        FParentDataSet.InternalFetchNested(FTable, ARowOptions + [foDetails]);
        Result := ANestedTable.Rows.Count > iPrevRowCount;
      end;
    end;
  end
  else begin
    DoBeforeRowRequest;
    oRow.RejectChanges;
    if ANestedTable = nil then begin
      CheckNeedFetch(foBlobs, ARowOptions, C_AD_BlobTypes);
      CheckNeedFetch(foDetails, ARowOptions, [dtRowSetRef, dtCursorRef]);
      if ARowOptions <> [] then begin
        StartWait;
        try
          Result := DoFetch(oRow, -1, ARowOptions);
        finally
          StopWait;
        end;
      end;
    end
    else begin
      if not oRow.Fetched[ANestedTable.Columns.ParentCol] then begin
        iPrevRowCount := ANestedTable.Rows.Count;
        StartWait;
        try
          DoFetch(oRow, ANestedTable.Columns.ParentCol, ARowOptions);
        finally
          StopWait;
        end;
        Result := ANestedTable.Rows.Count > iPrevRowCount;
      end;
    end;
    DoAfterRowRequest;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.FetchDetails(ADataSetField: TDataSetField = nil);
var
  oTab: TADDatSTable;
begin
  if ADataSetField <> nil then
    oTab := (ADataSetField.NestedDataSet as TADDataSet).FTable
  else
    oTab := nil;
  if InternalFetchNested(oTab, [foDetails]) and not FSelfOperating then
    DataEvent(deDataSetChange, 0);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.FetchBlobs;
begin
  CheckActive;
  if not (State in [dsBrowse, dsBlockRead]) then
    Exit;
  if InternalFetchNested(nil, [foBlobs]) and not FSelfOperating then
    DataEvent(deDataSetChange, 0);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.RefreshRecord;
begin
  CheckActive;
  if not (State in [dsBrowse, dsBlockRead]) then
    Exit;
  if InternalFetchNested(nil, [foClear] + ADGetFillRowOptions(GetFetchOptions)) and
     not FSelfOperating then
    DataEvent(deDataSetChange, 0);
end;

{-------------------------------------------------------------------------------}
{ Navigation / Editing }

procedure TADDataSet.DoProcessUpdateRequest(ARequest: TADPhysUpdateRequest;
  AOptions: TADPhysUpdateRowOptions);
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.CheckInserting;
  procedure ErrorInsert;
  begin
    ADException(Self, [S_AD_LComp, S_AD_LComp_PDS], er_AD_DAptCantInsert, []);
  end;
begin
  if not UpdateOptions.EnableInsert then
    ErrorInsert
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.CheckEditing;
  procedure ErrorEdit;
  begin
    ADException(Self, [S_AD_LComp, S_AD_LComp_PDS], er_AD_DAptCantEdit, []);
  end;
begin
  if not UpdateOptions.EnableUpdate then
    ErrorEdit;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.CheckDeleting;
  procedure ErrorDelete;
  begin
    ADException(Self, [S_AD_LComp, S_AD_LComp_PDS], er_AD_DAptCantDelete, []);
  end;
begin
  if not UpdateOptions.EnableDelete then
    ErrorDelete;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.InternalFirst;
begin
  FRecordIndex := -1;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.InternalLast;
begin
  CheckFetchedAll;
  FRecordIndex := FSourceView.Rows.Count;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.InternalEdit;
begin
  StartWait;
  try
    DoProcessUpdateRequest(arLock, [uoImmediateUpd]);
    inherited InternalEdit;
  finally
    StopWait;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.InternalInsert;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoBeforeInsert;
begin
  inherited DoBeforeInsert;
  StartWait;
  try
    CheckInserting;
    if (FParentDataSet <> nil) and (FParentDataSet.State = dsInsert) then
      FParentDataSet.Post;
    FRecordIndexToInsert := GetRecIndex;
    if FRecordIndexToInsert < 0 then
      FRecordIndexToInsert := 0;
    DoProcessUpdateRequest(arLock, [uoImmediateUpd, uoNoSrvRecord,
      uoNoClntRecord]);
  finally
    StopWait;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoBeforeEdit;
begin
  CheckEditing;
  inherited DoBeforeEdit;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoBeforeDelete;
begin
  CheckDeleting;
  inherited DoBeforeDelete;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.UpdateRecordIndex;
begin
  FSourceView.ProposedPosition := -1;
  FRecordIndexToInsert := -1;
  if FSourceView.LastUpdatePosition <> -1 then
    FRecordIndex := FSourceView.LastUpdatePosition;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.InternalPost;
var
  oRow: TADDatSRow;
begin
{$IFDEF AnyDAC_D6}
  inherited InternalPost;
{$ENDIF}
  if State = dsEdit then begin
    StartWait;
    try
      oRow := GetRow;
      if oRow.RowState = rsEditing then begin
        FSourceView.ProposedPosition := FRecordIndex;
        oRow.EndEdit;
        UpdateRecordIndex;
      end;
      DoProcessUpdateRequest(arLock,   [uoImmediateUpd, uoDeferedLock]);
      DoProcessUpdateRequest(arUpdate, [uoImmediateUpd]);
      DoProcessUpdateRequest(arUnLock, [uoImmediateUpd]);
    finally
      StopWait;
    end;
  end
  else
    InternalAddRecord(ActiveBuffer, GetBookmarkFlag(ActiveBuffer) = bfEOF);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.Post;
begin
  inherited Post;
  if State = dsSetKey then
    PostKeyBuffer(True);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.InternalDelete;
begin
  StartWait;
  try
    DoProcessUpdateRequest(arLock, [uoImmediateUpd, uoOneMomLock]);
    FSourceView.ProposedPosition := FRecordIndex;
    GetRow.Delete;
    UpdateRecordIndex;
    try
      DoProcessUpdateRequest(arDelete, [uoImmediateUpd]);
    except
      on E: Exception do begin
        if not (E is EADDBEngineException) or
           (EADDBEngineException(E).Kind <> ekNoDataFound) then begin
          DoProcessUpdateRequest(arUnLock, [uoImmediateUpd, uoCancelUnlock]);
          raise;
        end;
      end;
    end;
    DoProcessUpdateRequest(arUnLock, [uoImmediateUpd, uoNoSrvRecord]);
  finally
    StopWait;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.InternalRefresh;
var
  iLastRecNo, iNewRecNo: Integer;
  sKeyFields: String;
  vLastKeyValue: Variant;
begin
  CheckBrowseMode;
  if UpdatesPending then
    ADException(Self, [S_AD_LComp, S_AD_LComp_PDS], er_AD_DSRefreshError, []);
  if Unidirectional then
    ADException(Self, [S_AD_LComp, S_AD_LComp_PDS], er_AD_DSRefreshError2, []);
  if FMasterLink.Active and (FMasterLink.Fields.Count > 0) and DoMasterDependent(FMasterLink.Fields) or
     (DataSetField <> nil) then begin
    FTable.Clear;
    if FetchOptions.Mode in [fmOnDemand, fmAll, fmExactRecsMax] then
      CheckDetailRecords;
  end
  else begin
    iLastRecNo := GetRecNo;
    sKeyFields := PSGetKeyFields;
    if sKeyFields <> ''  then
      vLastKeyValue := FieldValues[sKeyFields];
    FTable.Clear;
    DoCloseSource;
    FSourceEOF := False;
    FUnidirRecsPurged := 0;
    DoOpenSource(False, False, False);
    iNewRecNo := -1;
    if (sKeyFields <> '') and LocateRecord(sKeyFields, vLastKeyValue, [], iNewRecNo) then
      FRecordIndex := iNewRecNo
    else
      InternalSetRecNo(iLastRecNo);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.InternalCancel;
var
  oRow: TADDatSRow;
begin
  StartWait;
  try
    if State = dsEdit then begin
      oRow := GetRow;
      if oRow.RowState = rsEditing then
        oRow.CancelEdit;
      DoProcessUpdateRequest(arUnLock, [uoImmediateUpd, uoCancelUnlock])
    end
    else begin
      DoProcessUpdateRequest(arUnLock, [uoImmediateUpd, uoCancelUnlock,
        uoNoSrvRecord, uoNoClntRecord]);
      if PRecInfo(ActiveBuffer + CalcFieldsSize)^.FRow = FNewRow then
        PRecInfo(ActiveBuffer + CalcFieldsSize)^.FRow := nil;
      FreeAndNil(FNewRow);
    end;
  finally
    StopWait;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.Cancel;
begin
  inherited Cancel;
  if State = dsSetKey then
    PostKeyBuffer(False);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.InternalAddRecord(Buffer: Pointer; Append: Boolean);
begin
  StartWait;
  try
    DoProcessUpdateRequest(arLock, [uoImmediateUpd, uoNoSrvRecord, uoDeferedLock]);
    try
      if Append then begin
        InternalFetchRows(True, True);
        FSourceView.ProposedPosition := FSourceView.Rows.Count;
      end
      else
        FSourceView.ProposedPosition := FRecordIndexToInsert;
      FTable.Rows.Add(FNewRow);
      UpdateRecordIndex;
      DoProcessUpdateRequest(arInsert, [uoImmediateUpd]);
      DoProcessUpdateRequest(arUnLock, [uoImmediateUpd]);
      FNewRow := nil;
    except
      DoProcessUpdateRequest(arUnLock, [uoImmediateUpd, uoCancelUnlock,
        uoNoSrvRecord, uoNoClntRecord]); // uoNoClntRecord here because
      // in next lines we will handle FNewRow by ourself
      if (FNewRow <> nil) and (FNewRow.Owner = FTable.Rows) then
        FNewRow.Delete(True);
      raise;
    end;
  finally
    StopWait;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.InternalInitRecord(Buffer: PChar);
begin
  if State in dsEditModes then
    GetRow(Buffer).Clear(True);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.InitRecord(Buffer: PChar);
var
  oMasterRow, oParentRow: TADDatSRow;
begin
  if (MasterSource <> nil) and (MasterSource.DataSet <> nil) and
     (MasterSource.DataSet is TADDataSet) then
    oMasterRow := TADDataSet(MasterSource.DataSet).GetRow
  else
    oMasterRow := nil;
  FNewRow := FTable.NewRow(True, [oMasterRow]);
  if FParentDataSet <> nil then begin
    oParentRow := GetParentRow;
    if oParentRow <> nil then
      try
        FNewRow.ParentRow := oParentRow;
      except
        FNewRow.Free;
        FNewRow := nil;
        raise;
      end;
  end;
  inherited InitRecord(Buffer);
  with PRecInfo(Buffer + CalcFieldsSize)^ do begin
    FBookmarkFlag := bfInserted;
    FRowIndex := -1;
    FRow := FNewRow;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.EmptyDataSet;
begin
  CheckBrowseMode;
  FTable.Clear;
  Resync([]);
// ???  InitRecord(ActiveBuffer);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.CopyFields(ASource: TDataset; AExcludeNewEmptyValues: Boolean = True);
var
  i: Integer;
  oSrcField: TField;
  oDestField: TField;
  oSrcStream: TStream;
  oDestStream: TStream;
begin
  for i := 0 to ASource.FieldCount - 1 do begin
    oSrcField := ASource.Fields[i];
    oDestField := FindField(oSrcField.FieldName);
    if (oDestField = nil) or
       (AExcludeNewEmptyValues and VarIsEmpty(oSrcField.NewValue)) then
      // nothing
    else if oSrcField.IsNull then
      oDestField.Clear
    else
      case oDestField.DataType of
      ftLargeInt:
        if oSrcField.DataType = ftLargeInt then
          TLargeIntField(oDestField).AsLargeInt := TLargeIntField(oSrcField).AsLargeInt
        else
          oDestField.AsInteger := oSrcField.AsInteger;
      ftBlob,
      ftMemo,
      ftFmtMemo,
      ftOraBlob,
      ftOraClob:
        if oSrcField.DataType in [ftBlob, ftMemo, ftFmtMemo, ftOraBlob, ftOraClob] then begin
          oSrcStream := ASource.CreateBlobStream(oSrcField, bmRead);
          try
            oDestStream := CreateBlobStream(oDestField, bmWrite);
            try
              oDestStream.CopyFrom(oSrcStream, 0);
            finally
              oDestStream.Free;
            end;
          finally
            oSrcStream.Free;
          end;
        end
        else
          oDestField.AsVariant := oSrcField.AsVariant;
      else
        oDestField.AsVariant := oSrcField.AsVariant;
      end;
  end;
end;


{-------------------------------------------------------------------------------}
procedure TADDataSet.DoUpdateErrorHandler(ARow: TADDatSRow; AException: Exception;
  ARequest: TADPhysUpdateRequest; var AAction: TADErrorAction);
begin
  if (AException is EADException) and Assigned(FOnUpdateError) then begin
    if (ARow <> nil) and (GetRow <> ARow) then
      BeginForceRow(ARow, False, True);
    try
      try
        FOnUpdateError(Self, EADException(AException), ARow, ARequest, AAction);
      except
        InternalHandleException;
        AAction := eaFail;
      end;
    finally
      if (ARow <> nil) and IsForceRowMode then
        EndForceRow;
    end;
  end
  else
    AAction := eaDefault;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoUpdateRecordHandler(ARow: TADDatSRow;
  ARequest: TADPhysUpdateRequest; AOptions: TADPhysUpdateRowOptions;
  var AAction: TADErrorAction);
begin
  if Assigned(OnUpdateRecord) then begin
    if (ARow <> nil) and (GetRow <> ARow) then
      BeginForceRow(ARow, False, True);
    try
      try
        AAction := eaApplied;
        OnUpdateRecord(Self, ARequest, AAction, AOptions);
      except
        InternalHandleException;
        AAction := eaFail;
      end;
    finally
      if (ARow <> nil) and IsForceRowMode then
        EndForceRow;
    end;
  end
  else
    AAction := eaDefault;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoReconcileErrorHandler(ARow: TADDatSRow;
  AException: EADException; AUpdateKind: TADDatSRowState;
  var AAction: TADDAptReconcileAction);
begin
  if Assigned(FOnReconcileError) then begin
    if (ARow <> nil) and (GetRow <> ARow) then
      BeginForceRow(ARow, False, True);
    try
      try
        FOnReconcileError(Self, AException, AUpdateKind, AAction);
      except
        InternalHandleException;
        AAction := raSkip;
      end;
    finally
      if (ARow <> nil) and IsForceRowMode then
        EndForceRow;
    end;
  end
  else
    AAction := raMerge;
end;

{-------------------------------------------------------------------------------}
{ Bookmarks}

procedure TADDataSet.InternalGotoBookmark(Bookmark: TBookmark);
var
  i: Integer;
begin
  i := FSourceView.IndexOf(PADDatSRow(Bookmark)^);
  if (i = -1) and not FLockNoBMK then
    ADException(Self, [S_AD_LComp, S_AD_LComp_PDS], er_AD_DSNoNookmark, []);
  FRecordIndex := i;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.InternalSetToRecord(Buffer: PChar);
var
  oRow: TADDatSRow;
begin
  if GetBookmarkFlag(Buffer) in [bfInserted, bfEOF, bfBOF] then
    FRecordIndex := FSourceView.Rows.Count
  else begin
    oRow := GetRow(Buffer, True);
    InternalGotoBookmark(@oRow);
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetBookmarkFlag(Buffer: PChar): TBookmarkFlag;
begin
  Result := PRecInfo(Buffer + CalcFieldsSize).FBookmarkFlag;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetBookmarkFlag(Buffer: PChar; AValue: TBookmarkFlag);
begin
  PRecInfo(Buffer + CalcFieldsSize).FBookmarkFlag := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.GetBookmarkData(Buffer: PChar; Data: Pointer);
begin
  PADDatSRow(Data)^ := GetRow(Buffer, True);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetBookmarkData(Buffer: PChar; Data: Pointer);
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
function TADDataSet.CompareBookmarks(Bookmark1, Bookmark2: TBookmark): Integer;
const
  RetCodes: array[Boolean, Boolean] of ShortInt = ((2, -1), (1, 0));
var
  i1, i2: Integer;
begin
  Result := RetCodes[Bookmark1 = nil, Bookmark2 = nil];
  if Result = 2 then begin
    i1 := FSourceView.IndexOf(PADDatSRow(Bookmark1)^);
    i2 := FSourceView.IndexOf(PADDatSRow(Bookmark2)^);
    if i1 < i2 then
      Result := -1
    else if i1 > i2 then
      Result := 1
    else
      Result := 0;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.BookmarkValid(Bookmark: TBookmark): Boolean;
begin
  Result := (FSourceView.IndexOf(PADDatSRow(Bookmark)^) <> -1);
end;

{-------------------------------------------------------------------------------}
{ Aggregates }

procedure TADDataSet.SetAggregates(const AValue: TADAggregates);
begin
  FAggregates.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.IsA: Boolean;
begin
  Result := FAggregates.Count > 0;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetAggregatesActive(const AValue: Boolean);
begin
  if FAggregatesActive <> AValue then begin
    FAggregatesActive := AValue;
    if FAggregatesActive and Active then begin
      FAggregates.Build;
      FFieldAggregates.Build;
    end
    else begin
      FAggregates.Release;
      FFieldAggregates.Release;
    end;
    DataEvent(deRecordChange, 0);
  end;
end;

{$IFNDEF AnyDAC_FPC}
{-------------------------------------------------------------------------------}
function TADDataSet.GetAggregateValue(AField: TField): Variant;
var
  oAgg: TADAggregate;
  oAggFld: TAggregateField;
begin
  oAggFld := AField as TAggregateField;
  oAgg := TADAggregate(oAggFld.Handle);
  if oAgg <> nil then
    Result := oAgg.Value;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.ResetAggField(AField: TField);
var
  oAgg: TADAggregate;
  oAggFld: TAggregateField;
begin
  if AggFields.IndexOf(AField) <> -1 then begin
    oAggFld := AField as TAggregateField;
    oAgg := TADAggregate(oAggFld.Handle);
    if oAgg <> nil then begin
      oAgg.Active := False;
      oAgg.Assign(oAggFld);
    end;
  end;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetViewAggregates;
{$IFNDEF AnyDAC_FPC}
var
  i: Integer;
  oAggFld: TAggregateField;
  oAgg: TADAggregate;
{$ENDIF}
begin
{$IFNDEF AnyDAC_FPC}
  for i := 0 to AggFields.Count - 1 do begin
    oAggFld := AggFields[i] as TAggregateField;
    oAgg := FFieldAggregates.Add;
    oAggFld.Handle := oAgg;
    oAgg.Assign(oAggFld);
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.ResetViewAggregates;
{$IFNDEF AnyDAC_FPC}
var
  i: Integer;
  oAggFld: TAggregateField;
  oAgg: TADAggregate;
{$ENDIF}
begin
{$IFNDEF AnyDAC_FPC}
  for i := 0 to AggFields.Count - 1 do begin
    oAggFld := AggFields[i] as TAggregateField;
    oAgg := TADAggregate(oAggFld.Handle);
    oAggFld.Handle := nil;
    oAgg.Free;
  end;
{$ENDIF}
  Aggregates.Release;
  FFieldAggregates.Release;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetGroupingLevel: Integer;
begin
  if FAggregates.GroupingLevel > FFieldAggregates.GroupingLevel then
    Result := FAggregates.GroupingLevel
  else
    Result := FFieldAggregates.GroupingLevel;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetGroupState(ALevel: Integer): TGroupPosInds;
begin
  if not (State in [dsInactive, dsOpening, dsInsert, dsSetKey]) and
     AggregatesActive and (IndexName <> '') then begin
    UpdateCursorPos;
    Result := TGroupPosInds(FSourceView.GetGroupState(FRecordIndex, ALevel));
  end
  else
    Result := [];
end;

{-------------------------------------------------------------------------------}
{ Indexes / keys / ranges }

procedure TADDataSet.SetIndexes(const AValue: TADIndexes);
begin
  FIndexes.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.IsIS: Boolean;
begin
  Result := FIndexes.Count > 0;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetIndexDefs(const AValue: TIndexDefs);
begin
  FIndexDefs.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.IsIDS: Boolean;
begin
  Result := FIndexDefs.Count > 0;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetIndexesActive(const AValue: Boolean);
begin
  if FIndexesActive <> AValue then begin
    FIndexesActive := AValue;
    if FIndexesActive then
      FIndexes.Build
    else
      FIndexes.Release;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetIndexName(const AValue: String);
begin
  if IndexName <> AValue then begin
    FIndexName := AValue;
    FIndexFieldNames := '';
    if Active then
      try
        DoSortOrderChanged;
        SwitchToIndex('', AValue);
      except
        IndexName := '';
        raise;
      end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetIndexFieldNames(const AValue: String);
begin
  if IndexFieldNames <> AValue then begin
    FIndexName := '';
    FIndexFieldNames := AValue;
    if Active then
      try
        DoSortOrderChanged;
        SwitchToIndex(AValue, '');
      except
        IndexFieldNames := '';
        raise;
      end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.LocateRecord(const AKeyFields: string;
  const AKeyValues: Variant; AOptions: TLocateOptions; var AIndex: Integer): Boolean;
var
  V: Variant;
  oFld: TField;
  opts: TADLocateOptions;
begin
  CheckFetchedAll;
  if FLocateRow = nil then begin
    FLocateRow := FTable.NewRow(False);
    FLocateColumns := TADDatSColumnSublist.Create;
  end;
  opts := [];
  if loCaseInsensitive in AOptions then
    Include(opts, loNoCase);
  if loPartialKey in AOptions then
    Include(opts, loPartial);
  if AKeyFields <> FLocateColumns.Names then
    FLocateColumns.Fill(FTable, AKeyFields);
  BeginForceRow(FLocateRow, True, True);
  try
    if FLocateColumns.Count = 1 then begin
      if VarIsArray(AKeyValues) then
        V := AKeyValues[0]
      else
        V := AKeyValues;
      oFld := FieldByName(AKeyFields);
{$IFDEF AnyDAC_D6Base}
      if oFld.DataType = ftLargeInt then
        TLargeIntField(oFld).Value := V
{$ELSE}
      if (oFld.DataType = ftLargeInt) and (VarType(V) = varInt64) then
        TLargeIntField(oFld).Value := Decimal(V).lo64
{$ENDIF}
      else
        oFld.Value := V;
    end
    else
      FieldValues[AKeyFields] := AKeyValues;
  finally
    EndForceRow;
  end;
  Result := False;
  FSourceView.Search(FLocateRow, FLocateColumns, nil, -1, opts, AIndex, Result);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.Locate(const AKeyFields: string; const AKeyValues: Variant;
  AOptions: TLocateOptions): Boolean;
var
  iPos: Integer;
begin
  DoBeforeScroll;
  CheckBrowseMode;
  CursorPosChanged;
  UpdateCursorPos;
  iPos := -1;
  Result := LocateRecord(AKeyFields, AKeyValues, AOptions, iPos);
  if Result then begin
    FRecordIndex := iPos;
    Resync([rmExact, rmCenter]);
    DoAfterScroll;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.Lookup(const AKeyFields: string; const AKeyValues: Variant;
  const AResultFields: string): Variant;
var
  iPos: Integer;
begin
  CheckBrowseMode;
  CursorPosChanged;
  UpdateCursorPos;
  iPos := -1;
  if LocateRecord(AKeyFields, AKeyValues, [], iPos) then begin
    BeginForceRow(FSourceView.Rows.ItemsI[iPos], False, True);
    try
      Result := FieldValues[AResultFields];
    finally
      EndForceRow;
    end;
  end
  else
    Result := Null;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetIndexFieldCount: Integer;
begin
  Result := 0;
  if (FSortView <> nil) and (FSortView.SortingMechanism <> nil) then
    Result := FSortView.SortingMechanism.SortColumnList.Count;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetIndexField(AIndex: Integer): TField;
begin
  Result := nil;
  if (FSortView <> nil) and (FSortView.SortingMechanism <> nil) then
    Result := FieldByName(FSortView.SortingMechanism.SortColumnList.ItemsI[AIndex].Name);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetIsIndexField(AField: TField): Boolean;
begin
  if (FSortView <> nil) and (FSortView.SortingMechanism <> nil) then
    Result := FSortView.SortingMechanism.SortColumnList.FindColumn(AField.FieldName) <> nil
  else
    Result := False;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.CheckSetKeyMode;
begin
  if State <> dsSetKey then
    DatabaseError(SNotEditing, Self);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.CheckIndexed;
begin
  if FSortView = nil then
    DatabaseError(SNoFieldIndexes, Self);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.AllocKeyBuffers;
var
  i: TADKeyIndex;
begin
  if FKeyBuffersAllocated then
    Exit;
  try
    for i := Low(TADKeyIndex) to High(TADKeyIndex) do begin
      GetMem(FKeyBuffers[i], SizeOf(TADKeyBuffer) + FBufferSize);
      FKeyBuffersAllocated := True;
      InitKeyBuffer(FKeyBuffers[i]);
    end;
  except
    FreeKeyBuffers;
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.FreeKeyBuffers;
var
  i: TADKeyIndex;
  oRow: TADDatSRow;
  pBuff: PADKeyBuffer;
begin
  if not FKeyBuffersAllocated then
    Exit;
  FKeyBuffersAllocated := False;
  for i := Low(TADKeyIndex) to High(TADKeyIndex) do begin
    pBuff := GetKeyBuffer(i, False);
    if pBuff <> nil then begin
      oRow := GetKeyRow(pBuff);
      if oRow <> nil then
        oRow.Free;
      FreeMem(pBuff, SizeOf(TADKeyBuffer) + FBufferSize);
      FKeyBuffers[i] := nil;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetKeyRow(ABuffer: PADKeyBuffer): TADDatSRow;
begin
  Result := GetRow(PChar(ABuffer) + SizeOf(TADKeyBuffer), True);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetKeyRow(ABuffer: PADKeyBuffer; ARow: TADDatSRow);
begin
  PRecInfo(PChar(ABuffer) + SizeOf(TADKeyBuffer) + CalcFieldsSize)^.FRow := ARow;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetKeyBuffer(AKeyIndex: TADKeyIndex; ACheckCreateRow: Boolean = True): PADKeyBuffer;
var
  oRow: TADDatSRow;
begin
  if ACheckCreateRow and (GetKeyRow(FKeyBuffers[AKeyIndex]) = nil) then begin
    oRow := FTable.NewRow(False);
    oRow.BeginForceWrite;
    SetKeyRow(FKeyBuffers[AKeyIndex], oRow);
  end;
  Result := FKeyBuffers[AKeyIndex];
end;

{-------------------------------------------------------------------------------}
function TADDataSet.InitKeyBuffer(ABuffer: PADKeyBuffer): PADKeyBuffer;
begin
  ADFillChar(ABuffer^, SizeOf(TADKeyBuffer) + FBufferSize, #0);
  Result := ABuffer;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.ClearKeyBuffer(ABuffer: PADKeyBuffer): PADKeyBuffer;
var
  oRow: TADDatSRow;
begin
  oRow := GetKeyRow(ABuffer);
  Result := InitKeyBuffer(ABuffer);
  SetKeyRow(ABuffer, oRow);
  if oRow <> nil then
    oRow.Clear(False);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.AssignKeyBuffer(ADest, ASrc: PADKeyBuffer);
var
  oSrcRow: TADDatSRow;
  oDestRow: TADDatSRow;
begin
  ADMove(ASrc^, ADest^, SizeOf(TADKeyBuffer) + CalcFieldsSize);
  ADMove((PChar(ASrc) + SizeOf(TADKeyBuffer) + CalcFieldsSize + SizeOf(PADDatSRow))^,
         (PChar(ADest) + SizeOf(TADKeyBuffer) + CalcFieldsSize + SizeOf(PADDatSRow))^,
         FBufferSize - CalcFieldsSize - SizeOf(PADDatSRow));
  oSrcRow := GetKeyRow(ASrc);
  oDestRow := GetKeyRow(ADest);
  if oSrcRow = nil then
    SetKeyRow(ADest, nil)
  else begin
    if oDestRow = nil then begin
      oDestRow := FTable.NewRow(False);
      oDestRow.BeginForceWrite;
      SetKeyRow(ADest, oDestRow);
    end;
    FTable.Import(oSrcRow, oDestRow);
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.CompareKeyBuffer(ABuff1, ABuff2: PADKeyBuffer): Boolean;
var
  oRow1, oRow2: TADDatSRow;
  oColumns: TADDatSColumnSublist;
  s: String;
  oCache: TADDatSCompareRowsCache;
begin
  if (ABuff1^.Exclusive <> ABuff2^.Exclusive) or (ABuff1^.FieldCount <> ABuff2^.FieldCount) then
    Result := False
  else begin
    oRow1 := GetKeyRow(ABuff1);
    oRow2 := GetKeyRow(ABuff2);
    oColumns := TADDatSColumnSublist.Create;
    try
      if IndexFieldNames <> '' then
        s := IndexFieldNames
      else
        s := Indexes.FindIndex(IndexName).Fields;
      oColumns.Fill(FTable, s);
      oCache := nil;
      Result := (oRow1.CompareRows(oColumns, nil, nil, -1, oRow2,
        nil, rvDefault, [], oCache) = 0);
    finally
      oColumns.Free;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetKeyBuffer(AKeyIndex: TADKeyIndex; AClear: Boolean);
begin
  CheckBrowseMode;
  CheckIndexed;
  FKeyBuffer := GetKeyBuffer(AKeyIndex);
  AssignKeyBuffer(GetKeyBuffer(kiSave), FKeyBuffer);
  if AClear then
    ClearKeyBuffer(FKeyBuffer);
  SetState(dsSetKey);
  SetModified(FKeyBuffer^.Modified);
  DataEvent(deDataSetChange, 0);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetKeyExclusive: Boolean;
begin
  CheckSetKeyMode;
  Result := FKeyBuffer^.Exclusive;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetKeyExclusive(AValue: Boolean);
begin
  CheckSetKeyMode;
  FKeyBuffer^.Exclusive := AValue;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetKeyFieldCount: Integer;
begin
  CheckSetKeyMode;
  Result := FKeyBuffer^.FieldCount;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetKeyFieldCount(AValue: Integer);
begin
  CheckSetKeyMode;
  FKeyBuffer^.FieldCount := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetKeyFields(AKeyIndex: TADKeyIndex; const AValues: array of const);
var
  i: Integer;
  iSaveState: TDataSetState;
begin
  CheckIndexed;
  iSaveState := SetTempState(dsSetKey);
  try
    FKeyBuffer := ClearKeyBuffer(GetKeyBuffer(AKeyIndex));
    for i := 0 to High(AValues) do
      GetIndexField(i).AssignValue(AValues[i]);
    FKeyBuffer^.FieldCount := High(AValues) + 1;
    FKeyBuffer^.Modified := Modified;
  finally
    RestoreState(iSaveState);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.PostKeyBuffer(ACommit: Boolean);
begin
  CheckIndexed;
  DataEvent(deCheckBrowseMode, 0);
  if ACommit then
    FKeyBuffer^.Modified := Modified
  else
    AssignKeyBuffer(FKeyBuffer, GetKeyBuffer(kiSave));
  SetState(dsBrowse);
  DataEvent(deDataSetChange, 0);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetKey;
begin
  SetKeyBuffer(kiLookup, True);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.EditKey;
begin
  SetKeyBuffer(kiLookup, False);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.FindKey(const AKeyValues: array of const): Boolean;
begin
  CheckBrowseMode;
  SetKeyFields(kiLookup, AKeyValues);
  Result := GotoKey;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.FindNearest(const AKeyValues: array of const);
begin
  CheckBrowseMode;
  SetKeyFields(kiLookup, AKeyValues);
  GotoNearest;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.InternalGotoKey(ANearest: Boolean): Boolean;
var
  iPos: Integer;
  oRow: TADDatSRow;
  keyBuff: PADKeyBuffer;
  opts: TADLocateOptions;
  iFldCnt: Integer;
begin
  CheckBrowseMode;
  CheckIndexed;
  DoBeforeScroll;
  CursorPosChanged;
  CheckFetchedAll;
  keyBuff := GetKeyBuffer(kiLookup);
  oRow := GetKeyRow(keyBuff);
  if FKeyBuffer^.FieldCount <= 0 then
    iFldCnt := FSortView.SortingMechanism.SortColumnList.Count
  else
    iFldCnt := FKeyBuffer^.FieldCount;
  if ANearest then
    opts := [loNearest, loLast]
  else
    opts := [];
  iPos := -1;
  Result := False;
  FSourceView.Search(oRow, FSortView.SortingMechanism.SortColumnList, nil,
    iFldCnt, opts, iPos, Result);
  if Result or ANearest then begin
    if iPos >= FSourceView.Rows.Count then
      iPos := FSourceView.Rows.Count - 1;
    FRecordIndex := iPos;
    Resync([rmExact, rmCenter]);
    DoAfterScroll;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GotoKey: Boolean;
begin
  Result := InternalGotoKey(False);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.GotoNearest;
begin
  InternalGotoKey(True);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.ApplyRange;
begin
  CheckBrowseMode;
  if SetCursorRange then
    FilteringUpdated;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.CancelRange;
begin
  CheckBrowseMode;
  UpdateCursorPos;
  if ResetCursorRange then
    FilteringUpdated;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.EditRangeStart;
begin
  SetKeyBuffer(kiRangeStart, False);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.EditRangeEnd;
begin
  SetKeyBuffer(kiRangeEnd, False);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetRangeStart;
begin
  SetKeyBuffer(kiRangeStart, True);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetRangeEnd;
begin
  SetKeyBuffer(kiRangeEnd, True);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetRange(const AStartValues, AEndValues: array of const);
begin
  CheckBrowseMode;
  SetKeyFields(kiRangeStart, AStartValues);
  SetKeyFields(kiRangeEnd, AEndValues);
  ApplyRange;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.SetCursorRange: Boolean;
var
  keyBuff: PADKeyBuffer;
begin
  Result := False;
  if FKeyBuffersAllocated and not (
    CompareKeyBuffer(GetKeyBuffer(kiRangeStart), GetKeyBuffer(kiCurRangeStart)) and
    CompareKeyBuffer(GetKeyBuffer(kiRangeEnd), GetKeyBuffer(kiCurRangeEnd))) then
  begin
    keyBuff := GetKeyBuffer(kiRangeStart);
    if keyBuff^.Modified then begin
      FRangeFrom := GetKeyRow(keyBuff);
      FRangeFromExclusive := keyBuff^.Exclusive;
      FRangeFromFieldCount := keyBuff^.FieldCount;
      if FRangeFromFieldCount = 0 then
        FRangeFromFieldCount := -1;
    end
    else if FRangeFrom <> nil then
      FRangeFrom := nil;
    keyBuff := GetKeyBuffer(kiRangeEnd);
    if keyBuff^.Modified then begin
      FRangeTo := GetKeyRow(keyBuff);
      FRangeToExclusive := keyBuff^.Exclusive;
      FRangeToFieldCount := keyBuff^.FieldCount;
      if FRangeToFieldCount = 0 then
        FRangeToFieldCount := -1;
    end
    else if FRangeTo <> nil then
      FRangeTo := nil;
    AssignKeyBuffer(GetKeyBuffer(kiCurRangeStart), GetKeyBuffer(kiRangeStart));
    AssignKeyBuffer(GetKeyBuffer(kiCurRangeEnd), GetKeyBuffer(kiRangeEnd));
    Result := True;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.ResetCursorRange: Boolean;
begin
  Result := False;
  if FKeyBuffersAllocated and (
     GetKeyBuffer(kiCurRangeStart, False)^.Modified or
     GetKeyBuffer(kiCurRangeEnd, False)^.Modified
    ) then
  begin
    if FRangeFrom <> nil then
      FRangeFrom := nil;
    if FRangeTo <> nil then
      FRangeTo := nil;
    ClearKeyBuffer(GetKeyBuffer(kiCurRangeStart));
    ClearKeyBuffer(GetKeyBuffer(kiCurRangeEnd));
    Result := True;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetRanged: Boolean;
begin
  Result := (FRangeFrom <> nil) or (FRangeTo <> nil);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetRanged(const AValue: Boolean);
begin
  if AValue <> Ranged then
    if AValue then
      ApplyRange
    else
      CancelRange;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.AddIndex(const AName, AFields, AExpression: string;
  AOptions: TADSortOptions; const ADescFields, ACaseInsFields: string);
begin
  if Indexes.FindIndex(AName) = nil then begin
    with Indexes.Add do begin
      Name := AName;
      if AFields <> '' then begin
        Fields := AFields;
        DescFields := ADescFields;
        CaseInsFields := ACaseInsFields;
      end
      else if AExpression <> '' then
        Expression := AExpression;
      Options := AOptions;
      Active := True;
    end;
  end
  else
    ADException(Self, [S_AD_LComp, S_AD_LComp_PDS], er_AD_DuplicatedName, []);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DeleteIndex(const AName: string);
begin
  Indexes.IndexByName(AName).Free;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DeleteIndexes;
begin
  Indexes.Clear;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.GetIndexNames(AList: TStrings);
{$IFDEF AnyDAC_FPC}
var
  I: Integer;
{$ENDIF}
begin
  if not IndexDefs.Updated then
    IndexDefs.Update;
{$IFNDEF AnyDAC_FPC}
  IndexDefs.GetItemNames(AList);
{$ELSE}
  AList.BeginUpdate;
  try
    AList.Clear;
    for I := 0 to IndexDefs.Count - 1 do
      with IndexDefs[i] do
        if Name <> '' then
          AList.Add(Name);
  finally
    AList.EndUpdate;
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
{ Filters }

procedure TADDataSet.RealFilteringUpdated;
begin
  try
    FilteringUpdated;
  except
    Filtered := False;
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetFilterOptions(AValue: TFilterOptions);
begin
  if AValue <> FilterOptions then begin
    inherited SetFilterOptions(AValue);
    if Filtered then
      RealFilteringUpdated;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetFilterText(const AValue: string);
begin
  if AValue <> Filter then begin
    inherited SetFilterText(AValue);
    if Filtered then
      RealFilteringUpdated;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetFiltered(AValue: Boolean);
begin
  if AValue <> Filtered then begin
    inherited SetFiltered(AValue);
    RealFilteringUpdated;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetOnFilterRecord(const AValue: TFilterRecordEvent);
begin
  if (TMethod(AValue).Code <> TMethod(OnFilterRecord).Code) or
     (TMethod(AValue).Data <> TMethod(OnFilterRecord).Data) then begin
    inherited SetOnFilterRecord(AValue);
    if Filtered then
      RealFilteringUpdated;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.DoFilterRow(AMech: TADDatSMechFilter;
  ARow: TADDatSRow; AVersion: TADDatSRowVersion): Boolean;
var
  iSaveState: TDataSetState;
begin
  iSaveState := SetTempState(dsFilter);
  BeginForceRow(ARow, False, True);
  try
    Result := True;
    OnFilterRecord(Self, Result);
  except
    InternalHandleException;
  end;
  EndForceRow;
  RestoreState(iSaveState);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetUpdateRecordTypes(const AValue: TUpdateRecordTypes);
begin
  CheckCachedUpdatesMode;
  if FUpdateRecordTypes <> AValue then begin
    FUpdateRecordTypes := AValue;
    FilteringUpdated;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.FindRecord(Restart, GoForward: Boolean): Boolean;
var
  oFlt: TADDatSMechFilter;
begin
  CheckBrowseMode;
  DoBeforeScroll;
  SetFound(False);
  UpdateCursorPos;
  CursorPosChanged;
  CheckFetchedAll;
  oFlt := nil;
  try
    if not Filtered then begin
      oFlt := CreateFilterMech;
      oFlt.Locator := True;
      FSourceView.Mechanisms.Add(oFlt);
    end;
    Result := FSourceView.Locate(FRecordIndex, GoForward, Restart);
  finally
    if oFlt <> nil then
      oFlt.Free;
  end;
  if Result then begin
    Resync([rmExact, rmCenter]);
    SetFound(True);
    DoAfterScroll;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.CreateExpression(const AExpr: String;
  AOptions: TADExpressionOptions = []): IADStanExpressionEvaluator;
var
  oParser: IADStanExpressionParser;
begin
  ADCreateInterface(IADStanExpressionParser, oParser);
  Result := oParser.Prepare(TADDatSTableExpressionDS.Create(FTable),
    AExpr, AOptions, [poDefaultExpr], '');
  Result.DataSource.Position := GetRow;
end;

{-------------------------------------------------------------------------------}
{ Constraints }

function TADDataSet.IsCS: Boolean;
begin
  Result := Constraints.Count > 0;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DisableConstraints;
begin
  if FConstDisableCount = 0 then
    if FTable <> nil then
      FTable.Constraints.Enforce := False;
  Inc(FConstDisableCount);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.EnableConstraints;
begin
  if FConstDisableCount > 0 then begin
    Dec(FConstDisableCount);
    if FConstDisableCount = 0 then
      if FTable <> nil then
        FTable.Constraints.Enforce := True;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetConstraintsEnabled: Boolean;
begin
  Result := FConstDisableCount = 0;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetConstraintsEnabled(const AValue: Boolean);
begin
  if AValue <> ConstraintsEnabled then
    if AValue then
      while not ConstraintsEnabled do
        EnableConstraints
    else
      while ConstraintsEnabled do
        DisableConstraints;
end;

{-------------------------------------------------------------------------------}
{ Cloning }

procedure TADDataSet.GotoCurrent(ADataSet: TADDataSet);
begin
  CheckBrowseMode;
  CheckFetchedAll;
  ADataSet.CheckActive;
  BookMark := ADataSet.BookMark;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoCloneCursor(AReset, AKeepSettings: Boolean);
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.CloneCursor(ASource: TADDataSet; AReset,
  AKeepSettings: Boolean);
begin
  ASource.CheckActive;
  ASource.UpdateCursorPos;
  AttachTable(ASource.FTable, ASource.FView);
  FCloneSource := ASource;
  FParentDataSet := ASource.FParentDataSet;
  if AReset then begin
    Filtered := False;
    Filter := '';
    OnFilterRecord := nil;
    IndexName := '';
    MasterSource := nil;
    MasterFields := '';
    UpdateOptions.ReadOnly := False;
  end
  else if not AKeepSettings then begin
    Filter := ASource.Filter;
    OnFilterRecord := ASource.OnFilterRecord;
    FilterOptions := ASource.FilterOptions;
    Filtered := ASource.Filtered;
    if ASource.IndexName <> '' then
      IndexName := ASource.IndexName
    else
      IndexFieldNames := ASource.IndexFieldNames;
    MasterSource := ASource.MasterSource;
    MasterFields := ASource.MasterFields;
    UpdateOptions.ReadOnly := ASource.UpdateOptions.ReadOnly;
  end;
  DoCloneCursor(AReset, AKeepSettings);
  Open;
//  SetNotifyCallback;
//  Source.SetNotifyCallback;
// ?????????????????????????????????????
end;

{-------------------------------------------------------------------------------}
{ Dataset creating }

procedure TADDataSet.InitColumnsFromFieldDefs(ADefs: TFieldDefs; ATable: TADDatSTable;
  ADatSManager: TADDatSManager);
var
  i: Integer;
  oDef: TFieldDef;
  oCol: TADDatSColumn;
  eDestDataType: TADDataType;
  iDestScale, iDestPrec: Integer;
  iDestSize: LongWord;
  esDestAttrs: TADDataAttributes;
{$IFNDEF AnyDAC_FPC}
  oChildTab: TADDatSTable;
  oChildTabRelCol: TADDatSColumn;
  oRel: TADDatSRelation;
{$ENDIF}
begin
  for i := 0 to ADefs.Count - 1 do begin
    oDef := ADefs[i];
    eDestDataType := dtUnknown;
    iDestScale := 0;
    iDestPrec := 0;
    iDestSize := 0;
    esDestAttrs := [];
    FormatOptions.FieldDef2ColumnDef(oDef.DataType, oDef.Size, oDef.Precision,
      eDestDataType, iDestScale, iDestPrec, iDestSize, esDestAttrs);

    oCol := TADDatSColumn.Create;
    oCol.Name := oDef.Name;
    oCol.DataType := eDestDataType;
    oCol.Size := iDestSize;
    oCol.Precision := iDestPrec;
    oCol.Scale := iDestScale;
    if not (faRequired in oDef.Attributes) then
      Include(esDestAttrs, caAllowNull);
    if faReadonly in oDef.Attributes then
      Include(esDestAttrs, caReadOnly);
    if faHiddenCol in oDef.Attributes then
      Include(esDestAttrs, caInternal);
    if faUnnamed in oDef.Attributes then
      Include(esDestAttrs, caUnnamed);
    if oDef.InternalCalcField then
      Include(esDestAttrs, caCalculated);
    if not (eDestDataType in [dtRowSetRef, dtCursorRef, dtRowRef, dtArrayRef]) then
      Include(esDestAttrs, caSearchable);
    oCol.Attributes := esDestAttrs;
    if oDef.DataType = ftAutoInc then
      oCol.AutoIncrement := True;
    ATable.Columns.Add(oCol);

{$IFNDEF AnyDAC_FPC}
    if (ADatSManager <> nil) and (eDestDataType in [dtRowSetRef, dtCursorRef, dtRowRef, dtArrayRef]) then begin
      oChildTab := TADDatSTable.Create;
      oChildTab.CountRef;
      oChildTab.Name := ADatSManager.Tables.BuildUniqueName(
        C_AD_SysNamePrefix + '#' + ATable.Name + '#' + oCol.Name);
      ADatSManager.Tables.Add(oChildTab);
      InitColumnsFromFieldDefs(oDef.ChildDefs, oChildTab, ADatSManager);

      oChildTabRelCol := TADDatSColumn.Create;
      oChildTabRelCol.Name := oChildTab.Columns.BuildUniqueName(
        C_AD_SysNamePrefix + '#' + oCol.Name);
      oChildTabRelCol.DataType := dtParentRowRef;
      oChildTabRelCol.Attributes := oCol.Attributes + [caInternal] - [caSearchable];
      oChildTab.Columns.Add(oChildTabRelCol);

      oRel := TADDatSRelation.Create;
      oRel.Name := ADatSManager.Relations.BuildUniqueName(
        C_AD_SysNamePrefix + '#' + ATable.Name + '#' + oCol.Name);
      oRel.Nested := True;
      oRel.ParentTable := ATable;
      oRel.ParentColumnNames := oCol.Name;
      oRel.ChildTable := oChildTab;
      oRel.ChildColumnNames := oChildTabRelCol.Name;
      ADatSManager.Relations.Add(oRel);
    end;
{$ENDIF}
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoCreateDataSet;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.CreateDataSet;
var
  oTab: TADDatSTable;
  oSch: TADDatSManager;
begin
  CheckInactive;
{$IFNDEF AnyDAC_FPC}
  InitFieldDefsFromFields;
{$ENDIF}
  oTab := TADDatSTable.Create;
  oSch := DoGetDatSManager;
  try
    oTab.CountRef;
    if oSch <> nil then begin
      oTab.Name := oSch.Tables.BuildUniqueName(Name);
      oSch.Tables.Add(oTab);
    end
    else
      oTab.Name := Name;
    InitColumnsFromFieldDefs(FieldDefs, oTab, oSch);
  except
    oTab.Free;
    raise;
  end;
  AttachTable(oTab, nil);
  oTab.RemRef;
{$IFNDEF AnyDAC_FPC}
  if State = dsOpening then
    OpenCursorComplete
  else
{$ENDIF}
    Open;
end;

{-------------------------------------------------------------------------------}
{ Delta management }

type
  TADDataSetIntfImpl = class(TInterfacedObject, IADDataSet)
  private
    FView: TADDatSView;
    FOwnView: Boolean;
  protected
    { IADDataSet }
    function GetDataView: TADDatSView;
  public
    constructor Create(AView: TADDatSView; AOwnView: Boolean);
    destructor Destroy; override;
  end;

{-------------------------------------------------------------------------------}
constructor TADDataSetIntfImpl.Create(AView: TADDatSView;
  AOwnView: Boolean);
begin
  inherited Create;
  FView := AView;
  FOwnView := AOwnView;
end;

{-------------------------------------------------------------------------------}
destructor TADDataSetIntfImpl.Destroy;
begin
  if FOwnView and (FView <> nil) then
    FView.Free;
  FView := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADDataSetIntfImpl.GetDataView: TADDatSView;
begin
  Result := FView;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetData: IADDataSet;
begin
  if FView <> nil then
    Result := TADDataSetIntfImpl.Create(FView, False)
  else if FTable <> nil then
    Result := TADDataSetIntfImpl.Create(FTable.DefaultView, False)
  else
    Result := TADDataSetIntfImpl.Create(nil, False);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetFilteredData: IADDataSet;
begin
  if FSourceView <> nil then
    Result := TADDataSetIntfImpl.Create(FSourceView, False)
  else
    Result := GetData;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetDataView: TADDatSView;
begin
  Result := FilteredData.GetDataView;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetData(const AValue: IADDataSet);
begin
  Close;
  if (FTable <> nil) and (AValue <> nil) and (AValue.DataView <> nil) and
     (AValue.DataView.Table <> FTable) then begin
    FTable.Reset;
    FTable.Import(AValue.DataView);
    Open;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetDelta: IADDataSet;
var
  oView: TADDatSView;
begin
  if FTable <> nil then begin
    oView := FTable.GetChangesView();
    oView.Creator := vsDataSetDelta;
    Result := TADDataSetIntfImpl.Create(oView, True);
  end
  else
    Result := TADDataSetIntfImpl.Create(nil, False);
end;

{-------------------------------------------------------------------------------}
{ Cached updates }

procedure TADDataSet.CheckCachedUpdatesMode;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
function TADDataSet.DoApplyUpdates(ATable: TADDatSTable; AMaxErrors: Integer): Integer;
begin
  // nothing
  Result := 0;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetCachedUpdates(const AValue: Boolean);
begin
  if FCachedUpdates <> AValue then begin
    if not AValue and UpdatesPending then // ???
      raise Exception.Create('Dataset has updated rows. Cant turn off cached updates mode');
    FCachedUpdates := AValue;
    if CachedUpdates then
      FetchOptions.Cache := FetchOptions.Cache + [fiDetails];
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetUpdates: TADDatSUpdatesJournal;
begin
  Result := nil;
  if FTable <> nil then begin
    if FTable.UpdatesRegistry then
      Result := FTable.Updates
    else if (FTable.Manager <> nil) and FTable.Manager.UpdatesRegistry then
      Result := FTable.Manager.Updates;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetSavePoint: Integer;
begin
  CheckBrowseMode;
  CheckCachedUpdatesMode;
  if Updates <> nil then
    Result := Updates.SavePoint
  else
    Result := -1;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetSavePoint(const AValue: Integer);
begin
  Cancel;
  CheckBrowseMode;
  CheckCachedUpdatesMode;
  UpdateCursorPos;
  if (AValue <> -1) and (Updates <> nil) then begin
    Updates.SavePoint := AValue;
    CursorPosChanged;
    Resync([]);
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetUpdatesPending: Boolean;
begin
  Result := False;
  if Active and (Updates <> nil) then
    Result := Updates.FirstChange(FTable) <> nil;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetChangeCount: Integer;
var
  oRow: TADDatSRow;
begin
  Result := 0;
  if Active and (Updates <> nil) then begin
    oRow := Updates.FirstChange(FTable);
    while oRow <> nil do begin
      Inc(Result);
      oRow := Updates.NextChange(oRow, FTable);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.RevertRecord;
var
  oRow: TADDatSRow;
begin
  Cancel;
  CheckBrowseMode;
  CheckCachedUpdatesMode;
  UpdateCursorPos;
  if (FRecordIndex >= 0) and (FRecordIndex < FSourceView.Rows.Count) then begin
    oRow := FSourceView.Rows.ItemsI[FRecordIndex];
    if oRow.RowState in [rsInserted, rsDeleted, rsModified] then begin
      oRow.RejectChanges;
      CursorPosChanged;
      Resync([]);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.CommitUpdates;
begin
  CheckBrowseMode;
  CheckCachedUpdatesMode;
  if Updates <> nil then begin
    Updates.AcceptChanges(FTable);
    UpdateCursorPos;
    Resync([]);
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.UndoLastChange(AFollowChange: Boolean): Boolean;
var
  oRow: TADDatSRow;
begin
  Cancel;
  CheckBrowseMode;
  CheckCachedUpdatesMode;
  UpdateCursorPos;
  Result := UpdatesPending;
  if Result then begin
    oRow := Updates.LastChange(FTable);
    if oRow.RowState = rsDeleted then begin
      oRow.RejectChanges;
      FRecordIndex := FSourceView.IndexOf(oRow);
    end
    else begin
      FRecordIndex := FSourceView.IndexOf(oRow);
      oRow.RejectChanges;
    end;
    if AFollowChange and (FRecordIndex <> -1) then begin
      CursorPosChanged;
      Resync([]);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.CancelUpdates;
begin
  SetSavePoint(0);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoBeforeApplyUpdate;
begin
  if Assigned(FBeforeApplyUpdates) then
    FBeforeApplyUpdates(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoAfterApplyUpdate(AErrors: Integer);
begin
  if Assigned(FAfterApplyUpdates) then
    FAfterApplyUpdates(Self, AErrors);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.ApplyUpdatesComplete(AErrors: Integer);
begin
  if FParentDataSet = nil then begin
    if FTable.HasErrors then
      Reconcile
    else if FAutoCommitUpdates then
      CommitUpdates;
  end;
  DoAfterApplyUpdate(AErrors);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.ApplyUpdates(AMaxErrors: Integer = -1): Integer;
begin
  StartWait;
  try
    DoBeforeApplyUpdate;
    CheckBrowseMode;
    CheckCachedUpdatesMode;
    if FParentDataSet <> nil then
      Result := FParentDataSet.ApplyUpdates(AMaxErrors)
    else
      Result := DoApplyUpdates(FTable, AMaxErrors);
    if not DoIsSourceAsync then
      ApplyUpdatesComplete(Result);
  finally
    StopWait;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.Reconcile: Boolean;
var
  oRow, oNextRow: TADDatSRow;
  iAction: TADDAptReconcileAction;
  oWait: IADGUIxWaitCursor;
begin
  CheckCachedUpdatesMode;
  if (Updates = nil) or not Assigned(FOnReconcileError) then begin
    if FAutoCommitUpdates then
      CommitUpdates;
    Result := True;
    Exit;
  end;
  oRow := Updates.FirstChange(FTable);
  while oRow <> nil do begin
    oNextRow := Updates.NextChange(oRow, FTable);
    if oRow.HasErrors then begin
      ADCreateInterface(IADGUIxWaitCursor, oWait);
      oWait.PushWait;
      try
        iAction := raMerge;
        DoReconcileErrorHandler(oRow, oRow.RowError, oRow.RowState, iAction);
      finally
        oWait.PopWait;
      end;
      case iAction of
      raSkip:
        ;
      raAbort:
        Break;
      raMerge:
        begin
          oRow.ClearErrors;
          oRow.AcceptChanges;
        end;
      raCorrect:
        oRow.ClearErrors;
      raCancel:
        begin
          oRow.ClearErrors;
          oRow.RejectChanges;
        end;
      raRefresh:
        begin
          oRow.ClearErrors;
          BeginForceRow(oRow, False, True);
          try
            RefreshRecord;
          finally
            EndForceRow;
          end;
        end;
      end;
    end;
    oRow := oNextRow;
  end;
  Result := not Updates.HasChanges(FTable);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.UpdateStatus: TUpdateStatus;
var
  pBuff: PChar;
  oRow: TADDatSRow;
  iRowState: TADDatSRowState;
begin
  if not Active then
    Result := usUnmodified
  else if State = dsInternalCalc then
    Result := usUnModified
  else begin
    if State = dsCalcFields then
      pBuff := CalcBuffer
    else
      pBuff := ActiveBuffer;
    oRow := GetRow(pBuff, False);
    if oRow = nil then
      Result := usUnModified
    else begin
      if oRow.RowState in [rsEditing, rsCalculating, rsChecking] then
        iRowState := oRow.RowPriorState
      else
        iRowState := oRow.RowState;
      if iRowState = rsModified then
        Result := usModified
      else if iRowState in [rsDetached, rsDeleted] then
        Result := usDeleted
      else if iRowState = rsInserted then
        Result := usInserted
      else
        Result := usUnModified;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
type
  TADDataSetDataLoadSave = record
    FIndActive: Boolean;
    FAggActive: Boolean;
    FSilentMode: Boolean;
    FRefreshMode: TADRefreshMode;
    FCacheUpdateCommands: Boolean;
    FUpdateChangedFields: Boolean;
    FLockMode: TADLockMode;
    FUpdateMode: TUpdateMode;
  end;
  PDEDataSetDataLoadSave = ^TADDataSetDataLoadSave;

procedure TADDataSet.BeginBatch(AWithDelete: Boolean = False);
var
  oUpdOpts: TADUpdateOptions;
begin
  CheckBrowseMode;
  if FDataLoadSave <> nil then
    Exit;
  GetMem(FDataLoadSave, SizeOf(TADDataSetDataLoadSave));
  with PDEDataSetDataLoadSave(FDataLoadSave)^ do begin
    DisableControls;
    DisableConstraints;
    FIndActive := IndexesActive;
    IndexesActive := False;
    FAggActive := AggregatesActive;
    AggregatesActive := False;
    if AWithDelete then
      FTable.BeginLoadData(lmMove)
    else
      FTable.BeginLoadData;
    FSilentMode := Self.FSilentMode;
    Self.FSilentMode := True;
    oUpdOpts := GetUpdateOptions;
    if oUpdOpts <> nil then begin
      FRefreshMode := oUpdOpts.RefreshMode;
      FCacheUpdateCommands := oUpdOpts.CacheUpdateCommands;
      FUpdateChangedFields := oUpdOpts.UpdateChangedFields;
      FLockMode := oUpdOpts.LockMode;
      FUpdateMode := oUpdOpts.UpdateMode;
      oUpdOpts.FastUpdates := True;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.EndBatch;
var
  oUpdOpts: TADUpdateOptions;
begin
  if FDataLoadSave = nil then
    Exit;
  try
    with PDEDataSetDataLoadSave(FDataLoadSave)^ do begin
      oUpdOpts := GetUpdateOptions;
      if oUpdOpts <> nil then begin
        oUpdOpts.RefreshMode := FRefreshMode;
        oUpdOpts.CacheUpdateCommands := FCacheUpdateCommands;
        oUpdOpts.UpdateChangedFields := FUpdateChangedFields;
        oUpdOpts.LockMode := FLockMode;
        oUpdOpts.UpdateMode := FUpdateMode;
      end;
      Self.FSilentMode := FSilentMode;
      if Active then begin
        FTable.EndLoadData;
        IndexesActive := FIndActive;
        AggregatesActive := FAggActive;
      end
      else begin
        FIndexesActive := FIndActive;
        FAggregatesActive := FAggActive;
      end;
      EnableConstraints;
      if Active then
        Resync([]);
      EnableControls;
    end;
  finally
    FreeMem(FDataLoadSave, SizeOf(TADDataSetDataLoadSave));
    FDataLoadSave := nil;
  end;
end;

{-------------------------------------------------------------------------------}
{ IProviderSupport }

procedure TADDataSet.PSExecute;
begin
  Execute;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.PSReset;
begin
  if Active and not BOF then
    First;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.PSGetDefaultOrder: TIndexDef;
begin
  Result := nil;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.PSGetIndexDefs(IndexTypes: TIndexOptions): TIndexDefs;
begin
{$IFNDEF AnyDAC_FPC}
  Result := GetIndexDefs(IndexDefs, IndexTypes);
{$ELSE}
  Result := nil;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
function TADDataSet.PSGetKeyFields: String;
{$IFDEF AnyDAC_FPC}
var
  i: integer;
{$ENDIF}
begin
{$IFNDEF AnyDAC_FPC}
  Result := inherited PSGetKeyFields;
{$ELSE}
  Result := '';
  for i := 0 to Fields.Count - 1 do
    if pfInKey in Fields[i].ProviderFlags then
    begin
      if Result <> '' then
        Result := Result + ';';
      Result := Result + Fields[i].FieldName;
    end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
function TADDataSet.PSGetTableName: String;
begin
  Result := UpdateOptions.UpdateTableName;
  if (Result = '') and (FTable <> nil) then
    Result := FTable.SourceName;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.PSGetUpdateException(E: Exception; Prev: EUpdateError): EUpdateError;
var
  PrevErr: Integer;
begin
  if Prev <> nil then
    PrevErr := Prev.ErrorCode
  else
    PrevErr := 0;
  if (E is EADDBEngineException) and (EADDBEngineException(E).ErrorCount > 0) then
    Result := EUpdateError.Create(E.Message, '',
      EADDBEngineException(E).Errors[0].ErrorCode, PrevErr, E)
  else begin
{$IFNDEF AnyDAC_FPC}
    Result := inherited PSGetUpdateException(E, Prev);
{$ELSE}
    if Prev <> nil then
      PrevErr := Prev.ErrorCode
    else
      PrevErr := 0;
    Result := EUpdateError.Create(E.Message, '', 1, PrevErr, E);
{$ENDIF}
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.PSUpdateRecord(AUpdateKind: TUpdateKind; ADelta: TDataSet): Boolean;
var
  lPrevActive: Boolean;
  sPrevPos: TBookmarkStr;

  function LocateRecord: Boolean;
  var
    sKeyFields: String;
  begin
    sKeyFields := PSGetKeyFields;
    if sKeyFields = '' then
      Result := False
    else
      Result := Locate(sKeyFields, ADelta[sKeyFields], []);
  end;

begin
  Result := False;
  lPrevActive := Active;
  if not Active then
    Open
  else
    sPrevPos := Bookmark;
  BeginBatch(True);
  try
    case AUpdateKind of
    ukModify:
      if LocateRecord then begin
        Edit;
        CopyFields(ADelta, True);
        Post;
        Result := True;
      end;
    ukInsert:
      begin
        Append;
        CopyFields(ADelta, True);
        Post;
        Result := True;
      end;
    ukDelete:
      if LocateRecord then begin
        Delete;
        Result := True;
      end;
    end;
  finally
    EndBatch;
    if Result then
      if not lPrevActive then
        Close
      else
        Bookmark := sPrevPos;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADBlobStream                                                                 }
{-------------------------------------------------------------------------------}
constructor TADBlobStream.Create(AField: TBlobField; AMode: TBlobStreamMode);
begin
  inherited Create;
  FField := AField;
  FDataSet := FField.DataSet as TADDataSet;
  if not (FDataSet.State in [dsInsert, dsSetKey, dsFilter, dsNewValue]) then
    with FDataSet.FetchOptions do
      if (Mode <> fmManual) and not (fiBlobs in Items) then begin
        FDataSet.FSelfOperating := True;
        try
          FDataSet.FetchBlobs;
        finally
          FDataSet.FSelfOperating := False;
        end;
      end;
  if FDataSet.GetActiveRecBuf(FBuffer) then begin
    if (AMode <> bmRead) and not FDataSet.IsForceRowMode then begin
      if FField.ReadOnly then
        DatabaseErrorFmt(SFieldReadOnly, [FField.DisplayName], FDataSet);
      if not (FDataSet.State in [dsEdit, dsInsert, dsNewValue]) then
        DatabaseError(SNotEditing, FDataSet);
    end;
    FMode := AMode;
    if AMode = bmWrite then
      Truncate
    else
      ReadBlobData;
  end;
  Position := 0;
end;

{-------------------------------------------------------------------------------}
destructor TADBlobStream.Destroy;
var
  oRow: TADDatSRow;
  oCol: TADDatSColumn;
  iColIndex: Integer;
  iLen: LongWord;
begin
  if FModified then
    try
      oCol := nil;
      iColIndex := -1;
      oRow := nil;
      if FDataSet.GetFieldColumn(FBuffer, FField.FieldNo, oCol, iColIndex, oRow, True) then begin
        if oRow.RowState in [rsInserted, rsModified, rsUnchanged] then
          oRow.BeginEdit;
        iLen := LongWord(Size);
        if FField is TADWideMemoField then
          iLen := iLen div SizeOf(WideChar);
        oRow.SetData(iColIndex, Memory, iLen);
        FField.Modified := True;
        FDataSet.DataEvent(deFieldChange, Longint(FField));
      end;
      { TODO -cDATASET : if not fiBlobs in Cache, then free blob data ?? }
    except
      FDataSet.InternalHandleException;
    end;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADBlobStream.Realloc(var ANewCapacity: Longint): Pointer;
begin
  if FMode <> bmRead then
    Result := inherited Realloc(ANewCapacity)
  else
    Result := Memory;
end;

{-------------------------------------------------------------------------------}
procedure TADBlobStream.ReadBlobData;
var
  oRow: TADDatSRow;
  oCol: TADDatSColumn;
  pData: Pointer;
  iLen: LongWord;
  iColIndex: Integer;
begin
  oCol := nil;
  iColIndex := -1;
  oRow := nil;
  if FDataSet.GetFieldColumn(FBuffer, FField.FieldNo, oCol, iColIndex, oRow) then begin
    pData := nil;
    iLen := 0;
    if oRow.GetData(iColIndex, FDataSet.GetRowVersion, pData, 0, iLen, False) then begin
      if FField is TADWideMemoField then
        iLen := iLen * SizeOf(WideChar);
      if FMode = bmRead then
        SetPointer(pData, iLen)
      else if iLen > 0 then begin
        SetSize(iLen);
        ADMove(pData^, Memory^, iLen);
      end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADBlobStream.Write(const ABuffer; ACount: Longint): Longint;
begin
  CheckWrite;
  Result := inherited Write(ABuffer, ACount);
  FModified := True;
end;

{-------------------------------------------------------------------------------}
procedure TADBlobStream.Truncate;
begin
  CheckWrite;
  Clear;
  FModified := True;
end;

{-------------------------------------------------------------------------------}
procedure TADBlobStream.CheckWrite;
begin
  if not (FMode in [bmWrite, bmReadWrite]) then
    DatabaseErrorFmt(SFieldReadOnly, [FField.DisplayName], FDataSet);
end;

{-------------------------------------------------------------------------------}
{ TADWideMemoField                                                              }
{-------------------------------------------------------------------------------}
constructor TADWideMemoField.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SetDataType(ftFmtMemo);
  Transliterate := True;
end;

{-------------------------------------------------------------------------------}
function TADWideMemoField.GetClassDesc: string;
begin
  Result := '(WideMemo)';
  if not IsNull then Result := AnsiUpperCase(Result);
end;

{-------------------------------------------------------------------------------}
function TADWideMemoField.GetAsString: String;
begin
  Result := GetAsWideString;
end;

{-------------------------------------------------------------------------------}
procedure TADWideMemoField.SetAsString(const AValue: String);
begin
  SetAsWideString(AValue);
end;

{-------------------------------------------------------------------------------}
function TADWideMemoField.GetAsWideString: WideString;
var
  iLen: Integer;
begin
  with DataSet.CreateBlobStream(Self, bmRead) do
    try
      iLen := Integer(Size);
      SetString(Result, nil, iLen div SizeOf(WideChar));
      ReadBuffer(PWideChar(Result)^, iLen);
    finally
      Free;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADWideMemoField.SetAsWideString(const AValue: WideString);
begin
  with DataSet.CreateBlobStream(Self, bmWrite) do
    try
      WriteBuffer(PWideChar(AValue)^, Length(AValue) * SizeOf(WideChar));
    finally
      Free;
    end;
end;

{-------------------------------------------------------------------------------}
function TADWideMemoField.GetAsVariant: Variant;
begin
  Result := GetAsWideString;
end;

{-------------------------------------------------------------------------------}
procedure TADWideMemoField.SetVarValue(const AValue: Variant);
begin
  SetAsWideString(AValue);
end;

{-------------------------------------------------------------------------------}
{ TADAutoIncField                                                               }
{-------------------------------------------------------------------------------}
constructor TADAutoIncField.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAutoIncrementSeed := -1;
  FAutoIncrementStep := -1;
  FClientAutoIncrement := True;
  FServerAutoIncrement := True;
  Required := False;
  ProviderFlags := [pfInWhere];
{$IFNDEF AnyDAC_FPC}
  AutoGenerateValue := DB.arAutoInc;
{$ENDIF}
  ReadOnly := True;
end;

{-------------------------------------------------------------------------------}
procedure TADAutoIncField.SetAutoIncrementSeed(const AValue: Integer);
begin
{$IFNDEF AnyDAC_FPC}
  if (DataSet <> nil) and (DataSet.Designer <> nil) then
    with DataSet.Designer do
    begin
      BeginDesign;
      try
        FAutoIncrementSeed := AValue;
      finally
        EndDesign;
      end;
    end
  else
{$ENDIF}
  begin
    CheckInactive;
    FAutoIncrementSeed := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAutoIncField.SetAutoIncrementStep(const AValue: Integer);
begin
{$IFNDEF AnyDAC_FPC}
  if (DataSet <> nil) and (DataSet.Designer <> nil) then
    with DataSet.Designer do
    begin
      BeginDesign;
      try
        FAutoIncrementStep := AValue;
      finally
        EndDesign;
      end;
    end
  else
{$ENDIF}
  begin
    CheckInactive;
    FAutoIncrementStep := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAutoIncField.SetClientAutoIncrement(const AValue: Boolean);
begin
{$IFNDEF AnyDAC_FPC}
  if (DataSet <> nil) and (DataSet.Designer <> nil) then
    with DataSet.Designer do
    begin
      BeginDesign;
      try
        FClientAutoIncrement := AValue;
      finally
        EndDesign;
      end;
    end
  else
{$ENDIF}
  begin
    CheckInactive;
    FClientAutoIncrement := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAutoIncField.SetServerAutoIncrement(const AValue: Boolean);

  procedure UpdateProps;
  begin
    if ServerAutoIncrement then begin
      Required := False;
      ProviderFlags := ProviderFlags - [pfInUpdate];
{$IFNDEF AnyDAC_FPC}
      AutoGenerateValue := DB.arAutoInc;
{$ENDIF}
      FAutoIncrementSeed := -1;
      FAutoIncrementStep := -1;
    end
    else begin
      ProviderFlags := ProviderFlags + [pfInUpdate];
{$IFNDEF AnyDAC_FPC}
      AutoGenerateValue := DB.arNone;
{$ENDIF}
      FAutoIncrementSeed := 1;
      FAutoIncrementStep := 1;
    end;
  end;

begin
  if ServerAutoIncrement <> AValue then
{$IFNDEF AnyDAC_FPC}
    if (DataSet <> nil) and (DataSet.Designer <> nil) then
      with DataSet.Designer do
      begin
        BeginDesign;
        try
          FServerAutoIncrement := AValue;
          UpdateProps;
        finally
          EndDesign;
        end;
      end
    else
{$ENDIF}
    begin
      CheckInactive;
      FServerAutoIncrement := AValue;
      UpdateProps;
    end;
end;

{-------------------------------------------------------------------------------}
{ TADIndex                                                                      }
{-------------------------------------------------------------------------------}
destructor TADIndex.Destroy;
begin
  Selected := False;
  DeleteView;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADIndex.GetDisplayName: string;
begin
  if Name = '' then
    Result := inherited GetDisplayName
  else
    Result := Name;
end;

{-------------------------------------------------------------------------------}
procedure TADIndex.Assign(ASource: TPersistent);
var
  opts: TADSortOptions;
begin
  if ASource is TADIndex then begin
    FActive := TADIndex(ASource).Active;
    FName := TADIndex(ASource).Name;
    FFields := TADIndex(ASource).Fields;
    FCaseInsFields := TADIndex(ASource).CaseInsFields;
    FDescFields := TADIndex(ASource).DescFields;
    FExpression := TADIndex(ASource).Expression;
    FOptions := TADIndex(ASource).Options;
    FFilter := TADIndex(ASource).Filter;
    FFilterOptions := TADIndex(ASource).FilterOptions;
    FView := TADIndex(ASource).FView;
    if FView <> nil then
      FView.AddRef
    else
      IndexChanged;
  end
  else if ASource is TIndexDef then begin
    FName := TIndexDef(ASource).Name;
    opts := [];
    if (ixPrimary in TIndexDef(ASource).Options) or (ixUnique in TIndexDef(ASource).Options) then
      Include(opts, soUnique);
    if ixPrimary in TIndexDef(ASource).Options then
      Include(opts, soPrimary);
    if ixDescending in TIndexDef(ASource).Options then
      Include(opts, soDescending);
    if ixCaseInsensitive in TIndexDef(ASource).Options then
      Include(opts, soNoCase);
    FOptions := opts;
    FFields := TIndexDef(ASource).Fields;
{$IFNDEF AnyDAC_FPC}
    FDescFields := TIndexDef(ASource).DescFields;
    FCaseInsFields := TIndexDef(ASource).CaseInsFields;
{$ENDIF}
    FExpression := TIndexDef(ASource).Expression;
    FFilter := '';
    FFilterOptions := [];
    FActive := not (ixNonMaintained in TIndexDef(ASource).Options);
    IndexChanged;
  end
  else
    inherited Assign(ASource);
end;

{-------------------------------------------------------------------------------}
procedure TADIndex.AssignTo(ADest: TPersistent);
var
  opts: TIndexOptions;
begin
  if ADest is TIndexDef then begin
    TIndexDef(ADest).Name := Name;
    if Fields <> '' then begin
      TIndexDef(ADest).Fields := Fields;
{$IFNDEF AnyDAC_FPC}
      TIndexDef(ADest).CaseInsFields := CaseInsFields;
      TIndexDef(ADest).DescFields := DescFields;
{$ENDIF}
    end
{$IFNDEF AnyDAC_FPC}
    else if Expression <> '' then
      TIndexDef(ADest).Expression := Expression
{$ENDIF}
    ;
    opts := [];
    if soPrimary in Options then
      Include(opts, ixPrimary);
    if soUnique in Options then
      Include(opts, ixUnique);
    if soDescending in Options then
      Include(opts, ixDescending);
    if soNoCase in Options then
      Include(opts, ixCaseInsensitive);
    if not Active then
      Include(opts, ixNonMaintained);
    TIndexDef(ADest).Options := opts;
  end
  else
    inherited AssignTo(ADest);
end;

{-------------------------------------------------------------------------------}
function TADIndex.GetDataSet: TADDataSet;
begin
  if Collection <> nil then
    Result := TADIndexes(Collection).FDataSet
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
function TADIndex.GetActualActive: Boolean;
begin
  Result := Active and (FUpdateCount = 0) and
    (DataSet <> nil) and (DataSet.FTable <> nil) and DataSet.IndexesActive;
end;

{-------------------------------------------------------------------------------}
function TADIndex.GetSelected: Boolean;
var
  oDS: TADDataSet;
begin
  oDS := DataSet;
  Result := (oDS <> nil) and (
    (Name <> '') and ({$IFDEF AnyDAC_NOLOCALE_META} ADCompareText {$ELSE} AnsiCompareText {$ENDIF}
      (oDS.IndexName, Name) = 0) or
    (Fields <> '') and ({$IFDEF AnyDAC_NOLOCALE_META} ADCompareText {$ELSE} AnsiCompareText {$ENDIF}
      (oDS.IndexFieldNames, Fields) = 0));
end;

{-------------------------------------------------------------------------------}
procedure TADIndex.SetSelected(const AValue: Boolean);
var
  oDS: TADDataSet;
begin
  oDS := DataSet;
  if (oDS <> nil) and (Selected <> AValue) then
    if not AValue then begin
      oDS.IndexName := '';
      oDS.IndexFieldNames := '';
    end
    else begin
      Active := True;
      oDS.IndexName := Name;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADIndex.DeleteView;
begin
  if FView <> nil then begin
    FView.RemRef;
    FView := nil;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADIndex.CreateView;
begin
  try
    FView := TADIndexes(Collection).FDataSet.BuildViewForIndex(Self);
  except
    Active := False;
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADIndex.IndexChanged;
var
  oDS: TADDataSet;
  lReset: Boolean;

  procedure DeleteCreateView;
  begin
    if ActualActive then begin
      DeleteView;
      CreateView;
    end
    else
      DeleteView;
  end;

begin
  if FUpdateCount = 0 then begin
    oDS := DataSet;
    lReset := (oDS <> nil) and (FView <> nil) and (oDS.FSortView = FView);
    if lReset then begin
      oDS.DisableControls;
      try
        try
          oDS.SetSortView(nil);
          DeleteCreateView;
        finally
          if FView = nil then begin
            oDS.FIndexName := '';
            oDS.FIndexFieldNames := '';
            oDS.SetSortView(nil);
          end
          else begin
            if oDS.FIndexName <> '' then
              oDS.FIndexName := Name;
            if oDS.FIndexFieldNames <> '' then
              oDS.FIndexFieldNames := Fields;
            oDS.SetSortView(FView);
          end;
        end;
      finally
        oDS.EnableControls;
      end;
    end
    else
      DeleteCreateView;
    if oDS <> nil then
      oDS.IndexDefs.Updated := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADIndex.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

{-------------------------------------------------------------------------------}
procedure TADIndex.EndUpdate;
begin
  if FUpdateCount > 0 then begin
    Dec(FUpdateCount);
    if FUpdateCount = 0 then
      IndexChanged;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADIndex.SetActive(const AValue: Boolean);
begin
  if FActive <> AValue then begin
    FActive := AValue;
    if FActive and
       ((Name = '') or (Fields = '') and (Expression = '') and (Filter = '')) and
       (DataSet <> nil) and not (csReading in DataSet.ComponentState) then
      ADException(Self, [S_AD_LComp, S_AD_LComp_PDS], er_AD_DSIndNotComplete, []);
    IndexChanged;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADIndex.SetCaseInsFields(const AValue: string);
begin
  if FCaseInsFields <> AValue then begin
    FCaseInsFields := AValue;
    FExpression := '';
    IndexChanged;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADIndex.SetDescFields(const AValue: string);
begin
  if FDescFields <> AValue then begin
    FDescFields := AValue;
    FExpression := '';
    IndexChanged;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADIndex.SetExpression(const AValue: string);
begin
  if FExpression <> AValue then begin
    FExpression := AValue;
    FFields := '';
    FDescFields := '';
    FCaseInsFields := '';
    IndexChanged;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADIndex.SetFields(const AValue: string);
begin
  if FFields <> AValue then begin
    FFields := AValue;
    FExpression := '';
    IndexChanged;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADIndex.SetFilter(const AValue: String);
begin
  if FFilter <> AValue then begin
    FFilter := AValue;
    IndexChanged;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADIndex.SetFilterOptions(const AValue: TADExpressionOptions);
begin
  if FFilterOptions <> AValue then begin
    FFilterOptions := AValue;
    IndexChanged;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADIndex.SetName(const AValue: String);
begin
  if FName <> AValue then begin
    FName := AValue;
    IndexChanged;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADIndex.SetOptions(const AValue: TADSortOptions);
begin
  if FOptions <> AValue then begin
    FOptions := AValue;
    IndexChanged;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADIndexes                                                                    }
{-------------------------------------------------------------------------------}
constructor TADIndexes.Create(ADataSet: TADDataSet);
begin
  inherited Create(TADIndex);
  FDataSet := ADataSet;
end;

{-------------------------------------------------------------------------------}
function TADIndexes.GetOwner: TPersistent;
begin
  Result := FDataSet;
end;

{-------------------------------------------------------------------------------}
function TADIndexes.Add: TADIndex;
begin
  Result := TADIndex(inherited Add);
end;

{-------------------------------------------------------------------------------}
function TADIndexes.FindIndex(const AName: String): TADIndex;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
    if {$IFDEF AnyDAC_NOLOCALE_META} ADCompareText {$ELSE} AnsiCompareText {$ENDIF}
       (Items[i].Name, AName) = 0 then begin
      Result := Items[i];
      Break;
    end;
end;

{-------------------------------------------------------------------------------}
function TADIndexes.IndexByName(const AName: String): TADIndex;
begin
  Result := FindIndex(AName);
  if Result = nil then
    ADException(Self, [S_AD_LComp, S_AD_LComp_PDS], er_AD_DSIndNotFound, [AName]);
end;

{-------------------------------------------------------------------------------}
function TADIndexes.GetItems(AIndex: Integer): TADIndex;
begin
  Result := TADIndex(inherited Items[AIndex]);
end;

{-------------------------------------------------------------------------------}
procedure TADIndexes.SetItems(AIndex: Integer; const AValue: TADIndex);
begin
  inherited Items[AIndex] := AValue;
end;

{-------------------------------------------------------------------------------}
function TADIndexes.FindIndexForFields(const AFields: String;
  ARequiredOptions: TADSortOptions = [];
  AProhibitedOptions: TADSortOptions = []): TADIndex;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
    with Items[i] do
      if (Expression = '') and ((Filter = '') or Selected) and
         (Pos(AFields, Fields) = 1) and (
            (Length(AFields) = Length(Fields)) or
            (Fields[Length(AFields) + 1] = ';')) and
         (Options * ARequiredOptions = ARequiredOptions) and
         (Options * AProhibitedOptions = []) then begin
        Result := Items[i];
        Break;
      end;
end;

{-------------------------------------------------------------------------------}
procedure TADIndexes.Build;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    Items[i].IndexChanged;
end;

{-------------------------------------------------------------------------------}
procedure TADIndexes.Release;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    Items[i].DeleteView;
end;

{-------------------------------------------------------------------------------}
{ TADAggregate                                                                  }
{-------------------------------------------------------------------------------}
destructor TADAggregate.Destroy;
begin
  DeleteAggregate;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADAggregate.GetDisplayName: String;
begin
  if Name = '' then
    Result := inherited GetDisplayName
  else
    Result := Name;
end;

{-------------------------------------------------------------------------------}
procedure TADAggregate.Assign(ASource: TPersistent);
begin
  if ASource is TADAggregate then begin
    FExpression := TADAggregate(ASource).Expression;
    FGroupingLevel := TADAggregate(ASource).GroupingLevel;
    FIndexName := TADAggregate(ASource).IndexName;
    FActive := TADAggregate(ASource).Active;
    FName := TADAggregate(ASource).Name;
    AggregateChanged;
  end
{$IFNDEF AnyDAC_FPC}
  else if ASource is TAggregateField then begin
    FExpression := TAggregateField(ASource).Expression;
    FGroupingLevel := TAggregateField(ASource).GroupingLevel;
    FIndexName := TAggregateField(ASource).IndexName;
    FActive := TAggregateField(ASource).Active;
    FName := C_AD_SysNamePrefix + '#' + TAggregateField(ASource).FieldName;
    AggregateChanged;
  end
{$ENDIF}
  else
    inherited Assign(ASource);
end;

{-------------------------------------------------------------------------------}
procedure TADAggregate.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

{-------------------------------------------------------------------------------}
procedure TADAggregate.EndUpdate;
begin
  if FUpdateCount > 0 then begin
    Dec(FUpdateCount);
    if FUpdateCount = 0 then
      AggregateChanged;
  end;
end;

{-------------------------------------------------------------------------------}
function TADAggregate.GetActualActive: Boolean;
begin
  Result := (FExpression <> '') and Active and (FUpdateCount = 0) and
    (DataSet <> nil) and (DataSet.FTable <> nil) and DataSet.AggregatesActive;
end;

{-------------------------------------------------------------------------------}
function TADAggregate.GetDataSet: TADDataSet;
begin
  if Collection <> nil then
    Result := TADAggregates(Collection).FDataSet
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADAggregate.DeleteAggregate;
begin
  if FAggregate <> nil then begin
    FAggregate.RemRef;
    FAggregate := nil;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAggregate.CreateAggregate;
var
  oDS: TADDataSet;
  iGrpLevel: Integer;
begin
  oDS := DataSet;
  if (oDS = nil) or        // When we modifying index props we set to nil index view,
                           // and then to some index view. There will be moment when
                           // oDS.IndexName not empty, but there are no FSortView
     (IndexName <> '') and {??? (IndexName <> oDS.IndexName) then}
     ((oDS.FSortView = nil) or (IndexName <> oDS.FSortView.Name)) then
    Exit;
  if IndexName <> '' then begin
    iGrpLevel := GroupingLevel;
    if TADAggregates(Collection).FGroupingLevel < iGrpLevel then
      TADAggregates(Collection).FGroupingLevel := iGrpLevel;
  end
  else
    iGrpLevel := 0;
  FAggregate := oDS.FSourceView.Aggregates.Add(Name, Expression, iGrpLevel);
  FAggregate.CountRef;
end;

{-------------------------------------------------------------------------------}
procedure TADAggregate.AggregateChanged;
begin
  if FUpdateCount = 0 then begin
    if ActualActive then begin
      DeleteAggregate;
      CreateAggregate;
    end
    else
      DeleteAggregate;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAggregate.SetActive(const AValue: Boolean);
begin
  if FActive <> AValue then begin
    FActive := AValue;
    if FActive and
       ((Name = '') or (Expression = '')) and
       (DataSet <> nil) and not (csReading in DataSet.ComponentState) then
      ADException(Self, [S_AD_LComp, S_AD_LComp_PDS], er_AD_DSAggNotComplete, []);
    AggregateChanged;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAggregate.SetExpression(const AValue: String);
begin
  if FExpression <> AValue then begin
    FExpression := AValue;
    AggregateChanged;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAggregate.SetGroupingLevel(const AValue: Integer);
begin
  if FGroupingLevel <> AValue then begin
    FGroupingLevel := AValue;
    AggregateChanged;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAggregate.SetIndexName(const AValue: String);
begin
  if FIndexName <> AValue then begin
    FIndexName := AValue;
    AggregateChanged;
  end;
end;

{-------------------------------------------------------------------------------}
function TADAggregate.InternalUse(var ARecordIndex: Integer): Boolean;
var
  oDS: TADDataSet;
begin
  oDS := DataSet;
  if (oDS <> nil) and oDS.GetActiveRecBufRecordIndex(ARecordIndex) and
     (FAggregate <> nil) and FAggregate.ActualActive then
    Result := True
  else
    Result := False;
end;

{-------------------------------------------------------------------------------}
function TADAggregate.GetInUse: Boolean;
var
  iRecInd: Integer;
begin
  iRecInd := -1;
  Result := InternalUse(iRecInd);
end;

{-------------------------------------------------------------------------------}
function TADAggregate.GetValue: Variant;
var
  iRecInd: Integer;
begin
  iRecInd := -1;
  if InternalUse(iRecInd) then
    Result := FAggregate.Value[iRecInd]
  else
    Result := Null;
end;

{-------------------------------------------------------------------------------}
{ TADAggregates                                                                 }
{-------------------------------------------------------------------------------}
constructor TADAggregates.Create(ADataSet: TADDataSet);
begin
  inherited Create(TADAggregate);
  FDataSet := ADataSet;
end;

{-------------------------------------------------------------------------------}
function TADAggregates.GetOwner: TPersistent;
begin
  Result := FDataSet;
end;

{-------------------------------------------------------------------------------}
function TADAggregates.Add: TADAggregate;
begin
  Result := TADAggregate(inherited Add);
end;

{-------------------------------------------------------------------------------}
function TADAggregates.GetItems(AIndex: Integer): TADAggregate;
begin
  Result := TADAggregate(inherited Items[AIndex]);
end;

{-------------------------------------------------------------------------------}
procedure TADAggregates.SetItems(AIndex: Integer; const AValue: TADAggregate);
begin
  inherited Items[AIndex] := AValue;
end;

{-------------------------------------------------------------------------------}
function TADAggregates.FindAggregate(const AName: String): TADAggregate;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
    if {$IFDEF AnyDAC_NOLOCALE_META} ADCompareText {$ELSE} AnsiCompareText {$ENDIF}
       (Items[i].Name, AName) = 0 then begin
      Result := Items[i];
      Break;
    end;
end;

{-------------------------------------------------------------------------------}
function TADAggregates.AggregateByName(const AName: String): TADAggregate;
begin
  Result := FindAggregate(AName);
  if Result = nil then
    ADException(Self, [S_AD_LComp, S_AD_LComp_PDS], er_AD_DSAggNotFound, [AName]);
end;

{-------------------------------------------------------------------------------}
procedure TADAggregates.Build;
var
  i: Integer;
begin
  FGroupingLevel := -1;
  for i := 0 to Count - 1 do
    Items[i].AggregateChanged;
  if FGroupingLevel = -1 then
    if (FDataSet <> nil) and (FDataSet.IndexName <> '') then
      FGroupingLevel := FDataSet.FSourceView.GroupingLevel
    else
      FGroupingLevel := 0;
end;

{-------------------------------------------------------------------------------}
procedure TADAggregates.Release;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    Items[i].DeleteAggregate;
end;

end.
