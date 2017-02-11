inherited fmEditRBCashBasis: TfmEditRBCashBasis
  Caption = 'fmEditRBCashBasis'
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 16
    Top = 8
    Width = 87
    Height = 13
    Caption = 'Текст основания'
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
    TabOrder = 2
    OnKeyDown = FormKeyDown
  end
end
