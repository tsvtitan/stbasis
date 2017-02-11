inherited fmEditRBPms_SanitaryNode: TfmEditRBPms_SanitaryNode
  Caption = 'fmEditRBPms_SanitaryNode'
  ClientHeight = 152
  ClientWidth = 309
  PixelsPerInch = 96
  TextHeight = 13
  object lbName: TLabel [0]
    Left = 8
    Top = 20
    Width = 79
    Height = 13
    Alignment = taRightJustify
    Caption = 'Наименование:'
  end
  object lbNote: TLabel [1]
    Left = 34
    Top = 47
    Width = 53
    Height = 13
    Alignment = taRightJustify
    Caption = 'Описание:'
  end
  object lbSortNumber: TLabel [2]
    Left = 42
    Top = 72
    Width = 47
    Height = 13
    Caption = 'Порядок:'
  end
  inherited pnBut: TPanel
    Top = 114
    Width = 309
    TabOrder = 5
    inherited Panel2: TPanel
      Left = 124
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 97
    TabOrder = 4
  end
  object edName: TEdit [5]
    Left = 97
    Top = 16
    Width = 199
    Height = 21
    MaxLength = 100
    TabOrder = 0
    OnChange = edNameChange
  end
  object edNote: TEdit [6]
    Left = 97
    Top = 43
    Width = 199
    Height = 21
    MaxLength = 100
    TabOrder = 1
    OnChange = edNameChange
  end
  object edSort: TEdit [7]
    Left = 97
    Top = 70
    Width = 46
    Height = 21
    ReadOnly = True
    TabOrder = 2
    Text = '1'
    OnChange = edSortChange
  end
  object udSort: TUpDown [8]
    Left = 143
    Top = 70
    Width = 15
    Height = 21
    Associate = edSort
    Min = 1
    Position = 1
    TabOrder = 3
    Wrap = False
    OnChanging = udSortChanging
  end
  inherited IBTran: TIBTransaction
    Left = 216
    Top = 33
  end
end
