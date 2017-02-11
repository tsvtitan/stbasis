{-------------------------------------------------------------------------------}
{ AnyDAC MS Access metadata                                                     }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit daADPhysMSAccMeta;

interface

uses
  daADStanIntf,
  daADPhysIntf, daADPhysConnMeta, daADPhysCmdGenerator;

type
  TADPhysMSAccMetadata = class (TADPhysConnectionMetadata)
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
    function GetTruncateSupported: Boolean; override;
    function GetDefValuesSupported: TADPhysDefaultValues; override;
    function GetAsyncAbortSupported: Boolean; override;
    function InternalEscapeBoolean(const AStr: String): String; override;
    function InternalEscapeDate(const AStr: String): String; override;
    function InternalEscapeDateTime(const AStr: String): String; override;
    function InternalEscapeFloat(const AStr: String): String; override;
    function InternalEscapeFunction(const ASeq: TADPhysEscapeData): String; override;
    function InternalEscapeTime(const AStr: String): String; override;
    function InternalEscapeEscape(AEscape: Char; const AStr: String): String; override;
  end;

  TADPhysMSAccCommandGenerator = class(TADPhysCommandGenerator)
  protected
    function GetIdentity: String; override;
  end;

implementation

uses
  SysUtils,
  daADStanConst;

{-------------------------------------------------------------------------------}
{ TADPhysOraMetadata                                                            }
{-------------------------------------------------------------------------------}
function TADPhysMSAccMetadata.GetKind: TADRDBMSKind;
begin
  Result := mkMSAccess;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSAccMetadata.GetNameQuotedCaseSensParts: TADPhysNameParts;
begin
  Result := [];
end;

{-------------------------------------------------------------------------------}
function TADPhysMSAccMetadata.GetNameCaseSensParts: TADPhysNameParts;
begin
  Result := [];
end;

{-------------------------------------------------------------------------------}
function TADPhysMSAccMetadata.GetNameDefLowCaseParts: TADPhysNameParts;
begin
  Result := [];
end;

{-------------------------------------------------------------------------------}
function TADPhysMSAccMetadata.GetParamNameMaxLength: Integer;
begin
  Result := 30;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSAccMetadata.GetNameParts: TADPhysNameParts;
begin
  Result := [npBaseObject, npObject];
end;

{-------------------------------------------------------------------------------}
function TADPhysMSAccMetadata.GetNameQuotaChar1: Char;
begin
  Result := '[';
end;

{-------------------------------------------------------------------------------}
function TADPhysMSAccMetadata.GetNameQuotaChar2: Char;
begin
  Result := ']';
end;

{-------------------------------------------------------------------------------}
function TADPhysMSAccMetadata.GetParamMark: TADPhysParamMark;
begin
  Result := prQMark;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSAccMetadata.GetTxAutoCommit: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSAccMetadata.GetTxNested: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSAccMetadata.GetTxSavepoints: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSAccMetadata.GetTxSupported: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSAccMetadata.GetTruncateSupported: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSAccMetadata.GetDefValuesSupported: TADPhysDefaultValues;
begin
  Result := dvNone;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSAccMetadata.GetAsyncAbortSupported: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSAccMetadata.InternalEscapeBoolean(
  const AStr: String): String;
begin
  Result := AStr;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSAccMetadata.InternalEscapeDate(const AStr: String): String;
begin
  Result := 'DATEVALUE(''' + AStr + ''')';
end;

{-------------------------------------------------------------------------------}
function TADPhysMSAccMetadata.InternalEscapeDateTime(const AStr: String): String;
begin
  Result := 'CDATE(''' + AStr + ''')';
end;

{-------------------------------------------------------------------------------}
function TADPhysMSAccMetadata.InternalEscapeTime(const AStr: String): String;
begin
  Result := 'TIMEVALUE(''' + AStr + ''')';
end;

{-------------------------------------------------------------------------------}
function TADPhysMSAccMetadata.InternalEscapeFloat(const AStr: String): String;
begin
  Result := AStr;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSAccMetadata.InternalEscapeFunction(const ASeq: TADPhysEscapeData): String;
var
  i: Integer;
  sEnd: String;
  A1, A2, A3, A4: String;

  function Intv2Acc(AIntv: String): String;
  begin
    if AIntv[1] = '''' then
      AIntv := Copy(AIntv, 2, Length(AIntv) - 2);
    AIntv := UpperCase(AIntv);
    if AIntv = 'YEAR' then
      Result := '''yyyy'''
    else if AIntv = 'QUARTER' then
      Result := '''Q'''
    else if AIntv = 'MONTH' then
      Result := '''m'''
    else if AIntv = 'WEEK' then
      Result := '''ww'''
    else if AIntv = 'DAY' then
      Result := '''d'''
    else if AIntv = 'HOUR' then
      Result := '''H'''
    else if AIntv = 'MINUTE' then
      Result := '''N'''
    else if AIntv = 'SECOND' then
      Result := '''S'''
    else
      UnsupportedEscape(ASeq);
  end;

begin
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
  efREPEAT,
  efRIGHT,
  efRTRIM,
  efSPACE,
  efSOUNDEX,
  efSUBSTRING,
  efCONCAT,
  efLCASE,
  efLOCATE,
  efUCASE,
  // numeric
  efACOS,
  efASIN,
  efATAN,
  efABS,
  efCEILING,
  efCOS,
  efCOT,
  efEXP,
  efFLOOR,
  efLOG,
  efMOD,
  efPOWER,
  efROUND,
  efSIGN,
  efSIN,
  efSQRT,
  efTAN,
  efRANDOM,
  efATAN2,
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
  efWEEK,
  efYEAR:         Result := '{fn ' + ASeq.FName + '(' + AddEscapeSequenceArgs(ASeq) + ')}';
  // system
  efIFNULL:       Result := 'IIF(' + A1 + ' IS NULL, ' + A2 + ', ' + A1 + ')';
  efIF:           Result := 'IIF(' + AddEscapeSequenceArgs(ASeq) + ')';
  efDECODE:
    begin
      i := 1;
      sEnd := '';
      Result := '';
      while i <= Length(ASeq.FArgs) - 2 do begin
        if i > 1 then
          Result := Result + ', ';
        Result := Result + 'IIF(' + A1 + ' = ' + ASeq.FArgs[i] +
          ', ' + ASeq.FArgs[i + 1];
        sEnd := sEnd + ')';
        Inc(i, 2);
      end;
      if i = Length(ASeq.FArgs) - 1 then begin
        if i > 1 then
          Result := Result + ', ';
        Result := Result + ASeq.FArgs[i];
      end;
      Result := Result + sEnd;
    end;
  // char
  efPOSITION:     Result := 'INSTR(1, ' + A2 + ', ' + A1 + ')';
  efBIT_LENGTH:   Result := '(LEN(' + A1 + ') * 8)';
  efCHAR_LENGTH,
  efLENGTH,
  efOCTET_LENGTH: Result := 'LEN(' + A1 + ')';
  efINSERT:       Result := 'MID(' + A1 + ', 1, ' + A2 + '- 1) & ' + A4 +
                    '& MID(' + A1 + ', (' + A2 + ') + (' + A3 + '), LEN(' + A1 + '))';
  efREPLACE:      Result := 'REPLACE(' + AddEscapeSequenceArgs(ASeq) + ')';
  // date and time
  efEXTRACT:      Result := 'DATEPART(' + Intv2Acc(A1) + ', ' + A2 + ')';
  efTIMESTAMPADD: Result := 'DATEADD(' + Intv2Acc(A1) + ', ' + A2 + ', ' + A3 + ')';
  efTIMESTAMPDIFF:Result := 'DATEDIFF(' + Intv2Acc(A1) + ', ' + A2 + ', ' + A3 + ')';
  // system
  efCATALOG:      Result := '{fn DATABASE()}';
  efSCHEMA:       Result := '{fn USER()';
  // numeric
  efPI:           Result := S_AD_Pi;
  efDEGREES:      Result := '(180 * (' + A1 + ') / ' + S_AD_Pi + ')';
  efRADIANS:      Result := '(' + S_AD_Pi + ' * (' + A1 + ') / 180)';
  efTRUNCATE:     Result := 'INT(' + A1 + ')';
  efLOG10:        Result := '(LOG(' + A1 + ') / LOG(10))';
  // convert
  efCONVERT:
    begin
      if A2[1] = '''' then
        A2 := Copy(A2, 2, Length(A2) - 2);
      Result := '{fn CONVERT(' + A1 + ', SQL_' + UpperCase(A2) + ')}';
    end;
  else
    UnsupportedEscape(ASeq);
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSAccMetadata.InternalEscapeEscape(AEscape: Char;
  const AStr: String): String;
var
  i: Integer;
begin
  Result := AStr;
  i := 1;
  while i <= Length(Result) do
    if Result[i] = AEscape then begin
      Result := Copy(Result, 1, i - 1) + '[' + Result[i + 1] + ']' +
        Copy(Result, i + 2, Length(Result));
      Inc(i, 3);
    end
    else
      Inc(i);
end;

{-------------------------------------------------------------------------------}
{ TADPhysMSAccCommandGenerator                                                  }
{-------------------------------------------------------------------------------}
function TADPhysMSAccCommandGenerator.GetIdentity: String;
begin
  Result := '@@IDENTITY';
end;

end.
