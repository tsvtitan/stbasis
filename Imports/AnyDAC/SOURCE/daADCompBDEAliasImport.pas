{ ----------------------------------------------------------------------------- }
{ AnyDAC BDE Aliases Importer                                                   }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{ ----------------------------------------------------------------------------- }
{$I daAD.inc}

unit daADCompBDEAliasImport;

interface

uses
  Classes, 
  daADStanIntf, daADStanConst, daADStanOption;

type
  TADAliasImportOverwriteEvent = procedure (const AName: String;
    var AOverwrite: Integer) of object;
  TADBDEAliasImporter = class(TObject)
  private
    FSrcParams: TStringList;
    FDestParams: TStrings;
    FFetch: TADFetchOptions;
    FFmt: TADFormatOptions;
    FUpd: TADUpdateOptions;
    FRes: TADResourceOptions;
    FConnectionDefFileName: String;
    FOverwriteDefs: Boolean;
    FAliasesToImport: TStringList;
    FOnOverwrite: TADAliasImportOverwriteEvent;
    function GetSrcBool(const AName: String; var AResult: Boolean): Boolean;
    function GetSrcInt(const AName: String; var AResult: Integer): Boolean;
    function GetSrcStr(const AName: String; var AResult: String): Boolean;
    procedure ImportSQLCommon;
    procedure ImportOracle(AImportMode: Boolean);
    procedure ImportMSSQL(AImportMode: Boolean);
    procedure ImportMSAccess(AImportMode: Boolean);
    procedure ImportODBC(AImportMode: Boolean);
    procedure ImportDB2(AImportMode: Boolean);
    procedure ImportMySQL(AImportMode: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Execute;
    procedure MakeBDECompatible(
      const AConnectionDef: IADStanConnectionDef; AEnableBCD, AEnableInteger: Boolean);
    property ConnectionDefFileName: String read FConnectionDefFileName
      write FConnectionDefFileName;
    property AliasesToImport: TStringList read FAliasesToImport;
    property OverwriteDefs: Boolean read FOverwriteDefs write FOverwriteDefs;
    property OnOverwrite: TADAliasImportOverwriteEvent read FOnOverwrite
      write FOnOverwrite;
  end;

implementation

uses
  SysUtils, DBTables, BDE,
  daADStanFactory, daADStanResStrs,
  daADPhysIntf, TypInfo;

const
  S_OpenODBC = 'OpenODBC';
  DRIVERNAME_KEY = 'DriverName';

{-------------------------------------------------------------------------------}
function TADBDEAliasImporter.GetSrcBool(const AName: String; var AResult: Boolean): Boolean;
var
  i: Integer;
begin
  i := FSrcParams.IndexOfName(AName);
  Result := i <> -1;
  AResult := False;
  if Result then
    AResult := CompareText(FSrcParams.Values[AName], S_AD_True) = 0;
end;

{-------------------------------------------------------------------------------}
function TADBDEAliasImporter.GetSrcInt(const AName: String; var AResult: Integer): Boolean;
var
  i: Integer;
begin
  i := FSrcParams.IndexOfName(AName);
  Result := i <> -1;
  AResult := 0;
  if Result then
    AResult := StrToInt(FSrcParams.Values[AName]);
end;

{-------------------------------------------------------------------------------}
function TADBDEAliasImporter.GetSrcStr(const AName: String; var AResult: String): Boolean;
var
  i: Integer;
begin
  i := FSrcParams.IndexOfName(AName);
  Result := i <> -1;
  AResult := '';
  if Result then
    AResult := FSrcParams.Values[AName];
end;

{-------------------------------------------------------------------------------}
procedure TADBDEAliasImporter.ImportSQLCommon;
var
  sVal: String;
  iVal: Integer;
  lVal: Boolean;
begin
  if GetSrcInt(szROWSETSIZE, iVal) and (iVal <> 20) then
    FFetch.RowsetSize := iVal;
  if GetSrcInt(szBLOBCOUNT, iVal) and (iVal = 0) then
    if iVal > 0 then
      FFetch.Cache := FFetch.Cache + [fiBlobs]
    else
      FFetch.Cache := FFetch.Cache - [fiBlobs];
  if GetSrcBool(szENABLESCHEMACACHE, lVal) then
    if lVal then
      FFetch.Cache := FFetch.Cache + [fiMeta]
    else
      FFetch.Cache := FFetch.Cache - [fiMeta];
  if GetSrcInt(szMAXROWS, iVal) and (iVal <> -1) then
    FFetch.RecsMax := iVal;
  if GetSrcStr(szPASSWORD, sVal) and (sVal <> '') then
    FDestParams.Values[S_AD_ConnParam_Common_Password] := sVal;
  if (GetSrcStr(szUSERNAME, sVal) or GetSrcStr(UpperCase(S_AD_ConnParam_Common_BDEStyleUserName), sVal)) and
     (sVal <> '') then
    FDestParams.Values[S_AD_ConnParam_Common_UserName] := sVal;
  if GetSrcInt(szCFGDRVTRACEMODE, iVal) and (iVal > 0) then begin
    if iVal <> 0 then
      sVal := S_AD_MoniIndy
    else
      sVal := '';
    FDestParams.Values[S_AD_ConnParam_Common_MonitorBy] := sVal;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADBDEAliasImporter.ImportOracle(AImportMode: Boolean);
var
  sVal: String;
  lVal: Boolean;
begin
  if AImportMode then
    FDestParams.Values[S_AD_ConnParam_Common_DriverID] := S_AD_OraId;
  FFmt.OwnMapRules := True;
  FFmt.MaxBcdPrecision := $7FFFFFFF;
  FFmt.MaxBcdScale := $7FFFFFFF;
  if GetSrcBool(szORAINTEGER, lVal) and lVal then begin
    with FFmt.MapRules.Add do begin
      SourceDataType := dtBCD;
      ScaleMin := 0;
      ScaleMax := 0;
      PrecMin := 0;
      PrecMax := 5;
      TargetDataType := dtInt16;
    end;
    with FFmt.MapRules.Add do begin
      SourceDataType := dtBCD;
      ScaleMin := 0;
      ScaleMax := 0;
      PrecMin := 6;
      PrecMax := 10;
      TargetDataType := dtInt32;
    end;
  end;
  if GetSrcBool(szCFGDBENABLEBCD, lVal) and lVal then
    with FFmt.MapRules.Add do begin
      SourceDataType := dtDouble;
      TargetDataType := dtBCD;
    end
  else
    with FFmt.MapRules.Add do begin
      SourceDataType := dtBCD;
      TargetDataType := dtDouble;
    end;
  with FFmt.MapRules.Add do begin
    SourceDataType := dtAnsiString;
    SizeMin := 256;
    TargetDataType := dtMemo;
  end;
  with FFmt.MapRules.Add do begin
    SourceDataType := dtWideString;
    SizeMax := 255;
    TargetDataType := dtAnsiString;
  end;
  with FFmt.MapRules.Add do begin
    SourceDataType := dtWideString;
    SizeMin := 256;
    TargetDataType := dtMemo;
  end;
  with FFmt.MapRules.Add do begin
    SourceDataType := dtDateTimeStamp;
    TargetDataType := dtDateTime;
  end;
  if AImportMode then begin
    if GetSrcStr(szCFGDRVVENDINIT, sVal) and (CompareText(sVal, 'OCI.DLL') <> 0) then
      FDestParams.Values[S_AD_ConnParam_Common_VendorLib] := sVal;
    if GetSrcStr(szSERVERNAME, sVal) and (sVal <> '') then
      FDestParams.Values[S_AD_ConnParam_Common_Database] := sVal;
    ImportSQLCommon;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADBDEAliasImporter.ImportMSSQL(AImportMode: Boolean);
var
  sVal: String;
  lVal: Boolean;
  iVal: Integer;
begin
  if AImportMode then
    FDestParams.Values[S_AD_ConnParam_Common_DriverID] := S_AD_MSSQL2000Id;
  FFmt.OwnMapRules := True;
  FFmt.MaxBcdPrecision := $7FFFFFFF;
  FFmt.MaxBcdScale := $7FFFFFFF;
  if GetSrcBool(szCFGDBENABLEBCD, lVal) and lVal then begin
    with FFmt.MapRules.Add do begin
      SourceDataType := dtDouble;
      ScaleMin := 1;
      TargetDataType := dtBCD;
    end;
    with FFmt.MapRules.Add do begin
      SourceDataType := dtDouble;
      ScaleMin := 1;
      PrecMax := 17;
      TargetDataType := dtBCD;
    end;
    with FFmt.MapRules.Add do begin
      SourceDataType := dtDouble;
      ScaleMin := 1;
      PrecMin := 19;
      TargetDataType := dtBCD;
    end;
  end
  else begin
    with FFmt.MapRules.Add do begin
      SourceDataType := dtBCD;
      PrecMin := 19;
      PrecMax := 19;
      ScaleMin := 4;
      ScaleMax := 4;
      TargetDataType := dtCurrency;
    end;
    with FFmt.MapRules.Add do begin
      SourceDataType := dtBCD;
      PrecMin := 10;
      PrecMax := 10;
      ScaleMin := 4;
      ScaleMax := 4;
      TargetDataType := dtCurrency;
    end;
    with FFmt.MapRules.Add do begin
      SourceDataType := dtBCD;
      TargetDataType := dtDouble;
    end;
  end;
  with FFmt.MapRules.Add do begin
    SourceDataType := dtDateTimeStamp;
    TargetDataType := dtDateTime;
  end;
  if AImportMode then begin
    if GetSrcInt(szMAXQUERYTIME, iVal) and (iVal <> $7FFFFFFF) then
      FRes.AsyncCmdTimeout := iVal * 1000;
    if GetSrcStr(szSYBLAPP, sVal) and (sVal <> '') then
      FDestParams.Values[S_AD_ConnParam_MSSQL_App] := sVal;
    if GetSrcStr(szDATABASENAME, sVal) and (sVal <> '') then
      FDestParams.Values[S_AD_ConnParam_Common_Database] := sVal;
    if GetSrcStr(szSYBLHOST, sVal) and (sVal <> '') then
      FDestParams.Values[S_AD_ConnParam_MSSQL_Address] := sVal;
    if GetSrcStr(szSYBLNATLANG, sVal) and (sVal <> '') then
      FDestParams.Values[S_AD_ConnParam_MSSQL_Language] := sVal;
    if GetSrcStr(szSERVERNAME, sVal) and (sVal <> '') then
      FDestParams.Values[S_AD_ConnParam_MSSQL_Server] := sVal;
    ImportSQLCommon;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADBDEAliasImporter.ImportMSAccess(AImportMode: Boolean);
var
  sVal: String;
begin
  if AImportMode then
    FDestParams.Values[S_AD_ConnParam_Common_DriverID] := S_AD_MSAccId;
  FFmt.OwnMapRules := True;
  FFmt.MaxBcdPrecision := $7FFFFFFF;
  FFmt.MaxBcdScale := $7FFFFFFF;
  with FFmt.MapRules.Add do begin
    SourceDataType := dtBCD;
    PrecMin := 19;
    PrecMax := 19;
    ScaleMin := 4;
    ScaleMax := 4;
    TargetDataType := dtCurrency;
  end;
  with FFmt.MapRules.Add do begin
    SourceDataType := dtBCD;
    PrecMin := 10;
    PrecMax := 10;
    ScaleMin := 4;
    ScaleMax := 4;
    TargetDataType := dtCurrency;
  end;
  with FFmt.MapRules.Add do begin
    SourceDataType := dtBCD;
    TargetDataType := dtDouble;
  end;
  with FFmt.MapRules.Add do begin
    SourceDataType := dtDateTimeStamp;
    TargetDataType := dtDateTime;
  end;
  if AImportMode then begin
    if GetSrcStr(szDATABASENAME, sVal) and (sVal <> '') then
      FDestParams.Values[S_AD_ConnParam_Common_Database] := sVal;
    if GetSrcStr(szCFGSYSTEMDB, sVal) and (sVal <> '') then
      FDestParams.Values[S_AD_ConnParam_MSAcc_SysDB] := sVal;
    if GetSrcStr(szUSERNAME, sVal) and (sVal <> '') then
      FDestParams.Values[S_AD_ConnParam_Common_UserName] := sVal;
    if GetSrcStr(szPASSWORD, sVal) and (sVal <> '') then
      FDestParams.Values[S_AD_ConnParam_Common_Password] := sVal;
    if GetSrcStr(szOPENMODE, sVal) and (CompareText(sVal, szREADONLY) = 0) then
      FDestParams.Values[S_AD_ConnParam_MSAcc_RO] := S_AD_True;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADBDEAliasImporter.ImportDB2(AImportMode: Boolean);
var
  sVal: String;
  lVal: Boolean;
  iVal: Integer;
begin
  if AImportMode then
    FDestParams.Values[S_AD_ConnParam_Common_DriverID] := S_AD_DB2Id;
  FFmt.OwnMapRules := True;
  FFmt.MaxBcdPrecision := $7FFFFFFF;
  FFmt.MaxBcdScale := $7FFFFFFF;
  if not (GetSrcBool(szCFGDBENABLEBCD, lVal) and lVal) then
    with FFmt.MapRules.Add do begin
      SourceDataType := dtBCD;
      TargetDataType := dtDouble;
    end;
  with FFmt.MapRules.Add do begin
    SourceDataType := dtDateTimeStamp;
    TargetDataType := dtDateTime;
  end;
  with FFmt.MapRules.Add do begin
    SourceDataType := dtWideString;
    TargetDataType := dtBlob;
  end;
  if AImportMode then begin
    if GetSrcInt(szMAXQUERYTIME, iVal) and (iVal <> $7FFFFFFF) then
      FRes.AsyncCmdTimeout := iVal * 1000;
    if GetSrcStr('DB2 DSN', sVal) and (sVal <> '') then
      FDestParams.Values[S_AD_ConnParam_Common_Database] := sVal;
    ImportSQLCommon;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADBDEAliasImporter.ImportMySQL(AImportMode: Boolean);
begin
  // ??? in BDE MySQL was supported through ODBC
  ImportODBC(AImportMode);
end;

{-------------------------------------------------------------------------------}
procedure TADBDEAliasImporter.ImportODBC(AImportMode: Boolean);
var
  sDrv, sVal: String;
  lVal: Boolean;
begin
  if GetSrcStr(szCFGODBCDSN, sVal) then begin
    // ??? Get RDBMS kind. If MySQL then Import to MySQL.
    // Else set S_AD_ConnParam_Common_RDBMSKind value.
  end;
  if AImportMode then
    FDestParams.Values[S_AD_ConnParam_Common_DriverID] := S_AD_ODBCId;
  FFmt.OwnMapRules := True;
  FFmt.MaxBcdPrecision := $7FFFFFFF;
  FFmt.MaxBcdScale := $7FFFFFFF;
  if GetSrcBool(szCFGDBENABLEBCD, lVal) and lVal then begin
    with FFmt.MapRules.Add do begin
      SourceDataType := dtDouble;
      ScaleMin := 1;
      TargetDataType := dtBCD;
    end;
    with FFmt.MapRules.Add do begin
      SourceDataType := dtDouble;
      ScaleMin := 1;
      PrecMax := 17;
      TargetDataType := dtBCD;
    end;
    with FFmt.MapRules.Add do begin
      SourceDataType := dtDouble;
      ScaleMin := 1;
      PrecMin := 19;
      TargetDataType := dtBCD;
    end;
    with FFmt.MapRules.Add do begin
      SourceDataType := dtBCD;
      ScaleMin := 0;
      ScaleMax := 0;
      PrecMin := 18;
      PrecMax := 18;
      TargetDataType := dtDouble;
    end;
  end
  else
    with FFmt.MapRules.Add do begin
      SourceDataType := dtBCD;
      TargetDataType := dtDouble;
    end;
  with FFmt.MapRules.Add do begin
    SourceDataType := dtDateTimeStamp;
    TargetDataType := dtDateTime;
  end;
  if AImportMode then begin
    if GetSrcStr(szTYPe, sVal) and (sVal <> '') then
      FDestParams.Values[S_AD_ConnParam_ODBC_Driver] := sVal;
    if GetSrcStr(szCFGODBCDSN, sVal) and (sVal <> '') then
      FDestParams.Values[S_AD_ConnParam_ODBC_DataSource] := sVal;
    if GetSrcStr(szDATABASENAME, sVal) and (sVal <> '') then
      FDestParams.Values[S_AD_ConnParam_Common_Database] := sDrv;
    ImportSQLCommon;
  end;
end;

{-------------------------------------------------------------------------------}
constructor TADBDEAliasImporter.Create;
begin
  inherited Create;
  FAliasesToImport := TStringList.Create;
{$IFDEF AnyDAC_D6}
  FAliasesToImport.CaseSensitive := False;
{$ENDIF}
  FAliasesToImport.Sorted := True;
  FAliasesToImport.Duplicates := dupAccept;
end;

{-------------------------------------------------------------------------------}
destructor TADBDEAliasImporter.Destroy;
begin
  FreeAndNil(FAliasesToImport);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADBDEAliasImporter.MakeBDECompatible(
  const AConnectionDef: IADStanConnectionDef; AEnableBCD, AEnableInteger: Boolean);
var
  sType, sDrv: String;
begin
  FSrcParams := TStringList.Create;
{$IFDEF AnyDAC_D6}
  FSrcParams.CaseSensitive := False;
{$ENDIF}
  FSrcParams.Sorted := True;
  FSrcParams.Duplicates := dupAccept;
  if AEnableBCD then
    FSrcParams.Add(szCFGDBENABLEBCD + '=' + UpperCase(S_AD_True));
  if AEnableInteger then
    FSrcParams.Add(szORAINTEGER + '=' + UpperCase(S_AD_True));

  FDestParams := AConnectionDef.Params;
  FFetch := TADFetchOptions.Create(nil);
  FFmt := TADFormatOptions.Create(nil);
  FUpd := TADUpdateOptions.Create(nil);
  FRes := TADResourceOptions.Create(nil);
  AConnectionDef.ReadOptions(FFmt, FUpd, FFetch, FRes);

  try
    sType := AConnectionDef.DriverID;
    if CompareText(sType, S_AD_OraId) = 0 then
      ImportOracle(False)
    else if CompareText(sType, S_AD_MySQLId) = 0 then
      ImportMySQL(False)
    else if CompareText(sType, S_AD_MSSQL2000Id) = 0 then
      ImportMSSQL(False)
    else if CompareText(sType, S_AD_MSAccId) = 0 then
      ImportMSAccess(False)
    else if CompareText(sType, S_AD_DB2Id) = 0 then
      ImportDB2(False)
    else if (CompareText(sType, S_AD_DBXId) = 0) or
            (CompareText(sType, S_AD_TDBXId) = 0) then begin
      sType := UpperCase(AConnectionDef.AsString[S_AD_ConnParam_Common_RDBMSKind]);
      sDrv := UpperCase(AConnectionDef.AsString[DRIVERNAME_KEY]);
      if (sType = C_AD_PhysRDBMSKinds[mkMSSQL]) and (sDrv = S_OpenODBC) then
        ImportMSSQL(False)
      else if (sType = C_AD_PhysRDBMSKinds[mkMSAccess]) and (sDrv = S_OpenODBC) then
        ImportMSAccess(False)
      else if (sType = C_AD_PhysRDBMSKinds[mkDB2]) and (sDrv = S_OpenODBC) then
        ImportDB2(False)
      else if CompareText(sDrv, S_OpenODBC) = 0 then
        ImportODBC(False)
      else
        raise Exception.Create(S_AD_CantMakeConnDefBDEComp);
    end;
    AConnectionDef.WriteOptions(FFmt, FUpd, FFetch, FRes);

  finally
    FreeAndNil(FSrcParams);
    FDestParams := nil;
    FreeAndNil(FFetch);
    FreeAndNil(FFmt);
    FreeAndNil(FUpd);
    FreeAndNil(FRes);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADBDEAliasImporter.Execute;
var
  i, j: Integer;
  oAliases, oDrvParams: TStringList;
  sType, sName: String;
  oDefs: IADStanConnectionDefs;
  oDef: IADStanConnectionDef;
  iOverwrite: Integer;
begin
  oAliases := TStringList.Create;
  oDrvParams := TStringList.Create;
  FSrcParams := TStringList.Create;
{$IFDEF AnyDAC_D6}
  FSrcParams.CaseSensitive := False;
{$ENDIF}
  FSrcParams.Sorted := True;
  FSrcParams.Duplicates := dupAccept;
  FDestParams := TStringList.Create;
  FFetch := TADFetchOptions.Create(nil);
  FFmt := TADFormatOptions.Create(nil);
  FUpd := TADUpdateOptions.Create(nil);
  FRes := TADResourceOptions.Create(nil);
  ADCreateInterface(IADStanConnectionDefs, oDefs);
  if FConnectionDefFileName <> '' then
    oDefs.Storage.FileName := FConnectionDefFileName;
  oDefs.Load;
  try
    Session.GetAliasNames(oAliases);
    for i := 0 to oAliases.Count - 1 do
      if (FAliasesToImport.Count = 0) or (FAliasesToImport.IndexOf(oAliases[i]) <> -1) then begin
        FDestParams.Clear;
        sType := Session.GetAliasDriverName(oAliases[i]);
        Session.GetDriverParams(sType, oDrvParams);
        Session.GetAliasParams(oAliases[i], FSrcParams);
        for j := 0 to oDrvParams.Count - 1 do
          if FSrcParams.IndexOfName(oDrvParams.Names[j]) = -1 then
            FSrcParams.Add(oDrvParams[j]);
        if sType = C_AD_PhysRDBMSKinds[mkOracle] then
          ImportOracle(True)
        else if sType = C_AD_PhysRDBMSKinds[mkMSSQL] then
          ImportMSSQL(True)
        else if sType = C_AD_PhysRDBMSKinds[mkMSAccess] then
          ImportMSAccess(True)
        else if sType = C_AD_PhysRDBMSKinds[mkDB2] then
          ImportDB2(True)
        else if FSrcParams.IndexOfName(szCFGODBCDSN) <> -1 then
          ImportODBC(True)
        else
          Continue;
        if OverwriteDefs then begin
          oDef := oDefs.FindConnectionDef(oAliases[i]);
          if (oDef <> nil) and Assigned(FOnOverwrite) then begin
            iOverwrite := 1;
            FOnOverwrite(oAliases[i], iOverwrite);
            if iOverwrite = 0 then
              oDef := nil
            else if iOverwrite = -1 then
              Exit;
          end
        end
        else
          oDef := nil;
        if oDef = nil then
          oDef := oDefs.Add as IADStanConnectionDef;
        oDef.Params.Assign(FDestParams);
        sName := oAliases[i];
        if not OverwriteDefs then begin
          j := 0;
          while oDefs.FindConnectionDef(sName) <> nil do begin
            Inc(j);
            sName := Format('%s_%d', [oAliases[i], j]);
          end;
        end;
        oDef.Name := sName;
        oDef.WriteOptions(FFmt, FUpd, FFetch, FRes);
        oDef.MarkPersistent;
      end;
    oDefs.Save;
  finally
    FreeAndNil(oAliases);
    FreeAndNil(oDrvParams);
    FreeAndNil(FSrcParams);
    FreeAndNil(FDestParams);
    FreeAndNil(FFetch);
    FreeAndNil(FFmt);
    FreeAndNil(FUpd);
    FreeAndNil(FRes);
  end;
end;

(*
--------------------------
ALL

'TYPE'                f('DriverID') # not dbExpress
                      'DriverId = S_AD_DBXId' & 'DriverName = Oracle' # dbExpress
'DLL32'               x

--------------------------
SQL Common

'BLOB SIZE'           'BlobSize' # dbExpress
'BLOBS TO CACHE'      f('FetchOptions.Cache' & fiBlobs)
'ENABLE SCHEMA CACHE' f('FetchOptions.Cache' & fiMeta)
'LANGDRIVER'          x
'MAX ROWS'            'FetchOptions.RecsMax'
'PASSWORD'            'Password'
'SCHEMA CACHE DIR'    x
'SCHEMA CACHE SIZE'   x
'SCHEMA CACHE TIME'   x
'SQLPASSTHRU MODE'    x
'SQLQRYMODE'          x
'USER NAME'           'User_Name'
'TRACE MODE'          'Tracing'

--------------------------
Oracle

'ENABLE BCD'          f('FormatOptions.MapRules')
'ENABLE INTEGERS'     f('FormatOptions.MapRules')
'LIST SYNONYMS'       x
'NET PROTOCOL'        x
'OBJECT MODE'         x
'ROWSET SIZE'         'FetchOptions.RowsetSize' # not dbExpress
                      'RowsetSize'              # dbExpress
'SERVER NAME'         'Database'
'VENDOR INIT'         'VendorLib'

--------------------------
MSSQL

'APPLICATION NAME'    'App'=v
'BLOB EDIT LOGGING'   x
'CONNECT TIMEOUT'     x
'DATABASE NAME'       'Database'=v
'DATE MODE'           x
'ENABLE BCD'          f('FormatOptions.MapRules')
'HOST NAME'           'Address'=v
'NATIONAL LANG NAME'  'Language'=v
'MAX QUERY TIME'      'ResourceOptions.AsyncCmdTimeout'=v*1000
'SERVER NAME'         'Server'=v
'TDS PACKET SIZE'     x
'TIMEOUT'             x

--------------------------
MSAccess

'DATABASE NAME'       'DBQ'=v
'LANGDRIVER'          x
'OPEN MODE'           'ReadOnly'=READ/WRITE -> 0, READ ONLY -> 1
'SYSTEM DATABASE'     'SystemDB'=v
'USER NAME'           'UID'=v
'PASSWORD'            'PWD'=v


--------------------------
ODBC

'BATCH COUNT'         x
'DATABASE NAME'       'Database'=v
'ENABLE BCD'          f('FormatOptions.MapRules')
'ODBC DSN'            'DSN'=v
'OPEN MODE'           'ReadOnly'=READ/WRITE -> 0, READ ONLY -> 1
'ROWSET SIZE'         'FetchOptions.RowsetSize' # not dbExpress
                      'RowsetSize'              # dbExpress
*)
end.

