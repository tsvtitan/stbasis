inherited fmEditRBNomenclatureGroup: TfmEditRBNomenclatureGroup
  Left = 304
  Caption = 'fmEditRBNomenclatureGroup'
  ClientHeight = 185
  ClientWidth = 304
  PixelsPerInch = 96
  TextHeight = 13
  object lbName: TLabel [0]
    Left = 8
    Top = 13
    Width = 79
    Height = 13
    Caption = 'Наименование:'
  end
  object lbParent: TLabel [1]
    Left = 36
    Top = 39
    Width = 51
    Height = 13
    Caption = 'Родитель:'
  end
  object lbNote: TLabel [2]
    Left = 22
    Top = 63
    Width = 66
    Height = 13
    Caption = 'Примечание:'
  end
  inherited pnBut: TPanel
    Top = 147
    Width = 304
    TabOrder = 5
    inherited Panel2: TPanel
      Left = 119
    end
  end
  inherited cbInString: TCheckBox
    Top = 125
    TabOrder = 4
  end
  object edName: TEdit [5]
    Left = 96
    Top = 9
    Width = 198
    Height = 21
    MaxLength = 100
    TabOrder = 0
    OnChange = edNameChange
  end
  object edParent: TEdit [6]
    Left = 96
    Top = 35
    Width = 177
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 1
    OnChange = edNameChange
    OnKeyDown = edParentKeyDown
  end
  object bibParent: TBitBtn [7]
    Left = 273
    Top = 35
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 2
    OnClick = bibParentClick
  end
  object meNote: TMemo [8]
    Left = 96
    Top = 62
    Width = 199
    Height = 55
    TabOrder = 3
    OnChange = edNameChange
  end
  inherited IBTran: TIBTransaction
    Left = 152
    Top = 81
  end
end
