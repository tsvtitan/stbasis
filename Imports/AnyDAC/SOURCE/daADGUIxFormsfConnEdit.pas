{ --------------------------------------------------------------------------- }
{ AnyDAC TADConnection editor form                                            }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I daAD.inc}

unit daADGUIxFormsfConnEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, ExtCtrls,
    Grids, StdCtrls, ComCtrls, Registry,
  daADStanIntf, daADStanOption,
  daADPhysIntf,
  daADCompClient,
  daADGUIxFormsControls, daADGUIxFormsfUpdateOptions, daADGUIxFormsfFormatOptions,
    daADGUIxFormsfFetchOptions, daADGUIxFormsfResourceOptions,
  daADGUIxFormsfLogin;

type
  TfrmADGUIxFormsConnEdit = class(TForm)
    pnlButtons: TADGUIxFormsPanel;
    btnDefaults: TButton;
    btnTest: TButton;
    pnlMain: TADGUIxFormsPanel;
    pnlGray: TADGUIxFormsPanel;
    Panel1: TADGUIxFormsPanel;
    pcMain: TADGUIxFormsPageControl;
    tsConnection: TTabSheet;
    sgParams: TStringGrid;
    cbParams: TComboBox;
    edtParams: TEdit;
    pnlTitle: TADGUIxFormsPanel;
    Label1: TLabel;
    Label2: TLabel;
    cbServerID: TComboBox;
    cbConnectionDefName: TComboBox;
    Panel2: TADGUIxFormsPanel;
    Panel3: TADGUIxFormsPanel;
    tsAdvanced: TTabSheet;
    ptreeAdvanced: TADGUIxFormsPanelTree;
    frmFormatOptions: TfrmADGUIxFormsFormatOptions;
    frmFetchOptions: TfrmADGUIxFormsFetchOptions;
    frmUpdateOptions: TfrmADGUIxFormsUpdateOptions;
    frmResourceOptions: TfrmADGUIxFormsResourceOptions;
    btnOk: TButton;
    btnCancel: TButton;
    btnWizard: TButton;
    procedure btnWizardClick(Sender: TObject);
    procedure sgParamsSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure cbServerIDClick(Sender: TObject);
    procedure EditorExit(Sender: TObject);
    procedure sgParamsTopLeftChanged(Sender: TObject);
    procedure EditorKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure sgParamsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure sgParamsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cbConnectionDefNameClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure sgParamsDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure btnDefaultsClick(Sender: TObject);
    procedure frmOptionsModified(Sender: TObject);
    procedure cbParamsDblClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnTestClick(Sender: TObject);
  private
    { Private declarations }
    FDriverID: String;
    FConnectionDefName: String;
    FConnectionDef: IADStanConnectionDef;
    FDefaults, FResults, FEdited: TStrings;
    FFetchOptions: TADFetchOptions;
    FFormatOptions: TADFormatOptions;
    FUpdateOptions: TADUpdateOptions;
    FResourceOptions: TADResourceOptions;
    FOnModified: TNotifyEvent;
    FLockResize: Boolean;
    FLastGridWidth: Integer;
    FUseComboEdit: Boolean;
    function GetPageControl: TPageControl;
    procedure GetDriverParams(const ADrvID: String; AStrs: TStrings);
    procedure GetConnectionDefParams(const AConnectionDefName: String; AStrs: TStrings);
    procedure OverrideBy(AThis, AByThat: TStrings);
    procedure FillParamValues(AAsIs: Boolean);
    procedure FillParamGrids(AResetPosition: Boolean);
    procedure AdjustEditor(ACtrl: TWinControl; ACol, ARow: Integer);
    procedure FillConnParams(AParams: TStrings);
    procedure Modified;
    function IsDriverKnown(const ADrvID: String;
      out ADrvMeta: IADPhysDriverMetadata): Boolean;
    procedure ResetConnectionDef;
    procedure ResetFetchOpts;
    procedure ResetFormatOpts;
    procedure ResetResourceOpts;
    procedure ResetUpdateOpts;
    function GetGridWidth: Integer;
    function GetEditor: TWinControl;
{ TODO : To be implemented }
//  protected
//    procedure LoadFormState(AReg: TRegistry); override;
//    procedure SaveFormState(AReg: TRegistry); override;
  public
    { Public declarations }
    class function Execute(AConn: TADCustomConnection; const ACaption: String): Boolean; overload;
    class function Execute(var AConnStr: String; const ACaption: String): Boolean; overload;
    constructor CreateForConnectionDefEditor;
    destructor Destroy; override;
    procedure LoadData(AConnectionDef: IADStanConnectionDef);
    procedure PostChanges;
    procedure SaveData;
    procedure ResetState(AClear: Boolean);
    procedure ResetData;
    procedure ResetPage;
    procedure TestConnection;
    procedure SetReadOnly(AValue: Boolean);
    property LockResize: Boolean read FLockResize write FLockResize;
    property PageControl: TPageControl read GetPageControl;
    property OnModified: TNotifyEvent read FOnModified write FOnModified;
  end;

var
  frmADGUIxFormsConnEdit: TfrmADGUIxFormsConnEdit;

implementation

uses
{$IFDEF AnyDAC_D6}
  Types,
{$ENDIF}
  Graphics, DB, Dialogs,
  daADGUIxIntf, daADGUIxFormsUtil, daADStanResStrs;

{$R *.dfm}

type
  __TWinControl = class(TWinControl)
  end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsConnEdit.ResetConnectionDef;
begin
  GetEditor.Visible := False;
  FEdited.Clear;
  FillParamValues(True);
  FillParamGrids(True);
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsConnEdit.ResetFetchOpts;
var
  oFetchOptions: TADFetchOptions;
begin
  oFetchOptions := TADFetchOptions.Create(nil);
  try
    frmFetchOptions.LoadFrom(oFetchOptions);
  finally
    oFetchOptions.Free;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsConnEdit.ResetFormatOpts;
var
  oFormatOptions: TADFormatOptions;
begin
  oFormatOptions := TADFormatOptions.Create(nil);
  try
    frmFormatOptions.LoadFrom(oFormatOptions);
  finally
    oFormatOptions.Free;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsConnEdit.ResetUpdateOpts;
var
  oUpdateOptions: TADUpdateOptions;
begin
  oUpdateOptions := TADUpdateOptions.Create(nil);
  try
    frmUpdateOptions.LoadFrom(oUpdateOptions);
  finally
    oUpdateOptions.Free;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsConnEdit.ResetResourceOpts;
var
  oResourceOptions: TADResourceOptions;
begin
  oResourceOptions := TADResourceOptions.Create(nil);
  try
    frmResourceOptions.LoadFrom(oResourceOptions);
  finally
    oResourceOptions.Free;
  end;
end;

{ --------------------------------------------------------------------------- }
function TfrmADGUIxFormsConnEdit.IsDriverKnown(const ADrvID: String;
  out ADrvMeta: IADPhysDriverMetadata): Boolean;
var
  i: Integer;
  oManMeta: IADPhysManagerMetadata;
begin
  Result := False;
  ADPhysManager.CreateMetadata(oManMeta);
  for i := 0 to oManMeta.DriverCount - 1 do
    if CompareText(oManMeta.DriverID[i], ADrvID) = 0 then begin
      oManMeta.CreateDriverMetadata(ADrvID, ADrvMeta);
      Result := True;
      Break;
    end;
end;

{ --------------------------------------------------------------------------- }
function TfrmADGUIxFormsConnEdit.GetPageControl: TPageControl;
begin
  Result := pcMain;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsConnEdit.GetDriverParams(const ADrvID: String;
  AStrs: TStrings);
var
  i, iLogin: Integer;
  sName, sType, sDefVal, sCaption: String;
  oDrvMeta: IADPhysDriverMetadata;
begin
  if IsDriverKnown(ADrvID, oDrvMeta) then
    for i := 0 to oDrvMeta.GetConnParamCount(AStrs) - 1 do begin
      oDrvMeta.GetConnParams(AStrs, i, sName, sType, sDefVal, sCaption, iLogin);
      AStrs.Add(sName + '=' + sDefVal);
    end;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsConnEdit.GetConnectionDefParams(const AConnectionDefName: String;
  AStrs: TStrings);
var
  oConnectionDef: IADStanConnectionDef;
begin
  if FConnectionDef <> nil then
    oConnectionDef := FConnectionDef
  else
    oConnectionDef := ADManager.ConnectionDefs.ConnectionDefByName(AConnectionDefName);
  AStrs.AddStrings(oConnectionDef.Params);
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsConnEdit.OverrideBy(AThis, AByThat: TStrings);
var
  i: Integer;
  sKey, sValue: String;
begin
  for i := 0 to AByThat.Count - 1 do begin
    sKey := AByThat.Names[i];
    sValue := AByThat.Values[sKey];
    AThis.Values[sKey] := sValue;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsConnEdit.FillParamValues(AAsIs: Boolean);
var
  oStrs: TStringList;
begin
  oStrs := TStringList.Create;
  try
    FDefaults.Clear;
    if FDriverID <> '' then
      GetDriverParams(FDriverID, FDefaults);
    if FConnectionDefName <> '' then begin
      GetConnectionDefParams(FConnectionDefName, oStrs);
      OverrideBy(FDefaults, oStrs);
    end;
    FResults.Assign(FDefaults);
    if not AAsIs then
      OverrideBy(FResults, FEdited);
  finally
    oStrs.Free;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsConnEdit.FillConnParams(AParams: TStrings);
var
  i, j: Integer;
  lChanged: Boolean;
  sKey, sVal: String;
begin
  AParams.Clear;
  if FConnectionDef <> nil then
    AParams.Assign(FEdited)
  else
    for i := 0 to FEdited.Count - 1 do begin
      sKey := FEdited.Names[i];
      sVal := FEdited.Values[sKey];
      lChanged := False;
      for j := 1 to sgParams.RowCount - 1 do
        if AnsiCompareText(sgParams.Cells[0, j], sKey) = 0 then begin
          lChanged := True;
          Break;
        end;
      if lChanged then
        lChanged := FDefaults.Values[sKey] <> sVal;
      if lChanged then
        AParams.Add(sKey + '=' + sVal);
    end;
end;

{ --------------------------------------------------------------------------- }
function TfrmADGUIxFormsConnEdit.GetGridWidth: Integer;
begin
  Result := sgParams.ClientWidth - GetSystemMetrics(SM_CXVSCROLL) - 5;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsConnEdit.FormCreate(Sender: TObject);
var
  iBorderY, iBorderX: Integer;
begin
  iBorderY := GetSystemMetrics(SM_CYBORDER);
  iBorderX := GetSystemMetrics(SM_CXBORDER);
  sgParams.DefaultRowHeight := GetEditor.Height - iBorderY;
  FLastGridWidth := GetGridWidth;
  sgParams.ColWidths[0] := MulDiv(FLastGridWidth, 1, 3) - 2 * iBorderX;
  sgParams.ColWidths[1] := MulDiv(FLastGridWidth, 1, 3) - 2 * iBorderX;
  sgParams.ColWidths[2] := MulDiv(FLastGridWidth, 1, 3) - 2 * iBorderX;
  FDefaults := TStringList.Create;
  FResults := TStringList.Create;
  FEdited := TStringList.Create;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsConnEdit.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FDefaults);
  FreeAndNil(FResults);
  FreeAndNil(FEdited);
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsConnEdit.FillParamGrids(AResetPosition: Boolean);
var
  oDrvMeta: IADPhysDriverMetadata;
  i, iLogin: Integer;
  sName, sType, sDefVal, sCaption: String;
begin
  if not IsDriverKnown(FDriverID, oDrvMeta) then
    sgParams.RowCount := 2
  else begin
    sgParams.RowCount := oDrvMeta.GetConnParamCount(FResults) + 1;
    for i := 0 to sgParams.RowCount - 1 do begin
      oDrvMeta.GetConnParams(FResults, i, sName, sType, sDefVal, sCaption, iLogin);
      sgParams.Cells[0, i + 1] := sName;
      sgParams.Cells[1, i + 1] := FResults.Values[sName];
      sgParams.Cells[2, i + 1] := sDefVal;
    end;
  end;
  sgParams.Cells[0, 0] := S_AD_ParParameter;
  sgParams.Cells[1, 0] := S_AD_ParValue;
  sgParams.Cells[2, 0] := S_AD_ParDefault;
  sgParams.FixedRows := 1;
  if AResetPosition then begin
    if sgParams.RowCount > 2 then
      sgParams.Row := 2
    else
      sgParams.Row := 1;
    sgParams.Col := 1;
  end;
end;

{ --------------------------------------------------------------------------- }
function TfrmADGUIxFormsConnEdit.GetEditor: TWinControl;
begin
  if FUseComboEdit then
    Result := cbParams
  else
    Result := edtParams;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsConnEdit.AdjustEditor(ACtrl: TWinControl;
  ACol, ARow: Integer);
var
  R: TRect;
begin
  with __TWinControl(ACtrl) do begin
    R := sgParams.CellRect(ACol, ARow);
    R.TopLeft := sgParams.Parent.ScreenToClient(sgParams.ClientToScreen(R.TopLeft));
    R.BottomRight := sgParams.Parent.ScreenToClient(sgParams.ClientToScreen(R.BottomRight));
    Left := R.Left;
    Top := R.Top;
    Width := R.Right - R.Left;
    Text := sgParams.Cells[ACol, ARow];
    Visible := True;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsConnEdit.cbServerIDClick(Sender: TObject);
var
  s: String;
begin
  s := cbServerID.Text;
  if (s <> '') and ((FConnectionDef = nil) and (FConnectionDefName <> '') or (FDriverID <> s)) then begin
    if FConnectionDef = nil then
      FConnectionDefName := '';
    cbConnectionDefName.Text := '';
    FDriverID := s;
    FEdited.Clear;
    FillParamValues(True);
    FillParamGrids(True);
    GetEditor.Visible := False;
    Modified;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsConnEdit.cbConnectionDefNameClick(Sender: TObject);
var
  s: String;
begin
  s := cbConnectionDefName.Text;
  if (s <> '') and (FConnectionDefName <> s) then begin
    FConnectionDefName := s;
    FDriverID := ADManager.ConnectionDefs.ConnectionDefByName(s).DriverID;
    cbServerID.Text := '';
    FEdited.Clear;
    FillParamValues(True);
    FillParamGrids(True);
    GetEditor.Visible := False;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsConnEdit.sgParamsSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
var
  oDrvMeta: IADPhysDriverMetadata;
  iLogin: Integer;
  sName, sType, sDefVal, sCaption: String;
  lNewUseComboEdit: Boolean;
begin
  if not cbServerID.Enabled then
    Exit;
  if (ACol = 1) and (ARow > 1) then begin
    if IsDriverKnown(FDriverID, oDrvMeta) then begin
      oDrvMeta.GetConnParams(FResults, ARow - 1, sName, sType, sDefVal, sCaption, iLogin);
      lNewUseComboEdit := ADSetupEditor(cbParams, edtParams, sType);
      if lNewUseComboEdit <> FUseComboEdit then begin
        if lNewUseComboEdit then
          edtParams.Visible := False
        else
          cbParams.Visible := False;
        FUseComboEdit := lNewUseComboEdit;
      end;
      AdjustEditor(GetEditor, ACol, ARow);
    end
    else
      GetEditor.Visible := False;
  end
  else
    GetEditor.Visible := False;
  CanSelect := True;
  if GetEditor.Visible then
    if Visible then
      GetEditor.SetFocus;
//    else if GetEditor.CanFocus then
//      ActiveControl := GetEditor;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsConnEdit.sgParamsTopLeftChanged(Sender: TObject);
begin
  if GetEditor.Visible then
    AdjustEditor(GetEditor, sgParams.Col, sgParams.Row);
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsConnEdit.sgParamsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_F2) and GetEditor.Visible then begin
    GetEditor.BringToFront;
    GetEditor.SetFocus;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsConnEdit.sgParamsMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  sgParamsTopLeftChanged(sgParams);
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsConnEdit.FormResize(Sender: TObject);
var
  d: Double;
  iW0, iW1, iW2: Integer;
begin
  if not FLockResize and (GetGridWidth > 80) then begin
    if FLastGridWidth > 0 then begin
      d := GetGridWidth / FLastGridWidth;
      iW0 := Round(d * sgParams.ColWidths[0]);
      if iW0 < 20 then
        iW0 := 20;
      iW1 := Round(d * sgParams.ColWidths[1]);
      if iW1 < 20 then
        iW1 := 20;
      iW2 := Round(d * sgParams.ColWidths[2]);
      if iW2 < 20 then
        iW2 := 20;
      sgParams.ColWidths[0] := iW0;
      sgParams.ColWidths[1] := iW1;
      sgParams.ColWidths[2] := iW2;
      sgParamsMouseUp(nil, mbLeft, [], 0, 0);
    end;
    FLastGridWidth := GetGridWidth;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsConnEdit.sgParamsDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  sKey, sValue: String;
begin
  with TStringGrid(Sender) do begin
    if ((ACol = 0) or (ACol = 1)) and (ARow = 1) or
       (ACol = 2) and (ARow > 0) then begin
      with Canvas.Font do begin
        Color := clBtnShadow;
        Style := Style + [fsItalic];
      end;
    end
    else if (ACol = 1) and (ARow > 0) then begin
      sKey := Cells[0, ARow];
      sValue := Cells[1, ARow];
      if FDefaults.Values[sKey] <> sValue then
        with Canvas do begin
          Brush.Color := clInfoBk;
          FillRect(Rect);
        end;
    end;
    Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2, Cells[ACol, ARow]);
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsConnEdit.EditorExit(Sender: TObject);
var
  sKey, sVal: String;
  i: Integer;
begin
  sKey := sgParams.Cells[0, sgParams.Row];
  sVal := __TWinControl(GetEditor).Text;
  if sgParams.Cells[1, sgParams.Row] <> sVal then begin
    sgParams.Cells[1, sgParams.Row] := sVal;
    i := FEdited.IndexOfName(sKey);
    if i = -1 then
      i := FEdited.Add('');
    FEdited[i] := (sKey + '=' + sVal);
    FillParamValues(False);
    FillParamGrids(False);
    Modified;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsConnEdit.EditorKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (GetEditor = cbParams) and cbParams.DroppedDown and (cbParams.Style <> csSimple) then
    Exit;
  if Key = VK_ESCAPE then begin
    AdjustEditor(GetEditor, sgParams.Col, sgParams.Row);
    if FUseComboEdit then
      cbParams.SelectAll
    else
      edtParams.SelectAll;
    Key := 0;
  end
  else if (Key = VK_RETURN) or (Key = VK_DOWN) and (Shift = []) then begin
    if sgParams.Row < sgParams.RowCount - 1 then begin
      EditorExit(nil);
      sgParams.Row := sgParams.Row + 1;
    end;
    Key := 0;
  end
  else if (Key = VK_UP) and (Shift = []) then begin
    if sgParams.Row > sgParams.FixedRows + 1 then begin
      EditorExit(nil);
      sgParams.Row := sgParams.Row - 1;
    end;
    Key := 0;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsConnEdit.cbParamsDblClick(Sender: TObject);
begin
  if cbParams.ItemIndex + 1 >= cbParams.Items.Count then
    cbParams.ItemIndex := 0
  else
    cbParams.ItemIndex := cbParams.ItemIndex + 1;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsConnEdit.btnDefaultsClick(Sender: TObject);
begin
  ResetData;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsConnEdit.frmOptionsModified(Sender: TObject);
begin
  Modified;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsConnEdit.btnTestClick(Sender: TObject);
var
  oConn: TADConnection;
  oDlg: TADGUIxFormsLoginDialog;
begin
  oConn := TADConnection.Create(nil);
  oDlg := TADGUIxFormsLoginDialog.Create(nil);
  try
    oConn.LoginDialog := oDlg as IADGUIxLoginDialog;
    frmFetchOptions.SaveTo(oConn.FetchOptions);
    frmFormatOptions.SaveTo(oConn.FormatOptions);
    frmUpdateOptions.SaveTo(oConn.UpdateOptions);
    frmResourceOptions.SaveTo(oConn.ResourceOptions);
    FillConnParams(oConn.Params);
    if FConnectionDefName <> '' then
      oConn.ConnectionDefName := FConnectionDefName
    else
      oConn.DriverName := FDriverID;
    oConn.Open;
    ShowMessage(S_AD_LoginDialogTestOk);
  finally
    oConn.Free;
    oDlg.Free;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsConnEdit.btnWizardClick(Sender: TObject);
var
  oConn: TADConnection;
  oDrv: IADPhysDriver;
  oWizard: IADPhysDriverConnectionWizard;
begin
  oConn := TADConnection.Create(nil);
  try
    FillConnParams(oConn.Params);
    if FConnectionDefName <> '' then
      oConn.ConnectionDefName := FConnectionDefName
    else
      oConn.DriverName := FDriverID;
    oConn.CheckConnectionDef;
    ADPhysManager.CreateDriver(oConn.ResultConnectionDef.DriverID, oDrv);
    oDrv.CreateConnectionWizard(oWizard);
    if oWizard = nil then
      MessageDlg(S_AD_WizardNotAccessible, mtWarning, [mbOK], -1)
    else if oWizard.Run(oConn.ResultConnectionDef) then begin
      FEdited.Assign(oConn.Params);
      FillParamValues(False);
      FillParamGrids(True);
    end;
  finally
    oConn.Free;
  end;
end;

{ TODO : To be implemented }
(*
{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.LoadFormState(AReg: TRegistry);
begin
  inherited LoadFormState(AReg);
  ptreeAdvanced.LoadState(AReg);
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.SaveFormState(AReg: TRegistry);
begin
  inherited SaveFormState(AReg);
  ptreeAdvanced.SaveState(AReg);
end;
*)

{ --------------------------------------------------------------------------- }
// TADConnection editor

class function TfrmADGUIxFormsConnEdit.Execute(AConn: TADCustomConnection;
  const ACaption: String): Boolean;
begin
  with TfrmADGUIxFormsConnEdit.Create(nil) do
  try
{ TODO : To be implemented }
//    LoadState;
    Caption := Format(S_AD_ConnEditCaption, [ACaption]);
    ADManager.GetDriverNames(cbServerID.Items);
    ADManager.GetConnectionDefNames(cbConnectionDefName.Items);
    if AConn.DriverName <> '' then begin
      cbServerID.Text := AConn.DriverName;
      FDriverID := AConn.DriverName;
    end
    else if AConn.ConnectionDefName <> '' then begin
      cbConnectionDefName.Text := AConn.ConnectionDefName;
      FConnectionDefName := AConn.ConnectionDefName;
      try
        FDriverID := ADManager.ConnectionDefs.ConnectionDefByName(
          AConn.ConnectionDefName).DriverID;
      except
        Application.HandleException(nil);
        cbConnectionDefName.Text := '';
        FConnectionDefName := '';
      end;
    end;
    FEdited.Assign(AConn.Params);
    FillParamValues(False);
    FillParamGrids(True);
    frmFetchOptions.LoadFrom(AConn.FetchOptions);
    frmFormatOptions.LoadFrom(AConn.FormatOptions);
    frmUpdateOptions.LoadFrom(AConn.UpdateOptions);
    frmResourceOptions.LoadFrom(AConn.ResourceOptions);
    Result := (ShowModal = mrOK);
    if Result then begin
      AConn.Close;
      frmFetchOptions.SaveTo(AConn.FetchOptions);
      frmFormatOptions.SaveTo(AConn.FormatOptions);
      frmUpdateOptions.SaveTo(AConn.UpdateOptions);
      frmResourceOptions.SaveTo(AConn.ResourceOptions);
      FillConnParams(AConn.Params);
      if FConnectionDefName <> '' then
        AConn.ConnectionDefName := FConnectionDefName
      else
        AConn.DriverName := FDriverID;
    end;
{ TODO : To be implemented }
//    SaveState;
  finally
    Free;
  end;
end;

{ --------------------------------------------------------------------------- }
class function TfrmADGUIxFormsConnEdit.Execute(var AConnStr: String;
  const ACaption: String): Boolean;
var
  oConn: TADCustomConnection;
begin
  with TfrmADGUIxFormsConnEdit.Create(nil) do
  try
    oConn := TADCustomConnection.Create(nil);
    try
      oConn.ResultConnectionDef.ParseString(AConnStr);
      Result := Execute(oConn, ACaption);
      if Result then
        AConnStr := oConn.ResultConnectionDef.BuildString();
    finally
      oConn.Free;
    end;
  finally
    Free;
  end;
end;

{ --------------------------------------------------------------------------- }
// ConnectionDef editor

constructor TfrmADGUIxFormsConnEdit.CreateForConnectionDefEditor;
begin
  inherited Create(nil);
  BorderStyle := bsNone;
  Ctl3D := False;
  pnlTitle.Height := 43;
  Label2.Visible := False;
  cbConnectionDefName.Visible := False;
  pnlButtons.Visible := False;
  btnDefaults.Visible := False;
  FLockResize := True;
end;

{ --------------------------------------------------------------------------- }
destructor TfrmADGUIxFormsConnEdit.Destroy;
begin
  FreeAndNil(FFetchOptions);
  FreeAndNil(FFormatOptions);
  FreeAndNil(FUpdateOptions);
  FreeAndNil(FResourceOptions);
  inherited Destroy;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsConnEdit.Modified;
begin
  if Assigned(FOnModified) then
    FOnModified(Self);
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsConnEdit.LoadData(AConnectionDef: IADStanConnectionDef);
begin
  FConnectionDef := AConnectionDef;
  ADManager.GetDriverNames(cbServerID.Items);
  FConnectionDefName := AConnectionDef.Name;
  cbServerID.Text := AConnectionDef.DriverID;
  FDriverID := AConnectionDef.DriverID;
  FEdited.Assign(AConnectionDef.Params);
  FillParamValues(False);
  FillParamGrids(True);
  FFetchOptions := TADFetchOptions.Create(nil);
  FFormatOptions := TADFormatOptions.Create(nil);
  FUpdateOptions := TADUpdateOptions.Create(nil);
  FResourceOptions := TADTopResourceOptions.Create(nil);
  AConnectionDef.ReadOptions(FFormatOptions, FUpdateOptions,
    FFetchOptions, FResourceOptions);
  frmFetchOptions.LoadFrom(FFetchOptions);
  frmFormatOptions.LoadFrom(FFormatOptions);
  frmUpdateOptions.LoadFrom(FUpdateOptions);
  frmResourceOptions.LoadFrom(FResourceOptions);
  FLockResize := False;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsConnEdit.PostChanges;
begin
  if GetEditor.Visible then
    EditorExit(nil);
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsConnEdit.SaveData;
begin
  frmFetchOptions.SaveTo(FFetchOptions);
  frmFormatOptions.SaveTo(FFormatOptions);
  frmUpdateOptions.SaveTo(FUpdateOptions);
  frmResourceOptions.SaveTo(FResourceOptions);
  FillConnParams(FConnectionDef.Params);
  FConnectionDef.Name := FConnectionDefName;
  FConnectionDef.DriverID := FDriverID;
  FConnectionDef.WriteOptions(FFormatOptions, FUpdateOptions,
    FFetchOptions, FResourceOptions);
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsConnEdit.ResetState(AClear: Boolean);
begin
  GetEditor.Visible := False;
  if AClear then
    FConnectionDef := nil;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsConnEdit.ResetData;
begin
  ResetFetchOpts;
  ResetFormatOpts;
  ResetResourceOpts;
  ResetUpdateOpts;
  ResetConnectionDef;
  Modified;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsConnEdit.ResetPage;
begin
  if pcMain.ActivePage = tsConnection then begin
    ResetConnectionDef;
    Modified;
  end
  else if pcMain.ActivePage = tsAdvanced then begin
    ResetFormatOpts;
    ResetFetchOpts;
    ResetUpdateOpts;
    ResetResourceOpts;
    Modified;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsConnEdit.SetReadOnly(AValue: Boolean);
begin
  if AValue then begin
    sgParams.Font.Color := clGray;
    Label1.Enabled := False;
    cbServerID.Enabled := False;
    tsAdvanced.Enabled := False;
    ptreeAdvanced.Enabled := False;
    GetEditor.Visible := False;
  end
  else begin
    sgParams.Font.Color := clWindowText;
    Label1.Enabled := True;
    cbServerID.Enabled := True;
    tsAdvanced.Enabled := True;
    ptreeAdvanced.Enabled := True;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsConnEdit.TestConnection;
begin
  btnTestClick(nil);
end;

end.
