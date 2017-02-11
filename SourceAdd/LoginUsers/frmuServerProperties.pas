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

unit frmuServerProperties;

interface

uses
  Forms, ExtCtrls, StdCtrls, Classes, Controls, SysUtils, zluibcClasses,
  ComCtrls, Graphics, Registry, IBServices, frmuMessage, IB, Windows,
  Messages, zluContextHelp, frmuDlgClass;

type
  TfrmServerProperties = class(TDialog)
    TabAlias: TTabSheet;
    TabGeneral: TTabSheet;
    bvlLine1: TBevel;
    cboProtocol: TComboBox;
    edtAliasName: TEdit;
    edtHostName: TEdit;
    lblAliasName: TLabel;
    lblAttachmentNo: TLabel;
    lblCapabilities: TLabel;
    lblDatabaseNo: TLabel;
    lblHostName: TLabel;
    lblProtocol: TLabel;
    lblVersion: TLabel;
    lvDatabases: TListView;
    memCapabilities: TMemo;
    pgcMain: TPageControl;
    stxAttachmentNo: TStaticText;
    stxDatabaseNo: TStaticText;
    stxVersion: TStaticText;
    btnApply: TButton;
    btnCancel: TButton;
    btnRefresh: TButton;
    Button1: TButton;
    Label1: TLabel;
    edtDescription: TEdit;
    function FormHelp(Command: Word; Data: Integer; var CallHelp: Boolean): Boolean;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure cboProtocolChange(Sender: TObject);
    procedure cboProtocolDblClick(Sender: TObject);
    procedure edtAliasNameChange(Sender: TObject);
    procedure lvDatabasesDblClick(Sender: TObject);
    procedure pgcMainChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    FAssignedServer : TibcServerNode;
    FLicenseDesc: TStringList;
    procedure NoteChanges();
    procedure Refresh();
    procedure ShowActivity();
    procedure WMNCLButtonDown( var Message: TWMNCLBUTTONDOWN ); message WM_NCLBUTTONDOWN ;
  public
    { Public declarations }
    procedure AssignServerNode(const ServerNode: TibcServerNode);
    function GetNewSettings: TibcServerNode;
    procedure DecodeMask(AssignedServer: TibcServerNode);
  end;

  ENameError = class(Exception);

function EditServerProperties(const CurrSelServer: TibcServerNode): integer;

implementation

uses
  zluGlobal, frmuMain, IBDatabase, frmuDBConnections, IBHeader, IBErrorCodes;

{$R *.DFM}

const
  LIC_A_BIT=0;
  LIC_B_BIT=3;
  LIC_C_BIT=16;
  LIC_D_BIT=1;
  LIC_E_BIT=4;
  LIC_F_BIT=5;
  LIC_I_BIT=8;
  LIC_L_BIT=11;
  LIC_P_BIT=15;
  LIC_Q_BIT=2;
  LIC_R_BIT=17;
  LIC_S_BIT=18;
  LIC_W_BIT=22;
  LIC_2_BIT=27;
  LIC_3_BIT=28;

  LIC_A_TEXT = 'Ada language preprocessing is supported';
  LIC_B_TEXT = 'Basic language preprocessing is supported';
  LIC_C_TEXT = 'C language preprocessing is supported';
  LIC_D_TEXT = 'Server can modify the metadata of databases';
  LIC_E_TEXT = 'Server can access tables which are external to a database';
  LIC_F_TEXT = 'Fortran language preprocessing is supported';
  LIC_I_TEXT = 'Server can access tables which are internal to a database';
  LIC_L_TEXT = 'All language preprocessing is supported except C++ and Ada';
  LIC_P_TEXT = 'Pascal language preprocessing is supported';
  LIC_Q_TEXT = 'Client can use query tools';
  LIC_R_TEXT = 'Client can access remote servers';
  LIC_S_TEXT = 'Server can process requests from remote clients';
  LIC_W_TEXT = 'Server is not limited  as to the number of users it can process';
  LIC_2_TEXT = 'COBOL language preprocessing is supported';
  LIC_3_TEXT = 'C++ language preprocessing is supported';

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
function TfrmServerProperties.FormHelp(Command: Word; Data: Integer;
  var CallHelp: Boolean): Boolean;
begin
  CallHelp := False;
  Result := WinHelp(WindowHandle,CONTEXT_HELP_FILE,HELP_CONTEXT,SERVER_PROPERTIES);
end;

{****************************************************************
*
*  b t n A p p l y C l i c k
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   April 28, 1999
*
*  Input: ignored
*
*  Description: Sets the modal result of the form to mrOK
*               if all user entered values are valid.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmServerProperties.btnApplyClick(Sender: TObject);
var
  lRegistry : TRegistry;
  ServerActive: boolean;
begin
  lRegistry := TRegistry.Create;
  try
    // save alias and database file information
    Screen.Cursor := crHourGlass;
    ServerActive := FAssignedServer.Server.Active;
    if FAssignedServer.Server.Active then
      FAssignedServer.Server.Active := false;
    if lRegistry.OpenKey(Format('%s%s',[gRegServersKey,FAssignedServer.NodeName]),false) then
    begin
      case cboProtocol.ItemIndex of
        0:
        begin
          FAssignedServer.Server.Protocol := TCP;
          lRegistry.WriteInteger('Protocol',0);
        end;
        1:
        begin
          FAssignedServer.Server.Protocol := NamedPipe;
          lRegistry.WriteInteger('Protocol',1);
        end;
        2:
        begin
          FAssignedServer.Server.Protocol := SPX;
          lRegistry.WriteInteger('Protocol',2);
        end;
      end;
      FAssignedServer.ServerName := edtHostName.Text;
      FAssignedServer.Server.ServerName := edtHostName.Text;
      lRegistry.WriteString('ServerName', edtHostName.Text);
      FAssignedServer.Description := edtDescription.Text;
      lRegistry.WriteString('Description', edtDescription.Text);
      lRegistry.CloseKey();
      lRegistry.MoveKey(Format('%s%s',[gRegServersKey,FAssignedServer.NodeName]),
        Format('%s%s',[gRegServersKey,edtAliasName.Text]), true);
      FAssignedServer.NodeName := edtAliasName.Text;

      if ServerActive then
        FAssignedServer.Server.Active := true;
    end;
  finally
    lRegistry.Free;
    Screen.Cursor := crDefault;
  end;
end;

{****************************************************************
*
*  b t n C a n c e l C l i c k
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   April 28, 1999
*
*  Input: ignored
*
*  Description: Sets the modal result of the form to mrCancel.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmServerProperties.btnCancelClick(Sender: TObject);
begin
  btnApply.Click;
  ModalResult := mrOK;
end;

{****************************************************************
*
*  b t n R e f r e s h C l i c k
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   April 28, 1999
*
*  Input: ignored
*
*  Description: Retrieves server properties and displays them on
*               the form.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmServerProperties.btnRefreshClick(Sender: TObject);
begin
  Refresh();
end;

{****************************************************************
*
*  c b o P r o t o c o l C h a n g e
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   April 28, 1999
*
*  Input: ignored
*
*  Description: Prepares the form when changes are made.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmServerProperties.cboProtocolChange(Sender: TObject);
begin
  NoteChanges;
end;

{****************************************************************
*
*  c b o P r o t o c o l D b l C l i c k
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   April 28, 1999
*
*  Input: ignored
*
*  Description: When the user doucle clicks the comco box,
*               the next protocol in the combo box is selected and
*               the form is prepared after the change.  Selects the
*               first protocol when the end of the list is reached.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmServerProperties.cboProtocolDblClick(Sender: TObject);
begin
  if not cboProtocol.DroppedDown then
  begin
    if cboProtocol.ItemIndex = cboProtocol.Items.Count - 1 then
      cboProtocol.ItemIndex := 0
    else
      cboProtocol.ItemIndex := cboProtocol.ItemIndex + 1;
  end;
  NoteChanges;
end;

{****************************************************************
*
*  e d t A l i a s N a m e C h a n g e
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   April 28, 1999
*
*  Input: ignored
*
*  Description: Prepares the form when changes are made.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmServerProperties.edtAliasNameChange(Sender: TObject);
begin
  NoteChanges;
end;

{****************************************************************
*
*  l v D a t a b a s e s D b l C l i c k
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   April 28, 1999
*
*  Input: ignored
*
*  Description: Displays additional information when the user double clicks
*               an item in the list view.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmServerProperties.lvDatabasesDblClick(Sender: TObject);
var
  sCurrSelDB:string;
  i:integer;
begin
  sCurrSelDB := '';

  if lvDatabases.Selected <> nil then
  begin
    sCurrSelDB := lvDatabases.Selected.Caption;  // get selected item
    if sCurrSelDB <> '' then             // if there was a selected item before
    begin
      i := lvDatabases.Items.Count;      // get number of databases in list
      while i > 0 do                     // loop to see if it is still attached
      begin
        dec(i);                          // start at end of list
        if lvDatabases.Items.Item[i].Caption = sCurrSelDB then  // if found/attached
        begin
          lvDatabases.Items.Item[i].Selected := true;
          ShowActivity;                  // show users
          i := - 1;                      // lower value of i to indicate success
        end;
      end;  // end loop through attached databases

      if i = 0 then  // no items or original item not found
        DisplayMsg(ERR_GET_USERS,'All users have disconnected from database ' +
          sCurrSelDB + '.  It is no longer attached to the server.');

    end;  // end if double clicked on item
    Refresh();                           // refresh unselects item
  end;
end;

{****************************************************************
*
*  p g c M a i n C h a n g e
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   April 28, 1999
*
*  Input: ignored
*
*  Description: Prepares the form when the user switches between
*               tabbed pages.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmServerProperties.pgcMainChange(Sender: TObject);
begin
  if pgcMain.ActivePage = tabAlias then
    btnRefresh.Enabled := false
  else
    btnRefresh.Enabled := true;
end;

{****************************************************************
*
*  N o t e C h a n g e s
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   April 28, 1999
*
*  Input: none
*
*  Description: Prepares the form when the user makes changes.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmServerProperties.NoteChanges();
begin
  btnApply.Enabled := False;  // assume no changes made, then start checking
  case FAssignedServer.Server.Protocol of
    TCP:
      if (cboProtocol.ItemIndex <> 0) and (cboProtocol.ItemIndex >= 0) then
        btnApply.Enabled := True;
    NamedPipe:
      if (cboProtocol.ItemIndex <> 1)  and (cboProtocol.ItemIndex >= 0) then
        btnApply.Enabled := True;
    SPX:
      if (cboProtocol.ItemIndex <> 2)  and (cboProtocol.ItemIndex >= 0) then
        btnApply.Enabled := True;
  end;
  if edtAliasName.Text <> FAssignedServer.NodeName then
    btnApply.Enabled := True;
  if edtHostName.Text <> FAssignedServer.ServerName then
    btnApply.Enabled := true;

  if edtDescription.Text <> FAssignedServer.Description then
    btnApply.Enabled := true;
end;

{****************************************************************
*
*  R e f r e s h
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   April 28, 1999
*
*  Input: none
*
*  Description: Retrieves server properties and displays them on
*               the form.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmServerProperties.Refresh();
var
  i:integer;
  lDatabaseName:TListItem;

begin
  try
    FLicenseDesc.Clear;
    if FAssignedServer = nil then
      Exit
    else
    begin
      if not FAssignedServer.Server.Active then
        FAssignedServer.Server.Attach;
      try
        FAssignedServer.Server.FetchDatabaseInfo;
        FAssignedServer.Server.FetchVersionInfo;
        FAssignedServer.Server.FetchLicenseMaskInfo;
        FAssignedServer.Server.FetchLicenseInfo;
      except
        on E:EIBError do
          if E.IBErrorCode = isc_insufficient_svc_privileges then
            FAssignedServer.Server.Active := true
          else
          begin
            DisplayMsg(ERR_SERVER_SERVICE,E.Message);
            if (E.IBErrorCode = isc_lost_db_connection) or
               (E.IBErrorCode = isc_unavailable) or
               (E.IBErrorCode = isc_network_error) then
              frmMain.SetErrorState;
            SetErrorState;
            exit;
          end;
      end;
      DecodeMask(FAssignedServer);
      memCapabilities.Lines := FLicenseDesc;
    end;
  except
    on E:EIBError do
    begin
      DisplayMsg(ERR_SERVER_SERVICE,E.Message);
      if (E.IBErrorCode = isc_lost_db_connection) or
         (E.IBErrorCode = isc_unavailable) or
         (E.IBErrorCode = isc_network_error) then
        frmMain.SetErrorState;
      SetErrorState;
      exit;
    end;
  end;
  stxVersion.Caption := FAssignedServer.Server.VersionInfo.ServerVersion;
  stxDatabaseNo.Caption := IntToStr(FAssignedServer.Server.DatabaseInfo.NoOfDatabases);
  stxAttachmentNo.Caption := IntToStr(FAssignedServer.Server.DatabaseInfo.NoOfAttachments);

  lvDatabases.Items.Clear;
  for i:= 0 to FAssignedServer.Server.DatabaseInfo.NoOfDatabases - 1 do
  begin
    lDatabaseName := lvDatabases.Items.Add;
    lDatabaseName.Caption := FAssignedServer.Server.DatabaseInfo.DbName[i];
  end;
end;


{****************************************************************
*
*  S h o w A c t i v i t y
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   April 28, 1999
*
*  Input: none
*
*  Description: Creates a temporary TIBDatabase object and uses it
*               to view the users connected to the currently highlighted
*               database in the Database list, via the DBConnections form.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmServerProperties.ShowActivity();
var
  lDatabase : TIBDatabase;
begin
  lDatabase := TIBDatabase.Create(Application);
  try
    case FAssignedServer.Server.Protocol of
      TCP: lDatabase.DatabaseName := Format('%s:%s',[FAssignedServer.ServerName,lvDatabases.Selected.Caption]);
      NamedPipe: lDatabase.DatabaseName := Format('\\%s\%s',[FAssignedServer.ServerName,lvDatabases.Selected.Caption]);
      SPX: lDatabase.DatabaseName := Format('%s@%s',[FAssignedServer.ServerName,lvDatabases.Selected.Caption]);
      Local:  lDatabase.DatabaseName := lvDatabases.Selected.Caption;
    end;
    frmuDBConnections.ViewDBConnections(FAssignedServer,lDatabase);
  finally
    lDatabase.Free;
  end;
end;


{****************************************************************
*
*  A s s i g n S e r v e r N o d e
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   April 28, 1999
*
*  Input: A TibcServerNode object for which properties are to be retrieved
*
*  Description: assigns a server node to the form and prepares features
*               that do not change and inserts initial values for
*               data.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmServerProperties.AssignServerNode(const ServerNode: TibcServerNode);
begin
  FAssignedServer := ServerNode;
  if FAssignedServer <> nil then
  begin
    edtAliasName.Text:= FAssignedServer.NodeName;
    edtHostName.Text:= FAssignedServer.ServerName;
    edtDescription.Text := FAssignedServer.Description;
    case FAssignedServer.Server.Protocol of
    Local:
      begin
        edtAliasName.Color := clSilver;
        edtHostName.Color := clSilver;
        cboProtocol.Color := clSilver;
        edtAliasName.Enabled := false;
        edtHostName.Enabled := false;
        cboProtocol.Enabled := false;
        edtHostName.Text:= FAssignedServer.NodeName;
      end;
    TCP:
      cboProtocol.ItemIndex := 0;
    NamedPipe:
      cboProtocol.ItemIndex := 1;
    SPX:
      cboProtocol.ItemIndex := 2;
    end;

    if not FAssignedServer.Server.Active then
    begin
      TabGeneral.TabVisible := false;
      cboProtocol.Enabled := true;
      edtHostName.Enabled := true;
    end
    else
      Refresh();
  end;
end;


{****************************************************************
*
*  E d i t S e r v e r P r o p e r t i e s
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   April 28, 1999
*
*  Input: Server node for which properties are requested.
*
*  Returns: Modal Result of Server Properties form.
*
*  Description: Displays the Server Properties form and saves
*               changes to server alias and/or protocol in the
*               registry.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function EditServerProperties(const CurrSelServer: TibcServerNode): integer;
var
  frmServerProperties : TfrmServerProperties;
  tmpServer: TibcServerNode;
  ServerActive: boolean;

begin
  result := FAILURE;
  frmServerProperties := TfrmServerProperties.Create(Application);
  try
    frmServerProperties.AssignServerNode(CurrSelServer);
    if not frmServerProperties.GetErrorState then
    begin
      frmServerProperties.ShowModal;
      tmpServer := frmServerProperties.GetNewSettings;
      with CurrSelServer do
      begin
        if Server.Protocol <> tmpServer.Server.Protocol then
        begin
          ServerActive := Server.Active;
          if Server.Active then
            Server.Active := false;
          Server.Protocol := tmpServer.Server.Protocol;

          if ServerActive then
          Server.Active := true;
        end;
        NodeName := tmpServer.NodeName;
      end;
      frmMain.RenameTreeNode(CurrSelServer,frmServerProperties.edtAliasName.Text);
      result := SUCCESS;
    end;
  finally
    frmServerProperties.Free;
  end;
end;

{****************************************************************
*
*  D e c o d e M a s k
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   May 5, 1999
*
*  Input:  none
*
*  Description: Decodes the masks previously fetched and sets up
*               the output TStrings.
*
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmServerProperties.DecodeMask(AssignedServer: TibcServerNode);
var
  lLicenseMask: integer;
begin
  lLicenseMask := AssignedServer.Server.LicenseMaskInfo.LicenseMask;
  if ((lLicenseMask shr LIC_A_BIT) and 1) = 1 then
    FLicenseDesc.Add(LIC_A_TEXT);

  if ((lLicenseMask shr LIC_B_BIT) and 1) = 1 then
    FLicenseDesc.Add(LIC_B_TEXT);

  if ((lLicenseMask shr LIC_C_BIT) and 1) = 1 then
    FLicenseDesc.Add(LIC_C_TEXT);

  if ((lLicenseMask shr LIC_D_BIT) and 1) = 1 then
    FLicenseDesc.Add(LIC_D_TEXT);

  if ((lLicenseMask shr LIC_E_BIT) and 1) = 1 then
    FLicenseDesc.Add(LIC_E_TEXT);

  if ((lLicenseMask shr LIC_F_BIT) and 1) = 1 then
    FLicenseDesc.Add(LIC_F_TEXT);

  if ((lLicenseMask shr LIC_I_BIT) and 1) = 1 then
    FLicenseDesc.Add(LIC_I_TEXT);

  if ((lLicenseMask shr LIC_L_BIT) and 1) = 1 then
    FLicenseDesc.Add(LIC_L_TEXT);

  if ((lLicenseMask shr LIC_P_BIT) and 1) = 1 then
    FLicenseDesc.Add(LIC_P_TEXT);

  if ((lLicenseMask shr LIC_Q_BIT) and 1) = 1 then
    FLicenseDesc.Add(LIC_Q_TEXT);

  if ((lLicenseMask shr LIC_R_BIT) and 1) = 1 then
    FLicenseDesc.Add(LIC_R_TEXT);

  if ((lLicenseMask shr LIC_S_BIT) and 1) = 1 then
    FLicenseDesc.Add(LIC_S_TEXT);

  if ((lLicenseMask shr LIC_W_BIT) and 1) = 1 then
    FLicenseDesc.Add(LIC_W_TEXT)
  else
    FLicenseDesc.Add('Server is limited to ' + IntToStr(FAssignedServer.Server.LicenseInfo.LicensedUsers) + ' users');

  if ((lLicenseMask shr LIC_2_BIT) and 1) = 1 then
    FLicenseDesc.Add(LIC_2_TEXT);

  if ((lLicenseMask shr LIC_3_BIT) and 1) = 1 then
    FLicenseDesc.Add(LIC_3_TEXT);
end;

procedure TfrmServerProperties.FormCreate(Sender: TObject);
begin
  inherited;
  FLicenseDesc := TStringList.Create();
end;

procedure TfrmServerProperties.FormDestroy(Sender: TObject);
begin
  FLicenseDesc.Free;
end;

procedure TfrmServerProperties.WMNCLButtonDown( var Message: TWMNCLButtonDown );
var
  ScreenPt: TPoint;
  ClientPt: TPoint;
begin
  ScreenPt.X := Message.XCursor;
  ScreenPt.Y := Message.YCursor;
  ClientPt := ScreenToClient( ScreenPt );
  if( ClientPt.X > Width-45 )and (ClientPt.X < Width-29) then
   begin
    WinHelp(WindowHandle,CONTEXT_HELP_FILE,HELP_CONTEXT,SERVER_PROPERTIES);
    Message.Result := 0;
  end else
   inherited;
end;

procedure TfrmServerProperties.FormShow(Sender: TObject);
begin
  inherited;
  pgcMain.ActivePage := tabAlias;
  pgcMainChange(Sender);
end;

function TfrmServerProperties.GetNewSettings: TibcServerNode;
begin
  result := FAssignedServer;
end;

procedure TfrmServerProperties.Button1Click(Sender: TObject);
begin
  inherited;
  ModalResult := mrCancel;
end;

end.


