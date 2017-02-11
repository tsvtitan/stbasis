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
*  f r m u B a c k u p A l i a s P r o p e r t i e s
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Description:  This unit provides an interface for editing
*                backup alias properties
*
*****************************************************************
* Revisions:
*
*****************************************************************}
unit frmuBackupAliasProperties;

interface

uses
  Forms, ExtCtrls, StdCtrls, Classes, Controls, zluibcClasses, ComCtrls,
  SysUtils, Grids, Dialogs, Registry, Windows, Messages, frmuDlgClass;

type
  TfrmBackupAliasProperties = class(TDialog)
    lblServerName: TLabel;
    stxServerName: TStaticText;
    lblAliasName: TLabel;
    bvlLine1: TBevel;
    edtAliasName: TEdit;
    sgBackupFiles: TStringGrid;
    lblDBServer: TLabel;
    cbDBServer: TComboBox;
    lblDBAlias: TLabel;
    cbDBAlias: TComboBox;
    btnApply: TButton;
    btnOK: TButton;
    Button1: TButton;
    function FormHelp(Command: Word; Data: Integer; var CallHelp: Boolean): Boolean;
    procedure FormCreate(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure cbDBServerChange(Sender: TObject);
    procedure sgBackupFilesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtAliasNameChange(Sender: TObject);
    procedure sgBackupFilesSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: String);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    FApplyChanges: boolean;
    FCurrSelServer : TibcServerNode;
    FPreviousKeyName : String;
    function VerifyInputData() : boolean;
    procedure WMNCLButtonDown( var Message: TWMNCLBUTTONDOWN ); message WM_NCLBUTTONDOWN ;
  public
    { Public declarations }
    FBackupAliasNode: TibcBackupAliasNode;
    FSourceServerNode: TibcServerNode;    
  end;

function EditBackupAliasProperties(const SourceServerNode: TibcServerNode;
                                   var BackupAliasNode: TibcBackupAliasNode): integer;

implementation

uses
  zluGlobal, zluUtility, frmuMain, frmuMessage, zluContextHelp;

{$R *.DFM}

{****************************************************************
*
*  E d i t B a c k u p A l i a s P r o p e r t i e s ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:   SourceServerNode - currently selected server
*           BackupAliasNode  - currently selected backup alias
*
*  Return:  Integer - specifies whether or not backup alias
*                     properties where modified
*
*  Description: Displays backup alias properties as well as
*               capturing new properties.  This function will
*               apply the new changes, if any.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function EditBackupAliasProperties(const SourceServerNode: TibcServerNode;
  var BackupAliasNode: TibcBackupAliasNode): integer;
var
  frmBackupAliasProperties: TfrmBackupAliasProperties;
  i: integer;
  lCurrBackupAliasNode: TTreeNode;
  lTmp,
  lCurrLine: string;
begin
  frmBackupAliasProperties := TfrmBackupAliasProperties.Create(Application);
  try
    // set server name and backup alias
    frmBackupAliasProperties.FBackupAliasNode := BackupAliasNode;
    frmBackupAliasProperties.FSourceServerNode:= SourceServerNode;
    frmBackupAliasProperties.stxServerName.Caption := SourceServerNode.NodeName;
    frmBackupAliasProperties.edtAliasName.Text := BackupAliasNode.NodeName;

    frmBackupAliasProperties.FCurrSelServer := SourceServerNode;
    frmBackupAliasProperties.FPreviousKeyName := BackupAliasNode.NodeName;
    lCurrBackupAliasNode := frmMain.tvMain.Items.GetNode(SourceServerNode.DatabasesID);

    // get list of server aliases and place in dbserver combo box
    for i := 1 to TibcTreeNode(frmMain.tvMain.Items[0].Data).ObjectList.Count - 1 do
    begin
      lTmp := TibcTreeNode(frmMain.tvMain.Items[0].Data).ObjectList.Strings[i];
      lTmp := GetNextField(lTmp, DEL);
      frmBackupAliasProperties.cbDBServer.Items.AddObject(lTmp,
      TibcServerNode(TTreeNode(TibcTreeNode(frmMain.tvMain.Items[0].Data).ObjectList.Objects[i]).Data));
    end;

    // get list of database aliases on currently selected server and place in dbalias combo box
    for i := 1 to TibcTreeNode(lCurrBackupAliasNode.Data).ObjectList.Count - 1 do
    begin
      lTmp := TibcDatabaseNode(lCurrBackupAliasNode.Data).ObjectList.Strings[i];
      lTmp := GetNextField(lTmp, DEL);
      frmBackupAliasProperties.cbDBAlias.Items.AddObject(lTmp,
      TibcDatabaseNode(TTreeNode(TibcTreeNode(lCurrBackupAliasNode.Data).ObjectList.Objects[i]).Data));
    end;

    // show server and alias in combo boxes
    frmBackupAliasProperties.cbDBServer.ItemIndex := frmBackupAliasProperties.cbDBServer.Items.IndexOf(BackupAliasNode.SourceDBServer);
    frmBackupAliasProperties.cbDBAlias.ItemIndex := frmBackupAliasProperties.cbDBAlias.Items.IndexOf(BackupAliasNode.SourceDBAlias);

    // clear stringgrid
    for i := 1 to frmBackupAliasProperties.sgBackupFiles.RowCount do
    begin
      frmBackupAliasProperties.sgBackupFiles.Cells[0,i] := '';
      frmBackupAliasProperties.sgBackupFiles.Cells[1,i] := '';
    end;

    // fill in string grid with filename(s) of backup file(s)
    for i := 1 to BackupAliasNode.BackupFiles.Count do
    begin
      lCurrLine := BackupAliasNode.BackupFiles.Strings[i-1];
      frmBackupAliasProperties.sgBackupFiles.Cells[0,i] := zluUtility.GetNextField(lCurrLine,'=');
      frmBackupAliasProperties.sgBackupFiles.RowCount := frmBackupAliasProperties.sgBackupFiles.RowCount + 1;
    end;

    // show form
    frmBackupAliasProperties.ShowModal;
    result := SUCCESS;
  finally
    // deallocate memory
    frmBackupAliasProperties.Free;
  end;
end;

function TfrmBackupAliasProperties.FormHelp(Command: Word; Data: Integer;
  var CallHelp: Boolean): Boolean;
begin
  CallHelp := False;
  Result := WinHelp(WindowHandle,CONTEXT_HELP_FILE,HELP_CONTEXT,BACKUP_CONFIGURATION_PROPERTIES);
end;

procedure TfrmBackupAliasProperties.FormCreate(Sender: TObject);
begin
  inherited;
  FApplyChanges := false;
  sgBackupFiles.Cells[0,0] := 'Backup Filename(s)';
end;

procedure TfrmBackupAliasProperties.btnApplyClick(Sender: TObject);
var
  j: integer;
  lRegistry: TRegistry;

begin
  if VerifyInputData() then
  begin
    // set new backup alias properties
    Screen.Cursor := crHourGlass;    
    lRegistry := TRegistry.Create;
    FBackupAliasNode.NodeName := edtAliasName.Text;
    FBackupAliasNode.SourceDBServer := cbDBServer.Text;
    FBackupAliasNode.SourceDBAlias := cbDBAlias.Text;

    // clear all backup files associated with the current backup alias
    FBackupAliasNode.BackupFiles.Clear;
    for j := 1 to sgBackupFiles.RowCount - 1 do
    begin
      // specify new backup files from stringgrid
      if sgBackupFiles.Cells[0,j] <> '' then
      begin
        if not (IsValidDBName(sgBackupFiles.Cells[0,j])) then
          DisplayMsg(WAR_REMOTE_FILENAME, Format('File: %s', [sgBackupFiles.Cells[0,j]]));
        FBackupAliasNode.BackupFiles.Add(sgBackupFiles.Cells[0,j]);
      end;
    end;

    // update registry
    if lRegistry.OpenKey(Format('%s%s\Backup Files\%s',[gRegServersKey,FSourceServerNode.Nodename,FPreviousKeyName]),false) then
    begin
      lRegistry.WriteString('SourceDBServer',FBackupAliasNode.SourceDBServer);
      lRegistry.WriteString('SourceDBAlias',FBackupAliasNode.SourceDBAlias);
      lRegistry.WriteString('BackupFiles',FBackupAliasNode.BackupFiles.Text);

      lRegistry.MoveKey(Format('%s%s\Backup Files\%s',[gRegServersKey,FSourceServerNode.Nodename,FPreviousKeyName]),
        Format('%s%s\Backup Files\%s',[gRegServersKey,FSourceServerNode.Nodename,edtAliasName.Text]), true);

      lRegistry.CloseKey();
      lRegistry.Free;
      FPreviousKeyName := edtAliasName.Text;
    end;

    // update backup alias in treenode
    FBackupAliasNode.NodeName := edtAliasName.Text;
    frmMain.RenameTreeNode(FBackupAliasNode,FBackupAliasNode.NodeName);
    Screen.Cursor := crDefault;    
  end;
end;

procedure TfrmBackupAliasProperties.btnOKClick(Sender: TObject);
begin
  if btnApply.enabled then
    btnApply.Click;
  ModalResult := mrOK;
end;

procedure TfrmBackupAliasProperties.cbDBServerChange(Sender: TObject);
var
  i: integer;
  lCurrDBAliasesNode: TTreeNode;
begin
  cbDBAlias.Items.Clear;
  lCUrrDBAliasesNode := Nil;

  if cbDBServer.ItemIndex <> -1 then
    lCurrDBAliasesNode := frmMain.tvMain.Items.GetNode(TibcServerNode(cbDBServer.Items.Objects[cbDBServer.ItemIndex]).BackupFilesID);

  if Assigned(lCurrDBAliasesNode) then
  begin
    for i := 1 to TibcServerNode(lCurrDBAliasesNode.Data).ObjectList.Count - 1 do
    begin
      cbDBAlias.Items.AddObject(TibcTreeNode(lCurrDBAliasesNode.Data).ObjectList.Strings[i],
        TibcBackupAliasNode(TTreeNode(TibcTreeNode(lCurrDBAliasesNode.Data).ObjectList.Objects[i]).Data));
    end;
  end;
  btnApply.Enabled := true;
end;

procedure TfrmBackupAliasProperties.sgBackupFilesKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  // if ctrl-tab is pressed
  if (Key = VK_TAB) and (ssCtrl in Shift) then
  begin
    if sgBackupFiles.Col < sgBackupFiles.ColCount - 1 then
    begin                              // select next field in stringgrid
      sgBackupFiles.Col := sgBackupFiles.Col + 1;
    end
    else                               // if at end of grid then
    begin                              // add a new row
      if sgBackupFiles.Row = sgBackupFiles.RowCount - 1 then
        sgBackupFiles.RowCount := sgBackupFiles.RowCount + 1;
      sgBackupFiles.Col := 0;
      sgBackupFiles.Row := sgBackupFiles.Row + 1;
    end;
  end;
end;

function TfrmBackupAliasProperties.VerifyInputData() : boolean;
var
  lCurrParentNode, lCurrChildNode: TTreeNode;
begin
  result := true;

  lCurrParentNode := frmMain.tvMain.Items.GetNode(FCurrSelServer.BackupFilesID);
  lCurrChildNode := lCurrParentNode.GetFirstChild();
  while (lCurrChildNode <> nil) do
  begin
    if (edtAliasName.Text = lCurrChildNode.Text) and (FPreviousKeyName <> lCurrChildNode.Text) then
    begin
      DisplayMsg(WAR_DUPLICATE_DB_ALIAS, '');
      edtAliasName.SetFocus;
      Result := false;
      Exit;
    end;
    lCurrChildNode := lCurrParentNode.GetNextChild(lCurrChildNode);
  end;

  if (edtAliasName.Text = '') or (edtAliasName.Text = ' ') then
  begin
    DisplayMsg(ERR_BACKUP_ALIAS, '');
    edtAliasName.SetFocus;
    Result := false;
    Exit;
  end;
end;

procedure TfrmBackupAliasProperties.WMNCLButtonDown( var Message: TWMNCLButtonDown );
var
  ScreenPt: TPoint;
  ClientPt: TPoint;
begin
  ScreenPt.X := Message.XCursor;
  ScreenPt.Y := Message.YCursor;
  ClientPt := ScreenToClient( ScreenPt );
  if( ClientPt.X > Width-45 )and (ClientPt.X < Width-29) then
   begin
    WinHelp(WindowHandle,CONTEXT_HELP_FILE,HELP_CONTEXT,BACKUP_CONFIGURATION_PROPERTIES);
    Message.Result := 0;
  end else
   inherited;
end;

procedure TfrmBackupAliasProperties.edtAliasNameChange(Sender: TObject);
begin
  inherited;
  btnApply.Enabled := true;
end;

procedure TfrmBackupAliasProperties.sgBackupFilesSetEditText(
  Sender: TObject; ACol, ARow: Integer; const Value: String);
begin
  inherited;
  if not btnApply.Enabled then
    btnApply.Enabled := true;
end;

procedure TfrmBackupAliasProperties.FormShow(Sender: TObject);
begin
  inherited;
  btnApply.Enabled := false;
end;

procedure TfrmBackupAliasProperties.Button1Click(Sender: TObject);
begin
  inherited;
  ModalResult := mrCancel;
end;

end.
