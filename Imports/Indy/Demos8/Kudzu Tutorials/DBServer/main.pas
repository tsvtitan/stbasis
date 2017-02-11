unit main;

interface

uses
  {$IFDEF Linux}
  QGraphics, QControls, QForms, Libc,
  {$ELSE}
  Graphics, Controls, Forms, Windows,
  {$ENDIF}
  Classes,
  IdBaseComponent, IdComponent, IdTCPServer,
  SysUtils;

type
  TformMain = class(TForm)
    IdTCPServer1: TIdTCPServer;
    procedure IdTCPServer1Execute(AThread: TIdPeerThread);
  private
  public
  end;

var
  formMain: TformMain;

implementation
{$R *.dfm}

procedure TformMain.IdTCPServer1Execute(AThread: TIdPeerThread);
var
  i: integer;
begin
  with AThread.Connection do begin
    WriteLn('Hello. DB Server ready.');
    i := StrToIntDef(ReadLn, 0);
    // Sleep is substituted for a long DB or other call
    Sleep(5000);
    WriteLn(IntToStr(i * 7));
    Disconnect;
  end;
end;

end.
