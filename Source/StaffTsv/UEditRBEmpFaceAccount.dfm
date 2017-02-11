inherited fmEditRBEmpFaceAccount: TfmEditRBEmpFaceAccount
  Caption = 'fmEditRBEmpFaceAccount'
  ClientHeight = 199
  ClientWidth = 266
  PixelsPerInch = 96
  TextHeight = 13
  object lbNum: TLabel [0]
    Left = 31
    Top = 15
    Width = 26
    Height = 13
    Caption = 'Счет:'
  end
  object lbPercent: TLabel [1]
    Left = 11
    Top = 95
    Width = 46
    Height = 13
    Caption = 'Процент:'
  end
  object lbSumm: TLabel [2]
    Left = 20
    Top = 121
    Width = 37
    Height = 13
    Caption = 'Сумма:'
  end
  object lbBank: TLabel [3]
    Left = 29
    Top = 40
    Width = 28
    Height = 13
    Caption = 'Банк:'
  end
  object lbCurrency: TLabel [4]
    Left = 16
    Top = 67
    Width = 41
    Height = 13
    Caption = 'Валюта:'
  end
  inherited pnBut: TPanel
    Top = 161
    Width = 266
    TabOrder = 8
    inherited Panel2: TPanel
      Left = 81
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 145
    TabOrder = 7
  end
  object edNum: TEdit [7]
    Left = 64
    Top = 11
    Width = 190
    Height = 21
    MaxLength = 30
    TabOrder = 0
    OnChange = edBankChange
    OnKeyPress = edNumKeyPress
  end
  object edPercent: TEdit [8]
    Left = 64
    Top = 91
    Width = 96
    Height = 21
    MaxLength = 30
    TabOrder = 5
    OnChange = edBankChange
    OnKeyPress = edPercentKeyPress
  end
  object edSumm: TEdit [9]
    Left = 64
    Top = 117
    Width = 96
    Height = 21
    MaxLength = 30
    TabOrder = 6
    OnChange = edBankChange
    OnKeyPress = edPercentKeyPress
  end
  object edBank: TEdit [10]
    Left = 64
    Top = 37
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 1
    OnChange = edBankChange
  end
  object bibBank: TBitBtn [11]
    Left = 233
    Top = 37
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 2
    OnClick = bibBankClick
  end
  object edCurrency: TEdit [12]
    Left = 64
    Top = 64
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 3
    OnChange = edBankChange
  end
  object bibCurrency: TBitBtn [13]
    Left = 233
    Top = 64
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 4
    OnClick = bibCurrencyClick
  end
  inherited IBTran: TIBTransaction
    Left = 64
    Top = 161
  end
end
