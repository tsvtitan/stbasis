{ ----------------------------------------------------------------------------- }
{ AnyDAC Advantage Database Server driver                                       }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{ ----------------------------------------------------------------------------- }
{$I daAD.inc}

unit daADPhysADS;

interface

uses
  daADPhysManager;

type
  TADPhysADSDriverLink = class(TADPhysDriverLinkBase)
  end;

{-------------------------------------------------------------------------------}
implementation

uses
  Classes, SysUtils,
{$IFDEF AnyDAC_D6Base}
  StrUtils,
{$ENDIF}
  daADStanConst, daADStanError, daADStanUtil,
  daADPhysIntf, daADPhysCmdGenerator, daADPhysODBCCli, daADPhysODBCWrapper,
    daADPhysODBCBase, daADPhysADSMeta;

type
  TADPhysODBCADSDriver = class;
  TADPhysODBCADSConnection = class;

  TADPhysODBCADSDriver = class(TADPhysODBCDriverBase)
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

  TADPhysODBCADSConnection = class (TADPhysODBCConnectionBase)
  protected
    class function GetDriverClass: TADPhysDriverClass; override;
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

{-------------------------------------------------------------------------------}
{ TADPhysODBCADSDriver                                                          }
{-------------------------------------------------------------------------------}
class function TADPhysODBCADSDriver.GetDriverID: String;
begin
  Result := S_AD_ADSId;
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCADSDriver.GetDescription: string;
begin
  Result := 'Advantage Database Server Driver';
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCADSDriver.GetODBCConnectStringKeywords(AKeywords: TStrings);
begin
  inherited GetODBCConnectStringKeywords(AKeywords);
  AKeywords.Add(S_AD_ConnParam_Common_Database + '=DataDirectory');
  AKeywords.Add(S_AD_ConnParam_ADS_DefaultType);
  AKeywords.Add(S_AD_ConnParam_ADS_ServerTypes);
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCADSDriver.GetODBCFixedPart: String;
begin
  Result := 'DRIVER={Advantage StreamlineSQL ODBC}';
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCADSDriver.GetConnParamCount(AKeys: TStrings): Integer;
begin
  Result := inherited GetConnParamCount(AKeys) + 3;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCADSDriver.GetConnParams(AKeys: TStrings; AIndex: Integer;
  var AName, AType, ADefVal, ACaption: String; var ALoginIndex: Integer);
begin
  ALoginIndex := -1;
  ADefVal := '';
  if AIndex < inherited GetConnParamCount(AKeys) then begin
    inherited GetConnParams(AKeys, AIndex, AName, AType, ADefVal, ACaption, ALoginIndex);
    if AName = S_AD_ConnParam_Common_Database then
      ALoginIndex := 2;
  end
  else begin
    case AIndex - inherited GetConnParamCount(AKeys) of
    0:
      begin
        AName := S_AD_ConnParam_ADS_DefaultType;
        AType := 'FoxPro;Advantage';
      end;
    1:
      begin
        AName := S_AD_ConnParam_ADS_ServerTypes;
        AType := '1;2;4';
      end;
    2:
      begin
        AName := S_AD_ConnParam_ADS_Locking;
        AType := 'Off;On';
      end;
    end;
    ACaption := AName;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADPhysODBCADSConnection                                                      }
{-------------------------------------------------------------------------------}
class function TADPhysODBCADSConnection.GetDriverClass: TADPhysDriverClass;
begin
  Result := TADPhysODBCADSDriver;
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCADSConnection.InternalCreateCommandGenerator(
  const ACommand: IADPhysCommand): TADPhysCommandGenerator;
begin
  if ACommand <> nil then
    Result := TADPhysADSCommandGenerator.Create(ACommand)
  else
    Result := TADPhysADSCommandGenerator.Create(Self);
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCADSConnection.InternalCreateMetadata: TObject;
begin
  Result := TADPhysADSMetadata.Create({$IFDEF AnyDAC_MONITOR} GetMonitor, {$ENDIF} Self);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCADSConnection.ParseError(AHandle: TODBCHandle;
  ARecNum: SQLSmallint; const ASQLState: String; ANativeError: SQLInteger;
  const ADiagMessage: String; const ACommandText: String; var AObj: String;
  var AKind: TADCommandExceptionKind; var ACmdOffset: Integer);
begin
  { TODO }
  inherited ParseError(AHandle, ARecNum, ASQLState, ANativeError,
    ADiagMessage, ACommandText, AObj, AKind, ACmdOffset);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCADSConnection.GetStrsMaxSizes(AStrDataType: SQLSmallint;
  AFixedLen, ANumeric: Boolean; out ACharSize: Integer; out AByteSize: Integer);
begin
  { TODO }
  AByteSize := 32766;
  ACharSize := AByteSize;
  case AStrDataType of
  SQL_C_CHAR, SQL_C_BINARY:
    if ANumeric then begin
      ACharSize := 30;
      AByteSize := 30 + 2;
    end;
  SQL_C_WCHAR:
    ACharSize := AByteSize div SizeOf(SQLWChar);
  else
    ADCapabilityNotSupported(Self, [S_AD_LPhys, S_AD_ADSId]);
  end;
end;

{-------------------------------------------------------------------------------}
initialization
  ADPhysManager();
  ADPhysManagerObj.RegisterPhysConnectionClass(TADPhysODBCADSConnection);

end.
