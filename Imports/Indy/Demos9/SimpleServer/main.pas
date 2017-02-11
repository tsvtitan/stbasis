unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, HgComponent, HgTCPConnection, HgSimpleServer, IdBaseComponent,
  IdComponent, IdTCPConnection, IdSimpleServer;

type
  TForm3 = class(TForm)
    SServ: TIdSimpleServer;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.DFM}

procedure TForm3.Button1Click(Sender: TObject);
begin
  with SServ do begin
    if Listen then begin
      WriteLn('Hello');
      Disconnect;
    end;
  end;
end;

end.
