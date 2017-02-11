{***************************************************************
 *
 * Project  : MailClientWindows
 * Unit Name: fMain
 * Purpose  :
 * Version  : 1.0
 * Date     : Mon 02 Jul 2001  -  15:17:37
 * Author   : Allen O'Neill <allen_oneill@hotmail.com>
 * History  :
 * Tested   : Mon 02 Jul 2001  // Allen O'Neill <allen_oneill@hotmail.com>
 *
 ****************************************************************}

unit fMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, Menus, ImgList, Buttons, IdSMTP,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdMessageClient, IdPOP3, IdMessage, IniFiles, IdAntiFreezeBase,
  IdAntiFreeze;

type
  TfrmMain = class(TForm)
    Panel1: TPanel;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Setup1: TMenuItem;
    Sendmessages1: TMenuItem;
    Checkmessages1: TMenuItem;
    lvMessages: TListView;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    mmoBody: TMemo;
    sbMain: TStatusBar;
    edtSubject: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    cboPriority: TComboBox;
    Label3: TLabel;
    Label4: TLabel;
    cboReturnReceipt: TComboBox;
    imgListMain: TImageList;
    lvAttachments: TListView;
    Panel2: TPanel;
    Label5: TLabel;
    Panel3: TPanel;
    Label6: TLabel;
    lstTO: TListBox;
    lstCC: TListBox;
    btnSetup: TBitBtn;
    btnNewMessage: TBitBtn;
    btnRetrieveMail: TBitBtn;
    IdPOP3: TIdPOP3;
    IdSMTP: TIdSMTP;
    IdMessage: TIdMessage;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Label7: TLabel;
    lblAttachments: TLabel;
    IdAntiFreeze: TIdAntiFreeze;
    procedure Exit1Click(Sender: TObject);
    procedure btnSetupClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnRetrieveMailClick(Sender: TObject);
  private
    { Private declarations }
  public

  fSMTPServer,
  fSMTPUsername,
  fSMTPPassword,
  fPOP3Server,
  fPOP3Username,
  fPOP3Password : String;
  fSMTPPort,
  fPOP3Port : Integer;
  fSMTPAuthRequired : Boolean;

  Procedure SaveIni;
  Procedure LoadIni;

  Procedure CheckMail;
  Procedure DisableControls;
  Procedure EnableControls;

  Procedure MSG(AString:String);

  end;

var
  frmMain: TfrmMain;

implementation

uses fSetup;

{$R *.DFM}

procedure TfrmMain.Exit1Click(Sender: TObject);
begin
if MessageDlg('Are you sure you wish to exit?', mtConfirmation, [mbYes, mbNo], 0)
  = mrYes then
    application.terminate;
end;


procedure TfrmMain.LoadIni;
var
  ini : TIniFile;
begin
ini:= TIniFile.create(ExtractFilePath(ParamStr(0)) + 'MailClientWindows.ini');
with ini do
  begin
  fSMTPServer       := ReadString('SMTP','Server','smtp.yourdomain.com');
  fSMTPUsername     := ReadString('SMTP','UserName','AUserName');
  fSMTPPassword     := ReadString('SMTP','Password','APassword');
  fSMTPPort         := ReadInteger('SMTP','Port',25);
  fSMTPAuthRequired := ReadBool('SMTP','AuthRequired',False);
  fPOP3Server       := ReadString('POP3','Server','POP3.yourdomain.com');
  fPOP3Username     := ReadString('POP3','Username','POP3.yourdomain.com');
  fPOP3Password     := ReadString('POP3','Password','POP3.yourdomain.com');
  fPOP3Port         := ReadInteger('POP3','Port',110);
  end;
FreeAndNil(ini);
end;


procedure TfrmMain.SaveIni;
var
  ini : TIniFile;
begin
ini:= TIniFile.create(ExtractFilePath(ParamStr(0)) + 'MailClientWindows.ini');
with ini do
  begin
  WriteString('SMTP','Server',fSMTPServer);
  WriteString('SMTP','UserName',fSMTPUsername);
  WriteString('SMTP','Password',fSMTPPassword);
  WriteInteger('SMTP','Port',fSMTPPort);
  WriteBool('SMTP','AuthRequired',fSMTPAuthRequired);
  WriteString('POP3','Server',fPOP3Server);
  WriteString('POP3','Username',fPOP3Username);
  WriteString('POP3','Password',fPOP3Password);
  WriteInteger('POP3','Port',fPOP3Port);
  end;
FreeAndNil(ini);
end;

procedure TfrmMain.btnSetupClick(Sender: TObject);
var
  frm : TfrmSetup;
begin

frm := TfrmSetup.Create(frmMain);
with frm do
  begin
  edtSMTPServer.text := fSMTPServer;
  edtSMTPPort.text := IntToStr(fSMTPPort);
  chkSMTPAuth.checked := fSMTPAuthRequired;
  edtSMTPUsername.text := fSMTPUsername;
  edtSMTPPassword.text := fSMTPPassword;
  edtPOP3Server.text := fPOP3Server;
  edtPOP3Port.text := IntToStr(fPOP3Port);
  edtPOP3Username.text := fPOP3Username;
  edtPOP3Password.text := fPOP3Password;

  ShowModal;

  if modalResult = mrOk then
    begin
    fSMTPServer := edtSMTPServer.text;
    fSMTPPort := StrToInt(edtSMTPPort.text);
    fSMTPAuthRequired := chkSMTPAuth.checked;
    fSMTPUsername := edtSMTPUsername.text;
    fSMTPPassword := edtSMTPPassword.text;
    fPOP3Server := edtPOP3Server.text;
    fPOP3Port := StrToInt(edtPOP3Port.text);
    fPOP3Username := edtPOP3Username.text;
    fPOP3Password := edtPOP3Password.text;
    SaveIni;
    end;

  end;
  
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
LoadIni;
end;

procedure TfrmMain.btnRetrieveMailClick(Sender: TObject);
begin

if (fPOP3Server <> '') and (fPOP3Port > -1) and (fPOP3Username <> '') and (fPOP3Password <> '') then
  CheckMail
else
  MessageDlg('Cannot check mail until all POP3 fields are filled in in setup !', mtWarning, [mbOK], 0);

end;

procedure TfrmMain.CheckMail;
begin
try
DisableControls;

with IdPOP3 do
  begin
  if connected then disconnect;
  Host := fPOP3Server;
  Port := fPOP3Port;
  Username := fPOP3Username;
  Password := fPOP3Password;
  try
  MSG('Connecting to remote server ' + Host + #32 + 'please wait...');
  Connect(60); // setting timeout for 60 seconds
  if CheckMessages > 0 then // the number of messages on the server (same result as POP command STAT)
    begin
    
    end
  else
    begin

    end;


  except
  on E : Exception do
  MessageDlg('Error connecting to POP3 server:'+#13+#10+E.Message, mtWarning, [mbOK], 0);
  end;


  end;

finally
EnableControls;
end;
end;


procedure TfrmMain.DisableControls;
begin
btnSetup.enabled := false;
btnNewMessage.enabled := false;
btnRetrieveMail.enabled := false;
end;

procedure TfrmMain.EnableControls;
begin
btnSetup.enabled := True;
btnNewMessage.enabled := True;
btnRetrieveMail.enabled := True;
end;

procedure TfrmMain.MSG(AString: String);
begin
sbMain.SimpleText := AString;
application.processmessages;
end;

end.
