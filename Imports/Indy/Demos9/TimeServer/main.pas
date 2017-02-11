unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IdComponent, IdTCPServer, IdTimeServer, IdBaseComponent;

type
  TForm1 = class(TForm)
    IdTimeServer1: TIdTimeServer;
  private
  public
  end;

var
  Form1: TForm1;

implementation
{$R *.DFM}

// No Code required - TimeServer is functional as is.

end.
