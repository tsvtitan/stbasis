{ ----------------------------------------------------------------------------- }
{ AnyDAC Adaptive Server Anywhere driver                                        }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{ ----------------------------------------------------------------------------- }
{$I daAD.inc}

unit daADPhysASA;

interface

uses
  daADPhysManager;

type
  TADPhysASADriverLink = class(TADPhysDriverLinkBase)
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
    daADPhysODBCBase, daADPhysASAMeta;

type
  TADPhysODBCASADriver = class;
  TADPhysODBCASAConnection = class;

  TADPhysODBCASADriver = class(TADPhysODBCDriverBase)
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

  TADPhysODBCASAConnection = class (TADPhysODBCConnectionBase)
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
{ TADPhysODBCASADriver                                                          }
{-------------------------------------------------------------------------------}
class function TADPhysODBCASADriver.GetDriverID: String;
begin
  Result := S_AD_ASAId;
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCASADriver.GetDescription: string;
begin
  Result := 'Sybase ASA Driver';
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCASADriver.GetODBCConnectStringKeywords(AKeywords: TStrings);
begin
  inherited GetODBCConnectStringKeywords(AKeywords);
  AKeywords.Add(S_AD_ConnParam_ASA_Server);
  AKeywords.Add(S_AD_ConnParam_Common_Database + '=DatabaseName');
  AKeywords.Add(S_AD_ConnParam_ASA_DatabaseFile);
  AKeywords.Add(S_AD_ConnParam_ASA_OSAuthentication + '=Integrated');
  AKeywords.Add(S_AD_ConnParam_ASA_App + '=AppInfo');
  AKeywords.Add(S_AD_ConnParam_ASA_Compress);
  AKeywords.Add(S_AD_ConnParam_ASA_Encrypt + '=Encryption');
  AKeywords.Add('=DRIVER');
  AKeywords.Add('=COMMLINKS');
  AKeywords.Add('=DELPHI');
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCASADriver.GetODBCFixedPart: String;
begin
  Result := 'DRIVER={Adaptive Server Anywhere 8.0};CommLinks=ShMem,TCP;Delphi=Yes';
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCASADriver.GetConnParamCount(AKeys: TStrings): Integer;
begin
  Result := inherited GetConnParamCount(AKeys) + 8;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCASADriver.GetConnParams(AKeys: TStrings; AIndex: Integer;
  var AName, AType, ADefVal, ACaption: String; var ALoginIndex: Integer);
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
        AName := S_AD_ConnParam_ASA_Server;
        AType := '@S';
        ALoginIndex := 3;
      end;
    1:
      begin
        AName := S_AD_ConnParam_ASA_DatabaseFile;
        AType := '@S';
      end;
    2:
      begin
        AName := S_AD_ConnParam_MSSQL_OSAuthentication;
        AType := '@Y';
        ALoginIndex := 2;
      end;
    3:
      begin
        AName := S_AD_ConnParam_MSSQL_App;
        AType := '@S';
      end;
    4:
      begin
        AName := S_AD_ConnParam_ASA_Compress;
        AType := '@Y';
      end;
    5:
      begin
        AName := S_AD_ConnParam_MSSQL_Encrypt;
        AType := '@S';
      end;
    6:
      begin
        AName := S_AD_ConnParam_Common_MetaDefSchema;
        AType := '@S';
      end;
    7:
      begin
        AName := S_AD_ConnParam_Common_MetaDefCatalog;
        AType := '@S';
      end;
    end;
    ACaption := AName;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADPhysODBCASAConnection                                                      }
{-------------------------------------------------------------------------------}
class function TADPhysODBCASAConnection.GetDriverClass: TADPhysDriverClass;
begin
  Result := TADPhysODBCASADriver;
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCASAConnection.InternalCreateCommandGenerator(
  const ACommand: IADPhysCommand): TADPhysCommandGenerator;
begin
  if ACommand <> nil then
    Result := TADPhysASACommandGenerator.Create(ACommand)
  else
    Result := TADPhysASACommandGenerator.Create(Self);
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCASAConnection.InternalCreateMetadata: TObject;
begin
  Result := TADPhysASAMetadata.Create({$IFDEF AnyDAC_MONITOR} GetMonitor, {$ENDIF} Self);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCASAConnection.ParseError(AHandle: TODBCHandle;
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

const
  C_SyntaxErrMsg = 'Syntax error or access violation: near ''';
var
  sWord, sPhrase: String;
  i1, i2: Integer;
begin
  // following is not supported by ASA:
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
  3701,
  -141,
  -265:
    AKind := ekObjNotExists;
  18456:
    AKind := ekUserPwdInvalid;
  -131:
    begin
      i1 := Pos(C_SyntaxErrMsg, ADiagMessage);
      if i1 <> 0 then begin
        i2 := ADPosEx('''', ADiagMessage, i1 + Length(C_SyntaxErrMsg));
        if i2 <> 0 then begin
          sWord := Copy(ADiagMessage, i1 + Length(C_SyntaxErrMsg),
            i2 - i1 - Length(C_SyntaxErrMsg));
          sPhrase := Copy(ADiagMessage, i2 + 5, Length(ADiagMessage));
          i1 := 1;
          while (i1 <= Length(sPhrase)) and (sPhrase[i1] = '.') do
            Inc(i1);
          i2 := Length(sPhrase);
          while (i2 >= 1) and (sPhrase[i2] = '.') do
            Dec(i2);
          sPhrase := Copy(sPhrase, i1, i2 - i1 + 1);
          i1 := 1;
          while i1 <= Length(sPhrase) do
            if sPhrase[i1] in ['[', ']'] then
              Delete(sPhrase, i1, 1)
            else
              Inc(i1);
          ACmdOffset := Pos(sPhrase, ACommandText) + Pos(sWord, sPhrase) - 1;
        end;
      end;
    end;
  else
    inherited ParseError(AHandle, ARecNum, ASQLState, ANativeError,
      ADiagMessage, ACommandText, AObj, AKind, ACmdOffset);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCASAConnection.GetStrsMaxSizes(AStrDataType: SQLSmallint;
  AFixedLen, ANumeric: Boolean; out ACharSize: Integer; out AByteSize: Integer);
begin
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
    ADCapabilityNotSupported(Self, [S_AD_LPhys, S_AD_ASAId]);
  end;
end;

{-------------------------------------------------------------------------------}
initialization
  ADPhysManager();
  ADPhysManagerObj.RegisterPhysConnectionClass(TADPhysODBCASAConnection);

end.
