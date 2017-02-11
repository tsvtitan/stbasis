{-------------------------------------------------------------------------------}
{ AnyDAC error handling support                                                 }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit daADStanError;

interface

uses
  Classes, DB,
  daADStanIntf;

type
  EADExceptionClass = class of EADException;
  EADException = class(EDatabaseError)
  private
    FADCode: Integer;
  public
    constructor Create; overload; virtual;
    constructor Create(AADCode: Integer; const AMessage: String); overload;
    destructor Destroy; override;
    procedure Duplicate(var AValue: EADException); virtual;
    property ADCode: Integer read FADCode;
  end;

  TADCommandExceptionKind = (ekOther, ekNoDataFound, ekRecordLocked,
    ekUKViolated, ekFKViolated, ekObjNotExists, ekUserPwdInvalid,
    ekUserPwdExpired, ekUserPwdWillExpire, ekCmdAborted, ekServerGone,
    ekServerOutput);

  TADDBError = class (TObject)
  private
    FMessage: string;
    FErrorCode: Integer;
    FLevel: Integer;
    FObjName: String;
    FKind: TADCommandExceptionKind;
    FCommandTextOffset: Integer;
    FRowIndex: Integer;
    procedure Assign(ASrc: TADDBError);
  public
    constructor Create; overload;
    constructor Create(ALevel, AErrorCode: Integer; const AMessage,
      AObjName: String; AKind: TADCommandExceptionKind; ACmdOffset: Integer); overload;
    property ErrorCode: Integer read FErrorCode write FErrorCode;
    property Kind: TADCommandExceptionKind read FKind write FKind;
    property Level: Integer read FLevel write FLevel;
    property Message: String read FMessage write FMessage;
    property ObjName: String read FObjName write FObjName;
    property CommandTextOffset: Integer read FCommandTextOffset write FCommandTextOffset;
    property RowIndex: Integer read FRowIndex write FRowIndex;
  end;

  EADDBEngineExceptionClass = class of EADDBEngineException;
  EADDBEngineException = class(EADException)
  private
    FItems: TList;
    FMonitorAdapter: IADMoniAdapter;
    function GetErrors(AIndex: Integer): TADDBError;
    function GetErrorCount: Integer;
    function GetKind: TADCommandExceptionKind;
  public
    constructor Create; overload; override;
    constructor Create(AADCode: Integer; const AMessage: String); overload;
    destructor Destroy; override;
    procedure Duplicate(var AValue: EADException); override;
    procedure Append(AItem: TADDBError);
    property ErrorCount: Integer read GetErrorCount;
    property Errors[Index: Integer]: TADDBError read GetErrors; default;
    property Kind: TADCommandExceptionKind read GetKind;
    property MonitorAdapter: IADMoniAdapter read FMonitorAdapter
      write FMonitorAdapter;
  end;

procedure ADException(AObj: TObject; AEx: EADException); overload;
function ADExceptionLayers(const ALayers: array of String): String;
procedure ADException(AObj: TObject; const ALayers: array of String;
  ACode: Integer; const AArgs: array of const); overload;
procedure ADCapabilityNotSupported(AObj: TObject; const ALayers: array of String);
procedure ADManagerRequired(AObj: TObject; const ALayers: array of String;
  const AMgr: String);

implementation

uses
  SysUtils,
  daADStanConst, daADStanResStrs;

{-------------------------------------------------------------------------------}
constructor EADException.Create;
begin
  inherited Create('');
end;

{-------------------------------------------------------------------------------}
constructor EADException.Create(AADCode: Integer; const AMessage: String);
begin
  inherited Create(AMessage);
  FADCode := AADCode;
end;

{-------------------------------------------------------------------------------}
destructor EADException.Destroy;
begin
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure EADException.Duplicate(var AValue: EADException);
begin
  if AValue = nil then
    AValue := EADExceptionClass(ClassType).Create;
  AValue.Message := Message;
  AValue.FADCode := ADCode;
end;

{-------------------------------------------------------------------------------}
procedure ADException(AObj: TObject; AEx: EADException);
var
  oHndlr: IADStanErrorHandler;
  oMAIntf: IADMoniAdapter;
  oEx: Exception;
  oObj: IADStanObject;
begin
  if (AEx is EADDBEngineException) and
     Supports(AObj, IADMoniAdapter, oMAIntf) then
    EADDBEngineException(AEx).FMonitorAdapter := oMAIntf;
  oEx := Exception(AEx);
  if Supports(AObj, IADStanErrorHandler, oHndlr) then begin
    Supports(AObj, IADStanObject, oObj);
    oHndlr.HandleException(oObj, oEx);
  end;
  if oEx <> nil then
    raise oEx;
end;

{-------------------------------------------------------------------------------}
function ADExceptionLayers(const ALayers: array of String): String;
var
  i: Integer;
begin
  Result := '[AnyDAC]';
  for i := Low(ALayers) to High(ALayers) do
    Result := Result + '[' + ALayers[i] + ']';
end;

{-------------------------------------------------------------------------------}
function GetErrorMessage(ACode: Integer; const AArgs: array of const): String;

  function CheckCustomMessage(const AStdMessage: String): String;
  begin
    if TVarRec(AArgs[1]).VInteger = 1 then
      Result := AStdMessage
    else
      Result := String(TVarRec(AArgs[0]).VAnsiString);
  end;

begin
  case ACode of
  er_AD_DuplicatedName: Result := S_AD_DuplicatedName;
  er_AD_NameNotFound: Result := S_AD_NameNotFound;
  er_AD_ColTypeUndefined: Result := S_AD_ColTypeUndefined;
  er_AD_NoColsDefined: Result := S_AD_NoColsDefined;
  er_AD_CheckViolated: Result := CheckCustomMessage(S_AD_CheckViolated);
  er_AD_CantBeginEdit: Result := S_AD_CantBeginEdit;
  er_AD_CantCreateChildView: Result := S_AD_CantCreateChildView;
  er_AD_RowCantBeDeleted: Result := S_AD_RowCantBeDeleted;
  er_AD_ColMBBLob: Result := S_AD_ColMBBLob;
  er_AD_FixedLenDataMismatch: Result := S_AD_FixedLenDataMismatch;
  er_AD_RowNotInEditableState: Result := S_AD_RowNotInEditableState;
  er_AD_ColIsReadOnly: Result := S_AD_ColIsReadOnly;
  er_AD_RowCantBeInserted: Result := S_AD_RowCantBeInserted;
  er_AD_RowColMBNotNull: Result := S_AD_RowColMBNotNull;
  er_AD_DuplicateRows: Result := CheckCustomMessage(S_AD_DuplicateRows);
  er_AD_NoMasterRow: Result := CheckCustomMessage(S_AD_NoMasterRow);
  er_AD_HasChildRows: Result := CheckCustomMessage(S_AD_HasChildRows);
  er_AD_CantCompareRows: Result := S_AD_CantCompareRows;
  er_AD_ConvIsNotSupported: Result := S_AD_ConvIsNotSupported;
  er_AD_ColIsNotSearchable: Result := S_AD_ColIsNotSearchable;
  er_AD_RowMayHaveSingleParent: Result := S_AD_RowMayHaveSingleParent;
  er_AD_CantOperateInvObj: Result := S_AD_CantOperateInvObj;
  er_AD_CantSetParentRow: Result := S_AD_CantSetParentRow;
  er_AD_RowIsNotNested: Result := S_AD_RowIsNotNested;
  er_AD_ColumnIsNotRef: Result := S_AD_ColumnIsNotRef;
  er_AD_ColumnIsNotSetRef: Result := S_AD_ColumnIsNotSetRef;
  er_AD_OperCNBPerfInState: Result := S_AD_OperCNBPerfInState;
  er_AD_CantSetUpdReg: Result := S_AD_CantSetUpdReg;
  er_AD_TooManyAggs: Result := S_AD_TooManyAggs;
  er_AD_GrpLvlExceeds: Result := S_AD_GrpLvlExceeds;
  er_AD_VarLenDataMismatch: Result := S_AD_VarLenDataMismatch;
  er_AD_BadForeignKey: Result := S_AD_BadForeignKey;
  er_AD_BadUniqueKey: Result := S_AD_BadUniqueKey;
  er_AD_CantChngColType: Result := S_AD_CantChngColType;
  er_AD_BadRelation: Result := S_AD_BadRelation;
  er_AD_CantCreateParentView: Result := S_AD_CantCreateParentView;
  er_AD_CantChangeTableStruct: Result := S_AD_CantChangeTableStruct;
  er_AD_FoundCascadeLoop: Result := S_AD_FoundCascadeLoop;
  er_AD_RecLocked: Result := S_AD_RecLocked;
  er_AD_RecNotLocked: Result := S_AD_RecNotLocked;
  er_AD_TypeIncompat: Result := S_AD_TypeIncompat;

  er_AD_ColumnDoesnotFound: Result := S_AD_ColumnDoesnotFound;
  er_AD_ExprTermination: Result := S_AD_ExprTermination;
  er_AD_ExprMBAgg: Result := S_AD_ExprMBAgg;
  er_AD_ExprCantAgg: Result := S_AD_ExprCantAgg;
  er_AD_ExprTypeMis: Result := S_AD_ExprTypeMis;
  er_AD_ExprIncorrect: Result := S_AD_ExprIncorrect;
  er_AD_InvalidKeywordUse: Result := S_AD_InvalidKeywordUse;
  er_AD_ExprInvalidChar: Result := S_AD_ExprInvalidChar;
  er_AD_ExprNameError: Result := S_AD_ExprNameError;
  er_AD_ExprStringError: Result := S_AD_ExprStringError;
  er_AD_ExprNoLParen: Result := S_AD_ExprNoLParen;
  er_AD_ExprNoRParenOrComma: Result := S_AD_ExprNoRParenOrComma;
  er_AD_ExprNoRParen: Result := S_AD_ExprNoRParen;
  er_AD_ExprEmptyInList: Result := S_AD_ExprEmptyInList;
  er_AD_ExprExpected: Result := S_AD_ExprExpected;
  er_AD_ExprNoArith: Result := S_AD_ExprNoArith;
  er_AD_ExprBadScope: Result := S_AD_ExprBadScope;
  er_AD_ExprEmpty: Result := S_AD_ExprEmpty;
  er_AD_ExprEvalError: Result := S_AD_ExprEvalError;

  er_AD_DSNoNookmark: Result := S_AD_DSNoNookmark;
  er_AD_DSViewNotSorted: Result := S_AD_DSViewNotSorted;
  er_AD_DSNoAdapter: Result := S_AD_DSNoAdapter;
  er_AD_DSNoNestedMasterSource: Result := S_AD_DSNoNestedMasterSource;
  er_AD_DSCircularDataLink: Result := S_AD_DSCircularDataLink;
  er_AD_DSRefreshError: Result := S_AD_DSRefreshError;
  er_AD_DSNoDataTable: Result := S_AD_DSNoDataTable;
  er_AD_DSIndNotFound: Result := S_AD_DSIndNotFound;
  er_AD_DSAggNotFound: Result := S_AD_DSAggNotFound;
  er_AD_DSIndNotComplete: Result := S_AD_DSIndNotComplete;
  er_AD_DSAggNotComplete: Result := S_AD_DSAggNotComplete;
  er_AD_DSRefreshError2: Result := S_AD_DSRefreshError2;

  er_AD_DefCircular: Result := S_AD_DefCircular;
  er_AD_DefRO: Result := S_AD_DefRO;
  er_AD_DefCantMakePers: Result := S_AD_DefCantMakePers;
  er_AD_DefAlreadyLoaded: Result := S_AD_DefAlreadyLoaded;
  er_AD_DefNotExists: Result := S_AD_DefNotExists;
  er_AD_DefDupName: Result := S_AD_DefDupName;

  er_AD_AccSrvNotFound: Result := S_AD_AccSrvNotFound;
  er_AD_AccSrvNotDefined: Result := S_AD_AccSrvNotDefined;
  er_AD_AccCantSaveCfgFileName: Result := S_AD_AccCantSaveCfgFileName;
  er_AD_AccSrvMBConnected: Result := S_AD_AccSrvMBConnected;
  er_AD_AccCapabilityNotSup: Result := S_AD_AccCapabilityNotSup;
  er_AD_AccTxMBActive: Result := S_AD_AccTxMBActive;
  er_AD_AccCantChngCommandState: Result := S_AD_AccCantChngCommandState;
  er_AD_AccCommandMBFilled: Result := S_AD_AccCommandMBFilled;
  er_AD_AccSrvrIntfMBAssignedS: Result := S_AD_AccSrvrIntfMBAssignedS;
  er_AD_AccCmdMHRowSet: Result := S_AD_AccCmdMHRowSet;
  er_AD_AccCmdMBPrepared: Result := S_AD_AccCmdMBPrepared;
  er_AD_AccCantExecCmdWithRowSet: Result := S_AD_AccCantExecCmdWithRowSet;
  er_AD_AccCmdMBOpen4Fetch: Result := S_AD_AccCmdMBOpen4Fetch;
  er_AD_AccExactFetchMismatch: Result := S_AD_AccExactFetchMismatch;
  er_AD_AccMetaInfoMismatch: Result := S_AD_AccMetaInfoMismatch;
  er_AD_AccCantLoadLibrary: Result := S_AD_AccCantLoadLibrary;
  er_AD_AccCantGetLibraryEntry: Result := S_AD_AccCantGetLibraryEntry;
  er_AD_AccSrvMBDisConnected: Result := S_AD_AccSrvMBDisConnected;
  er_AD_AccToManyLogins: Result := S_AD_AccToManyLogins;
  er_AD_AccCantOperDrv: Result := S_AD_AccCantOperDrv;
  er_AD_AccDrvPackEmpty: Result := S_AD_AccDrvPackEmpty;
  er_AD_AccDrvMngrMB: Result := S_AD_AccDrvMngrMB;
  er_AD_AccPrepMissed: Result := S_AD_AccPrepMissed;
  er_AD_AccPrepParamNotDef: Result := S_AD_AccPrepParamNotDef;
  er_AD_AccPrepTooLongIdent: Result := S_AD_AccPrepTooLongIdent;
  er_AD_AccPrepUnknownEscape: Result := S_AD_AccPrepUnknownEscape;
  er_AD_AccParamArrayMismatch: Result := S_AD_AccParamArrayMismatch;
  er_AD_AccAsyncOperInProgress: Result := S_AD_AccAsyncOperInProgress;
  er_AD_AccEscapeIsnotSupported: Result := S_AD_AccEscapeIsnotSupported;
  er_AD_AccMetaInfoReset: Result := S_AD_AccMetaInfoReset;
  er_AD_AccWhereIsEmpty: Result := S_AD_AccWhereIsEmpty;
  er_AD_AccUpdateTabUndefined: Result := S_AD_AccUpdateTabUndefined;
  er_AD_AccNameHasErrors: Result := S_AD_AccNameHasErrors;
  er_AD_AccEscapeBadSyntax: Result := S_AD_AccEscapeBadSyntax;
  er_AD_AccDrvIsNotReg: Result := S_AD_AccDrvIsNotReg;
  er_AD_AccShutdownTO: Result := S_AD_AccShutdownTO;
  er_AD_AccParTypeUnknown: Result := S_AD_AccParTypeUnknown;
  er_AD_AccParDataMapNotSup: Result := S_AD_AccParDataMapNotSup;
  er_AD_AccColDataMapNotSup: Result := S_AD_AccColDataMapNotSup;
  er_AD_AccParDefChanged: Result := S_AD_AccParDefChanged;
  er_AD_AccMetaInfoNotDefined: Result := S_AD_AccMetaInfoNotDefined;

  er_AD_DAptRecordIsDeleted: Result := S_AD_DAptRecordIsDeleted;
  er_AD_DAptRecordIsLocked: Result := S_AD_DAptRecordIsLocked;
  er_AD_DAptNoSelectCmd: Result := S_AD_DAptNoSelectCmd;
  er_AD_DAptApplyUpdateFailed: Result := S_AD_DAptApplyUpdateFailed;
  er_AD_DAptCantEdit: Result := S_AD_DAptCantEdit;
  er_AD_DAptCantInsert: Result := S_AD_DAptCantInsert;
  er_AD_DAptCantDelete: Result := S_AD_DAptCantDelete;

  er_AD_ClntSessMBSingle: Result := S_AD_ClntSessMBSingle;
  er_AD_ClntSessMBInactive: Result := S_AD_ClntSessMBInactive;
  er_AD_ClntSessMBActive: Result := S_AD_ClntSessMBActive;
  er_AD_ClntDbDupName: Result := S_AD_ClntDbDupName;
  er_AD_ClntDbMBInactive: Result := S_AD_ClntDbMBInactive;
  er_AD_ClntDbMBActive: Result := S_AD_ClntDbMBActive;
  er_AD_ClntDbLoginAborted: Result := S_AD_ClntDbLoginAborted;
  er_AD_ClntDbCantConnPooled: Result := S_AD_ClntDbCantConnPooled;
  er_AD_ClntDBNotFound: Result := S_AD_ClntDBNotFound;
  er_AD_ClntAdaptMBActive: Result := S_AD_ClntAdaptMBActive;
  er_AD_ClntAdaptMBInactive: Result := S_AD_ClntAdaptMBInactive;
  er_AD_ClntNotCachedUpdates: Result := S_AD_ClntNotCachedUpdates;
  er_AD_ClntDbNotDefined: Result := S_AD_ClntDbNotDefined;

  er_AD_DPNoAscFld: Result := S_AD_DPNoAscFld;
  er_AD_DPNoSrcDS: Result := S_AD_DPNoSrcDS;
  er_AD_DPNoDestDS: Result := S_AD_DPNoDestDS;
  er_AD_DPNoAscDest: Result := S_AD_DPNoAscDest;
  er_AD_DPNoAscSrc: Result := S_AD_DPNoAscSrc;
  er_AD_DPBadFixedSize: Result := S_AD_DPBadFixedSize;
  er_AD_DPAscFldDup: Result := S_AD_DPAscFldDup;
  er_AD_DPBadAsciiFmt: Result := S_AD_DPBadAsciiFmt;
  er_AD_DPSrcUndefined: Result := S_AD_DPSrcUndefined;

  er_AD_StanTimeout: Result := S_AD_StanTimeout;
  er_AD_StanCantGetBlob: Result := S_AD_StanCantGetBlob;
  er_AD_StanPoolMBInactive: Result := S_AD_StanPoolMBInactive;
  er_AD_StanPoolMBActive: Result := S_AD_StanPoolMBActive;
  er_AD_StanCantNonblocking: Result := S_AD_StanCantNonblocking;
  er_AD_StanMacroNotFound: Result := S_AD_StanMacroNotFound;
  er_AD_StanBadParRowIndex: Result := S_AD_StanBadParRowIndex;
  er_AD_StanPoolAcquireTimeout: Result := S_AD_StanPoolAcquireTimeout;
  er_AD_StanMgrRequired: Result := S_AD_StanMgrRequired;

  er_AD_DBXParMBNotEmpty: Result := S_AD_DBXParMBNotEmpty;
  er_AD_DBXNoDriverCfg: Result := S_AD_DBXNoDriverCfg;

  er_AD_MySQLBadVersion: Result := S_AD_MySQLBadVersion;
  er_AD_MySQLCantSetPort: Result := S_AD_MySQLCantSetPort;
  er_AD_MySQLBadParams: Result := S_AD_MySQLBadParams;
  er_AD_MySQLCantInitEmbeddedServer: Result := S_AD_MySQLCantInitEmbeddedServer;


  er_AD_OdbcDataToLarge: Result := S_AD_OdbcDataToLarge;
  er_AD_OdbcVarDataTypeUnsup: Result := S_AD_OdbcVarDataTypeUnsup;
  er_AD_OdbcParamArrMismatch: Result := S_AD_OdbcParamArrMismatch;

  er_AD_OraNoCursor: Result := S_AD_OraNoCursor;
  er_AD_OraCantAssFILE: Result := S_AD_OraCantAssFILE;
  er_AD_OraNoCursorParams: Result := S_AD_OraNoCursorParams;
  er_AD_OraNotInstalled: Result := S_AD_OraNotInstalled;
  er_AD_OraBadVersion: Result := S_AD_OraBadVersion;
  er_AD_OraOutOfCount: Result := S_AD_OraOutOfCount;
  er_AD_OraBadValueSize: Result := S_AD_OraBadValueSize;
  er_AD_OraBadArrayLen: Result := S_AD_OraBadArrayLen;
  er_AD_OraBadValueType: Result := S_AD_OraBadValueType;
  er_AD_OraUnsupValueType: Result := S_AD_OraUnsupValueType;
  er_AD_OraDataToLarge: Result := S_AD_OraDataToLarge;
  er_AD_OraVarWithoutStmt: Result := S_AD_OraVarWithoutStmt;
  er_AD_OraBadVarType: Result := S_AD_OraBadVarType;
  er_AD_OraUndefPWVar: Result := S_AD_OraUndefPWVar;
  er_AD_OraBadTypePWVar: Result := S_AD_OraBadTypePWVar;
  er_AD_OraTooLongGTRID: Result := S_AD_OraTooLongGTRID;
  er_AD_OraTooLongBQUAL: Result := S_AD_OraTooLongBQUAL;
  er_AD_OraTooLongTXName: Result := S_AD_OraTooLongTXName;
  er_AD_OraDBTNManyClBraces: Result := S_AD_OraDBTNManyClBraces;
  er_AD_OraNotPLSQLObj: Result := S_AD_OraNotPLSQLObj;
  er_AD_OraPLSQLObjNameEmpty: Result := S_AD_OraPLSQLObjNameEmpty;
  er_AD_OraNotPackageProc: Result := S_AD_OraNotPackageProc;
  er_AD_OraBadTableType: Result := S_AD_OraBadTableType;
  er_AD_OraUnNamedRecParam: Result := S_AD_OraUnNamedRecParam;
  end;
end;

{-------------------------------------------------------------------------------}
procedure ADException(AObj: TObject; const ALayers: array of String;
  ACode: Integer; const AArgs: array of const);
var
  s, sMsg: String;
begin
  sMsg := GetErrorMessage(ACode, AArgs);
  s := ADExceptionLayers(ALayers) + '-' + IntToStr(ACode) + '. ';
  try
    s := s + Format(sMsg, AArgs);
  except
    s := s + sMsg;
  end;
  ADException(AObj, EADException.Create(ACode, s));
end;

{-------------------------------------------------------------------------------}
procedure ADCapabilityNotSupported(AObj: TObject; const ALayers: array of String);
begin
  ADException(AObj, ALayers, er_AD_AccCapabilityNotSup, []);
end;

{-------------------------------------------------------------------------------}
procedure ADManagerRequired(AObj: TObject; const ALayers: array of String;
  const AMgr: String);
begin
  ADException(AObj, ALayers, er_AD_StanMgrRequired, [AMgr]);
end;

{-------------------------------------------------------------------------------}
{ TADDBError                                                                    }
{-------------------------------------------------------------------------------}
constructor TADDBError.Create;
begin
  inherited Create;
  FCommandTextOffset := -1;
  FRowIndex := -1;
end;

{-------------------------------------------------------------------------------}
constructor TADDBError.Create(ALevel, AErrorCode: Integer;
  const AMessage, AObjName: String; AKind: TADCommandExceptionKind;
  ACmdOffset: Integer);
begin
  Create;
  FLevel := ALevel;
  FErrorCode := AErrorCode;
  FMessage := AMessage;
  FObjName := AObjName;
  FKind := AKind;
  FCommandTextOffset := ACmdOffset;
end;

{-------------------------------------------------------------------------------}
procedure TADDBError.Assign(ASrc: TADDBError);
begin
  FLevel := ASrc.Level;
  FErrorCode := ASrc.ErrorCode;
  FMessage := ASrc.Message;
  FObjName := ASrc.ObjName;
  FKind := ASrc.Kind;
  FCommandTextOffset := ASrc.CommandTextOffset;
end;

{-------------------------------------------------------------------------------}
{ EADDBEngineException                                                          }
{-------------------------------------------------------------------------------}
constructor EADDBEngineException.Create;
begin
  inherited Create(0, '');
  FItems := TList.Create;
end;

{-------------------------------------------------------------------------------}
constructor EADDBEngineException.Create(AADCode: Integer;
  const AMessage: String);
begin
  inherited Create(AADCode, AMessage);
  FItems := TList.Create;
end;

{-------------------------------------------------------------------------------}
destructor EADDBEngineException.Destroy;
var
  i: Integer;
begin
  FMonitorAdapter := nil;
  for i := 0 to FItems.Count - 1 do
    TADDBError(FItems[i]).Free;
  FreeAndNil(FItems);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure EADDBEngineException.Duplicate(var AValue: EADException);
var
  oItem: TADDBError;
  i: Integer;
begin
  inherited Duplicate(AValue);
  EADDBEngineException(AValue).FMonitorAdapter := MonitorAdapter;
  for i := 0 to FItems.Count - 1 do begin
    oItem := TADDBError.Create;
    oItem.Assign(TADDBError(FItems[i]));
    EADDBEngineException(AValue).FItems.Add(oItem);
  end;
end;

{-------------------------------------------------------------------------------}
function EADDBEngineException.GetErrorCount: Integer;
begin
  Result := FItems.Count;
end;

{-------------------------------------------------------------------------------}
function EADDBEngineException.GetErrors(AIndex: Integer): TADDBError;
begin
  Result := TADDBError(FItems[AIndex]);
end;

{-------------------------------------------------------------------------------}
function EADDBEngineException.GetKind: TADCommandExceptionKind;
begin
  if FItems.Count > 0 then
    Result := Errors[0].Kind
  else
    Result := ekOther;
end;

{-------------------------------------------------------------------------------}
procedure EADDBEngineException.Append(AItem: TADDBError);
begin
  FItems.Add(AItem);
end;

end.
