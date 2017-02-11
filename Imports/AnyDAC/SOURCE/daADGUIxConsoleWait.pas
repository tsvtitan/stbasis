{-------------------------------------------------------------------------------}
{ AnyDAC Wait Cursor interface console based implementation                     }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit daADGUIxConsoleWait;

interface

implementation

uses
  Classes,
  daADStanFactory,
  daADGUIxIntf;

{-------------------------------------------------------------------------------}
{- TADGUIxWaitCursorConsoleImpl                                                -}
{-------------------------------------------------------------------------------}
type
  TADGUIxWaitCursorConsoleImpl = class(TADObject, IADGUIxWaitCursor)
  private
    FWaitCursor: TADGUIxScreenCursor;
    FOnShow: TNotifyEvent;
    FOnHide: TNotifyEvent;
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
  end;

{-------------------------------------------------------------------------------}
function TADGUIxWaitCursorConsoleImpl.GetWaitCursor: TADGUIxScreenCursor;
begin
  Result := FWaitCursor;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxWaitCursorConsoleImpl.SetWaitCursor(const AValue: TADGUIxScreenCursor);
begin
  FWaitCursor := AValue;
end;

{-------------------------------------------------------------------------------}
function TADGUIxWaitCursorConsoleImpl.GetOnHide: TNotifyEvent;
begin
  Result := FOnHide;
end;

{-------------------------------------------------------------------------------}
function TADGUIxWaitCursorConsoleImpl.GetOnShow: TNotifyEvent;
begin
  Result := FOnShow;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxWaitCursorConsoleImpl.SetOnHide(const AValue: TNotifyEvent);
begin
  FOnHide := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxWaitCursorConsoleImpl.SetOnShow(const AValue: TNotifyEvent);
begin
  FOnShow := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxWaitCursorConsoleImpl.StartWait;
begin
  if ADGUIxSilent() then
    Exit;
  if Assigned(FOnShow) then
    FOnShow(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxWaitCursorConsoleImpl.StopWait;
begin
  if ADGUIxSilent() then
    Exit;
  if Assigned(FOnHide) then
    FOnHide(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxWaitCursorConsoleImpl.PopWait;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxWaitCursorConsoleImpl.PushWait;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
initialization
  TADSingletonFactory.Create(TADGUIxWaitCursorConsoleImpl, IADGUIxWaitCursor);
  FADGUIxInteractive := False;

end.
