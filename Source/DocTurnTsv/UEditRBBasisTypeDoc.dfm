inherited fmEditRBBasisTypeDoc: TfmEditRBBasisTypeDoc
  Left = 380
  Top = 241
  Caption = 'fmEditRBBasisTypeDoc'
  ClientHeight = 117
  ClientWidth = 329
  PixelsPerInch = 96
  TextHeight = 13
  object lbFor: TLabel [0]
    Left = 24
    Top = 12
    Width = 80
    Height = 13
    Caption = 'Основание для:'
  end
  object lbWhat: TLabel [1]
    Left = 7
    Top = 38
    Width = 97
    Height = 13
    Caption = 'Который является:'
  end
  inherited pnBut: TPanel
    Top = 79
    Width = 329
    TabOrder = 5
    inherited Panel2: TPanel
      Left = 144
    end
  end
  inherited cbInString: TCheckBox
    Top = 58
    TabOrder = 4
  end
  object edFor: TEdit [4]
    Left = 113
    Top = 9
    Width = 190
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 0
    OnChange = edForChange
  end
  object edWhat: TEdit [5]
    Left = 113
    Top = 35
    Width = 190
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 2
    OnChange = edForChange
  end
  object bibFor: TBitBtn [6]
    Left = 303
    Top = 9
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 1
    OnClick = bibForClick
  end
  object bibWhat: TBitBtn [7]
    Left = 303
    Top = 35
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 3
    OnClick = bibWhatClick
  end
  inherited IBTran: TIBTransaction
    Top = 17
  end
end
