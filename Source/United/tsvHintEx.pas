unit tsvHintEx;

interface

uses Windows, Classes, Controls, Graphics, stdctrls, Messages;

type

  TtsvHintEx=class;

  TDirection = (bdNone,bdUp,bdDown,bdLeft,bdRight,bdHorzIn,bdHorzOut,bdVertIn,bdVertOut);
  TWayDirection = (Horz,Vert);

  TtsvHintExWindow=class(THintWindow)
  private
    FHint: string;
    FHintComponent: TtsvHintEx;
    procedure FillBackGround(Clr1, Clr2: TColor; Dir: TWayDirection; TwoWay: Boolean);
    function GetHintWidth(AHint: TtsvHintEx; Default: Integer): Integer;
    function GetHintText(AHint: TtsvHintEx; Default: string): string;
    function GetRealyCount(AHint: TtsvHintEx): Integer;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    procedure Paint;override;
    procedure CreateParams(var Params: TCreateParams);override;
    procedure ActivateHintData(Rect: TRect; const AHint: string; AData: Pointer); override;
    function CalcHintRect(MaxWidth: Integer; const AHint: string; AData: Pointer): TRect; override;
  end;

  TtsvHintExCaption=class(TCollectionItem)
  private
    FCaption: string;
    FBrush: TBrush;
    FFont: TFont;
    FPen: TPen;
    FAlignment: TAlignment;
    FToNewLine: Boolean;
    FWidth: Integer;
    FAutoSize: Boolean;
    procedure SetBrush(Value: TBrush);
    procedure SetFont(Value: TFont);
    procedure SetPen(Value: TPen);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy;override;
  published
    property Alignment: TAlignment read FAlignment write FAlignment;
    property AutoSize: Boolean read FAutoSize write FAutoSize;
    property Caption: string read FCaption write FCaption;
    property Brush: TBrush read FBrush write SetBrush;
    property Font: TFont read FFont write SetFont;
    property Pen: TPen read FPen write SetPen;
    property ToNewLine: Boolean read FToNewLine write FToNewLine;
    property Width: Integer read FWidth write FWidth;
  end;
  
  TtsvHintExCaptions=class(TCollection)
  private
    FHint: TtsvHintEx;
    function GetHintCaption(Index: Integer): TtsvHintExCaption;
    procedure SetHintCaption(Index: Integer; Value: TtsvHintExCaption);
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(AOwner: TtsvHintEx);
    destructor Destroy; override;
    function  Add: TtsvHintExCaption;
    procedure Assign(Source: TPersistent); override;
    procedure Clear;
    procedure Delete(Index: Integer);
    function Insert(Index: Integer): TtsvHintExCaption;
    property Items[Index: Integer]: TtsvHintExCaption read GetHintCaption write SetHintCaption;
  end;

  TtsvHintEx=class(TComponent)
  private
   FOldWndMethod: TWndMethod;
   FDirection: TDirection;
   FEndColor: TColor;
   FStartColor: TColor;
   FBrush: TBrush;
   FFont: TFont;
   FPen: TPen;
   FShadowVisible: Boolean;
   FShadowColor: TColor;
   FShadowWidth: Integer;
   FCaption: TStrings;
   FCaptions: TtsvHintExCaptions;
   FAlignment: TAlignment;
   FLayout: TTextLayout;
   FControl: TControl;
   FReshowTimeout: Integer;
   FHideTimeout: Integer;
   FLeft: Integer;
   FdHintPosX, FdHintPosY: Integer;

   procedure SetBrush(Value: TBrush);
   procedure SetFont(Value: TFont);
   procedure SetPen(Value: TPen);
   procedure SetCaption(Value: TStrings);
   procedure SetCaptions(Value: TtsvHintExCaptions);
   procedure SetControl(Value: TControl);

   procedure ControlWindowProc(var Message: TMessage);

  protected

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ActivateHint(Point: TPoint);overload;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    property Layout: TTextLayout read FLayout write FLayout;
    property Left: Integer read FLeft write FLeft;
    property ShadowVisible: Boolean read FShadowVisible write FShadowVisible;
    property ShadowColor: TColor read FShadowColor write FShadowColor;
    property ShadowWidth: Integer read FShadowWidth write FShadowWidth;
  published
    property Alignment: TAlignment read FAlignment write FAlignment;
    property Caption: TStrings read FCaption write SetCaption;
    property Captions: TtsvHintExCaptions read FCaptions write SetCaptions;
    property Control: TControl read FControl write SetControl;
    property Direction: TDirection read FDirection write FDirection;
    property StartColor: TColor read FStartColor write FStartColor;
    property EndColor: TColor read FEndColor write FEndColor;
    property Brush: TBrush read FBrush write SetBrush;
    property Font: TFont read FFont write SetFont;
    property Pen: TPen read FPen write SetPen;
    property ReshowTimeout: Integer read FReshowTimeout write FReshowTimeout;
    property HideTimeout: Integer read FHideTimeout write FHideTimeout;
    property dHintPosX: Integer read FdHintPosX write FdHintPosX;
    property dHintPosY: Integer read FdHintPosY write FdHintPosY;

  end;

implementation

uses Forms, SysUtils;

{ TtsvHintExWindow }

constructor TtsvHintExWindow.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  FHintComponent:=nil;
end;

destructor TtsvHintExWindow.Destroy;
begin
  inherited Destroy;
end;

procedure TtsvHintExWindow.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := WS_POPUP OR WS_DISABLED;
end;

procedure TtsvHintExWindow.ActivateHintData(Rect: TRect; const AHint: string; AData: Pointer); 
begin
  FHint:=AHint;
  FHintComponent:=AData;
  inherited;
end;

function TtsvHintExWindow.GetHintText(AHint: TtsvHintEx; Default: string): string;
var
  i: Integer;
  hc: TtsvHintExCaption;
  s: string;
begin
  Result:=Default;
  if AHint=nil then exit;
  if AHint.Captions.Count=0 then begin
    Result:=Trim(AHint.Caption.Text);
  end else begin
    s:='';
    for i:=0 to AHint.Captions.Count-1 do begin
      hc:=AHint.Captions.Items[i];
      if hc.ToNewLine then s:=s+#13;
      s:=s+hc.Caption;
    end;
    Result:=s;
  end;
end;

function TtsvHintExWindow.GetHintWidth(AHint: TtsvHintEx; Default: Integer): Integer;
var
  AFont: TFont;
  hc: TtsvHintExCaption;
  mw: Integer;
  s: string;
  i,cw: Integer;
begin
  Result:=Default;
  if AHint=nil then exit;
  AFont:=TFont.Create;
  try
    AFont.Assign(Canvas.Font);
    if AHint.Captions.Count=0 then begin
      Canvas.Font.Assign(AHint.Font);
      mw:=0;
      for i:=0 to AHint.Caption.Count-1 do begin
        cw:=Canvas.TextWidth(AHint.Caption.Strings[i]);
        if cw>mw then mw:=cw;
      end;
      Result:=mw+8;
    end else begin
      mw:=0;
      s:='';
      cw:=0;
      for i:=0 to AHint.Captions.Count-1 do begin
        hc:=AHint.Captions.Items[i];
        Canvas.Font.Assign(hc.Font);
        try
          s:=hc.Caption;
          if hc.ToNewLine then cw:=0;
          if hc.AutoSize then
           cw:=cw+Canvas.TextWidth(s)
          else cw:=cw+hc.Width;
          if cw>mw then mw:=cw;
        finally
          Canvas.Font.Assign(AFont);
        end;
      end;
      Result:=mw+6;
    end; 
  finally
    Canvas.Font.Assign(AFont);
    AFont.Free;
  end;
end;

function TtsvHintExWindow.CalcHintRect(MaxWidth: Integer; const AHint: string; AData: Pointer): TRect;
begin
  if AData=nil then begin
    Result:=inherited CalcHintRect(MaxWidth,AHint,AData);
    Result.Top:=Result.Top+1;
    Result.Bottom:=Result.Bottom-1;
  end else begin
    Result:=inherited CalcHintRect(MaxWidth,GetHintText(TtsvHintEx(AData),AHint),AData);
    Result.Right:=GetHintWidth(TtsvHintEx(AData),Result.Right);
    Result.Top:=Result.Top+1;
    Result.Bottom:=Result.Bottom-1;
  end;
end;

function TtsvHintExWindow.GetRealyCount(AHint: TtsvHintEx): Integer;
var
  i: Integer;
begin
  Result:=0;
  if AHint.Captions.Count>0 then Inc(Result);
  for i:=0 to AHint.Captions.Count-1 do begin
    if AHint.Captions.Items[i].ToNewLine then Inc(Result);
  end;
end;

procedure TtsvHintExWindow.Paint;
var
  OldBrush: TBrush;
  OldFont: TFont;
  OldPen: TPen;
  rt: TRect;
  i: Integer;
  s: string;
  h,w: Integer;
  x,y: Integer;
  hc: TtsvHintExCaption;
  RealyY,RealyCount: Integer;
  LastW: Integer;
begin
  rt:=GetClientRect;
  if FHintComponent<>nil then begin

    OldBrush:=TBrush.Create;
    OldFont:=TFont.Create;
    OldPen:=TPen.Create;
    OldBrush.Assign(Canvas.Brush);
    OldFont.Assign(Canvas.Font);
    OldPen.Assign(Canvas.Pen);
    try

      Canvas.Brush.Assign(FHintComponent.Brush);
      Canvas.Font.Assign(FHintComponent.Font);
      Canvas.Pen.Assign(FHintComponent.Pen);


      with FHintComponent do begin
        case Direction of
          bdNone: begin
            Canvas.FillRect(rt);
          end;
          bdUp: FillBackGround(StartColor, EndColor, Horz, False);
          bdDown: FillBackGround(EndColor, StartColor, Horz, False);
          bdLeft: FillBackGround(StartColor, EndColor, Vert, False);
          bdRight: FillBackGround(EndColor, StartColor, Vert, False);
          bdHorzOut: FillBackGround(StartColor, EndColor, Horz, True);
          bdHorzIn: FillBackGround(EndColor, StartColor, Horz, True);
          bdVertIn: FillBackGround(StartColor, EndColor, Vert, True);
        else
          FillBackGround(EndColor, StartColor, Vert, True);
        end;

        if ShadowVisible then begin


        end;
      end;

      h:=rt.Bottom-rt.Top;
      w:=rt.Right-rt.Left;

      if FHintComponent.Captions.Count=0 then begin

        Canvas.Brush.Assign(FHintComponent.Brush);
        Canvas.Font.Assign(FHintComponent.Font);
        Canvas.Pen.Assign(FHintComponent.Pen);

        for i:=0 to FHintComponent.Caption.Count-1 do begin
          s:=FHintComponent.Caption.Strings[i];
          x:=0;
          y:=0;
          case FHintComponent.Alignment of
            taLeftJustify: x:=2;
            taRightJustify: x:=w-Canvas.TextWidth(s)-2;
            taCenter: x:=w div 2 - Canvas.TextWidth(s) div 2;
          end;
          case FHintComponent.Layout of
            tlTop: y:=Canvas.TextHeight(s)*i;
            tlBottom: y:=(h div FHintComponent.Caption.Count)*(i+1)-Canvas.TextHeight(s);
            tlCenter: y:=(h div FHintComponent.Caption.Count)*i+(h div FHintComponent.Caption.Count) div 2 - Canvas.TextHeight(s) div 2;
          end;
          Canvas.TextOut(x,y,s);
        end;

      end else begin

        x:=2;
        RealyY:=0;
        LastW:=0;
        RealyCount:=GetRealyCount(FHintComponent);
        for i:=0 to FHintComponent.Captions.Count-1 do begin
          hc:=FHintComponent.Captions.Items[i];
          Canvas.Brush.Assign(hc.Brush);
          Canvas.Font.Assign(hc.Font);
          Canvas.Pen.Assign(hc.Pen);
          try
            s:=hc.Caption;
            if hc.ToNewLine then begin
              Inc(RealyY);
              x:=2;
              y:=(h div RealyCount)*RealyY + (h div RealyCount)div 2 - Canvas.TextHeight(hc.Caption) div 2;
            end else begin
              x:=x+LastW;
              y:=(h div RealyCount)*RealyY + (h div RealyCount)div 2 - Canvas.TextHeight(hc.Caption) div 2;
              if hc.AutoSize then
                LastW:=Canvas.TextWidth(s)
              else LastW:=hc.Width;
            end;
           Canvas.TextOut(x,y,s);
          finally
            Canvas.Brush.Assign(FHintComponent.Brush);
            Canvas.Font.Assign(FHintComponent.Font);
            Canvas.Pen.Assign(FHintComponent.Pen);
          end;
        end;

      end;

      Canvas.Brush.Style:=bsClear;
      Canvas.Rectangle(rt);


    finally
     Canvas.Brush.Assign(OldBrush);
     Canvas.Font.Assign(OldFont);
     Canvas.Pen.Assign(OldPen);
     OldBrush.Free;
     OldFont.Free;
     OldPen.Free;
    end;

  end else begin

    inherited Paint;

    Canvas.Brush.Style:=bsSolid;
    Canvas.Brush.Color:=clInfoBk;
    Canvas.FillRect(rt);

    Canvas.Brush.Style:=bsClear;
    Canvas.Font.Color:=clWindowText;
    Canvas.TextOut(3,2,FHint);

    Canvas.Brush.Style:=bsClear;
    Canvas.Pen.Color:=clBlack;
    Canvas.Rectangle(rt);

  end;
end;

procedure TtsvHintExWindow.FillBackGround(Clr1,Clr2: TColor; Dir: TWayDirection; TwoWay: Boolean);
var
  RGBFrom   : array[0..2] of Byte;    { from RGB values                     }
  RGBDiff   : array[0..2] of integer; { difference of from/to RGB values    }
  ColorBand : TRect;                  { color band rectangular coordinates  }
  I         : Integer;                { color band index                    }
  R         : Byte;                   { a color band's R value              }
  G         : Byte;                   { a color band's G value              }
  B         : Byte;                   { a color band's B value              }
  Last      : Integer;                { last value in loop }
begin
  { Extract from RGB values}
  RGBFrom[0] := GetRValue(ColorToRGB(Clr1));
  RGBFrom[1] := GetGValue(ColorToRGB(Clr1));
  RGBFrom[2] := GetBValue(ColorToRGB(Clr1));
  { Calculate difference of from and to RGB values}
  RGBDiff[0] := GetRValue(ColorToRGB(Clr2)) - RGBFrom[0];
  RGBDiff[1] := GetGValue(ColorToRGB(Clr2)) - RGBFrom[1];
  RGBDiff[2] := GetBValue(ColorToRGB(Clr2)) - RGBFrom[2];
  { Set pen sytle and mode}
  { Set color band's left and right coordinates }
  if Dir = Horz then
    begin
      ColorBand.Left := 0;
      ColorBand.Right := Width;
    end
  else
    begin
      ColorBand.Top := 0;
      ColorBand.Bottom := Height;
    end;
  { Set number of iterations to do }
  if TwoWay then
    Last := $7f
  else
    Last := $ff;
  for I := 0 to Last do begin
    { Calculate color band color}
    R := RGBFrom[0] + MulDiv(I,RGBDiff[0],Last);
    G := RGBFrom[1] + MulDiv(I,RGBDiff[1],Last);
    B := RGBFrom[2] + MulDiv(I,RGBDiff[2],Last);
    { Select brush and paint color band }
    Canvas.Brush.Color := RGB(R,G,B);
    if Dir = Horz then
      begin
        { Calculate color band's top and bottom coordinates}
        ColorBand.Top    := MulDiv (I    , Height, $100);
        ColorBand.Bottom := MulDiv (I + 1, Height, $100);
      end
    else
      begin
        { Calculate color band's left and right coordinates}
        ColorBand.Left  := MulDiv (I    , Width, $100);
        ColorBand.Right := MulDiv (I + 1, Width, $100);
      end;
    Canvas.FillRect(ColorBand);
    if TwoWay then begin
      { This is a two way fill, so do the other half }
      if Dir = Horz then
        begin
          { Calculate color band's top and bottom coordinates}
          ColorBand.Top    := MulDiv ($ff - I    , Height, $100);
          ColorBand.Bottom := MulDiv ($ff - I + 1, Height, $100);
        end
      else
        begin
          { Calculate color band's left and right coordinates}
          ColorBand.Left  := MulDiv ($ff - I    , Width, $100);
          ColorBand.Right := MulDiv ($ff - I + 1, Width, $100);
        end;
      Canvas.FillRect(ColorBand);
    end;
  end;
end;


{ TtsvHintExCaption }

constructor TtsvHintExCaption.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FBrush:=TBrush.Create;
  FBrush.Style:=bsClear;
  FFont:=TFont.Create;
  FPen:=TPen.Create;
  FAutoSize:=true;
end;

destructor TtsvHintExCaption.Destroy;
begin
  FBrush.Free;
  FFont.Free;
  FPen.Free;
  inherited;
end;

procedure TtsvHintExCaption.SetBrush(Value: TBrush);
begin
  FBrush.Assign(Value);
end;

procedure TtsvHintExCaption.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TtsvHintExCaption.SetPen(Value: TPen);
begin
  FPen.Assign(Value);
end;

{ TtsvHintExCaptions }

constructor TtsvHintExCaptions.Create(AOwner: TtsvHintEx);
begin
  inherited Create(TtsvHintExCaption);
  FHint:=AOwner; 
end;

destructor TtsvHintExCaptions.Destroy;
begin
  inherited;
end;

function TtsvHintExCaptions.GetHintCaption(Index: Integer): TtsvHintExCaption;
begin
  Result := TtsvHintExCaption(inherited Items[Index]);
end;

procedure TtsvHintExCaptions.SetHintCaption(Index: Integer; Value: TtsvHintExCaption);
begin
  Items[Index].Assign(Value);
end;

function TtsvHintExCaptions.GetOwner: TPersistent;
begin
  Result := FHint;
end;

function  TtsvHintExCaptions.Add: TtsvHintExCaption;
begin
  Result := TtsvHintExCaption(inherited Add);
end;

procedure TtsvHintExCaptions.Assign(Source: TPersistent);
begin
  if Source is TtsvHintEx then begin
  end else
   inherited Assign(Source);
end;

procedure TtsvHintExCaptions.Clear;
begin
  inherited Clear;
end;

procedure TtsvHintExCaptions.Delete(Index: Integer);
begin
  Inherited Delete(Index);
end;

function TtsvHintExCaptions.Insert(Index: Integer): TtsvHintExCaption;
begin
  Result:=TtsvHintExCaption(Inherited Insert(Index));
end;

{ TtsvHintEx }

constructor TtsvHintEx.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBrush:=TBrush.Create;
  FFont:=TFont.Create;
  FPen:=TPen.Create;
  FStartColor:=clBlue;
  FEndColor:=clBlack;
  FLayout:=tlCenter;
  FCaption:=TStringList.Create;
  FCaptions:=TtsvHintExCaptions.Create(Self);
  FReshowTimeout:=500;
  FHideTimeout:=500;
  FdHintPosX:=-10;
  FdHintPosY:=5;
end;

destructor TtsvHintEx.Destroy;
begin
  SetControl(nil);
  Application.ShowHint:=false;
  Application.ShowHint:=true;
  FCaptions.Free;
  FCaption.Free;
  FPen.Free;
  FFont.Free;
  FBrush.Free;
  inherited Destroy;
end;

procedure TtsvHintEx.SetBrush(Value: TBrush);
begin
  FBrush.Assign(Value);
end;

procedure TtsvHintEx.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TtsvHintEx.SetPen(Value: TPen);
begin
  FPen.Assign(Value);
end;

procedure TtsvHintEx.SetCaption(Value: TStrings);
begin
  FCaption.Assign(Value);
end;

procedure TtsvHintEx.SetCaptions(Value: TtsvHintExCaptions);
begin
  FCaptions.Assign(Value);
end;

procedure TtsvHintEx.ActivateHint(Point: TPoint);
begin
  Application.ActivateHint(Point);
end;

procedure TtsvHintEx.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FControl) then
    SetControl(nil);
end;

procedure TtsvHintEx.SetControl(Value: TControl);
begin
  if Value<>FControl then begin
    if FControl<>nil then
      FControl.WindowProc:=FOldWndMethod;
    if Value<>nil then begin
      FOldWndMethod:=Value.WindowProc;
    end else begin
      FOldWndMethod:=nil;
    end;  
    FControl:=Value;
    if FControl<>nil then 
      FControl.WindowProc:=ControlWindowProc;
  end;
end;

procedure TtsvHintEx.ControlWindowProc(var Message: TMessage);
var
  P: PHintInfo;
begin
  case Message.Msg of
    CM_HINTSHOW: begin
      P:=Pointer(Message.LParam);
      if P.HintControl=FControl then begin
        P.HintData:=Self;
        P.HintWindowClass:=TtsvHintExWindow;
        P.ReshowTimeout:=FReshowTimeout;
        P.HideTimeout:=FHideTimeout;
        P.HintPos:=Point(P.HintPos.x+FdHintPosX,P.HintPos.y+FdHintPosY);
      end else begin
        P.HintData:=nil;
        P.HintWindowClass:=HintWindowClass;
      end;
    end;
    else
      if Assigned(FOldWndMethod) then
        FOldWndMethod(Message);
  end;
end;


end.
