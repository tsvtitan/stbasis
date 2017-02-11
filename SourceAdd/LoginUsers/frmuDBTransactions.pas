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
*  f r m u D B T r a n s a c t i o n s
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Description:  This unit provides an interface to view and
*                recover (if possible) limbo transasctions.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
unit frmuDBTransactions;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, zluibcClasses, StdCtrls, ComCtrls, ExtCtrls, IBServices,
  IB, ImgList, frmuDlgClass;

type
  TfrmDBTransactions = class(TDialog)
    edtPath: TEdit;
    lblConnectPath: TLabel;
    lblStatus: TLabel;
    lvTransactions: TListView;
    memAdvice: TMemo;
    pgcMain: TPageControl;
    tabAdvice: TTabSheet;
    tabTransactions: TTabSheet;
    stxDatabase: TStaticText;
    lblDatabase: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    rgOptions: TRadioGroup;
    lblRepairStatus: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure lvTransactionsSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure pgcMainChange(Sender: TObject);
    procedure pgcMainChanging(Sender: TObject; var AllowChange: Boolean);
    procedure rgOptionsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FValidation : TIBValidationService;
    FGlobalAction: TTransactionGlobalAction;
    FCurrentRecord : Integer;
    procedure GetLimboTransactions(const SourceServerNode : TibcServerNode; const CurrSelDatabase : TibcDatabaseNode);
    procedure WMNCLButtonDown( var Message: TWMNCLBUTTONDOWN ); message WM_NCLBUTTONDOWN ;
  public
    { Public declarations }
  end;

function DoDBTransactions(const SourceServerNode: TibcServerNode; const CurrSelDatabase: TibcDatabaseNode): integer;

implementation

uses
  zluGlobal, zluUtility, zluContextHelp, frmuMessage, frmuMain, IBErrorCodes;

{$R *.DFM}

{****************************************************************
*
*  D o D B T r a n s a c t i o n s ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  SourceServerNode - The currently selected server
*          CurrSelDatabase  - The currently selected database
*
*  Return: Integer - Determines whether the operation was a
*                    success or a failure
*
*  Description: This function checks for limbo transactions,
*               if any exist the form is shown, otherwise
*               a message is displayed and control is returned
*               to the main
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function DoDBTransactions(const SourceServerNode: TibcServerNode; const CurrSelDatabase: TibcDatabaseNode): integer;
var
  frmDBTransactions : TfrmDBTransactions;
begin
  frmDBTransactions := Nil;
  try
    frmDBTransactions := TfrmDBTransactions.Create(Application);

    Screen.Cursor := crHourGlass;
    frmDBTransactions.stxDatabase.Caption:=CurrSelDatabase.NodeName;
    // get a list of limbo transactions
    frmDBTransactions.GetLimboTransactions(SourceServerNode, CurrSelDatabase);

    // if the record count is not 0 then there are limbo transactions
    if frmDBTransactions.FCurrentRecord <> 0 then
      frmDBTransactions.ShowModal     // show the form as a modal dialog box
    else                               // if there were no limbo transactions
    begin                              // then display message
      DisplayMsg(INF_NO_PENDING_TRANSACTIONS, '');
      Result := FAILURE;
      Exit;
    end;

    if (frmDBTransactions.ModalResult = mrOK) and
       (not frmDBTransactions.GetErrorState) then
      result:=SUCCESS
    else
      result:=FAILURE;
  finally
    // deallocate memory
    frmDBTransactions.Free;
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmDBTransactions.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

{****************************************************************
*
*  G e t L i m b o T r a n s a c t i o n s
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  SourceServerNode - The currently selected server
*          CurrSelDatabase  - The currently selected database
*
*  Return: None
*
*  Description: This procedure populates the listview with
*               a list of limbo transactions and they're IDs.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmDBTransactions.GetLimboTransactions(const SourceServerNode : TibcServerNode; const CurrSelDatabase : TibcDatabaseNode);
var
  lListItem : TListItem;
begin
  FValidation := nil;
  try
    // create validation service object
    FValidation := TIBValidationService.Create(nil);
    try
      // assign server details
      FValidation.LoginPrompt := false;
      FValidation.ServerName := SourceServerNode.Server.ServerName;
      FValidation.Protocol := SourceServerNode.Server.Protocol;
      FValidation.Params.Clear;
      FValidation.Params.Assign(SourceServerNode.Server.Params);
      // assign database details
      case SourceServerNode.Server.Protocol of
        TCP : FValidation.DatabaseName := Format('%s:%s',[SourceServerNode.ServerName,CurrSelDatabase.DatabaseFiles.Strings[0]]);
        NamedPipe : FValidation.DatabaseName := Format('\\%s\%s',[SourceServerNode.ServerName,CurrSelDatabase.DatabaseFiles.Strings[0]]);
        SPX : FValidation.DatabaseName := Format('%s@%s',[SourceServerNode.ServerName,CurrSelDatabase.DatabaseFiles.Strings[0]]);
        Local : FValidation.DatabaseName := CurrSelDatabase.DatabaseFiles.Strings[0];
      end;
      // attach to server and start service
      FValidation.Options := [LimboTransactions];
      FValidation.Attach();
      FValidation.ServiceStart;
    except
      on E: EIBError do
      begin
        DisplayMsg(E.IBErrorCode, E.Message);
        if (E.IBErrorCode = isc_lost_db_connection) or
           (E.IBErrorCode = isc_unavailable) or
           (E.IBErrorCode = isc_network_error) then
          frmMain.SetErrorState;
        SetErrorState;
        Exit;
      end;
    end;

    // get limbo transactions and populate LimboTransactionsInfo array
    FValidation.FetchLimboTransactionInfo;

    while (FValidation.IsServiceRunning) and (not gApplShutdown) do
    begin
      Application.ProcessMessages;
    end;

    if FValidation.Active then
      FValidation.Detach();

    // get number of records and populate listview
    FCurrentRecord := 0;
    while FValidation.LimboTransactionInfo[FCurrentRecord].ID > 0 do
    begin
      lListItem := lvTransactions.Items.Add;

      if FValidation.LimboTransactionInfo[FCurrentRecord].MultiDatabase then
        lListItem.Caption := 'Multi-Database Transaction'
      else
        lListItem.Caption := 'Transaction';

      lListItem.SubItems.Add(IntToStr(FValidation.LimboTransactionInfo[FCurrentRecord].ID));
      case FValidation.LimboTransactionInfo[FCurrentRecord].Advise of
        CommitAdvise   : lListItem.SubItems.Add('Commit');
        RollBackAdvise : lListItem.SubItems.Add('Rollback');
        UnknownAdvise  : lListItem.SubItems.Add('Unknown');
      end;
      lListItem.SubItems.Add('In Limbo');

      Inc(FCurrentRecord);
    end;
  finally
    // FValidation.Free;
  end;
end;

{****************************************************************
*
*  p g c M a i n C h a n g e
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  Sender - The object that initiated the event
*
*  Return: None
*
*  Description: This procedure shows details about the
*               currently selected transaction if the Advice
*               tab is selected
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmDBTransactions.pgcMainChange(Sender: TObject);
var
  i         : Integer;
  lListItem : TListItem;
  lStr      : String;
begin
  // determine which page is active
  lListItem := lvTransactions.Selected;
  if pgcMain.ActivePage = tabAdvice then
  begin
    // find transaction record
    i := 0;
    while (FValidation.LimboTransactionInfo[i].ID <> 0) and (FValidation.LimboTransactionInfo[i].ID <> StrToInt(lListItem.SubItems[0]))  do
      Inc(i);

    // make it the current record
    FCurrentRecord := i;

    // if there an item is currently selected in the list
    if (lListItem <> Nil) and (lListItem.Caption <> '') then
    begin
      // populate memo
      with memAdvice.Lines do
      begin
        Clear;
        Add(lListItem.Caption);
        Add(Format('  Host Site: %s', [FValidation.LimboTransactionInfo[i].HostSite]));

        case FValidation.LimboTransactionInfo[i].State of
          LimboState    : lStr := 'is in limbo';
          CommitState   : lStr := 'has been committed';
          RollBackState : lStr := 'has been rolled back';
          UnknownState  : lStr := 'is in an unknown state';
        end;
        Add(Format('  Transaction %d %s.', [FValidation.LimboTransactionInfo[i].ID, lStr]));

        Add(Format('  Remote Site: %s', [FValidation.LimboTransactionInfo[i].RemoteSite]));
        Add(Format('  Database Path: %s', [FValidation.LimboTransactionInfo[i].RemoteDatabasePath]));

        Add('');

        case FValidation.LimboTransactionInfo[i].Advise of
          CommitAdvise   : lStr := 'Commit';
          RollBackAdvise : lStr := 'Rollback';
          UnknownAdvise  : lStr := 'Unknown';
        end;

        Add(Format('Recommended Action: %s', [lStr]));

      end;
    end
    else
    begin
      // show message in memo if no item is selected
      memAdvice.Lines.Clear;
      memAdvice.Lines.Add('Please select an item from the Transactions tab.');
    end;
  end
  else
  begin
    // give the listview control focus
    lvTransactions.SetFocus;
  end;
end;

procedure TfrmDBTransactions.lvTransactionsSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
var
  i : Integer;
begin
  // find currently selected record
  i := 0;
  while (FValidation.LimboTransactionInfo[i].ID <> StrToInt(Item.SubItems[0])) and (FValidation.LimboTransactionInfo[i].ID <> 0) do
    Inc(i);

  FCurrentRecord := i;

  // show its database path
  edtPath.Text := FValidation.LimboTransactionInfo[i].RemoteDatabasePath;
end;

{****************************************************************
*
*  b t n O K C l i c k
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  Sender - The object that initiated the event
*
*  Return: None
*
*  Description: This procedure will try to fix any limbo
*               transactions.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmDBTransactions.btnOKClick(Sender: TObject);
var
  lCnt: integer;
begin
  try
    FValidation.GlobalAction := FGlobalAction;
    Screen.Cursor := crHourGlass;
    { Fix:  Service only allows 1 transaction to be fixed at a time }
    for lCnt := 0 to lvTransactions.Items.Count-1 do
    begin
      Application.ProcessMessages;    
      lblRepairStatus.Caption := Format('Repairing transaction %s',[lvTransactions.Items[lCnt].Subitems[0]]);
      lblRepairStatus.Visible := true;
      FValidation.Attach;
      FValidation.FixLimboTransactionErrors;
      while FValidation.IsServiceRunning do
        Application.ProcessMessages;
      lvTransactions.Items[lCnt].SubItems[2] := 'Fixed';        
      FValidation.Detach;
      FValidation.Attach;
      FValidation.ServiceStart;
      Application.ProcessMessages;      
      FValidation.FetchLimboTransactionInfo;
      while FValidation.IsServiceRunning do
        Application.ProcessMessages;
      FValidation.Detach;      
    end;
  except
    on E:EIBError do
    begin
      DisplayMsg(E.IBErrorCode, E.Message);
      if (E.IBErrorCode = isc_lost_db_connection) or
         (E.IBErrorCode = isc_unavailable) or
         (E.IBErrorCode = isc_network_error) then
      begin
        frmMain.SetErrorState;
        SetErrorState;
      end
      else
      if Fvalidation.Active then
        FValidation.Detach;
    end;
  end;
  ModalResult := mrOK;
  Screen.Cursor := crDefault;
  if Fvalidation.Active then
    FValidation.Detach;
  MessageDlg ('Limbo transaction recovery completed.', mtInformation, [mbOK], 0);
end;

procedure TfrmDBTransactions.WMNCLButtonDown( var Message: TWMNCLButtonDown );
var
  ScreenPt: TPoint;
  ClientPt: TPoint;
begin
  ScreenPt.X := Message.XCursor;
  ScreenPt.Y := Message.YCursor;
  ClientPt := ScreenToClient( ScreenPt );
  if( ClientPt.X > Width-45 )and (ClientPt.X < Width-29) then
   begin
    WinHelp(WindowHandle,CONTEXT_HELP_FILE,HELP_CONTEXT,TRANSACTIONS_RECOVERY);
    Message.Result := 0;
  end else
   inherited;
end;

procedure TfrmDBTransactions.pgcMainChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  inherited;
  if not Assigned(lvTransactions.Selected) then
  begin
    ShowMessage('Select a transaction for information about that transaction.');
    AllowChange := false;
  end;

end;

procedure TfrmDBTransactions.rgOptionsClick(Sender: TObject);
begin
  inherited;
  case rgOptions.ItemIndex of
    0: FGlobalAction := NoGlobalAction;
    1: FGlobalAction := CommitGlobal;
    2: FGlobalAction := RollbackGlobal;
    3: FGlobalAction := RecoverTwoPhaseGlobal;
  end;
end;

procedure TfrmDBTransactions.FormCreate(Sender: TObject);
begin
  inherited;
  FGlobalAction := NoGlobalAction;
end;

end.
