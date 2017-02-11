{--------------------------------------------------------------- ---------------}
{ Data Abstract - AnyDAC Driver                                                 }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I DataAbstract.inc}
{$I daAD.inc}

unit uDAAnyDACDriver;

{$R DataAbstract_AnyDACDriver_Glyphs.res}

interface

uses
  DB,
  uROClasses,
  uDAEngine, uDAInterfaces, uDAInterfacesEx, uDAUtils, uDAOracleInterfaces,
  {$I ..\..\..\TOOL\TOOLDBs.inc}
  daADStanIntf, daADMoniBase, daADCompClient;

type
  { TDAAnyDACDriver }
  TDAAnyDACDriver = class(TDADriverReference)
  end;

  { TDAEAnyDACDriver }
  TDAEAnyDACDriver = class(TDAEDriver)
  private
    FMonitor: TADMoniIndyClientLink;
    FTraceCallback: TDALogTraceEvent;
    procedure DoTrace(ASender: TADMoniClientLinkBase;
      const AClassName, AObjName, AMessage: String);
  protected
    function GetConnectionClass: TDAEConnectionClass; override;
    // IDADriver
    procedure Initialize; override;
    procedure Finalize; override;
    function GetDriverID: string; override;
    function GetDescription: string; override;
    procedure GetAuxDrivers(out List: IROStrings); override;
    function GetAvailableDriverOptions: TDAAvailableDriverOptions; override;
    procedure DoSetTraceOptions(TraceActive: boolean;
      TraceOptions: TDATraceOptions; Callback: TDALogTraceEvent); override;
  end;

  { TDAEAnyDACConnection }
  TDAEAnyDACConnection = class(TDAEConnection, IDAConnectionModelling,
    IInterface, IDAUseGenerators, IOracleConnection)
  private
    FADConnection: TADConnection;
    FRDBMSKind: TADRDBMSKind;
    function GetRDBMSKind: TADRDBMSKind;

  protected
    // IInterface
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;

    // TDAEConnection
    function GetDatasetClass: TDAEDatasetClass; override;
    function GetStoredProcedureClass: TDAEStoredProcedureClass; override;

    function CreateCustomConnection: TCustomConnection; override;
    procedure DoApplyConnectionString(aConnStrParser: TDAConnectionStringParser; aConnectionObject: TCustomConnection); override;

    function DoBeginTransaction: integer; override;
    procedure DoCommitTransaction; override;
    procedure DoRollbackTransaction; override;
    function DoGetInTransaction: boolean; override;

    function DoGetLastAutoInc(const GeneratorName: string): integer; override;
    // IDAUseGenerators
    function GetNextAutoinc(const GeneratorName: string): integer; safecall;

    procedure DoGetStoredProcedureNames(out List: IROStrings); override;
    procedure DoGetTableNames(out List: IROStrings); override;
    procedure DoGetViewNames(out List: IROStrings); override;
    procedure DoGetTableFields(const aTableName: string;
      out Fields: TDAFieldCollection); override;
    procedure DoGetForeignKeys(out ForeignKeys: TDADriverForeignKeyCollection); override;

    function GetQuoteChars: TDAQuoteCharArray; override;
    function CreateMacroProcessor: TDASQLMacroProcessor; override;

    // IDAConnectionModelling
    function BuildCreateTableSQL(aDataSet: TDADataSet; const aOverrideName: string = ''): string; safecall;
    procedure CreateTable(aDataSet: TDADataSet; const aOverrideName: string = ''); safecall;
    function FieldToDeclaration(aField: TDAField): string; safecall;

    property RDBMSKind: TADRDBMSKind read GetRDBMSKind;
  end;

  { TDAEAnyDACQuery }
  TDAEAnyDACQuery = class(TDAEDataset, IDAMustSetParams)
  protected
    function CreateDataset(aConnection: TDAEConnection): TDataset; override;

    // TDAEDataset
    procedure DoPrepare(Value: boolean); override;
    function DoExecute: integer; override;
    function DoGetSQL: string; override;
    procedure DoSetSQL(const Value: string); override;

    // IDAMustSetParams
    procedure SetParamValues(Params: TDAParamCollection); safecall;
  end;

  { TDAEAnyDACStoredProcedure }
  TDAEAnyDACStoredProcedure = class(TDAEStoredProcedure, IDAMustSetParams)
  protected
    function CreateDataset(aConnection: TDAEConnection): TDataset; override;

    procedure RefreshParams; override;
    function GetStoredProcedureName: string; override;
    procedure SetStoredProcedureName(const Name: string); override;
    function Execute: integer; override;

    // IDAMustSetParams
    procedure SetParamValues(Params: TDAParamCollection); safecall;
  end;

procedure Register;

function GetDriverObject: IDADriver; stdcall;

implementation

uses
  Classes, SysUtils, Variants, Math,
  uDADriverManager, uDARes, uDAMacroProcessors, uDAHelpers, uROBinaryHelpers,
  daADStanFactory, daADStanConst, daADStanOption, daADStanParam, daADPhysIntf,
  daADGUIxConsoleWait;

{------------------------------------------------------------------------------}
{ Generic procedures                                                           }
{------------------------------------------------------------------------------}
procedure SetADParamValuesFromDA(ADAParams: TDAParamCollection;
  AADParams: TADParams; ASetType: Boolean);
var
  i: integer;
  oDAPar: TDAParam;
  oADPar: TADParam;
begin
  for i := 0 to AADParams.Count - 1 do begin
    oADPar := AADParams[i];
    oDAPar := ADAParams.ParamByName(oADPar.Name);
    oADPar.ParamType := TParamType(oDAPar.ParamType);
    if oDAPar.ParamType in [daptInput, daptInputOutput] then
      if oDAPar.DataType in [datBlob, datMemo] then begin
        if ASetType then
          oADPar.DataType := BlobTypeMappings[oDAPar.BlobType];
        if VarIsEmpty(oDAPar.Value) or VarIsNull(oDAPar.Value) then
          oADPar.Clear
        else
          oADPar.AsBlob := VariantBinaryToString(oDAPar.Value);
      end
      else begin
        if ASetType then
          oADPar.DataType := DATypeToVCLType(oDAPar.DataType);
        oADPar.Value := oDAPar.Value;
      end;
  end;
end;

{------------------------------------------------------------------------------}
procedure GetDAParamValuesFromAD(ADAParams: TDAParamCollection; AADParams: TADParams);
var
  i: integer;
  oDAPar: TDAParam;
  oADPar: TADParam;
begin
  for i := 0 to ADAParams.Count - 1 do begin
    oDAPar := ADAParams[i];
    oADPar := AADParams.ParamByName(oDAPar.Name);
    if oDAPar.ParamType in [daptOutput, daptInputOutput, daptResult] then
      oDAPar.Value := oADPar.Value;
  end;
end;

{------------------------------------------------------------------------------}
function MapAD2DADataType(AADDataType: TADDataType; out ABlobType: TDABlobType): TDADataType;
begin
  ABlobType := dabtUnknown;
  case AADDataType of
  dtUnknown:
    Result := datUnknown;
  dtWideString,
  dtAnsiString:
    Result := datString;
  dtWideMemo,
  dtMemo:
    Result := datMemo;
  dtWideHMemo,
  dtHMemo:
    begin
      Result := datBlob;
      ABlobType := dabtOraClob;
    end;
  dtDate,
  dtTime,
  dtDateTime,
  dtDateTimeStamp:
    Result := datDateTime;
  dtByte,
  dtSByte,
  dtUInt16,
  dtInt16,
  dtUInt32,
  dtInt32:
    Result := datInteger;
  dtUInt64,
  dtInt64:
    Result := datLargeInt;
  dtDouble,
  dtBCD:
    Result := datFloat;
  dtCurrency,
  dtFmtBCD:
    Result := datCurrency;
  dtBlob,
  dtByteString:
    begin
      Result := datBlob;
      ABlobType := dabtBlob;
    end;
  dtHBlob,
  dtHBFile:
    begin
      Result := datBlob;
      ABlobType := dabtOraBlob;
    end;
  dtBoolean:
    Result := datBoolean;
  else
    raise Exception.Create('AnyDAC data type is not supported or unknown');
  end;
end;

{------------------------------------------------------------------------------}
{ TDAEAnyDACDriver                                                             }
{------------------------------------------------------------------------------}
function TDAEAnyDACDriver.GetAvailableDriverOptions: TDAAvailableDriverOptions;
begin
  result := [doAuxDriver, doServerName, doDatabaseName, doLogin, doCustom];
end;

{------------------------------------------------------------------------------}
function TDAEAnyDACDriver.GetConnectionClass: TDAEConnectionClass;
begin
  result := TDAEAnyDACConnection;
end;

{------------------------------------------------------------------------------}
function TDAEAnyDACDriver.GetDescription: string;
begin
  result := 'da-soft AnyDAC Driver';
end;

{------------------------------------------------------------------------------}
function TDAEAnyDACDriver.GetDriverID: string;
begin
  result := 'AnyDAC';
end;

{------------------------------------------------------------------------------}
procedure TDAEAnyDACDriver.GetAuxDrivers(out List: IROStrings);
begin
  List := NewROStrings;
  ADManager.GetDriverNames(List.Strings);
end;

{------------------------------------------------------------------------------}
procedure TDAEAnyDACDriver.Initialize;
begin
  ADManager.Open;
end;

{------------------------------------------------------------------------------}
procedure TDAEAnyDACDriver.Finalize;
begin
  ADManager.Close;
  if FMonitor <> nil then
    FreeAndNil(FMonitor);
end;

{------------------------------------------------------------------------------}
procedure TDAEAnyDACDriver.DoTrace(ASender: TADMoniClientLinkBase;
  const AClassName, AObjName, AMessage: String);
begin
  if Assigned(FTraceCallback) then
    FTraceCallback(ASender, AMessage, 0);
end;

{------------------------------------------------------------------------------}
procedure TDAEAnyDACDriver.DoSetTraceOptions(TraceActive: boolean;
  TraceOptions: TDATraceOptions; Callback: TDALogTraceEvent);
var
  eKinds: TADDebugEventKinds;
begin
  inherited;
  if TraceActive then begin
    if FMonitor = nil then
      FMonitor := TADMoniIndyClientLink.Create(Self);
    FMonitor.Tracing := False;
    FTraceCallBack := Callback;
    FMonitor.OnOutput := DoTrace;
    eKinds := [];
    if toPrepare in TraceOptions then
      eKinds := eKinds + [ekCmdPrepare];
    if toExecute in TraceOptions then
      eKinds := eKinds + [ekCmdExecute];
    if toFetch in TraceOptions then
      eKinds := eKinds + [ekCmdDataIn];
    if toError in TraceOptions then
      eKinds := eKinds + [ekError];
    // if toStmt in TraceOptions then
    //   eKinds := eKinds + [tfStmt];
    if toConnect in TraceOptions then
      eKinds := eKinds + [ekConnConnect];
    if toTransact in TraceOptions then
      eKinds := eKinds + [ekConnTransact];
    // if toBlob in TraceOptions then
    //   eKinds := eKinds + [tfBlob];
    if toService in TraceOptions then
      eKinds := eKinds + [ekVendor];
    if toMisc in TraceOptions then
      eKinds := eKinds + [ekConnService, ekLiveCycle, ekAdaptUpdate];
    if toParams in TraceOptions then
      eKinds := eKinds + [ekCmdDataIn, ekCmdDataOut];
    FMonitor.EventKinds := eKinds;
    FMonitor.Tracing := True;
  end
  else begin
    if FMonitor <> nil then
      FMonitor.Tracing := False;
    FTraceCallback := nil;
  end;
end;

{------------------------------------------------------------------------------}
{ TDAEAnyDACConnection                                                         }
{------------------------------------------------------------------------------}
function TDAEAnyDACConnection.GetRDBMSKind: TADRDBMSKind;
begin
  if (FRDBMSKind = mkUnknown) and (FADConnection <> nil) and
     (FADConnection.ConnectionIntf <> nil) then
    FRDBMSKind := FADConnection.RDBMSKind;
  Result := FRDBMSKind;
end;

{------------------------------------------------------------------------------}
function TDAEAnyDACConnection.QueryInterface(const IID: TGUID; out Obj): HResult;
const
  IOracleConnection_GUID: TGUID = '{C7C88680-12BF-402A-8843-80016429BAC1}';
  IDAUseGenerators_GUID: TGUID = '{7963D550-361E-486A-AAD6-EFD12896F719}';
begin
  if IsEqualGUID(IID, IDAUseGenerators_GUID) or
     IsEqualGUID(IID, IOracleConnection_GUID) then
    if RDBMSKind = mkOracle then
      Result := inherited QueryInterface(IID, Obj)
    else
      Result := E_NOINTERFACE
  else
    Result := inherited QueryInterface(IID, Obj);
end;

{------------------------------------------------------------------------------}
function TDAEAnyDACConnection.GetDatasetClass: TDAEDatasetClass;
begin
  result := TDAEAnyDACQuery;
end;

{------------------------------------------------------------------------------}
function TDAEAnyDACConnection.GetStoredProcedureClass: TDAEStoredProcedureClass;
begin
  result := TDAEAnyDACStoredProcedure;
end;

{------------------------------------------------------------------------------}
function TDAEAnyDACConnection.CreateCustomConnection: TCustomConnection;
begin
  FRDBMSKind := mkUnknown;
  FADConnection := TADConnection.Create(nil);
  FADConnection.LoginPrompt := False;
  result := FADConnection;
end;

{------------------------------------------------------------------------------}
procedure TDAEAnyDACConnection.DoApplyConnectionString(
  aConnStrParser: TDAConnectionStringParser; aConnectionObject: TCustomConnection);
var
  oDef: IADStanConnectionDef;
begin
  FRDBMSKind := mkUnknown;
  inherited DoApplyConnectionString(aConnStrParser, aConnectionObject);
  with aConnStrParser do begin
    oDef := FADConnection.ResultConnectionDef;
    oDef.DriverID := AuxDriver;
    if (Self.UserID <> '') then
      oDef.UserName := Self.UserID
    else if (UserID <> '') then
      oDef.UserName := UserID;
    if (Self.Password <> '') then
      oDef.Password := Self.Password
    else if (Password <> '') then
      oDef.Password := Password;
    if Database <> '' then
      oDef.Database := Database;
    if CompareText(oDef.DriverID, C_AD_PhysRDBMSKinds[mkMySQL]) = 0 then
      oDef.AsString[S_AD_ConnParam_MySQL_Host] := Server
    else if CompareText(oDef.DriverID, C_AD_PhysRDBMSKinds[mkASA]) = 0 then
      oDef.AsString[S_AD_ConnParam_ASA_Server] := Server
    else
      oDef.AsString[S_AD_ConnParam_MSSQL_Server] := Server;
    oDef.ParseString(AuxParamsString);
    if AuxParams['ConnectionDefName'] <> '' then
      FADConnection.ConnectionDefName := AuxParams['ConnectionDefName'];
  end;
end;

{------------------------------------------------------------------------------}
function TDAEAnyDACConnection.DoBeginTransaction: integer;
begin
  Result := FADConnection.StartTransaction;
end;

{------------------------------------------------------------------------------}
procedure TDAEAnyDACConnection.DoCommitTransaction;
begin
  FADConnection.Commit;
end;

{------------------------------------------------------------------------------}
procedure TDAEAnyDACConnection.DoRollbackTransaction;
begin
  FADConnection.Rollback;
end;

{------------------------------------------------------------------------------}
function TDAEAnyDACConnection.DoGetInTransaction: boolean;
begin
  result := FADConnection.InTransaction;
end;

{------------------------------------------------------------------------------}
function TDAEAnyDACConnection.DoGetLastAutoInc(const GeneratorName: string): integer;
var
  v: Variant;
begin
  v := FADConnection.GetLastAutoGenValue(GeneratorName);
  if VarIsNull(v) then
    Result := 0
  else
    Result := v;
end;

{------------------------------------------------------------------------------}
function TDAEAnyDACConnection.GetNextAutoinc(const GeneratorName: string): integer;
var
  ds: IDAdataset;
begin
  ds := NewDataset('SELECT ' + GeneratorName + '.Nextval FROM dual');
  ds.Open;
  result := ds.Fields[0].Value;
end;

{------------------------------------------------------------------------------}
procedure TDAEAnyDACConnection.DoGetStoredProcedureNames(out List: IROStrings);
begin
  List := NewROStrings();
  FADConnection.GetStoredProcNames('', '', '', '', List.Strings, [osMy]);
end;

{------------------------------------------------------------------------------}
procedure TDAEAnyDACConnection.DoGetViewNames(out List: IROStrings);
begin
  List := NewROStrings();
  FADConnection.GetTableNames('', '', '', List.Strings, [osMy], [tkView]);
end;

{------------------------------------------------------------------------------}
procedure TDAEAnyDACConnection.DoGetTableNames(out List: IROStrings);
begin
  List := NewROStrings();
  FADConnection.GetTableNames('', '', '', List.Strings, [osMy], [tkTable]);
end;

{------------------------------------------------------------------------------}
procedure TDAEAnyDACConnection.DoGetTableFields(const aTableName: string;
  out Fields: TDAFieldCollection);
var
  oMIQ: TADMetaInfoQuery;
  eAttrs: TADDataAttributes;
  eBlobType: TDABlobType;
  lUseROWIDAsPK: Boolean;
  oFld: TDAField;
begin
  Fields := TDAFieldCollection.Create(nil);
  lUseROWIDAsPK := False;
  oMIQ := TADMetaInfoQuery.Create(nil);
  try
    oMIQ.Connection := FADConnection;
    oMIQ.ObjectName := aTableName;
    oMIQ.MetaInfoKind := mkTableFields;
    oMIQ.Open;
    while not oMIQ.Eof do begin
      with Fields.Add do begin
        Name := oMIQ.FieldByName('COLUMN_NAME').AsString;
        Size := oMIQ.FieldByName('COLUMN_LENGTH').AsInteger;
        eAttrs := TADDataAttributes(Word(oMIQ.FieldByName('COLUMN_ATTRIBUTES').AsInteger));
        DataType := MapAD2DADataType(TADDataType(oMIQ.FieldByName('COLUMN_DATATYPE').AsInteger), eBlobType);
        if eBlobType <> dabtUnknown then
          BlobType := eBlobType;
        if (DataType = datInteger) and (caAutoInc in eAttrs) then
          DataType := datAutoInc;
        Required := not (caAllowNull in eAttrs);
        ReadOnly := caReadOnly in eAttrs;
        if caROWID in eAttrs then begin
          InPrimaryKey := True;
          lUseROWIDAsPK := True;
        end;
        // DefaultValue
        // ServerAutoRefresh
      end;
      oMIQ.Next;
    end;

    if not lUseROWIDAsPK then begin
      oMIQ.Close;
      oMIQ.BaseObjectName := oMIQ.ObjectName;
      oMIQ.ObjectName := '';
      oMIQ.MetaInfoKind := mkPrimaryKeyFields;
      oMIQ.Open;
      while not oMIQ.Eof do begin
        oFld := Fields.FindField(oMIQ.FieldByName('COLUMN_NAME').AsString);
        if oFld <> nil then
          oFld.InPrimaryKey := True;
        oMIQ.Next;
      end;
    end;

  finally
    oMIQ.Free;
  end;
end;

{------------------------------------------------------------------------------}
procedure TDAEAnyDACConnection.DoGetForeignKeys(out ForeignKeys: TDADriverForeignKeyCollection);
var
  oTabs, oFKeys, oFKeyFields: TADMetaInfoQuery;
  sFKFields, sPKFields: String;
  oConnMeta: IADPhysConnectionMetadata;

  function QuoteName(const AName: String): String;
  begin
    if AName = '' then
      Result := ''
    else
      Result := oConnMeta.NameQuotaChar1 + AName + oConnMeta.NameQuotaChar2;
  end;

begin
  FADConnection.ConnectionIntf.CreateMetadata(oConnMeta);
  ForeignKeys := TDADriverForeignKeyCollection.Create(nil);
  oTabs := TADMetaInfoQuery.Create(nil);
  oFKeys := TADMetaInfoQuery.Create(nil);
  oFKeyFields := TADMetaInfoQuery.Create(nil);
  try
    oTabs.Connection := FADConnection;
    oTabs.MetaInfoKind := mkTables;
    oTabs.TableKinds := [tkTable, tkTempTable, tkLocalTable];
    oFKeys.MetaInfoKind := mkForeignKeys;
    oFKeys.Connection := FADConnection;
    oFKeys.MetaInfoKind := mkForeignKeys;
    oFKeyFields.Connection := FADConnection;
    oFKeyFields.MetaInfoKind := mkForeignKeyFields;
    oTabs.Open;
    while not oTabs.Eof do begin
      oFKeys.Close;
      oFKeys.CatalogName := QuoteName(oTabs.Fields[1].AsString);
      oFKeys.SchemaName := QuoteName(oTabs.Fields[2].AsString);
      oFKeys.ObjectName := QuoteName(oTabs.Fields[3].AsString);
      oFKeys.Open;
      while not oFKeys.Eof do begin
        oFKeyFields.Close;
        oFKeyFields.CatalogName := QuoteName(oFKeys.Fields[1].AsString);
        oFKeyFields.SchemaName := QuoteName(oFKeys.Fields[2].AsString);
        oFKeyFields.BaseObjectName := QuoteName(oFKeys.Fields[3].AsString);
        oFKeyFields.ObjectName := QuoteName(oFKeys.Fields[4].AsString);
        oFKeyFields.Open;
        sPKFields := '';
        sFKFields := '';
        while not oFKeyFields.Eof do begin
          if sPKFields <> '' then
            sPKFields := sPKFields + ',';
          sPKFields := sPKFields + oFKeyFields.Fields[6].AsString;
          if sFKFields <> '' then
            sFKFields := sFKFields + ',';
          sFKFields := sFKFields + oFKeyFields.Fields[5].AsString;
          oFKeyFields.Next;
        end;
        with ForeignKeys.Add do begin
          PKTable := FADConnection.EncodeObjectName(oFKeys.Fields[5].AsString,
            oFKeys.Fields[6].AsString, '', oFKeys.Fields[7].AsString);
          PKField := sPKFields;
          FKTable := FADConnection.EncodeObjectName(oFKeys.Fields[1].AsString,
            oFKeys.Fields[2].AsString, '', oFKeys.Fields[3].AsString);
          FKField := sFKFields;
        end;
        oFKeys.Next;
      end;
      oTabs.Next;
    end;
  finally
    oTabs.Free;
    oFKeys.Free;
    oFKeyFields.Free;
  end;
end;

{------------------------------------------------------------------------------}
function TDAEAnyDACConnection.GetQuoteChars: TDAQuoteCharArray;
var
  oConnMeta: IADPhysConnectionMetadata;
begin
  FADConnection.ConnectionIntf.CreateMetadata(oConnMeta);
  result[0] := oConnMeta.NameQuotaChar1;
  result[1] := oConnMeta.NameQuotaChar2;
end;

{------------------------------------------------------------------------------}
function TDAEAnyDACConnection.CreateMacroProcessor: TDASQLMacroProcessor;
begin
  Result := nil;
  case RDBMSKind of
  mkMSSQL,
  mkMSAccess:  result := TMSSQLMacroProcessor.Create;
  mkOracle:    result := TOracleMacroProcessor.Create;
  end;
end;

{------------------------------------------------------------------------------}
procedure TDAEAnyDACConnection.CreateTable(aDataSet: TDADataSet; const aOverrideName: string);
var
  sSQL: string;
begin
  sSQL := BuildCreateTableSQL(aDataSet, aOverrideName);
  with NewCommand(sSQL, stSQL) do
    Execute();
end;

{------------------------------------------------------------------------------}
function TDAEAnyDACConnection.BuildCreateTableSQL(aDataSet: TDADataSet;
  const aOverrideName: string): string;
var
  lName: string;
begin
  lName := aOverrideName;
  if lName = '' then
    lName := aDataSet.Name;
  result := uDAHelpers.BuildCreateStatementForTable(aDataSet, lName, self);
end;

{------------------------------------------------------------------------------}
function TDAEAnyDACConnection.FieldToDeclaration(aField: TDAField): string;
begin
  Result := '';
  case RDBMSKind of
  mkMSSQL:
    case aField.DataType of
    datString:    result := Format('varchar(%d)', [aField.Size]);
    datDateTime:  result := 'datetime';
    datFloat:     result := 'float';
    datCurrency:  result := 'money';
    datAutoInc:   result := 'int IDENTITY(1,1)';
    datInteger:   result := 'int';
    datLargeInt:  result := 'largeint';
    datBoolean:   result := 'bit';
    datMemo:      result := 'text';
    datBlob:      result := 'image';
    end;
  mkOracle:
    case aField.DataType of
    datString:    result := Format('varchar2(%d)', [aField.Size]);
    datDateTime:  result := 'date';
    datFloat:     result := 'float';
    datCurrency:  result := 'number(19,4)';
    datAutoInc:   result := 'number(10,0)';
    datInteger:   result := 'number(10,0)';
    datLargeInt:  result := 'number(19,0)';
    datBoolean:   result := 'number(1)';
    else
      case aField.BlobType of
      dabtBlob:     result := 'long raw';
      dabtMemo:     result := 'long';
      dabtOraBlob:  result := 'blob';
      dabtOraClob:  result := 'clob';
      end;
    end;
  mkMySQL:
    case aField.DataType of
    datString:    result := Format('varchar(%d)', [aField.Size]);
    datDateTime:  result := 'datetime';
    datFloat:     result := 'float';
    datCurrency:  result := 'decimal';
    datAutoInc:   result := 'int auto_increment';
    datInteger:   result := 'int';
    datLargeInt:  result := 'bigint';
    datBoolean:   result := 'bool';
    datMemo:      result := 'longtext';
    datBlob:      result := 'longblob';
    end;
  end;
  if Result = '' then
    raise Exception.Create('DataAbstract data type is not supported or unknown');
end;

{------------------------------------------------------------------------------}
{ TDAEAnyDACQuery                                                              }
{------------------------------------------------------------------------------}
function TDAEAnyDACQuery.CreateDataset(aConnection: TDAEConnection): TDataset;
begin
  result := TADQuery.Create(nil);
  TADQuery(result).Connection := TDAEAnyDACConnection(aConnection).FADConnection;
  TADQuery(result).RequestLive := False;
  TADQuery(result).FetchOptions.Mode := fmAll;
end;

{------------------------------------------------------------------------------}
procedure TDAEAnyDACQuery.DoPrepare(Value: boolean);
begin
  TADQuery(Dataset).Prepared := Value;
end;

{------------------------------------------------------------------------------}
function TDAEAnyDACQuery.DoExecute: integer;
begin
  inherited DoExecute;
  result := TADQuery(Dataset).RowsAffected;
  GetDAParamValuesFromAD(GetParams, TADQuery(Dataset).Params);
end;

{------------------------------------------------------------------------------}
function TDAEAnyDACQuery.DoGetSQL: string;
begin
  result := TADQuery(Dataset).SQL.Text;
end;

{------------------------------------------------------------------------------}
procedure TDAEAnyDACQuery.DoSetSQL(const Value: string);
begin
  TADQuery(Dataset).SQL.Text := Value;
end;

{------------------------------------------------------------------------------}
procedure TDAEAnyDACQuery.SetParamValues(Params: TDAParamCollection);
begin
  SetADParamValuesFromDA(Params, TADQuery(Dataset).Params, True);
end;

{------------------------------------------------------------------------------}
{ TDAEAnyDACStoredProcedure                                                    }
{------------------------------------------------------------------------------}
function TDAEAnyDACStoredProcedure.CreateDataset(aConnection: TDAEConnection): TDataset;
begin
  Result := TADStoredProc.Create(nil);
  TADStoredProc(Result).Connection := TDAEAnyDACConnection(aConnection).FADConnection;
end;

{------------------------------------------------------------------------------}
function TDAEAnyDACStoredProcedure.GetStoredProcedureName: string;
begin
  Result := TADStoredProc(DataSet).StoredProcName;
end;

{------------------------------------------------------------------------------}
procedure TDAEAnyDACStoredProcedure.SetStoredProcedureName(const Name: string);
begin
  TADStoredProc(DataSet).StoredProcName := Name;
end;

{------------------------------------------------------------------------------}
function TDAEAnyDACStoredProcedure.Execute: integer;
var
  oADParams: TADParams;
  oDAParams: TDAParamCollection;
begin
  oADParams := TADStoredProc(Dataset).Params;
  oDAParams := GetParams;
  if oADParams.Count <> oDAParams.Count then
    TADStoredProc(Dataset).Prepare;
  SetADParamValuesFromDA(oDAParams, oADParams, False);
  TADStoredProc(Dataset).ExecProc;
  result := TADStoredProc(Dataset).RowsAffected;
  GetDAParamValuesFromAD(oDAParams, oADParams);
end;

{------------------------------------------------------------------------------}
procedure TDAEAnyDACStoredProcedure.RefreshParams;
var
  oDAParams: TDAParamCollection;
  oDAParam: TDAParam;
  i: Integer;
begin
  TADStoredProc(Dataset).Prepare;
  oDAParams := GetParams;
  oDAParams.Clear;
  with TADStoredProc(Dataset) do
    for i := 0 to Params.Count - 1 do begin
      oDAParam := oDAParams.Add;
      oDAParam.Name := Params[i].Name;
      oDAParam.DataType := VCLTypeToDAType(Params[i].DataType);
      oDAParam.ParamType := TDAParamType(Params[i].ParamType);
      oDAParam.Size := Params[i].Size;
    end;
end;

{------------------------------------------------------------------------------}
procedure TDAEAnyDACStoredProcedure.SetParamValues(Params: TDAParamCollection);
begin
  SetADParamValuesFromDA(Params, TADStoredProc(Dataset).Params, False);
end;

{------------------------------------------------------------------------------}
{ Registration and factory code                                                }
{------------------------------------------------------------------------------}
var
  _driver: TDAEDriver = nil;

{------------------------------------------------------------------------------}
procedure Register;
begin
  RegisterComponents(DAPalettePageName, [TDAAnyDACDriver]);
end;

{------------------------------------------------------------------------------}
function GetDriverObject: IDADriver;
begin
  if _driver = nil then
    _driver := TDAEAnyDACDriver.Create(nil);
  result := _driver;
end;

{------------------------------------------------------------------------------}
exports
  GetDriverObject name func_GetDriverObject;

initialization
  _driver := nil;
  RegisterDriverProc(GetDriverObject);

finalization
  UnregisterDriverProc(GetDriverObject);
  FreeAndNIL(_driver);

end.
