program BuildTest;


{$DEFINE WINVER_0x400_OR_GREATER}
{$DEFINE WINVER_0x401_OR_GREATER}
{$DEFINE WINVER_0x500_OR_GREATER}

{$DEFINE RAS_DYNAMIC_LINK}
{$DEFINE RAS_DYNAMIC_LINK_EXPLICIT}

{$E ~EX}

uses
  RasShost in '..\Pas\RasShost.pas',
  RasAuth in '..\Pas\RasAuth.pas',
  RasDlg in '..\Pas\RasDlg.pas',
  RasEapif in '..\Pas\RasEapif.pas',
  RasError in '..\Pas\RasError.pas',
  RasSapi in '..\Pas\RasSapi.pas',
  Ras in '..\Pas\Ras.pas',
  RasUtils in 'RasUtils.pas',
  RasHelperClasses in 'RasHelperClasses.pas';

begin
end.
