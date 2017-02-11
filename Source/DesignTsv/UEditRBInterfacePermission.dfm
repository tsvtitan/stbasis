inherited fmEditRBInterfacePermission: TfmEditRBInterfacePermission
  Left = 343
  Top = 223
  Caption = 'fmEditRBInterfacePermission'
  ClientHeight = 174
  ClientWidth = 352
  PixelsPerInch = 96
  TextHeight = 13
  object lbInterface: TLabel [0]
    Left = 66
    Top = 16
    Width = 60
    Height = 13
    Alignment = taRightJustify
    Caption = 'Интерфейс:'
  end
  object lbInterfaceAction: TLabel [1]
    Left = 9
    Top = 43
    Width = 117
    Height = 13
    Alignment = taRightJustify
    Caption = 'Действие интерфейса:'
  end
  object lbObject: TLabel [2]
    Left = 16
    Top = 71
    Width = 110
    Height = 13
    Alignment = taRightJustify
    Caption = 'Объект базы данных:'
  end
  object lbPermission: TLabel [3]
    Left = 91
    Top = 99
    Width = 35
    Height = 13
    Alignment = taRightJustify
    Caption = 'Право:'
  end
  inherited pnBut: TPanel
    Top = 136
    Width = 352
    TabOrder = 7
    inherited Panel2: TPanel
      Left = 167
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 119
    TabOrder = 6
  end
  object edInterface: TEdit [6]
    Left = 134
    Top = 12
    Width = 190
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 0
    OnChange = edNameChange
  end
  object bibInterface: TButton [7]
    Left = 324
    Top = 12
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 1
    OnClick = bibInterfaceClick
  end
  object cmbInterfaceAction: TComboBox [8]
    Left = 134
    Top = 39
    Width = 212
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 2
    OnChange = edNameChange
    Items.Strings = (
      'Товар'
      'Услуга'
      'Набор')
  end
  object edObject: TEdit [9]
    Left = 134
    Top = 67
    Width = 190
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 3
    OnChange = edNameChange
  end
  object bibObject: TButton [10]
    Left = 324
    Top = 67
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 4
    OnClick = bibObjectClick
  end
  object cmbPermission: TComboBox [11]
    Left = 134
    Top = 95
    Width = 212
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 5
    OnChange = edNameChange
    Items.Strings = (
      'Товар'
      'Услуга'
      'Набор')
  end
  inherited IBTran: TIBTransaction
    Left = 8
    Top = 3
  end
end
