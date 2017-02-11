{
 * The contents of this file are subject to the InterBase Public License
 * Version 1.0 (the "License"); you may not use this file except in
 * compliance with the License.
 * 
 * You may obtain a copy of the License at http://www.Inprise.com/IPL.html.
 * 
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
 * the License for the specific language governing rights and limitations
 * under the License.  The Original Code was created by Inprise
 * Corporation and its predecessors.
 * 
 * Portions created by Inprise Corporation are Copyright (C) Inprise
 * Corporation. All Rights Reserved.
 * 
 * Contributor(s): ______________________________________.
}

unit frmuSQLOptions;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  frmuDlgClass, StdCtrls, ExtCtrls, Grids, ComCtrls;

type
  TfrmSQLOptions = class(TDialog)
    btnApply: TButton;
    Button1: TButton;
    pgControl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    sgOptions: TStringGrid;
    pnlOptionName: TPanel;
    cbOptions: TComboBox;
    GroupBox1: TGroupBox;
    cbUpdateConnect: TCheckBox;
    cbUpdateCreate: TCheckBox;
    rgTransactions: TRadioGroup;
    Label1: TLabel;
    Memo1: TMemo;
    cbClearInput: TCheckBox;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure cbOptionsChange(Sender: TObject);
    procedure cbOptionsDblClick(Sender: TObject);
    procedure cbOptionsExit(Sender: TObject);
    procedure cbOptionsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure sgOptionsDblClick(Sender: TObject);
    procedure sgOptionsDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure sgOptionsSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSQLOptions: TfrmSQLOptions;

implementation

uses zluGlobal, Registry;

{$R *.DFM}
const
  OPTION_NAME_COL = 0;
  OPTION_VALUE_COL = 1;

  SHOW_QUERY_PLAN_ROW = 0;
  AUTO_COMMIT_DDL_ROW = 1;
  CHARACTER_SET_ROW = 2;
  BLOB_DISPLAY_ROW = 3;
  BLOB_SUBTYPE_ROW = 4;
  ISQL_TERMINATOR_ROW = 5;
  DEFAULT_DIALECT_ROW = 6;

procedure TfrmSQLOptions.FormCreate(Sender: TObject);
begin
  inherited;
  sgOptions.DefaultRowHeight := cbOptions.Height;
  cbOptions.Visible := False;
  pnlOptionname.Visible := False;
  sgOptions.RowCount := 7;
  pgControl.ActivePageIndex := 0;

  sgOptions.Cells[OPTION_NAME_COL,SHOW_QUERY_PLAN_ROW] := 'Show Query Plan';
  if gAppSettings[SHOW_QUERY_PLAN].Setting = false then
    sgOptions.Cells[OPTION_VALUE_COL,SHOW_QUERY_PLAN_ROW] := 'False'
  else
    sgOptions.Cells[OPTION_VALUE_COL,SHOW_QUERY_PLAN_ROW] := 'True';

  sgOptions.Cells[OPTION_NAME_COL,AUTO_COMMIT_DDL_ROW] := 'Auto Commit DDL';
  if gAppSettings[AUTO_COMMIT_DDL].Setting = false then
    sgOptions.Cells[OPTION_VALUE_COL,AUTO_COMMIT_DDL_ROW] := 'False'
  else
    sgOptions.Cells[OPTION_VALUE_COL,AUTO_COMMIT_DDL_ROW] := 'True';

  sgOptions.Cells[OPTION_NAME_COL,CHARACTER_SET_ROW] := 'Character Set';
  sgOptions.Cells[OPTION_VALUE_COL,CHARACTER_SET_ROW] := gAppSettings[CHARACTER_SET].Setting;

  sgOptions.Cells[OPTION_NAME_COL,BLOB_DISPLAY_ROW] := 'BLOB Display';
  sgOptions.Cells[OPTION_VALUE_COL,BLOB_DISPLAY_ROW] := gAppSettings[BLOB_DISPLAY].Setting;

  sgOptions.Cells[OPTION_NAME_COL,BLOB_SUBTYPE_ROW] := 'BLOB Subtype';
  sgOptions.Cells[OPTION_VALUE_COL,BLOB_SUBTYPE_ROW] := gAppSettings[BLOB_SUBTYPE].Setting;

  sgOptions.Cells[OPTION_NAME_COL,ISQL_TERMINATOR_ROW] := 'Terminator';
  sgOptions.Cells[OPTION_VALUE_COL,ISQL_TERMINATOR_ROW] := gAppSettings[ISQL_TERMINATOR].Setting;

  sgOptions.Cells[OPTION_NAME_COL,DEFAULT_DIALECT_ROW] := 'Client Dialect';
  sgOptions.Cells[OPTION_VALUE_COL,DEFAULT_DIALECT_ROW] := gAppSettings[DEFAULT_DIALECT].Setting;

  cbClearInput.Checked := gAppSettings[CLEAR_INPUT].Setting;
  cbUpdateConnect.Checked := gAppSettings[UPDATE_ON_CONNECT].Setting;
  cbUpdateCreate.Checked := gAppSettings[UPDATE_ON_CREATE].Setting;
  rgTransactions.ItemIndex := gAppSettings[COMMIT_ON_EXIT].Setting;
end;

procedure TfrmSQLOptions.btnApplyClick(Sender: TObject);
var
  NewSetting: boolean;
  Reg: TRegistry;
begin
  inherited;
  Reg := TRegistry.Create;
  Screen.Cursor := crHourGlass;
  with Reg do
  begin
    OpenKey (gRegSettingsKey, false);

    if sgOptions.Cells[OPTION_VALUE_COL,SHOW_QUERY_PLAN_ROW] = 'True' then
      NewSetting := true
    else
      NewSetting := false;

    if NewSetting <> gAppSettings[SHOW_QUERY_PLAN].Setting then
    begin
      gAppSettings[SHOW_QUERY_PLAN].Setting := NewSetting;
      WriteBool(gAppSettings[SHOW_QUERY_PLAN].Name, gAppSettings[SHOW_QUERY_PLAN].Setting);
    end;


    if sgOptions.Cells[OPTION_VALUE_COL,AUTO_COMMIT_DDL_ROW] = 'True' then
      NewSetting := true
    else
      NewSetting := false;

    if NewSetting <> gAppSettings[AUTO_COMMIT_DDL].Setting then
    begin
      gAppSettings[AUTO_COMMIT_DDL].Setting := NewSetting;
      WriteBool(gAppSettings[AUTO_COMMIT_DDL].Name, gAppSettings[AUTO_COMMIT_DDL].Setting);
    end;

    if gAppSettings[CHARACTER_SET].Setting <> sgOptions.Cells[OPTION_VALUE_COL,CHARACTER_SET_ROW] then
    begin
      gAppSettings[CHARACTER_SET].Setting := sgOptions.Cells[OPTION_VALUE_COL,CHARACTER_SET_ROW];
      WriteString(gAppSettings[CHARACTER_SET].Name, gAppSettings[CHARACTER_SET].Setting);
    end;

    if gAppSettings[BLOB_DISPLAY].Setting <> sgOptions.Cells[OPTION_VALUE_COL,BLOB_DISPLAY_ROW] then
    begin
      gAppSettings[BLOB_DISPLAY].Setting := sgOptions.Cells[OPTION_VALUE_COL,BLOB_DISPLAY_ROW];
      WriteString(gAppSettings[BLOB_DISPLAY].Name, gAppSettings[BLOB_DISPLAY].Setting);
    end;

    if gAppSettings[BLOB_SUBTYPE].Setting <> sgOptions.Cells[OPTION_VALUE_COL,BLOB_SUBTYPE_ROW] then
    begin
      gAppSettings[BLOB_SUBTYPE].Setting := sgOptions.Cells[OPTION_VALUE_COL,BLOB_SUBTYPE_ROW];
      WriteString(gAppSettings[BLOB_SUBTYPE].Name, gAppSettings[BLOB_SUBTYPE].Setting);
    end;

    if gAppSettings[ISQL_TERMINATOR].Setting <> sgOptions.Cells[OPTION_VALUE_COL,ISQL_TERMINATOR_ROW] then
    begin
      gAppSettings[ISQL_TERMINATOR].Setting := sgOptions.Cells[OPTION_VALUE_COL,ISQL_TERMINATOR_ROW];
      WriteString(gAppSettings[ISQL_TERMINATOR].Name, gAppSettings[ISQL_TERMINATOR].Setting);
    end;

    if gAppSettings[DEFAULT_DIALECT].Setting <> StrToInt(sgOptions.Cells[OPTION_VALUE_COL,DEFAULT_DIALECT_ROW]) then
    begin
      gAppSettings[DEFAULT_DIALECT].Setting := StrToInt(sgOptions.Cells[OPTION_VALUE_COL,DEFAULT_DIALECT_ROW]);
      WriteInteger(gAppSettings[DEFAULT_DIALECT].Name, gAppSettings[DEFAULT_DIALECT].Setting);
    end;

    if gAppSettings[UPDATE_ON_CONNECT].Setting <> cbUpdateConnect.Checked then
    begin
      gAppSettings[UPDATE_ON_CONNECT].Setting := cbUpdateConnect.Checked;
      WriteBool(gAppSettings[UPDATE_ON_CONNECT].Name, gAppSettings[UPDATE_ON_CONNECT].Setting);
    end;

    if gAppSettings[UPDATE_ON_CREATE].Setting <> cbUpdateCreate.Checked then
    begin
      gAppSettings[UPDATE_ON_CREATE].Setting := cbUpdateCreate.Checked;
      WriteBool(gAppSettings[UPDATE_ON_CREATE].Name, gAppSettings[UPDATE_ON_CREATE].Setting);
    end;

    if gAppSettings[CLEAR_INPUT].Setting <> cbClearInput.Checked then
    begin
      gAppSettings[CLEAR_INPUT].Setting := cbClearInput.Checked;
      WriteBool(gAppSettings[CLEAR_INPUT].Name, gAppSettings[CLEAR_INPUT].Setting);
    end;

    if gAppSettings[COMMIT_ON_EXIT].Setting <> rgTransactions.ItemIndex then
    begin
      gAppSettings[COMMIT_ON_EXIT].Setting := rgTransactions.ItemIndex;
      WriteInteger(gAppSettings[COMMIT_ON_EXIT].Name, gAppSettings[COMMIT_ON_EXIT].Setting);
    end;

    CloseKey;
    Free;
  end;
  Screen.Cursor := crDefault;
end;

procedure TfrmSQLOptions.cbOptionsChange(Sender: TObject);
begin
  inherited;
  btnApply.Enabled := true;
end;

procedure TfrmSQLOptions.cbOptionsDblClick(Sender: TObject);
begin
  inherited;
  if (sgOptions.Col = OPTION_VALUE_COL) or (sgOptions.Col = OPTION_NAME_COL) then
  begin
    if cbOptions.ItemIndex = cbOptions.Items.Count - 1 then
      cbOptions.ItemIndex := 0
    else
      cbOptions.ItemIndex := cbOptions.ItemIndex + 1;

    if (sgOptions.Col = OPTION_VALUE_COL) then
      sgOptions.Cells[sgOptions.Col,sgOptions.Row] := cbOptions.Items[cbOptions.ItemIndex];
  end;
end;

procedure TfrmSQLOptions.cbOptionsExit(Sender: TObject);
var
  lR     : TRect;
  iIndex : Integer;
begin
  inherited;
  iIndex := cbOptions.Items.IndexOf(cbOptions.Text);

  if (iIndex = -1) and (sgOptions.Row <> ISQL_TERMINATOR_ROW) then
  begin
    MessageDlg('Invalid option value', mtError, [mbOK], 0);

    cbOptions.ItemIndex := 0;          // reset to first item in list
    //Size and position the combo box to fit the cell
    lR := sgOptions.CellRect(OPTION_VALUE_COL, sgOptions.Row);
    lR.Left := lR.Left + sgOptions.Left;
    lR.Right := lR.Right + sgOptions.Left;
    lR.Top := lR.Top + sgOptions.Top;
    lR.Bottom := lR.Bottom + sgOptions.Top;
    cbOptions.Left := lR.Left + 1;
    cbOptions.Top := lR.Top + 1;
    cbOptions.Width := (lR.Right + 1) - lR.Left;
    cbOptions.Height := (lR.Bottom + 1) - lR.Top;
    cbOptions.SetFocus;
  end
  else if (sgOptions.Row = ISQL_TERMINATOR_ROW) and (sgOptions.Col = OPTION_VALUE_COL) then
    sgOptions.Cells[sgOptions.Col,sgOptions.Row] := cbOptions.Text
  else if (sgOptions.Col <> OPTION_NAME_COL) then
    sgOptions.Cells[sgOptions.Col,sgOptions.Row] := cbOptions.Items[iIndex]
  else
    sgOptions.Cells[OPTION_VALUE_COL,sgOptions.Row] := cbOptions.Items[iIndex];
end;

procedure TfrmSQLOptions.cbOptionsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_DOWN) and (ssAlt in Shift) then
    cbOptions.DroppedDown := true;
end;

procedure TfrmSQLOptions.sgOptionsDblClick(Sender: TObject);
begin
  inherited;
  {
  if sgOptions.Col = OPTION_VALUE_COL then
  begin
    if cbOptions.ItemIndex = cbOptions.Items.Count - 1 then
      cbOptions.ItemIndex := 0
    else
      cbOptions.ItemIndex := cbOptions.ItemIndex + 1;

    sgOptions.Cells[sgOptions.Col,sgOptions.Row] := cbOptions.Items[cbOptions.ItemIndex];
    cbOptions.Visible := false;
    sgOptions.SetFocus;
  end;
  }
end;

procedure TfrmSQLOptions.sgOptionsDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
const
  INDENT = 2;
var
  lLeft: integer;
  lText: string;

begin
  inherited;
  with sgOptions.canvas do
  begin
    if ACol = OPTION_VALUE_COL then
    begin
      font.color := clBlue;
      if brush.color = clHighlight then
        font.color := clWhite;
      lText := sgOptions.Cells[ACol,ARow];
      lLeft := Rect.Left + INDENT;
      TextRect(Rect, lLeft, Rect.top + INDENT, lText);
    end;
  end;
end;

procedure TfrmSQLOptions.sgOptionsSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
var
  lR : TRect;
  lName : TRect;
begin
  inherited;
  cbOptions.Items.Clear;
  case ARow of
    DEFAULT_DIALECT_ROW:
    begin
      cbOptions.Items.Add('1');
      cbOptions.Items.Add('2');
      cbOptions.Items.Add('3');      
    end;

    SHOW_QUERY_PLAN_ROW:
    begin
      cbOptions.Items.Add('True');
      cbOptions.Items.Add('False');
    end;
    AUTO_COMMIT_DDL_ROW:
    begin
      cbOptions.Items.Add('True');
      cbOptions.Items.Add('False');
    end;
    CHARACTER_SET_ROW:
    begin
      with cbOptions.Items do
      begin
        Add('ASCII');
        Add('BIG_5');
        Add('CYRL');
        Add('DOS437');
        Add('DOS850');
        Add('DOS852');
        Add('DOS857');
        Add('DOS860');
        Add('DOS861');
        Add('DOS863');
        Add('DOS865');
        Add('EUCJ_0208');
        Add('GB_2312');
        Add('ISO8859_1');
        Add('KSC_5601');
        Add('NEXT');
        Add('None');
        Add('OCTETS');
        Add('SJIS_0208');
        Add('UNICODE_FSS');
        Add('WIN1250');
        Add('WIN1251');
        Add('WIN1252');
        Add('WIN1253');
        Add('WIN1254');
      end;
    end;
    BLOB_DISPLAY_ROW:
    begin
      cbOptions.Items.Add('Enabled');
      cbOptions.Items.Add('Disabled');
      cbOptions.Items.Add('Restrict');
    end;
    BLOB_SUBTYPE_ROW:
    begin
      cbOptions.Items.Add('Text');
      cbOptions.Items.Add('Unknown');
    end;
    ISQL_TERMINATOR_ROW:
    begin
      cbOptions.Items.Add(';');
    end;
  end;

  pnlOptionName.Caption := sgOptions.Cells[OPTION_NAME_COL,ARow];

  if ACol = OPTION_NAME_COL then
    cbOptions.ItemIndex := cbOptions.Items.IndexOf(sgOptions.Cells[ACol+1,ARow])
  else if ACol = OPTION_VALUE_COL then
  begin
    cbOptions.ItemIndex := cbOptions.Items.IndexOf(sgOptions.Cells[ACol,ARow]);
    if cbOptions.ItemIndex = -1 then
      cbOptions.Text := sgOptions.Cells[ACol,ARow];
  end;

  if ACol = OPTION_NAME_COL then
  begin
    lName := sgOptions.CellRect(ACol, ARow);
    lR := sgOptions.CellRect(ACol + 1, ARow);
  end
  else
  begin
    lName := sgOptions.CellRect(ACol - 1, ARow);
    lR := sgOptions.CellRect(ACol, ARow);
  end;

  // lName := sgOptions.CellRect(ACol, ARow);
  lName.Left := lName.Left + sgOptions.Left;
  lName.Right := lName.Right + sgOptions.Left;
  lName.Top := lName.Top + sgOptions.Top;
  lName.Bottom := lName.Bottom + sgOptions.Top;
  pnlOptionName.Left := lName.Left + 1;
  pnlOptionName.Top := lName.Top + 1;
  pnlOptionName.Width := (lName.Right + 1) - lName.Left;
  pnlOptionName.Height := (lName.Bottom + 1) - lName.Top;
  pnlOptionName.Visible := True;

  // lR := sgOptions.CellRect(ACol, ARow);
  lR.Left := lR.Left + sgOptions.Left;
  lR.Right := lR.Right + sgOptions.Left;
  lR.Top := lR.Top + sgOptions.Top;
  lR.Bottom := lR.Bottom + sgOptions.Top;
  cbOptions.Left := lR.Left + 1;
  cbOptions.Top := lR.Top + 1;
  cbOptions.Width := (lR.Right + 1) - lR.Left;
  cbOptions.Height := (lR.Bottom + 1) - lR.Top;
  cbOptions.Visible := True;
  cbOptions.SetFocus;
end;

procedure TfrmSQLOptions.Button1Click(Sender: TObject);
begin
  inherited;
  if btnApply.Enabled then
    btnApply.Click;
  Close;
end;

procedure TfrmSQLOptions.FormShow(Sender: TObject);
begin
  inherited;
  btnApply.Enabled := false;
end;

procedure TfrmSQLOptions.Button2Click(Sender: TObject);
begin
  inherited;
  ModalResult := mrCancel;
end;

end.
