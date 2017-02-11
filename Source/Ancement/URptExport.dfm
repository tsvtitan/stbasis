inherited fmRptExport: TfmRptExport
  Left = 410
  Top = 173
  Width = 412
  Height = 360
  BorderIcons = [biSystemMenu, biMinimize, biMaximize]
  BorderStyle = bsSizeable
  Caption = 'Экспорт данных для верстки'
  Constraints.MinHeight = 360
  Constraints.MinWidth = 410
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000000000000900000000000000099000000000099999990000FFF
    F099999999000FFFF099999999900F00F099999999000FFFF099999990000F00
    FFFFF09900000FFFFFFFF09000000F00F000000000000FFFF0FF000000000F08
    F0F0000000000FFFF0000000000000000000000000000000000000000000FFDF
    0000FFCF0000FFC7000000030000000100000000000000010000000300000007
    0000000F0000001F0000007F000000FF000001FF000003FF0000FFFF0000}
  PixelsPerInch = 96
  TextHeight = 13
  inherited cbInString: TCheckBox [0]
    Top = 217
    TabOrder = 2
  end
  inherited pnBut: TPanel [1]
    Top = 295
    Width = 404
    TabOrder = 3
    inherited Panel2: TPanel
      Left = 112
      Width = 292
      TabOrder = 1
      inherited bibClear: TButton [0]
        Left = 198
        Top = 29
        Hint = 'Значения по умолчанию'
        Caption = 'По умолчанию'
      end
      inherited bibGen: TButton [1]
        Left = 15
      end
      inherited bibClose: TButton [2]
        Left = 210
      end
      inherited bibBreak: TButton [3]
        Left = 113
      end
    end
    object bibSave: TButton
      Left = 7
      Top = 5
      Width = 75
      Height = 25
      Hint = 'Сохранить результат'
      Caption = 'Сохранить'
      TabOrder = 0
      OnClick = bibSaveClick
    end
  end
  object pnRelease: TPanel [2]
    Left = 0
    Top = 0
    Width = 404
    Height = 92
    Align = alTop
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 0
    object grbCase: TGroupBox
      Left = 5
      Top = 5
      Width = 394
      Height = 82
      Align = alClient
      Caption = ' Выберите вариант экспорта '
      TabOrder = 0
      object lbPeriodTo: TLabel
        Left = 198
        Top = 53
        Width = 15
        Height = 13
        Caption = 'по:'
        Enabled = False
      end
      object edRelease: TEdit
        Left = 102
        Top = 23
        Width = 206
        Height = 21
        Color = clBtnFace
        MaxLength = 100
        ReadOnly = True
        TabOrder = 1
      end
      object bibRelease: TButton
        Left = 313
        Top = 23
        Width = 21
        Height = 21
        Hint = 'Выбрать'
        Caption = '...'
        TabOrder = 2
        OnClick = bibReleaseClick
      end
      object rbExportByNumrelease: TRadioButton
        Left = 12
        Top = 24
        Width = 89
        Height = 17
        Caption = 'По выпуску:'
        Checked = True
        TabOrder = 0
        TabStop = True
        OnClick = rbExportByNumreleaseClick
      end
      object rbExportByPeriod: TRadioButton
        Left = 12
        Top = 51
        Width = 83
        Height = 17
        Caption = 'За период с:'
        TabOrder = 3
        OnClick = rbExportByNumreleaseClick
      end
      object dtpDateFrom: TDateTimePicker
        Left = 102
        Top = 50
        Width = 87
        Height = 21
        CalAlignment = dtaLeft
        Date = 37670.6213090741
        Time = 37670.6213090741
        Color = clBtnFace
        DateFormat = dfShort
        DateMode = dmComboBox
        Enabled = False
        Kind = dtkDate
        ParseInput = False
        TabOrder = 4
      end
      object dtpDateTo: TDateTimePicker
        Left = 222
        Top = 50
        Width = 87
        Height = 21
        CalAlignment = dtaLeft
        Date = 37670.6213090741
        Time = 37670.6213090741
        Color = clBtnFace
        DateFormat = dfShort
        DateMode = dmComboBox
        Enabled = False
        Kind = dtkDate
        ParseInput = False
        TabOrder = 5
      end
      object bibPeriod: TButton
        Left = 313
        Top = 50
        Width = 21
        Height = 21
        Hint = 'Выбрать'
        Caption = '...'
        Enabled = False
        TabOrder = 6
        OnClick = bibPeriodClick
      end
    end
  end
  object pnResult: TPanel [3]
    Left = 0
    Top = 92
    Width = 404
    Height = 203
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 1
    object grbResult: TGroupBox
      Left = 5
      Top = 5
      Width = 394
      Height = 193
      Align = alClient
      Caption = ' Результат '
      TabOrder = 0
      object pnBackRichEdit: TPanel
        Left = 2
        Top = 15
        Width = 390
        Height = 176
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 5
        TabOrder = 0
      end
    end
  end
  inherited IBTran: TIBTransaction
    Left = 224
    Top = 169
  end
  inherited Mainqr: TIBQuery
    Left = 168
    Top = 169
  end
  object sd: TSaveDialog
    Filter = 
      'Файлы RTF (*.rtf)|*.rtf|Файлы TXT (*.txt)|*.txt|Все файлы (*.*)|' +
      '*.*'
    Options = [ofOverwritePrompt, ofEnableSizing]
    Left = 87
    Top = 173
  end
end
