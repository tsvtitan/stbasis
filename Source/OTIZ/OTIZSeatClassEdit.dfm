object frmSeatClassEdit: TfrmSeatClassEdit
  Left = 392
  Top = 279
  BorderStyle = bsDialog
  Caption = 'Штатное расписание'
  ClientHeight = 310
  ClientWidth = 295
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 50
    Width = 58
    Height = 13
    Caption = 'Должность'
  end
  object Label2: TLabel
    Left = 8
    Top = 74
    Width = 37
    Height = 13
    Caption = 'Разряд'
  end
  object Label3: TLabel
    Left = 8
    Top = 98
    Width = 51
    Height = 13
    Caption = 'Документ'
  end
  object Label71: TLabel
    Left = 8
    Top = 10
    Width = 77
    Height = 13
    Caption = 'Текущий отдел'
  end
  object Label4: TLabel
    Left = 8
    Top = 122
    Width = 106
    Height = 13
    Caption = 'Минимальный оклад'
  end
  object Label5: TLabel
    Left = 8
    Top = 146
    Width = 112
    Height = 13
    Caption = 'Максимальный оклад'
  end
  object Label6: TLabel
    Left = 8
    Top = 170
    Width = 119
    Height = 13
    Caption = 'Кол-во штатных едениц'
  end
  object Label7: TLabel
    Left = 8
    Top = 194
    Width = 44
    Height = 13
    Caption = 'Доплата'
  end
  object Label8: TLabel
    Left = 8
    Top = 218
    Width = 91
    Height = 13
    Caption = 'Коефф. северный'
  end
  object Label9: TLabel
    Left = 8
    Top = 242
    Width = 91
    Height = 13
    Caption = 'Коефф. районный'
  end
  object ComboEdit1: TComboEdit
    Left = 128
    Top = 48
    Width = 161
    Height = 21
    Color = clBtnFace
    DirectInput = False
    GlyphKind = gkEllipsis
    ButtonWidth = 16
    NumGlyphs = 1
    TabOrder = 1
    OnButtonClick = ComboEdit1ButtonClick
  end
  object ComboEdit2: TComboEdit
    Left = 128
    Top = 72
    Width = 161
    Height = 21
    Color = clBtnFace
    DirectInput = False
    GlyphKind = gkEllipsis
    ButtonWidth = 16
    NumGlyphs = 1
    TabOrder = 2
    OnButtonClick = ComboEdit2ButtonClick
  end
  object ComboEdit3: TComboEdit
    Left = 128
    Top = 96
    Width = 161
    Height = 21
    Color = clBtnFace
    DirectInput = False
    GlyphKind = gkEllipsis
    ButtonWidth = 16
    NumGlyphs = 1
    TabOrder = 3
    OnButtonClick = ComboEdit3ButtonClick
  end
  object Button1: TButton
    Left = 136
    Top = 280
    Width = 75
    Height = 25
    Caption = 'ОК'
    Default = True
    ModalResult = 1
    TabOrder = 10
  end
  object Button2: TButton
    Left = 216
    Top = 280
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Отмена'
    ModalResult = 2
    TabOrder = 11
  end
  object EditCurDepart: TEdit
    Left = 128
    Top = 8
    Width = 158
    Height = 21
    TabStop = False
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 0
  end
  object CurrencyEdit1: TCurrencyEdit
    Left = 128
    Top = 120
    Width = 161
    Height = 21
    AutoSize = False
    TabOrder = 4
  end
  object CurrencyEdit2: TCurrencyEdit
    Left = 128
    Top = 144
    Width = 161
    Height = 21
    AutoSize = False
    TabOrder = 5
  end
  object RxSpinEdit1: TRxSpinEdit
    Left = 168
    Top = 168
    Width = 121
    Height = 21
    ButtonKind = bkStandard
    MaxValue = 65535
    MinValue = 1
    TabOrder = 6
  end
  object CurrencyEdit3: TCurrencyEdit
    Left = 128
    Top = 192
    Width = 161
    Height = 21
    AutoSize = False
    TabOrder = 7
  end
  object RxSpinEdit2: TRxSpinEdit
    Left = 168
    Top = 216
    Width = 121
    Height = 21
    ButtonKind = bkStandard
    ValueType = vtFloat
    TabOrder = 8
  end
  object RxSpinEdit3: TRxSpinEdit
    Left = 168
    Top = 240
    Width = 121
    Height = 21
    ButtonKind = bkStandard
    ValueType = vtFloat
    TabOrder = 9
  end
  object quTemp: TIBQuery
    Transaction = trTemp
    BufferChunks = 1000
    CachedUpdates = False
    Left = 72
    Top = 72
  end
  object trTemp: TIBTransaction
    Active = False
    DefaultAction = TARollback
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    AutoStopAction = saNone
    Left = 136
    Top = 72
  end
end
