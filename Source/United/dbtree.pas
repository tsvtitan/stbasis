
unit dbtree;
(*
 COPYRIGHT (c) RSD software 1997, 98
 All Rights Reserved.
*) 


interface
{$I dbtree.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, CommCtrl, DB, tsvComCtrls;

type

  TAutoTreeViewOption = (trCanDelete, trConfirmDelete);
  TAutoTreeViewOptions = set of TAutoTreeViewOption;

  TDragDropTreeNode = procedure(Destination, Source : TTreeNode;
                    Var Accept : Boolean) of object;
  TEndDragTreeNode = procedure(Destination, Source : TTreeNode;
                    Var AttachMode : TNodeAttachMode) of object;
  TTreeViewCustomDraw = procedure(Sender : TObject; TreeNode : TTreeNode;
                        AFont : TFont; Var AColor, ABkColor : TColor) of object;

  TCustomAutoTreeView = class(TTSVCustomTreeView)
  private
    FOptions : TAutoTreeViewOptions;
    FSelectedIndex : Integer;
    FDragDropProcessingFlag : Boolean;
    FDragObject : TDragObject;
    FScrollTimerID : Integer;
    fntcd : TFont;
    FCanvas : TControlCanvas;
    FOnDragDropTreeNode : TDragDropTreeNode;
    FOnEndDragTreeNode : TEndDragTreeNode;
    FOnCustomDraw : TTreeViewCustomDraw;
    FShowNodeHint : Boolean;

    function GetDragSourceTreeNode : TTreeNode;
    procedure SetSelectedIndex(Value : Integer);
    procedure CMDrag(var Message: TCMDrag); message CM_DRAG;
    procedure VM_DELETEITEM(var Message: TMessage); message TVM_DELETEITEM;
    procedure CNNotify(var Message : TWMNotify); message CN_NOTIFY;
    procedure WMNotify(var Message : TWMNotify); message WM_NOTIFY;    
  protected
    CopyTreeNodeStructFlag : Boolean;
    MoveTreeNodeStructFlag : Boolean;
    DeleteNodeStructFlag : Boolean;
    ParentChangedTreeNode : TTreeNode;
    NewParentTreeNode : TTreeNode;

    procedure DoCustomDraw(TreeNode : TTreeNode; AFont : TFont;
               Var AColor, ABkColor : TColor); virtual;
    procedure DoStartDrag(var DragObject: TDragObject); override;
    function GetNodeFromItem(const Item: TTVItem): TTreeNode;
    function GetListItemText(TreeNode : TTreeNode) : String; virtual;
    function CreateNode: TTreeNode; override;
    procedure DeleteNodeStructure(List : TList); virtual;
    procedure InsertTreeNodeStructure(ListS, ListD : TList; Flag : Boolean); virtual;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure DoDragDropTreeNode(Destination, Source : TTreeNode; Var Accept : Boolean); virtual;
    procedure WndProc(var Message: TMessage); override;

    property Options : TAutoTreeViewOptions read FOptions write FOptions
             default [trCanDelete, trConfirmDelete];
    property SelectedIndex : Integer read FSelectedIndex write SetSelectedIndex;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure GetNodeStructure(TreeNode : TTreeNode; List : TList); virtual;
    function IsCustomDraw : Boolean; virtual;
    function MoveTreeNodeStructure(Source, Destination : TTreeNode; IsCopy : Boolean) : TTreeNode;
    property DragSourceTreeNode : TTreeNode read GetDragSourceTreeNode;
  published
    {$IFDEF DELPHI3_0}
    property ImeMode;
    property ImeName;
    {$ENDIF}
    property ShowNodeHint : Boolean read FShowNodeHint write FShowNodeHint;
    property OnAdvancedCustomDrawItem;
    property OnCustomDraw : TTreeViewCustomDraw read FOnCustomDraw write FOnCustomDraw;
    property OnDragDropTreeNode : TDragDropTreeNode read FOnDragDropTreeNode
                                   write FOnDragDropTreeNode;
    property OnEndDragTreeNode : TEndDragTreeNode read FOnEndDragTreeNode
                                   write FOnEndDragTreeNode;
  end;

  TAutoTreeView = class(TCustomAutoTreeView)
  published
    property ShowButtons;
    property BorderStyle;
    property DragCursor;
    property ShowLines;
    property ShowRoot;
    property ReadOnly;
    property DragMode;
    property HideSelection;
    property Indent;
    property Items;
    property OnEditing;
    property OnEdited;
    property OnExpanding;
    property OnExpanded;
    property OnCollapsing;
    property OnCompare;
    property OnCollapsed;
    property OnChanging;
    property OnChange;
    property OnDeletion;
    property OnGetImageIndex;
    property OnGetSelectedIndex;
    property Align;
    property Enabled;
    property Font;
    property Color;
    property ParentColor;
    property ParentCtl3D;
    property Ctl3D;
    property Options;
    property SelectedIndex;    
    property SortType;
    property TabOrder;
    property TabStop default True;
    property Visible;
    property OnClick;
    property OnEnter;
    property OnExit;
    property OnDragDrop;
    property OnDragOver;
    property OnStartDrag;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnDblClick;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property PopupMenu;
    property ParentFont;
    property ParentShowHint;
    property ShowHint;
    property Images;
    property StateImages;
  end;

  EDBTreeViewError = class(Exception);


  TDBTreeView = class;

  TDataLinkTreeView = class(TDataLink)
  private
    FDBTreeView: TDBTreeView;
    Filter : String;
    Filtered : Boolean;
  protected
    procedure ActiveChanged; override;
    procedure DataSetChanged; override;
    procedure DataSetScrolled(Distance: Integer); override;
    procedure RecordChanged(Field: TField); override;
    procedure LayoutChanged; override;
  end;

  TDBTreeNodes = class;

  TDBTreeNode = class
  protected
    DBTreeNodes : TDBTreeNodes;

    FKeyFieldValue : Variant;
    FParentFieldValue : Variant;
    FTreeNode : TTreeNode;
    FChildLoaded : Boolean;

    Refreshed : Boolean;
    Deleted : Boolean;
    FIndex : Integer;
    FListText : String;

    FBkColor : TColor;
    FColor : TColor;
    FFontStyle : TFontStyles;
    FFontName : TFontName;
    FIsCustomDraw : Boolean;

    procedure SetChildLoaded(Value : Boolean);
    procedure SetIsCustomDraw(Value : Boolean);
    procedure DestroyChildren;    
  protected
    procedure SetKeyFieldValue(Value : Variant);
  public
    constructor Create(AOwner : TDBTreeNodes; Value : Variant);
    procedure LoadChildren(Recurse: Boolean);

    property BkColor : TColor read FBkColor write FBkColor;
    property Color : TColor read FColor write FColor;
    property FontStyle : TFontStyles read FFontStyle write FFontStyle;
    property FontName : TFontName read FFontName write FFontName;
    property IsCustomDraw : Boolean read FIsCustomDraw write SetIsCustomDraw;

    property ChildLoaded : Boolean read FChildLoaded write SetChildLoaded;
    property Index : Integer read FIndex;
    property KeyFieldValue : Variant read FKeyFieldValue;
    property ParentFieldValue : Variant read FParentFieldValue;
    property TreeNode : TTreeNode read FTreeNode write FTreeNode;
  end;

  TDBTreeNodes = class
  private
    FDBTreeView : TDBTreeView;
    FList : TList;
    FlagBuzy : Boolean;
    FCustomDrawCount : Integer;

    function GetDBNodeFromIndex(Index : Integer) : TDBTreeNode;
    function GetMaxKeyFieldValue : Variant;
  protected
    procedure BeginRefreshRecord;
    procedure EndRefreshRecord;
    function FindNearest(Value : Variant; Var Index : Integer) : Boolean;
    procedure RefreshParents;
    procedure Clear;
    procedure Delete(ADBTreeNode : TDBTreeNode);
    procedure NodeChangeParent(TreeNode : TTreeNode; Value : Variant);
  public
    constructor Create(ADBTreeView : TDBTreeView);
    destructor Destroy; override;
    procedure RefreshRecord;
    function Count : Integer;
    function GetKeyFieldValue(Value : TTreeNode) : Variant;
    function GetParentValue(Value : TTreeNode) : Variant;
    function GetDBTreeNode(Value : Variant) : TDBTreeNode;
    function GetTreeNode(Value : Variant) : TTreeNode;
    function GetDBTreeNodeByTreeNode(Value : TTreeNode) : TDBTreeNode;
    function IndexOf(Value : TTreeNode) : Integer;
    property Items[Index: Integer]: TDBTreeNode read GetDBNodeFromIndex; default;
    property MaxKeyFieldValue : Variant read GetMaxKeyFieldValue;
  end;

  TAddNewDBTreeNodeEvent = procedure(Sender: TObject; var DBTreeNode: TDBTreeNode) of Object;
  TCreateNewKeyValue = procedure(Sender: TObject; var NewKeyValue: Variant) of Object;
  TSetDisplayItemText = procedure(Sender: TObject; var DisplayText: String) of Object;
  TDBTreeViewOption = (trDBCanDelete, trDBConfirmDelete, trCanDBNavigate,
                    trSmartRecordLoad, trSmartRecordCopy, trCheckHasChildren,
                    trUseNodeData);
  TDBTreeViewOptions = set of TDBTreeViewOption;


  TDBTreeView = class(TCustomAutoTreeView) 
  private
    DataChangedBusy : Boolean;
    NonUserInsertFlag : Boolean;
    DoInsertFlag : Boolean;
    NodeHasExpanded : Boolean;

    FDataLink: TDataLinkTreeView;
    FDBTreeNodes : TDBTreeNodes;
    InsertedTreeNode : TTreeNode;
    FAddNewItem : TAddNewDBTreeNodeEvent;
    FCreateNewKeyValue : TCreateNewKeyValue;
    FOnSetDisplayItemText : TSetDisplayItemText;

    FKeyFieldName: String;
    FListFieldName: String;
    FParentFieldName: String;
    FDisplayFieldName : String;
    FImageIndexFieldName : String;
    FStateIndexFieldName : String;
    FRootValue : Variant;
    FSeparatedSt : String;
    FOptions : TDBTreeViewOptions;

    FImageIndexField: TField;
    FKeyField: TField;
    FListField: TField;
    FDisplayFields: TList;
    FParentField: TField;
    FStateIndexField: TField;    

    FEditInstance: Pointer;
    FDefEditProc: Pointer;
    FEditHandle : HWND;

    procedure DataLinkActiveChanged;
    procedure DataLinkRecordChanged(Field: TField);
    procedure DataChanged;
    procedure RecordEdit(Field : TField);
    procedure RecordInsert(Field : TField);

    function GetDataSource: TDataSource;
    function GetRootValue: String;
    function GetSeletectedDBTreeNode : TDBTreeNode;
    procedure Scroll;
    procedure SetDataSource(Value: TDataSource);
    procedure SetDisplayFieldName(const Value: string);
    procedure SetImageIndexFieldName(const Value: string);
    procedure SetKeyFieldName(const Value: string);
    procedure SetListFieldName(const Value: string);
    procedure SetRootValue(const Value: String);
    procedure SetStateIndexFieldName(const Value: string);
    procedure SetOptions(const Value : TDBTreeViewOptions);
    procedure SetParentFieldName(const Value: string);
    procedure SetSeparatedSt(const Value: string);

    function GetDisplayText : String;

    procedure CNNotify(var Message: TWMNotify); message CN_NOTIFY;
    procedure VM_DELETEITEM(var Message: TMessage); message TVM_DELETEITEM;
    procedure VM_INSERTITEM(var Message: TMessage); message TVM_INSERTITEM;
    procedure VM_SELECTITEM(var Message: TMessage); message TVM_SELECTITEM;
    procedure WMPAINT(var Message: TMessage); message WM_PAINT;
    procedure EditWndProc(var Message: TMessage);
//    procedure FrameSelectedItem;
  protected
    function CanExpand(Node: TTreeNode): Boolean; override;
    function CanCollapse(Node: TTreeNode): Boolean; override;
    procedure CreateHandle; override;
    procedure Change(Node: TTreeNode); override;
    procedure DeleteNodeStructure(List : TList); override;
    procedure DoCustomDraw(TreeNode : TTreeNode; AFont : TFont;
               Var AColor, ABkColor : TColor); override;
    function GetListItemText(TreeNode : TTreeNode) : String; override;
    procedure Edit(const Item: TTVItem); override;
    procedure InsertTreeNodeStructure(ListS, ListD : TList; Flag : Boolean); override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure WndProc(var Message: TMessage); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure GetNodeStructure(TreeNode : TTreeNode; List : TList); override;
    function GetImageIndexField : TField;
    function GetKeyField : TField;
    function GetListField : TField;
    function GetParentField : TField;
    function GetStateIndexField : TField;

    procedure GotoKeyFieldValue(Value : Variant);
    function IsCustomDraw : Boolean; override;
    procedure AssignFields;
    procedure RefreshItems;

    procedure WMMouseWheel(var Message: TWMMouseWheel);message WM_MOUSEWHEEL;

    property DBSelected : TDBTreeNode read GetSeletectedDBTreeNode;
    property DBTreeNodes : TDBTreeNodes read FDBTreeNodes;
    property Items;
    property Selected;
  published
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property DisplayField: string read FDisplayFieldName write SetDisplayFieldName;
    property ImageIndexField: string read FImageIndexFieldName write SetImageIndexFieldName;
    property KeyField: string read FKeyFieldName write SetKeyFieldName;
    property ListField: string read FListFieldName write SetListFieldName;
    property ParentField: string read FParentFieldName write SetParentFieldName;
    property RootValue : String read GetRootValue write SetRootValue;
    property SeparatedSt : string read FSeparatedSt write SetSeparatedSt;
    property StateIndexField: string read FStateIndexFieldName write SetStateIndexFieldName;    
    property ShowButtons;
    property BorderStyle;
    property DragCursor;
    property ShowLines;
    property ShowRoot;
    property ReadOnly;
    property DragMode;
    property HideSelection;
    property Indent;
    property OnEditing;
    property OnEdited;
    property OnExpanding;
    property OnExpanded;
    property OnCollapsing;
    property OnCompare;
    property OnCollapsed;
    property OnChanging;
    property OnChange;
    property OnDeletion;
    property OnGetImageIndex;
    property OnGetSelectedIndex;
    property Align;
    property Enabled;
    property Font;
    property Color;
    property ParentColor;
    property ParentCtl3D;
    property Ctl3D;
    property Options : TDBTreeViewOptions read FOptions write SetOptions;
    property SortType;
    property SelectedIndex;
    property TabOrder;
    property TabStop default True;
    property Visible;
    property OnAddNewItem : TAddNewDBTreeNodeEvent read FAddNewItem write FAddNewItem;
    property OnCreateNewKeyValue : TCreateNewKeyValue read FCreateNewKeyValue
                                 write FCreateNewKeyValue;
    property OnSetDisplayItemText : TSetDisplayItemText read FOnSetDisplayItemText
                                 write FOnSetDisplayItemText;
    property OnClick;
    property OnEnter;
    property OnExit;
    property OnDragDrop;
    property OnDragOver;
    property OnStartDrag;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnDblClick;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property PopupMenu;
    property ParentFont;
    property ParentShowHint;
    property ShowHint;
    property Images;
    property StateImages;
end;

function DBTrDataSetLocate(DataSet : TDataSet; const KeyFields: string;
   const KeyValues: Variant; Options: TLocateOptions): Boolean;

   
const ATreeViewDelConfirm = 37201;
const ADBTreeViewSmartLoadS = 37202;


implementation

function DBTrDataSetLocate(DataSet : TDataSet; const KeyFields: string;
   const KeyValues: Variant; Options: TLocateOptions): Boolean;
begin
  Result := DataSet.Locate(KeyFields, KeyValues, Options);
end;

function VarEquals(const V1, V2: Variant): Boolean;
begin
  Result := False;
  try
    Result := V1 = V2;
  except
  end;
end;

function VarFirstMore(const V1, V2: Variant): Boolean;
begin
  Result := False;
  try
    Result := V1 >= V2;
  except
  end;
end;

function VarFirstMoreEx(const V1, V2: Variant): Boolean;
begin
  Result := False;
  try
    Result := V1 > V2;
  except
  end;
end;

var
  AutoTreeViewDragImages : TDragImageList;
  DropSourceTreeNode : TTreeNode;
  OldDragOverTreeNode : TTreeNode;

procedure ScrollTreeViewTimerProc(Wnd: HWnd; Msg, TimerID, SysTime: Longint); stdcall;
Var
  p : TPoint;
begin
  GetCursorPos(p);
  Windows.ScreenToClient(GetCapture, p);
  SendMessage(GetCapture, LongInt(WM_MOUSEMOVE), MK_LBUTTON, MAKELONG(p.X, p.Y));
end;

constructor TCustomAutoTreeView.Create(AOwner: TComponent);
begin
  FScrollTimerID := -1;
  inherited Create(AOwner);
  CopyTreeNodeStructFlag := False;
  MoveTreeNodeStructFlag := False;
  DeleteNodeStructFlag := False;
  ParentChangedTreeNode := Nil;
  NewParentTreeNode := Nil;
  FSelectedIndex := -1;
  FOptions := [trCanDelete, trConfirmDelete];
  FDragDropProcessingFlag := False;
  fntcd := TFont.Create;
  FCanvas := TControlCanvas.Create;
  FShowNodeHint := True;  
end;

destructor TCustomAutoTreeView.Destroy;
begin
  fntcd.Free;
  FCanvas.Free;  
  inherited Destroy;
end;

type
TtmpDragObject = class(TDragControlObject)
protected
  function GetDragCursor(Accepted: Boolean; X, Y: Integer): TCursor; override;
end;

function TtmpDragObject.GetDragCursor(Accepted: Boolean; X, Y: Integer): TCursor;
begin
  if Accepted then begin
    if Not (GetKeyState(VK_CONTROL) < 0) then
      Result := TCustomAutoTreeView(Control).DragCursor
    else  Result := -1011;
   end else Result := crNoDrop;
end;

procedure TCustomAutoTreeView.DoStartDrag(var DragObject: TDragObject);
begin
  DragObject := TtmpDragObject.Create(self);
  inherited;
  AutoTreeViewDragImages := GetDragImages;
  if(self.Focused) then
    DropSourceTreeNode := Selected
  else DropSourceTreeNode := Nil;

end;

procedure TCustomAutoTreeView.DoDragDropTreeNode(Destination, Source : TTreeNode;
          Var Accept : Boolean);
begin
  if(Assigned(FOnDragDropTreeNode)) then
    FOnDragDropTreeNode(Destination, Source, Accept);
end;


procedure TCustomAutoTreeView.DeleteNodeStructure(List : TList);
begin
end;

procedure TCustomAutoTreeView.GetNodeStructure(TreeNode : TTreeNode; List : TList);

 procedure GetNodeStructure_(TreeNode : TTreeNode; List : TList);
 Var
   tn : TTreeNode;
 begin
   if (TreeNode <> Nil) And TreeNode.HasChildren then  begin
    tn := TreeNode.GetFirstChild;
    while (tn <> nil) do begin
      List.Add(tn);
      if(tn.HasChildren) then
        GetNodeStructure_(tn, List);
      tn := TreeNode.GetNextChild (tn);
    end;
  end;
 end;

 begin
  List.Add(TreeNode);
  GetNodeStructure_(TreeNode, List);
end;

procedure TCustomAutoTreeView.InsertTreeNodeStructure(ListS, ListD : TList; Flag : Boolean);
begin
end;

function TCustomAutoTreeView.GetDragSourceTreeNode : TTreeNode;
begin
  if(DropSourceTreeNode <> Nil) And (DropSourceTreeNode.TreeView = self) then
    Result := DropSourceTreeNode
  else Result := Nil;
end;

procedure TCustomAutoTreeView.SetSelectedIndex(Value : Integer);
Var
  i : Integer;
begin
  if(Value <> FSelectedIndex) then begin
    FSelectedIndex := Value;
    for i := 0 to Items.Count - 1 do
      Items[i].SelectedIndex := FSelectedIndex;
  end;
end;

function TCustomAutoTreeView.CreateNode: TTreeNode;
begin
  Result := Inherited CreateNode;
  if(result <> Nil) And (FSelectedIndex <> -1) then
      Result.SelectedIndex := FSelectedIndex
end;

procedure TCustomAutoTreeView.KeyDown(var Key: Word; Shift: TShiftState);
Var
  St : String;
begin
  if(Key = VK_DELETE) And (trCanDelete in Options)
  And Not ReadOnly And (Selected <> Nil) And Not IsEditing then begin
    St := LoadStr(ATreeViewDelConfirm) + ' "' + Selected.Text + '"';
    if not (trConfirmDelete in Options) Or
     (MessageDlg(St, mtConfirmation, mbOKCancel, 0) <> idCancel) then
       Items.Delete(Selected);
  end;
  inherited;
end;

procedure TCustomAutoTreeView.WndProc(var Message: TMessage);
Var
  Id : Integer;
begin
  if (FScrollTimerID = -1) And Dragging then begin
     FScrollTimerID := SetTimer(Handle, 1, 200, @ScrollTreeViewTimerProc);
  end;
  if (FScrollTimerID > -1) And Not Dragging then begin
    Id := FScrollTimerID;
    FScrollTimerID := -1;
    KillTimer(Handle, Id);
  end;
  inherited;
end;

procedure TCustomAutoTreeView.CMDrag(var Message: TCMDrag);
Var
 lpht: TTVHitTestInfo;
 TreeItem : HTreeItem;
 TreeNode : TTreeNode;

 function GetUnVisible(t : TTreeNode; PrevFlag : Boolean; Var NewT : TTReeNode) : Boolean;
 Var
   Rect : TRect;
   tempt : TTreeNode;
 begin
   Result := False;
   if(PrevFlag) And (t <> Nil) And (t.GetPrevVisible <> Nil) then begin
     tempt := t.GetPrevVisible;
     TreeView_GetItemRect(tempt.handle, tempt.ItemId, Rect, True);
     If(Rect.Top <= Top) then begin
       Result := True;
       NewT := tempt;
     end
     else if(tempt.GetPrevVisible <> Nil) then begin
       tempt := t.GetPrevVisible;
       TreeView_GetItemRect(tempt.handle, tempt.ItemId, Rect, True);
       If(Rect.Top <= Top) then begin
         Result := True;
         NewT := tempt;
       end;
     end;
   end;
   if( Not PrevFlag) And (t <> Nil) And (t.GetNextVisible <> Nil) then begin
     tempt := t.GetNextVisible;
     TreeView_GetItemRect(tempt.handle, tempt.ItemId, Rect, True);
     If(Rect.Bottom + 1 >= Top + Height) then begin
       Result := True;
       NewT := tempt;
     end
     else if(tempt.GetNextVisible <> Nil) then begin
       tempt := t.GetNext;
       TreeView_GetItemRect(tempt.handle, tempt.ItemId, Rect, True);
       If(Rect.Bottom + 1 >= Top + Height) then begin
         Result := True;
         NewT := tempt;
       end
    end;
   end;
 end;

 procedure HideDragImage;
 begin
   if(AutoTreeViewDragImages <> NIl) then
     AutoTreeViewDragImages.HideDragImage
   else if(FDragObject <> Nil) then
      FDragObject.HideDragImage;
 end;

 procedure ShowDragImage;
 begin
   if(AutoTreeViewDragImages <> NIl) then
     AutoTreeViewDragImages.ShowDragImage
   else if(FDragObject <> Nil) then
      FDragObject.ShowDragImage;
 end;

Var
  SelDrag : TTreeNode;
  CorrectDragFlag, IsCopyFlag : Boolean;
begin

  CorrectDragFlag := False;
  with Message, DragRec^ do begin
    case DragMessage of
    dmDragEnter: begin
       FDragDropProcessingFlag := True;
       OldDragOverTreeNode := Nil;
       FDragObject := Source;
     end;
     dmDragMove: begin
      lpht.pt := ScreenToClient(Point(Pos.X, Pos.Y));
      lpht.flags := TVHT_ONITEM;
      TreeItem := TreeView_HitTest(handle, lpht);

      if(TreeItem <> Nil) then begin
        TreeNode := Items.GetNode(TreeItem);

        if(OldDragOverTreeNode <> Nil) And (OldDragOverTreeNode.GetPrevVisible = TreeNode)
        And (GetUnVisible(TreeNode, True, SelDrag)) then begin
          HideDragImage;
          TreeView_SelectSetFirstVisible(SelDrag.handle, SelDrag.ItemId);
          ShowDragImage;
        end;

        if(OldDragOverTreeNode <> Nil) And (OldDragOverTreeNode.GetNextVisible = TreeNode)
        And (GetUnVisible(TreeNode, False, SelDrag)) then begin
            lpht.pt := Point(Left + 3, Top + 3);
            lpht.flags := TVHT_ONITEM;
            TreeItem := TreeView_HitTest(handle, lpht);
            if(TreeItem <> NIl) then begin
              SelDrag := Items.GetNode(TreeItem);
              if(SelDrag <> Nil) And (SelDrag.GetNextVisible <> Nil) then begin
                SelDrag := SelDrag.GetNextVisible;
                HideDragImage;
                TreeView_SelectSetFirstVisible(SelDrag.handle, SelDrag.ItemId);
                ShowDragImage;
              end;
            end;
        end;
        if (OldDragOverTreeNode <> TreeNode) then begin
          OldDragOverTreeNode := TreeNode;
          if(OldDragOverTreeNode <> Nil) then begin
            HideDragImage;
            TreeView_SelectDropTarget(Handle, OldDragOverTreeNode.ItemId);
            ShowDragImage;
          end;
        end;
     end;
   end;
   dmDragLeave : begin
     if(DropSourceTreeNode <> Nil) then begin
       HideDragImage;
       TreeView_SelectDropTarget(Handle, Nil);
       DropSourceTreeNode.Selected := True;
       ShowDragImage;
     end;
     FDragObject := Nil;
   end;
   dmDragCancel, dmDragDrop:  begin
       FDragObject := Nil;
       if(OldDragOverTreeNode <> Nil) then begin
         TreeView_SelectDropTarget(Handle, NIl);
         OldDragOverTreeNode.Selected := True;
         Invalidate;
         IsCopyFlag := GetKeyState(VK_CONTROL) < 0;
         if (OldDragOverTreeNode <> Nil) And (DropSourceTreeNode <> Nil)
         And Not OldDragOverTreeNode.HasAsParent(DropSourceTreeNode)
         And (OldDragOverTreeNode <> DropSourceTreeNode)
         And ((OldDragOverTreeNode <> DropSourceTreeNode.Parent)
             Or IsCopyFlag Or Assigned(FOnEndDragTreeNode)) then begin
           CorrectDragFlag := True;
           DoDragDropTreeNode(OldDragOverTreeNode, DropSourceTreeNode, CorrectDragFlag);
           if(CorrectDragFlag) then begin
             TreeNode := MoveTreeNodeStructure(DropSourceTreeNode, OldDragOverTreeNode, IsCopyFlag);
             if(TreeNode <> NIl) then begin
               TreeNode.MakeVisible;
               Selected := TreeNode;
             end;
              Message.DragMessage := dmDragDrop;
              DropTarget := OldDragOverTreeNode;
           end;
         end;
         OldDragOverTreeNode := Nil;
       end;
       FDragDropProcessingFlag := False;       
     Invalidate;
   end;
   end;
 end;


 if(DropSourceTreeNode <> Nil) And (Message.DragMessage <> dmDragDrop)
 And (Message.DragMessage <> dmDragCancel)
 And (OldDragOverTreeNode <> DropSourceTreeNode) And (OldDragOverTreeNode <> Nil) then begin
   CorrectDragFlag := (Not DropSourceTreeNode.HasChildren Or Not OldDragOverTreeNode.HasAsParent(DropSourceTreeNode));
   if(CorrectDragFlag) then
     DoDragDropTreeNode(OldDragOverTreeNode, DropSourceTreeNode, CorrectDragFlag);
 end;

 inherited;

 if (Message.DragMessage = dmDragDrop) Or (Message.DragMessage = dmDragCancel) then begin
   DropSourceTreeNode := Nil;
   AutoTreeViewDragImages := Nil;
   DropTarget := Nil;
 end;

 if(Message.DragMessage = dmDragMove) And (CorrectDragFlag) And (Message.Result = 0) then
   Message.Result := 1;
end;


function TCustomAutoTreeView.MoveTreeNodeStructure(Source, Destination : TTreeNode; IsCopy : Boolean) : TTreeNode;
var
  i, ind : Integer;
  ListS, ListD : TList;
  tr : TTreeNode;
  AStyle : TNodeAttachMode;
begin
  ListS := TList.Create;
  ListD := TList.Create;
  CopyTreeNodeStructFlag := IsCopy;
  GetNodeStructure(Source, ListS);
  AStyle := naAddChild;
  if Assigned(FOnEndDragTreeNode) then
    FOnEndDragTreeNode(Destination, Source, AStyle);
  if(AStyle = naAddChild) Or (AStyle = naAddChildFirst) then
    Destination.HasChildren := True;
  if(Destination.TreeView <> Source.TreeView) Or IsCopy then begin
    CopyTreeNodeStructFlag := True;
    tr := Nil;
    for i := 0 to ListS.Count - 1 do begin
      if(i = 0) then begin
        case AStyle of
          naAdd: tr := Items.Add(Destination, GetListItemText(TTreeNode(ListS.List^[i])));
          naAddFirst : tr := Items.AddFirst(Destination, GetListItemText(TTreeNode(ListS.List^[i])));
          naAddChild : tr := Items.AddChild(Destination, GetListItemText(TTreeNode(ListS.List^[i])));
          naAddChildFirst: tr := Items.AddChildFirst(Destination, GetListItemText(TTreeNode(ListS.List^[i])));
          naInsert: tr := Items.Insert(Destination, GetListItemText(TTreeNode(ListS.List^[i])));
        end;
      end
      else begin
        ind := ListS.IndexOf(TTreeNode(ListS.List^[i]).Parent);
        tr := Items.AddChild(TTreeNode(ListD.List^[ind]), GetListItemText(TTreeNode(ListS.List^[i])))
      end;
      if(tr <> Nil) then
        ListD.Add(tr);
    end;
    InsertTreeNodeStructure(ListS, ListD, True);
    CopyTreeNodeStructFlag := False;
  end;
  if(Destination.TreeView = Source.TreeView) And Not Iscopy then begin
    MoveTreeNodeStructFlag := True;
    Source.MoveTo(Destination, AStyle);
    if(AStyle = naAddChild) Or (AStyle = naAddChildFirst) then
      NewParentTreeNode := Destination
    else  NewParentTreeNode := Destination.Parent;
    ParentChangedTreeNode := Source;
    MoveTreeNodeStructFlag := False;
  end;
  Result := Nil;
  if(ListD.Count > 0) then
    Result := TTreeNode(ListD[0]);
  if(ParentChangedTreeNode <> Nil) then
    Result := ParentChangedTreeNode;
  ListS.Free;
  ListD.Free;
  if Not TAutoTreeView(Source.TreeView).ReadOnly
  And (Destination.TreeView <> Source.TreeView) And Not IsCopy then
    Source.Free;
end;

function TCustomAutoTreeView.GetNodeFromItem(const Item: TTVItem): TTreeNode;
begin
  with Item do
    if (state and TVIF_PARAM) <> 0 then Result := Pointer(lParam)
    else Result := Items.GetNode(hItem);
end;

function TCustomAutoTreeView.GetListItemText(TreeNode : TTreeNode) : String;
begin
  if(TreeNode <> Nil) then
    Result := TreeNode.Text;
end;

procedure TCustomAutoTreeView.VM_DELETEITEM(var Message: TMessage);
Var
  i : Integer;
  List : TList;
  tn : TTreeNode;
begin
  if(TVI_ROOT <> HTreeItem(Message.lparam))
  And Not DeleteNodeStructFlag then begin
    DeleteNodeStructFlag := True;
    tn := Items.GetNode(HTreeItem(Message.lparam));
    if(tn <> Nil) then begin
      List := TList.Create;
      GetNodeStructure(tn, List);
      if Not CopyTreeNodeStructFlag then
        DeleteNodeStructure(List);
      for i := List.Count - 1 downto 0 do
        if(TTreeNode(List.List^[i]) <> tn) then
          TTreeNode(List.List^[i]).Free;
      List.Free;
    end;
    DeleteNodeStructFlag := False;
  end;
  inherited;
end;

function TCustomAutoTreeView.IsCustomDraw : Boolean;
begin
  Result := Assigned(FOnCustomDraw);
end;

procedure TCustomAutoTreeView.DoCustomDraw(TreeNode : TTreeNode; AFont : TFont;
               Var AColor, ABkColor : TColor);
begin
  if Assigned(FOnCustomDraw) then
    FOnCustomDraw(self, TreeNode, AFont, AColor, ABkColor);
end;


procedure TCustomAutoTreeView.CNNotify(var Message : TWMNotify);
{Var
  pnmlv : PNMLVCustomDraw;
  tr : TTreeNode;
  htr : HTReeItem;
  Color, BkColor : TColor;}
begin
{  if(Message.nmhdr^.code = NM_CUSTOMDRAW) then  begin
    pnmlv := PNMLVCustomDraw(TMessage(Message).lParam);
    if(pnmlv^.nmcd.dwDrawStage = CDDS_PREPAINT) then begin
      if IsCustomDraw then
        Message.Result := CDRF_NOTIFYITEMDRAW
      else Message.Result := CDRF_DODEFAULT;
    end;
    if(pnmlv^.nmcd.dwDrawStage = CDDS_ITEMPREPAINT)then begin
      htr := Pointer(pnmlv^.nmcd.dwItemSpec);
      tr := Items.GetNode(htr);
      fntcd.Assign(Font);
      Color := Font.Color;
      BkColor := clWindow;
      DoCustomDraw( tr, fntcd, Color, BkColor);
      if (pnmlv^.nmcd.uItemState ANd TVGN_CARET = 0)
      And (pnmlv^.nmcd.uItemState And TVGN_DROPHILITE = 0)
      And (OldDragOverTreeNode <> tr) then begin
        pnmlv^.clrText := ColorToRGB(Color);
        pnmlv^.clrTextBk := ColorToRGB(bkColor);
      end;

      SelectObject(pnmlv^.nmcd.hdc, fntcd.Handle);
      Message.Result  := CDRF_NEWFONT;
    end;
  end else inherited;
 }
 inherited;
end;

type
PAToolTipText = ^TAToolTipText;
TAToolTipText = packed record
  hdr: TNMHDR;
  lpszText: PAnsiChar;
  szText: array[0..79] of Char;
  hinst: THandle;
  uFlags: UINT;
end;


procedure TCustomAutoTreeView.WMNotify(var Message : TWMNotify);
begin
  if ((Message.nmhdr^.code =  TTN_NEEDTEXTA) or (Message.nmhdr^.code =  TTN_NEEDTEXTW))
  and Not FShowNodeHint then begin
     PAToolTipText(TMessage(Message).lparam).lpszText := PChar('');
     TMessage(Message).Result := 0;
  end else  inherited;
end;



{TDataLinkTreeView}
procedure TDataLinkTreeView.ActiveChanged;
begin
  if(DataSet <> Nil) then begin
    Filter := DataSet.Filter;
    Filtered := DataSet.Filtered;
  end else begin
    Filter := '';
    Filtered := False;
  end;
  if FDBTreeView <> nil then FDBTreeView.DataLinkActiveChanged;
end;

procedure TDataLinkTreeView.DataSetChanged;
begin
  if(DataSet <> Nil)
  And ((Filter <> DataSet.Filter) Or (Filtered <> DataSet.Filtered)) then begin
    Filter := DataSet.Filter;
    Filtered := DataSet.Filtered;
    FDBTreeView.DataLinkActiveChanged;
  end else FDBTreeView.DataChanged;
end;

procedure TDataLinkTreeView.LayoutChanged;
begin
end;

procedure TDataLinkTreeView.DataSetScrolled(Distance: Integer);
begin
  FDBTreeView.Scroll;
end;

procedure TDataLinkTreeView.RecordChanged(Field: TField);
begin
  FDBTreeView.DataLinkRecordChanged(Field);
end;

{TDBTreeNode}
constructor TDBTreeNode.Create(AOwner : TDBTreeNodes; Value : Variant);
Var
  i : Integer;
begin
  DBTreeNodes := AOwner;

  FBkColor := clWindow;
  FColor  := DBTreeNodes.FDBTreeView.Font.Color;
  FFontStyle := DBTreeNodes.FDBTreeView.Font.Style;
  FFontName := DBTreeNodes.FDBTreeView.Font.Name;
  FIsCustomDraw := False;

  FKeyFieldValue := Value;
  DBTreeNodes.FindNearest(Value, findex);
  if(findex < 0) then findex := 0;
  for i := fIndex to DBTreeNodes.FList.Count - 1 do
    Inc(DBTreeNodes[i].findex);
  DBTreeNodes.FList.Insert(findex, self);
end;


procedure TDBTreeNode.SetKeyFieldValue(Value : Variant);
Var
  newind, i : Integer;
begin
  if(FKeyFieldValue <> Value) then begin
    FKeyFieldValue := Value;
    DBTreeNodes.FindNearest(Value, newind);
    if(newind <> fIndex) then begin
      if(newind > fIndex) then
        for i := fIndex + 1 to newind do
          Inc(DBTreeNodes[i].findex)
      else
        for i := newind to fIndex - 1 do
          Dec(DBTreeNodes[i].findex);
      DBTreeNodes.FList.Delete(findex);
      findex := newind;
      DBTreeNodes.FList.Insert(findex, self);
    end;
  end;
end;

procedure TDBTreeNode.DestroyChildren;
Var
  DBTreeNode : TDBTreeNode;
  i : Integer;
  List : TList;
  Flag : Boolean;
begin
  if DBTreeNodes.FDBTreeView.DataChangedBusy then exit;
  Flag := DBTreeNodes.FDBTreeView.DataChangedBusy;
  DBTreeNodes.FDBTreeView.DataChangedBusy := True;
  DBTreeNodes.FDBTreeView.DeleteNodeStructFlag := True;
  List := TList.Create;
  DBTreeNodes.FDBTreeView.GetNodeStructure(TreeNode, List);
  for i := 1 to List.Count - 1 do begin
    DBTreeNode := DBTreeNodes.GetDBTreeNodeByTreeNode(TTreeNode(List[i]));
    if (DBTreeNode <> Nil) then begin
     DBTreeNodes.FList.Remove(DBTreeNode);
     DBTreeNode.TreeNode.Delete;
     DBTreeNode.Free;
    end;
  end;
  List.Free;
  TreeNode.HasChildren := True;
  DBTreeNodes.FDBTreeView.DeleteNodeStructFlag := False;  
  DBTreeNodes.FDBTreeView.DataChangedBusy := Flag;
end;

procedure TDBTreeNode.LoadChildren(Recurse: Boolean);
Var
  DataSet : TDataSet;
  Flag, FlagDis : Boolean;
  bm : TBookMark;
begin
  Flag := DBTreeNodes.FDBTreeView.DataChangedBusy;
  DBTreeNodes.FDBTreeView.DataChangedBusy := True;
  DataSet := DBTreeNodes.FDBTreeView.FDataLink.DataSet;
  FlagDis := DataSet.ControlsDisabled;
  if Not flagDis then
    DataSet.DisableControls;
  bm := DataSet.GetBookmark;
  TreeNode.HasChildren := DBTrDataSetLocate(DataSet, DBTreeNodes.FDBTreeView.FParentFieldName, KeyFieldValue, []);
  if (TreeNode.HasChildren) then
    while (Not DataSet.EOF)
    And VarEquals(DBTreeNodes.FDBTreeView.FParentField.Value, KeyFieldValue) do begin
      DBTreeNodes.RefreshRecord;
      if(Recurse) then
        DBTreeNodes.FDBTreeView.DBSelected.LoadChildren(True);
      DataSet.Next;
    end;

  DataSet.GotoBookmark(bm);
  DataSet.FreeBookmark(bm);
  if Not flagDis then
    DataSet.EnableControls;
  DBTreeNodes.FDBTreeView.DataChangedBusy := Flag;
end;

procedure TDBTreeNode.SetChildLoaded(Value : Boolean);
begin
  if(Value <> FChildLoaded) then begin
    FChildLoaded := Value;  
    if(Value) then
      LoadChildren(False)
    else DestroyChildren;
  end;
end;

procedure TDBTreeNode.SetIsCustomDraw(Value : Boolean);
begin
  if(FIsCustomDraw <> Value) then begin
    FIsCustomDraw := Value;
    if(Value) then
      Inc(DBTreeNodes.FCustomDrawCount)
    else Dec(DBTreeNodes.FCustomDrawCount);
  end;
end;

{TDBTreeNodes}
constructor TDBTreeNodes.Create(ADBTreeView : TDBTreeView);
begin
  FDBTreeView := ADBTreeView;
  FList := TList.Create;
  FlagBuzy := False;
  FCustomDrawCount := 0;
end;

destructor TDBTreeNodes.Destroy;
begin
  Clear;
  FList.Free;

  inherited Destroy;
end;


procedure TDBTreeNodes.BeginRefreshRecord;
Var
  i : Integer;
begin

  for i := 0 to Count - 1 do
    Items[i].Refreshed := False;
end;

procedure TDBTreeNodes.EndRefreshRecord;
Var
 i : Integer;
begin
  i := 0;
  while i < Count  do
    if Not Items[i].Refreshed then begin
       FDBTreeView.DataChangedBusy := False;
       Delete(Items[i]);
       FDBTreeView.DataChangedBusy := True;
       i := 0;
    end else  Inc(i);
end;

function TDBTreeNodes.FindNearest(Value : Variant; Var Index : Integer) : Boolean;
var
  Min, Max : LongInt;
begin
  Index := -1; 
  Result := False;
  if (FList.Count = 0) Or VarIsNull(Value)
  Or VarFirstMoreEx( TDBTreeNode(FList.List^[0]).FKeyFieldValue, Value) then
    exit;

  if VarFirstMoreEx(Value, MaxKeyFieldValue) then begin
    Index := FList.Count;
    Exit;
  end;

  Min := 0;
  Max := FList.Count - 1;

  repeat
    if ((Max - Min) = 1) then begin
      if(Min = Index) then Min := Max;
      if(Max = Index) then Max := Min;
    end;
    Index := Min + ((Max - Min) div 2);
    if VarEquals(Value, TDBTreeNode(FList.List^[Index]).FKeyFieldValue) then break;
    if VarFirstMore(Value, TDBTreeNode(FList.List^[Index]).FKeyFieldValue) then
      Min := Index
    else  Max := Index;
  until (Min = Max);
  if Not VarEquals(Value, TDBTreeNode(FList.List^[Index]).KeyFieldValue) then begin
    if (Index < FList.Count - 1) And VarFirstMore(Value, TDBTreeNode(FList.List^[Index]).FKeyFieldValue) then
       Inc(Index);
  end else Result := True;
end;

procedure TDBTreeNodes.RefreshRecord;
Var
  DBTreeNode : TDBTreeNode;
  ParentTreeNode : TTreeNode;
  bm : TBookMark;
  FlagDis : Boolean;
begin
  FDBTreeView.NonUserInsertFlag := True;
  if varIsNull(FDBTreeView.FKeyField.Value) then exit;

  DBTreeNode := GetDBTreeNode(FDBTreeView.FKeyField.Value);
  ParentTreeNode := GetTreeNode(FDBTreeView.FParentField.Value);

  if(DBTreeNode = Nil) then begin
    DBTreeNode := TDBTreeNode.Create(self, FDBTreeView.FKeyField.Value);
    DBTreeNode.FParentFieldValue := FDBTreeView.FParentField.Value;
    DBTreeNode.FTreeNode := Nil;
  end;
  if Not VarEquals(DBTreeNode.FKeyFieldValue,  FDBTreeView.FKeyField.Value) then
    DBTreeNode.SetKeyFieldValue(FDBTreeView.FKeyField.Value);
  if Not VarEquals(DBTreeNode.FParentFieldValue, FDBTreeView.FParentField.Value) then
    DBTreeNode.FParentFieldValue := FDBTreeView.FParentField.Value;

  if (DBTreeNode.TreeNode = Nil) then begin
    if(ParentTreeNode = Nil) then
      DBTreeNode.FTreeNode := FDBTreeView.Items.Add(ParentTreeNode, '')
    else DBTreeNode.FTreeNode := FDBTreeView.Items.AddChild(ParentTreeNode, '');
    DBTreeNode.FTreeNode.Text := FDBTreeView.GetDisplayText;
    if Not VarIsNull(DBTreeNode.FKeyFieldValue) And Assigned(FDBTreeView.FAddNewItem) then
      FDBTreeView.FAddNewItem(Nil, DBTreeNode);
  end else begin
    if(DBTreeNode.TreeNode.Parent <> ParentTreeNode) and
    (DBTreeNode.TreeNode <> ParentTreeNode) and
    (DBTreeNode.TreeNode.Parent <> nil) then begin
      DBTreeNode.TreeNode.MoveTo(ParentTreeNode, naAddChild);
      ParentTreeNode.HasChildren := True;
    end;
    if(DBTreeNode.TreeNode.Text <> FDBTreeView.GetDisplayText) then
      DBTreeNode.TreeNode.Text := FDBTreeView.GetDisplayText;
  end;

  if(trSmartRecordLoad in FDBTreeView.Options)  then begin
    if  (trCheckHasChildren in FDBTreeView.Options) then begin
      FlagDis := FDBTreeView.FDataLink.DataSet.ControlsDisabled;
      if Not FlagDis then
        FDBTreeView.FDataLink.DataSet.DisableControls;
      bm := FDBTreeView.FDataLink.DataSet.GetBookmark;
      DBTreeNode.TreeNode.HasChildren :=
      DBTrDataSetLocate(FDBTreeView.FDataLink.DataSet, FDBTreeView.FParentFieldName, DBTreeNode.FKeyFieldValue, []);
      FDBTreeView.FDataLink.DataSet.GotoBookmark(bm);
      FDBTreeView.FDataLink.DataSet.FreeBookmark(bm);
      if Not flagDis then
        FDBTreeView.FDataLink.DataSet.EnableControls;
    end else DBTreeNode.TreeNode.HasChildren := True;
  end;

  DBTreeNode.FListText := FDBTreeView.FListField.Text;
  if (DBTreeNode.TreeNode <> Nil) then begin
     if(FDBTreeView.FImageIndexField <> Nil) then begin
       if Not VarIsNull(FDBTreeView.FImageIndexField.Value) then
         DBTreeNode.TreeNode.ImageIndex := FDBTreeView.FImageIndexField.AsInteger
       else DBTreeNode.TreeNode.ImageIndex := -1;
     end;
     if(FDBTreeView.FStateIndexField <> Nil) then begin
       if Not VarIsNull(FDBTreeView.FStateIndexField.Value) then
         DBTreeNode.TreeNode.StateIndex := FDBTreeView.FStateIndexField.AsInteger
       else DBTreeNode.TreeNode.ImageIndex := -1;
     end;
  end;
  if(trUseNodeData in FDBTreeView.Options)
  And (DBTreeNode.TreeNode <> Nil) then
    DBTreeNode.TreeNode.Data := DBTreeNode;
  DBTreeNode.Refreshed := True;
  DBTreeNode.Deleted := False;
  FDBTreeView.NonUserInsertFlag := False;
  if(Count < 100) And (Count > FDBTreeView.FDataLink.BufferCount) then
    FDBTreeView.FDataLink.BufferCount := Count
  else FDBTreeView.FDataLink.BufferCount := 100;
end;

procedure TDBTreeNodes.RefreshParents;
Var
  i : Integer;
  ParentTreeNode : TTreeNode;
  MoveFlag : Boolean;
begin
  for i := 0 to Count - 1  do
    if(Items[i].Refreshed) And (Items[i].TreeNode.Parent = Nil) then begin
      ParentTreeNode := GetTreeNode(Items[i].ParentFieldValue);
      MoveFlag := FDBTreeView.MoveTreeNodeStructFlag;
      FDBTreeView.MoveTreeNodeStructFlag := True;
      if(ParentTreeNode <> Nil) And (Items[i].TreeNode <> ParentTreeNode) then begin
        ParentTreeNode.HasChildren := True;
        Items[i].TreeNode.MoveTo(ParentTreeNode, naAddChild);
      end;
      FDBTreeView.MoveTreeNodeStructFlag := MoveFlag;
    end;
 end;

procedure TDBTreeNodes.Clear;
Var
  i : Integer;
begin
  for i := 0 to FList.Count - 1  do
    TDBTreeNode(FList.Items[i]).Free;
  FDBTreeView.Items.Clear;
  FList.Clear;
end;

procedure TDBTreeNodes.Delete(ADBTreeNode : TDBTreeNode);
begin
 if (ADBTreeNode <> Nil) then begin
   if(trSmartRecordLoad in FDBTreeView.FOptions) then
     ADBTreeNode.LoadChildren(True);
   FList.Remove(ADBTreeNode);
   ADBTreeNode.TreeNode.Delete;
   ADBTreeNode.Free;
 end;
end;


function TDBTreeNodes.Count : Integer;
begin
  Result := FList.Count;
end;

function TDBTreeNodes.GetDBNodeFromIndex(Index : Integer) : TDBTreeNode;
begin
  if(Index > - 1) And (Index < Count) then
    result := TDBTreeNode(FList[Index])
  else result := Nil;
end;

function TDBTreeNodes.GetMaxKeyFieldValue : Variant;
begin
  Result := NULL;
  if(FList.Count > 0) then begin
    Result := Items[FList.Count - 1].KeyFieldValue;
  end;
end;

function TDBTreeNodes.GetKeyFieldValue(Value : TTreeNode) : Variant;
Var
  dbtr : TDBTreeNode;
begin
  Result := Null;
  dbtr := GetDBTreeNodeByTreeNode(Value);
  if(dbtr <> Nil) then
    Result := dbtr.KeyFieldvalue;
end;

function TDBTreeNodes.GetParentValue(Value : TTreeNode) : Variant;
Var
  dbtr : TDBTreeNode;
begin
  Result := Null;
  dbtr := GetDBTreeNodeByTreeNode(Value);
  if(dbtr <> Nil) then
    Result := dbtr.ParentFieldValue;
end;

function TDBTreeNodes.GetDBTreeNode(Value : Variant) : TDBTreeNode;
Var
  i : Integer;
begin
  if(FindNearest(Value, i)) then
    Result := Items[i]
  else Result := Nil;
end;

function TDBTreeNodes.GetTreeNode(Value : Variant) : TTreeNode;
Var
  dbtn : TDBTreeNode;
begin
  dbtn := GetDBTreeNode(Value);
  if(dbtn <> nil) then
    Result := dbtn.TreeNode
  else Result := Nil;
end;

function TDBTreeNodes.GetDBTreeNodeByTreeNode(Value : TTreeNode) : TDBTreeNode;
Var
  i : Integer;
begin
  Result := Nil;
  if(trUseNodeData in FDBTreeView.Options) then begin
     if (Value.Data <> Nil) then
        Result := TDBTreeNode(Value.Data);
  end else begin
    i := IndexOf(Value);
    if(i > -1) then
      Result := Items[i];
  end;
end;

function TDBTreeNodes.IndexOf(Value : TTreeNode) : Integer;
Var
  i : Integer;
begin
  Result := -1;
  if (Value <> Nil) then begin
    for i := 0 to Count - 1 do begin
      if (Items[i].TreeNode = Value) then begin
        Result:=i;
        break;
      end;  
    end;    
{    if(i < Count) And (Count > 0) then
      Result := i;}
  end;
end;


procedure TDBTreeNodes.NodeChangeParent(TreeNode : TTreeNode; Value : Variant);
Var
  t : TTreeNode;
  MoveFlag : Boolean;
  dbtr : TDBTreeNode;
begin
  if FlagBuzy then exit;
  dbtr := GetDBTreeNodeByTreeNode(TreeNode);
  if(dbtr = Nil) then  exit;
  if Not VarEquals(dbtr.ParentFieldValue, Value) then
    dbtr.FParentFieldValue := Value;
  t := GetTreeNode(Value);
  if(t = TreeNode.Parent) then  exit;

  FlagBuzy := True;
  MoveFlag := FDBTreeView.MoveTreeNodeStructFlag;
  FDBTreeView.MoveTreeNodeStructFlag := True;
  if(t <> Nil) And (dbtr.TreeNode <> t) then begin
     TreeNode.Focused := False;
     t.HasChildren := True;
     TreeNode.MoveTo(t, naAddChild);
  end else TreeNode.MoveTo(Nil, naAdd);
  FDBTreeView.MoveTreeNodeStructFlag := MoveFlag;
  FDBTreeView.Repaint;
  FlagBuzy := False;
end;

{TDBTreeView}
constructor TDBTreeView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FRootValue := NULL;
  FDataLink := TDataLinkTreeView.Create;
  FDataLink.FDBTreeView := Self;
  FDBTreeNodes := TDBTreeNodes.Create(self);
  FEditInstance := MakeObjectInstance(EditWndProc);

  DataChangedBusy := False;
  DoInsertFlag := False;
  FDisplayFields := TList.Create;
  FSeparatedSt := ' - ';
  Options := [trDBCanDelete, trDBConfirmDelete, trCanDBNavigate,
          trSmartRecordCopy, trCheckHasChildren];
  InsertedTreeNode := Nil;
  NodeHasExpanded := False;
end;

destructor TDBTreeView.Destroy;
begin
  FreeObjectInstance(FEditInstance);
  FDisplayFields.Free;
  FDBTreeNodes.Clear;
  FDataLink.FDBTreeView := nil;
  FDataLink.Free;
  Items.Clear;
  FDBTreeNodes.Free;
  inherited Destroy;
end;

function TDBTreeView.GetImageIndexField : TField;
begin
  Result := FImageIndexField;
end;

function TDBTreeView.GetKeyField : TField;
begin
  Result := FKeyField;
end;

function TDBTreeView.GetListField : TField;
begin
  Result := FListField;
end;

function TDBTreeView.GetParentField : TField;
begin
  Result := FParentField;
end;

function TDBTreeView.GetStateIndexField : TField;
begin
  Result := FStateIndexField;
end;

type
  TPVariant = ^Variant;

procedure TDBTreeView.GotoKeyFieldValue(Value : Variant);
var
  TreeNode : TTreeNode;
  PValue : TPVariant;
  List : TList;
  bm : TBookmark;
  i : Integer;
  Flag, FlagDis : Boolean;
begin
  if VarIsNull(Value) then exit;

{  Items.BeginUpdate;
  try
 } 
  TreeNode := FDBTreeNodes.GetTreeNode(Value);
  if(TreeNode <> Nil) then begin
    TreeNode.Selected:=true;
    TreeNode.MakeVisible;
    Selected := TreeNode;
  end else
    if(trSmartRecordLoad in Options) And Not (DataChangedBusy) then begin
      Flag := DataChangedBusy;
      DataChangedBusy := True;
      List := TList.Create;
      bm := FDataLink.DataSet.GetBookmark;
      FlagDis := FDataLink.DataSet.ControlsDisabled;
      if Not flagDis then
        FDataLink.DataSet.DisableControls;
      while (TreeNode = Nil) do
        if DBTrDataSetLocate(FDBTreeNodes.FDBTreeView.FDataLink.DataSet,
          FKeyFieldName, FParentField.Value, [])
        And Not (VarEquals(FKeyField.Value, FParentField.Value)) then begin
          New(PValue);
          PValue^ := FKeyField.Value;
          List.Add(PValue);
          TreeNode := FDBTreeNodes.GetTreeNode(PValue^);
        end else break;
      if(TreeNode = Nil) then begin
        DBTreeNodes.RefreshRecord;
        TreeNode := DBSelected.TreeNode;
        DBSelected.ChildLoaded := True;
      end;
      if (TreeNode <> Nil) then
        for i := List.Count - 1 downto 0 do begin
          PValue := List[i];
          DBTrDataSetLocate(FDataLink.DataSet, FKeyFieldName, PValue^, []);
          DBSelected.ChildLoaded := True;
        end;

      GotoKeyFieldValue(Value);
      if Not flagDis then
        FDataLink.DataSet.EnableControls;
      FDataLink.DataSet.GotoBookmark(bm);
      FDataLink.DataSet.FreeBookmark(bm);
      DataChangedBusy := Flag;
      for i := 0 to List.Count - 1 do
        Dispose(TPVariant(List[i]));
      List.Free;
    end;
{  finally
   Items.EndUpdate;
  end;}  
end;

procedure TDBTreeView.CreateHandle;
Var
  Flag : Boolean;
begin
  Flag := DataChangedBusy;
  DataChangedBusy := True;
  inherited CreateHandle;
  DataChangedBusy := Flag;
end;

procedure TDBTreeView.Change(Node: TTreeNode);
Var
  V : Variant;
  tr, tr1 : TTreenode;
  Flag : Boolean;
begin
  inherited;                  
  if(DataChangedBusy) then exit;
  DataChangedBusy := True;
  if(FKeyField <> Nil) then begin
    V := FDBTreeNodes.GetKeyFieldValue(Node);
    if Not VarIsNull(V) And (VarType(V) <> varEmpty)
    And Not VarEquals(FKeyField.Value, V) And
    (dsInsert <> FKeyField.DataSet.State) And
    Not ((FdataLink.DataSet.EOF) And (FdataLink.DataSet.BOF)) then begin
      Flag := FDataLink.DataSet.State = dsEdit;
      tr1 := Nil;
      if Flag then begin
        tr := DBTreeNodes.GetTreeNode(FKeyField.Value);
        if(tr <> Selected) then begin
          SendMessage(Handle, WM_SETREDRAW, Integer(False), 0);
          tr1 := Selected;
          Selected := tr;
        end else Flag := False;
      end;
      try
        DBTrDataSetLocate(FdataLink.DataSet, FKeyFieldName, V, []);
      except
      end;
      if Flag then begin
        Selected := tr1;
        SendMessage(Handle, WM_SETREDRAW, Integer(True), 0);
      end;
    end;
  end;
  DataChangedBusy := False;
end;


procedure TDBTreeView.Edit(const Item: TTVItem);
Var
  Flag : Boolean;
begin
  inherited;
  if (FListField <> Nil) then begin
    Flag := DataChangedBusy;
    DataChangedBusy := True;
    if(Not ReadOnly) And (FListField.DataSet <> Nil) And (Selected <> Nil)
    And ((FListField.DataSet.State = dsEdit) Or (FListField.DataSet.State = dsInsert)) And
     (FListField.Text <> Selected.Text) then
       FListField.Text := Selected.Text
     else Selected.Text := FListField.Text;
    if(Selected <> Nil) then
      Selected.Text := GetDisplayText;
    DataChangedBusy := Flag;
  end;  
end;

procedure TDBTreeView.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) And (FDataLink <> nil) and (AComponent = DataSource)
     then DataSource := nil;
end;

procedure TDBTreeView.RefreshItems;
Var
  bm : TBookMark;
  i : Integer;
  FlagDis : Boolean;
  OldSortType : TSortType;
begin
{ Items.BeginUpdate;
 try}
  DataChangedBusy := True;
  if(FKeyField <> Nil) And (FListField <> Nil) And (FParentField <> Nil) then begin
    OldSortType := SortType;
    SortType := stNone;
    FDBTreeNodes.BeginRefreshRecord;
    FlagDis := FDataLink.DataSet.ControlsDisabled;
    if Not flagDis then
      FDataLink.DataSet.DisableControls;
    bm := FDataLink.DataSet.GetBookmark;
    if Not (trSmartRecordLoad in Options) then begin
      i := mrNo;
      if(csDesigning in ComponentState) And (FDataLink.DataSet.RecordCount > 999) then
        i :=  MessageDlg(LoadStr(ADBTreeViewSmartLoadS), mtConfirmation, [mbYes, mbNo], 0);
      if(i = mrNo) then begin
        FDataLink.DataSet.First;
        while Not FDataLink.DataSet.EOF do begin
          FDBTreeNodes.RefreshRecord;
          FDataLink.DataSet.Next;
        end;
      end;  
    end else begin
      if(FDBTreeNodes.Count > 0) then begin
        for i := 0 to FDBTreeNodes.Count - 1 do begin
          if Not (VarEquals(FKeyField.Value, FDBTreeNodes[i].FKeyFieldValue)) then
            DBTrDataSetLocate(FDataLink.DataSet, FKeyFieldName, FDBTreeNodes[i].FKeyFieldValue, []);
          FDBTreeNodes.RefreshRecord;
        FDataLink.DataSet.Next;
        end;
      end else
        FDataLink.DataSet.First;
        if DBTrDataSetLocate(FDataLink.DataSet, FParentFieldName, FRootValue, []) then
          while (Not FDataLink.DataSet.EOF) And VarEquals(FParentField.Value, FRootValue) do begin
            FDBTreeNodes.RefreshRecord;
            FDataLink.DataSet.Next;
         end;
    end;
    FDataLink.DataSet.GotoBookmark(bm);
    FDataLink.DataSet.FreeBookmark(bm);
    if Not flagDis then
      FDataLink.DataSet.EnableControls;
    FDBTreeNodes.RefreshParents;
    FDBTreeNodes.EndRefreshRecord;
    SortType := OldSortType;
  end;

  Scroll;  
  DataChangedBusy := False;
{ finally
  Items.EndUpdate;
 end;}
end;

procedure TDBTreeView.AssignFields;

  function IsIntegerField(AField : TField) : Boolean;
  begin
    Result := AField.DataType in [ftSmallint, ftInteger, ftWord, ftAutoInc];
  end;  

begin
  FDisplayFields.Clear;
  if FDataLink.Active then  begin
    if(FKeyFieldName <> '') then
      FKeyField := FDataLink.DataSet.FieldByName(FKeyFieldName);
    if(FListFieldName <> '') then
      FListField := FDataLink.DataSet.FieldByName(FListFieldName);
    if(FParentFieldName <> '') then
      FParentField := FDataLink.DataSet.FieldByName(FParentFieldName);
    if(FImageIndexFieldName <> '') then begin
      FImageIndexField := FDataLink.DataSet.FieldByName(FImageIndexFieldName);
      if (FImageIndexField <> Nil) And Not IsIntegerField(FImageIndexField) then
        FImageIndexField := Nil;
    end;
    if(FStateIndexFieldName <> '') then begin
      FStateIndexField := FDataLink.DataSet.FieldByName(FStateIndexFieldName);
      if(FStateIndexField <> NIl) And Not IsIntegerField(FStateIndexField) then
        FStateIndexField := Nil;
    end;

    FDataLink.DataSet.GetFieldList(FDisplayFields, FDisplayFieldName);
  end;
end;


procedure TDBTreeView.DataLinkActiveChanged;
begin
  FKeyField := Nil;
  FListField := Nil;
  FParentField := Nil;
  FImageIndexField := Nil;
  FStateIndexField := Nil;

  FDisplayFields.Clear;
  AssignFields;
  if(FKeyField <> NIl) And Not VarIsNull(FRootValue) then
    case FKeyField.DataType of
      ftSmallint: VarCast(FRootValue, FRootValue,  varSmallint);
      ftInteger, ftWord, ftAutoInc: VarCast(FRootValue, FRootValue,  varInteger);
      ftFloat, ftCurrency: VarCast(FRootValue, FRootValue,  varDouble);
    else VarCast(FRootValue, FRootValue,  varString);
  end;

  FDBTreeNodes.Clear;
  Items.Clear;
  RefreshItems;
end;

procedure TDBTreeView.DataLinkRecordChanged(Field: TField);
begin
  if(Field <> Nil) And (Field.DataSet <> Nil) then begin
    case Field.DataSet.State of
      dsEdit : RecordEdit(Field);
      dsInsert: RecordInsert(Field);
    end;
  end;
end;

function TDBTreeView.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

function TDBTreeView.GetRootValue: String;
begin
  if VarIsNull(FRootValue) then
    Result := ''
  else Result := String(FRootValue);
end;

function TDBTreeView.GetSeletectedDBTreeNode : TDBTreeNode;
begin
  Result := Nil;
  if(FKeyField <> Nil) And (FKeyField.Value <> NULL) then
    Result := FDBTreeNodes.GetDBTreeNode(FKeyField.Value);
end;


procedure TDBTreeView.Scroll;
begin
  if Not (trCanDBNavigate in Options) then exit;
  if(FKeyField <> Nil) then
    GotoKeyFieldValue(FKeyField.Value);
end;

procedure TDBTreeView.SetDataSource(Value: TDataSource);
begin
  FDataLink.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

procedure TDBTreeView.SetDisplayFieldName(const Value: string);
begin
  if FDisplayFieldName <> Value then
  begin
    FDisplayFieldName := Value;
    DataLinkActiveChanged;
  end;
end;

procedure TDBTreeView.SetImageIndexFieldName(const Value: string);
begin
  if FImageIndexFieldName <> Value then
  begin
    FImageIndexFieldName := Value;
    DataLinkActiveChanged;
  end;
end;

procedure TDBTreeView.SetKeyFieldName(const Value: string);
begin
  if FKeyFieldName <> Value then
  begin
    FKeyFieldName := Value;
    DataLinkActiveChanged;
  end;
end;

procedure TDBTreeView.SetListFieldName(const Value: string);
begin
  if FListFieldName <> Value then
  begin
    FListFieldName := Value;
    DataLinkActiveChanged;
  end;
end;

procedure TDBTreeView.SetStateIndexFieldName(const Value: string);
begin
  if FStateIndexFieldName <> Value then
  begin
    FStateIndexFieldName := Value;
    DataLinkActiveChanged;
  end;
end;

procedure TDBTreeView.SetOptions(const Value: TDBTreeViewOptions);
begin
  if(Value <> FOptions) then begin
    FOptions := Value;
    inherited Options := [];
    if(trDBCanDelete in FOptions) then
      inherited Options := inherited Options + [trCanDelete];
    if(trDBConfirmDelete in FOptions) then
      inherited Options := inherited Options + [trConfirmDelete];
    RefreshItems;
  end;
end;

procedure TDBTreeView.SetParentFieldName(const Value: string);
begin
  if FParentFieldName <> Value then
  begin
    FParentFieldName := Value;
    DataLinkActiveChanged;
  end;
end;

procedure TDBTreeView.SetRootValue(const Value : String);
Var
  V : Variant;
begin
  V := Value;
  if Not VarIsNull(FRootValue) then
    FRootValue := VarAsType(V,  VarType(FRootValue))
  else FRootValue := V;
  if(trSmartRecordLoad in FOptions) then
    DataLinkActiveChanged;
end;

procedure TDBTreeView.SetSeparatedSt(const Value: string);
begin
  if FSeparatedSt <> Value then
  begin
    FSeparatedSt := Value;
    if(FDisplayFields.Count > 0) then
      DataLinkActiveChanged;
  end;
end;

procedure TDBTreeView.DataChanged;
begin
  if DataChangedBusy or not HandleAllocated
  Or (FDataLink.DataSet.State = dsInsert) Or (FDataLink.DataSet.State = dsEdit) then exit;
  if IsEditing And (Selected <> Nil) then
    Selected.EndEdit(True);
  AssignFields;
  RefreshItems;
  Scroll;
end;

function TDBTreeView.GetDisplayText : String;
Var
  i : Integer;
  St : String;
begin
  St := '';
  if(FDisplayFields.Count > 0) then begin
    for i := 0 to FDisplayFields.Count - 1 do begin
      if(i > 0) then
        St := St + FSeparatedSt;
      St := St + TField(FDisplayFields[i]).Text;
    end;
  end else
    if(FListField <> Nil) then
      St := FListField.Text;
  if Assigned(FOnSetDisplayItemText) then
    FOnSetDisplayItemText(self, St);
  Result := St;
end;

procedure TDBTreeView.RecordEdit(Field : TField);
Var
  TreeNode : TTreeNode;
  V : Variant;
begin
  if(FKeyField <> Nil) then begin
    TreeNode := Selected;
    if(TreeNode = Nil) then exit;

    if(Field = FListField) And (TreeNode.Text <> Field.Text ) then
        TreeNode.Text := Field.Text;

    if(FImageIndexField = Field) then begin
      if Not VarIsNull(FImageIndexField.Value) then
        TreeNode.ImageIndex := FImageIndexField.AsInteger
      else TreeNode.ImageIndex := -1;
    end;

    if(FStateIndexField = Field) then begin
      if Not VarIsNull(FStateIndexField.Value) then
        TreeNode.StateIndex := FStateIndexField.AsInteger
      else TreeNode.StateIndex := -1;
    end;

    if(Field = FParentField) then begin
      V := FDBTreeNodes.GetParentValue(TreeNode);
      if Not VarIsNull(Field.Value) And Not VarIsNull(V) And
      Not VarEquals(Field.Value, V)then
        FDBTreeNodes.NodeChangeParent(TreeNode, Field.Value);
    end;
  end;
end;

procedure TDBTreeView.RecordInsert(Field : TField);
Var
  DBTreeNode : TDBTreeNode;
begin
{ Items.BeginUpdate;
 try}
  if(FKeyField <> Nil) And (FKeyField.Value <> NULL) then begin
    if  Not DataChangedBusy then
      FDBTreeNodes.RefreshRecord;
    DBTreeNode := DBSelected;
    if(DBTreeNode <> Nil) And (DBTreeNode.TreeNode <> Nil) then  begin
      Selected := DBTreeNode.TreeNode;
      if(Selected <> Nil) then
        Selected.MakeVisible;
   end;
   if (DBTreeNode <> Nil) And (DBTreeNode.ParentFieldValue <> NULL)  And
   Assigned(FAddNewItem) then
     FAddNewItem(Nil, DBTreeNode);
  end;
{ finally
  Items.EndUpdate;
 end;}
end;

(*procedure TDBTreeView.FrameSelectedItem;
Var
  Rect: TRect;
  DC : HDC;
  wnd : HWND;
  OldColor : TColor;
//  FontColor: TColor;
begin
  if Not Focused And Not DataChangedBusy And (Selected <> Nil) then begin
    TreeView_GetItemRect(Selected.Handle, Selected.ItemId, Rect, True);
    Wnd := handle;
    DC := GetDeviceContext(Wnd);
    OldColor := Brush.Color;
    Brush.Color := Font.Color;
//    FrameRect(DC, Rect, Brush.Handle);
{    Brush.Color := clBtnFace;
    FillRect(dc,rect,Brush.Handle);
    DrawText(dc,Pchar(Selected.Text),Length(Selected.Text),Rect,DT_LEFT and DT_CENTER);}
    Brush.Color := OldColor;
    ReleaseDC(Wnd, DC);
   end;
end;*)

procedure TDBTreeView.DeleteNodeStructure(List : TList);
Var
  i : Integer;
  dbtr : TDBTreeNode;
  flag, FlagDis : Boolean;
begin
  if Not FDataLink.Active  then exit;
  FlagDis := FDataLink.DataSet.ControlsDisabled;
  if Not flagDis then
    FDataLink.DataSet.DisableControls;
  for i := List.Count - 1 downto 0 do begin
    dbtr := DBTreeNodes.GetDBTreeNodeByTreeNode(TTreeNode(List.List^[i]));
    if (dbtr <> Nil) then begin
      flag := False;
      if Not DataChangedBusy And Not ((FdataLink.DataSet.EOF) And (FdataLink.DataSet.BOF)) then
        try
          flag := DBTrDataSetLocate(FdataLink.DataSet, FKeyFieldName,
            dbtr.KeyFieldValue, []);
        except
        end;
      if flag And VarEquals(dbtr.KeyFieldValue, FKeyField.Value) then
        FDataLink.DataSet.Delete;
      if(dbtr <> Nil) then
        dbtr.Deleted := True;
    end;
  end;
  flag := DataChangedBusy;
  DataChangedBusy := True;
  if Not flagDis then
    FDataLink.DataSet.EnableControls;
  DataChangedBusy := flag;
end;

procedure TDBTreeView.DoCustomDraw(TreeNode : TTreeNode; AFont : TFont;
               Var AColor, ABkColor : TColor);
{Var
  dbtr : TDBTreeNode;}
begin
{  if (Assigned(OnCustomDraw)) then
     inherited DoCustomDraw(TreeNode, AFont, AColor, ABkColor)
  else begin
    dbtr := DBTreeNodes.GetDBTreeNodeByTreeNode(TreeNode);
    if(dbtr <> Nil) And (dbtr.IsCustomDraw) then
      with dbtr do begin
        AFont.Style := FontStyle;
        AFont.Name := FontName;
        AColor := Color;
        ABkColor := BkColor;
      end;
  end;}
{    inherited DoCustomDraw(TreeNode, AFont, AColor, ABkColor);
    dbtr := DBTreeNodes.GetDBTreeNodeByTreeNode(TreeNode);
    if(dbtr <> Nil)then
      with dbtr do begin
        AFont.Style := FontStyle;
        AFont.Name := FontName;
        AColor := Color;
        ABkColor := BkColor;
      end;
 }
end;

procedure TDBTreeView.GetNodeStructure(TreeNode : TTreeNode; List : TList);
Var
  dbtr : TDBTreeNode;
begin
  if(trSmartRecordLoad in FOptions)
  And   Not DeleteNodeStructFlag And CopyTreeNodeStructFlag then begin
    dbtr := DBTreeNodes.GetDBTreeNodeByTreeNode(TreeNode);
    if(dbtr <> Nil) then
      dbtr.LoadChildren(True);
  end;
  inherited GetNodeStructure(TreeNode, List);
end;

type
TInsertFieldStruct = class
private
  Buffer : Pointer;
  {$IFNDEF DELPHI3_0}
  Stream : TBlobStream;
  {$ELSE}
  Stream : TStream;
  {$ENDIF}
  FieldName : String;
public
  constructor Create(Size : Integer);
  destructor Destroy; override;
end;

constructor TInsertFieldStruct.Create(Size : Integer);
begin
  inherited Create;
  GetMem(Buffer, Size);
end;

destructor TInsertFieldStruct.Destroy;
begin
  FreeMem(Buffer);
  if(Stream <> Nil) then
    Stream.Free;
  inherited Destroy;
end;

procedure TDBTreeView.InsertTreeNodeStructure(ListS, ListD : TList; Flag : Boolean);
Var
  i, index : Integer;
  MaxKeyFieldValue : Variant;
  tr, tr1 : TTreeNode;
  dbtr, dbtr1 : TDBTreeNode;
  ifs : TInsertFieldStruct;
  List : TList;
  FlagBuzy, FlagDis : Boolean;
  sDBTreeView : TDBTreeView;
  sDBTreeKeyValue : Variant;
  FCopiedFields : TList;
  {$IFDEF DELPHI3_0}
  AStream : TStream;
  {$ENDIF}

  function IsBlobField(AField : TField) : Boolean;
  begin
    Result := AField is TBlobField;
  end;

begin
  FlagBuzy := DataChangedBusy;
  DataChangedBusy := True;
  FlagDis := FDataLink.DataSet.ControlsDisabled;
  if Not flagDis then
    FdataLink.DataSet.DisableControls;
  if(ListD.Count > 0) And (trSmartRecordLoad in FOptions) then begin
    tr := TTreeNode(ListD[0]);
    if(tr <> Nil) And (tr.Parent <> Nil) then begin
      dbtr1 := DBTreeNodes.GetDBTreeNodeByTreeNode(tr.Parent);
      if(dbtr1 <> Nil) then begin
        dbtr1.ChildLoaded := True;
        dbtr1.TreeNode.HasChildren := True;
      end;
    end;
  end;
  if (ListS.Count > 0) then
    sDBTreeView := TDBTreeView(TTreeNode(ListS[0]).TreeView)
  else  sDBTreeView := Nil;
  sDBTreeKeyValue := varNull;
  FCopiedFields := TList.Create;
  if Flag And (trSmartRecordCopy in FOptions) And (ListS.Count > 0) And
  (TTreeNode(ListS[0]).TreeView is TDBTreeView) then begin
    sDBTreeKeyValue := sDBTreeView.FKeyField.Value;
    for index := 0 to sDBTreeView.FDataLink.DataSet.FieldCount - 1 do
      if(CompareText(sDBTreeView.FDataLink.DataSet.Fields[index].FieldName, FKeyFieldName) <> 0)
      And (CompareText(sDBTreeView.FDataLink.DataSet.Fields[index].FieldName, FParentFieldName) <> 0)
      And (FDataLink.DataSet.FindField(sDBTreeView.FDataLink.DataSet.Fields[index].FieldName) <> Nil) then
        FCopiedFields.Add(sDBTreeView.FDataLink.DataSet.Fields[index]);
  end;

  MaxKeyFieldValue := DBTreeNodes.MaxKeyFieldValue;
  for i := 0 to ListD.Count - 1 do begin
    tr := TTreeNode(ListD[i]);
    if Assigned(FCreateNewKeyValue) then
     FCreateNewKeyValue(Nil, MaxKeyFieldValue)
    else begin
      try if Not VarIsNULL (DBTreeNodes.MaxKeyFieldValue) then
        Inc(MaxKeyFieldValue)
      else MaxKeyFieldValue := 0;
      except
      end;
    end;
    dbtr := TDBTreeNode.Create(DBTreeNodes, MaxKeyFieldValue);
    if(tr.Parent <> Nil) then
      dbtr.FParentFieldValue := DBTreeNodes.GetKeyFieldValue(tr.Parent)
    else begin
      if Not VarIsNull(FRootValue) Or (trSmartRecordLoad in FOptions) then
        dbtr.FParentFieldValue := FRootValue
      else dbtr.FParentFieldValue := dbtr.FKeyFieldValue;
    end;
    dbtr.TreeNode := tr;
    if(trUseNodeData in Options) then
      tr.Data := dbtr;
    if(FDisplayFields.Count > 0)
    And (sDBTreeView = self) then begin
      tr1 := TTreeNode(ListS[i]);
      if(tr1 <> Nil) then begin
        dbtr1 := DBTreeNodes.GetDBTreeNodeByTreeNode(tr1);
        if(dbtr1 <> Nil) then begin
          DBTrDataSetLocate(FDataLink.DataSet, FKeyFieldName, dbtr1.FKeyFieldValue, []);
          tr.Text := FListField.Text;
        end;
      end;
    end;
    FDataLink.DataSet.Append;
    FParentField.Value :=  dbtr.FParentFieldValue;
    if(FListField <> FKeyField) And (FListField <> FParentField) then
      FListField.Value :=  tr.Text;
    FKeyField.Value :=  dbtr.FKeyFieldValue;
    FDataLink.DataSet.Post;

    if (FCopiedFields.Count > 0) then begin
      tr1 := TTreeNode(ListS[i]);
      List := TList.Create;
      if(tr1 <> Nil) then begin
        dbtr1 := sDBTreeView.DBTreeNodes.GetDBTreeNodeByTreeNode(tr1);
        if(dbtr1 <> Nil) then begin
          if(sDBTreeView <> self) then
            sDBTreeView.DataChangedBusy := True;
          DBTrDataSetLocate(sDBTreeView.FDataLink.DataSet, sDBTreeView.FKeyFieldName,
            dbtr1.FKeyFieldValue, []);
          if(sDBTreeView <> self) then
            sDBTreeView.DataChangedBusy := False;
          for index := 0 to FCopiedFields.Count - 1 do begin
            ifs := TInsertFieldStruct.Create(TField(FCopiedFields[Index]).DataSize + 1);
            try
              ifs.Stream := Nil;
              if(IsBlobField(TField(FCopiedFields[Index]))) then begin
                {$IFNDEF DELPHI3_0}
                ifs.Stream := TBlobStream.Create(TBlobField(FCopiedFields[Index]), bmRead);
                {$ELSE}
                AStream :=  sDBTreeView.FDataLink.DataSet.CreateBlobStream(TField(FCopiedFields[Index]), bmRead);
                ifs.Stream := TMemoryStream.Create;
                ifs.Stream.CopyFrom(AStream, AStream.Size);
                AStream.Free;
                {$ENDIF}
                ifs.FieldName := TField(FCopiedFields[Index]).FieldName;
                List.Add(ifs);
              end else
                if TField(FCopiedFields[Index]).GetData(ifs.Buffer) then begin
                  ifs.FieldName := TField(FCopiedFields[Index]).FieldName;
                  List.Add(ifs)
                end else ifs.Free;
            except
              ifs.Free;
            end;
          end;
        end;
      end;

      if(List.Count > 0) then
        try
          DBTrDataSetLocate(FDataLink.DataSet, FKeyFieldName, dbtr.FKeyFieldValue, []);
          FDataLink.DataSet.Edit;
          for index := 0 to List.Count - 1 do begin
            ifs := TInsertFieldStruct(List[index]);
            try
              if(ifs.Stream <> Nil)then
                {$IFNDEF DELPHI3_0}
                TBlobField(FDataLink.DataSet.FindField(ifs.FieldName)).LoadFromStream(ifs.Stream)
                {$ELSE}
                begin
                  AStream := FDataLink.DataSet.CreateBlobStream(FDataLink.DataSet.FindField(ifs.FieldName), bmWrite);
                  ifs.Stream.Position := 0;
                  AStream.CopyFrom(ifs.Stream, ifs.Stream.Size);
                  AStream.Free;
                end
              {$ENDIF}
              else FDataLink.DataSet.FindField(ifs.FieldName).SetData(ifs.Buffer);
            except; end;
          end;
          FDataLink.DataSet.Post;
        except
        end;
      while List.Count > 0 do begin
        ifs := TInsertFieldStruct(List[0]);
        List.Remove(ifs);
        ifs.Free;
      end;
      List.Free;
    end;

    tr.Text := GetDisplayText;
    if Assigned(FAddNewItem) then
      FAddNewItem(Nil, dbtr);
  end;
  tr := TTreeNode(ListD[0]);
  if(tr <> Nil) then begin
    dbtr1 := DBTreeNodes.GetDBTreeNodeByTreeNode(tr.Parent);
    if(dbtr1 <> Nil) then
      DBTrDataSetLocate(FDataLink.DataSet, FKeyFieldName,
        dbtr1.FKeyFieldValue, []);
  end;

  if(sDBTreeView <> Nil) And (sDBTreeView <> self) then begin
    sDBTreeView.DataChangedBusy := True;
    DBTrDataSetLocate(sDBTreeView.FDataLink.DataSet, sDBTreeView.FKeyFieldName,
      sDBTreeKeyValue, []);
    sDBTreeView.DataChangedBusy := False;
  end;
  
  FCopiedFields.Free;

  if Not flagDis then
    FdataLink.DataSet.EnableControls;
  DataChangedBusy := FlagBuzy;
end;

function TDBTreeView.IsCustomDraw : Boolean;
begin
  Result := (inherited IsCustomDraw) Or (DBTreeNodes.FCustomDrawCount > 0);
end;

function TDBTreeView.GetListItemText(TreeNode : TTreeNode) : String;
var
  dbtr : TDBTreeNode;
begin
  if(FDisplayFields.Count > 0) then begin
    dbtr := FDBTreeNodes.GetDBTreeNodeByTreeNode(TreeNode);
    if(dbtr <> Nil) then
      Result := dbtr.FListText;
  end else Result := inherited GetListItemText(TreeNode);
end;

procedure TDBTreeView.VM_DELETEITEM(var Message: TMessage);
Var
  TreeNode : TTreeNode;
  dbtr : TDBTreeNode;
begin
 dbtr := Nil;
 if(TVI_ROOT <> HTreeItem(Message.lparam)) And Not MoveTreeNodeStructFlag
 And FDataLink.Active And Not (csDestroying in ComponentState) then begin
   TreeNode := Items.GetNode(HTreeItem(Message.lparam));
   if(TreeNode <> Nil)then
     dbtr := DBTreeNodes.GetDBTreeNodeByTreeNode(TreeNode);
 end;
 inherited;

 if (dbtr <> Nil) And dbtr.Deleted then
   DBTreeNodes.Delete(dbtr);
end;

procedure TDBTreeView.VM_INSERTITEM(var Message: TMessage);
Var
  tn, oldtnp, newtnp : TTreeNode;
  dbtn : TDBTreeNode;
  str : TTVInsertStruct;
  Flag : Boolean;
begin
  inherited;
  if Not NonUserInsertFlag  And Not DataChangedBusy
  And Not MoveTreeNodeStructFlag And Not CopyTreeNodeStructFlag then begin
    tn := Items.GetNode(HTreeItem(Message.Result));
    if(tn <> Nil) then begin
      dbtn := DBTreeNodes.GetDBTreeNodeByTreeNode(tn);
      if(dbtn = Nil) then
        InsertedTreeNode := tn
      else begin
        oldtnp := DBTreeNodes.GetTreeNode(dbtn.FParentFieldValue);
        str := PTVInsertStruct(Message.lParam)^;
        newtnp := Items.GetNode(str.hparent);
        if(newtnp <> oldtnp) then begin
          Flag := DataChangedBusy;
          DataChangedBusy := True;
          ParentChangedTreeNode := tn;
          NewParentTreeNode := newtnp;
          DataChangedBusy := Flag;
        end;
      end;
      DoInsertFlag := True;
    end;
  end;
end;


procedure TDBTreeView.VM_SELECTITEM(var Message: TMessage);
begin
  inherited;
//  FrameSelectedItem;
end;

function TDBTreeView.CanExpand(Node: TTreeNode): Boolean;
begin
  Result := True;
  if Not NodeHasExpanded and Assigned(OnExpanding) then
    OnExpanding(Self, Node, Result);
end;

function TDBTreeView.CanCollapse(Node: TTreeNode): Boolean;
begin
  Result := True;
  if Not NodeHasExpanded and Assigned(OnCollapsing) then
    OnCollapsing(Self, Node, Result);
end;

procedure TDBTreeView.CNNotify(var Message: TWMNotify);
Var
  TreeNode : TTreeNode;
  dbtr : TDBTreeNode;
 begin
  if(trSmartRecordLoad in FOptions) then
    with Message.NMHdr^, PNMTreeView(Pointer(Message.NMHdr))^ do begin
      if (code = TVN_ITEMEXPANDING) and (Action = TVE_EXPAND) then begin
        NodeHasExpanded := True;
        dbtr := DBTreeNodes.GetDBTreeNodeByTreeNode(GetNodeFromItem(ItemNew));
        if(dbtr <> Nil) and (CanExpand(dbtr.TreeNode))then
           dbtr.ChildLoaded := True;
       end;
      if (code = TVN_ITEMEXPANDED) And (action = TVE_COLLAPSE)then begin
        NodeHasExpanded := True;
        dbtr := DBTreeNodes.GetDBTreeNodeByTreeNode(GetNodeFromItem(ItemNew));
        if(dbtr <> Nil) and CanCollapse(dbtr.TreeNode) then
           dbtr.ChildLoaded := False;
      end;
    end;

  inherited;

  NodeHasExpanded := False;

  with Message.NMHdr^ do
    if (code = TVN_BEGINLABELEDIT) And (FListField <> Nil) then begin
      with PTVDispInfo(Pointer(Message.NMHdr))^ do
        TreeNode := GetNodeFromItem(item);
      TreeNode.Text := FListField.Text;
      SendMessage(TreeView_GetEditControl(handle), WM_SETTEXT, 0, Integer(PChar(TreeNode.Text)));
      if FDataLink.DataSet.CanModify then
        FDataLink.Edit;
        FEditHandle := TreeView_GetEditControl(Handle);
        SendMessage(FEditHandle, EM_SETLIMITTEXT, FListField.DisplayWidth, 0);
        FDefEditProc := Pointer(GetWindowLong(FEditHandle, GWL_WNDPROC));
        SetWindowLong(FEditHandle, GWL_WNDPROC, LongInt(FEditInstance));
    end;
end;

procedure TDBTreeView.EditWndProc(var Message: TMessage);
begin
  with Message do begin
    case Msg of
      WM_CHAR:
        if Not (FDataLink.DataSet.CanModify) Or FListField.ReadOnly  then
          exit
        else begin
          if Not (FListField.IsValidChar(Char(wParam))) then begin
            MessageBeep(0);
            exit;
          end;
        end;
    end;
    Result := CallWindowProc(FDefEditProc, FEditHandle, Msg, WParam, LParam);
  end;
end;

procedure TDBTreeView.WMPaint(var Message: TMessage);
begin
  inherited;
{  if Not (Focused) And (Selected <> Nil) And (Selected.IsVisible)
  And Not IsEditing then
    FrameSelectedItem;}
end;

procedure TDBTreeView.WndProc(var Message: TMessage);
var
  MaxKeyFieldValue, KeyValue : Variant;
  dbtr, dbtr1 : TDBTreeNode;
  tr : TTreeNode;
  Flag, FlagDis : Boolean;
begin
  if DoInsertFlag And (InsertedTreeNode <> Nil) And Not CopyTreeNodeStructFlag
  And Not DataChangedBusy  And FDataLink.Active then begin
    DoInsertFlag := False;
    Flag := DataChangedBusy;
    DataChangedBusy := True;
    FlagDis := FDataLink.DataSet.ControlsDisabled;
    if Not flagDis then
      FdataLink.DataSet.DisableControls;
    MaxKeyFieldValue := DBTreeNodes.MaxKeyFieldValue;
    if Assigned(FCreateNewKeyValue) then
       FCreateNewKeyValue(Nil, MaxKeyFieldValue)
    else begin
       try
         if Not VarIsNULL (DBTreeNodes.MaxKeyFieldValue) then
           Inc(MaxKeyFieldValue)
         else MaxKeyFieldValue := 0;
       except
       end;
    end;
    dbtr := TDBTreeNode.Create(DBTreeNodes, MaxKeyFieldValue);
    if(InsertedTreeNode.Parent <> Nil) then begin
      if(trSmartRecordLoad in FOptions) then begin
        dbtr1 := DBTreeNodes.GetDBTreeNodeByTreeNode(InsertedTreeNode.Parent);
        if(dbtr1 <> Nil) then
          dbtr1.ChildLoaded := True;
      end;
     dbtr.FParentFieldValue := DBTreeNodes.GetKeyFieldValue(InsertedTreeNode.Parent);
    end else begin
      if Not VarIsNull(FRootValue) then
        dbtr.FParentFieldValue := FRootValue
      else dbtr.FParentFieldValue := dbtr.FKeyFieldValue;
    end;
    dbtr.TreeNode := InsertedTreeNode;
    if(trUseNodeData in FOptions) then
      InsertedTreeNode.Data := dbtr;

    FdataLink.DataSet.Append;
    FParentField.Value :=  dbtr.FParentFieldValue;
    if(FListField <> FKeyField) And (FListField <> FParentField) then
      FListField.Value :=  InsertedTreeNode.Text;
    if VarIsNull(FKeyField.Value) then
      FKeyField.Value :=  dbtr.FKeyFieldValue
    else dbtr.SetKeyFieldValue(FKeyField.Value); 
    FdataLink.DataSet.Post;
    InsertedTreeNode.Text := GetDisplayText;

    if Assigned(FAddNewItem) then
      FAddNewItem(Nil, dbtr);
    if Not flagDis then
      FDataLink.DataSet.EnableControls;
    DataChangedBusy := Flag;
    Selected := InsertedTreeNode;
    InsertedTreeNode := Nil;
  end;

  if (ParentChangedTreeNode <> Nil) And Not DataChangedBusy then begin
    Flag := DataChangedBusy;
    DataChangedBusy := True;
    FlagDis := FDataLink.DataSet.ControlsDisabled;
    if Not flagDis then
      FdataLink.DataSet.DisableControls;
    dbtr := DBTreeNodes.GetDBTreeNodeByTreeNode(ParentChangedTreeNode);
    if(dbtr <> Nil) then begin
      if(NewParentTreeNode <> Nil) then begin
        dbtr1 := DBTreeNodes.GetDBTreeNodeByTreeNode(NewParentTreeNode);
        if(dbtr1 <> Nil) then
          dbtr.FParentFieldValue := dbtr1.FKeyFieldValue
        else   begin
          if(trSmartRecordLoad in FOptions) And Not (VarIsNull(FRootValue)) then
            dbtr.FParentFieldValue := FRootValue
          else dbtr.FParentFieldValue := dbtr.FKeyFieldValue;
        end;
      end
      else  begin
        if(trSmartRecordLoad in FOptions) And Not (VarIsNull(FRootValue)) then
          dbtr.FParentFieldValue := FRootValue
        else dbtr.FParentFieldValue := dbtr.FKeyFieldValue;
      end;
      if Not VarEquals(FKeyField.Value, dbtr.FKeyFieldValue) then begin
        KeyValue := FKeyField.Value;
        DBTrDataSetLocate(FDataLink.DataSet, FKeyFieldName, dbtr.FKeyFieldValue, []);
      end else KeyValue := NULL;
      FDataLink.DataSet.Edit;
      FParentField.Value := dbtr.FParentFieldValue;
      FdataLink.DataSet.Post;
      if Not VarIsNULL(KeyValue) then
        DBTrDataSetLocate(FDataLink.DataSet, FKeyFieldName, KeyValue, []);
    end;
    if Not flagDis then
      FDataLink.DataSet.EnableControls;
    ParentChangedTreeNode := Nil;
    NewParentTreeNode := Nil;
    DataChangedBusy := Flag;
  end;

  inherited WndProc(Message);
  if Not DataChangedBusy And Not CopyTreeNodeStructFlag
  And Not MoveTreeNodeStructFlag
  And (Message.Msg = TVM_SETITEM) And Not IsEditing
  And (PTVITEM(Message.lparam)^.mask And TVIF_TEXT = 1)
  And (PTVITEM(Message.lparam)^.hItem <> Nil)
  And (Not ReadOnly) And (FListField <> Nil) And (FDisplayFields.Count = 0)
  And (FDataLink.DataSet.CanModify) And Not FListField.ReadOnly then begin
    DataChangedBusy := True;
    FlagDis := FDataLink.DataSet.ControlsDisabled;
    FDataLink.DataSet.DisableControls;
    SendMessage(Handle, WM_SETREDRAW, Integer(False), 0);
    DataChangedBusy := False;
    tr := Selected;
    TreeView_SelectItem(Handle, PTVITEM(Message.lparam)^.hItem);
    DataChangedBusy := True;
    if(FListField.Text <> Selected.Text) then begin
      FDataLink.DataSet.Edit;
      FListField.Text := Selected.Text;
      FDataLink.DataSet.Post;
    end;
    Selected := tr;
    SendMessage(Handle, WM_SETREDRAW, Integer(True), 0);
    if Not (FlagDis) then
      FDataLink.DataSet.EnableControls;
    DataChangedBusy := False;
  end;
end;

procedure TDBTreeView.WMMouseWheel(var Message: TWMMouseWheel);
const
  CountWheel=1;
var  
  nd: TTreeNode;
begin
  if Assigned(FDataLink) and FDataLink.Active  then begin
   if FDataLink.DataSet=nil then exit;
   if FDataLink.Active then
    with Message, FDataLink.DataSet do begin
       if WheelDelta>=0 then begin
         nd:=Selected.GetPrev;
         if nd<>nil then begin
           nd.MakeVisible;
           nd.Selected:=true;
         end;
       end else begin
         nd:=Selected.GetNext;
         if nd<>nil then begin
           nd.MakeVisible;
           nd.Selected:=true;
         end;
       end;
       Result:=1;
    end;
  end;
end;


end.
