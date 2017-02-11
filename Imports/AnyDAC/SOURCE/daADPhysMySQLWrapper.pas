{-------------------------------------------------------------------------------}
{ AnyDAC MySQL wrapper classes                                                  }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit daADPhysMySQLWrapper;

interface

uses
  daADStanIntf,
  daADStanError,
  daADPhysMySQLCli;

type
  EMySQLNativeException = class;
  TMySQLLib = class;
  TMySQLSession = class;
  TMySQLResult = class;
  TMySQLField = class;

  EMySQLNativeException = class(EADDBEngineException)
  end;

  TMySQLLib = class(TObject)
  private
    FOwningObj: TObject;
    function GetMySQLProcAddress(const AProcName: String; ARequired: Boolean = True): Pointer;
    procedure LoadMySQLEntrys;
    procedure LoadMySQLLibrary(const AMySQLDllNames: array of String);

  public
    FMySQLDllName: String;
    FMySQLhDll: Integer;
    FMySQLVersion: Integer;
    FMySQLEmbedded: Boolean;
    FMySQLEmbeddedInit: Boolean;

    mysql_num_fields: TPrcmysql_num_fields;
    mysql_fetch_field_direct: TPrcmysql_fetch_field_direct;
    mysql_affected_rows: TPrcmysql_affected_rows;
    mysql_insert_id: TPrcmysql_insert_id;
    mysql_errno: TPrcmysql_errno;
    mysql_error: TPrcmysql_error;
    mysql_warning_count: TPrcmysql_warning_count;
    mysql_info: TPrcmysql_info;
    mysql_character_set_name: TPrcmysql_character_set_name;
    mysql_get_character_set_info: TPrcmysql_get_character_set_info;
    mysql_set_character_set: TPrcmysql_set_character_set;
    mysql_init: TPrcmysql_init;
    mysql_ssl_set: TPrcmysql_ssl_set;
    mysql_connect: TPrcmysql_connect;
    mysql_real_connect: TPrcmysql_real_connect;
    mysql_close: TPrcmysql_close;
    mysql_select_db: TPrcmysql_select_db;
    mysql_real_query: TPrcmysql_real_query;
    mysql_kill: TPrcmysql_kill;
    mysql_ping: TPrcmysql_ping;
    mysql_stat: TPrcmysql_stat;
    mysql_get_server_info: TPrcmysql_get_server_info;
    mysql_get_client_info: TPrcmysql_get_client_info;
    mysql_get_host_info: TPrcmysql_get_host_info;
    mysql_get_proto_info: TPrcmysql_get_proto_info;
    mysql_list_processes: TPrcmysql_list_processes;
    mysql_store_result: TPrcmysql_store_result;
    mysql_use_result: TPrcmysql_use_result;
    mysql_options_: TPrcmysql_options;
    mysql_free_result: TPrcmysql_free_result;
    mysql_fetch_row: TPrcmysql_fetch_row;
    mysql_fetch_lengths: TPrcmysql_fetch_lengths;
    mysql_escape_string: TPrcmysql_escape_string;
    mysql_real_escape_string: TPrcmysql_real_escape_string;
    mysql_thread_safe: TPrcmysql_thread_safe;
    mysql_more_results: TPrcmysql_more_results;
    mysql_next_result: TPrcmysql_next_result;
    mysql_server_init: TPrcmysql_server_init;
    mysql_server_end: TPrcmysql_server_end;
    mysql_thread_init: TPrcmysql_thread_init;
    mysql_thread_end: TPrcmysql_thread_end;

    constructor Create(const AVendorHome, AVendorLib: String; AOwningObj: TObject = nil);
    destructor Destroy; override;
    property OwningObj: TObject read FOwningObj;
  end;

  TMySQLSession = class(TObject)
  private
    FLib: TMySQLLib;
    FTracing: Boolean;
{$IFDEF AnyDAC_MONITOR}
    FMonitor: IADMoniClient;
{$ENDIF}
    FPMySQL: PMYSQL;
    FOwningObj: TObject;
    FCurrDB: String;
    FInfo: EMySQLNativeException;
    function GetAffectedRows: my_ulonglong;
    function GetClientInfo: String;
    function GetServerInfo: String;
    procedure SetOptions(AOption: mysql_option; const Value: PChar);
    procedure SetDB(const AValue: String);
    procedure ProcessError(AErrNo: LongWord; AInitiator: TObject);
    procedure Check(ACode: Integer = -1; AInitiator: TObject = nil);
    procedure ClearInfo;
    procedure SetInfo(ApInfo: PChar);
    function GetCharacterSetName: String;
    function GetHostInfo: String;
    function GetInsert_ID: my_ulonglong;
    procedure SetCharacterSetName(const AValue: String);
  public
    constructor Create(ALib: TMySQLLib;
      {$IFDEF AnyDAC_MONITOR} const AMonitor: IADMoniClient; {$ENDIF}
      AOwningObj: TObject = nil);
    destructor Destroy; override;
{$IFDEF AnyDAC_MONITOR}
    procedure Trace(const AMsg: String; const AArgs: array of const); overload;
    procedure Trace(AKind: TADMoniEventKind; AStep: TADMoniEventStep;
      const AMsg: String; const AArgs: array of const); overload;
{$ENDIF}
    procedure Init;
    procedure Connect(const host, user, passwd, db: String;
      port: LongWord; clientflag: LongWord);
    procedure Disconnect;
    function EscapeString(szTo: PChar; const szFrom: PChar;
      length: LongWord): LongWord;
    procedure Query(const ACmd: String; AInitiator: TObject = nil);
    function StoreResult: TMySQLResult;
    function UseResult: TMySQLResult;
    function MoreResults: Boolean;
    function NextResult: Boolean;
    procedure GetCharacterSetInfo(var ACharset: MY_CHARSET_INFO);
    property Options[AOption: mysql_option]: PChar write SetOptions;
    property ServerInfo: String read GetServerInfo;
    property ClientInfo: String read GetClientInfo;
    property AffectedRows: my_ulonglong read GetAffectedRows;
    property Tracing: Boolean read FTracing write FTracing;
    property DB: String read FCurrDB write SetDB;
    property Lib: TMySQLLib read FLib;
    property OwningObj: TObject read FOwningObj;
    property Info: EMySQLNativeException read FInfo;
    property CharacterSetName: String read GetCharacterSetName write SetCharacterSetName;
    property HostInfo: String read GetHostInfo;
    property Insert_ID: my_ulonglong read GetInsert_ID;
  end;

  TMySQLResult = class(TObject)
  private
    FSession: TMySQLSession;
    FCursor: PMYSQL_RES;
    FpRow: PMYSQL_ROW;
    FpLengths: PLongInt;
    FField: TMySQLField;
    function GetFieldCount: LongWord;
    function GetFields(AIndex: Integer): TMySQLField;
{$IFDEF AnyDAC_MONITOR}
    procedure DumpColumns(ARowIndex: Integer);
{$ENDIF}
  public
    constructor Create(ASession: TMySQLSession; AResult: PMYSQL_RES);
    destructor Destroy; override;
    function Fetch(ARowIndex: Integer): Boolean;
    function GetData(AIndex: Integer; var ApData: Pointer; var ALen: LongWord): Boolean;
    property FieldCount: LongWord read GetFieldCount;
    property Fields[AIndex: Integer]: TMySQLField read GetFields;
  end;

  TMySQLField = class(TObject)
  private
    FResult: TMySQLResult;
    FpFld: PMYSQL_FIELD;
  public
    procedure GetInfo(var name, srcname, table: PChar; var type_: Byte;
      var length, flags, decimals: LongWord);
    constructor Create(AResult: TMySQLResult);
  end;

implementation

uses
  Windows, SysUtils, Classes,
  daADStanConst, daADStanUtil,
  daADPhysIntf;

const
  smysql_get_client_info: String = 'mysql_get_client_info';
  smysql_num_fields: String = 'mysql_num_fields';
  smysql_fetch_field_direct: String = 'mysql_fetch_field_direct';
  smysql_affected_rows: String = 'mysql_affected_rows';
  smysql_insert_id: String = 'mysql_insert_id';
  smysql_errno: String = 'mysql_errno';
  smysql_error: String = 'mysql_error';
  smysql_warning_count: String = 'mysql_warning_count';
  smysql_info: String = 'mysql_info';
  smysql_character_set_name: String = 'mysql_character_set_name';
  smysql_get_character_set_info: String = 'mysql_get_character_set_info';
  smysql_set_character_set: String = 'mysql_set_character_set';
  smysql_init: String = 'mysql_init';
  smysql_connect: String = 'mysql_connect';
  smysql_ssl_set: String = 'mysql_ssl_set';
  smysql_real_connect: String = 'mysql_real_connect';
  smysql_close: String = 'mysql_close';
  smysql_select_db: String = 'mysql_select_db';
  smysql_real_query: String = 'mysql_real_query';
  smysql_kill: String = 'mysql_kill';
  smysql_ping: String = 'mysql_ping';
  smysql_stat: String = 'mysql_stat';
  smysql_get_server_info: String = 'mysql_get_server_info';
  smysql_get_host_info: String = 'mysql_get_host_info';
  smysql_get_proto_info: String = 'mysql_get_proto_info';
  smysql_list_processes: String = 'mysql_list_processes';
  smysql_store_result: String = 'mysql_store_result';
  smysql_use_result: String = 'mysql_use_result';
  smysql_options_: String = 'mysql_options';
  smysql_free_result: String = 'mysql_free_result';
  smysql_fetch_row: String = 'mysql_fetch_row';
  smysql_fetch_lengths: String = 'mysql_fetch_lengths';
  smysql_escape_string: String = 'mysql_escape_string';
  smysql_real_escape_string: String = 'mysql_real_escape_string';
  smysql_thread_safe: String = 'mysql_thread_safe';
  smysql_more_results: String = 'mysql_more_results';
  smysql_next_result: String = 'mysql_next_result';
  smysql_server_init: String = 'mysql_server_init';
  smysql_server_end: String = 'mysql_server_end';
  smysql_thread_init: String = 'mysql_thread_init';
  smysql_thread_end: String = 'mysql_thread_end';

{-------------------------------------------------------------------------------}
{ TMySQLLib                                                                     }
{-------------------------------------------------------------------------------}
procedure TMySQLLib.LoadMySQLLibrary(const AMySQLDllNames: array of String);
var
  i: Integer;
begin
  FMySQLhDll := 0;
  for i := 0 to Length(AMySQLDllNames) - 1 do
    if AMySQLDllNames[i] <> '' then begin
{$IFDEF AnyDAC_FPC}
      FMySQLhDll := LoadLibrary(PChar(AMySQLDllNames[i]));
{$ELSE}
      FMySQLhDll := SafeLoadLibrary(PChar(AMySQLDllNames[i]));
{$ENDIF}
      if FMySQLhDll <> 0 then begin
        SetLength(FMySQLDllName, 255);
        SetLength(FMySQLDllName, GetModuleFileName(FMySQLhDll, PChar(FMySQLDllName), 255));
        Break;
      end;
    end;
  if FMySQLhDll = 0 then begin
    if Length(AMySQLDllNames) = 1 then
      i := 0
    else
      i := 1;
    ADException(OwningObj, [S_AD_LPhys, S_AD_MySQLId], er_AD_AccCantLoadLibrary,
      [AMySQLDllNames[i], ADLastSystemErrorMsg, AMySQLDllNames[i]]);
  end;
  FMySQLEmbedded := (FMySQLDllName[Pos('.', FMySQLDllName) - 1] in ['d', 'D']);
end;

{-------------------------------------------------------------------------------}
function TMySQLLib.GetMySQLProcAddress(const AProcName: String; ARequired: Boolean): Pointer;
begin
  Result := nil;
  try
    Result := GetProcAddress(FMySQLhDll, PChar(AProcName));
    if (Result = nil) and ARequired then
      ADException(OwningObj, [S_AD_LPhys, S_AD_MySQLId], er_AD_AccCantGetLibraryEntry,
        [AProcName, ADLastSystemErrorMsg]);
  except
    ADHandleException;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TMySQLLib.LoadMySQLEntrys;
begin
  @mysql_get_client_info := GetMySQLProcAddress(smysql_get_client_info);
  FMySQLVersion := ADVerStr2Int(String(mysql_get_client_info()));
  if (FMySQLVersion < mvMySQL032000) or (FMySQLVersion >= mvMySQL050200) then
    ADException(OwningObj, [S_AD_LPhys, S_AD_MySQLId], er_AD_MySQLBadVersion,
      [FMySQLVersion]);

  @mysql_num_fields := GetMySQLProcAddress(smysql_num_fields);
  @mysql_fetch_field_direct := GetMySQLProcAddress(smysql_fetch_field_direct);
  @mysql_affected_rows := GetMySQLProcAddress(smysql_affected_rows);
  @mysql_insert_id := GetMySQLProcAddress(smysql_insert_id);
  @mysql_errno := GetMySQLProcAddress(smysql_errno);
  @mysql_error := GetMySQLProcAddress(smysql_error);
  if FMySQLVersion >= mvMySQL040101 then
    @mysql_warning_count := GetMySQLProcAddress(smysql_warning_count)
  else
    @mysql_warning_count := nil;
  @mysql_info := GetMySQLProcAddress(smysql_info);
  if FMySQLVersion >= mvMySQL032321 then
    @mysql_character_set_name := GetMySQLProcAddress(smysql_character_set_name, False)
  else
    @mysql_character_set_name := nil;
  if FMySQLVersion >= mvMySQL050010 then begin
    @mysql_get_character_set_info := GetMySQLProcAddress(smysql_get_character_set_info);
    @mysql_set_character_set := GetMySQLProcAddress(smysql_set_character_set);
  end
  else begin
    @mysql_get_character_set_info := nil;
    @mysql_set_character_set := nil;
  end;
  @mysql_init := GetMySQLProcAddress(smysql_init);
  if not FMySQLEmbedded then
    if FMySQLVersion < mvMySQL040000 then begin
      @mysql_connect := GetMySQLProcAddress(smysql_connect);
      @mysql_ssl_set := nil;
    end
    else begin
      @mysql_connect := nil;
      @mysql_ssl_set := GetMySQLProcAddress(smysql_ssl_set);
    end;
  @mysql_real_connect := GetMySQLProcAddress(smysql_real_connect);
  @mysql_close := GetMySQLProcAddress(smysql_close);
  @mysql_select_db := GetMySQLProcAddress(smysql_select_db);
  @mysql_real_query := GetMySQLProcAddress(smysql_real_query);
  @mysql_kill := GetMySQLProcAddress(smysql_kill);
  @mysql_ping := GetMySQLProcAddress(smysql_ping);
  @mysql_stat := GetMySQLProcAddress(smysql_stat);
  @mysql_get_server_info := GetMySQLProcAddress(smysql_get_server_info);
  @mysql_get_host_info := GetMySQLProcAddress(smysql_get_host_info);
  @mysql_get_proto_info := GetMySQLProcAddress(smysql_get_proto_info);
  @mysql_list_processes := GetMySQLProcAddress(smysql_list_processes);
  @mysql_store_result := GetMySQLProcAddress(smysql_store_result);
  @mysql_use_result := GetMySQLProcAddress(smysql_use_result);
  @mysql_options_ := GetMySQLProcAddress(smysql_options_);
  @mysql_free_result := GetMySQLProcAddress(smysql_free_result);
  @mysql_fetch_row := GetMySQLProcAddress(smysql_fetch_row);
  @mysql_fetch_lengths := GetMySQLProcAddress(smysql_fetch_lengths);
  @mysql_escape_string := GetMySQLProcAddress(smysql_escape_string);
  if FMySQLVersion >= mvMySQL032314 then begin
    @mysql_real_escape_string := GetMySQLProcAddress(smysql_real_escape_string, False);
    @mysql_thread_safe := GetMySQLProcAddress(smysql_thread_safe, False);
  end
  else begin
    @mysql_real_escape_string := nil;
    @mysql_thread_safe := nil;
  end;
  if FMySQLVersion >= mvMySQL040101 then begin
    @mysql_more_results := GetMySQLProcAddress(smysql_more_results);
    @mysql_next_result := GetMySQLProcAddress(smysql_next_result);
  end
  else begin
    @mysql_more_results := nil;
    @mysql_next_result := nil;
  end;
  if FMySQLEmbedded then begin
    @mysql_server_init := GetMySQLProcAddress(smysql_server_init);
    @mysql_server_end := GetMySQLProcAddress(smysql_server_end);
    @mysql_thread_init := GetMySQLProcAddress(smysql_thread_init);
    @mysql_thread_end := GetMySQLProcAddress(smysql_thread_end);
  end;
end;

{-------------------------------------------------------------------------------}
constructor TMySQLLib.Create(const AVendorHome, AVendorLib: String; AOwningObj: TObject);
const
  C_Libmysql: String = 'libmysql';
  C_Dll: String = '.dll';
(*
  server_args: array [0..1] of PChar = (
    'markup',
    '--defaults-file=.\sh\my.cnf'
  );
  server_groups: array [0..3] of PChar = (
    'embedded',
    'server',
    'markup_SERVER',
    nil
  );
*)
var
  s: String;
  aMySQLDllNames: array of String;
begin
  inherited Create;
  FMySQLEmbeddedInit := False;
  FOwningObj := AOwningObj;
  s := AVendorHome;
  if s <> '' then begin
    if s[Length(s)] <> '\' then
      s := s + '\';
    s := s + 'bin\';
  end;
  if AVendorLib <> '' then begin
    SetLength(aMySQLDllNames, 1);
    aMySQLDllNames[0] := s + AVendorLib;
  end
  else begin
    SetLength(aMySQLDllNames, 8);
    aMySQLDllNames[0] := ''; // s + C_Libmysql + 'd' + C_Dll;
    aMySQLDllNames[1] := s + C_Libmysql + C_Dll;
    aMySQLDllNames[2] := s + C_Libmysql + '500' + C_Dll;
    aMySQLDllNames[3] := s + C_Libmysql + '410' + C_Dll;
    aMySQLDllNames[4] := s + C_Libmysql + '401' + C_Dll;
    aMySQLDllNames[5] := s + C_Libmysql + '400' + C_Dll;
    aMySQLDllNames[6] := s + C_Libmysql + '323' + C_Dll;
    aMySQLDllNames[7] := s + C_Libmysql + '320' + C_Dll;
  end;
  LoadMySQLLibrary(aMySQLDllNames);
  LoadMySQLEntrys;
  if FMySQLEmbedded then begin
(*
    if mysql_server_init(sizeof(server_args) div sizeof(PChar),
                         @server_args[0], @server_groups[0]) <> 0 then
*)
      ADException(OwningObj, [S_AD_LPhys, S_AD_MySQLId],
        er_AD_MySQLCantInitEmbeddedServer, []);
    FMySQLEmbeddedInit := True;
  end;
end;

{-------------------------------------------------------------------------------}
destructor TMySQLLib.Destroy;
begin
  if FMySQLEmbeddedInit then begin
    FMySQLEmbeddedInit := False;
    mysql_server_end();
  end;
  if FMySQLhDll <> 0 then begin
    FreeLibrary(FMySQLhDll);
    FMySQLhDll := 0;
  end;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
{ TMySQLSession                                                                 }
{-------------------------------------------------------------------------------}
constructor TMySQLSession.Create(ALib: TMySQLLib;
  {$IFDEF AnyDAC_MONITOR} const AMonitor: IADMoniClient; {$ENDIF}
  AOwningObj: TObject);
begin
  inherited Create;
{$IFDEF AnyDAC_MONITOR}
  FMonitor := AMonitor;
{$ENDIF}
  FOwningObj := AOwningObj;
  FLib := ALib;
end;

{-------------------------------------------------------------------------------}
destructor TMySQLSession.Destroy;
begin
  if FPMySQL <> nil then
    Disconnect;
  ClearInfo;
{$IFDEF AnyDAC_MONITOR}
  FMonitor := nil;
{$ENDIF}
  FOwningObj := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_MONITOR}
procedure TMySQLSession.Trace(const AMsg: String; const AArgs: array of const);
begin
  FMonitor.Notify(ekVendor, esProgress, OwningObj, AMsg, AArgs);
end;

{-------------------------------------------------------------------------------}
procedure TMySQLSession.Trace(AKind: TADMoniEventKind; AStep: TADMoniEventStep;
  const AMsg: String; const AArgs: array of const);
begin
  FMonitor.Notify(AKind, AStep, OwningObj, AMsg, AArgs);
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
procedure TMySQLSession.ProcessError(AErrNo: LongWord; AInitiator: TObject);
var
  pErrMsg: PChar;
  oEx: EMySQLNativeException;
  sObjName, sMsg, sSQL: String;
  eKind: TADCommandExceptionKind;
  oCommand: IADPhysCommand;
  iOff, i1, i2: Integer;
begin
  pErrMsg := FLib.mysql_error(FPMySQL);
  oEx := EMySQLNativeException.Create(er_AD_MySQLGeneral,
    ADExceptionLayers([S_AD_LPhys, S_AD_MySQLId, 'LIBMYSQL']) + ' ' + String(pErrMsg));
  sObjName := '';
  eKind := ekOther;
  case AErrNo of
  ER_NO_SUCH_TABLE,
  ER_BAD_TABLE_ERROR,
  ER_SP_DOES_NOT_EXIST:   eKind := ekObjNotExists;
  ER_DUP_ENTRY:           eKind := ekUKViolated;
  ER_LOCK_WAIT_TIMEOUT:   eKind := ekRecordLocked;
  ER_NO_REFERENCED_ROW,
  ER_ROW_IS_REFERENCED:   eKind := ekFKViolated;
  ER_ACCESS_DENIED_ERROR: eKind := ekUserPwdInvalid;
  ER_SERVER_GONE_ERROR,
  ER_SERVER_LOST:         eKind := ekServerGone;
  // ekNoDataFound - nothing similar in MySQL
  // 1048 - NOT NULL violated
  end;
  sMsg := String(pErrMsg);
  iOff := -1;
  if (AErrNo = ER_PARSE_ERROR) and Supports(AInitiator, IADPhysCommand, oCommand) then begin
    sSQL := oCommand.CommandText;
    i1 := Pos('to use near ''', sMsg);
    if i1 = 0 then
      i1 := Pos('syntax near ''', sMsg);
    if i1 <> 0 then begin
      i1 := i1 + 13;
      i2 := Length(sMsg);
      while (i2 > i1) and (sMsg[i2] <> '''') do
        Dec(i2);
      iOff := Pos(ADFixCRLF(Copy(sMsg, i1, i2 - i1 - 1)), sSQL);
      if iOff = 0 then begin
        i1 := Pos('at line', sMsg);
        if i1 <> 0 then begin
          i1 := StrToIntDef(Copy(sMsg, i1 + 7, Length(sMsg)), 0);
          if i1 <> 0 then begin
            i2 := 1;
            while i2 <= Length(sSQL) do
              if sSQL[i2] = #13 then begin
                if sSQL[i2 + 1] = #10 then
                  Inc(i2);
                Inc(i2);
                Dec(i1);
                if i1 = 1 then begin
                  iOff := i2;
                  Break;
                end;
              end
              else
                Inc(i2);
          end;
        end;
      end;
    end;
  end;
  oEx.Append(TADDBError.Create(1, AErrNo, sMsg, sObjName, eKind, iOff));
{$IFDEF AnyDAC_MONITOR}
  if Tracing then
    FMonitor.Notify(ekError, esProgress, OwningObj, pErrMsg, ['errno', AErrNo]);
{$ENDIF}
  ADException(AInitiator, oEx);
end;

{-------------------------------------------------------------------------------}
procedure TMySQLSession.ClearInfo;
begin
  FreeAndNil(FInfo);
end;

{-------------------------------------------------------------------------------}
procedure TMySQLSession.SetInfo(ApInfo: PChar);
begin
  ClearInfo;
  FInfo := EMySQLNativeException.Create(er_AD_MySQLGeneral,
    ADExceptionLayers([S_AD_LPhys, S_AD_MySQLId]));
  FInfo.Append(TADDBError.Create(1, MYSQL_SUCCESS, String(ApInfo), '', ekOther, -1));
end;

{-------------------------------------------------------------------------------}
procedure TMySQLSession.Check(ACode: Integer = -1; AInitiator: TObject = nil);
var
  iErrNo: LongWord;
begin
  if ACode <> 0 then begin
    iErrNo := FLib.mysql_errno(FPMySQL);
    if (ACode <> -1) or (iErrNo <> 0) then begin
      if AInitiator = nil then
        AInitiator := OwningObj;
      ProcessError(iErrNo, AInitiator);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TMySQLSession.Init;
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then
    Trace(smysql_init, []);
{$ENDIF}
  FPMySQL := FLib.mysql_init(nil);
end;

{-------------------------------------------------------------------------------}
procedure TMySQLSession.Connect(const host, user, passwd,
  db: String; port, clientflag: LongWord);
begin
  if Assigned(FLib.mysql_real_connect) then begin
{$IFDEF AnyDAC_MONITOR}
    if Tracing then
      Trace(smysql_real_connect, ['host', host, 'user', user, 'passwd', passwd,
        'db', db, 'port', port, 'clientflag', clientflag]);
{$ENDIF}
    if FLib.mysql_real_connect(FPMySQL, PChar(host), PChar(user), PChar(passwd),
        PChar(db), port, nil, clientflag) = nil then
      Check;
  end
  else begin
    if (port <> 0) and (port <> MYSQL_PORT) then
      ADException(OwningObj, [S_AD_LPhys, S_AD_MySQLId], er_AD_MySQLCantSetPort, []);
{$IFDEF AnyDAC_MONITOR}
    if Tracing then
      Trace(smysql_connect, ['host', host, 'user', user, 'passwd', passwd]);
{$ENDIF}
    if FLib.mysql_connect(FPMySQL, PChar(host), PChar(user), PChar(passwd)) = nil then
      Check;
    if db <> '' then
      Query('USE ' + db);
  end;
  FCurrDB := db;
end;

{-------------------------------------------------------------------------------}
procedure TMySQLSession.Disconnect;
begin
  if FPMySQL = nil then
    Exit;
  ClearInfo;
{$IFDEF AnyDAC_MONITOR}
  if Tracing then
    Trace(smysql_close, []);
{$ENDIF}
  FLib.mysql_close(FPMySQL);
  FPMySQL := nil;
end;

{-------------------------------------------------------------------------------}
function TMySQLSession.EscapeString(szTo: PChar; const szFrom: PChar;
  length: LongWord): LongWord;
begin
  if Assigned(FLib.mysql_real_escape_string) then begin
    Result := FLib.mysql_real_escape_string(FPMySQL, szTo, szFrom, length);
{$IFDEF AnyDAC_MONITOR}
    if Tracing then
      Trace(smysql_real_escape_string, ['szFrom', szFrom, 'szTo', szTo]);
{$ENDIF}
  end
  else begin
    Result := FLib.mysql_escape_string(szTo, szFrom, length);
{$IFDEF AnyDAC_MONITOR}
    if Tracing then
      Trace(smysql_escape_string, ['szFrom', szFrom, 'szTo', szTo]);
{$ENDIF}
  end;
end;

{-------------------------------------------------------------------------------}
function TMySQLSession.GetAffectedRows: my_ulonglong;
begin
  Result := FLib.mysql_affected_rows(FPMySQL);
{$IFDEF AnyDAC_MONITOR}
  if Tracing then
    Trace(smysql_affected_rows, ['Rows', Result]);
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
function TMySQLSession.GetClientInfo: String;
begin
  Result := FLib.mysql_get_client_info();
{$IFDEF AnyDAC_MONITOR}
  if Tracing then
    Trace(smysql_get_client_info, ['Ver', Result]);
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
function TMySQLSession.GetServerInfo: String;
begin
  Result := FLib.mysql_get_server_info(FPMySQL);
{$IFDEF AnyDAC_MONITOR}
  if Tracing then
    Trace(smysql_get_server_info, ['Ver', Result]);
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TMySQLSession.SetOptions(AOption: mysql_option;
  const Value: PChar);
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then
    Trace(smysql_options_, ['option', Integer(AOption), 'arg', LongWord(Value)]);
{$ENDIF}
  FLib.mysql_options_(FPMySQL, AOption, Value);
end;

{-------------------------------------------------------------------------------}
procedure TMySQLSession.Query(const ACmd: String; AInitiator: TObject = nil);
var
  iRes: Integer;
  pInfo: PChar;
begin
  ClearInfo;
{$IFDEF AnyDAC_MONITOR}
  if Tracing then
    Trace(smysql_real_query, ['q', ACmd]);
{$ENDIF}
  iRes := FLib.mysql_real_query(FPMySQL, PChar(ACmd), Length(ACmd));
  Check(iRes, AInitiator);
  pInfo := FLib.mysql_info(FPMySQL);
  if pInfo <> nil then begin
    SetInfo(pInfo);
{$IFDEF AnyDAC_MONITOR}
    if Tracing then
      Trace(smysql_info, ['res', String(pInfo)]);
{$ENDIF}
  end;
{$IFDEF AnyDAC_MONITOR}
  if Assigned(FLib.mysql_warning_count) then begin
    iRes := FLib.mysql_warning_count(FPMySQL);
    if Tracing then
      Trace(smysql_warning_count, ['res', iRes]);
(*
    if (iRes > 0) and () then begin
      Query('show warnings');
      oRes := StoreResult;
      try
      finally
        oRes.Free;
      end;
    end;
*)
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
function TMySQLSession.StoreResult: TMySQLResult;
var
  pRes: PMYSQL_RES;
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then
    Trace(smysql_store_result, []);
{$ENDIF}
  pRes := FLib.mysql_store_result(FPMySQL);
  Check;
  if pRes = nil then
    Result := nil
  else
    Result := TMySQLResult.Create(Self, pRes);
end;

{-------------------------------------------------------------------------------}
function TMySQLSession.UseResult: TMySQLResult;
var
  pRes: PMYSQL_RES;
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then
    Trace(smysql_use_result, []);
{$ENDIF}
  pRes := FLib.mysql_use_result(FPMySQL);
  Check;
  if pRes = nil then
    Result := nil
  else
    Result := TMySQLResult.Create(Self, pRes);
end;

{-------------------------------------------------------------------------------}
function TMySQLSession.MoreResults: Boolean;
begin
  ClearInfo;
  if not Assigned(FLib.mysql_more_results) then
    Result := False
  else begin
{$IFDEF AnyDAC_MONITOR}
    if Tracing then
      Trace(smysql_more_results, []);
{$ENDIF}
    Result := FLib.mysql_more_results(FPMySQL) = 1;
  end;
end;

{-------------------------------------------------------------------------------}
function TMySQLSession.NextResult: Boolean;
begin
  ClearInfo;
  if not Assigned(FLib.mysql_next_result) then
    Result := False
  else begin
{$IFDEF AnyDAC_MONITOR}
    if Tracing then
      Trace(smysql_next_result, []);
{$ENDIF}
    case FLib.mysql_next_result(FPMySQL) of
    my_bool(-1): Result := False;
    0:           Result := True;
    else         begin Result := False; Check; end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TMySQLSession.SetDB(const AValue: String);
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then
    Trace(smysql_select_db, ['db', AValue]);
{$ENDIF}
  Check(FLib.mysql_select_db(FPMySQL, PChar(AValue)));
  FCurrDB := AValue;
end;

{-------------------------------------------------------------------------------}
function TMySQLSession.GetHostInfo: String;
begin
  Result := String(FLib.mysql_get_host_info(FPMySQL));
{$IFDEF AnyDAC_MONITOR}
  if Tracing then
    Trace(smysql_get_host_info, ['res', Result]);
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
function TMySQLSession.GetInsert_ID: my_ulonglong;
begin
  Result := FLib.mysql_insert_id(FPMySQL);
{$IFDEF AnyDAC_MONITOR}
  if Tracing then
    Trace(smysql_insert_id, ['res', Result]);
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TMySQLSession.GetCharacterSetInfo(var ACharset: MY_CHARSET_INFO);
begin
  if Assigned(FLib.mysql_get_character_set_info) then begin
    FLib.mysql_get_character_set_info(FPMySQL, ACharset);
{$IFDEF AnyDAC_MONITOR}
    if Tracing then
      Trace(smysql_get_character_set_info, []);
{$ENDIF}
  end
  else
    ADFillChar(ACharset, SizeOf(MY_CHARSET_INFO), #0);
end;

{-------------------------------------------------------------------------------}
function TMySQLSession.GetCharacterSetName: String;
begin
  if Assigned(FLib.mysql_character_set_name) then begin
    Result := String(FLib.mysql_character_set_name(FPMySQL));
{$IFDEF AnyDAC_MONITOR}
    if Tracing then
      Trace(smysql_character_set_name, ['res', Result]);
{$ENDIF}
  end
  else
    Result := '';
end;

{-------------------------------------------------------------------------------}
procedure TMySQLSession.SetCharacterSetName(const AValue: String);
var
  iRes: Integer;
begin
  if Assigned(FLib.mysql_set_character_set) then begin
{$IFDEF AnyDAC_MONITOR}
    if Tracing then
      Trace(smysql_set_character_set, ['cs_name', AValue]);
{$ENDIF}
    iRes := FLib.mysql_set_character_set(FPMySQL, PChar(AValue));
    if iRes <> 0 then
      Query('SET NAMES ' + AValue);
  end
  else
    Query('SET NAMES ' + AValue);
end;

{-------------------------------------------------------------------------------}
{ TMySQLResult                                                                  }
{-------------------------------------------------------------------------------}
constructor TMySQLResult.Create(ASession: TMySQLSession; AResult: PMYSQL_RES);
begin
  inherited Create;
  FSession := ASession;
  FCursor := AResult;
end;

{-------------------------------------------------------------------------------}
destructor TMySQLResult.Destroy;
begin
{$IFDEF AnyDAC_MONITOR}
  if FSession.Tracing then
    FSession.Trace(smysql_free_result, ['res', FCursor]);
{$ENDIF}
  FSession.FLib.mysql_free_result(FCursor);
  FCursor := nil;
  FreeAndNil(FField);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TMySQLResult.GetFieldCount: LongWord;
begin
{$IFDEF AnyDAC_MONITOR}
  if FSession.Tracing then
    FSession.Trace(smysql_num_fields, ['res', FCursor]);
{$ENDIF}
  Result := FSession.FLib.mysql_num_fields(FCursor);
end;

{-------------------------------------------------------------------------------}
function TMySQLResult.GetFields(AIndex: Integer): TMySQLField;
begin
  if FField = nil then
    FField := TMySQLField.Create(Self);
{$IFDEF AnyDAC_MONITOR}
  if FSession.Tracing then
    FSession.Trace(smysql_fetch_field_direct, ['res', FCursor, 'fieldnr', AIndex]);
{$ENDIF}
  FField.FpFld := FSession.FLib.mysql_fetch_field_direct(FCursor, AIndex);
  Result := FField;
end;

{-------------------------------------------------------------------------------}
function TMySQLResult.Fetch(ARowIndex: Integer): Boolean;
begin
{$IFDEF AnyDAC_MONITOR}
  if FSession.Tracing then
    FSession.Trace(smysql_fetch_row, ['res', FCursor]);
{$ENDIF}
  FpRow := FSession.FLib.mysql_fetch_row(FCursor);
  Result := (FpRow <> nil);
  if Result then begin
{$IFDEF AnyDAC_MONITOR}
    if FSession.Tracing then
      FSession.Trace(smysql_fetch_lengths, ['res', FCursor]);
{$ENDIF}
    FpLengths := FSession.FLib.mysql_fetch_lengths(FCursor);
    if FpLengths = nil then
      FSession.Check;
{$IFDEF AnyDAC_MONITOR}
    if FSession.Tracing then
      DumpColumns(ARowIndex);
{$ENDIF}
  end
  else begin
    FSession.Check;
{$IFDEF AnyDAC_MONITOR}
    if FSession.Tracing then
      FSession.Trace(ekCmdDataOut, esProgress, 'EOF', []);
{$ENDIF}
  end;
end;

{-------------------------------------------------------------------------------}
function TMySQLResult.GetData(AIndex: Integer; var ApData: Pointer;
  var ALen: LongWord): Boolean;
begin
  ALen  := PLongWord(LongWord(FpLengths) + LongWord(AIndex) * SizeOf(LongWord))^;
  ApData := PChar(FpRow^[AIndex]);
  Result := ApData <> nil;
end;

{$IFDEF AnyDAC_MONITOR}
{-------------------------------------------------------------------------------}
procedure TMySQLResult.DumpColumns(ARowIndex: Integer);
var
  i: Integer;
  pData: Pointer;
  iLen: LongWord;
  s: String;
begin
  if FSession.Tracing then begin
    FSession.Trace(ekCmdDataOut, esStart, 'Fetched', ['Row', ARowIndex]);
    for i := 0 to FSession.FLib.mysql_num_fields(FCursor) - 1 do begin
      pData := nil;
      iLen := 0;
      if not GetData(i, pData, iLen) then
        s := 'NULL'
      else if iLen > 1024 then begin
        SetString(s, PChar(pData), 1024);
        s := '(truncated at 1024) ''' + s + ' ...''';
      end
      else begin
        SetString(s, PChar(pData), iLen);
        s := '''' + s + '''';
      end;
      FSession.Trace(ekCmdDataOut, esProgress, 'Column', [String('N'), i,
        'Len', iLen, '@Data', s]);
    end;
    FSession.Trace(ekCmdDataOut, esEnd, 'Fetched', ['Row', ARowIndex]);
  end;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
{ TMySQLField                                                                   }
{-------------------------------------------------------------------------------}
constructor TMySQLField.Create(AResult: TMySQLResult);
begin
  inherited Create;
  FResult := AResult;
end;

{-------------------------------------------------------------------------------}
procedure TMySQLField.GetInfo(var name, srcname, table: PChar;
  var type_: Byte; var length, flags, decimals: LongWord);
var
  pFld0410: PMYSQL_FIELD0410;
  pFld0401: PMYSQL_FIELD0401;
  pFld0400: PMYSQL_FIELD0400;
  pFld0320: PMYSQL_FIELD0320;
begin
  if FResult.FSession.FLib.FMySQLVersion >= mvMySQL040101 then begin
    pFld0410 := PMYSQL_FIELD0410(FpFld);
    name := pFld0410^.name;
    srcname := pFld0410^.org_name;
    if (srcname = nil) or (srcname^ = #0) then
      srcname := name;
    table := pFld0410^.org_table;
    type_ := pFld0410^.type_;
    length := pFld0410^.length;
    if pFld0410^.max_length > length then
      length := pFld0410^.max_length;
    flags := pFld0410^.flags;
    decimals := pFld0410^.decimals;
    // ??? pFld0410^.Catalog
  end
  else if FResult.FSession.FLib.FMySQLVersion >= mvMySQL040100 then begin
    pFld0401 := PMYSQL_FIELD0401(FpFld);
    name := pFld0401^.name;
    srcname := pFld0401^.org_name;
    if (srcname = nil) or (srcname^ = #0) then
      srcname := name;
    table := pFld0401^.org_table;
    type_ := pFld0401^.type_;
    length := pFld0401^.length;
    if pFld0401^.max_length > length then
      length := pFld0401^.max_length;
    flags := pFld0401^.flags;
    decimals := pFld0401^.decimals;
  end
  else if FResult.FSession.FLib.FMySQLVersion >= mvMySQL040000 then begin
    pFld0400 := PMYSQL_FIELD0400(FpFld);
    name := pFld0400^.name;
    srcname := name;
    table := pFld0400^.org_table;
    type_ := pFld0400^.type_;
    length := pFld0400^.length;
    if pFld0400^.max_length > length then
      length := pFld0400^.max_length;
    flags := pFld0400^.flags;
    decimals := pFld0400^.decimals;
  end
  else begin
    pFld0320 := PMYSQL_FIELD0320(FpFld);
    name := pFld0320^.name;
    srcname := name;
    table := pFld0320^.table;
    type_ := pFld0320^.type_;
    length := pFld0320^.length;
    if pFld0320^.max_length > length then
      length := pFld0320^.max_length;
    flags := pFld0320^.flags;
    decimals := pFld0320^.decimals;
  end;
end;

end.
