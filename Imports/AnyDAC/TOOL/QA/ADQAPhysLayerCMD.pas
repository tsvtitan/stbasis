{-------------------------------------------------------------------------------}
{ AnyDAC Phys Layer tests                                                       }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit ADQAPhysLayerCMD;

interface

uses
  Classes, Windows, SysUtils, DB,
  ADQAPack, ADQAPhysLayerCNN,
  daADStanIntf, daADStanOption, daADStanParam,
  daADDatSManager,
  daADGUIxIntf,
  daADPhysIntf;

type
  TADQAPhysCMDTsHolder = class (TADQAPhysTsHolderBase)
  private
    function GetMacrosString(ADataType: TADMacroDataType; AIndx: Integer): String;
    procedure RunMacros(ACommText: String; ADataType: TADMacroDataType; AIndx: Integer);
  public
    procedure RegisterTests; override;
    procedure TestCommandBatchExec;
    procedure TestCommandBatchExecAffect;
    procedure TestMapping;
    procedure TestMappingStrings;
    procedure TestParamBindMode;
    procedure TestReadWriteBlob;
    procedure TestSeveralCursors;
    procedure TestStringsBorderLength;
    procedure TestAsyncCmdExec;
    procedure TestCommandDefAndMerge;
    procedure TestCommandDefineDB2;
    procedure TestCommandDefineMSAccess;
    procedure TestCommandDefineMSSQL;
    procedure TestCommandDefineASA;
    procedure TestCommandDefineMySQL;
    procedure TestCommandDefineOra;
    procedure TestCommandDefineSameCol;
    procedure TestCommandDisconnectable;
    procedure TestCommandIns;
    procedure TestCommandMacroDB2;
    procedure TestCommandMacroMSAccess;
    procedure TestCommandMacroMSSQL;
    procedure TestCommandMacroASA;
    procedure TestCommandMacroMySQL;
    procedure TestCommandMacroOra;
    procedure TestCurrencyBcdFmtBcd;
    procedure TestCmdOraclPreprocessor;
    procedure TestCmdMySQLPreprocessor;
    procedure TestBoolValue;
    procedure TestCmdKind;
    procedure TestNumericPrecision;
  end;

implementation

uses
{$IFDEF AnyDAC_D6}
  Variants, FMTBcd, SqlTimSt,
{$ELSE}
  ActiveX, ComObj, 
{$ENDIF}  
  Controls, Dialogs, Math,
  ADQAConst, ADQAUtils, ADQAEvalFuncs, ADQAVarField,
  daADPhysCmdPreprocessor, daADStanUtil, daADStanConst, daADStanError;

{-------------------------------------------------------------------------------}
{ TADQAPhysTsHolder                                                             }
{-------------------------------------------------------------------------------}
procedure TADQAPhysCMDTsHolder.RegisterTests;
begin
  RegisterTest('PhysCommand;Define;Types;DB2',                   TestCommandDefineDB2, mkDB2);
  RegisterTest('PhysCommand;Define;Types;MS Access',             TestCommandDefineMSAccess, mkMSAccess);
  RegisterTest('PhysCommand;Define;Types;MSSQL',                 TestCommandDefineMSSQL, mkMSSQL);
  RegisterTest('PhysCommand;Define;Types;ASA',                   TestCommandDefineASA, mkASA);
  RegisterTest('PhysCommand;Define;Types;MySQL',                 TestCommandDefineMySQL, mkMySQL);
  RegisterTest('PhysCommand;Define;Types;Oracle',                TestCommandDefineOra, mkOracle);
  RegisterTest('PhysCommand;Define;With merge;DB2',              TestCommandDefAndMerge, mkDB2);
  RegisterTest('PhysCommand;Define;With merge;MS Access',        TestCommandDefAndMerge, mkMSAccess);
  RegisterTest('PhysCommand;Define;With merge;MSSQL',            TestCommandDefAndMerge, mkMSSQL);
  RegisterTest('PhysCommand;Define;With merge;ASA',              TestCommandDefAndMerge, mkASA);
  RegisterTest('PhysCommand;Define;With merge;MySQL',            TestCommandDefAndMerge, mkMySQL);
  RegisterTest('PhysCommand;Define;With merge;Oracle',           TestCommandDefAndMerge, mkOracle);
  RegisterTest('PhysCommand;Define;The same col;DB2',            TestCommandDefineSameCol, mkDB2);
  RegisterTest('PhysCommand;Define;The same col;MS Access',      TestCommandDefineSameCol, mkMSAccess);
  RegisterTest('PhysCommand;Define;The same col;MSSQL',          TestCommandDefineSameCol, mkMSSQL);
  RegisterTest('PhysCommand;Define;The same col;ASA',            TestCommandDefineSameCol, mkASA);
  RegisterTest('PhysCommand;Define;The same col;MySQL',          TestCommandDefineSameCol, mkMySQL);
  RegisterTest('PhysCommand;Define;The same col;Oracle',         TestCommandDefineSameCol, mkOracle);
  RegisterTest('PhysCommand;Disconnectable;Oracle',              TestCommandDisconnectable, mkOracle);
  RegisterTest('PhysCommand;Batch execute;DB2',                  TestCommandBatchExec, mkDB2);
  RegisterTest('PhysCommand;Batch execute;MS Access',            TestCommandBatchExec, mkMSAccess);
  RegisterTest('PhysCommand;Batch execute;MSSQL',                TestCommandBatchExec, mkMSSQL);
  RegisterTest('PhysCommand;Batch execute;ASA',                  TestCommandBatchExec, mkASA);
  RegisterTest('PhysCommand;Batch execute;MySQL',                TestCommandBatchExec, mkMySQL);
  RegisterTest('PhysCommand;Batch execute;Oracle',               TestCommandBatchExec, mkOracle);
  RegisterTest('PhysCommand;Batch execute;With affect;DB2',      TestCommandBatchExecAffect, mkDB2);
  RegisterTest('PhysCommand;Batch execute;With affect;MS Access',TestCommandBatchExecAffect, mkMSAccess);
  RegisterTest('PhysCommand;Batch execute;With affect;MSSQL',    TestCommandBatchExecAffect, mkMSSQL);
  RegisterTest('PhysCommand;Batch execute;With affect;ASA',      TestCommandBatchExecAffect, mkASA);
  RegisterTest('PhysCommand;Batch execute;With affect;MySQL',    TestCommandBatchExecAffect, mkMySQL);
  RegisterTest('PhysCommand;Batch execute;With affect;Oracle',   TestCommandBatchExecAffect, mkOracle);
  RegisterTest('PhysCommand;Insert-Fetch;DB2',                   TestCommandIns, mkDB2);
  RegisterTest('PhysCommand;Insert-Fetch;MS Access',             TestCommandIns, mkMSAccess);
  RegisterTest('PhysCommand;Insert-Fetch;MSSQL',                 TestCommandIns, mkMSSQL);
  RegisterTest('PhysCommand;Insert-Fetch;ASA',                   TestCommandIns, mkASA);
  RegisterTest('PhysCommand;Insert-Fetch;MySQL',                 TestCommandIns, mkMySQL);
  RegisterTest('PhysCommand;Insert-Fetch;Oracle',                TestCommandIns, mkOracle);
  RegisterTest('PhysCommand;Insert-Fetch;Currency;DB2',          TestCurrencyBcdFmtBcd, mkDB2);
  RegisterTest('PhysCommand;Insert-Fetch;Currency;MS Access',    TestCurrencyBcdFmtBcd, mkMSAccess);
  RegisterTest('PhysCommand;Insert-Fetch;Currency;MSSQL',        TestCurrencyBcdFmtBcd, mkMSSQL);
  RegisterTest('PhysCommand;Insert-Fetch;Currency;ASA',          TestCurrencyBcdFmtBcd, mkASA);
  RegisterTest('PhysCommand;Insert-Fetch;Currency;MySQL',        TestCurrencyBcdFmtBcd, mkMySQL);
  RegisterTest('PhysCommand;Insert-Fetch;Currency;Oracle',       TestCurrencyBcdFmtBcd, mkOracle);
  RegisterTest('PhysCommand;Macros;DB2',                         TestCommandMacroDB2, mkDB2);
  RegisterTest('PhysCommand;Macros;MS Access',                   TestCommandMacroMSAccess, mkMSAccess);
  RegisterTest('PhysCommand;Macros;MSSQL',                       TestCommandMacroMSSQL, mkMSSQL);
  RegisterTest('PhysCommand;Macros;ASA',                         TestCommandMacroASA, mkASA);
  RegisterTest('PhysCommand;Macros;MySQL',                       TestCommandMacroMySQL, mkMySQL);
  RegisterTest('PhysCommand;Macros;Oracle',                      TestCommandMacroOra, mkOracle);
  RegisterTest('PhysCommand;Mapping;Ins-Fetch;DB2',              TestMapping, mkDB2);
  RegisterTest('PhysCommand;Mapping;Ins-Fetch;MS Access',        TestMapping, mkMSAccess);
  RegisterTest('PhysCommand;Mapping;Ins-Fetch;MSSQL',            TestMapping, mkMSSQL);
  RegisterTest('PhysCommand;Mapping;Ins-Fetch;ASA',              TestMapping, mkASA);
  RegisterTest('PhysCommand;Mapping;Ins-Fetch;MySQL',            TestMapping, mkMySQL);
  RegisterTest('PhysCommand;Mapping;Ins-Fetch;Oracle',           TestMapping, mkOracle);
  RegisterTest('PhysCommand;Mapping;Ansi- to WideString',        TestMappingStrings, mkOracle);
  RegisterTest('PhysCommand;Async executing;DB2',                TestAsyncCmdExec, mkDB2);
  RegisterTest('PhysCommand;Async executing;MS Access',          TestAsyncCmdExec, mkMSAccess);
  RegisterTest('PhysCommand;Async executing;MSSQL',              TestAsyncCmdExec, mkMSSQL);
  RegisterTest('PhysCommand;Async executing;ASA',                TestAsyncCmdExec, mkASA);
  RegisterTest('PhysCommand;Async executing;Oracle',             TestAsyncCmdExec, mkOracle);
  RegisterTest('PhysCommand;Several cursors;DB2',                TestSeveralCursors, mkDB2);
  RegisterTest('PhysCommand;Several cursors;MS Access',          TestSeveralCursors, mkMSAccess);
  RegisterTest('PhysCommand;Several cursors;MSSQL',              TestSeveralCursors, mkMSSQL);
  RegisterTest('PhysCommand;Several cursors;ASA',                TestSeveralCursors, mkASA);
  RegisterTest('PhysCommand;Several cursors;MySQL',              TestSeveralCursors, mkMySQL);
  RegisterTest('PhysCommand;Several cursors;Oracle',             TestSeveralCursors, mkOracle);
  RegisterTest('PhysCommand;Params;Border length;DB2',           TestStringsBorderLength, mkDB2);
  RegisterTest('PhysCommand;Params;Border length;MS Access',     TestStringsBorderLength, mkMSAccess);
  RegisterTest('PhysCommand;Params;Border length;MSSQL',         TestStringsBorderLength, mkMSSQL);
  RegisterTest('PhysCommand;Params;Border length;ASA',           TestStringsBorderLength, mkASA);
  RegisterTest('PhysCommand;Params;Border length;MySQL',         TestStringsBorderLength, mkMySQL);
  RegisterTest('PhysCommand;Params;Border length;Oracle',        TestStringsBorderLength, mkOracle);
  RegisterTest('PhysCommand;Params;Bind mode;DB2',               TestParamBindMode, mkDB2);
  RegisterTest('PhysCommand;Params;Bind mode;MS Access',         TestParamBindMode, mkMSAccess);
  RegisterTest('PhysCommand;Params;Bind mode;MSSQL',             TestParamBindMode, mkMSSQL);
  RegisterTest('PhysCommand;Params;Bind mode;ASA',               TestParamBindMode, mkASA);
  RegisterTest('PhysCommand;Params;Bind mode;MySQL',             TestParamBindMode, mkMySQL);
  RegisterTest('PhysCommand;Params;Bind mode;Oracle',            TestParamBindMode, mkOracle);
  RegisterTest('PhysCommand;Params;Precision;MSSQL',             TestNumericPrecision, mkMSSQL);
  RegisterTest('PhysCommand;Blobs;DB2',                          TestReadWriteBlob, mkDB2);
  RegisterTest('PhysCommand;Blobs;MS Access',                    TestReadWriteBlob, mkMSAccess);
  RegisterTest('PhysCommand;Blobs;MSSQL',                        TestReadWriteBlob, mkMSSQL);
  RegisterTest('PhysCommand;Blobs;ASA',                          TestReadWriteBlob, mkASA);
  RegisterTest('PhysCommand;Blobs;MySQL',                        TestReadWriteBlob, mkMySQL);
  RegisterTest('PhysCommand;Blobs;Oracle',                       TestReadWriteBlob, mkOracle);
  RegisterTest('PhysCommand;Command preprocessor;Parsing;Oracle',TestCmdOraclPreprocessor, mkOracle);
  RegisterTest('PhysCommand;Command preprocessor;Parsing;MySQL', TestCmdMySQLPreprocessor, mkMySQL);
  RegisterTest('PhysCommand;Command preprocessor;Boolean',       TestBoolValue, mkOracle);
  RegisterTest('PhysCommand;Command preprocessor;Kind',          TestCmdKind, mkOracle);
end;

{-------------------------------------------------------------------------------}
function TADQAPhysCMDTsHolder.GetMacrosString(ADataType: TADMacroDataType; AIndx: Integer): String;
var
  s: String;
begin
  s := 'select 1 from {id ADQA_All_types} where ';
  if AIndx > 0 then begin
    if (ADataType <> mdDate) and (ADataType <> mdTime) then
      s := s + FTab.Columns[AIndx].Name + ' = !MAC'
    else if ADataType = mdDate then
      s := s + '{fn CONVERT(' + FTab.Columns[AIndx].Name + ', DATE)}' + ' = !MAC'
    else if ADataType = mdTime then
      s := s + '{fn CONVERT(' + FTab.Columns[AIndx].Name + ', TIME)}' + ' = !MAC';
  end
  else
    s := 'select 1 from !MAC';
  if AIndx = -10 then
    s := '';
  Result := s;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysCMDTsHolder.RunMacros(ACommText: String; ADataType: TADMacroDataType;
  AIndx: Integer);
var
  oTmpTab: TADDatSTable;
begin
  oTmpTab := FDatSManager.Tables.Add;
  try
    with FCommIntf do begin
      if ACommText = '' then
        Exit;
      oTmpTab.Clear;
      CommandText := ACommText;
      if Macros.Count = 0 then begin
        Error(MacroCountIsZero(MacroTypes[ADataType]));
        Exit;
      end;
      with Macros[0], FVarFieldList do begin
        if AIndx = -1 then
          Value := 'ADQA_All_types'
        else
          try
            Value := VarValues[AIndx];
          except
            on E: Exception do
              Error(E.Message);
          end;
        Name := 'MAC';
        DataType  := ADataType;
      end;
      try
        try
          Prepare;
          try
            Define(oTmpTab);
            Open;
            Fetch(oTmpTab);
          except
            on E: Exception do begin
              Error(ErrorTableDefine(C_AD_PhysRDBMSKinds[FRDBMSKind], MacroTypes[ADataType] + ' type. ' +
                    E.Message));
              Exit;
            end
          end
        finally
          Unprepare;
          CommandKind := skUnknown;
        end;
      except
        on E: Exception do
          Error(ErrorCommPrepare(C_AD_PhysRDBMSKinds[FRDBMSKind], MacroTypes[ADataType] + ' type. ' +
                E.Message));
      end;
      if oTmpTab.Rows.Count <> 1 then begin
        Error(WrongRowCount(1, oTmpTab.Rows.Count) + '; the tested macro type is ' +
              MacroTypes[ADataType]);
        Exit;
      end;
      if Compare(oTmpTab.Rows[0].GetData(0), 1) <> 0 then
        Error(MacroFails(C_AD_PhysRDBMSKinds[FRDBMSKind], MacroTypes[ADataType]));
    end;
  finally
    FDatSManager.Tables.Remove(oTmpTab);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysCMDTsHolder.TestCmdOraclPreprocessor;
var
  oPP: TADPhysPreprocessor;
  oConnMeta: IADPhysConnectionMetadata;
  i: Integer;

  procedure CPC(ACount: Integer);
  begin
    if ACount <> oPP.Params.Count then
      Error(CmdPreprError('PC=' + IntToStr(oPP.Params.Count), IntToStr(ACount)));
  end;

  procedure CMC(ACount: Integer);
  begin
    if ACount <> oPP.MacrosUpd.Count then
      Error(CmdPreprError('PC=' + IntToStr(oPP.MacrosUpd.Count), IntToStr(ACount)));
  end;

  procedure CP(AIndex: Integer; const AName: String);
  begin
    if oPP.Params[AIndex].Name <> AName then
      Error(CmdPreprError('P[' + IntToStr(AIndex) + ']="' + oPP.Params[AIndex].Name +
        '"', AName));
  end;

  procedure CM(AIndex: Integer; const AName: String);
  begin
    if oPP.MacrosUpd[AIndex].Name <> AName then
      Error(CmdPreprError('P[' + IntToStr(AIndex) + ']="' + oPP.MacrosUpd[AIndex].Name +
        '"', AName));
  end;

begin
  FConnIntf.CreateMetadata(oConnMeta);
  oPP := TADPhysPreprocessor.Create;
  oPP.ConnMetadata := oConnMeta;
  oPP.MacrosRead := TADMacros.Create;
  oPP.MacrosUpd := oPP.MacrosRead;
  oPP.Params := TADParams.Create;
  try
    // 1) Extracting FROM clause
    oPP.Instrs := [piExpandMacros, piExpandEscapes, piParseSQL];
    for i := Low(OraSQLCommands) to High(OraSQLCommands) do begin
      oPP.Source := OraSQLCommands[i];
      try
        oPP.Execute;
      except
      end;
      if AnsiCompareStr(oPP.SQLFromValue, SQLFromRes[i]) <> 0 then
        Error(CmdPreprError(oPP.SQLFromValue, SQLFromRes[i]));
    end;

    // 2) Extracting params and macros
    oPP.Instrs := [piCreateParams, piExpandParams, piCreateMacros, piExpandMacros];
    for i := Low(OraSQLParams) to High(OraSQLParams) do begin
      oPP.Source := OraSQLParams[i];
      oPP.MacrosUpd.Clear;
      oPP.Params.Clear;
      oPP.Execute;
      case i of
      0: begin CPC(3); CMC(0); CP(0, 'P0'); CP(1, 'P1'); CP(2, 'P2'); end;
      1: begin CPC(0); CMC(3); CM(0, 'M0'); CM(1, 'M1'); CM(2, 'M2'); end;
      2: begin CPC(0); CMC(3); CM(0, 'M0'); CM(1, 'M1'); CM(2, 'M2'); end;
      3: begin CPC(0); CMC(0); end;
      4: begin CPC(0); CMC(0); end;
      5: begin CPC(0); CMC(0); end;
      6: begin CPC(3); CMC(0); CP(0, 'P0'); CP(1, 'p1'); CP(2, 'P2'); end;
      7: begin CPC(0); CMC(3); CM(0, 'M0'); CM(1, 'm1'); CM(2, 'M2'); end;
      8: begin CPC(0); CMC(3); CM(0, 'M0'); CM(1, 'm1'); CM(2, 'M2'); end;
      9: begin CPC(1); CMC(1); CP(0, 'P1'); CM(0, 'M1'); end;
      end;
    end;

    // 3) Only params / only macros
    oPP.Source := OraSQLParams[High(OraSQLParams)];
    oPP.Instrs := [piCreateParams];
    oPP.MacrosUpd.Clear;
    oPP.Params.Clear;
    oPP.Execute;
    CPC(1); CMC(0); CP(0, 'P1');

    oPP.Instrs := [piCreateMacros];
    oPP.MacrosUpd.Clear;
    oPP.Params.Clear;
    oPP.Execute;
    CPC(0); CMC(1); CM(0, 'M1');

    // 4) No expanding
    oPP.Instrs := [piExpandEscapes, piParseSQL];
    for i := Low(OraSQLParams) to High(OraSQLParams) do begin
      oPP.Source := OraSQLParams[i];
      oPP.MacrosUpd.Clear;
      oPP.Params.Clear;
      oPP.Execute;
      CPC(0); CMC(0);
      if OraSQLParams[i] <> oPP.Destination then
        Error(CmdPreprError('NoProc=' + OraSQLParams[i], oPP.Destination));
    end;

  finally
    oPP.Params.Free;
    oPP.MacrosRead.Free;
    oPP.Free;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysCMDTsHolder.TestCmdMySQLPreprocessor;
var
  oPP: TADPhysPreprocessor;
  oConnMeta: IADPhysConnectionMetadata;
  i: Integer;
begin
  FConnIntf.CreateMetadata(oConnMeta);
  oPP := TADPhysPreprocessor.Create;
  oPP.ConnMetadata := oConnMeta;
  oPP.MacrosRead := TADMacros.Create;
  oPP.MacrosUpd := oPP.MacrosRead;
  oPP.Params := TADParams.Create;
  try

    oPP.Instrs := [piCreateParams, piExpandParams, piCreateMacros, piExpandMacros,
      piExpandEscapes, piParseSQL];
    for i := Low(MySQLParams) to High(MySQLParams) do begin
      oPP.Source := MySQLParams[i];
      oPP.MacrosUpd.Clear;
      oPP.Params.Clear;
      try
        oPP.Execute;
        if MySQLParams[i] <> oPP.Destination then
          Error(CmdPreprError('NoProc=' + MySQLParams[i], oPP.Destination));
      except
        on E: Exception do
          Error(CmdPreprError(E.Message, MySQLParams[i]));
      end;
    end;

  finally
    oPP.Params.Free;
    oPP.MacrosRead.Free;
    oPP.Free;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysCMDTsHolder.TestBoolValue;
var
  V1, V2: Variant;

  procedure Check(AWhat: Boolean);
  var
    s: String;
  begin
    if AWhat then
      s := '{l True}'
    else
      s := '{l False}';
    with FCommIntf do begin
      Prepare('select ' + s + ' from dual');
      Define(FTab);
      Open;
      Fetch(FTab);
    end;
    try
      V1 := FTab.Rows[0].GetData(0);
      V2 := AWhat;
      if (V1 <> V2) and (V1 <> Ord(Boolean(V2))) then
        Error(EscapeFails('{l }', VarToStr(V1), VarToStr(V2)));
    except
      on E: Exception do
        Error(E.Message);
    end;
  end;

begin
  if not ConnectionSwitch then begin
    Error(CannotContinueTest);
    Exit;
  end;
  Check(True);
  Check(False);
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysCMDTsHolder.TestCmdKind;
var
  oCmd: IADPhysCommand;

  procedure Check(ACmdKind: TADPhysCommandKind; const ASrcObjName, ACase: String);
  const
    S_PhysCommandKinds: array [TADPhysCommandKind] of string =
    ('skUnknown', 'skSelect', 'skSelectForUpdate', 'skDelete',
    'skInsert', 'skUpdate', 'skCreate', 'skAlter', 'skDrop', 'skStoredProc',
    'skStoredProcWithCrs', 'skStoredProcNoCrs', 'skExecute', 'skOther');
  begin
    if (oCmd.CommandKind <> ACmdKind) or (oCmd.SourceObjectName <> ASrcObjName) then
      Error(CmdPreprError('[' + ACase + '], CK=[' + S_PhysCommandKinds[oCmd.CommandKind] +
                          '] SON=[' + oCmd.SourceObjectName + ']',
                          'CK=[' + S_PhysCommandKinds[ACmdKind] +
                          '] SON=[' + ASrcObjName + ']'));
  end;

begin
  FConnIntf.CreateCommand(oCmd);

  oCmd.CommandText := 'select * from dual';
  oCmd.Prepare;
  Check(skSelect, 'dual', '1');

  oCmd.CommandText := 'delete from dual';
  oCmd.Prepare;
  Check(skDelete, '', '2');

  oCmd.CommandText := 'insert into dual';
  oCmd.Prepare;
  Check(skInsert, '', '3');

  oCmd.CommandText := 'update dual';
  oCmd.Prepare;
  Check(skUpdate, '', '4');

  oCmd.CommandText := 'create dual';
  oCmd.Prepare;
  Check(skCreate, '', '5');

  oCmd.CommandText := 'alter dual';
  oCmd.Prepare;
  Check(skAlter, '', '6');

  oCmd.CommandText := 'drop dual';
  oCmd.Prepare;
  Check(skDrop, '', '7');

  oCmd.CommandText := '';
  Check(skUnknown, '', '8');

  oCmd.CommandKind := skDrop;
  oCmd.CommandText := 'select * from dual';
  oCmd.Prepare;
  Check(skDrop, 'dual', '9');

  oCmd.CommandText := '';
  Check(skDrop, '', '10');

  oCmd.CommandKind := skUnknown;
  oCmd.CommandText := 'select * from dual';
  oCmd.Prepare;
  Check(skSelect, 'dual', '11');
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysCMDTsHolder.TestAsyncCmdExec;
var
  iTm, iArr: LongWord;
  lExc: Boolean;

  procedure PrepareTest(AArrSize: LongWord = 0);
  var
    i: Integer;
    iArrSize: LongWord;
  begin
    with FCommIntf do begin
      Options.ResourceOptions.AsyncCmdMode := amBlocking;
      Prepare('delete from {id ADQA_ForAsync}');
      try
        Execute;
      except
        on E: Exception do
          Error(E.Message);
      end;

      iArrSize := AArrSize;
      if AArrSize = 0 then
        case FRDBMSKind of
        mkMSAccess: iArrSize := 500;
        mkMSSQL:    iArrSize := 1000;
        mkASA:      iArrSize := 500;
        mkOracle:   iArrSize := 800;
        mkDB2:      iArrSize := 1000;
        end;

      CommandText := 'insert into {id ADQA_ForAsync}(id, name) values(:id, :name)';
      Params[0].DataType := ftInteger;
      Params[1].DataType := ftString;
      Params.ArraySize   := iArrSize;
      try
        Prepare;
      except
        on E: Exception do
          Error(E.Message);
      end;
      for i := 0 to iArrSize - 1 do begin
        Params[0].AsIntegers[i] := 0;
        Params[1].AsStrings[i]  := 'str' + IntToStr(i);
      end;
      try
        Execute(iArrSize, 0);
      except
        on E: Exception do
          Error(E.Message);
      end;
      CheckCommandState(csPrepared, FCommIntf);
      CommandKind := skUnknown;
    end;
  end;

begin
  // Async mode = amCancelDialog
  PrepareTest;
  with FCommIntf do begin
    Options.ResourceOptions.AsyncCmdMode := amCancelDialog;
    if FRDBMSKind <> mkASA then
      Prepare('SELECT Count(*) ' +
              'FROM {id ADQA_ForAsync} a, {id ADQA_ForAsync} b ' +
              'GROUP BY a.name, b.name')
    else
      Prepare('SELECT a.name ' +
              'FROM {id ADQA_ForAsync} a, {id ADQA_ForAsync} b, {id ADQA_ForAsync} c ' +
              'GROUP BY a.name, b.name, c.name');

    CheckCommandState(csPrepared, FCommIntf);
    try
      try
        Open;
        CheckCommandState(csOpen, FCommIntf);
      except
        on E: Exception do begin
          if not(E is EAbort) then
            Error(E.Message);
        end;
      end;
    finally
      try
        Unprepare;
        CheckCommandState(csInactive, FCommIntf);
      except
        on E: Exception do
          Error(E.Message);
      end;
    end;
  end;
  if MessageDlg(DidYouSee('Cancel Dialog'), mtInformation,
               [mbYes, mbNo], 0) <> Ord(mrYes) then
    Error(CancelDialogFails);

  // Abort on Execute
  if FRDBMSKind in [mkMSSQL, mkASA, mkMSAccess] then
    iArr := 10000
  else
    iArr := 5000;
  PrepareTest(iArr);
  with FCommIntf do begin
    Options.ResourceOptions.AsyncCmdMode := amAsync;
    Prepare('UPDATE {id ADQA_ForAsync} SET name = ''changed''');
    try
      try
        Execute;
        Trace('>> 1. AbortJob ' + CommandState[FCommIntf.State]);
        AbortJob;
        Trace('<< 1. AbortJob ' + CommandState[FCommIntf.State]);
        iTm := GetTickCount;
        while (FCommIntf.State = csAborting) and (GetTickCount - iTm < 8000) do
          Sleep(0);
        CheckCommandState(csPrepared, FCommIntf);
      except
        on E: Exception do begin
          if not(E is EAbort) then
            Error(ErrorOnAbortFunction(E.Message));
        end;
      end;
    finally
      try
        Unprepare;
        CheckCommandState(csInactive, FCommIntf);
      except
        on E: Exception do
          Error(ErrorOnUnprepFunction(E.Message));
      end;
    end;
  end;

  // Abort on Open
  PrepareTest;
  with FCommIntf do begin
    Options.ResourceOptions.AsyncCmdMode := amAsync;
    Prepare('SELECT Count(*) ' +
            'FROM {id ADQA_ForAsync} a, {id ADQA_ForAsync} b ' +
            'GROUP BY a.name, b.name');
    try
      try
        Open;
        Trace('>> 2. AbortJob ' + CommandState[FCommIntf.State]);
        AbortJob;
        Trace('<< 2. AbortJob ' + CommandState[FCommIntf.State]);
        iTm := GetTickCount;
        Trace('>> 2. Wait not csAborting ' + CommandState[FCommIntf.State]);
        while (FCommIntf.State = csAborting) and (GetTickCount - iTm < 8000) do
          Sleep(0);
        Trace('>> 2. Wait not csAborting ' + CommandState[FCommIntf.State]);
        CheckCommandState(csPrepared, FCommIntf, 'Abort on Open');
      except
        on E: Exception do begin
          if not(E is EAbort) then
            Error(ErrorOnAbortFunction(E.Message));
        end;
      end;
    finally
      try
        Unprepare;
        CheckCommandState(csInactive, FCommIntf);
      except
        on E: Exception do
          Error(ErrorOnUnprepFunction(E.Message));
      end;
    end;
  end;

  // Async mode = amAsync
  PrepareTest(10000);
  with FCommIntf do begin
    Options.ResourceOptions.AsyncCmdMode := amAsync;
    Prepare('UPDATE {id ADQA_ForAsync} SET name = ''changed''');
    try
      try
        Trace('>> 3. Execute ' + CommandState[FCommIntf.State]);
        Execute;
        Trace('<< 3. Execute ' + CommandState[FCommIntf.State]);
        CheckCommandState(csExecuting, FCommIntf, 'Async mode = amAsync');
        try
          lExc := False;
          Prepare('select * from {id Shippers}');
        except
          lExc := True;
        end;
        if not lExc then
          Error(NoExcWithAsyncMode);
        iTm := GetTickCount;
        try
          while (State = csExecuting) and (GetTickCount - iTm < 8000) do
            Sleep(0);
          CheckCommandState(csPrepared, FCommIntf);
        except
          on E: Exception do
            Error(E.Message);
        end;
      except
        on E: Exception do
          Error(E.Message);
      end;
    finally
      try
        Unprepare;
        CheckCommandState(csInactive, FCommIntf);
      except
        on E: Exception do
          Error(E.Message);
      end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysCMDTsHolder.TestCommandDefAndMerge;
var
  lWasExc: Boolean;

  procedure ConfigureTable;
  begin
    FDatSManager.Reset;
    FTab := FDatSManager.Tables.Add;
    FTab.SourceName := EncodeName(FRDBMSKind, 'Categories');
    with FTab.Columns.Add('CategoryID', dtInt32) do begin
      SourceID := 1;
      SourceName := 'Categoryid';
      AutoIncrement := True;
      AutoIncrementSeed := -2;
      AutoIncrementStep := -3;
    end;
  end;

  procedure DefineTab(ATable: String; AMode: TADPhysMetaInfoMergeMode);
  begin
    with FCommIntf do begin
      Prepare('select * from {id ' + ATable + '}');
      Define(FTab, AMode);
    end;
  end;

  procedure DefineManager(ATable: String; AMode: TADPhysMetaInfoMergeMode);
  begin
    with FCommIntf do begin
      Prepare('select * from {id ' + ATable + '}');
      Define(FDatSManager, nil, AMode);
    end;
  end;

begin
  ConfigureTable;
  DefineTab('Categories', mmOverride);
  CheckColumnsCount(FTab, 4);

  ConfigureTable;
  lWasExc := False;
  try
    DefineTab('Categories', mmRely);
  except
    on E: Exception do begin
      Error(E.Message);
      lWasExc := True;
    end;
  end;
  if not lWasExc then
    CheckColumnsCount(FTab, 1);

  ConfigureTable;
  DefineManager('Products', mmRely);
  if FDatSManager.Tables.Count <> 1 then
    Error(WrongTableCount(1, FDatSManager.Tables.Count))
  else
    CheckColumnsCount(FTab, 1);

  ConfigureTable;
  DefineManager('Products', mmOverride);
  if FDatSManager.Tables.Count <> 2 then
    Error(WrongTableCount(2, FDatSManager.Tables.Count))
  else begin
    DefineManager('Categories', mmOverride);
    CheckColumnsCount(FTab, 4, -1, '[Define(FDatSManager, nil, mmOverride)]');
    if AnsiCompareText(FTab.SourceName, EncodeName(FRDBMSKind, 'Categories')) <> 0 then
      Error(WrongTableName(EncodeName(FRDBMSKind,'Categories'), FTab.SourceName) +
            '. [Define(FDatSManager, nil, mmOverride)]');

    CheckColumnsCount(FDatSManager.Tables[1], 10, -1,
                      '[Define(FDatSManager, nil, mmOverride)]');
    if AnsiCompareText(FDatSManager.Tables[1].SourceName, EncodeName(FRDBMSKind,'Products')) <> 0 then
      Error(WrongTableName(EncodeName(FRDBMSKind,'Products'), FDatSManager.Tables[1].SourceName));
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysCMDTsHolder.TestCommandDisconnectable;
var
  oComm: array [0..24] of IADPhysCommand;
  i, j, k: Integer;
begin
  TADTopResourceOptions(FConnIntf.Options.ResourceOptions).MaxCursors := 20;
  FCommIntf := nil;
  for i := 0 to 24 do begin
    FConnIntf.CreateCommand(oComm[i]);
    oComm[i].Options.ResourceOptions.Disconnectable := True;
    with oComm[i].Options.FetchOptions do begin
      Mode := fmOnDemand;
      RowsetSize := 10;
    end;
    FConnIntf.TxBegin;
    if not FConnIntf.TxIsActive then
      Error(TransIsInactive);
    try
      with oComm[i] do begin
        Prepare('select * from {id Order Details}');
        Define(FTab);
        Open;
        Fetch(FTab, False);
        try
          if i > 9 then
            Fetch(FTab, False);
        except
          on E: Exception do begin
            Error(E.Message);
            Exit;
          end;
        end;
      end;
      FConnIntf.TxCommit;
      if FConnIntf.TxIsActive then
        Error(TransIsActive);
    except
      FConnIntf.TxRollback;
      if FConnIntf.TxIsActive then
        Error(TransIsActive);
      for j := 0 to 9 do
        CheckCommandState(csInactive, oComm[j], ' #' + IntToStr(j));
      k := 0;
      for j := 0 to i - 1 do
        if oComm[j].State = csInactive then
          Inc(k);
      if Abs(k - ((i - 1) * 80) div 100) > 1 then
        Error(WrongCountInactComm(k, ((i - 1) * 80) div 100));
      Exit;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysCMDTsHolder.TestCurrencyBcdFmtBcd;
var
  sComm: String;
  rCurrency: Currency;
  rBcd: Currency;
  rFmtBCD: TBcd;
{$IFNDEF AnyDAC_D6}
  cr: Currency;
{$ENDIF}
begin
  sComm := 'insert into {id ADQA_Bcd}(ftCurrency, ftBCD, ftFmtBCD) ' +
           'values(:ftCurrency, :ftBCD, :ftFmtBCD)';
  with FCommIntf do begin
    if FRDBMSKind in [mkOracle, mkDB2] then
      with Options.FormatOptions do begin
        OwnMapRules := True;
        with MapRules.Add do begin
          PrecMin := 19;
          PrecMax := 19;
          ScaleMin := 4;
          ScaleMax := 4;
          SourceDataType := dtFmtBCD;
          TargetDataType := dtCurrency;
        end;
      end;
    try
      Prepare('delete from {id ADQA_Bcd}');
      Execute;

      try
        CommandText := sComm;
      except
        on E: Exception do begin
          Error(E.Message);
          Exit;
        end;
      end;

      rCurrency := StrToCurrency_Cast('445315487961234.5999');
      rBcd      := StrToCurrency_Cast('455315487961234.9119');
      rFmtBCD   := StrToBcd_Cast('989455315487961234.9119');

      Params[0].AsCurrency := rCurrency;
      Params[1].AsBCD      := rBcd;
      Params[2].AsFMTBCD   := rFmtBCD;

      try
        Prepare;
        Execute;
      except
        on E: Exception do begin
          Error(E.Message);
          Exit;
        end;
      end;

      Prepare('select * from {id ADQA_Bcd}');
      Define(FTab);
      Open;
      Fetch(FTab);

      if Abs(rCurrency - FTab.Rows[0].GetData('ftCurrency')) > 0.11 then
        Error(WrongValueInColumn('ftCurrency', '',
              VarToStr(FTab.Rows[0].GetData('ftCurrency')), CurrToStr(rCurrency)));

      if Abs(rBcd - FTab.Rows[0].GetData('ftBCD')) > 0.11 then
        Error(WrongValueInColumn('ftBCD', '',
              VarToStr(FTab.Rows[0].GetData('ftBCD')), CurrToStr(rBcd)));

{$IFDEF AnyDAC_D6}
      if BcdCompare(rFmtBCD, VarToBcd(FTab.Rows[0].GetData('ftFmtBCD'))) <> 0 then
        Error(WrongValueInColumn('ftFmtBCD', '',
              VarToStr(FTab.Rows[0].GetData('ftFmtBCD')), BcdToStr(rFmtBCD)));
{$ELSE}
      BCDToCurr(rFmtBCD, cr);
      if Abs(cr - FTab.Rows[0].GetData('ftFmtBCD')) > 0.0001 then
        Error(WrongValueInColumn('ftFmtBCD', '',
              VarToStr(FTab.Rows[0].GetData('ftFmtBCD')), CurrToStr(cr)));
{$ENDIF}
    finally
      with Options.FormatOptions do begin
        MapRules.Clear;
        OwnMapRules := False;
      end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysCMDTsHolder.TestCommandIns;
var
  j, k:   Integer;
  V1, V2: Variant;
begin
  DeleteFromSource;
  GetParamsArray;
  with FCommIntf do begin
    CommandText := GetInsertString;
    k := 0;
    for j := 0 to Params.Count - 1 do
      with Params[j], FVarFieldList do begin
        ParamType := ptInput;
        try
          while IsOfUnknownType(k) do
            Inc(k);
          DataType := Types[k];
          Size     := Sizes[k];
          Value    := VarValues[k];
          Inc(k);
        except
          on E: Exception do begin
            Error(ErrorOnSetParamValue(VarToStr(VarValues[k]), E.Message));
            Exit;
          end
        end;
      end;
    Prepare;
    try
      try
        Execute;
      except
        on E: Exception do begin
          Error('#1. ' + ErrorOnCommExec(C_AD_PhysRDBMSKinds[FRDBMSKind], E.Message));
          Exit;
        end
      end
    finally
      Unprepare;
    end;

    Prepare('select * from {id ADQA_All_types}');
    try
      Define(FTab);
      Open;
      try
        Fetch(FTab);
      except
        on E: Exception do begin
          Error(ErrorFetchToTable(C_AD_PhysRDBMSKinds[FRDBMSKind], E.Message));
          Exit;
        end
      end
    finally
      Unprepare;
    end;
  end;

  for j := 0 to FTab.Columns.Count - 1 do
    try
      if FVarFieldList.IsOfUnknownType(j) then
        continue;
      V1 := FVarFieldList.VarValues[j];
      V2 := FTab.Rows[0].GetData(j);
      if Compare(V1, V2, FVarFieldList.Types[j]) <> 0 then
         Error(WrongValueInColumn(FTab.Columns[j].Name, C_AD_PhysRDBMSKinds[FRDBMSKind], VarToStr(V2),
               VarToStr(V1)));
    except
      on E: Exception do
        Error(ErrorOnCompareVal(FTab.Columns[j].Name, E.Message));
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysCMDTsHolder.TestCommandMacroDB2;
var
  iIndx: Integer;
  j:     TADMacroDataType;
  s:     String;

  procedure GetParamsArray;
  begin
    with FVarFieldList do begin
      Clear;
      CreateEmptyList(FTab.Columns.Count);
      SetField(Dates[0],    ftDate, 5);
      SetField(Floats[0],   ftFloat, 7);
      SetField(Integers[0], ftInteger, 9);
      SetField(Strings[0],  ftString, 16);
      SetField(Times[0],    ftTime, 14);
{$IFDEF AnyDAC_D6}
      SetField(VarSQLTimeStampCreate(TimeStamps[2]),
                            ftTimeStamp, 15);
{$ELSE}
      SetField(ADSQLTimeStampToDateTime(TimeStamps[2]),
                            ftDateTime, 15);
{$ENDIF}
    end;
  end;

begin
  DeleteFromSource;
  GetParamsArray;
  if Insert then
    for j := Low(TADMacroDataType) to High(TADMacroDataType) do begin
      iIndx := -10;
      case j of
      mdString:     iIndx := 16;
      mdIdentifier: iIndx := -1;
      mdInteger:    iIndx := 9;
      mdFloat:      iIndx := 7;
      mdDateTime:   iIndx := 15;
      mdDate:       iIndx := 5;
      mdTime:       iIndx := 14;
      end;
      s := GetMacrosString(j, iIndx);
      RunMacros(s, j, iIndx);
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysCMDTsHolder.TestCommandMacroMSAccess;
var
  iIndx: Integer;
  j:     TADMacroDataType;
  s:     String;

  procedure GetParamsArray;
  begin
    with FVarFieldList do begin
      Clear;
      CreateEmptyList(FTab.Columns.Count);
      SetField(Integers[0],  ftInteger, 2);
      SetField(Floats[0],    ftFloat, 3);
      SetField(Strings[0],   ftString, 6);
      SetField(DateTimes[2], ftDateTime, 8);
      SetField(Booleans[0],  ftBoolean, 10);
    end;
  end;

begin
  DeleteFromSource;
  GetParamsArray;
  if Insert then
    for j := Low(TADMacroDataType) to High(TADMacroDataType) do begin
      iIndx := -10;
      case j of
      mdString:     iIndx := 6;
      mdIdentifier: iIndx := -1;
      mdInteger:    iIndx := 2;
      mdBoolean:    iIndx := 10;
      mdFloat:      iIndx := 3;
      mdDateTime:   iIndx := 8;
      end;
      s := GetMacrosString(j, iIndx);
      RunMacros(s, j, iIndx);
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysCMDTsHolder.TestCommandMacroMSSQL;
var
  iIndx: Integer;
  j:     TADMacroDataType;
  s:     String;

  procedure GetParamsArray;
  begin
    with FVarFieldList do begin
      Clear;
      CreateEmptyList(FTab.Columns.Count);
      SetField(Booleans[0], ftBoolean, 2);
      SetField(Strings[0],  ftString, 3);
{$IFDEF AnyDAC_D6}
      SetField(VarSQLTimeStampCreate(DateTimes[2]),
                            ftTimeStamp, 4);
{$ELSE}
      SetField(DateTimes[2],ftDateTime, 4);
{$ENDIF}
      SetField(Floats[0],   ftFloat, 5);
      SetField(Integers[0], ftInteger, 7);
    end;
  end;

begin
  DeleteFromSource;
  GetParamsArray;
  if Insert then
    for j := Low(TADMacroDataType) to High(TADMacroDataType) do begin
      iIndx := -10;
      case j of
      mdString:     iIndx := 3;
      mdIdentifier: iIndx := -1;
      mdInteger:    iIndx := 7;
      mdBoolean:    iIndx := 2;
      mdFloat:      iIndx := 5;
      mdDateTime:   iIndx := 4;
      end;
      s := GetMacrosString(j, iIndx);
      RunMacros(s, j, iIndx);
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysCMDTsHolder.TestCommandMacroASA;
var
  iIndx: Integer;
  j:     TADMacroDataType;
  s:     String;

  procedure GetParamsArray;
  begin
    with FVarFieldList do begin
      Clear;
      CreateEmptyList(FTab.Columns.Count);
      SetField(Booleans[0], ftBoolean, 3);
      SetField(Strings[0],  ftString, 4);
{$IFDEF AnyDAC_D6}
      SetField(VarSQLTimeStampCreate(DateTimes[2]),
                            ftTimeStamp, 18);
{$ELSE}
      SetField(DateTimes[2],ftDateTime, 18);
{$ENDIF}
      SetField(Floats[0],   ftFloat, 8);
      SetField(Integers[0], ftInteger, 11);
    end;
  end;

begin
  DeleteFromSource;
  GetParamsArray;
  if Insert then
    for j := Low(TADMacroDataType) to High(TADMacroDataType) do begin
      iIndx := -10;
      case j of
      mdString:     iIndx := 4;
      mdIdentifier: iIndx := -1;
      mdInteger:    iIndx := 11;
      mdBoolean:    iIndx := 3;
      mdFloat:      iIndx := 8;
      mdDateTime:   iIndx := 18;
      end;
      s := GetMacrosString(j, iIndx);
      RunMacros(s, j, iIndx);
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysCMDTsHolder.TestCommandMacroMySQL;
var
  iIndx: Integer;
  j:     TADMacroDataType;
  s:     String;

  procedure GetParamsArray;
  begin
    with FVarFieldList do begin
      Clear;
      CreateEmptyList(FTab.Columns.Count);
      SetField(Booleans[0], ftBoolean, 2);
      SetField(Integers[0], ftInteger, 4);
      SetField(Floats[0],   ftFloat, 8);
      SetField(Strings[0],  ftString, 13);
      SetField(Dates[0],    ftDate, 15);
      SetField(Times[0],    ftTime, 16);
{$IFDEF AnyDAC_D6}
      SetField(VarSQLTimeStampCreate(TimeStamps[0]),
                            ftTimeStamp, 19);
{$ELSE}
      SetField(ADSQLTimeStampToDateTime(TimeStamps[0]),
                            ftDateTime, 19);
{$ENDIF}
    end;
  end;

begin
  DeleteFromSource;
  GetParamsArray;
  if Insert then
    for j := Low(TADMacroDataType) to High(TADMacroDataType) do begin
      iIndx := -10;
      case j of
      mdString:     iIndx := 13;
      mdIdentifier: iIndx := -1;
      mdInteger:    iIndx := 4;
      mdBoolean:    iIndx := 2;
      mdFloat:      iIndx := 8;
      mdDate:       iIndx := 15;
      mdTime:       iIndx := 16;
      mdDateTime:   iIndx := 19;
      end;
      s := GetMacrosString(j, iIndx);
      RunMacros(s, j, iIndx);
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysCMDTsHolder.TestCommandMacroOra;
var
  iIndx: Integer;
  j:     TADMacroDataType;
  s:     String;

  procedure GetParamsArray;
  begin
    with FVarFieldList do begin
      Clear;
      CreateEmptyList(FTab.Columns.Count);
      SetField(Strings[0],                           ftString, 1);
{$IFDEF AnyDAC_D6}
      SetField(VarFMTBcdCreate('10', 10, 0),         ftFMTBcd, 2);
{$ELSE}
      SetField(StrToCurr('10'),                      ftBcd, 2);
{$ENDIF}
      SetField(Floats[0],                            ftFloat, 3);
{$IFDEF AnyDAC_D6}
      SetField(VarSQLTimeStampCreate(DateTimes[2]),  ftTimeStamp, 6);
{$ELSE}
      SetField(DateTimes[2],                         ftDateTime, 6);
{$ENDIF}
    end;
  end;

begin
  DeleteFromSource;
  GetParamsArray;
  if Insert then
    for j := Low(TADMacroDataType) to High(TADMacroDataType) do begin
      iIndx := -10;
      case j of
      mdString:     iIndx := 1;
      mdIdentifier: iIndx := -1;
      mdInteger:    iIndx := 2;
      mdFloat:      iIndx := 3;
      mdDate:       iIndx := 6;
      mdTime:       iIndx := 6;
      mdDateTime:   iIndx := 6;
      end;
      s := GetMacrosString(j, iIndx);
      RunMacros(s, j, iIndx);
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysCMDTsHolder.TestMapping;
var
  i, j: Integer;
  v:    Variant;
  eTarget, eSource: TADDataType;
  oTab:    TADDatSTable;
  eType:   TFieldType;
  sSource,
  sTarget: String;

  procedure SetMapRule(APrecMax, APrecMin, AScaleMax, AScaleMin: Integer;
                       ATargetDataType, ASourceDataType: TADDataType);
  begin
    with FCommIntf.Options.FormatOptions.MapRules.Add do begin
      PrecMax  := APrecMax;
      PrecMin  := APrecMin;
      ScaleMax := AScaleMax;
      ScaleMin := AScaleMin;
      TargetDataType := ATargetDataType;
      SourceDataType := ASourceDataType;
    end;
  end;

  procedure DeleteFromNumbers;
  begin
    with FCommIntf do begin
      Prepare('delete from {id ADQA_Numbers}');
      try
        Execute;
      finally
        CommandKind := skUnknown;
      end;
    end;
  end;

begin
  oTab := FDatSManager.Tables.Add;
  with FCommIntf do
  try
    Options.FormatOptions.OwnMapRules := True;
    Prepare('select * from {id ADQA_Numbers}');
    try
      Define(FTab);
    finally
      CommandKind := skUnknown;
    end;
    for i := 0 to FTab.Columns.Count - 1 do begin
      if AnsiCompareText(FTab.Columns[i].Name, 'dtBoolean') = 0 then
        continue;
      for eTarget := Low(TADDataType) to High(TADDataType) do
        with Options.FormatOptions do begin
          MapRules.Clear;

          case eTarget of
          dtUnknown,
          dtDateTime..dtObject:
            continue;
          end;

          if (i = 0) and (eTarget = dtBoolean) and (FRDBMSKind in [mkOracle, mkDB2]) then
            for j := 0 to 1 do begin // check mapping FmtBCD (NUMBER(2,0)) to dtBoolean
              DeleteFromNumbers;

              Prepare('insert into {id ADQA_Numbers}(dtBoolean) values(' + IntToStr(j) + ')');
              Execute;

              sSource := 'dtFmtBCD';
              sTarget := 'dtBoolean';
              SetMapRule(2, 0, 0, 0, dtBoolean, dtFmtBCD);

              Prepare('select dtBoolean from {id ADQA_Numbers}');
              try
                Define(oTab);
                try
                  Open;
                  Fetch(oTab);
                except
                  on E: Exception do begin
                    Error(ErrorOnMappingInsert(sSource, sTarget, E.Message));
                    continue;
                  end;
                end;
              finally
                CommandKind := skUnknown;
              end;

              if Compare(Integer(Boolean(j)), VarAsType(oTab.Rows[0].GetData(0), varInteger)) <> 0 then
                Error(WrongMappingInsert(sSource, sTarget, VarToStr(Boolean(j)),
                      VarToStr(oTab.Rows[0].GetData(0))));
              oTab.Clear;
              MapRules.Clear;
            end;

          if eTarget = dtBoolean then
            continue;

          eSource := DataTypeByName[FTab.Columns[i].Name];
          case eSource of  // source type
          dtByte, dtSByte:
            case eTarget of
            dtByte,
            dtSByte:
              continue;
            else
              begin
{$IFDEF AnyDAC_D6}
                if eTarget = dtFmtBCD then
                  v := VarFMTBcdCreate(111.0)
                else
{$ENDIF}
                  v := 111;
                SetMapRule(3, 0, 0, 0, eTarget, eSource);
              end;
            end;
          dtInt16, dtUInt16:
            case eTarget of
            dtByte,
            dtSByte,
            dtInt16,
            dtUInt16:
              continue;
            else
              begin
{$IFDEF AnyDAC_D6}
                if eTarget = dtFmtBCD then
                  v := VarFMTBcdCreate(6553.0)
                else
{$ENDIF}
                  v := 6553;
                SetMapRule(5, 4, 0, 0, eTarget, eSource);
              end;
            end;
          dtInt32, dtUInt32:
            case eTarget of
            dtByte,
            dtSByte,
            dtInt16,
            dtInt32,
            dtUInt16,
            dtUInt32:
              continue;
            else
              begin
{$IFDEF AnyDAC_D6}
                if eTarget = dtFmtBCD then
                  v := VarFMTBcdCreate(2147489.0)
                else
{$ENDIF}
                  v := 2147489;
                SetMapRule(10, 6, 0, 0, eTarget, eSource);
              end;
            end;
          dtInt64, dtUInt64:
            case eTarget of
            dtByte,
            dtSByte,
            dtInt16,
            dtInt32,
            dtInt64,
            dtUInt16,
            dtUInt32,
            dtUInt64:
              continue;
            else
              begin
{$IFDEF AnyDAC_D6}
                if eTarget = dtFmtBCD then
                  v := VarFMTBcdCreate(2147488.0)
                else
                  v := Int64(2147488);
{$ELSE}
                  v := 2147488;
{$ENDIF}
                SetMapRule(19, 6, 0, 0, eTarget, eSource);
              end;
            end;
          dtDouble:
            case eTarget of
            dtByte,
            dtSByte,
            dtInt16,
            dtInt32,
            dtUInt16,
            dtUInt32,
            dtDouble:
              continue;
            dtInt64,  dtUInt64:
              begin
{$IFDEF AnyDAC_D6}
                if eTarget = dtFmtBCD then
                  v := VarFMTBcdCreate(3456789012.343445)
                else
                  v := Int64(2348831218);
{$ELSE}
                TVarData(v).VType := varInt64;
                Decimal(v).Lo64 := 2348831218;
{$ENDIF}
                SetMapRule(16, 13, 0, 0, eTarget, eSource);
              end;
            else
              begin
                SetMapRule(16, 13, 6, 4, eTarget, eSource);
                v := 3456789012.3434;
              end;
            end;
          dtCurrency:
            case eTarget of
            dtByte,
            dtSByte,
            dtInt16,
            dtInt32,
            dtUInt16,
            dtUInt32,
            dtCurrency:
              continue;
            dtInt64,  dtUInt64:
              begin
                SetMapRule(20, 19, 4, 4, eTarget, eSource);
{$IFDEF AnyDAC_D6}
                v := Int64(2348514218);
{$ELSE}
                TVarData(v).VType := varInt64;
                Decimal(v).Lo64 := 2348514218;
{$ENDIF}
              end;
            else
              begin
{$IFDEF AnyDAC_D6}
                if eTarget = dtFmtBCD then
                  v := VarFMTBcdCreate(3456789012.3434)
                else
{$ENDIF}
                  v := 3456789012.3434;
                SetMapRule(20, 19, 4, 4, eTarget, eSource);
              end;
            end;
          dtBCD:
            case eTarget of
            dtByte,
            dtSByte,
            dtInt16,
            dtInt32,
            dtUInt16,
            dtUInt32,
            dtBCD:
              continue;
            dtInt64,  dtUInt64:
              begin
                SetMapRule(20, 19, 4, 4, eTarget, eSource);
{$IFDEF AnyDAC_D6}
                v := Int64(2348581218);
{$ELSE}
                TVarData(v).VType := varInt64;
                Decimal(v).Lo64 := 2348581218;
{$ENDIF}
              end;
            else
              begin
{$IFDEF AnyDAC_D6}
                if eTarget = dtFmtBCD then
                  v := VarFMTBcdCreate(3456789012.3434)
                else
{$ENDIF}
                  v := 3456789012.3434;
                SetMapRule(20, 19, 4, 4, eTarget, eSource);
              end;
            end;
          dtFmtBCD:
            case eTarget of
            dtByte,
            dtSByte,
            dtInt16,
            dtInt32,
            dtUInt16,
            dtUInt32,
            dtFmtBCD:
              continue;
            dtInt64,
            dtUInt64:
              begin
                SetMapRule(18, 0, 4, 4, eTarget, eSource);
{$IFDEF AnyDAC_D6}
                v := Int64(2348514831218);
{$ELSE}
                TVarData(v).VType := varInt64;
                Decimal(v).Lo64 := 2348514831218;
{$ENDIF}
              end;
            else
              begin
                SetMapRule(18, 0, 4, 4, eTarget, eSource);
                v := 3456789012.3434;
              end;
            end;
          end;

          try
            DeleteFromNumbers;
          except
            on E: Exception do
              Error(E.Message);
          end;

          CommandText := 'insert into {id ADQA_Numbers}(' + FTab.Columns[i].Name +
                         ') values(:' + FTab.Columns[i].Name + ')';
          Params[0].ADDataType := eTarget;
          Params[0].Value := v;

          eType   := Params[0].DataType;
          sTarget := ADDataTypesNames[eTarget];
          sSource := FTab.Columns[i].Name;
          try
            try
              Execute;
            except
              on E: Exception do begin
                Error(ErrorOnMappingInsert(sSource, sTarget, E.Message));
                continue;
              end;
            end
          finally
            Unprepare;
            CommandKind := skUnknown;
          end;

          Prepare('select ' + FTab.Columns[i].Name + ' from {id ADQA_Numbers}');
          try
            Define(oTab);
            Open;
            Fetch(oTab);
          finally
            CommandKind := skUnknown;
          end;

          if Compare(oTab.Rows[0].GetData(0), v, eType) <> 0 then
            Error(WrongMappingInsert(sSource, sTarget, VarToStr(v),
                  VarToStr(oTab.Rows[0].GetData(0))));

          oTab.Clear;
        end;
    end;
  finally
    Options.FormatOptions.MapRules.Clear;
    Options.FormatOptions.OwnMapRules := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysCMDTsHolder.TestMappingStrings;
var
  sTestString:     AnsiString;
  sTestWideString: WideString;
  i: Integer;
begin
  sTestString := '';
  for i := 1 to 300 do
    sTestString := sTestString + 'a';
  with FCommIntf do
  try
    Prepare('delete from {id ADQA_WString}');
    Execute;

    Options.FormatOptions.OwnMapRules := True;
    with Options.FormatOptions.MapRules.Add do begin
      SizeMax := 4000;
      SizeMin := 0;
      SourceDataType := dtWideString;
      TargetDataType := dtAnsiString;
    end;
    CommandText := 'insert into {id ADQA_WString}(widestring) values(:widestring)';
    Params[0].AsString := sTestString;
    try
      try
        Execute;
      except
        on E: Exception do begin
          Error(ErrorOnMappingInsert('dtWideString', 'dtAnsiString', E.Message));
          Exit;
        end;
      end
    finally
      Unprepare;
      CommandKind := skUnknown;
    end;

    Prepare('select widestring from {id ADQA_WString}');
    try
      Define(FTab);
      Open;
      Fetch(FTab);
    finally
      CommandKind := skUnknown;
    end;

    sTestWideString := FTab.Rows[0].GetData(0);
    if Compare(sTestString, sTestWideString, ftWideString) <> 0 then
      Error(WrongMappingInsert('dtWideString', 'dtAnsiString', sTestString,
            sTestWideString));
  finally
    Options.FormatOptions.MapRules.Clear;
    Options.FormatOptions.OwnMapRules := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysCMDTsHolder.TestParamBindMode;
var
  j:      TADParamBindMode;
  i:      Integer;
  V1, V2: Variant;
begin
  for j := Low(TADParamBindMode) to High(TADParamBindMode) do
    with FCommIntf do begin
      Prepare('delete from {id ADQA_ParamBind}');
      Execute;

      ParamBindMode := j;
      CommandText := 'insert into {id ADQA_ParamBind}(p1, p2, p3, p4) ' +
                     'values(:p1, :p2, :p1, :p4)';
      CheckCommandState(csInactive, FCommIntf);
      if (j = pbByName) then begin
        if (FRDBMSKind = mkOracle) and (Params.Count <> 3) or
           (FRDBMSKind <> mkOracle) and (Params.Count <> 4) then begin
          if FRDBMSKind = mkOracle then
            Error(WrongParCount(Params.Count, 3) + '. [pbByName]')
          else
            Error(WrongParCount(Params.Count, 4) + '. [pbByName]');
          CommandText := '';
          CommandKind := skUnknown;
          continue;
        end;
        with Params do begin
          ParamByName('p1').AsString := 'str0';
          ParamByName('p2').AsString := 'str1';
          ParamByName('p4').AsString := 'str2';
        end;
        Prepare;
        Execute;

        Prepare('select * from {id ADQA_ParamBind}');
        Define(FTab);
        Open;
        CheckCommandState(csOpen, FCommIntf);
        Fetch(FTab);

        for i := 0 to 3 do begin
          V1 := FTab.Rows[0].GetData(i);
          if i in [0, 1] then
            V2 := 'str' + IntToStr(i)
          else if i = 2 then
            V2 := 'str0'
          else
            V2 := 'str2';
          if AnsiCompareText(V1, V2) <> 0 then
            Error(ParBindMode(ParamBindModes[j], VarToStr(V2), VarToStr(V1)));
        end;
      end
      else begin
        if (Params.Count <> 4) then begin
          Error(WrongParCount(Params.Count, 4) + '. [pbByNumber]');
          continue;
        end;
        if Params[0].Name <> Params[2].Name then
          Error(WrongParamName(Params[2].Name, Params[0].Name));
        for i := 0 to 3 do
          Params[i].AsString := 'str' + IntToStr(i);
        Prepare;
        try
          Execute;
        except
          on E: Exception do begin
            Error(E.Message);
            Exit;
          end;
        end;

        Prepare('select * from {id ADQA_ParamBind}');
        Define(FTab);
        Open;
        CheckCommandState(csOpen, FCommIntf);
        Fetch(FTab);

        for i := 0 to 3 do begin
          V1 := FTab.Rows[0].GetData(i);
          V2 := 'str' + IntToStr(i);
          if AnsiCompareText(V1, V2) <> 0 then
            Error(ParBindMode(ParamBindModes[j], VarToStr(V2), VarToStr(V1)));
        end;
      end;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysCMDTsHolder.TestCommandBatchExec;
const
  C_ARR_SIZE = 3000;
var
  i, j, k: Integer;
  V:       Variant;
{$IFNDEF AnyDAC_D6}
  l: Integer;
{$ENDIF}
begin
  GetParamsArray;
  with FCommIntf, FVarFieldList do begin
    Prepare('delete from {id ADQA_All_types}');
    Execute;

    CommandText := GetInsertString;
    CheckCommandState(csInactive, FCommIntf);
    k := -1;
    for i := 0 to FVarFieldList.Count - 1 do
      if not IsOfUnknownType(i) then begin
        Inc(k);
        Params[k].DataType := Types[i];
        Params[k].Size     := Sizes[i];
      end;

    Params.ArraySize := C_ARR_SIZE;
    Prepare;
    CheckCommandState(csPrepared, FCommIntf);

    FConnIntf.TxBegin;
    try
      for i := 0 to C_ARR_SIZE - 1 do begin
        k := -1;
        for j := 0 to FVarFieldList.Count - 1 do
          if not IsOfUnknownType(j) then begin
            Inc(k);
            case Types[j] of
            ftString:     Params[k].AsStrings[i]       := VarValues[j];
            ftSmallint:   Params[k].AsSmallInts[i]     := VarValues[j];
            ftInteger:    Params[k].AsIntegers[i]      := VarValues[j];
            ftBCD:        Params[k].AsBCDs[i]          := VarValues[j];
{$IFDEF AnyDAC_D6}
            ftTimeStamp:  Params[k].AsSQLTimeStamps[i] := VarToSQLTimeStamp(VarValues[j]);
{$ENDIF}
            ftDate:       Params[k].AsDates[i]         := VarValues[j];
            ftTime:       Params[k].AsTimes[i]         := VarValues[j];
            ftDateTime:   Params[k].AsDateTimes[i]     := VarValues[j];
            ftMemo:       Params[k].AsMemos[i]         := VarValues[j];
            ftBoolean:    Params[k].AsBooleans[i]      := VarValues[j];
            ftCurrency:   Params[k].AsCurrencys[i]     := VarValues[j];
            ftBlob:       Params[k].AsBlobs[i]         := VarValues[j];
            ftFloat:      Params[k].AsFloats[i]        := VarValues[j];
            ftBytes:      Params[k].AsBytes[i]         := VarValues[j];
            ftVarBytes:   Params[k].AsVarBytes[i]      := VarValues[j];
            ftFixedChar:  Params[k].AsStrings[i]       := VarValues[j];
{$IFDEF AnyDAC_D6}
            ftLargeint:   Params[k].AsLargeInts[i]     := VarValues[j];
{$ELSE}
            ftLargeint:
              begin
                v := VarValues[j];
                if TVarData(v).VType = varInt64 then
                  Params[k].AsLargeInts[i] := Decimal(v).lo64
                else begin
                  l := VarValues[j];
                  Params[k].AsLargeInts[i] := l;
                end;
              end;
{$ENDIF}
            ftWideString: Params[k].AsWideStrings[i]   := VarValues[j];
            ftOraBlob:    Params[k].AsBlobs[i]         := VarValues[j];
            ftOraClob:    Params[k].AsMemos[i]         := VarValues[j];
{$IFDEF AnyDAC_D6}
            ftFMTBcd:     Params[k].AsFMTBCDs[i]       := VarToBcd(VarValues[j]);
{$ENDIF}            
            ftGuid:       Params[k].AsGUIDs[i]         := StringToGUID(VarValues[j]);
            ftFmtMemo:    Params[k].AsWideMemos[i]     := VarValues[j];
            else
              ASSERT(False);
            end;
          end;
      end;

      Execute(C_ARR_SIZE, 0);
      if RowsAffected <> C_ARR_SIZE then begin
        Error(WrongBatchInsertCount);
        Exit;
      end;
      FConnIntf.TxCommit;
    except
      on E: Exception do begin
        FConnIntf.TxRollback;
        Error(ErrorBatchExec(E.Message));
        Exit;
      end;
    end;
    if FConnIntf.TxIsActive then
      Error(TransIsActive);
    CommandKind := skUnknown;

    FDatSManager.Reset;
    FTab := FDatSManager.Tables.Add;
    Prepare('select * from {id ADQA_All_types}');
    Define(FTab);
    Fetch(FTab);

    if FTab.Rows.Count <> C_ARR_SIZE then begin
      Error(WrongBatchInsertCount);
      Exit;
    end;
    for i := 0 to C_ARR_SIZE - 1 do
      for j := 0 to FTab.Columns.Count - 1 do
        if not IsOfUnknownType(j) then begin
          V := FTab.Rows[i].GetData(j);
          if Compare(V, VarValues[j], Types[j]) <> 0 then begin
            if i > 0 then
              Exit;
            Error(WrongBatchInserting(FTab.Columns[j].Name, VarToStr(V),
                  VarToStr(VarValues[j])));
          end;
        end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysCMDTsHolder.TestCommandBatchExecAffect;
var
  i: Integer;
  V: Variant;
  oConnMeta: IADPhysConnectionMetadata;

  procedure DoError(AMess: String);
  begin
    Error(AMess);
    FConnIntf.TxRollback;
    if FConnIntf.TxIsActive then
      Error(TransIsActive);
  end;

begin
  FConnIntf.CreateMetadata(oConnMeta);
  with FCommIntf do begin
    Prepare('delete from {id ADQA_TabWithPK}');
    Execute;

    CommandText := 'insert into {id ADQA_TabWithPK}(f1) values(:f1)';
    Params[0].DataType := ftInteger;

    Params.ArraySize := 100;
    Prepare;

    FConnIntf.TxBegin;
    try
      for i := 0 to 100 - 1 do
        if i = 50 then
          Params[0].AsIntegers[i] := 50 - 1
        else
          Params[0].AsIntegers[i] := i;

      Execute(100, 0);
      FConnIntf.TxCommit;
      if FConnIntf.TxIsActive then
        Error(TransIsActive);
    except
      on E: Exception do begin
        if (oConnMeta.Kind = mkMSSQL) and (RowsAffected <> 99) and
          (EADDBEngineException(E).Errors[0].RowIndex <> 50) then begin
          DoError(ErrorBatchAffect(FCommIntf.RowsAffected, 99));
          Exit;
        end
        else if (oConnMeta.Kind <> mkMSSQL) and (RowsAffected <> 50) then begin
          DoError(ErrorBatchAffect(FCommIntf.RowsAffected, 50));
          Exit;
        end
        else begin
          try
            if oConnMeta.Kind <> mkMSSQL then begin
              Params[0].AsIntegers[RowsAffected] := 50;
              Execute(100, RowsAffected);
            end
            else begin
              Disconnect;
              CommandText := 'insert into {id ADQA_TabWithPK}(f1) values(:f1)';
              Params.ArraySize := 1;
              Params[0].AsInteger := 50;
              Prepare;
              Execute;
            end;
          except
            on E: Exception do begin
              DoError(E.Message);
              Exit;
            end;
          end;
        end;
      end;
    end;
    CommandKind := skUnknown;

    FDatSManager.Reset;
    FTab := FDatSManager.Tables.Add;
    Prepare('select * from {id ADQA_TabWithPK}');
    Define(FTab);
    Fetch(FTab);

    if FTab.Rows.Count <> 100 then
      Error(WrongBatchInsertCount);
    for i := 0 to 100 - 1 do begin
      V := FTab.Rows[i].GetData(0);
      if Compare(V, i, ftInteger) <> 0 then begin
        if i > 0 then
          Exit;
        Error(WrongBatchInserting('', VarToStr(V), VarToStr(i)));
      end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysCMDTsHolder.TestReadWriteBlob;
var
  pInData:  Pointer;
  iCurLen:  Integer;

  procedure AllocMemory;
  var
    i: Integer;
    iByte: Byte;
  begin
    GetMem(pInData, iCurLen);
    iByte := 1;
    for i := 0 to iCurLen - 1 do begin
      (PChar(pInData) + i)^ := Chr(iByte);
      Inc(iByte);
      if iByte = 97 then
        iByte := 1;
    end;
  end;

  procedure FreeMemory;
  begin
    FreeMem(pInData);
  end;

  procedure DeleteData(const ATab: String);
  var
    oComm: IADPhysCommand;
  begin
    FConnIntf.CreateCommand(oComm);
    with oComm do begin
      CommandKind := skUnknown;
      Prepare('delete from {id ' + ATab + '}');
      Execute;
    end;
  end;

  function WriteData(const ATab: String; AType: TFieldType): Boolean;
  begin
    Result := True;
    with FCommIntf do begin
      CommandKind := skUnknown;
      CommandText := 'insert into {id ' + ATab + '}(blobdata) values(:p)';
      with Params[0] do begin
        DataType := AType;
        SetBlobRawData(iCurLen, PChar(pInData));
      end;
      Prepare;
      try
        Execute;
      except
        on E: Exception do begin
          Error(ErrorOnWriteBlobData(iCurLen, '{' + ATab + '} ' + E.Message));
          Result := False;
        end;
      end;
    end;
  end;

  function ReadData(const AField, ATab: String; AWithOrderBy: Boolean = True): Boolean;
  var
    oComm: IADPhysCommand;
    sOB: String;
  begin
    Result := True;
    FConnIntf.CreateCommand(oComm);
    FTab.Reset;
    with oComm do begin
      CommandKind := skUnknown;
      if AWithOrderBy then
        sOB := ' order by id'
      else
        sOB := '';
      Prepare(Format('select %s from {id %s}%s', [AField, ATab, sOB]));
      Define(FTab);
      Open;
      try
        Fetch(FTab, True);
      except
        on E: Exception do begin
          Error(E.Message);
          Result := False;
        end;
      end;
    end;
  end;

  function CompareData(const ATab: String; ARow, ABlobFieldId: Integer): Boolean;
  var
    S1, S2:     String;
    cWrongChar: Char;
    i:          Integer;
  begin
    Result := True;
    S1 := VarToStr(FTab.Rows[ARow].GetData(ABlobFieldId));
    if Length(S1) <> iCurLen then begin
      Result := False;
      Error(Format(WrongBlobDataMsg3, [Length(S1), iCurLen]));
      Exit;
    end;
    SetLength(S2, iCurLen);
    Move(PChar(pInData)^, PChar(S2)^, iCurLen);
    if Compare(S1, S2) <> 0 then begin
      Result := False;
      for i := 1 to iCurLen do
        if S1[i] <> S2[i] then begin
          cWrongChar := S1[i];
          if cWrongChar = #0 then
            cWrongChar := ' ';
          Error(WrongBlobData(String(cWrongChar), i, ATab));
          Exit;
        end;
    end;
  end;

  function DoTestingBlobData(const AField, ATab: String; AType: TFieldType; ARow, ABlobFieldId: Integer): Boolean;
  begin
    Result := False;
    AllocMemory;
    try
      DeleteData(ATab);
      if WriteData(ATab, AType) then
        if ReadData(AField, ATab) then
          Result := CompareData(ATab, ARow, ABlobFieldId);
    finally
      FreeMemory;
    end;
  end;

  procedure DoTestingFewRows(const AField, ATab: String; AType: TFieldType; ABlobFieldId: Integer);
  var
    i: Integer;
    pBuff: Pointer;
    iLen: LongWord;
    iTmpCurLen: Integer;
  begin
    iTmpCurLen := iCurLen;
    AllocMemory;
    try
      DeleteData(ATab);
      for i := 1 to 100 do begin
        if i mod 2 = 0 then
          iCurLen := 0
        else
          iCurLen := iTmpCurLen;
        WriteData(ATab, AType);
      end;
      iCurLen := iTmpCurLen;
      ReadData(AField, ATab);
      for i := 1 to 100 do
        if i mod 2 = 0 then begin
          if FTab.Rows[i - 1].GetData(ABlobFieldId, rvDefault, pBuff, iLen, iLen, False) then
            Error(WrongBlobDataMsg2);
        end
        else
          CompareData(ATab, i - 1, ABlobFieldId);
    finally
      FreeMemory;
    end;
  end;

  procedure DoTestingOutputBlob;
  var
    S1: String;
  begin
    AllocMemory;
    try
      DeleteData('ADQA_MaxLength');
      with FCommIntf do begin
        CommandText := 'ADQA_OutParam';
        CommandKind := skStoredProcNoCrs;
        Prepare;
        with Params[1] do begin
          DataType := ftMemo;
          SetBlobRawData(iCurLen, PChar(pInData));
        end;
        Execute;
        if Compare(Params[0].AsString, Strings[0]) <> 0 then
          Error(ErrorOnStorProcParam('ADQA_OutParam', Params[0].Name, Params[0].AsString, Strings[0]));
        ReadData('memos', 'ADQA_MaxLength', False);
        SetLength(S1, iCurLen);
        Move(PChar(pInData)^, S1[1], iCurLen);
        if Compare(FTab.Rows[0].GetData(0), S1) <> 0 then
          Error(WrongValueInTable('memos', 0, FTab.Rows[0].GetData(0), S1, 'ADQA_MaxLength'));
        S1 := S1 + 'abcde';
        if Compare(Params[1].AsMemo, S1) <> 0 then
          Error(ErrorOnStorProcParam('ADQA_OutParam', Params[1].Name, S1, Params[1].AsMemo));
      end;
    finally
      FreeMemory;
    end;
  end;

begin
  with FCommIntf.Options.FetchOptions do begin
    Mode := fmAll;
    Items := Items + [fiBlobs];
  end;

  iCurLen := 0;
  DoTestingBlobData('*', 'ADQA_Blob', ftBlob, 0, 1);

  if FRDBMSKind = mkOracle then begin
    for iCurLen := 3900 to 4100 do
      if not DoTestingBlobData('*', 'ADQA_Blob', ftOraBlob, 0, 1) then
        break;

    iCurLen := 8000;
    DoTestingOutputBlob;

    for iCurLen := 4001 to 4002 do
      if not DoTestingBlobData('*', 'ADQA_Clob', ftOraClob, 0, 1) then
        break;
  end
  else begin
    iCurLen := 4000000;
    DoTestingBlobData('*', 'ADQA_Blob', ftBlob, 0, 1);

    iCurLen := 1000;
    DoTestingFewRows('*', 'ADQA_Blob', ftBlob, 1);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysCMDTsHolder.TestSeveralCursors;
var
  oComm: IADPhysCommand;
  oTab:  TADDatSTable;
  oConnMeta: IADPhysConnectionMetadata;
begin
  FConnIntf.CreateCommand(oComm);
  FConnIntf.CreateMetadata(oConnMeta);
  oTab := FDatSManager.Tables.Add;
  if oConnMeta.Kind in [mkMSAccess, mkMSSQL] then
    FConnIntf.TxOptions.Isolation := xiDirtyRead
  else
    FConnIntf.TxOptions.Isolation := xiReadCommitted;
  FConnIntf.TxBegin;
  if not FConnIntf.TxIsActive then
    Error(TransIsInactive);
  try
    with FCommIntf do begin
      with Options.FetchOptions do begin
        Mode := fmOnDemand;
        RowsetSize := 10;
      end;
      Prepare('select * from {id Order Details}');
      Define(FTab);
      Open;
      CheckCommandState(csOpen, FCommIntf);
      Fetch(FTab, False);
    end;
    FConnIntf.TxCommit;
    if FConnIntf.TxIsActive then
      Error(TransIsActive);
  except
    FConnIntf.TxRollback;
    if FConnIntf.TxIsActive then
      Error(TransIsActive);
  end;
  CheckRowsCount(FTab, 10);
  FConnIntf.TxBegin;
  if not FConnIntf.TxIsActive then
    Error(TransIsInactive);
  try
    with oComm do begin
      with Options.FetchOptions do begin
        Mode := fmOnDemand;
        RowsetSize := 20;
      end;
      Prepare('select * from {id Order Details}');
      Define(oTab);
      Open;
      try
        Fetch(oTab, False);
      except
        on E: Exception do
          Error(E.Message);
      end;
    end;
    FConnIntf.TxCommit;
    if FConnIntf.TxIsActive then
      Error(TransIsActive);
  except
    FConnIntf.TxRollback;
    if FConnIntf.TxIsActive then
      Error(TransIsActive);
  end;
  CheckRowsCount(oTab, 20);
  FCommIntf.Fetch(FTab, False);
  CheckRowsCount(FTab, 20);
  oComm.Fetch(oTab, False);
  CheckRowsCount(oTab, 40);
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysCMDTsHolder.TestStringsBorderLength;
var
  i, j, iField, iFieldNum: Integer;
  s, sTabName: String;
  w: WideString;
  V1: Variant;

  function GetInsString(AField: Integer): String;
  var
    sFld: String;
  begin
    Result := 'insert into {id ' + sTabName + '}(';
    case AField of
    0: sFld := 'str';
    1: sFld := 'memos';
    2: sFld := 'widestr';
    3: sFld := 'blobs';
    end;
    Result := Result + sFld + ') values(:S)';
  end;

  procedure RefetchData;
  begin
    with FCommIntf do begin
      Prepare('select * from {id ' + sTabName + '}');
      Define(FTab);
      Open;
      Fetch(FTab);
    end;
  end;

  procedure DefineTab;
  begin
    with FCommIntf do begin
      Prepare('select * from {id ' + sTabName + '}');
      Define(FTab);
    end;
  end;

  procedure Delete;
  begin
    with FCommIntf do begin
      Prepare('delete from {id ' + sTabName + '}');
      Execute;
    end;
  end;

begin
  for iField := 0 to 3 do
    for i := Low(BorderLength[FRDBMSKind]) to High(BorderLength[FRDBMSKind]) do begin
      s := '';
      w := '';

      if (iField in [0, 2]) and (i > 1) then
        continue;

      case FRDBMSKind of
      mkMSAccess:
        if iField = 2 then
          if BorderLength[FRDBMSKind, i] > 255 then continue;
      mkMSSQL:
        case iField of
        1: if BorderLength[FRDBMSKind, i] > 8000 then continue;
        2: if BorderLength[FRDBMSKind, i] > 4000 then continue;
        end;
      mkOracle:
        case iField of
        1: if BorderLength[FRDBMSKind, i] > 4001 then continue;
        2: if BorderLength[FRDBMSKind, i] > 2000 then continue;
        end;
      end;

      if FRDBMSKind <> mkMSSQL then begin
        sTabName  := 'ADQA_MaxLength';
        iFieldNum := iField;
      end
      else begin
        iFieldNum := 0;
        case iField of
        0: sTabName := 'ADQA_MaxLength';
        1: sTabName := 'ADQA_MaxLengthVarchar';
        2: sTabName := 'ADQA_MaxLengthNVarchar';
        3:
          begin
            sTabName  := 'ADQA_MaxLength';
            iFieldNum := 1;
          end;
        end;
      end;

      if BorderLength[FRDBMSKind, i] = 0 then
        continue;

      for j := 1 to BorderLength[FRDBMSKind, i] do
        if iField = 2 then
          w := w + 'w'
        else
          s := s + 's';

      Delete;
      DefineTab;
      with FCommIntf do begin
        CommandText := GetInsString(iField);
        case iField of
        0: Params[0].AsString     := s;
        1: Params[0].AsMemo       := s;
        2: Params[0].AsWideString := w;
        3: Params[0].AsBlob       := s;
        end;
        Prepare;
        try
          Execute;
        except
          on E: Exception do begin
            Error(ErrBorderLength(BorderLength[FRDBMSKind, i],
                                  FTab.Columns[iFieldNum].Name, E.Message));
            break;
          end;
        end;
      end;
      RefetchData;
      V1 := VarToValue(FTab.Rows[0].GetData(iFieldNum), '');
      if iField = 2 then begin
{$IFDEF AnyDAC_D6}
        if WideCompareStr(V1, w) <> 0 then
{$ELSE}
        if Compare(V1, w) <> 0 then
{$ENDIF}
          Error(WrongWithBorderLength(FTab.Columns[iFieldNum].Name,
                                      BorderLength[FRDBMSKind, i], V1, w));
        continue;
      end;
      if Compare(V1, s) <> 0 then
          Error(WrongWithBorderLength(FTab.Columns[iFieldNum].Name,
                                      BorderLength[FRDBMSKind, i], V1, s));
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysCMDTsHolder.TestCommandDefineDB2;
var
  eDataType: TADDataType;
  j:         Integer;
  sType,
  sRealType: string;
  lError:    Boolean;
begin
  for j := 0 to FTab.Columns.Count - 1 do
    with FTab.Columns[j] do begin
      sType := AnsiUpperCase(Copy(Name, 2, Length(Name)));
      eDataType := DataType;
      sRealType := ADDataTypesNames[DataType];
      lError := False;

      if sType = _BIGINT then
        if not(eDataType in [dtInt64]) then
          lError := True;
      if sType = _DECIMAL then
        if not(eDataType in [dtBCD, dtFmtBCD]) then
          lError := True;
      if sType = _SMALLINT then
        if eDataType <> dtInt16 then
          lError := True;
      if (sType = _CHARACTER) or (sType = _VARCHAR) then
        if eDataType <> dtAnsiString then
          lError := True;
      if (sType = _GRAPHIC) or (sType = _VARGRAPHIC) then
        if eDataType <> dtWideString then
          lError := True;
      if sType = _BLOB then
        if eDataType <> dtBlob then
          lError := True;
      if sType = _CLOB then
        if not(eDataType in [dtMemo]) then
          lError := True;
      if sType = _DATALINK then
        if eDataType <> dtAnsiString then
          lError := True;
      if sType = _DBCLOB then
        if eDataType <> dtWideMemo then
          lError := True;
      if sType = _INTEGER then
        if eDataType <> dtInt32 then
          lError := True;
      if sType = _DATE then
        if eDataType <> dtDate then
          lError := True;
      if sType = _TIME then
        if eDataType <> dtTime then
          lError := True;
      if sType = _TIMESTAMP then
        if eDataType <> dtDateTimeStamp then
          lError := True;
      if (sType = _DOUBLE) or (sType = _REAL) then
        if not(eDataType in [dtDouble]) then
          lError := True;
      if sType = _LONGVARCHAR then
        if eDataType <> dtMemo then
          lError := True;
      if sType = _LONGVARGRAPHIC then
        if not (eDataType in [dtWideMemo]) then
          lError := True;
      if (sType = _CHAR_BIT) or (sType = _VARCHAR_BIT) then
        if eDataType <> dtByteString then
          lError := True;

      if lError then
        Error(DefineError(sType, sRealType, DB2_CONN));
   end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysCMDTsHolder.TestCommandDefineMSAccess;
var
  eDataType: TADDataType;
  j:         Integer;
  sType,
  sRealType: string;
  lError:    Boolean;
begin
  for j := 0 to FTab.Columns.Count - 1 do
    with FTab.Columns[j] do begin
      sType := AnsiUpperCase(Copy(Name, 2, Length(Name)));
      eDataType := DataType;
      sRealType := ADDataTypesNames[DataType];
      lError := False;

      if sType = _INT + '1' then
        if eDataType <> dtByte then
          lError := True;
      if sType = _INT + '2' then
        if eDataType <> dtInt16 then
          lError := True;
      if sType = _INT + '4' then
        if eDataType <> dtInt32 then
          lError := True;
      if sType = _CURRENCY then
        if eDataType <> dtCurrency then
          lError := True;
      if sType = _BIGINT then
        if not(eDataType in [dtBCD, dtFmtBCD]) then
          lError := True;
      if (sType = _SINGLE) or (sType = _DOUBLE) then
        if eDataType <> dtDouble then
          lError := True;
      if sType = _TEXT then
        if not(eDataType in [dtAnsiString, dtWideString]) then
          lError := True;
      if sType = _GUID then
        if eDataType <> dtGUID then
          lError := True;
      if sType = _BINARY then
        if eDataType <> dtByteString then
          lError := True;
      if sType = _MEMO then
        if not(eDataType in [dtMemo, dtWideMemo]) then
         lError := True;
      if sType = _DATETIME then
        if not(eDataType in [dtDateTime, dtDateTimeStamp]) then
          lError := True;
      if sType = _BOOLEAN then
        if eDataType <> dtBoolean then
          lError := True;
      if sType = _LONGBINARY then
        if eDataType <> dtBlob then
          lError := True;

      if lError then
        Error(DefineError(sType, sRealType, MSACCESS_CONN));
   end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysCMDTsHolder.TestCommandDefineMSSQL;
var
  eDataType: TADDataType;
  j:         Integer;
  sType,
  sRealType: string;
  lError:    Boolean;
begin
  for j := 0 to FTab.Columns.Count - 1 do
    with FTab.Columns[j] do begin
      sType := AnsiUpperCase(Copy(Name, 2, Length(Name)));
      eDataType := DataType;
      sRealType := ADDataTypesNames[DataType];
      lError := False;

      if sType = _INT then
        if eDataType <> dtInt32 then
          lError := True;
      if sType = _SMALLINT then
        if eDataType <> dtInt16 then
          lError := True;
      if sType = _TINYINT then
        if eDataType <> dtByte then
          lError := True;
      if (sType = _CHAR) or (sType = _VARCHAR) then
        if eDataType <> dtAnsiString then
          lError := True;
      if (sType = _NCHAR) or (sType = _NVARCHAR) then
        if eDataType <> dtWideString then
          lError := True;
      if (sType = _BIT) then
        if eDataType <> dtBoolean then
          lError := True;
      if (sType = _IMAGE) then
        if eDataType <> dtBlob then
          lError := True;
      if Pos(_DATETIME, sType) > 0 then
        if not(eDataType in [dtDateTime, dtDateTimeStamp]) then
          lError := True;
      if (Pos(_MONEY, sType) > 0) or (sType = _NUMERIC) then
        if not(eDataType in [dtBCD, dtFmtBCD, dtCurrency]) then
          lError := True;
      if (sType = _FLOAT) or (sType = _REAL) then
        if eDataType <> dtDouble then
          lError := True;
      if sType = _BIGINT then
        if eDataType <> dtInt64 then
          lError := True;
      if sType = _TEXT then
        if eDataType <> dtMemo then
          lError := True;
      if sType = _NTEXT then
        if eDataType <> dtWideMemo then
          lError := True;
      if (Pos(_BINARY, sType) > 0) or (sType = _TIMESTAMP) then
        if eDataType <> dtByteString then
          lError := True;
      if sType = _SQL_VARIANT then
        if eDataType <> dtByteString then
          lError := True;
      if sType = _UNIQUEIDENTIFIER then
        if eDataType <> dtGUID then
          lError := True;

      if lError then
        Error(DefineError(sType, sRealType, MSSQL_CONN));
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysCMDTsHolder.TestCommandDefineASA;
var
  eDataType: TADDataType;
  j:         Integer;
  sType,
  sRealType: string;
  lError:    Boolean;
begin
  for j := 0 to FTab.Columns.Count - 1 do
    with FTab.Columns[j] do begin
      sType := AnsiUpperCase(Copy(Name, 2, Length(Name)));
      eDataType := DataType;
      sRealType := ADDataTypesNames[DataType];
      lError := False;

      if sType = _INT then
        if eDataType <> dtInt32 then
          lError := True;
      if sType = _UINT then
        if eDataType <> dtUInt32 then
          lError := True;
      if sType = _SMALLINT then
        if eDataType <> dtInt16 then
          lError := True;
      if sType = _USMALLINT then
        if eDataType <> dtUInt16 then
          lError := True;
      if sType = _TINYINT then
        if eDataType <> dtSByte then
          lError := True;
      if (sType = _CHAR) or (sType = _VARCHAR) then
        if eDataType <> dtAnsiString then
          lError := True;
      if (sType = _BIT) then
        if eDataType <> dtBoolean then
          lError := True;
      if (sType = _LONGBINARY) then
        if eDataType <> dtBlob then
          lError := True;
      if sType = _TIMESTAMP then
        if not(eDataType in [dtDateTime, dtDateTimeStamp]) then
          lError := True;
      if sType = _DATE then
        if eDataType <> dtDate then
          lError := True;
      if sType = _TIME then
        if eDataType <> dtTime then
          lError := True;
      if sType = _NUMERIC then
        if not(eDataType in [dtBCD, dtFmtBCD]) then
          lError := True;
      if sType = _DECIMAL then
        if not(eDataType in [dtBCD, dtFmtBCD, dtCurrency]) then
          lError := True;
      if (sType = _FLOAT) or (sType = _REAL) or (sType = _DOUBLE) then
        if eDataType <> dtDouble then
          lError := True;
      if sType = _BIGINT then
        if eDataType <> dtInt64 then
          lError := True;
      if sType = _UBIGINT then
        if eDataType <> dtUInt64 then
          lError := True;
      if sType = _LONGVARCHAR then
        if eDataType <> dtMemo then
          lError := True;
      if (Pos(_BINARY, sType) > 0) and (sType <> _LONGBINARY) then
        if eDataType <> dtByteString then
          lError := True;

      if lError then
        Error(DefineError(sType, sRealType, ASA_CONN));
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysCMDTsHolder.TestCommandDefineMySQL;
var
  eDataType: TADDataType;
  j:         Integer;
  sType,
  sRealType: string;
  lError:    Boolean;
begin
  for j := 0 to FTab.Columns.Count - 1 do
    with FTab.Columns[j] do begin
      sType := AnsiUpperCase(Copy(Name, 2, Length(Name)));
      eDataType := DataType;
      sRealType := ADDataTypesNames[DataType];
      lError := False;

      if sType = _NUMERIC then
        if eDataType <> dtInt64 then
          lError := True;
      if sType = _DECIMAL then
        if not(eDataType in [dtBCD, dtFmtBCD]) then
          lError := True;
      if (sType = _BOOL) or (sType = _BIT)  then
        if not(eDataType in [dtInt16, dtSByte, dtBoolean]) then
          lError := True;
      if (sType = _INT) or (sType = _INTEGER) or (sType = _MEDIUMINT) then
        if eDataType <> dtInt32 then
          lError := True;
      if sType = _YEAR then
        if eDataType <> dtUInt16 then
          lError := True;
      if sType = _TINYINT then
        if not(eDataType in [dtInt16, dtSByte]) then
          lError := True;
      if sType = _BIGINT then
        if eDataType <> dtInt64 then
          lError := True;
      if (sType = _FLOAT) or (sType = _REAL) then
        if not(eDataType in [dtDouble]) then
          lError := True;
      if Pos(_BLOB, sType) > 0 then
        if not((eDataType = dtBlob) or (eDataType = dtByteString)) then
          lError := True;
      if Pos(_CHAR, sType) > 0 then
        if not(eDataType in [dtAnsiString]) then
          lError := True;
      if Pos(_TEXT, sType) > 0 then
        if not(eDataType in [dtMemo, dtAnsiString]) then
          lError := True;
      if (sType = _DATE) then
        if eDataType <> dtDate then
          lError := True;
      if sType = _TIME then
        if eDataType <> dtTime then
          lError := True;
      if sType = _DATETIME then
        if eDataType <> dtDateTime then
          lError := True;
      if sType = _TIMESTAMP then
        if eDataType <> dtDateTimeStamp then
          lError := True;
      if sType = _SET then
        if eDataType <> dtAnsiString then
          lError := True;
      if sType = _ENUM then
        if eDataType <> dtAnsiString then
          lError := True;

      if lError then
        Error(DefineError(sType, sRealType, MYSQL_CONN));
    end
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysCMDTsHolder.TestCommandDefineOra;
var
  eDataType: TADDataType;
  j:         Integer;
  sType,
  sRealType: string;
  lError:    Boolean;
begin
  for j := 0 to FTab.Columns.Count - 1 do
    with FTab.Columns[j] do begin
      sType := AnsiUpperCase(Copy(Name, 2, Length(Name)));
      eDataType := DataType;
      sRealType := ADDataTypesNames[DataType];
      lError := False;

      if (sType = _CHAR) or (sType = _VARCHAR2) then
        if not(eDataType in [dtAnsiString, dtMemo]) then
          lError := True;
      if (sType = _NCHAR) or (sType = _NVARCHAR2) then
        if not(eDataType in [dtWideString, dtWideMemo]) then
          lError := True;
      if sType = _FLOAT then
        if eDataType <> dtDouble then
          lError := True;
      if sType = _NUMBER then
        if not(eDataType in [dtBCD, dtFmtBCD]) then
          lError := True;
      if sType = _LONG then
        if eDataType <> dtMemo then
          lError := True;
      if sType = _DATE then
        if not(eDataType in [dtDateTime, dtDateTimeStamp]) then
          lError := True;
      if sType = _RAW then
        if eDataType <> dtByteString then
          lError := True;
      if sType = _ROWID then
        if eDataType <> dtAnsiString then
          lError := True;
      if sType = _BLOB then
        if eDataType <> dtHBlob then
          lError := True;
      if sType = _CLOB then
        if eDataType <> dtHMemo then
          lError := True;
      if sType = _NCLOB then
        if eDataType <> dtWideHMemo then
          lError := True;
      if sType = _UROWID then
        if eDataType <> dtAnsiString then
          lError := True;
      if sType = _BFILE then
        if eDataType <> dtHBFile then
          lError := True;

      if lError then
        Error(DefineError(sType, sRealType, ORACLE_CONN));
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysCMDTsHolder.TestCommandDefineSameCol;
begin
  with FCommIntf do begin
    FDatSManager.Reset;
    FTab := FDatSManager.Tables.Add;
    Prepare('select CategoryID, CategoryID as CID from {id Categories}');
    Define(FTab);
    if FTab.Columns.Count <> 2 then begin
      Error(Format('Base column number is [%d], but expected [%d]',
        [FTab.Columns.Count, 2]));
      Exit;
    end;
    if AnsiCompareText(FTab.Columns[0].Name, 'CategoryID') <> 0 then
      Error(Format('Column [0] name is [%s], but expected [%s]',
        [FTab.Columns[0].Name, 'CategoryID']));
    if AnsiCompareText(FTab.Columns[1].Name, 'CID') <> 0 then
      Error(Format('Column [1] name is [%s], but expected [%s]',
        [FTab.Columns[1].Name, 'CID']));
    if AnsiCompareText(FTab.Columns[0].SourceName, 'CategoryID') <> 0 then
      Error(Format('Column [0] source name is [%s], but expected [%s]',
        [FTab.Columns[0].SourceName, 'CategoryID']));
    if AnsiCompareText(FTab.Columns[1].SourceName, 'CategoryID') <> 0 then
      Error(Format('Column [1] source name is [%s], but expected [%s]',
        [FTab.Columns[1].SourceName, 'CategoryID']));

    FTab := FDatSManager.Tables.Add;
    Prepare('select count(*), count(*) from {id Categories}');
    Define(FTab);
    if FTab.Columns.Count <> 2 then begin
      Error(Format('Expression column number is [%d], but expected [%d]',
        [FTab.Columns.Count, 2]));
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysCMDTsHolder.TestNumericPrecision;

  procedure DeleteData;
  begin
    with FCommIntf do begin
      Prepare('delete from {id ADQA_OrderDetails}');
      Execute;
    end;
  end;

  procedure DefineParam(const AName: String; ADataType: TFieldType;
    ADataSize: Integer; AParamType: TParamType);
  var
    oPar: TADParam;
  begin
    oPar := FCommIntf.Params.ParamByName(AName);
{$IFDEF AnyDAC_D6}
    if ADataType = ftFloat then begin
      oPar.DataType := ftFMTBcd;
      oPar.NumericScale := 4;
      oPar.Precision := 14;
    end
    else if ADataType = ftDateTime then
      oPar.DataType := ftTimeStamp
    else
{$ENDIF}
      oPar.DataType := ADataType;
    oPar.ParamType := AParamType;
    oPar.ArraySize := 1;
  end;

var
  F1: Integer;
  F2: TDateTime;
  F3: Double;
  F4: Double;
  F5: Double;
  F6: Double;
  F7: String;
  j: Integer;
begin
  DeleteData;
  FCommIntf.CommandText := 'insert into ADQA_OrderDetails (OrderID, OnDate, ProductID, ' +
    ' UnitPrice, Quantity, Discount, Notes) values (:f1, :f2, :f3, :f4, :f5, :f6, :f7)';
  DefineParam('f1', ftFloat, -1, ptInput);
  DefineParam('f2', ftDateTime, -1, ptInput);
  DefineParam('f3', ftFloat, -1, ptInput);
  DefineParam('f4', ftFloat, -1, ptInput);
  DefineParam('f5', ftFloat, -1, ptInput);
  DefineParam('f6', ftFloat, -1, ptInput);
  DefineParam('f7', ftString, 100, ptInput);

  F1 := Integer(Random(1000));
  F2 := NOW();
  F3 := Random(9999999999);
{$IFDEF AnyDAC_D6}
  F4 := RoundTo(Random * Random(9999999999), -4);
{$ELSE}
  F4 := Random * Random(9999999999);
{$ENDIF}
  F5 := Random(9999);
  F6 := Random * Random(999);
  SetLength(F7, 50);
  for j := 1 to Length(F7) do
    F7[j] := Char(Ord('a') + Random(25));

  F1 := F1 + 1;
  FCommIntf.Params[0].Value := F1;
  FCommIntf.Params[1].Value := F2;
  FCommIntf.Params[2].Value := F3;
  FCommIntf.Params[3].Value := F4;
  FCommIntf.Params[4].Value := F5;
  FCommIntf.Params[5].Value := F6;
  FCommIntf.Params[6].Value := F7;

  FCommIntf.Execute;
  FCommIntf.Unprepare;
end;

initialization

  ADQAPackManager.RegisterPack('Phys Layer', TADQAPhysCMDTsHolder);

end.
