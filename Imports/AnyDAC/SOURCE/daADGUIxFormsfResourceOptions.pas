{ --------------------------------------------------------------------------- }
{ AnyDAC resource options editing frame                                       }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I daAD.inc}

unit daADGUIxFormsfResourceOptions;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, StdCtrls, ExtCtrls, DB,
  daADStanOption, daADStanIntf,
  daADGUIxFormsControls;

type
  TfrmADGUIxFormsResourceOptions = class(TFrame)
    ro_gbCmdTextProcess: TADGUIxFormsPanel;
    ro_gbCursors: TADGUIxFormsPanel;
    ro_cbDisconnectable: TCheckBox;
    ro_gbAsync: TADGUIxFormsPanel;
    ro_cbCreateParams: TCheckBox;
    ro_cbCreateMacros: TCheckBox;
    ro_Label1: TLabel;
    ro_edtMaxCursors: TEdit;
    ro_cbxAsyncCmdMode: TComboBox;
    ro_Label2: TLabel;
    ro_Label3: TLabel;
    ro_edtAsyncCmdTimeout: TEdit;
    ro_cbExpandParams: TCheckBox;
    ro_cbExpandMacros: TCheckBox;
    ro_cbExpandEscapes: TCheckBox;
    ro_Label4: TLabel;
    ro_cbxDefaultParamType: TComboBox;
    procedure ro_Change(Sender: TObject);
  private
    { Private declarations }
    FOnModified: TNotifyEvent;
    FModifiedLocked: Boolean;
  public
    procedure LoadFrom(AOpts: TADResourceOptions);
    procedure SaveTo(AOpts: TADResourceOptions);
  published
    property OnModified: TNotifyEvent read FOnModified write FOnModified;
  end;

implementation

{$R *.dfm}

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsResourceOptions.LoadFrom(AOpts: TADResourceOptions);
begin
  FModifiedLocked := True;
  try
    ro_cbxAsyncCmdMode.ItemIndex := Integer(AOpts.AsyncCmdMode);
    ro_edtAsyncCmdTimeout.Text := IntToStr(Integer(AOpts.AsyncCmdTimeout));
    ro_cbCreateParams.Checked := AOpts.ParamCreate;
    ro_cbCreateMacros.Checked := AOpts.MacroCreate;
    ro_cbExpandParams.Checked := AOpts.ParamExpand;
    ro_cbExpandMacros.Checked := AOpts.MacroExpand;
    ro_cbExpandEscapes.Checked := AOpts.EscapeExpand;
    ro_cbDisconnectable.Checked := AOpts.Disconnectable;
    if AOpts is TADTopResourceOptions then begin
      ro_edtMaxCursors.Text := IntToStr(TADTopResourceOptions(AOpts).MaxCursors);
      ro_edtMaxCursors.Visible := True;
    end
    else
      ro_edtMaxCursors.Visible := False;
    ro_Label1.Visible := ro_edtMaxCursors.Visible;
    ro_cbxDefaultParamType.ItemIndex := Integer(AOpts.DefaultParamType);
  finally
    FModifiedLocked := False;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsResourceOptions.SaveTo(AOpts: TADResourceOptions);
begin
  if ro_cbxAsyncCmdMode.ItemIndex <> Integer(AOpts.AsyncCmdMode) then
    AOpts.AsyncCmdMode := TADStanAsyncMode(ro_cbxAsyncCmdMode.ItemIndex);
  if StrToInt(ro_edtAsyncCmdTimeout.Text) <> Integer(AOpts.AsyncCmdTimeout) then
    AOpts.AsyncCmdTimeout := LongWord(StrToInt(ro_edtAsyncCmdTimeout.Text));
  if ro_cbCreateParams.Checked <> AOpts.ParamCreate then
    AOpts.ParamCreate := ro_cbCreateParams.Checked;
  if ro_cbCreateMacros.Checked <> AOpts.MacroCreate then
    AOpts.MacroCreate := ro_cbCreateMacros.Checked;
  if ro_cbExpandParams.Checked <> AOpts.ParamExpand then
    AOpts.ParamExpand := ro_cbExpandParams.Checked;
  if ro_cbExpandMacros.Checked <> AOpts.MacroExpand then
    AOpts.MacroExpand := ro_cbExpandMacros.Checked;
  if ro_cbExpandEscapes.Checked <> AOpts.EscapeExpand then
    AOpts.EscapeExpand := ro_cbExpandEscapes.Checked;
  if ro_cbDisconnectable.Checked <> AOpts.Disconnectable then
    AOpts.Disconnectable := ro_cbDisconnectable.Checked;
  if AOpts is TADTopResourceOptions then
    if StrToInt(ro_edtMaxCursors.Text) <> TADTopResourceOptions(AOpts).MaxCursors then
      TADTopResourceOptions(AOpts).MaxCursors := StrToInt(ro_edtMaxCursors.Text);
  if ro_cbxDefaultParamType.ItemIndex <> Integer(AOpts.DefaultParamType) then
    AOpts.DefaultParamType := TParamType(ro_cbxDefaultParamType.ItemIndex);
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsResourceOptions.ro_Change(Sender: TObject);
begin
  if not FModifiedLocked and Assigned(FOnModified) then
    FOnModified(Self);
end;

end.
