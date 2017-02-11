inherited fmRptMemOrder5: TfmRptMemOrder5
  Left = 163
  Top = 174
  Caption = 'Ìולמנטאכüםûי מנהונ ¹5'
  ClientHeight = 110
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 54
    Top = 16
    Width = 41
    Height = 13
    Caption = 'Ïונטמה:'
  end
  inherited pnBut: TPanel
    Top = 72
  end
  inherited cbInString: TCheckBox
    Top = 47
  end
  object EdPeriod: TEdit [3]
    Left = 104
    Top = 12
    Width = 225
    Height = 21
    Color = clMenu
    ReadOnly = True
    TabOrder = 2
  end
  object BtCallPeriod: TButton [4]
    Left = 329
    Top = 12
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 3
    OnClick = BtCallPeriodClick
  end
  inherited IBTran: TIBTransaction
    Left = 360
    Top = 9
  end
  inherited Mainqr: TIBQuery
    Left = 392
    Top = 8
  end
end
