unit UDPServerMain;

interface

uses
  {$IFDEF Linux}
    QGraphics,   QControls,   QForms,   QDialogs,   QStdCtrls,
  {$ELSE}
  Windows, Messages, Graphics, Controls, Forms, Dialogs, IdWinsock,   stdctrls,
  {$ENDIF}
  SysUtils, Classes, IdBaseComponent, IdAntiFreezeBase, IdAntiFreeze,
  IdComponent, IdUDPBase, IdUDPClient, IdStack, IdUDPServer, IdSocketHandle;


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
    procedure UDPServerUDPRead(Sender: TObject; AData: TStream; ABinding: TIdSocketHandle);
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

{$IFDEF Linux}{$R *.xfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TUDPMainForm.FormCreate(Sender: TObject);
begin
  HostName.Caption := UDPServer.LocalName;
  HostAddress.Caption := GStack.LocalAddress;
  Port.Caption := IntToStr(UDPServer.DefaultPort);
  BufferSize.Caption := IntToStr(UDPServer.BufferSize);
  UDPServer.Active := True;
end;

procedure TUDPMainForm.UDPServerUDPRead(Sender: TObject; AData: TStream; ABinding: TIdSocketHandle);
var
  DataStringStream: TStringStream;
  s: String;
begin
  DataStringStream := TStringStream.Create('');
  try
    DataStringStream.CopyFrom(AData, AData.Size);
    UDPMemo.Lines.Add('Received "' + DataStringStream.DataString + '" from ' + ABinding.PeerIP + ' on port ' + IntToStr(ABinding.PeerPort));
    s := 'Replied from ' + UDPServer.LocalName + ' to "' + DataStringStream.DataString + '"';
    ABinding.SendTo(ABinding.PeerIP, ABinding.PeerPort, s[1], Length(s));
  finally
    DataStringStream.Free;
  end;
end;


end.
