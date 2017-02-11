inherited fmEditRBMagazinePostings: TfmEditRBMagazinePostings
  Left = 361
  Top = 67
  Caption = 'fmEditRBMagazinePostings'
  ClientHeight = 623
  ClientWidth = 413
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBut: TPanel
    Top = 561
    Width = 413
    Height = 62
    inherited Panel2: TPanel
      Left = 228
      Height = 62
      inherited bibOk: TBitBtn
        Top = 29
      end
      inherited bibCancel: TBitBtn
        Top = 29
      end
    end
    inherited bibClear: TBitBtn
      Top = 29
    end
    object cbInStringCopy: TCheckBox
      Left = 6
      Top = 0
      Width = 186
      Height = 17
      Caption = 'Фильтр по вхождению строки'
      TabOrder = 2
      Visible = False
    end
  end
  inherited cbInString: TCheckBox
    Left = 22
    Top = 8
  end
  object PView: TPanel [2]
    Left = 0
    Top = 49
    Width = 413
    Height = 344
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object Label10: TLabel
      Left = 24
      Top = 53
      Width = 26
      Height = 13
      Caption = 'Дата'
    end
    object Label11: TLabel
      Left = 184
      Top = 53
      Width = 33
      Height = 13
      Caption = 'Время'
    end
    object Label3: TLabel
      Left = 24
      Top = 5
      Width = 68
      Height = 13
      Caption = '№ документа'
    end
    object Label4: TLabel
      Left = 184
      Top = 5
      Width = 62
      Height = 13
      Caption = '№ проводки'
    end
    object DTPDate: TDateTimePicker
      Left = 24
      Top = 68
      Width = 105
      Height = 21
      CalAlignment = dtaLeft
      Date = 37491.3682498843
      Time = 37491.3682498843
      DateFormat = dfShort
      DateMode = dmComboBox
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Kind = dtkDate
      ParseInput = False
      ParentFont = False
      TabOrder = 0
    end
    object ETime: TEdit
      Left = 184
      Top = 72
      Width = 105
      Height = 21
      TabOrder = 1
    end
    object GBDebit: TGroupBox
      Left = 24
      Top = 96
      Width = 365
      Height = 121
      Caption = 'Дебит, аналитика'
      TabOrder = 2
      object EDebit: TEdit
        Left = 104
        Top = 16
        Width = 73
        Height = 21
        TabOrder = 0
      end
      inline FrameSubDT: TFrameSubkonto
        Left = 2
        Top = 37
        Width = 361
        Height = 76
        TabOrder = 1
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
    object GBCredit: TGroupBox
      Left = 24
      Top = 216
      Width = 365
      Height = 121
      Caption = 'Кредит, аналитика'
      TabOrder = 3
      object ECredit: TEdit
        Left = 104
        Top = 16
        Width = 73
        Height = 21
        TabOrder = 0
      end
      inline FrameSubKT: TFrameSubkonto
        Left = 2
        Top = 37
        Width = 361
        Height = 76
        TabOrder = 1
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
    object ENum: TEdit
      Left = 24
      Top = 24
      Width = 105
      Height = 21
      TabOrder = 4
    end
    object ENumPosting: TEdit
      Left = 184
      Top = 24
      Width = 105
      Height = 21
      TabOrder = 5
    end
  end
  object PDoc: TPanel [3]
    Left = 0
    Top = 0
    Width = 413
    Height = 49
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    object Label1: TLabel
      Left = 24
      Top = 8
      Width = 51
      Height = 13
      Caption = 'Документ'
    end
    object EDoc: TEdit
      Left = 24
      Top = 24
      Width = 321
      Height = 21
      TabOrder = 0
    end
  end
  object POper: TPanel [4]
    Left = 0
    Top = 522
    Width = 413
    Height = 160
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 4
    object Label2: TLabel
      Left = 24
      Top = 0
      Width = 50
      Height = 13
      Caption = 'Операция'
    end
    object Label5: TLabel
      Left = 24
      Top = 40
      Width = 50
      Height = 13
      Caption = 'Проводка'
    end
    object LCurrency: TLabel
      Left = 24
      Top = 80
      Width = 38
      Height = 13
      Caption = 'Валюта'
    end
    object LKolvo: TLabel
      Left = 24
      Top = 120
      Width = 59
      Height = 13
      Caption = 'Количество'
    end
    object Label8: TLabel
      Left = 184
      Top = 120
      Width = 34
      Height = 13
      Caption = 'Сумма'
    end
    object EOper: TEdit
      Left = 24
      Top = 16
      Width = 321
      Height = 21
      TabOrder = 0
    end
    object EPosting: TEdit
      Left = 24
      Top = 56
      Width = 321
      Height = 21
      TabOrder = 1
    end
    object ECurrency: TEdit
      Left = 24
      Top = 96
      Width = 89
      Height = 21
      TabOrder = 2
    end
    object EKolvo: TEdit
      Left = 24
      Top = 136
      Width = 89
      Height = 21
      TabOrder = 3
    end
    object ESumma: TEdit
      Left = 184
      Top = 136
      Width = 89
      Height = 21
      TabOrder = 4
    end
  end
  object PFilter: TPanel [5]
    Left = 0
    Top = 393
    Width = 413
    Height = 129
    Align = alTop
    Alignment = taRightJustify
    BevelOuter = bvNone
    TabOrder = 5
    Visible = False
    object Label9: TLabel
      Left = 97
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
    object Label12: TLabel
      Left = 202
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
    object Label13: TLabel
      Left = 97
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
    object Label14: TLabel
      Left = 203
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
    object Label15: TLabel
      Left = 38
      Top = 68
      Width = 35
      Height = 13
      Alignment = taRightJustify
      Caption = 'Дебит:'
    end
    object Label16: TLabel
      Left = 32
      Top = 100
      Width = 39
      Height = 13
      Caption = 'Кредит:'
    end
    object DTPBeg: TDateTimePicker
      Left = 112
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
      Left = 24
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
      Left = 232
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
      Left = 24
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
      Left = 112
      Top = 8
      Width = 81
      Height = 21
      Enabled = False
      TabOrder = 4
    end
    object ENumFin: TEdit
      Left = 232
      Top = 8
      Width = 81
      Height = 21
      Enabled = False
      TabOrder = 5
    end
    object BKassaFilter: TButton
      Left = 145
      Top = 64
      Width = 17
      Height = 21
      Caption = '...'
      Default = True
      TabOrder = 6
      OnClick = BKassaFilterClick
    end
    object MEDebitFilter: TMaskEdit
      Left = 80
      Top = 64
      Width = 65
      Height = 21
      EditMask = 'aaa\.aaa\.a;1; '
      MaxLength = 9
      TabOrder = 7
      Text = '   .   . '
    end
    object MECreditFilter: TMaskEdit
      Left = 80
      Top = 96
      Width = 65
      Height = 21
      EditMask = 'aaa\.aaa\.a;1; '
      MaxLength = 9
      TabOrder = 8
      Text = '   .   . '
    end
    object BKorAcFilter: TButton
      Left = 145
      Top = 96
      Width = 16
      Height = 21
      Caption = '...'
      Default = True
      TabOrder = 9
      OnClick = BKorAcFilterClick
    end
  end
  inherited IBTran: TIBTransaction
    Left = 128
    Top = 615
  end
end
