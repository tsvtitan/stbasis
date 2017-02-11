inherited FPAFilter: TFPAFilter
  Left = 336
  Top = 193
  Caption = 'Фильтр'
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel1: TPanel
    inherited RBAct: TRadioButton
      Checked = False
      TabStop = False
    end
  end
  object BClear: TButton [15]
    Left = 8
    Top = 368
    Width = 75
    Height = 25
    Caption = 'Очистить'
    TabOrder = 9
    OnClick = BClearClick
  end
  object CheckBox: TCheckBox [16]
    Left = 8
    Top = 336
    Width = 193
    Height = 17
    Caption = 'Фильтр по вхождению строки'
    TabOrder = 10
  end
  inherited IBTable: TIBTable
    Left = 216
  end
end
