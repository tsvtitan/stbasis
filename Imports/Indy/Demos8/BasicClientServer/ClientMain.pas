{***************************************************************
 *
 * Project  : Client
 * Unit Name: ClientMain
 * Purpose  : Demonstrates basic interaction of IdTCPClient with server
 * Date     : 16/01/2001  -  03:21:02
 * History  :
 *
 ****************************************************************}

unit ClientMain;

interface

uses
  {$IFDEF Linux}
  QForms, QGraphics, QControls, QDialogs, QStdCtrls, QExtCtrls,
  {$ELSE}
  Windows, Messages, Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls,
  {$ENDIF}
  SysUtils, Classes,
  IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient;

type
  TForm2 = class(TForm)
    TCPClient: TIdTCPClient;
    pnlTop: TPanel;
    btnGo: TButton;
    lstMain: TListBox;
    Button1: TButton;
    procedure btnGoClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
  public
  end;

var
  Form2: TForm2;

implementation
{$IFDEF Linux}{$R *.xfm}{$ELSE}{$R *.DFM}{$ENDIF}

// Any data received from the client is added as a text line in the ListBox
procedure TForm2.btnGoClick(Sender: TObject);
begin
  with TCPClient do
  begin
    if not Connected then Connect;
    try
      WriteLn;
      lstMain.Items.Add(ReadLn);
    finally
      // Disconnect;
    end;
  end;
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
  try
    if TCPClient.Connected then begin
      TCPClient.WriteLn;
      lstMain.Items.Add(TCPClient.ReadLn);
    end;
  finally
    TCPClient.Disconnect;
  end;
end;

end.
