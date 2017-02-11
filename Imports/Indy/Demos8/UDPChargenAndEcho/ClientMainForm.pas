unit ClientMainForm;

interface

uses
  {$IFDEF Linux}
  QGraphics, QControls, QForms, QStdCtrls, QDialogs,
  {$ELSE}
  Windows, Buttons, Messages, Graphics, Controls, Forms, Dialogs,
  {$ENDIF}
  SysUtils, Classes, IdBaseComponent, IdComponent, IdUDPBase, IdUDPClient,
  StdCtrls;

type
  TfrmMain = class(TForm)
    Button1: TButton;
    IdUDPClient1: TIdUDPClient;
    IdUDPClient2: TIdUDPClient;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure Test(IdUDPClient: TIdUDPClient);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$IFDEF Linux}{$R *.xfm}{$ELSE}{$R *.DFM}{$ENDIF}

uses IdException, IdStackConsts;

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  Test(IdUDPClient1);
end;

procedure TfrmMain.Button2Click(Sender: TObject);
begin
  Test(IdUDPClient2);
end;

procedure TfrmMain.Test(IdUDPClient: TIdUDPClient);
var
  counter: integer;
  s, peer: string;
  port: integer;
begin
  counter := 1;
  Screen.Cursor := crHourGlass;
  try
    IdUDPClient.Send(Format('test #%d', [counter]));
    inc(counter);
    repeat
      try
        s := IdUDPClient.ReceiveString(peer, port);
      except
        on E: EIdSocketError do
          if E.LastError <> 10040 then
            raise;
      end;
      if s <> '' then
        ShowMessage(Format('%s:%d said'#13'%s', [peer, port, s]));
    until s = '';
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  // enable broadcast support in TIdUDPClient
  IdUDPClient1.BroadcastEnabled := True;
  IdUDPClient2.BroadcastEnabled := True;
end;

end.
