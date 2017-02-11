{-------------------------------------------------------------------------------}
{ AnyDAC option support classes                                                 }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit daADStanOption;

interface

uses
  SysUtils, Windows, Classes, DB,
{$IFDEF AnyDAC_D6Base}
  Variants,
{$ENDIF}
  daADStanIntf, daADStanConst;

type
  IADStanOptions = interface;
  TADCustomOptions = class;
  TADMapRule = class;
  TADFormatOptions = class;
  TADFormatConversionBuffer = class;
  TADFetchOptions = class;
  TADUpdateOptions = class;
  TADResourceOptions = class;
  TADTxOptions = class;

  TADOptionChangeEvent = procedure (AOptions: TADCustomOptions) of object;

  TADFormatOptionValue = (fvMapRules, fvSE2Null, fvStrsTrim, fvStrsDivLen2,
    fvMaxStringSize, fvMaxBcdPrecision, fvMaxBcdScale, fvInlineDataSize,
    fvDefaultParamDataType);
  TADFormatOptionValues = set of TADFormatOptionValue;

  TADFetchOptionValue = (evMode, evItems, evRecsMax, evRowsetSize,
    evCache, evAutoClose, evRecordCountMode);
  TADFetchOptionValues = set of TADFetchOptionValue;

  TADFetchMode = (fmManual, fmOnDemand, fmAll, fmExactRecsMax);
  TADFetchItem = (fiBlobs, fiDetails, fiMeta);
  TADFetchItems = set of TADFetchItem;

  TADRecordCountMode = (cmVisible, cmFetched, cmTotal);

  TADUpdateOptionValue = (uvEDelete, uvEInsert, uvEUpdate,
    uvUpdateChngFields, uvUpdateMode, uvLockMode, uvLockPoint,
    uvLockWait, uvRefreshMode, uvCountUpdatedRecords,
    uvCacheUpdateCommands, uvUseProviderFlags);
  TADUpdateOptionValues = set of TADUpdateOptionValue;

  TADLockMode = (lmPessimistic, lmOptimistic, lmRely);
  TADLockPoint = (lpImmediate, lpDeferred);

  TADRefreshMode = (rmManual, rmOnDemand, rmAll);

  TADResourceOptionValue = (rvParamCreate, rvMacroCreate,
    rvMacroExpand, rvParamExpand, rvEscapeExpand,
    rvDisconnectable, rvMaxCursors, rvAsyncCmdMode,
    rvAsyncCmdTimeout, rvDirectExecute, rvDefaultParamType,
    rvServerOutput, rvServerOutputSize);
  TADResourceOptionValues = set of TADResourceOptionValue;

  TADTxDisconnectAction = (xdNone, xdCommmit, xdRollback);
  TADTxIsolation = (xiDirtyRead, xiReadCommitted, xiRepeatableRead,
    xiSerializible);
  TADTxValue = (xoAutoCommit, xoIsolation);
  TADTxValues = set of TADTxValue;

  IADStanOptions = interface (IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2018}']
    // private
    function GetFetchOptions: TADFetchOptions;
    function GetFormatOptions: TADFormatOptions;
    function GetUpdateOptions: TADUpdateOptions;
    function GetResourceOptions: TADResourceOptions;
    // public
    property FetchOptions: TADFetchOptions read GetFetchOptions;
    property FormatOptions: TADFormatOptions read GetFormatOptions;
    property UpdateOptions: TADUpdateOptions read GetUpdateOptions;
    property ResourceOptions: TADResourceOptions read GetResourceOptions;
    function GetParentOptions(out AOpts: IADStanOptions): Boolean;
  end;

  TADCustomOptions = class (TPersistent)
  private
    FOwnerObj: TPersistent;
    FOwner: IADStanOptions;
    FOnChanging: TADOptionChangeEvent;
    FOnChanged: TADOptionChangeEvent;
  protected
    procedure Changing;
    procedure Changed;
    function  GetOwner: TPersistent; override;
  public
    constructor Create(const AOwner: TObject);
    procedure BeforeDestruction; override;
    procedure RestoreDefaults; virtual;
    property Owner: IADStanOptions read FOwner;
    property OwnerObj: TPersistent read FOwnerObj;
  end;

  TADMapRule = class (TCollectionItem)
  private
    FPrecMax: Integer;
    FPrecMin: Integer;
    FScaleMax: Integer;
    FScaleMin: Integer;
    FSizeMax: LongWord;
    FSizeMin: LongWord;
    FSourceDataType: TADDataType;
    FTargetDataType: TADDataType;
    procedure SetPrecMax(Value: Integer);
    procedure SetPrecMin(Value: Integer);
    procedure SetScaleMax(Value: Integer);
    procedure SetScaleMin(Value: Integer);
    procedure SetSizeMax(Value: LongWord);
    procedure SetSizeMin(Value: LongWord);
    procedure SetSourceDataType(Value: TADDataType);
    procedure SetTargetDataType(Value: TADDataType);
    procedure Changing;
    procedure Changed;
  protected
    function GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); override;
    procedure Assign(Source: TPersistent); override;
  published
    property PrecMax: Integer read FPrecMax write SetPrecMax default C_AD_DefMapPrec;
    property PrecMin: Integer read FPrecMin write SetPrecMin default C_AD_DefMapPrec;
    property ScaleMax: Integer read FScaleMax write SetScaleMax default C_AD_DefMapScale;
    property ScaleMin: Integer read FScaleMin write SetScaleMin default C_AD_DefMapScale;
    property SizeMax: LongWord read FSizeMax write SetSizeMax default C_AD_DefMapSize;
    property SizeMin: LongWord read FSizeMin write SetSizeMin default C_AD_DefMapSize;
    property SourceDataType: TADDataType read FSourceDataType write
      SetSourceDataType default dtUnknown;
    property TargetDataType: TADDataType read FTargetDataType write
      SetTargetDataType default dtUnknown;
  end;

  TADMapRules = class(TCollection)
  private
    FFormatOptions: TADFormatOptions;
    function GetItems(AIndex: Integer): TADMapRule;
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(AFormatOptions: TADFormatOptions);
    function Add: TADMapRule;
    property Items[AIndex: Integer]: TADMapRule read GetItems; default;
  end;

  TADFormatOptions = class (TADCustomOptions)
  private
    function GetStrsEmpty2Null: Boolean;
    function GetStrsTrim: Boolean;
    procedure SetStrsEmpty2Null(Value: Boolean);
    procedure SetStrsTrim(Value: Boolean);
    function GetMapRules: TADMapRules;
    function GetParentFormatOptions(const AParentOpts: IADStanOptions): TADFormatOptions;
    function IsMRS: Boolean;
    function IsSE2NS: Boolean;
    function IsSTS: Boolean;
    procedure SetMapRules(const Value: TADMapRules);
    function GetMaxStringSize: LongWord;
    function IsMSSS: Boolean;
    procedure SetMaxStringSize(const Value: LongWord);
    function GetMaxBcdPrecision: Integer;
    function GetMaxBcdScale: Integer;
    function IsMBPS: Boolean;
    function IsMBSS: Boolean;
    procedure SetMaxBcdPrecision(const Value: Integer);
    procedure SetMaxBcdScale(const Value: Integer);
    procedure SetOwnMapRules(const AValue: Boolean);
    function GetStrsDivLen2: Boolean;
    function IsSDL2S: Boolean;
    procedure SetStrsDivLen2(const Value: Boolean);
    function GetInlineDataSize: Integer;
    function IsIDSS: Boolean;
    procedure SetInlineDataSize(const AValue: Integer);
    procedure SetDefaultParamDataType(const AValue: TFieldType);
    function GetDefaultParamDataType: TFieldType;
    function IsDPDTS: Boolean;
  protected
    FMapRules: TADMapRules;
    FStrsEmpty2Null: Boolean;
    FStrsTrim: Boolean;
    FStrsDivLen2: Boolean;
    FAssignedValues: TADFormatOptionValues;
    FMaxStringSize: LongWord;
    FMaxBcdPrecision: Integer;
    FMaxBcdScale: Integer;
    FInlineDataSize: Integer;
    FDefaultParamDataType: TFieldType;
  public
    constructor Create(const AOwner: TObject);
    destructor Destroy; override;
    procedure Assign(ASource: TPersistent); override;
    procedure RestoreDefaults; override;
    function IsValueOwned(AValue: TADFormatOptionValue; out AParentOpts: IADStanOptions): Boolean;
    procedure ResolveDataType(ASrcDataType: TADDataType; ASrcSize: LongWord;
      ASrcPrec, ASrcScale: Integer; var ADestDataType: TADDataType; AForward: Boolean);
    procedure ResolveFieldType(ASrcFieldType: TFieldType; ASrcADFieldType: TADDataType;
      ASrcSize: LongWord; ASrcPrecision: Integer; var ADestFieldType: TFieldType;
      var ADestSize: LongWord; var ADestPrecision: Integer; var ASrcDataType,
      ADestDataType: TADDataType; AForward: Boolean);
    procedure ColumnDef2FieldDef(ASrcDataType: TADDataType; ASrcScale,
      ASrcPrec: Integer; ASrcSize: LongWord; ASrcAttrs: TADDataAttributes;
      var ADestFieldType: TFieldType; var ADestSize: LongWord; var ADestPrec: Integer);
    class procedure FieldDef2ColumnDef(ASrcFieldType: TFieldType; ASrcSize: LongWord;
      ASrcPrec: Integer; var ADestDataType: TADDataType; var ADestScale,
      ADestPrec: Integer; var ADestSize: LongWord; var ADestAttrs: TADDataAttributes);
    procedure CheckConversion(ASrc, ADest: TADDataType);
    procedure ConvertRawData(ASrcType, ADestType: TADDataType; ApSrc: Pointer;
      ASrcSize: LongWord; var ApDest: Pointer; ADestMaxSize: LongWord;
      var ADestSize: LongWord);
    property AssignedValues: TADFormatOptionValues read FAssignedValues;
  published
    property OwnMapRules: Boolean read IsMRS write SetOwnMapRules default False;
    property MapRules: TADMapRules read GetMapRules write SetMapRules
      stored IsMRS;
    property StrsEmpty2Null: Boolean read GetStrsEmpty2Null write SetStrsEmpty2Null
      stored IsSE2NS default True;
    property StrsTrim: Boolean read GetStrsTrim write SetStrsTrim
      stored IsSTS default False;
    property StrsDivLen2: Boolean read GetStrsDivLen2 write SetStrsDivLen2
      stored IsSDL2S default False;
    property MaxStringSize: LongWord read GetMaxStringSize write SetMaxStringSize
      stored IsMSSS default C_AD_MaxDlp4StrSize;
    property MaxBcdPrecision: Integer read GetMaxBcdPrecision write SetMaxBcdPrecision
      stored IsMBPS default 18;
    property MaxBcdScale: Integer read GetMaxBcdScale write SetMaxBcdScale
      stored IsMBSS default 4;
    property InlineDataSize: Integer read GetInlineDataSize write
      SetInlineDataSize stored IsIDSS default -1;
    property DefaultParamDataType: TFieldType read GetDefaultParamDataType write
      SetDefaultParamDataType stored IsDPDTS default ftUnknown;
  end;

  TADFormatConversionBuffer = class(TObject)
  public
    FBuffer: Pointer;
    FBufferSize: LongWord;
    constructor Create;
    destructor Destroy; override;
    procedure Extend(ASrcDataLen: LongWord; var ADestDataLen: LongWord;
      ASrcType, ADestType: TADDataType);
    procedure Check(ALen: LongWord = 0);
    procedure Release;
    property Ptr: Pointer read FBuffer;
    property Size: LongWord read FBufferSize;
  end;

  TADFetchOptions = class (TADCustomOptions)
  private
    function GetRecsMax: Integer;
    function GetRowsetSize: Integer;
    function GetItems: TADFetchItems;
    function GetMode: TADFetchMode;
    procedure SetRecsMax(const Value: Integer);
    procedure SetRowsetSize(const Value: Integer);
    procedure SetItems(const Value: TADFetchItems);
    procedure SetMode(const Value: TADFetchMode);
    function GetParentFetchOptions(const AParentOpts: IADStanOptions): TADFetchOptions;
    function IsIS: Boolean;
    function IsMS: Boolean;
    function IsRMS: Boolean;
    function IsRSS: Boolean;
    function GetCache: TADFetchItems;
    function IsCS: Boolean;
    procedure SetCache(const Value: TADFetchItems);
    function GetActualRowsetSize: Integer;
    function GetAutoClose: Boolean;
    function IsACS: Boolean;
    procedure SetAutoClose(const Value: Boolean);
    function GetRecordcountMode: TADRecordCountMode;
    function IsRCMS: Boolean;
    procedure SetRecordCountMode(const Value: TADRecordCountMode);
  protected
    FRecsMax: Integer;
    FRowsetSize: Integer;
    FMode: TADFetchMode;
    FItems: TADFetchItems;
    FAssignedValues: TADFetchOptionValues;
    FCache: TADFetchItems;
    FAutoClose: Boolean;
    FRecordCountMode: TADRecordCountMode;
  public
    procedure Assign(ASource: TPersistent); override;
    procedure RestoreDefaults; override;
    function IsValueOwned(AValue: TADFetchOptionValue; out AParentOpts: IADStanOptions): Boolean;
    property AssignedValues: TADFetchOptionValues read FAssignedValues;
    property ActualRowsetSize: Integer read GetActualRowsetSize;
  published
    property Mode: TADFetchMode read GetMode write SetMode
      stored IsMS default fmOnDemand;
    property Items: TADFetchItems read GetItems write SetItems
      stored IsIS default [fiBlobs, fiDetails, fiMeta];
    property Cache: TADFetchItems read GetCache write SetCache
      stored IsCS default [fiBlobs, fiDetails, fiMeta];
    property RecsMax: Integer read GetRecsMax write SetRecsMax
      stored IsRMS default -1;
    property RowsetSize: Integer read GetRowsetSize write SetRowsetSize
      stored IsRSS default IDefRowSetSize;
    property AutoClose: Boolean read GetAutoClose write SetAutoClose
      stored IsACS default True;
    property RecordCountMode: TADRecordCountMode read GetRecordcountMode
      write SetRecordCountMode stored IsRCMS default cmVisible;
  end;

  TADUpdateOptions = class (TADCustomOptions)
  private
    function GetEnableDelete: Boolean;
    function GetEnableInsert: Boolean;
    function GetEnableUpdate: Boolean;
    procedure SetEnableDelete(AValue: Boolean);
    procedure SetEnableInsert(AValue: Boolean);
    procedure SetEnableUpdate(AValue: Boolean);
    function GetParentUpdateOptions(const AParentOpts: IADStanOptions): TADUpdateOptions;
    function GetReadOnly: Boolean;
    procedure SetReadOnly(const AValue: Boolean);
    function IsEDS: Boolean;
    function IsEIS: Boolean;
    function IsEUS: Boolean;
    function GetUpdateChangedFields: Boolean;
    function GetUpdateMode: TUpdateMode;
    function IsUCFS: Boolean;
    function IsUMS: Boolean;
    procedure SetUpdateChangedFields(const AValue: Boolean);
    procedure SetUpdateMode(const AValue: TUpdateMode);
    function IsLMS: Boolean;
    function IsLPS: Boolean;
    procedure SetLockMode(const AValue: TADLockMode);
    procedure SetLockPoint(const AValue: TADLockPoint);
    function GetLockMode: TADLockMode;
    function GetLockPoint: TADLockPoint;
    function GetLockWait: Boolean;
    function IsLWS: Boolean;
    procedure SetLockWait(const AValue: Boolean);
    function GetRefreshMode: TADRefreshMode;
    function IsRMS: Boolean;
    procedure SetRefreshMode(const AValue: TADRefreshMode);
    function GetCountUpdatedRecords: Boolean;
    function IsCURS: Boolean;
    procedure SetCountUpdatedRecords(const AValue: Boolean);
    function GetCacheUpdateCommands: Boolean;
    function IsCUAS: Boolean;
    procedure SetCacheUpdateCommands(const AValue: Boolean);
    function GetUseProviderFlags: Boolean;
    function IsUPFS: Boolean;
    procedure SetUseProviderFlags(const AValue: Boolean);
    function GetFastUpdates: Boolean;
    procedure SetFastUpdates(const AValue: Boolean);
    function GetRequestLive: Boolean;
    procedure SetRequestLive(const AValue: Boolean);
  protected
    FEnableDelete: Boolean;
    FEnableInsert: Boolean;
    FEnableUpdate: Boolean;
    FUpdateChangedFields: Boolean;
    FUpdateMode: TUpdateMode;
    FLockMode: TADLockMode;
    FLockPoint: TADLockPoint;
    FLockWait: Boolean;
    FRefreshMode: TADRefreshMode;
    FCountUpdatedRecords: Boolean;
    FCacheUpdateCommands: Boolean;
    FUseProviderFlags: Boolean;
    FAssignedValues: TADUpdateOptionValues;
  public
    procedure Assign(ASource: TPersistent); override;
    procedure RestoreDefaults; override;
    function IsValueOwned(AValue: TADUpdateOptionValue; out AParentOpts: IADStanOptions): Boolean;
    property AssignedValues: TADUpdateOptionValues read FAssignedValues;
  published
    property EnableDelete: Boolean read GetEnableDelete write SetEnableDelete
      stored IsEDS default True;
    property EnableInsert: Boolean read GetEnableInsert write SetEnableInsert
      stored IsEIS default True;
    property EnableUpdate: Boolean read GetEnableUpdate write SetEnableUpdate
      stored IsEUS default True;
    property UpdateChangedFields: Boolean read GetUpdateChangedFields
      write SetUpdateChangedFields stored IsUCFS default True;
    property UpdateMode: TUpdateMode read GetUpdateMode write SetUpdateMode
      stored IsUMS default upWhereKeyOnly;
    property LockMode: TADLockMode read GetLockMode write SetLockMode
      stored IsLMS default lmRely;
    property LockPoint: TADLockPoint read GetLockPoint write SetLockPoint
      stored IsLPS default lpDeferred;
    property LockWait: Boolean read GetLockWait write SetLockWait
      stored IsLWS default False;
    property RefreshMode: TADRefreshMode read GetRefreshMode write SetRefreshMode
      stored IsRMS default rmOnDemand;
    property CountUpdatedRecords: Boolean read GetCountUpdatedRecords
      write SetCountUpdatedRecords stored IsCURS default True;
    property CacheUpdateCommands: Boolean read GetCacheUpdateCommands
      write SetCacheUpdateCommands stored IsCUAS default True;
    property UseProviderFlags: Boolean read GetUseProviderFlags
      write SetUseProviderFlags stored IsUPFS default True;
    // short-cuts
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly
      stored False default False;
    property FastUpdates: Boolean read GetFastUpdates write SetFastUpdates
      stored False default False;
    property RequestLive: Boolean read GetRequestLive write SetRequestLive
      stored False default False;
  end;

  TADBottomUpdateOptions = class(TADUpdateOptions)
  private
    procedure SetUpdateTableName(const Value: String);
  protected
    FUpdateTableName: String;
  public
    procedure Assign(ASource: TPersistent); override;
    procedure RestoreDefaults; override;
  published
    property UpdateTableName: String read FUpdateTableName write
      SetUpdateTableName;
  end;

  TADResourceOptions = class(TADCustomOptions)
  private
    function GetMacroCreate: Boolean;
    function GetParamCreate: Boolean;
    function GetParentResourceOptions(const AParentOpts: IADStanOptions): TADResourceOptions;
    function IsMCS: Boolean;
    function IsPCS: Boolean;
    procedure SetMacroCreate(const AValue: Boolean);
    procedure SetParamCreate(const AValue: Boolean);
    function GetDisconnectable: Boolean;
    function IsDS: Boolean;
    procedure SetDisconnectable(const AValue: Boolean);
    function GetAsyncCmdMode: TADStanAsyncMode;
    function GetAsyncCmdTimeout: LongWord;
    function IsACOMS: Boolean;
    function IsACOTS: Boolean;
    procedure SetAsyncCmdMode(const AValue: TADStanAsyncMode);
    procedure SetAsyncCmdTimeout(const AValue: LongWord);
    function GetDirectExecute: Boolean;
    function IsDES: Boolean;
    procedure SetDirectExecute(const AValue: Boolean);
    function GetEscapeExpand: Boolean;
    function GetMacroExpand: Boolean;
    function GetParamExpand: Boolean;
    function IsEPS: Boolean;
    function IsMES: Boolean;
    function IsPES: Boolean;
    procedure SetEscapeExpand(const AValue: Boolean);
    procedure SetMacroExpand(const AValue: Boolean);
    procedure SetParamExpand(const AValue: Boolean);
    function GetDefaultParamType: TParamType;
    function IsDPTS: Boolean;
    procedure SetDefaultParamType(const AValue: TParamType);
  protected
    FParamCreate: Boolean;
    FMacroCreate: Boolean;
    FParamExpand: Boolean;
    FMacroExpand: Boolean;
    FEscapeExpand: Boolean;
    FDisconnectable: Boolean;
    FAsyncCmdMode: TADStanAsyncMode;
    FAsyncCmdTimeout: LongWord;
    FDirectExecute: Boolean;
    FDefaultParamType: TParamType;
    FAssignedValues: TADResourceOptionValues;
  public
    procedure Assign(ASource: TPersistent); override;
    procedure RestoreDefaults; override;
    function IsValueOwned(AValue: TADResourceOptionValue; out AParentOpts: IADStanOptions): Boolean;
    property AssignedValues: TADResourceOptionValues read FAssignedValues;
  published
    property ParamCreate: Boolean read GetParamCreate write SetParamCreate
      stored IsPCS default True;
    property MacroCreate: Boolean read GetMacroCreate write SetMacroCreate
      stored IsMCS default True;
    property ParamExpand: Boolean read GetParamExpand write SetParamExpand
      stored IsPES default True;
    property MacroExpand: Boolean read GetMacroExpand write SetMacroExpand
      stored IsMES default True;
    property EscapeExpand: Boolean read GetEscapeExpand write SetEscapeExpand
      stored IsEPS default True;
    property Disconnectable: Boolean read GetDisconnectable write SetDisconnectable
      stored IsDS default True;
    property AsyncCmdMode: TADStanAsyncMode read GetAsyncCmdMode
      write SetAsyncCmdMode stored IsACOMS default amBlocking;
    property AsyncCmdTimeout: LongWord read GetAsyncCmdTimeout
      write SetAsyncCmdTimeout stored IsACOTS default $FFFFFFFF;
    property DirectExecute: Boolean read GetDirectExecute
      write SetDirectExecute stored IsDES default False;
    property DefaultParamType: TParamType read GetDefaultParamType
      write SetDefaultParamType stored IsDPTS default ptInput;
  end;

  TADTopResourceOptions = class(TADResourceOptions)
  private
    function GetMaxCursors: Integer;
    procedure SetMaxCursors(const AValue: Integer);
    function IsMCS: Boolean;
    function GetServerOutput: Boolean;
    function IsSOS: Boolean;
    procedure SetServerOutput(const AValue: Boolean);
    function GetServerOutputSize: Integer;
    function IsSOSS: Boolean;
    procedure SetServerOutputSize(const AValue: Integer);
  protected
    FMaxCursors: Integer;
    FServerOutput: Boolean;
    FServerOutputSize: Integer;
  public
    procedure Assign(ASource: TPersistent); override;
    procedure RestoreDefaults; override;
  published
    property MaxCursors: Integer read GetMaxCursors write SetMaxCursors
      stored IsMCS default - 1;
    property ServerOutput: Boolean read GetServerOutput
      write SetServerOutput stored IsSOS default False;
    property ServerOutputSize: Integer read GetServerOutputSize
      write SetServerOutputSize stored IsSOSS default 20000;
  end;

  TADTxOptions = class (TPersistent)
  private
    procedure SetAutoCommit(const AValue: Boolean);
    procedure SetIsolation(const AValue: TADTxIsolation);
  protected
    FAutoCommit: Boolean;
    FDisconnectAction: TADTxDisconnectAction;
    FIsolation: TADTxIsolation;
    FChanged: TADTxValues;
  public
    constructor Create;
    procedure ClearChanged;
    procedure SetIsolationAsStr(const AValue: String);
    property Changed: TADTxValues read FChanged;
  published
    property DisconnectAction: TADTxDisconnectAction read FDisconnectAction
      write FDisconnectAction default xdRollback;
    property AutoCommit: Boolean read FAutoCommit write SetAutoCommit default True;
    property Isolation: TADTxIsolation read FIsolation write SetIsolation
      default xiReadCommitted;
  end;

implementation

uses
{$IFDEF AnyDAC_D6Base}
  {$IFDEF AnyDAC_D6}
  FmtBcd, SqlTimSt,
  {$ENDIF}
{$ELSE}
  ComObj,  
{$ENDIF}    
  TypInfo,
  daADStanError, daADStanUtil;

{-------------------------------------------------------------------------------}
const
  C_AD_MaxFixedSize = 134; // BCD -> WIAD STR: 2 * (64 digits + 1 sign + 1 dec.sep. + 1 zero byte)
  C_AD_AllowedConversions: array[TADDataType {src}, TADDataType {dest}] of Byte = (
    (1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    (0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    (0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    (0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    (0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    (0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    (0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    (0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    (0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    (0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    (0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    (0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    (0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    (0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    (0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0),
    (0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0),
    (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0),
    (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0),
    (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0),
    (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1)
  );

{-------------------------------------------------------------------------------}
{- TADCustomOptions                                                            -}
{-------------------------------------------------------------------------------}
{$HINTS OFF}
constructor TADCustomOptions.Create(const AOwner: TObject);
var
  lRes: Boolean;
begin
  inherited Create;
  if AOwner <> nil then begin
    if AOwner is TPersistent then
      FOwnerObj := TPersistent(AOwner);
    lRes := Supports(AOwner, IADStanOptions, FOwner);
    ASSERT(lRes, 'Supports(AOwner, IADStanOptions, FOwner)');
    FOwner._Release;
  end;
  RestoreDefaults;
end;
{$HINTS ON}

{-------------------------------------------------------------------------------}
procedure TADCustomOptions.BeforeDestruction;
begin
  if FOwner <> nil then
    FOwner._AddRef;
  inherited BeforeDestruction;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomOptions.Changed;
begin
  if Assigned(FOnChanged) then
    FOnChanged(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomOptions.Changing;
begin
  if Assigned(FOnChanging) then
    FOnChanging(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomOptions.RestoreDefaults;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
function TADCustomOptions.GetOwner: TPersistent;
begin
  Result := FOwnerObj;
end;

{-------------------------------------------------------------------------------}
{- TADMapRule                                                                  -}
{-------------------------------------------------------------------------------}
constructor TADMapRule.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FPrecMax := C_AD_DefMapPrec;
  FPrecMin := C_AD_DefMapPrec;
  FScaleMax := C_AD_DefMapScale;
  FScaleMin := C_AD_DefMapScale;
  FSizeMax := C_AD_DefMapSize;
  FSizeMin := C_AD_DefMapSize;
  FSourceDataType := dtUnknown;
  FTargetDataType := dtUnknown;
end;

{-------------------------------------------------------------------------------}
procedure TADMapRule.Assign(Source: TPersistent);
begin
  if Source is TADMapRule then begin
    FPrecMax := TADMapRule(Source).FPrecMax;
    FPrecMin := TADMapRule(Source).FPrecMin;
    FScaleMax := TADMapRule(Source).FScaleMax;
    FScaleMin := TADMapRule(Source).FScaleMin;
    FSizeMax := TADMapRule(Source).FSizeMax;
    FSizeMin := TADMapRule(Source).FSizeMin;
    FSourceDataType := TADMapRule(Source).FSourceDataType;
    FTargetDataType := TADMapRule(Source).FTargetDataType;
  end
  else
    inherited Assign(Source);
end;

{-------------------------------------------------------------------------------}
procedure TADMapRule.Changed;
begin
  if Collection <> nil then
    TADMapRules(Collection).FFormatOptions.Changed;
end;

{-------------------------------------------------------------------------------}
procedure TADMapRule.Changing;
begin
  if Collection <> nil then
    TADMapRules(Collection).FFormatOptions.Changing;
end;

{-------------------------------------------------------------------------------}
procedure TADMapRule.SetPrecMax(Value: Integer);
begin
  if FPrecMax <> Value then
  begin
    Changing;
    FPrecMax := Value;
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADMapRule.SetPrecMin(Value: Integer);
begin
  if FPrecMin <> Value then
  begin
    Changing;
    FPrecMin := Value;
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADMapRule.SetScaleMax(Value: Integer);
begin
  if FScaleMax <> Value then
  begin
    Changing;
    FScaleMax := Value;
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADMapRule.SetScaleMin(Value: Integer);
begin
  if FScaleMin <> Value then
  begin
    Changing;
    FScaleMin := Value;
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADMapRule.SetSizeMax(Value: LongWord);
begin
  if FSizeMax <> Value then
  begin
    Changing;
    FSizeMax := Value;
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADMapRule.SetSizeMin(Value: LongWord);
begin
  if FSizeMin <> Value then
  begin
    Changing;
    FSizeMin := Value;
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADMapRule.SetSourceDataType(Value: TADDataType);
begin
  if FSourceDataType <> Value then
  begin
    if (Collection <> nil) and (TADMapRules(Collection).FFormatOptions <> nil) and
       (Value <> dtUnknown) and (FTargetDataType <> dtUnknown) then
      TADMapRules(Collection).FFormatOptions.CheckConversion(Value, FTargetDataType);
    Changing;
    FSourceDataType := Value;
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADMapRule.SetTargetDataType(Value: TADDataType);
begin
  if FTargetDataType <> Value then
  begin
    if (Collection <> nil) and (TADMapRules(Collection).FFormatOptions <> nil) and
       (Value <> dtUnknown) and (FSourceDataType <> dtUnknown) then
      TADMapRules(Collection).FFormatOptions.CheckConversion(FSourceDataType, Value);
    Changing;
    FTargetDataType := Value;
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
function TADMapRule.GetDisplayName: string;
var
  pTI: PTypeInfo;
begin
  if (FSourceDataType = dtUnknown) and (FTargetDataType = dtUnknown) then
    Result := inherited GetDisplayName
  else begin
    pTI := TypeInfo(TADDataType);
    Result :=
      GetEnumName(pTI, Integer(FSourceDataType)) +
      ' -> ' +
      GetEnumName(pTI, Integer(FTargetDataType));
  end;
end;

{-------------------------------------------------------------------------------}
{- TADMapRules                                                                 -}
{-------------------------------------------------------------------------------}
constructor TADMapRules.Create(AFormatOptions: TADFormatOptions);
begin
  inherited Create(TADMapRule);
  FFormatOptions := AFormatOptions;
end;

{-------------------------------------------------------------------------------}
function TADMapRules.Add: TADMapRule;
begin
  Result := TADMapRule(inherited Add);
end;

{-------------------------------------------------------------------------------}
function TADMapRules.GetItems(AIndex: Integer): TADMapRule;
begin
  Result := TADMapRule(inherited Items[AIndex]);
end;

{-------------------------------------------------------------------------------}
function TADMapRules.GetOwner: TPersistent;
begin
  Result := FFormatOptions;
end;

{-------------------------------------------------------------------------------}
{- TADFormatOptions                                                            -}
{-------------------------------------------------------------------------------}
constructor TADFormatOptions.Create(const AOwner: TObject);
begin
  FMapRules := TADMapRules.Create(Self);
  inherited Create(AOwner);
end;

{-------------------------------------------------------------------------------}
destructor TADFormatOptions.Destroy;
begin
  FreeAndNil(FMapRules);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADFormatOptions.Assign(ASource: TPersistent);
begin
  if (ASource = nil) or (ASource = Self) then
    Exit;
  if ASource is TADFormatOptions then begin
    if fvMapRules in TADFormatOptions(ASource).FAssignedValues then
      MapRules.Assign(TADFormatOptions(ASource).MapRules);
    if fvSE2Null in TADFormatOptions(ASource).FAssignedValues then
      StrsEmpty2Null := TADFormatOptions(ASource).StrsEmpty2Null;
    if fvStrsTrim in TADFormatOptions(ASource).FAssignedValues then
      StrsTrim := TADFormatOptions(ASource).StrsTrim;
    if fvMaxStringSize in TADFormatOptions(ASource).FAssignedValues then
      MaxStringSize := TADFormatOptions(ASource).MaxStringSize;
    if fvMaxBcdPrecision in TADFormatOptions(ASource).FAssignedValues then
      MaxBcdPrecision := TADFormatOptions(ASource).MaxBcdPrecision;
    if fvMaxBcdScale in TADFormatOptions(ASource).FAssignedValues then
      MaxBcdScale := TADFormatOptions(ASource).MaxBcdScale;
    if fvInlineDataSize in TADFormatOptions(ASource).FAssignedValues then
      InlineDataSize := TADFormatOptions(ASource).InlineDataSize;
    if fvDefaultParamDataType in TADFormatOptions(ASource).FAssignedValues then
      DefaultParamDataType := TADFormatOptions(ASource).DefaultParamDataType
  end
  else
    inherited Assign(ASource);
end;

{-------------------------------------------------------------------------------}
procedure TADFormatOptions.RestoreDefaults;
begin
  FAssignedValues := [];
  FStrsEmpty2Null := True;
  FStrsTrim := False;
  FMaxStringSize := C_AD_MaxDlp4StrSize;
  FMaxBcdPrecision := 18;
  FMaxBcdScale := 4;
  FMapRules.Clear;
  FInlineDataSize := -1;
  FDefaultParamDataType := ftUnknown;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.IsValueOwned(AValue: TADFormatOptionValue;
  out AParentOpts: IADStanOptions): Boolean;
begin
  Result := (FOwner = nil) or (AValue in FAssignedValues);
  if not Result then begin
    FOwner.GetParentOptions(AParentOpts);
    Result := (AParentOpts = nil);
  end
  else
    AParentOpts := nil;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.GetParentFormatOptions(
  const AParentOpts: IADStanOptions): TADFormatOptions;
begin
  if (FOwner <> nil) and (AParentOpts <> nil) then
    Result := AParentOpts.FormatOptions
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.GetMapRules: TADMapRules;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(fvMapRules, oParentOpts) then
    Result := FMapRules
  else
    Result := GetParentFormatOptions(oParentOpts).MapRules;
end;

{-------------------------------------------------------------------------------}
procedure TADFormatOptions.SetMapRules(const Value: TADMapRules);
begin
  Changing;
  FMapRules.Assign(Value);
  Include(FAssignedValues, fvMapRules);
  Changed;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.IsMRS: Boolean;
begin
  Result := fvMapRules in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
procedure TADFormatOptions.SetOwnMapRules(const AValue: Boolean);
var
  oParentOpts: IADStanOptions;
begin
  if (fvMapRules in FAssignedValues) <> AValue then
    if AValue then begin
      if (FOwner <> nil) and FOwner.GetParentOptions(oParentOpts) then
        FMapRules.Assign(oParentOpts.FormatOptions.MapRules);
      Include(FAssignedValues, fvMapRules);
    end
    else begin
      if (FOwner <> nil) and FOwner.GetParentOptions(oParentOpts) then
        FMapRules.Clear;
      Exclude(FAssignedValues, fvMapRules);
    end;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.GetStrsEmpty2Null: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(fvSE2Null, oParentOpts) then
    Result := FStrsEmpty2Null
  else
    Result := GetParentFormatOptions(oParentOpts).StrsEmpty2Null;
end;

{-------------------------------------------------------------------------------}
procedure TADFormatOptions.SetStrsEmpty2Null(Value: Boolean);
begin
  if not (fvSE2Null in FAssignedValues) or (FStrsEmpty2Null <> Value) then begin
    Changing;
    FStrsEmpty2Null := Value;
    Include(FAssignedValues, fvSE2Null);
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.IsSE2NS: Boolean;
begin
  Result := fvSE2Null in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.GetStrsTrim: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(fvStrsTrim, oParentOpts) then
    Result := FStrsTrim
  else
    Result := GetParentFormatOptions(oParentOpts).StrsTrim;
end;

{-------------------------------------------------------------------------------}
procedure TADFormatOptions.SetStrsTrim(Value: Boolean);
begin
  if not (fvStrsTrim in FAssignedValues) or (FStrsTrim <> Value) then begin
    Changing;
    FStrsTrim := Value;
    Include(FAssignedValues, fvStrsTrim);
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.IsSTS: Boolean;
begin
  Result := fvStrsTrim in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.GetStrsDivLen2: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(fvStrsDivLen2, oParentOpts) then
    Result := FStrsDivLen2
  else
    Result := GetParentFormatOptions(oParentOpts).StrsDivLen2;
end;

{-------------------------------------------------------------------------------}
procedure TADFormatOptions.SetStrsDivLen2(const Value: Boolean);
begin
  if not (fvStrsDivLen2 in FAssignedValues) or (FStrsDivLen2 <> Value) then begin
    Changing;
    FStrsDivLen2 := Value;
    Include(FAssignedValues, fvStrsDivLen2);
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.IsSDL2S: Boolean;
begin
  Result := fvStrsDivLen2 in AssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.GetMaxStringSize: LongWord;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(fvMaxStringSize, oParentOpts) then
    Result := FMaxStringSize
  else
    Result := GetParentFormatOptions(oParentOpts).MaxStringSize;
end;

{-------------------------------------------------------------------------------}
procedure TADFormatOptions.SetMaxStringSize(const Value: LongWord);
begin
  if not (fvMaxStringSize in FAssignedValues) or (FMaxStringSize <> Value) then begin
    Changing;
    FMaxStringSize := Value;
    Include(FAssignedValues, fvMaxStringSize);
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.IsMSSS: Boolean;
begin
  Result := fvMaxStringSize in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.GetMaxBcdPrecision: Integer;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(fvMaxBcdPrecision, oParentOpts) then
    Result := FMaxBcdPrecision
  else
    Result := GetParentFormatOptions(oParentOpts).MaxBcdPrecision;
end;

{-------------------------------------------------------------------------------}
procedure TADFormatOptions.SetMaxBcdPrecision(const Value: Integer);
begin
  if not (fvMaxBcdPrecision in FAssignedValues) or (FMaxBcdPrecision <> Value) then begin
    Changing;
    FMaxBcdPrecision := Value;
    Include(FAssignedValues, fvMaxBcdPrecision);
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.IsMBPS: Boolean;
begin
  Result := fvMaxBcdPrecision in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.GetMaxBcdScale: Integer;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(fvMaxBcdScale, oParentOpts) then
    Result := FMaxBcdScale
  else
    Result := GetParentFormatOptions(oParentOpts).MaxBcdScale;
end;

{-------------------------------------------------------------------------------}
procedure TADFormatOptions.SetMaxBcdScale(const Value: Integer);
begin
  if not (fvMaxBcdScale in FAssignedValues) or (FMaxBcdScale <> Value) then begin
    Changing;
    FMaxBcdScale := Value;
    Include(FAssignedValues, fvMaxBcdScale);
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.IsMBSS: Boolean;
begin
  Result := fvMaxBcdScale in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.GetInlineDataSize: Integer;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(fvInlineDataSize, oParentOpts) then
    Result := FInlineDataSize
  else
    Result := GetParentFormatOptions(oParentOpts).InlineDataSize;
end;

{-------------------------------------------------------------------------------}
procedure TADFormatOptions.SetInlineDataSize(const AValue: Integer);
begin
  if not (fvInlineDataSize in FAssignedValues) or (FInlineDataSize <> AValue) then begin
    Changing;
    FInlineDataSize := AValue;
    Include(FAssignedValues, fvInlineDataSize);
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.IsIDSS: Boolean;
begin
  Result := fvInlineDataSize in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.GetDefaultParamDataType: TFieldType;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(fvDefaultParamDataType, oParentOpts) then
    Result := FDefaultParamDataType
  else
    Result := GetParentFormatOptions(oParentOpts).DefaultParamDataType;
end;

{-------------------------------------------------------------------------------}
procedure TADFormatOptions.SetDefaultParamDataType(const AValue: TFieldType);
begin
  if not (fvDefaultParamDataType in FAssignedValues) or (FDefaultParamDataType <> AValue) then begin
    Changing;
    FDefaultParamDataType := AValue;
    Include(FAssignedValues, fvDefaultParamDataType);
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.IsDPDTS: Boolean;
begin
  Result := fvDefaultParamDataType in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
procedure TADFormatOptions.ResolveDataType(ASrcDataType: TADDataType;
  ASrcSize: LongWord; ASrcPrec, ASrcScale: Integer; var ADestDataType: TADDataType;
  AForward: Boolean);
var
  i: Integer;
  oRules: TADMapRules;
begin
  ADestDataType := ASrcDataType;
  oRules := MapRules;
  for i := 0 to oRules.Count - 1 do
    with oRules[i] do
      if (AForward and (SourceDataType = ASrcDataType) or
          not AForward and (TargetDataType = ASrcDataType)) and
         ((SizeMin = C_AD_DefMapSize) or (ASrcSize <= 0) or (SizeMin <= ASrcSize)) and
         ((SizeMax = C_AD_DefMapSize) or (ASrcSize <= 0) or (SizeMax >= ASrcSize)) and
         ((PrecMin = C_AD_DefMapPrec) or (ASrcPrec <= 0) or (PrecMin <= ASrcPrec)) and
         ((PrecMax = C_AD_DefMapPrec) or (ASrcPrec <= 0) or (PrecMax >= ASrcPrec)) and
         ((ScaleMin = C_AD_DefMapScale) or (ASrcScale < 0) or (ScaleMin <= ASrcScale)) and
         ((ScaleMax = C_AD_DefMapScale) or (ASrcScale < 0) or (ScaleMax >= ASrcScale)) then begin
        if AForward then
          ADestDataType := TargetDataType
        else
          ADestDataType := SourceDataType;
        Break;
      end;
{$IFDEF AnyDAC_FPC}
  if ADestDataType = ASrcDataType then begin
    if AForward then begin
      case ASrcDataType of
      dtCurrency:      ADestDataType := dtBCD;
      dtWideString:    ADestDataType := dtAnsiString;
      dtWideHMemo:     ADestDataType := dtHMemo;
      dtWideMemo:      ADestDataType := dtMemo;
      dtGuid:          ADestDataType := dtAnsiString;
      dtDateTimeStamp: ADestDataType := dtDateTime;
      dtFMTBcd:        ADestDataType := dtDouble;
      end;
    end;
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TADFormatOptions.ResolveFieldType(ASrcFieldType: TFieldType;
  ASrcADFieldType: TADDataType; ASrcSize: LongWord; ASrcPrecision: Integer;
  var ADestFieldType: TFieldType; var ADestSize: LongWord;
  var ADestPrecision: Integer; var ASrcDataType, ADestDataType: TADDataType;
  AForward: Boolean);
var
  iSrcScale, iSrcPrec: Integer;
  iSrcSize: LongWord;
  iSrcAttrs: TADDataAttributes;
begin
  iSrcAttrs := [];
  iSrcSize := 0;
  iSrcPrec := 0;
  iSrcScale := 0;
  FieldDef2ColumnDef(ASrcFieldType, ASrcSize, ASrcPrecision, ASrcDataType,
    iSrcScale, iSrcPrec, iSrcSize, iSrcAttrs);
  if (ASrcDataType = dtHMemo) and (ASrcADFieldType = dtWideHMemo) then
    ASrcDataType := dtWideHMemo
  else if (ASrcDataType = dtHBlob) and (ASrcADFieldType = dtHBFile) then
    ASrcDataType := dtHBFile
  else if (ASrcDataType = dtDateTime) and (ASrcADFieldType = dtDateTimeStamp) then
    ASrcDataType := dtDateTimeStamp;
  ResolveDataType(ASrcDataType, iSrcSize, iSrcPrec, iSrcScale,
    ADestDataType, AForward);
  ColumnDef2FieldDef(ADestDataType, iSrcScale, iSrcPrec, iSrcSize, iSrcAttrs,
    ADestFieldType, ADestSize, ADestPrecision);
end;

{-------------------------------------------------------------------------------}
procedure TADFormatOptions.ColumnDef2FieldDef(ASrcDataType: TADDataType;
  ASrcScale, ASrcPrec: Integer; ASrcSize: LongWord; ASrcAttrs: TADDataAttributes;
  var ADestFieldType: TFieldType; var ADestSize: LongWord; var ADestPrec: Integer);
begin
  ADestFieldType := ftUnknown;
  ADestSize := 0;
  ADestPrec := 0;
  case ASrcDataType of
    dtUnknown:
      ;
    dtBoolean:
      ADestFieldType := ftBoolean;
    dtSByte:
      ADestFieldType := ftSmallint;
    dtInt16:
      ADestFieldType := ftSmallint;
    dtInt32:
      if caAutoInc in ASrcAttrs then
        ADestFieldType := ftAutoInc
      else
        ADestFieldType := ftInteger;
    dtInt64, dtUInt64:
//      if caAutoInc in ASrcAttrs then
//        ADestFieldType := ftAutoInc
//      else
        ADestFieldType := ftLargeint;
    dtByte:
      ADestFieldType := ftWord;
    dtUInt16:
      ADestFieldType := ftWord;
    dtUInt32:
      ADestFieldType := ftInteger;
    dtDouble:
      begin
        ADestFieldType := ftFloat;
        ADestPrec := ASrcPrec;
      end;
    dtCurrency:
      begin
        ADestFieldType := ftCurrency;
        ADestPrec := ASrcPrec;
      end;
    dtBCD, dtFmtBCD:
      begin
{$IFDEF AnyDAC_D6}
        if (ASrcDataType = dtFmtBCD) or
           (ASrcPrec > MaxBcdPrecision) or (ASrcScale > MaxBcdScale) then
          ADestFieldType := ftFMTBcd
        else
{$ENDIF}
          ADestFieldType := ftBcd;
        ADestSize := ASrcScale;
        ADestPrec := ASrcPrec;
      end;
    dtDateTimeStamp:
{$IFDEF AnyDAC_D6}
      ADestFieldType := ftTimeStamp;
{$ELSE}
      ADestFieldType := ftDateTime;
{$ENDIF}
    dtDateTime:
      ADestFieldType := ftDateTime;
    dtTime:
      ADestFieldType := ftTime;
    dtDate:
      ADestFieldType := ftDate;
    dtAnsiString:
      begin
        ADestSize := ASrcSize;
        if ASrcSize > MaxStringSize then
          ADestFieldType := ftMemo
        else begin
          if caFixedLen in ASrcAttrs then
            ADestFieldType := ftFixedChar
          else
            ADestFieldType := ftString;
// ???       if ADestSize = 0 then
//          ADestSize := MaxStringSize;
        end;
      end;
    dtWideString:
      begin
        ADestSize := ASrcSize;
        if ASrcSize > MaxStringSize then
          ADestFieldType := ftFmtMemo
        else begin
          ADestFieldType := ftWideString;
// ???       if ADestSize = 0 then
//          ADestSize := MaxStringSize;
        end;
      end;
    dtByteString:
      begin
        ADestSize := ASrcSize;
        if ASrcSize > MaxStringSize then
          ADestFieldType := ftBlob
        else begin
          if caFixedLen in ASrcAttrs then
            ADestFieldType := ftBytes
          else
            ADestFieldType := ftVarBytes;
// ???       if ADestSize = 0 then
//          ADestSize := MaxStringSize;
        end;
      end;
    dtBlob:
      ADestFieldType := ftBlob;
    dtMemo:
      ADestFieldType := ftMemo;
    dtWideMemo:
      ADestFieldType := ftFmtMemo;
    dtHBlob:
      ADestFieldType := ftOraBlob;
    dtHBFile:
      ADestFieldType := ftOraBlob;
    dtHMemo:
      ADestFieldType := ftOraClob;
    dtWideHMemo:
      ADestFieldType := ftOraClob;
    dtObject:
      ADestFieldType := ftInterface;
    dtRowSetRef:
      ADestFieldType := ftDataSet;
    dtCursorRef:
      ADestFieldType := ftCursor;
    dtRowRef:
      ADestFieldType := ftAdt;
    dtArrayRef:
      ADestFieldType := ftArray;
    dtParentRowRef:
      ADestFieldType := ftReference;
    dtGUID:
      begin
        ADestFieldType := ftGUID;
        ADestSize := C_AD_GUIDStrLen;
      end;
  end;
end;

{-------------------------------------------------------------------------------}
class procedure TADFormatOptions.FieldDef2ColumnDef(ASrcFieldType: TFieldType;
  ASrcSize: LongWord; ASrcPrec: Integer; var ADestDataType: TADDataType;
  var ADestScale, ADestPrec: Integer; var ADestSize: LongWord;
  var ADestAttrs: TADDataAttributes);
begin
  ADestDataType := dtUnknown;
  ADestScale := 0;
  ADestPrec := 0;
  ADestSize := 0;
  ADestAttrs := [];
  case ASrcFieldType of
    ftUnknown:
      ;
    ftBoolean:
      ADestDataType := dtBoolean;
    ftSmallint:
      ADestDataType := dtInt16;
    ftAutoInc:
      begin
        ADestDataType := dtInt32;
        ADestAttrs := [caAutoInc];
      end;
    ftInteger:
      ADestDataType := dtInt32;
    ftLargeint:
      ADestDataType := dtInt64;
    ftWord:
      ADestDataType := dtUInt16;
    ftFloat:
      begin
        ADestDataType := dtDouble;
        ADestPrec := ASrcPrec;
      end;
    ftCurrency:
      begin
        ADestDataType := dtCurrency;
        ADestPrec := ASrcPrec;
      end;
{$IFDEF AnyDAC_D6}
    ftFmtBCD:
      begin
        ADestDataType := dtFmtBCD;
        ADestScale := ASrcSize;
        ADestPrec := ASrcPrec;
      end;
{$ENDIF}
    ftBcd:
      begin
        ADestDataType := dtBCD;
        ADestScale := ASrcSize;
        ADestPrec := ASrcPrec;
      end;
{$IFDEF AnyDAC_D6}
    ftTimeStamp:
      ADestDataType := dtDateTimeStamp;
{$ENDIF}
    ftDateTime:
      ADestDataType := dtDateTime;
    ftTime:
      ADestDataType := dtTime;
    ftDate:
      ADestDataType := dtDate;
    ftFixedChar:
      begin
        ADestDataType := dtAnsiString;
        ADestSize := ASrcSize;
        ADestAttrs := [caFixedLen];
      end;
    ftString:
      begin
        ADestDataType := dtAnsiString;
        ADestSize := ASrcSize;
      end;
    ftWideString:
      begin
        ADestDataType := dtWideString;
        ADestSize := ASrcSize;
      end;
    ftBytes:
      begin
        ADestDataType := dtByteString;
        ADestSize := ASrcSize;
        ADestAttrs := [caFixedLen];
      end;
    ftVarBytes:
      begin
        ADestDataType := dtByteString;
        ADestSize := ASrcSize;
        ADestAttrs := [];
      end;
    ftBlob, ftGraphic, ftParadoxOle, ftDBaseOle, ftTypedBinary:
      begin
        ADestDataType := dtBlob;
        ADestAttrs := [caBlobData];
      end;
    ftMemo:
      begin
        ADestDataType := dtMemo;
        ADestAttrs := [caBlobData];
      end;
    ftFmtMemo:
      begin
        ADestDataType := dtWideMemo;
        ADestAttrs := [caBlobData];
      end;
    ftOraBlob:
      begin
        ADestDataType := dtHBlob;
        ADestAttrs := [caBlobData];
      end;
    ftOraClob:
      begin
        ADestDataType := dtHMemo;
        ADestAttrs := [caBlobData];
      end;
    ftInterface, ftIDispatch:
      ADestDataType := dtObject;
    ftReference, ftVariant:
      ADestDataType := dtUnknown;
    ftCursor:
      ADestDataType := dtCursorRef;
    ftDataSet:
      ADestDataType := dtRowSetRef;
    ftAdt:
      ADestDataType := dtRowRef;
    ftArray:
      ADestDataType := dtArrayRef;
    ftGUID:
      ADestDataType := dtGUID;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADFormatOptions.CheckConversion(ASrc, ADest: TADDataType);
begin
  if C_AD_AllowedConversions[ASrc, ADest] = 0 then
    ADException(nil, [S_AD_LStan], er_AD_ConvIsNotSupported, []);
end;

{-------------------------------------------------------------------------------}
const
  SF_D: String = '%d';
  SF_U: String = '%u';
  SF_F: String = '%f';
  SF_S: String = '%s';
  SWF_D: WideString = '%d';
  SWF_U: WideString = '%u';
  SWF_F: WideString = '%f';
  SWF_S: WideString = '%s';
  RLongDate: TADSQLTimeStamp = (Year: 2002; Month: 9; Day: 29; Hour: 23;
    Minute: 59; Second: 59; Fractions: 999);
var
  C_AD_MaxLenTimeStampStr: Integer = -1;

procedure TADFormatOptions.ConvertRawData(ASrcType, ADestType: TADDataType;
  ApSrc: Pointer; ASrcSize: LongWord; var ApDest: Pointer; ADestMaxSize: LongWord;
  var ADestSize: LongWord);
var
  lConverted: Boolean;
  rSTS: TADSQLTimeStamp;
  buff: array [0 .. 255] of Char;

  function GetStorageSize: Integer;
  begin
    case ADestType of
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
    dtDateTime:     Result := Sizeof(TDateTimeRec);
    dtDateTimeStamp:Result := Sizeof(TADSQLTimeStamp);
    dtTime:         Result := Sizeof(Longint);
    dtDate:         Result := Sizeof(Longint);
    dtGUID:         Result := Sizeof(TGUID);
    dtObject:       Result := Sizeof(IADDataStoredObject);
    else            Result := 0;
    end;
  end;

  procedure ValToStr(const AFmt: String; const Value: array of const);
  var
    pBuff: Pointer;
    iLen: Integer;
  begin
    if ApDest = nil then begin
      pBuff := @(buff[0]);
      iLen := SizeOf(buff);
    end
    else begin
      pBuff := ApDest;
      iLen := ADestMaxSize;
    end;
    ADestSize := FormatBuf(pBuff^, iLen, PChar(AFmt)^, Length(AFmt), Value) + 1;
    PChar(pBuff)[ADestSize - 1] := #0;
  end;

  procedure ValToWStr(const AFmt: WideString; const Value: array of const);
  var
    pBuff: Pointer;
    iLen: Integer;
{$IFNDEF AnyDAC_D6}
    s: String;
{$ENDIF}
  begin
    if ApDest = nil then begin
      pBuff := @(buff[0]);
      iLen := SizeOf(buff);
    end
    else begin
      pBuff := ApDest;
      iLen := ADestMaxSize;
    end;
{$IFDEF AnyDAC_D6}
    ADestSize := WideFormatBuf(pBuff^, iLen div SizeOf(WideChar),
      PWideChar(AFmt)^, Length(AFmt), Value) + 1;
{$ELSE}
    s := Format(AFmt, Value);
    ADestSize := MultiByteToWideChar(0, 0, PChar(s), Length(s),
      PWideChar(pBuff), iLen - 1) + 1;
{$ENDIF}
    PWideChar(pBuff)[ADestSize - 1] := #0;
  end;

  procedure AnsiStr2Dest;
  begin
    case ADestType of
    dtBoolean: PWordBool(ApDest)^ := PChar(ApSrc)^ in ['T', 't', 'Y', 'y'];
    dtSByte:   ADStr2Int(PChar(ApSrc), ASrcSize, ApDest, SizeOf(ShortInt), False);
    dtInt16:   ADStr2Int(PChar(ApSrc), ASrcSize, ApDest, SizeOf(SmallInt), False);
    dtInt32:   ADStr2Int(PChar(ApSrc), ASrcSize, ApDest, SizeOf(Integer), False);
    dtInt64:   ADStr2Int(PChar(ApSrc), ASrcSize, ApDest, SizeOf(Int64), False);
    dtByte:    ADStr2Int(PChar(ApSrc), ASrcSize, ApDest, SizeOf(Byte), True);
    dtUInt16:  ADStr2Int(PChar(ApSrc), ASrcSize, ApDest, SizeOf(Word), True);
    dtUInt32:  ADStr2Int(PChar(ApSrc), ASrcSize, ApDest, SizeOf(LongWord), True);
    dtUInt64:  ADStr2Int(PChar(ApSrc), ASrcSize, ApDest, SizeOf(UInt64), True);
    dtDouble:  PDouble(ApDest)^ := StrToFloat(PChar(ApSrc)^);
    dtCurrency:PCurrency(ApDest)^ := StrToCurr(PChar(ApSrc)^);
    dtBCD,
    dtFmtBCD:  ADStr2BCD(PChar(ApSrc), ASrcSize, PADBcd(ApDest)^, DecimalSeparator);
    dtDateTime:PADDateTimeData(ApDest)^.DateTime := TimeStampToMSecs(DateTimeToTimeStamp(StrToDateTime(PChar(ApSrc)^)));
    dtTime:    PLongword(ApDest)^ := ADDateTime2Time(StrToDateTime(PChar(ApSrc)^));
    dtDate:    PLongword(ApDest)^ := ADDateTime2Date(StrToDateTime(PChar(ApSrc)^));
    dtDateTimeStamp: PADSQLTimeStamp(ApDest)^ := ADDateTimeToSQLTimeStamp(StrToDateTime(PChar(ApSrc)^));
    dtGUID:    PGUID(ApDest)^ := StringToGUID(PChar(ApSrc)^); 
    else lConverted := False;
    end;
  end;

  procedure WideStr2Dest;
  var
    s: String;
    pPrevDest: Pointer;
  begin
    s := PWideChar(ApSrc);
    pPrevDest := ApDest;
    ApDest := PChar(s);
    try
      AnsiStr2Dest;
    finally
      ApDest := pPrevDest;
    end;
  end;

  procedure SetStrFromPBCD(ApValue: PADBcd);
  begin
    ADBCD2Str(buff, Integer(ADestSize), ApValue^, DecimalSeparator);
    if ADestSize >= ADestMaxSize then
      ADestSize := ADestMaxSize
    else
      Inc(ADestSize);
    ADMove(buff[0], ApDest, ADestSize);
  end;

  procedure SetWStrFromPBCD(ApValue: PADBcd);
  var
    iLen: Integer;
  begin
    iLen := 0;
    ADBCD2Str(buff, iLen, ApValue^, DecimalSeparator);
    ADestSize := MultiByteToWideChar(0, 0, buff, iLen, PWideChar(ApDest), ADestMaxSize);
    if ADestSize < ADestMaxSize then begin
      PWideChar(ApDest)[ADestSize] := #0;
      Inc(ADestSize);
    end;
  end;

  procedure Int64ToBCD(AValue: Int64);
  var
    s: String;
  begin
    s := IntToStr(AValue);
    ADStr2BCD(PChar(s), Length(s), PADBcd(ApDest)^, DecimalSeparator);
  end;

  procedure IntToBCD(AValue: Integer);
  var
    s: String;
  begin
    s := IntToStr(AValue);
    ADStr2BCD(PChar(s), Length(s), PADBcd(ApDest)^, DecimalSeparator);
  end;

  procedure DblToBcd(AValue: Double);
  var
    s: String;
  begin
    s := FloatToStr(AValue);
    ADStr2BCD(PChar(s), Length(s), PADBcd(ApDest)^, DecimalSeparator);
  end;

  procedure BcdToInt(ADestLen: Integer; ANoSign: Boolean);
  var
    iLen: Integer;
  begin
    iLen := 0;
    ADBCD2Str(buff, iLen, PADBcd(ApSrc)^, DecimalSeparator);
    ADStr2Int(buff, iLen, ApDest, ADestLen, ANoSign);
  end;

  procedure BcdToDbl;
  var
    iLen: Integer;
    s: String;
  begin
    iLen := 0;
    ADBCD2Str(buff, iLen, PADBcd(ApSrc)^, DecimalSeparator);
    SetString(s, buff, iLen);
    PDouble(ApDest)^ := StrToFloat(s);
  end;

  procedure BcdToCr;
  var
    c: Currency;
  begin
    c := 0.0;
    BCDToCurr(PADBcd(ApSrc)^, c);
    PCurrency(ApDest)^ := c;
  end;

  procedure SetStrFromSTS(ApValue: PADSQLTimeStamp; AKind: TADDataType);
  var
    sFmt, sVal: String;
  begin
    case AKind of
    dtDateTime,
    dtDateTimeStamp: sFmt := '';
    dtTime:          sFmt := ShortTimeFormat;
    dtDate:          sFmt := ShortDateFormat;
    end;
    sVal := '';
    DateTimeToString(sVal, sFmt, ADSQLTimeStampToDateTime(ApValue^));
    ValToStr(SF_S, [sVal]);
  end;

  procedure SetWStrFromSTS(ApValue: PADSQLTimeStamp; AKind: TADDataType);
  var
    sFmt, sVal: String;
  begin
    case AKind of
    dtDateTime,
    dtDateTimeStamp: sFmt := '';
    dtTime:          sFmt := ShortTimeFormat;
    dtDate:          sFmt := ShortDateFormat;
    end;
    sVal := '';
    DateTimeToString(sVal, sFmt, ADSQLTimeStampToDateTime(ApValue^));
    ValToWStr(SWF_S, [sVal]);
  end;

  procedure AnsiStr2WideChar;
  var
    s: String;
  begin
    s := PChar(ApSrc);
    StringToWideChar(s, PWideChar(ApDest), ADestSize);
  end;

  procedure WideStr2AnsiChar;
  var
    s: String;
  begin
    s := WideCharToString(PWideChar(ApSrc));
    StrLCopy(PChar(ApDest), PChar(s), ADestSize);
  end;

begin
  if ASrcType = ADestType then begin
    ADestSize := ASrcSize;
    if ApSrc <> nil then
      ApDest := ApSrc;
    Exit;
  end;
  CheckConversion(ASrcType, ADestType);
  ADestSize := GetStorageSize();
  lConverted := True;
  case ASrcType of
  dtBoolean:
    if ADestType = dtAnsiString then begin
      if (ApSrc <> nil) and (ApDest <> nil) then begin
        if PWordBool(ApSrc)^ then
          PChar(ApDest)[0] := 'T'
        else
          PChar(ApDest)[0] := 'F';
        PChar(ApDest)[1] := #0;
      end;
      ADestSize := 1;
    end
    else if ADestType = dtWideString then begin
      if (ApSrc <> nil) and (ApDest <> nil) then begin
        if PWordBool(ApSrc)^ then
          PWideChar(ApDest)[0] := 'T'
        else
          PWideChar(ApDest)[0] := 'F';
        PWideChar(ApDest)[1] := #0;
      end;
      ADestSize := 1;
    end
    else if (ApSrc <> nil) and (ApDest <> nil) then
      case ADestType of
      dtSByte:      PShortInt(ApDest)^ := ShortInt(PWordBool(ApSrc)^);
      dtInt16:      PSmallInt(ApDest)^ := SmallInt(PWordBool(ApSrc)^);
      dtInt32:      PInteger(ApDest)^ := Integer(PWordBool(ApSrc)^);
      dtInt64:      PInt64(ApDest)^ := Int64(PWordBool(ApSrc)^);
      dtByte:       PByte(ApDest)^ := Byte(PWordBool(ApSrc)^);
      dtUInt16:     PWord(ApDest)^ := Word(PWordBool(ApSrc)^);
      dtUInt32:     PLongWord(ApDest)^ := LongWord(PWordBool(ApSrc)^);
      dtUInt64:     PUInt64(ApDest)^ := UInt64(PWordBool(ApSrc)^);
      dtBCD,
      dtFmtBCD:     IntToBCD(Integer(PWordBool(ApSrc)^));
      else lConverted := False;
      end;
  dtSByte:
    if ADestType = dtAnsiString then
      if ApSrc <> nil then
        ValToStr(SF_D, [PShortInt(ApSrc)^])
      else
        ADestSize := 5
    else if ADestType = dtWideString then
      if ApSrc <> nil then
        ValToWStr(SWF_D, [PShortInt(ApSrc)^])
      else
        ADestSize := 5
    else if (ApSrc <> nil) and (ApDest <> nil) then
      case ADestType of
      dtBoolean:    PWordBool(ApDest)^ := WordBool(PShortInt(ApSrc)^);
      dtInt16:      PSmallInt(ApDest)^ := PShortInt(ApSrc)^;
      dtInt32:      PInteger(ApDest)^ := PShortInt(ApSrc)^;
      dtInt64:      PInt64(ApDest)^ := PShortInt(ApSrc)^;
      dtByte:       PByte(ApDest)^ := PShortInt(ApSrc)^;
      dtUInt16:     PWord(ApDest)^ := PShortInt(ApSrc)^;
      dtUInt32:     PLongWord(ApDest)^ := PShortInt(ApSrc)^;
      dtUInt64:     PUInt64(ApDest)^ := PShortInt(ApSrc)^;
      dtDouble:     PDouble(ApDest)^ := PShortInt(ApSrc)^;
      dtCurrency:   PCurrency(ApDest)^ := PShortInt(ApSrc)^;
      dtBCD,
      dtFmtBCD:     IntToBCD(PShortInt(ApSrc)^);
      else lConverted := False;
      end;
  dtInt16:
    if ADestType = dtAnsiString then
      if ApSrc <> nil then
        ValToStr(SF_D, [PSmallInt(ApSrc)^])
      else
        ADestSize := 7
    else if ADestType = dtWideString then
      if ApSrc <> nil then
        ValToWStr(SWF_D, [PSmallInt(ApSrc)^])
      else
        ADestSize := 7
    else if (ApSrc <> nil) and (ApDest <> nil) then
      case ADestType of
      dtBoolean:  PWordBool(ApDest)^ := WordBool(PSmallInt(ApSrc)^);
      dtSByte:    PShortInt(ApDest)^ := ShortInt(PSmallInt(ApSrc)^);
      dtInt32:    PInteger(ApDest)^ := PSmallInt(ApSrc)^;
      dtInt64:    PInt64(ApDest)^ := PSmallInt(ApSrc)^;
      dtByte:     PByte(ApDest)^ := Byte(PSmallInt(ApSrc)^);
      dtUInt16:   PWord(ApDest)^ := PSmallInt(ApSrc)^;
      dtUInt32:   PLongWord(ApDest)^ := PSmallInt(ApSrc)^;
      dtUInt64:   PUInt64(ApDest)^ := PSmallInt(ApSrc)^;
      dtDouble:   PDouble(ApDest)^ := PSmallInt(ApSrc)^;
      dtCurrency: PCurrency(ApDest)^ := PSmallInt(ApSrc)^;
      dtBCD,
      dtFmtBCD:   IntToBCD(PSmallInt(ApSrc)^);
      else lConverted := False;
      end;
  dtInt32:
    if ADestType = dtAnsiString then
      if ApSrc <> nil then
        ValToStr(SF_D, [PInteger(ApSrc)^])
      else
        ADestSize := 12
    else if ADestType = dtWideString then
      if ApSrc <> nil then
        ValToWStr(SWF_D, [PInteger(ApSrc)^])
      else
        ADestSize := 12
    else if (ApSrc <> nil) and (ApDest <> nil) then
      case ADestType of
      dtBoolean:  PWordBool(ApDest)^ := WordBool(PInteger(ApSrc)^);
      dtSByte:    PShortInt(ApDest)^ := ShortInt(PInteger(ApSrc)^);
      dtInt16:    PSmallInt(ApDest)^ := SmallInt(PInteger(ApSrc)^);
      dtInt64:    PInt64(ApDest)^ := PInteger(ApSrc)^;
      dtByte:     PByte(ApDest)^ := Byte(PInteger(ApSrc)^);
      dtUInt16:   PWord(ApDest)^ := Word(PInteger(ApSrc)^);
      dtUInt32:   PLongWord(ApDest)^ := PInteger(ApSrc)^;
      dtUInt64:   PUInt64(ApDest)^ := PInteger(ApSrc)^;
      dtDouble:   PDouble(ApDest)^ := PInteger(ApSrc)^;
      dtCurrency: PCurrency(ApDest)^ := PInteger(ApSrc)^;
      dtBCD,
      dtFmtBCD:   IntToBCD(PInteger(ApSrc)^);
      else lConverted := False;
      end;
  dtInt64:
    if ADestType = dtAnsiString then
      if ApSrc <> nil then
        ValToStr(SF_D, [PInt64(ApSrc)^])
      else
        ADestSize := 22
    else if ADestType = dtWideString then
      if ApSrc <> nil then
        ValToWStr(SWF_D, [PInt64(ApSrc)^])
      else
        ADestSize := 22
    else if (ApSrc <> nil) and (ApDest <> nil) then
      case ADestType of
      dtBoolean:  PWordBool(ApDest)^ := WordBool(PInt64(ApSrc)^);
      dtSByte:    PShortInt(ApDest)^ := ShortInt(PInt64(ApSrc)^);
      dtInt16:    PSmallInt(ApDest)^ := SmallInt(PInt64(ApSrc)^);
      dtInt32:    PInteger(ApDest)^ := Integer(PInt64(ApSrc)^);
      dtByte:     PByte(ApDest)^ := Byte(PInt64(ApSrc)^);
      dtUInt16:   PWord(ApDest)^ := Word(PInt64(ApSrc)^);
      dtUInt32:   PLongWord(ApDest)^ := LongWord(PInt64(ApSrc)^);
      dtUInt64:   PUInt64(ApDest)^ := PInt64(ApSrc)^;
      dtDouble:   PDouble(ApDest)^ := PInt64(ApSrc)^;
      dtCurrency: PCurrency(ApDest)^ := PInt64(ApSrc)^;
      dtBCD,
      dtFmtBCD:   Int64ToBCD(PInt64(ApSrc)^);
      else lConverted := False;
      end;
  dtByte:
    if ADestType = dtAnsiString then
      if ApSrc <> nil then
        ValToStr(SF_U, [PByte(ApSrc)^])
      else
        ADestSize := 4
    else if ADestType = dtWideString then
      if ApSrc <> nil then
        ValToWStr(SWF_U, [PByte(ApSrc)^])
      else
        ADestSize := 4
    else if (ApSrc <> nil) and (ApDest <> nil) then
      case ADestType of
      dtBoolean:  PWordBool(ApDest)^ := WordBool(PByte(ApSrc)^);
      dtSByte:    PShortInt(ApDest)^ := PByte(ApSrc)^;
      dtInt16:    PSmallInt(ApDest)^ := PByte(ApSrc)^;
      dtInt32:    PInteger(ApDest)^ := PByte(ApSrc)^;
      dtInt64:    PInt64(ApDest)^ := PByte(ApSrc)^;
      dtUInt16:   PWord(ApDest)^ := PByte(ApSrc)^;
      dtUInt32:   PLongWord(ApDest)^ := PByte(ApSrc)^;
      dtUInt64:   PUInt64(ApDest)^ := PByte(ApSrc)^;
      dtDouble:   PDouble(ApDest)^ := PByte(ApSrc)^;
      dtCurrency: PCurrency(ApDest)^ := PByte(ApSrc)^;
      dtBCD,
      dtFmtBCD:   IntToBCD(PByte(ApSrc)^);
      else lConverted := False;
      end;
  dtUInt16:
    if ADestType = dtAnsiString then
      if ApSrc <> nil then
        ValToStr(SF_U, [PWord(ApSrc)^])
      else
        ADestSize := 6
    else if ADestType = dtWideString then
      if ApSrc <> nil then
        ValToWStr(SWF_U, [PWord(ApSrc)^])
      else
        ADestSize := 6
    else if (ApSrc <> nil) and (ApDest <> nil) then
      case ADestType of
      dtBoolean:  PWordBool(ApDest)^ := WordBool(PWord(ApSrc)^);
      dtSByte:    PShortInt(ApDest)^ := ShortInt(PWord(ApSrc)^);
      dtInt16:    PSmallInt(ApDest)^ := PWord(ApSrc)^;
      dtInt32:    PInteger(ApDest)^ := PWord(ApSrc)^;
      dtInt64:    PInt64(ApDest)^ := PWord(ApSrc)^;
      dtByte:     PByte(ApDest)^ := Byte(PWord(ApSrc)^);
      dtUInt32:   PLongWord(ApDest)^ := PWord(ApSrc)^;
      dtUInt64:   PUInt64(ApDest)^ := PWord(ApSrc)^;
      dtDouble:   PDouble(ApDest)^ := PWord(ApSrc)^;
      dtCurrency: PCurrency(ApDest)^ := PWord(ApSrc)^;
      dtBCD,
      dtFmtBCD:   IntToBCD(PWord(ApSrc)^);
      else lConverted := False;
      end;
  dtUInt32:
    if ADestType = dtAnsiString then
      if ApSrc <> nil then
        ValToStr(SF_U, [PLongWord(ApSrc)^])
      else
        ADestSize := 11
    else if ADestType = dtWideString then
      if ApSrc <> nil then
        ValToWStr(SWF_U, [PLongWord(ApSrc)^])
      else
        ADestSize := 11
    else if (ApSrc <> nil) and (ApDest <> nil) then
      case ADestType of
      dtBoolean:  PWordBool(ApDest)^ := WordBool(PLongWord(ApSrc)^);
      dtSByte:    PShortInt(ApDest)^ := ShortInt(PLongWord(ApSrc)^);
      dtInt16:    PSmallInt(ApDest)^ := SmallInt(PLongWord(ApSrc)^);
      dtInt32:    PInteger(ApDest)^ := PLongWord(ApSrc)^;
      dtInt64:    PInt64(ApDest)^ := PLongWord(ApSrc)^;
      dtByte:     PByte(ApDest)^ := Byte(PLongWord(ApSrc)^);
      dtUInt16:   PWord(ApDest)^ := Word(PLongWord(ApSrc)^);
      dtUInt64:   PUInt64(ApDest)^ := PLongWord(ApSrc)^;
      dtDouble:   PDouble(ApDest)^ := PLongWord(ApSrc)^;
      dtCurrency: PCurrency(ApDest)^ := PLongWord(ApSrc)^;
      dtBCD,
      dtFmtBCD:   Int64ToBCD(PLongWord(ApSrc)^);
      else lConverted := False;
      end;
  dtUInt64:
    if ADestType = dtAnsiString then
      if ApSrc <> nil then
        ValToStr(SF_D, [PUInt64(ApSrc)^])
      else
        ADestSize := 22
    else if ADestType = dtWideString then
      if ApSrc <> nil then
        ValToWStr(SWF_D, [PUInt64(ApSrc)^])
      else
        ADestSize := 22
    else if (ApSrc <> nil) and (ApDest <> nil) then
      case ADestType of
      dtBoolean:  PWordBool(ApDest)^ := WordBool(PUInt64(ApSrc)^);
      dtSByte:    PShortInt(ApDest)^ := ShortInt(PUInt64(ApSrc)^);
      dtInt16:    PSmallInt(ApDest)^ := SmallInt(PUInt64(ApSrc)^);
      dtInt32:    PInteger(ApDest)^ := Integer(PUInt64(ApSrc)^);
      dtInt64:    PInt64(ApDest)^ := PUInt64(ApSrc)^;
      dtByte:     PByte(ApDest)^ := Byte(PUInt64(ApSrc)^);
      dtUInt16:   PWord(ApDest)^ := Word(PUInt64(ApSrc)^);
      dtUInt32:   PLongWord(ApDest)^ := LongWord(PUInt64(ApSrc)^);
      dtDouble:   PDouble(ApDest)^ := PUInt64(ApSrc)^;
      dtCurrency: PCurrency(ApDest)^ := PUInt64(ApSrc)^;
      dtBCD,
      dtFmtBCD:   Int64ToBCD(PUInt64(ApSrc)^);
      else lConverted := False;
      end;
  dtDouble:
    if ADestType = dtAnsiString then
      if ApSrc <> nil then
        ValToStr(SF_F, [PDouble(ApSrc)^])
      else
        ADestSize := 19
    else if ADestType = dtWideString then
      if ApSrc <> nil then
        ValToWStr(SWF_F, [PDouble(ApSrc)^])
      else
        ADestSize := 19
    else if (ApSrc <> nil) and (ApDest <> nil) then
      case ADestType of
      dtSByte:    PShortInt(ApDest)^ := ShortInt(Trunc(PDouble(ApSrc)^));
      dtInt16:    PSmallInt(ApDest)^ := SmallInt(Trunc(PDouble(ApSrc)^));
      dtInt32:    PInteger(ApDest)^ := Integer(Trunc(PDouble(ApSrc)^));
      dtInt64:    PInt64(ApDest)^ := Trunc(PDouble(ApSrc)^);
      dtByte:     PByte(ApDest)^ := Byte(Trunc(PDouble(ApSrc)^));
      dtUInt16:   PWord(ApDest)^ := Word(Trunc(PDouble(ApSrc)^));
      dtUInt32:   PLongWord(ApDest)^ := LongWord(Trunc(PDouble(ApSrc)^));
      dtUInt64:   PUInt64(ApDest)^ := Trunc(PDouble(ApSrc)^);
      dtCurrency: PCurrency(ApDest)^ := PDouble(ApSrc)^;
      dtBCD,
      dtFmtBCD:   DblToBcd(PDouble(ApSrc)^);
      else lConverted := False;
      end;
  dtCurrency:
    if ADestType = dtAnsiString then
      if ApSrc <> nil then
        ValToStr(SF_F, [PCurrency(ApSrc)^])
      else
        ADestSize := 22
    else if ADestType = dtWideString then
      if ApSrc <> nil then
        ValToWStr(SWF_F, [PCurrency(ApSrc)^])
      else
        ADestSize := 22
    else if (ApSrc <> nil) and (ApDest <> nil) then
      case ADestType of
      dtSByte:    PShortInt(ApDest)^ := ShortInt(Trunc(PCurrency(ApSrc)^));
      dtInt16:    PSmallInt(ApDest)^ := SmallInt(Trunc(PCurrency(ApSrc)^));
      dtInt32:    PInteger(ApDest)^ := Integer(Trunc(PCurrency(ApSrc)^));
      dtInt64:    PInt64(ApDest)^ := Trunc(PCurrency(ApSrc)^);
      dtByte:     PByte(ApDest)^ := Byte(Trunc(PCurrency(ApSrc)^));
      dtUInt16:   PWord(ApDest)^ := Word(Trunc(PCurrency(ApSrc)^));
      dtUInt32:   PLongWord(ApDest)^ := LongWord(Trunc(PCurrency(ApSrc)^));
      dtUInt64:   PUInt64(ApDest)^ := Trunc(PCurrency(ApSrc)^);
      dtDouble:   PDouble(ApDest)^ := PCurrency(ApSrc)^;
      dtBCD,
      dtFmtBCD:   CurrToBCD(PCurrency(ApSrc)^, PADBcd(ApDest)^, 20);
      else lConverted := False;
      end;
  dtBCD,
  dtFmtBCD:
    if ADestType = dtAnsiString then
      if ApSrc <> nil then
        SetStrFromPBCD(PADBcd(ApSrc))
      else
        ADestSize := 67
    else if ADestType = dtWideString then
      if ApSrc <> nil then
        SetWStrFromPBCD(PADBcd(ApSrc))
      else
        ADestSize := 67
    else if (ApSrc <> nil) and (ApDest <> nil) then
      case ADestType of
      dtBoolean:  BcdToInt(SizeOf(WordBool), True);
      dtSByte:    BcdToInt(SizeOf(ShortInt), False);
      dtInt16:    BcdToInt(SizeOf(SmallInt), False);
      dtInt32:    BcdToInt(SizeOf(Integer), False);
      dtInt64:    BcdToInt(SizeOf(Int64), False);
      dtByte:     BcdToInt(SizeOf(Byte), True);
      dtUInt16:   BcdToInt(SizeOf(Word), True);
      dtUInt32:   BcdToInt(SizeOf(LongWord), True);
      dtUInt64:   BcdToInt(SizeOf(UInt64), True);
      dtDouble:   BcdToDbl;
      dtCurrency: BcdToCr;
      dtFmtBCD,
      dtBCD:      ApDest := ApSrc;
      else lConverted := False;
      end;
  dtDateTime:
    begin
      if ApSrc <> nil then
        rSTS := ADDateTimeToSQLTimeStamp(TimeStampToDateTime(MSecsToTimeStamp(PADDateTimeData(ApSrc)^.DateTime)));
      if ADestType = dtAnsiString then
        if ApSrc <> nil then
          SetStrFromSTS(@rSTS, dtDateTime)
        else
          ADestSize := C_AD_MaxLenTimeStampStr
      else if ADestType = dtWideString then
        if ApSrc <> nil then
          SetWStrFromSTS(@rSTS, dtDateTime)
        else
          ADestSize := C_AD_MaxLenTimeStampStr
      else if (ApSrc <> nil) and (ApDest <> nil) then
        case ADestType of
        dtTime:          PLongword(ApDest)^ := ADSQLTimeStamp2Time(rSTS);
        dtDate:          PLongword(ApDest)^ := ADSQLTimeStamp2Date(rSTS);
        dtDateTimeStamp: PADSQLTimeStamp(ApDest)^ := rSTS;
        else lConverted := False;
        end;
    end;
  dtDateTimeStamp:
    if ADestType = dtAnsiString then
      if ApSrc <> nil then
        SetStrFromSTS(PADSQLTimeStamp(ApSrc), dtDateTimeStamp)
      else
        ADestSize := C_AD_MaxLenTimeStampStr
    else if ADestType = dtWideString then
      if ApSrc <> nil then
        SetWStrFromSTS(PADSQLTimeStamp(ApSrc), dtDateTimeStamp)
      else
        ADestSize := C_AD_MaxLenTimeStampStr
    else if (ApSrc <> nil) and (ApDest <> nil) then
      case ADestType of
      dtTime:     PLongword(ApDest)^ := ADSQLTimeStamp2Time(PADSQLTimeStamp(ApSrc)^);
      dtDate:     PLongword(ApDest)^ := ADSQLTimeStamp2Date(PADSQLTimeStamp(ApSrc)^);
      dtDateTime: PADDateTimeData(ApDest)^.DateTime := TimeStampToMSecs(DateTimeToTimeStamp(ADSQLTimeStampToDateTime(PADSQLTimeStamp(ApSrc)^)));
      else lConverted := False;
      end;
  dtTime:
    if ADestType = dtAnsiString then
      if ApSrc <> nil then begin
        rSTS := ADTime2SQLTimeStamp(PLongword(ApSrc)^);
        SetStrFromSTS(@rSTS, dtTime);
      end
      else
        ADestSize := C_AD_MaxLenTimeStampStr
    else if ADestType = dtWideString then
      if ApSrc <> nil then begin
        rSTS := ADTime2SQLTimeStamp(PLongword(ApSrc)^);
        SetWStrFromSTS(@rSTS, dtTime);
      end
      else
        ADestSize := C_AD_MaxLenTimeStampStr
    else if (ApSrc <> nil) and (ApDest <> nil) then
      case ADestType of
      dtDateTime:      PADDateTimeData(ApDest)^.DateTime := TimeStampToMSecs(DateTimeToTimeStamp(ADSQLTimeStampToDateTime(ADTime2SQLTimeStamp(PLongword(ApSrc)^))));
      dtDateTimeStamp: PADSQLTimeStamp(ApDest)^ := ADTime2SQLTimeStamp(PLongword(ApSrc)^)
      else lConverted := False;
      end;
  dtDate:
    if ADestType = dtAnsiString then
      if ApSrc <> nil then begin
        rSTS := ADDate2SQLTimeStamp(PLongword(ApSrc)^);
        SetStrFromSTS(@rSTS, dtDate);
      end
      else
        ADestSize := C_AD_MaxLenTimeStampStr
    else if ADestType = dtWideString then
      if ApSrc <> nil then begin
        rSTS := ADDate2SQLTimeStamp(PLongword(ApSrc)^);
        SetWStrFromSTS(@rSTS, dtDate);
      end
      else
        ADestSize := C_AD_MaxLenTimeStampStr
    else if (ApSrc <> nil) and (ApDest <> nil) then
      case ADestType of
      dtDateTime:      PADDateTimeData(ApDest)^.DateTime := TimeStampToMSecs(DateTimeToTimeStamp(ADSQLTimeStampToDateTime(ADDate2SQLTimeStamp(PLongword(ApSrc)^))));
      dtDateTimeStamp: PADSQLTimeStamp(ApDest)^ := ADDate2SQLTimeStamp(PLongword(ApSrc)^)
      else lConverted := False;
      end;
  dtAnsiString:
    if ADestType in [dtWideString, dtWideMemo, dtWideHMemo] then begin
      ADestSize := ASrcSize;
      if ADestSize > ADestMaxSize div SizeOf(WideChar) then
        ADestSize := ADestMaxSize div SizeOf(WideChar);
      if ApSrc <> nil then
        AnsiStr2WideChar;
    end
    else if ADestType in [dtByteString, dtBlob, dtMemo, dtHBlob, dtHBFile, dtHMemo] then begin
      ADestSize := ASrcSize;
      if ADestSize > ADestMaxSize then
        ADestSize := ADestMaxSize;
      if ApSrc <> nil then
        ApDest := ApSrc;
    end
    else if (ApSrc <> nil) and (ApDest <> nil) then
      AnsiStr2Dest;
  dtWideString:
    if ADestType in [dtAnsiString, dtMemo, dtHMemo] then begin
      ADestSize := ASrcSize;
      if ADestSize > ADestMaxSize then
        ADestSize := ADestMaxSize;
      if ApSrc <> nil then
        WideStr2AnsiChar;
    end
    else if ADestType in [dtWideMemo, dtWideHMemo] then begin
      ADestSize := ASrcSize;
      if ADestSize > ADestMaxSize then
        ADestSize := ADestMaxSize;
      if ApSrc <> nil then
        ApDest := ApSrc;
    end
    else if ADestType in [dtByteString, dtBlob, dtHBlob, dtHBFile] then begin
      ADestSize := ASrcSize * SizeOf(WideChar);
      if ADestSize > ADestMaxSize then
        ADestSize := ADestMaxSize;
      if ApSrc <> nil then
        ApDest := ApSrc;
    end
    else if (ApSrc <> nil) and (ApDest <> nil) then
      WideStr2Dest;
  dtByteString:
    case ADestType of
    dtAnsiString,
    dtBlob,
    dtMemo,
    dtHBlob,
    dtHBFile,
    dtHMemo:
      begin
        ADestSize := ASrcSize;
        if ADestSize > ADestMaxSize then
          ADestSize := ADestMaxSize;
        if ApSrc <> nil then
          ApDest := ApSrc;
      end;
    dtWideString,
    dtWideMemo,
    dtWideHMemo:
      begin
        ADestSize := ASrcSize div SizeOf(WideChar);
        if ADestSize > ADestMaxSize div SizeOf(WideChar) then
          ADestSize := ADestMaxSize div SizeOf(WideChar);
        if ApSrc <> nil then
          ApDest := ApSrc;
      end;
    else lConverted := False;
    end;
  dtBlob,
  dtHBlob,
  dtHBFile:
    if ADestType in [dtBlob, dtMemo, dtHBlob, dtHBFile, dtHMemo] then begin
      ADestSize := ASrcSize;
      if ADestSize > ADestMaxSize then
        ADestSize := ADestMaxSize;
      if ApSrc <> nil then
        ApDest := ApSrc;
    end
    else if ADestType in [dtWideMemo, dtWideHMemo] then begin
      ADestSize := ASrcSize div SizeOf(WideChar);
      if ADestSize > ADestMaxSize div SizeOf(WideChar) then
        ADestSize := ADestMaxSize div SizeOf(WideChar);
      if ApSrc <> nil then
        ApDest := ApSrc;
    end
    else lConverted := False;
  dtMemo,
  dtHMemo:
    if ADestType in [dtBlob, dtMemo, dtHBlob, dtHBFile, dtHMemo] then begin
      ADestSize := ASrcSize;
      if ADestSize > ADestMaxSize then
        ADestSize := ADestMaxSize;
      if ApSrc <> nil then
        ApDest := ApSrc;
    end
    else if ADestType in [dtWideMemo, dtWideHMemo] then begin
      ADestSize := ASrcSize;
      if ADestSize > ADestMaxSize div SizeOf(WideChar) then
        ADestSize := ADestMaxSize div SizeOf(WideChar);
      if ApSrc <> nil then
        AnsiStr2WideChar;
    end
    else lConverted := False;
  dtWideMemo,
  dtWideHMemo:
    if ADestType in [dtAnsiString, dtMemo, dtHMemo] then begin
      ADestSize := ASrcSize;
      if ADestSize > ADestMaxSize then
        ADestSize := ADestMaxSize;
      if ApSrc <> nil then
        WideStr2AnsiChar;
    end
    else if ADestType in [dtWideMemo, dtWideHMemo] then begin
      ADestSize := ASrcSize;
      if ADestSize > ADestMaxSize then
        ADestSize := ADestMaxSize;
      if ApSrc <> nil then
        ApDest := ApSrc;
    end
    else if ADestType in [dtByteString, dtBlob, dtHBlob, dtHBFile] then begin
      ADestSize := ASrcSize * SizeOf(WideChar);
      if ADestSize > ADestMaxSize then
        ADestSize := ADestMaxSize;
      if ApSrc <> nil then
        ApDest := ApSrc;
    end
    else lConverted := False;
  dtGUID:
    if ADestType = dtAnsiString then
      if ApSrc <> nil then
        ValToStr(SF_S, [GUIDToString(PGUID(ApSrc)^)])
      else
        ADestSize := C_AD_GUIDStrLen
    else if ADestType = dtWideString then
      if ApSrc <> nil then
        ValToWStr(SWF_S, [GUIDToString(PGUID(ApSrc)^)])
      else
        ADestSize := C_AD_GUIDStrLen
  else
    lConverted := False;
  end;
  ASSERT(lConverted);
end;

{-------------------------------------------------------------------------------}
{ TADFormatConversionBuffer                                                     }
{-------------------------------------------------------------------------------}
constructor TADFormatConversionBuffer.Create;
begin
  inherited Create;
  Release;
end;

{-------------------------------------------------------------------------------}
destructor TADFormatConversionBuffer.Destroy;
begin
  Release;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADFormatConversionBuffer.Extend(ASrcDataLen: LongWord;
  var ADestDataLen: LongWord; ASrcType, ADestType: TADDataType);
var
  uiLen: LongWord;
begin
  ADestDataLen := ASrcDataLen;
  if ADestDataLen < ASrcDataLen then
    uiLen := ASrcDataLen
  else
    uiLen := ADestDataLen;
  if (ASrcType in C_AD_WideTypes) or (ADestType in C_AD_WideTypes) then
    uiLen := uiLen * SizeOf(WideChar);
  Check(uiLen);
end;

{-------------------------------------------------------------------------------}
procedure TADFormatConversionBuffer.Check(ALen: LongWord = 0);
var
  lAlloc: Boolean;
begin
  Inc(ALen, SizeOf(Word));
  if FBufferSize < ALen then begin
    FBufferSize := ALen;
    lAlloc := True;
  end
  else
    lAlloc := (FBuffer = nil);
  if lAlloc then
    ReallocMem(FBuffer, FBufferSize);
end;

{-------------------------------------------------------------------------------}
procedure TADFormatConversionBuffer.Release;
begin
  if FBuffer <> nil then begin
    FreeMem(FBuffer, FBufferSize);
    FBuffer := nil;
  end;
  FBufferSize := C_AD_MaxFixedSize;
end;

{-------------------------------------------------------------------------------}
{- TADFetchOptions                                                             -}
{-------------------------------------------------------------------------------}
procedure TADFetchOptions.Assign(ASource: TPersistent);
begin
  if (ASource = nil) or (ASource = Self) then
    Exit;
  if ASource is TADFetchOptions then begin
    if evMode in TADFetchOptions(ASource).FAssignedValues then
      Mode := TADFetchOptions(ASource).Mode;
    if evItems in TADFetchOptions(ASource).FAssignedValues then
      Items := TADFetchOptions(ASource).Items;
    if evRecsMax in TADFetchOptions(ASource).FAssignedValues then
      RecsMax := TADFetchOptions(ASource).RecsMax;
    if evRowsetSize in TADFetchOptions(ASource).FAssignedValues then
      RowsetSize := TADFetchOptions(ASource).RowsetSize;
    if evCache in TADFetchOptions(ASource).FAssignedValues then
      Cache := TADFetchOptions(ASource).Cache;
    if evAutoClose in TADFetchOptions(ASource).FAssignedValues then
      AutoClose := TADFetchOptions(ASource).AutoClose;
    if evRecordCountMode in TADFetchOptions(ASource).FAssignedValues then
      RecordCountMode := TADFetchOptions(ASource).RecordCountMode;
  end
  else
    inherited Assign(ASource);
end;

{-------------------------------------------------------------------------------}
procedure TADFetchOptions.RestoreDefaults;
begin
  FAssignedValues := [];
  FMode := fmOnDemand;
  FRecsMax := -1;
  FRowsetSize := IDefRowSetSize;
  FItems := [fiBlobs, fiDetails, fiMeta];
  FCache := [fiBlobs, fiDetails, fiMeta];
  FAutoClose := True;
  FRecordCountMode := cmVisible;
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.IsValueOwned(AValue: TADFetchOptionValue;
  out AParentOpts: IADStanOptions): Boolean;
begin
  Result := (FOwner = nil) or (AValue in FAssignedValues);
  if not Result then begin
    FOwner.GetParentOptions(AParentOpts);
    Result := (AParentOpts = nil);
  end
  else
    AParentOpts := nil;
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.GetParentFetchOptions(const AParentOpts: IADStanOptions): TADFetchOptions;
begin
  if (FOwner <> nil) and (AParentOpts <> nil) then
    Result := AParentOpts.FetchOptions
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.GetRecsMax: Integer;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(evRecsMax, oParentOpts) then
    Result := FRecsMax
  else
    Result := GetParentFetchOptions(oParentOpts).RecsMax;
end;

{-------------------------------------------------------------------------------}
procedure TADFetchOptions.SetRecsMax(const Value: Integer);
begin
  if not (evRecsMax in FAssignedValues) or (FRecsMax <> Value) then begin
    Changing;
    FRecsMax := Value;
    Include(FAssignedValues, evRecsMax);
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.IsRMS: Boolean;
begin
  Result := evRecsMax in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.GetRowsetSize: Integer;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(evRowsetSize, oParentOpts) then
    Result := FRowsetSize
  else
    Result := GetParentFetchOptions(oParentOpts).RowsetSize;
end;

{-------------------------------------------------------------------------------}
procedure TADFetchOptions.SetRowsetSize(const Value: Integer);
begin
  if not (evRowsetSize in FAssignedValues) or (FRowsetSize <> Value) then begin
    Changing;
    FRowsetSize := Value;
    Include(FAssignedValues, evRowsetSize);
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.GetActualRowsetSize: Integer;
begin
  if Mode = fmExactRecsMax then
    Result := RecsMax
  else
    Result := -1;
  if Result < 0 then
    Result := RowsetSize;
  if Result <= 0 then
    Result := 1;
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.IsRSS: Boolean;
begin
  Result := evRowsetSize in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.GetItems: TADFetchItems;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(evItems, oParentOpts) then
    Result := FItems
  else
    Result := GetParentFetchOptions(oParentOpts).Items;
end;

{-------------------------------------------------------------------------------}
procedure TADFetchOptions.SetItems(const Value: TADFetchItems);
begin
  if not (evItems in FAssignedValues) or (FItems <> Value) then begin
    Changing;
    FItems := Value;
    Include(FAssignedValues, evItems);
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.IsIS: Boolean;
begin
  Result := evItems in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.GetMode: TADFetchMode;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(evMode, oParentOpts) then
    Result := FMode
  else
    Result := GetParentFetchOptions(oParentOpts).Mode;
end;

{-------------------------------------------------------------------------------}
procedure TADFetchOptions.SetMode(const Value: TADFetchMode);
begin
  if not (evMode in FAssignedValues) or (FMode <> Value) then
  begin
    Changing;
    FMode := Value;
    Include(FAssignedValues, evMode);
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.IsMS: Boolean;
begin
  Result := evMode in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.GetCache: TADFetchItems;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(evCache, oParentOpts) then
    Result := FCache
  else
    Result := GetParentFetchOptions(oParentOpts).Cache;
end;

{-------------------------------------------------------------------------------}
procedure TADFetchOptions.SetCache(const Value: TADFetchItems);
begin
  if not (evCache in FAssignedValues) or (FCache <> Value) then begin
    Changing;
    FCache := Value;
    Include(FAssignedValues, evCache);
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.IsCS: Boolean;
begin
  Result := evCache in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.GetAutoClose: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(evAutoClose, oParentOpts) then
    Result := FAutoClose
  else
    Result := GetParentFetchOptions(oParentOpts).AutoClose;
end;

{-------------------------------------------------------------------------------}
procedure TADFetchOptions.SetAutoClose(const Value: Boolean);
begin
  if not (evAutoClose in FAssignedValues) or (FAutoClose <> Value) then begin
    Changing;
    FAutoClose := Value;
    Include(FAssignedValues, evAutoClose);
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.IsACS: Boolean;
begin
  Result := evAutoClose in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.GetRecordcountMode: TADRecordCountMode;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(evRecordcountMode, oParentOpts) then
    Result := FRecordcountMode
  else
    Result := GetParentFetchOptions(oParentOpts).RecordcountMode;
end;

{-------------------------------------------------------------------------------}
procedure TADFetchOptions.SetRecordCountMode(const Value: TADRecordCountMode);
begin
  if not (evRecordCountMode in FAssignedValues) or (FRecordCountMode <> Value) then begin
    Changing;
    FRecordCountMode := Value;
    Include(FAssignedValues, evRecordCountMode);
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.IsRCMS: Boolean;
begin
  Result := evRecordCountMode in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
{- TADUpdateOptions                                                            -}
{-------------------------------------------------------------------------------}
procedure TADUpdateOptions.RestoreDefaults;
begin
  FAssignedValues := [];
  FEnableDelete := True;
  FEnableInsert := True;
  FEnableUpdate := True;
  FUpdateChangedFields := True;
  FUpdateMode := upWhereKeyOnly;
  FLockMode := lmRely;
  FLockPoint := lpDeferred;
  FLockWait := False;
  FRefreshMode := rmOnDemand;
  FCountUpdatedRecords := True;
  FCacheUpdateCommands := True;
  FUseProviderFlags := True;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateOptions.Assign(ASource: TPersistent);
begin
  if (ASource = nil) or (ASource = Self) then
    Exit;
  if ASource is TADUpdateOptions then begin
    if uvEDelete in TADUpdateOptions(ASource).FAssignedValues then
      EnableDelete := TADUpdateOptions(ASource).EnableDelete;
    if uvEInsert in TADUpdateOptions(ASource).FAssignedValues then
      EnableInsert := TADUpdateOptions(ASource).EnableInsert;
    if uvEUpdate in TADUpdateOptions(ASource).FAssignedValues then
      EnableUpdate := TADUpdateOptions(ASource).EnableUpdate;
    if uvUpdateChngFields in TADUpdateOptions(ASource).FAssignedValues then
      UpdateChangedFields := TADUpdateOptions(ASource).UpdateChangedFields;
    if uvUpdateMode in TADUpdateOptions(ASource).FAssignedValues then
      UpdateMode := TADUpdateOptions(ASource).UpdateMode;
    if uvLockMode in TADUpdateOptions(ASource).FAssignedValues then
      LockMode := TADUpdateOptions(ASource).LockMode;
    if uvLockPoint in TADUpdateOptions(ASource).FAssignedValues then
      LockPoint := TADUpdateOptions(ASource).LockPoint;
    if uvLockWait in TADUpdateOptions(ASource).FAssignedValues then
      LockWait := TADUpdateOptions(ASource).LockWait;
    if uvRefreshMode in TADUpdateOptions(ASource).FAssignedValues then
      RefreshMode := TADUpdateOptions(ASource).RefreshMode;
    if uvCountUpdatedRecords in TADUpdateOptions(ASource).FAssignedValues then
      CountUpdatedRecords := TADUpdateOptions(ASource).CountUpdatedRecords;
    if uvCacheUpdateCommands in TADUpdateOptions(ASource).FAssignedValues then
      CacheUpdateCommands := TADUpdateOptions(ASource).CacheUpdateCommands;
    if uvUseProviderFlags in TADUpdateOptions(ASource).FAssignedValues then
      UseProviderFlags := TADUpdateOptions(ASource).UseProviderFlags;
  end
  else
    inherited Assign(ASource);
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.IsValueOwned(AValue: TADUpdateOptionValue;
  out AParentOpts: IADStanOptions): Boolean;
begin
  Result := (FOwner = nil) or (AValue in FAssignedValues);
  if not Result then begin
    FOwner.GetParentOptions(AParentOpts);
    Result := (AParentOpts = nil);
  end
  else
    AParentOpts := nil;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.GetParentUpdateOptions(const AParentOpts: IADStanOptions): TADUpdateOptions;
begin
  if (FOwner <> nil) and (AParentOpts <> nil) then
    Result := AParentOpts.UpdateOptions
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.GetEnableDelete: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(uvEDelete, oParentOpts) then
    Result := FEnableDelete
  else
    Result := GetParentUpdateOptions(oParentOpts).EnableDelete;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateOptions.SetEnableDelete(AValue: Boolean);
begin
  if not (uvEDelete in FAssignedValues) or (FEnableDelete <> AValue) then begin
    Changing;
    FEnableDelete := AValue;
    Include(FAssignedValues, uvEDelete);
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.IsEDS: Boolean;
begin
  Result := uvEDelete in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.GetEnableInsert: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(uvEInsert, oParentOpts) then
    Result := FEnableInsert
  else
    Result := GetParentUpdateOptions(oParentOpts).EnableInsert;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateOptions.SetEnableInsert(AValue: Boolean);
begin
  if not (uvEInsert in FAssignedValues) or (FEnableInsert <> AValue) then begin
    Changing;
    FEnableInsert := AValue;
    Include(FAssignedValues, uvEInsert);
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.IsEIS: Boolean;
begin
  Result := uvEInsert in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.GetEnableUpdate: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(uvEUpdate, oParentOpts) then
    Result := FEnableUpdate
  else
    Result := GetParentUpdateOptions(oParentOpts).EnableUpdate;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateOptions.SetEnableUpdate(AValue: Boolean);
begin
  if not (uvEUpdate in FAssignedValues) or (FEnableUpdate <> AValue) then begin
    Changing;
    FEnableUpdate := AValue;
    Include(FAssignedValues, uvEUpdate);
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.IsEUS: Boolean;
begin
  Result := uvEUpdate in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.GetReadOnly: Boolean;
begin
  Result := not EnableDelete and not EnableInsert and not EnableUpdate;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateOptions.SetReadOnly(const AValue: Boolean);
begin
  EnableDelete := not AValue;
  EnableInsert := not AValue;
  EnableUpdate := not AValue;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.GetUpdateChangedFields: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(uvUpdateChngFields, oParentOpts) then
    Result := FUpdateChangedFields
  else
    Result := GetParentUpdateOptions(oParentOpts).UpdateChangedFields;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateOptions.SetUpdateChangedFields(const AValue: Boolean);
begin
  if not (uvUpdateChngFields in FAssignedValues) or (FUpdateChangedFields <> AValue) then begin
    Changing;
    FUpdateChangedFields := AValue;
    Include(FAssignedValues, uvUpdateChngFields);
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.IsUCFS: Boolean;
begin
  Result := uvUpdateChngFields in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.GetUpdateMode: TUpdateMode;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(uvUpdateMode, oParentOpts) then
    Result := FUpdateMode
  else
    Result := GetParentUpdateOptions(oParentOpts).UpdateMode;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateOptions.SetUpdateMode(const AValue: TUpdateMode);
begin
  if not (uvUpdateMode in FAssignedValues) or (FUpdateMode <> AValue) then begin
    Changing;
    FUpdateMode := AValue;
    Include(FAssignedValues, uvUpdateMode);
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.IsUMS: Boolean;
begin
  Result := uvUpdateMode in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.GetLockMode: TADLockMode;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(uvLockMode, oParentOpts) then
    Result := FLockMode
  else
    Result := GetParentUpdateOptions(oParentOpts).LockMode;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateOptions.SetLockMode(const AValue: TADLockMode);
begin
  if not (uvLockMode in FAssignedValues) or (FLockMode <> AValue) then begin
    Changing;
    FLockMode := AValue;
    Include(FAssignedValues, uvLockMode);
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.IsLMS: Boolean;
begin
  Result := uvLockMode in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.GetLockPoint: TADLockPoint;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(uvLockPoint, oParentOpts) then
    Result := FLockPoint
  else
    Result := GetParentUpdateOptions(oParentOpts).LockPoint;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateOptions.SetLockPoint(const AValue: TADLockPoint);
begin
  if not (uvLockPoint in FAssignedValues) or (FLockPoint <> AValue) then begin
    Changing;
    FLockPoint := AValue;
    Include(FAssignedValues, uvLockPoint);
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.IsLPS: Boolean;
begin
  Result := uvLockPoint in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.GetLockWait: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(uvLockWait, oParentOpts) then
    Result := FLockWait
  else
    Result := GetParentUpdateOptions(oParentOpts).LockWait;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateOptions.SetLockWait(const AValue: Boolean);
begin
  if not (uvLockWait in FAssignedValues) or (FLockWait <> AValue) then begin
    Changing;
    FLockWait := AValue;
    Include(FAssignedValues, uvLockWait);
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.IsLWS: Boolean;
begin
  Result := uvLockWait in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.GetRefreshMode: TADRefreshMode;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(uvRefreshMode, oParentOpts) then
    Result := FRefreshMode
  else
    Result := GetParentUpdateOptions(oParentOpts).RefreshMode;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateOptions.SetRefreshMode(const AValue: TADRefreshMode);
begin
  if not (uvRefreshMode in FAssignedValues) or (FRefreshMode <> AValue) then begin
    Changing;
    FRefreshMode := AValue;
    Include(FAssignedValues, uvRefreshMode);
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.IsRMS: Boolean;
begin
  Result := uvRefreshMode in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.GetCountUpdatedRecords: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(uvCountUpdatedRecords, oParentOpts) then
    Result := FCountUpdatedRecords
  else
    Result := GetParentUpdateOptions(oParentOpts).CountUpdatedRecords;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateOptions.SetCountUpdatedRecords(const AValue: Boolean);
begin
  if not (uvCountUpdatedRecords in FAssignedValues) or (FCountUpdatedRecords <> AValue) then begin
    Changing;
    FCountUpdatedRecords := AValue;
    Include(FAssignedValues, uvCountUpdatedRecords);
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.IsCURS: Boolean;
begin
  Result := uvCountUpdatedRecords in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.GetCacheUpdateCommands: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(uvCacheUpdateCommands, oParentOpts) then
    Result := FCacheUpdateCommands
  else
    Result := GetParentUpdateOptions(oParentOpts).CacheUpdateCommands;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateOptions.SetCacheUpdateCommands(const AValue: Boolean);
begin
  if not (uvCacheUpdateCommands in FAssignedValues) or (FCacheUpdateCommands <> AValue) then begin
    Changing;
    FCacheUpdateCommands := AValue;
    Include(FAssignedValues, uvCacheUpdateCommands);
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.IsCUAS: Boolean;
begin
  Result := uvCacheUpdateCommands in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.GetUseProviderFlags: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(uvUseProviderFlags, oParentOpts) then
    Result := FUseProviderFlags
  else
    Result := GetParentUpdateOptions(oParentOpts).UseProviderFlags;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateOptions.SetUseProviderFlags(const AValue: Boolean);
begin
  if not (uvUseProviderFlags in FAssignedValues) or (FUseProviderFlags <> AValue) then begin
    Changing;
    FUseProviderFlags := AValue;
    Include(FAssignedValues, uvUseProviderFlags);
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.IsUPFS: Boolean;
begin
  Result := uvUseProviderFlags in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.GetFastUpdates: Boolean;
begin
  Result := not UpdateChangedFields and (UpdateMode = upWhereKeyOnly) and
    (LockMode = lmRely) and (RefreshMode = rmManual) and CacheUpdateCommands;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateOptions.SetFastUpdates(const AValue: Boolean);
begin
  if AValue then begin
    UpdateChangedFields := False;
    UpdateMode := upWhereKeyOnly;
    LockMode := lmRely;
    RefreshMode := rmManual;
    CacheUpdateCommands := True;
  end
  else begin
    FUpdateChangedFields := True;
    FUpdateMode := upWhereKeyOnly;
    FLockMode := lmRely;
    FRefreshMode := rmOnDemand;
    FCacheUpdateCommands := True;
    FAssignedValues := FAssignedValues - [uvUpdateChngFields, uvUpdateMode,
      uvLockMode, uvRefreshMode, uvCacheUpdateCommands];
  end;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.GetRequestLive: Boolean;
begin
  Result := (Owner <> nil) and (fiMeta in Owner.FetchOptions.Items) and not ReadOnly;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateOptions.SetRequestLive(const AValue: Boolean);
begin
  if RequestLive <> AValue then
    if AValue then begin
      if Owner <> nil then
        Owner.FetchOptions.Items := Owner.FetchOptions.Items + [fiMeta];
      ReadOnly := False;
      UseProviderFlags := False;
    end
    else begin
      if Owner <> nil then
        Owner.FetchOptions.Items := Owner.FetchOptions.Items - [fiMeta];
      ReadOnly := True;
      UseProviderFlags := True;
    end;
end;

{-------------------------------------------------------------------------------}
{ TADBottomUpdateOptions                                                        }
{-------------------------------------------------------------------------------}
procedure TADBottomUpdateOptions.Assign(ASource: TPersistent);
begin
  inherited Assign(ASource);
  if ASource is TADBottomUpdateOptions then
    UpdateTableName := TADBottomUpdateOptions(ASource).UpdateTableName
end;

{-------------------------------------------------------------------------------}
procedure TADBottomUpdateOptions.RestoreDefaults;
begin
  inherited RestoreDefaults;
  FUpdateTableName := '';
end;

{-------------------------------------------------------------------------------}
procedure TADBottomUpdateOptions.SetUpdateTableName(const Value: String);
begin
  FUpdateTableName := Value;
end;

{-------------------------------------------------------------------------------}
{ TADResourceOptions                                                            }
{-------------------------------------------------------------------------------}
procedure TADResourceOptions.RestoreDefaults;
begin
  FAssignedValues := [];
  FParamCreate := True;
  FMacroCreate := True;
  FParamExpand := True;
  FMacroExpand := True;
  FEscapeExpand := True;
  FDisconnectable := True;
  FAsyncCmdMode := amBlocking;
  FAsyncCmdTimeout := $FFFFFFFF;
  FDirectExecute := False;
  FDefaultParamType := ptInput;
end;

{-------------------------------------------------------------------------------}
procedure TADResourceOptions.Assign(ASource: TPersistent);
begin
  if (ASource = nil) or (ASource = Self) then
    Exit;
  if ASource is TADResourceOptions then begin
    if rvParamCreate in TADResourceOptions(ASource).FAssignedValues then
      ParamCreate := TADResourceOptions(ASource).ParamCreate;
    if rvMacroCreate in TADResourceOptions(ASource).FAssignedValues then
      MacroCreate := TADResourceOptions(ASource).MacroCreate;
    if rvParamExpand in TADResourceOptions(ASource).FAssignedValues then
      ParamExpand := TADResourceOptions(ASource).ParamExpand;
    if rvMacroExpand in TADResourceOptions(ASource).FAssignedValues then
      MacroExpand := TADResourceOptions(ASource).MacroExpand;
    if rvEscapeExpand in TADResourceOptions(ASource).FAssignedValues then
      EscapeExpand := TADResourceOptions(ASource).EscapeExpand;
    if rvDisconnectable in TADResourceOptions(ASource).FAssignedValues then
      Disconnectable := TADResourceOptions(ASource).Disconnectable;
    if rvAsyncCmdMode in TADResourceOptions(ASource).FAssignedValues then
      AsyncCmdMode := TADResourceOptions(ASource).AsyncCmdMode;
    if rvAsyncCmdTimeout in TADResourceOptions(ASource).FAssignedValues then
      AsyncCmdTimeout := TADResourceOptions(ASource).AsyncCmdTimeout;
    if rvDirectExecute in TADResourceOptions(ASource).FAssignedValues then
      DirectExecute := TADResourceOptions(ASource).DirectExecute;
    if rvDefaultParamType in TADResourceOptions(ASource).FAssignedValues then
      DefaultParamType := TADResourceOptions(ASource).DefaultParamType;
  end
  else
    inherited Assign(ASource);
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.IsValueOwned(AValue: TADResourceOptionValue;
  out AParentOpts: IADStanOptions): Boolean;
begin
  Result := (FOwner = nil) or (AValue in FAssignedValues);
  if not Result then begin
    FOwner.GetParentOptions(AParentOpts);
    Result := (AParentOpts = nil);
  end
  else
    AParentOpts := nil;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.GetParentResourceOptions(const AParentOpts: IADStanOptions): TADResourceOptions;
begin
  if (FOwner <> nil) and (AParentOpts <> nil) then
    Result := AParentOpts.ResourceOptions
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.GetMacroCreate: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(rvMacroCreate, oParentOpts) then
    Result := FMacroCreate
  else
    Result := GetParentResourceOptions(oParentOpts).MacroCreate;
end;

{-------------------------------------------------------------------------------}
procedure TADResourceOptions.SetMacroCreate(const AValue: Boolean);
begin
  if not (rvMacroCreate in FAssignedValues) or (FMacroCreate <> AValue) then begin
    Changing;
    FMacroCreate := AValue;
    Include(FAssignedValues, rvMacroCreate);
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.IsMCS: Boolean;
begin
  Result := rvMacroCreate in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.GetParamCreate: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(rvParamCreate, oParentOpts) then
    Result := FParamCreate
  else
    Result := GetParentResourceOptions(oParentOpts).ParamCreate;
end;

{-------------------------------------------------------------------------------}
procedure TADResourceOptions.SetParamCreate(const AValue: Boolean);
begin
  if not (rvParamCreate in FAssignedValues) or (FParamCreate <> AValue) then begin
    Changing;
    FParamCreate := AValue;
    Include(FAssignedValues, rvParamCreate);
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.IsPCS: Boolean;
begin
  Result := rvParamCreate in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.GetParamExpand: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(rvParamExpand, oParentOpts) then
    Result := FParamExpand
  else
    Result := GetParentResourceOptions(oParentOpts).ParamExpand;
end;

{-------------------------------------------------------------------------------}
procedure TADResourceOptions.SetParamExpand(const AValue: Boolean);
begin
  if not (rvParamExpand in FAssignedValues) or (FParamExpand <> AValue) then begin
    Changing;
    FParamExpand := AValue;
    Include(FAssignedValues, rvParamExpand);
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.IsPES: Boolean;
begin
  Result := rvParamExpand in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.GetMacroExpand: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(rvMacroExpand, oParentOpts) then
    Result := FMacroExpand
  else
    Result := GetParentResourceOptions(oParentOpts).MacroExpand;
end;

{-------------------------------------------------------------------------------}
procedure TADResourceOptions.SetMacroExpand(const AValue: Boolean);
begin
  if not (rvMacroExpand in FAssignedValues) or (FMacroExpand <> AValue) then begin
    Changing;
    FMacroExpand := AValue;
    Include(FAssignedValues, rvMacroExpand);
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.IsMES: Boolean;
begin
  Result := rvMacroExpand in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.GetEscapeExpand: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(rvEscapeExpand, oParentOpts) then
    Result := FEscapeExpand
  else
    Result := GetParentResourceOptions(oParentOpts).EscapeExpand;
end;

{-------------------------------------------------------------------------------}
procedure TADResourceOptions.SetEscapeExpand(const AValue: Boolean);
begin
  if not (rvEscapeExpand in FAssignedValues) or (FEscapeExpand <> AValue) then begin
    Changing;
    FEscapeExpand := AValue;
    Include(FAssignedValues, rvEscapeExpand);
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.IsEPS: Boolean;
begin
  Result := rvEscapeExpand in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.GetDisconnectable: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(rvDisconnectable, oParentOpts) then
    Result := FDisconnectable
  else
    Result := GetParentResourceOptions(oParentOpts).Disconnectable;
end;

{-------------------------------------------------------------------------------}
procedure TADResourceOptions.SetDisconnectable(const AValue: Boolean);
begin
  if not (rvDisconnectable in FAssignedValues) or (FDisconnectable <> AValue) then begin
    Changing;
    FDisconnectable := AValue;
    Include(FAssignedValues, rvDisconnectable);
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.IsDS: Boolean;
begin
  Result := rvDisconnectable in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.GetAsyncCmdMode: TADStanAsyncMode;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(rvAsyncCmdMode, oParentOpts) then
    Result := FAsyncCmdMode
  else
    Result := GetParentResourceOptions(oParentOpts).AsyncCmdMode;
end;

{-------------------------------------------------------------------------------}
procedure TADResourceOptions.SetAsyncCmdMode(const AValue: TADStanAsyncMode);
begin
  if not (rvAsyncCmdMode in FAssignedValues) or (FAsyncCmdMode <> AValue) then begin
    Changing;
    FAsyncCmdMode := AValue;
    Include(FAssignedValues, rvAsyncCmdMode);
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.IsACOMS: Boolean;
begin
  Result := rvAsyncCmdMode in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.GetAsyncCmdTimeout: LongWord;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(rvAsyncCmdTimeout, oParentOpts) then
    Result := FAsyncCmdTimeout
  else
    Result := GetParentResourceOptions(oParentOpts).AsyncCmdTimeout;
end;

{-------------------------------------------------------------------------------}
procedure TADResourceOptions.SetAsyncCmdTimeout(const AValue: LongWord);
begin
  if not (rvAsyncCmdTimeout in FAssignedValues) or (FAsyncCmdTimeout <> AValue) then begin
    Changing;
    FAsyncCmdTimeout := AValue;
    Include(FAssignedValues, rvAsyncCmdTimeout);
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.IsACOTS: Boolean;
begin
  Result := rvAsyncCmdTimeout in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.GetDirectExecute: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(rvDirectExecute, oParentOpts) then
    Result := FDirectExecute
  else
    Result := GetParentResourceOptions(oParentOpts).DirectExecute;
end;

{-------------------------------------------------------------------------------}
procedure TADResourceOptions.SetDirectExecute(const AValue: Boolean);
begin
  if not (rvDirectExecute in FAssignedValues) or (FDirectExecute <> AValue) then begin
    Changing;
    FDirectExecute := AValue;
    Include(FAssignedValues, rvDirectExecute);
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.IsDES: Boolean;
begin
  Result := rvDirectExecute in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.GetDefaultParamType: TParamType;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(rvDefaultParamType, oParentOpts) then
    Result := FDefaultParamType
  else
    Result := GetParentResourceOptions(oParentOpts).DefaultParamType;
end;

{-------------------------------------------------------------------------------}
procedure TADResourceOptions.SetDefaultParamType(const AValue: TParamType);
begin
  if not (rvDefaultParamType in FAssignedValues) or (FDefaultParamType <> AValue) then begin
    Changing;
    FDefaultParamType := AValue;
    Include(FAssignedValues, rvDefaultParamType);
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.IsDPTS: Boolean;
begin
  Result := rvDefaultParamType in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
{ TADTopResourceOptions                                                         }
{-------------------------------------------------------------------------------}
procedure TADTopResourceOptions.RestoreDefaults;
begin
  inherited RestoreDefaults;
  FMaxCursors := -1;
  FServerOutput := False;
  FServerOutputSize := 20000;
end;

{-------------------------------------------------------------------------------}
procedure TADTopResourceOptions.Assign(ASource: TPersistent);
begin
  if (ASource = nil) or (ASource = Self) then
    Exit;
  inherited Assign(ASource);
  if ASource is TADTopResourceOptions then begin
    if rvMaxCursors in TADTopResourceOptions(ASource).FAssignedValues then
      MaxCursors := TADTopResourceOptions(ASource).MaxCursors;
    if rvServerOutput in TADTopResourceOptions(ASource).FAssignedValues then
      ServerOutput := TADTopResourceOptions(ASource).ServerOutput;
    if rvServerOutputSize in TADTopResourceOptions(ASource).FAssignedValues then
      ServerOutputSize := TADTopResourceOptions(ASource).ServerOutputSize;
  end;
end;

{-------------------------------------------------------------------------------}
function TADTopResourceOptions.GetMaxCursors: Integer;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(rvMaxCursors, oParentOpts) then
    Result := FMaxCursors
  else
    Result := (GetParentResourceOptions(oParentOpts) as TADTopResourceOptions).MaxCursors;
end;

{-------------------------------------------------------------------------------}
procedure TADTopResourceOptions.SetMaxCursors(const AValue: Integer);
begin
  if not (rvMaxCursors in FAssignedValues) or (FMaxCursors <> AValue) then begin
    Changing;
    FMaxCursors := AValue;
    Include(FAssignedValues, rvMaxCursors);
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
function TADTopResourceOptions.IsMCS: Boolean;
begin
  Result := rvMaxCursors in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADTopResourceOptions.GetServerOutput: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(rvServerOutput, oParentOpts) then
    Result := FServerOutput
  else
    Result := (GetParentResourceOptions(oParentOpts) as TADTopResourceOptions).ServerOutput;
end;

{-------------------------------------------------------------------------------}
procedure TADTopResourceOptions.SetServerOutput(const AValue: Boolean);
begin
  if not (rvServerOutput in FAssignedValues) or (FServerOutput <> AValue) then begin
    Changing;
    FServerOutput := AValue;
    Include(FAssignedValues, rvServerOutput);
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
function TADTopResourceOptions.IsSOS: Boolean;
begin
  Result := rvServerOutput in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADTopResourceOptions.GetServerOutputSize: Integer;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(rvServerOutputSize, oParentOpts) then
    Result := FServerOutputSize
  else
    Result := (GetParentResourceOptions(oParentOpts) as TADTopResourceOptions).ServerOutputSize;
end;

{-------------------------------------------------------------------------------}
procedure TADTopResourceOptions.SetServerOutputSize(const AValue: Integer);
begin
  if not (rvServerOutputSize in FAssignedValues) or (FServerOutputSize <> AValue) then begin
    Changing;
    FServerOutputSize := AValue;
    Include(FAssignedValues, rvServerOutputSize);
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
function TADTopResourceOptions.IsSOSS: Boolean;
begin
  Result := rvServerOutputSize in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
{ TADTxOptions                                                                  }
{-------------------------------------------------------------------------------}
constructor TADTxOptions.Create;
begin
  inherited Create;
  FDisconnectAction := xdRollback;
  FAutoCommit := True;
  FIsolation := xiReadCommitted;
  ClearChanged;
end;

{-------------------------------------------------------------------------------}
procedure TADTxOptions.ClearChanged;
begin
  FChanged := [];
end;

{-------------------------------------------------------------------------------}
procedure TADTxOptions.SetAutoCommit(const AValue: Boolean);
begin
  if FAutoCommit <> AValue then begin
    FAutoCommit := AValue;
    Include(FChanged, xoAutoCommit);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADTxOptions.SetIsolation(const AValue: TADTxIsolation);
begin
  if FIsolation <> AValue then begin
    FIsolation := AValue;
    Include(FChanged, xoIsolation);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADTxOptions.SetIsolationAsStr(const AValue: String);
begin
  if CompareText(AValue, S_AD_DirtyRead) = 0 then
    Isolation := xiDirtyRead
  else if CompareText(AValue, S_AD_ReadCommitted) = 0 then
    Isolation := xiReadCommitted
  else if CompareText(AValue, S_AD_RepeatRead) = 0 then
    Isolation := xiRepeatableRead
  else if CompareText(AValue, S_AD_Serializible) = 0 then
    Isolation := xiSerializible;
end;

{-------------------------------------------------------------------------------}
initialization

  C_AD_MaxLenTimeStampStr := Length(DateTimeToStr(ADSQLTimeStampToDateTime(RLongDate)));

end.
