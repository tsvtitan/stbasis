unit IndyTCPServer;
{This Unit was programmed by Anthony J. Caduto on 17 March 2001
Anyone may use this Unit for any purpose, however I would ask that if you make improvements to
the basic structure to send them to me so I can include them. You will be given credit for your additions
My email address is tcaduto@amsoftwaredesign.com}

{In this unit we wrap the Indy TCP server object and the Indy thread manager object into
a class called TIndyTCPServer.  All the Indy TCP server events are declared in the private section of the
class.
The constructor creates the two Indy objects, sets their properties and activates the Indy
server.
The destructor frees the obects created in the constructor

You should be able to substitute any of the INDY server objects in this framework very easily}

interface

uses
  IdThreadMgr, IdThreadMgrDefault, IdBaseComponent, IdComponent,
  IdTCPServer;

type
  TIndyTCPServer = class(Tobject)
  IndyTCP: TIdTCPServer;
  Indythreadmgr: TIdThreadMgrDefault;
  private
    { Private declarations }
    procedure IndyTCPExecute(AThread: TIdPeerThread);
    procedure IndyTCPConnect(AThread: TIdPeerThread);
    procedure IndyTCPDisconnect(AThread: TIdPeerThread);
    procedure IndyTCPStatus(axSender: TObject;const axStatus: TIdStatus; const asStatusText: String);
  public
       Constructor Create;
       Destructor  Destroy;override;
  end;

implementation


{ TIndyTCPServer }

constructor TIndyTCPServer.Create;
begin
     inherited create;
     IndyTCP                            :=TIDTCPServer.create(nil);
     Indythreadmgr                      :=TIdThreadMgrDefault.Create(nil);
     {Set Indy TCP server Properties}
     With IndyTCP do
          begin
              ThreadMgr               :=Indythreadmgr;
              OnExecute               :=IndyTCPExecute;
              OnConnect               :=IndyTCPConnect;
              OnDisconnect            :=IndyTCPDisconnect;
              OnStatus                :=IndyTCPStatus;
              TerminateWaitTime       :=5000;
              DefaultPort             :=9300;
              {Activate the Indy Server}
              Active                  :=true;
          end;

end;

destructor TIndyTCPServer.Destroy;
begin
    IndyTCP.Free;
    Indythreadmgr.Free;
    inherited Destroy;
end;



procedure TIndyTCPServer.IndyTCPStatus(axSender: TObject;
  const axStatus: TIdStatus; const asStatusText: String);
begin

end;

procedure TIndyTCPServer.IndyTCPExecute(AThread: TIdPeerThread);
var
command:string;
begin

command:= Athread.Connection.ReadLn;

if command = 'test' then
 begin
     system.Writeln('Test command received');
     Athread.Connection.WriteLn('indeed');
 end;

if command = 'shutdown' then
    begin
        Athread.Connection.WriteLn('Shutting down');
        system.Writeln('Server is shutting down');
        IndyTCP.Active:=false;
        
    end;

end;

procedure TIndyTCPServer.IndyTCPConnect(AThread: TIdPeerThread);
begin

end;

procedure TIndyTCPServer.IndyTCPDisconnect(AThread: TIdPeerThread);
begin

end;

end.
 