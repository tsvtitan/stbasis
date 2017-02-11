{ --------------------------------------------------------------------------- }
{ AnyDAC VCL About dialog                                                     }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I daAD.inc}

unit daADGUIxFormsfAbout;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  StdCtrls, ExtCtrls, ComCtrls,
  daADGUIxFormsfOptsBase, daADGUIxFormsControls;

type
  { ------------------------------------------------------------------------- }
  { TfrmADGUIxFormsAbout                                                      }
  { ------------------------------------------------------------------------- }
  TfrmADGUIxFormsAbout = class(TfrmADGUIxFormsOptsBase)
    lblProductName: TLabel;
    lblVersion: TLabel;
    lblCopyright: TLabel;
    lblInternetLink: TLabel;
    Panel1: TADGUIxFormsPanel;
    imLogo: TImage;
    imgGradient: TImage;
    procedure lblInternetLinkClick(Sender: TObject);
  private
    { Private declarations }
    procedure Setup(AModHInst: THandle; const ACaption: String);
  public
    { Public declarations }
    class procedure Execute(AModHInst: THandle = 0; const ACaption: String = '');
  end;

var
  frmADGUIxFormsAbout: TfrmADGUIxFormsAbout;

implementation

uses
  ShellAPI,
  daADStanUtil, daADStanResStrs;

{$R *.dfm}

{ ------------------------------------------------------------------------- }
{ TfrmADGUIxFormsAbout                                                      }
{ ------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsAbout.Setup(AModHInst: THandle; const ACaption: String);
var
  sMod, sProduct, sVersion, sVersionName, sCopyright, sInfo: String;
{$IFNDEF AnyDAC_D6}
  ModName: array[0..MAX_PATH] of Char;
{$ENDIF}
begin
  if AModHInst = 0 then
    AModHInst := HInstance;
{$IFDEF AnyDAC_D6}
  sMod := GetModuleName(AModHInst);
{$ELSE}
  SetString(sMod, ModName, GetModuleFileName(AModHInst, ModName, SizeOf(ModName)));
{$ENDIF}
  ADGetVersionInfo(sMod, sProduct, sVersion, sVersionName, sCopyright, sInfo);
  if ACaption = '' then
    Caption := Format(S_AD_ProductAbout, [sProduct])
  else
    Caption := ACaption;
  lblProductName.Caption := sProduct;
  lblVersion.Caption := sVersionName;
  lblCopyright.Caption := sCopyright;
  lblInternetLink.Caption := sInfo;
end;

{ ------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsAbout.lblInternetLinkClick(Sender: TObject);
begin
  if lblInternetLink.Caption <> '' then
    ShellExecute(Handle, 'open', PChar(lblInternetLink.Caption), nil, nil, SW_SHOW);
end;

{ ------------------------------------------------------------------------- }
class procedure TfrmADGUIxFormsAbout.Execute(AModHInst: THandle = 0;
  const ACaption: String = '');
var
  oFrm: TfrmADGUIxFormsAbout;
begin
  oFrm := TfrmADGUIxFormsAbout.Create(nil);
  oFrm.Setup(AModHInst, ACaption);
  try
    oFrm.ShowModal;
  finally
    oFrm.Free;
  end;
end;

end.
