{-------------------------------------------------------------------------------}
{ AnyDAC Executor form                                                          }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit fGUIMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, ImgList, ComCtrls, ToolWin, ActnList, Menus,
{$IFDEF AnyDAC_D6}
  StrUtils, Variants,
{$ENDIF}
  daADStanIntf, daADStanSQLParser,
  daADGUIxFormsControls, daADGUIxFormsfError, daADGUIxFormsfLogin,
    daADGUIxFormsfAsync, daADGUIxFormsWait,
  daADPhysIntf,
  uConMain;

type
  TfrmExecGUIMain = class(TForm)
    dlgOpen: TOpenDialog;
    ActionList1: TActionList;
    acOpenScript: TAction;
    acExit: TAction;
    acRun: TAction;
    acRunByStep: TAction;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Opensqlfile1: TMenuItem;
    Exit1: TMenuItem;
    Help1: TMenuItem;
    acAbout: TAction;
    About1: TMenuItem;
    Run1: TMenuItem;
    Runscript1: TMenuItem;
    Runbystep1: TMenuItem;
    Options1: TMenuItem;
    mniContOnErrors: TMenuItem;
    ADGUIxFormsErrorDialog1: TADGUIxFormsErrorDialog;
    acSkipStep: TAction;
    Dropoutcommand1: TMenuItem;
    mniShowMessages: TMenuItem;
    acContinueOnError: TAction;
    acShowMessages: TAction;
    dlgSaveScript: TSaveDialog;
    acSaveScript: TAction;
    SaveLogas1: TMenuItem;
    ADGUIxFormsLoginDialog1: TADGUIxFormsLoginDialog;
    ADGUIxFormsAsyncExecuteDialog1: TADGUIxFormsAsyncExecuteDialog;
    ADGUIxWaitCursor1: TADGUIxWaitCursor;
    pnlMain: TADGUIxFormsPanel;
    Panel10: TADGUIxFormsPanel;
    Panel11: TADGUIxFormsPanel;
    pnlInstructionName: TADGUIxFormsPanel;
    pnlTopFrame: TADGUIxFormsPanel;
    pnlToolbar: TADGUIxFormsPanel;
    ToolBar1: TToolBar;
    tbtOpen: TToolButton;
    ToolButton6: TToolButton;
    ToolButton2: TToolButton;
    tbtRun: TToolButton;
    ToolButton1: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    lblTitle: TLabel;
    Panel5: TADGUIxFormsPanel;
    pnlTitleBottomLine: TADGUIxFormsPanel;
    Panel15: TADGUIxFormsPanel;
    Panel16: TADGUIxFormsPanel;
    Label2: TLabel;
    Panel17: TADGUIxFormsPanel;
    Panel18: TADGUIxFormsPanel;
    mmLog: TMemo;
    sbMain: TStatusBar;
    Splitter1: TSplitter;
    N1: TMenuItem;
    ilMain: TImageList;
    ToolButton8: TToolButton;
    Panel1: TADGUIxFormsPanel;
    Label3: TLabel;
    cbConnDef: TComboBox;
    acDropNonexistObj: TAction;
    HideNoObjAtDropErrors1: TMenuItem;
    dlgSaveLog: TSaveDialog;
    acSaveLog: TAction;
    SaveLog1: TMenuItem;
    N2: TMenuItem;
    procedure cbConnDefChange(Sender: TObject);
    procedure acOpenScriptExecute(Sender: TObject);
    procedure acExitExecute(Sender: TObject);
    procedure acRunExecute(Sender: TObject);
    procedure acRunByStepExecute(Sender: TObject);
    procedure acAboutExecute(Sender: TObject);
    procedure acRunByStepUpdate(Sender: TObject);
    procedure acSkipStepExecute(Sender: TObject);
    procedure acContinueOnErrorExecute(Sender: TObject);
    procedure acShowMessagesExecute(Sender: TObject);
    procedure acSaveScriptExecute(Sender: TObject);
    procedure acSaveScriptUpdate(Sender: TObject);
    procedure acRunUpdate(Sender: TObject);
    procedure acSkipStepUpdate(Sender: TObject);
    procedure acContinueOnErrorUpdate(Sender: TObject);
    procedure acShowMessagesUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure acDropNonexistObjUpdate(Sender: TObject);
    procedure acDropNonexistObjExecute(Sender: TObject);
    procedure mmScriptKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure mmScriptMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure acSaveLogUpdate(Sender: TObject);
    procedure acSaveLogExecute(Sender: TObject);
  private
    FExec: TADScriptExecutor;
  public
    mmScript: TADGUIxFormsMemo;
    procedure SetExecutor(AExec: TADScriptExecutor);
  end;

var
  frmExecGUIMain: TfrmExecGUIMain;

implementation

uses
  IniFiles,
  uDatSUtils,
  daADStanError, daADStanConst, daADStanUtil,
  daADGUIxFormsfAbout;

{$R *.dfm}

{-------------------------------------------------------------------------------}
type
  TADScriptFormEnv = class (TADScriptEnv)
  private
    FFrm: TfrmExecGUIMain;
    FNewLine: Boolean;
  protected
    procedure DoConnectError(E: Exception); override;
    procedure DoCommandError(E: Exception); override;
    procedure DoCommandChanged; override;
    procedure DoLog(const AMsg: String; ANewLine: Boolean); override;
    procedure DoCheckUpdateScriptAndPos; override;
  public
    constructor Create(AForm: TfrmExecGUIMain);
  end;

{-------------------------------------------------------------------------------}
{ TADScriptFormEnv                                                              }
{-------------------------------------------------------------------------------}
constructor TADScriptFormEnv.Create(AForm: TfrmExecGUIMain);
begin
  inherited Create;
  FFrm := AForm;
end;

{-------------------------------------------------------------------------------}
procedure TADScriptFormEnv.DoConnectError(E: Exception);
begin
  if EADException(E).ADCode <> er_AD_ClntDbLoginAborted then
    ADHandleException;
end;

{-------------------------------------------------------------------------------}
procedure TADScriptFormEnv.DoCommandError(E: Exception);
begin
  ADHandleException;
end;

{-------------------------------------------------------------------------------}
procedure TADScriptFormEnv.DoCommandChanged;
begin
  with FFrm do begin
    sbMain.Panels[1].Text := 'Delimiter: ' + '[' + FExec.SQLDelimiter + ']';
    if not FExec.EOF then begin
      mmScript.CaretPos := FExec.CurrentPosition;
      sbMain.Panels[2].Text := Format('Position: %d, %d',
        [FExec.CurrentPosition.X, FExec.CurrentPosition.Y]);
    end
    else begin
      mmScript.SelStart := mmScript.GetTextLen;
      sbMain.Panels[2].Text := 'Position: EOF';
    end
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADScriptFormEnv.DoLog(const AMsg: String; ANewLine: Boolean);
begin
  with FFrm.mmLog do begin
    if FNewLine then
      Lines.Add(AMsg)
    else
      Lines[Lines.Count - 1] := Lines[Lines.Count - 1] + AMsg;
    Hint := FFrm.FExec.Command.Text;
  end;
  FNewLine := ANewLine;
  Application.ProcessMessages;
end;

{-------------------------------------------------------------------------------}
procedure TADScriptFormEnv.DoCheckUpdateScriptAndPos;
begin
  with FFrm do begin
    if mmScript.Modified then begin
      mmScript.Modified := False;
      FExec.AssignStrings(mmScript.Lines);
    end;
    FExec.CurrentPosition := mmScript.CaretPos;
  end;
end;

{-------------------------------------------------------------------------------}
{ TfrmExecGUIMain                                                               }
{-------------------------------------------------------------------------------}
procedure TfrmExecGUIMain.SetExecutor(AExec: TADScriptExecutor);
var
  i: Integer;
begin
  FExec := AExec;
  FExec.Env := TADScriptFormEnv.Create(Self);
  FExec.Init;

  cbConnDef.Items.Clear;
  for i := 0 to ADPhysManager.ConnectionDefs.Count - 1 do
    cbConnDef.Items.Add(ADPhysManager.ConnectionDefs[i].Name);
  if FExec.ConnectionDef <> '' then
    cbConnDef.ItemIndex := cbConnDef.Items.IndexOf(FExec.ConnectionDef);
  if cbConnDef.ItemIndex >= 0 then
    cbConnDefChange(nil);
end;

{-------------------------------------------------------------------------------}
procedure TfrmExecGUIMain.FormCreate(Sender: TObject);
begin
  mmScript := TADGUIxFormsMemo.Create(Self);
  with mmScript do begin
    Parent := Panel5;
    Align := alClient;
    BevelInner := bvNone;
    BorderStyle := bsNone;
    Lines.Add('-- $DEFINE DELIMITER ;');
    Lines.Add('select * from {id Employees};');
    Lines.Add('select * from {id Categories}');
    ParentFont := False;
    ScrollBars := ssBoth;
    TabOrder := 0;
    OnKeyUp := mmScriptKeyUp;
    OnMouseUp := mmScriptMouseUp;
  end;
  mmScript.Modified := True;
end;

{-------------------------------------------------------------------------------}
procedure TfrmExecGUIMain.mmScriptKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  FExec.CurrentPosition := mmScript.CaretPos;
end;

{-------------------------------------------------------------------------------}
procedure TfrmExecGUIMain.mmScriptMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FExec.CurrentPosition := mmScript.CaretPos;
end;

{-------------------------------------------------------------------------------}
procedure TfrmExecGUIMain.cbConnDefChange(Sender: TObject);
var
  oMAIntf: IADMoniAdapter;
  i: Integer;
  sName: String;
  vValue: Variant;
  eKind: TADDebugMonitorAdapterItemKind;
begin
  if FExec.ConnectionDef <> cbConnDef.Text then begin
    FExec.ConnectionDef := cbConnDef.Text;
    FExec.Username := '';
    FExec.Password := '';
  end;
  FExec.LoginPrompt := (FExec.Username = '');
  if FExec.Connect then begin
    sbMain.Panels[0].Text := 'Connected to ' + cbConnDef.Text;
    oMAIntf := FExec.ConnIntf as IADMoniAdapter;
    mmLog.Lines.Add('Connection info:');
    for i := 0 to oMAIntf.ItemCount - 1 do begin
      oMAIntf.GetItem(i, sName, vValue, eKind);
      if eKind in [ikClientInfo, ikSessionInfo] then
        mmLog.Lines.Add(sName + ' = ' + VarToStr(vValue));
    end;
    mmLog.Lines.Add('');
    mmScript.SetFocus;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TfrmExecGUIMain.acOpenScriptExecute(Sender: TObject);
begin
  if dlgOpen.Execute then begin
    mmLog.Clear;
    mmScript.Lines.LoadFromFile(dlgOpen.FileName);
    mmScript.SelStart := 0;
    mmScript.Modified := True;
    mmScript.SetFocus;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TfrmExecGUIMain.acSaveScriptUpdate(Sender: TObject);
begin
  acSaveScript.Enabled := mmScript.Lines.Count <> 0;
end;

{-------------------------------------------------------------------------------}
procedure TfrmExecGUIMain.acSaveScriptExecute(Sender: TObject);
begin
  if dlgSaveScript.Execute then
    mmScript.Lines.SaveToFile(dlgSaveScript.FileName);
end;

{-------------------------------------------------------------------------------}
procedure TfrmExecGUIMain.acSaveLogUpdate(Sender: TObject);
begin
  acSaveLog.Enabled := mmLog.Lines.Count <> 0;
end;

{-------------------------------------------------------------------------------}
procedure TfrmExecGUIMain.acSaveLogExecute(Sender: TObject);
begin
  if dlgSaveLog.Execute then
    mmLog.Lines.SaveToFile(dlgSaveLog.FileName);
end;

{-------------------------------------------------------------------------------}
procedure TfrmExecGUIMain.acExitExecute(Sender: TObject);
begin
  Close;
end;

{-------------------------------------------------------------------------------}
procedure TfrmExecGUIMain.acRunUpdate(Sender: TObject);
begin
  acRun.Enabled := FExec.Connected and not FExec.EOF;
end;

{-------------------------------------------------------------------------------}
procedure TfrmExecGUIMain.acRunExecute(Sender: TObject);
begin
  mmScript.CaretPos := Point(0, 0);
  FExec.RunScript;
  if FExec.Errors = 0 then
    sbMain.Panels[0].Text := 'Done.'
  else
    sbMain.Panels[0].Text := 'Done with errors.';
end;

{-------------------------------------------------------------------------------}
procedure TfrmExecGUIMain.acRunByStepUpdate(Sender: TObject);
begin
  acRunByStep.Enabled := FExec.Connected and not FExec.EOF;
end;

{-------------------------------------------------------------------------------}
procedure TfrmExecGUIMain.acRunByStepExecute(Sender: TObject);
var
  rPos: TPoint;
begin
  rPos := mmScript.CaretPos;
  if not FExec.EOF and (FExec.Command.Count = 0) then
    FExec.NextCommand;
  FExec.RunCommand;
  if FExec.Errors = 0 then
    sbMain.Panels[0].Text := 'Done.'
  else begin
    mmScript.CaretPos := rPos;
    sbMain.Panels[0].Text := 'Done with errors.';
  end;
end;

{-------------------------------------------------------------------------------}
procedure TfrmExecGUIMain.acSkipStepUpdate(Sender: TObject);
begin
  acSkipStep.Enabled := not FExec.EOF;
end;

{-------------------------------------------------------------------------------}
procedure TfrmExecGUIMain.acSkipStepExecute(Sender: TObject);
begin
  FExec.NextCommand;
end;

{-------------------------------------------------------------------------------}
procedure TfrmExecGUIMain.acContinueOnErrorUpdate(Sender: TObject);
begin
  acContinueOnError.Checked := FExec.ContinueOnError;
end;

{-------------------------------------------------------------------------------}
procedure TfrmExecGUIMain.acContinueOnErrorExecute(Sender: TObject);
begin
  FExec.ContinueOnError := not acContinueOnError.Checked;
end;

{-------------------------------------------------------------------------------}
procedure TfrmExecGUIMain.acDropNonexistObjUpdate(Sender: TObject);
begin
  acDropNonexistObj.Checked := FExec.DropNonexistObj;
end;

{-------------------------------------------------------------------------------}
procedure TfrmExecGUIMain.acDropNonexistObjExecute(Sender: TObject);
begin
  FExec.DropNonexistObj := not acDropNonexistObj.Checked;
end;

{-------------------------------------------------------------------------------}
procedure TfrmExecGUIMain.acShowMessagesUpdate(Sender: TObject);
begin
  acShowMessages.Checked := FExec.ShowMessages;
end;

{-------------------------------------------------------------------------------}
procedure TfrmExecGUIMain.acShowMessagesExecute(Sender: TObject);
begin
  FExec.ShowMessages := not acShowMessages.Checked;
end;

{-------------------------------------------------------------------------------}
procedure TfrmExecGUIMain.acAboutExecute(Sender: TObject);
begin
  TfrmADGUIxFormsAbout.Execute;
end;

end.
