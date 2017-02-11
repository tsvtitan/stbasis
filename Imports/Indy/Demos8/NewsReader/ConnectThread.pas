unit ConnectThread;

interface
uses classes, sysutils, IdTCPClient;

type
  TProc = procedure() of object;
  TExcClass = class of exception;
  TIdConnectThread = class(TThread)
  public
    ConnectProc: TProc;
    errormsg: string;
    done: boolean;
    excclass: TExcClass;
    procedure Execute; override;
  end;

procedure ConnectThreaded(AClient : TIdTCPClient);

implementation
uses IdAntiFreezeBase, Windows;

procedure ConnectThreaded(AClient : TIdTCPClient);
begin
    with TIdConnectThread.Create(true) do
    try
      TMethod(ConnectProc).Code := Addr(TIdTCPClient.Connect);
//     FConnecting := true; // new property Connecting (readonly)
      resume;
      repeat
        sleep(10);
        TIdAntiFreezeBase.DoProcess(true);
      until done;
//      FConnecting := false;
      if assigned(excclass)
        then raise excclass.Create(errormsg);
    finally
      free;
    end;
end;

{ TIdConnectThread }

procedure TIdConnectThread.Execute;
begin
  inherited;
  done := false;
  errormsg := '';
  excclass := nil;
  try
    if assigned(connectproc)
      then connectproc();
  except
    on e: exception do
    begin
      errormsg := e.message;
      excclass := TExcClass(e.classtype);
    end;
  end;
  done := true;
end;

end.
