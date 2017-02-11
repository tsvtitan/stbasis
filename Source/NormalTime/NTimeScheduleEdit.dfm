object frmScheduleEdit: TfrmScheduleEdit
  Left = 381
  Top = 260
  BorderStyle = bsDialog
  Caption = 'frmScheduleEdit'
  ClientHeight = 128
  ClientWidth = 303
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
    Top = 34
    Width = 76
    Height = 13
    Caption = 'Наименование'
  end
  object Label11: TLabel
    Left = 8
    Top = 10
    Width = 102
    Height = 13
    Caption = 'Текущий календарь'
  end
  object Label2: TLabel
    Left = 8
    Top = 58
    Width = 158
    Height = 13
    Caption = 'Среднемесячное число по году'
  end
  object EditName: TEdit
    Left = 176
    Top = 32
    Width = 121
    Height = 21
    TabOrder = 1
  end
  object EditCurDate: TEdit
    Left = 176
    Top = 8
    Width = 121
    Height = 21
    TabStop = False
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 0
  end
  object Button1: TButton
    Left = 144
    Top = 96
    Width = 75
    Height = 25
    Caption = 'ОК'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object Button2: TButton
    Left = 224
    Top = 96
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Отмена'
    ModalResult = 2
    TabOrder = 4
  end
  object EditAvgYear: TRxSpinEdit
    Left = 176
    Top = 56
    Width = 121
    Height = 21
    ButtonKind = bkStandard
    MaxValue = 65535
    MinValue = 0.01
    ValueType = vtFloat
    Value = 0.01
    TabOrder = 2
  end
  object quTemp: TIBQuery
    Transaction = trTemp
    BufferChunks = 1000
    CachedUpdates = False
    Left = 72
    Top = 32
  end
  object trTemp: TIBTransaction
    Active = False
    DefaultAction = TARollback
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    AutoStopAction = saNone
    Left = 128
    Top = 32
  end
end
