unit fMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IdThreadMgr, IdThreadMgrPool, IdBaseComponent, IdComponent,
  IdTCPServer, SyncObjs;

type
  TfrmMain = class(TForm)
    Label1: TLabel;
    edtNumConnections: TEdit;
    IdTCPServer: TIdTCPServer;
    IdThreadMgrPool: TIdThreadMgrPool;
    Label2: TLabel;
    Label3: TLabel;
    lblClientConnections: TLabel;
    btnServer: TButton;
    btnExit: TButton;
    chkThreadPool: TCheckBox;
    procedure btnExitClick(Sender: TObject);
    procedure btnServerClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure IdTCPServerConnect(AThread: TIdPeerThread);
    procedure IdTCPServerDisconnect(AThread: TIdPeerThread);
    procedure IdTCPServerExecute(AThread: TIdPeerThread);
    procedure IdTCPServerException(AThread: TIdPeerThread;
      AException: Exception);
    procedure IdTCPServerListenException(AThread: TIdListenerThread;
      AException: Exception);
  private
    { Private declarations }
  public
    { Public declarations }
  fConnections : integer;
  CS : TCriticalSection;
  Procedure LockControls;
  procedure UnlockControls;
  end;

var
  frmMain: TfrmMain;

implementation
{We include IdGlobal because Delphi 4 does not have FreeAndNil.  For D4
IdGlobal has an IFDEF'ed FreeAndNil procedure that is compiled if Delphi 4 is
used.}
uses IdGlobal;

{$R *.DFM}

procedure TfrmMain.btnExitClick(Sender: TObject);
begin
application.terminate;
end;

procedure TfrmMain.btnServerClick(Sender: TObject);
begin
if IdTCPServer.active then
  begin
  UnlockControls;
  btnServer.caption := 'Start server';
  IdTCPServer.active := false;
  end
else
  begin
  LockControls;  
  btnServer.caption := 'Stop server';
  if trim(edtNumConnections.text) <> '' then
    IdTCPServer.MaxConnections := StrToInt(edtNumConnections.text);
  if chkThreadPool.checked then
    IdTCPServer.ThreadMgr := IdThreadMgrPool
  else IdTCPServer.ThreadMgr := nil;
  IdTCPServer.active := true;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
if not assigned(CS) then CS := TCriticalSection.create;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
if assigned(CS) then FreeAndNil(CS);
end;

procedure TfrmMain.LockControls;
begin
edtNumConnections.enabled := false;
edtNumConnections.color := clGray;
chkThreadPool.enabled := false;
end;

procedure TfrmMain.UnlockControls;
begin
edtNumConnections.enabled := true;
edtNumConnections.color := clWhite;
chkThreadPool.enabled := true;
end;

procedure TfrmMain.IdTCPServerConnect(AThread: TIdPeerThread);
begin

CS.enter;
inc(fConnections);
lblClientConnections.caption := '[ ' + IntToStr(fConnections) + ' ]';
CS.Leave;

end;

procedure TfrmMain.IdTCPServerDisconnect(AThread: TIdPeerThread);
begin
CS.enter;
dec(fConnections);
lblClientConnections.caption := '[ ' + IntToStr(fConnections) + ' ]';
CS.Leave;

end;

// All we want to do is echo back the text sent by the server
procedure TfrmMain.IdTCPServerExecute(AThread: TIdPeerThread);
var
  s : string;
begin
s := AThread.connection.ReadLn;
AThread.connection.writeln(s);
end;

procedure TfrmMain.IdTCPServerException(AThread: TIdPeerThread;
  AException: Exception);
begin
//ShowMessage('Server exception' + #13 + AException.message + #13 + AException.ClassName);
end;

procedure TfrmMain.IdTCPServerListenException(AThread: TIdListenerThread;
  AException: Exception);
begin
//ShowMessage('Listen exception' + #13 + AException.message + #13 + AException.ClassName);
end;

end.
