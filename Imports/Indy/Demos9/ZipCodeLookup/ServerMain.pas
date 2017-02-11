unit ServerMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IdBaseComponent, IdComponent, IdTCPServer;

type
  TformMain = class(TForm)
    IdTCPServer1: TIdTCPServer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure IdTCPServer1Connect(AThread: TIdPeerThread);
    procedure IdTCPServer1Execute(AThread: TIdPeerThread);
  private
    ZipCodeList: TStrings;
  public
  end;

var
  formMain: TformMain;

implementation
{$R *.DFM}

procedure TformMain.FormCreate(Sender: TObject);
begin
  ZipCodeList := TStringList.Create;
  ZipCodeList.LoadFromFile(ExtractFilePath(Application.EXEName) + 'ZipCodes.dat');
end;

procedure TformMain.FormDestroy(Sender: TObject);
begin
  ZipCodeList.Free;
end;

procedure TformMain.IdTCPServer1Connect(AThread: TIdPeerThread);
begin
  AThread.Connection.WriteLn('Indy Zip Code Server Ready.');
end;

procedure TformMain.IdTCPServer1Execute(AThread: TIdPeerThread);
var
  sCommand: string;
begin
  with AThread.Connection do begin
    sCommand := ReadLn;
    if SameText(sCommand, 'QUIT') then begin
      Disconnect;
    end else if SameText(Copy(sCommand, 1, 8), 'ZipCode ') then begin
      WriteLn(ZipCodeList.Values[Copy(sCommand, 9, MaxInt)]);
    end;
  end;
end;

end.
