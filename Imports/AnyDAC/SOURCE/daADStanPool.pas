{-------------------------------------------------------------------------------}
{ AnyDAC pool standard implementation                                           }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit daADStanPool;

interface

implementation

uses
  Windows, SysUtils, Classes,
  daADStanIntf, daADStanConst, daADStanUtil, daADStanError, daADStanFactory;

type
  TADInterfaceList = class;
  TADResourcePool = class;
  TADPoolWorker = class;
  TADPoolAllocator = class;

  TADInterfaceList = class(TInterfaceList)
  private
    function GetFastCount: Integer;
  public
    property FastCount: Integer read GetFastCount;
  end;

  TADResourcePool = class(TADObject, IADStanObjectFactory)
  private
    FHost: IADStanObjectHost;
    FActive: Integer;
    FFreeList, FBusyList: TADInterfaceList;
    FActiveRequests, FCreatingItemsCount, FDestroingItemsCount: Integer;
    FWorker, FAllocator: TADThread;
    FMaximumItems, FOptimalItems, FPoolGrowDelta: Integer;
    FWorkerTimeout, FMaxWaitForItemTime, FGCLatencyPeriod: LongWord;
    FLastError: String;
    FStatSection: TRTLCriticalSection;
    FStatGets: Integer;
    FStatGetsNoWait: Integer;
    FStatGetsTime: TLargeInteger;
    FStatGetsTimeout: Integer;
    FStatWaitTime: TLargeInteger;
    FStatAllocates: Integer;
    FStatDeallocates: Integer;
    procedure InternalAcquireItem(out AObject: IADStanObject);
    procedure InternalReleaseItem(const AObject: IADStanObject);
    procedure CheckActive;
    procedure CheckInactive;
    function GetStillRunning: Boolean;
    function GetAllItemsCount: Integer;
    function GetBusyItemsCount: Integer;
    function GetFreeItemsCount: Integer;
    function GetStatGetsQueueLen: Integer;
    procedure RequestItemsCreation(AAmount: Integer);
    procedure RequestItemsDestroying(AAmount: Integer);
    function GetFutureItemsCount: Integer;
  protected
    procedure CreateItem(out AObject: IADStanObject);
    // IADStanObjectFactory
    procedure Open(const AHost: IADStanObjectHost; const ADef: IADStanDefinition);
    procedure Close;
    procedure Acquire(out AObject: IADStanObject);
    procedure Release(const AObject: IADStanObject);
  public
    procedure Initialize; override;
    destructor Destroy; override;
    procedure ResetStat;
    { runtime info properties }
    property AllItemsCount: Integer read GetAllItemsCount;
    property StillRunning: Boolean read GetStillRunning;
    property BusyItemsCount: Integer read GetBusyItemsCount;
    property FreeItemsCount: Integer read GetFreeItemsCount;
    property FutureItemsCount: Integer read GetFutureItemsCount;
    property CreatingItemsCount: Integer read FCreatingItemsCount;
    property DestroingItemsCount: Integer read FDestroingItemsCount;
    { stat info }
    property StatGets: Integer read FStatGets;
    property StatGetsNoWait: Integer read FStatGetsNoWait;
    property StatGetsQueueLen: Integer read GetStatGetsQueueLen;
    property StatGetsTime: TLargeInteger read FStatGetsTime;
    property StatGetsTimeout: Integer read FStatGetsTimeout;
    property StatWaitTime: TLargeInteger read FStatWaitTime;
    property StatAllocates: Integer read FStatAllocates;
    property StatDeallocates: Integer read FStatDeallocates;
    { management properties }
    property WorkerTimeout: LongWord read FWorkerTimeout write FWorkerTimeout;
    property MaxWaitForItemTime: LongWord read FMaxWaitForItemTime write FMaxWaitForItemTime;
    property GCLatencyPeriod: LongWord read FGCLatencyPeriod write FGCLatencyPeriod;
    property MaximumItems: Integer read FMaximumItems write FMaximumItems;
    property OptimalItems: Integer read FOptimalItems write FOptimalItems;
    property PoolGrowDelta: Integer read FPoolGrowDelta write FPoolGrowDelta;
  end;

  TADPoolRequestInfo = record
    FEvent: THandle;
    FItem: IADStanObject;
    FStartTime: TLargeInteger;
    FWaitTime: TLargeInteger;
  end;
  PADPoolRequestInfo = ^TADPoolRequestInfo;

  TADPoolThread = class(TADThread)
  private
    FPool: TADResourcePool;
  public
    constructor Create(APool: TADResourcePool);
    destructor Destroy; override;
  end;

  TADPoolWorker = class(TADPoolThread)
  private
    FRequestList: TThreadList;
    FGCCummBusyLen: TLargeInteger;
    FGCCummFreeLen: TLargeInteger;
    FGCLastCheckTime: LongWord;
    function ProcessRequest: Boolean;
    procedure ProcessPoolGet(ApInfo: PADPoolRequestInfo);
    procedure ProcessGetTimeout(ApInfo: PADPoolRequestInfo);
    procedure ProcessPoolPut(AObj: Pointer);
  protected
    procedure Execute; override;
    function DoAllowTerminate: Boolean; override;
    procedure DoIdle; override;
  public
    constructor Create(APool: TADResourcePool);
    destructor Destroy; override;
  end;

  TADPoolAllocator = class(TADPoolThread)
  private
    procedure ProcessFreeItem(AAmount: Integer);
    procedure ProcessNewItem(AAmount: Integer);
  protected
    procedure Execute; override;
    function DoAllowTerminate: Boolean; override;
  end;

{$IFNDEF AnyDAC_D6Base}
function InterlockedExchangeAdd(var Addend: Longint; Value: Longint): Longint stdcall;
  external 'kernel32.dll' name 'InterlockedExchangeAdd';
{$ENDIF}  

{-------------------------------------------------------------------------------}
{ TADInterfaceList                                                              }
{-------------------------------------------------------------------------------}
type
  __TInterfaceList = class(TInterfacedObject)
  private
    FList: TThreadList;
  end;

  __TThreadList = class(TObject)
  private
    FList: TList;
  end;

function TADInterfaceList.GetFastCount: Integer;
begin
  Result := __TThreadList(__TInterfaceList(Self).FList).FList.Count;
end;

{-------------------------------------------------------------------------------}
{ Pool messages                                                                 }
{-------------------------------------------------------------------------------}
type
  TADPoolWorkerMsgBase = class(TADThreadMsgBase)
  private
    FpInfo: PADPoolRequestInfo;
  public
    constructor Create(ApInfo: PADPoolRequestInfo); overload;
  end;

  TADPoolWorkerGetMsg = class(TADPoolWorkerMsgBase)
  protected
    function Perform(AThread: TADThread): Boolean; override;
  end;

  TADPoolWorkerGetTimeoutMsg = class(TADPoolWorkerMsgBase)
  protected
    function Perform(AThread: TADThread): Boolean; override;
  end;

  TADPoolWorkerPutMsg = class(TADThreadMsgBase)
  private
    FObj: Pointer;
  protected
    function Perform(AThread: TADThread): Boolean; override;
  public
    constructor Create(AObj: Pointer); overload;
  end;

  TADPoolAllocatorMsgBase = class(TADThreadMsgBase)
  private
    FAmount: Integer;
  public
    constructor Create(AAmount: Integer); overload;
  end;

  TADPoolAllocatorNewItemMsg = class(TADPoolAllocatorMsgBase)
  protected
    function Perform(AThread: TADThread): Boolean; override;
  end;

  TADPoolAllocatorFreeItemMsg = class(TADPoolAllocatorMsgBase)
  protected
    function Perform(AThread: TADThread): Boolean; override;
  end;

{-------------------------------------------------------------------------------}
constructor TADPoolWorkerMsgBase.Create(ApInfo: PADPoolRequestInfo);
begin
  inherited Create;
  FpInfo := ApInfo;
end;

{-------------------------------------------------------------------------------}
function TADPoolWorkerGetMsg.Perform(AThread: TADThread): Boolean;
begin
  (AThread as TADPoolWorker).ProcessPoolGet(FpInfo);
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPoolWorkerGetTimeoutMsg.Perform(AThread: TADThread): Boolean;
begin
  (AThread as TADPoolWorker).ProcessGetTimeout(FpInfo);
  Result := True;
end;

{-------------------------------------------------------------------------------}
constructor TADPoolWorkerPutMsg.Create(AObj: Pointer);
begin
  inherited Create;
  FObj := AObj;
end;

{-------------------------------------------------------------------------------}
function TADPoolWorkerPutMsg.Perform(AThread: TADThread): Boolean;
begin
  (AThread as TADPoolWorker).ProcessPoolPut(FObj);
  Result := True;
end;

{-------------------------------------------------------------------------------}
constructor TADPoolAllocatorMsgBase.Create(AAmount: Integer);
begin
  inherited Create;
  FAmount := AAmount;
end;

{-------------------------------------------------------------------------------}
function TADPoolAllocatorNewItemMsg.Perform(AThread: TADThread): Boolean;
begin
  (AThread as TADPoolAllocator).ProcessNewItem(FAmount);
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPoolAllocatorFreeItemMsg.Perform(AThread: TADThread): Boolean;
begin
  (AThread as TADPoolAllocator).ProcessFreeItem(FAmount);
  Result := True;
end;

{-------------------------------------------------------------------------------}
{ TADResourcePool                                                               }
{-------------------------------------------------------------------------------}
procedure TADResourcePool.Initialize;
begin
  inherited Initialize;
  FFreeList := TADInterfaceList.Create;
  FBusyList := TADInterfaceList.Create;
  InitializeCriticalSection(FStatSection);
  FMaxWaitForItemTime := C_AD_MaxWaitForItemTime;
  FGCLatencyPeriod := C_AD_GCLatencyPeriod;
  FWorkerTimeout := C_AD_WorkerTimeout;
  FMaximumItems := C_AD_MaximumItems;
  FOptimalItems := C_AD_OptimalItems;
  FPoolGrowDelta := C_AD_PoolGrowDelta;
end;

{-------------------------------------------------------------------------------}
destructor TADResourcePool.Destroy;
begin
  if StillRunning then
    Close;
  FreeAndNil(FFreeList);
  FreeAndNil(FBusyList);
  DeleteCriticalSection(FStatSection);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADResourcePool.CheckInactive;
begin
  if FActive > 0 then
    ADException(Self, [S_AD_LStan], er_AD_StanPoolMBInactive, []);
end;

{-------------------------------------------------------------------------------}
procedure TADResourcePool.CheckActive;
begin
  if FActive = 0 then
    ADException(Self, [S_AD_LStan], er_AD_StanPoolMBActive, []);
end;

{-------------------------------------------------------------------------------}
function TADResourcePool.GetAllItemsCount: Integer;
begin
  if (FFreeList = nil) or (FBusyList = nil) then
    Result := 0
  else
    Result := FFreeList.FastCount + FBusyList.FastCount;
end;

{-------------------------------------------------------------------------------}
function TADResourcePool.GetBusyItemsCount: Integer;
begin
  Result := FBusyList.FastCount;
end;

{-------------------------------------------------------------------------------}
function TADResourcePool.GetFreeItemsCount: Integer;
begin
  Result := FFreeList.FastCount;
end;

{-------------------------------------------------------------------------------}
procedure TADResourcePool.InternalAcquireItem(out AObject: IADStanObject);
begin
  if FFreeList.FastCount = 0 then begin
    if (CreatingItemsCount = 0) and (FutureItemsCount < MaximumItems) then
      RequestItemsCreation(1);
    AObject := nil;
  end
  else begin
    FFreeList.Lock;
    try
      AObject := IADStanObject(FFreeList.Items[FFreeList.Count - 1]);
      FFreeList.Delete(FFreeList.Count - 1);
      FBusyList.Add(AObject);
//      AObject.PreparePoolItem;
    finally
      FFreeList.Unlock;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADResourcePool.InternalReleaseItem(const AObject: IADStanObject);
var
  i: Integer;
begin
  if AObject <> nil then begin
    FFreeList.Lock;
    try
      i := FBusyList.IndexOf(AObject);
      if i <> -1 then begin
        ASSERT(FFreeList.IndexOf(AObject) = -1);
        FFreeList.Add(AObject);
        FBusyList.Delete(i);
      end
      else
        ASSERT(False);
    finally
      FFreeList.Unlock;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADResourcePool.GetStillRunning: Boolean;
begin
  Result := (FActive > 0) and (FWorker <> nil) and not TADPoolWorker(FWorker).Terminated;
end;

{-------------------------------------------------------------------------------}
procedure TADResourcePool.ResetStat;
begin
  FStatGets := 0;
  FStatGetsNoWait := 0;
  FStatGetsTime := 0;
  FStatGetsTimeout := 0;
  FStatWaitTime := 0;
  FStatAllocates := 0;
  FStatDeallocates := 0;
  FActiveRequests := 0;
  FCreatingItemsCount := 0;
  FDestroingItemsCount := 0;
end;

{-------------------------------------------------------------------------------}
procedure TADResourcePool.Open(const AHost: IADStanObjectHost; const ADef: IADStanDefinition);

  function Def(AValue, ADef: Integer): Integer;
  begin
    if AValue = 0 then
      Result := ADef
    else
      Result := AValue;
  end;

begin
  ASSERT(Assigned(AHost));
  CheckInactive;
  FHost := AHost;
  if ADef <> nil then begin
    FMaxWaitForItemTime := LongWord(Def(ADef.AsInteger[S_AD_PoolParam_MaxWaitForItemTime], Integer(C_AD_MaxWaitForItemTime)));
    FGCLatencyPeriod := LongWord(Def(ADef.AsInteger[S_AD_PoolParam_GCLatencyPeriod], C_AD_GCLatencyPeriod));
    FWorkerTimeout := LongWord(Def(ADef.AsInteger[S_AD_PoolParam_WorkerTimeout], C_AD_WorkerTimeout));
    FMaximumItems := Def(ADef.AsInteger[S_AD_PoolParam_MaximumItems], C_AD_MaximumItems);
    FOptimalItems := Def(ADef.AsInteger[S_AD_PoolParam_OptimalItems], C_AD_OptimalItems);
    FPoolGrowDelta := Def(ADef.AsInteger[S_AD_PoolParam_PoolGrowDelta], C_AD_PoolGrowDelta);
  end;
  ResetStat;
  InterlockedIncrement(FActive);
  TADPoolAllocator.Create(Self).Active := True;
  TADPoolWorker.Create(Self).Active := True;
end;

{-------------------------------------------------------------------------------}
procedure TADResourcePool.Close;
begin
  CheckActive;
  InterlockedDecrement(FActive);
  RequestItemsDestroying(MAXINT);
  while AllItemsCount > 0 do begin
    Sleep(1);
    RequestItemsDestroying(MAXINT);
  end;
  FWorker.Free;
  FAllocator.Free;
  FHost := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADResourcePool.CreateItem(out AObject: IADStanObject);
begin
  FHost.CreateObject(AObject);
end;

{-------------------------------------------------------------------------------}
procedure TADResourcePool.Acquire(out AObject: IADStanObject);
var
  R: TADPoolRequestInfo;
  C1, C2: TLargeInteger;
begin
  C1 := 0;
  QueryPerformanceCounter(C1);
  InterlockedIncrement(FStatGets);
  InterlockedIncrement(FActiveRequests);
  try
    CheckActive;
    AObject := nil;
    if StillRunning then begin
      R.FEvent := CreateEvent(nil, True, False, nil);
      try
        FWorker.EnqueueMsg(TADPoolWorkerGetMsg.Create(@R));
        if WaitForSingleObject(R.FEvent, MaxWaitForItemTime) = WAIT_OBJECT_0 then begin
          EnterCriticalSection(FStatSection);
          try
            FStatWaitTime := FStatWaitTime + R.FWaitTime;
          finally
            LeaveCriticalSection(FStatSection);
          end;
          try
            AObject := R.FItem;
            R.FItem := nil;
            AObject.BeforeReuse;
          except
            Release(AObject);
            AObject := nil;
            raise;
          end;
        end
        else begin
          InterlockedIncrement(FStatGetsTimeout);
          FWorker.EnqueueMsg(TADPoolWorkerGetTimeoutMsg.Create(@R));
          if FLastError = '' then
            FLastError := 'All objects are busy';
          ADException(Self, [S_AD_LStan], er_AD_StanPoolAcquireTimeout,
            [FHost.ObjectKindName, FLastError]);
        end;
      finally
        CloseHandle(R.FEvent);
      end;
    end;
  finally
    InterlockedDecrement(FActiveRequests);
    C2 := 0;
    QueryPerformanceCounter(C2);
    EnterCriticalSection(FStatSection);
    try
      FStatGetsTime := FStatGetsTime + (C2 - C1);
    finally
      LeaveCriticalSection(FStatSection);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADResourcePool.Release(const AObject: IADStanObject);
begin
  AObject.AfterReuse;
  if FWorker <> nil then begin
    AObject._AddRef;
    FWorker.EnqueueMsg(TADPoolWorkerPutMsg.Create(Pointer(AObject)));
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADResourcePool.RequestItemsCreation(AAmount: Integer);
begin
  if FAllocator <> nil then begin
    InterlockedExchangeAdd(FCreatingItemsCount, AAmount);
    FAllocator.EnqueueMsg(TADPoolAllocatorNewItemMsg.Create(AAmount));
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADResourcePool.RequestItemsDestroying(AAmount: Integer);
begin
  if FAllocator <> nil then begin
    InterlockedExchangeAdd(FDestroingItemsCount, AAmount);
    FAllocator.EnqueueMsg(TADPoolAllocatorFreeItemMsg.Create(AAmount));
  end;
end;

{-------------------------------------------------------------------------------}
function TADResourcePool.GetStatGetsQueueLen: Integer;
begin
  if FActive > 0 then
    with TADPoolWorker(FWorker).FRequestList do begin
      Result := LockList.Count;
      UnlockList;
    end
  else
    Result := 0;
end;

{-------------------------------------------------------------------------------}
function TADResourcePool.GetFutureItemsCount: Integer;
begin
  Result := AllItemsCount + FCreatingItemsCount - FDestroingItemsCount;
end;

{-------------------------------------------------------------------------------}
{ TADPoolThread                                                                 }
{-------------------------------------------------------------------------------}
constructor TADPoolThread.Create(APool: TADResourcePool);
begin
  inherited Create;
  FPool := APool;
  Timeout := APool.WorkerTimeout;
  FreeOnTerminate := False;
end;

{-------------------------------------------------------------------------------}
destructor TADPoolThread.Destroy;
begin
  inherited Destroy;
  FPool := nil;
end;

{-------------------------------------------------------------------------------}
{ TADPoolWorker                                                                 }
{-------------------------------------------------------------------------------}
constructor TADPoolWorker.Create(APool: TADResourcePool);
begin
  inherited Create(APool);
  FRequestList := TThreadList.Create;
end;

{-------------------------------------------------------------------------------}
destructor TADPoolWorker.Destroy;
begin
  FreeAndNil(FRequestList);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADPoolWorker.Execute;
begin
  FPool.FWorker := Self;
  FGCCummBusyLen := 0;
  FGCCummFreeLen := 0;
  FGCLastCheckTime := GetTickCount();
  FPool.RequestItemsCreation(FPool.OptimalItems);
  inherited Execute;
  FPool.FWorker := nil;
end;

{-------------------------------------------------------------------------------}
function TADPoolWorker.DoAllowTerminate: Boolean;
begin
  Result := (FPool = nil) or
    ((FPool.FActiveRequests = 0) and
      ((FPool.FBusyList = nil) or (FPool.FBusyList.Count = 0)));
end;

{-------------------------------------------------------------------------------}
procedure TADPoolWorker.ProcessPoolGet(ApInfo: PADPoolRequestInfo);
var
  oList: TList;
begin
  oList := FRequestList.LockList;
  try
    if (oList.Count = 0) and (FPool.FFreeList.FastCount > 0) then begin
      Inc(FPool.FStatGetsNoWait);
      ApInfo^.FStartTime := INFINITE;
    end
    else
      QueryPerformanceCounter(ApInfo^.FStartTime);
    oList.Add(ApInfo);
  finally
    FRequestList.UnlockList;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPoolWorker.ProcessGetTimeout(ApInfo: PADPoolRequestInfo);
begin
  FRequestList.Remove(ApInfo);
end;

{-------------------------------------------------------------------------------}
procedure TADPoolWorker.ProcessPoolPut(AObj: Pointer);
begin
  FPool.InternalReleaseItem(IADStanObject(AObj));
  IADStanObject(AObj)._Release;
end;

{-------------------------------------------------------------------------------}
function TADPoolWorker.ProcessRequest: Boolean;
var
  pReq: PADPoolRequestInfo;
  oObject: IADStanObject;
  C: TLargeInteger;
  oList: TList;
begin
  Result := False;
  oList := FRequestList.LockList;
  try
    if oList.Count > 0 then begin
      pReq := PADPoolRequestInfo(oList.Items[0]);
      FPool.InternalAcquireItem(oObject);
      if oObject <> nil then begin
        pReq.FItem := oObject;
        if pReq^.FStartTime <> INFINITE then begin
          C := 0;
          QueryPerformanceCounter(C);
          pReq^.FWaitTime := C - pReq^.FStartTime;
        end
        else
          pReq^.FWaitTime := 0;
        oList.Delete(0);
        SetEvent(pReq.FEvent);
        Result := True;
      end;
    end;
  finally
    FRequestList.UnlockList;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPoolWorker.DoIdle;
begin
  while ProcessRequest do;
  if ADTimeout(FGCLastCheckTime, FPool.FGCLatencyPeriod) then begin
    if (FGCCummBusyLen > FGCCummFreeLen * 2) and (FPool.FutureItemsCount < FPool.MaximumItems)  then
      FPool.RequestItemsCreation(FPool.PoolGrowDelta)
    else if (FGCCummFreeLen > FGCCummBusyLen * 2) and (FPool.FutureItemsCount > FPool.OptimalItems) then
      FPool.RequestItemsDestroying(FPool.PoolGrowDelta);
    FGCCummBusyLen := 0;
    FGCCummFreeLen := 0;
    FGCLastCheckTime := GetTickCount();
  end
  else begin
    FGCCummBusyLen := FGCCummBusyLen + FPool.FBusyList.FastCount;
    FGCCummFreeLen := FGCCummFreeLen + FPool.FFreeList.FastCount;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADPoolAllocator                                                              }
{-------------------------------------------------------------------------------}
procedure TADPoolAllocator.Execute;
begin
  FPool.FAllocator := Self;
  inherited Execute;
  FPool.FAllocator := nil;
end;

{-------------------------------------------------------------------------------}
function TADPoolAllocator.DoAllowTerminate: Boolean;
begin
  Result := (FPool = nil) or (FPool.AllItemsCount = 0);
end;

{-------------------------------------------------------------------------------}
procedure TADPoolAllocator.ProcessNewItem(AAmount: Integer);
var
  i: Integer;
  oObject: IADStanObject;
  oList: TADInterfaceList;
begin
  if FPool.FActive > 0 then begin
    i := 1;
    oList := FPool.FFreeList;
    while not Terminated and (i <= AAmount) and (FPool.AllItemsCount < FPool.MaximumItems) do begin
      oList.Lock;
      try
        try
          FPool.CreateItem(oObject);
          if oObject = nil then
            Break;
          oList.Add(oObject);
          oObject := nil;
          FPool.FLastError := '';
        except
          on E: Exception do begin
            InterlockedExchangeAdd(FPool.FCreatingItemsCount, -(AAmount - (i - 1)));
            if E is EADException then
              FPool.FLastError := E.Message;
            raise;
          end;
        end;
      finally
        oList.Unlock;
      end;
      InterlockedExchangeAdd(FPool.FCreatingItemsCount, -1);
      Inc(FPool.FStatAllocates);
      Inc(i);
    end;
    InterlockedExchangeAdd(FPool.FCreatingItemsCount, -(AAmount - (i - 1)));
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPoolAllocator.ProcessFreeItem(AAmount: Integer);
var
  i: Integer;
  oList: TADInterfaceList;
begin
  i := 1;
  oList := FPool.FFreeList;
  while not Terminated and (i <= AAmount) and (FPool.FFreeList.Count > 0) do begin
    oList.Lock;
    try
      try
        oList.Delete(oList.Count - 1);
      except
        InterlockedExchangeAdd(FPool.FDestroingItemsCount, -(AAmount - (i - 1)));
        raise;
      end;
    finally
      oList.Unlock;
    end;
    InterlockedExchangeAdd(FPool.FDestroingItemsCount, -1);
    Inc(FPool.FStatDeallocates);
    Inc(i);
  end;
  InterlockedExchangeAdd(FPool.FDestroingItemsCount, -(AAmount - (i - 1)));
end;

{-------------------------------------------------------------------------------}
initialization
  TADMultyInstanceFactory.Create(TADResourcePool, IADStanObjectFactory);

end.
