{-------------------------------------------------------------------------------}
{ AnyDAC TDBX metadata                                                          }
{ Copyright (c) 2004-2007 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit daADPhysTDBXMeta;

interface

uses
  daADStanIntf,
  daADPhysIntf, daADPhysManager, daADPhysConnMeta, daADPhysTDBX;

type
  __TADPhysConnectionMetadata = class(TADPhysConnectionMetadata)
  end;

  TADPhysTDBXMetadata = class (TADPhysConnectionMetadata)
  private
    FTxSupported: Boolean;
    FTxNested: Boolean;
    FNameMaxLength: Integer;
    FNameQuotaChar1: Char;
    FNameQuotaChar2: Char;
    FParentMeta: __TADPhysConnectionMetadata;
  protected
    // uses ParentMeta
    function GetTxSavepoints: Boolean; override;
    function GetTxAutoCommit: Boolean; override;
    function GetNameParts: TADPhysNameParts; override;
    function GetNameQuotedCaseSensParts: TADPhysNameParts; override;
    function GetNameCaseSensParts: TADPhysNameParts; override;
    function GetNameDefLowCaseParts: TADPhysNameParts; override;
    function GetInsertBlobsAfterReturning: Boolean; override;
    function GetEnableIdentityInsert: Boolean; override;
    function GetTruncateSupported: Boolean; override;
    function GetDefValuesSupported: TADPhysDefaultValues; override;
    function GetInlineRefresh: Boolean; override;
    function GetSelectWithoutFrom: Boolean; override;
    function GetKind: TADRDBMSKind; override;
    function GetLockNoWait: Boolean; override;
    function GetAsyncAbortSupported: Boolean; override;
    function InternalGetSQLCommandKind(const AToken: String): TADPhysCommandKind; override;
    function TranslateEscapeSequence(var ASeq: TADPhysEscapeData): String; override;
    function GetTxSupported: Boolean; override;
    function GetTxNested: Boolean; override;
    function GetParamNameMaxLength: Integer; override;
    function GetNameQuotaChar1: Char; override;
    function GetNameQuotaChar2: Char; override;
    procedure InternalDecodeObjName(const AName: String; var AParsedName: TADPhysParsedName;
      const ACommand: IADPhysCommand); override;
    function InternalEncodeObjName(const AParsedName: TADPhysParsedName;
      const ACommand: IADPhysCommand): String; override;
  public
    constructor Create(
      {$IFDEF AnyDAC_MONITOR} const AMonitor: IADMoniClient; {$ENDIF}
      const AConnection: TADPhysConnection; AParentMeta: TADPhysConnectionMetadata);
    destructor Destroy; override;
  end;

implementation

uses
  SysUtils, DBXCommon,
  daADStanUtil;

{-------------------------------------------------------------------------------}
{ TADPhysTDBXMetadata                                                          }
{-------------------------------------------------------------------------------}
constructor TADPhysTDBXMetadata.Create(
  {$IFDEF AnyDAC_MONITOR} const AMonitor: IADMoniClient; {$ENDIF}
  const AConnection: TADPhysConnection; AParentMeta: TADPhysConnectionMetadata);
var
  oDBExpMeta: TDBXDatabaseMetaData;
  oDbxConn: IADPhysTDBXConnection;
  ws: WideString;
begin
  inherited Create({$IFDEF AnyDAC_MONITOR} AMonitor, {$ENDIF} AConnection);
  FParentMeta := __TADPhysConnectionMetadata(AParentMeta);
  if FParentMeta = nil then begin
    oDbxConn := AConnection as IADPhysTDBXConnection;
    with oDbxConn do
      if State = csConnected then begin
        oDBExpMeta := DbxConnection.DatabaseMetaData;
        ws := oDBExpMeta.QuoteChar;
        if Length(ws) > 0 then begin
          FNameQuotaChar1 := AnsiChar(ws[1]);
          FNameQuotaChar2 := FNameQuotaChar1;
        end
        else begin
          FNameQuotaChar1 := inherited GetNameQuotaChar1;
          FNameQuotaChar2 := inherited GetNameQuotaChar2;
        end;
        FNameMaxLength := inherited GetParamNameMaxLength;
        FTxSupported := oDBExpMeta.SupportsTransactions;
        FTxNested := oDBExpMeta.SupportsNestedTransactions;
      end
      else begin
        FNameQuotaChar1 := inherited GetNameQuotaChar1;
        FNameQuotaChar2 := inherited GetNameQuotaChar2;
        FNameMaxLength := inherited GetParamNameMaxLength;
        FTxSupported := inherited GetTxSupported;
        FTxNested := inherited GetTxNested;
      end;
  end;
end;

{-------------------------------------------------------------------------------}
destructor TADPhysTDBXMetadata.Destroy;
begin
  FreeAndNil(FParentMeta);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADPhysTDBXMetadata.InternalEncodeObjName(const AParsedName: TADPhysParsedName;
  const ACommand: IADPhysCommand): String;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.InternalEncodeObjName(AParsedName, ACommand)
  else 
    Result := inherited InternalEncodeObjName(AParsedName, ACommand);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTDBXMetadata.InternalDecodeObjName(const AName: String;
  var AParsedName: TADPhysParsedName; const ACommand: IADPhysCommand);
begin
  if FParentMeta <> nil then
    FParentMeta.InternalDecodeObjName(AName, AParsedName, ACommand)
  else
    inherited InternalDecodeObjName(AName, AParsedName, ACommand);
end;

{-------------------------------------------------------------------------------}
function TADPhysTDBXMetadata.GetTxNested: Boolean;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetTxNested
  else
    Result := FTxNested;
end;

{-------------------------------------------------------------------------------}
function TADPhysTDBXMetadata.GetTxSupported: Boolean;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetTxSupported
  else
    Result := FTxSupported;
end;

{-------------------------------------------------------------------------------}
function TADPhysTDBXMetadata.GetTxAutoCommit: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysTDBXMetadata.GetTxSavepoints: Boolean;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetTxSavepoints
  else
    Result := inherited GetTxSavepoints;
end;

{-------------------------------------------------------------------------------}
function TADPhysTDBXMetadata.GetParamNameMaxLength: Integer;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetParamNameMaxLength
  else
    Result := FNameMaxLength;
end;

{-------------------------------------------------------------------------------}
function TADPhysTDBXMetadata.GetNameQuotaChar1: Char;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetNameQuotaChar1
  else
    Result := FNameQuotaChar1;
end;

{-------------------------------------------------------------------------------}
function TADPhysTDBXMetadata.GetNameQuotaChar2: Char;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetNameQuotaChar2
  else
    Result := FNameQuotaChar2;
end;

{-------------------------------------------------------------------------------}
function TADPhysTDBXMetadata.GetNameCaseSensParts: TADPhysNameParts;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetNameCaseSensParts
  else
    Result := inherited GetNameCaseSensParts;
end;

{-------------------------------------------------------------------------------}
function TADPhysTDBXMetadata.GetNameDefLowCaseParts: TADPhysNameParts;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetNameDefLowCaseParts
  else
    Result := inherited GetNameDefLowCaseParts;
end;

{-------------------------------------------------------------------------------}
function TADPhysTDBXMetadata.GetNameParts: TADPhysNameParts;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetNameParts
  else
    Result := inherited GetNameParts;
end;

{-------------------------------------------------------------------------------}
function TADPhysTDBXMetadata.GetNameQuotedCaseSensParts: TADPhysNameParts;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetNameQuotedCaseSensParts
  else
    Result := inherited GetNameQuotedCaseSensParts;
end;

{-------------------------------------------------------------------------------}
function TADPhysTDBXMetadata.GetDefValuesSupported: TADPhysDefaultValues;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetDefValuesSupported
  else
    Result := inherited GetDefValuesSupported;
end;

{-------------------------------------------------------------------------------}
function TADPhysTDBXMetadata.GetInlineRefresh: Boolean;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetInlineRefresh
  else
    Result := inherited GetInlineRefresh;
end;

{-------------------------------------------------------------------------------}
function TADPhysTDBXMetadata.GetSelectWithoutFrom: Boolean;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetSelectWithoutFrom
  else
    Result := inherited GetSelectWithoutFrom;
end;

{-------------------------------------------------------------------------------}
function TADPhysTDBXMetadata.GetInsertBlobsAfterReturning: Boolean;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetInsertBlobsAfterReturning
  else
    Result := inherited GetInsertBlobsAfterReturning;
end;

{-------------------------------------------------------------------------------}
function TADPhysTDBXMetadata.GetEnableIdentityInsert: Boolean;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetEnableIdentityInsert
  else
    Result := inherited GetEnableIdentityInsert;
end;

{-------------------------------------------------------------------------------}
function TADPhysTDBXMetadata.GetTruncateSupported: Boolean;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetTruncateSupported
  else
    Result := inherited GetTruncateSupported;
end;

{-------------------------------------------------------------------------------}
function TADPhysTDBXMetadata.GetKind: TADRDBMSKind;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetKind
  else
    Result := inherited GetKind;
end;

{-------------------------------------------------------------------------------}
function TADPhysTDBXMetadata.GetLockNoWait: Boolean;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetLockNoWait
  else
    Result := inherited GetLockNoWait;
end;

{-------------------------------------------------------------------------------}
function TADPhysTDBXMetadata.GetAsyncAbortSupported: Boolean;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetAsyncAbortSupported
  else
    Result := inherited GetAsyncAbortSupported;
end;

{-------------------------------------------------------------------------------}
function TADPhysTDBXMetadata.InternalGetSQLCommandKind(const AToken: String): TADPhysCommandKind;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetSQLCommandKind(AToken)
  else
    Result := inherited InternalGetSQLCommandKind(AToken);
end;

{-------------------------------------------------------------------------------}
function TADPhysTDBXMetadata.TranslateEscapeSequence(var ASeq: TADPhysEscapeData): String;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.TranslateEscapeSequence(ASeq)
  else
    Result := inherited TranslateEscapeSequence(ASeq);
end;

end.
