{ --------------------------------------------------------------------------- }
{ AnyDAC Speed Tester - NCOCI8 dataset unit                                   }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I ..\ADSpeed.inc}

unit ADSpeedNCOCI8;

interface

uses
  Controls, DB, ADSpeedBase, ADSpeedBaseDB,
  NCOci, NCOciWrapper, NCOciDB, NCOciParams,
  daADStanIntf;

type
  TADSpeedNCOCI8Query = class(TADSpeedCustomDBDataSet)
  private
    function GetQuery: TOCIQuery;
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
    property Query: TOCIQuery read GetQuery;
  end;

implementation

{---------------------------------------------------------------------------}
{ TADSpeedNCOCI8Query                                                       }
{---------------------------------------------------------------------------}
constructor TADSpeedNCOCI8Query.Create;
begin
  inherited Create;
  DataSet := TOCIQuery.Create(nil);
end;

{---------------------------------------------------------------------------}
destructor TADSpeedNCOCI8Query.Destroy;
begin
  DataSet.Free;
  DataSet := nil;
  inherited Destroy;
end;

{---------------------------------------------------------------------------}
// Query management

function TADSpeedNCOCI8Query.GetQuery: TOCIQuery;
begin
  Result := DataSet as TOCIQuery;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedNCOCI8Query.Setup(AFetchAll, AWithBlobs, AReadOnly: Boolean);
begin
  if AFetchAll then begin
    //  Query.Unidirectional := True;
    Query.FetchParams.RowsetSize := 100;
  end
  else begin
    //  Query.Unidirectional := False;
    Query.FetchParams.RowsetSize := 1;
  end;
end;

{---------------------------------------------------------------------------}
function TADSpeedNCOCI8Query.GetSQL: String;
begin
  Result := Query.SQL.Text;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedNCOCI8Query.SetSQL(const Value: String);
begin
  Query.SQL.Text := Value;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedNCOCI8Query.DefineParam(const AName: String;
  ADataType: TFieldType; ADataSize: Integer; AParamType: TParamType);
var
  oPar: TOCIParam;
begin
  oPar := Query.ParamByName(AName);
  oPar.DataType := ADataType;
  if ADataSize <> -1 then
    oPar.ODataSize := ADataSize;
  oPar.ParamType := AParamType;
  oPar.ArrayLen := ArraySize;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedNCOCI8Query.Prepare;
begin
  Query.Prepare;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedNCOCI8Query.UnPrepare;
begin
  Query.UnPrepare;
end;

{---------------------------------------------------------------------------}
function TADSpeedNCOCI8Query.GetParam(AIndex: Integer): Variant;
begin
  Result := Query.Params[AIndex].Values[FArrayIndex];
end;

{---------------------------------------------------------------------------}
procedure TADSpeedNCOCI8Query.SetParam(AIndex: Integer;
  const AValue: Variant);
begin
  Query.Params[AIndex].Values[FArrayIndex] := AValue;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedNCOCI8Query.Execute;
begin
  Inc(FArrayIndex);
  if FArrayIndex = ArraySize then begin
    Query.ExecSQL(ArraySize);
    FArrayIndex := 0;
  end;
end;

{---------------------------------------------------------------------------}
// Connection management

procedure TADSpeedNCOCI8Query.SetConnection(AConnection: TObject);
begin
  inherited SetConnection(AConnection);
  Query.DatabaseName := (AConnection as TOCIDatabase).DatabaseName;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedNCOCI8Query.StartTransaction;
begin
  Query.PointedDatabase.StartTransaction;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedNCOCI8Query.RollbackTransaction;
begin
  Query.PointedDatabase.Rollback;
end;

{---------------------------------------------------------------------------}
class function TADSpeedNCOCI8Query.GetName: String;
begin
  Result := 'TOCIQuery';
end;

{---------------------------------------------------------------------------}
class function TADSpeedNCOCI8Query.GetDescription: String;
begin
  Result := 'da-soft TOCIQuery -> OCI8 -> Oracle';
end;

{---------------------------------------------------------------------------}
class function TADSpeedNCOCI8Query.AllocConnection: TObject;
begin
  Result := TOCIDatabase.Create(nil);
  with TOCIDatabase(Result) do begin
    DatabaseName := 'AnyDACSPEED_NCOCI_ORA';
    DefaultFetchParams.PieceBuffSize := 32768;
    DefaultFetchParams.PieceBuffOwn := True;
    DefaultFetchParams.RowsetSize := 50;
    LoginPrompt := False;
    SilentMode := True;
    ShowWaitForm := False;
    WaitCursor := crDefault;
  end;
end;

{---------------------------------------------------------------------------}
class procedure TADSpeedNCOCI8Query.OpenConnection(
  AConnection: TObject; const AConnDef: IADStanConnectionDef);
begin
  with TOCIDatabase(AConnection) do begin
    Connected := False;
    ServerName := AConnDef.Database;
    UserName := AConnDef.Username;
    Password := AConnDef.Password;
    Connected := True;
  end;
end;

{---------------------------------------------------------------------------}
class procedure TADSpeedNCOCI8Query.CloseConnection(AConnection: TObject);
begin
  TOCIDatabase(AConnection).Close;
end;

end.

