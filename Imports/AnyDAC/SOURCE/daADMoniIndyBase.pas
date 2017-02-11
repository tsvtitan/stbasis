{-------------------------------------------------------------------------------}
{ AnyDAC monitor TCP/IP (Indy) based implementation. Common part.               }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit daADMoniIndyBase;

interface

uses
  Windows, Classes, SysUtils,
  IdTCPConnection, IdTCPClient,
  daADStanIntf;

type
  // common
  TADMoniIndyQueueItem = class;
  TADMoniIndyQueue = class;
  TADMoniIndyQueueWorker = class;
  TADMoniIndyStream = class;
  TADMoniIndyAdapterList = class;
  EDEMoniException = class(Exception);

  {----------------------------------------------------------------------------}
  { TADMoniIndyQueueItem                                                       }
  {----------------------------------------------------------------------------}
  TADMoniIndyQueueEventKind = (ptNone, ptConnectClient, ptDisConnectClient,
    ptRegisterAdapter, ptUnRegisterAdapter, ptUpdateAdapter, ptNotify);
  TADMoniIndyQueueEventKinds = set of TADMoniIndyQueueEventKind;
  TADMoniIndyQueueItem = class(TObject)
  private
    procedure SetArg(AArg: PVarRec);
  public
    FProcessID: LongWord;
    FMonitorID: LongWord;
    FEvent: TADMoniIndyQueueEventKind;
    FKind: TADMoniEventKind;
    FStep: TADMoniEventStep;
    FHandle: LongWord;
    FMessage: String;
    FPath: String;
    FArgs: TStringStream;
    FProc: Pointer;
    FTime: LongWord;
    constructor Create;
    destructor Destroy; override;
    procedure SetArgs(AArgs: array of const); overload;
    procedure SetArgs(AArgs: Variant); overload;
    function GetArgs: Variant;
  end;

  {----------------------------------------------------------------------------}
  { TADMoniIndyQueue                                                           }
  {----------------------------------------------------------------------------}
  TADMoniIndyQueue = class(TObject)
  private
    FList: TList;
    FThread: TADMoniIndyQueueWorker;
    FOnPostItem: TNotifyEvent;
    FQueueCriticalSection: TRTLCriticalSection;
    function GetCount: Integer;
  public
    constructor Create(AThread: TADMoniIndyQueueWorker);
    destructor Destroy; override;
    function GetItem: TADMoniIndyQueueItem;
    function GetNextEvent: TADMoniIndyQueueEventKind;
    procedure PostItem(AItem: TADMoniIndyQueueItem);
    procedure Clear;
    property Count: Integer read GetCount;
    property OnPostItem: TNotifyEvent read FOnPostItem write FOnPostItem;
  end;

  {----------------------------------------------------------------------------}
  { TADMoniIndyQueueWorker                                                     }
  {----------------------------------------------------------------------------}
  TADMoniIndyQueueWorker = class(TThread)
  private
    FItemAvailableEvent: LongWord;
  protected
    procedure DoAction; virtual; abstract;
    function GetQueue: TADMoniIndyQueue; virtual; abstract;
    procedure Execute; override;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AbortProcessing;
    procedure Signal;
  end;

  {----------------------------------------------------------------------------}
  { TADMoniIndyStream                                                          }
  {----------------------------------------------------------------------------}
  TADMoniIndyStreamOpenMode = (omRead, omWrite);
  TADMoniIndyStreamBlockID = DWORD;
  TADMoniIndyStream = class(TObject)
  private
    FConnection: TIdTCPConnection;
    FBuffer: TStringStream;
    FBlockLevel: Integer;
    FMode: TADMoniIndyStreamOpenMode;
    procedure WriteBytes(const ABuff; ALen: Integer);
    procedure WriteValueHeader(const AParamName: String; AType: Char);
    procedure ReadBytes(var ABuff; ALen: Integer);
    procedure ReadValueHeader(const AParamName: String; AType: Char);
    procedure ReceiveBuffer;
    procedure SendBuffer;
  public
    procedure Open(AConnection: TIdTCPConnection; AMode: TADMoniIndyStreamOpenMode);
    procedure Close;
    procedure WriteBeginBlock(AID: TADMoniIndyStreamBlockID);
    procedure WriteEndBlock;
    procedure WriteString(const AParamName: String; const AValue: String);
    procedure WriteBlob(const AParamName: String; AValue: TStringStream);
    procedure WriteBoolean(const AParamName: String; AValue: Boolean);
    procedure WriteInteger(const AParamName: String; AValue: Integer);
    procedure WriteFloat(const AParamName: String; AValue: Double);
    procedure WriteDate(const AParamName: String; AValue: TDateTime);

    procedure ReadBeginBlock(AID: TADMoniIndyStreamBlockID);
    procedure ReadEndBlock;
    function IsEndBlock: Boolean;
    function ReadString(const AParamName: String): String;
    procedure ReadBlob(const AParamName: String; AValue: TStringStream);
    function ReadBoolean(const AParamName: String): Boolean;
    function ReadInteger(const AParamName: String): Integer;
    function ReadFloat(const AParamName: String): Double;
    function ReadDate(const AParamName: String): TDateTime;
  end;

  {----------------------------------------------------------------------------}
  { TADMoniIndyAdapterList                                                     }
  {----------------------------------------------------------------------------}
  TADMoniIndyAdapterList = class(TObject)
  private
    FList: TStringList;
    function GetCount: Integer;
    function GetPath(AIndex: Integer): string;
    function GetHandle(AIndex: Integer): LongWord;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function IndexOf(AHandle: LongWord): Integer;
    function FindByHandle(AHandle: LongWord): string;
    function FindByPath(const APath: string): LongWord;
    procedure AddAdapter(const APath: string; AHandle: LongWord);
    procedure RemoveAdapter(AHandle: LongWord);
    property Count: Integer read GetCount;
    property Paths[AIndex: Integer]: string read GetPath;
    property Handles[AIndex: Integer]: LongWord read GetHandle;
  end;

const
  C_AD_Mon_StringHeader: Char = 'S';
  C_AD_Mon_BooleanHeader: Char = 'B';
  C_AD_Mon_IntegerHeader: Char = 'I';
  C_AD_Mon_FloatHeader: Char = 'F';
  C_AD_Mon_DateHeader: Char = 'D';
  C_AD_Mon_BlobHeader: Char = 'L';
  C_AD_Mon_BeginBlockDelim: Char = '{';
  C_AD_Mon_EndBlockDelim: Char = '}';

  C_AD_Mon_PacketVersion: Integer = 1;
  C_AD_Mon_PacketBodyBlockID: Integer = 0;

  S_AD_MsgVersion: String = 'VER';
  S_AD_MsgEvent: String = 'EVT';
  S_AD_MsgProcessId: String = 'PID';
  S_AD_MsgMonitorId: String = 'MID';
  S_AD_MsgText: String = 'MSG';
  S_AD_MsgArgs: String = 'ARG';
  S_AD_MsgAdapterHandle: String = 'HND';
  S_AD_MsgNotifyKind: String = 'KND';
  S_AD_MsgNotifyStep: String = 'STP';
  S_AD_MsgTime: String = 'TIM';

  function ADMoniIndyIsLocalHost(const AIP: String): Boolean;

implementation

uses
{$IFDEF AnyDAC_D6}
  Variants,
{$ELSE}
  ActiveX,
{$ENDIF}
{$IFNDEF AnyDAC_INDY101}
  {$IFDEF AnyDAC_INDY10}
  IdStreamVCL,
  {$ENDIF}
{$ENDIF}
  daADStanUtil, daADStanResStrs;

{-------------------------------------------------------------------------------}
function ADMoniIndyIsLocalHost(const AIP: String): Boolean;
begin
  Result := (AIP <> '127.0.0.1') and (LowerCase(AIP) <> 'localhost');
end;

{-------------------------------------------------------------------------------}
{ TADMoniIndyQueueItem                                                          }
{-------------------------------------------------------------------------------}
constructor TADMoniIndyQueueItem.Create;
begin
  inherited Create;
  FArgs := TStringStream.Create('');
end;

{-------------------------------------------------------------------------------}
destructor TADMoniIndyQueueItem.Destroy;
begin
  FreeAndNil(FArgs);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniIndyQueueItem.SetArg(AArg: PVarRec);
var
  iLen: Integer;
  bByte: Byte;
begin
  with AArg^ do begin
    FArgs.WriteBuffer(VType, SizeOf(VType));
    case VType of
      vtInteger:
        FArgs.WriteBuffer(VInteger, SizeOf(Vinteger));
      vtBoolean:
        FArgs.WriteBuffer(VBoolean, SizeOf(VBoolean));
      vtChar:
        FArgs.WriteBuffer(VChar, SizeOf(VChar));
      vtExtended:
        FArgs.WriteBuffer(VExtended^, SizeOf(VExtended^));
      vtString:
        begin
          iLen := Length(VString^);
          FArgs.WriteBuffer(iLen, SizeOf(iLen));
          if iLen > 0 then
            FArgs.WriteBuffer(VString^[1], iLen);
        end;
      vtPointer:
        FArgs.WriteBuffer(VPointer, SizeOf(VPointer));
      vtPChar:
        begin
          iLen := StrLen(VPChar);
          FArgs.WriteBuffer(iLen, SizeOf(iLen));
          if iLen > 0 then
            FArgs.WriteBuffer(VPChar^, iLen);
        end;
      vtAnsiString:
        begin
          iLen := Length(String(VAnsiString));
          FArgs.WriteBuffer(iLen, SizeOf(iLen));
          if iLen > 0 then
            FArgs.WriteBuffer(PChar(String(VAnsiString))^, iLen);
        end;
      vtCurrency:
        FArgs.WriteBuffer(VCurrency^, SizeOf(VCurrency^));
      vtWideString:
        begin
          iLen := Length(WideString(VWideString)) * SizeOf(WideChar);
          FArgs.WriteBuffer(iLen, SizeOf(iLen));
          if iLen > 0 then
            FArgs.WriteBuffer(PWideChar(WideString(VWideString))^, iLen);
        end;
      vtPWideChar:
        begin
          iLen := ADWideStrLen(VPWideChar) * SizeOf(WideChar);
          FArgs.WriteBuffer(iLen, SizeOf(iLen));
          if iLen > 0 then
            FArgs.WriteBuffer(VPWideChar^, iLen);
        end;
      vtInt64:
        FArgs.WriteBuffer(VInt64^, SizeOf(VInt64^));
      vtObject:
        begin
          // special case - for NULL and Unassigned
          ASSERT((Byte(VObject) = 0) or (Byte(VObject) = 1));
          bByte := Byte(VObject);
          FArgs.WriteBuffer(bByte, SizeOf(bByte));
        end;
      else
        // vtObject, vtClass, vtVariant, vtInterface
        ASSERT(FALSE);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniIndyQueueItem.SetArgs(AArgs: array of const);
var
  i, iLen: Integer;
begin
  if High(AArgs) = -1 then
    Exit;
  iLen := High(AArgs);
  FArgs.WriteBuffer(iLen, SizeOf(iLen));
  for i := 0 to High(AArgs) do
    SetArg(@AArgs[i]);
end;

{-------------------------------------------------------------------------------}
procedure TADMoniIndyQueueItem.SetArgs(AArgs: Variant);
var
  i, iLen: Integer;
  V: Variant;

  procedure SetVarRec(AArgs: array of const);
  begin
    SetArg(@AArgs[0]);
  end;

begin
  if VarIsNull(AArgs) or VarIsEmpty(AArgs) then
    Exit;
  iLen := VarArrayHighBound(AArgs, 1);
  FArgs.WriteBuffer(iLen, SizeOf(iLen));
  for i := 0 to iLen do begin
    V := AArgs[i];
    with TVarData(V) do
      case VType of
        varSmallInt: SetVarRec([VSmallInt]);
        varInteger:  SetVarRec([VInteger]);
        varSingle:   SetVarRec([VSingle]);
        varDouble:   SetVarRec([VDouble]);
        varCurrency: SetVarRec([VCurrency]);
        varDate:     SetVarRec([VDate]);
        varOleStr:   SetVarRec([VOleStr]);
        varBoolean:  SetVarRec([VBoolean]);
        varByte:     SetVarRec([VByte]);
{$IFDEF AnyDAC_D6}
        varShortInt: SetVarRec([VShortInt]);               
        varWord:     SetVarRec([VWord]);
        varLongWord: SetVarRec([VLongWord]);
        varInt64:    SetVarRec([VInt64]);
{$ELSE}
        varInt64:    SetVarRec([Decimal(V).lo64]);
{$ENDIF}
        varString:   SetVarRec([String(VString)]);
        // special case - for NULL and Unassigned
        varEmpty:    SetVarRec([TObject(0)]);
        varNull:     SetVarRec([TObject(1)]);
      else
{$IFDEF AnyDAC_D6}
        if VarIsCustom(V) then
          SetVarRec(['CT: ' + VarToStrDef(V, '<error>')])
        else
{$ENDIF}
        begin
          // varAny, varArray, varByRef, varDispatch, varError, varUnknown
          ASSERT(FALSE);
        end;
      end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADMoniIndyQueueItem.GetArgs: Variant;
var
  i, iLen: Integer;
  iType: Byte;
  iInteger: Integer;
  lBoolean: Boolean;
  cChar: Char;
  fExtended: Extended;
  sString: AnsiString;
  lwLongword: LongWord;
  cCurrency: Currency;
  wsString: WideString;
  lliInt64: Int64;
  bByte: Byte;
{$IFNDEF AnyDAC_D6}
  V: Variant;
{$ENDIF}
begin
  if FArgs.Read(iLen, SizeOf(iLen)) = 0 then begin
    Result := Unassigned;
    Exit;
  end;
  Result := VarArrayCreate([0, iLen], varVariant);
  for i := 0 to iLen do begin
    FArgs.ReadBuffer(iType, SizeOf(iType));
    case iType of
      vtInteger:
        begin
          FArgs.ReadBuffer(iInteger, SizeOf(integer));
          Result[i] := iInteger;
        end;
      vtBoolean:
        begin
          FArgs.ReadBuffer(lBoolean, SizeOf(lBoolean));
          Result[i] := lBoolean;
        end;
      vtChar:
        begin
          FArgs.ReadBuffer(cChar, SizeOf(cChar));
          Result[i] := cChar;
        end;
      vtExtended:
        begin
          FArgs.ReadBuffer(fExtended, SizeOf(fExtended));
          Result[i] := fExtended;
        end;
      vtString, vtPChar, vtAnsiString:
        begin
          FArgs.ReadBuffer(iLen, SizeOf(iLen));
          if iLen > 0 then begin
            SetLength(sString, iLen);
            FArgs.ReadBuffer(sString[1], iLen);
          end
          else
            sString := '';
          Result[i] := sString;
        end;
      vtPointer:
        begin
          FArgs.ReadBuffer(lwLongword, SizeOf(lwLongword));
{$IFDEF AnyDAC_D6}
          Result[i] := lwLongword;
{$ELSE}
          Result[i] := Integer(lwLongword);
{$ENDIF}
        end;
      vtCurrency:
        begin
          FArgs.ReadBuffer(cCurrency, SizeOf(cCurrency));
          Result[i] := cCurrency;
        end;
      vtWideString, vtPWideChar:
        begin
          FArgs.ReadBuffer(iLen, SizeOf(iLen));
          if iLen > 0 then begin
            SetLength(wsString, iLen div SizeOf(WideChar));
            FArgs.ReadBuffer(wsString[1], iLen);
          end
          else
            wsString := '';
          Result[i] := wsString;
        end;
      vtInt64:
        begin
          FArgs.ReadBuffer(lliInt64, SizeOf(lliInt64));
{$IFDEF AnyDAC_D6}
          Result[i] := lliInt64;
{$ELSE}
          TVarData(V).VType := varInt64;
          Decimal(V).lo64 := lliInt64;
          Result[i] := V;
{$ENDIF}
        end;
      vtObject:
        begin
          // special case - for NULL and Unassigned
          FArgs.ReadBuffer(bByte, SizeOf(bByte));
          if bByte = 0 then
            Result[i] := Unassigned
          else if bByte = 1 then
            Result[i] := Null;
        end;
      else
        // vtObject, ctClass, vtVariant, vtInterface
        ASSERT(FALSE);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADMoniIndyQueue                                                              }
{-------------------------------------------------------------------------------}
constructor TADMoniIndyQueue.Create(AThread: TADMoniIndyQueueWorker);
begin
  inherited Create;
  FThread := AThread;
  FList := TList.Create;
  InitializeCriticalSection(FQueueCriticalSection);
end;

{-------------------------------------------------------------------------------}
destructor TADMoniIndyQueue.Destroy;
begin
  FThread := nil;
  FreeAndNil(FList);
  DeleteCriticalSection(FQueueCriticalSection);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADMoniIndyQueue.GetCount: Integer;
begin
  Result := FList.Count;
end;

{-------------------------------------------------------------------------------}
function TADMoniIndyQueue.GetNextEvent: TADMoniIndyQueueEventKind;
begin
  EnterCriticalSection(FQueueCriticalSection);
  try
    if FList.Count > 0 then
      Result := TADMoniIndyQueueItem(FList[0]).FEvent
    else
      Result := ptNone;
  finally
    LeaveCriticalSection(FQueueCriticalSection);
  end;
end;

{-------------------------------------------------------------------------------}
function TADMoniIndyQueue.GetItem: TADMoniIndyQueueItem;
begin
  EnterCriticalSection(FQueueCriticalSection);
  try
    if FList.Count > 0 then begin
      Result := TADMoniIndyQueueItem(FList[0]);
      FList.Delete(0);
    end
    else
      Result := nil;
  finally
    LeaveCriticalSection(FQueueCriticalSection);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniIndyQueue.PostItem(AItem: TADMoniIndyQueueItem);
var
  i: Integer;
  lSignal: Boolean;
begin
  i := 10;
  while (i > 0) and (FList.Count > 100) do begin
    Dec(i);
    Sleep(0);
  end;
  EnterCriticalSection(FQueueCriticalSection);
  try
    if FList.Count > 1000 then
      FList.Clear;
    lSignal := (FList.Count = 0);
    FList.Add(AItem);
  finally
    LeaveCriticalSection(FQueueCriticalSection);
  end;
  if lSignal then
    FThread.Signal;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniIndyQueue.Clear;
var
  i: Integer;
begin
  EnterCriticalSection(FQueueCriticalSection);
  try
    for i := 0 to FList.Count - 1 do
      TADMoniIndyQueueItem(FList[i]).Free;
    FList.Clear;
  finally
    LeaveCriticalSection(FQueueCriticalSection);
  end;
end;

{-------------------------------------------------------------------------------}
{ TADMoniIndyQueueWorker                                                        }
{-------------------------------------------------------------------------------}
constructor TADMoniIndyQueueWorker.Create;
begin
  inherited Create(True);
  FItemAvailableEvent := CreateEvent(nil, False, False, nil);
  if FItemAvailableEvent = 0 then
    raise EDEMoniException.Create('Win32EventFailure');
end;

{-------------------------------------------------------------------------------}
destructor TADMoniIndyQueueWorker.Destroy;
begin
  AbortProcessing;
  CloseHandle(FItemAvailableEvent);
  FItemAvailableEvent := 0;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniIndyQueueWorker.Execute;
begin
  while not Terminated do begin
    if WaitForSingleObject(FItemAvailableEvent, INFINITE) = WAIT_OBJECT_0 then
      while not Terminated and (GetQueue <> nil) and (GetQueue.Count > 0) do
        DoAction
    else
      Terminate;
  end;
  Sleep(0);
end;

{-------------------------------------------------------------------------------}
procedure TADMoniIndyQueueWorker.AbortProcessing;
var
  iExitCode: LongWord;
begin
  if Suspended then
    Resume;
  if not Terminated then begin
    Terminate;
    Signal;
    while GetExitCodeThread(Handle, iExitCode) and (iExitCode = STILL_ACTIVE) do
      Sleep(0);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniIndyQueueWorker.Signal;
begin
  SetEvent(FItemAvailableEvent);
end;

{-------------------------------------------------------------------------------}
{ TADMoniIndyStream                                                             }
{-------------------------------------------------------------------------------}
procedure TADMoniIndyStream.WriteBytes(const ABuff; ALen: Integer);
begin
  FBuffer.WriteBuffer(ABuff, ALen);
end;

{-------------------------------------------------------------------------------}
procedure TADMoniIndyStream.WriteValueHeader(const AParamName: String; AType: Char);
{$IFDEF AnyDAC_DEBUG}
var
  iLen: Integer;
{$ENDIF}
begin
{$IFDEF AnyDAC_DEBUG}
  WriteBytes(AType, SizeOf(AType));
  iLen := Length(AParamName);
  WriteBytes(iLen, SizeOf(iLen));
  if iLen > 0 then
    WriteBytes(AParamName[1], iLen);
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TADMoniIndyStream.ReadBytes(var ABuff; ALen: Integer);
begin
  FBuffer.ReadBuffer(ABuff, ALen);
end;

{-------------------------------------------------------------------------------}
procedure TADMoniIndyStream.ReadValueHeader(const AParamName: String; AType: Char);
{$IFDEF AnyDAC_DEBUG}
var
  ch: Char;
  iLen: Integer;
  sPName: String;
{$ENDIF}
begin
{$IFDEF AnyDAC_DEBUG}
  ReadBytes(ch, SizeOf(ch));
  if ch <> AType then
    raise EDEMoniException.Create(S_AD_MonEncounterType);
  ReadBytes(iLen, SizeOf(iLen));
  if iLen > 0 then begin
    SetLength(sPName, iLen);
    ReadBytes(sPName[1], iLen);
    if ADCompareText(AParamName, sPName) <> 0 then
      raise EDEMoniException.Create(S_AD_MonEncounterParamName);
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_INDY101}
procedure TADMoniIndyStream.ReceiveBuffer;
begin
  FConnection.IOHandler.ReadStream(FBuffer, -1, False);
  FBuffer.Position := 0;
end;
{$ELSE}
  {$IFDEF AnyDAC_INDY10}
procedure TADMoniIndyStream.ReceiveBuffer;
var
  oIdStream: TIdStreamVCL;
begin
  oIdStream := TIdStreamVCL.Create(FBuffer);
  try
    FConnection.IOHandler.ReadStream(oIdStream, -1, False);
  finally
    oIdStream.Free;
  end;
  FBuffer.Position := 0;
end;
  {$ELSE}
procedure TADMoniIndyStream.ReceiveBuffer;
begin
  FConnection.ReadStream(FBuffer);
  FBuffer.Position := 0;
end;
  {$ENDIF}
{$ENDIF}

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_INDY101}
procedure TADMoniIndyStream.SendBuffer;
begin
  FConnection.IOHandler.Write(FBuffer, 0, True);
end;
{$ELSE}
  {$IFDEF AnyDAC_INDY10}
procedure TADMoniIndyStream.SendBuffer;
var
  oIdStream: TIdStreamVCL;
begin
  oIdStream := TIdStreamVCL.Create(FBuffer);
  try
    FConnection.IOHandler.Write(oIdStream, 0, True);
  finally
    oIdStream.Free;
  end;
end;
  {$ELSE}
procedure TADMoniIndyStream.SendBuffer;
begin
  FConnection.WriteStream(FBuffer, True, True);
end;
  {$ENDIF}
{$ENDIF}

{-------------------------------------------------------------------------------}
procedure TADMoniIndyStream.Open(AConnection: TIdTCPConnection; AMode: TADMoniIndyStreamOpenMode);
begin
  FConnection := AConnection;
  FBlockLevel := 0;
  FMode := AMode;
  FBuffer := TStringStream.Create('');
  if FMode = omRead then
    try
      ReceiveBuffer;
    except
      Close;
      raise;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniIndyStream.Close;
begin
  if FMode = omWrite then
    SendBuffer;
  FreeAndNil(FBuffer);
end;

{-------------------------------------------------------------------------------}
procedure TADMoniIndyStream.WriteBeginBlock(AID: TADMoniIndyStreamBlockID);
begin
  WriteBytes(C_AD_Mon_BeginBlockDelim, Length(C_AD_Mon_BeginBlockDelim));
  WriteBytes(AID, SizeOf(AID));
  Inc(FBlockLevel);
end;

{-------------------------------------------------------------------------------}
procedure TADMoniIndyStream.WriteEndBlock;
begin
  WriteBytes(C_AD_Mon_EndBlockDelim, Length(C_AD_Mon_EndBlockDelim));
  Dec(FBlockLevel);
end;

{-------------------------------------------------------------------------------}
procedure TADMoniIndyStream.WriteString(const AParamName: String; const AValue: String);
var
  iLen: Integer;
begin
  WriteValueHeader(AParamName, C_AD_Mon_StringHeader);
  iLen := Length(AValue);
  WriteBytes(iLen, SizeOf(iLen));
  if iLen > 0 then
    WriteBytes(AValue[1], iLen);
end;

{-------------------------------------------------------------------------------}
procedure TADMoniIndyStream.WriteBlob(const AParamName: String; AValue: TStringStream);
var
  iLen: Integer;
begin
  WriteValueHeader(AParamName, C_AD_Mon_BlobHeader);
  iLen := AValue.Size;
  WriteBytes(iLen, SizeOf(iLen));
  if iLen > 0 then
    WriteBytes(PChar(AValue.DataString)^, iLen);
end;

{-------------------------------------------------------------------------------}
procedure TADMoniIndyStream.WriteBoolean(const AParamName: String; AValue: Boolean);
var
  B: Byte;
begin
  B := Byte(AValue);
  WriteValueHeader(AParamName, C_AD_Mon_BooleanHeader);
  WriteBytes(B, SizeOf(B));
end;

{-------------------------------------------------------------------------------}
procedure TADMoniIndyStream.WriteInteger(const AParamName: String; AValue: Integer);
begin
  WriteValueHeader(AParamName, C_AD_Mon_IntegerHeader);
  WriteBytes(AValue, SizeOf(AValue));
end;

{-------------------------------------------------------------------------------}
procedure TADMoniIndyStream.WriteFloat(const AParamName: String; AValue: Double);
begin
  WriteValueHeader(AParamName, C_AD_Mon_FloatHeader);
  WriteBytes(AValue, SizeOf(AValue));
end;

{-------------------------------------------------------------------------------}
procedure TADMoniIndyStream.WriteDate(const AParamName: String; AValue: TDateTime);
begin
  WriteValueHeader(AParamName, C_AD_Mon_DateHeader);
  WriteBytes(AValue, SizeOf(AValue));
end;

{-------------------------------------------------------------------------------}
procedure TADMoniIndyStream.ReadBeginBlock(AID: TADMoniIndyStreamBlockID);
var
  iLen: Integer;
  iID: TADMoniIndyStreamBlockID;
  s: String;
begin
  iLen := Length(C_AD_Mon_BeginBlockDelim);
  SetLength(s, iLen);
  ReadBytes(s[1], iLen);
  if ADCompareText(s, C_AD_Mon_BeginBlockDelim) <> 0 then
    raise EDEMoniException.Create(S_AD_MonEncounterBlock);
  ReadBytes(iID, SizeOf(iID));
  if AID <> iID then
    raise EDEMoniException.Create(S_AD_MonEncounterBlock);
  Inc(FBlockLevel);
end;

{-------------------------------------------------------------------------------}
procedure TADMoniIndyStream.ReadEndBlock;
var
  iLen: Integer;
  s: String;
begin
  while not IsEndBlock do
    FBuffer.Position := FBuffer.Position + 1;
  iLen := Length(C_AD_Mon_EndBlockDelim);
  SetLength(s, iLen);
  ReadBytes(s[1], iLen);
  Dec(FBlockLevel);
end;

{-------------------------------------------------------------------------------}
function TADMoniIndyStream.IsEndBlock: Boolean;
var
  iPos, iLen: Integer;
  s: String;
begin
  iPos := FBuffer.Position;
  try
    iLen := Length(C_AD_Mon_EndBlockDelim);
    SetLength(s, iLen);
    ReadBytes(s[1], iLen);
    Result := ADCompareText(s, C_AD_Mon_EndBlockDelim) = 0;
  finally
    FBuffer.Position := iPos;
  end;
end;

{-------------------------------------------------------------------------------}
function TADMoniIndyStream.ReadString(const AParamName: String): String;
var
  iLen: Integer;
begin
  ReadValueHeader(AParamName, C_AD_Mon_StringHeader);
  ReadBytes(iLen, SizeOf(iLen));
  if iLen > 0 then begin
    SetLength(Result, iLen);
    ReadBytes(Result[1], iLen);
  end
  else
    Result := '';
end;

{-------------------------------------------------------------------------------}
procedure TADMoniIndyStream.ReadBlob(const AParamName: String; AValue: TStringStream);
var
  iLen: Integer;
begin
  ReadValueHeader(AParamName, C_AD_Mon_BlobHeader);
  ReadBytes(iLen, SizeOf(iLen));
  AValue.Size := iLen;
  if iLen > 0 then
    ReadBytes(PChar(AValue.DataString)^, iLen);
end;

{-------------------------------------------------------------------------------}
function TADMoniIndyStream.ReadBoolean(const AParamName: String): Boolean;
var
  B: Byte;
begin
  ReadValueHeader(AParamName, C_AD_Mon_BooleanHeader);
  ReadBytes(B, SizeOf(B));
  Result := Boolean(B);
end;

{-------------------------------------------------------------------------------}
function TADMoniIndyStream.ReadInteger(const AParamName: String): Integer;
begin
  ReadValueHeader(AParamName, C_AD_Mon_IntegerHeader);
  ReadBytes(Result, SizeOf(Result));
end;

{-------------------------------------------------------------------------------}
function TADMoniIndyStream.ReadFloat(const AParamName: String): Double;
begin
  ReadValueHeader(AParamName, C_AD_Mon_FloatHeader);
  ReadBytes(Result, SizeOf(Result));
end;

{-------------------------------------------------------------------------------}
function TADMoniIndyStream.ReadDate(const AParamName: String): TDateTime;
begin
  ReadValueHeader(AParamName, C_AD_Mon_DateHeader);
  ReadBytes(Result, SizeOf(Result));
end;

{-------------------------------------------------------------------------------}
{ TADMoniIndyAdapterList                                                        }
{-------------------------------------------------------------------------------}
constructor TADMoniIndyAdapterList.Create;
begin
  inherited Create;
  FList := TStringList.Create;
end;

{-------------------------------------------------------------------------------}
destructor TADMoniIndyAdapterList.Destroy;
begin
  Clear;
  FreeAndNil(FList);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniIndyAdapterList.Clear;
begin
  FList.Clear;
end;

{-------------------------------------------------------------------------------}
function TADMoniIndyAdapterList.GetCount: Integer;
begin
  Result := FList.Count;
end;

{-------------------------------------------------------------------------------}
function TADMoniIndyAdapterList.GetPath(AIndex: Integer): string;
begin
  Result := FList[AIndex];
end;

{-------------------------------------------------------------------------------}
function TADMoniIndyAdapterList.GetHandle(AIndex: Integer): LongWord;
begin
  Result := LongWord(FList.Objects[AIndex]);
end;

{-------------------------------------------------------------------------------}
function TADMoniIndyAdapterList.IndexOf(AHandle: LongWord): Integer;
var
  i: Integer;
begin
  for i := 0 to FList.Count - 1 do
    if LongWord(FList.Objects[i]) = AHandle then begin
      Result := i;
      Exit;
    end;
  Result := -1;
end;

{-------------------------------------------------------------------------------}
function TADMoniIndyAdapterList.FindByHandle(AHandle: LongWord): string;
var
  i: Integer;
begin
  i := IndexOf(AHandle);
  if i <> -1 then
    Result := FList[i]
  else
    Result := '';
end;

{-------------------------------------------------------------------------------}
function TADMoniIndyAdapterList.FindByPath(const APath: string): LongWord;
var
  i: Integer;
begin
  if FList.Find(APath, i) then
    Result := LongWord(FList.Objects[i])
  else
    Result := 0;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniIndyAdapterList.AddAdapter(const APath: string; AHandle: LongWord);
begin
  FList.AddObject(APath, TObject(AHandle));
end;

{-------------------------------------------------------------------------------}
procedure TADMoniIndyAdapterList.RemoveAdapter(AHandle: LongWord);
var
  i: Integer;
begin
  i := IndexOf(AHandle);
  if i <> -1 then
    FList.Delete(i);
end;

end.
