inherited fmEditRBTreeTaxes: TfmEditRBTreeTaxes
  Left = 331
  Top = 295
  Caption = 'Дерево налогов'
  ClientHeight = 137
  ClientWidth = 353
  PixelsPerInch = 96
  TextHeight = 13
  object lbTaxesType: TLabel [0]
    Left = 80
    Top = 11
    Width = 34
    Height = 13
    Alignment = taRightJustify
    Caption = 'Налог:'
  end
  object lbStandartOperation: TLabel [1]
    Left = 61
    Top = 35
    Width = 53
    Height = 13
    Alignment = taRightJustify
    Caption = 'Операция:'
  end
  object lbParent: TLabel [2]
    Left = 63
    Top = 59
    Width = 51
    Height = 13
    Alignment = taRightJustify
    Caption = 'Родитель:'
  end
  inherited pnBut: TPanel
    Top = 99
    Width = 353
    TabOrder = 3
    inherited Panel2: TPanel
      Left = 168
    end
  end
  inherited cbInString: TCheckBox
    Left = 0
    Top = 82
    TabOrder = 2
  end
  object edTaxesType: TEdit [5]
    Left = 124
    Top = 8
    Width = 199
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 0
    OnKeyDown = edTaxesTypeKeyDown
  end
  object bibTaxesType: TBitBtn [6]
    Left = 324
    Top = 7
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 1
    OnClick = bibTaxesTypeClick
  end
  object edStandartOperation: TEdit [7]
    Left = 124
    Top = 32
    Width = 199
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 4
    OnKeyDown = edStandartOperationKeyDown
  end
  object bibStandartOperation: TBitBtn [8]
    Left = 324
    Top = 31
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 5
    OnClick = bibStandartOperationClick
  end
  object edParentTreeTaxes: TEdit [9]
    Left = 124
    Top = 56
    Width = 199
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 6
    OnKeyDown = edParentTreeTaxesKeyDown
  end
  object bibParentTreeTaxes: TBitBtn [10]
    Left = 324
    Top = 55
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 7
    OnClick = bibParentTreeTaxesClick
  end
  inherited IBTran: TIBTransaction
    Left = 0
    Top = 49
  end
end
