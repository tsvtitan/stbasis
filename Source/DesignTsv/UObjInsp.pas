unit UObjInsp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ZPropLst, ExtCtrls, ComCtrls, TypInfo, StdCtrls,
  rmTVComboBox, Menus, ImgList, tsvDesignForm, DsgnIntf;

type
  TfmObjInsp = class(TForm)
    tbcPropMet: TTabControl;
    pmObj: TPopupMenu;
    ImageList1: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tbcPropMetChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FDSB: TDesignScrollBox;
    FHeightOk: Boolean;
    ObjInsp: TZPropList;
    ObjTV: TrmComboTreeView;
    FLastObj: TObject;
    procedure SetLastObj(Value: TOBject);
    procedure SetComponent(ct: TComponent);
    procedure WMSizing(var Message: TMessage); message WM_SIZING;
    procedure SetupHeight;
    function GetTreeViewName(ct: TComponent):string;
    procedure SetObjectOnTreeView(ct: TComponent);
    procedure ObjTVChanged(Sender: TObject; Node: TTreeNode);
    procedure ObjInspOnNewObject(Sender: TZPropList; OldObj, NewObj: TObject);
    procedure ObjInspOnChange(Sender: TZPropList; Prop: TPropertyEditor);
    function GetNodefromData(Data: Pointer): TTreeNode;
    procedure ChangeNameInTV(owner,ct: TComponent; NewName: string);
  public
    procedure SetDSB(DSB: TDesignScrollBox);
    procedure FillComboFromListForms(List: TList);
    property LastObj: TObject read FLastObj write SetLastObj;
  end;

var
  fmObjInsp: TfmObjInsp;

implementation

{$R *.DFM}

procedure TfmObjInsp.FormCreate(Sender: TObject);
var
  cls: TClass;
begin
  tbcPropMet.Align:=alClient;
  
  ObjTV:=TrmComboTreeView.Create(nil);
  ObjTV.Parent:=Self;
  ObjTV.Align:=alTop;
  ObjTV.DropDownHeight:=7*ObjTV.Height-5;
  ObjTV.OnChanged:=ObjTVChanged;
  ObjTV.Cursor:=crArrow;
  ObjTV.PopupMenu:=pmObj;
  ObjTV.HotTrack:=true;
  ObjTV.Expanded:=false;
  ObjTV.Images:=ImageList1;

  ObjInsp:=TZPropList.Create(nil);
  ObjInsp.Parent:=tbcPropMet;
  ObjInsp.Align:=alClient;
  ObjInsp.Translated:=false;
  ObjInsp.IntegralHeight:=false;
  ObjInsp.NewButtons:=true;
  ObjInsp.Filter:=tkProperties;
  ObjInsp.Sorted:=true;
  ObjInsp.OnNewObject:=ObjInspOnNewObject;
  ObjInsp.OnChange:=ObjInspOnChange;
  ObjInsp.TranslateList.Add('Action','Äà');
  ObjInsp.TranslateList.Add('Font','Øðèôò');
  ObjInsp.TranslateList.Add('fsBold','Æèðíûé');
  ObjInsp.TranslateList.Add('Left','Left');
  ObjInsp.TranslateList.Add('Color','Öâåò');
//  ObjInsp.RemoveList.AddObject('Style',TObject(Form1.ClassType));
  cls:=TButton;
  ObjInsp.RemoveList.AddObject('Style',TObject(cls));


  SetupHeight;
end;

procedure TfmObjInsp.FormDestroy(Sender: TObject);
begin
  ObjInsp.Free;
  ObjTV.Free;
end;

procedure TfmObjInsp.tbcPropMetChange(Sender: TObject);
begin
  case tbcPropMet.TabIndex of
    0: ObjInsp.Filter:=tkProperties;
    1: ObjInsp.Filter:=[tkMethod];
  end;
end;

procedure TfmObjInsp.ObjInspOnNewObject(Sender: TZPropList; OldObj, NewObj: TObject);
begin
  //
end;

function TfmObjInsp.GetNodefromData(Data: Pointer): TTreeNode;
var
  i: Integer;
  nd: TTreeNode;
begin
  Result:=nil;
  for i:=0 to ObjTV.Items.Count-1 do begin
    nd:=ObjTV.Items.Item[i];
    if nd.data=Data then begin
      result:=nd;
      exit;
    end; 
  end;
end;

procedure TfmObjInsp.ChangeNameInTV(owner,ct: TComponent; NewName: string);
begin

end;

procedure TfmObjInsp.ObjInspOnChange(Sender: TZPropList; Prop: TPropertyEditor);
var
  tmps: string;
begin
  tmps:=Prop.GetPropType.Name;
  if tmps='TComponentName' then begin
    ChangeNameInTV(TComponent(Sender.CurObj).Owner,
                   TComponent(Sender.CurObj),
                   Prop.GetName);
  end;
end;

procedure TfmObjInsp.WMSizing(var Message: TMessage);
var
  HRow, NewHeight, Diff: Integer;
  R: PRect;
begin
  exit;
  if FHeightOk then
  begin
    R := PRect(Message.LParam);
    HRow := ObjInsp.RowHeight;
    NewHeight := R.Bottom - R.Top;
    if NewHeight < 128 then NewHeight := 128;
    if HRow > 0 then
    begin
      Diff := NewHeight - Height;
      if Abs(Diff) <= HRow shr 1 then Diff := 0;
      NewHeight := Height + (Diff shl 1) div HRow * HRow;;
    end;

    if Message.WParam in [WMSZ_BOTTOM, WMSZ_BOTTOMLEFT, WMSZ_BOTTOMRIGHT] then
      R.Bottom := R.Top + NewHeight
    else
      R.Top := R.Bottom - NewHeight;
  end;
end;

procedure TfmObjInsp.SetupHeight;
var
  HRow, HOverhead: Integer;
begin
  HRow := ObjInsp.RowHeight;
  if HRow > 0 then
  begin
    HOverhead := Height - ObjInsp.ClientHeight;
    Height := HOverhead + ObjInsp.ClientHeight div HRow * HRow;
  end;
  FHeightOk := True;
end;

procedure TfmObjInsp.FillComboFromListForms(List: TList);

  procedure RecurseWinControl(wc: TWinControl; nd: TTreeNode);
  var
    i: Integer;
    ct: TComponent;
    ndNext: TTreeNode;
  begin
    for i:=0 to wc.ComponentCount-1 do begin
      ct:=wc.Components[i];
      if not (ct is TControl) then begin
        ndNext:=ObjTV.Items.AddChildObject(nd,GetTreeViewName(ct),ct);
        ndNext.ImageIndex:=1;
        ndNext.SelectedIndex:=1;
      end;
    end;
    for i:=0 to wc.ControlCount-1 do begin
      ct:=TControl(wc.Controls[i]);
      ndNext:=ObjTV.Items.AddChildObject(nd,GetTreeViewName(ct),ct);
      ndNext.ImageIndex:=2;
      ndNext.SelectedIndex:=2;
      if ct is TWinControl then begin
        RecurseWinControl(TWinControl(ct),ndNext);
      end;
    end;
  end;

var
  i: Integer;
  wc: TWinControl;
  nd: TTreeNode;
begin
 ObjTV.Items.BeginUpdate;
 try
  ObjTV.Items.Clear;
  for i:=0 to List.Count-1 do begin
    wc:=List.Items[i];
    nd:=ObjTV.Items.AddChildObject(nil,GetTreeViewName(wc),wc);
    nd.ImageIndex:=0;
    nd.SelectedIndex:=0;
    RecurseWinControl(wc,nd);
  end;
 finally
  ObjTV.Items.EndUpdate;
  ObjTV.FullExpand;
 end;
end;

function TfmObjInsp.GetTreeViewName(ct: TComponent):string;
begin
  Result:=ct.Name+': '+ct.Classname;
end;

procedure TfmObjInsp.SetObjectOnTreeView(ct: TComponent);
var
  i: Integer;
  nd: TTreeNode;
begin
  nd:=GetNodefromData(ct);
  if nd<>nil then begin
    nd.Selected:=true;
    nd.MakeVisible;
    ObjTV.SelectedNode:=nd;
  end;
end;

procedure TfmObjInsp.SetComponent(ct: TComponent);
begin
  SetObjectOnTreeView(ct);
  ObjInsp.CurObj:=ct;
  ObjInsp.SetFocus;
  FLastObj:=ObjInsp.CurObj;
end;

procedure TfmObjInsp.ObjTVChanged(Sender: TObject; Node: TTreeNode);
begin
   if Node<>nil then begin
     SetComponent(TComponent(Node.Data));
   end;
   ObjInsp.SetFocus;
end;

procedure TfmObjInsp.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_F2: begin
      if Shift=[ssCtrl] then begin
        ObjTV.DropDown;
      end;
    end;
  end;
end;

procedure TfmObjInsp.SetLastObj(Value: TOBject);
begin
  if FDSB=nil then exit;
{  FillComboFromListForms(FDSB.ListForms);
  if Value is TComponent then begin
   SetComponent(TComponent(Value));
  end;}
end;

procedure TfmObjInsp.SetDSB(DSB: TDesignScrollBox);
begin
  FDSB:=DSB;
end;

end.
