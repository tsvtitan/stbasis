{-------------------------------------------------------------------------------}
{ AnyDAC QA utils implementation                                                }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit ADQAUtils;

interface

uses
  DB, Windows, SysUtils, ComCtrls, Classes,
{$IFDEF AnyDAC_D6}
    StrUtils, FMTBcd, SqlTimSt, Variants,
{$ELSE}
    ActiveX,    
{$ENDIF}    
  daADStanIntf, daADStanOption, daADStanParam,
  daADDatSManager,
  daADGUIxIntf,
  daADPhysIntf,
  daADDAptIntf,
  daADCompClient;

type
  TStrCompare     = function (const s1, s2: String): Integer;
  TWideStrCompare = function (const s1, s2: WideString): Integer;

  // Error messages
  function ThisGroupAdded: String;
  function ErrorOnTestExec(const ATestName, AExcMsg: String): String;
  function ErrorTableDefine(const ARDBMS, AExcMsg: String): String;
  function ErrorOnSetParamValue(const AVal, AExcMsg: String): String;
  function ErrorOnCommExec(const ARDBMS, AExcMsg: String): String;
  function MacroCountIsZero(const AType: String): String;
  function MacroFails(const ARDBMS, AType: String): String;
  function CannotContinueTest: String;
  function ErrorFetchToTable(const ARDBMS, AExcMsg: String): String;
  function WrongValueInColumn(const AColName, ARDBMS, AV1, AV2: String): String;
  function WrongValueInTable(const AColName: String; ARow: Integer; AV1, AV2: String; ATab: String = ''): String;
  function WrongValueInColumnMeta(const AColName: String; ARow: Integer; ATab, AObj,
    ARDBMS, AV1, AV2: String): String;
  function WrongProcArgValueMeta(const AColName, AArg, ATab, AObj, ARDBMS, AV1, AV2: String): String;
  function WrongTypeValueMeta(const AColName, AType, ATab, AObj, ARDBMS, AV1, AV2: String): String;
  function ErrorOnCompareVal(const AColName, AExcMsg: String): String;
  function ErrorOnInitParamArray(const AExcMsg: String): String;
  function ErrorOnImport(ANum: Integer): String;
  function AutoIncFails: String;
  function RelationsFails(const AColName: String): String;
  function ErrorGettingChildView(const AColName, AExcMsg: String): String;
  function ErrorOnInitMech(const AMech, AExcMsg: String): String;
  function MechFails(const AMech, AColName, AAddStr: String): String; overload;
  function MechFails(const AMech, AV1, ASign, AV2: String): String; overload;
  function TypeMismError(const ADef, AReal, AMsg, AProcName: String): String;
  function ParamCountIsZero(const AProcName: String): String;
  function WrongParamType(const AType, AExpType, AProcName: String): String;
  function ErrorOnStorProc(const AProcName, AMsg: String): String;
  function ErrorOnStorProcParam(const AProcName, AParam, AV1, AV2: String): String;
  function CannotTestStorProc(const AProcName: String): String;
  function WrongValueInParam(const APar, AGot, AExp: String): String;
  function ErrorOnClearTbRows(AExcMsg: String): String;
  function ErrorOnTbReset(AExcMsg: String): String;
  function ReadingFails(const AColName, AExcMsg: String): String;
  function EscapeFuncFails(const AFunName, AGot, AExp: String): String;
  function AggregateError(const AKind, ACol, AV1, AV2: String): String; overload;
  function AggregateError(const AKind, ACol, AReason: String): String; overload;
  function ComputeError(const AKind, AV1, AV2: String): String; overload;
  function ComputeError(const AKind, AReason: String): String; overload;
  function WrongValueInCalcCol(const AV1, AV2, AT1, AT2: String): String;
  function AcceptingFails(const AWhere, AMsg: String): String;
  function RejectingFails(const AWhere, AMsg: String): String;
  function ComparingRowFails(const AMsg: String): String;
  function SearchFails(const AColName: String): String;
  function ErrorOnExecFind(const AExcMsg: String): String;
  function RowFiltFails(const AV1, ASign, AV2: String): String;
  function RowStFiltFails(const AState: String): String;
  function SortingFails(const AIn, ADesc, AWide, AS1, AS2: String): String; overload;
  function SortingFails(const ADesc, AV1, ASign, AV2: String): String; overload;
  function ErrorInColumn(const AColName, AExcMsg: String): String;
  function ErrorOnReset(const AExcMsg: String): String;
  function DefineError(const AWhat, AAs, ARDBMS: String): String;
  function FailedDataChange(const AHow: String): String;
  function FailedDataDelete(const AHow, AMsg: String): String;
  function FailedRestrOnParentData(const AWhat: String): String;
  function FailedNullifData(const AWhat, AMsg: String): String;
  function FaildExcpWhereChildDel: String;
  function WrongCharsInBinary(const AColName, AMsg: String): String;
  function WrongExpectedCount(const AWhat, AWhere: String; ADef, AExp: Integer): String;
  function VariantIsNull: String;
  function DuplUnIndexError: String;
  function UnIndexError: String;
  function ErrorOnInsert(const ARDBMS, AExcMsg: String): String;
  function ErrorCommPrepare(const ARDBMS, AExcMsg: String): String;
  function WrongBatchInserting(const AField, AV1, AV2: String): String;
  function WrongBatchInsertCount: String;
  function ErrorBatchAffect(AGot, AExp: Integer): String;
  function ErrorOnMappingInsert(ASource, ATarget, AExcMsg: String): String;
  function WrongMappingInsert(ASource, ATarget, AExp, AGot: String): String;
  function WrongConvertData(ASource, ATarget, AV1, AV2: String): String; overload;
  function WrongConvertData(ASource, ATarget, AReason: String): String; overload;
  function WrongColumnCount(AExpect, AGot: Integer): String;
  function WrongFieldCount(AExpect, AGot: Integer): String;
  function WrongTableCount(AExpect, AGot: Integer): String;
  function WrongTableName(AExpect, AGot: String): String;
  function WrongRowCount(AExpect, AGot: Integer): String;
  function WrongColumnName(AExpect, AGot: String): String;
  function WrongColumnType(ANum: Integer; AExpect, AGot: String): String;
  function ThereAreNoReqVal(AVal, ACol: String): String;
  function ThereAreUnexpVal(AVal, ACol: String): String;
  function ErrorMetaCommPrepare(AExcMes: String): String;
  function TableNotFound(AName: String): String;
  function WrongErrCount(AGot, AExpect: Integer): String;
  function DatSTableISNil: String;
  function UpdateExecTimeBig(AGot, AExpect: Integer): String;
  function UpdateExecTimeSmall(AGot, AExpect: Integer): String;
  function WrongCountOfUpdate(AGot, AExpect: Integer): String;
  function UpdateDuringTrans: String;
  function DontUpdateAfterTrans: String;
  function CntUpdatedRowsIsNull: String;
  function CntErrOnUpdateIsWrong(AGot, AExp: Integer): String;
  function ThereAreTwoUpdRows: String;
  function ThereIsUnexpRow: String;
  function TransIsInactive: String;
  function TransIsActive: String;
  function ErrorResultTrans: String;
  function ConnectionDefAlreadyDel(AName: String): String;
  function ConnectionDefIsNotLocked(AName: String): String;
  function ConnectionDefNameDublicated(AName: String): String;
  function ConnectionDefNotLoaded: String;
  function ConnectToErrBase: String;
  function TheConnectionDefIsNotCleared: String;
  function EscapeFails(AEsc, AGot, AExpect: String): String;
  function CancelDialogFails: String;
  function PoolingError(AT1, AT2: Integer): String;
  function DidYouSee(AWhat: String): String;
  function SimpleQuestion: String;
  function WrongParCount(AGot, AExp: Integer): String;
  function ThereAreNoParInReg(AWhat: String): String;
  function ThereAreNoParInIni(AWhat: String): String;
  function ExecAborted: String;
  function NoExcWithAsyncMode: String;
  function StateIsNotWaited(AState, ARealSt: String): String;
  function ParBindMode(APar, AExp, AGot: String): String;
  function WrongParamName(AGot, AExp: String): String;
  function WrongCountInactComm(AGot, AExp: Integer): String;
  function WrongRowState(AGot, AExp: String; AComm: String = ''): String;
  function UnsuppType(AType: String): String;
  function ErrBorderLength(ALen: Integer; ACol, AExc: String): String;
  function WrongWithBorderLength(ACol: String; ALen: Integer; AGot, AExp: String): String;
  function ErrorOnUpdate(AGot, AExp: Integer): String;
  function NoExcRaised: String;
  function WrongTypeCast(ASrc, daADest, AGot, AExp: String): String;
  function WrongBlobData(AChar: String; APos: Integer; AComment: String = ''): String;
  function ErrorOnWriteBlobData(ALen: Integer; AExp: String = ''): String;
  function ErrorOnAbortFunction(AExp: String): String;
  function ErrorOnUnprepFunction(AExp: String): String;
  function ErrorBatchExec(AExc: String): String;
  function SearchFromBegin: String;
  function TestNotFound(AName: String): String;
  function SetFieldValueError(AName: String): String;
  function FieldIndexError(ANum: Integer): String;
  function EmptyDSError(AExc: String): String;
  function UniqueIndexError(AName: String): String;
  function UnSelectIndexError(AName: String): String;
  function ActivateIndexError(AName, AExc: String): String;
  function DescendIndexError(AName: String): String;
  function CaseInsensIndexError(AName: String): String;
  function FindKeyError(AKey, AName: String): String;
  function LocateError(const AFieldName: String): String;
  function LookupError(const AFieldName, ALooked, AExp: String): String;
  function LocateWithOptionsError(const AFieldName: String;
    AOptions: TLocateOptions): String;
  function NavigationError(const AMethodName: String): String;
  function FilterError(const AFieldName: String;
    AOptions: TFilterOptions): String;
  function FilterCountError: String;
  function CantCreateFilter(const AFieldName: String): String;
  function SetRangeError(const AFieldName, AIndexName: String): String;
  function CancelRangeError(const AFieldName, AIndexName: String): String;
  function MasterDetailError(const AFieldName: String): String;
  function AggregatesError(const AFieldName, AAggKindName, AIndexName: String): String;
  function SaveLoadError: String;
  function CloneCursorError: String;
  function DefineFieldsError(const AErrorMsg: String): String;
  function DefineExistingFieldError: String;
  function DefineSameFieldsError: String;
  function AppendFCDSError(const AUpdateMethodName: String): String;
  function EditFCDSError(AList: TStrings): String;
  function ErrorOnQueryOpen(const AExc: String): String;
  function WrongFieldsCountInQuery(const AGot, AExp: Integer): String;
  function WrongValInQryField(const AName, AGot, AExp: String): String;
  function DSStateIsNotWaited(AState: String): String;
  function WrongCountInactQry(AGot, AExp: Integer): String;
  function ErrorsDuringApplyUpdates: String;
  function CmdPreprError(AGot, AExp: String): String;
  function WrongUpdatedVals(AGot, AExp: String): String;
  function WrongInsertedVals(ARecFrm, AGot, AExp, AComm: String): String;
  function FileIsEmpty: String;
  function WrongField(AWhat, AWhere, AGot, AExp: String): String;
  function ErrorOnPumpExec(AExc, ACmnt1, ACmnt2: String): String;
  function RecCountIsZero(AMsg: String): String;
  function FilesAreDiffer(AGot, AExp: String): String;
  function AllFieldsAreNull(AMsg, ACommnt: String): String;
  function RecCountIsWrong(ARecForm: String; AGot, AExp: Integer; ACommnt: String): String;
  function ObjIsNotFound(AObj, AMsg: String): String;
  function ErrorLookupFields(AType, AGot, AExp: String): String;
  function ErrorOnField(AMsg, AType: String): String;
  function FieldsDiffer(AName, AGot, AExp: String): String;
  function CalcFieldValNull(AResFld, AFld1, AFld2, AExpr: String): String;
  function ErrorOnCalcField(AResFld, AFld1, AFld2, AExpr, AExcMsg: String): String;
  function WrongCalcFieldValNull(AResFld, AGot, AExp, AFld1, AFld2, AExpr: String): String;
  function WrongTimestampAttr: String;

  // Conversion
  function StrToDate_Cast(const AStr: String): TDateTime;
  function StrToTime_Cast(const AStr: String): TDateTime;
  function StrToDateTime_Cast(const AStr: String): TDateTime;
  function StrToFloat_Cast(const AStr: String): Double;
  function StrToCurrency_Cast(const AStr: String): Currency;
  function StrToBcd_Cast(const AStr: String): TBcd;
  function StrToSQLTimeStamp_Cast(const AStr: String): TADSQLTimeStamp;
  function VarToStr_Cast(const AValue: Variant): String;
  function VarToValue(const AValue, ADefault: Variant): Variant;

  // For the tests with command
  function EncodeName(ARDBMSKind: TADRDBMSKind; AName: String): String;
  function SumOp  (V1, V2: Variant): Variant;
  function DeducOp(V1, V2: Variant): Variant;
  function MulOp  (V1, V2: Variant): Variant;
  function DivOp  (V1, V2: Variant): Variant;

  // For TTreeView
  function  AllCheckedInGroup(AChildNode: TTreeNode): Boolean;
  function  HasCheckedInGroup(AChildNode: TTreeNode): Boolean;
  procedure CheckParGrayWhenCheck(ANode: TTreeNode);
  procedure CheckParGrayWhenUncheck(ANode: TTreeNode; AChild: TTreeNode = nil);

  // Used by many tests
  procedure ActivateDEManger;
  procedure OpenPhysManager;
  procedure SetConnectionDefFileName(AFileName: String; AToDEManger: Boolean = False);

  // For tests to compare strings
  function AnsiCompareStrA(const S1, S2: String): Integer;
  function AnsiCompareTextA(const S1, S2: String): Integer;
  function WideCompareStrA(const S1, S2: WideString): Integer;
  function WideCompareTextA(const S1, S2: WideString): Integer;

  // Used by several tests
  procedure RefetchTable(AName: String; ATab: TADDatSTable; AComm: IADPhysCommand;
    AOrdBy: String = 'id');

  // Used by many tests
  function GetConnectionDef(AKind: TADRDBMSKind): String;
  function GetDBMSName(AKind: TADRDBMSKind): String;
  function GetStringFromArray(V: Variant): String;
  function Compare(const V1, V2: Variant; AType: TFieldType = ftUnknown): Integer;

  // Examination field types
  function IsBooleanField(AFieldNum: Integer): Boolean;
  function IsStringField(AFieldNum: Integer): Boolean;
  function IsNonTextField(AFieldNum: Integer): Boolean;
  function IsNumericField(AFieldNum: Integer): Boolean;

  // Getting field values
  function GetDefaultValue(AFieldNum: Integer; ATSasVar: Boolean = True): Variant;
  procedure GetRangeValue(AFieldNum: Integer; var AMin, AMax: Variant);
  function GetMinValue(AFieldNum: Integer): Variant;
  function GetMaxValue(AFieldNum: Integer): Variant;
  function GetSumValue(AFieldNum: Integer): Variant;
  function GetAggValue(AFieldNum: Integer): Variant;

  procedure SetFieldValue(AField: TField; const AValue: Variant);
{$IFNDEF AnyDAC_D6}
  function GetEnvironmentVariable(const Name: string): string;
{$ENDIF}  

implementation

uses
  daADStanConst, daADStanUtil,
  ADQAConst;

{-------------------------------------------------------------------------------}
function ThisGroupAdded: String;
begin
  Result := ThisGroupAddedMsg;
end;

{-------------------------------------------------------------------------------}
function ErrorOnTestExec(const ATestName, AExcMsg: String): String;
begin
  Result := Format(ErrorOnTestExecMsg, [ATestName, AExcMsg]);
end;

{-------------------------------------------------------------------------------}
function ErrorTableDefine(const ARDBMS, AExcMsg: String): String;
begin
  Result := Format(ErrorTableDefineMsg, [ARDBMS, AExcMsg]);
end;

{-------------------------------------------------------------------------------}
function ErrorOnSetParamValue(const AVal, AExcMsg: String): String;
begin
  Result := Format(ErrorOnSetParamValueMsg, [AVal, AExcMsg]);
end;

{-------------------------------------------------------------------------------}
function ErrorOnCommExec(const ARDBMS, AExcMsg: String): String;
begin
  Result := Format(ErrorOnCommExecMsg, [ARDBMS, AExcMsg]);
end;

{-------------------------------------------------------------------------------}
function MacroCountIsZero(const AType: String): String;
begin
  Result := Format(MacroCountIsZeroMsg, [AType]);
end;

{-------------------------------------------------------------------------------}
function MacroFails(const ARDBMS, AType: String): String;
begin
  Result := Format(MacroFailsMsg, [AType, ARDBMS]);
end;

{-------------------------------------------------------------------------------}
function CannotContinueTest: String;
begin
  Result := CannotContinueTestMsg;
end;

{-------------------------------------------------------------------------------}
function ErrorFetchToTable(const ARDBMS, AExcMsg: String): String;
begin
  Result := Format(ErrorFetchToTableMsg, [ARDBMS, AExcMsg]);
end;

{-------------------------------------------------------------------------------}
function WrongValueInColumn(const AColName, ARDBMS, AV1, AV2: String): String;
begin
  Result := Format(WrongValueInColumnMsg, [AColName, ARDBMS, AV1, AV2]);
end;

{-------------------------------------------------------------------------------}
function WrongValueInTable(const AColName: String; ARow: Integer; AV1, AV2: String; ATab: String = ''): String;
begin
  Result := Format(WrongValueInTableMsg, [AColName, ARow, ATab, AV1, AV2]);
end;

{-------------------------------------------------------------------------------}
function WrongValueInColumnMeta(const AColName: String; ARow: Integer; ATab, AObj,
  ARDBMS, AV1, AV2: String): String;
begin
  Result := Format(WrongValueInColumnMetaMsg, [AColName, ARow, ATab, AObj, ARDBMS, AV1, AV2]);
end;

{-------------------------------------------------------------------------------}
function WrongProcArgValueMeta(const AColName, AArg, ATab, AObj, ARDBMS, AV1, AV2: String): String;
begin
  Result := Format(WrongProcArgValueMetaMsg, [AColName, AArg, ATab, AObj, ARDBMS, AV1, AV2]);
end;

{-------------------------------------------------------------------------------}
function WrongTypeValueMeta(const AColName, AType, ATab, AObj, ARDBMS, AV1, AV2: String): String;
begin
  Result := Format(WrongTypeValueMetaMsg, [AColName, AType, ATab, AObj, ARDBMS, AV1, AV2]);
end;

{-------------------------------------------------------------------------------}
function ErrorOnCompareVal(const AColName, AExcMsg: String): String;
begin
  Result := Format(ErrorOnCompareValMsg, [AColName, AExcMsg]);
end;

{-------------------------------------------------------------------------------}
function ErrorOnInitParamArray(const AExcMsg: String): String;
begin
  Result := Format(ErrorOnInitParamArrayMsg, [AExcMsg]);
end;

{-------------------------------------------------------------------------------}
function ErrorOnImport(ANum: Integer): String;
begin
  if ANum = -1 then
    Result := Format(ErrorOnImportMsg, [])
  else
    Result := Format(ErrorOnImportMsg, [ANum]);
end;

{-------------------------------------------------------------------------------}
function AutoIncFails: String;
begin
  Result := AutoIncFailsMsg;
end;

{-------------------------------------------------------------------------------}
function RelationsFails(const AColName: String): String;
begin
 Result := Format(RelationsFailsMsg, [AColName]);
end;

{-------------------------------------------------------------------------------}
function ErrorGettingChildView(const AColName, AExcMsg: String): String;
begin
 Result := Format(ErrorGettingChildViewMsg, [AColName, AExcMsg]);
end;

{-------------------------------------------------------------------------------}
function ErrorOnInitMech(const AMech, AExcMsg: String): String;
begin
  Result := Format(ErrorOnInitMechMsg, [AMech, AExcMsg]);
end;

{-------------------------------------------------------------------------------}
function MechFails(const AMech, AColName, AAddStr: String): String;
begin
  Result := Format(MechFailsMsg, [AMech, AColName, AAddStr]);
end;

{-------------------------------------------------------------------------------}
function MechFails(const AMech, AV1, ASign, AV2: String): String;
begin
  Result := Format(MechFails2Msg, [AMech, AV1, ASign, AV2]);
end;

{-------------------------------------------------------------------------------}
function TypeMismError(const ADef, AReal, AMsg, AProcName: String): String;
begin
  Result := Format(TypeMismErrorMsg, [ADef, AReal, AMsg, AProcName]);
end;

{-------------------------------------------------------------------------------}
function ParamCountIsZero(const AProcName: String): String;
begin
  Result := Format(ParamCountIsZeroMsg, [AProcName]);
end;

{-------------------------------------------------------------------------------}
function WrongParamType(const AType, AExpType, AProcName: String): String;
begin
  Result := Format(WrongParamTypeMsg, [AType, AExpType, AProcName]);
end;

{-------------------------------------------------------------------------------}
function ErrorOnStorProc(const AProcName, AMsg: String): String;
begin
  Result := Format(ErrorOnStorProcMsg, [AProcName, AMsg]);
end;

{-------------------------------------------------------------------------------}
function ErrorOnStorProcParam(const AProcName, AParam, AV1, AV2: String): String;
begin
  Result := Format(ErrorOnStorProcParamMsg, [AProcName, AParam, AV2, AV1]);
end;

{-------------------------------------------------------------------------------}
function CannotTestStorProc(const AProcName: String): String;
begin
  Result := Format(CannotTestStorProcMsg, [AProcName]);
end;

{-------------------------------------------------------------------------------}
function WrongValueInParam(const APar, AGot, AExp: String): String;
begin
  Result := Format(WrongValueInParamMsg, [APar, AGot, AExp]);
end;

{-------------------------------------------------------------------------------}
function ErrorOnClearTbRows(AExcMsg: String): String;
begin
  Result := Format(ErrorOnClearTbRowsMsg, [AExcMsg]);
end;

{-------------------------------------------------------------------------------}
function ErrorOnTbReset(AExcMsg: String): String;
begin
  Result := Format(ErrorOnTbResetMsg, [AExcMsg]);
end;

{-------------------------------------------------------------------------------}
function ReadingFails(const AColName, AExcMsg: String): String;
begin
  Result := Format(ReadingFailsMsg, [AColName, AExcMsg]);
end;

{-------------------------------------------------------------------------------}
function EscapeFuncFails(const AFunName, AGot, AExp: String): String;
begin
  Result := Format(EscapeFuncFailsMsg, [AFunName, AGot, AExp]);
end;

{-------------------------------------------------------------------------------}
function AggregateError(const AKind, ACol, AV1, AV2: String): String;
begin
  Result := Format(AggregateErrorMsg, [AKind, ACol, AV1, AV2]);
end;

{-------------------------------------------------------------------------------}
function AggregateError(const AKind, ACol, AReason: String): String;
begin
  Result := Format(AggregateError2Msg, [AKind, ACol, AReason]);
end;

{-------------------------------------------------------------------------------}
function ComputeError(const AKind, AV1, AV2: String): String;
begin
  Result := Format(ComputeErrorMsg, [AKind, AV1, AV2]);
end;

{-------------------------------------------------------------------------------}
function ComputeError(const AKind, AReason: String): String;
begin
  Result := Format(ComputeError2Msg, [AKind, AReason]);
end;

{-------------------------------------------------------------------------------}
function WrongValueInCalcCol(const AV1, AV2, AT1, AT2: String): String;
begin
  Result := Format(WrongValueInCalcColMsg, [AV1, AV2, AT1, AT2]);
end;

{-------------------------------------------------------------------------------}
function AcceptingFails(const AWhere, AMsg: String): String;
begin
  Result := Format(AcceptingFailsMsg, [AWhere, AMsg]);
end;

{-------------------------------------------------------------------------------}
function RejectingFails(const AWhere, AMsg: String): String;
begin
  Result := Format(RejectingFailsMsg, [AWhere, AMsg]);
end;

{-------------------------------------------------------------------------------}
function ComparingRowFails(const AMsg: String): String;
begin
  Result := Format(ComparingRowFailsMsg, [AMsg]);
end;

{-------------------------------------------------------------------------------}
function SearchFails(const AColName: String): String;
begin
  Result := Format(SearchFailsMsg, [AColName]);
end;

{-------------------------------------------------------------------------------}
function ErrorOnExecFind(const AExcMsg: String): String;
begin
  Result := Format(ErrorOnExecFindMsg, [AExcMsg]);
end;

{-------------------------------------------------------------------------------}
function RowFiltFails(const AV1, ASign, AV2: String): String;
begin
  Result := Format(RowFiltFailsMsg, [AV1, ASign, AV2]);
end;

{-------------------------------------------------------------------------------}
function RowStFiltFails(const AState: String): String;
begin
  Result := Format(RowStFiltFailsMsg, [AState]);
end;

{-------------------------------------------------------------------------------}
function SortingFails(const AIn, ADesc, AWide, AS1, AS2: String): String;
begin
  Result := Format(SortingFailsMsg, [AIn, ADesc, AWide, AS1, AS2]);
end;

{-------------------------------------------------------------------------------}
function SortingFails(const ADesc, AV1, ASign, AV2: String): String;
begin
  Result := Format(SortingFails2Msg, [ADesc, AV1, ASign, AV2]);
end;

{-------------------------------------------------------------------------------}
function ErrorInColumn(const AColName, AExcMsg: String): String;
begin
  Result := Format(ErrorInColumnMsg, [AColName, AExcMsg]);
end;

{-------------------------------------------------------------------------------}
function ErrorOnReset(const AExcMsg: String): String;
begin
  Result := Format(ErrorOnResetMsg, [AExcMsg]);
end;

{-------------------------------------------------------------------------------}
function DefineError(const AWhat, AAs, ARDBMS: String): String;
begin
  Result := Format(DefineErrorMsg, [AWhat, AAs, ARDBMS]);
end;

{-------------------------------------------------------------------------------}
function FailedDataChange(const AHow: String): String;
begin
  Result := Format(FailedDataChangeMsg, [AHow]);
end;

{-------------------------------------------------------------------------------}
function FailedDataDelete(const AHow, AMsg: String): String;
begin
  Result := Format(FailedDataDeleteMsg, [AHow, AMsg]);
end;

{-------------------------------------------------------------------------------}
function FailedRestrOnParentData(const AWhat: String): String;
begin
  Result := Format(FailedRestrOnParentDataMsg, [AWhat]);
end;

{-------------------------------------------------------------------------------}
function FailedNullifData(const AWhat, AMsg: String): String;
begin
  Result := Format(FailedNullifDataMsg, [AWhat, AMsg]);
end;

{-------------------------------------------------------------------------------}
function FaildExcpWhereChildDel: String;
begin
  Result := FaildExcpWhereChildDelMsg;
end;

{-------------------------------------------------------------------------------}
function WrongCharsInBinary(const AColName, AMsg: String): String;
begin
  Result := Format(WrongCharsInBinaryMsg, [AColName, AMsg]);
end;

{-------------------------------------------------------------------------------}
function WrongExpectedCount(const AWhat, AWhere: String; ADef, AExp: Integer): String;
begin
  Result := Format(WrongExpectedCountMsg, [AWhat, ADef, AExp, AWhere]);
end;

{-------------------------------------------------------------------------------}
function VariantIsNull: String;
begin
  Result := VariantIsNullMsg;
end;

{-------------------------------------------------------------------------------}
function DuplUnIndexError: String;
begin
  Result := DuplUnIndexErrorMsg;
end;

{-------------------------------------------------------------------------------}
function UnIndexError: String;
begin
  Result := UnIndexErrorMsg;
end;

{-------------------------------------------------------------------------------}
function ErrorOnInsert(const ARDBMS, AExcMsg: String): String;
begin
  Result := Format(ErrorOnInsertMsg, [ARDBMS, AExcMsg]);
end;

{-------------------------------------------------------------------------------}
function ErrorCommPrepare(const ARDBMS, AExcMsg: String): String;
begin
  Result := Format(ErrorCommPrepareMsg, [ARDBMS, AExcMsg]);
end;

{-------------------------------------------------------------------------------}
function WrongBatchInserting(const AField, AV1, AV2: String): String;
begin
  Result := Format(WrongBatchInsertingMsg, [AField, AV1, AV2]);
end;

{-------------------------------------------------------------------------------}
function WrongBatchInsertCount: String;
begin
  Result := WrongBatchInsertCountMsg;
end;

{-------------------------------------------------------------------------------}
function ErrorBatchAffect(AGot, AExp: Integer): String;
begin
  Result := Format(ErrorBatchAffectMsg, [AGot, AExp]);
end;

{-------------------------------------------------------------------------------}
function ErrorOnMappingInsert(ASource, ATarget, AExcMsg: String): String;
begin
  Result := Format(ErrorOnMappingInsertMsg, [ASource, ATarget, AExcMsg]);
end;

{-------------------------------------------------------------------------------}
function WrongMappingInsert(ASource, ATarget, AExp, AGot: String): String;
begin
  Result := Format(WrongMappingInsertMsg, [ASource, ATarget, AGot, AExp]);
end;

{-------------------------------------------------------------------------------}
function WrongConvertData(ASource, ATarget, AV1, AV2: String): String;
begin
  Result := Format(WrongConvertDataMsg, [ASource, ATarget, AV2, AV1]);
end;

{-------------------------------------------------------------------------------}
function WrongConvertData(ASource, ATarget, AReason: String): String;
begin
  Result := Format(WrongConvertData2Msg, [ASource, ATarget, AReason]);
end;

{-------------------------------------------------------------------------------}
function WrongColumnCount(AExpect, AGot: Integer): String;
begin
  Result := Format(WrongColumnCountMsg, [AGot, AExpect]);
end;

{-------------------------------------------------------------------------------}
function WrongFieldCount(AExpect, AGot: Integer): String;
begin
  Result := Format(WrongFieldCountMsg, [AGot, AExpect]);
end;

{-------------------------------------------------------------------------------}
function WrongTableCount(AExpect, AGot: Integer): String;
begin
  Result := Format(WrongTableCountMsg, [AGot, AExpect]);
end;

{-------------------------------------------------------------------------------}
function WrongTableName(AExpect, AGot: String): String;
begin
  Result := Format(WrongTableNameMsg, [AGot, AExpect]);
end;

{-------------------------------------------------------------------------------}
function WrongRowCount(AExpect, AGot: Integer): String;
begin
  Result := Format(WrongRowCountMsg, [AGot, AExpect]);
end;

{-------------------------------------------------------------------------------}
function WrongColumnName(AExpect, AGot: String): String;
begin
  Result := Format(WrongColumnNameMsg, [AGot, AExpect]);
end;

{-------------------------------------------------------------------------------}
function WrongColumnType(ANum: Integer; AExpect, AGot: String): String;
begin
  Result := Format(WrongColumnTypeMsg, [ANum, AGot, AExpect]);
end;

{-------------------------------------------------------------------------------}
function ThereAreNoReqVal(AVal, ACol: String): String;
begin
  Result := Format(ThereAreNoReqValMsg, [AVal, ACol]);
end;

{-------------------------------------------------------------------------------}
function ThereAreUnexpVal(AVal, ACol: String): String;
begin
  Result := Format(ThereAreUnexpValMsg, [AVal, ACol]);
end;

{-------------------------------------------------------------------------------}
function ErrorMetaCommPrepare(AExcMes: String): String;
begin
  Result := Format(ErrorMetaCommPrepareMsg, [AExcMes]);
end;

{-------------------------------------------------------------------------------}
function TableNotFound(AName: String): String;
begin
  Result := Format(TableNotFoundMsg, [AName]);
end;

{-------------------------------------------------------------------------------}
function WrongErrCount(AGot, AExpect: Integer): String;
begin
  Result := Format(WrongErrCountMsg, [AGot, AExpect]);
end;

{-------------------------------------------------------------------------------}
function DatSTableISNil: String;
begin
  Result := DatSTableISNilMsg;
end;

{-------------------------------------------------------------------------------}
function UpdateExecTimeBig(AGot, AExpect: Integer): String;
begin
  Result := Format(UpdateExecTimeBigMsg, [AGot, AExpect]);
end;

{-------------------------------------------------------------------------------}
function UpdateExecTimeSmall(AGot, AExpect: Integer): String;
begin
  Result := Format(UpdateExecTimeSmallMsg, [AGot, AExpect]);
end;

{-------------------------------------------------------------------------------}
function WrongCountOfUpdate(AGot, AExpect: Integer): String;
begin
  Result := Format(WrongCountOfUpdateMsg, [AGot, AExpect]);
end;

{-------------------------------------------------------------------------------}
function UpdateDuringTrans: String;
begin
  Result := UpdateDuringTransMsg;
end;

{-------------------------------------------------------------------------------}
function DontUpdateAfterTrans: String;
begin
  Result := DontUpdateAfterTransMsg;
end;

{-------------------------------------------------------------------------------}
function CntUpdatedRowsIsNull: String;
begin
  Result := CntUpdatedRowsIsNullMsg;
end;

{-------------------------------------------------------------------------------}
function CntErrOnUpdateIsWrong(AGot, AExp: Integer): String;
begin
  Result := Format(CntErrOnUpdateIsWrongMsg, [AGot, AExp]);
end;

{-------------------------------------------------------------------------------}
function ThereAreTwoUpdRows: String;
begin
  Result := ThereAreTwoUpdRowsMsg;
end;

{-------------------------------------------------------------------------------}
function ThereIsUnexpRow: String;
begin
  Result := ThereIsUnexpRowMsg;
end;

{-------------------------------------------------------------------------------}
function TransIsInactive: String;
begin
  Result := TransIsInactiveMsg;
end;

{-------------------------------------------------------------------------------}
function TransIsActive: String;
begin
  Result := TransIsActiveMsg;
end;

{-------------------------------------------------------------------------------}
function ErrorResultTrans: String;
begin
  Result := ErrorResultTransMsg;
end;

{-------------------------------------------------------------------------------}
function ConnectionDefAlreadyDel(AName: String): String;
begin
  Result := Format(ConnectionDefAlreadyDelMsg, [AName]);
end;

{-------------------------------------------------------------------------------}
function ConnectionDefIsNotLocked(AName: String): String;
begin
  Result := Format(ConnectionDefIsNotLockedMsg, [AName]);
end;

{-------------------------------------------------------------------------------}
function ConnectionDefNameDublicated(AName: String): String;
begin
  Result := Format(ConnectionDefNameIsDubMsg, [AName]);
end;

{-------------------------------------------------------------------------------}
function ConnectionDefNotLoaded: String;
begin
  Result := ConnectionDefsNotLoadedMsg;
end;

{-------------------------------------------------------------------------------}
function ConnectToErrBase: String;
begin
  Result := ConnectToErrBaseMsg;
end;

{-------------------------------------------------------------------------------}
function TheConnectionDefIsNotCleared: String;
begin
  Result := TheConnectionDefIsNotClearedMsg;
end;

{-------------------------------------------------------------------------------}
function EscapeFails(AEsc, AGot, AExpect: String): String;
begin
  Result := Format(EscapeFailsMsg, [AEsc, AGot, AExpect]);
end;

{-------------------------------------------------------------------------------}
function CancelDialogFails: String;
begin
  Result := CancelDialogFailsMsg;
end;

{-------------------------------------------------------------------------------}
function PoolingError(AT1, AT2: Integer): String;
begin
  Result := Format(PoolingErrorMsg, [AT1, AT2]);
end;

{-------------------------------------------------------------------------------}
function DidYouSee(AWhat: String): String;
begin
  Result := Format(DidYouSeeMsg, [AWhat]);
end;

{-------------------------------------------------------------------------------}
function SimpleQuestion: String;
begin
  Result := SimpleQuestionMsg;
end;

{-------------------------------------------------------------------------------}
function WrongParCount(AGot, AExp: Integer): String;
begin
  Result := Format(WrongParCountMsg, [AGot, AExp]);
end;

{-------------------------------------------------------------------------------}
function ThereAreNoParInReg(AWhat: String): String;
begin
  Result := Format(ThereAreNoParInRegMsg, [AWhat]);
end;

{-------------------------------------------------------------------------------}
function ThereAreNoParInIni(AWhat: String): String;
begin
  Result := Format(ThereAreNoParInIniMsg, [AWhat]);
end;

{-------------------------------------------------------------------------------}
function ExecAborted: String;
begin
  Result := ExecAbortedMsg;
end;

{-------------------------------------------------------------------------------}
function NoExcWithAsyncMode: String;
begin
  Result := NoExcWithAsyncModeMsg;
end;

{-------------------------------------------------------------------------------}
function StateIsNotWaited(AState, ARealSt: String): String;
begin
  Result := Format(StateIsNotWaitedMsg, [AState, ARealSt]);
end;

{-------------------------------------------------------------------------------}
function ParBindMode(APar, AExp, AGot: String): String;
begin
  Result := Format(ParBindModeMsg, [APar, AGot, AExp]);
end;

{-------------------------------------------------------------------------------}
function WrongParamName(AGot, AExp: String): String;
begin
  Result := Format(WrongParamNameMsg, [AGot, AExp]);
end;

{-------------------------------------------------------------------------------}
function WrongCountInactComm(AGot, AExp: Integer): String;
begin
  Result := Format(WrongCountInactCommMsg, [AGot, AExp]);
end;

{-------------------------------------------------------------------------------}
function WrongRowState(AGot, AExp: String; AComm: String = ''): String;
begin
  Result := Format(WrongRowStateMsg, [AGot, AExp, AComm]);
end;

{-------------------------------------------------------------------------------}
function UnsuppType(AType: String): String;
begin
  Result := Format(UnsuppTypeMsg, [AType]);
end;

{-------------------------------------------------------------------------------}
function ErrBorderLength(ALen: Integer; ACol, AExc: String): String;
begin
  Result := Format(ErrBorderLengthMsg, [ACol, ALen, AExc]);
end;

{-------------------------------------------------------------------------------}
function WrongWithBorderLength(ACol: String; ALen: Integer; AGot, AExp: String): String;
begin
  Result := Format(WrongWithBorderLengthMsg, [ACol, ALen, AGot, AExp]);
end;

{-------------------------------------------------------------------------------}
function ErrorOnUpdate(AGot, AExp: Integer): String;
begin
  Result := Format(ErrorOnUpdateMsg, [AGot, AExp]);
end;

{-------------------------------------------------------------------------------}
function NoExcRaised: String;
begin
  Result := NoExcRaisedMsg;
end;

{-------------------------------------------------------------------------------}
function WrongTypeCast(ASrc, daADest, AGot, AExp: String): String;
begin
  Result := Format(WrongTypeCastMsg, [ASrc, daADest, AGot, AExp]);
end;

{-------------------------------------------------------------------------------}
function WrongBlobData(AChar: String; APos: Integer; AComment: String = ''): String;
begin
  Result := Format(WrongBlobDataMsg, [AChar, APos, AComment]);
end;

{-------------------------------------------------------------------------------}
function ErrorOnWriteBlobData(ALen: Integer; AExp: String): String;
begin
  Result := Format(ErrorOnWriteBlobDataMsg, [ALen, AExp]);
end;

{-------------------------------------------------------------------------------}
function ErrorOnAbortFunction(AExp: String): String;
begin
  Result := Format(ErrorOnAbortFunctionMsg, [AExp]);
end;

{-------------------------------------------------------------------------------}
function ErrorOnUnprepFunction(AExp: String): String;
begin
  Result := Format(ErrorOnUnprepFunctionMsg, [AExp]);
end;

{-------------------------------------------------------------------------------}
function ErrorBatchExec(AExc: String): String;
begin
  Result := Format(ErrorBatchExecMsg, [AExc]);
end;

{-------------------------------------------------------------------------------}
function SearchFromBegin: String;
begin
  Result := SearchFromBeginMsg;
end;

{-------------------------------------------------------------------------------}
function TestNotFound(AName: String): String;
begin
  Result := Format(TestNotFoundMsg, [AName]);
end;

{-------------------------------------------------------------------------------}
function SetFieldValueError(AName: String): String;
begin
  Result := Format(SetFieldValueErrorMsg, [AName]);
end;

{-------------------------------------------------------------------------------}
function FieldIndexError(ANum: Integer): String;
begin
  Result := Format(FieldIndexErrorMsg, [ANum]);
end;

{-------------------------------------------------------------------------------}
function EmptyDSError(AExc: String): String;
begin
  Result := Format(EmptyDSErrorMsg, [AExc]);
end;

{-------------------------------------------------------------------------------}
function UniqueIndexError(AName: String): String;
begin
  Result := Format(UniqueIndexErrorMsg, [AName]);
end;

{-------------------------------------------------------------------------------}
function UnSelectIndexError(AName: String): String;
begin
  Result := Format(UnSelectIndexErrorMsg, [AName]);
end;

{-------------------------------------------------------------------------------}
function ActivateIndexError(AName, AExc: String): String;
begin
  Result := Format(ActivateIndexErrorMsg, [AName, AExc]);
end;

{-------------------------------------------------------------------------------}
function DescendIndexError(AName: String): String;
begin
  Result := Format(DescendIndexErrorMsg, [AName]);
end;

{-------------------------------------------------------------------------------}
function CaseInsensIndexError(AName: String): String;
begin
  Result := Format(CaseInsensIndexErrorMsg, [AName]);
end;

{-------------------------------------------------------------------------------}
function FindKeyError(AKey, AName: String): String;
begin
  Result := Format(FindKeyErrorMsg, [AKey, AName]);
end;

{-------------------------------------------------------------------------------}
function LocateError(const AFieldName: String): String;
begin
  Result := Format(LocateErrorMsg, [AFieldName]);
end;

{-------------------------------------------------------------------------------}
function LookupError(const AFieldName, ALooked, AExp: String): String;
begin
  Result := Format(LookupErrorMsg, [AFieldName, ALooked, AExp]);
end;

{-------------------------------------------------------------------------------}
function LocateWithOptionsError(const AFieldName: String;
  AOptions: TLocateOptions): String;

  function OptionsStr: String;
  const
    OptionNames: array[TLocateOption] of String = ('loCaseInsensitive', 'loPartialKey');
  begin
    Result := '';
    if loCaseInsensitive in AOptions then
      Result := OptionNames[loCaseInsensitive];
    if loPartialKey in AOptions then
      Result := OptionNames[loPartialKey];
    if (loCaseInsensitive in AOptions) and (loPartialKey in AOptions) then
      Result := OptionNames[loCaseInsensitive] + ', ' + OptionNames[loPartialKey];
  end;

begin
  Result := Format(LocateWithOptionsErrorMsg, [AFieldName, OptionsStr]);
end;

{-------------------------------------------------------------------------------}
function NavigationError(const AMethodName: String): String;
begin
  Result := Format(NavigationErrorMsg, [AMethodName]);
end;

{-------------------------------------------------------------------------------}
function FilterError(const AFieldName: String;
  AOptions: TFilterOptions): String;

  function OptionsStr: String;
  const
    OptionNames: array[TFilterOption] of String = ('foCaseInsensitive', 'foNoPartialCompare');
  begin
    Result := '';
    if foCaseInsensitive in AOptions then
      Result := OptionNames[foCaseInsensitive];
    if foNoPartialCompare in AOptions then
      Result := OptionNames[foNoPartialCompare];
    if (foNoPartialCompare in AOptions) and (foCaseInsensitive in AOptions) then
      Result := OptionNames[foNoPartialCompare] + ', ' + OptionNames[foCaseInsensitive];
  end;

begin
  Result := Format(FilterErrorMsg, [AFieldName, OptionsStr]);
end;

{-------------------------------------------------------------------------------}
function FilterCountError: String;
begin
  Result := FilterCountErrorMsg;
end;

{-------------------------------------------------------------------------------}
function CantCreateFilter(const AFieldName: String): String;
begin
  Result := Format(CantCreateFilterMsg, [AFieldName]);
end;

{-------------------------------------------------------------------------------}
function SetRangeError(const AFieldName, AIndexName: String): String;
begin
  Result := Format(SetRangeErrorMsg, [AFieldName, AIndexName]);
end;

{-------------------------------------------------------------------------------}
function CancelRangeError(const AFieldName, AIndexName: String): String;
begin
  Result := Format(CancelRangeErrorMsg, [AFieldName, AIndexName]);
end;

{-------------------------------------------------------------------------------}
function MasterDetailError(const AFieldName: String): String;
begin
  Result := Format(MasterDetailErrorMsg, [AFieldName]);
end;

{-------------------------------------------------------------------------------}
function AggregatesError(const AFieldName, AAggKindName, AIndexName: String): String;
begin
  Result := Format(AggregatesErrorMsg, [AFieldName, AAggKindName, AIndexName]);
end;

{-------------------------------------------------------------------------------}
function SaveLoadError: String;
begin
  Result := SaveLoadErrorMsg;
end;

{-------------------------------------------------------------------------------}
function CloneCursorError: String;
begin
  Result := CloneCursorErrorMsg;
end;

{-------------------------------------------------------------------------------}
function DefineFieldsError(const AErrorMsg: String): String;
begin
  Result := Format(DefineFieldsErrorMsg, [AErrorMsg]);
end;

{-------------------------------------------------------------------------------}
function DefineExistingFieldError: String;
begin
  Result := DefineExistingFieldErrorMsg;
end;

{-------------------------------------------------------------------------------}
function DefineSameFieldsError: String;
begin
  Result := DefineSameFieldsErrorMsg;
end;

{-------------------------------------------------------------------------------}
function AppendFCDSError(const AUpdateMethodName: String): String;
begin
  Result := Format(AppendFCDSErrorMsg, [AUpdateMethodName]);
end;

{-------------------------------------------------------------------------------}
function EditFCDSError(AList: TStrings): String;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to AList.Count - 1 do begin
    if Result <> '' then
      Result := Result + ', ';
    Result := Result + AList[i];
  end;
  Result := Format(EditFCDSErrorMsg, [Result]);
end;

{-------------------------------------------------------------------------------}
function ErrorOnQueryOpen(const AExc: String): String;
begin
  Result := Format(ErrorOnQueryOpenMsg, [AExc]);
end;

{-------------------------------------------------------------------------------}
function WrongFieldsCountInQuery(const AGot, AExp: Integer): String;
begin
  Result := Format(WrongFieldsCountInQueryMsg, [AGot, AExp]);
end;

{-------------------------------------------------------------------------------}
function WrongValInQryField(const AName, AGot, AExp: String): String;
begin
  Result := Format(WrongValInQryFieldMsg, [AName, AGot, AExp]);
end;

{-------------------------------------------------------------------------------}
function DSStateIsNotWaited(AState: String): String;
begin
  Result := Format(DSStateIsNotWaitedMsg, [AState]);
end;

{-------------------------------------------------------------------------------}
function WrongCountInactQry(AGot, AExp: Integer): String;
begin
  Result := Format(WrongCountInactQryMsg, [AGot, AExp]);
end;

{-------------------------------------------------------------------------------}
function ErrorsDuringApplyUpdates: String;
begin
  Result := ErrorsDuringApplyUpdatesMsg;
end;

{-------------------------------------------------------------------------------}
function CmdPreprError(AGot, AExp: String): String;
begin
  Result := Format(CmdPreprErrorMsg, [AGot, AExp]);
end;

{-------------------------------------------------------------------------------}
function WrongUpdatedVals(AGot, AExp: String): String;
begin
  Result := Format(WrongUpdatedValsMsg, [AGot, AExp]);
end;

{-------------------------------------------------------------------------------}
function WrongInsertedVals(ARecFrm, AGot, AExp, AComm: String): String;
begin
  Result := Format(WrongInsertedValsMsg, [ARecFrm, AGot, AExp, AComm]);
end;

{-------------------------------------------------------------------------------}
function FileIsEmpty: String;
begin
  Result := FileIsEmptyMsg;
end;

{-------------------------------------------------------------------------------}
function WrongField(AWhat, AWhere, AGot, AExp: String): String;
begin
  Result := Format(WrongFieldMsg, [AWhat, AWhere, AGot, AExp]);
end;

{-------------------------------------------------------------------------------}
function ErrorOnPumpExec(AExc, ACmnt1, ACmnt2: String): String;
begin
  Result := Format(ErrorOnPumpExecMsg, [AExc, ACmnt1, ACmnt2]);
end;

{-------------------------------------------------------------------------------}
function RecCountIsZero(AMsg: String): String;
begin
  Result := Format(RecCountIsZeroMsg, [AMsg]);
end;

{-------------------------------------------------------------------------------}
function FilesAreDiffer(AGot, AExp: String): String;
begin
  Result := Format(FilesAreDifferMsg, [AGot, AExp]);
end;

{-------------------------------------------------------------------------------}
function AllFieldsAreNull(AMsg, ACommnt: String): String;
begin
  Result := Format(AllFieldsAreNullMsg, [AMsg, ACommnt]);
end;

{-------------------------------------------------------------------------------}
function RecCountIsWrong(ARecForm: String; AGot, AExp: Integer; ACommnt: String): String;
begin
  Result := Format(RecCountIsWrongMsg, [ARecForm, AGot, AExp, ACommnt]);
end;

{-------------------------------------------------------------------------------}
function ObjIsNotFound(AObj, AMsg: String): String;
begin
  Result := Format(ObjIsNotFoundMsg, [AObj, AMsg]);
end;

{-------------------------------------------------------------------------------}
function ErrorLookupFields(AType, AGot, AExp: String): String;
begin
  Result := Format(ErrorLookupFieldsMsg, [AType, AGot, AExp]);
end;

{-------------------------------------------------------------------------------}
function ErrorOnField(AMsg, AType: String): String;
begin
  Result := Format(ErrorOnFieldMsg, [AMsg, AType]);
end;

{-------------------------------------------------------------------------------}
function FieldsDiffer(AName, AGot, AExp: String): String;
begin
  Result := Format(FieldsDifferMsg, [AName, AGot, AExp]);
end;

{-------------------------------------------------------------------------------}
function CalcFieldValNull(AResFld, AFld1, AFld2, AExpr: String): String;
begin
  Result := Format(CalcFieldValNullMsg, [AResFld, AFld1, AFld2, AExpr]);
end;

{-------------------------------------------------------------------------------}
function ErrorOnCalcField(AResFld, AFld1, AFld2, AExpr, AExcMsg: String): String;
begin
  Result := Format(ErrorOnCalcFieldMsg, [AResFld, AFld1, AFld2, AExpr, AExcMsg]);
end;

{-------------------------------------------------------------------------------}
function WrongCalcFieldValNull(AResFld, AGot, AExp, AFld1, AFld2, AExpr: String): String;
begin
  Result := Format(WrongCalcFieldValNullMsg, [AResFld, AGot, AExp, AFld1, AFld2, AExpr]);
end;

{-------------------------------------------------------------------------------}
function WrongTimestampAttr: String;
begin
  Result := WrongTimestampAttrMsg;
end;

// Conversion
{-------------------------------------------------------------------------------}
function StrToDate_Cast(const AStr: String): TDateTime;
var
  prevDateSeparator:   Char;
  prevShortDateFormat: String;
begin
  prevShortDateFormat := ShortDateFormat;
  prevDateSeparator   := DateSeparator;
  ShortDateFormat     := 'mm/dd/yyyy';
  DateSeparator       := '/';
  try
    Result := StrToDate(AStr);
  finally
    DateSeparator   := prevDateSeparator;
    ShortDateFormat := prevShortDateFormat;
  end;
end;

{-------------------------------------------------------------------------------}
function StrToTime_Cast(const AStr: String): TDateTime;
var
  prevShortTimeFormat: String;
begin
  prevShortTimeFormat := ShortTimeFormat;
  ShortTimeFormat := 'hh:mm:ss';
  try
    Result := StrToTime(AStr);
  finally
    ShortTimeFormat := prevShortTimeFormat;
  end;
end;

{-------------------------------------------------------------------------------}
function StrToDateTime_Cast(const AStr: String): TDateTime;
var
  prevDateSeparator:   Char;
  prevShortTimeFormat,
  prevShortDateFormat: String;
begin
  prevShortDateFormat := ShortDateFormat;
  prevShortTimeFormat := ShortTimeFormat;
  prevDateSeparator   := DateSeparator;
  ShortDateFormat := 'mm/dd/yyyy';
  ShortTimeFormat := 'hh:mm:ss';
  DateSeparator   := '/';
  try
    Result := StrToDateTime(AStr);
  finally
    DateSeparator := prevDateSeparator;
    ShortTimeFormat := prevShortTimeFormat;
    ShortDateFormat := prevShortDateFormat;
  end;
end;

{-------------------------------------------------------------------------------}
function StrToFloat_Cast(const AStr: String): Double;
var
  prevDecimalSeparator: Char;
begin
  prevDecimalSeparator := DecimalSeparator;
  DecimalSeparator := '.';
  try
    Result := StrToFloat(AStr);
  finally
    DecimalSeparator := prevDecimalSeparator;
  end;
end;

{-------------------------------------------------------------------------------}
function StrToCurrency_Cast(const AStr: String): Currency;
var
  prevDecimalSeparator: Char;
begin
  prevDecimalSeparator := DecimalSeparator;
  DecimalSeparator := '.';
  try
    Result := StrToCurr(AStr);
  finally
    DecimalSeparator := prevDecimalSeparator;
  end;
end;

{-------------------------------------------------------------------------------}
function StrToBcd_Cast(const AStr: String): TBcd;
begin
  ADStr2BCD(PChar(AStr), Length(AStr), Result, '.');
end;

{-------------------------------------------------------------------------------}
function StrToSQLTimeStamp_Cast(const AStr: String): TADSQLTimeStamp;
var
  D: TDateTime;
begin
  D := StrToDateTime_Cast(AStr);
  Result := ADDateTimeToSQLTimeStamp(D);
end;

{-------------------------------------------------------------------------------}
function VarToStr_Cast(const AValue: Variant): String;
var
  prevDecimalSeparator: Char;
{$IFNDEF AnyDAC_D6}
  i: Integer;
{$ENDIF}
begin
  prevDecimalSeparator := DecimalSeparator;
  DecimalSeparator := '.';
  try
    if VarType(AValue) = varCurrency then
      Result := CurrToStr(AValue)
{$IFNDEF AnyDAC_D6}
    else if TVarData(AValue).VType = varInt64 then
      Result := IntToStr(Decimal(AValue).lo64)
{$ENDIF}
    else
      Result := VarToStr(AValue);
{$IFNDEF AnyDAC_D6}
    if VarType(AValue) in [varCurrency, varDouble, varSingle] then begin
      i := Pos(prevDecimalSeparator, Result);
      if i > 0 then
        Result[i] := '.';
    end;
{$ENDIF}        
  finally
    DecimalSeparator := prevDecimalSeparator;
  end;
end;

{-------------------------------------------------------------------------------}
function VarToValue(const AValue, ADefault: Variant): Variant;
begin
  if VarIsNull(AValue) then
    Result := ADefault
  else
    Result := AValue;
end;

// Useful routines
{-------------------------------------------------------------------------------}
function EncodeName(ARDBMSKind: TADRDBMSKind; AName: String): String;
begin
  Result := LeftCommas[ARDBMSKind] + AName + RightCommas[ARDBMSKind];
end;

{-------------------------------------------------------------------------------}
function SumOp(V1, V2: Variant): Variant;
begin
  Result := V1 + V2;
end;

{-------------------------------------------------------------------------------}
function DeducOp(V1, V2: Variant): Variant;
begin
  Result := V1 - V2;
end;

{-------------------------------------------------------------------------------}
function MulOp(V1, V2: Variant): Variant;
begin
  Result := V1 * V2;
end;

{-------------------------------------------------------------------------------}
function DivOp(V1, V2: Variant): Variant;
begin
  ASSERT(V2 <> 0);
  Result := V1 / V2;
end;

{-------------------------------------------------------------------------------}
function AllCheckedInGroup(AChildNode: TTreeNode): Boolean;
var
  oNode: TTreeNode;
begin
  Result := True;
  oNode := AChildNode.Parent;
  if oNode = nil then begin
    Result := False;
    Exit;
  end;
  oNode := oNode.getFirstChild;
  while oNode <> nil do begin
    if oNode.StateIndex <> CHECKED then begin
      Result := False;
      Exit;
    end;
    oNode := oNode.getNextSibling;
  end;
end;

{-------------------------------------------------------------------------------}
function HasCheckedInGroup(AChildNode: TTreeNode): Boolean;
var
  oNode: TTreeNode;
begin
  Result := False;
  oNode := AChildNode.Parent;
  if oNode = nil then begin
    Result := False;
    Exit;
  end;
  oNode := oNode.getFirstChild;
  while oNode <> nil do begin
    if oNode.StateIndex <> UNCHECKED then begin
      Result := True;
      Exit;
    end;
    oNode := oNode.getNextSibling;
  end;
end;

{-------------------------------------------------------------------------------}
procedure CheckParGrayWhenCheck(ANode: TTreeNode);
begin
  if ANode = nil then
    Exit;
  if AllCheckedInGroup(ANode) then
    ANode.Parent.StateIndex := CHECKED
  else if ANode.Parent <> nil then
    ANode.Parent.StateIndex := GRAYED;
  CheckParGrayWhenCheck(ANode.Parent);
end;

{-------------------------------------------------------------------------------}
procedure CheckParGrayWhenUncheck(ANode: TTreeNode; AChild: TTreeNode = nil);
begin
  if ANode = nil then
    Exit;
  if HasCheckedInGroup(ANode) then
    ANode.Parent.StateIndex := GRAYED
  else if ANode.Parent <> nil then
    ANode.Parent.StateIndex := UNCHECKED;
  CheckParGrayWhenUncheck(ANode.Parent, ANode);
end;

{-------------------------------------------------------------------------------}
procedure ActivateDEManger;
begin
  if not ADManager.Active then
    ADManager.Active := True;
end;

{-------------------------------------------------------------------------------}
procedure OpenPhysManager;
begin
  if ADPhysManager.State = dmsInactive then
    ADPhysManager.Open;
end;

{-------------------------------------------------------------------------------}
procedure SetConnectionDefFileName(AFileName: String; AToDEManger: Boolean);
begin
  if not AToDEManger then
    ADPhysManager.ConnectionDefs.Storage.FileName := AFileName
  else
    ADManager.ConnectionDefs.Storage.FileName := AFileName;
end;

{-------------------------------------------------------------------------------}
function AnsiCompareStrA(const S1, S2: String): Integer;
var
  iLen: Integer;
begin
  iLen := Length(S1);
  if iLen > Length(S2) then
    iLen := Length(S2);
  Result := CompareString(LOCALE_USER_DEFAULT, SORT_STRINGSORT,
    PChar(S1), iLen, PChar(S2), iLen) - 2;
  if Result = 0 then
    if Length(S1) > Length(S2) then
      Result := 1
    else if Length(S1) < Length(S2) then
      Result := -1;
end;

{-------------------------------------------------------------------------------}
function AnsiCompareTextA(const S1, S2: String): Integer;
var
  iLen: Integer;
begin
  iLen := Length(S1);
  if iLen > Length(S2) then
    iLen := Length(S2);
  Result := CompareString(LOCALE_USER_DEFAULT, NORM_IGNORECASE or SORT_STRINGSORT,
    PChar(S1), iLen, PChar(S2), iLen) - 2;
  if Result = 0 then
    if Length(S1) > Length(S2) then
      Result := 1
    else if Length(S1) < Length(S2) then
      Result := -1;
end;

{-------------------------------------------------------------------------------}
function WideCompareStrA(const S1, S2: WideString): Integer;
var
  iLen: Integer;
begin
  iLen := Length(S1);
  if iLen > Length(S2) then
    iLen := Length(S2);
  Result := CompareStringW(LOCALE_USER_DEFAULT, SORT_STRINGSORT,
    PWideChar(S1), iLen, PWideChar(S2), iLen) - 2;
  if Result = 0 then
    if Length(S1) > Length(S2) then
      Result := 1
    else if Length(S1) < Length(S2) then
      Result := -1;
end;

{-------------------------------------------------------------------------------}
function WideCompareTextA(const S1, S2: WideString): Integer;
var
  iLen: Integer;
begin
  iLen := Length(S1);
  if iLen > Length(S2) then
    iLen := Length(S2);
  Result := CompareStringW(LOCALE_USER_DEFAULT, NORM_IGNORECASE or SORT_STRINGSORT,
    PWideChar(S1), iLen, PWideChar(S2), iLen) - 2;
  if Result = 0 then
    if Length(S1) > Length(S2) then
      Result := 1
    else if Length(S1) < Length(S2) then
      Result := -1;
end;

{-------------------------------------------------------------------------------}
procedure RefetchTable(AName: String; ATab: TADDatSTable; AComm: IADPhysCommand;
  AOrdBy: String = 'id');
begin
  with AComm do begin
    Prepare('select * from {id ' + AName + '} order by ' + AOrdBy);
    Define(ATab);
    Open;
    Fetch(ATab);
    Disconnect;
  end;
end;

{-------------------------------------------------------------------------------}
function GetConnectionDef(AKind: TADRDBMSKind): String;
begin
  Result := '';
  case AKind of
  mkOracle:   Result := ORACLE_CONN;
  mkMSSQL:    Result := MSSQL_CONN;
  mkMSAccess: Result := MSACCESS_CONN;
  mkMySQL:    Result := MYSQL_CONN;
  mkDB2:      Result := DB2_CONN;
  mkASA:      Result := ASA_CONN;
  end;
end;

{-------------------------------------------------------------------------------}
function GetDBMSName(AKind: TADRDBMSKind): String;
begin
  Result := '';
  case AKind of
  mkOracle:   Result := S_AD_OraId;
  mkMSSQL:    Result := S_AD_MSSQLId;
  mkMSAccess: Result := S_AD_MSAccId;
  mkMySQL:    Result := S_AD_MySQLId;
  mkDB2:      Result := S_AD_DB2Id;
  mkASA:      Result := S_AD_ASAId;
  mkADS:      Result := S_AD_ADSId;
  end;
end;

{-------------------------------------------------------------------------------}
function GetStringFromArray(V: Variant): String;
  var
    m: Integer;
    p: Pointer;
  begin
    m := VarArrayHighBound(V, 1) - VarArrayLowBound(V, 1) + 1;
    SetLength(Result, m);
    if m > 0 then begin
      p := VarArrayLock(V);
      try
        Move(p^, PChar(Result)^, m);
      finally
        VarArrayUnlock(V);
      end;
    end;
  end;

{-------------------------------------------------------------------------------}
function Compare(const V1, V2: Variant; AType: TFieldType = ftUnknown): Integer;
var
  s: String;

  function SimpleCompare(const V1, V2: Variant): Integer;
  var
    V1tmp, V2tmp: Variant;
{$IFNDEF AnyDAC_D6}
    liVal1, liVal2: Int64;
    iVal: Integer;
{$ENDIF}

    function Oppose(const V1, V2: Variant): Integer;
    begin
      Result := -10;
      if V1 > V2 then
        Result := 1
      else if V1 = V2 then
        Result := 0
      else if V1 < V2 then
        Result := -1;
    end;

  begin
{$IFNDEF AnyDAC_D6}
    if (TVarData(V1).VType in [varSmallint, varInteger, varInt64, varCurrency, varDouble]) and
       (TVarData(V2).VType in [varSmallint, varInteger, varInt64, varCurrency, varDouble]) then begin
      if TVarData(V1).VType = varInt64 then
        liVal1 := Decimal(V1).Lo64
      else if TVarData(V1).VType in [varCurrency, varDouble] then
        liVal1 := Trunc(V1)
      else begin
        iVal := V1;
        liVal1 := iVal;
      end;
      if TVarData(V2).VType = varInt64 then
        liVal2 := Decimal(V2).Lo64
      else if TVarData(V1).VType in [varCurrency, varDouble] then
        liVal2 := Trunc(V2)
      else begin
        iVal := V2;
        liVal2 := iVal;
      end;
      Result := -10;
      if liVal1 > liVal2 then
        Result := 1
      else if liVal1 = liVal2 then
        Result := 0
      else if liVal1 < liVal2 then
        Result := -1;
      Exit;
    end;
{$ENDIF}
{$IFDEF AnyDAC_D9}
    if VarIsFMTBcd(V1) or VarIsFMTBcd(V2) then begin
      Result := BcdCompare(VarToBcd(V1), VarToBcd(V2));
      if Result < 0 then
        Result := -1
      else if Result >0 then
        Result := 1;
      Exit;
    end;
{$ENDIF}
    case AType of
    ftString:     Result := AnsiCompareStrA(VarToStr(V1), VarToStr(V2));
    ftWideString: Result := WideCompareStrA(VarToStr(V1), VarToStr(V2));
{$IFDEF AnyDAC_D6}
    ftFMTBcd,
{$ENDIF}
    ftCurrency, ftBCD, ftFloat:
      begin
{$IFDEF AnyDAC_D6}
        if VarIsFMTBcd(V1) then
          V1tmp := BcdToDouble(VarToBcd(V1))
        else
          V1tmp := V1;
        if VarIsFMTBcd(V2) then
          V2tmp := BcdToDouble(VarToBcd(V2))
        else
          V2tmp := V2;
{$ELSE}
        V1tmp := V1;
        V2tmp := V2;
{$ENDIF}
        if Abs(V1tmp - V2tmp) <= 0.1 then
          Result := 0
        else
          Result := Oppose(V1tmp, V2tmp);
      end;
    ftLargeint:
      begin
        if VarType(V1) <> varInt64 then
{$IFDEF AnyDAC_D6}
          if VarType(V1) = VarFMTBcd then
            V1tmp := StrToInt64(BcdToStr(VarToBcd(V1)))
          else
{$ENDIF}
            V1tmp := VarAsType(V1, varInt64)
        else
          V1tmp := V1;
        if VarType(V2) <> varInt64 then
{$IFDEF AnyDAC_D6}
          if VarType(V2) = VarFMTBcd then
            V2tmp := StrToInt64(BcdToStr(VarToBcd(V2)))
          else
{$ENDIF}
            V2tmp := VarAsType(V2, varInt64)
        else
          V2tmp := V2;
        Result := Oppose(V1tmp, V2tmp);
      end;
    else
      Result := Oppose(V1, V2);
    end;
  end;

  function CheckBinary(const ABin, AStr: String): Integer;
  var
    i, j: Integer;
  begin
    Result := 1;
    if Length(AStr) <= Length(ABin) then begin
      i := Pos(AStr, ABin);
      if i > 0 then begin
        Result := 0;
        for j := Length(AStr) + 1 to Length(ABin) do
          if not(Byte(ABin[j]) in [0, Byte(' ')]) then begin
            Result := -1;
            break;
          end;
      end;
    end;
  end;

{$IFNDEF AnyDAC_D6}
  function RightStr(const AStr: String; ACount: Integer): String;
  begin
    Result := Copy(AStr, Length(AStr) - ACount + 1, ACount);
  end;
{$ENDIF}

begin
  Result := -10;
  if VarIsNull(V1) or VarIsNull(V2) then
    Exit;
  // bytestrings
  if VarIsArray(V1) and VarIsArray(V2) then begin
    Result := SimpleCompare(Trim(GetStringFromArray(V1)), Trim(GetStringFromArray(V2)));
    Exit;
  end;
  if VarIsArray(V1) or VarIsArray(V2) then begin
    if VarIsArray(V1) then
      Result := CheckBinary(GetStringFromArray(V1), VarToStr(V2))
    else
      Result := CheckBinary(GetStringFromArray(V2), VarToStr(V1)) * (-1);
  end  // guids
  else if ((VarType(V1) = varString) or (VarType(V1) = varOleStr)) and
          ((VarType(V2) = varString) or (VarType(V2) = varOleStr)) then begin
    if (RightStr(VarToStr(V1), 1) = '}') and (RightStr(VarToStr(V2), 1) = '}') then
      Result := SimpleCompare(V1, V2)
    else if RightStr(VarToStr(V1), 1) = '}' then begin
      s := Copy(VarToStr(V1), 2, Length(VarToStr(V1)) - 2);
      Result := SimpleCompare(s, V2);
    end
    else if RightStr(VarToStr(V2), 1) = '}' then begin
      s := Copy(VarToStr(V2), 2, Length(VarToStr(V2)) - 2);
      Result := SimpleCompare(V1, s);
    end
    else
      Result := SimpleCompare(Trim(V1), Trim(V2))
  end
  else
    Result := SimpleCompare(V1, V2);
end;

{-------------------------------------------------------------------------------}
function IsBooleanField(AFieldNum: Integer): Boolean;
begin
  Result := FldTypes[AFieldNum] = ftBoolean;
end;

{-------------------------------------------------------------------------------}
function IsStringField(AFieldNum: Integer): Boolean;
begin
  Result := FldTypes[AFieldNum] in [ftString, ftFixedChar, ftWideString];
end;

{-------------------------------------------------------------------------------}
function IsNonTextField(AFieldNum: Integer): Boolean;
begin
  Result := FldTypes[AFieldNum] in ftNonTextTypes;
end;

{-------------------------------------------------------------------------------}
function IsNumericField(AFieldNum: Integer): Boolean;
begin
  Result := FldTypes[AFieldNum] in [ftSmallint, ftInteger, ftWord, ftFloat,
    ftLargeint, {$IFDEF AnyDAC_D6} ftFMTBcd, {$ENDIF} ftCurrency, ftBcd, ftAutoInc];
end;

{-------------------------------------------------------------------------------}
function GetDefaultValue(AFieldNum: Integer; ATSasVar: Boolean): Variant;
var
  rDateTm: TDateTime;
begin
  case AFieldNum of
    0,
    11, 12,
    14, 15,
    16:     Result := Strings[4];
    17:     Result := WideStrings[4];
    4:      Result := True;
    8:      Result := Dates[0];
    9:      Result := Times[1];
    10:     Result := DateTimes[2];
    18:     Result := Guids[0];
    20:
      begin
        if not ATSasVar then begin
          rDateTm := ADSQLTimeStampToDateTime(TimeStamps[1]);
          Result := DateTimeToStr(rDateTm);
        end
        else
{$IFDEF AnyDAC_D6}
          VarSQLTimeStampCreate(Result, TimeStamps[1]);
{$ELSE}
          Result := ADSQLTimeStampToDateTime(TimeStamps[1]);
{$ENDIF}
      end;
    else    Result := 0;
  end;
end;

{-------------------------------------------------------------------------------}
procedure  GetRangeValue(AFieldNum: Integer; var AMin, AMax: Variant);
var
  V1, V2: Variant;
{$IFNDEF AnyDAC_D6}
  cr1, cr2: Currency;
{$ENDIF}

   procedure SetValues(NewMin, NewMax: Variant);
   begin
     AMin := NewMin;
     AMax := NewMax;
   end;

begin
  case AFieldNum of
    0,
    11, 12,
    14, 15,
    16:     SetValues(Strings[1], Strings[6]);
    17:     SetValues(WideStrings[1], WideStrings[6]);
    1:      SetValues(SmallInts[7], SmallInts[8]);
    2:      SetValues(Integers[1], Integers[3]);
    3:      SetValues(Words[6], Words[7]);
    4:      SetValues(True, True);
    5:      SetValues(Floats[1], Floats[8]);
    6:      SetValues(Currencies[0], Currencies[8]);
    7:      SetValues(Bcds[1], Bcds[0]);
    8:      SetValues(Dates[7], Dates[1]);
    9:      SetValues(Times[5], Times[8]);
    10:     SetValues(DateTimes[6], DateTimes[8]);
    13:     SetValues(AutoIncs[4], AutoIncs[7]);
    18:     SetValues(Guids[8], Guids[1]);
    19:
      begin
{$IFDEF AnyDAC_D6}
        SetValues(LargeInts[9], LargeInts[8]);
{$ELSE}
        TVarData(V1).VType := varInt64;
        Decimal(V1).lo64 := LargeInts[9];
        TVarData(V2).VType := varInt64;
        Decimal(V2).lo64 := LargeInts[8];
        SetValues(V1, V2);
{$ENDIF}
      end;
    20:
      begin
{$IFDEF AnyDAC_D6}
        VarSQLTimeStampCreate(V1, TimeStamps[2]);
        VarSQLTimeStampCreate(V2, TimeStamps[8]);
{$ELSE}
        V1 := ADSQLTimeStampToDateTime(TimeStamps[2]);
        V2 := ADSQLTimeStampToDateTime(TimeStamps[8]);
{$ENDIF}
        SetValues(V1, V2);
      end;
    21:
      begin
{$IFDEF AnyDAC_D6}
        V1 := VarFMTBcdCreate(FMTBcds[4]);
        V2 := VarFMTBcdCreate(FMTBcds[3]);
{$ELSE}
        BCDToCurr(FMTBcds[4], cr1);
        BCDToCurr(FMTBcds[3], cr2);
        V1 := cr1;
        V2 := cr2;
{$ENDIF}
        SetValues(V1, V2);
      end;
  end;
end;

{-------------------------------------------------------------------------------}
function GetMinValue(AFieldNum: Integer): Variant;
{$IFNDEF AnyDAC_D6}
var
  cr: Currency;
{$ENDIF}
begin
  case AFieldNum of
    0,
    11, 12,
    14, 15,
    16:     Result := Strings[0];
    17:     Result := WideStrings[9];
    1:      Result := SmallInts[5];
    2:      Result := Integers[7];
    3:      Result := Words[8];
    4:      Result := False;
    5:      Result := Floats[7];
    6:      Result := Currencies[9];
    7:      Result := Bcds[5];
    8:      Result := Dates[0];
    9:      Result := Times[0];
    10:     Result := DateTimes[1];
    13:     Result := AutoIncs[6];
    18:     Result := Guids[5];
    19:
      begin
{$IFDEF AnyDAC_D6}
        Result := LargeInts[4];
{$ELSE}
        TVarData(Result).VType := varInt64;
        Decimal(Result).lo64 := LargeInts[4];
{$ENDIF}
      end;
    20:
{$IFDEF AnyDAC_D6}
      VarSQLTimeStampCreate(Result, TimeStamps[7]);
{$ELSE}
      Result := ADSQLTimeStampToDateTime(TimeStamps[7]);
{$ENDIF}
    21:
      begin
{$IFDEF AnyDAC_D6}
        Result := VarFMTBcdCreate(FMTBcds[6]);
{$ELSE}
        BCDToCurr(FMTBcds[6], cr);
        Result := cr;
{$ENDIF}
      end;
  end;
end;

{-------------------------------------------------------------------------------}
function GetMaxValue(AFieldNum: Integer): Variant;
{$IFNDEF AnyDAC_D6}
var
  cr: Currency;
{$ENDIF}
begin
  case AFieldNum of
    0,
    11, 12,
    14, 15,
    16:     Result := Strings[9];
    17:     Result := WideStrings[5];
    1:      Result := SmallInts[6];
    2:      Result := Integers[8];
    3:      Result := Words[9];
    4:      Result := True;
    5:      Result := Floats[6];
    6:      Result := Currencies[2];
    7:      Result := Bcds[4];
    8:      Result := Dates[9];
    9:      Result := Times[4];
    10:     Result := DateTimes[9];
    13:     Result := AutoIncs[5];
    18:     Result := Guids[2];
    19:
      begin
{$IFDEF AnyDAC_D6}
        Result := LargeInts[3];
{$ELSE}
        TVarData(Result).VType := varInt64;
        Decimal(Result).lo64 := LargeInts[3];
{$ENDIF}
      end;
    20:
{$IFDEF AnyDAC_D6}
      VarSQLTimeStampCreate(Result, TimeStamps[9]);
{$ELSE}
      Result := ADSQLTimeStampToDateTime(TimeStamps[9]);
{$ENDIF}
    21:
      begin
{$IFDEF AnyDAC_D6}
        Result := VarFMTBcdCreate(FMTBcds[5]);
{$ELSE}
        BCDToCurr(FMTBcds[5], cr);
        Result := cr;
{$ENDIF}
      end;
  end;
end;

{-------------------------------------------------------------------------------}
function GetSumValue(AFieldNum: Integer): Variant;
var
  i: Integer;
{$IFDEF AnyDAC_D6}
  B1, B2: TBcd;
{$ELSE}
  cr1: Currency;
{$ENDIF}  
begin
  Result := 0;
  if IsNumericField(AFieldNum) then
    for i := 0 to RECORD_COUNT - 1 do
      case AFieldNum of
        1:  Result := Result + SmallInts[i];
        2:  Result := Result + Integers[i];
        3:  Result := Result + Words[i];
        5:  Result := Result + Floats[i];
        6:  Result := Result + Currencies[i];
        7:  Result := Result + Bcds[i];
        13: Result := Result + AutoIncs[i];
        19:
          begin
{$IFDEF AnyDAC_D6}
            Result := Result + LargeInts[i];
{$ELSE}
            TVarData(Result).VType := varInt64;
            Decimal(Result).lo64 := Decimal(Result).lo64 + LargeInts[i];
{$ENDIF}
          end;
        21:
          begin
{$IFDEF AnyDAC_D6}
            B1 := VarToBcd(Result);
            BcdAdd(FMTBcds[i], B1, B2);
            Result := VarFMTBcdCreate(B2);
{$ELSE}
            BCDToCurr(FMTBcds[i], cr1);
            Result := Result + cr1;
{$ENDIF}
          end;
      end;
end;

{-------------------------------------------------------------------------------}
function GetAggValue(AFieldNum: Integer): Variant;
{$IFDEF AnyDAC_D6}
var
  B1, B2: TBcd;
  prevDecimalSeparator: Char;
{$ENDIF}
begin
{$IFDEF AnyDAC_D6}
  if FldTypes[AFieldNum] = ftFMTBcd then begin
    B1 := VarToBcd(GetSumValue(AFieldNum));
    prevDecimalSeparator := DecimalSeparator;
    DecimalSeparator := '.';
    try
      BcdDivide(B1, RECORD_COUNT, B2);
    finally
      DecimalSeparator := prevDecimalSeparator;
    end;
    Result := VarFMTBcdCreate(B2);
  end
  else
{$ENDIF}
    Result := GetSumValue(AFieldNum) / RECORD_COUNT;
end;

{-------------------------------------------------------------------------------}
procedure SetFieldValue(AField: TField; const AValue: Variant);
var
{$IFNDEF AnyDAC_D6}
  i: Integer;
{$ELSE}
  s: String;
  b: TBCD;
{$ENDIF}
begin
{$IFDEF AnyDAC_D6}
  if AField.DataType = ftLargeint then
    TLargeIntField(AField).AsLargeInt := AValue
  else if AField.DataType = ftFMTBcd then begin
    s := VarToStr(AValue);
    ADStr2BCD(PChar(s), Length(s), b, DecimalSeparator);
    TFmtBCDField(AField).SetData(@b, True);
  end
  else if AField.DataType = ftBcd then
    TBCDField(AField).AsString := VarToStr(AValue)
{$ELSE}
  if AField.DataType = ftLargeint then
    if TVarData(AValue).VType = varInt64 then
      TLargeIntField(AField).AsLargeInt := Decimal(AValue).Lo64
    else begin
      i := AValue;
      TLargeIntField(AField).AsLargeInt := i;
    end
{$ENDIF}
  else
    AField.Value := AValue;
end;

{$IFNDEF AnyDAC_D6}
function GetEnvironmentVariable(const Name: string): string;
var
  Len: integer;
begin
  Result := '';
  Len := Windows.GetEnvironmentVariable(PChar(Name), nil, 0);
  if Len > 0 then
  begin
    SetLength(Result, Len - 1);
    Windows.GetEnvironmentVariable(PChar(Name), PChar(Result), Len);
  end;
end;
{$ENDIF}

end.
