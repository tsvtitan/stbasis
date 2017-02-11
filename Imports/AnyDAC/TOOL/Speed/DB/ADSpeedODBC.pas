{ --------------------------------------------------------------------------- }
{ AnyDAC Speed Tester - ODBC Express dataset unit                             }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I ..\ADSpeed.inc}

unit ADSpeedODBC;

interface

uses
  DB, OCIH, OCL, ODSI, ADSpeedBase, ADSpeedBaseDB,
  daADStanIntf;

type
  TADSpeedODBCQuery = class(TADSpeedCustomDBDataSet)
  private
    function GetQuery: TOEQuery;
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
    property Query: TOEQuery read GetQuery;
  end;

{$IFDEF AnyDACSPEED_ORA}
  TADSpeedOra4OraODBCQuery = class(TADSpeedODBCQuery)
  public
    class function AllocConnection: TObject; override;
    class procedure OpenConnection(AConnection: TObject; const AConnDef: IADStanConnectionDef); override;
    class function GetName: String; override;
    class function GetDescription: String; override;
  end;

  TADSpeedMs4OraODBCQuery = class(TADSpeedODBCQuery)
  public
    class function AllocConnection: TObject; override;
    class procedure OpenConnection(AConnection: TObject; const AConnDef: IADStanConnectionDef); override;
    class function GetName: String; override;
    class function GetDescription: String; override;
  end;
{$ENDIF}

{$IFDEF AnyDACSPEED_MSSQL}
  TADSpeedMs4MssqlODBCQuery = class(TADSpeedODBCQuery)
  public
    class function AllocConnection: TObject; override;
    class procedure OpenConnection(AConnection: TObject; const AConnDef: IADStanConnectionDef); override;
    class function GetName: String; override;
    class function GetDescription: String; override;
  end;
{$ENDIF}

implementation

uses
  SysUtils, daADStanConst;

{---------------------------------------------------------------------------}
{ TADSpeedODBCQuery                                                         }
{---------------------------------------------------------------------------}
constructor TADSpeedODBCQuery.Create;
begin
  inherited Create;
  DataSet := TOEQuery.Create(nil);
  Query.hStmt.SQLParsing := True;
end;

{---------------------------------------------------------------------------}
destructor TADSpeedODBCQuery.Destroy;
begin
  DataSet.Free;
  DataSet := nil;
  inherited Destroy;
end;

{---------------------------------------------------------------------------}
// Query management

function TADSpeedODBCQuery.GetQuery: TOEQuery;
begin
  Result := DataSet as TOEQuery;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedODBCQuery.Setup(AFetchAll, AWithBlobs, AReadOnly: Boolean);
var
  isMSSQL: Boolean;
begin
{$IFDEF AnyDACSPEED_MSSQL}
  isMSSQL := True;
{$ENDIF}
{$IFDEF AnyDACSPEED_Ora}
  isMSSQL := True;
{$ENDIF}
  Query.hStmt.CursorType := SQL_CURSOR_FORWARD_ONLY;
  Query.hStmt.ConcurrencyType := SQL_CONCUR_READ_ONLY;
  if AFetchAll and not IsMSSQL then
    Query.hStmt.RowSetSize := 100
  else
    Query.hStmt.RowSetSize := 1;
  if AWithBlobs then
    Query.hStmt.BlobSize := 250000;
  Query.RequestLive := not AReadOnly;
end;

{---------------------------------------------------------------------------}
function TADSpeedODBCQuery.GetSQL: String;
begin
  Result := TCustomOEDataSet(Query).SQL;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedODBCQuery.SetSQL(const Value: String);
var
  s: String;
begin
  s := UpperCase(Value);
  if (Pos('DECLARE', s) <> 0) or (Pos('BEGIN', s) <> 0) then
    TCustomOEDataSet(Query).SQL := Value
  else
    Query.SQL.Text := Value;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedODBCQuery.DefineParam(const AName: String;
  ADataType: TFieldType; ADataSize: Integer; AParamType: TParamType);
var
  oPar: TParam;
begin
  oPar := Query.Params.ParamByName(AName);
  oPar.DataType := ADataType;
  if ADataSize <> -1 then
    oPar.Size := ADataSize;
  oPar.ParamType := AParamType;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedODBCQuery.Prepare;
begin
  Query.Prepare;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedODBCQuery.UnPrepare;
begin
  Query.UnPrepare;
end;

{---------------------------------------------------------------------------}
function TADSpeedODBCQuery.GetParam(AIndex: Integer): Variant;
begin
  Result := Query.Params[AIndex].Value;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedODBCQuery.SetParam(AIndex: Integer;
  const AValue: Variant);
begin
  Query.Params[AIndex].Value := AValue;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedODBCQuery.Execute;
begin
  Query.ExecSQL;
end;

{---------------------------------------------------------------------------}
// Connection management

procedure TADSpeedODBCQuery.SetConnection(AConnection: TObject);
begin
  inherited SetConnection(AConnection);
  Query.hDbc := THdbc(AConnection);
end;

{---------------------------------------------------------------------------}
procedure TADSpeedODBCQuery.StartTransaction;
begin
  Query.hDbc.StartTransact;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedODBCQuery.RollbackTransaction;
begin
  Query.hDbc.Rollback;
end;

{---------------------------------------------------------------------------}
class procedure TADSpeedODBCQuery.CloseConnection(AConnection: TObject);
begin
  THdbc(AConnection).Disconnect;
end;

{$IFDEF AnyDACSPEED_ORA}
{---------------------------------------------------------------------------}
{ TADSpeedOra4OraODBCQuery                                                  }
{---------------------------------------------------------------------------}
class function TADSpeedOra4OraODBCQuery.GetName: String;
begin
  Result := 'Ora TOEQuery';
end;

{---------------------------------------------------------------------------}
class function TADSpeedOra4OraODBCQuery.GetDescription: String;
begin
  Result := 'Korbitec TOEQuery -> Oracle ODBC driver -> OCI8 -> Oracle';
end;

{---------------------------------------------------------------------------}
class function TADSpeedOra4OraODBCQuery.AllocConnection: TObject;
begin
  Result := THdbc.Create(nil);
  with THdbc(Result) do begin
    { TODO : There driver name must be evaluated, not just constant }
    Driver := 'Oracle in Ora920';
    Attributes.Values['Application Attributes'] := 'T';
    Attributes.Values['Attributes'] := 'W';
    Attributes.Values['BatchAutocommitMode'] := 'IfAllSuccessful';
    Attributes.Values['CloseCursor'] := 'F';
    Attributes.Values['DisableMTS'] := 'F';
    Attributes.Values['EXECSchemaOpt'] := '';
    Attributes.Values['EXECSyntax'] := 'F';
    Attributes.Values['Failover'] := 'T';
    Attributes.Values['FailoverDelay'] := '10';
    Attributes.Values['FailoverRetryCount'] := '10';
    Attributes.Values['ForceWCHAR'] := 'F';
    Attributes.Values['Lobs'] := 'T';
    Attributes.Values['Longs'] := 'T';
    Attributes.Values['MetadataIdDefault'] := 'F';
    Attributes.Values['PrefetchCount'] := '3';
    Attributes.Values['QueryTimeout'] := 'T';
    Attributes.Values['ResultSets'] := 'T';
    Attributes.Values['SQLGetData extensions'] := 'F';
    Attributes.Values['Translation DLL'] := '';
    Attributes.Values['Translation Option'] := '0';
  end;
end;

{---------------------------------------------------------------------------}
class procedure TADSpeedOra4OraODBCQuery.OpenConnection(
  AConnection: TObject; const AConnDef: IADStanConnectionDef);
begin
  with THdbc(AConnection) do begin
    Connected := False;
    UserName := AConnDef.UserName;
    Password := AConnDef.Password;
    Attributes.Values['ServerName'] := AConnDef.Database;
    Connected := True;
  end;
end;

{---------------------------------------------------------------------------}
{ TADSpeedMs4OraODBCQuery                                                   }
{---------------------------------------------------------------------------}
class function TADSpeedMs4OraODBCQuery.GetName: String;
begin
  Result := 'MS TOEQuery';
end;

{---------------------------------------------------------------------------}
class function TADSpeedMs4OraODBCQuery.GetDescription: String;
begin
  Result := 'Korbitec TOEQuery -> MS ODBC driver -> OCI7 -> Oracle';
end;

{---------------------------------------------------------------------------}
class function TADSpeedMs4OraODBCQuery.AllocConnection: TObject;
begin
  Result := THdbc.Create(nil);
  with THdbc(Result) do
    Driver := 'Microsoft ODBC for Oracle';
end;

{---------------------------------------------------------------------------}
class procedure TADSpeedMs4OraODBCQuery.OpenConnection(
  AConnection: TObject; const AConnDef: IADStanConnectionDef);
begin
  with THdbc(AConnection) do begin
    Connected := False;
    UserName := AConnDef.UserName;
    Password := AConnDef.Password;
    Attributes.Values['ServerName'] := AConnDef.Database;
    Connected := True;
  end;
end;
{$ENDIF}

{$IFDEF AnyDACSPEED_MSSQL}
{---------------------------------------------------------------------------}
{ TADSpeedMs4MssqlODBCQuery                                                 }
{---------------------------------------------------------------------------}
class function TADSpeedMs4MssqlODBCQuery.GetName: String;
begin
  Result := 'TOEQuery';
end;

{---------------------------------------------------------------------------}
class function TADSpeedMs4MssqlODBCQuery.GetDescription: String;
begin
  Result := 'Korbitec TOEQuery -> MS ODBC driver -> MSSQL';
end;

{---------------------------------------------------------------------------}
class function TADSpeedMs4MssqlODBCQuery.AllocConnection: TObject;
begin
  Result := THdbc.Create(nil);
  with THdbc(Result) do begin
    Driver := 'SQL Server';
    Attributes.Values['Database'] := '';
  end;
end;

{---------------------------------------------------------------------------}
class procedure TADSpeedMs4MssqlODBCQuery.OpenConnection(
  AConnection: TObject; const AConnDef: IADStanConnectionDef);
begin
  with THdbc(AConnection) do begin
    Connected := False;
    UserName := AConnDef.Username;
    Password := AConnDef.Password;
    Attributes.Values['Server'] := AConnDef.AsString[S_AD_ConnParam_MSSQL_Server];
    Attributes.Values['Database'] := AConnDef.Database;
    Connected := True;
  end;
end;
{$ENDIF}

end.

