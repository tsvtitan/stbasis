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
*  f r m u S e r v e r R e g i s t e r
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Description:  This unit provides an interface for selecting/
*                registering a server
*
*****************************************************************
* Revisions:
*
*****************************************************************}

unit frmuServerRegister;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, IBServices, frmuDlgClass;

type
  TfrmServerRegister = class(TDialog)
    gbServerInfo: TGroupBox;
    lblServerName: TLabel;
    lblProtocol: TLabel;
    lblServerAlias: TLabel;
    Label1: TLabel;
    cbProtocol: TComboBox;
    edtServerName: TEdit;
    rbLocalServer: TRadioButton;
    rbRemoteServer: TRadioButton;
    edtServerAlias: TEdit;
    chkSaveAlias: TCheckBox;
    edtDescription: TEdit;
    gbLoginInfo: TGroupBox;
    lblUsername: TLabel;
    lblPassword: TLabel;
    edtUsername: TEdit;
    edtPassword: TEdit;
    btnOK: TButton;
    btnCancel: TButton;
    function FormHelp(Command: Word; Data: Integer;var CallHelp: Boolean): Boolean;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure rbLocalServerClick(Sender: TObject);
    procedure rbRemoteServerClick(Sender: TObject);
  private
    { Private declarations }
    FAction: word;
    function VerifyInputData(): boolean;
    procedure WMNCLButtonDown( var Message: TWMNCLBUTTONDOWN ); message WM_NCLBUTTONDOWN ;
  public
    { Public declarations }
  end;

function RegisterServer(var ServerName,ServerAlias,UserName,Password, Description: string;  var Protocol: TProtocol; const SelAction: word; var SaveAlias: boolean): integer;

implementation

uses
  frmuMessage, zluGlobal, zluContextHelp, zluUtility;

{$R *.DFM}


{****************************************************************
*
*  R e g i s t e r S e r v e r ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  ServerName  - The server name
*          ServerAlias - The server alias
*          UserName    - The username to use when connecting to
*                        the server
*          Password    - The password to use when connecting to
*                        the server
*          Protocol    - The protocol to use when connecting to
*                        the server
*          SelAction   - The action to perform, Register/Select
*          SaveAlias   - Indicates whether or not to save the
*                        alias info to the registry
*
*  Return: integer - Indicates the success/failure of the operation
*
*  Description:  Registers/Selects a server based on the action specified
*                by SelAction
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function RegisterServer(var ServerName,ServerAlias,UserName,Password, Description: string; var Protocol: TProtocol; const SelAction: word; var SaveAlias: boolean): integer;
var
  frmServerRegister: TfrmServerRegister;
begin
  frmServerRegister:= TfrmServerRegister.Create(Application);
  try
    with frmServerRegister do
    begin
      // determine which form caption to use based on the SelAction
      if SelAction = SELECT_SERVER then
      begin
        Caption := 'Select Server and Connect';
      end
      else
      begin
        Caption := 'Register Server and Connect';
      end;
      FAction := SelAction;

      // if the SelAction is to select a server then disable radio buttons
      if FAction = SELECT_SERVER then
      begin
        rbLocalServer.Enabled := false;
        rbRemoteServer.Enabled := false;
      end
      else
      begin
        { if the local server is running, then check the box to register it
          if the local server is not registered }
        if IsIBRunning and not IsServerRegistered('Local Server') then
        begin
          rbLocalServer.Checked := true;
          rbLocalServer.OnClick (nil);
        end
        else
        begin
          rbRemoteServer.Checked := true;
          rbRemoteServer.OnClick (nil);          
        end;

        if IsServerRegistered('Local Server') then
          rbLocalServer.Enabled := false;
      end;

      ShowModal;

      // if all fields pass validity checks
      if ModalResult = mrOK then
      begin
        // if Local Server radio button is selected
        if rbLocalServer.Checked then
        begin
          Protocol := Local;           // set local server properties
          ServerName := 'Local Server';
          ServerAlias := 'Local Server';
          Description := edtDescription.Text;          
        end
        else                           // otherwise
        begin
          case cbProtocol.ItemIndex of // determine which protocol was selected
            0: Protocol := TCP;
            1: Protocol := NamedPipe;
            2: Protocol := SPX;
          end;
          ServerName := edtServerName.Text;
          ServerAlias := edtServerAlias.Text;
          Description := edtDescription.Text;
        end;
        UserName := edtUsername.Text;  // set username based on user input
        Password := edtPassword.Text;  // set password based on user input
        SaveAlias := chkSaveAlias.Checked;
        result := SUCCESS;
      end
      else
        result := FAILURE;
    end;
  finally
    // deallocate memory
    frmServerRegister.Free;
  end;
end;

function TfrmServerRegister.FormHelp(Command: Word; Data: Integer;
  var CallHelp: Boolean): Boolean;
begin
  CallHelp := False;
  // call WinHelp and show Register Server topic
  Result := WinHelp(WindowHandle,CONTEXT_HELP_FILE,HELP_CONTEXT,SERVER_REGISTER);
end;

procedure TfrmServerRegister.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmServerRegister.btnOKClick(Sender: TObject);
begin
  if VerifyInputData() then
    ModalResult := mrOK;
end;

{****************************************************************
*
*  r b L o c a l S e r v e r C l i c k ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  Sender - The object initiating the event
*
*  Return: None
*
*  Description:  Enables/disables controls based on the state
*                of the radio button (Checked/Uncheked)
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmServerRegister.rbLocalServerClick(Sender: TObject);
begin
  // enable/disable controls based on which server radio button is selected
  if rbLocalServer.Checked then
  begin
    edtServerName.text := '';
    edtServerName.Enabled := false;
    edtServerAlias.Enabled := false;
    cbProtocol.ItemIndex := -1;
    cbProtocol.Enabled := false;
    edtServerName.Color := clSilver;
    edtServerAlias.Color := clSilver;
    cbProtocol.Color := clSilver;
  end
  else
  begin
    edtServerName.Enabled := true;
    edtServerAlias.Enabled := true;
    cbProtocol.Enabled := true;
    edtServerName.Color := clWhite;
    cbProtocol.Color := clWhite;
    edtServerAlias.Color := clWhite;
  end
end;

{****************************************************************
*
*  r b R e m o t e S e r v e r C l i c k ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  Sender - The object initiating the event
*
*  Return: None
*
*  Description:  Enables/disables controls based on the state
*                of the radio button (Checked/Uncheked)
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmServerRegister.rbRemoteServerClick(Sender: TObject);
begin
  // enable/disable controls based on which server radio button is selected
  if rbRemoteServer.Checked then
  begin
    edtServerName.Enabled := true;
    cbProtocol.Enabled := true;
    edtServerAlias.Enabled := true;
    edtServerName.Color := clWhite;
    cbProtocol.Color := clWhite;
    edtServerAlias.Color := clWhite;
  end
  else
  begin
    edtServerName.Enabled := false;
    cbProtocol.Enabled := false;
    edtServerAlias.Enabled := false;
    edtServerName.Color := clSilver;
    cbProtocol.Color := clSilver;
    edtServerAlias.Color := clSilver;
  end
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
function TfrmServerRegister.VerifyInputData(): boolean;
begin
  result := true;

  // if the remote server radio button is selected
  if rbRemoteServer.Checked then
  begin
    // if no servername is specified
    if (edtServerName.Text = '') or (edtServerName.Text = ' ') then
    begin
      DisplayMsg(ERR_SERVER_NAME,'');  // show error message
      edtServerName.SetFocus;          // give focus to control
      result := false;
      Exit;
    end;

    // if no protocol is selected
    if (cbProtocol.Text = '') or (cbProtocol.Text = ' ') then
    begin
      DisplayMsg(ERR_PROTOCOL,'');     // show error message
      cbProtocol.SetFocus;             // give focus to control
      result := false;
      Exit;
    end;

    // if no server alias is specified
    if (edtServerAlias.Text = '') or (edtServerAlias.Text = ' ') then
    begin
      DisplayMsg(ERR_SERVER_ALIAS,'');   // show error message
      edtServerAlias.SetFocus;           // give focus to control
      result := false;
      Exit;
    end;
  end;

  // if the selected action is to select a server
  if FAction = SELECT_SERVER then
  begin
    // if no username is specified
    if (edtUsername.Text = '') or (edtUsername.Text = ' ') then
    begin
      DisplayMsg(ERR_USERNAME,'');     // show error message
      edtUsername.SetFocus;            // give focus to control
      result := false;
      Exit;
    end;

    // if no password is specified
    if (edtPassword.Text = '') or (edtPassword.Text = ' ') then
    begin
      DisplayMsg(ERR_PASSWORD,'');     // show error message
      edtPassword.SetFocus;            // give focus to control
      result := false;
      Exit;
    end;
  end;  
end;

procedure TfrmServerRegister.WMNCLButtonDown( var Message: TWMNCLButtonDown );
var
  ScreenPt: TPoint;
  ClientPt: TPoint;
begin
  ScreenPt.X := Message.XCursor;
  ScreenPt.Y := Message.YCursor;
  ClientPt := ScreenToClient( ScreenPt );
  if( ClientPt.X > Width-45 )and (ClientPt.X < Width-29) then
   begin
    WinHelp(WindowHandle,CONTEXT_HELP_FILE,HELP_CONTEXT,SERVER_REGISTER);
    Message.Result := 0;
  end else
   inherited;
end;

end.
