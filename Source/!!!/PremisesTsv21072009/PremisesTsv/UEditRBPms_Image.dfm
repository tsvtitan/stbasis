inherited fmEditRBPms_Image: TfmEditRBPms_Image
  Left = 350
  Top = 184
  Caption = 'fmEditRBPms_Image'
  ClientHeight = 325
  ClientWidth = 459
  PixelsPerInch = 96
  TextHeight = 13
  object lbHouseNumber: TLabel [0]
    Left = 283
    Top = 15
    Width = 66
    Height = 13
    Alignment = taRightJustify
    Caption = 'Номер дома:'
  end
  object lbImage: TLabel [1]
    Left = 10
    Top = 37
    Width = 51
    Height = 13
    Caption = 'Картинка:'
  end
  object lbStreet: TLabel [2]
    Left = 12
    Top = 15
    Width = 35
    Height = 13
    Alignment = taRightJustify
    Caption = 'Улица:'
    FocusControl = edStreet
  end
  inherited pnBut: TPanel
    Top = 287
    Width = 459
    TabOrder = 8
    inherited Panel2: TPanel
      Left = 274
    end
  end
  inherited cbInString: TCheckBox
    Left = 16
    Top = 260
    TabOrder = 7
  end
  object edHouseNumber: TEdit [5]
    Left = 359
    Top = 11
    Width = 88
    Height = 21
    MaxLength = 100
    TabOrder = 2
    OnChange = edNameChange
  end
  object bibImageLoad: TButton [6]
    Left = 223
    Top = 255
    Width = 70
    Height = 20
    Hint = 'Загрузить'
    Cancel = True
    Caption = 'Загрузить'
    TabOrder = 4
    OnClick = bibImageLoadClick
  end
  object bibImageSave: TButton [7]
    Left = 301
    Top = 255
    Width = 70
    Height = 20
    Hint = 'Сохранить'
    Caption = 'Сохранить'
    TabOrder = 5
    OnClick = bibImageSaveClick
  end
  object pnImage: TPanel [8]
    Left = 10
    Top = 55
    Width = 438
    Height = 195
    BevelOuter = bvNone
    TabOrder = 3
    object ScrollBox1: TScrollBox
      Left = 0
      Top = 0
      Width = 438
      Height = 195
      Align = alClient
      TabOrder = 0
      object imImage: TImage
        Left = 0
        Top = 0
        Width = 258
        Height = 117
        AutoSize = True
        Center = True
      end
    end
  end
  object bibClearImage: TButton [9]
    Left = 379
    Top = 255
    Width = 70
    Height = 20
    Hint = 'Очистить'
    Caption = 'Очистить'
    TabOrder = 6
    OnClick = bibClearImageClick
  end
  object edStreet: TEdit [10]
    Left = 57
    Top = 11
    Width = 188
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 0
    OnChange = edNameChange
  end
  object btStreet: TButton [11]
    Left = 251
    Top = 11
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 1
    OnClick = btStreetClick
  end
  inherited IBTran: TIBTransaction
    Left = 143
    Top = 85
  end
  object OD: TOpenPictureDialog
    Options = [ofEnableSizing]
    Left = 74
    Top = 87
  end
  object SD: TSavePictureDialog
    Options = [ofEnableSizing]
    Left = 106
    Top = 87
  end
end
