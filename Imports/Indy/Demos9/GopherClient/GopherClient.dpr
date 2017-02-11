program gopherclient;

uses
  Forms,
  gmain in 'gmain.pas' {frmGopher},
  textview in 'textview.pas' {frmTextView};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmGopher, frmGopher);
  Application.CreateForm(TfrmTextView, frmTextView);
  Application.Run;
end.
