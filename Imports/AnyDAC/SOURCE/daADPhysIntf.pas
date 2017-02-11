{-------------------------------------------------------------------------------}
{ AnyDAC physical layer API                                                     }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit daADPhysIntf;

interface

uses
  Classes, SysUtils,
  daADStanIntf, daADStanOption, daADStanParam, daADStanError,
  daADDatSManager,
  daADGUIxIntf;

type
  IADPhysManagerMetadata = interface;
  IADPhysManager = interface;
  IADPhysDriverMetadata = interface;
  IADPhysDriverConnectionWizard = interface;
  IADPhysDriver = interface;
  IADPhysConnectionMetadata = interface;
  IADPhysConnection = interface;
  IADPhysDescribeHandler = interface;
  IADPhysCommandGenerator = interface;
  IADPhysMappingHandler = interface;
  IADPhysCommand = interface;
  IADPhysMetaInfoCommand = interface;

  TADPhysCommandKind = (skUnknown, skSelect, skSelectForUpdate, skDelete,
    skInsert, skUpdate, skCreate, skAlter, skDrop, skStoredProc,
    skStoredProcWithCrs, skStoredProcNoCrs, skExecute, skOther);

  TADPhysEscapeKind = (eskFloat, eskDate, eskTime, eskDateTime, eskIdentifier,
    eskBoolean, eskFunction, eskIF, eskEscape);
  TADPhysEscapeFunction = (efASCII, efLTRIM, efREPLACE, efRTRIM, efSOUNDEX, efABS,
    efCOS, efEXP, efFLOOR, efMOD, efPOWER, efROUND, efSIGN, efSIN, efSQRT, efTAN,
    efDECODE, efBIT_LENGTH, efCHAR, efCHAR_LENGTH, efCONCAT, efDIFFERENCE, efINSERT,
    efLCASE, efLEFT, efLENGTH, efLOCATE, efOCTET_LENGTH, efPOSITION, efREPEAT, efRIGHT,
    efSPACE, efSUBSTRING, efUCASE, efACOS, efASIN, efATAN, efATAN2, efCOT, efCEILING,
    efDEGREES, efLOG, efLOG10, efPI, efRADIANS, efRANDOM, efTRUNCATE, efCURDATE,
    efCURTIME, efNOW, efDAYNAME, efDAYOFMONTH, efDAYOFWEEK, efDAYOFYEAR, efEXTRACT,
    efHOUR, efMINUTE, efMONTH, efMONTHNAME, efQUARTER, efSECOND, efTIMESTAMPADD,
    efTIMESTAMPDIFF, efWEEK, efYEAR, efCATALOG, efSCHEMA, efIFNULL, efIF, efCONVERT,
    efNONE);
  TADPhysEscapeData = record
    FKind: TADPhysEscapeKind;
    FFunc: TADPhysEscapeFunction;
    FName: String;
    FArgs: array of String;
  end;

  TADPhysNamePart = (npCatalog, npSchema, npDBLink, npBaseObject, npObject);
  TADPhysNameParts = set of TADPhysNamePart;
  TADPhysParsedName = record
    FCatalog,
    FSchema,
    FBaseObject,
    FObject,
    FLink: String;
  end;

  TADPhysDecodeOption = (doUnquote, doNormalize, doSubObj);
  TADPhysDecodeOptions = set of TADPhysDecodeOption;
  TADPhysEncodeOption = (eoQuote, eoNormalize, eoBeatify);
  TADPhysEncodeOptions = set of TADPhysEncodeOption;

  TADPhysParamMark = (prQMark, prName, prNumber);
  TADPhysDefaultValues = (dvNone, dvDefVals, dvDef);

  TADPhysConnectionState = (csDisconnecting, csDisconnected,
    csConnecting, csConnected);

  TADPhysRequest = (arNone,
    arFromRow, arSelect, arInsert, arUpdate, arDelete,
    arLock, arUnlock, arFetchRow, arUpdateHBlobs, arDeleteAll);
  TADPhysRequests = set of TADPhysRequest;
  TADPhysUpdateRequest = arInsert .. arDeleteAll;
  TADPhysUpdateRequests = set of TADPhysUpdateRequest;
  TADPhysUpdateRowOption = (uoCancelUnlock, uoImmediateUpd, uoDeferedLock,
    uoOneMomLock, uoNoSrvRecord, uoNoClntRecord);
  TADPhysUpdateRowOptions = set of TADPhysUpdateRowOption;

  TADPhysFillRowOption = (foBlobs, foDetails, foData,
    foAfterIns, foAfterUpd, foForCheck, foClear);
  TADPhysFillRowOptions = set of TADPhysFillRowOption;

  TADPhysCommandGeneratorOptions = set of (goForceQuoteTab, goForceNoQuoteTab,
    goForceQuoteCol, goForceNoQuoteCol, goClassicParamName, goBeautify);

  TADPhysMetaInfoKind = (
    mkNone,
    mkTables, mkTableFields,
    mkIndexes, mkIndexFields,
    mkPrimaryKey, mkPrimaryKeyFields,
    mkForeignKeys, mkForeignKeyFields,
    mkPackages, mkProcs, mkProcArgs);
  TADPhysObjectScope = (osMy, osOther, osSystem);
  TADPhysObjectScopes = set of TADPhysObjectScope;
  TADPhysTableKind = (tkSynonym, tkTable, tkView, tkTempTable, tkLocalTable);
  TADPhysTableKinds = set of TADPhysTableKind;
  TADPhysProcedureKind = (pkProcedure, pkFunction);
  TADPhysIndexKind = (ikNonUnique, ikUnique, ikPrimaryKey);
  TADPhysCascadeRuleKind = (ckNone, ckCascade, ckRestrict, ckSetNull, ckSetDefault);

  TADPhysManagerState = (dmsInactive, dmsActive, dmsStoping, dmsTerminating);
  TADPhysDriverState = (drsUnloaded, drsLoaded, drsRegistered,
    drsInitializing, drsActive, drsInactive, drsStoping, drsFinalizing);
  TADPhysCommandState = (csInactive, csPrepared, csExecuting, csOpen,
    csFetching, csAborting);
  TADPhysNameKind = (nkDefault, nkID, nkSource, nkDatS, nkObj);
  TADPhysMetaInfoMergeMode = (mmReset, mmOverride, mmRely);
  TADPhysMissingMetaInfoAction = (maAdd, maIgore, maError);

  IADPhysManagerMetadata = interface (IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2100}']
    // private
    function GetDriverCount: Integer;
    function GetDriverID(Index: Integer): String;
    // public
    procedure CreateDriverMetadata(const ADriverID: String; out ADrvMeta: IADPhysDriverMetadata);
    property DriverCount: Integer read GetDriverCount;
    property DriverID[Index: Integer]: String read GetDriverID;
  end;

  IADPhysManager = interface(IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2101}']
    // private
    function GetDriverDefs: IADStanDefinitions;
    function GetConnectionDefs: IADStanConnectionDefs;
    function GetOptions: IADStanOptions;
    function GetState: TADPhysManagerState;
    function GetDesignTime: Boolean;
    procedure SetDesignTime(AValue: Boolean);
    // public
    procedure CreateConnection(const AConDef: IADStanConnectionDef;
      out AConn: IADPhysConnection; AIntfRequired: Boolean = True); overload;
    procedure CreateConnection(const AConDefName: String;
      out AConn: IADPhysConnection; AIntfRequired: Boolean = True); overload;
    procedure CreateDriver(const ADriverID: String;
      out ADrv: IADPhysDriver; AIntfRequired: Boolean = True);
    procedure CreateMetadata(out AMeta: IADPhysManagerMetadata);
    procedure CreateDefaultConnectionMetadata(out AConn: IADPhysConnectionMetadata);
    procedure Open;
    procedure Close(AWait: Boolean = False);
    property DriverDefs: IADStanDefinitions read GetDriverDefs;
    property ConnectionDefs: IADStanConnectionDefs read GetConnectionDefs;
    property Options: IADStanOptions read GetOptions;
    property State: TADPhysManagerState read GetState;
    property DesignTime: Boolean read GetDesignTime write SetDesignTime;
  end;

  IADPhysDriverMetadata = interface (IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2102}']
    // private
    function GetDriverIntfID: String;
    function GetDescription: String;
    // public
    function GetConnParamCount(AKeys: TStrings): Integer;
    procedure GetConnParams(AKeys: TStrings; Index: Integer; var
      AName, AType, ADefVal, ACaption: String; var ALoginIndex: Integer);
    property DriverID: String read GetDriverIntfID;
    property Description: String read GetDescription;
  end;

  IADPhysDriverConnectionWizard = interface (IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2111}']
    function Run(AConnDef: IADStanConnectionDef): Boolean;
  end;

  IADPhysDriver = interface (IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2103}']
    // private
    function GetDriverIntfID: String;
    function GetRefCount: Integer;
    function GetConnectionCount: Integer;
    function GetConnections(AIndex: Integer): IADPhysConnection;
    function GetState: TADPhysDriverState;
    // public
    procedure ForceDisconnect;
    procedure CreateMetadata(out AMeta: IADPhysDriverMetadata);
    procedure CreateConnectionWizard(out AWizard: IADPhysDriverConnectionWizard);
    property DriverID: String read GetDriverIntfID;
    property State: TADPhysDriverState read GetState;
    property RefCount: Integer read GetRefCount;
    property ConnectionCount: Integer read GetConnectionCount;
    property Connections[AIndex: Integer]: IADPhysConnection read GetConnections;
  end;

  IADPhysConnectionMetadata = interface (IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2104}']
    // private
    function GetKind: TADRDBMSKind;
    function GetClientVersion: LongWord;
    function GetServerVersion: LongWord;
    function GetTxSupported: Boolean;
    function GetTxNested: Boolean;
    function GetTxSavepoints: Boolean;
    function GetTxAutoCommit: Boolean;
    function GetParamNameMaxLength: Integer;
    function GetNameParts: TADPhysNameParts;
    function GetNameQuotedCaseSensParts: TADPhysNameParts;
    function GetNameCaseSensParts: TADPhysNameParts;
    function GetNameDefLowCaseParts: TADPhysNameParts;
    function GetNameQuotaChar1: Char;
    function GetNameQuotaChar2: Char;
    function GetInsertBlobsAfterReturning: Boolean;
    function GetEnableIdentityInsert: Boolean;
    function GetParamMark: TADPhysParamMark;
    function GetTruncateSupported: Boolean;
    function GetDefValuesSupported: TADPhysDefaultValues;
    function GetInlineRefresh: Boolean;
    function GetSelectWithoutFrom: Boolean;
    function GetLockNoWait: Boolean;
    function GetAsyncAbortSupported: Boolean;
    function GetCommandSeparator: String;
    // public
    procedure DecodeObjName(const AName: String; var AParsedName: TADPhysParsedName;
      const ACommand: IADPhysCommand; AOpts: TADPhysDecodeOptions);
    function EncodeObjName(const AParsedName: TADPhysParsedName;
      const ACommand: IADPhysCommand; AOpts: TADPhysEncodeOptions): String;
    function TranslateEscapeSequence(var ASeq: TADPhysEscapeData): String;
    function GetSQLCommandKind(const AToken: String): TADPhysCommandKind;
    function DefineMetadataTableName(AKind: TADPhysMetaInfoKind): String;
    procedure DefineMetadataStructure(ATable: TADDatSTable; AKind: TADPhysMetaInfoKind);
    // object lists
    function GetTables(AScope: TADPhysObjectScopes; AKinds: TADPhysTableKinds;
      const ACatalog, ASchema, AWildCard: String): TADDatSView;
    function GetTableFields(const ACatalog, ASchema, ATable, AWildCard: String): TADDatSView;
    function GetTableIndexes(const ACatalog, ASchema, ATable, AWildCard: String): TADDatSView;
    function GetTableIndexFields(const ACatalog, ASchema, ATable, AIndex, AWildCard: String): TADDatSView;
    function GetTablePrimaryKey(const ACatalog, ASchema, ATable: String): TADDatSView;
    function GetTablePrimaryKeyFields(const ACatalog, ASchema, ATable, AWildCard: String): TADDatSView;
    function GetPackages(AScope: TADPhysObjectScopes; const ACatalog, ASchema, AWildCard: String): TADDatSView;
    function GetPackageProcs(const ACatalog, ASchema, APackage, AWildCard: String): TADDatSView;
    function GetProcs(AScope: TADPhysObjectScopes; const ACatalog, ASchema, AWildCard: String): TADDatSView;
    function GetProcArgs(const ACatalog, ASchema, APackage, AProc, AWildCard: String;
      AOverload: Word): TADDatSView;
    // props
    property Kind: TADRDBMSKind read GetKind;
    property ClientVersion: LongWord read GetClientVersion;
    property ServerVersion: LongWord read GetServerVersion;
    property TxSupported: Boolean read GetTxSupported;
    property TxNested: Boolean read GetTxNested;
    property TxSavepoints: Boolean read GetTxSavepoints;
    property TxAutoCommit: Boolean read GetTxAutoCommit;
    property ParamNameMaxLength: Integer read GetParamNameMaxLength;
    property NameParts: TADPhysNameParts read GetNameParts;
    property NameQuotedCaseSensParts: TADPhysNameParts read GetNameQuotedCaseSensParts;
    property NameCaseSensParts: TADPhysNameParts read GetNameCaseSensParts;
    property NameDefLowCaseParts: TADPhysNameParts read GetNameDefLowCaseParts;
    property NameQuotaChar1: Char read GetNameQuotaChar1;
    property NameQuotaChar2: Char read GetNameQuotaChar2;
    property InsertBlobsAfterReturning: Boolean read GetInsertBlobsAfterReturning;
    property EnableIdentityInsert: Boolean read GetEnableIdentityInsert;
    property ParamMark: TADPhysParamMark read GetParamMark;
    property TruncateSupported: Boolean read GetTruncateSupported;
    property DefValuesSupported: TADPhysDefaultValues read GetDefValuesSupported;
    property InlineRefresh: Boolean read GetInlineRefresh;
    property SelectWithoutFrom: Boolean read GetSelectWithoutFrom;
    property LockNoWait: Boolean read GetLockNoWait;
    property AsyncAbortSupported: Boolean read GetAsyncAbortSupported;
    property CommandSeparator: String read GetCommandSeparator;
  end;

  IADPhysConnection = interface (IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2105}']
    // private
    function GetRefCount: Integer;
    function GetDriver: IADPhysDriver;
    function GetState: TADPhysConnectionState;
    function GetOptions: IADStanOptions;
    function GetTxOptions: TADTxOptions;
    function GetTxIsActive: Boolean;
    function GetTxSerialID: LongWord;
    function GetCommandCount: Integer;
    function GetCommands(AIndex: Integer): IADPhysCommand;
    function GetErrorHandler: IADStanErrorHandler;
    function GetLogin: IADGUIxLoginDialog;
    function GetConnectionDef: IADStanConnectionDef;
    function GetLoginPrompt: Boolean;
    function GetMessages: EADDBEngineException;
    function GetCliObj: TObject;
    procedure SetOptions(const AValue: IADStanOptions);
    procedure SetTxOptions(const AValue: TADTxOptions);
    procedure SetErrorHandler(const AValue: IADStanErrorHandler);
    procedure SetLogin(const AValue: IADGUIxLoginDialog);
    procedure SetLoginPrompt(const AValue: Boolean);
{$IFDEF AnyDAC_MONITOR}
    function GetMonitor: IADMoniClient;
    function GetTracing: Boolean;
    procedure SetTracing(AValue: Boolean);
{$ENDIF}
    // public
    procedure CreateMetadata(out AConnMeta: IADPhysConnectionMetadata);
    procedure CreateCommandGenerator(out AGen: IADPhysCommandGenerator;
      const ACommand: IADPhysCommand = nil);
    procedure CreateCommand(out ACmd: IADPhysCommand);
    procedure CreateMetaInfoCommand(out AMetaCmd: IADPhysMetaInfoCommand);
    procedure ForceDisconnect;
    procedure Open;
    procedure Close;
    function TxBegin: LongWord;
    procedure TxCommit;
    procedure TxRollback;
    procedure ChangePassword(const ANewPassword: String);
    function GetLastAutoGenValue(const AName: String): Variant;
    // R/O
    property RefCount: Integer read GetRefCount;
    property Driver: IADPhysDriver read GetDriver;
    property State: TADPhysConnectionState read GetState;
    property TxIsActive: Boolean read GetTxIsActive;
    property TxSerialID: LongWord read GetTxSerialID;
    property ConnectionDef: IADStanConnectionDef read GetConnectionDef;
    property CommandCount: Integer read GetCommandCount;
    property Commands[AIndex: Integer]: IADPhysCommand read GetCommands;
    property Messages: EADDBEngineException read GetMessages;
    property CliObj: TObject read GetCliObj;
    // R/W
    property Options: IADStanOptions read GetOptions write SetOptions;
    property TxOptions: TADTxOptions read GetTxOptions write SetTxOptions;
    property ErrorHandler: IADStanErrorHandler read GetErrorHandler write SetErrorHandler;
    property Login: IADGUIxLoginDialog read GetLogin write SetLogin;
    property LoginPrompt: Boolean read GetLoginPrompt write SetLoginPrompt;
{$IFDEF AnyDAC_MONITOR}
    property Tracing: Boolean read GetTracing write SetTracing;
    property Monitor: IADMoniClient read GetMonitor;
{$ENDIF}
  end;

  TADPhysMappingResult = (mrDefault, mrMapped, mrNotMapped);
  IADPhysMappingHandler = interface (IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2108}']
    function MapRecordSet(ATable: Pointer; ATabNameKind: TADPhysNameKind;
      var ASourceID: Integer; var ASourceName, ADatSName, AUpdateName: String;
      var ADatSTable: TADDatSTable): TADPhysMappingResult;
    function MapRecordSetColumn(ATable: Pointer; ATabNameKind: TADPhysNameKind;
      AColumn: Pointer; AColNameKind: TADPhysNameKind; var ASourceID: Integer;
      var ASourceName, ADatSName, AUpdateName: String;
      var ADatSColumn: TADDatSColumn): TADPhysMappingResult;
  end;

  IADPhysDescribeHandler = interface(IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2106}']
    procedure DescribeColumn(AColumn: TADDatSColumn; var AAttributes: TADDataAttributes;
      var AOptions: TADDataOptions; var AUpdateName: String);
    procedure DescribeTable(ATable: TADDatSTable; var AUpdateName: String);
  end;

  IADPhysCommandGenerator = interface (IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2107}']
    // private
    function GetFillRowOptions: TADPhysFillRowOptions;
    function GetGenOptions: TADPhysCommandGeneratorOptions;
    function GetHasHBlobs: Boolean;
    function GetParams: TADParams;
    function GetRow: TADDatSRow;
    function GetTable: TADDatSTable;
    function GetUpdateRowOptions: TADPhysUpdateRowOptions;
    procedure SetParams(const AValue: TADParams);
    procedure SetRow(const AValue: TADDatSRow);
    procedure SetTable(const AValue: TADDatSTable);
    procedure SetUpdateRowOptions(const AValue: TADPhysUpdateRowOptions);
    function GetCol: TADDatSColumn;
    procedure SetCol(const AValue: TADDatSColumn);
    procedure SetFillRowOptions(const AValue: TADPhysFillRowOptions);
    procedure SetGenOptions(const AValue: TADPhysCommandGeneratorOptions);
    function GetCommandKind: TADPhysCommandKind;
    function GetOptions: IADStanOptions;
    procedure SetOptions(const AValue: IADStanOptions);
    function GetDescribeHandler: IADPhysDescribeHandler;
    procedure SetDescribeHandler(const AValue: IADPhysDescribeHandler);
    function GetMappingHandler: IADPhysMappingHandler;
    procedure SetMappingHandler(const AValue: IADPhysMappingHandler);
    // public
    function GenerateDelete: String;
    function GenerateDeleteAll(ANoUndo: Boolean): String;
    function GenerateInsert: String;
    function GenerateLock: String;
    function GenerateSavepoint(const AName: String): String;
    function GenerateRollbackToSavepoint(const AName: String): String;
    function GenerateCommitSavepoint(const AName: String): String;
    function GenerateSelect: String;
    function GenerateUnLock: String;
    function GenerateUpdate: String;
    function GenerateUpdateHBlobs: String;
    function GenerateGetLastAutoGenValue(const AName: String): String;
    function GenerateCall(const AName: String): String;
    // R/O
    property CommandKind: TADPhysCommandKind read GetCommandKind;
    property HasHBlobs: Boolean read GetHasHBlobs;
    // R/W
    property Column: TADDatSColumn read GetCol write SetCol;
    property FillRowOptions: TADPhysFillRowOptions read GetFillRowOptions
      write SetFillRowOptions;
    property GenOptions: TADPhysCommandGeneratorOptions read GetGenOptions
      write SetGenOptions;
    property Options: IADStanOptions read GetOptions write SetOptions;
    property Params: TADParams read GetParams write SetParams;
    property Row: TADDatSRow read GetRow write SetRow;
    property Table: TADDatSTable read GetTable write SetTable;
    property UpdateRowOptions: TADPhysUpdateRowOptions read GetUpdateRowOptions
      write SetUpdateRowOptions;
    property DescribeHandler: IADPhysDescribeHandler read GetDescribeHandler
      write SetDescribeHandler;
    property MappingHandler: IADPhysMappingHandler read GetMappingHandler
      write SetMappingHandler;
  end;

  EADPhysArrayExecuteError = class(EADException)
  private
    FTimes: LongInt;
    FOffset: LongInt;
    FAction: TADErrorAction;
    FException: Exception;
  public
    constructor Create(ATimes, AOffset: LongInt; AException: Exception); overload;
    property Times: LongInt read FTimes;
    property Offset: LongInt read FOffset;
    property Exception: Exception read FException;
    property Action: TADErrorAction read FAction write FAction;
  end;

  IADPhysCommand = interface (IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2109}']
    // private
    function GetSchemaName: String;
    function GetCatalogName: String;
    function GetBaseObjectName: String;
    function GetConnection: IADPhysConnection;
    function GetOptions: IADStanOptions;
    function GetState: TADPhysCommandState;
    function GetCommandText: String;
    function GetCommandKind: TADPhysCommandKind;
    function GetParams: TADParams;
    function GetMacros: TADMacros;
    function GetParamBindMode: TADParamBindMode;
    function GetOverload: Word;
    function GetNextRecordSet: Boolean;
    function GetErrorHandler: IADStanErrorHandler;
    function GetSourceObjectName: String;
    function GetSourceRecordSetName: String;
    function GetAsyncHandler: IADStanAsyncHandler;
    function GetRowsAffected: Integer;
    function GetRowsAffectedReal: Boolean;
    function GetErrorAction: TADErrorAction;
    function GetMappingHandler: IADPhysMappingHandler;
    function GetSQLOrderByPos: Integer;
    function GetCliObj: TObject;
    procedure SetSchemaName(const AValue: String);
    procedure SetCatalogName(const AValue: String);
    procedure SetBaseObjectName(const AValue: String);
    procedure SetOptions(const AValue: IADStanOptions);
    procedure SetCommandText(const AValue: String);
    procedure SetCommandKind(const AValue: TADPhysCommandKind);
    procedure SetSourceObjectName(const AValues: String);
    procedure SetSourceRecordSetName(const AValues: String);
    procedure SetNextRecordSet(const AValue: Boolean);
    procedure SetErrorHandler(const AValue: IADStanErrorHandler);
    procedure SetParamBindMode(const AValue: TADParamBindMode);
    procedure SetOverload(const AValue: Word);
    procedure SetAsyncHandler(const AValue: IADStanAsyncHandler);
    procedure SetMappingHandler(const AValue: IADPhysMappingHandler);
    // public
    procedure AbortJob(const AWait: Boolean = False);
    procedure Close;
    procedure CloseAll;
    procedure CheckAsyncProgress;
    procedure Disconnect;
    function Define(ADatSManager: TADDatSManager; ATable: TADDatSTable = nil;
      AMetaInfoMergeMode: TADPhysMetaInfoMergeMode = mmReset): TADDatSTable; overload;
    function Define(ATable: TADDatSTable;
      AMetaInfoMergeMode: TADPhysMetaInfoMergeMode = mmReset): TADDatSTable; overload;
    procedure Execute(ATimes: Integer = 0; AOffset: Integer = 0);
    procedure Fetch(ATable: TADDatSTable; AAll: Boolean = True); overload;
    procedure Fetch(ADatSManager: TADDatSManager;
      AMetaInfoMergeMode: TADPhysMetaInfoMergeMode = mmReset); overload;
    procedure Open;
    procedure Prepare(const ACommandText: String = '');
    procedure Unprepare;
    // R/O
    property Connection: IADPhysConnection read GetConnection;
    property State: TADPhysCommandState read GetState;
    property RowsAffected: Integer read GetRowsAffected;
    property RowsAffectedReal: Boolean read GetRowsAffectedReal;
    property ErrorAction: TADErrorAction read GetErrorAction;
    property SQLOrderByPos: Integer read GetSQLOrderByPos;
    property CliObj: TObject read GetCliObj;
    // R/W
    property Options: IADStanOptions read GetOptions write SetOptions;
    property SchemaName: String read GetSchemaName write SetSchemaName;
    property CatalogName: String read GetCatalogName write SetCatalogName;
    property BaseObjectName: String read GetBaseObjectName write SetBaseObjectName;
    property CommandKind: TADPhysCommandKind read GetCommandKind write SetCommandKind;
    property CommandText: String read GetCommandText write SetCommandText;
    property Params: TADParams read GetParams;
    property Macros: TADMacros read GetMacros;
    property ParamBindMode: TADParamBindMode read GetParamBindMode write SetParamBindMode;
    property Overload: Word read GetOverload write SetOverload;
    property NextRecordSet: Boolean read GetNextRecordSet write SetNextRecordSet;
    property SourceObjectName: String read GetSourceObjectName write SetSourceObjectName;
    property SourceRecordSetName: String read GetSourceRecordSetName write SetSourceRecordSetName;
    property ErrorHandler: IADStanErrorHandler read GetErrorHandler write SetErrorHandler;
    property AsyncHandler: IADStanAsyncHandler read GetAsyncHandler write SetAsyncHandler;
    property MappingHandler: IADPhysMappingHandler read GetMappingHandler write SetMappingHandler;
  end;

  IADPhysMetaInfoCommand = interface(IADPhysCommand)
    ['{3E9B315B-F456-4175-A864-B2573C4A2110}']
    // private
    function GetMetaInfoKind: TADPhysMetaInfoKind;
    procedure SetMetaInfoKind(AValue: TADPhysMetaInfoKind);
    function GetTableKinds: TADPhysTableKinds;
    procedure SetTableKinds(AValue: TADPhysTableKinds);
    function GetWildcard: String;
    procedure SetWildcard(const AValue: String);
    function GetObjectScopes: TADPhysObjectScopes;
    procedure SetObjectScopes(AValue: TADPhysObjectScopes);
    // public
    property MetaInfoKind: TADPhysMetaInfoKind read GetMetaInfoKind write SetMetaInfoKind;
    property TableKinds: TADPhysTableKinds read GetTableKinds write SetTableKinds;
    property Wildcard: String read GetWildcard write SetWildcard;
    property ObjectScopes: TADPhysObjectScopes read GetObjectScopes write SetObjectScopes;
  end;

const
  C_AD_PhysRDBMSKinds: array[TADRDBMSKind] of String =
    ('', 'ORACLE', 'MSSQL', 'MSACCESS', 'MYSQL', 'DB2', 'ASA', 'ADS', 'OTHER');

{$IFDEF AnyDAC_MONITOR}
var
  FADMoniEnabled: Boolean = True;
{$ENDIF}  

function ADPhysManager: IADPhysManager;
function ADGetFillRowOptions(AFetchOptions: TADFetchOptions): TADPhysFillRowOptions;

implementation

uses
  daADStanFactory;

function ADPhysManager: IADPhysManager;
begin
  ADCreateInterface(IADPhysManager, Result);
end;

{-------------------------------------------------------------------------------}
{ EADPhysArrayExecuteError                                                      }
{-------------------------------------------------------------------------------}
constructor EADPhysArrayExecuteError.Create(ATimes, AOffset: Integer;
  AException: Exception);
begin
  inherited Create(0, '');
  FTimes := ATimes;
  FOffset := AOffset;
  FException := AException;
  FAction := eaFail;
end;

{-------------------------------------------------------------------------------}
function ADGetFillRowOptions(AFetchOptions: TADFetchOptions): TADPhysFillRowOptions;
begin
  if AFetchOptions = nil then
    Result := [foData, foBlobs, foDetails]
  else begin
    Result := [foData];
    if fiBlobs in AFetchOptions.Items then
      Include(Result, foBlobs);
    if fiDetails in AFetchOptions.Items then
      Include(Result, foDetails);
  end;
end;

end.
