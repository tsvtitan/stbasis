inherited fmRbkDocumFilter: TfmRbkDocumFilter
  Caption = 'fmRbkDocumFilter'
  ClientHeight = 201
  ClientWidth = 326
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnBtn: TPanel
    Top = 161
    Width = 326
    inherited Panel1: TPanel
      Left = 149
    end
    inherited btClear: TBitBtn
      Visible = True
    end
  end
  inherited PnEdit: TPanel
    Width = 326
    Height = 161
    object LbNum: TLabel [0]
      Left = 8
      Top = 12
      Width = 37
      Height = 13
      Caption = 'Номер:'
    end
    object LbTypeDoc: TLabel [1]
      Left = 8
      Top = 41
      Width = 22
      Height = 13
      Caption = 'Тип:'
    end
    inherited PnFilter: TPanel
      Top = 142
      Width = 326
    end
    object Panel2: TPanel
      Left = 0
      Top = 123
      Width = 326
      Height = 19
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      Visible = False
    end
    object EdNum: TEdit
      Left = 50
      Top = 8
      Width = 89
      Height = 21
      TabOrder = 2
    end
    object EdTypeDoc: TEdit
      Left = 50
      Top = 37
      Width = 234
      Height = 21
      Color = clMenu
      ReadOnly = True
      TabOrder = 3
      OnKeyDown = EdTypeDocKeyDown
    end
    object BtCallTypeDoc: TButton
      Left = 285
      Top = 37
      Width = 21
      Height = 21
      Caption = '...'
      TabOrder = 4
      OnClick = BtCallTypeDocClick
    end
    object grbBirthDate: TGroupBox
      Left = 11
      Top = 71
      Width = 295
      Height = 58
      TabOrder = 5
      object lbBirthDateFrom: TLabel
        Left = 13
        Top = 31
        Width = 9
        Height = 13
        Caption = 'с:'
      end
      object lbBirthDateTo: TLabel
        Left = 140
        Top = 31
        Width = 15
        Height = 13
        Caption = 'по:'
      end
      object DPFirst: TDateTimePicker
        Left = 39
        Top = 26
        Width = 94
        Height = 22
        CalAlignment = dtaLeft
        Date = 37147
        Time = 37147
        ShowCheckbox = True
        Checked = False
        Color = clMenu
        DateFormat = dfShort
        DateMode = dmComboBox
        Enabled = False
        Kind = dtkDate
        ParseInput = False
        TabOrder = 0
      end
      object DPNext: TDateTimePicker
        Left = 162
        Top = 26
        Width = 94
        Height = 22
        CalAlignment = dtaLeft
        Date = 37147
        Time = 37147
        ShowCheckbox = True
        Checked = False
        Color = clMenu
        DateFormat = dfShort
        DateMode = dmComboBox
        Enabled = False
        Kind = dtkDate
        ParseInput = False
        TabOrder = 1
      end
      object btCallPeriod: TBitBtn
        Left = 258
        Top = 27
        Width = 21
        Height = 21
        Hint = 'Выбрать'
        Caption = '...'
        Enabled = False
        TabOrder = 2
        OnClick = btCallPeriodClick
      end
      object CB: TCheckBox
        Left = 16
        Top = -1
        Width = 114
        Height = 17
        Caption = 'Выбор по периоду'
        TabOrder = 3
        OnClick = CBClick
      end
    end
  end
  inherited IBQ: TIBQuery
    Left = 296
  end
  inherited Trans: TIBTransaction
    Left = 232
    Top = 65533
  end
end
