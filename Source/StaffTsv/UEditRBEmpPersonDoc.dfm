inherited fmEditRBEmpPersonDoc: TfmEditRBEmpPersonDoc
  Caption = 'fmEditRBEmpPersonDoc'
  ClientHeight = 218
  ClientWidth = 322
  PixelsPerInch = 96
  TextHeight = 13
  object lbSerial: TLabel [0]
    Left = 80
    Top = 39
    Width = 34
    Height = 13
    Caption = 'Серия:'
  end
  object lbNum: TLabel [1]
    Left = 77
    Top = 65
    Width = 37
    Height = 13
    Caption = 'Номер:'
  end
  object lbDateWhere: TLabel [2]
    Left = 45
    Top = 91
    Width = 69
    Height = 13
    Caption = 'Дата выдачи:'
  end
  object lbPersonDocName: TLabel [3]
    Left = 35
    Top = 12
    Width = 79
    Height = 13
    Caption = 'Тип документа:'
  end
  object lbPlantName: TLabel [4]
    Left = 55
    Top = 118
    Width = 59
    Height = 13
    Caption = 'Кем выдан:'
  end
  object lbPodrCode: TLabel [5]
    Left = 11
    Top = 145
    Width = 103
    Height = 13
    Alignment = taRightJustify
    Caption = 'Код подразделения:'
  end
  inherited pnBut: TPanel
    Top = 180
    Width = 322
    TabOrder = 9
    inherited Panel2: TPanel
      Left = 137
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 163
    TabOrder = 8
  end
  object edPersonDocName: TEdit [8]
    Left = 124
    Top = 9
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 0
    OnChange = edPersonDocNameChange
  end
  object bibPersonDocName: TBitBtn [9]
    Left = 293
    Top = 9
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 1
    OnClick = bibPersonDocNameClick
  end
  object dtpDateWhere: TDateTimePicker [10]
    Left = 124
    Top = 87
    Width = 97
    Height = 22
    CalAlignment = dtaLeft
    Date = 37156
    Time = 37156
    ShowCheckbox = True
    Checked = False
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 4
    OnChange = edPersonDocNameChange
  end
  object edPlantName: TEdit [11]
    Left = 124
    Top = 115
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 5
    OnChange = edPersonDocNameChange
  end
  object bibPlantName: TBitBtn [12]
    Left = 293
    Top = 115
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 6
    OnClick = bibPlantNameClick
  end
  object msedSerial: TMaskEdit [13]
    Left = 124
    Top = 35
    Width = 190
    Height = 21
    TabOrder = 2
    OnChange = edPersonDocNameChange
  end
  object msedNum: TMaskEdit [14]
    Left = 124
    Top = 61
    Width = 190
    Height = 21
    TabOrder = 3
    OnChange = edPersonDocNameChange
  end
  object msedPodrCode: TMaskEdit [15]
    Left = 124
    Top = 141
    Width = 190
    Height = 21
    MaxLength = 30
    TabOrder = 7
    OnChange = edPersonDocNameChange
  end
  inherited IBTran: TIBTransaction
    Left = 8
    Top = 41
  end
end
