unit Main;

// A list of time servers is available at:
// http://www.eecis.udel.edu/~mills/ntp/servers.html

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IdComponent, IdTCPConnection, IdTCPClient, IdTime, StdCtrls,
  IdBaseComponent;

type
  TfrmTimeDemo = class(TForm)
    lblTimeServer: TLabel;
    IdDemoTime: TIdTime;
    edtTimeResult: TEdit;
    Label1: TLabel;
    btnGetTime: TButton;
    cmboTimeServer: TComboBox;
    procedure btnGetTimeClick(Sender: TObject);
  private
  public
  end;

var
  frmTimeDemo: TfrmTimeDemo;

implementation
{$R *.DFM}

procedure TfrmTimeDemo.btnGetTimeClick(Sender: TObject);
begin
  IdDemoTime.Host := cmboTimeServer.Text;
  { After setting Host, this is all you have to get the time from a time
  server.  We do the rest. }
  edtTimeResult.Text := DateTimeToStr ( IdDemoTime.DateTime );
end;

end.
