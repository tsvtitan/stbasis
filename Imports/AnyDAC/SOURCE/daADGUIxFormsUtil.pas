{ --------------------------------------------------------------------------- }
{ AnyDAC GUIx Forms layer utilities                                           }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I daAD.inc}

unit daADGUIxFormsUtil;

interface

uses
  Classes, StdCtrls;

function ADSetupEditor(ACombo: TComboBox; AEdit: TEdit; const AType: String): Boolean;

implementation

uses
  SysUtils,
  daADStanConst, daADStanUtil;

{-------------------------------------------------------------------------------}
function ADSetupEditor(ACombo: TComboBox; AEdit: TEdit; const AType: String): Boolean;
var
  i: Integer;
begin
  Result := True;
  if AType = '@L' then begin
    ACombo.Style := csDropDown;
    ACombo.Items.BeginUpdate;
    try
      ACombo.Items.Clear;
      ACombo.Items.Add(S_AD_True);
      ACombo.Items.Add(S_AD_False);
    finally
      ACombo.Items.EndUpdate;
    end;
    ACombo.Text := S_AD_False;
  end
  else if AType = '@Y' then begin
    ACombo.Style := csDropDown;
    ACombo.Items.BeginUpdate;
    try
      ACombo.Items.Clear;
      ACombo.Items.Add(S_AD_Yes);
      ACombo.Items.Add(S_AD_No);
    finally
      ACombo.Items.EndUpdate;
    end;
    ACombo.Text := S_AD_No;
  end
  else if AType = '@I' then begin
    //ACombo.Style := csSimple;
    //ACombo.Items.Clear;
    //ACombo.Text := '0';
    AEdit.Text := '0';
    Result := False;
  end
  else if (AType = '') or (AType = '@S') then begin
    //ACombo.Style := csSimple;
    //ACombo.Items.Clear;
    //ACombo.Text := '';
    AEdit.Text := '';
    Result := False;
  end
  else begin
    ACombo.Style := csDropDown;
    i := 1;
    ACombo.Items.BeginUpdate;
    try
      ACombo.Items.Clear;
      while i <= Length(AType) do
        ACombo.Items.Add(ADExtractFieldName(AType, i));
    finally
      ACombo.Items.EndUpdate;
    end;
    ACombo.Text := '';
  end;
end;

end.
