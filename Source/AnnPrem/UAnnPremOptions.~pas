unit UAnnPremOptions;

interface

{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls, StdCtrls, Buttons, IBServices, CheckLst,
  menus, ImgList, Grids, IBQuery, IBDatabase;

type
  TfmOptions = class(TForm)
    pc: TPageControl;
    tsSrvImport: TTabSheet;
    pnSrvImport: TPanel;
    chbImportSelectInvalidChar: TCheckBox;
    meImportValidChars: TMemo;
    LabelFormat: TLabel;
    meFormat: TMemo;
    CheckBoxDelNextChar: TCheckBox;
    CheckBoxAutoTranslateRegion: TCheckBox;
    CheckBoxUseOriginalText: TCheckBox;
    procedure FormCreate(Sender: TObject);
  private
  public
    procedure LoadFromIni(OptionHandle: THandle);
    procedure SaveToIni(OptionHandle: THandle);
  end;

var
  fmOptions: TfmOptions;

implementation


uses UMainUnited, UAnnPremCode, UAnnPremData;

{$R *.DFM}

procedure TfmOptions.FormCreate(Sender: TObject);
begin
  Left:=-1000;
  Top:=-1000;

  LoadFromIni(OPTION_INVALID_HANDLE);
end;

procedure TfmOptions.LoadFromIni;
begin
  if (OptionHandle=hOptionImport)or(OptionHandle=OPTION_INVALID_HANDLE) then begin
    chbImportSelectInvalidChar.Checked:=ReadParam(ConstSectionOptions,chbImportSelectInvalidChar.Name,chbImportSelectInvalidChar.Checked);
    meImportValidChars.Lines.Text:=HexStrToStr(ReadParam(ConstSectionOptions,meImportValidChars.Name,StrToHexStr(meImportValidChars.Lines.Text)));
    meFormat.Lines.Text:=HexStrToStr(ReadParam(ConstSectionOptions,meFormat.Name,StrToHexStr(meFormat.Lines.Text)));
    CheckBoxDelNextChar.Checked:=ReadParam(ConstSectionOptions,CheckBoxDelNextChar.Name,CheckBoxDelNextChar.Checked);
    CheckBoxAutoTranslateRegion.Checked:=ReadParam(ConstSectionOptions,CheckBoxAutoTranslateRegion.Name,CheckBoxAutoTranslateRegion.Checked);
    CheckBoxUseOriginalText.Checked:=ReadParam(ConstSectionOptions,CheckBoxUseOriginalText.Name,CheckBoxUseOriginalText.Checked);
  end;
end;

procedure TfmOptions.SaveToIni;
begin
  if (OptionHandle=hOptionImport)or(OptionHandle=OPTION_INVALID_HANDLE) then begin
    WriteParam(ConstSectionOptions,chbImportSelectInvalidChar.Name,chbImportSelectInvalidChar.Checked);
    WriteParam(ConstSectionOptions,meImportValidChars.Name,StrToHexStr(meImportValidChars.Lines.Text));
    WriteParam(ConstSectionOptions,meFormat.Name,StrToHexStr(meFormat.Lines.Text));
    WriteParam(ConstSectionOptions,CheckBoxDelNextChar.Name,CheckBoxDelNextChar.Checked);
    WriteParam(ConstSectionOptions,CheckBoxAutoTranslateRegion.Name,CheckBoxAutoTranslateRegion.Checked);
    WriteParam(ConstSectionOptions,CheckBoxUseOriginalText.Name,CheckBoxUseOriginalText.Checked);
  end;

end;


end.
