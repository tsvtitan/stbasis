{ --------------------------------------------------------------------------- }
{ AnyDAC Speed Tester - DOA dataset unit                                      }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I ..\ADSpeed.inc}

unit ADSpeedDOA;

interface

uses
  DB, OracleData, Oracle, ADSpeedBase, ADSpeedBaseDB, 
  daADStanIntf;

type
  TADSpeedDOAQuery = class(TADSpeedCustomDBDataSet)
  private
    function GetQuery: TOracleDataSet;
  protected
    procedure SetConnection(AConnection: TObject); override;
    procedure SetParam(AIndex: Integer; const AValue: Variant); override;
    function GetParam(AIndex: Integer): Variant; override;
    function GetSQL: String; override;
    procedure SetSQL(const Value: String); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Prepare; override;
    procedure UnPrepare; override;
    procedure Execute; override;
    procedure StartTransaction; override;
    procedure RollbackTransaction; override;
    procedure Setup(AFetchAll, AWithBlobs, AReadOnly: Boolean); override;
    procedure DefineParam(const AName: String; ADataType: TFieldType;
      ADataSize: Integer; AParamType: TParamType); override;
    class function AllocConnection: TObject; override;
    class procedure OpenConnection(AConnection: TObject; const AConnDef: IADStanConnectionDef); override;
    class procedure CloseConnection(AConnection: TObject); override;
    class function GetName: String; override;
    class function GetDescription: String; override;
    property Query: TOracleDataSet read GetQuery;
  end;

implementation

uses
  Controls,
{$IFDEF AnyDAC_D6}
  Variants,
{$ENDIF}
  OracleTypes;

type
  __TOracleDataSet = class(TOracleDataSet)
  end;

{---------------------------------------------------------------------------}
{ TADSpeedDOAQuery                                                          }
{---------------------------------------------------------------------------}
constructor TADSpeedDOAQuery.Create;
begin
  inherited Create;
  DataSet := TOracleDataSet.Create(nil);
end;

{---------------------------------------------------------------------------}
destructor TADSpeedDOAQuery.Destroy;
begin
  DataSet.Free;
  DataSet := nil;
  inherited Destroy;
end;

{---------------------------------------------------------------------------}
// Query management

function TADSpeedDOAQuery.GetQuery: TOracleDataSet;
begin
  Result := DataSet as TOracleDataSet;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedDOAQuery.Setup(AFetchAll, AWithBlobs, AReadOnly: Boolean);
begin
  if AFetchAll then begin
    // Query.Unidirectional := True;
    Query.ReadBuffer := 100;
    Query.QueryAllRecords := True;
  end
  else begin
    // Query.Unidirectional := False;
    Query.ReadBuffer := 1;
    Query.QueryAllRecords := False;
  end;
  Query.ReadOnly := AReadOnly;
end;

{---------------------------------------------------------------------------}
function TADSpeedDOAQuery.GetSQL: String;
begin
  Result := Query.SQL.Text;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedDOAQuery.SetSQL(const Value: String);
begin
  Query.SQL.Text := Value;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedDOAQuery.DefineParam(const AName: String;
  ADataType: TFieldType; ADataSize: Integer; AParamType: TParamType);
var
  i, iType: Integer;
  sName: String;
begin
  sName := AName;
  i := __TOracleDataSet(Query).InternalQuery.VariableIndex(sName);
  if i = -1 then begin
    case ADataType of
    ftFloat:    iType := otFloat;
    ftString:   iType := otString;
    ftDateTime: iType := otDate;
    else        iType := otString;
    end;
    Query.DeclareVariable(sName, iType);
    i := Query.VariableCount - 1;
  end;
  Query.Variables.Data(i).ReDim(ArraySize, -1, Query.Session);
end;

{---------------------------------------------------------------------------}
procedure TADSpeedDOAQuery.Prepare;
begin
  // nothing
end;

{---------------------------------------------------------------------------}
procedure TADSpeedDOAQuery.UnPrepare;
begin
  Query.ClearVariables;
end;

{---------------------------------------------------------------------------}
function TADSpeedDOAQuery.GetParam(AIndex: Integer): Variant;
begin
  Result := Query.GetVariable(Query.VariableName(AIndex));
end;

{---------------------------------------------------------------------------}
procedure TADSpeedDOAQuery.SetParam(AIndex: Integer; const AValue: Variant);
begin
  Query.Variables.Data(AIndex).SetValue(FArrayIndex, AValue, Query.Session);
end;

{---------------------------------------------------------------------------}
procedure TADSpeedDOAQuery.Execute;
begin
  Inc(FArrayIndex);
  if FArrayIndex = ArraySize then begin
    __TOracleDataSet(Query).InternalQuery.ExecuteArray(0, ArraySize);
    FArrayIndex := 0;
  end;
end;

{---------------------------------------------------------------------------}
// Connection management

procedure TADSpeedDOAQuery.SetConnection(AConnection: TObject);
begin
  inherited SetConnection(AConnection);
  Query.Session := (AConnection as TOracleSession);
end;

{---------------------------------------------------------------------------}
procedure TADSpeedDOAQuery.StartTransaction;
begin
  Query.Session.SetTransaction(tmReadWrite);
end;

{---------------------------------------------------------------------------}
procedure TADSpeedDOAQuery.RollbackTransaction;
begin
  Query.Session.Rollback;
end;

{---------------------------------------------------------------------------}
class function TADSpeedDOAQuery.GetName: String;
begin
  Result := 'TOracleDataSet';
end;

{---------------------------------------------------------------------------}
class function TADSpeedDOAQuery.GetDescription: String;
begin
  Result := 'AllroundAutomations TOracleDataSet -> OCI8 -> Oracle';
end;

{---------------------------------------------------------------------------}
class function TADSpeedDOAQuery.AllocConnection: TObject;
begin
  Result := TOracleSession.Create(nil);
  with TOracleSession(Result) do
    Cursor := crDefault;
end;

{---------------------------------------------------------------------------}
class procedure TADSpeedDOAQuery.OpenConnection(
  AConnection: TObject; const AConnDef: IADStanConnectionDef);
begin
  with TOracleSession(AConnection) do begin
    Connected := False;
    LogonDatabase := AConnDef.Database;
    LogonUsername := AConnDef.Username;
    LogonPassword := AConnDef.Password;
    Connected := True;
  end;
end;

{---------------------------------------------------------------------------}
class procedure TADSpeedDOAQuery.CloseConnection(AConnection: TObject);
begin
  TOracleSession(AConnection).LogOff;
end;

end.

