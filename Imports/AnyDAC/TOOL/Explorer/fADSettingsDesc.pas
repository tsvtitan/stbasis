{ --------------------------------------------------------------------------- }
{ AnyDAC Explorer AnyDACDef related classes and property page                 }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I daAD.inc}

unit fADSettingsDesc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, fBaseDesc, StdCtrls, ExtCtrls,
  daADStanIntf,
  daADGUIxFormsControls,
  fExplorer;

type
  {---------------------------------------------------------------------------}
  TADSettingsNode = class(TADExplorerNode)
  private
    FSettingsDef: IADStanConnectionDef;
  public
    constructor Create(const ASettingsDef: IADStanConnectionDef);
    destructor Destroy; override;
    function CreateExpander: TADExplorerNodeExpander; override;
    function CreateFrame: TFrame; override;
    procedure Apply; override;
    procedure Cancel; override;
  end;

  {---------------------------------------------------------------------------}
  TfrmADSettingsDesc = class(TfrmBaseDesc)
    cbMoniInDelphiIDE: TCheckBox;
    GroupBox1: TGroupBox;
    cbMoniLiveCycle: TCheckBox;
    cbMoniError: TCheckBox;
    cbMoniConnection: TCheckBox;
    cbMoniTransaction: TCheckBox;
    cbMoniService: TCheckBox;
    cbMoniPrepare: TCheckBox;
    cbMoniExecute: TCheckBox;
    cbMoniDataIn: TCheckBox;
    cbMoniDataOut: TCheckBox;
    cbMoniUpdate: TCheckBox;
    cbMoniVendor: TCheckBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    GroupBox3: TGroupBox;
    Label4: TLabel;
    edtMoniHost: TEdit;
    edtMoniPort: TEdit;
    edtMoniTimeout: TEdit;
    edtMoniFileName: TEdit;
    cbMoniAppend: TCheckBox;
    pnlInstructionName: TADGUIxFormsPanel;
    Label5: TLabel;
    Panel7: TADGUIxFormsPanel;
  private
    FSettingsDef: IADStanConnectionDef;
  public
    procedure LoadData; override;
    procedure SaveData; override;
    procedure ResetPageData; override;
  end;

var
  frmADSettingsDesc: TfrmADSettingsDesc;

implementation

{$R *.dfm}

uses
  daADStanConst;

{-----------------------------------------------------------------------------}
{ TADSettingsNode                                                             }
{-----------------------------------------------------------------------------}
constructor TADSettingsNode.Create(const ASettingsDef: IADStanConnectionDef);
begin
  inherited Create;
  FSettingsDef := ASettingsDef;
  FObjectName := 'AnyDAC Settings';
  FImageIndex := 0;
  FStatus := [nsEditable, nsDataEditable];
end;

{-----------------------------------------------------------------------------}
destructor TADSettingsNode.Destroy;
begin
  Close;
  inherited Destroy;
end;

{-----------------------------------------------------------------------------}
function TADSettingsNode.CreateExpander: TADExplorerNodeExpander;
begin
  Result := nil;
end;

{-----------------------------------------------------------------------------}
function TADSettingsNode.CreateFrame: TFrame;
begin
  Result := TfrmADSettingsDesc.Create(nil);
end;

{-----------------------------------------------------------------------------}
procedure TADSettingsNode.Apply;
begin
  FSettingsDef.Apply;
end;

{-----------------------------------------------------------------------------}
procedure TADSettingsNode.Cancel;
begin
  FSettingsDef.Cancel;
end;

{-----------------------------------------------------------------------------}
{ TfrmADSettingsDesc                                                          }
{-----------------------------------------------------------------------------}
procedure TfrmADSettingsDesc.SaveData;
var
  eEvents: TADMoniEventKinds;
begin
  inherited SaveData;
  if FSettingsDef = nil then begin
    FSettingsDef := FExplNode.ConnectionDefs.AddConnectionDef;
    FSettingsDef.Name := S_AD_ConnParam_Common_Settings;
    FSettingsDef.MarkPersistent;
  end;
  FSettingsDef.AsBoolean[S_AD_MoniInIDE] := cbMoniInDelphiIDE.Checked;
  eEvents := [];
  if cbMoniLiveCycle.Checked then
    Include(eEvents, ekLiveCycle);
  if cbMoniError.Checked then
    Include(eEvents, ekError);
  if cbMoniConnection.Checked then
    Include(eEvents, ekConnConnect);
  if cbMoniTransaction.Checked then
    Include(eEvents, ekConnTransact);
  if cbMoniService.Checked then
    Include(eEvents, ekConnService);
  if cbMoniPrepare.Checked then
    Include(eEvents, ekCmdPrepare);
  if cbMoniExecute.Checked then
    Include(eEvents, ekCmdExecute);
  if cbMoniDataIn.Checked then
    Include(eEvents, ekCmdDataIn);
  if cbMoniDataOut.Checked then
    Include(eEvents, ekCmdDataOut);
  if cbMoniUpdate.Checked then
    Include(eEvents, ekAdaptUpdate);
  if cbMoniVendor.Checked then
    Include(eEvents, ekVendor);
  FSettingsDef.AsInteger[S_AD_MoniCategories] := PWord(@eEvents)^;
  FSettingsDef.AsString[S_AD_MoniIndyHost] := edtMoniHost.Text;
  FSettingsDef.AsString[S_AD_MoniIndyPort] := edtMoniPort.Text;
  FSettingsDef.AsString[S_AD_MoniIndyTimeout] := edtMoniTimeout.Text;
  FSettingsDef.AsString[S_AD_MoniFlatFileName] := edtMoniFileName.Text;
  FSettingsDef.AsBoolean[S_AD_MoniFlatFileAppend] := cbMoniAppend.Checked;
end;

{-----------------------------------------------------------------------------}
procedure TfrmADSettingsDesc.LoadData;
var
  eEvents: TADMoniEventKinds;
  iEvents: Integer;
begin
  FSettingsDef := FExplNode.ConnectionDefs.FindConnectionDef(S_AD_ConnParam_Common_Settings);
  if (FSettingsDef <> nil) and FSettingsDef.HasValue(S_AD_MoniInIDE) then
    cbMoniInDelphiIDE.Checked := FSettingsDef.AsBoolean[S_AD_MoniInIDE]
  else
    cbMoniInDelphiIDE.Checked := True;
  if (FSettingsDef <> nil) and FSettingsDef.HasValue(S_AD_MoniCategories) then begin
    iEvents := FSettingsDef.AsInteger[S_AD_MoniCategories];
    eEvents := PADMoniEventKinds(@iEvents)^;
    cbMoniLiveCycle.Checked := ekLiveCycle in eEvents;
    cbMoniError.Checked := ekError in eEvents;
    cbMoniConnection.Checked := ekConnConnect in eEvents;
    cbMoniTransaction.Checked := ekConnTransact in eEvents;
    cbMoniService.Checked := ekConnService in eEvents;
    cbMoniPrepare.Checked := ekCmdPrepare in eEvents;
    cbMoniExecute.Checked := ekCmdExecute in eEvents;
    cbMoniDataIn.Checked := ekCmdDataIn in eEvents;
    cbMoniDataOut.Checked := ekCmdDataOut in eEvents;
    cbMoniUpdate.Checked := ekAdaptUpdate in eEvents;
    cbMoniVendor.Checked := ekVendor in eEvents;
  end
  else begin
    cbMoniLiveCycle.Checked := True;
    cbMoniError.Checked := True;
    cbMoniConnection.Checked := True;
    cbMoniTransaction.Checked := True;
    cbMoniService.Checked := True;
    cbMoniPrepare.Checked := True;
    cbMoniExecute.Checked := True;
    cbMoniDataIn.Checked := True;
    cbMoniDataOut.Checked := True;
    cbMoniUpdate.Checked := True;
    cbMoniVendor.Checked := True;
  end;
  if (FSettingsDef <> nil) and FSettingsDef.HasValue(S_AD_MoniIndyHost) then
    edtMoniHost.Text := FSettingsDef.AsString[S_AD_MoniIndyHost]
  else
    edtMoniHost.Text := 'localhost';
  if (FSettingsDef <> nil) and FSettingsDef.HasValue(S_AD_MoniIndyPort) then
    edtMoniPort.Text := FSettingsDef.AsString[S_AD_MoniIndyPort]
  else
    edtMoniPort.Text := IntToStr(C_AD_MonitorPort);
  if (FSettingsDef <> nil) and FSettingsDef.HasValue(S_AD_MoniIndyTimeout) then
    edtMoniTimeout.Text := FSettingsDef.AsString[S_AD_MoniIndyTimeout]
  else
    edtMoniTimeout.Text := IntToStr(C_AD_MonitorTimeout);
  if (FSettingsDef <> nil) and FSettingsDef.HasValue(S_AD_MoniFlatFileName) then
    edtMoniFileName.Text := FSettingsDef.AsString[S_AD_MoniFlatFileName]
  else
    edtMoniFileName.Text := C_AD_MonitorFileName;
  if (FSettingsDef <> nil) and FSettingsDef.HasValue(S_AD_MoniFlatFileAppend) then
    cbMoniAppend.Checked := FSettingsDef.AsBoolean[S_AD_MoniFlatFileAppend]
  else
    cbMoniAppend.Checked := C_AD_MonitorAppend;
  inherited LoadData;
end;

{-----------------------------------------------------------------------------}
procedure TfrmADSettingsDesc.ResetPageData;
begin
  cbMoniInDelphiIDE.Checked := True;
  cbMoniLiveCycle.Checked := True;
  cbMoniError.Checked := True;
  cbMoniConnection.Checked := True;
  cbMoniTransaction.Checked := True;
  cbMoniService.Checked := True;
  cbMoniPrepare.Checked := True;
  cbMoniExecute.Checked := True;
  cbMoniDataIn.Checked := True;
  cbMoniDataOut.Checked := True;
  cbMoniUpdate.Checked := True;
  cbMoniVendor.Checked := True;
  edtMoniHost.Text := 'localhost';
  edtMoniPort.Text := IntToStr(C_AD_MonitorPort);
  edtMoniTimeout.Text := IntToStr(C_AD_MonitorTimeout);
  edtMoniFileName.Text := C_AD_MonitorFileName;
  cbMoniAppend.Checked := C_AD_MonitorAppend;
  CtrlChange(nil);
end;

end.
