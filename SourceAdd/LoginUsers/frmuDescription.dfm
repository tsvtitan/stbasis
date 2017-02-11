inherited frmDescription: TfrmDescription
  Left = 684
  Top = 370
  Caption = 'Edit Description'
  ClientHeight = 273
  ClientWidth = 310
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object reDescription: TRichEditX
    Left = 0
    Top = 0
    Width = 310
    Height = 231
    Align = alTop
    Lines.Strings = (
      'reDescription')
    TabOrder = 0
  end
  object Button1: TButton
    Left = 145
    Top = 241
    Width = 75
    Height = 25
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 231
    Top = 241
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
