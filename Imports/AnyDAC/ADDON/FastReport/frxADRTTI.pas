
{******************************************}
{                                          }
{             FastReport v4.0              }
{          AD components RTTI              }
{                                          }
{                                          }
{                                          }
{                                          }
{******************************************}
{                                          }
{       Created by: Serega Glazyrin        }
{      E-mail: glserega@mezonplus.ru       }
{                                          }
{                                          }
{******************************************}

unit frxADRTTI;

interface

{$I frx.inc}

implementation

uses
  Windows, Classes, fs_iinterpreter, fs_idbrtti, frxADComponents,
  SysUtils, Forms, daADCompClient, daADCompDataset
{$IFDEF Delphi6}
, Variants
{$ENDIF};


type
  TFunctions = class(TfsRTTIModule)
  private
    function CallMethod(Instance: TObject; ClassType: TClass;
      const MethodName: String; Caller: TfsMethodHelper): Variant;
    function GetProp(Instance: TObject; ClassType: TClass;
      const PropName: String): Variant;
  public
    constructor Create(AScript: TfsScript); override;
  end;



constructor TFunctions.Create(AScript: TfsScript);
begin
  inherited Create(AScript);
  with AScript do
  begin
    AddClass(TADManager, 'TComponent');
    AddClass(TADConnection, 'TComponent');
    AddClass(TADDataSet, 'TDataSet');
    AddClass(TADAdaptedDataSet, 'TADDataSet');
    AddClass(TADRdbmsDataSet, 'TADAdaptedDataSet');
{    with AddClass(TTable, 'TDBDataSet') do
    begin
      AddMethod('procedure CreateTable', CallMethod);
      AddMethod('procedure DeleteTable', CallMethod);
      AddMethod('procedure EmptyTable', CallMethod);
      AddMethod('function FindKey(const KeyValues: array): Boolean', CallMethod);
      AddMethod('procedure FindNearest(const KeyValues: array)', CallMethod);
      AddMethod('procedure RenameTable(const NewTableName: string)', CallMethod);
    end;}
    with AddClass(TADQuery, 'TADRdbmsDataSet') do
    begin
      AddMethod('procedure ExecSQL', CallMethod);
      AddMethod('function ParamByName(const Value: string): TParam', CallMethod);
      AddMethod('procedure Prepare', CallMethod);
      AddProperty('ParamCount', 'Word', GetProp, nil);
    end;
    with AddClass(TADStoredProc, 'TADRdbmsDataSet') do
    begin
      AddMethod('procedure ExecProc', CallMethod);
      AddMethod('function ParamByName(const Value: string): TParam', CallMethod);
      AddMethod('procedure Prepare', CallMethod);
      AddProperty('ParamCount', 'Word', GetProp, nil);
    end;

    with AddClass(TfrxADDatabase, 'TfrxCustomDatabase') do
      AddProperty('Database', 'TADConnection', GetProp, nil);
    //AddClass(TfrxADTable, 'TfrxCustomTable');
    with AddClass(TfrxADQuery, 'TfrxCustomQuery') do
    begin
      AddMethod('procedure ExecSQL', CallMethod);
      AddProperty('Query', 'TADQuery', GetProp, nil);
    end;
    with AddClass(TfrxADStoredProc, 'TfrxADStoredProc') do
    begin
      AddMethod('procedure ExecProc', CallMethod);
      AddProperty('StoredProc', 'TADStoredProc', GetProp, nil);
    end;
  end;
end;

function TFunctions.CallMethod(Instance: TObject; ClassType: TClass;
  const MethodName: String; Caller: TfsMethodHelper): Variant;
begin
  Result := 0;

  if ClassType = TADQuery then
  begin
    if MethodName = 'EXECSQL' then
      TADQuery(Instance).ExecSQL
    else if MethodName = 'PARAMBYNAME' then
      Result := Integer(TADQuery(Instance).ParamByName(Caller.Params[0]))
    else if MethodName = 'PREPARE' then
      TADQuery(Instance).Prepare
  end
  else if ClassType = TADStoredProc then
  begin
    if MethodName = 'EXECPROC' then
      TADStoredProc(Instance).ExecProc
    else if MethodName = 'PARAMBYNAME' then
      Result := Integer(TADStoredProc(Instance).ParamByName(Caller.Params[0]))
    else if MethodName = 'PREPARE' then
      TADStoredProc(Instance).Prepare
  end
  else if ClassType = TfrxADQuery then
  begin
    if MethodName = 'EXECSQL' then
      TfrxADQuery(Instance).Query.ExecSQL;
  end
  else if ClassType = TfrxADStoredProc then
  begin
    if MethodName = 'EXECPROC' then
      TfrxADStoredProc(Instance).StoredProc.ExecProc;
  end
end;

function TFunctions.GetProp(Instance: TObject; ClassType: TClass;
  const PropName: String): Variant;
begin
  Result := 0;

  if ClassType = TADQuery then
  begin
    if PropName = 'PARAMCOUNT' then
      Result := TADQuery(Instance).ParamCount
  end
  else if ClassType = TADStoredProc then
  begin
    if PropName = 'PARAMCOUNT' then
      Result := TADStoredProc(Instance).ParamCount
  end
  else if ClassType = TfrxADDatabase then
  begin
    if PropName = 'DATABASE' then
      Result := Integer(TfrxADDatabase(Instance).Database)
  end
  else if ClassType = TfrxADQuery then
  begin
    if PropName = 'QUERY' then
      Result := Integer(TfrxADQuery(Instance).Query)
  end
  else if ClassType = TfrxADStoredProc then
  begin
    if PropName = 'STOREDPROC' then
      Result := Integer(TfrxADStoredProc(Instance).StoredProc)
  end;
end;

initialization
  fsRTTIModules.Add(TFunctions);

finalization
  if fsRTTIModules <> nil then
    fsRTTIModules.Remove(TFunctions);
   
end.
