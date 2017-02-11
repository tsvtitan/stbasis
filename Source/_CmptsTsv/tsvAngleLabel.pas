{******************************************************************************}
{**                                                                          **}
{**  TtsvLabel Component - enhanced TLabel for angled text output.           **}
{**  For Delphi 2-5, C++ Builder 1-4.                                        **}
{**                                                                          **}
{**  Author:    KARPOLAN                                                     **}
{**  E-Mail:    karpolan@yahoo.com , karpolan@utilmind.com                   **}
{**  Home Page: http://karpolan.i.am, http://www.utilmind.com                **}
{**  Copyright © 1996-99 by KARPOLAN.                                        **}
{**                                                                          **}
{******************************************************************************}
Unit tsvAngleLabel;

{** History:
  13 feb 1999 - 1.0 First reliase....
  04 mar 1999 - 1.1 Reorganized for old Delphi versions support. Added some compiler
    derectives for correct methods inheriting.
    Added/Overrided:
      Methods : Paint, AdjustBounds.
  31 aug 1999 - 1.2 Prepared for public release. Some updates...
*******************************************************************************}

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

Type
  TtsvAngleDirection = (adEast, adNothEast , adNoth , adNothWest,
                        adWest, adSouthWest, adSouth, adSouthEast);

{##############################################################################}
{## TtsvCustomAngleLabel = Class(TCustomLabel) ################################}
{##############################################################################}
  TtsvCustomAngleLabel = Class(TCustomLabel)
  Private
  {** Fields **}
    fAngle            : integer;
    fAngleDirection   : TtsvAngleDirection;
    fTextPos          : TPoint;
    fDirectionFont    : HFONT;
  {** Properties Routine **}
    Procedure SetAngle           (A : integer);
    Procedure SetAngleDirection  (A : TtsvAngleDirection);
  {** Messages Routine **}
    Procedure CMTextChanged(Var Message: TMessage); Message CM_TEXTCHANGED;
    Procedure CMFontChanged(Var Message: TMessage); Message CM_FONTCHANGED;

  Protected
  {** Override This **}
    Procedure Notification(AComponent: TComponent;
                           Operation : TOperation);                    Override;
    Procedure Loaded;                                                  Override;
  {** Drawing Routines **}
    Procedure Paint;                                                   Override;
    Procedure AdjustBounds;                                            Override; 
{    Procedure DoDrawText(Var ARect : TRect;
                         AFlags    : Longint);                          Virtual;}
    Procedure DoDrawText(Var ARect : TRect;
                         AFlags    : Longint);                         Override;
  {** Font and Size Routines **}
    Procedure ReCreateFont;                                             Virtual;
    Procedure CalcRect(Var ARect : TRect);                              Virtual;
  {** Properties **}
    Property Angle               : integer
      Read   fAngle
      Write  SetAngle              Default 0;
    Property AngleDirection      : TtsvAngleDirection
      Read   fAngleDirection
      Write  SetAngleDirection     Default adEast;
  Public
  {** Init/Done **}
    Constructor Create(AOwner : TComponent);                           Override;
    Destructor  Destroy;                                               Override;
  End;{TtsvCustomAngleLabel = Class(TCustomLabel)}


{##############################################################################}
{## TtsvAngleLabel = Class(TtsvCustomAngleLabel) ##############################}
{##############################################################################}
  TtsvAngleLabel = Class(TtsvCustomAngleLabel)
  Published
  {** Properties **}
    property Alignment;
    property AutoSize;
    Property Angle;
    Property AngleDirection;
    Property Align;
    property FocusControl;
    Property Caption;
    Property Enabled;
    Property Font;
    Property ParentFont;
    Property ParentShowHint;
    Property PopupMenu;
    Property ShowHint;
    Property Transparent;
    property Layout;
    Property Visible;
    Property Anchors;
    Property Constraints;
    property WordWrap;
  {** Events **}
    Property OnClick;
    Property OnDblClick;
    Property OnDragDrop;
    Property OnDragOver;
    Property OnEndDrag;
    Property OnMouseDown;
    property OnMouseMove;
    Property OnMouseUp;
    Property OnStartDrag;
    Property OnStartDock;
    Property OnEndDock;
  End;{TtsvAngleLabel = Class(TtsvCustomAngleLabel)}

Function DirectionByAngle(Angle : integer) : TtsvAngleDirection;
Function AngleByDirection(Direction : TtsvAngleDirection) : integer;

{##############################################################################}
{******************************************************************************}
{##############################################################################}
Implementation
{##############################################################################}
{******************************************************************************}
{##############################################################################}

Function DirectionByAngle(Angle : integer) : TtsvAngleDirection;
Const
  DirectionsByOrder : Array[0..7] of TtsvAngleDirection = (
    adEast, adNothEast , adNoth ,  adNothWest,
    adWest, adSouthWest, adSouth,  adSouthEast);
Begin
  if Angle < 0
   then Angle := 360 - (-Angle mod 360);
  Result := DirectionsByOrder[((Angle + 23) mod 360) div 45];
End;{Function DirectionByAngle}

Function AngleByDirection(Direction : TtsvAngleDirection) : integer;
Const
  AnglesForDirections : Array[TtsvAngleDirection] of integer = (
    0, 45, 90, 135, 180, 225, 270, 315);
Begin
  Result := AnglesForDirections[Direction];
End;{Function AngleByDirection}

{##############################################################################}
{## TtsvCustomAngleLabel = Class(TCustomLabel) #####################################}
{##############################################################################}
Const
  Alignments : Array[TAlignment] of Word = (DT_LEFT, DT_RIGHT, DT_CENTER);
  WordWraps  : Array[Boolean   ] of Word = (0, DT_WORDBREAK);
{******************************************************************************}
{** Public ********************************************************************}
{******************************************************************************}
{** Init/Done **}
{***************}
Constructor TtsvCustomAngleLabel.Create(AOwner : TComponent);
Begin
  FillChar(fTextPos, SizeOf(fTextPos), 0);
  fAngleDirection:=adNoth;

  Inherited Create(AOwner);

  Font.Name:='Arial';

End;{Constructor TtsvCustomAngleLabel.Create}

Destructor TtsvCustomAngleLabel.Destroy;
Begin
  Inherited Destroy;
End;{Destructor TtsvCustomAngleLabel.Destroy}

{******************************************************************************}
{** Protected *****************************************************************}
{******************************************************************************}
{** Override This **}
{*******************}
Procedure TtsvCustomAngleLabel.Notification(AComponent: TComponent;
                                            Operation : TOperation);
Begin
  Inherited Notification(AComponent, Operation);
End;{Procedure TtsvCustomAngleLabel.Notification}

Procedure TtsvCustomAngleLabel.Loaded;
Begin
  Inherited Loaded;
  ReCreateFont;
  AdjustBounds;
End;{Procedure TtsvCustomAngleLabel.Loaded}

{**********************}
{** Drawing Routines **}
{**********************}

Procedure TtsvCustomAngleLabel.Paint;
Var
  CalcRect  : TRect;
  ARect     : TRect;
  DrawStyle : Integer;
Begin
  with Canvas do
   begin
     ARect := ClientRect;
     if not Transparent then
      begin
        Brush.Color := Self.Color;
        Brush.Style := bsSolid;
        FillRect(ARect);
      end;{if not Transparent then}

     Brush.Style := bsClear;
     DrawStyle := DT_EXPANDTABS or WordWraps[WordWrap] or Alignments[Alignment];
     
   {** Calculate vertical layout **}
     if Layout <> tlTop then
      begin
        CalcRect := ARect;
        DoDrawText(CalcRect, DrawStyle or DT_CALCRECT);
        if Layout = tlBottom
         then OffsetRect(ARect, 0, (Height - CalcRect.Bottom))
         else OffsetRect(ARect, 0, (Height - CalcRect.Bottom) div 2);
      end;{if Layout <> tlTop then}

     DoDrawText(ARect, DrawStyle);
   end;{with Canvas do}
End;{Procedure TtsvCustomAngleLabel.Paint}

Procedure TtsvCustomAngleLabel.AdjustBounds;
Var
  DC   : HDC;
  X    : integer;
  Rect : TRect;
Begin
  if not (csReading in ComponentState) and AutoSize then
   begin
     Rect := ClientRect;
     DC := GetDC(0);
     Canvas.Handle := DC;
     DoDrawText(Rect, (DT_EXPANDTABS or DT_CALCRECT) or WordWraps[WordWrap]);
     Canvas.Handle := 0;
     ReleaseDC(0, DC);
     X := Left;
     if Alignment = taRightJustify
      then Inc(X, Width - Rect.Right);
     SetBounds(X, Top, Rect.Right, Rect.Bottom);
   end;{if not ...}
End;{Procedure TtsvCustomAngleLabel.AdjustBounds}

Procedure TtsvCustomAngleLabel.DoDrawText(Var ARect  : TRect;
                                          AFlags     : LongInt);
Var
  Text    : String;
  RegFont : HFONT;
Begin
  if (AFlags and DT_CALCRECT <> 0) then
   begin
     CalcRect(ARect);
     Exit;
   end;{if (AFlags and DT_CALCRECT <> 0) then}

  Text := Caption;

  ReCreateFont;
  RegFont := SelectObject(Canvas.Handle, fDirectionFont);
    TextOut(Canvas.Handle, fTextPos.X, fTextPos.Y, PChar(Text), Length(Text));
  SelectObject(Canvas.Handle, RegFont);
End;{Procedure TtsvCustomAngleLabel.DoDrawText}


{****************************}
{** Font and Size Routines **}
{****************************}
Procedure TtsvCustomAngleLabel.ReCreateFont;
Var
  ALogFont : TLOGFONT;
  FontName : String;
Begin
  FillChar(ALogFont, SizeOf(ALogFont), 0);
  FontName := Font.Name;

  with ALogFont, Font do
   begin
     LStrCpy(lfFaceName, PChar(FontName));
     lfHeight := Font.Height;
     if (fsBold in Style)
      then lfWeight := FW_BOLD
      else lfWeight := FW_NORMAL;
     if (fsItalic in Style)
      then lfItalic := 1;
     if (fsUnderline in Style)
      then lfUnderline := 1;
     if (fsStrikeOut in Style)
      then lfStrikeOut := 1;
     lfEscapement  := AngleByDirection(fAngleDirection) * 10;
//     lfOrientation := lfEscapement;
   end;{with ALogFont do}

  if fDirectionFont <> 0
   then DeleteObject(fDirectionFont);
  fDirectionFont := CreateFontIndirect(ALogFont);
End;{Procedure TtsvCustomAngleLabel.ReCreateFont}


Procedure TtsvCustomAngleLabel.CalcRect(Var ARect : TRect);

  Procedure HorizontalRect;
  Begin
  End;{Internal Procedure HorizontalRect}

  Procedure VerticalRect;
  Begin
    with ARect do
     ARect := Rect(Left, Top, Left + (Bottom - Top), Top + (Right - Left));
  End;{Internal Procedure VerticalRect}

  Procedure AngleRect;
  Const
    extSin45 = 0.7071067;
  Var
    WidthHeight : integer;
  Begin
    with ARect do
     begin
       WidthHeight := Round((Right - Left) * extSin45) + Abs(Font.Height);
       ARect := Rect(Left, Top, Left + WidthHeight, Top + WidthHeight);
     end;{with ARect do}
  End;{Internal Procedure AngleRect}

  Procedure CalcRectByText;
  Var
    Text   : String;
    AFlags : Word;
  Begin
    Text := Caption;
    if ((Text = '') or ShowAccelChar and (Text[1] = '&') and (Text[2] = #0))
     then Text := Text + ' ';

    AFlags := DT_CALCRECT or DT_EXPANDTABS or WordWraps[WordWrap] or Alignments[Alignment];
    if not ShowAccelChar
     then AFlags := AFlags or DT_NOPREFIX;

    Canvas.Font := Font;
    DrawText(Canvas.Handle, PChar(Text), Length(Text), ARect, AFlags);
  End;{Internal Procedure CalcRectByText}

Begin
  CalcRectByText;

  with ARect do
   case fAngleDirection of
    adEast      : begin
      HorizontalRect;
      fTextPos := TopLeft;
    end;
    adNothEast  : begin
      AngleRect;
      fTextPos := Point(Left, Bottom + Font.Height);
    end;
    adNoth      : begin
      VerticalRect;
      fTextPos := Point(Left, Bottom);
    end;
    adNothWest  : begin
      AngleRect;
      fTextPos := Point(Right + Font.Height, Bottom);
    end;
    adWest      : begin
      HorizontalRect;
      fTextPos := Point(Right, Bottom);
    end;
    adSouthWest : begin
      AngleRect;
      fTextPos := Point(Right, Top - Font.Height);
    end;
    adSouth     : begin
      VerticalRect;
      fTextPos := Point(Right, Top);
    end;
    adSouthEast : begin
      AngleRect;
      fTextPos := Point(Left - Font.Height , Top);
    end;
   end;{case fAngleDirection of}
End;{Procedure TtsvCustomAngleLabel.CalcRect}


{******************************************************************************}
{** Private *******************************************************************}
{******************************************************************************}
{** Properties Routine **}
{************************}
Procedure TtsvCustomAngleLabel.SetAngle(A : integer);
Begin
  AngleDirection := DirectionByAngle(A);
End;{Procedure TtsvCustomAngleLabel.SetAngle}

Procedure TtsvCustomAngleLabel.SetAngleDirection(A : TtsvAngleDirection);
Begin
  if fAngleDirection = A
   then Exit;
  fAngleDirection := A;
  fAngle          := AngleByDirection(fAngleDirection);

  AdjustBounds;
  Invalidate;
End;{Procedure TtsvCustomAngleLabel.SetAngleDirection}

{**********************}
{** Messages Routine **}
{**********************}
Procedure TtsvCustomAngleLabel.CMTextChanged(Var Message: TMessage);
Begin
  AdjustBounds;
  Invalidate;
End;{Procedure TtsvCustomAngleLabel.CMTextChanged}

Procedure TtsvCustomAngleLabel.CMFontChanged(var Message: TMessage);
Begin
  AdjustBounds;
End;{Procedure TtsvCustomAngleLabel.CMFontChanged}


END{Unit antAngleLabel}.
