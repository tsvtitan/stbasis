inherited fmEditRBVisit: TfmEditRBVisit
  Left = 458
  Top = 153
  Caption = 'fmEditRBVisit'
  ClientHeight = 434
  ClientWidth = 400
  PixelsPerInch = 96
  TextHeight = 13
  object lbVisitDate: TLabel [0]
    Left = 38
    Top = 39
    Width = 89
    Height = 13
    Alignment = taRightJustify
    Caption = 'Дата посещения:'
  end
  object lbInvalidFio: TLabel [1]
    Left = 80
    Top = 66
    Width = 47
    Height = 13
    Alignment = taRightJustify
    Caption = 'Инвалид:'
  end
  object lbInvalidGroup: TLabel [2]
    Left = 8
    Top = 165
    Width = 119
    Height = 13
    Alignment = taRightJustify
    Caption = 'Установленная группа:'
  end
  object lbSick: TLabel [3]
    Left = 81
    Top = 219
    Width = 46
    Height = 13
    Alignment = taRightJustify
    Caption = 'Болезнь:'
  end
  object lbDeterminationDate: TLabel [4]
    Left = 28
    Top = 240
    Width = 99
    Height = 26
    Alignment = taRightJustify
    Caption = 'Дата установления'#13#10'инвалидности:'
  end
  object lbPhysician: TLabel [5]
    Left = 100
    Top = 275
    Width = 27
    Height = 13
    Alignment = taRightJustify
    Caption = 'Врач:'
  end
  object lbViewPlace: TLabel [6]
    Left = 46
    Top = 302
    Width = 81
    Height = 13
    Alignment = taRightJustify
    Caption = 'Место осмотра:'
  end
  object lbInvalidCategory: TLabel [7]
    Left = 71
    Top = 329
    Width = 56
    Height = 13
    Alignment = taRightJustify
    Caption = 'Категория:'
  end
  object lbVisitDateTo: TLabel [8]
    Left = 245
    Top = 39
    Width = 15
    Height = 13
    Caption = 'по:'
    Visible = False
  end
  object lbOrdinal: TLabel [9]
    Left = 33
    Top = 13
    Width = 96
    Height = 13
    Alignment = taRightJustify
    Caption = 'Номер по порядку:'
  end
  object lbSickGroup: TLabel [10]
    Left = 44
    Top = 192
    Width = 83
    Height = 13
    Alignment = taRightJustify
    Caption = 'Группа болезни:'
  end
  object lbBranch: TLabel [11]
    Left = 69
    Top = 356
    Width = 58
    Height = 13
    Alignment = taRightJustify
    Caption = 'Отделение:'
  end
  inherited pnBut: TPanel
    Top = 396
    Width = 400
    TabOrder = 20
    inherited Panel2: TPanel
      Left = 215
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 378
    TabOrder = 19
  end
  object edInvalidFio: TEdit [14]
    Left = 138
    Top = 63
    Width = 226
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 4
    OnChange = edNameChange
  end
  object bibInvalidFio: TBitBtn [15]
    Left = 364
    Top = 63
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 5
    OnClick = bibInvalidFioClick
  end
  object dtpVisitDate: TDateTimePicker [16]
    Left = 138
    Top = 36
    Width = 94
    Height = 22
    CalAlignment = dtaLeft
    Date = 37640.8046224537
    Time = 37640.8046224537
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 1
    OnChange = dtpVisitDateChange
  end
  object edSick: TEdit [17]
    Left = 138
    Top = 216
    Width = 226
    Height = 21
    MaxLength = 100
    TabOrder = 12
    OnChange = edNameChange
  end
  object bibSick: TBitBtn [18]
    Left = 364
    Top = 216
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 13
    OnClick = bibSickClick
  end
  object dtpDeterminationDate: TDateTimePicker [19]
    Left = 138
    Top = 244
    Width = 94
    Height = 21
    CalAlignment = dtaLeft
    Date = 37640.8046224537
    Time = 37640.8046224537
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 14
    OnChange = dtpVisitDateChange
  end
  object dtpVisitDateTo: TDateTimePicker [20]
    Left = 270
    Top = 36
    Width = 94
    Height = 22
    CalAlignment = dtaLeft
    Date = 37640.8046224537
    Time = 37640.8046224537
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 2
    Visible = False
    OnChange = dtpVisitDateChange
  end
  object bibVisitDate: TBitBtn [21]
    Left = 364
    Top = 36
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 3
    Visible = False
    OnClick = bibVisitDateClick
  end
  object cmbInvalidGroup: TComboBox [22]
    Left = 138
    Top = 162
    Width = 246
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 9
    OnChange = edNameChange
  end
  object cmbPhysician: TComboBox [23]
    Left = 138
    Top = 271
    Width = 246
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 15
    OnChange = edNameChange
  end
  object cmbViewPlace: TComboBox [24]
    Left = 138
    Top = 299
    Width = 246
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 16
    OnChange = edNameChange
  end
  object cmbInvalidCategory: TComboBox [25]
    Left = 138
    Top = 326
    Width = 246
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 17
    OnChange = edNameChange
  end
  object cmbComingInvalidGroup: TComboBox [26]
    Left = 138
    Top = 113
    Width = 246
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 7
    OnChange = edNameChange
  end
  object edOrdinal: TEdit [27]
    Left = 138
    Top = 10
    Width = 93
    Height = 21
    MaxLength = 100
    TabOrder = 0
    OnChange = edNameChange
  end
  object edSickGroup: TEdit [28]
    Left = 138
    Top = 189
    Width = 226
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 10
    OnChange = edNameChange
  end
  object bibSickGroup: TBitBtn [29]
    Left = 364
    Top = 189
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 11
    OnClick = bibSickGroupClick
  end
  object rbComingInvalidGroup: TRadioButton [30]
    Left = 138
    Top = 92
    Width = 137
    Height = 17
    Caption = 'Является инвалидом:'
    Checked = True
    TabOrder = 6
    TabStop = True
    OnClick = rbComingInvalidGroupClick
  end
  object rbFirstUvo: TRadioButton [31]
    Left = 138
    Top = 140
    Width = 113
    Height = 17
    Caption = 'Впервые УВО:'
    TabOrder = 8
    OnClick = rbComingInvalidGroupClick
  end
  object cmbBranch: TComboBox [32]
    Left = 138
    Top = 353
    Width = 246
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 18
    OnChange = edNameChange
  end
  inherited IBTran: TIBTransaction
    Left = 256
    Top = 237
  end
end
