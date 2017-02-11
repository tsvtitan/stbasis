inherited fmEditRBAnnouncement: TfmEditRBAnnouncement
  Left = 317
  Top = 141
  Caption = 'fmEditRBAnnouncement'
  ClientHeight = 481
  ClientWidth = 400
  OnActivate = FormActivate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object lbNumRelease: TLabel [0]
    Left = 64
    Top = 12
    Width = 41
    Height = 13
    Alignment = taRightJustify
    Caption = 'Выпуск:'
    FocusControl = edNumRelease
  end
  object lbTreeHeading: TLabel [1]
    Left = 60
    Top = 36
    Width = 45
    Height = 13
    Alignment = taRightJustify
    Caption = 'Рубрика:'
    FocusControl = edTreeheading
  end
  object lbContactPhone: TLabel [2]
    Left = 65
    Top = 193
    Width = 110
    Height = 13
    Alignment = taRightJustify
    Caption = 'Контактный телефон:'
    FocusControl = edContactPhone
  end
  object lbWord: TLabel [3]
    Left = 19
    Top = 60
    Width = 86
    Height = 13
    Alignment = taRightJustify
    Caption = 'Ключевое слово:'
    FocusControl = cmbWord
  end
  object lbtext: TLabel [4]
    Left = 8
    Top = 83
    Width = 97
    Height = 13
    Alignment = taRightJustify
    Caption = 'Текст объявления:'
    FocusControl = reText
  end
  object lbHomePhone: TLabel [5]
    Left = 71
    Top = 217
    Width = 104
    Height = 13
    Alignment = taRightJustify
    Caption = 'Домашний телефон:'
    FocusControl = edHomePhone
  end
  object lbWorkPhone: TLabel [6]
    Left = 84
    Top = 241
    Width = 91
    Height = 13
    Alignment = taRightJustify
    Caption = 'Рабочий телефон:'
    FocusControl = edWorkPhone
  end
  object lbAbout: TLabel [7]
    Left = 109
    Top = 264
    Width = 66
    Height = 13
    Alignment = taRightJustify
    Caption = 'Примечание:'
    FocusControl = meAbout
  end
  object lbCopyPrint: TLabel [8]
    Left = 188
    Top = 352
    Width = 124
    Height = 13
    Alignment = taRightJustify
    Caption = 'Количество публикаций:'
    FocusControl = edCopyPrint
  end
  object lbWhoIn: TLabel [9]
    Left = 127
    Top = 378
    Width = 48
    Height = 13
    Alignment = taRightJustify
    Caption = 'Кто ввел:'
    FocusControl = edWhoIn
  end
  object lbWhoChange: TLabel [10]
    Left = 108
    Top = 402
    Width = 68
    Height = 13
    Alignment = taRightJustify
    Caption = 'Кто изменил:'
    FocusControl = edWhoChange
  end
  inherited pnBut: TPanel
    Top = 443
    Width = 400
    TabOrder = 16
    inherited Panel2: TPanel
      Left = 215
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 424
    TabOrder = 15
  end
  object edNumRelease: TEdit [13]
    Left = 112
    Top = 8
    Width = 258
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 0
    OnChange = edNumReleaseChange
    OnKeyDown = edNumReleaseKeyDown
    OnKeyPress = edNumReleaseKeyPress
  end
  object bibNumRelease: TButton [14]
    Left = 374
    Top = 8
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 1
    OnClick = bibNumReleaseClick
  end
  object edTreeheading: TEdit [15]
    Left = 112
    Top = 32
    Width = 258
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 2
    OnChange = edNumReleaseChange
  end
  object bibTreeHeading: TButton [16]
    Left = 374
    Top = 32
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 3
    OnClick = bibTreeHeadingClick
  end
  object edContactPhone: TEdit [17]
    Left = 183
    Top = 189
    Width = 211
    Height = 21
    MaxLength = 100
    TabOrder = 7
    OnChange = edNumReleaseChange
    OnExit = edContactPhoneExit
  end
  object edHomePhone: TEdit [18]
    Left = 183
    Top = 213
    Width = 211
    Height = 21
    MaxLength = 100
    TabOrder = 8
    OnChange = edNumReleaseChange
    OnExit = edContactPhoneExit
  end
  object edWorkPhone: TEdit [19]
    Left = 183
    Top = 237
    Width = 211
    Height = 21
    MaxLength = 100
    TabOrder = 9
    OnChange = edNumReleaseChange
    OnExit = edContactPhoneExit
  end
  object meAbout: TMemo [20]
    Left = 183
    Top = 261
    Width = 211
    Height = 85
    TabOrder = 10
    OnChange = edNumReleaseChange
    OnKeyDown = meTextKeyDown
    OnKeyPress = meTextKeyPress
  end
  object edCopyPrint: TEdit [21]
    Left = 320
    Top = 349
    Width = 59
    Height = 21
    MaxLength = 6
    ReadOnly = True
    TabOrder = 11
    Text = '1'
    OnChange = edNumReleaseChange
  end
  object udCopyPrint: TUpDown [22]
    Left = 379
    Top = 349
    Width = 15
    Height = 21
    Associate = edCopyPrint
    Min = 1
    Position = 1
    TabOrder = 12
    Thousands = False
    Wrap = False
    OnChanging = udCopyPrintChanging
  end
  object cmbWord: TComboBox [23]
    Left = 112
    Top = 56
    Width = 282
    Height = 21
    ItemHeight = 13
    TabOrder = 4
    OnChange = edNumReleaseChange
    OnEnter = cmbWordEnter
    OnKeyDown = cmbWordKeyDown
    OnKeyPress = cmbWordKeyPress
    OnKeyUp = cmbWordKeyUp
  end
  object reText: TRichEdit [24]
    Left = 112
    Top = 80
    Width = 282
    Height = 106
    PopupMenu = pmRusWord
    ScrollBars = ssVertical
    TabOrder = 5
    OnChange = edNumReleaseChange
    OnExit = meTextExit
    OnKeyDown = meTextKeyDown
    OnKeyPress = meTextKeyPress
  end
  object bibCheckRusWords: TButton [25]
    Left = 8
    Top = 160
    Width = 96
    Height = 25
    Caption = 'Проверить ->'
    TabOrder = 6
    OnClick = bibCheckRusWordsClick
  end
  object edWhoIn: TEdit [26]
    Left = 183
    Top = 374
    Width = 211
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 13
    OnChange = edNumReleaseChange
    OnExit = edContactPhoneExit
  end
  object edWhoChange: TEdit [27]
    Left = 183
    Top = 398
    Width = 211
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 14
    OnChange = edNumReleaseChange
    OnExit = edContactPhoneExit
  end
  inherited IBTran: TIBTransaction
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    Left = 16
    Top = 266
  end
  object pmRusWord: TPopupMenu
    Left = 216
    Top = 93
    object miRusWordAdd: TMenuItem
      Caption = 'Добавить'
      Default = True
      Hint = 'Добавить слово в словарь'
      OnClick = miRusWordAddClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object miRusWordCancel: TMenuItem
      Caption = 'Отмена'
      Hint = 'Отмена'
    end
  end
end
