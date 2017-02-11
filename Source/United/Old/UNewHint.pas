unit UNewHint;

interface
{$I stbasis.inc}
uses Windows, Classes, Controls, Messages, Graphics, Forms;

type

  TNewHintWindow = class(TCustomControl)
  private
    FActivating: Boolean;
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
    procedure WMNCPaint(var Message: TMessage); message WM_NCPAINT;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure ActivateHint(Rect: TRect; const AHint: string); virtual;
    procedure ActivateHintData(Rect: TRect; const AHint: string; AData: Pointer); virtual;
    function CalcHintRect(MaxWidth: Integer; const AHint: string;
      AData: Pointer): TRect; virtual;
    function IsHintMsg(var Msg: TMsg): Boolean; virtual;
    procedure ReleaseHandle;
    property BiDiMode;
    property Caption;
    property Color;
    property Canvas;
    property Font;
  end;

  TNewHintWindowClass = class of TNewHintWindow;

implementation


{ THintWindow }

constructor TNewHintWindow.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Color := $80FFFF;
//  Canvas.Font := Screen.HintFont;
  Canvas.Brush.Style := bsClear;
end;

procedure TNewHintWindow.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := WS_POPUP or WS_BORDER;
    WindowClass.Style := WindowClass.Style or CS_SAVEBITS;
    if NewStyleControls then ExStyle := WS_EX_TOOLWINDOW;
    AddBiDiModeExStyle(ExStyle);
  end;
end;

procedure TNewHintWindow.WMNCHitTest(var Message: TWMNCHitTest);
begin
  Message.Result := HTTRANSPARENT;
end;

procedure TNewHintWindow.WMNCPaint(var Message: TMessage);
var
  DC: HDC;
  R: TRect;
begin
  DC := GetWindowDC(Handle);
  try
    R := Rect(0, 0, Width, Height);
    Canvas.Brush.Color:=clBlack;
    Canvas.Brush.Style:=bsSolid;
    FrameRect(DC,R,Canvas.Brush.Handle);
    //DrawEdge(DC, R, BDR_RAISEDOUTER, BF_RECT);
  finally
    ReleaseDC(Handle, DC);
  end;
end;

procedure TNewHintWindow.Paint;
var
  R: TRect;
begin
  R := ClientRect;
  Inc(R.Left, 1);
  Inc(R.Top, 1);
  Canvas.Brush.Style:=bsClear;
  Canvas.Font.Color := clInfoText;
  DrawText(Canvas.Handle, PChar(Caption), -1, R, DT_LEFT or DT_NOPREFIX or
    DT_WORDBREAK or DrawTextBiDiModeFlagsReadingOnly);
end;

function TNewHintWindow.IsHintMsg(var Msg: TMsg): Boolean;
begin
  with Msg do
    Result := ((Message >= WM_KEYFIRST) and (Message <= WM_KEYLAST)) or
      ((Message = CM_ACTIVATE) or (Message = CM_DEACTIVATE)) or
      (Message = CM_APPKEYDOWN) or (Message = CM_APPSYSCOMMAND) or
      (Message = WM_COMMAND) or ((Message > WM_MOUSEMOVE) and
      (Message <= WM_MOUSELAST)) or (Message = WM_NCMOUSEMOVE);
end;

procedure TNewHintWindow.ReleaseHandle;
begin
  DestroyHandle;
end;

procedure TNewHintWindow.CMTextChanged(var Message: TMessage);
begin
  inherited;
  if FActivating then Exit;
  Width := Canvas.TextWidth(Caption) + 6;
  Height := Canvas.TextHeight(Caption) + 4;
end;

procedure TNewHintWindow.ActivateHint(Rect: TRect; const AHint: string);
begin
  FActivating := True;
  try
    Caption := AHint;
    Inc(Rect.Bottom, 2);
    UpdateBoundsRect(Rect);
    if Rect.Top + Height > Screen.DesktopHeight then
      Rect.Top := Screen.DesktopHeight - Height;
    if Rect.Left + Width > Screen.DesktopWidth then
      Rect.Left := Screen.DesktopWidth - Width;
    if Rect.Left < Screen.DesktopLeft then Rect.Left := Screen.DesktopLeft;
    if Rect.Bottom < Screen.DesktopTop then Rect.Bottom := Screen.DesktopTop;
    SetWindowPos(Handle, HWND_TOPMOST, Rect.Left, Rect.Top, Width, Height,
      SWP_SHOWWINDOW or SWP_NOACTIVATE);
    Invalidate;
  finally
    FActivating := False;
  end;
end;

procedure TNewHintWindow.ActivateHintData(Rect: TRect; const AHint: string; AData: Pointer);
begin
  ActivateHint(Rect, AHint);
end;

function TNewHintWindow.CalcHintRect(MaxWidth: Integer; const AHint: string; AData: Pointer): TRect;
begin
  Result := Rect(0, 0, MaxWidth, 0);
  DrawText(Canvas.Handle, PChar(AHint), -1, Result, DT_CALCRECT or DT_LEFT or
    DT_WORDBREAK or DT_NOPREFIX or DrawTextBiDiModeFlagsReadingOnly);
  Inc(Result.Right, 6);
  Inc(Result.Bottom, 2);
end;

end.
