program QotdClient;

uses
  Forms,
  main in 'main.pas' {frmQuoteOfTheDayDemo};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmQuoteOfTheDayDemo, frmQuoteOfTheDayDemo);
  Application.Run;
end.
