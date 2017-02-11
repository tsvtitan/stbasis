unit fMain;
{***************************************************************
 *
 * Project  : Client
 * Unit Name: fMain
 * Purpose  : Demonstrates sending / receiving record data and use of buffers
 * Version  : 1.0
 * Date     : Sat 14 Jul 2001  -  03:50:24
 * Author   : Allen O'Neill <allen_oneill@hotmail.com>
 * History  :
 * Tested   : Sat 14 Jul 2001  // Allen O'Neill <allen_oneill@hotmail.com>
 *
 ****************************************************************}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IdBaseComponent, IdComponent, IdTCPServer;

type
  Direction = (dirLeft,dirRight);

type
  MyRecord = Packed Record
  MyInteger : Integer;
  MyString : String[250];
  MyBool : Boolean;
  MyDirection : Direction;
  end;


type
  TfrmMain = class(TForm)
    IdTCPServer: TIdTCPServer;
    btnStart: TButton;
    btnExit: TButton;
    procedure btnExitClick(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure IdTCPServerExecute(AThread: TIdPeerThread);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.DFM}

procedure TfrmMain.btnExitClick(Sender: TObject);
begin
if IdTCPServer.active then IdTCPServer.active := false;
application.terminate;
end;

procedure TfrmMain.btnStartClick(Sender: TObject);
begin
IdTCPServer.active := not IdTCPServer.active;

if btnStart.caption = 'Start' then btnStart.caption := 'Stop'
else if btnStart.caption = 'Stop' then btnStart.caption := 'Start';

end;

procedure TfrmMain.IdTCPServerExecute(AThread: TIdPeerThread);
var
  MyRec : MyRecord;
begin
AThread.connection.ReadBuffer(MyRec,SizeOf(MyRec));
AThread.connection.WriteBuffer(MyRec,SizeOf(MyRec),true);
end;

end.
