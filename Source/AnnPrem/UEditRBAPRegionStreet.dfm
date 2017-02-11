inherited fmEditRBAPRegionStreet: TfmEditRBAPRegionStreet
  Left = 520
  Top = 308
  Caption = 'fmEditRBAPRegionStreet'
  ClientHeight = 117
  ClientWidth = 270
  PixelsPerInch = 96
  TextHeight = 13
  object lbRegion: TLabel [0]
    Left = 24
    Top = 12
    Width = 34
    Height = 13
    Caption = 'Район:'
  end
  object lbStreet: TLabel [1]
    Left = 23
    Top = 38
    Width = 35
    Height = 13
    Caption = 'Улица:'
  end
  inherited pnBut: TPanel
    Top = 79
    Width = 270
    TabOrder = 5
    inherited Panel2: TPanel
      Left = 85
    end
  end
  inherited cbInString: TCheckBox
    Top = 58
    TabOrder = 4
  end
  object edRegion: TEdit [4]
    Left = 68
    Top = 9
    Width = 165
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 0
    OnChange = edRegionChange
  end
  object edStreet: TEdit [5]
    Left = 68
    Top = 35
    Width = 165
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 2
    OnChange = edRegionChange
  end
  object bibRegion: TButton [6]
    Left = 239
    Top = 9
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 1
    OnClick = bibRegionClick
  end
  object bibStreet: TButton [7]
    Left = 239
    Top = 35
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 3
    OnClick = bibStreetClick
  end
  inherited IBTran: TIBTransaction
    Left = 112
  end
end
