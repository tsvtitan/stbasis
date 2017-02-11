{-------------------------------------------------------------------------------}
{ AnyDAC monitor flat file implementation                                       }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit daADMoniFlatFile;

interface

uses
  Classes,
  daADStanIntf, daADMoniBase, daADMoniCustom;

{$IFDEF AnyDAC_MONITOR}
type
  {-----------------------------------------------------------------------------}
  { TADMoniFlatFileClientLink                                                   }
  {-----------------------------------------------------------------------------}
  TADMoniFlatFileClientLink = class(TADMoniClientLinkBase)
  private
    FFFClient: IADMoniFlatFileClient;
    FFileNameChanged: Boolean;
    function GetFileName: String;
    procedure SetFileName(const AValue: String);
    function GetFileAppend: Boolean;
    procedure SetFileAppend(const AValue: Boolean);
    function IsFNS: Boolean;
  protected
    function GetMoniClient: IADMoniClient; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property FFClient: IADMoniFlatFileClient read FFFClient;
  published
    property FileName: String read GetFileName write SetFileName stored IsFNS;
    property FileAppend: Boolean read GetFileAppend write SetFileAppend default False;
  end;
{$ENDIF}

implementation

{$IFDEF AnyDAC_MONITOR}
uses
  SysUtils,
{$IFDEF AnyDAC_D6Base}
  Variants,
{$ELSE}
  ActiveX,
{$ENDIF}
  daADStanConst, daADStanUtil, daADStanFactory, daADStanTracer;

{-----------------------------------------------------------------------------}
{ TADMoniFlatFileClient                                                       }
{-----------------------------------------------------------------------------}
type
  TADMoniFlatFileClient = class(TADMoniCustomClient, IADMoniFlatFileClient)
  private
    FStarted: Boolean;
    FTracer: TADTracer;
  protected
    // IADMoniClient
    procedure SetupFromDefinition(const AParams: IADStanDefinition); override;
    // IADMoniFlatFileClient
    function GetFileName: String;
    procedure SetFileName(const AValue: String);
    function GetFileAppend: Boolean;
    procedure SetFileAppend(const AValue: Boolean);
    // other
    procedure DoTraceMsg(const AClassName, AObjName, AMessage: String); override;
    function DoTracingChanged: Boolean; override;
  public
    procedure Initialize; override;
    destructor Destroy; override;
    property Tracer: TADTracer read FTracer;
  end;

{-------------------------------------------------------------------------------}
procedure TADMoniFlatFileClient.Initialize;
begin
  inherited Initialize;
  FTracer := TADTracer.Create;
  FTracer.TraceFileName := C_AD_MonitorFileName;
  FTracer.TraceFileAppend := C_AD_MonitorAppend;
  FStarted := False;
end;

{-------------------------------------------------------------------------------}
destructor TADMoniFlatFileClient.Destroy;
begin
  inherited Destroy;
  FreeAndNil(FTracer);
end;

{-------------------------------------------------------------------------------}
procedure TADMoniFlatFileClient.SetupFromDefinition(const AParams: IADStanDefinition);
begin
  inherited SetupFromDefinition(AParams);
  if AParams.HasValue(S_AD_MoniFlatFileName) then
    FTracer.TraceFileName := AParams.AsString[S_AD_MoniFlatFileName];
  if AParams.HasValue(S_AD_MoniFlatFileAppend) then
    FTracer.TraceFileAppend := AParams.AsBoolean[S_AD_MoniFlatFileAppend];
end;

{-------------------------------------------------------------------------------}
function TADMoniFlatFileClient.DoTracingChanged: Boolean;
begin
  if GetTracing and not FStarted then begin
    FTracer.Resume;
    FStarted := True;
  end;
  FTracer.Active := GetTracing;
  Result := True;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniFlatFileClient.DoTraceMsg(const AClassName, AObjName,
  AMessage: String);
begin
  FTracer.TraceMsg(AClassName, AObjName, AMessage);
end;

{-------------------------------------------------------------------------------}
function TADMoniFlatFileClient.GetFileName: String;
begin
  Result := FTracer.TraceFileName;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniFlatFileClient.SetFileName(const AValue: String);
begin
  FTracer.TraceFileName := AValue;
end;

{-------------------------------------------------------------------------------}
function TADMoniFlatFileClient.GetFileAppend: Boolean;
begin
  Result := FTracer.TraceFileAppend;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniFlatFileClient.SetFileAppend(const AValue: Boolean);
begin
  FTracer.TraceFileAppend := AValue;
end;

{-------------------------------------------------------------------------------}
{ TADMoniFlatFileClientLink                                                     }
{-------------------------------------------------------------------------------}
constructor TADMoniFlatFileClientLink.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFFClient := MoniClient as IADMoniFlatFileClient;
  FileAppend := True;
end;

{-------------------------------------------------------------------------------}
destructor TADMoniFlatFileClientLink.Destroy;
begin
  FFFClient := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADMoniFlatFileClientLink.GetMoniClient: IADMoniClient;
var
  oFFClient: IADMoniFlatFileClient;
begin
  ADCreateInterface(IADMoniFlatFileClient, oFFClient);
  Result := oFFClient as IADMoniClient;
end;

{-------------------------------------------------------------------------------}
function TADMoniFlatFileClientLink.GetFileName: String;
begin
  Result := FFClient.FileName;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniFlatFileClientLink.SetFileName(const AValue: String);
begin
  if FFClient.FileName <> AValue then begin
    FFClient.FileName := AValue;
    FFileNameChanged := (AValue <> '');
  end;
end;

{-------------------------------------------------------------------------------}
function TADMoniFlatFileClientLink.IsFNS: Boolean;
begin
  Result := FFileNameChanged;
end;

{-------------------------------------------------------------------------------}
function TADMoniFlatFileClientLink.GetFileAppend: Boolean;
begin
  Result := FFClient.FileAppend;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniFlatFileClientLink.SetFileAppend(const AValue: Boolean);
begin
  FFClient.FileAppend := AValue;
end;

{-------------------------------------------------------------------------------}
initialization
  TADSingletonFactory.Create(TADMoniFlatFileClient, IADMoniFlatFileClient);
{$ENDIF}

end.
