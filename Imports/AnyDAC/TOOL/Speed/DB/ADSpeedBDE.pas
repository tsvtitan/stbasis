{ --------------------------------------------------------------------------- }
{ AnyDAC Speed Tester - BDE dataset unit                                      }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I ..\ADSpeed.inc}

unit ADSpeedBDE;

interface

uses
  DB, DBTables,
  daADStanIntf, ADSpeedBase, ADSpeedBaseDB;

type
  TADSpeedBDEQuery = class(TADSpeedCustomDBDataSet)
  private
    function GetQuery: TQuery;
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
    class procedure CloseConnection(AConnection: TObject); override;
    property Query: TQuery read GetQuery;
  end;

{$IFDEF AnyDACSPEED_ORA}
  TADSpeedOraBDEQuery = class(TADSpeedBDEQuery)
  public
    class function GetName: String; override;
    class function GetDescription: String; override;
    class function AllocConnection: TObject; override;
    class procedure OpenConnection(AConnection: TObject; const AConnDef: IADStanConnectionDef); override;
  end;
{$ENDIF}

{$IFDEF AnyDACSPEED_MSSQL}
  TADSpeedMssqlBDEQuery = class(TADSpeedBDEQuery)
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
{ TADSpeedBDEQuery                                                          }
{---------------------------------------------------------------------------}
constructor TADSpeedBDEQuery.Create;
begin
  inherited Create;
  DataSet := TQuery.Create(nil);
end;

{---------------------------------------------------------------------------}
destructor TADSpeedBDEQuery.Destroy;
begin
  DataSet.Free;
  DataSet := nil;
  inherited Destroy;
end;

{---------------------------------------------------------------------------}
// Query management

function TADSpeedBDEQuery.GetQuery: TQuery;
begin
  Result := DataSet as TQuery;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedBDEQuery.Setup(AFetchAll, AWithBlobs, AReadOnly: Boolean);
begin
  if AFetchAll then begin
    Query.UniDirectional := True;
    Query.BlockReadSize := 6000;
  end
  else begin
    Query.UniDirectional := False;
    Query.BlockReadSize := 0;
  end;
end;

{---------------------------------------------------------------------------}
function TADSpeedBDEQuery.GetSQL: String;
begin
  Result := Query.SQL.Text;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedBDEQuery.SetSQL(const Value: String);
begin
  Query.SQL.Text := Value;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedBDEQuery.DefineParam(const AName: String;
  ADataType: TFieldType; ADataSize: Integer; AParamType: TParamType);
var
  oPar: TParam;
begin
  oPar := Query.ParamByName(AName);
  oPar.DataType := ADataType;
  oPar.ParamType := AParamType;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedBDEQuery.Prepare;
begin
  Query.Prepare;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedBDEQuery.UnPrepare;
begin
  Query.UnPrepare;
end;

{---------------------------------------------------------------------------}
function TADSpeedBDEQuery.GetParam(AIndex: Integer): Variant;
begin
  Result := Query.Params[AIndex].Value;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedBDEQuery.SetParam(AIndex: Integer;
  const AValue: Variant);
begin
  Query.Params[AIndex].Value := AValue;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedBDEQuery.Execute;
begin
  Query.ExecSQL;
end;

{---------------------------------------------------------------------------}
// Connection management

procedure TADSpeedBDEQuery.SetConnection(AConnection: TObject);
begin
  inherited SetConnection(AConnection);
  Query.DatabaseName := (AConnection as TDatabase).DatabaseName;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedBDEQuery.StartTransaction;
begin
  Query.Database.StartTransaction;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedBDEQuery.RollbackTransaction;
begin
  Query.Database.Rollback;
end;

{---------------------------------------------------------------------------}
class procedure TADSpeedBDEQuery.CloseConnection(AConnection: TObject);
begin
  (AConnection as TDatabase).Close;
end;

{$IFDEF AnyDACSPEED_ORA}
{---------------------------------------------------------------------------}
{ TADSpeedOraBDEQuery                                                       }
{---------------------------------------------------------------------------}
class function TADSpeedOraBDEQuery.GetName: String;
begin
  Result := 'TQuery';
end;

{---------------------------------------------------------------------------}
class function TADSpeedOraBDEQuery.GetDescription: String;
begin
  Result := 'Borland TQuery -> BDE -> SQLLink -> OCI8 -> Oracle';
end;

{---------------------------------------------------------------------------}
class function TADSpeedOraBDEQuery.AllocConnection: TObject;
begin
  Result := TDatabase.Create(nil);
  with TDatabase(Result) do begin
    DatabaseName := 'AnyDACSPEED_BDE_ORA';
    DriverName := 'ORACLE';
    Params.Add('NET PROTOCOL=TNS');
    Params.Add('OPEN MODE=READ/WRITE');
    Params.Add('SCHEMA CACHE SIZE=128');
    Params.Add('LANGDRIVER=DBWINUS0');
    Params.Add('SQLQRYMODE=SERVER');
    Params.Add('SQLPASSTHRU MODE=SHARED AUTOCOMMIT');
    Params.Add('SCHEMA CACHE TIME=-1');
    Params.Add('MAX ROWS=-1');
    Params.Add('BATCH COUNT=200');
    Params.Add('ENABLE SCHEMA CACHE=FALSE');
    Params.Add('SCHEMA CACHE DIR=c:\temp');
    Params.Add('ENABLE BCD=FALSE');
    Params.Add('ENABLE INTEGERS=FALSE');
    Params.Add('LIST SYNONYMS=ALL');
    Params.Add('ROWSET SIZE=100');
    Params.Add('BLOBS TO CACHE=100');
    Params.Add('BLOB SIZE=200');
    Params.Add('OBJECT MODE=FALSE');

    Params.Add('SERVER NAME=');
    Params.Add('USER NAME=');
    Params.Add('PASSWORD=');

    SessionName := 'Default';
    LoginPrompt := False;
    TraceFlags := [];
  end;
end;

{---------------------------------------------------------------------------}
class procedure TADSpeedOraBDEQuery.OpenConnection(AConnection: TObject;
  const AConnDef: IADStanConnectionDef);
begin
  with TDatabase(AConnection) do begin
    Connected := False;
    Params.Values['SERVER NAME'] := AConnDef.Database;
    Params.Values['USER NAME'] := AConnDef.UserName;
    Params.Values['PASSWORD'] := AConnDef.Password;
    Connected := True;
  end;
end;
{$ENDIF}

{$IFDEF AnyDACSPEED_MSSQL}
{---------------------------------------------------------------------------}
{ TADSpeedMssqlBDEQuery                                                     }
{---------------------------------------------------------------------------}
class function TADSpeedMssqlBDEQuery.GetName: String;
begin
  Result := 'TQuery';
end;

{---------------------------------------------------------------------------}
class function TADSpeedMssqlBDEQuery.GetDescription: String;
begin
  Result := 'Borland TQuery -> BDE -> SQLLink -> netlib -> MSSQL';
end;

{---------------------------------------------------------------------------}
class function TADSpeedMssqlBDEQuery.AllocConnection: TObject;
begin
  Result := TDatabase.Create(nil);
  with TDatabase(Result) do begin
    DatabaseName := 'AnyDACSPEED_BDE_MSSQL';
    DriverName := 'MSSQL';

    Params.Add('APPLICATION NAME=');
    Params.Add('BATCH COUNT=200');
    Params.Add('BLOB EDIT LOGGING=');
    Params.Add('BLOB SIZE=200');
    Params.Add('BLOBS TO CACHE=100');
    Params.Add('DATE MODE=0');
    Params.Add('ENABLE BCD=FALSE');
    Params.Add('ENABLE SCHEMA CACHE=FALSE');
    Params.Add('LANGDRIVER=');
    Params.Add('MAX QUERY TIME=300');
    Params.Add('MAX ROWS=-1');
    Params.Add('NATIONAL LANG NAME=');
    Params.Add('OPEN MODE=READ/WRITE');
    Params.Add('SCHEMA CACHE DIR=c:\temp');
    Params.Add('SCHEMA CACHE SIZE=128');
    Params.Add('SCHEMA CACHE TIME=-1');
    Params.Add('SQLPASSTHRU MODE=SHARED AUTOCOMMIT');
    Params.Add('SQLQRYMODE=SERVER');
    Params.Add('TDS PACKET SIZE=4096');
    Params.Add('HOST NAME=');

    Params.Add('SERVER NAME=');
    Params.Add('DATABASE NAME=');
    Params.Add('USER NAME=');
    Params.Add('PASSWORD=');

    SessionName := 'Default';
    LoginPrompt := False;
    TraceFlags := [];
  end;
end;

{---------------------------------------------------------------------------}
class procedure TADSpeedMssqlBDEQuery.OpenConnection(
  AConnection: TObject; const AConnDef: IADStanConnectionDef);
begin
  with TDatabase(AConnection) do begin
    Connected := False;
    Params.Values['SERVER NAME'] := AConnDef.AsString[S_AD_ConnParam_MSSQL_Server];
    Params.Values['DATABASE NAME'] := AConnDef.Database;
    Params.Values['USER NAME'] := AConnDef.UserName;
    Params.Values['PASSWORD'] := AConnDef.Password;
    Connected := True;
  end;
end;
{$ENDIF}

end.

