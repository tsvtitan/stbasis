{-------------------------------------------------------------------------------}
{ AnyDAC db parameters and macros                                               }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit daADStanParam;

interface

uses
  Classes, DB,
{$IFDEF AnyDAC_D6Base}
  Variants,
  {$IFDEF AnyDAC_D6}
  FmtBcd, SqlTimSt,
  {$ENDIF}
{$ENDIF}
  daADStanIntf, daADStanUtil;

type
  TADMacro = class;
  TADMacros = class;
  TADParam = class;
  TADParams = class;

  TADGetOwner = function: TPersistent of object;

  TADMacroDataType = (mdUnknown, mdString, mdIdentifier, mdInteger,
    mdBoolean, mdFloat, mdDate, mdTime, mdDateTime, mdRaw);

  TADMacro = class(TCollectionItem)
  private
    FName: String;
    FValue: Variant;
    FDataType: TADMacroDataType;
    procedure SetValue(const AValue: Variant);
    function GetAsDateTime: TDateTime;
    function GetAsInteger: Integer;
    function GetAsString: String;
    function GetSQL: String;
    procedure SetAsDateTime(const AValue: TDateTime);
    procedure SetAsInteger(const AValue: Integer);
    procedure SetAsString(const AValue: String);
    function GetIsNull: Boolean;
    function GetAsFloat: Double;
    procedure SetAsFloat(const AValue: Double);
    function GetAsDate: TDateTime;
    procedure SetAsDate(const AValue: TDateTime);
    procedure SetDataType(const AValue: TADMacroDataType);
    procedure SetData(const AValue: Variant; AType: TADMacroDataType);
    procedure Changed;
    procedure SetAsIdentifier(const AValue: String);
    function GetAsTime: TDateTime;
    procedure SetAsTime(const AValue: TDateTime);
    function GetAsRaw: String;
    procedure SetAsRaw(const AValue: String);
  protected
    function GetDisplayName: String; override;
    function GetCollectionOwner: TPersistent;
  public
    constructor Create(Collection: TCollection); override;
    procedure Clear;
    procedure Assign(AValue: TPersistent); override;
    function IsEqual(AValue: TADMacro): Boolean;
    property CollectionOwner: TPersistent read GetCollectionOwner;
    property AsString: String read GetAsString write SetAsString;
    property AsIdentifier: String read GetAsString write SetAsIdentifier;
    property AsInteger: Integer read GetAsInteger write SetAsInteger;
    property AsDateTime: TDateTime read GetAsDateTime write SetAsDateTime;
    property AsDate: TDateTime read GetAsDate write SetAsDate;
    property AsTime: TDateTime read GetAsTime write SetAsTime;
    property AsFloat: Double read GetAsFloat write SetAsFloat;
    property AsRaw: String read GetAsRaw write SetAsRaw;
    property IsNull: Boolean read GetIsNull;
    property SQL: String read GetSQL;
  published
    property Value: Variant read FValue write SetValue;
    property Name: String read FName write FName;
    property DataType: TADMacroDataType read FDataType write SetDataType default mdRaw;
  end;

  TADMacros = class(TCollection)
  private
    FGetOwner: TADGetOwner;
    FOnChanged: TNotifyEvent;
    function GetDataSet: TDataSet;
    function GetItem(AIndex: Integer): TADMacro;
    procedure SetItem(AIndex: Integer; AValue: TADMacro);
    procedure DoChanged;
  protected
    function GetOwner: TPersistent; override;
    procedure AssignTo(ADest: TPersistent); override;
  public
    constructor Create; overload;
    constructor Create(AGetOwner: TADGetOwner); overload;
    procedure Assign(AValue: TPersistent); override;
    procedure EndUpdate; {$IFNDEF AnyDAC_FPC} override; {$ENDIF} // ???AnyDAC_FPC
    procedure AssignValues(AValue: TADMacros);
    function IsEqual(AValue: TADMacros): Boolean;
    function MacroByName(const AValue: String): TADMacro;
    function FindMacro(const AValue: String): TADMacro;
    property Command: TDataSet read GetDataSet;
    property Items[AIndex: Integer]: TADMacro read GetItem write SetItem; default;
    property UpdateCount;
    property OnChanged: TNotifyEvent read FOnChanged write FOnChanged;
  end;

  TADParamArrayType = (atScalar, atArray, atPLSQLTable);
  TADParamBindMode = (pbByName, pbByNumber);

  TADParam = class(TCollectionItem)
  private
    FName: String;
    FDataType: TFieldType;
    FADDataType: TADDataType;
    FParamType: TParamType;
    FSize: Integer;
    FPrecision: Integer;
    FNumericScale: Integer;
    FBound: Boolean;
    FPosition: Integer;
    FIsCaseSensitive: Boolean;
    FActive: Boolean;
    FArrayType: TADParamArrayType;
    FValue: TADVariantArray;
    FBaseParam: TADParam;
    function GetDataSet: TDataSet;
    function IsParamStored: Boolean;
    function GetAsBCDs(AIndex: Integer): Currency;
    function GetAsBooleans(AIndex: Integer): Boolean;
    function GetAsBytes(AIndex: Integer): String;
    function GetAsCurrencys(AIndex: Integer): Currency;
    function GetAsDateTimes(AIndex: Integer): TDateTime;
    function GetAsFloats(AIndex: Integer): Extended;
    function GetAsFMTBCDs(AIndex: Integer): TADBcd;
    function GetAsIntegers(AIndex: Integer): LongInt;
    function GetAsSQLTimeStamps(AIndex: Integer): TADSQLTimeStamp;
    function GetAsStrings(AIndex: Integer): String;
    function GetAsVariants(AIndex: Integer): Variant;
    function GetIsNulls(AIndex: Integer): Boolean;
    function GetWideStrings(AIndex: Integer): WideString;
    procedure SetAsBCDs(AIndex: Integer; const AValue: Currency);
    procedure SetAsBlobs(AIndex: Integer; const AValue: TBlobData);
    procedure SetAsBooleans(AIndex: Integer; const AValue: Boolean);
    procedure SetAsBytes(AIndex: Integer; const AValue: String);
    procedure SetAsVarBytes(AIndex: Integer; const AValue: String);
    procedure SetAsCurrencys(AIndex: Integer; const AValue: Currency);
    procedure SetAsDates(AIndex: Integer; const AValue: TDateTime);
    procedure SetAsDateTimes(AIndex: Integer; const AValue: TDateTime);
    procedure SetAsFloats(AIndex: Integer; const AValue: Extended);
    procedure SetAsFMTBCDs(AIndex: Integer; const AValue: TADBcd);
    procedure SetAsIntegers(AIndex: Integer; const AValue: LongInt);
    procedure SetAsMemos(AIndex: Integer; const AValue: String);
    procedure SetAsSmallInts(AIndex: Integer; const AValue: LongInt);
    procedure SetAsSQLTimeStamps(AIndex: Integer; const AValue: TADSQLTimeStamp);
    procedure SetAsStrings(AIndex: Integer; const AValue: String);
    procedure SetAsTimes(AIndex: Integer; const AValue: TDateTime);
    procedure SetAsVariants(AIndex: Integer; const AValue: Variant);
    procedure SetAsWords(AIndex: Integer; AValue: Integer);
    procedure SetBytesValue(AIndex: Integer; ABuff: TADBuffer; ASize: LongWord);
    procedure GetBytesValue(AIndex: Integer; ABuff: TADBuffer);
    procedure SetTexts(AIndex: Integer; const AValue: String);
    procedure SetWideStrings(AIndex: Integer; const AValue: WideString);
    procedure CheckIndex(var AIndex: Integer);
    function GetArraySize: Integer;
    procedure SetArraySize(AValue: Integer);
    procedure SetArrayType(AValue: TADParamArrayType);
    procedure UpdateData(ADim: Integer);
    function GetAsLargeInt: LargeInt;
    function GetAsLargeInts(AIndex: Integer): LargeInt;
    procedure SetAsLargeInt(const AValue: LargeInt);
    procedure SetAsLargeInts(AIndex: Integer; const AValue: LargeInt);
    procedure GetVarData(out AVar: PVariant; AIndex: Integer = -1);
    procedure ErrBadFieldType;
    procedure ErrUnknownFieldType;
    function GetAsGUID: TGUID;
    function GetAsGUIDs(AIndex: Integer): TGUID;
    procedure SetAsGUID(const AValue: TGUID);
    procedure SetAsGUIDs(AIndex: Integer; const AValue: TGUID);
    procedure SetAsWideMemo(const AValue: WideString);
    procedure SetAsWideMemos(AIndex: Integer; const AValue: WideString);
    procedure SetAsFixedChar(const AValue: String);
    procedure SetAsFixedChars(AIndex: Integer; const AValue: String);
  protected
    procedure AssignParam(AParam: TADParam);
    procedure AssignDlpParam(AParam: TParam);
    procedure AssignToDlpParam(AParam: TParam);
    procedure AssignTo(ADest: TPersistent); override;
    function GetAsFMTBCD: TADBcd;
    function GetAsBCD: Currency;
    function GetAsBoolean: Boolean;
    function GetAsByte: String;
    function GetAsDateTime: TDateTime;
    function GetAsSQLTimeStamp: TADSQLTimeStamp;
    function GetAsCurrency: Currency;
    function GetAsFloat: Extended;
    function GetAsInteger: Longint;
    function GetAsString: String;
    function GetWideString: WideString;
    function GetAsVariant: Variant;
    function GetIsNull: Boolean;
    function IsEqual(AValue: TADParam): Boolean;
    procedure SetAsBCD(const AValue: Currency);
    procedure SetAsFMTBCD(const AValue: TADBcd);
    procedure SetAsBlob(const AValue: TBlobData);
    procedure SetAsByte(const AValue: String);
    procedure SetAsVarByte(const AValue: String);
    procedure SetAsBoolean(const AValue: Boolean);
    procedure SetAsCurrency(const AValue: Currency);
    procedure SetAsDate(const AValue: TDateTime);
    procedure SetAsDateTime(const AValue: TDateTime);
    procedure SetAsSQLTimeStamp(const AValue: TADSQLTimeStamp);
    procedure SetAsFloat(const AValue: Extended);
    procedure SetAsInteger(const AValue: Longint);
    procedure SetAsMemo(const AValue: String);
    procedure SetAsString(const AValue: String);
    procedure SetWideString(const AValue: WideString);
    procedure SetAsSmallInt(const AValue: LongInt);
    procedure SetAsTime(const AValue: TDateTime);
    procedure SetAsVariant(const AValue: Variant);
    procedure SetAsWord(const AValue: LongInt);
    procedure SetDataType(AValue: TFieldType);
    procedure SetText(const AValue: String);
    function GetDisplayName: String; override;
    property DataSet: TDataSet read GetDataSet;
  public
    constructor Create(Collection: TCollection); overload; override;
    constructor Create(AParams: TParams; AParamType: TParamType); reintroduce; overload;
    // value manipulations
    procedure Assign(ASource: TPersistent); override;
    procedure AssignField(AField: TField);
    procedure AssignFieldValue(AField: TField; const AValue: Variant);
    procedure Clear(AIndex: Integer = -1);
    // raw data methods
    function GetBlobRawData(var ALen: LongWord; var APtr: TADBuffer; AIndex: Integer = -1): Boolean;
    function SetBlobRawData(ALen: LongWord; APtr: TADBuffer; AIndex: Integer = -1): TADBytes;
    procedure GetData(ABuffer: TADBuffer; AIndex: Integer = -1);
    procedure SetData(ABuffer: TADBuffer; ALen: LongWord = $FFFFFFFF; AIndex: Integer = -1);
    function GetDataSize(AIndex: Integer = -1): Integer;
    procedure LoadFromFile(const FileName: String; BlobType: TBlobType; AIndex: Integer = -1);
    procedure LoadFromStream(Stream: TStream; BlobType: TBlobType; AIndex: Integer = -1);
    // value properties
    property AsBCD: Currency read GetAsBCD write SetAsBCD;
    property AsFMTBCD: TADBcd read GetAsFMTBCD write SetAsFMTBCD;
    property AsBlob: TBlobData read GetAsString write SetAsBlob;
    property AsBoolean: Boolean read GetAsBoolean write SetAsBoolean;
    property AsByte: String read GetAsByte write SetAsByte;
    property AsVarByte: String read GetAsByte write SetAsVarByte;
    property AsCurrency: Currency read GetAsCurrency write SetAsCurrency;
    property AsDate: TDateTime read GetAsDateTime write SetAsDate;
    property AsDateTime: TDateTime read GetAsDateTime write SetAsDateTime;
    property AsFloat: Extended read GetAsFloat write SetAsFloat;
    property AsGUID: TGUID read GetAsGUID write SetAsGUID;
    property AsInteger: LongInt read GetAsInteger write SetAsInteger;
    property AsLargeInt: LargeInt read GetAsLargeInt write SetAsLargeInt;
    property AsSmallInt: LongInt read GetAsInteger write SetAsSmallInt;
    property AsSQLTimeStamp: TADSQLTimeStamp read GetAsSQLTimeStamp write SetAsSQLTimeStamp;
    property AsMemo: String read GetAsString write SetAsMemo;
    property AsString: String read GetAsString write SetAsString;
    property AsFixedChar: String read GetAsString write SetAsFixedChar;
    property AsTime: TDateTime read GetAsDateTime write SetAsTime;
    property AsWideMemo: WideString read GetWideString write SetAsWideMemo;
    property AsWideString: WideString read GetWideString write SetWideString;
    property AsWord: LongInt read GetAsInteger write SetAsWord;
    // array value properties
    property AsBCDs[AIndex: Integer]: Currency read GetAsBCDs write SetAsBCDs;
    property AsFMTBCDs[AIndex: Integer]: TADBcd read GetAsFMTBCDs write SetAsFMTBCDs;
    property AsBlobs[AIndex: Integer]: TBlobData read GetAsStrings write SetAsBlobs;
    property AsBooleans[AIndex: Integer]: Boolean read GetAsBooleans write SetAsBooleans;
    property AsBytes[AIndex: Integer]: String read GetAsBytes write SetAsBytes;
    property AsVarBytes[AIndex: Integer]: String read GetAsBytes write SetAsVarBytes;
    property AsCurrencys[AIndex: Integer]: Currency read GetAsCurrencys write SetAsCurrencys;
    property AsDates[AIndex: Integer]: TDateTime read GetAsDateTimes write SetAsDates;
    property AsDateTimes[AIndex: Integer]: TDateTime read GetAsDateTimes write SetAsDateTimes;
    property AsFloats[AIndex: Integer]: Extended read GetAsFloats write SetAsFloats;
    property AsGUIDs[AIndex: Integer]: TGUID read GetAsGUIDs write SetAsGUIDs;
    property AsIntegers[AIndex: Integer]: LongInt read GetAsIntegers write SetAsIntegers;
    property AsLargeInts[AIndex: Integer]: LargeInt read GetAsLargeInts write SetAsLargeInts;
    property AsSmallInts[AIndex: Integer]: LongInt read GetAsIntegers write SetAsSmallInts;
    property AsSQLTimeStamps[AIndex: Integer]: TADSQLTimeStamp read GetAsSQLTimeStamps write SetAsSQLTimeStamps;
    property AsMemos[AIndex: Integer]: String read GetAsStrings write SetAsMemos;
    property AsStrings[AIndex: Integer]: String read GetAsStrings write SetAsStrings;
    property AsFixedChars[AIndex: Integer]: String read GetAsStrings write SetAsFixedChars;
    property AsTimes[AIndex: Integer]: TDateTime read GetAsDateTimes write SetAsTimes;
    property AsWideMemos[AIndex: Integer]: WideString read GetWideStrings write SetAsWideMemos;
    property AsWideStrings[AIndex: Integer]: WideString read GetWideStrings write SetWideStrings;
    property AsWords[AIndex: Integer]: LongInt read GetAsIntegers write SetAsWords;
    property Values[AIndex: Integer]: Variant read GetAsVariants write SetAsVariants;
    property IsNulls[AIndex: Integer]: Boolean read GetIsNulls;
    // attributes
    property Bound: Boolean read FBound write FBound;
    property IsNull: Boolean read GetIsNull;
    property Text: String read GetAsString write SetText;
    property Texts[AIndex: Integer]: String read GetAsStrings write SetTexts;
    property BaseParam: TADParam read FBaseParam write FBaseParam;
  published
    property Active: Boolean read FActive write FActive default True;
    property Position: Integer read FPosition write FPosition default 0;
    property Name: String read FName write FName;
    property IsCaseSensitive: Boolean read FIsCaseSensitive write FIsCaseSensitive default False;
    property ArrayType: TADParamArrayType read FArrayType write SetArrayType default atScalar;
    property ArraySize: Integer read GetArraySize write SetArraySize default 1;
    property DataType: TFieldType read FDataType write SetDataType default ftUnknown;
    property ADDataType: TADDataType read FADDataType write FADDataType default dtUnknown;
    property Precision: Integer read FPrecision write FPrecision default 0;
    property NumericScale: Integer read FNumericScale write FNumericScale default 0;
    property ParamType: TParamType read FParamType write FParamType default ptUnknown;
    property Size: Integer read FSize write FSize default 0;
    property Value: Variant read GetAsVariant write SetAsVariant stored IsParamStored;
  end;

  TADParams = class(TCollection)
  private
    FGetOwner: TADGetOwner;
    FBindMode: TADParamBindMode;
    function GetItem(Index: Integer): TADParam;
    procedure SetItem(Index: Integer; const AValue: TADParam);
    function GetActiveCount: Integer;
    function GetArraySize: Integer;
    procedure SetArraySize(const AValue: Integer);
    procedure ReadBinaryData(AStream: TStream);
    function GetParamValues(const AParamName: WideString): Variant;
    procedure SetParamValues(const AParamName: WideString; const AValue: Variant);
  protected
    function GetDataSet: TDataSet;
    function GetOwner: TPersistent; override;
    procedure DefineProperties(AFiler: TFiler); override;
  public
    constructor Create; overload;
    constructor Create(AGetOwner: TADGetOwner); overload;
    destructor Destroy; override;
    procedure AssignValues(AValue: TADParams);
    procedure Prepare(ADefaultDataType: TFieldType);
    procedure Assign(AValue: TPersistent); override;
    function Add: TADParam; overload;
    function Add(const AName: String; const AValue: Variant): TADParam; overload;
    function Add(const AName: String; AType: TFieldType; ASize: Integer = -1): TADParam; overload;
    function CreateParam(AFldType: TFieldType; const AParamName: String;
      AParamType: TParamType): TADParam;
    procedure GetParamList(AList: TList; const AParamNames: String);
    function IsEqual(AValue: TADParams): Boolean;
    function ParamByName(const AValue: String): TADParam;
    function FindParam(const AValue: String): TADParam;
    function FindActiveParam(const AValue: String): TADParam;
    property Items[Index: Integer]: TADParam read GetItem write SetItem; default;
    property ParamValues[const AParamName: WideString]: Variant read GetParamValues write SetParamValues;
    property ActiveCount: Integer read GetActiveCount;
    property ArraySize: Integer read GetArraySize write SetArraySize;
    property BindMode: TADParamBindMode read FBindMode write FBindMode;
  end;

function ADVarType2FieldType(const AValue: Variant): TADMacroDataType;
function ADVar2SQLTyped(const AValue: Variant; AFieldType: TADMacroDataType): String;
function ADVar2SQL(const AValue: Variant): String;

implementation

uses
{$IFDEF AnyDAC_D9}
  Windows,
{$ENDIF}
{$IFDEF AnyDAC_D6Base}
  {$IFDEF AnyDAC_D6}
  VarUtils,
  {$ENDIF}
{$ELSE}
  ActiveX, ComObj,
{$ENDIF}
  SysUtils,
{$IFNDEF AnyDAC_FPC}
  DBConsts,
{$ENDIF}
  daADStanError, daADStanConst;

{$IFDEF AnyDAC_FPC}
const
  SParameterNotFound = 'Parameter ''%s'' not found';
  SInvalidVersion = 'Unable to load bind parameters';
  SUnknownFieldType = 'Field ''%s'' is of an unknown type';
  SBadFieldType = 'Field ''%s'' is of an unsupported type';
  SFieldOutOfRange = 'Value of field ''%s'' is out of range';
{$ENDIF}

{ ---------------------------------------------------------------------------- }
function ADVarType2FieldType(const AValue: Variant): TADMacroDataType;
begin
  case VarType(AValue) and varTypeMask of
  varEmpty    : Result := mdUnknown;
  varNull     : Result := mdUnknown;
  varByte     : Result := mdInteger;
  varSmallint : Result := mdInteger;
  varInteger  : Result := mdInteger;
  varSingle   : Result := mdFloat;
  varDouble   : Result := mdFloat;
  varCurrency : Result := mdFloat;
  varDate     : Result := mdDateTime;
  varString   : Result := mdString;
  varOleStr   : Result := mdString;
  varBoolean  : Result := mdBoolean;
  else
  Result := mdUnknown;
  end;
end;

{ ---------------------------------------------------------------------------- }
function ADVar2SQLTyped(const AValue: Variant; AFieldType: TADMacroDataType): String;
var
  l: Boolean;
  dt: TDateTime;
  d: Double;
{$IFDEF AnyDAC_D7}
  rFS: TFormatSettings;
{$ELSE}
  cPrevDecSep: Char;
  cPrevDateSep: Char;
  cPrevTimeSep: Char;
{$ENDIF}
begin
  Result := '';
  if (VarType(AValue) and varTypeMask) in [varEmpty, varNull] then begin
    if not (AFieldType in [mdRaw, mdIdentifier]) then
      Result := 'NULL';
  end
  else begin
    case AFieldType of
    mdRaw:
      Result := AValue;
    mdInteger:
      Result := VarAsType(AValue, varInteger);
    mdFloat:
      begin
        d := VarAsType(AValue, varDouble);
{$IFDEF AnyDAC_D7}
        rFS.DecimalSeparator := '.';
        Result := FloatToStr(d, rFS);
{$ELSE}
        cPrevDecSep := DecimalSeparator;
        DecimalSeparator := '.';
        try
          Result := FloatToStr(d);
        finally
          DecimalSeparator := cPrevDecSep;
        end;
{$ENDIF}
        Result := '{e ' + Result + '}';
      end;
    mdDate:
      begin
        dt := VarAsType(AValue, varDate);
{$IFDEF AnyDAC_D7}
        rFS.DateSeparator := '-';
        Result := FormatDateTime('yyyy/mm/dd', dt, rFS);
{$ELSE}
        cPrevDateSep := DateSeparator;
        DateSeparator := '-';
        try
          Result := FormatDateTime('yyyy/mm/dd', dt);
        finally
          DateSeparator := cPrevDateSep;
        end;
{$ENDIF}
        Result := '{d ''' + Result + '''}';
      end;
    mdTime:
      begin
        dt := VarAsType(AValue, varDate);
{$IFDEF AnyDAC_D7}
        rFS.TimeSeparator := ':';
        Result := FormatDateTime('hh:nn:ss', dt);
{$ELSE}
        cPrevTimeSep := TimeSeparator;
        TimeSeparator := '-';
        try
          Result := FormatDateTime('hh:nn:ss', dt);
        finally
          TimeSeparator := cPrevTimeSep;
        end;
{$ENDIF}
        Result := '{t ''' + Result + '''}';
      end;
    mdDateTime:
      begin
        dt := VarAsType(AValue, varDate);
{$IFDEF AnyDAC_D7}
        rFS.DateSeparator := '-';
        rFS.TimeSeparator := ':';
        Result := FormatDateTime('yyyy/mm/dd hh:nn:ss', dt, rFS);
{$ELSE}
        cPrevTimeSep := TimeSeparator;
        cPrevDateSep := DateSeparator;
        DateSeparator := '-';
        TimeSeparator := ':';
        try
          Result := FormatDateTime('yyyy/mm/dd hh:nn:ss', dt);
        finally
          TimeSeparator := cPrevTimeSep;
          DateSeparator := cPrevDateSep;
        end;
{$ENDIF}
        Result := '{dt ''' + Result + '''}';
      end;
    mdUnknown,
    mdString:
      Result := '''' + VarAsType(AValue, varString) + '''';
    mdIdentifier:
      begin
        Result := VarAsType(AValue, varString);
        Result := '{id ''' + Result + '''}';
      end;
    mdBoolean:
      begin
        l := VarAsType(AValue, varBoolean);
        if l then
          Result := '{l True}'
        else
          Result := '{l False}';
      end;
    end;
  end;
end;

{ ---------------------------------------------------------------------------- }
function ADVar2SQL(const AValue: Variant): String;
begin
  Result := ADVar2SQLTyped(AValue, ADVarType2FieldType(AValue));
end;

{ ---------------------------------------------------------------------------- }
{$IFNDEF AnyDAC_D6Base}
function FindVarData(const Variant): PVarData;
begin
  Result := @TVarData(Variant);
end;
{$ENDIF}

{ ---------------------------------------------------------------------------- }
{ TADMacro                                                                     }
{ ---------------------------------------------------------------------------- }
constructor TADMacro.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FValue := Null;
  FDataType := mdRaw;
end;

{ ---------------------------------------------------------------------------- }
function TADMacro.GetSQL: String;
begin
  Result := ADVar2SQLTyped(FValue, DataType);
end;

{ ---------------------------------------------------------------------------- }
function TADMacro.GetDisplayName: String;
begin
  if Name <> '' then
    Result := Name
  else
    Result := inherited GetDisplayName;
end;

{ ---------------------------------------------------------------------------- }
function TADMacro.GetCollectionOwner: TPersistent;
begin
  if not Assigned(Collection) then
    Result := nil
  else
    Result := TADMacros(Collection).GetOwner;
end;

{ ---------------------------------------------------------------------------- }
function TADMacro.IsEqual(AValue: TADMacro): Boolean;
begin
  Result := (Name = AValue.Name) and (DataType = AValue.DataType);
  if Result then
    try
      Result := Value = AValue.Value;
    except
      Result := False;
    end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADMacro.Assign(AValue: TPersistent);
begin
  if AValue is TADMacro then
    try
      if Collection <> nil then
        Collection.BeginUpdate;
      FDataType := TADMacro(AValue).DataType;
      FName := TADMacro(AValue).Name;
      FValue := TADMacro(AValue).Value;
    finally
      if Collection <> nil then
        Collection.EndUpdate;
    end
  else
    inherited Assign(AValue);
end;

{ ---------------------------------------------------------------------------- }
procedure TADMacro.Changed;
begin
  TADMacros(Collection).DoChanged;
end;

{ ---------------------------------------------------------------------------- }
procedure TADMacro.SetDataType(const AValue: TADMacroDataType);
begin
  if FDataType <> AValue then begin
    FDataType := AValue;
    Changed;
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADMacro.SetData(const AValue: Variant; AType: TADMacroDataType);
var
  lEQ: Boolean;
begin
  try
    lEQ := Value = AValue;
  except
    lEQ := False;
  end;
  if not lEQ then begin
    FValue := AValue;
    if AType <> mdUnknown then
      FDataType := AType
    else
      if FDataType = mdUnknown then
        FDataType := ADVarType2FieldType(AValue);
    Changed;
  end;
end;

{ ---------------------------------------------------------------------------- }
function TADMacro.GetIsNull: Boolean;
begin
  with FindVarData(FValue)^ do 
    Result := (VType = varNull) or (VType = varEmpty);
end;

{ ---------------------------------------------------------------------------- }
procedure TADMacro.Clear;
begin
  SetData(Null, mdUnknown);
end;

{ ---------------------------------------------------------------------------- }
procedure TADMacro.SetValue(const AValue: Variant);
begin
  SetData(AValue, mdUnknown);
end;

{ ---------------------------------------------------------------------------- }
function TADMacro.GetAsString: String;
begin
  if IsNull then
    Result := ''
  else
    Result := FValue;
end;

{ ---------------------------------------------------------------------------- }
procedure TADMacro.SetAsString(const AValue: String);
begin
  SetData(AValue, mdString);
end;

{ ---------------------------------------------------------------------------- }
procedure TADMacro.SetAsIdentifier(const AValue: String);
begin
  SetData(AValue, mdIdentifier);
end;

{ ---------------------------------------------------------------------------- }
function TADMacro.GetAsInteger: Integer;
begin
  if IsNull then
    Result := 0
  else
    Result := FValue;
end;

{ ---------------------------------------------------------------------------- }
procedure TADMacro.SetAsInteger(const AValue: Integer);
begin
  SetData(AValue, mdInteger);
end;

{ ---------------------------------------------------------------------------- }
function TADMacro.GetAsDateTime: TDateTime;
begin
  if IsNull then
    Result := 0.0
  else
    Result := FValue;
end;

{ ---------------------------------------------------------------------------- }
procedure TADMacro.SetAsDateTime(const AValue: TDateTime);
begin
  SetData(AValue, mdDateTime);
end;

{ ---------------------------------------------------------------------------- }
function TADMacro.GetAsFloat: Double;
begin
  if IsNull then
    Result := 0.0
  else
    Result := FValue;
end;

{ ---------------------------------------------------------------------------- }
procedure TADMacro.SetAsFloat(const AValue: Double);
begin
  SetData(AValue, mdFloat);
end;

{ ---------------------------------------------------------------------------- }
function TADMacro.GetAsDate: TDateTime;
begin
  if IsNull then
    Result := 0.0
  else
    Result := FValue;
end;

{ ---------------------------------------------------------------------------- }
procedure TADMacro.SetAsDate(const AValue: TDateTime);
var
  dt: TDateTime;
begin
  dt := Trunc(AValue);
  SetData(dt, mdDate);
end;

{ ---------------------------------------------------------------------------- }
function TADMacro.GetAsTime: TDateTime;
begin
  if IsNull then
    Result := 0.0
  else
    Result := FValue;
end;

{ ---------------------------------------------------------------------------- }
procedure TADMacro.SetAsTime(const AValue: TDateTime);
var
  dt: TDateTime;
begin
  dt := AValue - Trunc(AValue);
  SetData(dt, mdTime);
end;

{ ---------------------------------------------------------------------------- }
function TADMacro.GetAsRaw: String;
begin
  if IsNull then
    Result := ''
  else
    Result := FValue;
end;

{ ---------------------------------------------------------------------------- }
procedure TADMacro.SetAsRaw(const AValue: String);
begin
  SetData(AValue, mdRaw);
end;

{ ---------------------------------------------------------------------------- }
{ TADMacros                                                                    }
{ ---------------------------------------------------------------------------- }
constructor TADMacros.Create;
var
  oTmp: TADGetOwner;
begin
  oTmp := nil;
  Create(oTmp);
end;

{ ---------------------------------------------------------------------------- }
constructor TADMacros.Create(AGetOwner: TADGetOwner);
begin
  FGetOwner := AGetOwner;
  inherited Create(TADMacro);
end;

{ ---------------------------------------------------------------------------- }
procedure TADMacros.Assign(AValue: TPersistent);
var
  i, j: Integer;
  s: String;
begin
  if AValue is TStrings then begin
    BeginUpdate;
    try
      Clear;
      for i := 0 to TStrings(AValue).Count - 1 do
        with TADMacro(Add) do begin
          s := TStrings(AValue)[i];
          j := Pos('=', s);
          Name := Copy(s, 1, j - 1);
          Value := Copy(s, j + 1, Length(s));
        end;
    finally
      EndUpdate;
    end;
  end
  else
    inherited Assign(AValue);
end;

{ ---------------------------------------------------------------------------- }
procedure TADMacros.AssignTo(ADest: TPersistent);
var
  i: Integer;
begin
  if ADest is TStrings then begin
    TStrings(ADest).Clear;
    for i := 0 to Count - 1 do
      TStrings(ADest).Add(Items[i].Name + '=' + Items[i].Value);
  end
  else
    inherited AssignTo(ADest);
end;

{ ---------------------------------------------------------------------------- }
procedure TADMacros.AssignValues(AValue: TADMacros);
var
  i: Integer;
  oMacro: TADMacro;
begin
  BeginUpdate;
  try
    for i := 0 to AValue.Count - 1 do begin
      oMacro := FindMacro(AValue[i].Name);
      if oMacro <> nil then
        oMacro.Assign(AValue[i]);
    end;
  finally
    EndUpdate;
  end;
end;

{ ---------------------------------------------------------------------------- }
function TADMacros.IsEqual(AValue: TADMacros): Boolean;
var
  i: Integer;
begin
  Result := Count = AValue.Count;
  if Result then
    for i := 0 to Count - 1 do begin
      Result := Items[i].IsEqual(AValue.Items[i]);
      if not Result then
        Break;
    end
end;

{ ---------------------------------------------------------------------------- }
function TADMacros.FindMacro(const AValue: String): TADMacro;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do begin
    Result := Items[i];
    if {$IFDEF AnyDAC_NOLOCALE_META} ADCompareText {$ELSE} AnsiCompareText {$ENDIF}
       (Result.Name, AValue) = 0 then
      Exit;
  end;
  Result := nil;
end;

{ ---------------------------------------------------------------------------- }
function TADMacros.MacroByName(const AValue: String): TADMacro;
begin
  Result := FindMacro(AValue);
  if Result = nil then
    ADException(Self, [S_AD_LStan], er_AD_StanMacroNotFound, [AValue]);
end;

{ ---------------------------------------------------------------------------- }
function TADMacros.GetDataSet: TDataSet;
begin
  if Assigned(FGetOwner) and (FGetOwner() <> nil) and (FGetOwner() is TDataSet) then
    Result := TDataSet(FGetOwner())
  else
    Result := nil;
end;

{ ---------------------------------------------------------------------------- }
function TADMacros.GetItem(AIndex: Integer): TADMacro;
begin
  Result := TADMacro(inherited Items[AIndex]);
end;

{ ---------------------------------------------------------------------------- }
procedure TADMacros.SetItem(AIndex: Integer; AValue: TADMacro);
begin
  inherited Items[AIndex] := AValue;
end;

{ ---------------------------------------------------------------------------- }
function TADMacros.GetOwner: TPersistent;
begin
  if Assigned(FGetOwner) then
    Result := FGetOwner()
  else
    Result := nil; 
end;

{ ---------------------------------------------------------------------------- }
procedure TADMacros.DoChanged;
begin
  if (UpdateCount = 0) and Assigned(FOnChanged) then
    FOnChanged(Self);
end;

{ ---------------------------------------------------------------------------- }
procedure TADMacros.EndUpdate;
begin
  inherited EndUpdate;
  DoChanged;
end;

{ ---------------------------------------------------------------------------- }
{ TADParams                                                                    }
{ ---------------------------------------------------------------------------- }
constructor TADParams.Create;
var
  oTmp: TADGetOwner;
begin
  oTmp := nil;
  Create(oTmp);
end;

{ ---------------------------------------------------------------------------- }
constructor TADParams.Create(AGetOwner: TADGetOwner);
begin
  FGetOwner := AGetOwner;
  inherited Create(TADParam);
end;

{ ---------------------------------------------------------------------------- }
destructor TADParams.Destroy;
begin
  inherited Destroy;
end;

{ ---------------------------------------------------------------------------- }
function TADParams.GetDataSet: TDataSet;
begin
  if Assigned(FGetOwner) and (FGetOwner() <> nil) and (FGetOwner() is TDataSet) then
    Result := TDataSet(FGetOwner())
  else
    Result := nil;
end;

{ ---------------------------------------------------------------------------- }
function TADParams.GetOwner: TPersistent;
begin
  if Assigned(FGetOwner) then
    Result := FGetOwner()
  else
    Result := nil;
end;

{ ---------------------------------------------------------------------------- }
function TADParams.Add: TADParam;
begin
  Result := TADParam(inherited Add);
end;

{ ---------------------------------------------------------------------------- }
function TADParams.Add(const AName: String;
  const AValue: Variant): TADParam;
begin
  Result := Add;
  Result.Name := AName;
  Result.Value := AValue;
end;

{ ---------------------------------------------------------------------------- }
function TADParams.Add(const AName: String; AType: TFieldType;
  ASize: Integer): TADParam;
begin
  Result := Add;
  Result.Name := AName;
  Result.DataType := AType;
  if ASize <> -1 then
    Result.Size := ASize;
end;

{ ---------------------------------------------------------------------------- }
function TADParams.CreateParam(AFldType: TFieldType;
  const AParamName: String; AParamType: TParamType): TADParam;
begin
  Result := Add;
  Result.ParamType := AParamType;
  Result.Name := AParamName;
  Result.DataType := AFldType;
end;

{ ---------------------------------------------------------------------------- }
function TADParams.FindParam(const AValue: String): TADParam;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do begin
    Result := TADParam(inherited Items[i]);
    if {$IFDEF AnyDAC_NOLOCALE_META} ADCompareText {$ELSE} AnsiCompareText {$ENDIF}
       (Result.Name, AValue) = 0 then
      Exit;
  end;
  Result := nil;
end;

{ ---------------------------------------------------------------------------- }
function TADParams.FindActiveParam(const AValue: String): TADParam;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do begin
    Result := TADParam(inherited Items[i]);
    if Result.Active and ({$IFDEF AnyDAC_NOLOCALE_META} ADCompareText {$ELSE}
        AnsiCompareText {$ENDIF}(Result.Name, AValue) = 0) then
      Exit;
  end;
  Result := nil;
end;

{ ---------------------------------------------------------------------------- }
function TADParams.ParamByName(const AValue: String): TADParam;
begin
  Result := FindParam(AValue);
  if Result = nil then
    DatabaseErrorFmt(SParameterNotFound, [AValue], GetDataSet);
end;

{ ---------------------------------------------------------------------------- }
function TADParams.GetItem(Index: Integer): TADParam;
begin
  Result := TADParam(inherited Items[Index]);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParams.SetItem(Index: Integer; const AValue: TADParam);
begin
  inherited Items[Index] := AValue;
end;

{ ---------------------------------------------------------------------------- }
function TADParams.GetActiveCount: Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to Count - 1 do
    if Items[i].Active then
      Inc(Result);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParams.Assign(AValue: TPersistent);
begin
  if AValue = Self then
    Exit;
  if AValue is TADParams then
    FBindMode := TADParams(AValue).BindMode;
  inherited Assign(AValue);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParams.AssignValues(AValue: TADParams);
var
  i, j, n: Integer;
  oPar1, oPar2: TADParam;
begin
  if AValue = Self then
    Exit;
  if BindMode = pbByName then
    for i := AValue.Count - 1 downto 0 do begin
      oPar1 := AValue[i];
      for j := 0 to Count - 1 do begin
        oPar2 := TADParam(inherited Items[j]);
        if {$IFDEF AnyDAC_NOLOCALE_META} ADCompareText {$ELSE} AnsiCompareText {$ENDIF}
           (oPar1.Name, oPar2.Name) = 0 then
          oPar2.AssignParam(oPar1);
      end;
    end
  else begin
    n := AValue.Count;
    if n > Count then
      n := Count;
    for i := 0 to n - 1 do
      TADParam(inherited Items[i]).AssignParam(AValue[i]);
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParams.Prepare(ADefaultDataType: TFieldType);
var
  i, j: Integer;
  oPar1, oPar2: TADParam;
begin
  for i := 0 to Count - 1 do
    TADParam(inherited Items[i]).BaseParam := nil;
  if BindMode = pbByName then
    for i := 0 to Count - 2 do begin
      oPar1 := TADParam(inherited Items[i]);
      if oPar1.BaseParam = nil then
        for j := i + 1 to Count - 1 do begin
          oPar2 := TADParam(inherited Items[j]);
          if {$IFDEF AnyDAC_NOLOCALE_META} ADCompareText {$ELSE} AnsiCompareText {$ENDIF}
             (oPar1.Name, oPar2.Name) = 0 then begin
            oPar2.AssignParam(oPar1);
            oPar2.BaseParam := oPar1;
          end;
        end;
    end;
  for i := 0 to Count - 1 do begin
    oPar1 := TADParam(inherited Items[i]);
    if oPar1.DataType = ftUnknown then
      oPar1.DataType := ADefaultDataType;
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParams.GetParamList(AList: TList; const AParamNames: String);
var
  iPos: Integer;
begin
  iPos := 1;
  while iPos <= Length(AParamNames) do
    AList.Add(ParamByName(ADExtractFieldName(AParamNames, iPos)));
end;

{ ---------------------------------------------------------------------------- }
function TADParams.IsEqual(AValue: TADParams): Boolean;
var
  i: Integer;
begin
  Result := (Count = AValue.Count);
  if Result then
    for i := 0 to Count - 1 do begin
      Result := Items[i].IsEqual(AValue.Items[i]);
      if not Result then
        Break;
    end
end;

{ ---------------------------------------------------------------------------- }
function TADParams.GetArraySize: Integer;
begin
  if Count = 0 then
    Result := 1
  else
    Result := Items[0].ArraySize;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParams.SetArraySize(const AValue: Integer);
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    Items[i].ArraySize := AValue;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParams.DefineProperties(AFiler: TFiler);
begin
  inherited DefineProperties(AFiler);
  AFiler.DefineBinaryProperty('Data', ReadBinaryData, nil, False);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParams.ReadBinaryData(AStream: TStream);
var
  I, Temp, NumItems: Integer;
  Buffer: array[0..2047] of Char;
  TempStr: string;
  Version: Word;
  Bool: Boolean;
begin
  Clear;
  with AStream do
  begin
    Version := 0;
    ReadBuffer(Version, SizeOf(Version));
    if Version > 2 then DatabaseError(SInvalidVersion);
    NumItems := 0;
    if Version = 2 then
      ReadBuffer(NumItems, SizeOf(NumItems)) else
      ReadBuffer(NumItems, 2);
    for I := 0 to NumItems - 1 do
      with TADParam(Add) do
      begin
        Temp := 0;
        if Version = 2 then
          ReadBuffer(Temp, SizeOf(Temp)) else
          ReadBuffer(Temp, 1);
        SetLength(TempStr, Temp);
        ReadBuffer(PChar(TempStr)^, Temp);
        Name := TempStr;
        ReadBuffer(FParamType, SizeOf(FParamType));
        ReadBuffer(FDataType, SizeOf(FDataType));
        if DataType <> ftUnknown then
        begin
          Temp := 0;
          if Version = 2 then
            ReadBuffer(Temp, SizeOf(Temp)) else
            ReadBuffer(Temp, 2);
          ReadBuffer(Buffer, Temp);
          SetData(@Buffer, Temp);
        end;
        Bool := False;
        ReadBuffer(Bool, SizeOf(Bool));
        if Bool then FValue[0] := NULL;
        ReadBuffer(FBound, SizeOf(FBound));
      end;
  end;
end;

{ ---------------------------------------------------------------------------- }
function TADParams.GetParamValues(const AParamName: WideString): Variant;
var
  i: Integer;
  oParams: TList;
begin
  if Pos(';', AParamName) <> 0 then begin
    oParams := TList.Create;
    try
      GetParamList(oParams, AParamName);
      Result := VarArrayCreate([0, oParams.Count - 1], varVariant);
      for I := 0 to oParams.Count - 1 do
        Result[I] := TADParam(oParams[I]).Value;
    finally
      oParams.Free;
    end;
  end
  else
    Result := ParamByName(AParamName).Value;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParams.SetParamValues(const AParamName: WideString; const AValue: Variant);
var
  i: Integer;
  oParams: TList;
begin
  if Pos(';', AParamName) <> 0 then begin
    oParams := TList.Create;
    try
      GetParamList(oParams, AParamName);
      for i := 0 to oParams.Count - 1 do
        TADParam(oParams[I]).Value := AValue[I];
    finally
      oParams.Free;
    end;
  end
  else
    ParamByName(AParamName).Value := AValue;
end;

{ ---------------------------------------------------------------------------- }
{ TADParam                                                                     }
{ ---------------------------------------------------------------------------- }
var
  VarTypeMap: array[TFieldType] of Integer = (
    varError, varString, varSmallint, varInteger, varSmallint,
    varBoolean, varDouble, varCurrency, varCurrency, varDate, varDate, varDate,
    varString, varString, varInteger, varString, varString, varString, varOleStr,
    varString, varString, varString, varError, varString, varOleStr,
    varInt64, varError, varError, varError, varError, varString, varString,
    varVariant, varUnknown, varDispatch, varString
{$IFDEF AnyDAC_D6Base}
    , varString, varString
  {$IFDEF AnyDAC_D10}
    , varString, varString
    , varString, varString
  {$ENDIF}
{$ENDIF}    
    );

constructor TADParam.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FActive := True;
  UpdateData(1);
end;

{ ---------------------------------------------------------------------------- }
constructor TADParam.Create(AParams: TParams; AParamType: TParamType);
begin
  Create(AParams);
  ParamType := AParamType;
end;

{ ---------------------------------------------------------------------------- }
function TADParam.IsEqual(AValue: TADParam): Boolean;

  function CompareValues(const V1, V2: TADVariantArray): Boolean;
  var
    i: Integer;
  begin
    Result := Length(V1) = Length(V2);
    if Result then
      for i := 0 to Length(V1) - 1 do
{$IFDEF AnyDAC_D6Base}
        if VarCompareValue(V1[i], V2[i]) <> vrEqual then begin
{$ELSE}
        if not (
            (VarType(V1[i]) = VarType(V2[i])) and
            (VarIsEmpty(V1[i]) or (V1[i] = V2[i]))) then begin
{$ENDIF}
          Result := False;
          Break;
        end;
  end;

begin
  Result :=
    (Active = AValue.Active) and (Position = AValue.Position) and
    (IsCaseSensitive = AValue.IsCaseSensitive) and (ArrayType = AValue.ArrayType) and
    (ArraySize = AValue.ArraySize) and (DataType = AValue.DataType) and
    (ADDataType = AValue.ADDataType) and (Precision = AValue.Precision) and
    (NumericScale = AValue.NumericScale) and (Name = AValue.Name) and
    (ParamType = AValue.ParamType) and (Size = AValue.Size) and
    (IsNull = AValue.IsNull) and (Bound = AValue.Bound) and
    CompareValues(FValue, AValue.FValue);
end;

{ ---------------------------------------------------------------------------- }
function TADParam.IsParamStored: Boolean;
begin
  Result := Bound and (ArrayType = atScalar);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.CheckIndex(var AIndex: Integer);
  procedure ErrIndex;
  begin
    ADException(Self, [S_AD_LStan], er_AD_StanBadParRowIndex, [Name]);
  end;
begin
  if AIndex < 0 then
    AIndex := 0;
  if (AIndex = 0) or
     (ArrayType = atScalar) and (AIndex <= 0) and (Length(FValue) = 1) or
     (ArrayType <> atScalar) and (AIndex >= 0) and (Length(FValue) > AIndex) then
    Exit;
  ErrIndex;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.UpdateData(ADim: Integer);
var
  i, iLen: Integer;
begin
  iLen := Length(FValue);
  if iLen <> ADim then begin
    SetLength(FValue, ADim);
    for i := iLen to ADim - 1 do
      FValue[i] := Null;
  end;
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetArraySize: Integer;
begin
  Result := Length(FValue);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetArraySize(AValue: Integer);
begin
  if ArraySize <> AValue then begin
    if AValue > 1 then begin
      if FArrayType = atScalar then
        FArrayType := atArray;
    end
    else if AValue < 1 then
      AValue := 1;
    UpdateData(AValue);
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetArrayType(AValue: TADParamArrayType);
begin
  if ArrayType <> AValue then begin
    FArrayType := AValue;
    if (ArrayType = atScalar) and (ArraySize > 1) then
      ArraySize := 1;
  end;
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetIsNull: Boolean;
begin
  Result := GetIsNulls(0);
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetIsNulls(AIndex: Integer): Boolean;
begin
  if FBaseParam <> nil then begin
    Result := FBaseParam.GetIsNulls(AIndex);
    Exit;
  end;
  CheckIndex(AIndex);
  with FindVarData(FValue[AIndex])^ do
    Result := (VType = varNull) or (VType = varEmpty);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetDataType(AValue: TFieldType);
var
  vType, i: Integer;
begin
  if FDataType <> AValue then begin
    FDataType := AValue;
    if Assigned(DataSet) and (csDesigning in DataSet.ComponentState) and
       not GetIsNulls(-1) then begin
      vType := VarTypeMap[AValue];
      if vType <> varError then
        try
          for i := 0 to Length(FValue) - 1 do
            VarCast(FValue[i], FValue[i], vType);
        except
          Clear;
        end
      else
        Clear;
    end
    else
      Clear;
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.ErrUnknownFieldType;
begin
  DatabaseErrorFmt(SUnknownFieldType, [Name], DataSet);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.ErrBadFieldType;
begin
  DatabaseErrorFmt(SBadFieldType, [Name], DataSet);
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetDataSize(AIndex: Integer): Integer;
var
  pVar: PVariant;
  s: String;
  ws: WideString;

  function GetStrVarLen(out AResult: Integer): Boolean;
  begin
    if VarType(pVar^) = varString then begin
      AResult := Length(String(TVarData(pVar^).VString));
      Result := True;
    end
    else if VarType(pVar^) = varOleStr then begin
      AResult := ADWideStrLen(TVarData(pVar^).VOleStr);
      Result := True;
    end
    else
      Result := False;
  end;

begin
  if FBaseParam <> nil then begin
    Result := FBaseParam.GetDataSize(AIndex);
    Exit;
  end;
  Result := 0;
  GetVarData(pVar, AIndex);
  case DataType of
    ftUnknown:
      ErrUnknownFieldType;
    ftString, ftFixedChar, ftADT:
      begin
        if not GetStrVarLen(Result) then
          if not VarIsNull(pVar^) then begin
            s := pVar^;
            Result := Length(s);
          end;
        Inc(Result);
      end;
    ftWideString:
      begin
        if not GetStrVarLen(Result) then
          if not VarIsNull(pVar^) then begin
            ws := pVar^;
            Result := Length(ws);
          end;
        Inc(Result);
      end;
    ftBoolean:
      Result := SizeOf(WordBool);
{$IFDEF AnyDAC_D6Base}
    ftFMTBcd,
{$ENDIF}
    ftBCD:
      Result := SizeOf(TADBcd);
{$IFDEF AnyDAC_D6Base}
    ftTimeStamp:
      Result := SizeOf(TADSQLTimeStamp);
{$ENDIF}
    ftCurrency:
      Result := SizeOf(Currency);
    ftDateTime, ftFloat:
      Result := SizeOf(Double);
    ftTime, ftDate, ftAutoInc, ftInteger:
      Result := SizeOf(Integer);
    ftSmallint:
      Result := SizeOf(SmallInt);
    ftWord:
      Result := SizeOf(Word);
    ftBytes, ftVarBytes:
      if VarIsArray(pVar^) then
        Result := VarArrayHighBound(pVar^, 1) + 1
      else if not GetStrVarLen(Result) then
        Result := 0;
    ftBlob .. ftTypedBinary, ftOraClob, ftOraBlob:
      if not GetStrVarLen(Result) then
        Result := Length(VarToStr(pVar^));
    ftLargeint:
      Result := SizeOf(Largeint);
    ftArray, ftDataSet, ftReference, ftCursor:
      Result := 0;
    ftGUID:
      Result := SizeOf(TGUID);
  else
    ErrBadFieldType;
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.GetData(ABuffer: TADBuffer; AIndex: Integer);
var
  S: String;
  WS: WideString;
begin
  if FBaseParam <> nil then begin
    FBaseParam.GetData(ABuffer, AIndex);
    Exit;
  end;
  CheckIndex(AIndex);
  case DataType of
    ftUnknown:
      ErrUnknownFieldType;
    ftString, ftFixedChar, ftAdt:
      begin
        S := AsStrings[AIndex];
        ADMove(PChar(S)^, ABuffer^, (Length(S) + 1) * SizeOf(AnsiChar));
      end;
    ftWideString, ftFmtMemo:
      begin
        WS := AsWideStrings[AIndex];
        ADMove(PWideChar(WS)^, ABuffer^, (Length(WS) + 1) * SizeOf(WideChar));
      end;
    ftSmallint:
      PSmallInt(ABuffer)^ := SmallInt(AsIntegers[AIndex]);
    ftWord:
      PWord(ABuffer)^ := Word(AsIntegers[AIndex]);
    ftAutoInc, ftInteger:
      PInteger(ABuffer)^ := AsIntegers[AIndex];
    ftLargeint:
      PInt64(ABuffer)^ := AsLargeInts[AIndex];
    ftTime:
      PADDateTimeData(ABuffer)^.Time := DateTimeToTimeStamp(AsDateTimes[AIndex]).Time;
    ftDate:
      PADDateTimeData(ABuffer)^.Date := DateTimeToTimeStamp(AsDateTimes[AIndex]).Date;
{$IFDEF AnyDAC_D6Base}
    ftDateTime:
      PADDateTimeData(ABuffer)^.DateTime := TimeStampToMSecs(DateTimeToTimeStamp(AsDateTimes[AIndex]));
    ftTimeStamp:
      PADSQLTimeStamp(ABuffer)^ := AsSQLTimeStamps[AIndex];
{$ELSE}
    ftDateTime:
      if ADDataType = dtDateTimeStamp then
        PADSQLTimeStamp(ABuffer)^ := AsSQLTimeStamps[AIndex]
      else
        PADDateTimeData(ABuffer)^.DateTime := TimeStampToMSecs(DateTimeToTimeStamp(AsDateTimes[AIndex]));
{$ENDIF}
    ftBCD:
      begin
        S := CurrToStr(AsBCDs[AIndex]);
        ADStr2BCD(PChar(S), Length(S), PADBcd(ABuffer)^, DecimalSeparator);
      end;
{$IFDEF AnyDAC_D6Base}
    ftFMTBCD:
      PADBcd(ABuffer)^ := AsFMTBCDs[AIndex];
{$ENDIF}
    ftFloat:
      PDouble(ABuffer)^ := AsFloats[AIndex];
    ftCurrency:
      PCurrency(ABuffer)^ := AsCurrencys[AIndex];
    ftBoolean:
      PWord(ABuffer)^ := Ord(AsBooleans[AIndex]);
    ftBytes, ftVarBytes:
      GetBytesValue(AIndex, ABuffer);
    ftBlob .. ftGraphic, ftParadoxOle .. ftTypedBinary, ftOraBlob, ftOraClob:
      begin
        S := AsStrings[AIndex];
        ADMove(PChar(S)^, ABuffer^, Length(S));
      end;
    ftArray, ftDataSet, ftReference, ftCursor:
      {Nothing};
    ftGUID:
      PGUID(ABuffer)^ := AsGUIDs[AIndex];
  else
    ErrBadFieldType;
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetData(ABuffer: TADBuffer; ALen: LongWord; AIndex: Integer);
var
  crValue: Currency;
  TimeStamp: TTimeStamp;
  WS: WideString;
begin
  if FBaseParam <> nil then begin
    FBaseParam.SetData(ABuffer, ALen, AIndex);
    Exit;
  end;
  if DataType = ftUnknown then
    ErrUnknownFieldType
  else if ABuffer = nil then
    Clear
  else
    case DataType of
      ftString, ftFixedChar:
        Values[AIndex] := StrPas(ABuffer);
      ftWideString, ftFmtMemo:
        begin
          if ALen = $FFFFFFFF then
            ALen := ADWideStrLen(PWideChar(ABuffer));
          SetString(WS, PWideChar(ABuffer), ALen);
          Values[AIndex] := WS;
        end;
      ftWord:
        if ADDataType = dtByte then
          AsWords[AIndex] := PByte(ABuffer)^
        else
          AsWords[AIndex] := PWord(ABuffer)^;
      ftSmallint:
        if ADDataType = dtSByte then
          AsSmallInts[AIndex] := PShortint(ABuffer)^
        else if ADDataType = dtByte then
          AsSmallInts[AIndex] := PByte(ABuffer)^
        else
          AsSmallInts[AIndex] := PSmallint(ABuffer)^;
      ftInteger, ftAutoInc:
        AsIntegers[AIndex] := PInteger(ABuffer)^;
      ftLargeint:
        AsLargeInts[AIndex] := PInt64(ABuffer)^;
      ftTime:
        begin
          TimeStamp.Time := PLongInt(ABuffer)^;
          TimeStamp.Date := DateDelta;
          AsTimes[AIndex] := TimeStampToDateTime(TimeStamp);
        end;
      ftDate:
        begin
          TimeStamp.Time := 0;
          TimeStamp.Date := PInteger(ABuffer)^;
          AsDates[AIndex] := TimeStampToDateTime(TimeStamp);
        end;
{$IFDEF AnyDAC_D6Base}
      ftDateTime:
        AsDateTimes[AIndex] := TimeStampToDateTime(MSecsToTimeStamp(PDouble(ABuffer)^));
      ftTimeStamp:
        AsSQLTimeStamps[AIndex] := PADSQLTimeStamp(ABuffer)^;
{$ELSE}
      ftDateTime:
        if ADDataType = dtDateTimeStamp then
          AsSQLTimeStamps[AIndex] := PADSQLTimeStamp(ABuffer)^
        else
          AsDateTimes[AIndex] := TimeStampToDateTime(MSecsToTimeStamp(PDouble(ABuffer)^));
{$ENDIF}
      ftBCD:
        begin
          crValue := 0.0;
          if BCDToCurr(PADBcd(ABuffer)^, crValue) then
            AsBCDs[AIndex] := crValue
          else
            raise EOverFlow.CreateFmt(SFieldOutOfRange, [Name]);
        end;
{$IFDEF AnyDAC_D6Base}
      ftFMTBcd:
        AsFMTBCDs[AIndex] := PADBcd(ABuffer)^;
{$ENDIF}
      ftCurrency:
        AsCurrencys[AIndex] := PCurrency(ABuffer)^;
      ftFloat:
        AsFloats[AIndex] := PDouble(ABuffer)^;
      ftBoolean:
        AsBooleans[AIndex] := PWordBool(ABuffer)^;
      ftCursor:
        begin
          if AIndex < 0 then
            AIndex := 0;
          FValue[AIndex] := 0;
        end;
      ftBytes, ftVarBytes:
        begin
          if ALen = $FFFFFFFF then
            ALen := StrLen(PChar(ABuffer));
          SetBytesValue(AIndex, ABuffer, ALen);
        end;
      ftBlob .. ftGraphic, ftParadoxOle .. ftTypedBinary, ftOraBlob, ftOraClob:
        begin
          if ALen = $FFFFFFFF then
            ALen := StrLen(PChar(ABuffer));
          SetBlobRawData(ALen, ABuffer, AIndex);
        end;
      ftGUID:
        AsGUIDs[AIndex] := PGUID(ABuffer)^;
    else
      ErrBadFieldType;
    end;
end;

{ ---------------------------------------------------------------------------- }
function TADParam.SetBlobRawData(ALen: LongWord; APtr: TADBuffer; AIndex: Integer): TADBytes;
begin
  if FBaseParam <> nil then begin
    Result := FBaseParam.SetBlobRawData(ALen, APtr, AIndex);
    Exit;
  end;
  CheckIndex(AIndex);
  if not (DataType in [ftString, ftWideString, ftFixedChar,
                       ftBlob .. ftTypedBinary,
                       ftOraBlob, ftOraClob]) then
    FDataType := ftBlob;
  FBound := True;
  FValue[AIndex] := Null;
  if ALen > 0 then
    with TVarData(FValue[AIndex]) do begin
      VType := varString;
      if APtr <> nil then
        SetString(String(VString), PChar(APtr), ALen)
      else
        SetLength(String(VString), ALen);
      Result := PChar(String(VString));
    end
  else
    Result := nil;
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetBlobRawData(var ALen: LongWord; var APtr: TADBuffer; AIndex: Integer): Boolean;

  procedure ErrorCantGet;
  begin
    ADException(Self, [S_AD_LStan], er_AD_StanCantGetBlob, []);
  end;

begin
  if FBaseParam <> nil then begin
    Result := FBaseParam.GetBlobRawData(ALen, APtr, AIndex);
    Exit;
  end;
  if not (DataType in [ftString, ftWideString, ftFixedChar,
                       ftBlob .. ftTypedBinary,
                       ftOraBlob, ftOraClob]) then
    ErrorCantGet;
  Result := not IsNulls[AIndex];
  if not Result then begin
    ALen := 0;
    APtr := nil;
  end
  else begin
    if AIndex < 0 then
      AIndex := 0;
    case VarType(FValue[AIndex]) of
    varString:
      begin
        APtr := TADBuffer(String(TVarData(FValue[AIndex]).VString));
        ALen := Length(String(TVarData(FValue[AIndex]).VString));
      end;
    varOleStr:
      begin
        APtr := TADBuffer(TVarData(FValue[AIndex]).VOleStr);
        ALen := ADWideStrLen(TVarData(FValue[AIndex]).VOleStr);
      end;
    else
      VarCast(FValue[AIndex], FValue[AIndex], varString);
      Result := GetBlobRawData(ALen, APtr, AIndex);
    end;
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetBytesValue(AIndex: Integer; ABuff: TADBuffer; ASize: LongWord);
var
  V: Variant;
  pDest: Pointer;
begin
  if not (DataType in [ftVarBytes, ftBytes]) then
    DataType := ftBytes;
  V := VarArrayCreate([0, ASize - 1], varByte);
  pDest := VarArrayLock(V);
  try
    ADMove(ABuff^, pDest^, ASize);
  finally
    VarArrayUnlock(V);
  end;
  Values[AIndex] := V;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.GetBytesValue(AIndex: Integer; ABuff: TADBuffer);
var
  V: Variant;
  P: Pointer;
  S: String;
begin
  V := Values[AIndex];
  if VarIsArray(V) then begin
    P := VarArrayLock(V);
    try
      ADMove(P^, ABuff^, VarArrayHighBound(V, 1) + 1);
    finally
      VarArrayUnlock(V);
    end;
  end
  else
    with FindVarData(V)^ do
      if (VType <> varNull) and (VType <> varEmpty) then begin
        S := V;
        ADMove(PChar(S)^, ABuff^, Length(S));
      end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.Assign(ASource: TPersistent);

{$IFDEF AnyDAC_D6Base}
  procedure LoadFromStreamPersist(const StreamPersist: IStreamPersist);
  var
    MS: TMemoryStream;
  begin
    MS := TMemoryStream.Create;
    try
      StreamPersist.SaveToStream(MS);
      LoadFromStream(MS, ftGraphic);
    finally
      MS.Free;
    end;
  end;
{$ENDIF}

  procedure LoadFromStrings(ASource: TStrings);
  begin
    AsMemo := ASource.Text;
  end;

{$IFDEF AnyDAC_D6Base}
var
  StreamPersist: IStreamPersist;
{$ENDIF}
begin
  if ASource is TADParam then
    AssignParam(TADParam(ASource))
  else if ASource is TParam then
    AssignDlpParam(TParam(ASource))
  else if ASource is TField then
    AssignField(TField(ASource))
  else if ASource is TStrings then
    LoadFromStrings(TStrings(ASource))
{$IFDEF AnyDAC_D6Base}
  else if Supports(ASource, IStreamPersist, StreamPersist) then
    LoadFromStreamPersist(StreamPersist)
{$ENDIF}
  else
    inherited Assign(ASource);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.AssignTo(ADest: TPersistent);
begin
  if ADest is TField then
    TField(ADest).Value := FValue[0]
  else if ADest is TParam then
    AssignToDlpParam(TParam(ADest))
  else
    inherited AssignTo(ADest);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.AssignParam(AParam: TADParam);
begin
  if AParam <> nil then begin
    FDataType := AParam.DataType;
    FADDataType := AParam.ADDataType;
    FBound := AParam.Bound;
    FName := AParam.Name;
    if FParamType = ptUnknown then
      FParamType := AParam.ParamType;
    FSize := AParam.Size;
    FPrecision := AParam.Precision;
    FNumericScale := AParam.NumericScale;
    FActive := AParam.Active;
    FPosition := AParam.Position;
    FIsCaseSensitive := AParam.IsCaseSensitive;
    ArraySize := AParam.ArraySize;
    ArrayType := AParam.ArrayType;
    FValue := Copy(AParam.FValue);
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.AssignDlpParam(AParam: TParam);
begin
  if AParam <> nil then begin
    FDataType := AParam.DataType;
    FADDataType := dtUnknown;
    FBound := AParam.Bound;
    FName := AParam.Name;
    if FParamType = ptUnknown then
      FParamType := AParam.ParamType;
{$IFDEF AnyDAC_D6Base}
    FSize := AParam.Size;
    FPrecision := AParam.Precision;
    FNumericScale := SmallInt(AParam.NumericScale);
{$ELSE}
    FSize := 0;
    FPrecision := 0;
    FNumericScale := 0;
{$ENDIF}
    FActive := True;
    FPosition := 0;
    FIsCaseSensitive := False;
    ArraySize := 1;
    ArrayType := atScalar;
    FValue[0] := AParam.Value;
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.AssignToDlpParam(AParam: TParam);
begin
  if AParam <> nil then begin
    AParam.DataType := FDataType;
    AParam.Bound := FBound;
    AParam.Name := FName;
    if AParam.ParamType = ptUnknown then
      AParam.ParamType := FParamType;
{$IFDEF AnyDAC_D6Base}
    AParam.Size := FSize;
    AParam.Precision := FPrecision;
    AParam.NumericScale := FNumericScale;
{$ENDIF}
    AParam.Value := FValue[0];
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.AssignFieldValue(AField: TField; const AValue: Variant);
begin
  if AField <> nil then begin
    if (AField.DataType = ftString) and TStringField(AField).FixedChar then
      DataType := ftFixedChar
    else if (AField.DataType = ftMemo) and (AField.Size > 255) then
      DataType := ftString
    else if (AField.DataType = ftFmtMemo) and (AField.Size > 255) then
      DataType := ftWideString
{$IFDEF AnyDAC_D10}
    else if (AField.DataType = ftWideString) and TWideStringField(AField).FixedChar then
      DataType := ftFixedWideChar
    else if (AField.DataType = ftWideMemo) and (AField.Size > 255) then
      DataType := ftWideString
{$ENDIF}
    else
      DataType := AField.DataType;
    FADDataType := dtUnknown;
    if DataType = ftWideString then
      Size := AField.Size
    else
      Size := AField.DataSize;
    if AField.DataType in [ftBcd {$IFDEF AnyDAC_D6Base}, ftFMTBcd {$ENDIF}] then
      NumericScale := AField.Size;
    ArraySize := 1;
    ArrayType := atScalar;
    FBound := True;
    if VarIsNull(AValue) then
      Clear
    else
      Value := AValue;
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.AssignField(AField: TField);
begin
  if AField <> nil then begin
    AssignFieldValue(AField, AField.Value);
    Name := AField.FieldName;
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.Clear(AIndex: Integer);
var
  i: Integer;
begin
  if FBaseParam <> nil then begin
    FBaseParam.Clear(AIndex);
    Exit;
  end;
  if (ArrayType = atScalar) then
    FValue[0] := Null
  else if AIndex = -1 then
    for i := 0 to Length(FValue) - 1 do
      FValue[i] := Null
  else begin
    CheckIndex(AIndex);
    FValue[AIndex] := Null;
  end;
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetDataSet: TDataSet;
begin
  if not Assigned(Collection) then
    Result := nil
  else
    Result := TADParams(Collection).GetDataSet;
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetDisplayName: String;
begin
  if FName = '' then
    Result := inherited GetDisplayName
  else
    Result := FName;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsBoolean(const AValue: Boolean);
begin
  SetAsBooleans(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsBoolean: Boolean;
begin
  Result := GetAsBooleans(-1);
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsByte: String;
begin
  Result := GetAsBytes(-1);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsByte(const AValue: String);
begin
  SetAsBytes(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsVarByte(const AValue: String);
begin
  SetAsVarBytes(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsBooleans(AIndex: Integer; const AValue: Boolean);
begin
  FDataType := ftBoolean;
  Values[AIndex] := AValue;
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsBooleans(AIndex: Integer): Boolean;
var
  pVar: PVariant;
begin
  if IsNulls[AIndex] then
    Result := False
  else begin
    GetVarData(pVar, AIndex);
    Result := pVar^;
  end;
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsBytes(AIndex: Integer): String;
begin
  if IsNulls[AIndex] then
    Result := ''
  else begin
    SetLength(Result, GetDataSize(AIndex));
    GetBytesValue(AIndex, PChar(Result));
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsBytes(AIndex: Integer; const AValue: String);
begin
  FDataType := ftBytes;
  SetBytesValue(AIndex, PChar(AValue), Length(AValue));
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsVarBytes(AIndex: Integer; const AValue: String);
begin
  FDataType := ftVarBytes;
  SetBytesValue(AIndex, PChar(AValue), Length(AValue));
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsFloat(const AValue: Extended);
begin
  SetAsFloats(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsFloat: Extended;
begin
  Result := GetAsFloats(-1);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsFloats(AIndex: Integer; const AValue: Extended);
begin
  FDataType := ftFloat;
  Values[AIndex] := AValue;
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsFloats(AIndex: Integer): Extended;
var
  pVar: PVariant;
begin
  if IsNulls[AIndex] then
    Result := 0.0
  else begin
    GetVarData(pVar, AIndex);
    Result := pVar^;
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsCurrency(const AValue: Currency);
begin
  SetAsCurrencys(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsCurrency: Currency;
begin
  Result := GetAsCurrencys(-1);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsCurrencys(AIndex: Integer; const AValue: Currency);
begin
  FDataType := ftCurrency;
  Values[AIndex] := AValue;
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsCurrencys(AIndex: Integer): Currency;
var
  pVar: PVariant;
begin
  if IsNulls[AIndex] then
    Result := 0.0
  else begin
    GetVarData(pVar, AIndex);
    Result := pVar^;
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsBCD(const AValue: Currency);
begin
  SetAsBCDs(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsBCD: Currency;
begin
  Result := GetAsBCDs(-1);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsBCDs(AIndex: Integer; const AValue: Currency);
begin
  FDataType := ftBCD;
  Values[AIndex] := AValue;
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsBCDs(AIndex: Integer): Currency;
var
  pVar: PVariant;
begin
  if IsNulls[AIndex] then
    Result := 0.0
  else begin
    GetVarData(pVar, AIndex);
    Result := pVar^;
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsFMTBCD(const AValue: TADBcd);
begin
  SetAsFMTBCDs(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsFMTBCD: TADBcd;
begin
  Result := GetAsFMTBCDs(-1);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsFMTBCDs(AIndex: Integer; const AValue: TADBcd);
{$IFNDEF AnyDAC_D6}
var
  crVal: Currency;
{$ENDIF}
begin
{$IFDEF AnyDAC_D6}
  FDataType := ftFMTBCD;
  Values[AIndex] := VarFMTBcdCreate(AValue);
{$ELSE}
  crVal := 0.0;
  BCDToCurr(AValue, crVal);
  SetAsBCDs(AIndex, crVal);
{$ENDIF}
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsFMTBCDs(AIndex: Integer): TADBcd;
var
  pVar: PVariant;
{$IFNDEF AnyDAC_D6}
  crVal: Currency;
{$ENDIF}
begin
{$IFDEF AnyDAC_D6}
  if IsNulls[AIndex] then
    Result := NullBcd
  else begin
    GetVarData(pVar, AIndex);
    Result := VarToBcd(pVar^);
  end;
{$ELSE}
  if IsNulls[AIndex] then
    ADFillChar(Result, SizeOf(Result), #0)
  else begin
    GetVarData(pVar, AIndex);
    crVal := pVar^;
    CurrToBCD(crVal, Result);
  end;
{$ENDIF}
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsSQLTimeStamp(const AValue: TADSQLTimeStamp);
begin
  SetAsSQLTimeStamps(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsSQLTimeStamp: TADSQLTimeStamp;
begin
  Result := GetAsSQLTimeStamps(-1);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsSQLTimeStamps(AIndex: Integer; const AValue: TADSQLTimeStamp);
begin
{$IFDEF AnyDAC_D6}
  FDataType := ftTimeStamp;
  Values[AIndex] := VarSQLTimeStampCreate(AValue);
{$ELSE}
  SetAsDateTimes(AIndex, ADSQLTimeStampToDateTime(AValue));
{$ENDIF}
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsSQLTimeStamps(AIndex: Integer): TADSQLTimeStamp;
var
  pVar: PVariant;
begin
{$IFDEF AnyDAC_D6}
  if IsNulls[AIndex] then
    Result := NullSQLTimeStamp
  else begin
    GetVarData(pVar, AIndex);
    Result := VarToSQLTimeStamp(pVar^);
  end;
{$ELSE}
  if IsNulls[AIndex] then
    ADFillChar(Result, SizeOf(Result), #0)
  else begin
    GetVarData(pVar, AIndex);
    Result := ADDateTimeToSQLTimeStamp(pVar^);
  end;
{$ENDIF}
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsInteger(const AValue: Longint);
begin
  SetAsIntegers(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsInteger: Longint;
begin
  Result := GetAsIntegers(-1);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsIntegers(AIndex: Integer; const AValue: Longint);
begin
  FDataType := ftInteger;
  Values[AIndex] := AValue;
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsIntegers(AIndex: Integer): Longint;
var
  pVar: PVariant;
begin
  if IsNulls[AIndex] then
    Result := 0
  else begin
    GetVarData(pVar, AIndex);
    Result := pVar^;
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsWord(const AValue: LongInt);
begin
  SetAsWords(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsWords(AIndex: Integer; AValue: LongInt);
begin
  FDataType := ftWord;
  Values[AIndex] := AValue;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsSmallInt(const AValue: LongInt);
begin
  SetAsSmallInts(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsSmallInts(AIndex: Integer; const AValue: LongInt);
begin
  FDataType := ftSmallint;
  Values[AIndex] := AValue;
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsLargeInt: LargeInt;
begin
  Result := GetAsLargeInts(-1);
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsLargeInts(AIndex: Integer): LargeInt;
var
  pVar: PVariant;
{$IFNDEF AnyDAC_D6Base}
  iVal: Integer;
{$ENDIF}
begin
  if IsNulls[AIndex] then
    Result := 0
  else begin
    GetVarData(pVar, AIndex);
{$IFDEF AnyDAC_D6Base}
    Result := pVar^;
{$ELSE}
    if TVarData(pVar^).VType = varInt64 then
      Result := Decimal(pVar^).lo64
    else begin
      iVal := pVar^;
      Result := iVal;
    end;
{$ENDIF}
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsLargeInt(const AValue: LargeInt);
begin
  SetAsLargeInts(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsLargeInts(AIndex: Integer; const AValue: LargeInt);
{$IFNDEF AnyDAC_D6Base}
var
  v64: Variant;
{$ENDIF}
begin
  FDataType := ftLargeint;
{$IFDEF AnyDAC_D6Base}
  Values[AIndex] := AValue;
{$ELSE}
  TVarData(v64).VType := varInt64;
  Decimal(v64).lo64 := AValue;
  Values[AIndex] := v64;
{$ENDIF}
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsString(const AValue: String);
begin
  SetAsStrings(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsString: String;
begin
  Result := GetAsStrings(-1);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsStrings(AIndex: Integer; const AValue: String);
begin
  if FDataType <> ftFixedChar then
    FDataType := ftString;
  Values[AIndex] := AValue;
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsStrings(AIndex: Integer): String;
var
  pVar: PVariant;
begin
  if IsNulls[AIndex] then
    Result := ''
  else if DataType = ftBoolean then begin
    if Values[AIndex] then
      Result := S_AD_True
    else
      Result := S_AD_False;
  end
  else begin
    GetVarData(pVar, AIndex);
    Result := pVar^;
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsFixedChar(const AValue: String);
begin
  SetAsFixedChars(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsFixedChars(AIndex: Integer; const AValue: String);
begin
  if FDataType <> ftString then
    FDataType := ftFixedChar;
  Values[AIndex] := AValue;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsDate(const AValue: TDateTime);
begin
  SetAsDates(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsDates(AIndex: Integer; const AValue: TDateTime);
begin
  FDataType := ftDate;
  Values[AIndex] := AValue;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsTime(const AValue: TDateTime);
begin
  SetAsTimes(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsTimes(AIndex: Integer; const AValue: TDateTime);
begin
  FDataType := ftTime;
  Values[AIndex] := AValue;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsDateTime(const AValue: TDateTime);
begin
  SetAsDateTimes(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsDateTime: TDateTime;
begin
  Result := GetAsDateTimes(-1);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsDateTimes(AIndex: Integer; const AValue: TDateTime);
begin
  FDataType := ftDateTime;
  Values[AIndex] := AValue;
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsDateTimes(AIndex: Integer): TDateTime;
var
  pVar: PVariant;
begin
  if IsNulls[AIndex] then
    Result := 0.0
  else begin
    GetVarData(pVar, AIndex);
    Result := VarToDateTime(pVar^);
  end;
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetWideString: WideString;
begin
  Result := GetWideStrings(-1);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetWideString(const AValue: WideString);
begin
  SetWideStrings(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetWideStrings(AIndex: Integer): WideString;
var
  pVar: PVariant;
begin
  if IsNulls[AIndex] then
    Result := ''
  else begin
    GetVarData(pVar, AIndex);
    Result := pVar^;
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetWideStrings(AIndex: Integer; const AValue: WideString);
begin
  DataType := ftWideString;
  Values[AIndex] := AValue;
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsGUID: TGUID;
begin
  Result := GetAsGUIDs(-1);
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsGUIDs(AIndex: Integer): TGUID;
var
  pVar: PVariant;
begin
  if IsNulls[AIndex] then
    ADFillChar(Result, SizeOf(TGUID), #0)
  else begin
    GetVarData(pVar, AIndex);
    Result := StringToGUID(VarToStr(pVar^));
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsGUID(const AValue: TGUID);
begin
  SetAsGUIDs(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsGUIDs(AIndex: Integer; const AValue: TGUID);
begin
  DataType := ftGuid;
  Values[AIndex] := GUIDToString(AValue);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsVariant(const AValue: Variant);
begin
  SetAsVariants(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsVariants(AIndex: Integer; const AValue: Variant);
begin
  CheckIndex(AIndex);
  if (ArrayType = atScalar) then
    FBound := not VarIsEmpty(AValue)
  else
    FBound := True;
  if FDataType = ftUnknown then
    case VarType(AValue) of
{$IFDEF AnyDAC_D6Base}
      varShortInt,
{$ENDIF}
      varSmallint, varByte:
        FDataType := ftSmallInt;
{$IFDEF AnyDAC_D6Base}
      varWord, varLongWord,
{$ENDIF}
      varInteger:
        FDataType := ftInteger;
      varCurrency:
        FDataType := ftCurrency;
      varSingle, varDouble:
        FDataType := ftFloat;
      varDate:
        FDataType := ftDateTime;
      varBoolean:
        FDataType := ftBoolean;
      varString, varOleStr:
        if FDataType <> ftFixedChar then
          FDataType := ftString;
      varInt64:
        FDataType := ftLargeInt;
    else
{$IFDEF AnyDAC_D6}
      if VarType(AValue) = varSQLTimeStamp then
        FDataType := ftTimeStamp
      else if VarType(AValue) = varFMTBcd then
        FDataType := ftFMTBcd
      else
{$ENDIF}      
        FDataType := ftUnknown;
    end;
  if not (FDataType in [ftWideString, ftFmtMemo]) and (VarType(AValue) = varOleStr) then
    FValue[AIndex] := VarAsType(AValue, varString)
  else if (FDataType in [ftWideString, ftFmtMemo]) and (VarType(AValue) = varString) then
    FValue[AIndex] := VarAsType(AValue, varOleStr)
  else
    FValue[AIndex] := AValue;
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsVariant: Variant;
begin
  Result := GetAsVariants(-1);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.GetVarData(out AVar: PVariant; AIndex: Integer = -1);
begin
  CheckIndex(AIndex);
  AVar := @(FValue[AIndex]);
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsVariants(AIndex: Integer): Variant;
var
  pVar: PVariant;
  iLen: Integer;
  pRes, pSrc: Pointer;
begin
  GetVarData(pVar, AIndex);
  if VarType(pVar^) = (varArray or varByte) then begin
    iLen := VarArrayHighBound(pVar^, 1);
    Result := VarArrayCreate([0, iLen], varByte);
    pRes := VarArrayLock(Result);
    pSrc := VarArrayLock(pVar^);
    try
      ADMove(pSrc^, pRes^, iLen + 1);
    finally
      VarArrayUnlock(Result);
      VarArrayUnlock(pVar^);
    end;
  end
  else
    Result := pVar^;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsMemo(const AValue: String);
begin
  SetAsMemos(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsMemos(AIndex: Integer; const AValue: String);
begin
  if not (FDataType in [ftMemo, ftOraClob]) then
    FDataType := ftMemo;
  Values[AIndex] := AValue;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsBlob(const AValue: TBlobData);
begin
  SetAsBlobs(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsBlobs(AIndex: Integer; const AValue: TBlobData);
begin
  if not (FDataType in [ftBlob .. ftTypedBinary, ftOraBlob, ftOraClob]) then
    FDataType := ftBlob;
  Values[AIndex] := AValue;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsWideMemo(const AValue: WideString);
begin
  SetAsWideMemos(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsWideMemos(AIndex: Integer; const AValue: WideString);
begin
  FDataType := ftFmtMemo;
  Values[AIndex] := AValue;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetText(const AValue: String);
begin
  SetTexts(0, AValue);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetTexts(AIndex: Integer; const AValue: String);
begin
  Values[AIndex] := AValue;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.LoadFromFile(const FileName: String; BlobType: TBlobType;
  AIndex: Integer);
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead);
  try
    LoadFromStream(Stream, BlobType, AIndex);
  finally
    Stream.Free;
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.LoadFromStream(Stream: TStream; BlobType: TBlobType;
  AIndex: Integer);
var
  iLen: LongInt;
begin
  with Stream do begin
    FDataType := BlobType;
    Position := 0;
    iLen := Size;
    ReadBuffer(SetBlobRawData(iLen, nil, AIndex)^, iLen);
  end;
end;

{ ---------------------------------------------------------------------------- }
{$IFDEF AnyDAC_D6}
initialization

  VarTypeMap[ftTimeStamp] := VarSQLTimeStamp;
  VarTypeMap[ftFMTBcd] := VarFMTBcd;

{$ENDIF}

end.
