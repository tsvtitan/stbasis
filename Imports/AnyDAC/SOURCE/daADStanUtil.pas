{-------------------------------------------------------------------------------}
{ AnyDAC utilities                                                              }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit daADStanUtil;

interface

uses
{$IFDEF CLR}
  Windows, System.Text, System.Globalization,
{$ELSE}
  {$IFDEF LINUX}
  Types, Libc,
  {$ELSE}
  Windows,
  {$ENDIF}
{$ENDIF}
  SysUtils, Classes, SyncObjs,
{$IFDEF AnyDAC_D6}
  SqlTimSt, FmtBCD, Variants,
{$ENDIF}
  daADStanIntf;

{$IFNDEF AnyDAC_D6Base}
const
  soBeginning = soFromBeginning;
  soEnd = soFromEnd;
{$ENDIF}

type
  TADFileStream = class;
  TADStringList = class;
{$IFNDEF CLR}
  TADMemPool = class;
{$ENDIF}
  TADThreadMsgBase = class;
  TADThread = class;

  TADFileStream = class(TFileStream)
{$IFNDEF CLR}
  private
    FModified: Boolean;
    FBuffer: PChar;
    FStreamBufferSize: word;
    FPos, FBufStart, FBufEnd: Int64;
    procedure SyncBuffer(ReRead: Boolean);
  public
    constructor Create(const AFileName: string; AMode: Word; AStreamBufferSize: Word = $7FFF);
    destructor Destroy; override;
    function Read(var Buffer; Count: Longint): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    function Seek(Offset: Longint; Origin: Word): Longint; override;
  {$IFDEF AnyDAC_D6}
    function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64; override;
  {$ENDIF}
{$ENDIF}
  end;

  TADStringList = class(TStringList)
{$IFDEF AnyDAC_D6}
  public
    property UpdateCount;
{$ELSE}
  private
    function GetUpdateCount: Integer;
  public
    property UpdateCount: Integer read GetUpdateCount;
{$ENDIF}
  protected
{$IFDEF AnyDAC_NOLOCALE_META}
  {$IFDEF AnyDAC_D6}
    function CompareStrings(const S1, S2: string): Integer; override;
  {$ENDIF}
{$ENDIF}
  end;

{$IFNDEF CLR}
  TADMemPool = class(TObject)
  private
    FItemSize: LongWord;
  public
    constructor Create(AItemSize, AItemsPerPage, APreallocate: LongWord);
    destructor Destroy; override;
    function Alloc: Pointer;
    procedure Release(APtr: Pointer);
  end;
{$ENDIF}

  TADThreadMsgClass = class of TADThreadMsgBase;
  TADThreadMsgBase = class(TObject)
  public
    constructor Create; overload; virtual;
    function Perform(AThread: TADThread): Boolean; virtual;
  end;

  TADThreadStartMsg = class(TADThreadMsgBase)
  public
    function Perform(AThread: TADThread): Boolean; override;
  end;

  TADThreadStopMsg = class(TADThreadStartMsg)
  end;

  TADThreadTerminateMsg = class (TADThreadMsgBase)
  public
    function Perform(AThread: TADThread): Boolean; override;
  end;

  TADThread = class(TThread)
  private
    FActive: Boolean;
    FTimeout: LongWord;
    FMessages: TThreadList;
    FStartupEvent: TEvent;
    FMessageEvent: TEvent;
    procedure SetActive(AValue: Boolean);
  protected
    procedure Execute; override;
    function DoAllowTerminate: Boolean; virtual;
    procedure DoIdle; virtual;
    procedure DoActiveChanged; virtual;
    class function GetStartMsgClass: TADThreadMsgClass; virtual;
    class function GetStopMsgClass: TADThreadMsgClass; virtual;
    class function GetTerminateMsgClass: TADThreadMsgClass; virtual;
    property Messages: TThreadList read FMessages;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Shutdown(AWait: Boolean = True);
    procedure Ping;
    procedure EnqueueMsg(AMsg: TADThreadMsgBase);
    property Timeout: LongWord read FTimeout write FTimeout;
    property Active: Boolean read FActive write SetActive;
  end;

{$IFDEF AnyDAC_FPC}
  PADThreadInfo = ^TADThreadInfo;
  TADThreadInfo = record
    Next: PADThreadInfo;
    ThreadID: Cardinal;
    Active: Integer;
    RecursionCount: Cardinal;
  end;

  TADThreadLocalCounter = class
  private
    FHashTable: array [0..15] of PADThreadInfo;
    function HashIndex: Byte;
    function Recycle: PADThreadInfo;
  public
    destructor Destroy; override;
    procedure Open(var Thread: PADThreadInfo);
    procedure Delete(var Thread: PADThreadInfo);
    procedure Close(var Thread: PADThreadInfo);
  end;

  TADMREWSynchronizer = class(TInterfacedObject, IReadWriteSync)
  private
    FSentinel: Integer;
    FReadSignal: THandle;
    FWriteSignal: THandle;
    FWaitRecycle: Cardinal;
    FWriteRecursionCount: Cardinal;
    tls: TADThreadLocalCounter;
    FWriterID: Cardinal;
    FRevisionLevel: Cardinal;
    procedure BlockReaders;
    procedure UnblockReaders;
    procedure UnblockOneWriter;
    procedure WaitForReadSignal;
    procedure WaitForWriteSignal;
  public
    constructor Create;
    destructor Destroy; override;
    procedure BeginRead;
    procedure EndRead;
    function BeginWrite: Boolean;
    procedure EndWrite;
    property RevisionLevel: Cardinal read FRevisionLevel;
  end;
{$ELSE}
  TADMREWSynchronizer = TMultiReadExclusiveWriteSynchronizer;
{$ENDIF}

// Ansi string
function ADStrLike(const AStr, AMask: String; ANoCase: Boolean = False;
  AManyCharsMask: Char = '%'; AOneCharMask: Char = '_'; AEscapeChar: Char = '\'): Boolean;
function ADPosEx(const ASub, AStr: String; AFrom: Integer = 1): Integer;
{$IFDEF CLR}
function ADStrRPos(Str1, Str2: String): Integer;
{$ELSE}
function ADStrRPos(Str1, Str2: PChar): PChar;
{$ENDIF}
function ADCharUpperCase(ACh: Char): Char;
function ADCharLowerCase(ACh: Char): Char;
function ADPadR(const AStr: String; ALength: Integer): String;
function ADPadL(const AStr: String; ALength: Integer): String;
function ADValToStr(const AValue: Variant; AQuotes: Boolean): String;
function ADIdentToStr(const AValue: Variant; var AQuotes: Boolean): String;
function ADFixCRLF(const AStr: String): String;
function ADExtractFieldName(const AStr: String; var APos: Integer): String; overload;
function ADExtractFieldName(const AStr: String; var APos: Integer; const AFmt: TADParseFmtSettings): String; overload;
function ADValueFromIndex(AStrs: TStrings; AIndex: Integer): String;
function ADStrToken(const AString: String; AChars: TChars; var AFrom: Integer;
  ASqueeze: Boolean = False): String;

// Wide string
{$IFDEF CLR}
function ADWideStrLen(AStr: WideString): Integer;
{$ELSE}
function ADWideStrLen(AStr: PWideChar): Integer;
{$ENDIF}

// Pointers
function ADAddOffset(APointer: Pointer; AOffset: Integer): Pointer;
function ADIncPointer(var APointer: Pointer; AOffset: Integer): Pointer;

// System & path
function ADLastSystemErrorMsg: String;
function ADGetCmdParam(const AParName: String; const ADefValue: String): String;
function ADGetSystemPath: String;
function ADGetAppPath: String;
function ADGetMyDocsPath: String;
function ADGetBestPath(const ASpecifiedFileName, AGlobalFileName, ADefFileName: String): String;
{$IFDEF Win32}
function ADGetVersionInfo(const AFileName: string; var AProduct,
  AVersion, AVersionName, ACopyright, AInfo: string): Boolean;
{$ENDIF}
function ADVerStr2Int(const AVersion: String): Integer;
function ADReadRegValue(const AValue: String): String;
function ADReadEnvValue(const AName: String): String;
function ADExpandStr(const AStr: String): String;
function ADIsDesignTime: Boolean;

// Date & time
function ADIsSQLTimeStampBlank(const ATimeStamp: TADSQLTimeStamp): Boolean;
function ADDateTimeToSQLTimeStamp(const ADateTime: TDateTime): TADSQLTimeStamp;
function ADSQLTimeStampToDateTime(const ADateTime: TADSQLTimeStamp): TDateTime;
function ADSQLTimeStamp2Time(const AValue: TADSQLTimeStamp): Longint;
function ADSQLTimeStamp2Date(const AValue: TADSQLTimeStamp): Longint;
function ADTime2SQLTimeStamp(const AValue: Longint): TADSQLTimeStamp;
function ADDate2SQLTimeStamp(const AValue: Longint): TADSQLTimeStamp;
function ADTime2DateTime(const AValue: Longint): TDateTime;
function ADDateTime2Time(const AValue: TDateTime): Longint;
function ADDate2DateTime(const AValue: Longint): TDateTime;
function ADDateTime2Date(const AValue: TDateTime): Longint;

// BCD & numeric
function ADFixFMTBcdAdd(const V1, V2: Variant): Variant;
function ADFixFMTBcdSub(const V1, V2: Variant): Variant;
function ADFixFMTBcdDiv(const V1, V2: Variant): Variant;
{$IFDEF CLR}
function ADCompareUInt64(const Value1, Value2: UInt64): Integer;
procedure ADStr2BCD(pIn: String; ASize: Integer; var ABcd: TBcd; ADot: Char);
procedure ADBCD2Str(var pOut: String; var ASize: Integer; const ABcd: TBcd; ADot: Char);
procedure ADStr2Int(ASrcData: String; ASrcLen: Integer;
  out ADestData: System.Object; ADestLen: Integer; ANoSign: Boolean);
{$ELSE}
function ADCompareUInt64(const Value1, Value2: Int64): Integer;
procedure ADStr2BCD(pIn: PChar; ASize: Integer; var ABcd: TADBcd; ADot: Char);
procedure ADBCD2Str(pOut: PChar; var ASize: Integer; const ABcd: TADBcd; ADot: Char);
procedure ADStr2Int(ASrcData: PChar; ASrcLen: Integer;
  ADestData: Pointer; ADestLen: Integer; ANoSign: Boolean);
{$ENDIF}
{$IFDEF AnyDAC_FPC}
function CurrToBCD(const Curr: Currency; var BCD: TADBcd; Precision: Integer = 32;
  Decimals: Integer = 4): Boolean;
function BCDToCurr(const BCD: TADBcd; var Curr: Currency): Boolean;
{$ENDIF}

// other
{$IFDEF CLR}
function ADIndexOf(AList: array of TObject; ALen: Integer; AItem: TObject): Integer;
function ADLocale2Name(ALocale: CultureInfo): String;
{$ELSE}
function ADIndexOf(AList: Pointer; ALen: Integer; AItem: Pointer): Integer;
function ADLocale2Name(ALocale: LCID): String;
{$ENDIF}
function ADTimeout(AStartTicks, ATimeout: LongWord): Boolean;
function ADAcquireExceptionObject: Exception;
procedure ADHandleException;

// standard routine replacement
{$IFNDEF CLR}
type
  TADMoveProc = procedure(const Source; var Dest; Count: integer);
  TADFillChar = procedure(var Dest; count: Integer; Value: Char);
  TADCompareText = function(const S1, S2: String): Integer;
var
  ADMove: TADMoveProc;
  ADFillChar: TADFillChar;
  ADCompareText: TADCompareText;
{$ENDIF}
{$IFDEF CLR}
type
  TADCompareText = function(const S1, S2: String): Integer;
var
  ADCompareText: TADCompareText;
  MainThreadID: LongWord;
{$ENDIF}

var
  GParseFmtSettings: TADParseFmtSettings;
  GSemicolonFmtSettings: TADParseFmtSettings;
  GSpaceFmtSettings: TADParseFmtSettings;

implementation

uses
{$IFDEF AnyDAC_D7}
  StrUtils,
{$ENDIF}
{$IFDEF AnyDAC_FactCodeRTL}
  daADStanFCCPUID,
  daADStanFCMoveJOHUnit4,
  daADStanFCCompareTextShaUnit,
  daADStanFCFillCharDKCUnit,
  daADStanFCFillCharUnit,
{$ENDIF}
  Registry, ActiveX,
{$IFNDEF AnyDAC_FPC}
  ComObj, ShlObj,
{$ENDIF}
  daADStanConst;

var
  C_Date_1_1_1: TDateTime;

{$IFNDEF CLR}
{ ---------------------------------------------------------------------------- }
{ TADFileStream                                                                }
{ ---------------------------------------------------------------------------- }
constructor TADFileStream.Create(const AFileName: string; AMode: Word; AStreamBufferSize: Word = $7FFF);
begin
  inherited Create(AFileName, AMode);
  FStreamBufferSize := AStreamBufferSize;
  GetMem(FBuffer, FStreamBufferSize);
  SyncBuffer(True);
end;

{---------------------------------------------------------------------------- }
destructor TADFileStream.Destroy;
begin
  SyncBuffer(False);
  FreeMem(FBuffer, FStreamBufferSize);
  inherited;
end;

{---------------------------------------------------------------------------- }
procedure TADFileStream.SyncBuffer(ReRead: boolean);
begin
  if FModified then begin
    inherited Seek(FBufStart, soBeginning);
    inherited Write(FBuffer^, Longint(FBufEnd - FBufStart));
    FModified := False;
  end;
  if ReRead then begin
    FBufStart := inherited Seek(FPos, soBeginning);
    FBufEnd := FBufStart + inherited Read(FBuffer^, FStreamBufferSize);
  end
  else begin
    inherited Seek(FPos, soBeginning);
    FBufEnd := FBufStart;
  end;
end;

{---------------------------------------------------------------------------- }
function TADFileStream.Read(var Buffer; Count: Longint): Longint;
begin
  if Count >= FStreamBufferSize then begin
    SyncBuffer(False);
    Result := inherited Read(Buffer, Count)
  end
  else begin
    if (FBufStart > FPos) or (FPos + Count > FBufEnd) then
      SyncBuffer(True);
    if (Count < FBufEnd - FPos) then
      Result := Count
    else
      Result := Longint(FBufEnd - FPos);
    if Result = 1 then
      PChar(@Buffer)^ := (FBuffer + (FPos - FBufStart))^
    else
      ADMove((FBuffer + (FPos - FBufStart))^, Buffer, Result);
  end;
  FPos := FPos + Result;
end;

{---------------------------------------------------------------------------- }
function TADFileStream.Write(const Buffer; Count: Longint): Longint;
begin
  if Count >= FStreamBufferSize then begin
    SyncBuffer(False);
    Result := inherited Write(Buffer, Count);
    FPos := FPos + Result;
  end
  else begin
    if (FBufStart > FPos) or (FPos + Count > FBufStart + FStreamBufferSize) then
      SyncBuffer(True);
    Result := Count;
    if Result = 1 then
      (FBuffer + (FPos - FBufStart))^ := PChar(@Buffer)^
    else
      ADMove(Buffer, (FBuffer + (FPos - FBufStart))^, Result);
    FModified := True;
    FPos := FPos + Result;
    if (FPos > FBufEnd) then
      FBufEnd := FPos;
  end;
end;

{---------------------------------------------------------------------------- }
function TADFileStream.Seek(Offset: Longint; Origin: Word): Longint;
begin
  case Origin of
    soFromBeginning: FPos := Offset;
    soFromCurrent:   FPos := FPos + Offset;
    soFromEnd:       FPos := inherited Seek(Offset, Origin);
  else
    Assert(False);
  end;
  Result := Longint(FPos);
end;

{$IFDEF AnyDAC_D6}
{---------------------------------------------------------------------------- }
function TADFileStream.Seek(const Offset: Int64; Origin: TSeekOrigin): Int64;
begin
  case Origin of
    soBeginning: FPos := Offset;
    soCurrent:   FPos := FPos + Offset;
    soEnd:       FPos := inherited Seek(Offset,Origin);
  else
    Assert(False);
  end;
  Result := FPos;
end;
{$ENDIF}

{------------------------------------------------------------------------------}
{ TADStringList                                                                }
{------------------------------------------------------------------------------}
{$IFDEF AnyDAC_NOLOCALE_META}
  {$IFDEF AnyDAC_D6}
function TADStringList.CompareStrings(const S1, S2: string): Integer;
begin
  if CaseSensitive then
    Result := CompareStr(S1, S2)
  else
    Result := ADCompareText(S1, S2);
end;
  {$ENDIF}
{$ENDIF}

{------------------------------------------------------------------------------}
{$IFNDEF AnyDAC_D6}
type
  __TStrings = class(TPersistent)
  private
    FUpdateCount: Integer;
  end;

function TADStringList.GetUpdateCount: Integer;
begin
  Result := __TStrings(Self).FUpdateCount;
end;
{$ENDIF}

{------------------------------------------------------------------------------}
{ TADMemPool                                                                   }
{------------------------------------------------------------------------------}
constructor TADMemPool.Create(AItemSize, AItemsPerPage, APreallocate: LongWord);
begin
  inherited Create;
  FItemSize := AItemSize;
end;

{------------------------------------------------------------------------------}
destructor TADMemPool.Destroy;
begin
  inherited Destroy;
end;

{------------------------------------------------------------------------------}
function TADMemPool.Alloc: Pointer;
begin
  GetMem(Result, FItemSize);
end;

{------------------------------------------------------------------------------}
procedure TADMemPool.Release(APtr: Pointer);
begin
  FreeMem(APtr, FItemSize);
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
{ TADThreadMsgBase                                                              }
{-------------------------------------------------------------------------------}
constructor TADThreadMsgBase.Create;
begin
  inherited Create;
end;

{-------------------------------------------------------------------------------}
function TADThreadMsgBase.Perform(AThread: TADThread): Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
{ TADThreadStartMsg                                                             }
{-------------------------------------------------------------------------------}
function TADThreadStartMsg.Perform(AThread: TADThread): Boolean;
begin
  AThread.FStartupEvent.SetEvent;
  Result := True;
end;

{-------------------------------------------------------------------------------}
{ TADThreadTerminateMsg                                                         }
{-------------------------------------------------------------------------------}
function TADThreadTerminateMsg.Perform(AThread: TADThread): Boolean;
begin
  AThread.Terminate;
  Result := False;
end;

{-------------------------------------------------------------------------------}
{ TADThread                                                                     }
{-------------------------------------------------------------------------------}
constructor TADThread.Create;
begin
  inherited Create(True);
  FreeOnTerminate := True;
  FActive := False;
  FMessages := TThreadList.Create;
  FMessages.Duplicates := dupAccept;
  FMessageEvent := TEvent.Create(nil, False, False, '');
  FStartupEvent := TEvent.Create(nil, False, False, '');
  FTimeout := C_AD_WorkerTimeout;
end;

{-------------------------------------------------------------------------------}
destructor TADThread.Destroy;
begin
  Shutdown(True);
  FreeAndNil(FStartupEvent);
  FreeAndNil(FMessageEvent);
  FreeAndNil(FMessages);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
class function TADThread.GetStartMsgClass: TADThreadMsgClass;
begin
  Result := TADThreadStartMsg;
end;

{-------------------------------------------------------------------------------}
class function TADThread.GetStopMsgClass: TADThreadMsgClass;
begin
  Result := TADThreadStopMsg;
end;

{-------------------------------------------------------------------------------}
class function TADThread.GetTerminateMsgClass: TADThreadMsgClass;
begin
  Result := TADThreadTerminateMsg;
end;

{-------------------------------------------------------------------------------}
procedure TADThread.DoActiveChanged;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADThread.SetActive(AValue: Boolean);
begin
  if FActive <> AValue then begin
    FActive := AValue;
    try
      if Suspended then
        Resume;
      if FActive then
        EnqueueMsg(GetStartMsgClass().Create)
      else
        EnqueueMsg(GetStopMsgClass().Create);
      FStartupEvent.WaitFor(FTimeout);
      DoActiveChanged;
    except
      FActive := False;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADThread.Shutdown(AWait: Boolean);
var
  iExitCode: LongWord;
begin
  if GetCurrentThreadId = ThreadID then begin
    Terminate;
    Exit;
  end;
  if Suspended then
    Resume;
  if Active then begin
    EnqueueMsg(GetTerminateMsgClass().Create);
    Active := False;
  end;
  Terminate;
  repeat
    Sleep(0);
    iExitCode := 0;
  until not (AWait and GetExitCodeThread(Handle, iExitCode) and (iExitCode = STILL_ACTIVE));
end;

{-------------------------------------------------------------------------------}
procedure TADThread.EnqueueMsg(AMsg: TADThreadMsgBase);
begin
  FMessages.Add(AMsg);
  FMessageEvent.SetEvent;
end;

{-------------------------------------------------------------------------------}
procedure TADThread.Ping;
begin
  FMessageEvent.SetEvent;
//???  EnqueueMsg(TADThreadMsgBase.Create);
end;

{-------------------------------------------------------------------------------}
function TADThread.DoAllowTerminate: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
procedure TADThread.DoIdle;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADThread.Execute;
var
  oRecievedMsgs: TList;
  i: Integer;

  procedure Idle;
  begin
    if not (Terminated and DoAllowTerminate) then
      DoIdle;
  end;

begin
  while not (Terminated and DoAllowTerminate) do begin
    try
      case FMessageEvent.WaitFor(FTimeout) of
      wrSignaled:
        begin
          oRecievedMsgs := FMessages.LockList;
          try
            if oRecievedMsgs.Count = 0 then
              Idle
            else
              for i := 0 to oRecievedMsgs.Count - 1 do begin
                with TADThreadMsgBase(oRecievedMsgs[i]) do
                try
                  if not Perform(Self) then
                    Break;
                finally
                  Free;
                end;
                Idle;
              end;
          finally
{$IFDEF AnyDAC_D6}
            oRecievedMsgs.Count := 0;
{$ELSE}
            oRecievedMsgs.Clear;
{$ENDIF}
            FMessages.UnlockList;
          end;
        end;
      wrTimeout:
        Idle;
      else
        Terminate;
      end;
    except
      // no exceptions
    end;
  end;
end;

{$IFDEF AnyDAC_FPC}
{-------------------------------------------------------------------------------}
{ TADThreadLocalCounter                                                         }
{-------------------------------------------------------------------------------}
const
  Alive = High(Integer);

{-------------------------------------------------------------------------------}
destructor TADThreadLocalCounter.Destroy;
var
  P, Q: PADThreadInfo;
  I: Integer;
begin
  for I := 0 to High(FHashTable) do
  begin
    P := FHashTable[I];
    FHashTable[I] := nil;
    while P <> nil do
    begin
      Q := P;
      P := P^.Next;
      FreeMem(Q);
    end;
  end;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADThreadLocalCounter.HashIndex: Byte;
var
  H: Word;
begin
  H := Word(GetCurrentThreadID);
  Result := (WordRec(H).Lo xor WordRec(H).Hi) and 15;
end;

{-------------------------------------------------------------------------------}
procedure TADThreadLocalCounter.Open(var Thread: PADThreadInfo);
var
  P: PADThreadInfo;
  CurThread: Cardinal;
  H: Byte;
begin
  H := HashIndex;
  CurThread := GetCurrentThreadID;

  P := FHashTable[H];
  while (P <> nil) and (P.ThreadID <> CurThread) do
    P := P.Next;

  if P = nil then
  begin
    P := Recycle;

    if P = nil then
    begin
      P := PADThreadInfo(AllocMem(sizeof(TADThreadInfo)));
      P.ThreadID := CurThread;
      P.Active := Alive;

      // Another thread could start traversing the list between when we set the
      // head to P and when we assign to P.Next.  Initializing P.Next to point
      // to itself will make others spin until we assign the tail to P.Next.
      P.Next := P;
      P.Next := PADThreadInfo(InterlockedExchange(Integer(FHashTable[H]), Integer(P)));
    end;
  end;
  Thread := P;
end;

{-------------------------------------------------------------------------------}
procedure TADThreadLocalCounter.Close(var Thread: PADThreadInfo);
begin
  Thread := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADThreadLocalCounter.Delete(var Thread: PADThreadInfo);
begin
  Thread.ThreadID := 0;
  Thread.Active := 0;
end;

{-------------------------------------------------------------------------------}
function TADThreadLocalCounter.Recycle: PADThreadInfo;
var
  Gen: Integer;
begin
  Result := FHashTable[HashIndex];
  while (Result <> nil) do
  begin
    Gen := InterlockedExchange(Result.Active, Alive);
    if Gen <> Alive then
    begin
      Result.ThreadID := GetCurrentThreadID;
      Exit;
    end
    else
      Result := Result.Next;
  end;
end;


{-------------------------------------------------------------------------------}
{ TADMREWSynchronizer                                                           }
{-------------------------------------------------------------------------------}
const
  mrWriteRequest = $FFFF; // 65535 concurrent read requests (threads)
                          // 32768 concurrent write requests (threads)
                          // only one write lock at a time
                          // 2^32 lock recursions per thread (read and write combined)

constructor TADMREWSynchronizer.Create;
begin
  inherited Create;
  FSentinel := mrWriteRequest;
  FReadSignal := CreateEvent(nil, True, True, nil);  // manual reset, start signaled
  FWriteSignal := CreateEvent(nil, False, False, nil); // auto reset, start blocked
  FWaitRecycle := INFINITE;
  tls := TADThreadLocalCounter.Create;
end;

{-------------------------------------------------------------------------------}
destructor TADMREWSynchronizer.Destroy;
begin
  BeginWrite;
  inherited Destroy;
  CloseHandle(FReadSignal);
  CloseHandle(FWriteSignal);
  tls.Free;
end;

{-------------------------------------------------------------------------------}
procedure TADMREWSynchronizer.BlockReaders;
begin
  ResetEvent(FReadSignal);
end;

{-------------------------------------------------------------------------------}
procedure TADMREWSynchronizer.UnblockReaders;
begin
  SetEvent(FReadSignal);
end;

{-------------------------------------------------------------------------------}
procedure TADMREWSynchronizer.UnblockOneWriter;
begin
  SetEvent(FWriteSignal);
end;

{-------------------------------------------------------------------------------}
procedure TADMREWSynchronizer.WaitForReadSignal;
begin
  WaitForSingleObject(FReadSignal, FWaitRecycle);
end;

{-------------------------------------------------------------------------------}
procedure TADMREWSynchronizer.WaitForWriteSignal;
begin
  WaitForSingleObject(FWriteSignal, FWaitRecycle);
end;

{-------------------------------------------------------------------------------}
{$IFDEF DEBUG_MREWS}
var
  x: Integer;

procedure TADMREWSynchronizer.Debug(const Msg: string);
begin
  OutputDebugString(PChar(Format('%d %s Thread=%x Sentinel=%d, FWriterID=%x',
    [InterlockedIncrement(x), Msg, GetCurrentThreadID, FSentinel, FWriterID])));
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
function TADMREWSynchronizer.BeginWrite: Boolean;
var
  Thread: PADThreadInfo;
  HasReadLock: Boolean;
  ThreadID: Cardinal;
  Test: Integer;
  OldRevisionLevel: Cardinal;
begin
  {
    States of FSentinel (roughly - during inc/dec's, the states may not be exactly what is said here):
    mrWriteRequest:         A reader or a writer can get the lock
    1 - (mrWriteRequest-1): A reader (possibly more than one) has the lock
    0:                      A writer (possibly) just got the lock, if returned from the main write While loop
    < 0, but not a multiple of mrWriteRequest: Writer(s) want the lock, but reader(s) have it.
          New readers should be blocked, but current readers should be able to call BeginRead
    < 0, but a multiple of mrWriteRequest: Writer(s) waiting for a writer to finish
  }


{$IFDEF DEBUG_MREWS}
  Debug('Write enter------------------------------------');
{$ENDIF}
  Result := True;
  ThreadID := GetCurrentThreadID;
  if FWriterID <> ThreadID then  // somebody or nobody has a write lock
  begin
    // Prevent new readers from entering while we wait for the existing readers
    // to exit.
    BlockReaders;

    OldRevisionLevel := FRevisionLevel;

    Thread := nil;
    tls.Open(Thread);
    // We have another lock already. It must be a read lock, because if it
    // were a write lock, FWriterID would be our threadid.
    HasReadLock := Thread.RecursionCount > 0;

    if HasReadLock then    // acquiring a write lock requires releasing read locks
      InterlockedIncrement(FSentinel);

{$IFDEF DEBUG_MREWS}
    Debug('Write before loop');
{$ENDIF}
    // InterlockedExchangeAdd returns prev value
    while InterlockedExchangeAdd(FSentinel, -mrWriteRequest) <> mrWriteRequest do
    begin
{$IFDEF DEBUG_MREWS}
      Debug('Write loop');
      Sleep(1000); // sleep to force / debug race condition
      Debug('Write loop2a');
{$ENDIF}

      // Undo what we did, since we didn't get the lock
      Test := InterlockedExchangeAdd(FSentinel, mrWriteRequest);
      // If the old value (in Test) was 0, then we may be able to
      // get the lock (because it will now be mrWriteRequest). So,
      // we continue the loop to find out. Otherwise, we go to sleep,
      // waiting for a reader or writer to signal us.

      if Test <> 0 then
      begin
        {$IFDEF DEBUG_MREWS}
        Debug('Write starting to wait');
        {$ENDIF}
        WaitForWriteSignal;
      end
      {$IFDEF DEBUG_MREWS}
      else
        Debug('Write continue')
      {$ENDIF}
    end;

    // At the EndWrite, first Writers are awoken, and then Readers are awoken.
    // If a Writer got the lock, we don't want the readers to do busy
    // waiting. This Block resets the event in case the situation happened.
    BlockReaders;

    // Put our read lock marker back before we lose track of it
    if HasReadLock then
      InterlockedDecrement(FSentinel);

    FWriterID := ThreadID;

    Result := Integer(OldRevisionLevel) = (InterlockedIncrement(Integer(FRevisionLevel)) - 1);
  end;

  Inc(FWriteRecursionCount);
{$IFDEF DEBUG_MREWS}
  Debug('Write lock-----------------------------------');
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TADMREWSynchronizer.EndWrite;
var
  Thread: PADThreadInfo;
begin
{$IFDEF DEBUG_MREWS}
  Debug('Write end');
{$ENDIF}
  assert(FWriterID = GetCurrentThreadID);
  Thread := nil;
  tls.Open(Thread);
  Dec(FWriteRecursionCount);
  if FWriteRecursionCount = 0 then
  begin
    FWriterID := 0;
    InterlockedExchangeAdd(FSentinel, mrWriteRequest);
    {$IFDEF DEBUG_MREWS}
    Debug('Write about to UnblockOneWriter');
    {$ENDIF}
    UnblockOneWriter;
    {$IFDEF DEBUG_MREWS}
    Debug('Write about to UnblockReaders');
    {$ENDIF}
    UnblockReaders;
  end;
  if Thread.RecursionCount = 0 then
    tls.Delete(Thread);
{$IFDEF DEBUG_MREWS}
  Debug('Write unlock');
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TADMREWSynchronizer.BeginRead;
var
  Thread: PADThreadInfo;
  WasRecursive: Boolean;
  SentValue: Integer;
begin
{$IFDEF DEBUG_MREWS}
  Debug('Read enter');
{$ENDIF}

  Thread := nil;
  tls.Open(Thread);
  Inc(Thread.RecursionCount);
  WasRecursive := Thread.RecursionCount > 1;

  if FWriterID <> GetCurrentThreadID then
  begin
{$IFDEF DEBUG_MREWS}
    Debug('Trying to get the ReadLock (we did not have a write lock)');
{$ENDIF}
    // In order to prevent recursive Reads from causing deadlock,
    // we need to always WaitForReadSignal if not recursive.
    // This prevents unnecessarily decrementing the FSentinel, and
    // then immediately incrementing it again.
    if not WasRecursive then
    begin
      // Make sure we don't starve writers. A writer will
      // always set the read signal when it is done, and it is initially on.
      WaitForReadSignal;
      while (InterlockedDecrement(FSentinel) <= 0) do
      begin
  {$IFDEF DEBUG_MREWS}
        Debug('Read loop');
  {$ENDIF}
        // Because the InterlockedDecrement happened, it is possible that
        // other threads "think" we have the read lock,
        // even though we really don't. If we are the last reader to do this,
        // then SentValue will become mrWriteRequest
        SentValue := InterlockedIncrement(FSentinel);
        // So, if we did inc it to mrWriteRequest at this point,
        // we need to signal the writer.
        if SentValue = mrWriteRequest then
          UnblockOneWriter;

        // This sleep below prevents starvation of writers
        Sleep(0);

  {$IFDEF DEBUG_MREWS}
        Debug('Read loop2 - waiting to be signaled');
  {$ENDIF}
        WaitForReadSignal;
  {$IFDEF DEBUG_MREWS}
        Debug('Read signaled');
  {$ENDIF}
      end;
    end;
  end;
{$IFDEF DEBUG_MREWS}
  Debug('Read lock');
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TADMREWSynchronizer.EndRead;
var
  Thread: PADThreadInfo;
  Test: Integer;
begin
{$IFDEF DEBUG_MREWS}
  Debug('Read end');
{$ENDIF}
  Thread := nil;
  tls.Open(Thread);
  Dec(Thread.RecursionCount);
  if (Thread.RecursionCount = 0) then
  begin
     tls.Delete(Thread);

    // original code below commented out
    if (FWriterID <> GetCurrentThreadID) then
    begin
      Test := InterlockedIncrement(FSentinel);
      // It is possible for Test to be mrWriteRequest
      // or, it can be = 0, if the write loops:
      // Test := InterlockedExchangeAdd(FSentinel, mrWriteRequest) + mrWriteRequest;
      // Did not get executed before this has called (the sleep debug makes it happen faster)
      {$IFDEF DEBUG_MREWS}
      Debug(Format('Read UnblockOneWriter may be called. Test=%d', [Test]));
      {$ENDIF}
      if Test = mrWriteRequest then
        UnblockOneWriter
      else if Test <= 0 then // We may have some writers waiting
      begin
        if (Test mod mrWriteRequest) = 0 then
          UnblockOneWriter; // No more readers left (only writers) so signal one of them
      end;
    end;
  end;
{$IFDEF DEBUG_MREWS}
  Debug('Read unlock');
{$ENDIF}
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
{ Routines                                                                      }
{-------------------------------------------------------------------------------}
{$IFNDEF CLR}
function ADStrLike(const AStr, AMask: String; ANoCase: Boolean = False;
  AManyCharsMask: Char = '%'; AOneCharMask: Char = '_'; AEscapeChar: Char = '\'): Boolean;

  function InternalScan(pStr, pMask: PChar): Boolean;
  begin
    Result := True;
    while ((pStr^ = pMask^) and (pMask^ <> AManyCharsMask) or
        (pMask^ = AOneCharMask) or (pMask^ = AEscapeChar)) and
       (pStr^ <> #0) and (pMask^ <> #0) do begin
      if pMask^ = AEscapeChar then begin
        Inc(pMask);
        if pStr^ <> pMask^ then
          Break;
      end;
      Inc(pMask);
      Inc(pStr);
    end;
    if pMask^ = AManyCharsMask then begin
      while (pMask^ = AManyCharsMask) or (pMask^ = AOneCharMask) do begin
        if pMask^ = AOneCharMask then
          if pStr^ = #0 then begin
            Result := False;
            Exit;
          end
          else
            Inc(pStr);
        Inc(pMask);
      end;
      if pMask^ <> #0 then begin
        while (pStr^ <> #0) and ((pMask^ <> pStr^) or not InternalScan(pStr, pMask)) do
          Inc(pStr);
        Result := pStr^ <> #0;
      end;
    end
    else
      Result := (pMask^ = #0) and (pStr^ = #0);
  end;

begin
  if AMask = AManyCharsMask then
    Result := True
  else if (AMask = '') or (AStr = '') then
    Result := False
  else begin
    if ANoCase then
      Result := InternalScan(PChar(AnsiUpperCase(AStr)), PChar(AnsiUpperCase(AMask)))
    else
      Result := InternalScan(PChar(AStr), PChar(AMask));
  end;
end;

{$ELSE}
function ADStrLike(const AStr, AMask: String; ANoCase: Boolean = False;
  AManyCharsMask: Char = '%'; AOneCharMask: Char = '_'; AEscapeChar: Char = '\'): Boolean;

var
  sStr, sMask: String;

  function InternalScan(pStr, pMask: Integer): Boolean;
  begin
    Result := True;
    while (pStr <= Length(sStr)) and (pMask <= Length(sMask)) and
        ((sStr[pStr] = sMask[pMask]) and (sMask[pMask] <> AManyCharsMask) or
         (sMask[pMask] = AOneCharMask) or (sMask[pMask] = AEscapeChar)) do begin
      if sMask[pMask] = AEscapeChar then begin
        Inc(pMask);
        if sStr[pStr] <> sMask[pMask] then
          Break;
      end;
      Inc(pMask);
      Inc(pStr);
    end;
    if sMask[pMask] = AManyCharsMask then begin
      while (sMask[pMask] = AManyCharsMask) or (sMask[pMask] = AOneCharMask) do begin
        if sMask[pMask] = AOneCharMask then
          if pStr = Length(sStr) then begin
            Result := False;
            Exit;
          end
          else
            Inc(pStr);
        Inc(pMask);
      end;
      if pMask <> Length(sMask) then begin
        while (pStr <> Length(sStr)) and
              ((sMask[pMask] <> sStr[pStr]) or not InternalScan(pStr, pMask)) do
          Inc(pStr);
        Result := pStr <> Length(sStr);
      end;
    end
    else
      Result := (pMask = Length(sMask)) and (pStr = Length(sStr));
  end;

begin
  if AMask = AManyCharsMask then
    Result := True
  else if (AMask = '') or (AStr = '') then
    Result := False
  else begin
    if ANoCase then begin
      sMask := UpperCase(AMask);
      sStr := UpperCase(AStr);
    end
    else begin
      sMask := AMask;
      sStr := AStr;
    end;
    Result := InternalScan(1, 1);
  end;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
function ADPosEx(const ASub, AStr: String; AFrom: Integer = 1): Integer;
{$IFNDEF CLR}
var
  P: PChar;
{$ENDIF}
begin
  if AFrom < 1 then
    AFrom := 1;
  if AFrom > Length(AStr) then
    Result := 0
  else begin
{$IFNDEF CLR}
    P := StrPos(PChar(AStr) + (AFrom - 1), PChar(ASub));
    if P = nil then
      Result := 0
    else
      Result := P - PChar(AStr) + 1;
{$ELSE}
    Result := AStr.IndexOf(ASub, AFrom - 1) + 1;
{$ENDIF}
  end;
end;

{-------------------------------------------------------------------------------}
{$IFNDEF CLR}
function ADStrRPos(Str1, Str2: PChar): PChar;
var
  p1, p2, pBSub, pESub, pBS, pES: PChar;
begin
  Result := nil;
  if (Str1 = nil) or (Str2 = nil) then
    Exit;
  pBSub := Str2;
  pESub := Str2 + StrLen(Str2) - 1;
  pBS := Str1 + StrLen(Str2) - 1;
  pES := Str1 + StrLen(Str1) - 1;
  while pES >= pBS do begin
    if pES^ = pESub^ then begin
      p1 := pES;
      p2 := pESub;
      while (p2 >= pBSub) and (p1^ = p2^) do begin
        Dec(p1);
        Dec(p2);
      end;
      if p2 < pBSub then begin
        Result := p1 + 1;
        Exit;
      end;
    end;
    Dec(pES);
  end;
end;
{$ELSE}
function ADStrRPos(Str1, Str2: String): Integer;
begin
  Result := Str1.LastIndexOf(Str2);
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
{$IFNDEF CLR}
function ADCharUpperCase(ACh: Char): Char;
begin
  {$IFNDEF AnyDAC_FPC}
  Result := Chr(Integer(CharUpper(PChar(Ord(ACh)))));
  {$ELSE}
  Result := UpperCase(ACh)[1];
  {$ENDIF}
end;
{$ELSE}
function ADCharUpperCase(ACh: Char): Char;
begin
  Result := System.Char.ToUpper(ACh);
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
{$IFNDEF CLR}
function ADCharLowerCase(ACh: Char): Char;
  {$IFDEF AnyDAC_FPC}
var
  s: String;
  {$ENDIF}
begin
  {$IFNDEF AnyDAC_FPC}
  Result := Chr(Integer(CharLower(PChar(Ord(ACh)))));
  {$ELSE}
  s := ACh;
  s := LowerCase(s);
  Result := s[1];
  {$ENDIF}
end;
{$ELSE}
function ADCharUpperCase(ACh: Char): Char;
begin
  Result := System.Char.ToLower(ACh);
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
function ADPadR(const AStr: String; ALength: Integer): String;
begin
  if Length(AStr) > ALength then
    Result := Copy(AStr, 1, ALength)
  else
    Result := AStr + StringOfChar(' ', ALength - Length(AStr));
end;

{-------------------------------------------------------------------------------}
function ADPadL(const AStr: String; ALength: Integer): String;
begin
  if Length(AStr) > ALength then
    Result := Copy(AStr, 1, ALength)
  else
    Result := StringOfChar(' ', ALength - Length(AStr)) + AStr;
end;

{-------------------------------------------------------------------------------}
{$IFNDEF CLR}
function ADWideStrLen(AStr: PWideChar): Integer;
begin
  Result := 0;
  while (PChar(AStr)^ <> #0) or ((PChar(AStr) + 1)^ <> #0) do begin
    Inc(Result);
    AStr := PWideChar(PChar(AStr) + 2);
  end;
end;
{$ELSE}
function ADWideStrLen(AStr: WideString): Integer;
begin
  Result := Length(AStr);
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
function ADValToStr(const AValue: Variant; AQuotes: Boolean): String;
begin
  case VarType(AValue) of
    varEmpty:    Result := '<unassigned>';
    varNull:     Result := '<null>';
    varByte:     Result := '$' + IntToHex(Cardinal(AValue), 2);
{$IFDEF AnyDAC_D6}
    varWord:     Result := '$' + IntToHex(AValue, 4);
    varLongWord: Result := '$' + IntToHex(AValue, 8);
{$ENDIF}    
{$IFNDEF CLR}
    varOleStr,
{$ENDIF}
    varString:   if AQuotes then Result := '"' + AValue + '"' else Result := AValue;
    else         try Result := AValue; except Result := '<unknown>'; end;
  end;
end;

{-------------------------------------------------------------------------------}
function ADIdentToStr(const AValue: Variant; var AQuotes: Boolean): String;
begin
  AQuotes := True;
  case VarType(AValue) of
    varString,
    varOleStr:
      begin
        Result := AValue;
        if Result[1] = '@' then begin
          AQuotes := False;
          Result := Copy(Result, 2, Length(Result));
        end;
      end
    else
      Result := ADValToStr(AValue, True);
  end;
end;

{-------------------------------------------------------------------------------}
function ADFixCRLF(const AStr: String): String;
var
  i: Integer;
begin
  // ??? must be used C_AD_EOL
  Result := AStr;
  i := 1;
  while i <= Length(Result) do
    if (Result[i] = #13) and ((i = Length(Result)) or (Result[i + 1] <> #10)) then begin
      Insert(#10, Result, i + 1);
      Inc(i, 2);
    end
    else if (Result[i] = #10) and ((i = 1) or (Result[i - 1] <> #13)) then begin
      Insert(#13, Result, i);
      Inc(i, 2);
    end
    else
      Inc(i);
end;

{-------------------------------------------------------------------------------}
function ADExtractFieldName(const AStr: String; var APos: Integer): String; overload;
begin
  Result := ADExtractFieldName(AStr, APos, GParseFmtSettings);
end;

{-------------------------------------------------------------------------------}
function ADExtractFieldName(const AStr: String; var APos: Integer; const AFmt: TADParseFmtSettings): String; overload;
var
  i, iInBrackets: Integer;
  lInQuotes: Boolean;
begin
  i := APos;
  lInQuotes := False;
  iInBrackets := 0;
  with AFmt do
    while (i <= Length(AStr)) do begin
      if AStr[i] = FQuote then
        lInQuotes := not lInQuotes
      else if AStr[i] = FQuote1 then
        Inc(iInBrackets)
      else if AStr[i] = FQuote2 then
        Dec(iInBrackets)
      else if AStr[i] = FDelimiter then
        if not lInQuotes and (iInBrackets = 0) then
          Break;
      Inc(i);
    end;
  Result := Trim(Copy(AStr, APos, i - APos));
  if (i <= Length(AStr)) and (AStr[i] = AFmt.FDelimiter) then
    Inc(i);
  APos := i;
end;

{-------------------------------------------------------------------------------}
function ADValueFromIndex(AStrs: TStrings; AIndex: Integer): String;
begin
{$IFDEF AnyDAC_FPC}
  Result := AStrs.ValueFromIndex[AIndex];
{$ELSE}
  {$IFDEF AnyDAC_D7}
  Result := AStrs.ValueFromIndex[AIndex];
  {$ELSE}
  if AIndex >= 0 then
    Result := Copy(AStrs[AIndex], Length(AStrs.Names[AIndex]) + 2, MaxInt)
  else
    Result := '';
  {$ENDIF}
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
function ADStrToken(const AString: String; AChars: TChars; var AFrom: Integer;
  ASqueeze: Boolean = False): String;
var
  pS, pFrom: PChar;
begin
  if AFrom <= Length(AString) then begin
    pS := PChar(AString) + AFrom - 1;
    pFrom := pS;
    while (pS^ <> #0) and not (pS^ in AChars) do
      Inc(pS);
    Inc(AFrom, pS - pFrom + 1);
    SetString(Result, pFrom, pS - pFrom);
    if ASqueeze then
      while (AFrom <= Length(AString)) and (AString[AFrom] in AChars) do
        Inc(AFrom);
  end
  else
    Result := '';
end;

{-------------------------------------------------------------------------------}
function ADAddOffset(APointer: Pointer; AOffset: Integer): Pointer;
begin
{$IFNDEF AnyDAC_FPC}
  Result := PChar(APointer) + AOffset;
{$ELSE}
  Result := Pointer(int64(APointer) + AOffset);
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
function ADIncPointer(var APointer: Pointer; AOffset: Integer): Pointer;
begin
  APointer := ADAddOffset(APointer, AOffset);
  Result := APointer;
end;

{-------------------------------------------------------------------------------}
function ADLastSystemErrorMsg: String;
{$IFDEF MSWINDOWS}
var
  buf: PChar;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER or FORMAT_MESSAGE_FROM_SYSTEM,
    nil, GetLastError(), (SUBLANG_DEFAULT shl 10) or LANG_NEUTRAL,
    PChar(@buf), 0, nil);
  Result := buf;
  LocalFree(HLOCAL(buf));
{$ENDIF}
{$IFDEF LINUX}
  Result := dlerror;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
function ADIsSQLTimeStampBlank(const ATimeStamp: TADSQLTimeStamp): Boolean;
begin
  Result := (ATimeStamp.Year = 0) and
            (ATimeStamp.Month = 0) and
            (ATimeStamp.Day = 0) and
            (ATimeStamp.Hour = 0) and
            (ATimeStamp.Minute = 0) and
            (ATimeStamp.Second = 0) and
            (ATimeStamp.Fractions = 0);
end;

{-------------------------------------------------------------------------------}
function ADDateTimeToSQLTimeStamp(const ADateTime: TDateTime): TADSQLTimeStamp;
{$IFDEF AnyDAC_D6}
begin
  Result := DateTimeToSQLTimeStamp(ADateTime);
end;
{$ELSE}
var
  FFractions, FYear: Word;
begin
  with Result do begin
    FYear := 0;
    DecodeDate(ADateTime, FYear, Month, Day);
    Year := FYear;
    FFractions := 0;
    DecodeTime(ADateTime, Hour, Minute, Second, FFractions);
    Fractions := FFractions;
  end;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
function ADSQLTimeStampToDateTime(const ADateTime: TADSQLTimeStamp): TDateTime;
begin
{$IFDEF AnyDAC_D6}
  Result := SQLTimeStampToDateTime(ADateTime);
{$ELSE}
  if ADIsSQLTimeStampBlank(ADateTime) then
    Result := 0
  else with ADateTime do begin
    Result := EncodeDate(Year, Month, Day);
    if Result >= 0 then
      Result := Result + EncodeTime(Hour, Minute, Second, Word(Fractions))
    else
      Result := Result - EncodeTime(Hour, Minute, Second, Word(Fractions));
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
function ADSQLTimeStamp2Time(const AValue: TADSQLTimeStamp): Longint;
begin
  with AValue do
    Result := LongInt(((Hour * 60 + Minute) * 60 + Second) * 1000 + Fractions);
end;

{-------------------------------------------------------------------------------}
function ADTime2SQLTimeStamp(const AValue: Longint): TADSQLTimeStamp;
begin
  Result := ADDateTimeToSQLTimeStamp(ADTime2DateTime(AValue));
end;

{-------------------------------------------------------------------------------}
function ADSQLTimeStamp2Date(const AValue: TADSQLTimeStamp): Longint;
begin
  Result := Longint(Trunc(ADSQLTimeStampToDateTime(AValue) - C_Date_1_1_1 + 1.0));
end;

{-------------------------------------------------------------------------------}
function ADDate2SQLTimeStamp(const AValue: Longint): TADSQLTimeStamp;
begin
  Result := ADDateTimeToSQLTimeStamp(ADDate2DateTime(AValue));
end;

{-------------------------------------------------------------------------------}
function ADTime2DateTime(const AValue: Longint): TDateTime;
begin
  Result := AValue / (24.0 * 60.0 * 60.0 * 1000.0);
end;

{-------------------------------------------------------------------------------}
function ADDateTime2Time(const AValue: TDateTime): Longint;
var
  d: Double;
begin
  d := AValue * (24.0 * 60.0 * 60.0 * 1000.0) + 0.1;
  Result := LongInt(Trunc(d));
end;

{-------------------------------------------------------------------------------}
function ADDate2DateTime(const AValue: Longint): TDateTime;
begin
  Result := AValue - 1 + C_Date_1_1_1;
end;

{-------------------------------------------------------------------------------}
function ADDateTime2Date(const AValue: TDateTime): Longint;
begin
  Result := LongInt(Trunc(AValue - C_Date_1_1_1 + 1));
end;

{-------------------------------------------------------------------------------}
function ADFixFMTBcdAdd(const V1, V2: Variant): Variant;
{$IFDEF VER140}
var
  C1, C2: Currency;
  B: TBcd;
{$ENDIF}
begin
{$IFNDEF AnyDAC_FPC}
  {$IFDEF VER140}
  if ((VarType(V1) = VarFMTBcd) or (VarType(V2) = VarFMTBcd)) and
     BCDToCurr(VarToBcd(V1), C1) and BCDToCurr(VarToBcd(V2), C2) and CurrToBCD(C1 + C2, B) then
    Result := VarFMTBcdCreate(B)
  else
  {$ENDIF}
  {$IFNDEF AnyDAC_D6}
  if (VarType(V1) = varInt64) and (VarType(V2) = varInt64) then begin
    TVarData(Result).VType := varInt64;
    Decimal(Result).Lo64 := Decimal(V1).Lo64 + Decimal(V2).Lo64;
  end
  else
  {$ENDIF}
{$ENDIF}
    Result := V1 + V2;
end;

{-------------------------------------------------------------------------------}
function ADFixFMTBcdSub(const V1, V2: Variant): Variant;
{$IFDEF VER140}
var
  C1, C2: Currency;
  B: TBcd;
{$ENDIF}
begin
{$IFNDEF AnyDAC_FPC}
  {$IFDEF VER140}
  if ((VarType(V1) = VarFMTBcd) or (VarType(V2) = VarFMTBcd)) and
     BCDToCurr(VarToBcd(V1), C1) and BCDToCurr(VarToBcd(V2), C2) and CurrToBCD(C1 - C2, B) then
    Result := VarFMTBcdCreate(B)
  else
  {$ENDIF}
  {$IFNDEF AnyDAC_D6}
  if (VarType(V1) = varInt64) and (VarType(V2) = varInt64) then begin
    TVarData(Result).VType := varInt64;
    Decimal(Result).Lo64 := Decimal(V1).Lo64 - Decimal(V2).Lo64;
  end
  else
  {$ENDIF}
{$ENDIF}
    Result := V1 - V2;
end;

{-------------------------------------------------------------------------------}
function ADFixFMTBcdDiv(const V1, V2: Variant): Variant;
var
  cPrevDecimalSeparator: {$IFNDEF CLR} Char {$ELSE} String {$ENDIF};
{$IFNDEF AnyDAC_D6Base}
  dVal: Extended;
{$ENDIF}
begin
{$IFNDEF AnyDAC_D6Base}
  if VarType(V1) = varInt64 then begin
    dVal := V2;
    Result := Decimal(V1).Lo64 / dVal;
  end
  else
{$ENDIF}
  begin
    cPrevDecimalSeparator := DecimalSeparator;
    DecimalSeparator := '.';
    try
      Result := V1 / V2;
    finally
      DecimalSeparator := cPrevDecimalSeparator;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function ADCompareUInt64(const Value1, Value2:
  {$IFNDEF CLR} Int64 {$ELSE} UInt64 {$ENDIF}): Integer;
begin
  if Value1 = Value2 then
    Result := 0
  else if (Value1 >= 0) and (Value2 >= 0) then
    if Value1 > Value2 then
      Result := 1
    else
      Result := -1
  else if (Value1 < 0) and (Value2 >= 0) then
    Result := 1
  else if (Value1 >= 0) and (Value2 < 0) then
    Result := -1
  else
    if Value2 > Value1 then
      Result := 1
    else
      Result := -1
end;

{-------------------------------------------------------------------------------}
{$IFDEF Win32}
function ADGetSystemPath: String;
begin
  SetLength(Result, MAX_PATH);
  SetLength(Result, GetWindowsDirectory(PChar(Result), MAX_PATH));
end;
{$ENDIF}
{$IFDEF CLR}
function ADGetSystemPath: String;
var
  oSB: StringBuilder;
begin
  oSB := StringBuilder.Create(MAX_PATH);
  oSB.Length := GetWindowsDirectory(oSB, MAX_PATH);
  Result := oSB.ToString();
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
function ADGetMyDocsPath: String;
{$IFDEF AnyDAC_FPC}
const
  CSIDL_PERSONAL = $0005;
{$ENDIF}
var
  pidlDoc: PItemIDList;
begin
  pidlDoc := nil;
  if not Succeeded(SHGetSpecialFolderLocation(0, CSIDL_PERSONAL, pidlDoc)) then begin
    Result := '';
    Exit;
  end;
  SetLength(Result, MAX_PATH);
  if not SHGetPathFromIDList(pidlDoc, PChar(Result)) then
    Result := ''
  else
    SetLength(Result, StrLen(PChar(Result)));
  CoTaskMemFree(pidlDoc);
end;

{-------------------------------------------------------------------------------}
function ADGetAppPath: String;
begin
  Result := ExtractFileDir(ParamStr(0));
end;

{-------------------------------------------------------------------------------}
function ADGetBestPath(const ASpecifiedFileName, AGlobalFileName, ADefFileName: String): String;
var
  sSpec, sGlob, sDef: String;
begin
  sSpec := ADExpandStr(ASpecifiedFileName);
  sGlob := ADExpandStr(AGlobalFileName);
  sDef := ADExpandStr(ADefFileName);
  if sSpec = '' then begin
    Result := ADGetAppPath + '\' + sDef;
    if not FileExists(Result) then
      Result := sGlob;
  end
  else begin
    if ExtractFilePath(sSpec) = '' then
      Result := ADGetAppPath + '\' + sSpec
    else
      Result := sSpec;
  end;
end;

{-------------------------------------------------------------------------------}
function ADVerStr2Int(const AVersion: String): Integer;
var
  iItemNo, iDot, iFirstNonDig: Integer;
  s, sItem: String;
begin
  Result := 0;
  s := AVersion;
  for iItemNo := 1 to 5 do begin
    if s = '' then
      Result := Result * 100
    else begin
      iDot := Pos('.', s);
      if iDot = 0 then
        iDot := Length(s) + 1;
      sItem := Trim(Copy(s, 1, iDot - 1));
      iFirstNonDig := 1;
      while (iFirstNonDig <= Length(sItem)) and (sItem[iFirstNonDig] in ['0' .. '9']) do
        Inc(iFirstNonDig);
      Result := Result * 100 + StrToIntDef(Copy(sItem, 1, iFirstNonDig - 1), 0);
      s := Copy(s, iDot + 1, Length(s));
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function ADReadRegValue(const AValue: String): String;
var
  oReg: TRegistry;
  lOK: Boolean;
begin
  oReg := TRegistry.Create(KEY_READ);
  try
    oReg.RootKey := HKEY_CURRENT_USER;
    if not oReg.OpenKeyReadOnly(S_AD_CfgKeyName) or not oReg.ValueExists(AValue) then begin
      oReg.RootKey := HKEY_LOCAL_MACHINE;
      lOK := oReg.OpenKeyReadOnly(S_AD_CfgKeyName);
    end
    else
      lOK := True;
    if lOK then
      Result := oReg.ReadString(AValue);
  finally
    oReg.Free;
  end;
end;

{-------------------------------------------------------------------------------}
function ADReadEnvValue(const AName: String): String;
{$IFNDEF AnyDAC_D6Base}
var
  iSz: Integer;
{$ENDIF}
begin
{$IFDEF AnyDAC_D6Base}
  Result := GetEnvironmentVariable(AName);
{$ELSE}
  iSz := GetEnvironmentVariable(PChar(AName), nil, 0);
  if iSz = 0 then
    Result := ''
  else begin
    SetLength(Result, iSz - 1);
    GetEnvironmentVariable(PChar(AName), PChar(Result), iSz);
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
var
  FExpandStrCache: TStringList = nil;

function ADExpandStr(const AStr: String): String;
var
  i1, i2, iRes, iMax, iVal: Integer;
  sName, sVal: String;
  lNext: Boolean;
  rSR: TSearchRec;
begin
  Result := AStr;
  i1 := 1;
  lNext := False;
  while True do begin
    i1 := ADPosEx('$(', Result, i1);
    if i1 = 0 then
      Break;
    i2 := ADPosEx(')', Result, i1 + 2);
    if i2 = 0 then
      Break;
    sName := UpperCase(Copy(Result, i1 + 2, i2 - i1 - 2));
    if FExpandStrCache.IndexOfName(sName) <> -1 then
      sVal := FExpandStrCache.Values[sName]
    else if sName = 'RAND' then
      sVal := IntToStr(Random($7FFFFFFF))
    else if sName = 'NEXT' then begin
      sVal := '*';
      lNext := True;
    end
    else begin
      sVal := ADReadEnvValue(sName);
      if sVal = '' then
        sVal := ADReadRegValue(sName);
      FExpandStrCache.Add(sName + '=' + sVal);
    end;
    Result := Copy(Result, 1, i1 - 1) + sVal + Copy(Result, i2 + 1, Length(Result));
  end;
  if lNext then begin
    i1 := Pos('*', Result);
    iMax := 0;
    iRes := FindFirst(Result, faAnyFile, rSR);
    while iRes = 0 do begin
      iVal := StrToIntDef(Copy(rSR.Name, i1, Length(rSR.Name) - Length(Result) + 1), 0);
      if iVal > iMax then
        iMax := iVal;
      iRes := FindNext(rSR);
    end;
    FindClose(rSR);
    Result := Copy(Result, 1, i1 - 1) + IntToStr(iMax + 1) + Copy(Result, i1 + 1, Length(Result));
  end;
end;

{-------------------------------------------------------------------------------}
function ADIsDesignTime: Boolean;
const
  SIDEFileName: String =
{$IFDEF AnyDAC_FPC}
  'lazarus.exe'
{$ELSE}
  {$IFDEF AnyDAC_BCB}
    'bcb.exe'
  {$ELSE}
    {$IFDEF AnyDAC_DELPHI}
      {$IFDEF AnyDAC_D8}
        'bds.exe'
      {$ELSE}
        'delphi32.exe'
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}
  ;
begin
  Result := (CompareText(ExtractFileName(ParamStr(0)), SIDEFileName) = 0);
end;

{-------------------------------------------------------------------------------}
{$IFNDEF CLR}
function ADIndexOf(AList: Pointer; ALen: Integer; AItem: Pointer): Integer;
type
  PPtr = ^Pointer;
  TPtrArray = array of Pointer;
var
  p, lastP: PPtr;
  prevLastP: Pointer;
  c: Integer;
begin
  if ALen = -1 then
    c := Length(TPtrArray(AList))
  else
    c := ALen;
  if c = 0 then
    Result := -1
  else begin
    p := PPtr(AList);
    lastP := PPtr(PChar(p) + c * SizeOf(Pointer));
    prevLastP := lastP^;
    lastP^ := AItem;
    while p^ <> AItem do
      Inc(p);
    lastP^ := prevLastP;
    if (p^ = AItem) then begin
      Result := (PChar(p) - PChar(AList)) div SizeOf(Pointer);
      if Result = c then
        Result := -1;
    end
    else
      Result := -1;
  end;
end;
{$ELSE}
function ADIndexOf(AList: array of TObject; ALen: Integer; AItem: TObject): Integer;
begin
  if ALen = -1 then
    ALen := Length(AList);
  Result := System.Array.IndexOf(AList, AItem, 0, ALen);
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
function ADGetCmdParam(const AParName: String; const ADefValue: String): String;
var
  i, j, l: Integer;
  s: String;
begin
  Result := ADefValue;
  for i := 1 to ParamCount do begin
    s := ParamStr(i);
    if (s[1] in ['-', '/']) then begin
      j := 2;
      while (j <= Length(s)) and not (s[j] in [':', '=', ' ']) do
        Inc(j);
      l := j - 2;
      if (l = Length(AParName)) and
{$IFDEF Win32}
         (AnsiStrLIComp(PChar(s) + 1, PChar(AParName), l) = 0) then begin
{$ENDIF}
{$IFDEF CLR}
         (System.String.Compare(s, 1, AParName, 0, l, True) = 0) then begin
{$ENDIF}
        Result := Copy(s, j + 1, Length(s));
        if Result = '' then
          Result := '1';
        Exit;
      end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
{$IFDEF Win32}
function ADLocale2Name(ALocale: LCID): String;
var
  buff: array[0..2] of Char;
  iRes: Integer;
  sLang, sCntr: String;
begin
  iRes := GetLocaleInfoA(ALocale, LOCALE_SABBREVLANGNAME, @buff[0], 3);
  if iRes <> 0 then
    SetString(sLang, buff, iRes);
  iRes := GetLocaleInfoA(ALocale, LOCALE_SABBREVCTRYNAME, @buff[0], 3);
  if iRes <> 0 then
    SetString(sCntr, buff, iRes);
  if (sLang <> '') and (sCntr <> '') then
    Result := sLang + '-' + sCntr;
end;
{$ENDIF}
{$IFDEF CLR}
function ADLocale2Name(ALocale: CultureInfo): String;
begin
  Result := ALocale.Name;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
function ADTimeout(AStartTicks, ATimeout: LongWord): Boolean;
var
  i: LongWord;
begin
  i := GetTickCount;
  if i < AStartTicks then
    Result := ($FFFFFFFF - AStartTicks + i) >= ATimeout
  else
    Result := (i - AStartTicks) >= ATimeout;
end;

{-------------------------------------------------------------------------------}
{$IFDEF Win32}
procedure ADStr2BCD(pIn: PChar; ASize: Integer; var ABcd: TADBcd; ADot: Char);
var
  lNeg, lDec: Boolean;
  DecimalPos: Integer;
  pTmp: PChar;
begin
  if ASize = -1 then
    ASize := StrLen(pIn);
  ADFillChar(ABcd.Fraction, SizeOf(ABcd.Fraction), #0);
  if (pIn^ = '0') and ((ASize = 1) or ((pIn + 1)^ = #0)) or
     (pIn^ = #0) then begin
    ABcd.Precision := 8;
    ABcd.SignSpecialPlaces := 2;
    Exit;
  end;

  DecimalPos := 0;
  lDec := False;
  while DecimalPos < ASize do begin
    if pIn[DecimalPos] = ADot then begin
      lDec := True;
      Break;
    end;
    Inc(DecimalPos);
  end;
  if DecimalPos = ASize then
    DecimalPos := 0;

  { Strip leading whitespace }
  while (pIn^ <= ' ') or (pIn^ = '0') do begin
    Inc(pIn);
    Dec(ASize);
    if DecimalPos > 0 then
      Dec(DecimalPos);
  end;

  { Strip trailing whitespace }
  pTmp := pIn + ASize - 1;
  while pTmp^ <= ' ' do begin
    pTmp^ := #0;
    Dec(pTmp);
  end;

  { Is the number negative? }
  if pIn^ = '-' then begin
    lNeg := True;
    if DecimalPos > 0 then
      Dec(DecimalPos);
    Inc(pIn);
    Dec(ASize);
  end
  else begin
    lNeg := False;
    if pIn^ = '+' then begin
      if DecimalPos > 0 then
        Dec(DecimalPos);
      Inc(pIn);
      Dec(ASize);
    end;
  end;

  { Clear structure }
  if pIn^ = '0' then begin
    Inc(pIn);  // '0.' scenario
    Dec(ASize);
    if DecimalPos > 0 then
      Dec(DecimalPos);
  end;

  if ASize > 66 then begin
    ABcd.Precision := 8;
    ABcd.SignSpecialPlaces := 2;
    Exit;
  end;

  asm
      // From bytes to nibbles, both left aligned
      PUSH    ESI
      PUSH    EDI
      PUSH    EBX
      MOV     ESI, pIn       // move pIn to ESI
      MOV     EDI, ABcd      // move pTo to EDI
      ADD     EDI, OFFSET TADBcd.Fraction
      MOV     ECX, ASize     // store count in ECX
      MOV     DL,0           // Flag: when to store
      CLD
@@1:  LODSB                  // moves [ESI] into al
      CMP     AL, ADot
      JE      @@4
      SUB     AL, '0'
      CMP     DL, 0
      JNE     @@2
      SHL     AL, 4
      MOV     AH, AL
      JMP     @@3
@@2:  OR      AL, AH         // takes AH and ors in AL
      STOSB                  // always moves AL into [EDI]
@@3:  NOT     dl             // flip all bits
@@4:  DEC     ECX            // LOOP @@1, decrements cx and checks if it's 0
      JNE     @@1
      CMP     DL, 0          // are any bytes left unstored?
      JE      @@5
      MOV     AL, AH         // if so, move to al
      STOSB                  // and store to [EDI]
@@5:  POP     EBX
      POP     EDI
      POP     ESI
  end;

  if lDec then begin
    ABcd.Precision := Byte(ASize - 1);
    if lNeg then
      ABcd.SignSpecialPlaces := Byte((1 shl 7) + Byte(ASize - DecimalPos - 1))
    else
      ABcd.SignSpecialPlaces := Byte((0 shl 7) + Byte(ASize - DecimalPos - 1));
  end
  else begin
    ABcd.Precision := Byte(ASize);
    if lNeg then
      ABcd.SignSpecialPlaces := (1 shl 7)
    else
      ABcd.SignSpecialPlaces := (0 shl 7);
  end;
end;
{$ENDIF}
{$IFDEF CLR}
procedure ADStr2BCD(pIn: String; ASize: Integer; var ABcd: TBcd; ADot: Char);
var
  prevDS: String;
begin
  if ASize = -1 then
    ASize := Length(pIn);
  prevDS := DecimalSeparator;
  DecimalSeparator := ADot;
  try
    ABcd := TBcd.Parse(Copy(pIn, 1, ASize));
  finally
    DecimalSeparator := prevDS;
  end;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
{$IFDEF Win32}
procedure ADBCD2Str(pOut: PChar; var ASize: Integer; const ABcd: TADBcd; ADot: Char);
var
  iLoop: Integer;
  iNumDigits: Integer;
  pStr: PChar;
  cVal: Byte;
  lWasDigit: WordBool;
begin
  pStr := pOut;

  // First, is the number negative?
  if (ABcd.SignSpecialPlaces and (1 shl 7)) <> 0 then begin
    pOut^ := '-';
    Inc(pOut);
  end;

  // Now, loop through the whole part of the bcd number
  // use lower 6 bits of iSignSpecialPlaces.
  iNumDigits := ABcd.Precision - (ABcd.SignSpecialPlaces and 63);
  lWasDigit := False;
  for iLoop := 0 to iNumDigits - 1 do begin
    if (iLoop mod 2) <> 0 then
      // lower 4 bits only
      cVal := Byte((ABcd.Fraction[(iLoop - 1 ) div 2] and 15) + Ord('0'))
    else
      // upper 4 bits only
      cVal := Byte((ABcd.Fraction[iLoop div 2] shr 4) + Ord('0'));

    // This little test is used to strip leading '0' chars.
    if (cVal <> Ord('0')) or lWasDigit then begin
      pOut^ := Chr(cVal);
      Inc(pOut);
      lWasDigit := True;
    end;
  end;

  // If no data is stored yet, add a leading '0'.
  if not lWasDigit then begin
    pOut^ := '0';
    Inc(pOut);
  end;
  pOut^ := ADot;
  Inc(pOut);

  for iLoop := iNumDigits to ABcd.Precision - 1 do begin
    if iLoop mod 2 <> 0 then
      // lower 4 bits only
      pOut^ := Chr((ABcd.Fraction[(iLoop - 1) div 2] and 15) + Ord('0'))
    else
      // upper 4 bits only
      pOut^ := Chr((ABcd.Fraction[iLoop div 2] shr 4) + Ord('0'));
    Inc(pOut);
  end;

  // Right trim '0' chars
  ASize := pOut - pStr;
  while (ASize > 0) and ((pOut - 1)^ = '0') do begin
    Dec(pOut);
    Dec(ASize);
  end;
  if (ASize > 0) and ((pOut - 1)^ = ADot) then begin
    Dec(pOut);
    Dec(ASize);
  end;
  pOut^ := #0;
end;
{$ENDIF}
{$IFDEF CLR}
procedure ADBCD2Str(var pOut: String; var ASize: Integer; const ABcd: TBcd; ADot: Char);
var
  prevDS: String;
begin
  prevDS := DecimalSeparator;
  DecimalSeparator := ADot;
  try
    pOut := ABcd.ToString(nil);
    ASize := Length(pOut);
  finally
    DecimalSeparator := prevDS;
  end;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_FPC}
function CurrToBCD(const Curr: Currency; var BCD: TADBcd; Precision: Integer = 32;
  Decimals: Integer = 4): Boolean;
var
  s: String;
begin
  try
    s := CurrToStr(Curr);
    ADStr2BCD(PChar(s), Length(s), BCD, DecimalSeparator);
    Result := True;
  except
    Result := False;
  end;
end;

{-------------------------------------------------------------------------------}
function BCDToCurr(const BCD: TADBcd; var Curr: Currency): Boolean;
var
  aBuff: array [0..79] of Char;
  iSize: Integer;
begin
  try
    ADBCD2Str(aBuff, iSize, BCD, DecimalSeparator);
    Curr := StrToCurr(aBuff);
    Result := True;
  except
    Result := False;
  end;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
{$IFDEF Win32}
procedure ADStr2Int(ASrcData: PChar; ASrcLen: Integer;
  ADestData: Pointer; ADestLen: Integer; ANoSign: Boolean);
var
  i64: Int64;
  i: Integer;
  ui64: Int64;
  lw: LongWord;
  lNeg: Boolean;
  pEnd: PChar;
begin
  pEnd := ASrcData + ASrcLen - 1;
  while (ASrcData^ <= ' ') and (ASrcData <= pEnd) do
    Inc(ASrcData);
  lNeg := False;
  if ASrcData^ = '-' then begin
    lNeg := True;
    Inc(ASrcData);
  end
  else if ASrcData^ = '+' then
    Inc(ASrcData);
  if ANoSign then begin
    if ADestLen = SizeOf(Int64) then begin
      ui64 := 0;
      while ASrcData <= pEnd do begin
        ui64 := ui64 * 10 + Ord(ASrcData^) - Ord('0');
        Inc(ASrcData);
      end;
      PInt64(ADestData)^ := ui64;
    end
    else begin
      lw := 0;
      while ASrcData <= pEnd do begin
        lw := lw * 10 + Ord(ASrcData^) - Ord('0');
        Inc(ASrcData);
      end;
      case ADestLen of
      SizeOf(Byte):     PByte(ADestData)^ := Byte(lw);
      SizeOf(Word):     PWord(ADestData)^ := Word(lw);
      SizeOf(LongWord): PLongWord(ADestData)^ := LongWord(lw);
      end;
    end;
  end
  else begin
    if ADestLen = SizeOf(Int64) then begin
      i64 := 0;
      while ASrcData <= pEnd do begin
        i64 := i64 * 10 + Ord(ASrcData^) - Ord('0');
        Inc(ASrcData);
      end;
      if lNeg then
        i64 := - i64;
      PInt64(ADestData)^ := i64;
    end
    else begin
      i := 0;
      while ASrcData <= pEnd do begin
        i := i * 10 + Ord(ASrcData^) - Ord('0');
        Inc(ASrcData);
      end;
      if lNeg then
        i := - i;
      case ADestLen of
      SizeOf(ShortInt): PShortInt(ADestData)^ := ShortInt(i);
      SizeOf(SmallInt): PSmallInt(ADestData)^ := SmallInt(i);
      SizeOf(Integer):  PInteger(ADestData)^ := i;
      end;
    end;
  end;
end;
{$ENDIF}
{$IFDEF CLR}
procedure ADStr2Int(ASrcData: String; ASrcLen: Integer;
  out ADestData: System.Object; ADestLen: Integer; ANoSign: Boolean);
var
  s: String;
  i: Int64;
  ui: UInt64;
begin
  s := Copy(ASrcData, 1, ASrcLen);
  if ANoSign then begin
    i := StrToInt64(s);
    case ADestLen of
    SizeOf(ShortInt): ADestData := System.Object(System.SByte(i));
    SizeOf(SmallInt): ADestData := System.Object(System.Int16(i));
    SizeOf(Integer):  ADestData := System.Object(System.Int32(i));
    SizeOf(Int64):    ADestData := System.Object(System.Int64(i));
    end;
  end
  else begin
    ui := StrToUInt64(s);
    case ADestLen of
    SizeOf(Byte):     ADestData := System.Object(System.Byte(i));
    SizeOf(Word):     ADestData := System.Object(System.UInt16(i));
    SizeOf(LongWord): ADestData := System.Object(System.UInt32(i));
    SizeOf(UInt64):   ADestData := System.Object(System.UInt64(i));
    end;
  end;
end;
{$ENDIF}

{------------------------------------------------------------------------------}
{ RTL                                                                          }
{------------------------------------------------------------------------------}
{$IFNDEF AnyDAC_FactCodeRTL}
  {$IFNDEF CLR}
procedure RTLMove(const Source; var Dest; Count : Integer);
begin
  Move(Source, Dest, Count);
end;

procedure RTLFillChar(var Dest; count: Integer; Value: Char);
begin
  FillChar(Dest, count, Value);
end;
  {$ENDIF}
function RTLCompareText(const S1, S2: string): Integer;
begin
  Result := CompareText(S1, S2);
end;
{$ENDIF}

{$IFDEF Win32}
{------------------------------------------------------------------------------}
function ADGetVersionInfo(const AFileName: string; var AProduct,
  AVersion, AVersionName, ACopyright, AInfo: string): Boolean;
type
  TTranslation = array[0 .. 1] of Word;
const
  CTrans: String = '\VarFileInfo\Translation';
  CProdName: String = '\StringFileInfo\%s\FileDescription';
  CFileVers: String = '\StringFileInfo\%s\FileVersion';
  CCopyright: String = '\StringFileInfo\%s\LegalCopyright';
  CComments: String = '\StringFileInfo\%s\Comments';
  CSlash: String = '\';
var
  iHndl, iSz, iLen: DWORD;
  pBuff: Pointer;
  pTranslation: ^TTranslation;
  sTranslation, sBeta: String;
  pStr: PChar;
  pFileInfo: ^TVSFixedFileInfo;
begin
  Result := False;
  AProduct := '';
  AVersion := '';
  AVersionName := '';
  ACopyright := '';
  AInfo := '';
  iHndl := 0;
  iLen := 0;
  pFileInfo := nil;
  pTranslation := nil;
  pStr := nil;
  iSz := GetFileVersionInfoSize(PChar(AFileName), iHndl);
  if iSz <= 0 then
    Exit;
  GetMem(pBuff, iSz);
  try
    if not GetFileVersionInfo(PChar(AFileName), iHndl, iSz, pBuff) then
      Exit;
    if VerQueryValue(pBuff, PChar(CSlash), Pointer(pFileInfo), iLen) then
      if (pFileInfo.dwFileFlags and VS_FF_PRERELEASE) <> 0 then
        sBeta := ' Beta';
    if VerQueryValue(pBuff, PChar(CTrans), Pointer(pTranslation), iLen) then
      sTranslation := IntToHex(pTranslation^[0], 4) + IntToHex(pTranslation^[1], 4)
    else
      sTranslation := '040904B0';
    if VerQueryValue(pBuff, PChar(Format(CProdName, [sTranslation])), Pointer(pStr), iLen) then
      AProduct := pStr;
    if VerQueryValue(pBuff, PChar(Format(CFileVers, [sTranslation])), Pointer(pStr), iLen) then begin
      AVersion := pStr;
      AVersionName := Format('%d.%d.%d (Build %d)%s', [pFileInfo^.dwFileVersionMS shr 16,
        pFileInfo^.dwFileVersionMS and $0000FFFF, pFileInfo^.dwFileVersionLS shr 16,
        pFileInfo^.dwFileVersionLS and $0000FFFF, sBeta]);
    end;
    if VerQueryValue(pBuff, PChar(Format(CCopyright, [sTranslation])), Pointer(pStr), iLen) then
      ACopyright := pStr;
    if VerQueryValue(pBuff, PChar(Format(CComments, [sTranslation])), Pointer(pStr), iLen) then
      AInfo := pStr;
    Result := True;
  finally
    FreeMem(pBuff, iSz);
  end;
end;
{$ENDIF}

{------------------------------------------------------------------------------}
{$IFDEF AnyDAC_D6}
function ADAcquireExceptionObject: Exception;
begin
  Result := AcquireExceptionObject;
end;
{$ELSE}
type
  PRaiseFrame = ^TRaiseFrame;
  TRaiseFrame = record
    NextRaise: PRaiseFrame;
    ExceptAddr: Pointer;
    ExceptObject: TObject;
    ExceptionRecord: PExceptionRecord;
  end;

function ADAcquireExceptionObject: Exception;
begin
  if (RaiseList <> nil) and (PRaiseFrame(RaiseList)^.ExceptObject is Exception) then begin
    Result := Exception(PRaiseFrame(RaiseList)^.ExceptObject);
    PRaiseFrame(RaiseList)^.ExceptObject := nil;
  end
  else
    Result := nil;
end;
{$ENDIF}

{------------------------------------------------------------------------------}
procedure ADHandleException;
begin
{$IFDEF AnyDAC_D6}
  if Assigned(Classes.ApplicationHandleException) then
    Classes.ApplicationHandleException(ExceptObject);
{$ELSE}
  if GetCurrentThreadId = MainThreadID then
    SysUtils.ShowException(ExceptObject, ExceptAddr);
{$ENDIF}
end;

{------------------------------------------------------------------------------}
initialization

  C_Date_1_1_1 := EncodeDate(1, 1, 1);
  FExpandStrCache := TStringList.Create;
  FExpandStrCache.Sorted := True;
  FExpandStrCache.Duplicates := dupError;
{$IFDEF AnyDAC_FactCodeRTL}
  ADCompareText := CompareTextShaAsm3_b;
  if CPU.InstructionSupport * [isMMX, isSSE, isSSE2] = [isMMX, isSSE, isSSE2] then begin
    ADMove := MoveJOH_SSE_5;
    ADFillChar := FillCharDKC_SSE2_10_a;
  end
  else begin
    ADMove := MoveJOH_IA32_5;
    ADFillChar := FillCharCJGPas5_b;
  end;
{$ELSE}
  {$IFNDEF CLR}
  ADMove := RTLMove;
  ADFillChar := RTLFillChar;
  {$ENDIF}
  ADCompareText := RTLCompareText;
{$ENDIF}
{$IFDEF CLR}
  MainThreadID := GetCurrentThreadID;
{$ENDIF}

  with GParseFmtSettings do begin
    FDelimiter := ';';
    FQuote := '"';
    FQuote1 := '{';
    FQuote2 := '}';
  end;
  with GSemicolonFmtSettings do begin
    FDelimiter := ';';
    FQuote := #0;
    FQuote1 := #0;
    FQuote2 := #0;
  end;
  with GSpaceFmtSettings do begin
    FDelimiter := ' ';
    FQuote := #0;
    FQuote1 := #0;
    FQuote2 := #0;
  end;

finalization
  FreeAndNil(FExpandStrCache);

end.
