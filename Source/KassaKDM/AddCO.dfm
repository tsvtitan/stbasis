inherited FAddCO: TFAddCO
  Left = 217
  Top = 200
  ClientHeight = 380
  ClientWidth = 533
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object LTitle: TLabel [0]
    Left = 24
    Top = 16
    Width = 231
    Height = 20
    Alignment = taRightJustify
    Caption = 'Приходный кассовый ордер №'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel [1]
    Left = 384
    Top = 16
    Width = 18
    Height = 20
    Caption = 'от'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object LEmp: TLabel [2]
    Left = 17
    Top = 187
    Width = 60
    Height = 13
    Alignment = taRightJustify
    Caption = 'Принято от:'
  end
  object Label5: TLabel [3]
    Left = 11
    Top = 211
    Width = 65
    Height = 13
    Caption = 'Основаание:'
  end
  object Label6: TLabel [4]
    Left = 9
    Top = 234
    Width = 67
    Height = 13
    Caption = 'Приложение:'
  end
  object LSumDebit: TLabel [5]
    Left = 37
    Top = 259
    Width = 37
    Height = 13
    Caption = 'Сумма:'
  end
  object LNDS: TLabel [6]
    Left = 235
    Top = 290
    Width = 66
    Height = 13
    Caption = 'Ставка НДС:'
    Enabled = False
  end
  object LNDS1: TLabel [7]
    Left = 376
    Top = 290
    Width = 27
    Height = 13
    Caption = 'НДС:'
    Enabled = False
  end
  object LCur: TLabel [8]
    Left = 384
    Top = 152
    Width = 41
    Height = 13
    Caption = 'Валюта:'
    Visible = False
  end
  object LOnDoc: TLabel [9]
    Left = 3
    Top = 259
    Width = 73
    Height = 13
    Alignment = taRightJustify
    Caption = 'По документу:'
    Visible = False
  end
  object LSumKredit: TLabel [10]
    Left = 39
    Top = 291
    Width = 37
    Height = 13
    Alignment = taRightJustify
    Caption = 'Сумма:'
    Visible = False
  end
  object Label1: TLabel [11]
    Left = 37
    Top = 315
    Width = 40
    Height = 13
    Alignment = taRightJustify
    Caption = 'Кассир:'
  end
  inherited BOk: TButton
    Left = 368
    Top = 352
    TabOrder = 10
  end
  inherited BCancel: TButton
    Left = 456
    Top = 352
    TabOrder = 21
  end
  object DateTime: TDateTimePicker
    Left = 408
    Top = 16
    Width = 81
    Height = 21
    CalAlignment = dtaLeft
    Date = 36601.8222225463
    Time = 36601.8222225463
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 48
    Width = 369
    Height = 129
    Caption = 'Корреспондирующий счет,аналитика'
    TabOrder = 5
    object Label3: TLabel
      Left = 48
      Top = 28
      Width = 53
      Height = 13
      Caption = 'Корр.счет:'
    end
    object LSub1: TLabel
      Left = 8
      Top = 53
      Width = 92
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Constraints.MaxWidth = 100
    end
    object LSub2: TLabel
      Left = 8
      Top = 75
      Width = 91
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
    end
    object LSub3: TLabel
      Left = 7
      Top = 100
      Width = 93
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
    end
    object ESub1: TEdit
      Left = 104
      Top = 48
      Width = 241
      Height = 21
      ParentColor = True
      ReadOnly = True
      TabOrder = 2
    end
    object ESub2: TEdit
      Left = 104
      Top = 72
      Width = 241
      Height = 21
      ParentColor = True
      ReadOnly = True
      TabOrder = 4
    end
    object ESub3: TEdit
      Left = 104
      Top = 96
      Width = 241
      Height = 21
      ParentColor = True
      ReadOnly = True
      TabOrder = 6
    end
    object BKorAc: TButton
      Left = 169
      Top = 24
      Width = 17
      Height = 21
      Caption = '...'
      Default = True
      TabOrder = 1
      OnClick = BKorAcClick
    end
    object BSub1: TButton
      Left = 344
      Top = 48
      Width = 17
      Height = 21
      Caption = '...'
      Default = True
      TabOrder = 3
      Visible = False
      OnClick = BSub1Click
      OnKeyDown = FormKeyDown
    end
    object BSub2: TButton
      Left = 344
      Top = 72
      Width = 17
      Height = 21
      Caption = '...'
      Default = True
      TabOrder = 5
      Visible = False
      OnClick = BSub2Click
    end
    object BSub3: TButton
      Left = 344
      Top = 96
      Width = 17
      Height = 21
      Caption = '...'
      Default = True
      TabOrder = 7
      Visible = False
      OnClick = BSub3Click
    end
    object MEKorAc: TMaskEdit
      Left = 104
      Top = 24
      Width = 65
      Height = 21
      EditMask = 'aaa\.aaa\.a;1; '
      MaxLength = 9
      ReadOnly = True
      TabOrder = 0
      Text = '   .   . '
    end
  end
  object EEmp: TEdit
    Left = 80
    Top = 184
    Width = 433
    Height = 21
    ParentColor = True
    ReadOnly = True
    TabOrder = 6
  end
  object BEmp: TButton
    Left = 513
    Top = 184
    Width = 17
    Height = 21
    Caption = '...'
    Default = True
    TabOrder = 7
    OnClick = BEmpClick
  end
  object EBasis: TEdit
    Left = 80
    Top = 208
    Width = 433
    Height = 21
    ParentColor = True
    ReadOnly = True
    TabOrder = 8
  end
  object BBasis: TButton
    Left = 513
    Top = 208
    Width = 17
    Height = 21
    Caption = '...'
    Default = True
    TabOrder = 9
    OnClick = BBasisClick
  end
  object EAppend: TEdit
    Left = 80
    Top = 232
    Width = 433
    Height = 21
    ParentColor = True
    ReadOnly = True
    TabOrder = 11
  end
  object BAppend: TButton
    Left = 513
    Top = 232
    Width = 17
    Height = 21
    Caption = '...'
    Default = True
    TabOrder = 12
    OnClick = BAppendClick
  end
  object ESum: TEdit
    Left = 80
    Top = 256
    Width = 121
    Height = 21
    TabOrder = 15
    OnExit = ESumExit
  end
  object CBNDS: TCheckBox
    Left = 80
    Top = 288
    Width = 145
    Height = 17
    Caption = 'Указать в тексте НДС'
    TabOrder = 17
    OnClick = CBNDSClick
  end
  object ENDS: TEdit
    Left = 304
    Top = 286
    Width = 49
    Height = 21
    Enabled = False
    ParentColor = True
    TabOrder = 18
  end
  object ESumNDS: TEdit
    Left = 405
    Top = 286
    Width = 124
    Height = 21
    Enabled = False
    ReadOnly = True
    TabOrder = 20
  end
  object BNDS: TButton
    Left = 353
    Top = 286
    Width = 17
    Height = 21
    Caption = '...'
    Default = True
    Enabled = False
    TabOrder = 19
    OnClick = BNDSClick
  end
  object ENum: TEdit
    Left = 256
    Top = 16
    Width = 121
    Height = 21
    TabOrder = 0
  end
  object ECur: TEdit
    Left = 427
    Top = 149
    Width = 65
    Height = 21
    ParentColor = True
    ReadOnly = True
    TabOrder = 3
    Visible = False
  end
  object BCur: TButton
    Left = 492
    Top = 149
    Width = 17
    Height = 21
    Caption = '...'
    Default = True
    TabOrder = 4
    Visible = False
    OnClick = BCurClick
  end
  object RGKassa: TRadioGroup
    Left = 384
    Top = 48
    Width = 129
    Height = 57
    Caption = 'Касса ...'
    ItemIndex = 0
    Items.Strings = (
      'рублевая (Дт.50.1)'
      'валютная (Дт.50.2)')
    TabOrder = 2
    OnClick = RGKassaClick
  end
  object EOnDoc: TEdit
    Left = 80
    Top = 256
    Width = 433
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = True
    ParentFont = False
    ReadOnly = True
    TabOrder = 13
    Visible = False
  end
  object ESumKredit: TEdit
    Left = 80
    Top = 288
    Width = 121
    Height = 21
    TabOrder = 16
    Visible = False
    OnExit = ESumKreditExit
  end
  object BOnDoc: TButton
    Left = 513
    Top = 255
    Width = 17
    Height = 21
    Caption = '...'
    Default = True
    TabOrder = 14
    Visible = False
    OnClick = BOnDocClick
  end
  object ECashier: TEdit
    Left = 80
    Top = 312
    Width = 433
    Height = 21
    ParentColor = True
    ReadOnly = True
    TabOrder = 22
  end
  object BCashier: TButton
    Left = 508
    Top = 312
    Width = 17
    Height = 21
    Caption = '...'
    Default = True
    TabOrder = 23
    OnClick = BCashierClick
  end
end
