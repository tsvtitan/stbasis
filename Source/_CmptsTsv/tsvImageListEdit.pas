unit tsvImageListEdit;

interface

{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls, Menus, DsgnIntf, ImgList, ToolWin, StdCtrls, Buttons,
  ExtDlgs;

type
  TfmImageListEditor = class(TForm)
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
    pnBottom: TPanel;
    bibOk: TButton;
    bibCancel: TButton;
    ilLocal: TImageList;
    opd: TOpenPictureDialog;
    spd: TSavePictureDialog;
    tbExport: TToolButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
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
    procedure tbExportClick(Sender: TObject);
    procedure LVMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormResize(Sender: TObject);
  private
    NewLeft,NewTop,NewWidth,NewHeight: Integer;
    procedure ViewItem(li: TListItem);
    procedure LoadFromIni;
    procedure SaveToIni;
    procedure FillPopupMenu;
    procedure UpdateCaptions;
    procedure UnSelectAll;
  public
    ObjectEdit: TObject;
    isSetParam: Boolean;
    procedure SetCaption(AComponent: TComponent);
    procedure FillListView;
  end;

  TImageListEditor = class(TDefaultEditor)
    procedure Edit; override;
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;


implementation

uses {UComponents, }UCmptsTsvData, UCmptsTsvCode, UMainUnited;

{$R *.DFM}

{ TfmImageListEditor }

procedure TfmImageListEditor.LoadFromIni;
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

procedure TfmImageListEditor.SaveToIni;
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

procedure TfmImageListEditor.FillListView;
var
  i: Integer;
  li: TListItem;
begin
  LV.Items.BeginUpdate;
  try
   LV.Items.Clear;
   for i:=0 to ilLocal.Count-1 do begin
     li:=LV.Items.Add;
     li.Caption:=inttostr(i);
     li.ImageIndex:=i;
   end;
  finally
   LV.Items.EndUpdate;
  end;
end;

procedure TfmImageListEditor.SetCaption(AComponent: TComponent);
begin
  if AComponent<>nil then
   Caption:=Format(fmtSetCaption,['Редактор списка картинок',AComponent.Name])
  else
   Caption:='Редактор списка картинок';
end;

procedure TfmImageListEditor.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:=caHide;
end;

procedure TfmImageListEditor.LVCustomDrawItem(Sender: TCustomListView;
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

procedure TfmImageListEditor.UnSelectAll;
var
    i: Integer;
begin
    for i:=0 to LV.Items.Count-1 do
     if LV.Items[i].Selected then
      LV.Items[i].Selected:=false;
end;

procedure TfmImageListEditor.ViewItem(li: TListItem);
begin
  if isSetParam then exit;
end;

procedure TfmImageListEditor.TVDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept:=false;
  if Sender=Source then begin
    Accept:=true;
  end;
end;

procedure TfmImageListEditor.LVDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept:=false;
  if Sender=Source then begin
    Accept:=true;
  end;
end;

procedure TfmImageListEditor.LVEndDrag(Sender, Target: TObject; X,
  Y: Integer);
var
  pt: TPoint;
  li: TListItem;
  FSelItem, FCurItem: TListItem;
  ind: Integer;
begin
 if (Target=LV) then begin
  LV.Items.BeginUpdate;
  try
   FSelItem:=LV.Selected;
   FCurItem:=LV.GetItemAt(X,Y);
   GetCursorPos(pt);
   if FSelItem=nil then exit;
   if FCurItem=nil then exit;

   ind:=FCurItem.Index;
   ilLocal.Move(FSelItem.Index,ind);

   li:=LV.Items.Insert(FCurItem.Index);
   li.Assign(FSelItem);
   li.Caption:=inttostr(ind);
   li.ImageIndex:=ind;

   FSelItem.Delete;

   UnSelectAll;
   li.Selected:=true;
   LV.Arrange(arAlignLeft);
   li.MakeVisible(true);
   ViewItem(li);

  finally
   LV.Items.EndUpdate;
  end;
  UpdateCaptions;
 end;
end;

procedure TfmImageListEditor.FormDestroy(Sender: TObject);
begin
  SaveToIni;
end;

procedure TfmImageListEditor.FormCreate(Sender: TObject);
begin
  NewLeft:=Screen.width div 2-Width div 2;
  NewTop:=Screen.Height div 2-Height div 2;
  NewWidth:=Width;
  NewHeight:=Height;
  LoadFromIni;
  LV.WorkAreas.Clear;

end;

procedure TfmImageListEditor.LVClick(Sender: TObject);
begin
   ViewItem(LV.Selected);
end;

procedure TfmImageListEditor.LVKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   ViewItem(LV.Selected);
end;

procedure TfmImageListEditor.tbAddClick(Sender: TObject);
var
  liView: TListItem;
  i: Integer;
  pc: TPicture;
  ind: Integer;
  Mask,bmp: TBitmap;
begin
 try
  if not opd.Execute then exit;
  liView:=nil;

  Screen.Cursor:=crHourGlass;
  Mask:=TBitmap.Create;
  bmp:=TBitmap.Create;
  try
   for i:=0 to opd.Files.Count-1 do begin
    pc:=TPicture.Create;
    try
     pc.LoadFromFile(opd.Files.Strings[i]);
     ind:=-1;
     if pc.Graphic is TBitmap then begin
      bmp.Assign(pc.Graphic);
      bmp.Width:=ilLocal.Width;
      bmp.Height:=ilLocal.Height;
      Mask.Width:=bmp.Width;
      Mask.Height:=bmp.Height;
      Mask.Assign(bmp);
      bmp.TransparentColor:=bmp.Canvas.Pixels[0,0];
      Mask.Mask(bmp.TransparentColor);
      bmp.Transparent:=true;
      ind:=ilLocal.Add(bmp,Mask);
     end; 
     if pc.Graphic is TIcon then
      ind:=ilLocal.AddIcon(pc.Icon);

     if ind<>-1 then begin
      liView:=LV.Items.Add;
      liView.Caption:=inttostr(ind);
      liView.ImageIndex:=ind;
     end; 
    finally
     pc.Free;
    end;
   end;
  finally
    bmp.Free;
    Mask.Free;
    Screen.Cursor:=crDefault;
  end;

  if liView=nil then exit;

  UnSelectAll;
  liView.Selected:=true;
  liView.MakeVisible(true);
  ViewItem(liView);
 except
  {$IFDEF DEBUG} on E: Exception do begin
    Assert(false,E.message);
   end; 
  {$ENDIF}
 end; 
end;

procedure TfmImageListEditor.tbDeleteClick(Sender: TObject);
var
  li,liincr: TListItem;
  i: Integer;
begin
  li:=LV.Selected;
  if li=nil then exit;
  if LV.SelCount>1 then begin
   LV.Items.BeginUpdate;
   try
    for i:=LV.Items.Count-1 downto 0 do begin
      liincr:=LV.Items.Item[i];
      if liincr.Selected then begin
        ilLocal.Delete(liincr.ImageIndex);
        liincr.Delete;
      end;
    end;
   finally
    LV.Items.EndUpdate;
   end;
  end else begin
   ilLocal.Delete(li.ImageIndex);
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

procedure TfmImageListEditor.FillPopupMenu;
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

procedure TfmImageListEditor.pmLVPopup(Sender: TObject);
begin
  FillPopupMenu;
end;

procedure TfmImageListEditor.UpdateCaptions;
var
  i: Integer;
  li: TListItem;
begin
  LV.Items.BeginUpdate;
  try
    for i:=0 to LV.Items.Count-1 do begin
      li:=LV.Items[i];
      li.Caption:=inttostr(i);
      li.ImageIndex:=i;
    end;
  finally
    LV.Items.EndUpdate;
  end;
end;

procedure TfmImageListEditor.FormShow(Sender: TObject);
begin
  UpdateCaptions;
end;

procedure TfmImageListEditor.FormActivate(Sender: TObject);
begin
  UpdateCaptions;
end;

procedure TfmImageListEditor.tbUpClick(Sender: TObject);
var
  FSelItem, FCurItem: TListItem;
  li: TListItem;
begin
  LV.Items.BeginUpdate;
  try
   FSelItem:=LV.Selected;
   if FSelItem=nil then exit;

   if (FSelItem.Index-1>=0) and (FSelItem.Index-1<=LV.Items.Count-1) then begin
    FCurItem:=LV.Items.Item[FSelItem.Index-1];
   end else FCurItem:=nil;

   if FCurItem=nil then exit;

   ilLocal.Move(FSelItem.Index,FCurItem.Index);

   li:=LV.Items.Insert(FCurItem.Index);
   li.Assign(FSelItem);
   li.Caption:=inttostr(li.Index);
   li.ImageIndex:=li.Index;

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

procedure TfmImageListEditor.tbDownClick(Sender: TObject);
var
  FSelItem, FCurItem: TListItem;
  li: TListItem;
begin
  LV.Items.BeginUpdate;
  try
   FSelItem:=LV.Selected;
   if FSelItem=nil then exit;

   if (FSelItem.Index+2>=0) and (FSelItem.Index+2<=LV.Items.Count-1) then begin
    FCurItem:=LV.Items.Item[FSelItem.Index+2];
   end else FCurItem:=nil;

   if FCurItem=nil then begin

    ilLocal.Move(FSelItem.Index,LV.Items.Count-1);

    li:=LV.Items.Add;
    li.Assign(FSelItem);
    li.Caption:=inttostr(FSelItem.Index+1);
    li.ImageIndex:=FSelItem.Index+1;

    FSelItem.Delete;

    UnSelectAll;
    li.Selected:=true;
    li.MakeVisible(true);
    ViewItem(li);

   end else begin

    ilLocal.Move(FSelItem.Index,FCurItem.Index-1);
    
    li:=LV.Items.Insert(FCurItem.Index);
    li.Assign(FSelItem);
    li.Caption:=inttostr(li.Index);
    li.ImageIndex:=li.Index;

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

procedure EditImageListEditor(ImageList: TImageList);
begin
  with TfmImageListEditor.Create(Application) do
  try
    Screen.Cursor:=crHourGlass;
    try
     ilLocal.Assign(ImageList);
     SetCaption(ImageList);
     FillListView;
     ActiveControl := LV;
    finally
     Screen.Cursor:=crDefault;
    end; 
    case ShowModal of
      mrOk: ImageList.Assign(ilLocal);
    end;
  finally
    Free;
  end;
end;

{ TImageListEditor }

procedure TImageListEditor.Edit;
begin
  if Component is TImageList then begin
   EditImageListEditor(TImageList(Component));
  end;
end;

procedure TImageListEditor.ExecuteVerb(Index: Integer);
begin
  case Index of
    0: Edit;
  end;
end;

function TImageListEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Редактор списка картинок';
  else Result := '';
  end;
end;

function TImageListEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;


procedure TfmImageListEditor.tbExportClick(Sender: TObject);
var
  li: TListItem;
  pc: TPicture;
begin
  li:=LV.Selected;
  if li=nil then exit;
  if not spd.Execute then exit;
  pc:=TPicture.Create;
  try
    ilLocal.GetBitmap(li.Index,pc.Bitmap);
    pc.SaveToFile(spd.FileName);
  finally
    pc.Free;
  end;
  
end;

procedure TfmImageListEditor.LVMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
//  LV.Scroll(X,Y);
end;

procedure TfmImageListEditor.FormResize(Sender: TObject);
{var
  wa: TWorkArea;}
begin
{  LV.WorkAreas.Clear;
  wa:=LV.WorkAreas.Add;
  wa.Rect:=LV.ClientRect;   }
end;

end.
