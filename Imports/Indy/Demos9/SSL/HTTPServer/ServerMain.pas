unit ServerMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ActnList, StdCtrls, IdComponent, IdTCPServer, IdHTTPServer, Buttons,
  ComCtrls, IdGlobal, IdBaseComponent, IdThreadMgr, IdThreadMgrDefault, syncobjs,
  IdThreadMgrPool,
  IdSSLOpenSSL, ExtCtrls, IdIntercept, IdSSLIntercept;

type
  TfmHTTPServerMain = class(TForm)
    HTTPServer: TIdHTTPServer;
    alGeneral: TActionList;
    acActivate: TAction;
    edPort: TEdit;
    cbActive: TCheckBox;
    StatusBar1: TStatusBar;
    edRoot: TEdit;
    LabelRoot: TLabel;
    cbAuthentication: TCheckBox;
    cbManageSessions: TCheckBox;
    cbEnableLog: TCheckBox;
    IdThreadMgrDefault1: TIdThreadMgrDefault;
    cbLocalIPList: TComboBox;
    cbSSL: TCheckBox;
    Panel1: TPanel;
    sslLog: TListBox;
    Splitter1: TSplitter;
    lbLog: TListBox;
    IdServerInterceptOpenSSL1: TIdServerInterceptOpenSSL;
    procedure acActivateExecute(Sender: TObject);
    procedure edPortChange(Sender: TObject);
    procedure edPortKeyPress(Sender: TObject; var Key: Char);
    procedure edPortExit(Sender: TObject);
    procedure HTTPServerCommandGet(AThread: TIdPeerThread;
      RequestInfo: TIdHTTPRequestInfo; ResponseInfo: TIdHTTPResponseInfo);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure HTTPServerSessionEnd(Sender: TIdHTTPSession);
    procedure HTTPServerSessionStart(Sender: TIdHTTPSession);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure HTTPServerConnect(AThread: TIdPeerThread);
    procedure IdServerInterceptOpenSSL1GetPassword(var Password: String);
  private
    procedure ServeVirtualFolder(AThread: TIdPeerThread;
      RequestInfo: TIdHTTPRequestInfo; ResponseInfo: TIdHTTPResponseInfo);
    procedure DisplayMessage(const Msg: String);
    procedure ManageUSerSession(AThread: TIdPeerThread;
      RequestInfo: TIdHTTPRequestInfo; ResponseInfo: TIdHTTPResponseInfo);
    function GetMIMEType(sFile: TFileName): String;
    { Private declarations }
  public
    { Public declarations }
    EnableLog: boolean;
    MIMEMap: TIdMIMETable;
    procedure MyInfoCallback(Msg: String);
  end;

var
  fmHTTPServerMain: TfmHTTPServerMain;
  SSLOpenSSL: TIdServerInterceptOpenSSL;


implementation

uses FileCtrl, IdStack;

{$R *.DFM}

procedure TfmHTTPServerMain.MyInfoCallback(Msg: String);
begin
//  ShowMessage(Msg);
  sslLog.ItemIndex := sslLog.Items.Add(Msg);
end;


procedure TfmHTTPServerMain.acActivateExecute(Sender: TObject);
var
  AppDir: String;
begin
  acActivate.Checked := not acActivate.Checked;

  if not HTTPServer.Active then
  begin
    HTTPServer.Bindings.Clear;
    HTTPServer.DefaultPort := StrToIntDef(edPort.text, 80);
    HTTPServer.Bindings.Add;
    HTTPServer.Bindings[0].IP := cbLocalIPList.Text;
  end;

  if not DirectoryExists(edRoot.text) then
  begin
    DisplayMessage(Format('Web root folder (%s) not found.',[edRoot.text]));
    acActivate.Checked := False;
  end
  else
  begin
    if acActivate.Checked then begin
{
      if cbSSL.Checked then begin
        SSLOpenSSL := TIdServerInterceptOpenSSL.Create(nil);
        with SSLOpenSSL.SSLOptions do begin
          Method := sslvSSLv2;
          RootCertFile := AppDir + 'cert\CAcert.pem';
          CertFile     := AppDir + 'cert\WSScert.pem';
          KeyFile      := AppDir + 'cert\WSSkey.pem';
        end;
        SSLOpenSSL.Init;
        SSLOpenSSL.OnInfoCallback := MyInfoCallback;
        HTTPServer.Intercept := SSLOpenSSL;
      end;
}

      try
        EnableLog := cbEnableLog.Checked;
        HTTPServer.SessionState := cbManageSessions.Checked;
        HTTPServer.Active := true;
        DisplayMessage(format('Listening for HTTP connections on %s:%d.',[HTTPServer.Bindings[0].IP, HTTPServer.Bindings[0].Port]));
      except
        on e: exception do
        begin
          acActivate.Checked := False;
          DisplayMessage(format('Exception %s in Activate. Error is:"%s".', [e.ClassName, e.Message]));
        end;
      end;
    end
    else
    begin
      HTTPServer.Active := false;
{
      if cbSSL.Checked then begin
        SSLOpenSSL.Destroy;
      end;
      HTTPServer.Intercept := nil;
}      
      DisplayMessage('Stop listening.');
    end;
  end;
  edPort.Enabled := not acActivate.Checked;
  edRoot.Enabled := not acActivate.Checked;
  cbLocalIPList.enabled := not acActivate.Checked;
  cbAuthentication.Enabled := not acActivate.Checked;
  cbEnableLog.Enabled := not acActivate.Checked;
  cbManageSessions.Enabled := not acActivate.Checked;
end;

procedure TfmHTTPServerMain.edPortChange(Sender: TObject);
var
  FinalLength, i: Integer;
  FinalText: String;
begin
  // Filter routine. Remove every char that is not a numeric (must do that for cut'n paste)
  Setlength(FinalText, length(edPort.Text));
  FinalLength := 0;
  for i := 1 to length(edPort.Text) do
  begin
    if edPort.text[i] in [ '0'..'9' ] then
    begin
      inc(FinalLength);
      FinalText[FinalLength] := edPort.text[i];
    end;
  end;
  SetLength(FinalText, FinalLength);
  edPort.text := FinalText;
end;

procedure TfmHTTPServerMain.edPortKeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in [ '0'..'9', #8 ]) then
    Key := #0;
end;

procedure TfmHTTPServerMain.edPortExit(Sender: TObject);
begin
  if length(trim(edPort.text)) = 0 then
    edPort.text := '80';
end;


procedure TfmHTTPServerMain.ManageUSerSession(AThread: TIdPeerThread;
  RequestInfo: TIdHTTPRequestInfo; ResponseInfo: TIdHTTPResponseInfo);
var
  NumberOfView: Integer;
begin
  // Manage session informations
  if assigned(RequestInfo.Session) or (HTTPServer.CreateSession(ResponseInfo, RequestInfo) <> nil) then
  begin
    RequestInfo.Session.Lock;
    try
      NumberOfView := StrToIntDef(RequestInfo.Session.Content.Values['NumViews'], 0);
      inc(NumberOfView);
      RequestInfo.Session.Content.Values['NumViews'] := IntToStr(NumberOfView);
      RequestInfo.Session.Content.Values['UserName'] := RequestInfo.AuthUsername;
      RequestInfo.Session.Content.Values['Password'] := RequestInfo.AuthPassword;
    finally
      RequestInfo.Session.Unlock;
    end;
  end;
end;

procedure TfmHTTPServerMain.ServeVirtualFolder(AThread: TIdPeerThread;
  RequestInfo: TIdHTTPRequestInfo; ResponseInfo: TIdHTTPResponseInfo);
begin
  ResponseInfo.ContentType := 'text/HTML';
  ResponseInfo.ContentText := '<html><head><title>Virtual folder</title></head><body>';

  if AnsiSameText(RequestInfo.Params.Values['action'], 'close') then
  begin
    // Closing user session
    RequestInfo.Session.Free;
    ResponseInfo.ContentText :=  ResponseInfo.ContentText + '<h1>Session cleared</h1><p><a href="/sessions">Back</a></p>';
  end
  else
  begin
    if assigned(RequestInfo.Session) then
    begin
      if Length(RequestInfo.Params.Values['ParamName'])>0 then
      begin
        // Add a new parameter to the session
        ResponseInfo.Session.Content.Values[RequestInfo.Params.Values['ParamName']] := RequestInfo.Params.Values['Param'];
      end;
      ResponseInfo.ContentText := ResponseInfo.ContentText + '<h1>Session informations</h1>';
      RequestInfo.Session.Lock;
      try
        ResponseInfo.ContentText := ResponseInfo.ContentText + '<table border=1>';
        ResponseInfo.ContentText := ResponseInfo.ContentText + '<tr><td>SessionID</td><td>' + RequestInfo.Session.SessionID + '</td></tr>';
        ResponseInfo.ContentText := ResponseInfo.ContentText + '<tr><td>Number of page requested during this session</td><td>'+RequestInfo.Session.Content.Values['NumViews']+'</td></tr>';
        ResponseInfo.ContentText := ResponseInfo.ContentText + '<tr><td>Session data (raw)</td><td><pre>' + RequestInfo.Session.Content.Text + '</pre></td></tr>';
        ResponseInfo.ContentText := ResponseInfo.ContentText + '</table>';
        ResponseInfo.ContentText := ResponseInfo.ContentText + '<h1>Tools:</h1>';
        ResponseInfo.ContentText := ResponseInfo.ContentText + '<h2>Add new parameter</h2>';
        ResponseInfo.ContentText := ResponseInfo.ContentText + '<form>';
        ResponseInfo.ContentText := ResponseInfo.ContentText + '<p>Name: <input type="text" Name="ParamName"></p>';
        ResponseInfo.ContentText := ResponseInfo.ContentText + '<p>value: <input type="text" Name="Param"></p>';
        ResponseInfo.ContentText := ResponseInfo.ContentText + '<p><input type="Submit"><input type="reset"></p>';
        ResponseInfo.ContentText := ResponseInfo.ContentText + '</form>';
        ResponseInfo.ContentText := ResponseInfo.ContentText + '<h2>Other:</h2>';
        ResponseInfo.ContentText := ResponseInfo.ContentText + '<p><a href="' + RequestInfo.Document + '?action=close">Close current session</a></p>';
      finally
        RequestInfo.Session.Unlock;
      end;
    end
    else
    begin
      ResponseInfo.ContentText := ResponseInfo.ContentText + '<p color=#FF000>No session</p>';
    end;
  end;
  ResponseInfo.ContentText := ResponseInfo.ContentText + '</body></html>';
end;

procedure TfmHTTPServerMain.DisplayMessage(const Msg: String);
begin
  if EnableLog then
    lbLog.ItemIndex := lbLog.Items.Add(Msg);
end;

procedure TfmHTTPServerMain.HTTPServerCommandGet(AThread: TIdPeerThread;
  RequestInfo: TIdHTTPRequestInfo; ResponseInfo: TIdHTTPResponseInfo);
var
  LocalDoc: string;
  ByteSent: Cardinal;
  ResultFile: TFileStream;
begin
  // Log the request
  DisplayMessage(Format( 'Command %s %s received from %s:%d',
                         [RequestInfo.Command, RequestInfo.Document, AThread.Connection.Binding.PeerIP,AThread.Connection.Binding.PeerPort]));
  if cbAuthentication.Checked and (Not RequestInfo.AuthExists) then
  begin
    ResponseInfo.AuthRealm := 'Any Username Or Password Will Do';
  end
  else
  begin
    if cbManageSessions.checked then
    begin
      ManageUserSession(AThread, RequestInfo, ResponseInfo);
    end;

    if (Pos('/session', LowerCase(RequestInfo.Document)) = 1) then
    begin
      ServeVirtualFolder(AThread, RequestInfo, ResponseInfo);
    end
    else
    begin
       // Interprete the command to it's final path (avoid sending files in parent folders)
       LocalDoc := ExpandFilename(edRoot.text + RequestInfo.Document);
       // Default document (index.html) for folder
       if not FileExists(LocalDoc) and DirectoryExists(LocalDoc) and FileExists(ExpandFileName(LocalDoc + '/index.html')) then
       begin
         LocalDoc := ExpandFileName(LocalDoc + '/index.html');
       end;

       if FileExists(LocalDoc) then // File exists
       begin
         if AnsiSameText(Copy(LocalDoc, 1, Length(edRoot.text)), edRoot.Text) then // File down in dir structure
         begin
           if AnsiSameText(RequestInfo.Command, 'HEAD') then
           begin
             // HEAD request, don't send the document but still send back it's size
             ResultFile := TFileStream.create(LocalDoc, fmOpenRead	or fmShareDenyWrite);
             try
               ResponseInfo.ResponseNo := 200;
               ResponseInfo.ContentType := GetMIMEType(LocalDoc);
               ResponseInfo.ContentLength := ResultFile.Size;
             finally
               ResultFile.Free; // We must free this file since it won't be done by the web server component
             end;
           end
           else
           begin
             // Normal document request
             // Send the document back
             ByteSent := HTTPServer.ServeFile(AThread, ResponseInfo, LocalDoc);
             DisplayMessage(Format( 'Serving file %s (%d bytes / %d bytes sent) to %s:%d',
                                    [LocalDoc,
                                     ByteSent,
                                     FileSizeByName(LocalDoc),
                                     AThread.Connection.Binding.PeerIP,
                                     AThread.Connection.Binding.PeerPort]));
           end;
         end
         else
         begin
           ResponseInfo.ResponseNo := 403; // Unnauthorized
           ResponseInfo.ContentText := '<html><head><title>Error</title></head><body><h1>' + ResponseInfo.ResponseText + '</h1></body></html>';
         end;
       end
       else
       begin
         ResponseInfo.ResponseNo := 404; // Not found
         ResponseInfo.ContentText := '<html><head><title>Error</title></head><body><h1>' + ResponseInfo.ResponseText + '</h1></body></html>';
       end;
    end;
  end;
end;

procedure TfmHTTPServerMain.FormCreate(Sender: TObject);
begin
  MIMEMap := TIdMIMETable.Create(true);
  edRoot.text := ExtractFilePath(Application.exename) + 'Web';
end;

procedure TfmHTTPServerMain.FormDestroy(Sender: TObject);
begin
  MIMEMap.Free;
end;

function TfmHTTPServerMain.GetMIMEType(sFile: TFileName): String;
begin
  result := MIMEMap.GetFileMIMEType(sFile);
end;

procedure TfmHTTPServerMain.HTTPServerSessionEnd(Sender: TIdHTTPSession);
begin
  DisplayMessage(Format('Ending session %s at %s',[Sender.SessionID, FormatDateTime(LongTimeFormat, now)]));
  DisplayMessage(Format('Session duration was: %s',
                        [FloatToStr(StrToDateTime(sender.Content.Values['StartTime'])-now)]));
end;

procedure TfmHTTPServerMain.HTTPServerSessionStart(Sender: TIdHTTPSession);
begin
  sender.Content.Values['StartTime'] := DateTimeToStr(Now);
  DisplayMessage(Format('Starting session %s at %s',[Sender.SessionID, FormatDateTime(LongTimeFormat, now)]));
end;

procedure TfmHTTPServerMain.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  // desactivate the server
  if cbActive.Checked then
    acActivate.execute;
end;

procedure TfmHTTPServerMain.FormShow(Sender: TObject);
begin
  cbLocalIPList.Items.AddStrings(GStack.LocalAddresses);
  cbLocalIPList.ItemIndex := 0;
end;

procedure TfmHTTPServerMain.HTTPServerConnect(AThread: TIdPeerThread);
var
  s: String;
begin
{
  if AThread.Connection.InterceptEnabled then begin
    if (AThread.Connection.Intercept As TIdConnectionInterceptOpenSSL).SSLSocket.PeerCert <> nil then begin
      s := (AThread.Connection.Intercept As TIdConnectionInterceptOpenSSL).SSLSocket.PeerCert.Subject.OneLine;
      ShowMessage(s);
    end;
  end;
}  
end;

procedure TfmHTTPServerMain.IdServerInterceptOpenSSL1GetPassword(
  var Password: String);
begin
  Password := 'aaaa';
end;

end.
