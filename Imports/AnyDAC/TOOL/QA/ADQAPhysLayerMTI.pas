{-------------------------------------------------------------------------------}
{ AnyDAC Phys Layer metainfo tests                                              }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit ADQAPhysLayerMTI;

interface

uses
  Classes, Windows, SysUtils, DB, IniFiles,
  ADQAPack, ADQAPhysLayerCNN,
  daADStanIntf, daADStanOption, daADStanParam,
  daADDatSManager,
  daADGUIxIntf,
  daADPhysIntf;

type
  TADQAPhysMTITsHolder = class (TADQAPhysTsHolderBase)
  private
    FMetaCommIntf:  IADPhysMetaInfoCommand;
    FIni: TIniFile;
    procedure CheckCatalogAndSchema(ARow: Integer; AMes: String);
    procedure CheckIndexData(ATab: TADDatSTable;
      AMetaInfoKind: TADPhysMetaInfoKind);
    procedure CheckIndexFieldsData(ATab: TADDatSTable;
      AMetaInfoKind: TADPhysMetaInfoKind);
    function CheckIndexFieldsStructure(ATab: TADDatSTable): Boolean;
    function CheckIndexStructure(ATab: TADDatSTable): Boolean;
    procedure CheckPackagesData(ATab: TADDatSTable);
    function CheckPackagesStructure(ATab: TADDatSTable): Boolean;
    procedure CheckProcArgsData(ATab: TADDatSTable; APackaged: Boolean);
    function CheckProcArgsStructure(ATab: TADDatSTable): Boolean;
    procedure CheckProcsData(ATab: TADDatSTable; APackaged: Boolean);
    function CheckProcsStructure(ATab: TADDatSTable): Boolean;
    procedure CheckTableData(ATab: TADDatSTable; AWildcard: Boolean);
    procedure CheckTableFieldsData(ATab: TADDatSTable);
    function CheckTableFieldsStructure(ATab: TADDatSTable): Boolean;
    function CheckTableStructure(ATab: TADDatSTable): Boolean;
    function GetNorthWithRLCommas(ANum: Integer): String;
    function OraServerLess81: Boolean;
    function WrongName(ANum: Integer; AName: String): Boolean;
    function WrongType(ANum: Integer; AType: TADDataType): Boolean;
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
  daADStanUtil, daADStanConst, daADStanError;

{-------------------------------------------------------------------------------}
{ TADQAPhysTsHolder                                                             }
{-------------------------------------------------------------------------------}
procedure TADQAPhysMTITsHolder.RegisterTests;
begin
  RegisterTest('MetaInfoCommand;Tables;DB2',       TestTables, mkDB2);
  RegisterTest('MetaInfoCommand;Tables;MS Access', TestTables, mkMSAccess);
  RegisterTest('MetaInfoCommand;Tables;MSSQL',     TestTables, mkMSSQL);
  RegisterTest('MetaInfoCommand;Tables;ASA',       TestTables, mkASA);
  RegisterTest('MetaInfoCommand;Tables;MySQL',     TestTables, mkMySQL);
  RegisterTest('MetaInfoCommand;Tables;Oracle',    TestTables, mkOracle);

  RegisterTest('MetaInfoCommand;TableFields;DB2',       TestTableFields, mkDB2);
  RegisterTest('MetaInfoCommand;TableFields;MS Access', TestTableFields, mkMSAccess);
  RegisterTest('MetaInfoCommand;TableFields;MSSQL',     TestTableFields, mkMSSQL);
  RegisterTest('MetaInfoCommand;TableFields;ASA',       TestTableFields, mkASA);
  RegisterTest('MetaInfoCommand;TableFields;MySQL',     TestTableFields, mkMySQL);
  RegisterTest('MetaInfoCommand;TableFields;Oracle',    TestTableFields, mkOracle);

  RegisterTest('MetaInfoCommand;PrimaryKey;DB2',       TestPrimaryKey, mkDB2);
  RegisterTest('MetaInfoCommand;PrimaryKey;MS Access', TestPrimaryKey, mkMSAccess);
  RegisterTest('MetaInfoCommand;PrimaryKey;MSSQL',     TestPrimaryKey, mkMSSQL);
  RegisterTest('MetaInfoCommand;PrimaryKey;ASA',       TestPrimaryKey, mkASA);
  RegisterTest('MetaInfoCommand;PrimaryKey;MySQL',     TestPrimaryKey, mkMySQL);
  RegisterTest('MetaInfoCommand;PrimaryKey;Oracle',    TestPrimaryKey, mkOracle);

  RegisterTest('MetaInfoCommand;PrimaryKeyFields;DB2',       TestPKFields, mkDB2);
  RegisterTest('MetaInfoCommand;PrimaryKeyFields;MS Access', TestPKFields, mkMSAccess);
  RegisterTest('MetaInfoCommand;PrimaryKeyFields;MSSQL',     TestPKFields, mkMSSQL);
  RegisterTest('MetaInfoCommand;PrimaryKeyFields;ASA',       TestPKFields, mkASA);
  RegisterTest('MetaInfoCommand;PrimaryKeyFields;MySQL',     TestPKFields, mkMySQL);
  RegisterTest('MetaInfoCommand;PrimaryKeyFields;Oracle',    TestPKFields, mkOracle);

  RegisterTest('MetaInfoCommand;Indexes;DB2',       TestIndexes, mkDB2);
  RegisterTest('MetaInfoCommand;Indexes;MS Access', TestIndexes, mkMSAccess);
  RegisterTest('MetaInfoCommand;Indexes;MSSQL',     TestIndexes, mkMSSQL);
  RegisterTest('MetaInfoCommand;Indexes;ASA',       TestIndexes, mkASA);
  RegisterTest('MetaInfoCommand;Indexes;MySQL',     TestIndexes, mkMySQL);
  RegisterTest('MetaInfoCommand;Indexes;Oracle',    TestIndexes, mkOracle);

  RegisterTest('MetaInfoCommand;IndexFields;DB2',       TestIndexFields, mkDB2);
  RegisterTest('MetaInfoCommand;IndexFields;MS Access', TestIndexFields, mkMSAccess);
  RegisterTest('MetaInfoCommand;IndexFields;MSSQL',     TestIndexFields, mkMSSQL);
  RegisterTest('MetaInfoCommand;IndexFields;ASA',       TestIndexFields, mkASA);
  RegisterTest('MetaInfoCommand;IndexFields;MySQL',     TestIndexFields, mkMySQL);
  RegisterTest('MetaInfoCommand;IndexFields;Oracle',    TestIndexFields, mkOracle);

  RegisterTest('MetaInfoCommand;Packages-Ora;Pack',  TestPackages, mkOracle);
  RegisterTest('MetaInfoCommand;Packages-Ora;Procs', TestPackagedProcs, mkOracle);
  RegisterTest('MetaInfoCommand;Packages-Ora;Args',  TestPackagedProcArgs, mkOracle);

  RegisterTest('MetaInfoCommand;Procs;DB2',    TestProcs, mkDB2);
  RegisterTest('MetaInfoCommand;Procs;MSSQL',  TestProcs, mkMSSQL);
  RegisterTest('MetaInfoCommand;Procs;ASA',    TestProcs, mkASA);
  RegisterTest('MetaInfoCommand;Procs;Oracle', TestProcs, mkOracle);

  RegisterTest('MetaInfoCommand;ProcArgs;DB2',    TestProcArgs, mkDB2);
  RegisterTest('MetaInfoCommand;ProcArgs;MSSQL',  TestProcArgs, mkMSSQL);
  RegisterTest('MetaInfoCommand;ProcArgs;ASA',    TestProcArgs, mkASA);
  RegisterTest('MetaInfoCommand;ProcArgs;Oracle', TestProcArgs, mkOracle);
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysMTITsHolder.ClearAfterTest;
begin
  FMetaCommIntf := nil;
  FIni.Free;
  FIni := nil;
  inherited ClearAfterTest;
end;

{-------------------------------------------------------------------------------}
function TADQAPhysMTITsHolder.RunBeforeTest: Boolean;
begin
  Result := inherited RunBeforeTest;
  FCommIntf := nil;
  FConnIntf.CreateMetaInfoCommand(FMetaCommIntf);
  FIni := TIniFile.Create('.\ADQAMetaInfo.ini');
end;

{-------------------------------------------------------------------------------}
function TADQAPhysMTITsHolder.WrongName(ANum: Integer; AName: String): Boolean;
begin
  Error(WrongColumnName(FTab.Columns[ANum].Name, AName));
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADQAPhysMTITsHolder.WrongType(ANum: Integer; AType: TADDataType): Boolean;
begin
  Error(WrongColumnType(ANum, ADDataTypesNames[AType],
        ADDataTypesNames[FTab.Columns[ANum].DataType]));
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADQAPhysMTITsHolder.GetNorthWithRLCommas(ANum: Integer): String;
var
  oConnMeta: IADPhysConnectionMetaData;
begin
  FConnIntf.CreateMetadata(oConnMeta);
  Result := oConnMeta.NameQuotaChar1 + NorthWind[ANum] + oConnMeta.NameQuotaChar2;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysMTITsHolder.CheckCatalogAndSchema(ARow: Integer; AMes: String);
var
  oStrList: TStrings;
  V1, V2: Variant;
begin
  oStrList := TStringList.Create;
  try
    V1 := VarToValue(FTab.DefaultView.Rows[ARow].GetData(C_CATALOG_NAME), '');
    V2 := FIni.ReadString(C_AD_PhysRDBMSKinds[FRDBMSKind], 'Catalog', '');
    if FRDBMSKind = mkMSAccess then
      V2 := ExpandFileName(ADExpandStr(V2));
    if AnsiCompareText(V1, V2) <> 0 then
      Error(WrongValueInColumnMeta(C_CATALOG_NAME, ARow, AMes, '',
            C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));

    V1 := VarToValue(FTab.DefaultView.Rows[ARow].GetData(C_SCHEMA_NAME), '');
    V2 := FIni.ReadString(C_AD_PhysRDBMSKinds[FRDBMSKind], 'Schema', '');
    if AnsiCompareText(V1, V2) <> 0 then
      Error(WrongValueInColumnMeta(C_SCHEMA_NAME, ARow, AMes, '',
            C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));
  finally
    oStrList.Free;
  end;
end;

{-------------------------------------------------------------------------------}
function TADQAPhysMTITsHolder.OraServerLess81: Boolean;
var
  oMetaData: IADPhysConnectionMetaData;
begin
  FConnIntf.CreateMetadata(oMetaData);
  Result := oMetaData.ServerVersion < cvOracle81000;
end;

{-------------------------------------------------------------------------------}
// mkTables

function TADQAPhysMTITsHolder.CheckTableStructure(ATab: TADDatSTable): Boolean;
begin
  with ATab do begin
    Result := CheckColumnsCount(ATab, 6);
    if not Result then
      Exit;
    if AnsiCompareText(Columns[0].Name, C_RECNO)        <> 0 then Result := WrongName(0, C_RECNO);
    if AnsiCompareText(Columns[1].Name, C_CATALOG_NAME) <> 0 then Result := WrongName(1, C_CATALOG_NAME);
    if AnsiCompareText(Columns[2].Name, C_SCHEMA_NAME)  <> 0 then Result := WrongName(2, C_SCHEMA_NAME);
    if AnsiCompareText(Columns[3].Name, C_TABLE_NAME)   <> 0 then Result := WrongName(3, C_TABLE_NAME);
    if AnsiCompareText(Columns[4].Name, C_TABLE_TYPE)   <> 0 then Result := WrongName(4, C_TABLE_TYPE);
    if AnsiCompareText(Columns[5].Name, C_TABLE_SCOPE)  <> 0 then Result := WrongName(5, C_TABLE_SCOPE);
    if Columns[0].DataType <> dtInt32      then Result := WrongType(0, dtInt32);
    if Columns[1].DataType <> dtAnsiString then Result := WrongType(1, dtAnsiString);
    if Columns[2].DataType <> dtAnsiString then Result := WrongType(2, dtAnsiString);
    if Columns[3].DataType <> dtAnsiString then Result := WrongType(3, dtAnsiString);
    if Columns[4].DataType <> dtInt16      then Result := WrongType(4, dtInt16);
    if Columns[5].DataType <> dtInt16      then Result := WrongType(5, dtInt16);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysMTITsHolder.CheckTableData(ATab: TADDatSTable; AWildcard: Boolean);
var
  sMes: String;
  k, i, j: Integer;
  lFound: Boolean;
  V1, V2: Variant;
begin
  sMes := 'kind = mkTables';
  if AWildcard then begin
    k := WildCardRes_cnt;
    if ATab.Rows.Count <> k then begin
      Error('Wildcard doesn''t work. ' + WrongRowCount(k, ATab.Rows.Count));
      Exit;
    end;
  end
  else
    k := North_tab_cnt;
  for i := 0 to k - 1 do begin
    lFound := False;
    for j := 0 to ATab.Rows.Count - 1 do begin
      if not AWildcard then begin
        if (AnsiCompareText(ATab.Rows[j].GetData(3), NorthWind[i]) <> 0) then
          continue;
      end
      else
        if (AnsiCompareText(ATab.Rows[j].GetData(3), WildCardResult[i]) <> 0) then
          continue;

      CheckCatalogAndSchema(j, sMes);

      V1 := ATab.Rows[j].GetData(C_TABLE_TYPE);
      V2 := Ord(mkTables);
      if Compare(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_TABLE_TYPE, j, sMes, '',
              C_AD_PhysRDBMSKinds[FRDBMSKind],
              VarToStr(V1), VarToStr(V2)));

      V1 := ATab.Rows[j].GetData(C_TABLE_SCOPE);
      V2 := Ord(osMy);
      if Compare(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_TABLE_SCOPE, j, sMes + ' (' +
              ATab.Rows[j].GetData(3) + ')', '',
              C_AD_PhysRDBMSKinds[FRDBMSKind], ObjScopes[TADPhysObjectScope(V1)],
              ObjScopes[osMy]));
      lFound := True;
    end;
    if not lFound then
      if not AWildcard then
        Error(TableNotFound(NorthWind[i]))
      else
        Error(TableNotFound(WildCardResult[i]));
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysMTITsHolder.TestTables;
begin
  with FMetaCommIntf do begin
    // retrieving info about the tables
    MetaInfoKind := mkTables;
    ObjectScopes := [osMy, osSystem];
    TableKinds   := [tkTable, tkView];
    try
      Prepare;
      try
        Define(FTab);
        Open;
        Fetch(FTab);
      finally
        Unprepare;
      end;
    except
      on E: Exception do begin
        Error(ErrorMetaCommPrepare(E.Message));
        Exit;
      end;
    end;
    if CheckTableStructure(FTab) then
      CheckTableData(FTab, False);

    // check work of wildcard
    MetaInfoKind := mkTables;
    ObjectScopes := [osMy, osSystem];
    TableKinds   := [tkTable];
    Wildcard     := WildcardStr;
    try
      Prepare;
      try
        Define(FTab);
        Open;
        Fetch(FTab);
      finally
        Unprepare;
      end;
    except
      on E: Exception do begin
        Error(ErrorMetaCommPrepare(E.Message));
        Exit;
      end;
    end;
    if CheckTableStructure(FTab) then
      CheckTableData(FTab, True);
    Wildcard := '';
  end;
end;

{-------------------------------------------------------------------------------}
// mkTableFields

function TADQAPhysMTITsHolder.CheckTableFieldsStructure(ATab: TADDatSTable): Boolean;
begin
  with ATab do begin
    Result := CheckColumnsCount(ATab, 12);
    if not Result then
      Exit;
    if AnsiCompareText(Columns[0].Name,  C_RECNO)             <> 0 then Result := WrongName(0, C_RECNO);
    if AnsiCompareText(Columns[1].Name,  C_CATALOG_NAME)      <> 0 then Result := WrongName(1, C_CATALOG_NAME);
    if AnsiCompareText(Columns[2].Name,  C_SCHEMA_NAME)       <> 0 then Result := WrongName(2, C_SCHEMA_NAME);
    if AnsiCompareText(Columns[3].Name,  C_TABLE_NAME)        <> 0 then Result := WrongName(3, C_TABLE_NAME);
    if AnsiCompareText(Columns[4].Name,  C_COLUMN_NAME)       <> 0 then Result := WrongName(4, C_COLUMN_NAME);
    if AnsiCompareText(Columns[5].Name,  C_COLUMN_POSITION)   <> 0 then Result := WrongName(5, C_COLUMN_POSITION);
    if AnsiCompareText(Columns[6].Name,  C_COLUMN_DATATYPE)   <> 0 then Result := WrongName(6, C_COLUMN_DATATYPE);
    if AnsiCompareText(Columns[7].Name,  C_COLUMN_TYPENAME)   <> 0 then Result := WrongName(7, C_COLUMN_TYPENAME);
    if AnsiCompareText(Columns[8].Name,  C_COLUMN_ATTRIBUTES) <> 0 then Result := WrongName(8, C_COLUMN_ATTRIBUTES);
    if AnsiCompareText(Columns[9].Name,  C_COLUMN_PRECISION)  <> 0 then Result := WrongName(9, C_COLUMN_PRECISION);
    if AnsiCompareText(Columns[10].Name, C_COLUMN_SCALE)      <> 0 then Result := WrongName(10, C_COLUMN_SCALE);
    if AnsiCompareText(Columns[11].Name, C_COLUMN_LENGTH)     <> 0 then Result := WrongName(11, C_COLUMN_LENGTH);
    if Columns[0].DataType  <> dtInt32      then Result := WrongType(0,  dtInt32);
    if Columns[1].DataType  <> dtAnsiString then Result := WrongType(1,  dtAnsiString);
    if Columns[2].DataType  <> dtAnsiString then Result := WrongType(2,  dtAnsiString);
    if Columns[3].DataType  <> dtAnsiString then Result := WrongType(3,  dtAnsiString);
    if Columns[4].DataType  <> dtAnsiString then Result := WrongType(4,  dtAnsiString);
    if Columns[5].DataType  <> dtInt16      then Result := WrongType(5,  dtInt16);
    if Columns[6].DataType  <> dtInt16      then Result := WrongType(6,  dtInt16);
    if Columns[7].DataType  <> dtAnsiString then Result := WrongType(7,  dtAnsiString);
    if Columns[8].DataType  <> dtUInt32     then Result := WrongType(8,  dtUInt32);
    if Columns[9].DataType  <> dtInt16      then Result := WrongType(9,  dtInt16);
    if Columns[10].DataType <> dtInt16      then Result := WrongType(10, dtInt16);
    if Columns[11].DataType <> dtInt32      then Result := WrongType(11, dtInt32);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysMTITsHolder.CheckTableFieldsData(ATab: TADDatSTable);
var
  sMes, sObj, sTypeName: String;
  j: Integer;
  V1, V2: Variant;
begin
  if AnsiCompareText(ATab.Rows[0].GetData(3), 'Categories') = 0 then begin
    sMes := 'kind = mkTableFields';
    sObj := 'Categories';
    for j := 0 to ATab.Rows.Count - 1 do begin
      CheckCatalogAndSchema(j, sMes);

      V1 := VarToValue(ATab.Rows[j].GetData(C_COLUMN_NAME), '');
      V2 := Categ_field_name[j];
      if AnsiCompareText(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_COLUMN_NAME, j, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));

      V1 := VarToValue(ATab.Rows[j].GetData(C_COLUMN_POSITION), '');
      V2 := j + 1;
      if Compare(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_COLUMN_POSITION, j, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind],
              VarToStr(V1), VarToStr(V2)));

      V1 := VarToValue(ATab.Rows[j].GetData(C_COLUMN_DATATYPE), '');
      V2 := Categ_DType[FRDBMSKind, j];
      if AnsiCompareText(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_COLUMN_DATATYPE, j, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind],
              ADDataTypesNames[TADDataType(V1)],
              ADDataTypesNames[TADDataType(V2)]));

      V1 := VarToValue(ATab.Rows[j].GetData(C_COLUMN_TYPENAME), '');
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

      V1 := ATab.Rows[j].GetData(C_COLUMN_ATTRIBUTES);
      V2 := Categ_Col_attr[FRDBMSKind, j];
      if Compare(V1, V2) <> 0 then
        Error(WrongTypeValueMeta(C_COLUMN_ATTRIBUTES, sTypeName, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind],
              VarToStr(V1), VarToStr(V2)));

      V1 := VarToValue(ATab.Rows[j].GetData(C_COLUMN_PRECISION), 0);
      V2 := Categ_Col_prec[FRDBMSKind, j];
      if Compare(V1, V2) <> 0 then
        Error(WrongTypeValueMeta(C_COLUMN_PRECISION, sTypeName, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind],
              VarToStr(V1), VarToStr(V2)));

      V1 := VarToValue(ATab.Rows[j].GetData(C_COLUMN_SCALE), 0);
      V2 := Categ_Col_scal[FRDBMSKind, j];
      if Compare(V1, V2) <> 0 then
        Error(WrongTypeValueMeta(C_COLUMN_SCALE, sTypeName, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind],
              VarToStr(V1), VarToStr(V2)));

      V1 := VarToValue(ATab.Rows[j].GetData(C_COLUMN_LENGTH), 0);
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
    end;
  end;
  if AnsiCompareText(ATab.Rows[0].GetData(3), 'Order details') = 0 then begin
    sMes := 'kind = mkTableFields';
    sObj := 'Order details';
    for j := 0 to ATab.Rows.Count - 1 do begin
      CheckCatalogAndSchema(j, sMes);

      V1 := VarToValue(ATab.Rows[j].GetData(C_COLUMN_NAME), '');
      V2 := OrdDet_field_name[j];
      if AnsiCompareText(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_COLUMN_NAME, j, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));

      V1 := VarToValue(ATab.Rows[j].GetData(C_COLUMN_POSITION), 0);
      V2 := j + 1;
      if Compare(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_COLUMN_POSITION, j, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind],
              VarToStr(V1), VarToStr(V2)));

      V1 := ATab.Rows[j].GetData(C_COLUMN_DATATYPE);
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

      V1 := VarToValue(ATab.Rows[j].GetData(C_COLUMN_TYPENAME), '');
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

      V1 := ATab.Rows[j].GetData(C_COLUMN_ATTRIBUTES);
      V2 := OrdDet_Col_attr[FRDBMSKind, j];
      if Compare(V1, V2) <> 0 then
        Error(WrongTypeValueMeta(C_COLUMN_ATTRIBUTES, sTypeName, sMes,
              sObj, C_AD_PhysRDBMSKinds[FRDBMSKind],
              VarToStr(V1), VarToStr(V2)));

      V1 := VarToValue(ATab.Rows[j].GetData(C_COLUMN_PRECISION), 0);
      V2 := OrdDet_Col_prec[FRDBMSKind, j];
      if Compare(V1, V2) <> 0 then
        Error(WrongTypeValueMeta(C_COLUMN_PRECISION, sTypeName, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind],
              VarToStr(V1), VarToStr(V2)));

      V1 := VarToValue(ATab.Rows[j].GetData(C_COLUMN_SCALE), 0);
      V2 := OrdDet_Col_scal[FRDBMSKind, j];
      if Compare(V1, V2) <> 0 then
        Error(WrongTypeValueMeta(C_COLUMN_SCALE, sTypeName, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind],
              VarToStr(V1), VarToStr(V2)));

      V1 := VarToValue(ATab.Rows[j].GetData(C_COLUMN_LENGTH), 0);
      V2 := OrdDet_Col_len[FRDBMSKind, j];
      if Compare(V1, V2) <> 0 then
        Error(WrongTypeValueMeta(C_COLUMN_LENGTH, sTypeName, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind],
              VarToStr(V1), VarToStr(V2)));
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysMTITsHolder.TestTableFields;
var
  i: Integer;
begin
  with FMetaCommIntf do begin
    for i := 0 to North_tab_cnt - 1 do begin
      if not (i in [0, 6]) then {Categories, Order Details}
        continue;
      CommandText  := GetNorthWithRLCommas(i);
      MetaInfoKind := mkTableFields;
      try
        Prepare;
        try
          Define(FTab);
          Open;
          Fetch(FTab);
        finally
          Unprepare;
        end;
      except
        on E: Exception do begin
          Error(ErrorMetaCommPrepare(E.Message));
          Exit;
        end;
      end;
      if CheckTableFieldsStructure(FTab) then
        CheckTableFieldsData(FTab);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
// mkIndexes, mkPrimaryKey

function TADQAPhysMTITsHolder.CheckIndexStructure(ATab: TADDatSTable): Boolean;
begin
  with ATab do begin
    Result := CheckColumnsCount(ATab, 7);
    if not Result then
      Exit;
    if AnsiCompareText(Columns[0].Name, C_RECNO)        <> 0 then Result := WrongName(0, C_RECNO);
    if AnsiCompareText(Columns[1].Name, C_CATALOG_NAME) <> 0 then Result := WrongName(1, C_CATALOG_NAME);
    if AnsiCompareText(Columns[2].Name, C_SCHEMA_NAME)  <> 0 then Result := WrongName(2, C_SCHEMA_NAME);
    if AnsiCompareText(Columns[3].Name, C_TABLE_NAME)   <> 0 then Result := WrongName(3, C_TABLE_NAME);
    if AnsiCompareText(Columns[4].Name, C_INDEX_NAME)   <> 0 then Result := WrongName(4, C_INDEX_NAME);
    if AnsiCompareText(Columns[5].Name, C_PKEY_NAME)    <> 0 then Result := WrongName(5, C_PKEY_NAME);
    if AnsiCompareText(Columns[6].Name, C_INDEX_TYPE)   <> 0 then Result := WrongName(6, C_INDEX_TYPE);
    if Columns[0].DataType <> dtInt32      then Result := WrongType(0, dtInt32);
    if Columns[1].DataType <> dtAnsiString then Result := WrongType(1, dtAnsiString);
    if Columns[2].DataType <> dtAnsiString then Result := WrongType(2, dtAnsiString);
    if Columns[3].DataType <> dtAnsiString then Result := WrongType(3, dtAnsiString);
    if Columns[4].DataType <> dtAnsiString then Result := WrongType(4, dtAnsiString);
    if Columns[5].DataType <> dtAnsiString then Result := WrongType(5, dtAnsiString);
    if Columns[6].DataType <> dtInt16      then Result := WrongType(6, dtInt16);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysMTITsHolder.CheckIndexData(ATab: TADDatSTable;
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
  if ATab.Rows.Count = 0 then begin
    Error(RecCountIsZero(sMes));
    Exit;
  end;
  if AnsiCompareText(ATab.Rows[0].GetData(3), 'CustomerCustomerDemo') = 0 then begin
    sObj := 'CustomerCustomerDemo';
    for j := 0 to ATab.Rows.Count - 1 do begin
      CheckCatalogAndSchema(j, sMes);

      V1 := VarToValue(ATab.Rows[j].GetData(C_INDEX_NAME), '');
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
        V1 := VarToValue(ATab.Rows[j].GetData(C_PKEY_NAME), '');
        V2 := CustCustD_pkname[FRDBMSKind];
        if AnsiCompareText(V1, V2) <> 0 then
          Error(WrongValueInColumnMeta(C_PKEY_NAME, j, sMes, sObj,
                C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));
      end;

      V1 := ATab.Rows[j].GetData(C_INDEX_TYPE);
      V2 := CustCustD_indtp[FRDBMSKind, j];
      if Compare(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_INDEX_TYPE, j, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1), VarToStr(V2)));
    end;
  end;
  if AnsiCompareText(ATab.Rows[0].GetData(3), 'Order Details') = 0 then begin
    sObj := 'Orders Details';
    for j := 0 to ATab.Rows.Count - 1 do begin
      CheckCatalogAndSchema(j, sMes);

      V1 := VarToValue(ATab.Rows[j].GetData(C_INDEX_NAME), '');
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
        V1 := VarToValue(ATab.Rows[j].GetData(C_PKEY_NAME), '');
        V2 := OrdDet_pkname[FRDBMSKind];
        if AnsiCompareText(V1, V2) <> 0 then
          Error(WrongValueInColumnMeta(C_PKEY_NAME, j, sMes, sObj,
                C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));
      end;

      V1 := ATab.Rows[j].GetData(C_INDEX_TYPE);
      V2 := OrdDet_indtp[FRDBMSKind, j];
      if Compare(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_INDEX_TYPE, j, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1), VarToStr(V2)));
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysMTITsHolder.TestIndexes;
var
  i: Integer;
begin
  with FMetaCommIntf do begin
    for i := 0 to North_tab_cnt - 1 do begin
      if not(i in [1, 6]) then {CustomerCustomerDemo, Order Details}
        continue;
      CommandText  := GetNorthWithRLCommas(i);
      MetaInfoKind := mkIndexes;
      try
        Prepare;
        try
          Define(FTab);
          Open;
          Fetch(FTab);
        finally
          Unprepare;
        end;
      except
        on E: Exception do begin
          Error(ErrorMetaCommPrepare(E.Message));
          Exit;
        end;
      end;
      if CheckIndexStructure(FTab) then
        CheckIndexData(FTab, mkIndexes);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysMTITsHolder.TestPrimaryKey;
var
  i: Integer;
begin
  with FMetaCommIntf do begin
    for i := 0 to North_tab_cnt - 1 do begin
      if not (i in [1, 6]) then {CustomerCustomerDemo, Order Details}
        continue;
      CommandText  := GetNorthWithRLCommas(i);
      MetaInfoKind := mkPrimaryKey;
      try
        Prepare;
        try
          Define(FTab);
          Open;
          Fetch(FTab);
        finally
          Unprepare;
        end;
      except
        on E: Exception do begin
          Error(ErrorMetaCommPrepare(E.Message));
          Exit;
        end;
      end;
      if CheckIndexStructure(FTab) then
        CheckIndexData(FTab, mkPrimaryKey);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
// mkIndexFields, mkPrimaryKeyFields

function TADQAPhysMTITsHolder.CheckIndexFieldsStructure(ATab: TADDatSTable): Boolean;
begin
  with ATab do begin
    Result := CheckColumnsCount(ATab, 9);
    if not Result then
      Exit;
    if AnsiCompareText(Columns[0].Name, C_RECNO)           <> 0 then Result := WrongName(0, C_RECNO);
    if AnsiCompareText(Columns[1].Name, C_CATALOG_NAME)    <> 0 then Result := WrongName(1, C_CATALOG_NAME);
    if AnsiCompareText(Columns[2].Name, C_SCHEMA_NAME)     <> 0 then Result := WrongName(2, C_SCHEMA_NAME);
    if AnsiCompareText(Columns[3].Name, C_TABLE_NAME)      <> 0 then Result := WrongName(3, C_TABLE_NAME);
    if AnsiCompareText(Columns[4].Name, C_INDEX_NAME)      <> 0 then Result := WrongName(4, C_INDEX_NAME);
    if AnsiCompareText(Columns[5].Name, C_COLUMN_NAME)     <> 0 then Result := WrongName(5, C_COLUMN_NAME);
    if AnsiCompareText(Columns[6].Name, C_COLUMN_POSITION) <> 0 then Result := WrongName(6, C_COLUMN_POSITION);
    if AnsiCompareText(Columns[7].Name, C_SORT_ORDER)      <> 0 then Result := WrongName(7, C_SORT_ORDER);
    if AnsiCompareText(Columns[8].Name, C_FILTER)          <> 0 then Result := WrongName(8, C_FILTER);
    if Columns[0].DataType <> dtInt32      then Result := WrongType(0, dtInt32);
    if Columns[1].DataType <> dtAnsiString then Result := WrongType(1, dtAnsiString);
    if Columns[2].DataType <> dtAnsiString then Result := WrongType(2, dtAnsiString);
    if Columns[3].DataType <> dtAnsiString then Result := WrongType(3, dtAnsiString);
    if Columns[4].DataType <> dtAnsiString then Result := WrongType(4, dtAnsiString);
    if Columns[5].DataType <> dtAnsiString then Result := WrongType(5, dtAnsiString);
    if Columns[6].DataType <> dtInt16      then Result := WrongType(6, dtInt16);
    if Columns[7].DataType <> dtAnsiString then Result := WrongType(7, dtAnsiString);
    if Columns[8].DataType <> dtAnsiString then Result := WrongType(8, dtAnsiString);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysMTITsHolder.CheckIndexFieldsData(ATab: TADDatSTable;
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
  if ATab.Rows.Count = 0 then begin
    Error(RecCountIsZero(sMes));
    Exit;
  end;
  if AnsiCompareText(ATab.Rows[0].GetData(3), 'CustomerCustomerDemo') = 0 then begin
    if ATab.Rows[0].GetData(C_INDEX_NAME) = CustCustD_ind[FRDBMSKind, 0] then begin
      for j := 0 to ATab.Rows.Count - 1 do begin
        CheckCatalogAndSchema(j, sMes);

        V1 := VarToValue(ATab.Rows[j].GetData(C_COLUMN_NAME), '');
        V2 := CustCustD_colname[j];
        if AnsiCompareText(V1, V2) <> 0 then
          Error(WrongValueInColumnMeta(C_COLUMN_NAME, j, sMes, sObj,
                C_AD_PhysRDBMSKinds[FRDBMSKind],
                VarToStr(V1), VarToStr(V2)));

        V1 := ATab.Rows[j].GetData(C_COLUMN_POSITION);
        V2 := j + 1;
        if Compare(V1, V2) <> 0 then
          Error(WrongValueInColumnMeta(C_COLUMN_POSITION, j, sMes, sObj,
                C_AD_PhysRDBMSKinds[FRDBMSKind],
                VarToStr(V1), VarToStr(V2)));

        V1 := ATab.Rows[j].GetData(C_SORT_ORDER);
        V2 := 'A';
        if Compare(V1, V2) <> 0 then
          Error(WrongValueInColumnMeta(C_SORT_ORDER, j, sMes, sObj,
                C_AD_PhysRDBMSKinds[FRDBMSKind],
                VarToStr(V1), VarToStr(V2)));

        V1 := VarToValue(ATab.Rows[j].GetData(C_FILTER), '');
        V2 := '';
        if Compare(V1, V2) <> 0 then
          Error(WrongValueInColumnMeta(C_FILTER, j, sMes, sObj,
                C_AD_PhysRDBMSKinds[FRDBMSKind],
                VarToStr(V1), VarToStr(V2)));
      end;
    end;
    if ATab.Rows[0].GetData(C_INDEX_NAME) = CustCustD_ind[FRDBMSKind, 1] then begin
      V1 := VarToValue(ATab.Rows[0].GetData(C_COLUMN_NAME), '');
      V2 := CustCustD_colname[0];
      if AnsiCompareText(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_COLUMN_NAME, 0, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));
    end;
    if ATab.Rows[0].GetData(C_INDEX_NAME) = CustCustD_ind[FRDBMSKind, 2] then begin
      V1 := VarToValue(ATab.Rows[0].GetData(C_COLUMN_NAME), '');
      V2 := CustCustD_colname[1];
      if AnsiCompareText(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_COLUMN_NAME, 0, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysMTITsHolder.TestIndexFields;
var
  oIndexTab: TADDatSTable;
  i, j: Integer;
begin
  with FMetaCommIntf do begin
    oIndexTab := FDatSManager.Tables.Add;
    try
      for i := 0 to 12 do begin
        CommandText  := GetNorthWithRLCommas(i);
        MetaInfoKind := mkIndexes;
        try
          Prepare;
          try
            Define(oIndexTab);
            Open;
            Fetch(oIndexTab);
          finally
            Unprepare;
          end;
        except
          on E: Exception do begin
            Error(ErrorMetaCommPrepare(E.Message));
            Exit;
          end;
        end;
        for j := 0 to oIndexTab.Rows.Count - 1 do begin
          BaseObjectName := GetNorthWithRLCommas(i);
          CommandText    := LeftCommas[FRDBMSKind] + VarToValue(oIndexTab.Rows[j].GetData(4), '') +
                            RightCommas[FRDBMSKind];
          MetaInfoKind   := mkIndexFields;
          try
            Prepare;
            try
              Define(FTab);
              Open;
              Fetch(FTab);
            finally
              Unprepare;
            end;
          except
            on E: Exception do begin
              Error(ErrorMetaCommPrepare(E.Message));
              Exit;
            end;
          end;
          if CheckIndexFieldsStructure(FTab) then
            CheckIndexFieldsData(FTab, mkIndexFields);
        end;
      end;
    finally
      oIndexTab.Free;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysMTITsHolder.TestPKFields;
var
  oIndexTab: TADDatSTable;
  i, j: Integer;
begin
  with FMetaCommIntf do begin
    oIndexTab := FDatSManager.Tables.Add;
    try
      for i := 0 to 12 do begin
        CommandText  := GetNorthWithRLCommas(i);
        MetaInfoKind := mkPrimaryKey;
        try
          Prepare;
          try
            Define(oIndexTab);
            Open;
            Fetch(oIndexTab);
          finally
            Unprepare;
          end;
        except
          on E: Exception do begin
            Error(ErrorMetaCommPrepare(E.Message));
            Exit;
          end;
        end;
        for j := 0 to oIndexTab.Rows.Count - 1 do begin
          BaseObjectName := GetNorthWithRLCommas(i);
          CommandText    := LeftCommas[FRDBMSKind] + oIndexTab.Rows[j].GetData(4) +
                            RightCommas[FRDBMSKind];
          MetaInfoKind   := mkPrimaryKeyFields;
          try
            Prepare;
            try
              Define(FTab);
              Open;
              Fetch(FTab);
            finally
              Unprepare;
            end;
          except
            on E: Exception do begin
              Error(ErrorMetaCommPrepare(E.Message));
              Exit;
            end;
          end;
          if CheckIndexFieldsStructure(FTab) then
            CheckIndexFieldsData(FTab, mkPrimaryKeyFields);
        end;
      end;
    finally
      oIndexTab.Free;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
// mkPackages

function TADQAPhysMTITsHolder.CheckPackagesStructure(ATab: TADDatSTable): Boolean;
begin
  with ATab do begin
    Result := CheckColumnsCount(ATab, 5);
    if not Result then
      Exit;
    if AnsiCompareText(Columns[0].Name, C_RECNO)         <> 0 then Result := WrongName(0, C_RECNO);
    if AnsiCompareText(Columns[1].Name, C_CATALOG_NAME)  <> 0 then Result := WrongName(1, C_CATALOG_NAME);
    if AnsiCompareText(Columns[2].Name, C_SCHEMA_NAME)   <> 0 then Result := WrongName(2, C_SCHEMA_NAME);
    if AnsiCompareText(Columns[3].Name, C_PACKAGE_NAME)  <> 0 then Result := WrongName(3, C_PACKAGE_NAME);
    if AnsiCompareText(Columns[4].Name, C_PACKAGE_SCOPE) <> 0 then Result := WrongName(4, C_PACKAGE_SCOPE);
    if Columns[0].DataType <> dtInt32      then Result := WrongType(0, dtInt32);
    if Columns[1].DataType <> dtAnsiString then Result := WrongType(1, dtAnsiString);
    if Columns[2].DataType <> dtAnsiString then Result := WrongType(2, dtAnsiString);
    if Columns[3].DataType <> dtAnsiString then Result := WrongType(3, dtAnsiString);
    if Columns[4].DataType <> dtInt16      then Result := WrongType(4, dtInt16);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysMTITsHolder.CheckPackagesData(ATab: TADDatSTable);
var
  sMes: String;
  V1, V2: Variant;
  j: Integer;
  lFound: Boolean;
begin
  sMes := 'kind = mkPackages';
  lFound := False;
  for j := 0 to ATab.Rows.Count - 1 do begin
    CheckCatalogAndSchema(j, sMes);

    V1 := VarToValue(ATab.Rows[j].GetData(C_PACKAGE_NAME), '');
    V2 := Pack_name[0];
    if AnsiCompareText(V1, V2) <> 0 then
      continue;
    lFound := True;

    V1 := ATab.Rows[j].GetData(C_PACKAGE_SCOPE);
    V2 := osMy;
    if Compare(V1, V2) <> 0 then
      Error(WrongValueInColumnMeta(C_PACKAGE_SCOPE, j, sMes, '',
            C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1), VarToStr(V2)));
  end;
  if not lFound then
    Error(WrongValueInColumnMeta(C_PACKAGE_NAME, -1, sMes, '',
          C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysMTITsHolder.TestPackages;
begin
  with FMetaCommIntf do begin
    ObjectScopes := [osMy];
    MetaInfoKind := mkPackages;
    try
      Prepare;
      try
        Define(FTab);
        Open;
        Fetch(FTab);
      finally
        Unprepare;
      end;
    except
      on E: Exception do begin
        Error(ErrorMetaCommPrepare(E.Message));
        Exit;
      end;
    end;
    if CheckPackagesStructure(FTab) then
      CheckPackagesData(FTab);
  end;
end;

{-------------------------------------------------------------------------------}
// mkProcs

function TADQAPhysMTITsHolder.CheckProcsStructure(ATab: TADDatSTable): Boolean;
begin
  with ATab do begin
    Result := CheckColumnsCount(ATab, 10);
    if not Result then
      Exit;
    if AnsiCompareText(Columns[0].Name, C_RECNO)        <> 0 then Result := WrongName(0, C_RECNO);
    if AnsiCompareText(Columns[1].Name, C_CATALOG_NAME) <> 0 then Result := WrongName(1, C_CATALOG_NAME);
    if AnsiCompareText(Columns[2].Name, C_SCHEMA_NAME)  <> 0 then Result := WrongName(2, C_SCHEMA_NAME);
    if AnsiCompareText(Columns[3].Name, C_PACK_NAME)    <> 0 then Result := WrongName(3, C_PACKAGE_NAME);
    if AnsiCompareText(Columns[4].Name, C_PROC_NAME)    <> 0 then Result := WrongName(4, C_PROC_NAME);
    if AnsiCompareText(Columns[5].Name, C_OVERLOAD)     <> 0 then Result := WrongName(5, C_OVERLOAD);
    if AnsiCompareText(Columns[6].Name, C_PROC_TYPE)    <> 0 then Result := WrongName(6, C_PROC_TYPE);
    if AnsiCompareText(Columns[7].Name, C_PROC_SCOPE)   <> 0 then Result := WrongName(7, C_PROC_SCOPE);
    if AnsiCompareText(Columns[8].Name, C_IN_PARAMS)    <> 0 then Result := WrongName(8, C_IN_PARAMS);
    if AnsiCompareText(Columns[9].Name, C_OUT_PARAMS)   <> 0 then Result := WrongName(9, C_OUT_PARAMS);
    if Columns[0].DataType <> dtInt32      then Result := WrongType(0, dtInt32);
    if Columns[1].DataType <> dtAnsiString then Result := WrongType(1, dtAnsiString);
    if Columns[2].DataType <> dtAnsiString then Result := WrongType(2, dtAnsiString);
    if Columns[3].DataType <> dtAnsiString then Result := WrongType(3, dtAnsiString);
    if Columns[4].DataType <> dtAnsiString then Result := WrongType(4, dtAnsiString);
    if Columns[5].DataType <> dtInt16      then Result := WrongType(5, dtInt16);
    if Columns[6].DataType <> dtInt16      then Result := WrongType(6, dtInt16);
    if Columns[7].DataType <> dtInt16      then Result := WrongType(7, dtInt16);
    if Columns[8].DataType <> dtInt16      then Result := WrongType(8, dtInt16);
    if Columns[9].DataType <> dtInt16      then Result := WrongType(9, dtInt16);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysMTITsHolder.CheckProcsData(ATab: TADDatSTable;
  APackaged: Boolean);
var
  sMes: String;
  lFirst, lSec, lFound: Boolean;
  V1, V2: Variant;
  j, i, iPos: Integer;
  oView: TADDatSView;
begin
  sMes   := 'kind = mkProcs';
  lFirst := False;
  lSec   := False;
  oView  := ATab.DefaultView;
  if FRDBMSKind = mkOracle then begin
    if APackaged then begin
      sMes := 'In package, ' + sMes;
      for j := 0 to ATab.Rows.Count - 1 do begin
        CheckCatalogAndSchema(j, sMes);

        V1 := VarToValue(ATab.Rows[j].GetData(C_PROC_NAME), '');
        V2 := ProcInPack[j];
        if AnsiCompareText(V1, V2) = 0 then
          if j = 0 then
            lFirst := True
          else
            lSec := True;

        V1 := ATab.Rows[j].GetData(C_PROC_TYPE);
        V2 := ProcPropInPack[j, 0];
        if Compare(V1, V2) <> 0 then
          Error(WrongValueInColumnMeta(C_PROC_TYPE, j, sMes, '',
                C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
                VarToStr(V2)));

        V1 := ATab.Rows[j].GetData(C_PROC_SCOPE);
        V2 := ProcPropInPack[j, 1];
        if Compare(V1, V2) <> 0 then
          Error(WrongValueInColumnMeta(C_PROC_SCOPE, j, sMes, '',
                C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
                VarToStr(V2)));

        V1 := ATab.Rows[j].GetData(C_IN_PARAMS);
        V2 := ProcPropInPack[j, 2];
        if Compare(V1, V2) <> 0 then
          Error(WrongValueInColumnMeta(C_IN_PARAMS, j, sMes, '',
                C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
                VarToStr(V2)));

        V1 := ATab.Rows[j].GetData(C_OUT_PARAMS);
        V2 := ProcPropInPack[j, 3];
        if Compare(V1, V2) <> 0 then
          Error(WrongValueInColumnMeta(C_OUT_PARAMS, j, sMes, '',
                C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
                VarToStr(V2)));

        V1 := VarToValue(ATab.Rows[j].GetData(C_OVERLOAD), 0);
        V2 := ProcPropInPack[j, 4];
        if Compare(V1, V2) <> 0 then
          Error(WrongValueInColumnMeta(C_OVERLOAD, j, sMes, '',
                C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
                VarToStr(V2)));
      end;
      if not (lFirst and lSec) then
        Error(WrongValueInColumnMeta(C_PROC_NAME, -1, sMes, '',
              C_AD_PhysRDBMSKinds[FRDBMSKind], '', ''));
    end
    else begin
      oView.Mechanisms.Clear;
      oView.Mechanisms.AddSort(C_PROC_NAME);
      sMes := 'Without package, ' + sMes;
      for j := 0 to oView.Rows.Count - 1 do begin
        if j = CountOfOraProc then
          break;
        CheckCatalogAndSchema(j, sMes);

        V1 := VarToValue(oView.Rows[j].GetData(C_PROC_NAME), '');
        V2 := ProcWithoutPack[j];
        if AnsiCompareText(V1, V2) <> 0 then
          Error(WrongValueInColumnMeta(C_PROC_NAME, j, sMes, '',
                C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));

        V1 := oView.Rows[j].GetData(C_PROC_TYPE);
        V2 := ProcPropWithoutPack[j, 0];
        if Compare(V1, V2) <> 0 then
          Error(WrongValueInColumnMeta(C_PROC_TYPE, j, sMes, '',
                C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
                VarToStr(V2)));

        V1 := oView.Rows[j].GetData(C_PROC_SCOPE);
        V2 := ProcPropWithoutPack[j, 1];
        if Compare(V1, V2) <> 0 then
          Error(WrongValueInColumnMeta(C_PROC_SCOPE, j, sMes, '',
                C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
                VarToStr(V2)));

        V1 := VarToValue(oView.Rows[j].GetData(C_IN_PARAMS), 0);
        V2 := ProcPropWithoutPack[j, 2];
        if Compare(V1, V2) <> 0 then
          Error(WrongValueInColumnMeta(C_IN_PARAMS, j, sMes, '',
                C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
                VarToStr(V2)));

        V1 := VarToValue(oView.Rows[j].GetData(C_OUT_PARAMS), 0);
        V2 := ProcPropWithoutPack[j, 3];
        if Compare(V1, V2) <> 0 then
          Error(WrongValueInColumnMeta(C_OUT_PARAMS, j, sMes, '',
                C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
                VarToStr(V2)));

        V1 := VarToValue(oView.Rows[j].GetData(C_OVERLOAD), 0);
        V2 := ProcPropWithoutPack[j, 4];
        if Compare(V1, V2) <> 0 then
          Error(WrongValueInColumnMeta(C_OVERLOAD, j, sMes, '',
                C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
                VarToStr(V2)));
      end
    end
  end
  else if FRDBMSKind = mkDB2 then begin
    sMes := 'Without package, ' + sMes;
    lFound := False;
    for j := 0 to oView.Rows.Count - 1 do begin
      V1 := VarToValue(oView.Rows[j].GetData(C_CATALOG_NAME), '');
      V2 := '';
      if AnsiCompareText(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_CATALOG_NAME, j, sMes, '',
              C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));

      V1 := VarToValue(oView.Rows[j].GetData(C_PROC_NAME), '');
      V2 := ProcForDefineArgs[1];
      if AnsiCompareText(V1, V2) = 0 then begin
        lFound := True;
        break;
      end;
    end;
    if not lFound then
      Error(ObjIsNotFound(ProcForDefineArgs[1], sMes));
  end
  else if FRDBMSKind = mkMSSQL then begin
    oView.Mechanisms.Clear;
    oView.Mechanisms.AddSort(C_PROC_NAME);
    for j := 0 to oView.Rows.Count - 1 do begin
      CheckCatalogAndSchema(j, sMes);

      V1 := oView.Rows[j].GetData(C_PROC_NAME);
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
      if i < 0 then
        continue;

      V1 := oView.Rows[j].GetData(C_PROC_TYPE);
      V2 := ProcPropInMSSQL[i, 0];
      if Compare(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_PROC_TYPE, j, sMes, ProcInMSSQL[i],
              C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1), VarToStr(V2)));

      V1 := oView.Rows[j].GetData(C_PROC_SCOPE);
      V2 := ProcPropInMSSQL[i, 1];
      if Compare(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_PROC_SCOPE, j, sMes, ProcInMSSQL[i],
              C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1), VarToStr(V2)));

      V1 := VarToValue(oView.Rows[j].GetData(C_IN_PARAMS), 0);
      V2 := ProcPropInMSSQL[i, 2];
      if Compare(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_IN_PARAMS, j, sMes, ProcInMSSQL[i],
              C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1), VarToStr(V2)));

      V1 := VarToValue(oView.Rows[j].GetData(C_OUT_PARAMS), 0);
      V2 := ProcPropInMSSQL[i, 3];
      if Compare(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_OUT_PARAMS, j, sMes, ProcInMSSQL[i],
              C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1), VarToStr(V2)));

      V1 := VarToValue(oView.Rows[j].GetData(C_OVERLOAD), 0);
      V2 := ProcPropInMSSQL[i, 4];
      if Compare(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_OVERLOAD, j, sMes, ProcInMSSQL[i],
              C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1), VarToStr(V2)));
      if i = 1 then
        break;
    end
  end
  else begin
    oView.Mechanisms.Clear;
    oView.Mechanisms.AddSort(C_PROC_NAME);
    for j := 0 to oView.Rows.Count - 1 do begin
      V1 := oView.Rows[j].GetData(C_PROC_NAME);
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
      if i < 0 then
        continue;

      CheckCatalogAndSchema(j, sMes);

      V1 := oView.Rows[j].GetData(C_PROC_TYPE);
      V2 := ProcPropInASA[i, 0];
      if Compare(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_PROC_TYPE, j, sMes, ProcInASA[i],
              C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1), VarToStr(V2)));

      V1 := oView.Rows[j].GetData(C_PROC_SCOPE);
      V2 := ProcPropInASA[i, 1];
      if Compare(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_PROC_SCOPE, j, sMes, ProcInASA[i],
              C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1), VarToStr(V2)));

      V1 := VarToValue(oView.Rows[j].GetData(C_IN_PARAMS), 0);
      V2 := ProcPropInASA[i, 2];
      if Compare(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_IN_PARAMS, j, sMes, ProcInASA[i],
              C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1), VarToStr(V2)));

      V1 := VarToValue(oView.Rows[j].GetData(C_OUT_PARAMS), 0);
      V2 := ProcPropInASA[i, 3];
      if Compare(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_OUT_PARAMS, j, sMes, ProcInASA[i],
              C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1), VarToStr(V2)));

      V1 := VarToValue(oView.Rows[j].GetData(C_OVERLOAD), 0);
      V2 := ProcPropInASA[i, 4];
      if Compare(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_OVERLOAD, j, sMes, ProcInASA[i],
              C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1), VarToStr(V2)));
      if i = 1 then
        break;
    end
  end
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysMTITsHolder.TestProcs;
begin
  with FMetaCommIntf do begin
    ObjectScopes := [osMy];
    MetaInfoKind := mkProcs;
    if FRDBMSKind = mkDB2 then
      SchemaName := 'SYSPROC';
    try
      Prepare;
      try
        Define(FTab);
        Open;
        Fetch(FTab);
      finally
        if FRDBMSKind = mkDB2 then
          SchemaName := '';
        Unprepare;
      end;
    except
      on E: Exception do begin
        Error(ErrorMetaCommPrepare(E.Message));
        Exit;
      end;
    end;
    if CheckProcsStructure(FTab) then
      CheckProcsData(FTab, False);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysMTITsHolder.TestPackagedProcs;
begin
  with FMetaCommIntf do begin
    ObjectScopes   := [osMy];
    BaseObjectName := 'ADQA_All_types_PACK';
    MetaInfoKind   := mkProcs;
    try
      Prepare;
      try
        Define(FTab);
        Open;
        Fetch(FTab);
      finally
        Unprepare;
        BaseObjectName := '';
      end;
    except
      on E: Exception do begin
        Error(ErrorMetaCommPrepare(E.Message));
        Exit;
      end;
    end;
    if CheckProcsStructure(FTab) then
      CheckProcsData(FTab, True);
  end;
end;

{-------------------------------------------------------------------------------}
// mkProcArgs

function TADQAPhysMTITsHolder.CheckProcArgsStructure(ATab: TADDatSTable): Boolean;
begin
  with ATab do begin
    Result := CheckColumnsCount(ATab, 15);
    if not Result then
      Exit;
    if AnsiCompareText(Columns[0].Name, C_RECNO)            <> 0 then Result := WrongName(0, C_RECNO);
    if AnsiCompareText(Columns[1].Name, C_CATALOG_NAME)     <> 0 then Result := WrongName(1, C_CATALOG_NAME);
    if AnsiCompareText(Columns[2].Name, C_SCHEMA_NAME)      <> 0 then Result := WrongName(2, C_SCHEMA_NAME);
    if AnsiCompareText(Columns[3].Name, C_PACK_NAME)        <> 0 then Result := WrongName(3, C_PACKAGE_NAME);
    if AnsiCompareText(Columns[4].Name, C_PROC_NAME)        <> 0 then Result := WrongName(4, C_PROC_NAME);
    if AnsiCompareText(Columns[5].Name, C_OVERLOAD)         <> 0 then Result := WrongName(5, C_OVERLOAD);
    if AnsiCompareText(Columns[6].Name, C_PARAM_NAME)       <> 0 then Result := WrongName(6, C_PARAM_NAME);
    if AnsiCompareText(Columns[7].Name, C_PARAM_POSITION)   <> 0 then Result := WrongName(7, C_PARAM_POSITION);
    if AnsiCompareText(Columns[8].Name, C_PARAM_TYPE)       <> 0 then Result := WrongName(8, C_PARAM_TYPE);
    if AnsiCompareText(Columns[9].Name, C_PARAM_DATATYPE)   <> 0 then Result := WrongName(9, C_PARAM_DATATYPE);
    if AnsiCompareText(Columns[10].Name, C_PARAM_TYPENAME)  <> 0 then Result := WrongName(10, C_PARAM_TYPENAME);
    if AnsiCompareText(Columns[11].Name, C_PARAM_ATTRIBUTES)<> 0 then Result := WrongName(11, C_PARAM_ATTRIBUTES);
    if AnsiCompareText(Columns[12].Name, C_PARAM_PRECISION) <> 0 then Result := WrongName(12, C_PARAM_PRECISION);
    if AnsiCompareText(Columns[13].Name, C_PARAM_SCALE)     <> 0 then Result := WrongName(13, C_PARAM_SCALE);
    if AnsiCompareText(Columns[14].Name, C_PARAM_LENGTH)    <> 0 then Result := WrongName(14, C_PARAM_LENGTH);
    if Columns[0].DataType  <> dtInt32      then Result := WrongType(0, dtInt32);
    if Columns[1].DataType  <> dtAnsiString then Result := WrongType(1, dtAnsiString);
    if Columns[2].DataType  <> dtAnsiString then Result := WrongType(2, dtAnsiString);
    if Columns[3].DataType  <> dtAnsiString then Result := WrongType(3, dtAnsiString);
    if Columns[4].DataType  <> dtAnsiString then Result := WrongType(4, dtAnsiString);
    if Columns[5].DataType  <> dtInt16      then Result := WrongType(5, dtInt16);
    if Columns[6].DataType  <> dtAnsiString then Result := WrongType(6, dtAnsiString);
    if Columns[7].DataType  <> dtInt16      then Result := WrongType(7, dtInt16);
    if Columns[8].DataType  <> dtInt16      then Result := WrongType(8, dtInt16);
    if Columns[9].DataType  <> dtInt16      then Result := WrongType(9, dtInt16);
    if Columns[10].DataType <> dtAnsiString then Result := WrongType(10, dtAnsiString);
    if Columns[11].DataType <> dtUInt32     then Result := WrongType(11, dtUInt32);
    if Columns[12].DataType <> dtInt16      then Result := WrongType(12, dtInt16);
    if Columns[13].DataType <> dtInt16      then Result := WrongType(13, dtInt16);
    if Columns[14].DataType <> dtInt32      then Result := WrongType(14, dtInt32);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysMTITsHolder.CheckProcArgsData(ATab: TADDatSTable;
  APackaged: Boolean);
var
  sMes, sObj, sArgName, sTypeOfArgName: String;
  V1, V2: Variant;
  j: Integer;
  oView: TADDatSView;
  oTab: TADDatSTable;
  oCommand: IADPhysCommand;
begin
  oView := ATab.DefaultView;
  oView.Mechanisms.Clear;
  oView.Mechanisms.AddSort(C_PARAM_NAME);
  sMes := 'kind = mkProcArgs';
  sObj := 'Get_Valuesp';
  if FRDBMSKind = mkOracle then begin
    if APackaged then begin
      sMes := 'In package, ' + sMes;
      CheckCatalogAndSchema(0, sMes);

      V1 := VarToValue(oView.Rows[0].GetData(C_PACK_NAME), '');
      V2 := 'ADQA_All_types_PACK';
      if AnsiCompareText(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_PACK_NAME, 0, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));

      V1 := oView.Rows[0].GetData(C_PARAM_NAME);
      V2 := 'CUR';
      if AnsiCompareText(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_PARAM_NAME, 0, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));
      sArgName := V1;

      V1 := oView.Rows[0].GetData(C_PARAM_POSITION);
      V2 := 1;
      if Compare(V1, V2) <> 0 then
        Error(WrongProcArgValueMeta(C_PARAM_POSITION, sArgName, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1), VarToStr(V2)));

      V1 := oView.Rows[0].GetData(C_PARAM_TYPE);
      V2 := 2;
      if Compare(V1, V2) <> 0 then
        Error(WrongProcArgValueMeta(C_PARAM_TYPE, sArgName, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1), VarToStr(V2)));

      V1 := oView.Rows[0].GetData(C_PARAM_DATATYPE);
      V2 := 29;
      if Compare(V1, V2) <> 0 then
        Error(WrongProcArgValueMeta(C_PARAM_DATATYPE, sArgName, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind],
              ADDataTypesNames[TADDataType(V1)],
              ADDataTypesNames[TADDataType(V2)]));

      V1 := oView.Rows[0].GetData(C_PARAM_TYPENAME);
      V2 := 'REF CURSOR';
      if AnsiCompareText(V1, V2) <> 0 then
        Error(WrongProcArgValueMeta(C_PARAM_TYPENAME, sArgName, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));

      V1 := oView.Rows[0].GetData(C_PARAM_ATTRIBUTES);
      V2 := 4;
      if Compare(V1, V2) <> 0 then
        Error(WrongProcArgValueMeta(C_PARAM_ATTRIBUTES, sArgName, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1), VarToStr(V2)));

      V1 := VarToValue(oView.Rows[0].GetData(C_PARAM_PRECISION), 0);
      V2 := 0;
      if Compare(V1, V2) <> 0 then
        Error(WrongProcArgValueMeta(C_PARAM_PRECISION, sArgName, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1), VarToStr(V2)));

      V1 := VarToValue(oView.Rows[0].GetData(C_PARAM_SCALE), 0);
      V2 := 0;
      if Compare(V1, V2) <> 0 then
        Error(WrongProcArgValueMeta(C_PARAM_SCALE, sArgName, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1), VarToStr(V2)));

      V1 := VarToValue(oView.Rows[0].GetData(C_PARAM_LENGTH), 0);
      V2 := 0;
      if Compare(V1, V2) <> 0 then
        Error(WrongProcArgValueMeta(C_PARAM_LENGTH, sArgName, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1), VarToStr(V2)));
    end
    else begin
      sMes := 'Without package, ' + sMes;
      sObj := 'ADQA_All_Vals';
      for j := 0 to oView.Rows.Count - 1 do begin
        CheckCatalogAndSchema(j, sMes);

        V1 := VarToValue(oView.Rows[j].GetData(C_PACK_NAME), '');
        V2 := '';
        if AnsiCompareText(V1, V2) <> 0 then
          Error(WrongValueInColumnMeta(C_PACK_NAME, j, sMes, sObj,
                C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));

        V1 := oView.Rows[j].GetData(C_PARAM_NAME);
        V2 := ProcArgWithoutPack[j];
        if AnsiCompareText(V1, V2) <> 0 then
          Error(WrongValueInColumnMeta(C_PARAM_NAME, j, sMes, sObj,
                C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));
        sArgName := V1;

        V1 := oView.Rows[j].GetData(C_PARAM_POSITION);
        V2 := ProcArgPropWPack[j, 0];
        if Compare(V1, V2) <> 0 then
          Error(WrongProcArgValueMeta(C_PARAM_POSITION, sArgName, sMes, sObj,
                C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1), VarToStr(V2)));

        V1 := oView.Rows[j].GetData(C_PARAM_TYPE);
        V2 := ProcArgPropWPack[j, 1];
        if Compare(V1, V2) <> 0 then
          Error(WrongProcArgValueMeta(C_PARAM_TYPE, sArgName, sMes, sObj,
                C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1), VarToStr(V2)));

        V1 := oView.Rows[j].GetData(C_PARAM_DATATYPE);
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

        V1 := oView.Rows[j].GetData(C_PARAM_TYPENAME);
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

        V1 := oView.Rows[j].GetData(C_PARAM_ATTRIBUTES);
        V2 := ProcArgPropWPack[j, 3];
        if (j = 13) and OraServerLess81 then {I_UROWID}
          V2 := ProcArgPropWPack[12, 3];
        if (j = 29) and OraServerLess81 then {O_UROWID}
          V2 := ProcArgPropWPack[28, 3];
        if Compare(V1, V2) <> 0 then
          Error(WrongProcArgValueMeta(C_PARAM_ATTRIBUTES, sArgName, sMes,
                sObj, C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
                VarToStr(V2)));

        V1 := VarToValue(oView.Rows[j].GetData(C_PARAM_PRECISION), 0);
        V2 := ProcArgPropWPack[j, 4];
        if (j = 5) and OraServerLess81 then {I_FLOAT}
          V2 := ProcArgPropWPack[9, 4];
        if (j = 21) and OraServerLess81 then {O_FLOAT}
          V2 := ProcArgPropWPack[25, 4];
        if Compare(V1, V2) <> 0 then
          Error(WrongProcArgValueMeta(C_PARAM_PRECISION, sArgName, sMes,
                sObj, C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
                VarToStr(V2)));

        V1 := VarToValue(oView.Rows[j].GetData(C_PARAM_SCALE), 0);
        V2 := ProcArgPropWPack[j, 5];
        if Compare(V1, V2) <> 0 then
          Error(WrongProcArgValueMeta(C_PARAM_SCALE, sArgName, sMes, sObj,
                C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
                VarToStr(V2)));

        V1 := VarToValue(oView.Rows[j].GetData(C_PARAM_LENGTH), 0);
        V2 := ProcArgPropWPack[j, 6];
        if (j = 13) and OraServerLess81 then {I_UROWID}
          V2 := ProcArgPropWPack[12, 6];
        if (j = 29) and OraServerLess81 then {O_UROWID}
          V2 := ProcArgPropWPack[28, 6];
        if Compare(V1, V2) <> 0 then
          Error(WrongProcArgValueMeta(C_PARAM_LENGTH, sArgName, sMes, sObj,
                C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
                VarToStr(V2)));
      end;
    end
  end
  else if FRDBMSKind = mkDB2 then begin
    FConnIntf.CreateCommand(oCommand);
    oTab := FDatSManager.Tables.Add;
    with oCommand do begin
      Prepare('select ordinal, parmname, typename from sysibm.sysprocparms ' +
              'where procname = ''GET_SWRD_SETTINGS''');
      Define(oTab);
      Open;
      Fetch(oTab);
    end;
    sMes := 'Without package, ' + sMes;
    sObj := ProcForDefineArgs[1];
    oView.Mechanisms.Clear;
    oView.Mechanisms.AddSort(C_PARAM_POSITION);
    for j := 0 to oView.Rows.Count - 1 do begin
      V1 := VarToValue(oView.Rows[j].GetData(C_CATALOG_NAME), '');
      V2 := '';
      if AnsiCompareText(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_CATALOG_NAME, j, sMes, '',
              C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));

      V1 := oView.Rows[j].GetData(C_SCHEMA_NAME);
      V2 := 'SYSPROC';
      if AnsiCompareText(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_SCHEMA_NAME, j, sMes, '',
              C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));

      V1 := oView.Rows[j].GetData(C_PARAM_POSITION);
      V2 := oTab.Rows[j].GetData(0);
      if V1 <> V2 then
        Error(WrongValueInColumnMeta(C_PARAM_POSITION, j, sMes, '',
              C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));

      V1 := oView.Rows[j].GetData(C_PARAM_NAME);
      V2 := oTab.Rows[j].GetData(1);
      if AnsiCompareText(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_PARAM_NAME, j, sMes, '',
              C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));

      V1 := oView.Rows[j].GetData(C_PARAM_DATATYPE);
      V2 := ADProcParamTypes[j];
      if Compare(V1, V2) <> 0 then
        Error(WrongProcArgValueMeta(C_PARAM_TYPE, '#' + IntToStr(j), sMes,
              sObj, C_AD_PhysRDBMSKinds[FRDBMSKind],
              FldTypeNames[TFieldType(V1)], FldTypeNames[TFieldType(V2)]));
    end;
  end
  else if FRDBMSKind = mkMSSQL then begin
    oView.Mechanisms.Clear;
    oView.Mechanisms.AddSort(C_PARAM_NAME, '', C_PARAM_NAME);
    sObj := 'ADQA_All_Values';
    for j := 0 to oView.Rows.Count - 1 do begin
      CheckCatalogAndSchema(j, sMes);

      V1 := VarToValue(oView.Rows[j].GetData(C_PACK_NAME), '');
      V2 := '';
      if AnsiCompareText(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_PACK_NAME, j, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));

      V1 := oView.Rows[j].GetData(C_PARAM_NAME);
      V2 := ProcArgMSSQL[j];
      if AnsiCompareText(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_PARAM_NAME, j, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));
      sArgName := ProcArgMSSQL[j];
      sTypeOfArgName := AnsiUpperCase(Copy(sArgName, 4, Length(sArgName)));

      V1 := oView.Rows[j].GetData(C_PARAM_POSITION);
      V2 := ProcArgPropMSSQL[j, 0] + 1; // ??? Which position of @RETURN_VALUE param&
      if Compare(V1, V2) <> 0 then
        Error(WrongProcArgValueMeta(C_PARAM_POSITION, sArgName,
              sMes, sObj, C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
              VarToStr(V2)));

      V1 := oView.Rows[j].GetData(C_PARAM_TYPE);
      V2 := ProcArgPropMSSQL[j, 1];
      if Compare(V1, V2) <> 0 then
        Error(WrongProcArgValueMeta(C_PARAM_TYPE, sArgName,
              sMes, sObj, C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
              VarToStr(V2)));

      V1 := oView.Rows[j].GetData(C_PARAM_DATATYPE);
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
          if not((Compare(V1, Ord(dtAnsiString)) = 0) or
             (Compare(V1, Ord(dtBlob)) = 0)) then
            Error(WrongProcArgValueMeta(C_PARAM_DATATYPE, sArgName,
                  sMes, sObj, C_AD_PhysRDBMSKinds[FRDBMSKind],
                  ADDataTypesNames[TADDataType(V1)],
                  'dtAnsiString or dtBlob'));
        if sTypeOfArgName = _UNIQUEIDENTIFIER then
          if not((Compare(V1, Ord(dtAnsiString)) = 0) or
             (Compare(V1, Ord(dtBlob)) = 0) or
             (Compare(V1, Ord(dtGUID)) = 0)) then
            Error(WrongProcArgValueMeta(C_PARAM_DATATYPE, sArgName,
                  sMes, sObj, C_AD_PhysRDBMSKinds[FRDBMSKind],
                  ADDataTypesNames[TADDataType(V1)],
                  'dtAnsiString or dtBlob or dtGUID'));
        if {(sTypeOfArgName = _BIGINT) or }
           (sTypeOfArgName = _MONEY) or
           (sTypeOfArgName = _NUMERIC) then
          if not((Compare(V1, Ord(dtBCD)) = 0) or
             (Compare(V1, Ord(dtFmtBCD)) = 0)) then
            Error(WrongProcArgValueMeta(C_PARAM_DATATYPE, sArgName,
                  sMes, sObj, C_AD_PhysRDBMSKinds[FRDBMSKind],
                  ADDataTypesNames[TADDataType(V1)], 'dtBCD or dtFmtBCD'));
      end;

      V1 := oView.Rows[j].GetData(C_PARAM_TYPENAME);
      if AnsiCompareText(sArgName, '@RETURN_VALUE') <> 0 then begin
        V2 := sTypeOfArgName;
        if AnsiCompareText(V1, V2) <> 0 then
          Error(WrongProcArgValueMeta(C_PARAM_TYPENAME, sArgName,
                sMes, sObj, C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));
      end;

      V1 := oView.Rows[j].GetData(C_PARAM_ATTRIBUTES);
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

      V1 := VarToValue(oView.Rows[j].GetData(C_PARAM_PRECISION), 0);
      V2 := ProcArgPropMSSQL[j, 4];
      if Compare(V1, V2) <> 0 then
        Error(WrongProcArgValueMeta(C_PARAM_PRECISION, sArgName,
              sMes, sObj, C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
              VarToStr(V2)));

      V1 := VarToValue(oView.Rows[j].GetData(C_PARAM_SCALE), 0);
      V2 := ProcArgPropMSSQL[j, 5];
      if Compare(V1, V2) <> 0 then
        Error(WrongProcArgValueMeta(C_PARAM_SCALE, sArgName,
              sMes, sObj, C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
              VarToStr(V2)));

      V1 := VarToValue(oView.Rows[j].GetData(C_PARAM_LENGTH), 0);
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
    end;
  end
  else begin
    oView.Mechanisms.Clear;
    sObj := 'ADQA_All_Values';
    for j := 0 to oView.Rows.Count - 1 do begin
      CheckCatalogAndSchema(j, sMes);

      V1 := VarToValue(oView.Rows[j].GetData(C_PACK_NAME), '');
      V2 := '';
      if AnsiCompareText(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_PACK_NAME, j, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));

      V1 := oView.Rows[j].GetData(C_PARAM_NAME);
      V2 := ProcArgASA[j];
      if AnsiCompareText(V1, V2) <> 0 then
        Error(WrongValueInColumnMeta(C_PARAM_NAME, j, sMes, sObj,
              C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));
      sArgName := ProcArgASA[j];
      sTypeOfArgName := AnsiUpperCase(Copy(sArgName, 3, Length(sArgName)));

      V1 := oView.Rows[j].GetData(C_PARAM_POSITION);
      V2 := ProcArgPropASA[j, 0];
      if Compare(V1, V2) <> 0 then
        Error(WrongProcArgValueMeta(C_PARAM_POSITION, sArgName,
              sMes, sObj, C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
              VarToStr(V2)));

      V1 := oView.Rows[j].GetData(C_PARAM_TYPE);
      V2 := ProcArgPropASA[j, 1];
      if Compare(V1, V2) <> 0 then
        Error(WrongProcArgValueMeta(C_PARAM_TYPE, sArgName,
              sMes, sObj, C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
              VarToStr(V2)));

      V1 := oView.Rows[j].GetData(C_PARAM_DATATYPE);
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

      V1 := oView.Rows[j].GetData(C_PARAM_TYPENAME);
      V2 := sTypeOfArgName;
      if (AnsiCompareText(V1, V2) <> 0) and
         ((V2 = _LONGBINARY) and (AnsiCompareText('long binary', V1) <> 0)) and
         ((V2 = _INT) and (AnsiCompareText('integer', V1) <> 0)) and
         ((V2 = _LONGVARCHAR) and (AnsiCompareText('long varchar', V1) <> 0)) then
        Error(WrongProcArgValueMeta(C_PARAM_TYPENAME, sArgName,
              sMes, sObj, C_AD_PhysRDBMSKinds[FRDBMSKind], V1, V2));

      V1 := oView.Rows[j].GetData(C_PARAM_ATTRIBUTES);
      V2 := ProcArgPropASA[j, 3];
      if Compare(V1, V2) <> 0 then
        Error(WrongProcArgValueMeta(C_PARAM_ATTRIBUTES, sArgName,
              sMes, sObj, C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
              VarToStr(V2)));

      V1 := VarToValue(oView.Rows[j].GetData(C_PARAM_PRECISION), 0);
      V2 := ProcArgPropASA[j, 4];
      if Compare(V1, V2) <> 0 then
        Error(WrongProcArgValueMeta(C_PARAM_PRECISION, sArgName,
              sMes, sObj, C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
              VarToStr(V2)));

      V1 := VarToValue(oView.Rows[j].GetData(C_PARAM_SCALE), 0);
      V2 := ProcArgPropASA[j, 5];
      if Compare(V1, V2) <> 0 then
        Error(WrongProcArgValueMeta(C_PARAM_SCALE, sArgName,
              sMes, sObj, C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
              VarToStr(V2)));

      V1 := VarToValue(oView.Rows[j].GetData(C_PARAM_LENGTH), 0);
      V2 := ProcArgPropASA[j, 6];
      if Compare(V1, V2) <> 0 then
        Error(WrongProcArgValueMeta(C_PARAM_LENGTH, sArgName,
              sMes, sObj, C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V1),
              VarToStr(V2)));
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysMTITsHolder.TestProcArgs;
begin
  with FMetaCommIntf do begin
    ObjectScopes := [osMy];
    if FRDBMSKind in [mkMSSQL, mkASA] then
      CommandText := 'ADQA_All_Values'
    else if FRDBMSKind = mkDB2 then
      CommandText := ProcForDefineArgs[1]
    else
      CommandText  := 'ADQA_All_Vals';
    MetaInfoKind := mkProcArgs;
    if FRDBMSKind = mkDB2 then
      SchemaName := 'SYSPROC';
    try
      try
        Prepare;
        try
          Define(FTab);
          Open;
          Fetch(FTab);
        finally
          Unprepare;
        end;
      except
        on E: Exception do begin
          Error(ErrorMetaCommPrepare(E.Message));
          Exit;
        end;
      end;
      if CheckProcArgsStructure(FTab) then
        if FTab.Rows.Count <> 0 then
          CheckProcArgsData(FTab, False)
        else
          Error(RecCountIsZero('Proc. args of ' + CommandText));
    finally
      if FRDBMSKind = mkDB2 then
        SchemaName := '';
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysMTITsHolder.TestPackagedProcArgs;
begin
  with FMetaCommIntf do begin
    ObjectScopes   := [osMy];
    BaseObjectName := 'ADQA_All_types_PACK';
    CommandText    := 'Get_Valuesp';
    MetaInfoKind   := mkProcArgs;
    try
      Prepare;
      try
        Define(FTab);
        Open;
        Fetch(FTab);
      finally
        Unprepare;
      end;
    except
      on E: Exception do begin
        Error(ErrorMetaCommPrepare(E.Message));
        Exit;
      end;
    end;
    if CheckProcArgsStructure(FTab) then
      CheckProcArgsData(FTab, True);
  end;
end;

initialization

  ADQAPackManager.RegisterPack('Phys Layer', TADQAPhysMTITsHolder);

end.
