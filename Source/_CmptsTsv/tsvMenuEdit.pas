unit tsvMenuEdit;

interface

{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls, Menus, DsgnIntf, ImgList, ToolWin;

type
  TfmMenuEditor = class(TForm)
    pnTV: TPanel;
    TV: TTreeView;
    pmTV: TPopupMenu;
    pmDrag: TPopupMenu;
    miDragInsert: TMenuItem;
    miDragInsertChild: TMenuItem;
    N2: TMenuItem;
    miDragCancel: TMenuItem;
    pntlBar: TPanel;
    tlBar: TToolBar;
    tbAdd: TToolButton;
    tbDelete: TToolButton;
    ToolButton1: TToolButton;
    tbUp: TToolButton;
    tbDown: TToolButton;
    il: TImageList;
    tbAddChild: TToolButton;
    tbChange: TToolButton;
    tbExpand: TToolButton;
    tbCollapse: TToolButton;
    ToolButton6: TToolButton;
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
    procedure TVClick(Sender: TObject);
  private
    NewLeft,NewTop,NewWidth,NewHeight: Integer;
    FMenuItem: TMenuItem;
    FCurNode,FSelNode: TTReeNode;
    procedure ViewNode(nd: TTreeNode);
    function Check: Boolean;
    procedure LoadFromIni;
    procedure SaveToIni;
    procedure FillPopupMenu;
  public
    ObjectEdit: TObject;
    isSetParam: Boolean;
    PropertyDesigner: Pointer;
    procedure SetCaption(AComponent: TComponent);
    procedure FillTreeFromMenuItem(MenuItem: TMenuItem);
    procedure ForcedNotification(AForm: TCustomForm;
              APersistent: TPersistent; Operation: TOperation);
  end;


  TMenuItemProperty = class(TClassProperty)
  private
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
    destructor Destroy; override;
    procedure Initialize; override;
  end;

  TMenuItemEditor = class(TDefaultEditor)
    procedure EditProperty(PropertyEditor: TPropertyEditor;
      var Continue, FreeEditor: Boolean); override;
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;
  
  

var
  fmMenuEditor: TfmMenuEditor;

implementation

uses {UComponents, }UCmptsTsvData, UCmptsTsvCode, UMainUnited;

{$R *.DFM}


{ TfmMenuEditor }

procedure TfmMenuEditor.LoadFromIni;
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

procedure TfmMenuEditor.SaveToIni;
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

procedure TfmMenuEditor.FillTreeFromMenuItem(MenuItem: TMenuItem);

   procedure FillLocal(miParent: TMenuItem; ndParent: TTreeNode);
   var
     mi: TMenuItem;
     nd: TTreeNode;
     i: Integer;
   begin
     for i:=0 to miParent.Count-1 do begin
       mi:=TMenuItem(miParent.Items[i]);
       nd:=TV.Items.AddChildObject(ndParent,mi.Caption,mi);
       FillLocal(mi,nd);
     end;
   end;

begin
  if (FMenuItem=MenuItem)and(MenuItem<>nil) then begin
    exit;
  end;
  FMenuItem:=MenuItem;
  TV.Items.BeginUpdate;
  try
   TV.Items.Clear;
   if FMenuItem<>nil then
    FillLocal(TMenuItem(FMenuItem),nil);
  finally
   TV.Items.EndUpdate;
  end;
end;

procedure TfmMenuEditor.SetCaption(AComponent: TComponent);
begin
  if AComponent<>nil then
   Caption:=Format(fmtSetCaption,['–едактор меню',AComponent.Name])
  else
   Caption:='–едактор меню';
end;

procedure TfmMenuEditor.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:=caHide;
//  fmMenuEditor:=nil;
end;

procedure TfmMenuEditor.TVAdvancedCustomDrawItem(Sender: TCustomTreeView;
  Node: TTreeNode; State: TCustomDrawState; Stage: TCustomDrawStage;
  var PaintImages, DefaultDraw: Boolean);
{var
  rt: Trect;
  oldBrush: TBrush;}
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
 end;               }
end;

procedure TfmMenuEditor.TVChange(Sender: TObject; Node: TTreeNode);
begin
  ViewNode(TV.Selected);
end;

procedure TfmMenuEditor.TVEdited(Sender: TObject; Node: TTreeNode;
  var S: String);
begin
  if not Check then exit;
  if node=nil then exit;
  if Node.Data=nil then exit;
  TMenuItem(Node.Data).Caption:=S;
  IFormDesigner(PropertyDesigner).Modified;
end;

procedure TfmMenuEditor.ViewNode(nd: TTreeNode);
begin
  if isSetParam then exit;
  if not Check then exit;
  if nd=nil then exit;
  IFormDesigner(PropertyDesigner).SelectComponent(nd.Data);
  IFormDesigner(PropertyDesigner).Modified;
end;

function TfmMenuEditor.Check: Boolean;
begin
  Result:=false;
  if FMenuItem=nil then exit;
  if PropertyDesigner=nil then exit;
  Result:=true;
end;

procedure TfmMenuEditor.TVDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept:=false;
  if Sender=Source then begin
    Accept:=true;
  end;
end;

procedure TfmMenuEditor.TVEndDrag(Sender, Target: TObject; X, Y: Integer);
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

procedure TfmMenuEditor.miDragInsertClick(Sender: TObject);
var
  ctSel,ctCur,ctSelParent,ctCurParent: TMenuItem;
begin
  FSelNode.MoveTo(FCurNode,naInsert);
  ctSel:=FSelNode.Data;
  ctCur:=FCurNode.Data;
  ctSelParent:=TMenuItem(ctSel.Parent);
  ctCurParent:=TMenuItem(ctCur.Parent);
  ctSelParent.Remove(ctSel);
  ctCurParent.Insert(ctCur.MenuIndex,ctSel);
end;

procedure TfmMenuEditor.miDragInsertChildClick(Sender: TObject);
var
  ctSel,ctCur,ctSelParent: TMenuItem;
begin
  FSelNode.MoveTo(FCurNode,naAddChild);
  ctSel:=FSelNode.Data;
  ctCur:=FCurNode.Data;
  ctSelParent:=TMenuItem(ctSel.Parent);
  ctSelParent.Remove(ctSel);
  ctCur.Add(ctSel);
end;

procedure TfmMenuEditor.FormDestroy(Sender: TObject);
begin
  PropertyDesigner:=nil;
  SaveToIni;
end;

procedure TfmMenuEditor.FormCreate(Sender: TObject);
begin
  NewLeft:=Screen.width div 2-Width div 2;
  NewTop:=Screen.Height div 2-Height div 2;
  NewWidth:=Width;
  NewHeight:=Height;
  LoadFromIni;
end;

procedure TfmMenuEditor.ForcedNotification(AForm: TCustomForm;
                         APersistent: TPersistent; Operation: TOperation);
begin
   case Operation of
      opInsert:;
      opRemove:begin
         if ObjectEdit=APersistent then
            FreeAndNil(fmMenuEditor);
      end;
   end;
end;


{ TMenuItemProperty }

function TMenuItemProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paDialog]- [paSubProperties]-[paMultiSelect];
end;

procedure TMenuItemProperty.Initialize;
begin
  inherited;
end;

procedure TMenuItemProperty.Edit;
var
  fm: TfmMenuEditor;
  Comp: TPersistent;
begin
  fm:=fmMenuEditor;
  if fm=nil then
   fm:=TfmMenuEditor.Create(nil);
  fm.isSetParam:=true;
  Comp:= GetComponent(0);
  fm.ObjectEdit:=Comp;
  if Comp is TComponent then begin
   fm.SetCaption(TComponent(Comp));
  end else begin
   fm.SetCaption(nil);
  end;
  fm.PropertyDesigner:=Pointer(Designer);
  fm.FillTreeFromMenuItem(TMenuItem(GetOrdValue));
  fm.ActiveControl := fm.TV;
  fm.show;
  fm.BringToFront;
  fmMenuEditor:=fm;
  fm.Tv.Selected:=nil;
  fm.isSetParam:=false;
end;

destructor TMenuItemProperty.Destroy;
begin
  inherited;
end;

{ TMenuItemEditor }

procedure TMenuItemEditor.ExecuteVerb(Index: Integer);
begin
  case Index of
    0: Edit;
  end;
end;

function TMenuItemEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Ёлементы';
  else Result := '';
  end;
end;

function TMenuItemEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

procedure TMenuItemEditor.EditProperty(PropertyEditor: TPropertyEditor;
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

procedure TfmMenuEditor.tbAddClick(Sender: TObject);
var
  nd,ndView: TTreeNode;
  mi,miParent: TMenuItem;
begin
  if not Check then exit;

  nd:=TV.Selected;
  if nd=nil then
    miParent:=TMenuItem(FMenuItem)
  else begin
    if nd.Parent=nil then
      miParent:=TMenuItem(FMenuItem)
    else
      miParent:=nd.Parent.Data;
  end;  

  mi:=TMenuItem.Create(IFormDesigner(PropertyDesigner).Form);
  mi.Name:=IFormDesigner(PropertyDesigner).UniqueName(TMenuItem.ClassName);
  mi.Caption:=mi.Name;
  miParent.Add(mi);
  ndView:=TV.Items.AddObject(nd,mi.Name,mi);
  ViewNode(ndView);
  ndView.Selected:=true;
  ndView.MakeVisible;
  ndView.EditText;
end;

procedure TfmMenuEditor.tbAddChildClick(Sender: TObject);
var
  nd,ndView: TTreeNode;
  mi,miParent: TMenuItem;
begin
  if not Check then exit;

  nd:=TV.Selected;
  if nd=nil then
    miParent:=TMenuItem(FMenuItem)
  else
    miParent:=nd.Data;

  mi:=TMenuItem.Create(IFormDesigner(PropertyDesigner).Form);
  mi.Name:=IFormDesigner(PropertyDesigner).UniqueName(TMenuItem.ClassName);
  mi.Caption:=mi.Name;
  miParent.Add(mi);
  ndView:=TV.Items.AddChildObject(nd,mi.Name,mi);
  ViewNode(ndView);
  ndView.Selected:=true;
  ndView.MakeVisible;
  ndView.EditText;
end;

procedure TfmMenuEditor.tbChangeClick(Sender: TObject);
var
  nd: TTreeNode;
begin
  if not Check then exit;
  nd:=TV.Selected;
  if nd=nil then exit;
  nd.EditText;
end;

procedure TfmMenuEditor.tbDeleteClick(Sender: TObject);
var
  nd: TTreeNode;
begin
  if not Check then exit;
  nd:=TV.Selected;
  if nd=nil then exit;
  TMenuItem(nd.Data).Free;
  nd.Delete;
  IFormDesigner(PropertyDesigner).Modified;
end;

procedure TfmMenuEditor.tbExpandClick(Sender: TObject);
begin
  if not Check then exit;
  TV.FullExpand;
end;

procedure TfmMenuEditor.tbCollapseClick(Sender: TObject);
begin
  if not Check then exit;
  TV.FullCollapse;
end;

procedure TfmMenuEditor.FillPopupMenu;
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

procedure TfmMenuEditor.pmTVPopup(Sender: TObject);
begin
  FillPopupMenu;
end;

procedure TfmMenuEditor.tbUpClick(Sender: TObject);
var
  nd: TTreeNode;
  ndPrev: TTreeNode;
  miParent: TMenuItem;
begin
 if not Check then exit;
 TV.Items.BeginUpdate;
 try
  nd:=TV.Selected;
  if nd=nil then exit;
  ndPrev:=nd.getPrevSibling;
  if ndPrev=nil then exit;
  if nd.Parent=nil then
   miParent:=TMenuItem(FMenuItem)
  else miParent:=nd.Parent.Data;
  miParent.Remove(nd.data);
  nd.MoveTo(ndPrev,naInsert);
  if ndPrev.Parent=nil then
   miParent:=TMenuItem(FMenuItem)
  else miParent:=ndPrev.Parent.Data;
  miParent.Insert(TMenuItem(ndPrev.Data).MenuIndex,TMenuItem(nd.data));
 finally
  TV.Items.EndUpdate;
 end; 
end;

procedure TfmMenuEditor.tbDownClick(Sender: TObject);
var
  nd: TTreeNode;
  ndNext: TTreeNode;
  miParent: TMenuItem;
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
   if nd.Parent=nil then
    miParent:=TMenuItem(FMenuItem)
   else miParent:=nd.Parent.Data;
   miParent.Remove(nd.data);
   nd.MoveTo(ndNext,naAdd);
   if ndNext.Parent=nil then
    miParent:=TMenuItem(FMenuItem)
   else miParent:=ndNext.Parent.Data;
   miParent.Add(TMenuItem(nd.data));
  end else begin
   if nd.Parent=nil then
    miParent:=TMenuItem(FMenuItem)
   else miParent:=nd.Parent.Data;
   miParent.Remove(nd.data);
   nd.MoveTo(ndNext,naInsert);
   if ndNext.Parent=nil then
    miParent:=TMenuItem(FMenuItem)
   else miParent:=ndNext.Parent.Data;
   miParent.Insert(TMenuItem(ndNext.Data).MenuIndex,TMenuItem(nd.data));
  end;
 finally
  TV.Items.EndUpdate;
 end; 
end;

procedure TfmMenuEditor.TVClick(Sender: TObject);
begin
  ViewNode(TV.Selected);
end;

end.


