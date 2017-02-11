unit tsvListEdit;

interface

{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls, Menus, DsgnIntf, ImgList, ToolWin, StdCtrls;

type
  TfmListEditor = class(TForm)
    pnTV: TPanel;
    pmLV: TPopupMenu;
    LV: TListView;
    pntlBar: TPanel;
    tlBar: TToolBar;
    tbAdd: TToolButton;
    tbDelete: TToolButton;
    tbUp: TToolButton;
    ToolButton1: TToolButton;
    tbDown: TToolButton;
    il: TImageList;
    grbProps: TGroupBox;
    lbImageIndex: TLabel;
    lbStateIndex: TLabel;
    edImageIndex: TEdit;
    edStateIndex: TEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TVEdited(Sender: TObject; Node: TTreeNode; var S: String);
    procedure TVDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LVCustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure LVDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure LVEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure LVClick(Sender: TObject);
    procedure LVKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure tbAddClick(Sender: TObject);
    procedure tbDeleteClick(Sender: TObject);
    procedure pmLVPopup(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure tbUpClick(Sender: TObject);
    procedure tbDownClick(Sender: TObject);
    procedure edImageIndexEnter(Sender: TObject);
    procedure edImageIndexExit(Sender: TObject);
  private
    NewLeft,NewTop,NewWidth,NewHeight: Integer;
    FListItems: TListItems;
    procedure ViewItem(li: TListItem);
    function Check: Boolean;
    procedure LoadFromIni;
    procedure SaveToIni;
    procedure FillPopupMenu;
    procedure UpdateCaptions;
    procedure SetProps;
    procedure UnSelectAll;
  public
    ObjectEdit: TObject;
    isSetParam: Boolean;
    PropertyDesigner: Pointer;
    procedure SetCaption(AComponent: TComponent);
    procedure FillListFromListItems(ListItems: TListItems);
    procedure ForcedNotification(AForm: TCustomForm;
              APersistent: TPersistent; Operation: TOperation);
  end;

  TListItemProperty = class(TClassProperty)
  private
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
    destructor Destroy; override;
  end;

  TListItemEditor = class(TDefaultEditor)
    procedure EditProperty(PropertyEditor: TPropertyEditor;
      var Continue, FreeEditor: Boolean); override;
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;


var
  fmListEditor: TfmListEditor;

implementation

uses {UComponents, }UCmptsTsvData, UCmptsTsvCode, UMainUnited,
  tsvCollectionEdit;

{$R *.DFM}

const
  ConstItemCaption='Элемент';

{ TfmCollectionEditor }

procedure TfmListEditor.LoadFromIni;
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


procedure TfmListEditor.SaveToIni;
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

procedure TfmListEditor.FillListFromListItems(ListItems: TListItems);
var
  i: Integer;
  li: TListItem;
begin
  if (FListItems=ListItems)and(ListItems<>nil) then begin
    exit;
  end;
  FListItems:=ListItems;
  LV.Items.BeginUpdate;
  try
   LV.Items.Clear;
   if FListItems<>nil then begin
     for i:=0 to FListItems.Count-1 do begin
       li:=LV.Items.Add;
       li.Caption:=FListItems.Item[i].Caption;
       li.Data:=FListItems.Item[i];
     end;
   end;
  finally
   LV.Items.EndUpdate;
  end;
end;

procedure TfmListEditor.SetCaption(AComponent: TComponent);
begin
  if AComponent<>nil then
   Caption:=Format(fmtSetCaption,['Редактор списков',AComponent.Name])
  else
   Caption:='Редактор списков';
end;

procedure TfmListEditor.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:=caHide;
end;

procedure TfmListEditor.LVCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);

  procedure DrawItem;
  var
    rt: Trect;
  begin
  //drBounds, drIcon, drLabel, drSelectBounds
    rt:=Item.DisplayRect(drIcon);
    with Sender.Canvas do begin
     brush.Style:=bsSolid;
     brush.Color:=clBtnFace;
     InflateRect(rt,0,-1);
     FillRect(rt);
    end;
  end;

begin
   If Item=sender.Selected then begin
     if not(cdsSelected in State)then
      DrawItem;
   end;
end;

procedure TfmListEditor.TVEdited(Sender: TObject; Node: TTreeNode;
  var S: String);
begin
  if not Check then exit;
  if node=nil then exit;
  if Node.Data=nil then exit;
  TListItem(Node.Data).Caption:=S;
  IFormDesigner(PropertyDesigner).Modified;
end;

procedure TfmListEditor.UnSelectAll;
var
    i: Integer;
begin
    for i:=0 to LV.Items.Count-1 do
      LV.Items[i].Selected:=false;
end;

procedure TfmListEditor.ViewItem(li: TListItem);
begin
  if isSetParam then exit;
  if not Check then exit;
  SetProps;
  if li<>nil then begin
    IFormDesigner(PropertyDesigner).Modified;
  end else begin
    IFormDesigner(PropertyDesigner).Modified;
  end;
end;

function TfmListEditor.Check: Boolean;
begin
  Result:=false;
  if fmListEditor=nil then exit;
  if PropertyDesigner=nil then exit;
  Result:=true;
end;

procedure TfmListEditor.TVDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept:=false;
  if Sender=Source then begin
    Accept:=true;
  end;
end;

procedure TfmListEditor.LVDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept:=false;
  if Sender=Source then begin
    Accept:=true;
  end;
end;

procedure TfmListEditor.LVEndDrag(Sender, Target: TObject; X,
  Y: Integer);
var
  pt: TPoint;
  li: TListItem;
  liNew: TListItem;
  FSelItem, FCurItem: TListItem;
begin
 if (Target=LV) then begin
  LV.Items.BeginUpdate;
  try
   FSelItem:=LV.Selected;
   FCurItem:=LV.GetItemAt(X,Y);
   GetCursorPos(pt);
   if FSelItem=nil then exit;
   if FCurItem=nil then exit;

   li:=LV.Items.Insert(FCurItem.Index);
   li.Assign(FSelItem);

   liNew:=FListItems.Insert(TListItem(FCurItem.Data).Index);
   liNew.Assign(TCollectionItem(FSelItem.Data));
   li.Data:=liNew;

   FListItems.Delete(TListItem(FSelItem.Data).Index);
   FSelItem.Delete;
  finally
   LV.Items.EndUpdate;
  end;
  UpdateCaptions;
 end;
end;

procedure TfmListEditor.FormDestroy(Sender: TObject);
begin
  PropertyDesigner:=nil;
  SaveToIni;
end;

procedure TfmListEditor.FormCreate(Sender: TObject);
begin
  NewLeft:=Screen.width div 2-Width div 2;
  NewTop:=Screen.Height div 2-Height div 2;
  NewWidth:=Width;
  NewHeight:=Height;
  LoadFromIni;
end;

procedure TfmListEditor.ForcedNotification(AForm: TCustomForm;
                         APersistent: TPersistent; Operation: TOperation);
begin
   case Operation of
      opInsert:;
      opRemove:begin
         if ObjectEdit=APersistent then
            FreeAndNil(fmListEditor);
      end;
   end;
end;



procedure TfmListEditor.LVClick(Sender: TObject);
begin
   ViewItem(LV.Selected);
end;

procedure TfmListEditor.LVKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   ViewItem(LV.Selected);
end;

procedure TfmListEditor.tbAddClick(Sender: TObject);
var
  liView: TListItem;
  liNew: TListItem;
begin
  if not Check then exit;

  liNew:=FListItems.Add;
  liNew.Caption:=ConstItemCaption+inttostr(FListItems.Count-1);

  liView:=LV.Items.Add;
  liView.Caption:=liNew.Caption;
  liView.Data:=liNew;

  UnSelectAll;
  liView.Selected:=true;
  liView.MakeVisible(true);
  ViewItem(liView);
end;

procedure TfmListEditor.tbDeleteClick(Sender: TObject);
var
  li,liincr: TListItem;
  i: Integer;
begin
  if not Check then exit;
  li:=LV.Selected;
  if li=nil then exit;
  if LV.SelCount>1 then begin
   LV.Items.BeginUpdate;
   try
    for i:=LV.Items.Count-1 downto 0 do begin
      liincr:=LV.Items.Item[i];
      if liincr.Selected then begin
        FListItems.Delete(TListItem(liincr.Data).Index);
        liincr.Delete;
      end;
    end;
   finally
    LV.Items.EndUpdate;
   end;
  end else begin
   FListItems.Delete(TListItem(li.Data).Index);
   li.Delete;
  end;
  UpdateCaptions;
  if LV.Items.Count>0 then begin
   li:=LV.Items[LV.Items.Count-1];
   UnSelectAll;
   li.Selected:=true;
   li.MakeVisible(true);
   ViewItem(li);
  end else
   ViewItem(nil);
end;

procedure TfmListEditor.FillPopupMenu;
var
  i: Integer;
  mi: TMenuItem;
  bt: TToolButton;
begin
 try
  pmLV.Items.Clear;
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
    pmLV.Items.Add(mi);
  end;
 finally

 end;
end;

procedure TfmListEditor.pmLVPopup(Sender: TObject);
begin
  FillPopupMenu;
end;

procedure TfmListEditor.UpdateCaptions;
var
  i: Integer;
  li: TListItem;
begin
  LV.Items.BeginUpdate;
  try
    for i:=0 to LV.Items.Count-1 do begin
      li:=LV.Items[i];
      li.Caption:=TListItem(li.Data).Caption;
    end;
  finally
    LV.Items.EndUpdate;
  end;
end;

procedure TfmListEditor.FormShow(Sender: TObject);
begin
  UpdateCaptions;
end;

procedure TfmListEditor.FormActivate(Sender: TObject);
begin
  UpdateCaptions;
end;

procedure TfmListEditor.tbUpClick(Sender: TObject);
var
  FSelItem, FCurItem: TListItem;
  li: TListItem;
  liNew: TListItem;
begin
  LV.Items.BeginUpdate;
  try
   FSelItem:=LV.Selected;
   if FSelItem=nil then exit;

   if (FSelItem.Index-1>=0) and (FSelItem.Index-1<=LV.Items.Count-1) then begin
    FCurItem:=LV.Items.Item[FSelItem.Index-1];
   end else FCurItem:=nil;

   if FCurItem=nil then exit;

   li:=LV.Items.Insert(FCurItem.Index);
   li.Assign(FSelItem);

   liNew:=FListItems.Insert(TListItem(FCurItem.Data).Index);
   liNew.Assign(TListItem(FSelItem.Data));
   li.Data:=liNew;

   FListItems.Delete(TListItem(FSelItem.Data).Index);
   FSelItem.Delete;

   UnSelectAll;
   li.Selected:=true;
   li.MakeVisible(true);
   ViewItem(li);
  finally
   LV.Items.EndUpdate;
  end;
  UpdateCaptions;
end;

procedure TfmListEditor.tbDownClick(Sender: TObject);
var
  FSelItem, FCurItem: TListItem;
  li: TListItem;
  liNew: TListItem;
begin
  LV.Items.BeginUpdate;
  try
   FSelItem:=LV.Selected;
   if FSelItem=nil then exit;

   if (FSelItem.Index+2>=0) and (FSelItem.Index+2<=LV.Items.Count-1) then begin
    FCurItem:=LV.Items.Item[FSelItem.Index+2];
   end else FCurItem:=nil;

   if FCurItem=nil then begin
    li:=LV.Items.Add;
    li.Assign(FSelItem);

    liNew:=FListItems.Add;
    liNew.Assign(TListItem(FSelItem.Data));
    li.Data:=liNew;

    FListItems.Delete(TListItem(FSelItem.Data).Index);
    FSelItem.Delete;

    UnSelectAll;
    li.Selected:=true;
    li.MakeVisible(true);
    ViewItem(li);

   end else begin
    li:=LV.Items.Insert(FCurItem.Index);
    li.Assign(FSelItem);

    liNew:=FListItems.Insert(TListItem(FCurItem.Data).Index);
    liNew.Assign(TListItem(FSelItem.Data));
    li.Data:=liNew;

    FListItems.Delete(TListItem(FSelItem.Data).Index);
    FSelItem.Delete;

    UnSelectAll;
    li.Selected:=true;
    li.MakeVisible(true);
    ViewItem(li);
   end;

  finally
   LV.Items.EndUpdate;
  end;
  UpdateCaptions;
end;

{ TListItemProperty }

function TListItemProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paDialog]- [paSubProperties]-[paMultiSelect];
end;

procedure TListItemProperty.Edit;
var
  fm: TfmListEditor;
  Comp: TPersistent;
begin
  fm:=fmListEditor;
  if fm=nil then
   fm:=TfmListEditor.Create(nil);
  fm.isSetParam:=true;
  Comp:= GetComponent(0);
  fm.ObjectEdit:=Comp;
  if Comp is TComponent then begin
   fm.SetCaption(TComponent(Comp));
  end else begin
   fm.SetCaption(nil);
  end;
  fm.PropertyDesigner:=Pointer(Designer);
  fm.FillListFromListItems(TListItems(GetOrdValue));
  fm.ActiveControl := fm.LV;
  fm.show;
  fm.BringToFront;
  fmListEditor:=fm;
  fm.LV.Selected:=nil;
  fm.isSetParam:=false;
end;

destructor TListItemProperty.Destroy;
begin
  inherited;
end;


procedure TfmListEditor.SetProps;
begin
  edImageIndexEnter(edImageIndex);
  edImageIndexEnter(edStateIndex);
end;


procedure TfmListEditor.edImageIndexEnter(Sender: TObject);
var
  ed: TEdit;
  li: TListItem;
  liNew: TListItem;
begin
  li:=LV.Selected;
  if li=nil then exit;
  liNew:=li.Data;
  if Sender is TEdit then begin
   ed:=TEdit(Sender);
   if ed=edImageIndex then begin
     ed.Text:=inttostr(liNew.ImageIndex);
   end;
   if ed=edStateIndex then begin
     ed.Text:=inttostr(liNew.StateIndex);
   end;
  end;
end;

procedure TfmListEditor.edImageIndexExit(Sender: TObject);
var
  ed: TEdit;
  li: TListItem;
  liNew: TListItem;
begin
  li:=LV.Selected;
  if li=nil then exit;
  liNew:=li.Data;
  if Sender is TEdit then begin
   ed:=TEdit(Sender);
   if ed=edImageIndex then begin
     if isInteger(ed.Text) then liNew.ImageIndex:=strtoint(ed.Text);
   end;
   if ed=edStateIndex then begin
     if isInteger(ed.Text) then liNew.StateIndex:=strtoint(ed.Text);
   end;
  end;
end;

{ TListItemEditor }

procedure TListItemEditor.ExecuteVerb(Index: Integer);
var
  ce: TCollectionEditor;
begin
  case Index of
    0: Edit;
    1: begin
      if Component is TListView then begin
        ce:=TCollectionEditor.Create(Component,Designer);
        try
         ce.Edit;
        finally
         ce.Free;
        end; 
      end;
    end;
  end;
end;

function TListItemEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Элементы';
    1: Result := 'Колонки';
  else Result := '';
  end;
end;

function TListItemEditor.GetVerbCount: Integer;
begin
  Result := 2;
end;

procedure TListItemEditor.EditProperty(PropertyEditor: TPropertyEditor;
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


end.
