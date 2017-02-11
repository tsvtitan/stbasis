{-------------------------------------------------------------------------------}
{ AnyDAC Moni base classes                                                      }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit daADMoniBase;

interface

uses
  Classes, daADStanIntf, daADStanFactory;

{$IFDEF AnyDAC_MONITOR}
type
  TADMoniClientBase = class;
  TADMoniClientLinkBase = class;

  TADMoniClientBase = class(TADObject, IADMoniClient)
  private
    FName: TComponentName;
    FStartingFailure: Boolean;
    FTracing: Boolean;
    FEventKinds: TADMoniEventKinds;
    FOutputHandler: IADMoniClientOutputHandler;
  protected
    // IADMoniClient
    function GetTracing: Boolean;
    procedure SetTracing(const AValue: Boolean);
    function GetName: TComponentName;
    procedure SetName(const AValue: TComponentName);
    function GetEventKinds: TADMoniEventKinds;
    procedure SetEventKinds(const AValue: TADMoniEventKinds);
    function GetOutputHandler: IADMoniClientOutputHandler;
    procedure SetOutputHandler(const AValue: IADMoniClientOutputHandler);
    procedure SetupFromDefinition(const AParams: IADStanDefinition); virtual;
    procedure ResetFailure;
    procedure Notify(AKind: TADMoniEventKind; AStep: TADMoniEventStep;
      ASender: TObject; const AMsg: String; const AArgs: array of const); virtual;
    function RegisterAdapter(const AAdapter: IADMoniAdapter): LongWord; virtual;
    procedure UnregisterAdapter(const AAdapter: IADMoniAdapter); virtual;
    procedure AdapterChanged(const AAdapter: IADMoniAdapter); virtual;
    // other
    function DoTracingChanged: Boolean; virtual;
    function OperationAllowed: Boolean; virtual;
  public
    procedure Initialize; override;
  end;

  TADMoniOutputEvent = procedure (ASender: TADMoniClientLinkBase;
    const AClassName, AObjName, AMessage: String) of object;
  TADMoniClientLinkBase = class(TComponent, IADMoniClientOutputHandler
{$IFNDEF AnyDAC_D6}
    , IUnknown
{$ENDIF}
    )
  private
    FClient: IADMoniClient;
    FOnOutput: TADMoniOutputEvent;
    FStreamedTracing: Boolean;
    function GetEventKinds: TADMoniEventKinds;
    procedure SetEventKinds(const AValue: TADMoniEventKinds);
    function GetTracing: Boolean;
    procedure SetTracing(const AValue: Boolean);
    procedure SetOnOutput(const AValue: TADMoniOutputEvent);
  protected
    procedure Loaded; override;
    // IADMoniClientOutputHandler
    procedure HandleOutput(const AClassName, AObjName, AMessage: String); virtual;
    // other
    function GetMoniClient: IADMoniClient; virtual; abstract;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Notify(AKind: TADMoniEventKind; AStep: TADMoniEventStep;
      ASender: TObject; const AMsg: String; const AArgs: array of const); virtual;
    property MoniClient: IADMoniClient read FClient;
  published
    property Tracing: Boolean read GetTracing write SetTracing default False;
    property EventKinds: TADMoniEventKinds read GetEventKinds write SetEventKinds
      default [ekLiveCycle .. ekVendor];
    property OnOutput: TADMoniOutputEvent read FOnOutput write SetOnOutput;
  end;
{$ENDIF}

implementation

{$IFDEF AnyDAC_MONITOR}
uses
  Windows;

{-------------------------------------------------------------------------------}
{ TADMoniClientBase                                                             }
{-------------------------------------------------------------------------------}
procedure TADMoniClientBase.Initialize;
begin
  inherited Initialize;
  FTracing := False;
  FEventKinds := [ekLiveCycle .. ekVendor];
  ResetFailure;
end;

{-------------------------------------------------------------------------------}
function TADMoniClientBase.GetName: TComponentName;
begin
  Result := FName;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniClientBase.SetName(const AValue: TComponentName);
begin
  FName := AValue;
end;

{-------------------------------------------------------------------------------}
function TADMoniClientBase.GetEventKinds: TADMoniEventKinds;
begin
  Result := FEventKinds;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniClientBase.SetEventKinds(const AValue: TADMoniEventKinds);
begin
  FEventKinds := AValue;
end;

{-------------------------------------------------------------------------------}
function TADMoniClientBase.GetOutputHandler: IADMoniClientOutputHandler;
begin
  Result := FOutputHandler;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniClientBase.SetOutputHandler(const AValue: IADMoniClientOutputHandler);
begin
  FOutputHandler := AValue;
end;

{-------------------------------------------------------------------------------}
function TADMoniClientBase.GetTracing: Boolean;
begin
  Result := FTracing;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniClientBase.SetTracing(const AValue: Boolean);
begin
  if (FTracing <> AValue) and not FStartingFailure and OperationAllowed then begin
    FTracing := AValue;
    try
      if not DoTracingChanged then
        if AValue then begin
          FTracing := False;
          FStartingFailure := True;
        end;
    except
      SetTracing(False);
      FStartingFailure := True;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniClientBase.SetupFromDefinition(const AParams: IADStanDefinition);
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADMoniClientBase.ResetFailure;
begin
  FStartingFailure := False;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniClientBase.Notify(AKind: TADMoniEventKind;
  AStep: TADMoniEventStep; ASender: TObject; const AMsg: String;
  const AArgs: array of const);
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
function TADMoniClientBase.RegisterAdapter(const AAdapter: IADMoniAdapter): LongWord;
begin
  // nothing
  Result := 0;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniClientBase.UnregisterAdapter(const AAdapter: IADMoniAdapter);
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADMoniClientBase.AdapterChanged(const AAdapter: IADMoniAdapter);
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
function TADMoniClientBase.OperationAllowed: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADMoniClientBase.DoTracingChanged: Boolean;
begin
  // nothing
  Result := True;
end;

{-------------------------------------------------------------------------------}
{ TADMoniClientLinkBase                                                         }
{-------------------------------------------------------------------------------}
constructor TADMoniClientLinkBase.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FClient := GetMoniClient;
end;

{-------------------------------------------------------------------------------}
destructor TADMoniClientLinkBase.Destroy;
begin
  FClient.OutputHandler := nil;
  FClient := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniClientLinkBase.Loaded;
begin
  inherited Loaded;
  MoniClient.Tracing := FStreamedTracing;
end;

{-------------------------------------------------------------------------------}
function TADMoniClientLinkBase.GetEventKinds: TADMoniEventKinds;
begin
  Result := MoniClient.EventKinds;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniClientLinkBase.SetEventKinds(const AValue: TADMoniEventKinds);
begin
  MoniClient.EventKinds := AValue;
end;

{-------------------------------------------------------------------------------}
function TADMoniClientLinkBase.GetTracing: Boolean;
begin
  Result := MoniClient.Tracing;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniClientLinkBase.SetTracing(const AValue: Boolean);
begin
  if csReading in ComponentState then
    FStreamedTracing := AValue
  else
    MoniClient.Tracing := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniClientLinkBase.SetOnOutput(const AValue: TADMoniOutputEvent);
begin
  if Assigned(AValue) then
    MoniClient.OutputHandler := Self as IADMoniClientOutputHandler
  else
    MoniClient.OutputHandler := nil;
  FOnOutput := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniClientLinkBase.HandleOutput(
  const AClassName, AObjName, AMessage: String);
begin
  if Assigned(FOnOutput) then
    FOnOutput(Self, AClassName, AObjName, AMessage);
end;

{-------------------------------------------------------------------------------}
procedure TADMoniClientLinkBase.Notify(AKind: TADMoniEventKind;
  AStep: TADMoniEventStep; ASender: TObject; const AMsg: String;
  const AArgs: array of const);
begin
  MoniClient.Notify(AKind, AStep, ASender, AMsg, AArgs);
end;
{$ENDIF}

end.
