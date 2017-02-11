inherited fmEditRBCashOrders: TfmEditRBCashOrders
  Left = 344
  Top = 85
  Caption = 'fmEditRBCashOrders'
  ClientHeight = 550
  ClientWidth = 534
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object LNum: TLabel [0]
    Left = 240
    Top = 16
    Width = 15
    Height = 20
    Alignment = taRightJustify
    Caption = '№'
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
    Visible = False
  end
  object LEmp: TLabel [2]
    Left = 17
    Top = 307
    Width = 60
    Height = 13
    Alignment = taRightJustify
    Caption = 'Принято от:'
  end
  object LBasis: TLabel [3]
    Left = 11
    Top = 331
    Width = 65
    Height = 13
    Caption = 'Основаание:'
  end
  object LAppend: TLabel [4]
    Left = 9
    Top = 354
    Width = 67
    Height = 13
    Caption = 'Приложение:'
  end
  object LCashier: TLabel [5]
    Left = 37
    Top = 456
    Width = 40
    Height = 13
    Alignment = taRightJustify
    Caption = 'Кассир:'
  end
  object Label9: TLabel [6]
    Left = 73
    Top = 86
    Width = 8
    Height = 20
    Alignment = taRightJustify
    Caption = 'c'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object Label10: TLabel [7]
    Left = 176
    Top = 88
    Width = 20
    Height = 20
    Caption = 'до'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  inherited pnBut: TPanel
    Top = 512
    Width = 534
    inherited Panel2: TPanel
      Left = 264
      Width = 270
      inherited bibOk: TBitBtn
        Left = 110
      end
      inherited bibCancel: TBitBtn
        Left = 192
      end
    end
  end
  inherited cbInString: TCheckBox
    Top = 496
  end
  object DateTime: TDateTimePicker [10]
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
    TabOrder = 2
    Visible = False
  end
  object GBKorAc: TGroupBox [11]
    Left = 8
    Top = 176
    Width = 369
    Height = 121
    Caption = 'Корреспондирующий счет,аналитика'
    TabOrder = 3
    object Label3: TLabel
      Left = 48
      Top = 20
      Width = 53
      Height = 13
      Caption = 'Корр.счет:'
      Enabled = False
    end
    object BKorAc: TButton
      Left = 169
      Top = 16
      Width = 16
      Height = 21
      Caption = '...'
      Enabled = False
      TabOrder = 1
      OnClick = BKorAcClick
    end
    object MEKorAc: TMaskEdit
      Left = 104
      Top = 16
      Width = 65
      Height = 21
      Enabled = False
      EditMask = 'aaa\.aaa\.a;1; '
      MaxLength = 9
      ReadOnly = True
      TabOrder = 0
      Text = '   .   . '
      OnChange = EditChange
    end
    inline FrameSub: TFrameSubkonto
      Left = 2
      Top = 37
      Width = 361
      Height = 76
      TabOrder = 2
      inherited LSub1: TLabel
        Left = 96
      end
      inherited LSub2: TLabel
        Left = 96
      end
      inherited LSub3: TLabel
        Left = 96
      end
      inherited LSub4: TLabel
        Left = 96
      end
      inherited LSub5: TLabel
        Left = 96
      end
      inherited LSub6: TLabel
        Left = 96
      end
      inherited LSub7: TLabel
        Left = 96
      end
      inherited LSub8: TLabel
        Left = 96
      end
      inherited LSub9: TLabel
        Left = 96
      end
      inherited LSub10: TLabel
        Left = 96
      end
      inherited ESub1: TEdit
        Left = 101
      end
      inherited BSub1: TButton
        Left = 324
      end
      inherited ESub2: TEdit
        Left = 101
      end
      inherited BSub2: TButton
        Left = 324
      end
      inherited ESub3: TEdit
        Left = 101
      end
      inherited BSub3: TButton
        Left = 324
      end
      inherited ESub4: TEdit
        Left = 101
      end
      inherited BSub4: TButton
        Left = 324
      end
      inherited ESub5: TEdit
        Left = 101
      end
      inherited BSub5: TButton
        Left = 324
      end
      inherited ESub6: TEdit
        Left = 101
      end
      inherited BSub6: TButton
        Left = 324
      end
      inherited ESub7: TEdit
        Left = 101
      end
      inherited BSub7: TButton
        Left = 324
      end
      inherited ESub8: TEdit
        Left = 101
      end
      inherited BSub8: TButton
        Left = 324
      end
      inherited ESub9: TEdit
        Left = 101
      end
      inherited BSub9: TButton
        Left = 324
      end
      inherited ESub10: TEdit
        Left = 101
      end
      inherited BSub10: TButton
        Left = 324
      end
    end
  end
  object EEmp: TEdit [12]
    Left = 80
    Top = 304
    Width = 433
    Height = 21
    ParentColor = True
    ReadOnly = True
    TabOrder = 4
    OnChange = EditChange
  end
  object BEmp: TButton [13]
    Left = 513
    Top = 304
    Width = 17
    Height = 21
    Caption = '...'
    TabOrder = 5
    OnClick = BEmpClick
  end
  object EBasis: TEdit [14]
    Left = 80
    Top = 328
    Width = 433
    Height = 21
    ParentColor = True
    ReadOnly = True
    TabOrder = 6
    OnChange = EditChange
  end
  object BBasis: TButton [15]
    Left = 513
    Top = 328
    Width = 17
    Height = 21
    Caption = '...'
    TabOrder = 7
    OnClick = BBasisClick
  end
  object EAppend: TEdit [16]
    Left = 80
    Top = 352
    Width = 433
    Height = 21
    ParentColor = True
    ReadOnly = True
    TabOrder = 8
    OnChange = EditChange
  end
  object BAppend: TButton [17]
    Left = 513
    Top = 352
    Width = 17
    Height = 21
    Caption = '...'
    TabOrder = 9
    OnClick = BAppendClick
  end
  object ENum: TEdit [18]
    Left = 256
    Top = 16
    Width = 121
    Height = 21
    TabOrder = 10
    OnChange = EditChange
  end
  object POutCashOrders: TPanel [19]
    Left = -8
    Top = 374
    Width = 561
    Height = 59
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 11
    Visible = False
    object LOnDoc: TLabel
      Left = 11
      Top = 6
      Width = 73
      Height = 13
      Alignment = taRightJustify
      Caption = 'По документу:'
      Enabled = False
    end
    object LSumKredit: TLabel
      Left = 47
      Top = 33
      Width = 37
      Height = 13
      Alignment = taRightJustify
      Caption = 'Сумма:'
    end
    object EOnDoc: TEdit
      Left = 88
      Top = 3
      Width = 433
      Height = 21
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = True
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
    end
    object BOnDoc: TButton
      Left = 521
      Top = 4
      Width = 17
      Height = 21
      Caption = '...'
      Enabled = False
      TabOrder = 1
      OnClick = BOnDocClick
    end
    object ESumKredit: TEdit
      Left = 88
      Top = 30
      Width = 121
      Height = 21
      TabOrder = 2
      OnChange = EditChange
    end
  end
  object PInCashOrders: TPanel [20]
    Left = 24
    Top = 373
    Width = 529
    Height = 77
    BevelOuter = bvNone
    TabOrder = 12
    object LSumDebit: TLabel
      Left = 13
      Top = 8
      Width = 37
      Height = 13
      Caption = 'Сумма:'
    end
    object LNDS: TLabel
      Left = 107
      Top = 33
      Width = 66
      Height = 13
      Caption = 'Ставка НДС:'
      Enabled = False
    end
    object LNDS1: TLabel
      Left = 248
      Top = 33
      Width = 27
      Height = 13
      Caption = 'НДС:'
      Enabled = False
    end
    object lNP: TLabel
      Left = 107
      Top = 57
      Width = 58
      Height = 13
      Caption = 'Ставка НП:'
      Enabled = False
    end
    object lNP1: TLabel
      Left = 248
      Top = 57
      Width = 19
      Height = 13
      Caption = 'НП:'
      Enabled = False
    end
    object ESum: TEdit
      Left = 56
      Top = 4
      Width = 121
      Height = 21
      TabOrder = 0
      OnChange = EditChange
    end
    object CBNDS: TCheckBox
      Left = 56
      Top = 33
      Width = 49
      Height = 17
      Caption = 'НДС'
      TabOrder = 1
      OnClick = CBNDSClick
    end
    object ENDS: TEdit
      Left = 176
      Top = 28
      Width = 49
      Height = 21
      Enabled = False
      ParentColor = True
      TabOrder = 2
      OnChange = EditChange
    end
    object ESumNDS: TEdit
      Left = 277
      Top = 28
      Width = 124
      Height = 21
      Enabled = False
      ReadOnly = True
      TabOrder = 3
      OnChange = EditChange
    end
    object BNDS: TButton
      Left = 225
      Top = 28
      Width = 17
      Height = 21
      Caption = '...'
      Enabled = False
      TabOrder = 4
      OnClick = BNDSClick
    end
    object cbNP: TCheckBox
      Left = 56
      Top = 57
      Width = 41
      Height = 17
      Caption = 'НП'
      TabOrder = 5
      OnClick = cbNPClick
    end
    object eNP: TEdit
      Left = 176
      Top = 52
      Width = 49
      Height = 21
      Enabled = False
      ParentColor = True
      TabOrder = 6
      OnChange = EditChange
    end
    object bNP: TButton
      Left = 225
      Top = 52
      Width = 17
      Height = 21
      Caption = '...'
      Enabled = False
      TabOrder = 7
      OnClick = bNPClick
    end
    object eSumNP: TEdit
      Left = 277
      Top = 52
      Width = 124
      Height = 21
      Enabled = False
      ReadOnly = True
      TabOrder = 8
      OnChange = EditChange
    end
  end
  object ECashier: TEdit [21]
    Left = 80
    Top = 456
    Width = 433
    Height = 21
    ParentColor = True
    ReadOnly = True
    TabOrder = 13
    OnChange = EditChange
  end
  object BCashier: TButton [22]
    Left = 513
    Top = 456
    Width = 17
    Height = 21
    Caption = '...'
    TabOrder = 14
    OnClick = BCashierClick
  end
  object GBCurrency: TGroupBox [23]
    Left = 384
    Top = 48
    Width = 145
    Height = 65
    Caption = 'Валюта, курс'
    TabOrder = 15
    Visible = False
    object LCur: TLabel
      Left = 12
      Top = 23
      Width = 41
      Height = 13
      Caption = 'Валюта:'
    end
    object LKursCur: TLabel
      Left = 13
      Top = 48
      Width = 3
      Height = 13
    end
    object ECur: TEdit
      Left = 56
      Top = 20
      Width = 65
      Height = 21
      ParentColor = True
      ReadOnly = True
      TabOrder = 0
      OnChange = EditChange
    end
    object BCur: TButton
      Left = 121
      Top = 20
      Width = 17
      Height = 21
      Caption = '...'
      TabOrder = 1
      OnClick = BCurClick
    end
  end
  object CBDoc: TComboBox [24]
    Left = 8
    Top = 16
    Width = 225
    Height = 21
    ItemHeight = 13
    TabOrder = 16
    Text = 'Приходный кассовый ордер'
    OnChange = CBDocChange
    Items.Strings = (
      'Приходный кассовый ордер'
      'Расходный кассовый ордер')
  end
  object GBKassa: TGroupBox [25]
    Left = 8
    Top = 40
    Width = 369
    Height = 129
    Caption = 'Касса,аналитика'
    TabOrder = 17
    object LKassa: TLabel
      Left = 63
      Top = 20
      Width = 34
      Height = 13
      Alignment = taRightJustify
      Caption = 'Касса:'
    end
    object BKassa: TButton
      Left = 169
      Top = 16
      Width = 17
      Height = 21
      Caption = '...'
      TabOrder = 0
      OnClick = BKassaClick
    end
    object MEKassa: TMaskEdit
      Left = 104
      Top = 16
      Width = 65
      Height = 21
      EditMask = 'aaa\.aaa\.a;1; '
      MaxLength = 9
      ReadOnly = True
      TabOrder = 1
      Text = '   .   . '
      OnChange = EditChange
    end
    inline FrameSubKassa: TFrameSubkonto
      Left = 2
      Top = 37
      Width = 361
      Height = 76
      TabOrder = 2
      inherited LSub1: TLabel
        Left = 96
      end
      inherited LSub2: TLabel
        Left = 96
      end
      inherited LSub3: TLabel
        Left = 96
      end
      inherited LSub4: TLabel
        Left = 96
      end
      inherited LSub5: TLabel
        Left = 96
      end
      inherited LSub6: TLabel
        Left = 96
      end
      inherited LSub7: TLabel
        Left = 96
      end
      inherited LSub8: TLabel
        Left = 96
      end
      inherited LSub9: TLabel
        Left = 96
      end
      inherited LSub10: TLabel
        Left = 96
      end
      inherited ESub1: TEdit
        Left = 101
      end
      inherited BSub1: TButton
        Left = 324
      end
      inherited ESub2: TEdit
        Left = 101
      end
      inherited BSub2: TButton
        Left = 324
      end
      inherited ESub3: TEdit
        Left = 101
      end
      inherited BSub3: TButton
        Left = 324
      end
      inherited ESub4: TEdit
        Left = 101
      end
      inherited BSub4: TButton
        Left = 324
      end
      inherited ESub5: TEdit
        Left = 101
      end
      inherited BSub5: TButton
        Left = 324
      end
      inherited ESub6: TEdit
        Left = 101
      end
      inherited BSub6: TButton
        Left = 324
      end
      inherited ESub7: TEdit
        Left = 101
      end
      inherited BSub7: TButton
        Left = 324
      end
      inherited ESub8: TEdit
        Left = 101
      end
      inherited BSub8: TButton
        Left = 324
      end
      inherited ESub9: TEdit
        Left = 101
      end
      inherited BSub9: TButton
        Left = 324
      end
      inherited ESub10: TEdit
        Left = 101
      end
      inherited BSub10: TButton
        Left = 324
      end
    end
  end
  object PFilter: TPanel [26]
    Left = 8
    Top = 40
    Width = 369
    Height = 129
    Alignment = taRightJustify
    BorderStyle = bsSingle
    TabOrder = 18
    Visible = False
    object Label4: TLabel
      Left = 81
      Top = 38
      Width = 8
      Height = 20
      Alignment = taRightJustify
      Caption = 'c'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 186
      Top = 40
      Width = 20
      Height = 20
      Caption = 'до'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label11: TLabel
      Left = 81
      Top = 6
      Width = 8
      Height = 20
      Alignment = taRightJustify
      Caption = 'c'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label12: TLabel
      Left = 187
      Top = 8
      Width = 20
      Height = 20
      Caption = 'до'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label8: TLabel
      Left = 23
      Top = 68
      Width = 34
      Height = 13
      Alignment = taRightJustify
      Caption = 'Касса:'
    end
    object Label13: TLabel
      Left = 8
      Top = 100
      Width = 53
      Height = 13
      Caption = 'Корр.счет:'
    end
    object DTPBeg: TDateTimePicker
      Left = 96
      Top = 40
      Width = 81
      Height = 21
      CalAlignment = dtaLeft
      Date = 36601.8222225463
      Time = 36601.8222225463
      DateFormat = dfShort
      DateMode = dmComboBox
      Enabled = False
      Kind = dtkDate
      ParseInput = False
      TabOrder = 0
    end
    object CBDateFilter: TCheckBox
      Left = 8
      Top = 42
      Width = 65
      Height = 17
      Caption = 'Дата:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = CBDateFilterClick
    end
    object DTPFin: TDateTimePicker
      Left = 216
      Top = 40
      Width = 81
      Height = 21
      CalAlignment = dtaLeft
      Date = 36601.8222225463
      Time = 36601.8222225463
      DateFormat = dfShort
      DateMode = dmComboBox
      Enabled = False
      Kind = dtkDate
      ParseInput = False
      TabOrder = 2
    end
    object CBNumFilter: TCheckBox
      Left = 8
      Top = 8
      Width = 65
      Height = 17
      Caption = 'Номер:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = CBNumFilterClick
    end
    object ENumBeg: TEdit
      Left = 96
      Top = 8
      Width = 81
      Height = 21
      Enabled = False
      TabOrder = 4
    end
    object ENumFin: TEdit
      Left = 216
      Top = 8
      Width = 81
      Height = 21
      Enabled = False
      TabOrder = 5
    end
    object BKassaFilter: TButton
      Left = 129
      Top = 64
      Width = 16
      Height = 21
      Caption = '...'
      TabOrder = 6
      OnClick = BKassaFilterClick
    end
    object MEKassaFilter: TMaskEdit
      Left = 64
      Top = 64
      Width = 65
      Height = 21
      EditMask = 'aaa\.aaa\.a;1; '
      MaxLength = 9
      TabOrder = 7
      Text = '   .   . '
    end
    object MEKorAcFilter: TMaskEdit
      Left = 64
      Top = 96
      Width = 65
      Height = 21
      EditMask = 'aaa\.aaa\.a;1; '
      MaxLength = 9
      TabOrder = 8
      Text = '   .   . '
      OnChange = EditChange
    end
    object BKorAcFilter: TButton
      Left = 129
      Top = 96
      Width = 16
      Height = 21
      Caption = '...'
      TabOrder = 9
      OnClick = BKorAcFilterClick
    end
  end
  inherited IBTran: TIBTransaction
    Left = 152
    Top = 519
  end
end
