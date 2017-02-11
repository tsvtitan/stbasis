inherited fmEditRBPms_Planning: TfmEditRBPms_Planning
  Caption = 'fmEditRBPms_Planning'
  ClientHeight = 285
  ClientWidth = 314
  PixelsPerInch = 96
  TextHeight = 13
  object lbName: TLabel [0]
    Left = 8
    Top = 20
    Width = 79
    Height = 13
    Alignment = taRightJustify
    Caption = 'Наименование:'
  end
  object lbNote: TLabel [1]
    Left = 34
    Top = 47
    Width = 53
    Height = 13
    Alignment = taRightJustify
    Caption = 'Описание:'
  end
  object lbImage: TLabel [2]
    Left = 36
    Top = 99
    Width = 51
    Height = 13
    Caption = 'Картинка:'
  end
  object lbSortNumber: TLabel [3]
    Left = 42
    Top = 72
    Width = 47
    Height = 13
    Caption = 'Порядок:'
  end
  inherited pnBut: TPanel
    Top = 247
    Width = 314
    TabOrder = 8
    inherited Panel2: TPanel
      Left = 129
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 227
    TabOrder = 7
  end
  object edName: TEdit [6]
    Left = 97
    Top = 16
    Width = 209
    Height = 21
    MaxLength = 100
    TabOrder = 0
    OnChange = edNameChange
  end
  object edNote: TEdit [7]
    Left = 97
    Top = 43
    Width = 209
    Height = 21
    MaxLength = 100
    TabOrder = 1
    OnChange = edNameChange
  end
  object bibImageLoad: TButton [8]
    Left = 237
    Top = 99
    Width = 70
    Height = 20
    Hint = 'Загрузить'
    Cancel = True
    Caption = 'Загрузить'
    TabOrder = 4
    OnClick = bibImageLoadClick
  end
  object bibImageSave: TButton [9]
    Left = 237
    Top = 125
    Width = 70
    Height = 20
    Hint = 'Сохранить'
    Caption = 'Сохранить'
    TabOrder = 5
    OnClick = bibImageSaveClick
  end
  object pnImage: TPanel [10]
    Left = 96
    Top = 99
    Width = 135
    Height = 121
    BevelOuter = bvLowered
    TabOrder = 9
    object imImage: TImage
      Left = 1
      Top = 1
      Width = 133
      Height = 119
      Align = alClient
      Center = True
      Stretch = True
    end
  end
  object bibClearImage: TButton [11]
    Left = 237
    Top = 151
    Width = 70
    Height = 20
    Hint = 'Очистить'
    Caption = 'Очистить'
    TabOrder = 6
    OnClick = bibClearImageClick
  end
  object edSort: TEdit [12]
    Left = 97
    Top = 70
    Width = 46
    Height = 21
    ReadOnly = True
    TabOrder = 2
    Text = '1'
    OnChange = edNameChange
  end
  object udSort: TUpDown [13]
    Left = 143
    Top = 70
    Width = 15
    Height = 21
    Associate = edSort
    Min = 1
    Position = 1
    TabOrder = 3
    Wrap = False
    OnChanging = udSortChanging
  end
  inherited IBTran: TIBTransaction
    Left = 128
    Top = 156
  end
  object OD: TOpenPictureDialog
    Options = [ofEnableSizing]
    Left = 11
    Top = 126
  end
  object SD: TSavePictureDialog
    Options = [ofEnableSizing]
    Left = 43
    Top = 126
  end
end
