{ --------------------------------------------------------------------------- }
{ AnyDAC Speed Tester - SQLDirect dataset unit                                }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I ..\ADSpeed.inc}

unit ADSpeedSQLDirect;

interface

uses
  DB, SDCommon, SDEngine,
  daADStanIntf, ADSpeedBase, ADSpeedBaseDB;

type
  TADSpeedSQLDirectQuery = class(TADSpeedCustomDBDataSet)
  private
    function GetQuery: TSDQuery;
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
    procedure Setup(AFetchAll, AWithBlobs, AReadOnly: Boolean); override;
    procedure StartTransaction; override;
    procedure RollbackTransaction; override;
    procedure DefineParam(const AName: String; ADataType: TFieldType;
      ADataSize: Integer; AParamType: TParamType); override;
    class procedure CloseConnection(AConnection: TObject); override;
    property Query: TSDQuery read GetQuery;
  end;

{$IFDEF AnyDACSPEED_ORA}
  TADSpeedOraSQLDirectQuery = class(TADSpeedSQLDirectQuery)
  public
    class function GetName: String; override;
    class function GetDescription: String; override;
    class function AllocConnection: TObject; override;
    class procedure OpenConnection(AConnection: TObject; const AConnDef: IADStanConnectionDef); override;
  end;
{$ENDIF}

{$IFDEF AnyDACSPEED_MSSQL}
  TADSpeedMssqlSQLDirectQuery = class(TADSpeedSQLDirectQuery)
  public
    class function GetName: String; override;
    class function GetDescription: String; override;
    class function AllocConnection: TObject; override;
    class procedure OpenConnection(AConnection: TObject; const AConnDef: IADStanConnectionDef); override;
  end;
{$ENDIF}

implementation

uses
  daADStanConst;

{---------------------------------------------------------------------------}
{ TADSpeedSQLDirectQuery                                                    }
{---------------------------------------------------------------------------}
constructor TADSpeedSQLDirectQuery.Create;
begin
  inherited Create;
  DataSet := TSDQuery.Create(nil);
end;

{---------------------------------------------------------------------------}
destructor TADSpeedSQLDirectQuery.Destroy;
begin
  DataSet.Free;
  DataSet := nil;
  inherited Destroy;
end;

{---------------------------------------------------------------------------}
// Query management

function TADSpeedSQLDirectQuery.GetQuery: TSDQuery;
begin
  Result := DataSet as TSDQuery;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedSQLDirectQuery.Setup(AFetchAll, AWithBlobs, AReadOnly: Boolean);
begin
  Query.UniDirectional := AFetchAll;
  Query.RequestLive := not AReadOnly;
end;

{---------------------------------------------------------------------------}
function TADSpeedSQLDirectQuery.GetSQL: String;
begin
  Result := Query.SQL.Text;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedSQLDirectQuery.SetSQL(const Value: String);
begin
  Query.SQL.Text := Value;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedSQLDirectQuery.DefineParam(const AName: String;
  ADataType: TFieldType; ADataSize: Integer; AParamType: TParamType);
var
  oPar: TSDHelperParam;
begin
  oPar := Query.ParamByName(AName);
  oPar.DataType := ADataType;
  oPar.ParamType := AParamType;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedSQLDirectQuery.Prepare;
begin
  Query.Prepare;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedSQLDirectQuery.UnPrepare;
begin
  Query.UnPrepare;
end;

{---------------------------------------------------------------------------}
function TADSpeedSQLDirectQuery.GetParam(AIndex: Integer): Variant;
begin
  Result := Query.Params[AIndex].Value;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedSQLDirectQuery.SetParam(AIndex: Integer;
  const AValue: Variant);
begin
  Query.Params[AIndex].Value := AValue;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedSQLDirectQuery.Execute;
begin
  Query.SQL := Query.SQL;
  Query.ExecSQL;
end;

{---------------------------------------------------------------------------}
// Connection management

procedure TADSpeedSQLDirectQuery.SetConnection(AConnection: TObject);
begin
  inherited SetConnection(AConnection);
  Query.DatabaseName := (AConnection as TSDDatabase).DatabaseName;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedSQLDirectQuery.StartTransaction;
begin
  Query.Database.StartTransaction;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedSQLDirectQuery.RollbackTransaction;
begin
  Query.Database.Rollback;
end;

{---------------------------------------------------------------------------}
class procedure TADSpeedSQLDirectQuery.CloseConnection(AConnection: TObject);
begin
  (AConnection as TSDDatabase).Close;
end;

{$IFDEF AnyDACSPEED_ORA}
{---------------------------------------------------------------------------}
{ TADSpeedOraSQLDirectQuery                                                 }
{---------------------------------------------------------------------------}

class function TADSpeedOraSQLDirectQuery.GetName: String;
begin
  Result := 'TSDQuery';
end;

{---------------------------------------------------------------------------}
class function TADSpeedOraSQLDirectQuery.GetDescription: String;
begin
  Result := 'SQLDirect TSDQuery -> OCI8 -> Oracle';
end;

{---------------------------------------------------------------------------}
class function TADSpeedOraSQLDirectQuery.AllocConnection: TObject;
begin
  Result := TSDDatabase.Create(nil);
  with TSDDatabase(Result) do begin
    DatabaseName := 'AnyDACSPEED_SD_ORA';
    IdleTimeOut := 0;
    Params.Add('USER NAME=');
    Params.Add('PASSWORD=');
    RemoteDatabase := '';
    ServerType := stOracle;
    SessionName := 'Default';
    LoginPrompt := False;
    Session.SQLHourGlass := False;
  end;
end;

{---------------------------------------------------------------------------}
class procedure TADSpeedOraSQLDirectQuery.OpenConnection(
  AConnection: TObject; const AConnDef: IADStanConnectionDef);
begin
  with TSDDatabase(AConnection) do begin
    Connected := False;
    RemoteDatabase := AConnDef.Database;
    Params.Values['USER NAME'] := AConnDef.Username;
    Params.Values['PASSWORD'] := AConnDef.Password;
    Connected := True;
  end;
end;
{$ENDIF}

{$IFDEF AnyDACSPEED_MSSQL}
{---------------------------------------------------------------------------}
{ TADSpeedMssqlSQLDirectQuery                                               }
{---------------------------------------------------------------------------}
class function TADSpeedMssqlSQLDirectQuery.GetName: String;
begin
  Result := 'TSDQuery';
end;

{---------------------------------------------------------------------------}
class function TADSpeedMssqlSQLDirectQuery.GetDescription: String;
begin
  Result := 'SQLDirect TSDQuery -> netlib -> MSSQL';
end;

{---------------------------------------------------------------------------}
class function TADSpeedMssqlSQLDirectQuery.AllocConnection: TObject;
begin
  Result := TSDDatabase.Create(nil);
  with TSDDatabase(Result) do begin
    DatabaseName := 'AnyDACSPEED_SD_MSSQL';
    IdleTimeOut := 0;
    Params.Add('USER NAME=');
    Params.Add('PASSWORD=');
    RemoteDatabase := '';
    ServerType := stSQLServer;
    SessionName := 'Default';
    LoginPrompt := False;
    Session.SQLHourGlass := False;
  end;
end;

{---------------------------------------------------------------------------}
class procedure TADSpeedMssqlSQLDirectQuery.OpenConnection(
  AConnection: TObject; const AConnDef: IADStanConnectionDef);
begin
  with TSDDatabase(AConnection) do begin
    Connected := False;
    RemoteDatabase := AConnDef.AsString[S_AD_ConnParam_MSSQL_Server] + ':' + AConnDef.Database;
    Params.Values['USER NAME'] := AConnDef.Username;
    Params.Values['PASSWORD'] := AConnDef.Password;
    Connected := True;
  end;
end;
{$ENDIF}

end.

