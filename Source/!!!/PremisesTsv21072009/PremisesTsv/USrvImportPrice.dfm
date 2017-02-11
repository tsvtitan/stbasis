inherited fmSrvImportPrice: TfmSrvImportPrice
  Left = 418
  Top = 165
  Width = 520
  Height = 420
  ActiveControl = bibLoad
  Caption = 'fmSrvImportPrice'
  Constraints.MinHeight = 420
  Constraints.MinWidth = 520
  PixelsPerInch = 96
  TextHeight = 13
  object spl: TSplitter
    Left = 0
    Top = 211
    Width = 512
    Height = 3
    Cursor = crSizeNS
    Align = alTop
    MinSize = 100
  end
  object pnBut: TPanel
    Left = 0
    Top = 352
    Width = 512
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    object lbCount: TLabel
      Left = 94
      Top = 15
      Width = 42
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = 'Всего: 0'
    end
    object bibLoad: TBitBtn
      Left = 7
      Top = 9
      Width = 75
      Height = 25
      Hint = 'Загрузить импортируемые данные'
      Anchors = [akLeft, akBottom]
      Caption = 'Загрузить'
      ParentShowHint = False
      ShowHint = False
      TabOrder = 0
      OnClick = bibLoadClick
    end
    object bibImport: TBitBtn
      Left = 232
      Top = 9
      Width = 109
      Height = 25
      Hint = 'Импортировать в объявления ...'
      Anchors = [akRight, akBottom]
      Caption = 'Импортировать ...'
      TabOrder = 1
      OnClick = bibImportClick
      NumGlyphs = 2
    end
    object bibBreak: TBitBtn
      Left = 348
      Top = 9
      Width = 75
      Height = 25
      Hint = 'Прервать выполнение'
      Anchors = [akRight, akBottom]
      Caption = 'Прервать'
      Enabled = False
      TabOrder = 2
      OnClick = bibBreakClick
      NumGlyphs = 2
    end
    object bibClose: TBitBtn
      Left = 430
      Top = 9
      Width = 75
      Height = 25
      Hint = 'Закрыть'
      Anchors = [akRight, akBottom]
      Caption = 'Закрыть'
      TabOrder = 3
      OnClick = bibCloseClick
      NumGlyphs = 2
    end
  end
  object pnGrbBack: TPanel
    Left = 0
    Top = 41
    Width = 512
    Height = 170
    Align = alTop
    BevelOuter = bvNone
    BorderWidth = 5
    Constraints.MinHeight = 100
    TabOrder = 1
    object grbRichEdit: TGroupBox
      Left = 5
      Top = 5
      Width = 502
      Height = 160
      Align = alClient
      Caption = ' Импортируемые данные '
      TabOrder = 0
      object pnBackRichEdit: TPanel
        Left = 2
        Top = 15
        Width = 498
        Height = 143
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 5
        TabOrder = 0
      end
    end
  end
  object pnGrid: TPanel
    Left = 0
    Top = 214
    Width = 512
    Height = 138
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 5
    Constraints.MinHeight = 100
    TabOrder = 2
  end
  object pnRelease: TPanel
    Left = 0
    Top = 0
    Width = 512
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lbRelease: TLabel
      Left = 166
      Top = 18
      Width = 80
      Height = 13
      Anchors = [akTop, akRight]
      Caption = 'Выпуск газеты:'
    end
    object edRelease: TEdit
      Left = 256
      Top = 15
      Width = 223
      Height = 21
      Anchors = [akTop, akRight]
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 0
    end
    object bibRelease: TBitBtn
      Left = 479
      Top = 15
      Width = 21
      Height = 21
      Hint = 'Выбрать'
      Anchors = [akTop, akRight]
      Caption = '...'
      TabOrder = 1
      OnClick = bibReleaseClick
    end
  end
  object od: TOpenDialog
    Filter = 
      'Файлы RTF (*.rtf)|*.rtf|Файлы TXT (*.txt)|*.txt|Все файлы (*.*)|' +
      '*.*'
    Options = [ofAllowMultiSelect, ofEnableSizing]
    Left = 58
    Top = 103
  end
  object ds: TDataSource
    Left = 40
    Top = 205
  end
  object qr: TIBQuery
    BufferChunks = 1
    CachedUpdates = False
    ParamCheck = False
    Left = 88
    Top = 205
  end
  object tran: TIBTransaction
    Active = False
    AutoStopAction = saNone
    Left = 128
    Top = 205
  end
end
