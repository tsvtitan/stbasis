{ --------------------------------------------------------------------------- }
{ AnyDAC Error dialog                                                         }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I daAD.inc}

unit daADGUIxFormsfError;

interface

uses
  Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, ExtCtrls,
    ComCtrls,
  daADStanIntf, daADStanError,
  daADGUIxIntf, daADGUIxFormsControls;

type
  TfrmADGUIxFormsError = class;
  TADGUIxFormsErrorDialog = class;

  TfrmADGUIxFormsError = class(TForm)
    pnlMain: TADGUIxFormsPanel;
    pnlButtons: TADGUIxFormsPanel;
    pnlFrame: TADGUIxFormsPanel;
    pnlContent: TADGUIxFormsPanel;
    memMsg: TMemo;
    pnlTitle: TADGUIxFormsPanel;
    btnOk: TButton;
    btnAdvanced: TButton;
    pcAdvanced: TPageControl;
    tsAdvanced: TTabSheet;
    tsQuery: TTabSheet;
    pnlAdvanced: TADGUIxFormsPanel;
    Panel2: TADGUIxFormsPanel;
    Bevel1: TBevel;
    NativeLabel: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edtErrorCode: TEdit;
    edtServerObject: TEdit;
    edtMessage: TMemo;
    edtErrorKind: TEdit;
    edtCommandTextOffset: TEdit;
    btnPrior: TButton;
    btnNext: TButton;
    pnlAdvancedCaption: TADGUIxFormsPanel;
    Bevel2: TBevel;
    Panel1: TADGUIxFormsPanel;
    Panel3: TADGUIxFormsPanel;
    Label9: TLabel;
    mmCommandText: TMemo;
    Panel4: TADGUIxFormsPanel;
    Label5: TLabel;
    lvCommandParams: TListView;
    tsOther: TTabSheet;
    Panel5: TADGUIxFormsPanel;
    Panel6: TADGUIxFormsPanel;
    Label6: TLabel;
    Label7: TLabel;
    Panel7: TADGUIxFormsPanel;
    edtClassName: TEdit;
    edtDECode: TEdit;
    imIcon: TImage;
    pnlTitleBottomLine: TADGUIxFormsPanel;
    Panel8: TADGUIxFormsPanel;
    Panel9: TADGUIxFormsPanel;
    Panel10: TADGUIxFormsPanel;
    procedure FormShow(Sender: TObject);
    procedure BackClick(Sender: TObject);
    procedure NextClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DetailsBtnClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FEngineError: EADDBEngineException;
    FDetailsHeight, CurItem: Integer;
    FDetails: string;
    FPrevWidth: Integer;
    FOnHide: TADGUIxErrorDialogEvent;
    FOnShow: TADGUIxErrorDialogEvent;
    procedure UpdateLayout(ASwitching: Boolean);
    procedure ShowError;
    procedure ShowCommand;
    property EngineError: EADDBEngineException read FEngineError write FEngineError;
  protected
    procedure Execute(AExc: EADDBEngineException);
  end;

  TADGUIxFormsErrorDialog = class(TADComponent, IADGUIxErrorDialog)
  private
    FErrorDialog: IADGUIxErrorDialog;
    FOnHide: TADGUIxErrorDialogEvent;
    FOnShow: TADGUIxErrorDialogEvent;
    function GetCaption: String;
    procedure SetCaption(const AValue: String);
    function IsCS: Boolean;
    procedure DoOnHide(ASender: TObject; AException: EADDBEngineException);
    procedure DoOnShow(ASender: TObject; AException: EADDBEngineException);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property ErrorDialog: IADGUIxErrorDialog read FErrorDialog implements IADGUIxErrorDialog;
  published
    property Caption: String read GetCaption write SetCaption stored IsCS;
    property OnShow: TADGUIxErrorDialogEvent read FOnShow write FOnShow;
    property OnHide: TADGUIxErrorDialogEvent read FOnHide write FOnHide;
  end;

var
  frmADGUIxFormsError: TfrmADGUIxFormsError;

implementation

uses
  daADStanConst, daADStanFactory, daADStanUtil, daADStanResStrs;

{$R *.DFM}

{ --------------------------------------------------------------------------- }
{ TfrmADGUIxFormsError                                                        }
{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsError.FormCreate(Sender: TObject);
begin
  Caption := S_AD_ErrorDialogDefCaption;
  FDetailsHeight := ClientHeight;
  FDetails := btnAdvanced.Caption;
  pnlButtons.Height := pnlButtons.Height - 7;
  UpdateLayout(False);
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsError.FormDestroy(Sender: TObject);
begin
  if frmADGUIxFormsError = Self then
    frmADGUIxFormsError := nil;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsError.UpdateLayout(ASwitching: Boolean);
const
  DetailsOn: array [Boolean] of string = ('%s >>', '<< %s');
begin
  DisableAlign;
  try
    if pcAdvanced.Visible then begin
      if ASwitching then
        pnlButtons.Height := pnlButtons.Height + 7;
      ClientHeight := FDetailsHeight;
    end
    else begin
      if ASwitching then
        pnlButtons.Height := pnlButtons.Height - 7;
      FDetailsHeight := ClientHeight;
      ClientHeight := ClientHeight - pcAdvanced.Height - 7;
    end;
    memMsg.Height := pnlContent.Height - 16;
    pnlButtons.Top := 0;
    btnAdvanced.Caption := Format(DetailsOn[pcAdvanced.Visible], [FDetails]);
  finally
    EnableAlign;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsError.ShowError;
const
  ErrorKinds: array [TADCommandExceptionKind] of String =
    ('Other', 'NoDataFound', 'RecordLocked', 'UKViolated', 'FKViolated',
     'ObjNotExists', 'UserPwdInvalid', 'UserPwdExpired', 'UserPwdWillExpire',
     'CmdAborted', 'ServerGone', 'ServerOutput');
var
  oError: TADDBError;
  s: String;
  i: Integer;
begin
  btnPrior.Enabled := CurItem > 0;
  btnNext.Enabled := CurItem < EngineError.ErrorCount - 1;
  if CurItem > EngineError.ErrorCount - 1 then
    CurItem := EngineError.ErrorCount - 1
  else if CurItem < 0 then
    CurItem := 0;
  if EngineError.ErrorCount > 0 then begin
    oError := EngineError.Errors[CurItem];
    s := IntToStr(oError.ErrorCode);
    if oError.ErrorCode > 0 then
      for i := 1 to 5 - Length(s) do
        s := '0' + s;
    edtErrorCode.Text := s;
    edtErrorKind.Text := ErrorKinds[oError.Kind];
    edtMessage.Text := ADFixCRLF(oError.Message);
    edtServerObject.Text := oError.ObjName;
    if oError.CommandTextOffset = -1 then
      edtCommandTextOffset.Text := ''
    else
      edtCommandTextOffset.Text := IntToStr(oError.CommandTextOffset);
  end
  else begin
    edtErrorCode.Text := '';
    edtErrorKind.Text := '';
    edtMessage.Text := '';
    edtServerObject.Text := '';
    edtCommandTextOffset.Text := '';
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsError.ShowCommand;
var
  i: Integer;
  oAdapt: IADMoniAdapter;
  sName: String;
  vValue: Variant;
  eKind: TADDebugMonitorAdapterItemKind;
begin
  mmCommandText.Lines.Clear;
  lvCommandParams.Items.Clear;
  oAdapt := EngineError.MonitorAdapter;
  if Assigned(oAdapt) then begin
    for i := 0 to oAdapt.ItemCount - 1 do begin
      oAdapt.GetItem(i, sName, vValue, eKind);
      case eKind of
      ikSQL:
        mmCommandText.Text := ADFixCRLF(vValue);
      ikParam:
        with lvCommandParams.Items.Add do begin
          Caption := ADValToStr(sName, False);
          SubItems.Add(ADValToStr(vValue, False));
        end;
      end;
    end;
    tsQuery.TabVisible := True;
  end
  else
    tsQuery.TabVisible := False;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsError.FormShow(Sender: TObject);
begin
  memMsg.Text := ADFixCRLF(EngineError.Message);
  edtClassName.Text := EngineError.ClassName;
  edtDECode.Text := IntToStr(EngineError.ADCode);
  if pcAdvanced.Visible then begin
    CurItem := 0;
    ShowError;
    ShowCommand;
  end;
  FPrevWidth := ClientWidth;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsError.BackClick(Sender: TObject);
begin
  Dec(CurItem);
  ShowError;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsError.NextClick(Sender: TObject);
begin
  Inc(CurItem);
  ShowError;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsError.DetailsBtnClick(Sender: TObject);
begin
  DisableAlign;
  try
    pcAdvanced.Visible := not pcAdvanced.Visible;
    if not pcAdvanced.Visible then begin
      pcAdvanced.Align := alBottom;
      pnlButtons.Align := alBottom;
      pnlMain.Align := alClient;
    end
    else begin
      pnlMain.Align := alTop;
      pnlButtons.Align := alTop;
      pcAdvanced.Align := alClient;
    end;
    Bevel2.Visible := pcAdvanced.Visible;
    UpdateLayout(True);
    if pcAdvanced.Visible then begin
      CurItem := 0;
      ShowError;
      ShowCommand;
    end;
  finally
    EnableAlign;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsError.Execute(AExc: EADDBEngineException);
begin
  if Assigned(FOnShow) then
    FOnShow(Self, AExc);
  EngineError := AExc;
  ShowModal;
  EngineError := nil;
  if Assigned(FOnHide) then
    FOnHide(Self, AExc);
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsError.FormResize(Sender: TObject);
begin
  FPrevWidth := ClientWidth;
end;

{ --------------------------------------------------------------------------- }
{ TADGUIxFormsErrorDialog                                                     }
{ --------------------------------------------------------------------------- }
constructor TADGUIxFormsErrorDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ADCreateInterface(IADGUIxErrorDialog, FErrorDialog);
  (FErrorDialog as IADStanComponentReference).SetComponentReference(
    Self as IInterfaceComponentReference);
  FErrorDialog.OnShow := DoOnShow;
  FErrorDialog.OnHide := DoOnHide;
end;

{ --------------------------------------------------------------------------- }
destructor TADGUIxFormsErrorDialog.Destroy;
begin
  (FErrorDialog as IADStanComponentReference).SetComponentReference(nil);
  FErrorDialog.OnShow := nil;
  FErrorDialog.OnHide := nil;
  FErrorDialog := nil;
  inherited Destroy;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsErrorDialog.DoOnHide(ASender: TObject;
  AException: EADDBEngineException);
begin
  if Assigned(FOnHide) then
    FOnHide(Self, AException);
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsErrorDialog.DoOnShow(ASender: TObject;
  AException: EADDBEngineException);
begin
  if Assigned(FOnShow) then
    FOnShow(Self, AException);
end;

{ --------------------------------------------------------------------------- }
function TADGUIxFormsErrorDialog.GetCaption: String;
begin
  Result := FErrorDialog.Caption;
end;

{ --------------------------------------------------------------------------- }
function TADGUIxFormsErrorDialog.IsCS: Boolean;
begin
  Result := Caption <> S_AD_ErrorDialogDefCaption;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsErrorDialog.SetCaption(const AValue: String);
begin
  FErrorDialog.Caption := AValue;
end;

{ --------------------------------------------------------------------------- }
{ TADGUIxErrorDialogImpl                                                      }
{ --------------------------------------------------------------------------- }
type
  TADGUIxErrorDialogImpl = class(TADObject, IADGUIxErrorDialog)
  private
    FPrevOnException: TExceptionEvent;
    FHandlingException: Boolean;
    function GetForm: TfrmADGUIxFormsError;
    procedure HandleException(Sender: TObject; E: Exception);
  protected
    // IADGUIxErrorDialog
    function GetOnShow: TADGUIxErrorDialogEvent;
    procedure SetOnShow(const AValue: TADGUIxErrorDialogEvent);
    function GetOnHide: TADGUIxErrorDialogEvent;
    procedure SetOnHide(const AValue: TADGUIxErrorDialogEvent);
    function GetCaption: String;
    procedure SetCaption(const AValue: String);
    procedure Execute(AExc: EADDBEngineException);
  public
    procedure Initialize; override;
    destructor Destroy; override;
  end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxErrorDialogImpl.Initialize;
begin
  inherited Initialize;
  frmADGUIxFormsError := nil;
  FPrevOnException := Application.OnException;
  Application.OnException := HandleException;
end;

{ --------------------------------------------------------------------------- }
destructor TADGUIxErrorDialogImpl.Destroy;
begin
  if Application <> nil then
    Application.OnException := FPrevOnException;
  FPrevOnException := nil;
  FreeAndNil(frmADGUIxFormsError);
  inherited Destroy;
end;

{ --------------------------------------------------------------------------- }
function TADGUIxErrorDialogImpl.GetForm: TfrmADGUIxFormsError;
begin
  if frmADGUIxFormsError = nil then
    frmADGUIxFormsError := TfrmADGUIxFormsError.Create(Application);
  Result := frmADGUIxFormsError;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxErrorDialogImpl.HandleException(Sender: TObject; E: Exception);
begin
  if (E is EADDBEngineException) and not Application.Terminated and
     not FHandlingException then begin
    FHandlingException := True;
    try
      Execute(EADDBEngineException(E))
    finally
      FHandlingException := False;
    end;
  end
  else if Assigned(FPrevOnException) then
    FPrevOnException(Sender, E)
  else
    Application.ShowException(E);
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxErrorDialogImpl.Execute(AExc: EADDBEngineException);
begin
  if not ADGUIxSilent() then
    GetForm.Execute(AExc);
end;

{ --------------------------------------------------------------------------- }
function TADGUIxErrorDialogImpl.GetOnHide: TADGUIxErrorDialogEvent;
begin
  Result := GetForm.FOnHide;
end;

{ --------------------------------------------------------------------------- }
function TADGUIxErrorDialogImpl.GetOnShow: TADGUIxErrorDialogEvent;
begin
  Result := GetForm.FOnShow;
end;

{ --------------------------------------------------------------------------- }
function TADGUIxErrorDialogImpl.GetCaption: String;
begin
  Result := GetForm.Caption;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxErrorDialogImpl.SetOnHide(const AValue: TADGUIxErrorDialogEvent);
begin
  if Assigned(AValue) or Assigned(frmADGUIxFormsError) then
    GetForm.FOnHide := AValue;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxErrorDialogImpl.SetOnShow(const AValue: TADGUIxErrorDialogEvent);
begin
  if Assigned(AValue) or Assigned(frmADGUIxFormsError) then
    GetForm.FOnShow := AValue;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxErrorDialogImpl.SetCaption(const AValue: String);
begin
  if (AValue <> '') or Assigned(frmADGUIxFormsError) then
    GetForm.Caption := AValue;
end;

{ --------------------------------------------------------------------------- }
initialization
  TADSingletonFactory.Create(TADGUIxErrorDialogImpl, IADGUIxErrorDialog);

end.
