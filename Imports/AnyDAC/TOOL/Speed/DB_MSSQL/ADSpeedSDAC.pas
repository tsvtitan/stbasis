{ --------------------------------------------------------------------------- }
{ AnyDAC Speed Tester - SDAC dataset unit                                     }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I ..\ADSpeed.inc}

unit ADSpeedSDAC;

interface

uses
  DB,
  daADStanIntf,
  ADSpeedBase, ADSpeedBaseDB,
  MemDS, MSAccess, OLEDBAccess;

type
  TADSpeedSDACQuery = class(TADSpeedCustomDBDataSet)
  private
    function GetQuery: TMSQuery;
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
    property Query: TMSQuery read GetQuery;
  end;

implementation

uses
  DBAccess, daADStanConst;

{---------------------------------------------------------------------------}
{ TADSpeedSDACQuery                                                         }
{---------------------------------------------------------------------------}
constructor TADSpeedSDACQuery.Create;
begin
  inherited Create;
  DataSet := TMSQuery.Create(nil);
end;

{---------------------------------------------------------------------------}
destructor TADSpeedSDACQuery.Destroy;
begin
  DataSet.Free;
  DataSet := nil;
  inherited Destroy;
end;

{---------------------------------------------------------------------------}
// Query management

function TADSpeedSDACQuery.GetQuery: TMSQuery;
begin
  Result := DataSet as TMSQuery;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedSDACQuery.Setup(AFetchAll, AWithBlobs, AReadOnly: Boolean);
begin
  if AFetchAll then begin
    Query.UniDirectional := True;
    Query.FetchAll := True;
    Query.FetchRows := 100;
  end
  else begin
    Query.UniDirectional := False;
    Query.FetchAll := False;
    Query.FetchRows := 1;
  end;
  Query.ReadOnly := AReadOnly;
end;

{---------------------------------------------------------------------------}
function TADSpeedSDACQuery.GetSQL: String;
begin
  Result := Query.SQL.Text;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedSDACQuery.SetSQL(const Value: String);
begin
  Query.SQL.Text := Value;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedSDACQuery.DefineParam(const AName: String;
  ADataType: TFieldType; ADataSize: Integer; AParamType: TParamType);
var
  oPar: TDAParam;
begin
  oPar := Query.ParamByName(AName);
  oPar.DataType := ADataType;
  if ADataSize <> -1 then
    oPar.Size := ADataSize;
  oPar.ParamType := AParamType;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedSDACQuery.Prepare;
begin
  Query.Prepare;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedSDACQuery.UnPrepare;
begin
  Query.UnPrepare;
end;

{---------------------------------------------------------------------------}
function TADSpeedSDACQuery.GetParam(AIndex: Integer): Variant;
begin
  Result := Query.Params[AIndex].Value;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedSDACQuery.SetParam(AIndex: Integer; const AValue: Variant);
begin
  Query.Params[AIndex].Value := AValue;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedSDACQuery.Execute;
begin
  Query.Execute;
end;

{---------------------------------------------------------------------------}
// Connection management

procedure TADSpeedSDACQuery.SetConnection(AConnection: TObject);
begin
  inherited SetConnection(AConnection);
  Query.Connection := (AConnection as TMSConnection);
end;

{---------------------------------------------------------------------------}
procedure TADSpeedSDACQuery.StartTransaction;
begin
  Query.Connection.StartTransaction;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedSDACQuery.RollbackTransaction;
begin
  Query.Connection.Rollback;
end;

{---------------------------------------------------------------------------}
class function TADSpeedSDACQuery.GetName: String;
begin
  Result := 'TMSQuery';
end;

{---------------------------------------------------------------------------}
class function TADSpeedSDACQuery.GetDescription: String;
begin
  Result := 'CoreLab TMSQuery -> MS OLEDB provider -> MSSQL';
end;

{---------------------------------------------------------------------------}
class function TADSpeedSDACQuery.AllocConnection: TObject;
begin
  Result := TMSConnection.Create(nil);
  with TMSConnection(Result) do
    LoginPrompt := False;
end;

{---------------------------------------------------------------------------}
class procedure TADSpeedSDACQuery.OpenConnection(AConnection: TObject;
  const AConnDef: IADStanConnectionDef);
begin
  with TMSConnection(AConnection) do begin
    Connected := False;
    Authentication := auServer;
    Server := AConnDef.AsString[S_AD_ConnParam_MSSQL_Server];
    Database := AConnDef.Database;
    UserName := AConnDef.Username;
    Password := AConnDef.Password;
    Connected := True;
  end;
end;

{---------------------------------------------------------------------------}
class procedure TADSpeedSDACQuery.CloseConnection(AConnection: TObject);
begin
  TMSConnection(AConnection).Close;
end;

end.

