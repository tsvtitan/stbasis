inherited fmEditRBRespondents: TfmEditRBRespondents
  Left = 306
  Top = 231
  Caption = 'fmEditRBRespondents'
  ClientHeight = 275
  ClientWidth = 365
  PixelsPerInch = 96
  TextHeight = 13
  object lbSerial: TLabel [0]
    Left = 76
    Top = 104
    Width = 34
    Height = 13
    Alignment = taRightJustify
    Caption = 'Серия:'
  end
  object lbNum: TLabel [1]
    Left = 73
    Top = 126
    Width = 37
    Height = 13
    Alignment = taRightJustify
    Caption = 'Номер:'
  end
  object lbDateWhere: TLabel [2]
    Left = 41
    Top = 171
    Width = 69
    Height = 13
    Alignment = taRightJustify
    Caption = 'Дата выдачи:'
  end
  object lbPersonDocName: TLabel [3]
    Left = 31
    Top = 80
    Width = 79
    Height = 13
    Alignment = taRightJustify
    Caption = 'Тип документа:'
  end
  object lbPlantName: TLabel [4]
    Left = 51
    Top = 194
    Width = 59
    Height = 13
    Alignment = taRightJustify
    Caption = 'Кем выдан:'
  end
  object lbFname: TLabel [5]
    Left = 5
    Top = 11
    Width = 105
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    BiDiMode = bdLeftToRight
    Caption = 'Фамилия:'
    ParentBiDiMode = False
  end
  object lbName: TLabel [6]
    Left = 5
    Top = 33
    Width = 105
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    BiDiMode = bdLeftToRight
    Caption = 'Имя:'
    ParentBiDiMode = False
  end
  object lbSname: TLabel [7]
    Left = 5
    Top = 56
    Width = 105
    Height = 16
    Alignment = taRightJustify
    AutoSize = False
    BiDiMode = bdLeftToRight
    Caption = 'Отчество:'
    ParentBiDiMode = False
  end
  object lbKod: TLabel [8]
    Left = 7
    Top = 148
    Width = 103
    Height = 13
    Alignment = taRightJustify
    Caption = 'Код подразделения:'
  end
  inherited pnBut: TPanel
    Top = 237
    Width = 365
    TabOrder = 12
    inherited Panel2: TPanel
      Left = 180
    end
  end
  inherited cbInString: TCheckBox
    Left = 0
    Top = 221
    TabOrder = 11
  end
  object edPersonDocName: TEdit [11]
    Left = 119
    Top = 77
    Width = 219
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 3
    OnChange = edPersonDocNameChange
    OnKeyDown = edPersonDocNameKeyDown
  end
  object bibPersonDocName: TBitBtn [12]
    Left = 338
    Top = 76
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 4
    OnClick = bibPersonDocNameClick
  end
  object dtpDateWhere: TDateTimePicker [13]
    Left = 119
    Top = 167
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
    TabOrder = 8
    OnChange = edPersonDocNameChange
  end
  object edPlantName: TEdit [14]
    Left = 119
    Top = 191
    Width = 219
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 9
    OnChange = edPersonDocNameChange
    OnKeyDown = edPlantNameKeyDown
  end
  object bibPlantName: TBitBtn [15]
    Left = 338
    Top = 191
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 10
    OnClick = bibPlantNameClick
  end
  object msedSerial: TMaskEdit [16]
    Left = 119
    Top = 100
    Width = 240
    Height = 21
    TabOrder = 5
    OnChange = edPersonDocNameChange
  end
  object msedNum: TMaskEdit [17]
    Left = 119
    Top = 122
    Width = 240
    Height = 21
    TabOrder = 6
    OnChange = edPersonDocNameChange
  end
  object edFname: TMaskEdit [18]
    Left = 119
    Top = 7
    Width = 240
    Height = 21
    TabOrder = 0
    OnChange = edPersonDocNameChange
    OnKeyDown = edFnameKeyDown
  end
  object edName: TMaskEdit [19]
    Left = 119
    Top = 30
    Width = 240
    Height = 21
    TabOrder = 1
    OnChange = edPersonDocNameChange
    OnKeyDown = edNameKeyDown
  end
  object edSname: TMaskEdit [20]
    Left = 119
    Top = 54
    Width = 240
    Height = 21
    TabOrder = 2
    OnChange = edPersonDocNameChange
    OnKeyDown = edSnameKeyDown
  end
  object msedCod: TMaskEdit [21]
    Left = 119
    Top = 144
    Width = 240
    Height = 21
    TabOrder = 7
    OnChange = edPersonDocNameChange
  end
  inherited IBTran: TIBTransaction
    Left = 16
    Top = 165
  end
end
