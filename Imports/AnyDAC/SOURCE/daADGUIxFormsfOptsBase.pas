{ --------------------------------------------------------------------------- }
{ AnyDAC Base dialog form                                                     }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I daAD.inc}

unit daADGUIxFormsfOptsBase;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  StdCtrls, ExtCtrls, ComCtrls, Registry, daADGUIxFormsControls;

type
  TfrmADGUIxFormsOptsBase = class(TForm)
    pnlButtons: TADGUIxFormsPanel;
    pnlMain: TADGUIxFormsPanel;
    btnOk: TButton;
    btnCancel: TButton;
    pnlGray: TADGUIxFormsPanel;
    pnlOptions: TADGUIxFormsPanel;
    pnlTitle: TADGUIxFormsPanel;
    pnlTitleBottomLine: TADGUIxFormsPanel;
    lblTitle: TLabel;
  protected
    procedure LoadFormState(AReg: TRegistry); virtual;
    procedure SaveFormState(AReg: TRegistry); virtual;
  public
    procedure LoadState;
    procedure SaveState;
  end;

var
  frmADGUIxFormsOptsBase: TfrmADGUIxFormsOptsBase;

implementation

{$R *.dfm}

uses
  daADStanConst;

{------------------------------------------------------------------------------}
{ TfrmADGUIxFormsOptsBase                                                      }
{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsOptsBase.LoadFormState(AReg: TRegistry);
var
  eWinState: TWindowState;
begin
  eWinState := TWindowState(AReg.ReadInteger('State'));
  if eWinState = wsNormal then begin
    Position := poDesigned;
    Width := AReg.ReadInteger('Width');
    Height := AReg.ReadInteger('Height');
    Top := AReg.ReadInteger('Top');
    Left := AReg.ReadInteger('Left');
  end
  else if eWinState = wsMaximized then
    WindowState := wsMaximized;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsOptsBase.SaveFormState(AReg: TRegistry);
begin
  AReg.WriteInteger('State', Integer(WindowState));
  if WindowState = wsNormal then begin
    AReg.WriteInteger('Width', Width);
    AReg.WriteInteger('Height', Height);
    AReg.WriteInteger('Top', Top);
    AReg.WriteInteger('Left', Left);
  end;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsOptsBase.LoadState;
var
  oReg: TRegistry;
begin
  oReg := TRegistry.Create(KEY_READ);
  try
    oReg.RootKey := HKEY_CURRENT_USER;
    Position := poScreenCenter;
    if oReg.OpenKey(S_AD_CfgKeyName + '\' + Name, False) then
      LoadFormState(oReg);
  except
  end;
  oReg.Free;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsOptsBase.SaveState;
var
  oReg: TRegistry;
begin
  oReg := TRegistry.Create(KEY_WRITE);
  try
    oReg.RootKey := HKEY_CURRENT_USER;
    if oReg.OpenKey(S_AD_CfgKeyName + '\' + Name, True) then
      SaveFormState(oReg);
  except
  end;
  oReg.Free;
end;

end.
