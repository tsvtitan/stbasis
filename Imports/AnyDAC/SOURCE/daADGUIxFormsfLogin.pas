{-------------------------------------------------------------------------------}
{ AnyDAC Login dialog                                                           }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit daADGUIxFormsfLogin;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  StdCtrls, Buttons, ExtCtrls, IniFiles,
  daADStanIntf,
  daADGUIxIntf, daADGUIxFormsfOptsBase, daADGUIxFormsControls;

type
  TfrmADGUIxFormsLogin = class;
  TADGUIxFormsLoginDialog = class;

  TADLoginItem = record
    FParam: String;
    FType: String;
    FCaption: String;
    FOrder: Integer;
    FValue: String;
  end;

  TfrmADGUIxFormsLogin = class(TfrmADGUIxFormsOptsBase)
    pnlLogin: TADGUIxFormsPanel;
    pnlControls: TADGUIxFormsPanel;
    pnlHistory: TADGUIxFormsPanel;
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    cbxProfiles: TComboBox;
    Bevel1: TBevel;
    imgLogin: TImage;
    imgChngPwd: TImage;
    lblLogin: TLabel;
    lblChngPwd: TLabel;
    pnlChngPwd: TADGUIxFormsPanel;
    Label2: TLabel;
    Label3: TLabel;
    edtNewPassword: TEdit;
    edtNewPassword2: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure cbxProfilesClick(Sender: TObject);
    procedure edtNewPasswordChange(Sender: TObject);
    procedure cbxProfilesChange(Sender: TObject);
  private
    { Private declarations }
    FAddToOptionsHeight: Integer;
    FParams: array of TADLoginItem;
    FConnectionDef: IADStanConnectionDef;
    FVisibleItems: TStrings;
    FHistoryEnabled: Boolean;
    FHistoryWithPassword: Boolean;
    FHistoryStorage: TADGUIxLoginHistoryStorage;
    FHistoryKey: String;
    function CreateIniFile: TCustomIniFile;
  public
    { Public declarations }
    function ExecuteLogin: Boolean;
    function ExecuteChngPwd: Boolean;
  end;

  TADGUIxFormsLoginDialog = class(TADComponent, IADGUIxLoginDialog)
  private
    FLoginDialog: IADGUIxLoginDialog;
    FOnChangePassword: TADGUIxLoginDialogEvent;
    FOnLogin: TADGUIxLoginDialogEvent;
    FOnHide: TNotifyEvent;
    FOnShow: TNotifyEvent;
    function GetCaption: String;
    function GetChangeExpiredPassword: Boolean;
    function GetHistoryEnabled: Boolean;
    function GetHistoryKey: String;
    function GetHistoryStorage: TADGUIxLoginHistoryStorage;
    function GetHistoryWithPassword: Boolean;
    function GetLoginRetries: Integer;
    function GetVisibleItems: TStrings;
    procedure SetCaption(const AValue: String);
    procedure SetChangeExpiredPassword(const AValue: Boolean);
    procedure SetHistoryEnabled(const AValue: Boolean);
    procedure SetHistoryKey(const AValue: String);
    procedure SetHistoryStorage(const AValue: TADGUIxLoginHistoryStorage);
    procedure SetHistoryWithPassword(const AValue: Boolean);
    procedure SetLoginRetries(const AValue: Integer);
    procedure SetVisibleItems(const AValue: TStrings);
    function GetConnectionDef: IADStanConnectionDef;
    procedure SetConnectionDef(const AConnectionDef: IADStanConnectionDef);
    function GetDefaultDialog: Boolean;
    procedure SetDefaultDialog(const AValue: Boolean);
    procedure DoOnHide(ASender: TObject);
    procedure DoOnShow(ASender: TObject);
    procedure DoChangePassword(ASender: TObject; var AResult: Boolean);
    procedure DoLogin(ASender: TObject; var AResult: Boolean);
    procedure SetOnChangePassword(const AValue: TADGUIxLoginDialogEvent);
    procedure SetOnLogin(const AValue: TADGUIxLoginDialogEvent);
    function IsCS: Boolean;
    function IsHKS: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute(ALoginAction: TADGUIxLoginAction): Boolean;
    procedure GetAllLoginParams;
    property ConnectionDef: IADStanConnectionDef read GetConnectionDef write SetConnectionDef;
    property LoginDialog: IADGUIxLoginDialog read FLoginDialog implements IADGUIxLoginDialog;
  published
    property DefaultDialog: Boolean read GetDefaultDialog write SetDefaultDialog;
    property Caption: String read GetCaption write SetCaption stored IsCS;
    property HistoryEnabled: Boolean read GetHistoryEnabled write SetHistoryEnabled default True;
    property HistoryWithPassword: Boolean read GetHistoryWithPassword write SetHistoryWithPassword default True;
    property HistoryStorage: TADGUIxLoginHistoryStorage read GetHistoryStorage write SetHistoryStorage default hsRegistry;
    property HistoryKey: String read GetHistoryKey write SetHistoryKey stored IsHKS;
    property VisibleItems: TStrings read GetVisibleItems write SetVisibleItems;
    property LoginRetries: Integer read GetLoginRetries write SetLoginRetries default 3;
    property ChangeExpiredPassword: Boolean read GetChangeExpiredPassword write SetChangeExpiredPassword default True;
    property OnHide: TNotifyEvent read FOnHide write FOnHide;
    property OnShow: TNotifyEvent read FOnShow write FOnShow;
    property OnLogin: TADGUIxLoginDialogEvent read FOnLogin write SetOnLogin;
    property OnChangePassword: TADGUIxLoginDialogEvent read FOnChangePassword write SetOnChangePassword;
  end;

var
  frmADGUIxFormsLogin: TfrmADGUIxFormsLogin;

implementation

uses
  Registry,
  daADStanConst, daADStanError, daADStanUtil, daADStanFactory, daADStanResStrs,
  daADGUIxFormsUtil,
  daADPhysIntf;

{$R *.dfm}

{-------------------------------------------------------------------------------}
{ TfrmADGUIxFormsLogin                                                          }
{-------------------------------------------------------------------------------}
type
  __TControl = class(TControl)
  end;

{-------------------------------------------------------------------------------}
function StrReplace(const AStr: String; ASrch, ARepl: Char): String;
var
  i: Integer;
begin
  Result := AStr;
  for i := 1 to Length(Result) do
    if Result[i] = ASrch then
      Result[i] := ARepl;
end;

function TfrmADGUIxFormsLogin.ExecuteLogin: Boolean;
var
  oMeta: IADPhysManagerMetadata;
  oDrv: IADPhysDriverMetadata;
  i, j, iLogin: Integer;
  rTmp: TADLoginItem;
  sName, sType, sDef, sCaption: String;
  oPanel: TADGUIxFormsPanel;
  oLabel: TLabel;
  oCombo: TComboBox;
  oEdit: TEdit;
  oChk: TCheckBox;
  oCtrl: TControl;
  oActiveCtrl: TWinControl;
  oList: TStringList;

  procedure AddItem(const AName, AType, ACaption: String; AOrder: Integer;
    const AValue: String);
  begin
    if (FVisibleItems.Count = 0) or (FVisibleItems.IndexOf(AName) <> -1) then begin
      SetLength(FParams, Length(FParams) + 1);
      with FParams[Length(FParams) - 1] do begin
        FParam := AName;
        FType := AType;
        FCaption := ACaption;
        FOrder := AOrder;
        FValue := AValue;
      end;
    end;
  end;

begin
  pnlChngPwd.Visible := False;
  pnlLogin.Align := alClient;
  pnlLogin.Visible := True;
  imgLogin.Visible := True;
  lblLogin.Visible := True;

  SetLength(FParams, 0);
  ADPhysManager.CreateMetadata(oMeta);
  oMeta.CreateDriverMetadata(FConnectionDef.DriverID, oDrv);
  for i := 0 to oDrv.GetConnParamCount(FConnectionDef.Params) - 1 do begin
    oDrv.GetConnParams(FConnectionDef.Params, i, sName, sType, sDef, sCaption, iLogin);
    if iLogin <> -1 then
      AddItem(sName, sType, sCaption, iLogin, FConnectionDef.AsString[sName]);
  end;

  with pnlControls do
    while ControlCount > 0 do
      Controls[0].Free;

  for i := 0 to Length(FParams) - 1 do
    for j := i to Length(FParams) - 2 do
      if FParams[j].FOrder > FParams[j + 1].FOrder then begin
        rTmp := FParams[j + 1];
        FParams[j + 1] := FParams[j];
        FParams[j] := rTmp;
      end;

  oActiveCtrl := nil;
  for i := 0 to Length(FParams) - 1 do begin
    oPanel := TADGUIxFormsPanel.Create(Self);
    oPanel.BevelInner := bvNone;
    oPanel.BevelOuter := bvNone;
    oPanel.BorderStyle := bsNone;
    oPanel.Color := clWhite;
    oPanel.Parent := pnlControls;
    oPanel.Top := 6 + i * 26;
    oPanel.Height := 26;
    oPanel.Left := 3;
    oPanel.Width := pnlControls.ClientWidth;

    oLabel := TLabel.Create(Self);
    oLabel.Parent := oPanel;
    oLabel.Top := 4;
    oLabel.Left := 3;
    oLabel.Caption := '&' + FParams[i].FCaption + ':';

    if (FParams[i].FType = '@L') or (FParams[i].FType = '@Y') then begin
      oChk := TCheckBox.Create(Self);
      oChk.Parent := oPanel;
      oChk.Top := 4;
      oChk.Left := 70;
      oChk.Tag := i;
      oChk.Checked := (CompareText(FParams[i].FValue, S_AD_True) = 0) or
        (CompareText(FParams[i].FValue, S_AD_Yes) = 0);
      oLabel.FocusControl := oChk;
    end
    else if (FParams[i].FType <> '@S') and (FParams[i].FType <> '@I') then begin
      oCombo := TComboBox.Create(Self);
{$IFDEF AnyDAC_D6}
      oCombo.BevelInner := bvSpace;
      oCombo.BevelKind := bkFlat;
{$ENDIF}
      oCombo.Ctl3D := True;
      oCombo.Parent := oPanel;
      oCombo.Top := 2;
      oCombo.Left := 70;
      oCombo.Width := 150;
      oCombo.Tag := i;
      ADSetupEditor(oCombo, nil, FParams[i].FType);
      oCombo.Text := FParams[i].FValue;
      if (oCombo.Text = '') and (oActiveCtrl = nil) then
        oActiveCtrl := oCombo;
      oLabel.FocusControl := oCombo;
    end
    else begin
      oEdit := TEdit.Create(Self);
{$IFDEF AnyDAC_D6}
      oEdit.BevelInner := bvSpace;
      oEdit.BevelKind := bkFlat;
{$ENDIF}
      oEdit.Ctl3D := True;
{$IFDEF AnyDAC_D6}
      oEdit.BorderStyle := bsNone;
{$ENDIF}
      if FParams[i].FParam = S_AD_ConnParam_Common_Password then
        oEdit.PasswordChar := '#';
      oEdit.Parent := oPanel;
      oEdit.Top := 2;
      oEdit.Left := 70;
      oEdit.Width := 150;
      oEdit.Tag := i;
      oEdit.Text := FParams[i].FValue;
      if (oEdit.Text = '') and (oActiveCtrl = nil) then
        oActiveCtrl := oEdit;
      oLabel.FocusControl := oEdit;
    end;
  end;

  Height := FAddToOptionsHeight + Length(FParams) * 26 + 20;
  Width := 100 + 150;
  if oActiveCtrl = nil then
    ActiveControl := btnOk
  else
    ActiveControl := oActiveCtrl;

  cbxProfiles.Items.Clear;
  if FHistoryEnabled then
    with CreateIniFile do
    try
      oList := TStringList.Create;
      try
        ReadSections(oList);
        i := 0;
        while i < oList.Count do
          if Pos(FConnectionDef.DriverID + ' - ', oList[i]) = 0 then
            oList.Delete(i)
          else begin
            oList[i] := StrReplace(oList[i], '/', '\');
            Inc(i);
          end;
        cbxProfiles.Items := oList;
        cbxProfiles.ItemIndex := cbxProfiles.Items.IndexOf(FConnectionDef.DriverID + ' - ' +
          AnsiUpperCase(FConnectionDef.Database) + ' - ' + FConnectionDef.UserName);
        SendMessage(cbxProfiles.Handle, CB_SETDROPPEDWIDTH, Width, 0);
        cbxProfiles.OnChange(nil);
      finally
        oList.Free;
      end;
    finally
      Free;
    end
  else begin
    Height := Height - pnlTitle.Height - pnlHistory.Height;
    pnlTitle.Visible := False;
    pnlHistory.Visible := False;
  end;

  Result := (ShowModal = mrOK);

  if Result then begin
    for i := 0 to pnlControls.ControlCount - 1 do begin
      oCtrl := TADGUIxFormsPanel(pnlControls.Controls[i]).Controls[1];
      if oCtrl is TCheckBox then
        if FParams[oCtrl.Tag].FType = '@Y' then
          FConnectionDef.AsYesNo[FParams[oCtrl.Tag].FParam] := TCheckBox(oCtrl).Checked
        else
          FConnectionDef.AsBoolean[FParams[oCtrl.Tag].FParam] := TCheckBox(oCtrl).Checked
      else
        FConnectionDef.AsString[FParams[oCtrl.Tag].FParam] := __TControl(oCtrl).Caption;
    end;

    if FHistoryEnabled then
      with CreateIniFile do
      try
        sName := FConnectionDef.DriverID + ' - ' +
          StrReplace(AnsiUpperCase(FConnectionDef.Database), '\', '/') + ' - ' +
          FConnectionDef.UserName;
        EraseSection(sName);
        for i := 0 to Length(FParams) - 1 do
          if FHistoryWithPassword or
             (ADCompareText(FParams[i].FParam, S_AD_ConnParam_Common_Password) <> 0) then
            WriteString(sName, FParams[i].FParam, FConnectionDef.AsString[FParams[i].FParam]);
      finally
          Free;
      end;

  end;
  SetLength(FParams, 0);
  Application.ProcessMessages;
end;

{-------------------------------------------------------------------------------}
function TfrmADGUIxFormsLogin.ExecuteChngPwd: Boolean;
begin
  pnlLogin.Visible := False;
  pnlChngPwd.Align := alClient;
  pnlChngPwd.Visible := True;
  imgChngPwd.Visible := True;
  lblChngPwd.Visible := True;

  Height := Height - pnlOptions.Height + 75;
  Width := 250;
  btnOk.Enabled := False;
  ActiveControl := edtNewPassword;
  Result := (ShowModal = mrOK);
  if Result then
    FConnectionDef.NewPassword := edtNewPassword.Text;
end;

{-------------------------------------------------------------------------------}
function TfrmADGUIxFormsLogin.CreateIniFile: TCustomIniFile;
begin
  if FHistoryStorage = hsRegistry then
    Result := TRegistryIniFile.Create(FHistoryKey)
  else if FHistoryStorage = hsFile then
    Result := TIniFile.Create(FHistoryKey)
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsLogin.FormCreate(Sender: TObject);
begin
  FAddToOptionsHeight := Height - pnlOptions.Height + pnlHistory.Height;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsLogin.SpeedButton1Click(Sender: TObject);
begin
  with CreateIniFile do
  try
    EraseSection(StrReplace(cbxProfiles.Text, '\', '/'));
    cbxProfiles.Items.Delete(cbxProfiles.ItemIndex);
    cbxProfiles.ItemIndex := -1;
    cbxProfiles.Text := '';
  finally
    Free;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsLogin.cbxProfilesClick(Sender: TObject);
var
  i: Integer;
  oCtrl: TControl;
  sName: String;
begin
  with CreateIniFile do
  try
    sName := StrReplace(cbxProfiles.Text, '\', '/');
    for i := 0 to pnlControls.ControlCount - 1 do begin
      oCtrl := TADGUIxFormsPanel(pnlControls.Controls[i]).Controls[1];
      __TControl(oCtrl).Caption := ReadString(sName, FParams[oCtrl.Tag].FParam, '');
    end;
  finally
    Free;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsLogin.cbxProfilesChange(Sender: TObject);
begin
  SpeedButton1.Enabled := cbxProfiles.Text <> '';
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsLogin.edtNewPasswordChange(Sender: TObject);
begin
  btnOk.Enabled := (edtNewPassword.Text = edtNewPassword2.Text);
end;

{-------------------------------------------------------------------------------}
{ TADGUIxFormsLoginDialog                                                       }
{-------------------------------------------------------------------------------}
var
  FDefaultDialog: IADGUIxLoginDialog;

constructor TADGUIxFormsLoginDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ADCreateInterface(IADGUIxLoginDialog, FLoginDialog);
  (FLoginDialog as IADStanComponentReference).SetComponentReference(
    Self as IInterfaceComponentReference);
  FLoginDialog.OnShow := DoOnShow;
  FLoginDialog.OnHide := DoOnHide;
  if FDefaultDialog = nil then
    DefaultDialog := True;
end;

{-------------------------------------------------------------------------------}
destructor TADGUIxFormsLoginDialog.Destroy;
begin
  DefaultDialog := False;
  (FLoginDialog as IADStanComponentReference).SetComponentReference(nil);
  FLoginDialog.OnLogin := nil;
  FLoginDialog.OnChangePassword := nil;
  FLoginDialog.OnShow := nil;
  FLoginDialog.OnHide := nil;
  FLoginDialog := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsLoginDialog.DoLogin(ASender: TObject; var AResult: Boolean);
begin
  if Assigned(FOnLogin) then
    FOnLogin(Self, AResult);
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsLoginDialog.DoChangePassword(ASender: TObject; var AResult: Boolean);
begin
  if Assigned(FOnChangePassword) then
    FOnChangePassword(Self, AResult);
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsLoginDialog.DoOnShow(ASender: TObject);
begin
  if Assigned(FOnShow) then
    FOnShow(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsLoginDialog.DoOnHide(ASender: TObject);
begin
  if Assigned(FOnHide) then
    FOnHide(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsLoginDialog.SetOnChangePassword(const AValue: TADGUIxLoginDialogEvent);
begin
  FOnChangePassword := AValue;
  if Assigned(FOnChangePassword) then
    FLoginDialog.OnChangePassword := DoChangePassword
  else
    FLoginDialog.OnChangePassword := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsLoginDialog.SetOnLogin(const AValue: TADGUIxLoginDialogEvent);
begin
  FOnLogin := AValue;
  if Assigned(FOnLogin) then
    FLoginDialog.OnLogin := DoLogin
  else
    FLoginDialog.OnLogin := nil;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFormsLoginDialog.GetDefaultDialog: Boolean;
begin
{$IFNDEF AnyDAC_D6}
  if csDesigning in ComponentState then
    Result := True
  else
{$ENDIF}
    Result := FDefaultDialog = FLoginDialog;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsLoginDialog.SetDefaultDialog(const AValue: Boolean);
begin
{$IFNDEF AnyDAC_D6}
  if not (csDesigning in ComponentState) then
{$ENDIF}
    if DefaultDialog <> AValue then
      if AValue then
        FDefaultDialog := FLoginDialog
      else
        FDefaultDialog := nil;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFormsLoginDialog.GetConnectionDef: IADStanConnectionDef;
begin
  Result := FLoginDialog.ConnectionDef;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFormsLoginDialog.GetCaption: String;
begin
  Result := FLoginDialog.Caption;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFormsLoginDialog.GetChangeExpiredPassword: Boolean;
begin
  Result := FLoginDialog.ChangeExpiredPassword;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFormsLoginDialog.GetHistoryEnabled: Boolean;
begin
  Result := FLoginDialog.HistoryEnabled;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFormsLoginDialog.GetHistoryKey: String;
begin
  Result := FLoginDialog.HistoryKey;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFormsLoginDialog.GetHistoryStorage: TADGUIxLoginHistoryStorage;
begin
  Result := FLoginDialog.HistoryStorage;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFormsLoginDialog.GetHistoryWithPassword: Boolean;
begin
  Result := FLoginDialog.HistoryWithPassword;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFormsLoginDialog.GetLoginRetries: Integer;
begin
  Result := FLoginDialog.LoginRetries;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFormsLoginDialog.GetVisibleItems: TStrings;
begin
  Result := FLoginDialog.VisibleItems;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsLoginDialog.SetCaption(const AValue: String);
begin
  FLoginDialog.Caption := AValue;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFormsLoginDialog.IsCS: Boolean;
begin
  Result := Caption <> S_AD_LoginDialogDefCaption;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsLoginDialog.SetChangeExpiredPassword(const AValue: Boolean);
begin
  FLoginDialog.ChangeExpiredPassword := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsLoginDialog.SetHistoryEnabled(const AValue: Boolean);
begin
  FLoginDialog.HistoryEnabled := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsLoginDialog.SetHistoryKey(const AValue: String);
begin
  FLoginDialog.HistoryKey := AValue;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFormsLoginDialog.IsHKS: Boolean;
begin
  Result := HistoryKey <> (S_AD_CfgKeyName + '\' + S_AD_Profiles);
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsLoginDialog.SetHistoryStorage(const AValue: TADGUIxLoginHistoryStorage);
begin
  FLoginDialog.HistoryStorage := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsLoginDialog.SetHistoryWithPassword(const AValue: Boolean);
begin
  FLoginDialog.HistoryWithPassword := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsLoginDialog.SetLoginRetries(const AValue: Integer);
begin
  FLoginDialog.LoginRetries := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsLoginDialog.SetConnectionDef(const AConnectionDef: IADStanConnectionDef);
begin
  FLoginDialog.ConnectionDef := AConnectionDef;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsLoginDialog.SetVisibleItems(const AValue: TStrings);
begin
  FLoginDialog.VisibleItems := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsLoginDialog.GetAllLoginParams;
begin
  FLoginDialog.GetAllLoginParams;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFormsLoginDialog.Execute(ALoginAction: TADGUIxLoginAction): Boolean;
begin
  Result := FLoginDialog.Execute(ALoginAction);
end;

{-------------------------------------------------------------------------------}
{ TADGUIxFormsLoginDialog                                                       }
{-------------------------------------------------------------------------------}
type
  TADGUIxFormsLoginDialogImpl = class(TADObject, IADGUIxLoginDialog)
  private
    FHistoryWithPassword: Boolean;
    FHistoryEnabled: Boolean;
    FHistoryKey: String;
    FCaption: String;
    FHistoryStorage: TADGUIxLoginHistoryStorage;
    FVisibleItems: TStrings;
    FConnectionDef: IADStanConnectionDef;
    FOnHide: TNotifyEvent;
    FOnShow: TNotifyEvent;
    FLoginRetries: Integer;
    FOnChangePassword: TADGUIxLoginDialogEvent;
    FOnLogin: TADGUIxLoginDialogEvent;
    FChangeExpiredPassword: Boolean;
  protected
    // IADGUIxLoginDialog
    function GetCaption: String;
    function GetChangeExpiredPassword: Boolean;
    function GetHistoryEnabled: Boolean;
    function GetHistoryKey: String;
    function GetHistoryStorage: TADGUIxLoginHistoryStorage;
    function GetHistoryWithPassword: Boolean;
    function GetLoginRetries: Integer;
    function GetVisibleItems: TStrings;
    function GetConnectionDef: IADStanConnectionDef;
    function GetOnHide: TNotifyEvent;
    function GetOnShow: TNotifyEvent;
    function GetOnChangePassword: TADGUIxLoginDialogEvent;
    function GetOnLogin: TADGUIxLoginDialogEvent;
    procedure SetCaption(const AValue: String);
    procedure SetChangeExpiredPassword(const AValue: Boolean);
    procedure SetHistoryEnabled(const AValue: Boolean);
    procedure SetHistoryKey(const AValue: String);
    procedure SetHistoryStorage(const AValue: TADGUIxLoginHistoryStorage);
    procedure SetHistoryWithPassword(const AValue: Boolean);
    procedure SetLoginRetries(const AValue: Integer);
    procedure SetVisibleItems(const AValue: TStrings);
    procedure SetConnectionDef(const AValue: IADStanConnectionDef);
    procedure SetOnHide(const AValue: TNotifyEvent);
    procedure SetOnShow(const AValue: TNotifyEvent);
    procedure SetOnChangePassword(const AValue: TADGUIxLoginDialogEvent);
    procedure SetOnLogin(const AValue: TADGUIxLoginDialogEvent);
    function Execute(ALoginAction: TADGUIxLoginAction): Boolean;
    procedure GetAllLoginParams;
  public
    procedure Initialize; override;
    destructor Destroy; override;
  end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsLoginDialogImpl.Initialize;
begin
  inherited Initialize;
  FHistoryStorage := hsRegistry;
  FHistoryKey := S_AD_CfgKeyName + '\' + S_AD_Profiles;
  FHistoryWithPassword := True;
  FHistoryEnabled := True;
  FCaption := S_AD_LoginDialogDefCaption;
  FVisibleItems := TStringList.Create;
  FLoginRetries := 3;
  FChangeExpiredPassword := True;
end;

{-------------------------------------------------------------------------------}
destructor TADGUIxFormsLoginDialogImpl.Destroy;
begin
  FreeAndNil(FVisibleItems);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFormsLoginDialogImpl.GetCaption: String;
begin
  Result := FCaption;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFormsLoginDialogImpl.GetChangeExpiredPassword: Boolean;
begin
  Result := FChangeExpiredPassword;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFormsLoginDialogImpl.GetConnectionDef: IADStanConnectionDef;
begin
  Result := FConnectionDef;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFormsLoginDialogImpl.GetHistoryEnabled: Boolean;
begin
  Result := FHistoryEnabled;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFormsLoginDialogImpl.GetHistoryKey: String;
begin
  Result := FHistoryKey;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFormsLoginDialogImpl.GetHistoryStorage: TADGUIxLoginHistoryStorage;
begin
  Result := FHistoryStorage;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFormsLoginDialogImpl.GetHistoryWithPassword: Boolean;
begin
  Result := FHistoryWithPassword;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFormsLoginDialogImpl.GetLoginRetries: Integer;
begin
  Result := FLoginRetries;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFormsLoginDialogImpl.GetVisibleItems: TStrings;
begin
  Result := FVisibleItems;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFormsLoginDialogImpl.GetOnHide: TNotifyEvent;
begin
  Result := FOnHide;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFormsLoginDialogImpl.GetOnShow: TNotifyEvent;
begin
  Result := FOnShow;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFormsLoginDialogImpl.GetOnChangePassword: TADGUIxLoginDialogEvent;
begin
  Result := FOnChangePassword;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFormsLoginDialogImpl.GetOnLogin: TADGUIxLoginDialogEvent;
begin
  Result := FOnLogin;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsLoginDialogImpl.SetOnHide(const AValue: TNotifyEvent);
begin
  FOnHide := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsLoginDialogImpl.SetCaption(const AValue: String);
begin
  FCaption := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsLoginDialogImpl.SetChangeExpiredPassword(const AValue: Boolean);
begin
  FChangeExpiredPassword := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsLoginDialogImpl.SetConnectionDef(const AValue: IADStanConnectionDef);
begin
  FConnectionDef := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsLoginDialogImpl.SetHistoryEnabled(const AValue: Boolean);
begin
  FHistoryEnabled := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsLoginDialogImpl.SetHistoryKey(const AValue: String);
begin
  FHistoryKey := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsLoginDialogImpl.SetHistoryStorage(const AValue: TADGUIxLoginHistoryStorage);
begin
  FHistoryStorage := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsLoginDialogImpl.SetHistoryWithPassword(const AValue: Boolean);
begin
  FHistoryWithPassword := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsLoginDialogImpl.SetLoginRetries(const AValue: Integer);
begin
  FLoginRetries := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsLoginDialogImpl.SetVisibleItems(const AValue: TStrings);
begin
  FVisibleItems.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsLoginDialogImpl.SetOnShow(const AValue: TNotifyEvent);
begin
  FOnShow := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsLoginDialogImpl.SetOnChangePassword(const AValue: TADGUIxLoginDialogEvent);
begin
  FOnChangePassword := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsLoginDialogImpl.SetOnLogin(const AValue: TADGUIxLoginDialogEvent);
begin
  FOnLogin := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsLoginDialogImpl.GetAllLoginParams;
var
  oMeta: IADPhysManagerMetadata;
  oDrv: IADPhysDriverMetadata;
  i, iLogin: Integer;
  sName, sTmp: String;
begin
  ADPhysManager.CreateMetadata(oMeta);
  oMeta.CreateDriverMetadata(FConnectionDef.DriverID, oDrv);
  FVisibleItems.Clear;
  for i := 0 to oDrv.GetConnParamCount(FConnectionDef.Params) - 1 do begin
    oDrv.GetConnParams(FConnectionDef.Params, i, sName, sTmp, sTmp, sTmp, iLogin);
    if iLogin <> -1 then
      FVisibleItems.Add(sName);
  end;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFormsLoginDialogImpl.Execute(ALoginAction: TADGUIxLoginAction): Boolean;
var
  oLogin: TfrmADGUIxFormsLogin;
  iRetries: Integer;
  lLoged, lLoginPrompt: Boolean;
begin
  if ADGUIxSilent() then begin
    if Assigned(ALoginAction) then
      ALoginAction;
    Result := True;
    Exit;
  end;
  if Assigned(FOnShow) then
    FOnShow(Self);
  iRetries := 0;
  lLoged := True;
  lLoginPrompt := True;
  repeat
    try
      if lLoginPrompt then begin
        if Assigned(FOnLogin) then begin
          Result := True;
          FOnLogin(Self, Result);
        end
        else begin
          oLogin := TfrmADGUIxFormsLogin.Create(Application);
          try
            oLogin.FConnectionDef := FConnectionDef;
            oLogin.Caption := FCaption;
            oLogin.FVisibleItems := FVisibleItems;
            oLogin.FHistoryEnabled := FHistoryEnabled;
            oLogin.FHistoryWithPassword := FHistoryWithPassword;
            oLogin.FHistoryStorage := FHistoryStorage;
            oLogin.FHistoryKey := FHistoryKey;
            Result := oLogin.ExecuteLogin;
          finally
            oLogin.Free;
          end;
        end;
      end
      else begin
        lLoginPrompt := True;
        Result := True;
      end;
      if Result and Assigned(ALoginAction) then
        ALoginAction;
      lLoged := True;
    except on E: EADDBEngineException do
      // invalid password/user name
      if E.Kind = ekUserPwdInvalid then begin
        ADHandleException;
        Inc(iRetries);
        if iRetries >= FLoginRetries then
          ADException(Self, [S_AD_LGUIx, S_AD_LGUIx_PForms], er_AD_AccToManyLogins,
            [FLoginRetries]);
        lLoged := False;
      end
      // password expired
      else if (E.Kind = ekUserPwdExpired) and FChangeExpiredPassword then begin
        ADHandleException;
        if Assigned(FOnChangePassword) then begin
          Result := True;
          FOnChangePassword(Self, Result);
        end
        else begin
          oLogin := TfrmADGUIxFormsLogin.Create(Application);
          try
            oLogin.FConnectionDef := FConnectionDef;
            oLogin.Caption := FCaption;
            oLogin.FVisibleItems := FVisibleItems;
            oLogin.FHistoryEnabled := FHistoryEnabled;
            oLogin.FHistoryWithPassword := FHistoryWithPassword;
            oLogin.FHistoryStorage := FHistoryStorage;
            oLogin.FHistoryKey := FHistoryKey;
            Result := oLogin.ExecuteChngPwd;
          finally
            oLogin.Free;
          end;
        end;
        lLoginPrompt := False;
        lLoged := False;
      end
      // will expired
      else if E.Kind = ekUserPwdWillExpire then
        ADHandleException
      else
        raise;
    end;
  until lLoged;
  if Result and Assigned(FOnHide) then
    FOnHide(Self);
end;

{-------------------------------------------------------------------------------}
{ TADGUIxFormsLoginDialog                                                       }
{-------------------------------------------------------------------------------}
type
  TADGUIxFormsDefaultLoginDialogImpl = class(TADObject, IADGUIxDefaultLoginDialog)
  protected
    // IADGUIxDefaultLoginDialog
    function GetLoginDialog: IADGUIxLoginDialog;
  public
    destructor Destroy; override;
  end;

{-------------------------------------------------------------------------------}
destructor TADGUIxFormsDefaultLoginDialogImpl.Destroy;
begin
  FDefaultDialog := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFormsDefaultLoginDialogImpl.GetLoginDialog: IADGUIxLoginDialog;
begin
  Result := FDefaultDialog;
end;

{-------------------------------------------------------------------------------}
initialization
  TADMultyInstanceFactory.Create(TADGUIxFormsLoginDialogImpl, IADGUIxLoginDialog);
  TADSingletonFactory.Create(TADGUIxFormsDefaultLoginDialogImpl, IADGUIxDefaultLoginDialog);

end.
