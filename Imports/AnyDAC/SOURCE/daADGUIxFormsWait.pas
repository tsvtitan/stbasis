{-------------------------------------------------------------------------------}
{ AnyDAC wait time user interface                                               }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit daADGUIxFormsWait;

interface

uses
  Classes,
  daADStanIntf,
  daADGUIxIntf;

type
  { TADGUIxWaitCursor }
  TADGUIxWaitCursor = class(TADComponent, IADGUIxWaitCursor)
  private
    FWaitCursor: IADGUIxWaitCursor;
    FOnHide: TNotifyEvent;
    FOnShow: TNotifyEvent;
    function GetScreenCursor: TADGUIxScreenCursor;
    procedure SetScreenCursor(const AValue: TADGUIxScreenCursor);
    procedure DoOnHide(ASender: TObject);
    procedure DoOnShow(ASender: TObject);
  protected
    // IADGUIxWaitCursor
    function GetWaitCursor: TADGUIxScreenCursor;
    procedure SetWaitCursor(const AValue: TADGUIxScreenCursor);
    function GetOnShow: TNotifyEvent;
    procedure SetOnShow(const AValue: TNotifyEvent);
    function GetOnHide: TNotifyEvent;
    procedure SetOnHide(const AValue: TNotifyEvent);
    procedure StartWait;
    procedure StopWait;
    procedure PushWait;
    procedure PopWait;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property WaitCursor: IADGUIxWaitCursor read FWaitCursor;
  published
    property ScreenCursor: TADGUIxScreenCursor read GetScreenCursor write SetScreenCursor
      default gcrSQLWait;
    property OnShow: TNotifyEvent read FOnShow write FOnShow;
    property OnHide: TNotifyEvent read FOnHide write FOnHide;
  end;

implementation

uses
  Windows, Controls, Forms,
  daADStanConst, daADStanUtil, daADStanFactory;

{-------------------------------------------------------------------------------}
{ TADGUIxWaitCursor                                                             }
{-------------------------------------------------------------------------------}
constructor TADGUIxWaitCursor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ADCreateInterface(IADGUIxWaitCursor, FWaitCursor);
  (FWaitCursor as IADStanComponentReference).SetComponentReference(
    Self as IInterfaceComponentReference);
  FWaitCursor.OnShow := DoOnShow;
  FWaitCursor.OnHide := DoOnHide;
end;

{-------------------------------------------------------------------------------}
destructor TADGUIxWaitCursor.Destroy;
begin
  (FWaitCursor as IADStanComponentReference).SetComponentReference(nil);
  FWaitCursor.OnShow := nil;
  FWaitCursor.OnHide := nil;
  FWaitCursor := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxWaitCursor.DoOnHide(ASender: TObject);
begin
  if Assigned(FOnHide) then
    FOnHide(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxWaitCursor.DoOnShow(ASender: TObject);
begin
  if Assigned(FOnShow) then
    FOnShow(Self);
end;

{-------------------------------------------------------------------------------}
function TADGUIxWaitCursor.GetWaitCursor: TADGUIxScreenCursor;
begin
  Result := FWaitCursor.WaitCursor;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxWaitCursor.SetWaitCursor(const AValue: TADGUIxScreenCursor);
begin
  FWaitCursor.WaitCursor := AValue;
end;

{-------------------------------------------------------------------------------}
function TADGUIxWaitCursor.GetOnShow: TNotifyEvent;
begin
  Result := FWaitCursor.OnShow;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxWaitCursor.SetOnShow(const AValue: TNotifyEvent);
begin
  FWaitCursor.OnShow := AValue;
end;

{-------------------------------------------------------------------------------}
function TADGUIxWaitCursor.GetOnHide: TNotifyEvent;
begin
  Result := FWaitCursor.OnHide;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxWaitCursor.SetOnHide(const AValue: TNotifyEvent);
begin
  FWaitCursor.OnHide := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxWaitCursor.StartWait;
begin
  FWaitCursor.StartWait;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxWaitCursor.StopWait;
begin
  FWaitCursor.StopWait;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxWaitCursor.PushWait;
begin
  FWaitCursor.PushWait;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxWaitCursor.PopWait;
begin
  FWaitCursor.PopWait;
end;

{-------------------------------------------------------------------------------}
function TADGUIxWaitCursor.GetScreenCursor: TADGUIxScreenCursor;
begin
  Result := FWaitCursor.WaitCursor;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxWaitCursor.SetScreenCursor(const AValue: TADGUIxScreenCursor);
begin
  FWaitCursor.WaitCursor := AValue;
end;

{-------------------------------------------------------------------------------}
{- TADGUIxWaitCursorImpl                                                       -}
{-------------------------------------------------------------------------------}
type
  TADGUIxWaitCursorImpl = class(TADObject, IADGUIxWaitCursor)
  private
    FTimerID: Word;
    FStopRequestTime: LongWord;
    FWaitCursor: TADGUIxScreenCursor;
    FWasActive: Integer;
    FOnShow: TNotifyEvent;
    FOnHide: TNotifyEvent;
    procedure HideCursor;
    procedure ShowCursor;
    procedure TimerProc;
    procedure StopTimer;
    procedure StartTimer;
  protected
    // IADGUIxWaitCursor
    procedure StartWait;
    procedure StopWait;
    procedure PushWait;
    procedure PopWait;
    function GetWaitCursor: TADGUIxScreenCursor;
    procedure SetWaitCursor(const AValue: TADGUIxScreenCursor);
    function GetOnShow: TNotifyEvent;
    procedure SetOnShow(const AValue: TNotifyEvent);
    function GetOnHide: TNotifyEvent;
    procedure SetOnHide(const AValue: TNotifyEvent);
  public
    procedure Initialize; override;
    destructor Destroy; override;
  end;

var
  FWait: TADGUIxWaitCursorImpl;

{-------------------------------------------------------------------------------}
procedure TADGUIxWaitCursorImpl.Initialize;
begin
  inherited Initialize;
//  FWaitCursor := gcrSQLWait;
  FWaitCursor := gcrHourGlass;
  FWait := Self;
end;

{-------------------------------------------------------------------------------}
destructor TADGUIxWaitCursorImpl.Destroy;
begin
  HideCursor;
  StopTimer;
  inherited Destroy;
  FWait := nil;
end;

{-------------------------------------------------------------------------------}
function TADGUIxWaitCursorImpl.GetWaitCursor: TADGUIxScreenCursor;
begin
  Result := FWaitCursor;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxWaitCursorImpl.SetWaitCursor(const AValue: TADGUIxScreenCursor);
begin
  FWaitCursor := AValue;
end;

{-------------------------------------------------------------------------------}
function TADGUIxWaitCursorImpl.GetOnHide: TNotifyEvent;
begin
  Result := FOnHide;
end;

{-------------------------------------------------------------------------------}
function TADGUIxWaitCursorImpl.GetOnShow: TNotifyEvent;
begin
  Result := FOnShow;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxWaitCursorImpl.SetOnHide(const AValue: TNotifyEvent);
begin
  FOnHide := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxWaitCursorImpl.SetOnShow(const AValue: TNotifyEvent);
begin
  FOnShow := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxWaitCursorImpl.StopTimer;
begin
  if FTimerID <> 0 then begin
    KillTimer(0, FTimerID);
    FTimerID := 0;
  end;
  FStopRequestTime := 0;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxWaitCursorImpl.TimerProc;
begin
  if ADTimeout(FStopRequestTime, C_AD_HideCursorDelay) then begin
    HideCursor;
    StopTimer;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TimerCallBack(hWnd: HWND; Message, TimerID: LongWord; SysTime: LongWord); stdcall;
begin
  FWait.TimerProc;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxWaitCursorImpl.StartTimer;
begin
  if FTimerID = 0 then
    FTimerID := Word(SetTimer(0, 0, C_AD_HideCursorDelay, @TimerCallBack));
  FStopRequestTime := GetTickCount;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxWaitCursorImpl.ShowCursor;
var
  iCrs: TCursor;
begin
  case FWaitCursor of
    gcrDefault:   iCrs := crDefault;
    gcrHourGlass: iCrs := crHourGlass;
    gcrSQLWait:   iCrs := crSQLWait;
  else            Exit;
  end;
  if (Screen <> nil) and (Screen.Cursor <> iCrs) then begin
    if Assigned(FOnShow) then
      FOnShow(Self);
    Screen.Cursor := iCrs;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxWaitCursorImpl.HideCursor;
begin
  if Screen <> nil then begin
    Screen.Cursor := crDefault;
    if Assigned(FOnHide) then
      FOnHide(Self);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxWaitCursorImpl.StartWait;
begin
  if ADGUIxSilent() then
    Exit;
  StopTimer;
  ShowCursor;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxWaitCursorImpl.StopWait;
begin
  if ADGUIxSilent() then
    Exit;
  StartTimer;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxWaitCursorImpl.PopWait;
var
  iCrs: TCursor;
begin
  if ADGUIxSilent() then
    Exit;
  case FWaitCursor of
    gcrDefault:   iCrs := crDefault;
    gcrHourGlass: iCrs := crHourGlass;
    gcrSQLWait:   iCrs := crSQLWait;
  else            iCrs := crNone;
  end;
  if (Screen <> nil) and (Screen.Cursor = iCrs) then
    if FStopRequestTime > 0 then
      FWasActive := 2
    else
      FWasActive := 1
  else
    FWasActive := 0;
  HideCursor;
  StopTimer;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxWaitCursorImpl.PushWait;
begin
  if ADGUIxSilent() then
    Exit;
  case FWasActive of
  2: begin
      ShowCursor;
      StartTimer;
     end;
  1: ShowCursor;
  0: ;
  end;
end;

{-------------------------------------------------------------------------------}
initialization
  TADSingletonFactory.Create(TADGUIxWaitCursorImpl, IADGUIxWaitCursor);
  FADGUIxInteractive := True;

end.
