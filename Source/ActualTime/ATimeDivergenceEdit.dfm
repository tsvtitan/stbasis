object frmDivergenceEdit: TfrmDivergenceEdit
  Left = 474
  Top = 254
  BorderStyle = bsDialog
  Caption = 'Отклонение'
  ClientHeight = 230
  ClientWidth = 294
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
    Top = 64
    Width = 64
    Height = 13
    Caption = 'Дата начала'
  end
  object Label2: TLabel
    Left = 8
    Top = 88
    Width = 38
    Height = 13
    Caption = 'График'
  end
  object Label3: TLabel
    Left = 8
    Top = 112
    Width = 30
    Height = 13
    Caption = 'Сетка'
  end
  object Label4: TLabel
    Left = 8
    Top = 136
    Width = 37
    Height = 13
    Caption = 'Разряд'
  end
  object Label5: TLabel
    Left = 8
    Top = 160
    Width = 53
    Height = 13
    Caption = 'Категория'
  end
  object Label7: TLabel
    Left = 8
    Top = 8
    Width = 102
    Height = 13
    Caption = 'Текущий календарь'
  end
  object Label8: TLabel
    Left = 8
    Top = 32
    Width = 100
    Height = 13
    Caption = 'Текущий сотрудник'
  end
  object DateEdit1: TDateEdit
    Left = 128
    Top = 64
    Width = 161
    Height = 21
    NumGlyphs = 2
    TabOrder = 2
  end
  object ComboEdit1: TComboEdit
    Left = 128
    Top = 88
    Width = 161
    Height = 21
    Color = clBtnFace
    DirectInput = False
    GlyphKind = gkEllipsis
    ButtonWidth = 16
    NumGlyphs = 1
    TabOrder = 3
    OnButtonClick = ComboEdit1ButtonClick
    OnKeyDown = ComboEditKeyDown
  end
  object ComboEdit2: TComboEdit
    Left = 128
    Top = 112
    Width = 161
    Height = 21
    Color = clBtnFace
    DirectInput = False
    GlyphKind = gkEllipsis
    ButtonWidth = 16
    NumGlyphs = 1
    TabOrder = 4
    OnButtonClick = ComboEdit2ButtonClick
    OnKeyDown = ComboEditKeyDown
  end
  object ComboEdit3: TComboEdit
    Left = 128
    Top = 136
    Width = 161
    Height = 21
    Color = clBtnFace
    DirectInput = False
    GlyphKind = gkEllipsis
    ButtonWidth = 16
    NumGlyphs = 1
    TabOrder = 5
    OnButtonClick = ComboEdit3ButtonClick
    OnKeyDown = ComboEditKeyDown
  end
  object ComboEdit4: TComboEdit
    Left = 128
    Top = 160
    Width = 161
    Height = 21
    Color = clBtnFace
    DirectInput = False
    GlyphKind = gkEllipsis
    ButtonWidth = 16
    NumGlyphs = 1
    TabOrder = 6
    OnButtonClick = ComboEdit4ButtonClick
    OnKeyDown = ComboEditKeyDown
  end
  object Button1: TButton
    Left = 136
    Top = 200
    Width = 75
    Height = 25
    Caption = 'ОК'
    Default = True
    ModalResult = 1
    TabOrder = 7
  end
  object Button2: TButton
    Left = 216
    Top = 200
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Отмена'
    ModalResult = 2
    TabOrder = 8
  end
  object EditCurDate: TEdit
    Left = 128
    Top = 8
    Width = 158
    Height = 21
    TabStop = False
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 0
  end
  object EditCurEmp: TEdit
    Left = 128
    Top = 32
    Width = 158
    Height = 21
    TabStop = False
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 1
  end
  object quTemp: TIBQuery
    Transaction = trTemp
    BufferChunks = 1000
    CachedUpdates = False
    Left = 80
    Top = 120
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
    Top = 120
  end
end
