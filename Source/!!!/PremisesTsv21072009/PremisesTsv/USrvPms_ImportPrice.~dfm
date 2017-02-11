inherited fmSrvPms_ImportPrice: TfmSrvPms_ImportPrice
  Left = 251
  Top = 233
  Width = 520
  Height = 420
  ActiveControl = bibLoad
  Caption = 'fmSrvPms_ImportPrice'
  Constraints.MinHeight = 420
  Constraints.MinWidth = 520
  PixelsPerInch = 96
  TextHeight = 13
  object spl: TSplitter
    Left = 0
    Top = 155
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
    TabOrder = 2
    object lbCount: TLabel
      Left = 116
      Top = 15
      Width = 42
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = 'Всего: 0'
    end
    object bibLoad: TButton
      Left = 7
      Top = 9
      Width = 98
      Height = 25
      Hint = 'Загрузить импортируемые данные'
      Anchors = [akLeft, akBottom]
      Caption = 'Загрузить прайс'
      ParentShowHint = False
      ShowHint = False
      TabOrder = 0
      OnClick = bibLoadClick
    end
    object bibImport: TButton
      Left = 232
      Top = 9
      Width = 109
      Height = 25
      Hint = 'Импортировать в объявления ...'
      Anchors = [akRight, akBottom]
      Caption = 'Импортировать ...'
      TabOrder = 1
      OnClick = bibImportClick
    end
    object bibBreak: TButton
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
    end
    object bibClose: TButton
      Left = 430
      Top = 9
      Width = 75
      Height = 25
      Hint = 'Закрыть'
      Anchors = [akRight, akBottom]
      Caption = 'Закрыть'
      TabOrder = 3
      OnClick = bibCloseClick
    end
  end
  object pnGrbBack: TPanel
    Left = 0
    Top = 0
    Width = 512
    Height = 155
    Align = alTop
    BevelOuter = bvNone
    BorderWidth = 5
    Constraints.MinHeight = 155
    TabOrder = 0
    object grbCondition: TGroupBox
      Left = 5
      Top = 5
      Width = 502
      Height = 145
      Align = alClient
      Caption = ' Условия '
      TabOrder = 0
      object pnBackCondition: TPanel
        Left = 2
        Top = 15
        Width = 498
        Height = 128
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 5
        TabOrder = 0
        object pnConditionPlus: TPanel
          Left = 257
          Top = 5
          Width = 236
          Height = 118
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          object lbTypeOperation: TLabel
            Left = 7
            Top = -2
            Width = 145
            Height = 13
            Caption = 'Операция с недвижимостью'
          end
          object lbTypePremises: TLabel
            Left = 16
            Top = 42
            Width = 100
            Height = 13
            Alignment = taRightJustify
            Caption = 'Тип недвижимости:'
          end
          object lbUnitPrice: TLabel
            Left = 11
            Top = 66
            Width = 105
            Height = 13
            Alignment = taRightJustify
            Caption = 'Единица измерения:'
          end
          object bibLoadCondition: TButton
            Left = 8
            Top = 92
            Width = 108
            Height = 25
            Anchors = [akLeft, akBottom]
            Caption = 'Загрузить условия'
            TabOrder = 5
            OnClick = bibLoadConditionClick
          end
          object bibSaveCondition: TButton
            Left = 122
            Top = 92
            Width = 108
            Height = 25
            Anchors = [akLeft, akBottom]
            Caption = 'Сохранить условия'
            TabOrder = 6
            OnClick = bibSaveConditionClick
          end
          object cmbTypeOperation: TComboBox
            Left = 7
            Top = 14
            Width = 224
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            TabOrder = 0
            Items.Strings = (
              'Продажа'
              'Аренда'
              'Долевое')
          end
          object edTypePremises: TEdit
            Left = 122
            Top = 39
            Width = 83
            Height = 21
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 1
            OnKeyDown = edTypePremisesKeyDown
          end
          object bibTypePremises: TButton
            Left = 209
            Top = 39
            Width = 21
            Height = 21
            Caption = '...'
            TabOrder = 2
            OnClick = bibTypePremisesClick
          end
          object edUnitPrice: TEdit
            Left = 122
            Top = 63
            Width = 83
            Height = 21
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 3
            OnKeyDown = edUnitPriceKeyDown
          end
          object bibUnitPrice: TButton
            Left = 209
            Top = 63
            Width = 21
            Height = 21
            Caption = '...'
            TabOrder = 4
            OnClick = bibUnitPriceClick
          end
        end
        object pnValEdit: TPanel
          Left = 5
          Top = 5
          Width = 252
          Height = 118
          Align = alLeft
          Anchors = [akLeft, akBottom]
          BevelOuter = bvNone
          TabOrder = 0
        end
      end
    end
  end
  object pnGrid: TPanel
    Left = 0
    Top = 158
    Width = 512
    Height = 194
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 5
    Constraints.MinHeight = 100
    TabOrder = 1
    object lbGrid: TLabel
      Left = 5
      Top = 5
      Width = 502
      Height = 18
      Align = alTop
      AutoSize = False
      Caption = 'Предварительный просмотр'
      Layout = tlCenter
    end
  end
  object od: TOpenDialog
    Filter = 'Файлы XLS (*.xls)|*.xls|Все файлы (*.*)|*.*'
    Options = [ofEnableSizing]
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
  object odCondition: TOpenDialog
    Filter = 'Файлы DAT (*.dat)|*.dat|Все файлы (*.*)|*.*'
    Left = 295
    Top = 209
  end
  object sdCondition: TSaveDialog
    DefaultExt = '*.dat'
    Filter = 'Файлы DAT (*.dat)|*.dat|Все файлы (*.*)|*.*'
    Left = 343
    Top = 209
  end
  object pmGrid: TPopupMenu
    Left = 208
    Top = 272
    object miSaveGridToFile: TMenuItem
      Caption = 'Сохранить'
      Hint = 'Сохранить предварительный просмотр в файл'
      OnClick = miSaveGridToFileClick
    end
    object miLoadGridFromFile: TMenuItem
      Caption = 'Загрузить'
      Hint = 'Загрузить предварительный просмотр из файла'
      OnClick = miLoadGridFromFileClick
    end
    object miDeleteGrid: TMenuItem
      Caption = 'Удалить'
      Hint = 'Удалить запись'
      ShortCut = 16430
      OnClick = miDeleteGridClick
    end
    object miClearGrid: TMenuItem
      Caption = 'Очистить'
      Hint = 'Очистить предварительный просмотр'
      OnClick = miClearGridClick
    end
  end
  object sdGrid: TSaveDialog
    Options = [ofEnableSizing]
    Left = 176
    Top = 272
  end
  object cds: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 240
    Top = 272
  end
  object odGrid: TOpenDialog
    Options = [ofEnableSizing]
    Left = 144
    Top = 272
  end
end
