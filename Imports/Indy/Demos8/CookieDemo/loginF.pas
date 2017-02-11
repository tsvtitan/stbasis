unit loginF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmLogin = class(TForm)
    edtLogin: TEdit;
    edtPassword: TEdit;
    btnCancel: TButton;
    btnOK: TButton;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.DFM}

procedure TfrmLogin.FormShow(Sender: TObject);
begin
  edtLogin.SetFocus;
end;

end.
