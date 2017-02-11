inherited fmEditRBCorrectPost: TfmEditRBCorrectPost
  Left = 305
  Top = 223
  Caption = 'fmEditRBCorrectPost'
  ClientHeight = 152
  ClientWidth = 362
  PixelsPerInch = 96
  TextHeight = 13
  object LDebit: TLabel [0]
    Left = 40
    Top = 16
    Width = 35
    Height = 13
    Caption = 'Дебет:'
  end
  object LKredit: TLabel [1]
    Left = 36
    Top = 40
    Width = 39
    Height = 13
    Caption = 'Кредит:'
  end
  object LContents: TLabel [2]
    Left = 9
    Top = 64
    Width = 66
    Height = 13
    Alignment = taRightJustify
    Caption = 'Содержание:'
  end
  inherited pnBut: TPanel
    Top = 114
    Width = 362
    inherited Panel2: TPanel
      Left = 177
    end
  end
  inherited cbInString: TCheckBox
    Top = 96
  end
  object BDebit: TButton [5]
    Left = 144
    Top = 13
    Width = 17
    Height = 21
    Caption = '...'
    TabOrder = 2
    OnClick = BDebitClick
  end
  object BKredit: TButton [6]
    Left = 144
    Top = 36
    Width = 17
    Height = 21
    Caption = '...'
    TabOrder = 3
    OnClick = BKreditClick
  end
  object EContents: TEdit [7]
    Left = 77
    Top = 60
    Width = 276
    Height = 21
    TabOrder = 4
    OnChange = EditChange
  end
  object MEDebit: TMaskEdit [8]
    Left = 77
    Top = 13
    Width = 65
    Height = 21
    EditMask = 'aaa\.aaa\.a;1; '
    MaxLength = 9
    TabOrder = 5
    Text = '   .   . '
    OnChange = EditChange
  end
  object MEKredit: TMaskEdit [9]
    Left = 77
    Top = 36
    Width = 65
    Height = 21
    EditMask = 'aaa\.aaa\.a;1; '
    MaxLength = 9
    TabOrder = 6
    Text = '   .   . '
    OnChange = EditChange
  end
  object Button1: TButton [10]
    Left = 176
    Top = 13
    Width = 17
    Height = 21
    Caption = '...'
    TabOrder = 7
    OnClick = Button1Click
  end
  inherited IBTran: TIBTransaction
    Top = 121
  end
end
