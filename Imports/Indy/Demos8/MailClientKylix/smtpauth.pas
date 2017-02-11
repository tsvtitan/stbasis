unit smtpauth;

interface

uses
   {$IFDEF Linux}
     QForms,   QDialogs,   QStdCtrls,   QButtons,   QComCtrls,
   {$ELSE}
   Windows, Messages, Graphics, Controls, Forms, Dialogs,   stdctrls, Buttons, ComCtrls,
   {$ENDIF}
   SysUtils, Classes,   QControls;

type
  TfrmSMTPAuthentication = class(TForm)
    BitBtn1: TBitBtn;
    GroupBox1: TGroupBox;
    cboAuthType: TComboBox;
    lblAuthenticationType: TLabel;
    edtAccount: TEdit;
    edtPassword: TEdit;
    lbAccount: TLabel;
    lbPassword: TLabel;
    procedure cboAuthTypeChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Procedure EnableControls;
  end;

var
  frmSMTPAuthentication: TfrmSMTPAuthentication;

implementation

{$IFDEF Linux}{$R *.xfm}{$ELSE}{$R *.DFM}{$ENDIF}

{ TfrmSMTPAuthentication }

procedure TfrmSMTPAuthentication.EnableControls;
begin
  edtAccount.Enabled := (cboAuthType.ItemIndex <> 0);
  lbAccount.Enabled := (cboAuthType.ItemIndex <> 0);
  edtPassword.Enabled := (cboAuthType.ItemIndex <> 0);
  lbPassword.Enabled := (cboAuthType.ItemIndex <> 0);
end;

procedure TfrmSMTPAuthentication.cboAuthTypeChange(Sender: TObject);
begin
  EnableControls;
end;

end.
