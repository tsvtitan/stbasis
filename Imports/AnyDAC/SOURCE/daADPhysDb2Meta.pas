{-------------------------------------------------------------------------------}
{ AnyDAC IBM Db2 metadata                                                       }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit daADPhysDb2Meta;

interface

uses
  daADStanIntf,
  daADPhysIntf, daADPhysConnMeta, daADPhysCmdGenerator;

type
  TADPhysDb2Metadata = class (TADPhysConnectionMetadata)
  protected
    function GetKind: TADRDBMSKind; override;
    function GetTxSupported: Boolean; override;
    function GetTxNested: Boolean; override;
    function GetTxSavepoints: Boolean; override;
    function GetTxAutoCommit: Boolean; override;
    function GetParamNameMaxLength: Integer; override;
    function GetNameParts: TADPhysNameParts; override;
    function GetNameDefLowCaseParts: TADPhysNameParts; override;
    function GetNameCaseSensParts: TADPhysNameParts; override;
    function GetNameQuotaChar1: Char; override;
    function GetNameQuotaChar2: Char; override;
    function GetParamMark: TADPhysParamMark; override;
    function GetTruncateSupported: Boolean; override;
    function GetDefValuesSupported: TADPhysDefaultValues; override;
    function GetSelectWithoutFrom: Boolean; override;
    function GetAsyncAbortSupported: Boolean; override;
    function InternalEscapeBoolean(const AStr: String): String; override;
    function InternalEscapeDate(const AStr: String): String; override;
    function InternalEscapeDateTime(const AStr: String): String; override;
    function InternalEscapeFloat(const AStr: String): String; override;
    function InternalEscapeFunction(const ASeq: TADPhysEscapeData): String; override;
    function InternalEscapeTime(const AStr: String): String; override;
    function InternalGetSQLCommandKind(const AToken: String): TADPhysCommandKind; override;
  end;

  TADPhysDb2CommandGenerator = class(TADPhysCommandGenerator)
  protected
    function GetIdentity: String; override;
    function GetPessimisticLock: String; override;
    function GetSavepoint(const AName: String): String; override;
    function GetRollbackToSavepoint(const AName: String): String; override;
    function GetCommitSavepoint(const AName: String): String; override;
  end;

implementation

uses
  SysUtils,
  daADStanConst;

{-------------------------------------------------------------------------------}
{ TADPhysOraMetadata                                                            }
{-------------------------------------------------------------------------------}
function TADPhysDb2Metadata.GetKind: TADRDBMSKind;
begin
  Result := mkDb2;
end;

{-------------------------------------------------------------------------------}
function TADPhysDb2Metadata.GetNameCaseSensParts: TADPhysNameParts;
begin
  Result := [];
end;

{-------------------------------------------------------------------------------}
function TADPhysDb2Metadata.GetNameDefLowCaseParts: TADPhysNameParts;
begin
  Result := [];
end;

{-------------------------------------------------------------------------------}
function TADPhysDb2Metadata.GetParamNameMaxLength: Integer;
begin
  Result := 128;
end;

{-------------------------------------------------------------------------------}
function TADPhysDb2Metadata.GetNameParts: TADPhysNameParts;
begin
  Result := [npSchema, npBaseObject, npObject];
end;

{-------------------------------------------------------------------------------}
function TADPhysDb2Metadata.GetNameQuotaChar1: Char;
begin
  Result := '"';
end;

{-------------------------------------------------------------------------------}
function TADPhysDb2Metadata.GetNameQuotaChar2: Char;
begin
  Result := '"';
end;

{-------------------------------------------------------------------------------}
function TADPhysDb2Metadata.GetParamMark: TADPhysParamMark;
begin
  Result := prQMark;
end;

{-------------------------------------------------------------------------------}
function TADPhysDb2Metadata.GetTxAutoCommit: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysDb2Metadata.GetTxNested: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADPhysDb2Metadata.GetTxSavepoints: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysDb2Metadata.GetTxSupported: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysDb2Metadata.GetTruncateSupported: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADPhysDb2Metadata.GetDefValuesSupported: TADPhysDefaultValues;
begin
  Result := dvDef;
end;

{-------------------------------------------------------------------------------}
function TADPhysDb2Metadata.GetSelectWithoutFrom: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADPhysDb2Metadata.GetAsyncAbortSupported: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysDb2Metadata.InternalEscapeBoolean(
  const AStr: String): String;
begin
  if CompareText(AStr, S_AD_True) = 0 then
    Result := '1'
  else
    Result := '0';
end;

{-------------------------------------------------------------------------------}
function TADPhysDb2Metadata.InternalEscapeDate(const AStr: String): String;
begin
  Result := 'DATE(''' + AStr + ''')';
end;

{-------------------------------------------------------------------------------}
function TADPhysDb2Metadata.InternalEscapeDateTime(const AStr: String): String;
begin
  Result := 'TIMESTAMP_FORMAT(''' + AStr + ''', ''YYYY-MM-DD HH24:MI:SS'')';
end;

{-------------------------------------------------------------------------------}
function TADPhysDb2Metadata.InternalEscapeTime(const AStr: String): String;
begin
  Result := 'TIME(''' + AStr + ''')';
end;

{-------------------------------------------------------------------------------}
function TADPhysDb2Metadata.InternalEscapeFloat(const AStr: String): String;
begin
  Result := AStr;
end;

{-------------------------------------------------------------------------------}
function TADPhysDb2Metadata.InternalEscapeFunction(const ASeq: TADPhysEscapeData): String;
var
  sName: String;
  A1, A2, A3, A4: String;
  rSeq: TADPhysEscapeData;
  i: Integer;

  function AddArgs: string;
  begin
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
  // char
  efASCII,
  efCONCAT,
  efDIFFERENCE,
  efINSERT,
  efLEFT,
  efLENGTH,
  efLCASE,
  efLOCATE,
  efLTRIM,
  efREPLACE,
  efREPEAT,
  efRIGHT,
  efRTRIM,
  efSPACE,
  efSOUNDEX,
  efUCASE,
  // numeric
  efACOS,
  efASIN,
  efATAN,
  efATAN2,
  efABS,
  efCEILING,
  efCOS,
  efCOT,
  efDEGREES,
  efEXP,
  efFLOOR,
  efLOG,
  efLOG10,
  efMOD,
  efPOWER,
  efRADIANS,
  efSIGN,
  efSIN,
  efSQRT,
  efTAN,
  // date and time
  efDAYNAME,
  efDAYOFWEEK,
  efDAYOFYEAR,
  efHOUR,
  efMINUTE,
  efMONTH,
  efMONTHNAME,
  efQUARTER,
  efSECOND,
  efWEEK,
  efYEAR:        Result := sName + AddArgs;
  // character
  efCHAR:        Result := 'CHR' + AddArgs;
  efBIT_LENGTH:  Result := '(LENGTH(' + A1 + ') * 8)';
  efCHAR_LENGTH: Result := 'LENGTH' + AddArgs;
  efOCTET_LENGTH:Result := 'LENGTH' + AddArgs;
  efPOSITION:    Result := 'POSSTR(' + A2 + ', ' + A1 + ')';
  efSUBSTRING:   Result := 'SUBSTR' + AddArgs;
  // numeric
  efTRUNCATE:    Result := sName + '(' + A1 + ', 0)';
  efPI:          Result := S_AD_Pi;
  efRANDOM:      Result := 'RAND' + AddArgs;
  efROUND:
    if A2 = '' then
      Result := sName + '(' + A1 + ', 0)'
    else
      Result := sName + AddArgs;
  // date and time
  efCURDATE:     Result := 'CURRENT_DATE';
  efCURTIME:     Result := 'CURRENT_TIME';
  efNOW:         Result := 'CURRENT_TIMESTAMP';
  efDAYOFMONTH:  Result := 'DAY' + AddArgs;
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
  efTIMESTAMPADD:
    begin
      A1 := UpperCase(Trim(A1));
      if A1[1] = '''' then
        A1 := Copy(A1, 2, Length(A1) - 2);
      if A1 = 'QUARTER' then begin
        A2 := '((' + A2 + ') * 3)';
        A1 := 'MONTH';
      end
      else if A1 = 'WEEK' then begin
        A2 := '((' + A2 + ') * 7)';
        A1 := 'DAY';
      end
      else if A1 = 'FRAC_SECOND' then
        A1 := 'MICROSECOND';
      Result := '((' + A3 + ') + (' + A2 + ') ' + A1 + ')';
    end;
  efTIMESTAMPDIFF:
    begin
      A1 := UpperCase(Trim(A1));
      if A1[1] = '''' then
        A1 := Copy(A1, 2, Length(A1) - 2);
      if A1 = 'YEAR' then
        Result := '256'
      else if A1 = 'QUARTER' then
        Result := '128'
      else if A1 = 'MONTH' then
        Result := '64'
      else if A1 = 'WEEK' then
        Result := '32'
      else if A1 = 'DAY' then
        Result := '16'
      else if A1 = 'HOUR' then
        Result := '8'
      else if A1 = 'MINUTE' then
        Result := '4'
      else if A1 = 'SECOND' then
        Result := '2'
      else if A1 = 'FRAC_SECOND' then
        Result := '1'
      else
        UnsupportedEscape(ASeq);
      Result := 'TIMESTAMPDIFF(' + Result + ', CHAR((' + A3 + ') - (' + A2 + ')))';
    end;
  // system
  efCATALOG:     Result := '''''';
  efSCHEMA:      Result := 'CURRENT_SCHEMA';
  efIFNULL:      Result := 'CASE WHEN ' + A1 + ' IS NULL THEN ' + A2 + ' ELSE ' + A1 + ' END';
  efIF:          Result := 'CASE WHEN ' + A1 + ' THEN ' + A2 + ' ELSE ' + A3 + ' END';
  efDECODE:
    begin
      Result := 'CASE ' + ASeq.FArgs[0];
      i := 1;
      while i < Length(ASeq.FArgs) - 1 do begin
        Result := Result + ' WHEN ' + ASeq.FArgs[i] + ' THEN ' + ASeq.FArgs[i + 1];
        Inc(i, 2);
      end;
      if i = Length(ASeq.FArgs) - 1 then
        Result := Result + ' ELSE ' + ASeq.FArgs[i];
      Result := Result + ' END';
    end;
  // convert
  efCONVERT:
    begin
      A2 := UpperCase(Trim(A2));
      if A2[1] = '''' then
        A2 := Copy(A2, 2, Length(A2) - 2);
      if (A2 = 'LONGVARCHAR') or (A2 = 'WLONGVARCHAR') then
        A2 := 'LONG_VARCHAR'
      else if A2 = 'WCHAR' then
        A2 := 'CHAR'
      else if A2 = 'WVARCHAR' then
        A2 := 'VARCHAR'
      else if A2 = 'DATETIME' then
        A2 := 'TIMESTAMP'
      else if A2 = 'NUMERIC' then
        A2 := 'DECIMAL'
      else if A2 = 'TINYINT' then
        A2 := 'SMALLINT'
      else if (A2 = 'VARBINARY') or (A2 = 'BINARY') or (A2 = 'LONGVARBINARY') then
        A2 := 'BLOB'
      else if not ((A2 = 'BIGINT') or (A2 = 'CHAR') or (A2 = 'INTEGER') or
                   (A2 = 'NUMERIC') or (A2 = 'REAL') or (A2 = 'SMALLINT') or
                   (A2 = 'DATE') or (A2 = 'TIME') or (A2 = 'TIMESTAMP') or
                   (A2 = 'VARCHAR') or (A2 = 'DECIMAL') or (A2 = 'DOUBLE') or
                   (A2 = 'FLOAT')) then
        UnsupportedEscape(ASeq);
      Result := A2 + '(' + A1 + ')';
    end;
  else
    UnsupportedEscape(ASeq);
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysDb2Metadata.InternalGetSQLCommandKind(
  const AToken: String): TADPhysCommandKind;
begin
  if AToken = 'CALL' then
    Result := skExecute
  else
    Result := inherited InternalGetSQLCommandKind(AToken);
end;

{-------------------------------------------------------------------------------}
{ TADPhysDb2CommandGenerator                                                    }
{-------------------------------------------------------------------------------}
function TADPhysDb2CommandGenerator.GetIdentity: String;
begin
  Result := 'IDENTITY_VAL_LOCAL()';
end;

{-------------------------------------------------------------------------------}
function TADPhysDb2CommandGenerator.GetPessimisticLock: String;
var
  lNeedFrom: Boolean;
begin
  Result := 'SELECT ' + GetSelectList(True, False, lNeedFrom) + BRK +
    'FROM ' + GetFrom + BRK + 'WHERE ' + GetWhere(False) + BRK +
    'FOR UPDATE';
  FCommandKind := skSelectForUpdate;
  ASSERT(lNeedFrom);
end;

{-------------------------------------------------------------------------------}
function TADPhysDb2CommandGenerator.GetSavepoint(const AName: String): String;
begin
  Result := 'SAVEPOINT ' + AName + ' ON ROLLBACK RETAIN CURSORS';
end;

{-------------------------------------------------------------------------------}
function TADPhysDb2CommandGenerator.GetRollbackToSavepoint(const AName: String): String;
begin
  Result := 'ROLLBACK TO SAVEPOINT ' + AName;
end;

{-------------------------------------------------------------------------------}
function TADPhysDb2CommandGenerator.GetCommitSavepoint(const AName: String): String;
begin
  Result := 'RELEASE SAVEPOINT ' + AName;
end;

end.
