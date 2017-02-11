{ --------------------------------------------------------------------------- }
{ AnyDAC Explorer ConnectionDef related classes and property page             }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I daAD.inc}

unit fConnDefDesc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Menus, Grids, DBGrids, Buttons, ExtCtrls, IniFiles, DB,
  daADStanIntf, daADDatSManager, daADStanParam, daADStanError,
  daADPhysIntf,
  daADGUIxFormsfConnEdit,
  daADDAptIntf,
  daADCompDataSet, daADCompClient, daADStanOption,
  fDbDesc, fExplorer, fBaseDesc, fDbObjDesc, daADGUIxFormsControls;

type
  {-----------------------------------------------------------------------------}
  TADConnectionDefNode = class(TADDbObjNode)
  private
    FConnection: TADCustomConnection;
    FConnectionDef: IADStanConnectionDef;
  protected
    function GetStatus: TADExplorerNodeStatuses; override;
    function GetTemplateName: String; override;
    function GetConnection: TADCustomConnection; override;
    function GetConnectionDef: IADStanConnectionDef; override;
  public
    constructor Create(AConnectionDef: IADStanConnectionDef);
    destructor Destroy; override;
    function CreateExpander: TADExplorerNodeExpander; override;
    function CreateFrame: TFrame; override;
    procedure Open; override;
    procedure Close; override;
    procedure Apply; override;
    procedure Delete; override;
    procedure Cancel; override;
  end;

  {-----------------------------------------------------------------------------}
  TfrmConnectionDefDesc = class(TfrmDbDesc)
    tsConnectionInfo: TTabSheet;
    Panel3: TADGUIxFormsPanel;
    mmInfo: TMemo;
    pnlInfoSubTitle: TADGUIxFormsPanel;
    procedure pcMainChange(Sender: TObject);
  private
    FConnectionTS: TTabSheet;
    FAdvansedTS: TTabSheet;
    procedure Modified(ASender: TObject);
    procedure FillConnectionInfo;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LoadData; override;
    procedure PostChanges; override;
    procedure SaveData; override;
    procedure UpdateReadOnly; override;
    procedure ResetState(AClear: Boolean); override;
    procedure ResetPageData; override;
    function RunWizard: Boolean; override;
    procedure Test; override;
  end;

implementation

{$R *.DFM}

uses
{$IFDEF AnyDAC_D6}
  Variants,
{$ENDIF}
  DBCtrls,
  daADStanConst;

{-----------------------------------------------------------------------------}
{ TADConnectionDefNode                                                        }
{-----------------------------------------------------------------------------}
constructor TADConnectionDefNode.Create(AConnectionDef: IADStanConnectionDef);
begin
  inherited Create;
  FObjectName := AConnectionDef.Name;
  FImageIndex := 1;
  FConnectionDef := AConnectionDef;
  FStatus := [nsEditable, nsNameEditable, nsDataEditable, nsSettingsInvalidate,
    nsParentInsertable, nsTest];
  Include(FStatus, nsExpandable);
end;

{-----------------------------------------------------------------------------}
destructor TADConnectionDefNode.Destroy;
begin
  Close;
  inherited Destroy;
end;

{-----------------------------------------------------------------------------}
function TADConnectionDefNode.GetConnectionDef: IADStanConnectionDef;
begin
  Result := FConnectionDef;
end;

{-----------------------------------------------------------------------------}
function TADConnectionDefNode.GetConnection: TADCustomConnection;
begin
  Result := FConnection;
end;

{-----------------------------------------------------------------------------}
function TADConnectionDefNode.CreateExpander: TADExplorerNodeExpander;
begin
  Open;
  if FADExplorerWithSQL then
    Result := inherited CreateExpander
  else
    Result := nil;
end;

{-----------------------------------------------------------------------------}
function TADConnectionDefNode.CreateFrame: TFrame;
begin
  Result := TfrmConnectionDefDesc.Create(nil);
end;

{-----------------------------------------------------------------------------}
function TADConnectionDefNode.GetStatus: TADExplorerNodeStatuses;
var
  oDrv: IADPhysDriver;
  oWizard: IADPhysDriverConnectionWizard;
begin
  Result := inherited GetStatus;
  try
    ADPhysManager.CreateDriver(FConnectionDef.DriverID, oDrv);
    oDrv.CreateConnectionWizard(oWizard);
    if oWizard <> nil then
      Result := Result + [nsWizard];
  except
  end;
  if (FConnection <> nil) and FConnection.Connected then
    Result := Result + [nsActive]
  else
    Result := Result + [nsInactive];
end;

{-----------------------------------------------------------------------------}
procedure TADConnectionDefNode.Open;
begin
  if FConnection = nil then
    try
      FConnection := TADConnection(ADManager.OpenConnection(FConnectionDef.Name));
    except
      on E: EADException do
        if E.ADCode = er_AD_ClntDbLoginAborted then
          Abort
        else
          raise;
    end;
end;

{-----------------------------------------------------------------------------}
procedure TADConnectionDefNode.Close;
var
  prevKeepConnection: Boolean;
begin
  if FConnection <> nil then begin
    FConnection.CloseClients;
    prevKeepConnection := FConnection.KeepConnection;
    FConnection.KeepConnection := False;
    try
      ADManager.CloseConnection(FConnection);
    finally
      if FConnection <> nil then
        FConnection.KeepConnection := prevKeepConnection;
    end;
    FConnection := nil;
  end;
end;

{-----------------------------------------------------------------------------}
function TADConnectionDefNode.GetTemplateName: String;
begin
  Result := 'ConnectionDef';
end;

{-----------------------------------------------------------------------------}
procedure TADConnectionDefNode.Apply;
begin
  FConnectionDef.Name := ObjectName;
  FConnectionDef.Apply;
end;

{-----------------------------------------------------------------------------}
procedure TADConnectionDefNode.Delete;
begin
  if FConnectionDef.State = asAdded then
    FConnectionDef.Delete
  else begin
    FConnectionDef.Delete;
    FConnectionDef.Apply;
  end;
end;

{-----------------------------------------------------------------------------}
procedure TADConnectionDefNode.Cancel;
begin
  FConnectionDef.Cancel;
  ObjectName := FConnectionDef.Name;
end;

{-----------------------------------------------------------------------------}
{ TfrmConnectionDefDesc                                                       }
{-----------------------------------------------------------------------------}
constructor TfrmConnectionDefDesc.Create(AOwner: TComponent);
begin
  inherited Create(nil);
  if frmADGUIxFormsConnEdit = nil then
    frmADGUIxFormsConnEdit := TfrmADGUIxFormsConnEdit.CreateForConnectionDefEditor;
  frmADGUIxFormsConnEdit.OnModified := Modified;
  FConnectionTS := frmADGUIxFormsConnEdit.PageControl.Pages[0];
  FAdvansedTS := frmADGUIxFormsConnEdit.PageControl.Pages[1];
  FConnectionTS.PageControl := pcMain;
  FConnectionTS.PageIndex := 0;
  FAdvansedTS.PageControl := pcMain;
  FAdvansedTS.PageIndex := 1;
  tsSQL.TabVisible := False;
  tsConnectionInfo.TabVisible := True;
  pcMain.ActivePage := FConnectionTS;
end;

{-----------------------------------------------------------------------------}
destructor TfrmConnectionDefDesc.Destroy;
begin
  FConnectionTS.PageControl := frmADGUIxFormsConnEdit.PageControl;
  FAdvansedTS.PageControl := frmADGUIxFormsConnEdit.PageControl;
  frmADGUIxFormsConnEdit.ResetState(True);
  frmADGUIxFormsConnEdit.Visible := False;
  frmADGUIxFormsConnEdit.Parent := nil;
  inherited Destroy;
end;

{-----------------------------------------------------------------------------}
procedure TfrmConnectionDefDesc.Modified(ASender: TObject);
begin
  FModified := True;
end;

{-----------------------------------------------------------------------------}
procedure TfrmConnectionDefDesc.LoadData;
begin
  frmADGUIxFormsConnEdit.LoadData(FExplNode.ConnectionDef);
  inherited LoadData;
end;

{-----------------------------------------------------------------------------}
procedure TfrmConnectionDefDesc.PostChanges;
begin
  frmADGUIxFormsConnEdit.PostChanges;
end;

{-----------------------------------------------------------------------------}
procedure TfrmConnectionDefDesc.SaveData;
begin
  inherited SaveData;
  frmADGUIxFormsConnEdit.SaveData;
end;

{-----------------------------------------------------------------------------}
procedure TfrmConnectionDefDesc.UpdateReadOnly;
begin
  if FADExplorerWithSQL then
    tsSQL.TabVisible := ReadOnly;
  pcMain.ActivePage := FConnectionTS;
  frmADGUIxFormsConnEdit.SetReadOnly(ReadOnly);
end;

{-----------------------------------------------------------------------------}
procedure TfrmConnectionDefDesc.ResetState(AClear: Boolean);
begin
  frmADGUIxFormsConnEdit.ResetState(AClear);
  mmSQL.Lines.Clear;
  inherited ResetState(AClear);
  UpdateReadOnly;
end;

{-----------------------------------------------------------------------------}
procedure TfrmConnectionDefDesc.ResetPageData;
begin
  if not ExplNode.Explorer.Confirmations or
     (MessageDlg('Current page options will reset to default values. Do you want ?',
                 mtConfirmation, mbOKCancel, -1) = mrOK) then
    frmADGUIxFormsConnEdit.ResetPage;
end;

{-----------------------------------------------------------------------------}
function TfrmConnectionDefDesc.RunWizard: Boolean;
var
  oDrv: IADPhysDriver;
  oWizard: IADPhysDriverConnectionWizard;
begin
  Result := False;
  SaveData;
  ADPhysManager.CreateDriver(TADConnectionDefNode(ExplNode).FConnectionDef.DriverID, oDrv);
  oDrv.CreateConnectionWizard(oWizard);
  if (oWizard <> nil) and oWizard.Run(TADConnectionDefNode(ExplNode).FConnectionDef) then begin
    LoadData;
    Result := True;
  end;
end;

{-----------------------------------------------------------------------------}
procedure TfrmConnectionDefDesc.Test;
begin
  frmADGUIxFormsConnEdit.TestConnection;
end;

{-----------------------------------------------------------------------------}
procedure TfrmConnectionDefDesc.pcMainChange(Sender: TObject);
begin
  inherited pcMainChange(Sender);
  if pcMain.ActivePage = tsConnectionInfo then
    FillConnectionInfo;
end;

{-----------------------------------------------------------------------------}
procedure TfrmConnectionDefDesc.FillConnectionInfo;
var
  oMAIntf: IADMoniAdapter;
  i: Integer;
  sName: String;
  vValue: Variant;
  eKind: TADDebugMonitorAdapterItemKind;
  oConn: TADCustomConnection;
  oConnIntf: IADPhysConnection;
begin
  Screen.Cursor := crSQLWait;
  try
    mmInfo.Lines.Clear;
    oConn := ADManager.FindConnection(TADConnectionDefNode(ExplNode).FConnectionDef.Name);
    if (oConn <> nil) and (oConn.ConnectionIntf <> nil) then
      oConnIntf := oConn.ConnectionIntf
    else
      ADPhysManager.CreateConnection(TADConnectionDefNode(ExplNode).FConnectionDef, oConnIntf);
    if oConnIntf <> nil then begin
      mmInfo.Lines.Add('================================');
      mmInfo.Lines.Add('Connection definition parameters');
      mmInfo.Lines.Add('================================');
      mmInfo.Lines.AddStrings(TADConnectionDefNode(ExplNode).FConnectionDef.Params);
      oMAIntf := oConnIntf as IADMoniAdapter;
      mmInfo.Lines.Add('================================');
      mmInfo.Lines.Add('Client info');
      mmInfo.Lines.Add('================================');
      for i := 0 to oMAIntf.ItemCount - 1 do begin
        oMAIntf.GetItem(i, sName, vValue, eKind);
        if eKind = ikClientInfo then
          mmInfo.Lines.Add(sName + ' = ' + VarToStr(vValue));
      end;
      if oConnIntf.State = csConnected then begin
        mmInfo.Lines.Add('================================');
        mmInfo.Lines.Add('Session info');
        mmInfo.Lines.Add('================================');
        for i := 0 to oMAIntf.ItemCount - 1 do begin
          oMAIntf.GetItem(i, sName, vValue, eKind);
          if eKind = ikSessionInfo then
            mmInfo.Lines.Add(sName + ' = ' + VarToStr(vValue));
        end;
      end;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

end.
