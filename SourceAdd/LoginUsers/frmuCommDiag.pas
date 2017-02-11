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
*  f r m u C o m m D i a g
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Description:  This unit provides all the necessary functions
*                and interface to perform network communication
*                diagnostics.
*
*****************************************************************
* Revisions:
*
*****************************************************************}

unit frmuCommDiag;

interface

uses
  Windows, SysUtils,Forms, ExtCtrls, StdCtrls, Classes, Controls, ComCtrls, Dialogs,
  Graphics, zluibcClasses, zluCommDiag, Winsock, IB, ScktComp, Registry,
  IBDatabase, IBDatabaseInfo, Messages, frmuDlgClass;

type
  TfrmCommDiag = class(TDialog)
    btnSelDB: TButton;
    cbDBServer: TComboBox;
    cbNetBEUIServer: TComboBox;
    cbProtocol: TComboBox;
    cbSPXServer: TComboBox;
    cbService: TComboBox;
    cbTCPIPServer: TComboBox;
    edtDatabase: TEdit;
    edtPassword: TEdit;
    edtUsername: TEdit;
    gbDBServerInfo: TGroupBox;
    gbDatabaseInfo: TGroupBox;
    gbNetBEUIServerInfo: TGroupBox;
    gbNovellServerInfo: TGroupBox;
    gbTCPIPServerInfo: TGroupBox;
    lblDBResults: TLabel;
    lblDatabase: TLabel;
    lblNetBEUIServer: TLabel;
    lblNetBeuiResults: TLabel;
    lblPassword: TLabel;
    lblProtocol: TLabel;
    lblSPXResults: TLabel;
    lblSPXServer: TLabel;
    lblServerName: TLabel;
    lblService: TLabel;
    lblUsername: TLabel;
    lblWinSockResults: TLabel;
    lblWinsockServer: TLabel;
    memDBResults: TMemo;
    memNetBeuiResults: TMemo;
    memSPXResults: TMemo;
    memTCPIPResults: TMemo;
    pgcDiagnostics: TPageControl;
    rbLocalServer: TRadioButton;
    rbRemoteServer: TRadioButton;
    tabDBConnection: TTabSheet;
    tabNetBEUI: TTabSheet;
    tabSPX: TTabSheet;
    tabTCPIP: TTabSheet;
    pnlButtonBar: TPanel;
    btnTest: TButton;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSelDBClick(Sender: TObject);
    procedure btnTestClick(Sender: TObject);
    procedure cbDBServerClick(Sender: TObject);
    procedure rbLocalServerClick(Sender: TObject);
    procedure rbRemoteServerClick(Sender: TObject);
    procedure edtDatabaseChange(Sender: TObject);
  private
    { Private declarations }
    FProtocols: TStringList;
    FRegistry: TRegistry;
    FServers: TStringList;
    function VerifyInputData(): boolean;
    procedure PingServer;
    procedure TestDBConnect;
    procedure TestNetBEUI;
    procedure TestPort(Port : String);
    procedure TestSPX;
    procedure WMNCLButtonDown( var Message: TWMNCLBUTTONDOWN ); message WM_NCLBUTTONDOWN ;
  public
    { Public declarations }
  end;

  function DoDiagnostics(const CurrSelServer: TibcServerNode) : Integer;
  function ServiceRunning(const CurrSelServer : TibcServerNode) : Boolean;

const
  Port21     = 0;                      // constants to identify TCP/IP service tests
  PortFTP    = 1;
  Port3050   = 2;
  Portgds_db = 3;
  Ping       = 4;

var
  frmCommDiag : TfrmCommDiag;

implementation

uses
   zluGlobal, zluContextHelp, IBServices, frmuMessage;

{$R *.DFM}

{****************************************************************
*
*  D o D i a g n o t i c s
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  TibcServerNode - Specifies the currenly selected server
*
*  Return: Integer - Determines success or failure.
*
*  Description:  Responsible for creating the form.
*
*****************************************************************
* Revisions:
*
*****************************************************************}

function DoDiagnostics(const CurrSelServer: TibcServerNode): integer;
var
  frmCommDiag: TfrmCommDiag;
begin
  frmCommDiag:= TfrmCommDiag.Create(Application);
  try
    // determine if a server is currently selected
    if Assigned(CurrSelServer) then
    begin
      // if a local server is selected then check the local radio button
      if CurrSelServer.Server.Protocol = Local then
      begin
        frmCommDiag.rbLocalServer.Checked := true;
      end
      else
      begin
        // otherwise select the specified protocol of the remote server from the protocol combo box
        // and check the remote radio button
        frmCommDiag.cbDBServer.Text := CurrSelServer.Servername;
        case CurrSelServer.Server.Protocol of
          TCP: frmCommDiag.cbProtocol.ItemIndex := frmCommDiag.cbProtocol.Items.IndexOf('TCP/IP');
          NamedPipe: frmCommDiag.cbProtocol.ItemIndex := frmCommDiag.cbProtocol.Items.IndexOf('NetBEUI');
          SPX: frmCommDiag.cbProtocol.ItemIndex := frmCommDiag.cbProtocol.Items.IndexOf('SPX');
        end;
        frmCommDiag.rbRemoteServer.Checked := true;
      end;
    end
    else                               // if no server selected then assume Local Server
      frmCommDiag.rbLocalServer.Checked := true;
    frmCommDiag.ShowModal;             // show form as modal
    if frmCommDiag.ModalResult = mrOK then
    begin
      result := SUCCESS;
    end
    else
      result := FAILURE;
  finally
    // deallocate memory
    frmCommDiag.Free;
  end;
end;

{****************************************************************
*
*  D o D i a g n o t i c s
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  TibcServerNode - Specifies the currenly selected server
*
*  Return: Integer - Determines success or failure.
*
*  Description:  Responsible for creating the form.
*
*****************************************************************
* Revisions:
*
*****************************************************************}

function ServiceRunning(const CurrSelServer: TibcServerNode) : Boolean;
var
  lPipe   : TibcPipes;
  lSPX    : TibcSPX;
  lSocket : TibcSocket;
  lStr    : String;
begin
  lPipe   := Nil;
  lSPX    := Nil;
  lSocket := Nil;
  Result  := True;
  try
    case CurrSelServer.Server.Protocol of
      TCP :
      begin
        lSocket := TibcSocket.Create(Nil);
        lSocket.Host := CurrSelServer.Servername;
        lSocket.Port := 3050;         // gds_db
        lSocket.Timeout := 5000;      // set timeout for 5 secs.
        try
          lSocket.Connect;
        except
          Result := False;
        end;
      end;
      NamedPipe :
      begin
        lPipe := TibcPipes.Create;
        lPipe.Server := CurrSelServer.Servername;
        lPipe.Path := '\pipe\interbas\server\gds_db';
        lPipe.Tries := 5;
        lStr := '';

        // test pipe
        Result := lPipe.TestPipe(lStr, True);
      end;
      SPX :
      begin

      end;
    end;
  finally
    lPipe.Free;
    lSPX.Free;
    lSocket.Free
  end;
end;

// if user presses the Cancel button then set the result to mrCancel
procedure TfrmCommDiag.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

{****************************************************************
*
*  b t n S e l D B C l i c k
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  Tobject
*
*  Return: None
*
*  Description:  Shows an open file dialog box that allows
*                a user to browse for a local database file.
*
*****************************************************************
* Revisions:
*
*****************************************************************}

procedure TfrmCommDiag.btnSelDBClick(Sender: TObject);
var
  lOpenDialog: TOpenDialog;
begin
  lOpenDialog := nil;
  try
  begin
    // create and show open file dialog box
    lOpenDialog := TOpenDialog.Create(self);
    // specify defaul extension and filters
    lOpenDialog.DefaultExt := 'gdb';
    lOpenDialog.Filter := 'Database File (*.gdb)|*.GDB|All files (*.*)|*.*';
    // if OK is pressed then extract selected filename
    if lOpenDialog.Execute then
    begin
      edtDatabase.Text := lOpenDialog.Filename;
    end;
  end
  finally
    // deallocate memory
    lOpenDialog.free;
  end;
end;

// if the local radio button is selected then enable and/or disable
// the appropriate controls
procedure TfrmCommDiag.rbLocalServerClick(Sender: TObject);
begin
  if rbLocalServer.Checked then
  begin
    cbDBServer.Text := '';
    cbDBServer.Enabled := false;
    cbProtocol.ItemIndex := -1;
    cbProtocol.Enabled := false;
    cbDBServer.Color := clSilver;
    cbProtocol.Color := clSilver;
    btnSelDB.Enabled := true;
    edtDatabase.Text := '';
    edtUsername.Text := '';
    edtPassword.Text := '';
  end
  else
  begin
    cbDBServer.Enabled := true;
    cbProtocol.Enabled := true;
    cbDBServer.Color := clWindow;
    cbProtocol.Color := clWindow;
    btnSelDB.Enabled := false;
    edtDatabase.Text := '';
    edtUsername.Text := '';
    edtPassword.Text := '';
  end
end;

// if the remote radio button is selected then enable and/or disable
// the appropriate controls
procedure TfrmCommDiag.rbRemoteServerClick(Sender: TObject);
begin
  if rbRemoteServer.Checked then
  begin
    cbDBServer.Enabled := true;
    cbProtocol.Enabled := true;
    cbDBServer.Color := clWindow;
    cbProtocol.Color := clWindow;
    btnSelDB.Enabled := false;
    edtDatabase.Text := '';
    edtUsername.Text := '';
    edtPassword.Text := '';
  end
  else
  begin
    cbDBServer.Enabled := false;
    cbProtocol.Enabled := false;
    cbDBServer.Color := clSilver;
    cbProtocol.Color := clSilver;
    btnSelDB.Enabled := false;
    edtDatabase.Text := '';
    edtUsername.Text := '';
    edtPassword.Text := '';
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
*  Return: Boolean - Indicates whether all the necessary
*                    data has been entered in order to
*                    perform the specified task
*
*  Description:  Verifies whther all the necessary data has been
*                enetered in order to performt he specified
*                task.  If not an error message will be displayed
*                and the control responsible for the violation
*                will be given focus.
*
*****************************************************************
* Revisions:
*
*****************************************************************}

function TfrmCommDiag.VerifyInputData(): boolean;
begin
  result := true;

  // if the db connection tab is currently active
  if pgcDiagnostics.ActivePage = tabDBConnection then
  begin
    // if the remote radio button is checked
    if rbRemoteServer.Checked then
    begin
      // then make sure a server has been supplied
      if (cbDBServer.Text = '') or (cbDBServer.Text = ' ') then
      begin
        DisplayMsg(ERR_SERVER_NAME,'');
        cbDBServer.SetFocus;
        result := false;
        Exit;
      end;
      // also make sure a network protocol has been selected
      if (cbProtocol.Text = '') or (cbProtocol.Text = ' ') then
      begin
        DisplayMsg(ERR_PROTOCOL,'');
        cbProtocol.SetFocus;
        result := false;
        Exit;
      end;
    end;

    // ensure that a database has been specified
    if (edtDatabase.Text = '') or (edtDatabase.Text = ' ') then
    begin
      DisplayMsg(ERR_DB_ALIAS,'');
      edtDatabase.SetFocus;
      result := false;
      Exit;
    end;

    // ensure that a username has been specified
    if (edtUsername.Text = '') or (edtUsername.Text = ' ') then
    begin
      DisplayMsg(ERR_USERNAME,'');
      edtUsername.SetFocus;
      result := false;
      Exit;
    end;

    // ensure that a password has been specified
    if (edtPassword.Text = '') or (edtPassword.Text = ' ') then
    begin
      DisplayMsg(ERR_PASSWORD,'');
      edtPassword.SetFocus;
      result := false;
      Exit;
    end;
  end

  // otherwise, if the NetBEUI tab is active
  else if pgcDiagnostics.ActivePage = tabNetBEUI then
  begin
    // ensure that a server is specified
    if (cbNetBEUIServer.Text = '') or (cbNetBEUIServer.Text = ' ') then
    begin
      DisplayMsg(ERR_SERVER_NAME,'');
      cbNetBEUIServer.SetFocus;
      result := false;
      Exit;
    end;
  end

  // otherwise if the SPX tab is active
  else if pgcDiagnostics.ActivePage = tabSPX then
  begin
    // ensure that a server is specified
    if (cbSPXServer.Text = '') or (cbSPXServer.Text = ' ') then
    begin
      DisplayMsg(ERR_SERVER_NAME,'');
      cbSPXServer.SetFocus;
      result := false;
      Exit;
    end;
  end

  // otherwise if the TCP/IP tab is active
  else if pgcDiagnostics.ActivePage = tabTCPIP then
  begin
    // ensure that a server is specified
    if (cbTCPIPServer.Text = '') or (cbTCPIPServer.Text = ' ') then
    begin
      DisplayMsg(ERR_SERVER_NAME,'');
      cbTCPIPServer.SetFocus;
      result := false;
      Exit;
    end;

    // also ensure that a service has been selected
    if (cbService.Text = '') or (cbService.Text = ' ') then
    begin
      DisplayMsg(ERR_SERVICE,'');
      cbService.SetFocus;
      result := false;
      Exit;
    end;
  end;
end;

{****************************************************************
*
*  b t n T e s t C l i c k
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  TObject
*
*  Return: None
*
*  Description:  Determines which tab is active and performs
*                the appropriate network disgnostic.
*
*****************************************************************
* Revisions:
*
*****************************************************************}

procedure TfrmCommDiag.btnTestClick(Sender: TObject);
begin
  // if all the necessary data has been supplied then proceed
  if VerifyInputData() then
  begin
    // if DB connection is the active page
    if pgcDiagnostics.ActivePage = tabDBConnection then
    begin
      memDBResults.Lines.Clear;        // then clear the database results
      TestDBConnect;                   // perform the database test
    end;

    // if TCP/IP is the active page
    if pgcDiagnostics.ActivePage = tabTCPIP then
    begin
      memTCPIPResults.Lines.Clear;     // then clear the TCP/IP results
      case cbService.ItemIndex of     // determine which service is selected
        Port21     : TestPort('21');   // and perform the TCP/IP test
        PortFTP    : TestPort('ftp');
        Port3050   : TestPort('3050');
        Portgds_db : TestPort('gds_db');
        Ping       : PingServer;
      end;
    end;

    // if NetBEUI is the active page
    if pgcDiagnostics.ActivePage = tabNetBEUI then
    begin
      memNetBEUIResults.Lines.Clear;   // then clear the NetBEUI results
      TestNetBEUI;                     // perform the NetBEUI test
    end;

    // if SPX is the active page
    if pgcDiagnostics.ActivePage = tabSPX then
    begin
      memSPXResults.Lines.Clear;       // then clear the SPX results
      TestSPX;
    end;

  end;
end;

{****************************************************************
*
*  P i n g S e r v e r
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  None
*
*  Return: None
*
*  Description:  Creates a Ping object and performs a
*                TCP/IP ping returning round trip times and
*                packet loss statistics.
*
*****************************************************************
* Revisions:
*
*****************************************************************}

procedure TfrmCommDiag.PingServer;
var
  Ping        : TibcPing;              // Ping
  iMaxRTT     : Integer;               // store maximum round trip time
  iMinRTT     : Integer;               // store minimum round trip time
  iAvgRTT     : Integer;               // stores average round trip time
  fPacketLoss : Real;                  // stores packet loss statistics
  iPackets    : Integer;               // stores number of packets
  iSuccesses  : Integer;               // stores number of successes
  i           : Integer;               // counter
begin
  Ping := Nil;                         // initialize variables
  iMaxRTT:=0;
//  iMinRTT:=0;
  iAvgRTT:=0;
//  fPacketLoss:=0;
  iSuccesses:=0;
  iPackets:=4;

  Screen.Cursor := crHourGlass;
  try
    Ping := TibcPing.Create;           // create ping object

    with Ping do
    begin
      Host:=cbTCPIPServer.Text;       // set hostname
      Size:=32;                        // set packet size
      TTL:=64;                         // set time to live
      TimeOut:=4000;                   // set timeout
      iMinRTT:=TimeOut div 1000;       // set the minimum RTT to timeout
    end;

    // try to resolve host and get an IP address
    if Ping.ResolveHost then
    begin
      // if the specified host is already an IP address
      if Ping.HostName = ping.HostIP then
      begin
        memTCPIPResults.Lines.Add('Pinging ' + Ping.HostIP + ' with ' +
          IntToStr(Ping.Size) + ' bytes of data:');
      end
      else
      begin
        // if name is resolved then show hostname and IP address
        memTCPIPResults.Lines.Add('Pinging ' + Ping.HostName + ' [' +
          Ping.HostIP + '] ' + ' with ' + IntToStr(Ping.Size) + ' bytes of data:');
      end;
      memTCPIPResults.Lines.Add('');

      // ping server iPacket times
      for i:=0 to iPackets-1 do
      begin
        // ping server
        Ping.Ping;
        with memTCPIPResults.Lines do
        begin
          // if no errors
          if Ping.LastError = 0 then
          begin
            // increment the number of successes
            Inc(iSuccesses);
            // add the round trip time to the average acc
            iAvgRTT:=iAvgRTT + Ping.RTTReply;
            // if RTT larger then maxRTT then store it
            if Ping.RTTReply > iMaxRTT then
              iMaxRTT:=Ping.RTTReply;
            // if RTT less then minRTT then store it
            if Ping.RTTReply < iMinRTT then
              iMinRTT:=Ping.RTTReply;
            // if no error then show reply
            if Ping.LastError = 0 then
            begin
              Add('Reply from ' + Ping.HostIP + ': ' + 'bytes=' +
                IntToStr(Ping.Size) + ' time=' + IntToStr(Ping.RTTReply) +
                'ms ' + 'TTL=' + IntToStr(Ping.TTLReply));
            end;
          end
          else                         // if an error occured
          begin
            Add(Ping.VerboseResult);   // then show verbose error message
          end;
        end;
      end;

      if iSuccesses < 1 then           // if there were no successful pings
        iMinRTT:=0;                    // then set minimum RTT to 0

      // calculate the percentage of lost packets
      fPacketLoss:=((iPackets - iSuccesses) / iPackets) * 100;
      // calculate the average round trip times
      iAvgRTT:=iAvgRTT div iPackets;

      // show ping statistics
      with memTCPIPResults.Lines do
      begin
        Add('');
        Add('Ping statistics for ' + Ping.HostIP + ':');
        Add('    Packets: Send = ' + IntToStr(iPackets) + ', Received = ' +
          IntToStr(iSuccesses) + ', Lost = ' + IntToStr(iPackets-iSuccesses) +
          ' (' + FloatToStr(fPacketLoss) + '%),');
        Add('Approximate round trip times in milli-seconds:');
        Add('    Minimum = ' + IntToStr(iMinRTT) + 'ms, Maximum = ' +
          IntToStr(iMaxRTT) + 'ms, ' + 'Average = ' + IntToStr(iAvgRTT) + 'ms');
      end;
    end
    else                               // if host can't be resolved shot error message
      memTCPIPResults.Lines.add('Unknown host ' + cbTCPIPServer.Text + '.');
  finally
    // deallocate memory
    Ping.Free;
    Screen.Cursor := crDefault;
  end;
end;

{****************************************************************
*
*  T e s t D B C o n n e c t
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  None
*
*  Return: None
*
*  Description:  Creates a Database object and performs a
*                database connect test using a specified protocol.
*
*****************************************************************
* Revisions:
*
*****************************************************************}

procedure TfrmCommDiag.TestDBConnect;
var
  lDatabase : TIBDatabase;
  lProto    : TProtocol;
  iSuccess  : Boolean;
  lDBInfo   : TIBDatabaseInfo;
begin
  lDatabase := Nil;                    // initialize variables
  lDBInfo   := Nil;
  iSuccess  := True;;
  lProto    := Local;

  Screen.Cursor := crHourGlass;

  // if the local radio button is checked then set protocol to local
  if rbLocalServer.Checked or ((cbProtocol.ItemIndex < 0) and
     (rbLocalServer.Checked = False)) then
    lProto:=Local
  else
  begin
    // otherwise determine the specified protocol
    case cbProtocol.ItemIndex of
      0 : lProto:=TCP;
      1 : lProto:=NamedPipe;
      2 : lProto:=SPX;
    end;
  end;

  try
    // create the database object
    lDatabase := TIBDatabase.Create(Self);
    lDBInfo   := TIBDatabaseInfo.Create(Self);
    try
      // setup database path according to the specified protocol
      case lProto of
        TCP       : lDatabase.DatabaseName := Format('%s:%s',[UpperCase(cbDBServer.Text), edtDatabase.Text]);
        NamedPipe : lDatabase.DatabaseName := Format('\\%s\%s',[UpperCase(cbDBServer.Text), edtDatabase.Text]);
        SPX       : lDatabase.DatabaseName := Format('%s@%s',[UpperCase(cbDBServer.Text), edtDatabase.Text]);
        Local     : lDatabase.DatabaseName := edtDatabase.Text;
      end;

      // supply parameters to the database
      lDatabase.LoginPrompt:=False;
      lDatabase.Params.Clear;
      lDatabase.Params.Add(Format('isc_dpb_user_name=%s',[edtUsername.Text]));
      lDatabase.Params.Add(Format('isc_dpb_password=%s',[edtPassword.Text]));
      // connect to database
      lDatabase.Connected:=True;

      // show database name
      lDBInfo.Database := lDatabase;
      memDBResults.Lines.Add('Attempting to connect to:');
      memDBResults.Lines.Add(lDatabase.DatabaseName);
      memDBResults.Lines.Add(Format('Version : %s', [lDBInfo.Version]));
      memDBResults.Lines.Add('');

      // test attach - if connected then attach was successful
      if lDatabase.TestConnected then
        memDBResults.Lines.Add('Attaching    ... Passed!');

      try
        // test detach - detach from database
        lDatabase.Connected:=False;
        // if not connected then detach was successful
        if not lDatabase.Connected then
          memDBResults.Lines.Add('Detaching    ... Passed!');
      except
        on E : EIBError do
        begin
          // if an error occurs while detaching then show message
          memDBResults.Lines.Add('An InterBase error has occurred while detaching.');
          memDBResults.Lines.Add('Error - ' + E.Message);
          memDBResults.Lines.Add('');
          iSuccess:=False;             // set success flag to false
        end;
      end;
    except
      on E : EIBError do
      begin
        // if an error occurs while attaching then show message
        memDBResults.Lines.Add('An InterBase error has occurred while attaching.');
        memDBResults.Lines.Add('Error - ' + E.Message);
        iSuccess:=False;               // set success flag to false
      end;
    end;
  finally
    with memDBResults.Lines do
    begin
      if iSuccess then                 // show appropriate message
      begin                            // depending on Success flag
        Add('');
        Add('InterBase Communication Test Passed!');
      end
      else
        Add('InterBase Communication Test Failed!');
    end;
    // deallocate memory
    lDatabase.Free;
    lDBInfo.Free;
    Screen.Cursor := crDefault;
  end;
end;

{****************************************************************
*
*  T e s t P o r t
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  String - name or number of port service
*
*  Return: None
*
*  Description:  Creates a socket object and performs a
*                port/service test using TCP/IP.
*
*****************************************************************
* Revisions:
*
*****************************************************************}

procedure TfrmCommDiag.TestPort(Port : String);
var
  Sock     : TibcSocket;               // socket
  iPort    : Integer;                  // port number
  iResolve : Boolean;                  // port name resolution successful
  lService : String;                   // service name
  iSuccess : Boolean;                  // test successful
begin
  Sock := Nil;                         // initialize variables
//  iResolve := False;
  iSuccess := True;
  iPort := 3050;
  Screen.Cursor := crHourGlass;

  try
    iPort:=StrToInt(Port);             // convert specified port to a number
    iResolve:=True;                    // set resolution flag to true
  except
    on E : EConvertError do            // if a conversion error occurs then
    begin                              // est conversion flag to false
      iResolve:=False;
    end;
  end;

  try
    Sock:=TibcSocket.Create(Self);     // create socket
    Sock.Host := cbTCPIPServer.Text;  // set hostname
    Sock.ReportLevel := 1;             // set report level
    Sock.Timeout := 5000;              // set timeout

    with memTCPIPResults.Lines do
    begin
      Add('Attempting connection to ' + cbTCPIPServer.Text + '.');
      Add('Socket for connection obtained.');
      Add('');

      // if port was resolved to a number then
      if iResolve then
      begin
        Sock.Port:=iPort;              // set the port number
        lService:=Sock.PortName;       // get the port name

        if lService <> '' then
          Add('Found service ''' + lService + ''' at port ''' + Port + '''')
        else
          Add('Could not resolve service ''' + lService +
              ''' at port ''' + Port + '''');
      end
      // otherwise manually resolve port name to a number
      // and set the port number
      else
      begin
        if Port = 'ftp' then
          Sock.Port:=21
        else if Port = 'gds_db' then
          Sock.Port:=3050;
      end;

      try
        // connect to server via the specified service/port
        Sock.Connect;
      except
        on E : ESocketError do
        begin
          // if a socket error occurs then set success flag to false
          Add('Socket Error Trapped!');
          iSuccess:=False;
        end
        else
        begin
          // otherwise some other error occured
          Add('Failed to connect to host ''' + cbTCPIPServer.Text + ''',');
          Add('on port ' + Port + '. Error Num: ' +
              IntToStr(Sock.LastErrorNo) + '.');
          iSuccess:=False;
        end;
      end;

      // if the connectin is successful
      if Sock.Connected then
      begin
        Add('Connection established to host ''' + cbTCPIPServer.Text + ''',');
        Add('on port ' + Port + '.');
        Sock.Disconnect;
      end;
    end;
  finally
    with memTCPIPResults.Lines do
    begin
      Add('');
      if iSuccess then
        Add('TCP/IP Communication Test Passed!')
      else
        Add('TCP/IP Communication Test Failed!');
    end;
    // deallocate memory
    Sock.Free;
    Screen.Cursor := crDefault;
  end;
end;

// when the user presses the enter key then execute test task
procedure TfrmCommDiag.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(key)=13 then
  begin
    btnTestClick(sender);
    key:=char(0);
  end;
end;

{****************************************************************
*
*  F o r m C r e a t e
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  Tobject
*
*  Return: None
*
*  Description: Loads registered remote servers into the
*               combo boxes (also stores their protocols).
*
*****************************************************************
* Revisions:
*
*****************************************************************}

procedure TfrmCommDiag.FormCreate(Sender: TObject);
var
  lCount : Integer ;
  iProtocol : Integer;
  lServerAlias : TStringList;
  lStr : String;
  lRegServersKey : String;
begin
  inherited;
  FRegistry := Nil;                    // initialize variables
  FServers := Nil;
  FProtocols := Nil;
  lServerAlias :=Nil;
  pgcDiagnostics.ActivePageIndex := 0;
  try
    FRegistry := TRegistry.Create;
    FServers := TStringList.Create;
    FProtocols := TStringList.Create;
    lServerAlias := TStringList.Create;

    FRegistry.OpenKey('Software', False);
    FRegistry.OpenKey('Borland', False);
    FRegistry.OpenKey('Interbase', False);
    FRegistry.OpenKey('IBConsole', False);
    FRegistry.CreateKey('Servers');
    lRegServersKey := Format('\%s\Servers\',[FRegistry.CurrentPath]);

    // if server entries are found
    if FRegistry.OpenKey(lRegServersKey,False) then
    begin
      // get all server aliases
      FRegistry.GetKeyNames(lServerAlias);
      // loop through list of aliases to get server names
      for lCount := 0 to lServerAlias.Count - 1 do
      begin
        if FRegistry.OpenKey(Format('%s%s',[lRegServersKey,lServerAlias.Strings[lCount]]),False) then
        begin
          // get server names and protocols
          lStr := FRegistry.ReadString('ServerName');
          iProtocol := FRegistry.ReadInteger('Protocol');

          // Only add remote servers (and their protocol) to stringlists
          if lStr <> 'Local Server' then
          begin
            FServers.Add(lStr);
            FProtocols.Add(IntToStr(iProtocol));
          end;
        end;
      end;
    end;

    // add remote servers to all server combo boxes
    for lCount := 0 to FServers.Count - 1 do
    begin
        cbDBServer.Items.Add(FServers.Strings[lCount]);
        cbTCPIPServer.Items.Add(FServers.Strings[lCount]);
        cbNetBEUIServer.Items.Add(FServers.Strings[lCount]);
        cbSPXServer.Items.Add(FServers.Strings[lCount]);
    end;
  finally
    FRegistry.CloseKey;
    lServerAlias.Free;
  end;
end;

// deallocate registry and stringlists when form is closed
procedure TfrmCommDiag.FormDestroy(Sender: TObject);
begin
  FRegistry.Free;
  FServers.Free;
  FProtocols.Free;
end;

{****************************************************************
*
*  T e s t N e t B E U I
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  None
*
*  Return: None
*
*  Description:  Creates a pipes object and performs a
*                NetBEUI test using named pipes.
*
*****************************************************************
* Revisions:
*
*****************************************************************}

procedure TfrmCommDiag.TestNetBEUI;
var
  lPipe : TibcPipes;                   // named pipe
  lStr : String;
begin
  lPipe := Nil;                        // initialize variables
  lStr:='';
  Screen.Cursor := crHourGlass;
  try
    lPipe := TibcPipes.Create;         // create pipe

    // specify server name
    lPipe.Server := cbNetBEUIServer.Text;
    // specify pipe name
    lPipe.Path := '\pipe\interbas\server\gds_db';
    // specify number of attempts
    lPipe.Tries := 5;

    // test pipe
    lPipe.TestPipe(lStr, False);

    // assign results to NetBEUI results memo
    memNetBEUIResults.SetTextBuf(PChar(lStr));
  finally
    // deallocate memery
    lPipe.Free;
    Screen.Cursor := crDefault;
  end;
end;

{****************************************************************
*
*  T e s t S P X
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  None
*
*  Return: None
*
*  Description:  Creates a SPX object and performs a
*                test server connect using SPX.
*
*****************************************************************
* Revisions:
*
*****************************************************************}

procedure TfrmCommDiag.TestSPX;
var
  lspx : TibcSPX;
  lStr : String;
begin
  lspx := Nil;                         // initialize variables
  lStr:='';

  Screen.Cursor := crHourGlass;

  try
    lspx := TibcSPX.Create;

    // specify servername
    lspx.ServerName:=cbSPXServer.Text;
    // test SPX connection
    lspx.TestSPX(lStr);

    // assign results to SPX results memo
    memSPXResults.SetTextBuf(PChar(lStr));
  finally
    // deallocate memory
    lspx.Free;
    Screen.Cursor := crDefault;
  end;
end;

// assigns appropriate protocol for a selected server in the DB connection tab
procedure TfrmCommDiag.cbDBServerClick(Sender: TObject);
begin
  cbProtocol.ItemIndex :=
    StrToInt(FProtocols[FServers.IndexOf(cbDBServer.Text)]);
end;

procedure TfrmCommDiag.edtDatabaseChange(Sender: TObject);
begin
  edtDatabase.Hint := edtDatabase.Text;
end;

procedure TfrmCommDiag.WMNCLButtonDown( var Message: TWMNCLButtonDown );
var
  ScreenPt: TPoint;
  ClientPt: TPoint;
begin
  ScreenPt.X := Message.XCursor;
  ScreenPt.Y := Message.YCursor;
  ClientPt := ScreenToClient( ScreenPt );
  if( ClientPt.X > Width-45 )and (ClientPt.X < Width-29) then
   begin
    WinHelp(WindowHandle,CONTEXT_HELP_FILE,HELP_CONTEXT,FEATURES_DIAGNOSTICS);
    Message.Result := 0;
  end else
   inherited;
end;

end.
