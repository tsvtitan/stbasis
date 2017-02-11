unit tsvColorBox;

interface

uses Windows,Classes,Graphics,Stdctrls,dialogs, SysUtils;

const
  NoColorSelected = TColor($FF000000);
  StandardColorsCount = 16;
  ExtendedColorsCount = 4;
  SColorBoxCustomCaption = 'Другой...';

type
  TColorBoxStyles = (cbStandardColors, // first sixteen RGBI colors
                     cbExtendedColors, // four additional reserved colors
                     cbSystemColors,   // system managed/defined colors
                     cbIncludeNone,    // include clNone color, must be used with cbSystemColors
                     cbIncludeDefault, // include clDefault color, must be used with cbSystemColors
                     cbCustomColor,    // first color is customizable
                     cbPrettyNames);   // instead of 'clColorNames' you get 'Color Names'
  TColorBoxStyle = set of TColorBoxStyles;

  TTSVCustomColorBox = class(TCustomComboBox)
  private
    FStyle: TColorBoxStyle;
    FNeedToPopulate: Boolean;
    FListSelected: Boolean;
    FDefaultColorColor: TColor;
    FNoneColorColor: TColor;
    FSelectedColor: TColor;
    function GetColor(Index: Integer): TColor;
    function GetColorName(Index: Integer): string;
    function GetSelected: TColor;
    procedure SetSelected(const AColor: TColor);
    procedure ColorCallBack(const AName: string);
    procedure SetDefaultColorColor(const Value: TColor);
    procedure SetNoneColorColor(const Value: TColor);
  protected
    procedure CreateWnd; override;
    procedure Change;override;
    procedure DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    function PickCustomColor: Boolean; virtual;
    procedure PopulateList;
    procedure SetStyle(AStyle: TColorBoxStyle); reintroduce;
  public
    constructor Create(AOwner: TComponent); override;
    property Style: TColorBoxStyle read FStyle write SetStyle
      default [cbStandardColors, cbExtendedColors, cbSystemColors];
    property Colors[Index: Integer]: TColor read GetColor;
    property ColorNames[Index: Integer]: string read GetColorName;
    property Selected: TColor read GetSelected write SetSelected default clBlack;
    property DefaultColorColor: TColor read FDefaultColorColor write SetDefaultColorColor default clBlack;
    property NoneColorColor: TColor read FNoneColorColor write SetNoneColorColor default clBlack;
  end;

  TTSVColorBox = class(TTSVCustomColorBox)
  published
    property DefaultColorColor;
    property NoneColorColor;
    property Selected;
    property Style;

    property Anchors;
    property BevelEdges;
    property BevelInner;
    property BevelKind;
    property BevelOuter;
    property BiDiMode;
    property Color;
    property Constraints;
    property Ctl3D;
    property DropDownCount;
    property Enabled;
    property Font;
    property ItemHeight;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnChange;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDropDown;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnStartDock;
    property OnStartDrag;
  end;

implementation

{ TTSVCustomColorBox }

procedure TTSVCustomColorBox.ColorCallBack(const AName: String);
var
  I, LStart: Integer;
  LColor: TColor;
  LName: string;
begin
  LColor := StringToColor(AName);
  if cbPrettyNames in Style then
  begin
    if Copy(AName, 1, 2) = 'cl' then
      LStart := 3
    else
      LStart := 1;
    LName := '';
    for I := LStart to Length(AName) do
    begin
      case AName[I] of
        'A'..'Z':
          if LName <> '' then
            LName := LName + ' ';
      end;
      LName := LName + AName[I];
    end;
  end
  else
    LName := AName;
  Items.AddObject(LName, TObject(LColor));
end;

constructor TTSVCustomColorBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  inherited Style := csOwnerDrawFixed;
  FStyle := [cbStandardColors, cbExtendedColors, cbSystemColors];
  FSelectedColor := clWhite;
  FDefaultColorColor := clWhite;
  FNoneColorColor := clNone;
  PopulateList;
end;

procedure TTSVCustomColorBox.CreateWnd;
begin
  inherited CreateWnd;
  if FNeedToPopulate then
    PopulateList;
end;

procedure TTSVCustomColorBox.DrawItem(Index: Integer; Rect: TRect;
  State: TOwnerDrawState);

  function ColorToBorderColor(AColor: TColor): TColor;
  type
    TColorQuad = record
      Red,
      Green,
      Blue,
      Alpha: Byte;
    end;
  begin
    if (TColorQuad(AColor).Red > 192) or
       (TColorQuad(AColor).Green > 192) or
       (TColorQuad(AColor).Blue > 192) then
      Result := clBlack
    else if odSelected in State then
      Result := clWhite
    else
      Result := AColor;
  end;

var
  LRect: TRect;
  LBackground: TColor;
begin
  with Canvas do
  begin
    FillRect(Rect);
    LBackground := Brush.Color;

    LRect := Rect;
    LRect.Right := LRect.Bottom - LRect.Top + LRect.Left;
    InflateRect(LRect, -1, -1);
    Brush.Color := Colors[Index];
    if Brush.Color = clDefault then
      Brush.Color := DefaultColorColor
    else if Brush.Color = clNone then
      Brush.Color := NoneColorColor;
    FillRect(LRect);
    Brush.Color := ColorToBorderColor(ColorToRGB(Brush.Color));
    FrameRect(LRect);

    Brush.Color := LBackground;
    Rect.Left := LRect.Right + 5;

    TextRect(Rect, Rect.Left,
      Rect.Top + (Rect.Bottom - Rect.Top - TextHeight(Items[Index])) div 2,
      Items[Index]);
  end;
end;

function TTSVCustomColorBox.GetColor(Index: Integer): TColor;
begin
  Result := TColor(Items.Objects[Index]);
end;

function TTSVCustomColorBox.GetColorName(Index: Integer): string;
begin
  Result := Items[Index];
end;

function TTSVCustomColorBox.GetSelected: TColor;
begin
  if HandleAllocated then
    if ItemIndex <> -1 then
      Result := Colors[ItemIndex]
    else
      Result := NoColorSelected
  else
    Result := FSelectedColor;
end;

procedure TTSVCustomColorBox.KeyDown(var Key: Word; Shift: TShiftState);
begin
  FListSelected := False;
  inherited KeyDown(Key, Shift);
end;

procedure TTSVCustomColorBox.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  if (cbCustomColor in Style) and (Key = #13) and (ItemIndex = 0) then
  begin
    PickCustomColor;
    Key := #0;
  end;
end;

function TTSVCustomColorBox.PickCustomColor: Boolean;
var
  LColor: TColor;
begin
  with TColorDialog.Create(nil) do
    try
      LColor := ColorToRGB(TColor(Items.Objects[0]));
      Color := LColor;
      CustomColors.Text := Format('ColorA=%.8x', [LColor]);
      Result := Execute;
      if Result then
      begin
        Items.Objects[0] := TObject(Color);
        Self.Invalidate;
      end;
    finally
      Free;
    end;
end;

procedure TTSVCustomColorBox.PopulateList;
  procedure DeleteRange(const AMin, AMax: Integer);
  var
    I: Integer;
  begin
    for I := AMax downto AMin do
      Items.Delete(I);
  end;
  procedure DeleteColor(const AColor: TColor);
  var
    I: Integer;
  begin
    I := Items.IndexOfObject(TObject(AColor));
    if I <> -1 then
      Items.Delete(I);
  end;
var
  LSelectedColor, LCustomColor: TColor;
begin
  if HandleAllocated then
  begin
    Items.BeginUpdate;
    try
{      if (cbCustomColor in Style) and (Items.Count > 0) then
        LCustomColor := TColor(Items.Objects[0]);}
      LCustomColor := clWhite;
      
      LSelectedColor := FSelectedColor;
      Items.Clear;
      GetColorValues(ColorCallBack);
      if not (cbIncludeNone in Style) then
        DeleteColor(clNone);
      if not (cbIncludeDefault in Style) then
        DeleteColor(clDefault);
      if not (cbSystemColors in Style) then
        DeleteRange(StandardColorsCount + ExtendedColorsCount, Items.Count - 1);
      if not (cbExtendedColors in Style) then
        DeleteRange(StandardColorsCount, StandardColorsCount + ExtendedColorsCount - 1);
      if not (cbStandardColors in Style) then
        DeleteRange(0, StandardColorsCount - 1);
      if cbCustomColor in Style then
        Items.InsertObject(0, SColorBoxCustomCaption, TObject(LCustomColor));
      Selected := LSelectedColor;
    finally
      Items.EndUpdate;
      FNeedToPopulate := False;
    end;
  end
  else
    FNeedToPopulate := True;
end;

procedure TTSVCustomColorBox.SetDefaultColorColor(const Value: TColor);
begin
  if Value <> FDefaultColorColor then
  begin
    FDefaultColorColor := Value;
    Invalidate;
  end;
end;

procedure TTSVCustomColorBox.SetNoneColorColor(const Value: TColor);
begin
  if Value <> FNoneColorColor then
  begin
    FNoneColorColor := Value;
    Invalidate;
  end;
end;

procedure TTSVCustomColorBox.SetSelected(const AColor: TColor);
var
  I: Integer;
begin
  if HandleAllocated then
  begin
    I := Items.IndexOfObject(TObject(AColor));
    if (I = -1) and (cbCustomColor in Style) and (AColor <> NoColorSelected) then
    begin
      Items.Objects[0] := TObject(AColor);
      I := 0;
    end;
    ItemIndex := I;
  end;
  FSelectedColor := AColor;
end;

procedure TTSVCustomColorBox.SetStyle(AStyle: TColorBoxStyle);
begin
  if AStyle <> Style then
  begin
    FStyle := AStyle;
    Enabled := ([cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor] * FStyle) <> [];
    PopulateList;
    if (Items.Count > 0) and (ItemIndex = -1) then
      ItemIndex := 0;
  end;
end;

procedure TTSVCustomColorBox.Change;
begin
  FListSelected := False;
  if (cbCustomColor in Style) and
    (ItemIndex = 0) and
     not PickCustomColor then
      Exit;
  if Assigned(OnChange) then
     OnChange(Self);
end;

end.
