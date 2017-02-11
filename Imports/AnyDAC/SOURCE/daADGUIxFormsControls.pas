{ --------------------------------------------------------------------------- }
{ AnyDAC GUIx Forms custom controls                                           }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I daAD.inc}

unit daADGUIxFormsControls;

interface

uses
  Windows, WinProcs, WinTypes, Classes, Controls, ExtCtrls, Forms, Graphics,
  Messages, SysUtils, ImgList, StdCtrls, Buttons, ComCtrls, CommCtrl, ToolWin,
  Menus, Contnrs, Registry
{$IFDEF AnyDAC_SynEdit}
  , SynEdit, SynMemo, SynHighlighterSQL, SynEditHighlighter
{$ENDIF}
{$IFDEF AnyDAC_D6}
  , ValEdit
{$ENDIF}
  ;

const
  C_ColorInactiveFont = clBtnShadow;
  C_ColorInactiveTab = clBtnHighLight;
  C_ColorTabFrame = clBtnShadow;

  C_ColorButtomActiveFrame = clBtnShadow;
  C_ColorButtomInactiveFrame = clBtnShadow;
  C_ColorButtomActive = clBtnShadow;

{$IFNDEF AnyDAC_D6}
  clSkyBlue = TColor($F0CAA6);
  clHotLight = TColor($FF000000 or COLOR_HOTLIGHT);
{$ENDIF}

type
  TADGUIxFormsPanel = class;
  TADGUIxFormsTabControl = class;
  TADGUIxFormsTabSroller = class;
  TADGUIxFormsPanelTree = class;
  TADGUIxFormsListView = class;
  TADGUIxFormsMemo = class;

  TADGUIxFormsTabPosition = (tpBottom, tpTop);
  TADGUIxFormsTabState = (tsVisible, tsCut, tsInvisible);
  PADGUIxFormsTabInfo = ^TADGUIxFormsTabInfo;
  TADGUIxFormsTabInfo = record
    FPos: TRect;
    FTextWidth: Integer;
    FTextHeight: Integer;
    FImageIndex: Integer;
    FState: TADGUIxFormsTabState;
  end;

  TADGUIxFormsScrollDirection = (sdBackWard, sdForward);
  
  {----------------------------------------------------------------------------}
  { TADGUIxFormsPanel
  {----------------------------------------------------------------------------}
  TADGUIxFormsPanel = class (TPanel)
  public 
    constructor Create(AOwner: TComponent); override;
  end;
  
  {----------------------------------------------------------------------------}
  { TADGUIxFormsTabScrollButton
  {----------------------------------------------------------------------------}
  TADGUIxFormsTabScrollButton = class (TSpeedButton)
  private
    FDirection: TADGUIxFormsScrollDirection;
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Click; override;
  end;

  {----------------------------------------------------------------------------}
  { TADGUIxFormsTabSroller
  {----------------------------------------------------------------------------}
  TADGUIxFormsTabSroller = class (TCustomControl)
  private
    FBackward: TADGUIxFormsTabScrollButton;
    FButtonWidth: Integer;
    FForward: TADGUIxFormsTabScrollButton;
    FMinHeight: Integer;
    procedure WMSetFont(var AMessage: TMessage); message WM_SETFONT;
  protected
    procedure AlignControls(AControl: TControl; var ARect: TRect); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure UpdateButtons;
  end;

  {----------------------------------------------------------------------------}
  { TADGUIxFormsTabControlColors
  {----------------------------------------------------------------------------}
  TADGUIxFormsTabControlColors = class (TPersistent)
  private
    FColors: array [0..2] of TColor;
    FUpdateCount: Integer;
    FOnChange: TNotifyEvent;
    function GetColor(AIndex: Integer): TColor;
    procedure SetColor(AIndex: Integer; AValue: TColor);
    procedure Change;
    procedure DoChange;
  public
    constructor Create;
    procedure Assign(ASource: TPersistent); override;
    procedure BeginUpdate;
    procedure EndUpdate;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  published
    property InactiveFont: TColor index 0 read GetColor write SetColor default C_ColorInactiveFont;
    property InactiveTabBG: TColor index 1 read GetColor write SetColor default C_ColorInactiveTab;
    property TabFG: TColor index 2 read GetColor write SetColor default C_ColorTabFrame;
  end;

  {----------------------------------------------------------------------------}
  { TADGUIxFormsTabControl
  {----------------------------------------------------------------------------}
  TADGUIxFormsTabControl = class (TCustomControl)
  private
    FFirstTab: Integer;
    FImageChangeLink: TChangeLink;
    FImages: TImageList;
    FLastTab: Integer;
    FLockCount: Integer;
    FOnChange: TNotifyEvent;
    FPosition: TADGUIxFormsTabPosition;
    FScroller: TADGUIxFormsTabSroller;
    FStreamedTabIndex: Integer;
    FTabHeight: Integer;
    FTabIndex: Integer;
    FTabInfos: TList;
    FTabs: TStrings;
    FColors: TADGUIxFormsTabControlColors;
    procedure CalcSize(var AWidth, AHeight: Integer);
    procedure CalculateTabs;
    function CanScroll(AValue: TADGUIxFormsScrollDirection): Boolean;
    procedure ChangeTabIndex(ADelta: Integer);
    procedure ClearTabInfo;
    procedure CMFontChanged(var AMessage: TMessage); message CM_FONTCHANGED;
    procedure CMParentFontChanged(var AMessage: TMessage); message CM_PARENTFONTCHANGED;
    procedure DoChange;
    procedure DoEraseBG(var AMeassage: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure DoImagesChange(Sender: TObject);
    procedure DoColorsChangeHndlr(Sender: TObject);
    procedure DoSize(var AMessage: TWMSize); message WM_SIZE;
    function GetTabCount: Integer;
    function GetTabRect(ATabIndex: Integer): TRect;
    procedure LockAlign;
    procedure SetImages(AValue: TImageList);
    procedure SetPosition(AValue: TADGUIxFormsTabPosition);
    procedure SetTabIndex(AValue: Integer);
    procedure SetTabs(AList: TStrings);
    procedure SetColors(AValue: TADGUIxFormsTabControlColors);
    procedure TabsChanged;
    procedure UnLockAlign;
    procedure UpdateTabHeight;
  protected
    procedure AlignControls(AControl: TControl; var ARect: TRect); override;
    function CanChange(ATabIndex: Integer): Boolean; virtual;
    procedure Changed; virtual;
    procedure Click; override;
    function CurrentImageIndex(ATabIndex: Integer): Integer;
    function GetImageIndex(ATabIndex: Integer): Integer; virtual;
    procedure Loaded; override;
    procedure MouseMove(AShift: TShiftState; AX, AY: Integer); override;
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;
    procedure Paint; override;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    function IndexOfTabAt(AX, AY: Integer): Integer;
    procedure UpdateLayout;
    property TabCount: Integer read GetTabCount;
  published
    property Colors: TADGUIxFormsTabControlColors read FColors write SetColors;
    property Images: TImageList read FImages write SetImages;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property Position: TADGUIxFormsTabPosition read FPosition write SetPosition default tpBottom;
    property TabIndex: Integer read FTabIndex write SetTabIndex default -1;
    property Tabs: TStrings read FTabs write SetTabs;
    property Align;
    property Anchors;
    property Color;
    property DragCursor;
    property DragMode;
    property Font;
    property Height default 25;
    property Hint;
    property OnClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property ShowHint;
    property Visible;
    property Width default 200;
  end;

  {----------------------------------------------------------------------------}
  { TADGUIxFormsPageControl
  {----------------------------------------------------------------------------}
  TADGUIxFormsPageControl = class (TPageControl)
  private
    FPanelTitle: TADGUIxFormsPanel;
    FPanelTitleLine: TADGUIxFormsPanel;
    FPanels: TList;
    FFrameColor: TColor;
    FCaptionColor: TColor;
    procedure SetFrameColor(AValue: TColor);
    procedure SetCaptionColor(AValue: TColor);
{$IFDEF AnyDAC_D6}
    procedure DoLabelMouseEnterHndlr(Sender: TObject);
    procedure DoLabelMouseLeaveHndlr(Sender: TObject);
{$ENDIF}    
    procedure DoLabelClickHndlr(Sender: TObject);
    procedure UpdatePanel(AIndex: Integer);
    procedure InsertPage(AIndex: Integer; const APageCaption: string);
    procedure SetPageCaption(AIndex: Integer; const APageCaption: string);
    procedure DeletePage(AIndex: Integer);
    procedure TCMInsertItem(var AMessage: TMessage); message TCM_INSERTITEM;
    procedure TCMSetItem(var AMessage: TMessage); message TCM_SETITEM;
    procedure TCMDeleteItem(var AMessage: TMessage); message TCM_DELETEITEM;
    procedure TCMDeleteAllItem(var AMessage: TMessage); message TCM_DELETEALLITEMS;
    procedure WMSize(var AMessage: TMessage); message WM_SIZE;
{$IFDEF AnyDAC_D7}
  protected
    procedure SetTabIndex(AValue: Integer); override;
{$ELSE}
  private
    procedure TCMSetCurrItem(var AMessage: TMessage); message TCM_SETCURSEL;
{$ENDIF}
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property FrameColor: TColor read FFrameColor write SetFrameColor default clBtnShadow;
    property CaptionColor: TColor read FCaptionColor write SetCaptionColor default clSkyBlue;
  end;

  {----------------------------------------------------------------------------}
  { TADGUIxFormsPanelTree
  {----------------------------------------------------------------------------}
  TADGUIxFormsPanelTree = class(TScrollBox)
  private
    FPanels: TList;
    FLock: Boolean;
    procedure CMControlChange(var Message: TMessage); message CM_CONTROLCHANGE;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure ChangeAllState(AExpand: Boolean);
  protected
    procedure Loaded; override;
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LoadState(AReg: TRegistry);
    procedure SaveState(AReg: TRegistry);
  published
    property BevelInner default bvSpace;
    property BevelKind default bkFlat;
    property BorderStyle default bsNone;
    property Ctl3D default True;
    property ParentCtl3D default False;
  end;

  {----------------------------------------------------------------------------}
  { TADGUIxFormsListView
  {----------------------------------------------------------------------------}
  TADGUIxFormsLVBeforeEditEvent = procedure(Sender: TADGUIxFormsListView; AEditedIndex: Integer; var AEditedValue: string) of object;
  TADGUIxFormsLVAfterEditEvent = procedure(Sender: TADGUIxFormsListView; AEditedIndex: Integer) of object;

{$IFNDEF AnyDAC_D6}
  TListViewCoord = record
    Item: Integer;
    Column: Integer;
  end;

  TADGUIxFormsLVGetColumnAt = function(Item: TListItem; const Pt: TPoint): Integer of object;
  TADGUIxFormsLVGetColumnRect = function(Item: TListItem; ColumnIndex: Integer; var Rect: TRect): Boolean of object;
  TADGUIxFormsLVGetIndexesAt = function(const Pt: TPoint; var Coord: TListViewCoord): Boolean of object;

  TADGUIxFormsListView = class(TCustomListView)
  private
    FEdit: TEdit;
    FCombo: TComboBox;
    FEditControl: TWinControl;
    FColumnToEdit: Integer;
    FEditItemIndex: Integer;
    FColumnEditWidth: Integer;
    FComCtrl32Version: DWORD;
    FGetColumnAt: TADGUIxFormsLVGetColumnAt;
    FGetColumnRect: TADGUIxFormsLVGetColumnRect;
    FGetIndexesAt: TADGUIxFormsLVGetIndexesAt;
    FBeforeEdit: TADGUIxFormsLVBeforeEditEvent;
    FAfterEdit: TADGUIxFormsLVAfterEditEvent;
    FAlwaysShowEditor: Boolean;
    FEnterEditing: Boolean;
    function GetValue(const AName: string): string;
    function GetValueIndex(const AName: string): Integer;
    function GetComCtl32Version: DWORD;
    function Manual_GetIndexesAt(const APoint: TPoint; var ACoord: TListViewCoord): Boolean;
    function Manual_GetColumnAt(AItem: TListItem; const APoint: TPoint): Integer;
    function Manual_GetColumnRect(AItem: TListItem; AColumnIndex: Integer; var ARect: TRect): Boolean;
    function ComCtl_GetColumnAt(AItem: TListItem; const APoint: TPoint): Integer;
    function ComCtl_GetColumnRect(AItem: TListItem; AColumnIndex: Integer; var ARect: TRect): Boolean;
    function ComCtl_GetIndexesAt(const APoint: TPoint; var ACoord: TListViewCoord): Boolean;
    procedure DoEditKeyDownHndlr(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure DoComboKeyDownHndlr(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure DoExitHndlr(Sender: TObject);
    procedure DoBeforeEdit(var AEditedValue: string);
    procedure DoAfterEdit;
    function IndexOf(const AName: string): Integer;
    procedure Edited;
    procedure CancelEdit;
    procedure CNNotify(var Message: TWMNotify); message CN_NOTIFY;
    function GetItemIndex: Integer;
    procedure SetItemIndex(const Value: Integer);
  protected
    function CanEdit(AItem: TListItem): Boolean; override;
    procedure DrawItem(AItem: TListItem; ARect: TRect; AState: TOwnerDrawState); override;
    procedure KeyDown(var AKey: Word; AShift: TShiftState); override;
    procedure KeyUp(var AKey: Word; AShift: TShiftState); override;
    procedure MouseDown(AButton: TMouseButton; AShift: TShiftState; AX, AY: Integer); override;
    procedure MouseUp(AButton: TMouseButton; AShift: TShiftState; AX, AY: Integer); override;
    procedure Delete(AItem: TListItem); override;
    procedure DoEnter; override;
  public
    constructor Create(AOwner: TComponent); override;
    function IsEditing: Boolean; reintroduce;
    procedure AddValue(const AItemName, AValue: string);
    procedure AddIntegerValue(const AItemName: string; AValue: Integer);
    procedure AddFloatValue(const AItemName: string; AValue: Double);
    procedure AddBooleanValue(const AItemName: string; AValue: Boolean);
    procedure AddValues(const AItemName: string; AValues: TStrings; AIndex: Integer);
    property Value[const AName: string]: string read GetValue;
    property ValueIndex[const AName: string]: Integer read GetValueIndex;
    property ItemIndex: Integer read GetItemIndex write SetItemIndex;
  published
    property Action;
    property AlwaysShowEditor: Boolean read FAlwaysShowEditor write FAlwaysShowEditor default True;
    property Align;
    property AllocBy;
    property Anchors;
    property BevelEdges;
    property BevelInner default bvSpace;
    property BevelOuter;
    property BevelKind default bkFlat;
    property BevelWidth;
    property BiDiMode;
    property BorderStyle default bsNone;
    property BorderWidth;
    property Checkboxes;
    property Color;
    property Columns stored False;
    property ColumnClick;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property FlatScrollBars;
    property FullDrag;
    property GridLines default True;
    property HideSelection;
    property HotTrack;
    property HotTrackStyles;
    property HoverTime;
    property IconOptions;
    property Items;
    property LargeImages;
    property MultiSelect;
    property OwnerData;
    property OwnerDraw default True;
    property ReadOnly default False;
    property RowSelect;
    property ParentBiDiMode;
    property ParentColor default False;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowColumnHeaders default False;
    property ShowWorkAreas;
    property ShowHint;
    property SmallImages;
    property SortType;
    property StateImages;
    property TabOrder;
    property TabStop default True;
    property ViewStyle default vsReport;
    property Visible;
    property AfterEdit: TADGUIxFormsLVAfterEditEvent read FAfterEdit write FAfterEdit;
    property BeforeEdit: TADGUIxFormsLVBeforeEditEvent read FBeforeEdit write FBeforeEdit;
    property OnAdvancedCustomDraw;
    property OnAdvancedCustomDrawItem;
    property OnAdvancedCustomDrawSubItem;
    property OnChange;
    property OnChanging;
    property OnClick;
    property OnColumnClick;
    property OnColumnDragged;
    property OnColumnRightClick;
    property OnCompare;
    property OnContextPopup;
    property OnCustomDraw;
    property OnCustomDrawItem;
    property OnCustomDrawSubItem;
    property OnData;
    property OnDataFind;
    property OnDataHint;
    property OnDataStateChange;
    property OnDblClick;
    property OnDeletion;
    property OnDrawItem;
    property OnEditing;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetImageIndex;
    property OnGetSubItemImage;
    property OnDragDrop;
    property OnDragOver;
    property OnInfoTip;
    property OnInsert;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnSelectItem;
    property OnStartDock;
    property OnStartDrag;
  end;

{$ELSE}

  TADGUIxFormsListView = class(TValueListEditor)
  private
    FBeforeEdit: TADGUIxFormsLVBeforeEditEvent;
    FAfterEdit: TADGUIxFormsLVAfterEditEvent;
    FLockUpdate: Boolean;
    function GetIsEditing: Boolean;
    function GetItems: TStrings;
    function GetValue(const AName: String): String;
    function GetValueIndex(const AName: String): Integer;
    procedure DoChanging(ASender: TObject);
    procedure DoChanged(ASender: TObject);
  protected
    function GetEditText(ACol, ARow: Longint): string; override;
    procedure SetEditText(ACol, ARow: Longint; const AValue: string); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddValue(const AItemName, AValue: string);
    procedure AddIntegerValue(const AItemName: string; AValue: Integer);
    procedure AddFloatValue(const AItemName: string; AValue: Double);
    procedure AddBooleanValue(const AItemName: string; AValue: Boolean);
    procedure AddValues(const AItemName: string; AValues: TStrings; AIndex: Integer);
    procedure Clear;
    property IsEditing: Boolean read GetIsEditing;
    property Items: TStrings read GetItems;
    property Value[const AName: string]: string read GetValue;
    property ValueIndex[const AName: string]: Integer read GetValueIndex;
  published
    property BeforeEdit: TADGUIxFormsLVBeforeEditEvent read FBeforeEdit write FBeforeEdit;
    property AfterEdit: TADGUIxFormsLVAfterEditEvent read FAfterEdit write FAfterEdit;
    property DisplayOptions default [doAutoColResize, doKeyColFixed];
  end;

{$ENDIF}

  {----------------------------------------------------------------------------}
  { TADGUIxFormsMemo
  {----------------------------------------------------------------------------}
{$IFDEF AnyDAC_SynEdit}
  TADGUIxFormsMemo = class(TSynMemo)
  private
    function GetCaretPos: TPoint;
    procedure SetCaretPos(const AValue: TPoint);
  public
    constructor Create(AOwner: TComponent); override;
    property CaretPos: TPoint read GetCaretPos write SetCaretPos;
  end;
{$ELSE}
  TADGUIxFormsMemo = class(TMemo)
  private
  {$IFNDEF AnyDAC_D6}
    procedure SetCaretPos(const AValue: TPoint);
  {$ENDIF}
  public
    constructor Create(AOwner: TComponent); override;
  {$IFNDEF AnyDAC_D6}
    property CaretPos write SetCaretPos;
  {$ENDIF}
  end;
{$ENDIF}

implementation

uses
  Math
{$IFDEF AnyDAC_D6}
  , Types
{$ENDIF}
  , daADStanConst, Grids;

{$R daADGUIxFormsPanelTreeButton.res}

const
  C_TabStartOffsetX = 3;
  C_TabOffsetX = 6;
  C_TabOffsetY = 2;
  C_Deltas: array[TADGUIxFormsScrollDirection] of Integer = (-1, 1);

  CPlusBitmap = 'ADPLUS';
  CMinusBitmap = 'ADMINUS';
  CHorizSpace0 = 7;
  CHorizSpace1 = 5;
  CButtonWidth = 9;
  CHorizSpace2 = 10;
  CVertSpace0 = 3;
  CButtonHeight = CButtonWidth;
  CMountMinHeight = 20;

{ -------------------------------------------------------------------------- }
function RotatePoint(APoint, ACenter: TPoint; AAngle: Double): TPoint;
var
  rSinA, rCosA: Double;
begin
  if AAngle <> 0 then begin
    rSinA := Sin(AAngle);
    rCosA := Cos(AAngle);
    Result.X := Round(rCosA * (APoint.X - ACenter.X) + rSinA * (APoint.Y - ACenter.Y) +
      ACenter.X);
    Result.Y := Round(rCosA * (APoint.Y - ACenter.Y) - rSinA * (APoint.X - ACenter.X) +
      ACenter.Y);
  end
  else
    Result := APoint;
end;

{----------------------------------------------------------------------------}
{ TADGUIxFormsPanel                                                          }
{----------------------------------------------------------------------------}
constructor TADGUIxFormsPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF AnyDAC_D7}
  ParentBackground := False;
{$ENDIF}
end;
  
{----------------------------------------------------------------------------}
{ TADGUIxFormsTabStrings                                                     }
{----------------------------------------------------------------------------}
type
  TADGUIxFormsTabStrings = class (TStringList)
  private
    FTabControl: TADGUIxFormsTabControl;
  protected
    procedure Changed; override;
  public
    constructor Create(ATabControl: TADGUIxFormsTabControl);
  end;

{----------------------------------------------------------------------------}
constructor TADGUIxFormsTabStrings.Create(ATabControl: TADGUIxFormsTabControl);
begin
  inherited Create;
  FTabControl := ATabControl;
end;

{----------------------------------------------------------------------------}
{$IFNDEF AnyDAC_D6}
type
  __TStrings = class(TPersistent)
  private
    FUpdateCount: Integer;
  end;
{$ENDIF}

procedure TADGUIxFormsTabStrings.Changed;
begin
  inherited Changed;
{$IFDEF AnyDAC_D6}
  if UpdateCount = 0 then
{$ELSE}
  if __TStrings(Self).FUpdateCount = 0 then
{$ENDIF}
    FTabControl.TabsChanged;
end;

{----------------------------------------------------------------------------}
{ TADGUIxFormsTabScrollButton                                                }
{----------------------------------------------------------------------------}
constructor TADGUIxFormsTabScrollButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Flat := True;
  ParentColor := True;
end;

{----------------------------------------------------------------------------}
procedure TADGUIxFormsTabScrollButton.Paint;
var
  aPoints: array[0..2] of TPoint;
  iHeight: Integer;
begin
  inherited Paint;
  iHeight := Canvas.TextHeight('W');
  if FDirection = sdBackward then begin
    aPoints[0] := Point(ClientWidth div 2 - iHeight div 4, ClientHeight div 2);
    aPoints[1] := Point(aPoints[0].X + iHeight div 2, aPoints[0].Y);
  end
  else begin
    aPoints[0] := Point(ClientWidth div 2 + iHeight div 4, ClientHeight div 2);
    aPoints[1] := Point(aPoints[0].X - iHeight div 2, aPoints[0].Y);
  end;
  aPoints[1] := RotatePoint(aPoints[1], aPoints[0], -Pi / 4);
  aPoints[2] := RotatePoint(aPoints[1], aPoints[0], Pi / 2);
  with Canvas do begin
    if Enabled then begin
      Brush.Color := C_ColorButtomActive;
      Pen.Color := C_ColorButtomActiveFrame;
    end
    else begin
      Brush.Color := Color;
      Pen.Color := C_ColorButtomInactiveFrame;
    end;
    Polygon(aPoints);
  end;
end;

{----------------------------------------------------------------------------}
procedure TADGUIxFormsTabScrollButton.Click;
begin
  inherited;
  TADGUIxFormsTabControl(Owner.Owner).ChangeTabIndex(C_Deltas[FDirection]);
end;

{----------------------------------------------------------------------------}
{ TADGUIxFormsTabSroller                                                     }
{----------------------------------------------------------------------------}
constructor TADGUIxFormsTabSroller.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBackward := TADGUIxFormsTabScrollButton.Create(Self);
  FBackward.Parent := Self;
  FBackward.FDirection := sdBackWard;
  FForward := TADGUIxFormsTabScrollButton.Create(Self);
  FForward.Parent := Self;
  FForward.FDirection := sdForward;
  FMinHeight := 24;
  FButtonWidth := 23;
  Width := 2 * FButtonWidth;
  Height := FMinHeight;
end;

{----------------------------------------------------------------------------}
procedure TADGUIxFormsTabSroller.WMSetFont(var AMessage: TMessage);
begin
  inherited;
  if HandleAllocated then begin
    Canvas.Font := Self.Font;
    FButtonWidth := 2 * Canvas.TextWidth('W');
    SetBounds(Left, Top, 2 * FButtonWidth, Height);
  end;
end;

{----------------------------------------------------------------------------}
procedure TADGUIxFormsTabSroller.AlignControls(AControl: TControl;
  var ARect: TRect);
begin
  FBackward.SetBounds(0, 0, FButtonWidth, Height);
  FForward.SetBounds(FButtonWidth, 0, FButtonWidth, Height);
end;

{----------------------------------------------------------------------------}
procedure TADGUIxFormsTabSroller.UpdateButtons;
begin
  FBackward.Enabled := TADGUIxFormsTabControl(Owner).CanScroll(sdBackward);
  FForward.Enabled := TADGUIxFormsTabControl(Owner).CanScroll(sdForward);
end;

{----------------------------------------------------------------------------}
{ TADGUIxFormsTabControlColors                                               }
{----------------------------------------------------------------------------}
constructor TADGUIxFormsTabControlColors.Create;
begin
  FColors[0] := C_ColorInactiveFont;
  FColors[1] := C_ColorInactiveTab;
  FColors[2] := C_ColorTabFrame;
end;

{----------------------------------------------------------------------------}
procedure TADGUIxFormsTabControlColors.Assign(ASource: TPersistent);
begin
  if ASource is TADGUIxFormsTabControlColors then begin
    BeginUpdate;
    try
      InactiveFont := TADGUIxFormsTabControlColors(ASource).InactiveFont;
      InactiveTabBG := TADGUIxFormsTabControlColors(ASource).InactiveTabBG;
      TabFG := TADGUIxFormsTabControlColors(ASource).TabFG;
    finally
      EndUpdate;
    end;
  end
  else
    inherited Assign(ASource);
end;

{----------------------------------------------------------------------------}
procedure TADGUIxFormsTabControlColors.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

{----------------------------------------------------------------------------}
procedure TADGUIxFormsTabControlColors.EndUpdate;
begin
  Dec(FUpdateCount);
  if FUpdateCount = 0 then
    DoChange;
end;

{----------------------------------------------------------------------------}
function TADGUIxFormsTabControlColors.GetColor(AIndex: Integer): TColor;
begin
  Result := FColors[AIndex];
end;

{----------------------------------------------------------------------------}
procedure TADGUIxFormsTabControlColors.SetColor(AIndex: Integer; AValue: TColor);
begin
  if FColors[AIndex] <> AValue then begin
    FColors[AIndex] := AValue;
    Change;
  end;
end;

{----------------------------------------------------------------------------}
procedure TADGUIxFormsTabControlColors.Change;
begin
  if FUpdateCount = 0 then
    DoChange;
end;

{----------------------------------------------------------------------------}
procedure TADGUIxFormsTabControlColors.DoChange;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

{----------------------------------------------------------------------------}
{ TADGUIxFormsTabControl                                                     }
{----------------------------------------------------------------------------}
constructor TADGUIxFormsTabControl.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FTabs := TADGUIxFormsTabStrings.Create(Self);
  FColors := TADGUIxFormsTabControlColors.Create;
  FColors.OnChange := DoColorsChangeHndlr;
  FTabInfos := TList.Create;
  FScroller := TADGUIxFormsTabSroller.Create(Self);
  FScroller.Parent := Self;
  FScroller.Visible := False;
  FPosition := tpBottom;
  FImageChangeLink := TChangeLink.Create;
  FImageChangeLink.OnChange := DoImagesChange;
  FTabHeight := 25;
  FTabIndex := -1;
  FStreamedTabIndex := -1;
  ControlStyle := ControlStyle - [csAcceptsControls];
  Width := 200;
  Height := FTabHeight + 2 * C_TabOffsetY;
  FLastTab := -1;
end;

{----------------------------------------------------------------------------}
destructor TADGUIxFormsTabControl.Destroy;
begin
  ClearTabInfo;
  FreeAndNil(FTabInfos);
  FreeAndNil(FTabs);
  FreeAndNil(FColors);
  FreeAndNil(FImageChangeLink);
  FScroller.Parent := nil;
  inherited Destroy;
end;

{----------------------------------------------------------------------------}
procedure TADGUIxFormsTabControl.CalcSize(var AWidth, AHeight: Integer);
var
  iLeft, iTop, iWidth, iHeight: Integer;
begin
  iWidth := 10;
  iHeight := FTabHeight + 2 * C_TabOffsetY;
  if not (csLoading in ComponentState) then begin
    if FScroller.Visible then begin
      iWidth := iWidth + FScroller.Width;
      iHeight := Max(FScroller.FMinHeight, iHeight);
    end;
    AHeight := Max(AHeight, iHeight);
    AWidth := Max(AWidth, iWidth);
  end;
  if FScroller.Visible then begin
    iLeft := ClientWidth - FScroller.Width - C_TabStartOffsetX;
    iHeight := FTabHeight;
    case FPosition of
      tpBottom: iTop := ClientHeight - iHeight;
      else      iTop := C_TabOffsetY;
    end;
    FScroller.SetBounds(iLeft, iTop, FScroller.Width, iHeight - C_TabOffsetY);
  end
  else
    FScroller.SetBounds(-FScroller.Width, 0, FScroller.Width, iHeight);
end;

{----------------------------------------------------------------------------}
procedure TADGUIxFormsTabControl.CalculateTabs;
var
  iTabWidth, i, iCx: Integer;
  iCharW, iCharH: Integer;
  sTabCaption: string;
  pTabInfo: PADGUIxFormsTabInfo;
  iClientWidth: Integer;
  lExit: Boolean;
begin
  if TabCount = 0 then begin
    FScroller.Visible := False;
    Exit;
  end;
  iClientWidth := ClientWidth - C_TabStartOffsetX;
  Canvas.Font := Self.Font;
  iCharW := Canvas.TextWidth('W');
  iCharH := Canvas.TextHeight('Wy');
  iCx := C_TabStartOffsetX;
  ClearTabInfo;
  lExit := False;
  for i := 0 to TabCount - 1 do begin
    GetMem(pTabInfo, SizeOf(TADGUIxFormsTabInfo));
    try
      pTabInfo^.FImageIndex := -1;
      sTabCaption := FTabs[i];
      pTabInfo^.FTextHeight := iCharH;
      pTabInfo^.FTextWidth := Canvas.TextWidth(sTabCaption);
      if Pos('&', sTabCaption) <> 0 then
        Dec(pTabInfo^.FTextWidth, iCharW);
      pTabInfo^.FTextWidth := Max(pTabInfo^.FTextWidth, iCharW);
      iTabWidth := pTabInfo^.FTextWidth + 2 * C_TabOffsetX;
      if FImages <> nil then
        Inc(iTabWidth, FImages.Width + C_TabOffsetX);
  
      if (i >= FFirstTab) and not lExit then begin
        if (i < TabCount - 1) and (iClientWidth < iTabWidth + FScroller.Width) or
           (i = TabCount - 1) and
           ((FFirstTab <> 0) and (iClientWidth < iTabWidth + FScroller.Width) or
            (FFirstTab = 0) and (iClientWidth < iTabWidth)) then begin
          pTabInfo^.FState := tsCut;
          FLastTab := i;
          lExit := True;
        end
        else begin
          pTabInfo^.FState := tsVisible;
          Dec(iClientWidth, iTabWidth);
        end;
        pTabInfo^.FPos := Rect(iCx, 0, iCx + iTabWidth, FTabHeight);
        Inc(iCx, iTabWidth);
      end
      else begin
        pTabInfo^.FPos := Rect(0, 0, iTabWidth, FTabHeight);
        pTabInfo^.FState := tsInvisible;
      end;
      FTabInfos.Add(pTabInfo);
    except
      FreeMem(pTabInfo);
      raise;
    end;
  end;
  if not lExit then
    FLastTab := TabCount - 1;
  FScroller.Visible := (FLastTab <> TabCount - 1) or (FFirstTab <> 0);
  FScroller.UpdateButtons;
end;

{----------------------------------------------------------------------------}
function TADGUIxFormsTabControl.CanScroll(AValue: TADGUIxFormsScrollDirection): Boolean;
begin
  Result := FScroller.Visible and (FFirstTab + C_Deltas[AValue] >= 0) and
     ((FLastTab + C_Deltas[AValue] < TabCount) or
      (PADGUIxFormsTabInfo(FTabInfos[FLastTab])^.FState = tsCut));
end;

{----------------------------------------------------------------------------}
procedure TADGUIxFormsTabControl.ChangeTabIndex(ADelta: Integer);
begin
  if (FFirstTab + ADelta >= 0) and ((FLastTab + ADelta < TabCount) or
     (PADGUIxFormsTabInfo(FTabInfos[FLastTab])^.FState = tsCut)) then begin
    FFirstTab := FFirstTab + ADelta;
    UpdateLayout;
    Invalidate;
  end;
end;

{----------------------------------------------------------------------------}
procedure TADGUIxFormsTabControl.ClearTabInfo;
var
  i: Integer;
  pTabInfo: PADGUIxFormsTabInfo;
begin
  for i := 0 to FTabInfos.Count - 1 do begin
    pTabInfo := PADGUIxFormsTabInfo(FTabInfos[i]);
    if pTabInfo <> nil then
      FreeMem(pTabInfo);
  end;
  FTabInfos.Clear;
end;

{----------------------------------------------------------------------------}
procedure TADGUIxFormsTabControl.CMFontChanged(var AMessage: TMessage);
begin
  UpdateLayout;
  inherited;
end;

{----------------------------------------------------------------------------}
procedure TADGUIxFormsTabControl.CMParentFontChanged(var AMessage: TMessage);
begin
  inherited;
  UpdateLayout;
end;

{----------------------------------------------------------------------------}
procedure TADGUIxFormsTabControl.DoChange;
begin
  Changed;
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

{----------------------------------------------------------------------------}
procedure TADGUIxFormsTabControl.DoEraseBG(var AMeassage: TWMEraseBkgnd);
begin
  if not (csDesigning in ComponentState) then
    AMeassage.Result := 1
  else
    inherited;
end;

{----------------------------------------------------------------------------}
procedure TADGUIxFormsTabControl.DoImagesChange(Sender: TObject);
begin
  Invalidate;
end;

{----------------------------------------------------------------------------}
procedure TADGUIxFormsTabControl.DoColorsChangeHndlr(Sender: TObject);
begin
  Invalidate;
end;

{----------------------------------------------------------------------------}
procedure TADGUIxFormsTabControl.DoSize(var AMessage: TWMSize);
var
  iW, iH: Integer;
begin
  iW := AMessage.Width;
  iH := AMessage.Height;
  LockAlign;
  try
    CalculateTabs;
    CalcSize(iW, iH);
  finally
    UnlockAlign;
  end;
  AMessage.Width := iW;
  AMessage.Height := iH;
  inherited;
end;

{----------------------------------------------------------------------------}
function TADGUIxFormsTabControl.GetTabCount: Integer;
begin
  Result := FTabs.Count;
end;

{----------------------------------------------------------------------------}
function TADGUIxFormsTabControl.GetTabRect(ATabIndex: Integer): TRect;
var
  iDeltaY: Integer;
begin
  if (ATabIndex >= FFirstTab) and (ATabIndex <= FLastTab) then begin
    Result := PADGUIxFormsTabInfo(FTabInfos[ATabIndex])^.FPos;
    case FPosition of
      tpBottom: iDeltaY := ClientHeight - FTabHeight - C_TabOffsetY;
      tpTop:    iDeltaY := C_TabOffsetY;
      else      iDeltaY := 0;
    end;
    OffsetRect(Result, 0, iDeltaY);
  end
  else
    Result := Rect(0, 0, 0, 0);
end;

{----------------------------------------------------------------------------}
procedure TADGUIxFormsTabControl.LockAlign;
begin
  Inc(FLockCount);
end;

{----------------------------------------------------------------------------}
procedure TADGUIxFormsTabControl.SetImages(AValue: TImageList);
var
  oImageSize1, oImageSize2: TSize;
begin
  if csDestroying in ComponentState then
    Exit;
  if FImages <> nil then begin
    FImages.UnRegisterChanges(FImageChangeLink);
    oImageSize1.cx := FImages.Width;
    oImageSize1.cy := FImages.Height;
  end
  else begin
    oImageSize1.cx := 0;
    oImageSize1.cy := 0;
  end;
  FImages := AValue;
  if FImages <> nil then begin
    FImages.RegisterChanges(FImageChangeLink);
    FImages.FreeNotification(Self);
    oImageSize2.cx := FImages.Width;
    oImageSize2.cy := FImages.Height;
  end
  else begin
    oImageSize2.cx := 0;
    oImageSize2.cy := 0;
  end;
  if (oImageSize1.cx <> oImageSize2.cx) or (oImageSize1.cy <> oImageSize2.cy) then
    UpdateLayout;
  Invalidate;
end;

{----------------------------------------------------------------------------}
procedure TADGUIxFormsTabControl.SetPosition(AValue: TADGUIxFormsTabPosition);
begin
  if FPosition <> AValue then begin
    FPosition := AValue;
    UpdateLayout;
    Invalidate;
  end;
end;

{----------------------------------------------------------------------------}
procedure TADGUIxFormsTabControl.SetTabIndex(AValue: Integer);
begin
  if csReading in ComponentState then
    FStreamedTabIndex := AValue
  else
    if FTabIndex <> AValue then begin
      if AValue >= TabCount then
        AValue := TabCount - 1;
      if CanChange(AValue) then begin
        FTabIndex := AValue;
        if not (csLoading in ComponentState) then begin
  
          UpdateLayout;
          while (FFirstTab < TabCount) and (FFirstTab <> FLastTab) and
                ((FTabIndex > FLastTab) or
                 (FTabIndex = FLastTab) and
                 (PADGUIxFormsTabInfo(FTabInfos[FTabIndex])^.FState = tsCut)) do begin
            Inc(FFirstTab);
            CalculateTabs;
          end;
          if (FTabIndex < FFirstTab) and (FTabIndex <> -1) then begin
            FFirstTab := FTabIndex;
            CalculateTabs;
          end
          else if FTabIndex = -1 then
            FLastTab := -1;
          DoChange;
          Invalidate;
        end;
      end;
    end;
end;

{----------------------------------------------------------------------------}
procedure TADGUIxFormsTabControl.SetTabs(AList: TStrings);
begin
  if AList <> nil then
    FTabs.Assign(AList);
  TabsChanged;
end;

{----------------------------------------------------------------------------}
procedure TADGUIxFormsTabControl.SetColors(AValue: TADGUIxFormsTabControlColors);
begin
  FColors.Assign(AValue);
end;

{----------------------------------------------------------------------------}
procedure TADGUIxFormsTabControl.TabsChanged;
begin
  if TabCount = 0 then begin
    FFirstTab := 0;
    FLastTab := -1;
  end;
  if (FTabIndex = -1) and (TabCount > 0) then
    SetTabIndex(0)
  else begin
    UpdateLayout;
    Invalidate;
  end;
end;

{----------------------------------------------------------------------------}
procedure TADGUIxFormsTabControl.UnLockAlign;
begin
  Dec(FLockCount);
end;

{----------------------------------------------------------------------------}
procedure TADGUIxFormsTabControl.UpdateTabHeight;
begin
  if HandleAllocated then begin
    Canvas.Font := Font;
    if FImages <> nil then
      FTabHeight := Max(Canvas.TextHeight('Wy'), FImages.Height)
    else
      FTabHeight := Canvas.TextHeight('Wy');
    FTabHeight := Max(MulDiv(FTabHeight, 150, 100), FScroller.FMinHeight);
  end
  else
    FTabHeight := 25;
end;

{----------------------------------------------------------------------------}
procedure TADGUIxFormsTabControl.AlignControls(AControl: TControl; var ARect: TRect);
begin
  if FLockCount = 0 then
    UpdateLayout;
end;

{----------------------------------------------------------------------------}
function TADGUIxFormsTabControl.CanChange(ATabIndex: Integer): Boolean;
begin
  Result := True;
end;

{----------------------------------------------------------------------------}
procedure TADGUIxFormsTabControl.Changed;
begin
end;

{----------------------------------------------------------------------------}
procedure TADGUIxFormsTabControl.Click;
var
  oPoint: TPoint;
  i: Integer;
begin
  GetCursorPos(oPoint);
  oPoint := ScreenToClient(oPoint);
  i := IndexOfTabAt(oPoint.X, oPoint.Y);
  if i <> -1 then
    SetTabIndex(i);
  inherited Click;
end;

{----------------------------------------------------------------------------}
function TADGUIxFormsTabControl.CurrentImageIndex(ATabIndex: Integer): Integer;
begin
  if (ATabIndex >= 0) and (ATabIndex < TabCount) then
    Result := PADGUIxFormsTabInfo(FTabInfos[ATabIndex])^.FImageIndex
  else
    Result := -1;
end;

{----------------------------------------------------------------------------}
function TADGUIxFormsTabControl.GetImageIndex(ATabIndex: Integer): Integer;
begin
  Result := ATabIndex;
end;

{----------------------------------------------------------------------------}
procedure TADGUIxFormsTabControl.Loaded;
begin
  SetTabIndex(FStreamedTabIndex);
  inherited Loaded;
  UpdateLayout;
end;

{----------------------------------------------------------------------------}
procedure TADGUIxFormsTabControl.MouseMove(AShift: TShiftState; AX, AY: Integer);
var
  i: Integer;
  oPoint: TPoint;
begin
  inherited MouseMove(AShift, AX, AY);
  if ShowHint then begin
    i := IndexOfTabAt(AX, AY);
    if (i <> -1) and (Hint <> FTabs[i]) then begin
      Application.HideHint;
      Hint := FTabs[i];
      oPoint := ClientToScreen(oPoint);
      Application.ActivateHint(oPoint);
    end;
  end;
end;

{----------------------------------------------------------------------------}
procedure TADGUIxFormsTabControl.Notification(AComponent: TComponent;
  AOperation: TOperation);
begin
  inherited Notification(AComponent, AOperation);
  if (AOperation = opRemove) and (AComponent = FImages) then
    Images := nil;
end;

{----------------------------------------------------------------------------}
procedure TADGUIxFormsTabControl.Paint;
var
  oCache: TCanvas;
  oBmp: TBitmap;
  i: Integer;
  
  procedure DrawBorder(ARect: TRect; AColor: TColor; ATabIndex: Integer);
  var
    aCorners: array[0..3] of TPoint;
  begin
    with oCache do begin
      Pen.Style := psSolid;
      Pen.Width := 1;
      if ATabIndex = FTabIndex then begin
        aCorners[0] := ARect.TopLeft;
        aCorners[2] := ARect.BottomRight;
        case FPosition of
          tpBottom: aCorners[0].Y := aCorners[0].Y - 1;
          tpTop:    aCorners[2].Y := aCorners[2].Y + 1;
        end;
        aCorners[1] := Point(aCorners[0].X, aCorners[2].Y);
        aCorners[3] := Point(aCorners[2].X, aCorners[0].Y);
        Brush.Style := bsSolid;
        Brush.Color := AColor;
        Pen.Color := AColor;
        Polygon(aCorners);
        Pen.Color := FColors.TabFG;
        case FPosition of
          tpBottom:
            begin
              MoveTo(aCorners[1].X, aCorners[1].Y);
              LineTo(aCorners[2].X, aCorners[2].Y);
              LineTo(aCorners[3].X, aCorners[3].Y - 1);
            end;
          tpTop:
            begin
              MoveTo(aCorners[2].X, aCorners[2].Y);
              LineTo(aCorners[3].X, aCorners[3].Y);
              LineTo(aCorners[0].X, aCorners[0].Y);
              LineTo(aCorners[1].X, aCorners[1].Y + 1);
              {
              MoveTo(aCorners[3].X, aCorners[3].Y);
              LineTo(aCorners[2].X, aCorners[2].Y + 1);
              }
            end;
        end;
      end
      else if ATabIndex + 1 <> FTabIndex then begin
        Pen.Color := FColors.TabFG;
        case FPosition of
          tpBottom:
            begin
              MoveTo(ARect.Right, ARect.Top + 2 * C_TabOffsetY);
              LineTo(ARect.Right, ARect.Bottom - C_TabOffsetY);
            end;
          tpTop:
            begin
              MoveTo(ARect.Right, ARect.Top + C_TabOffsetY);
              LineTo(ARect.Right, ARect.Bottom - 2 * C_TabOffsetY);
            end;
        end;
      end;
    end;
  end;
  
  procedure DrawTabImage(ARect: TRect; ATabIndex: Integer);
  var
    iImageIndex: Integer;
    oImage: TBitmap;
  begin
    if FImages <> nil then begin
      iImageIndex := GetImageIndex(ATabIndex);
      PADGUIxFormsTabInfo(FTabInfos[ATabIndex])^.FImageIndex := iImageIndex;
      if (iImageIndex >= 0) and (iImageIndex < FImages.Count) then begin
        oImage := TBitmap.Create;
        try
          FImages.GetBitmap(iImageIndex, oImage);
          oImage.Transparent := True;
          ARect.Left := ARect.Left + C_TabOffsetX;
          ARect.Top := ARect.Top + (ARect.Bottom - ARect.Top - FImages.Height) div 2;
          oCache.Draw(ARect.Left, ARect.Top, oImage);
        finally
          oImage.Free;
        end;
      end;
    end;
  end;

  procedure DrawTabText(ARect: TRect; ATabIndex: Integer);
  var
    aBuffer: array[0..255] of Char;
    oRect: TRect;
    lImagePresent: Boolean;
  const
    C_Alignments: array[Boolean] of Integer = (DT_CENTER, DT_LEFT);
  begin
    StrPCopy(aBuffer, FTabs[ATabIndex]);
    oCache.Font := Font;
    if ATabIndex <> FTabIndex then
      oCache.Font.Color := FColors.InactiveFont;
    oCache.Brush.Style := bsClear;
    oRect := ARect;
    lImagePresent := PADGUIxFormsTabInfo(FTabInfos[ATabIndex])^.FImageIndex <> -1;
    if (FImages <> nil) and lImagePresent then
      oRect.Left := ARect.Left + 2 * C_TabOffsetX + FImages.Width;
    DrawText(oCache.Handle, aBuffer, Length(FTabs[ATabIndex]), oRect,
      DT_VCENTER or DT_SINGLELINE or C_Alignments[lImagePresent]);
  end;
  
  procedure DrawTabs(ATabIndex: Integer);
  var
    oColor: TColor;
    oRect: TRect;
  begin
    if ATabIndex <> FTabIndex then
      oColor := FColors.InactiveTabBG
    else
      oColor := Color;
    oRect := GetTabRect(ATabIndex);
    DrawBorder(oRect, oColor, ATabIndex);
    DrawTabImage(oRect, ATabIndex);
    DrawTabText(oRect, ATabIndex);
  end;

  procedure DrawTabArea;
  var
    oFillRect, oLine: TRect;
  begin
    oCache.Brush.Color := FColors.InactiveTabBG;
    oCache.Pen.Style := psSolid;
    oCache.Pen.Color := FColors.TabFG;
    case FPosition of
      tpBottom:
        begin
          oFillRect := Rect(0, ClientHeight - FTabHeight - C_TabOffsetY - 1,
                            ClientWidth, ClientHeight);
          oLine := oFillRect;
        end;
      tpTop:
        begin
          oFillRect := Rect(0, 0, ClientWidth, FTabHeight + C_TabOffsetY + 1);
          oLine := Rect(oFillRect.Left, oFillRect.Bottom, oFillRect.Right, oFillRect.Bottom);
        end;
    end;
    oCache.FillRect(oFillRect);
    oCache.MoveTo(oLine.Left, oLine.Top);
    oCache.LineTo(oLine.Right, oLine.Top);
  end;
  
  procedure DrawScrollerPlace;
  var
    oRect: TRect;
  begin
    with oCache do begin
      Brush.Style := bsSolid;
      Brush.Color := Color;
      Pen.Style := psSolid;
      Pen.Width := 1;
      oRect := FScroller.BoundsRect;
      oRect.Left := oRect.Left - C_TabOffsetX;
      oRect.Right := oRect.Right + C_TabStartOffsetX;
      case FPosition of
        tpBottom:
          begin
            oRect.Top := oRect.Top - C_TabOffsetY - 1;
            oRect.Bottom := oRect.Bottom + C_TabOffsetY;
            FillRect(oRect);
            Pen.Color := FColors.TabFG;
            MoveTo(oRect.Left, oRect.Top);
            LineTo(oRect.Left, oRect.Bottom - 1);
            LineTo(oRect.Right, oRect.Bottom - 1);
          end;
        tpTop:
          begin
            oRect.Top := oRect.Top - C_TabOffsetY;
            oRect.Bottom := oRect.Bottom + 2 * C_TabOffsetY;
            FillRect(oRect);
            Pen.Color := FColors.InactiveTabBG;
            MoveTo(oRect.Left, oRect.Bottom - 2);
            LineTo(oRect.Left, oRect.Top);
            LineTo(oRect.Right, oRect.Top);
          end;
      end;
    end;
  end;
  
begin
  oBmp := TBitmap.Create;
  try
    oBmp.Width := Width;
    oBmp.Height := Height;
    oCache := oBmp.Canvas;
    with oCache do begin
      Brush.Color := Color;
      FillRect(ClientRect);
    end;
    DrawTabArea;
    for i := FFirstTab to FLastTab do
      DrawTabs(i);
    if FScroller.Visible then
      DrawScrollerPlace;
    Canvas.Draw(0, 0, oBmp);
  finally
    oBmp.Free;
  end;
end;

{----------------------------------------------------------------------------}
function TADGUIxFormsTabControl.IndexOfTabAt(AX, AY: Integer): Integer;
var
  i: Integer;
  oRect: TRect;
begin
  for i := FFirstTab to FLastTab do begin
    oRect := GetTabRect(i);
    if PtInRect(oRect, Point(AX, AY)) then begin
      Result := i;
      Exit;
    end;
  end;
  Result := -1;
end;

{----------------------------------------------------------------------------}
procedure TADGUIxFormsTabControl.UpdateLayout;
var
  iW, iH: Integer;
begin
  if not (csLoading in ComponentState) then begin
    iW := Width;
    iH := Height;
    LockAlign;
    try
      UpdateTabHeight;
      CalculateTabs;
      CalcSize(iW, iH);
      SetBounds(Left, Top, iW, iH);
    finally
      UnLockAlign;
    end;
  end;
end;

{------------------------------------------------------------------------------}
{ TADGUIxFormsPageControl                                                      }
{------------------------------------------------------------------------------}
constructor TADGUIxFormsPageControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Style := tsFlatButtons;
  FFrameColor := clBtnShadow;
  FCaptionColor := clSkyBlue;
  FPanels := TList.Create;

  FPanelTitle := TADGUIxFormsPanel.Create(Self);
  FPanelTitle.Parent := Self;
  FPanelTitle.BevelOuter := bvNone;
  FPanelTitle.Color := FCaptionColor;
  if csDesigning in ComponentState then
    FPanelTitle.Align := alTop
  else
    FPanelTitle.Align := alNone;

  FPanelTitleLine := TADGUIxFormsPanel.Create(Self);
  FPanelTitleLine.Parent := FPanelTitle;
  FPanelTitleLine.Align := alBottom;
  FPanelTitleLine.BevelOuter := bvNone;
  FPanelTitleLine.Color := FFrameColor;
  FPanelTitleLine.Height := 1;
end;

{------------------------------------------------------------------------------}
destructor TADGUIxFormsPageControl.Destroy;
begin
  FreeAndNil(FPanels);
  inherited Destroy;
end;

{------------------------------------------------------------------------------}
procedure TADGUIxFormsPageControl.SetFrameColor(AValue: TColor);
begin
  if FFrameColor <> AValue then begin
    FFrameColor := AValue;
    FPanelTitleLine.Color := FFrameColor;
  end;
end;

{------------------------------------------------------------------------------}
procedure TADGUIxFormsPageControl.SetCaptionColor(AValue: TColor);
begin
  if FCaptionColor <> AValue then begin
    FCaptionColor := AValue;
    FPanelTitle.Color := FCaptionColor;
  end;
end;

{$IFDEF AnyDAC_D6}
{------------------------------------------------------------------------------}
procedure TADGUIxFormsPageControl.DoLabelMouseEnterHndlr(Sender: TObject);
begin
  if Sender is TLabel then begin
    TLabel(Sender).Font.Style := TLabel(Sender).Font.Style + [fsUnderline];
  end;
end;

{------------------------------------------------------------------------------}
procedure TADGUIxFormsPageControl.DoLabelMouseLeaveHndlr(Sender: TObject);
begin
  if Sender is TLabel then begin
    TLabel(Sender).Font.Style := TLabel(Sender).Font.Style - [fsUnderline];
  end;
end;
{$ENDIF}

{------------------------------------------------------------------------------}
procedure TADGUIxFormsPageControl.DoLabelClickHndlr(Sender: TObject);
var
  iTabIndex: Integer;
begin
  if Sender is TLabel then begin
    iTabIndex := Tabs.IndexOf(TLabel(Sender).Caption);
    if (iTabIndex <> -1) and (ActivePage <> TTabSheet(Tabs.Objects[iTabIndex])) then begin
      ActivePage := TTabSheet(Tabs.Objects[iTabIndex]);
      Change;
    end;
  end;
end;

{------------------------------------------------------------------------------}
procedure TADGUIxFormsPageControl.InsertPage(AIndex: Integer; const APageCaption: string);
var
  oContainerPanel: TADGUIxFormsPanel;
  oLabel: TLabel;
  iLeft: Integer;
begin
  iLeft := 0;
  if (AIndex > 0) and (FPanels.Count > 0) then begin
    if AIndex < FPanels.Count then
      iLeft := TADGUIxFormsPanel(FPanels[AIndex - 1]).Left + TADGUIxFormsPanel(FPanels[AIndex - 1]).Width
    else
      iLeft := TADGUIxFormsPanel(FPanels[FPanels.Count - 1]).Left + TADGUIxFormsPanel(FPanels[FPanels.Count - 1]).Width;
  end;

  FPanelTitle.DisableAlign;
  try
    oContainerPanel := TADGUIxFormsPanel.Create(Self);
    oContainerPanel.Align := alLeft;
    oContainerPanel.BevelOuter := bvNone;
    oContainerPanel.ParentColor := True;
    oContainerPanel.Parent := FPanelTitle;
    oContainerPanel.Left := iLeft;

    oLabel := TLabel.Create(Self);
    oLabel.AutoSize := True;
    oLabel.Parent := oContainerPanel;
    oLabel.Caption := APageCaption;
    oLabel.Cursor := crHandPoint;
    oLabel.Font.Color := clHotLight;

    if not (csDesigning in ComponentState) then begin
      oLabel.OnClick := DoLabelClickHndlr;
{$IFDEF AnyDAC_D6}
      oLabel.OnMouseEnter := DoLabelMouseEnterHndlr;
      oLabel.OnMouseLeave := DoLabelMouseLeaveHndlr;
{$ENDIF}      
    end;
  finally
    FPanelTitle.EnableAlign;
  end;
  FPanels.Insert(AIndex, oContainerPanel);
  UpdatePanel(AIndex);
end;

{------------------------------------------------------------------------------}
procedure TADGUIxFormsPageControl.UpdatePanel(AIndex: Integer);
var
  oPanel: TADGUIxFormsPanel;
  oLabel: TLabel;
  i: Integer;
begin
  if (AIndex >= 0) and (AIndex < FPanels.Count) then begin
    oPanel := TADGUIxFormsPanel(FPanels[AIndex]);
    oLabel := TLabel(oPanel.Controls[0]);
    if oLabel.Tag = 0 then begin
      oLabel.Font.Style := oLabel.Font.Style + [fsBold];
      oPanel.ClientWidth := oLabel.Width + 10;
      oPanel.ClientHeight := oLabel.Height + 10;
      oLabel.Left := 5;
      oLabel.Top := 5;
      oLabel.Tag := 1;
    end;
    if AIndex = TabIndex then
      oLabel.Font.Style := oLabel.Font.Style + [fsBold]
    else
      oLabel.Font.Style := oLabel.Font.Style - [fsBold];
  end
  else if AIndex = -1 then begin
    for i := 0 to FPanels.Count - 1 do
      UpdatePanel(i);
  end;
end;

{------------------------------------------------------------------------------}
procedure TADGUIxFormsPageControl.SetPageCaption(AIndex: Integer; const APageCaption: string);
begin
  with TLabel(TADGUIxFormsPanel(FPanels[AIndex]).Controls[0]) do begin
    Caption := APageCaption;
    Tag := 0;
  end;
  UpdatePanel(AIndex);
end;

{------------------------------------------------------------------------------}
procedure TADGUIxFormsPageControl.DeletePage(AIndex: Integer);
begin
  DisableAlign;
  try
    if AIndex <> -1 then begin
      TADGUIxFormsPanel(FPanels[AIndex]).Free;
      FPanels.Delete(AIndex);
    end
    else begin
      while FPanels.Count > 0 do begin
        TADGUIxFormsPanel(FPanels[0]).Free;
        FPanels.Delete(0);
      end;
    end;
  finally
    EnableAlign;
  end;
end;

{------------------------------------------------------------------------------}
procedure TADGUIxFormsPageControl.TCMInsertItem(var AMessage: TMessage);
var
  oTCItem: TTCItem;
begin
  inherited;
  oTCItem := PTCItem(AMessage.LParam)^;
  if oTCItem.mask and TCIF_TEXT <> 0 then
    InsertPage(AMessage.WParam, oTCItem.pszText);
end;

{------------------------------------------------------------------------------}
procedure TADGUIxFormsPageControl.TCMSetItem(var AMessage: TMessage);
var
  oTCItem: TTCItem;
begin
  inherited;
  oTCItem := PTCItem(AMessage.LParam)^;
  if oTCItem.mask and TCIF_TEXT <> 0 then
    SetPageCaption(AMessage.WParam, oTCItem.pszText);
end;

{------------------------------------------------------------------------------}
procedure TADGUIxFormsPageControl.TCMDeleteItem(var AMessage: TMessage);
begin
  inherited;
  DeletePage(AMessage.WParam);
end;

{------------------------------------------------------------------------------}
procedure TADGUIxFormsPageControl.TCMDeleteAllItem(var AMessage: TMessage);
begin
  inherited;
  DeletePage(-1);
end;

{$IFDEF AnyDAC_D7}
{------------------------------------------------------------------------------}
procedure TADGUIxFormsPageControl.SetTabIndex(AValue: Integer);
begin
  inherited SetTabIndex(AValue);
  UpdatePanel(-1);
end;

{$ELSE}
{------------------------------------------------------------------------------}
procedure TADGUIxFormsPageControl.TCMSetCurrItem(var AMessage: TMessage);
begin
  inherited;
  UpdatePanel(-1);
end;
{$ENDIF}

{------------------------------------------------------------------------------}
procedure TADGUIxFormsPageControl.WMSize(var AMessage: TMessage);
begin
  inherited;
  if not (csDesigning in ComponentState) then
    FPanelTitle.SetBounds(0, 0, ClientWidth, 26);
end;

{ --------------------------------------------------------------------------- }
{ TADGUIxFormsPanelTreeItem                                                   }
{ --------------------------------------------------------------------------- }
type
  TADGUIxFormsPanelTreeItem = class(TObject)
  private
    FTree: TADGUIxFormsPanelTree;
    FPanel: TADGUIxFormsPanel;
    FParent: TFrame;
    FMount: TADGUIxFormsPanel;
    FLbl: TLabel;
    FImg: TImage;
    FShp: TShape;
    FExpanded: Boolean;
    procedure BuildGroup;
    procedure BuildPanelMount;
    procedure DoExpandClicked(ASender: TObject);
    procedure DoPanelEnter(ASender: TObject);
    procedure DoPanelExit(ASender: TObject);
    procedure DoBtnEnter(ASender: TObject);
    procedure DoBtnExit(ASender: TObject);
    procedure DoBtnKeyPressed(ASender: TObject; var AKey: Char);
    procedure ChangeState(AExpand: Boolean);
  protected
    procedure Build;
  public
    constructor Create(APanel: TCustomPanel; AFrame: TCustomFrame;
      ATree: TADGUIxFormsPanelTree);
    destructor Destroy; override;
  end;

{ --------------------------------------------------------------------------- }
constructor TADGUIxFormsPanelTreeItem.Create(APanel: TCustomPanel;
  AFrame: TCustomFrame; ATree: TADGUIxFormsPanelTree);
begin
  inherited Create;
  FTree := ATree;
  FParent := TFrame(AFrame);
  FPanel := TADGUIxFormsPanel(APanel);
  if not (csLoading in ATree.ComponentState) then
    Build;
end;

{ --------------------------------------------------------------------------- }
destructor TADGUIxFormsPanelTreeItem.Destroy;
begin
  FPanel.Enabled := True;
  FPanel.Visible := False;
  if FParent <> nil then begin
    FParent.Hint := FLbl.Caption;
    FPanel.Parent := FParent;
  end
  else begin
    FPanel.Caption := FLbl.Caption;
    FPanel.Parent := FTree;
  end;
  FreeAndNil(FMount);
  FTree := nil;
  FPanel := nil;
  FParent := nil;
  FLbl := nil;
  FImg := nil;
  FShp := nil;
  inherited Destroy;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsPanelTreeItem.Build;
begin
  FTree.FLock := True;
  try
    if FPanel <> nil then
      BuildPanelMount
    else if FParent <> nil then
      BuildGroup;
  finally
    FTree.FLock := False;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsPanelTreeItem.BuildGroup;
begin
  FMount := TADGUIxFormsPanel.Create(FTree);
  FMount.Visible := False;
  FMount.Parent := FTree;
  FMount.Parent := FTree;
  FMount.Tag := LongWord(Self);
  FMount.Height := CMountMinHeight;
  FMount.Align := alTop;
  FMount.ParentColor := True;
  FMount.BevelInner := bvNone;
  FMount.BevelOuter := bvNone;

  FLbl := TLabel.Create(FMount);
  FLbl.Parent := FMount;
  FLbl.AutoSize := False;
  FLbl.SetBounds(CHorizSpace0 + CHorizSpace1, CVertSpace0,
    FMount.ClientWidth - (CHorizSpace0 + CHorizSpace1), CMountMinHeight);
  FLbl.Caption := FParent.Hint;
  FParent.Hint := '';
  FLbl.Font.Style := FLbl.Font.Style + [fsBold];
  FLbl.Anchors := [akTop, akLeft, akRight];
  FParent.Visible := False;

  FMount.Visible := True;
end;

type
  __TWinControl = class(TWinControl);
  
{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsPanelTreeItem.BuildPanelMount;
var
  oPnl: TADGUIxFormsPanel;
begin
  FMount := TADGUIxFormsPanel.Create(FTree);
  FMount.Visible := False;
  FMount.Parent := FTree;
  FMount.BevelInner := bvNone;
  FMount.BevelOuter := bvNone;
  FMount.Height := CMountMinHeight;
  FMount.Align := alTop;
  FMount.ParentColor := True;
  FMount.Tag := LongWord(Self);
  FMount.OnEnter := DoPanelEnter;
  FMount.OnExit := DoPanelExit;

  oPnl := TADGUIxFormsPanel.Create(FMount);
  oPnl.Parent := FMount;
  oPnl.BevelInner := bvNone;
  oPnl.BevelOuter := bvNone;
  oPnl.SetBounds(CHorizSpace0, 2, CHorizSpace1 + CButtonWidth + CHorizSpace1,
    CVertSpace0 + CButtonHeight + CVertSpace0);
  oPnl.Anchors := [akTop, akLeft];
  oPnl.TabStop := True;
  oPnl.ParentColor := True;
  oPnl.OnEnter := DoBtnEnter;
  oPnl.OnExit := DoBtnExit;
  __TWinControl(oPnl).OnKeyPress := DoBtnKeyPressed;

  FShp := TShape.Create(oPnl);
  FShp.Parent := oPnl;
  FShp.Align := alClient;
  FShp.Shape := stRoundRect;
  FShp.Brush.Style := bsClear;
  FShp.Pen.Style := psDot;
  FShp.Visible := False;

  FImg := TImage.Create(oPnl);
  FImg.Parent := oPnl;
  FImg.SetBounds(CHorizSpace1, CVertSpace0, CButtonWidth, CButtonHeight);
  FImg.OnClick := DoExpandClicked;
  FImg.Picture.Bitmap.LoadFromResourceName(HInstance, CPlusBitmap);

  FLbl := TLabel.Create(FMount);
  FLbl.Parent := FMount;
  FLbl.AutoSize := False;
  FLbl.SetBounds(CHorizSpace0 + CHorizSpace1 + CButtonWidth + CHorizSpace0 + CHorizSpace1,
    CVertSpace0, FMount.ClientWidth - (CHorizSpace0 + CHorizSpace1 + CButtonWidth +
    CHorizSpace0 + CHorizSpace1), CMountMinHeight);
  FLbl.Caption := FPanel.Caption;
  FPanel.Caption := '';
  FLbl.Font.Style := FLbl.Font.Style + [fsBold];
  FLbl.Anchors := [akTop, akLeft, akRight];

  FPanel.Parent := FMount;
  FPanel.BevelInner := bvNone;
  FPanel.BevelOuter := bvNone;
  FPanel.Anchors := [akTop, akLeft, akRight];
  FPanel.SetBounds(
    FLbl.Left, FLbl.Top + FLbl.Height,
    FPanel.Width, FPanel.Height);
  FPanel.Enabled := False;
  FPanel.Visible := False;

  FMount.Visible := True;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsPanelTreeItem.ChangeState(AExpand: Boolean);
begin
  if (FExpanded = AExpand) or (FPanel = nil) then
    Exit;
  FExpanded := AExpand;
  if FExpanded then begin
    FPanel.Visible := True;
    FPanel.Enabled := True;
    FMount.Height := FMount.Height + FPanel.Height + 3;
    FImg.Picture.Bitmap.LoadFromResourceName(HInstance, CMinusBitmap);
  end
  else begin
    FPanel.Visible := False;
    FPanel.Enabled := False;
    FMount.Height := FMount.Height - FPanel.Height - 3;
    FImg.Picture.Bitmap.LoadFromResourceName(HInstance, CPlusBitmap);
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsPanelTreeItem.DoExpandClicked(ASender: TObject);
begin
  ChangeState(not FExpanded);
  FImg.Parent.SetFocus;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsPanelTreeItem.DoPanelEnter(ASender: TObject);
begin
  FLbl.Font.Color := clHotLight;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsPanelTreeItem.DoPanelExit(ASender: TObject);
begin
  FLbl.Font.Color := clWindowText;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsPanelTreeItem.DoBtnEnter(ASender: TObject);
begin
  FShp.Visible := True;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsPanelTreeItem.DoBtnExit(ASender: TObject);
begin
  FShp.Visible := False;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsPanelTreeItem.DoBtnKeyPressed(ASender: TObject; var AKey: Char);
begin
  if (AKey = ' ') or
     (AKey = '+') and not FExpanded or
     (AKey = '-') and FExpanded then begin
    DoExpandClicked(nil);
    AKey := #0;
  end
  else if AKey = '*' then begin
    FTree.ChangeAllState(True);
    AKey := #0;
  end
  else if AKey = '/' then begin
    FTree.ChangeAllState(False);
    AKey := #0;
  end;
end;

{ --------------------------------------------------------------------------- }
{ TADGUIxFormsPanelTree                                                       }
{ --------------------------------------------------------------------------- }
constructor TADGUIxFormsPanelTree.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPanels := TList.Create;
  BevelInner := bvSpace;
  BevelKind := bkFlat;
  BorderStyle := bsNone;
  Ctl3D := True;
  ParentCtl3D := False;
  Caption := '';
  VertScrollBar.Style := ssFlat;
  VertScrollBar.Tracking := True;
  VertScrollBar.Smooth := False;
  HorzScrollBar.Style := ssFlat;
  HorzScrollBar.Tracking := True;
  HorzScrollBar.Smooth := False;
end;

{ --------------------------------------------------------------------------- }
destructor TADGUIxFormsPanelTree.Destroy;
begin
  FreeAndNil(FPanels);
  inherited Destroy;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsPanelTree.Loaded;
var
  i: Integer;
begin
  inherited Loaded;
  DisableAlign;
  try
    for i := 0 to FPanels.Count - 1 do
      TADGUIxFormsPanelTreeItem(FPanels[i]).Build;
  finally
    EnableAlign;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsPanelTree.CMControlChange(var Message: TMessage);
var
  i: Integer;
  oCtrl, oCtrl2: TControl;
  lInserted: Boolean;
begin
  inherited;
  oCtrl := TControl(Message.WParam);
  lInserted := Boolean(Message.LParam);

  if (csDesigning in ComponentState) or FLock or
     (oCtrl.Parent <> Self) then
    Exit;

  if oCtrl is TCustomPanel then begin
    if lInserted then
      FPanels.Add(TADGUIxFormsPanelTreeItem.Create(TCustomPanel(oCtrl), nil, Self))
    else
      for i := 0 to FPanels.Count - 1 do
        if TADGUIxFormsPanelTreeItem(FPanels[i]).FPanel = oCtrl then begin
          TADGUIxFormsPanelTreeItem(FPanels[i]).Free;
          FPanels.Delete(i);
          Break;
        end;
  end
  else if oCtrl is TCustomFrame then begin
    if lInserted then begin
      FPanels.Add(TADGUIxFormsPanelTreeItem.Create(nil, TCustomFrame(oCtrl), Self));
      for i := 0 to TCustomFrame(oCtrl).ControlCount - 1 do begin
        oCtrl2 := TCustomFrame(oCtrl).Controls[i];
        if oCtrl2 is TCustomPanel then
          FPanels.Add(TADGUIxFormsPanelTreeItem.Create(TCustomPanel(oCtrl2), TCustomFrame(oCtrl), Self));
      end;
    end
    else
      for i := 0 to FPanels.Count - 1 do
        if TADGUIxFormsPanelTreeItem(FPanels[i]).FParent = oCtrl then begin
          TADGUIxFormsPanelTreeItem(FPanels[i]).Free;
          FPanels.Delete(i);
        end;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsPanelTree.CMEnabledChanged(var Message: TMessage);
var
  i: Integer;
begin
  inherited;
  for i := 0 to FPanels.Count - 1 do
    with TADGUIxFormsPanelTreeItem(FPanels[i]) do
      if not Enabled then
        FLbl.Font.Color := clGray
      else
        FLbl.Font.Color := clWindowText;
end;

{ --------------------------------------------------------------------------- }
function TADGUIxFormsPanelTree.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
  MousePos: TPoint): Boolean;
var
  iMsg, iCode: Cardinal;
begin
  Result := inherited DoMouseWheel(Shift, WheelDelta, MousePos);
  if FLock then
    Exit;
  if ssShift in Shift then
    iMsg := WM_HSCROLL
  else
    iMsg := WM_VSCROLL;
  if WheelDelta < 0 Then
    iCode := SB_LINEDOWN
  else
    iCode := SB_LINEUP;
  Perform(iMsg, iCode, 0);
  Perform(iMsg, SB_ENDSCROLL, 0);
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsPanelTree.ChangeAllState(AExpand: Boolean);
var
  i: Integer;
begin
  for i := 0 to FPanels.Count - 1 do
    TADGUIxFormsPanelTreeItem(FPanels[i]).ChangeState(AExpand);
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsPanelTree.LoadState(AReg: TRegistry);
var
  i: Integer;
  s: String;
begin
  s := AReg.ReadString(Name);
  for i := 1 to Length(s) do
    TADGUIxFormsPanelTreeItem(FPanels[i - 1]).ChangeState(s[i] = 'X');
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsPanelTree.SaveState(AReg: TRegistry);
var
  i: Integer;
  s: String;
begin
  SetLength(s, FPanels.Count);
  for i := 1 to FPanels.Count do
    if TADGUIxFormsPanelTreeItem(FPanels[i - 1]).FExpanded then
      s[i] := 'X'
    else
      s[i] := ' ';
  AReg.WriteString(Name, s);
end;

{ --------------------------------------------------------------------------- }
{ --------------------------------------------------------------------------- }
type
  TADGUIxFormsListViewItemType = (itString, itInteger, itFloat, itSet);
  TADGUIxFormsListViewItemInfo = class(TObject)
  private
    FType: TADGUIxFormsListViewItemType;
    FList: TStrings;
    FValue: string;
    FIndex: Integer;
    procedure SetValue(const AValue: string);
  public
    constructor Create(const AValue: string); overload;
    constructor Create(const AValue: Boolean); overload;
    constructor Create(const AValue: Integer); overload;
    constructor Create(const AValue: Double); overload;
    constructor Create(const AValues: TStrings; AIndex: Integer); overload;
    destructor Destroy; override;
    property Value: string read FValue write SetValue;
    property Values: TStrings read FList;
    property Index: Integer read FIndex;
  end;

{------------------------------------------------------------------------------}
{ TADGUIxFormsListViewItemInfo
{------------------------------------------------------------------------------}
constructor TADGUIxFormsListViewItemInfo.Create(const AValue: string);
begin
  FType := itString;
  FValue := AValue;
  FIndex := -1;
end;

{------------------------------------------------------------------------------}
constructor TADGUIxFormsListViewItemInfo.Create(const AValue: Boolean);
begin
  FType := itSet;
  FList := TStringList.Create;
  FList.Add(S_AD_True);
  FList.Add(S_AD_False);
  FValue := S_AD_Bools[AValue];
  if AValue then
    FIndex := 0
  else
    FIndex := 1;
end;

{------------------------------------------------------------------------------}
constructor TADGUIxFormsListViewItemInfo.Create(const AValue: Integer);
begin
  FType := itInteger;
  FValue := IntToStr(AValue);
  FIndex := -1;
end;

{------------------------------------------------------------------------------}
constructor TADGUIxFormsListViewItemInfo.Create(const AValue: Double);
begin
  FType := itFloat;
  FValue := FloatToStr(AValue);
  FIndex := -1;
end;

{------------------------------------------------------------------------------}
constructor TADGUIxFormsListViewItemInfo.Create(const AValues: TStrings; AIndex: Integer);
begin
  FType := itSet;
  FList := TStringList.Create;
  FList.AddStrings(AValues);
  FIndex := AIndex;
  if FIndex <> -1 then
    FValue := FList[FIndex];
end;

{------------------------------------------------------------------------------}
destructor TADGUIxFormsListViewItemInfo.Destroy;
begin
  FreeAndNil(FList);
  inherited Destroy;
end;

{------------------------------------------------------------------------------}
procedure TADGUIxFormsListViewItemInfo.SetValue(const AValue: string);
var
  i: Integer;
begin
  if FValue <> AValue then begin
    case FType of
      itInteger:
      begin
        StrToInt(AValue);
        FValue := AValue;
      end;
      itFloat:
      begin
        StrToFloat(AValue);
        FValue := AValue;
      end;
      itSet:
      begin
        i := FList.IndexOf(AValue);
        if i <> -1 then begin
          FIndex := i;
          FValue := AValue;
        end;
      end;
      else
        FValue := AValue;
    end;
  end;
end;

{$IFNDEF AnyDAC_D6}
{------------------------------------------------------------------------------}
{ TADGUIxFormsListView
{------------------------------------------------------------------------------}
constructor TADGUIxFormsListView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEdit := TEdit.Create(Self);
  FEdit.OnKeyDown := DoEditKeyDownHndlr;

  FCombo := TComboBox.Create(Self);
  FCombo.Style := csDropDownList;
  FCombo.OnKeyDown := DoComboKeyDownHndlr;

  FColumnToEdit := -1;
  FEditItemIndex := -1;
  FColumnEditWidth := 0;
  FComCtrl32Version := 0;
  FGetColumnAt := nil;
  FGetColumnRect := nil;
  FGetIndexesAt := nil;
  if GetComCtl32Version >= DWORD(MakeLong(4, 70)) then begin
    FGetColumnAt := ComCtl_GetColumnAt;
    FGetColumnRect := ComCtl_GetColumnRect;
    FGetIndexesAt := ComCtl_GetIndexesAt;
  end
  else begin
    FGetColumnAt := Manual_GetColumnAt;
    FGetColumnRect := Manual_GetColumnRect;
    FGetIndexesAt := Manual_GetIndexesAt;
  end;

  FAlwaysShowEditor := True;
  BevelInner := bvSpace;
  BevelKind := bkFlat;
  BorderStyle := bsNone;
  Columns.Add.Width := 100;
  Columns.Add.Width := 100;
  GridLines := True;
  OwnerDraw := True;
  ShowColumnHeaders := False;
  ViewStyle := vsReport;
end;

{------------------------------------------------------------------------------}
function TADGUIxFormsListView.GetValue(const AName: string): string;
var
  i: Integer;
begin
  i := IndexOf(AName);
  if i <> -1 then
    Result := TADGUIxFormsListViewItemInfo(Items[i].SubItems.Objects[0]).Value
  else
    Result := '';
end;

{------------------------------------------------------------------------------}
function TADGUIxFormsListView.GetValueIndex(const AName: string): Integer;
var
  i: Integer;
begin
  i := IndexOf(AName);
  if i <> -1 then
    Result := TADGUIxFormsListViewItemInfo(Items[i].SubItems.Objects[0]).Index
  else
    Result := -1;
end;

{------------------------------------------------------------------------------}
function TADGUIxFormsListView.GetComCtl32Version: DWORD;

type
  DLLVERSIONINFO = record
    cbSize: DWORD;
    dwMajorVersion: DWORD;
    dwMinorVersion: DWORD;
    dwBuildNumber: DWORD;
    dwPlatformID: DWORD;
  end;

  TDllGetVersionProc = function(var VerInfo: DLLVERSIONINFO): Integer; stdcall;

var
  hComCtrl32: HMODULE;
  DllGetVersion: TDllGetVersionProc;
  VersionInfo: DLLVERSIONINFO;
  aFileName: array[0..MAX_PATH - 1] of Char;
  dwHandle: DWORD;
  dwSize: DWORD;
  pData: Pointer;
  pVersion: Pointer;
  iLen: UINT;
begin
  if FComCtrl32Version = 0 then begin
    hComCtrl32 := GetModuleHandle('comctl32.dll');
    if hComCtrl32 <> 0 then begin
      @DllGetVersion := GetProcAddress(hComCtrl32, 'DllGetVersion');
      if @DllGetVersion <> nil then begin
        FillChar(VersionInfo, SizeOf(DLLVERSIONINFO), 0);
        if DllGetVersion(VersionInfo) >= 0 then
          FComCtrl32Version := MakeLong(Word(VersionInfo.dwMajorVersion), Word(VersionInfo.dwMinorVersion));
      end;
    end;

    if FComCtrl32Version = 0 then begin
      FillChar(aFileName, SizeOf(aFileName), 0);
      if GetModuleFileName(hComCtrl32, aFileName, MAX_PATH) <> 0 then begin
        dwHandle := 0;
        dwSize := GetFileVersionInfoSize(aFileName, dwHandle);
        if dwSize <> 0 then begin
          pData := GlobalAllocPtr(GPTR, dwSize);
          try
            if (pData <> nil) and GetFileVersionInfo(aFileName, dwHandle, dwSize, pData) then begin
              pVersion := nil;
              iLen := 0;
              if VerQueryValue(pData, '\', pVersion, iLen) then begin
                with PVSFixedFileInfo(pVersion)^ do
                  FComCtrl32Version := MakeLong(Word(dwFileVersionMS), Word(dwFileVersionLS));
              end;
            end;
          finally
            GlobalFreePtr(pData);
          end;
        end;
      end;
    end;
  end;
  Result := FComCtrl32Version;
end;

{------------------------------------------------------------------------------}
function TADGUIxFormsListView.Manual_GetIndexesAt(const APoint: TPoint; var ACoord: TListViewCoord): Boolean;
var
  oItem: TListItem;
begin
  oItem := GetItemAt(APoint.x, APoint.y);
  if oItem <> nil then begin
    ACoord.Item := oItem.Index;
    ACoord.Column := Manual_GetColumnAt(oItem, APoint);
    Result := True;
  end
  else
    Result := False;
end;

{------------------------------------------------------------------------------}
function TADGUIxFormsListView.Manual_GetColumnAt(AItem: TListItem; const APoint: TPoint): Integer;
var
  oRect: TRect;
  i: Integer;
begin
  oRect := AItem.DisplayRect(drBounds);
  for i := 0 to Columns.Count - 1 do begin
    oRect.Right := (oRect.Left + Columns[i].Width);
    if PtInRect(oRect, APoint) then begin
      Result := i;
      Exit;
    end;
    oRect.Left := oRect.Right;
  end;
  Result := -1;
end;

{------------------------------------------------------------------------------}
function TADGUIxFormsListView.Manual_GetColumnRect(AItem: TListItem; AColumnIndex: Integer; var ARect: TRect): Boolean;
var
  i: Integer;
begin
  if (AColumnIndex < 0) or (AColumnIndex >= Columns.Count) then begin
    Result := False;
    Exit;
  end;

  ARect := AItem.DisplayRect(drBounds);
  for i := 0 to AColumnIndex - 1 do
    ARect.Left := ARect.Left + Columns[i].Width;
  ARect.Right := ARect.Left + Columns[AColumnIndex].Width;

  Result := True;
end;

{------------------------------------------------------------------------------}
function TADGUIxFormsListView.ComCtl_GetColumnAt(AItem: TListItem; const APoint: TPoint): Integer;
var
  oHitTest: TLVHitTestInfo;
begin
  Result := -1;

  FillChar(oHitTest, SizeOf(oHitTest), 0);
  oHitTest.pt := APoint;

  if (ListView_SubItemHitTest(Handle, @oHitTest) > -1) and (oHitTest.iItem = AItem.Index) then
    Result := oHitTest.iSubItem;
end;

{------------------------------------------------------------------------------}
function TADGUIxFormsListView.ComCtl_GetColumnRect(AItem: TListItem; AColumnIndex: Integer; var ARect: TRect): Boolean;
begin
  Result := ListView_GetSubItemRect(Handle, AItem.Index, AColumnIndex, LVIR_BOUNDS, @ARect);
end;

{------------------------------------------------------------------------------}
function TADGUIxFormsListView.ComCtl_GetIndexesAt(const APoint: TPoint; var ACoord: TListViewCoord): Boolean;
var
  oHitTest: TLVHitTestInfo;
begin
  FillChar(oHitTest, SizeOf(oHitTest), 0);
  oHitTest.pt := APoint;

  if ListView_SubItemHitTest(Handle, @oHitTest) > -1 then begin
    ACoord.Item := oHitTest.iItem;
    ACoord.Column := oHitTest.iSubItem;
    Result := True;
  end
  else
    Result := False;
end;

{------------------------------------------------------------------------------}
procedure TADGUIxFormsListView.DoEditKeyDownHndlr(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  case AKey of
    VK_RETURN:
      Edited;
    VK_ESCAPE:
      CancelEdit;
    VK_UP:
      if Selected <> nil then begin
        Edited;
        if Selected.Index > 0 then
          ItemIndex := ItemIndex - 1;
      end;
    VK_DOWN:
      if Selected <> nil then begin
        Edited;
        if Selected.Index < Items.Count - 1 then
          ItemIndex := ItemIndex + 1;
      end;
  end;
end;

{------------------------------------------------------------------------------}
procedure TADGUIxFormsListView.DoComboKeyDownHndlr(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  case AKey of
    VK_RETURN:
      Edited;
    VK_ESCAPE:
      CancelEdit;
    VK_UP:
      if not FCombo.DroppedDown and not (ssAlt in AShift) and (Selected <> nil) then begin
        Edited;
        if Selected.Index > 0 then
          ItemIndex := ItemIndex - 1;
      end;
    VK_DOWN:
      if not FCombo.DroppedDown and not (ssAlt in AShift) and (Selected <> nil) then begin
        Edited;
        if Selected.Index < Items.Count - 1 then
          ItemIndex := ItemIndex + 1;
      end;
  end;
end;

{------------------------------------------------------------------------------}
procedure TADGUIxFormsListView.DoExitHndlr(Sender: TObject);
begin
  Edited;
end;

{------------------------------------------------------------------------------}
procedure TADGUIxFormsListView.DoBeforeEdit(var AEditedValue: string);
begin
  if Assigned(FBeforeEdit) then
    FBeforeEdit(Self, FEditItemIndex, AEditedValue);
end;

{------------------------------------------------------------------------------}
procedure TADGUIxFormsListView.DoAfterEdit;
begin
  if Assigned(FAfterEdit) then
    FAfterEdit(Self, FEditItemIndex);
end;

{------------------------------------------------------------------------------}
function TADGUIxFormsListView.IndexOf(const AName: string): Integer;
var
  i: Integer;
begin
  for i := 0 to Items.Count - 1 do
    if Items[i].Caption = AName then begin
      Result := i;
      Exit;
    end;
  Result := -1;
end;

{------------------------------------------------------------------------------}
procedure TADGUIxFormsListView.Edited;
var
  oItemInfo: TADGUIxFormsListViewItemInfo;
  sValue: string;
begin
  if (FEditControl <> nil) and (FColumnToEdit > 0) then begin
    oItemInfo := TADGUIxFormsListViewItemInfo(Items[FEditItemIndex].SubItems.Objects[FColumnToEdit - 1]);
    try
      sValue := __TWinControl(FEditControl).Text;
      if oItemInfo.FType = itString then
        DoBeforeEdit(sValue);
      oItemInfo.Value := sValue;
      Items[FEditItemIndex].SubItems[FColumnToEdit - 1] := oItemInfo.Value;
    finally
      CancelEdit;
    end;
  end;
end;

{------------------------------------------------------------------------------}
procedure TADGUIxFormsListView.CancelEdit;
begin
  if FEditControl <> nil then begin
    FEditControl.Parent := nil;
    __TWinControl(FEditControl).OnExit := nil;
    FEditControl := nil;
    SetFocus;
    DoAfterEdit;
  end;
  FEditItemIndex := -1;
end;

{------------------------------------------------------------------------------}
function TADGUIxFormsListView.CanEdit(AItem: TListItem): Boolean;
var
  oRect: TRect;
  oItemInfo: TADGUIxFormsListViewItemInfo;
begin
  Result := False;
  if FColumnToEdit <= 0 then
    Exit;

  oItemInfo := TADGUIxFormsListViewItemInfo(AItem.SubItems.Objects[0]);
  if oItemInfo.FType <> itSet then begin
    FEdit.Parent := Self;
    FEditControl := FEdit;
  end
  else begin
    FCombo.Parent := Self;
    FCombo.Clear;
    FCombo.Items.AddStrings(oItemInfo.Values);
    FCombo.ItemIndex := oItemInfo.Index;
    FEditControl := FCombo;
  end;

  if not FGetColumnRect(AItem, FColumnToEdit, oRect) then
    Exit;
  FEditItemIndex := AItem.Index;
  FColumnEditWidth := oRect.Right - oRect.Left;
  oRect.Top := oRect.Top - 1;
  FEditControl.SetBounds(oRect.Left, oRect.Top, FColumnEditWidth, oRect.Bottom - oRect.Top);
  if FEditControl.Height > oRect.Bottom - oRect.Top then
    FEditControl.Top := oRect.Top - (FEditControl.Height - oRect.Bottom + oRect.Top) div 2;

  __TWinControl(FEditControl).Text := AItem.SubItems[FColumnToEdit - 1];
  __TWinControl(FEditControl).OnExit := DoExitHndlr;

  FEditControl.SetFocus;
end;

{------------------------------------------------------------------------------}
procedure TADGUIxFormsListView.MouseDown(AButton: TMouseButton; AShift: TShiftState; AX, AY: Integer);
var
  oCoord: TListViewCoord;
begin
  inherited MouseDown(AButton, AShift, AX, AY);
  if not IsEditing then begin
    if FGetIndexesAt(Point(AX, AY), oCoord) then begin
      if (oCoord.Column <> FColumnToEdit) or (FEditItemIndex <> oCoord.Item) then begin
        FColumnToEdit := oCoord.Column;
        Invalidate;
      end;
    end
    else
      FColumnToEdit := -1;
  end;
end;

{------------------------------------------------------------------------------}
procedure TADGUIxFormsListView.MouseUp(AButton: TMouseButton; AShift: TShiftState; AX, AY: Integer);
begin
  inherited MouseUp(AButton, AShift, AX, AY);
  if FEnterEditing and (Selected <> nil) then begin
    FEnterEditing := False;
    Selected.EditCaption;
  end;
end;

{------------------------------------------------------------------------------}
procedure TADGUIxFormsListView.Delete(AItem: TListItem);
begin
  if {not AItem.Deleting and} (AItem.SubItems.Count > 0) and
     (AItem.SubItems.Objects[0] <> nil) then begin
    AItem.SubItems.Objects[0].Free;
    AItem.SubItems.Objects[0] := nil;
  end;
  inherited Delete(AItem);
end;

{------------------------------------------------------------------------------}
procedure TADGUIxFormsListView.DoEnter;
begin
  if Items.Count > 0 then begin
    if ItemIndex = -1 then begin
      ItemIndex := 0;
      Items[0].Focused := True;
    end;
    if FColumnToEdit = -1 then begin
      FColumnToEdit := 0;
      Invalidate;
    end;
  end;
  inherited DoEnter;
end;

{------------------------------------------------------------------------------}
procedure TADGUIxFormsListView.DrawItem(AItem: TListItem; ARect: TRect; AState: TOwnerDrawState);
var
  oRect: TRect;
  i: Integer;
  sTmp: string;
begin
  oRect := AItem.DisplayRect(drBounds);
  Canvas.Brush.Color := Color;
  Canvas.FillRect(oRect);

  for i := 0 to Columns.Count - 1 do begin
    if not FGetColumnRect(AItem, i, oRect) then
      Continue;

    if (AItem.Selected) and (i = FColumnToEdit) and (not IsEditing) and Focused then begin
      Canvas.Brush.Color := clHighlight;
      Canvas.Font.Color := clHighlightText;
    end
    else begin
      Canvas.Brush.Color := Color;
      Canvas.Font.Color := Font.Color;
    end;

    Canvas.FillRect(oRect);

    if i = 0 then
      sTmp := AItem.Caption
    else begin
      if i <= AItem.SubItems.Count then
        sTmp := AItem.SubItems[i - 1]
      else
        sTmp := '';
    end;
    Canvas.TextRect(oRect, oRect.Left + 4, oRect.Top, sTmp);
  end;
end;

{------------------------------------------------------------------------------}
procedure TADGUIxFormsListView.KeyDown(var AKey: Word; AShift: TShiftState);
begin
  inherited KeyDown(AKey, AShift);
  if not IsEditing then begin
    case AKey of
      VK_LEFT:
        if FColumnToEdit > 0 then begin
          Dec(FColumnToEdit);
          Invalidate;
        end;
      VK_RIGHT:
        if FColumnToEdit < Columns.Count - 1 then begin
          Inc(FColumnToEdit);
          Invalidate;
        end;
      VK_F2:
        if Selected <> nil then
          ListView_EditLabel(Handle, Selected.Index);
    end;
  end;
end;

{------------------------------------------------------------------------------}
procedure TADGUIxFormsListView.KeyUp(var AKey: Word; AShift: TShiftState);
begin
  inherited KeyUp(AKey, AShift);
  if FEnterEditing and (Selected <> nil) then begin
    FEnterEditing := False;
    Selected.EditCaption;
  end;
end;

{------------------------------------------------------------------------------}
function TADGUIxFormsListView.IsEditing: Boolean;
begin
  Result := FEditControl <> nil;
end;

{------------------------------------------------------------------------------}
procedure TADGUIxFormsListView.AddValue(const AItemName, AValue: string);
var
  oItemInfo: TADGUIxFormsListViewItemInfo;
begin
  with Items.Add do begin
    Caption := AItemName;
    oItemInfo := TADGUIxFormsListViewItemInfo.Create(AValue);
    SubItems.AddObject(oItemInfo.Value, oItemInfo);
  end;
end;

{------------------------------------------------------------------------------}
procedure TADGUIxFormsListView.AddIntegerValue(const AItemName: string; AValue: Integer);
var
  oItemInfo: TADGUIxFormsListViewItemInfo;
begin
  with Items.Add do begin
    Caption := AItemName;
    oItemInfo := TADGUIxFormsListViewItemInfo.Create(AValue);
    SubItems.AddObject(oItemInfo.Value, oItemInfo);
  end;
end;

{------------------------------------------------------------------------------}
procedure TADGUIxFormsListView.AddFloatValue(const AItemName: string; AValue: Double);
var
  oItemInfo: TADGUIxFormsListViewItemInfo;
begin
  with Items.Add do begin
    Caption := AItemName;
    oItemInfo := TADGUIxFormsListViewItemInfo.Create(AValue);
    SubItems.AddObject(oItemInfo.Value, oItemInfo);
  end;
end;

{------------------------------------------------------------------------------}
procedure TADGUIxFormsListView.AddBooleanValue(const AItemName: string; AValue: Boolean);
var
  oItemInfo: TADGUIxFormsListViewItemInfo;
begin
  with Items.Add do begin
    Caption := AItemName;
    oItemInfo := TADGUIxFormsListViewItemInfo.Create(AValue);
    SubItems.AddObject(oItemInfo.Value, oItemInfo);
  end;
end;

{------------------------------------------------------------------------------}
procedure TADGUIxFormsListView.AddValues(const AItemName: string; AValues: TStrings; AIndex: Integer);
var
  oItemInfo: TADGUIxFormsListViewItemInfo;
begin
  with Items.Add do begin
    Caption := AItemName;
    oItemInfo := TADGUIxFormsListViewItemInfo.Create(AValues, AIndex);
    SubItems.AddObject(oItemInfo.Value, oItemInfo);
  end;
end;

{------------------------------------------------------------------------------}
procedure TADGUIxFormsListView.CNNotify(var Message: TWMNotify);
begin
  inherited;
  with PNMListView(Message.NMHdr)^ do
    if (Message.NMHdr^.code = LVN_ITEMCHANGED) and (uChanged = LVIF_STATE) and
       (uOldState and LVIS_SELECTED = 0) and (uNewState and LVIS_SELECTED <> 0) and
       AlwaysShowEditor and (FColumnToEdit = 1) and (Selected <> nil) then
      FEnterEditing := True;
end;

{------------------------------------------------------------------------------}
function TADGUIxFormsListView.GetItemIndex: Integer;
begin
  Result := -1;
  if Selected <> nil then
    Result := Selected.Index;
end;

{------------------------------------------------------------------------------}
procedure TADGUIxFormsListView.SetItemIndex(const Value: Integer);
begin
  if Value < 0 then
  begin
    if Selected <> nil then
      Selected.Selected := False
  end
  else
    Items[Value].Selected := True;
end;

{$ELSE}
{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}

constructor TADGUIxFormsListView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DisplayOptions := DisplayOptions - [doColumnTitles];
  FSaveCellExtents := False;
  TStringList(Items).OnChanging := DoChanging;
  TStringList(Items).OnChange := DoChanged;
end;

{------------------------------------------------------------------------------}
procedure TADGUIxFormsListView.DoChanging(ASender: TObject);
begin
  FLockUpdate := True;
end;

{------------------------------------------------------------------------------}
procedure TADGUIxFormsListView.DoChanged(ASender: TObject);
begin
  FLockUpdate := False;
end;

{------------------------------------------------------------------------------}
function TADGUIxFormsListView.GetIsEditing: Boolean;
begin
  Result := EditorMode;
end;

{------------------------------------------------------------------------------}
function TADGUIxFormsListView.GetItems: TStrings;
begin
  Result := Strings;
end;

{------------------------------------------------------------------------------}
function TADGUIxFormsListView.GetEditText(ACol, ARow: Longint): string;
begin
  Result := inherited GetEditText(ACol, ARow);
  if Assigned(FBeforeEdit) and not FLockUpdate then
    FBeforeEdit(Self, ARow - FixedRows, Result);
end;

{------------------------------------------------------------------------------}
procedure TADGUIxFormsListView.SetEditText(ACol, ARow: Longint; const AValue: string);
begin
  inherited SetEditText(ACol, ARow, AValue);
  if Assigned(FAfterEdit) and not FLockUpdate then
    FAfterEdit(Self, ARow - FixedRows);
end;

{------------------------------------------------------------------------------}
procedure TADGUIxFormsListView.AddValue(const AItemName, AValue: string);
begin
  InsertRow(AItemName, AValue, True);
end;

{------------------------------------------------------------------------------}
procedure TADGUIxFormsListView.AddIntegerValue(const AItemName: string; AValue: Integer);
begin
  InsertRow(AItemName, IntToStr(AValue), True);
end;

{------------------------------------------------------------------------------}
procedure TADGUIxFormsListView.AddFloatValue(const AItemName: string; AValue: Double);
begin
  InsertRow(AItemName, FloatToStr(AValue), True);
end;

{------------------------------------------------------------------------------}
procedure TADGUIxFormsListView.AddBooleanValue(const AItemName: string; AValue: Boolean);
begin
  InsertRow(AItemName, BoolToStr(AValue, True), True);
end;

{------------------------------------------------------------------------------}
procedure TADGUIxFormsListView.AddValues(const AItemName: string; AValues: TStrings; AIndex: Integer);
var
  sVal: String;
begin
  if (AIndex >= 0) and (AIndex < AValues.Count) then
    sVal := AValues[AIndex]
  else
    sVal := '';
  InsertRow(AItemName, sVal, True);
  ItemProps[AItemName].PickList := AValues;
end;

{------------------------------------------------------------------------------}
procedure TADGUIxFormsListView.Clear;
begin
  Strings.Clear;
end;

{------------------------------------------------------------------------------}
function TADGUIxFormsListView.GetValue(const AName: String): String;
begin
  Result := Values[AName];
end;

{------------------------------------------------------------------------------}
function TADGUIxFormsListView.GetValueIndex(const AName: String): Integer;
begin
  Result := ItemProps[AName].PickList.IndexOf(Values[AName]);
end;
{$ENDIF}

{------------------------------------------------------------------------------}
{ TADGUIxFormsMemo
{------------------------------------------------------------------------------}
{$IFDEF AnyDAC_SynEdit}
type
  TADGUIxFormsHilighter = class(TSynSQLSyn)
  private
    FReg: TRegistry;
    FFontName: String;
    FFontSize: Integer;
    function GetEditorKey: String;
    procedure LoadAttr(AAttrs: TSynHighlighterAttributes; const AKind: String);
    procedure LoadSettings;
    function ReadBool(const Ident: string): Boolean;
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  GHighlighter: TADGUIxFormsHilighter;

{------------------------------------------------------------------------------}
constructor TADGUIxFormsHilighter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FReg := TRegistry.Create;
  try
    FReg.RootKey := HKEY_CURRENT_USER;
    LoadSettings;
  finally
    FReg.Free;
  end;
end;

{------------------------------------------------------------------------------}
function TADGUIxFormsHilighter.GetEditorKey: String;
begin
  Result := '\SOFTWARE\Borland\';
{$IFDEF AnyDAC_D10}
  Result := Result + 'BDS\4.0\';
{$ELSE}
  {$IFDEF AnyDAC_D9}
    Result := Result + 'BDS\3.0\';
  {$ELSE}
    {$IFDEF AnyDAC_D7}
      Result := Result + 'Delphi\7.0\';
    {$ELSE}
      {$IFDEF AnyDAC_D6}
        Result := Result + 'Delphi\6.0\';
      {$ELSE}
        {$IFDEF AnyDAC_D5}
        Result := Result + 'Delphi\5.0\';
        {$ENDIF}
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}
  Result := Result + 'Editor';
end;

{-------------------------------------------------------------------------------}
function TADGUIxFormsHilighter.ReadBool(const Ident: string): Boolean;
const
  C_BoolArr: array [Boolean] of String = ('False', 'True');
begin
  Result := FReg.ReadString('Ident') = C_BoolArr[True];
end;

{------------------------------------------------------------------------------}
procedure TADGUIxFormsHilighter.LoadAttr(AAttrs: TSynHighlighterAttributes;
  const AKind: String);
var
  eStyles: TFontStyles;
  iColor: Longint;
begin
  with AAttrs do begin
    if not FReg.OpenKeyReadOnly(GetEditorKey + '\Highlight\' + AKind) then
      Exit;

    if not ReadBool('Default Foreground') and
       IdentToColor(FReg.ReadString('Foreground Color New'), iColor) then
      Foreground := iColor;

    if not ReadBool('Default Background') and
       IdentToColor(FReg.ReadString('Background Color New'), iColor) then
      Background := iColor;

    eStyles := [];
    if ReadBool('Bold') then
      Include(eStyles, fsBold)
    else
      Exclude(eStyles, fsBold);
    if ReadBool('Italic') then
      Include(eStyles, fsItalic)
    else
      Exclude(eStyles, fsItalic);
    if ReadBool('Underline') then
      Include(eStyles, fsUnderline)
    else
      Exclude(eStyles, fsUnderline);
    Style := eStyles;
  end;
end;

{------------------------------------------------------------------------------}
procedure TADGUIxFormsHilighter.LoadSettings;
begin
  if not FReg.OpenKeyReadOnly(GetEditorKey + '\Options') then
    Exit;
  FFontName := FReg.ReadString('Editor Font');
  FFontSize := FReg.ReadInteger('Font Size');
  LoadAttr(SpaceAttri, 'Whitespace');
  LoadAttr(CommentAttribute, 'Comment');
  LoadAttr(CommentAttri, 'Comment');
  LoadAttr(KeywordAttribute, 'Reserved word');
  LoadAttr(KeyAttri, 'Reserved word');
  LoadAttr(PLSQLAttri, 'Reserved word');
  LoadAttr(SQLPlusAttri, 'Reserved word');
  LoadAttr(FunctionAttri, 'Reserved word');
  LoadAttr(NumberAttri, 'Number');
  LoadAttr(StringAttribute, 'String');
  LoadAttr(StringAttri, 'String');
  LoadAttr(SymbolAttribute, 'Symbol');
  LoadAttr(SymbolAttri, 'Symbol');
  LoadAttr(IdentifierAttribute, 'Identifier');
  LoadAttr(IdentifierAttri, 'Identifier');
  LoadAttr(DelimitedIdentifierAttri, 'Identifier');
  LoadAttr(VariableAttri, 'Identifier');
end;

{------------------------------------------------------------------------------}
constructor TADGUIxFormsMemo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if GHighlighter = nil then
    GHighlighter := TADGUIxFormsHilighter.Create(nil);
  Font.Name := GHighlighter.FFontName;
  Font.Size := GHighlighter.FFontSize;
  Highlighter := GHighlighter;
end;

{------------------------------------------------------------------------------}
function TADGUIxFormsMemo.GetCaretPos: TPoint;
begin
  Result := Point(CaretX, CaretY - 1);
end;

{------------------------------------------------------------------------------}
procedure TADGUIxFormsMemo.SetCaretPos(const AValue: TPoint);
begin
  CaretX := AValue.X;
  CaretY := AValue.Y + 1;
end;

initialization

finalization
  FreeAndNil(GHighlighter);

{$ELSE}

{------------------------------------------------------------------------------}
constructor TADGUIxFormsMemo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Font.Name := 'Courier New';
end;

{------------------------------------------------------------------------------}
{$IFNDEF AnyDAC_D6}
procedure TADGUIxFormsMemo.SetCaretPos(const AValue: TPoint);
var
  CharIdx: Integer;
begin
  CharIdx := SendMessage(Handle, EM_LINEINDEX, AValue.y, 0) + AValue.x;
  SendMessage(Handle, EM_SETSEL, CharIdx, CharIdx);
end;
{$ENDIF}

{$ENDIF}

end.
