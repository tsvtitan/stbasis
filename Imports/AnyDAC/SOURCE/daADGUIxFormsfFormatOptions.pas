{ --------------------------------------------------------------------------- }
{ AnyDAC format options editing frame                                         }
{ Copyright (c) 2004 by Dmitry Arefiev (www.da-soft.com)                      }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I daAD.inc}

unit daADGUIxFormsfFormatOptions;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms,
    StdCtrls, Grids, ComCtrls, Buttons, ExtCtrls,
  daADStanIntf, daADStanOption,
  daADGUIxFormsControls;

type
  TfrmADGUIxFormsFormatOptions = class(TFrame)
    mo_GroupBox1: TADGUIxFormsPanel;
    mo_Panel3: TADGUIxFormsPanel;
    mo_sgMapRules: TStringGrid;
    mo_cbxDataType: TComboBox;
    mo_Panel2: TADGUIxFormsPanel;
    mo_Panel5: TADGUIxFormsPanel;
    mo_cbOwnMapRules: TCheckBox;
    mo_gb1: TADGUIxFormsPanel;
    mo_Label2: TLabel;
    mo_Label3: TLabel;
    mo_edtMaxBcdPrecision: TEdit;
    mo_edtMaxBcdScale: TEdit;
    mo_gb2: TADGUIxFormsPanel;
    mo_Label1: TLabel;
    mo_Label10: TLabel;
    mo_cbStrsEmpty2Null: TCheckBox;
    mo_cbStrsTrim: TCheckBox;
    mo_edtMaxStringSize: TEdit;
    mo_edtInlineDataSize: TEdit;
    mo_cbStrsDivLen2: TCheckBox;
    mo_Panel11: TADGUIxFormsPanel;
    Panel1: TADGUIxFormsPanel;
    Panel2: TADGUIxFormsPanel;
    mo_btnAddRule: TSpeedButton;
    Panel3: TADGUIxFormsPanel;
    Panel4: TADGUIxFormsPanel;
    mo_btnRemRule: TSpeedButton;
    mo_Panel6: TADGUIxFormsPanel;
    mo_Label6: TLabel;
    mo_cbDefaultParamDataType: TComboBox;
    procedure mo_cbOwnMapRulesClick(Sender: TObject);
    procedure mo_btnAddRuleClick(Sender: TObject);
    procedure mo_btnRemRuleClick(Sender: TObject);
    procedure mo_sgMapRulesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure mo_sgMapRulesSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure mo_sgMapRulesTopLeftChanged(Sender: TObject);
    procedure mo_cbxDataTypeExit(Sender: TObject);
    procedure mo_cbxDataTypeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure mo_sgMapRulesEnter(Sender: TObject);
    procedure mo_Change(Sender: TObject);
  private
    FOnModified: TNotifyEvent;
    FLockModified: Boolean;
    procedure AdjustComboBox(ABox: TComboBox; ACol, ARow: Integer;
      AGrid: TStringGrid);
    { Private declarations }
  public
    procedure LoadFrom(AOpts: TADFormatOptions);
    procedure SaveTo(AOpts: TADFormatOptions);
  published
    property OnModified: TNotifyEvent read FOnModified write FOnModified;
  end;

implementation

{$R *.dfm}

uses
  DB,
  daADStanConst;
  
{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsFormatOptions.LoadFrom(AOpts: TADFormatOptions);

  function IntToStrDef(AValue, ADefault: Integer): String;
  begin
    if AValue = ADefault then
      Result := ''
    else
      Result := IntToStr(AValue);
  end;

  function UIntToStrDef(AValue, ADefault: LongWord): String;
  begin
    if AValue = ADefault then
      Result := ''
    else
      Result := IntToStr(AValue);
  end;

var
  i: Integer;
begin
  FLockModified := True;
  try
    mo_sgMapRules.Cells[0, 0] := 'SourceDataType';
    mo_sgMapRules.Cells[1, 0] := 'TargetDataType';
    mo_sgMapRules.Cells[2, 0] := 'PrecMin';
    mo_sgMapRules.Cells[3, 0] := 'PrecMax';
    mo_sgMapRules.Cells[4, 0] := 'ScaleMin';
    mo_sgMapRules.Cells[5, 0] := 'ScaleMax';
    mo_sgMapRules.Cells[6, 0] := 'SizeMin';
    mo_sgMapRules.Cells[7, 0] := 'SizeMax';
    if AOpts.MapRules.Count = 0 then begin
      mo_sgMapRules.RowCount := 2;
      for i := 0 to mo_sgMapRules.ColCount - 1 do
        mo_sgMapRules.Cells[i, 1] := ''
    end
    else begin
      mo_sgMapRules.RowCount := AOpts.MapRules.Count + 1;
      for i := 0 to AOpts.MapRules.Count - 1 do
        with AOpts.MapRules[i] do begin
          mo_sgMapRules.Cells[0, i + 1] := mo_cbxDataType.Items[Integer(SourceDataType)];
          mo_sgMapRules.Cells[1, i + 1] := mo_cbxDataType.Items[Integer(TargetDataType)];
          mo_sgMapRules.Cells[2, i + 1] := IntToStrDef(PrecMin, C_AD_DefMapPrec);
          mo_sgMapRules.Cells[3, i + 1] := IntToStrDef(PrecMax, C_AD_DefMapPrec);
          mo_sgMapRules.Cells[4, i + 1] := IntToStrDef(ScaleMin, C_AD_DefMapScale);
          mo_sgMapRules.Cells[5, i + 1] := IntToStrDef(ScaleMax, C_AD_DefMapScale);
          mo_sgMapRules.Cells[6, i + 1] := UIntToStrDef(SizeMin, C_AD_DefMapSize);
          mo_sgMapRules.Cells[7, i + 1] := UIntToStrDef(SizeMax, C_AD_DefMapSize);
        end;
    end;
    mo_cbOwnMapRules.Checked := AOpts.OwnMapRules;
    mo_sgMapRules.Enabled := mo_cbOwnMapRules.Checked;
    mo_cbStrsEmpty2Null.Checked := AOpts.StrsEmpty2Null;
    mo_cbStrsTrim.Checked := AOpts.StrsTrim;
    mo_edtMaxStringSize.Text := IntToStr(AOpts.MaxStringSize);
    mo_edtMaxBcdPrecision.Text := IntToStr(AOpts.MaxBcdPrecision);
    mo_edtMaxBcdScale.Text := IntToStr(AOpts.MaxBcdScale);
    mo_cbOwnMapRulesClick(nil);
    mo_sgMapRules.DefaultRowHeight := mo_cbxDataType.Height - GetSystemMetrics(SM_CYBORDER);
    mo_cbStrsDivLen2.Checked := AOpts.StrsDivLen2;
    mo_edtInlineDataSize.Text := IntToStr(AOpts.InlineDataSize);
    mo_cbDefaultParamDataType.ItemIndex := Integer(AOpts.DefaultParamDataType);
  finally
    FLockModified := False;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsFormatOptions.SaveTo(AOpts: TADFormatOptions);

  function OneChar(S: String; ADefault: Char): Char;
  begin
    S := Trim(S);
    if S = '' then
      Result := ADefault
    else
      Result := S[1];
  end;

var
  i: Integer;
begin
  if AOpts.OwnMapRules <> mo_cbOwnMapRules.Checked then
    AOpts.OwnMapRules := mo_cbOwnMapRules.Checked;
  if AOpts.OwnMapRules then begin
    AOpts.MapRules.Clear;
    for i := 1 to mo_sgMapRules.RowCount - 1 do
      with AOpts.MapRules.Add do
        if (mo_sgMapRules.Cells[0, i] <> '') and (mo_sgMapRules.Cells[1, i] <> '') then begin
          SourceDataType := TADDataType(mo_cbxDataType.Items.IndexOf(mo_sgMapRules.Cells[0, i]));
          TargetDataType := TADDataType(mo_cbxDataType.Items.IndexOf(mo_sgMapRules.Cells[1, i]));
          PrecMin := StrToIntDef(mo_sgMapRules.Cells[2, i], C_AD_DefMapPrec);
          PrecMax := StrToIntDef(mo_sgMapRules.Cells[3, i], C_AD_DefMapPrec);
          ScaleMin := StrToIntDef(mo_sgMapRules.Cells[4, i], C_AD_DefMapScale);
          ScaleMax := StrToIntDef(mo_sgMapRules.Cells[5, i], C_AD_DefMapScale);
          SizeMin := LongWord(StrToIntDef(mo_sgMapRules.Cells[6, i], Integer(C_AD_DefMapSize)));
          SizeMax := LongWord(StrToIntDef(mo_sgMapRules.Cells[7, i], Integer(C_AD_DefMapSize)));
        end;
  end;
  if AOpts.StrsEmpty2Null <> mo_cbStrsEmpty2Null.Checked then
    AOpts.StrsEmpty2Null := mo_cbStrsEmpty2Null.Checked;
  if AOpts.StrsTrim <> mo_cbStrsTrim.Checked then
    AOpts.StrsTrim := mo_cbStrsTrim.Checked;
  if AOpts.MaxStringSize <> LongWord(StrToInt(mo_edtMaxStringSize.Text)) then
    AOpts.MaxStringSize := LongWord(StrToInt(mo_edtMaxStringSize.Text));
  if AOpts.MaxBcdPrecision <> StrToInt(mo_edtMaxBcdPrecision.Text) then
    AOpts.MaxBcdPrecision := StrToInt(mo_edtMaxBcdPrecision.Text);
  if AOpts.MaxBcdScale <> StrToInt(mo_edtMaxBcdScale.Text) then
    AOpts.MaxBcdScale := StrToInt(mo_edtMaxBcdScale.Text);
  if AOpts.StrsDivLen2 <> mo_cbStrsDivLen2.Checked then
    AOpts.StrsDivLen2 := mo_cbStrsDivLen2.Checked;
  if AOpts.InlineDataSize <> StrToInt(mo_edtInlineDataSize.Text) then
    AOpts.InlineDataSize := StrToInt(mo_edtInlineDataSize.Text);
  if mo_cbDefaultParamDataType.ItemIndex <> Integer(AOpts.DefaultParamDataType) then
    AOpts.DefaultParamDataType := TFieldType(mo_cbDefaultParamDataType.ItemIndex);
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsFormatOptions.mo_Change(Sender: TObject);
begin
  if not FLockModified and Assigned(FOnModified) then
    FOnModified(Self);
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsFormatOptions.mo_cbOwnMapRulesClick(Sender: TObject);
begin
  mo_sgMapRules.Enabled := mo_cbOwnMapRules.Checked;
  mo_btnAddRule.Enabled := mo_cbOwnMapRules.Checked;
  mo_btnRemRule.Enabled := mo_cbOwnMapRules.Checked;
  mo_Change(nil);
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsFormatOptions.mo_btnAddRuleClick(Sender: TObject);
var
  i, j: Integer;
begin
  mo_sgMapRules.RowCount := mo_sgMapRules.RowCount + 1;
  for i := mo_sgMapRules.Row to mo_sgMapRules.RowCount - 2 do
    for j := 0 to mo_sgMapRules.ColCount - 1 do
      mo_sgMapRules.Cells[j, i + 1] := mo_sgMapRules.Cells[j, i];
  mo_Change(nil);
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsFormatOptions.mo_btnRemRuleClick(Sender: TObject);
var
  i, j: Integer;
begin
  if mo_sgMapRules.RowCount > 1 then begin
    for i := mo_sgMapRules.Row to mo_sgMapRules.RowCount - 2 do
      for j := 0 to mo_sgMapRules.ColCount - 1 do
        mo_sgMapRules.Cells[j, i] := mo_sgMapRules.Cells[j, i + 1];
    if mo_sgMapRules.RowCount = 2 then
      for j := 0 to mo_sgMapRules.ColCount - 1 do
        mo_sgMapRules.Cells[j, 1] := ''
    else
      mo_sgMapRules.RowCount := mo_sgMapRules.RowCount - 1;
    mo_Change(nil);
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsFormatOptions.mo_sgMapRulesKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_F2) and mo_cbxDataType.Visible then begin
    mo_cbxDataType.BringToFront;
    mo_cbxDataType.SetFocus;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsFormatOptions.mo_sgMapRulesEnter(Sender: TObject);
var
  lCanSelect: Boolean;
begin
  if not mo_cbxDataType.Visible then
    mo_sgMapRulesSelectCell(mo_sgMapRules, mo_sgMapRules.Col,
      mo_sgMapRules.Row, lCanSelect);
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsFormatOptions.mo_sgMapRulesSelectCell(Sender: TObject;
  ACol, ARow: Integer; var CanSelect: Boolean);
begin
  if (ARow >= 1) and (ACol <= 1) then begin
    mo_cbxDataType.ItemIndex := mo_cbxDataType.Items.IndexOf(
      mo_sgMapRules.Cells[ACol, ARow]);
    AdjustComboBox(mo_cbxDataType, ACol, ARow, mo_sgMapRules);
  end
  else
    mo_cbxDataType.Visible := False;
  CanSelect := True;
  if mo_cbxDataType.Visible then
    mo_cbxDataType.SetFocus;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsFormatOptions.mo_sgMapRulesTopLeftChanged(
  Sender: TObject);
begin
  if mo_cbxDataType.Visible then
    AdjustComboBox(mo_cbxDataType, mo_sgMapRules.Col, mo_sgMapRules.Row, mo_sgMapRules);
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsFormatOptions.mo_cbxDataTypeExit(Sender: TObject);
begin
  if mo_sgMapRules.Cells[mo_sgMapRules.Col, mo_sgMapRules.Row] <>
     mo_cbxDataType.Items[mo_cbxDataType.ItemIndex] then begin
    mo_sgMapRules.Cells[mo_sgMapRules.Col, mo_sgMapRules.Row] :=
      mo_cbxDataType.Items[mo_cbxDataType.ItemIndex];
    mo_Change(nil);
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsFormatOptions.mo_cbxDataTypeKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if mo_cbxDataType.DroppedDown then
    Exit;
  if Key = VK_ESCAPE then begin
    AdjustComboBox(mo_cbxDataType, mo_sgMapRules.Col, mo_sgMapRules.Row, mo_sgMapRules);
    mo_cbxDataType.SelectAll;
    Key := 0;
  end
  else if (Key = VK_RETURN) or (Key = VK_DOWN) then begin
    mo_cbxDataType.OnExit(mo_cbxDataType);
    if mo_sgMapRules.Row < mo_sgMapRules.RowCount - 1 then
      mo_sgMapRules.Row := mo_sgMapRules.Row + 1;
    Key := 0;
  end
  else if Key = VK_UP then begin
    mo_cbxDataType.OnExit(mo_cbxDataType);
    if mo_sgMapRules.Row > mo_sgMapRules.FixedRows then
      mo_sgMapRules.Row := mo_sgMapRules.Row - 1;
    Key := 0;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsFormatOptions.AdjustComboBox(ABox: TComboBox; ACol, ARow: Integer;
  AGrid: TStringGrid);
var
  R: TRect;
begin
  if ABox = nil then
    Exit;
  with ABox do begin
    R := AGrid.CellRect(ACol, ARow);
    R.TopLeft := ABox.Parent.ScreenToClient(AGrid.ClientToScreen(R.TopLeft));
    R.BottomRight := ABox.Parent.ScreenToClient(AGrid.ClientToScreen(R.BottomRight));
    Left := R.Left;
    Top := R.Top;
    Width := R.Right - R.Left + 1;
    Text := AGrid.Cells[ACol, ARow];
    Visible := True;
  end;
end;

end.
