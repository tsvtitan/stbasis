unit tsvTreeEdit;

interface

{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls, Menus, DsgnIntf, ImgList, ToolWin, StdCtrls;

type
  TfmTreeEditor = class(TForm)
    pnTV: TPanel;
    TV: TTreeView;
    pmTV: TPopupMenu;
    pmDrag: TPopupMenu;
    miDragInsert: TMenuItem;
    miDragInsertChild: TMenuItem;
    N2: TMenuItem;
    miDragCancel: TMenuItem;
    il: TImageList;
    pntlBar: TPanel;
    tlBar: TToolBar;
    tbAdd: TToolButton;
    tbAddChild: TToolButton;
    tbChange: TToolButton;
    tbDelete: TToolButton;
    ToolButton1: TToolButton;
    tbExpand: TToolButton;
    tbCollapse: TToolButton;
    ToolButton6: TToolButton;
    tbUp: TToolButton;
    tbDown: TToolButton;
    grbProps: TGroupBox;
    lbImageIndex: TLabel;
    edImageIndex: TEdit;
    lbSelectedIndex: TLabel;
    edSelectedIndex: TEdit;
    lbStateIndex: TLabel;
    edStateIndex: TEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TVAdvancedCustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; State: TCustomDrawState; Stage: TCustomDrawStage;
      var PaintImages, DefaultDraw: Boolean);
    procedure TVChange(Sender: TObject; Node: TTreeNode);
    procedure TVEdited(Sender: TObject; Node: TTreeNode; var S: String);
    procedure TVDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure TVEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure miDragInsertClick(Sender: TObject);
    procedure miDragInsertChildClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tbAddClick(Sender: TObject);
    procedure tbAddChildClick(Sender: TObject);
    procedure tbChangeClick(Sender: TObject);
    procedure tbDeleteClick(Sender: TObject);
    procedure tbExpandClick(Sender: TObject);
    procedure tbCollapseClick(Sender: TObject);
    procedure pmTVPopup(Sender: TObject);
    procedure tbUpClick(Sender: TObject);
    procedure tbDownClick(Sender: TObject);
    procedure edImageIndexExit(Sender: TObject);
    procedure edImageIndexEnter(Sender: TObject);
  private
    NewLeft,NewTop,NewWidth,NewHeight: Integer;
    FTreeNodes: TTreeNodes;
    FCurNode,FSelNode: TTReeNode;
    procedure ViewNode(nd: TTreeNode);
    function Check: Boolean;
    procedure LoadFromIni;
    procedure SaveToIni;
    procedure FillPopupMenu;
    procedure SetProps;
  public
    ObjectEdit: TObject;
    isSetParam: Boolean;
    PropertyDesigner: Pointer;
    procedure SetCaption(AComponent: TComponent);
    procedure FillTreeFromTreeNodes(TreeNodes: TTreeNodes);
    procedure ForcedNotification(AForm: TCustomForm;
              APersistent: TPersistent; Operation: TOperation);
  end;


  TTreeNodeProperty = class(TClassProperty)
  private
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
    destructor Destroy; override;
    procedure Initialize; override;
  end;

  TTreeNodeEditor = class(TDefaultEditor)
    procedure EditProperty(PropertyEditor: TPropertyEditor;
      var Continue, FreeEditor: Boolean); override;
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;
  
var
  fmTreeEditor: TfmTreeEditor;

implementation

uses {UComponents, }UCmptsTsvData, UCmptsTsvCode, UMainUnited;

{$R *.DFM}

const
  ConstNodeName='”зел';


{ TfmTreeEditor }

procedure TfmTreeEditor.LoadFromIni;
begin
  try
      Left:=ReadParam(ClassName,'Left',NewLeft);
      Top:=ReadParam(ClassName,'Top',NewTop);
      Width:=ReadParam(ClassName,'Width',NewWidth);
      Height:=ReadParam(ClassName,'Height',NewHeight);
  except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

procedure TfmTreeEditor.SaveToIni;
begin
  try
      WriteParam(ClassName,'Left',Left);
      WriteParam(ClassName,'Top',Top);
      WriteParam(ClassName,'Width',Width);
      WriteParam(ClassName,'Height',Height);
  except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

procedure TfmTreeEditor.FillTreeFromTreeNodes(TreeNodes: TTreeNodes);

   procedure FillLocal(ndParentNew,ndParent: TTreeNode);
   var
     nd,ndNew: TTreeNode;
     i: Integer;
   begin
     for i:=0 to ndParentNew.Count-1 do begin
       ndNew:=ndParentNew.Item[i];
       nd:=TV.Items.AddChildObject(ndParent,ndNew.Text,ndNew);
       FillLocal(ndNew,nd);
     end;
   end;

var
  i: Integer;
  nd: TTreeNode;
begin
  if (FTreeNodes=TreeNodes)and(TreeNodes<>nil) then begin
    exit;
  end;
  FTreeNodes:=TreeNodes;
  TV.Items.BeginUpdate;
  try
   TV.Items.Clear;
   if FTreeNodes<>nil then begin
     for i:=0 to FTreeNodes.Count-1 do
      if FTreeNodes.Item[i].Level=0 then begin
        nd:=TV.Items.AddChildObject(nil,FTreeNodes.Item[i].Text,FTreeNodes.Item[i]);
        FillLocal(FTreeNodes.Item[i],nd);
      end;  
   end;
  finally
   TV.Items.EndUpdate;
  end;
end;

procedure TfmTreeEditor.SetCaption(AComponent: TComponent);
begin
  if AComponent<>nil then
   Caption:=Format(fmtSetCaption,['–едактор дерева',AComponent.Name])
  else
   Caption:='–едактор дерева';
end;

procedure TfmTreeEditor.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:=caHide;
//  fmTreeEditor:=nil;
end;

procedure TfmTreeEditor.TVAdvancedCustomDrawItem(Sender: TCustomTreeView;
  Node: TTreeNode; State: TCustomDrawState; Stage: TCustomDrawStage;
  var PaintImages, DefaultDraw: Boolean);
{var
  rt: Trect;
  oldBrush: TBrush;    }
begin
{ oldBrush:=TBrush.Create;
 try
  if GetFocus<>TV.Handle then begin
    if Node=TV.Selected then begin
      oldBrush.Assign(TV.Canvas.Brush);
      TV.Canvas.Brush.Style:=bsSolid;
      TV.Canvas.Brush.Color:=clBtnFace;
      rt:=Node.DisplayRect(true);
      TV.Canvas.FillRect(rt);
      TV.Canvas.Brush.Style:=bsClear;
      TV.Canvas.Font.Color:=clWindowText;
      TV.Canvas.TextOut(rt.Left+2,rt.top+1,node.text);
      TV.Canvas.Brush.Assign(oldBrush);
    end else begin
     DefaultDraw:=true;
    end;
  end else begin
    if Node=TV.Selected then begin
     oldBrush.Assign(TV.Canvas.Brush);
     TV.Canvas.Brush.Style:=bsSolid;
     TV.Canvas.Brush.Color:=clHighlight;
     rt:=Node.DisplayRect(true);
     TV.Canvas.FillRect(rt);
     TV.Canvas.Brush.Style:=bsClear;
     TV.Canvas.Font.Color:=clHighlightText;
     TV.Canvas.TextOut(rt.Left+2,rt.top+1,node.text);
     TV.Canvas.DrawFocusRect(rt);
     TV.Canvas.Brush.Assign(oldBrush);
    end else begin
     DefaultDraw:=true;
    end;
  end;
 finally
  oldBrush.Free;
 end;    }
end;

procedure TfmTreeEditor.TVChange(Sender: TObject; Node: TTreeNode);
begin
  ViewNode(TV.Selected);
end;

procedure TfmTreeEditor.TVEdited(Sender: TObject; Node: TTreeNode;
  var S: String);
begin
  if not Check then exit;
  if node=nil then exit;
  if Node.Data=nil then exit;
  TTreeNode(Node.Data).Text:=S;
  IFormDesigner(PropertyDesigner).Modified;
end;

procedure TfmTreeEditor.ViewNode(nd: TTreeNode);
begin
  if isSetParam then exit;
  if not Check then exit;
  if nd=nil then exit;
  if csReadingState in TV.ControlState then exit;
  if nd.data=nil then exit;

  SetProps;
//  IFormDesigner(PropertyDesigner).SelectComponent(nd.Data);
  IFormDesigner(PropertyDesigner).Modified;
end;

function TfmTreeEditor.Check: Boolean;
begin
  Result:=false;
  if FTreeNodes=nil then exit;
  if PropertyDesigner=nil then exit;
  Result:=true;
end;

procedure TfmTreeEditor.TVDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept:=false;
  if Sender=Source then begin
    Accept:=true;
  end;
end;

procedure TfmTreeEditor.TVEndDrag(Sender, Target: TObject; X, Y: Integer);
var
  pt: TPoint;
begin
  if (Target=TV) then begin
   FSelNode:=TV.Selected;
   FCurNode:=TV.GetNodeAt(X,Y);
   GetCursorPos(pt);
   if FSelNode=nil then exit;
   if FCurNode=nil then exit;
   pmDrag.Popup(pt.X,pt.Y);
  end;
end;

procedure TfmTreeEditor.miDragInsertClick(Sender: TObject);
begin
  FSelNode.MoveTo(FCurNode,naInsert);
  TTreeNode(FSelNode.Data).MoveTo(TTreeNode(FCurNode.Data),naInsert);
end;

procedure TfmTreeEditor.miDragInsertChildClick(Sender: TObject);
begin
  FSelNode.MoveTo(FCurNode,naAddChild);
  TTreeNode(FSelNode.Data).MoveTo(TTreeNode(FCurNode.Data),naAddChild);
end;

procedure TfmTreeEditor.FormDestroy(Sender: TObject);
begin
  PropertyDesigner:=nil;
  SaveToIni;
end;

procedure TfmTreeEditor.FormCreate(Sender: TObject);
begin
  NewLeft:=Screen.width div 2-Width div 2;
  NewTop:=Screen.Height div 2-Height div 2;
  NewWidth:=Width;
  NewHeight:=Height;
  LoadFromIni;
end;

procedure TfmTreeEditor.ForcedNotification(AForm: TCustomForm;
                         APersistent: TPersistent; Operation: TOperation);
begin
   case Operation of
      opInsert:;
      opRemove:begin
         if ObjectEdit=APersistent then
            FreeAndNil(fmTreeEditor);
      end;
   end;
end;


{ TMenuItemProperty }

function TTreeNodeProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paDialog]- [paSubProperties]-[paMultiSelect];
end;

procedure TTreeNodeProperty.Initialize;
begin
  inherited;
end;

procedure TTreeNodeProperty.Edit;
var
  fm: TfmTreeEditor;
  Comp: TPersistent;
begin
  fm:=fmTreeEditor;
  if fm=nil then
   fm:=TfmTreeEditor.Create(nil);
  fm.isSetParam:=true;
  Comp:= GetComponent(0);
  fm.ObjectEdit:=Comp;
  if Comp is TComponent then begin
   fm.SetCaption(TComponent(Comp));
  end else begin
   fm.SetCaption(nil);
  end;
  fm.PropertyDesigner:=Pointer(Designer);
  fm.FillTreeFromTreeNodes(TTreeNodes(GetOrdValue));
  fm.ActiveControl := fm.TV;
  fm.show;
  fm.BringToFront;
  fmTreeEditor:=fm;
  fm.Tv.Selected:=nil;
  fm.isSetParam:=false;
end;

destructor TTreeNodeProperty.Destroy;
begin
  inherited;
end;

{ TTreeNodeEditor }

procedure TTreeNodeEditor.ExecuteVerb(Index: Integer);
begin
  case Index of
    0: Edit;
  end;
end;

function TTreeNodeEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Ёлементы';
  else Result := '';
  end;
end;

function TTreeNodeEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

procedure TTreeNodeEditor.EditProperty(PropertyEditor: TPropertyEditor;
             var Continue, FreeEditor: Boolean);
var
  PropName: string;
begin
  PropName := PropertyEditor.GetName;
  if (CompareText(PropName, 'Items') = 0)then
  begin
    PropertyEditor.Edit;
    Continue := False;
    FreeEditor:=false;
  end else
    inherited EditProperty(PropertyEditor, Continue, FreeEditor);
end;





procedure TfmTreeEditor.tbAddClick(Sender: TObject);
var
  nd,ndView: TTreeNode;
  ndNew,ndParentNew: TTreeNode;
begin
  if not Check then exit;

  nd:=TV.Selected;
  if nd=nil then
    ndParentNew:=nil
  else begin
    if nd.Parent=nil then
      ndParentNew:=nil
    else
      ndParentNew:=nd.Data;
  end;

  ndNew:=FTreeNodes.Add(ndParentNew,ConstNodeName+inttostr(FTreeNodes.Count));
  ndView:=TV.Items.AddObject(nd,ndNew.text,ndNew);
  ViewNode(ndView);
  ndView.Selected:=true;
  ndView.MakeVisible;
  ndView.EditText;
end;

procedure TfmTreeEditor.tbAddChildClick(Sender: TObject);
var
  nd,ndView: TTreeNode;
  ndNew,ndParentNew: TTreeNode;
begin
  if not Check then exit;

  nd:=TV.Selected;
  if nd=nil then
    ndParentNew:=nil
  else begin
    ndParentNew:=nd.Data;
  end;

  ndNew:=FTreeNodes.AddChild(ndParentNew,ConstNodeName+inttostr(FTreeNodes.Count));
  ndView:=TV.Items.AddChildObject(nd,ndNew.Text,ndNew);
  ViewNode(ndView);
  ndView.Selected:=true;
  ndView.MakeVisible;
  ndView.EditText;
end;

procedure TfmTreeEditor.tbChangeClick(Sender: TObject);
var
  nd: TTreeNode;
begin
  if not Check then exit;
  nd:=TV.Selected;
  if nd=nil then exit;
  nd.EditText;
end;

procedure TfmTreeEditor.tbDeleteClick(Sender: TObject);
var
  nd: TTreeNode;
begin
  if not Check then exit;
  nd:=TV.Selected;
  if nd=nil then exit;
  TTreeNode(nd.Data).Delete;
  nd.Delete;
  IFormDesigner(PropertyDesigner).Modified;
end;

procedure TfmTreeEditor.tbExpandClick(Sender: TObject);
begin
  if not Check then exit;
  TV.FullExpand;
end;

procedure TfmTreeEditor.tbCollapseClick(Sender: TObject);
begin
  if not Check then exit;
  TV.FullCollapse;
end;

procedure TfmTreeEditor.FillPopupMenu;
var
  i: Integer;
  mi: TMenuItem;
  bt: TToolButton;
begin
 try
  pmTV.Items.Clear;
  for i:=0 to tlBar.ButtonCount-1 do begin
    bt:=tlBar.Buttons[i];
    mi:=TMenuItem.Create(Self);
    case bt.Style of
      tbsButton: mi.Caption:=bt.Caption;
      tbsSeparator: mi.Caption:='-';
    end;
    mi.Hint:=bt.Hint;
    mi.Enabled:=bt.Enabled;
    mi.ImageIndex:=bt.ImageIndex;
    mi.OnClick:=bt.OnClick;
    pmTV.Items.Add(mi);
  end;
 finally

 end; 
end;

procedure TfmTreeEditor.pmTVPopup(Sender: TObject);
begin
   FillPopupMenu;
end;

procedure TfmTreeEditor.tbUpClick(Sender: TObject);
var
  nd: TTreeNode;
  ndPrev: TTreeNode;
begin
 if not Check then exit;
 TV.Items.BeginUpdate;
 try
  nd:=TV.Selected;
  if nd=nil then exit;
  ndPrev:=nd.getPrevSibling;
  if ndPrev=nil then exit;
  TTreeNode(nd.Data).MoveTo(TTreeNode(ndPrev.Data),naInsert);
  nd.MoveTo(ndPrev,naInsert);
 finally
  TV.Items.EndUpdate;
 end;
end;

procedure TfmTreeEditor.tbDownClick(Sender: TObject);
var
  nd: TTreeNode;
  ndNext: TTreeNode;
begin
 if not Check then exit;
 TV.Items.BeginUpdate;
 try
  nd:=TV.Selected;
  if nd=nil then exit;
  ndNext:=nd.getNextSibling;
  if ndNext=nil then exit;
  ndNext:=ndNext.getNextSibling;
  if ndNext=nil then begin
   ndNext:=nd.getNextSibling;
   TTreeNode(nd.Data).MoveTo(TTreeNode(ndNext.Data),naAdd);
   nd.MoveTo(ndNext,naAdd);
  end else begin
   TTreeNode(nd.Data).MoveTo(TTreeNode(ndNext.Data),naInsert);
   nd.MoveTo(ndNext,naInsert);
  end; 
 finally
  TV.Items.EndUpdate;
 end;
end;

procedure TfmTreeEditor.edImageIndexExit(Sender: TObject);
var
  ed: TEdit;
  nd: TTreeNode;
  ndNew: TTreeNode;
begin
  nd:=TV.Selected;
  if nd=nil then exit;
  ndNew:=nd.Data;
  if Sender is TEdit then begin
   ed:=TEdit(Sender);
   if ed=edImageIndex then begin
     if isInteger(ed.Text) then ndNew.ImageIndex:=strtoint(ed.Text);
   end;
   if ed=edSelectedIndex then begin
     if isInteger(ed.Text) then ndNew.selectedIndex:=strtoint(ed.Text);
   end;
   if ed=edStateIndex then begin
     if isInteger(ed.Text) then ndNew.StateIndex:=strtoint(ed.Text);
   end;
  end;
end;

procedure TfmTreeEditor.SetProps;
begin
  edImageIndexEnter(edImageIndex);
  edImageIndexEnter(edSelectedIndex);
  edImageIndexEnter(edStateIndex);
end;

procedure TfmTreeEditor.edImageIndexEnter(Sender: TObject);
var
  ed: TEdit;
  nd: TTreeNode;
  ndNew: TTreeNode;
begin
  nd:=TV.Selected;
  if nd=nil then exit;
  ndNew:=nd.Data;
  if Sender is TEdit then begin
   ed:=TEdit(Sender);
   if ed=edImageIndex then begin
     ed.Text:=inttostr(ndNew.ImageIndex);
   end;
   if ed=edSelectedIndex then begin
     ed.Text:=inttostr(ndNew.SelectedIndex);
   end;
   if ed=edStateIndex then begin
     ed.Text:=inttostr(ndNew.StateIndex);
   end;
  end; 
end;

end.
