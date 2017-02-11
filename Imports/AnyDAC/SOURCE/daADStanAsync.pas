{-------------------------------------------------------------------------------}
{ AnyDAC async execution implementation                                         }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit daADStanAsync;

interface

implementation

uses
  Windows, Messages, SysUtils, Classes,
  daADStanIntf, daADStanConst, daADStanError, daADStanFactory, daADStanUtil,
  daADGUIxIntf;

type
  TADAsyncThread = class;
  TADStanAsyncExecutor = class;

  TADAsyncThread = class(TThread)
  private
    FExecutor: TADStanAsyncExecutor;
  protected
    procedure Execute; override;
  public
    constructor Create(AExecutor: TADStanAsyncExecutor);
  end;

  TADStanAsyncExecutor = class(TADObject, IADStanAsyncExecutor)
  private
    FOperationIntf: IADStanAsyncOperation;
    FHandlerIntf: IADStanAsyncHandler;
    FAsyncDlg: IADGUIxAsyncExecuteDialog;
    FTimeout: LongWord;
    FState: TADStanAsyncState;
    FMode: TADStanAsyncMode;
    FThread: TADAsyncThread;
    FException: Exception;
    FRunThreadId: DWORD;
    procedure ExecuteAsyncInThread;
    procedure Cleanup;
  protected
    // IADStanAsyncExecutor
    function GetState: TADStanAsyncState;
    function GetMode: TADStanAsyncMode;
    function GetTimeout: LongWord;
    function GetOperation: IADStanAsyncOperation;
    function GetHandler: IADStanAsyncHandler;
    procedure Setup(const AOperation: IADStanAsyncOperation;
      const AMode: TADStanAsyncMode; const ATimeout: LongWord;
      const AHandler: IADStanAsyncHandler);
    procedure Run;
    procedure AbortJob;
  public
    destructor Destroy; override;
  end;

var
  ADStanActiveAsyncsWithUI: Integer;

{-------------------------------------------------------------------------------}
{ TADAsyncThread                                                                }
{-------------------------------------------------------------------------------}
constructor TADAsyncThread.Create(AExecutor: TADStanAsyncExecutor);
begin
  FExecutor := AExecutor;
  FExecutor._AddRef;
  FreeOnTerminate := True;
  inherited Create(False);
//  Sleep(0);
end;

{-------------------------------------------------------------------------------}
procedure TADAsyncThread.Execute;
begin
  try
    FExecutor.ExecuteAsyncInThread;
  finally
    FExecutor.FThread := nil;
    FExecutor._Release;
    PostThreadMessage(FExecutor.FRunThreadId, C_AD_WM_ASYNC_DONE, 0, 0);
    Sleep(0);
  end;
end;

{-------------------------------------------------------------------------------}
{ TADStanAsyncExecutor                                                          }
{-------------------------------------------------------------------------------}
destructor TADStanAsyncExecutor.Destroy;
begin
  FAsyncDlg := nil;
  FHandlerIntf := nil;
  if (FOperationIntf <> nil) and (FMode in [amNonBlocking, amCancelDialog]) then
    InterlockedDecrement(ADStanActiveAsyncsWithUI);
  FOperationIntf := nil;
  if FException <> nil then
    FreeAndNil(FException);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADStanAsyncExecutor.GetMode: TADStanAsyncMode;
begin
  Result := FMode;
end;

{-------------------------------------------------------------------------------}
function TADStanAsyncExecutor.GetState: TADStanAsyncState;
begin
  Result := FState;
end;

{-------------------------------------------------------------------------------}
function TADStanAsyncExecutor.GetTimeout: LongWord;
begin
  Result := FTimeout;
end;

{-------------------------------------------------------------------------------}
function TADStanAsyncExecutor.GetOperation: IADStanAsyncOperation;
begin
  Result := FOperationIntf;
end;

{-------------------------------------------------------------------------------}
function TADStanAsyncExecutor.GetHandler: IADStanAsyncHandler;
begin
  Result := FHandlerIntf;
end;

{-------------------------------------------------------------------------------}
procedure TADStanAsyncExecutor.ExecuteAsyncInThread;
begin
  try
    try
      FOperationIntf.Execute;
    except
      if FState in [asInactive, asExecuting] then
        FState := asFailed;
      FException := ADAcquireExceptionObject;
    end;
    if FState in [asInactive, asExecuting] then
      FState := asFinished;
  finally
    if (GetHandler <> nil) and (FMode = amAsync) then
      GetHandler.HandleFinished(nil, FState, FException);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADStanAsyncExecutor.Setup(const AOperation: IADStanAsyncOperation;
  const AMode: TADStanAsyncMode; const ATimeout: LongWord;
  const AHandler: IADStanAsyncHandler);
begin
  ASSERT(AOperation <> nil);
  FOperationIntf := AOperation;
  FHandlerIntf := AHandler;
  FTimeout := ATimeout;
  FMode := AMode;
  FState := asInactive;
  if FMode in [amNonBlocking, amCancelDialog] then
    if ADGUIxSilent() then
      FMode := amBlocking
    else if ADStanActiveAsyncsWithUI > 0 then
      ADException(Self, [S_AD_LStan], er_AD_StanCantNonblocking, [])
    else begin
      ADCreateInterface(IADGUIxAsyncExecuteDialog, FAsyncDlg);
      if FAsyncDlg = nil then
        FMode := amBlocking
      else
        InterlockedIncrement(ADStanActiveAsyncsWithUI);
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADStanAsyncExecutor.Cleanup;
var
  rMsg: TMsg;
begin
  if PeekMessage(rMsg, 0, 0, 0, PM_NOREMOVE) and
     (rMsg.message = C_AD_WM_ASYNC_DONE) then
    PeekMessage(rMsg, 0, 0, 0, PM_REMOVE);
end;

{-------------------------------------------------------------------------------}
procedure TADStanAsyncExecutor.Run;
var
  H: THandle;
  dwRes, dwWakeMask: LongWord;
  rMsg: TMsg;
  oWait: IADGUIxWaitCursor;
  lDone: Boolean;
  oEx: Exception;
begin
  ASSERT(FState = asInactive);
  FRunThreadId := GetCurrentThreadId;
  if FMode <> amAsync then begin
    ADCreateInterface(IADGUIxWaitCursor, oWait);
    oWait.StartWait;
  end;
  try
    if (FMode = amBlocking) and (FTimeout = $FFFFFFFF) then begin
      try
        FOperationIntf.Execute;
        FState := asFinished;
      except
        FState := asFailed;
        raise;
      end;
    end
    else begin
      FThread := TADAsyncThread.Create(Self);
      H := FThread.Handle;
      if FMode = amAsync then
        Exit;
      if FThread <> nil then
        try
          if FMode <> amBlocking then begin
            if FMode = amCancelDialog then
              FAsyncDlg.Execute(True, Self);
            dwWakeMask := QS_ALLINPUT;
          end
          else
            dwWakeMask := QS_POSTMESSAGE;
          try
            lDone := False;
            while not lDone and (FThread <> nil) do begin
              dwRes := MsgWaitForMultipleObjects(1, H, False, FTimeout, dwWakeMask);
              case dwRes of
              WAIT_FAILED, // most probably - already terminated
              WAIT_OBJECT_0:
                lDone := True;
              WAIT_OBJECT_0 + 1:
                while not lDone and PeekMessage(rMsg, 0, 0, 0, PM_REMOVE) do begin
                  if rMsg.message = C_AD_WM_ASYNC_DONE then
                    lDone := True
                  else if rMsg.Message = WM_QUIT then begin
                    AbortJob;
                    Halt(rMsg.WParam);
                  end;
                  if (FMode = amNonBlocking) or not (
                      (rMsg.message >= WM_KEYDOWN) and (rMsg.message <= WM_DEADCHAR) and not FAsyncDlg.IsFormActive or
                      (rMsg.message >= WM_MOUSEFIRST) and (rMsg.message <= WM_MOUSELAST) and not FAsyncDlg.IsFormMouseMessage(rMsg) or
                      (rMsg.message >= WM_SYSKEYDOWN) and (rMsg.message <= WM_SYSDEADCHAR)
                     ) then begin
                    TranslateMessage(rMsg);
                    DispatchMessage(rMsg);
                  end;
                end;
              WAIT_TIMEOUT:
                begin
                  AbortJob;
                  FState := asExpired;
                  Break;
                end;
              end;
            end;
          finally
            if FMode <> amBlocking then
              if FMode = amCancelDialog then
                FAsyncDlg.Execute(False, nil);
          end;
          if (FException <> nil) and not (
              (FException is EADDBEngineException) and
              (EADDBEngineException(FException).Kind = ekCmdAborted) and
              (FState in [asAborted, asExpired])
             ) then begin
            FState := asFailed;
            oEx := FException;
            FException := nil;
            raise oEx;
          end
          else if FState = asExpired then
            ADException(Self, [S_AD_LStan], er_AD_StanTimeout, [])
          else if FState = asAborted then
            Abort;
        except
          if FState in [asInactive, asExecuting] then
            FState := asFailed;
          raise;
        end;
      if FState in [asInactive, asExecuting] then
        FState := asFinished;
    end;
  finally
    Cleanup;
    if FMode <> amAsync then begin
      oWait.StopWait;
      if GetHandler <> nil then
        GetHandler.HandleFinished(nil, FState, FException);
    end;
    FreeAndNil(FException);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADStanAsyncExecutor.AbortJob;
begin
  FState := asAborted;
  FThread.Terminate;
  FOperationIntf.AbortJob;
end;

{-------------------------------------------------------------------------------}
initialization
  ADStanActiveAsyncsWithUI := 0;
  TADMultyInstanceFactory.Create(TADStanAsyncExecutor, IADStanAsyncExecutor);

end.
