program aaa;

uses
  UServiceCode in 'UServiceCode.pas' {StbasisName: TService},
  SvcMgr in 'svcmgr.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TStbasisName, StbasisName);
  Application.Run;
end.
