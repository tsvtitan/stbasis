{ --------------------------------------------------------------------------- }
{ AnyDAC Speed Tester - ODAC dataset unit                                     }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I ..\ADSpeed.inc}

unit ADSpeedODAC;

interface

uses
  DB, MemDS, DBAccess, Ora, OraSmart, ADSpeedBase, ADSpeedBaseDB, Controls,
  daADStanIntf;

type
  TADSpeedODACQuery = class(TADSpeedCustomDBDataSet)
  private
    function GetQuery: TSmartQuery;
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
    property Query: TSmartQuery read GetQuery;
  end;

implementation

type
  __TSmartQuery = class(TSmartQuery)
  end;

{---------------------------------------------------------------------------}
{ TADSpeedODACQuery                                                         }
{---------------------------------------------------------------------------}
constructor TADSpeedODACQuery.Create;
begin
  inherited Create;
  DataSet := TSmartQuery.Create(nil);
  Query.OptionsDS.KeepPrepared := True;
end;

{---------------------------------------------------------------------------}
destructor TADSpeedODACQuery.Destroy;
begin
  DataSet.Free;
  DataSet := nil;
  inherited Destroy;
end;

{---------------------------------------------------------------------------}
// Query management

function TADSpeedODACQuery.GetQuery: TSmartQuery;
begin
  Result := DataSet as TSmartQuery;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedODACQuery.Setup(AFetchAll, AWithBlobs, AReadOnly: Boolean);
begin
  if AFetchAll then begin
    //  Query.Unidirectional := True;
    Query.FetchRows := 100;
  end
  else begin
    //  Query.Unidirectional := False;
    Query.FetchRows := 1;
  end;
  Query.ReadOnly := AReadOnly;
end;

{---------------------------------------------------------------------------}
function TADSpeedODACQuery.GetSQL: String;
begin
  Result := Query.SQL.Text;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedODACQuery.SetSQL(const Value: String);
begin
  Query.SQL.Text := Value;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedODACQuery.DefineParam(const AName: String;
  ADataType: TFieldType; ADataSize: Integer; AParamType: TParamType);
var
  oPar: TOraParam;
begin
  oPar := Query.ParamByName(AName);
  oPar.DataType := ADataType;
  if ADataSize <> -1 then
    oPar.Size := ADataSize;
  oPar.ParamType := AParamType;
  oPar.Length := ArraySize;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedODACQuery.Prepare;
begin
  Query.Prepare;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedODACQuery.UnPrepare;
begin
  Query.UnPrepare;
end;

{---------------------------------------------------------------------------}
function TADSpeedODACQuery.GetParam(AIndex: Integer): Variant;
begin
  Result := Query.Params[AIndex].ItemValue[FArrayIndex + 1];
end;

{---------------------------------------------------------------------------}
procedure TADSpeedODACQuery.SetParam(AIndex: Integer; const AValue: Variant);
begin
  Query.Params[AIndex].ItemValue[FArrayIndex + 1] := AValue;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedODACQuery.Execute;
begin
  Inc(FArrayIndex);
  if FArrayIndex = ArraySize then begin
    __TSmartQuery(Query).FCommand.Execute(ArraySize);
    FArrayIndex := 0;
  end;
end;

{---------------------------------------------------------------------------}
// Connection management

procedure TADSpeedODACQuery.SetConnection(AConnection: TObject);
begin
  inherited SetConnection(AConnection);
  Query.Session := (AConnection as TOraSession);
end;

{---------------------------------------------------------------------------}
procedure TADSpeedODACQuery.StartTransaction;
begin
  Query.Session.StartTransaction;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedODACQuery.RollbackTransaction;
begin
  Query.Session.Rollback;
end;

{---------------------------------------------------------------------------}
class function TADSpeedODACQuery.GetName: String;
begin
  Result := 'TSmartQuery';
end;

{---------------------------------------------------------------------------}
class function TADSpeedODACQuery.GetDescription: String;
begin
  Result := 'CoreLab TSmartQuery -> OCI8 -> Oracle';
end;

{---------------------------------------------------------------------------}
class function TADSpeedODACQuery.AllocConnection: TObject;
begin
  Result := TOraSession.Create(nil);
  with TOraSession(Result) do
    ConnectPrompt := False;
end;

{---------------------------------------------------------------------------}
class procedure TADSpeedODACQuery.OpenConnection(
  AConnection: TObject; const AConnDef: IADStanConnectionDef);
begin
  with TOraSession(AConnection) do begin
    Connected := False;
    Server := AConnDef.Database;
    UserName := AConnDef.UserName;
    Password := AConnDef.Password;
    Connected := True;
  end;
end;

{---------------------------------------------------------------------------}
class procedure TADSpeedODACQuery.CloseConnection(AConnection: TObject);
begin
  TOraSession(AConnection).Close;
end;

end.

