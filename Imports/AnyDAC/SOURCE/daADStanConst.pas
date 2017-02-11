{-------------------------------------------------------------------------------}
{ AnyDAC constants                                                              }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit daADStanConst;

interface

uses
  Messages, daADStanIntf;

const
  // EOL's
  C_AD_WinEOL = #13#10;
  C_AD_UnixEOL = #13;
  C_AD_MacEOL = #10;
{$IFDEF MSWINDOWS}
  C_AD_EOL = C_AD_WinEOL;
{$ENDIF}
{$IFDEF LINUX}
  C_AD_EOL = C_AD_UnixEOL;
{$ENDIF}

  // Common
  C_AD_WM_Base  = WM_USER + 1000;
  C_AD_MaxDlp2StrSize = 255;
  C_AD_MaxDlp4StrSize = 8192;
  C_AD_GUIDStrLen = 38;
  C_AD_MaxNameLen = 128;

  // Layer ID's
  S_AD_LStan = 'Stan';
  S_AD_LStan_PEval = 'Eval';
  S_AD_LStan_PDef = 'Def';
  S_AD_LGUIx = 'GUIx';
  S_AD_LGUIx_PForms = 'Forms';
  S_AD_LGUIx_PSrvc = 'Services';
  S_AD_LMoni = 'Moni';
  S_AD_LMoni_PIndy = 'Indy';
  S_AD_LMoni_PFF = 'FlatFile';
  S_AD_LDatS = 'DatS';
  S_AD_LPhys = 'Phys';
  S_AD_LDApt = 'DApt';
  S_AD_LComp = 'Comp';
  S_AD_LComp_PClnt = 'Clnt';
  S_AD_LComp_PDS = 'DS';
  S_AD_LComp_PDM = 'DM';

  // Driver ID's
  S_AD_DBXId = 'DBX';
  S_AD_TDBXId = 'TDBX';
  S_AD_ODBCId = 'ODBC';
  S_AD_MSSQLId = 'MSSQL';
  S_AD_MSSQL2000Id = 'MSSQL2000';
  S_AD_MSSQL2005Id = 'MSSQL2005';
  S_AD_MSAccId = 'MSAcc';
  S_AD_DB2Id = 'DB2';
  S_AD_MySQLId = 'MySQL';
  S_AD_OraId = 'Ora';
  S_AD_ASAId = 'ASA';
  S_AD_ADSId = 'ADS';

  S_AD_DBExpPack = 'DBExp';
  S_AD_OraclPack = 'Oracl';
  S_AD_PhysPack = 'daADPhys';

  // Monitor ID's and parameters
  S_AD_MoniFlatFile = 'FlatFile';
  S_AD_MoniIndy = 'Indy';
  S_AD_MoniCustom = 'Custom';
  S_AD_MoniInIDE = 'MonitorInDelphiIDE';
  S_AD_MoniCategories = 'MonitorCategories';
  S_AD_MoniIndyHost = 'MonitorByIndy_Host';
  S_AD_MoniIndyPort = 'MonitorByIndy_Port';
  S_AD_MoniIndyTimeout = 'MonitorByIndy_Timeout';
  S_AD_MoniFlatFileName = 'MonitorByFlatFile_FileName';
  S_AD_MoniFlatFileAppend = 'MonitorByFlatFile_Append';

  // Definition standard parameters
  S_AD_DefinitionParam_Common_Name = 'Name';
  S_AD_DefinitionParam_Common_Parent = 'Parent';
  S_AD_DefinitionParam_Common_ConnectionDef = 'ConnectionDef';

  // Driver definition parameters
  C_AD_DrvBaseId = 'BaseDriverID';
  C_AD_DrvPackage = 'Package';

  S_AD_DirtyRead = 'DirtyRead';
  S_AD_ReadCommitted = 'ReadCommited';
  S_AD_RepeatRead = 'RepeatableRead';
  S_AD_Serializible = 'Serializible';

  C_AD_PhysManagerShutdownTimeout = 10000; 

  // Connection definition standard parameters
  S_AD_ConnParam_Common_Settings = 'AnyDACSettings';
  S_AD_ConnParam_Common_DriverID = 'DriverID';
  S_AD_ConnParam_Common_Database = 'Database';
  S_AD_ConnParam_Common_UserName = 'User_Name';
  S_AD_ConnParam_Common_BDEStyleUserName = 'User name';
  S_AD_ConnParam_Common_Password = 'Password';
  S_AD_ConnParam_Common_NewPassword = 'NewPassword';
  S_AD_ConnParam_Common_Pooled = 'Pooled';
  S_AD_ConnParam_Common_VendorLib = 'VendorLib';
  S_AD_ConnParam_Common_VendorHome = 'VendorHome';
  S_AD_ConnParam_Common_MetaDefSchema = 'MetaDefSchema';
  S_AD_ConnParam_Common_MetaDefCatalog = 'MetaDefCatalog';
  S_AD_ConnParam_Common_RDBMSKind = 'RDBMS';
  S_AD_ConnParam_Common_Transisolation = 'TransIsolation';
  S_AD_ConnParam_Common_MonitorBy = 'MonitorBy';
  S_AD_ConnParam_Common_LoginTimeout = 'LoginTimeout';
  S_AD_ConnParam_Common_AllowReconnect = 'AllowReconnect';

  // MySQL parameters
  S_AD_ConnParam_MySQL_Host = 'Host';
  S_AD_ConnParam_MySQL_Port = 'Port';
  S_AD_ConnParam_MySQL_Compress = 'Compress';
  S_AD_ConnParam_MySQL_UseSSL = 'UseSSL';
  S_AD_ConnParam_MySQL_Autocommit = 'AutoCommit';
  S_AD_ConnParam_MySQL_CharacterSet = 'CharacterSet';
  S_AD_ConnParam_MySQL_Utf8Mapping = 'Utf8Mapping';
  S_AD_ConnParam_MySQL_ResultMode = 'ResultMode';
  S_AD_ConnParam_MySQL_MaxAllowedPacket = 'MaxAllowedPacket';

  // Base ODBC parameters
  S_AD_ConnParam_ODBC_Advanced = 'ODBCAdvanced';

  // MSSQL paramaters
  S_AD_ConnParam_MSSQL_Server = 'Server';
  S_AD_ConnParam_MSSQL_Network = 'Network';
  S_AD_ConnParam_MSSQL_Address = 'Address';
  S_AD_ConnParam_MSSQL_App = 'App';
  S_AD_ConnParam_MSSQL_Workstation = 'Workstation';
  S_AD_ConnParam_MSSQL_OSAuthentication = 'OSAuthent';
  S_AD_ConnParam_MSSQL_Language = 'Language';
  S_AD_ConnParam_MSSQL_Encrypt = 'Encrypt';

  // MSAccess parameters
  S_AD_ConnParam_MSAcc_SysDB = 'SystemDB';
  S_AD_ConnParam_MSAcc_RO = 'ReadOnly';

  // ASA parameters
  S_AD_ConnParam_ASA_Server = 'EngineName';
  S_AD_ConnParam_ASA_DatabaseFile = 'DatabaseFile';
  S_AD_ConnParam_ASA_Compress = 'Compress';
  S_AD_ConnParam_ASA_OSAuthentication = S_AD_ConnParam_MSSQL_OSAuthentication;
  S_AD_ConnParam_ASA_App = S_AD_ConnParam_MSSQL_App;
  S_AD_ConnParam_ASA_Encrypt = S_AD_ConnParam_MSSQL_Encrypt;

  // ADS parameters
  S_AD_ConnParam_ADS_DefaultType = 'DefaultType';
  S_AD_ConnParam_ADS_ServerTypes = 'ServerTypes';
  S_AD_ConnParam_ADS_Locking = 'AdvantageLocking';

  // ODBC parameters
  S_AD_ConnParam_ODBC_Driver = 'Driver';
  S_AD_ConnParam_ODBC_DataSource = 'DataSource';

  // Oracle parameters
  S_AD_ConnParam_Oracl_AuthMode = 'AuthMode';
  S_AD_ConnParam_Oracl_Autocommit = 'AutoCommit';
//  S_AD_ConnParam_Oracl_Distributed = 'Distributed';
//  S_AD_ConnParam_Oracl_SrvIntName = 'Dist_SrvIntName';
  S_AD_ConnParam_Oracl_PieceSize = 'PieceSize';
  S_AD_ConnParam_Oracl_BytesPerChar = 'BytesPerChar';
  S_AD_ConnParam_Oracl_BoolValues = 'BooleanValues';
  S_AD_ConnParam_Oracl_SQL_TRACE = 'SQLTrace';
  S_AD_ConnParam_Oracl_OPTIMIZER_GOAL = 'OptimizerGoal';
  S_AD_ConnParam_Oracl_HASH_JOIN_ENABLED = 'HashJoinEnabled';

  // Async exec messages
  C_AD_WM_ASYNC_DONE         = C_AD_WM_Base + 1;
  // Monitor
  C_AD_WM_MoniMainFrmRunning = C_AD_WM_Base + 10;

  // Pool definition parameters
  S_AD_PoolParam_WorkerTimeout = 'POOL_WorkerTimeout';
  S_AD_PoolParam_MaxWaitForItemTime = 'POOL_MaxWaitForItemTime';
  S_AD_PoolParam_GCLatencyPeriod = 'POOL_GCLatencyPeriod';
  S_AD_PoolParam_MaximumItems = 'POOL_MaximumItems';
  S_AD_PoolParam_OptimalItems = 'POOL_OptimalItems';
  S_AD_PoolParam_PoolGrowDelta = 'POOL_PoolGrowDelta';

  // Pool default values
  C_AD_MaxWaitForItemTime = 10000;
  C_AD_GCLatencyPeriod = 30000;
  C_AD_WorkerTimeout = 100;
  C_AD_MaximumItems = 50;
  C_AD_OptimalItems = 10;
  C_AD_PoolGrowDelta = 10;

  // Command generator
  C_AD_CmdGenRight = 60;
  C_AD_CmdGenAlias = 'A';

  // Definition related
  S_AD_DefCfgFileName = 'ADConnectionDefs.ini';
  S_AD_DefDrvFileName = 'ADDrivers.ini';
  S_AD_CfgKeyName = '\Software\da-soft\AnyDAC';
  S_AD_CfgValName = 'ConnectionDefFile';
  S_AD_DrvValName = 'DriverFile';
  S_AD_MoniValName = 'MonitorPath';
  S_AD_ExplValName = 'ExplorerPath';
  S_AD_ExecValName = 'ExecutorPath';
  S_AD_Profiles = 'Profiles';
  S_AD_Drivers = 'Drivers';
  S_AD_True = 'True';
  S_AD_False = 'False';
  S_AD_Yes = 'Yes';
  S_AD_No = 'No';
  S_AD_Bools: array[Boolean] of String = (S_AD_False, S_AD_True);
  S_AD_DefBoolValues = '0;1';
  S_AD_Local = '<LOCAL>';

  // Wait default values
  C_AD_HideCursorDelay = 50;
  C_AD_DelayBeforeFWait = 200;

  // Monitor default values
  C_AD_MonitorPort = 8050;
  C_AD_MonitorTimeout = 1000;
  C_AD_MonitorFileName = 'AnyDAC$(RAND).TRC';
  C_AD_MonitorAppend = False;

  // Schema
  C_AD_InvariantDataTypes = [dtRowSetRef, dtCursorRef, dtRowRef, dtArrayRef, dtParentRowRef];
  C_AD_BlobTypes = [dtBlob, dtMemo, dtWideMemo, dtHBlob, dtHBFile, dtHMemo, dtWideHMemo];
  C_AD_StrTypes = [dtAnsiString, dtWideString, dtByteString];
  C_AD_VarLenTypes = C_AD_BlobTypes + C_AD_StrTypes;
  C_AD_WideTypes = [dtWideString, dtWideMemo, dtWideHMemo];
  C_AD_NonSearchableDataTypes = C_AD_InvariantDataTypes + C_AD_BlobTypes;
  C_AD_DataTypeNames: array[TADDataType] of String = (
    'Unknown',
    'Boolean',
    'SByte', 'Int16', 'Int32', 'Int64',
    'Byte', 'UInt16', 'UInt32', 'UInt64',
    'Double', 'Currency', 'BCD', 'FmtBCD',
    'DateTime', 'Time', 'Date', 'DateTimeStamp',
    'AnsiString', 'WideString', 'ByteString',
    'Blob', 'Memo', 'WideMemo',
    'HBlob', 'HMemo', 'WideHMemo',
    'HBFile',
    'RowSetRef', 'CursorRef', 'RowRef',
      'ArrayRef', 'ParentRowRef',
    'GUID', 'Object');
  C_AD_SysNamePrefix = '_AD_';
  C_AD_SysSavepointPrefix = 'SP_';
  C_AD_MaxAggsPerView = 64;

  C_AD_CrsPctClose = 80;

  S_AD_Pi = '3.141592653589';
  C_AD_Pi =  3.1415926535897932384626433832795;

  // Some Oracle versions
  cvOracle80000 = 800000000;
  cvOracle80400 = 800040000;
  cvOracle80500 = 800050000;
  cvOracle80501 = 800050001;
  cvOracle81000 = 801000000;
  cvOracle81500 = 801050000;
  cvOracle81600 = 801060000;
  cvOracle90000 = 900010101;

  // Some MySQL versions
  mvMySQL032000 = 0320000000;
  mvMySQL032300 = 0323000000;
  mvMySQL032314 = 0323140000;
  mvMySQL032321 = 0323210000;
  mvMySQL040000 = 0400000000;
  mvMySQL040002 = 0400020000;
  mvMySQL040100 = 0401000000;
  mvMySQL040101 = 0401010000;
  mvMySQL050000 = 0500000000;
  mvMySQL050010 = 0500100000;
  mvMySQL050100 = 0501000000;
  mvMySQL050200 = 0502000000;

  // Default length's
  IDefLongSize = 0;
  IMaxPLSQLInOutLongSize = 65535;
  IDefStrSize = 255;
  IDefNumericSize = 30;

  // Default memory allocation
  IDefInrecDataSize = 8000;          // = maximum MSSQL VARCHAR length
  IDefPieceBuffLen = 32768;
  IDefRowSetSize = 50;

  // Default data type mapping
  C_AD_DefMapPrec = -1;
  C_AD_DefMapScale = -1;
  C_AD_DefMapSize = $FFFFFFFF;

  // Error codes
  er_AD_DuplicatedName = 1;
  er_AD_NameNotFound = 2;
  er_AD_ColTypeUndefined = 3;
  er_AD_NoColsDefined = 4;
  er_AD_CheckViolated = 5; // * 1-> cons name, 0-> message
  er_AD_CantBeginEdit = 6;
  er_AD_CantCreateChildView = 7;
  er_AD_RowCantBeDeleted = 8;
  er_AD_ColMBBlob = 9;
  er_AD_FixedLenDataMismatch = 10;
  er_AD_RowNotInEditableState = 11;
  er_AD_ColIsReadOnly = 12;
  er_AD_RowCantBeInserted = 13;
  er_AD_RowColMBNotNull = 14;
  er_AD_DuplicateRows = 15; // * 1-> cons name, 0-> message
  er_AD_NoMasterRow = 16; // * 1-> cons name, 0-> message
  er_AD_HasChildRows = 17; // * 1-> cons name, 0-> message
  er_AD_CantCompareRows = 18;
  er_AD_ConvIsNotSupported = 19;
  er_AD_ColIsNotSearchable = 20;
  er_AD_RowMayHaveSingleParent = 21;
  er_AD_CantOperateInvObj = 22;
  er_AD_CantSetParentRow = 23;
  er_AD_RowIsNotNested = 24;
  er_AD_ColumnIsNotRef = 25;
  er_AD_ColumnIsNotSetRef = 26;
  er_AD_OperCNBPerfInState = 28;
  er_AD_CantSetUpdReg = 29;
  er_AD_TooManyAggs = 30;
  er_AD_GrpLvlExceeds = 31;
  er_AD_VarLenDataMismatch = 32;
  er_AD_BadForeignKey = 33;
  er_AD_BadUniqueKey = 34;
  er_AD_CantChngColType = 35;
  er_AD_BadRelation = 36;
  er_AD_CantCreateParentView = 37;
  er_AD_CantChangeTableStruct = 38;
  er_AD_FoundCascadeLoop = 39;
  er_AD_RecLocked = 40;
  er_AD_RecNotLocked = 41;
  er_AD_TypeIncompat = 42;

  er_AD_ColumnDoesnotFound = 100;
  er_AD_ExprTermination = 101;
  er_AD_ExprMBAgg = 102;
  er_AD_ExprCantAgg = 103;
  er_AD_ExprTypeMis = 104;
  er_AD_ExprIncorrect = 105;
  er_AD_InvalidKeywordUse = 106;
  er_AD_ExprInvalidChar = 107;
  er_AD_ExprNameError = 108;
  er_AD_ExprStringError = 109;
  er_AD_ExprNoLParen = 110;
  er_AD_ExprNoRParenOrComma = 111;
  er_AD_ExprNoRParen = 112;
  er_AD_ExprEmptyInList = 113;
  er_AD_ExprExpected = 114;
  er_AD_ExprNoArith = 115;
  er_AD_ExprBadScope = 116;
  er_AD_ExprEmpty = 117;
  er_AD_ExprEvalError = 118;

  er_AD_DSNoNookmark = 200;
  er_AD_DSViewNotSorted = 201;
  er_AD_DSNoAdapter = 202;
  er_AD_DSNoNestedMasterSource = 203;
  er_AD_DSCircularDataLink = 204;
  er_AD_DSRefreshError = 205;
  er_AD_DSNoDataTable = 206;
  er_AD_DSIndNotFound = 207;
  er_AD_DSAggNotFound = 208;
  er_AD_DSIndNotComplete = 209;
  er_AD_DSAggNotComplete = 210;
  er_AD_DSRefreshError2 = 211;

  er_AD_DefCircular = 250;
  er_AD_DefRO = 251;
  er_AD_DefCantMakePers = 252;
  er_AD_DefAlreadyLoaded = 253;
  er_AD_DefNotExists = 254;
  er_AD_DefDupName = 255;

  er_AD_AccSrvNotFound = 300;
  er_AD_AccCantSaveCfgFileName = 301;
  er_AD_AccSrvMBConnected = 302;
  er_AD_AccCapabilityNotSup = 303;
  er_AD_AccTxMBActive = 304;
  er_AD_AccCantChngCommandState = 305;
  er_AD_AccCommandMBFilled = 306;
  er_AD_AccSrvrIntfMBAssignedS = 307;
  er_AD_AccCmdMHRowSet = 308;
  er_AD_AccCmdMBPrepared = 309;
  er_AD_AccCantExecCmdWithRowSet = 310;
  er_AD_AccCmdMBOpen4Fetch = 311;
  er_AD_AccExactFetchMismatch = 312;
  er_AD_AccMetaInfoMismatch = 313;
  er_AD_AccCantLoadLibrary = 314;
  er_AD_AccCantGetLibraryEntry = 315;
  er_AD_AccSrvMBDisConnected = 316;
  er_AD_AccToManyLogins = 317;
  er_AD_AccCantOperDrv = 318;
  er_AD_AccDrvPackEmpty = 319;
  er_AD_AccDrvMngrMB = 320;
  er_AD_AccPrepMissed = 321;
  er_AD_AccPrepParamNotDef = 322;
  er_AD_AccPrepTooLongIdent = 323;
  er_AD_AccPrepUnknownEscape = 324;
  er_AD_AccParamArrayMismatch = 325;
  er_AD_AccAsyncOperInProgress = 326;
  er_AD_AccEscapeIsnotSupported = 327;
  er_AD_AccMetaInfoReset = 328;
  er_AD_AccWhereIsEmpty = 329;
  er_AD_AccUpdateTabUndefined = 330;
  er_AD_AccNameHasErrors = 331;
  er_AD_AccEscapeBadSyntax = 332;
  er_AD_AccDrvIsNotReg = 333;
  er_AD_AccShutdownTO = 334;
  er_AD_AccParTypeUnknown = 335;
  er_AD_AccParDataMapNotSup = 336;
  er_AD_AccColDataMapNotSup = 337;
  er_AD_AccParDefChanged = 338;
  er_AD_AccMetaInfoNotDefined = 339;
  er_AD_AccSrvNotDefined = 340;


  er_AD_DAptRecordIsDeleted = 400;
  er_AD_DAptRecordIsLocked = 401;
  er_AD_DAptNoSelectCmd = 402;
  er_AD_DAptApplyUpdateFailed = 404;
  er_AD_DAptCantEdit = 405;
  er_AD_DAptCantInsert = 406;
  er_AD_DAptCantDelete = 407;

  er_AD_ClntSessMBSingle = 500;
  er_AD_ClntSessMBInactive = 501;
  er_AD_ClntSessMBActive = 502;
  er_AD_ClntDbDupName = 503;
  er_AD_ClntDbMBInactive = 504;
  er_AD_ClntDbMBActive = 505;
  er_AD_ClntDbLoginAborted = 506;
  er_AD_ClntDbCantConnPooled = 507;
  er_AD_ClntDBNotFound = 508;
  er_AD_ClntAdaptMBActive = 509;
  er_AD_ClntAdaptMBInactive = 510;
  er_AD_ClntNotCachedUpdates = 511;
  er_AD_ClntDbNotDefined = 512;

  er_AD_DPNoAscFld = 600;
  er_AD_DPNoSrcDS = 601;
  er_AD_DPNoDestDS = 602;
  er_AD_DPNoAscDest = 603;
  er_AD_DPNoAscSrc = 604;
  er_AD_DPBadFixedSize = 605;
  er_AD_DPAscFldDup = 606;
  er_AD_DPBadAsciiFmt = 607;
  er_AD_DPSrcUndefined = 608;

  er_AD_StanTimeout = 700;
  er_AD_StanCantGetBlob = 701;
  er_AD_StanPoolMBInactive = 702;
  er_AD_StanPoolMBActive = 703;
  er_AD_StanCantNonblocking = 705;
  er_AD_StanMacroNotFound = 706;
  er_AD_StanBadParRowIndex = 707;
  er_AD_StanPoolAcquireTimeout = 708;
  er_AD_StanMgrRequired = 709;

  er_AD_DBXGeneral = 1000;
  er_AD_DBXParMBNotEmpty = 1001;
  er_AD_DBXNoDriverCfg = 1002;

  er_AD_MySQLGeneral = 1100;
  er_AD_MySQLBadVersion = 1101;
  er_AD_MySQLCantSetPort = 1102;
  er_AD_MySQLBadParams = 1103;
  er_AD_MySQLCantInitEmbeddedServer = 1104;

  er_AD_OdbcGeneral = 1200;
  er_AD_OdbcDataToLarge = 1201;
  er_AD_OdbcVarDataTypeUnsup = 1202;
  er_AD_OdbcParamArrMismatch = 1203;

  er_AD_OraGeneral = 1300;
  er_AD_OraNoCursor = 1305;
  er_AD_OraCantAssFILE = 1307;
  er_AD_OraNoCursorParams = 1308;
  er_AD_OraNotInstalled = 1309;
  er_AD_OraBadVersion = 1310;
  er_AD_OraOutOfCount = 1312;
  er_AD_OraBadValueSize = 1313;
  er_AD_OraBadArrayLen = 1314;
  er_AD_OraBadValueType = 1315;
  er_AD_OraUnsupValueType = 1316;
  er_AD_OraDataToLarge = 1317;
  er_AD_OraVarWithoutStmt = 1318;
  er_AD_OraBadVarType = 1319;
  er_AD_OraUndefPWVar = 1320;
  er_AD_OraBadTypePWVar = 1321;
  er_AD_OraTooLongGTRID = 1323;
  er_AD_OraTooLongBQUAL = 1324;
  er_AD_OraTooLongTXName = 1325;
  er_AD_OraDBTNManyClBraces = 1326;
  er_AD_OraNotPLSQLObj = 1327;
  er_AD_OraPLSQLObjNameEmpty = 1328;
  er_AD_OraNotPackageProc = 1329;
  er_AD_OraBadTableType = 1330;
  er_AD_OraUnNamedRecParam = 1331;

implementation

end.
