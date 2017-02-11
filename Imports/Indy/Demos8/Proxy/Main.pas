unit Main;

interface

uses
  {$IFDEF Linux}
  QControls, QStdCtrls, QGraphics, QForms, QDialogs,
  {$ELSE}
  Windows, Messages, Graphics, Controls, Forms, Dialogs, StdCtrls,
  {$ENDIF}
  SysUtils, Classes, IdBaseComponent, IdComponent, IdTCPServer, IdMappedPortTCP;


type
  TForm1 = class(TForm)
    Memo1: TMemo;
    IdMappedPortTCP1 : TIdMappedPortTCP;
  private
  public
  end;

var
  Form1: TForm1;

implementation
{$IFDEF Linux}{$R *.xfm}{$ELSE}{$R *.DFM}{$ENDIF}

end.
