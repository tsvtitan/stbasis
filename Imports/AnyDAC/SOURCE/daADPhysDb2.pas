{ ----------------------------------------------------------------------------- }
{ AnyDAC ODBC IBM DB2 driver                                                    }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{ ----------------------------------------------------------------------------- }
{$I daAD.inc}

unit daADPhysDB2;

interface

uses
  daADPhysManager;

type
  TADPhysDB2DriverLink = class(TADPhysDriverLinkBase)
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
    daADPhysODBCBase, daADPhysDB2Meta;

type
  TADPhysODBCDB2Driver = class;
  TADPhysODBCDB2Connection = class;

  TADPhysODBCDB2Driver = class(TADPhysODBCDriverBase)
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

  TADPhysODBCDB2Connection = class(TADPhysODBCConnectionBase)
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
    procedure UpdateDecimalSep; override;
  end;

{-------------------------------------------------------------------------------}
{ TADPhysODBCDB2Driver                                                          }
{-------------------------------------------------------------------------------}
class function TADPhysODBCDB2Driver.GetDriverID: String;
begin
  Result := S_AD_DB2Id;
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCDB2Driver.GetDescription: string;
begin
  Result := 'IBM DB2 Driver';
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCDB2Driver.GetODBCConnectStringKeywords(AKeywords: TStrings);
begin
  AKeywords.Add(S_AD_ConnParam_Common_Database + '=DBALIAS');
  AKeywords.Add('=DRIVER');
  AKeywords.Add('=IGNOREWARNINGS');
  inherited GetODBCConnectStringKeywords(AKeywords);
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCDB2Driver.GetODBCFixedPart: String;
begin
  Result := 'DRIVER={IBM DB2 ODBC DRIVER};IGNOREWARNINGS=1';
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCDB2Driver.GetConnParamCount(AKeys: TStrings): Integer;
begin
  Result := inherited GetConnParamCount(AKeys) + 1;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCDB2Driver.GetConnParams(AKeys: TStrings; AIndex: Integer;
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
    AName := S_AD_ConnParam_Common_MetaDefSchema;
    AType := '@S';
  end;
end;

{-------------------------------------------------------------------------------}
{ TADPhysODBCDB2Connection                                                      }
{-------------------------------------------------------------------------------}
class function TADPhysODBCDB2Connection.GetDriverClass: TADPhysDriverClass;
begin
  Result := TADPhysODBCDB2Driver;
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCDB2Connection.InternalCreateCommandGenerator(
  const ACommand: IADPhysCommand): TADPhysCommandGenerator;
begin
  if ACommand <> nil then
    Result := TADPhysDb2CommandGenerator.Create(ACommand)
  else
    Result := TADPhysDb2CommandGenerator.Create(Self);
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCDB2Connection.InternalCreateMetadata: TObject;
begin
  Result := TADPhysDb2Metadata.Create({$IFDEF AnyDAC_MONITOR} GetMonitor, {$ENDIF} Self);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCDB2Connection.ParseError(AHandle: TODBCHandle;
  ARecNum: SQLSmallint; const ASQLState: String; ANativeError: SQLInteger;
  const ADiagMessage: String; const ACommandText: String; var AObj: String;
  var AKind: TADCommandExceptionKind; var ACmdOffset: Integer);

  procedure ExtractObjName;
  var
    i1, i2: Integer;
  begin
    i1 := Pos('"', ADiagMessage);
    if i1 <> 0 then begin
      i2 := ADPosEx('"', ADiagMessage, i1 + 1);
      if i2 <> 0 then
        AObj := Copy(ADiagMessage, i1 + 1, i2 - i1 - 1);
    end;
  end;

begin
  // following is not supported by DB2:
  // ekNoDataFound
  // ekUserPwdExpired
  // ekUserPwdWillExpire
  // ekRecordLocked
  case ANativeError of
  -803:
    begin
      AKind := ekUKViolated;
      // first "xxxx" - constraint
      // second "xxxx" - table name
      ExtractObjName;
    end;
  -530:
    begin
      AKind := ekFKViolated;
      // first "xxxx" - constraint
      ExtractObjName;
    end;
  -204:
    begin
      AKind := ekObjNotExists;
      // first "xxxx" - table name
      ExtractObjName;
    end;
  -30082:
    AKind := ekUserPwdInvalid;
  else
    inherited ParseError(AHandle, ARecNum, ASQLState, ANativeError,
      ADiagMessage, ACommandText, AObj, AKind, ACmdOffset);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCDB2Connection.GetStrsMaxSizes(AStrDataType: SQLSmallint;
  AFixedLen, ANumeric: Boolean; out ACharSize: Integer; out AByteSize: Integer);
begin
  // char - 254
  // varchar - 32672
  // long varchar - 32700
  // clob - 2147483647
  // graphic - 127 * 2
  // vargraphic - 16336 * 2
  // long vargraphic - 16350 * 2
  // dbclob - 1073741823 * 2
  // blob - 2147483647
  case AStrDataType of
  SQL_C_CHAR, SQL_C_BINARY:
    begin
      if AFixedLen then
        AByteSize := 254
      else
        AByteSize := 32672;
      if ANumeric then
        AByteSize := 31;
      ACharSize := AByteSize;
      if ANumeric then
        Inc(AByteSize, 2);
    end;
  SQL_C_WCHAR:
    begin
      if AFixedLen then
        AByteSize := 254
      else
        AByteSize := 32672;
      ACharSize := AByteSize div SizeOf(SQLWChar);
    end;
  else
    ADCapabilityNotSupported(Self, [S_AD_LPhys, S_AD_DB2Id]);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCDB2Connection.UpdateDecimalSep;
var
  oStmt: TODBCCommandStatement;
  oCol: TODBCVariable;
  pData: SQLPointer;
  iCnt, iSize: SQLUInteger;
begin
  inherited UpdateDecimalSep;
  try
    oStmt := TODBCCommandStatement.Create(ODBCConnection);
    try
      oStmt.Prepare('SELECT 12.34 FROM SYSCAT.ROUTINES WHERE ROUTINENAME = ''EXP''');
      oCol := oStmt.AddCol(1, SQL_NUMERIC, SQL_C_CHAR);
      oStmt.BindColumns(1);
      iCnt := 0;
      oStmt.Execute(1, 0, iCnt, True, '');
      oStmt.Fetch(1);
      pData := nil;
      iSize := 0;
      oCol.GetData(0, pData, iSize, True);
      ODBCConnection.DecimalSepCol := PChar(pData)[2];
    finally
      oStmt.Free;
    end;
  except
    // silent
  end;
end;

{-------------------------------------------------------------------------------}
initialization
  ADPhysManager();
  ADPhysManagerObj.RegisterPhysConnectionClass(TADPhysODBCDB2Connection);

end.
