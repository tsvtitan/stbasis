object frmCalHolidayEdit: TfrmCalHolidayEdit
  Left = 370
  Top = 333
  BorderStyle = bsDialog
  Caption = 'frmCalHolidayEdit'
  ClientHeight = 127
  ClientWidth = 280
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
    Top = 56
    Width = 107
    Height = 13
    Caption = 'Описание праздника'
  end
  object Label11: TLabel
    Left = 8
    Top = 8
    Width = 102
    Height = 13
    Caption = 'Текущий календарь'
  end
  object Label2: TLabel
    Left = 8
    Top = 32
    Width = 83
    Height = 13
    Caption = 'Дата праздника'
  end
  object EditHolidayName: TEdit
    Left = 152
    Top = 56
    Width = 121
    Height = 21
    TabOrder = 2
  end
  object EditCurDate: TEdit
    Left = 152
    Top = 8
    Width = 121
    Height = 21
    TabStop = False
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 0
  end
  object EditHolidayDate: TDateEdit
    Left = 152
    Top = 32
    Width = 121
    Height = 21
    NumGlyphs = 2
    Weekends = [Sun, Sat]
    TabOrder = 1
  end
  object Button1: TButton
    Left = 120
    Top = 96
    Width = 75
    Height = 25
    Caption = 'ОК'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object Button2: TButton
    Left = 200
    Top = 96
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Отмена'
    ModalResult = 2
    TabOrder = 4
  end
  object quTemp: TIBQuery
    Transaction = trTemp
    BufferChunks = 1000
    CachedUpdates = False
    Left = 64
    Top = 8
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
    Top = 8
  end
end
