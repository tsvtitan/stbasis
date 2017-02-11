inherited fmEditJRMagazinePostings: TfmEditJRMagazinePostings
  Left = 445
  Top = 46
  Caption = 'fmEditJRMagazinePostings'
  ClientHeight = 605
  ClientWidth = 386
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBut: TPanel
    Top = 543
    Width = 386
    Height = 62
    TabOrder = 5
    inherited Panel2: TPanel
      Left = 201
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
    TabOrder = 4
  end
  object PView: TPanel [2]
    Left = 0
    Top = 33
    Width = 386
    Height = 192
    Align = alTop
    BorderStyle = bsSingle
    TabOrder = 1
    object Label10: TLabel
      Left = 216
      Top = 9
      Width = 26
      Height = 13
      Caption = 'Дата'
    end
    object Label11: TLabel
      Left = 305
      Top = 9
      Width = 33
      Height = 13
      Caption = 'Время'
    end
    object Label3: TLabel
      Left = 8
      Top = 5
      Width = 68
      Height = 13
      Caption = '№ документа'
    end
    object Label4: TLabel
      Left = 104
      Top = 5
      Width = 62
      Height = 13
      Caption = '№ проводки'
    end
    object Label6: TLabel
      Left = 194
      Top = 26
      Width = 14
      Height = 13
      Caption = 'от:'
    end
    object DTPDate: TDateTimePicker
      Left = 216
      Top = 24
      Width = 81
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
      TabOrder = 2
      OnChange = EditChange
    end
    object GBDebit: TGroupBox
      Left = 8
      Top = 56
      Width = 371
      Height = 65
      Caption = 'Дебет, аналитика'
      TabOrder = 4
      inline FrameSubDT: TFrameSubkonto
        Left = 2
        Top = 33
        Width = 359
        Height = 26
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
          OnChange = EditChange
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
      object MEDebit: TMaskEdit
        Left = 102
        Top = 13
        Width = 65
        Height = 21
        Color = clMenu
        EditMask = 'aaa\.aaa\.a;1; '
        MaxLength = 9
        ReadOnly = True
        TabOrder = 0
        Text = '   .   . '
        OnChange = EditChange
      end
      object BDebit: TButton
        Left = 167
        Top = 13
        Width = 16
        Height = 21
        Caption = '...'
        TabOrder = 1
        OnClick = BDebitClick
      end
    end
    object GBCredit: TGroupBox
      Left = 8
      Top = 121
      Width = 371
      Height = 65
      Caption = 'Кредит, аналитика'
      TabOrder = 5
      inline FrameSubKT: TFrameSubkonto
        Left = 2
        Top = 34
        Width = 359
        Height = 27
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
          OnChange = EditChange
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
      object MECredit: TMaskEdit
        Left = 103
        Top = 14
        Width = 65
        Height = 21
        Color = clMenu
        EditMask = 'aaa\.aaa\.a;1; '
        MaxLength = 9
        ReadOnly = True
        TabOrder = 0
        Text = '   .   . '
        OnChange = EditChange
      end
      object BCredit: TButton
        Left = 168
        Top = 14
        Width = 16
        Height = 21
        Caption = '...'
        TabOrder = 1
        OnClick = BCreditClick
      end
    end
    object ENum: TEdit
      Left = 8
      Top = 24
      Width = 73
      Height = 21
      TabOrder = 0
      OnChange = EditChange
      OnKeyPress = ENumKeyPress
    end
    object ENumPosting: TEdit
      Left = 104
      Top = 24
      Width = 73
      Height = 21
      TabOrder = 1
      OnChange = EditChange
      OnKeyPress = ENumKeyPress
    end
    object DTPTime: TDateTimePicker
      Left = 305
      Top = 24
      Width = 72
      Height = 21
      CalAlignment = dtaLeft
      Date = 37576.7500633565
      Time = 37576.7500633565
      DateFormat = dfShort
      DateMode = dmComboBox
      Kind = dtkTime
      ParseInput = False
      TabOrder = 3
      OnChange = EditChange
    end
  end
  object PDoc: TPanel [3]
    Left = 0
    Top = 0
    Width = 386
    Height = 33
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvNone
    BorderStyle = bsSingle
    TabOrder = 0
    object Label1: TLabel
      Left = 7
      Top = 7
      Width = 54
      Height = 13
      Caption = 'Документ:'
    end
    object EDoc: TEdit
      Left = 65
      Top = 4
      Width = 296
      Height = 21
      Color = clMenu
      ReadOnly = True
      TabOrder = 0
      OnChange = EditChange
    end
    object BDoc: TButton
      Left = 362
      Top = 4
      Width = 17
      Height = 21
      Caption = '...'
      TabOrder = 1
      OnClick = BDocClick
    end
  end
  object POper: TPanel [4]
    Left = 0
    Top = 354
    Width = 386
    Height = 215
    Align = alTop
    BorderStyle = bsSingle
    TabOrder = 3
    object Label2: TLabel
      Left = 8
      Top = 112
      Width = 63
      Height = 13
      Caption = 'Примечание'
    end
    object LKolvo: TLabel
      Left = 112
      Top = 70
      Width = 59
      Height = 13
      Caption = 'Количество'
      Enabled = False
    end
    object Label8: TLabel
      Left = 8
      Top = 70
      Width = 34
      Height = 13
      Caption = 'Сумма'
    end
    object EKolvo: TEdit
      Left = 112
      Top = 86
      Width = 89
      Height = 21
      Enabled = False
      TabOrder = 2
      OnChange = EditChange
      OnKeyPress = ENumKeyPress
    end
    object ESumma: TEdit
      Left = 8
      Top = 86
      Width = 89
      Height = 21
      TabOrder = 1
      OnChange = EditChange
      OnKeyPress = ESummaKeyPress
    end
    object GBCurrency: TGroupBox
      Left = 8
      Top = 8
      Width = 217
      Height = 57
      Caption = 'Валюта,курс'
      Enabled = False
      TabOrder = 0
      object Label5: TLabel
        Left = 120
        Top = 14
        Width = 24
        Height = 13
        Caption = 'Курс'
      end
      object LCurrency: TLabel
        Left = 24
        Top = 14
        Width = 38
        Height = 13
        Caption = 'Валюта'
      end
      object BCursCur: TButton
        Left = 185
        Top = 28
        Width = 17
        Height = 21
        Caption = '...'
        TabOrder = 3
        OnClick = BCursCurClick
      end
      object ECursCur: TEdit
        Left = 120
        Top = 28
        Width = 65
        Height = 21
        ParentColor = True
        ReadOnly = True
        TabOrder = 2
        OnChange = EditChange
      end
      object BCur: TButton
        Left = 89
        Top = 28
        Width = 17
        Height = 21
        Caption = '...'
        TabOrder = 1
        OnClick = BCurClick
      end
      object ECur: TEdit
        Left = 24
        Top = 28
        Width = 65
        Height = 21
        ParentColor = True
        ReadOnly = True
        TabOrder = 0
        OnChange = EditChange
      end
    end
    object mText: TMemo
      Left = 8
      Top = 136
      Width = 369
      Height = 65
      MaxLength = 255
      TabOrder = 3
      OnChange = EditChange
    end
  end
  object PFilter: TPanel [5]
    Left = 0
    Top = 225
    Width = 386
    Height = 129
    Align = alTop
    Alignment = taRightJustify
    BorderStyle = bsSingle
    TabOrder = 2
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
      TabOrder = 4
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
      TabOrder = 3
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
      TabOrder = 5
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
      TabOrder = 0
      OnClick = CBNumFilterClick
    end
    object ENumBeg: TEdit
      Left = 112
      Top = 8
      Width = 81
      Height = 21
      Enabled = False
      TabOrder = 1
      OnKeyPress = ENumKeyPress
    end
    object ENumFin: TEdit
      Left = 232
      Top = 8
      Width = 81
      Height = 21
      Enabled = False
      TabOrder = 2
      OnKeyPress = ENumKeyPress
    end
    object BDebitFilter: TButton
      Left = 145
      Top = 64
      Width = 17
      Height = 21
      Caption = '...'
      TabOrder = 7
      OnClick = BDebitFilterClick
    end
    object MEDebitFilter: TMaskEdit
      Left = 80
      Top = 64
      Width = 65
      Height = 21
      Color = clMenu
      EditMask = 'aaa\.aaa\.a;1; '
      MaxLength = 9
      TabOrder = 6
      Text = '   .   . '
    end
    object MECreditFilter: TMaskEdit
      Left = 80
      Top = 96
      Width = 65
      Height = 21
      Color = clMenu
      EditMask = 'aaa\.aaa\.a;1; '
      MaxLength = 9
      TabOrder = 8
      Text = '   .   . '
    end
    object BCreditFilter: TButton
      Left = 145
      Top = 96
      Width = 16
      Height = 21
      Caption = '...'
      TabOrder = 9
      OnClick = BCreditFilterClick
    end
  end
  inherited IBTran: TIBTransaction
    Top = 559
  end
end
