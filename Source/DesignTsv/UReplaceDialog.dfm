object fmReplaceDialog: TfmReplaceDialog
  Left = 285
  Top = 166
  BorderStyle = bsDialog
  Caption = 'Заменить'
  ClientHeight = 268
  ClientWidth = 362
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lbFindText: TLabel
    Left = 8
    Top = 11
    Width = 78
    Height = 13
    Caption = 'Строка поиска:'
    WordWrap = True
  end
  object lbReplace: TLabel
    Left = 18
    Top = 39
    Width = 68
    Height = 13
    Caption = 'Заменить на:'
    WordWrap = True
  end
  object pnBut: TPanel
    Left = 0
    Top = 230
    Width = 362
    Height = 38
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 6
    object Panel2: TPanel
      Left = 177
      Top = 0
      Width = 185
      Height = 38
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object bibOk: TButton
        Left = 22
        Top = 5
        Width = 75
        Height = 25
        Hint = 'Подтвердить'
        Caption = 'OK'
        Default = True
        TabOrder = 0
        OnClick = bibOkClick
      end
      object bibCancel: TButton
        Left = 104
        Top = 5
        Width = 75
        Height = 25
        Hint = 'Отменить'
        Cancel = True
        Caption = 'Отмена'
        ModalResult = 2
        TabOrder = 1
      end
    end
  end
  object grbOptions: TGroupBox
    Left = 8
    Top = 62
    Width = 168
    Height = 98
    Caption = ' Опиции '
    TabOrder = 2
    object chbWithCase: TCheckBox
      Left = 8
      Top = 16
      Width = 145
      Height = 17
      Caption = 'С учетом регистра'
      TabOrder = 0
    end
    object chbWordOnly: TCheckBox
      Left = 8
      Top = 35
      Width = 137
      Height = 17
      Caption = 'Слово целиком'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object chbRegExpresion: TCheckBox
      Left = 8
      Top = 54
      Width = 153
      Height = 17
      Caption = 'Регулярные выражения'
      Enabled = False
      TabOrder = 2
    end
    object chbPromt: TCheckBox
      Left = 8
      Top = 73
      Width = 153
      Height = 17
      Caption = 'Вопрос при замене'
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
  end
  object grbDirection: TGroupBox
    Left = 185
    Top = 62
    Width = 170
    Height = 98
    Caption = ' Направление '
    TabOrder = 3
    object rbForward: TRadioButton
      Left = 8
      Top = 18
      Width = 153
      Height = 18
      Caption = 'Вперед'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object rgBackward: TRadioButton
      Left = 8
      Top = 39
      Width = 153
      Height = 18
      Caption = 'Назад'
      TabOrder = 1
    end
  end
  object grbScope: TGroupBox
    Left = 8
    Top = 164
    Width = 168
    Height = 60
    Caption = ' Область поиска '
    TabOrder = 4
    object rbGlobal: TRadioButton
      Left = 8
      Top = 16
      Width = 153
      Height = 18
      Caption = 'Везде'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object rbSelected: TRadioButton
      Left = 8
      Top = 36
      Width = 153
      Height = 18
      Caption = 'В выделенном тексте'
      TabOrder = 1
    end
  end
  object grbOrigin: TGroupBox
    Left = 185
    Top = 164
    Width = 170
    Height = 60
    Caption = ' Откуда начинать '
    TabOrder = 5
    object rbFromCursor: TRadioButton
      Left = 8
      Top = 16
      Width = 153
      Height = 18
      Caption = 'От курсора'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object rbEntire: TRadioButton
      Left = 8
      Top = 36
      Width = 153
      Height = 18
      Caption = 'От начала'
      TabOrder = 1
    end
  end
  object cmbSearchText: TComboBox
    Left = 96
    Top = 9
    Width = 257
    Height = 21
    ItemHeight = 13
    TabOrder = 0
  end
  object cmbReplace: TComboBox
    Left = 96
    Top = 37
    Width = 257
    Height = 21
    ItemHeight = 13
    TabOrder = 1
  end
end
