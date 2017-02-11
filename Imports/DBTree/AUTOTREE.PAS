unit autotree;
(*
 COPYRIGHT (c) RSD software 1997, 98
 All Rights Reserved.
*)


{$I dbtrver.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, CommCtrl, ExtCtrls;

type
  TAutoTreeViewOption = (trCanDelete, trConfirmDelete);
  TAutoTreeViewOptions = set of TAutoTreeViewOption;

  TDragDropTreeNode = procedure(Destination, Source : TTreeNode;
                    Var Accept : Boolean) of object;
  TEndDragTreeNode = procedure(Destination, Source : TTreeNode;
                    Var AttachMode : TNodeAttachMode) of object;
  TTreeViewCustomDraw = procedure(Sender : TObject; TreeNode : TTreeNode;
                        AFont : TFont; Var AColor, ABkColor : TColor) of object;

  TCustomAutoTreeView = class(TCustomTreeView)
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


const ATreeViewDelConfirm = 37201;
const ADBTreeViewSmartLoadS = 37202;

implementation

{$I rsdcmctl.inc}
{$R autotree.res}

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
     FScrollTimerID := SetTimer(Handle, 1, 300, @ScrollTreeViewTimerProc);
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
Var
  pnmlv : PNMLVCustomDraw;
  tr : TTreeNode;
  htr : HTReeItem;
  Color, BkColor : TColor;
begin
  if(Message.nmhdr^.code = NM_CUSTOMDRAW) then  begin
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

  {$IFDEF DELPHI3_0}
  with Message.NMHdr^ do
    if (code = TVN_BEGINLABELEDIT) then
      SetImeMode(TreeView_GetEditControl(handle), ImeMode);
  {$ENDIF}    
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

{$IFDEF  UNREGISTEREDDBTREEVIEW}
const
  PROT_MESSAGE = 'Permission to use DBTreeView components without fee is hereby granted. See order.txt';

procedure CheckProtection;
begin
  if (FindWindow('TPropertyInspector', 'Object Inspector') = 0) then begin
    MessageDlg(PROT_MESSAGE, mtWarning, [mbOK], 0);
    exit;
  end;
end;

{$ENDIF}


initialization
  OldDragOverTreeNode := Nil;
  AutoTreeViewDragImages := Nil;
  Screen.Cursors[-1011] := LoadCursor(HInstance, 'AUTOTREEDRAGCOPY');
  {$IFDEF  UNREGISTEREDDBTREEVIEW}
     CheckProtection;
  {$ENDIF}

end.
