unit tsvListBox;

interface

uses Windows, Messages, Classes, Controls, Graphics, ComCtrls, stdctrls, Imglist, Forms;

type


  TtsvListBoxItemCaption=class(TCollectionItem)
    private
      FAutoSize: Boolean;
      FAlignment: TAlignment;
      FCaption: string;
      FWidth: Integer;
      FFont: TFont;
      FBrush: TBrush;
      FPen: TPen;
      procedure SetAutoSize(Value: Boolean);
      procedure SetAlignment(Value: TAlignment);
      procedure SetWidth(Value: Integer);
      procedure SetFont(Value: TFont);
      procedure SetBrush(Value: TBrush);
      procedure SetPen(Value: TPen);
      procedure SetCaption(Value: string);
    public
      constructor Create(Collection: TCollection); override;
      destructor Destroy;override;
    published
      property AutoSize: Boolean read FAutoSize write SetAutoSize;
      property Alignment: TAlignment read FAlignment write SetAlignment;
      property Caption: String read FCaption write SetCaption;
      property Width: Integer read FWidth write SetWidth;
      property Font: TFont read FFont write SetFont;
      property Brush: TBrush read FBrush write SetBrush;
      property Pen: TPen read Fpen write SetPen;
  end;

  TtsvListBoxItemCaptionClass=class of TtsvListBoxItemCaption;
  TtsvListBoxItem=class;

  TtsvListBoxItemCaptions=class(TCollection)
  private
    FListBoxItem: TtsvListBoxItem;
    function GetListBoxItemCaption(Index: Integer): TtsvListBoxItemCaption;
    procedure SetListBoxItemCaption(Index: Integer; Value: TtsvListBoxItemCaption);
  protected
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TtsvListBoxItem; tsvListBoxItemCaptionClass: TtsvListBoxItemCaptionClass);
    function  Add: TtsvListBoxItemCaption;
    procedure Clear;
    procedure Delete(Index: Integer);
    function Insert(Index: Integer): TtsvListBoxItemCaption;
    property Items[Index: Integer]: TtsvListBoxItemCaption read GetListBoxItemCaption write SetListBoxItemCaption;
  end;

  TtsvListBoxItem=class(TCollectionItem)
  private
    FImageIndex: TImageIndex;
    FCaption: String;
    FCaptionEx: TtsvListBoxItemCaptions;
    FFont: TFont;
    FBrush: TBrush;
    FPen: TPen;
    FVisible: Boolean;
    procedure SetImageIndex(Value: TImageIndex);
    procedure SetCaption(Value: string);
    procedure SetFont(Value: TFont);
    procedure SetBrush(Value: TBrush);
    procedure SetPen(Value: TPen);
    procedure SetVisible(Value: Boolean);
    procedure SetCaptionEx(Value: TtsvListBoxItemCaptions);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy;override;
  published
    property Caption: String read FCaption write SetCaption;
    property CaptionEx: TtsvListBoxItemCaptions read FCaptionEx write SetCaptionEx;
    property ImageIndex: TImageIndex read FImageIndex write SetImageIndex;
    property Font: TFont read FFont write SetFont;
    property Brush: TBrush read FBrush write SetBrush;
    property Pen: TPen read Fpen write SetPen;
    property Visible: Boolean read FVisible write SetVisible;
  end;

  TtsvListBoxItemClass=class of TtsvListBoxItem;

  TtsvListBox=class;
  
  TtsvListBoxItems=class(TCollection)
  private
    FListBox: TtsvListBox;
    function GetListBoxItem(Index: Integer): TtsvListBoxItem;
    procedure SetListBoxItem(Index: Integer; Value: TtsvListBoxItem);
  protected
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TtsvListBox; tsvListBoxItemClass: TtsvListBoxItemClass);
    destructor Destroy; override;
    function  Add: TtsvListBoxItem;
    procedure Assign(Source: TPersistent); override;
    procedure BeginUpdate; override;
    procedure Clear;
    procedure Delete(Index: Integer);
    procedure EndUpdate; override;
    function Insert(Index: Integer): TtsvListBoxItem;
    property ListBox: TtsvListBox read FListBox;
    property Items[Index: Integer]: TtsvListBoxItem read GetListBoxItem write SetListBoxItem;
  end;

  TtsvListBox=class(TCustomListBox)
    private
     FDefItemHeight: Integer;
     FImages: TCustomImageList;
     FItemsEx: TtsvListBoxItems;
     procedure SetImages(Value: TCustomImageList);
     procedure SetItemsEx(Value: TtsvListBoxItems);

     procedure WMSize(var Message: TMessage); message WM_SIZE;
    protected
     procedure Notification(AComponent: TComponent; Operation: TOperation); override;
     procedure DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState);override;
    public
     constructor Create(AOwner: TComponent);override;
     destructor Destroy;override;
     procedure Clear;
    published
     property Align;
     property Anchors;
     property BiDiMode;
     property BorderStyle;
     property Color;
     property Constraints;
     property Ctl3D;
     property DragCursor;
     property DragKind;
     property DragMode;
     property Enabled;
     property ExtendedSelect;
     property Font;
     property ImeMode;
     property ImeName;
     property IntegralHeight;
     property Images: TCustomImageList read FImages write SetImages;
     property ItemHeight;
     property ItemsEx: TtsvListBoxItems read FItemsEx write SetItemsEx;
     property MultiSelect;
     property ParentBiDiMode;
     property ParentColor;
     property ParentCtl3D;
     property ParentFont;
     property ParentShowHint;
     property PopupMenu;
     property ShowHint;
     property TabOrder;
     property TabStop;
     property TabWidth;
     property Visible;
     property OnClick;
     property OnContextPopup;
     property OnDblClick;
     property OnDragDrop;
     property OnDragOver;
     property OnDrawItem;
     property OnEndDock;
     property OnEndDrag;
     property OnEnter;
     property OnExit;
     property OnKeyDown;
     property OnKeyPress;
     property OnKeyUp;
     property OnMeasureItem;
     property OnMouseDown;
     property OnMouseMove;
     property OnMouseUp;
     property OnStartDock;
     property OnStartDrag;
  end;

implementation

uses SysUtils, Dialogs;

{ TtsvListBoxItemCaption }

constructor TtsvListBoxItemCaption.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FFont := TFont.Create;
  FBrush:= TBrush.Create;
  FPen:=TPen.Create;
  FWidth:=50;
end;

destructor TtsvListBoxItemCaption.Destroy;
begin
  FFont.Free;
  FBrush.Free;
  FPen.Free;
  Inherited Destroy;
end;

procedure TtsvListBoxItemCaption.SetAlignment(Value: TAlignment);
begin
  if Value<>FAlignment then begin
    FAlignment:=Value;
    TtsvListBoxItems(TtsvListBoxItemCaptions(Collection).FListBoxItem.Collection).FListBox.Invalidate;
  end;  
end;

procedure TtsvListBoxItemCaption.SetWidth(Value: Integer);
begin
  if Value<>FWidth then begin
    FWidth:=Value;
    TtsvListBoxItems(TtsvListBoxItemCaptions(Collection).FListBoxItem.Collection).FListBox.Invalidate;
  end;
end;

procedure TtsvListBoxItemCaption.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
  TtsvListBoxItems(TtsvListBoxItemCaptions(Collection).FListBoxItem.Collection).FListBox.Invalidate;
end;

procedure TtsvListBoxItemCaption.SetBrush(Value: TBrush);
begin
  FBrush.Assign(Value);
  TtsvListBoxItems(TtsvListBoxItemCaptions(Collection).FListBoxItem.Collection).FListBox.Invalidate;
end;

procedure TtsvListBoxItemCaption.SetPen(Value: TPen);
begin
  FPen.Assign(Value);
  TtsvListBoxItems(TtsvListBoxItemCaptions(Collection).FListBoxItem.Collection).FListBox.Invalidate;
end;

procedure TtsvListBoxItemCaption.SetCaption(Value: String);
begin
  if Value<>FCaption then begin
    FCaption:=Value;
    TtsvListBoxItems(TtsvListBoxItemCaptions(Collection).FListBoxItem.Collection).FListBox.Invalidate;
  end;  
end;

procedure TtsvListBoxItemCaption.SetAutoSize(Value: Boolean);
begin
  if Value<>FAutoSize then begin
    FAutoSize:=Value;
    TtsvListBoxItems(TtsvListBoxItemCaptions(Collection).FListBoxItem.Collection).FListBox.Invalidate;
  end;  
end;

{ TtsvListBoxItemCaptions }

constructor TtsvListBoxItemCaptions.Create(AOwner: TtsvListBoxItem; tsvListBoxItemCaptionClass: TtsvListBoxItemCaptionClass);
begin
  inherited Create(tsvListBoxItemCaptionClass);
  FListBoxItem := AOwner;
end;

function TtsvListBoxItemCaptions.GetListBoxItemCaption(Index: Integer): TtsvListBoxItemCaption;
begin
  Result := TtsvListBoxItemCaption(inherited Items[Index]);
end;

procedure TtsvListBoxItemCaptions.SetListBoxItemCaption(Index: Integer; Value: TtsvListBoxItemCaption);
begin
  Items[Index].Assign(Value);
end;

function TtsvListBoxItemCaptions.GetOwner: TPersistent;
begin
  Result := FListBoxItem;
end;

procedure TtsvListBoxItemCaptions.Update(Item: TCollectionItem);
begin
  if (FListBoxItem = nil)  then Exit;
end;

function TtsvListBoxItemCaptions.Add: TtsvListBoxItemCaption;
begin
  Result := TtsvListBoxItemCaption(inherited Add);
end;

procedure TtsvListBoxItemCaptions.Clear;
begin
  inherited Clear;
end;

procedure TtsvListBoxItemCaptions.Delete(Index: Integer);
begin
  inherited Delete(Index);
end;

function TtsvListBoxItemCaptions.Insert(Index: Integer): TtsvListBoxItemCaption;
begin
  Result:=TtsvListBoxItemCaption(inherited Insert(Index));
end;

{ TtsvListBoxItem }

constructor TtsvListBoxItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  TtsvListBoxItems(Collection).FListBox.Items.Add('');
  FCaptionEx:=TtsvListBoxItemCaptions.Create(Self,TtsvListBoxItemCaption);
  FFont := TFont.Create;
  FBrush:= TBrush.Create;
  FPen:=TPen.Create;
  FVisible:=true;
  FImageIndex:=-1; 
end;

destructor TtsvListBoxItem.Destroy;
begin
  FFont.Free;
  FBrush.Free;
  FPen.Free;
  FCaptionEx.Free;
  Inherited Destroy;
end;

procedure TtsvListBoxItem.SetImageIndex(Value: TImageIndex);
begin
  if Value<>FImageIndex then begin
    FImageIndex:=Value;
    TtsvListBoxItems(Collection).FListBox.Invalidate;
  end;
end;

procedure TtsvListBoxItem.SetCaption(Value: String);
begin
  if Value<>FCaption then begin
    FCaption:=Value;
    TtsvListBoxItems(Collection).FListBox.Items[Index]:=Value;
  end;
end;

procedure TtsvListBoxItem.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
  TtsvListBoxItems(Collection).FListBox.Invalidate;
end;

procedure TtsvListBoxItem.SetBrush(Value: TBrush);
begin
  FBrush.Assign(Value);
  TtsvListBoxItems(Collection).FListBox.Invalidate;
end;

procedure TtsvListBoxItem.SetPen(Value: TPen);
begin
  FPen.Assign(Value);
  TtsvListBoxItems(Collection).FListBox.Invalidate;
end;

procedure TtsvListBoxItem.SetVisible(Value: Boolean);
begin
  if Value<>FVisible then begin
    if Value then begin
      FVisible:=Value;
    end else begin
      FVisible:=Value;
    end;
  end;
end;

procedure TtsvListBoxItem.SetCaptionEx(Value: TtsvListBoxItemCaptions);
begin
  FCaptionEx.Assign(Value);
  TtsvListBoxItems(Collection).FListBox.Invalidate;
end;

{ TtsvListBoxItems }

constructor TtsvListBoxItems.Create(AOwner: TtsvListBox; tsvListBoxItemClass: TtsvListBoxItemClass);
begin
  inherited Create(tsvListBoxItemClass);
  FListBox := AOwner;
end;

destructor TtsvListBoxItems.Destroy;
begin
//  FListBox.Items.Clear;
  inherited Destroy;
end;

function TtsvListBoxItems.GetListBoxItem(Index: Integer): TtsvListBoxItem;
begin
  Result := TtsvListBoxItem(inherited Items[Index]);
end;

procedure TtsvListBoxItems.SetListBoxItem(Index: Integer; Value: TtsvListBoxItem);
begin
  Items[Index].Assign(Value);
end;

function TtsvListBoxItems.GetOwner: TPersistent;
begin
  Result := FListBox;
end;

procedure TtsvListBoxItems.Update(Item: TCollectionItem);
begin
  if (FListBox = nil) or (csLoading in FListBox.ComponentState) then Exit;
end;

function TtsvListBoxItems.Add: TtsvListBoxItem;
begin
  Result := TtsvListBoxItem(inherited Add);
end;

procedure TtsvListBoxItems.Clear;
begin
  FListBox.Items.Clear;
  inherited Clear;
end;

procedure TtsvListBoxItems.Assign(Source: TPersistent);
begin
end;

procedure TtsvListBoxItems.Delete(Index: Integer);
begin
  FListBox.Items.Delete(Index);
  Inherited Delete(Index);
end;

function TtsvListBoxItems.Insert(Index: Integer): TtsvListBoxItem;
begin
  FListBox.Items.Insert(Index,'');
  Result:=TtsvListBoxItem(Inherited Insert(Index));
end;

procedure TtsvListBoxItems.BeginUpdate;
begin
//  FListBox.Items.BeginUpdate;
  inherited BeginUpdate;
end;

procedure TtsvListBoxItems.EndUpdate;
begin
//  FListBox.Items.EndUpdate;
  inherited EndUpdate;
end;

{ TtsvListBox }

constructor TtsvListBox.Create(AOwner: TComponent);
begin
  Inherited Create(AOwner);
  FItemsEx:=TtsvListBoxItems.Create(Self,TtsvListBoxItem);
  Style:=lbOwnerDrawFixed;
  FDefItemHeight:=16;
end;

destructor TtsvListBox.Destroy;
begin
  FreeAndNil(FItemsEx);
  Inherited Destroy;
end;

procedure TtsvListBox.SetImages(Value: TCustomImageList);
begin
  FImages := Value;
  if Images <> nil then begin
    ItemHeight:=Images.Height+4;
    Invalidate;
  end else begin
    ItemHeight:=FDefItemHeight;
  end;
end;

procedure TtsvListBox.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then begin
    if AComponent = Images then Images := nil;
  end;
end;

procedure TtsvListBox.DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  Flags: Longint;
  OldRect: TRect;
  xImage,yImage: Integer;
  oldBrush: TBrush;
  oldFont: TFont;
  oldPen: TPen;
  CurItemEx: TtsvListBoxItem;
  CurCaptionEx: TtsvListBoxItemCaption;
  i: Integer;
begin
  if Assigned(OnDrawItem) then
    OnDrawItem(Self, Index, Rect, State)
  else begin
   if FItemsEx=nil then exit;
   
   oldBrush:=TBrush.Create;
   oldFont:=TFont.Create;
   oldPen:=TPen.Create;
   try

    oldBrush.Assign(Canvas.Brush);
    oldFont.Assign(Canvas.Font);
    oldPen.Assign(Canvas.Pen);

    CurItemEx:=FItemsEx.Items[Index];
    if CurItemEx=nil then exit;

//    CurItemEx:=FItemsEx.Items[CurItemEx.RealDrawIndex];

    Canvas.Brush.Assign(CurItemEx.Brush);
    Canvas.Font.Assign(CurItemEx.Font);
    Canvas.Pen.Assign(CurItemEx.Pen);
    Canvas.FillRect(Rect);

    if (odSelected in State) then begin
      Canvas.Brush.Color := clHighlight;
      Canvas.Font.Color := clHighlightText;
      Canvas.FillRect(Rect);
    end;

    if Index<Items.Count then begin

      OldRect:=Rect;

      Flags := DrawTextBiDiModeFlags(DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX);
      if not UseRightToLeftAlignment then Inc(Rect.Left, 2)
      else Dec(Rect.Right, 2);

      if FImages<>nil then begin
        xImage:=Rect.Left;
        yImage:=Rect.Top+2;
        FImages.Draw(Canvas,xImage,yImage,CurItemEx.ImageIndex,true);
        Inc(Rect.Left, FImages.Width+4);
      end;

      if CurItemEx.CaptionEx.Count>0 then begin

        for i:=0 to CurItemEx.CaptionEx.Count-1 do begin

          CurCaptionEx:=CurItemEx.CaptionEx.Items[i];

          Canvas.Brush.Assign(CurCaptionEx.Brush);
          Canvas.Font.Assign(CurCaptionEx.Font);
          Canvas.Pen.Assign(CurCaptionEx.Pen);
          
          if i=CurItemEx.CaptionEx.Count-1 then
           Rect.Right:=OldRect.Right
          else begin
           if CurCaptionEx.AutoSize then
            Rect.Right:=Rect.Left+Canvas.TextWidth(CurCaptionEx.Caption)
           else
            Rect.Right:=Rect.Left+CurCaptionEx.Width;
          end;

          Canvas.FillRect(Rect);

          if (odSelected in State) then begin
            Canvas.Brush.Color := clHighlight;
            Canvas.Font.Color := clHighlightText;
            Canvas.FillRect(Rect);
          end;

          case CurCaptionEx.Alignment of
            taLeftJustify:  Flags := DrawTextBiDiModeFlags(DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX or DT_LEFT);
            taRightJustify: Flags := DrawTextBiDiModeFlags(DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX or DT_RIGHT);
            taCenter:       Flags := DrawTextBiDiModeFlags(DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX or DT_CENTER);
          end;
          
          DrawText(Canvas.Handle, PChar(CurCaptionEx.Caption), Length(CurCaptionEx.Caption), Rect, Flags);
          Rect.Left:=Rect.Right;
        end;

      end else begin
       DrawText(Canvas.Handle, PChar(CurItemEx.Caption), Length(CurItemEx.Caption), Rect, Flags);
      end;

     end; 
    finally
     Canvas.Brush.Assign(oldBrush);
     Canvas.Font.Assign(oldFont);
     Canvas.Pen.Assign(oldPen);
     oldBrush.Free;
     oldFont.Free;
     oldPen.Free;
    end;
  end;
end;

procedure TtsvListBox.SetItemsEx(Value: TtsvListBoxItems);
begin
  FItemsEx.Assign(Value);
end;

procedure TtsvListBox.Clear;
begin
  Items.Clear;
  FItemsEx.Clear;
end;

procedure TtsvListBox.WMSize(var Message: TMessage); 
begin
  Invalidate;
  Inherited;
end;

end.

