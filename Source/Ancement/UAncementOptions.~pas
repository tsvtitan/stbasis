unit UAncementOptions;

interface

{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls, StdCtrls, Buttons, IBServices, CheckLst,
  menus, ImgList, Grids, IBQuery, IBDatabase;

type
  TfmOptions = class(TForm)
    pc: TPageControl;
    tsRptExport: TTabSheet;
    pnRptExport: TPanel;
    grbAddition: TGroupBox;
    lbBeforePhones: TLabel;
    edBeforePhones: TEdit;
    lbBeforeCP: TLabel;
    edBeforeCP: TEdit;
    Label5: TLabel;
    edAfterPhones: TEdit;
    lbAfterCP: TLabel;
    edAfterCP: TEdit;
    lbBeforeHP: TLabel;
    edBeforeHP: TEdit;
    lbAfterHP: TLabel;
    edAfterHP: TEdit;
    lbBeforeWP: TLabel;
    edBeforeWP: TEdit;
    lbAfterWP: TLabel;
    edAfterWP: TEdit;
    tsSrvImport: TTabSheet;
    pnSrvImport: TPanel;
    grbSrvImport: TGroupBox;
    lbBeforeTree: TLabel;
    lbAfterTree: TLabel;
    edBeforeTree: TEdit;
    edAfterTree: TEdit;
    lbPointerTree: TLabel;
    edPointerTree: TEdit;
    lbBeforeContact: TLabel;
    edBeforeContact: TEdit;
    lbBeforeHome: TLabel;
    edBeforeHome: TEdit;
    lbBeforeWork: TLabel;
    edBeforeWork: TEdit;
    tsRbkAnnouncement: TTabSheet;
    pnRbkAnnouncement: TPanel;
    chbAutoAdd: TCheckBox;
    chbAutoOpenTree: TCheckBox;
    grbExportFonts: TGroupBox;
    lbFontExportKeyWords: TLabel;
    edFontExportKeyWords: TEdit;
    bibFontExportKeyWords: TButton;
    lbFontExportText: TLabel;
    edFontExportText: TEdit;
    bibFontExportText: TButton;
    fd: TFontDialog;
    grbAnnouncementPhones: TGroupBox;
    lbAnnouncementNN: TLabel;
    edAnnouncementNN: TEdit;
    udAnnouncementNN: TUpDown;
    chbAnnouncementTreePath: TCheckBox;
    chbAnnouncementCheckRusWords: TCheckBox;
    chbAnnouncementDoStep95: TCheckBox;
    tsRptExportTreeHeading: TTabSheet;
    pnRptExportTreeHeading: TPanel;
    rgExportTreeHeading: TRadioGroup;
    chbImportWithOutKeyWords: TCheckBox;
    chbAnnouncementViewDouble: TCheckBox;
    lbPercentDouble: TLabel;
    edPercentDouble: TEdit;
    udPercentDouble: TUpDown;
    grbCaseExport: TGroupBox;
    chbExportWithImport: TCheckBox;
    chbExportNoText: TCheckBox;
    chbExportUpperKeyWords: TCheckBox;
    chbExportWordKeyWithDelim: TCheckBox;
    edExportWordKeyWithDelim: TEdit;
    chbAndText: TCheckBox;
    rbForEditing: TRadioButton;
    rbForSite: TRadioButton;
    chbImportLoadTranslateQuotas: TCheckBox;
    chbImportConvertWords: TCheckBox;
    chbImportSelectInvalidChar: TCheckBox;
    meImportValidChars: TMemo;
    chbExportWithAutoReplace: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure bibFontExportKeyWordsClick(Sender: TObject);
    procedure bibFontExportTextClick(Sender: TObject);
    procedure chbAnnouncementTreePathClick(Sender: TObject);
    procedure chbExportWordKeyWithDelimClick(Sender: TObject);
    procedure chbAnnouncementViewDoubleClick(Sender: TObject);
    procedure rbForEditingClick(Sender: TObject);
  private
  public
    procedure LoadFromIni(OptionHandle: THandle);
    procedure SaveToIni(OptionHandle: THandle);
  end;

var
  fmOptions: TfmOptions;

implementation


uses UMainUnited, UAncementCode, UAncementData, URBAnnouncement,
  URBAnnouncementDubl, tsvComponentFont;

{$R *.DFM}

procedure TfmOptions.FormCreate(Sender: TObject);
begin
  Left:=-1000;
  Top:=-1000;

  edFontExportKeyWords.Text:=edFontExportKeyWords.Font.Name;
  edFontExportText.Text:=edFontExportText.Font.Name;

  LoadFromIni(OPTION_INVALID_HANDLE);
end;

procedure TfmOptions.LoadFromIni;
var
  cf,cfOld: TComponentFont;
begin
  if (OptionHandle=hOptionReports)or(OptionHandle=OPTION_INVALID_HANDLE) then begin

    rbForEditing.Checked:=ReadParam(ConstSectionOptions,rbForEditing.Name,rbForEditing.Checked);
    rbForSite.Checked:=ReadParam(ConstSectionOptions,rbForSite.Name,rbForSite.Checked);

    edBeforePhones.Text:=ReadParam(ConstSectionOptions,edBeforePhones.Name,edBeforePhones.Text);
    edAfterPhones.Text:=ReadParam(ConstSectionOptions,edAfterPhones.Name,edAfterPhones.Text);
    edBeforeCP.Text:=ReadParam(ConstSectionOptions,edBeforeCP.Name,edBeforeCP.Text);
    edAfterCP.Text:=ReadParam(ConstSectionOptions,edAfterCP.Name,edAfterCP.Text);
    edBeforeHP.Text:=ReadParam(ConstSectionOptions,edBeforeHP.Name,edBeforeHP.Text);
    edAfterHP.Text:=ReadParam(ConstSectionOptions,edAfterHP.Name,edAfterHP.Text);
    edBeforeWP.Text:=ReadParam(ConstSectionOptions,edBeforeWP.Name,edBeforeWP.Text);
    edAfterWP.Text:=ReadParam(ConstSectionOptions,edAfterWP.Name,edAfterWP.Text);
    chbExportWithImport.Checked:=ReadParam(ConstSectionOptions,chbExportWithImport.Name,chbExportWithImport.Checked);
    chbExportNoText.Checked:=ReadParam(ConstSectionOptions,chbExportNoText.Name,chbExportNoText.Checked);
    chbExportUpperKeyWords.Checked:=ReadParam(ConstSectionOptions,chbExportUpperKeyWords.Name,chbExportUpperKeyWords.Checked);
    chbExportWordKeyWithDelim.Checked:=ReadParam(ConstSectionOptions,chbExportWordKeyWithDelim.Name,chbExportWordKeyWithDelim.Checked);
    chbAndText.Checked:=ReadParam(ConstSectionOptions,chbAndText.Name,chbAndText.Checked);
    chbExportWithAutoReplace.Checked:=ReadParam(ConstSectionOptions,chbExportWithAutoReplace.Name,chbExportWithAutoReplace.Checked);

    cf:=TComponentFont.Create(nil);
    cfOld:=TComponentFont.Create(nil);
    try
      cfOld.Font:=edFontExportKeyWords.Font;
      cf.SetFontFromHexStr(ReadParam(ConstSectionOptions,edFontExportKeyWords.Name,cfOld.GetFontAsHexStr));
      edFontExportKeyWords.Font.Assign(cf.Font);
      edFontExportKeyWords.Text:=edFontExportKeyWords.Font.Name;
      bibFontExportKeyWords.Height:=edFontExportKeyWords.Height;
      cfOld.Font:=edFontExportText.Font;
      cf.SetFontFromHexStr(ReadParam(ConstSectionOptions,edFontExportText.Name,cfOld.GetFontAsHexStr));
      edFontExportText.Font.Assign(cf.Font);
      edFontExportText.Text:=edFontExportText.Font.Name;
      edFontExportText.Height:=edFontExportText.Height;
    finally
     cfOld.Free;
     cf.Free;
    end;

  end;

  if (OptionHandle=hOptionImport)or(OptionHandle=OPTION_INVALID_HANDLE) then begin
    edBeforeTree.Text:=ReadParam(ConstSectionOptions,edBeforeTree.Name,edBeforeTree.Text);
    edAfterTree.Text:=ReadParam(ConstSectionOptions,edAfterTree.Name,edAfterTree.Text);
    edPointerTree.Text:=ReadParam(ConstSectionOptions,edPointerTree.Name,edPointerTree.Text);
    edBeforeContact.Text:=ReadParam(ConstSectionOptions,edBeforeContact.Name,edBeforeContact.Text);
    edBeforeHome.Text:=ReadParam(ConstSectionOptions,edBeforeHome.Name,edBeforeHome.Text);
    edBeforeWork.Text:=ReadParam(ConstSectionOptions,edBeforeWork.Name,edBeforeWork.Text);
    chbImportWithOutKeyWords.Checked:=ReadParam(ConstSectionOptions,chbImportWithOutKeyWords.Name,chbImportWithOutKeyWords.Checked);
    chbImportLoadTranslateQuotas.Checked:=ReadParam(ConstSectionOptions,chbImportLoadTranslateQuotas.Name,chbImportLoadTranslateQuotas.Checked);
    chbImportConvertWords.Checked:=ReadParam(ConstSectionOptions,chbImportConvertWords.Name,chbImportConvertWords.Checked);
    chbImportSelectInvalidChar.Checked:=ReadParam(ConstSectionOptions,chbImportSelectInvalidChar.Name,chbImportSelectInvalidChar.Checked);
    meImportValidChars.Lines.Text:=HexStrToStr(ReadParam(ConstSectionOptions,meImportValidChars.Name,StrToHexStr(meImportValidChars.Lines.Text)));
  end;

  if (OptionHandle=hOptionAnnouncement)or(OptionHandle=OPTION_INVALID_HANDLE) then begin
    chbAutoAdd.Checked:=ReadParam(ConstSectionOptions,chbAutoAdd.Name,chbAutoAdd.Checked);
    chbAutoOpenTree.Checked:=ReadParam(ConstSectionOptions,chbAutoOpenTree.Name,chbAutoOpenTree.Checked);
    udAnnouncementNN.Position:=ReadParam(ConstSectionOptions,udAnnouncementNN.Name,udAnnouncementNN.Position);
    chbAnnouncementTreePath.Checked:=ReadParam(ConstSectionOptions,chbAnnouncementTreePath.Name,chbAnnouncementTreePath.Checked);
    chbAnnouncementCheckRusWords.Checked:=ReadParam(ConstSectionOptions,chbAnnouncementCheckRusWords.Name,chbAnnouncementCheckRusWords.Checked);
    chbAnnouncementViewDouble.Checked:=ReadParam(ConstSectionOptions,chbAnnouncementViewDouble.Name,chbAnnouncementViewDouble.Checked);
    chbAnnouncementDoStep95.Checked:=ReadParam(ConstSectionOptions,chbAnnouncementDoStep95.Name,chbAnnouncementDoStep95.Checked);
    udPercentDouble.Position:=ReadParam(ConstSectionOptions,udPercentDouble.Name,udPercentDouble.Position);
  end;  

  if (OptionHandle=hOptionExportTreeHeading)or(OptionHandle=OPTION_INVALID_HANDLE) then begin
    rgExportTreeHeading.ItemIndex:=ReadParam(ConstSectionOptions,rgExportTreeHeading.Name,rgExportTreeHeading.ItemIndex);
  end;  

end;

procedure TfmOptions.SaveToIni;
var
  cf: TComponentFont;
begin
  if (OptionHandle=hOptionReports)or(OptionHandle=OPTION_INVALID_HANDLE) then begin

    WriteParam(ConstSectionOptions,rbForEditing.Name,rbForEditing.Checked);
    WriteParam(ConstSectionOptions,rbForSite.Name,rbForSite.Checked);

    WriteParam(ConstSectionOptions,edBeforePhones.Name,edBeforePhones.Text);
    WriteParam(ConstSectionOptions,edAfterPhones.Name,edAfterPhones.Text);
    WriteParam(ConstSectionOptions,edBeforeCP.Name,edBeforeCP.Text);
    WriteParam(ConstSectionOptions,edAfterCP.Name,edAfterCP.Text);
    WriteParam(ConstSectionOptions,edBeforeHP.Name,edBeforeHP.Text);
    WriteParam(ConstSectionOptions,edAfterHP.Name,edAfterHP.Text);
    WriteParam(ConstSectionOptions,edBeforeWP.Name,edBeforeWP.Text);
    WriteParam(ConstSectionOptions,edAfterWP.Name,edAfterWP.Text);
    WriteParam(ConstSectionOptions,chbExportWithImport.Name,chbExportWithImport.Checked);
    WriteParam(ConstSectionOptions,chbExportNoText.Name,chbExportNoText.Checked);
    WriteParam(ConstSectionOptions,chbExportUpperKeyWords.Name,chbExportUpperKeyWords.Checked);
    WriteParam(ConstSectionOptions,chbExportWordKeyWithDelim.Name,chbExportWordKeyWithDelim.Checked);
    WriteParam(ConstSectionOptions,chbAndText.Name,chbAndText.Checked);
    WriteParam(ConstSectionOptions,chbExportWithAutoReplace.Name,chbExportWithAutoReplace.Checked);

    cf:=TComponentFont.Create(nil);
    try
      cf.Font:=edFontExportKeyWords.Font;
      WriteParam(ConstSectionOptions,edFontExportKeyWords.Name,cf.GetFontAsHexStr);
      cf.Font:=edFontExportText.Font;
      WriteParam(ConstSectionOptions,edFontExportText.Name,cf.GetFontAsHexStr);
    finally
     cf.Free;
    end;
  end;

  if (OptionHandle=hOptionImport)or(OptionHandle=OPTION_INVALID_HANDLE) then begin
    WriteParam(ConstSectionOptions,edBeforeTree.Name,edBeforeTree.Text);
    WriteParam(ConstSectionOptions,edAfterTree.Name,edAfterTree.Text);
    WriteParam(ConstSectionOptions,edPointerTree.Name,edPointerTree.Text);
    WriteParam(ConstSectionOptions,edBeforeContact.Name,edBeforeContact.Text);
    WriteParam(ConstSectionOptions,edBeforeHome.Name,edBeforeHome.Text);
    WriteParam(ConstSectionOptions,edBeforeWork.Name,edBeforeWork.Text);
    WriteParam(ConstSectionOptions,chbImportWithOutKeyWords.Name,chbImportWithOutKeyWords.Checked);
    WriteParam(ConstSectionOptions,chbImportLoadTranslateQuotas.Name,chbImportLoadTranslateQuotas.Checked);
    WriteParam(ConstSectionOptions,chbImportConvertWords.Name,chbImportConvertWords.Checked);
    WriteParam(ConstSectionOptions,chbImportSelectInvalidChar.Name,chbImportSelectInvalidChar.Checked);
    WriteParam(ConstSectionOptions,meImportValidChars.Name,StrToHexStr(meImportValidChars.Lines.Text));
  end;

  if (OptionHandle=hOptionAnnouncement)or(OptionHandle=OPTION_INVALID_HANDLE) then begin
    WriteParam(ConstSectionOptions,chbAutoAdd.Name,chbAutoAdd.Checked);
    WriteParam(ConstSectionOptions,chbAutoOpenTree.Name,chbAutoOpenTree.Checked);
    WriteParam(ConstSectionOptions,udAnnouncementNN.Name,udAnnouncementNN.Position);
    WriteParam(ConstSectionOptions,chbAnnouncementTreePath.Name,chbAnnouncementTreePath.Checked);
    WriteParam(ConstSectionOptions,chbAnnouncementCheckRusWords.Name,chbAnnouncementCheckRusWords.Checked);
    WriteParam(ConstSectionOptions,chbAnnouncementViewDouble.Name,chbAnnouncementViewDouble.Checked);
    WriteParam(ConstSectionOptions,chbAnnouncementDoStep95.Name,chbAnnouncementDoStep95.Checked);
    WriteParam(ConstSectionOptions,udPercentDouble.Name,udPercentDouble.Position);
  end;  

  if (OptionHandle=hOptionExportTreeHeading)or(OptionHandle=OPTION_INVALID_HANDLE) then begin
    WriteParam(ConstSectionOptions,rgExportTreeHeading.Name,rgExportTreeHeading.ItemIndex);
  end;  

end;


procedure TfmOptions.bibFontExportKeyWordsClick(Sender: TObject);
begin
   fd.Font.Assign(edFontExportKeyWords.Font);
   if not fd.Execute then exit;
   edFontExportKeyWords.Font.Assign(fd.Font);
   edFontExportKeyWords.Text:=edFontExportKeyWords.Font.Name;
   bibFontExportKeyWords.Height:=edFontExportKeyWords.Height;
end;

procedure TfmOptions.bibFontExportTextClick(Sender: TObject);
begin
   fd.Font.Assign(edFontExportText.Font);
   if not fd.Execute then exit;
   edFontExportText.Font.Assign(fd.Font);
   edFontExportText.Text:=edFontExportText.Font.Name;
   bibFontExportText.Height:=edFontExportText.Height;
end;

procedure TfmOptions.chbAnnouncementTreePathClick(Sender: TObject);
begin
  if fmRBAnnouncement<>nil then begin
   fmRBAnnouncement.pnTreePath.Visible:=chbAnnouncementTreePath.Checked;
   fmRBAnnouncement.ShowingChanged;
  end;
  if fmRBAnnouncementDubl<>nil then begin
   fmRBAnnouncementDubl.pnTreePath.Visible:=chbAnnouncementTreePath.Checked;
   fmRBAnnouncementDubl.ShowingChanged;
  end;
end;

procedure TfmOptions.chbExportWordKeyWithDelimClick(Sender: TObject);
begin
  edExportWordKeyWithDelim.Color:=Iff(chbExportWordKeyWithDelim.Checked,clWindow,clBtnFace);
  edExportWordKeyWithDelim.Enabled:=chbExportWordKeyWithDelim.Checked;
  chbAndText.Checked:=iff(chbExportWordKeyWithDelim.Checked,chbAndText.Checked,false);
  chbAndText.Enabled:=chbExportWordKeyWithDelim.Checked;
end;

procedure TfmOptions.chbAnnouncementViewDoubleClick(Sender: TObject);
begin
  lbPercentDouble.Enabled:=chbAnnouncementViewDouble.Checked;
  edPercentDouble.Enabled:=chbAnnouncementViewDouble.Checked;
  edPercentDouble.Color:=Iff(chbAnnouncementViewDouble.Checked,clWindow,clBtnFace);
  udPercentDouble.Enabled:=chbAnnouncementViewDouble.Checked;
  if fmRBAnnouncement<>nil then begin
    fmRBAnnouncement.pnDouble.Visible:=chbAnnouncementViewDouble.Checked;
    fmRBAnnouncement.spl.Visible:=fmRBAnnouncement.pnDouble.Visible;
    fmRBAnnouncement.ShowingChanged;
    fmRBAnnouncement.MainqrAfterScroll(nil);
  end;
end;

procedure TfmOptions.rbForEditingClick(Sender: TObject);
begin
  chbExportWithImport.Enabled:=rbForEditing.Checked;
  chbExportNoText.Enabled:=rbForEditing.Checked;
  chbExportUpperKeyWords.Enabled:=rbForEditing.Checked;
  chbExportWordKeyWithDelim.Enabled:=rbForEditing.Checked;
  edExportWordKeyWithDelim.Enabled:=rbForEditing.Checked;
  chbAndText.Enabled:=rbForEditing.Checked;
end;

end.
