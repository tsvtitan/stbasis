{-------------------------------------------------------------------------------}
{ AnyDAC ADS metadata                                                           }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit daADPhysADSMeta;

interface

uses
  daADStanIntf,
  daADPhysIntf, daADPhysManager, daADPhysConnMeta, daADPhysCmdGenerator;

type
  TADPhysADSMetadata = class (TADPhysConnectionMetadata)
  protected
    function GetKind: TADRDBMSKind; override;
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
    function GetParamMark: TADPhysParamMark; override;
    function GetInlineRefresh: Boolean; override;
    function GetSelectWithoutFrom: Boolean; override;
    function GetAsyncAbortSupported: Boolean; override;
    function GetLockNoWait: Boolean; override;
    function GetDefValuesSupported: TADPhysDefaultValues; override;
    function GetEnableIdentityInsert: Boolean; override;
    function GetNameQuotedCaseSensParts: TADPhysNameParts; override;
    function InternalEscapeDate(const AStr: String): String; override;
    function InternalEscapeDateTime(const AStr: String): String; override;
    function InternalEscapeFloat(const AStr: String): String; override;
    function InternalEscapeFunction(const ASeq: TADPhysEscapeData): String; override;
    function InternalEscapeTime(const AStr: String): String; override;
    function InternalGetSQLCommandKind(const AToken: String): TADPhysCommandKind; override;
  end;

  TADPhysADSCommandGenerator = class(TADPhysCommandGenerator)
  protected
    function GetSavepoint(const AName: String): String; override;
    function GetRollbackToSavepoint(const AName: String): String; override;
    function GetSingleRowTable: String; override;
    function GetIdentity: String; override;
  end;

implementation

uses
  SysUtils, DB,
  daADStanConst, daADDatSManager;

{-------------------------------------------------------------------------------}
{ TADPhysADSMetadata                                                            }
{-------------------------------------------------------------------------------}
function TADPhysADSMetadata.GetKind: TADRDBMSKind;
begin
  Result := mkADS;
end;

{-------------------------------------------------------------------------------}
function TADPhysADSMetadata.GetNameQuotedCaseSensParts: TADPhysNameParts;
begin
  Result := [];
end;

{-------------------------------------------------------------------------------}
function TADPhysADSMetadata.GetNameCaseSensParts: TADPhysNameParts;
begin
  Result := [];
end;

{-------------------------------------------------------------------------------}
function TADPhysADSMetadata.GetNameDefLowCaseParts: TADPhysNameParts;
begin
  Result := [];
end;

{-------------------------------------------------------------------------------}
function TADPhysADSMetadata.GetParamNameMaxLength: Integer;
begin
  Result := 63;
end;

{-------------------------------------------------------------------------------}
function TADPhysADSMetadata.GetNameParts: TADPhysNameParts;
begin
  Result := [npCatalog, npBaseObject, npObject];
end;

{-------------------------------------------------------------------------------}
function TADPhysADSMetadata.GetNameQuotaChar1: Char;
begin
  Result := '"';
end;

{-------------------------------------------------------------------------------}
function TADPhysADSMetadata.GetNameQuotaChar2: Char;
begin
  Result := '"';
end;

{-------------------------------------------------------------------------------}
function TADPhysADSMetadata.GetParamMark: TADPhysParamMark;
begin
  Result := prQMark;
end;

{-------------------------------------------------------------------------------}
function TADPhysADSMetadata.GetTxAutoCommit: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysADSMetadata.GetTxNested: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADPhysADSMetadata.GetTxSavepoints: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysADSMetadata.GetTxSupported: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysADSMetadata.GetInlineRefresh: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADPhysADSMetadata.GetEnableIdentityInsert: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADPhysADSMetadata.GetDefValuesSupported: TADPhysDefaultValues;
begin
  Result := dvDef;
end;

{-------------------------------------------------------------------------------}
function TADPhysADSMetadata.GetSelectWithoutFrom: Boolean;
begin
  { TODO }
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysADSMetadata.GetLockNoWait: Boolean;
begin
  Result := False;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysADSMetadata.GetAsyncAbortSupported: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysADSMetadata.InternalEscapeDate(const AStr: String): String;
begin
  { TODO }
  Result := inherited InternalEscapeDate(AStr);
end;

{-------------------------------------------------------------------------------}
function TADPhysADSMetadata.InternalEscapeDateTime(const AStr: String): String;
begin
  { TODO }
  Result := inherited InternalEscapeDateTime(AStr);
end;

{-------------------------------------------------------------------------------}
function TADPhysADSMetadata.InternalEscapeTime(const AStr: String): String;
begin
  { TODO }
  Result := inherited InternalEscapeTime(AStr);
end;

{-------------------------------------------------------------------------------}
function TADPhysADSMetadata.InternalEscapeFloat(const AStr: String): String;
begin
  { TODO }
  Result := inherited InternalEscapeFloat(AStr);
end;

{-------------------------------------------------------------------------------}
function TADPhysADSMetadata.InternalEscapeFunction(const ASeq: TADPhysEscapeData): String;
var
  sName: String;
  A1, A2, A3, A4: String;
  // rSeq: TADPhysEscapeData;
  // i: Integer;

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
  { TODO }
  efIFNULL:      Result := 'CASE WHEN ' + A1 + ' IS NULL THEN ' + A2 + ' ELSE ' + A1 + ' END';
  else
    UnsupportedEscape(ASeq);
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysADSMetadata.InternalGetSQLCommandKind(
  const AToken: String): TADPhysCommandKind;
begin
  if AToken = 'DECLARE' then
    Result := skExecute
  else
    Result := inherited InternalGetSQLCommandKind(AToken);
end;

{-------------------------------------------------------------------------------}
{ TADPhysADSCommandGenerator                                                    }
{-------------------------------------------------------------------------------}
function TADPhysADSCommandGenerator.GetIdentity: String;
begin
  Result := 'LASTAUTOINC(STATEMENT)';
end;

{-------------------------------------------------------------------------------}
function TADPhysADSCommandGenerator.GetSingleRowTable: String;
begin
  Result := 'SYSTEM.IOTA';
end;

{-------------------------------------------------------------------------------}
function TADPhysADSCommandGenerator.GetSavepoint(const AName: String): String;
begin
  Result := 'SAVEPOINT ' + AName;
end;

{-------------------------------------------------------------------------------}
function TADPhysADSCommandGenerator.GetRollbackToSavepoint(const AName: String): String;
begin
  Result := 'ROLLBACK TO SAVEPOINT ' + AName;
end;

end.
