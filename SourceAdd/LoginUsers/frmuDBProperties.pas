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
*  f r m u D B P r o p e r t i e s
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   April 28, 1999
*
*  Description:  This unit provides an interface for viewing
*                and changing database properties
*
*****************************************************************
* Revisions:
*
*****************************************************************}
unit frmuDBProperties;

interface

uses
  Windows, Forms, ExtCtrls, StdCtrls, Classes, Controls, zluibcClasses, ComCtrls,
  SysUtils, Dialogs, Grids, Graphics, Registry, IBDatabaseInfo, zluContextHelp,
  IBEvents, IBServices, frmuMessage, IB, IBDatabase, Db, IBCustomDataSet,
  IBQuery, Messages, frmuDlgClass;

type
  TfrmDBProperties = class(TDialog)
    TabAlias: TTabSheet;
    TabGeneral: TTabSheet;
    cbOptions: TComboBox;
    edtAliasName: TEdit;
    edtFilename: TEdit;
    gbSummaryInfo: TGroupBox;
    lblAliasName: TLabel;
    lblDBOwner: TLabel;
    lblDBPages: TLabel;
    lblFilename: TLabel;
    lblOptions: TLabel;
    lblPageSize: TLabel;
    lvSecondaryFiles: TListView;
    pgcMain: TPageControl;
    sgOptions: TStringGrid;
    stxDBOwner: TStaticText;
    stxDBPages: TStaticText;
    stxPageSize: TStaticText;
    btnSelFilename: TButton;
    pnlOptionName: TPanel;
    lblServerName: TLabel;
    stxServerName: TStaticText;
    btnApply: TButton;
    btnCancel: TButton;
    Button1: TButton;
    function  FormHelp(Command: Word; Data: Integer; var CallHelp: Boolean): Boolean;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure cbOptionsChange(Sender: TObject);
    procedure cbOptionsDblClick(Sender: TObject);
    procedure cbOptionsExit(Sender: TObject);
    procedure cbOptionsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtAliasNameChange(Sender: TObject);
    procedure sgOptionsDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure sgOptionsSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure btnSelFilenameClick(Sender: TObject);
    procedure edtFilenameChange(Sender: TObject);
    procedure SetDefaults (const readOnly, sweep, synch, dialect: String);
    procedure edtFilenameExit(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    FApplyChanges: boolean;
    FOriginalAlias: string;
    FOriginalReadOnly: string;
    FOriginalSweepInterval: string;
    FOriginalSynchMode: string;
    FOriginalSQLDialect: String;
    FAliaschanged: boolean;
    function  VerifyInputData(): boolean;
    procedure WMNCLButtonDown( var Message: TWMNCLBUTTONDOWN ); message WM_NCLBUTTONDOWN ;
  public
    sOriginalForcedWrites: string;
    sOriginalReadOnly: string;
    sOriginalSweepInterval: string;
    sOriginalSQLDialect: string;
    bOriginalConnectStatus: boolean;
    CurrSelDatabase: TibcDatabaseNode;
    CurrSelServer: TibcServerNode;
end;

function EditDBProperties(const CurrSelServer: TibcServerNode; var CurrSelDatabase: TibcDatabaseNode): integer;

implementation

uses
  zluGlobal, zluUtility,frmuMain, IBErrorCodes;

{$R *.DFM}

const
  OPTION_NAME_COL = 0;
  OPTION_VALUE_COL = 1;
  FORCED_WRITES_ROW = 0;
  SWEEP_INTERVAL_ROW = 1;
  READ_ONLY_ROW = 3;
  SQL_DIALECT_ROW = 2;
  FORCED_WRITES_TRUE = 'Enabled';
  FORCED_WRITES_FALSE = 'Disabled';
  READ_ONLY_TRUE = 'True';
  READ_ONLY_FALSE = 'False';
  SWEEP_INTERVAL_MIN = 0;
  SWEEP_INTERVAL_MAX = 200000;
  SQL_DIALECT1 = '1';
  SQL_DIALECT2 = '2';
  SQL_DIALECT3 = '3';

{****************************************************************
*
*  F o r m C r e a t e
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   April 28, 1999
*
*  Input: Sender - The object that initiated the event
*
*  Return:
*
*  Description:  This procedure creates an instance of the TfrmDBProperties
*                class and fills in some properties
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmDBProperties.FormCreate(Sender: TObject);
begin
  inherited;
  FApplyChanges := false;
  FAliasChanged := false;
  sgOptions.DefaultRowHeight := cbOptions.Height;
  sgOptions.RowCount := 4;
  sgOptions.Cells[OPTION_NAME_COL,FORCED_WRITES_ROW] := 'Forced Writes';
  sgOptions.Cells[OPTION_NAME_COL,SWEEP_INTERVAL_ROW] := 'Sweep Interval';
  sgOptions.Cells[OPTION_NAME_COL,SQL_DIALECT_ROW] := 'Database Dialect';
  sgOptions.Cells[OPTION_NAME_COL,READ_ONLY_ROW] := 'Read Only';

  cbOptions.Visible := True;
  pnlOptionName.Visible := True;
  btnApply.Enabled := false;
end;

{****************************************************************
*
*  F o r m H e l p
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   April 28, 1999
*
*  Input: ignored
*
*  Return: result of WinHelp call, True if successful
*
*  Description:  Captures the Help event and instead displays
*                a particular topic in a new window.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function TfrmDBProperties.FormHelp(Command: Word; Data: Integer;
  var CallHelp: Boolean): Boolean;
begin
  CallHelp := False;
  Result := WinHelp(WindowHandle,CONTEXT_HELP_FILE,HELP_CONTEXT,DATABASE_PROPERTIES);
end;

{****************************************************************
*
*  F o r m S h o w
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   April 28, 1999
*
*  Input: Sender - The object that initiated the event
*
*  Return:
*
*  Description:  Assigns initial values of editable form items
*                for use in determining if changes are made and
*                if the user enters valid combinations of input.
*                Sets up the combobox to prevent blank string grid
*                cells from occurring.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmDBProperties.FormShow(Sender: TObject);
begin
  FOriginalAlias := edtAliasName.Text;
  pnlOptionName.Caption := 'Forced Writes';
  cbOptions.Style := csDropDown;
  cbOptions.Items.Add(FORCED_WRITES_TRUE);
  cbOptions.Items.Add(FORCED_WRITES_FALSE);
  cbOptions.ItemIndex := cbOptions.Items.IndexOf(FOriginalSynchMode);
  cbOptions.Tag := FORCED_WRITES_ROW;
  btnApply.Enabled := false;
  FAliasChanged := false;
end;

{****************************************************************
*
*  b t n A p p l y C l i c k
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   April 28, 1999
*
*  Input: Sender - The object that initiated the event
*
*  Return:
*
*  Description:  This procedure verifies user entries and closes the
*                form when the user clicks on the Apply button
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmDBProperties.btnApplyClick(Sender: TObject);
var
  lRegistry: TRegistry;
  i: integer;
  lConfigService: TIBConfigService;

begin
  if VerifyInputData() then
  begin
    Screen.Cursor := crHourGlass;
    // save alias and database file information
    lRegistry := TRegistry.Create;
    lConfigService := TIBConfigService.Create(self);

    CurrSelDatabase.DatabaseFiles.Clear;
    CurrSelDatabase.DatabaseFiles.Add(edtFilename.Text);

    for i := 0 to lvSecondaryFiles.Items.Count-1 do
      CurrSelDatabase.DatabaseFiles.Add(lvSecondaryFiles.Items[i].Caption);

    if lRegistry.OpenKey(Format('%s%s\Databases\%s',[gRegServersKey,CurrSelServer.NodeName,CurrSelDatabase.NodeName]),false) then
    begin
      lRegistry.WriteString('DatabaseFiles',CurrSelDatabase.DatabaseFiles.Text);
      lRegistry.CloseKey();
      lRegistry.MoveKey(Format('%s%s\Databases\%s',[gRegServersKey,CurrSelServer.NodeName,CurrSelDatabase.NodeName]),
        Format('%s%s\Databases\%s',[gRegServersKey,CurrSelServer.NodeName, edtAliasName.Text]), true);
    end;

    CurrSelDatabase.NodeName := edtAliasName.Text;
    frmMain.RenameTreeNode(CurrSelDatabase, edtAliasName.Text);

    // Set properties if general tab was shown

    if TabGeneral.TabVisible then
    begin
      try  // try to connect to configuration service
        lConfigService.DatabaseName := CurrSelDatabase.Database.DatabaseName;
        lConfigService.LoginPrompt := false;
        lConfigService.ServerName := CurrSelServer.Servername;
        lConfigService.Protocol := CurrSelServer.Server.Protocol;
        lConfigService.Params.Add(Format('isc_spb_user_name=%s', [CurrSelDatabase.UserName]));
        lConfigService.Params.Add(Format('isc_spb_password=%s', [CurrSelDatabase.Password]));
        lConfigService.Attach();
      except
        on E:EIBError do
        begin
          DisplayMsg(ERR_SERVER_LOGIN, E.Message);
          if (E.IBErrorCode = isc_lost_db_connection) or
             (E.IBErrorCode = isc_unavailable) or
             (E.IBErrorCode = isc_network_error) then
            frmMain.SetErrorState;
          SetErrorState;
          Screen.Cursor := crDefault;
          Exit;
        end;
      end;

      if lConfigService.Active then // if attached successfully
      begin
        try
          // Toggle Read-Only first if changing from Read_Only
          if ((sgOptions.Cells[OPTION_VALUE_COL,READ_ONLY_ROW] <> sOriginalReadOnly) and
           (sOriginalReadOnly = READ_ONLY_TRUE))   then
          begin
            CurrSelDatabase.Database.Connected := False;  // need to disconnect from database
            if not lConfigService.Active then
              lConfigService.Attach();

            if lConfigService.Active then  // if attached successfully
            begin
              lConfigService.SetReadOnly(False);  // toggle original value
              CurrSelDatabase.Database.Connected := bOriginalConnectStatus;
            end;
          end; // end if read-only changed

          // Set sweep interval if changed
          if sgOptions.Cells[OPTION_VALUE_COL,SWEEP_INTERVAL_ROW] <> sOriginalSweepInterval then
          begin
            lConfigService.SetSweepInterval(StrToInt(sgOptions.Cells[OPTION_VALUE_COL,SWEEP_INTERVAL_ROW]));
            while (lConfigService.IsServiceRunning) and (not gApplShutdown) do
              Application.ProcessMessages;
          end;

          // Set SQL Dialect if changed
          if sgOptions.Cells[OPTION_VALUE_COL,SQL_DIALECT_ROW] <> sOriginalSQLDialect then
          begin
            try
              lConfigService.SetDBSqlDialect (StrToInt(sgOptions.Cells[OPTION_VALUE_COL,SQL_DIALECT_ROW]));
              while (lConfigService.IsServiceRunning) and (not gApplShutdown) do
                Application.ProcessMessages;
            except
              on E : EIBError do
              begin
                DisplayMsg(ERR_SERVICE, E.Message);
                if (E.IBErrorCode = isc_lost_db_connection) or
                   (E.IBErrorCode = isc_unavailable) or
                   (E.IBErrorCode = isc_network_error) then
                  frmMain.SetErrorState;
                SetErrorState;
                Screen.Cursor := crDefault;
                exit;
              end;
            end;
          end;

          // Set forced writes if changed
          if sgOptions.Cells[OPTION_VALUE_COL,FORCED_WRITES_ROW] <> sOriginalForcedWrites then
          begin
            lConfigService.SetAsyncMode(sOriginalForcedWrites = FORCED_WRITES_TRUE);  // toggle original value
            while (lConfigService.IsServiceRunning) and (not gApplShutdown) do
              Application.ProcessMessages;
          end;

          // Toggle read only if changed
          if ((sgOptions.Cells[OPTION_VALUE_COL,READ_ONLY_ROW] <> sOriginalReadOnly) and
           (sOriginalReadOnly = READ_ONLY_FALSE)) then
          begin
            CurrSelDatabase.Database.Connected := False;  // need to disconnect from database
            try
              if not lConfigService.Active then
                lConfigService.Attach();
            except
              on E : EIBError do
              begin
                DisplayMsg(ERR_SERVER_LOGIN, E.Message);
                if (E.IBErrorCode = isc_lost_db_connection) or
                   (E.IBErrorCode = isc_unavailable) or
                   (E.IBErrorCode = isc_network_error) then
                begin
                  frmMain.SetErrorState;
                  SetErrorState;
                end
                else
                  CurrSelDatabase.Database.Connected := True;
                Screen.Cursor := crDefault;
                Exit;
              end;
            end;
            try
              if lConfigService.Active then               // if attached successfully
              begin
                lConfigService.SetReadOnly(True);         // toggle original value
                CurrSelDatabase.Database.Connected := bOriginalConnectStatus;
              end;
            except
              on E : EIBError do
              begin
                DisplayMsg(ERR_SERVER_LOGIN, E.Message);
                if (E.IBErrorCode = isc_lost_db_connection) or
                   (E.IBErrorCode = isc_unavailable) or
                   (E.IBErrorCode = isc_network_error) then
                begin
                  frmMain.SetErrorState;
                  SetErrorState;
                end
                else
                  // reconnect to database if an exception occurs
                  CurrSelDatabase.Database.Connected := True;
                Screen.Cursor := crDefault;
                Exit;
              end;
            end;
          end; // end if read-only changed
        except
          on E : EIBError do
          begin
            DisplayMsg(ERR_MODIFY_DB_PROPERTIES, E.Message);
            Screen.Cursor := crDefault;
            Exit;
          end;
        end;

      end; // end successful service start
      if lConfigService.Active then
        lConfigService.Detach();  // finally detach
      Screen.Cursor := crDefault;
    end;  // end if connected
  end;  // end if VerifyData
end;

{****************************************************************
*
*  b t n C a n c e l C l i c k
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   April 28, 1999
*
*  Input: Sender - The object that initiated the event
*
*  Return:
*
*  Description:  This procedure returns a ModalResult of mrCancel
*                whent the user presses the Cancel button, btnCancel
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmDBProperties.btnCancelClick(Sender: TObject);
begin
  Cursor := crHourGlass;
  btnApply.Click;
  Cursor := crHourGlass;
  ModalResult := mrOK;
end;

{****************************************************************
*
*  c b O p t i o n s C h a n g e
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   April 28, 1999
*
*  Input: Sender - The object that initiated the event
*
*  Return:
*
*  Description:  This procedure handles changes to the text of the
*                options combo box.  It calls the function NoteChanges
*                to look for and prepare the form to accept changes
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmDBProperties.cbOptionsChange(Sender: TObject);
begin
  FApplyChanges := True;
  btnApply.Enabled := True;
end;

{****************************************************************
*
*  c b O p t i o n s D b l C l i c k
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   April 28, 1999
*
*  Input: Sender - The object that initiated the event
*
*  Return:
*
*  Description:  Flips through the items in the combo box,
*                assigning the next value or the first one when the
*                last item is reached.  Notifies the form that changes
*                may have been made via NoteChanges.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmDBProperties.cbOptionsDblClick(Sender: TObject);
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
  FApplyChanges := True;
  btnApply.Enabled := True;
end;

{****************************************************************
*
*  c b O p t i o n s E x i t
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   April 28, 1999
*
*  Input: Sender - The object that initiated the event
*
*  Return:
*
*  Description:  This procedure adjusts the appearance of the form
*                when the user selects another object on the form
*                while cbOptions has focus.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmDBProperties.cbOptionsExit(Sender: TObject);
var
  lR     : Trect;
  iIndex : Integer;
begin
  iIndex := cbOptions.Items.IndexOf(cbOptions.Text);

  if (iIndex = -1) and (sgOptions.Row <> SWEEP_INTERVAL_ROW) then
  begin
    MessageDlg('Invalid option value', mtError, [mbOK], 0);

    cbOptions.ItemIndex := 0;
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
    cbOptions.Visible := True;
    cbOptions.SetFocus;
  end
  else if (sgOptions.Row = SWEEP_INTERVAL_ROW) then
  begin
    sgOptions.Cells[OPTION_VALUE_COL,sgOptions.Row] := cbOptions.Text;
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
*  c b O p t i o n s K e y D o w n
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   April 28, 1999
*
*  Input: Sender - The object that initiated the event
*
*  Return:
*
*  Description: Enables the user to use the keyboard to select
*               items from the combo box.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmDBProperties.cbOptionsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_DOWN) then
    cbOptions.DroppedDown := true;
end;

{****************************************************************
*
*  e d t A l i a s N a m e C h a n g e
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   April 28, 1999
*
*  Input: Sender - The object that initiated the event
*
*  Return:
*
*  Description:  Notifies the form that changes may have been made.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmDBProperties.edtAliasNameChange(Sender: TObject);
begin
  FAliasChanged := true;
  FApplyChanges := True;
  btnApply.Enabled := True;
  edtAliasName.Hint := edtAliasName.Text;
end;

{****************************************************************
*
*  s g O p t i o n s D r a w C e l l
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   April 28, 1999
*
*  Input: Sender - The object that initiated the event
*
*  Return:
*
*  Description:
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmDBProperties.sgOptionsDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
const
  INDENT = 2;
var
  lLeft: integer;
  lText: string;
begin
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

{****************************************************************
*
*  s g O p t i o n s S e l e c t C e l l
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   April 28, 1999
*
*  Input: Sender - The object that initiated the event
*
*  Return:
*
*  Description:  This procedure prepares the combobox cbOptions
*                and inserts it into the selected cell.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmDBProperties.sgOptionsSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
var
  lR, lName : TRect;
begin
  cbOptionsExit(Sender);
  cbOptions.Items.Clear;

  case ARow of
    FORCED_WRITES_ROW:
    begin
      cbOptions.Style := csDropDown;
      cbOptions.Items.Add(FORCED_WRITES_TRUE);
      cbOptions.Items.Add(FORCED_WRITES_FALSE);
      cbOptions.Tag := FORCED_WRITES_ROW;
    end;
    SWEEP_INTERVAL_ROW:
    begin
      cbOptions.Style := csSimple;
      cbOptions.Text := sgOptions.Cells[OPTION_VALUE_COL,SWEEP_INTERVAL_ROW];
      cbOptions.Tag := SWEEP_INTERVAL_ROW;
    end;
    READ_ONLY_ROW:
    begin
      cbOptions.Style := csDropDown;
      cbOptions.Items.Add(READ_ONLY_TRUE);
      cbOptions.Items.Add(READ_ONLY_FALSE);
      cbOptions.Tag := READ_ONLY_ROW;
    end;
    SQL_DIALECT_ROW:
    begin
      cbOptions.Style := csDropDown;
      cbOptions.Items.Add(SQL_DIALECT1);
      cbOptions.Items.Add(SQL_DIALECT2);
      cbOptions.Items.Add(SQL_DIALECT3);
      cbOptions.ItemIndex := StrToInt(FOriginalSQLDialect)-1;
      cbOptions.Tag := SQL_DIALECT_ROW;
    end;
  end;

  pnlOptionName.Caption := sgOptions.Cells[OPTION_NAME_COL, ARow];

  if ACol = OPTION_NAME_COL then
    cbOptions.ItemIndex := cbOptions.Items.IndexOf(sgOptions.Cells[ACOL+1,ARow])
  else if ACol = OPTION_VALUE_COL then
  begin
    cbOptions.ItemIndex := cbOptions.Items.IndexOf(sgOptions.Cells[ACol,ARow]);
    if (cbOptions.ItemIndex = -1) or (ARow = SWEEP_INTERVAL_ROW) then
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

{****************************************************************
*
*  V e r i f y I n p u t D a t a
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   April 28, 1999
*
*  Input: none
*
*  Return:  Returns TRUE if all data is valid.  Returns FALSE if
*           any data (Sweep Interval particularly) is invalid,
*           or if an invalid combination of values has been provided.
*
*  Description:  This function verifies that valid values have been
*                provided by the user.
*
*****************************************************************
* Revisions:
*
*****************************************************************}

function TfrmDBProperties.VerifyInputData(): boolean;
begin
  result := true;  // only if no exceptions raised

  if FAliasChanged and frmMain.AliasExists (edtAliasName.Text) then
  begin
    DisplayMsg(ERR_ALIAS_EXISTS, '');
    edtAliasName.text := FOriginalAlias;
    result := false;
    FAliasChanged := false;
  end;
  
  if TabGeneral.Visible then
  try
    if (StrToInt(sgOptions.Cells[OPTION_VALUE_COL,SWEEP_INTERVAL_ROW]) < SWEEP_INTERVAL_MIN) or
       (StrToInt(sgOptions.Cells[OPTION_VALUE_COL,SWEEP_INTERVAL_ROW]) > SWEEP_INTERVAL_MAX) then
      raise ERangeError.Create('The Sweep Interval must be a value from ' + IntToStr(SWEEP_INTERVAL_MIN) +
                 ' to ' + IntToStr(SWEEP_INTERVAL_MAX) + '.  Please enter a valid sweep interval value.');
    if ((FOriginalReadOnly = READ_ONLY_TRUE) and
       (sgOptions.Cells[OPTION_VALUE_COL,READ_ONLY_ROW] = READ_ONLY_TRUE) and
       ((sgOptions.Cells[OPTION_VALUE_COL,SWEEP_INTERVAL_ROW] <> FOriginalSweepInterval) or
       (sgOptions.Cells[OPTION_VALUE_COL,READ_ONLY_ROW] = FOriginalReadOnly))) then
      raise EPropReadOnly.Create('Database Properties cannot be changed while the database is read-only.');
    Exit;
  except
    on E:EConvertError do
    begin
      DisplayMsg(ERR_INVALID_PROPERTY_VALUE, 'Sweep Interval: ' + E.Message );
      result := false;
    end;
    on E:ERangeError do
    begin
      DisplayMsg(ERR_NUMERIC_VALUE, E.Message );
      result := false;
    end;
    on E:EPropReadOnly do
    begin
      DisplayMsg(ERR_INVALID_PROPERTY_VALUE,E.Message);
      result := false;
    end;
  end;
end;

{*******************************************************************
*
* E d i t D B P r o p e r t i e s ( )
*
********************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   April 28, 1999
*
*  Input:  CurrSelServer : TibcServerNode, the current server node
           CurrSelDatabase : TibcDatabaseNode, the current database
*
*  Return: integer - a status code indicating the success/failure
*                    of the operation.
*
*  Description: This procedure creates and displays the database
*               properties form.  The user can then view and make
*               changes to the properties.  When the user closes
*               the form, the function then tests for any changes and
*               applies them to the database.  Finally, the
*               form and all supporting IB objects are destroyed.
*
********************************************************************
* Revisions:
*
********************************************************************}
function EditDBProperties(const CurrSelServer: TibcServerNode; var CurrSelDatabase: TibcDatabaseNode): integer;
var
  frmDBProperties: TfrmDBProperties;
  lRegistry: TRegistry;
  lSubKeys: TStringList;
  lIBDBInfo: TIBDatabaseInfo;
  lConfigService: TIBConfigService;
  lListItem: TListItem;
  qryDBProperties: TIBQuery;
  sOriginalForcedWrites: string;
  sOriginalReadOnly: string;
  sOriginalSweepInterval: string;
  sOriginalSQLDialect: string;
  bOriginalConnectStatus: boolean;
begin
  frmDBProperties := TfrmDBProperties.Create(Application);
  lRegistry := TRegistry.Create();
  lSubKeys := TStringList.Create();
  lIBDBInfo := TIBDatabaseInfo.Create(frmDBProperties);
  lConfigService := TIBConfigService.Create(frmDBProperties);
  qryDBProperties := TIBQuery.Create(frmDBProperties);
  try
    frmDBProperties.edtAliasName.Text := CurrSelDatabase.NodeName;
    frmDBProperties.edtFilename.Text := CurrSelDatabase.DatabaseFiles.Strings[0];
    frmDBProperties.stxServerName.Caption := CurrSelServer.NodeName;

    if CurrSelServer.Server.Protocol <> Local then
      frmDBProperties.btnSelFilename.Enabled := false;

    bOriginalConnectStatus := CurrSelDatabase.Database.Connected;
    if not CurrSelDatabase.Database.Connected then
      frmDBProperties.TabGeneral.TabVisible := false
    else
    begin  // retrieve database properties
      frmDBProperties.edtFileName.Enabled := false;
      frmDBProperties.btnSelFilename.Enabled := false;
      lIBDBInfo.Database := CurrSelDatabase.Database;                       // assign selected database to db info object
      frmDBProperties.stxPageSize.Caption := IntToStr(lIBDBInfo.PageSize);  // get page size from ib info object
      frmDBProperties.stxDBPages.Caption := IntToStr(lIBDBInfo.Allocation); // get number of pages allocated
      sOriginalSweepInterval := IntToStr(lIBDBInfo.SweepInterval);
      frmDBProperties.sgOptions.Cells[OPTION_VALUE_COL,SWEEP_INTERVAL_ROW] := sOriginalSweepInterval;

      if lIBDBInfo.ForcedWrites <> 0 then    // True
        sOriginalForcedWrites := FORCED_WRITES_TRUE
      else                                   // False
        sOriginalForcedWrites := FORCED_WRITES_FALSE;

      frmDBProperties.sgOptions.Cells[OPTION_VALUE_COL,FORCED_WRITES_ROW] := sOriginalForcedWrites;

      if lIBDBInfo.ReadOnly <> 0 then        // True
        sOriginalReadOnly := READ_ONLY_TRUE
      else                                   // False
        sOriginalReadOnly := READ_ONLY_FALSE;

      frmDBProperties.sgOptions.Cells[OPTION_VALUE_COL,READ_ONLY_ROW] := sOriginalReadOnly;

      sOriginalSQLDialect := IntToStr(lIBDBInfo.DBSQLDialect);
      frmDBProperties.sgOptions.Cells[OPTION_VALUE_COL,SQL_DIALECT_ROW] := sOriginalSQLDialect;

      if not CurrSelDatabase.Database.DefaultTransaction.InTransaction then
        CurrSelDatabase.Database.DefaultTransaction.StartTransaction;

      // Set the defaults for the database properties
      frmDBProperties.SetDefaults (sOriginalReadOnly, sOriginalSweepInterval, sOriginalForcedWrites, sOriginalSQLDialect);
      with qryDBProperties do
      begin
        Close;
        Database := CurrSelDatabase.Database;
        Transaction := CurrSelDatabase.Database.DefaultTransaction;
        SQL.Clear;
        SQL.Add('SELECT RDB$FILE_NAME, RDB$FILE_START FROM RDB$FILES ' +
                'WHERE RDB$SHADOW_NUMBER IS NULL OR RDB$SHADOW_NUMBER < 1 ' +
                'ORDER BY RDB$FILE_SEQUENCE ASC');
        try
          Open;
          First;
          while not eof do
          begin
            lListItem := frmDBProperties.lvSecondaryFiles.Items.Add;
            lListItem.Caption := qryDBProperties.Fields[0].AsString;
            lListItem.SubItems.Add(qryDBProperties.Fields[1].AsString);
            Next;
          end;
        except
          on e:EIBError do
          begin
            lListItem := frmDBProperties.lvSecondaryFiles.Items.Add;
            lListItem.Caption := 'Not Available';
            lListItem.SubItems.Add('Not Available');
            DisplayMsg(ERR_GET_TABLE_DATA,E.Message + ' Secondary files unavailable.');
          end;
        end;
        Close;
        if not CurrSelDatabase.Database.DefaultTransaction.InTransaction then
          CurrSelDatabase.Database.DefaultTransaction.StartTransaction;
        Transaction := CurrSelDatabase.Database.DefaultTransaction;
        SQL.Clear;
        SQL.Add('SELECT RDB$OWNER_NAME FROM RDB$RELATIONS ' +
                'WHERE RDB$RELATION_NAME = ''RDB$DATABASE'' ');
        try
          Open;
          First;
          frmDBProperties.stxDBOwner.Caption := Fields[0].AsString;
        except
          on E:EIBError do
          begin
            frmDBProperties.stxDBOwner.Caption := 'Not Available';
            DisplayMsg(ERR_GET_TABLE_DATA,E.Message + ' Database owner unavailable.');
          end;
        end;
        Close;
      end; // with qryDBProperties
    end; // retrieve database properties
    frmDBProperties.CurrSelDatabase := CurrSelDatabase;
    frmDBProperties.CurrSelServer := CurrSelServer;
    frmDBProperties.sOriginalForcedWrites := sOriginalForcedWrites;
    frmDBProperties.sOriginalReadOnly := sOriginalReadOnly;
    frmDBProperties.sOriginalSweepInterval := sOriginalSweepInterval;
    frmDBProperties.sOriginalSQLDialect := sOriginalSQLDialect;
    frmDBProperties.bOriginalConnectStatus := bOriginalConnectStatus;

    frmDBProperties.ShowModal;
    Application.ProcessMessages;
    result := SUCCESS;
    
  finally
    Screen.Cursor := crDefault;
    qryDBProperties.Free;
    lConfigService.Free;
    lIBDBInfo.Free;
    frmDBProperties.Free;
    lSubKeys.Free;
    lRegistry.Free;
  end;
end;

procedure TfrmDBProperties.btnSelFilenameClick(Sender: TObject);
var
  lOpenDialog: TOpenDialog;
begin
  lOpenDialog := nil;
  try
  begin
    lOpenDialog := TOpenDialog.Create(self);
    // setup Open Dialog title, extension, filters and options
    lOpenDialog.Title := 'Select Database';
    lOpenDialog.DefaultExt := 'gdb';
    lOpenDialog.Filter := 'Database File (*.gdb)|*.GDB|All files (*.*)|*.*';
    lOpenDialog.Options := [ofHideReadOnly,ofNoNetworkButton, ofEnableSizing];
    if lOpenDialog.Execute then
    begin
      // get filename
      edtFilename.Text := lOpenDialog.FileName;
      // if no dbalias is specified then make it the name of the file
      if (edtAliasName.Text = '') or (edtAliasName.Text = ' ') then
      begin
        edtAliasName.Text := ExtractFileName(edtFilename.Text);
        if (edtAliasName.Text = '') or (edtAliasName.Text = ' ') then
        begin
          edtAliasName.Text := ExtractFileName(edtFilename.Text);
        end;
      end;
    end;
  end
  finally
    lOpenDialog.free;
  end;
end;

procedure TfrmDBProperties.edtFilenameChange(Sender: TObject);
begin
  FApplyChanges := True;
  btnApply.Enabled := True;
  edtFilename.Hint := edtFilename.Text;
end;

procedure TfrmDBProperties.WMNCLButtonDown( var Message: TWMNCLButtonDown );
var
  ScreenPt: TPoint;
  ClientPt: TPoint;
begin
  ScreenPt.X := Message.XCursor;
  ScreenPt.Y := Message.YCursor;
  ClientPt := ScreenToClient( ScreenPt );
  if( ClientPt.X > Width-45 )and (ClientPt.X < Width-29) then
   begin
    WinHelp(WindowHandle,CONTEXT_HELP_FILE,HELP_CONTEXT,DATABASE_PROPERTIES);
    Message.Result := 0;
  end else
   inherited;
end;

procedure TfrmDBProperties.SetDefaults(const readOnly, sweep, synch,
  dialect: String);
begin

  FOriginalReadOnly := readOnly;
  FOriginalSweepInterval := Sweep;
  FOriginalSynchMode := synch;
  FOriginalSQLDialect := dialect;

end;

procedure TfrmDBProperties.edtFilenameExit(Sender: TObject);
begin
  inherited;
  if not (IsValidDBName(edtFilename.text)) then
     DisplayMsg(WAR_REMOTE_FILENAME, Format('File: %s', [edtFileName.text]));
end;

procedure TfrmDBProperties.Button1Click(Sender: TObject);
begin
  inherited;
  ModalResult := mrCancel;
end;

end.
