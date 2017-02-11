program Moni_Main;

uses
  Forms,
  fMoniDemo in 'fMoniDemo.pas' {frmMoniDemo},
  TestComponent in 'TestComponent.pas',
  fMainBase in '..\..\fMainBase.pas' {frmMainBase};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMoniDemo, frmMoniDemo);
  Application.Run;
end.
