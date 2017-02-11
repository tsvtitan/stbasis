{ ----------------------------------------------------------------------------- }
{ AnyDAC ODBC metadata                                                          }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{ ----------------------------------------------------------------------------- }
{$I daAD.inc}

unit daADPhysODBCMeta;

interface

uses
  daADStanIntf,
  daADPhysIntf, daADPhysManager, daADPhysConnMeta, daADPhysODBCBase,
    daADPhysODBCCli;

type
  __TADPhysConnectionMetadata = class(TADPhysConnectionMetadata)
  end;

  TADPhysODBCMetadata = class(TADPhysConnectionMetadata)
  private
    FConnectionObj: TADPhysODBCConnectionBase;
    FNameMaxLength: Integer;
    FNameQuotaChar1: Char;
    FNameQuotaChar2: Char;
    FParentMeta: __TADPhysConnectionMetadata;
    FTxNested: Boolean;
    FTxSupported: Boolean;
    FQuotedIdentifierCase: SQLUSmallint;
    FIdentifierCase: SQLUSmallint;
    FCatalogUsage: SQLUInteger;
    FSchemaUsage: SQLUInteger;
    FCancelSupported: Boolean;
  protected
    function GetAsyncAbortSupported: Boolean; override;
    function GetDefValuesSupported: TADPhysDefaultValues; override;
    function GetEnableIdentityInsert: Boolean; override;
    function GetInlineRefresh: Boolean; override;
    function GetInsertBlobsAfterReturning: Boolean; override;
    function GetKind: TADRDBMSKind; override;
    function GetLockNoWait: Boolean; override;
    function GetNameCaseSensParts: TADPhysNameParts; override;
    function GetNameDefLowCaseParts: TADPhysNameParts; override;
    function GetNameParts: TADPhysNameParts; override;
    function GetNameQuotaChar1: Char; override;
    function GetNameQuotaChar2: Char; override;
    function GetNameQuotedCaseSensParts: TADPhysNameParts; override;
    function GetParamNameMaxLength: Integer; override;
    function GetSelectWithoutFrom: Boolean; override;
    function GetTruncateSupported: Boolean; override;
    function GetTxAutoCommit: Boolean; override;
    function GetTxNested: Boolean; override;
    function GetTxSavepoints: Boolean; override;
    function GetTxSupported: Boolean; override;
    procedure InternalDecodeObjName(const AName: String; var AParsedName:
      TADPhysParsedName; const ACommand: IADPhysCommand); override;
    function InternalEncodeObjName(const AParsedName: TADPhysParsedName; const ACommand:
      IADPhysCommand): string; override;
    function InternalGetSQLCommandKind(const AToken: String): TADPhysCommandKind; override;
    function TranslateEscapeSequence(var ASeq: TADPhysEscapeData): string; override;
  public
    constructor Create({$IFDEF AnyDAC_MONITOR} const AMonitor: IADMoniClient;
      {$ENDIF} const AConnection: TADPhysConnection; AConnectionObj:
      TADPhysODBCConnectionBase; AParentMeta: TADPhysConnectionMetadata);
    destructor Destroy; override;
  end;

implementation

uses
  SysUtils;

type
  __TADPhysODBCConnectionBase = class(TADPhysODBCConnectionBase)
  end;

{------------------------------------------------------------------------------}
{ TADPhysODBCMetadata                                                          }
{------------------------------------------------------------------------------}
constructor TADPhysODBCMetadata.Create({$IFDEF AnyDAC_MONITOR} const AMonitor:
  IADMoniClient; {$ENDIF} const AConnection: TADPhysConnection; AConnectionObj:
  TADPhysODBCConnectionBase; AParentMeta: TADPhysConnectionMetadata);
var
  C: string;
begin
  inherited Create({$IFDEF AnyDAC_MONITOR} AMonitor, {$ENDIF} AConnection);
  FParentMeta := __TADPhysConnectionMetadata(AParentMeta);
  if FParentMeta = nil then begin
    FConnectionObj := AConnectionObj;
    with __TADPhysODBCConnectionBase(FConnectionObj) do
      if GetState = csConnected then begin
        FTxSupported := ODBCConnection.TXN_CAPABLE <> SQL_TC_NONE;
        FTxNested := ODBCConnection.MULTIPLE_ACTIVE_TXN = 'Y';
        FNameMaxLength := ODBCConnection.MAX_COLUMN_NAME_LEN;
        C := ODBCConnection.IDENTIFIER_QUOTE_CHAR;
        if Length(C) = 2 then begin
          FNameQuotaChar1 := C[1];
          FNameQuotaChar2 := C[2];
        end
        else begin
          FNameQuotaChar1 := C[1];
          FNameQuotaChar2 := C[1];
        end;
        FQuotedIdentifierCase := ODBCConnection.QUOTED_IDENTIFIER_CASE;
        FIdentifierCase := ODBCConnection.IDENTIFIER_CASE;
        FCatalogUsage := ODBCConnection.CATALOG_USAGE;
        FSchemaUsage := ODBCConnection.SCHEMA_USAGE;
        FCancelSupported := ODBCConnection.GetFunctions(SQL_API_SQLCANCEL) = SQL_TRUE;
        ConfigNameParts;
      end
      else begin
        FTxSupported := inherited GetTxSupported;
        FTxNested := inherited GetTxNested;
        FNameMaxLength := inherited GetParamNameMaxLength;
        FNameQuotaChar1 := inherited GetNameQuotaChar1;
        FNameQuotaChar2 := inherited GetNameQuotaChar2;
        FQuotedIdentifierCase := SQL_IC_SENSITIVE;
        FIdentifierCase := SQL_IC_UPPER;
        FCatalogUsage := 0;
        FSchemaUsage := 0;
        FCancelSupported := True;
      end;
  end;
end;

{------------------------------------------------------------------------------}
destructor TADPhysODBCMetadata.Destroy;
begin
  FreeAndNil(FParentMeta);
  inherited Destroy;
end;

{------------------------------------------------------------------------------}
function TADPhysODBCMetadata.GetAsyncAbortSupported: Boolean;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetAsyncAbortSupported
  else
    Result := FCancelSupported;
end;

{------------------------------------------------------------------------------}
function TADPhysODBCMetadata.GetDefValuesSupported: TADPhysDefaultValues;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetDefValuesSupported
  else
    Result := inherited GetDefValuesSupported;
end;

{------------------------------------------------------------------------------}
function TADPhysODBCMetadata.GetEnableIdentityInsert: Boolean;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetEnableIdentityInsert
  else
    Result := inherited GetEnableIdentityInsert;
end;

{------------------------------------------------------------------------------}
function TADPhysODBCMetadata.GetInlineRefresh: Boolean;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetInlineRefresh
  else
    Result := inherited GetInlineRefresh;
end;

{------------------------------------------------------------------------------}
function TADPhysODBCMetadata.GetInsertBlobsAfterReturning: Boolean;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetInsertBlobsAfterReturning
  else
    Result := inherited GetInsertBlobsAfterReturning;
end;

{------------------------------------------------------------------------------}
function TADPhysODBCMetadata.GetKind: TADRDBMSKind;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetKind
  else
    Result := inherited GetKind;
end;

{------------------------------------------------------------------------------}
function TADPhysODBCMetadata.GetLockNoWait: Boolean;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetLockNoWait
  else
    Result := inherited GetLockNoWait;
end;

{------------------------------------------------------------------------------}
function TADPhysODBCMetadata.GetNameCaseSensParts: TADPhysNameParts;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetNameCaseSensParts
  else if FIdentifierCase = SQL_IC_SENSITIVE then
    Result := [npCatalog, npSchema, npDBLink, npBaseObject, npObject]
  else
    Result := [];
end;

{------------------------------------------------------------------------------}
function TADPhysODBCMetadata.GetNameDefLowCaseParts: TADPhysNameParts;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetNameDefLowCaseParts
  else if FIdentifierCase = SQL_IC_LOWER then
    Result := [npCatalog, npSchema, npDBLink, npBaseObject, npObject]
  else
    Result := [];
end;

{------------------------------------------------------------------------------}
function TADPhysODBCMetadata.GetNameParts: TADPhysNameParts;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetNameParts
  else begin
    Result := inherited GetNameParts;
    if FCatalogUsage and SQL_CU_DML_STATEMENTS = SQL_CU_DML_STATEMENTS then
      Include(Result, npCatalog);
    if FSchemaUsage and SQL_SU_DML_STATEMENTS = SQL_SU_DML_STATEMENTS then
      Include(Result, npSchema);
  end;
end;

{------------------------------------------------------------------------------}
function TADPhysODBCMetadata.GetNameQuotaChar1: Char;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetNameQuotaChar1
  else
    Result := FNameQuotaChar1;
end;

{------------------------------------------------------------------------------}
function TADPhysODBCMetadata.GetNameQuotaChar2: Char;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetNameQuotaChar2
  else
    Result := FNameQuotaChar2;
end;

{------------------------------------------------------------------------------}
function TADPhysODBCMetadata.GetNameQuotedCaseSensParts: TADPhysNameParts;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetNameQuotedCaseSensParts
  else if FQuotedIdentifierCase = SQL_IC_SENSITIVE then
    Result := [npCatalog, npSchema, npDBLink, npBaseObject, npObject]
  else
    Result := [];
end;

{------------------------------------------------------------------------------}
function TADPhysODBCMetadata.GetParamNameMaxLength: Integer;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetParamNameMaxLength
  else
    Result := FNameMaxLength;
end;

{------------------------------------------------------------------------------}
function TADPhysODBCMetadata.GetSelectWithoutFrom: Boolean;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetSelectWithoutFrom
  else
    Result := inherited GetSelectWithoutFrom;
end;

{------------------------------------------------------------------------------}
function TADPhysODBCMetadata.GetTruncateSupported: Boolean;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetTruncateSupported
  else
    Result := inherited GetTruncateSupported;
end;

{------------------------------------------------------------------------------}
function TADPhysODBCMetadata.GetTxAutoCommit: Boolean;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetTxAutoCommit
  else
    Result := inherited GetTxAutoCommit;
end;

{------------------------------------------------------------------------------}
function TADPhysODBCMetadata.GetTxNested: Boolean;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetTxNested
  else
    Result := FTxNested;
end;

{------------------------------------------------------------------------------}
function TADPhysODBCMetadata.GetTxSavepoints: Boolean;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetTxSavepoints
  else
    Result := inherited GetTxSavepoints;
end;

{------------------------------------------------------------------------------}
function TADPhysODBCMetadata.GetTxSupported: Boolean;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetTxSupported
  else
    Result := FTxSupported;
end;

{------------------------------------------------------------------------------}
procedure TADPhysODBCMetadata.InternalDecodeObjName(const AName: String; var AParsedName:
  TADPhysParsedName; const ACommand: IADPhysCommand);
begin
  if FParentMeta <> nil then
    FParentMeta.InternalDecodeObjName(AName, AParsedName, ACommand)
  else
    inherited InternalDecodeObjName(AName, AParsedName, ACommand);
end;

{------------------------------------------------------------------------------}
function TADPhysODBCMetadata.InternalEncodeObjName(const AParsedName: TADPhysParsedName;
  const ACommand: IADPhysCommand): string;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.InternalEncodeObjName(AParsedName, ACommand)
  else begin
    Result := inherited InternalEncodeObjName(AParsedName, ACommand);
  end;
end;

{------------------------------------------------------------------------------}
function TADPhysODBCMetadata.InternalGetSQLCommandKind(const AToken: String):
  TADPhysCommandKind;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetSQLCommandKind(AToken)
  else
    Result := inherited InternalGetSQLCommandKind(AToken);
end;

{------------------------------------------------------------------------------}
function TADPhysODBCMetadata.TranslateEscapeSequence(var ASeq: TADPhysEscapeData): string;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.TranslateEscapeSequence(ASeq)
  else
    Result := inherited TranslateEscapeSequence(ASeq);
end;

end.

