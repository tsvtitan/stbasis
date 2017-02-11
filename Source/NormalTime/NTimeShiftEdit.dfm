object frmShiftEdit: TfrmShiftEdit
  Left = 431
  Top = 229
  BorderStyle = bsDialog
  Caption = 'frmShiftEdit'
  ClientHeight = 111
  ClientWidth = 224
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
    Top = 10
    Width = 76
    Height = 13
    Caption = 'Наименование'
  end
  object Label2: TLabel
    Left = 8
    Top = 42
    Width = 90
    Height = 13
    Caption = 'Процент допланы'
  end
  object EditName: TEdit
    Left = 96
    Top = 8
    Width = 121
    Height = 21
    TabOrder = 0
  end
  object EditPercent: TRxSpinEdit
    Left = 112
    Top = 40
    Width = 105
    Height = 21
    ButtonKind = bkStandard
    TabOrder = 1
  end
  object ButtonOK: TButton
    Left = 64
    Top = 80
    Width = 75
    Height = 25
    Caption = 'ОК'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object ButtonCancel: TButton
    Left = 144
    Top = 80
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Отмена'
    ModalResult = 2
    TabOrder = 3
  end
  object quTemp: TIBQuery
    Transaction = trTemp
    BufferChunks = 1000
    CachedUpdates = False
    Left = 112
    Top = 24
  end
  object trTemp: TIBTransaction
    Active = False
    DefaultAction = TARollback
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    AutoStopAction = saNone
    Left = 168
    Top = 16
  end
end
