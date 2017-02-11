unit tsvCollectionEdit;

interface

{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls, Menus, DsgnIntf, ImgList, ToolWin;

type
  TfmCollectionEditor = class(TForm)
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
  private
    NewLeft,NewTop,NewWidth,NewHeight: Integer;
    FCollection: TCollection;
    procedure ViewItem(li: TListItem);
    function Check: Boolean;
    procedure LoadFromIni;
    procedure SaveToIni;
    procedure FillPopupMenu;
    procedure UpdateCaptions;
    procedure UnSelectAll;
  public
    ObjectEdit: TObject;
    isSetParam: Boolean;
    PropertyDesigner: Pointer;
    procedure SetCaption(AComponent: TComponent);
    procedure FillListFromCollection(Collection: TCollection);
    procedure ForcedNotification(AForm: TCustomForm;
              APersistent: TPersistent; Operation: TOperation);
  end;


  TCollectionProperty = class(TClassProperty)
  private
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
    destructor Destroy; override;
  end;

  TCollectionEditor = class(TDefaultEditor)
    procedure EditProperty(PropertyEditor: TPropertyEditor;
      var Continue, FreeEditor: Boolean); override;
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;


var
  fmCollectionEditor: TfmCollectionEditor;

implementation

uses {UComponents, }UCmptsTsvData, UCmptsTsvCode, UMainUnited;

{$R *.DFM}

const
  ConstItemCaption='Элемент';


{ TfmCollectionEditor }

procedure TfmCollectionEditor.LoadFromIni;
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

procedure TfmCollectionEditor.SaveToIni;
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

procedure TfmCollectionEditor.FillListFromCollection(Collection: TCollection);
var
  i: Integer;
  li: TListItem;
begin
  if (FCollection=Collection)and(Collection<>nil) then begin
    exit;
  end;
  FCollection:=Collection;
  LV.Items.BeginUpdate;
  try
   LV.Items.Clear;
   if FCollection<>nil then begin
     for i:=0 to FCollection.Count-1 do begin
       li:=LV.Items.Add;
       li.Caption:=Inttostr(i)+' - '+FCollection.Items[i].DisplayName;
       li.Data:=FCollection.Items[i];
     end;
   end;  
  finally
   LV.Items.EndUpdate;
  end;
end;

procedure TfmCollectionEditor.SetCaption(AComponent: TComponent);
begin
  if AComponent<>nil then
   Caption:=Format(fmtSetCaption,['Редактор коллекций',AComponent.Name])
  else
   Caption:='Редактор коллекций';
end;

procedure TfmCollectionEditor.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:=caHide;
  ViewItem(nil);
end;

procedure TfmCollectionEditor.LVCustomDrawItem(Sender: TCustomListView;
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
{   If Item=sender.Selected then begin
     if not(cdsSelected in State)then
      DrawItem;
   end;          }
end;

procedure TfmCollectionEditor.TVEdited(Sender: TObject; Node: TTreeNode;
  var S: String);
begin
{  if not Check then exit;
  if node=nil then exit;
  if Node.Data=nil then exit;
  TMenuItem(Node.Data).Caption:=S;
  IFormDesigner(PropertyDesigner).Modified;}
end;

procedure TfmCollectionEditor.UnSelectAll;
var
    i: Integer;
begin
    for i:=0 to LV.Items.Count-1 do
      LV.Items[i].Selected:=false;
end;


procedure TfmCollectionEditor.ViewItem(li: TListItem);
begin
  if isSetParam then exit;
  if not Check then exit;
  if li<>nil then begin
    IFormDesigner(PropertyDesigner).SelectComponent(li.Data);
    IFormDesigner(PropertyDesigner).Modified;
  end else begin
    IFormDesigner(PropertyDesigner).SelectComponent(TPersistent(ObjectEdit));
    IFormDesigner(PropertyDesigner).Modified;
  end;
end;

function TfmCollectionEditor.Check: Boolean;
begin
  Result:=false;
  if FCollection=nil then exit;
  if PropertyDesigner=nil then exit;
  Result:=true;
end;

procedure TfmCollectionEditor.TVDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept:=false;
  if Sender=Source then begin
    Accept:=true;
  end;
end;


procedure TfmCollectionEditor.LVDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept:=false;
  if Sender=Source then begin
    Accept:=true;
  end;
end;

procedure TfmCollectionEditor.LVEndDrag(Sender, Target: TObject; X,
  Y: Integer);
var
  pt: TPoint;
  li: TListItem;
  ci: TCollectionItem;
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

   ci:=FCollection.Insert(TCollectionItem(FCurItem.Data).Index);
   ci.Assign(TCollectionItem(FSelItem.Data));
   li.Data:=ci;

   FCollection.Delete(TCollectionItem(FSelItem.Data).Index);
   FSelItem.Delete;
  finally
   LV.Items.EndUpdate;
  end;
  UpdateCaptions;
 end;
end;

procedure TfmCollectionEditor.FormDestroy(Sender: TObject);
begin
  PropertyDesigner:=nil;
  SaveToIni;
end;

procedure TfmCollectionEditor.FormCreate(Sender: TObject);
begin
  NewLeft:=Screen.width div 2-Width div 2;
  NewTop:=Screen.Height div 2-Height div 2;
  NewWidth:=Width;
  NewHeight:=Height;
  LoadFromIni;
end;

procedure TfmCollectionEditor.ForcedNotification(AForm: TCustomForm;
                         APersistent: TPersistent; Operation: TOperation);
begin
   case Operation of
      opInsert:;
      opRemove:begin
         if ObjectEdit=APersistent then
            FreeAndNil(fmCollectionEditor);
      end;
   end;
end;



procedure TfmCollectionEditor.LVClick(Sender: TObject);
begin
   ViewItem(LV.Selected);
end;

procedure TfmCollectionEditor.LVKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   ViewItem(LV.Selected);
end;

procedure TfmCollectionEditor.tbAddClick(Sender: TObject);
var
  liView: TListItem;
  ci: TCollectionItem;
begin
  if not Check then exit;

  ci:=FCollection.Add;

  liView:=LV.Items.Add;
  liView.Caption:=inttostr(FCollection.Count-1)+' - '+ci.DisplayName;
  liView.Data:=ci;

  UnSelectAll;
  liView.Selected:=true;
  liView.MakeVisible(true);
  ViewItem(liView);
end;

procedure TfmCollectionEditor.tbDeleteClick(Sender: TObject);
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
        FCollection.Delete(TCollectionItem(liincr.Data).Index);
        liincr.Delete;
      end;
    end;
   finally
    LV.Items.EndUpdate;
   end; 
  end else begin
   FCollection.Delete(TCollectionItem(li.Data).Index);
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

procedure TfmCollectionEditor.FillPopupMenu;
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

procedure TfmCollectionEditor.pmLVPopup(Sender: TObject);
begin
  FillPopupMenu;
end;

procedure TfmCollectionEditor.UpdateCaptions;
var
  i: Integer;
  li: TListItem;
begin
  LV.Items.BeginUpdate;
  try
    for i:=0 to LV.Items.Count-1 do begin
      li:=LV.Items[i];
      li.Caption:=Inttostr(i)+' - '+TCollectionItem(li.Data).DisplayName;
    end;
  finally
    LV.Items.EndUpdate;
  end;
end;

procedure TfmCollectionEditor.FormShow(Sender: TObject);
begin
  UpdateCaptions;
end;

procedure TfmCollectionEditor.FormActivate(Sender: TObject);
begin
  UpdateCaptions;
end;

procedure TfmCollectionEditor.tbUpClick(Sender: TObject);
var
  FSelItem, FCurItem: TListItem;
  li: TListItem;
  ci: TCollectionItem;
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

   ci:=FCollection.Insert(TCollectionItem(FCurItem.Data).Index);
   ci.Assign(TCollectionItem(FSelItem.Data));
   li.Data:=ci;

   FCollection.Delete(TCollectionItem(FSelItem.Data).Index);
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

procedure TfmCollectionEditor.tbDownClick(Sender: TObject);
var
  FSelItem, FCurItem: TListItem;
  li: TListItem;
  ci: TCollectionItem;
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

    ci:=FCollection.Add;
    ci.Assign(TCollectionItem(FSelItem.Data));
    li.Data:=ci;

    FCollection.Delete(TCollectionItem(FSelItem.Data).Index);
    FSelItem.Delete;

    UnSelectAll;
    li.Selected:=true;
    li.MakeVisible(true);
    ViewItem(li);
    
   end else begin
    li:=LV.Items.Insert(FCurItem.Index);
    li.Assign(FSelItem);

    ci:=FCollection.Insert(TCollectionItem(FCurItem.Data).Index);
    ci.Assign(TCollectionItem(FSelItem.Data));
    li.Data:=ci;

    FCollection.Delete(TCollectionItem(FSelItem.Data).Index);
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

{ TCollectionItemProperty }

function TCollectionProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paDialog]- [paSubProperties]-[paMultiSelect];
end;

procedure TCollectionProperty.Edit;
var
  fm: TfmCollectionEditor;
  Comp: TPersistent;
begin
  fm:=fmCollectionEditor;
  if fm=nil then
   fm:=TfmCollectionEditor.Create(nil);
  fm.isSetParam:=true;
  Comp:= GetComponent(0);
  fm.ObjectEdit:=Comp;
  if Comp is TComponent then begin
   fm.SetCaption(TComponent(Comp));
  end else begin
   fm.SetCaption(nil);
  end;
  fm.PropertyDesigner:=Pointer(Designer);
  fm.FillListFromCollection(TCollection(GetOrdValue));
  fm.ActiveControl := fm.LV;
  fm.show;
  fm.BringToFront;
  fmCollectionEditor:=fm;
  fm.LV.Selected:=nil;
  fm.isSetParam:=false;
end;

destructor TCollectionProperty.Destroy;
begin
  inherited;
end;

{ TCollectionItemEditor }

procedure TCollectionEditor.ExecuteVerb(Index: Integer);
begin
  case Index of
    0: Edit;
  end;
end;

function TCollectionEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Коллекции';
  else Result := '';
  end;
end;

function TCollectionEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

procedure TCollectionEditor.EditProperty(PropertyEditor: TPropertyEditor;
             var Continue, FreeEditor: Boolean);
var
  PropName: string;
begin
  PropName := PropertyEditor.GetName;
  if (CompareText(PropName, 'Panels') = 0)or
     (CompareText(PropName, 'Columns') = 0)or
     (CompareText(PropName, 'ItemsEx') = 0)or
     (CompareText(PropName, 'Bands') = 0) then begin
    PropertyEditor.Edit;
    Continue := False;
    FreeEditor:=false;
  end else
    inherited EditProperty(PropertyEditor, Continue, FreeEditor);
end;


end.
