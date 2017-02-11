unit tsvDbImage;

interface

uses Windows, Messages, Classes, Controls, Forms, db, dbctrls, tsvPicture;

type

  TtsvDBImage = class(TCustomControl)
  private
    FDataLink: TFieldDataLink;
    FPicture: TtsvPicture;
    FBorderStyle: TBorderStyle;
    FAutoDisplay: Boolean;
    FStretch: Boolean;
    FCenter: Boolean;
    FPictureLoaded: Boolean;
    FQuickDraw: Boolean;
    procedure DataChange(Sender: TObject);
    function GetDataField: string;
    function GetDataSource: TDataSource;
    function GetField: TField;
    function GetReadOnly: Boolean;
    procedure PictureChanged(Sender: TObject);
    procedure SetAutoDisplay(Value: Boolean);
    procedure SetBorderStyle(Value: TBorderStyle);
    procedure SetCenter(Value: Boolean);
    procedure SetDataField(const Value: string);
    procedure SetDataSource(Value: TDataSource);
    procedure SetPicture(Value: TtsvPicture);
    procedure SetReadOnly(Value: Boolean);
    procedure SetStretch(Value: Boolean);
    procedure UpdateData(Sender: TObject);
    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure WMCut(var Message: TMessage); message WM_CUT;
    procedure WMCopy(var Message: TMessage); message WM_COPY;
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
    procedure WMSize(var Message: TMessage); message WM_SIZE;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    function GetPalette: HPALETTE; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CopyToClipboard;
    procedure CutToClipboard;
    function ExecuteAction(Action: TBasicAction): Boolean; override;
    procedure LoadPicture;
    procedure PasteFromClipboard;
    function UpdateAction(Action: TBasicAction): Boolean; override;
    property Field: TField read GetField;
    property Picture: TtsvPicture read FPicture write SetPicture;
  published
    property Align;
    property Anchors;
    property AutoDisplay: Boolean read FAutoDisplay write SetAutoDisplay default True;
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle default bsSingle;
    property Center: Boolean read FCenter write SetCenter default True;
    property Color;
    property Constraints;
    property Ctl3D;
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ParentColor default False;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property QuickDraw: Boolean read FQuickDraw write FQuickDraw default True;
    property ShowHint;
    property Stretch: Boolean read FStretch write SetStretch default False;
    property TabOrder;
    property TabStop default True;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;


implementation

uses graphics, clipbrd;

const
  EmptyImage='Нет картинки';

constructor TtsvDBImage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csOpaque, csReplicatable];
  if not NewStyleControls then ControlStyle := ControlStyle + [csFramed];
  Width := 105;
  Height := 105;
  TabStop := True;
  ParentColor := False;
  FPicture := TtsvPicture.Create;
  FPicture.OnChange := PictureChanged;
  FBorderStyle := bsSingle;
  FAutoDisplay := True;
  FCenter := True;
  FDataLink := TFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnUpdateData := UpdateData;
  FQuickDraw := True;
end;

destructor TtsvDBImage.Destroy;
begin
  FPicture.Free;
  FDataLink.Free;
  FDataLink := nil;
  inherited Destroy;
end;

function TtsvDBImage.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TtsvDBImage.SetDataSource(Value: TDataSource);
begin
  if not (FDataLink.DataSourceFixed and (csLoading in ComponentState)) then
    FDataLink.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

function TtsvDBImage.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;

procedure TtsvDBImage.SetDataField(const Value: string);
begin
  FDataLink.FieldName := Value;
end;

function TtsvDBImage.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;

procedure TtsvDBImage.SetReadOnly(Value: Boolean);
begin
  FDataLink.ReadOnly := Value;
end;

function TtsvDBImage.GetField: TField;
begin
  Result := FDataLink.Field;
end;

function TtsvDBImage.GetPalette: HPALETTE;
begin
  Result := 0;
  if FPicture.Graphic is TBitmap then
    Result := TBitmap(FPicture.Graphic).Palette;
end;

procedure TtsvDBImage.SetAutoDisplay(Value: Boolean);
begin
  if FAutoDisplay <> Value then
  begin
    FAutoDisplay := Value;
    if Value then LoadPicture;
  end;
end;

procedure TtsvDBImage.SetBorderStyle(Value: TBorderStyle);
begin
  if FBorderStyle <> Value then
  begin
    FBorderStyle := Value;
    RecreateWnd;
  end;
end;

procedure TtsvDBImage.SetCenter(Value: Boolean);
begin
  if FCenter <> Value then
  begin
    FCenter := Value;
    Invalidate;
  end;
end;

procedure TtsvDBImage.SetPicture(Value: TtsvPicture);
begin
  FPicture.Assign(Value);
end;

procedure TtsvDBImage.SetStretch(Value: Boolean);
begin
  if FStretch <> Value then
  begin
    FStretch := Value;
    Invalidate;
  end;
end;

procedure TtsvDBImage.Paint;
var
  Size: TSize;
  R: TRect;
  S: string;
  DrawPict: TtsvPicture;
  Form: TCustomForm;
  Pal: HPalette;
  HW: Extended;
  CHCW: Extended;
  NewW,NewH: Integer;
begin
  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := Color;
    FillRect(ClientRect);
    if FPictureLoaded or (csPaintCopy in ControlState) then
    begin
      DrawPict := TtsvPicture.Create;
      Pal := 0;
      try
        if (csPaintCopy in ControlState) and
          Assigned(FDataLink.Field) and FDataLink.Field.IsBlob then
        begin
          DrawPict.Assign(FDataLink.Field);
          if DrawPict.Graphic is TBitmap then
            DrawPict.Bitmap.IgnorePalette := QuickDraw;
        end
        else
        begin
          DrawPict.Assign(Picture);
          if Focused and (DrawPict.Graphic <> nil) and (DrawPict.Graphic.Palette <> 0) then
          begin { Control has focus, so realize the bitmap palette in foreground }
            Pal := SelectPalette(Handle, DrawPict.Graphic.Palette, False);
            RealizePalette(Handle);
          end;
        end;
        if Stretch then begin
          if (DrawPict.Graphic = nil) or DrawPict.Graphic.Empty then
            FillRect(ClientRect)
          else begin
            HW:=DrawPict.Height / DrawPict.Width;
            CHCW:=ClientHeight / ClientWidth;
            if HW>1 then begin
              if CHCW>1 then begin
                NewW:=ClientWidth;
                NewH:=Round(NewW/HW);
              end else begin
                NewH:=ClientHeight;
                NewW:=Round(NewH*HW);
              end;
            end else begin
              if CHCW>1 then begin
                NewW:=ClientWidth;
                NewH:=Round(NewW*HW);
              end else begin
                NewH:=ClientHeight;
                NewW:=Round(NewH/HW);
              end;
            end;
            SetRect(R, 0, 0, NewW, NewH);
            if Center then OffsetRect(R, (ClientWidth - NewW) div 2, (ClientHeight - NewH) div 2);
            StretchDraw(R, DrawPict.Graphic);

          end;
        end else  begin
          SetRect(R, 0, 0, DrawPict.Width, DrawPict.Height);
          if Center then OffsetRect(R, (ClientWidth - DrawPict.Width) div 2,
            (ClientHeight - DrawPict.Height) div 2);
          StretchDraw(R, DrawPict.Graphic);
          ExcludeClipRect(Handle, R.Left, R.Top, R.Right, R.Bottom);
          FillRect(ClientRect);
          SelectClipRgn(Handle, 0);
        end;
      finally
        if Pal <> 0 then SelectPalette(Handle, Pal, True);
        DrawPict.Free;
      end;
    end
    else begin
      Font := Self.Font;
      if FDataLink.Field <> nil then
        S := FDataLink.Field.DisplayLabel
      else S := Name;
//      S := '(' + S + ')';
      S := EmptyImage;
      Size := TextExtent(S);
      R := ClientRect;
      TextRect(R, (R.Right - Size.cx) div 2, (R.Bottom - Size.cy) div 2, S);
    end;
    Form := GetParentForm(Self);
    if (Form <> nil) and (Form.ActiveControl = Self) and
      not (csDesigning in ComponentState) and
      not (csPaintCopy in ControlState) then
    begin
      Brush.Color := clWindowFrame;
      FrameRect(ClientRect)
    end;
  end;
end;

procedure TtsvDBImage.PictureChanged(Sender: TObject);
begin
  if FPictureLoaded then FDataLink.Modified;
  FPictureLoaded := True;
  Invalidate;
end;

procedure TtsvDBImage.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

procedure TtsvDBImage.LoadPicture;
var
  ms: TMemoryStream;
begin
  if not FPictureLoaded and (not Assigned(FDataLink.Field) or
    FDataLink.Field.IsBlob) then begin
      if FDataLink.Field is TBlobField then begin
        ms:=TMemoryStream.Create;
        try
          TBlobField(FDataLink.Field).SaveToStream(ms);
          ms.Position:=0;
          Picture.LoadFromStream(ms);
        finally
          ms.Free;
        end;
      end else Picture.Assign(FDataLink.Field);
    end;
end;

procedure TtsvDBImage.DataChange(Sender: TObject);
begin
  Picture.Graphic := nil;
  FPictureLoaded := False;
  if FAutoDisplay then LoadPicture;
end;

procedure TtsvDBImage.UpdateData(Sender: TObject);
begin
  if Picture.Graphic is TBitmap then
     FDataLink.Field.Assign(Picture.Graphic) else
     FDataLink.Field.Clear;
end;

procedure TtsvDBImage.CopyToClipboard;
begin
  if Picture.Graphic <> nil then Clipboard.Assign(Picture);
end;

procedure TtsvDBImage.CutToClipboard;
begin
  if Picture.Graphic <> nil then
    if FDataLink.Edit then
    begin
      CopyToClipboard;
      Picture.Graphic := nil;
    end;
end;

procedure TtsvDBImage.PasteFromClipboard;
begin
  if Clipboard.HasFormat(CF_BITMAP) and FDataLink.Edit then
    Picture.Bitmap.Assign(Clipboard);
end;

procedure TtsvDBImage.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    if FBorderStyle = bsSingle then
      if NewStyleControls and Ctl3D then
        ExStyle := ExStyle or WS_EX_CLIENTEDGE
      else
        Style := Style or WS_BORDER;
    WindowClass.style := WindowClass.style and not (CS_HREDRAW or CS_VREDRAW);
  end;
end;

procedure TtsvDBImage.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  case Key of
    VK_INSERT:
      if ssShift in Shift then PasteFromClipBoard else
        if ssCtrl in Shift then CopyToClipBoard;
    VK_DELETE:
      if ssShift in Shift then CutToClipBoard;
  end;
end;

procedure TtsvDBImage.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  case Key of
    ^X: CutToClipBoard;
    ^C: CopyToClipBoard;
    ^V: PasteFromClipBoard;
    #13: LoadPicture;
    #27: FDataLink.Reset;
  end;
end;

procedure TtsvDBImage.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;

procedure TtsvDBImage.CMEnter(var Message: TCMEnter);
begin
  Invalidate; { Draw the focus marker }
  inherited;
end;

procedure TtsvDBImage.CMExit(var Message: TCMExit);
begin
  try
    FDataLink.UpdateRecord;
  except
    SetFocus;
    raise;
  end;
  Invalidate; { Erase the focus marker }
  inherited;
end;

procedure TtsvDBImage.CMTextChanged(var Message: TMessage);
begin
  inherited;
  if not FPictureLoaded then Invalidate;
end;

procedure TtsvDBImage.WMLButtonDown(var Message: TWMLButtonDown);
begin
  if TabStop and CanFocus then SetFocus;
  inherited;
end;

procedure TtsvDBImage.WMLButtonDblClk(var Message: TWMLButtonDblClk);
begin
  LoadPicture;
  inherited;
end;

procedure TtsvDBImage.WMCut(var Message: TMessage);
begin
  CutToClipboard;
end;

procedure TtsvDBImage.WMCopy(var Message: TMessage);
begin
  CopyToClipboard;
end;

procedure TtsvDBImage.WMPaste(var Message: TMessage);
begin
  PasteFromClipboard;
end;

procedure TtsvDBImage.WMSize(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

function TtsvDBImage.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TtsvDBImage.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

end.
