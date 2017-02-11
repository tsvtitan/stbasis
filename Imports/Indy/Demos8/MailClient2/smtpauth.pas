unit smtpauth;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TfrmSMTPAuthentication = class(TForm)
    btbOK: TBitBtn;
    grbSettings: TGroupBox;
    chbAuthType: TComboBox;
    lblAuthenticationType: TLabel;
    edtAccount: TEdit;
    edtPassword: TEdit;
    lbAccount: TLabel;
    lbPassword: TLabel;
    procedure chbAuthTypeChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Procedure EnableControls;
  end;

var
  frmSMTPAuthentication: TfrmSMTPAuthentication;

implementation

{$R *.DFM}

{ TfrmSMTPAuthentication }

procedure TfrmSMTPAuthentication.EnableControls;
begin
  edtAccount.Enabled := (chbAuthType.ItemIndex <> 0);
  lbAccount.Enabled := (chbAuthType.ItemIndex <> 0);
  edtPassword.Enabled := (chbAuthType.ItemIndex <> 0);
  lbPassword.Enabled := (chbAuthType.ItemIndex <> 0);
end;

procedure TfrmSMTPAuthentication.chbAuthTypeChange(Sender: TObject);
begin
  EnableControls;
end;

end.
