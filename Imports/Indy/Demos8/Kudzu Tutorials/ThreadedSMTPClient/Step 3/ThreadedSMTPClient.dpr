program ThreadedSMTPClient;

{
Please do not expand or modify this demo in anyway. If you wish to do so please use a new demo
and copy the appropriate parts.

This demo is used for my articles, book chapters, and conference sessions and may be
limited in certain scopes. This is because they are teaching demos and designed to demonstrate
limited but specific items concepts.

Chad Z. Hower aka "Kudzu"
}

uses
  {$IFDEF Linux}
  QForms,
  {$ELSE}
  Forms,
  {$ENDIF}
  Main in 'Main.pas' {formMain},
  SMTPThread in 'SMTPThread.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TformMain, formMain);
  Application.Run;
end.
