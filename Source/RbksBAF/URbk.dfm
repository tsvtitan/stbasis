object FmRbk: TFmRbk
  Left = 152
  Top = 163
  Width = 473
  Height = 353
  Color = clBtnFace
  Constraints.MinHeight = 340
  Constraints.MinWidth = 460
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnKeyUp = FormKeyUp
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object PnFind: TPanel
    Left = 0
    Top = 0
    Width = 465
    Height = 34
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Lbfind: TLabel
      Left = 0
      Top = 0
      Width = 65
      Height = 34
      Align = alLeft
      Alignment = taCenter
      Caption = 'Поиск:'
      Constraints.MinWidth = 65
      Layout = tlCenter
    end
    object EdFind: TEdit
      Left = 64
      Top = 7
      Width = 337
      Height = 21
      TabOrder = 0
      OnChange = EdFindChange
    end
  end
  object PnOk: TPanel
    Left = 0
    Top = 286
    Width = 465
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 4
    Constraints.MinHeight = 40
    TabOrder = 1
    object LbRecCount: TLabel
      Left = 165
      Top = 14
      Width = 80
      Height = 13
      Caption = 'Всего выбрано:'
    end
    object DBNav: TDBNavigator
      Left = 8
      Top = 11
      Width = 148
      Height = 18
      DataSource = DS
      VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
      Hints.Strings = (
        'Первая запись'
        'Предыдущая запись'
        'Следующая запись'
        'Последняя запись')
      TabOrder = 0
    end
    object BtOk: TBitBtn
      Left = 301
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      Default = True
      TabOrder = 1
      NumGlyphs = 2
    end
    object BtClose: TButton
      Left = 384
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Закрыть'
      TabOrder = 2
      OnClick = BtCloseClick
    end
  end
  object PnWorkArea: TPanel
    Left = 0
    Top = 34
    Width = 465
    Height = 252
    Align = alClient
    BevelOuter = bvNone
    BiDiMode = bdLeftToRight
    BorderWidth = 2
    ParentBiDiMode = False
    TabOrder = 2
    object PnSqlBtn: TPanel
      Left = 378
      Top = 2
      Width = 85
      Height = 248
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object PnModify: TPanel
        Left = 0
        Top = 0
        Width = 85
        Height = 105
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object BtInsert: TButton
          Left = 5
          Top = 7
          Width = 75
          Height = 25
          Caption = 'Добавить'
          TabOrder = 0
          OnClick = BtInsertClick
        end
        object BtEdit: TButton
          Left = 5
          Top = 37
          Width = 75
          Height = 25
          Caption = 'Изменить'
          TabOrder = 1
          OnClick = BtEditClick
        end
        object BtDel: TButton
          Left = 5
          Top = 67
          Width = 75
          Height = 25
          Caption = 'Удалить'
          TabOrder = 2
          OnClick = BtDelClick
        end
      end
      object PnOption: TPanel
        Left = 0
        Top = 105
        Width = 85
        Height = 143
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object BtRefresh: TButton
          Left = 5
          Top = 12
          Width = 75
          Height = 25
          Caption = 'Обновить'
          TabOrder = 0
          OnClick = BtRefreshClick
        end
        object BtMore: TButton
          Left = 5
          Top = 42
          Width = 75
          Height = 25
          Caption = 'Подробнее'
          TabOrder = 1
          OnClick = BtMoreClick
        end
        object BtFilter: TBitBtn
          Left = 5
          Top = 73
          Width = 75
          Height = 25
          Caption = 'Фильтр'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = BtFilterClick
        end
        object BtOptions: TButton
          Left = 5
          Top = 103
          Width = 75
          Height = 25
          Caption = 'Настройка'
          TabOrder = 3
          OnClick = BtOptionsClick
        end
      end
    end
    object PnGrid: TPanel
      Left = 2
      Top = 2
      Width = 376
      Height = 248
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
    end
  end
  object DS: TDataSource
    DataSet = RbkQuery
    Left = 128
    Top = 122
  end
  object RbkQuery: TIBQuery
    Transaction = RbkTrans
    BufferChunks = 1000
    CachedUpdates = False
    Left = 176
    Top = 90
  end
  object RbkTrans: TIBTransaction
    Active = False
    DefaultAction = TARollback
    AutoStopAction = saNone
    Left = 256
    Top = 90
  end
end
