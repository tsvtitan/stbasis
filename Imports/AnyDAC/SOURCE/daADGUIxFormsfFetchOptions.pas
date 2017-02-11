{ --------------------------------------------------------------------------- }
{ AnyDAC fetch options editing frame                                          }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I daAD.inc}

unit daADGUIxFormsfFetchOptions;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, StdCtrls,
  ExtCtrls, daADStanOption, daADGUIxFormsControls;

type
  TfrmADGUIxFormsFetchOptions = class(TFrame)
    fo_gbItems: TADGUIxFormsPanel;
    fo_cbIBlobs: TCheckBox;
    fo_cbIDetails: TCheckBox;
    fo_cbIMeta: TCheckBox;
    fo_gbCache: TADGUIxFormsPanel;
    fo_cbCBlobs: TCheckBox;
    fo_cbCDetails: TCheckBox;
    fo_cbCMeta: TCheckBox;
    fo_GroupBox1: TADGUIxFormsPanel;
    fo_Label1: TLabel;
    fo_Label3: TLabel;
    fo_Label2: TLabel;
    fo_edtRecsMax: TEdit;
    fo_edtRowSetSize: TEdit;
    fo_cbxMode: TComboBox;
    fo_cbAutoClose: TCheckBox;
    fo_Label4: TLabel;
    fo_cbxRecordCountMode: TComboBox;
    procedure fo_Change(Sender: TObject);
  private
    { Private declarations }
    FOnModified: TNotifyEvent;
    FModifiedLocked: Boolean;
  public
    procedure LoadFrom(AOpts: TADFetchOptions);
    procedure SaveTo(AOpts: TADFetchOptions);
  published
    property OnModified: TNotifyEvent read FOnModified write FOnModified;
  end;

implementation

{$R *.dfm}

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsFetchOptions.LoadFrom(AOpts: TADFetchOptions);
begin
  FModifiedLocked := True;
  try
    fo_cbxMode.ItemIndex := Integer(AOpts.Mode);
    fo_cbIBlobs.Checked := fiBlobs in AOpts.Items;
    fo_cbIDetails.Checked := fiDetails in AOpts.Items;
    fo_cbIMeta.Checked := fiMeta in AOpts.Items;
    fo_cbCBlobs.Checked := fiBlobs in AOpts.Cache;
    fo_cbCDetails.Checked := fiDetails in AOpts.Cache;
    fo_cbCMeta.Checked := fiMeta in AOpts.Cache;
    fo_edtRecsMax.Text := IntToStr(AOpts.RecsMax);
    fo_edtRowSetSize.Text := IntToStr(AOpts.RowsetSize);
    fo_cbAutoClose.Checked := AOpts.AutoClose;
    fo_cbxRecordCountMode.ItemIndex := Integer(AOpts.RecordCountMode);
  finally
    FModifiedLocked := False;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsFetchOptions.SaveTo(AOpts: TADFetchOptions);
var
  i: TADFetchItems;
  j: Integer;
begin
  if AOpts.Mode <> TADFetchMode(fo_cbxMode.ItemIndex) then
    AOpts.Mode := TADFetchMode(fo_cbxMode.ItemIndex);
  i := [];
  if fo_cbIBlobs.Checked then
    Include(i, fiBlobs);
  if fo_cbIDetails.Checked then
    Include(i, fiDetails);
  if fo_cbIMeta.Checked then
    Include(i, fiMeta);
  if AOpts.Items <> i then
    AOpts.Items := i;
  i := [];
  if fo_cbCBlobs.Checked then
    Include(i, fiBlobs);
  if fo_cbCDetails.Checked then
    Include(i, fiDetails);
  if fo_cbCMeta.Checked then
    Include(i, fiMeta);
  if AOpts.Cache <> i then
    AOpts.Cache := i;
  j := StrToInt(fo_edtRecsMax.Text);
  if AOpts.RecsMax <> j then
    AOpts.RecsMax := j;
  j := StrToInt(fo_edtRowSetSize.Text);
  if AOpts.RowsetSize <> j then
    AOpts.RowsetSize := j;
  if AOpts.AutoClose <> fo_cbAutoClose.Checked then
    AOpts.AutoClose := fo_cbAutoClose.Checked;
  if AOpts.RecordCountMode <> TADRecordCountMode(fo_cbxRecordCountMode.ItemIndex) then
    AOpts.RecordCountMode := TADRecordCountMode(fo_cbxRecordCountMode.ItemIndex);
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsFetchOptions.fo_Change(Sender: TObject);
begin
  if not FModifiedLocked and Assigned(FOnModified) then
    FOnModified(Self);
end;

end.
