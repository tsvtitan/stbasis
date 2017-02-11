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

unit frmuDBConnections;

interface

uses
  Forms, ExtCtrls, StdCtrls, Classes, Controls, zluibcClasses, ComCtrls,
  IBDatabase, SysUtils, IBDatabaseInfo, Windows, zluContextHelp,
  IBServices, IB, frmuMessage, Messages, frmuDlgClass;

type
  TfrmDBConnections = class(TDialog)
    lvConnections: TListView;
    btnOK: TButton;
    function FormHelp(Command: Word; Data: Integer; var CallHelp: Boolean): Boolean;
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
    procedure WMNCLButtonDown( var Message: TWMNCLBUTTONDOWN ); message WM_NCLBUTTONDOWN ;
  public
    { Public declarations }
  end;

function ViewDBConnections(const CurrSelServer: TibcServerNode; const CurrDatabase: TIBDatabase): boolean;

implementation

uses
  zluGlobal, zluUtility;

{$R *.DFM}

{****************************************************************
*
*  V i e w D B C o n n e c t i o n s
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   April 28, 1999
*
*  Input: TIBDatabase -  Database for which a list of connections
*                        is requested
*
*  Return: FAILURE on database login failure, SUCCESS otherwise
*
*  Description:  Displays the DB Connections form and fills in the
*                list of connected users.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function ViewDBConnections(const CurrSelServer: TibcServerNode; const CurrDatabase: TIBDatabase): boolean;
var
  frmDBConnections: TfrmDBConnections;
  lIBDBInfo: TIBDatabaseInfo;
  lUserName: TListItem;
  i: integer;
  lDatabase : TIBDatabase;
begin
  lDatabase := nil;
  lIBDBInfo := nil;
  frmDBConnections := nil;
  try
    Screen.Cursor := crHourGlass;
    frmDBConnections := TfrmDBConnections.Create(Application);
    lDatabase := TIBDatabase.Create(Application);
    lIBDBInfo := TIBDatabaseInfo.Create(Application);
    try
      case CurrSelServer.Server.Protocol of
        TCP: lDatabase.DatabaseName := Format('%s:%s',[CurrSelServer.ServerName,CurrDatabase.DatabaseName]);
        NamedPipe: lDatabase.DatabaseName := Format('\\%s\%s',[CurrSelServer.ServerName,CurrDatabase.DatabaseName]);
        SPX: lDatabase.DatabaseName := Format('%s@%s',[CurrSelServer.ServerName,CurrDatabase.DatabaseName]);
        Local:  lDatabase.DatabaseName := CurrDatabase.DatabaseName;
      end;

      lDatabase.LoginPrompt := false;
      lDatabase.Params.Clear;
      lDatabase.Params.Add(Format('isc_dpb_user_name=%s',[CurrSelServer.UserName]));
      lDatabase.Params.Add(Format('isc_dpb_password=%s',[CurrSelServer.Password]));
      lDatabase.Connected := true;
      Application.ProcessMessages;
      result := true;
    except
      on E:EIBError do
      begin
        DisplayMsg(ERR_DB_CONNECT,E.Message);
        result := false;
        exit;
      end;
    end;

    lIBDBInfo.Database := lDatabase;

    for i := 1 to lIBDBInfo.UserNames.Count - 1 do
    begin
      lUserName := frmDBConnections.lvConnections.Items.Add;
      lUserName.Caption := lIBDBInfo.UserNames[i];
    end;

    frmDBConnections.ShowModal;
    result := true;

  finally
    if lDatabase.Connected then
      lDatabase.Connected := false;
    Application.ProcessMessages;
    lDatabase.Free;
    lIBDBInfo.Free;
    frmDBConnections.Free;
    Screen.Cursor := crDefault;
  end;
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
function TfrmDBConnections.FormHelp(Command: Word; Data: Integer;
  var CallHelp: Boolean): Boolean;
begin
  CallHelp := False;
  Result := WinHelp(WindowHandle,CONTEXT_HELP_FILE,HELP_CONTEXT,DATABASE_ACTIVITY);
end;

{****************************************************************
*
*  b t n O K C l i c k
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   April 28, 1999
*
*  Input: ignored
*
*  Description:  Closes the form with a modal result of mrOK.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmDBConnections.btnOKClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TfrmDBConnections.WMNCLButtonDown( var Message: TWMNCLButtonDown );
var
  ScreenPt: TPoint;
  ClientPt: TPoint;
begin
  ScreenPt.X := Message.XCursor;
  ScreenPt.Y := Message.YCursor;
  ClientPt := ScreenToClient( ScreenPt );
  if( ClientPt.X > Width-45 )and (ClientPt.X < Width-29) then
   begin
    WinHelp(WindowHandle,CONTEXT_HELP_FILE,HELP_CONTEXT,DATABASE_ACTIVITY);
    Message.Result := 0;
  end else
   inherited;
end;

end.
