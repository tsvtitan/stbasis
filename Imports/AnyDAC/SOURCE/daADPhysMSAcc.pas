{ ----------------------------------------------------------------------------- }
{ AnyDAC ODBC MS Access driver                                                  }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{ ----------------------------------------------------------------------------- }
{$I daAD.inc}

unit daADPhysMSAcc;

interface

uses
  daADPhysManager;

type
  TADPhysMSAccessDriverLink = class(TADPhysDriverLinkBase)
  end;

{-------------------------------------------------------------------------------}
implementation

uses
  Classes, SysUtils,
  daADStanConst, daADStanError, daADStanUtil,
  daADPhysIntf, daADPhysCmdGenerator, daADPhysODBCCli, daADPhysODBCWrapper,
    daADPhysODBCBase, daADPhysMSAccMeta;

type
  TADPhysODBCMSAccessDriver = class;
  TADPhysODBCMSAccessConnection = class;

  TADPhysODBCMSAccessDriver = class(TADPhysODBCDriverBase)
  protected
    procedure GetODBCConnectStringKeywords(AKeywords: TStrings); override;
    function GetODBCFixedPart: String; override;
    function GetDescription: string; override;
    function GetConnParamCount(AKeys: TStrings): Integer; override;
    procedure GetConnParams(AKeys: TStrings; AIndex: Integer; var AName,
      AType, ADefVal, ACaption: String; var ALoginIndex: Integer); override;
  public
    class function GetDriverID: String; override;
  end;

  TADPhysODBCMSAccessConnection = class(TADPhysODBCConnectionBase)
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
{ TADPhysODBCMSAccessDriver                                                     }
{-------------------------------------------------------------------------------}
class function TADPhysODBCMSAccessDriver.GetDriverID: String;
begin
  Result := S_AD_MSAccId;
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCMSAccessDriver.GetDescription: string;
begin
  Result := 'MS Access Driver';
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCMSAccessDriver.GetODBCConnectStringKeywords(AKeywords: TStrings);
begin
  AKeywords.Add(S_AD_ConnParam_Common_Database + '=DBQ');
  AKeywords.Add(S_AD_ConnParam_MSAcc_SysDB);
  AKeywords.Add(S_AD_ConnParam_MSAcc_RO);
  AKeywords.Add('=DRIVER');
  AKeywords.Add('=ExtendedAnsiSQL');
  inherited GetODBCConnectStringKeywords(AKeywords);
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCMSAccessDriver.GetODBCFixedPart: String;
begin
  Result := 'DRIVER={Microsoft Access Driver (*.mdb)};ExtendedAnsiSQL=1';
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCMSAccessDriver.GetConnParamCount(AKeys: TStrings): Integer;
begin
  Result := inherited GetConnParamCount(AKeys) + 2;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCMSAccessDriver.GetConnParams(AKeys: TStrings; AIndex: Integer;
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
        AName := S_AD_ConnParam_MSAcc_SysDB;
        AType := '@S';
      end;
    1:
      begin
        AName := S_AD_ConnParam_MSAcc_RO;
        AType := '@L';
      end;
    end;
    ACaption := AName;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADPhysODBCMSAccessConnection                                                 }
{-------------------------------------------------------------------------------}
class function TADPhysODBCMSAccessConnection.GetDriverClass: TADPhysDriverClass;
begin
  Result := TADPhysODBCMSAccessDriver;
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCMSAccessConnection.InternalCreateCommandGenerator(
  const ACommand: IADPhysCommand): TADPhysCommandGenerator;
begin
  if ACommand <> nil then
    Result := TADPhysMSAccCommandGenerator.Create(ACommand)
  else
    Result := TADPhysMSAccCommandGenerator.Create(Self);
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCMSAccessConnection.InternalCreateMetadata: TObject;
begin
  Result := TADPhysMSAccMetadata.Create({$IFDEF AnyDAC_MONITOR} GetMonitor, {$ENDIF} Self);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCMSAccessConnection.ParseError(AHandle: TODBCHandle;
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
  // following is not supported by MSAccess:
  // ekNoDataFound
  // ekUserPwdExpired
  // ekUserPwdWillExpire
  case ANativeError of
  -1102:
    AKind := ekRecordLocked;
  -1605:
    AKind := ekUKViolated;
  -1613:
    AKind := ekFKViolated;
  -1305:
    begin
      AKind := ekObjNotExists;
      // first 'xxxx' - object name
      ExtractObjName;
    end;
  -1905:
    AKind := ekUserPwdInvalid;
  else
    inherited ParseError(AHandle, ARecNum, ASQLState, ANativeError,
      ADiagMessage, ACommandText, AObj, AKind, ACmdOffset);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCMSAccessConnection.GetStrsMaxSizes(AStrDataType: SQLSmallint;
  AFixedLen, ANumeric: Boolean; out ACharSize: Integer; out AByteSize: Integer);
begin
  case AStrDataType of
  SQL_C_CHAR, SQL_C_WCHAR:
    begin
      ACharSize := 255;
      if ANumeric then
        ACharSize := 38;
    end;
  SQL_C_BINARY:
    ACharSize := 510;
  else
    ADCapabilityNotSupported(Self, [S_AD_LPhys, S_AD_MSAccId]);
  end;
  AByteSize := ACharSize;
  if AStrDataType = SQL_C_WCHAR then
    AByteSize := AByteSize * SizeOf(SQLWChar);
  if ANumeric then
    Inc(AByteSize, 2);
end;

{-------------------------------------------------------------------------------}
initialization
  ADPhysManager();
  ADPhysManagerObj.RegisterPhysConnectionClass(TADPhysODBCMSAccessConnection);

end.
