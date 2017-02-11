{-------------------------------------------------------------------------------}
{ AnyDAC QA constants                                                           }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit ADQAConst;

interface

uses
  DB, SysUtils,
{$IFDEF AnyDAC_D6}
  FMTBcd, SQLTimSt,
{$ENDIF}  
  daADStanIntf, daADStanParam, daADStanConst, daADStanUtil,
  daADDatSManager,
  daADPhysIntf,
  daADCompDataMove;

resourcestring
  ThisGroupAddedMsg            = 'This group has already been added!';
  ErrorOnTestExecMsg           = 'Error [%s]. [%s]';
  ErrorTableDefineMsg          = 'Error on table defining or command opening in [%s] RDBMS. [%s]';
  ErrorOnSetParamValueMsg      = 'Error on setting value [%s] to parameter. [%s]';
  ErrorOnCommExecMsg           = 'Error on command executing in [%s] RDBMS. [%s]';
  MacroCountIsZeroMsg          = 'Macros count is zero. Macro data type is [%s].';
  MacroFailsMsg                = 'Macro fails on data type [%s] in [%s] RDBMS.';
  CannotContinueTestMsg        = 'Cann''t continue test executing.';
  ErrorFetchToTableMsg         = 'Error on fetching to table in [%s] RDBMS. [%s]';
  WrongValueInColumnMsg        = 'Wrong value in the column [%s] in [%s] RDBMS. Got [%s], expected [%s]';
  WrongValueInTableMsg         = 'Wrong value in the col [%s] in row [%d], table [%s]. Got [%s], expected [%s]';
  ErrorOnCompareValMsg         = 'Error on comparing values. Column [%s]. [%s]';
  ErrorOnInitParamArrayMsg     = 'Error on initializing array of params. [%s]';
  ErrorOnImportMsg             = 'Error on importing DatSView. Row[%d]';
  AutoIncFailsMsg              = 'Auto Incrementation fails.';
  RelationsFailsMsg            = 'Relation fails on column [%s].';
  ErrorGettingChildViewMsg     = 'Error on getting child view. Column [%s]. [%s]';
  ErrorOnInitMechMsg           = 'Error on initializing mechanism [%s]. [%s]';
  MechFailsMsg                 = 'Mechanism [%s] fails on column [%s]. [%s]';
  TypeMismErrorMsg             = 'Type mismatch error! Got [%s], expected [%s], param [%s]. Proc. [%s]';
  ParamCountIsZeroMsg          = 'There are no params defined after Prepare in proc. [%s]';
  WrongParamTypeMsg            = 'Wrong param type is obtained from proc! Got [%s], expected [%s]. [%s]';
  ErrorOnStorProcMsg           = 'Error on stor. proc. [%s]. [%s]';
  ErrorOnStorProcParamMsg      = 'Error on stor. proc. [%s], param or field [%s]. Got [%s], expected [%s]';
  CannotTestStorProcMsg        = 'Cann''t testing a procedure. [%s]';
  WrongValueInParamMsg         = 'Wrong value is in the param [%s]. Got [%s], expected [%s]';
  ErrorOnClearTbRowsMsg        = 'Error on clearing table rows. [%s]';
  ErrorOnTbResetMsg            = 'Error on table reseting. [%s]';
  ReadingFailsMsg              = 'Reading from table fails on column [%s]. [%s]';
  EscapeFuncFailsMsg           = 'Escape function [%s] fails. Got [%s], expected [%s]';
  AggregateErrorMsg            = 'Aggregate with [%s] kind on column [%s] does not work. [%s] <> [%s]';
  AggregateError2Msg           = 'Aggregate with [%s] kind on column [%s] does not work. %s';
  ComputeErrorMsg              = 'Compute [%s] fails. [%s] <> [%s]';
  ComputeError2Msg             = 'Compute [%s] fails. %s';
  WrongValueInCalcColMsg       = 'Wrong value in the calc. col.: result [%s] and prototype [%s]. Types in expr-n are [%s] and [%s]';
  AcceptingFailsMsg            = '[%s] accepting fails. [%s]';
  RejectingFailsMsg            = '[%s] rejecting fails. [%s]';
  ComparingRowFailsMsg         = 'Comparing fails. [%s]';
  MechFails2Msg                = 'Mechanism [%s] fails. Values [%s] %s [%s]';
  SearchFailsMsg               = 'Searching fails on column [%s]';
  ErrorOnExecFindMsg           = 'Error on executing method Find. [%s]';
  RowFiltFailsMsg              = 'Rowfilter fails. Values [%s] %s [%s]';
  RowStFiltFailsMsg            = 'RowStateFilter fails. State is [%s]';
  SortingFailsMsg              = 'Case %ssensitive %s sorting of %sstrings fails. [%s] <> [%s]';
  SortingFails2Msg             = 'Sorting of %s fails. [%s] [%s] [%s]';
  ErrorInColumnMsg             = 'Error in column [%s]. [%s]';
  ErrorOnResetMsg              = 'Error on DatS Manager reseting. [%s]';
  DefineErrorMsg               = '[%s] defined as [%s] in [%s] RDBMS.';
  FailedDataChangeMsg          = 'Failed [%s] data change.';
  FailedDataDeleteMsg          = 'Failed [%s] data delete. [%s]';
  FailedRestrOnParentDataMsg   = 'Failed restrict exception raised on parent data [%s]';
  FailedNullifDataMsg          = 'Failed nullify data [%s]. [%s]';
  FaildExcpWhereChildDelMsg    = 'Failed cascade exception raised on parent data delete';
  WrongCharsInBinaryMsg        = 'Wrong chars are in the binary, field [%s]! [%s]';
  WrongExpectedCountMsg        = 'Expected count of [%s] is wrong. Defined [%d], expected [%d]. [%s]';
  VariantIsNullMsg             = 'Variant is null!';
  DuplUnIndexErrorMsg          = 'Duplicate unique index error';
  UnIndexErrorMsg              = 'Unique index error';
  ErrorOnInsertMsg             = 'Error on inserting into RDBMS [%s]. [%s]';
  ErrorCommPrepareMsg          = 'Error command preparing in [%s] RDBMS. [%s]';
  ErrorMetaCommPrepareMsg      = 'Error Meta info command preparing or opening. [%s]';
  WrongBatchInsertingMsg       = 'Wrong values are in the table after batch executing in field [%s]. Got [%s], expected [%s]';
  WrongBatchInsertCountMsg     = 'Wrong count of rows is in the table after batch executing.';
  ErrorBatchAffectMsg          = 'Wrong count of affected rows is there. Got [%d], expected [%d]';
  ErrorBatchExecMsg            = 'Error on batch executing. [%s]';
  ErrorOnMappingInsertMsg      = 'Error on mapping insert. Source type [%s], target type [%s]. [%s]';
  WrongMappingInsertMsg        = 'Wrong values are in the base after inserting. Source type [%s], target type [%s]. Got [%s], expected [%s]';
  WrongConvertDataMsg          = 'Error converting data: source [%s], target [%s]. Got [%s], expected [%s]';
  WrongConvertData2Msg         = 'Error converting data: source [%s], target [%s]. %s';
  WrongColumnCountMsg          = 'Wrong columns'' count is in the table. Got [%d], expected [%d]';
  WrongFieldCountMsg           = 'Wrong fileds'' count is in the CDS. Got [%d], expected [%d]';
  WrongTableCountMsg           = 'Wrong tables'' count is in the DatS Manager. Got [%d], expected [%d]';
  WrongTableNameMsg            = 'Wrong table''s name is in the DatS Manager. Got [%s], expected [%s]';
  WrongRowCountMsg             = 'Wrong rows'' count is in the table. Got [%d], expected [%d]';
  WrongColumnNameMsg           = 'Wrong columns'' names are in the table. Got [%s], expected [%s]';
  WrongColumnTypeMsg           = 'Wrong column [%d] type is in the table. Got [%s], expected [%s]';
  ThereAreNoReqValMsg          = 'There are no requred values [%s] in column [%s]';
  ThereAreUnexpValMsg          = 'There are unexpected values [%s] in column [%s]';
  TableNotFoundMsg             = 'The table [%s] is not found';
  WrongValueInColumnMetaMsg    = 'Wrong! Column [%s], row [%d], table [%s], object [%s] in [%s] RDBMS. Got [%s], expected [%s]';
  WrongProcArgValueMetaMsg     = 'Wrong! Column [%s], arg [%s], table [%s], object [%s] in [%s] RDBMS. Got [%s], expected [%s]';
  WrongTypeValueMetaMsg        = 'Wrong! Column [%s], type [%s], table [%s], object [%s] in [%s] RDBMS. Got [%s], expected [%s]';
  WrongErrCountMsg             = 'Wrong errors count returned by Update func. Got [%d], expected [%d]';
  DatSTableISNilMsg            = 'DatSTable = nil';
  UpdateExecTimeBigMsg         = 'The time of method Update exec. is bigger then waited for. LockWait = False. Got [%d], expected [%d]';
  UpdateExecTimeSmallMsg       = 'The time of method Update exec. is smaller then waited for. . LockWait = True. Got [%d], expected [%d]';
  WrongCountOfUpdateMsg        = 'Wrong count of calling method Update. Got [%d], expected [%d]';
  UpdateDuringTransMsg         = 'The table was updated by Adapter(Query), but it had not make it. LockWait = False';
  DontUpdateAfterTransMsg      = 'The table was not updated by Adapter(Query) after the transaction. LockWait = True';
  CntUpdatedRowsIsNullMsg      = 'The count of the updated rows is zero';
  CntErrOnUpdateIsWrongMsg     = 'Wrong count of the errors during updating. Got [%d], expected [%d]';
  ThereAreTwoUpdRowsMsg        = 'There are two updated rows in the table instead one';
  ThereIsUnexpRowMsg           = 'There is unexpected row in the table';
  TransIsInactiveMsg           = 'The transaction is inactive';
  TransIsActiveMsg             = 'The transaction is active';
  ErrorResultTransMsg          = 'After the transaction there is no expected row in the table';
  ConnectionDefAlreadyDelMsg   = 'The connection definition [%s] has already been deleted';
  ConnectionDefIsNotLockedMsg  = 'The connection definition [%s] is not protected again changes while connection exists';
  ConnectionDefNameIsDubMsg    = 'The connection definition [%s] name is dublicated';
  ConnectionDefsNotLoadedMsg   = 'The connection definitions auto load feature does not work';
  ConnectToErrBaseMsg          = 'It has been connected to erronious base';
  TheConnectionDefIsNotClearedMsg
                               = 'The connection definition is not cleared';
  EscapeFailsMsg               = 'Escape [%s] fails. Got [%s], expected [%s]';
  CancelDialogFailsMsg         = 'Cancel dialog is invisible';
  PoolingErrorMsg              = 'Pooled = false: time = [%d]; Pooled = true: time = [%d]';
  DidYouSeeMsg                 = 'Did you see a [%s]?';
  SimpleQuestionMsg            = 'Simple question';
  WrongParCountMsg             = 'Wrong count of the params! Got [%d], expected [%d]';
  ThereAreNoParInRegMsg        = 'There are no params in the registry!. [%s]';
  ThereAreNoParInIniMsg        = 'There are no params in the ini file!. [%s]';
  ExecAbortedMsg               = 'Executing was aborted by user!';
  NoExcWithAsyncModeMsg        = 'There is no exception in async mode!';
  StateIsNotWaitedMsg          = 'The command state isn''t [%s]. Real is [%s]';
  ParBindModeMsg               = 'Param bind mode [%s] fail. Got [%s], expected [%s]';
  WrongParamNameMsg            = 'Wrong param name is in the command interface. Got [%s], expected [%s]';
  WrongCountInactCommMsg       = 'Wrong count of inactive commands is. Got [%d], expected [%d]';
  WrongRowStateMsg             = 'Wrong row''s state. Got [%s], expected [%s]. [%s]';
  UnsuppTypeMsg                = 'The type [%s] is unsupported!';
  ErrBorderLengthMsg           = 'Error on "insert" excecuting, columns [%s]. Length is [%d]. [%s]';
  WrongWithBorderLengthMsg     = 'Wrong value is in the base, column [%s]. Length is [%d]. Got [%s], expected [%s]';
  ErrorOnUpdateMsg             = 'There is unexpected count of errors on updating by adapter(query) or manager of adapters. Got [%d], expected [%d]';
  NoExcRaisedMsg               = 'There is no expected exception raising!';
  WrongTypeCastMsg             = 'Wrong type casting: src type [%s], dest type [%s]. Got [%s], expected [%s]';
  WrongBlobDataMsg             = 'Wrong symbol [%s] has [%d] position. [%s]';
  WrongBlobDataMsg2            = 'The BLOB must be NULL';
  WrongBlobDataMsg3            = 'The BLOB length mismatch. Got [%d], expected [%d]';
  ErrorOnWriteBlobDataMsg      = 'Error on writing blob data. Length [%d]. [%s]';
  ErrorOnAbortFunctionMsg      = 'Error during Abort func. [%s]';
  ErrorOnUnprepFunctionMsg     = 'Error during Unprepare func. [%s]';
  SearchFromBeginMsg           = 'Would you like continue the search from beginning?';
  TestNotFoundMsg              = 'The test name like [%s] is not found!';
  SetFieldValueErrorMsg        = 'Value of [%s] field was set with error';
  FieldIndexErrorMsg           = 'Field index [%d] is out of bounds';
  EmptyDSErrorMsg              = 'Dataset was emptied with error. [%s]';
  UniqueIndexErrorMsg          = 'Unique index [%s] does not work';
  UnSelectIndexErrorMsg        = 'Record count has been changed after unselected index [%s]';
  ActivateIndexErrorMsg        = 'Can not activate index [%s]. [%s]';
  DescendIndexErrorMsg         = 'Descending index [%s] does not work';
  CaseInsensIndexErrorMsg      = 'CaseInsensivity index [%s] does not work';
  FindKeyErrorMsg              = 'Search on [%s] key field using [%s] index does not work';
  LocateWithOptionsErrorMsg    = 'Locate on [%s] field found wrong record. Options: [%s]';
  LocateErrorMsg               = 'Locate on [%s] field(s) failed';
  LookupErrorMsg               = 'Lookup on [%s] field(s) failed. Looked up [%s], expected [%s]';
  LocRecPosChangedErrorMsg     = 'Position after lookup / unsucc. locate changed';
  NavigationErrorMsg           = 'Navigation method [%s] does not work';
  FilterErrorMsg               = 'Filter on [%s] field does not work. Options: [%s]';
  FilterCountErrorMsg          = 'Reading FilterCount property changed current dataset position';
  CantCreateFilterMsg          = 'Can not create filter on [%s] field';
  SetRangeErrorMsg             = 'Ranging on [%s] field with [%s] index does not work';
  CancelRangeErrorMsg          = 'Cancel of ranging on [%s] field with [%s] index does not work';
  MasterDetailErrorMsg         = 'Master-detail filter on [%s] field does not work';
  AggregatesErrorMsg           = 'Aggregate with [%s] kind on field [%s] using [%s] index does not work';
  SaveLoadErrorMsg             = 'Save dataset to string and load from one faild';
  CloneCursorErrorMsg          = 'Cursor cloning is failed';
  DefineFieldsErrorMsg         = 'Can not open dataset after fields definition. Error: %s';
  DefineExistingFieldErrorMsg  = 'Dataset allows to add a field with already existing name';
  DefineSameFieldsErrorMsg     = 'Dataset allows to add two fields with the same definitions';
  AppendFCDSErrorMsg           = 'Incorrect appending records to dataset. UpdateMethod = %s';
  EditFCDSErrorMsg             = 'Incorrect editing fields: [%s]';
  ErrorOnQueryOpenMsg          = 'Error on TADQuery open. [%s]';
  WrongFieldsCountInQueryMsg   = 'There is wrong fields count in TADQuery. Got [%d], expected [%d]';
  WrongValInQryFieldMsg        = 'Wrong value in field [%s]. Got [%s], expected [%s]';
  DSStateIsNotWaitedMsg        = 'The DataSet''s state isn''t [%s]';
  WrongCountInactQryMsg        = 'Wrong count of inactive queries is. Got [%d], expected [%d]';
  ErrorsDuringApplyUpdatesMsg  = 'Count of errors during ApplyUpdates > 0';
  CmdPreprErrorMsg             = 'Command Preprocessor error. Got [%s], expected [%s]';
  WrongUpdatedValsMsg          = 'Wrong values after update by UpdateSQL. Got [%s], expected [%s]';
  WrongInsertedValsMsg         = 'Fields differ, rec. format is [%s]. Got [%s], expected [%s]. [%s]';
  FileIsEmptyMsg               = 'ASCII file is empty after moving data';
  WrongFieldMsg                = 'Wrong field [%s] in [%s] after moving data. Got [%s], expected [%s]';
  ErrorOnPumpExecMsg           = 'Error [%s] on moving data, rec. format is [%s]. [%s]';
  RecCountIsZeroMsg            = 'Record (rows) count is 0. [%s]';
  FilesAreDifferMsg            = 'Files differ. Got [' + C_AD_EOL + '%s' + C_AD_EOL + '],' + C_AD_EOL + ' expected [' + C_AD_EOL + '%s' + C_AD_EOL + ']';
  AllFieldsAreNullMsg          = 'All fields in the record are Null, rec. format is [%s]. [%s]';
  RecCountIsWrongMsg           = 'Record count is wrong, rec. format is [%s]. Got [%d], expected [%d]. [%s]';
  ObjIsNotFoundMsg             = 'Object [%s] is not found. [%s]';
  ErrorLookupFieldsMsg         = 'Error on look up fields. Type [%s]. Values: got [%s], expected [%s]';
  ErrorOnFieldMsg              = 'Error [%s] on field [%s]';
  FieldsDifferMsg              = 'Wrong value of field [%s]. Got [%s], expected [%s]';
  WrongCalcFieldValNullMsg     = 'Wrong val. of calc. field [%s]. Got [%s], expected [%s]. Fields in expr: [%s] and [%s]. Expr: [%s]';
  CalcFieldValNullMsg          = 'Calc. field [%s] is null. Fields in expr: [%s] and [%s]. Expr: [%s]';
  ErrorOnCalcFieldMsg          = 'Error on calc. field [%s]. Fields in expr: [%s] and [%s]. Expr: [%s]. [%s]';
  WrongTimestampAttrMsg        = 'Timestamp column has not AllowNull attribute';

type
  TFunc      = function(ACol, ARowID: Integer; ATab: TADDatSTable = nil): Variant of object;
  TFuncGroup = function(ACol, ARowID, AGroupLevel: Integer; ATab: TADDatSTable = nil): Variant of object;
  TOp        = function(V1, V2: Variant): Variant;

const
  // common consts
  OK_INDEX      = 0;
  FAILURE_INDEX = 1;
  EXEC_INDEX    = 4;
  OK_MSG        = 'Ok.';

  CHECKED   = 1;
  UNCHECKED = 2;
  GRAYED    = 3;

  CONN_DEF_STORAGE = '$(ADHOME)\DB\ADConnectionDefs.ini';

  SelectFromStmt  = 'select * from {id %s}';
  SelectFieldStmt = 'select %s from {id %s}';
  DeleteFromStmt  = 'delete from {id %s}';
  InsertIntoStmt  = 'insert into {id %s}(%s) values(:%s)';

  AggKindNames:   array [TADAggregateKind] of String = ('Sum', 'Avg', 'Count', 'Min', 'Max', 'TFirst' , 'TLast');

  RightCommas:    array [TADRDBMSKind] of String = ('', '"', ']', ']', '`', '"', '"', '"', '');
  LeftCommas:     array [TADRDBMSKind] of String = ('', '"', '[', '[', '`', '"', '"', '"', '');

  ADDataTypesNames: array [TADDataType] of String = ('dtUnknown', 'dtBoolean', 'dtSByte',
    'dtInt16', 'dtInt32', 'dtInt64', 'dtByte', 'dtUInt16', 'dtUInt32', 'dtUInt64', 'dtDouble',
    'dtCurrency', 'dtBCD', 'dtFmtBCD', 'dtDateTime', 'dtTime', 'dtDate', 'dtDateTimeStamp', 'dtAnsiString',
    'dtWideString', 'dtByteString', 'dtBlob', 'dtMemo', 'dtWideMemo', 'dtHBlob', 'dtHMemo', 'dtWideHMemo',
    'dtHBFile', 'dtRowSetRef', 'dtCursorRef', 'dtRowRef', 'dtArrayRef', 'dtParentRowRef', 'dtGUID', 'dtObject');

  FldTypeNames:   array [TFieldType] of string = ('ftUnknown', 'ftString', 'ftSmallInt', 'ftInteger',
    'ftWord', 'ftBoolean', 'ftFloat', 'ftCurrency', 'ftBCD', 'ftDate', 'ftTime',
    'ftDateTime', 'ftBytes', 'ftVarBytes', 'ftAutoInc', 'ftBlob', 'ftMemo', 'ftGraphic', 'ftFmtMemo',
    'ftParadoxOle', 'ftDBaseOle', 'ftTypedBinary', 'ftCursor', 'ftFixedChar', 'ftWideString',
    'ftLargeint', 'ftADT', 'ftArray', 'ftReference', 'ftDataSet', 'ftOraBlob', 'ftOraClob',
    'ftVariant', 'ftInterface', 'ftIDispatch', 'ftGuid'
{$IFDEF AnyDAC_D6}
    , 'ftTimeStamp', 'ftFMTBcd'
  {$IFDEF AnyDAC_D10}
    ,'ftFixedWideChar', 'ftWideMemo', 'ftOraTimeStamp', 'ftOraInterval'
  {$ENDIF}
{$ENDIF}    
    );

  RowVersions:    array [TADDatSRowVersion] of String = ('rvDefault', 'rvCurrent', 'rvOriginal', 'rvPrevious', 'rvProposed');
  RowsStates:     array [TADDatSRowState] of String = ('rsInitializing', 'rsDetached', 'rsInserted', 'rsDeleted',
    'rsModified', 'rsUnchanged', 'rsEditing', 'rsCalculating', 'rsChecking', 'rsDestroying', 'rsForceWrite',
    'rsImportingCurent', 'rsImportingOriginal', 'rsImportingProposed');

  ParamBindModes: array [TADParamBindMode] of String = ('pbByName', 'pbByNumber');
  CommandState:   array [TADPhysCommandState] of String = ('csInactive', 'csPrepared', 'csExecuting', 'csOpen',
    'csFetching', 'csAborting');

  UpdateReq:      array [TADPhysUpdateRequest] of String = ('arInsert', 'arUpdate', 'arDelete',
    'arLock', 'arUnlock', 'arFetchRow', 'arUpdateHBlobs', 'arDeleteAll');

  MacroTypes:     array [TADMacroDataType] of String = ('mdUnknown', 'mdString', 'mdIdentifier', 'mdInteger',
    'mdBoolean', 'mdFloat', 'mdDate', 'mdTime', 'mdDateTime', 'mdRaw');

  ParamTypes:     array [TParamType] of String = ('ptUnknown', 'ptInput', 'ptOutput', 'ptInputOutput', 'ptResult');
  ObjScopes:      array [TADPhysObjectScope] of String = ('osMy', 'osOther', 'osSystem');
  SmallInts:      array [0..9] of SmallInt = (23, 1, -456, 567,
    -6789, -7890, 23456, 0, 9012, 12345);

  ShortInts:      array [0..9] of ShortInt = (23, 1, -126, 127,
    -89, -1, 43, 0, 12, 100);

  Integers:       array [0..9] of Integer = (123456, -234567, -345678,
    4567890, -5678901, 0, 789012345, -890123456, 1234567890, -21451);

  Int64s:         array [0..9] of Int64 = (1234567890123456789, -1234567890123456789, -1,
    3490224567890, -56782452901, 0, 222521613131313, -9999999999999999, 1234567890, -23633636331451);

  Bytes2:         array [0..9] of Byte = (0, 89, 200, 56, 24, 10, 61, 149, 255, 151);
  Words:          array [0..9] of Word = (6789, 7890, 8901, 23, 1, 456,
    567, 9012, 0, 23456);

  LongWords:      array [0..9] of LongWord = (4294967295  , 78367390, 8901, 23, 1, 43366656,
    563333337, 9012, 0, 2);

  Booleans:       array [0..9] of Boolean = (False, False, False, True,
    False, False, False, False, False, False);

  Floats_str:     array [0..9] of string = ('1.234567', '-2.3456789', '34.56789',
    '-45.678901', '123456789.012345', '-234567890.0', '3456789012.345678',
    '-4567890123.456789', '56789.012345', '0.0');

  Currencies_str: array [0..9] of string = ('-1.0001', '0',
    '123456780123456.9999', '-23456.7891', '45.6789', '343.08', '8563434747.0343',
    '1111111.2222', '343434.5555', '-384348384.0');

  Bcds_str:       array [0..9] of string = ('34.56789', '-45.6789',
    '1.234567', '-2.3456', '3456789012.3456', '-4567890123.456789',
    '123456789.012345', '-234567890.0', '56789.012345', '0.0');

  Dates_str:      array [0..9] of string = ('12/31/1756', '02/03/2002',
    '12/05/1998', '11/10/1888', '10/05/1970', '09/05/1945', '12/06/1941',
    '07/12/1957', '09/09/1999', '04/07/2157');

  Times_str:      array [0..9] of string = ('00:00:00', '00:01:00',
    '01:34:55', '22:04:59', '23:59:59', '11:00:44', '15:01:34', '18:45:00',
    '18:45:01', '15:01:12');

  DateTimes_str:  array [0..9] of string = ('02/01/1752 00:00:00',
    '02/03/1751 00:01:00', '12/31/1755 01:30:55', '11/10/1888 22:04:59',
    '10/05/1970 23:59:59', '09/05/1945 11:01:00', '12/06/1941 15:01:34',
    '07/12/1957 18:45:00', '09/09/1999 18:45:01', '04/07/2157 15:01:12');

  Bytes:          array [0..9] of string = ('klmno1', 'vuwxy1', 'abcde',
    'pqrst', 'vuwxy', 'abcde1', 'ABCDE', 'fghij1', 'klmno', 'fghij');

  VarBytes:       array [0..9] of string = ('fghij1', 'vuwxy', 'klmno',
    'fghij', 'vuwxy1', 'klmno1', 'pqrst', 'abcde', 'abcde1', 'ABCDE');

  AutoIncs:       array [0..9] of Integer = (789012345, -890123456, 0,
   4567890, -5678901, 1234567890, -2145678901, 123456, -234567, -345678);

  Rowids:         array [0..9] of string = ('AAAIXCAAJAAAF6oAAA', 'AAAIXCAAJAAAF6oAAB',
    'AAAIXCAAJAAAF6oAAC', 'AAAIXCAAJAAAF6oAAD', 'AAAIXCAAJAAAF6oAAE', 'AAAIXCAAJAAAF6oAAF',
    'AAAIXCAAJAAAF6oAAG', 'AAAIXCAAJAAAF6oAAH', 'AAAIXCAAJAAAF6oAAI', 'AAAIXCAAJAAAF6oAAJ');

  Blobs:          array [0..9] of string = ('klmno', 'abcde1', 'ABCDE',
    'fghij', 'vuwxy1', 'klmno1', 'pqrst', 'fghij1', 'vuwxy', 'abcde');

  HBlobs:         array [0..9] of string = ('klmno', 'abcde1', 'ABCDE',
    'fghij', 'vuwxy1', 'klmno1', 'pqrst', 'fghij1', 'vuwxy', 'abcde');

  Memos:          array [0..9] of string = ('abcde1', 'ABCDE', 'vuwxy1',
    'fghij', 'klmno1', 'klmno', 'pqrst', 'fghij1', 'vuwxy', 'abcde');

  HMemos:         array [0..9] of string = ('abcde1', 'ABCDE', 'vuwxy1',
    'fghij', 'klmno1', 'klmno', 'pqrst', 'fghij1', 'vuwxy', 'abcde');

  FixedChars:     array [0..9] of string = ('fghij', 'abcde1', 'ABCDE',
    'klmno1', 'klmno', 'pqrst', 'fghij1', 'vuwxy', 'abcde', 'vuwxy1');

  Guids:          array [0..9] of string = (
   '{6E73D79B-8392-412E-8059-232318A0ECE0}', '{65E4128F-E7A7-4177-9CBE-9EC22956CDA8}',
   '{99999999-9999-9999-9999-999999999999}', '{3966D41F-0B84-4F5A-8538-ABD4109BFD18}',
   '{1C4F16B0-B04F-4DBC-ADBE-A7CFC8752389}', '{00000001-0001-0001-0001-000000000001}',
   '{36A69F2C-1D3B-4E34-9E39-9FFCE31933E7}', '{03F8CBA3-CB4F-42DE-BC98-A876DFE2B514}',
   '{1F6CA4E0-566E-4B6F-96D4-AF7BC6C98799}', '{5B3C1E34-C7B9-4F82-9A07-859D086131FD}');

  LargeInts:      array [0..9] of LargeInt = (0, 123456, -123456,
    123456789012345678, -234567890123456789, -5674236565636363, 5675675463,
    978867567566, 134364564, -298374658);

  TimeStamps_str: array [0..9] of string = ('10/05/1970 23:59:59',
    '11/10/1888 22:04:59', '09/05/1945 11:01:00', '07/12/1957 18:45:00',
    '02/03/2002 00:01:00', '12/06/1941 15:01:34', '12/05/1998 01:34:55',
    '01/01/1002 00:00:00', '09/09/1999 18:45:01', '04/07/2157 15:01:12');

  FMTBcds_str:    array [0..9] of String = ('-234567890.0', '56789.012345',
    '0.0', '34.56789', '-45.678901', '3456789012.345678', '-4567890123.456789',
    '123456789.012345', '1.234567', '-2.3456789');

  Strings:        array [0..9] of string = ('ABCDE', 'fghij', 'fghij1',
    'klmno', 'abcde', 'klmno1', 'pqrst', 'abcde1', 'vuwxy', 'vuwxy1');

  Randoms:        array [0..9] of Integer = (0, 6, 7, 2, 4, 1, 9, 3, 5, 8);
  Binary =        'klmnoklmnoklmnoklmnoklmnoklmnoklmnoklmno';

  // for DApt Layer
  NUM_WHERE = 3;
  C_ROW_CNT = 10;

  // for DatS Layer
  C_DELTA = 0.1;

  C_tBoolean       = 'dtBoolean';
  C_tSByte         = 'dtSByte';
  C_tInt16         = 'dtInt16';
  C_tInt32         = 'dtInt32';
  C_tInt64         = 'dtInt64';
  C_tByte          = 'dtByte';
  C_tUInt16        = 'dtUInt16';
  C_tUInt32        = 'dtUInt32';
  C_tUInt64        = 'dtUInt64';
  C_tDouble        = 'dtDouble';
  C_tCurrency      = 'dtCurrency';
  C_tBCD           = 'dtBCD';
  C_tFmtBCD        = 'dtFmtBCD';
  C_tDateTime      = 'dtDateTime';
  C_tTime          = 'dtTime';
  C_tDate          = 'dtDate';
  C_tDateTimeStamp = 'dtDateTimeStamp';
  C_tAnsiString    = 'dtAnsiString';
  C_tWideString    = 'dtWideString';
  C_tByteString    = 'dtByteString';
  C_tBlob          = 'dtBlob';
  C_tMemo          = 'dtMemo';
  C_tWideMemo      = 'dtWideMemo';
  C_tHBlob         = 'dtHBlob';
  C_tHMemo         = 'dtHMemo';
  C_tWideHMemo     = 'dtWideHMemo';
  C_tHBFile        = 'dtHBFile';
  C_tRowSetRef     = 'dtRowSetRef';
  C_tCursorRef     = 'dtCursorRef';
  C_tRowRef        = 'dtRowRef';
  C_tArrayRef      = 'dtArrayRef';
  C_tParentRowRef  = 'dtParentRowRef';
  C_tGUID          = 'dtGUID';

  // for Phys Layer
  C_RECNO             = 'RECNO';
  C_CATALOG_NAME      = 'CATALOG_NAME';
  C_SCHEMA_NAME       = 'SCHEMA_NAME';
  C_TABLE_NAME        = 'TABLE_NAME';
  C_TABLE_TYPE        = 'TABLE_TYPE';
  C_TABLE_SCOPE       = 'TABLE_SCOPE';
  C_COLUMN_NAME       = 'COLUMN_NAME';
  C_COLUMN_POSITION   = 'COLUMN_POSITION';
  C_COLUMN_DATATYPE   = 'COLUMN_DATATYPE';
  C_COLUMN_TYPENAME   = 'COLUMN_TYPENAME';
  C_COLUMN_ATTRIBUTES = 'COLUMN_ATTRIBUTES';
  C_COLUMN_PRECISION  = 'COLUMN_PRECISION';
  C_COLUMN_SCALE      = 'COLUMN_SCALE';
  C_COLUMN_LENGTH     = 'COLUMN_LENGTH';
  C_INDEX_NAME        = 'INDEX_NAME';
  C_PKEY_NAME         = 'PKEY_NAME';
  C_INDEX_TYPE        = 'INDEX_TYPE';
  C_SORT_ORDER        = 'SORT_ORDER';
  C_FILTER            = 'FILTER';
  C_PACKAGE_NAME      = 'PACKAGE_NAME';
  C_PACKAGE_SCOPE     = 'PACKAGE_SCOPE';
  C_PACK_NAME         = 'PACK_NAME';
  C_PROC_NAME         = 'PROC_NAME';
  C_PROC_TYPE         = 'PROC_TYPE';
  C_PROC_SCOPE        = 'PROC_SCOPE';
  C_IN_PARAMS         = 'IN_PARAMS';
  C_OUT_PARAMS        = 'OUT_PARAMS';
  C_OVERLOAD          = 'OVERLOAD';
  C_PARAM_NAME        = 'PARAM_NAME';
  C_PARAM_POSITION    = 'PARAM_POSITION';
  C_PARAM_TYPE        = 'PARAM_TYPE';
  C_PARAM_DATATYPE    = 'PARAM_DATATYPE';
  C_PARAM_TYPENAME    = 'PARAM_TYPENAME';
  C_PARAM_ATTRIBUTES  = 'PARAM_ATTRIBUTES';
  C_PARAM_PRECISION   = 'PARAM_PRECISION';
  C_PARAM_SCALE       = 'PARAM_SCALE';
  C_PARAM_LENGTH      = 'PARAM_LENGTH';

  // These are constants for Meta info command tests
  North_tab_cnt = 13;
  NorthWind: array[0..North_tab_cnt - 1] of String = ('Categories', 'CustomerCustomerDemo', 'CustomerDemographics',
      'Customers', 'Employees', 'EmployeeTerritories', 'Order Details', 'Orders', 'Products',
      'Region', 'Shippers', 'Suppliers', 'Territories');

  WildCardStr = '%ustom%';
  WildCardRes_cnt = 3;
  WildCardResult:
             array [0..WildCardRes_cnt - 1] of String = ('CustomerCustomerDemo', 'CustomerDemographics', 'Customers');

  Categ_field_name:
                   array [0..3] of String = ('Categoryid', 'CategoryName', 'Description', 'Picture');
  Categ_Types:     array [TADRDBMSKind, 0..3] of String =
      (('', '', '', ''), ('NUMBER', 'NVARCHAR2', 'LONG', 'BLOB'),
      ('int', 'nvarchar', 'ntext', 'image'), ('COUNTER', 'VARCHAR', 'LONGCHAR', 'LONGBINARY'),
      ('int(11)', 'varchar(15)', 'mediumtext', 'longblob'), ('INTEGER', 'VARGRAPHIC', 'LONG VARGRAPHIC', 'BLOB'),
      ('integer', 'varchar', 'long varchar', 'long binary'),
      ('', '', '', ''), ('', '', '', ''));

  Categ_DType:     array [TADRDBMSKind, 0..3] of Byte =    {'NUMBER', 'NVARCHAR2', 'LONG', 'BLOB'}
      ((0, 0, 0, 0),   (13, 19, 22, 24), (4, 19, 23, 21),
      (4, 18, 22, 21), (4, 18, 22, 21),  (4, 19, 23, 21),
      (4, 18, 22, 21),
      (0, 0, 0, 0), (0, 0, 0, 0));

  Categ_Col_attr:  array [TADRDBMSKind, 0..3] of Byte =    {'NUMBER', 'NVARCHAR2', 'LONG', 'BLOB'}
      ((0, 0, 0, 0),  ( 1, 1, 10, 10),  (1, 1, 10, 10),
      (1, 3, 10, 10), (35, 1, 10, 10),  (1, 1, 10, 10),
      (129, 129, 138, 138),
      (0, 0, 0, 0), (0, 0, 0, 0));

  Categ_Col_prec:  array [TADRDBMSKind, 0..3] of Byte =    {'NUMBER', 'NVARCHAR2', 'LONG', 'BLOB'}
      ((0, 0, 0, 0), (10, 0, 0, 0), (0, 0, 0, 0),
      (0, 0, 0, 0),  (0, 0, 0, 0),  (0, 0, 0, 0), (0, 0, 0, 0),
      (0, 0, 0, 0), (0, 0, 0, 0));

  Categ_Col_scal:  array [TADRDBMSKind, 0..3] of Byte =    {'NUMBER', 'NVARCHAR2', 'LONG', 'BLOB'}
      ((0, 0, 0, 0), (0, 0, 0, 0), (0, 0, 0, 0),
      (0, 0, 0, 0),  (0, 0, 0, 0), (0, 0, 0, 0), (0, 0, 0, 0),
      (0, 0, 0, 0), (0, 0, 0, 0));

  Categ_Col_len:   array [TADRDBMSKind, 0..3] of Integer = {'NUMBER', 'NVARCHAR2', 'LONG', 'BLOB'}
      ((0, 0, 0, 0), (0, 15, 0, 0), (0, 15, 0, 0),
      (0, 15, {2147483647}0, {2147483647}1073741823), (0, 15, 0, 0),
      (0, 15, 16350, 1048576), (0, 15, 0, 2000000000),
      (0, 0, 0, 0), (0, 0, 0, 0));

  OrdDet_field_name:
                   array [0..4] of String = ('OrderID', 'ProductID', 'UnitPrice', 'Quantity', 'Discount');
  OrdDet_Types:    array [TADRDBMSKind, 0..4] of String =
    (('', '', '', '', ''), ('NUMBER', 'NUMBER', 'NUMBER', 'NUMBER', 'FLOAT'),
    ('int', 'int', 'money', 'smallint', 'real'), ('INTEGER', 'INTEGER', 'CURRENCY', 'SMALLINT', 'REAL'),
    ('int(11)', 'int(11)', 'decimal(19,4)', 'smallint(6)', 'float'), ('INTEGER', 'INTEGER', 'DECIMAL', 'SMALLINT', 'REAL'),
    ('integer', 'integer', 'numeric', 'smallint', 'float'), ('', '', '', '', ''),
    ('', '', '', '', ''));

  OrdDet_DType:    array [TADRDBMSKind, 0..4] of Byte =              {'NUMBER', 'NUMBER', 'NUMBER', 'NUMBER', 'FLOAT'}
      ((0, 0, 0, 0, 0),  (13, 13, 13, 13, 10), (4, 4, 13, 3, 10),
      (4, 4, 12, 3, 10), (4, 4, 12, 3, 10),    (4, 4, 12, 3, 10),
      (4, 4, 12, 3, 10), (0, 0, 0, 0, 0), (0, 0, 0, 0, 0));

  OrdDet_Col_attr: array [TADRDBMSKind, 0..4] of Byte =              {'NUMBER', 'NUMBER', 'NUMBER', 'NUMBER', 'FLOAT'}
      ((0, 0, 0, 0, 0), (1, 1, 3, 129, 129),       (1, 1, 129, 129, 129),
      (3, 3, 3, 3, 3),  (129, 129, 129, 129, 129), (1, 1, 129, 129, 129),
      (129, 129, 129, 129, 129), (0, 0, 0, 0, 0), (0, 0, 0, 0, 0));

  OrdDet_Col_prec: array [TADRDBMSKind, 0..4] of Byte =              {'NUMBER', 'NUMBER', 'NUMBER', 'NUMBER', 'FLOAT'}
      ((0, 0, 0, 0, 0), (10, 10, 19, 5, 38), (0, 0, 19, 0, 8),
      (0, 0, 19, 0, 8), (0, 0, 19, 0, 0),    (0, 0, 19, 0, 8),
      (0, 0, 19, 0, 7), (0, 0, 0, 0, 0), (0, 0, 0, 0, 0));

  OrdDet_Col_scal: array [TADRDBMSKind, 0..4] of Byte =              {'NUMBER', 'NUMBER', 'NUMBER', 'NUMBER', 'FLOAT'}
      ((0, 0, 0, 0, 0), (0, 0, 4, 0, 0), (0, 0, 4, 0, 0),
      (0, 0, 4, 0, 0),  (0, 0, 4, 0, 0), (0, 0, 4, 0, 0),
      (0, 0, 4, 0, 0), (0, 0, 0, 0, 0), (0, 0, 0, 0, 0));

  OrdDet_Col_len:  array [TADRDBMSKind, 0..4] of Byte =              {'NUMBER', 'NUMBER', 'NUMBER', 'NUMBER', 'FLOAT'}
      ((0, 0, 0, 0, 0), (0, 0, 0, 0, 0), (0, 0, 0, 0, 0),
      (0, 0, 0, 0, 0),  (0, 0, 0, 0, 0), (0, 0, 0, 0, 0),
      (0, 0, 0, 0, 0), (0, 0, 0, 0, 0), (0, 0, 0, 0, 0));

  CustCustD_ind:   array [TADRDBMSKind, 0..4] of String =
      (('', '', '', '', ''),
      ('PK_CustomerCustomerDemo', 'I_CustCustDemo_CustomerID', 'I_CustCustDemo_CustomerTypeID', '', ''),
      ('PK_CustomerCustomerDemo', 'I_CustCustDemo_CustomerID', 'I_CustCustDemo_CustomerTypeID', '', ''),
      ('PK_CustomerCustomerDemo', 'FK_CCDemo_Customers', 'FK_CCDemo_Demogr', 'I_CustCustD_CustomerID', 'I_CustCustD_CustomerTypeID'),
      ('PRIMARY', 'I_CustCustDemo_CustomerID', 'I_CustCustDemo_CustomerTypeID', '', ''),
      ('PK_CustCustDemo', 'I_CustCustD_CsID', 'I_CustCustD_CsTyp', '', ''),
      ('PK_CustomerCustomerDemo', 'I_CustCustDemo_CustomerID', 'I_CustCustDemo_CustomerTypeID', '', ''),
      ('', '', '', '', ''), ('', '', '', '', ''));

  CustCustD_pkname:array [TADRDBMSKind] of String =
      ('', 'PK_CustomerCustomerDemo', 'PK_CustomerCustomerDemo', 'PK_CustomerCustomerDemo', 'PRIMARY', 'PK_CustCustDemo',
       'CustomerCustomerDemo', '', '');
  CustCustD_indtp: array [TADRDBMSKind, 0..4] of TADPhysIndexKind =
      ((ikNonUnique, ikNonUnique, ikNonUnique, ikNonUnique, ikNonUnique),    {mkNone}
      (ikPrimaryKey, ikNonUnique, ikNonUnique, ikNonUnique, ikNonUnique),    {mkOracle}
      (ikPrimaryKey, ikNonUnique, ikNonUnique, ikNonUnique, ikNonUnique),    {mkMSSQL}
      (ikPrimaryKey, ikNonUnique, ikNonUnique, ikNonUnique, ikNonUnique),    {mkMSAccess}
      (ikPrimaryKey, ikNonUnique, ikNonUnique, ikNonUnique, ikNonUnique),    {mkMySQL}
      (ikPrimaryKey, ikNonUnique, ikNonUnique, ikNonUnique, ikNonUnique),    {mkDb2}
      (ikPrimaryKey, ikNonUnique, ikNonUnique, ikNonUnique, ikNonUnique),    {mkASA}
      (ikNonUnique,  ikNonUnique, ikNonUnique, ikNonUnique, ikNonUnique),    {mkADS}
      (ikNonUnique,  ikNonUnique, ikNonUnique, ikNonUnique, ikNonUnique));   {mkNone}

  OrdDet_ind:      array [TADRDBMSKind, 0..4] of String =
      (('', '', '', '', ''),
      ('PK_OrderDetails', 'I_OrderDetails_OrderID', 'I_OrderDetails_ProductID', '', ''),
      ('PK_Order_Details', 'I_OrderDetails_OrderID', 'I_OrderDetails_ProductID', '', ''),
      ('PK_OrderDetails', 'FK_Order_Details_Orders', 'FK_Order_Details_Products', 'I_OrdDetails_OrdID', 'I_OrdDetails_ProdID'),
      ('PRIMARY', 'I_OrderDetails_OrderID', 'I_OrderDetails_ProductID', '', ''),
      ('PK_OrderDetails', 'I_OrdDet_OrderID', 'I_OrdDet_ProductID', '', ''),
      ('PK_OrderDetails', 'I_OrderDetails_OrderID', 'I_OrderDetails_ProductID', '', ''),
      ('', '', '', '', ''), ('', '', '', '', ''));

  OrdDet_pkname:   array [TADRDBMSKind] of String =
      ('', 'PK_OrderDetails', 'PK_Order_Details', 'PK_OrderDetails', 'PRIMARY', 'PK_OrderDetails',
       'Order Details', '', '');
  OrdDet_indtp:    array [TADRDBMSKind, 0..4] of TADPhysIndexKind =
      ((ikNonUnique, ikNonUnique, ikNonUnique, ikNonUnique, ikNonUnique),   {mkNone}
      (ikPrimaryKey, ikNonUnique, ikNonUnique, ikNonUnique, ikNonUnique),   {mkOracle}
      (ikPrimaryKey, ikNonUnique, ikNonUnique, ikNonUnique, ikNonUnique),   {mkMSSQL}
      (ikPrimaryKey, ikNonUnique, ikNonUnique, ikNonUnique, ikNonUnique),   {mkMSAccess}
      (ikPrimaryKey, ikNonUnique, ikNonUnique, ikNonUnique, ikNonUnique),   {mkMySQL}
      (ikPrimaryKey, ikNonUnique, ikNonUnique, ikNonUnique, ikNonUnique),   {mkDb2}
      (ikPrimaryKey, ikNonUnique, ikNonUnique, ikNonUnique, ikNonUnique),   {mkASA}
      (ikNonUnique,  ikNonUnique, ikNonUnique, ikNonUnique, ikNonUnique),   {mkADS}
      (ikNonUnique,  ikNonUnique, ikNonUnique, ikNonUnique, ikNonUnique));  {mkNone}

  CustCustD_colname:
                   array [0..1] of String = ('CustomerID', 'CustomerTypeID');
  Pack_name:       array [0..0] of String = ('ADQA_ALL_TYPES_PACK');
  CountOfOraProc   = 5;
  ProcWithoutPack: array [0..CountOfOraProc - 1] of String = ('ADQA_ALL_VALS', 'ADQA_ALL_VALUES',
      'ADQA_GET_VALUES', 'ADQA_OUTPARAM', 'ADQA_SET_VALUES');

  ProcPropWithoutPack:
                   array [0..CountOfOraProc - 1, 0..4] of Integer =                    {(Type, Scope, InParams, OutParams, Overl)}
      ((0, 0, 0, 0, 0), (0, 0, 0, 0, 0),
      (0, 0, 0, 0, 0),  (0, 0, 0, 0, 0), (0, 0, 0, 0, 0));

  ProcInPack:      array [0..1] of String = ('GET_VALUESF', 'GET_VALUESP');
  ProcPropInPack:  array [0..1, 0..4] of Integer = ((1, 0, 0, 1, 0), (0, 0, 0, 1, 0)); {(Type, Scope, InParams, OutParams, Overl)}
  CountOfMSSQLProc = 2;
  ProcInMSSQL:     array [0..CountOfMSSQLProc - 1] of String = ('ADQA_ALL_VALUES', 'ADQA_SET_VALUES');
  ProcPropInMSSQL: array [0..1, 0..4] of Integer = ((1, 0, 0, 0, 0), (1, 0, 0, 0, 0)); {(Type, Scope, InParams, OutParams, Overl)}
  CountOfASAProc   = 2;
  ProcInASA:      array [0..CountOfASAProc - 1] of String = ('ADQA_ALL_VALUES', 'ADQA_SET_VALUES');
  ProcPropInASA:  array [0..1, 0..4] of Integer = ((0, 0, 0, 19, 0), (0, 0, 19, 0, 0)); {(Type, Scope, InParams, OutParams, Overl)}
  CountProcArgWithoutPack = 32;
  ProcArgWithoutPack:
                   array [0..CountProcArgWithoutPack - 1] of String =
      ('I_BFILE', 'I_BLOB', 'I_CHAR', 'I_CLOB', 'I_DATE', 'I_FLOAT', 'I_LONG', 'I_NCHAR', 'I_NCLOB', 'I_NUMBER', 'I_NVARCHAR2', 'I_RAW',
       'I_ROWID', 'I_UROWID', 'I_VARCHAR', 'I_VARCHAR2', 'O_BFILE', 'O_BLOB', 'O_CHAR', 'O_CLOB', 'O_DATE', 'O_FLOAT', 'O_LONG',
       'O_NCHAR', 'O_NCLOB', 'O_NUMBER', 'O_NVARCHAR2', 'O_RAW', 'O_ROWID', 'O_UROWID', 'O_VARCHAR', 'O_VARCHAR2');

  ProcArgPropWPack:
                   array [0..CountProcArgWithoutPack - 1, 0..6] of Integer = {(Pos, ParamType, DataType, Attr, Prec, Scale, Len)}
      (({I_BFILE}15, 1, 27, 2058, 0, 0, 0), ({I_BLOB}14, 1, 24, 10, 0, 0, 0), ({I_CHAR}11, 1, 18, 7, 0, 0, 0),  ({I_CLOB}13, 1, 25, 10, 0, 0, 0),
      ({I_DATE}7, 1, 17, 3, 0, 0, 0),    ({I_FLOAT}4, 1, 10, 3, 38, 0, 0), ({I_LONG}5, 1, 22, 10, 0, 0, 0),   ({I_NCHAR}10, 1, 19, 7, 0, 0, 0),
      ({I_NCLOB}12, 1, 26, 10, 0, 0, 0),   ({I_NUMBER}3, 1, 13, 3, 0, 0, 0),  ({I_NVARCHAR2}1, 1, 19, 3, 0, 0, 0),  ({I_RAW}8, 1, 20, 3, 0, 0, 0),
      ({I_ROWID}9, 1, 18, 73, 0, 0, 18), ({I_UROWID}16, 1, 18, 69, 0, 0, 0), ({I_VARCHAR}6, 1, 18, 3, 0, 0, 0),  ({I_VARCHAR2}2, 1, 18, 3, 0, 0, 0),
      ({O_BFILE}31, 2, 27, 2058, 0, 0, 0), ({O_BLOB}30, 2, 24, 10, 0, 0, 0), ({O_CHAR}27, 2, 18, 7, 0, 0, 0), ({O_CLOB}29, 2, 25, 10, 0, 0, 0),
      ({O_DATE}23, 2, 17, 3, 0, 0, 0),   ({O_FLOAT}20, 2, 10, 3, 38, 0, 0), ({O_LONG}21, 2, 22, 10, 0, 0, 0), ({O_NCHAR}26, 2, 19, 7, 0, 0, 0),
      ({O_NCLOB}28, 2, 26, 10, 0, 0, 0),  ({O_NUMBER}19, 2, 13, 3, 0, 0, 0),  ({O_NVARCHAR2}17, 2, 19, 3, 0, 0, 0),  ({O_RAW}24, 2, 20, 3, 0, 0, 0),
      ({O_ROWID}25, 2, 18, 73, 0, 0, 18), ({O_UROWID}32, 2, 18, 69, 0, 0, 0), ({O_VARCHAR}22, 2, 18, 3, 0, 0, 0),  ({O_VARCHAR2}18, 2, 18, 3, 0, 0, 0));

  CountProcArgMSSQL = {24;}20;
  ProcArgMSSQL:    array [0..CountProcArgMSSQL - 1] of String =
      ('@o_bigint', '@o_binary', '@o_bit', '@o_char', '@o_datetime', '@o_float', {'@o_image',} '@o_int',
       '@o_money', '@o_nchar', {'@o_ntext',} '@o_numeric', '@o_nvarchar', '@o_real',  '@o_smalldatetime', '@o_smallint',
       '@o_smallmoney', {'@o_sql_variant', '@o_text',} '@o_tinyint', '@o_uniqueidentifier',
       '@o_varbinary', '@o_varchar', '@RETURN_VALUE');

  ProcArgPropMSSQL:
                   array [0..CountProcArgMSSQL - 1, 0..6] of Integer = {(Pos, ParamType, DataType, Attr, Prec, Scale, Len)}
      (({@o_bigint}1, 3, 5, 3, 0, 0, 0),         ({@o_binary}2, 3, 20, 7, 0, 0, 50),  ({@o_bit}3, 3, 1, 3, 0, 0, 0),
      ({@o_char}4, 3, 18, 7, 0, 0, 10),          ({@o_datetime}5, 3, 17, 3, 0, 0, 0), ({@o_float}6, 3, 10, 3, 16, 0, 0),
      {({@o_image7, 3, 21, 10, 0, 0, 0),}        ({@o_int}{8}7, 3, 4, 3, 0, 0, 0),    ({@o_money}{9}8, 3, 12, 3, 19, 4, 0),
      ({@o_nchar}{10}9, 3, 19, 7, 0, 0, 10),    {({@o_ntext11, 3, 22, 10, 0, 0, 0),}  ({@o_numeric}{12}10, 3, 12, 3, 10, 8, 0),
      ({@o_nvarchar}{13}11, 3, 19, 3, 0, 0, 50), ({@o_real}{14}12, 3, 10, 3, 8, 0, 0),({@o_smalldatetime}{15}13, 3, 17, 3, 0, 0, 0),
      ({@o_smallint}{16}14, 3, 3, 3, 0, 0, 0),   ({@o_smallmoney}{17}15, 3, 12, 3, 10, 4, 0), {({@o_sql_variant18, 3, 21, 3, 0, 0, 0),
      ({@o_text19, 3, 22, 10, 0, 0, 0),}       ({@o_tinyint}{20}16, 3, 2, 3, 0, 0, 0), ({@o_uniqueidentifier}{21}17, 3, 22, 3, 0, 0, 0),
      ({@o_varbinary}{22}18, 3, 20, 3, 0, 0, 50), ({@o_varchar}{23}19, 3, 18, 3, 0, 0, 50), ({@RETURN_VALUE}0, 4, 4, 1, 0, 0, 0));

  CountProcArgASA = 19;
  ProcArgASA:    array [0..CountProcArgASA - 1] of String =
      ('o_bigint', 'o_binary', 'o_bit', 'o_char', 'o_date', 'o_time', 'o_decimal', 'o_double', 'o_float', 'o_longbinary',
       'o_int', 'o_numeric', 'o_real', 'o_smallint', 'o_longvarchar', 'o_timestamp', 'o_tinyint', 'o_varbinary', 'o_varchar');

  ProcArgPropASA:
                   array [0..CountProcArgASA - 1, 0..6] of Integer = {(Pos, ParamType, DataType, Attr, Prec, Scale, Len)}
      (({@o_bigint}1, 2, 5, 3, 0, 0, 0),         ({@o_binary}2, 2, 20, 7, 0, 0, 50),  ({@o_bit}3, 2, 1, 3, 0, 0, 0),
      ({@o_char}4, 2, 18, 7, 0, 0, 10),          ({@o_date}5, 2, 14, 3, 0, 0, 0),     ({@o_time}6, 2, 15, 3, 0, 0, 0),
      ({@o_decimal}7, 2, 13, 3, 19, 4, 0),       ({@o_double}8, 2, 10, 3, 15, 0, 0),  ({@o_float}9, 2, 10, 3, 7, 0, 0),
      ({@o_longbinary}10, 2, 21, 10, 0, 0, 2000000000),({@o_int}11, 2, 4, 3, 0, 0, 0), ({@o_numeric}12, 2, 13, 3, 10, 8, 0),
      ({@o_real}13, 2, 10, 3, 7, 0, 0),          ({@o_smallint}14, 2, 3, 3, 0, 0, 0), ({@o_longvarchar}15, 2, 22, 10, 0, 0, 0),
      ({@o_timestamp}16, 2, 17, 3, 0, 0, 0),      ({@o_tinyint}17, 2, 2, 3, 0, 0, 0),  ({@o_varbinary}18, 2, 20, 3, 0, 0, 50),
      ({@o_varchar}19, 2, 18, 3, 0, 0, 50));
  // The end of the constants for Meta info command tests


  C_THREAD_COUNT = 100;

  NEW_VAL1 = 3003;
  NEW_VAL2 = 3004;

  C_BYTE   = 111;
  C_SBYTE  = 111;
  C_INT16  = 1000;
  C_INT32  = 10491;
  C_INT64  = 57205725;
  C_UINT16 = 522;
  C_UINT32 = 29087;
  C_UINT64 = 4096740;
  C_DOUBLE = 309335.91255773456;

  // possible datatypes in different RDBMS
  _CHAR             = 'CHAR';
  _CHAR_BIT         = 'CHAR_BIT';
  _CHARACTER        = 'CHARACTER';
  _NCHAR            = 'NCHAR';
  _VARCHAR          = 'VARCHAR';
  _VARCHAR_BIT      = 'VARCHAR_BIT';
  _VARCHAR2         = 'VARCHAR2';
  _NVARCHAR2        = 'NVARCHAR2';
  _NVARCHAR         = 'NVARCHAR';
  _INT              = 'INT';
  _UINT             = 'UINT';
  _INTEGER          = 'INTEGER';
  _MEDIUMINT        = 'MEDIUMINT';
  _SMALLINT         = 'SMALLINT';
  _USMALLINT        = 'USMALLINT';
  _TINYINT          = 'TINYINT';
  _BIGINT           = 'BIGINT';
  _UBIGINT          = 'UBIGINT';
  _FLOAT            = 'FLOAT';
  _CURRENCY         = 'CURRENCY';
  _MONEY            = 'MONEY';
  _NUMERIC          = 'NUMERIC';
  _DECIMAL          = 'DECIMAL';
  _REAL             = 'REAL';
  _DOUBLE           = 'DOUBLE';
  _SINGLE           = 'SINGLE';
  _TEXT             = 'TEXT';
  _NTEXT            = 'NTEXT';
  _GUID             = 'GUID';
  _UNIQUEIDENTIFIER = 'UNIQUEIDENTIFIER';
  _BINARY           = 'BINARY';
  _VARBINARY        = 'VARBINARY';
  _LONGBINARY       = 'LONGBINARY';
  _MEMO             = 'MEMO';
  _DATETIME         = 'DATETIME';
  _DATE             = 'DATE';
  _TIME             = 'TIME';
  _SQL_VARIANT      = 'SQL_VARIANT';
  _TIMESTAMP        = 'TIMESTAMP';
  _BLOB             = 'BLOB';
  _CLOB             = 'CLOB';
  _NCLOB            = 'NCLOB';
  _BOOL             = 'BOOL';
  _BOOLEAN          = 'BOOLEAN';
  _BIT              = 'BIT';
  _RAW              = 'RAW';
  _ROWID            = 'ROWID';
  _UROWID           = 'UROWID';
  _BFILE            = 'BFILE';
  _NUMBER           = 'NUMBER';
  _IMAGE            = 'IMAGE';
  _YEAR             = 'YEAR';
  _LONG             = 'LONG';
  _SET              = 'SET';
  _ENUM             = 'ENUM';
  _GRAPHIC          = 'GRAPHIC';
  _VARGRAPHIC       = 'VARGRAPHIC';
  _LONGVARCHAR      = 'LONGVARCHAR';
  _LONGVARGRAPHIC   = 'LONGVARGRAPHIC';
  _DBCLOB           = 'DBCLOB';
  _DATALINK         = 'DATALINK';

  CursorRowsCount: array [0..2] of Integer = (3, 8, 29);

  BorderLength:    array [TADRDBMSKind, 0..20] of Integer =
     ((0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),                                                            {mkNone}
     (254, 255, 256, 1022, 1023, 1024, 1332, 1333, 1334, 1999, 2000, 2001, 3070, 3071, 3072, 3999, 4000, 4001, 0, 0, 0),          {mkOracle}
     (254, 255, 256, 1022, 1023, 1024, 1999, 2000, 2047, 2048, 3070, 3071, 3072, 3999, 4000, 4001, 4094, 4095, 4096, 7999, 8000), {mkMSSQL}
     (254, 255, 256, 1022, 1023, 1024, 2046, 2047, 2048, 3070, 3071, 3072, 4094, 4095, 4096, 8190, 8191, 8192, 0, 0, 0),          {mkMSAccess}
     (254, 255, 256, 1022, 1023, 1024, 2046, 2047, 2048, 3070, 3071, 3072, 4094, 4095, 4096, 8190, 8191, 8192, 0, 0, 0),          {mkMySQL}
     (254, 255, 256, 1022, 1023, 1024, 2046, 2047, 2048, 3070, 3071, 3072, 4094, 4095, 4096, 8190, 8191, 8192, 0, 0, 0),          {mkDb2}
     (254, 255, 256, 1022, 1023, 1024, 2046, 2047, 2048, 3070, 3071, 3072, 4094, 4095, 4096, 8190, 8191, 8192, 0, 0, 0),          {mkASA}                                                   {mkASA}
     (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),                                                             {mkADS}
     (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));                                                            {mkOther}

  OraSQLCommands:  array [0..13] of String =
     (
      'select * from aaa',
      'select * from aaa order by ccc',
      'select * from aaa.bbb.ccc',
      'select * from aaa.bbb.ccc order by ccc',
      'select * from "aaa"',
      'select * from "aaa" order by ccc',
      'select * from "aaa"."bbb"."ccc"',
      'select * from "aaa"."bbb"."ccc" order by ccc',
      'select * from (select * from aaa)',
      'select * from (select * from aaa) order by ccc',
      'select * from (select * from aaa',
      'select * from "aaa"."bbb"."ccc',
      'select * from "aaa".bbb',
      'select * from "aaa".bbb."ccc" order by ccc'
     );

  SQLFromRes:    array [0..13] of String =
     (
      'aaa',
      'aaa',
      'aaa.bbb.ccc',
      'aaa.bbb.ccc',
      '"aaa"',
      '"aaa"',
      '"aaa"."bbb"."ccc"',
      '"aaa"."bbb"."ccc"',
      '(select * from aaa)',
      '(select * from aaa)',
      '',
      '"aaa"."bbb"."ccc',
      '"aaa".bbb',
      '"aaa".bbb."ccc"'
     );

  OraSQLParams:  array [0..9] of String =
     (
      ':p0 qwe :p1 qwe :p2',
      '!m0 qwe !m1 qwe !m2',
      '&m0 qwe &m1 qwe &m2',
      '::p0 qwe ::p1 qwe ::p2',
      '!!m0 qwe !!m1 qwe !!m2',
      '&&m0 qwe &&m1 qwe &&m2',
      ':"P0" qwe :"p1" qwe :"P2"',
      '!"M0" qwe !"m1" qwe !"M2"',
      '&"M0" qwe &"m1" qwe &"M2"',
      ':p1 !m1'
     );

  MySQLParams:   array [0..3] of String =
     (
      'INSERT into mlabel (GRUP,NNUM,NAME) VALUES (''94000'',''94100007'',''Программа WINDOWS"95 руссиф.'')',
      'INSERT into mlabel (GRUP,NNUM,NAME) VALUES ("13000","13230011","В/камера PANASONIC NV-M3500EM(кейс")',
      '"''"',
      '''"'''
     );

  // consts for Comp Layer
  INDEX_COUNT = 4;
{$IFDEF AnyDAC_D6}
  FIELD_COUNT = 22;
{$ELSE}
  FIELD_COUNT = 20;
{$ENDIF}
  RECORD_COUNT = 10;

  IdxPrefs: array [0..INDEX_COUNT - 1] of String = ('p_', 'u_', 'd_', 'c_');
  IdxValues: array [0..INDEX_COUNT - 1] of TADSortOption = (soPrimary, soUnique,
    soDescending, soNoCase);

  FldNames: array [0..FIELD_COUNT - 1] of String = ('ftString', 'ftSmallInt', 'ftInteger',
    'ftWord', 'ftBoolean', 'ftFloat', 'ftCurrency', 'ftBCD', 'ftDate', 'ftTime',
    'ftDateTime', 'ftBytes', 'ftVarBytes', 'ftAutoInc', 'ftBlob', 'ftMemo',
    'ftFixedChar', 'ftWideString', 'ftGuid', 'ftLargeInt'
{$IFDEF AnyDAC_D6}
    , 'ftTimeStamp', 'ftFMTBcd'
{$ENDIF}
    );

  FldTypes: array [0..FIELD_COUNT - 1] of TFieldType = (ftString, ftSmallInt, ftInteger,
    ftWord, ftBoolean, ftFloat, ftCurrency, ftBCD, ftDate, ftTime,
    ftDateTime, ftBytes, ftVarBytes, ftAutoInc, ftBlob, ftMemo,
    ftFixedChar, ftWideString, ftGuid, ftLargeInt
{$IFDEF AnyDAC_D6}
    , ftTimeStamp, ftFMTBcd
{$ENDIF}
    );

  FldSizes: array[0..FIELD_COUNT - 1] of Byte =
    (20, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 16, 16, 0, 0, 0, 20, 20, 38, 0
{$IFDEF AnyDAC_D6}
    , 0, 0
{$ENDIF}
    );

  DescendNums: array [0..FIELD_COUNT - 1] of Integer = (9{Strings}, 6{SmallInts},
    8{Integers}, 9{Words}, 3{Boolean}, 6{Floats}, 2{Currencies}, 4{Bcds}, 9{Dates},
    4{Times}, 9{datetimes}, 1{Bytes}, 4{VarBytes}, 5{AutoIncs}, 4{Blobs},
    2{Memos}, 9{FixedChar}, 5{WideString}, 2{Guids}, 3{LargeInt}
{$IFDEF AnyDAC_D6}
    , 9{TimeStamps}, 5{FMTBcds}
{$ENDIF}
    );

  CaseInsensNums1: array [0..FIELD_COUNT - 1] of Integer = (0{Strings}, -1{SmallInts},
    -1{Integers}, -1{Words}, -1{Boolean}, -1{Floats}, -1{Currencies}, -1{Bcds},
    -1{Dates}, -1{Times}, -1{datetimes}, 2{Bytes}, 7{VarBytes}, -1{AutoIncs},
    2{Blobs}, 1{Memos}, 2{FixedChar}, 3{WideString}, -1{Guids}, -1{LargeInt}
{$IFDEF AnyDAC_D6}
    , -1{TimeStamps}, -1{FMTBcds}
{$ENDIF}
    );

  CaseInsensNums2: array [0..FIELD_COUNT - 1] of Integer = (0{Strings}, -1{SmallInts},
    -1{Integers}, -1{Words}, -1{Boolean}, -1{Floats}, -1{Currencies}, -1{Bcds},
    -1{Dates}, -1{Times}, -1{datetimes}, 2{Bytes}, 7{VarBytes}, -1{AutoIncs},
    2{Blobs}, 1{Memos}, 2{FixedChar}, 9{WideString}, -1{Guids}, -1{LargeInt}
{$IFDEF AnyDAC_D6}
    , -1{TimeStamps}, -1{FMTBcds}
{$ENDIF}
    );

  LookupNums: array [0..FIELD_COUNT - 1] of Integer = (0{Strings},
    5{SmallInts}, 7{Integers}, 8{Words}, 0{Boolean}, 7{Floats}, 9{Currencies},
    5{Bcds}, 0{Dates}, 0{Times}, 1{datetimes}, 2{Bytes}, 7{VarBytes}, 6{AutoIncs},
    9{Blobs}, 9{Memos}, 2{FixedChar}, 9{WideString}, 5{Guids}, 4{LargeInt}
{$IFDEF AnyDAC_D6}
    , 7{TimeStamps}, 6{FMTBcds}
{$ENDIF}
    );

  LocateCINums: array [0..FIELD_COUNT - 1, 0..1] of Integer = ((4, 0){Strings},
    (-1, -1){SmallInts}, (-1, -1){Integers}, (-1, -1){Words}, (-1, -1){Boolean},
    (-1, -1){Floats}, (-1, -1){Currencies}, (-1, -1){Bcds}, (-1, -1){Dates},
    (-1, -1){Times}, (-1, -1){datetimes}, (0, 4){Bytes}, (0, 4){VarBytes},
    (-1, -1){AutoIncs}, (4, 0){Blobs}, (4, 0){Memos}, (4, 2){FixedChar},
    (4, 4){WideString}, (-1, -1){Guids}, (-1, -1){LargeInt}
{$IFDEF AnyDAC_D6}
    , (-1, -1){TimeStamps}, (-1, -1){FMTBcds}
{$ENDIF}
    );

  LocatePKNums: array [0..FIELD_COUNT - 1, 0..1] of Integer = ((1, 1){Strings},
    (-1, -1){SmallInts}, (-1, -1){Integers}, (-1, -1){Words}, (-1, -1){Boolean},
    (-1, -1){Floats}, (-1, -1){Currencies}, (-1, -1){Bcds}, (-1, -1){Dates},
    (-1, -1){Times}, (-1, -1){datetimes}, (3, 5){Bytes}, (1, 2){VarBytes},
    (-1, -1){AutoIncs}, (6, 7){Blobs}, (8, 9){Memos}, (3, 3){FixedChar},
    (3, 3){WideString}, (-1, -1){Guids}, (-1, -1){LargeInt}
{$IFDEF AnyDAC_D6}
    , (-1, -1){TimeStamps}, (-1, -1){FMTBcds}
{$ENDIF}
    );

  SetRangeNums: array [0..FIELD_COUNT - 1] of Integer = (5{Strings}, 5{SmallInts},
    5{Integers}, 5{Words}, 1{Boolean}, 5{Floats}, 5{Currencies}, 5{Bcds},
    5{Dates}, 5{Times}, 5{Datetimes}, 5{Bytes}, 5{VarBytes}, 5{AutoIncs},
    5{Blobs}, 5{Memos}, 5{FixedChar}, 3{WideString}, 5{Guids}, 5{LargeInt}
{$IFDEF AnyDAC_D6}
    , 5{TimeStamps}, 5{FMTBcds}
{$ENDIF}
    );

  NullInField:  array [TADRDBMSKind] of Integer = (0, 3, 2, 1, 1, 4, 3, 0, 0);
  NullInDateField:
                array [TADRDBMSKind] of Integer = (0, 4, 4, 8, 19, 15, 18, 0, 0);

  DTMMode:      array [TADDataMoveMode] of String =
    ('dmAlwaysInsert', 'dmAppend', 'dmUpdate', 'dmAppendUpdate',
     'dmDelete');

  DTMRecFormat: array [TADAsciiRecordFormat] of String = ('rfFixedLength', 'rfCommaDoubleQuote', 'rfFieldPerLine',
    'rfTabDoubleQuote', 'rfCustom');

  // for DB2
  ProcForDefineArgs: array [0..1] of String = ('LIST_SRVR_VERSIONS', 'GET_SWRD_SETTINGS');
  ParamsCountOfPrc:  array [0..1] of Integer = (3, 12);
  ParamTypesOfProc:  array [0..1, 0..11] of TFieldType =
     ((ftString, ftString, ftInteger, ftUnknown, ftUnknown, ftUnknown,
       ftUnknown, ftUnknown, ftUnknown, ftUnknown, ftUnknown, ftUnknown),
      (ftString, ftSmallint, ftSmallint, ftString, ftString, ftLargeint,
       ftSmallint, ftSmallint, ftSmallint, ftSmallint, ftString, ftString));
  ADProcParamTypes:  array [0..11] of TADDataType =
    (dtAnsiString, dtInt16, dtInt16, dtAnsiString, dtAnsiString, dtInt64,
     dtInt16, dtInt16, dtInt16, dtInt16, dtAnsiString, dtAnsiString);
  All_types_col_name: array [0..19] of String =
    ('tbigint', 'tblob', 'tchar', 'tchar_bit', 'tclob', 'tdate', 'tdecimal',
     'tdouble', 'tgraphic', 'tinteger', 'tlongvarchar', 'tlongvargraphic',
     'treal', 'tsmallint', 'ttime', 'ttimestamp', 'tvarchar', 'tvarchar_bit',
     'tvargraphic', 'tdbclob');
  All_types_col_type: array [0..19] of String =
    ('BIGINT', 'BLOB', 'CHAR', 'CHAR () FOR BIT DATA', 'CLOB', 'DATE', 'DECIMAL',
     'DOUBLE', 'GRAPHIC', 'INTEGER', 'LONG VARCHAR', 'LONG VARGRAPHIC',
     'REAL', 'SMALLINT', 'TIME', 'TIMESTAMP', 'VARCHAR', 'VARCHAR () FOR BIT DATA',
     'VARGRAPHIC', 'DBCLOB');


var
  Floats:      array [0..9] of Double;
  Currencies:  array [0..9] of Currency;
  Bcds:        array [0..9] of Currency;
  Dates:       array [0..9] of TDateTime;
  Times:       array [0..9] of TDateTime;
  DateTimes:   array [0..9] of TDateTime;
  TimeStamps:  array [0..9] of TADSQLTimeStamp;
  FMTBcds:     array [0..9] of TBcd;
  MSACCESS_CONN,
  MSSQL_CONN,
  ASA_CONN,
  MYSQL_CONN,
  ORACLE_CONN,
  DB2_CONN:    String;
  WideStrings: array [0..9] of WideString;
  WideMemos:   array [0..9] of WideString;
  WideHMemos:  array [0..9] of WideString;

  procedure InitConnectionDefNames;
  procedure LoadNumDataFromStrings;
  procedure LoadWideStrings;

implementation

uses
  ADQAUtils;

procedure InitConnectionDefNames;
begin
  MSACCESS_CONN := 'Access_Demo';
  MSSQL_CONN    := 'MSSQL2000_Demo';
  ASA_CONN      := 'ASA_Demo';
  MYSQL_CONN    := 'MySQL_Demo';
  ORACLE_CONN   := 'Oracle_Demo';
  DB2_CONN      := 'DB2_Demo';
end;

procedure LoadNumDataFromStrings;
var
  i: Integer;
begin
  for i := 0 to 9 do begin
    Floats[i]     := StrToFloat_Cast(Floats_str[i]);
    Currencies[i] := StrToCurrency_Cast(Currencies_str[i]);
    Bcds[i]       := StrToCurrency_Cast(Bcds_str[i]);
    Dates[i]      := StrToDate_Cast(Dates_str[i]);
    Times[i]      := StrToTime_Cast(Times_str[i]);
    DateTimes[i]  := StrToDateTime_Cast(DateTimes_str[i]);
    TimeStamps[i] := StrToSQLTimeStamp_Cast(TimeStamps_str[i]);
    FMTBcds[i]    := StrToBcd_Cast(FMTBcds_str[i]);
  end;
end;

procedure LoadWideStrings;
var
  sUnicodes: String;
  oFile: TADFileStream;
  i: Integer;
begin
  SetLength(sUnicodes, 300);
  oFile := TADFileStream.Create(ADExpandStr('$(ADHOME)\DB\Data\ADQA_Unicode_Strings.txt'), fmOpenRead);
  try
    oFile.Read(sUnicodes[1], 300);
    for i := 0 to 9 do begin
      SetLength(WideStrings[i], 5);
      ADMove((PChar(sUnicodes) + i * 10)^, PWideChar(WideStrings[i])^, 10);
    end;
    for i := 0 to 9 do begin
      SetLength(WideMemos[i], 5);
      ADMove((PChar(sUnicodes) + i * 10 + 100)^, PWideChar(WideMemos[i])^, 10);
    end;
    for i := 0 to 9 do begin
      SetLength(WideHMemos[i], 5);
      ADMove((PChar(sUnicodes) + i * 10 + 200)^, PWideChar(WideHMemos[i])^, 10);
    end;
  finally
    oFile.Free;
  end;
end;

initialization

  InitConnectionDefNames;
  LoadNumDataFromStrings;
  LoadWideStrings;

end.
