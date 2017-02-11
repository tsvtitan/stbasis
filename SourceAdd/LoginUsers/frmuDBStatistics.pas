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
*  f r m u D B S t a t i s t i c s
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Description:  This unit provides an interface for selecting
*                options when displaying database statistics
*
*****************************************************************
* Revisions:
*
*****************************************************************}
unit frmuDBStatistics;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, zluibcClasses, IBServices, IB, Grids, frmuDlgClass;

type
  TfrmDBStatistics = class(TDialog)
    sgOptions: TStringGrid;
    pnlOptionName: TPanel;
    cbOptions: TComboBox;
    lblOptions: TLabel;
    lblDatabaseName: TLabel;
    bvlLine1: TBevel;
    btnOK: TButton;
    btnCancel: TButton;
    stxDatabaseName: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure cbOptionsChange(Sender: TObject);
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

function DoDBStatistics(const SourceServerNode: TibcServerNode;
                        const CurrSelDatabase: TibcDatabaseNode): integer;

implementation

uses
  zluGlobal, zluUtility, zluContextHelp, frmuMessage, fileCtrl, IBErrorCodes,
  frmuMain;

{$R *.DFM}

const
  OPTION_NAME_COL = 0;
  OPTION_VALUE_COL = 1;

  STATISTICS_OPTION_ROW = 0;

{****************************************************************
*
*  D o D B S t a t i s t i c s ( )
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
*  Description:
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function DoDBStatistics(const SourceServerNode: TibcServerNode;
  const CurrSelDatabase: TibcDatabaseNode): integer;
var
  frmDBStatistics: TfrmDBStatistics;
  lDBStatisticsData: TStringList;
  lDBStatistics: TIBStatisticalService;
  lDBStatisticsOptions: TStatOptions;

begin
  lDBStatisticsData := TStringList.Create();
  lDBStatistics := TIBStatisticalService.Create(Application);
  try
    try
      // assign server details
      lDBStatistics.LoginPrompt := false;
      lDBStatistics.ServerName := SourceServerNode.Server.ServerName;
      lDBStatistics.Protocol := SourceServerNode.Server.Protocol;
      lDBStatistics.Params.Clear;
      lDBStatistics.Params.Assign(SourceServerNode.Server.Params);
      lDBStatistics.Attach();            // try to attach to server
    except                               // if an exception occurs then trap it
      on E:EIBError do                   // and display an error message
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
    if lDBStatistics.Active = true then
    begin
      frmDBStatistics := TfrmDBStatistics.Create(Application);
      try
        frmDBStatistics.stxDatabaseName.Caption := MinimizeName (CurrSelDatabase.NodeName,
          frmDBStatistics.stxDatabaseName.Canvas,
          (frmDBStatistics.stxDatabaseName.ClientRect.Left - frmDBStatistics.stxDatabaseName.ClientRect.Right));

        frmDBStatistics.stxDatabaseName.Hint := CurrSelDatabase.NodeName;

        frmDBStatistics.ShowModal;

        if (frmDBStatistics.ModalResult = mrOK) and
           (not frmDBStatistics.GetErrorState) then
        begin
          // repaint screen
          Application.ProcessMessages;
          Screen.Cursor := crHourGlass;

          // assign database details
          lDBStatistics.DatabaseName := CurrSelDatabase.Database.DatabaseName;

          lDBStatisticsOptions := [];
          // determine which options have been selected
          if frmDBStatistics.sgOptions.Cells[1,STATISTICS_OPTION_ROW] = 'Data Pages' then
            Include(lDBStatisticsOptions, DataPages)
          else if frmDBStatistics.sgOptions.Cells[1,STATISTICS_OPTION_ROW] = 'Database Log' then
            Include(lDBStatisticsOptions, DbLog)
          else if frmDBStatistics.sgOptions.Cells[1,STATISTICS_OPTION_ROW] = 'Header Page' then
            Include(lDBStatisticsOptions, HeaderPages)
          else if frmDBStatistics.sgOptions.Cells[1,STATISTICS_OPTION_ROW] = 'Index Pages' then
            Include(lDBStatisticsOptions, IndexPages)
          else if frmDBStatistics.sgOptions.Cells[1,STATISTICS_OPTION_ROW] = 'System Relations' then
            Include(lDBStatisticsOptions, SystemRelations);

          // assign validation options
          lDBStatistics.Options := lDBStatisticsOptions;

          // start service
          try
            lDBStatistics.ServiceStart;
            SourceServerNode.OpenTextViewer (lDBStatistics, 'Database Statistics');
            lDBStatistics.Detach;
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
        end;
      except
        on E: Exception do
        begin
          DisplayMsg(ERR_SERVER_SERVICE,E.Message + #13#10 + 'Database statistics cannot be displayed.');
          result := FAILURE;
        end;
      end;
      result := SUCCESS;
    end
    else
      result := FAILURE;
  finally
    Screen.Cursor := crDefault;
    if lDBStatistics.Active then
      lDBStatistics.Detach();
    lDBStatisticsData.Free;
    lDBStatistics.Free;
  end;
end;

{****************************************************************
*
*  F o r  m C r e a t e
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
*               the string grid when the form is created.
*
*****************************************************************
* Revisions:
*
*****************************************************************}

procedure TfrmDBStatistics.FormCreate(Sender: TObject);
begin
  inherited;
  sgOptions.DefaultRowHeight := cbOptions.Height;
  cbOptions.Visible := True;
  pnlOptionName.Visible := True;

  sgOptions.RowCount := 1;

  sgOptions.Cells[OPTION_NAME_COL,STATISTICS_OPTION_ROW] := 'Show data for:';
  sgOptions.Cells[OPTION_VALUE_COL,STATISTICS_OPTION_ROW] := 'All Options';

  pnlOptionName.Caption := 'Show data for:';
  cbOptions.Items.Add('All Options');
  cbOptions.Items.Add('Data Pages');
  cbOptions.Items.Add('Database Log');
  cbOptions.Items.Add('Header Page');
  cbOptions.Items.Add('Index Pages');
  cbOptions.Items.Add('System Relations');
  cbOptions.ItemIndex := 0;
end;

procedure TfrmDBStatistics.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmDBStatistics.btnOKClick(Sender: TObject);
begin
  if VerifyInputData() then
    ModalResult := mrOK;
end;

procedure TfrmDBStatistics.cbOptionsChange(Sender: TObject);
begin
  {
  sgOptions.Cells[sgOptions.Col,sgOptions.Row] :=
    cbOptions.Items[cbOptions.ItemIndex];
  cbOptions.Visible := false;
  sgOptions.SetFocus;
  }
end;

{****************************************************************
*
*  c b O p t i o n s D b l C l i c k
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

procedure TfrmDBStatistics.cbOptionsDblClick(Sender: TObject);
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

procedure TfrmDBStatistics.cbOptionsExit(Sender: TObject);
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

procedure TfrmDBStatistics.cbOptionsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_DOWN) then
    cbOptions.DroppedDown := true;
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
*               the Option string grid.
*
*****************************************************************
* Revisions:
*
*****************************************************************}

procedure TfrmDBStatistics.sgOptionsDrawCell(Sender: TObject; ACol,
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

procedure TfrmDBStatistics.sgOptionsSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
var
  lR, lName : TRect;
begin
  cbOptions.Items.Clear;
  cbOptions.Items.Add('All Options');
  cbOptions.Items.Add('Data Pages');
  cbOptions.Items.Add('Database Log');
  cbOptions.Items.Add('Header Page');
  cbOptions.Items.Add('Index Pages');
  cbOptions.Items.Add('System Relations');

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

function TfrmDBStatistics.VerifyInputData(): boolean;
begin
  result := true;
end;

procedure TfrmDBStatistics.WMNCLButtonDown( var Message: TWMNCLButtonDown );
var
  ScreenPt: TPoint;
  ClientPt: TPoint;
begin
  ScreenPt.X := Message.XCursor;
  ScreenPt.Y := Message.YCursor;
  ClientPt := ScreenToClient( ScreenPt );
  if( ClientPt.X > Width-45 )and (ClientPt.X < Width-29) then
   begin
    WinHelp(WindowHandle,CONTEXT_HELP_FILE,HELP_CONTEXT,DATABASE_STATISTICS);
    Message.Result := 0;
  end else
   inherited;
end;

end.
