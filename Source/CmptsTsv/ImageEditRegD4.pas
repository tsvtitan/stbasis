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
                       Thats it. Tested with Delphi 4, but should work with
                       any version that has TImageList.

****************************************************************************}
unit ImageEditRegD4;

interface

uses DsgnIntf, Forms;

type
 TActionImageIndexEditor = class(TIntegerProperty)
 public
  function GetAttributes: TPropertyAttributes; override;
  procedure Edit; override;
 end;

type
 TCoolBandImageIndexEditor = class(TIntegerProperty)
 public
  function GetAttributes: TPropertyAttributes; override;
  procedure Edit; override;
 end;

type
 TMenuImageIndexEditor = class(TIntegerProperty)
 public
  function GetAttributes: TPropertyAttributes; override;
  procedure Edit; override;
 end;

 TTabSheetImageIndexEditor = class(TIntegerProperty)
 public
  function GetAttributes: TPropertyAttributes; override;
  procedure Edit; override;
 end;

 TToolButtonImageIndexEditor = class(TIntegerProperty)
 public
  function GetAttributes: TPropertyAttributes; override;
  procedure Edit; override;
 end;

procedure Register;

implementation

uses SysUtils, Messages, ActnList, ImgList, Controls, TypInfo,
    Dialogs, ImageEditMainD4, Menus, comctrls;

{******** TAction Editor ************************************}

function TActionImageIndexEditor.GetAttributes: TPropertyAttributes;
begin
 Result := [paDialog, paMultiSelect]
end;

procedure TActionImageIndexEditor.Edit;
var
  Item: TAction;
  Images: TCustomImageList;
begin
//Get Action of ImageIndex
  Item := TAction(GetComponent(0));
//Get ImageList of TActionlist of this TAction
  Images := Item.ActionList.Images;
  if Images = nil then
    MessageDlg('Image List not assigned!', mtInformation, [mbOK], 0)
  else
    with tImageIndexForm.Create(application) do
      try
        ImageList1.AddImages(Images);
        FormCaptionName := 'TAction - '+Item.Name;
        ImageIndex := GetOrdValue;
        if ShowModal = mrOk then
            SetOrdValue(ImageIndex);
      finally
        free;
      end;
end;

{******** TCoolband Editor ************************************}

function TCoolBandImageIndexEditor.GetAttributes: TPropertyAttributes;
begin
 Result := [paDialog, paMultiSelect]
end;

procedure TCoolBandImageIndexEditor.Edit;
var
  Item: TCoolBand;
  Images: TCustomImageList;
begin
//Get CoolBand of ImageIndex
  Item := TCoolBand(GetComponent(0));
//Get Imagelist of TCoolBar of this TCoolBand
  Images := tCoolBands(Item.Collection).CoolBar.Images;
  if Images = nil then
    MessageDlg('Image List not assigned!', mtInformation, [mbOK], 0)
  else
    with tImageIndexForm.Create(application) do
      try
        ImageList1.AddImages(Images);
        FormCaptionName := 'TCoolband - '+Item.Text;
        ImageIndex := GetOrdValue;
        if ShowModal = mrOk then
            SetOrdValue(ImageIndex);
      finally
        free;
      end;
end;

{******** TMenuItem Editor ************************************}

function TMenuImageIndexEditor.GetAttributes: TPropertyAttributes;
begin
 Result := [paDialog, paMultiSelect]
end;

procedure TMenuImageIndexEditor.Edit;
var
  Item: TMenuItem;
  Images: TCustomImageList;
begin
//Get MenuItem of ImageIndex
  Item := TMenuItem(GetComponent(0));
//Get Imagelist of TMenu of this TMenuItem
  Images := Item.GetParentMenu.Images;
  if Images = nil then
    MessageDlg('Image List not assigned!', mtInformation, [mbOK], 0)
  else
    with tImageIndexForm.Create(application) do
      try
        Item := TMenuItem(GetComponent(0));
        ImageList1.AddImages(Images);
        FormCaptionName := 'TMenuItem - '+Item.Name;
        ImageIndex := GetOrdValue;
        if ShowModal = mrOk then
            SetOrdValue(ImageIndex);
      finally
        free;
      end;
end;

{******** TTabSheet Editor ************************************}

function TTabSheetImageIndexEditor.GetAttributes: TPropertyAttributes;
begin
 Result := [paDialog, paMultiSelect]
end;

procedure TTabSheetImageIndexEditor.Edit;
var
  Item: TTabSheet;
  Images: TCustomImageList;
begin
//Get TabSheet of ImageIndex
  Item := TTabSheet(GetComponent(0));
//Get Imagelist of TPageControl of this TTabSheet
  Images := Item.PageControl.Images;
  if Images = nil then
    MessageDlg('Image List not assigned!', mtInformation, [mbOK], 0)
  else
    with tImageIndexForm.Create(application) do
      try
        ImageList1.AddImages(Images);
        FormCaptionName := 'TTabSheet - '+Item.Name;
        ImageIndex := GetOrdValue;
        if ShowModal = mrOk then
            SetOrdValue(ImageIndex);
      finally
        free;
      end;
end;

{******** TToolButton Editor ************************************}

function TToolButtonImageIndexEditor.GetAttributes: TPropertyAttributes;
begin
 Result := [paDialog, paMultiSelect]
end;

procedure TToolButtonImageIndexEditor.Edit;
var
  Item: TToolButton;
  Images: TCustomImageList;
begin
//Get ToolButton of ImageIndex
  Item := TToolbutton(GetComponent(0));
//Get Imagelist of TToolBar of this TToolButton
  Images := tToolBar(Item.Parent).Images;
  if Images = nil then
    MessageDlg('Image List not assigned!', mtInformation, [mbOK], 0)
  else
    with tImageIndexForm.Create(application) do
      try
        ImageList1.AddImages(Images);
        FormCaptionName := 'TToolButton - '+Item.Name;
        ImageIndex := GetOrdValue;
        if ShowModal = mrOk then
            SetOrdValue(ImageIndex);
      finally
        free;
      end;
end;

{******** Register Editors ************************************}

procedure Register;
begin
  RegisterPropertyEditor(TypeInfo(Integer), TAction, 'ImageIndex', TActionImageIndexEditor);
  RegisterPropertyEditor(TypeInfo(Integer), TCoolBand, 'ImageIndex', TCoolBandImageIndexEditor);
  RegisterPropertyEditor(TypeInfo(Integer), TMenuItem, 'ImageIndex', TMenuImageIndexEditor);
  RegisterPropertyEditor(TypeInfo(Integer), TTabSheet, 'ImageIndex', TTabSheetImageIndexEditor);
  RegisterPropertyEditor(TypeInfo(Integer), TToolButton, 'ImageIndex', TToolButtonImageIndexEditor);
end;

end.