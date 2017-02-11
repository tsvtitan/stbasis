unit Main;

interface

uses
  {$IFDEF Linux}
  QGraphics, QControls, QForms, QStdCtrls, QExtCtrls,
  {$ELSE}
  Graphics, Controls, Forms, StdCtrls, ExtCtrls,
  {$ENDIF}
  Classes,
  IdBaseComponent, IdComponent, IdTCPServer,
  SysUtils;

type
  TformMain = class(TForm)
    IdTCPServer1: TIdTCPServer;
    Timer1: TTimer;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure IdTCPServer1Connect(AThread: TIdPeerThread);
    procedure IdTCPServer1Execute(AThread: TIdPeerThread);
    procedure Timer1Timer(Sender: TObject);
  private
    FZipCodeList: TStrings;
  public
  end;

var
  formMain: TformMain;

implementation
{$R *.dfm}

uses
  SyncObjs;

var
  GLogCS: TCriticalSection;
  GUserLog: TStringList;

procedure TformMain.FormCreate(Sender: TObject);
begin
  FZipCodeList := TStringList.Create;
  FZipCodeList.LoadFromFile(ExtractFilePath(Application.EXEName) + 'ZipCodes.dat');
end;

procedure TformMain.FormDestroy(Sender: TObject);
begin
  FZipCodeList.Free;
end;

procedure TformMain.IdTCPServer1Connect(AThread: TIdPeerThread);
begin
  AThread.Connection.WriteLn('Indy Zip Code Server Ready.');
end;

procedure TformMain.IdTCPServer1Execute(AThread: TIdPeerThread);
var
  LCommand: string;
  LZipCode: string;
begin
  with AThread.Connection do begin
    LCommand := ReadLn;
    if AnsiSameText(LCommand, 'QUIT') then begin
      Disconnect;
    end else if AnsiSameText(Copy(LCommand, 1, 8), 'ZipCode ') then begin
      LZipCode := Copy(LCommand, 9, MaxInt);
      GLogCS.Enter; try
        GUserLog.Add(LZipCode);
      finally GLogCS.Leave; end;
      WriteLn(FZipCodeList.Values[LZipCode]);
    end;
  end;
end;

procedure TformMain.Timer1Timer(Sender: TObject);
begin
  GLogCS.Enter; try
    memo1.Lines.AddStrings(GUserLog);
    GUserLog.Clear;
  finally GLogCS.Leave; end;
end;

initialization
  GLogCS := TCriticalSection.Create;
  GUserLog := TStringList.Create;
finalization
  FreeAndNil(GUserLog);
  FreeAndNil(GLogCS);
end.
