unit ClientMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, ExtCtrls;

type
  TForm2 = class(TForm)
    TCPClient: TIdTCPClient;
    ListBox1: TListBox;
    Panel1: TPanel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
  public
  end;

var
  Form2: TForm2;

implementation
{$R *.DFM}

procedure TForm2.Button1Click(Sender: TObject);
begin
  with TCPClient do
  begin
    Connect;
    try
      ListBox1.Items.Add(ReadLn);
    finally
      Disconnect;
    end;
  end;
end;

end.
