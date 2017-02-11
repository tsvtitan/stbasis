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
*  f r m u D B R e g i s t e r
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Description:  This unit provides an interface for registering
*                a database
*
*****************************************************************
* Revisions:
*
*****************************************************************}

unit frmuDBRegister;

interface

uses
  SysUtils, Forms, ExtCtrls, StdCtrls, Classes, Controls, Dialogs,
  Windows, zluibcClasses, Messages, Registry, frmuDlgClass;

type
  TfrmDBRegister = class(TDialog)
    lblServerName: TLabel;
    stxServerName: TStaticText;
    bvlLine1: TBevel;
    gbDatabase: TGroupBox;
    lblDBAlias: TLabel;
    lblDBFile: TLabel;
    btnSelDBFile: TButton;
    edtDBFile: TEdit;
    edtDBAlias: TEdit;
    chkSaveAlias: TCheckBox;
    gbLoginInfo: TGroupBox;
    lblUsername: TLabel;
    lblPassword: TLabel;
    lblRole: TLabel;
    edtUsername: TEdit;
    edtPassword: TEdit;
    edtRole: TEdit;
    btnOK: TButton;
    btnCancel: TButton;
    cbCaseSensitive: TCheckBox;
    function FormHelp(Command: Word; Data: Integer; var CallHelp: Boolean): Boolean;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnSelDBFileClick(Sender: TObject);
    procedure edtDBFileChange(Sender: TObject);
    procedure edtDBFileExit(Sender: TObject);
    procedure edtRoleChange(Sender: TObject);
  private
    { Private declarations }
    FCurrSelServer : TibcServerNode;
    function VerifyInputData(): boolean;
    procedure WMNCLButtonDown( var Message: TWMNCLBUTTONDOWN ); message WM_NCLBUTTONDOWN ;
  public
    { Public declarations }
  end;

function RegisterDB(var DBAlias,Username,Password,Role: string;
                        DatabaseFiles: TStringList;
                        const SelServer: TibcServerNode;
                        var SaveAlias, CaseSensitive: boolean): boolean;

implementation

uses
   IBServices, frmuMessage, zluGlobal, zluContextHelp, zluUtility;

{$R *.DFM}

{****************************************************************
*
*  R e g i s t e r D B ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  DBAlias   - The database alias
*          DBFile    - The database file, including path
*          Username  - The username to use when connecting to
*                      the database
*          Password  - The password to use when connecting to
*                      the database
*          Role      - The role to use when connecting to the
*                      database
*          SelServer - The specified server
*          SaveAlias - Indicates whether or not to save the alias
*                      information to the registry
*
*  Return: boolean - Indicates the success/failure of the operation
*
*  Description:  Captures the information required in order to
*                register the specified database.  The actual
*                registration of the database is performed by
*                the main form.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function RegisterDB(var DBAlias, Username, Password, Role: string;
  DatabaseFiles: TStringList; const SelServer: TibcServerNode; var SaveAlias, CaseSensitive: boolean): boolean;
var
  frmDBRegister: TfrmDBRegister;
begin
  frmDBRegister := TfrmDBRegister.Create(Application);
  try
    // show servername
    frmDBRegister.stxServerName.Caption := SelServer.NodeName;
    frmDBRegister.FCurrSelServer := SelServer;
    // disable browse button if remote server
    if SelServer.Server.Protocol <> Local then
      frmDBRegister.btnSelDBFile.Enabled := false;
    frmDBRegister.ShowModal;
    if frmDBRegister.ModalResult = mrOK then
    begin
      // set database information
      DBAlias := frmDBRegister.edtDBAlias.Text;

      { Force a path for all databases if the current protocol is local }
      if SelServer.Server.Protocol = Local then
      begin
        if ExtractFilePath(frmDBRegister.edtDBFile.Text) = '' then
          frmDBRegister.edtDBFile.Text := ExtractFilePath(Application.ExeName)+
           frmDBRegister.edtDBFile.Text;
      end;
      DatabaseFiles.Add(frmDBRegister.edtDBFile.Text);
      Username := frmDBRegister.edtUsername.Text;
      Password := frmDBRegister.edtPassword.Text;
      Role := frmDBRegister.edtRole.Text;
      SaveAlias := frmDBRegister.chkSaveAlias.Checked;
      CaseSensitive := frmDBRegister.cbCaseSensitive.Checked;
      result := true;
    end
    else
      result := false;
  finally
    // deallocate memory
    frmDBRegister.Free;
  end;
end;

function TfrmDBRegister.FormHelp(Command: Word; Data: Integer;
  var CallHelp: Boolean): Boolean;
begin
  CallHelp := False;
  // call WinHelp and show Register Database topic
  Result := WinHelp(WindowHandle,CONTEXT_HELP_FILE,HELP_CONTEXT,DATABASE_REGISTER);
end;

procedure TfrmDBRegister.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmDBRegister.btnOKClick(Sender: TObject);
begin
  if VerifyInputData() then
    ModalResult := mrOK;
end;

{****************************************************************
*
*  b t n S e l D B F i l e C l i c k ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  Sender - The object that initiated the event
*
*  Return: None
*
*  Description:  Displays a default windows file open dialog for capturing filenames
*
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmDBRegister.btnSelDBFileClick(Sender: TObject);
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
      edtDBFile.Text := lOpenDialog.FileName;
      // if no dbalias is specified then make it the name of the file
      if (edtDBAlias.Text = '') or (edtDBAlias.Text = ' ') then
      begin
        edtDBAlias.Text := ExtractFileName(edtDbFile.Text);
        if (edtDBAlias.Text = '') or (edtDBAlias.Text = ' ') then
        begin
          edtDBAlias.Text := ExtractFileName(edtDbFile.Text);
        end;
      end;
    end;
  end
  finally
    // deallocate memory
    lOpenDialog.free;
  end;
end;

procedure TfrmDBRegister.edtDBFileChange(Sender: TObject);
begin
  edtDBFile.hint := edtDBFile.text;
end;

procedure TfrmDBRegister.edtDBFileExit(Sender: TObject);
begin
  // if no dbalias is specified then make filename the dbalias
  if (edtDBAlias.Text = '') or (edtDBAlias.Text = ' ') then
  begin
    edtDBAlias.Text := ExtractFileName(edtDbFile.Text);
  end;
  if not (IsValidDBName(edtDBFile.Text)) then
     DisplayMsg(WAR_REMOTE_FILENAME, Format('File: %s', [edtDBFile.Text]));
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
*  Return: Boolean - Indicates the success/failure of the operation
*
*  Description:  Performs some basic validation on data entered by
*                the user
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function TfrmDBRegister.VerifyInputData(): boolean;
var
  lRegistry : TRegistry;
begin
  lRegistry := Nil;
  result := true;

  try
    lRegistry := TRegistry.Create;

    // if no dbalias is specified
    if (edtDBAlias.Text = '') or (edtDBAlias.Text = ' ') then
    begin
      DisplayMsg(ERR_DB_ALIAS,'');       // show error message
      edtDBAlias.SetFocus;               // give focus to control
      result := false;
      Exit;
    end;

    // check for backslash in dbalias
    // If backslashes are used (i.e. for a path), then the registry
    // key will not be created properly
    if Pos('\',edtDBAlias.Text) <> 0 then
    begin
      DisplayMsg(ERR_DB_ALIAS,'');       // show error message
      edtDBAlias.SetFocus;               // give focus to control
      result := false;
      Exit;
    end;

    // if no dbfile is specified
    if (edtDBFile.GetTextLen = 0) then
    begin
      DisplayMsg(ERR_DB_FILE,edtDBFile.Text);        // show error message
      edtDBFile.SetFocus;                            // give focus to control
      result := false;
      Exit;
    end;

    if lRegistry.KeyExists(Format('%s%s\Databases\%s',[gRegServersKey,FCurrSelServer.Nodename,edtDBAlias.Text])) then
    begin                                // show error message
      DisplayMsg(ERR_DB_ALIAS,'This database alias already exists.');
      edtDBAlias.SetFocus;               // give focus to control
      result := false;
      Exit;
    end;


  finally
    lRegistry.Free;
  end;
end;

procedure TfrmDBRegister.WMNCLButtonDown( var Message: TWMNCLButtonDown );
var
  ScreenPt: TPoint;
  ClientPt: TPoint;
begin
  ScreenPt.X := Message.XCursor;
  ScreenPt.Y := Message.YCursor;
  ClientPt := ScreenToClient( ScreenPt );
  if( ClientPt.X > Width-45 )and (ClientPt.X < Width-29) then
   begin
    WinHelp(WindowHandle,CONTEXT_HELP_FILE,HELP_CONTEXT,DATABASE_REGISTER);
    Message.Result := 0;
  end else
   inherited;
end;

procedure TfrmDBRegister.edtRoleChange(Sender: TObject);
begin
  inherited;
  cbCaseSensitive.Enabled := (edtRole.GetTextLen > 0);
end;

end.
