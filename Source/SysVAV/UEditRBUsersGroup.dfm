inherited fmEditRBUsersGroup: TfmEditRBUsersGroup
  Left = 478
  Top = 224
  Caption = 'fmEditRBUsersGroup'
  ClientHeight = 123
  ClientWidth = 386
  PixelsPerInch = 96
  TextHeight = 13
  object lbNameUsersGroup: TLabel [0]
    Left = 1
    Top = 11
    Width = 118
    Height = 13
    Alignment = taRightJustify
    Caption = 'Группа пользователей:'
  end
  object lbInterfaceName: TLabel [1]
    Left = 29
    Top = 33
    Width = 89
    Height = 13
    Caption = 'Имя интерфейса:'
  end
  inherited pnBut: TPanel
    Top = 85
    Width = 386
    TabOrder = 3
    inherited Panel2: TPanel
      Left = 201
    end
  end
  inherited cbInString: TCheckBox
    Left = 0
    Top = 58
    TabOrder = 2
  end
  object edNameUsersGroup: TEdit [4]
    Left = 124
    Top = 7
    Width = 245
    Height = 21
    MaxLength = 100
    TabOrder = 0
  end
  object cmbInterfaceName: TComboBox [5]
    Left = 124
    Top = 30
    Width = 245
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
  end
  inherited IBTran: TIBTransaction
    Left = 0
    Top = 1
  end
end
