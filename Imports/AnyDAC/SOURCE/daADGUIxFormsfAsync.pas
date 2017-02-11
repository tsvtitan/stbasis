{-------------------------------------------------------------------------------}
{ AnyDAC async notify form                                                      }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit daADGUIxFormsfAsync;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  ExtCtrls, Buttons,
  daADStanIntf,
  daADGUIxIntf, daADGUIxFormsControls;

type
  TfrmADGUIxFormsAsyncExecute = class;
  TADGUIxFormsAsyncExecuteDialog = class;

  TfrmADGUIxFormsAsyncExecute = class(TForm)
    Panel2: TADGUIxFormsPanel;
    pnlHeader: TADGUIxFormsPanel;
    Panel1: TADGUIxFormsPanel;
    tmrDelay: TTimer;
    btnCancel: TSpeedButton;
    Image1: TImage;
    pnlTitleBottomLine: TADGUIxFormsPanel;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnCancelClick(Sender: TObject);
    procedure tmrDelayTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FExecutor: IADStanAsyncExecutor;
    FRequestShow: Boolean;
    FWindowList : Pointer;
  protected
    // IADGUIxAsyncExecuteDialog
    procedure Execute(AShow: Boolean; const AExecutor: IADStanAsyncExecutor);
    function IsFormActive: Boolean;
    function IsFormMouseMessage(const AMsg: TMsg): Boolean;
  end;

  TADGUIxFormsAsyncExecuteDialog = class(TADComponent, IADGUIxAsyncExecuteDialog)
  private
    FAsyncDialog: IADGUIxAsyncExecuteDialog;
    FOnShow: TNotifyEvent;
    FOnHide: TNotifyEvent;
    procedure DoOnShow(ASender: TObject);
    procedure DoOnHide(ASender: TObject);
    function GetCaption: String;
    procedure SetCaption(const AValue: String);
    function IsCS: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property AsyncDialog: IADGUIxAsyncExecuteDialog read FAsyncDialog
      implements IADGUIxAsyncExecuteDialog;
  published
    property Caption: String read GetCaption write SetCaption stored IsCS;
    property OnShow: TNotifyEvent read FOnShow write FOnShow;
    property OnHide: TNotifyEvent read FOnHide write FOnHide;
  end;

var
  frmADGUIxFormsAsyncExecute: TfrmADGUIxFormsAsyncExecute;

implementation

{$R *.dfm}

uses
  daADStanConst, daADStanFactory, daADStanResStrs;

{-------------------------------------------------------------------------------}
{ TfrmADWait                                                                    }
{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsAsyncExecute.FormCreate(Sender: TObject);
begin
  Caption := S_AD_AsyncDialogDefCaption;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsAsyncExecute.FormDestroy(Sender: TObject);
begin
  if frmADGUIxFormsAsyncExecute = Self then
    frmADGUIxFormsAsyncExecute := nil;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsAsyncExecute.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then begin
    btnCancelClick(nil);
    Key := 0;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsAsyncExecute.btnCancelClick(Sender: TObject);
begin
  if FExecutor.Operation.AbortSupported then
    FExecutor.AbortJob;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsAsyncExecute.tmrDelayTimer(Sender: TObject);
begin
  if (FRequestShow <> Visible) and not (csDestroying in ComponentState) then begin
    if FRequestShow then begin
      if GetCapture <> 0 then
        SendMessage(GetCapture, WM_CANCELMODE, 0, 0);
      FWindowList := DisableTaskWindows(0);
      Show;
    end
    else begin
      if FWindowList <> nil then begin
        EnableTaskWindows(FWindowList);
        FWindowList := nil;
      end;
      Hide;
    end;
    tmrDelay.Enabled := False;
//      TNCOciBreakFrm.ProcessMessages;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsAsyncExecute.Execute(AShow: Boolean;
  const AExecutor: IADStanAsyncExecutor);
begin
  FExecutor := AExecutor;
  if AShow <> FRequestShow then begin
    FRequestShow := AShow;
    if FRequestShow then
      btnCancel.Visible := AExecutor.Operation.AbortSupported
    else
      FExecutor := nil;
    tmrDelay.Interval := C_AD_DelayBeforeFWait;
    tmrDelay.Enabled := True;
  end;
end;

{-------------------------------------------------------------------------------}
function TfrmADGUIxFormsAsyncExecute.IsFormActive: Boolean;
begin
  Result := Screen.ActiveForm = Self;
end;

{-------------------------------------------------------------------------------}
function TfrmADGUIxFormsAsyncExecute.IsFormMouseMessage(const AMsg: TMsg): Boolean;
var
  oCtrl: TControl;
begin
  oCtrl := FindControl(AMsg.hwnd);
  if oCtrl <> nil then
    Result := (GetParentForm(oCtrl) = Self)
  else
    Result := False;
end;

{-------------------------------------------------------------------------------}
{ TADGUIxFormsAsyncExecuteDialog                                                }
{-------------------------------------------------------------------------------}
constructor TADGUIxFormsAsyncExecuteDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ADCreateInterface(IADGUIxAsyncExecuteDialog, FAsyncDialog);
  (FAsyncDialog as IADStanComponentReference).SetComponentReference(
    Self as IInterfaceComponentReference);
  FAsyncDialog.OnShow := DoOnShow;
  FAsyncDialog.OnHide := DoOnHide;
end;

{-------------------------------------------------------------------------------}
destructor TADGUIxFormsAsyncExecuteDialog.Destroy;
begin
  (FAsyncDialog as IADStanComponentReference).SetComponentReference(nil);
  FAsyncDialog.OnShow := nil;
  FAsyncDialog.OnHide := nil;
  FAsyncDialog := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsAsyncExecuteDialog.DoOnHide(ASender: TObject);
begin
  if Assigned(FOnHide) then
    FOnHide(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsAsyncExecuteDialog.DoOnShow(ASender: TObject);
begin
  if Assigned(FOnShow) then
    FOnShow(Self);
end;

{-------------------------------------------------------------------------------}
function TADGUIxFormsAsyncExecuteDialog.GetCaption: String;
begin
  Result := FAsyncDialog.Caption;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsAsyncExecuteDialog.SetCaption(const AValue: String);
begin
  FAsyncDialog.Caption := AValue;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFormsAsyncExecuteDialog.IsCS: Boolean;
begin
  Result := Caption <> S_AD_AsyncDialogDefCaption;
end;

{-------------------------------------------------------------------------------}
{ TADGUIxFormsAsyncExecuteImpl                                                  }
{-------------------------------------------------------------------------------}
type
  TADGUIxFormsAsyncExecuteImpl = class(TADObject, IADGUIxAsyncExecuteDialog)
  private
    function GetForm: TfrmADGUIxFormsAsyncExecute;
  protected
    // IADGUIxAsyncExecuteDialog
    function GetOnShow: TNotifyEvent;
    procedure SetOnShow(const AValue: TNotifyEvent);
    function GetOnHide: TNotifyEvent;
    procedure SetOnHide(const AValue: TNotifyEvent);
    function GetCaption: String;
    procedure SetCaption(const AValue: String);
    procedure Execute(AShow: Boolean; const AExecutor: IADStanAsyncExecutor);
    function IsFormActive: Boolean;
    function IsFormMouseMessage(const AMsg: TMsg): Boolean;
  public
    procedure Initialize; override;
    destructor Destroy; override;
  end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsAsyncExecuteImpl.Initialize;
begin
  inherited Initialize;
  frmADGUIxFormsAsyncExecute := nil;
end;

{-------------------------------------------------------------------------------}
destructor TADGUIxFormsAsyncExecuteImpl.Destroy;
begin
  FreeAndNil(frmADGUIxFormsAsyncExecute);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFormsAsyncExecuteImpl.GetForm: TfrmADGUIxFormsAsyncExecute;
begin
  if frmADGUIxFormsAsyncExecute = nil then
    frmADGUIxFormsAsyncExecute := TfrmADGUIxFormsAsyncExecute.Create(Application);
  Result := frmADGUIxFormsAsyncExecute;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsAsyncExecuteImpl.Execute(AShow: Boolean;
  const AExecutor: IADStanAsyncExecutor);
begin
  if not ADGUIxSilent() then
    GetForm.Execute(AShow, AExecutor);
end;

{-------------------------------------------------------------------------------}
function TADGUIxFormsAsyncExecuteImpl.IsFormActive: Boolean;
begin
  Result := not ADGUIxSilent() and GetForm.IsFormActive;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFormsAsyncExecuteImpl.IsFormMouseMessage(
  const AMsg: TMsg): Boolean;
begin
  Result := not ADGUIxSilent() and GetForm.IsFormMouseMessage(AMsg);
end;

{-------------------------------------------------------------------------------}
function TADGUIxFormsAsyncExecuteImpl.GetOnHide: TNotifyEvent;
begin
  Result := GetForm.OnHide;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFormsAsyncExecuteImpl.GetOnShow: TNotifyEvent;
begin
  Result := GetForm.OnShow;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsAsyncExecuteImpl.SetOnHide(const AValue: TNotifyEvent);
begin
  if Assigned(AValue) or Assigned(frmADGUIxFormsAsyncExecute) then
    GetForm.OnHide := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsAsyncExecuteImpl.SetOnShow(const AValue: TNotifyEvent);
begin
  if Assigned(AValue) or Assigned(frmADGUIxFormsAsyncExecute) then
    GetForm.OnShow := AValue;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFormsAsyncExecuteImpl.GetCaption: String;
begin
  Result := GetForm.Caption;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsAsyncExecuteImpl.SetCaption(const AValue: String);
begin
  if (AValue <> '') or Assigned(frmADGUIxFormsAsyncExecute) then
    GetForm.Caption := AValue;
end;

{-------------------------------------------------------------------------------}
initialization
  TADSingletonFactory.Create(TADGUIxFormsAsyncExecuteImpl, IADGUIxAsyncExecuteDialog);

end.
