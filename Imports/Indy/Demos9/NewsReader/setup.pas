unit setup;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, Spin, Dialogs;

type
  TfrmNewsSetup = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    edtServer: TEdit;
    lblServer: TLabel;
    lblPort: TLabel;
    spnedtPort: TSpinEdit;
    grpAuthentication: TGroupBox;
    Bevel1: TBevel;
    edtUserID: TEdit;
    edtPassword: TEdit;
    lblPassword: TLabel;
    Label2: TLabel;
    chkUseSSL: TCheckBox;
    edtCert: TEdit;
    edtKey: TEdit;
    edtRoot: TEdit;
    lblCertificate: TLabel;
    lblKeyFile: TLabel;
    lblRootFile: TLabel;
    bbtnCertFile: TBitBtn;
    bbtnKey: TBitBtn;
    bbtnRoot: TBitBtn;
    odlgCert: TOpenDialog;
    odlgKey: TOpenDialog;
    odlgRoot: TOpenDialog;
    procedure chkUseSSLClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bbtnCertFileClick(Sender: TObject);
    procedure bbtnKeyClick(Sender: TObject);
    procedure bbtnRootClick(Sender: TObject);
  private
    { Private declarations }
    Procedure EnableDisableSSLOptions;
  public
    { Public declarations }
  end;

var
  frmNewsSetup: TfrmNewsSetup;

implementation

{$R *.DFM}

procedure TfrmNewsSetup.chkUseSSLClick(Sender: TObject);
begin
  EnableDisableSSLOptions;
end;

procedure TfrmNewsSetup.EnableDisableSSLOptions;
begin
  lblCertificate.Enabled := chkUseSSL.Checked;
  edtCert.Enabled := chkUseSSL.Checked;
  bbtnCertFile.Enabled := chkUseSSL.Checked;
  lblKeyFile.Enabled := chkUseSSL.Checked;
  edtKey.Enabled := chkUseSSL.Checked;
  bbtnKey.Enabled := chkUseSSL.Checked;
  lblRootFile.Enabled := chkUseSSL.Checked;
  edtRoot.Enabled := chkUseSSL.Checked;
  bbtnRoot.Enabled := chkUseSSL.Checked;
  if chkUseSSL.Checked then
  begin
    spnedtPort.Value := 563;
    edtCert.Color := clWindow;
    edtKey.Color := clWindow;
    edtRoot.Color := clWindow;
  end   // chkUseSSL.Checked
  else
  begin
    spnedtPort.Value := 119;
    edtCert.Color := clBtnFace;
    edtKey.Color := clBtnFace;
    edtRoot.Color := clBtnFace;
  end;  //else .. chkUseSSL.Checked
end;

procedure TfrmNewsSetup.FormCreate(Sender: TObject);
begin
  EnableDisableSSLOptions;
end;

procedure TfrmNewsSetup.bbtnCertFileClick(Sender: TObject);
begin
  odlgCert.FileName := edtCert.Text;
  if odlgCert.Execute then
  begin
    edtCert.Text := odlgCert.FileName;
  end; // if odlgCert.Execute then
end;

procedure TfrmNewsSetup.bbtnKeyClick(Sender: TObject);
begin
  odlgKey.FileName := edtKey.Text;
  if odlgKey.Execute then
  begin
    edtKey.Text := odlgKey.FileName;
  end; // if odlgKey.Execute then
end;

procedure TfrmNewsSetup.bbtnRootClick(Sender: TObject);
begin
  odlgRoot.FileName := edtRoot.Text;
  if odlgRoot.Execute then
  begin
    edtRoot.Text := odlgRoot.FileName;
  end; // if odlgRoot.Execute then
end;

end.
