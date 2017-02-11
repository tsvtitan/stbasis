library CPL;

uses
  CtlPanel,
  UCPLCode in 'UCPLCode.pas' {AppletModule1: TAppletModule};

exports CPlApplet;

{$R *.RES}

{$E cpl}

begin
  Application.Initialize;
  Application.CreateForm(TAppletModule1, AppletModule1);
  Application.Run;
end.