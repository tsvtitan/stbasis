{-------------------------------------------------------------------------------}
{ AnyDAC DBExpress metadata                                                     }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit daADPhysDBExpMeta;

interface

uses
  daADStanIntf, 
  daADPhysIntf, daADPhysManager, daADPhysConnMeta, daADPhysDBExp;

type
  __TADPhysConnectionMetadata = class(TADPhysConnectionMetadata)
  end;

  TADPhysDBExpMetadata = class (TADPhysConnectionMetadata)
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
  SysUtils, DBXpress,
  daADStanUtil;

{-------------------------------------------------------------------------------}
{ TADPhysDBExpMetadata                                                          }
{-------------------------------------------------------------------------------}
constructor TADPhysDBExpMetadata.Create(
  {$IFDEF AnyDAC_MONITOR} const AMonitor: IADMoniClient; {$ENDIF}
  const AConnection: TADPhysConnection; AParentMeta: TADPhysConnectionMetadata);
var
  oDBExpMeta: {$IFDEF AnyDAC_D10} ISQLMetaData30 {$ELSE} ISQLMetaData {$ENDIF};
  oDbxConn: IADPhysDBXConnection;
  siPropSize: SmallInt;
  C: SQLString;
  L: LongBool;
  I: Integer;
begin
  inherited Create({$IFDEF AnyDAC_MONITOR} AMonitor, {$ENDIF} AConnection);
  FParentMeta := __TADPhysConnectionMetadata(AParentMeta);
  if FParentMeta = nil then begin
    oDbxConn := AConnection as IADPhysDBXConnection;
    with oDbxConn do
      if State = csConnected then begin
        Check(DbxConnection.getSQLMetaData(oDBExpMeta));
        C := '""';
        siPropSize := 1;
        oDBExpMeta.getOption(eMetaObjectQuoteChar, @C[1], 2, siPropSize);
        if siPropSize = 2 then begin
          FNameQuotaChar1 := AnsiChar(C[1]);
          FNameQuotaChar2 := AnsiChar(C[2]);
        end
        else begin
          FNameQuotaChar1 := AnsiChar(C[1]);
          FNameQuotaChar2 := AnsiChar(C[1]);
        end;
        I := 30;
        oDBExpMeta.getOption(eMetaMaxObjectNameLength, @I, SizeOf(Integer), siPropSize);
        FNameMaxLength := I;
        L := False;
        oDBExpMeta.getOption(eMetaSupportsTransaction, @L, SizeOf(LongBool), siPropSize);
        FTxSupported := L;
        L := False;
        oDBExpMeta.getOption(eMetaSupportsTransactions, @L, SizeOf(LongBool), siPropSize);
        // get eConnMaxActiveComm
        FTxNested := L;
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
destructor TADPhysDBExpMetadata.Destroy;
begin
  FreeAndNil(FParentMeta);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADPhysDBExpMetadata.InternalEncodeObjName(const AParsedName: TADPhysParsedName;
  const ACommand: IADPhysCommand): String;
//{$IFDEF AnyDAC_D7}
//var
//  buf: array [0..255] of char;
//  wLen: SmallInt;
//{$ENDIF}
begin
  if FParentMeta <> nil then
    Result := FParentMeta.InternalEncodeObjName(AParsedName, ACommand)
  else begin
//{$IFDEF AnyDAC_D7}
//    with __TADPhysDBXConnection(FConnectionObj) do begin
//      if AParsedName.FCatalog <> '' then
//        Check(FDbxConnection.setOption(eConnCatalogName, LongInt(PChar(AParsedName.FCatalog))));
//      if AParsedName.FSchema <> '' then
//        Check(FDbxConnection.setOption(eConnSchemaName, LongInt(PChar(AParsedName.FSchema))));
//      if AParsedName.FObject <> '' then
//        Check(FDbxConnection.setOption(eConnObjectName, LongInt(PChar(AParsedName.FObject))));
//      ADFillChar(buf[0], 256, 0);
//      Check(FDbxConnection.getOption(eConnQualifiedName, @buf, SizeOf(buf), wLen));
//    end;
//    Result := PChar(@buf);
//{$ELSE}
    Result := inherited InternalEncodeObjName(AParsedName, ACommand);
//{$ENDIF}
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDBExpMetadata.InternalDecodeObjName(const AName: String;
  var AParsedName: TADPhysParsedName; const ACommand: IADPhysCommand);
{$IFDEF AnyDAC_D7}
var
  buf0, buf1, buf2: array [0..255] of char;
  wLen: SmallInt;
  oDbxConn: IADPhysDBXConnection;
  iRes: SQLResult;
{$ENDIF}
begin
  if FParentMeta <> nil then
    FParentMeta.InternalDecodeObjName(AName, AParsedName, ACommand)
  else begin
{$IFDEF AnyDAC_D7}
    if AName <> '' then begin
      oDbxConn := FConnectionObj as IADPhysDBXConnection;
      with oDbxConn do begin
        iRes := DbxConnection.setOption(eConnQualifiedName, LongInt(PChar(AName)));
        if iRes <> DBXERR_NOTSUPPORTED then begin
          Check(iRes);
          ADFillChar(buf0[0], 256, #0);
          Check(DbxConnection.getOption(eConnCatalogName, @buf0, SizeOf(buf0), wLen));
          if buf0[0] <> #0 then
            AParsedName.FCatalog := PChar(@buf0);
          ADFillChar(buf1[0], 256, #0);
          Check(DbxConnection.getOption(eConnSchemaName, @buf1, SizeOf(buf1), wLen));
          if buf1[0] <> #0 then
            AParsedName.FSchema := PChar(@buf1);
          ADFillChar(buf2[0], 256, #0);
          Check(DbxConnection.getOption(eConnObjectName, @buf2, SizeOf(buf2), wLen));
          if buf2[0] <> #0 then
            AParsedName.FObject := PChar(@buf2);
        end
        else
          inherited InternalDecodeObjName(AName, AParsedName, ACommand);
      end;
    end;
{$ELSE}
    inherited InternalDecodeObjName(AName, AParsedName, ACommand);
{$ENDIF}
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysDBExpMetadata.GetTxNested: Boolean;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetTxNested
  else
    Result := FTxNested;
end;

{-------------------------------------------------------------------------------}
function TADPhysDBExpMetadata.GetTxSupported: Boolean;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetTxSupported
  else
    Result := FTxSupported;
end;

{-------------------------------------------------------------------------------}
function TADPhysDBExpMetadata.GetTxAutoCommit: Boolean;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetTxAutoCommit
  else
    Result := inherited GetTxAutoCommit;
end;

{-------------------------------------------------------------------------------}
function TADPhysDBExpMetadata.GetTxSavepoints: Boolean;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetTxSavepoints
  else
    Result := inherited GetTxSavepoints;
end;

{-------------------------------------------------------------------------------}
function TADPhysDBExpMetadata.GetParamNameMaxLength: Integer;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetParamNameMaxLength
  else
    Result := FNameMaxLength;
end;

{-------------------------------------------------------------------------------}
function TADPhysDBExpMetadata.GetNameQuotaChar1: Char;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetNameQuotaChar1
  else
    Result := FNameQuotaChar1;
end;

{-------------------------------------------------------------------------------}
function TADPhysDBExpMetadata.GetNameQuotaChar2: Char;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetNameQuotaChar2
  else
    Result := FNameQuotaChar2;
end;

{-------------------------------------------------------------------------------}
function TADPhysDBExpMetadata.GetNameCaseSensParts: TADPhysNameParts;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetNameCaseSensParts
  else
    Result := inherited GetNameCaseSensParts;
end;

{-------------------------------------------------------------------------------}
function TADPhysDBExpMetadata.GetNameDefLowCaseParts: TADPhysNameParts;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetNameDefLowCaseParts
  else
    Result := inherited GetNameDefLowCaseParts;
end;

{-------------------------------------------------------------------------------}
function TADPhysDBExpMetadata.GetNameParts: TADPhysNameParts;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetNameParts
  else
    Result := inherited GetNameParts;
end;

{-------------------------------------------------------------------------------}
function TADPhysDBExpMetadata.GetNameQuotedCaseSensParts: TADPhysNameParts;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetNameQuotedCaseSensParts
  else
    Result := inherited GetNameQuotedCaseSensParts;
end;

{-------------------------------------------------------------------------------}
function TADPhysDBExpMetadata.GetDefValuesSupported: TADPhysDefaultValues;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetDefValuesSupported
  else
    Result := inherited GetDefValuesSupported;
end;

{-------------------------------------------------------------------------------}
function TADPhysDBExpMetadata.GetInlineRefresh: Boolean;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetInlineRefresh
  else
    Result := inherited GetInlineRefresh;
end;

{-------------------------------------------------------------------------------}
function TADPhysDBExpMetadata.GetSelectWithoutFrom: Boolean;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetSelectWithoutFrom
  else
    Result := inherited GetSelectWithoutFrom;
end;

{-------------------------------------------------------------------------------}
function TADPhysDBExpMetadata.GetInsertBlobsAfterReturning: Boolean;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetInsertBlobsAfterReturning
  else
    Result := inherited GetInsertBlobsAfterReturning;
end;

{-------------------------------------------------------------------------------}
function TADPhysDBExpMetadata.GetEnableIdentityInsert: Boolean;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetEnableIdentityInsert
  else
    Result := inherited GetEnableIdentityInsert;
end;

{-------------------------------------------------------------------------------}
function TADPhysDBExpMetadata.GetTruncateSupported: Boolean;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetTruncateSupported
  else
    Result := inherited GetTruncateSupported;
end;

{-------------------------------------------------------------------------------}
function TADPhysDBExpMetadata.GetKind: TADRDBMSKind;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetKind
  else
    Result := inherited GetKind;
end;

{-------------------------------------------------------------------------------}
function TADPhysDBExpMetadata.GetLockNoWait: Boolean;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetLockNoWait
  else
    Result := inherited GetLockNoWait;
end;

{-------------------------------------------------------------------------------}
function TADPhysDBExpMetadata.GetAsyncAbortSupported: Boolean;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetAsyncAbortSupported
  else
    Result := inherited GetAsyncAbortSupported;
end;

{-------------------------------------------------------------------------------}
function TADPhysDBExpMetadata.InternalGetSQLCommandKind(const AToken: String): TADPhysCommandKind;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetSQLCommandKind(AToken)
  else
    Result := inherited InternalGetSQLCommandKind(AToken);
end;

{-------------------------------------------------------------------------------}
function TADPhysDBExpMetadata.TranslateEscapeSequence(var ASeq: TADPhysEscapeData): String;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.TranslateEscapeSequence(ASeq)
  else
    Result := inherited TranslateEscapeSequence(ASeq);
end;

end.
