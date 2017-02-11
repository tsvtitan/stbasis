{***************************************************************
 *
 * Project  : SimpleServer
 * Unit Name: main
 * Purpose  : Demonstrates basic use of SimpleServer
 * Date     : 21/01/2001  -  14:52:50
 * History  :
 *
 ****************************************************************}

unit main;

interface

uses
  {$IFDEF Linux}
  QGraphics, QControls, QForms, QDialogs, QStdCtrls,
  {$ELSE}
  Windows, Messages, Graphics, Controls, Forms, Dialogs, StdCtrls,
  {$ENDIF}
  SysUtils, Classes, IdBaseComponent, IdComponent, IdTCPConnection, IdSimpleServer;

type
  TfrmMain = class(TForm)
    SServ: TIdSimpleServer;
    btnAccept: TButton;
    procedure btnAcceptClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$IFDEF Linux}{$R *.xfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TfrmMain.btnAcceptClick(Sender: TObject);
begin
  with SServ do begin
    if Listen then begin
      WriteLn('Hello');
      Disconnect;
    end;
  end;
end;

end.
