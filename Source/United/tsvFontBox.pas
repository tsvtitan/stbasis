unit tsvFontBox;

{$IFNDEF VER80}
 {$IFNDEF VER90}
  {$IFNDEF VER93}
    {$IFNDEF VER100}
      {$IFNDEF VER110}
        {$DEFINE ST4}
        {$IFNDEF VER120}
           {$IFNDEF VER125}
            {$DEFINE ST5}
          {$ENDIF}
        {$ENDIF}
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}
 {$ENDIF}
{$ENDIF}

interface

uses
  Windows, Messages, Controls, Classes, Graphics,
  StdCtrls, SysUtils, Printers, Forms, tsvHint;

const
  TestSentence      = 'Ýעמ עוסע רנטפעא';

type
  TFontType = (TrueTypeFonts, RasterFonts, DeviceFonts, OtherFonts);

  TFontsType = set of TFontType;

  TPreviewPosition = (ppLeftTop, ppLeftBottom, ppRightTop, ppRightBottom);

  TSTHintWindow = class (TNewHintWindow)
  protected
    procedure Paint; override;
  end;
  
  TPreview = class (TPersistent)
  private
    FColor		: TColor;
    FFontColor		: TColor;
    FFontSize		: Integer;
    FFontStyle		: TFontStyles;
    FMaxWidth		: Integer;
    FMargin		: Integer;
    FPosition		: TPreviewPosition;
    FText		: string;
    FVisible		: Boolean;
  published
    property Color	: TColor read FColor write FColor default clInfoBk;
    property FontColor	: TColor read FFontColor write FFontColor default clInfoText;
    property FontSize	: Integer read FFontSize write FFontSize default 14;
    property FontStyle	: TFontStyles read FFontStyle write FFontStyle;
    property MaxWidth	: Integer read FMaxWidth write FMaxWidth default 200;
    property Margin	: Integer read FMargin write FMargin default 2;
    property Position	: TPreviewPosition read FPosition write FPosition default ppRightTop;
    property Text	: string read FText write FText;
    property Visible	: Boolean read FVisible write FVisible default True;
  end;

  TTSVFontBox = class (TCustomComboBox)
  private
    FAutoUpdate		: Boolean;
    FTrueTypeBmp	: TBitmap;
    FRasterBmp		: TBitmap;
    FDeviceBmp		: TBitmap;
    FFontName		: TFontName;
    FFontsType		: TFontsType;
    FNoFonts		: TStringList;
    FPreview		: TPreview;
    FHintWindow		: TSTHintWindow;
    FBitmap		: TBitmap;
    FBmpWidth		: Integer;
    procedure SetFontName (Value: TFontName);
    procedure SetFontsType (Value: TFontsType);
    procedure SetNoFonts (Value: TStringList);
    procedure UpdateHeight;
    procedure NoFontsChanged (Sender: TObject);
    procedure CMFontChanged (var Message: TMessage); message CM_FONTCHANGED;
    procedure CNCommand (var Message: TWMCommand);  message CN_COMMAND;
  protected
    procedure DrawItem (Index: Integer; Rect: TRect; State: TOwnerDrawState); override;
    procedure Change; override;
  public
    constructor Create (AOwner: TComponent); override;
    procedure CreateWnd; override;
    procedure Loaded; override;
    destructor Destroy; override;
    procedure SetTrueTypeBmp (Value: TBitmap);
    procedure SetRasterBmp (Value: TBitmap);
    procedure SetDeviceBmp (Value: TBitmap);
  published
    property AutoUpdate		: Boolean read FAutoUpdate write FAutoUpdate default True;
    property FontName		: TFontName read FFontName write SetFontName;
    property FontsType		: TFontsType read FFontsType write SetFontsType default [TrueTypeFonts, RasterFonts, DeviceFonts, OtherFonts];
    property TrueTypeBmp	: TBitmap read FTrueTypeBmp write SetTrueTypeBmp;
    property RasterBmp		: TBitmap read FRasterBmp write SetRasterBmp;
    property DeviceBmp		: TBitmap read FDeviceBmp write SetDeviceBmp;
    property NoFonts		: TStringList read FNoFonts write SetNoFonts;
    property Preview		: TPreview read FPreview write FPreview;
    procedure UpdateFonts;
    {$IFDEF ST4}
    property Anchors;
    property BiDiMode;
    property Constraints;
    property DragKind;
    property ParentBiDiMode;
    property OnEndDock;
    property OnStartDock;
    {$ENDIF}
    {$IFDEF ST5}
    property OnConTextPopup;
    {$ENDIF}
    {$IFNDEF VER90}
    property ImeMode;
    property ImeName;
    {$ENDIF}
    property Color;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property DropDownCount;
    property Enabled;
    property Font;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property Visible;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDropDown;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnStartDrag;
  end;

  TTSVFontList = class (TCustomListBox)
  private
    FTrueTypeBmp	: TBitmap;
    FRasterBmp		: TBitmap;
    FDeviceBmp		: TBitmap;
    FFontName		: TFontName;
    FFontsType		: TFontsType;
    FNoFonts		: TStringList;
    FPreview		: TPreview;
    FHintWindow		: TSTHintWindow;
    FBitmap		: TBitmap;
    FBmpWidth		: Integer;
    procedure SetFontName (Value: TFontName);
    procedure SetFontsType (Value: TFontsType);
    procedure SetNoFonts (Value: TStringList);
    procedure UpdateHeight;
    procedure NoFontsChanged (Sender: TObject);
    procedure CMFontChanged (var Message: TMessage); message CM_FONTCHANGED;
  protected
    procedure DrawItem (Index: Integer; Rect: TRect; State: TOwnerDrawState); override;
    procedure Click; override;
  public
    constructor Create (AOwner: TComponent); override;
    procedure CreateWnd; override;
    procedure Loaded; override;
    destructor Destroy; override;
    procedure SetTrueTypeBmp (Value: TBitmap);
    procedure SetRasterBmp (Value: TBitmap);
    procedure SetDeviceBmp (Value: TBitmap);
  published
    property FontName		: TFontName read FFontName write SetFontName;
    property FontsType		: TFontsType read FFontsType write SetFontsType default [TrueTypeFonts, RasterFonts, DeviceFonts, OtherFonts];
    property TrueTypeBmp	: TBitmap read FTrueTypeBmp write SetTrueTypeBmp;
    property RasterBmp		: TBitmap read FRasterBmp write SetRasterBmp;
    property DeviceBmp		: TBitmap read FDeviceBmp write SetDeviceBmp;
    property NoFonts		: TStringList read FNoFonts write SetNoFonts;
    property Preview		: TPreview read FPreview write FPreview;
    procedure UpdateFonts;
    {$IFDEF ST4}
    property Anchors;
    property BiDiMode;
    property Constraints;
    property DragKind;
    property ParentBiDiMode;
    property OnEndDock;
    property OnStartDock;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    {$ENDIF}
    {$IFDEF ST5}
    property OnContextPopup;
    {$ENDIF}
    {$IFNDEF VER90}
    property ImeMode;
    property ImeName;
    {$ENDIF}
    property Align;
    property BorderStyle;
    property Color;
    property Columns;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property Enabled;
    property ExtendedSelect;
    property Font;
    property IntegralHeight;
    property MultiSelect;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;                                         
    property OnStartDrag;
  end;

{$R TSVFontBox.RES}

implementation

function GetItemHeight (Font: TFont): Integer;
var
  DC		: HDC;
  Fnt		: HFont;
  Metrics	: TTextMetric;
begin
  DC := GetDC (0);
  try
    Fnt := SelectObject (DC, Font.Handle);
    GeTTextMetrics (DC, Metrics);
    SelectObject (DC, Fnt);
  finally
    ReleaseDC (0, DC);
  end;
  Result := Metrics.tmHeight + 1;
end;

procedure TSTHintWindow.Paint;
var
  R: TRect;
begin
  inherited;
  R := ClientRect;
  Inc (R.Left, 2);
  Inc (R.Top, 2);
  DrawText (Canvas.Handle, PChar(Caption), -1, R, DT_Left or DT_NOPREFIX or
            DT_WORDBREAK or DrawTextBiDiModeFlagsReadingOnly);

end;

constructor TTSVFontBox.Create (AOwner: TComponent);
begin
  inherited Create (AOwner);
  FHintWindow := TSTHintWindow.Create (Self);
  FHintWindow.Canvas.Font.Charset := DEFAULT_CHARSET;
  FTrueTypeBmp := TBitmap.Create;
  FRasterBmp := TBitmap.Create;
  FDeviceBmp := TBitmap.Create;
  FBitmap := TBitmap.Create;
  FTrueTypeBmp.Handle := LoadBitmap (HInstance, 'STTTF');
  FRasterBmp.Handle := LoadBitmap (HInstance, 'STFON');
  FDeviceBmp.Handle := LoadBitmap (HInstance, 'STPRN');
  FNoFonts := TStringList.Create;
  TStringList (FNoFonts).OnChange := NoFontsChanged;
  Style := csOwnerDrawFixed;
  Sorted := True;
  FPreview := TPreview.Create;
  FPreview.FVisible := True;
  FPreview.FColor := clInfoBk;
  FPreview.FFontColor := clInfoText;
  FPreview.FPosition := ppRightTop;
  FPreview.FText := TestSentence;
  FPreview.FFontSize := 10;
  FPreview.FMaxWidth := 200;
  FPreview.FMargin := 2;
  FFontsType := [TrueTypeFonts, RasterFonts, DeviceFonts,OtherFonts];
  FAutoUpdate := True;
  UpdateHeight;
end;

procedure TTSVFontBox.CreateWnd;
begin
  inherited CreateWnd;
  UpdateFonts;
end;

procedure TTSVFontBox.Loaded;
begin
  inherited Loaded;
  SetFontName (FFontName);
end;

destructor TTSVFontBox.Destroy;
begin
  FTrueTypeBmp.Free;
  FRasterBmp.Free;
  FDeviceBmp.Free;
  FNoFonts.Free;
  FBitmap.Free;
  FHintWindow.Free;
  FPreview.Free;
  inherited Destroy;
end;

procedure TTSVFontBox.NoFontsChanged (Sender: TObject);
begin
  UpdateFonts;
end;

procedure TTSVFontBox.SetNoFonts (Value: TStringList);
begin
  FNoFonts.Assign (Value);
  UpdateFonts;
end;

procedure TTSVFontBox.SetTrueTypeBmp (Value: TBitmap);
begin
  FTrueTypeBmp.Assign (Value);
  UpdateHeight;
end;

procedure TTSVFontBox.SetRasterBmp (Value: TBitmap);
begin
  FRasterBmp.Assign (Value);
  UpdateHeight;
end;

procedure TTSVFontBox.SetDeviceBmp (Value: TBitmap);
begin
  FDeviceBmp.Assign (Value);
  UpdateHeight;
end;

procedure TTSVFontBox.UpdateHeight;
var i: Integer;
begin
  i := GetItemHeight (Font);
  if FTrueTypeBmp.Height > i then i := FTrueTypeBmp.Height;
  if FRasterBmp.Height > i then i := FRasterBmp.Height;
  if FDeviceBmp.Height > i then i := FDeviceBmp.Height;
  ItemHeight := i + 2;
  Height := ItemHeight;
  FBmpWidth := FTrueTypeBmp.Width;
  if FRasterBmp.Width > FBmpWidth then FBmpWidth := FRasterBmp.Width;
  if FDeviceBmp.Width > FBmpWidth then FBmpWidth := FDeviceBmp.Width;
  RecreateWnd;
end;

procedure TTSVFontBox.CMFontChanged (var Message: TMessage);
begin
  inherited;
  UpdateHeight;
end;

procedure TTSVFontBox.CNCommand (var Message: TWMCommand);
begin
  inherited;
  case Message.NotifyCode of
    CBN_DropDown:
    begin
      if FAutoUpdate then UpdateFonts;
    end;
  end;
end;

procedure TTSVFontBox.Change;
begin
  FFontName := Items [ItemIndex];
  inherited Change;
end;

procedure TTSVFontBox.SetFontName (Value: TFontName);
var Index: integer;
begin
  Index := Items.IndexOf (Value);   
  if Index <> - 1 then
  begin
    ItemIndex := Index;
    FFontName := Value;
  end;
//  if Assigned (OnChange) then OnChange (Self);
end;

procedure TTSVFontBox.SetFontsType(Value:TFontsType);
begin
  FFontsType := Value;
  UpdateFonts;
end;

procedure TTSVFontBox.UpdateFonts;

function IsValid (Combo: TTSVFontBox; FontType: Integer): Boolean;
begin
  if (FontType and TrueTYPE_FONTTYPE) <> 0 then
  begin
    Result := TrueTypeFonts in Combo.FontsType;
  end
  else
    if (FontType and DEVICE_FONTTYPE) <> 0 then
    begin
      Result := DeviceFonts in Combo.FontsType;
    end
    else
      if (FontType and RASTER_FONTTYPE) <> 0 then
      begin
        Result := RasterFonts in Combo.FontsType;
      end
      else
        Result := OtherFonts in Combo.FontsType;
end;

function EnumFontsProc (var EnumLogFont: TEnumLogFont; var TextMetric: TNewTextMetric; 
                        FontType: Integer; Data: LPARAM): Integer; export; stdcall;
var
  FaceName: string;
begin
  FaceName := StrPas (EnumLogFont.elfLogFont.lfFaceName);
  with TTSVFontBox (Data) do
    if (Items.IndexOf (FaceName) = - 1)
        and (IsValid (TTSVFontBox (Data), FontType))
             and (NoFonts.IndexOf (FaceName) = - 1) then
    begin
      Items.AddObject (FaceName, TObject (FontType));
    end;
  Result := 1;
end;

var
  DC	: HDC;
  Old	: string;
  Index	: integer;
begin
  if not HandleAllocated then Exit;
  if Items.Count <> 0 then Old := Items [ItemIndex];
  Items.BeginUpdate;
  try
    Clear;
    DC := GetDC (0);
    try
      EnumFontFamilies (DC, nil, @EnumFontsProc, Longint (Self));
      try
        EnumFontFamilies (Printer.Handle, nil, @EnumFontsProc, Longint (Self));
      except
      end;
    finally
      ReleaseDC (0, DC);
    end;
  finally
    Items.EndUpdate;
  end;
  Index := Items.IndexOf (Old);
  if Index <> - 1 then ItemIndex := Index
  else
  begin
    if Items.Count <> 0 then
    begin
      ItemIndex := 0;
      SetFontName ( Items [ItemIndex]);
    end;
  end;
  if Items.Count <> 0 then SetFontName (Items [ItemIndex]);
end;

procedure TTSVFontBox.DrawItem (Index: Integer; Rect: TRect; State: TOwnerDrawState);
var FontType			: Integer;
    HintRect,ItemRect, 
    BitmapRect			: TRect;
    Pos				: TPoint;
    s				: string;
begin
  if (DroppedDown) and (FPreview.FVisible) then
  begin
    s := FPreview.FText;
    if s = '%1' then s := Items [ItemIndex];
    FHintWindow.Canvas.Font.Name := Items [ItemIndex];
    FHintWindow.Canvas.Font.Size := FPreview.FFontSize;
    FHintWindow.Canvas.Font.Color := FPreview.FFontColor;
    FHintWindow.Canvas.Font.Style := FPreview.FFontStyle;
    FHintWindow.Color := FPreview.FColor;
    HintRect := FHintWindow.CalcHintRect (FPreview.FMaxWidth, s, nil);
    case FPreview.Position of
      ppLeftTop: Pos := ClientToScreen (Point (0 - (HintRect.Right - HintRect.Left) - FPreview.FMargin, 0));
      ppLeftBottom: Pos := ClientToScreen (Point (0 - (HintRect.Right - HintRect.Left) - FPreview.FMargin,Height));
      ppRightTop: Pos := ClientToScreen (Point (Width + FPreview.FMargin, 0));
      ppRightBottom: Pos := ClientToScreen (Point (Width + FPreview. FMargin, Height));
    end;
    OffsetRect (HintRect, Pos.X, Pos.Y);
    FHintWindow.ActivateHint (HintRect, s);
  end
  else
  begin
    FHintWindow.ReleaseHandle;
  end;
  FBitmap.Assign (nil);
  Canvas.FillRect (Rect);
  FontType := Integer (Items.Objects [Index]);
  if (FontType and TrueTYPE_FONTTYPE) <> 0 then FBitmap.Assign (FTrueTypeBmp)
  else
    if (FontType and DEVICE_FONTTYPE) <> 0 then FBitmap.Assign (FDeviceBmp)
    else
      if (FontType and RASTER_FONTTYPE) <> 0 then FBitmap.Assign (FRasterBmp);
  ItemRect := Bounds (Rect.Left + 2, (Rect.Top + Rect.Bottom - FBitmap.Height) div 2, FBitmap.Width, FBitmap.Height);
  BitmapRect := Bounds (0, 0, FBitmap.Width, FBitmap.Height);
  Canvas.BrushCopy (ItemRect, FBitmap, BitmapRect, FBitmap.TransParentColor);
  Rect.Left := Rect.Left + FBmpWidth + 4;
  Canvas.Font.Name:=Items [Index];
  DrawText (Canvas.Handle, PChar (Items [Index]), Length (Items [Index]),
           Rect, DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX);
end;

constructor TTSVFontList.Create (AOwner: TComponent);
begin
  inherited Create (AOwner);
  FHintWindow := TSTHintWindow.Create (Self);
  FHintWindow.Canvas.Font.Charset := DEFAULT_CHARSET;
  FTrueTypeBmp := TBitmap.Create;
  FRasterBmp := TBitmap.Create;
  FDeviceBmp := TBitmap.Create;
  FBitmap := TBitmap.Create;
  FTrueTypeBmp.Handle := LoadBitmap (HInstance, 'STTTF');
  FRasterBmp.Handle := LoadBitmap (HInstance, 'STFON');
  FDeviceBmp.Handle := LoadBitmap (HInstance, 'STPRN');
  FNoFonts := TStringList.Create;
  TStringList (FNoFonts).OnChange := NoFontsChanged;
  Style := lbOwnerDrawFixed;
  Sorted := True;
  FPreview := TPreview.Create;
  FPreview.FVisible := True;
  FPreview.FColor := clInfoBk;
  FPreview.FFontColor := clInfoText;
  FPreview.FPosition := ppRightTop;
  FPreview.FText := TestSentence;
  FPreview.FFontSize := 10;
  FPreview.FMaxWidth := 200;
  FPreview.FMargin := 2;
  FFontsType := [TrueTypeFonts, RasterFonts, DeviceFonts,OtherFonts];
  UpdateHeight;
end;

procedure TTSVFontList.CreateWnd;
begin
  inherited CreateWnd;
  UpdateFonts;
end;

procedure TTSVFontList.Loaded;
begin
  inherited Loaded;
  SetFontName (FFontName);
end;

destructor TTSVFontList.Destroy;
begin
  FTrueTypeBmp.Free;
  FRasterBmp.Free;
  FDeviceBmp.Free;
  FNoFonts.Free;
  FBitmap.Free;
  FHintWindow.Free;
  FPreview.Free;
  inherited Destroy;
end;

procedure TTSVFontList.NoFontsChanged (Sender: TObject);
begin
  UpdateFonts;
end;

procedure TTSVFontList.SetNoFonts (Value: TStringList);
begin
  FNoFonts.Assign (Value);
  UpdateFonts;
end;

procedure TTSVFontList.SetTrueTypeBmp (Value: TBitmap);
begin
  FTrueTypeBmp.Assign(Value);
  UpdateHeight;
end;

procedure TTSVFontList.SetRasterBmp (Value: TBitmap);
begin
  FRasterBmp.Assign (Value);
  UpdateHeight;
end;

procedure TTSVFontList.SetDeviceBmp (Value: TBitmap);
begin
  FDeviceBmp.Assign (Value);
  UpdateHeight;
end;

procedure TTSVFontList.UpdateHeight;
var i: Integer;
begin
  i := GetItemHeight (Font);
  if FTrueTypeBmp.Height > i then i := FTrueTypeBmp.Height;
  if FRasterBmp.Height > i then i := FRasterBmp.Height;
  if FDeviceBmp.Height > i then i := FDeviceBmp.Height;
  ItemHeight := i + 2;
  FBmpWidth := FTrueTypeBmp.Width;
  if FRasterBmp.Width > FBmpWidth then FBmpWidth := FRasterBmp.Width;
  if FDeviceBmp.Width > FBmpWidth then FBmpWidth := FDeviceBmp.Width;
  RecreateWnd;
end;

procedure TTSVFontList.CMFontChanged (var Message: TMessage);
begin
  inherited;
  UpdateHeight;
end;

procedure TTSVFontList.Click;
begin
  FFontName := Items [ItemIndex];
  inherited Click;
end;

procedure TTSVFontList.SetFontName (Value: TFontName);
var Index: integer;
begin
  Index := Items.IndexOf (Value);   
  if Index <> - 1 then
  begin
    ItemIndex := Index;
    FFontName := Value;
  end;
//  if Assigned (OnClick) then OnClick (Self);
end;

procedure TTSVFontList.SetFontsType (Value: TFontsType);
begin
  FFontsType := Value;
  UpdateFonts;
end;

procedure TTSVFontList.UpdateFonts;

function IsValid (Combo: TTSVFontList;FontType:Integer): Boolean;
begin
  if (FontType and TrueTYPE_FONTTYPE) <> 0 then
  begin
    Result := TrueTypeFonts in Combo.FontsType;
  end
  else
    if (FontType and DEVICE_FONTTYPE) <> 0 then
    begin
      Result := DeviceFonts in Combo.FontsType;
    end
    else
      if (FontType and RASTER_FONTTYPE) <> 0 then
      begin
        Result := RasterFonts in Combo.FontsType;
      end
      else
        Result := OtherFonts in Combo.FontsType;
end;

function EnumFontsProc (var EnumLogFont: TEnumLogFont; var TextMetric: TNewTextMetric;
                        FontType: Integer; Data: LPARAM): Integer;
  export; stdcall;
var
  FaceName  : string;
begin
  FaceName := StrPas (EnumLogFont.elfLogFont.lfFaceName);
  with TTSVFontList (Data) do
    if (Items.IndexOf (FaceName) = - 1)
        and (IsValid (TTSVFontList (Data), FontType))
             and (NoFonts.IndexOf (FaceName) = - 1) then
    begin
      Items.AddObject (FaceName, TObject (FontType));
    end;
  Result := 1;
end;

var
  DC	: HDC;
  Old	: string;
  Index	: integer;
begin
  if not HandleAllocated then Exit;
  if Items.Count <> 0 then Old := Items [ItemIndex];
  Items.BeginUpdate;
  try
    Clear;
    DC := GetDC (0);
    try
      EnumFontFamilies (DC, nil, @EnumFontsProc, Longint (Self));
      try
        EnumFontFamilies (Printer.Handle, nil, @EnumFontsProc, Longint (Self));
      except
      end;
    finally
      ReleaseDC (0, DC);
    end;
  finally
    Items.EndUpdate;
  end;
  Index := Items.IndexOf (Old);
  if Index <> - 1 then ItemIndex := Index
  else
  begin
    if Items.Count <> 0 then
    begin
      ItemIndex := 0;
      SetFontName ( Items [ItemIndex]);
    end;
  end;
  if Items.Count <> 0 then SetFontName (Items [ItemIndex]);
end;

procedure TTSVFontList.DrawItem (Index: Integer; Rect: TRect; State: TOwnerDrawState);
var FontType, H, W	: Integer;
    HintRect, ItemRect,
    BitmapRect		: TRect;
    Pos			: TPoint;
    s			: string;
begin
  if (Focused) and (FPreview.FVisible) then
  begin
    s := FPreview.FText;
    if s = '%1' then s := Items [ItemIndex];
    FHintWindow.Canvas.Font.Name := Items [ItemIndex];
    FHintWindow.Canvas.Font.Size := FPreview.FFontSize;
    FHintWindow.Canvas.Font.Color := FPreview.FFontColor;
    FHintWindow.Canvas.Font.Style := FPreview.FFontStyle;
    FHintWindow.Color := FPreview.FColor;
    HintRect := FHintWindow.CalcHintRect (FPreview.FMaxWidth, s, nil);
    if BorderStyle = bsNone then
    begin
      W := 0;
      H := 0;
    end
    else
    begin
      W := 2;
      H := 2;
    end;
    case FPreview.Position of
      ppLeftTop: Pos := ClientToScreen (Point (0 - (HintRect.Right - HintRect.Left) - FPreview.FMargin - w,0 - h));
      ppLeftBottom: Pos := ClientToScreen (Point (0 - (HintRect.Right - HintRect.Left) - FPreview.FMargin - w,Height - (HintRect.Bottom - HintRect.Top) - H - 4));
      ppRightTop: Pos := ClientToScreen (Point (Width + FPreview.FMargin - w,0 - h));
      ppRightBottom: Pos := ClientToScreen (Point (Width + FPreview.FMargin - w, Height - (HintRect.Bottom - HintRect.Top) - H - 4));
    end;
    OffsetRect (HintRect, Pos.X, Pos.Y);
    FHintWindow.ActivateHint (HintRect, s);
  end
  else
  begin
    FHintWindow.ReleaseHandle;
  end;
  FBitmap.Assign (nil);
  Canvas.FillRect (rect);
  FontType := Integer (Items.Objects [Index]);
  if (FontType and TRUETYPE_FONTTYPE) <> 0 then FBitmap.Assign(FTrueTypeBmp)
  else
    if (FontType and DEVICE_FONTTYPE) <> 0 then FBitmap.Assign(FDeviceBmp)
    else
      if (FontType and RASTER_FONTTYPE) <> 0 then FBitmap.Assign(FRasterBmp);
  ItemRect := Bounds (Rect.Left + 2, (Rect.Top + Rect.Bottom - FBitmap.Height) div 2, FBitmap.Width, FBitmap.Height);
  BitmapRect := Bounds (0, 0, FBitmap.Width, FBitmap.Height);
  Canvas.BrushCopy (ItemRect, FBitmap, BitmapRect, FBitmap.TransParentColor);
  Rect.Left := Rect.Left + FBmpWidth + 4;
  Canvas.Font.Name:=Items [Index];
  DrawText (Canvas.Handle, PChar (Items [Index]), Length (Items [Index]),
           Rect, DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX);
end;

end.
