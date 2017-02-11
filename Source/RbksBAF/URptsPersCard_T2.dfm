inherited fmRptsCard_T2: TfmRptsCard_T2
  Left = 248
  Top = 285
  Caption = 'Личная карточка (Форма Т-2)'
  ClientHeight = 117
  PixelsPerInch = 96
  TextHeight = 13
  object LbEmp: TLabel [0]
    Left = 16
    Top = 23
    Width = 56
    Height = 13
    Caption = 'Сотрудник:'
  end
  inherited pnBut: TPanel
    Top = 79
  end
  inherited cbInString: TCheckBox
    Top = 60
  end
  object EdEmp: TEdit [3]
    Left = 76
    Top = 19
    Width = 262
    Height = 21
    Color = clMenu
    TabOrder = 2
  end
  object BtCallEmp: TButton [4]
    Left = 338
    Top = 19
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 3
    OnClick = BtCallEmpClick
  end
end
