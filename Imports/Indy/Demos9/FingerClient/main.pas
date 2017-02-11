unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdFinger;

type
  TfrmFingerDemo = class(TForm)
    IdFngFinger: TIdFinger;
    edtQuerry: TEdit;
    lblQuerry: TLabel;
    mmoQuerryResults: TMemo;
    lblInstructions: TLabel;
    chkVerboseQuerry: TCheckBox;
    bbtnQuerry: TBitBtn;
    procedure bbtnQuerryClick(Sender: TObject);
  private
  public
  end;

var
  frmFingerDemo: TfrmFingerDemo;

implementation
{$R *.DFM}

procedure TfrmFingerDemo.bbtnQuerryClick(Sender: TObject);
begin
  {Set the Querry string for the Finger from the text entered}
  IdFngFinger.CompleteQuery := edtQuerry.Text;
  {Do we want verbose querry - not supported on many systems}
  IdFngFinger.VerboseOutput := chkVerboseQuerry.Checked;
  {Do our querry with the Finger function}
  mmoQuerryResults.Lines.Text := IdFngFinger.Finger;
end;

end.
