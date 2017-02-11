inherited FCOFilter: TFCOFilter
  Left = 229
  Top = 103
  Caption = 'Фильтр'
  ClientHeight = 388
  ClientWidth = 526
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel [0]
    Left = 8
    Top = 48
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
  object LCur: TLabel [1]
    Left = 344
    Top = 112
    Width = 41
    Height = 13
    Caption = 'Валюта:'
  end
  object LEmp: TLabel [2]
    Left = 17
    Top = 155
    Width = 60
    Height = 13
    Alignment = taRightJustify
    Caption = 'Принято от:'
  end
  object Label5: TLabel [3]
    Left = 11
    Top = 179
    Width = 65
    Height = 13
    Caption = 'Основаание:'
  end
  object Label6: TLabel [4]
    Left = 9
    Top = 202
    Width = 67
    Height = 13
    Caption = 'Приложение:'
  end
  object LSumDebit: TLabel [5]
    Left = 37
    Top = 227
    Width = 37
    Height = 13
    Caption = 'Сумма:'
  end
  object LNDS: TLabel [6]
    Left = 11
    Top = 258
    Width = 66
    Height = 13
    Caption = 'Ставка НДС:'
  end
  object Label1: TLabel [7]
    Left = 136
    Top = 48
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
  object Label4: TLabel [8]
    Left = 232
    Top = 16
    Width = 15
    Height = 20
    Caption = '№'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label7: TLabel [9]
    Left = 13
    Top = 283
    Width = 40
    Height = 13
    Alignment = taRightJustify
    Caption = 'Кассир:'
  end
  inherited BOk: TButton
    Left = 360
    Top = 360
  end
  inherited BCancel: TButton
    Left = 448
    Top = 360
  end
  object CBTOrder: TComboBox
    Left = 8
    Top = 16
    Width = 217
    Height = 21
    ItemHeight = 13
    TabOrder = 2
    OnChange = CBTOrderChange
  end
  object ENum: TEdit
    Left = 256
    Top = 16
    Width = 121
    Height = 21
    TabOrder = 3
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 80
    Width = 217
    Height = 65
    Caption = 'Корреспондирующий счет'
    TabOrder = 4
    object Label3: TLabel
      Left = 48
      Top = 28
      Width = 53
      Height = 13
      Caption = 'Корр.счет:'
    end
    object MEKorAc: TMaskEdit
      Left = 104
      Top = 24
      Width = 65
      Height = 21
      EditMask = 'aaa\.aaa\.a;1; '
      MaxLength = 9
      TabOrder = 0
      Text = '   .   . '
    end
  end
  object GBKassa: TGroupBox
    Left = 232
    Top = 80
    Width = 97
    Height = 65
    Caption = 'Касса ...'
    TabOrder = 5
    object MEKassa: TMaskEdit
      Left = 16
      Top = 24
      Width = 65
      Height = 21
      EditMask = 'aaa\.aaa\.a;1; '
      MaxLength = 9
      TabOrder = 0
      Text = '   .   . '
    end
  end
  object ECur: TEdit
    Left = 387
    Top = 109
    Width = 65
    Height = 21
    ParentColor = True
    ReadOnly = True
    TabOrder = 6
  end
  object BCur: TButton
    Left = 452
    Top = 109
    Width = 17
    Height = 21
    Caption = '...'
    Default = True
    TabOrder = 7
    OnClick = BCurClick
  end
  object EEmp: TEdit
    Left = 80
    Top = 152
    Width = 433
    Height = 21
    ParentColor = True
    TabOrder = 8
  end
  object EBasis: TEdit
    Left = 80
    Top = 176
    Width = 433
    Height = 21
    ParentColor = True
    TabOrder = 9
  end
  object EAppend: TEdit
    Left = 80
    Top = 200
    Width = 433
    Height = 21
    ParentColor = True
    TabOrder = 10
  end
  object ESum: TEdit
    Left = 80
    Top = 224
    Width = 121
    Height = 21
    TabOrder = 11
  end
  object ENDS: TEdit
    Left = 80
    Top = 254
    Width = 49
    Height = 21
    ParentColor = True
    ReadOnly = True
    TabOrder = 12
  end
  object BNDS: TButton
    Left = 129
    Top = 254
    Width = 17
    Height = 21
    Caption = '...'
    Default = True
    TabOrder = 13
    OnClick = BNDSClick
  end
  object DateTime1: TDateTimePicker
    Left = 32
    Top = 48
    Width = 89
    Height = 21
    CalAlignment = dtaLeft
    Date = 0.690806261576654
    Time = 0.690806261576654
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 14
  end
  object DateTime2: TDateTimePicker
    Left = 176
    Top = 48
    Width = 89
    Height = 21
    CalAlignment = dtaLeft
    Date = 37339.6908710532
    Time = 37339.6908710532
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 15
  end
  object BClear: TButton
    Left = 8
    Top = 360
    Width = 75
    Height = 25
    Caption = 'Очистить'
    TabOrder = 16
    OnClick = BClearClick
  end
  object CheckBox: TCheckBox
    Left = 8
    Top = 330
    Width = 193
    Height = 17
    Caption = 'Фильтр по вхождению строки'
    TabOrder = 17
  end
  object ECashier: TEdit
    Left = 56
    Top = 280
    Width = 433
    Height = 21
    ParentColor = True
    ReadOnly = True
    TabOrder = 18
  end
  object BCashier: TButton
    Left = 484
    Top = 280
    Width = 17
    Height = 21
    Caption = '...'
    Default = True
    TabOrder = 19
    OnClick = BCashierClick
  end
end
