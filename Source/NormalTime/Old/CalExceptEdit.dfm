object frmCalExceptEdit: TfrmCalExceptEdit
  Left = 416
  Top = 249
  BorderStyle = bsDialog
  Caption = 'frmCalExceptEdit'
  ClientHeight = 143
  ClientWidth = 263
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object Label11: TLabel
    Left = 8
    Top = 8
    Width = 84
    Height = 13
    Caption = 'Текущая неделя'
  end
  object Label1: TLabel
    Left = 8
    Top = 32
    Width = 34
    Height = 13
    Caption = 'В день'
  end
  object Label2: TLabel
    Left = 8
    Top = 56
    Width = 73
    Height = 13
    Caption = 'Рабочих часов'
  end
  object Label3: TLabel
    Left = 8
    Top = 82
    Width = 114
    Height = 13
    Caption = 'Описание исключения'
  end
  object EditCurDate: TEdit
    Left = 136
    Top = 8
    Width = 121
    Height = 21
    TabStop = False
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 0
  end
  object DateEdit1: TDateEdit
    Left = 136
    Top = 32
    Width = 121
    Height = 21
    NumGlyphs = 2
    Weekends = [Sun, Sat]
    TabOrder = 1
  end
  object RxSpinEdit1: TRxSpinEdit
    Left = 136
    Top = 56
    Width = 121
    Height = 21
    ButtonKind = bkStandard
    Increment = 0.25
    ValueType = vtFloat
    TabOrder = 2
  end
  object ButtonOK: TButton
    Left = 104
    Top = 112
    Width = 75
    Height = 25
    Caption = 'ОК'
    Default = True
    ModalResult = 1
    TabOrder = 4
  end
  object ButtonCancel: TButton
    Left = 184
    Top = 112
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Отмена'
    ModalResult = 2
    TabOrder = 5
  end
  object EditExceptName: TEdit
    Left = 136
    Top = 80
    Width = 121
    Height = 21
    TabOrder = 3
  end
  object quTemp: TIBQuery
    Transaction = trTemp
    BufferChunks = 1000
    CachedUpdates = False
    Left = 48
    Top = 16
  end
  object trTemp: TIBTransaction
    Active = False
    DefaultAction = TACommitRetaining
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    Left = 112
    Top = 16
  end
end
