{-------------------------------------------------------------------------------}
{ AnyDAC MSSQL metadata                                                         }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit daADPhysMSSQLMeta;

interface

uses
  daADStanIntf,
  daADPhysIntf, daADPhysConnMeta, daADPhysCmdGenerator;

type
  TADPhysMSSQLMetadata = class (TADPhysConnectionMetadata)
  protected
    function GetKind: TADRDBMSKind; override;
    function GetTxSupported: Boolean; override;
    function GetTxNested: Boolean; override;
    function GetTxSavepoints: Boolean; override;
    function GetTxAutoCommit: Boolean; override;
    function GetParamNameMaxLength: Integer; override;
    function GetNameParts: TADPhysNameParts; override;
    function GetNameQuotedCaseSensParts: TADPhysNameParts; override;
    function GetNameCaseSensParts: TADPhysNameParts; override;
    function GetNameDefLowCaseParts: TADPhysNameParts; override;
    function GetNameQuotaChar1: Char; override;
    function GetNameQuotaChar2: Char; override;
    function GetParamMark: TADPhysParamMark; override;
    function GetInlineRefresh: Boolean; override;
    function GetEnableIdentityInsert: Boolean; override;
    function GetDefValuesSupported: TADPhysDefaultValues; override;
    function GetLockNoWait: Boolean; override;
    function GetAsyncAbortSupported: Boolean; override;
    function GetCommandSeparator: String; override;
    function InternalEscapeBoolean(const AStr: String): String; override;
    function InternalEscapeDate(const AStr: String): String; override;
    function InternalEscapeDateTime(const AStr: String): String; override;
    function InternalEscapeFloat(const AStr: String): String; override;
    function InternalEscapeFunction(const ASeq: TADPhysEscapeData): String; override;
    function InternalEscapeTime(const AStr: String): String; override;
    function InternalGetSQLCommandKind(const AToken: String): TADPhysCommandKind; override;
  end;

  TADPhysMSSQLCommandGenerator = class(TADPhysCommandGenerator)
  protected
    function GetInlineRefresh(const AStmt: String;
      ARequest: TADPhysUpdateRequest): String; override;
    function GetIdentityInsert(const ATable, AStmt: String;
      ARequest: TADPhysUpdateRequest): String; override;
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
function TADPhysMSSQLMetadata.GetKind: TADRDBMSKind;
begin
  Result := mkMSSQL;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.GetNameQuotedCaseSensParts: TADPhysNameParts;
begin
  Result := [];
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.GetNameCaseSensParts: TADPhysNameParts;
begin
  Result := [];
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.GetNameDefLowCaseParts: TADPhysNameParts;
begin
  Result := [];
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.GetParamNameMaxLength: Integer;
begin
  Result := 128;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.GetNameParts: TADPhysNameParts;
begin
  Result := [npCatalog, npSchema, npBaseObject, npObject];
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.GetNameQuotaChar1: Char;
begin
  Result := '[';
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.GetNameQuotaChar2: Char;
begin
  Result := ']';
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.GetParamMark: TADPhysParamMark;
begin
  Result := prQMark;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.GetTxAutoCommit: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.GetTxNested: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.GetTxSavepoints: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.GetTxSupported: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.GetInlineRefresh: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.GetEnableIdentityInsert: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.GetDefValuesSupported: TADPhysDefaultValues;
begin
  Result := dvDefVals;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.GetLockNoWait: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.GetAsyncAbortSupported: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.GetCommandSeparator: String;
begin
  Result := 'GO';
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.InternalEscapeBoolean(
  const AStr: String): String;
begin
  if CompareText(AStr, S_AD_True) = 0 then
    Result := '1'
  else
    Result := '0';
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.InternalEscapeDate(const AStr: String): String;
begin
  Result := 'CONVERT(DATETIME, ''' + AStr + ''', 20)';
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.InternalEscapeDateTime(const AStr: String): String;
begin
  Result := 'CONVERT(DATETIME, ''' + AStr + ''', 20)';
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.InternalEscapeTime(const AStr: String): String;
begin
  Result := 'CONVERT(DATETIME, ''' + AStr + ''', 114)';
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.InternalEscapeFloat(const AStr: String): String;
begin
  Result := AStr;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.InternalEscapeFunction(const ASeq: TADPhysEscapeData): String;
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
  efCHAR,
  efDIFFERENCE,
  efLEFT,
  efLTRIM,
  efREPLACE,
  efRIGHT,
  efRTRIM,
  efSPACE,
  efSOUNDEX,
  efSUBSTRING,
  // numeric
  efACOS,
  efASIN,
  efATAN,
  efABS,
  efCEILING,
  efCOS,
  efCOT,
  efDEGREES,
  efEXP,
  efFLOOR,
  efLOG,
  efLOG10,
  efPOWER,
  efPI,
  efSIGN,
  efSIN,
  efSQRT,
  efTAN:         Result := sName + AddArgs;
  // character
  efBIT_LENGTH:  Result := '(LEN(' + A1 + ') * 8)';
  efCHAR_LENGTH: Result := 'LEN' + AddArgs;
  efCONCAT:      Result := '(' + A1 + ' + ' + A2 + ')';
  efINSERT:      Result := 'STUFF' + AddArgs;
  efLCASE:       Result := 'LOWER' + AddArgs;
  efLENGTH:      Result := 'LEN(RTRIM(' + A1 + '))';
  efLOCATE:
    begin
      Result := 'CHARINDEX(' + A1 + ', ' + A2;
      if Length(ASeq.FArgs) = 3 then
        Result := Result + ', ' + A3;
      Result := Result + ')'
    end;
  efOCTET_LENGTH:Result := 'LEN' + AddArgs;
  efPOSITION:    Result := 'CHARINDEX' + AddArgs;
  efREPEAT:      Result := 'REPLICATE' + AddArgs;
  efUCASE:       Result := 'UPPER' + AddArgs;
  // numeric
  efRANDOM:      Result := 'RAND' + AddArgs;
  efTRUNCATE:    Result := 'CAST(' + A1 + ' AS BIGINT)';
  efATAN2:       Result := 'ATN2' + AddArgs;
  efMOD:         Result := '((' + A1 + ') % (' + A2 + '))';
  efROUND:
    if A2 = '' then
      Result := sName + '(' + A1 + ', 0)'
    else
      Result := sName + AddArgs;
  efRADIANS:
    Result := sName + '(' + A1 + ' + 0.0)';
  // date and time
  efCURDATE,
  efCURTIME,
  efNOW:         Result := 'GETDATE()';
  efDAYNAME:     Result := 'DATENAME(WEEKDAY, ' + A1 + ')';
  efDAYOFMONTH:  Result := 'DATEPART(DAY, ' + A1 + ')';
  efDAYOFWEEK:   Result := 'DATEPART(WEEKDAY, ' + A1 + ')';
  efDAYOFYEAR:   Result := 'DATEPART(DAYOFYEAR, ' + A1 + ')';
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
  efHOUR:        Result := 'DATEPART(HOUR, ' + A1 + ')';
  efMINUTE:      Result := 'DATEPART(MINUTE, ' + A1 + ')';
  efMONTH:       Result := 'DATEPART(MONTH, ' + A1 + ')';
  efMONTHNAME:   Result := 'DATENAME(MONTH, ' + A1 + ')';
  efQUARTER:     Result := 'DATEPART(QUARTER, ' + A1 + ')';
  efSECOND:      Result := 'DATEPART(SECOND, ' + A1 + ')';
  efTIMESTAMPADD:
    begin
      if A1[1] = '''' then
        ASeq.FArgs[0] := Copy(A1, 2, Length(A1) - 2);
      Result := 'DATEADD' + AddArgs;
    end;
  efTIMESTAMPDIFF:
    begin
      if A1[1] = '''' then
        ASeq.FArgs[0] := Copy(A1, 2, Length(A1) - 2);
      Result := 'DATEDIFF' + AddArgs;
    end;
  efWEEK:        Result := 'DATEPART(WEEK, ' + A1 + ')';
  efYEAR:        Result := 'DATEPART(YEAR, ' + A1 + ')';
  // system
  efCATALOG:     Result := '''''';
  efSCHEMA:      Result := 'CURRENT_USER()';
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
    Result := 'CONVERT(' + A2 + ', ' + A1 + ')';
  else
    UnsupportedEscape(ASeq);
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.InternalGetSQLCommandKind(
  const AToken: String): TADPhysCommandKind;
begin
  if (AToken = 'EXEC') or (AToken = 'EXECUTE') then
    Result := skExecute
  else
    Result := inherited InternalGetSQLCommandKind(AToken);
end;

{-------------------------------------------------------------------------------}
{ TADPhysMSSQLCommandGenerator                                                  }
{-------------------------------------------------------------------------------}
function TADPhysMSSQLCommandGenerator.GetInlineRefresh(const AStmt: String;
  ARequest: TADPhysUpdateRequest): String;
begin
  Result := GenerateSelect;
  if Result <> '' then
    Result := AStmt + ';' + BRK + Result
  else
    Result := AStmt;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLCommandGenerator.GetIdentityInsert(
  const ATable, AStmt: String; ARequest: TADPhysUpdateRequest): String;
begin
  Result := 'SET IDENTITY_INSERT ' + ATable + ' ON;' + BRK + AStmt +
    ';' + BRK + 'SET IDENTITY_INSERT ' + ATable + ' OFF';
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLCommandGenerator.GetIdentity: String;
begin
  Result := 'SCOPE_IDENTITY()';
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLCommandGenerator.GetPessimisticLock: String;
var
  lNeedFrom: Boolean;
begin
  if not FOptions.UpdateOptions.LockWait then
    Result := 'SET LOCK_TIMEOUT 0;' + BRK;
  lNeedFrom := False;
  Result := Result + 'SELECT ' + GetSelectList(True, False, lNeedFrom) + BRK +
    'FROM ' + GetFrom + ' WITH(ROWLOCK,UPDLOCK)' + BRK + 'WHERE ' + GetWhere(False);
  FCommandKind := skSelectForUpdate;
  ASSERT(lNeedFrom);
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLCommandGenerator.GetSavepoint(const AName: String): String;
begin
  Result := 'IF @@TRANCOUNT = 0 BEGIN SET IMPLICIT_TRANSACTIONS OFF BEGIN TRANSACTION END ELSE SAVE TRANSACTION ' + AName;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLCommandGenerator.GetRollbackToSavepoint(const AName: String): String;
begin
  Result := 'IF @@TRANCOUNT = 1 ROLLBACK TRANSACTION ELSE ROLLBACK TRANSACTION ' + AName;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLCommandGenerator.GetCommitSavepoint(const AName: String): String;
begin
  Result := 'IF @@TRANCOUNT >= 1 COMMIT TRANSACTION';
end;

end.
