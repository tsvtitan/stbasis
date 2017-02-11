unit fLoginDemo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ExtCtrls, Buttons, ComCtrls,
  daADStanIntf, daADStanOption, daADStanDef,
  daADGUIxFormsfLogin, daADGUIxFormsWait,
  daADPhysIntf,
  daADCompClient, fMainCompBase, jpeg;

type
  TForm1 = class(TfrmMainCompBase)
    btnConnect:               TSpeedButton;
    btnDisconnect:            TSpeedButton;
    chLoginPrompt:            TCheckBox;
    Label3:                   TLabel;
    Bevel1:                   TBevel;
    chChangePassword:         TCheckBox;
    chHistory:                TCheckBox;
    edLoginRetries:           TLabeledEdit;
    udLoginRetries:           TUpDown;
    mmVisibleItems:           TMemo;
    Label1:                   TLabel;
    chHistoryWithPassword:    TCheckBox;
    Memo1:                    TMemo;
    procedure btnConnectClick(Sender: TObject);
    procedure btnDisconnectClick(Sender: TObject);
    procedure cbDBClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  dmMainComp;

{$R *.dfm}

procedure TForm1.btnConnectClick(Sender: TObject);
begin
  btnDisconnectClick(nil);
  dmlMainComp.dbMain.Connected := True;
end;

procedure TForm1.btnDisconnectClick(Sender: TObject);
begin
  dmlMainComp.dbMain.Connected := False;
end;

procedure TForm1.cbDBClick(Sender: TObject);
begin
  with dmlMainComp do begin
    dbMain.LoginPrompt := chLoginPrompt.Checked;
    with ADGUIxFormsLoginDialog1 do begin
      ChangeExpiredPassword := chChangePassword.Checked;
      HistoryEnabled := chHistory.Checked;
      HistoryWithPassword := chHistoryWithPassword.Checked;
      LoginRetries := udLoginRetries.Position;
      VisibleItems.Assign(mmVisibleItems.Lines);
    end;
    inherited cbDBClick(Sender);
  end;
end;

end.
