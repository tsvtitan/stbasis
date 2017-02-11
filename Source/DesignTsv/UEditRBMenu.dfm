inherited fmEditRBMenu: TfmEditRBMenu
  Left = 372
  Top = 195
  Caption = 'fmEditRBMenu'
  ClientHeight = 242
  ClientWidth = 554
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
  object lbParent: TLabel [1]
    Left = 36
    Top = 39
    Width = 51
    Height = 13
    Alignment = taRightJustify
    Caption = 'Родитель:'
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
  object lbSort: TLabel [5]
    Left = 369
    Top = 174
    Width = 109
    Height = 13
    Alignment = taRightJustify
    Caption = 'Порядок сортировки:'
  end
  inherited pnBut: TPanel
    Top = 204
    Width = 554
    TabOrder = 12
    inherited Panel2: TPanel
      Left = 369
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 188
    TabOrder = 11
  end
  object edName: TEdit [8]
    Left = 96
    Top = 9
    Width = 211
    Height = 21
    MaxLength = 100
    TabOrder = 0
    OnChange = edNameChange
  end
  object edParent: TEdit [9]
    Left = 96
    Top = 35
    Width = 190
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 1
    OnChange = edNameChange
    OnKeyDown = edParentKeyDown
  end
  object bibParent: TButton [10]
    Left = 286
    Top = 35
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 2
    OnClick = bibParentClick
  end
  object meHint: TMemo [11]
    Left = 96
    Top = 89
    Width = 212
    Height = 55
    TabOrder = 5
    OnChange = edNameChange
  end
  object grbImage: TGroupBox [12]
    Left = 314
    Top = 3
    Width = 234
    Height = 164
    Caption = ' Картинка '
    TabOrder = 8
    object srlbxImage: TScrollBox
      Left = 9
      Top = 16
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
      Left = 155
      Top = 15
      Width = 70
      Height = 20
      Hint = 'Загрузить заставку'
      Cancel = True
      Caption = 'Загрузить'
      TabOrder = 1
      OnClick = bibImageLoadClick
    end
    object bibImageSave: TButton
      Left = 155
      Top = 39
      Width = 70
      Height = 20
      Hint = 'Сохранить заставку'
      Caption = 'Сохранить'
      TabOrder = 2
      OnClick = bibImageSaveClick
    end
    object bibImageCopy: TButton
      Left = 155
      Top = 63
      Width = 70
      Height = 20
      Hint = 'Копировать в буфер'
      Cancel = True
      Caption = 'Копировать'
      TabOrder = 3
      OnClick = bibImageCopyClick
    end
    object bibImagePaste: TButton
      Left = 155
      Top = 87
      Width = 70
      Height = 20
      Hint = 'Вставить из буфера '
      Caption = 'Вставить'
      TabOrder = 4
      OnClick = bibImagePasteClick
    end
    object chbImageStretch: TCheckBox
      Left = 9
      Top = 142
      Width = 137
      Height = 17
      Caption = 'Растягивать'
      Checked = True
      State = cbChecked
      TabOrder = 6
      OnClick = chbImageStretchClick
    end
    object bibImageClear: TButton
      Left = 155
      Top = 111
      Width = 70
      Height = 20
      Hint = 'Очистить заставку'
      Caption = 'Очистить'
      TabOrder = 5
      OnClick = bibImageClearClick
    end
  end
  object htShortCut: THotKey [13]
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
  object chbChangeFlag: TCheckBox [14]
    Left = 136
    Top = 172
    Width = 171
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Заменять предыдущее меню'
    TabOrder = 7
    OnClick = chbChangeFlagClick
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
  object edSort: TEdit [17]
    Left = 487
    Top = 171
    Width = 46
    Height = 21
    ReadOnly = True
    TabOrder = 9
    Text = '1'
  end
  object udSort: TUpDown [18]
    Left = 533
    Top = 171
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
    Top = 201
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
