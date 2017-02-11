object fmSalPeriod: TfmSalPeriod
  Left = 374
  Top = 206
  Width = 393
  Height = 280
  BorderIcons = [biSystemMenu]
  Caption = 'Управление периодами'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = True
  Position = poDesktopCenter
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 12
    Top = 17
    Width = 144
    Height = 20
    Caption = 'Текущий период:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 4
    Top = 48
    Width = 377
    Height = 24
    Alignment = taCenter
    AutoSize = False
    Caption = 'состояние периода:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lbStatusCurCalcPeriod: TLabel
    Left = 4
    Top = 72
    Width = 377
    Height = 24
    Alignment = taCenter
    AutoSize = False
    Caption = 'состояние периода'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object bibClosePeriod: TButton
    Left = 4
    Top = 170
    Width = 377
    Height = 33
    Caption = 'Закрыть и перейти к следующему периоду'
    TabOrder = 0
    OnClick = bibClosePeriodClick
  end
  object CheckBox1: TCheckBox
    Left = 18
    Top = 104
    Width = 297
    Height = 17
    Caption = 'Переносить остатки с предыдущего месяца'
    Checked = True
    State = cbChecked
    TabOrder = 1
  end
  object edCalcPeriod: TEdit
    Left = 159
    Top = 17
    Width = 190
    Height = 24
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 100
    ParentFont = False
    ReadOnly = True
    TabOrder = 2
  end
  object bibCurCalcPeriod: TBitBtn
    Left = 309
    Top = 103
    Width = 72
    Height = 21
    Hint = 'Выбрать'
    Caption = 'Текущий'
    TabOrder = 3
    Visible = False
    OnClick = bibCurCalcPeriodClick
  end
  object bOpenPeriod: TButton
    Left = 4
    Top = 130
    Width = 377
    Height = 33
    Caption = 'Открыть период'
    TabOrder = 4
    OnClick = bOpenPeriodClick
  end
  object bReversePeriod: TButton
    Left = 4
    Top = 209
    Width = 377
    Height = 33
    Caption = 'Откатить данные'
    TabOrder = 5
    OnClick = bReversePeriodClick
  end
  object Mainqr: TIBQuery
    Transaction = IBTran
    BufferChunks = 1000
    CachedUpdates = False
    Left = 28
    Top = 64
  end
  object IBTran: TIBTransaction
    Active = False
    AutoStopAction = saNone
    Left = 76
    Top = 64
  end
end
