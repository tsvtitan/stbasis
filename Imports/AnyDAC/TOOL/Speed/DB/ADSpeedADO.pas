{ --------------------------------------------------------------------------- }
{ AnyDAC Speed Tester - ADO dataset unit                                      }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I ..\ADSpeed.inc}

unit ADSpeedADO;

interface

uses
  DB, ADODB, ADSpeedBase, ADSpeedBaseDB,
  daADStanIntf;

type
  TADSpeedADOQuery = class(TADSpeedCustomDBDataSet)
  private
    function GetQuery: TADOQuery;
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
    property Query: TADOQuery read GetQuery;
  end;

{$IFDEF AnyDACSPEED_ORA}
  TADSpeedOra4OraADOQuery = class(TADSpeedADOQuery)
  public
    class function AllocConnection: TObject; override;
    class procedure OpenConnection(AConnection: TObject; const AConnDef: IADStanConnectionDef); override;
    class function GetName: String; override;
    class function GetDescription: String; override;
  end;

  TADSpeedMs4OraADOQuery = class(TADSpeedADOQuery)
  public
    class function AllocConnection: TObject; override;
    class procedure OpenConnection(AConnection: TObject; const AConnDef: IADStanConnectionDef); override;
    class function GetName: String; override;
    class function GetDescription: String; override;
  end;
{$ENDIF}

{$IFDEF AnyDACSPEED_MSSQL}
  TADSpeedMs4MssqlADOQuery = class(TADSpeedADOQuery)
  public
    class function AllocConnection: TObject; override;
    class procedure OpenConnection(AConnection: TObject; const AConnDef: IADStanConnectionDef); override;
    class function GetName: String; override;
    class function GetDescription: String; override;
  end;
{$ENDIF}

implementation

uses
  daADStanConst;

{---------------------------------------------------------------------------}
{ TADSpeedADOQuery                                                          }
{---------------------------------------------------------------------------}
constructor TADSpeedADOQuery.Create;
begin
  inherited Create;
  DataSet := TADOQuery.Create(nil);
end;

{---------------------------------------------------------------------------}
destructor TADSpeedADOQuery.Destroy;
begin
  DataSet.Free;
  DataSet := nil;
  inherited Destroy;
end;

{---------------------------------------------------------------------------}
// Query management

function TADSpeedADOQuery.GetQuery: TADOQuery;
begin
  Result := DataSet as TADOQuery;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedADOQuery.Setup(AFetchAll, AWithBlobs, AReadOnly: Boolean);
begin
  Query.CursorLocation := clUseClient;
{$IFDEF AnyDACSPEED_MSSQL}
  Query.CursorType := ctKeyset;
{$ENDIF}
{$IFDEF AnyDACSPEED_ORA}
  Query.CursorType := ctOpenForwardOnly;
{$ENDIF}
  if AFetchAll then
    Query.CacheSize := 100
  else
    Query.CacheSize := 1;
  if AReadOnly then
    Query.LockType := ltReadOnly
  else
    Query.LockType := ltOptimistic;
end;

{---------------------------------------------------------------------------}
function TADSpeedADOQuery.GetSQL: String;
begin
  Result := Query.SQL.Text;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedADOQuery.SetSQL(const Value: String);
begin
  Query.SQL.Text := Value;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedADOQuery.DefineParam(const AName: String;
  ADataType: TFieldType; ADataSize: Integer; AParamType: TParamType);
var
  oPar: TParameter;
begin
  oPar := Query.Parameters.ParamByName(AName);
  oPar.DataType := ADataType;
  if ADataSize <> -1 then
    oPar.Size := ADataSize;
  oPar.Direction := TParameterDirection(AParamType);
end;

{---------------------------------------------------------------------------}
procedure TADSpeedADOQuery.Prepare;
begin
  Query.Prepared := True;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedADOQuery.UnPrepare;
begin
  Query.Prepared := False;
end;

{---------------------------------------------------------------------------}
function TADSpeedADOQuery.GetParam(AIndex: Integer): Variant;
begin
  Result := Query.Parameters[AIndex].Value;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedADOQuery.SetParam(AIndex: Integer;
  const AValue: Variant);
begin
  Query.Parameters[AIndex].Value := AValue;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedADOQuery.Execute;
begin
  Query.ExecSQL;
end;

{---------------------------------------------------------------------------}
// Connection management

procedure TADSpeedADOQuery.SetConnection(AConnection: TObject);
begin
  inherited SetConnection(AConnection);
  Query.Connection := TADOConnection(AConnection);
end;

{---------------------------------------------------------------------------}
procedure TADSpeedADOQuery.StartTransaction;
begin
  Query.Connection.BeginTrans;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedADOQuery.RollbackTransaction;
begin
  Query.Connection.RollbackTrans;
end;

{---------------------------------------------------------------------------}
class procedure TADSpeedADOQuery.CloseConnection(AConnection: TObject);
begin
  TADOConnection(AConnection).Close;
end;

{$IFDEF AnyDACSPEED_ORA}
{---------------------------------------------------------------------------}
{ TADSpeedOra4OraADOQuery                                                   }
{---------------------------------------------------------------------------}
class function TADSpeedOra4OraADOQuery.GetName: String;
begin
  Result := 'Ora TADOQuery';
end;

{---------------------------------------------------------------------------}
class function TADSpeedOra4OraADOQuery.GetDescription: String;
begin
  Result := 'Borland TADOQuery -> Oracle OLEDB provider -> OCI8 -> Oracle';
end;

{---------------------------------------------------------------------------}
class function TADSpeedOra4OraADOQuery.AllocConnection: TObject;
begin
  Result := TADOConnection.Create(nil);
  with TADOConnection(Result) do begin
    LoginPrompt := False;
    Provider := 'OraOLEDB.Oracle.1';
  end;
end;

{---------------------------------------------------------------------------}
class procedure TADSpeedOra4OraADOQuery.OpenConnection(
  AConnection: TObject; const AConnDef: IADStanConnectionDef);
begin
  with TADOConnection(AConnection) do begin
    Connected := False;
    ConnectionString :=
      'Provider=OraOLEDB.Oracle.1;Password=' + AConnDef.Password + ';Persist Security Info=Tru' +
      'e;User ID=' + AConnDef.UserName + ';Data Source=' + AConnDef.Database + ';FetchSize=100;ChunkSize=32768';
    Connected := True;
  end;
end;

{---------------------------------------------------------------------------}
{ TADSpeedMs4OraADOQuery                                                    }
{---------------------------------------------------------------------------}
class function TADSpeedMs4OraADOQuery.GetName: String;
begin
  Result := 'MS TADOQuery';
end;

{---------------------------------------------------------------------------}
class function TADSpeedMs4OraADOQuery.GetDescription: String;
begin
  Result := 'Borland TADOQuery -> MS OLEDB provider -> OCI7 -> Oracle';
end;

{---------------------------------------------------------------------------}
class function TADSpeedMs4OraADOQuery.AllocConnection: TObject;
begin
  Result := TADOConnection.Create(nil);
  with TADOConnection(Result) do begin
    LoginPrompt := False;
    Provider := 'MSDAORA.1';
  end
end;

{---------------------------------------------------------------------------}
class procedure TADSpeedMs4OraADOQuery.OpenConnection(
  AConnection: TObject; const AConnDef: IADStanConnectionDef);
begin
  with TADOConnection(AConnection) do begin
    Connected := False;
    ConnectionString :=
      'Provider=MSDAORA.1;Password=' + AConnDef.Password + ';User ID=' + AConnDef.UserName +
      ';Data Source=' + AConnDef.Database + ';Persist Security Info=True';
    Connected := True;
  end;
end;
{$ENDIF}

{$IFDEF AnyDACSPEED_MSSQL}
{---------------------------------------------------------------------------}
{ TADSpeedMs4MssqlADOQuery                                                  }
{---------------------------------------------------------------------------}
class function TADSpeedMs4MssqlADOQuery.GetName: String;
begin
  Result := 'TADOQuery';
end;

{---------------------------------------------------------------------------}
class function TADSpeedMs4MssqlADOQuery.GetDescription: String;
begin
  Result := 'Borland TADOQuery -> MS OLEDB provider -> MSSQL';
end;

{---------------------------------------------------------------------------}
class function TADSpeedMs4MssqlADOQuery.AllocConnection: TObject;
begin
  Result := TADOConnection.Create(nil);
  with TADOConnection(Result) do begin
    LoginPrompt := False;
    Provider := 'SQLOLEDB.1';
  end
end;

{---------------------------------------------------------------------------}
class procedure TADSpeedMs4MssqlADOQuery.OpenConnection(
  AConnection: TObject; const AConnDef: IADStanConnectionDef);
begin
  with TADOConnection(AConnection) do begin
    Connected := False;
    ConnectionString :=
      'Provider=SQLOLEDB.1;Password=' + AConnDef.Password + ';Persist Security Info=True;' +
      'User ID=' + AConnDef.Username + ';Initial Catalog=' + AConnDef.Database + ';Data Source=' +
      AConnDef.AsString[S_AD_ConnParam_MSSQL_Server];
    Connected := True;
  end;
end;
{$ENDIF}

end.

