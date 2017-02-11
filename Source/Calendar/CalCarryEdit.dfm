object frmCalCarryEdit: TfrmCalCarryEdit
  Left = 355
  Top = 201
  BorderStyle = bsDialog
  Caption = 'frmCalCarryEdit'
  ClientHeight = 175
  ClientWidth = 247
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
  object Label3: TLabel
    Left = 8
    Top = 112
    Width = 50
    Height = 13
    Caption = 'Описание'
  end
  object Label11: TLabel
    Left = 8
    Top = 8
    Width = 102
    Height = 13
    Caption = 'Текущий календарь'
  end
  object EditCarryName: TEdit
    Left = 72
    Top = 112
    Width = 169
    Height = 21
    TabOrder = 2
  end
  object ButtonOK: TButton
    Left = 88
    Top = 144
    Width = 75
    Height = 25
    Caption = 'ОК'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object ButtonCancel: TButton
    Left = 168
    Top = 144
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Отмена'
    ModalResult = 2
    TabOrder = 4
  end
  object EditCurDate: TEdit
    Left = 120
    Top = 8
    Width = 121
    Height = 21
    TabStop = False
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 0
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 32
    Width = 233
    Height = 73
    Caption = 'Перенести выходной'
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 19
      Width = 42
      Height = 13
      Caption = 'Из даты'
    end
    object Label2: TLabel
      Left = 8
      Top = 43
      Width = 39
      Height = 13
      Caption = 'На дату'
    end
    object DateEdit1: TDateEdit
      Left = 112
      Top = 16
      Width = 113
      Height = 21
      NumGlyphs = 2
      Weekends = [Sun, Sat]
      TabOrder = 0
    end
    object DateEdit2: TDateEdit
      Left = 112
      Top = 40
      Width = 113
      Height = 21
      NumGlyphs = 2
      Weekends = [Sun, Sat]
      TabOrder = 1
    end
  end
  object quTemp: TIBQuery
    Transaction = trTemp
    BufferChunks = 1000
    CachedUpdates = False
    Left = 8
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
    Left = 64
    Top = 112
  end
end
