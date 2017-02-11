{
Copyright © 1998 by Delphi 4 Developer's Guide - Xavier Pacheco and Steve Teixeira
}
unit Marquee;

interface

{$R 'tsv.res'}

uses
  SysUtils, Windows, Classes, Forms, Controls, Graphics,
  Messages, ExtCtrls, Dialogs;

const
  ScrollPix = 1;     // num of pixels for each scroll
  TmInterval = 1;   // time between scrolls in ms

type
  TJustification = (tjCenter, tjLeft, tjRight);

  EMarqueeError = class(Exception);

  TddgMarquee = class(TCustomPanel)
  private
    MemBitmap: TBitmap;
    InsideRect: TRect;
    FItems: TStringList;
    FJust: TJustification;
    FScrollDown: Boolean;
    LineHi : Integer;
    CurrLine : Integer;
    VRect: TRect;
    FTimer: TTimer;
    FActive: Boolean;
    FOnDone: TNotifyEvent;
    FCircle: Boolean;
    FTimerInterval: Integer;
    FScrollPxl: Integer;
    FTrans: Boolean;
    FptDown: TPoint;
    FMove: Boolean;
    FMovePixels: Integer;
    procedure SetItems(Value: TStringList);
    procedure DoTimerOnTimer(Sender: TObject);
    procedure MakeRects;
    procedure PaintLine(R: TRect; LineNum: Integer);
    procedure SetLineHeight;
    procedure SetStartLine;
    procedure IncLine;
    procedure SetActive(Value: Boolean);
    procedure SetTimerInterVal(Value: Integer);
  protected
    procedure Paint; override;
    procedure FillBitmap; virtual;
    procedure NewMouseMove(Sender: TObject; Shift: TShiftState; X,  Y: Integer);
    procedure NewMouseUp(Sender: TObject; Button: TMouseButton;
                      Shift: TShiftState; X, Y: Integer);
    procedure NewMouseDown(Sender: TObject; Button: TMouseButton;
                        Shift: TShiftState; X, Y: Integer);
    procedure WMMouseWheel(var Message: TWMMouseWheel);message WM_MOUSEWHEEL;
                        
  public
    property Active: Boolean read FActive write SetActive;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property ScrollDown: Boolean read FScrollDown write FScrollDown;
    property Justify: TJustification read FJust write FJust default tjCenter;
    property Circle: Boolean read FCircle write FCircle;
    property TimerInterval: Integer read FTimerInterVal write SetTimerInterVal;
    property ScrollPixel: Integer read FScrollPxl write FScrollPxl;
    property Items: TStringList read FItems write SetItems;
    property Transparent: Boolean read FTrans write FTrans;
    property MovePixels: Integer read FMovePixels write FMovePixels;
    property OnDone: TNotifyEvent read FOnDone write FOnDone;
    { Publish inherited properties: }
    property Align;
    property Alignment;
    property BevelInner;
    property BevelOuter;
    property BevelWidth;
    property BorderWidth;
    property BorderStyle;
    property Color;
    property Ctl3D;
    property Font;
    property Locked;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
  end;

implementation

const
  crImageMove=300;
  crImageDown=301;
  CursorMove='CRIMAGEMOVE';
  CursorDown='CRIMAGEDOWN';
  

constructor TddgMarquee.Create(AOwner: TComponent);
{ constructor for TddgMarquee class }

  procedure DoTimer;
  { procedure sets up TddgMarquee's timer }
  begin
    FTimer := TTimer.Create(Self);
    with FTimer do
    begin
      Enabled := False;
      Interval := FTimerInterval;
      OnTimer := DoTimerOnTimer;
    end;
  end;

begin
  inherited Create(AOwner);
//  ControlStyle:=ControlStyle+[csOpaque];
  Screen.Cursors[crImageMove] := LoadCursor(HINSTANCE,CursorMove);
  Screen.Cursors[crImageDown] := LoadCursor(HINSTANCE,CursorDown);
  Cursor:=crImageMove;

  FItems := TStringList.Create;  { instanciate string list }
  FTimerInterval:=TmInterval;
  DoTimer;                       { set up timer }
  { set instance variable default values }
  Width := 100;
  Height := 75;
  FActive := False;
  FScrollDown := False;
  FScrollPxl:=ScrollPix;
  FJust := tjCenter;
  FTrans:=False;
  FMovePixels:=1;
//  BevelWidth := 3;
  OnMouseDown:=NewMouseDown;
  OnMouseUp:=NewMouseUp;
  OnMouseMove:=NewMouseMove;
end;

destructor TddgMarquee.Destroy;
{ destructor for TddgMarquee class }
begin
  DestroyCursor(Screen.Cursors[crImageMove]);
  DestroyCursor(Screen.Cursors[crImageDown]);
  Screen.Cursors[crImageMove] := 0;
  Screen.Cursors[crImageDown] := 0;

  SetActive(False);
  FTimer.Free;             // free allocated objects
  FItems.Free;
  inherited Destroy;
end;

procedure TddgMarquee.DoTimerOnTimer(Sender: TObject);
{ This method is executed in respose to a timer event }
begin
  IncLine;
  { only repaint within borders }
  InvalidateRect(Handle, @InsideRect, False);
end;

procedure TddgMarquee.IncLine;
{ this method is called to increment a line }
begin
  if not FScrollDown then       // if Marquee is scrolling upward
  begin
    { Check to see if marquee has scrolled to end yet }
    if FItems.Count * LineHi + ClientRect.Bottom -
      FScrollPxl  >= CurrLine then
      { not at end, so increment current line }
      Inc(CurrLine, FScrollPxl)
    else begin
     if Not FCircle then
      SetActive(False)
     else FillBitmap;
    end;
  end
  else begin                   // if Marquee is scrolling downward
    { Check to see if marquee has scrolled to end yet }
    if CurrLine >= FScrollPxl then
      { not at end, so decrement current line }
      Dec(CurrLine, FScrollPxl)
    else begin
     if Not FCircle then
      SetActive(False)
     else FillBitmap;
    end;
  end;
end;

procedure TddgMarquee.SetItems(Value: TStringList);
begin
  if FItems <> Value then
    FItems.Assign(Value);
end;

procedure TddgMarquee.SetLineHeight;
{ this virtual method sets the LineHi instance variable }
var
  Metrics : TTextMetric;
begin
  { get metric info for font }
  GetTextMetrics(Canvas.Handle, Metrics);
  { adjust line height }
  LineHi := Metrics.tmHeight + Metrics.tmInternalLeading;
end;

procedure TddgMarquee.SetStartLine;
{ this virtual method initializes the CurrLine instance variable }
begin
  // initialize current line to top if scrolling up, or...
  if not FScrollDown then CurrLine := 0
  // bottom if scrolling down
  else CurrLine := VRect.Bottom - Height;
end;

procedure TddgMarquee.PaintLine(R: TRect; LineNum: Integer);
{ this method is called to paint each line of text onto MemBitmap }
const
  Flags: array[TJustification] of DWORD = (DT_CENTER, DT_LEFT, DT_RIGHT);
var
  S: string;
begin
  { Copy next line to local variable for clarity }
  S := FItems.Strings[LineNum];
  { Draw line of text onto memory bitmap }
  DrawText(MemBitmap.Canvas.Handle, PChar(S), Length(S), R,
    Flags[FJust] or DT_SINGLELINE or DT_TOP);
end;

procedure TddgMarquee.MakeRects;
{ procedure sets up VRect and InsideRect TRects }
begin
  { VRect rectangle represents entire memory bitmap }
  with VRect do
  begin
    Top := 0;
    Left := 0;
    Right := Width;
    Bottom := LineHi * FItems.Count + Height * 2;
  end;
  { InsideRect rectangle represents interior of beveled border }
  with InsideRect do
  begin
    Top := BevelWidth;
    Left := BevelWidth;
    Right := Width - (2 * BevelWidth);
    Bottom := Height - (2 * BevelWidth);
  end;
end;

procedure TddgMarquee.FillBitmap;
var
  y, i : Integer;
  Rect: TRect;
begin
  SetLineHeight;                 // set height of each line
  MakeRects;                     // make rectangles
  with Rect do
  begin
    Left := InsideRect.Left;
    Bottom := VRect.Bottom ;
    Right := InsideRect.Right;
  end;
  SetStartLine;
  MemBitmap.Width := Width;      // initialize memory bitmap
 if Ftrans then begin
   MemBitmap.TransparentColor:=Color;
   MemBitmap.Transparent:=true;
 end else begin
   MemBitmap.Transparent:=false;
 end;
  with MemBitmap do
  begin
    Height := VRect.Bottom;
    with Canvas do
    begin
      Font := Self.Font;
      Brush.Color := Color;
      FillRect(VRect);
      Brush.Style := bsClear;
    end;
  end;
  y := Height;
  i := 0;
  repeat
    Rect.Top := y;
    PaintLine(Rect, i);
    { increment y by the height (in pixels) of a line }
    inc(y, LineHi);
    inc(i);
  until i >= FItems.Count;      // repeat for all lines
end;

procedure TddgMarquee.SetActive(Value: Boolean);
{ called to activate/deactivate the marquee }
begin
  if Value and (not FActive) and (FItems.Count > 0) then
  begin
    FActive := True;                // set active flag
    MemBitmap := TBitmap.Create;
    FillBitmap;                     // Paint Image on bitmap
    FTimer.Enabled := True;         // start timer
  end
  else if (not Value) and FActive then
  begin
    FTimer.Enabled := False;   // disable timer,
    if Assigned(FOnDone)       // fire OnDone event,
      then FOnDone(Self);
    FActive := False;          // set FActive to False
    MemBitmap.Free;            // free memory bitmap
    Invalidate;                // clear control window
  end;
end;

procedure TddgMarquee.SetTimerInterVal(Value: Integer);
begin
  if Value<>FTimerInterval then begin
   FTimerInterval:=Value;
   FTimer.Interval:=FTimerInterval;
  end;
end;

procedure TddgMarquee.Paint;
begin
  if FActive then begin
   BitBlt(Canvas.Handle, 0, 0, InsideRect.Right, InsideRect.Bottom,
      MemBitmap.Canvas.Handle, 0,CurrLine, SRCCOPY);
  end else
   inherited Paint;
end;

procedure TddgMarquee.NewMouseMove(Sender: TObject; Shift: TShiftState; X,  Y: Integer);
begin
 if FMove then begin
  if Y>FptDown.y then begin
    dec(CurrLine,FMovePixels);
    FScrollDown:=true;
    DoTimerOnTimer(nil);
  end;
  if Y<FptDown.y then begin
    inc(CurrLine,FMovePixels);
    FScrollDown:=false;
    DoTimerOnTimer(nil);
  end;
  FptDown:=Point(X,Y);
 end;

end;

procedure TddgMarquee.NewMouseUp(Sender: TObject; Button: TMouseButton;
                      Shift: TShiftState; X, Y: Integer);
begin
  if FMove then begin
   Cursor:=crImageMove;
   FTimer.Enabled:=true;
   FMove:=false;
  end;
end;

procedure TddgMarquee.NewMouseDown(Sender: TObject; Button: TMouseButton;
                        Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbLeft then begin
    SetCursor(Screen.Cursors[crImageDown]);
    FTimer.Enabled:=false;
    FMove:=true;
    FptDown:=Point(X,Y);
  end;
end;

procedure TddgMarquee.WMMouseWheel(var Message: TWMMouseWheel);
begin
  with Message do begin
    if WheelDelta<0 then
     inc(CurrLine,FMovePixels)
    else dec(CurrLine,FMovePixels);
    FScrollDown:=false;
    DoTimerOnTimer(nil);
    Result:=1;
  end;
end;

end.
