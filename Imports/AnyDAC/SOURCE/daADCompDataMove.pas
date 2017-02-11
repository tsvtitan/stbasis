{-------------------------------------------------------------------------------}
{ AnyDAC TADDataMove                                                            }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{ ----------------------------------------------------------------------------- }
{ Portions copyright:                                                           }
{ - Business Software Systems, Inc. 1995 - 2003.                                }
{   The idea is based on SQLDataPump unit of Freeware dbExpress Plus            }
{ ----------------------------------------------------------------------------- }
{$I daAD.inc}

unit daADCompDataMove;

interface

uses
{$IFDEF Win32}
  Windows,
{$ENDIF}
  SysUtils, Classes, DB,
  daADStanIntf, daADStanUtil,
  daADCompClient;

type
  TADAsciiField = class;
  TADAsciiFields = class;
  TADAsciiDataDef = class;
  TADMappingItem = class;
  TADMappings = class;
  TADDataMove = class;

  TADAsciiDataType = (atOther, atString, atFloat, atNumber, atBool, atLongInt,
    atDate, atTime, atDateTime, atBlob, atMemo);
  TADAsciiEndOfLine = (elWindows, elUnix, elMac);
  TADAsciiRecordFormat = (rfFixedLength, rfCommaDoubleQuote, rfFieldPerLine,
    rfTabDoubleQuote, rfCustom);

  TADDataSourceKind = (skDataSet, skAscii);
  TADDataMoveMode = (dmAlwaysInsert, dmAppend, dmUpdate, dmAppendUpdate, dmDelete);
  TADLogFileAction = (laNone, laCreate, laAppend);
  TADDataMovePhase = (psPreparing, psStarting, psProgress, psFinishing, psUnpreparing);
  TADDataMoveProgressEvent = procedure (ASender: TObject; APhase: TADDataMovePhase) of object;
  TADDataMoveFindDestRecordEvent = procedure (ASender: TObject; var AFound: Boolean) of object;
  TADDataMoveOption = (poOptimiseDest, poOptimiseSrc, poClearDest, poClearDestNoUndo,
    poAbortOnExc, poSrcFromCurRec);
  TADDataMoveOptions = set of TADDataMoveOption;

  // eaFail: write error to log, go to next record, if poAbortOnExc, then eaExitFailure
  // eaSkip: write error to log, go to next record
  // eaRetry: retry record
  // eaApplied: go to next record
  // eaDefault: ->> eaFail
  // eaExitSuccess: stop moving and exit
  // eaExitFailure: stop moving and reraise
  TADDataMoveErrorEvent = procedure (ASender: TObject; var AAction: TADErrorAction) of object;

  TADAsciiField = class(TCollectionItem)
  private
    FDataType: TADAsciiDataType;
    FFieldName: String;
    FFieldSize: Integer;
    FPrecision: Integer;
    procedure SetFieldName(const AValue: String);
  protected
    function GetDisplayName: String; override;
  public
    procedure Assign(ASource: TPersistent); override;
    procedure DefineAsField(AFld: TField);
  published
    property DataType: TADAsciiDataType read FDataType write FDataType;
    property FieldName: String read FFieldName write SetFieldName;
    property FieldSize: Integer read FFieldSize write FFieldSize;
    property Precision: Integer read FPrecision write FPrecision;
  end;

  TADAsciiFields = class(TCollection)
  private
    FDef: TADAsciiDataDef;
    function GetItem(AIndex: Integer): TADAsciiField;
    procedure SetItem(AIndex: Integer; const AValue: TADAsciiField);
    procedure CheckFieldName(AField: TADAsciiField; const ANewName: String);
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(ADef: TADAsciiDataDef);
    function Add: TADAsciiField;
    procedure AddAll;
    function FindField(const AName: String): TADAsciiField;
    function FieldByName(const AName: String): TADAsciiField;
    property Items[Index: Integer]: TADAsciiField read GetItem write SetItem; default;
  end;

  TADAsciiFormatSettingsValue = (
    fsCurrencyFormat, fsNegCurrFormat, fsThousandSeparator, fsDecimalSeparator,
    fsCurrencyDecimals, fsDateSeparator, fsTimeSeparator, fsCurrencyString,
    fsShortDateFormat, fsTimeAMString, fsTimePMString, fsShortTimeFormat,
    fsTwoDigitYearCenturyWindow);
  TADAsciiFormatSettingsValueSet = set of TADAsciiFormatSettingsValue;

{$IFNDEF AnyDAC_D7}
  TFormatSettings = record
    CurrencyFormat: Byte;
    NegCurrFormat: Byte;
    ThousandSeparator: Char;
    DecimalSeparator: Char;
    CurrencyDecimals: Byte;
    DateSeparator: Char;
    TimeSeparator: Char;
    ListSeparator: Char;
    CurrencyString: string;
    ShortDateFormat: string;
    LongDateFormat: string;
    TimeAMString: string;
    TimePMString: string;
    ShortTimeFormat: string;
    LongTimeFormat: string;
    ShortMonthNames: array[1..12] of string;
    LongMonthNames: array[1..12] of string;
    ShortDayNames: array[1..7] of string;
    LongDayNames: array[1..7] of string;
    TwoDigitYearCenturyWindow: Word;
  end;
{$ENDIF}

  TADAsciiFormatSettings = class(TPersistent)
  private
    FFS: TFormatSettings;
    FDataDef: TADAsciiDataDef;
    FValues: TADAsciiFormatSettingsValueSet;
    procedure SetCurrencyDecimals(const AValue: Byte);
    procedure SetCurrencyFormat(const AValue: Byte);
    procedure SetCurrencyString(const AValue: string);
    procedure SetDateSeparator(const AValue: Char);
    procedure SetDecimalSeparator(const AValue: Char);
    procedure SetNegCurrFormat(const AValue: Byte);
    procedure SetShortDateFormat(const AValue: string);
    procedure SetShortTimeFormat(const AValue: string);
    procedure SetThousandSeparator(const AValue: Char);
    procedure SetTimeAMString(const AValue: string);
    procedure SetTimePMString(const AValue: string);
    procedure SetTimeSeparator(const AValue: Char);
    procedure SetTwoDigitYearCenturyWindow(const AValue: Word);
    function IsCDS: Boolean;
    function IsCFS: Boolean;
    function IsCSS: Boolean;
    function IsDSS: Boolean;
    function IsDTSS: Boolean;
    function IsNCFS: Boolean;
    function IsSDFS: Boolean;
    function IsSTFS: Boolean;
    function IsTAMSS: Boolean;
    function IsTDYCWS: Boolean;
    function IsTMSS: Boolean;
    function IsTPMSS: Boolean;
    function IsTSS: Boolean;
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(ADef: TADAsciiDataDef);
    destructor Destroy; override;
    procedure Assign(ASource: TPersistent); override;
    property DataDef: TADAsciiDataDef read FDataDef;
  published
    property CurrencyFormat: Byte read FFS.CurrencyFormat write SetCurrencyFormat stored IsCFS;
    property NegCurrFormat: Byte read FFS.NegCurrFormat write SetNegCurrFormat stored IsNCFS;
    property ThousandSeparator: Char read FFS.ThousandSeparator write SetThousandSeparator stored IsTSS;
    property DecimalSeparator: Char read FFS.DecimalSeparator write SetDecimalSeparator stored IsDSS;
    property CurrencyDecimals: Byte read FFS.CurrencyDecimals write SetCurrencyDecimals stored IsCDS;
    property DateSeparator: Char read FFS.DateSeparator write SetDateSeparator stored IsDTSS;
    property TimeSeparator: Char read FFS.TimeSeparator write SetTimeSeparator stored IsTMSS;
    property CurrencyString: string read FFS.CurrencyString write SetCurrencyString stored IsCSS;
    property ShortDateFormat: string read FFS.ShortDateFormat write SetShortDateFormat stored IsSDFS;
    property TimeAMString: string read FFS.TimeAMString write SetTimeAMString stored IsTAMSS;
    property TimePMString: string read FFS.TimePMString write SetTimePMString stored IsTPMSS;
    property ShortTimeFormat: string read FFS.ShortTimeFormat write SetShortTimeFormat stored IsSTFS;
    property TwoDigitYearCenturyWindow: Word read FFS.TwoDigitYearCenturyWindow
      write SetTwoDigitYearCenturyWindow stored IsTDYCWS;
  end;

  TADAsciiDataDef = class(TPersistent)
  private
    FDataMove: TADDataMove;
    FFields: TADAsciiFields;
    FDelimiter: Char;
    FRecordDelimiter: TADAsciiEndOfLine;
    FRecordFormat: TADAsciiRecordFormat;
    FSeparator: Char;
    FWithFieldNames: Boolean;
    FFormatSettings: TADAsciiFormatSettings;
    procedure SetFields(const AValue: TADAsciiFields);
    procedure SetDelimiter(AValue: Char);
    procedure SetRecordFormat(AValue: TADAsciiRecordFormat);
    procedure SetSeparator(AValue: Char);
    function IsADDS: Boolean;
    procedure SetWithFieldNames(const AValue: Boolean);
    procedure SetFormatSettings(const AValue: TADAsciiFormatSettings);
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(ADataMove: TADDataMove);
    destructor Destroy; override;
    procedure Assign(ASource: TPersistent); override;
    property DataMove: TADDataMove read FDataMove;
  published
    property Fields: TADAsciiFields read FFields write SetFields;
    property Delimiter: Char read FDelimiter write SetDelimiter stored IsADDS;
    property Separator: Char read FSeparator write SetSeparator stored IsADDS;
    property EndOfLine: TADAsciiEndOfLine read FRecordDelimiter write FRecordDelimiter default elWindows;
    property RecordFormat: TADAsciiRecordFormat read FRecordFormat write SetRecordFormat default rfCommaDoubleQuote;
    property WithFieldNames: Boolean read FWithFieldNames write SetWithFieldNames default False;
    property FormatSettings: TADAsciiFormatSettings read FFormatSettings write SetFormatSettings;
  end;

  TADMappingItem = class(TCollectionItem)
  private
    FSourceExpression: String;
    FSourceFieldName: String;
    FDestinationFieldName: String;
    FDestField: TField;
    FDestValue: Variant;
    FSourceField: TField;
    FSourceAsciiField: TADAsciiField;
    FSourceEvaluator: IADStanExpressionEvaluator;
    FSourceValue: Variant;
    FInKey: Boolean;
    FDestAsciiField: TADAsciiField;
    function GetAsText: String;
    procedure SetAsText(const AValue: String);
    function GetItemValue: Variant;
  protected
    function GetDisplayName: String; override;
  public
    destructor Destroy; override;
    procedure Assign(ASource: TPersistent); override;
    procedure Prepare;
    procedure Unprepare;
    procedure Move;
    property DestField: TField read FDestField;
    property DestAsciiField: TADAsciiField read FDestAsciiField;
    property DestValue: Variant read FDestValue write FDestValue;
    property SourceField: TField read FSourceField;
    property SourceAsciiField: TADAsciiField read FSourceAsciiField;
    property SourceEvaluator: IADStanExpressionEvaluator read FSourceEvaluator;
    property SourceValue: Variant read FSourceValue write FSourceValue;
    property ItemValue: Variant read GetItemValue;
    property InKey: Boolean read FInKey;
    property AsText: String read GetAsText write SetAsText;
  published
    property SourceFieldName: String read FSourceFieldName write FSourceFieldName;
    property SourceExpression: String read FSourceExpression write FSourceExpression;
    property DestinationFieldName: String read FDestinationFieldName write FDestinationFieldName;
  end;

  TADMappings = class(TCollection)
  private
    FDataMove: TADDataMove;
    FMappingsAdded: Boolean;
    FAsciiFieldsAdded: Boolean;
    function GetItem(AIndex: Integer): TADMappingItem;
    procedure SetItem(AIndex: Integer; const AValue: TADMappingItem);
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(ADataMove: TADDataMove);
    function Add: TADMappingItem; overload;
    procedure Add(const AMapItem: String); overload;
    procedure AddAll;
    procedure Prepare;
    procedure Unprepare;
    procedure Move(AKeysOnly: Boolean);
    function IndexOfName(const AName: String): Integer;
    property Items[Index: Integer]: TADMappingItem read GetItem write SetItem; default;
    property DataMove: TADDataMove read FDataMove;
  end;

  TADDataMove = class(TADComponent)
  private
    FAsciiDataDef: TADAsciiDataDef;
    FAsciiFileName: String;
    FMappings: TADMappings;
    FLogFileAction: TADLogFileAction;
    FLogFileName: String;
    FSourceKind: TADDataSourceKind;
    FDestinationKind: TADDataSourceKind;
    FMode: TADDataMoveMode;
    FStatisticsInterval: LongInt;
    FCommitCount: LongInt;
    FDeleteCount: LongInt;
    FInsertCount: LongInt;
    FUpdateCount: LongInt;
    FReadCount: LongInt;
    FExceptionCount: LongInt;
    FSource: TDataSet;
    FDestination: TADAdaptedDataSet;
    FOnProgress: TADDataMoveProgressEvent;
    FOnFindDestRecord: TADDataMoveFindDestRecordEvent;
    FOptions: TADDataMoveOptions;
    FAborting: Boolean;
    FOnError: TADDataMoveErrorEvent;
    function FindDestRecord: Boolean;
    procedure SetMappings(const AValue: TADMappings);
    function GetWriteCount: LongInt;
    function ExecuteTableToTable: LongInt;
    function ExecuteTableToAscii: LongInt;
    function ExecuteAsciiToTable: LongInt;
    procedure SetAsciiDataDef(const AValue: TADAsciiDataDef);
    procedure SetDestination(const AValue: TADAdaptedDataSet);
    procedure SetSource(const AValue: TDataSet);
    procedure DoStatistic(APhase: TADDataMovePhase);
    function InitExceptionFile: TADFileStream;
    procedure ProcessException(E: Exception; AExcFS: TADFileStream;
      var AAction: TADErrorAction);
    procedure DeleteExceptionFile(AExcFS: TADFileStream);
    function SetupDestination: Boolean;
    function SetupSource: Boolean;
    procedure SetDestinationKind(const AValue: TADDataSourceKind);
    procedure SetSourceKind(const AValue: TADDataSourceKind);
    procedure SetMode(const AValue: TADDataMoveMode);
    procedure CheckAsciiSetup;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property ReadCount: LongInt read FReadCount;
    property InsertCount: LongInt read FInsertCount;
    property UpdateCount: LongInt read FUpdateCount;
    property DeleteCount: LongInt read FDeleteCount;
    property WriteCount: LongInt read GetWriteCount;
    property ExceptionCount: LongInt read FExceptionCount;
    function Execute: LongInt;
    procedure AbortJob;
  published
    property AsciiDataDef: TADAsciiDataDef read FAsciiDataDef write SetAsciiDataDef;
    property AsciiFileName: String read FAsciiFileName write FAsciiFileName;
    property Mappings: TADMappings read FMappings write SetMappings;
    property Options: TADDataMoveOptions read FOptions write FOptions
      default [poOptimiseDest, poOptimiseSrc, poAbortOnExc];
    property LogFileAction: TADLogFileAction read FLogFileAction write FLogFileAction default laNone;
    property LogFileName: String read FLogFileName write FLogFileName;
    property CommitCount: LongInt read FCommitCount write FCommitCount default 100;
    property Mode: TADDataMoveMode read FMode write SetMode default dmAlwaysInsert;
    property StatisticsInterval: LongInt read FStatisticsInterval write FStatisticsInterval default 100;
    property SourceKind: TADDataSourceKind read FSourceKind write SetSourceKind default skDataSet;
    property DestinationKind: TADDataSourceKind read FDestinationKind write SetDestinationKind default skDataSet;
    property Source: TDataSet read FSource write SetSource;
    property Destination: TADAdaptedDataSet read FDestination write SetDestination;
    property OnProgress: TADDataMoveProgressEvent read FOnProgress write FOnProgress;
    property OnFindDestRecord: TADDataMoveFindDestRecordEvent read FOnFindDestRecord write FOnFindDestRecord;
    property OnError: TADDataMoveErrorEvent read FOnError write FOnError;
  end;

implementation

uses
{$IFDEF AnyDAC_D6Base}
  Variants,
{$ELSE}
  ActiveX, ComObj,   
{$ENDIF}
  daADStanOption, daADStanError, daADStanConst, daADStanFactory, daADStanResStrs,
  daADGUIxIntf;

type
  TADDataMoveAction = (paSkip, paInsert, paUpdate, paDelete, paAlwaysInsert);

{-------------------------------------------------------------------------------}
{ TADAsciiField                                                                 }
{-------------------------------------------------------------------------------}
procedure TADAsciiField.Assign(ASource: TPersistent);
begin
  if ASource is TADAsciiField then begin
    DataType := TADAsciiField(ASource).DataType;
    FieldName := TADAsciiField(ASource).FieldName;
    FieldSize := TADAsciiField(ASource).FieldSize;
  end
  else
    inherited Assign(ASource);
end;

{-------------------------------------------------------------------------------}
procedure TADAsciiField.SetFieldName(const AValue: String);
begin
  if FFieldName <> AValue then begin
    TADAsciiFields(Collection).CheckFieldName(Self, AValue);
    FFieldName := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
function TADAsciiField.GetDisplayName: string;
begin
  Result := FieldName;
  if Result = '' then
    Result := inherited GetDisplayName;
end;

{-------------------------------------------------------------------------------}
procedure TADAsciiField.DefineAsField(AFld: TField);
begin
  case AFld.DataType of
  ftBoolean:
    begin
      DataType := atBool;
      FieldSize := 1;
    end;
  ftString,
  ftFixedChar,
  ftWideString:
    begin
      DataType := atString;
      FieldSize := AFld.Size;
    end;
  ftSmallint:
    begin
      DataType := atNumber;
      FieldSize := 6;
    end;
  ftInteger:
    begin
      DataType := atLongInt;
      FieldSize := 11;
    end;
  ftWord:
    begin
      DataType := atNumber;
      FieldSize := 5;
    end;
  ftFloat:
    begin
      DataType := atFloat;
      Precision := TFloatField(AFld).Precision;
      if Precision > 0 then
        FieldSize := Precision + 2
      else
        FieldSize := 18;
    end;
  ftCurrency:
    begin
      DataType := atFloat;
      Precision := TCurrencyField(AFld).Precision;
      if Precision > 0 then
        FieldSize := Precision + 2
      else
        FieldSize := 22;
    end;
  ftAutoInc:
    begin
      DataType := atLongInt;
      FieldSize := 11;
    end;
  ftLargeint:
    begin
      DataType := atLongInt;
      FieldSize := 21;
    end;
  ftBCD:
    begin
      DataType := atFloat;
      Precision := TBCDField(AFld).Precision;
      if Precision > 0 then
        FieldSize := Precision + 2
      else
        FieldSize := 18;
    end;
{$IFDEF AnyDAC_D6}
  ftFMTBcd:
    begin
      DataType := atFloat;
      Precision := TFMTBCDField(AFld).Precision;
      if Precision > 0 then
        FieldSize := Precision + 2
      else
        FieldSize := 38;
    end;
{$ENDIF}
  ftDate:
    begin
      DataType := atDate;
      FieldSize := 16;
    end;
  ftTime:
    begin
      DataType := atTime;
      FieldSize := 11;
    end;
{$IFDEF AnyDAC_D6}
  ftTimeStamp,
{$ENDIF}
  ftDateTime:
    begin
      DataType := atDateTime;
      FieldSize := 27;
    end;
  ftMemo,
  ftOraClob,
  ftFmtMemo:
    begin
      DataType := atMemo;
      FieldSize := -1;
    end;
  ftBlob,
  ftOraBlob:
    begin
      DataType := atBlob;
      FieldSize := -1;
    end;
  ftBytes,
  ftVarBytes:
    begin
      DataType := atBlob;
      FieldSize := AFld.Size;
    end;
  else
    DataType := atOther;
    FieldSize := 100;
  end;
  FieldName := AFld.FieldName;
end;

{-------------------------------------------------------------------------------}
{ TADAsciiFields                                                                }
{-------------------------------------------------------------------------------}
constructor TADAsciiFields.Create(ADef: TADAsciiDataDef);
begin
  inherited Create(TADAsciiField);
  FDef := ADef;
end;

{-------------------------------------------------------------------------------}
function TADAsciiFields.GetItem(AIndex: Integer): TADAsciiField;
begin
  Result := TADAsciiField(inherited GetItem(AIndex));
end;

{-------------------------------------------------------------------------------}
procedure TADAsciiFields.SetItem(AIndex: Integer; const AValue: TADAsciiField);
begin
  inherited SetItem(AIndex, AValue);
end;

{-------------------------------------------------------------------------------}
function TADAsciiFields.GetOwner: TPersistent;
begin
  Result := FDef;
end;

{-------------------------------------------------------------------------------}
function TADAsciiFields.Add: TADAsciiField;
begin
  Result := TADAsciiField(inherited Add);
end;

{-------------------------------------------------------------------------------}
procedure TADAsciiFields.AddAll;
var
  oDS: TDataSet;
  i: Integer;
begin
  if FDef.FDataMove.SourceKind = skDataSet then
    oDS := FDef.FDataMove.Source
  else if FDef.FDataMove.DestinationKind = skDataSet then
    oDS := FDef.FDataMove.Destination
  else
    oDS := nil;
  if oDS = nil then
    Exit;
  oDS.Active := True;
  Clear;
  for i := 0 to oDS.Fields.Count - 1 do
    Add.DefineAsField(oDS.Fields[i]);
end;

{-------------------------------------------------------------------------------}
function TADAsciiFields.FindField(const AName: String): TADAsciiField;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
    if AnsiCompareText(AName, Items[i].FieldName) = 0 then begin
      Result := Items[i];
      Break;
    end;
end;

{-------------------------------------------------------------------------------}
function TADAsciiFields.FieldByName(const AName: String): TADAsciiField;
begin
  Result := FindField(AName);
  if Result = nil then
    ADException(FDef.FDataMove, [S_AD_LComp, S_AD_LComp_PDM], er_AD_DPNoAscFld, [AName]);
end;

{-------------------------------------------------------------------------------}
procedure TADAsciiFields.CheckFieldName(AField: TADAsciiField; const ANewName: String);
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    if (Items[i] <> AField) and (AnsiCompareText(Items[i].FieldName, ANewName) = 0) then
      ADException(FDef.FDataMove, [S_AD_LComp, S_AD_LComp_PDM], er_AD_DPAscFldDup, [ANewName]);
end;

{-------------------------------------------------------------------------------}
{ TADAsciiFormatSettings                                                        }
{-------------------------------------------------------------------------------}
constructor TADAsciiFormatSettings.Create(ADef: TADAsciiDataDef);
var
  i: Integer;
begin
  inherited Create;
  FDataDef := ADef;
  FFS.CurrencyFormat := SysUtils.CurrencyFormat;
  FFS.NegCurrFormat := SysUtils.NegCurrFormat;
  FFS.ThousandSeparator := SysUtils.ThousandSeparator;
  FFS.DecimalSeparator := SysUtils.DecimalSeparator;
  FFS.CurrencyDecimals := SysUtils.CurrencyDecimals;
  FFS.DateSeparator := SysUtils.DateSeparator;
  FFS.TimeSeparator := SysUtils.TimeSeparator;
  FFS.ListSeparator := SysUtils.ListSeparator;
  FFS.CurrencyString := SysUtils.CurrencyString;
  FFS.ShortDateFormat := SysUtils.ShortDateFormat;
  FFS.LongDateFormat := SysUtils.LongDateFormat;
  FFS.TimeAMString := SysUtils.TimeAMString;
  FFS.TimePMString := SysUtils.TimePMString;
  FFS.ShortTimeFormat := SysUtils.ShortTimeFormat;
  FFS.LongTimeFormat := SysUtils.LongTimeFormat;
  for i := 1 to 12 do
    FFS.ShortMonthNames[i] := SysUtils.ShortMonthNames[i];
  for i := 1 to 12 do
    FFS.LongMonthNames[i] := SysUtils.LongMonthNames[i];
  for i := 1 to 7 do
    FFS.ShortDayNames[i] := SysUtils.ShortDayNames[i];
  for i := 1 to 7 do
    FFS.LongDayNames[i] := SysUtils.LongDayNames[i];
  FFS.TwoDigitYearCenturyWindow := SysUtils.TwoDigitYearCenturyWindow;
  FValues := [];
end;

{-------------------------------------------------------------------------------}
destructor TADAsciiFormatSettings.Destroy;
begin
  FDataDef := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADAsciiFormatSettings.GetOwner: TPersistent;
begin
  Result := FDataDef;
end;

{-------------------------------------------------------------------------------}
procedure TADAsciiFormatSettings.Assign(ASource: TPersistent);
begin
  if ASource is TADAsciiFormatSettings then begin
    FFS := TADAsciiFormatSettings(ASource).FFS;
    FValues := TADAsciiFormatSettings(ASource).FValues;
  end
  else
    inherited Assign(ASource);
end;

{-------------------------------------------------------------------------------}
procedure TADAsciiFormatSettings.SetCurrencyDecimals(const AValue: Byte);
begin
  if FFS.CurrencyDecimals <> AValue then begin
    FFS.CurrencyDecimals := AValue;
    Include(FValues, fsCurrencyDecimals);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAsciiFormatSettings.SetCurrencyFormat(const AValue: Byte);
begin
  if FFS.CurrencyFormat <> AValue then begin
    FFS.CurrencyFormat := AValue;
    Include(FValues, fsCurrencyFormat);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAsciiFormatSettings.SetCurrencyString(const AValue: string);
begin
  if FFS.CurrencyString <> AValue then begin
    FFS.CurrencyString := AValue;
    Include(FValues, fsCurrencyString);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAsciiFormatSettings.SetDateSeparator(const AValue: Char);
begin
  if FFS.DateSeparator <> AValue then begin
    FFS.DateSeparator := AValue;
    Include(FValues, fsDateSeparator);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAsciiFormatSettings.SetDecimalSeparator(const AValue: Char);
begin
  if FFS.DecimalSeparator <> AValue then begin
    FFS.DecimalSeparator := AValue;
    Include(FValues, fsDateSeparator);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAsciiFormatSettings.SetNegCurrFormat(const AValue: Byte);
begin
  if FFS.NegCurrFormat <> AValue then begin
    FFS.NegCurrFormat := AValue;
    Include(FValues, fsNegCurrFormat);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAsciiFormatSettings.SetShortDateFormat(const AValue: string);
begin
  if FFS.ShortDateFormat <> AValue then begin
    FFS.ShortDateFormat := AValue;
    Include(FValues, fsShortDateFormat);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAsciiFormatSettings.SetShortTimeFormat(const AValue: string);
begin
  if FFS.ShortTimeFormat <> AValue then begin
    FFS.ShortTimeFormat := AValue;
    Include(FValues, fsShortTimeFormat);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAsciiFormatSettings.SetThousandSeparator(const AValue: Char);
begin
  if FFS.ThousandSeparator <> AValue then begin
    FFS.ThousandSeparator := AValue;
    Include(FValues, fsThousandSeparator);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAsciiFormatSettings.SetTimeAMString(const AValue: string);
begin
  if FFS.TimeAMString <> AValue then begin
    FFS.TimeAMString := AValue;
    Include(FValues, fsTimeAMString);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAsciiFormatSettings.SetTimePMString(const AValue: string);
begin
  if FFS.TimePMString <> AValue then begin
    FFS.TimePMString := AValue;
    Include(FValues, fsTimePMString);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAsciiFormatSettings.SetTimeSeparator(const AValue: Char);
begin
  if FFS.TimeSeparator <> AValue then begin
    FFS.TimeSeparator := AValue;
    Include(FValues, fsTimeSeparator);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAsciiFormatSettings.SetTwoDigitYearCenturyWindow(
  const AValue: Word);
begin
  if FFS.TwoDigitYearCenturyWindow <> AValue then begin
    FFS.TwoDigitYearCenturyWindow := AValue;
    Include(FValues, fsTwoDigitYearCenturyWindow);
  end;
end;

{-------------------------------------------------------------------------------}
function TADAsciiFormatSettings.IsCDS: Boolean;
begin
  Result := fsCurrencyDecimals in FValues;
end;

{-------------------------------------------------------------------------------}
function TADAsciiFormatSettings.IsCFS: Boolean;
begin
  Result := fsCurrencyFormat in FValues;
end;

{-------------------------------------------------------------------------------}
function TADAsciiFormatSettings.IsCSS: Boolean;
begin
  Result := fsCurrencyString in FValues;
end;

{-------------------------------------------------------------------------------}
function TADAsciiFormatSettings.IsDSS: Boolean;
begin
  Result := fsDecimalSeparator in FValues;
end;

{-------------------------------------------------------------------------------}
function TADAsciiFormatSettings.IsDTSS: Boolean;
begin
  Result := fsDateSeparator in FValues;
end;

{-------------------------------------------------------------------------------}
function TADAsciiFormatSettings.IsNCFS: Boolean;
begin
  Result := fsNegCurrFormat in FValues;
end;

{-------------------------------------------------------------------------------}
function TADAsciiFormatSettings.IsSDFS: Boolean;
begin
  Result := fsShortDateFormat in FValues;
end;

{-------------------------------------------------------------------------------}
function TADAsciiFormatSettings.IsSTFS: Boolean;
begin
  Result := fsShortTimeFormat in FValues;
end;

{-------------------------------------------------------------------------------}
function TADAsciiFormatSettings.IsTAMSS: Boolean;
begin
  Result := fsTimeAMString in FValues;
end;

{-------------------------------------------------------------------------------}
function TADAsciiFormatSettings.IsTDYCWS: Boolean;
begin
  Result := fsTwoDigitYearCenturyWindow in FValues;
end;

{-------------------------------------------------------------------------------}
function TADAsciiFormatSettings.IsTMSS: Boolean;
begin
  Result := fsTimeSeparator in FValues;
end;

{-------------------------------------------------------------------------------}
function TADAsciiFormatSettings.IsTPMSS: Boolean;
begin
  Result := fsTimePMString in FValues;
end;

{-------------------------------------------------------------------------------}
function TADAsciiFormatSettings.IsTSS: Boolean;
begin
  Result := fsThousandSeparator in FValues;
end;

{-------------------------------------------------------------------------------}
{ TADAsciiDataDef                                                               }
{-------------------------------------------------------------------------------}
constructor TADAsciiDataDef.Create(ADataMove: TADDataMove);
begin
  inherited Create;
  FDataMove := ADataMove;
  FFields := TADAsciiFields.Create(Self);
  FDelimiter := #34;
  FSeparator := #59;
  FRecordFormat := rfCommaDoubleQuote;
  FRecordDelimiter := elWindows;
  FWithFieldNames := False;
  FFormatSettings := TADAsciiFormatSettings.Create(Self);
end;

{-------------------------------------------------------------------------------}
destructor TADAsciiDataDef.Destroy;
begin
  FreeAndNil(FFields);
  FreeAndNil(FFormatSettings);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADAsciiDataDef.GetOwner: TPersistent;
begin
  Result := FDataMove;
end;

{-------------------------------------------------------------------------------}
procedure TADAsciiDataDef.Assign(ASource: TPersistent);
begin
  if ASource is TADAsciiDataDef then begin
    EndOfLine := TADAsciiDataDef(ASource).EndOfLine;
    Delimiter := TADAsciiDataDef(ASource).Delimiter;
    Separator := TADAsciiDataDef(ASource).Separator;
    RecordFormat := TADAsciiDataDef(ASource).RecordFormat;
    Fields := TADAsciiDataDef(ASource).Fields;
    WithFieldNames := TADAsciiDataDef(ASource).WithFieldNames;
    FormatSettings.Assign(TADAsciiDataDef(ASource).FormatSettings);
  end
  else
    inherited Assign(ASource);
end;

{-------------------------------------------------------------------------------}
procedure TADAsciiDataDef.SetFields(const AValue: TADAsciiFields);
begin
  FFields.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADAsciiDataDef.SetDelimiter(AValue: Char);
begin
  if FDelimiter <> AValue then begin
    RecordFormat := rfCustom;
    FDelimiter := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAsciiDataDef.SetSeparator(AValue: Char);
begin
  if FSeparator <> AValue then begin
    RecordFormat := rfCustom;
    FSeparator := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAsciiDataDef.SetRecordFormat(AValue: TADAsciiRecordFormat);
begin
  if FRecordFormat <> AValue then begin
    FRecordFormat := AValue;
    case AValue of
    rfCommaDoubleQuote:
      begin
        FDelimiter := #34;
        FSeparator := #59;
      end;
    rfTabDoubleQuote:
      begin
        FDelimiter := #34;
        FSeparator := #9;
      end;
    rfFixedLength:
      begin
        FDelimiter := #34;
        FSeparator := #0;
        FWithFieldNames := False;
      end;
    rfFieldPerLine:
      begin
        FDelimiter := #0;
        FSeparator := #0;
        FWithFieldNames := False;
      end;
    else
      FDelimiter := #34;
      FSeparator := #59;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADAsciiDataDef.IsADDS: Boolean;
begin
  Result := (FRecordFormat = rfCustom);
end;

{-------------------------------------------------------------------------------}
procedure TADAsciiDataDef.SetWithFieldNames(const AValue: Boolean);
begin
  if FWithFieldNames <> AValue then begin
    FWithFieldNames := AValue;
    if FWithFieldNames and (RecordFormat in [rfFixedLength, rfFieldPerLine]) then
      RecordFormat := rfCommaDoubleQuote;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAsciiDataDef.SetFormatSettings(const AValue: TADAsciiFormatSettings);
begin
  FFormatSettings.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
{ TADMappingItemExpressionDS                                                    }
{-------------------------------------------------------------------------------}
type
  TADMappingItemExpressionDS = class(TInterfacedObject, IADStanExpressionDataSource)
  private
    FMappings: TADMappings;
    FDataMove: TADDataMove;
  protected
    // IADStanExpressionDataSource
    function GetVarIndex(const AName: String): Integer;
    function GetVarType(AIndex: Integer): TADDataType;
    function GetVarScope(AIndex: Integer): TADExpressionScopeKind;
    function GetVarData(AIndex: Integer): Variant;
    procedure SetVarData(AIndex: Integer; const AValue: Variant);
    function GetSubAggregateValue(AIndex: Integer): Variant; virtual;
    function GetPosition: Pointer;
    procedure SetPosition(AValue: Pointer);
    function GetRowNum: Integer;
  public
    constructor Create(AMappings: TADMappings);
  end;

{-------------------------------------------------------------------------------}
constructor TADMappingItemExpressionDS.Create(AMappings: TADMappings);
begin
  inherited Create;
  FMappings := AMappings;
  FDataMove := AMappings.DataMove;
end;

{-------------------------------------------------------------------------------}
function TADMappingItemExpressionDS.GetPosition: Pointer;
begin
  Result := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADMappingItemExpressionDS.SetPosition(AValue: Pointer);
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
function TADMappingItemExpressionDS.GetRowNum: Integer;
begin
  Result := 0;
end;

{-------------------------------------------------------------------------------}
function TADMappingItemExpressionDS.GetSubAggregateValue(AIndex: Integer): Variant;
begin
  Result := Unassigned;
  ADCapabilityNotSupported(Self, [S_AD_LComp, S_AD_LComp_PDM]);
end;

{-------------------------------------------------------------------------------}
function TADMappingItemExpressionDS.GetVarIndex(const AName: String): Integer;
begin
  Result := FMappings.IndexOfName(AName);
end;

{-------------------------------------------------------------------------------}
function TADMappingItemExpressionDS.GetVarType(AIndex: Integer): TADDataType;
const
  ADT2ADDT: array[TADAsciiDataType] of TADDataType = (dtAnsiString, dtAnsiString,
    dtDouble, dtFmtBCD, dtBoolean, dtInt32, dtDate, dtTime, dtDateTime, dtBlob, dtMemo);
var
  iScale, iPrec: Integer;
  iSize: LongWord;
  eAttrs: TADDataAttributes;
begin
  with FMappings.Items[AIndex], FDataMove do
    if SourceExpression <> '' then
      if DestinationKind = skAscii then
        Result := ADT2ADDT[AsciiDataDef.Fields.FieldByName(DestinationFieldName).DataType]
      else begin
        Result := dtUnknown;
        iScale := 0;
        iPrec := 0;
        iSize := 0;
        eAttrs := [];
        TADFormatOptions.FieldDef2ColumnDef(Destination.FieldByName(DestinationFieldName).DataType,
          0, 0, Result, iScale, iPrec, iSize, eAttrs);
      end
    else if SourceFieldName <> '' then
      if SourceKind = skAscii then
        Result := ADT2ADDT[AsciiDataDef.Fields.FieldByName(SourceFieldName).DataType]
      else begin
        Result := dtUnknown;
        iScale := 0;
        iPrec := 0;
        iSize := 0;
        eAttrs := [];
        TADFormatOptions.FieldDef2ColumnDef(Source.FieldByName(SourceFieldName).DataType,
          0, 0, Result, iScale, iPrec, iSize, eAttrs);
      end;
end;

{-------------------------------------------------------------------------------}
function TADMappingItemExpressionDS.GetVarScope(AIndex: Integer): TADExpressionScopeKind;
begin
  Result := ckField;
end;

{-------------------------------------------------------------------------------}
function TADMappingItemExpressionDS.GetVarData(AIndex: Integer): Variant;
begin
  Result := FMappings.Items[AIndex].ItemValue;
end;

{-------------------------------------------------------------------------------}
procedure TADMappingItemExpressionDS.SetVarData(AIndex: Integer; const AValue: Variant);
begin
  ADCapabilityNotSupported(Self, [S_AD_LComp, S_AD_LComp_PDM]);
end;

{-------------------------------------------------------------------------------}
{ TADMappingItem                                                                }
{-------------------------------------------------------------------------------}
destructor TADMappingItem.Destroy;
begin
  Unprepare;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADMappingItem.Assign(ASource: TPersistent);
begin
  if ASource is TADMappingItem then begin
    SourceFieldName := TADMappingItem(ASource).SourceFieldName;
    SourceExpression := TADMappingItem(ASource).SourceExpression;
    DestinationFieldName := TADMappingItem(ASource).DestinationFieldName;
  end
  else
    inherited Assign(ASource);
end;

{-------------------------------------------------------------------------------}
function TADMappingItem.GetDisplayName: string;
begin
  Result := SourceFieldName;
  if Result = '' then
    Result := SourceExpression;
  if (Result <> '') or (DestinationFieldName <> '') then
    Result := Result + '->';
  Result := Result + DestinationFieldName;
  if Result = '' then
    Result := inherited GetDisplayName;
end;

{-------------------------------------------------------------------------------}
procedure TADMappingItem.Prepare;
var
  oParser: IADStanExpressionParser;
  iDestInd: Integer;
begin
  with TADMappings(Collection).FDataMove do begin
    if DestinationKind = skAscii then begin
      if DestinationFieldName <> '' then
        FDestAsciiField := AsciiDataDef.Fields.FieldByName(DestinationFieldName)
      else
        FDestAsciiField := AsciiDataDef.Fields[Index];
      iDestInd := FDestAsciiField.Index;
    end
    else begin
      if DestinationFieldName <> '' then
        FDestField := Destination.FieldByName(DestinationFieldName)
      else
        FDestField := Destination.Fields[Index];
//      if FDestField.ReadOnly
      iDestInd := FDestField.Index;
      FInKey := pfInKey in FDestField.ProviderFlags;
    end;
    if SourceExpression <> '' then begin
      ADCreateInterface(IADStanExpressionParser, oParser);
      FSourceEvaluator := oParser.Prepare(
        TADMappingItemExpressionDS.Create(TADMappings(Collection)),
        SourceExpression, [], [poDefaultExpr], '');
    end
    else if SourceFieldName <> '' then
      if SourceKind = skAscii then
        FSourceAsciiField := AsciiDataDef.Fields.FieldByName(SourceFieldName)
      else
        FSourceField := Source.FieldByName(SourceFieldName)
    else
      try
        if SourceKind = skAscii then
          FSourceAsciiField := AsciiDataDef.Fields[iDestInd]
        else
          FSourceField := Source.Fields[iDestInd];
      except
        ADException(TADMappings(Collection).FDataMove, [S_AD_LComp, S_AD_LComp_PDM],
          er_AD_DPSrcUndefined, [DestinationFieldName]);
      end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADMappingItem.Unprepare;
begin
  FDestField := nil;
  FDestAsciiField := nil;
  FDestValue := Unassigned;
  FSourceField := nil;
  FSourceAsciiField := nil;
  FSourceEvaluator := nil;
  FSourceValue := Unassigned;
end;

{-------------------------------------------------------------------------------}
function TADMappingItem.GetItemValue: Variant;
begin
  if FSourceEvaluator <> nil then
    Result := FSourceEvaluator.Evaluate
  else if FSourceAsciiField <> nil then
    Result := FSourceValue
  else if FSourceField <> nil then
    Result := FSourceField.Value
  else
    Result := Null;
end;

{-------------------------------------------------------------------------------}
procedure TADMappingItem.Move;
var
  V: Variant;
begin
  if FDestAsciiField <> nil then
    FDestValue := ItemValue
  else if FSourceField <> nil then
    FDestField.Assign(FSourceField)
  else begin
    V := ItemValue;
    if VarIsNull(V) then
      FDestField.Clear
    else if FDestField is TBinaryField then
      FDestField.AsString := V
    else if FDestField is TLargeintField then begin
{$IFDEF AnyDAC_D6Base}
      TLargeintField(FDestField).AsLargeInt := V;
{$ELSE}
      if TVarData(V).VType = varInt64 then
        TLargeintField(FDestField).AsLargeInt := Decimal(V).lo64
      else
        TLargeintField(FDestField).AsFloat := V;
{$ENDIF}
    end
    else begin
{$IFDEF AnyDAC_D6Base}
      FDestField.Value := V;
{$ELSE}
      if TVarData(V).VType = varInt64 then
        if Decimal(V).lo64 <= MAXINT then
          FDestField.AsInteger := Decimal(V).lo64
        else
          FDestField.AsFloat := Decimal(V).lo64
      else
        FDestField.Value := V;
{$ENDIF}
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADMappingItem.GetAsText: String;
begin
  if DestinationFieldName = SourceFieldName then
    Result := DestinationFieldName
  else
    Result := DestinationFieldName + '=' + SourceFieldName;
end;

{-------------------------------------------------------------------------------}
procedure TADMappingItem.SetAsText(const AValue: String);
var
  i: Integer;
begin
  i := Pos('=', AValue);
  if i <> 0 then begin
    DestinationFieldName := Copy(AValue, 1, i - 1);
    SourceFieldName := Copy(AValue, i + 1, Length(AValue));
  end
  else begin
    DestinationFieldName := AValue;
    SourceFieldName := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADMappings                                                                   }
{-------------------------------------------------------------------------------}
constructor TADMappings.Create(ADataMove: TADDataMove);
begin
  inherited Create(TADMappingItem);
  FDataMove := ADataMove;
end;

{-------------------------------------------------------------------------------}
function TADMappings.GetItem(AIndex: Integer): TADMappingItem;
begin
  Result := TADMappingItem(inherited GetItem(AIndex));
end;

{-------------------------------------------------------------------------------}
function TADMappings.GetOwner: TPersistent;
begin
  Result := FDataMove;
end;

{-------------------------------------------------------------------------------}
procedure TADMappings.SetItem(AIndex: Integer; const AValue: TADMappingItem);
begin
  inherited SetItem(AIndex, AValue);
end;

{-------------------------------------------------------------------------------}
function TADMappings.Add: TADMappingItem;
begin
  Result := TADMappingItem(inherited Add);
end;

{-------------------------------------------------------------------------------}
procedure TADMappings.Add(const AMapItem: String);
begin
  Add.AsText := AMapItem;
end;

{-------------------------------------------------------------------------------}
procedure TADMappings.AddAll;
var
  oDestDS, oSrcDS: TDataSet;
  oItem: TADMappingItem;
  oDestFld, oSrcFld: TField;
  oDestAscFld, oSrcAscFld: TADAsciiField;
  i: Integer;
begin
  Clear;
  if (FDataMove.SourceKind = skDataSet) and
     (FDataMove.DestinationKind = skDataSet) then begin
    oSrcDS := FDataMove.Source;
    oSrcDS.Active := True;
    oDestDS := FDataMove.Destination;
    oDestDS.Active := True;
    for i := 0 to oDestDS.Fields.Count - 1 do begin
      oDestFld := oDestDS.Fields[i];
      oSrcFld := oSrcDS.FindField(oDestFld.FieldName);
      oItem := Add;
      oItem.DestinationFieldName := oDestFld.FieldName;
      if oSrcFld <> nil then
        oItem.SourceFieldName := oSrcFld.FieldName;
    end;
  end
  else if (FDataMove.SourceKind = skDataSet) and
          (FDataMove.DestinationKind = skAscii) then begin
    oSrcDS := FDataMove.Source;
    oSrcDS.Active := True;
    for i := 0 to FDataMove.AsciiDataDef.Fields.Count - 1 do begin
      oDestAscFld := FDataMove.AsciiDataDef.Fields[i];
      oSrcFld := oSrcDS.FindField(oDestAscFld.FieldName);
      oItem := Add;
      oItem.DestinationFieldName := oDestAscFld.FieldName;
      if oSrcFld <> nil then
        oItem.SourceFieldName := oSrcFld.FieldName;
    end;
  end
  else if (FDataMove.SourceKind = skAscii) and
          (FDataMove.DestinationKind = skDataSet) then begin
    oDestDS := FDataMove.Destination;
    oDestDS.Active := True;
    for i := 0 to oDestDS.Fields.Count - 1 do begin
      oDestFld := oDestDS.Fields[i];
      oSrcAscFld := FDataMove.AsciiDataDef.Fields.FindField(oDestFld.FieldName);
      oItem := Add;
      oItem.DestinationFieldName := oDestFld.FieldName;
      if oSrcAscFld <> nil then
        oItem.SourceFieldName := oSrcAscFld.FieldName;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADMappings.Prepare;
var
  i: Integer;
begin
  try
    if FDataMove.AsciiDataDef.Fields.Count = 0 then begin
      FAsciiFieldsAdded := True;
      FDataMove.AsciiDataDef.Fields.AddAll;
    end;
    if Count = 0 then begin
      FMappingsAdded := True;
      AddAll;
    end;
    for i := 0 to Count - 1 do
      Items[i].Prepare;
  except
    Unprepare;
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADMappings.Unprepare;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    Items[i].Unprepare;
  if FMappingsAdded then begin
    Clear;
    FMappingsAdded := False;
  end;
  if FAsciiFieldsAdded then begin
    FDataMove.AsciiDataDef.Fields.Clear;
    FAsciiFieldsAdded := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADMappings.Move(AKeysOnly: Boolean);
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    with Items[i] do
      if not AKeysOnly or InKey then
        Move;
end;

{-------------------------------------------------------------------------------}
function TADMappings.IndexOfName(const AName: String): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Count - 1 do
    if AnsiCompareText(Items[i].DestinationFieldName, AName) = 0 then begin
      Result := i;
      Break;
    end;
end;

{-------------------------------------------------------------------------------}
{ TADDataMove                                                                   }
{-------------------------------------------------------------------------------}
constructor TADDataMove.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAsciiDataDef := TADAsciiDataDef.Create(Self);
  FMappings := TADMappings.Create(Self);
  FOptions := [poOptimiseDest, poOptimiseSrc, poAbortOnExc];
  FCommitCount := 100;
  FMode := dmAlwaysInsert;
  FLogFileAction := laNone;
  FAsciiFileName := 'Data.txt';
  FLogFileName := 'Data.log';
  FSourceKind := skDataSet;
  FDestinationKind := skDataSet;
  FStatisticsInterval := 100;
end;

{-------------------------------------------------------------------------------}
destructor TADDataMove.Destroy;
begin
  FreeAndNil(FAsciiDataDef);
  FreeAndNil(FMappings);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADDataMove.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then begin
    if AComponent = FSource then
      Source := nil
    else if AComponent = FDestination then
      Destination := nil;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataMove.SetAsciiDataDef(const AValue: TADAsciiDataDef);
begin
  FAsciiDataDef.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADDataMove.SetMappings(const AValue: TADMappings);
begin
  FMappings.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADDataMove.SetDestinationKind(const AValue: TADDataSourceKind);
begin
  if FDestinationKind <> AValue then begin
    FDestinationKind := AValue;
    if DestinationKind = skAscii then begin
      Mode := dmAlwaysInsert;
      Destination := nil;
      if SourceKind = skAscii then
        SourceKind := skDataSet;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataMove.SetSourceKind(const AValue: TADDataSourceKind);
begin
  if FSourceKind <> AValue then begin
    FSourceKind := AValue;
    if SourceKind = skAscii then begin
      Source := nil;
      if DestinationKind = skAscii then
        DestinationKind := skDataSet;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataMove.SetDestination(const AValue: TADAdaptedDataSet);
begin
  if FDestination <> AValue then begin
    if FDestination <> nil then
      FDestination.RemoveFreeNotification(Self);
    FDestination := AValue;
    if AValue = Source then
      Source := nil;
    if FDestination <> nil then begin
      FDestination.FreeNotification(Self);
      DestinationKind := skDataSet;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataMove.SetSource(const AValue: TDataSet);
begin
  if FSource <> AValue then begin
    if FSource <> nil then
      FSource.RemoveFreeNotification(Self);
    FSource := AValue;
    if AValue = Destination then
      Destination := nil;
    if FSource <> nil then begin
      FSource.FreeNotification(Self);
      SourceKind := skDataSet;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataMove.SetMode(const AValue: TADDataMoveMode);
begin
  if FMode <> AValue then begin
    FMode := AValue;
    if DestinationKind = skAscii then
      FMode := dmAlwaysInsert;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataMove.GetWriteCount: LongInt;
begin
  Result := FInsertCount + FUpdateCount + FDeleteCount;
end;

{-------------------------------------------------------------------------------}
function TADDataMove.Execute: LongInt;
begin
  if (SourceKind = skDataSet) and (DestinationKind = skDataSet) then
    Result := ExecuteTableToTable
  else if (SourceKind = skDataSet) and (DestinationKind = skAscii) then
    Result := ExecuteTableToAscii
  else if (SourceKind = skAscii) and (DestinationKind = skDataSet) then
    Result := ExecuteAsciiToTable
  else
    Result := -1;
end;

{-------------------------------------------------------------------------------}
procedure TADDataMove.DoStatistic(APhase: TADDataMovePhase);
begin
  if Assigned(FOnProgress) then
    FOnProgress(Self, APhase);
end;

{-------------------------------------------------------------------------------}
function TADDataMove.InitExceptionFile: TADFileStream;
var
  S: String;
begin
  if (LogFileName > #32) and (FLogFileAction <> laNone) then begin
    if FileExists(LogFileName) then
      if FLogFileAction = laCreate then
        Result := TADFileStream.Create(LogFileName, fmCreate)
      else
        Result := TADFileStream.Create(LogFileName, fmOpenReadWrite or fmShareDenyWrite)
    else
      Result := TADFileStream.Create(LogFileName, fmCreate);
    S := C_AD_EOL + C_AD_EOL + '*************** ' + S_AD_StartLog + ' ' +
      DateTimeToStr(Now) + ' ***************' + C_AD_EOL;
    Result.Write(S[1], Length(S));
  end
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADDataMove.ProcessException(E: Exception; AExcFS: TADFileStream;
  var AAction: TADErrorAction);
var
  sName, sSQL: String;
  vValue: Variant;
  eKind: TADDebugMonitorAdapterItemKind;
  S: String;
  i: Integer;
begin
  AAction := eaFail;
  if E is EDatabaseError then begin
    if Assigned(FOnError) then begin
      FOnError(Self, AAction);
      if AAction = eaDefault then
        AAction := eaFail;
    end;
    if AAction in [eaFail, eaSkip] then begin
      Inc(FExceptionCount);
      sSQL := '';
      if AExcFS <> nil then begin
        if (E is EADDBEngineException) and (EADDBEngineException(E).MonitorAdapter <> nil) then begin
          with EADDBEngineException(E).MonitorAdapter do
            for i := 0 to ItemCount - 1 do begin
              vValue := Unassigned;
              eKind := ikStat;
              GetItem(i, sName, vValue, eKind);
              if eKind = ikSQL then begin
                sSQL := ADFixCRLF(vValue);
                Break;
              end;
            end;
        end;
        S := C_AD_EOL + E.Message + C_AD_EOL + C_AD_EOL + sSQL + C_AD_EOL;
        AExcFS.Write(S[1], Length(S));
      end;
    end;
    if (AAction = eaFail) and (poAbortOnExc in Options) then
      AAction := eaExitFailure;
  end
  else
    AAction := eaExitFailure;
end;

{-------------------------------------------------------------------------------}
procedure TADDataMove.DeleteExceptionFile(AExcFS: TADFileStream);
var
  S: String;
begin
  if AExcFS <> nil then
    try
      if FExceptionCount = 0 then begin
        S := C_AD_EOL + '          **********  ' + S_AD_NoErrorsLogged + ' ' +
          '**********' + C_AD_EOL;
        AExcFS.Write(S[1], Length(S));
      end;
      S := C_AD_EOL + '*************** ' + S_AD_EndLog + ' ' +
        DateTimeToStr(Now) + ' ***************' + C_AD_EOL;
      AExcFS.Write(S[1], Length(S));
    finally
      AExcFS.Free;
    end;
end;

{-------------------------------------------------------------------------------}
type
  __TADAdaptedDataSet = class(TADAdaptedDataSet)
  end;

function TADDataMove.SetupSource: Boolean;
begin
  Result := Source.Active;
  Source.DisableControls;
  if (poOptimiseSrc in Options) and (Source is TADAdaptedDataSet) then
    with __TADAdaptedDataSet(Source) do begin
      FetchOptions.Items := [fiBlobs, fiDetails];
      FetchOptions.Mode := fmOnDemand;
      if FetchOptions.RowsetSize < CommitCount then
        FetchOptions.RowsetSize := CommitCount;
      FetchOptions.Cache := [];
      Unidirectional := True;
    end;
  if not (poSrcFromCurRec in Options) and Source.Active then
    try
      Source.First;
    except
      Source.Close;
      Source.Open;
    end
  else
    Source.Active := True;
end;

{-------------------------------------------------------------------------------}
function TADDataMove.SetupDestination: Boolean;
begin
  Result := Destination.Active;
  Destination.DisableControls;
  if poOptimiseDest in Options then
    with __TADAdaptedDataSet(Destination) do begin
      FetchOptions.Items := [fiMeta];
      FetchOptions.Mode := fmManual;
      UpdateOptions.FastUpdates := True;
    end;
  Destination.Active := True;
end;

{-------------------------------------------------------------------------------}
procedure TADDataMove.CheckAsciiSetup;
var
  i: Integer;
begin
  if AsciiDataDef.RecordFormat = rfFixedLength then
    for i := 0 to AsciiDataDef.Fields.Count - 1 do
      if AsciiDataDef.Fields[i].FieldSize < 0 then
        ADException(Self, [S_AD_LComp, S_AD_LComp_PDM], er_AD_DPBadFixedSize,
          [AsciiDataDef.Fields[i].FieldName]);
end;

{-------------------------------------------------------------------------------}
procedure TADDataMove.AbortJob;
begin
  if (Source <> nil) and (Source is TADAdaptedDataSet) then
    TADAdaptedDataSet(Source).AbortJob(True);
  if Destination <> nil then
    Destination.AbortJob(True);
  FAborting := True;
end;

{-------------------------------------------------------------------------------}
function TADDataMove.FindDestRecord: Boolean;
begin
  if Assigned(FOnFindDestRecord) then begin
    Result := False;
    FOnFindDestRecord(Self, Result);
  end
  else begin
    Destination.ServerSetKey;
    Mappings.Move(True);
    Result := Destination.ServerGotoKey;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataMove.ExecuteTableToTable: LongInt;
var
  oExcFS: TADFileStream;
  iAction: TADDataMoveAction;
  oDestConn: TADCustomConnection;
  lExcLogged: Boolean;
  oWait: IADGUIxWaitCursor;
  lDestDisconnected, lSrcActive, lDestActive, lRetry: Boolean;
  eErrorAction: TADErrorAction;
begin
  if Source = nil then
    ADException(Self, [S_AD_LComp, S_AD_LComp_PDM], er_AD_DPNoSrcDS, []);
  if Destination = nil then
    ADException(Self, [S_AD_LComp, S_AD_LComp_PDM], er_AD_DPNoDestDS, []);

  FReadCount := 0;
  FInsertCount := 0;
  FUpdateCount := 0;
  FDeleteCount := 0;
  FExceptionCount := 0;
  FAborting := False;
  lExcLogged := False;
  lDestDisconnected := False;
  oExcFS := nil;
  oDestConn := nil;

  DoStatistic(psPreparing);
  if not FAborting then
  try
    ADCreateInterface(IADGUIxWaitCursor, oWait);
    oWait.StartWait;
    oExcFS := InitExceptionFile;

    try
      oDestConn := Destination.PointedConnection;
      if (oDestConn <> nil) and not oDestConn.InTransaction then begin
        lDestDisconnected := not oDestConn.Connected;
        oDestConn.Connected := True;
        oDestConn.StartTransaction;
      end;
      lSrcActive := SetupSource;
      lDestActive := SetupDestination;
      try

        Mappings.Prepare;
        if [poClearDest, poClearDestNoUndo] * Options <> [] then
          iAction := paAlwaysInsert
        else if Mode = dmAlwaysInsert then
          iAction := paAlwaysInsert
        else if Mode = dmDelete then
          iAction := paDelete
        else
          iAction := paSkip;

        if [poClearDest, poClearDestNoUndo] * Options <> [] then
          Destination.ServerDeleteAll(poClearDestNoUndo in Options);

        DoStatistic(psStarting);

        while not FSource.Eof and not FAborting do begin
          oWait.StartWait;
          try
            Inc(FReadCount);

            if not (iAction in [paDelete, paAlwaysInsert]) then begin
              iAction := paSkip;
              if FindDestRecord then begin
                if (Mode = dmUpdate) or (Mode = dmAppendUpdate) then
                  iAction := paUpdate;
              end
              else begin
                if (Mode = dmAppend) or (Mode = dmAppendUpdate) then
                  iAction := paInsert;
              end;
            end;

            if (oDestConn <> nil) and not oDestConn.InTransaction then
              oDestConn.StartTransaction;

            repeat
              lRetry := False;
              try
                case iAction of
                paInsert, paAlwaysInsert:
                  begin
                    Destination.ServerAppend;
                    Mappings.Move(False);
                    Destination.ServerPerform;
                    Inc(FInsertCount);
                  end;
                paUpdate:
                  begin
                    Destination.ServerEdit;
                    Mappings.Move(False);
                    Destination.ServerPerform;
                    Inc(FUpdateCount);
                  end;
                paDelete:
                  begin
                    Destination.ServerDelete;
                    Mappings.Move(True);
                    Destination.ServerPerform;
                    Inc(FDeleteCount);
                  end;
                end;
              except
                on E: Exception do begin
                  if (oDestConn <> nil) and oDestConn.InTransaction then
                    oDestConn.Rollback;
                  lExcLogged := True;
                  ProcessException(E, oExcFS, eErrorAction);
                  case eErrorAction of
                  eaFail:        lRetry := False;
                  eaSkip:        lRetry := False;
                  eaRetry:       lRetry := True;
                  eaApplied:     lRetry := False;
                  eaExitSuccess: FAborting := True;
                  eaExitFailure: raise;
                  end;
                  lExcLogged := False;
                end;
              end;
            until not lRetry;

            try
              Source.Next;
            except
              Source.UpdateCursorPos;
            end;

            if (oDestConn <> nil) and oDestConn.InTransaction and (CommitCount > 0) then
              if WriteCount mod CommitCount = 0 then
                oDestConn.Commit;

            if StatisticsInterval > 0 then
              if FReadCount mod StatisticsInterval = 0 then
                DoStatistic(psProgress);
          finally
            oWait.StopWait;
          end;
        end;

        DoStatistic(psFinishing);
        Source.Close;
        Destination.Disconnect;

      finally
        Source.Active := lSrcActive;
        Destination.Active := lDestActive;
        Source.EnableControls;
        Destination.EnableControls;
      end;

      if (oDestConn <> nil) and oDestConn.InTransaction then
        oDestConn.Commit;

    except
      on E: Exception do begin
        if (oDestConn <> nil) and oDestConn.InTransaction then
          oDestConn.Rollback;
        if not lExcLogged then begin
          ProcessException(E, oExcFS, eErrorAction);
          if eErrorAction = eaExitFailure then
            raise;
        end;
      end;
    end;

  finally
    if (oDestConn <> nil) and lDestDisconnected then
      oDestConn.Connected := False;
    Mappings.Unprepare;
    DeleteExceptionFile(oExcFS);
    oWait.StopWait;
  end;
  DoStatistic(psUnpreparing);
  Result := WriteCount;
end;

{-------------------------------------------------------------------------------}
function TADDataMove.ExecuteTableToAscii: LongInt;
var
  oExcFS: TADFileStream;
  oAscFS: TADFileStream;
  oAsciiField: TADAsciiField;
  sVal, sNewLine: String;
  lCreate, lNeedDelim: Boolean;
  i: Integer;
  oWait: IADGUIxWaitCursor;
  lSrcActive: Boolean;
{$IFNDEF AnyDAC_D7}
  d: Double;
{$ENDIF}
  eErrorAction: TADErrorAction;

  function GetStr(AAscFld: TADAsciiField): String;
  var
    i: Integer;
    v: Variant;
    oItem: TADMappingItem;
    s: String;
{$IFNDEF AnyDAC_D7}
    prevDecSep: Char;
    prevShortDateFormat: String;
    prevDateSep: Char;
    prevShortTimeFormat: String;
    prevTimeSep: Char;
{$ENDIF}
  begin
    Result := '';
    for i := 0 to Mappings.Count - 1 do begin
      oItem := Mappings[i];
      if oItem.DestAsciiField = AAscFld then begin
        v := oItem.DestValue;
        if not VarIsEmpty(v) and not VarIsNull(v) then begin
          { TODO -cPUMP : Here we should format values }
          case AAscFld.DataType of
          atOther:
            Result := v;
          atString:
            Result := v;
          atFloat:
{$IFDEF AnyDAC_D7}
            Result := FloatToStr(v, AsciiDataDef.FormatSettings.FFS);
{$ELSE}
            begin
              prevDecSep := DecimalSeparator;
              DecimalSeparator := AsciiDataDef.FormatSettings.DecimalSeparator;
              try
                d := v;
                Result := FloatToStr(d);
              finally
                DecimalSeparator := prevDecSep;
              end;
            end;
{$ENDIF}
          atNumber:
            Result := v;
          atBool:
            if (v) then
              Result := 'T'
            else
              Result := 'F';
          atLongInt:
            Result := v;
          atDate:
{$IFDEF AnyDAC_D7}
            Result := DateToStr(v, AsciiDataDef.FormatSettings.FFS);
{$ELSE}
            begin
              prevShortDateFormat := ShortDateFormat;
              prevDateSep := DateSeparator;
              ShortDateFormat := AsciiDataDef.FormatSettings.ShortDateFormat;
              DateSeparator := AsciiDataDef.FormatSettings.DateSeparator;
              try
                Result := DateToStr(v);
              finally
                ShortDateFormat := prevShortDateFormat;
                DateSeparator := prevDateSep;
              end;
            end;
{$ENDIF}
          atTime:
{$IFDEF AnyDAC_D7}
            Result := TimeToStr(v, AsciiDataDef.FormatSettings.FFS);
{$ELSE}
            begin
              prevShortTimeFormat := ShortTimeFormat;
              prevTimeSep := TimeSeparator;
              ShortTimeFormat := AsciiDataDef.FormatSettings.ShortTimeFormat;
              TimeSeparator := AsciiDataDef.FormatSettings.TimeSeparator;
              try
                Result := TimeToStr(v);
              finally
                ShortTimeFormat := prevShortTimeFormat;
                TimeSeparator := prevTimeSep;
              end;
            end;
{$ENDIF}
          atDateTime:
{$IFDEF AnyDAC_D7}
            Result := DateTimeToStr(v, AsciiDataDef.FormatSettings.FFS);
{$ELSE}
            begin
              prevShortTimeFormat := ShortTimeFormat;
              prevTimeSep := TimeSeparator;
              ShortTimeFormat := AsciiDataDef.FormatSettings.ShortTimeFormat;
              TimeSeparator := AsciiDataDef.FormatSettings.TimeSeparator;
              prevShortDateFormat := ShortDateFormat;
              prevDateSep := DateSeparator;
              ShortDateFormat := AsciiDataDef.FormatSettings.ShortDateFormat;
              DateSeparator := AsciiDataDef.FormatSettings.DateSeparator;
              try
                Result := DateTimeToStr(v);
              finally
                ShortTimeFormat := prevShortTimeFormat;
                TimeSeparator := prevTimeSep;
                ShortDateFormat := prevShortDateFormat;
                DateSeparator := prevDateSep;
              end;
            end;
{$ENDIF}
          atBlob:
            begin
              s := v;
              SetLength(Result, Length(s) * 2);
              BinToHex(PChar(s), PChar(Result), Length(s));
            end;
          atMemo:
            Result := v;
          end;
        end;
        Break;
      end;
    end;
  end;

  procedure DoubleChar(ACh: Char; var AStr: String);
  var
    j: Integer;
  begin
    j := 1;
    repeat
      j := ADPosEx(ACh, AStr, j);
      if j > 0 then begin
        Insert(ACh, AStr, j);
        Inc(j, 2);
      end;
    until j = 0;
  end;

begin
  if Source = nil then
    ADException(Self, [S_AD_LComp, S_AD_LComp_PDM], er_AD_DPNoSrcDS, []);
  if AsciiFileName = '' then
    ADException(Self, [S_AD_LComp, S_AD_LComp_PDM], er_AD_DPNoAscDest, []);

  FReadCount := 0;
  FInsertCount := 0;
  FUpdateCount := 0;
  FDeleteCount := 0;
  FExceptionCount := 0;
  FAborting := False;
  oAscFS := nil;
  oExcFS := nil;
  case AsciiDataDef.EndOfLine of
  elWindows: sNewLine := C_AD_WinEOL;
  elUnix:    sNewLine := C_AD_UnixEOL;
  elMac:     sNewLine := C_AD_MacEOL;
  end;

  DoStatistic(psPreparing);
  if not FAborting then
  try
    ADCreateInterface(IADGUIxWaitCursor, oWait);
    oWait.StartWait;
    oExcFS := InitExceptionFile;

    lSrcActive := SetupSource;
    try

      Mappings.Prepare;
      CheckAsciiSetup;

      try
        lCreate := True;
        if FileExists(AsciiFileName) then
          if [poClearDest, poClearDestNoUndo] * Options <> [] then
            DeleteFile(AsciiFileName)
          else
            lCreate := True;
        if lCreate then
          oAscFS := TADFileStream.Create(AsciiFileName, fmCreate)
        else begin
          oAscFS := TADFileStream.Create(AsciiFileName, fmOpenReadWrite or fmShareDenyWrite);
          oAscFS.Seek(0, soFromEnd);
        end;

        DoStatistic(psStarting);

        if AsciiDataDef.WithFieldNames then begin
          for i := 0 to AsciiDataDef.Fields.Count - 1 do begin
            if i > 0 then
              oAscFS.Write(AsciiDataDef.FSeparator, 1);
            if AsciiDataDef.Delimiter <> #0 then
              oAscFS.Write(AsciiDataDef.FDelimiter, 1);
            oAscFS.Write(AsciiDataDef.Fields[i].FFieldName[1],
              Length(AsciiDataDef.Fields[i].FieldName));
            if AsciiDataDef.Delimiter <> #0 then
              oAscFS.Write(AsciiDataDef.FDelimiter, 1);
          end;
          oAscFS.Write(sNewLine[1], Length(sNewLine));
        end;

        while not Source.Eof and not FAborting do begin
          oWait.StartWait;
          try
            Inc(FReadCount);

            Mappings.Move(False);
            for i := 0 to AsciiDataDef.Fields.Count - 1 do begin
              oAsciiField := AsciiDataDef.Fields[i];
              sVal := GetStr(oAsciiField);
              if AsciiDataDef.Delimiter <> #0 then
                DoubleChar(AsciiDataDef.Delimiter, sVal);
              if AsciiDataDef.Separator <> #0 then
                DoubleChar(AsciiDataDef.Separator, sVal);
              lNeedDelim := oAsciiField.DataType in [atMemo, atString, atOther];
              if (AsciiDataDef.RecordFormat in [rfCommaDoubleQuote, rfTabDoubleQuote, rfCustom]) and
                 lNeedDelim and (AsciiDataDef.Delimiter <> #0) then
                oAscFS.Write(AsciiDataDef.FDelimiter, 1);
              if AsciiDataDef.RecordFormat = rfFixedLength then
                if oAsciiField.DataType in [atMemo, atString, atOther] then
                  sVal := ADPadR(sVal, oAsciiField.FieldSize)
                else
                  sVal := ADPadL(sVal, oAsciiField.FieldSize);
              if Length(sVal) > 0 then
                oAscFS.Write(sVal[1], Length(sVal));
              if (AsciiDataDef.RecordFormat in [rfCommaDoubleQuote, rfTabDoubleQuote, rfCustom]) then begin
                if lNeedDelim and (AsciiDataDef.Delimiter <> #0) then
                  oAscFS.Write(AsciiDataDef.FDelimiter, 1);
                if i < Source.Fields.Count - 1 then
                  if AsciiDataDef.Separator <> #0 then
                    oAscFS.Write(AsciiDataDef.FSeparator, 1);
              end;
              if AsciiDataDef.RecordFormat = rfFieldPerLine then
                oAscFS.Write(sNewLine[1], Length(sNewLine));
            end;
            if AsciiDataDef.RecordFormat <> rfFieldPerLine then
              oAscFS.Write(sNewLine[1], Length(sNewLine));

            Inc(FInsertCount);
            Source.Next;

            if StatisticsInterval > 0 then
              if FReadCount mod StatisticsInterval = 0 then
                DoStatistic(psProgress);
          finally
            oWait.StopWait;
          end;
        end;

        DoStatistic(psFinishing);
        Source.Close;

      except
        on E: Exception do begin
          ProcessException(E, oExcFS, eErrorAction);
          if eErrorAction = eaExitFailure then
            raise;
        end;
      end;

    finally
      Source.Active := lSrcActive;
      Source.EnableControls;
    end;

  finally
    Mappings.Unprepare;
    if oAscFS <> nil then
      oAscFS.Free;
    DeleteExceptionFile(oExcFS);
    oWait.StopWait;
  end;

  DoStatistic(psUnpreparing);
  Result := WriteCount;
end;

{-------------------------------------------------------------------------------}
function TADDataMove.ExecuteAsciiToTable: LongInt;
var
  oAscFS: TADFileStream;
  oExcFS: TADFileStream;
  iAction: TADDataMoveAction;
  oDestConn: TADCustomConnection;
  oAscFld: TADAsciiField;
  i, iFldLen, iFrom, iTo: Integer;
  sBuff: String;
  lEOF, lExcLogged, lInDelim: Boolean;
  C: Char;
  oWait: IADGUIxWaitCursor;
  lDestDisconnected, lDestActive, lRetry: Boolean;
  eErrorAction: TADErrorAction;

  function StrAndBoolToInt(const AStr: String): Variant;
  begin
    if (AStr[1] in ['T', 't', 'Y', 'y']) then
      Result := 1
    else if (AStr[1] in ['F', 'f', 'N', 'n']) then
      Result := 0
    else if Length(AStr) >= 10 then begin
{$IFDEF AnyDAC_D6Base}
      Result := StrToInt64(AStr);
{$ELSE}
      TVarData(Result).VType := varInt64;
      Decimal(Result).lo64 := StrToInt64(AStr);
{$ENDIF}
    end
    else
      Result := StrToInt(AStr);
  end;

  function StrAndBoolToFloat(const AStr: String; const AFS: TFormatSettings): Extended;
{$IFNDEF AnyDAC_D7}
  var
    prevDecSep: Char;
{$ENDIF}
  begin
    if (AStr[1] in ['T', 't', 'Y', 'y']) then
      Result := 1.0
    else if (AStr[1] in ['F', 'f', 'N', 'n']) then
      Result := 0.0
    else
{$IFDEF AnyDAC_D7}
      Result := StrToFloat(AStr, AFS);
{$ELSE}
      begin
        prevDecSep := DecimalSeparator;
        DecimalSeparator := AFS.DecimalSeparator;
        try
          Result := StrToFloat(AStr);
        finally
          DecimalSeparator := prevDecSep;
        end;
      end;
{$ENDIF}
  end;

  function CheckDateNotEmpty(const AStr: String): Boolean;
  var
    pCh: PChar;
  begin
    pCh := PChar(AStr);
    with AsciiDataDef.FormatSettings do
      while pCh^ <> #0 do
        if not ((pCh^ = ' ') or (pCh^ = '0') or (pCh^ = DateSeparator) or (pCh^ = TimeSeparator)) then
          Break
        else
          Inc(pCh);
    Result := pCh^ <> #0;
  end;

  procedure SetStr(AAscFld: TADAsciiField; const AStr: String);
  var
    i: Integer;
    oItem: TADMappingItem;
    S, S2: String;
{$IFNDEF AnyDAC_D7}
    prevShortDateFormat: String;
    prevDateSep: Char;
    prevShortTimeFormat: String;
    prevTimeSep: Char;
{$ENDIF}
  begin
    for i := 0 to Mappings.Count - 1 do begin
      oItem := Mappings[i];
      if oItem.SourceAsciiField = AAscFld then begin
        { TODO -cPUMP : Here we should remove format from values }
        S := AStr;
        if (Length(S) > 0) and (S[Length(S)] <= ' ') then
          S := TrimRight(AStr);
        if S = '' then
          oItem.SourceValue := Null
        else
          try
            case oAscFld.DataType of
            atOther:
              oItem.SourceValue := S;
            atString:
              oItem.SourceValue := S;
            atFloat:
              oItem.SourceValue := StrAndBoolToFloat(S, AsciiDataDef.FormatSettings.FFS);
            atNumber:
              oItem.SourceValue := StrAndBoolToInt(S);
            atBool:
              oItem.SourceValue := StrAndBoolToInt(S) <> 0;
            atLongInt:
              oItem.SourceValue := StrAndBoolToInt(S);
            atDate:
              if CheckDateNotEmpty(S) then
{$IFDEF AnyDAC_D7}
                oItem.SourceValue := StrToDate(S, AsciiDataDef.FormatSettings.FFS)
{$ELSE}
                begin
                  prevShortDateFormat := ShortDateFormat;
                  prevDateSep := DateSeparator;
                  ShortDateFormat := AsciiDataDef.FormatSettings.ShortDateFormat;
                  DateSeparator := AsciiDataDef.FormatSettings.DateSeparator;
                  try
                    oItem.SourceValue := StrToDate(S);
                  finally
                    ShortDateFormat := prevShortDateFormat;
                    DateSeparator := prevDateSep;
                  end;
                end
{$ENDIF}
              else
                oItem.SourceValue := Null;
            atTime:
              if CheckDateNotEmpty(S) then
{$IFDEF AnyDAC_D7}
                oItem.SourceValue := StrToTime(S, AsciiDataDef.FormatSettings.FFS)
{$ELSE}
                begin
                  prevShortTimeFormat := ShortTimeFormat;
                  prevTimeSep := TimeSeparator;
                  ShortTimeFormat := AsciiDataDef.FormatSettings.ShortTimeFormat;
                  TimeSeparator := AsciiDataDef.FormatSettings.TimeSeparator;
                  try
                    oItem.SourceValue := StrToTime(S);
                  finally
                    ShortTimeFormat := prevShortTimeFormat;
                    TimeSeparator := prevTimeSep;
                  end;
                end
{$ENDIF}
              else
                oItem.SourceValue := Null;
            atDateTime:
              if CheckDateNotEmpty(S) then
{$IFDEF AnyDAC_D7}
                oItem.SourceValue := StrToDateTime(S, AsciiDataDef.FormatSettings.FFS)
{$ELSE}
                begin
                  prevShortTimeFormat := ShortTimeFormat;
                  prevTimeSep := TimeSeparator;
                  ShortTimeFormat := AsciiDataDef.FormatSettings.ShortTimeFormat;
                  TimeSeparator := AsciiDataDef.FormatSettings.TimeSeparator;
                  prevShortDateFormat := ShortDateFormat;
                  prevDateSep := DateSeparator;
                  ShortDateFormat := AsciiDataDef.FormatSettings.ShortDateFormat;
                  DateSeparator := AsciiDataDef.FormatSettings.DateSeparator;
                  try
                    oItem.SourceValue := StrToDateTime(S);
                  finally
                    ShortTimeFormat := prevShortTimeFormat;
                    TimeSeparator := prevTimeSep;
                    ShortDateFormat := prevShortDateFormat;
                    DateSeparator := prevDateSep;
                  end;
                end
{$ENDIF}
              else
                oItem.SourceValue := Null;
            atBlob:
              begin
                SetLength(S2, Length(S) div 2);
                HexToBin(PChar(S), PChar(S2), Length(S2));
                oItem.SourceValue := S2;
              end;
            atMemo:
              oItem.SourceValue := S;
            end;
          except
            on E: EConvertError do
              ADException(Self, [S_AD_LComp, S_AD_LComp_PDM], er_AD_DPBadAsciiFmt,
                [AStr, oItem.DisplayName, E.Message]);
          end;
        Break;
      end;
    end;
  end;

begin
  if AsciiFileName = '' then
    ADException(Self, [S_AD_LComp, S_AD_LComp_PDM], er_AD_DPNoAscDest, []);
  if Destination = nil then
    ADException(Self, [S_AD_LComp, S_AD_LComp_PDM], er_AD_DPNoDestDS, []);

  FReadCount := 0;
  FInsertCount := 0;
  FUpdateCount := 0;
  FDeleteCount := 0;
  FExceptionCount := 0;
  oAscFS := nil;
  oExcFS := nil;
  lEOF := False;
  FAborting := False;
  lExcLogged := False;
  lDestDisconnected := False;
  iFldLen := 0;
  oDestConn := nil;
  SetLength(sBuff, 1024);

  DoStatistic(psPreparing);
  if not FAborting then
  try
    ADCreateInterface(IADGUIxWaitCursor, oWait);
    oWait.StartWait;
    oExcFS := InitExceptionFile;

    try
      oDestConn := Destination.PointedConnection;
      if (oDestConn <> nil) and not oDestConn.InTransaction then begin
        lDestDisconnected := not oDestConn.Connected;
        oDestConn.Connected := True;
        oDestConn.StartTransaction;
      end;
      lDestActive := SetupDestination;
      try

        Mappings.Prepare;
        CheckAsciiSetup;

        if [poClearDest, poClearDestNoUndo] * Options <> [] then
          iAction := paAlwaysInsert
        else if Mode = dmAlwaysInsert then
          iAction := paAlwaysInsert
        else if Mode = dmDelete then
          iAction := paDelete
        else
          iAction := paSkip;

        oAscFS := TADFileStream.Create(AsciiFileName, fmOpenRead or fmShareDenyWrite);

        if [poClearDest, poClearDestNoUndo] * Options <> [] then
          Destination.ServerDeleteAll(poClearDestNoUndo in Options);

        DoStatistic(psStarting);

        if AsciiDataDef.WithFieldNames then begin
          repeat
            lEOF := (oAscFS.Read(sBuff[1], SizeOf(C)) < 1);
          until lEOF or (sBuff[1] in [#13, #10]);
          repeat
            lEOF := (oAscFS.Read(sBuff[1], SizeOf(C)) < 1);
          until lEOF or not (sBuff[1] in [#13, #10]);
          if not lEOF then
            oAscFS.Position := oAscFS.Position - 1;
        end;

        while not lEOF and not FAborting do begin
          oWait.StartWait;
          try
            for i := 0 to AsciiDataDef.Fields.Count - 1 do begin
              oAscFld := AsciiDataDef.Fields[i];

              if not lEOF then
                case AsciiDataDef.RecordFormat of
                rfFixedLength:
                  begin
                    iFldLen := oAscFld.FieldSize;
                    if Length(sBuff) < iFldLen then
                      SetLength(sBuff, iFldLen);
                    lEOF := (oAscFS.Read(sBuff[1], iFldLen * SizeOf(C)) < iFldLen * SizeOf(C));
                  end;
                rfFieldPerLine:
                  begin
                    iFldLen := 0;
                    repeat
                      Inc(iFldLen);
                      if iFldLen > Length(sBuff) then
                        SetLength(sBuff, iFldLen + iFldLen div 2);
                      lEOF := (oAscFS.Read(sBuff[iFldLen], SizeOf(C)) < SizeOf(C));
                    until lEOF or (sBuff[iFldLen] in [#13, #10]);
                    if not lEOF then begin
                      Dec(iFldLen);
                      if AsciiDataDef.EndOfLine = elWindows then
                        oAscFS.Read(sBuff[iFldLen + 1], SizeOf(C));
                    end;
                  end;
                else
                  iFldLen := 0;
                  lInDelim := False;
                  repeat
                    Inc(iFldLen);
                    if iFldLen > Length(sBuff) then
                      SetLength(sBuff, iFldLen + iFldLen div 2);
                    lEOF := (oAscFS.Read(sBuff[iFldLen], SizeOf(C)) < SizeOf(C));
                    if not lEOF then
                      if sBuff[iFldLen] = AsciiDataDef.Delimiter then begin
                        C := #0;
                        lEOF := (oAscFS.Read(C, SizeOf(C)) < SizeOf(C));
                        if lEOF or (C <> AsciiDataDef.Delimiter) then
                          lInDelim := not lInDelim;
                        if not lEOF and (C <> AsciiDataDef.Delimiter) then
                          oAscFS.Position := oAscFS.Position - 1;
                      end;
                  until lEOF or not lInDelim and
                        (sBuff[iFldLen] in [#13, #10, AsciiDataDef.Separator]);
                  if not lEOF then
                    Dec(iFldLen);
                end;

              if not lEOF then begin
                iFrom := 1;
                iTo := iFldLen;
                if (iFrom > 0) and (iFrom <= Length(sBuff)) and (sBuff[iFrom] = AsciiDataDef.Delimiter) then
                  Inc(iFrom);
                if (iTo > 0) and (iTo <= Length(sBuff)) and (sBuff[iTo] = AsciiDataDef.Delimiter) then
                  Dec(iTo);
                SetStr(oAscFld, Copy(sBuff, iFrom, iTo - iFrom + 1));
              end
              else
                SetStr(oAscFld, '');
            end;

            Inc(FReadCount);

            if AsciiDataDef.RecordFormat <> rfFieldPerLine then begin
              repeat
                lEOF := (oAscFS.Read(sBuff[1], SizeOf(C)) < SizeOf(C));
              until lEOF or not (sBuff[1] in [#13, #10]);
              if not lEOF then
                oAscFS.Position := oAscFS.Position - 1;
            end;

            if not (iAction in [paDelete, paAlwaysInsert]) then begin
              iAction := paSkip;
              if FindDestRecord then begin
                if (Mode = dmUpdate) or (Mode = dmAppendUpdate) then
                  iAction := paUpdate;
              end
              else begin
                if (Mode = dmAppend) or (Mode = dmAppendUpdate) then
                  iAction := paInsert;
              end;
            end;

            if (oDestConn <> nil) and not oDestConn.InTransaction then
              oDestConn.StartTransaction;

            repeat
              lRetry := False;
              try
                case iAction of
                paInsert, paAlwaysInsert:
                  begin
                    Destination.ServerAppend;
                    Mappings.Move(False);
                    Destination.ServerPerform;
                    Inc(FInsertCount);
                  end;
                paUpdate:
                  begin
                    Destination.ServerEdit;
                    Mappings.Move(False);
                    Destination.ServerPerform;
                    Inc(FUpdateCount);
                  end;
                paDelete:
                  begin
                    Destination.ServerDelete;
                    Mappings.Move(True);
                    Destination.ServerPerform;
                    Inc(FDeleteCount);
                  end;
                end;
              except
                on E: Exception do begin
                  lExcLogged := True;
                  ProcessException(E, oExcFS, eErrorAction);
                  case eErrorAction of
                  eaFail:        lRetry := False;
                  eaSkip:        lRetry := False;
                  eaRetry:       lRetry := True;
                  eaApplied:     lRetry := False;
                  eaExitSuccess: FAborting := True;
                  eaExitFailure: raise;
                  end;
                  lExcLogged := False;
                end;
              end;
            until not lRetry;

            if (oDestConn <> nil) and oDestConn.InTransaction and (CommitCount > 0) then
              if WriteCount mod CommitCount = 0 then
                oDestConn.Commit;

            if StatisticsInterval > 0 then
              if FReadCount mod StatisticsInterval = 0 then
                DoStatistic(psProgress);

          finally
            oWait.StopWait;
          end;
        end;

        DoStatistic(psFinishing);
        Destination.Disconnect;

      finally
        Destination.Active := lDestActive;
        Destination.EnableControls;
      end;

      if (oDestConn <> nil) and oDestConn.InTransaction then
        oDestConn.Commit;

    except
      on E: Exception do begin
        if (oDestConn <> nil) and oDestConn.InTransaction then
          oDestConn.Rollback;
        if not lExcLogged then begin
          ProcessException(E, oExcFS, eErrorAction);
          if eErrorAction = eaExitFailure then
            raise;
        end;
      end;
    end;

  finally
    if (oDestConn <> nil) and lDestDisconnected then
      oDestConn.Connected := False;
    Mappings.Unprepare;
    if oAscFS <> nil then
      oAscFS.Free;
    DeleteExceptionFile(oExcFS);
    oWait.StopWait;
  end;
  DoStatistic(psUnpreparing);
  Result := WriteCount;
end;

end.
