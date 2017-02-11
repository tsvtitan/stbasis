{-------------------------------------------------------------------------------}
{ AnyDAC MySQL metadata                                                         }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit daADPhysMySQLMeta;

interface

uses
  daADStanIntf,
  daADPhysIntf, daADPhysManager, daADPhysConnMeta, daADPhysCmdGenerator;

type
  TADPhysMySQLMetadata = class (TADPhysConnectionMetadata)
  private
    FServerVersion,
    FClientVersion: LongWord;
    FServerCaseSens: Boolean;
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
    function GetNameQuotedCaseSensParts: TADPhysNameParts; override;
    function GetNameCaseSensParts: TADPhysNameParts; override;
    function GetNameDefLowCaseParts: TADPhysNameParts; override;
    function GetNameQuotaChar1: Char; override;
    function GetNameQuotaChar2: Char; override;
    function GetParamMark: TADPhysParamMark; override;
    function GetDefValuesSupported: TADPhysDefaultValues; override;
    function InternalEscapeBoolean(const AStr: String): String; override;
    function InternalEscapeDate(const AStr: String): String; override;
    function InternalEscapeDateTime(const AStr: String): String; override;
    function InternalEscapeFloat(const AStr: String): String; override;
    function InternalEscapeFunction(const ASeq: TADPhysEscapeData): String; override;
    function InternalEscapeTime(const AStr: String): String; override;
    function InternalEscapeEscape(AEscape: Char; const AStr: String): String; override;
    function InternalGetSQLCommandKind(const AToken: String): TADPhysCommandKind; override;
  public
    constructor Create(
      {$IFDEF AnyDAC_MONITOR} const AMonitor: IADMoniClient; {$ENDIF}
      const AConnection: TADPhysConnection; AServerVersion, AClientVersion: LongWord;
      AServerCaseSens: Boolean);
  end;

  TADPhysMySQLCommandGenerator = class(TADPhysCommandGenerator)
  protected
    function GetIdentity: String; override;
    function GetPessimisticLock: String; override;
    function GetSavepoint(const AName: String): String; override;
    function GetRollbackToSavepoint(const AName: String): String; override;
  end;

implementation

uses
  SysUtils,
  daADStanConst;

const
  // copied here from daADPhysMySQLCli to remove dependency
  NAME_LEN = 64;

{-------------------------------------------------------------------------------}
{ TADPhysOraMetadata                                                            }
{-------------------------------------------------------------------------------}
constructor TADPhysMySQLMetadata.Create(
  {$IFDEF AnyDAC_MONITOR} const AMonitor: IADMoniClient; {$ENDIF}
  const AConnection: TADPhysConnection; AServerVersion, AClientVersion: LongWord;
  AServerCaseSens: Boolean);
begin
  inherited Create({$IFDEF AnyDAC_MONITOR} AMonitor, {$ENDIF} AConnection);
  FServerVersion := AServerVersion;
  FClientVersion := AClientVersion;
  FServerCaseSens := AServerCaseSens;
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLMetadata.GetKind: TADRDBMSKind;
begin
  Result := mkMySQL;
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLMetadata.GetClientVersion: LongWord;
begin
  Result := FClientVersion;
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLMetadata.GetServerVersion: LongWord;
begin
  Result := FServerVersion;
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLMetadata.GetNameQuotedCaseSensParts: TADPhysNameParts;
begin
  Result := GetNameCaseSensParts;
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLMetadata.GetNameCaseSensParts: TADPhysNameParts;
begin
  if FServerCaseSens then
    Result := [npCatalog, npBaseObject, npObject]
  else
    Result := [];
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLMetadata.GetNameDefLowCaseParts: TADPhysNameParts;
begin
  Result := [npBaseObject, npObject];
  if FServerVersion >= mvMySQL040002 then
    Include(Result, npCatalog);
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLMetadata.GetParamNameMaxLength: Integer;
begin
  Result := NAME_LEN;
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLMetadata.GetNameParts: TADPhysNameParts;
begin
  Result := [npCatalog, npBaseObject, npObject];
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLMetadata.GetNameQuotaChar1: Char;
begin
  Result := '`';
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLMetadata.GetNameQuotaChar2: Char;
begin
  Result := '`';
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLMetadata.GetParamMark: TADPhysParamMark;
begin
  Result := prQMark;
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLMetadata.GetTxAutoCommit: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLMetadata.GetTxNested: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLMetadata.GetTxSavepoints: Boolean;
begin
  Result := (FServerVersion >= mvMySQL040100); // ????
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLMetadata.GetTxSupported: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLMetadata.GetDefValuesSupported: TADPhysDefaultValues;
begin
  if FServerVersion >= mvMySQL040000 then
    Result := dvDef
  else
    Result := dvNone;
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLMetadata.InternalEscapeBoolean(
  const AStr: String): String;
begin
  Result := '''' + AStr + '''';
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLMetadata.InternalEscapeDate(const AStr: String): String;
begin
  if FServerVersion >= mvMySQL040000 then
    Result := 'CAST(''' + AStr + ''' AS DATE)'
  else
    Result := '''' + AStr + '''';
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLMetadata.InternalEscapeDateTime(const AStr: String): String;
begin
  if FServerVersion >= mvMySQL040000 then
    Result := 'CAST(''' + AStr + ''' AS DATETIME)'
  else
    Result := '''' + AStr + '''';
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLMetadata.InternalEscapeTime(const AStr: String): String;
begin
  if FServerVersion >= mvMySQL040000 then
    Result := 'CAST(''' + AStr + ''' AS TIME)'
  else
    Result := '''' + AStr + '''';
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLMetadata.InternalEscapeFloat(const AStr: String): String;
begin
  Result := AStr;
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLMetadata.InternalEscapeFunction(const ASeq: TADPhysEscapeData): String;
var
  sName: String;
  A1, A2, A3: String;
  i: Integer;

  function AddArgs: string;
  begin
    Result := '(' + AddEscapeSequenceArgs(Aseq) + ')';
  end;

begin
  sName := ASeq.FName;
  if Length(ASeq.FArgs) >= 1 then begin
    A1 := ASeq.FArgs[0];
    if Length(ASeq.FArgs) >= 2 then begin
      A2 := ASeq.FArgs[1];
      if Length(ASeq.FArgs) >= 3 then
        A3 := ASeq.FArgs[2];
    end;
  end;
  case ASeq.FFunc of
  // the same
  // char
  efASCII,
  efCHAR_LENGTH,
  efCONCAT,
  efCHAR,
  efINSERT,
  efLCASE,
  efLEFT,
  efLTRIM,
  efLOCATE,
  efOCTET_LENGTH,
  efREPEAT,
  efREPLACE,
  efRIGHT,
  efRTRIM,
  efSPACE,
  efSOUNDEX,
  efSUBSTRING,
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
  efPI,
  efRADIANS,
  efSIGN,
  efSIN,
  efSQRT,
  efTAN,
  // date and time
  efCURDATE,
  efCURTIME,
  efNOW,
  efDAYNAME,
  efDAYOFMONTH,
  efDAYOFWEEK,
  efDAYOFYEAR,
  efHOUR,
  efMINUTE,
  efMONTH,
  efMONTHNAME,
  efQUARTER,
  efSECOND,
  efYEAR,
  // system
  efIFNULL:
    Result := sName + AddArgs;
  // convert
  efCONVERT:
    if FServerVersion >= mvMySQL040000 then
      Result := sName + AddArgs
    else
      Result := A1;
  // character
  efDIFFERENCE:  Result := '(SOUNDEX(' + A1 + ') - SOUNDEX(' + A2 + '))';
  efLENGTH:      Result := 'LENGTH(RTRIM(' + A1 + '))';
  efPOSITION:    Result := 'POSITION(' + A1 + ' IN ' + A2 + ')';
  efBIT_LENGTH:
    if FServerVersion >= mvMySQL040000 then
      Result := sName + AddArgs
    else
      Result := '(LENGTH(' + A1 + ') * 8)';
  // numeric
  efRANDOM:      Result := 'RAND' + AddArgs;
  efROUND,
  efTRUNCATE:
    if A2 = '' then
      Result := sName + '(' + A1 + ', 0)'
    else
      Result := sName + AddArgs;
  // date and time
  efTIMESTAMPADD:
    if FServerVersion >= mvMySQL050000 then begin
      if A1[1] = '''' then
        ASeq.FArgs[0] := Copy(A1, 2, Length(A1) - 2);
      Result := sName + AddArgs;
    end
    else begin
      if A1[1] = '''' then
        A1 := Copy(A1, 2, Length(A1) - 2);
      if CompareText(A1, 'week') = 0 then begin
        A2 := A2 + ' * 7';
        A1 := 'DAY';
      end;
      Result := 'DATE_ADD(' + A3 + ', INTERVAL ' + A2 + ' ' + A1 + ')';
    end;
  efTIMESTAMPDIFF:
    if FServerVersion >= mvMySQL050000 then begin
      if A1[1] = '''' then
        ASeq.FArgs[0] := Copy(A1, 2, Length(A1) - 2);
      Result := sName + AddArgs;
    end
    else
      UnsupportedEscape(ASeq);
  efEXTRACT:
    begin
      if A1[1] = '''' then
        A1 := Copy(A1, 2, Length(A1) - 2);
      Result := sName + '(' + A1 + ' FROM ' + A2 + ')';
    end;
  efWEEK:
    if FServerVersion >= mvMySQL040000 then
      Result := '(WEEK(' + A1 + ') + 1)'
    else
      Result := sName + AddArgs;
  // system
  efCATALOG:     Result := 'DATABASE()';
  efSCHEMA:      Result := '''''';
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
  else
    UnsupportedEscape(ASeq);
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLMetadata.InternalEscapeEscape(AEscape: Char; const AStr: String): String;
begin
  Result := AStr + ' ESCAPE ''';
  if AEscape = '\' then
    Result := Result + '\\'''
  else
    Result := Result + AEscape + '''';
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLMetadata.InternalGetSQLCommandKind(
  const AToken: String): TADPhysCommandKind;
begin
  if AToken = 'SHOW' then
    Result := skSelect
  else if AToken = 'EXPLAIN' then
    Result := skSelect
  else if AToken = 'CALL' then
    Result := skExecute
  else
    Result := inherited InternalGetSQLCommandKind(AToken);
end;

{-------------------------------------------------------------------------------}
{ TADPhysMySQLCommandGenerator                                                  }
{-------------------------------------------------------------------------------}
function TADPhysMySQLCommandGenerator.GetIdentity: String;
begin
  Result := 'LAST_INSERT_ID()';
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLCommandGenerator.GetPessimisticLock: String;
var
  lNeedFrom: Boolean;
begin
  ASSERT(FOptions.UpdateOptions.LockWait); // ???
  lNeedFrom := False;
  Result := 'SELECT ' + GetSelectList(True, False, lNeedFrom) + BRK +
    'FROM ' + GetFrom + BRK + 'WHERE ' + GetWhere(False) + BRK +
    'LOCK IN SHARE MODE';
  FCommandKind := skSelectForUpdate;
  ASSERT(lNeedFrom);
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLCommandGenerator.GetSavepoint(const AName: String): String;
begin
  Result := 'SAVEPOINT ' + AName;
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLCommandGenerator.GetRollbackToSavepoint(const AName: String): String;
begin
  Result := 'ROLLBACK TO SAVEPOINT ' + AName;
end;

end.
