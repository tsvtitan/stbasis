{-------------------------------------------------------------------------------}
{ AnyDAC Component Layer: TADMetaInfoQuery tests                                }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit ADQACompLayerMTI;

interface

uses
  Classes, Windows, SysUtils, DB, IniFiles,
  ADQAPack, ADQACompLayerCNN,
  daADStanIntf, daADStanOption, daADStanParam,
  daADDatSManager,
  daADGUIxIntf,
  daADPhysIntf,
  daADDAptIntf,
  daADCompClient;

type
  TADQACompMTITsHolder = class (TADQACompTsHolderBase)
  private
    FMetaQuery:  TADMetaInfoQuery;
    FIni: TIniFile;
    procedure CheckCatalogAndSchema(AMes: String);
    procedure CheckIndexData(AMeta: TADMetaInfoQuery;
      AMetaInfoKind: TADPhysMetaInfoKind);
    procedure CheckIndexFieldsData(AMeta: TADMetaInfoQuery;
      AMetaInfoKind: TADPhysMetaInfoKind);
    function CheckIndexFieldsStructure(AMeta: TADMetaInfoQuery): Boolean;
    function CheckIndexStructure(AMeta: TADMetaInfoQuery): Boolean;
    procedure CheckPackagesData(AMeta: TADMetaInfoQuery);
    function CheckPackagesStructure(AMeta: TADMetaInfoQuery): Boolean;
    procedure CheckProcArgsData(AMeta: TADMetaInfoQuery; APackaged: Boolean);
    function CheckProcArgsStructure(AMeta: TADMetaInfoQuery): Boolean;
    procedure CheckProcsData(AMeta: TADMetaInfoQuery; APackaged: Boolean);
    function CheckProcsStructure(AMeta: TADMetaInfoQuery): Boolean;
    procedure CheckTableData(AMeta: TADMetaInfoQuery; AWildcard: Boolean);
    procedure CheckTableFieldsData(AMeta: TADMetaInfoQuery);
    function CheckTableFieldsStructure(AMeta: TADMetaInfoQuery): Boolean;
    function CheckTableStructure(AMeta: TADMetaInfoQuery): Boolean;
    function GetNorthWithRLCommas(ANum: Integer): String;
    function OraServerLess81: Boolean;
    function WrongName(ANum: Integer; AName: String): Boolean;
    function WrongType(ANum: Integer; AType: TFieldType): Boolean;
  public
    procedure RegisterTests; override;
    function RunBeforeTest: Boolean; override;
    procedure ClearAfterTest; override;
    procedure TestPackages;
    procedure TestProcArgs;
    procedure TestPackagedProcs;
    procedure TestProcs;
    procedure TestPackagedProcArgs;
    procedure TestTables;
    procedure TestTableFields;
    procedure TestIndexes;
    procedure TestPrimaryKey;
    procedure TestIndexFields;
    procedure TestPKFields;
  end;

implementation

uses
{$IFDEF AnyDAC_D6}
  Variants, FMTBcd, SqlTimSt,
{$ELSE}
  ActiveX, ComObj,
{$ENDIF}  
  ADQAConst, ADQAUtils,
  daADStanUtil, daADStanConst, daADStanError, daADCompDataSet;

{-------------------------------------------------------------------------------}
{ TADQAPhysTsHolder                                                             }
{-------------------------------------------------------------------------------}
procedure TADQACompMTITsHolder.RegisterTests;
begin
  RegisterTest('MetaInfoQuery;Tables;DB2',       TestTables, mkDB2);
  RegisterTest('MetaInfoQuery;Tables;MS Access', TestTables, mkMSAccess);
  RegisterTest('MetaInfoQuery;Tables;MSSQL',     TestTables, mkMSSQL);
  RegisterTest('MetaInfoQuery;Tables;ASA',       TestTables, mkASA);
  RegisterTest('MetaInfoQuery;Tables;MySQL',     TestTables, mkMySQL);
  RegisterTest('MetaInfoQuery;Tables;Oracle',    TestTables, mkOracle);

  RegisterTest('MetaInfoQuery;TableFields;DB2',       TestTableFields, mkDB2);
  RegisterTest('MetaInfoQuery;TableFields;MS Access', TestTableFields, mkMSAccess);
  RegisterTest('MetaInfoQuery;TableFields;MSSQL',     TestTableFields, mkMSSQL);
  RegisterTest('MetaInfoQuery;TableFields;ASA',       TestTableFields, mkASA);
  RegisterTest('MetaInfoQuery;TableFields;MySQL',     TestTableFields, mkMySQL);
  RegisterTest('MetaInfoQuery;TableFields;Oracle',    TestTableFields, mkOracle);

  RegisterTest('MetaInfoQuery;PrimaryKey;DB2',       TestPrimaryKey, mkDB2);
  RegisterTest('MetaInfoQuery;PrimaryKey;MS Access', TestPrimaryKey, mkMSAccess);
  RegisterTest('MetaInfoQuery;PrimaryKey;MSSQL',     TestPrimaryKey, mkMSSQL);
  RegisterTest('MetaInfoQuery;PrimaryKey;ASA',       TestPrimaryKey, mkASA);
  RegisterTest('MetaInfoQuery;PrimaryKey;MySQL',     TestPrimaryKey, mkMySQL);
  RegisterTest('MetaInfoQuery;PrimaryKey;Oracle',    TestPrimaryKey, mkOracle);

  RegisterTest('MetaInfoQuery;PrimaryKeyFields;DB2',       TestPKFields, mkDB2);
  RegisterTest('MetaInfoQuery;PrimaryKeyFields;MS Access', TestPKFields, mkMSAccess);
  RegisterTest('MetaInfoQuery;PrimaryKeyFields;MSSQL',     TestPKFields, mkMSSQL);
  RegisterTest('MetaInfoQuery;PrimaryKeyFields;ASA',       TestPKFields, mkASA);
  RegisterTest('MetaInfoQuery;PrimaryKeyFields;MySQL',     TestPKFields, mkMySQL);
  RegisterTest('MetaInfoQuery;PrimaryKeyFields;Oracle',    TestPKFields, mkOracle);

  RegisterTest('MetaInfoQuery;Indexes;DB2',       TestIndexes, mkDB2);
  RegisterTest('MetaInfoQuery;Indexes;MS Access', TestIndexes, mkMSAccess);
  RegisterTest('MetaInfoQuery;Indexes;MSSQL',     TestIndexes, mkMSSQL);
  RegisterTest('MetaInfoQuery;Indexes;ASA',       TestIndexes, mkASA);
  RegisterTest('MetaInfoQuery;Indexes;MySQL',     TestIndexes, mkMySQL);
  RegisterTest('MetaInfoQuery;Indexes;Oracle',    TestIndexes, mkOracle);

  RegisterTest('MetaInfoQuery;IndexFields;DB2',       TestIndexFields, mkDB2);
  RegisterTest('MetaInfoQuery;IndexFields;MS Access', TestIndexFields, mkMSAccess);
  RegisterTest('MetaInfoQuery;IndexFields;MSSQL',     TestIndexFields, mkMSSQL);
  RegisterTest('MetaInfoQuery;IndexFields;ASA',       TestIndexFields, mkASA);
  RegisterTest('MetaInfoQuery;IndexFields;MySQL',     TestIndexFields, mkMySQL);
  RegisterTest('MetaInfoQuery;IndexFields;Oracle',    TestIndexFields, mkOracle);

  RegisterTest('MetaInfoQuery;Packages-Ora;Pack',  TestPackages, mkOracle);
  RegisterTest('MetaInfoQuery;Packages-Ora;Procs', TestPackagedProcs, mkOracle);
  RegisterTest('MetaInfoQuery;Packages-Ora;Args',  TestPackagedProcArgs, mkOracle);

  RegisterTest('MetaInfoQuery;Procs;DB2',    TestProcs, mkDB2);
  RegisterTest('MetaInfoQuery;Procs;MSSQL',  TestProcs, mkMSSQL);
  RegisterTest('MetaInfoQuery;Procs;ASA',    TestProcs, mkASA);
  RegisterTest('MetaInfoQuery;Procs;Oracle', TestProcs, mkOracle);

  RegisterTest('MetaInfoQuery;ProcArgs;DB2',    TestProcArgs, mkDB2);
  RegisterTest('MetaInfoQuery;ProcArgs;MSSQL',  TestProcArgs, mkMSSQL);
  RegisterTest('MetaInfoQuery;ProcArgs;ASA',    TestProcArgs, mkASA);
  RegisterTest('MetaInfoQuery;ProcArgs;Oracle', TestProcArgs, mkOracle);
end;

{-------------------------------------------------------------------------------}
procedure TADQACompMTITsHolder.ClearAfterTest;
begin
  FMetaQuery.Free;
  FMetaQuery := nil;
  FIni.Free;
  FIni := nil;
  inherited ClearAfterTest;
end;

{-------------------------------------------------------------------------------}
function TADQACompMTITsHolder.RunBeforeTest: Boolean;
begin
  Result := inherited RunBeforeTest;
  if FMetaQuery = nil then begin
    FMetaQuery := TADMetaInfoQuery.Create(nil);
    FMetaQuery.Connection := FConnection;
  end;
  FIni := TIniFile.Create('.\ADQAMetaInfo.ini');
end;

{-------------------------------------------------------------------------------}
function TADQACompMTITsHolder.WrongName(ANum: Integer; AName: String): Boolean;
begin
  Error(WrongColumnName(FMetaQuery.Fields[ANum].FieldName, AName));
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADQACompMTITsHolder.WrongType(ANum: Integer; AType: TFieldType): Boolean;
begin
  Error(WrongColumnType(ANum, FldTypeNames[AType],
        FldTypeNames[FMetaQuery.Fields[ANum].DataType]));
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADQACompMTITsHolder.GetNorthWithRLCommas(ANum: Integer): String;
var
  oConnMeta: IADPhysConnectionMetaData;
begin
  FConnIntf.CreateMetadata(oConnMeta);
  Result := oConnMeta.NameQuotaChar1 + NorthWind[ANum] + oConnMeta.NameQuotaChar2;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompMTITsHolder.CheckCatalogAndSchema(AMes: String);
var
  oStrList: TStrings;
  V1, V2: Variant;
  j: Integer;
begin
  oStrList := TStringList.Create;
  try
    j := FMetaQuery.RecNo - 1;
    V1 := VarToValue(FMetaQuery[C_CATALOG_NAME], '');
    V2 := FIni.ReadString(C_AD_PhysRDBMSKinds[FRDBMSKind], 'Catalog', '');
    if FRDBMSKind = mkMSAccess then
      V2 := ExpandFileName(ADExpandStr(V2));
    if AnsiCompareText(V1, V2) <> 0 then
      Error(WrongValueInColumnMeta(C_CATALOG_NAME, j, AMes, '',
            C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));

    V1 := VarToValue(FMetaQuery[C_SCHEMA_NAME], '');
    V2 := FIni.ReadString(C_AD_PhysRDBMSKinds[FRDBMSKind], 'Schema', '');
    if AnsiCompareText(V1, V2) <> 0 then
      Error(WrongValueInColumnMeta(C_SCHEMA_NAME, j, AMes, '',
            C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));
  finally
    oStrList.Free;
  end;
end;

{-------------------------------------------------------------------------------}
function TADQACompMTITsHolder.OraServerLess81: Boolean;
var
  oMetaData: IADPhysConnectionMetaData;
begin
  FConnIntf.CreateMetadata(oMetaData);
  Result := oMetaData.ServerVersion < cvOracle81000;
end;

{-------------------------------------------------------------------------------}
// mkTables

function TADQACompMTITsHolder.CheckTableStructure(AMeta: TADMetaInfoQuery): Boolean;
begin
  with AMeta do begin
    Result := CheckColumnsCount(Table, 6);
    if not Result then
      Exit;
    if AnsiCompareText(Fields[0].FieldName, C_RECNO)        <> 0 then Result := WrongName(0, C_RECNO);
    if AnsiCompareText(Fields[1].FieldName, C_CATALOG_NAME) <> 0 then Result := WrongName(1, C_CATALOG_NAME);
    if AnsiCompareText(Fields[2].FieldName, C_SCHEMA_NAME)  <> 0 then Result := WrongName(2, C_SCHEMA_NAME);
    if AnsiCompareText(Fields[3].FieldName, C_TABLE_NAME)   <> 0 then Result := WrongName(3, C_TABLE_NAME);
    if AnsiCompareText(Fields[4].FieldName, C_TABLE_TYPE)   <> 0 then Result := WrongName(4, C_TABLE_TYPE);
    if AnsiCompareText(Fields[5].FieldName, C_TABLE_SCOPE)  <> 0 then Result := WrongName(5, C_TABLE_SCOPE);
    if Fields[0].DataType <> ftInteger  then Result := WrongType(0, ftInteger);
    if Fields[1].DataType <> ftString   then Result := WrongType(1, ftString);
    if Fields[2].DataType <> ftString   then Result := WrongType(2, ftString);
    if Fields[3].DataType <> ftString   then Result := WrongType(3, ftString);
    if Fields[4].DataType <> ftSmallInt then Result := WrongType(4, ftSmallInt);
    if Fields[5].DataType <> ftSmallInt then Result := WrongType(5, ftSmallInt);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompMTITsHolder.CheckTableData(AMeta: TADMetaInfoQuery; AWildcard: Boolean);
var
  sMes: String;
  k, i, j: Integer;
  lFound: Boolean;
  V1, V2: Variant;
begin
  sMes := 'kind = mkTables';
  if AWildcard then begin
    k := WildCardRes_cnt;
    if AMeta.RecordCount <> k then begin
      Error('Wildcard doesn''t work. ' + WrongRowCount(k, AMeta.RecordCount));
      Exit;
    end;
  end
  else
    k := North_tab_cnt;
  for i := 0 to k - 1 do begin
    lFound := False;
    AMeta.First;
    while not AMeta.Eof do begin
      if not AWildcard then begin
        if (AnsiCompareText(AMeta.Fields[3].AsString, NorthWind[i]) <> 0) then begin
          AMeta.Next;
          continue;
        end
      end
      else
        if (AnsiCompareText(AMeta.Fields[3].AsString, WildCardResult[i]) <> 0) then begin
          AMeta.Next;
          continue;
        end;

      CheckCatalogAndSchema(sMes);
      j := FMetaQuery.RecNo - 1;

      V1 := AMeta[C_TABLE_TYPE];
      V2 := Ord(mkTables);
      if Compare(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_TABLE_TYPE, j, sMes, '',
              C_AD_PhysRDBMSKinds[FRDBMSKind],
              VarToStr(V1), VarToStr(V2)));

      V1 := AMeta[C_TABLE_SCOPE];
      V2 := Ord(osMy);
      if Compare(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_TABLE_SCOPE, j, sMes + ' (' +
              AMeta.Fields[3].AsString + ')', '',
              C_AD_PhysRDBMSKinds[FRDBMSKind], ObjScopes[TADPhysObjectScope(V1)],
              ObjScopes[osMy]));
      lFound := True;
      AMeta.Next;
    end;
    if not lFound then
      if not AWildcard then
        Error(TableNotFound(NorthWind[i]))
      else
        Error(TableNotFound(WildCardResult[i]));
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompMTITsHolder.TestTables;
begin
  with FMetaQuery do
  try
    // retrieving info about the tables
    MetaInfoKind := mkTables;
    ObjectScopes := [osMy, osSystem];
    TableKinds   := [tkTable, tkView];
    try
      Open;
    except
      on E: Exception do begin
        Error(ErrorMetaCommPrepare(E.Message));
        Exit;
      end;
    end;
    if CheckTableStructure(FMetaQuery) then
      CheckTableData(FMetaQuery, False);
    Close;

    // check work of wildcard
    MetaInfoKind := mkTables;
    ObjectScopes := [osMy, osSystem];
    TableKinds   := [tkTable];
    Wildcard     := WildcardStr;
    try
      Open;
    except
      on E: Exception do begin
        Error(ErrorMetaCommPrepare(E.Message));
        Exit;
      end;
    end;
    if CheckTableStructure(FMetaQuery) then
      CheckTableData(FMetaQuery, True);
  finally
    Disconnect;
    Wildcard := '';
  end;
end;

{-------------------------------------------------------------------------------}
// mkTableFields

function TADQACompMTITsHolder.CheckTableFieldsStructure(AMeta: TADMetaInfoQuery): Boolean;
begin
  with AMeta do begin
    Result := CheckColumnsCount(AMeta.Table, 12);
    if not Result then
      Exit;
    if AnsiCompareText(Fields[0].FieldName,  C_RECNO)             <> 0 then Result := WrongName(0, C_RECNO);
    if AnsiCompareText(Fields[1].FieldName,  C_CATALOG_NAME)      <> 0 then Result := WrongName(1, C_CATALOG_NAME);
    if AnsiCompareText(Fields[2].FieldName,  C_SCHEMA_NAME)       <> 0 then Result := WrongName(2, C_SCHEMA_NAME);
    if AnsiCompareText(Fields[3].FieldName,  C_TABLE_NAME)        <> 0 then Result := WrongName(3, C_TABLE_NAME);
    if AnsiCompareText(Fields[4].FieldName,  C_COLUMN_NAME)       <> 0 then Result := WrongName(4, C_COLUMN_NAME);
    if AnsiCompareText(Fields[5].FieldName,  C_COLUMN_POSITION)   <> 0 then Result := WrongName(5, C_COLUMN_POSITION);
    if AnsiCompareText(Fields[6].FieldName,  C_COLUMN_DATATYPE)   <> 0 then Result := WrongName(6, C_COLUMN_DATATYPE);
    if AnsiCompareText(Fields[7].FieldName,  C_COLUMN_TYPENAME)   <> 0 then Result := WrongName(7, C_COLUMN_TYPENAME);
    if AnsiCompareText(Fields[8].FieldName,  C_COLUMN_ATTRIBUTES) <> 0 then Result := WrongName(8, C_COLUMN_ATTRIBUTES);
    if AnsiCompareText(Fields[9].FieldName,  C_COLUMN_PRECISION)  <> 0 then Result := WrongName(9, C_COLUMN_PRECISION);
    if AnsiCompareText(Fields[10].FieldName, C_COLUMN_SCALE)      <> 0 then Result := WrongName(10, C_COLUMN_SCALE);
    if AnsiCompareText(Fields[11].FieldName, C_COLUMN_LENGTH)     <> 0 then Result := WrongName(11, C_COLUMN_LENGTH);
    if Fields[0].DataType  <> ftInteger   then Result := WrongType(0,  ftInteger);
    if Fields[1].DataType  <> ftString    then Result := WrongType(1,  ftString);
    if Fields[2].DataType  <> ftString    then Result := WrongType(2,  ftString);
    if Fields[3].DataType  <> ftString    then Result := WrongType(3,  ftString);
    if Fields[4].DataType  <> ftString    then Result := WrongType(4,  ftString);
    if Fields[5].DataType  <> ftSmallInt  then Result := WrongType(5,  ftSmallInt);
    if Fields[6].DataType  <> ftSmallInt  then Result := WrongType(6,  ftSmallInt);
    if Fields[7].DataType  <> ftString    then Result := WrongType(7,  ftString);
    if Fields[8].DataType  <> ftInteger   then Result := WrongType(8,  ftInteger);
    if Fields[9].DataType  <> ftSmallInt  then Result := WrongType(9,  ftSmallInt);
    if Fields[10].DataType <> ftSmallInt  then Result := WrongType(10, ftSmallInt);
    if Fields[11].DataType <> ftInteger   then Result := WrongType(11, ftInteger);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompMTITsHolder.CheckTableFieldsData(AMeta: TADMetaInfoQuery);
var
  sMes, sObj, sTypeName: String;
  V1, V2: Variant;
  j: Integer;
begin
  AMeta.First;
  if AnsiCompareText(AMeta.Fields[3].AsString, 'Categories') = 0 then begin
    sMes := 'kind = mkTableFields';
    sObj := 'Categories';
    while not AMeta.Eof do begin
      CheckCatalogAndSchema(sMes);
      j := FMetaQuery.RecNo - 1;

      V1 := VarToValue(AMeta[C_COLUMN_NAME], '');
      V2 := Categ_field_name[j];
      if AnsiCompareText(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_COLUMN_NAME, j, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));

      V1 := VarToValue(AMeta[C_COLUMN_POSITION], '');
      V2 := j + 1;
      if Compare(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_COLUMN_POSITION, j, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind],
              VarToStr(V1), VarToStr(V2)));

      V1 := VarToValue(AMeta[C_COLUMN_DATATYPE], '');
      V2 := Categ_DType[FRDBMSKind, j];
      if AnsiCompareText(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_COLUMN_DATATYPE, j, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind],
              ADDataTypesNames[TADDataType(V1)],
              ADDataTypesNames[TADDataType(V2)]));

      V1 := VarToValue(AMeta[C_COLUMN_TYPENAME], '');
      V2 := Categ_Types[FRDBMSKind, j];
      if (AnsiCompareText(V2, _INT) <> 0) and
         (AnsiCompareText(V2, _IMAGE) <> 0) then begin
        if AnsiCompareText(V1, V2) <> 0 then
          Error(WrongTypeValueMeta(C_COLUMN_TYPENAME, V2, sMes, sObj,
                C_AD_PhysRDBMSKinds[FRDBMSKind],
                VarToStr(V1), VarToStr(V2)));
      end
      else begin
        if AnsiCompareText(V2, _INT) = 0 then
          if Pos(_INT, AnsiUpperCase(V1)) < 0 then
            Error(WrongTypeValueMeta(C_COLUMN_TYPENAME, V2, sMes, sObj,
                  C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));
        if AnsiCompareText(V2, _IMAGE) = 0 then
          if not((AnsiCompareText(V1, _IMAGE) <> 0) or
             (AnsiCompareText(V1, _VARBINARY) <> 0)) then
            Error(WrongTypeValueMeta(C_COLUMN_TYPENAME, V2, sMes, sObj,
                  C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));
      end;
      sTypeName := V2;

      V1 := AMeta[C_COLUMN_ATTRIBUTES];
      V2 := Categ_Col_attr[FRDBMSKind, j];
      if Compare(V1, V2) <> 0 then
        Error(WrongTypeValueMeta(C_COLUMN_ATTRIBUTES, sTypeName, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind],
              VarToStr(V1), VarToStr(V2)));

      V1 := VarToValue(AMeta[C_COLUMN_PRECISION], 0);
      V2 := Categ_Col_prec[FRDBMSKind, j];
      if Compare(V1, V2) <> 0 then
        Error(WrongTypeValueMeta(C_COLUMN_PRECISION, sTypeName, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind],
              VarToStr(V1), VarToStr(V2)));

      V1 := VarToValue(AMeta[C_COLUMN_SCALE], 0);
      V2 := Categ_Col_scal[FRDBMSKind, j];
      if Compare(V1, V2) <> 0 then
        Error(WrongTypeValueMeta(C_COLUMN_SCALE, sTypeName, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind],
              VarToStr(V1), VarToStr(V2)));

      V1 := VarToValue(AMeta[C_COLUMN_LENGTH], 0);
      V2 := Categ_Col_len[FRDBMSKind, j];
      if (AnsiCompareText(sTypeName, _NTEXT) <> 0) and
         (AnsiCompareText(sTypeName, _IMAGE) <> 0) then begin
        if Compare(V1, V2) <> 0 then
          Error(WrongTypeValueMeta(C_COLUMN_LENGTH, sTypeName, sMes, sObj,
                C_AD_PhysRDBMSKinds[FRDBMSKind],
                VarToStr(V1), VarToStr(V2)));
      end
      else begin
        if AnsiCompareText(sTypeName, _IMAGE) = 0 then
          if not((Compare(V1, 0) = 0) or (Compare(V1, 2147483647) = 0)) then
            Error(WrongTypeValueMeta(C_PARAM_LENGTH, sTypeName,
                  sMes, '', C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
                  '0 or 2147483647'));
        if AnsiCompareText(sTypeName, _NTEXT) = 0 then
          if not((Compare(V1, 0) = 0) or
             (Compare(V1, 1073741823) = 0) or
             (Compare(V1, 2147483647) = 0)) then
            Error(WrongTypeValueMeta(C_PARAM_LENGTH, sTypeName,
                  sMes, '', C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
                  '0 or 1073741823 or 2147483647'));
      end;
      AMeta.Next;
    end;
  end;

  AMeta.First;
  if AnsiCompareText(AMeta.Fields[3].AsString, 'Order details') = 0 then begin
    sMes := 'kind = mkTableFields';
    sObj := 'Order details';
    while not AMeta.Eof do begin
      CheckCatalogAndSchema(sMes);
      j := FMetaQuery.RecNo - 1;

      V1 := VarToValue(AMeta[C_COLUMN_NAME], '');
      V2 := OrdDet_field_name[j];
      if AnsiCompareText(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_COLUMN_NAME, j, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));

      V1 := VarToValue(AMeta[C_COLUMN_POSITION], 0);
      V2 := j + 1;
      if Compare(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_COLUMN_POSITION, j, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind],
              VarToStr(V1), VarToStr(V2)));

      V1 := AMeta[C_COLUMN_DATATYPE];
      V2 := OrdDet_DType[FRDBMSKind, j];
      if V2 <> 12 then begin {dtBCD}
        if AnsiCompareText(V1, V2) <> 0 then
          Error(WrongValueInColumnMeta(C_COLUMN_DATATYPE, j, sMes, sObj,
                C_AD_PhysRDBMSKinds[FRDBMSKind],
                ADDataTypesNames[TADDataType(V1)],
                ADDataTypesNames[TADDataType(V2)]));
      end
      else if (V1 <> 12) and (V1 <> 13) then
          Error(WrongValueInColumnMeta(C_COLUMN_DATATYPE, j, sMes, sObj,
                C_AD_PhysRDBMSKinds[FRDBMSKind],
                ADDataTypesNames[TADDataType(V1)], 'dtBCD or dtFmtBCD'));

      V1 := VarToValue(AMeta[C_COLUMN_TYPENAME], '');
      V2 := OrdDet_Types[FRDBMSKind, j];
      if (AnsiCompareText(V2, _INT) <> 0) and
         (AnsiCompareText(V2, _MONEY) <> 0) then begin
        if AnsiCompareText(V1, V2) <> 0 then
          Error(WrongTypeValueMeta(C_COLUMN_TYPENAME, V2, sMes, sObj,
                C_AD_PhysRDBMSKinds[FRDBMSKind],
                VarToStr(V1), VarToStr(V2)));
      end
      else begin
        if AnsiCompareText(V2, _INT) = 0 then
          if Pos(_INT, AnsiUpperCase(V1)) < 0 then
            Error(WrongTypeValueMeta(C_COLUMN_TYPENAME, V2, sMes, sObj,
                  C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));
        if AnsiCompareText(V2, _MONEY) = 0 then
          if not((AnsiCompareText(V1, _MONEY) <> 0) or
             (AnsiCompareText(V1, _NUMERIC) <> 0)) then
            Error(WrongTypeValueMeta(C_COLUMN_TYPENAME, V2, sMes, sObj,
                  C_AD_PhysRDBMSKinds[FRDBMSKind], V1, 'money or numeric'));
      end;
      sTypeName := V2;

      V1 := AMeta[C_COLUMN_ATTRIBUTES];
      V2 := OrdDet_Col_attr[FRDBMSKind, j];
      if Compare(V1, V2) <> 0 then
        Error(WrongTypeValueMeta(C_COLUMN_ATTRIBUTES, sTypeName, sMes,
              sObj, C_AD_PhysRDBMSKinds[FRDBMSKind],
              VarToStr(V1), VarToStr(V2)));

      V1 := VarToValue(AMeta[C_COLUMN_PRECISION], 0);
      V2 := OrdDet_Col_prec[FRDBMSKind, j];
      if Compare(V1, V2) <> 0 then
        Error(WrongTypeValueMeta(C_COLUMN_PRECISION, sTypeName, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind],
              VarToStr(V1), VarToStr(V2)));

      V1 := VarToValue(AMeta[C_COLUMN_SCALE], 0);
      V2 := OrdDet_Col_scal[FRDBMSKind, j];
      if Compare(V1, V2) <> 0 then
        Error(WrongTypeValueMeta(C_COLUMN_SCALE, sTypeName, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind],
              VarToStr(V1), VarToStr(V2)));

      V1 := VarToValue(AMeta[C_COLUMN_LENGTH], 0);
      V2 := OrdDet_Col_len[FRDBMSKind, j];
      if Compare(V1, V2) <> 0 then
        Error(WrongTypeValueMeta(C_COLUMN_LENGTH, sTypeName, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind],
              VarToStr(V1), VarToStr(V2)));
      AMeta.Next;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompMTITsHolder.TestTableFields;
var
  i: Integer;
begin
  with FMetaQuery do
  try
    for i := 0 to North_tab_cnt - 1 do begin
      if not (i in [0, 6]) then {Categories, Order Details}
        continue;
      ObjectName   := GetNorthWithRLCommas(i);
      MetaInfoKind := mkTableFields;
      try
        Open;
      except
        on E: Exception do begin
          Error(ErrorMetaCommPrepare(E.Message));
          Exit;
        end;
      end;
      if CheckTableFieldsStructure(FMetaQuery) then
        CheckTableFieldsData(FMetaQuery);
    end;
  finally
    Disconnect;
  end;
end;

{-------------------------------------------------------------------------------}
// mkIndexes, mkPrimaryKey

function TADQACompMTITsHolder.CheckIndexStructure(AMeta: TADMetaInfoQuery): Boolean;
begin
  with AMeta do begin
    Result := CheckColumnsCount(AMeta.Table, 7);
    if not Result then
      Exit;
    if AnsiCompareText(Fields[0].FieldName, C_RECNO)        <> 0 then Result := WrongName(0, C_RECNO);
    if AnsiCompareText(Fields[1].FieldName, C_CATALOG_NAME) <> 0 then Result := WrongName(1, C_CATALOG_NAME);
    if AnsiCompareText(Fields[2].FieldName, C_SCHEMA_NAME)  <> 0 then Result := WrongName(2, C_SCHEMA_NAME);
    if AnsiCompareText(Fields[3].FieldName, C_TABLE_NAME)   <> 0 then Result := WrongName(3, C_TABLE_NAME);
    if AnsiCompareText(Fields[4].FieldName, C_INDEX_NAME)   <> 0 then Result := WrongName(4, C_INDEX_NAME);
    if AnsiCompareText(Fields[5].FieldName, C_PKEY_NAME)    <> 0 then Result := WrongName(5, C_PKEY_NAME);
    if AnsiCompareText(Fields[6].FieldName, C_INDEX_TYPE)   <> 0 then Result := WrongName(6, C_INDEX_TYPE);
    if Fields[0].DataType <> ftInteger   then Result := WrongType(0, ftInteger);
    if Fields[1].DataType <> ftString    then Result := WrongType(1, ftString);
    if Fields[2].DataType <> ftString    then Result := WrongType(2, ftString);
    if Fields[3].DataType <> ftString    then Result := WrongType(3, ftString);
    if Fields[4].DataType <> ftString    then Result := WrongType(4, ftString);
    if Fields[5].DataType <> ftString    then Result := WrongType(5, ftString);
    if Fields[6].DataType <> ftSmallInt  then Result := WrongType(6, ftSmallInt);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompMTITsHolder.CheckIndexData(AMeta: TADMetaInfoQuery;
  AMetaInfoKind: TADPhysMetaInfoKind);
var
  sMes, sObj: String;
  V1, V2: Variant;
  j: Integer;
begin
  if AMetaInfoKind = mkIndexes then
    sMes := 'kind = mkIndexes'
  else
    sMes := 'kind = mkPrimaryKey';
  if AMeta.RecordCount = 0 then begin
    Error(RecCountIsZero(sMes));
    Exit;
  end;
  AMeta.First;
  if AnsiCompareText(AMeta.Fields[3].AsString, 'CustomerCustomerDemo') = 0 then begin
    sObj := 'CustomerCustomerDemo';
    while not AMeta.Eof do begin
      CheckCatalogAndSchema(sMes);
      j := FMetaQuery.RecNo - 1;

      V1 := VarToValue(AMeta[C_INDEX_NAME], '');
      if AMetaInfoKind = mkIndexes then begin
        if FRDBMSKind <> mkASA then
          V2 := CustCustD_ind[FRDBMSKind, j]
        else
          if j < 2 then
            V2 := CustCustD_ind[FRDBMSKind, j + 1]
          else
            V2 := CustCustD_ind[FRDBMSKind, 0];
      end
      else begin
        if FRDBMSKind <> mkASA then
          V2 := CustCustD_ind[FRDBMSKind, j]
        else
          V2 := CustCustD_pkname[FRDBMSKind];
      end;
      if AnsiCompareText(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_INDEX_NAME, j, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));

      if j = 0 then begin
        V1 := VarToValue(AMeta[C_PKEY_NAME], '');
        V2 := CustCustD_pkname[FRDBMSKind];
        if AnsiCompareText(V1, V2) <> 0 then
          Error(WrongValueInColumnMeta(C_PKEY_NAME, j, sMes, sObj,
                C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));
      end;

      V1 := AMeta[C_INDEX_TYPE];
      V2 := CustCustD_indtp[FRDBMSKind, j];
      if Compare(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_INDEX_TYPE, j, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1), VarToStr(V2)));
      AMeta.Next;
    end;
  end;
  AMeta.First;
  if AnsiCompareText(AMeta.Fields[3].AsString, 'Order Details') = 0 then begin
    sObj := 'Orders Details';
    while not AMeta.Eof do begin
      CheckCatalogAndSchema(sMes);
      j := FMetaQuery.RecNo - 1;

      V1 := VarToValue(AMeta[C_INDEX_NAME], '');
      if AMetaInfoKind = mkIndexes then begin
        if FRDBMSKind <> mkASA then
          V2 := OrdDet_ind[FRDBMSKind, j]
        else
          if j < 2 then
            V2 := OrdDet_ind[FRDBMSKind, j + 1]
          else
            V2 := OrdDet_ind[FRDBMSKind, 0];
      end
      else begin
        if FRDBMSKind <> mkASA then
          V2 := OrdDet_ind[FRDBMSKind, j]
        else
          V2 := OrdDet_pkname[FRDBMSKind];
      end;
      if AnsiCompareText(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_INDEX_NAME, j, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));

      if j = 0 then begin
        V1 := VarToValue(AMeta[C_PKEY_NAME], '');
        V2 := OrdDet_pkname[FRDBMSKind];
        if AnsiCompareText(V1, V2) <> 0 then
          Error(WrongValueInColumnMeta(C_PKEY_NAME, j, sMes, sObj,
                C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));
      end;

      V1 := AMeta[C_INDEX_TYPE];
      V2 := OrdDet_indtp[FRDBMSKind, j];
      if Compare(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_INDEX_TYPE, j, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1), VarToStr(V2)));
      AMeta.Next;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompMTITsHolder.TestIndexes;
var
  i: Integer;
begin
  with FMetaQuery do
  try
    for i := 0 to North_tab_cnt - 1 do begin
      if not(i in [1, 6]) then {CustomerCustomerDemo, Order Details}
        continue;
      ObjectName   := GetNorthWithRLCommas(i);
      MetaInfoKind := mkIndexes;
      try
        Open;
      except
        on E: Exception do begin
          Error(ErrorMetaCommPrepare(E.Message));
          Exit;
        end;
      end;
      if CheckIndexStructure(FMetaQuery) then
        CheckIndexData(FMetaQuery, mkIndexes);
    end;
  finally
    Disconnect;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompMTITsHolder.TestPrimaryKey;
var
  i: Integer;
begin
  with FMetaQuery do
  try
    for i := 0 to North_tab_cnt - 1 do begin
      if not (i in [1, 6]) then {CustomerCustomerDemo, Order Details}
        continue;
      ObjectName   := GetNorthWithRLCommas(i);
      MetaInfoKind := mkPrimaryKey;
      try
        Open;
      except
        on E: Exception do begin
          Error(ErrorMetaCommPrepare(E.Message));
          Exit;
        end;
      end;
      if CheckIndexStructure(FMetaQuery) then
        CheckIndexData(FMetaQuery, mkPrimaryKey);
    end;
  finally
    Disconnect;
  end;
end;

{-------------------------------------------------------------------------------}
// mkIndexFields, mkPrimaryKeyFields

function TADQACompMTITsHolder.CheckIndexFieldsStructure(AMeta: TADMetaInfoQuery): Boolean;
begin
  with AMeta do begin
    Result := CheckColumnsCount(AMeta.Table, 9);
    if not Result then
      Exit;
    if AnsiCompareText(Fields[0].FieldName, C_RECNO)           <> 0 then Result := WrongName(0, C_RECNO);
    if AnsiCompareText(Fields[1].FieldName, C_CATALOG_NAME)    <> 0 then Result := WrongName(1, C_CATALOG_NAME);
    if AnsiCompareText(Fields[2].FieldName, C_SCHEMA_NAME)     <> 0 then Result := WrongName(2, C_SCHEMA_NAME);
    if AnsiCompareText(Fields[3].FieldName, C_TABLE_NAME)      <> 0 then Result := WrongName(3, C_TABLE_NAME);
    if AnsiCompareText(Fields[4].FieldName, C_INDEX_NAME)      <> 0 then Result := WrongName(4, C_INDEX_NAME);
    if AnsiCompareText(Fields[5].FieldName, C_COLUMN_NAME)     <> 0 then Result := WrongName(5, C_COLUMN_NAME);
    if AnsiCompareText(Fields[6].FieldName, C_COLUMN_POSITION) <> 0 then Result := WrongName(6, C_COLUMN_POSITION);
    if AnsiCompareText(Fields[7].FieldName, C_SORT_ORDER)      <> 0 then Result := WrongName(7, C_SORT_ORDER);
    if AnsiCompareText(Fields[8].FieldName, C_FILTER)          <> 0 then Result := WrongName(8, C_FILTER);
    if Fields[0].DataType <> ftInteger   then Result := WrongType(0, ftInteger);
    if Fields[1].DataType <> ftString    then Result := WrongType(1, ftString);
    if Fields[2].DataType <> ftString    then Result := WrongType(2, ftString);
    if Fields[3].DataType <> ftString    then Result := WrongType(3, ftString);
    if Fields[4].DataType <> ftString    then Result := WrongType(4, ftString);
    if Fields[5].DataType <> ftString    then Result := WrongType(5, ftString);
    if Fields[6].DataType <> ftSmallInt  then Result := WrongType(6, ftSmallInt);
    if Fields[7].DataType <> ftString    then Result := WrongType(7, ftString);
    if Fields[8].DataType <> ftString    then Result := WrongType(8, ftString);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompMTITsHolder.CheckIndexFieldsData(AMeta: TADMetaInfoQuery;
  AMetaInfoKind: TADPhysMetaInfoKind);
var
  sMes, sObj: String;
  V1, V2: Variant;
  j: Integer;
begin
  if AMetaInfoKind = mkIndexFields then
    sMes := 'kind = mkIndexFields'
  else
    sMes := 'kind = mkPrimaryKeyFields';
  sObj := 'CustomerCustomerDemo';
  if AMeta.RecordCount = 0 then begin
    Error(RecCountIsZero(sMes));
    Exit;
  end;
  AMeta.First;
  if AnsiCompareText(AMeta.Fields[3].AsString, 'CustomerCustomerDemo') = 0 then begin
    if AMeta[C_INDEX_NAME] = CustCustD_ind[FRDBMSKind, 0] then begin
      while not AMeta.Eof do begin
        CheckCatalogAndSchema(sMes);
        j := FMetaQuery.RecNo - 1;

        V1 := VarToValue(AMeta[C_COLUMN_NAME], '');
        V2 := CustCustD_colname[j];
        if AnsiCompareText(V1, V2) <> 0 then
          Error(WrongValueInColumnMeta(C_COLUMN_NAME, j, sMes, sObj,
                C_AD_PhysRDBMSKinds[FRDBMSKind],
                VarToStr(V1), VarToStr(V2)));

        V1 := AMeta[C_COLUMN_POSITION];
        V2 := j + 1;
        if Compare(V1, V2) <> 0 then
          Error(WrongValueInColumnMeta(C_COLUMN_POSITION, j, sMes, sObj,
                C_AD_PhysRDBMSKinds[FRDBMSKind],
                VarToStr(V1), VarToStr(V2)));

        V1 := AMeta[C_SORT_ORDER];
        V2 := 'A';
        if Compare(V1, V2) <> 0 then
          Error(WrongValueInColumnMeta(C_SORT_ORDER, j, sMes, sObj,
                C_AD_PhysRDBMSKinds[FRDBMSKind],
                VarToStr(V1), VarToStr(V2)));

        V1 := VarToValue(AMeta[C_FILTER], '');
        V2 := '';
        if Compare(V1, V2) <> 0 then
          Error(WrongValueInColumnMeta(C_FILTER, j, sMes, sObj,
                C_AD_PhysRDBMSKinds[FRDBMSKind],
                VarToStr(V1), VarToStr(V2)));
        AMeta.Next;
      end;
    end;
    AMeta.First;
    if AMeta[C_INDEX_NAME] = CustCustD_ind[FRDBMSKind, 1] then begin
      V1 := VarToValue(AMeta[C_COLUMN_NAME], '');
      V2 := CustCustD_colname[0];
      if AnsiCompareText(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_COLUMN_NAME, 0, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));
    end;
    if AMeta[C_INDEX_NAME] = CustCustD_ind[FRDBMSKind, 2] then begin
      V1 := VarToValue(AMeta[C_COLUMN_NAME], '');
      V2 := CustCustD_colname[1];
      if AnsiCompareText(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_COLUMN_NAME, 0, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompMTITsHolder.TestIndexFields;
var
  oIndexQuery: TADMetaInfoQuery;
  i: Integer;
begin
  with FMetaQuery do
  try
    oIndexQuery := TADMetaInfoQuery.Create(nil);
    try
      oIndexQuery.Connection := Connection;
      for i := 0 to 12 do begin
        oIndexQuery.Close;
        oIndexQuery.ObjectName   := GetNorthWithRLCommas(i);
        oIndexQuery.MetaInfoKind := mkIndexes;
        try
          oIndexQuery.Open;
        except
          on E: Exception do begin
            Error(ErrorMetaCommPrepare(E.Message));
            Exit;
          end;
        end;
        while not oIndexQuery.Eof do begin
          Close;
          BaseObjectName := GetNorthWithRLCommas(i);
          ObjectName     := LeftCommas[FRDBMSKind] + oIndexQuery.Fields[4].AsString +
                            RightCommas[FRDBMSKind];
          MetaInfoKind   := mkIndexFields;
          try
            Open;
          except
            on E: Exception do begin
              Error(ErrorMetaCommPrepare(E.Message));
              Exit;
            end;
          end;
          if CheckIndexFieldsStructure(FMetaQuery) then
            CheckIndexFieldsData(FMetaQuery, mkIndexFields);
          oIndexQuery.Next;
        end;
      end;
    finally
      oIndexQuery.Free;
    end;
  finally
    Disconnect;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompMTITsHolder.TestPKFields;
var
  oIndexQuery: TADMetaInfoQuery;
  i: Integer;
begin
  with FMetaQuery do
  try
    oIndexQuery := TADMetaInfoQuery.Create(nil);
    try
      oIndexQuery.Connection := Connection;
      for i := 0 to 12 do begin
        oIndexQuery.Close;
        oIndexQuery.ObjectName   := GetNorthWithRLCommas(i);
        oIndexQuery.MetaInfoKind := mkPrimaryKey;
        try
          oIndexQuery.Open;
        except
          on E: Exception do begin
            Error(ErrorMetaCommPrepare(E.Message));
            Exit;
          end;
        end;
        while not oIndexQuery.Eof do begin
          Close;
          BaseObjectName := GetNorthWithRLCommas(i);
          ObjectName     := LeftCommas[FRDBMSKind] + oIndexQuery.Fields[4].AsString +
                            RightCommas[FRDBMSKind];
          MetaInfoKind   := mkPrimaryKeyFields;
          try
            Open;
          except
            on E: Exception do begin
              Error(ErrorMetaCommPrepare(E.Message));
              Exit;
            end;
          end;
          if CheckIndexFieldsStructure(FMetaQuery) then
            CheckIndexFieldsData(FMetaQuery, mkPrimaryKeyFields);
          oIndexQuery.Next;
        end;
      end;
    finally
      oIndexQuery.Free;
    end;
  finally
    Disconnect;
  end;
end;

{-------------------------------------------------------------------------------}
// mkPackages

function TADQACompMTITsHolder.CheckPackagesStructure(AMeta: TADMetaInfoQuery): Boolean;
begin
  with AMeta do begin
    Result := CheckColumnsCount(AMeta.Table, 5);
    if not Result then
      Exit;
    if AnsiCompareText(Fields[0].FieldName, C_RECNO)         <> 0 then Result := WrongName(0, C_RECNO);
    if AnsiCompareText(Fields[1].FieldName, C_CATALOG_NAME)  <> 0 then Result := WrongName(1, C_CATALOG_NAME);
    if AnsiCompareText(Fields[2].FieldName, C_SCHEMA_NAME)   <> 0 then Result := WrongName(2, C_SCHEMA_NAME);
    if AnsiCompareText(Fields[3].FieldName, C_PACKAGE_NAME)  <> 0 then Result := WrongName(3, C_PACKAGE_NAME);
    if AnsiCompareText(Fields[4].FieldName, C_PACKAGE_SCOPE) <> 0 then Result := WrongName(4, C_PACKAGE_SCOPE);
    if Fields[0].DataType <> ftInteger    then Result := WrongType(0, ftInteger);
    if Fields[1].DataType <> ftString     then Result := WrongType(1, ftString);
    if Fields[2].DataType <> ftString     then Result := WrongType(2, ftString);
    if Fields[3].DataType <> ftString     then Result := WrongType(3, ftString);
    if Fields[4].DataType <> ftSmallInt   then Result := WrongType(4, ftSmallInt);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompMTITsHolder.CheckPackagesData(AMeta: TADMetaInfoQuery);
var
  sMes: String;
  V1, V2: Variant;
  lFound: Boolean;
  j: Integer;
begin
  sMes := 'kind = mkPackages';
  lFound := False;
  AMeta.First;
  while not AMeta.Eof do begin
    CheckCatalogAndSchema(sMes);
    j := FMetaQuery.RecNo - 1;

    V1 := VarToValue(AMeta[C_PACKAGE_NAME], '');
    V2 := Pack_name[0];
    if AnsiCompareText(V1, V2) <> 0 then begin
      AMeta.Next;
      continue;
    end;
    lFound := True;

    V1 := AMeta[C_PACKAGE_SCOPE];
    V2 := osMy;
    if Compare(V1, V2) <> 0 then
      Error(WrongValueInColumnMeta(C_PACKAGE_SCOPE, j, sMes, '',
            C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1), VarToStr(V2)));
    AMeta.Next;
  end;
  if not lFound then
    Error(WrongValueInColumnMeta(C_PACKAGE_NAME, -1, sMes, '',
          C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));
end;

{-------------------------------------------------------------------------------}
procedure TADQACompMTITsHolder.TestPackages;
begin
  with FMetaQuery do
  try
    ObjectScopes := [osMy];
    MetaInfoKind := mkPackages;
    try
      Open;
    except
      on E: Exception do begin
        Error(ErrorMetaCommPrepare(E.Message));
        Exit;
      end;
    end;
    if CheckPackagesStructure(FMetaQuery) then
      CheckPackagesData(FMetaQuery);
  finally
    Disconnect;
  end;
end;

{-------------------------------------------------------------------------------}
// mkProcs

function TADQACompMTITsHolder.CheckProcsStructure(AMeta: TADMetaInfoQuery): Boolean;
begin
  with AMeta do begin
    Result := CheckColumnsCount(AMeta.Table, 10);
    if not Result then
      Exit;
    if AnsiCompareText(Fields[0].FieldName, C_RECNO)        <> 0 then Result := WrongName(0, C_RECNO);
    if AnsiCompareText(Fields[1].FieldName, C_CATALOG_NAME) <> 0 then Result := WrongName(1, C_CATALOG_NAME);
    if AnsiCompareText(Fields[2].FieldName, C_SCHEMA_NAME)  <> 0 then Result := WrongName(2, C_SCHEMA_NAME);
    if AnsiCompareText(Fields[3].FieldName, C_PACK_NAME)    <> 0 then Result := WrongName(3, C_PACKAGE_NAME);
    if AnsiCompareText(Fields[4].FieldName, C_PROC_NAME)    <> 0 then Result := WrongName(4, C_PROC_NAME);
    if AnsiCompareText(Fields[5].FieldName, C_OVERLOAD)     <> 0 then Result := WrongName(5, C_OVERLOAD);
    if AnsiCompareText(Fields[6].FieldName, C_PROC_TYPE)    <> 0 then Result := WrongName(6, C_PROC_TYPE);
    if AnsiCompareText(Fields[7].FieldName, C_PROC_SCOPE)   <> 0 then Result := WrongName(7, C_PROC_SCOPE);
    if AnsiCompareText(Fields[8].FieldName, C_IN_PARAMS)    <> 0 then Result := WrongName(8, C_IN_PARAMS);
    if AnsiCompareText(Fields[9].FieldName, C_OUT_PARAMS)   <> 0 then Result := WrongName(9, C_OUT_PARAMS);
    if Fields[0].DataType <> ftInteger   then Result := WrongType(0, ftInteger);
    if Fields[1].DataType <> ftString    then Result := WrongType(1, ftString);
    if Fields[2].DataType <> ftString    then Result := WrongType(2, ftString);
    if Fields[3].DataType <> ftString    then Result := WrongType(3, ftString);
    if Fields[4].DataType <> ftString    then Result := WrongType(4, ftString);
    if Fields[5].DataType <> ftSmallInt  then Result := WrongType(5, ftSmallInt);
    if Fields[6].DataType <> ftSmallInt  then Result := WrongType(6, ftSmallInt);
    if Fields[7].DataType <> ftSmallInt  then Result := WrongType(7, ftSmallInt);
    if Fields[8].DataType <> ftSmallInt  then Result := WrongType(8, ftSmallInt);
    if Fields[9].DataType <> ftSmallInt  then Result := WrongType(9, ftSmallInt);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompMTITsHolder.CheckProcsData(AMeta: TADMetaInfoQuery;
  APackaged: Boolean);
var
  sMes: String;
  lFirst, lSec, lFound: Boolean;
  V1, V2: Variant;
  i, iPos, j: Integer;
begin
  sMes   := 'kind = mkProcs';
  lFirst := False;
  lSec   := False;
  if FRDBMSKind = mkOracle then begin
    if APackaged then begin
      sMes := 'In package, ' + sMes;
      AMeta.First;
      while not AMeta.Eof do begin
        CheckCatalogAndSchema(sMes);
        j := FMetaQuery.RecNo - 1;

        V1 := VarToValue(AMeta[C_PROC_NAME], '');
        V2 := ProcInPack[j];
        if AnsiCompareText(V1, V2) = 0 then
          if j = 0 then
            lFirst := True
          else
            lSec := True;

        V1 := AMeta[C_PROC_TYPE];
        V2 := ProcPropInPack[j, 0];
        if Compare(V1, V2) <> 0 then
          Error(WrongValueInColumnMeta(C_PROC_TYPE, j, sMes, '',
                C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
                VarToStr(V2)));

        V1 := AMeta[C_PROC_SCOPE];
        V2 := ProcPropInPack[j, 1];
        if Compare(V1, V2) <> 0 then
          Error(WrongValueInColumnMeta(C_PROC_SCOPE, j, sMes, '',
                C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
                VarToStr(V2)));

        V1 := AMeta[C_IN_PARAMS];
        V2 := ProcPropInPack[j, 2];
        if Compare(V1, V2) <> 0 then
          Error(WrongValueInColumnMeta(C_IN_PARAMS, j, sMes, '',
                C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
                VarToStr(V2)));

        V1 := AMeta[C_OUT_PARAMS];
        V2 := ProcPropInPack[j, 3];
        if Compare(V1, V2) <> 0 then
          Error(WrongValueInColumnMeta(C_OUT_PARAMS, j, sMes, '',
                C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
                VarToStr(V2)));

        V1 := VarToValue(AMeta[C_OVERLOAD], 0);
        V2 := ProcPropInPack[j, 4];
        if Compare(V1, V2) <> 0 then
          Error(WrongValueInColumnMeta(C_OVERLOAD, j, sMes, '',
                C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
                VarToStr(V2)));
        AMeta.Next;
      end;
      if not (lFirst and lSec) then
        Error(WrongValueInColumnMeta(C_PROC_NAME, -1, sMes, '',
              C_AD_PhysRDBMSKinds[FRDBMSKind], '', ''));
    end
    else begin
      AMeta.IndexFieldNames := C_PROC_NAME;
      AMeta.First;
      sMes := 'Without package, ' + sMes;
      while not AMeta.Eof do begin
        j := FMetaQuery.RecNo - 1;
        if j = CountOfOraProc then
          break;
        CheckCatalogAndSchema(sMes);

        V1 := VarToValue(AMeta[C_PROC_NAME], '');
        V2 := ProcWithoutPack[j];
        if AnsiCompareText(V1, V2) <> 0 then
          Error(WrongValueInColumnMeta(C_PROC_NAME, j, sMes, '',
                C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));

        V1 := AMeta[C_PROC_TYPE];
        V2 := ProcPropWithoutPack[j, 0];
        if Compare(V1, V2) <> 0 then
          Error(WrongValueInColumnMeta(C_PROC_TYPE, j, sMes, '',
                C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
                VarToStr(V2)));

        V1 := AMeta[C_PROC_SCOPE];
        V2 := ProcPropWithoutPack[j, 1];
        if Compare(V1, V2) <> 0 then
          Error(WrongValueInColumnMeta(C_PROC_SCOPE, j, sMes, '',
                C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
                VarToStr(V2)));

        V1 := VarToValue(AMeta[C_IN_PARAMS], 0);
        V2 := ProcPropWithoutPack[j, 2];
        if Compare(V1, V2) <> 0 then
          Error(WrongValueInColumnMeta(C_IN_PARAMS, j, sMes, '',
                C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
                VarToStr(V2)));

        V1 := VarToValue(AMeta[C_OUT_PARAMS], 0);
        V2 := ProcPropWithoutPack[j, 3];
        if Compare(V1, V2) <> 0 then
          Error(WrongValueInColumnMeta(C_OUT_PARAMS, j, sMes, '',
                C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
                VarToStr(V2)));

        V1 := VarToValue(AMeta[C_OVERLOAD], 0);
        V2 := ProcPropWithoutPack[j, 4];
        if Compare(V1, V2) <> 0 then
          Error(WrongValueInColumnMeta(C_OVERLOAD, j, sMes, '',
                C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
                VarToStr(V2)));
        AMeta.Next;
      end
    end
  end
  else if FRDBMSKind = mkDB2 then begin
    sMes := 'Without package, ' + sMes;
    lFound := False;
    AMeta.First;
    while not AMeta.Eof do begin
      j := FMetaQuery.RecNo - 1;

      V1 := VarToValue(AMeta[C_CATALOG_NAME], '');
      V2 := '';
      if AnsiCompareText(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_CATALOG_NAME, j, sMes, '',
              C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));

      V1 := VarToValue(AMeta[C_PROC_NAME], '');
      V2 := ProcForDefineArgs[1];
      if AnsiCompareText(V1, V2) = 0 then begin
        lFound := True;
        break;
      end;
      AMeta.Next;
    end;
    if not lFound then
      Error(ObjIsNotFound(ProcForDefineArgs[1], sMes));
  end
  else if FRDBMSKind = mkMSSQL then begin
    AMeta.IndexFieldNames := C_PROC_NAME;
    AMeta.First;
    while not AMeta.Eof do begin
      CheckCatalogAndSchema(sMes);
      j := FMetaQuery.RecNo - 1;

      V1 := AMeta[C_PROC_NAME];
      iPos := Pos(';', V1);
        if iPos > 0 then
          V1 := Copy(V1, 1, iPos - 1);
      V2 := ProcInMSSQL[0];
      if AnsiCompareText(V1, V2) = 0 then
        i := 0
      else begin
        V2 := ProcInMSSQL[1];
        if AnsiCompareText(V1, V2) = 0 then
          i := 1
        else
          i := -1;
      end;
      if i < 0 then begin
        AMeta.Next;
        continue;
      end;

      V1 := AMeta[C_PROC_TYPE];
      V2 := ProcPropInMSSQL[i, 0];
      if Compare(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_PROC_TYPE, j, sMes, ProcInMSSQL[i],
              C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1), VarToStr(V2)));

      V1 := AMeta[C_PROC_SCOPE];
      V2 := ProcPropInMSSQL[i, 1];
      if Compare(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_PROC_SCOPE, j, sMes, ProcInMSSQL[i],
              C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1), VarToStr(V2)));

      V1 := VarToValue(AMeta[C_IN_PARAMS], 0);
      V2 := ProcPropInMSSQL[i, 2];
      if Compare(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_IN_PARAMS, j, sMes, ProcInMSSQL[i],
              C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1), VarToStr(V2)));

      V1 := VarToValue(AMeta[C_OUT_PARAMS], 0);
      V2 := ProcPropInMSSQL[i, 3];
      if Compare(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_OUT_PARAMS, j, sMes, ProcInMSSQL[i],
              C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1), VarToStr(V2)));

      V1 := VarToValue(AMeta[C_OVERLOAD], 0);
      V2 := ProcPropInMSSQL[i, 4];
      if Compare(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_OVERLOAD, j, sMes, ProcInMSSQL[i],
              C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1), VarToStr(V2)));
      if i = 1 then
        break;
      AMeta.Next;
    end
  end
  else begin
    AMeta.IndexFieldNames := C_PROC_NAME;
    AMeta.First;
    while not AMeta.Eof do begin
      V1 := AMeta[C_PROC_NAME];
      V2 := ProcInASA[0];
      if AnsiCompareText(V1, V2) = 0 then
        i := 0
      else begin
        V2 := ProcInASA[1];
        if AnsiCompareText(V1, V2) = 0 then
          i := 1
        else
          i := -1;
      end;
      if i < 0 then begin
        AMeta.Next;
        continue;
      end;

      CheckCatalogAndSchema(sMes);
      j := FMetaQuery.RecNo - 1;

      V1 := AMeta[C_PROC_TYPE];
      V2 := ProcPropInASA[i, 0];
      if Compare(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_PROC_TYPE, j, sMes, ProcInASA[i],
              C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1), VarToStr(V2)));

      V1 := AMeta[C_PROC_SCOPE];
      V2 := ProcPropInASA[i, 1];
      if Compare(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_PROC_SCOPE, j, sMes, ProcInASA[i],
              C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1), VarToStr(V2)));

      V1 := VarToValue(AMeta[C_IN_PARAMS], 0);
      V2 := ProcPropInASA[i, 2];
      if Compare(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_IN_PARAMS, j, sMes, ProcInASA[i],
              C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1), VarToStr(V2)));

      V1 := VarToValue(AMeta[C_OUT_PARAMS], 0);
      V2 := ProcPropInASA[i, 3];
      if Compare(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_OUT_PARAMS, j, sMes, ProcInASA[i],
              C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1), VarToStr(V2)));

      V1 := VarToValue(AMeta[C_OVERLOAD], 0);
      V2 := ProcPropInASA[i, 4];
      if Compare(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_OVERLOAD, j, sMes, ProcInASA[i],
              C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1), VarToStr(V2)));
      if i = 1 then
        break;
      AMeta.Next;
    end
  end
end;

{-------------------------------------------------------------------------------}
procedure TADQACompMTITsHolder.TestProcs;
begin
  with FMetaQuery do
  try
    ObjectScopes := [osMy];
    MetaInfoKind := mkProcs;
    if FRDBMSKind = mkDB2 then
      SchemaName := 'SYSPROC';
    try
      Open;
    except
      on E: Exception do begin
        Error(ErrorMetaCommPrepare(E.Message));
        Exit;
      end;
    end;
    if CheckProcsStructure(FMetaQuery) then
      CheckProcsData(FMetaQuery, False);
  finally
    Disconnect;
    IndexFieldNames := '';
    if FRDBMSKind = mkDB2 then
      SchemaName := '';
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompMTITsHolder.TestPackagedProcs;
begin
  with FMetaQuery do
  try
    ObjectScopes   := [osMy];
    BaseObjectName := 'ADQA_All_types_PACK';
    MetaInfoKind   := mkProcs;
    try
      Open;
    except
      on E: Exception do begin
        Error(ErrorMetaCommPrepare(E.Message));
        Exit;
      end;
    end;
    if CheckProcsStructure(FMetaQuery) then
      CheckProcsData(FMetaQuery, True);
  finally
    Disconnect;
    IndexFieldNames := '';
    BaseObjectName := '';
  end;
end;

{-------------------------------------------------------------------------------}
// mkProcArgs

function TADQACompMTITsHolder.CheckProcArgsStructure(AMeta: TADMetaInfoQuery): Boolean;
begin
  with AMeta do begin
    Result := CheckColumnsCount(AMeta.Table, 15);
    if not Result then
      Exit;
    if AnsiCompareText(Fields[0].FieldName, C_RECNO)            <> 0 then Result := WrongName(0, C_RECNO);
    if AnsiCompareText(Fields[1].FieldName, C_CATALOG_NAME)     <> 0 then Result := WrongName(1, C_CATALOG_NAME);
    if AnsiCompareText(Fields[2].FieldName, C_SCHEMA_NAME)      <> 0 then Result := WrongName(2, C_SCHEMA_NAME);
    if AnsiCompareText(Fields[3].FieldName, C_PACK_NAME)        <> 0 then Result := WrongName(3, C_PACKAGE_NAME);
    if AnsiCompareText(Fields[4].FieldName, C_PROC_NAME)        <> 0 then Result := WrongName(4, C_PROC_NAME);
    if AnsiCompareText(Fields[5].FieldName, C_OVERLOAD)         <> 0 then Result := WrongName(5, C_OVERLOAD);
    if AnsiCompareText(Fields[6].FieldName, C_PARAM_NAME)       <> 0 then Result := WrongName(6, C_PARAM_NAME);
    if AnsiCompareText(Fields[7].FieldName, C_PARAM_POSITION)   <> 0 then Result := WrongName(7, C_PARAM_POSITION);
    if AnsiCompareText(Fields[8].FieldName, C_PARAM_TYPE)       <> 0 then Result := WrongName(8, C_PARAM_TYPE);
    if AnsiCompareText(Fields[9].FieldName, C_PARAM_DATATYPE)   <> 0 then Result := WrongName(9, C_PARAM_DATATYPE);
    if AnsiCompareText(Fields[10].FieldName, C_PARAM_TYPENAME)  <> 0 then Result := WrongName(10, C_PARAM_TYPENAME);
    if AnsiCompareText(Fields[11].FieldName, C_PARAM_ATTRIBUTES)<> 0 then Result := WrongName(11, C_PARAM_ATTRIBUTES);
    if AnsiCompareText(Fields[12].FieldName, C_PARAM_PRECISION) <> 0 then Result := WrongName(12, C_PARAM_PRECISION);
    if AnsiCompareText(Fields[13].FieldName, C_PARAM_SCALE)     <> 0 then Result := WrongName(13, C_PARAM_SCALE);
    if AnsiCompareText(Fields[14].FieldName, C_PARAM_LENGTH)    <> 0 then Result := WrongName(14, C_PARAM_LENGTH);
    if Fields[0].DataType  <> ftInteger  then Result := WrongType(0, ftInteger);
    if Fields[1].DataType  <> ftString   then Result := WrongType(1, ftString);
    if Fields[2].DataType  <> ftString   then Result := WrongType(2, ftString);
    if Fields[3].DataType  <> ftString   then Result := WrongType(3, ftString);
    if Fields[4].DataType  <> ftString   then Result := WrongType(4, ftString);
    if Fields[5].DataType  <> ftSmallInt then Result := WrongType(5, ftSmallInt);
    if Fields[6].DataType  <> ftString   then Result := WrongType(6, ftString);
    if Fields[7].DataType  <> ftSmallInt then Result := WrongType(7, ftSmallInt);
    if Fields[8].DataType  <> ftSmallInt then Result := WrongType(8, ftSmallInt);
    if Fields[9].DataType  <> ftSmallInt then Result := WrongType(9, ftSmallInt);
    if Fields[10].DataType <> ftString   then Result := WrongType(10, ftString);
    if Fields[11].DataType <> ftInteger  then Result := WrongType(11, ftInteger);
    if Fields[12].DataType <> ftSmallInt then Result := WrongType(12, ftSmallInt);
    if Fields[13].DataType <> ftSmallInt then Result := WrongType(13, ftSmallInt);
    if Fields[14].DataType <> ftInteger  then Result := WrongType(14, ftInteger);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompMTITsHolder.CheckProcArgsData(AMeta: TADMetaInfoQuery;
  APackaged: Boolean);
var
  sMes, sObj, sArgName, sTypeOfArgName: String;
  V1, V2: Variant;
  oQuery: TADQuery;
  j: Integer;
begin
  AMeta.IndexFieldNames := C_PARAM_NAME;
  sMes := 'kind = mkProcArgs';
  sObj := 'Get_Valuesp';
  if FRDBMSKind = mkOracle then begin
    if APackaged then begin
      sMes := 'In package, ' + sMes;
      CheckCatalogAndSchema(sMes);

      V1 := VarToValue(AMeta[C_PACK_NAME], '');
      V2 := 'ADQA_All_types_PACK';
      if AnsiCompareText(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_PACK_NAME, 0, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));

      V1 := AMeta[C_PARAM_NAME];
      V2 := 'CUR';
      if AnsiCompareText(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_PARAM_NAME, 0, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));
      sArgName := V1;

      V1 := AMeta[C_PARAM_POSITION];
      V2 := 1;
      if Compare(V1, V2) <> 0 then
        Error(WrongProcArgValueMeta(C_PARAM_POSITION, sArgName, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1), VarToStr(V2)));

      V1 := AMeta[C_PARAM_TYPE];
      V2 := 2;
      if Compare(V1, V2) <> 0 then
        Error(WrongProcArgValueMeta(C_PARAM_TYPE, sArgName, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1), VarToStr(V2)));

      V1 := AMeta[C_PARAM_DATATYPE];
      V2 := 29;
      if Compare(V1, V2) <> 0 then
        Error(WrongProcArgValueMeta(C_PARAM_DATATYPE, sArgName, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind],
              ADDataTypesNames[TADDataType(V1)],
              ADDataTypesNames[TADDataType(V2)]));

      V1 := AMeta[C_PARAM_TYPENAME];
      V2 := 'REF CURSOR';
      if AnsiCompareText(V1, V2) <> 0 then
        Error(WrongProcArgValueMeta(C_PARAM_TYPENAME, sArgName, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));

      V1 := AMeta[C_PARAM_ATTRIBUTES];
      V2 := 4;
      if Compare(V1, V2) <> 0 then
        Error(WrongProcArgValueMeta(C_PARAM_ATTRIBUTES, sArgName, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1), VarToStr(V2)));

      V1 := VarToValue(AMeta[C_PARAM_PRECISION], 0);
      V2 := 0;
      if Compare(V1, V2) <> 0 then
        Error(WrongProcArgValueMeta(C_PARAM_PRECISION, sArgName, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1), VarToStr(V2)));

      V1 := VarToValue(AMeta[C_PARAM_SCALE], 0);
      V2 := 0;
      if Compare(V1, V2) <> 0 then
        Error(WrongProcArgValueMeta(C_PARAM_SCALE, sArgName, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1), VarToStr(V2)));

      V1 := VarToValue(AMeta[C_PARAM_LENGTH], 0);
      V2 := 0;
      if Compare(V1, V2) <> 0 then
        Error(WrongProcArgValueMeta(C_PARAM_LENGTH, sArgName, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1), VarToStr(V2)));
    end
    else begin
      sMes := 'Without package, ' + sMes;
      sObj := 'ADQA_All_Vals';
      while not AMeta.Eof do begin
        CheckCatalogAndSchema(sMes);
        j := FMetaQuery.RecNo - 1;

        V1 := VarToValue(AMeta[C_PACK_NAME], '');
        V2 := '';
        if AnsiCompareText(V1, V2) <> 0 then
          Error(WrongValueInColumnMeta(C_PACK_NAME, j, sMes, sObj,
                C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));

        V1 := AMeta[C_PARAM_NAME];
        V2 := ProcArgWithoutPack[j];
        if AnsiCompareText(V1, V2) <> 0 then
          Error(WrongValueInColumnMeta(C_PARAM_NAME, j, sMes, sObj,
                C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));
        sArgName := V1;

        V1 := AMeta[C_PARAM_POSITION];
        V2 := ProcArgPropWPack[j, 0];
        if Compare(V1, V2) <> 0 then
          Error(WrongProcArgValueMeta(C_PARAM_POSITION, sArgName, sMes, sObj,
                C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1), VarToStr(V2)));

        V1 := AMeta[C_PARAM_TYPE];
        V2 := ProcArgPropWPack[j, 1];
        if Compare(V1, V2) <> 0 then
          Error(WrongProcArgValueMeta(C_PARAM_TYPE, sArgName, sMes, sObj,
                C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1), VarToStr(V2)));

        V1 := AMeta[C_PARAM_DATATYPE];
        V2 := ProcArgPropWPack[j, 2];
        if (j = 5) and OraServerLess81 then {I_FLOAT}
          V2 := ProcArgPropWPack[9, 2];
        if (j = 21) and OraServerLess81 then {O_FLOAT}
          V2 := ProcArgPropWPack[25, 2];
        if Compare(V1, V2) <> 0 then
          Error(WrongProcArgValueMeta(C_PARAM_DATATYPE, sArgName, sMes, sObj,
                C_AD_PhysRDBMSKinds[FRDBMSKind],
                ADDataTypesNames[TADDataType(V1)],
                ADDataTypesNames[TADDataType(V2)]));

        V1 := AMeta[C_PARAM_TYPENAME];
        V2 := Copy(ProcArgWithoutPack[j], 3,
                       Length(ProcArgWithoutPack[j]));
        if (j = 5) and OraServerLess81 then {I_FLOAT}
          V2 := Copy(ProcArgWithoutPack[9], 3,
                         Length(ProcArgWithoutPack[9]));
        if (j = 21) and OraServerLess81 then {O_FLOAT}
          V2 := Copy(ProcArgWithoutPack[25], 3,
                         Length(ProcArgWithoutPack[25]));
        if (j = 13) and OraServerLess81 then {I_UROWID}
          V2 := Copy(ProcArgWithoutPack[12], 3,
                         Length(ProcArgWithoutPack[12]));
        if (j = 29) and OraServerLess81 then {O_UROWID}
          V2 := Copy(ProcArgWithoutPack[28], 3,
                         Length(ProcArgWithoutPack[28]));
        if (AnsiCompareText(V1, V2) <> 0) and
           (AnsiCompareText('varchar', V2) <> 0) then
          Error(WrongProcArgValueMeta(C_PARAM_TYPENAME, sArgName, sMes,
               sObj, C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));

        V1 := AMeta[C_PARAM_ATTRIBUTES];
        V2 := ProcArgPropWPack[j, 3];
        if (j = 13) and OraServerLess81 then {I_UROWID}
          V2 := ProcArgPropWPack[12, 3];
        if (j = 29) and OraServerLess81 then {O_UROWID}
          V2 := ProcArgPropWPack[28, 3];
        if Compare(V1, V2) <> 0 then
          Error(WrongProcArgValueMeta(C_PARAM_ATTRIBUTES, sArgName, sMes,
                sObj, C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
                VarToStr(V2)));

        V1 := VarToValue(AMeta[C_PARAM_PRECISION], 0);
        V2 := ProcArgPropWPack[j, 4];
        if (j = 5) and OraServerLess81 then {I_FLOAT}
          V2 := ProcArgPropWPack[9, 4];
        if (j = 21) and OraServerLess81 then {O_FLOAT}
          V2 := ProcArgPropWPack[25, 4];
        if Compare(V1, V2) <> 0 then
          Error(WrongProcArgValueMeta(C_PARAM_PRECISION, sArgName, sMes,
                sObj, C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
                VarToStr(V2)));

        V1 := VarToValue(AMeta[C_PARAM_SCALE], 0);
        V2 := ProcArgPropWPack[j, 5];
        if Compare(V1, V2) <> 0 then
          Error(WrongProcArgValueMeta(C_PARAM_SCALE, sArgName, sMes, sObj,
                C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
                VarToStr(V2)));

        V1 := VarToValue(AMeta[C_PARAM_LENGTH], 0);
        V2 := ProcArgPropWPack[j, 6];
        if (j = 13) and OraServerLess81 then {I_UROWID}
          V2 := ProcArgPropWPack[12, 6];
        if (j = 29) and OraServerLess81 then {O_UROWID}
          V2 := ProcArgPropWPack[28, 6];
        if Compare(V1, V2) <> 0 then
          Error(WrongProcArgValueMeta(C_PARAM_LENGTH, sArgName, sMes, sObj,
                C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
                VarToStr(V2)));
        AMeta.Next;
      end;
    end
  end
  else if FRDBMSKind = mkDB2 then begin
    oQuery := TADQuery.Create(nil);
    oQuery.Connection := FConnection;
    oQuery.SQL.Text := 'select ordinal, parmname, typename ' +
                       'from sysibm.sysprocparms ' +
                       'where procname = ''GET_SWRD_SETTINGS''';
    oQuery.Open;
    sMes := 'Without package, ' + sMes;
    sObj := ProcForDefineArgs[1];
    AMeta.IndexFieldNames := C_PARAM_POSITION;
    while not AMeta.Eof do begin
      j := FMetaQuery.RecNo - 1;
      
      V1 := VarToValue(AMeta[C_CATALOG_NAME], '');
      V2 := '';
      if AnsiCompareText(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_CATALOG_NAME, j, sMes, '',
              C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));

      V1 := AMeta[C_SCHEMA_NAME];
      V2 := 'SYSPROC';
      if AnsiCompareText(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_SCHEMA_NAME, j, sMes, '',
              C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));

      V1 := AMeta[C_PARAM_POSITION];
      V2 := oQuery.Fields[0].Value;
      if V1 <> V2 then
        Error(WrongValueInColumnMeta(C_PARAM_POSITION, j, sMes, '',
              C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));

      V1 := AMeta[C_PARAM_NAME];
      V2 := oQuery.Fields[1].Value;
      if AnsiCompareText(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_PARAM_NAME, j, sMes, '',
              C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));

      V1 := AMeta[C_PARAM_DATATYPE];
      V2 := ADProcParamTypes[j];
      if Compare(V1, V2) <> 0 then
        Error(WrongProcArgValueMeta(C_PARAM_TYPE, '#' + IntToStr(j), sMes,
              sObj, C_AD_PhysRDBMSKinds[FRDBMSKind],
              FldTypeNames[TFieldType(V1)], FldTypeNames[TFieldType(V2)]));
      AMeta.Next;
      oQuery.Next;
    end;
  end
  else if FRDBMSKind = mkMSSQL then begin
    with AMeta.Indexes.Add do begin
      Fields := C_PARAM_NAME;
      Options := [soNoCase];
      Selected := True;
    end;
    sObj := 'ADQA_All_Values';
    while not AMeta.Eof do begin
      CheckCatalogAndSchema(sMes);
      j := FMetaQuery.RecNo - 1;

      V1 := VarToValue(AMeta[C_PACK_NAME], '');
      V2 := '';
      if AnsiCompareText(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_PACK_NAME, j, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));

      V1 := AMeta[C_PARAM_NAME];
      V2 := ProcArgMSSQL[j];
      if AnsiCompareText(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_PARAM_NAME, j, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));
      sArgName := ProcArgMSSQL[j];
      sTypeOfArgName := AnsiUpperCase(Copy(sArgName, 4, Length(sArgName)));

      V1 := AMeta[C_PARAM_POSITION];
      V2 := ProcArgPropMSSQL[j, 0] + 1; // ??? Which position of @RETURN_VALUE param&
      if Compare(V1, V2) <> 0 then
        Error(WrongProcArgValueMeta(C_PARAM_POSITION, sArgName,
              sMes, sObj, C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
              VarToStr(V2)));

      V1 := AMeta[C_PARAM_TYPE];
      V2 := ProcArgPropMSSQL[j, 1];
      if Compare(V1, V2) <> 0 then
        Error(WrongProcArgValueMeta(C_PARAM_TYPE, sArgName,
              sMes, sObj, C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
              VarToStr(V2)));

      V1 := AMeta[C_PARAM_DATATYPE];
      V2 := ProcArgPropMSSQL[j, 2];
      if (sTypeOfArgName <> _SQL_VARIANT) and
         (sTypeOfArgName <> _UNIQUEIDENTIFIER) {and
         (sTypeOfArgName <> _BIGINT)} and
         (sTypeOfArgName <> _MONEY) and (sTypeOfArgName <> _NUMERIC) then begin
        if Compare(V1, V2) <> 0 then
          Error(WrongProcArgValueMeta(C_PARAM_DATATYPE, sArgName,
                sMes, sObj, C_AD_PhysRDBMSKinds[FRDBMSKind],
                ADDataTypesNames[TADDataType(V1)],
                ADDataTypesNames[TADDataType(V2)]));
      end
      else begin
        if sTypeOfArgName = _SQL_VARIANT then
          if not((Compare(V1, Ord(ftString)) = 0) or
             (Compare(V1, Ord(dtBlob)) = 0)) then
            Error(WrongProcArgValueMeta(C_PARAM_DATATYPE, sArgName,
                  sMes, sObj, C_AD_PhysRDBMSKinds[FRDBMSKind],
                  ADDataTypesNames[TADDataType(V1)],
                  'ftString or dtBlob'));
        if sTypeOfArgName = _UNIQUEIDENTIFIER then
          if not((Compare(V1, Ord(ftString)) = 0) or
             (Compare(V1, Ord(dtBlob)) = 0) or
             (Compare(V1, Ord(dtGUID)) = 0)) then
            Error(WrongProcArgValueMeta(C_PARAM_DATATYPE, sArgName,
                  sMes, sObj, C_AD_PhysRDBMSKinds[FRDBMSKind],
                  ADDataTypesNames[TADDataType(V1)],
                  'ftString or dtBlob or dtGUID'));
        if {(sTypeOfArgName = _BIGINT) or }
           (sTypeOfArgName = _MONEY) or
           (sTypeOfArgName = _NUMERIC) then
          if not((Compare(V1, Ord(dtBCD)) = 0) or
             (Compare(V1, Ord(dtFmtBCD)) = 0)) then
            Error(WrongProcArgValueMeta(C_PARAM_DATATYPE, sArgName,
                  sMes, sObj, C_AD_PhysRDBMSKinds[FRDBMSKind],
                  ADDataTypesNames[TADDataType(V1)], 'dtBCD or dtFmtBCD'));
      end;

      V1 := AMeta[C_PARAM_TYPENAME];
      if AnsiCompareText(sArgName, '@RETURN_VALUE') <> 0 then begin
        V2 := sTypeOfArgName;
        if AnsiCompareText(V1, V2) <> 0 then
          Error(WrongProcArgValueMeta(C_PARAM_TYPENAME, sArgName,
                sMes, sObj, C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));
      end;

      V1 := AMeta[C_PARAM_ATTRIBUTES];
      V2 := ProcArgPropMSSQL[j, 3];
      if sTypeOfArgName <> _SQL_VARIANT then begin
        if Compare(V1, V2) <> 0 then
          Error(WrongProcArgValueMeta(C_PARAM_ATTRIBUTES, sArgName,
                sMes, sObj, C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
                VarToStr(V2)));
      end
      else begin
        if sTypeOfArgName = _SQL_VARIANT then
          if not((Compare(V1, 3) = 0)) then
            Error(WrongProcArgValueMeta(C_PARAM_DATATYPE, sArgName,
                  sMes, sObj, C_AD_PhysRDBMSKinds[FRDBMSKind],
                  ADDataTypesNames[TADDataType(V1)],
                  ADDataTypesNames[TADDataType(3)]));
      end;

      V1 := VarToValue(AMeta[C_PARAM_PRECISION], 0);
      V2 := ProcArgPropMSSQL[j, 4];
      if Compare(V1, V2) <> 0 then
        Error(WrongProcArgValueMeta(C_PARAM_PRECISION, sArgName,
              sMes, sObj, C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
              VarToStr(V2)));

      V1 := VarToValue(AMeta[C_PARAM_SCALE], 0);
      V2 := ProcArgPropMSSQL[j, 5];
      if Compare(V1, V2) <> 0 then
        Error(WrongProcArgValueMeta(C_PARAM_SCALE, sArgName,
              sMes, sObj, C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
              VarToStr(V2)));

      V1 := VarToValue(AMeta[C_PARAM_LENGTH], 0);
      V2 := ProcArgPropMSSQL[j, 6];
      if (sTypeOfArgName <> _TEXT) and
         (sTypeOfArgName <> _NTEXT) and
         (sTypeOfArgName <> _IMAGE) then begin
        if Compare(V1, V2) <> 0 then
          Error(WrongProcArgValueMeta(C_PARAM_LENGTH, sArgName,
                sMes, sObj, C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
                VarToStr(V2)));
      end
      else begin
        if sTypeOfArgName = _IMAGE then
          if not((Compare(V1, 0) = 0) or (Compare(V1, 2147483647) = 0)) then
            Error(WrongProcArgValueMeta(C_PARAM_LENGTH, sArgName,
                  sMes, sObj, C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
                  '0 or 2147483647'));
        if sTypeOfArgName = _TEXT then
          if not((Compare(V1, 0) = 0) or (Compare(V1, 2147483647) = 0)) then
            Error(WrongProcArgValueMeta(C_PARAM_LENGTH, sArgName,
                  sMes, sObj, C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
                  '0 or 2147483647'));
        if sTypeOfArgName = _NTEXT then
          if not((Compare(V1, 0) = 0) or
             (Compare(V1, 1073741823) = 0) or
             (Compare(V1, 2147483647) = 0)) then
            Error(WrongProcArgValueMeta(C_PARAM_LENGTH, sArgName,
                  sMes, sObj, C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
                  '0 or 1073741823 or 2147483647'));
      end;
      AMeta.Next;
    end;
  end
  else begin
    AMeta.IndexFieldNames := '';
    AMeta.IndexName := '';
    sObj := 'ADQA_All_Values';
    while not AMeta.Eof do begin
      CheckCatalogAndSchema(sMes);
      j := FMetaQuery.RecNo - 1;

      V1 := VarToValue(AMeta[C_PACK_NAME], '');
      V2 := '';
      if AnsiCompareText(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_PACK_NAME, j, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));

      V1 := AMeta[C_PARAM_NAME];
      V2 := ProcArgASA[j];
      if AnsiCompareText(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_PARAM_NAME, j, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));
      sArgName := ProcArgASA[j];
      sTypeOfArgName := AnsiUpperCase(Copy(sArgName, 3, Length(sArgName)));

      V1 := AMeta[C_PARAM_POSITION];
      V2 := ProcArgPropASA[j, 0];
      if Compare(V1, V2) <> 0 then
        Error(WrongProcArgValueMeta(C_PARAM_POSITION, sArgName,
              sMes, sObj, C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
              VarToStr(V2)));

      V1 := AMeta[C_PARAM_TYPE];
      V2 := ProcArgPropASA[j, 1];
      if Compare(V1, V2) <> 0 then
        Error(WrongProcArgValueMeta(C_PARAM_TYPE, sArgName,
              sMes, sObj, C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
              VarToStr(V2)));

      V1 := AMeta[C_PARAM_DATATYPE];
      V2 := ProcArgPropASA[j, 2];
      if sTypeOfArgName <> _NUMERIC then begin
        if Compare(V1, V2) <> 0 then
          Error(WrongProcArgValueMeta(C_PARAM_DATATYPE, sArgName,
                sMes, sObj, C_AD_PhysRDBMSKinds[FRDBMSKind],
                ADDataTypesNames[TADDataType(V1)],
                ADDataTypesNames[TADDataType(V2)]));
      end
      else begin
        if not((Compare(V1, Ord(dtBCD)) = 0) or
           (Compare(V1, Ord(dtFmtBCD)) = 0)) then
          Error(WrongProcArgValueMeta(C_PARAM_DATATYPE, sArgName,
                sMes, sObj, C_AD_PhysRDBMSKinds[FRDBMSKind],
                ADDataTypesNames[TADDataType(V1)], 'dtBCD or dtFmtBCD'));
      end;

      V1 := AMeta[C_PARAM_TYPENAME];
      V2 := sTypeOfArgName;
      if (AnsiCompareText(V1, V2) <> 0) and
         ((V2 = _LONGBINARY) and (AnsiCompareText('long binary', V1) <> 0)) and
         ((V2 = _INT) and (AnsiCompareText('integer', V1) <> 0)) and
         ((V2 = _LONGVARCHAR) and (AnsiCompareText('long varchar', V1) <> 0)) then
        Error(WrongProcArgValueMeta(C_PARAM_TYPENAME, sArgName,
              sMes, sObj, C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));

      V1 := AMeta[C_PARAM_ATTRIBUTES];
      V2 := ProcArgPropASA[j, 3];
      if Compare(V1, V2) <> 0 then
        Error(WrongProcArgValueMeta(C_PARAM_ATTRIBUTES, sArgName,
              sMes, sObj, C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
              VarToStr(V2)));

      V1 := VarToValue(AMeta[C_PARAM_PRECISION], 0);
      V2 := ProcArgPropASA[j, 4];
      if Compare(V1, V2) <> 0 then
        Error(WrongProcArgValueMeta(C_PARAM_PRECISION, sArgName,
              sMes, sObj, C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
              VarToStr(V2)));

      V1 := VarToValue(AMeta[C_PARAM_SCALE], 0);
      V2 := ProcArgPropASA[j, 5];
      if Compare(V1, V2) <> 0 then
        Error(WrongProcArgValueMeta(C_PARAM_SCALE, sArgName,
              sMes, sObj, C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
              VarToStr(V2)));

      V1 := VarToValue(AMeta[C_PARAM_LENGTH], 0);
      V2 := ProcArgPropASA[j, 6];
      if Compare(V1, V2) <> 0 then
        Error(WrongProcArgValueMeta(C_PARAM_LENGTH, sArgName,
              sMes, sObj, C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
              VarToStr(V2)));
      AMeta.Next;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompMTITsHolder.TestProcArgs;
begin
  with FMetaQuery do
  try
    ObjectScopes := [osMy];
    if FRDBMSKind in [mkMSSQL, mkASA] then
      ObjectName := 'ADQA_All_Values'
    else if FRDBMSKind = mkDB2 then
      ObjectName := ProcForDefineArgs[1]
    else
      ObjectName := 'ADQA_All_Vals';
    MetaInfoKind := mkProcArgs;
    if FRDBMSKind = mkDB2 then
      SchemaName := 'SYSPROC';
    try
      Open;
    except
      on E: Exception do begin
        Error(ErrorMetaCommPrepare(E.Message));
        Exit;
      end;
    end;
    if CheckProcArgsStructure(FMetaQuery) then
      if FMetaQuery.RecordCount <> 0 then
        CheckProcArgsData(FMetaQuery, False)
      else
        Error(RecCountIsZero('Proc. args of ' + ObjectName));
  finally
    Disconnect;
    IndexFieldNames := '';
    Indexes.Clear;
    if FRDBMSKind = mkDB2 then
      SchemaName := '';
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompMTITsHolder.TestPackagedProcArgs;
begin
  with FMetaQuery do
  try
    ObjectScopes   := [osMy];
    BaseObjectName := 'ADQA_All_types_PACK';
    ObjectName     := 'Get_Valuesp';
    MetaInfoKind   := mkProcArgs;
    try
      Open;
    except
      on E: Exception do begin
        Error(ErrorMetaCommPrepare(E.Message));
        Exit;
      end;
    end;
    if CheckProcArgsStructure(FMetaQuery) then
      CheckProcArgsData(FMetaQuery, True);
  finally
    Disconnect;
    IndexFieldNames := '';
    Indexes.Clear;
  end;
end;

initialization

  ADQAPackManager.RegisterPack('Comp Layer', TADQACompMTITsHolder);

end.
