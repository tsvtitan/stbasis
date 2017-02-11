unit Main;

interface

uses
  {$IFDEF Linux}
  QGraphics, QControls, QForms,
  {$ELSE}
  Graphics, Controls, Forms, 
  {$ENDIF}
  Classes,
  IdBaseComponent, IdComponent, IdTCPServer,
  SysUtils;

type
  TformMain = class(TForm)
    IdTCPServer1: TIdTCPServer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure IdTCPServer1Connect(AThread: TIdPeerThread);
    procedure IdTCPServer1Execute(AThread: TIdPeerThread);
  private
    FZipCodeList: TStrings;
  public
  end;

var
  formMain: TformMain;

implementation
{$R *.dfm}

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
begin
  with AThread.Connection do begin
    LCommand := ReadLn;
    if AnsiSameText(LCommand, 'QUIT') then begin
      Disconnect;
    end else if AnsiSameText(Copy(LCommand, 1, 8), 'ZipCode ') then begin
      WriteLn(FZipCodeList.Values[Copy(LCommand, 9, MaxInt)]);
    end;
  end;
end;

end.
