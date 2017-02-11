{-------------------------------------------------------------------------------}
{ AnyDAC SQL command generator                                                  }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit daADPhysCmdGenerator;

interface

uses
  DB,
  daADStanIntf, daADStanOption, daADStanParam,
  daADDatSManager,
  daADPhysIntf;

type
  TADPhysCommandGenerator = class(TInterfacedObject, IADPhysCommandGenerator)
  private
    FColumn: TADDatSColumn;
    FCommand: IADPhysCommand;
    FAlias: String;
    FHasHBlobs: Boolean;
    FIdentityInsert: Boolean;
    FUpdateRowOptions: TADPhysUpdateRowOptions;
    FFillRowOptions: TADPhysFillRowOptions;
    FGenOptions: TADPhysCommandGeneratorOptions;
    FDescribeHandler: IADPhysDescribeHandler;
    FMappingHandler: IADPhysMappingHandler;
    FLastColumn: TADDatSColumn;
    FLastColumnAttrs: TADDataAttributes;
    FLastColumnOptions: TADDataOptions;
    FLastColumnObjName: String;
    function GenerateInlineRefresh(const AStmt: String;
      ARequest: TADPhysUpdateRequest): String;
    function GenerateIdentityInsert(const ATable, AStmt: String;
      ARequest: TADPhysUpdateRequest): String;
  protected
    FTable: TADDatSTable;
    FRow: TADDatSRow;
    FParams: TADParams;
    FConnMeta: IADPhysConnectionMetadata;
    FOptions: IADStanOptions;
    FCommandKind: TADPhysCommandKind;
    function GetSelectList(AAllowIdentityExp, AFlatFieldList: Boolean; var ANeedFrom: Boolean): String;
    function GetFrom: String;
    function GetWhere(AInInsert: Boolean): String;
    function GetColumn(const AParentField: String; AColumn: TADDatSColumn): String;
    function ColumnChanged(ARow: TADDatSRow; AColumn: TADDatSColumn): Boolean;
    function ColumnInKey(AColumn: TADDatSColumn): Boolean;
    function ColumnSearchable(AColumn: TADDatSColumn): Boolean;
    function ColumnStorable(AColumn: TADDatSColumn): Boolean;
    function ColumnReqRefresh(ARequest: TADPhysUpdateRequest;
      AColumn: TADDatSColumn): Boolean;
    function ColumnIsHBLOB(AColumn: TADDatSColumn): Boolean;
    function AddColumnParam(AColumn: TADDatSColumn; ANewValue: Boolean;
      AType: TParamType): String;
    function ColumnUpdatable(AColumn: TADDatSColumn): Boolean;
    function NormalizeColName(const AName: String): String;
    function NormalizeTabName(const AName: String): String;
    procedure GetColumnAttributes(AColumn: TADDatSColumn;
      var AAttrs: TADDataAttributes; var AOptions: TADDataOptions;
      var AObjName: String);
    function BRK: String;
    // IADPhysCommandGenerator
    // private
    function GetFillRowOptions: TADPhysFillRowOptions;
    function GetGenOptions: TADPhysCommandGeneratorOptions;
    function GetHasHBlobs: Boolean;
    function GetParams: TADParams;
    function GetRow: TADDatSRow;
    function GetTable: TADDatSTable;
    function GetUpdateRowOptions: TADPhysUpdateRowOptions;
    procedure SetParams(const AValue: TADParams);
    procedure SetRow(const AValue: TADDatSRow);
    procedure SetTable(const AValue: TADDatSTable);
    procedure SetUpdateRowOptions(const AValue: TADPhysUpdateRowOptions);
    function GetCol: TADDatSColumn;
    procedure SetCol(const AValue: TADDatSColumn);
    procedure SetFillRowOptions(const AValue: TADPhysFillRowOptions);
    procedure SetGenOptions(const AValue: TADPhysCommandGeneratorOptions);
    function GetCommandKind: TADPhysCommandKind;
    function GetOptions: IADStanOptions;
    procedure SetOptions(const AValue: IADStanOptions);
    function GetDescribeHandler: IADPhysDescribeHandler;
    procedure SetDescribeHandler(const AValue: IADPhysDescribeHandler);
    function GetMappingHandler: IADPhysMappingHandler;
    procedure SetMappingHandler(const AValue: IADPhysMappingHandler);
    // public
    function GenerateSelect: String; virtual;
    function GenerateInsert: String;
    function GenerateUpdateHBlobs: String;
    function GenerateUpdate: String;
    function GenerateDelete: String;
    function GenerateDeleteAll(ANoUndo: Boolean): String;
    function GenerateLock: String;
    function GenerateUnLock: String;
    function GenerateSavepoint(const AName: String): String;
    function GenerateRollbackToSavepoint(const AName: String): String;
    function GenerateCommitSavepoint(const AName: String): String;
    function GenerateGetLastAutoGenValue(const AName: String): String;
    function GenerateCall(const AName: String): String;
    // other
    function GetInlineRefresh(const AStmt: String;
      ARequest: TADPhysUpdateRequest): String; virtual;
    function GetIdentityInsert(const ATable, AStmt: String;
      ARequest: TADPhysUpdateRequest): String; virtual;
    function GetIdentity: String; virtual;
    function GetSingleRowTable: String; virtual;
    function GetPessimisticLock: String; virtual;
    function GetSavepoint(const AName: String): String; virtual;
    function GetRollbackToSavepoint(const AName: String): String; virtual;
    function GetCommitSavepoint(const AName: String): String; virtual;
    function GetLastAutoGenValue(const AName: String): String; virtual;
    function GetCall(const AName: String): String; virtual;
  public
    constructor Create; overload;
    constructor Create(const ACommand: IADPhysCommand); overload;
    constructor Create(const AConnection: IADPhysConnection); overload;
  end;

implementation

uses
{$IFDEF AnyDAC_D6Base}
  Variants,
{$ENDIF}
  SysUtils, Classes,
  daADStanConst, daADStanError;

{-------------------------------------------------------------------------------}
{ TADPhysCommandGenerator                                                       }
{-------------------------------------------------------------------------------}
constructor TADPhysCommandGenerator.Create;
begin
  inherited Create;
  FAlias := C_AD_CmdGenAlias;
  FFillRowOptions := [foBlobs, foDetails, foData, foAfterIns, foAfterUpd,
    foForCheck, foClear];
end;

{-------------------------------------------------------------------------------}
constructor TADPhysCommandGenerator.Create(const ACommand: IADPhysCommand);
begin
  ASSERT((ACommand <> nil) and (ACommand.Connection <> nil));
  Create;
  ACommand.Connection.CreateMetadata(FConnMeta);
  FCommand := ACommand;
  FOptions := ACommand.Options;
end;

{-------------------------------------------------------------------------------}
constructor TADPhysCommandGenerator.Create(const AConnection: IADPhysConnection);
begin
  ASSERT(AConnection <> nil);
  Create;
  AConnection.CreateMetadata(FConnMeta);
  FCommand := nil;
  FOptions := AConnection.Options;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.GetFillRowOptions: TADPhysFillRowOptions;
begin
  Result := FFillRowOptions;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.GetGenOptions: TADPhysCommandGeneratorOptions;
begin
  Result := FGenOptions;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.GetHasHBlobs: Boolean;
begin
  Result := FHasHBlobs;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.GetParams: TADParams;
begin
  Result := FParams;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.GetRow: TADDatSRow;
begin
  Result := FRow;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.GetTable: TADDatSTable;
begin
  Result := FTable;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.GetCol: TADDatSColumn;
begin
  Result := FColumn;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.GetUpdateRowOptions: TADPhysUpdateRowOptions;
begin
  Result := FUpdateRowOptions;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommandGenerator.SetCol(const AValue: TADDatSColumn);
begin
  FColumn := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommandGenerator.SetParams(const AValue: TADParams);
begin
  FParams := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommandGenerator.SetRow(const AValue: TADDatSRow);
begin
  FRow := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommandGenerator.SetTable(const AValue: TADDatSTable);
begin
  FTable := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommandGenerator.SetUpdateRowOptions(
  const AValue: TADPhysUpdateRowOptions);
begin
  FUpdateRowOptions := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommandGenerator.SetFillRowOptions(
  const AValue: TADPhysFillRowOptions);
begin
  FFillRowOptions := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommandGenerator.SetGenOptions(
  const AValue: TADPhysCommandGeneratorOptions);
begin
  FGenOptions := AValue;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.GetCommandKind: TADPhysCommandKind;
begin
  Result := FCommandKind;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.GetOptions: IADStanOptions;
begin
  Result := FOptions;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommandGenerator.SetOptions(const AValue: IADStanOptions);
begin
  FOptions := AValue;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.GetDescribeHandler: IADPhysDescribeHandler;
begin
  Result := FDescribeHandler;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommandGenerator.SetDescribeHandler(
  const AValue: IADPhysDescribeHandler);
begin
  FDescribeHandler := AValue;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.GetMappingHandler: IADPhysMappingHandler;
begin
  Result := FMappingHandler;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommandGenerator.SetMappingHandler(const AValue: IADPhysMappingHandler);
begin
  FMappingHandler := AValue;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.BRK: String;
begin
  if goBeautify in GetGenOptions then
    Result := C_AD_EOL
  else
    Result := ' ';
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.NormalizeColName(const AName: String): String;
var
  rName: TADPhysParsedName;
  eEncOpts: TADPhysEncodeOptions;
  eDecOpts: TADPhysDecodeOptions;
begin
  eDecOpts := [doNormalize, doSubObj];
  if goForceNoQuoteCol in FGenOptions then
    Include(eDecOpts, doUnquote);
  FConnMeta.DecodeObjName(AName, rName, FCommand, eDecOpts);
  eEncOpts := [];
  if goForceQuoteCol in FGenOptions then
    Include(eEncOpts, eoQuote);
  Result := FConnMeta.EncodeObjName(rName, FCommand, eEncOpts);
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.NormalizeTabName(const AName: String): String;
var
  rName: TADPhysParsedName;
  eEncOpts: TADPhysEncodeOptions;
  eDecOpts: TADPhysDecodeOptions;
begin
  eDecOpts := [doNormalize];
  if goForceNoQuoteTab in FGenOptions then
    Include(eDecOpts, doUnquote);
  FConnMeta.DecodeObjName(AName, rName, FCommand, eDecOpts);
  eEncOpts := [];
  if goForceQuoteTab in FGenOptions then
    Include(eEncOpts, eoQuote);
  Result := FConnMeta.EncodeObjName(rName, FCommand, eEncOpts);
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.GetColumn(const AParentField: String;
  AColumn: TADDatSColumn): String;
var
  eAttrs: TADDataAttributes;
  eOpts: TADDataOptions;
  sName: String;
begin
  sName := '';
  eOpts := [];
  eAttrs := [];
  GetColumnAttributes(AColumn, eAttrs, eOpts, sName);
  Result := NormalizeColName(sName);
  if AParentField <> '' then
    Result := AParentField + '.' + Result;
  if (AParentField = '') and (FAlias <> '') then
    Result := FAlias + '.' + Result;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.GetFrom: String;
var
  iTmp: Integer;
  sTmp: String;
  oTmp: TADDatSTable;
  pTable: Pointer;
  eKind: TADPhysNameKind;
begin
  if FTable = nil then begin
    pTable := nil;
    eKind := nkDefault;
  end
  else begin
    pTable := Pointer(FTable.Name);
    eKind := nkDatS;
  end;
  iTmp := 0;
  sTmp := '';
  oTmp := nil;
  Result := '';
  if (GetMappingHandler = nil) or
     (GetMappingHandler.MapRecordSet(pTable, eKind, iTmp, sTmp,
                                     sTmp, Result, oTmp) = mrDefault) then
    Result := FTable.SourceName;
  if FDescribeHandler <> nil then
    FDescribeHandler.DescribeTable(FTable, Result);
  Result := NormalizeTabName(Result);
  if Result = '' then
    ADException(Self, [S_AD_LPhys], er_AD_AccUpdateTabUndefined, []);
  if FAlias <> '' then
    Result := Result + ' ' + FAlias;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommandGenerator.GetColumnAttributes(AColumn: TADDatSColumn;
  var AAttrs: TADDataAttributes; var AOptions: TADDataOptions; var AObjName: String);
var
  eMapResult: TADPhysMappingResult;
  iTmp: Integer;
  sTmp, sUpdateName: String;
  oTmp: TADDatSColumn;
begin
  if FLastColumn = AColumn then begin
    AAttrs := FLastColumnAttrs;
    AOptions := FLastColumnOptions;
    AObjName := FLastColumnObjName;
    Exit;
  end;
  if GetMappingHandler = nil then
    eMapResult := mrDefault
  else begin
    iTmp := 0;
    sTmp := '';
    sUpdateName := '';
    oTmp := nil;
    eMapResult := GetMappingHandler.MapRecordSetColumn(Pointer(AColumn.Table), nkObj,
      Pointer(AColumn.Name), nkDatS, iTmp, sTmp, sTmp, sUpdateName, oTmp);
  end;
  case eMapResult of
  mrDefault:
    begin
      AOptions := AColumn.Options;
      AAttrs := AColumn.Attributes;
      AObjName := AColumn.SourceName;
    end;
  mrMapped:
    begin
      AOptions := AColumn.Options;
      AAttrs := AColumn.Attributes;
      AObjName := sUpdateName;
    end;
  else
    AOptions := [];
    AAttrs := [];
    AObjName := '';
  end;
  if FDescribeHandler <> nil then
    FDescribeHandler.DescribeColumn(AColumn, AAttrs, AOptions, AObjName);
  FLastColumn := AColumn;
  FLastColumnAttrs := AAttrs;
  FLastColumnOptions := AOptions;
  FLastColumnObjName := AObjName;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.ColumnStorable(AColumn: TADDatSColumn): Boolean;
var
  eAttrs: TADDataAttributes;
  eOpts: TADDataOptions;
  sName: String;
begin
  sName := '';
  eAttrs := [];
  eOpts := [];
  GetColumnAttributes(AColumn, eAttrs, eOpts, sName);
  Result :=
    ([caCalculated, caInternal, caUnnamed] * eAttrs = []) and
    (sName <> '');
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.ColumnReqRefresh(ARequest: TADPhysUpdateRequest;
  AColumn: TADDatSColumn): Boolean;
var
  eAttrs: TADDataAttributes;
  eOpts: TADDataOptions;
  sName: String;
begin
  sName := '';
  eAttrs := [];
  eOpts := [];
  GetColumnAttributes(AColumn, eAttrs, eOpts, sName);
  case ARequest of
  arInsert:
    Result := (FOptions.UpdateOptions.RefreshMode = rmAll) or
      (FOptions.UpdateOptions.RefreshMode = rmOnDemand) and (
        (coAfterInsChanged in eOpts) or
        ([caAutoInc, caCalculated, caDefault, caROWID, caRowVersion, caVolatile] * eAttrs <> [])
      );
  arUpdate:
    Result := (FOptions.UpdateOptions.RefreshMode = rmAll) or
      (FOptions.UpdateOptions.RefreshMode = rmOnDemand) and (
        (coAfterUpdChanged in eOpts) or
        ([caCalculated, caRowVersion, caVolatile] * eAttrs <> [])
      );
  arFetchRow:
    Result :=
      (foAfterIns in FFillRowOptions) and
      // following protects from [SELECT IncFld FROM MyTab WHERE IncFld IS NULL]
      not ((caAutoInc in eAttrs) and (coInKey in eOpts) and (GetIdentity = '')) and (
        (coAfterInsChanged in eOpts) or
        ([caAutoInc, caCalculated, caDefault, caROWID, caRowVersion, caVolatile] * eAttrs <> [])
      ) or
      (foAfterUpd in FFillRowOptions) and (
        (coAfterUpdChanged in eOpts) or
        ([caCalculated, caRowVersion, caVolatile] * eAttrs <> [])
      );
  else
    Result := False;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.ColumnSearchable(AColumn: TADDatSColumn): Boolean;
var
  eAttrs: TADDataAttributes;
  eOpts: TADDataOptions;
  sName: String;
begin
  sName := '';
  eAttrs := [];
  eOpts := [];
  GetColumnAttributes(AColumn, eAttrs, eOpts, sName);
  Result := ColumnStorable(AColumn) and (caSearchable in eAttrs) and
    (eOpts * [coInWhere, coInKey] <> []);
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.ColumnUpdatable(AColumn: TADDatSColumn): Boolean;
var
  eAttrs: TADDataAttributes;
  eOpts: TADDataOptions;
  sName: String;
begin
  sName := '';
  eAttrs := [];
  eOpts := [];
  GetColumnAttributes(AColumn, eAttrs, eOpts, sName);
  Result := ColumnStorable(AColumn) and (coInUpdate in eOpts);
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.ColumnChanged(ARow: TADDatSRow;
  AColumn: TADDatSColumn): Boolean;
begin
  Result := (ARow = nil) or
    not ARow.CompareColumnVersions(AColumn.Index, rvCurrent, rvOriginal);
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.ColumnInKey(AColumn: TADDatSColumn): Boolean;
var
  eAttrs: TADDataAttributes;
  eOpts: TADDataOptions;
  sName: String;
begin
  sName := '';
  eAttrs := [];
  eOpts := [];
  GetColumnAttributes(AColumn, eAttrs, eOpts, sName);
  Result := coInKey in eOpts;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.AddColumnParam(AColumn: TADDatSColumn;
  ANewValue: Boolean; AType: TParamType): String;
const
  sValAge: array[Boolean] of String = ('OLD_', 'NEW_');
var
  oParam: TADParam;
  iSize: LongWord;
  i, iPrecision: Integer;
  eType: TFieldType;
  sName: String;

  function GetColumnPath(AColumn: TADDatSColumn): String;
  var
    oCol: TADDatSColumn;
  begin
    oCol := AColumn.ParentColumn;
    if oCol <> nil then
      Result := GetColumnPath(oCol)
    else
      Result := '';
    Result := Result + '$_' + IntToStr(AColumn.Index);
  end;

begin
  if goClassicParamName in FGenOptions then
    Result := sValAge[ANewValue] + AColumn.Name
  else
    Result := sValAge[ANewValue] + 'P' + GetColumnPath(AColumn);
  if FParams <> nil then begin
    i := 0;
    sName := Result;
    while FParams.FindParam(Result) <> nil do begin
      Inc(i);
      Result := Format('%s#%d', [sName, i]);
    end;
    oParam := TADParam(FParams.Add);
    oParam.Position := FParams.Count;
    eType := ftUnknown;
    iSize := 0;
    iPrecision := 0;
    FOptions.FormatOptions.ColumnDef2FieldDef(AColumn.SourceDataType,
      AColumn.SourceScale, AColumn.SourcePrecision, AColumn.SourceSize,
      AColumn.Attributes, eType, iSize, iPrecision);
    oParam.Name := Result;
    oParam.ParamType := AType;
    oParam.DataType := eType;
    oParam.ADDataType := AColumn.SourceDataType;
    oParam.Precision := iPrecision;
    if eType in [{$IFDEF AnyDAC_D6Base}ftFMTBcd,{$ENDIF} ftBcd] then
      oParam.NumericScale := SmallInt(iSize)
    else
      oParam.Size := iSize;
  end;
  if goClassicParamName in FGenOptions then
    Result := ':' + Result
  else
    case FConnMeta.ParamMark of
    prQMark:  Result := '?';
    prNumber: Result := ':' + IntToStr(FParams.Count - 1);
    prName:   Result := ':' + Result;
    end;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.ColumnIsHBLOB(AColumn: TADDatSColumn): Boolean;
begin
  Result := AColumn.DataType in [dtHBlob, dtHBFile, dtHMemo, dtWideHMemo];
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.GetSelectList(AAllowIdentityExp, AFlatFieldList: Boolean;
  var ANeedFrom: Boolean): String;
var
  iLockMode: TADLockMode;
  iTotalLen: Integer;

  procedure ProcessDataTableFields(ATable: TADDatSTable;
    const AParentField: String; var S: String);
  var
    i: Integer;
    sField, sName: String;
    eAttrs: TADDataAttributes;
    eOpts: TADDataOptions;
    oCol: TADDatSColumn;
  begin
    for i := 0 to ATable.Columns.Count - 1 do begin
      oCol := ATable.Columns[i];
      sName := '';
      eAttrs := [];
      eOpts := [];
      GetColumnAttributes(oCol, eAttrs, eOpts, sName);
      if AFlatFieldList and (oCol.DataType = dtRowRef) then
        ProcessDataTableFields(oCol.NestedTable, GetColumn(AParentField, oCol), S)
      else if ColumnStorable(oCol) and (
        (
          (oCol.DataType in C_AD_BlobTypes) and (foBlobs in FFillRowOptions) or
          (oCol.DataType in [dtRowSetRef, dtCursorRef]) and (foDetails in FFillRowOptions) or
          (foData in FFillRowOptions)
        ) and (
          not (foForCheck in FFillRowOptions) or (
            ColumnSearchable(oCol) or
            (iLockMode = lmPessimistic) and ColumnIsHBLOB(oCol)
          )
        ) and (
          ([foAfterIns, foAfterUpd] * FFillRowOptions = []) or
          ColumnReqRefresh(arFetchRow, oCol)
        )
      ) then begin
        sField := '';
        case oCol.DataType of
        dtBlob, dtMemo, dtHBlob, dtHBFile, dtHMemo, dtWideHMemo:
          if foBlobs in FFillRowOptions then begin
            sField := GetColumn(AParentField, oCol);
            ANeedFrom := True;
          end;
        dtRowSetRef, dtCursorRef:
          if foDetails in FFillRowOptions then begin
            sField := GetColumn(AParentField, oCol);
            ANeedFrom := True;
          end;
        else
          if AAllowIdentityExp and (foAfterIns in FFillRowOptions) and
             (caAutoInc in eAttrs) and (GetIdentity <> '') then
            sField := GetIdentity + ' AS ' + NormalizeColName(sName)
          else begin
            sField := GetColumn(AParentField, oCol);
            ANeedFrom := True;
          end;
        end;
        if sField <> '' then begin
          if S <> '' then
            S := S + ', ';
          if (goBeautify in GetGenOptions) and (Length(S) - iTotalLen >= C_AD_CmdGenRight) then begin
            iTotalLen := Length(S);
            S := S + BRK + '  ';
          end;
          S := S + sField;
        end;
      end;
    end;
  end;

begin
  iLockMode := FOptions.UpdateOptions.LockMode;
  Result := '';
  ANeedFrom := False;
  iTotalLen := 0;
  if FColumn <> nil then begin
    if not AFlatFieldList and (FColumn.DataType = dtRowRef) then
      ProcessDataTableFields(FColumn.NestedTable, GetColumn('', FColumn), Result)
    else
      Result := GetColumn('', FColumn);
  end
  else
    ProcessDataTableFields(FTable, '', Result);
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.GetWhere(AInInsert: Boolean): String;
var
  iUpdMode: TUpdateMode;
  eRowVersion: TADDatSRowVersion;
  iTotalLen: Integer;

  procedure ProcessDataTableFields(ATable: TADDatSTable; ARow: TADDatSRow;
    const AParentField: String; var S: String);
  var
    i: Integer;
    oCol: TADDatSColumn;
    oNestedRow: TADDatSRow;
    eAttrs: TADDataAttributes;
    eOpts: TADDataOptions;
    sName: String;
  begin
    for i := 0 to ATable.Columns.Count - 1 do begin
      oCol := ATable.Columns[i];
      sName := '';
      eAttrs := [];
      eOpts := [];
      GetColumnAttributes(oCol, eAttrs, eOpts, sName);
      if oCol.DataType = dtRowRef then begin
        if ARow = nil then
          oNestedRow := nil
        else
          oNestedRow := ARow.NestedRow[i];
        ProcessDataTableFields(oCol.NestedTable, oNestedRow, GetColumn(AParentField, oCol), S);
      end
      else if ColumnSearchable(oCol) and
              ((iUpdMode = upWhereAll) or
               (iUpdMode = upWhereChanged) and (ColumnChanged(ARow, oCol) or ColumnInKey(oCol)) or
               (iUpdMode = upWhereKeyOnly) and ColumnInKey(oCol)) and
              not (AInInsert and (caRowVersion in eAttrs)) and
              not (AInInsert and (coAfterInsChanged in eOpts) and
                   not ((caAutoInc in eAttrs) and (GetIdentity <> ''))) then begin
        if S <> '' then
          S := S + ' AND ';
        if (goBeautify in GetGenOptions) and (Length(S) - iTotalLen >= C_AD_CmdGenRight) then begin
          iTotalLen := Length(S);
          S := S + BRK + '  ';
        end;
        if AInInsert and
           (caAutoInc in eAttrs) and (GetIdentity <> '') then
          S := S + GetColumn(AParentField, oCol) + ' = ' + GetIdentity
        else if (ARow <> nil) and VarIsNull(ARow.GetData(i, eRowVersion)) then
          S := S + GetColumn(AParentField, oCol) + ' IS NULL'
        else
          S := S + GetColumn(AParentField, oCol) + ' = ' + AddColumnParam(oCol,
            eRowVersion = rvCurrent, ptInput);
      end;
    end;
  end;

begin
  Result := '';
  if AInInsert then begin
    eRowVersion := rvCurrent;
    iUpdMode := upWhereKeyOnly;
  end
  else if foAfterUpd in FFillRowOptions then begin
    eRowVersion := rvCurrent;
    iUpdMode := FOptions.UpdateOptions.UpdateMode;
  end
  else begin
    eRowVersion := rvOriginal;
    iUpdMode := FOptions.UpdateOptions.UpdateMode;
  end;
  iTotalLen := 0;
  ProcessDataTableFields(FTable, FRow, '', Result);
  if (Result = '') and (iUpdMode = upWhereKeyOnly) then begin
    iUpdMode := upWhereAll;
    ProcessDataTableFields(FTable, FRow, '', Result);
  end;
  if Result = '' then
    ADException(Self, [S_AD_LPhys], er_AD_AccWhereIsEmpty, []);
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.GenerateInlineRefresh(const AStmt: String;
  ARequest: TADPhysUpdateRequest): String;
var
  prevFillOpts: TADPhysFillRowOptions;
begin
  prevFillOpts := FFillRowOptions;
  Include(FFillRowOptions, foData);
  if ARequest = arInsert then
    Include(FFillRowOptions, foAfterIns)
  else if ARequest = arUpdate then
    Include(FFillRowOptions, foAfterUpd);
  try
    Result := GetInlineRefresh(AStmt, ARequest);
  finally
    FFillRowOptions := prevFillOpts;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.GenerateIdentityInsert(
  const ATable, AStmt: String; ARequest: TADPhysUpdateRequest): String;
begin
  Result := GetIdentityInsert(ATable, AStmt, ARequest);
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.GenerateUpdate: String;
var
  lUpdChngFields: Boolean;
  iTotalLen: Integer;

  procedure ProcessDataTableFields(ATable: TADDatSTable; ARow: TADDatSRow;
    const AParentField: String; var S: String);
  var
    i: Integer;
    oCol: TADDatSColumn;
    lFldChng: Boolean;
  begin
    for i := 0 to ATable.Columns.Count - 1 do begin
      oCol := ATable.Columns[i];
      if ColumnUpdatable(oCol) then
        if oCol.DataType = dtRowRef then
          ProcessDataTableFields(oCol.NestedTable, ARow.NestedRow[i],
            GetColumn(AParentField, oCol), S)
        else begin
          lFldChng := not lUpdChngFields or ColumnChanged(ARow, oCol);
          if lFldChng then begin
            if S <> '' then
              S := S + ', ';
            if (goBeautify in GetGenOptions) and (Length(S) - iTotalLen >= C_AD_CmdGenRight) then begin
              iTotalLen := Length(S);
              S := S + BRK + '  ';
            end;
            S := S + GetColumn(AParentField, oCol) + ' = ';
            if FConnMeta.InsertBlobsAfterReturning then
              case oCol.DataType of
              dtHBlob:
                begin
                  FHasHBlobs := True;
                  S := S + 'EMPTY_BLOB()';
                end;
              dtHBFile:
                begin
                  FHasHBlobs := True;
                  S := S + 'BFILENAME(''' + oCol.SourceDirectory + ''', ''' +
                    VarToStr(ARow.GetData(i, rvCurrent)) + ''')';
                end;
              dtHMemo,
              dtWideHMemo:
                begin
                  FHasHBlobs := True;
                  S := S + 'EMPTY_CLOB()';
                end;
              else
                S := S + AddColumnParam(oCol, True, ptInput);
              end
            else begin
              FHasHBlobs := ColumnIsHBLOB(oCol);
              S := S + AddColumnParam(oCol, True, ptInput);
            end;
          end;
        end;
    end;
  end;

begin
  Result := '';
  FAlias := '';
  FHasHBlobs := False;
  lUpdChngFields := FOptions.UpdateOptions.UpdateChangedFields;
  iTotalLen := 0;
  ProcessDataTableFields(FTable, FRow, '', Result);
  if Result <> '' then begin
    Result := 'UPDATE ' + GetFrom + BRK + 'SET ' + Result + BRK + 'WHERE ' + GetWhere(False);
    if FConnMeta.InlineRefresh then
      Result := GenerateInlineRefresh(Result, arUpdate);
  end;
  if FCommandKind <> skUnknown then
    FCommandKind := skUpdate;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.GenerateInsert: String;
var
  s1, s2, s3, sFrom: String;
  lUpdChngFields: Boolean;
  iTotalLen: Integer;

  procedure ProcessDataTableFields(ATable: TADDatSTable; ARow: TADDatSRow;
    const AParentField: String; var AFieldList, AValueList, AFirstField: String;
    AForceAddField: Boolean);
  var
    i: Integer;
    oCol: TADDatSColumn;
    lFldChng: Boolean;
    sName, s1, s2, s3, sReserveFirst: String;
    eAttrs: TADDataAttributes;
    eOpts: TADDataOptions;
  begin
    sReserveFirst := '';
    for i := 0 to ATable.Columns.Count - 1 do begin
      oCol := ATable.Columns[i];
      sName := '';
      eAttrs := [];
      eOpts := [];
      GetColumnAttributes(oCol, eAttrs, eOpts, sName);
      if ColumnUpdatable(oCol) then begin
        if oCol.DataType = dtRowRef then begin
          s1 := '';
          s2 := '';
          ProcessDataTableFields(oCol.NestedTable, ARow.NestedRow[i],
            GetColumn(AParentField, oCol), s1, s2, AFirstField, True);
          if AFieldList <> '' then begin
            AFieldList := AFieldList + ', ';
            AValueList := AValueList + ', ';
          end;
          AFieldList := AFieldList + GetColumn(AParentField, oCol);
          AValueList := AValueList + NormalizeColName(oCol.SourceDataTypeName) +
            '(' + s2 + ')';
        end
        else begin
          lFldChng :=
            AForceAddField or
            not lUpdChngFields or ColumnChanged(ARow, oCol) or
            ColumnIsHBLOB(oCol);
          if lFldChng then begin
            if AFieldList <> '' then begin
              AFieldList := AFieldList + ', ';
              AValueList := AValueList + ', ';
              if (goBeautify in GetGenOptions) and (
                  (Length(AFieldList) - iTotalLen >= C_AD_CmdGenRight) or
                  (Length(AValueList) - iTotalLen >= C_AD_CmdGenRight)
                 ) then begin
                iTotalLen := Length(AFieldList);
                if iTotalLen < Length(AValueList) then
                  iTotalLen := Length(AValueList);
                AFieldList := AFieldList + BRK + '  ';
                AValueList := AValueList + BRK + '  ';
              end;
            end;
            if FConnMeta.InsertBlobsAfterReturning then
              case oCol.DataType of
              dtHBlob:
                begin
                  FHasHBlobs := True;
                  s3 := 'EMPTY_BLOB()';
                end;
              dtHBFile:
                begin
                  FHasHBlobs := True;
                  s3 := 'BFILENAME(''' + oCol.SourceDirectory + ''', ''' +
                    VarToStr(ARow.GetData(i, rvCurrent)) + ''')';
                end;
              dtHMemo,
              dtWideHMemo:
                begin
                  FHasHBlobs := True;
                  s3 := 'EMPTY_CLOB()';
                end;
              else
                s3 := AddColumnParam(oCol, True, ptInput);
              end
            else begin
              FHasHBlobs := ColumnIsHBLOB(oCol);
              s3 := AddColumnParam(oCol, True, ptInput);
            end;
            FIdentityInsert := FIdentityInsert or (caAutoInc in eAttrs);
            AFieldList := AFieldList + GetColumn(AParentField, oCol);
            AValueList := AValueList + s3;
          end;
          if (AFirstField = '') and (coAllowNull in eOpts) then begin
            if not (caDefault in eAttrs) then
              AFirstField := GetColumn(AParentField, oCol)
            else if sReserveFirst = '' then
              sReserveFirst := GetColumn(AParentField, oCol);
          end;
        end;
      end;
    end;
    if AFirstField = '' then
      AFirstField := sReserveFirst;
  end;

begin
  s1 := '';
  s2 := '';
  s3 := '';
  FAlias := '';
  FHasHBlobs := False;
  FIdentityInsert := False;
  lUpdChngFields := FOptions.UpdateOptions.UpdateChangedFields;
  iTotalLen := 0;
  ProcessDataTableFields(FTable, FRow, '', s1, s2, s3, False);
  sFrom := GetFrom;
  Result := 'INSERT INTO ' + sFrom + BRK;
  if s1 = '' then
    case FConnMeta.DefValuesSupported of
    dvNone:    Result := Result + '(' + s3 + ') VALUES (NULL)';
    dvDefVals: Result := Result + 'DEFAULT VALUES';
    dvDef:     Result := Result + '(' + s3 + ') VALUES (DEFAULT)';
    end
  else
    Result := Result + '(' + s1 + ')' + BRK + 'VALUES (' + s2 + ')';
  if FConnMeta.InlineRefresh or
     FHasHBlobs and FConnMeta.InsertBlobsAfterReturning then
    Result := GenerateInlineRefresh(Result, arInsert);
  if FIdentityInsert and FConnMeta.EnableIdentityInsert then
    Result := GenerateIdentityInsert(sFrom, Result, arInsert);
  if FCommandKind <> skUnknown then
    FCommandKind := skInsert;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.GenerateUpdateHBlobs: String;
var
  iTotalLen: Integer;

  procedure ProcessBlobFields(ATable: TADDatSTable; ARow: TADDatSRow;
    const AParentField: String; var S: String);
  var
    i: Integer;
    oCol: TADDatSColumn;
  begin
    for i := 0 to ATable.Columns.Count - 1 do begin
      oCol := ATable.Columns[i];
      if ColumnUpdatable(oCol) then
        if oCol.DataType = dtRowRef then
          ProcessBlobFields(oCol.NestedTable, ARow.NestedRow[i],
            GetColumn(AParentField, oCol), S)
        else if ColumnIsHBLOB(oCol) and ColumnChanged(ARow, oCol) then begin
          if S <> '' then
            S := S + ', ';
          if (goBeautify in GetGenOptions) and (Length(S) - iTotalLen >= C_AD_CmdGenRight) then begin
            iTotalLen := Length(S);
            S := S + BRK + '  ';
          end;
          S := S + GetColumn(AParentField, oCol) + ' = ' +
            AddColumnParam(oCol, True, ptInput);
        end;
    end;
  end;

begin
  Result := '';
  iTotalLen := 0;
  ProcessBlobFields(FTable, FRow, '', Result);
  if Result <> '' then
    Result := 'UPDATE ' + GetFrom + BRK + 'SET ' + Result + BRK + 'WHERE ' + GetWhere(True);
  FCommandKind := skUpdate;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.GenerateDelete: String;
begin
  FAlias := '';
  Result := 'DELETE FROM ' + GetFrom + BRK + 'WHERE ' + GetWhere(False);
  FCommandKind := skDelete;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.GenerateDeleteAll(ANoUndo: Boolean): String;
begin
  FAlias := '';
  if ANoUndo and FConnMeta.TruncateSupported then begin
    Result := 'TRUNCATE TABLE ' + GetFrom;
    FCommandKind := skOther;
  end
  else begin
    Result := 'DELETE FROM ' + GetFrom;
    FCommandKind := skDelete;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.GenerateLock: String;
var
  sList: String;
  lNeedFrom: Boolean;
begin
  FCommandKind := skSelect;
  if FOptions.UpdateOptions.LockMode = lmPessimistic then
    Result := GetPessimisticLock;
  if Result = '' then begin
    lNeedFrom := False;
    sList := GetSelectList(False, False, lNeedFrom);
    if sList <> '' then begin
      Result := 'SELECT ' + sList;
      if lNeedFrom then
        Result := Result + BRK + 'FROM ' + GetFrom + BRK + 'WHERE ' + GetWhere(False)
      else if GetSingleRowTable <> '' then
        Result := Result + ' FROM ' + GetSingleRowTable;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.GenerateUnLock: String;
begin
  Result := '';
  FCommandKind := skUnknown;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.GenerateSelect: String;
var
  sList: String;
  lNeedFrom: Boolean;
begin
  lNeedFrom := False;
  sList := GetSelectList(FConnMeta.SelectWithoutFrom, False, lNeedFrom);
  if sList <> '' then begin
    Result := 'SELECT ' + sList;
    if lNeedFrom then
      Result := Result + BRK + 'FROM ' + GetFrom + BRK + 'WHERE ' +
        GetWhere(foAfterIns in FFillRowOptions)
    else if GetSingleRowTable <> '' then
      Result := Result + ' FROM ' + GetSingleRowTable;
  end;
  FCommandKind := skSelect;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.GenerateSavepoint(const AName: String): String;
begin
  FCommandKind := skOther;
  Result := GetSavepoint(AName);
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.GenerateRollbackToSavepoint(const AName: String): String;
begin
  FCommandKind := skOther;
  Result := GetRollbackToSavepoint(AName);
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.GenerateCommitSavepoint(const AName: String): String;
begin
  FCommandKind := skOther;
  Result := GetCommitSavepoint(AName);
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.GenerateGetLastAutoGenValue(
  const AName: String): String;
begin
  FCommandKind := skSelect;
  Result := GetLastAutoGenValue(AName);
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.GenerateCall(const AName: String): String;
begin
  FCommandKind := skExecute;
  Result := GetCall(AName);
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.GetInlineRefresh(const AStmt: String;
  ARequest: TADPhysUpdateRequest): String;
begin
  // overridden by MSSQL, Oracle, DB2 descendant classes
  Result := AStmt;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.GetIdentityInsert(const ATable, AStmt: String;
  ARequest: TADPhysUpdateRequest): String;
begin
  // overridden by MSSQL descendant class
  Result := AStmt;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.GetIdentity: String;
begin
  // overridden by MSSQL, MySQL, ADS descendant classes
  Result := '';
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.GetSingleRowTable: String;
begin
  // overridden by Oracle, ADS descendant classes
  Result := '';
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.GetPessimisticLock: String;
begin
  // overridden by Oracle, MSSQL, MySQL descendant classes
  Result := '';
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.GetRollbackToSavepoint(const AName: String): String;
begin
  // overridden by Oracle, MSSQL, MySQL descendant classes
  Result := '';
  ADCapabilityNotSupported(Self, [S_AD_LPhys]);
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.GetCommitSavepoint(const AName: String): String;
begin
  // overridden by DB2 descendant classes
  Result := '';
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.GetSavepoint(const AName: String): String;
begin
  // overridden by Oracle, MSSQL, MySQL descendant classes
  Result := '';
  ADCapabilityNotSupported(Self, [S_AD_LPhys]);
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.GetLastAutoGenValue(const AName: String): String;
var
  sIdent: String;
begin
  sIdent := GetIdentity;
  if sIdent <> '' then begin
    Result := 'SELECT ' + sIdent;
    if GetSingleRowTable <> '' then
      Result := Result + ' FROM ' + GetSingleRowTable;
  end
  else
    ADCapabilityNotSupported(Self, [S_AD_LPhys]);
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandGenerator.GetCall(const AName: String): String;
begin
  // overridden by all descendant classes
  Result := '';
  ADCapabilityNotSupported(Self, [S_AD_LPhys]);
end;

end.
