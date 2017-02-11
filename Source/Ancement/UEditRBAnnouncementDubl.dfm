inherited fmEditRBAnnouncementDubl: TfmEditRBAnnouncementDubl
  Left = 195
  Top = 129
  Caption = 'fmEditRBAnnouncementDubl'
  ClientHeight = 453
  ClientWidth = 401
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object lbNumRelease: TLabel [0]
    Left = 77
    Top = 12
    Width = 41
    Height = 13
    Caption = 'Выпуск:'
  end
  object lbTreeHeading: TLabel [1]
    Left = 73
    Top = 39
    Width = 45
    Height = 13
    Caption = 'Рубрика:'
  end
  object lbContactPhone: TLabel [2]
    Left = 64
    Top = 207
    Width = 110
    Height = 13
    Caption = 'Контактный телефон:'
  end
  object lbWord: TLabel [3]
    Left = 32
    Top = 67
    Width = 86
    Height = 13
    Caption = 'Ключевое слово:'
  end
  object lbtext: TLabel [4]
    Left = 21
    Top = 94
    Width = 97
    Height = 13
    Caption = 'Текст объявления:'
  end
  object lbHomePhone: TLabel [5]
    Left = 70
    Top = 234
    Width = 104
    Height = 13
    Caption = 'Домашний телефон:'
  end
  object lbWorkPhone: TLabel [6]
    Left = 83
    Top = 261
    Width = 91
    Height = 13
    Caption = 'Рабочий телефон:'
  end
  object lbAbout: TLabel [7]
    Left = 108
    Top = 287
    Width = 66
    Height = 13
    Caption = 'Примечание:'
  end
  object lbCopyPrint: TLabel [8]
    Left = 187
    Top = 379
    Width = 124
    Height = 13
    Caption = 'Количество публикаций:'
  end
  inherited pnBut: TPanel
    Top = 415
    Width = 401
    TabOrder = 13
    inherited Panel2: TPanel
      Left = 216
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 392
    TabOrder = 12
  end
  object edNumRelease: TEdit [11]
    Left = 126
    Top = 8
    Width = 99
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 0
    OnChange = edNumReleaseChange
  end
  object bibNumRelease: TButton [12]
    Left = 225
    Top = 8
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 1
    OnClick = bibNumReleaseClick
  end
  object edTreeheading: TEdit [13]
    Left = 126
    Top = 35
    Width = 189
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 2
    OnChange = edNumReleaseChange
  end
  object bibTreeHeading: TButton [14]
    Left = 315
    Top = 35
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 3
    OnClick = bibTreeHeadingClick
  end
  object edContactPhone: TEdit [15]
    Left = 182
    Top = 203
    Width = 211
    Height = 21
    MaxLength = 100
    TabOrder = 6
    OnChange = edNumReleaseChange
    OnExit = edContactPhoneExit
  end
  object meText: TMemo [16]
    Left = 126
    Top = 91
    Width = 267
    Height = 106
    ScrollBars = ssVertical
    TabOrder = 5
    OnChange = edNumReleaseChange
    OnExit = meTextExit
  end
  object edHomePhone: TEdit [17]
    Left = 182
    Top = 230
    Width = 211
    Height = 21
    MaxLength = 100
    TabOrder = 7
    OnChange = edNumReleaseChange
    OnExit = edContactPhoneExit
  end
  object edWorkPhone: TEdit [18]
    Left = 182
    Top = 257
    Width = 211
    Height = 21
    MaxLength = 100
    TabOrder = 8
    OnChange = edNumReleaseChange
    OnExit = edContactPhoneExit
  end
  object meAbout: TMemo [19]
    Left = 182
    Top = 284
    Width = 211
    Height = 85
    TabOrder = 9
    OnChange = edNumReleaseChange
  end
  object edCopyPrint: TEdit [20]
    Left = 319
    Top = 376
    Width = 59
    Height = 21
    MaxLength = 6
    ReadOnly = True
    TabOrder = 10
    Text = '1'
  end
  object udCopyPrint: TUpDown [21]
    Left = 378
    Top = 376
    Width = 15
    Height = 21
    Associate = edCopyPrint
    Min = 1
    Position = 1
    TabOrder = 11
    Thousands = False
    Wrap = False
  end
  object cmbWord: TComboBox [22]
    Left = 126
    Top = 63
    Width = 211
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 4
    OnChange = edNumReleaseChange
    OnEnter = cmbWordEnter
    OnKeyDown = cmbWordKeyDown
  end
  inherited IBTran: TIBTransaction
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    Left = 16
    Top = 266
  end
  object IBQKeywords: TIBQuery
    BufferChunks = 1000
    CachedUpdates = False
    SQL.Strings = (
      'select  * from KEYWORDS')
    Left = 16
    Top = 216
  end
end
