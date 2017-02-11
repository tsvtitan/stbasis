{$I daAD.inc}
program ADExplorer;

uses
  Forms,
  {$I ..\TOOLDBs.inc}
  daADGUIxFormsfConnEdit,
  daADGUIxFormsfAbout,
  daADGUIxFormsfOptsBase,
  fExplorer in 'fExplorer.pas' {frmExplorer},
  fADSettingsDesc in 'fADSettingsDesc.pas' {frmADSettingsDesc: TFrame},
  fConnDefDesc in 'fConnDefDesc.pas' {frmConnDefDesc: TFrame},
  fBaseDesc in 'fBaseDesc.pas' {frmBaseDesc: TFrame},
  fRootDesc in 'fRootDesc.pas' {frmRootDesc: TFrame},
  fDbDesc in 'fDbDesc.pas' {frmDbDesc: TFrame},
  fDbObjDesc in 'fDbObjDesc.pas' {frmDbObjDesc: TFrame},
  fDbSetDesc in 'fDbSetDesc.pas' {frmDbSetDesc: TFrame},
  fOptions in 'fOptions.pas' {frmOptions},
  fBlob in 'fBlob.pas' {frmBlob},
  fImpAliases in 'fImpAliases.pas',
  fMakeBDECompatible in 'fMakeBDECompatible.pas' {frmMakeBDECompatible};

{$R *.RES}

begin
  FADExplorerWithSQL := True;
  Application.Initialize;
  Application.CreateForm(TfrmExplorer, frmExplorer);
  Application.Run;
end.

