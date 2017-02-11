{***************************************************************
 *
 * Project  : WSZipCodeServer
 * Unit Name: ServerMain
 * Purpose  : Demonstrates use of TCPServer as ZipCode server
 * Date     : 21/01/2001  -  16:15:37
 * History  :
 *
 ****************************************************************}

unit ServerMain;

interface

uses
  {$IFDEF Linux}
  QControls, QGraphics, QForms, QDialogs,
  {$ELSE}
  Windows, Messages, Graphics, Controls, Forms, Dialogs,
  {$ENDIF}
  SysUtils, Classes, IdBaseComponent, IdComponent, IdTCPServer;

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
{$IFDEF Linux}{$R *.xfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TformMain.FormCreate(Sender: TObject);
begin
  ZipCodeList := TStringList.Create;
  ZipCodeList.LoadFromFile(ExtractFilePath(Application.EXEName) + 'ZipCodes.dat');
end;

procedure TformMain.FormDestroy(Sender: TObject);
begin
  ZipCodeList := nil;
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
