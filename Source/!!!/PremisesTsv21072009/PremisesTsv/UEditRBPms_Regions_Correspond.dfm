inherited fmEditRBPms_Regions_Correspond: TfmEditRBPms_Regions_Correspond
  Left = 451
  Top = 425
  Caption = 'fmEditRBPms_Regions_Correspond'
  ClientHeight = 125
  ClientWidth = 304
  PixelsPerInch = 96
  TextHeight = 13
  object lbCityRegion: TLabel [0]
    Left = 27
    Top = 20
    Width = 34
    Height = 13
    Alignment = taRightJustify
    Caption = 'Район:'
  end
  object lbRegion: TLabel [1]
    Left = 8
    Top = 47
    Width = 53
    Height = 13
    Alignment = taRightJustify
    Caption = 'Подрайон:'
  end
  inherited pnBut: TPanel
    Top = 87
    Width = 304
    TabOrder = 5
    inherited Panel2: TPanel
      Left = 119
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 73
    TabOrder = 4
  end
  object edCityRegion: TEdit [4]
    Left = 69
    Top = 16
    Width = 202
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 0
    OnChange = edCityRegionChange
  end
  object edRegion: TEdit [5]
    Left = 69
    Top = 43
    Width = 202
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 2
    OnChange = edCityRegionChange
  end
  object btCityRegion: TButton [6]
    Left = 271
    Top = 16
    Width = 23
    Height = 22
    Caption = '...'
    TabOrder = 1
    OnClick = btCityRegionClick
  end
  object btRegion: TButton [7]
    Left = 271
    Top = 43
    Width = 23
    Height = 22
    Caption = '...'
    TabOrder = 3
    OnClick = btRegionClick
  end
  inherited IBTran: TIBTransaction
    Left = 120
    Top = 129
  end
end
