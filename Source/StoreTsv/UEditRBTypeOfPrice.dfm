inherited fmEditRBTypeOfPrice: TfmEditRBTypeOfPrice
  Left = 531
  Caption = 'fmEditRBTypeOfPrice'
  ClientHeight = 197
  ClientWidth = 302
  PixelsPerInch = 96
  TextHeight = 13
  object lbName: TLabel [0]
    Left = 6
    Top = 13
    Width = 79
    Height = 13
    Caption = 'Наименование:'
  end
  object lbNote: TLabel [1]
    Left = 18
    Top = 36
    Width = 66
    Height = 13
    Caption = 'Примечание:'
  end
  object lbTradingPay: TLabel [2]
    Left = 112
    Top = 99
    Width = 96
    Height = 13
    Caption = 'Торговая наценка:'
  end
  object lbTaxFromSale: TLabel [3]
    Left = 124
    Top = 126
    Width = 84
    Height = 13
    Caption = 'Налог с продаж:'
  end
  inherited pnBut: TPanel
    Top = 159
    Width = 302
    TabOrder = 5
    inherited Panel2: TPanel
      Left = 117
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 143
    TabOrder = 4
  end
  object edName: TEdit [6]
    Left = 92
    Top = 9
    Width = 199
    Height = 21
    MaxLength = 100
    TabOrder = 0
    OnChange = edNameChange
  end
  object meNote: TMemo [7]
    Left = 92
    Top = 35
    Width = 199
    Height = 55
    TabOrder = 1
    OnChange = edNameChange
  end
  object edTradingPay: TEdit [8]
    Left = 217
    Top = 95
    Width = 74
    Height = 21
    BiDiMode = bdRightToLeft
    MaxLength = 15
    ParentBiDiMode = False
    TabOrder = 2
    Text = '0'
    OnChange = edNameChange
    OnKeyPress = edTaxFromSaleKeyPress
  end
  object edTaxFromSale: TEdit [9]
    Left = 217
    Top = 122
    Width = 74
    Height = 21
    BiDiMode = bdRightToLeft
    MaxLength = 15
    ParentBiDiMode = False
    TabOrder = 3
    Text = '0'
    OnChange = edNameChange
    OnKeyPress = edTaxFromSaleKeyPress
  end
  inherited IBTran: TIBTransaction
    Left = 211
    Top = 26
  end
end
