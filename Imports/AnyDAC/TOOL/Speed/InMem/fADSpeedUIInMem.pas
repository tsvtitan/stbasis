{ --------------------------------------------------------------------------- }
{ AnyDAC Speed Tester - inmemory main form                                    }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I ..\ADSpeed.inc}

unit fADSpeedUIInMem;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fADSpeedUI, ImgList, Menus, ActnList, ComCtrls, ToolWin,
  ExtCtrls, Grids, StdCtrls, daADGUIxFormsControls;

type
  TADSpeedUIInMemFrm = class(TADSpeedUIFrm)
    Label3: TLabel;
    ToolButton1: TToolButton;
    edtRecordCount: TEdit;
    cbUseBatch: TCheckBox;
    ToolButton2: TToolButton;
    procedure edtRecordCountKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtRecordCountExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbUseBatchClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ADSpeedUIInMemFrm: TADSpeedUIInMemFrm;

implementation

{$R *.dfm}

uses
  ADSpeedBaseInMem;

{---------------------------------------------------------------------------}
{ TADSpeedUIInMemFrm                                                        }
{---------------------------------------------------------------------------}
procedure TADSpeedUIInMemFrm.FormCreate(Sender: TObject);
begin
  inherited;
  cbUseBatch.OnClick := nil;
  cbUseBatch.Checked := G_AD_UseBatch;
  cbUseBatch.OnClick := cbUseBatchClick;
  edtRecordCount.Text := IntToStr(TADSpeedInMemTestManager(FMgr).RecordCount);
end;

{---------------------------------------------------------------------------}
procedure TADSpeedUIInMemFrm.edtRecordCountKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then begin
    edtRecordCountExit(nil);
    Key := 0;
  end;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedUIInMemFrm.edtRecordCountExit(Sender: TObject);
begin
  TADSpeedInMemTestManager(FMgr).RecordCount := StrToInt(edtRecordCount.Text);
  LoadTestsInfo;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedUIInMemFrm.cbUseBatchClick(Sender: TObject);
begin
  MessageDlg('Batch setting will take effect only if here was no test runs',
    mtWarning, [mbOK], 0);
  G_AD_UseBatch := cbUseBatch.Checked;
  FMgr.ClearTests;
end;

end.
