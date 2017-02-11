inherited FmRbkExpPercentEdit: TFmRbkExpPercentEdit
  Caption = 'FmRbkExpPercentEdit'
  ClientHeight = 116
  ClientWidth = 295
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnBtn: TPanel
    Top = 76
    Width = 295
    inherited Panel1: TPanel
      Left = 118
    end
  end
  inherited PnEdit: TPanel
    Width = 295
    Height = 76
    object LbExperience: TLabel [0]
      Left = 49
      Top = 13
      Width = 29
      Height = 13
      Caption = 'Стаж:'
    end
    object LbPercent: TLabel [1]
      Left = 32
      Top = 42
      Width = 46
      Height = 13
      Caption = 'Процент:'
    end
    inherited PnFilter: TPanel
      Top = 57
      Width = 295
    end
    object EdExperience: TMaskEdit
      Left = 88
      Top = 9
      Width = 102
      Height = 21
      TabOrder = 1
      OnChange = EdExperienceChange
    end
    object EdPercent: TMaskEdit
      Left = 88
      Top = 38
      Width = 102
      Height = 21
      TabOrder = 2
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
