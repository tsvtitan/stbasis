{***************************************************************
 *
 * Project  : Load testing client
 * Unit Name: fMain
 * Purpose  : Demonstrates load testing against a server and using Indy clients within threads
 * Version  : 1.0
 * Date     : Sat 14 Jul 2001  -  02:15:21
 * Author   : Allen O'Neill <allen_oneill@hotmail.com>
 * History  :
 * Tested   : Sat 14 Jul 2001  // Allen O'Neill <allen_oneill@hotmail.com>
 *
 ****************************************************************}

unit fMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, ExtCtrls, SyncObjs;

type
  TfrmMain = class(TForm)
    Label1: TLabel;
    edtNumThreads: TEdit;
    lvThreads: TListView;
    Label2: TLabel;
    btnThreads: TButton;
    btnExit: TButton;
    Label3: TLabel;
    edtServerIP: TEdit;
    Label4: TLabel;
    edtServerPort: TEdit;
    tmrThreadScan: TTimer;
    btnStopSelected: TButton;
    procedure btnThreadsClick(Sender: TObject);
    procedure tmrThreadScanTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure btnStopSelectedClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  NumThreads :Integer;
  CS : TCriticalSection;
  Procedure LockControls;
  Procedure UnlockControls;
  Procedure RemoveFromList(Sender : TObject);
  end;

var
  frmMain: TfrmMain;

implementation
{We include IdGlobal because Delphi 4 does not have FreeAndNil.  For D4
IdGlobal has an IFDEF'ed FreeAndNil procedure that is compiled if Delphi 4 is
used.}
uses ClientThread, IdGlobal;

{$R *.DFM}

procedure TfrmMain.btnThreadsClick(Sender: TObject);
var
  i : integer;
  ClientThread : TClientThread;
  Itm : TListItem;
begin
try

if btnThreads.caption = 'Start Threads' then
  begin
  LockControls;

  btnThreads.caption := 'Stop Threads';

  lvThreads.AllocBy := StrToInt(edtNumThreads.text);
  lvThreads.Items.BeginUpdate;

  for i := 0 to StrToInt(edtNumThreads.text) -1 do
    begin
    inc(NumThreads);
    ClientThread := TClientThread.Create(true);
    with ClientThread do
      begin
      OnTerminate := RemoveFromList;
      FreeOnTerminate := true;
      ServerIP := edtServerIP.text;
      Port := StrToInt(edtServerPort.text);
      ThreadID := i;
      Resume;
      end;
    Itm := lvThreads.Items.Add;
    Itm.Caption := 'ID: ' + IntToStr(i);
    Itm.SubItems.Append('Waiting...');
    Itm.SubItems.Append('---');
    Itm.SubItems.Append('---');
    Itm.Data := Pointer(ClientThread);
    end;
  lvThreads.Items.EndUpdate;
  end
else
if btnThreads.caption = 'Stop Threads' then
  begin
  btnThreads.caption := 'Start Threads';
  for i := 0 to lvThreads.Items.Count - 1 do
    TClientThread(lvThreads.Items[i].Data).Kill := true;
  UnlockControls;
  end;

except
on E : Exception do
ShowMessage(E.Message);
end;



end;

procedure TfrmMain.tmrThreadScanTimer(Sender: TObject);
var
  i : integer;
begin
tmrThreadScan.enabled := false;

CS.Enter;
lvThreads.Items.BeginUpdate;

for i := 0 to lvThreads.Items.Count -1 do
  if lvThreads.Items[i].SubItems[0] <> 'DEAD' then
    begin
    lvThreads.Items[i].SubItems[0] := TClientThread(lvThreads.Items[i].Data).Status;
    lvThreads.Items[i].SubItems[1] := IntToStr(TClientThread(lvThreads.Items[i].Data).RoundTripTime);
    lvThreads.Items[i].SubItems[2] := TClientThread(lvThreads.Items[i].Data).SendString;
    end;

if NumThreads = 0 then lvThreads.Items.Clear;

lvThreads.Items.EndUpdate;
CS.Leave;

tmrThreadScan.enabled := true;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
if not assigned(CS) then
  CS := TCriticalSection.Create;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
if assigned(CS) then FreeAndNil(CS);
end;

procedure TfrmMain.btnExitClick(Sender: TObject);
begin
btnThreads.Click;
application.terminate;
end;

procedure TfrmMain.LockControls;
begin
btnStopSelected.visible := true;
edtNumThreads.color := clGray;
edtNumThreads.enabled := false;
edtServerIP.color := clGray;
edtServerIP.enabled := false;
edtServerIP.color := clGray;
edtServerPort.enabled := false;
edtServerPort.color :=clGray;
btnExit.enabled := false;
end;

procedure TfrmMain.UnlockControls;
begin
btnStopSelected.visible := false;
edtNumThreads.color := clWhite;
edtNumThreads.enabled := true;
edtServerIP.color := clWhite;
edtServerIP.enabled := true;
edtServerIP.color := clWhite;
edtServerPort.enabled := true;
edtServerPort.color :=clWhite;
btnExit.enabled := true;
end;

procedure TfrmMain.RemoveFromList(Sender: TObject);
var
  i : integer;
begin
try
CS.Enter;
for i := 0 to lvThreads.items.count - 1 do
  begin
  if copy(lvThreads.items[i].Caption,1,length(lvThreads.items[i].Caption))
    = 'ID: ' + IntToStr(TClientThread(Sender).ThreadID) then
  lvThreads.Items[i].SubItems[0] := 'DEAD';
  end;
Dec(NumThreads);
CS.Leave;
except
on E : Exception do
ShowMessage(E.Message);
end;
end;

procedure TfrmMain.btnStopSelectedClick(Sender: TObject);
begin
if lvThreads.SelCount > 0 then
  TClientThread(lvThreads.Selected.Data).Kill := true;
end;

end.
