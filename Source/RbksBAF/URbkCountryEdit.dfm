inherited FmRbkCountryEdit: TFmRbkCountryEdit
  Left = 386
  Top = 262
  Caption = 'Редактирование'
  ClientHeight = 208
  ClientWidth = 486
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnBtn: TPanel
    Top = 168
    Width = 486
    inherited Panel1: TPanel
      Left = 309
    end
  end
  inherited PnEdit: TPanel
    Width = 486
    Height = 168
    object LbCode: TLabel [0]
      Left = 78
      Top = 14
      Width = 22
      Height = 13
      Caption = 'Код:'
    end
    object LbName: TLabel [1]
      Left = 47
      Top = 42
      Width = 53
      Height = 13
      Caption = 'Название:'
    end
    object lbName1: TLabel [2]
      Left = 8
      Top = 70
      Width = 92
      Height = 13
      Caption = 'Полное название:'
    end
    object lbAlfa2: TLabel [3]
      Left = 63
      Top = 98
      Width = 37
      Height = 13
      Caption = 'Сокр.1:'
    end
    object lbAlfa3: TLabel [4]
      Left = 63
      Top = 126
      Width = 37
      Height = 13
      Caption = 'Сокр.2:'
    end
    inherited PnFilter: TPanel
      Top = 149
      Width = 486
    end
    object EdCode: TEdit
      Left = 106
      Top = 11
      Width = 185
      Height = 21
      MaxLength = 30
      TabOrder = 1
    end
    object EdName: TEdit
      Left = 106
      Top = 39
      Width = 246
      Height = 21
      MaxLength = 45
      TabOrder = 2
    end
    object EdName1: TEdit
      Left = 106
      Top = 67
      Width = 372
      Height = 21
      MaxLength = 250
      TabOrder = 3
    end
    object EdAlfa2: TEdit
      Left = 106
      Top = 94
      Width = 121
      Height = 21
      MaxLength = 2
      TabOrder = 4
    end
    object EdAlfa3: TEdit
      Left = 106
      Top = 122
      Width = 121
      Height = 21
      MaxLength = 3
      TabOrder = 5
    end
  end
  inherited IBQ: TIBQuery
    Left = 256
    Top = 5
  end
  inherited Trans: TIBTransaction
    Left = 288
    Top = 5
  end
end
