unit UPremisesTsvOptions;

interface

{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls, StdCtrls, Buttons, IBServices, CheckLst,
  menus, ImgList, Grids, IBQuery, IBDatabase, FileCtrl;

type
  TfmOptions = class(TForm)
    pc: TPageControl;
    tsPremises: TTabSheet;
    pnPremises: TPanel;
    grbExportFonts: TGroupBox;
    lbPhoneColumn: TLabel;
    edPhoneColumn: TEdit;
    bibPhoneColumn: TButton;
    fd: TFontDialog;
    tsRptPrice: TTabSheet;
    pnPrice: TPanel;
    GroupBox1: TGroupBox;
    Panel5: TPanel;
    Panel6: TPanel;
    bibReportDir: TButton;
    edReportDir: TEdit;
    chbUseSpecialTabOrderDel: TCheckBox;
    lbForDeleteTorecyled: TLabel;
    edForDeleteTorecyled: TEdit;
    btForDeleteTorecyled: TButton;
    lbMoveFromRecyled: TLabel;
    edMoveFromRecyled: TEdit;
    btMoveFromRecyled: TButton;
    lbSaleUnitPrice: TLabel;
    edSaleUnitPrice: TEdit;
    btSaleUnitPrice: TButton;
    lbLeaseUnitPrice: TLabel;
    edLeaseUnitPrice: TEdit;
    btLeaseUnitPrice: TButton;
    lbShareUnitPrice: TLabel;
    edShareUnitPrice: TEdit;
    btShareUnitPrice: TButton;
    tsImport: TTabSheet;
    pnImport: TPanel;
    chbCheckDoubleOnImport: TCheckBox;
    chbCheckDoubleOnEdit: TCheckBox;
    chbClearFilterOnEnter: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure bibPhoneColumnClick(Sender: TObject);
    procedure bibReportDirClick(Sender: TObject);
    procedure btForDeleteTorecyledClick(Sender: TObject);
    procedure edForDeleteTorecyledKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btMoveFromRecyledClick(Sender: TObject);
    procedure edMoveFromRecyledKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btSaleUnitPriceClick(Sender: TObject);
    procedure edSaleUnitPriceKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btLeaseUnitPriceClick(Sender: TObject);
    procedure edLeaseUnitPriceKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btShareUnitPriceClick(Sender: TObject);
    procedure edShareUnitPriceKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    procedure SetStatusByEdit(Edit: TEdit);
    procedure SetUnitPriceByEdit(Edit: TEdit);
  public
    procedure LoadFromIni(OptionHandle: THandle);
    procedure SaveToIni(OptionHandle: THandle);
  end;

var
  fmOptions: TfmOptions;

implementation


uses UMainUnited, UPremisesTsvCode, UPremisesTsvData, tsvComponentFont, tsvPathUtils;


{$R *.DFM}

procedure TfmOptions.FormCreate(Sender: TObject);
begin
  Left:=-1000;
  Top:=-1000;

  TControl(edReportDir).Align:=alClient;
  TControl(bibReportDir).Align:=alRight;

end;

procedure TfmOptions.LoadFromIni(OptionHandle: THandle);
var
  cf,cfOld: TComponentFont;
begin
  if (OptionHandle=hOptionPremises)or(OptionHandle=OPTION_INVALID_HANDLE) then begin
    cf:=TComponentFont.Create(nil);
    cfOld:=TComponentFont.Create(nil);
    try
      cfOld.Font:=edPhoneColumn.Font;
      cf.SetFontFromHexStr(ReadParam(ConstSectionOptions,edPhoneColumn.Name,cfOld.GetFontAsHexStr));
      edPhoneColumn.Font.Assign(cf.Font);
      edPhoneColumn.Text:=edPhoneColumn.Font.Name;
      bibPhoneColumn.Height:=edPhoneColumn.Height;
    finally
     cfOld.Free;
     cf.Free;
    end;

//    chbUseSpecialTabOrder.Checked:=ReadParam(ConstSectionOptions,chbUseSpecialTabOrder.Name,chbUseSpecialTabOrder.Checked);
    edForDeleteTorecyled.Tag:=ReadParam(ConstSectionOptions,edForDeleteTorecyled.Name+'Tag',edForDeleteTorecyled.Tag);
    SetStatusByEdit(edForDeleteTorecyled);
    edMoveFromRecyled.Tag:=ReadParam(ConstSectionOptions,edMoveFromRecyled.Name+'Tag',edMoveFromRecyled.Tag);
    SetStatusByEdit(edMoveFromRecyled);
    edSaleUnitPrice.Tag:=ReadParam(ConstSectionOptions,edSaleUnitPrice.Name+'Tag',edSaleUnitPrice.Tag);
    SetUnitPriceByEdit(edSaleUnitPrice);
    edLeaseUnitPrice.Tag:=ReadParam(ConstSectionOptions,edLeaseUnitPrice.Name+'Tag',edLeaseUnitPrice.Tag);
    SetUnitPriceByEdit(edLeaseUnitPrice);
    edShareUnitPrice.Tag:=ReadParam(ConstSectionOptions,edShareUnitPrice.Name+'Tag',edShareUnitPrice.Tag);
    SetUnitPriceByEdit(edShareUnitPrice);
    chbCheckDoubleOnEdit.Checked:=ReadParam(ConstSectionOptions,chbCheckDoubleOnEdit.Name,chbCheckDoubleOnEdit.Checked);
    chbClearFilterOnEnter.Checked:=ReadParam(ConstSectionOptions,chbClearFilterOnEnter.Name,chbClearFilterOnEnter.Checked);
  end;
  if (OptionHandle=hOptionRptPrice)or(OptionHandle=OPTION_INVALID_HANDLE) then begin
    edreportDir.Text:=ReadParam(ConstSectionOptions,edreportDir.Name,edreportDir.Text);
  end;  
  if (OptionHandle=hOptionImport)or(OptionHandle=OPTION_INVALID_HANDLE) then begin
    chbCheckDoubleOnImport.Checked:=ReadParam(ConstSectionOptions,chbCheckDoubleOnImport.Name,chbCheckDoubleOnImport.Checked);
  end;
end;

procedure TfmOptions.SaveToIni(OptionHandle: THandle);
var
  cf: TComponentFont;
begin
  if (OptionHandle=hOptionPremises)or(OptionHandle=OPTION_INVALID_HANDLE) then begin
    cf:=TComponentFont.Create(nil);
    try
      cf.Font:=edPhoneColumn.Font;
      WriteParam(ConstSectionOptions,edPhoneColumn.Name,cf.GetFontAsHexStr);
    finally
     cf.Free;
    end;

//    WriteParam(ConstSectionOptions,chbUseSpecialTabOrder.Name,chbUseSpecialTabOrder.Checked);
    WriteParam(ConstSectionOptions,edForDeleteTorecyled.Name+'Tag',edForDeleteTorecyled.Tag);
    WriteParam(ConstSectionOptions,edMoveFromRecyled.Name+'Tag',edMoveFromRecyled.Tag);
    WriteParam(ConstSectionOptions,edSaleUnitPrice.Name+'Tag',edSaleUnitPrice.Tag);
    WriteParam(ConstSectionOptions,edLeaseUnitPrice.Name+'Tag',edLeaseUnitPrice.Tag);
    WriteParam(ConstSectionOptions,edShareUnitPrice.Name+'Tag',edShareUnitPrice.Tag);
    WriteParam(ConstSectionOptions,chbCheckDoubleOnEdit.Name,chbCheckDoubleOnEdit.Checked);
    WriteParam(ConstSectionOptions,chbClearFilterOnEnter.Name,chbClearFilterOnEnter.Checked);
  end;
  if (OptionHandle=hOptionRptPrice)or(OptionHandle=OPTION_INVALID_HANDLE) then begin
    WriteParam(ConstSectionOptions,edreportDir.Name,edreportDir.Text);
  end;
  if (OptionHandle=hOptionImport)or(OptionHandle=OPTION_INVALID_HANDLE) then begin
    WriteParam(ConstSectionOptions,chbCheckDoubleOnImport.Name,chbCheckDoubleOnImport.Checked);
  end;
end;

procedure TfmOptions.bibPhoneColumnClick(Sender: TObject);
begin
   fd.Font.Assign(edPhoneColumn.Font);
   if not fd.Execute then exit;
   edPhoneColumn.Font.Assign(fd.Font);
   edPhoneColumn.Text:=edPhoneColumn.Font.Name;
   bibPhoneColumn.Height:=edPhoneColumn.Height;
end;

procedure TfmOptions.bibReportDirClick(Sender: TObject);
begin
  edreportDir.Text:=SelectDirectoryEx(Application.Handle,edreportDir.Text,ConstSelectDir,[tbReturnOnlyFSDirs]);
{   if SelectDirectory(ConstSelectDir,'',S) then
     edreportDir.Text:=S;}
end;

procedure TfmOptions.btForDeleteTorecyledClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='pms_station_id';
  TPRBI.Locate.KeyValues:=iff(Trim(edForDeleteTorecyled.Text)='',Unassigned,edForDeleteTorecyled.Tag);
  if _ViewInterfaceFromName(NameRbkPms_Station,@TPRBI) then begin
    edForDeleteTorecyled.Text:=GetFirstValueFromPRBI(@TPRBI,'name');
    edForDeleteTorecyled.Tag:=GetFirstValueFromPRBI(@TPRBI,'pms_station_id');
  end;
end;

procedure TfmOptions.edForDeleteTorecyledKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    edForDeleteTorecyled.Text:='';
    edForDeleteTorecyled.Tag:=0;
  end;
end;

procedure TfmOptions.btMoveFromRecyledClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='pms_station_id';
  TPRBI.Locate.KeyValues:=iff(Trim(edMoveFromRecyled.Text)='',Unassigned,edMoveFromRecyled.Tag);
  if _ViewInterfaceFromName(NameRbkPms_Station,@TPRBI) then begin
    edMoveFromRecyled.Text:=GetFirstValueFromPRBI(@TPRBI,'name');
    edMoveFromRecyled.Tag:=GetFirstValueFromPRBI(@TPRBI,'pms_station_id');
  end;
end;

procedure TfmOptions.edMoveFromRecyledKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    edMoveFromRecyled.Text:='';
    edMoveFromRecyled.Tag:=0;
  end;
end;

procedure TfmOptions.btSaleUnitPriceClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='pms_unitprice_id';
  TPRBI.Locate.KeyValues:=iff(Trim(edSaleUnitPrice.Text)='',Unassigned,edSaleUnitPrice.Tag);
  if _ViewInterfaceFromName(NameRbkPms_UnitPrice,@TPRBI) then begin
    edSaleUnitPrice.Text:=GetFirstValueFromPRBI(@TPRBI,'name');
    edSaleUnitPrice.Tag:=GetFirstValueFromPRBI(@TPRBI,'pms_unitprice_id');
  end;
end;

procedure TfmOptions.edSaleUnitPriceKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    edSaleUnitPrice.Text:='';
    edSaleUnitPrice.Tag:=0;
  end;
end;

procedure TfmOptions.btLeaseUnitPriceClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='pms_unitprice_id';
  TPRBI.Locate.KeyValues:=iff(Trim(edLeaseUnitPrice.Text)='',Unassigned,edLeaseUnitPrice.Tag);
  if _ViewInterfaceFromName(NameRbkPms_UnitPrice,@TPRBI) then begin
    edLeaseUnitPrice.Text:=GetFirstValueFromPRBI(@TPRBI,'name');
    edLeaseUnitPrice.Tag:=GetFirstValueFromPRBI(@TPRBI,'pms_unitprice_id');
  end;
end;

procedure TfmOptions.edLeaseUnitPriceKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    edLeaseUnitPrice.Text:='';
    edLeaseUnitPrice.Tag:=0;
  end;
end;

procedure TfmOptions.btShareUnitPriceClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='pms_unitprice_id';
  TPRBI.Locate.KeyValues:=iff(Trim(edShareUnitPrice.Text)='',Unassigned,edShareUnitPrice.Tag);
  if _ViewInterfaceFromName(NameRbkPms_UnitPrice,@TPRBI) then begin
    edShareUnitPrice.Text:=GetFirstValueFromPRBI(@TPRBI,'name');
    edShareUnitPrice.Tag:=GetFirstValueFromPRBI(@TPRBI,'pms_unitprice_id');
  end;
end;

procedure TfmOptions.edShareUnitPriceKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    edShareUnitPrice.Text:='';
    edShareUnitPrice.Tag:=0;
  end;
end;

procedure TfmOptions.SetStatusByEdit(Edit: TEdit);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.WhereStr:=PChar(' pms_station_id='+inttostr(Edit.Tag)+' ');
  if _ViewInterfaceFromName(NameRbkPms_Station,@TPRBI) then begin
    Edit.Text:=GetFirstValueFromPRBI(@TPRBI,'name');
  end;
end;

procedure TfmOptions.SetUnitPriceByEdit(Edit: TEdit);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.WhereStr:=PChar(' pms_unitprice_id='+inttostr(Edit.Tag)+' ');
  if _ViewInterfaceFromName(NameRbkPms_UnitPrice,@TPRBI) then begin
    Edit.Text:=GetFirstValueFromPRBI(@TPRBI,'name');
  end;
end;

end.
