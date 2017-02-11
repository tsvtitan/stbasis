unit mainform;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IdComponent, IdTCPServer, IdDayTimeServer, IdBaseComponent;

type
  TForm1 = class(TForm)
    IdDayTimeServer1: TIdDayTimeServer;
  private
  public
  end;

var
  Form1: TForm1;

implementation
{$R *.DFM}

// No Code required - DayTimeServer is functional as is.

end.
