unit UDPServerMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IdBaseComponent, IdAntiFreezeBase, IdAntiFreeze, IdWinsock, StdCtrls,
  IdUDPServer, IdComponent, IdUDPBase, IdStack;

type
  TUDPMainForm = class(TForm)
    SourceGroupBox: TGroupBox;
    HostNameLabel: TLabel;
    HostAddressLabel: TLabel;
    HostName: TLabel;
    HostAddress: TLabel;
    UDPServer: TIdUDPServer;
    UDPAntiFreeze: TIdAntiFreeze;
    PortLabel: TLabel;
    Port: TLabel;
    BufferSizeLabel: TLabel;
    BufferSize: TLabel;
    UDPMemo: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure UDPServerUDPRead(Sender: TObject; AData: TStream; const APeerIP: String; const APeerPort: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  UDPMainForm: TUDPMainForm;

implementation

const
  HOSTNAMELENGTH = 80;

{$R *.DFM}

procedure TUDPMainForm.FormCreate(Sender: TObject);
begin
  HostName.Caption := UDPServer.LocalName;
  HostAddress.Caption := GStack.LocalAddress;
  Port.Caption := IntToStr(UDPServer.DefaultPort);
  BufferSize.Caption := IntToStr(UDPServer.BufferSize);
  UDPServer.Active := True;
end;

procedure TUDPMainForm.UDPServerUDPRead(Sender: TObject; AData: TStream; const APeerIP: String; const APeerPort: Integer);
var
  DataStringStream: TStringStream;
begin
  DataStringStream := TStringStream.Create('');
  try
    DataStringStream.CopyFrom(AData, AData.Size);
    UDPMemo.Lines.Add('Received "' + DataStringStream.DataString + '" from ' + APeerIP + ' on port ' + IntToStr(APeerPort));
    UDPServer.Send(APeerIP, APeerPort, 'Replied from ' + UDPServer.LocalName + ' to "' + DataStringStream.DataString + '"');
  finally
    DataStringStream.Free;
  end;
end;

end.
