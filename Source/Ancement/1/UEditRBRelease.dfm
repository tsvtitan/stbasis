inherited fmEditRBRelease: TfmEditRBRelease
  Left = 391
  Top = 216
  Caption = 'fmEditRBRelease'
  ClientHeight = 141
  ClientWidth = 377
  PixelsPerInch = 96
  TextHeight = 13
  object lbNumRelease: TLabel [0]
    Left = 14
    Top = 11
    Width = 83
    Height = 13
    Caption = 'Номер выпуска:'
    FocusControl = edNumRelease
  end
  object lbDate: TLabel [1]
    Left = 22
    Top = 39
    Width = 75
    Height = 13
    Alignment = taRightJustify
    Caption = 'Дата выпуска:'
    FocusControl = dtpDate
  end
  object lbAbout: TLabel [2]
    Left = 31
    Top = 66
    Width = 66
    Height = 13
    Caption = 'Примечание:'
    FocusControl = edAbout
  end
  object lbToDate: TLabel [3]
    Left = 218
    Top = 39
    Width = 15
    Height = 13
    Alignment = taRightJustify
    Caption = 'по:'
    FocusControl = dtpToDate
    Visible = False
  end
  inherited pnBut: TPanel
    Top = 103
    Width = 377
    TabOrder = 6
    inherited Panel2: TPanel
      Left = 192
    end
  end
  inherited cbInString: TCheckBox
    Left = 108
    Top = 87
    TabOrder = 5
  end
  object dtpDate: TDateTimePicker [6]
    Left = 108
    Top = 35
    Width = 95
    Height = 22
    CalAlignment = dtaLeft
    Date = 37147
    Time = 37147
    Checked = False
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 1
    OnChange = edNumReleaseChange
  end
  object edNumRelease: TEdit [7]
    Left = 108
    Top = 8
    Width = 93
    Height = 21
    TabOrder = 0
    OnChange = edNumReleaseChange
    OnKeyPress = edNumReleaseKeyPress
  end
  object edAbout: TEdit [8]
    Left = 108
    Top = 63
    Width = 261
    Height = 21
    TabOrder = 4
    OnChange = edNumReleaseChange
  end
  object dtpToDate: TDateTimePicker [9]
    Left = 244
    Top = 35
    Width = 95
    Height = 22
    CalAlignment = dtaLeft
    Date = 37147
    Time = 37147
    Checked = False
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 2
    Visible = False
    OnChange = edNumReleaseChange
  end
  object bibTodate: TButton [10]
    Left = 346
    Top = 35
    Width = 22
    Height = 22
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 3
    Visible = False
    OnClick = bibTodateClick
  end
  inherited IBTran: TIBTransaction
    Left = 16
    Top = 9
  end
end
