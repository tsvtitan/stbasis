inherited fmEditRBKindSubkonto: TfmEditRBKindSubkonto
  Left = 279
  Top = 128
  Caption = 'fmEditRBKindSubkonto'
  ClientHeight = 233
  ClientWidth = 390
  PixelsPerInch = 96
  TextHeight = 13
  object LTable: TLabel [0]
    Left = 73
    Top = 72
    Width = 46
    Height = 13
    Caption = 'Таблица:'
  end
  object LFieldWithId: TLabel [1]
    Left = 62
    Top = 100
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
    Top = 129
    Width = 111
    Height = 13
    Caption = 'Поле с содержанием:'
  end
  object LInterface: TLabel [4]
    Left = 57
    Top = 45
    Width = 60
    Height = 13
    Caption = 'Интерфейс:'
  end
  inherited pnBut: TPanel
    Top = 195
    Width = 390
    inherited Panel2: TPanel
      Left = 205
    end
  end
  inherited cbInString: TCheckBox
    Top = 176
    TabOrder = 5
  end
  object CBTable: TComboBox [7]
    Left = 128
    Top = 68
    Width = 257
    Height = 21
    ItemHeight = 13
    TabOrder = 2
    OnChange = CBTableChange
  end
  object CBFieldWithId: TComboBox [8]
    Left = 128
    Top = 96
    Width = 257
    Height = 21
    ItemHeight = 13
    TabOrder = 3
    OnChange = EditChange
  end
  object EName: TEdit [9]
    Left = 128
    Top = 12
    Width = 257
    Height = 21
    TabOrder = 1
    OnChange = EditChange
  end
  object CBFieldWithText: TComboBox [10]
    Left = 128
    Top = 125
    Width = 257
    Height = 21
    ItemHeight = 13
    TabOrder = 4
    OnChange = EditChange
  end
  object cmbInterfaces: TComboBox [11]
    Left = 128
    Top = 40
    Width = 257
    Height = 21
    ItemHeight = 13
    TabOrder = 6
  end
  inherited IBTran: TIBTransaction
    Left = 144
    Top = 177
  end
end
