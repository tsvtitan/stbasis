inherited fmEditRBTaxesType: TfmEditRBTaxesType
  Left = 325
  Top = 261
  Caption = 'fmEditRBTypeTaxes'
  ClientHeight = 164
  ClientWidth = 373
  PixelsPerInch = 96
  TextHeight = 13
  object lbTaxesType: TLabel [0]
    Left = 6
    Top = 11
    Width = 79
    Height = 13
    Caption = 'Наименование:'
  end
  inherited pnBut: TPanel
    Top = 126
    Width = 373
    TabOrder = 2
    inherited Panel2: TPanel
      Left = 188
    end
  end
  inherited cbInString: TCheckBox
    Left = 0
    Top = 106
  end
  object edNameTaxes: TEdit [3]
    Left = 88
    Top = 7
    Width = 273
    Height = 21
    MaxLength = 100
    TabOrder = 0
    OnChange = edNameTaxesChange
  end
  object RGStatusTaxes: TRadioGroup [4]
    Left = 88
    Top = 32
    Width = 273
    Height = 73
    Caption = '  Вид налога  '
    ItemIndex = 0
    Items.Strings = (
      'налоги с физических лиц'
      'налоги с юридических лиц'
      'все налоги')
    TabOrder = 3
    OnClick = edNameTaxesChange
    OnEnter = edNameTaxesChange
  end
  inherited IBTran: TIBTransaction
    Left = 8
    Top = 41
  end
end
