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
*  f r m u U s e r
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Description:  This unit provides an interface for managing
*                user accounts
*
*****************************************************************
* Revisions:
*
*****************************************************************}

unit frmuUser;

interface

uses
  Windows, SysUtils, Forms, ExtCtrls, StdCtrls, Classes, Controls, Dialogs,
  IBServices, zluibcClasses, Graphics, Messages, frmuDlgClass, ActnList;

type
  TfrmUserInfo = class(TDialog)
    btnNew: TButton;
    btnApply: TButton;
    btnDelete: TButton;
    btnClose: TButton;
    btnCancel: TButton;
    gbOptionalInfo: TGroupBox;
    lblFName: TLabel;
    lblMName: TLabel;
    lblLName: TLabel;
    edtLName: TEdit;
    edtFName: TEdit;
    edtMName: TEdit;
    gbRequiredInfo: TGroupBox;
    lblPassword: TLabel;
    lblConfirmPassword: TLabel;
    lblUserName: TLabel;
    edtUsername: TEdit;
    cbUsername: TComboBox;
    edtPassword: TEdit;
    edtConfirmPassword: TEdit;
    ActionList1: TActionList;
    NewUser: TAction;
    ModifyUser: TAction;
    DeleteUser: TAction;
    function FormHelp(Command: Word; Data: Integer; var CallHelp: Boolean): Boolean;
    procedure btnApplyClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure cbUsernameChange(Sender: TObject);
    procedure cbUsernameClick(Sender: TObject);
    procedure edtConfirmPasswordChange(Sender: TObject);
    procedure edtFNameChange(Sender: TObject);
    procedure edtLNameChange(Sender: TObject);
    procedure edtMNameChange(Sender: TObject);
    procedure edtPasswordChange(Sender: TObject);
    procedure edtUsernameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DeleteUserUpdate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FConfirmPassword: string;
    FCurrSelServer: TibcServerNode;
    FPassword: string;
    FSecurityService: TIBSecurityService;
    FUserInfo : array of TUserInfo;
    function GetUserInfo(): boolean;
    function GetUserList(): boolean;
    function VerifyInputData(): boolean;
    procedure GetUsers(const idx: integer = -1);
    procedure WMNCLButtonDown( var Message: TWMNCLBUTTONDOWN ); message WM_NCLBUTTONDOWN ;
  public
    { Public declarations }
    AddNew: boolean;
  end;

  function UserInfo(var CurrSelServer: TibcServerNode;
    const CurrSelUser: string;
    const AddNew: boolean = false): boolean;

implementation

uses
  IB, frmuMessage, zluGlobal, zluContextHelp, zluUtility, frmuMain, IBErrorCodes;

{$R *.DFM}

const
  DUMMY_PASSWORD = 'TheyKilledKennyAgain';


{****************************************************************
*
*  U s e r I n f o ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  CurrSelServer - The currently selected server
*          CurrSelUser   - The currently selected username if any,
*                          else ''
*
*  Return: Boolean - Indicates the success/failure of the operation
*
*  Description:  Creates an instance of TIBSecurityService, and establishes
*                a connection to the server. If it is successful it also
*                creates an instance of the User Information form
*                Once the form is closed it returns control to the
*                calling function.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function UserInfo(var CurrSelServer: TibcServerNode;
  const CurrSelUser: string;
  const AddNew: boolean = false): boolean;
var
  frmUserInfo: TfrmUserInfo;
  lSecurityService: TIBSecurityService;
begin
  lSecurityService := TIBSecurityService.Create(nil);
  try
    try
      // fill in security service details
      lSecurityService.LoginPrompt := false;
      lSecurityService.ServerName := CurrSelServer.Server.ServerName;
      lSecurityService.Protocol := CurrSelServer.Server.Protocol;
      lSecurityService.Params.Assign(CurrSelServer.Server.Params);
      lSecurityService.Attach();       // attach to server
    except
      on E:EIBError do                 // if an exception occurs then trap it
      begin                            // and show error message
        DisplayMsg(ERR_SERVER_LOGIN, E.Message);
        result := false;
        if (E.IBErrorCode = isc_lost_db_connection) or
           (E.IBErrorCode = isc_unavailable) or
           (E.IBErrorCode = isc_network_error) then
          frmMain.SetErrorState;
        Exit;
      end;
    end;

    // if attached to server successfully
    if lSecurityService.Active = true then
    begin
      // create an instance of the user info form
      frmUserInfo := TfrmUserInfo.Create(Application);
      try
        frmUserInfo.FSecurityService := lSecurityService;
        frmUserInfo.FCurrSelServer := CurrSelServer;
        frmUserInfo.GetUserList();     // get a list of users in security database
        frmUserInfo.GetUsers;
        frmUserInfo.cbUsername.Hint := frmUserInfo.cbUsername.Text;

        // if there is a valid user
        if CurrSelUser <> '' then
        begin
          // show user along with user info
          frmUserInfo.cbUsername.ItemIndex := frmUserInfo.cbUsername.Items.IndexOf(CurrSelUser);
          frmUserInfo.cbUsernameClick(frmUserInfo);

          if UpperCase(CurrSelUser) = 'SYSDBA' then
            frmUserInfo.btnDelete.Enabled := false;
        end;
        frmUserInfo.AddNew := AddNew;
        frmUserInfo.ShowModal;
        Application.ProcessMessages;
      finally
        // deallocate memory
        frmUserInfo.Free;
      end;
      result := true;
    end
    else
      result := false;
  finally
    // if attached to server then detach
    if lSecurityService.Active then
      lSecurityService.Detach();
    // deallocate memory
    lSecurityService.Free();
  end;
end;

function TfrmUserInfo.FormHelp(Command: Word; Data: Integer;
  var CallHelp: Boolean): Boolean;
begin
  CallHelp := False;
  // call WinHelp and show server security topic
  Result := WinHelp(WindowHandle,CONTEXT_HELP_FILE,HELP_CONTEXT,SERVER_SECURITY);
end;

{****************************************************************
*
*  b t n A p p l y C l i c k ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  Sender - The object initiating the event
*
*  Return: None
*
*  Description:  Adds/Modifies a user in the security database
*                depending on the current mode (insert/edit)
*                which is determined by the visibility of edtUsername
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmUserInfo.btnApplyClick(Sender: TObject);
var
  lUserCount : Integer;
begin
  { Get the information first }
  FPassword := edtPassword.Text;
  FConfirmPassword := edtConfirmPassword.Text;
  lUserCount := -1;  
  // if all fields pass validity checks
  if VerifyInputData() then
  begin
     Screen.Cursor := crHourGlass;     // change cursor to hourglass
    try
      // if not attached to server then attach
      if not FSecurityService.Active then
      begin
        FSecurityService.Params.Clear;
        FSecurityService.Params.Assign(FCurrSelServer.Server.Params);
        FSecurityService.Attach();
      end;

      // if attached to server
      if FSecurityService.Active then
      begin
        // if the username edit box is visible
        // then this is a new user being added to the security database
        if edtUsername.Visible then
        begin
          // fill in security service details regarding user
          FSecurityService.UserName := edtUsername.Text;
          FSecurityService.Password := edtPassword.Text;
          FSecurityService.FirstName := edtFName.Text;
          FSecurityService.MiddleName := edtMName.Text;
          FSecurityService.LastName := edtLName.Text;
          try
            // try adding user to security database
            FSecurityService.AddUser();
            while (FSecurityService.IsServiceRunning) and (not gApplShutdown) do
            begin
              Application.ProcessMessages;
            end;
                                                                              
            // add to FUserInfo cache
            // first find last user
            lUserCount := 0;
            while (lUserCount < Length(FUserInfo)) and (FUserInfo[lUserCount].Username <> '') do
            begin
              Inc(lUserCount);
            end;

            // if count is less then length then a hole was found
            // fill hole with new user infomation
            if lUserCount < Length(FUserInfo) then
            begin
              FUserInfo[lUserCount].Username := UpperCase(edtUsername.Text);
              FUserInfo[lUserCount].FirstName := edtFName.Text;
              FUserInfo[lUserCount].MiddleName := edtMName.Text;
              FUserInfo[lUserCount].LastName := edtLName.Text;
            end
            else                       // if no hole found then add to end
            begin
              if lUserCount >= Length(FUserInfo) then
                SetLength(FUserInfo, lUserCount + 10);

              FUserInfo[lUserCount].Username := UpperCase(edtUsername.Text);
              FUserInfo[lUserCount].FirstName := edtFName.Text;
              FUserInfo[lUserCount].MiddleName := edtMName.Text;
              FUserInfo[lUserCount].LastName := edtLName.Text;
            end;
          except                       // if an exception occurs then trap it
            on E:EIBError do           // and show error message
            begin
              DisplayMsg(ERR_ADD_USER, E.Message);
              if (E.IBErrorCode = isc_lost_db_connection) or
                 (E.IBErrorCode = isc_unavailable) or
                 (E.IBErrorCode = isc_network_error) then
                frmMain.SetErrorState;
              SetErrorState;
              Screen.Cursor := crDefault;    // change cursor back to default              
              exit;
            end;
          end;
        end
        else
        begin
          // if edit box isn't visible then the current
          // user is being modified in the security database

          // use current username
          FSecurityService.UserName := cbUsername.Text;

          // find index in list
          lUserCount := cbUsername.Items.IndexOf(cbUsername.Text);

          // fill in security service details regarding user
          if edtPassword.Text <> DUMMY_PASSWORD then
            FSecurityService.Password := edtPassword.Text;

          // IBX cannot modify an existing field to blank so
          // if field is blank make it a space
          if edtFName.Text = '' then edtFName.Text := ' ';
          if edtMName.Text = '' then edtMName.Text := ' ';
          if edtLName.Text = '' then edtLName.Text := ' ';
          FSecurityService.FirstName := edtFName.Text;
          FSecurityService.MiddleName := edtMName.Text;
          FSecurityService.LastName := edtLName.Text;
          if edtFName.Text = ' ' then edtFName.Text := '';
          if edtMName.Text = ' ' then edtMName.Text := '';
          if edtLName.Text = ' ' then edtLName.Text := '';

          try
            // try modifying the user in the security database
            FSecurityService.ModifyUser();
            while (FSecurityService.IsServiceRunning) and (not gApplShutdown) do
            begin
              Application.ProcessMessages;
            end;

            // if the user being modified is currently connected
            if FCurrSelServer.UserName = cbUsername.Text then
            begin
              // disconnect from the server
              // and reconnect using the new user information
              if edtPassword.Text <> DUMMY_PASSWORD then
                FCurrSelServer.Password := edtPassword.Text;
              FCurrSelServer.Server.Detach();
              FCurrSelServer.Server.Params.Clear;
              FCurrSelServer.Server.Params.Add(Format('isc_spb_user_name=%s',[FCurrSelServer.UserName]));
              FCurrSelServer.Server.Params.Add(Format('isc_spb_password=%s',[FCurrSelServer.Password]));
              FCurrSelServer.Server.Attach();
              Application.ProcessMessages;

              if FSecurityService.Active then
                FSecurityService.Detach();

              FSecurityService.Params.Clear;
              FSecurityService.Params.Assign(FCurrSelServer.Server.Params);
              FSecurityService.Attach();
            end;

            FUserInfo[lUserCount].FirstName := edtFName.Text;
            FUserInfo[lUserCount].MiddleName := edtMName.Text;
            FUserInfo[lUserCount].LastName := edtLName.Text;

          except                       // if an exception occurs then trap it
            on E:EIBError do           // and show error message
            begin
              DisplayMsg(ERR_MODIFY_USER, E.Message);
              if (E.IBErrorCode = isc_lost_db_connection) or
                 (E.IBErrorCode = isc_unavailable) or
                 (E.IBErrorCode = isc_network_error) then
                frmMain.SetErrorState;
              Screen.Cursor := crDefault;    // change cursor back to default
              SetErrorState;
              exit;
            end;
          end;
        end;
      end;
    finally
      begin
        // change form back to the display user state
        cbUserName.Visible := true;
        edtUsername.Visible := false;
        btnNew.Enabled := true;
        btnApply.Enabled := false;
        btnDelete.Enabled := true;
        btnClose.Visible := true;
        btnCancel.Visible := false;
        lblUserName.FocusControl := cbUserName;
        cbUserName.SetFocus;
        GetUsers (lUserCount);
        Screen.Cursor := crDefault;    // change cursor back to default
      end;
    end;
  end;
end;

procedure TfrmUserInfo.btnCancelClick(Sender: TObject);
begin
  // change form back to the display user state
  cbUserName.Visible := true;
  edtUsername.Visible := false;
  btnNew.Enabled := true;
  btnApply.Enabled := false;
  btnDelete.Enabled := true;
  btnClose.Visible := true;
  btnCancel.Visible := false;
  lblUserName.FocusControl := cbUserName;
  cbUserName.SetFocus;
  //GetUserList;
  GetUsers;
end;

procedure TfrmUserInfo.btnCloseClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

{****************************************************************
*
*  b t n D e l e t e C l i c k ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  Sender - The object initiating the event
*
*  Return: None
*
*  Description:  Deletes a user from the security database
*                after confirmation from the user
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmUserInfo.btnDeleteClick(Sender: TObject);
var
  lUserCount : Integer;
  i          : Integer;
  lConfirmed : Boolean;
begin
  lConfirmed := False;

  if not btnDelete.Enabled then
    exit;
  // show confirmation dialog
  if cbUsername.Text = UpperCase(FCurrSelServer.UserName) then
  begin
    if MessageDlg(Format('The user you wish to delete is the same user you are logged into the server as.%sAre you sure that you want to delete user: %s?',
        [#13#10,cbUsername.Text]),mtConfirmation, mbOkCancel, 0) = mrOK then
      lConfirmed := True;
  end
  else
  begin
    if MessageDlg(Format('Are you sure that you want to delete user: %s?',
        [cbUsername.Text]),mtConfirmation, mbOkCancel, 0) = mrOK then
      lConfirmed := True;
  end;

  if lConfirmed then
  begin
    // if the user chooses to proceed
    try
      Screen.Cursor := crHourGlass;    // change cursor to hourglass
      try
        // if security server is not attached
        if not FSecurityService.Active then
        begin
          // attach to server
          FSecurityService.Params.Clear;
          FSecurityService.Params.Assign(FCurrSelServer.Server.Params);
          FSecurityService.Attach();
        end;

        // if security service is attached
        if FSecurityService.Active then
        begin
          // delete user
          FSecurityService.UserName := cbUsername.Text;
          FSecurityService.DeleteUser();
        end;

        while (FSecurityService.IsServiceRunning) and (not gApplShutdown) do
        begin
          Application.ProcessMessages;
        end;

        // delete user from cache
        i := cbUsername.Items.IndexOf(cbUsername.Text);
        if i <> -1 then
        begin
          lUserCount := i;
          while lUserCount < High(FUserInfo) do
          begin
            FUserInfo[lUserCount] := FUserInfo[lUserCount+1];
            Inc(lUserCount);
          end;
        end;
      except                           // if an exception occurs then trap it
        on E:EIBError do               // and display an error message
        begin
          DisplayMsg(ERR_DELETE_USER, E.Message);
          if (E.IBErrorCode = isc_lost_db_connection) or
             (E.IBErrorCode = isc_unavailable) or
             (E.IBErrorCode = isc_network_error) then
            frmMain.SetErrorState;
          SetErrorState;
          Screen.Cursor := crDefault;    // change cursor back to default          
          exit;
        end;
      end;
    finally
      begin
        GetUsers;
        Screen.Cursor := crDefault;    // change hour glass to default
      end;
    end;
  end;
end;

{****************************************************************
*
*  b t n N e w C l i c k ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  Sender - The object initiating the event
*
*  Return: None
*
*  Description:  Initializes the forms controls in order to receive
*                new user information
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmUserInfo.btnNewClick(Sender: TObject);
begin
  // change form to the add user state
  cbUsername.Visible := false;
  edtUsername.Visible := true;
  edtUserName.Text := '';
  edtPassword.Text := '';
  edtConfirmPassword.Text := '';
  edtFName.Text := '';
  edtMName.Text := '';
  edtLName.Text := '';
  cbUsername.Enabled := true;
  cbUserName.Color := clWhite;
  edtPassword.Enabled := true;
  edtPassword.Color := clWhite;
  edtConfirmPassword.Enabled := true;
  edtConfirmPassword.Color := clWhite;
  edtFName.Enabled := true;
  edtFName.Color := clWhite;
  edtMName.Enabled := true;
  edtMName.Color := clWhite;
  edtLName.Enabled := true;
  edtLName.Color := clWhite;
  btnNew.Enabled := false;
  btnApply.Enabled := false;
  btnDelete.Enabled := false;
  btnCancel.Visible := true;
  btnClose.Visible := false;
  lblUserName.FocusControl := edtUserName;
  edtUserName.SetFocus;
end;

procedure TfrmUserInfo.cbUsernameChange(Sender: TObject);
begin
  if UpperCase (cbUserName.Text) = 'SYSDBA' then
    btnDelete.Enabled := false
  else
    btnDelete.Enabled := true;
  cbUsername.Hint := cbUsername.Text;  // assign current name in combo to hint
end;

procedure TfrmUserInfo.cbUsernameClick(Sender: TObject);
begin
  if GetUserInfo() then                // get user info
  begin                                // if info was returned
    btnNew.Enabled := true;            // change form to display user state
    btnApply.Enabled := false;
    btnDelete.Enabled := true;
    btnCancel.Visible := false;
    btnClose.Visible := true;
  end
  else                                 // otherwise change form to display
  begin                                // user state and
    btnNew.Enabled := true;
    btnApply.Enabled := false;
    btnDelete.Enabled := false;        // disable the delete buttom
    btnCancel.Visible := false;
    btnClose.Visible := true;
  end;
end;

procedure TfrmUserInfo.edtConfirmPasswordChange(Sender: TObject);
begin
  if edtConfirmPassword.Text = DUMMY_PASSWORD then
    exit;                              // set confirm password
  FConfirmPassword := edtConfirmPassword.Text;
  if (edtUsername.Text <> '') and (edtPassword.Text <> '') and
    (edtConfirmPassword.Text <> '') then
    btnApply.Enabled := true;          // enable the password if username changes
end;

procedure TfrmUserInfo.edtFNameChange(Sender: TObject);
begin
  btnApply.Enabled := true;            // enable the apply button if first name changes
end;

procedure TfrmUserInfo.edtLNameChange(Sender: TObject);
begin
  btnApply.Enabled := true;            // enable the apply button if last name changes
end;

procedure TfrmUserInfo.edtMNameChange(Sender: TObject);
begin
  btnApply.Enabled := true;            // enable the apply button if middle name changes
end;

procedure TfrmUserInfo.edtPasswordChange(Sender: TObject);
begin
  if edtPassword.GetTextLen > 0 then
    btnApply.Enabled := true;
end;

procedure TfrmUserInfo.edtUsernameChange(Sender: TObject);
begin
  if edtUserName.GetTextLen > 0 then
    btnApply.Enabled := true;
end;

{****************************************************************
*
*  G e t U s e r I n f o ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  None
*
*  Return: Boolean - Indicates the success/failure of the operation
*
*  Description:  Retrieves account information for a single user
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function TfrmUserInfo.GetUserInfo(): boolean;
var
  lUserInfo: TUserInfo;
  i : Integer;
begin
  Result := True;
  try
    Screen.Cursor := crHourGlass;
    i := cbUsername.Items.IndexOf(cbUsername.Text);
    if i <> -1 then
    begin
      lUserInfo := FUserInfo[i];
      edtPassword.Text := DUMMY_PASSWORD;
      FPassword := '';
      edtConfirmPassword.text := DUMMY_PASSWORD;
      FConfirmPassword := '';
      edtFName.Text := lUserInfo.FirstName;
      edtMName.Text := lUserInfo.MiddleName;
      edtLName.Text := lUserInfo.LastName;
    end
    else
      Result := False;
  finally
    Screen.Cursor := crDefault;      // change cursor to default
  end;
end;

{****************************************************************
*
*  G e t U s e r L i s t ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  None
*
*  Return: Boolean - Indicates the success/failure of the operation
*
*  Description:  Retrieves a list of existing users in the security
*                database and enables/disables the appropriate
*                controls based on the success/failure of the operation
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function TfrmUserInfo.GetUserList(): boolean;
var
  lUserCount: integer;
  lPrevUsername : String;
begin
  result := true;
  try
    Screen.Cursor := crHourGlass;      // change cursor to hourglass

    cbUsername.Items.Clear;            // clear all items from combo box
    try
      // if security service isn't attached then attach
      if not FSecurityService.Active then
      begin
        FSecurityService.Params.Clear;
        FSecurityService.Params.Assign(FCurrSelServer.Server.Params);
        FSecurityService.Attach();
      end;

      // if security service is attached then get user info
      if FSecurityService.Active then
        FSecurityService.DisplayUsers();

      while (FSecurityService.IsServiceRunning) and (not gApplShutdown) do
      begin
        Application.ProcessMessages;
      end;

      lUserCount := 0;
      lPrevUsername := '';
      FUserInfo[lUserCount] := FSecurityService.UserInfo[lUserCount];

      // go through list of users and add to combo box
      while (FUserInfo[lUserCount].UserName <> '') and (FUserInfo[lUserCount].UserName <> lPrevUsername) do
      begin
        lPrevUsername := FUserInfo[lUserCount].UserName;
        inc(lUserCount);

        if (lUserCount >= Length(FUserInfo)) then
          SetLength(FUserInfo, (lUserCount + 10));

        if lPrevUsername <> FSecurityService.UserInfo[lUserCount].Username then
          FUserInfo[lUserCount] := FSecurityService.UserInfo[lUserCount];
      end;

    except                             // if an exception occurs then trap it
      on E:EIBError do                 // and show error message
      begin
        DisplayMsg(ERR_GET_USERS, E.Message);
        result := false;
        if (E.IBErrorCode = isc_lost_db_connection) or
           (E.IBErrorCode = isc_unavailable) or
           (E.IBErrorCode = isc_network_error) then
          frmMain.SetErrorState;
        SetErrorState;
      end;
    end;
  finally
    Screen.Cursor := crDefault;        // change cursor to default
  end;
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
function TfrmUserInfo.VerifyInputData(): boolean;
var
  i: integer;
begin
  result := true;

  // if the form is in the add user state
  if edtUsername.Visible then
  begin
    // check if any data was entered in the username edit box
    if (edtUsername.Text = '') or (edtUsername.Text = ' ') then
    begin                              // if not then show
      DisplayMsg(ERR_USERNAME,'');     // error message
      edtUsername.SetFocus;            // and give the control focus
      result := false;
      btnApply.Enabled := false;      
      Exit;
    end;

    // check if a password was supplied or if it's been changed from the dummy password
    if (FPassword = '') or (FPassword = ' ') or (FPassword = DUMMY_PASSWORD) then
    begin                              // if not then show
      DisplayMsg(ERR_PASSWORD,'');     // error message
      edtPassword.SetFocus;            // and give the control focus
      result := false;
      btnApply.Enabled := false;      
      Exit;
    end;
  end;

  // check if the password and confirmation password are the same
  i := CompareStr(FPassword,FConfirmPassword);
  if i <> 0 then
  begin                                // if not then show error message
    DisplayMsg(ERR_PASSWORD_MISSMATCH,'');
    edtPassword.Text := DUMMY_PASSWORD;
    edtConfirmPassword.Text := DUMMY_PASSWORD;
    edtPassword.SetFocus;       // and give the control focus
    btnApply.Enabled := false;
    result := false;
  end;
end;

procedure TfrmUserInfo.GetUsers(const idx: integer = -1);
var
  lUserCount : Integer;
begin
  try
    lUserCount := 0;
    cbUsername.Items.Clear;

    while (lUserCount <= High(FUserInfo)) and (FUserInfo[lUserCount].Username <> '') do
    begin
      cbUsername.Items.Add(FUserInfo[lUserCount].Username);
      Inc(lUserCount);
    end;

    if cbUsername.Items.Count > 0 then // if there are users then
    begin                              // change form to display user state
      btnDelete.Enabled := true;
      cbUsername.Enabled := true;
      cbUserName.Color := clWhite;
      edtPassword.Enabled := true;
      edtPassword.Color := clWhite;
      edtConfirmPassword.Enabled := true;
      edtConfirmPassword.Color := clWhite;
      edtFName.Enabled := true;
      edtFName.Color := clWhite;
      edtMName.Enabled := true;
      edtMName.Color := clWhite;
      edtLName.Enabled := true;
      edtLName.Color := clWhite;
      if idx >= 0 then
        cbUsername.ItemIndex := idx
      else
        cbUsername.ItemIndex := 0;      
      cbUsernameClick(Self);
    end
    else                               // otherwise change form to display
    begin                              // user state and disable the
      btnDelete.Enabled := false;      // delete button
      cbUsername.Enabled := false;     // also grey out user info fields
      cbUserName.Color := clSilver;
      edtPassword.Enabled := false;
      edtPassword.Color := clSilver;
      edtConfirmPassword.Enabled := false;
      edtConfirmPassword.Color := clSilver;
      edtFName.Enabled := false;
      edtFName.Color := clSilver;
      edtMName.Enabled := false;
      edtMName.Color := clSilver;
      edtLName.Enabled := false;
      edtLName.Color := clSilver;
      cbUsernameClick(Self);
    end;
  finally

  end;
end;

procedure TfrmUserInfo.FormCreate(Sender: TObject);
begin
  inherited;
  SetLength(FUserInfo, 10);
end;

procedure TfrmUserInfo.WMNCLButtonDown( var Message: TWMNCLButtonDown );
var
  ScreenPt: TPoint;
  ClientPt: TPoint;
begin
  ScreenPt.X := Message.XCursor;
  ScreenPt.Y := Message.YCursor;
  ClientPt := ScreenToClient( ScreenPt );
  if( ClientPt.X > Width-45 )and (ClientPt.X < Width-29) then
   begin
    WinHelp(WindowHandle,CONTEXT_HELP_FILE,HELP_CONTEXT,SERVER_SECURITY);
    Message.Result := 0;
  end else
   inherited;
end;

procedure TfrmUserInfo.DeleteUserUpdate(Sender: TObject);
begin
  inherited;
  (Sender as TAction).Enabled := (UpperCase(CbUserName.Text) = 'SYSDBA');
end;

procedure TfrmUserInfo.FormShow(Sender: TObject);
begin
  inherited;
  if AddNew then
    btnNew.Click;
  cbUserNameChange(Sender);
end;

end.
