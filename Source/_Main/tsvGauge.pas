unit TsvGauge;


interface

uses SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, StdCtrls,
     extctrls, buttons;

type

  TtsvGaugeKind = (gkText, gkHorizontalBar, gkVerticalBar, gkPie, gkNeedle);
  TFillDirection=(fdLR,fdRL,fdTB,fdBT);

//  TtsvGauge = class(TGraphicControl)
  TtsvGauge = class(TSpeedButton)
  private
    FTransparent: Boolean;
    FMinValue: Longint;
    FMaxValue: Longint;
    FCurValue: Single;
    FKind: TTsvGaugeKind;
    FShowPercent: Boolean;
    FBorderStyle: TBorderStyle;
    FStartColor: TColor;
    FEndColor: TColor;
    FBackColor: TColor;
    FText: string;
    FCenterText: Boolean;
    FColorCount: Word;
    procedure SetCenterText(Value: Boolean);
    procedure PaintBackground(AnImage: TBitmap);
    procedure PaintAsText(AnImage: TBitmap; PaintRect: TRect);
    procedure PaintAsNothing(AnImage: TBitmap; PaintRect: TRect);
    procedure PaintAsBar(AnImage: TBitmap; PaintRect: TRect);
    procedure PaintAsPie(AnImage: TBitmap; PaintRect: TRect);
    procedure PaintAsNeedle(AnImage: TBitmap; PaintRect: TRect);
    procedure SetTsvGaugeKind(Value: TtsvGaugeKind);
    procedure SetShowPercent(Value: Boolean);
    procedure SetBorderStyle(Value: TBorderStyle);
    procedure SetStartColor(Value: TColor);
    procedure SetEndColor(Value: TColor);
    procedure SetBackColor(Value: TColor);
    procedure SetMinValue(Value: Longint);
    procedure SetMaxValue(Value: Longint);
    procedure SetProgress(Value: Single);
    function GetPercentDone: Longint;
    procedure SetText(Value: String);
    procedure SetTransparent(Value: Boolean);
    procedure FillGradientRect(canvas: tcanvas; Recty: trect;
                  fbcolor, fecolor: tcolor; fcolors: Integer; fdirect: TFillDirection);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddProgress(Value: Single);
    property PercentDone: Longint read GetPercentDone;
  published
    property Align;
    property Color;
    property Enabled;
    property Kind: TTsvGaugeKind read FKind write SetTsvGaugeKind default gkHorizontalBar;
    property ShowPercent: Boolean read FShowPercent write SetShowPercent default True;
    property Font;
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle default bsSingle;
    property StartColor: TColor read FStartColor write SetStartColor default clBlack;
    property EndColor: TColor read FEndColor write SetEndColor default clWhite;
    property ColorCount: Word read FColorCount write FColorCount default 256;
    property BackColor: TColor read FBackColor write SetBackColor default clWhite;
    property MinValue: Longint read FMinValue write SetMinValue default 0;
    property MaxValue: Longint read FMaxValue write SetMaxValue default 100;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property Progress: Single read FCurValue write SetProgress;
    property ShowHint;
    property Visible;
    property Text: string read FText write SetText;
    property Transparent: Boolean read FTransparent write SetTransparent;
    property CenterText: Boolean read FCenterText write SetCenterText;
  end;

implementation

uses Consts;

type
  TBltBitmap = class(TBitmap)
    procedure MakeLike(ATemplate: TBitmap);
  end;

{ TBltBitmap }

procedure TBltBitmap.MakeLike(ATemplate: TBitmap);
begin
  Width := ATemplate.Width;
  Height := ATemplate.Height;
  Canvas.Brush.Color := clWindowFrame;
  Canvas.Brush.Style := bsSolid;
  Canvas.FillRect(Rect(0, 0, Width, Height));
end;

{ This function solves for x in the equation "x is y% of z". }
function SolveForX(Y, Z: Longint): Longint;
begin
  Result := Trunc( Z * (Y * 0.01) );
end;

{ This function solves for y in the equation "x is y% of z". }
function SolveForY(X, Z: Longint): Longint;
begin
  if Z = 0 then Result := 0
  else Result := Trunc( (X * 100.0) / Z );
end;

{ TTsvGauge }

constructor TTsvGauge.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csOpaque]-[csFramed];
//  ControlStyle := ControlStyle - [csOpaque];
  { default values }
  FMinValue := 0;
  FMaxValue := 100;
  FCurValue := 0;
  FKind := gkHorizontalBar;
  FShowPercent := false;
  FBorderStyle := bsNone;
  FStartColor := clnavy;
  FEndColor := clnavy;
  FColorCount:=256;
  FBackColor := clBtnFace;
  FCentertext:=false;
  Flat:=true;
  Width := 200;
  Height := 20;
end;

function TTsvGauge.GetPercentDone: Longint;
begin
  Result := SolveForY(round(FCurValue) - FMinValue, FMaxValue - FMinValue);
end;

procedure TTsvGauge.Paint;
var
  TheImage: TBitmap;
  OverlayImage: TBltBitmap;
  PaintRect: TRect;
begin
  with Canvas do
  begin
    TheImage := TBitmap.Create;
    try
      TheImage.Height := Height;
      TheImage.Width := Width;
      if FTransparent then begin
       TheImage.TransparentColor:=FBackColor;
       TheImage.transparent:=true;
       TheImage.Canvas.Brush.Style:=bsClear;
      end else begin
       TheImage.transparent:=false;
       TheImage.Canvas.Brush.Style:=bsSolid;
      end;
      PaintBackground(TheImage);
      PaintRect := ClientRect;
      if FBorderStyle = bsSingle then InflateRect(PaintRect, -1, -1);
      OverlayImage := TBltBitmap.Create;
      try
        OverlayImage.MakeLike(TheImage);
        PaintBackground(OverlayImage);
        case FKind of
          gkText: PaintAsNothing(OverlayImage, PaintRect);
          gkHorizontalBar, gkVerticalBar: PaintAsBar(OverlayImage, PaintRect);
          gkPie: PaintAsPie(OverlayImage, PaintRect);
          gkNeedle: PaintAsNeedle(OverlayImage, PaintRect);
        end;
        TheImage.Canvas.CopyMode := cmSrcInvert;
        TheImage.Canvas.Draw(0, 0, OverlayImage);
        TheImage.Canvas.CopyMode := cmSrcCopy;
        PaintAsText(TheImage, PaintRect);
      finally
        OverlayImage.Free;
      end;
      Canvas.CopyMode := cmSrcCopy;
      Canvas.Draw(0, 0, TheImage);
    finally
      TheImage.Destroy;
    end;

  end;
  inherited;
end;

procedure TTsvGauge.PaintBackground(AnImage: TBitmap);
var
  ARect: TRect;
begin
  with AnImage.Canvas do
  begin
    CopyMode := cmBlackness;
    ARect := Rect(0, 0, Width, Height);
    CopyRect(ARect, Animage.Canvas, ARect);
    CopyMode := cmSrcCopy;
  end;
end;

procedure TTsvGauge.PaintAsText(AnImage: TBitmap; PaintRect: TRect);
var
  S: string;
  X, Y: Integer;
  OverRect: TBltBitmap;
begin
  OverRect := TBltBitmap.Create;
  try
    OverRect.MakeLike(AnImage);
    PaintBackground(OverRect);
    if FShowPercent then
     S := FText+' '+Format('%d%%',[PercentDone])
    else
     S := FText;
    with OverRect.Canvas do
    begin
      Brush.Style := bsClear;
      Font := Self.Font;
      Font.Color := clWhite;
      with PaintRect do
      begin
       if FCentertext then begin
        X := (Right - Left + 1 - TextWidth(S)) div 2;
       end else begin
        X := 5;
       end;
       Y := (Bottom - Top + 2 - TextHeight(S)) div 2;
      end;
      TextRect(PaintRect, X, Y, S);
    end;
    AnImage.Canvas.CopyMode := cmSrcInvert;
    AnImage.Canvas.Draw(0, 0, OverRect);
  finally
    OverRect.Free;
  end;
end;

procedure TTsvGauge.PaintAsNothing(AnImage: TBitmap; PaintRect: TRect);
begin
  with AnImage do
  begin
    Canvas.Brush.Color := BackColor;
    Canvas.FillRect(PaintRect);
  end;
end;

procedure TTsvGauge.PaintAsBar(AnImage: TBitmap; PaintRect: TRect);
var
  FillSize: Longint;
  W, H: Integer;
begin
  W := PaintRect.Right - PaintRect.Left + 1;
  H := PaintRect.Bottom - PaintRect.Top + 1;
  with AnImage.Canvas do
  begin
    Brush.Color := BackColor;
    FillRect(PaintRect);
    Pen.Color := StartColor;
    Pen.Width := 1;
    Brush.Color := StartColor;
    case FKind of
      gkHorizontalBar:
        begin
          FillSize := SolveForX(PercentDone, W);
          if FillSize > W then FillSize := W;
          if FillSize > 0 then begin
//            FillRect(Rect(PaintRect.Left, PaintRect.Top,FillSize, H));
            FillGradientRect(AnImage.Canvas,
                             Rect(PaintRect.Left, PaintRect.Top,FillSize, H),
                             StartColor,
                             EndColor,
                             ColorCount,
                             fdLR);
          end;  
        end;
      gkVerticalBar:
        begin
          FillSize := SolveForX(PercentDone, H);
          if FillSize >= H then FillSize := H - 1;
          FillGradientRect(AnImage.Canvas,
                           Rect(PaintRect.Left, H - FillSize, W, H),
                           StartColor,
                           EndColor,
                           ColorCount,
                           fdTB);

        end;
    end;
  end;
end;

procedure TTsvGauge.PaintAsPie(AnImage: TBitmap; PaintRect: TRect);
var
  MiddleX, MiddleY: Integer;
  Angle: Double;
  W, H: Integer;
begin
  W := PaintRect.Right - PaintRect.Left;
  H := PaintRect.Bottom - PaintRect.Top;
  if FBorderStyle = bsSingle then
  begin
    Inc(W);
    Inc(H);
  end;
  with AnImage.Canvas do
  begin
    Brush.Color := Color;
    FillRect(PaintRect);
    Brush.Color := BackColor;
    Pen.Color := StartColor;
    Pen.Width := 1;
    Ellipse(PaintRect.Left, PaintRect.Top, W, H);
    if PercentDone > 0 then
    begin
      Brush.Color := StartColor;
      MiddleX := W div 2;
      MiddleY := H div 2;
      Angle := (Pi * ((PercentDone / 50) + 0.5));
      Pie(PaintRect.Left, PaintRect.Top, W, H, Round(MiddleX * (1 - Cos(Angle))),
        Round(MiddleY * (1 - Sin(Angle))), MiddleX, 0);
    end;
  end;
end;

procedure TTsvGauge.PaintAsNeedle(AnImage: TBitmap; PaintRect: TRect);
var
  MiddleX: Integer;
  Angle: Double;
  X, Y, W, H: Integer;
begin
  with PaintRect do
  begin
    X := Left;
    Y := Top;
    W := Right - Left;
    H := Bottom - Top;
    if FBorderStyle = bsSingle then
    begin
      Inc(W);
      Inc(H);
    end;
  end;
  with AnImage.Canvas do
  begin
    Brush.Color := Color;
    FillRect(PaintRect);
    Brush.Color := BackColor;
    Pen.Color := StartColor;
    Pen.Width := 1;
    Pie(X, Y, W, H * 2 - 1, X + W, PaintRect.Bottom - 1, X, PaintRect.Bottom - 1);
    MoveTo(X, PaintRect.Bottom);
    LineTo(X + W, PaintRect.Bottom);
    if PercentDone > 0 then
    begin
      Pen.Color := StartColor;
      MiddleX := Width div 2;
      MoveTo(MiddleX, PaintRect.Bottom - 1);
      Angle := (Pi * ((PercentDone / 100)));
      LineTo(Round(MiddleX * (1 - Cos(Angle))), Round((PaintRect.Bottom - 1) *
        (1 - Sin(Angle))));
    end;
  end;
end;

procedure TTsvGauge.SetTsvGaugeKind(Value: TTsvGaugeKind);
begin
  if Value <> FKind then
  begin
    FKind := Value;
    Refresh;
  end;
end;

procedure TTsvGauge.SetShowPercent(Value: Boolean);
begin
  if Value <> FShowPercent then
  begin
    FShowPercent := Value;
    Refresh;
  end;
end;

procedure TTsvGauge.SetBorderStyle(Value: TBorderStyle);
begin
  if Value <> FBorderStyle then
  begin
    FBorderStyle := Value;
    Refresh;
  end;
end;

procedure TTsvGauge.SetStartColor(Value: TColor);
begin
  if Value <> FStartColor then
  begin
    FStartColor := Value;
    Refresh;
  end;
end;

procedure TTsvGauge.SetEndColor(Value: TColor);
begin
  if Value <> FEndColor then
  begin
    FEndColor := Value;
    Refresh;
  end;
end;

procedure TTsvGauge.SetBackColor(Value: TColor);
begin
  if Value <> FBackColor then
  begin
    FBackColor := Value;
    Refresh;
  end;
end;

procedure TTsvGauge.SetMinValue(Value: Longint);
begin
  if Value <> FMinValue then
  begin
    if Value > FMaxValue then
      if not (csLoading in ComponentState) then
        raise EInvalidOperation.CreateFmt(SOutOfRange, [-MaxInt, FMaxValue - 1]);
    FMinValue := Value;
    if (round(FCurValue) < Value) then FCurValue := Value;
    Refresh;
  end;
end;

procedure TTsvGauge.SetMaxValue(Value: Longint);
begin
  if Value <> FMaxValue then
  begin
    if Value < FMinValue then
     exit;
{      if not (csLoading in ComponentState) then
        raise EInvalidOperation.CreateFmt(SOutOfRange, [FMinValue + 1, MaxInt]);}
    FMaxValue := Value;
    if (round(FCurValue) > Value) then FCurValue := Value;
    Refresh;
  end;
end;

procedure TTsvGauge.SetProgress(Value: Single);
var
  TempPercent: Longint;
begin
  TempPercent := GetPercentDone;  { remember where we were }
  if round(Value) < FMinValue then
    Value := FMinValue
  else if round(Value) > FMaxValue then
    Value := FMaxValue;
  if FCurValue <> Value then
  begin
    FCurValue := Value;
    if TempPercent <> GetPercentDone then { only refresh if percentage changed }
      Refresh;
  end;
  
end;

procedure TTsvGauge.AddProgress(Value: Single);
begin
  Progress := FCurValue + Value;
  Refresh;
end;

procedure TTsvGauge.SetText(Value: String);
begin
  FText:=Value;
  Refresh;
end;

procedure TTsvGauge.SetTransparent(Value: Boolean);
begin
  if Value<>FTransparent then begin
     FTransparent:=Value;
     Invalidate;
  end;
end;

procedure TTsvGauge.SetCenterText(Value: Boolean);
begin
  if Value<>FCenterText then begin
    FCentertext:=true;
    Invalidate;
  end;
end;

procedure TTsvGauge.FillGradientRect(canvas: tcanvas; Recty: trect;
                  fbcolor, fecolor: tcolor; fcolors: Integer; fdirect: TFillDirection);
var
  i, j, h, w: Integer;
  R, G, B: Longword;
  beginRGBvalue, RGBdifference: array[0..2] of Longword;
begin
  beginRGBvalue[0] := GetRvalue(colortoRGB(FBcolor));
  beginRGBvalue[1] := GetGvalue(colortoRGB(FBcolor));
  beginRGBvalue[2] := GetBvalue(colortoRGB(FBcolor));

  RGBdifference[0] := GetRvalue(colortoRGB(FEcolor)) - beginRGBvalue[0];
  RGBdifference[1] := GetGvalue(colortoRGB(FEcolor)) - beginRGBvalue[1];
  RGBdifference[2] := GetBvalue(colortoRGB(FEcolor)) - beginRGBvalue[2];

  canvas.pen.style := pssolid;
  canvas.pen.mode := pmcopy;

  R:=0;
  G:=0;
  B:=0;

  j := 0;
  h := recty.bottom - recty.top;
  w := recty.right - recty.left;

  case fdirect of
    fdRL: begin

     for i := fcolors downto 0 do begin
      recty.left  := muldiv(i - 1, w, fcolors);
      recty.right := muldiv(i, w, fcolors);
      if fcolors>1 then begin
        R := beginRGBvalue[0] + LongWord(muldiv(j, RGBDifference[0], fcolors));
        G := beginRGBvalue[1] + LongWord(muldiv(j, RGBDifference[1], fcolors));
        B := beginRGBvalue[2] + LongWord(muldiv(j, RGBDifference[2], fcolors));
      end;
      canvas.brush.color := RGB(R, G, B);
      patBlt(canvas.handle, recty.left, recty.top, Recty.right - recty.left, h, patcopy);
      inc(j);
     end;
    end;
    fdLR: begin

     for i :=0 to fcolors do begin
      recty.left  := muldiv(i-1 , w, fcolors);
      recty.right := muldiv(i , w, fcolors);
      if fcolors>1 then begin
        R := beginRGBvalue[0] + LongWord(muldiv(j, RGBDifference[0], fcolors));
        G := beginRGBvalue[1] + LongWord(muldiv(j, RGBDifference[1], fcolors));
        B := beginRGBvalue[2] + LongWord(muldiv(j, RGBDifference[2], fcolors));
      end;
      canvas.brush.color := RGB(R, G, B);
      patBlt(canvas.handle, recty.left, recty.top, Recty.right - recty.left, h, patcopy);
      inc(j);
     end;
    end;
    fdTB: begin

     for i :=0 to fcolors do begin
      recty.Top  := muldiv(i-1 , h, fcolors);
      recty.Bottom := muldiv(i , h, fcolors);
      if fcolors>1 then begin
        R := beginRGBvalue[0] + LongWord(muldiv(j, RGBDifference[0], fcolors));
        G := beginRGBvalue[1] + LongWord(muldiv(j, RGBDifference[1], fcolors));
        B := beginRGBvalue[2] + LongWord(muldiv(j, RGBDifference[2], fcolors));
      end;
      canvas.brush.color := RGB(R, G, B);
      patBlt(canvas.handle, recty.left, recty.top, w,Recty.Bottom - recty.top, patcopy);
      inc(j);
     end;

    end;
    fdBT: begin

     for i :=fcolors downto 0 do begin
      recty.Top  := muldiv(i-1 , h, fcolors);
      recty.Bottom := muldiv(i , h, fcolors);
      if fcolors>1 then begin
        R := beginRGBvalue[0] + LongWord(muldiv(j, RGBDifference[0], fcolors));
        G := beginRGBvalue[1] + LongWord(muldiv(j, RGBDifference[1], fcolors));
        B := beginRGBvalue[2] + LongWord(muldiv(j, RGBDifference[2], fcolors));
      end;
      canvas.brush.color := RGB(R, G, B);
      patBlt(canvas.handle, recty.left, recty.top, w,Recty.Bottom - recty.top, patcopy);
      inc(j);
     end;

    end;
  end;
end;


end.
