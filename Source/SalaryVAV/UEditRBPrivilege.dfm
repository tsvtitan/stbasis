inherited fmEditRBPrivelege: TfmEditRBPrivelege
  Left = 454
  Top = 244
  Caption = 'fmEditRBPrivelege'
  ClientHeight = 376
  ClientWidth = 355
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBut: TPanel
    Top = 338
    Width = 355
    inherited Panel2: TPanel
      Left = 170
    end
  end
  inherited cbInString: TCheckBox
    Top = 312
  end
  object Panel1: TPanel [2]
    Left = 0
    Top = 0
    Width = 355
    Height = 338
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object ScrollBox1: TScrollBox
      Left = 0
      Top = 0
      Width = 355
      Height = 338
      Align = alClient
      TabOrder = 0
      object Label1: TLabel
        Left = 33
        Top = 53
        Width = 38
        Height = 13
        Caption = 'Январь'
      end
      object Label2: TLabel
        Left = 33
        Top = 73
        Width = 47
        Height = 13
        Caption = 'Февраль'
      end
      object Label3: TLabel
        Left = 33
        Top = 93
        Width = 26
        Height = 13
        Caption = 'Март'
      end
      object Label4: TLabel
        Left = 33
        Top = 113
        Width = 37
        Height = 13
        Caption = 'Апрель'
      end
      object Label5: TLabel
        Left = 33
        Top = 133
        Width = 21
        Height = 13
        Caption = 'Май'
      end
      object Label6: TLabel
        Left = 33
        Top = 213
        Width = 48
        Height = 13
        Caption = 'Сентябрь'
      end
      object Label7: TLabel
        Left = 33
        Top = 233
        Width = 43
        Height = 13
        Caption = 'Октябрь'
      end
      object Label8: TLabel
        Left = 33
        Top = 253
        Width = 38
        Height = 13
        Caption = 'Ноябрь'
      end
      object Label9: TLabel
        Left = 33
        Top = 153
        Width = 28
        Height = 13
        Caption = 'Июнь'
      end
      object Label10: TLabel
        Left = 33
        Top = 193
        Width = 34
        Height = 13
        Caption = 'Август'
      end
      object Label11: TLabel
        Left = 33
        Top = 173
        Width = 28
        Height = 13
        Caption = 'Июль'
      end
      object Label12: TLabel
        Left = 33
        Top = 273
        Width = 45
        Height = 13
        Caption = 'Декабрь'
      end
      object Label13: TLabel
        Left = 104
        Top = 30
        Width = 39
        Height = 13
        Caption = 'на себя'
      end
      object Label14: TLabel
        Left = 176
        Top = 30
        Width = 71
        Height = 13
        Caption = 'на иждевенца'
      end
      object Label15: TLabel
        Left = 288
        Top = 30
        Width = 30
        Height = 13
        Caption = 'Всего'
      end
      object Label16: TLabel
        Left = 48
        Top = 8
        Width = 268
        Height = 20
        Caption = 'Льготы по подоходному налогу'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Bevel1: TBevel
        Left = 24
        Top = 285
        Width = 320
        Height = 10
        Shape = bsBottomLine
      end
      object Bevel2: TBevel
        Left = 256
        Top = 32
        Width = 9
        Height = 289
        Shape = bsLeftLine
      end
      object Label17: TLabel
        Left = 33
        Top = 302
        Width = 30
        Height = 13
        Caption = 'Итого'
      end
      object bReCalc: TButton
        Left = 0
        Top = 8
        Width = 75
        Height = 25
        Caption = 'bReCalc'
        TabOrder = 0
        Visible = False
        OnClick = bReCalcClick
      end
      object CESPJanuary: TCurrencyEdit
        Left = 88
        Top = 49
        Width = 81
        Height = 21
        AutoSize = False
        TabOrder = 1
        OnChange = bReCalcClick
      end
      object CESPFebruary: TCurrencyEdit
        Left = 88
        Top = 69
        Width = 81
        Height = 21
        AutoSize = False
        TabOrder = 2
        OnChange = bReCalcClick
      end
      object CESPMarch: TCurrencyEdit
        Left = 88
        Top = 89
        Width = 81
        Height = 21
        AutoSize = False
        TabOrder = 3
        OnChange = bReCalcClick
      end
      object CESPApril: TCurrencyEdit
        Left = 88
        Top = 109
        Width = 81
        Height = 21
        AutoSize = False
        TabOrder = 4
        OnChange = bReCalcClick
      end
      object CESPMay: TCurrencyEdit
        Left = 88
        Top = 129
        Width = 81
        Height = 21
        AutoSize = False
        TabOrder = 5
        OnChange = bReCalcClick
      end
      object CESPJune: TCurrencyEdit
        Left = 88
        Top = 149
        Width = 81
        Height = 21
        AutoSize = False
        TabOrder = 6
        OnChange = bReCalcClick
      end
      object CESPJuly: TCurrencyEdit
        Left = 88
        Top = 169
        Width = 81
        Height = 21
        AutoSize = False
        TabOrder = 7
        OnChange = bReCalcClick
      end
      object CESPAugust: TCurrencyEdit
        Left = 88
        Top = 189
        Width = 81
        Height = 21
        AutoSize = False
        TabOrder = 8
        OnChange = bReCalcClick
      end
      object CESPSeptember: TCurrencyEdit
        Left = 88
        Top = 209
        Width = 81
        Height = 21
        AutoSize = False
        TabOrder = 9
        OnChange = bReCalcClick
      end
      object CESPOctober: TCurrencyEdit
        Left = 88
        Top = 229
        Width = 81
        Height = 21
        AutoSize = False
        TabOrder = 10
        OnChange = bReCalcClick
      end
      object CESPNovember: TCurrencyEdit
        Left = 88
        Top = 249
        Width = 81
        Height = 21
        AutoSize = False
        TabOrder = 11
        OnChange = bReCalcClick
      end
      object CESPDecember: TCurrencyEdit
        Left = 88
        Top = 269
        Width = 81
        Height = 21
        AutoSize = False
        TabOrder = 12
        OnChange = bReCalcClick
      end
      object CEDPJanuary: TCurrencyEdit
        Left = 172
        Top = 49
        Width = 81
        Height = 21
        AutoSize = False
        TabOrder = 13
        OnChange = bReCalcClick
      end
      object CEDPFebruary: TCurrencyEdit
        Left = 172
        Top = 69
        Width = 81
        Height = 21
        AutoSize = False
        TabOrder = 14
        OnChange = bReCalcClick
      end
      object CEDPMarch: TCurrencyEdit
        Left = 172
        Top = 89
        Width = 81
        Height = 21
        AutoSize = False
        TabOrder = 15
        OnChange = bReCalcClick
      end
      object CEDPApril: TCurrencyEdit
        Left = 172
        Top = 109
        Width = 81
        Height = 21
        AutoSize = False
        TabOrder = 16
        OnChange = bReCalcClick
      end
      object CEDPMay: TCurrencyEdit
        Left = 172
        Top = 129
        Width = 81
        Height = 21
        AutoSize = False
        TabOrder = 17
        OnChange = bReCalcClick
      end
      object CEDPJune: TCurrencyEdit
        Left = 172
        Top = 149
        Width = 81
        Height = 21
        AutoSize = False
        TabOrder = 18
        OnChange = bReCalcClick
      end
      object CEDPJuly: TCurrencyEdit
        Left = 172
        Top = 169
        Width = 81
        Height = 21
        AutoSize = False
        TabOrder = 19
        OnChange = bReCalcClick
      end
      object CEDPAugust: TCurrencyEdit
        Left = 172
        Top = 189
        Width = 81
        Height = 21
        AutoSize = False
        TabOrder = 20
        OnChange = bReCalcClick
      end
      object CEDPSeptember: TCurrencyEdit
        Left = 172
        Top = 209
        Width = 81
        Height = 21
        AutoSize = False
        TabOrder = 21
        OnChange = bReCalcClick
      end
      object CEDPOctober: TCurrencyEdit
        Left = 172
        Top = 229
        Width = 81
        Height = 21
        AutoSize = False
        TabOrder = 22
        OnChange = bReCalcClick
      end
      object CEDPNovember: TCurrencyEdit
        Left = 172
        Top = 249
        Width = 81
        Height = 21
        AutoSize = False
        TabOrder = 23
        OnChange = bReCalcClick
      end
      object CEDPDecember: TCurrencyEdit
        Left = 172
        Top = 269
        Width = 81
        Height = 21
        AutoSize = False
        TabOrder = 24
        OnChange = bReCalcClick
      end
      object CEAllSP: TCurrencyEdit
        Left = 88
        Top = 298
        Width = 81
        Height = 21
        TabStop = False
        AutoSize = False
        ReadOnly = True
        TabOrder = 25
        OnChange = bReCalcClick
      end
      object CEAllDP: TCurrencyEdit
        Left = 172
        Top = 298
        Width = 81
        Height = 21
        TabStop = False
        AutoSize = False
        ReadOnly = True
        TabOrder = 26
        OnChange = bReCalcClick
      end
      object CETotal: TCurrencyEdit
        Left = 262
        Top = 298
        Width = 81
        Height = 21
        TabStop = False
        AutoSize = False
        ReadOnly = True
        TabOrder = 27
      end
      object CEAllJanuary: TCurrencyEdit
        Left = 262
        Top = 49
        Width = 81
        Height = 21
        TabStop = False
        AutoSize = False
        ReadOnly = True
        TabOrder = 28
      end
      object CEAllFebruary: TCurrencyEdit
        Left = 262
        Top = 69
        Width = 81
        Height = 21
        TabStop = False
        AutoSize = False
        ReadOnly = True
        TabOrder = 29
      end
      object CEAllMarch: TCurrencyEdit
        Left = 262
        Top = 89
        Width = 81
        Height = 21
        TabStop = False
        AutoSize = False
        ReadOnly = True
        TabOrder = 30
      end
      object CEAllApril: TCurrencyEdit
        Left = 262
        Top = 109
        Width = 81
        Height = 21
        TabStop = False
        AutoSize = False
        ReadOnly = True
        TabOrder = 31
      end
      object CEAllMay: TCurrencyEdit
        Left = 262
        Top = 129
        Width = 81
        Height = 21
        TabStop = False
        AutoSize = False
        ReadOnly = True
        TabOrder = 32
      end
      object CEAllJune: TCurrencyEdit
        Left = 262
        Top = 149
        Width = 81
        Height = 21
        TabStop = False
        AutoSize = False
        ReadOnly = True
        TabOrder = 33
      end
      object CEAllJuly: TCurrencyEdit
        Left = 262
        Top = 169
        Width = 81
        Height = 21
        TabStop = False
        AutoSize = False
        ReadOnly = True
        TabOrder = 34
      end
      object CEAllAugust: TCurrencyEdit
        Left = 262
        Top = 189
        Width = 81
        Height = 21
        TabStop = False
        AutoSize = False
        ReadOnly = True
        TabOrder = 35
      end
      object CEAllSeptember: TCurrencyEdit
        Left = 262
        Top = 209
        Width = 81
        Height = 21
        TabStop = False
        AutoSize = False
        ReadOnly = True
        TabOrder = 36
      end
      object CEAllOctober: TCurrencyEdit
        Left = 262
        Top = 229
        Width = 81
        Height = 21
        TabStop = False
        AutoSize = False
        ReadOnly = True
        TabOrder = 37
      end
      object CEAllNovember: TCurrencyEdit
        Left = 262
        Top = 249
        Width = 81
        Height = 21
        TabStop = False
        AutoSize = False
        ReadOnly = True
        TabOrder = 38
      end
      object CEAllDecember: TCurrencyEdit
        Left = 262
        Top = 269
        Width = 81
        Height = 21
        TabStop = False
        AutoSize = False
        ReadOnly = True
        TabOrder = 39
      end
    end
  end
  inherited IBTran: TIBTransaction
    Left = 8
    Top = 305
  end
end
