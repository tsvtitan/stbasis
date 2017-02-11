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

{****************************************************************
*
*  f r m u D B V a l i d a t i o n
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Description:  This unit provides an interface for performing
*                a database validation and repair
*
*****************************************************************
* Revisions:
*
*****************************************************************}
unit frmuDBValidation;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, zluibcClasses, zluContextHelp, IBServices, IB,
  Grids, frmuDlgClass;

type
  TfrmDBValidation = class(TDialog)
    lblDatabaseName: TLabel;
    bvlLine1: TBevel;
    lblOptions: TLabel;
    pnlOptionName: TPanel;
    sgOptions: TStringGrid;
    cbOptions: TComboBox;
    btnOK: TButton;
    btnCancel: TButton;
    stxDatabaseName: TLabel;
    function  FormHelp(Command: Word; Data: Integer; var CallHelp: Boolean): Boolean;
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure cbOptionsDblClick(Sender: TObject);
    procedure cbOptionsExit(Sender: TObject);
    procedure cbOptionsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure sgOptionsDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure sgOptionsSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
  private
    { Private declarations }
    function VerifyInputData(): boolean;
    procedure WMNCLButtonDown( var Message: TWMNCLBUTTONDOWN ); message WM_NCLBUTTONDOWN ;
  public
    { Public declarations }
  end;

function DoDBValidation(const SourceServerNode: TibcServerNode; const CurrSelDatabase: TibcDatabaseNode): integer;

implementation

uses zluGlobal, zluUtility, frmuMessage, frmuDBValidationReport,
     fileCtrl, frmuMain, IBErrorCodes;

{$R *.DFM}

const
  OPTION_NAME_COL = 0;
  OPTION_VALUE_COL = 1;
  VALIDATE_RECORD_FRAGMENTS_ROW = 0;
  READ_ONLY_VALIDATION_ROW = 1;
  IGNORE_CHECKSUM_ERRORS_ROW = 2;

{****************************************************************
*
*  D o D B V a l i d a t i o n ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  TibcServerNode  - currently selected server
*          TibcDatabseNode - currently selected database (the
*                            database to be validated)
*
*  Return: Integer - indicates success or failure
*
*  Description: Ths function performs the validatation task.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function DoDBValidation(const SourceServerNode: TibcServerNode;
  const CurrSelDatabase: TibcDatabaseNode): integer;
var
  frmDBValidation  : TfrmDBValidation;
  lValidation      : TIBValidationService;
  lValidateOptions : TValidateOptions;
  lValidationInfo  : TStringList;
  Validation_errors: boolean;
begin
  lValidationInfo := TStringList.Create;
  lValidation := TIBValidationService.Create(Nil);
  lValidateOptions := [];
  Result := SUCCESS;
  try
    try
      // assign server details
      lValidation.LoginPrompt := false;
      lValidation.ServerName := SourceServerNode.Server.ServerName;
      lValidation.Protocol := SourceServerNode.Server.Protocol;
      lValidation.Params.Clear;
      lValidation.Params.Assign(SourceServerNode.Server.Params);
      lValidation.Attach();            // try to attach to server
    except                             // if an exception occurs then trap it
      on E:EIBError do                 // and display an error message
      begin
        DisplayMsg(ERR_SERVER_LOGIN, E.Message);
        result := FAILURE;
        if (E.IBErrorCode = isc_lost_db_connection) or
           (E.IBErrorCode = isc_unavailable) or
           (E.IBErrorCode = isc_network_error) then
          frmMain.SetErrorState;
        Exit;
      end;
    end;

    // if successfully attached to server
    if lValidation.Active = true then
    begin
      frmDBValidation := TfrmDBValidation.Create(Application);
      try
        frmDBValidation.stxDatabaseName.Caption := MinimizeName (CurrSelDatabase.NodeName,
          frmDBValidation.stxDatabaseName.Canvas,
          (frmDBValidation.stxDatabaseName.ClientRect.Left - frmDBValidation.stxDatabaseName.ClientRect.Right));
        frmDBValidation.stxDatabaseName.Hint := CurrSelDatabase.NodeName;

        frmDBValidation.ShowModal;

        if (frmDBValidation.ModalResult = mrOK) and
          (not frmDBValidation.GetErrorState) then
        begin
          Screen.Cursor := crHourGlass;

          // assign database details
          case SourceServerNode.Server.Protocol of
            TCP : lValidation.DatabaseName := Format('%s:%s',[SourceServerNode.ServerName,CurrSelDatabase.DatabaseFiles.Strings[0]]);
            NamedPipe : lValidation.DatabaseName := Format('\\%s\%s',[SourceServerNode.ServerName,CurrSelDatabase.DatabaseFiles.Strings[0]]);
            SPX : lValidation.DatabaseName := Format('%s@%s',[SourceServerNode.ServerName,CurrSelDatabase.DatabaseFiles.Strings[0]]);
            Local : lValidation.DatabaseName := CurrSelDatabase.DatabaseFiles.Strings[0];
          end;

          // determine which options have been selected
          Include (lValidateOptions, ValidateDB);
          if frmDBValidation.sgOptions.Cells[1,VALIDATE_RECORD_FRAGMENTS_ROW] = 'True' then
            Include(lValidateOptions, ValidateFull);

          if frmDBValidation.sgOptions.Cells[1,READ_ONLY_VALIDATION_ROW] = 'True' then
            Include(lValidateOptions, CheckDB);

          if (frmDBValidation.sgOptions.Cells[1,IGNORE_CHECKSUM_ERRORS_ROW] = 'True') then
            Include(lValidateOptions, IgnoreChecksum);

          // assign validation options
          lValidation.Options := lValidateOptions;

          // start service
          try
            lValidation.ServiceStart;
            Application.ProcessMessages;

            // get validation report
            while not lValidation.Eof  do
              lValidationInfo.Add(Trim(lValidation.GetNextLine));

            Validation_errors := true;
            if lValidationInfo.Count = 1 then  { there is an EOL marker }
              Validation_errors := false;

            while (lValidation.IsServiceRunning) and (not gApplShutdown) do
              Application.ProcessMessages;

            if lValidation.Active then
              lValidation.Detach();

            // show the validation report form
            frmuDBValidationReport.ShowReport(lValidationInfo.Text, SourceServerNode,
              CurrSelDatabase, Validation_errors);
          except
            on E: EIBError do
            begin
              DisplayMsg(E.IBErrorCode, E.Message);
              if (E.IBErrorCode = isc_lost_db_connection) or
                 (E.IBErrorCode = isc_unavailable) or
                 (E.IBErrorCode = isc_network_error) then
                frmMain.SetErrorState;
            end;
          end;
          result := SUCCESS;
        end
        else
          result := FAILURE;
      finally
        frmDBValidation.Free;
      end;
    end;
  finally
    Screen.Cursor := crDefault;
    // detach from server and deallocate memory
    if lValidation.Active then
      lValidation.Detach();
    lValidationInfo.Free;
    lValidation.Free;
  end;
end;

procedure TfrmDBValidation.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

function TfrmDBValidation.VerifyInputData(): boolean;
var
  lValidateOptions: TValidateOptions;
  
begin
  lValidateOptions := [ValidateDB];
  // determine which options have been selected
  if sgOptions.Cells[1,VALIDATE_RECORD_FRAGMENTS_ROW] = 'True' then
    Include(lValidateOptions, ValidateFull);

  if sgOptions.Cells[1,READ_ONLY_VALIDATION_ROW] = 'True' then
    Include(lValidateOptions, CheckDB);

  if sgOptions.Cells[1,IGNORE_CHECKSUM_ERRORS_ROW] = 'True' then
    Include(lValidateOptions, IgnoreChecksum);

  result := not (lValidateOptions = []);
end;

procedure TfrmDBValidation.btnOKClick(Sender: TObject);
begin
  if VerifyInputData() then
    ModalResult := mrOK
  else
    ShowMessage ('You must specify a validation option');
end;

{****************************************************************
*
*  F r o m C r e a t e
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  TObject - Object that initiated the event
*
*  Return: None
*
*  Description: This procedure is responsible for populating
*               the string grids when the form is created.
*
*****************************************************************
* Revisions:
*
*****************************************************************}

procedure TfrmDBValidation.FormCreate(Sender: TObject);
begin
  inherited;
  sgOptions.DefaultRowHeight := cbOptions.Height;
  cbOptions.Visible := True;
  pnlOptionName.Visible := True;

  sgOptions.RowCount := 3;

  sgOptions.Cells[OPTION_NAME_COL,VALIDATE_RECORD_FRAGMENTS_ROW] := 'Validate Record Fragments';
  sgOptions.Cells[OPTION_VALUE_COL,VALIDATE_RECORD_FRAGMENTS_ROW] := 'False';

  sgOptions.Cells[OPTION_NAME_COL,READ_ONLY_VALIDATION_ROW] := 'Read Only Validation';
  sgOptions.Cells[OPTION_VALUE_COL,READ_ONLY_VALIDATION_ROW] := 'False';

  sgOptions.Cells[OPTION_NAME_COL,IGNORE_CHECKSUM_ERRORS_ROW] := 'Ignore Checksum Errors';
  sgOptions.Cells[OPTION_VALUE_COL,IGNORE_CHECKSUM_ERRORS_ROW] := 'False';

  pnlOptionName.Caption := 'Validate Record Fragments';
  cbOptions.Items.Add('True');
  cbOptions.Items.Add('False');
  cbOptions.ItemIndex := 1;  
end;

procedure TfrmDBValidation.cbOptionsExit(Sender: TObject);
var
  lR     : TRect;
  iIndex : Integer;
begin
  iIndex := cbOptions.Items.IndexOf(cbOptions.Text);

  if (iIndex = -1) then
  begin
    MessageDlg('Invalid option value', mtError, [mbOK], 0);

    cbOptions.ItemIndex := 0;
    // Size and position the combo box to fit the cell
    lR := sgOptions.CellRect(OPTION_VALUE_COL, sgOptions.Row);
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
  end
  else if (sgOptions.Col <> OPTION_NAME_COL) then
  begin
    sgOptions.Cells[sgOptions.Col,sgOptions.Row] := cbOptions.Items[iIndex];
  end
  else
  begin
    sgOptions.Cells[OPTION_VALUE_COL,sgOptions.Row] := cbOptions.Items[iIndex];
  end;
end;

{****************************************************************
*
*  s g O p t i o n s D r a w C e l l
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  TObject - Object that initiated the event
*          Integer - currently selected column
*          Integer - currently selected row
*          TRect   - coordinates
*          TGridDrawState - drawing state of grid
*
*  Return: None
*
*  Description: This procedure draws contents to a specified cell in
*               the Options string grid.
*
*****************************************************************
* Revisions:
*
*****************************************************************}

procedure TfrmDBValidation.sgOptionsDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
const
  INDENT = 2;
var
  lLeft: integer;
  lText: string;
begin
  with sgOptions.canvas do
  begin
    if (ACol = OPTION_VALUE_COL) then
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

{****************************************************************
*
*  s g O p t i o n s S e l e c t C e l l
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  TObject - Object that initiated the event
*          Integer - currently selected column
*          Integer - currently selected row
*          Boolean - indicates whether call can be selected
*
*  Return: None
*
*  Description: This procedure shows the combo box and populates
*               it when the user selects a row in the value
*               column of the options grid.
*
*****************************************************************
* Revisions:
*
*****************************************************************}

procedure TfrmDBValidation.sgOptionsSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
var
  lR, lName : TRect;
begin
  cbOptions.Items.Clear;
  case ARow of
    VALIDATE_RECORD_FRAGMENTS_ROW:
    begin
      cbOptions.Items.Add('True');
      cbOptions.Items.Add('False');
    end;
    READ_ONLY_VALIDATION_ROW:
    begin
      cbOptions.Items.Add('True');
      cbOptions.Items.Add('False');
    end;
    IGNORE_CHECKSUM_ERRORS_ROW:
    begin
      cbOptions.Items.Add('True');
      cbOptions.Items.Add('False');
    end;
  end;

  pnlOptionName.Caption := sgOptions.Cells[OPTION_NAME_COL, ARow];

  if ACol = OPTION_NAME_COL then
    cbOptions.ItemIndex := cbOptions.Items.IndexOf(sgOptions.Cells[ACol+1,ARow])
  else if ACol = OPTION_VALUE_COL then
    cbOptions.ItemIndex := cbOptions.Items.IndexOf(sgOptions.Cells[ACol,ARow]);

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

{****************************************************************
*
*  s g O p t i o n s D b l C l i c k
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  TObject - object that initiated the event
*
*  Return: None
*
*
*  Description: This procedure rotates through a list of values
*               when the option name or value is double-clicked.
*
*****************************************************************
* Revisions:
*
*****************************************************************}

procedure TfrmDBValidation.cbOptionsDblClick(Sender: TObject);
begin
  if (sgOptions.Col = OPTION_VALUE_COL) or (sgOptions.Col = OPTION_NAME_COL) then
  begin
    if cbOptions.ItemIndex = cbOptions.Items.Count - 1 then
      cbOptions.ItemIndex := 0
    else
      cbOptions.ItemIndex := cbOptions.ItemIndex + 1;

    if sgOptions.Col = OPTION_VALUE_COL then
      sgOptions.Cells[sgOptions.Col,sgOptions.Row] := cbOptions.Items[cbOptions.ItemIndex];
  end;
end;

procedure TfrmDBValidation.cbOptionsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_DOWN) then
    cbOptions.DroppedDown := true;
end;

function TfrmDBValidation.FormHelp(Command: Word; Data: Integer;
  var CallHelp: Boolean): Boolean;
begin
  CallHelp := False;
  Result := WinHelp(WindowHandle,CONTEXT_HELP_FILE,HELP_CONTEXT,DATABASE_VALIDATION);
end;

procedure TfrmDBValidation.WMNCLButtonDown( var Message: TWMNCLButtonDown );
var
  ScreenPt: TPoint;
  ClientPt: TPoint;
begin
  ScreenPt.X := Message.XCursor;
  ScreenPt.Y := Message.YCursor;
  ClientPt := ScreenToClient( ScreenPt );
  if( ClientPt.X > Width-45 )and (ClientPt.X < Width-29) then
   begin
    WinHelp(WindowHandle,CONTEXT_HELP_FILE,HELP_CONTEXT,DATABASE_VALIDATION);
    Message.Result := 0;
  end else
   inherited;
end;

end.
