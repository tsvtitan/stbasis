inherited FCBFilter: TFCBFilter
  Left = 448
  Top = 163
  Caption = 'Фильтр'
  ClientHeight = 174
  ClientWidth = 295
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 16
    Top = 24
    Width = 30
    Height = 13
    Caption = 'Текст'
  end
  inherited BOk: TButton
    Left = 128
    Top = 144
    TabOrder = 2
  end
  inherited BCancel: TButton
    Left = 216
    Top = 144
    TabOrder = 3
  end
  object BClear: TButton
    Left = 8
    Top = 144
    Width = 75
    Height = 25
    Caption = 'Очистить'
    TabOrder = 4
    OnClick = BClearClick
  end
  object Edit: TEdit
    Left = 16
    Top = 48
    Width = 257
    Height = 21
    TabOrder = 0
  end
  object CheckBox: TCheckBox
    Left = 8
    Top = 112
    Width = 177
    Height = 17
    Caption = 'Фильтр по вхождению строки'
    TabOrder = 1
  end
end
