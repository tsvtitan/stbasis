unit mainform;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IdBaseComponent, IdComponent, IdTCPServer, IdEchoServer;

type
  TForm1 = class(TForm)
    IdECHOServer1: TIdECHOServer;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{No coding is required.  Echo server is ready to go by setting Active to True}

end.
