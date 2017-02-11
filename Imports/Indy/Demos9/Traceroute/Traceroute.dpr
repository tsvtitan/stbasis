program Traceroute;

uses
  Forms,
  fmTraceRouteMainU in 'fmTraceRouteMainU.pas' {fmTracertMain};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfmTracertMain, fmTracertMain);
  Application.Run;
end.
