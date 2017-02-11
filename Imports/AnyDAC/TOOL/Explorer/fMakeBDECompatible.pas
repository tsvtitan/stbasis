{ --------------------------------------------------------------------------- }
{ AnyDAC Explorer Make ConnectionDef BDE compatible dialog                    }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I daAD.inc}

unit fMakeBDECompatible;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls,
  daADStanIntf,
  daADGUIxFormsfOptsBase;

type
  TfrmMakeBDECompatible = class(TfrmADGUIxFormsOptsBase)
    cbEnableBCD: TCheckBox;
    cbEnableIntegers: TCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
    class function Execute(const AConnectionDef: IADStanConnectionDef;
      ABDEEnableBCD, ABDEEnableIntegers: Boolean): Boolean;
  end;

var
  frmMakeBDECompatible: TfrmMakeBDECompatible;

implementation

{$R *.dfm}

uses
  daADCompBDEAliasImport;

{ --------------------------------------------------------------------------- }
{ TfrmMakeBDECompatible                                                       }
{ --------------------------------------------------------------------------- }
class function TfrmMakeBDECompatible.Execute(
  const AConnectionDef: IADStanConnectionDef; ABDEEnableBCD,
  ABDEEnableIntegers: Boolean): Boolean;
var
  oMig: TADBDEAliasImporter;
begin
  with TfrmMakeBDECompatible.Create(nil) do
  try
    cbEnableBCD.Checked := ABDEEnableBCD;
    cbEnableIntegers.Checked := ABDEEnableIntegers;
    Result := (ShowModal = mrOK);
    if Result then begin
      oMig := TADBDEAliasImporter.Create;
      try
        oMig.MakeBDECompatible(AConnectionDef, cbEnableBCD.Checked, cbEnableIntegers.Checked);
      finally
        oMig.Free;
      end;
    end;
  finally
    Free;
  end;
end;

end.

