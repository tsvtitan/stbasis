program Demo;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  ResFrm in 'ResFrm.pas' {CheckResForm},
  MemSpd in 'MemSpd.pas' {SpeedForm},
  Sample in 'Sample.pas',
  PCrypt in 'PCrypt.pas' {PartForm},
  StrDemo in 'StrDemo.pas' {StringForm},
  IVDemo in 'IVDemo.pas' {IVForm},
  Cipher in '..\Source\Cipher.pas',
  DECConst in '..\Source\DECConst.pas',
  DECUtil in '..\Source\DECUtil.pas',
  Hash in '..\Source\Hash.pas',
  HCMngr in '..\Source\HCMngr.pas',
  RFC2289 in '..\Source\RFC2289.pas',
  RNG in '..\Source\Rng.pas',
  OTPDemo in 'OTPDemo.pas' {OTPForm},
  GenForm in 'GenForm.pas' {GForm},
  Cipher1 in '..\Source\Cipher1.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'DEC Part I';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
