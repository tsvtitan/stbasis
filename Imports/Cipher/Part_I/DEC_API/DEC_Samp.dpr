program DEC_Samp;

uses
  Forms,
  Main in 'Main.pas' {MainForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'DEC1 API Demo';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
