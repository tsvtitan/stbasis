{ --------------------------------------------------------------------------- }
{ AnyDAC Explorer options user interface                                      }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
//ByUsers
//ByObjType

{$I daAD.inc}

unit fOptions;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Buttons,
  daADGUIxFormsfOptsBase, daADGUIxFormsControls;

type
  TfrmOptions = class(TfrmADGUIxFormsOptsBase)
    pnlBDEDefaults: TADGUIxFormsPanel;
    cbEnableBCD: TCheckBox;
    cbEnableIntegers: TCheckBox;
    cbOverwriteConnDef: TCheckBox;
    pnlGeneral: TADGUIxFormsPanel;
    Label1: TLabel;
    cbxHierarchy: TComboBox;
    cbConfirmations: TCheckBox;
    cbTracing: TCheckBox;
    cbDblclickMemo: TCheckBox;
    pnlContainer: TADGUIxFormsPanel;
    tcPages: TADGUIxFormsTabControl;
    pnlData: TADGUIxFormsPanel;
    pnlBottomSep: TADGUIxFormsPanel;
    pnlRightSep: TADGUIxFormsPanel;
    pnlLeftSep: TADGUIxFormsPanel;
    procedure tcPagesChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function Execute(var AHierachy: String; var AConfirmations, ATracing,
      daADblclickMemo, ABDEEnableBCD, ABDEEnableIntegers, ABDEOverwriteConnDef: Boolean): Boolean;
  end;

var
  frmOptions: TfrmOptions;

implementation

{$R *.dfm}

{ --------------------------------------------------------------------------- }
class function TfrmOptions.Execute(var AHierachy: String; var AConfirmations,
  ATracing, daADblclickMemo, ABDEEnableBCD, ABDEEnableIntegers, ABDEOverwriteConnDef: Boolean): Boolean;
begin
  if frmOptions = nil then
    frmOptions := TfrmOptions.Create(Application);
  with frmOptions do begin
    if CompareText('ByUsers', AHierachy) = 0 then
      cbxHierarchy.ItemIndex := 0
    else if CompareText('ByObjType', AHierachy) = 0 then
      cbxHierarchy.ItemIndex := 1
    else
      cbxHierarchy.ItemIndex := -1;
    cbConfirmations.Checked := AConfirmations;
    cbTracing.Checked := ATracing;
    cbDblclickMemo.Checked := daADblclickMemo;
    cbEnableBCD.Checked := ABDEEnableBCD;
    cbEnableIntegers.Checked := ABDEEnableIntegers;
    cbOverwriteConnDef.Checked := ABDEOverwriteConnDef;
    Result := (ShowModal = mrOK);
    if Result then begin
      case cbxHierarchy.ItemIndex of
      0:   AHierachy := 'ByUsers';
      1:   AHierachy := 'ByObjType';
      else AHierachy := '';
      end;
      AConfirmations := cbConfirmations.Checked;
      ATracing := cbTracing.Checked;
      daADblclickMemo := cbDblclickMemo.Checked;
      ABDEEnableBCD := cbEnableBCD.Checked;
      ABDEEnableIntegers := cbEnableIntegers.Checked;
      ABDEOverwriteConnDef := cbOverwriteConnDef.Checked;
    end;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmOptions.tcPagesChange(Sender: TObject);
begin
  if tcPages.TabIndex = 0 then begin
    pnlGeneral.Visible := True;
    pnlBDEDefaults.Visible := False;
  end
  else begin
    pnlBDEDefaults.Visible := True;
    pnlGeneral.Visible := False;
  end;
end;

end.
