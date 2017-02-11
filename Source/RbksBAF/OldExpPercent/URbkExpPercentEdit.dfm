inherited FmRbkExpPercentEdit: TFmRbkExpPercentEdit
  Caption = 'FmRbkExpPercentEdit'
  ClientHeight = 165
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnBtn: TPanel
    Top = 125
  end
  inherited PnEdit: TPanel
    Height = 125
    object LbTypePay: TLabel [0]
      Left = 16
      Top = 21
      Width = 62
      Height = 13
      Caption = 'Вид оплаты:'
    end
    object LbExperience: TLabel [1]
      Left = 49
      Top = 51
      Width = 29
      Height = 13
      Caption = 'Стаж:'
    end
    object LbPercent: TLabel [2]
      Left = 32
      Top = 80
      Width = 46
      Height = 13
      Caption = 'Процент:'
    end
    inherited PnFilter: TPanel
      Top = 106
    end
    object EdTypePay: TEdit
      Left = 88
      Top = 17
      Width = 199
      Height = 21
      Color = clMenu
      TabOrder = 1
    end
    object BtCallTypePay: TButton
      Left = 287
      Top = 17
      Width = 21
      Height = 21
      Caption = '...'
      TabOrder = 2
      OnClick = BtCallTypePayClick
    end
    object EdExperience: TMaskEdit
      Left = 88
      Top = 47
      Width = 102
      Height = 21
      TabOrder = 3
      OnChange = EdExperienceChange
    end
    object EdPercent: TMaskEdit
      Left = 88
      Top = 76
      Width = 102
      Height = 21
      TabOrder = 4
      OnChange = EdExperienceChange
    end
  end
  inherited IBQ: TIBQuery
    Left = 8
    Top = 133
  end
  inherited Trans: TIBTransaction
    Left = 8
    Top = 173
  end
end
