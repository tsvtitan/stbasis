inherited FChooseDoc: TFChooseDoc
  Left = 359
  Top = 241
  Caption = 'Кассовые ордера'
  ClientHeight = 125
  ClientWidth = 206
  OldCreateOrder = True
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  inherited BOk: TButton
    Left = 40
    Top = 96
    TabOrder = 1
  end
  inherited BCancel: TButton
    Left = 128
    Top = 96
    TabOrder = 2
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 193
    Height = 73
    Caption = 'Документ'
    TabOrder = 0
    object LBCO: TListBox
      Left = 8
      Top = 24
      Width = 169
      Height = 33
      ItemHeight = 13
      Items.Strings = (
        'Приходный кассовый ордер'
        'Расходный кассовый ордер')
      TabOrder = 0
      OnKeyDown = FormKeyDown
    end
  end
end
