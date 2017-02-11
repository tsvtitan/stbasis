inherited fmEditRBPms_Builder: TfmEditRBPms_Builder
  Left = 513
  Top = 292
  Caption = 'fmEditRBPms_Builder'
  ClientHeight = 258
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
    Top = 167
    Width = 47
    Height = 13
    Caption = 'Порядок:'
  end
  object LabelPhones: TLabel [3]
    Left = 31
    Top = 71
    Width = 56
    Height = 13
    Alignment = taRightJustify
    Caption = 'Телефоны:'
  end
  inherited pnBut: TPanel
    Top = 220
    Width = 309
    TabOrder = 6
    inherited Panel2: TPanel
      Left = 124
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 197
    TabOrder = 5
  end
  object edName: TEdit [6]
    Left = 97
    Top = 16
    Width = 199
    Height = 21
    MaxLength = 100
    TabOrder = 0
    OnChange = edNameChange
  end
  object edNote: TEdit [7]
    Left = 97
    Top = 43
    Width = 199
    Height = 21
    MaxLength = 100
    TabOrder = 1
    OnChange = edNameChange
  end
  object edSort: TEdit [8]
    Left = 97
    Top = 165
    Width = 46
    Height = 21
    ReadOnly = True
    TabOrder = 3
    Text = '1'
    OnChange = edSortChange
  end
  object udSort: TUpDown [9]
    Left = 143
    Top = 165
    Width = 15
    Height = 21
    Associate = edSort
    Min = 1
    Position = 1
    TabOrder = 4
    Wrap = False
    OnChanging = udSortChanging
  end
  object MemoPhones: TMemo [10]
    Left = 97
    Top = 70
    Width = 199
    Height = 89
    TabOrder = 2
    OnChange = edNameChange
  end
  inherited IBTran: TIBTransaction
    Left = 216
    Top = 33
  end
end
