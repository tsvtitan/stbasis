{ --------------------------------------------------------------------------- }
{ AnyDAC Explorer tree root related classes and property page                 }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I daAD.inc}

unit fRootDesc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    StdCtrls, Buttons, Menus, ExtCtrls,
  daADStanIntf,
  daADCompClient,
  daADGUIxFormsControls,
  fBaseDesc, fExplorer;

type
  {---------------------------------------------------------------------------}
  TADRootNode = class(TADExplorerNode)
  private
    FExplorer: TfrmExplorer;
    FFileName: String;
    FDefaultFile: Boolean;
  protected
    function GetStatus: TADExplorerNodeStatuses; override;
    function GetConnectionDefs: IADStanConnectionDefs; override;
    function GetExplorer: TfrmExplorer; override;
  public
    constructor Create(AExplorer: TfrmExplorer);
    destructor Destroy; override;
    function CreateExpander: TADExplorerNodeExpander; override;
    function CreateSubNode: TADExplorerNode; override;
    function CreateFrame: TFrame; override;
    procedure Open; override;
    procedure Close; override;
    procedure Apply; override;
    procedure Cancel; override;
    property FileName: String read FFileName;
    property DefaultFile: Boolean read FDefaultFile;
  end;

  {---------------------------------------------------------------------------}
  TADRootNodeExpander = class(TADExplorerNodeExpander)
  private
    FConnectionDefIndex: Integer;
  public
    constructor Create(ANode: TADExplorerNode); override;
    function Next: TADExplorerNode; override;
  end;

  {---------------------------------------------------------------------------}
  TfrmRootDesc = class(TfrmBaseDesc)
    edtFileName: TEdit;
    Label2: TLabel;
    SpeedButton1: TSpeedButton;
    odConnectionDefStorage: TOpenDialog;
    cbDefaultFile: TCheckBox;
    pnlInstructionName: TADGUIxFormsPanel;
    Label1: TLabel;
    Panel7: TADGUIxFormsPanel;
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LoadData; override;
    procedure SaveData; override;
    procedure ResetPageData; override;
    procedure UpdateReadOnly; override;
  end;

var
  frmRootDesc: TfrmRootDesc;

implementation

Uses
  fConnDefDesc, fADSettingsDesc,
  daADStanConst, daADStanUtil, daADStanDef,
  daADPhysIntf;

{$R *.DFM}

{-----------------------------------------------------------------------------}
{ TADRootNode                                                                 }
{-----------------------------------------------------------------------------}
constructor TADRootNode.Create(AExplorer: TfrmExplorer);
begin
  inherited Create;
  FObjectName := 'Connections';
  FImageIndex := 0;
  FExplorer := AExplorer;
  FFileName := ADManager.ConnectionDefFileName;
  FDefaultFile := (AnsiCompareText(FFileName, ADExpandStr(ADLoadConnDefGlobalFileName())) = 0);
  FStatus := [nsExpandable, nsInsertable, nsEditable, nsDataEditable];
end;

{-----------------------------------------------------------------------------}
destructor TADRootNode.Destroy;
begin
  Close;
  inherited Destroy;
end;

{-----------------------------------------------------------------------------}
function TADRootNode.GetConnectionDefs: IADStanConnectionDefs;
begin
  Result := ADManager.ConnectionDefs;
end;

{-----------------------------------------------------------------------------}
function TADRootNode.GetExplorer: TfrmExplorer;
begin
  Result := FExplorer;
end;

{-----------------------------------------------------------------------------}
function TADRootNode.CreateSubNode: TADExplorerNode;
var
  oConnectionDef: IADStanConnectionDef;
begin
  oConnectionDef := ADManager.ConnectionDefs.AddConnectionDef;
{$IFDEF AnyDAC_D6}
  {$IFDEF AnyDAC_D11}
  oConnectionDef.DriverID := S_AD_TDBXId;
  {$ELSE}
  oConnectionDef.DriverID := S_AD_DBXId;
  {$ENDIF}
{$ENDIF}
  oConnectionDef.MarkPersistent;
  Result := TADConnectionDefNode.Create(oConnectionDef);
end;

{-----------------------------------------------------------------------------}
function TADRootNode.CreateExpander: TADExplorerNodeExpander;
begin
  Open;
  Result := TADRootNodeExpander.Create(Self);
end;

{-----------------------------------------------------------------------------}
function TADRootNode.CreateFrame: TFrame;
begin
  Result := TfrmRootDesc.Create(nil);
end;

{-----------------------------------------------------------------------------}
function TADRootNode.GetStatus: TADExplorerNodeStatuses;
begin
  Result := inherited GetStatus;
  if ADManager.Active then
    Result := Result + [nsActive]
  else
    Result := Result + [nsInactive];
end;

{-----------------------------------------------------------------------------}
procedure TADRootNode.Open;
var
  i: Integer;
begin
  with ADManager do begin
    if ConnectionDefFileName <> FFileName then begin
      Active := False;
      ConnectionDefFileName := FFileName;
    end;
    Active := True;
    FFileName := ConnectionDefFileName;
    i := Pos(' - ', FExplorer.Caption);
    if i <> 0 then
      FExplorer.Caption := Copy(FExplorer.Caption, 1, i - 1);
    FExplorer.Caption := FExplorer.Caption + ' - ' + FFileName;
  end;
end;

{-----------------------------------------------------------------------------}
procedure TADRootNode.Close;
var
  i: Integer;
begin
  ADManager.Active := False;
  for i := 0 to 10 do begin
    if ADManager.State = dmsInactive then
      Break;
    Sleep(100);
  end;
  i := Pos(' - ', FExplorer.Caption);
  if i <> 0 then
    FExplorer.Caption := Copy(FExplorer.Caption, 1, i - 1);
end;

{-----------------------------------------------------------------------------}
procedure TADRootNode.Apply;
begin
  with ADManager do
    if ConnectionDefFileName <> FFileName then begin
      Active := False;
      ConnectionDefFileName := FFileName;
    end;
  if FDefaultFile then
    ADSaveConnDefGlobalFileName(FFileName);
end;

{-----------------------------------------------------------------------------}
procedure TADRootNode.Cancel;
begin
  FFileName := ADManager.ConnectionDefFileName;
  FDefaultFile := (AnsiCompareText(FFileName, ADLoadConnDefGlobalFileName()) = 0);
end;

{-----------------------------------------------------------------------------}
{ TADRootNodeExpander                                                         }
{-----------------------------------------------------------------------------}
constructor TADRootNodeExpander.Create(ANode: TADExplorerNode);
begin
  inherited Create(ANode);
  FConnectionDefIndex := 0;
end;

{-----------------------------------------------------------------------------}
function TADRootNodeExpander.Next: TADExplorerNode;
begin
  with TADRootNode(Node) do
    if FConnectionDefIndex > ADManager.ConnectionDefs.Count then
      Result := nil
    else if FConnectionDefIndex = 0 then begin
      Result := TADSettingsNode.Create(ADManager.ConnectionDefs.FindConnectionDef(S_AD_ConnParam_Common_Settings));
      Inc(FConnectionDefIndex);
    end
    else begin
      Result := TADConnectionDefNode.Create(ADManager.ConnectionDefs.Items[FConnectionDefIndex - 1]);
      Result.ObjectName := ADManager.ConnectionDefs.Items[FConnectionDefIndex - 1].Name;
      Inc(FConnectionDefIndex);
    end;
end;

{-----------------------------------------------------------------------------}
{ TfrmRootDesc                                                                }
{-----------------------------------------------------------------------------}
procedure TfrmRootDesc.SaveData;
begin
  inherited SaveData;
  with FExplNode as TADRootNode do begin
    FFileName := Trim(edtFileName.Text);
    FDefaultFile := cbDefaultFile.Checked;
  end;
end;

{-----------------------------------------------------------------------------}
procedure TfrmRootDesc.LoadData;
begin
  with FExplNode as TADRootNode do begin
    edtFileName.Text := FFileName;
    cbDefaultFile.Checked := FDefaultFile;
  end;
  inherited LoadData;
  if edtFileName.Text = '' then begin
    ShowMessage('AnyDAC Explorer have not found connection definition file.'#13#10 +
                'You should create new one ! Please enter it name into "File Name" box.');
    edtFileName.SetFocus;
  end;
end;

{-----------------------------------------------------------------------------}
procedure TfrmRootDesc.UpdateReadOnly;
begin
  edtFileName.Enabled := not ReadOnly;
  SpeedButton1.Enabled := not ReadOnly;
  cbDefaultFile.Enabled := not ReadOnly;
end;

{-----------------------------------------------------------------------------}
procedure TfrmRootDesc.SpeedButton1Click(Sender: TObject);
begin
  odConnectionDefStorage.FileName := edtFileName.Text;
  if odConnectionDefStorage.Execute then begin
    edtFileName.Text := odConnectionDefStorage.FileName;
    cbDefaultFile.Checked := (AnsiCompareText(edtFileName.Text,
      ADLoadConnDefGlobalFileName()) = 0);
    CtrlChange(nil);
  end;
end;

{-----------------------------------------------------------------------------}
procedure TfrmRootDesc.ResetPageData;
begin
  edtFileName.Text := ADGetSystemPath + '\' + S_AD_DefCfgFileName;
  cbDefaultFile.Checked := True;
  CtrlChange(nil);
end;

end.

