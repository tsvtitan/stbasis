{ --------------------------------------------------------------------------- }
{ AnyDAC Speed Tester - AnyDAC dataset unit                                   }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I ..\ADSpeed.inc}

unit ADSpeedAD;

interface

uses
{$IFDEF AnyDAC_D6}
  Variants, FmtBCD, SqlTimSt,
{$ENDIF}
  DB, ADSpeedBase, ADSpeedBaseDB,
  daADStanIntf, daADCompClient, daADStanParam, daADStanOption;

type
  TADSpeedADQuery = class(TADSpeedCustomDBDataSet)
  private
    function GetQuery: TADQuery;
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
    property Query: TADQuery read GetQuery;
  end;

{$IFDEF AnyDACSPEED_ORA}
  TADSpeedDbxOraADQuery = class(TADSpeedADQuery)
  public
    class function GetName: String; override;
    class function GetDescription: String; override;
    class function AllocConnection: TObject; override;
    class procedure OpenConnection(AConnection: TObject; const AConnDef: IADStanConnectionDef); override;
  end;

  TADSpeedDirOraADQuery = class(TADSpeedADQuery)
  public
    class function GetName: String; override;
    class function GetDescription: String; override;
    class function AllocConnection: TObject; override;
    class procedure OpenConnection(AConnection: TObject; const AConnDef: IADStanConnectionDef); override;
  end;
{$ENDIF}

{$IFDEF AnyDACSPEED_MSSQL}
  TADSpeedDirMssqlADQuery = class(TADSpeedADQuery)
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
{ TADSpeedADQuery                                                           }
{---------------------------------------------------------------------------}
constructor TADSpeedADQuery.Create;
begin
  inherited Create;
  DataSet := TADQuery.Create(nil);
end;

{---------------------------------------------------------------------------}
destructor TADSpeedADQuery.Destroy;
begin
  DataSet.Free;
  DataSet := nil;
  inherited Destroy;
end;

{---------------------------------------------------------------------------}
// Query management

function TADSpeedADQuery.GetQuery: TADQuery;
begin
  Result := DataSet as TADQuery;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedADQuery.Setup(AFetchAll, AWithBlobs, AReadOnly: Boolean);
begin
  with Query.FetchOptions do begin
    if AFetchAll then begin
      RowsetSize := 100;
      Mode := fmAll;
    end
    else begin
      RowsetSize := 1;
      Mode := fmAll;
      //Mode := fmOnDemand;
    end;
    if AWithBlobs then
      Items := Items + [fiBlobs]
    else
      Items := Items - [fiBlobs];
  end;
  Query.UpdateOptions.RequestLive := not AReadOnly;
end;

{---------------------------------------------------------------------------}
function TADSpeedADQuery.GetSQL: String;
begin
  Result := Query.SQL.Text;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedADQuery.SetSQL(const Value: String);
begin
  Query.SQL.Text := Value;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedADQuery.DefineParam(const AName: String;
  ADataType: TFieldType; ADataSize: Integer; AParamType: TParamType);
var
  oPar: TADParam;
begin
  oPar := Query.ParamByName(AName);
{$IFDEF AnyDACSPEED_ORA}
  if Self is TADSpeedDirOraADQuery then
    oPar.DataType := ADataType
  else
{$ENDIF}
{$IFDEF AnyDAC_D6}
    // ??? following lines was for DBX only
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
  oPar.ArraySize := ArraySize;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedADQuery.Prepare;
begin
  Query.Prepare;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedADQuery.UnPrepare;
begin
  Query.UnPrepare;
end;

{---------------------------------------------------------------------------}
function TADSpeedADQuery.GetParam(AIndex: Integer): Variant;
begin
  Result := Query.Params[AIndex].Values[FArrayIndex];
end;

{---------------------------------------------------------------------------}
procedure TADSpeedADQuery.SetParam(AIndex: Integer;
  const AValue: Variant);
begin
{$IFDEF AnyDACSPEED_ORA}
  if Self is TADSpeedDirOraADQuery then
    Query.Params[AIndex].Values[FArrayIndex] := AValue
  else
{$ENDIF}
    with Query.Params[AIndex] do begin
{$IFDEF AnyDAC_D6}
      if DataType = ftFMTBcd then
        case VarType(AValue) of
        varSmallint, varInteger:
          AsFMTBCDs[FArrayIndex] := IntegerToBCD(AValue);
        varSingle, varDouble, varCurrency:
          AsFMTBCDs[FArrayIndex] := DoubleToBCD(AValue);
        else
          Values[FArrayIndex] := AValue;
        end
      else if DataType = ftTimeStamp then
        AsSQLTimeStamps[FArrayIndex] := DateTimeToSQLTimeStamp(AValue)
      else
{$ENDIF}
        Values[FArrayIndex] := AValue;
    end;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedADQuery.Execute;
begin
  Inc(FArrayIndex);
  if FArrayIndex = ArraySize then begin
    Query.Execute(ArraySize);
    FArrayIndex := 0;
  end;
end;

{---------------------------------------------------------------------------}
// Connection management

procedure TADSpeedADQuery.SetConnection(AConnection: TObject);
begin
  inherited SetConnection(AConnection);
  Query.Connection := (AConnection as TADConnection);
end;

{---------------------------------------------------------------------------}
procedure TADSpeedADQuery.StartTransaction;
begin
  Query.Connection.StartTransaction;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedADQuery.RollbackTransaction;
begin
  Query.Connection.Rollback;
end;

{---------------------------------------------------------------------------}
class procedure TADSpeedADQuery.CloseConnection(AConnection: TObject);
begin
  (AConnection as TADConnection).Close;
end;

{$IFDEF AnyDACSPEED_ORA}
{---------------------------------------------------------------------------}
{ TADSpeedDbxOraADQuery                                                     }
{---------------------------------------------------------------------------}
class function TADSpeedDbxOraADQuery.GetName: String;
begin
  Result := 'DBX TADQuery';
end;

{---------------------------------------------------------------------------}
class function TADSpeedDbxOraADQuery.GetDescription: String;
begin
  Result := 'da-soft AnyDAC TADQuery -> Borland dbExpress driver -> OCI8 -> Oracle';
end;

{---------------------------------------------------------------------------}
class function TADSpeedDbxOraADQuery.AllocConnection: TObject;
begin
  Result := TADConnection.Create(nil);
  with TADConnection(Result) do begin

{$IFDEF AnyDAC_D11}
    DriverName := 'TDBX';
    Params.Add('DriverID=TDBX');
{$ELSE}
    DriverName := 'DBX';
    Params.Add('DriverID=DBX');
{$ENDIF}

    Params.Add('DriverName=Oracle');
    Params.Add('RDBMS=Oracle');

    Params.Add('BlobSize=-1');
    Params.Add('ErrorResourceFile=');
    Params.Add('LocaleCode=0000');
    Params.Add('Oracle TransIsolation=ReadCommited');

    Params.Add('DataBase=');
    Params.Add('User_Name=');
    Params.Add('Password=');

    ADManager.SilentMode := True;
    LoginPrompt := False;
  end;
end;

{---------------------------------------------------------------------------}
class procedure TADSpeedDbxOraADQuery.OpenConnection(AConnection: TObject;
  const AConnDef: IADStanConnectionDef);
begin
  with TADConnection(AConnection) do begin
    Connected := False;
    Params.Values['DataBase'] := AConnDef.Database;
    Params.Values['User_Name'] := AConnDef.UserName;
    Params.Values['Password'] := AConnDef.Password;
    Connected := True;
  end;
end;

{---------------------------------------------------------------------------}
{ TADSpeedDirOraADQuery                                                     }
{---------------------------------------------------------------------------}
class function TADSpeedDirOraADQuery.GetName: String;
begin
  Result := 'TADQuery';
end;

{---------------------------------------------------------------------------}
class function TADSpeedDirOraADQuery.GetDescription: String;
begin
  Result := 'da-soft TADQuery -> OCI8 -> Oracle';
end;

{---------------------------------------------------------------------------}
class function TADSpeedDirOraADQuery.AllocConnection: TObject;
begin
  Result := TADConnection.Create(nil);
  with TADConnection(Result) do begin
    DriverName := 'Ora';
    Params.Add('DriverID=Ora');

    Params.Add('DataBase=');
    Params.Add('User_Name=');
    Params.Add('Password=');

    ADManager.SilentMode := True;
    LoginPrompt := False;
  end;
end;

{---------------------------------------------------------------------------}
class procedure TADSpeedDirOraADQuery.OpenConnection(
  AConnection: TObject; const AConnDef: IADStanConnectionDef);
begin
  with TADConnection(AConnection) do begin
    Connected := False;
    Params.Values['DataBase'] := AConnDef.Database;
    Params.Values['User_Name'] := AConnDef.UserName;
    Params.Values['Password'] := AConnDef.Password;
    Connected := True;
  end;
end;
{$ENDIF}

{$IFDEF AnyDACSPEED_MSSQL}
{---------------------------------------------------------------------------}
{ TADSpeedDirMssqlADQuery                                                   }
{---------------------------------------------------------------------------}
class function TADSpeedDirMssqlADQuery.GetName: String;
begin
  Result := 'TADQuery';
end;

{---------------------------------------------------------------------------}
class function TADSpeedDirMssqlADQuery.GetDescription: String;
begin
  Result := 'da-soft TADQuery -> SQL Server ODBC -> MSSQL';
end;

{---------------------------------------------------------------------------}
class function TADSpeedDirMssqlADQuery.AllocConnection: TObject;
begin
  Result := TADConnection.Create(nil);
  with TADConnection(Result) do begin
    FetchOptions.Items := FetchOptions.Items - [fiMeta];

    DriverName := 'MSSQL2000';

    Params.Add('Server=');
    Params.Add('User_Name=');
    Params.Add('Password=');
    Params.Add('Database=');

    ADManager.SilentMode := True;
    LoginPrompt := False;
  end;
end;

{---------------------------------------------------------------------------}
class procedure TADSpeedDirMssqlADQuery.OpenConnection(
  AConnection: TObject; const AConnDef: IADStanConnectionDef);
begin
  with TADConnection(AConnection) do begin
    Connected := False;
    Params.Values['Server'] := AConnDef.AsString[S_AD_ConnParam_MSSQL_Server];
    Params.Values['User_Name'] := AConnDef.Username;
    Params.Values['Password'] := AConnDef.Password;
    Params.Values['Database'] := AConnDef.Database;
    Connected := True;
  end;
end;
{$ENDIF}

end.

