object frmCategoryEdit: TfrmCategoryEdit
  Left = 443
  Top = 246
  BorderStyle = bsDialog
  Caption = 'Категории'
  ClientHeight = 104
  ClientWidth = 278
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
    Top = 18
    Width = 76
    Height = 13
    Caption = 'Наименование'
  end
  object Label2: TLabel
    Left = 8
    Top = 42
    Width = 59
    Height = 13
    Caption = 'Вид оплаты'
  end
  object EditName: TEdit
    Left = 96
    Top = 16
    Width = 177
    Height = 21
    TabOrder = 0
  end
  object ButtonOK: TButton
    Left = 120
    Top = 72
    Width = 75
    Height = 25
    Caption = 'ОК'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object ButtonCancel: TButton
    Left = 200
    Top = 72
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Отмена'
    ModalResult = 2
    TabOrder = 3
  end
  object ComboEdit1: TComboEdit
    Left = 96
    Top = 40
    Width = 177
    Height = 21
    Color = clBtnFace
    DirectInput = False
    GlyphKind = gkEllipsis
    ButtonWidth = 16
    NumGlyphs = 1
    TabOrder = 1
    OnButtonClick = ComboEdit1ButtonClick
  end
  object quTemp: TIBQuery
    Transaction = trTemp
    BufferChunks = 1000
    CachedUpdates = False
    Left = 144
  end
  object trTemp: TIBTransaction
    Active = False
    DefaultAction = TARollback
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    AutoStopAction = saNone
    Left = 216
  end
end
