unit tsvGradient;

interface

uses  Windows, Classes, controls, Graphics, stdctrls;

type

   TFillDirection=(fdLeftRigth,fdRigthLeft,fdTopBottom,fdBottomTop);

   TtsvGradient=class(TCustomControl)
   private
     FDirection: TFillDirection;
     FFromColor: TColor;
     FToColor: TColor;
     FGradientCount: Word;
     procedure FillGradientRect(canvas: tcanvas; Recty: trect;
                                fbcolor, fecolor: tcolor; fcolors:
                                Integer; fdirect: TFillDirection);
     procedure SetFromColor(Value: TColor);
     procedure SetToColor(Value: TColor);
     procedure SetGradientCount(Value: Word);
     procedure SetDirection(Value: TFillDirection);
   public
     constructor Create(AOwner: TComponent); override;
     procedure Paint; override;
   published  

     property Align;
     property FromColor: TColor read FFromColor write SetFromColor;
     property ToColor: TColor read FToColor write SetToColor;
     property GradientCount: Word read FGradientCount write SetGradientCount;
     property Direction: TFillDirection read FDirection write SetDirection;
   end;



implementation

{ TtsvGradientLabel }

constructor TtsvGradient.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := [csAcceptsControls, csCaptureMouse, csClickEvents,
    csSetCaption, csOpaque, csDoubleClicks, csReplicatable];
  FDirection:=fdTopBottom;
  FFromColor:=clBlack;
  FToColor:=clWhite;
  FGradientCount:=64;
  Width:=100;
  Height:=75;
end;

procedure TtsvGradient.FillGradientRect(canvas: tcanvas; Recty: trect;
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

  j := 0;
  h := recty.bottom - recty.top;
  w := recty.right - recty.left;
  R:=0;
  G:=0;
  B:=0;

  case fdirect of
    fdRigthLeft: begin

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
    fdLeftRigth: begin

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
    fdTopBottom: begin

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
    fdBottomTop: begin

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

procedure TtsvGradient.Paint;
begin
  FillGradientRect(Canvas,GetClientRect,FFromColor, FToColor ,FGradientCount,FDirection);
end;

procedure TtsvGradient.SetFromColor(Value: TColor);
begin
  if Value<>FFromColor then begin
    FFromColor:=Value;
    Invalidate;
  end;
end;

procedure TtsvGradient.SetToColor(Value: TColor);
begin
  if Value<>FToColor then begin
    FToColor:=Value;
    Invalidate;
  end;
end;

procedure TtsvGradient.SetGradientCount(Value: Word);
begin
  if Value<>FGradientCount then begin
    FGradientCount:=Value;
    Invalidate;
  end;
end;

procedure TtsvGradient.SetDirection(Value: TFillDirection);
begin
  if Value<>FDirection then begin
    FDirection:=Value;
    Invalidate;
  end;
end;


end.
