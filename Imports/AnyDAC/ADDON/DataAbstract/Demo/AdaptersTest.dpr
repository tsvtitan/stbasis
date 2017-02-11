program AdaptersTest;

uses
  Forms,
  fMainForm in 'fMainForm.pas' {Form1},
  uDAAnyDACDriver in '..\Drivers\uDAAnyDACDriver.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
