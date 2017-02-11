program WMFInfo;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Ex_Grid in '..\Ex_Grid.pas',
  Ex_Utils in '..\Ex_Utils.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'WMF Info';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
