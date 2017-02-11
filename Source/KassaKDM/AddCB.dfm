inherited FAddCB: TFAddCB
  Left = 218
  Top = 160
  ClientHeight = 110
  ClientWidth = 313
  OnClose = nil
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 16
    Top = 8
    Width = 87
    Height = 13
    Caption = 'Текст основания'
  end
  inherited pnBut: TPanel
    Top = 72
    Width = 313
    TabOrder = 2
    inherited Panel2: TPanel
      Left = 128
    end
  end
  object Edit: TEdit [3]
    Left = 16
    Top = 24
    Width = 281
    Height = 21
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 100
    ParentFont = False
    TabOrder = 0
    OnKeyDown = FormKeyDown
  end
end
