{ --------------------------------------------------------------------------- }
{ AnyDAC Speed Tester - dbExpress dataset unit                                }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I ..\ADSpeed.inc}

unit ADSpeedDbExpr;

interface

uses
  Classes, DB, DBClient, DBXpress, SqlExpr, DBLocalS, ADSpeedBase, ADSpeedBaseDB,
  daADStanIntf;

type
  TADSpeedDbExprQuery = class(TADSpeedCustomDBDataSet)
  private
    function GetQuery: TSQLQuery;
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
    property Query: TSQLQuery read GetQuery;
  end;

{$IFDEF AnyDACSPEED_ORA}
  TADSpeedOraDbExprQuery = class(TADSpeedDbExprQuery)
  public
    class function GetName: String; override;
    class function GetDescription: String; override;
    class function AllocConnection: TObject; override;
    class procedure OpenConnection(AConnection: TObject; const AConnDef: IADStanConnectionDef); override;
  end;

  TADSpeedCrlabOraDbExprQuery = class(TADSpeedDbExprQuery)
  public
    class function GetName: String; override;
    class function GetDescription: String; override;
    class function AllocConnection: TObject; override;
    class procedure OpenConnection(AConnection: TObject; const AConnDef: IADStanConnectionDef); override;
  end;

  TADSpeedCrlabNetOraDbExprQuery = class(TADSpeedDbExprQuery)
  public
    class function GetName: String; override;
    class function GetDescription: String; override;
    class function AllocConnection: TObject; override;
    class procedure OpenConnection(AConnection: TObject; const AConnDef: IADStanConnectionDef); override;
  end;
{$ENDIF}

{$IFDEF AnyDACSPEED_MSSQL}
  TADSpeedMssqlDbExprQuery = class(TADSpeedDbExprQuery)
  public
    class function GetName: String; override;
    class function GetDescription: String; override;
    class function AllocConnection: TObject; override;
    class procedure OpenConnection(AConnection: TObject; const AConnDef: IADStanConnectionDef); override;
  end;

  TADSpeedCrlabMssqlDbExprQuery = class(TADSpeedDbExprQuery)
  public
    class function GetName: String; override;
    class function GetDescription: String; override;
    class function AllocConnection: TObject; override;
    class procedure OpenConnection(AConnection: TObject; const AConnDef: IADStanConnectionDef); override;
  end;
{$ENDIF}

{$IFDEF AnyDACSPEED_ORA}
  TADSpeedCrlabOraSQLDataSetQuery = class(TADSpeedCustomDBDataSet)
  private
    function GetQuery: TSQLClientDataSet;
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
    class function GetDescription: String; override;
    class function GetName: String; override;
    class procedure OpenConnection(AConnection: TObject; const AConnDef: IADStanConnectionDef); override;
    class procedure CloseConnection(AConnection: TObject); override;
    class function GetCanExecute: Boolean; override;
    property Query: TSQLClientDataSet read GetQuery;
  end;
{$ENDIF}

implementation

uses
  DBLocal,
  daADStanConst;

{---------------------------------------------------------------------------}
{ TADSpeedDbExprQuery }

constructor TADSpeedDbExprQuery.Create;
begin
  inherited Create;
  DataSet := TSQLQuery.Create(nil);
  Query.NoMetadata := True;
end;

{---------------------------------------------------------------------------}
destructor TADSpeedDbExprQuery.Destroy;
begin
  DataSet.Free;
  DataSet := nil;
  inherited Destroy;
end;

{---------------------------------------------------------------------------}
// Query management

function TADSpeedDbExprQuery.GetQuery: TSQLQuery;
begin
  Result := DataSet as TSQLQuery;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedDbExprQuery.Setup(AFetchAll, AWithBlobs, AReadOnly: Boolean);
begin
  Query.GetMetadata := not AReadOnly;
end;

{---------------------------------------------------------------------------}
function TADSpeedDbExprQuery.GetSQL: String;
begin
  Result := Query.SQL.Text;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedDbExprQuery.SetSQL(const Value: String);
begin
  Query.SQL.Text := Value;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedDbExprQuery.DefineParam(const AName: String;
  ADataType: TFieldType; ADataSize: Integer; AParamType: TParamType);
var
  oPar: TParam;
begin
  oPar := Query.ParamByName(AName);
  if ADataType = ftFloat then
    ADataType := ftBCD
  else if ADataType = ftDateTime then
    ADataType := ftTimeStamp;
  oPar.DataType := ADataType;
  oPar.ParamType := AParamType;
  if ADataSize <> -1 then
    oPar.Size := ADataSize;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedDbExprQuery.Prepare;
begin
  Query.Prepared := True;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedDbExprQuery.UnPrepare;
begin
  Query.Prepared := False;
end;

{---------------------------------------------------------------------------}
function TADSpeedDbExprQuery.GetParam(AIndex: Integer): Variant;
begin
  Result := Query.Params[AIndex].Value;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedDbExprQuery.SetParam(AIndex: Integer;
  const AValue: Variant);
begin
  Query.Params[AIndex].Value := AValue;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedDbExprQuery.Execute;
begin
  Query.ExecSQL(False);
end;

{---------------------------------------------------------------------------}
// Connection management

procedure TADSpeedDbExprQuery.SetConnection(AConnection: TObject);
begin
  inherited SetConnection(AConnection);
  Query.SQLConnection := TSQLConnection(AConnection);
end;

{---------------------------------------------------------------------------}
procedure TADSpeedDbExprQuery.StartTransaction;
var
  TransDesc: TTransactionDesc;
begin
  FillChar(TransDesc, Sizeof(TransDesc), 0);
  TransDesc.TransactionID := 1;
  Query.SQLConnection.StartTransaction(TransDesc);
end;

{---------------------------------------------------------------------------}
procedure TADSpeedDbExprQuery.RollbackTransaction;
var
  TransDesc: TTransactionDesc;
begin
  FillChar(TransDesc, Sizeof(TransDesc), 0);
  TransDesc.TransactionID := 1;
  Query.SQLConnection.Rollback(TransDesc);
end;

{---------------------------------------------------------------------------}
class procedure TADSpeedDbExprQuery.CloseConnection(AConnection: TObject);
begin
  TSQLConnection(AConnection).Close;
end;

{$IFDEF AnyDACSPEED_ORA}
{---------------------------------------------------------------------------}
{ TADSpeedOraDbExprQuery                                                    }
{---------------------------------------------------------------------------}
class function TADSpeedOraDbExprQuery.GetName: String;
begin
  Result := 'Borl TSQLQuery';
end;

{---------------------------------------------------------------------------}
class function TADSpeedOraDbExprQuery.GetDescription: String;
begin
  Result := 'Borland TSQLQuery -> Borland dbExpr driver -> OCI8 -> Oracle';
end;

{---------------------------------------------------------------------------}
class function TADSpeedOraDbExprQuery.AllocConnection: TObject;
begin
  Result := TSQLConnection.Create(nil);
  with TSQLConnection(Result) do begin
    LoadParamsOnConnect := False;
    DriverName := 'XXXX';
    GetDriverFunc := 'getSQLDriverORACLE';
    LibraryName := 'dbexpora.dll';
    VendorLib := 'OCI.DLL';
    LoginPrompt := False;
    SQLHourGlass := False;
    Params.Add('BlobSize=-1');
    Params.Add('RowsetSize=100');
    Params.Add('ErrorResourceFile=');
    Params.Add('LocaleCode=0000');
    Params.Add('Oracle TransIsolation=ReadCommited');
    Params.Add('DataBase=');
    Params.Add('User_Name=');
    Params.Add('Password=');
  end;
end;

{---------------------------------------------------------------------------}
class procedure TADSpeedOraDbExprQuery.OpenConnection(AConnection: TObject;
  const AConnDef: IADStanConnectionDef);
begin
  with TSQLConnection(AConnection) do begin
    Connected := False;
    Params.Values['DataBase'] := AConnDef.Database;
    Params.Values['User_Name'] := AConnDef.UserName;
    Params.Values['Password'] := AConnDef.Password;
    Connected := True;
  end;
end;

{---------------------------------------------------------------------------}
{ TADSpeedCrlabOraDbExprQuery                                               }
{---------------------------------------------------------------------------}
class function TADSpeedCrlabOraDbExprQuery.GetName: String;
begin
  Result := 'Crlab TSQLQuery';
end;

{---------------------------------------------------------------------------}
class function TADSpeedCrlabOraDbExprQuery.GetDescription: String;
begin
  Result := 'Borland TSQLQuery -> CoreLab dbExpr driver -> OCI8 -> Oracle';
end;

{---------------------------------------------------------------------------}
class function TADSpeedCrlabOraDbExprQuery.AllocConnection: TObject;
begin
  Result := TSQLConnection.Create(nil);
  with TSQLConnection(Result) do begin
    LoadParamsOnConnect := False;
    DriverName := 'XXXX';
    GetDriverFunc := 'getSQLDriverORA';
    LibraryName := 'dbexpoda.dll';
    VendorLib := 'OCI.DLL';
    LoginPrompt := False;
    SQLHourGlass := False;
    Params.Add('BlobSize=-1');
    Params.Add('RowsetSize=100');
    Params.Add('ErrorResourceFile=');
    Params.Add('LocaleCode=0000');
    Params.Add('Oracle TransIsolation=ReadCommited');
    Params.Add('DataBase=');
    Params.Add('User_Name=');
    Params.Add('Password=');
  end;
end;

{---------------------------------------------------------------------------}
class procedure TADSpeedCrlabOraDbExprQuery.OpenConnection(
  AConnection: TObject; const AConnDef: IADStanConnectionDef);
begin
  with TSQLConnection(AConnection) do begin
    Connected := False;
    Params.Values['DataBase'] := AConnDef.Database;
    Params.Values['User_Name'] := AConnDef.UserName;
    Params.Values['Password'] := AConnDef.Password;
    Connected := True;
  end;
end;

{---------------------------------------------------------------------------}
{ TADSpeedCrlabNetOraDbExprQuery                                            }
{---------------------------------------------------------------------------}
class function TADSpeedCrlabNetOraDbExprQuery.GetName: String;
begin
  Result := 'Crlab/Net TSQLQuery';
end;

{---------------------------------------------------------------------------}
class function TADSpeedCrlabNetOraDbExprQuery.GetDescription: String;
begin
  Result := 'Borland TSQLQuery -> CoreLab dbExpr/Net driver -> Oracle';
end;

{---------------------------------------------------------------------------}
class function TADSpeedCrlabNetOraDbExprQuery.AllocConnection: TObject;
begin
  Result := TSQLConnection.Create(nil);
  with TSQLConnection(Result) do begin
    LoadParamsOnConnect := False;
    DriverName := 'XXXX';
    GetDriverFunc := 'getSQLDriverORANET';
    LibraryName := 'dbexpoda.dll';
    VendorLib := 'OCI.DLL';
    LoginPrompt := False;
    SQLHourGlass := False;
    Params.Add('BlobSize=-1');
    Params.Add('RowsetSize=100');
    Params.Add('ErrorResourceFile=');
    Params.Add('LocaleCode=0000');
    Params.Add('Oracle TransIsolation=ReadCommited');
    Params.Add('DataBase=');
    Params.Add('User_Name=');
    Params.Add('Password=');
  end;
end;

{---------------------------------------------------------------------------}
class procedure TADSpeedCrlabNetOraDbExprQuery.OpenConnection(
  AConnection: TObject; const AConnDef: IADStanConnectionDef);
begin
  with TSQLConnection(AConnection) do begin
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
{ TADSpeedMssqlDbExprQuery                                                  }
{---------------------------------------------------------------------------}
class function TADSpeedMssqlDbExprQuery.GetName: String;
begin
  Result := 'Borl TSQLQuery';
end;

{---------------------------------------------------------------------------}
class function TADSpeedMssqlDbExprQuery.GetDescription: String;
begin
  Result := 'Borland TSQLQuery -> Borland dbExpr driver -> MS OLEDB provider -> MSSQL';
end;

{---------------------------------------------------------------------------}
class function TADSpeedMssqlDbExprQuery.AllocConnection: TObject;
begin
  Result := TSQLConnection.Create(nil);
  with TSQLConnection(Result) do begin
    LoadParamsOnConnect := False;
    DriverName := 'XXXX';
    GetDriverFunc := 'getSQLDriverMSSQL';
    LibraryName := 'dbexpmss.dll';
    VendorLib := 'sqloledb.DLL';
    LoginPrompt := False;
    SQLHourGlass := False;
    Params.Add('HostName=');
    Params.Add('DataBase=');
    Params.Add('User_Name=');
    Params.Add('Password=');
    Params.Add('BlobSize=-1');
    Params.Add('ErrorResourceFile=');
    Params.Add('LocaleCode=0000');
    Params.Add('MSSQL TransIsolation=ReadCommited');
    Params.Add('OS Authentication=False');
  end;
end;

{---------------------------------------------------------------------------}
class procedure TADSpeedMssqlDbExprQuery.OpenConnection(
  AConnection: TObject; const AConnDef: IADStanConnectionDef);
begin
  with TSQLConnection(AConnection) do begin
    Connected := False;
    Params.Values['HostName'] := AConnDef.AsString[S_AD_ConnParam_MSSQL_Server];
    Params.Values['DataBase'] := AConnDef.Database;
    Params.Values['User_Name'] := AConnDef.UserName;
    Params.Values['Password'] := AConnDef.Password;
    Connected := True;
  end;
end;

{---------------------------------------------------------------------------}
{ TADSpeedCrlabMssqlDbExprQuery                                             }
{---------------------------------------------------------------------------}
class function TADSpeedCrlabMssqlDbExprQuery.GetName: String;
begin
  Result := 'CrLab TSQLQuery';
end;

{---------------------------------------------------------------------------}
class function TADSpeedCrlabMssqlDbExprQuery.GetDescription: String;
begin
  Result := 'Borland TSQLQuery -> CoreLab dbExpr driver -> MS OLEDB provider -> MSSQL';
end;

{---------------------------------------------------------------------------}
class function TADSpeedCrlabMssqlDbExprQuery.AllocConnection: TObject;
begin
  Result := TSQLConnection.Create(nil);
  with TSQLConnection(Result) do begin
    LoadParamsOnConnect := False;
    DriverName := 'XXXX';
    GetDriverFunc := 'getSQLDriverSQLServer';
    LibraryName := 'dbexpsda.dll';
    VendorLib := 'sqloledb.DLL';
    LoginPrompt := False;
    SQLHourGlass := False;
    Params.Add('BlobSize=-1');
    Params.Add('HostName=');
    Params.Add('DataBase=');
    Params.Add('User_Name=');
    Params.Add('Password=');
  end;
end;

{---------------------------------------------------------------------------}
class procedure TADSpeedCrlabMssqlDbExprQuery.OpenConnection(
  AConnection: TObject; const AConnDef: IADStanConnectionDef);
begin
  with TSQLConnection(AConnection) do begin
    Connected := False;
    Params.Values['HostName'] := AConnDef.AsString[S_AD_ConnParam_MSSQL_Server];
    Params.Values['DataBase'] := AConnDef.Database;
    Params.Values['User_Name'] := AConnDef.UserName;
    Params.Values['Password'] := AConnDef.Password;
    Connected := True;
  end;
end;
{$ENDIF}

{$IFDEF AnyDACSPEED_ORA}
{---------------------------------------------------------------------------}
{ TADSpeedCrlabOraSQLDataSetQuery                                           }
{---------------------------------------------------------------------------}
constructor TADSpeedCrlabOraSQLDataSetQuery.Create;
begin
  inherited Create;
  DataSet := TSQLClientDataSet.Create(nil);
end;

{---------------------------------------------------------------------------}
destructor TADSpeedCrlabOraSQLDataSetQuery.Destroy;
begin
  DataSet.Free;
  DataSet := nil;
  inherited Destroy;
end;

{---------------------------------------------------------------------------}
// Query management

function TADSpeedCrlabOraSQLDataSetQuery.GetQuery: TSQLClientDataSet;
begin
  Result := DataSet as TSQLClientDataSet;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedCrlabOraSQLDataSetQuery.Setup(AFetchAll, AWithBlobs, AReadOnly: Boolean);
begin
  if AFetchAll then
    Query.PacketRecords := 100
  else
    Query.PacketRecords := 1;
  Query.ReadOnly := AReadOnly;
end;

{---------------------------------------------------------------------------}
function TADSpeedCrlabOraSQLDataSetQuery.GetSQL: String;
begin
  Result := Query.CommandText;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedCrlabOraSQLDataSetQuery.SetSQL(const Value: String);
begin
  Query.CommandText := Value;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedCrlabOraSQLDataSetQuery.DefineParam(
  const AName: String; ADataType: TFieldType; ADataSize: Integer;
  AParamType: TParamType);
var
  oPar: TParam;
begin
  oPar := Query.Params.ParamByName(AName);
  if ADataType = ftFloat then
    ADataType := ftBCD
  else if ADataType = ftDateTime then
    ADataType := ftTimeStamp;
  oPar.DataType := ADataType;
  oPar.ParamType := AParamType;
  if ADataSize <> -1 then
    oPar.Size := ADataSize;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedCrlabOraSQLDataSetQuery.Prepare;
begin
end;

{---------------------------------------------------------------------------}
procedure TADSpeedCrlabOraSQLDataSetQuery.UnPrepare;
begin
end;

{---------------------------------------------------------------------------}
function TADSpeedCrlabOraSQLDataSetQuery.GetParam(
  AIndex: Integer): Variant;
begin
  Result := Query.Params[AIndex].Value;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedCrlabOraSQLDataSetQuery.SetParam(AIndex: Integer;
  const AValue: Variant);
begin
  Query.Params[AIndex].Value := AValue;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedCrlabOraSQLDataSetQuery.Execute;
begin
  Query.Execute;
end;

{---------------------------------------------------------------------------}
// Connection management

procedure TADSpeedCrlabOraSQLDataSetQuery.SetConnection(
  AConnection: TObject);
begin
  inherited SetConnection(AConnection);
  Query.DBConnection := TSQLConnection(AConnection);
end;

{---------------------------------------------------------------------------}
procedure TADSpeedCrlabOraSQLDataSetQuery.StartTransaction;
var
  TransDesc: TTransactionDesc;
begin
  FillChar(TransDesc, Sizeof(TransDesc), 0);
  TransDesc.TransactionID := 1;
  Query.DBConnection.StartTransaction(TransDesc);
end;

{---------------------------------------------------------------------------}
procedure TADSpeedCrlabOraSQLDataSetQuery.RollbackTransaction;
var
  TransDesc: TTransactionDesc;
begin
  FillChar(TransDesc, Sizeof(TransDesc), 0);
  TransDesc.TransactionID := 1;
  Query.DBConnection.Rollback(TransDesc);
end;

{---------------------------------------------------------------------------}
class function TADSpeedCrlabOraSQLDataSetQuery.GetName: String;
begin
  Result := 'CrLab TSQLClientDataSet';
end;

{---------------------------------------------------------------------------}
class function TADSpeedCrlabOraSQLDataSetQuery.GetDescription: String;
begin
  Result := 'Borland TSQLClientDataSet -> TSQLQuery -> CoreLab dbExpr driver -> Oracle';
end;

{---------------------------------------------------------------------------}
class function TADSpeedCrlabOraSQLDataSetQuery.GetCanExecute: Boolean;
begin
  Result := False;
end;

{---------------------------------------------------------------------------}
class function TADSpeedCrlabOraSQLDataSetQuery.AllocConnection: TObject;
begin
  Result := TSQLConnection.Create(nil);
  with TSQLConnection(Result) do begin
    LoadParamsOnConnect := False;
    DriverName := 'XXXX';
    GetDriverFunc := 'getSQLDriverORA';
    LibraryName := 'dbexpoda.dll';
    VendorLib := 'OCI.DLL';
    LoginPrompt := False;
    SQLHourGlass := False;
    Params.Add('BlobSize=-1');
    Params.Add('RowsetSize=100');
    Params.Add('ErrorResourceFile=');
    Params.Add('LocaleCode=0000');
    Params.Add('Oracle TransIsolation=ReadCommited');
    Params.Add('DataBase=');
    Params.Add('User_Name=');
    Params.Add('Password=');
  end;
end;

{---------------------------------------------------------------------------}
class procedure TADSpeedCrlabOraSQLDataSetQuery.OpenConnection(
  AConnection: TObject; const AConnDef: IADStanConnectionDef);
begin
  with TSQLConnection(AConnection) do begin
    Connected := False;
    Params.Values['DataBase'] := AConnDef.Database;
    Params.Values['User_Name'] := AConnDef.UserName;
    Params.Values['Password'] := AConnDef.Password;
    Connected := True;
  end;
end;

{---------------------------------------------------------------------------}
class procedure TADSpeedCrlabOraSQLDataSetQuery.CloseConnection(
  AConnection: TObject);
begin
  TSQLConnection(AConnection).Close;
end;
{$ENDIF}

end.

