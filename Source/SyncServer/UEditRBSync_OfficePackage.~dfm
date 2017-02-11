inherited fmEditRBSync_OfficePackage: TfmEditRBSync_OfficePackage
  Left = 560
  Top = 203
  Caption = 'fmEditRBSync_OfficePackage'
  ClientHeight = 168
  ClientWidth = 277
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object lbOffice: TLabel [0]
    Left = 20
    Top = 12
    Width = 31
    Height = 13
    Alignment = taRightJustify
    Caption = 'Офис:'
    FocusControl = edOffice
  end
  object lbPackage: TLabel [1]
    Left = 17
    Top = 39
    Width = 34
    Height = 13
    Alignment = taRightJustify
    Caption = 'Пакет:'
    FocusControl = edPackage
  end
  object lbPriority: TLabel [2]
    Left = 110
    Top = 90
    Width = 57
    Height = 13
    Alignment = taRightJustify
    Caption = 'Приоритет:'
    FocusControl = edPriority
  end
  object lbDirection: TLabel [3]
    Left = 45
    Top = 64
    Width = 71
    Height = 13
    Alignment = taRightJustify
    Caption = 'Направление:'
    FocusControl = cmbDirection
  end
  inherited pnBut: TPanel
    Top = 130
    Width = 277
    TabOrder = 7
    inherited Panel2: TPanel
      Left = 92
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 112
    TabOrder = 6
  end
  object edOffice: TEdit [6]
    Left = 58
    Top = 8
    Width = 190
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 0
    OnChange = edNameChange
  end
  object btOffice: TButton [7]
    Left = 248
    Top = 8
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 1
    OnClick = btOfficeClick
  end
  object edPackage: TEdit [8]
    Left = 58
    Top = 35
    Width = 190
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 2
    OnChange = edNameChange
  end
  object btPackage: TButton [9]
    Left = 248
    Top = 35
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 3
    OnClick = btPackageClick
  end
  object edPriority: TEdit [10]
    Left = 176
    Top = 87
    Width = 93
    Height = 21
    TabOrder = 5
    OnChange = edNameChange
  end
  object cmbDirection: TComboBox [11]
    Left = 124
    Top = 61
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 4
    OnChange = cmbDirectionChange
    Items.Strings = (
      'В офис'
      'Из офиса')
  end
  inherited IBTran: TIBTransaction
    Left = 16
    Top = 74
  end
end
