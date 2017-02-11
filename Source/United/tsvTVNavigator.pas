unit tsvTVNavigator;

interface

uses Windows, SysUtils, Messages, Classes, Controls, extctrls, graphics,
     buttons, comctrls, tsvComCtrls;

type

  TTVNavButton = class;

  TTVNavGlyph = (ngEnabled, ngDisabled);
  TTVNavigateBtn = (nbFirst, nbPrior, nbNext, nbLast,
                  nbInsert, nbDelete, nbEdit, nbPost, nbCancel, nbRefresh);
  TTVButtonSet = set of TTVNavigateBtn;
  TTVNavButtonStyle = set of (nsAllowTimer, nsFocusRect);

  ETVNavClick = procedure (Sender: TObject; Button: TTVNavigateBtn) of object;

  TTVNavigator = class (TCustomPanel)
  private
    FVisibleButtons: TTVButtonSet;
    FHints: TStrings;
    ButtonWidth: Integer;
    MinBtnSize: TPoint;
    FOnNavClick: ETVNavClick;
    FBeforeAction: ETVNavClick;
    FocusedButton: TTVNavigateBtn;
    FConfirmDelete: Boolean;
    FFlat: Boolean;
    FTreeView: TTSVCustomTreeView;
    procedure BtnMouseDown (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ClickHandler(Sender: TObject);
    function GetHints: TStrings;
    procedure HintsChanged(Sender: TObject);
    function GetTreeView: TTSVCustomTreeView;
    procedure SetTreeView(Value: TTSVCustomTreeView);
    procedure InitButtons;
    procedure InitHints;
    procedure SetFlat(Value: Boolean);
    procedure SetHints(Value: TStrings);
    procedure SetSize(var W: Integer; var H: Integer);
    procedure SetVisible(Value: TTVButtonSet);
    procedure WMSize(var Message: TWMSize);  message WM_SIZE;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure WMWindowPosChanging(var Message: TWMWindowPosChanging); message WM_WINDOWPOSCHANGING;
  protected
    Buttons: array[TTVNavigateBtn] of TTVNavButton;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    procedure CalcMinSize(var W, H: Integer);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure BtnClick(Index: TTVNavigateBtn); virtual;
    procedure SetEnableButtons;
  published
    property VisibleButtons: TTVButtonSet read FVisibleButtons write SetVisible
      default [nbFirst, nbPrior, nbNext, nbLast, nbInsert, nbDelete,
        nbEdit, nbPost, nbCancel, nbRefresh];
    property Align;
    property Anchors;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Flat: Boolean read FFlat write SetFlat default False;
    property Ctl3D;
    property Hints: TStrings read GetHints write SetHints;
    property ParentCtl3D;
    property ParentShowHint;
    property PopupMenu;
    property ConfirmDelete: Boolean read FConfirmDelete write FConfirmDelete default True;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property TreeView: TTSVCustomTreeView read GetTreeView write SetTreeView;

    property Visible;
    property BeforeAction: ETVNavClick read FBeforeAction write FBeforeAction;
    property OnClick: ETVNavClick read FOnNavClick write FOnNavClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
  end;

{ TTVNavButton }

  TTVNavButton = class(TSpeedButton)
  private
    FIndex: TTVNavigateBtn;
    FNavStyle: TTVNavButtonStyle;
    FRepeatTimer: TTimer;
    procedure TimerExpired(Sender: TObject);
  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
  public
    destructor Destroy; override;
    property NavStyle: TTVNavButtonStyle read FNavStyle write FNavStyle;
    property Index : TTVNavigateBtn read FIndex write FIndex;
  end;

implementation

{$R tsvTVNavigator.res}

uses Clipbrd, DBConsts, Dialogs, Math;

const
  InitRepeatPause = 400;  { pause before repeat timer (ms) }
  RepeatPause     = 100;  { pause before hint window displays (ms)}
  SpaceSize       =  5;   { size of space between special buttons }

resourcestring
  SFirstRecord = 'Первая запись';
  SPriorRecord = 'Предыдущая запись';
  SNextRecord = 'Следующая запись';
  SLastRecord = 'Последняя запись';
  SInsertRecord = 'Вставить запись';
  SDeleteRecord = 'Удалить запись';
  SEditRecord = 'Изменить запись';
  SPostEdit = 'Подтвердить изменения';
  SCancelEdit = 'Отменить изменения';
  SRefreshRecord = 'Обновить данные';
  
{ TTVNavigator }

var
  BtnTypeName: array[TTVNavigateBtn] of PChar = ('FIRST', 'PRIOR', 'NEXT',
    'LAST', 'INSERT', 'DELETE', 'EDIT', 'POST', 'CANCEL', 'REFRESH');
  BtnHintId: array[TTVNavigateBtn] of Pointer = (@SFirstRecord, @SPriorRecord,
    @SNextRecord, @SLastRecord, @SInsertRecord, @SDeleteRecord, @SEditRecord,
    @SPostEdit, @SCancelEdit, @SRefreshRecord);

constructor TTVNavigator.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csAcceptsControls, csSetCaption] + [csOpaque];
  if not NewStyleControls then ControlStyle := ControlStyle + [csFramed];
  FVisibleButtons := [nbFirst, nbPrior, nbNext, nbLast, nbInsert,
    nbDelete, nbEdit, nbPost, nbCancel, nbRefresh];
  FHints := TStringList.Create;
  TStringList(FHints).OnChange := HintsChanged;
  InitButtons;
  InitHints;
  BevelOuter := bvNone;
  BevelInner := bvNone;
  Width := 241;
  Height := 25;
  ButtonWidth := 0;
  FocusedButton := nbFirst;
  FConfirmDelete := True;
  FullRepaint := False;
end;

destructor TTVNavigator.Destroy;
begin
  FHints.Free;
  inherited Destroy;
end;

procedure TTVNavigator.InitButtons;
var
  I: TTVNavigateBtn;
  Btn: TTVNavButton;
  X: Integer;
  ResName: string;
begin
  MinBtnSize := Point(20, 18);
  X := 0;
  for I := Low(Buttons) to High(Buttons) do
  begin
    Btn := TTVNavButton.Create (Self);
    Btn.Flat := Flat;
    Btn.Index := I;
    Btn.Visible := I in FVisibleButtons;
    Btn.Enabled := True;
    Btn.SetBounds (X, 0, MinBtnSize.X, MinBtnSize.Y);
    FmtStr(ResName, 'TVN_%s', [BtnTypeName[I]]);
    Btn.Glyph.LoadFromResourceName(HInstance, ResName);
    Btn.NumGlyphs := 2;
    Btn.Enabled := False;
    Btn.Enabled := True;
    Btn.OnClick := ClickHandler;
    Btn.OnMouseDown := BtnMouseDown;
    Btn.Parent := Self;
    Buttons[I] := Btn;
    X := X + MinBtnSize.X;
  end;
  Buttons[nbPrior].NavStyle := Buttons[nbPrior].NavStyle + [nsAllowTimer];
  Buttons[nbNext].NavStyle  := Buttons[nbNext].NavStyle + [nsAllowTimer];
end;

procedure TTVNavigator.InitHints;
var
  I: Integer;
  J: TTVNavigateBtn;
begin
  J := Low(Buttons);
  for I := 0 to (FHints.Count - 1) do
  begin
    if FHints.Strings[I] <> '' then Buttons[J].Hint := FHints.Strings[I];
    if J = High(Buttons) then Exit;
    Inc(J);
  end;
end;

procedure TTVNavigator.HintsChanged(Sender: TObject);
begin
  InitHints;
end;

procedure TTVNavigator.SetFlat(Value: Boolean);
var
  I: TTVNavigateBtn;
begin
  if FFlat <> Value then
  begin
    FFlat := Value;
    for I := Low(Buttons) to High(Buttons) do
      Buttons[I].Flat := Value;
  end;
end;

procedure TTVNavigator.SetHints(Value: TStrings);
begin
   FHints.Assign(Value);
end;

function TTVNavigator.GetHints: TStrings;
begin
  Result := FHints;
end;

procedure TTVNavigator.GetChildren(Proc: TGetChildProc; Root: TComponent);
begin
end;

procedure TTVNavigator.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FTreeView <> nil) and
    (AComponent = FTreeView) then FTreeView := nil;
end;

procedure TTVNavigator.SetVisible(Value: TTVButtonSet);
var
  I: TTVNavigateBtn;
  W, H: Integer;
begin
  W := Width;
  H := Height;
  FVisibleButtons := Value;
  for I := Low(Buttons) to High(Buttons) do
    Buttons[I].Visible := I in FVisibleButtons;
  SetSize(W, H);
  if (W <> Width) or (H <> Height) then
    inherited SetBounds (Left, Top, W, H);
  Invalidate;
end;

procedure TTVNavigator.CalcMinSize(var W, H: Integer);
var
  Count: Integer;
  I: TTVNavigateBtn;
begin
  if (csLoading in ComponentState) then Exit;
  if Buttons[nbFirst] = nil then Exit;

  Count := 0;
  for I := Low(Buttons) to High(Buttons) do
    if Buttons[I].Visible then
      Inc(Count);
  if Count = 0 then Inc(Count);

  W := Max(W, Count * MinBtnSize.X);
  H := Max(H, MinBtnSize.Y);

  if Align = alNone then W := (W div Count) * Count;
end;

procedure TTVNavigator.SetSize(var W: Integer; var H: Integer);
var
  Count: Integer;
  I: TTVNavigateBtn;
  Space, Temp, Remain: Integer;
  X: Integer;
begin
  if (csLoading in ComponentState) then Exit;
  if Buttons[nbFirst] = nil then Exit;

  CalcMinSize(W, H);

  Count := 0;
  for I := Low(Buttons) to High(Buttons) do
    if Buttons[I].Visible then
      Inc(Count);
  if Count = 0 then Inc(Count);

  ButtonWidth := W div Count;
  Temp := Count * ButtonWidth;
  if Align = alNone then W := Temp;

  X := 0;
  Remain := W - Temp;
  Temp := Count div 2;
  for I := Low(Buttons) to High(Buttons) do
  begin
    if Buttons[I].Visible then
    begin
      Space := 0;
      if Remain <> 0 then
      begin
        Dec(Temp, Remain);
        if Temp < 0 then
        begin
          Inc(Temp, Count);
          Space := 1;
        end;
      end;
      Buttons[I].SetBounds(X, 0, ButtonWidth + Space, Height);
      Inc(X, ButtonWidth + Space);
    end
    else
      Buttons[I].SetBounds (Width + 1, 0, ButtonWidth, Height);
  end;
end;

procedure TTVNavigator.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
var
  W, H: Integer;
begin
  W := AWidth;
  H := AHeight;
  if not HandleAllocated then SetSize(W, H);
  inherited SetBounds (ALeft, ATop, W, H);
end;

procedure TTVNavigator.WMSize(var Message: TWMSize);
var
  W, H: Integer;
begin
  inherited;
  W := Width;
  H := Height;
  SetSize(W, H);
end;

procedure TTVNavigator.WMWindowPosChanging(var Message: TWMWindowPosChanging);
begin
  inherited;
  if (SWP_NOSIZE and Message.WindowPos.Flags) = 0 then
    CalcMinSize(Message.WindowPos.cx, Message.WindowPos.cy);
end;

procedure TTVNavigator.ClickHandler(Sender: TObject);
begin
  BtnClick (TTVNavButton (Sender).Index);
end;

procedure TTVNavigator.BtnMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  OldFocus: TTVNavigateBtn;
begin
  OldFocus := FocusedButton;
  FocusedButton := TTVNavButton (Sender).Index;
  if TabStop and (GetFocus <> Handle) and CanFocus then
  begin
    SetFocus;
    if (GetFocus <> Handle) then
      Exit;
  end
  else if TabStop and (GetFocus = Handle) and (OldFocus <> FocusedButton) then
  begin
    Buttons[OldFocus].Invalidate;
    Buttons[FocusedButton].Invalidate;
  end;
end;

procedure TTVNavigator.SetEnableButtons;

   var
     nd: TTreeNode;
     i: TTVNavigateBtn;
   begin
     nd:=FTreeView.Selected;
     if (nd<>nil) then begin
       Buttons[nbPrior].Enabled:=true;
       Buttons[nbFirst].Enabled:=true;
       Buttons[nbNext].Enabled:=true;
       Buttons[nbLast].Enabled:=true;

       if nd.AbsoluteIndex=0 then begin
         Buttons[nbPrior].Enabled:=false;
         Buttons[nbFirst].Enabled:=false;
       end;
       if nd.AbsoluteIndex=FTreeView.Items.Count-1 then begin
         Buttons[nbNext].Enabled:=false;
         Buttons[nbLast].Enabled:=false;
       end;
     end else begin
       for i:=Low(Buttons) to High(Buttons) do
         Buttons[i].Enabled:=false;
     end;
end;

procedure TTVNavigator.BtnClick(Index: TTVNavigateBtn);
var
  nd: TTreeNode;
begin
  if (FTreeView <> nil) then begin
    if not (csDesigning in ComponentState) and Assigned(FBeforeAction) then
      FBeforeAction(Self, Index);
      case Index of
        nbPrior: begin
         if FTReeView.Selected<>nil then begin
           nd:=FTReeView.Selected.GetPrev;
           if nd<>nil then begin
             nd.MakeVisible;
             nd.Selected:=true;
           end;
         end;
        end;
        nbNext: begin
         if FTReeView.Selected<>nil then begin
           nd:=FTReeView.Selected.GetNext;
           if nd<>nil then begin
             nd.MakeVisible;
             nd.Selected:=true;
           end;
         end;
        end;
        nbFirst: begin
         if FTReeView.Items.Count>0 then begin
          nd:=FTReeView.Items[0];
          if nd<>nil then begin
           nd.MakeVisible;
           nd.Selected:=true;
          end;
         end; 
        end;
        nbLast: begin
         if FTReeView.Items.Count>0 then begin
          nd:=FTReeView.Items[FTReeView.Items.Count-1];
          if nd<>nil then begin
           nd.MakeVisible;
           nd.Selected:=true;
          end;
         end;
        end;
        nbInsert: ;
        nbEdit: ;
        nbCancel: ;
        nbPost: ;
        nbRefresh: ;
        nbDelete: begin
{          if not FConfirmDelete or
            (MessageDlg(SDeleteRecordQuestion, mtConfirmation,
            mbOKCancel, 0) <> idCancel) then Delete;}
        end;
    end;
    SetEnableButtons;
  end;
  if not (csDesigning in ComponentState) and Assigned(FOnNavClick) then
    FOnNavClick(Self, Index);
end;

procedure TTVNavigator.WMSetFocus(var Message: TWMSetFocus);
begin
  Buttons[FocusedButton].Invalidate;
end;

procedure TTVNavigator.WMKillFocus(var Message: TWMKillFocus);
begin
  Buttons[FocusedButton].Invalidate;
end;

procedure TTVNavigator.KeyDown(var Key: Word; Shift: TShiftState);
var
  NewFocus: TTVNavigateBtn;
  OldFocus: TTVNavigateBtn;
begin
  OldFocus := FocusedButton;
  case Key of
    VK_RIGHT:
      begin
        NewFocus := FocusedButton;
        repeat
          if NewFocus < High(Buttons) then
            NewFocus := Succ(NewFocus);
        until (NewFocus = High(Buttons)) or (Buttons[NewFocus].Visible);
        if NewFocus <> FocusedButton then
        begin
          FocusedButton := NewFocus;
          Buttons[OldFocus].Invalidate;
          Buttons[FocusedButton].Invalidate;
        end;
      end;
    VK_LEFT:
      begin
        NewFocus := FocusedButton;
        repeat
          if NewFocus > Low(Buttons) then
            NewFocus := Pred(NewFocus);
        until (NewFocus = Low(Buttons)) or (Buttons[NewFocus].Visible);
        if NewFocus <> FocusedButton then
        begin
          FocusedButton := NewFocus;
          Buttons[OldFocus].Invalidate;
          Buttons[FocusedButton].Invalidate;
        end;
      end;
    VK_SPACE:
      begin
        if Buttons[FocusedButton].Enabled then
          Buttons[FocusedButton].Click;
      end;
  end;
end;

procedure TTVNavigator.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTARROWS;
end;

procedure TTVNavigator.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
end;

procedure TTVNavigator.SetTreeView(Value: TTSVCustomTreeView);
begin
  FTreeView:=Value;
  if Value <> nil then Value.FreeNotification(Self);
  SetEnableButtons;
end;

function TTVNavigator.GetTreeView: TTSVCustomTreeView;
begin
  Result := FTreeView;
end;

{TTVNavButton}

destructor TTVNavButton.Destroy;
begin
  if FRepeatTimer <> nil then
    FRepeatTimer.Free;
  inherited Destroy;
end;

procedure TTVNavButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited MouseDown (Button, Shift, X, Y);
  if nsAllowTimer in FNavStyle then
  begin
    if FRepeatTimer = nil then
      FRepeatTimer := TTimer.Create(Self);

    FRepeatTimer.OnTimer := TimerExpired;
    FRepeatTimer.Interval := InitRepeatPause;
    FRepeatTimer.Enabled  := True;
  end;
end;

procedure TTVNavButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
                                  X, Y: Integer);
begin
  inherited MouseUp (Button, Shift, X, Y);
  if FRepeatTimer <> nil then
    FRepeatTimer.Enabled  := False;
end;

procedure TTVNavButton.TimerExpired(Sender: TObject);
begin
  FRepeatTimer.Interval := RepeatPause;
  if (FState = bsDown) and MouseCapture then
  begin
    try
      Click;
    except
      FRepeatTimer.Enabled := False;
      raise;
    end;
  end;
end;

procedure TTVNavButton.Paint;
var
  R: TRect;
begin
  inherited Paint;
  if (GetFocus = Parent.Handle) and
     (FIndex = TTVNavigator (Parent).FocusedButton) then
  begin
    R := Bounds(0, 0, Width, Height);
    InflateRect(R, -3, -3);
    if FState = bsDown then
      OffsetRect(R, 1, 1);
    Canvas.Brush.Style := bsSolid;
    Font.Color := clBtnShadow;
    DrawFocusRect(Canvas.Handle, R);
  end;
end;


end.
