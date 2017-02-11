inherited fmEditRBUsersAccessRights: TfmEditRBUsersAccessRights
  Left = 303
  Top = 382
  Caption = 'Значения свойств'
  ClientHeight = 119
  ClientWidth = 358
  PixelsPerInch = 96
  TextHeight = 13
  object lbTypeDoc: TLabel [0]
    Left = 35
    Top = 9
    Width = 79
    Height = 13
    Alignment = taRightJustify
    Caption = 'Тип документа:'
  end
  object lbTypeNumerator: TLabel [1]
    Left = 55
    Top = 33
    Width = 59
    Height = 13
    Alignment = taRightJustify
    Caption = 'Нумератор:'
  end
  inherited pnBut: TPanel
    Top = 81
    Width = 358
    TabOrder = 5
    inherited Panel2: TPanel
      Left = 173
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 64
    TabOrder = 4
  end
  object edTypeDoc: TEdit [4]
    Left = 124
    Top = 6
    Width = 199
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 0
    OnKeyDown = edTypeDocKeyDown
  end
  object bibTypeDoc: TBitBtn [5]
    Left = 324
    Top = 5
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 1
    OnClick = bibTypeDocClick
  end
  object edTypeNumerator: TEdit [6]
    Left = 124
    Top = 30
    Width = 199
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 2
    OnKeyDown = edTypeNumeratorKeyDown
  end
  object bibTypeNumerator: TBitBtn [7]
    Left = 324
    Top = 29
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 3
    OnClick = bibTypeNumeratorClick
  end
  inherited IBTran: TIBTransaction
    Left = 8
    Top = 30
  end
end
