inherited fmEditRBToolbutton: TfmEditRBToolbutton
  Left = 283
  Top = 223
  Caption = 'fmEditRBToolbutton'
  ClientHeight = 261
  ClientWidth = 559
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object lbName: TLabel [0]
    Left = 8
    Top = 13
    Width = 79
    Height = 13
    Alignment = taRightJustify
    Caption = 'Наименование:'
  end
  object lbToolbar: TLabel [1]
    Left = 46
    Top = 39
    Width = 41
    Height = 13
    Alignment = taRightJustify
    Caption = 'Панель:'
  end
  object lbHint: TLabel [2]
    Left = 34
    Top = 90
    Width = 53
    Height = 13
    Alignment = taRightJustify
    Caption = 'Описание:'
  end
  object lbShortCut: TLabel [3]
    Left = 87
    Top = 152
    Width = 91
    Height = 13
    Alignment = taRightJustify
    Caption = 'Горячая клавиша:'
  end
  object lbInterface: TLabel [4]
    Left = 27
    Top = 66
    Width = 60
    Height = 13
    Alignment = taRightJustify
    Caption = 'Интерфейс:'
  end
  object lbStyle: TLabel [5]
    Left = 104
    Top = 177
    Width = 74
    Height = 13
    Alignment = taRightJustify
    Caption = 'Вид элемента:'
  end
  object lbSort: TLabel [6]
    Left = 371
    Top = 202
    Width = 109
    Height = 13
    Alignment = taRightJustify
    Caption = 'Порядок сортировки:'
  end
  inherited pnBut: TPanel
    Top = 223
    Width = 559
    TabOrder = 12
    inherited Panel2: TPanel
      Left = 374
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 205
    TabOrder = 11
  end
  object edName: TEdit [9]
    Left = 96
    Top = 9
    Width = 211
    Height = 21
    MaxLength = 100
    TabOrder = 0
    OnChange = edNameChange
  end
  object edToolbar: TEdit [10]
    Left = 96
    Top = 35
    Width = 190
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 1
    OnChange = edNameChange
    OnKeyDown = edToolbarKeyDown
  end
  object bibToolbar: TButton [11]
    Left = 286
    Top = 35
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 2
    OnClick = bibToolbarClick
  end
  object meHint: TMemo [12]
    Left = 96
    Top = 89
    Width = 212
    Height = 55
    TabOrder = 5
    OnChange = edNameChange
  end
  object grbImage: TGroupBox [13]
    Left = 314
    Top = 3
    Width = 237
    Height = 191
    Caption = ' Картинка '
    TabOrder = 8
    object srlbxImage: TScrollBox
      Left = 11
      Top = 20
      Width = 138
      Height = 123
      TabOrder = 0
      object imImage: TImage
        Left = 0
        Top = 0
        Width = 134
        Height = 119
        AutoSize = True
        Center = True
        Stretch = True
        OnMouseDown = imImageMouseDown
        OnMouseMove = imImageMouseMove
        OnMouseUp = imImageMouseUp
      end
    end
    object bibImageLoad: TButton
      Left = 157
      Top = 19
      Width = 70
      Height = 20
      Hint = 'Загрузить заставку'
      Cancel = True
      Caption = 'Загрузить'
      TabOrder = 1
      OnClick = bibImageLoadClick
    end
    object bibImageSave: TButton
      Left = 157
      Top = 43
      Width = 70
      Height = 20
      Hint = 'Сохранить заставку'
      Caption = 'Сохранить'
      TabOrder = 2
      OnClick = bibImageSaveClick
    end
    object bibImageCopy: TButton
      Left = 157
      Top = 67
      Width = 70
      Height = 20
      Hint = 'Копировать в буфер'
      Cancel = True
      Caption = 'Копировать'
      TabOrder = 3
      OnClick = bibImageCopyClick
    end
    object bibImagePaste: TButton
      Left = 157
      Top = 91
      Width = 70
      Height = 20
      Hint = 'Вставить из буфера '
      Caption = 'Вставить'
      TabOrder = 4
      OnClick = bibImagePasteClick
    end
    object chbImageStretch: TCheckBox
      Left = 11
      Top = 161
      Width = 137
      Height = 17
      Caption = 'Растягивать'
      Checked = True
      State = cbChecked
      TabOrder = 6
      OnClick = chbImageStretchClick
    end
    object bibImageClear: TButton
      Left = 157
      Top = 115
      Width = 70
      Height = 20
      Hint = 'Очистить заставку'
      Caption = 'Очистить'
      TabOrder = 5
      OnClick = bibImageClearClick
    end
  end
  object htShortCut: THotKey [14]
    Left = 187
    Top = 149
    Width = 121
    Height = 19
    HotKey = 0
    InvalidKeys = [hcShift, hcAlt, hcShiftAlt, hcShiftCtrlAlt]
    Modifiers = []
    TabOrder = 6
    OnEnter = htShortCutEnter
    OnExit = htShortCutEnter
  end
  object edInterface: TEdit [15]
    Left = 96
    Top = 62
    Width = 190
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 3
    OnChange = edNameChange
    OnKeyDown = edInterfaceKeyDown
  end
  object bibInterface: TButton [16]
    Left = 286
    Top = 62
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 4
    OnClick = bibInterfaceClick
  end
  object cmbStyle: TComboBox [17]
    Left = 187
    Top = 173
    Width = 121
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 7
    OnChange = edNameChange
    Items.Strings = (
      'Товар'
      'Услуга'
      'Набор')
  end
  object edSort: TEdit [18]
    Left = 489
    Top = 199
    Width = 46
    Height = 21
    ReadOnly = True
    TabOrder = 9
    Text = '1'
    OnChange = edNameChange
  end
  object udSort: TUpDown [19]
    Left = 535
    Top = 199
    Width = 15
    Height = 21
    Associate = edSort
    Min = 1
    Position = 1
    TabOrder = 10
    Wrap = False
    OnChanging = udSortChanging
  end
  inherited IBTran: TIBTransaction
    Top = 123
  end
  object OD: TOpenPictureDialog
    Options = [ofEnableSizing]
    Left = 395
    Top = 54
  end
  object SD: TSavePictureDialog
    Options = [ofEnableSizing]
    Left = 355
    Top = 54
  end
end
