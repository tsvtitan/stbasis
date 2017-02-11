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
*  f r m u D B R e s t o r e
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Description:  This unit provides an interface for performing
*                a database restore
*
*****************************************************************
* Revisions:
*
*****************************************************************}
unit frmuDBRestore;
                  
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, zluibcClasses, Grids, IB, IBQuery, frmuDlgClass;

type
  TfrmDBRestore = class(TDialog)
    gbDatabaseFiles: TGroupBox;
    lblDestinationServer: TLabel;
    lblDBAlias: TLabel;
    sgDatabaseFiles: TStringGrid;
    cbDBServer: TComboBox;
    cbDBAlias: TComboBox;
    imgDownArrow: TImage;
    gbBackupFiles: TGroupBox;
    lblBackupServer: TLabel;
    lblBackupAlias: TLabel;
    stxBackupServer: TStaticText;
    sgBackupFiles: TStringGrid;
    cbBackupAlias: TComboBox;
    lblOptions: TLabel;
    sgOptions: TStringGrid;
    btnOK: TButton;
    btnCancel: TButton;
    pnlOptionName: TPanel;
    cbOptions: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure cbOptionsChange(Sender: TObject);
    procedure cbOptionsDblClick(Sender: TObject);
    procedure cbOptionsExit(Sender: TObject);
    procedure cbOptionsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtDestinationDBChange(Sender: TObject);
    procedure edtSourceDBChange(Sender: TObject);
    procedure sgBackupFilesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure sgDatabaseFilesDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure sgDatabaseFilesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure sgOptionsDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure sgOptionsSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure cbDBServerChange(Sender: TObject);
    procedure cbDBAliasChange(Sender: TObject);
    procedure cbBackupAliasChange(Sender: TObject);
    function FormHelp(Command: Word; Data: Integer; var CallHelp: Boolean): Boolean;
    procedure IncreaseRows(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
  private
    { Private declarations }
    FVerboseFile: string;

    FSourceServerNode: TibcServerNode;
    function VerifyInputData(): boolean;
    procedure WMNCLButtonDown( var Message: TWMNCLBUTTONDOWN ); message WM_NCLBUTTONDOWN ;
  public
    { Public declarations }
    FFileList: TStringList;
  end;

function DoDBRestore(const SourceServerNode: TibcServerNode;
                     const SourceBackupAliasNode: TibcTreeNode): integer;

implementation

uses zluGlobal,frmuServerRegister,IBServices,frmuMessage,
  frmuMain, zluUtility, dmuMain, zluContextHelp, Registry, IBErrorCodes;

{$R *.DFM}

const
  OPTION_NAME_COL = 0;
  OPTION_VALUE_COL = 1;
  PAGE_SIZE_ROW = 0;
  OVERWRITE_ROW = 1;
  COMMIT_EACH_TABLE_ROW = 2;
  CREATE_SHADOW_FILES_ROW = 3;
  DEACTIVATE_INDICES_ROW = 4;
  VALIDITY_CONDITIONS_ROW = 5;
  USE_ALL_SPACE_ROW = 6;
  VERBOSE_OUTPUT_ROW = 7;

{****************************************************************
*
*  F o r m C r e a t e ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  Sender - The object that initiated the event
*
*  Return: None
*
*  Description: Ths procedure intializes the form's controls when
*               the form is initially created.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmDBRestore.FormCreate(Sender: TObject);
begin
  inherited;
  FFileList := TStringList.Create;
  sgOptions.DefaultRowHeight := cbOptions.Height;
  cbOptions.Visible := True;
  pnlOptionName.Visible := True;

  sgBackupFiles.Cells[0,0] := 'Filename(s)';

  sgDatabaseFiles.Cells[0,0] := 'Filename(s)';
  sgDatabaseFiles.Cells[1,0] := 'Pages';

  sgOptions.RowCount := 8;

  sgOptions.Cells[OPTION_NAME_COL,PAGE_SIZE_ROW] := 'Page Size (Bytes)';
  sgOptions.Cells[OPTION_VALUE_COL,PAGE_SIZE_ROW] := '1024';

  sgOptions.Cells[OPTION_NAME_COL,OVERWRITE_ROW] := 'Overwrite';
  sgOptions.Cells[OPTION_VALUE_COL,OVERWRITE_ROW] := 'False';

  sgOptions.Cells[OPTION_NAME_COL,COMMIT_EACH_TABLE_ROW] := 'Commit After Each Table';
  sgOptions.Cells[OPTION_VALUE_COL,COMMIT_EACH_TABLE_ROW] := 'False';

  sgOptions.Cells[OPTION_NAME_COL,CREATE_SHADOW_FILES_ROW] := 'Create Shadow Files';
  sgOptions.Cells[OPTION_VALUE_COL,CREATE_SHADOW_FILES_ROW] := 'True';

  sgOptions.Cells[OPTION_NAME_COL,DEACTIVATE_INDICES_ROW] := 'Deactivate Indices';
  sgOptions.Cells[OPTION_VALUE_COL,DEACTIVATE_INDICES_ROW] := 'False';

  sgOptions.Cells[OPTION_NAME_COL,VALIDITY_CONDITIONS_ROW] := 'Validity Conditions';
  sgOptions.Cells[OPTION_VALUE_COL,VALIDITY_CONDITIONS_ROW] := 'Restore';

  sgOptions.Cells[OPTION_NAME_COL,USE_ALL_SPACE_ROW] := 'Use All Space';
  sgOptions.Cells[OPTION_VALUE_COL,USE_ALL_SPACE_ROW] := 'False';

  sgOptions.Cells[OPTION_NAME_COL,VERBOSE_OUTPUT_ROW] := 'Verbose Output';
  sgOptions.Cells[OPTION_VALUE_COL,VERBOSE_OUTPUT_ROW] := 'To Screen';

  pnlOptionName.Caption := 'Page Size (Bytes)';
  cbOptions.Items.Add('1024');
  cbOptions.Items.Add('2048');
  cbOptions.Items.Add('4096');
  cbOptions.Items.Add('8192');
  cbOptions.ItemIndex := 0;
end;

procedure TfrmDBRestore.FormDestroy(Sender: TObject);
begin
  FFileList.Free;
end;

procedure TfrmDBRestore.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmDBRestore.btnOKClick(Sender: TObject);
var
  j: integer;
  lRestoreService: TIBRestoreService;
  lOptions: TRestoreOptions;
  lVerboseInfo: TStringList;
  Reg: TRegistry;
begin
  if VerifyInputData() then
  begin
    Screen.Cursor := crHourglass;
    lVerboseInfo := TStringList.Create;
    lRestoreService := TIBRestoreService.Create(nil);
    try
      try
        lRestoreService.LoginPrompt := false;
        lRestoreService.ServerName := FSourceServerNode.Server.ServerName;
        lRestoreService.Protocol := FSourceServerNode.Server.Protocol;
        lRestoreService.Params.Clear;
        lRestoreService.Params.Assign(FSourceServerNode.Server.Params);
        lRestoreService.Attach();
      except
        on E:EIBError do
        begin
          DisplayMsg(E.IBErrorCode, E.Message);
          Screen.Cursor := crDefault;
          if (E.IBErrorCode = isc_lost_db_connection) or
             (E.IBErrorCode = isc_unavailable) or
             (E.IBErrorCode = isc_network_error) then
            frmMain.SetErrorState;
          SetErrorState;
          Exit;
        end;
      end;

      if lRestoreService.Active = true then
      begin
        if sgOptions.Cells[OPTION_VALUE_COL,OVERWRITE_ROW] = 'True' then
        begin
          Include(lOptions, Replace);
        end
        else
        begin
          Include(lOptions, CreateNewDB);
        end;

        if sgOptions.Cells[OPTION_VALUE_COL,COMMIT_EACH_TABLE_ROW] = 'True' then
        begin
          Include(lOptions, OneRelationAtATime);
        end;

        if sgOptions.Cells[OPTION_VALUE_COL,CREATE_SHADOW_FILES_ROW] = 'False' then
        begin
          Include(lOptions, NoShadow);
        end;

        if sgOptions.Cells[OPTION_VALUE_COL,DEACTIVATE_INDICES_ROW] = 'True' then
        begin
          Include(lOptions, DeactivateIndexes);
        end;

        if sgOptions.Cells[OPTION_VALUE_COL,VALIDITY_CONDITIONS_ROW] = 'False' then
        begin
          Include(lOptions, NoValidityCheck);
        end;

        lRestoreService.Options := lOptions;
        lRestoreService.PageSize := StrToInt(sgOptions.Cells[OPTION_VALUE_COL,PAGE_SIZE_ROW]);

        if (sgOptions.Cells[OPTION_VALUE_COL,VERBOSE_OUTPUT_ROW] = 'To Screen') or
          (sgOptions.Cells[OPTION_VALUE_COL,VERBOSE_OUTPUT_ROW] = 'To File') then
        begin
          lRestoreService.Verbose := true;
        end;

        for j := 1 to sgBackupFiles.RowCount - 1 do
        begin
          if sgBackupFiles.Cells[0,j] <> '' then
            lRestoreService.BackupFile.Add(Format('%s',[sgBackupFiles.Cells[0,j]]));
        end;

        if cbDBServer.ItemIndex > -1 then
        begin
          for j := 1 to sgDatabaseFiles.RowCount - 1 do
          begin
            if not (IsValidDBName(sgDatabaseFiles.Cells[0,j])) then
              DisplayMsg(WAR_REMOTE_FILENAME, Format('File: %s', [sgDatabaseFiles.Cells[0,j]]));

            if (sgDatabaseFiles.Cells[0,j] <> '') and (sgDatabaseFiles.Cells[1,j] <> '')then
            begin
              lRestoreService.DatabaseName.Add(Format('%s=%s',[sgDatabaseFiles.Cells[0,j],sgDatabaseFiles.Cells[1,j]]));
            end
            else
            begin
              lRestoreService.DatabaseName.Add(sgDatabaseFiles.Cells[0,j]);
            end;
          end;
        end;
        Screen.Cursor := crHourGlass;
        try
          lRestoreService.ServiceStart;
          FSourceServerNode.OpenTextViewer (lRestoreService, 'Database Restore');
          while (lRestoreService.IsServiceRunning) and (not gApplShutdown) do
          begin
            Application.ProcessMessages;
            Screen.Cursor := crHourGlass;
          end;

          if lRestoreService.Active then
            lRestoreService.Detach();

          { If the database alias entered does not already exist, create it }
          if not frmMain.AliasExists (cbDBAlias.Text) then
          begin
            Reg := TRegistry.Create;
            if Reg.OpenKey(Format('%s%s\Databases\%s',[gRegServersKey, cbDBServer.Text, cbDBAlias.Text]),true) then
            begin
              Reg.WriteString('DatabaseFiles', lRestoreService.DatabaseName.Text);
              Reg.WriteString('Username', FSourceServerNode.UserName);
              Reg.CloseKey;
              Reg.Free;
              frmMain.tvMainChange(nil, nil);
            end;
          end;
          ModalResult := mrOK;          
        except
          on E: EIBError do
          begin
            DisplayMsg(E.IBErrorCode, E.Message);
            if (E.IBErrorCode = isc_lost_db_connection) or
               (E.IBErrorCode = isc_unavailable) or
               (E.IBErrorCode = isc_network_error) then
              frmMain.SetErrorState;
            SetErrorState;
          end;
        end;
      end;
    finally
      if lRestoreService.Active then
        lRestoreService.Detach();
      lRestoreService.Free();
      lVerboseInfo.Free;
      Screen.Cursor := crDefault;
    end;
  end;
end;

{****************************************************************
*
*  c b O p t i o n s C h a n g e ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  Sender - The object that initiated the event
*
*  Return: None
*
*  Description: This procedure changes the value of the selected
*               cell in the grid based on what was entered in the
*               combobox.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmDBRestore.cbOptionsChange(Sender: TObject);
var
  lSaveDialog: TSaveDialog;
begin
  lSaveDialog := nil;
  if (cbOptions.Text = 'To File') and (sgOptions.Row = VERBOSE_OUTPUT_ROW) then
  begin
    try
      lSaveDialog := TSaveDialog.Create(Self);
      lSaveDialog.Title := 'Select Verbose File';
      lSaveDialog.DefaultExt := 'txt';
      lSaveDialog.Filter := 'Text File (*.txt)|*.TXT|All files (*.*)|*.*';
      lSaveDialog.Options := [ofHideReadOnly,ofEnableSizing];
      if lSaveDialog.Execute then
      begin
        if FileExists(lSaveDialog.FileName) then
        begin
          if MessageDlg(Format('OK to overwrite %s', [lSaveDialog.FileName]),
              mtConfirmation, mbYesNoCancel, 0) <> idYes then
          begin
            cbOptions.ItemIndex := cbOptions.Items.IndexOf('To Screen');
            Exit;
          end;
        end;
        FVerboseFile := lSaveDialog.FileName;
      end
      else
        cbOptions.ItemIndex := cbOptions.Items.IndexOf('To Screen');
    finally
      lSaveDialog.free;
    end;
  end;

  {
  sgOptions.Cells[sgOptions.Col,sgOptions.Row] :=
    cbOptions.Items[cbOptions.ItemIndex];
  cbOptions.Visible := false;
  sgOptions.SetFocus;
  }
end;

{****************************************************************
*
*  c b O p t i o n s D b l C l i c k ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  Sender - The object that initiated the event
*
*  Return: None
*
*  Description: This procedure rotates the values in the combobox
*               and updates the selected cell in the grid each
*               time is is double clicked
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmDBRestore.cbOptionsDblClick(Sender: TObject);
begin
  if (sgOptions.Col = OPTION_VALUE_COL) or (sgOptions.Col = OPTION_NAME_COL) then
  begin
    if cbOptions.ItemIndex = cbOptions.Items.Count - 1 then
      cbOptions.ItemIndex := 0
    else
      cbOptions.ItemIndex := cbOptions.ItemIndex + 1;

    if sgOptions.Col = OPTION_VALUE_COL then
      sgOptions.Cells[sgOptions.Col,sgOptions.Row] := cbOptions.Items[cbOptions.ItemIndex];

    // cbOptions.Visible := True;
    // sgOptions.SetFocus;
  end;
end;

{****************************************************************
*
*  c b O p t i o n s E x i t ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  Sender - The object that initiated the event
*
*  Description: This procedure changes the value of the selected
*               cell in the grid based on what was entered in the
*               combobox.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmDBRestore.cbOptionsExit(Sender: TObject);
var
  lR : TRect;
  iIndex : Integer;
begin
  iIndex := cbOptions.Items.IndexOf(cbOptions.Text);

  if (iIndex = -1) then
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
*  c b O p t i o n s K e y D o w n ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  Sender - The object that initiated the event
*
*  Return: None
*
*  Description: This procedure drops down the combobox for the selected
*               grid cell when the <DOWN ARROW> key is pressed.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmDBRestore.cbOptionsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_DOWN) then
    cbOptions.DroppedDown := true;
end;

procedure TfrmDBRestore.edtDestinationDBChange(Sender: TObject);
begin
//  edtDestinationDB.Hint := edtDestinationDB.Text;
end;

procedure TfrmDBRestore.edtSourceDBChange(Sender: TObject);
begin
//  edtSourceDB.Hint := edtSourceDB.Text;
end;

{****************************************************************
*
*  s g B a c k u p F i l e s K e y D o w n ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  Sender - The object that initiated the event
*
*  Return: None
*
*  Description:
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmDBRestore.sgBackupFilesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_TAB) and (ssCtrl in Shift) then
  begin
    if sgBackupFiles.Col < sgBackupFiles.ColCount - 1 then
    begin
      sgBackupFiles.Col := sgBackupFiles.Col + 1;
    end
    else
    begin
      if sgBackupFiles.Row = sgBackupFiles.RowCount - 1 then
        sgBackupFiles.RowCount := sgBackupFiles.RowCount + 1;
      sgBackupFiles.Col := 0;
      sgBackupFiles.Row := sgBackupFiles.Row + 1;
    end;
  end;
end;

{****************************************************************
*
*  s g D a t a b a s e F i l e s D r a w C e l l ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  Sender - The object that initiated the event
*
*  Return: None
*
*  Description: This procedure is responsible for painting blue
*               the option value text in the string grid
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmDBRestore.sgDatabaseFilesDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
const
  INDENT = 2;
var
  lLeft: integer;
  lText: string;
begin
  with Sender as TStringGrid do //sgDatabaseFiles.canvas do
  begin
    if (ACol = 2) and (ARow <> 0) then
    begin
      canvas.font.color := clBlack;
      if canvas.brush.color = clHighlight then
        canvas.font.color := clWhite;
      lText := Cells[ACol,ARow];
      lLeft := Rect.Left + INDENT;
      Canvas.TextRect(Rect, lLeft, Rect.top + INDENT, lText);
    end;
  end;
end;

{****************************************************************
*
*  s g D a t a b a s e F i l e s K e y D o w n ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  Sender - The object that initiated the event
*
*  Return: None
*
*  Description:
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmDBRestore.sgDatabaseFilesKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  lKey : Word;
begin
  if (Key = VK_TAB) and (ssCtrl in Shift) then
  begin
    if sgDatabaseFiles.Col < sgDatabaseFiles.ColCount - 1 then
    begin
      sgDatabaseFiles.Col := sgDatabaseFiles.Col + 1;
    end
    else
    begin
      if sgDatabaseFiles.Row = sgDatabaseFiles.RowCount - 1 then
        sgDatabaseFiles.RowCount := sgDatabaseFiles.RowCount + 1;
      sgDatabaseFiles.Col := 0;
      sgDatabaseFiles.Row := sgDatabaseFiles.Row + 1;
    end;
  end;

  if (Key = VK_RETURN) and
    (sgDatabaseFiles.Cells[sgDatabaseFiles.Col,sgDatabaseFiles.Row] <> '') then
  begin
    lKey := VK_TAB;
    sgDatabaseFilesKeyDown(Self, lKey, [ssCtrl]);
  end;

end;

{****************************************************************
*
*  s g O p t i o n s D r a w C e l l ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  Sender - The object that initiated the event
*
*  Return: None
*
*  Description: This procedure is responsible for painting blue
*               the option value text in the string grid
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmDBRestore.sgOptionsDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
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
*  s g O p t i o n s S e l e c t C e l l ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  Refer to the Delphi documentation.
*
*  Return: None
*
*  Description: This procedure initializes and positions the combobox
*               depending on which cell in the grid is selected
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmDBRestore.sgOptionsSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
var
  lR, lName : TRect;
begin
  cbOptions.Items.Clear;
  case ARow of
    PAGE_SIZE_ROW:
    begin
      cbOptions.Items.Add('1024');
      cbOptions.Items.Add('2048');
      cbOptions.Items.Add('4096');
      cbOptions.Items.Add('8192');
    end;
    OVERWRITE_ROW:
    begin
      cbOptions.Items.Add('True');
      cbOptions.Items.Add('False');
    end;
    COMMIT_EACH_TABLE_ROW:
    begin
      cbOptions.Items.Add('True');
      cbOptions.Items.Add('False');
    end;
    CREATE_SHADOW_FILES_ROW:
    begin
      cbOptions.Items.Add('True');
      cbOptions.Items.Add('False');
    end;
    DEACTIVATE_INDICES_ROW:
    begin
      cbOptions.Items.Add('True');
      cbOptions.Items.Add('False');
    end;
    VALIDITY_CONDITIONS_ROW:
    begin
      cbOptions.Items.Add('Restore');
      cbOptions.Items.Add('Ignore');
    end;
    USE_ALL_SPACE_ROW:
    begin
      cbOptions.Items.Add('True');
      cbOptions.Items.Add('False');
    end;
    VERBOSE_OUTPUT_ROW:
    begin
      cbOptions.Items.Add('None');
      cbOptions.Items.Add('To Screen');
      cbOptions.Items.Add('To File');
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
*  V e r i f y I n p u t D a t a ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  None
*
*  Return: boolean - Indicates the success/failure of the operation
*
*  Description:  Performs some basic validation on data entered by
*                the user
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function TfrmDBRestore.VerifyInputData(): boolean;
var
  lCnt: integer;
  found: boolean;
  fp: string;

begin
  result := true;
  found := false;

  // check if combo box is empty or nothing selected
  if (cbDBServer.ItemIndex = -1) or (cbDBServer.Text = '') or (cbDBServer.Text = ' ') then
  begin
    DisplayMsg(ERR_SERVER_NAME,'');
    cbDBServer.SetFocus;
    result := false;
    Exit;
  end;

  // check if combo box is empty
  if (cbDBAlias.Text = '') or (cbDBAlias.Text = ' ') then
  begin
    DisplayMsg(ERR_DB_ALIAS,'');
    cbDBAlias.SetFocus;
    result := false;
    Exit;
  end;

  for lCnt := 1 to sgDatabaseFiles.RowCount - 1 do
  begin
    if (sgDatabaseFiles.Cells[0,lCnt] <> '') then
    begin
      found := true;
      fp := ExtractFilePath(sgDatabaseFiles.Cells[0,lCnt]);

      if fp = '' then
      begin
        DisplayMsg(ERR_NO_PATH, 'File: '+sgDatabaseFiles.Cells[0,lCnt]);
        sgDatabaseFiles.SetFocus;
        result := false;
        exit;
      end;
    end;
  end;

  if not found then
  begin
    DisplayMsg (ERR_NO_FILES,'');
    result := false;
    exit;
  end;

end;

{*******************************************************************
*
*  D o R e s t o r e ( )
*
********************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  SelServerNode - Identifies the selected server
*          SelTreeNode - Identifies the selected backup file
*
*  Return: None
*
*  Description: This procedure creates and displays the restore form
*               in order to capture restore information. It then
*               performs the restore and destroys the instance of
*               the form.
*
*********************************************************************
* Revisions:
*
*********************************************************************}
function DoDBRestore(const SourceServerNode: TibcServerNode;
                     const SourceBackupAliasNode: TibcTreeNode): integer;
var
  i: integer;
  frmDBRestore: TfrmDBRestore;
  lBackupAliasNode: TibcBackupAliasNode;
  lCurrBackupAliasesNode: TTreeNode;
  AliasName: String;

begin
  frmDBRestore := nil;
  lBackupAliasNode := nil;

  if SourceBackupAliasNode is TibcBackupAliasNode then
    lBackupAliasNode := TibcBackupAliasNode(SourceBackupAliasNode);
  try
    frmDBRestore := TfrmDBRestore.Create(Application);
    frmDBRestore.FSourceServerNode := SourceServerNode;
    frmDBRestore.stxBackupServer.Caption := SourceServerNode.NodeName;
    lCurrBackupAliasesNode := frmMain.tvMain.Items.GetNode(SourceServerNode.BackupFilesID);

    for i := 1 to TibcTreeNode(lCurrBackupAliasesNode.Data).ObjectList.Count - 1 do
    begin
      AliasName := TibcTreeNode(lCurrBackupAliasesNode.Data).ObjectList.Strings[i];

      frmDBRestore.cbBackupAlias.Items.AddObject(GetNextField (AliasName, DEL),
      TibcBackupAliasNode(TTreeNode(TibcTreeNode(lCurrBackupAliasesNode.Data).ObjectList.Objects[i]).Data));
    end;

    for i := 1 to TibcTreeNode(frmMain.tvMain.Items[0].Data).ObjectList.Count - 1 do
    begin
      AliasName := TibcTreeNode(frmMain.tvMain.Items[0].Data).ObjectList.Strings[i];
      frmDBRestore.cbDBServer.Items.AddObject(GetNextField(AliasName, DEL),
        TibcServerNode(TTreeNode(TibcTreeNode(frmMain.tvMain.Items[0].Data).ObjectList.Objects[i]).Data));
    end;

    if Assigned(SourceBackupAliasNode) then
    begin
      frmDBRestore.cbBackupAlias.ItemIndex := frmDBRestore.cbBackupAlias.Items.IndexOf(SourceBackupAliasNode.NodeName);
      frmDBRestore.cbBackupAliasChange(frmDBRestore);

      if Assigned (lBackupAliasNode) then
      begin
        frmDBRestore.cbDBServer.ItemIndex := frmDBRestore.cbDBServer.Items.IndexOf(lBackupAliasNode.SourceDBServer);
        frmDBRestore.cbDBServerChange(frmDBRestore);
        frmDBRestore.cbDBAlias.ItemIndex := frmDBRestore.cbDBAlias.Items.IndexOf(lBackupAliasNode.SourceDBAlias);
        frmDBRestore.cbDBAliasChange(frmDBRestore);
      end;
    end;

    frmDBRestore.ShowModal;
    if (frmDBRestore.ModalResult = mrOK) and
       (not frmDBRestore.GetErrorState)then
    begin
      if Assigned (lBackupAliasNode) then
      begin
        if lBackupAliasNode.SourceDBAlias = '' then
          lBackupAliasNode.SourceDBAlias := frmDBRestore.cbDBAlias.Text;
      end;
      DisplayMsg(INF_RESTORE_DB_SUCCESS,'');
      result := SUCCESS;
    end
    else
      result := FAILURE;
  finally
    frmDBRestore.Free;
  end;
end;

procedure TfrmDBRestore.cbDBServerChange(Sender: TObject);
var
  s: string;
  i: integer;
  lCurrDatabaseAliasesNode: TTreeNode;
begin
  cbDBAlias.Items.Clear;
  cbDBAlias.Text := '';

  if cbDBServer.ItemIndex <> -1 then
  begin
    lCurrDatabaseAliasesNode := frmMain.tvMain.Items.GetNode(TibcServerNode(cbDBServer.Items.Objects[cbDBServer.ItemIndex]).DatabasesID);

    if Assigned(lCurrDatabaseAliasesNode) then
    begin
      if TibcServerNode(lCurrDatabaseAliasesNode.Data).ObjectList.Count <> 0 then
      begin
        for i := 1 to TibcServerNode(lCurrDatabaseAliasesNode.Data).ObjectList.Count - 1 do
        begin
          s := TibcTreeNode(lCurrDatabaseAliasesNode.Data).ObjectList.Strings[i];
          cbDBAlias.Items.AddObject(GetNextField(s, DEL),
            TibcDatabaseNode(TTreeNode(TibcTreeNode(lCurrDatabaseAliasesNode.Data).ObjectList.Objects[i]).Data));
        end;
      end;
    end;
  end;
end;

procedure TfrmDBRestore.cbDBAliasChange(Sender: TObject);
var
  i: integer;
  lCurrDBNode: TTreeNode;
  lCurrServerNode: TTreeNode;
  lCurrLine: string;
begin
  for i := 1 to sgDatabaseFiles.RowCount do
  begin
    sgDatabaseFiles.Cells[0,i] := '';
    sgDatabaseFiles.Cells[1,i] := '';
  end;

  if (cbDBAlias.ItemIndex > -1) and (Assigned(cbDBAlias.Items.Objects[cbDBAlias.ItemIndex])) then
    lCurrDBNode := frmMain.tvMain.Items.GetNode(TibcDatabaseNode(cbDBAlias.Items.Objects[cbDBAlias.ItemIndex]).NodeID)
  else
    lCurrDBNode := nil;

  if (cbDBAlias.ItemIndex > -1) and (Assigned(cbDBServer.Items.Objects[cbDBServer.ItemIndex])) then
    lCurrServerNode := frmMain.tvMain.Items.GetNode(TibcServerNode(cbDBServer.Items.Objects[cbDBServer.ItemIndex]).NodeID)
  else
    lCurrServerNode := nil;

  if Assigned(lCurrDBNode) and Assigned(lCurrServerNode) then
  begin

    for i := 1 to TibcDatabaseNode(lCurrDBNode.Data).DatabaseFiles.Count do
    begin
      lCurrLine := TibcDatabaseNode(lCurrDBNode.Data).DatabaseFiles.Strings[i - 1];
      while Length(lCurrLine) > 0 do
      begin
        sgDatabaseFiles.Cells[0,i] := zluUtility.GetNextField(lCurrLine,'=');
        sgDatabaseFiles.Cells[1,i] := zluUtility.GetNextField(lCurrLine,'=');
      end;
      sgDatabaseFiles.RowCount := sgDatabaseFiles.RowCount + 1;
    end;
  end;
end;

procedure TfrmDBRestore.cbBackupAliasChange(Sender: TObject);
var
  i: integer;
  lCurrBackupAliasNode: TTreeNode;
  lCurrLine: string;
  GridOptions: set of TGridOption;
  OpenDlg: TOpenDialog;
begin

  with cbBackupAlias do begin
    with sgBackupFiles do begin
      RowCount := 4;
      for i := 1 to RowCount do
      begin
        Cells[0,i] := '';
        Cells[1,i] := '';
      end;

      if ItemIndex = 0 then
        begin
        // Allow the user to select files for backup
        OnDrawCell := sgDatabaseFilesDrawCell;
        OnKeyDown := sgDatabaseFilesKeyDown;
        Color := clWindow;
        GridOptions := Options;
        Include (GridOptions, goEditing);
        Options := GridOptions;
        sgBackupFiles.SetFocus;

        // If the server is local, allow the user to browse for a file
        if FSourceServerNode.Server.Protocol = Local then
        begin
          OpenDlg := TOpenDialog.Create(Self);
          with OpenDlg do
          begin
            Options := [ofAllowMultiSelect, ofFileMustExist];
            Filter := 'Backup files (*.gbk)|*.gbk|All files (*.*)|*.*';
            FilterIndex := 1;
            if Execute then
            begin
              if RowCount < Files.Count then
                RowCount := Files.Count;

              for i:= 0 to Files.Count - 1 do
                Cells[0, i+1] := Files.Strings[i];
            end;
            Free;
          end;
        end;
      end
      else begin  // Read the alias for backup information
        if (ItemIndex > 0) and (Assigned(Items.Objects[ItemIndex])) then
        begin
          GridOptions := Options;
          Exclude (GridOptions, goEditing);
          Options := GridOptions;
          OnDrawCell := nil;
          OnKeyDown := nil;
          Color := clbtnFace;
          Row := 1;
          lCurrBackupAliasNode := frmMain.tvMain.Items.GetNode(TibcBackupAliasNode(Items.Objects[ItemIndex]).NodeID);
          for i := 1 to TibcBackupAliasNode(lCurrBackupAliasNode.Data).BackupFiles.Count do
          begin
            lCurrLine := TibcBackupAliasNode(lCurrBackupAliasNode.Data).BackupFiles.Strings[i-1];
            while Length(lCurrLine) > 0 do
            begin
              Cells[0,i] := zluUtility.GetNextField(lCurrLine,'=');
              Cells[1,i] := zluUtility.GetNextField(lCurrLine,'=');
            end;
            RowCount := RowCount + 1;
          end;
          cbDBServer.ItemIndex := cbDBServer.Items.IndexOf(TibcBackupAliasNode(lCurrBackupAliasNode.Data).SourceDBServer);
          cbDBServerChange(self);
          cbDBAlias.ItemIndex := cbDBAlias.Items.IndexOf(TibcBackupAliasNode(lCurrBackupAliasNode.Data).SourceDBAlias);
          cbDBAliasChange(self);
        end;
      end;
    end;
  end;
end;

function TfrmDBRestore.FormHelp(Command: Word; Data: Integer;
  var CallHelp: Boolean): Boolean;
begin
  CallHelp := False;
  Result := WinHelp(WindowHandle,CONTEXT_HELP_FILE,HELP_CONTEXT,DATABASE_RESTORE);
end;

procedure TfrmDBRestore.WMNCLButtonDown( var Message: TWMNCLButtonDown );
var
  ScreenPt: TPoint;
  ClientPt: TPoint;
begin
  ScreenPt.X := Message.XCursor;
  ScreenPt.Y := Message.YCursor;
  ClientPt := ScreenToClient( ScreenPt );
  if( ClientPt.X > Width-45 )and (ClientPt.X < Width-29) then
   begin
    WinHelp(WindowHandle,CONTEXT_HELP_FILE,HELP_CONTEXT,DATABASE_RESTORE);
    Message.Result := 0;
  end else
   inherited;
end;

procedure TfrmDBRestore.IncreaseRows(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  with Sender as TStringGrid do begin
    if ARow = RowCount-1 then
      RowCount := RowCount + 1;
  end;
end;

end.
