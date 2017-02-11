inherited fmEditRBSickGroup: TfmEditRBSickGroup
  Left = 304
  Caption = 'fmEditRBSickGroup'
  ClientHeight = 207
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
  object lbSort: TLabel [3]
    Left = 114
    Top = 126
    Width = 109
    Height = 13
    Alignment = taRightJustify
    Caption = 'Порядок сортировки:'
  end
  inherited pnBut: TPanel
    Top = 169
    Width = 304
    TabOrder = 7
    inherited Panel2: TPanel
      Left = 119
    end
  end
  inherited cbInString: TCheckBox
    Top = 151
    TabOrder = 6
  end
  object edName: TEdit [6]
    Left = 96
    Top = 9
    Width = 198
    Height = 21
    MaxLength = 100
    TabOrder = 0
    OnChange = edNameChange
  end
  object edParent: TEdit [7]
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
  object bibParent: TBitBtn [8]
    Left = 273
    Top = 35
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 2
    OnClick = bibParentClick
  end
  object meNote: TMemo [9]
    Left = 96
    Top = 62
    Width = 199
    Height = 55
    TabOrder = 3
    OnChange = edNameChange
  end
  object edSort: TEdit [10]
    Left = 233
    Top = 123
    Width = 46
    Height = 21
    ReadOnly = True
    TabOrder = 4
    Text = '1'
    OnChange = edNameChange
  end
  object udSort: TUpDown [11]
    Left = 279
    Top = 123
    Width = 15
    Height = 21
    Associate = edSort
    Min = 1
    Position = 1
    TabOrder = 5
    Wrap = False
    OnChanging = udSortChanging
  end
  inherited IBTran: TIBTransaction
    Left = 16
    Top = 33
  end
end
