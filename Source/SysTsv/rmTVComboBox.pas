{================================================================================
Copyright (C) 1997-2001 Mills Enterprise

Unit     : rmTVComboBox
Purpose  : TreeView and PathTreeView based ComboBoxes
Date     : 02-01-2000
Author   : Ryan J. Mills
Version  : 1.80
================================================================================}

unit rmTVComboBox;

interface

{$I CompilerDefines.INC}

uses
   Windows, Messages, Classes, Controls, ComCtrls, CommCtrl,stdctrls,
   ImgList, rmScrnCtrls, Buttons, rmBtnEdit;

type

   TrmCustomComboTreeView = class(TrmCustomBtnEdit)
   private
   { Private declarations }
     FScreenTreeview: TrmCustomScreenTreeView;
     fDropDownWidth: integer;
     fSelectedNode: TTreeNode;
     FDropDownHeight: integer;
     FOnDropDown: TNotifyEvent;
     fChanged: TTVChangedEvent;
     fChanging: TTVChangingEvent;
     fLeafOnly: boolean;
     fOnDestroy: TNotifyEvent;
     FLastWidth,FLastheight: Integer;

     procedure FScreenTreeviewOnResize(Sender: TObject);
     procedure SelfOnResize(Sender: TObject);

     function GetExpanded: Boolean;
     procedure SetExpanded(Value: Boolean);
     function GetHotTrack: Boolean;
     procedure SetHotTrack(Value: Boolean);
     procedure ToggleTreeView(Sender: TObject);
//     procedure SelectNode(Incr: Integer);

     procedure DoClick(Sender: TObject);
     procedure DoMyKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
     procedure DoMyExit(Sender: Tobject);

     procedure CMFontchanged(var Message: TMessage); message CM_FontChanged;
     procedure cmCancelMode(var Message:TCMCancelMode); Message cm_cancelMode;
     procedure wmKillFocus(var Message:TMessage); message wm_KillFocus;
     procedure wmSetFocus(var Message:TMessage); message wm_Setfocus;
     procedure wmLBUTTONDOWN(var Message:TMessage); message WM_LBUTTONDOWN;

     function GetAutoExpand: boolean;
     function GetCollapsedEvent: TTVExpandedEvent;
     function GetCollapsingEvent: TTVCollapsingEvent;
     function GetCompareEvent: TTVCompareEvent;
     function GetExpandedEvent: TTVExpandedEvent;
     function GetExpandingEvent: TTVExpandingEvent;
     function GetImages: TCustomImageList;
     function GetItems: TTreeNodes;
     function GetSortType: TSortType;
     function GetStateImages: TCustomImageList;

     procedure SetAutoExpand(const Value: boolean);
     procedure SetCollapsedEvent(const Value: TTVExpandedEvent);
     procedure SetCollapsingEvent(const Value: TTVCollapsingEvent);
     procedure SetCompareEvent(const Value: TTVCompareEvent);
     procedure SetExpandingEvent(const Value: TTVExpandingEvent);
     procedure SetExpandedEvent(const Value: TTVExpandedEvent);
     procedure SetImages(const Value: TCustomImageList);
     procedure SetSelectedNode(const Value: TTreeNode);
     procedure SetSortType(const Value: TSortType);
     procedure SetStateImages(const Value: TCustomImageList);
     procedure SetImageIndexEvent(const Value: TTVExpandedEvent);
     procedure SetSelectedIndexEvent(const Value: TTVExpandedEvent);
     function GetImageIndexEvent: TTVExpandedEvent;
     function GetSelectedIndexEvent: TTVExpandedEvent;
   protected
   { Protected declarations }
     procedure KeyDown(var Key: Word; Shift: TShiftState); override;

     property AllowLeafOnly : boolean read fLeafOnly write fLeafOnly default false;
     property AutoExpand: boolean read getAutoExpand write setAutoExpand;
     property DropDownHeight: integer read FDropDownHeight write fDropDownHeight default 0;
     property DropDownWidth: integer read fDropDownWidth write fDropDownWidth default 0;
     property Images: TCustomImageList read GetImages write SetImages;
     property Items: TTreeNodes read GetItems;
     property SelectedNode: TTreeNode read fSelectedNode write SetSelectedNode;
     property SortType: TSortType read GetSortType write SetSortType;
     property StateImages: TCustomImageList read GetStateImages write SetStateImages;

     property OnChanged: TTVChangedEvent read fChanged write fChanged;
     property OnChanging: TTVChangingEvent read fChanging write fChanging;
     property OnCollapsing: TTVCollapsingEvent read GetCollapsingEvent write SetCollapsingEvent;
     property OnCollapsed: TTVExpandedEvent read GetCollapsedEvent write SetCollapsedEvent;
     property OnCompare: TTVCompareEvent read GetCompareEvent write SetCompareEvent;
     property OnDropDown: TNotifyEvent read FOnDropDown write fOnDropDown;
     property OnExpanding: TTVExpandingEvent read GetExpandingEvent write SetExpandingEvent;
     property OnExpanded: TTVExpandedEvent read GetExpandedEvent write SetExpandedEvent;
     property OnGetImageIndex : TTVExpandedEvent read GetImageIndexEvent write SetImageIndexEvent;
     property OnGetSelectedIndex : TTVExpandedEvent read GetSelectedIndexEvent write SetSelectedIndexEvent;
     property OnDestroy : TNotifyEvent read fOnDestroy write fOnDestroy;
   public
   { Public declarations }
     constructor Create(AOwner: TComponent); override;
     destructor Destroy; override;
     procedure CreateParams(var Params: TCreateParams);override;
     procedure WndProc(var Message: TMessage); override;

     function CustomSort(SortProc: TTVCompare; Data: Longint): Boolean;
     procedure FullExpand;
     procedure FullCollapse;
     procedure DropDown;
     property HotTrack: Boolean read GetHotTrack write SetHotTrack;
     property Expanded: Boolean read GetExpanded write SetExpanded;

   end;

   TrmComboTreeView = class(TrmCustomComboTreeView)
   public
   { Public declarations }
     property Items;
     property SelectedNode;
   published
   { Published declarations }
     {$ifdef D4_OR_HIGHER}
     property Anchors;
     property Constraints;
     {$endif}
     property Enabled;
     property Font;
     property MaxLength;
     property ParentColor;
     property ParentCtl3D;
     property ParentFont;
     property ParentShowHint;
     property PopupMenu;
     property ShowHint;
     property TabOrder;
     property TabStop;
     property Visible;


     property AllowLeafOnly;
     property AutoExpand;
     property DropDownHeight;
     property DropDownWidth;
     property Images;
     property SortType;
     property StateImages;
     property OnDropDown;
     property OnChanged;
     property OnChanging;
     property OnCollapsed;
     property OnCollapsing;
     property OnCompare;
     property OnExpanding;
     property OnExpanded;
     property OnGetImageIndex;
     property OnGetSelectedIndex;
     property OnDestroy;
   end;


implementation

uses forms;



{ TrmCustomComboTreeView }

constructor TrmCustomComboTreeView.Create(AOwner: TComponent);
begin
   inherited create(aowner);

   fSelectedNode := nil;

   OnBtn1Click := ToggleTreeView;
   OnExit := DoMyExit;
   readonly := true;
   fDropDownHeight := 0;
   fDropDownWidth := 0;
   fLeafOnly := false;

   with GetButton(1) do
   begin
      Font.name := 'Marlett';
      font.size := 10;
      Caption := '6';
      Glyph := nil;
   end;


   FScreenTreeview := TrmCustomScreenTreeView.create(nil);
   with FScreenTreeview do
   begin
      width := self.width;
      height := self.height * 8;
      visible := false;
      Parent := self;
      ReadOnly := true;
      OnClick := DoClick;
      OnKeyDown := DoMyKeyDown;
      FScreenTreeview.OnResize:= FScreenTreeviewOnResize;
   end;
   FScreenTreeview.hide;
   FLastWidth:=Width;
   FLastHeight:=Width;
   FScreenTreeview.Constraints.MinHeight:=FScreenTreeview.Height;
   OnResize:=SelfOnResize;
end;

procedure TrmCustomComboTreeView.SelfOnResize(Sender: TObject);
begin
end;

procedure TrmCustomComboTreeView.FScreenTreeviewOnResize(Sender: TObject);
begin
  FLastWidth:=FScreenTreeview.Width;
  FLastHeight:=FScreenTreeview.Height;
end;

procedure TrmCustomComboTreeView.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style and not ES_MULTILINE;
end;

function TrmCustomComboTreeView.CustomSort(SortProc: TTVCompare;
  Data: Integer): Boolean;
begin
   result := FScreenTreeview.CustomSort(SortProc, Data);
end;

procedure TrmCustomComboTreeView.DoClick(Sender: TObject);
var
   allowchange:boolean;
   wPoint : TPoint;
   HitTest : THitTests;
begin
   if not assigned(FScreenTreeview.Selected) then
      exit;

   wPoint := FScreenTreeview.ScreenToClient(Mouse.CursorPos);
   if not assigned(FScreenTreeview.GetNodeAt(wPoint.x, wPoint.y)) then
      exit;

   HitTest := FScreenTreeview.GetHitTestInfoAt(wPoint.x, wPoint.y);
   if not (htOnItem in HitTest) then
      exit;

   if not (fLeafOnly) or ((fLeafOnly) and (FScreenTreeview.Selected.Count = 0)) then
   begin
      allowchange := true;
      if Assigned(fChanging) then
         fChanging(self, FScreenTreeview.Selected, allowchange);
      if allowchange then
      begin
         fSelectedNode := FScreenTreeview.Selected;
         FScreenTreeview.hide;
         Text := fSelectedNode.Text;
         if assigned(fChanged) then
            fChanged(self, fSelectedNode);
      end
      else
         FScreenTreeview.Selected := fSelectedNode;
   end;
end;

procedure TrmCustomComboTreeView.DoMyKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
   AllowChange : boolean;
begin
   if (key = vk_escape) then
   begin
      fSelectedNode :=nil;
      FScreenTreeview.hide;
      self.setfocus;
      if assigned(fChanged) then
         fChanged(self, fSelectedNode);
      fSelectedNode :=FScreenTreeview.Selected;
//      self.SelectAll;
   end
   else
   if (key = vk_Return) then
   begin
      if not assigned(FScreenTreeview.Selected) then
         exit;

      if not (fLeafOnly) or ((fLeafOnly) and (FScreenTreeview.Selected.Count = 0)) then
      begin
         allowchange := true;
         if Assigned(fChanging) then
            fChanging(self, FScreenTreeview.Selected, allowchange);
         if allowchange then
         begin
            fSelectedNode := FScreenTreeview.Selected;
            FScreenTreeview.hide;
            Text := fSelectedNode.Text;
            self.setfocus;
            if assigned(fChanged) then
               fChanged(self, fSelectedNode);
//            self.SelectAll;
         end
         else
            FScreenTreeview.Selected := fSelectedNode;
      end;
   end
end;

procedure TrmCustomComboTreeView.DoMyExit(Sender: Tobject);
begin
   if FScreenTreeview.visible then
      FScreenTreeview.visible := false;
end;

procedure TrmCustomComboTreeView.FullCollapse;
begin
   FScreenTreeview.FullCollapse;  
end;

procedure TrmCustomComboTreeView.FullExpand;
begin
   FScreenTreeview.FullExpand;
end;

function TrmCustomComboTreeView.getAutoExpand: boolean;
begin
   result := FScreenTreeview.AutoExpand;
end;

function TrmCustomComboTreeView.GetCollapsedEvent: TTVExpandedEvent;
begin
   Result := FScreenTreeview.OnCollapsed;
end;

function TrmCustomComboTreeView.GetCollapsingEvent: TTVCollapsingEvent;
begin
   Result := FScreenTreeview.OnCollapsing;
end;

function TrmCustomComboTreeView.GetCompareEvent: TTVCompareEvent;
begin
   Result := FScreenTreeview.OnCompare;
end;

function TrmCustomComboTreeView.GetExpandedEvent: TTVExpandedEvent;
begin
   Result := FScreenTreeview.OnExpanded;
end;

function TrmCustomComboTreeView.GetExpandingEvent: TTVExpandingEvent;
begin
   result := FScreenTreeview.OnExpanding;
end;

function TrmCustomComboTreeView.GetImageIndexEvent: TTVExpandedEvent;
begin
   Result := FScreenTreeview.OnGetImageIndex;
end;

function TrmCustomComboTreeView.GetImages: TCustomImageList;
begin
   result := FScreenTreeview.images;
end;

function TrmCustomComboTreeView.GetItems: TTreeNodes;
begin
   Result := FScreenTreeview.Items;
end;

function TrmCustomComboTreeView.GetSelectedIndexEvent: TTVExpandedEvent;
begin
   Result := FScreenTreeview.OnGetSelectedIndex;
end;

function TrmCustomComboTreeView.GetSortType: TSortType;
begin
   Result := FScreenTreeview.SortType;
end;

function TrmCustomComboTreeView.GetStateImages: TCustomImageList;
begin
   result := FScreenTreeview.StateImages;
end;

procedure TrmCustomComboTreeView.DropDown;
begin
  ToggleTreeView(Self);
  FScreenTreeview.SetFocus;
end;

{procedure TrmCustomComboTreeView.SelectNode(Incr: Integer);
var
  nd: TTreeNode;
  ndSel: TTreeNode;
begin
  ndSel:=FScreenTreeview.Selected;
  if ndSel=nil then begin
   if FScreenTreeview.Items.Count>0 then begin
    nd:=FScreenTreeview.Items.Item[0];
    nd.Selected:=true;
    nd.MakeVisible;
    Text:=nd.Text;
    fSelectedNode:=nd;
//    self.SelectAll;
    if assigned(fChanged) then
       fChanged(self, fSelectedNode);
   end;
   exit;
  end;
  case Incr of
    1: begin
      nd:=ndSel.GetNext;
      if nd<>nil then begin
        nd.Selected:=true;
        nd.MakeVisible;
        Text:=nd.Text;
        fSelectedNode:=nd;
//        self.SelectAll;
        if assigned(fChanged) then
          fChanged(self, fSelectedNode);
      end;
    end;
   -1: begin
      nd:=ndSel.GetPrev;
      if nd<>nil then begin
        nd.Selected:=true;
        nd.MakeVisible;
        Text:=nd.Text;
        fSelectedNode:=nd;
//        self.SelectAll;
        if assigned(fChanged) then
          fChanged(self, fSelectedNode);
      end;
    end;
  end;

end;}

function TrmCustomComboTreeView.GetHotTrack: Boolean;
begin
  Result:=FScreenTreeview.HotTrack;
end;

procedure TrmCustomComboTreeView.SetHotTrack(Value: Boolean);
begin
  FScreenTreeview.HotTrack:=Value;
end;

function TrmCustomComboTreeView.GetExpanded: Boolean;
begin
  Result:=FScreenTreeview.AutoExpand;
end;

procedure TrmCustomComboTreeView.SetExpanded(Value: Boolean);
begin
  FScreenTreeview.AutoExpand:=Value;
end;


procedure TrmCustomComboTreeView.KeyDown(var Key: Word;
   Shift: TShiftState);
begin
   if ((Key = VK_DOWN) or (key = VK_UP)) and (ssAlt in Shift) then
   begin
      if not FScreenTreeview.visible then
         ToggleTreeView(self)
      else begin
         FScreenTreeview.hide;
      end;
   end
   else begin
//     inherited KeyDown(Key, Shift);
   //  FScreenTreeview.KeyDown(Key, Shift);
   end;  

end;

procedure TrmCustomComboTreeView.setAutoExpand(const Value: boolean);
begin
   FScreenTreeview.AutoExpand := Value;
end;

procedure TrmCustomComboTreeView.SetCollapsedEvent(
   const Value: TTVExpandedEvent);
begin
   FScreenTreeview.OnCollapsed := Value;
end;

procedure TrmCustomComboTreeView.SetCollapsingEvent(
   const Value: TTVCollapsingEvent);
begin
   FScreenTreeview.OnCollapsing := Value;
end;

procedure TrmCustomComboTreeView.SetCompareEvent(
   const Value: TTVCompareEvent);
begin
   FScreenTreeview.OnCompare := Value;
end;

procedure TrmCustomComboTreeView.SetExpandedEvent(
   const Value: TTVExpandedEvent);
begin
   FScreenTreeview.OnExpanded := Value;
end;

procedure TrmCustomComboTreeView.SetExpandingEvent(
   const Value: TTVExpandingEvent);
begin
   FScreenTreeview.OnExpanding := Value;
end;

procedure TrmCustomComboTreeView.SetImageIndexEvent(
  const Value: TTVExpandedEvent);
begin
   FScreenTreeview.OnGetImageIndex := value;  
end;

procedure TrmCustomComboTreeView.SetImages(const Value: TCustomImageList);
begin
   FScreenTreeview.Images := value;
end;

procedure TrmCustomComboTreeView.SetSelectedIndexEvent(
  const Value: TTVExpandedEvent);
begin
   FScreenTreeview.OnGetSelectedIndex := value;  
end;

procedure TrmCustomComboTreeView.SetSelectedNode(const Value: TTreeNode);
begin
   fSelectedNode := Value;
   if assigned(fSelectedNode) then
      Text := fSelectedNode.Text
   else Text := '';
end;

procedure TrmCustomComboTreeView.SetSortType(const Value: TSortType);
begin
   FScreenTreeview.SortType := value;
end;

procedure TrmCustomComboTreeView.SetStateImages(
   const Value: TCustomImageList);
begin
   FScreenTreeview.StateImages := value;
end;

procedure TrmCustomComboTreeView.ToggleTreeView(Sender: TObject);
var
   CP, SP: TPoint;
begin
   CP.X := Left;
   CP.Y := Top + Height;
   SP := parent.ClientToScreen(CP);

   SetFocus;
//   SelectAll;

   with FScreenTreeview do
   begin
{     if fDropDownWidth = 0 then
         Width := self.width
      else}
         width := FLastWidth;

{     if fDropDownHeight = 0 then
         Height := self.Height * 8
      else}
         Height := FLastheight;

      try
        if not isBadReadPtr(fSelectedNode,TTreeNode.InstanceSize) then begin
         Selected := fSelectedNode;
         if assigned(Selected) then
            Selected.MakeVisible;
        end else
         Selected := nil;
      except
         Selected := nil;
      end;
      Left := SP.X;

      if assigned(screen.ActiveForm) then
      begin
        if (SP.Y + FScreenTreeview.height < screen.activeForm.Monitor.Height) then
          FScreenTreeview.Top := SP.Y
        else
          FScreenTreeview.Top := (SP.Y - self.height) - FScreenTreeview.height;
      end
      else
      begin
        if (SP.Y + FScreenTreeview.height < screen.Height) then
          FScreenTreeview.Top := SP.Y
        else
          FScreenTreeview.Top := (SP.Y - self.height) - FScreenTreeview.height;
      end;

      FScreenTreeview.Constraints.MinWidth:=Self.Width;
      if FScreenTreeview.Width<Self.Width then
        FScreenTreeview.Width:=Self.Width;
        
      Show;


  {    SetWindowPos(handle, hwnd_topMost, FScreenTreeview.Left,
                                         FScreenTreeview.top,
                                         FScreenTreeview.Width,
                                         FScreenTreeview.Height, swp_nosize or swp_NoMove);      }

      SetWindowPos(handle, hwnd_topMost, 0,
                                         0,
                                         0,
                                         0, swp_nosize or swp_NoMove);

   end; { Calendar }

end;

procedure TrmCustomComboTreeView.WndProc(var Message: TMessage);
begin

 case Message.Msg of
    WM_CHAR,
  //  WM_KEYDOWN,
    WM_KEYUP   : if (FScreenTreeview.visible) then
                 begin
{                      if GetCaptureControl =nil then
                      begin}
                         Message.result := SendMessage(FScreenTreeview.Handle, message.msg, message.wParam, message.LParam);
//                         if message.result = 0 then exit;
//                      end;
                 end;
  end;
  inherited WndProc(Message);
end;

destructor TrmCustomComboTreeView.Destroy;
begin
  if assigned(fOnDestroy) then
     fOnDestroy(self);
  FScreenTreeview.free;
  inherited;
end;

procedure TrmCustomComboTreeView.wmKillFocus(var Message: TMessage);
begin
  // inherited;
   if FScreenTreeview.visible then begin
      FScreenTreeview.Hide;
   end;
end;

procedure TrmCustomComboTreeView.wmSetFocus(var Message:TMessage);
begin
 // inherited;
  FButton1.Invalidate;
end;

procedure TrmCustomComboTreeView.wmLBUTTONDOWN(var Message:TMessage);
begin
  inherited;
  FButton1.Click;
{ if not FScreenTreeview.visible then
      ToggleTreeView(self)
 else begin
      FScreenTreeview.hide;
 end;}
end;

procedure TrmCustomComboTreeView.cmCancelMode(var Message: TCMCancelMode);
begin
   inherited;
   if Message.Sender = fScreenTreeView then
      exit;
   if FScreenTreeview.visible then
      FScreenTreeview.Hide;
end;

procedure TrmCustomComboTreeView.CMFontchanged(var Message: TMessage);
begin
   inherited;
   FScreenTreeview.Font.Assign(self.font);  
end;

{ TrmCustomComboPathTreeView }


end.

