{-------------------------------------------------------------------------------}
{ AnyDAC Oracle metadata                                                        }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit daADPhysOraclMeta;

interface

uses
  daADStanIntf,
  daADPhysIntf, daADPhysManager, daADPhysConnMeta, daADPhysCmdGenerator;

type
  TADPhysOraMetadata = class (TADPhysConnectionMetadata)
  private
    FServerVersion, FClientVersion: LongWord;
  protected
    function GetKind: TADRDBMSKind; override;
    function GetClientVersion: LongWord; override;
    function GetServerVersion: LongWord; override;
    function GetTxSupported: Boolean; override;
    function GetTxNested: Boolean; override;
    function GetTxSavepoints: Boolean; override;
    function GetTxAutoCommit: Boolean; override;
    function GetParamNameMaxLength: Integer; override;
    function GetNameParts: TADPhysNameParts; override;
    function GetNameCaseSensParts: TADPhysNameParts; override;
    function GetNameDefLowCaseParts: TADPhysNameParts; override;
    function GetNameQuotaChar1: Char; override;
    function GetNameQuotaChar2: Char; override;
    function GetInsertBlobsAfterReturning: Boolean; override;
    function GetParamMark: TADPhysParamMark; override;
    function GetInlineRefresh: Boolean; override;
    function GetSelectWithoutFrom: Boolean; override;
    function GetAsyncAbortSupported: Boolean; override;
    function GetLockNoWait: Boolean; override;
    function GetDefValuesSupported: TADPhysDefaultValues; override;
    function InternalEscapeBoolean(const AStr: String): String; override;
    function InternalEscapeDate(const AStr: String): String; override;
    function InternalEscapeDateTime(const AStr: String): String; override;
    function InternalEscapeFloat(const AStr: String): String; override;
    function InternalEscapeFunction(const ASeq: TADPhysEscapeData): String; override;
    function InternalEscapeTime(const AStr: String): String; override;
    function InternalGetSQLCommandKind(const AToken: String): TADPhysCommandKind; override;
  public
    constructor Create(
      {$IFDEF AnyDAC_MONITOR} const AMonitor: IADMoniClient; {$ENDIF}
      const AConnection: TADPhysConnection; AServerVersion, AClientVersion: LongWord);
  end;

  TADPhysOraCommandGenerator = class(TADPhysCommandGenerator)
  private
    function GetOracleReturning(ARequest: TADPhysUpdateRequest): String;
  protected
    function GetInlineRefresh(const AStmt: String;
      ARequest: TADPhysUpdateRequest): String; override;
    function GetPessimisticLock: String; override;
    function GetSavepoint(const AName: String): String; override;
    function GetRollbackToSavepoint(const AName: String): String; override;
    function GetLastAutoGenValue(const AName: String): String; override;
    function GetSingleRowTable: String; override;
    function GetCall(const AName: String): String; override;
  end;

implementation

uses
  SysUtils, DB,
  daADStanConst, daADDatSManager, daADStanParam;

{-------------------------------------------------------------------------------}
{ TADPhysOraMetadata                                                            }
{-------------------------------------------------------------------------------}
constructor TADPhysOraMetadata.Create(
  {$IFDEF AnyDAC_MONITOR} const AMonitor: IADMoniClient; {$ENDIF}
  const AConnection: TADPhysConnection; AServerVersion, AClientVersion: LongWord);
begin
  inherited Create({$IFDEF AnyDAC_MONITOR} AMonitor, {$ENDIF} AConnection);
  FServerVersion := AServerVersion;
  FClientVersion := AClientVersion;
end;

{-------------------------------------------------------------------------------}
function TADPhysOraMetadata.GetKind: TADRDBMSKind;
begin
  Result := mkOracle;
end;

{-------------------------------------------------------------------------------}
function TADPhysOraMetadata.GetClientVersion: LongWord;
begin
  Result := FClientVersion;
end;

{-------------------------------------------------------------------------------}
function TADPhysOraMetadata.GetServerVersion: LongWord;
begin
  Result := FServerVersion;
end;

{-------------------------------------------------------------------------------}
function TADPhysOraMetadata.GetNameCaseSensParts: TADPhysNameParts;
begin
  Result := [];
end;

{-------------------------------------------------------------------------------}
function TADPhysOraMetadata.GetNameDefLowCaseParts: TADPhysNameParts;
begin
  Result := [];
end;

{-------------------------------------------------------------------------------}
function TADPhysOraMetadata.GetParamNameMaxLength: Integer;
begin
  Result := 30;
end;

{-------------------------------------------------------------------------------}
function TADPhysOraMetadata.GetNameParts: TADPhysNameParts;
begin
  Result := [npSchema, npDBLink, npBaseObject, npObject];
end;

{-------------------------------------------------------------------------------}
function TADPhysOraMetadata.GetNameQuotaChar1: Char;
begin
  Result := '"';
end;

{-------------------------------------------------------------------------------}
function TADPhysOraMetadata.GetNameQuotaChar2: Char;
begin
  Result := '"';
end;

{-------------------------------------------------------------------------------}
function TADPhysOraMetadata.GetParamMark: TADPhysParamMark;
begin
  Result := prName;
end;

{-------------------------------------------------------------------------------}
function TADPhysOraMetadata.GetTxAutoCommit: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysOraMetadata.GetTxNested: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADPhysOraMetadata.GetTxSavepoints: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysOraMetadata.GetTxSupported: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysOraMetadata.GetInsertBlobsAfterReturning: Boolean;
begin
  Result := FClientVersion < cvOracle81000;
end;

{-------------------------------------------------------------------------------}
function TADPhysOraMetadata.GetInlineRefresh: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysOraMetadata.GetSelectWithoutFrom: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADPhysOraMetadata.GetLockNoWait: Boolean;
begin
  Result := True;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysOraMetadata.GetAsyncAbortSupported: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysOraMetadata.GetDefValuesSupported: TADPhysDefaultValues;
begin
  if FServerVersion >= cvOracle90000 then
    Result := dvDef
  else
    Result := dvNone;
end;

{-------------------------------------------------------------------------------}
function TADPhysOraMetadata.InternalEscapeBoolean(
  const AStr: String): String;
begin
  if CompareText(AStr, S_AD_True) = 0 then
    Result := '1'
  else
    Result := '0';
end;

{-------------------------------------------------------------------------------}
function TADPhysOraMetadata.InternalEscapeDate(const AStr: String): String;
begin
  Result := 'TO_DATE(''' + AStr + ''', ''YYYY-MM-DD'')';
end;

{-------------------------------------------------------------------------------}
function TADPhysOraMetadata.InternalEscapeDateTime(const AStr: String): String;
begin
  Result := 'TO_DATE(''' + AStr + ''', ''YYYY-MM-DD HH24:MI:SS'')';
end;

{-------------------------------------------------------------------------------}
function TADPhysOraMetadata.InternalEscapeTime(const AStr: String): String;
begin
  Result := '(TO_DATE(''1900-01-01'', ''YYYY-MM-DD'') + (TO_DATE(''' + AStr + ''', ''HH24:MI:SS'') - TRUNC(TO_DATE(''' + AStr + ''', ''HH24:MI:SS''))))';
end;

{-------------------------------------------------------------------------------}
function TADPhysOraMetadata.InternalEscapeFloat(const AStr: String): String;
begin
  Result := 'TO_NUMBER(''' + AStr + ''')';
end;

{-------------------------------------------------------------------------------}
function TADPhysOraMetadata.InternalEscapeFunction(const ASeq: TADPhysEscapeData): String;
var
  sName: String;
  A1, A2, A3, A4: String;
  rSeq: TADPhysEscapeData;

  function AddArgs: string;
  begin
    if Length(ASeq.FArgs) > 0 then
      Result := '(' + AddEscapeSequenceArgs(ASeq) + ')';
  end;

begin
  sName := ASeq.FName;
  if Length(ASeq.FArgs) >= 1 then begin
    A1 := ASeq.FArgs[0];
    if Length(ASeq.FArgs) >= 2 then begin
      A2 := ASeq.FArgs[1];
      if Length(ASeq.FArgs) >= 3 then begin
        A3 := ASeq.FArgs[2];
        if Length(ASeq.FArgs) >= 4 then
          A4 := ASeq.FArgs[3];
      end;
    end;
  end;
  case ASeq.FFunc of
  // the same
  efASCII,
  efLTRIM,
  efREPLACE,
  efRTRIM,
  efSOUNDEX,
  efABS,
  efACOS,
  efASIN,
  efATAN,
  efCOS,
  efEXP,
  efFLOOR,
  efMOD,
  efPOWER,
  efROUND,
  efSIGN,
  efSIN,
  efSQRT,
  efTAN,
  efDECODE:      Result := sName + AddArgs;
  // character
  efBIT_LENGTH:  Result := '(LENGTHB(' + A1 + ') * 8)';
  efCHAR:        Result := 'CHR' + AddArgs;
  efCHAR_LENGTH: Result := 'LENGTH' + AddArgs;
  efCONCAT:      Result := '(' + A1 + ' || ' + A2 + ')';
  efDIFFERENCE:  UnsupportedEscape(ASeq);
  efINSERT:      Result := '(SUBSTR(' + A1 + ', 1, (' + A2 + ') - 1) || ' + A4 +
                    ' || SUBSTR(' + A1 + ', (' + A2 + ' + ' + A3 + ')))';
  efLCASE:       Result := 'LOWER' + AddArgs;
  efLEFT:        Result := 'SUBSTR(' + A1 + ', 1, ' + A2 + ')';
  efLENGTH:      Result := 'LENGTH(RTRIM(' + A1 + '))';
  efLOCATE:
    begin
      Result := 'INSTR(' + A2 + ', ' + A1;
      if Length(ASeq.FArgs) = 3 then
        Result := Result + ', ' + A3;
      Result := Result + ')'
    end;
  efOCTET_LENGTH:Result := 'LENGTHB' + AddArgs;
  efPOSITION:    Result := 'INSTR(' + A2 + ', ' + A1 + ')';
  efREPEAT:      Result := 'RPAD(' + A1 + ', (' + A2 + ') * LENGTH(' + A1 + '), ' + A1 + ')';
  efRIGHT:       Result := 'SUBSTR(' + A1 + ', LENGTH(' + A1 + ') + 1 - (' + A2 + '))';
  efSPACE:       Result := 'RPAD('' '', ' + A1 + ')';
  efSUBSTRING:   Result := 'SUBSTR' + AddArgs;
  efUCASE:       Result := 'UPPER' + AddArgs;
  // numeric
  efCEILING:     Result := 'CEIL' + AddArgs;
  efDEGREES:     Result := '(180 * (' + A1 + ') / ' + S_AD_Pi  + ')';
  efLOG:         Result := 'LN' + AddArgs;
  efLOG10:       Result := 'LOG(10, ' + A1 + ')';
  efPI:          Result := S_AD_Pi;
  efRADIANS:     Result := '((' + A1 + ') / 180 * ' + S_AD_Pi + ')';
  efRANDOM:
    if FServerVersion >= cvOracle90000 then
      Result := 'DBMS_RANDOM.VALUE'
    else
      Result := 'MOD(TRUNC((SYSDATE - TRUNC(SYSDATE)) * 60 * 60 * 24), 1000)';
  efTRUNCATE:    Result := 'TRUNC' + AddArgs;
  // date and time
  efCURDATE:     Result := 'TRUNC(SYSDATE)';
  efCURTIME:     Result := '(TO_DATE(''1900-01-01'', ''YYYY-MM-DD'') + (SYSDATE - TRUNC(SYSDATE)))';
  efNOW:         Result := 'SYSDATE';
  efDAYNAME:     Result := 'RTRIM(TO_CHAR(' + A1 + ', ''DAY''))';
  efDAYOFMONTH:  Result := 'TO_NUMBER(TO_CHAR(' + A1 + ', ''DD''))';
  efDAYOFWEEK:   Result := 'TO_NUMBER(TO_CHAR(' + A1 + ', ''D''))';
  efDAYOFYEAR:   Result := 'TO_NUMBER(TO_CHAR(' + A1 + ', ''DDD''))';
  efEXTRACT:
    begin
      rSeq.FKind := eskFunction;
      if A1[1] = '''' then
        A1 := Copy(A1, 2, Length(A1) - 2);
      A1 := UpperCase(A1);
      if A1 = 'DAY' then
        A1 := 'DAYOFMONTH';
      rSeq.FName := A1;
      SetLength(rSeq.FArgs, 1);
      rSeq.FArgs[0] := ASeq.FArgs[1];
      EscapeFuncToID(rSeq);
      Result := InternalEscapeFunction(rSeq);
    end;
  efHOUR:        Result := 'TO_NUMBER(TO_CHAR(' + A1 + ', ''HH24''))';
  efMINUTE:      Result := 'TO_NUMBER(TO_CHAR(' + A1 + ', ''MI''))';
  efMONTH:       Result := 'TO_NUMBER(TO_CHAR(' + A1 + ', ''MM''))';
  efMONTHNAME:   Result := 'RTRIM(TO_CHAR(' + A1 + ', ''MONTH''))';
  efQUARTER:     Result := 'TO_NUMBER(TO_CHAR(' + A1 + ', ''Q''))';
  efSECOND:      Result := 'TO_NUMBER(TO_CHAR(' + A1 + ', ''SS''))';
  efTIMESTAMPADD:
    begin
      A1 := UpperCase(Trim(A1));
      if A1[1] = '''' then
        A1 := Copy(A1, 2, Length(A1) - 2);
      if A1 = 'YEAR' then
        Result := 'ADD_MONTHS(' + A3 + ', 12 * (' + A2 + '))'
      else if A1 = 'MONTH' then
        Result := 'ADD_MONTHS(' + A3 + ', ' + A2 + ')'
      else if A1 = 'WEEK' then
        Result := '(' + A3 + ' + 7 * (' + A2 + '))'
      else if A1 = 'DAY' then
        Result := '(' + A3 + ' + ' + A2 + ')'
      else if A1 = 'HOUR' then
        Result := '(' + A3 + ' + (' + A2 + ') / 24.0)'
      else if A1 = 'MINUTE' then
        Result := '(' + A3 + ' + (' + A2 + ') / (24.0 * 60.0))'
      else if A1 = 'SECOND' then
        Result := '(' + A3 + ' + (' + A2 + ') / (24.0 * 60.0 * 60.0))'
      else
        UnsupportedEscape(ASeq);
    end;
  efTIMESTAMPDIFF:
    begin
      A1 := UpperCase(Trim(A1));
      if A1[1] = '''' then
        A1 := Copy(A1, 2, Length(A1) - 2);
      if A1 = 'YEAR' then
        Result := 'TRUNC(MONTHS_BETWEEN(' + A3 + ', ' + A2 + ') / 12)'
      else if A1 = 'MONTH' then
        Result := 'MONTHS_BETWEEN(' + A3 + ', ' + A2 + ')'
      else if A1 = 'WEEK' then
        Result := 'TRUNC(((' + A3 + ') - (' + A2 + ')) / 7)'
      else if A1 = 'DAY' then
        Result := '((' + A3 + ') - (' + A2 + '))'
      else if A1 = 'HOUR' then
        Result := 'TRUNC(((' + A3 + ') - (' + A2 + ')) * 24.0)'
      else if A1 = 'MINUTE' then
        Result := 'TRUNC(((' + A3 + ') - (' + A2 + ')) * (24.0 * 60.0))'
      else if A1 = 'SECOND' then
        Result := 'TRUNC(((' + A3 + ') - (' + A2 + ')) * (24.0 * 60.0 * 60.0))'
      else
        UnsupportedEscape(ASeq);
    end;
  efWEEK:        Result := 'TO_NUMBER(TO_CHAR(' + A1 + ', ''WW''))';
  efYEAR:        Result := 'TO_NUMBER(TO_CHAR(' + A1 + ', ''YYYY''))';
  // system
  efCATALOG:     Result := '''''';
  efSCHEMA:      Result := 'USER';
  efIFNULL:      Result := 'NVL' + AddArgs;
  efIF:
    if FServerVersion >= cvOracle90000 then
      Result := 'CASE WHEN ' + A1 + ' THEN ' + A2 + ' ELSE ' + A3 + ' END'
    else
      UnsupportedEscape(ASeq);
  // convert
  efCONVERT:
    begin
      A2 := UpperCase(Trim(A2));
      if A2[1] = '''' then
        A2 := Copy(A2, 2, Length(A2) - 2);
      if (A2 = 'CHAR') or (A2 = 'LONGVARCHAR') or (A2 = 'VARCHAR') then
        Result := 'TO_CHAR(' + A1 + ')'
      else if (A2 = 'WCHAR') or (A2 = 'WLONGVARCHAR') or (A2 = 'WVARCHAR') then
        Result := 'TO_NCHAR(' + A1 + ')'
      else if (A2 = 'DATE') then
        if FServerVersion >= cvOracle90000 then
          Result := 'TRUNC(CAST(' + A1 + ' AS DATE))'
        else
          Result := 'TRUNC(TO_DATE(' + A1 + '))'
      else if (A2 = 'DATETIME') then
        if FServerVersion >= cvOracle90000 then
          Result := 'CAST(' + A1 + ' AS DATE)'
        else
          Result := 'TO_DATE(' + A1 + ')'
      else if (A2 = 'TIME') then
        if FServerVersion >= cvOracle90000 then
          Result := '(TO_DATE(''1900-01-01'', ''YYYY-MM-DD'') + (CAST(' + A1 + ' AS DATE) - TRUNC(CAST(' + A1 + ' AS DATE))))'
        else
          Result := '(TO_DATE(''1900-01-01'', ''YYYY-MM-DD'') + (TO_DATE(' + A1 + ') - TRUNC(TO_DATE(' + A1 + '))))'
      else if (A2 = 'DECIMAL') or (A2 = 'DOUBLE') or (A2 = 'FLOAT') or
              (A2 = 'NUMERIC') or (A2 = 'REAL') then
        Result := 'TO_NUMBER(' + A1 + ')'
      else if (A2 = 'INTEGER') or (A2 = 'SMALLINT') or (A2 = 'TINYINT') or
              (A2 = 'BIGINT') then
        Result := 'TRUNC(TO_NUMBER(' + A1 + '))'
      else
        UnsupportedEscape(ASeq);
    end;
  else
    // unsupported ATAN2, COT
    UnsupportedEscape(ASeq);
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysOraMetadata.InternalGetSQLCommandKind(
  const AToken: String): TADPhysCommandKind;
begin
  if (AToken = 'DECLARE') or (AToken = 'BEGIN') then
    Result := skExecute
  else
    Result := inherited InternalGetSQLCommandKind(AToken);
end;

{-------------------------------------------------------------------------------}
{ TADPhysOraCommandGenerator                                                    }
{-------------------------------------------------------------------------------}
function TADPhysOraCommandGenerator.GetOracleReturning(ARequest: TADPhysUpdateRequest): String;
var
  s1, s2: String;
  i: Integer;
  oCols: TADDatSColumnList;
  oCol: TADDatSColumn;
  lRefresh, lPutBlob: Boolean;
  eParType: TParamType;
begin
  s1 := '';
  s2 := '';
  oCols := FTable.Columns;
  for i := 0 to oCols.Count - 1 do begin
    oCol := oCols[i];
    if ColumnStorable(oCol) then begin
      lRefresh := ColumnReqRefresh(ARequest, oCol);
      lPutBlob := FConnMeta.InsertBlobsAfterReturning and ColumnIsHBLOB(oCol) and
        ColumnChanged(FRow, oCol) and (oCol.DataType <> dtHBFile);
      if lRefresh or lPutBlob then begin
        if s1 <> '' then begin
          s1 := s1 + ', ';
          s2 := s2 + ', ';
        end;
        s1 := s1 + GetColumn('', oCols[i]);
        // if Insert then
        //   after exec put
        // else if Update then
        //   if Set then
        //     after exec put
        //   else if Refr then
        //     after exec get
        // else
        //   after exec get
        if lPutBlob then
          eParType := ptInput
        else if lRefresh then
          eParType := ptOutput
        else
          eParType := ptUnknown;
        s2 := s2 + AddColumnParam(oCols[i], True, eParType);
      end;
    end;
  end;
  if s1 <> '' then
    Result := ' RETURNING ' + s1 + ' INTO ' + s2
  else
    Result := '';
end;

{-------------------------------------------------------------------------------}
function TADPhysOraCommandGenerator.GetInlineRefresh(const AStmt: String;
  ARequest: TADPhysUpdateRequest): String;
begin
  Result := AStmt + GetOracleReturning(ARequest);
end;

{-------------------------------------------------------------------------------}
function TADPhysOraCommandGenerator.GetPessimisticLock: String;
var
  lNeedFrom: Boolean;
begin
  Result := 'SELECT ' + GetSelectList(True, False, lNeedFrom) + BRK +
    'FROM ' + GetFrom + BRK + 'WHERE ' + GetWhere(False) + BRK +
    'FOR UPDATE';
  FCommandKind := skSelectForUpdate;
  ASSERT(lNeedFrom);
  if not FOptions.UpdateOptions.LockWait then
    Result := Result + ' NOWAIT';
end;

{-------------------------------------------------------------------------------}
function TADPhysOraCommandGenerator.GetSavepoint(const AName: String): String;
begin
  Result := 'SAVEPOINT ' + AName;
end;

{-------------------------------------------------------------------------------}
function TADPhysOraCommandGenerator.GetRollbackToSavepoint(const AName: String): String;
begin
  Result := 'ROLLBACK TO SAVEPOINT ' + AName;
end;

{-------------------------------------------------------------------------------}
function TADPhysOraCommandGenerator.GetLastAutoGenValue(const AName: String): String;
begin
  Result := 'SELECT ' + AName + '.CURRVAL' + BRK + 'FROM ' + GetSingleRowTable;
end;

{-------------------------------------------------------------------------------}
function TADPhysOraCommandGenerator.GetSingleRowTable: String;
begin
  Result := 'DUAL';
end;

{-------------------------------------------------------------------------------}
function TADPhysOraCommandGenerator.GetCall(const AName: String): String;
begin
  Result := 'BEGIN ' + AName;
  if Result[Length(Result)] <> ';' then
    Result := Result + ';';
  Result := Result + ' END;';
end;

end.
