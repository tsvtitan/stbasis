unit dbtree_l;
(*
 COPYRIGHT (c) RSD software 1997, 98
 All Rights Reserved.
*)


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  dbtree, DB, StdCtrls, ExtCtrls, ComCtrls, Menus, DBTables, dbctrls;

type

  TTVTextStyle = (tvtsShort, tvtsFull);

  TAutoTreeViewCloseUp = procedure (Sender : TObject; Accept : Boolean) of Object;

  TCustomAutoTreeViewEdit = class(TCustomControl)
  private
    PopUpForm : TForm;
    FCanSelectParents : Boolean;
    FAlignment: TAlignment;
    FFocused : Boolean;
    FButtonWidth : Integer;
    FDividedChar : Char;
    FDropDownRows : Integer;
    FListVisible : Boolean;
    PopupFormDeactivateFlag : Boolean;
    FOnDropDown: TNotifyEvent;
    FOnCloseUp: TAutoTreeViewCloseUp;
//    FOnCustomDraw : TTreeViewCustomDraw;    
    FText : String;
    FTextStyle : TTVTextStyle;

    procedure SetDividedChar(Value : Char);
    procedure SetText(Value : String);

    function GetCustomDraw : TTreeViewCustomDraw;
    function GetTreeViewColor : TColor;
    function GetTreeViewCursor : TCursor;
    function GetTreeViewDragMode : TDragMode;
    function GetTreeViewFont : TFont;
    function GetTreeViewHint : String;
    function GetTreeViewImages : TImageList;
    function GetTreeViewIndent : Integer;
    function GetTreeViewPopupMenu : TPopupMenu;
    function GetTreeViewReadOnly : Boolean;
    function GetSelectedTreeNode : TTreeNode;
    function GetTreeViewShowButtons : Boolean;
    function GetTreeViewShowHint : Boolean;
    function GetTreeViewShowLines : Boolean;
    function GetTreeViewShowRoot : Boolean;
    function GetTreeViewSortType : TSortType;
    function GetTreeViewStateImages : TImageList;

    procedure SetCustomDraw(Value : TTreeViewCustomDraw); 
    procedure SetTreeViewColor(Value : TColor);
    procedure SetTreeViewCursor(Value : TCursor);
    procedure SetTreeViewDragMode(Value : TDragMode);
    procedure SetTreeViewFont(Value : TFont);
    procedure SetTreeViewHint(Value : String);
    procedure SetTreeViewImages(Value : TImageList);
    procedure SetTreeViewIndent(Value : Integer);
    procedure SetTreeViewPopupMenu(Value : TPopupMenu);
    procedure SetTreeViewReadOnly(Value : Boolean);
    procedure SetTreeViewShowButtons(Value : Boolean);
    procedure SetTreeViewShowHint(Value : Boolean);
    procedure SetTreeViewShowLines(Value : Boolean);
    procedure SetTreeViewShowRoot(Value : Boolean);
    procedure SetTreeViewSortType(Value : TSortType);
    procedure SetTreeViewStateImages(Value : TImageList);

    procedure CMCtl3DChanged(var Message: TMessage); message CM_CTL3DCHANGED;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;

    function GetBorderSize: Integer;
    function GetTextHeight: Integer;
    procedure PopUpFormKeyDown(Sender : TObject; var Key: Word; Shift: TShiftState);
    procedure AllowChangeTreeNode(Sender: TObject; Node: TTreeNode; var AllowChange: Boolean);
    procedure DblClickTreeView(Sender: TObject);
    procedure PopupFormDeActivate(Sender: TObject);
  protected
    VirtualTreeView : TAutoTreeView; {It has to assign in other classes}

    procedure CreateParams(var Params: TCreateParams); override;
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;

    procedure DropDownOk; virtual;
    procedure PopUpFormCreate; virtual;
    procedure PrepareDropDown; virtual;

    property DividedChar : Char read FDividedChar write SetDividedChar;
    property TextStyle : TTVTextStyle read FTextStyle  write FTextStyle;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CloseUp(Accept: Boolean); virtual;
    procedure DropDown; virtual;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;

    property Selected : TTreeNode read GetSelectedTreeNode;
  published
    property CanSelectParents : Boolean read FCanSelectParents write FCanSelectParents;
    property Color;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property DropDownRows: Integer read FDropDownRows write FDropDownRows default 7;
    property Enabled;
    property Font;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text : String read FText write SetText;
    property TreeViewColor : TColor read GetTreeViewColor write SetTreeViewColor;
    property TreeViewCursor : TCursor read GetTreeViewCursor write SetTreeViewCursor;
    property TreeViewDragMode : TDragMode read GetTreeViewDragMode write SetTreeViewDragMode;
    property TreeViewFont : TFont read GetTreeViewFont write SetTreeViewFont;
    property TreeViewHint : String read GetTreeViewHint write SetTreeViewHint;    
    property TreeViewImages : TImageList read GetTreeViewImages write SetTreeViewImages;
    property TreeViewIndent : Integer read GetTreeViewIndent write SetTreeViewIndent;
    property TreeViewPopupMenu : TPopupMenu read GetTreeViewPopupMenu write SetTreeViewPopupMenu;
    property TreeViewReadOnly : Boolean read GetTreeViewReadOnly write SetTreeViewReadOnly;    
    property TreeViewShowButtons : Boolean read GetTreeViewShowButtons write SetTreeViewShowButtons;
    property TreeViewShowHint : Boolean read GetTreeViewShowHint write SetTreeViewShowHint;
    property TreeViewShowLines : Boolean read GetTreeViewShowLines write SetTreeViewShowLines;
    property TreeViewShowRoot : Boolean read GetTreeViewShowRoot write SetTreeViewShowRoot;
    property TreeViewSortType : TSortType read GetTreeViewSortType write SetTreeViewSortType;
    property TreeViewStateImages : TImageList read GetTreeViewStateImages write SetTreeViewStateImages;
    property Visible;
    property OnCloseUp: TAutoTreeViewCloseUp read FOnCloseUp write FOnCloseUp;
    property OnClick;
    property OnCustomDraw : TTreeViewCustomDraw read GetCustomDraw write SetCustomDraw;
    property OnDragDrop;
    property OnDragOver;
    property OnDropDown: TNotifyEvent read FOnDropDown write FOnDropDown;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
end;

TCustomTreeViewEdit = class(TCustomAutoTreeViewEdit)
private
  TreeView : TAutoTreeView;

  function GetItems : TTreeNodes;
  procedure SetItems(Value : TTreeNodes);
protected
  procedure PopUpFormCreate; override;
  procedure PrepareDropDown; override;
  procedure SearchTreeNode;
public
  destructor Destroy; override;
  function GetTreeNodeByText(ParentTreeNode : TTreeNode; Text : String; flag : Boolean) : TTreeNode;
published
  property DividedChar;
  property Items : TTreeNodes read GetItems write SetItems;
  property TextStyle;
end;

TTreeViewEdit = class(TCustomTreeViewEdit)
published
  property Alignment : TAlignment read FAlignment write FAlignment;
end;

TDBTreeViewEdit = class(TCustomTreeViewEdit)
  private
    FDataLink : TFieldDataLink;
    FCanvas: TControlCanvas;

    procedure DataChange(Sender: TObject);
    function GetDataField: string;
    function GetDataSource: TDataSource;
    function GetField: TField;
    function GetReadOnly: Boolean;
    procedure SetDataField(const Value: string);
    procedure SetDataSource(Value: TDataSource);
    procedure SetReadOnly(Value: Boolean);
    procedure UpdateData(Sender: TObject);
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
  protected
    procedure DropDownOk; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure DropDown; override;
    destructor Destroy; override;
    property Field: TField read GetField;
    property Text;
  published
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
end;

TCustomLookUpTreeView = class;

TDataLinkLookUpTreeView = class(TDataLink)
private
  LookUpTreeView: TCustomLookUpTreeView;
protected
  procedure ActiveChanged; override;
end;

TCustomLookUpTreeView = class(TCustomAutoTreeViewEdit)
private
   DBTreeView : TDBTreeView;
   FListSource: TDataSource;
   ListLink : TDataLinkLookUpTreeView;
   FKeyFieldValue : Variant;
   FAssignFieldName : String;
   FKeyFieldName : String;
   FParentFieldName : String;
   FListFieldName : String;
   FDisplayFieldName : String;
   FImageIndexFieldName : String;
   FStateIndexFieldName : String;

   FOnSetDisplayItemText : TSetDisplayItemText;


   function GetAddNewItem : TAddNewDBTreeNodeEvent;
   function GetOptions : TDBTreeViewOptions;
   function GetRootValue : String;
   procedure SetAddNewItem(Value : TAddNewDBTreeNodeEvent);
   procedure SetAssignField(Value: String);
   procedure SetKeyField(Value: String);
   procedure SetListField(Value: String);
   procedure SetOptions(Value : TDBTreeViewOptions);
   procedure SetParentField(Value: String);
   procedure SetRootValue(Value : String);   
   procedure SetListSource(Value: TDataSource);

   procedure DataLinkActiveChanged;
 protected
   FAssignField : TField;
   FKeyField : TField;
   FListField : TField;
   FParentField : TField;

   procedure DropDownOk; override;
   procedure PopUpFormCreate; override;

   property AssignField : String read FAssignFieldName write SetAssignField;
 public
   constructor Create(AOwner : TComponent); override;
   destructor Destroy; override;
   procedure CloseUp(Accept: Boolean); override;
   procedure DropDown; override;
 published
   property DisplayField: string read FDisplayFieldName write FDisplayFieldName;
   property DividedChar;
   property ImageIndexField : String read FImageIndexFieldName write FImageIndexFieldName;
   property ListSource: TDataSource read FListSource write SetListSource;
   property KeyField: string read FKeyFieldName write SetKeyField;
   property ListField: string read FListFieldName write SetListField;
   property Options : TDBTreeViewOptions read GetOptions write SetOptions;
   property ParentField: string read FParentFieldName write SetParentField;
   property RootValue : String read GetRootValue write SetRootValue;
   property StateIndexField : String read FStateIndexFieldName write FStateIndexFieldName;
   property TextStyle;
   property DBTV: TDBTreeView read DBTreeView;
   property OnAddNewItem : TAddNewDBTreeNodeEvent read GetAddNewItem write SetAddNewItem;
   property OnSetDisplayItemText : TSetDisplayItemText read FOnSetDisplayItemText
                                write FOnSetDisplayItemText;
end;

TLookUpTreeView = class(TCustomLookUpTreeView)
published
  property Alignment : TAlignment read FAlignment write FAlignment;
end;

TDBLookUpTreeView = class(TCustomLookUpTreeView)
private
  FDataLink: TFieldDataLink;
  FCanvas: TControlCanvas;
  FCloseUpFlag : Boolean;

  procedure DataChange(Sender: TObject);
  function GetDataField: string;
  function GetDataSource: TDataSource;
  function GetField: TField;
  function GetReadOnly: Boolean;
  procedure SetDataField(const Value: string);
  procedure SetDataSource(Value: TDataSource);
  procedure SetReadOnly(Value: Boolean);
  procedure UpdateData(Sender: TObject);
  procedure CMExit(var Message: TCMExit); message CM_EXIT;
  procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
  procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
protected
  procedure DropDownOk; override;
  function GetDisplayText : String;
  function GetLookUpValue : Variant;
  procedure Notification(AComponent: TComponent;
    Operation: TOperation); override;
  procedure PrepareDropDown; override;
  procedure SearchTreeNode;
public
  constructor Create(AOwner: TComponent); override;
  destructor Destroy; override;
  property Field: TField read GetField;
  procedure CloseUp(Accept: Boolean); override;
  procedure DropDown; override;
  property Text;
published
  property AssignField;
  property DataField: string read GetDataField write SetDataField;
  property DataSource: TDataSource read GetDataSource write SetDataSource;
  property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
end;

implementation

function VarEquals(const V1, V2: Variant): Boolean;
begin
  Result := False;
  try
    Result := V1 = V2;
  except
  end;
end;


function GetFullTreeNodeName(TreeNode : TTreeNode; DividedChar : Char) : String;
Var
  tr : TTreeNode;
begin
  Result := '';
  tr := TreeNode;
  while tr <> Nil do begin
    if(Length(Result) > 0 ) And (Length(tr.Text) > 0 ) then
      Result := DividedChar + Result;
    Result := tr.Text + Result;
    tr := tr.Parent;
  end;
end;

{TCustomAutoTreeViewEdit}

constructor TCustomAutoTreeViewEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  VirtualTreeView := Nil;
  ControlStyle := [csOpaque, csReplicatable];
  if Not NewStyleControls then
    ControlStyle := ControlStyle + [csFramed];
  ParentColor := False;
  TabStop := True;
  FCanSelectParents := True;

  PopUpForm := TForm.Create(self);
  with PopUpForm do begin
    BorderIcons := [];
    BorderStyle := BsNone;
    OnDeactivate := PopupFormdeActivate;
  end;
  PopUpFormCreate;

  Width := 145;
  Height := 0;
  FButtonWidth := GetSystemMetrics(SM_CXVSCROLL);
  FDividedChar := '.';
  FDropDownRows := 7;
  PopupFormDeactivateFlag := False;
end;


procedure TCustomAutoTreeViewEdit.PopUpFormCreate;
begin
  if(VirtualTreeView <> Nil) then begin
     VirtualTreeView.OnChanging := AllowChangeTreeNode;
     VirtualTreeView.OnDblClick := DblClickTreeView;
     VirtualTreeView.OnKeyDown := PopUpFormKeyDown;
   end;
end;

destructor TCustomAutoTreeViewEdit.Destroy;
begin
  PopUpForm.Free;
  inherited;
end;

function TCustomAutoTreeViewEdit.GetBorderSize: Integer;
var
  Params: TCreateParams;
  R: TRect;
begin
  CreateParams(Params);
  SetRect(R, 0, 0, 0, 0);
  AdjustWindowRectEx(R, Params.Style, False, Params.ExStyle);
  Result := R.Bottom - R.Top;
end;

var
  AllowDblClickFlag : Boolean;

procedure TCustomAutoTreeViewEdit.AllowChangeTreeNode(Sender: TObject; Node: TTreeNode;
    var AllowChange: Boolean);
begin
  AllowDblClickFlag := True;
  if(Not FCanSelectParents) And (Node.HasChildren) then begin
    AllowDblClickFlag := False;
    AllowChange := False
  end
  else AllowChange := True;

end;

procedure TCustomAutoTreeViewEdit.DblClickTreeView(Sender: TObject);
begin
  if(VirtualTreeView.Selected <> Nil) And AllowDblClickFlag then
    CloseUp(True);
end;

procedure TCustomAutoTreeViewEdit.PopupFormDeActivate(Sender: TObject);
begin
  PopupFormDeactivateFlag := True;
  CloseUp(False);
end;

procedure TCustomAutoTreeViewEdit.CloseUp(Accept: Boolean);
begin
  PopUpForm.Close;
  if(Accept) then DropDownOk;
  if FListVisible then begin
    SetCaptureControl(Nil);
    Invalidate;
    FListVisible := False;
  end;
  if Assigned(FOnCloseUp) then FOnCloseUp(Self, Accept);
end;

procedure TCustomAutoTreeViewEdit.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
    if NewStyleControls and Ctl3D then
      ExStyle := ExStyle or WS_EX_CLIENTEDGE
    else
      Style := Style or WS_BORDER;
end;

procedure TCustomAutoTreeViewEdit.DropDown;
var
  ptUpper, ptLower: TPoint;
  rectPlace : TRect;
begin
  if not FListVisible  then
  begin
    if Assigned(FOnDropDown) then FOnDropDown(Self);
    PrepareDropDown;

    PopUpForm.Font := Font;
    PopUpForm.Width := Width;
    PopUpForm.Height := 5 + FDropDownRows*GetTextHeight;
    if(Width > PopUpForm.Width) then
      PopUpForm.Width := Width;

    rectPlace := ClientRect;
    ptUpper.X := rectPlace.Left;
    ptUpper.Y := rectPlace.Top;
    ptUpper := ClientToScreen( ptUpper );
    ptLower.X := rectPlace.Right;
    ptLower.Y := rectPlace.Bottom;
    ptLower := ClientToScreen( ptLower );

    if ptUpper.X + 1 + PopUpForm.Width > Screen.Width then
      PopUpForm.Left := Screen.Width - PopUpForm.Width - 2
    else PopUpForm.Left := ptUpper.X - 2;
    if(PopUpForm.Left < 0) then PopUpForm.Left := 0;
    if ptLower.Y + 1 + PopUpForm.Height > Screen.Height then
       PopUpForm.Top := ptUpper.Y - PopUpForm.Height - 2
    else PopUpForm.Top := ptLower.Y - 1;


    FListVisible := True;
    SendMessage(VirtualTreeView.Handle, WM_RBUTTONDOWN, 0, 0);    
    PopUpForm.Show;
    Paint;
  end;
end;

function TCustomAutoTreeViewEdit.GetTextHeight: Integer;
var
  DC: HDC;
  SaveFont: HFont;
  Metrics: TTextMetric;
begin
  DC := GetDC(0);
  SaveFont := SelectObject(DC, Font.Handle);
  GetTextMetrics(DC, Metrics);
  SelectObject(DC, SaveFont);
  ReleaseDC(0, DC);
  Result := Metrics.tmHeight;
end;

procedure TCustomAutoTreeViewEdit.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    SetFocus;
    if FListVisible then
      CloseUp(False)
    else
      if Not (PopupFormDeactivateFlag) then
        DropDown;
  end;
  PopupFormDeactivateFlag := False;
  inherited MouseDown(Button, Shift, X, Y);  
end;

procedure TCustomAutoTreeViewEdit.Paint;
var
  W, X, Flags: Integer;
  Selected: Boolean;
  R: TRect;
begin
  Canvas.Font := Font;
  Canvas.Brush.Color := Color;
  Selected := FFocused and not FListVisible and
    not (csPaintCopy in ControlState);
  if Selected then
  begin
    Canvas.Font.Color := clHighlightText;
    Canvas.Brush.Color := clHighlight;
  end;
  W := ClientWidth - FButtonWidth;
  X := 2;
  case FAlignment of
    taRightJustify: X := W - Canvas.TextWidth(FText) - 3;
    taCenter: X := (W - Canvas.TextWidth(FText)) div 2;
  end;
  SetRect(R, 1, 1, W - 1, ClientHeight - 1);
  Canvas.TextRect(R, X, 2, FText);
  if Selected then Canvas.DrawFocusRect(R);
  SetRect(R, W, 0, ClientWidth, ClientHeight);
  Flags := DFCS_SCROLLCOMBOBOX;
  DrawFrameControl(Canvas.Handle, R, DFC_SCROLL, Flags);
end;


procedure TCustomAutoTreeViewEdit.DropDownOk;
begin
  if(VirtualTreeView <> Nil) And (VirtualTreeView.Selected <> Nil) then  begin
    if(FTextStyle = tvtsFull) then
      Text := GetFullTreeNodeName(VirtualTreeView.Selected, FDividedChar)
    else  Text := VirtualTreeView.Selected.Text;
  end;
end;


procedure TCustomAutoTreeViewEdit.PrepareDropDown;
begin
end;


procedure TCustomAutoTreeViewEdit.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, GetTextHeight + GetBorderSize + 4);
end;

procedure TCustomAutoTreeViewEdit.CMCtl3DChanged(var Message: TMessage);
begin
  if NewStyleControls then
  begin
    RecreateWnd;
    Height := 0;
  end;
  inherited;
end;

procedure TCustomAutoTreeViewEdit.CMFontChanged(var Message: TMessage);
begin
  inherited;
  Height := 0;
end;


procedure TCustomAutoTreeViewEdit.PopUpFormKeyDown(Sender : TObject; var Key: Word; Shift: TShiftState);
begin
  if(Key = VK_ESCAPE) then
    CloseUp(False);
  if(Key = VK_RETURN) And (VirtualTreeView.Selected <> Nil) then
    CloseUp(True);
end;

procedure TCustomAutoTreeViewEdit.WMKillFocus(var Message: TWMKillFocus);
begin
  inherited;
  FFocused := False;  
  Invalidate;

end;

procedure TCustomAutoTreeViewEdit.WMSetFocus(var Message: TWMSetFocus);
begin
  FFocused := True;
  Invalidate;
end;


procedure TCustomAutoTreeViewEdit.SetText(Value : String);
begin
  FText := Value;
  invalidate;
end;

procedure TCustomAutoTreeViewEdit.SetDividedChar(Value : Char);
begin
  FDividedChar := Value;
  if(VirtualTreeView <> Nil) And (VirtualTreeView.Selected <> Nil) then
     GetFullTreeNodeName(VirtualTreeView.Selected, FDividedChar);
  invalidate;
end;

function TCustomAutoTreeViewEdit.GetCustomDraw : TTreeViewCustomDraw;
begin
  if(VirtualTreeView <> Nil) then
    Result := VirtualTreeView.OnCustomDraw
  else Result := Nil;
end;

function TCustomAutoTreeViewEdit.GetTreeViewColor : TColor;
begin
  if(VirtualTreeView <> Nil) then
    Result := VirtualTreeView.Color
  else Result := clNone;
end;

function TCustomAutoTreeViewEdit.GetTreeViewCursor : TCursor;
begin
  if(VirtualTreeView <> Nil) then
    Result := VirtualTreeView.Cursor
  else Result := crNone;   
end;

function TCustomAutoTreeViewEdit.GetTreeViewDragMode : TDragMode;
begin
  if(VirtualTreeView <> Nil) then
    Result := VirtualTreeView.DragMode
  else  Result := dmManual;
end;

function TCustomAutoTreeViewEdit.GetTreeViewFont : TFont;
begin
  if(VirtualTreeView <> Nil) then
    Result := VirtualTreeView.Font
  else Result := Nil;
end;

function TCustomAutoTreeViewEdit.GetTreeViewHint : String;
begin
  if(VirtualTreeView <> Nil) then
    Result := VirtualTreeView.Hint;
end;

function TCustomAutoTreeViewEdit.GetTreeViewImages : TImageList;
begin
  if(VirtualTreeView <> Nil) then
    Result := TImageList(VirtualTreeView.Images)
  else Result := Nil;
end;

function TCustomAutoTreeViewEdit.GetTreeViewIndent : Integer;
begin
  if(VirtualTreeView <> Nil) then
    Result := VirtualTreeView.Indent
  else Result := -1;
end;

function TCustomAutoTreeViewEdit.GetTreeViewPopupMenu : TPopupMenu;
begin
  if(VirtualTreeView <> Nil) then
    Result := VirtualTreeView.PopupMenu
  else Result := Nil;
end;

function TCustomAutoTreeViewEdit.GetTreeViewReadOnly : Boolean;
begin
  if(VirtualTreeView <> Nil) then
    Result := VirtualTreeView.ReadOnly
  else Result := False;
end;

function TCustomAutoTreeViewEdit.GetSelectedTreeNode : TTreeNode;
begin
  if(VirtualTreeView <> Nil) then
    Result := VirtualTreeView.Selected
  else Result := Nil;
end;


function TCustomAutoTreeViewEdit.GetTreeViewShowButtons : Boolean;
begin
  if(VirtualTreeView <> Nil) then
    Result := VirtualTreeView.ShowButtons
  else Result := False;
end;

function TCustomAutoTreeViewEdit.GetTreeViewShowHint : Boolean;
begin
  if(VirtualTreeView <> Nil) then
    Result := VirtualTreeView.ShowHint
  else Result := False;
end;

function TCustomAutoTreeViewEdit.GetTreeViewShowLines : Boolean;
begin
  if(VirtualTreeView <> Nil) then
    Result := VirtualTreeView.ShowLines
  else Result := False;
end;

function TCustomAutoTreeViewEdit.GetTreeViewShowRoot : Boolean;
begin
  if(VirtualTreeView <> Nil) then
    Result := VirtualTreeView.ShowRoot
  else Result := False;    
end;

function TCustomAutoTreeViewEdit.GetTreeViewSortType : TSortType;
begin
  if(VirtualTreeView <> Nil) then
    Result := VirtualTreeView.SortType
  else Result := stNone;
end;

function TCustomAutoTreeViewEdit.GetTreeViewStateImages : TImageList;
begin
  if(VirtualTreeView <> Nil) then
    Result := TImageList(VirtualTreeView.StateImages)
  else Result := Nil;
end;

procedure TCustomAutoTreeViewEdit.SetCustomDraw(Value : TTreeViewCustomDraw);
begin
  if(VirtualTreeView <> Nil) then
    VirtualTreeView.OnCustomDraw := Value;
end;


procedure TCustomAutoTreeViewEdit.SetTreeViewColor(Value : TColor);
begin
  if(VirtualTreeView <> Nil) then
    VirtualTreeView.Color := Value;
end;

procedure TCustomAutoTreeViewEdit.SetTreeViewCursor(Value : TCursor);
begin
  if(VirtualTreeView <> Nil) then
    VirtualTreeView.Cursor := Value;
end;

procedure TCustomAutoTreeViewEdit.SetTreeViewDragMode(Value : TDragMode);
begin
  if(VirtualTreeView <> Nil) then
    VirtualTreeView.DragMode := Value
end;

procedure TCustomAutoTreeViewEdit.SetTreeViewFont(Value : TFont);
begin
  if(VirtualTreeView <> Nil) then
    VirtualTreeView.Font := Value;
end;

procedure TCustomAutoTreeViewEdit.SetTreeViewHint(Value : String);
begin
  if(VirtualTreeView <> Nil) then
    VirtualTreeView.Hint := Value;
end;

procedure TCustomAutoTreeViewEdit.SetTreeViewImages(Value : TImageList);
begin
  if(VirtualTreeView <> Nil) then
    VirtualTreeView.Images := Value;
end;

procedure TCustomAutoTreeViewEdit.SetTreeViewIndent(Value : Integer);
begin
  if(VirtualTreeView <> Nil) then
    VirtualTreeView.Indent := Value;
end;

procedure TCustomAutoTreeViewEdit.SetTreeViewPopupMenu(Value : TPopupMenu);
begin
  if(VirtualTreeView <> Nil) then
    VirtualTreeView.PopupMenu := Value;
end;

procedure TCustomAutoTreeViewEdit.SetTreeViewReadOnly(Value : Boolean);
begin
  if(VirtualTreeView <> Nil) then
    VirtualTreeView.ReadOnly := Value;
end;

procedure TCustomAutoTreeViewEdit.SetTreeViewShowButtons(Value : Boolean);
begin
  if(VirtualTreeView <> Nil) then
    VirtualTreeView.ShowButtons := Value;
end;

procedure TCustomAutoTreeViewEdit.SetTreeViewShowHint(Value : Boolean);
begin
  if(VirtualTreeView <> Nil) then
    VirtualTreeView.ShowHint := Value;
end;

procedure TCustomAutoTreeViewEdit.SetTreeViewShowLines(Value : Boolean);
begin
  if(VirtualTreeView <> Nil) then
    VirtualTreeView.ShowLines := Value;
end;

procedure TCustomAutoTreeViewEdit.SetTreeViewShowRoot(Value : Boolean);
begin
  if(VirtualTreeView <> Nil) then
    VirtualTreeView.ShowRoot := Value;
end;

procedure TCustomAutoTreeViewEdit.SetTreeViewSortType(Value : TSortType);
begin
  if(VirtualTreeView <> Nil) then
    VirtualTreeView.SortType := Value;
end;

procedure TCustomAutoTreeViewEdit.SetTreeViewStateImages(Value : TImageList);
begin
  if(VirtualTreeView <> Nil) then
    VirtualTreeView.StateImages := Value;
end;


{TTreeViewEdit}
destructor TCustomTreeViewEdit.Destroy;
begin
  TreeView.Free;
  inherited;
end;

procedure TCustomTreeViewEdit.PopUpFormCreate;
begin
  TreeView := TAutoTreeView.Create(PopUpForm);
  VirtualTreeView := TreeView;
  with TreeView do begin
    Parent := PopUpForm;
    Align := alClient;
  end;
  inherited;
end;

procedure TCustomTreeViewEdit.PrepareDropDown;
begin
  SearchTreeNode;
end;

procedure TCustomTreeViewEdit.SearchTreeNode;
Var
  i : Integer;
  St : String;
begin
  if(Length(FText) = 0) then exit;
  if(TextStyle = tvtsShort) then begin
    for i := 0 to VirtualTreeView.Items.Count - 1 do begin
      if(FText = VirtualTreeView.Items[i].Text) then begin
        VirtualTreeView.Selected := VirtualTreeView.Items[i];
        VirtualTreeView.Selected.MakeVisible;
        break;
      end;
    end;
  end else begin
    for i := 0 to VirtualTreeView.Items.Count - 1 do begin
      St := GetFullTreeNodeName(VirtualTreeView.Items[i], FDividedChar);
      if(FText = St) then begin
        VirtualTreeView.Selected := VirtualTreeView.Items[i];
        VirtualTreeView.Selected.MakeVisible;
        break;
      end;
    end;
  end;
end;

function TCustomTreeViewEdit.GetTreeNodeByText(ParentTreeNode : TTreeNode;
         Text : String; flag : Boolean) : TTreeNode;
Var
  tmp : TTreeNode;
begin
  Result := Nil;
  if(ParentTreeNode = Nil) then begin
    tmp := VirtualTreeView.Items.GetFirstNode;
     while(tmp <> Nil) And (Result = Nil) do
       if(tmp.Text = Text) then
         Result := tmp
       else tmp :=  tmp.GetNext;
   end else begin
     tmp := ParentTreeNode.GetFirstChild;
     while(tmp <> Nil) And (Result = Nil) do begin
       if(tmp.Text = Text) then
         Result := tmp
       else begin
         if flag And tmp.HasChildren then
           Result := GetTreeNodeByText(tmp, Text, flag);
         if(Result = Nil) then
           tmp := ParentTreeNode.GetNextChild(tmp);
       end;
     end;
   end;
end;

function TCustomTreeViewEdit.GetItems : TTreeNodes;
begin
  Result := TreeView.Items;
end;

procedure TCustomTreeViewEdit.SetItems(Value : TTreeNodes);
begin
  TreeView.Items := Value;
end;


{ TDBTreeViewEdit }

constructor TDBTreeViewEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable];
  {$IFDEF DELPHI3_0_CONFIDENTIAL}
    FDataLink := TFieldDataLink.Create(self);
  {$ELSE}
    FDataLink := TFieldDataLink.Create;  
  {$ENDIF}
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnUpdateData := UpdateData;
end;

destructor TDBTreeViewEdit.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  FCanvas.Free;  
  inherited Destroy;
end;

procedure TDBTreeViewEdit.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

procedure TDBTreeViewEdit.DataChange(Sender: TObject);
begin
  if FDataLink.Field <> nil then begin
    if FAlignment <> FDataLink.Field.Alignment then
    begin
      FAlignment := FDataLink.Field.Alignment;
    end;
    Text := FDataLink.Field.Text
  end else
    if csDesigning in ComponentState then
      Text := Name
    else
      Text := '';
end;


procedure TDBTreeViewEdit.UpdateData(Sender: TObject);
begin
  FDataLink.Field.Text := Text;
end;

procedure TDBTreeViewEdit.DropDown;
begin
  if Not FDataLink.Editing then
    FDataLink.Edit;
  inherited DropDown;
  FDataLink.Modified;
end;

procedure TDBTreeViewEdit.DropDownOk;
begin
  inherited DropDownOk;
  FDataLink.Field.Text := Text;
end;


function TDBTreeViewEdit.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TDBTreeViewEdit.SetDataSource(Value: TDataSource);
begin
  FDataLink.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

function TDBTreeViewEdit.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;

procedure TDBTreeViewEdit.SetDataField(const Value: string);
begin
  FDataLink.FieldName := Value;
end;

function TDBTreeViewEdit.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;

procedure TDBTreeViewEdit.SetReadOnly(Value: Boolean);
begin
  FDataLink.ReadOnly := Value;
end;

function TDBTreeViewEdit.GetField: TField;
begin
  Result := FDataLink.Field;
end;

procedure TDBTreeViewEdit.CMExit(var Message: TCMExit);
begin
  try
    FDataLink.UpdateRecord;
  except
    SetFocus;
    raise;
  end;
  inherited;
end;

procedure TDBTreeViewEdit.WMPaint(var Message: TWMPaint);
var
  S: string;
  W, X, Flags: Integer;
  R: TRect;
  DC: HDC;
  PS: TPaintStruct;
begin
  if not (csPaintCopy in ControlState) then inherited else  begin
    if FDataLink.Field <> nil then S := FDataLink.Field.Text else S := '';
    if FCanvas = nil then  begin
      FCanvas := TControlCanvas.Create;
      FCanvas.Control := Self;
    end;
    DC := Message.DC;
    if DC = 0 then DC := BeginPaint(Handle, PS);
    FCanvas.Handle := DC;
    try
      FCanvas.Font := Font;
      W := ClientWidth - FButtonWidth;
      X := 2;
      case FAlignment of
        taRightJustify: X := W - FCanvas.TextWidth(S) - 3;
        taCenter: X := (W - FCanvas.TextWidth(S)) div 2;
      end;
      SetRect(R, 1, 1, W - 1, ClientHeight - 1);
      FCanvas.TextRect(R, X, 2, S);
      SetRect(R, W, 0, ClientWidth, ClientHeight);
      Flags := DFCS_SCROLLCOMBOBOX;
      DrawFrameControl(FCanvas.Handle, R, DFC_SCROLL, Flags);
    finally
      FCanvas.Handle := 0;
      if Message.DC = 0 then EndPaint(Handle, PS);
    end;
  end;
end;

procedure TDBTreeViewEdit.CMGetDatalink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;

{TDataLinkLookUpTreeView}
procedure TDataLinkLookUpTreeView.ActiveChanged;
begin
  if (LookUpTreeView <> nil) then LookUpTreeView.DataLinkActiveChanged;
end;

{TCustomLookUpTreeView}
constructor TCustomLookUpTreeView.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  ListLink := TDataLinkLookUpTreeView.Create;
  ListLink.LookUpTreeView := self;
end;

destructor TCustomLookUpTreeView.Destroy;
begin
  ListLink.LookUpTreeView := Nil;
  ListLink.Free;
  DBTreeView.Free;
  inherited;
end;

procedure TCustomLookUpTreeView.DropDown;
begin
  with DBTreeView do begin
    KeyField := FKeyFieldName;
    ParentField := FParentFieldName;
    ListField := FListFieldName;
    DisplayField := FDisplayFieldName;
    OnSetDisplayItemText := FOnSetDisplayItemText;
    ImageIndexField := FImageIndexFieldName;
    StateIndexField := FStateIndexFieldName;
    DataSource := FListSource;
  end;
  if Not VarIsNull(FKeyFieldValue) then
    DBTreeView.GotoKeyFieldValue(FKeyFieldValue);
  inherited;

end;


procedure TCustomLookUpTreeView.DropDownOk;
begin
  inherited;
  FKeyFieldValue := Null;
  if(FKeyField <> Nil) then
    FKeyFieldValue := FKeyField.Value;
end;

procedure TCustomLookUpTreeView.PopUpFormCreate;
begin

  FKeyFieldValue := Null;
  DBTreeView := TDBTreeView.Create(PopUpForm);
  VirtualTreeView := TAutoTreeView(DBTreeView);
  with DBTreeView do begin
    Parent := PopUpForm;
    Align := alClient;
  end;
  inherited;
end;

procedure TCustomLookUpTreeView.CloseUp(Accept: Boolean);
begin
  PopupForm.Close;
  inherited CloseUp(Accept);
  DBTreeView.DataSource := Nil;
end;

function TCustomLookUpTreeView.GetAddNewItem : TAddNewDBTreeNodeEvent;
begin
  Result := DBTreeView.onAddNewItem;
end;

function TCustomLookUpTreeView.GetOptions : TDBTreeViewOptions;
begin
  Result := DBTreeView.Options;
end;

function TCustomLookUpTreeView.GetRootValue : String;
begin
  Result := DBTreeView.RootValue;
end;

procedure TCustomLookUpTreeView.SetAddNewItem(Value : TAddNewDBTreeNodeEvent);
begin
  DBTreeView.onAddNewItem := Value;
end;

procedure TCustomLookUpTreeView.SetKeyField(Value: String);
begin
  if(Value <> FKeyFieldName) then begin
    FKeyFieldName := Value;
    DataLinkActiveChanged;
  end;
end;

procedure TCustomLookUpTreeView.SetListField(Value: String);
begin
  if(Value <> FListFieldName) then begin
    FListFieldName := Value;
    DataLinkActiveChanged;
  end;
end;

procedure TCustomLookUpTreeView.SetOptions(Value : TDBTreeViewOptions);
begin
  DBTreeView.Options := Value;
end;

procedure TCustomLookUpTreeView.SetRootValue(Value : String);
begin
  DBTreeView.RootValue := Value;
end;

procedure TCustomLookUpTreeView.SetParentField(Value: String);
begin
  if(Value <> FParentFieldName) then
    FParentFieldName := Value;
end;

procedure TCustomLookUpTreeView.SetListSource(Value: TDataSource);
begin
  if(Value <> FListSource) then begin
    FListSource := Value;
    ListLink.DataSource := Value;
  end;
end;

procedure TCustomLookUpTreeView.SetAssignField(Value: String);
begin
  if(Value <> FAssignFieldName) then begin
    FAssignFieldName := Value;
    DataLinkActiveChanged;
  end;
end;

procedure TCustomLookUpTreeView.DataLinkActiveChanged;
begin
  FKeyField := Nil;
  FListField := Nil;
  FAssignField := Nil;
  FParentField := Nil;
  if ListLink.Active then  begin
    if(FKeyFieldName <> '') then
      FKeyField := ListLink.DataSet.FieldByName(FKeyFieldName);
    if(FListFieldName <> '') then
      FListField := ListLink.DataSet.FieldByName(FListFieldName);
    if(FAssignFieldName <> '') then
      FAssignField := ListLink.DataSet.FieldByName(FAssignFieldName);
    if(FParentFieldName <> '') then
      FParentField := ListLink.DataSet.FieldByName(FParentFieldName);
  end;
end;

{TDBLookUpTreeView}
constructor TDBLookUpTreeView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable];
  {$IFDEF DELPHI3_0_CONFIDENTIAL}
    FDataLink := TFieldDataLink.Create(self);
  {$ELSE}
    FDataLink := TFieldDataLink.Create;
  {$ENDIF}
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnUpdateData := UpdateData;
  FCloseUpFlag := False;
end;

destructor TDBLookUpTreeView.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  FCanvas.Free;
  inherited Destroy;
end;

procedure TDBLookUpTreeView.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

procedure TDBLookUpTreeView.SearchTreeNode;
begin
  if (FDataLink.Field <> nil) And (DBTreeView <> Nil) then
    DBTreeView.GotoKeyFieldValue(FDataLink.Field.Value);
end;

procedure TDBLookUpTreeView.PrepareDropDown;
begin
  inherited;
  SearchTreeNode;
end;

procedure TDBLookUpTreeView.DataChange(Sender: TObject);
begin
  if FDataLink.Field <> nil then begin
    if FAlignment <> FDataLink.Field.Alignment then
    begin
      FAlignment := FDataLink.Field.Alignment;
    end;
    Text := GetDisplayText
  end else
    if csDesigning in ComponentState then
      Text := Name
    else
      Text := '';
end;

procedure TDBLookUpTreeView.UpdateData(Sender: TObject);
begin
  if (FDataLink.Active)
  And ((FDataLink.DataSet.State = dsInsert) or (FDataLink.dataSet.State = dsEdit)) then
    FDataLink.Field.Value := GetLookUpValue;
end;

procedure TDBLookUpTreeView.DropDown;
begin
  if Not FDataLink.Editing then
    FDataLink.Edit;
  inherited DropDown;
  FDataLink.Modified;
end;

procedure TDBLookUpTreeView.DropDownOk;
begin
  inherited DropDownOk;
  UpdateData(self);
end;

procedure TDBLookUpTreeView.CloseUp(Accept : Boolean);
begin
  if(FCloseUpFlag) then exit;
  FCloseUpFlag := True;
  inherited CloseUp(Accept);
  if not (Accept) and (FDataLink <> Nil) then
    FDataLink.Reset;
  FCloseUpFlag := False;  
end;

function TDBLookUpTreeView.GetDisplayText : String;
Var
  b : Boolean;
begin
  Result := '';
  if (FDataLink.Field = Nil) Or (FKeyField = Nil) Or (FListField = Nil)
  Or (FParentField = Nil) then exit;
  if (ListLink.Active) then begin
    ListLink.DataSet.DisableControls;
    if(FAssignField <> Nil) then
      b:= ListLink.DataSet.Locate(FAssignFieldName, FDataLink.Field.Value, [])
    else
      b := ListLink.DataSet.Locate(FKeyFieldName, FDataLink.Field.Value, []);
    if b then begin
      Result := FListField.Text;
      if(FTextStyle = tvtsFull) then begin
        while ListLink.DataSet.Locate(FKeyFieldName, FParentField.Value, [])
        And Not VarEquals(FParentField.Value, FKeyField.Value) do
          Result := FListField.Text + FDividedChar + Result;
      end;
    end;
    ListLink.DataSet.EnableControls;    
  end;
end;

function TDBLookUpTreeView.GetLookUpValue : Variant;
begin
  Result := Null;
  if (ListLink.Active) then begin
    if(FAssignField <> Nil) then
      Result := FAssignField.Value
    else Result := FKeyField.Value;
  end;
end;

function TDBLookUpTreeView.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TDBLookUpTreeView.SetDataSource(Value: TDataSource);
begin
  FDataLink.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

function TDBLookUpTreeView.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;

procedure TDBLookUpTreeView.SetDataField(const Value: string);
begin
  FDataLink.FieldName := Value;
end;

function TDBLookUpTreeView.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;

procedure TDBLookUpTreeView.SetReadOnly(Value: Boolean);
begin
  FDataLink.ReadOnly := Value;
end;

function TDBLookUpTreeView.GetField: TField;
begin
  Result := FDataLink.Field;
end;

procedure TDBLookUpTreeView.CMExit(var Message: TCMExit);
begin
  try
    FDataLink.UpdateRecord;
  except
    SetFocus;
    raise;
  end;
  inherited;
end;

procedure TDBLookUpTreeView.WMPaint(var Message: TWMPaint);
var
  S: string;
  W, X, Flags: Integer;
  R: TRect;
  DC: HDC;
  PS: TPaintStruct;
begin
  if not (csPaintCopy in ControlState) then inherited else  begin
    S := GetDisplayText;
    if FCanvas = nil then  begin
      FCanvas := TControlCanvas.Create;
      FCanvas.Control := Self;
    end;
    DC := Message.DC;
    if DC = 0 then DC := BeginPaint(Handle, PS);
    FCanvas.Handle := DC;
    try
      FCanvas.Font := Font;
      W := ClientWidth - FButtonWidth;
      X := 2;
      case FAlignment of
        taRightJustify: X := W - FCanvas.TextWidth(S) - 3;
        taCenter: X := (W - FCanvas.TextWidth(S)) div 2;
      end;
      SetRect(R, 1, 1, W - 1, ClientHeight - 1);
      FCanvas.TextRect(R, X, 2, S);
      SetRect(R, W, 0, ClientWidth, ClientHeight);
      Flags := DFCS_SCROLLCOMBOBOX;
      DrawFrameControl(FCanvas.Handle, R, DFC_SCROLL, Flags);
    finally
      FCanvas.Handle := 0;
      if Message.DC = 0 then EndPaint(Handle, PS);
    end;
  end;
end;

procedure TDBLookUpTreeView.CMGetDatalink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;


end.
