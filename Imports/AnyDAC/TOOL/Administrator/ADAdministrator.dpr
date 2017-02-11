{$I daAD.inc}
program ADAdministrator;

uses
  Forms,
  {$I ..\TOOLDBs.inc}
  daADGUIxFormsfConnEdit,
  daADGUIxFormsfAbout,
  daADGUIxFormsfOptsBase,
  fADSettingsDesc in '..\Explorer\fADSettingsDesc.pas' {frmADSettingsDesc: TFrame},
  fRootDesc in '..\Explorer\fRootDesc.pas',
  fBlob in '..\Explorer\fBlob.pas' {frmBlob},
  fConnDefDesc in '..\Explorer\fConnDefDesc.pas',
  fDbDesc in '..\Explorer\fDbDesc.pas',
  fDbObjDesc in '..\Explorer\fDbObjDesc.pas',
  fDbSetDesc in '..\Explorer\fDbSetDesc.pas',
  fExplorer in '..\Explorer\fExplorer.pas' {frmExplorer},
  fOptions in '..\Explorer\fOptions.pas',
  fBaseDesc in '..\Explorer\fBaseDesc.pas' {frmBaseDesc: TFrame},
  fImpAliases in '..\Explorer\fImpAliases.pas' {frmImportAliases},
  fMakeBDECompatible in '..\Explorer\fMakeBDECompatible.pas';

{$R *.res}

begin
  FADExplorerWithSQL := False;
  Application.Initialize;
  Application.CreateForm(TfrmExplorer, frmExplorer);
  Application.Run;
end.
