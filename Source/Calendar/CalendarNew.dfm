object frmCalendarNew: TfrmCalendarNew
  Left = 330
  Top = 202
  BorderStyle = bsDialog
  Caption = 'Создать календарь'
  ClientHeight = 263
  ClientWidth = 351
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 176
    Width = 128
    Height = 13
    Caption = 'На основании документа'
  end
  object Label2: TLabel
    Left = 8
    Top = 131
    Width = 122
    Height = 13
    Caption = 'Дата вступления в силу'
  end
  object Label3: TLabel
    Left = 8
    Top = 155
    Width = 207
    Height = 13
    Caption = 'Процент доплаты за работу в праздники'
  end
  object ComboEdit1: TComboEdit
    Left = 8
    Top = 192
    Width = 337
    Height = 21
    Color = clBtnFace
    DirectInput = False
    GlyphKind = gkEllipsis
    ButtonWidth = 16
    NumGlyphs = 1
    TabOrder = 3
    Text = ' '
    OnButtonClick = ComboEdit1ButtonClick
  end
  object btnOK: TButton
    Left = 192
    Top = 232
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 4
  end
  object btnClose: TButton
    Left = 272
    Top = 232
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Отмена'
    ModalResult = 2
    TabOrder = 5
  end
  object DateEdit1: TDateEdit
    Left = 144
    Top = 128
    Width = 201
    Height = 21
    NumGlyphs = 2
    Weekends = [Sun, Sat]
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 337
    Height = 113
    Caption = 'Способ создания'
    TabOrder = 0
    object RadioButton1: TRadioButton
      Left = 8
      Top = 34
      Width = 321
      Height = 17
      Caption = 'Копировать данные из текущего календаря'
      TabOrder = 1
      OnClick = RadioButtonsClick
    end
    object RadioButton2: TRadioButton
      Left = 8
      Top = 16
      Width = 169
      Height = 17
      Caption = 'Пустой календарь'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = RadioButtonsClick
    end
    object GroupBox2: TGroupBox
      Left = 123
      Top = 50
      Width = 209
      Height = 57
      Caption = 'Копировать только'
      TabOrder = 2
      object CheckBox1: TCheckBox
        Left = 8
        Top = 16
        Width = 81
        Height = 17
        Caption = 'Праздники'
        Checked = True
        State = cbChecked
        TabOrder = 0
      end
      object CheckBox2: TCheckBox
        Left = 104
        Top = 16
        Width = 81
        Height = 17
        Caption = 'Переносы'
        Checked = True
        State = cbChecked
        TabOrder = 1
      end
      object CheckBox3: TCheckBox
        Left = 8
        Top = 32
        Width = 193
        Height = 17
        Caption = 'Графики норм рабочего времени'
        Checked = True
        State = cbChecked
        TabOrder = 2
      end
    end
  end
  object RxSpinEdit1: TRxSpinEdit
    Left = 224
    Top = 152
    Width = 121
    Height = 21
    ButtonKind = bkStandard
    Value = 100
    TabOrder = 2
  end
  object quTemp: TIBQuery
    Transaction = trTemp
    BufferChunks = 1000
    CachedUpdates = False
    Left = 80
    Top = 176
  end
  object trTemp: TIBTransaction
    Active = False
    DefaultAction = TARollback
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    AutoStopAction = saNone
    Left = 152
    Top = 176
  end
end
