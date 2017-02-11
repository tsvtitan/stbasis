unit Setup;

interface

uses
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   StdCtrls, Buttons, ComCtrls, ExtCtrls;

type
   TfmSetup = class(TForm)
      BitBtn1: TBitBtn;
    Panel1: TPanel;
    pcSetup: TPageControl;
    tsIncoming: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    edtIncomingServer: TEdit;
    edtIncomingPort: TEdit;
    edtEmail: TEdit;
    edtIncomingAccount: TEdit;
    edtIncomingPassword: TEdit;
    tsSmtp: TTabSheet;
    lblAuthenticationType: TLabel;
    lbAccount: TLabel;
    lbPassword: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    cboOutgoingAuthType: TComboBox;
    edtOutgoingAccount: TEdit;
    edtOutgoingPassword: TEdit;
    edtOutgoingServer: TEdit;
    edtOutgoingPort: TEdit;
    Label10: TLabel;
    cboIncomingServerType: TComboBox;
    Label3: TLabel;
      procedure bbtnAuthenticationClick(Sender: TObject);
      procedure FormCreate(Sender: TObject);
      procedure FormHide(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
   private
    { Private declarations }
   public
    { Public declarations }
      procedure UpdateServerLabel;
   end;

var
   fmSetup: TfmSetup;

implementation

{$R *.DFM}

uses Main, smtpauth, inifiles;

procedure TfmSetup.bbtnAuthenticationClick(Sender: TObject);
begin
   frmSMTPAuthentication.ShowModal;
end;

procedure TfmSetup.UpdateServerLabel;
begin
   frmMain.pnlServerName.caption := edtIncomingServer.Text;
end; (*  *)

procedure TfmSetup.FormCreate(Sender: TObject);
begin
  edtIncomingServer.Text := IncomingServerName;
  edtIncomingPort.Text := IntToStr(IncomingServerPort);
  edtIncomingAccount.Text := IncomingServerUser;
  edtIncomingPassword.Text := IncomingServerPassword;
  cboIncomingServerType.ItemIndex := IncomingServerType;

  edtOutgoingServer.Text := OutgoingServerName;
  edtOutgoingPort.Text := IntToStr(OutgoingServerPort);
  edtOutgoingAccount.Text := OutgoingServerUser;
  edtOutgoingPassword.Text := OutgoingServerPassword;
  cboOutgoingAuthType.ItemIndex := OutgoingAuthType;

  edtEmail.Text := UserEmail;

  UpdateServerLabel;
end;

procedure TfmSetup.FormHide(Sender: TObject);
begin
   UpdateServerLabel;
end;

procedure TfmSetup.BitBtn1Click(Sender: TObject);
var
  MailIni: TIniFile;
begin
  MailIni := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Mail.ini');
  with MailIni do begin
    WriteString('Incoming', 'ServerName', edtIncomingServer.Text);
    IncomingServerName := edtIncomingServer.Text;

    WriteString('Incoming', 'ServerPort', edtIncomingPort.Text);
    IncomingServerPort := StrToIntDef(edtIncomingPort.Text, 110);

    WriteString('Incoming', 'ServerUser', edtIncomingAccount.Text);
    IncomingServerUser := edtIncomingAccount.Text;

    WriteString('Incoming', 'ServerPassword', edtIncomingPassword.Text);
    IncomingServerPassword := edtIncomingPassword.Text;

    WriteInteger('Incoming', 'IncomingServerType', cboIncomingServerType.ItemIndex);
    IncomingServerType := cboIncomingServerType.ItemIndex;

    if ( IncomingServerType = stPOP3 ) then
       frmMain.pnlMailBox.Visible := False
    else
        frmMain.pnlMailBox.Visible := True;

    WriteString('Outgoing', 'ServerName', edtOutgoingServer.Text);
    OutgoingServerName := edtOutgoingServer.Text;

    WriteString('Outgoing', 'ServerPort', edtOutgoingPort.Text);
    OutgoingServerPort := StrToIntDef(edtOutgoingPort.Text, 25);

    WriteString('Outgoing', 'ServerUser', edtOutgoingAccount.Text);
    OutgoingServerUser := edtOutgoingAccount.Text;

    WriteString('Outgoing', 'ServerPassword', edtOutgoingPassword.Text);
    OutgoingServerPassword := edtOutgoingPassword.Text;

    WriteString('Email', 'PersonalEmail', edtEmail.Text);
    UserEmail := edtEmail.Text;

    WriteInteger('Outgoing', 'OutgoingAuthenticationType', cboOutgoingAuthType.ItemIndex);
    OutgoingAuthType := cboOutgoingAuthType.ItemIndex;

  end;
  MailIni.Free;
end;

procedure TfmSetup.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

end.

