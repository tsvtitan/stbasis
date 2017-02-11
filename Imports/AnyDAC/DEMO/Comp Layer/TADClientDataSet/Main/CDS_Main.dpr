program CDS_Main;

uses
  Forms,
{$IFDEF APR}
  gsAPRPackBaloon in '..\..\..\..\..\APR\gsAPRPackBaloon.pas',
  gsAPRPackCOM in '..\..\..\..\..\APR\gsAPRPackCOM.pas',
  gsAPRPackComCtrls in '..\..\..\..\..\APR\gsAPRPackComCtrls.pas',
  gsAPRPackDB in '..\..\..\..\..\APR\gsAPRPackDB.pas',
  gsAPRPackMMedia in '..\..\..\..\..\APR\gsAPRPackMMedia.pas',
  gsAPRPackSGrd in '..\..\..\..\..\APR\gsAPRPackSGrd.pas',
  gsAPRPackStd in '..\..\..\..\..\APR\gsAPRPackStd.pas',
{$ENDIF}
  fMainDemo in 'fMainDemo.pas' {TfrmMainDemo},
  fProperties in 'fProperties.pas' {frmProperties},
  fMainBase in '..\..\..\fMainBase.pas' {frmMainBase};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMainDemo, frmMainDemo);
  Application.CreateForm(TfrmMainBase, frmMainBase);
  Application.Run;
end.
