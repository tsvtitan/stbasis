inherited fmEditRBKindSubkonto: TfmEditRBKindSubkonto
  Left = 361
  Top = 105
  Caption = 'fmEditRBKindSubkonto'
  ClientHeight = 255
  ClientWidth = 395
  PixelsPerInch = 96
  TextHeight = 13
  object LTable: TLabel [0]
    Left = 73
    Top = 96
    Width = 46
    Height = 13
    Caption = 'Таблица:'
  end
  object LFieldWithId: TLabel [1]
    Left = 62
    Top = 124
    Width = 55
    Height = 13
    Caption = 'Поле с ИД'
  end
  object LName: TLabel [2]
    Left = 40
    Top = 16
    Width = 79
    Height = 13
    Caption = 'Наименование:'
  end
  object LFieldWithText: TLabel [3]
    Left = 8
    Top = 153
    Width = 111
    Height = 13
    Caption = 'Поле с содержанием:'
  end
  object LInterface: TLabel [4]
    Left = 57
    Top = 69
    Width = 60
    Height = 13
    Caption = 'Интерфейс:'
  end
  object LLevel: TLabel [5]
    Left = 70
    Top = 40
    Width = 47
    Height = 13
    Caption = 'Уровень:'
  end
  inherited pnBut: TPanel
    Top = 217
    Width = 395
    inherited Panel2: TPanel
      Left = 210
    end
  end
  inherited cbInString: TCheckBox
    Left = 14
    Top = 192
    TabOrder = 6
  end
  object CBTable: TComboBox [8]
    Left = 128
    Top = 92
    Width = 257
    Height = 21
    ItemHeight = 13
    TabOrder = 3
    OnChange = CBTableChange
  end
  object CBFieldWithId: TComboBox [9]
    Left = 128
    Top = 120
    Width = 257
    Height = 21
    ItemHeight = 13
    TabOrder = 4
    OnChange = EditChange
  end
  object EName: TEdit [10]
    Left = 128
    Top = 12
    Width = 257
    Height = 21
    TabOrder = 1
    OnChange = EditChange
  end
  object CBFieldWithText: TComboBox [11]
    Left = 128
    Top = 149
    Width = 257
    Height = 21
    ItemHeight = 13
    TabOrder = 5
    OnChange = EditChange
  end
  object udLevel: TUpDown [12]
    Left = 152
    Top = 38
    Width = 14
    Height = 21
    Min = 1
    Position = 1
    TabOrder = 7
    Wrap = False
    OnClick = udLevelClick
  end
  object ELevel: TEdit [13]
    Left = 128
    Top = 38
    Width = 25
    Height = 21
    ReadOnly = True
    TabOrder = 2
    Text = '1'
    OnChange = ELevelChange
  end
  object cmbInterfaces: TComboBox [14]
    Left = 128
    Top = 64
    Width = 257
    Height = 21
    ItemHeight = 13
    TabOrder = 8
  end
  inherited IBTran: TIBTransaction
    Left = 144
    Top = 217
  end
end
