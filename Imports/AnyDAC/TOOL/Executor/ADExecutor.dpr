{$I daAD.inc}
program ADExecutor;
{$APPTYPE CONSOLE}

uses
  SysUtils,  
  Forms,
  Windows,
  {$I ..\TOOLDBs.inc}
  daADGUIxIntf,
  fGUIMain in 'fGUIMain.pas' {frmExecGUIMain},
  uConMain in 'uConMain.pas',
  uDatSUtils in '..\..\DEMO\uDatSUtils.pas';

{$R *.res}

var
  oExec: TADScriptExecutor;
begin
  try
    oExec := TADScriptExecutor.Create;
    try
      oExec.Env := TADScriptConsoleEnv.Create;
      if oExec.ExtractParams then
        if oExec.FileList.Count = 0 then begin
          FreeConsole;
          Application.Initialize;
          Application.Title := 'AnyDAC Executor';
          Application.CreateForm(TfrmExecGUIMain, frmExecGUIMain);
          frmExecGUIMain.SetExecutor(oExec);
          Application.Run;
        end
        else begin
          FADGUIxSilentMode := True;
          oExec.Init;
          if oExec.Connect then begin
            oExec.RunAllScripts;
            Writeln('Done.');
            if oExec.Errors > 0 then
              ExitCode := 1;
          end;
        end
      else
        ExitCode := 1;
    finally
      oExec.Free;
    end;
  except
    on E: Exception do begin
      Writeln('ERROR: ' + E.Message);
      ExitCode := 1;
    end;
  end;
end.
