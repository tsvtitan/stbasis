object frmRoundType: TfrmRoundType
  Left = 319
  Top = 231
  Width = 527
  Height = 328
  Caption = 'Виды округлений'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnKeyUp = FormKeyUp
  OnPaint = FormPaint
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object PanelTop: TPanel
    Left = 0
    Top = 0
    Width = 519
    Height = 33
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Label1: TLabel
      Left = 9
      Top = 9
      Width = 34
      Height = 13
      Caption = 'Найти:'
    end
    object EditSearch: TEdit
      Left = 50
      Top = 6
      Width = 391
      Height = 21
      TabOrder = 0
      OnKeyUp = EditSearchKeyUp
    end
  end
  object PanelBottom: TPanel
    Left = 0
    Top = 267
    Width = 519
    Height = 34
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 4
    object LabelCount: TLabel
      Left = 185
      Top = 0
      Width = 87
      Height = 34
      Align = alLeft
      Caption = 'Всего записей: 0'
      Enabled = False
      Layout = tlCenter
    end
    object PanelClose: TPanel
      Left = 437
      Top = 0
      Width = 82
      Height = 34
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object ButtonClose: TButton
        Left = 2
        Top = 6
        Width = 75
        Height = 25
        Caption = 'Закрыть'
        TabOrder = 0
        OnClick = ButtonCloseClick
      end
    end
    object PanelOKCancel: TPanel
      Left = 276
      Top = 0
      Width = 161
      Height = 34
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      Visible = False
      object ButtonOK: TButton
        Left = 2
        Top = 6
        Width = 75
        Height = 25
        Caption = 'Выбор'
        Default = True
        ModalResult = 1
        TabOrder = 0
      end
      object ButtonCancel: TButton
        Left = 82
        Top = 6
        Width = 75
        Height = 25
        Cancel = True
        Caption = 'Отмена'
        ModalResult = 2
        TabOrder = 1
      end
    end
    object PanelNavigator: TPanel
      Left = 0
      Top = 0
      Width = 185
      Height = 34
      Align = alLeft
      BevelOuter = bvNone
      BorderWidth = 8
      TabOrder = 2
      object DBNavigator: TDBNavigator
        Left = 8
        Top = 8
        Width = 169
        Height = 18
        DataSource = dsRoundTypeSelect
        VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
        Align = alClient
        TabOrder = 0
      end
    end
  end
  object PanelRight: TPanel
    Left = 429
    Top = 33
    Width = 90
    Height = 234
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 2
    object ButtonAdd: TButton
      Left = 8
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Добавить'
      TabOrder = 0
      OnClick = ButtonAddClick
    end
    object ButtonEdit: TButton
      Left = 8
      Top = 40
      Width = 75
      Height = 25
      Caption = 'Изменить'
      TabOrder = 1
      OnClick = ButtonEditClick
    end
    object ButtonDelete: TButton
      Left = 8
      Top = 72
      Width = 75
      Height = 25
      Caption = 'Удалить'
      TabOrder = 2
      OnClick = ButtonDeleteClick
    end
    object ButtonEditRefresh: TButton
      Left = 8
      Top = 112
      Width = 75
      Height = 25
      Caption = 'Обновить'
      TabOrder = 3
      OnClick = ButtonEditRefreshClick
    end
    object ButtonSetup: TButton
      Left = 8
      Top = 144
      Width = 75
      Height = 25
      Caption = 'Настройка'
      TabOrder = 4
      OnClick = ButtonSetupClick
    end
  end
  object GridRoundType: TRxDBGrid
    Left = 0
    Top = 33
    Width = 339
    Height = 234
    Align = alClient
    DataSource = dsRoundTypeSelect
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgAlwaysShowSelection]
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDblClick = ButtonEditClick
    OnEnter = GridRoundTypeEnter
    OnExit = GridRoundTypeExit
    TitleButtons = True
    OnGetCellParams = GridRoundTypeGetCellParams
    Columns = <
      item
        Expanded = False
        FieldName = 'NAME'
        Title.Caption = 'Наименование'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'factor'
        Title.Caption = 'Фактор'
        Visible = True
      end>
  end
  object PanelSelecting: TPanel
    Left = 339
    Top = 33
    Width = 90
    Height = 234
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 3
    Visible = False
    object ButtonSetup2: TButton
      Left = 8
      Top = 40
      Width = 75
      Height = 25
      Caption = 'Настройка'
      TabOrder = 1
      OnClick = ButtonSetupClick
    end
    object ButtonRefresh: TButton
      Left = 8
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Обновить'
      TabOrder = 0
      OnClick = ButtonEditRefreshClick
    end
  end
  object quRoundTypeSelect: TIBQuery
    Tag = 1
    Transaction = trRead
    AfterScroll = quRoundTypeSelectAfterScroll
    BufferChunks = 100
    CachedUpdates = False
    Left = 104
    Top = 64
  end
  object trRead: TIBTransaction
    Active = False
    DefaultAction = TARollback
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    AutoStopAction = saNone
    Left = 248
    Top = 64
  end
  object dsRoundTypeSelect: TDataSource
    DataSet = quRoundTypeSelect
    Left = 176
    Top = 64
  end
end
