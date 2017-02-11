{ ----------------------------------------------------------------------------- }
{ AnyDAC ODBC generic source driver                                             }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{ ----------------------------------------------------------------------------- }
{$I daAD.inc}

unit daADPhysODBC;

interface

uses
  daADPhysManager;

type
  TADPhysODBCDriverLink = class(TADPhysDriverLinkBase)
  end;

{-------------------------------------------------------------------------------}
implementation

uses
  SysUtils, Classes,
  daADStanIntf, daADStanConst,
  daADPhysIntf, daADPhysCmdGenerator, daADPhysODBCBase, daADPhysConnMeta,
    daADPhysODBCCli, daADPhysODBCWrapper, daADPhysMSSQLMeta, daADPhysMSAccMeta,
    daADPhysDB2Meta, daADPhysOraclMeta, daADPhysASAMeta, daADPhysMySQLMeta,
    daADPhysADSMeta, daADPhysODBCMeta;

type
  TADPhysODBCDriver = class;
  TADPhysODBCConnection = class;

  TADPhysODBCDriver = class(TADPhysODBCDriverBase)
  protected
    procedure GetODBCConnectStringKeywords(AKeywords: TStrings); override;
    function GetODBCFixedPart: String; override;
    function GetConnParamCount(AKeys: TStrings): Integer; override;
    procedure GetConnParams(AKeys: TStrings; AIndex: Integer; var AName, AType,
      ADefVal, ACaption: String; var ALoginIndex: Integer); override;
    function GetDescription: string; override;
  public
    class function GetDriverID: String; override;
  end;

  TADPhysODBCConnection = class(TADPhysODBCConnectionBase)
  private
    FRdbmsKind: TADRDBMSKind;
    procedure UpdateRDBMSKind;
  protected
    class function GetDriverClass: TADPhysDriverClass; override;
    function InternalCreateCommandGenerator(
      const ACommand: IADPhysCommand): TADPhysCommandGenerator; override;
    function InternalCreateMetadata: TObject; override;
    procedure InternalConnect; override;
    procedure GetStrsMaxSizes(AStrDataType: SQLSmallint; AFixedLen,
      ANumeric: Boolean; out ACharSize, AByteSize: Integer); override;
  public
    constructor Create(ADriverObj: TADPhysDriver; const ADriver: IADPhysDriver;
      AConnHost: TADPhysConnectionHost); override;
  end;

{-------------------------------------------------------------------------------}
{ TADPhysODBCDriver                                                             }
{-------------------------------------------------------------------------------}
class function TADPhysODBCDriver.GetDriverID: String;
begin
  Result := S_AD_ODBCId;
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCDriver.GetDescription: string;
begin
  Result := 'ODBC Driver';
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCDriver.GetODBCConnectStringKeywords(AKeywords: TStrings);
begin
  AKeywords.Add(S_AD_ConnParam_ODBC_Driver);
  AKeywords.Add(S_AD_ConnParam_ODBC_DataSource + '=DSN');
  AKeywords.Add(S_AD_ConnParam_Common_Database + '=DBQ');
  inherited GetODBCConnectStringKeywords(AKeywords);
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCDriver.GetODBCFixedPart: String;
begin
  Result := '';
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCDriver.GetConnParamCount(AKeys: TStrings): Integer;
begin
  Result := inherited GetConnParamCount(AKeys) + 5;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCDriver.GetConnParams(AKeys: TStrings; AIndex: Integer;
  var AName, AType, ADefVal, ACaption: String; var ALoginIndex: Integer);
var
  j: TADRDBMSKind;
  sDSN, sDesc: String;
  sDriver, sAttr: String;
begin
  ALoginIndex := -1;
  ADefVal := '';
  if AIndex < inherited GetConnParamCount(AKeys) then
    inherited GetConnParams(AKeys, AIndex, AName, AType, ADefVal, ACaption, ALoginIndex)
  else begin
    case AIndex - inherited GetConnParamCount(AKeys) of
    0:
      begin
        AName := S_AD_ConnParam_ODBC_Driver;
        AType := '';
        with ODBCEnvironment do
          if DriverFirst(sDriver, sAttr) then
            repeat
              if AType <> '' then
                AType := AType + ';';
              AType := AType + TODBCLib.DecorateKeyValue(sDriver);
            until not DriverNext(sDriver, sAttr);
      end;
    1:
      begin
        AName := S_AD_ConnParam_ODBC_DataSource;
        AType := '';
        with ODBCEnvironment do
          if DSNFirst(sDSN, sDesc) then
            repeat
              if AType <> '' then
                AType := AType + ';';
              AType := AType + TODBCLib.DecorateKeyValue(sDSN);
            until not DSNNext(sDSN, sDesc);
        ALoginIndex := 2;
      end;
    2:
      begin
        AName := S_AD_ConnParam_Common_MetaDefSchema;
        AType := '@S';
      end;
    3:
      begin
        AName := S_AD_ConnParam_Common_MetaDefCatalog;
        AType := '@S';
      end;
    4:
      begin
        AName := S_AD_ConnParam_Common_RDBMSKind;
        AType := '';
        for j := Low(TADRDBMSKind) to High(TADRDBMSKind) do begin
          if AType <> '' then
            AType := AType + ';';
          AType := AType + C_AD_PhysRDBMSKinds[j];
        end;
      end;
    end;
    ACaption := AName;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADPhysODBCConnection                                                         }
{-------------------------------------------------------------------------------}
constructor TADPhysODBCConnection.Create(ADriverObj: TADPhysDriver;
  const ADriver: IADPhysDriver; AConnHost: TADPhysConnectionHost);
begin
  inherited Create(ADriverObj, ADriver, AConnHost);
  UpdateRDBMSKind;
end;

{-------------------------------------------------------------------------------}
class function TADPhysODBCConnection.GetDriverClass: TADPhysDriverClass;
begin
  Result := TADPhysODBCDriver;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCConnection.UpdateRDBMSKind;
var
  i: TADRDBMSKind;
  s: string;

  function Match(const AName: String): Boolean;
  begin
    Result := Copy(s, 1, Length(AName)) = AName;
  end;

begin
  if FRdbmsKind = mkUnknown then begin
    s := UpperCase(GetConnectionDef.AsString[S_AD_ConnParam_Common_RDBMSKind]);
    if s <> '' then
      for i := Low(TADRDBMSKind) to High(TADRDBMSKind) do
        if C_AD_PhysRDBMSKinds[i] = s then begin
          FRdbmsKind := i;
          Exit;
        end;
  end;
  if (FRdbmsKind = mkUnknown) and Connected then
    FRdbmsKind := ODBCConnection.RdbmsKind;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCConnection.InternalConnect;
begin
  inherited InternalConnect;
  FRdbmsKind := mkUnknown;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCConnection.GetStrsMaxSizes(AStrDataType: SQLSmallint;
  AFixedLen, ANumeric: Boolean; out ACharSize, AByteSize: Integer);
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCConnection.InternalCreateCommandGenerator(const ACommand:
  IADPhysCommand): TADPhysCommandGenerator;
begin
  UpdateRDBMSKind;
  if ACommand <> nil then
    case FRdbmsKind of
    mkOracle:   Result := TADPhysOraCommandGenerator.Create(ACommand);
    mkMSSQL:    Result := TADPhysMSSQLCommandGenerator.Create(ACommand);
    mkMSAccess: Result := TADPhysMSAccCommandGenerator.Create(ACommand);
    mkMySQL:    Result := TADPhysMySQLCommandGenerator.Create(ACommand);
    mkDb2:      Result := TADPhysDb2CommandGenerator.Create(ACommand);
    mkASA:      Result := TADPhysASACommandGenerator.Create(ACommand);
    mkADS:      Result := TADPhysADSCommandGenerator.Create(ACommand);
    else        Result := TADPhysCommandGenerator.Create(ACommand);
    end
  else
    case FRdbmsKind of
    mkOracle:   Result := TADPhysOraCommandGenerator.Create(Self);
    mkMSSQL:    Result := TADPhysMSSQLCommandGenerator.Create(Self);
    mkMSAccess: Result := TADPhysMSAccCommandGenerator.Create(Self);
    mkMySQL:    Result := TADPhysMySQLCommandGenerator.Create(Self);
    mkDb2:      Result := TADPhysDb2CommandGenerator.Create(Self);
    mkASA:      Result := TADPhysASACommandGenerator.Create(Self);
    mkADS:      Result := TADPhysADSCommandGenerator.Create(Self);
    else        Result := TADPhysCommandGenerator.Create(Self);
    end
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCConnection.InternalCreateMetadata: TObject;
begin
  UpdateRDBMSKind;
  case FRdbmsKind of
  mkOracle:   Result := TADPhysOraMetadata.Create({$IFDEF AnyDAC_MONITOR} GetMonitor, {$ENDIF} Self, 0, 0);
  mkMSSQL:    Result := TADPhysMSSQLMetadata.Create({$IFDEF AnyDAC_MONITOR} GetMonitor, {$ENDIF} Self);
  mkMSAccess: Result := TADPhysMSAccMetadata.Create({$IFDEF AnyDAC_MONITOR} GetMonitor, {$ENDIF} Self);
  mkMySQL:    Result := TADPhysMySQLMetadata.Create({$IFDEF AnyDAC_MONITOR} GetMonitor, {$ENDIF} Self, 0, 0, False);
  mkDb2:      Result := TADPhysDb2Metadata.Create({$IFDEF AnyDAC_MONITOR} GetMonitor, {$ENDIF} Self);
  mkASA:      Result := TADPhysASAMetadata.Create({$IFDEF AnyDAC_MONITOR} GetMonitor, {$ENDIF} Self);
  mkADS:      Result := TADPhysADSMetadata.Create({$IFDEF AnyDAC_MONITOR} GetMonitor, {$ENDIF} Self);
  else        Result := nil;
  end;
  Result := TADPhysODBCMetadata.Create({$IFDEF AnyDAC_MONITOR} GetMonitor, {$ENDIF}
    Self, Self, TADPhysConnectionMetadata(Result));
end;

{-------------------------------------------------------------------------------}
initialization
  ADPhysManager();
  ADPhysManagerObj.RegisterPhysConnectionClass(TADPhysODBCConnection);

end.
