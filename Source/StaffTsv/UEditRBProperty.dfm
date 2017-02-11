inherited fmEditRBProperty: TfmEditRBProperty
  Left = 304
  Caption = 'fmEditRBProperty'
  ClientHeight = 117
  ClientWidth = 310
  PixelsPerInch = 96
  TextHeight = 13
  object lbName: TLabel [0]
    Left = 37
    Top = 16
    Width = 79
    Height = 13
    Caption = 'Наименование:'
  end
  object lbParent: TLabel [1]
    Left = 65
    Top = 42
    Width = 51
    Height = 13
    Caption = 'Родитель:'
  end
  inherited pnBut: TPanel
    Top = 79
    Width = 310
    TabOrder = 4
    inherited Panel2: TPanel
      Left = 125
    end
  end
  inherited cbInString: TCheckBox
    Top = 61
    TabOrder = 3
  end
  object edName: TEdit [4]
    Left = 125
    Top = 12
    Width = 174
    Height = 21
    MaxLength = 100
    TabOrder = 0
    OnChange = edNameChange
  end
  object edParent: TEdit [5]
    Left = 125
    Top = 38
    Width = 153
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 1
    OnChange = edNameChange
    OnKeyDown = edParentKeyDown
  end
  object bibParent: TBitBtn [6]
    Left = 278
    Top = 38
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 2
    OnClick = bibParentClick
  end
  inherited IBTran: TIBTransaction
    Left = 104
    Top = 81
  end
end
