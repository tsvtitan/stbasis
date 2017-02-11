{-------------------------------------------------------------------------------}
{ AnyDAC connection metadata base class                                         }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit daADPhysConnMeta;

interface

uses
  daADStanIntf, daADDatSManager,
  daADPhysIntf, daADPhysManager;

type
  TADPhysConnectionMetadata = class (TInterfacedObject, IUnknown,
    IADPhysConnectionMetadata)
  private
    FMaximumNameParts: Integer;
    FNameParts: array of String;
    function IsNameValid(const AName: String): Boolean;
    function IsNameQuoted(const AName: String; ACh1, ACh2: Char): Boolean;
    function NormObjName(const AName: String; APart: TADPhysNamePart): String;
    function QuoteName(const AName: String): String;
    function UnQuoteName(const AName: String; ACh1, ACh2: Char): String;
    function QuoteNameIfReq(const AName: String; APart: TADPhysNamePart): String;
    function IsRDBMSKind(const AStr: String; var ACurrent: Boolean): Boolean;
{$IFDEF AnyDAC_MONITOR}
    procedure Trace(AKind: TADMoniEventKind; AStep: TADMoniEventStep;
      const AMsg: String; AArgs: array of const);
{$ENDIF}
    function FetchNoCache(AMetaKind: TADPhysMetaInfoKind; AScope: TADPhysObjectScopes;
      AKinds: TADPhysTableKinds; const ACatalog, ASchema, ABaseObject, AWildCard: String;
      AOverload: Word): TADDatSTable;
    function CheckFetchToCache(AMetaKind: TADPhysMetaInfoKind; const AFilter: String;
      var ATable: TADDatSTable; var AView: TADDatSView): Boolean;
    procedure AddWildcard(AView: TADDatSView; const AColumn, AWildcard: String;
      APart: TADPhysNamePart);
    procedure FetchToCache(AMetaKind: TADPhysMetaInfoKind; const ACatalog, ASchema,
      ABaseObject, AObject: String; AOverload: Word; ADataTable: TADDatSTable);
    function DefineMetadataTableName(AKind: TADPhysMetaInfoKind): String;
    function GetCacheFilter(const ACatalog, ASchema, AObjField, AObj,
      ASubObjField, ASubObj: String): String;
    function ConvertNameCase(const AName: String; APart: TADPhysNamePart): String;
    procedure ParseMetaInfoParams(const ACatalog, ASchema, ABaseObjName,
      AObjName: String; var AParsedName: TADPhysParsedName);
  protected
    FMetaSchema: TADDatSManager;
{$IFDEF AnyDAC_MONITOR}
    FMonitor: IADMoniClient;
{$ENDIF}
    FConnectionObj: TADPhysConnection;
    // IUnknown
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    // TADPhysConnectionMetadata
    function GetKind: TADRDBMSKind; virtual;
    function GetClientVersion: LongWord; virtual;
    function GetServerVersion: LongWord; virtual;
    function GetTxSupported: Boolean; virtual;
    function GetTxNested: Boolean; virtual;
    function GetTxSavepoints: Boolean; virtual;
    function GetTxAutoCommit: Boolean; virtual;
    function GetParamNameMaxLength: Integer; virtual;
    function GetNameParts: TADPhysNameParts; virtual;
    function GetNameQuotedCaseSensParts: TADPhysNameParts; virtual;
    function GetNameCaseSensParts: TADPhysNameParts; virtual;
    function GetNameDefLowCaseParts: TADPhysNameParts; virtual;
    function GetNameQuotaChar1: Char; virtual;
    function GetNameQuotaChar2: Char; virtual;
    function GetInsertBlobsAfterReturning: Boolean; virtual;
    function GetEnableIdentityInsert: Boolean; virtual;
    function GetParamMark: TADPhysParamMark; virtual;
    function GetSelectWithoutFrom: Boolean; virtual;
    function GetLockNoWait: Boolean; virtual;
    function GetAsyncAbortSupported: Boolean; virtual;
    function GetCommandSeparator: String; virtual;
    procedure DecodeObjName(const AName: String; var AParsedName: TADPhysParsedName;
      const ACommand: IADPhysCommand; AOpts: TADPhysDecodeOptions);
    function EncodeObjName(const AParsedName: TADPhysParsedName;
      const ACommand: IADPhysCommand; AOpts: TADPhysEncodeOptions): String;
    function TranslateEscapeSequence(var ASeq: TADPhysEscapeData): String; virtual;
    function GetSQLCommandKind(const AToken: String): TADPhysCommandKind;
    function GetTruncateSupported: Boolean; virtual;
    function GetDefValuesSupported: TADPhysDefaultValues; virtual;
    function GetInlineRefresh: Boolean; virtual;
    function GetTables(AScope: TADPhysObjectScopes; AKinds: TADPhysTableKinds;
      const ACatalog, ASchema, AWildCard: String): TADDatSView; virtual;
    function GetTableFields(const ACatalog, ASchema, ATable, AWildCard: String): TADDatSView; virtual;
    function GetTableIndexes(const ACatalog, ASchema, ATable, AWildCard: String): TADDatSView; virtual;
    function GetTableIndexFields(const ACatalog, ASchema, ATable, AIndex, AWildCard: String): TADDatSView; virtual;
    function GetTablePrimaryKey(const ACatalog, ASchema, ATable: String): TADDatSView; virtual;
    function GetTablePrimaryKeyFields(const ACatalog, ASchema, ATable, AWildCard: String): TADDatSView; virtual;
    function GetTableForeignKeys(const ACatalog, ASchema, ATable, AWildCard: String): TADDatSView;
    function GetTableForeignKeyFields(const ACatalog, ASchema, ATable, AForeignKey, AWildCard: String): TADDatSView;
    function GetPackages(AScope: TADPhysObjectScopes; const ACatalog, ASchema, AWildCard: String): TADDatSView; virtual;
    function GetPackageProcs(const ACatalog, ASchema, APackage, AWildCard: String): TADDatSView; virtual;
    function GetProcs(AScope: TADPhysObjectScopes; const ACatalog, ASchema, AWildCard: String): TADDatSView; virtual;
    function GetProcArgs(const ACatalog, ASchema, APackage, AProc, AWildCard: String;
      AOverload: Word): TADDatSView; virtual;
    procedure DefineMetadataStructure(ATable: TADDatSTable; AKind: TADPhysMetaInfoKind);
    // other
    function InternalEncodeObjName(const AParsedName: TADPhysParsedName;
      const ACommand: IADPhysCommand): String; virtual;
    procedure InternalDecodeObjName(const AName: String;
      var AParsedName: TADPhysParsedName; const ACommand: IADPhysCommand); virtual;
    procedure InternalOverrideNameByCommand(var AParsedName: TADPhysParsedName;
      const ACommand: IADPhysCommand); virtual;
    function InternalEscapeBoolean(const AStr: String): String; virtual;
    function InternalEscapeDate(const AStr: String): String; virtual;
    function InternalEscapeDateTime(const AStr: String): String; virtual;
    function InternalEscapeFloat(const AStr: String): String; virtual;
    function InternalEscapeFunction(const ASeq: TADPhysEscapeData): String; virtual;
    function InternalEscapeTime(const AStr: String): String; virtual;
    function InternalEscapeEscape(AEscape: Char; const AStr: String): String; virtual;
    function InternalGetSQLCommandKind(const AToken: String): TADPhysCommandKind; virtual;
    // utility
    procedure UnsupportedEscape(const ASeq: TADPhysEscapeData);
    procedure EscapeFuncToID(var ASeq: TADPhysEscapeData);
    function AddEscapeSequenceArgs(const ASeq: TADPhysEscapeData): String;
    procedure ConfigNameParts;
  public
    constructor Create(
      {$IFDEF AnyDAC_MONITOR} const AMonitor: IADMoniClient; {$ENDIF}
      const AConnectionObj: TADPhysConnection);
    destructor Destroy; override;
  end;

implementation

uses
{$IFDEF AnyDAC_D10}
  Windows,
{$ENDIF}
  SysUtils,
  daADStanError, daADStanConst;

{-------------------------------------------------------------------------------}
{ TADPhysConnectionMetadata                                                     }
{-------------------------------------------------------------------------------}
constructor TADPhysConnectionMetadata.Create(
  {$IFDEF AnyDAC_MONITOR} const AMonitor: IADMoniClient; {$ENDIF}
  const AConnectionObj: TADPhysConnection);
begin
  inherited Create;
{$IFDEF AnyDAC_MONITOR}
  FMonitor := AMonitor;
{$ENDIF}
  FConnectionObj := AConnectionObj;
  FMetaSchema := TADDatSManager.Create;
  ConfigNameParts;
end;

{-------------------------------------------------------------------------------}
destructor TADPhysConnectionMetadata.Destroy;
begin
{$IFDEF AnyDAC_MONITOR}
  FMonitor := nil;
{$ENDIF}
  FConnectionObj := nil;
  FreeAndNil(FMetaSchema);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata._AddRef: Integer;
begin
  if FConnectionObj = nil then
    Result := inherited _AddRef
  else
    Result := FConnectionObj._AddRef;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata._Release: Integer;
begin
  if FConnectionObj = nil then
    Result := inherited _Release
  else
    Result := FConnectionObj._Release;
end;

{$IFDEF AnyDAC_MONITOR}
{-------------------------------------------------------------------------------}
procedure TADPhysConnectionMetadata.Trace(AKind: TADMoniEventKind;
  AStep: TADMoniEventStep; const AMsg: String; AArgs: array of const);
begin
  if (FMonitor <> nil) and FMonitor.Tracing then
    FMonitor.Notify(AKind, AStep, Self, AMsg, AArgs);
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
procedure TADPhysConnectionMetadata.ConfigNameParts;
var
  i: TADPhysNamePart;
begin
  FMaximumNameParts := 0;
  for i := Low(TADPhysNamePart) to High(TADPhysNamePart) do
    if (i <> npDBLink) and (i in GetNameParts) then
      Inc(FMaximumNameParts);
  SetLength(FNameParts, FMaximumNameParts);
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.IsNameValid(const AName: String): Boolean;
var
  i: Integer;
begin
  Result := True;
  for i := 1 to Length(AName) do
    if not ((i = 1) and (AName[i] in ['a' .. 'z', 'A' .. 'Z']) or
            (i > 1) and (AName[i] in ['a' .. 'z', 'A' .. 'Z', '0' .. '9', '_', '$', '#'])) then begin
      Result := False;
      Break;
    end;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.IsNameQuoted(const AName: String; ACh1, ACh2: Char): Boolean;
begin
  Result :=
    (Length(AName) > 2) and
    not (ACh1 in [#0, ' ']) and not (ACh2 in [#0, ' ']) and
    (AName[1] = ACh1) and (AName[Length(AName)] = ACh2);
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.NormObjName(const AName: String; APart: TADPhysNamePart): String;
begin
  Result := AName;
  if Result <> '' then
    if not IsNameQuoted(Result, GetNameQuotaChar1, GetNameQuotaChar2) then
      if APart in GetNameCaseSensParts then begin
        // QwQw -> QwQw
        // Q w Q w -> "Q w Q w"
        // "Q w Q w" -> "Q w Q w"
        if not IsNameValid(Result) then
          Result := QuoteName(Result);
      end
      else begin
        // QwQw -> QWQW | qwqw
        // Q w Q w -> "Q W Q W" | "q w q w"
        // "Q w Q w" -> "Q w Q w"
        if APart in GetNameDefLowCaseParts then
          Result := AnsiLowerCase(Result)
        else
          Result := AnsiUpperCase(Result);
        if not IsNameValid(Result) then
          Result := QuoteName(Result);
      end
    else if not (APart in GetNameQuotedCaseSensParts) then
      if APart in GetNameDefLowCaseParts then
        Result := AnsiLowerCase(Result)
      else
        Result := AnsiUpperCase(Result);
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.QuoteName(const AName: String): String;
begin
  if (AName <> '') and not IsNameQuoted(AName, GetNameQuotaChar1, GetNameQuotaChar2) and
     not (GetNameQuotaChar1 in [#0, ' ']) and
     not (GetNameQuotaChar2 in [#0, ' ']) then
    Result := GetNameQuotaChar1 + AName + GetNameQuotaChar2
  else
    Result := AName;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.UnQuoteName(const AName: String; ACh1, ACh2: Char): String;
begin
  if IsNameQuoted(AName, ACh1, ACh2) then
    Result := Copy(AName, 2, Length(AName) - 2)
  else
    Result := AName;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.QuoteNameIfReq(const AName: String; APart: TADPhysNamePart): String;
begin
  Result := AName;
  if (AName <> '') and not IsNameQuoted(AName, GetNameQuotaChar1, GetNameQuotaChar2) then
    if not IsNameValid(AName) then
      Result := QuoteName(AName)
    else if not (APart in GetNameCaseSensParts) and (APart in GetNameQuotedCaseSensParts) then begin
      if APart in GetNameDefLowCaseParts then
        Result := AnsiLowerCase(AName)
      else
        Result := AnsiUpperCase(AName);
      if Result <> AName then
        Result := QuoteName(AName);
    end;
end;

{-------------------------------------------------------------------------------}
type
  __TADPhysConnection = class(TADPhysConnection)
  end;

procedure TADPhysConnectionMetadata.InternalOverrideNameByCommand(
  var AParsedName: TADPhysParsedName; const ACommand: IADPhysCommand);
var
  rBaseName: TADPhysParsedName;
begin
  with AParsedName, ACommand do begin
    if FCatalog = '' then
      FCatalog := CatalogName;
    if FSchema = '' then
      FSchema := SchemaName;
    if FBaseObject = '' then begin
      FBaseObject := BaseObjectName;
      if Pos('.', FBaseObject) <> 0 then begin
        InternalDecodeObjName(FBaseObject, rBaseName, ACommand);
        if rBaseName.FCatalog <> '' then
          FCatalog := rBaseName.FCatalog;
        if rBaseName.FSchema <> '' then
          FSchema := rBaseName.FSchema;
        if rBaseName.FObject <> '' then
          FBaseObject := rBaseName.FObject;
      end;
    end;
  end;
  if FConnectionObj <> nil then
    __TADPhysConnection(FConnectionObj).
      InternalOverrideNameByCommand(AParsedName, ACommand);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnectionMetadata.InternalDecodeObjName(const AName: String;
  var AParsedName: TADPhysParsedName; const ACommand: IADPhysCommand);
var
  lInQuotes, lWasLink: Boolean;
  iStName, i, iPart, nParts: Integer;

  procedure Error;
  begin
    ADException(Self, [S_AD_LPhys], er_AD_AccNameHasErrors, [AName]);
  end;

  procedure ExtractNamePart;
  begin
    if (iPart + 1 > FMaximumNameParts) or (i - iStName < 0) then
      Error;
    FNameParts[iPart] := Trim(Copy(AName, iStName, i - iStName));
    Inc(iPart);
  end;

  function NextPart: String;
  begin
    if iPart > 0 then begin
      Dec(iPart);
      Result := FNameParts[iPart];
    end;
  end;

begin
  AParsedName.FCatalog := '';
  AParsedName.FSchema := '';
  AParsedName.FBaseObject := '';
  AParsedName.FObject := '';
  AParsedName.FLink := '';
  if AName = '' then
    Exit;

  lInQuotes := False;
  lWasLink := False;
  iStName := 1;
  iPart := 0;
  i := 1;
  while i <= Length(AName) do begin
    if AName[i] = GetNameQuotaChar1 then
      if GetNameQuotaChar1 = GetNameQuotaChar2 then
        lInQuotes := not lInQuotes
      else
        lInQuotes := True
    else if AName[i] = GetNameQuotaChar2 then
      lInQuotes := False
    else if not lInQuotes then
      if AName[i] = '.' then begin
        ExtractNamePart;
        iStName := i + 1;
      end
      else if AName[i] = '@' then begin
        ExtractNamePart;
        AParsedName.FLink := Copy(AName, i + 1, Length(AName));
        lWasLink := True;
        Break;
      end;
    Inc(i);
  end;
  if not lWasLink then
    ExtractNamePart;
  if lInQuotes then
    Error;

  nParts := iPart;
  AParsedName.FObject := NextPart;
  if nParts = FMaximumNameParts then
    AParsedName.FBaseObject := NextPart;
  if npSchema in GetNameParts then
    AParsedName.FSchema := NextPart;
  if npCatalog in GetNameParts then
    AParsedName.FCatalog := NextPart;
  if iPart <> 0 then
    Error;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnectionMetadata.DecodeObjName(const AName: String;
  var AParsedName: TADPhysParsedName; const ACommand: IADPhysCommand;
  AOpts: TADPhysDecodeOptions);
begin
  if not (doSubObj in AOpts) then begin
    InternalDecodeObjName(AName, AParsedName, ACommand);
    if ACommand <> nil then
      InternalOverrideNameByCommand(AParsedName, ACommand);
    with AParsedName do begin
      if doNormalize in AOpts then begin
        FCatalog := NormObjName(FCatalog, npCatalog);
        FSchema := NormObjName(FSchema, npSchema);
        FBaseObject := NormObjName(FBaseObject, npBaseObject);
        FObject := NormObjName(FObject, npObject);
      end;
      if doUnquote in AOpts then begin
        FCatalog := UnQuoteName(FCatalog, GetNameQuotaChar1, GetNameQuotaChar2);
        FSchema := UnQuoteName(FSchema, GetNameQuotaChar1, GetNameQuotaChar2);
        FBaseObject := UnQuoteName(FBaseObject, GetNameQuotaChar1, GetNameQuotaChar2);
        FObject := UnQuoteName(FObject, GetNameQuotaChar1, GetNameQuotaChar2);
      end;
      if (FBaseObject = '') and (FObject = '') then begin
        FCatalog := '';
        FSchema := '';
        FLink := '';
      end;
    end;
  end
  else
    with AParsedName do begin
      FCatalog := '';
      FSchema := '';
      FLink := '';
      FBaseObject := '';
      FObject := AName;
      if doNormalize in AOpts then
        FObject := NormObjName(FObject, npObject);
      if doUnquote in AOpts then
        FObject := UnQuoteName(FObject, GetNameQuotaChar1, GetNameQuotaChar2);
    end;
{$IFDEF AnyDAC_MONITOR}
  Trace(ekConnService, esProgress, 'DecodeObjName', ['AName', AName,
    'AParsedName.FCatalog', AParsedName.FCatalog,
    'AParsedName.FSchema', AParsedName.FSchema,
    'AParsedName.FBaseObject', AParsedName.FBaseObject,
    'AParsedName.FObject', AParsedName.FObject]);
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.InternalEncodeObjName(const AParsedName: TADPhysParsedName;
  const ACommand: IADPhysCommand): String;
var
  i: Integer;
  s: String;
  eParts: TADPhysNameParts;
begin
  Result := '';
  eParts := GetNameParts;
  for i := 1 to 4 do begin
    s := '';
    case i of
    1: if npCatalog in eParts then
        s := AParsedName.FCatalog;
    2: if npSchema in eParts then
        s := AParsedName.FSchema;
    3: if npBaseObject in eParts then
        s := AParsedName.FBaseObject;
    4: if npObject in eParts then
        s := AParsedName.FObject;
    end;
       // part is not empty
    if (s <> '') or
       // schema is empty, but there was catalog, then - Northwind..Orders
       (i = 2) and (npCatalog in eParts) and (npSchema in eParts) and (Result <> '') then begin
      if Result <> '' then
        Result := Result + '.';
      Result := Result + s;
    end;
  end;
  if (npDBLink in eParts) and (AParsedName.FLink <> '') then
    Result := Result + '@' + AParsedName.FLink;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.EncodeObjName(const AParsedName: TADPhysParsedName;
  const ACommand: IADPhysCommand; AOpts: TADPhysEncodeOptions): String;
var
  rName: TADPhysParsedName;
begin
  rName := AParsedName;
  with rName do begin
    if eoBeatify in AOpts then begin
      if AnsiCompareText(FConnectionObj.DefaultCatalogName, FCatalog) = 0 then
        FCatalog := '';
      if AnsiCompareText(FConnectionObj.DefaultSchemaName, FSchema) = 0 then
        FSchema := '';
      FCatalog := QuoteNameIfReq(FCatalog, npCatalog);
      FSchema := QuoteNameIfReq(FSchema, npSchema);
      FBaseObject := QuoteNameIfReq(FBaseObject, npBaseObject);
      FObject := QuoteNameIfReq(FObject, npObject);
    end
    else begin
      if eoNormalize in AOpts then begin
        FCatalog := NormObjName(FCatalog, npCatalog);
        FSchema := NormObjName(FSchema, npSchema);
        FBaseObject := NormObjName(FBaseObject, npBaseObject);
        FObject := NormObjName(FObject, npObject);
      end;
      if eoQuote in AOpts then begin
        FCatalog := QuoteName(FCatalog);
        FSchema := QuoteName(FSchema);
        FBaseObject := QuoteName(FBaseObject);
        FObject := QuoteName(FObject);
      end;
    end;
  end;
  Result := InternalEncodeObjName(rName, ACommand);
{$IFDEF AnyDAC_MONITOR}
  Trace(ekConnService, esProgress, 'EncodeObjName', [
    'AParsedName.FCatalog', AParsedName.FCatalog,
    'AParsedName.FSchema', AParsedName.FSchema,
    'AParsedName.FBaseObject', AParsedName.FBaseObject,
    'AParsedName.FObject', AParsedName.FObject,
    'Result', Result]);
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.IsRDBMSKind(const AStr: String; var ACurrent: Boolean): Boolean;
var
  i: TADRDBMSKind;
begin
  Result := False;
  ACurrent := False;
  for i := Low(TADRDBMSKind) to High(TADRDBMSKind) do
    if CompareText(AStr, C_AD_PhysRDBMSKinds[i]) = 0 then begin
      Result := True;
      if i = GetKind then
        ACurrent := True;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnectionMetadata.UnsupportedEscape(const ASeq: TADPhysEscapeData);
begin
  ADException(Self, [S_AD_LPhys], er_AD_AccEscapeIsnotSupported, [ASeq.FName]);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnectionMetadata.EscapeFuncToID(var ASeq: TADPhysEscapeData);
var
  sName: String;
  eFunc: TADPhysEscapeFunction;
begin
  sName := ASeq.FName;
  // character
  if sName = 'ASCII' then
    eFunc := efASCII
  else if sName = 'LTRIM' then
    eFunc := efLTRIM
  else if sName = 'REPLACE' then
    eFunc := efREPLACE
  else if sName = 'RTRIM' then
    eFunc := efRTRIM
  else if sName = 'SOUNDEX' then
    eFunc := efSOUNDEX
  else if sName = 'ABS' then
    eFunc := efABS
  else if sName = 'COS' then
    eFunc := efCOS
  else if sName = 'EXP' then
    eFunc := efEXP
  else if sName = 'FLOOR' then
    eFunc := efFLOOR
  else if sName = 'MOD' then
    eFunc := efMOD
  else if sName = 'POWER' then
    eFunc := efPOWER
  else if sName = 'ROUND' then
    eFunc := efROUND
  else if sName = 'SIGN' then
    eFunc := efSIGN
  else if sName = 'SIN' then
    eFunc := efSIN
  else if sName = 'SQRT' then
    eFunc := efSQRT
  else if sName = 'TAN' then
    eFunc := efTAN
  else if sName = 'DECODE' then
    eFunc := efDECODE
  else if sName = 'BIT_LENGTH' then
    eFunc := efBIT_LENGTH
  else if sName = 'CHAR' then
    eFunc := efCHAR
  else if (sName = 'CHAR_LENGTH') or (sName = 'CHARACTER_LENGTH') then
    eFunc := efCHAR_LENGTH
  else if sName = 'CONCAT' then
    eFunc := efCONCAT
  else if sName = 'DIFFERENCE' then
    eFunc := efDIFFERENCE
  else if sName = 'INSERT' then
    eFunc := efINSERT
  else if sName = 'LCASE' then
    eFunc := efLCASE
  else if sName = 'LEFT' then
    eFunc := efLEFT
  else if sName = 'LENGTH' then
    eFunc := efLENGTH
  else if sName = 'LOCATE' then
    eFunc := efLOCATE
  else if sName = 'OCTET_LENGTH' then
    eFunc := efOCTET_LENGTH
  else if sName = 'POSITION' then
    eFunc := efPOSITION
  else if sName = 'REPEAT' then
    eFunc := efREPEAT
  else if sName = 'RIGHT' then
    eFunc := efRIGHT
  else if sName = 'SPACE' then
    eFunc := efSPACE
  else if sName = 'SUBSTRING' then
    eFunc := efSUBSTRING
  else if sName = 'UCASE' then
    eFunc := efUCASE
  // numeric
  else if sName = 'ACOS' then
    eFunc := efACOS
  else if sName = 'ASIN' then
    eFunc := efASIN
  else if sName = 'ATAN' then
    eFunc := efATAN
  else if sName = 'CEILING' then
    eFunc := efCEILING
  else if sName = 'DEGREES' then
    eFunc := efDEGREES
  else if sName = 'LOG' then
    eFunc := efLOG
  else if sName = 'LOG10' then
    eFunc := efLOG10
  else if sName = 'PI' then
    eFunc := efPI
  else if sName = 'RADIANS' then
    eFunc := efRADIANS
  else if sName = 'RANDOM' then
    eFunc := efRANDOM
  else if sName = 'TRUNCATE' then
    eFunc := efTRUNCATE
  // date and time
  else if (sName = 'CURRENT_DATE') or (sName = 'CURDATE') then
    eFunc := efCURDATE
  else if (sName = 'CURRENT_TIME') or (sName = 'CURTIME') then
    eFunc := efCURTIME
  else if (sName = 'CURRENT_TIMESTAMP') or (sName = 'NOW') then
    eFunc := efNOW
  else if sName = 'DAYNAME' then
    eFunc := efDAYNAME
  else if sName = 'DAYOFMONTH' then
    eFunc := efDAYOFMONTH
  else if sName = 'DAYOFWEEK' then
    eFunc := efDAYOFWEEK
  else if sName = 'DAYOFYEAR' then
    eFunc := efDAYOFYEAR
  else if sName = 'EXTRACT' then
    eFunc := efEXTRACT
  else if sName = 'HOUR' then
    eFunc := efHOUR
  else if sName = 'MINUTE' then
    eFunc := efMINUTE
  else if sName = 'MONTH' then
    eFunc := efMONTH
  else if sName = 'MONTHNAME' then
    eFunc := efMONTHNAME
  else if sName = 'QUARTER' then
    eFunc := efQUARTER
  else if sName = 'SECOND' then
    eFunc := efSECOND
  else if sName = 'TIMESTAMPADD' then
    eFunc := efTIMESTAMPADD
  else if sName = 'TIMESTAMPDIFF' then
    eFunc := efTIMESTAMPDIFF
  else if sName = 'WEEK' then
    eFunc := efWEEK
  else if sName = 'YEAR' then
    eFunc := efYEAR
  // system
  else if sName = 'CATALOG' then
    eFunc := efCATALOG
  else if sName = 'SCHEMA' then
    eFunc := efSCHEMA
  else if sName = 'IFNULL' then
    eFunc := efIFNULL
  else if (sName = 'IF') or (sName = 'IIF') then
    eFunc := efIF
  // convert
  else if sName = 'CONVERT' then
    eFunc := efCONVERT
  else begin
    eFunc := efNONE;
    // unsupported ATAN2, COT
    UnsupportedEscape(ASeq);
  end;
  ASeq.FFunc := eFunc;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.AddEscapeSequenceArgs(const ASeq: TADPhysEscapeData): String;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to Length(ASeq.FArgs) - 1 do begin
    if i > 0 then
      Result := Result + ', ';
    Result := Result + ASeq.FArgs[i];
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.TranslateEscapeSequence(
  var ASeq: TADPhysEscapeData): String;
var
  rName: TADPhysParsedName;
  i: Integer;
  s: String;
  lCurrent: Boolean;
begin
  case ASeq.FKind of
  eskFloat:
    Result := InternalEscapeFloat(UnQuoteName(ASeq.FArgs[0], '''', ''''));
  eskDate:
    Result := InternalEscapeDate(UnQuoteName(ASeq.FArgs[0], '''', ''''));
  eskTime:
    Result := InternalEscapeTime(UnQuoteName(ASeq.FArgs[0], '''', ''''));
  eskDateTime:
    Result := InternalEscapeDateTime(UnQuoteName(ASeq.FArgs[0], '''', ''''));
  eskIdentifier:
    begin
      rName.FObject := UnQuoteName(ASeq.FArgs[0], '''', '''');
      Result := EncodeObjName(rName, nil, [eoQuote]);
    end;
  eskBoolean:
    Result := InternalEscapeBoolean(UnQuoteName(ASeq.FArgs[0], '''', ''''));
  eskFunction:
    begin
      EscapeFuncToID(ASeq);
      try
        Result := InternalEscapeFunction(ASeq);
      except
        on E: Exception do begin
          if not (E is EADException) then
            ADException(Self, [S_AD_LPhys], er_AD_AccEscapeBadSyntax,
              [ASeq.FName, E.Message])
          else
            raise;
        end;
      end;
    end;
  eskIF:
    begin
      i := 0;
      Result := '';
      while i < (Length(ASeq.FArgs) and not 1) do begin
        s := Trim(ASeq.FArgs[i]);
        lCurrent := False;
        if IsRDBMSKind(s, lCurrent) then begin
          if lCurrent then begin
            Result := ASeq.FArgs[i + 1];
            Break;
          end;
        end
        else if s <> '' then begin
          Result := ASeq.FArgs[i + 1];
          Break;
        end;
        Inc(i, 2);
      end;
      if i = Length(ASeq.FArgs) - 1 then
        Result := ASeq.FArgs[i];
    end;
  eskEscape:
    Result := InternalEscapeEscape(ASeq.FArgs[0][1], ASeq.FArgs[1]);
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetSQLCommandKind(
  const AToken: String): TADPhysCommandKind;
begin
  if AToken = 'SELECT' then
    Result := skSelect
  else if AToken = 'UPDATE' then
    Result := skUpdate
  else if AToken = 'INSERT' then
    Result := skInsert
  else if AToken = 'DELETE' then
    Result := skDelete
  else if AToken = 'DROP' then
    Result := skDrop
  else if AToken = 'CREATE' then
    Result := skCreate
  else if AToken = 'ALTER' then
    Result := skAlter
  else
    Result := InternalGetSQLCommandKind(AToken);
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.InternalGetSQLCommandKind(
  const AToken: String): TADPhysCommandKind;
begin
  Result := skOther;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetInsertBlobsAfterReturning: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetEnableIdentityInsert: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetKind: TADRDBMSKind;
begin
  Result := mkOther;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetClientVersion: LongWord;
begin
  Result := 0;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetServerVersion: LongWord;
begin
  Result := 0;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetNameQuotedCaseSensParts: TADPhysNameParts;
begin
  Result := [npCatalog, npSchema, npDBLink, npBaseObject, npObject];
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetNameCaseSensParts: TADPhysNameParts;
begin
  Result := [];
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetNameDefLowCaseParts: TADPhysNameParts;
begin
  Result := [];
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetParamNameMaxLength: Integer;
begin
  Result := 32;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetNameParts: TADPhysNameParts;
begin
  Result := [npBaseObject, npObject];
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetNameQuotaChar1: Char;
begin
  Result := '"';
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetNameQuotaChar2: Char;
begin
  Result := '"';
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetParamMark: TADPhysParamMark;
begin
  Result := prQMark;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetTxAutoCommit: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetTxNested: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetTxSavepoints: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetTxSupported: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetTruncateSupported: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetDefValuesSupported: TADPhysDefaultValues;
begin
  Result := dvDef;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetInlineRefresh: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetSelectWithoutFrom: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetLockNoWait: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetAsyncAbortSupported: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetCommandSeparator: String;
begin
  Result := ';';
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.InternalEscapeBoolean(const AStr: String): String;
begin
  Result := AStr;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.InternalEscapeDate(const AStr: String): String;
begin
  Result := '''' + AStr + '''';
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.InternalEscapeDateTime(const AStr: String): String;
begin
  Result := '''' + AStr + '''';
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.InternalEscapeFloat(const AStr: String): String;
begin
  Result := AStr;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.InternalEscapeTime(const AStr: String): String;
begin
  Result := '''' + AStr + '''';
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.InternalEscapeFunction(const ASeq: TADPhysEscapeData): String;
begin
  Result := '';
  ADCapabilityNotSupported(Self, [S_AD_LPhys]);
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.InternalEscapeEscape(AEscape: Char; const AStr: String): String;
begin
  Result := AStr + ' ESCAPE ''' + AEscape + '''';
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.DefineMetadataTableName(AKind: TADPhysMetaInfoKind): String;
var
  sDB: String;
begin
  ASSERT((FConnectionObj <> nil) and (FConnectionObj.ConnectionDef <> nil));
  sDB := FConnectionObj.ConnectionDef.ExpandedDatabase;
  case AKind of
  mkTables:           Result := C_AD_SysNamePrefix + '#' + sDB + '#TABLES';
  mkTableFields:      Result := C_AD_SysNamePrefix + '#' + sDB + '#TABLEFIELDS';
  mkIndexes:          Result := C_AD_SysNamePrefix + '#' + sDB + '#INDEXES';
  mkIndexFields:      Result := C_AD_SysNamePrefix + '#' + sDB + '#INDEXFIELDS';
  mkPrimaryKey:       Result := C_AD_SysNamePrefix + '#' + sDB + '#PRIMARYKEYS';
  mkPrimaryKeyFields: Result := C_AD_SysNamePrefix + '#' + sDB + '#PRIMARYKEYFIELDS';
  mkForeignKeys:      Result := C_AD_SysNamePrefix + '#' + sDB + '#FOREIGNKEYS';
  mkForeignKeyFields: Result := C_AD_SysNamePrefix + '#' + sDB + '#FOREIGNKEYFIELDS';
  mkPackages:         Result := C_AD_SysNamePrefix + '#' + sDB + '#PACKAGES';
  mkProcs:            Result := C_AD_SysNamePrefix + '#' + sDB + '#PROCS';
  mkProcArgs:         Result := C_AD_SysNamePrefix + '#' + sDB + '#PROCARGS';
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnectionMetadata.DefineMetadataStructure(ATable: TADDatSTable;
  AKind: TADPhysMetaInfoKind);
var
  iCol: Integer;

  procedure Add(const AName: String; AType: TADDataType);
  var
    oCol: TADDatSColumn;
  begin
    Inc(iCol);
    oCol := TADDatSColumn.Create;
    oCol.Name := AName;
    oCol.SourceName := '';
    oCol.SourceID := iCol;
    oCol.SourceDataType := AType;
    oCol.SourceSize := LongWord(-1);
    oCol.Attributes := [caAllowNull, caReadOnly, caSearchable];
    oCol.DataType := AType;
    if AType = dtAnsiString then
      oCol.Size := C_AD_MaxNameLen;
    ATable.Columns.Add(oCol);
  end;

begin
  iCol := 0;
  case AKind of
  mkTables:
    begin
      Add('RECNO',            dtInt32);
      Add('CATALOG_NAME',     dtAnsiString);
      Add('SCHEMA_NAME',      dtAnsiString);
      Add('TABLE_NAME',       dtAnsiString);
      Add('TABLE_TYPE',       dtInt16);       // TADTableKind
      Add('TABLE_SCOPE',      dtInt16);       // TADObjectScope
    end;
  mkTableFields:
    begin
      Add('RECNO',            dtInt32);
      Add('CATALOG_NAME',     dtAnsiString);
      Add('SCHEMA_NAME',      dtAnsiString);
      Add('TABLE_NAME',       dtAnsiString);
      Add('COLUMN_NAME',      dtAnsiString);
      Add('COLUMN_POSITION',  dtInt16);
      Add('COLUMN_DATATYPE',  dtInt16);       // TADDataType
      Add('COLUMN_TYPENAME',  dtAnsiString);
      Add('COLUMN_ATTRIBUTES',dtUInt32);      // TADDataAttributes
      Add('COLUMN_PRECISION', dtInt16);
      Add('COLUMN_SCALE',     dtInt16);
      Add('COLUMN_LENGTH',    dtInt32);
    end;
  mkIndexes,
  mkPrimaryKey:
    begin
      Add('RECNO',            dtInt32);
      Add('CATALOG_NAME',     dtAnsiString);
      Add('SCHEMA_NAME',      dtAnsiString);
      Add('TABLE_NAME',       dtAnsiString);
      Add('INDEX_NAME',       dtAnsiString);
      Add('PKEY_NAME',        dtAnsiString);
      Add('INDEX_TYPE',       dtInt16);       // TADIndexKind
    end;
  mkIndexFields,
  mkPrimaryKeyFields:
    begin
      Add('RECNO',            dtInt32);
      Add('CATALOG_NAME',     dtAnsiString);
      Add('SCHEMA_NAME',      dtAnsiString);
      Add('TABLE_NAME',       dtAnsiString);
      Add('INDEX_NAME',       dtAnsiString);
      Add('COLUMN_NAME',      dtAnsiString);
      Add('COLUMN_POSITION',  dtInt16);
      Add('SORT_ORDER',       dtAnsiString);
      Add('FILTER',           dtAnsiString);
    end;
  mkForeignKeys:
    begin
      Add('RECNO',            dtInt32);
      Add('CATALOG_NAME',     dtAnsiString);
      Add('SCHEMA_NAME',      dtAnsiString);
      Add('TABLE_NAME',       dtAnsiString);
      Add('FKEY_NAME',        dtAnsiString);
      Add('PKEY_CATALOG_NAME',dtAnsiString);
      Add('PKEY_SCHEMA_NAME', dtAnsiString);
      Add('PKEY_TABLE_NAME',  dtAnsiString);
      Add('DELETE_RULE',      dtInt16);
      Add('UPDATE_RULE',      dtInt16);
    end;
  mkForeignKeyFields:
    begin
      Add('RECNO',            dtInt32);
      Add('CATALOG_NAME',     dtAnsiString);
      Add('SCHEMA_NAME',      dtAnsiString);
      Add('TABLE_NAME',       dtAnsiString);
      Add('FKEY_NAME',        dtAnsiString);
      Add('COLUMN_NAME',      dtAnsiString);
      Add('PKEY_COLUMN_NAME', dtAnsiString);
      Add('COLUMN_POSITION',  dtInt16);
    end;
  mkPackages:
    begin
      Add('RECNO',            dtInt32);
      Add('CATALOG_NAME',     dtAnsiString);
      Add('SCHEMA_NAME',      dtAnsiString);
      Add('PACKAGE_NAME',     dtAnsiString);
      Add('PACKAGE_SCOPE',    dtInt16);       // TADObjectScope
    end;
  mkProcs:
    begin
      Add('RECNO',            dtInt32);
      Add('CATALOG_NAME',     dtAnsiString);
      Add('SCHEMA_NAME',      dtAnsiString);
      Add('PACK_NAME',        dtAnsiString);
      Add('PROC_NAME',        dtAnsiString);
      Add('OVERLOAD',         dtInt16);
      Add('PROC_TYPE',        dtInt16);       // TADProcedureKind
      Add('PROC_SCOPE',       dtInt16);       // TADObjectScope
      Add('IN_PARAMS',        dtInt16);
      Add('OUT_PARAMS',       dtInt16);
    end;
  mkProcArgs:
    begin
      Add('RECNO',            dtInt32);       // 0
      Add('CATALOG_NAME',     dtAnsiString);  // 1
      Add('SCHEMA_NAME',      dtAnsiString);  // 2
      Add('PACK_NAME',        dtAnsiString);  // 3
      Add('PROC_NAME',        dtAnsiString);  // 4
      Add('OVERLOAD',         dtInt16);       // 5
      Add('PARAM_NAME',       dtAnsiString);  // 6
      Add('PARAM_POSITION',   dtInt16);       // 7
      Add('PARAM_TYPE',       dtInt16);       // 8 - TParamType
      Add('PARAM_DATATYPE',   dtInt16);       // 9 - TADDataType
      Add('PARAM_TYPENAME',   dtAnsiString);  // 10
      Add('PARAM_ATTRIBUTES', dtUInt32);      // 11 - TADDataAttributes
      Add('PARAM_PRECISION',  dtInt16);       // 12
      Add('PARAM_SCALE',      dtInt16);       // 13
      Add('PARAM_LENGTH',     dtInt32);       // 14
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.FetchNoCache(AMetaKind: TADPhysMetaInfoKind;
  AScope: TADPhysObjectScopes; AKinds: TADPhysTableKinds; const ACatalog, ASchema,
  ABaseObject, AWildCard: String; AOverload: Word): TADDatSTable;
var
  oCommand: IADPhysMetaInfoCommand;
begin
  Result := TADDatSTable.Create(DefineMetadataTableName(AMetaKind));
  Result.CountRef(0);
  try
    (FConnectionObj as IADPhysConnection).CreateMetaInfoCommand(oCommand);
    with oCommand.Options.ResourceOptions do
      if AsyncCmdMode = amAsync then
        AsyncCmdMode := amBlocking;
    oCommand.ObjectScopes := AScope;
    oCommand.TableKinds := AKinds;
    oCommand.CatalogName := ACatalog;
    oCommand.SchemaName := ASchema;
    oCommand.BaseObjectName := ABaseObject;
    oCommand.Wildcard := AWildCard;
    oCommand.Overload := AOverload;
    oCommand.MetaInfoKind := AMetaKind;
    oCommand.Prepare;
    oCommand.Define(Result);
    oCommand.Open;
    oCommand.Fetch(Result, True);
  except
    Result.Free;
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnectionMetadata.FetchToCache(AMetaKind: TADPhysMetaInfoKind;
  const ACatalog, ASchema, ABaseObject, AObject: String; AOverload: Word; ADataTable: TADDatSTable);
var
  oCommand: IADPhysMetaInfoCommand;
begin
  (FConnectionObj as IADPhysConnection).CreateMetaInfoCommand(oCommand);
  with oCommand.Options.ResourceOptions do
    if AsyncCmdMode = amAsync then
      AsyncCmdMode := amBlocking;
  oCommand.CatalogName := ACatalog;
  oCommand.SchemaName := ASchema;
  oCommand.BaseObjectName := ABaseObject;
  oCommand.CommandText := AObject;
  oCommand.Overload := AOverload;
  oCommand.MetaInfoKind := AMetaKind;
  oCommand.Prepare;
  if ADataTable.Columns.Count = 0 then
    oCommand.Define(ADataTable);
  oCommand.Open;
  if oCommand.State = csOpen then
    oCommand.Fetch(ADataTable, True);
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.CheckFetchToCache(AMetaKind: TADPhysMetaInfoKind;
  const AFilter: String; var ATable: TADDatSTable; var AView: TADDatSView): Boolean;
var
  i: Integer;
  sTabName: String;
begin
  sTabName := DefineMetadataTableName(AMetaKind);
  i := FMetaSchema.Tables.IndexOfName(sTabName);
  if i = -1 then begin
    ATable := FMetaSchema.Tables.Add(sTabName);
    DefineMetadataStructure(ATable, AMetaKind);
  end
  else
    ATable := FMetaSchema.Tables.ItemsI[i];
  AView := ATable.Select(AFilter);
  Result := AView.Rows.Count = 0;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.ConvertNameCase(const AName: String;
  APart: TADPhysNamePart): String;
begin
  if not (APart in GetNameQuotedCaseSensParts) then
    if APart in GetNameDefLowCaseParts then
      Result := 'LOWER(' + AName + ')'
    else
      Result := 'UPPER(' + AName + ')'
  else
    Result := AName;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnectionMetadata.AddWildcard(AView: TADDatSView;
  const AColumn, AWildcard: String; APart: TADPhysNamePart);
begin
  if AWildcard <> '' then
    AView.RowFilter := AView.RowFilter + ' AND ' + ConvertNameCase(AColumn, APart) +
      ' LIKE ''' + AWildcard + '''';
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetCacheFilter(const ACatalog, ASchema,
  AObjField, AObj, ASubObjField, ASubObj: String): String;

  procedure AddCond(const AColumn, AVal: String; APart: TADPhysNamePart);
  begin
    if Result <> '' then
      Result := Result + ' AND ';
    Result := Result + ConvertNameCase(AColumn, APart) + ' = ''' + AVal + '''';
  end;

begin
  Result := '';
  if ACatalog <> '' then
    AddCond('CATALOG_NAME', ACatalog, npCatalog);
  if ASchema <> '' then
    AddCond('SCHEMA_NAME', ASchema, npSchema);
  if AObj <> '' then
    AddCond(AObjField, AObj, npBaseObject);
  if ASubObj <> '' then
    AddCond(ASubObjField, ASubObj, npObject);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnectionMetadata.ParseMetaInfoParams(const ACatalog, ASchema,
  ABaseObjName, AObjName: String; var AParsedName: TADPhysParsedName);
var
  sObjName: String;
  rName2: TADPhysParsedName;
begin
  if ABaseObjName <> '' then
    sObjName := ABaseObjName
  else
    sObjName := AObjName;
  DecodeObjName(sObjName, AParsedName, nil, [doUnquote, doNormalize]);
  if ABaseObjName <> '' then begin
    AParsedName.FBaseObject := AParsedName.FObject;
    DecodeObjName(AObjName, rName2, nil, [doUnquote, doNormalize, doSubObj]);
    AParsedName.FObject := rName2.FObject;
  end;
  if AParsedName.FCatalog = '' then
    AParsedName.FCatalog := ACatalog;
  if AParsedName.FSchema = '' then
    AParsedName.FSchema := ASchema;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetTables(AScope: TADPhysObjectScopes;
  AKinds: TADPhysTableKinds; const ACatalog, ASchema, AWildCard: String): TADDatSView;
begin
  Result := FetchNoCache(mkTables, AScope, AKinds, ACatalog, ASchema, '',
    AWildCard, 0).DefaultView;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetTableFields(const ACatalog, ASchema,
  ATable, AWildCard: String): TADDatSView;
var
  rName: TADPhysParsedName;
  oTab: TADDatSTable;
begin
  Result := nil;
  oTab := nil;
  ParseMetaInfoParams(ACatalog, ASchema, '', ATable, rName);
  with rName do
    if CheckFetchToCache(mkTableFields, GetCacheFilter(FCatalog, FSchema,
        'TABLE_NAME', FObject, '', ''), oTab, Result) then
      FetchToCache(mkTableFields, ACatalog, ASchema, '', ATable, 0, oTab);
  AddWildcard(Result, 'COLUMN_NAME', AWildCard, npObject);
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetTableIndexes(const ACatalog, ASchema,
  ATable, AWildCard: String): TADDatSView;
var
  rName: TADPhysParsedName;
  oTab: TADDatSTable;
begin
  Result := nil;
  oTab := nil;
  ParseMetaInfoParams(ACatalog, ASchema, '', ATable, rName);
  with rName do
    if CheckFetchToCache(mkIndexes, GetCacheFilter(FCatalog, FSchema,
        'TABLE_NAME', FObject, '', ''), oTab, Result) then
      FetchToCache(mkIndexes, ACatalog, ASchema, '', ATable, 0, oTab);
  AddWildcard(Result, 'INDEX_NAME', AWildCard, npObject);
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetTableIndexFields(const ACatalog,
  ASchema, ATable, AIndex, AWildCard: String): TADDatSView;
var
  rName: TADPhysParsedName;
  oTab: TADDatSTable;
begin
  Result := nil;
  oTab := nil;
  ParseMetaInfoParams(ACatalog, ASchema, ATable, AIndex, rName);
  with rName do
    if CheckFetchToCache(mkIndexFields, GetCacheFilter(FCatalog, FSchema,
        'TABLE_NAME', FBaseObject, 'INDEX_NAME', FObject), oTab, Result) then
      FetchToCache(mkIndexFields, ACatalog, ASchema, ATable, AIndex, 0, oTab);
  AddWildcard(Result, 'COLUMN_NAME', AWildCard, npObject);
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetTablePrimaryKey(const ACatalog,
  ASchema, ATable: String): TADDatSView;
var
  rName: TADPhysParsedName;
  oTab: TADDatSTable;
begin
  Result := nil;
  oTab := nil;
  ParseMetaInfoParams(ACatalog, ASchema, '', ATable, rName);
  with rName do
    if CheckFetchToCache(mkPrimaryKey, GetCacheFilter(FCatalog, FSchema,
        'TABLE_NAME', FObject, '', ''), oTab, Result) then
      FetchToCache(mkPrimaryKey, ACatalog, ASchema, '', ATable, 0, oTab);
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetTablePrimaryKeyFields(const ACatalog,
  ASchema, ATable, AWildCard: String): TADDatSView;
var
  rName: TADPhysParsedName;
  oTab: TADDatSTable;
begin
  Result := nil;
  oTab := nil;
  ParseMetaInfoParams(ACatalog, ASchema, '', ATable, rName);
  with rName do
    if CheckFetchToCache(mkPrimaryKeyFields, GetCacheFilter(FCatalog, FSchema,
        'TABLE_NAME', FObject, '', ''), oTab, Result) then
      FetchToCache(mkPrimaryKeyFields, ACatalog, ASchema, ATable, '', 0, oTab);
  AddWildcard(Result, 'COLUMN_NAME', AWildCard, npObject);
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetTableForeignKeys(const ACatalog, ASchema,
  ATable, AWildCard: String): TADDatSView;
var
  rName: TADPhysParsedName;
  oTab: TADDatSTable;
begin
  Result := nil;
  oTab := nil;
  ParseMetaInfoParams(ACatalog, ASchema, '', ATable, rName);
  with rName do
    if CheckFetchToCache(mkForeignKeys, GetCacheFilter(FCatalog, FSchema,
        'TABLE_NAME', FObject, '', ''), oTab, Result) then
      FetchToCache(mkForeignKeys, ACatalog, ASchema, '', ATable, 0, oTab);
  AddWildcard(Result, 'FK_NAME', AWildCard, npObject);
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetTableForeignKeyFields(const ACatalog,
  ASchema, ATable, AForeignKey, AWildCard: String): TADDatSView;
var
  rName: TADPhysParsedName;
  oTab: TADDatSTable;
begin
  Result := nil;
  oTab := nil;
  ParseMetaInfoParams(ACatalog, ASchema, ATable, AForeignKey, rName);
  with rName do
    if CheckFetchToCache(mkForeignKeyFields, GetCacheFilter(FCatalog, FSchema,
        'TABLE_NAME', FBaseObject, 'FK_NAME', FObject), oTab, Result) then
      FetchToCache(mkForeignKeyFields, ACatalog, ASchema, ATable, AForeignKey, 0, oTab);
  AddWildcard(Result, 'COLUMN_NAME', AWildCard, npObject);
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetPackages(AScope: TADPhysObjectScopes;
  const ACatalog, ASchema, AWildCard: String): TADDatSView;
begin
  Result := FetchNoCache(mkPackages, AScope, [], ACatalog, ASchema, '',
    AWildCard, 0).DefaultView;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetPackageProcs(const ACatalog, ASchema,
  APackage, AWildCard: String): TADDatSView;
var
  rName: TADPhysParsedName;
  oTab: TADDatSTable;
begin
  Result := nil;
  oTab := nil;
  ParseMetaInfoParams(ACatalog, ASchema, APackage, '', rName);
  with rName do
    if CheckFetchToCache(mkProcs, GetCacheFilter(FCatalog, FSchema,
        'PACK_NAME', FBaseObject, '', ''), oTab, Result) then
      FetchToCache(mkProcs, ACatalog, ASchema, APackage, '', 0, oTab);
  AddWildcard(Result, 'PROC_NAME', AWildCard, npBaseObject);
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetProcs(AScope: TADPhysObjectScopes;
  const ACatalog, ASchema, AWildCard: String): TADDatSView;
begin
  Result := FetchNoCache(mkProcs, AScope, [], ACatalog, ASchema, '',
    AWildCard, 0).DefaultView;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetProcArgs(const ACatalog, ASchema,
  APackage, AProc, AWildCard: String; AOverload: Word): TADDatSView;
var
  rName: TADPhysParsedName;
  oTab: TADDatSTable;
  sProc, sFlt: String;
begin
  Result := nil;
  oTab := nil;
  ParseMetaInfoParams(ACatalog, ASchema, APackage, AProc, rName);
  if (GetKind = mkMSSQL) and (Pos(';', AProc) = 0) then
    sProc := AProc + ';1'
  else
    sProc := AProc;
  with rName do begin
    sFlt := GetCacheFilter(FCatalog, FSchema, 'PACK_NAME', FBaseObject,
      'PROC_NAME', sProc);
    if AOverload <> 0 then begin
      if sFlt <> '' then
        sFlt := sFlt + ' AND ';
      sFlt := sFlt + 'OVERLOAD = ' + IntToStr(AOverload);
    end;
    if CheckFetchToCache(mkProcArgs, sFlt, oTab, Result) then
      FetchToCache(mkProcArgs, ACatalog, ASchema, APackage, AProc, AOverload, oTab);
  end;
  AddWildcard(Result, 'PARAM_NAME', AWildCard, npObject);
end;

end.
