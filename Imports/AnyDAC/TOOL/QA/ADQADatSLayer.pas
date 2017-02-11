{-------------------------------------------------------------------------------}
{ AnyDAC DatS Layer tests                                                       }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit ADQADatSLayer;

interface

uses
  Classes, Windows,
  ADQAPack,
  daADStanIntf,
  daADDatSManager,
  daADGUIxIntf,
  daADPhysIntf,
  daADCompClient;

type
  TADQADatSTsHolder = class (TADQATsHolderBase)
  private
    FCurRandom: Integer;
    FVars:      array of Variant;
    procedure ClearArray;
    function GetRandom: Integer;
    procedure PrepareTestAllNumericFields;
    procedure PrepareTestDiffTypes(ABtStringOff: Boolean = False;
      ANoDatSManagerReset: Boolean = False);
    function PrepareTestWithConnection: Boolean;
  public
    procedure RegisterTests; override;
    procedure TestAutoInc;
    procedure TestCalcColFuncs;
    procedure TestCalColNumeric;
    procedure TestChildRelations;
    procedure TestConstraints1;
    procedure TestConstraints2;
    procedure TestConstraints3;
    procedure TestConstraintsUnicity;
    procedure TestDataChanges;
    procedure TestImport;
    procedure TestRange;
    procedure TestManagerReset;
    procedure TestMechMastDet;
    procedure TestRowCompare;
    procedure TestTableChangeStructure;
    procedure TestTableClear;
    procedure TestTableColumns;
    procedure TestTableCompute;
    procedure TestViewAggregate;
    procedure TestViewFilter;
    procedure TestViewSearch;
    procedure TestViewSort;
    procedure TestViewSortAndFill;
    procedure TestViewsLinkage;
  end;

implementation

uses
  DB, SysUtils,
{$IFDEF AnyDAC_D6}
  Variants, FMTBcd, SqlTimSt, DateUtils,
{$ELSE}
  ActiveX, ComObj, 
{$ENDIF}
  ADQAConst, ADQAUtils, ADQAEvalFuncs,
  daADStanError, daADStanOption, daADStanParam, daADStanConst, daADStanUtil;

{-------------------------------------------------------------------------------}
{ TADQADatSTsHolder                                                             }
{-------------------------------------------------------------------------------}
procedure TADQADatSTsHolder.RegisterTests;
begin
    RegisterTest('Changes (Accept/Reject)', TestDataChanges, mkMSAccess);
    RegisterTest('Mech. master and det',    TestMechMastDet);
    RegisterTest('Range mech',              TestRange);
    RegisterTest('ChildRelations',          TestChildRelations);
    RegisterTest('Reset',                   TestManagerReset);
    RegisterTest('Views;Sorting',           TestViewSort);
    RegisterTest('Views;Sort and add',      TestViewSortAndFill);
    RegisterTest('Views;Filtering',         TestViewFilter, mkMSAccess);
    RegisterTest('Views;Searching',         TestViewSearch);
    RegisterTest('Views;Aggregates',        TestViewAggregate);
    RegisterTest('Views;Linkage',           TestViewsLinkage);
    RegisterTest('Comparing',               TestRowCompare, mkMSAccess);
    RegisterTest('Compute',                 TestTableCompute);
    RegisterTest('Change table structure',  TestTableChangeStructure);
    RegisterTest('Read columns',            TestTableColumns);
    RegisterTest('Autoinc fields',          TestAutoInc);
    RegisterTest('Import',                  TestImport, mkMSAccess);
    RegisterTest('Clear and reset',         TestTableClear);
    RegisterTest('Constraints;1',           TestConstraints1);
    RegisterTest('Constraints;2',           TestConstraints2);
    RegisterTest('Constraints;3',           TestConstraints3);
    RegisterTest('Unique constraints',      TestConstraintsUnicity);
    RegisterTest('Calculated columns;Numeric & Arifmetic', TestCalColNumeric);
    RegisterTest('Calculated columns;Functions',           TestCalcColFuncs);
end;

{-------------------------------------------------------------------------------}
procedure TADQADatSTsHolder.TestAutoInc;
var
  i, j: Integer;

  procedure PrepareTest;
  var
    i, j: Integer;

    procedure SetAutoInc(ACol: TADDatSColumn);
    begin
      with ACol do begin
        AutoIncrement := True;
        AutoIncrementSeed := 1;
        AutoIncrementStep := 1;
      end;
    end;

  begin
    FDatSManager.Reset;
    FTab := FDatSManager.Tables.Add;
    SetAutoInc(FTab.Columns.Add(C_tInt16, dtInt16));

    FTab := FDatSManager.Tables.Add;
    SetAutoInc(FTab.Columns.Add(C_tInt32, dtInt32));

    FTab := FDatSManager.Tables.Add;
    SetAutoInc(FTab.Columns.Add(C_tInt64, dtInt64));

    FTab := FDatSManager.Tables.Add;
    SetAutoInc(FTab.Columns.Add(C_tByte, dtByte));

    FTab := FDatSManager.Tables.Add;
    SetAutoInc(FTab.Columns.Add(C_tUInt16, dtUInt16));

    FTab := FDatSManager.Tables.Add;
    SetAutoInc(FTab.Columns.Add(C_tUInt32, dtUInt32));

    FTab := FDatSManager.Tables.Add;
    SetAutoInc(FTab.Columns.Add(C_tUInt64, dtUInt64));

    FTab := FDatSManager.Tables.Add;
    SetAutoInc(FTab.Columns.Add(C_tSByte, dtSByte));

    for i := 0 to 101 - 1 do
      for j := 0 to FDatSManager.Tables.Count - 1 do
        with FDatSManager.Tables[j].Rows.Add([Unassigned]) do
          if RowState <> rsInserted then begin
            Error(WrongRowState(RowsStates[RowState], RowsStates[rsInserted],
                  'TabName is ' + FDatSManager.Tables[j].Name));
            break;
          end;
  end;

begin
  PrepareTest;
  for i := 1 to 101 do
    for j := 0 to FDatSManager.Tables.Count - 1 do
      if Abs(FDatSManager.Tables[j].Rows[i - 1].GetData(0)) <> i then
        Error(AutoIncFails);
end;

{-------------------------------------------------------------------------------}
procedure TADQADatSTsHolder.TestCalcColFuncs;
var
  oTestEvalFuncs: TADQAEvalFuncs;
  oCol:           TADDatSColumn;
  i:              Integer;
  V1, V2:         Variant;

  procedure PrepareTest;
  begin
    FDatSManager.Reset;
    FTab := FDatSManager.Tables.Add('Table');
    FTab.Columns.Add(C_tInt32,         dtInt32);
    FTab.Columns.Add(C_tDouble,        dtDouble);
    FTab.Columns.Add(C_tAnsiString,    dtAnsiString);
    FTab.Columns.Add(C_tDateTime,      dtDateTime);
    FTab.Columns.Add(C_tTime,          dtTime);
    FTab.Columns.Add(C_tDate,          dtDate);
    FTab.Columns.Add(C_tSByte,         dtSByte);
    FTab.Columns.Add(C_tWideString,    dtWideString);
    FTab.Columns.Add(C_tDateTimeStamp, dtDateTimeStamp);

    oTestEvalFuncs := TADQAEvalFuncs.Create;
    oTestEvalFuncs.Init;
  end;

begin
  PrepareTest;
  oCol := nil;
  try
    for i := 0 to oTestEvalFuncs.Count - 1 do begin
      try
        case oTestEvalFuncs.ResType[i] of
        dtInt32:         oCol := FTab.Columns[0];
        dtDouble:        oCol := FTab.Columns[1];
        dtAnsiString:    oCol := FTab.Columns[2];
        dtDateTime:      oCol := FTab.Columns[3];
        dtTime:          oCol := FTab.Columns[4];
        dtDate:          oCol := FTab.Columns[5];
        dtSByte:         oCol := FTab.Columns[6];
        dtWideString:    oCol := FTab.Columns[7];
        dtDateTimeStamp: oCol := FTab.Columns[8];
        else             Exit;
        end;
        oCol.Expression := oTestEvalFuncs.EscFunc[i];
        FTab.Rows.Add([]);
        V1 := FTab.Rows[0].GetData(oCol);
        V2 := oTestEvalFuncs.TrueRes[i];
        if Compare(V1, V2) <> 0 then
          if oCol.DataType = dtDouble then begin
            if Abs(V1 - V2) > C_DELTA then
              Error(EscapeFuncFails(oTestEvalFuncs.EscFunc[i], V1, V2));
          end
          else
            Error(EscapeFuncFails(oTestEvalFuncs.EscFunc[i], V1, V2));
        FTab.Clear;
        oCol.Expression := '';
      except
        on E: Exception do
          Error(oTestEvalFuncs.EscFunc[i] + ' ' + E.Message);
      end
    end
  finally
    oTestEvalFuncs.Free;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQADatSTsHolder.TestCalColNumeric;
var
  i, j, k: Integer;
  sExpr, sT1,
  sT2:     String;
  aSign:   array[0..3] of Char;
  POper:   TOp;
  V1, V2,
  vRes:    Variant;
  oRow:    TADDatSRow;

  function GetSign(ANum: Integer): Char;
  begin
    Result := aSign[ANum mod 4];
  end;

begin
  PrepareTestAllNumericFields;
  aSign[0] := '+';
  aSign[1] := '-';
  aSign[2] := '*';
  aSign[3] := '/';
  FTab.Clear;
  FTab.Columns.Add('total', dtCurrency);
  for i := 0 to FTab.Columns.Count - 2 do
    for j := 0 to FTab.Columns.Count - 2 do begin
      if j = i then continue;
      for k := 0 to 3 do begin
        FTab.Clear;
        case k of
        0:   POper := SumOp;
        1:   POper := DeducOp;
        2:   POper := MulOp;
        3:   POper := DivOp;
        else POper := nil;
        end;
        sExpr := FTab.Columns[i].Name + GetSign(k) + FTab.Columns[j].Name;

        sT1 := ADDataTypesNames[FTab.Columns[i].DataType];
        case FTab.Columns[i].DataType of
        dtSByte:    V1 := -20;
        dtInt16:    V1 := 234;
        dtInt32:    V1 := 1230;
        dtInt64:    V1 := -11290;
        dtByte:     V1 := 22;
        dtUInt16:   V1 := 36;
        dtUInt32:   V1 := 27467;
        dtUInt64:   V1 := 124;
        dtDouble:   V1 := 33.99;
        dtCurrency: V1 := -2857.49;
{$IFDEF AnyDAC_D6}
        dtBCD:      V1 := VarFMTBcdCreate(StrToBcd_Cast('5872.4547'));
        dtFmtBCD:   V1 := VarFMTBcdCreate(StrToBcd_Cast('34857.555'));
{$ELSE}
        dtBCD:      V1 := 5872.4547;
        dtFmtBCD:   V1 := 34857.555;
{$ENDIF}
        end;

        sT2 := ADDataTypesNames[FTab.Columns[j].DataType];
        case FTab.Columns[j].DataType of
        dtSByte:    V2 := -1;
        dtInt16:    V2 := -22;
        dtInt32:    V2 := 14919;
        dtInt64:    V2 := 216;
        dtByte:     V2 := 100;
        dtUInt16:   V2 := 34;
        dtUInt32:   V2 := 333;
        dtUInt64:   V2 := 44444;
        dtDouble:   V2 := 2242.2;
        dtCurrency: V2 := 35.23;
{$IFDEF AnyDAC_D6}
        dtBCD:      V2 := VarFMTBcdCreate(StrToBcd_Cast('-872.45473422'));
        dtFmtBCD:   V2 := VarFMTBcdCreate(StrToBcd_Cast('-57.134'));
{$ELSE}
        dtBCD:      V2 := -872.45473422;
        dtFmtBCD:   V2 := -57.134;
{$ENDIF}
        end;

        FTab.Columns.ColumnByName('total').Expression := sExpr;
        oRow := FTab.NewRow(True);
        FTab.Rows.Add(oRow);
        with oRow do begin
          BeginEdit;
          SetData(i, V1);
          SetData(j, V2);
          EndEdit;
        end;
        vRes := Abs(POper(V1, V2) - oRow.GetData('total'));
        if vRes > 0.1 then
          Error(WrongValueInCalcCol(VarToStr(Abs(oRow.GetData('total'))),
                VarToStr(Abs(POper(V1, V2))), sT1, sT2));
      end;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADQADatSTsHolder.TestChildRelations;
var
  oRel:      TADDatSRelation;
  oDatSView: TADDatSView;
  i, j, k:   Integer;

  procedure PrepareTest;
  var
    i, j, k: Integer;
    oTempTab: TADDatSTable;
  begin
    PrepareTestDiffTypes(True);
    for i := 0 to FTab.Columns.Count - 1 do begin
      oTempTab := FDatSManager.Tables.Add('Table' + IntToStr(i));
      oTempTab.Columns.Add('foreign' + FTab.Columns[i].Name, FTab.Columns[i].DataType);
    end;

    for i := 0 to FTab.Rows.Count - 1 do
      for j := 0 to FTab.Columns.Count - 1 do
        for k := 0 to 5 do
          with FDatSManager do
            Tables[j + 1].Rows.Add([FTab.Rows[i].GetData(j)]);

    for j := 0 to FTab.Columns.Count - 1 do
      with FDatSManager do
        Relations.Add(FTab.Columns[j], Tables[j + 1].Columns[0]);
  end;

begin
  PrepareTest;
  // checking child relations
  for i := 0 to FTab.Rows.Count - 1 do
    for j := 0 to FTab.Columns.Count - 1 do begin
      try
        oRel := FDatSManager.Relations[j];
        oDatSView := FTab.Rows[i].GetChildRows(oRel);
        for k := 0 to oDatSView.Rows.Count - 1 do
          if Compare(oDatSView.Rows[k].GetData(0), FTab.Rows[i].GetData(j)) <> 0 then
            Error(RelationsFails(FTab.Columns[j].Name));
      except
        on E: Exception do
          Error(ErrorGettingChildView(FTab.Columns[j].Name, E.Message));
      end
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADQADatSTsHolder.TestConstraints1;
var
  oTabFirst, oTabSec, oTabThird: TADDatSTable;
  oFirstPK,  oSecPK,  oThirdPK:  TADDatSUniqueConstraint;
  oSecFK,    oThirdFK1:          TADDatSForeignKeyConstraint;
  i: Integer;

  procedure FillTables;
  var
    i: Integer;
  begin
    oTabFirst.EnforceConstraints := False;
    oTabSec.EnforceConstraints   := False;
    oTabThird.EnforceConstraints := False;
    try
      with oTabFirst.Rows do
        for i := 1 to 3 do
          Add([i]);
      with oTabSec.Rows do
        for i := 1 to 9 do
          Add([i, ((i - 1) div 3) + 1]);
      with oTabThird.Rows do
        for i := 1 to 27 do
          Add([i, (i - 1) div 3 + 1]);
    finally
      oTabFirst.EnforceConstraints := True;
      oTabSec.EnforceConstraints   := True;
      oTabThird.EnforceConstraints := True;
    end;
  end;

  procedure ClearTables;
  begin
    oTabFirst.Clear;
    oTabSec.Clear;
    oTabThird.Clear;
  end;

  function ChangePK: Boolean;
  var
    i: Integer;
    V: Variant;
  begin
    Result := False;
    try
      with oTabFirst do
        for i := 1 to 3 do begin
          Rows[i - 1].BeginEdit;
          Rows[i - 1].SetData(0, i * 1000);
          V := Rows[i - 1].GetData(0, rvPrevious);
          Rows[i - 1].EndEdit;
        end;
    except
      on E: EADException do
        Result := True;
    end;
  end;

  function DeletePK: Boolean;
  begin
    Result := False;
    with oTabFirst do
      try
        while Rows.Count <> 0 do
          Rows[0].Delete;
      except
        on E: EADException do
          Result := True;
      end;
  end;

  procedure PrepareTest;
  begin
    FDatSManager.Reset;
    // create data table
    oTabFirst := FDatSManager.Tables.Add('First');
    oTabFirst.Columns.Add('ID', dtInt32);
    oFirstPK := oTabFirst.Constraints.AddUK('FIR_PK', 'ID', True);
    // create data table
    oTabSec := FDatSManager.Tables.Add('Second');
    oTabSec.Columns.Add('ID', dtInt32);
    oTabSec.Columns.Add('FK', dtInt32);
    oSecPK := oTabSec.Constraints.AddUK('SEC_PK', 'ID', True);
    oSecFK := oTabSec.Constraints.AddFK('SEC_FK', 'First', 'ID', 'FK');
    // create data table
    oTabThird := FDatSManager.Tables.Add('Third');
    oTabThird.Columns.Add('ID', dtInt32);
    oTabThird.Columns.Add('FK', dtInt32);
    oThirdPK  := oTabThird.Constraints.AddUK('THD_PK', 'ID', True);
    oThirdFK1 := oTabThird.Constraints.AddFK('THD_FK', 'Second', 'ID', 'FK');
  end;

begin
  PrepareTest;
  FillTables;
  oSecFK.UpdateRule := crCascade;
  ChangePK;
  with oTabSec do
    for i := 1 to 9 do
      if Integer(Rows[i - 1].GetData(1)) <> (((i - 1) div 3) + 1) * 1000 then
        Error(FailedDataChange('cascade'));

  oSecFK.DeleteRule    := crCascade;
  oThirdFK1.DeleteRule := crCascade;
  DeletePK;
  if oTabSec.Rows.Count <> 0 then
    Error(FailedDataDelete('cascade', 'Tab2'));
  if oTabThird.Rows.Count <> 0 then
    Error(FailedDataDelete('cascade', 'Tab3'));
  ClearTables;

  FillTables;
  oSecFK.UpdateRule := crRestrict;
  if not ChangePK then
    Error(FailedRestrOnParentData('change'));

  oSecFK.DeleteRule    := crRestrict;
  oThirdFK1.DeleteRule := crRestrict;
  if not DeletePK then
    Error(FailedRestrOnParentData('delete'));
  ClearTables;

  FillTables;
  oSecFK.UpdateRule := crNullify;
  ChangePK;
  with oTabSec do
    for i := 1 to 9 do
      if not VarIsNull(Rows[i - 1].GetData(1)) then
        Error(FailedNullifData('change', ''));

  oSecFK.DeleteRule := crNullify;
  DeletePK;
  with oTabSec do
    if Rows.Count = 0 then
      Error(FailedNullifData('delete', 'Count in child table = 0...'))
    else
      for i := 0 to 8 do
        if not VarIsNull(Rows[i].GetData(1)) then
          Error(FailedNullifData('delete', ''));
  ClearTables;
end;

{-------------------------------------------------------------------------------}
procedure TADQADatSTsHolder.TestConstraints2;
var
  oTabFirst, oTabSec, oTabThird: TADDatSTable;
  oFirstPK,  oSecPK,  oThirdPK:  TADDatSUniqueConstraint;
  oFirstFK,  oSecFK,  oThirdFK1: TADDatSForeignKeyConstraint;
  i: Integer;

  procedure FillTables;
  var
    i: Integer;
  begin
    oTabFirst.EnforceConstraints := False;
    oTabSec.EnforceConstraints   := False;
    oTabThird.EnforceConstraints := False;
    try
      with oTabFirst.Rows do begin
        Add([1, 3]);
        Add([2, 1]);
        Add([3, 2]);
      end;
      with oTabSec.Rows do
        for i := 1 to 9 do
          Add([i, ((i - 1) div 3) + 1]);
      with oTabThird.Rows do
        for i := 1 to 3 do
          Add([i, (i - 1) * 3 + 1]);
    finally
      oTabFirst.EnforceConstraints := True;
      oTabSec.EnforceConstraints   := True;
      oTabThird.EnforceConstraints := True;
    end;
  end;

  procedure ClearTables;
  begin
    oTabFirst.Clear;
    oTabSec.Clear;
    oTabThird.Clear;
  end;

  function ChangePK: Boolean;
  var
    i: Integer;
    V: Variant;
  begin
    Result := False;
    try
      with oTabFirst do
        for i := 1 to 3 do begin
          Rows[i - 1].BeginEdit;
          Rows[i - 1].SetData(0, i * 1000);
          V := Rows[i - 1].GetData(0, rvPrevious);
          Rows[i - 1].EndEdit;
        end;
    except
      on E: EADException do
        Result := True;
    end;
  end;

  function DeletePK: Boolean;
  begin
    Result := False;
    with oTabFirst do
      try
        while Rows.Count <> 0 do
          Rows[0].Delete;
      except
        on E: EADException do
          Result := True;
      end;
  end;

  procedure PrepareTest;
  begin
    FDatSManager.Reset;
    // create data table
    oTabFirst := FDatSManager.Tables.Add('First');
    oTabFirst.Columns.Add('ID', dtInt32);
    oTabFirst.Columns.Add('FK', dtInt32);
    oFirstPK := oTabFirst.Constraints.AddUK('FIR_PK', 'ID', True);
    // create data table
    oTabSec := FDatSManager.Tables.Add('Second');
    oTabSec.Columns.Add('ID', dtInt32);
    oTabSec.Columns.Add('FK', dtInt32);
    oSecPK := oTabSec.Constraints.AddUK('SEC_PK', 'ID', True);
    oSecFK := oTabSec.Constraints.AddFK('SEC_FK', 'First', 'ID', 'FK');
    // create data table
    oTabThird := FDatSManager.Tables.Add('Third');
    oTabThird.Columns.Add('ID', dtInt32);
    oTabThird.Columns.Add('FK', dtInt32);
    oThirdPK  := oTabThird.Constraints.AddUK('THD_PK', 'ID', True);
    oThirdFK1 := oTabThird.Constraints.AddFK('THD_FK', 'Second', 'ID', 'FK');
    oFirstFK  := oTabFirst.Constraints.AddFK('FIR_FK', 'Third', 'ID', 'FK');
  end;

begin
  PrepareTest;
  FillTables;
  oSecFK.UpdateRule := crCascade;
  ChangePK;
  with oTabSec do
    for i := 1 to 9 do
      if Integer(Rows[i - 1].GetData(1)) <> (((i - 1) div 3) + 1) * 1000 then
        Error(FailedDataChange('cascade'));

  oSecFK.DeleteRule    := crCascade;
  oThirdFK1.DeleteRule := crCascade;
  oFirstFK.DeleteRule  := crCascade;
  if DeletePK then
   // Error(FaildExcpWhereChildDel);
  ClearTables;

  FillTables;
  oSecFK.UpdateRule := crRestrict;
  if not ChangePK then
    Error(FailedRestrOnParentData('change'));

  oSecFK.DeleteRule    := crRestrict;
  oThirdFK1.DeleteRule := crRestrict;
  oFirstFK.DeleteRule  := crRestrict;
  if not DeletePK then
    Error(FailedRestrOnParentData('delete'));
  ClearTables;

  FillTables;
  oSecFK.UpdateRule := crNullify;
  ChangePK;
  with oTabSec do
    for i := 1 to 9 do
      if not VarIsNull(Rows[i - 1].GetData(1)) then
        Error(FailedNullifData('change', ''));

  oSecFK.DeleteRule := crNullify;
  DeletePK;
  with oTabSec do
    if Rows.Count = 0 then
      Error(FailedNullifData('delete', 'Count in child table = 0...'))
    else
      for i := 0 to 8 do
        if not VarIsNull(Rows[i].GetData(1)) then
          Error(FailedNullifData('delete', ''));
  ClearTables;
end;

{-------------------------------------------------------------------------------}
procedure TADQADatSTsHolder.TestConstraints3;
var
  oTabFirst, oTabSec,   oTabThird: TADDatSTable;
  oFirstPK,  oSecPK,    oThirdPK:  TADDatSUniqueConstraint;
  oSecFK,    oThirdFK1, oThirdFK2: TADDatSForeignKeyConstraint;
  i: Integer;

  procedure ClearTables;
  begin
    oTabFirst.Clear;
    oTabSec.Clear;
    oTabThird.Clear;
  end;

  procedure PrepareTest;
  begin
    FDatSManager.Reset;
    // create data table
    oTabFirst := FDatSManager.Tables.Add('First');
    oTabFirst.Columns.Add('ID', dtInt32);
    oFirstPK := oTabFirst.Constraints.AddUK('FIR_PK', 'ID', True);
    // create data table
    oTabSec := FDatSManager.Tables.Add('Second');
    oTabSec.Columns.Add('ID', dtInt32);
    oTabSec.Columns.Add('FK', dtInt32);
    oSecPK := oTabSec.Constraints.AddUK('SEC_PK', 'ID', True);
    oSecFK := oTabSec.Constraints.AddFK('SEC_FK', 'First', 'ID', 'FK');
    // create data table
    oTabThird := FDatSManager.Tables.Add('Third');
    oTabThird.Columns.Add('ID', dtInt32);
    oTabThird.Columns.Add('FK1', dtInt32);
    oTabThird.Columns.Add('FK2', dtInt32);
    oThirdPK  := oTabThird.Constraints.AddUK('THD_PK', 'ID', True);
    oThirdFK1 := oTabThird.Constraints.AddFK('THD_FK1', 'First', 'ID', 'FK1');
    oThirdFK2 := oTabThird.Constraints.AddFK('THD_FK2', 'Second', 'ID', 'FK2');
  end;

  procedure FillTables;
  var
    i: Integer;
  begin
    oTabFirst.EnforceConstraints := False;
    oTabSec.EnforceConstraints   := False;
    oTabThird.EnforceConstraints := False;
    try
      with oTabFirst.Rows do
        for i := 1 to 3 do
          Add([i]);
      with oTabSec.Rows do
        for i := 1 to 9 do
          Add([i, ((i - 1) div 3) + 1]);
      with oTabThird.Rows do
        for i := 1 to 27 do
          Add([i, (i - 1) mod 3 + 1, (i - 1) div 3 + 1]);
    finally
      oTabFirst.EnforceConstraints := True;
      oTabSec.EnforceConstraints   := True;
      oTabThird.EnforceConstraints := True;
    end;
  end;

  function ChangePK: Boolean;
  var
    i: Integer;
    V: Variant;
  begin
    Result := False;
    try
      with oTabFirst do
        for i := 1 to 3 do begin
          Rows[i - 1].BeginEdit;
          Rows[i - 1].SetData(0, i * 1000);
          V := Rows[i - 1].GetData(0, rvPrevious);
          Rows[i - 1].EndEdit;
        end;
    except
      on E: EADException do
        Result := True;
    end;
  end;

  function DeletePK: Boolean;
  begin
    Result := False;
    with oTabFirst do
      try
        while Rows.Count <> 0 do
          Rows[0].Delete;
      except
        on E: EADException do
          Result := True;
      end;
  end;

begin
  PrepareTest;
  FillTables;
  oSecFK.UpdateRule    := crCascade;
  oThirdFK1.UpdateRule := crCascade;
  oThirdFK2.UpdateRule := crCascade;
  ChangePK;
  with oTabSec do
    for i := 1 to 9 do
      if Integer(Rows[i - 1].GetData(1)) <> ((i - 1) div 3 + 1) * 1000 then begin
        Error(FailedDataChange('cascade'));
        break;
      end;

  with oTabThird do
    for i := 1 to 3 do
      if Integer(Rows[i - 1].GetData(1)) <> ((i - 1) mod 3 + 1) * 1000 then begin
        Error(FailedDataChange('cascade'));
        break;
      end;

  oSecFK.DeleteRule    := crCascade;
  oThirdFK1.DeleteRule := crCascade;
  oThirdFK2.DeleteRule := crCascade;
  if DeletePK then
    Error(FaildExcpWhereChildDel);
  ClearTables;

  FillTables;
  oSecFK.UpdateRule    := crRestrict;
  oThirdFK1.UpdateRule := crRestrict;
  oThirdFK2.UpdateRule := crRestrict;
  if not ChangePK then
    Error(FailedRestrOnParentData('change'));

  oSecFK.DeleteRule    := crRestrict;
  oThirdFK1.DeleteRule := crRestrict;
  oThirdFK2.DeleteRule := crRestrict;
  if not DeletePK then
    Error(FailedRestrOnParentData('delete'));
  ClearTables;

  FillTables;
  oSecFK.UpdateRule    := crNullify;
  oThirdFK1.UpdateRule := crNullify;
  oThirdFK2.UpdateRule := crNullify;
  ChangePK;
  with oTabSec do
    for i := 1 to 9 do
      if not VarIsNull(Rows[i - 1].GetData(1)) then begin
        Error(FailedNullifData('change', 'TabSec'));
        break;
      end;

  with oTabThird do
    for i := 1 to 3 do
      if not VarIsNull(Rows[i - 1].GetData(1)) then begin
        Error(FailedNullifData('change', 'TabThird'));
        break;
      end;

  oSecFK.DeleteRule    := crNullify;
  oThirdFK1.DeleteRule := crNullify;
  oThirdFK2.DeleteRule := crNullify;
  DeletePK;
  with oTabSec do
    if Rows.Count = 0 then
      Error(FailedNullifData('delete', 'Count in child table = 0.. TabSec'))
    else
      for i := 0 to 8 do
        if not VarIsNull(Rows[i].GetData(1)) then begin
          Error(FailedNullifData('delete', 'TabSec'));
          break;
        end;

  with oTabThird do
    if Rows.Count = 0 then
      Error(FailedNullifData('delete', 'Count in child table = 0.. TabThird'))
    else
      for i := 0 to 3 do
        if not VarIsNull(Rows[i].GetData(1)) then begin
          Error(FailedNullifData('delete', 'TabThird'));
          break;
        end;
end;

{-------------------------------------------------------------------------------}
procedure TADQADatSTsHolder.TestConstraintsUnicity;
var
  oRow:  TADDatSRow;
  aCols: array of TADDatSColumn;
  lRes:  Boolean;
  i:     Integer;
begin
  PrepareTestDiffTypes;
  FTab.Constraints.AddUK('PK', FTab.Columns[0], True);
  // 1.
  oRow := FTab.NewRow(True);
  try
    oRow.SetData(0, FTab.Rows[0].GetData(0));
    try
      lRes := False;
      FTab.Rows.Add(oRow);
    except
      on E: EADException do
        lRes := True;
    end;
    if not lRes then
      Error(DuplUnIndexError);
  finally
    oRow.Free;
  end;

  // 2.
  oRow := FTab.NewRow(True);
  try
    oRow.SetData(0, FTab.Rows[0].GetData(0) + 1);
    try
      lRes := True;
      FTab.Rows.Add(oRow);
    except
      on E: EADException do
        lRes := False;
    end;
    if not lRes then
      Error(UnIndexError);
  finally
    oRow.Free;
  end;

  // 3.
  FTab.Constraints.RemoveByName('PK');
  oRow := FTab.NewRow(True);
  try
    oRow.SetData(0, FTab.Rows[0].GetData(0));
    try
      lRes := True;
      FTab.Rows.Add(oRow);
    except
      on E: EADException do
        lRes := False;
    end;
    if not lRes then
      Error(UnIndexError);
  finally
    oRow.Free;
  end;

  // 4.
  SetLength(aCols, FTab.Columns.Count);
  for i := 0 to FTab.Columns.Count - 1 do
    aCols[i] := FTab.Columns[i];
  FTab.Constraints.AddUK('PK', aCols, True);
  oRow := FTab.NewRow(True);
  for i := 0 to FTab.Columns.Count - 1 do
    oRow.SetData(i, FTab.Rows[0].GetData(i));
  try
    lRes := False;
    FTab.Rows.Add(oRow);
  except
    on E: EADException do begin
      oRow.Free;
      lRes := True;
    end;
  end;
  if not lRes then
    Error(DuplUnIndexError);
end;

procedure TADQADatSTsHolder.TestDataChanges;
var
  oRow1, oRow2,
  oCopyRow1, oCopyRow2: TADDatSRow;
  oTab2, oCopyFTab,
  oCopyTab2:            TADDatSTable;

  procedure Accept;
  begin
    FTab.AcceptChanges;
  end;

  procedure AcceptDatSManager;
  begin
    FDatSManager.AcceptChanges;
  end;

  procedure Reject;
  begin
    FTab.RejectChanges;
  end;

  procedure RejectDatSManager;
  begin
    FDatSManager.RejectChanges;
  end;

  procedure Change(ATab: TADDatSTable);
  begin
    with ATab.Rows[0] do begin
      BeginEdit;
      SetValues([Unassigned, 'String' + VarToStr(GetRandom), Unassigned]);
      EndEdit;
    end;
  end;

begin
  // table accept/reject changes
  if not PrepareTestWithConnection then begin
    Error(CannotContinueTest);
    Exit;
  end;
  oCopyFTab := FTab.Copy;
  oRow1     := FTab.Rows[0];
  oCopyRow1 := oCopyFTab.Rows[0];
  // test accept
  try
    Change(FTab);
    Accept;
    if oRow1.RowState <> rsUnchanged then
      Error(AcceptingFails('DatSTable', ''));
    if oRow1.CompareRows(oCopyRow1, rvDefault, []) = 0 then
      Error(AcceptingFails('DatSTable', ''));
  finally
    oCopyFTab.Free;
  end;

  // test reject
  Change(FTab);
  oCopyFTab := FTab.Copy;
  oCopyRow1 := oCopyFTab.Rows[0];
  try
    Reject;
    if oRow1.RowState <> rsUnchanged then
      Error(RejectingFails('DatSTable', ''));
    if oRow1.CompareRows(oCopyRow1, rvCurrent, []) = 0 then
      Error(RejectingFails('DatSTable', ''));
  finally
    oCopyFTab.Free;
  end;

  //DatS Manager accept/reject changes
  if not PrepareTestWithConnection then begin
    Error(CannotContinueTest);
    Exit;
  end;
  oRow1 := FTab.Rows[0];
  // a copy of the first table
  oCopyFTab := FTab.Copy;
  oCopyRow1 := oCopyFTab.Rows[0];
  // second table - also a copy of global table FTab
  oTab2 := FTab.Copy;
  oTab2.Name := 't2';
  FDatSManager.Tables.Add(oTab2);
  oRow2 := oTab2.Rows[0];

  // test accept
  try
    Change(FTab);
    Change(oTab2);
    AcceptDatSManager;

    // checking errors
    if FTab.HasChanges([rsDetached, rsInserted, rsDeleted, rsModified, rsUnchanged,
                        rsEditing, rsCalculating, rsChecking, rsDestroying,
                        rsImportingCurent, rsImportingOriginal,
                        rsImportingProposed]) then
      Error(AcceptingFails('DatSManger', 'FTab has changes'));

    if oTab2.HasChanges([rsDetached, rsInserted, rsDeleted, rsModified, rsUnchanged,
                         rsEditing, rsCalculating, rsChecking, rsDestroying,
                         rsImportingCurent, rsImportingOriginal,
                         rsImportingProposed]) then
      Error(AcceptingFails('DatSManger', 'oTab2 has changes'));

    if (oRow1.RowState <> rsUnchanged) and (oRow2.RowState <> rsUnchanged) then
      Error(AcceptingFails('DatSManger', 'Rows hasn''t rsUnchanged state'));

    if oRow1.CompareRows(oCopyRow1, rvDefault, []) = 0 then
      Error(AcceptingFails('DatSManger', 'Row1 equals copyrow1'));

    if oRow2.CompareRows(oCopyRow1, rvDefault, []) = 0 then
      Error(AcceptingFails('DatSManger', 'Row2 equals copyrow1'));
  finally
    oCopyFTab.Free;
  end;

  // test reject
  Change(FTab);
  Change(oTab2);
  // a copy of the first table
  oCopyFTab := FTab.Copy;
  oCopyRow1 := oCopyFTab.Rows[0];
  // a copy of the second table
  oCopyTab2 := oTab2.Copy;
  oCopyRow2 := oCopyTab2.Rows[0];
  try
    RejectDatSManager;
    // checking errors
    if FTab.HasChanges([rsDetached, rsInserted, rsDeleted, rsModified, rsUnchanged,
                        rsEditing, rsCalculating, rsChecking, rsDestroying,
                        rsImportingCurent, rsImportingOriginal,
                        rsImportingProposed]) then
      Error(RejectingFails('DatSManger', 'FTab has changes'));

    if oTab2.HasChanges([rsDetached, rsInserted, rsDeleted, rsModified, rsUnchanged,
                         rsEditing, rsCalculating, rsChecking, rsDestroying,
                         rsImportingCurent,
                         rsImportingOriginal, rsImportingProposed]) then
      Error(RejectingFails('DatSManger', 'oTab2 has changes'));

    if (oRow1.RowState <> rsUnchanged) and (oRow2.RowState <> rsUnchanged) then
      Error(RejectingFails('DatSManger', 'Rows hasn''t rsUnchanged state'));

    if oRow1.CompareRows(oCopyRow1, rvCurrent, []) = 0 then
      Error(RejectingFails('DatSManger', 'Row1 equals copyrow1'));

    if oRow2.CompareRows(oCopyRow2, rvCurrent, []) = 0 then
      Error(RejectingFails('DatSManger', 'Row2 equals copyrow2'));
  finally
    oCopyFTab.Free;
    oCopyTab2.Free;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQADatSTsHolder.TestImport;
var
  oView:       TADDatSView;
  oImpTab:     TADDatSTable;
  oRow,
  oCopyRow:    TADDatSRow;
  oCol:        TADDatSColumn;
  i, j:        Integer;
  lWasExc:     Boolean;
  eSrc, eDest: TADDataType;
  vSrcVal, V1, V2:
               Variant;
  sVal:        String;

  procedure CheckStates(ARow1, ARow2: TADDatSRow);
  begin
    if ARow1.RowState <> ARow2.RowState then
      Error(WrongRowState(RowsStates[ARow2.RowState],
        RowsStates[ARow1.RowState]));
    if ARow1.RowPriorState <> ARow2.RowPriorState then
      Error(WrongRowState(RowsStates[ARow2.RowPriorState],
        RowsStates[ARow1.RowPriorState]));
  end;

  procedure CheckImportRow(ARow1, ARow2: TADDatSRow);
  begin
    try
      FTab.Import(ARow1, ARow2);
    except
      on E: Exception do begin
        Error(E.Message);
        Exit;
      end;
    end;
    if ARow1.CompareRows(ARow2, rvDefault, []) <> 0 then
      Error(ErrorOnImport(-1));
    CheckStates(ARow1, ARow2);
  end;

  procedure CheckFieldVal(ARow, AImpRow: TADDatSRow);
  var
    i:         Integer;
    oColList1,
    oColList2: TADDatSColumnList;
    oCol:      TADDatSColumn;
  begin
    try
      oImpTab.Import(ARow, AImpRow);
    except
      on E: Exception do begin
        Error(E.Message);
        Exit;
      end;
    end;
    oColList1 := FTab.Columns;
    oColList2 := oImpTab.Columns;

    V1 := AImpRow.GetData('New_Imp');
    V2 := 'imp';
    if Compare(V1, V2) <> 0 then
      Error(WrongValueInTable('New_Imp', 0, VarToStr(V2), VarToStr(V1)));

    oCol := nil;
    for i := 0 to oColList1.Count - 1 do begin
      try
        oCol := oColList2.ColumnByName(oColList1[i].Name);
      except
        on E: EADException do
          continue;
      end;
      V1 := ARow.GetData(i);
      V2 := AImpRow.GetData(oCol);
      if Compare(V1, V2) <> 0 then
        Error(WrongValueInTable(oCol.Name, 0, VarToStr(V2), VarToStr(V1)));
    end;
    CheckStates(ARow, AImpRow);
  end;

  function GetVarArray(ApData: Pointer; ALen: Integer): Variant;
  var
    p: Pointer;
  begin
    Result := VarArrayCreate([0, ALen - 1], varByte);
    p := VarArrayLock(Result);
    try
      Move(ApData^, p^, ALen);
    finally
      VarArrayUnlock(Result);
    end;
  end;

begin
  // 1. The structures of dest and src tables are identical
  PrepareTestDiffTypes;
  oView := FTab.DefaultView;
  PrepareTestDiffTypes(False, True);
  oImpTab := FTab;
  FTab    := FDatSManager.Tables[0];
  oImpTab.Import(oView);
  if FTab.Rows.Count <> oImpTab.Rows.Count then begin
    Error(WrongRowCount(FTab.Rows.Count, oImpTab.Rows.Count));
    Exit;
  end;
  for i := 0 to FTab.Rows.Count - 1 do begin
    if FTab.Rows[i].CompareRows(oImpTab.Rows[i], rvDefault, []) <> 0 then
      Error(ErrorOnImport(i));
    CheckStates(FTab.Rows[i], oImpTab.Rows[i]);
  end;

  // check importing rows
  // 1.1
  if not PrepareTestWithConnection then begin
    Error(CannotContinueTest);
    Exit;
  end;
  FTab.Rows[0].Delete;
  oRow := FTab.Rows[0];
  oCopyRow := FTab.NewRow(True);
  CheckImportRow(oRow, oCopyRow);

  // 1.2
  with FTab.Rows[1] do begin
    BeginEdit;
    SetData(0, FTab.Rows[1].GetData(0) + 1);
    EndEdit;
  end;
  oRow := FTab.Rows[1];
  oCopyRow := FTab.NewRow(True);
  CheckImportRow(oRow, oCopyRow);

  // 2. The structures are not identical
  // 2.1
  PrepareTestDiffTypes;
  PrepareTestDiffTypes(False, True);
  oImpTab := FTab;
  oCol := oImpTab.Columns.Add('New_Imp', dtAnsiString);
  with oImpTab.Rows.Add([]) do begin
    BeginEdit;
    SetData(oCol, 'imp');
    EndEdit;
  end;

  FTab := FDatSManager.Tables[0];
  FTab.Columns[0].Name := 'New_' + FTab.Columns[0].Name;
  CheckFieldVal(FTab.Rows[0], oImpTab.Rows[0]);

  // 2.2
  FDatSManager.Reset;
  FTab := FDatSManager.Tables.Add;
  FTab.Columns.Add('key', dtInt32).Unique := True;
  FTab.Constraints.AddUK('PK', FTab.Columns[0], True);
  FTab.Rows.Add([1]);

  oImpTab := FDatSManager.Tables.Add;
  oImpTab.Columns.Add('key', dtInt32);
  oImpTab.Rows.Add([1]);

  try
    lWasExc := False;
    FTab.ImportRow(oImpTab.Rows[0]);
  except
    on E: EADException do
      lWasExc := True;
  end;
  if not lWasExc then
    Error(NoExcRaised);

  // 2.3
  FDatSManager.Reset;
  FTab    := FDatSManager.Tables.Add;
  oImpTab := FDatSManager.Tables.Add;
  eSrc  := dtInt32;
  eDest := dtInt32;
  for i := 0 to 6 do begin
    case i of
    0:
      begin
        eSrc    := dtInt32;
        vSrcVal := Integer(-15);
      end;
    1:
      begin
        eSrc    := dtDouble;
        vSrcVal := 7.3848;
      end;
    2:
      begin
        eSrc    := dtDateTime;
        vSrcVal := StrToDateTime_Cast('11/10/1888 22:04:59');
      end;
    3:
      begin
        eSrc    := dtAnsiString;
        vSrcVal := 'klmno';
      end;
    4:
      begin
        eSrc    := dtAnsiString;
        vSrcVal := '134';
      end;
    5:
      begin
        eSrc    := dtByteString;
        vSrcVal := 'abcde';
      end;
    6:
      begin
        eSrc    := dtByteString;
        vSrcVal := '1256';
      end;
    end;
    FTab.Reset;
    FTab.Columns.Add('type', eSrc);
    FTab.Rows.Add([vSrcVal]);
    for j := 0 to 4 do begin
      case j of
      0: eDest := dtInt32;
      1: eDest := dtDouble;
      2: eDest := dtDateTime;
      3: eDest := dtAnsiString;
      4: eDest := dtByteString;
      end;
      if eDest = eSrc then
        continue;
      oImpTab.Reset;
      oImpTab.Columns.Add('type', eDest);
      try
        oImpTab.ImportRow(FTab.Rows[0]);
        V1 := oImpTab.Rows[0].GetData(0);
        case eSrc of
        dtInt32:
          case eDest of
          dtDouble:     V2 := VarAsType(-15, varDouble);
          dtDateTime:   V2 := VarAsType(-15, varDate);
          dtAnsiString: V2 := VarAsType(-15, varString);
          dtByteString:
            begin
              sVal := '-15';
              V2   := GetVarArray(PChar(sVal), Length(sVal));
            end;
          end;
        dtDouble:
          case eDest of
          dtInt32:      V2 := VarAsType(7.3848, varInteger);
          dtDateTime:   V2 := VarAsType(7.3848, varDate);
          dtAnsiString: V2 := VarAsType(7.3848, varString);
          dtByteString:
            begin
              sVal := FloatToStr(7.3848);
              V2   := GetVarArray(PChar(sVal), Length(sVal));
            end;
          end;
        dtDateTime:
          case eDest of
          dtInt32:      V2 := VarAsType(StrToDateTime_Cast('11/10/1888 22:04:59'), varInteger);
          dtDouble:     V2 := VarAsType(StrToDateTime_Cast('11/10/1888 22:04:59'), varDouble);
          dtAnsiString: V2 := VarAsType(StrToDateTime_Cast('11/10/1888 22:04:59'), varString);
          dtByteString:
            begin
              V1 := StrToDateTime(GetStringFromArray(V1));
              V2 := StrToDateTime_Cast('11/10/1888 22:04:59');
            end;
          end;
        dtAnsiString:
          case eDest of
          dtInt32:      V2 := VarAsType('134', varInteger);
          dtDouble:     V2 := VarAsType('134', varDouble);
          dtDateTime:   V2 := VarAsType('134', varDate);
          dtByteString:
            begin
              sVal := vSrcVal;
              V2   := GetVarArray(PChar(sVal), Length(vSrcVal));
            end;
          end;
        dtByteString:
          case eDest of
          dtInt32:;
          dtDouble:;
          dtDateTime:;
          dtAnsiString: V2 := GetStringFromArray(FTab.Rows[0].GetData(0));
          end;
        end;
        if Compare(V1, V2) <> 0 then begin
          Compare(V1, V2);
          Error(WrongTypeCast(ADDataTypesNames[eSrc], ADDataTypesNames[eDest],
                VarToStr(V1), VarToStr(V2)));
        end;
      except
        on E: EADException do
          if E.ADCode <> er_AD_TypeIncompat then
            Error(E.Message);
      end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQADatSTsHolder.TestRange;
var
  oDatSView, oView: TADDatSView;
  oRange:           TADDatSMechRange;
begin
  PrepareTestDiffTypes;

  oDatSView := TADDatSView.Create;
  oView     := TADDatSView.Create;
  try
    oView.Mechanisms.AddSort(FTab.Columns[0].Name);
    oView.Active := True;
    FTab.Views.Add(oView);

    oRange := TADDatSMechRange.Create;
    oDatSView.SourceView := oView;
    oDatSView.Mechanisms.Add(oRange);
    FTab.Views.Add(oDatSView);
    // 1.
    with oRange do begin
      Active := False;
      Top    := FTab.Rows[8];
      Bottom := FTab.Rows[2];
      TopExclusive    := False;
      BottomExclusive := False;
      Active := True;
    end;
    oDatSView.Active := True;
    if oDatSView.Rows.Count <> 6 then
      Error(MechFails('range', IntToStr(oDatSView.Rows.Count), ' <> ', IntToStr(6)));
    oRange.Active := False;
    if oDatSView.Rows.Count = 6 then
      Error(MechFails('range', IntToStr(oDatSView.Rows.Count), ' = ', IntToStr(6)));
    oDatSView.Active := False;

    // 2.
    with oRange do begin
      Active := False;
      Top    := FTab.Rows[9];
      Bottom := FTab.Rows[0];
      TopExclusive    := True;
      BottomExclusive := True;
      Active := True;
    end;
    oDatSView.Active := True;
    if oDatSView.Rows.Count <> 2 then
      Error(MechFails('range', IntToStr(oDatSView.Rows.Count), ' <> ', IntToStr(2)));
    oRange.Active := False;
    if oDatSView.Rows.Count = 2 then
      Error(MechFails('range', IntToStr(oDatSView.Rows.Count), ' = ', IntToStr(2)));
  finally
    oDatSView.Free;
    oView.Free;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQADatSTsHolder.TestManagerReset;
var
  l: Integer;
begin
  try
    for l := 0 to 10 do
      TestChildRelations;
  except
    on E: Exception do begin
      Error(ErrorOnReset(E.Message));
      Exit;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQADatSTsHolder.TestMechMastDet;
var
  oDatSView, oView: TADDatSView;
  oMechDetails:     TADDatSMechDetails;
  oMechMaster:      TADDatSMechMaster;
  i, j, k:          Integer;
  lError:           Boolean;

  procedure PrepareTest;
  var
    i, j, k: Integer;
    oTempTab: TADDatSTable;
  begin
    PrepareTestDiffTypes(True);

    for i := 0 to FTab.Columns.Count - 1 do begin
      oTempTab := FDatSManager.Tables.Add('Table' + IntToStr(i));
      oTempTab.Columns.Add('foreign' + FTab.Columns[i].Name, FTab.Columns[i].DataType);
    end;

    for i := 0 to FTab.Rows.Count - 1 do
      for j := 0 to FTab.Columns.Count - 1 do
        for k := 0 to 5 do
          with FDatSManager do
            Tables[j + 1].Rows.Add([FTab.Rows[i].GetData(j)]);

    for j := 0 to FTab.Columns.Count - 1 do
      with FDatSManager do begin
        Relations.Add(FTab.Columns[j], Tables[j + 1].Columns[0]);
        oView := TADDatSView.Create;
        Tables[j + 1].Views.Add(oView);
        oView.Mechanisms.AddSort(Tables[j + 1].Columns[0].Name);
        oView.Active := True;
      end;
  end;

begin
  PrepareTest;
  for i := 0 to FTab.Rows.Count - 1 do
    for j := 0 to FTab.Columns.Count - 1 do begin
      oDatSView := TADDatSView.Create;
      try
        FDatSManager.Tables[j + 1].Views.Add(oDatSView);
        oMechDetails := TADDatSMechDetails.Create;
        oDatSView.Mechanisms.Add(oMechDetails);
        oDatSView.SourceView := FDatSManager.Tables[j + 1].Views[0];
        with oMechDetails do begin
          try
            Active := False;
            ParentRelation := FDatSManager.Relations[j];
            ParentRow := FTab.Rows[i];
            Active := True;
          except
            on E: Exception do begin
              Error(ErrorOnInitMech('Details', E.Message));
              continue;
            end
          end;
        end;
        oDatSView.Active := True;
        for k := 0 to 5 do
          if oDatSView.Rows.Count = 0 then
            Error(MechFails('Details', FTab.Columns[j].Name,
                  'There are no rows in DatSView!'))
          else if Compare(oDatSView.Rows[k].GetData(0), FTab.Rows[i].GetData(j)) <> 0 then
            Error(MechFails('Details', FTab.Columns[j].Name, ''));
      finally
        oDatSView.Free;
      end
    end;

  for j := 0 to FTab.Columns.Count - 1 do begin
    for k := 0 to FDatSManager.Tables[j + 1].Rows.Count - 1 do begin
      oDatSView := TADDatSView.Create;
      oView := TADDatSView.Create;
      try
        FTab.Views.Add(oDatSView);
        oMechMaster := TADDatSMechMaster.Create;
        oDatSView.Mechanisms.Add(oMechMaster);
        FTab.Views.Add(oView);
        oView.Mechanisms.AddSort(FDatSManager.Relations[j].ParentColumns[0].Name);
        oDatSView.SourceView := oView;
        oView.Active := True;
        with oMechMaster do begin
          try
            Active := False;
            ChildRelation := FDatSManager.Relations[j];
            ChildRow := FDatSManager.Tables[j + 1].Rows[k];
            Active := True;
          except
            on E: Exception do begin
              Error(ErrorOnInitMech('Master', E.Message));
              continue;
            end
          end;
        end;
        oDatSView.Active := True;
        try
          if oDatSView.Rows.Count = 0 then
            Error(MechFails('Master', FTab.Columns[j].Name,
                  'There are no rows in DatSView!'))
          else begin
            lError := True;
            for i := 0 to oDatSView.Rows.Count - 1 do
              lError := lError and (oDatSView.Rows[i].CompareRows(FTab.Rows[k div 6], rvDefault, []) <> 0);
            if lError then
              Error(MechFails('Master', FTab.Columns[j].Name, ''));
          end;
        except
          on E: Exception do
            Error(ErrorOnCompareVal('', E.Message));
        end;
      finally
        oDatSView.Free;
        oView.Free;
      end
    end
  end
end;

{-------------------------------------------------------------------------------}
procedure TADQADatSTsHolder.TestRowCompare;
var
  oRow, oCopyRow: TADDatSRow;

  function PrepareTest: Boolean;
  begin
    Result := PrepareTestWithConnection;
    if not Result then begin
      Error(CannotContinueTest);
      Exit;
    end;
    oRow := FTab.Rows[0];
    oCopyRow := FTab.NewRow(True);
    // following 2 lines here just to link this methods into ADQA
    oRow.DumpRow(False);
    FTab.Rows.DumpCol(0, False);
  end;

  procedure Save;
  begin
    FTab.Import(oRow, oCopyRow);
  end;

  procedure Load;
  begin
    FTab.Import(oCopyRow, oRow);
  end;

  function Compare(ARow1, ARow2: TADDatSRow; AVersion: TADDatSRowVersion = rvDefault): Integer;
  begin
    try
      Result := ARow1.CompareRows(ARow2, AVersion, []);
    except
      on E: Exception do begin
        Error(E.Message);
        Result := -1;
      end;
    end;
  end;

  procedure EditRow(ANum, ACol: Integer; AValue: Variant);
  begin
    with FTab.Rows[ANum] do begin
      BeginEdit;
      SetData(ACol, AValue);
      EndEdit;
    end;
  end;

begin
  if not PrepareTest then
    Exit;
  try
    Save;
    if Compare(oRow, oCopyRow, rvCurrent) <> 0 then
      Error(ComparingRowFails('Row vers. is ' + RowVersions[rvCurrent]));
    EditRow(0, 0, 2);
    if Compare(oRow, oCopyRow, rvCurrent) = 0 then
      Error(ComparingRowFails('Row vers. is ' + RowVersions[rvCurrent]));
    if Compare(oRow, oCopyRow, rvPrevious) <> 0 then
      Error(ComparingRowFails('Row vers. is ' + RowVersions[rvPrevious]));
    if Compare(oRow, oCopyRow, rvOriginal) <> 0 then
      Error(ComparingRowFails('Row vers. is ' + RowVersions[rvOriginal]));
    FTab.AcceptChanges;
    if Compare(oRow, oCopyRow, rvCurrent) = 0 then
      Error(ComparingRowFails('Row vers. is ' + RowVersions[rvCurrent]));
    if Compare(oRow, oCopyRow, rvPrevious) = 0 then
      Error(ComparingRowFails('Row vers. is ' + RowVersions[rvPrevious]));
    Load;
    if Compare(oRow, oCopyRow, rvCurrent) <> 0 then
      Error(ComparingRowFails('Row vers. is ' + RowVersions[rvCurrent]));
    if Compare(oRow, oCopyRow, rvPrevious) <> 0 then
      Error(ComparingRowFails('Row vers. is ' + RowVersions[rvPrevious]));
    EditRow(0, 0, 2);
    Save;
    if Compare(oRow, oCopyRow, rvPrevious) <> 0 then
      Error(ComparingRowFails('Row vers. is ' + RowVersions[rvPrevious]));
  finally
    oCopyRow.Free;
  end;

  // checking comparing with all datatypes fields
  PrepareTestDiffTypes;
  oRow := FTab.Rows[0];
  oCopyRow := FTab.NewRow(True);
  try
    Save;
    if Compare(oRow, oCopyRow) <> 0 then
      Error(ComparingRowFails(''));
    oRow := FTab.Rows[1];
    Save;
    oRow := FTab.Rows[0];
    if Compare(oRow, oCopyRow) = 0 then
      Error(ComparingRowFails(''));
    Load;
    if Compare(oRow, oCopyRow) <> 0 then
      Error(ComparingRowFails(''));
  finally
    oCopyRow.Free;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQADatSTsHolder.TestTableChangeStructure;

  procedure CheckError(AE: Exception);
  begin
    if not (AE is EADException) or
       (EADException(AE).ADCode <> er_AD_CantChangeTableStruct) then
      Error(AE.Message);
  end;

begin
  PrepareTestDiffTypes;
  try
    FTab.Columns.Add('New', dtInt32);
  except
    on E: Exception do
      CheckError(E);
  end;
  try
    FTab.Columns[0].Free;
  except
    on E: Exception do
      CheckError(E);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQADatSTsHolder.TestTableClear;
begin
  PrepareTestDiffTypes;
  try
    FTab.Clear;
    if FTab.Rows.Count <> 0 then
      Error(ErrorOnClearTbRows(''));
    try
      FTab.Reset;
      if FTab.Columns.Count <> 0 then
        Error(ErrorOnTbReset(''));
    except
      on E: Exception do
        Error(ErrorOnTbReset(E.Message));
    end;
  except
    on E: Exception do
      Error(ErrorOnClearTbRows(E.Message));
  end;
end;

procedure TADQADatSTsHolder.TestTableColumns;
var
  i, j:   Integer;
{$IFNDEF AnyDAC_D6}
  v2,
{$ENDIF}
  v:  Variant;
  lEqual: Boolean;
{$IFNDEF AnyDAC_D6}
  cr: Currency;
{$ENDIF}
begin
  PrepareTestDiffTypes;
  for i := 0 to FTab.Rows.Count - 1 do
    for j := 0 to FTab.Columns.Count - 1 do begin
      lEqual := True;
      v := FTab.Rows[i].GetData(j);
      try
        case FTab.Columns[j].DataType of
        dtInt16:         if Compare(v, SmallInts[i])   <> 0 then lEqual := False;
        dtInt32:         if Compare(v, Integers[i])    <> 0 then lEqual := False;
{$IFDEF AnyDAC_D6}
        dtInt64:         if Compare(v, Int64s[i])      <> 0 then lEqual := False;
{$ELSE}
        dtInt64:
          begin
            TVarData(v2).VType := varInt64;
            Decimal(v2).Lo64 := Int64s[i];
            if Compare(v, v2) <> 0 then lEqual := False;
          end;
{$ENDIF}
        dtByte:          if Compare(v, Bytes2[i])      <> 0 then lEqual := False;
        dtUInt16:        if Compare(v, Words[i])       <> 0 then lEqual := False;
{$IFDEF AnyDAC_D6}
        dtUInt32:        if Compare(v, LongWords[i])
{$ELSE}
        dtUInt32:        if Compare(v, Integer(LongWords[i]))
{$ENDIF}
                                                       <> 0 then lEqual := False;
        dtAnsiString:    if Compare(v, Strings[i])     <> 0 then lEqual := False;
        dtWideString:    if Compare(v, WideStrings[i]) <> 0 then lEqual := False;
        dtByteString:    if Compare(v, Bytes[i])       <> 0 then lEqual := False;
        dtBlob:          if Compare(v, Blobs[i])       <> 0 then lEqual := False;
        dtMemo:          if Compare(v, Memos[i])       <> 0 then lEqual := False;
        dtHBlob:         if Compare(v, HBlobs[i])      <> 0 then lEqual := False;
        dtHBFile:        if Compare(v, HBlobs[i])      <> 0 then lEqual := False;
        dtHMemo:         if Compare(v, HMemos[i])      <> 0 then lEqual := False;
        dtWideMemo:      if Compare(v, WideMemos[i])   <> 0 then lEqual := False;
        dtWideHMemo:     if Compare(v, WideHMemos[i])  <> 0 then lEqual := False;
        dtBoolean:       if Compare(v, Booleans[i])    <> 0 then lEqual := False;
        dtSByte:         if Compare(v, ShortInts[i])   <> 0 then lEqual := False;
        dtDouble:        if Compare(v, Floats[i])      <> 0 then lEqual := False;
        dtDateTime:      if Compare(v, DateTimes[i])   <> 0 then lEqual := False;
{$IFDEF AnyDAC_D6}
        dtDateTimeStamp: if Compare(v, VarSQLTimeStampCreate(TimeStamps[i]))
{$ELSE}
        dtDateTimeStamp: if Compare(v, ADSQLTimeStampToDateTime(TimeStamps[i]))
{$ENDIF}
                                                       <> 0 then lEqual := False;
        dtTime:          if Compare(v, Times[i])       <> 0 then lEqual := False;
        dtDate:          if Compare(v, Dates[i])       <> 0 then lEqual := False;
        dtBCD:           if Compare(v, Bcds[i])        <> 0 then lEqual := False;
{$IFDEF AnyDAC_D6}
        dtFmtBCD:        if Compare(v, VarFMTBcdCreate(FMTBcds[i]))
                                                       <> 0 then lEqual := False;
{$ELSE}
        dtFmtBCD:
          begin
            BcdToCurr(FMTBcds[i], cr);
            if Compare(v, cr) <> 0 then lEqual := False;
          end;
{$ENDIF}
        dtCurrency:      if Compare(v, Currencies[i])  <> 0 then lEqual := False;
        dtGUID:          if Compare(v, Guids[i])       <> 0 then lEqual := False;
        end;
      except
        on E: Exception do
          Error(ErrorOnCompareVal(FTab.Columns[j].Name, E.Message));
      end;
      if not lEqual then
        Error(ReadingFails(FTab.Columns[j].Name, ''));
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADQADatSTsHolder.TestTableCompute;
var
  v:     Variant;
  A, B:  Double;
  i:     TADAggregateKind;
  j:     Integer;
  pFunc: TFunc;
  s:     String;
begin
  PrepareTestAllNumericFields;
  for i := Low(TADAggregateKind) to High(TADAggregateKind) do begin
    case i of
    akSum:   pFunc := Sum;
    akAvg:   pFunc := Avg;
    akCount: pFunc := Count;
    akMin:   pFunc := Min;
    akMax:   pFunc := Max;
    else     pFunc := nil;
    end;
    if @pFunc <> nil then
      for j := 0 to FTab.Columns.Count - 1 do
        try
          if i <> akCount then
            s := AggKindNames[i] + '(' + FTab.Columns[j].Name + ')'
          else
            s := AggKindNames[i] + '(*)';
          v := FTab.Compute(s, '');
          A := VarAsType(v, varDouble);
          B := pFunc(j, FTab.Rows.Count - 1);
          if Abs(A - B) > C_DELTA then
            Error(ComputeError(s, VarToStr(A), VarToStr(B)));
        except
          on E: Exception do
            Error(ComputeError(s, E.Message));
        end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQADatSTsHolder.TestViewAggregate;
var
  oAgg:         TADDatSAggregate;
  oView:        TADDatSView;
  i, iColCount: Integer;
  j:            TADAggregateKind;
  vA, vB:       Variant;
  s:            String;
  pFunc:        TFunc;
  pFuncGroup:   TFuncGroup;
  oTab:         TADDatSTable;

  procedure FillTable;
  var
    i, j, k, l, c: Integer;
    aVal: array of Byte;
  begin
    FTab.Clear;
    c := FTab.Columns.Count - 1;
    SetLength(aVal, c + 1);
    for j := 0 to c do begin
      FTab.Rows.Add([]);
      l := 1;
      for k := c - j to c do begin
        aVal[k] := l;
        Inc(l);
      end;
      with FTab.Rows[j] do begin
        BeginEdit;
        for i := 0 to c do
          SetData(i, aVal[i]);
        EndEdit;
      end;
    end;
  end;

  function GetAggrVal(ARowID: Integer): Double;
  begin
    Result := VarAsType(oAgg.Value[ARowID], varDouble)
  end;

  function GetData(ARowID, ACol: Integer): Variant;
  begin
    Result := FTab.Rows[ARowID].GetData(ACol);
  end;

begin
  PrepareTestAllNumericFields;
  oView := FTab.DefaultView;
  // check min, max, count and sum
  for j := Low(TADAggregateKind) to High(AggKindNames) do begin
    case j of
    akSum:   pFunc := Sum;
    akAvg:   pFunc := Avg;
    akCount: pFunc := Count;
    akMin:   pFunc := Min;
    akMax:   pFunc := Max;
    else     pFunc := nil;
    end;
    if @pFunc <> nil then
      for i := 0 to FTab.Columns.Count - 1 do
        try
          if j <> akCount then
            oAgg := oView.Aggregates.Add(AggKindNames[j], AggKindNames[j] +
                       '(' + FTab.Columns[i].Name + ')')
          else
            oAgg := oView.Aggregates.Add(AggKindNames[j], AggKindNames[j] + '(*)');
          try
            vA := GetAggrVal(FTab.Rows.Count - 1);
            vB := pFunc(i, FTab.Rows.Count - 1);
            if Abs(VarAsType(vA, varDouble) - VarAsType(vB, varDouble)) > C_DELTA then
              Error(AggregateError(AggKindNames[j], FTab.Columns[i].Name,
                    VarToStr(vA), VarToStr(vB)));
          finally
            oAgg.Free;
          end;
        except
          on E: Exception do
            Error(AggregateError(AggKindNames[j], FTab.Columns[i].Name,
                  E.Message));
        end;
  end;
  // Grouping level
  FillTable;
  s := FTab.Columns[0].Name;
  iColCount := FTab.Columns.Count - 1;
  oView := FTab.DefaultView;
  for i := 0 to iColCount - 2 do
    s := s + ';' + FTab.Columns[i + 1].Name;
  oView.Mechanisms.AddSort(s);

  for j := Low(TADAggregateKind) to High(TADAggregateKind) do begin
    case j of
    akSum:   pFuncGroup := SumGr;
    akAvg:   pFuncGroup := AvgGr;
    akCount: pFuncGroup := CountGr;
    akMin:   pFuncGroup := MinGr;
    akMax:   pFuncGroup := MaxGr;
    else     pFuncGroup := nil;
    end;
    if @pFunc <> nil then
      for i := 0 to iColCount - 2 do begin
        if j <> akCount then
          oAgg := oView.Aggregates.Add(AggKindNames[j], AggKindNames[j] +
                     '(' + FTab.Columns[iColCount].Name + ')', i + 1)
        else
          oAgg := oView.Aggregates.Add(AggKindNames[j], AggKindNames[j] +
                     '(*)', i + 1);
        try
          vA := GetAggrVal(0);
          vB := pFuncGroup(iColCount, 0, i + 1);
          if Abs(VarAsType(vA, varDouble) - VarAsType(vB, varDouble)) > C_DELTA then
            Error(AggregateError(AggKindNames[j], FTab.Columns[iColCount].Name,
                  VarToStr(vA), VarToStr(vB)));
        finally
          oAgg.Free;
        end;
      end;
  end;
  // simple test from newsgroup
  // conditional calculation on not sorted column, view not sorted too
  oTab := TADDatSTable.Create;
  try
    oTab.Columns.Add('id',       dtInt32);
    oTab.Columns.Add('name',     dtAnsiString).Size := 20;
    oTab.Columns.Add('sum',      dtInt32);
    oTab.Columns.Add('selected', dtBoolean);
    oView := oTab.Views.Add('MyView');
    oAgg := oView.Aggregates.Add('SelSum', 'SUM(IIF(selected, "sum", 0))');
    oTab.Rows.Add([1, 'qwe', 10, True]);
    oTab.Rows.Add([2, 'qwe', 20, False]);
    oTab.Rows.Add([3, 'qwe', 30, True]);
    if oAgg.Value[0] <> 40 then
      Error(AggregateError('SUM(IIF)', 'selected & "sum"',
        '40', VarToStr(oAgg.Value[0])));
  finally
    oTab.Free;
  end;
  // conditional calculation on not sorted column, view is sorted
  oTab := TADDatSTable.Create;
  try
    oTab.Columns.Add('id',       dtInt32);
    oTab.Columns.Add('name',     dtAnsiString).Size := 20;
    oTab.Columns.Add('sum',      dtInt32);
    oTab.Columns.Add('selected', dtBoolean);
    oView := oTab.Views.Add('MyView');
    oView.Sort := 'name';
    oAgg := oView.Aggregates.Add('SelSum', 'SUM(IIF(selected, "sum", 0))');
    oTab.Rows.Add([1, 'qwe', 10, True]);
    oTab.Rows.Add([2, 'qwe', 20, False]);
    oTab.Rows.Add([3, 'qwe', 30, True]);
    if oAgg.Value[0] <> 40 then
      Error(AggregateError('SUM(IIF)', 'selected & "sum"',
        '40', VarToStr(oAgg.Value[0])));
  finally
    oTab.Free;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQADatSTsHolder.TestViewFilter;
var
  oView: TADDatSView;
  aFilter:   array of TADDatSRow;
  i, j, k,
  col, iVal: Integer;
  s:         String;
  V:         Variant;

  procedure Change;
  var
    i: Integer;
  begin
    for i := 0 to FTab.Rows.Count - 1 do
      try
        if FTab.Rows[i].RowState = rsDeleted then
          continue;
        with FTab.Rows[i] do begin
          BeginEdit;
          SetValues([Unassigned, 'String' + IntToStr(GetRandom), Unassigned]);
          EndEdit;
        end;
        break;
      except
        on E: Exception do
          Error(E.Message);
      end;
  end;

  procedure Insert;
  begin
    FTab.Rows.Add([Unassigned, 'String' + IntToStr(GetRandom), Unassigned]);
  end;

  procedure Delete;
  begin
    FTab.Rows[0].Delete;
    FTab.Rows[1].Delete;
  end;

  procedure ClearFilter;
  var
    i: Integer;
  begin
    for i := 0 to High(aFilter) do
      aFilter[i] := nil;
  end;

  function PrepareTest: Boolean;
  begin
    ClearFilter;
    Result := PrepareTestWithConnection;
    if not Result then begin
      Error(CannotContinueTest);
      Exit;
    end;
    oView := FTab.DefaultView;
  end;

begin
  PrepareTestAllNumericFields;
  SetLength(aFilter, FTab.Rows.Count);
  oView := FTab.DefaultView;

  // 1.
  for col := 0 to FTab.Columns.Count - 1 do
    try
      V := FTab.Rows[0].GetData(col);
      s := FTab.Columns[col].Name + ' > ' + VarToStr_Cast(V);
      oView.Mechanisms.AddFilter(s);
      try
        k := 0;
        for i := 0 to FTab.Rows.Count - 1 do
          if Compare(FTab.Rows[i].GetData(col), V) > 0 then begin
            aFilter[k] := FTab.Rows[i];
            Inc(k);
          end;
        if k <> oView.Rows.Count then
          Error(MechFails('Filter', FTab.Columns[col].Name, ' > ', VarToStr(V)))
        else begin
          oView.Mechanisms.AddSort(FTab.Columns[col].Name);
          for i := 0 to k - 1 do
            if oView.Find(aFilter[i], []) = -1 then
              Error(MechFails('Filter', FTab.Columns[col].Name, ' > ', VarToStr(V)));
        end;
      finally
        oView.Mechanisms.Clear;
      end;
    except
      on E: Exception do
        Error(MechFails('Filter', FTab.Columns[col].Name, E.Message));
    end;

  // 2.
  ClearFilter;
  for col := 0 to FTab.Columns.Count - 1 do
    try
      V := FTab.Rows[0].GetData(col);
      s := FTab.Columns[col].Name + ' < ' + VarToStr_Cast(V);
      oView.RowFilter := s;
      try
        k := 0;
        for i := 0 to FTab.Rows.Count - 1 do
          if FTab.Rows[i].GetData(col) < V then begin
            aFilter[k] := FTab.Rows[i];
            Inc(k);
          end;
        if k <> oView.Rows.Count then
          Error(RowFiltFails(FTab.Columns[col].Name, ' < ', VarToStr(V)))
        else begin
          oView.Mechanisms.AddSort(FTab.Columns[col].Name);
          for i := 0 to k - 1 do
            if oView.Find(aFilter[i], []) = -1 then
              Error(RowFiltFails(FTab.Columns[col].Name, ' < ', VarToStr(V)));
        end;
      finally
        oView.Mechanisms.Clear;
      end;
    except
      on E: Exception do
        Error(MechFails('RowFilter', FTab.Columns[col].Name, E.Message));
    end;

  // 3.
  // rowstate rsDeleted
  if not PrepareTest then
    Exit;
  SetLength(aFilter, FTab.Rows.Count);
  Delete;
  oView.RowStateFilter := [rsDetached, rsInserted, rsModified, rsUnchanged,
    rsEditing, rsCalculating, rsChecking, rsDestroying,
    rsImportingCurent, rsImportingOriginal, rsImportingProposed];
  try
    k := 0;
    for j := 0 to FTab.Rows.Count - 1 do
      if FTab.Rows[j].RowState = rsDeleted then begin
        aFilter[k] := FTab.Rows[j];
        Inc(k);
      end;
    try
      oView.Mechanisms.AddSort('id');
      for i := 0 to k - 1 do begin
        iVal := oView.Find(aFilter[i], []);
        if iVal <> -1 then
          Error(RowStFiltFails(RowsStates[rsDeleted]));
      end;
    except
      on E: Exception do
        Error(MechFails('RowStateFilter', RowsStates[rsDeleted], E.Message));
    end;
  finally
    oView.Mechanisms.Clear;
  end;

  // 4.
  // rowstate rsInserted
  if not PrepareTest then
    Exit;
  Insert;
  Insert;
  oView.RowStateFilter := [rsDetached, rsDeleted, rsModified, rsUnchanged,
    rsEditing, rsCalculating, rsChecking, rsDestroying,
    rsImportingCurent, rsImportingOriginal, rsImportingProposed];
  try
    k := 0;
    for j := 0 to FTab.Rows.Count - 1 do
      if FTab.Rows[j].RowState = rsInserted then begin
        aFilter[k] := FTab.Rows[j];
        Inc(k);
      end;
    oView.Mechanisms.AddSort('id');
    for i := 0 to k - 1 do begin
      iVal := oView.Find(aFilter[i], []);
      if iVal <> -1 then
        Error(RowStFiltFails(RowsStates[rsInserted]));
    end
  finally
    oView.Mechanisms.Clear;
  end;

  // 5.
  // rowstate rsModified
  if not PrepareTest then
    Exit;
  Change;
  oView.RowStateFilter := [rsDetached, rsInserted, rsDeleted, rsUnchanged,
    rsEditing, rsCalculating, rsChecking, rsDestroying,
    rsImportingCurent, rsImportingOriginal, rsImportingProposed];
  try
    k := 0;
    for j := 0 to FTab.Rows.Count - 1 do
      if FTab.Rows[j].RowState = rsModified then begin
        aFilter[k] := FTab.Rows[j];
        Inc(k);
      end;
    oView.Mechanisms.AddSort('id');
    for i := 0 to k - 1 do begin
      iVal := oView.Find(aFilter[i], []);
      if iVal <> -1 then
        Error(RowStFiltFails(RowsStates[rsModified]));
    end
  finally
    oView.Mechanisms.Clear;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQADatSTsHolder.TestViewSearch;
var
  oView:   TADDatSView;
  oMechFilter: TADDatSMechFilter;
  oRow:        TADDatSRow;
  i, j:        Integer;
  s:           String;
  lFound:      Boolean;
  V:           Variant;
begin
  lFound := True;
  PrepareTestDiffTypes;
  oView := FTab.DefaultView;

  // 1.
  for j := 0 to FTab.Columns.Count - 1 do begin
    oView.Mechanisms.AddSort(FTab.Columns[j].Name);
    try
      try
        for i := 0 to FTab.Rows.Count - 1 do
          if oView.Find([FTab.Rows[i].GetData(FTab.Columns[j])], []) = -1 then
            Error(SearchFails(FTab.Columns[j].Name));
      except
        on E: Exception do
          Error(ErrorOnExecFind(E.Message));
      end;
    finally
      oView.Mechanisms.Clear;
    end;
  end;

  // 2.
  for i := 0 to FTab.Columns.Count - 1 do
    try
      try
        s := FTab.Columns[0].Name;
        ClearArray;
        SetLength(FVars, i + 1);
        FVars[0] := FTab.Rows[0].GetData(0);
        for j := 1 to i do begin
          s := s + ';' + FTab.Columns[j].Name;
          FVars[j] := FTab.Rows[0].GetData(j);
        end;
        oView.Mechanisms.AddSort(s);
        if oView.Find(FVars, []) = -1 then
          Error(SearchFails('few columns'));
      except
        on E: Exception do
          Error(ErrorOnExecFind(E.Message));
      end;
    finally
      oView.Mechanisms.Clear;
    end;

  // 3.
  oRow := FTab.NewRow(False);
  try
    oRow.SetValues(FVars);
    oView.Search(oRow, nil, nil, -1, [], i, lFound);
    if not lFound then
      Error(SearchFails(''));
  finally
    oRow.Free;
  end;

  // 4.
  PrepareTestAllNumericFields;
  oView := FTab.DefaultView;
  for j := 0 to FTab.Columns.Count - 1 do begin
    V := FTab.Rows[0].GetData(j);
    s := FTab.Columns[j].Name + ' = ' + VarToStr_Cast(V);
    oMechFilter := TADDatSMechFilter.Create(s);
    oMechFilter.Locator := True;
    try
      oView.Mechanisms.Add(oMechFilter);
      try
        oView.Locate(i, True, True);
        if i <> 0 then
          Error(SearchFails(FTab.Columns[j].Name));
      finally
        oMechFilter.Free;
      end;
    except
      on E: Exception do
        Error(E.Message);
    end;
  end;
  oView.Mechanisms.Clear;

  // 5.
  try
    s := FTab.Columns[0].Name;
    ClearArray;
    SetLength(FVars, 1);
    FVars[0] := FTab.Rows[0].GetData(0);
    FTab.Rows[0].Delete;
    oView.Mechanisms.AddSort(s);
    try
      if oView.Find(FVars, []) <> -1 then
        Error(SearchFails('found the deleted row'));
    except
      on E: Exception do
        Error(ErrorOnExecFind(E.Message));
    end;
  except
    on E: Exception do
        Error(E.Message);
  end;
end;

{-------------------------------------------------------------------------------}
type
  TStrCompare     = function (const s1, s2: String): Integer;
  TWideStrCompare = function (const s1, s2: WideString): Integer;

procedure TADQADatSTsHolder.TestViewSort;
var
  oView: TADDatSView;
  i, j:      Integer;
  s1, s2:    String;
  Indx:      array[0..9] of Integer;

  procedure PrepareTest;
  var
    i: Integer;
  begin
    FDatSManager.Reset;
    FTab := FDatSManager.Tables.Add;
    FTab.Columns.Add('Str',     dtAnsiString);
    FTab.Columns.Add('WideStr', dtWideString);

    for i := 0 to 9 do
      FTab.Rows.Add([Strings[i], WideStrings[i]]);
  end;

  procedure Sort(ACaseSens, AWideStr, daADesc: Boolean);
  var
    PStrFunc:     TStrCompare;
    PWideStrFunc: TWideStrCompare;
    i, j, k:      Integer;
    lCond:        Boolean;
  begin
    for i := 0 to 9 do
      Indx[i] := i;
    if not AWideStr then begin
      if ACaseSens then
        PStrFunc := AnsiCompareStrA
      else
        PStrFunc := AnsiCompareTextA;
      for i := 0 to 9 do
        for j := 0 to 9 - i - 1 do begin
          if not daADesc then
            lCond := PStrFunc(Strings[Indx[j]], Strings[Indx[j + 1]]) > 0
          else
            lCond := PStrFunc(Strings[Indx[j]], Strings[Indx[j + 1]]) < 0;
          if lCond then begin
            k := Indx[j + 1];
            Indx[j + 1] := Indx[j];
            Indx[j] := k;
          end;
        end;
    end
    else begin
      if ACaseSens then
        PWideStrFunc := WideCompareStrA
      else
        PWideStrFunc := WideCompareTextA;
      for i := 0 to 9 do
        for j := 0 to 9 - i - 1 do begin
          if not daADesc then
            lCond := PWideStrFunc(WideStrings[Indx[j]], WideStrings[Indx[j + 1]]) > 0
          else
            lCond := PWideStrFunc(WideStrings[Indx[j]], WideStrings[Indx[j + 1]]) < 0;
          if lCond then begin
            k := Indx[j + 1];
            Indx[j + 1] := Indx[j];
            Indx[j] := k;
          end;
        end;
    end;
  end;

begin
  PrepareTest;
  // case ins.
  oView := FTab.DefaultView;
  oView.Mechanisms.AddSort('Str', '', 'Str');
  Sort(False, False, False);
  for i := 0 to 9 do begin
    s1 := oView.Rows[i].GetData(0);
    s2 := Strings[Indx[i]];
    if AnsiCompareText(s1, s2) <> 0 then
      Error(SortingFails('in', '', '', s1, s2));
  end;
  oView.Mechanisms.Clear;

  oView.Mechanisms.AddSort('Str', 'Str', 'Str');
  Sort(False, False, True);
  for i := 0 to 9 do begin
    s1 := oView.Rows[i].GetData(0);
    s2 := Strings[Indx[i]];
    if AnsiCompareText(s1, s2) <> 0 then
      Error(SortingFails('in', 'desc', '', s1, s2));
  end;
  oView.Mechanisms.Clear;

  oView.Mechanisms.AddSort('WideStr', '', 'WideStr');
  Sort(False, True, False);
  for i := 0 to 9 do begin
    s1 := oView.Rows[i].GetData(1);
    s2 := WideStrings[Indx[i]];
    if AnsiCompareText(s1, s2) <> 0 then
      Error(SortingFails('in', '', 'wide', s1, s2));
  end;
  oView.Mechanisms.Clear;

  oView.Mechanisms.AddSort('WideStr', 'WideStr', 'WideStr');
  Sort(False, True, True);
  for i := 0 to 9 do begin
    s1 := oView.Rows[i].GetData(1);
    s2 := WideStrings[Indx[i]];
    if AnsiCompareText(s1, s2) <> 0 then
      Error(SortingFails('in', 'desc', 'wide', s1, s2));
  end;
  oView.Mechanisms.Clear;

  // case sens
  oView.Mechanisms.AddSort('Str');
  Sort(True, False, False);
  for i := 0 to 9 do begin
    s1 := oView.Rows[i].GetData(0);
    s2 := Strings[Indx[i]];
    if s1 <> s2 then
      Error(SortingFails('', '', '', s1, s2));
  end;
  oView.Mechanisms.Clear;

  oView.Mechanisms.AddSort('Str', 'Str');
  Sort(True, False, True);
  for i := 0 to 9 do begin
    s1 := oView.Rows[i].GetData(0);
    s2 := Strings[Indx[i]];
    if s1 <> s2 then
      Error(SortingFails('', 'desc', '', s1, s2));
  end;
  oView.Mechanisms.Clear;

  oView.Mechanisms.AddSort('WideStr');
  Sort(True, True, False);
  for i := 0 to 9 do begin
    s1 := oView.Rows[i].GetData(1);
    s2 := WideStrings[Indx[i]];
    if s1 <> s2 then
      Error(SortingFails('', '', 'wide', s1, s2));
  end;
  oView.Mechanisms.Clear;

  oView.Mechanisms.AddSort('WideStr', 'WideStr');
  Sort(True, True, True);
  for i := 0 to 9 do begin
    s1 := oView.Rows[i].GetData(1);
    s2 := WideStrings[Indx[i]];
    if s1 <> s2 then
      Error(SortingFails('', 'desc', 'wide', s1, s2));
  end;
  oView.Mechanisms.Clear;

  // check sorting of different type fields
  PrepareTestAllNumericFields;
  oView := FTab.DefaultView;
  // sorting
  for i := 0 to FTab.Columns.Count - 1 do
    try
      oView.Mechanisms.AddSort(FTab.Columns[i].Name);
      for j := 0 to oView.Rows.Count - 2 do
        if Compare(oView.Rows[j].GetData(i), oView.Rows[j + 1].GetData(i)) = 1 then
          Error(SortingFails(FTab.Columns[i].Name,
            VarToStr(oView.Rows[j].GetData(i)), ' < ',
            VarToStr(oView.Rows[j + 1].GetData(i))));
      oView.Mechanisms.Clear;
    except
      on E: Exception do begin
        Error(ErrorInColumn(FTab.Columns[i].Name, E.Message));
        Exit;
      end
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADQADatSTsHolder.TestViewSortAndFill;
var
  oView: TADDatSView;
begin
  FDatSManager.Reset;
  FTab := FDatSManager.Tables.Add;
  FTab.Columns.Add('ID',  dtInt32);
  FTab.Columns.Add('Str', dtAnsiString);
  oView := FTab.DefaultView;
  oView.Mechanisms.AddSort('ID');

  // 1. Ascending
  // 1.1. Add rows with the same key value
  FTab.Rows.Add([1, 'a']);
  FTab.Rows.Add([1, 'b']);
  FTab.Rows.Add([1, 'c']);
  if oView.Rows.Count <> 3 then
    Error(Format('1.1. Row number in view is [%d], but must be [3]', [oView.Rows.Count]));
  if oView.Rows.DumpCol(1) <> 'a; b; c' then
    Error(Format('1.1. Row order in view is [%s], but must be [a; b; c]', [oView.Rows.DumpCol(1)]));

  // 1.2. Add rows in reverse order of key value
  FTab.Rows.Clear;
  FTab.Rows.Add([1, 'a']);
  FTab.Rows.Add([100, 'b']);
  FTab.Rows.Add([9, 'c']);
  FTab.Rows.Add([8, 'd']);
  if oView.Rows.Count <> 4 then
    Error(Format('1.2. Row number in view is [%d], but must be [4]', [oView.Rows.Count]));
  if oView.Rows.DumpCol(0) <> '1; 8; 9; 100' then
    Error(Format('1.2. Row order in view is [%s], but must be [1; 8; 9; 100]', [oView.Rows.DumpCol(0)]));

  FTab.Rows.Clear;
  FTab.Rows.Add([1, 'a']);
  FTab.Rows.Add([100, 'b']);
  FTab.Rows.Add([2, 'c']);
  if oView.Rows.Count <> 3 then
    Error(Format('1.2. Row number in view is [%d], but must be [3]', [oView.Rows.Count]));
  if oView.Rows.DumpCol(0) <> '1; 2; 100' then
    Error(Format('1.2. Row order in view is [%s], but must be [1; 2; 100]', [oView.Rows.DumpCol(0)]));

  // 1.3. Changing non key columns
  FTab.Rows[2].BeginEdit;
  FTab.Rows[2].SetData(1, 'c');
  FTab.Rows[2].EndEdit;
  if oView.Rows.Count <> 3 then
    Error(Format('1.3. Row number in view is [%d], but must be [3]', [oView.Rows.Count]));
  if oView.Rows.DumpCol(0) <> '1; 2; 100' then
    Error(Format('1.3. Row order in view is [%s], but must be [1; 2; 100]', [oView.Rows.DumpCol(0)]));

  oView.Mechanisms.Clear;
  oView.Mechanisms.AddSort('ID', 'ID');

  // 2. Descending
  // 2.1. Add rows with the same key value
  FTab.Rows.Clear;
  FTab.Rows.Add([1, 'a']);
  FTab.Rows.Add([1, 'b']);
  FTab.Rows.Add([1, 'c']);
  if oView.Rows.Count <> 3 then
    Error(Format('2.1. Row number in view is [%d], but must be [3]', [oView.Rows.Count]));
  if oView.Rows.DumpCol(1) <> 'a; b; c' then
    Error(Format('2.1. Row order in view is [%s], but must be [a; b; c]', [oView.Rows.DumpCol(1)]));

  // 2.2. Add rows in reverse order of key value
  FTab.Rows.Clear;
  FTab.Rows.Add([1, 'a']);
  FTab.Rows.Add([100, 'b']);
  FTab.Rows.Add([9, 'c']);
  FTab.Rows.Add([8, 'd']);
  if oView.Rows.Count <> 4 then
    Error(Format('2.2. Row number in view is [%d], but must be [4]', [oView.Rows.Count]));
  if oView.Rows.DumpCol(0) <> '100; 9; 8; 1' then
    Error(Format('2.2. Row order in view is [%s], but must be [100; 9; 8; 1]', [oView.Rows.DumpCol(0)]));

  FTab.Rows.Clear;
  FTab.Rows.Add([1, 'a']);
  FTab.Rows.Add([100, 'b']);
  FTab.Rows.Add([2, 'c']);
  if oView.Rows.Count <> 3 then
    Error(Format('2.2. Row number in view is [%d], but must be [3]', [oView.Rows.Count]));
  if oView.Rows.DumpCol(0) <> '100; 2; 1' then
    Error(Format('2.2. Row order in view is [%s], but must be [100; 2; 1]', [oView.Rows.DumpCol(0)]));

  // 2.3. Changing non key columns
  FTab.Rows[2].BeginEdit;
  FTab.Rows[2].SetData(1, 'c');
  FTab.Rows[2].EndEdit;
  if oView.Rows.Count <> 3 then
    Error(Format('2.3. Row number in view is [%d], but must be [3]', [oView.Rows.Count]));
  if oView.Rows.DumpCol(0) <> '100; 2; 1' then
    Error(Format('2.3. Row order in view is [%s], but must be [100; 2; 1]', [oView.Rows.DumpCol(0)]));
end;

{-------------------------------------------------------------------------------}
procedure TADQADatSTsHolder.TestViewsLinkage;

  procedure PrepareTest;
  var
    i: Integer;
  begin
    FDatSManager.Reset;
    FTab := FDatSManager.Tables.Add;
    FTab.Columns.Add('ID',  dtInt32);
    FTab.Columns.Add('Str', dtAnsiString);

    for i := 0 to 9 do
      FTab.Rows.Add([i, IntToStr(i)]);
  end;

var
  oView1, oView2: TADDatSView;
  oRow: TADDatSRow;
begin
  PrepareTest;

  oView1 := TADDatSView.Create;
  oView1.Mechanisms.AddSort('ID');
  oView1.Active := True;
  FTab.Views.Add(oView1);

  oView2 := TADDatSView.Create;
  oView2.Mechanisms.AddFilter('ID < 5');
  oView2.Mechanisms.AddStates();
  oView2.SourceView := oView1;
  oView2.Active := True;
  FTab.Views.Add(oView2);
  try
    oRow := FTab.Rows[0];
    if oView2.Rows.IndexOf(oRow) = -1 then
      Error('Row is not in the subview, although it must be there');

    with oRow do begin
      BeginEdit;
      SetData(0, 1000);
      EndEdit;
    end;
    if oView2.Rows.IndexOf(oRow) <> -1 then
      Error('Row is in the subview, although it must NOT be there');

    with oRow do begin
      BeginEdit;
      SetData(0, 2);
      EndEdit;
    end;
    if oView2.Rows.IndexOf(oRow) <> 1 then
      Error('Row in the subview is not #2');

    with oRow do
      Delete;
    if oView2.Rows.IndexOf(oRow) <> -1 then
      Error('Row is in the subview, although it must NOT be there');

  finally
    oView1.Free;
    oView2.Free;
    FDatSManager.Reset;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQADatSTsHolder.ClearArray;
var
  i: Integer;
begin
  for i := 0 to High(FVars) do
    FVars[i] := Unassigned;
end;

{-------------------------------------------------------------------------------}
function TADQADatSTsHolder.GetRandom: Integer;
begin
  Inc(FCurRandom);
  FCurRandom := FCurRandom mod 10;
  Result := Randoms[FCurRandom];
end;

{-------------------------------------------------------------------------------}
procedure TADQADatSTsHolder.PrepareTestAllNumericFields;
var
  i: Integer;
{$IFNDEF AnyDAC_D6}
  v: Variant;
  cr: Currency;
{$ENDIF}
begin
  FDatSManager.Reset;
  FTab := FDatSManager.Tables.Add;
  FTab.Columns.Add(C_tInt16,    dtInt16);
  FTab.Columns.Add(C_tInt32,    dtInt32);
  FTab.Columns.Add(C_tInt64,    dtInt64);
  FTab.Columns.Add(C_tByte,     dtByte);
  FTab.Columns.Add(C_tSByte,    dtSByte);
  FTab.Columns.Add(C_tUInt16,   dtUInt16);
  FTab.Columns.Add(C_tUInt32,   dtUInt32);
  FTab.Columns.Add(C_tUInt64,   dtUInt64);
  FTab.Columns.Add(C_tDouble,   dtDouble);
  FTab.Columns.Add(C_tBCD,      dtBCD);
  FTab.Columns.Add(C_tFmtBcd,   dtFmtBCD);
  FTab.Columns.Add(C_tCurrency, dtCurrency);

  for i := 0 to 9 do begin
{$IFDEF AnyDAC_D6}
    FTab.Rows.Add([SmallInts[i], Integers[i], Int64s[i], Bytes2[i], ShortInts[i],
                   Words[i], LongWords[i], LongWords[i], Floats[i], Bcds[i],
                   VarFMTBcdCreate(FMTBcds[i]), Currencies[i]]);
{$ELSE}
    TVarData(v).VType := varInt64;
    Decimal(v).Lo64 := Int64s[i];
    BCDToCurr(FMTBcds[i], cr);
    FTab.Rows.Add([SmallInts[i], Integers[i], v, Bytes2[i], ShortInts[i],
                   Words[i], Integer(LongWords[i]), Integer(LongWords[i]), Floats[i], Bcds[i],
                   cr, Currencies[i]]);
{$ENDIF}
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQADatSTsHolder.PrepareTestDiffTypes(ABtStringOff: Boolean = False;
  ANoDatSManagerReset: Boolean = False);
var
  i: Integer;
{$IFNDEF AnyDAC_D6}
  v: Variant;
  cr: Currency;
{$ENDIF}
begin
  if not ANoDatSManagerReset then
    FDatSManager.Reset;
  FTab := FDatSManager.Tables.Add;
  FTab.Columns.Add(C_tInt16,         dtInt16);
  FTab.Columns.Add(C_tInt32,         dtInt32);
  FTab.Columns.Add(C_tInt64,         dtInt64);
  FTab.Columns.Add(C_tByte,          dtByte);
  FTab.Columns.Add(C_tUInt16,        dtUInt16);
  FTab.Columns.Add(C_tUInt32,        dtUInt32);
  FTab.Columns.Add(C_tUInt64,        dtUInt64);
  FTab.Columns.Add(C_tAnsiString,    dtAnsiString);
  FTab.Columns.Add(C_tWideString,    dtWideString);
  if not ABtStringOff then
    FTab.Columns.Add(C_tByteString,  dtByteString);
  FTab.Columns.Add(C_tBlob,          dtBlob);
  FTab.Columns.Add(C_tHBlob,         dtHBlob);
  FTab.Columns.Add(C_tHBFile,        dtHBFile);
  FTab.Columns.Add(C_tMemo,          dtMemo);
  FTab.Columns.Add(C_tHMemo,         dtHMemo);
  FTab.Columns.Add(C_tBoolean,       dtBoolean);
  FTab.Columns.Add(C_tSByte,         dtSByte);
  FTab.Columns.Add(C_tDouble,        dtDouble);
  FTab.Columns.Add(C_tDateTime,      dtDateTime);
  FTab.Columns.Add(C_tTime,          dtTime);
  FTab.Columns.Add(C_tDate,          dtDate);
  FTab.Columns.Add(C_tBCD,           dtBCD);
  FTab.Columns.Add(C_tFmtBcd,        dtFmtBCD);
  FTab.Columns.Add(C_tDateTimeStamp, dtDateTimeStamp);
  FTab.Columns.Add(C_tCurrency,      dtCurrency);
  FTab.Columns.Add(C_tGUID,          dtGUID);
  FTab.Columns.Add(C_tWideMemo,      dtWideMemo);
  FTab.Columns.Add(C_tWideHMemo,     dtWideHMemo);
  if ANoDatSManagerReset then
    Exit;
  for i := 0 to 9 do begin
{$IFDEF AnyDAC_D6}
    if not ABtStringOff then
      FTab.Rows.Add([SmallInts[i], Integers[i], Int64s[i], Bytes2[i], Words[i],
                    LongWords[i], LongWords[i], Strings[i], WideStrings[i],
                    Bytes[i], Blobs[i], HBlobs[i], HBlobs[i], Memos[i], HMemos[i],
                    Booleans[i], ShortInts[i], Floats[i], DateTimes[i], Times[i],
                    Dates[i], Bcds[i], VarFMTBcdCreate(FMTBcds[i]),
                    VarSQLTimeStampCreate(TimeStamps[i]), Currencies[i],
                    Guids[i], WideMemos[i], WideHMemos[i]])
    else
      FTab.Rows.Add([SmallInts[i], Integers[i], Int64s[i], Bytes2[i], Words[i],
                    LongWords[i], LongWords[i], Strings[i], WideStrings[i],
                    Blobs[i], HBlobs[i], HBlobs[i], Memos[i], HMemos[i],
                    Booleans[i], ShortInts[i], Floats[i], DateTimes[i], Times[i],
                    Dates[i], Bcds[i], VarFMTBcdCreate(FMTBcds[i]),
                    VarSQLTimeStampCreate(TimeStamps[i]), Currencies[i],
                    Guids[i], WideMemos[i], WideHMemos[i]]);
{$ELSE}
    TVarData(v).VType := varInt64;
    Decimal(v).Lo64 := Int64s[i];
    BCDToCurr(FMTBcds[i], cr);
    if not ABtStringOff then
      FTab.Rows.Add([SmallInts[i], Integers[i], v, Bytes2[i], Words[i],
                     Integer(LongWords[i]), Integer(LongWords[i]), Strings[i], WideStrings[i],
                     Bytes[i], Blobs[i], HBlobs[i], HBlobs[i], Memos[i], HMemos[i],
                     Booleans[i], ShortInts[i], Floats[i], DateTimes[i], Times[i],
                     Dates[i], Bcds[i], cr,
                     ADSQLTimeStampToDateTime(TimeStamps[i]), Currencies[i],
                     Guids[i], WideMemos[i], WideHMemos[i]])
    else
      FTab.Rows.Add([SmallInts[i], Integers[i], v, Bytes2[i], Words[i],
                     Integer(LongWords[i]), Integer(LongWords[i]), Strings[i], WideStrings[i],
                     Blobs[i], HBlobs[i], HBlobs[i], Memos[i], HMemos[i],
                     Booleans[i], ShortInts[i], Floats[i], DateTimes[i], Times[i],
                     Dates[i], Bcds[i], cr,
                     ADSQLTimeStampToDateTime(TimeStamps[i]), Currencies[i],
                     Guids[i], WideMemos[i], WideHMemos[i]]);
{$ENDIF}
  end;
end;

{-------------------------------------------------------------------------------}
function TADQADatSTsHolder.PrepareTestWithConnection: Boolean;
begin
  FDatSManager.Reset;

  FTab := FDatSManager.Tables.Add;
  SetConnectionDefFileName(CONN_DEF_STORAGE);
  OpenPhysManager;

  ADPhysManager.CreateConnection(GetConnectionDef(FRDBMSKind), FConnIntf);
  FConnIntf.LoginPrompt := False;
  FConnIntf.Open;
  FConnIntf.CreateCommand(FCommIntf);
  Result := False;
  try
    with FCommIntf do begin
      Prepare('select * from {id Shippers} order by ShipperID');
      Define(FTab);
      with FTab.Columns[0] do begin
        Name := 'id';
        AutoIncrement := True;
        AutoIncrementSeed := -1;
        AutoIncrementStep := -1;
        ReadOnly := False;
      end;
      FTab.Columns[1].Name := 'f1';
      FTab.Columns[2].Name := 'f2';
      Open;
      Fetch(FTab);
    end;
    Result := CheckRowsCount(FTab, 3);
  except
    on E: Exception do
      Error(E.Message);
  end;
end;

initialization

  ADQAPackManager.RegisterPack('DatS Layer', TADQADatSTsHolder);

end.
