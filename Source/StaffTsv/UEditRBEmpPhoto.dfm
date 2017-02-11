inherited fmEditRBEmpPhoto: TfmEditRBEmpPhoto
  Left = 289
  Top = 125
  Caption = 'fmEditRBEmpPhoto'
  ClientHeight = 328
  ClientWidth = 338
  PixelsPerInch = 96
  TextHeight = 13
  object lbDatePhoto: TLabel [0]
    Left = 9
    Top = 10
    Width = 94
    Height = 13
    Caption = 'Дата фотографии:'
  end
  object lbNote: TLabel [1]
    Left = 37
    Top = 32
    Width = 66
    Height = 13
    Caption = 'Примечание:'
  end
  object lbPhoto: TLabel [2]
    Left = 35
    Top = 126
    Width = 68
    Height = 13
    Caption = 'Фотография:'
  end
  inherited pnBut: TPanel
    Top = 290
    Width = 338
    TabOrder = 9
    inherited Panel2: TPanel
      Left = 153
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 274
    TabOrder = 8
  end
  object dtpDatePhoto: TDateTimePicker [5]
    Left = 112
    Top = 6
    Width = 84
    Height = 22
    CalAlignment = dtaLeft
    Date = 37156
    Time = 37156
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 0
    OnChange = dtpDatePhotoChange
  end
  object meNote: TMemo [6]
    Left = 112
    Top = 35
    Width = 220
    Height = 86
    TabOrder = 1
    OnChange = meNoteChange
  end
  object srlbxPhoto: TScrollBox [7]
    Left = 112
    Top = 128
    Width = 138
    Height = 123
    TabOrder = 2
    object imPhoto: TImage
      Left = 0
      Top = 0
      Width = 134
      Height = 119
      AutoSize = True
      Center = True
      Stretch = True
      OnMouseDown = imPhotoMouseDown
      OnMouseMove = imPhotoMouseMove
      OnMouseUp = imPhotoMouseUp
    end
  end
  object bibPhotoLoad: TBitBtn [8]
    Left = 257
    Top = 128
    Width = 75
    Height = 25
    Hint = 'Загрузить картинку'
    Cancel = True
    Caption = 'Загрузить'
    TabOrder = 3
    OnClick = bibPhotoLoadClick
    NumGlyphs = 2
  end
  object bibPhotoSave: TBitBtn [9]
    Left = 257
    Top = 160
    Width = 75
    Height = 25
    Hint = 'Сохранить картинку'
    Caption = 'Сохранить'
    TabOrder = 4
    OnClick = bibPhotoSaveClick
    NumGlyphs = 2
  end
  object bibPhotoCopy: TBitBtn [10]
    Left = 257
    Top = 192
    Width = 75
    Height = 25
    Hint = 'Копировать в буфер'
    Cancel = True
    Caption = 'Копировать'
    TabOrder = 5
    OnClick = bibPhotoCopyClick
    NumGlyphs = 2
  end
  object bibPhotoPaste: TBitBtn [11]
    Left = 257
    Top = 224
    Width = 75
    Height = 25
    Hint = 'Вставить из буфера '
    Caption = 'Вставить'
    TabOrder = 6
    OnClick = bibPhotoPasteClick
    NumGlyphs = 2
  end
  object chbPhotoStretch: TCheckBox [12]
    Left = 112
    Top = 254
    Width = 137
    Height = 17
    Caption = 'Растягивать'
    Checked = True
    State = cbChecked
    TabOrder = 7
    OnClick = chbPhotoStretchClick
  end
  inherited IBTran: TIBTransaction
    Left = 75
    Top = 59
  end
  object OD: TOpenPictureDialog
    Options = [ofEnableSizing]
    Left = 11
    Top = 59
  end
  object SD: TSavePictureDialog
    Options = [ofEnableSizing]
    Left = 43
    Top = 59
  end
end
