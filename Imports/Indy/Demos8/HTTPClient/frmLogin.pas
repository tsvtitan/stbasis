unit frmLogin;

interface

uses
  {$IFDEF Linux}
  QGraphics, QControls, QForms, QDialogs, QComCtrls, QButtons, QStdCtrls, QExtCtrls,
  {$ELSE}
  Windows, Messages, Graphics, Controls, Forms, Dialogs, stdctrls, ExtCtrls, Buttons, ComCtrls,
  {$ENDIF}
  SysUtils, Classes;

type
  TLoginForm = class(TForm)
    edtUserName: TEdit;
    edtPassword: TEdit;
    edtDomain: TEdit;
    btnOK: TButton;
    lblRealm: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    lblDomain: TLabel;
    btnCancel: TButton;
    Label4: TLabel;
    lblSite: TLabel;
    Label5: TLabel;
    Image1: TImage;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LoginForm: TLoginForm;

implementation

{$IFDEF Linux}{$R *.xfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TLoginForm.FormShow(Sender: TObject);
begin
  edtUserName.SetFocus;
  lblDomain.Enabled := Length(edtDomain.Text) > 0;
  edtDomain.Enabled := Length(edtDomain.Text) > 0;
end;

end.
