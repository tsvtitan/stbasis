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
*  f r m u M e s s a g e
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Description:  This unit provides a default message display
*                window used throughout the application
*
*****************************************************************
* Revisions:
*
*****************************************************************}

unit frmuMessage;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, frmuDlgClass;

type
  TfrmMessage = class(TDialog)
    imgWarning: TImage;
    imgInformation: TImage;
    imgError: TImage;
    stxSummaryMsg: TStaticText;
    lblDetailMsg: TLabel;
    btnOK: TButton;
    memDetailMsg: TMemo;
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Const
  {Global Errors - (0001-2999}
  ERR_SYSTEM_INIT = 0001;
  ERR_USERNAME = 0002;
  ERR_PASSWORD = 0003;
  ERR_PASSWORD_MISSMATCH = 0004;
  ERR_ADD_USER = 0005;
  ERR_MODIFY_USER = 0006;
  ERR_DELETE_USER = 0007;
  ERR_GET_USERS = 0008;
  ERR_GET_USER_INFO = 0009;
  ERR_SOURCE_DB = 0010;
  ERR_DESTINATION_DB = 0011;
  ERR_SAME_SOURCE_DESTINATION = 0012;
  ERR_DB_FILE = 0013;
  ERR_SERVER_NAME = 0014;
  ERR_PROTOCOL = 0015;
  ERR_BACKUP_DB = 0016;
  ERR_RESTORE_DB = 0017;
  ERR_GET_TABLES = 0018;
  ERR_GET_VIEWS = 0019;
  ERR_SERVICE = 0020;
  ERR_INVALID_CERTIFICATE = 0024;
  ERR_NUMERIC_VALUE = 0025;
  ERR_GET_TABLE_DATA = 0026;
  ERR_DB_ALIAS = 0027;
  ERR_GET_ROLES = 0028;
  ERR_SERVER_LOGIN = 0029;
  ERR_DB_CONNECT = 0030;
  ERR_DB_DISCONNECT = 0031;
  ERR_GET_PROCEDURES = 0032;
  ERR_GET_FUNCTIONS = 0033;
  ERR_GET_GENERATORS = 0034;
  ERR_GET_EXCEPTIONS = 0035;
  ERR_GET_BLOB_FILTERS = 0036;
  ERR_GET_COLUMNS = 0037;
  ERR_GET_INDICES = 0038;
  ERR_GET_REFERENTIAL_CONST = 0039;
  ERR_GET_UNIQUE_CONST = 0040;
  ERR_GET_CHECK_CONST = 0041;
  ERR_GET_TRIGGERS = 0042;
  ERR_GET_DDL = 0043;
  ERR_INVALID_PROPERTY_VALUE = 0044;
  ERR_GET_DEPENDENCIES = 0045;
  ERR_GET_DB_PROPERTIES = 0046;
  ERR_DB_SIZE = 0047;
  ERR_ISQL_ERROR = 0048;
  ERR_SERVER_SERVICE = 0049;
  ERR_EXTERNAL_EDITOR = 0050;
  ERR_SERVER_ALIAS = 0051;
  ERR_BACKUP_ALIAS = 0052;
  ERR_DB_SHUTDOWN = 0053;
  ERR_MODIFY_DB_PROPERTIES = 0054;
  ERR_DROP_DATABASE = 0055;
  ERR_FILE_OPEN = 0056;
  ERR_INV_EDITOR = 0057;
  ERR_EDITOR_MISSING = 0058;
  ERR_BAD_FORMAT = 0059;
  ERR_INV_DIALECT = 0060;
  ERR_FOPEN = 0061;
  ERR_TEXT_NOT_FOUND = 0062;
  ERR_PRINT = 0063;
  ERR_NO_PATH = 0064;
  ERR_NO_FILES = 0065;
  ERR_GET_DOMAINS = 0066;
  ERR_EXT_TOOL_ERROR = 0067;
  ERR_PROPERTIES = 0068;
  ERR_ALIAS_EXISTS = 0069;

  {Global Warnings - (3000-5999}
  WAR_DB_UNAVAILABLE = 3000;
  WAR_NO_PERMISSION = 3001;
  WAR_SERVER_REGISTERED = 3002;
  WAR_DUPLICATE_DB_ALIAS = 3003;
  WAR_BACKUP_FILE_REGISTERED = 3004;
  WAR_DIALECT_MISMATCH = 3005;
  WAR_REMOTE_FILENAME = 3006;

  {Global Messages - (6000-9999}
  INF_ADD_USER_SUCCESS = 6000;
  INF_BACKUP_DB_SUCCESS = 6001;
  INF_RESTORE_DB_SUCCESS = 6002;
  INF_NO_PENDING_TRANSACTIONS = 6003;
  INF_RESTART_SERVER = 6004;
  INF_DATABASE_SHUTDOWN = 6005;
  INF_DATABASE_RESTARTED = 6006;
  INF_SQL_SCRIPT = 6007;
  INF_DATABASE_SWEEP = 6008;

  function DisplayMsg(const MsgNo: integer; MsgText: string): boolean;

implementation

uses zluUtility, ibErrorCodes;

{$R *.DFM}

{****************************************************************
*
*  D i s p l a y M s g ()
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  MsgNo   - Message No
*          MsgText - The actual error message text
*
*  Return: None
*
*  Description:  Prepare and show message dialog depending on
*                the MsgNo and MsgText
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function DisplayMsg(const MsgNo: integer; MsgText: string): boolean;
var
  frmMessage: TfrmMessage;
begin
  frmMessage := TfrmMessage.Create(Application);
  try
    MsgText := RemoveControlChars(MsgText);

    case MsgNo of
      1..2999:
      begin
        frmMessage.Caption := 'Error';
        frmMessage.imgError.Visible := true;
        frmMessage.imgWarning.Visible := false;
        frmMessage.imgInformation.Visible := false;
        frmMessage.memDetailMsg.Text :=  MsgText;        
      end;
      3000..5999:
      begin
        frmMessage.Caption := 'Warning';
        frmMessage.imgError.Visible := false;
        frmMessage.imgWarning.Visible := true;
        frmMessage.imgInformation.Visible := false;
        frmMessage.memDetailMsg.Text :=  MsgText;
      end;
      6000..9999:
      begin
        frmMessage.Caption := 'Information';
        frmMessage.imgError.Visible := false;
        frmMessage.imgWarning.Visible := false;
        frmMessage.imgInformation.Visible := true;
        frmMessage.memDetailMsg.Text :=  MsgText;
      end;
      335544321..336920607:
      begin
        frmMessage.Caption := 'Error';
        frmMessage.imgError.Visible := true;
        frmMessage.imgWarning.Visible := false;
        frmMessage.imgInformation.Visible := false;
        frmMessage.memDetailMsg.Text :=  MsgText;        
      end;
    end;

    case MsgNo of
      //****** Errors ******
      ERR_SYSTEM_INIT:
        frmMessage.stxSummaryMsg.Caption := 'Initialization failure.';
      ERR_USERNAME:
        frmMessage.stxSummaryMsg.Caption := 'Invalid username. Please enter a valid username.';
      ERR_PASSWORD:
        frmMessage.stxSummaryMsg.Caption := 'Invalid password. Please enter a valid password.';
      ERR_PASSWORD_MISSMATCH:
        frmMessage.stxSummaryMsg.Caption := 'The password does not match the confirmation password.';
      ERR_ADD_USER:
        frmMessage.stxSummaryMsg.Caption := 'Unable to add user.';
      ERR_MODIFY_USER:
        frmMessage.stxSummaryMsg.Caption := 'Unable to modify user account.';
      ERR_DELETE_USER:
        frmMessage.stxSummaryMsg.Caption := 'Unable to delete user.';
      ERR_GET_USERS:
        frmMessage.stxSummaryMsg.Caption := 'Unable to retrieve user list.';
      ERR_GET_USER_INFO:
        frmMessage.stxSummaryMsg.Caption := 'Unable to retrieve user information.';
      ERR_SOURCE_DB:
        frmMessage.stxSummaryMsg.Caption := 'Invalid source database name. Please enter a valid database name.';
      ERR_DESTINATION_DB:
        frmMessage.stxSummaryMsg.Caption := 'Invalid destination database name. Please enter a valid database name.';
      ERR_SAME_SOURCE_DESTINATION:
        frmMessage.stxSummaryMsg.Caption := 'The source and destination must be different.';
      ERR_DB_FILE:
        frmMessage.stxSummaryMsg.Caption := 'Invalid database file or the file does not exist.';
      ERR_SERVER_NAME:
        frmMessage.stxSummaryMsg.Caption := 'Invalid server name. Please enter a valid server name.';
      ERR_PROTOCOL:
        frmMessage.stxSummaryMsg.Caption := 'Invalid network protocol. Please select a network protocol from the list.';
      ERR_BACKUP_DB:
        frmMessage.stxSummaryMsg.Caption := 'Database backup failed.';
      ERR_RESTORE_DB:
        frmMessage.stxSummaryMsg.Caption := 'Database restore failed.';
      ERR_GET_TABLES:
        frmMessage.stxSummaryMsg.Caption := 'Unable to retrieve a list of tables.';
      ERR_GET_VIEWS:
        frmMessage.stxSummaryMsg.Caption := 'Unable to retrieve a list of views.';
      ERR_SERVICE:
        frmMessage.stxSummaryMsg.Caption := 'Invalid service. Please select a service from the list.';
      ERR_INVALID_CERTIFICATE:
        frmMessage.stxSummaryMsg.Caption := 'The certificate could not be validated based on the information given. Please recheck the id and key information.';
      ERR_NUMERIC_VALUE:
        frmMessage.stxSummaryMsg.Caption := 'Invalid numeric value. Please enter a valid numeric value.';
      ERR_GET_TABLE_DATA:
        frmMessage.stxSummaryMsg.Caption := 'Unable to retrieve data.';
      ERR_DB_ALIAS:
        frmMessage.stxSummaryMsg.Caption := 'Invalid database alias. Please enter a valid database name.';
      ERR_GET_ROLES:
        frmMessage.stxSummaryMsg.Caption := 'Unable to retrieve a list of roles.';
      ERR_SERVER_LOGIN:
        frmMessage.stxSummaryMsg.Caption := 'Error logging into the requested server.';
      ERR_DB_CONNECT:
        frmMessage.stxSummaryMsg.Caption := 'Error connecting to the requested database.';
      ERR_DB_DISCONNECT:
        frmMessage.stxSummaryMsg.Caption := 'Error disconnecting from database.';
      ERR_GET_PROCEDURES:
        frmMessage.stxSummaryMsg.Caption := 'Unable to retrieve a list of procedures.';
      ERR_GET_FUNCTIONS:
        frmMessage.stxSummaryMsg.Caption := 'Unable to retrieve a list of functions.';
      ERR_GET_GENERATORS:
        frmMessage.stxSummaryMsg.Caption := 'Unable to retrieve a list of generators.';
      ERR_GET_EXCEPTIONS:
        frmMessage.stxSummaryMsg.Caption := 'Unable to retrieve a list of exceptions.';
      ERR_GET_BLOB_FILTERS:
        frmMessage.stxSummaryMsg.Caption := 'Unable to retrieve a list of blob filters.';
      ERR_GET_COLUMNS:
        frmMessage.stxSummaryMsg.Caption := 'Unable to retrieve a list of columns.';
      ERR_GET_INDICES:
        frmMessage.stxSummaryMsg.Caption := 'Unable to retrieve a list of indices.';
      ERR_GET_REFERENTIAL_CONST:
        frmMessage.stxSummaryMsg.Caption := 'Unable to retrieve a list of referential constraints.';
      ERR_GET_UNIQUE_CONST:
        frmMessage.stxSummaryMsg.Caption := 'Unable to retrieve a list of unique constraints.';
      ERR_GET_CHECK_CONST:
        frmMessage.stxSummaryMsg.Caption := 'Unable to retrieve a list of check constraints.';
      ERR_GET_TRIGGERS:
        frmMessage.stxSummaryMsg.Caption := 'Unable to retrieve a list of triggers.';
      ERR_GET_DDL:
        frmMessage.stxSummaryMsg.Caption := 'An error occured while attempting to extract metadata information.';
      ERR_INVALID_PROPERTY_VALUE:
        frmMessage.stxSummaryMsg.Caption := 'Invalid Property Value.';
      ERR_GET_DEPENDENCIES:
        frmMessage.stxSummaryMsg.Caption := 'An error occured while attempting to extract dependency information.';
      ERR_GET_DB_PROPERTIES:
        frmMessage.stxSummaryMsg.Caption := 'An error occured while attempting to retrieve database properties.';
      ERR_DB_SIZE:
        frmMessage.stxSummaryMsg.Caption := 'Invalid database file size.';
      ERR_ISQL_ERROR:
        frmMessage.stxSummaryMsg.Caption := 'SQL Error';
      ERR_SERVER_SERVICE:
        frmMessage.stxSummaryMsg.Caption := 'Service Error';
      ERR_EXTERNAL_EDITOR:
        frmMessage.stxSummaryMsg.Caption := 'External Editor Error';
      ERR_SERVER_ALIAS:
        frmMessage.stxSummaryMsg.Caption := 'Invalid server alias. Please enter a valid server alias.';
      ERR_BACKUP_ALIAS:
        frmMessage.stxSummaryMsg.Caption := 'Invalid backup alias. Please enter a valid backup alias.';
      ERR_DB_SHUTDOWN:
        frmMessage.stxSummaryMsg.Caption := 'Database shutdown unsuccessful.';
      ERR_MODIFY_DB_PROPERTIES:
        frmMessage.stxSummaryMsg.Caption := 'Unable to modify database properties.';
      ERR_DROP_DATABASE:
        frmMessage.stxSummaryMsg.Caption := 'An error occured while attempting to drop the database.';
      ERR_FILE_OPEN:
        frmMessage.stxSummaryMsg.Caption := 'An error occured while attempting to open file.';
      ERR_INV_EDITOR:
        frmMessage.stxSummaryMsg.Caption := 'The editor specified is invalid.';
      ERR_EDITOR_MISSING:
        frmMessage.stxSummaryMsg.Caption := 'The external editor is not specified.';
      ERR_BAD_FORMAT:
        frmMessage.stxSummaryMsg.Caption := 'Unable to display blob.  The format is not graphical.';
      ERR_INV_DIALECT:
        frmMessage.stxSummaryMsg.Caption := 'Unable to change the client dialect.';
      ERR_FOPEN:
        frmMessage.stxSummaryMsg.Caption := 'Error occured opening file.';
      ERR_TEXT_NOT_FOUND:
        frmMessage.stxSummaryMsg.Caption := 'Search string not found.';
      ERR_PRINT:
        frmMessage.stxSummaryMsg.Caption := 'Unable to print.  Make sure your printer is installed and working.';
      ERR_NO_PATH:
        frmMessage.stxSummaryMsg.Caption := 'No path was specified for the backup file or database.';
      ERR_NO_FILES:
        frmMessage.stxSummaryMsg.Caption := 'No files were specified for backup or restore.';
      ERR_GET_DOMAINS:
        frmMessage.stxSummaryMsg.Caption := 'Unable to retrieve a list of domains.';
      ERR_EXT_TOOL_ERROR:
        frmMessage.stxSummaryMsg.Caption := 'Unable to launch external tool';
      ERR_PROPERTIES:
        frmMessage.stxSummaryMsg.Caption := 'Unable to retrieve properties for the object';
      ERR_ALIAS_EXISTS:
        frmMessage.stxSummaryMsg.Caption := 'Invalid alias.  This alias already exists.';

      //****** Warnings ******
      WAR_NO_PERMISSION:
        frmMessage.stxSummaryMsg.Caption := 'Insufficient rights for this operation.';
      WAR_SERVER_REGISTERED:
        frmMessage.stxSummaryMsg.Caption := 'The server is already registered.';
      WAR_DUPLICATE_DB_ALIAS:
        frmMessage.stxSummaryMsg.Caption := 'This database alias already exists.';
      WAR_BACKUP_FILE_REGISTERED:
        frmMessage.stxSummaryMsg.Caption := 'The backup file is already registered.';
      WAR_DIALECT_MISMATCH:
        frmMessage.stxSummaryMsg.Caption := 'The client dialect does not match the database dialect.';
      WAR_REMOTE_FILENAME:
        frmMessage.stxSummaryMsg.Caption := 'The file name specified may contain a server name.'+#13#10+
         'Some operations may not work correctly.';

      {****** Information ******}
      INF_ADD_USER_SUCCESS:
        frmMessage.stxSummaryMsg.Caption := 'The user was added successfully.';
      INF_BACKUP_DB_SUCCESS:
        frmMessage.stxSummaryMsg.Caption := 'Database backup completed.';
      INF_RESTORE_DB_SUCCESS:
        frmMessage.stxSummaryMsg.Caption := 'Database restore completed.';
      INF_NO_PENDING_TRANSACTIONS:
        frmMessage.stxSummaryMsg.Caption := 'No pending transactions were found.';
      INF_RESTART_SERVER:
        frmMessage.stxSummaryMsg.Caption := 'You must restart the server in order for the changes to go into effect.';
      INF_DATABASE_SHUTDOWN:
        frmMessage.stxSummaryMsg.Caption := 'Database shutdown completed successfully.';
      INF_DATABASE_RESTARTED:
        frmMessage.stxSummaryMsg.Caption := 'Database restart completed successfully.';
      INF_SQL_SCRIPT:
        frmMessage.stxSummaryMsg.Caption := 'SQL script done.';
      INF_DATABASE_SWEEP:
        frmMessage.stxSummaryMsg.Caption := 'Database sweep completed.';

      {****** InterBase Errors ******}        
      isc_gbak_db_exists:
         frmMessage.stxSummaryMsg.Caption := 'To overwrite an existing database, set the Overwrite option to TRUE';
      isc_gfix_invalid_sw:
         frmMessage.stxSummaryMsg.Caption := 'An invalid option was specified for the operation.';
      isc_gfix_incmp_sw:
         frmMessage.stxSummaryMsg.Caption := 'The parameters for this operation are conflicting.';
      isc_gfix_retry:
         frmMessage.stxSummaryMsg.Caption := 'An operation was not specified.';
      isc_gfix_retry_db:
         frmMessage.stxSummaryMsg.Caption := 'A database was not specified for the operation';
      isc_gbak_page_size_missing:
         frmMessage.stxSummaryMsg.Caption := 'The page size must be specified.';
      isc_gsec_cant_open_db:
         frmMessage.stxSummaryMsg.Caption := 'The security database could not be opened.';
      isc_gsec_no_usr_name:
         frmMessage.stxSummaryMsg.Caption := 'User name missing.  A user name must be specified for all operations.';
      isc_gsec_err_add:
         frmMessage.stxSummaryMsg.Caption := 'An unknown error was encountered while attempting to add the user record.';
      isc_gsec_err_modify:
        frmMessage.stxSummaryMsg.Caption := 'An unknown error was encountered while attempting to modify the user record.';
      isc_gsec_err_find_mod:
        frmMessage.stxSummaryMsg.Caption := 'An unknown error was encountered while attempting to find/modify the user record.';
      isc_gsec_err_rec_not_found:
        frmMessage.stxSummaryMsg.Caption := 'The information for the user was not found.';      
      isc_gsec_err_delete:
        frmMessage.stxSummaryMsg.Caption := 'An unknown error was encountered while attempting to delete the user record.';
      isc_gsec_err_find_del:
        frmMessage.stxSummaryMsg.Caption := 'An unknown error was encountered while attempting to find/delete the user record.';
      isc_gsec_err_find_disp:
        frmMessage.stxSummaryMsg.Caption := 'An unknown error was encountered while attempting to find/display the user record.';
      isc_sys_request:
        frmMessage.stxSummaryMsg.Caption := 'An unknown error attempting to open a file on the server.';
      else
        if MsgText <> '' then
          frmMessage.stxSummaryMsg.Caption := MsgText
        else
          frmMessage.stxSummaryMsg.Caption := 'An Unknown Error Occured';
    end;

    if (MsgText = '') or
       (frmMessage.stxSummaryMsg.Caption = MsgText) then
    begin
      frmMessage.Height := frmMessage.btnOK.Top + frmMessage.btnOK.Height + 35;
      frmMessage.Update;
      Application.ProcessMessages;
    end
    else
    begin
      frmMessage.Height := frmMessage.memDetailMsg.Top + frmMessage.memDetailMsg.Height + 40;
      frmMessage.Update;
      Application.ProcessMessages;
    end;
    
    if ((frmMessage.ShowModal) = mrAbort) then
      result := true
    else
      result := false;
  finally
    frmMessage.Free;
  end;
end;

procedure TfrmMessage.btnOKClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
