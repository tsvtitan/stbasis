inherited fmRbkATEEdit: TfmRbkATEEdit
  Left = 224
  Top = 168
  Caption = 'fmRbkATEEdit'
  ClientHeight = 211
  ClientWidth = 429
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnEdit: TPanel [0]
    Width = 429
    Height = 171
    object lbCode: TLabel [0]
      Left = 60
      Top = 19
      Width = 22
      Height = 13
      Alignment = taRightJustify
      Caption = 'Код:'
    end
    object LbName: TLabel [1]
      Left = 29
      Top = 46
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = 'Название:'
    end
    object LbSmallName: TLabel [2]
      Left = 51
      Top = 73
      Width = 31
      Height = 13
      Alignment = taRightJustify
      Caption = 'Сокр.:'
    end
    object LbPostIndex: TLabel [3]
      Left = 13
      Top = 126
      Width = 69
      Height = 13
      Alignment = taRightJustify
      Caption = 'Почт. индекс:'
    end
    object LbGNINMB: TLabel [4]
      Left = 33
      Top = 99
      Width = 49
      Height = 13
      Caption = 'ГНИНМБ:'
    end
    inherited PnFilter: TPanel
      Top = 152
      Width = 429
      TabOrder = 5
    end
    object EdCode: TEdit
      Left = 89
      Top = 15
      Width = 135
      Height = 21
      MaxLength = 11
      TabOrder = 0
    end
    object EdName: TEdit
      Left = 89
      Top = 42
      Width = 320
      Height = 21
      MaxLength = 40
      TabOrder = 1
    end
    object EdSocr: TEdit
      Left = 89
      Top = 69
      Width = 135
      Height = 21
      MaxLength = 10
      TabOrder = 2
    end
    object EdPostIndex: TMaskEdit
      Left = 89
      Top = 122
      Width = 135
      Height = 21
      EditMask = '000000;0; '
      MaxLength = 6
      TabOrder = 4
    end
    object EdGNINMB: TMaskEdit
      Left = 89
      Top = 95
      Width = 135
      Height = 21
      EditMask = '0000;1; '
      MaxLength = 4
      TabOrder = 3
      Text = '    '
    end
  end
  inherited PnBtn: TPanel [1]
    Top = 171
    Width = 429
    inherited Panel1: TPanel
      Left = 252
    end
  end
  inherited IBQ: TIBQuery
    Left = 272
    Top = 5
  end
  inherited Trans: TIBTransaction
    Left = 312
    Top = 5
  end
end
