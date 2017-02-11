inherited FmRbkBankEdit: TFmRbkBankEdit
  Caption = 'FmRbkBankEdit'
  ClientHeight = 246
  ClientWidth = 418
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnBtn: TPanel
    Top = 206
    Width = 418
    inherited Panel1: TPanel
      Left = 241
    end
  end
  inherited PnEdit: TPanel
    Width = 418
    Height = 206
    object LbName: TLabel [0]
      Left = 19
      Top = 16
      Width = 53
      Height = 13
      Caption = 'Название:'
    end
    object LbBik: TLabel [1]
      Left = 19
      Top = 88
      Width = 22
      Height = 13
      Caption = 'Бик:'
    end
    object LbBikrkc: TLabel [2]
      Left = 19
      Top = 124
      Width = 44
      Height = 13
      Caption = 'Бик РКЦ'
    end
    object LbkorAccount: TLabel [3]
      Left = 19
      Top = 160
      Width = 56
      Height = 13
      Caption = 'Корр. счет:'
    end
    object LbAddress: TLabel [4]
      Left = 19
      Top = 52
      Width = 34
      Height = 13
      Caption = 'Адрес:'
    end
    inherited PnFilter: TPanel
      Top = 187
      Width = 418
    end
    object EdName: TEdit
      Left = 98
      Top = 12
      Width = 300
      Height = 21
      TabOrder = 1
    end
    object EdAddress: TEdit
      Left = 98
      Top = 48
      Width = 300
      Height = 21
      TabOrder = 2
    end
    object EdBik: TEdit
      Left = 98
      Top = 84
      Width = 121
      Height = 21
      MaxLength = 9
      TabOrder = 3
    end
    object EdBikRkc: TEdit
      Left = 98
      Top = 120
      Width = 121
      Height = 21
      MaxLength = 9
      TabOrder = 4
    end
    object EdKorAccount: TEdit
      Left = 98
      Top = 156
      Width = 121
      Height = 21
      MaxLength = 20
      TabOrder = 5
    end
  end
  inherited IBQ: TIBQuery
    Left = 192
    Top = 65525
  end
  inherited Trans: TIBTransaction
    Left = 152
    Top = 65533
  end
end
