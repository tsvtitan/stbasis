unit fSetup;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmSetup = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    edtSMTPServer: TEdit;
    edtSMTPPort: TEdit;
    Label2: TLabel;
    chkSMTPAuth: TCheckBox;
    Label3: TLabel;
    edtSMTPUsername: TEdit;
    Label4: TLabel;
    edtSMTPPassword: TEdit;
    GroupBox2: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    edtPOP3Server: TEdit;
    edtPOP3Port: TEdit;
    edtPOP3Username: TEdit;
    edtPOP3Password: TEdit;
    btnSave: TButton;
    bntnCancel: TButton;
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  frmSetup: TfrmSetup;

implementation

{$R *.DFM}

{ TfrmSetup }

end.
