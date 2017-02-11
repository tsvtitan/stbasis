{-------------------------------------------------------------------------------}
{ AnyDAC tracer                                                                 }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit daADStanTracer;

interface

Uses
  SysUtils, Windows, Classes,
  daADStanError, daADStanUtil;

type
  TADTracerMsgBase = class;
  TADTracerStartMsg = class;
  TADTracerStopMsg = class;
  TADTracerTerminateMsg = class;
  TADTracerOutputMsg = class;
  TADTraceFileHandler = class;
  TADTracer = class;

  { --------------------------------------------------------------------------- }
  { TADTracerMsgBase                                                            }
  { --------------------------------------------------------------------------- }
  TADTracerMsgBase = class(TADThreadMsgBase)
  private
    FCounter: Int64;
    FDateTime: TDateTime;
    FThreadID: DWORD;
  public
    constructor Create; override;
    function Perform(AThread: TADThread): Boolean; override;
    function AsString: String; virtual;
  end;

  { --------------------------------------------------------------------------- }
  { TADTracerStartMsg                                                           }
  { --------------------------------------------------------------------------- }
  TADTracerStartMsg = class(TADTracerMsgBase)
  public
    function Perform(AThread: TADThread): Boolean; override;
    function AsString: String; override;
  end;

  { --------------------------------------------------------------------------- }
  { TADTracerStopMsg                                                            }
  { --------------------------------------------------------------------------- }
  TADTracerStopMsg = class(TADTracerMsgBase)
  public
    function Perform(AThread: TADThread): Boolean; override;
    function AsString: String; override;
  end;

  { --------------------------------------------------------------------------- }
  { TADTracerTerminateMsg                                                       }
  { --------------------------------------------------------------------------- }
  TADTracerTerminateMsg = class(TADTracerMsgBase)
  public
    function Perform(AThread: TADThread): Boolean; override;
    function AsString: String; override;
  end;

  { --------------------------------------------------------------------------- }
  { TADTracerOutputMsg                                                          }
  { --------------------------------------------------------------------------- }
  TADTracerOutputMsg = class(TADTracerMsgBase)
  private
    FObjClassName: String;
    FObjID: String;
    FMsgText: String;
  public
    constructor Create(const AObjectClassName, AObjID, AMsgText: String);
    function AsString: String; override;
  end;

  { --------------------------------------------------------------------------- }
  { TADTraceFileHandler                                                         }
  { --------------------------------------------------------------------------- }
  TADTraceFileHandler = class (TObject)
  private
    FStream: TFileStream;
  public
    constructor Create(const AFileName: String; AAppend: Boolean);
    destructor Destroy; override;
    procedure WriteLine(const ABuffer: String);
  end;

  { --------------------------------------------------------------------------- }
  { TADTracer                                                                   }
  { --------------------------------------------------------------------------- }
  TADTracer = class(TADThread)
  private
    FTraceFileName: String;
    FTraceFileHandler: TADTraceFileHandler;
    FTraceFileAppend: Boolean;
    procedure CheckInactive;
    procedure SetTraceFileName(AValue: String);
    procedure SetTraceFileAppend(AValue: Boolean);
    procedure OpenTraceFiles;
    procedure CloseTraceFiles;
  protected
    class function GetStartMsgClass: TADThreadMsgClass; override;
    class function GetStopMsgClass: TADThreadMsgClass; override;
    class function GetTerminateMsgClass: TADThreadMsgClass; override;
    function DoAllowTerminate: Boolean; override;
    procedure DoActiveChanged; override;
  public
    constructor Create;
    procedure TraceMsg(const AObjClassName, AObjName, AMsg: String);
    property TraceFileName: String read FTraceFileName write SetTraceFileName;
    property TraceFileAppend: Boolean read FTraceFileAppend write SetTraceFileAppend;
  end;

implementation

{$IFDEF CLR}
uses
  System.IO, System.Threading;
{$ENDIF}

resourceString
  sMb_TracerPropertyChangeOnlyActiveFalse = 'Tracer has to be Active=false to change the properties';
  sMb_TracerTraceFileHasToBeOpen = 'Trace file has to be open for this action';
  sMb_TracerTraceFileHasToBeClosed = 'Trace file has to be closed for this action';
  sMb_TracerTraceFileNameNotAssigned = 'Trace file name has to be assigned';

{ --------------------------------------------------------------------------- }
{ TADTracerMsgBase                                                            }
{ --------------------------------------------------------------------------- }
constructor TADTracerMsgBase.Create;
begin
  inherited Create;
  QueryPerformanceCounter(FCounter);
  FDateTime := Now();
  FThreadID := GetCurrentThreadID;
end;

{ --------------------------------------------------------------------------- }
function TADTracerMsgBase.AsString: String;
begin
  Result:= (Format('%10d %s %8d', [FCounter, DateTimeToStr(FDateTime), FThreadID]));
end;

{ --------------------------------------------------------------------------- }
function TADTracerMsgBase.Perform(AThread: TADThread): Boolean;
begin
  (AThread as TADTracer).FTraceFileHandler.WriteLine(AsString);
  Result := True;
end;

{ --------------------------------------------------------------------------- }
{ TADTracerStartMsg                                                           }
{ --------------------------------------------------------------------------- }
function TADTracerStartMsg.Perform(AThread: TADThread): Boolean;
begin
  (AThread as TADTracer).OpenTraceFiles;
  inherited Perform(AThread);
  with TADThreadStartMsg.Create do
  try
    Result := Perform(AThread);
  finally
    Free;
  end;
end;

{ --------------------------------------------------------------------------- }
function TADTracerStartMsg.AsString: String;
begin
  Result := inherited AsString + ' -=#!!! AnyDAC Tracer started !!!#=-';
end;

{ --------------------------------------------------------------------------- }
{ TADTracerStopMsg                                                            }
{ --------------------------------------------------------------------------- }
function TADTracerStopMsg.Perform(AThread: TADThread): Boolean;
begin
  inherited Perform(AThread);
  (AThread as TADTracer).CloseTraceFiles;
  with TADThreadStopMsg.Create do
  try
    Result := Perform(AThread);
  finally
    Free;
  end;
end;

{ --------------------------------------------------------------------------- }
function TADTracerStopMsg.AsString: String;
begin
  Result := inherited AsString + ' -=#!!! AnyDAC Tracer stopped !!!#=-';
end;

{ --------------------------------------------------------------------------- }
{ TADTracerTerminateMsg                                                       }
{ --------------------------------------------------------------------------- }
function TADTracerTerminateMsg.Perform(AThread: TADThread): Boolean;
begin
  inherited Perform(AThread);
  with TADThreadTerminateMsg.Create do
  try
    Result := Perform(AThread);
  finally
    Free;
  end;
end;

{ --------------------------------------------------------------------------- }
function TADTracerTerminateMsg.AsString: String;
begin
  Result := inherited AsString + ' -=#!!! AnyDAC Tracer terminated !!!#=-';
end;

{ --------------------------------------------------------------------------- }
{ TADTracerOutputMsg                                                          }
{ --------------------------------------------------------------------------- }
constructor TADTracerOutputMsg.Create(const AObjectClassName, AObjID, AMsgText: String);
begin
  inherited Create;
  FObjClassName := AObjectClassName;
  FObjID := AObjID;
  FMsgText := AMsgText;
end;

{ --------------------------------------------------------------------------- }
function TADTracerOutputMsg.AsString: String;
begin
  Result := Format('%s %-32s %-20s %s',
    [inherited AsString, FObjClassName, FObjID, FMsgText]);
end;

{ --------------------------------------------------------------------------- }
{ TADTraceFileHandler                                                         }
{ --------------------------------------------------------------------------- }
constructor TADTraceFileHandler.Create(const AFileName: String; AAppend: Boolean);
begin
  inherited Create;
  if not (FileExists(AFileName) and AAppend) then
    FileClose(FileCreate(AFileName));
  FStream := TFileStream.Create(AFileName, fmOpenWrite or fmShareDenyWrite);
  if AAppend then begin
    FStream.Position := FStream.Size;
    if FStream.Position > 0 then
      WriteLine('');
  end;
end;

{ --------------------------------------------------------------------------- }
destructor TADTraceFileHandler.Destroy;
begin
  FreeAndNil(FStream);
  inherited Destroy;
end;

{ --------------------------------------------------------------------------- }
procedure TADTraceFileHandler.WriteLine(const ABuffer: String);
const
  CCRLF: array[0 .. 1] of Byte = (Byte(#13), Byte(#10));
begin
{$IFDEF WIN32}
  if Length(ABuffer) > 0 then
    FStream.WriteBuffer(ABuffer[1], Length(ABuffer));
  FStream.WriteBuffer(CCRLF, SizeOf(CCRLF));
{$ENDIF}
{$IFDEF CLR}
  if Length(ABuffer) > 0 then
    FStream.WriteBuffer(BytesOf(ABuffer), Length(ABuffer));
  FStream.WriteBuffer(CCRLF, Length(CCRLF));
{$ENDIF}
end;

{ --------------------------------------------------------------------------- }
{ TADTracer                                                                   }
{ --------------------------------------------------------------------------- }
constructor TADTracer.Create;
begin
  inherited Create;
  FreeOnTerminate := False;
end;

{ --------------------------------------------------------------------------- }
class function TADTracer.GetStartMsgClass: TADThreadMsgClass;
begin
  Result := TADTracerStartMsg;
end;

{ --------------------------------------------------------------------------- }
class function TADTracer.GetStopMsgClass: TADThreadMsgClass;
begin
  Result := TADTracerStopMsg;
end;

{ --------------------------------------------------------------------------- }
class function TADTracer.GetTerminateMsgClass: TADThreadMsgClass;
begin
  Result := TADTracerTerminateMsg;
end;

{ --------------------------------------------------------------------------- }
function TADTracer.DoAllowTerminate: Boolean;
begin
  if Messages = nil then
    Result := True
  else
    with Messages do begin
      Result := LockList.Count = 0;
      UnlockList;
    end;
end;

{ --------------------------------------------------------------------------- }
procedure TADTracer.DoActiveChanged;
begin
  if not Active then
    while not DoAllowTerminate do
      Sleep(0);
end;

{ --------------------------------------------------------------------------- }
procedure TADTracer.CheckInactive;
begin
  if Active then
    EADException.Create(sMb_TracerPropertyChangeOnlyActiveFalse);
end;

{ --------------------------------------------------------------------------- }
procedure TADTracer.SetTraceFileName(AValue: String);
begin
  CheckInactive;
  FTraceFileName := ADExpandStr(AValue);
end;

{ --------------------------------------------------------------------------- }
procedure TADTracer.SetTraceFileAppend(AValue: Boolean);
begin
  CheckInactive;
  FTraceFileAppend := AValue;
end;

{ --------------------------------------------------------------------------- }
procedure TADTracer.OpenTraceFiles;
begin
  if FTraceFileHandler <> nil then
    EADException.Create(sMb_TracerTraceFileHasToBeClosed);
  if FTraceFileName = '' then
    EADException.Create(sMb_TracerTraceFileNameNotAssigned);
  FTraceFileHandler := TADTraceFileHandler.Create(FTraceFileName, FTraceFileAppend);
  FTraceFileHandler.WriteLine('--- new start of AnyDAC Trace ---');
end;

{ --------------------------------------------------------------------------- }
procedure TADTracer.CloseTraceFiles;
begin
  if FTraceFileHandler = nil then
    EADException.Create(sMb_TracerTraceFileHasToBeOpen);
  FreeAndNil(FTraceFileHandler);
end;

{ --------------------------------------------------------------------------- }
procedure TADTracer.TraceMsg(const AObjClassName, AObjName, AMsg: String);
begin
  if (Self <> nil) and Active then
    EnqueueMsg(TADTracerOutputMsg.Create(AObjClassName, AObjName, AMsg));
end;

end.
