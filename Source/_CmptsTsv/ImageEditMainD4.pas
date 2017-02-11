{****************************************************************************
	Component   :  ImageEditRegD4.pas is a part of the ImageIndex Editor
                       that makes it easier to set the ImageIndex property of
                       TMenuItems, TAction, TCoolBand, TToolButton, and
                       TTabSheet components.  After installing these property
                       editors, double click (or click the edit button) of the
                       ImageIndex property of these components, and (if an Image
                       List is set for the owners) a window will open, containing
                       the images of the ImageList, so you can select the image
                       to use and it will fill in the ImageIndex property with the
                       number, from the ImageList, for that image.  This makes
                       it easier than trying to remeber the number of the image
                       in the list.

	Version     :  1.00

	Author      :  Rick Hollerich  e-mail: <rholleri@prairie.lakes.com>
																			<ldshih@freenet.edmonton.ab.ca>
	DISCLAIMER  :  ImageIndex Editor is distributed as freeware, without
                       warranties of any kind.  Use of this software is at
                       your own risk.

        Installation : Open ImageIndexEditD4.dpk, compile it and install it.
                       Thats it. Any ImageIndex property in the object inspector
                       should use these editors. If you find an ImageIndex
                       property I missed, let me know.  Tested with Delphi 4,
                       but should work with any version that has TImageList.

****************************************************************************}
unit ImageEditMainD4;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ComCtrls, ImgList, StdCtrls, ExtCtrls, Buttons;

type
  TImageIndexForm = class(TForm)
    Bevel1: TBevel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ComboBox1: TComboBox;
    Image1: TImage;
    ImageList1: TImageList;
    ListView1: TListView;
    Panel1: TPanel;
    procedure BitBtn2Click(Sender: TObject);
    procedure ComboBox1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
  private
    FFormCaptionName: string;
    FImageIndex: integer;
    procedure SetFormCaptionName(const Value: string);
    procedure SetImageIndex(const Value: integer);
    { Private declarations }
  public
    { Public declarations }
    property FormCaptionName: string read FFormCaptionName write SetFormCaptionName;
    property ImageIndex: integer read FImageIndex write SetImageIndex;
  end;

var
  ImageIndexForm: TImageIndexForm;

implementation

{$R *.DFM}

{ TImageIndexForm }

procedure TImageIndexForm.BitBtn2Click(Sender: TObject);
begin
  fImageIndex := -1;
  ModalResult := mrOK;
end;

procedure TImageIndexForm.ComboBox1Click(Sender: TObject);
begin
  with ComboBox1 do
    ListView1.ViewStyle := TViewStyle(Items.Objects[ItemIndex]);
end;

procedure TImageIndexForm.FormCreate(Sender: TObject);
begin
  fImageIndex := -1;
end;

procedure TImageIndexForm.FormShow(Sender: TObject);
var
  I: integer;
  ListItem: TListItem;
begin
  // Create a ListView item for each image in the ImageList
  with ListView1 do
  begin
    SmallImages := ImageList1;
    LargeImages := ImageList1;
    for I := 0 to ImageList1.Count - 1 do
    begin
      ListItem := Items.Add;
      Listitem.Caption := 'Image ' + IntToStr(I);
      ListItem.ImageIndex := I;
    end;
    // Add View styles and constants to the Combo Box
    ComboBox1.Items.AddObject('vsIcon', TObject(vsIcon));
    ComboBox1.Items.AddObject('vsList', TObject(vsList));
    ComboBox1.Items.AddObject('vsReport', TObject(vsReport));
    ComboBox1.Items.AddObject('vsSmallIcon', TObject(vsSmallIcon));
    // Display first item in the Combo Box
    ComboBox1.ItemIndex := 0;
    //Focus image in list
    if (fImageIndex < -1) or (fImageIndex > ImageList1.Count-1) then
      begin
        ListView1.Selected := nil;
        fImageIndex := -1;
      end
     else ListView1.Selected :=
            ListView1.Items.Item[fImageIndex];
  end;
end;

procedure TImageIndexForm.ListView1DblClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TImageIndexForm.ListView1SelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  if Selected then
    begin
      BitBtn1.Caption := 'Use '+ Item.Caption;
      BitBtn1.Enabled := true;
      ImageList1.GetIcon(Item.ImageIndex, Image1.Picture.Icon );
      fImageIndex := Item.ImageIndex;
    end;
end;

procedure TImageIndexForm.SetFormCaptionName(const Value: string);
begin
  FFormCaptionName := Value;
  Caption := Value+'.ImageIndex Property Selector';
end;

procedure TImageIndexForm.SetImageIndex(const Value: integer);
begin
  fImageIndex := Value;
end;

end.
