unit UAlignPalette;

interface

uses
  Windows, Messages, SysUtils, Classes, Buttons, Menus, Controls, ExtCtrls,
  Forms, tsvDesignForm, ELDsgnr;

type

  TAlignPalette = class(TForm)
    Panel1: TPanel;
    bnLeft: TSpeedButton;
    bnHCenter: TSpeedButton;
    bnHWinCenter: TSpeedButton;
    bnHSpace: TSpeedButton;
    bnRight: TSpeedButton;
    bnBottom: TSpeedButton;
    bnVSpace: TSpeedButton;
    bnVWinCenter: TSpeedButton;
    bnVCenter: TSpeedButton;
    bnTop: TSpeedButton;
    procedure bnLeftClick(Sender: TObject);
    procedure bnRightClick(Sender: TObject);
    procedure bnTopClick(Sender: TObject);
    procedure bnBottomClick(Sender: TObject);
    procedure bnHCenterClick(Sender: TObject);
    procedure bnVCenterClick(Sender: TObject);
    procedure bnHWinCenterClick(Sender: TObject);
    procedure bnVWinCenterClick(Sender: TObject);
    procedure bnHSpaceClick(Sender: TObject);
    procedure bnVSpaceClick(Sender: TObject);
  private
    LocalDSB: TDesignScrollBox;
    function Check: Boolean;
  public
    procedure  SetLocalDSB(DSB: TDesignScrollBox);
  end;

implementation

{$R *.DFM}

procedure TAlignPalette.SetLocalDSB(DSB: TDesignScrollBox);
begin
  if DSB=nil then exit;
  LocalDSB:=DSB;
end;

function TAlignPalette.Check: Boolean;
begin
  Result:=false;
  if LocalDSB=nil then exit;
  if LocalDSB.ActiveDesignForm=nil then exit;
  Result:=LocalDSB.ActiveDesignForm.Designer<>nil;
end;

procedure TAlignPalette.bnLeftClick(Sender: TObject);
begin
  if Check then
    LocalDSB.ActiveDesignForm.ELDesigner.SelectedControls.AlignSelection(asLeft);
end;

procedure TAlignPalette.bnRightClick(Sender: TObject);
begin
  if Check then
    LocalDSB.ActiveDesignForm.ELDesigner.SelectedControls.AlignSelection(asRight);
end;

procedure TAlignPalette.bnTopClick(Sender: TObject);
begin
  if Check then
    LocalDSB.ActiveDesignForm.ELDesigner.SelectedControls.AlignSelection(asTop);
end;

procedure TAlignPalette.bnBottomClick(Sender: TObject);
begin
  if Check then
    LocalDSB.ActiveDesignForm.ELDesigner.SelectedControls.AlignSelection(asBottom);
end;

procedure TAlignPalette.bnHCenterClick(Sender: TObject);
begin
  if Check then
    LocalDSB.ActiveDesignForm.ELDesigner.SelectedControls.AlignSelection(asHorCenter);
end;

procedure TAlignPalette.bnVCenterClick(Sender: TObject);
begin
  if Check then
    LocalDSB.ActiveDesignForm.ELDesigner.SelectedControls.AlignSelection(asVerCenter);
end;

procedure TAlignPalette.bnHWinCenterClick(Sender: TObject);
begin
  if Check then
    LocalDSB.ActiveDesignForm.ELDesigner.SelectedControls.AlignSelection(asHorInWin);
end;

procedure TAlignPalette.bnVWinCenterClick(Sender: TObject);
begin
  if Check then
    LocalDSB.ActiveDesignForm.ELDesigner.SelectedControls.AlignSelection(asVerInWin);
end;

procedure TAlignPalette.bnHSpaceClick(Sender: TObject);
begin
  if Check then
    LocalDSB.ActiveDesignForm.ELDesigner.SelectedControls.AlignSelection(asHorSpace);
end;

procedure TAlignPalette.bnVSpaceClick(Sender: TObject);
begin
  if Check then
    LocalDSB.ActiveDesignForm.ELDesigner.SelectedControls.AlignSelection(asVerSpace);
end;

end.
