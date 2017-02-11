unit UServiceCode;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs;

type
  TStbasisName = class(TService)
    procedure ServiceExecute(Sender: TService);
    procedure ServiceShutdown(Sender: TService);
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure ServicePause(Sender: TService; var Paused: Boolean);
    procedure ServiceContinue(Sender: TService; var Continued: Boolean);
    procedure ServiceBeforeInstall(Sender: TService);
    procedure ServiceBeforeUninstall(Sender: TService);
    procedure ServiceCreate(Sender: TObject);
    procedure ServiceDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  StbasisName: TStbasisName;

implementation

{$R *.DFM}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  StbasisName.Controller(CtrlCode);
end;

function TStbasisName.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TStbasisName.ServiceExecute(Sender: TService);
var
  Stream : TMemoryStream;
begin
  ShowMessage('ServiceExecute');
 { Stream := TMemoryStream.Create;
  try
    while not Terminated do begin
      ServiceThread.ProcessRequests(False);
    end;

  finally
    Stream.Free;
  end;           }
end;

procedure TStbasisName.ServiceShutdown(Sender: TService);
begin
  ShowMessage('ServiceShutdown');
end;

procedure TStbasisName.ServiceStart(Sender: TService; var Started: Boolean);
begin
  ShowMessage('ServiceStart');
end;

procedure TStbasisName.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
  ShowMessage('ServiceStop');
end;

procedure TStbasisName.ServicePause(Sender: TService; var Paused: Boolean);
begin
  ShowMessage('ServicePause');
end;

procedure TStbasisName.ServiceContinue(Sender: TService;
  var Continued: Boolean);
begin
  ShowMessage('ServiceContinue');
end;

procedure TStbasisName.ServiceBeforeInstall(Sender: TService);
begin
  ShowMessage('ServiceBeforeInstall');
end;

procedure TStbasisName.ServiceBeforeUninstall(Sender: TService);
begin
  ShowMessage('ServiceBeforeUninstall');
end;

procedure TStbasisName.ServiceCreate(Sender: TObject);
begin
  ShowMessage('ServiceCreate');
end;

procedure TStbasisName.ServiceDestroy(Sender: TObject);
begin
  ShowMessage('ServiceDestroy');
end;

end.
