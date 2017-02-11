{-------------------------------------------------------------------------------}
{ AnyDAC resource strings                                                       }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit daADStanResStrs;

interface

uses
  daADStanConst;

resourcestring
  {-------------------------------------------------------------------------------}
  // Dialog captions

  S_AD_ErrorDialogDefCaption = 'AnyDAC Error';
  S_AD_LoginDialogDefCaption = 'AnyDAC Login';
  S_AD_AsyncDialogDefCaption = 'AnyDAC Working';
  S_AD_LoginDialogTestOk = 'Connection established successfully.';
  S_AD_WizardNotAccessible = 'The wizard is not implemented for this kind of driver.';

  {-------------------------------------------------------------------------------}
  // Error messages

  S_AD_DuplicatedName = 'Name [%s] is Duplicated in the list';
  S_AD_NameNotFound = 'Object with name [%s] is not found';
  S_AD_ColTypeUndefined = 'Column [%s] type is undefined';
  S_AD_NoColsDefined = 'No columns defined for table';
  S_AD_CheckViolated = 'Check condition violated. Constraint [%s]';
  S_AD_CantBeginEdit = 'Cannot begin edit row';
  S_AD_CantCreateChildView = 'Cannot create child view. Relation [%s]';
  S_AD_RowCantBeDeleted = 'Cannot delete row';
  S_AD_ColMBBLob = 'Column [%s] must have blob value';
  S_AD_FixedLenDataMismatch = 'Fixed length column [%s] data length mismatch.' + C_AD_EOL +
    'Value length - [%d], column fixed length - [%d]';
  S_AD_RowNotInEditableState = 'Row is not in editable state';
  S_AD_ColIsReadOnly = 'Column [%s] is read only';
  S_AD_RowCantBeInserted = 'Cannot insert row into table';
  S_AD_RowColMBNotNull = 'Column [%s] value must be not null';
  S_AD_DuplicateRows = 'Duplicate row found on unique index. Constraint [%s]';
  S_AD_NoMasterRow = 'Cannot process - no parent row. Constraint [%s]';
  S_AD_HasChildRows = 'Cannot process - child rows found. Constraint [%s]';
  S_AD_CantCompareRows = 'Cannot compare rows';
  S_AD_ConvIsNotSupported = 'Data type conversion is not supported';
  S_AD_ColIsNotSearchable = 'Column [%s] is not searchable';
  S_AD_RowMayHaveSingleParent = 'Row may have only single column of [dtParentRowRef] data type';
  S_AD_CantOperateInvObj = 'To operate invariant column [%s] data use other methods';
  S_AD_CantSetParentRow = 'Cannot set parent row';
  S_AD_RowIsNotNested = 'Row is not nested';
  S_AD_ColumnIsNotRef = 'Column [%s] is not reference to other row';
  S_AD_ColumnIsNotSetRef = 'Column [%s] is not reference to row set';
  S_AD_OperCNBPerfInState = 'Cannot perform operation for row state';
  S_AD_CantSetUpdReg = 'Cannot change updates registry for DatS manager [%s]';
  S_AD_TooManyAggs = 'Too many aggregate values per view';
  S_AD_GrpLvlExceeds = 'Grouping level exceeds maximum allowed for aggregate [%s]';
  S_AD_VarLenDataMismatch = 'Variable length column [%s] overflow.' + C_AD_EOL +
    'Value length - [%d], column maximum length - [%d]';
  S_AD_BadForeignKey = 'Invalid foreign key [%s]';
  S_AD_BadUniqueKey = 'Invalid unique key [%s]';
  S_AD_CantChngColType = 'Cannot change column [%s] data type';
  S_AD_BadRelation = 'Invalid relation [%s]';
  S_AD_CantCreateParentView = 'Cannot create parent view. Relation [%s]';
  S_AD_CantChangeTableStruct = 'Cannot change table [%s] structure, when table has rows';
  S_AD_FoundCascadeLoop = 'Found a cascading actions loop at checking foreign key [%s]';
  S_AD_RecLocked = 'Record already locked';
  S_AD_RecNotLocked = 'Record is not locked';
  S_AD_TypeIncompat = 'Assigning value [%s] is not compatible with column [%s] data type.' + C_AD_EOL + '%s';

  S_AD_ColumnDoesnotFound = 'Column with name [%s] is not found';
  S_AD_ExprTermination = 'Expression unexpectedly terminated';
  S_AD_ExprMBAgg = 'Expression must be aggregated';
  S_AD_ExprCantAgg = 'Expression cannot be aggregated';
  S_AD_ExprTypeMis = 'Type mismatch in expression';
  S_AD_ExprIncorrect = 'Expression is incorrect';
  S_AD_InvalidKeywordUse = 'Invalid use of keyword';
  S_AD_ExprInvalidChar = 'Invalid character found [%s]';
  S_AD_ExprNameError = 'Name is not terminated properly';
  S_AD_ExprStringError = 'String constant is not terminated properly';
  S_AD_ExprNoLParen = '''('' expected but [%s] found';
  S_AD_ExprNoRParenOrComma = ''')'' or '','' expected but [%s] found';
  S_AD_ExprNoRParen = ''')'' expected but [%s] found';
  S_AD_ExprEmptyInList = 'IN predicate list may not be empty';
  S_AD_ExprExpected = 'Expected [%s]';
  S_AD_ExprNoArith = 'Arithmetic in filter expressions not supported';
  S_AD_ExprBadScope = 'Operation cannot mix aggregate value with record-varying value';
  S_AD_ExprEmpty = 'Empty expression';
  S_AD_ExprEvalError = 'Error evaluating expression.' + C_AD_EOL + '%s';

  S_AD_DSNoNookmark = 'Bookmark is not found';
  S_AD_DSViewNotSorted = 'View [%s] is not a sorted view';
  S_AD_DSNoAdapter = 'Adapter interface must be supplied';
  S_AD_DSNoNestedMasterSource = 'Nested datasets cannot have a MasterSource';
  S_AD_DSCircularDataLink = 'Circular datalinks are not allowed';
  S_AD_DSRefreshError = 'To refresh dataset, cached updates must be commited or canceled';
  S_AD_DSNoDataTable = 'To open dataset, DataTable or DataView must be supplied ';
  S_AD_DSIndNotFound = 'Index [%s] is not found';
  S_AD_DSAggNotFound = 'Aggregate [%s] is not found';
  S_AD_DSIndNotComplete = 'Index definition is not complete';
  S_AD_DSAggNotComplete = 'Aggregate definition is not complete';
  S_AD_DSRefreshError2 = 'Cannot refresh unidirectional dataset';

  S_AD_DefCircular = 'Cannot make definition [%s] circular reference';
  S_AD_DefRO = 'Cannot %s definition [%s]. It has accosiated connection';
  S_AD_DefCantMakePers = 'Cannot make definition persistent';
  S_AD_DefAlreadyLoaded = 'Cannot load definition list, because it is already loaded';
  S_AD_DefNotExists = 'Definition with name [%s] is not found in [%s]';
  S_AD_DefDupName = 'Definition name [%s] is duplicated';

  S_AD_AccSrvNotFound = 'Driver [%s] is not registered.'#13#10'To register it, you can drop component [TADPhys%sDriverLink] into your project';
  S_AD_AccSrvNotDefined = 'Driver ID is not defined.'#13#10'Set TADConnection.DriverName or add DriverID parameter to your connection definition';
  S_AD_AccCantSaveCfgFileName = 'Cannot save definitions file name';
  S_AD_AccSrvMBConnected = 'Connection must be active';
  S_AD_AccCapabilityNotSup = 'Capability is not supported';
  S_AD_AccTxMBActive = 'Transaction must be active';
  S_AD_AccCantChngCommandState = 'Cannot change command state';
  S_AD_AccCommandMBFilled = 'Command text must be not empty';
  S_AD_AccSrvrIntfMBAssignedS = 'Connection interface must be assigned';
  S_AD_AccCmdMHRowSet = 'Command must return row set';
  S_AD_AccCmdMBPrepared = 'Command must be is prepared state';
  S_AD_AccCantExecCmdWithRowSet = 'Cannot execute command returning row set or metainfo';
  S_AD_AccCmdMBOpen4Fetch = 'Command must be open for fetching';
  S_AD_AccExactFetchMismatch = 'Exact fetch returned wrong number of rows';
  S_AD_AccMetaInfoMismatch = 'Meta information mismatch';
  S_AD_AccCantLoadLibrary = 'Cannot load vendor library [%s].' + C_AD_EOL + '%s' +
    'Check [%s] is located in one of the PATH directories or in application EXE direcrory';
  S_AD_AccCantGetLibraryEntry = 'Cannot get vendor library entry point [%s].' + C_AD_EOL + '%s';
  S_AD_AccSrvMBDisConnected = 'Connection must be inactive';
  S_AD_AccToManyLogins = 'Too many login retries. Allowed [%d] times';
  S_AD_AccCantOperDrv = 'Cannot %s in it current state';
  S_AD_AccDrvPackEmpty = 'Driver package name is undefined';
  S_AD_AccDrvMngrMB = 'To perform operation driver manager, must be [%s]';
  S_AD_AccPrepMissed = 'Character [%s] is missed';
  S_AD_AccPrepParamNotDef = 'Cannot preprocess command because not all parameters are defined';
  S_AD_AccPrepTooLongIdent = 'Too long identifier (> 255)';
  S_AD_AccPrepUnknownEscape = 'Unknown escape sequence [%s]';
  S_AD_AccParamArrayMismatch = 'Parameter [%s] ArraySize is less than ATimes';
  S_AD_AccAsyncOperInProgress = 'Cannot perform action, because previous action is in progress';
  S_AD_AccEscapeIsnotSupported = 'Escape function [%s] isnot supported';
  S_AD_AccMetaInfoReset = 'For metainfo retrivial supported only Define(mmReset)';
  S_AD_AccWhereIsEmpty = 'WHERE condition must be not empty';
  S_AD_AccUpdateTabUndefined = 'Update table undefined';
  S_AD_AccNameHasErrors = 'Cannot parse object name - [%s]';
  S_AD_AccEscapeBadSyntax = 'Syntax error in escape function [%s].' + C_AD_EOL + '%s';
  S_AD_AccDrvIsNotReg = 'Driver [%s] entry point is not registered.' + C_AD_EOL +
    'Possible reason: %s';
  S_AD_AccShutdownTO = 'ADPhysManager shutdown timeout.' + C_AD_EOL +
    'Possible reason: application has not released all connection interfaces';
  S_AD_AccParTypeUnknown = 'Parameter [%s] data type is unknown';
  S_AD_AccParDataMapNotSup = 'Data mapping for parameter [%s] is not supported';
  S_AD_AccColDataMapNotSup = 'Data mapping for column [%s] is not supported';
  S_AD_AccParDefChanged = 'Parameter [%s] definition changed. Query must be reprepared';
  S_AD_AccMetaInfoNotDefined = 'A meta data argument [%s] is not defined';

  S_AD_DAptRecordIsDeleted = '%s command %s [%d] instead of [1] record.' + C_AD_EOL +
    'Possible reasons: update table does not have PK or row identifier,' + C_AD_EOL + 
    'record has been changed/deleted by another user.';
  S_AD_DAptRecordIsLocked = 'Record is locked by another user';
  S_AD_DAptNoSelectCmd = 'Operation cannot be performed without assigned SelectCommand';
  S_AD_DAptApplyUpdateFailed = 'Update post failed';
  S_AD_DAptCantEdit = 'Row editing disabled';
  S_AD_DAptCantInsert = 'Row inserting disabled';
  S_AD_DAptCantDelete = 'Row deleting disabled';

  S_AD_ClntSessMBSingle = 'Application must have only single AD manager';
  S_AD_ClntSessMBInactive = 'Manager must be inactive';
  S_AD_ClntSessMBActive = 'Manager must be active';
  S_AD_ClntDbDupName = 'Connection name [%s] must be unique';
  S_AD_ClntDbMBInactive = 'Connection [%s] must be inactive';
  S_AD_ClntDbMBActive = 'Connection [%s] must be active';
  S_AD_ClntDbLoginAborted = 'Connection [%s] establishment is canceled';
  S_AD_ClntDbCantConnPooled = 'Connection cannot be pooled.' + C_AD_EOL +
    'Possible reason: either it is not named, either has additional params.';
  S_AD_ClntDBNotFound = 'Connection [%s] does not found';
  S_AD_ClntAdaptMBActive = 'Command must be in active state';
  S_AD_ClntAdaptMBInactive = 'Command must be in inactive state';
  S_AD_ClntNotCachedUpdates = 'Not in cached update mode';
  S_AD_ClntDbNotDefined = 'Connection is not defined.' + C_AD_EOL +
    'Possible reason: Connection and ConnectionName property values are both empty.';

  S_AD_DPNoAscFld = 'Ascii field [%s] does not found';
  S_AD_DPNoSrcDS = 'Source dataset not set';
  S_AD_DPNoDestDS = 'Destination dataset not set';
  S_AD_DPNoAscDest = 'Destination ascii data file name must be defined';
  S_AD_DPNoAscSrc = 'Source ascii data file name must be defined';
  S_AD_DPBadFixedSize = 'Ascii field [%s] size is undefined in Fixed Size Record format';
  S_AD_DPAscFldDup = 'Ascii field [%s] name is Duplicated';
  S_AD_DPBadAsciiFmt = 'Bad ASCII value [%s] format for mapping item [%s].' + C_AD_EOL + '%s';
  S_AD_DPSrcUndefined = 'Undefined source field or expression for destination field [%s]';

  S_AD_StanTimeout = 'Timeout expired';
  S_AD_StanCantGetBlob = 'Cannot get access to BLOB raw data';
  S_AD_StanPoolMBInactive = 'To perform operation pool must be inactive';
  S_AD_StanPoolMBActive = 'To perform operation pool must be active';
  S_AD_StanCantNonblocking = 'Cannot perform nonblocking action, while other nonblocking action is in progress';
  S_AD_StanMacroNotFound = 'Macro [%s] does not found';
  S_AD_StanBadParRowIndex = 'Bad parameter [%s] row index';
  S_AD_StanPoolAcquireTimeout = 'Timeout acquiring %s from pool. Possible reason:' + C_AD_EOL + '%s';
  S_AD_StanMgrRequired = 'Manager [%s] must be linked with application';
  S_AD_StanHowToReg = '.'#13#10'To register it, you can drop component [%s] into your project';

  S_AD_DBXParMBNotEmpty = 'Connection parameter [%s] must be not empty';
  S_AD_DBXNoDriverCfg = 'DbExpress driver configuration file [%s] does not found.'+ C_AD_EOL +
    'Possible reason: dbExpress is not properly installed on this machine';

  S_AD_MySQLBadVersion = 'Unsupported MySQL version [%i].' + C_AD_EOL +
    'Supported are client and server from v 3.20 to v 5.2';
  S_AD_MySQLCantSetPort = 'Port number cannot be changed';
  S_AD_MySQLBadParams = 'Error in parameter [%s] definition. %s';
  S_AD_MySQLCantInitEmbeddedServer = 'Failed to initialize embedded server.' + C_AD_EOL +
    'See MySQL log files for details';

  S_AD_OdbcDataToLarge = 'Data too large for variable [%s]. Max len = [%d], actual len = [%d]';
  S_AD_OdbcVarDataTypeUnsup = 'Variable [%s] C data type [%d] is not supported';
  S_AD_OdbcParamArrMismatch = 'Parameter [%s] must have the same array size as first parameter';

  S_AD_OraNoCursor = 'No cursors available';
  S_AD_OraCantAssFILE = 'Cannot assign value to BFILE/CFILE parameter [%s]';
  S_AD_OraNoCursorParams = 'No cursor parameters are defined. Include fiMeta into FetchOptions.Items';
  S_AD_OraNotInstalled = 'OCI is not properly installed on this machine (NOE1/INIT)';
  S_AD_OraBadVersion = 'Bad OCI version [%s]. AnyDAC Oracle Driver requires at least 8.0.3 (NOE2/INIT)';
  S_AD_OraOutOfCount = 'Index [%d] is out of array range [0 .. %d] (NOE4/VAR)';
  S_AD_OraBadValueSize = 'Bad or undefined variable value size (NOE5/VAR)';
  S_AD_OraBadArrayLen = 'Bad or undefined variable array length (NOE6/VAR)';
  S_AD_OraBadValueType = 'Bad or undefined variable [%s] value type %d (NOE7/VAR)';
  S_AD_OraUnsupValueType = 'Unsupported variable data type (NOE8/VAR)';
  S_AD_OraDataToLarge = 'Data length [%d] is to large for variable [%s] (NOE10/VAR)';
  S_AD_OraVarWithoutStmt = 'Variable require prepared statement for operation (NOE11/VAR)';
  S_AD_OraBadVarType = 'Bad or undefined variable param type (NOE12/VAR)';
  S_AD_OraUndefPWVar = 'Piece wiese operation for unknown variable (NOE13/STMT)';
  S_AD_OraBadTypePWVar = 'Piece wiese operation for invalid variable (NOE14/STMT)';
  S_AD_OraTooLongGTRID = 'Maximum length (%d) of GTRID exceeded - %d (NOE18/TX)';
  S_AD_OraTooLongBQUAL = 'Maximum length (%d) of BQUAL exceeded - %d (NOE19/TX)';
  S_AD_OraTooLongTXName = 'Maximum length (%d) of transaction name exceeded - %d (NOE20/TX)';
  S_AD_OraDBTNManyClBraces = 'Too many close braces in names file after alias [%s] (NOE105/DB)';
  S_AD_OraNotPLSQLObj = 'Name [%s] is not a callable PL/SQL object (NOE130/SP)';
  S_AD_OraPLSQLObjNameEmpty = 'PL/SQL object name is empty (NOE131/SP)';
  S_AD_OraNotPackageProc = 'Name [%s] is not a proc of package [%s] (NOE134/SP)';
  S_AD_OraBadTableType = 'Parameter with type TABLE OF BOOLEAN/RECORD not supported (use TADQuery) (NOE135/SP)';
  S_AD_OraUnNamedRecParam = 'Parameter with type RECORD must be of named type (use TADQuery) (NOE142/SP)';

  {-------------------------------------------------------------------------------}
  // daADCompBDEAliasImport

  S_AD_CantMakeConnDefBDEComp = 'Cannot make connection definition compatible with BDE.' + C_AD_EOL +
    'Reason - driver and RDBMS kind pair is unsupported.';

  {-------------------------------------------------------------------------------}
  // daADCompDataMove

  S_AD_StartLog = 'Start Log';
  S_AD_NoErrorsLogged = 'No Errors Logged';
  S_AD_EndLog = 'End Log';

  {-------------------------------------------------------------------------------}
  // daADCompReg

  S_AD_RegIniFilter = 'Ini Files (*.ini)|*.ini|All files (*.*)|*.*';
  S_AD_RegTxtFilter = 'Text Files (*.txt)|*.txt|CSV Files (*.csv)|*.csv|All files (*.*)|*.*';
  S_AD_RegLogFilter = 'Log Files (*.log)|*.log|Text Files (*.txt)|*.txt|All files (*.*)|*.*';
  S_AD_RegSQLFilter = 'SQL Files (*.sql)|*.sql|All files (*.*)|*.*';
  S_AD_RegExecute = '&Execute';
  S_AD_RegValidate = '&Validate';
  S_AD_RegConnectionEditor = '&Connection Editor ...';
  S_AD_RegRdbmsNextRS = '&Next record set';
  S_AD_RegUpdSQLEditor = '&Update SQL Editor ...';
  S_AD_RegQEditor = '&Query Editor ...';
  S_AD_Executor = 'E&xecutor';
  S_AD_Explorer = '&Explorer';
  S_AD_Monitor = '&Monitor';
  S_AD_DAHome = '&da-soft Home Page';
  S_AD_About = '&About ...';

  {-------------------------------------------------------------------------------}
  // daADDatSManager

  S_AD_NotFound = '<not found>';
  S_AD_Unnamed = 'Unnamed';

  {-------------------------------------------------------------------------------}
  // daADGUIxFormsfAbout

  S_AD_ProductAbout = '%s About';

  {-------------------------------------------------------------------------------}
  // daADGUIxFormsfConnEdit

  S_AD_ParParameter = 'Parameter';
  S_AD_ParValue = 'Value';
  S_AD_ParDefault = 'Default';
  S_AD_ConnEditCaption = 'AnyDAC Connection Editor - [%s]';

  {-------------------------------------------------------------------------------}
  // daADGUIxFormsfQBldr

  S_AD_QBMainCaption = 'AnyDAC Query Builder';
  S_AD_QBInfoCaption = 'Build Query Using Drag && Drop';
  S_AD_QBBadQueryFile = 'File %s is not AnyDAC QB''s query file.';
  S_AD_QBNoColumns = 'Columns are not selected.';

  {-------------------------------------------------------------------------------}
  // daADGUIxFormsfQEdit

  S_AD_QEditCaption = 'AnyDAC Query Editor - [%s]';

  {-------------------------------------------------------------------------------}
  // daADGUIxFormsfUSEdit

  S_AD_USEditCaption = 'AnyDAC Update SQL Editor - [%s]';
  S_AD_USEditCantEdit = 'Cannot edit TADUpdateSQL - connection is undefined';

  {-------------------------------------------------------------------------------}
  // daADGUIxFormsQBldrCtrls

  S_AD_QBldrGrdShow = 'Show';
  S_AD_QBldrGrdGroup = 'Group';
  S_AD_QBldrMinBtnHint = 'Minimize / Restore';
  S_AD_QBldrCloseBtnHint = 'Close';
  S_AD_QBldrSelectAllCapt = 'Select All';
  S_AD_QBldrUnSelectAllCapt = 'Unselect All';
  S_AD_QBldrUnlinkCapt = 'Unlink';
  S_AD_QBldrCloseCapt = 'Close';
  S_AD_QBldrLinkOptsCapt = 'Link options';
  S_AD_QBldrFieldCapt = 'Field';
  S_AD_QBldrTableCapt = 'Table';
  S_AD_QBldrSortCapt = 'Sort';
  S_AD_QBldrFunctionCapt = 'Function';
  S_AD_QBldrRemoveCapt = 'Remove';
  S_AD_QBldrNoFunctionCapt = 'No function';
  S_AD_QBldrAverageCapt = 'Average';
  S_AD_QBldrCountCapt = 'Count';
  S_AD_QBldrMaximumCapt = 'Maximum';
  S_AD_QBldrMinimumCapt = 'Minimum';
  S_AD_QBldrSumCapt = 'Sum';
  S_AD_QBldrNoSortCapt = 'No Sort';
  S_AD_QBldrAscendingCapt = 'Ascending';
  S_AD_QBldrDescendingCapt = 'Descending';

  {-------------------------------------------------------------------------------}
  // daADMoniIndyBase

  S_AD_MonNoConnection = 'No connection';
  S_AD_MonEncounterType = 'Ecounter unexpected parameter type';
  S_AD_MonEncounterParamName = 'Ecounter unexpected parameter name';
  S_AD_MonEncounterBlock = 'Ecounter unexpected block of parameters';

  {-------------------------------------------------------------------------------}
  // daADPhysManager

  S_AD_PhysPackNotLoaded = 'driver [%s] package is not loaded';
  S_AD_PhysNotLinked = 'driver [%s] main unit is not linked';

implementation

end.
