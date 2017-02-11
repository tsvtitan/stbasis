program LiteBrowser;

uses
  Forms,
  LiteBrows in 'LiteBrows.pas' {HTTPForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(THTTPForm, HTTPForm);
  Application.Run;
end.
