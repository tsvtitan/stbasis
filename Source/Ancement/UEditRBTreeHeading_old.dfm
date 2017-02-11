inherited fmEditRBTreeheading: TfmEditRBTreeheading
  Left = 427
  Top = 223
  Caption = 'fmEditRBTreeheading'
  ClientHeight = 144
  ClientWidth = 331
  PixelsPerInch = 96
  TextHeight = 13
  object lbNameHeading: TLabel [0]
    Left = 18
    Top = 16
    Width = 123
    Height = 13
    Caption = 'Наименование рубрики:'
  end
  object lbParent: TLabel [1]
    Left = 9
    Top = 42
    Width = 132
    Height = 13
    Caption = 'Рубрика верхнего уровня:'
  end
  object lbSortNumber: TLabel [2]
    Left = 32
    Top = 68
    Width = 109
    Height = 13
    Caption = 'Порядок сортировки:'
  end
  inherited pnBut: TPanel
    Top = 106
    Width = 331
    TabOrder = 6
    inherited Panel2: TPanel
      Left = 146
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 89
    TabOrder = 5
  end
  object edNameHeading: TEdit [5]
    Left = 149
    Top = 12
    Width = 174
    Height = 21
    MaxLength = 100
    TabOrder = 0
    OnChange = edNameHeadingChange
  end
  object edParent: TEdit [6]
    Left = 149
    Top = 38
    Width = 153
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 1
    OnChange = edNameHeadingChange
    OnKeyDown = edParentKeyDown
  end
  object bibParent: TButton [7]
    Left = 302
    Top = 38
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 2
    OnClick = bibParentClick
  end
  object edSortNumber: TEdit [8]
    Left = 149
    Top = 65
    Width = 59
    Height = 21
    MaxLength = 6
    ReadOnly = True
    TabOrder = 3
    Text = '1'
    OnChange = edNameHeadingChange
  end
  object udSortNumber: TUpDown [9]
    Left = 208
    Top = 65
    Width = 16
    Height = 21
    Associate = edSortNumber
    Min = 1
    Position = 1
    TabOrder = 4
    Thousands = False
    Wrap = False
  end
  inherited IBTran: TIBTransaction
    Left = 104
    Top = 121
  end
end
