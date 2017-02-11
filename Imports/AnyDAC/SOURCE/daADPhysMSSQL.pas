{ ----------------------------------------------------------------------------- }
{ AnyDAC MSSQL driver                                                           }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{ ----------------------------------------------------------------------------- }
{$I daAD.inc}

unit daADPhysMSSQL;

interface

uses
  daADPhysManager;

type
  TADPhysMSSQLDriverLink = class(TADPhysDriverLinkBase)
  end;

{-------------------------------------------------------------------------------}
implementation

uses
  Windows, Classes, SysUtils, ComObj,
{$IFDEF AnyDAC_D6Base}
  StrUtils, Variants,
{$ENDIF}  
  daADStanConst, daADStanError, daADStanUtil,
  daADPhysIntf, daADPhysCmdGenerator, daADPhysODBCCli, daADPhysODBCWrapper,
    daADPhysODBCBase, daADPhysMSSQLMeta;

type
  TADPhysODBCMSSQLDriverBase = class;
  TADPhysODBCMSSQL2000Driver = class;
  TADPhysODBCMSSQL2005Driver = class;
  TADPhysODBCMSSQLConnectionBase = class;
  TADPhysODBCMSSQL2000Connection = class;
  TADPhysODBCMSSQL2005Connection = class;

  TADPhysODBCMSSQLDriverBase = class(TADPhysODBCDriverBase)
  protected
    procedure GetODBCConnectStringKeywords(AKeywords: TStrings); override;
    function GetConnParamCount(AKeys: TStrings): Integer; override;
    procedure GetConnParams(AKeys: TStrings; AIndex: Integer; var AName, AType,
      ADefVal, ACaption: String; var ALoginIndex: Integer); override;
  end;

  TADPhysODBCMSSQL2000Driver = class(TADPhysODBCMSSQLDriverBase)
  protected
    function GetODBCFixedPart: String; override;
    function GetDescription: string; override;
  public
    class function GetDriverID: String; override;
  end;

  TADPhysODBCMSSQL2005Driver = class(TADPhysODBCMSSQLDriverBase)
  protected
    function GetODBCFixedPart: String; override;
    function GetDescription: string; override;
  public
    class function GetDriverID: String; override;
  end;

  TADPhysODBCMSSQLConnectionBase = class(TADPhysODBCConnectionBase)
  protected
    function InternalCreateCommandGenerator(const ACommand:
      IADPhysCommand): TADPhysCommandGenerator; override;
    function InternalCreateMetadata: TObject; override;
    procedure ParseError(AHandle: TODBCHandle; ARecNum: SQLSmallint;
      const ASQLState: String; ANativeError: SQLInteger; const ADiagMessage: String;
      const ACommandText: String; var AObj: String; var AKind: TADCommandExceptionKind;
      var ACmdOffset: Integer); override;
    procedure GetStrsMaxSizes(AStrDataType: SQLSmallint; AFixedLen,
      ANumeric: Boolean; out ACharSize, AByteSize: Integer); override;
  end;

  TADPhysODBCMSSQL2000Connection = class(TADPhysODBCMSSQLConnectionBase)
  protected
    class function GetDriverClass: TADPhysDriverClass; override;
  end;

  TADPhysODBCMSSQL2005Connection = class(TADPhysODBCMSSQLConnectionBase)
  protected
    class function GetDriverClass: TADPhysDriverClass; override;
  end;

{-------------------------------------------------------------------------------}
{ TADPhysODBCMSSQLDriverBase                                                    }
{-------------------------------------------------------------------------------}
procedure TADPhysODBCMSSQLDriverBase.GetODBCConnectStringKeywords(AKeywords: TStrings);
begin
  inherited GetODBCConnectStringKeywords(AKeywords);
  AKeywords.Add(S_AD_ConnParam_MSSQL_Server);
  AKeywords.Add(S_AD_ConnParam_MSSQL_Network);
  AKeywords.Add(S_AD_ConnParam_MSSQL_Address);
  AKeywords.Add(S_AD_ConnParam_Common_Database);
  AKeywords.Add(S_AD_ConnParam_MSSQL_OSAuthentication + '=Trusted_Connection');
  AKeywords.Add(S_AD_ConnParam_MSSQL_Workstation + '=WSID');
  AKeywords.Add(S_AD_ConnParam_MSSQL_App);
  AKeywords.Add(S_AD_ConnParam_MSSQL_Language);
  AKeywords.Add(S_AD_ConnParam_MSSQL_Encrypt);
  AKeywords.Add('=DRIVER');
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCMSSQLDriverBase.GetConnParamCount(AKeys: TStrings): Integer;
begin
  Result := inherited GetConnParamCount(AKeys) + 10;
end;

{-------------------------------------------------------------------------------}
var
  FSQLServerList: String = '*';

procedure TADPhysODBCMSSQLDriverBase.GetConnParams(AKeys: TStrings; AIndex: Integer;
  var AName, AType, ADefVal, ACaption: String; var ALoginIndex: Integer);

{$IFNDEF AnyDAC_FPC}
  function EnumerateServers: String;
  var
    vDMO, vServers: OleVariant;
    oList: TStringList;
    i: Integer;
  begin
    if FSQLServerList = '*' then begin
      FSQLServerList := '';
      oList := TStringList.Create;
      oList.Sorted := True;
      oList.Duplicates := dupIgnore;
      try
        vDMO := CreateOleObject('SQLDMO.Application');
        vServers := vDMO.ListAvailableSQLServers;
        for i := 1 to vServers.Count do
          oList.Add(VarToStr(vServers.Item(i)));
        for i := 0 to oList.Count - 1 do begin
          if FSQLServerList <> '' then
            FSQLServerList := FSQLServerList + ';';
          FSQLServerList := FSQLServerList + oList[i];
        end;
      except
        // no exceptions visible
      end;
      oList.Free;
      if FSQLServerList = '' then
        FSQLServerList := '@S';
      vServers := UnAssigned;
      vDMO := UnAssigned;
    end;
    Result := FSQLServerList;
  end;
{$ENDIF}

begin
  ALoginIndex := -1;
  ADefVal := '';
  if AIndex < inherited GetConnParamCount(AKeys) then begin
    inherited GetConnParams(AKeys, AIndex, AName, AType, ADefVal, ACaption, ALoginIndex);
    if AName = S_AD_ConnParam_Common_Database then
      ALoginIndex := 4;
  end
  else begin
    case AIndex - inherited GetConnParamCount(AKeys) of
    0:
      begin
        AName := S_AD_ConnParam_MSSQL_Server;
{$IFNDEF AnyDAC_FPC}
        AType := EnumerateServers();
{$ELSE}
        AType := '';
{$ENDIF}
        ALoginIndex := 3;
      end;
    1:
      begin
        AName := S_AD_ConnParam_MSSQL_Network;
        AType := '@S';
      end;
    2:
      begin
        AName := S_AD_ConnParam_MSSQL_Address;
        AType := '@S';
      end;
    3:
      begin
        AName := S_AD_ConnParam_MSSQL_OSAuthentication;
        AType := '@Y';
        ALoginIndex := 2;
      end;
    4:
      begin
        AName := S_AD_ConnParam_MSSQL_Workstation;
        AType := '@S';
      end;
    5:
      begin
        AName := S_AD_ConnParam_MSSQL_App;
        AType := '@S';
      end;
    6:
      begin
        AName := S_AD_ConnParam_MSSQL_Language;
        AType := '@S';
      end;
    7:
      begin
        AName := S_AD_ConnParam_MSSQL_Encrypt;
        AType := '@Y';
      end;
    8:
      begin
        AName := S_AD_ConnParam_Common_MetaDefSchema;
        AType := '@S';
      end;
    9:
      begin
        AName := S_AD_ConnParam_Common_MetaDefCatalog;
        AType := '@S';
      end;
    end;
    ACaption := AName;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADPhysODBCMSSQL2000Driver                                                    }
{-------------------------------------------------------------------------------}
class function TADPhysODBCMSSQL2000Driver.GetDriverID: String;
begin
  Result := S_AD_MSSQL2000Id;
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCMSSQL2000Driver.GetDescription: string;
begin
  Result := 'MSSQL 2000 Driver';
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCMSSQL2000Driver.GetODBCFixedPart: String;
begin
  Result := 'DRIVER={SQL SERVER}';
end;

{-------------------------------------------------------------------------------}
{ TADPhysODBCMSSQL2005Driver                                                    }
{-------------------------------------------------------------------------------}
class function TADPhysODBCMSSQL2005Driver.GetDriverID: String;
begin
  Result := S_AD_MSSQL2005Id;
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCMSSQL2005Driver.GetDescription: string;
begin
  Result := 'MSSQL 2005 Native Client Driver';
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCMSSQL2005Driver.GetODBCFixedPart: String;
begin
  Result := 'DRIVER={SQL NATIVE CLIENT}';
end;

{-------------------------------------------------------------------------------}
{ TADPhysODBCMSSQLConnectionBase                                                }
{-------------------------------------------------------------------------------}
function TADPhysODBCMSSQLConnectionBase.InternalCreateCommandGenerator(
  const ACommand: IADPhysCommand): TADPhysCommandGenerator;
begin
  if ACommand <> nil then
    Result := TADPhysMSSQLCommandGenerator.Create(ACommand)
  else
    Result := TADPhysMSSQLCommandGenerator.Create(Self);
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCMSSQLConnectionBase.InternalCreateMetadata: TObject;
begin
  Result := TADPhysMSSQLMetadata.Create({$IFDEF AnyDAC_MONITOR} GetMonitor, {$ENDIF} Self);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCMSSQLConnectionBase.ParseError(AHandle: TODBCHandle;
  ARecNum: SQLSmallint; const ASQLState: String; ANativeError: SQLInteger;
  const ADiagMessage: String; const ACommandText: String; var AObj: String;
  var AKind: TADCommandExceptionKind; var ACmdOffset: Integer);

  procedure ExtractObjName;
  var
    i1, i2: Integer;
  begin
    i1 := Pos('''', ADiagMessage);
    if i1 <> 0 then begin
      i2 := ADPosEx('''', ADiagMessage, i1 + 1);
      if i2 <> 0 then
        AObj := Copy(ADiagMessage, i1 + 1, i2 - i1 - 1);
    end;
  end;

begin
  // following is not supported by MSSQL:
  // ekNoDataFound
  // ekUserPwdExpired
  // ekUserPwdWillExpire
  case ANativeError of
  1204,
  1222:
    AKind := ekRecordLocked;
  2601,
  2627:
    begin
      AKind := ekUKViolated;
      // first 'xxxx' - constraint name
      // second 'xxxx' - table name
      ExtractObjName;
    end;
  547:
    begin
      if Pos('COLUMN FOREIGN KEY', ADiagMessage) <> 0 then begin
        AKind := ekFKViolated;
        // first 'xxxx' - constraint name
        // next 3 'xxxx' - full column name (database, table, column)
        ExtractObjName;
      end;
    end;
  208,
  3701:
    begin
      AKind := ekObjNotExists;
      // first 'xxxx' - object name
      ExtractObjName;
    end;
  18456:
    AKind := ekUserPwdInvalid;
  else
    inherited ParseError(AHandle, ARecNum, ASQLState, ANativeError,
      ADiagMessage, ACommandText, AObj, AKind, ACmdOffset);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCMSSQLConnectionBase.GetStrsMaxSizes(AStrDataType: SQLSmallint;
  AFixedLen, ANumeric: Boolean; out ACharSize: Integer; out AByteSize: Integer);
begin
  AByteSize := 8000;
  ACharSize := AByteSize;
  case AStrDataType of
  SQL_C_CHAR, SQL_C_BINARY:
    if ANumeric then begin
      ACharSize := 38;
      AByteSize := 38 + 2;
    end;
  SQL_C_WCHAR:
    ACharSize := AByteSize div SizeOf(SQLWChar);
  else
    ADCapabilityNotSupported(Self, [S_AD_LPhys, GetDriverClass.GetDriverID]);
  end;
end;

{-------------------------------------------------------------------------------}
{ TADPhysODBCMSSQL2000Connection                                                }
{-------------------------------------------------------------------------------}
class function TADPhysODBCMSSQL2000Connection.GetDriverClass: TADPhysDriverClass;
begin
  Result := TADPhysODBCMSSQL2000Driver;
end;

{-------------------------------------------------------------------------------}
{ TADPhysODBCMSSQL2005Connection                                                }
{-------------------------------------------------------------------------------}
class function TADPhysODBCMSSQL2005Connection.GetDriverClass: TADPhysDriverClass;
begin
  Result := TADPhysODBCMSSQL2005Driver;
end;

{-------------------------------------------------------------------------------}
initialization
  ADPhysManager();
  ADPhysManagerObj.RegisterPhysConnectionClass(TADPhysODBCMSSQL2000Connection);
  ADPhysManagerObj.RegisterPhysConnectionClass(TADPhysODBCMSSQL2005Connection);

end.
