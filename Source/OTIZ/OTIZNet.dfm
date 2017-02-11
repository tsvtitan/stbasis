object frmNet: TfrmNet
  Left = 319
  Top = 231
  Width = 538
  Height = 315
  Caption = 'Сетки'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000004700004000000000740000744000004444444407400004477740000074
    4044700040000077744700004000006674770004444400644440004774000064
    0044447004000044000446000744444000466400047007447047044740400047
    444000740077004007447047400400400047444074040040004007470740FFCF
    00007FCF00001F0000009E070000C4770000C0F70000C0E00000C1C30000CC1B
    0000CE3800001C39000084850000C1CC0000D8460000DC120000DD890000}
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
    Width = 530
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
    Top = 254
    Width = 530
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
      Left = 448
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
      Left = 287
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
        DataSource = dsNetSelect
        VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
        Align = alClient
        TabOrder = 0
      end
    end
  end
  object PanelRight: TPanel
    Left = 440
    Top = 33
    Width = 90
    Height = 221
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
  object GridNet: TRxDBGrid
    Left = 0
    Top = 33
    Width = 350
    Height = 221
    Align = alClient
    DataSource = dsNetSelect
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgAlwaysShowSelection]
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDblClick = ButtonEditClick
    OnEnter = GridNetEnter
    OnExit = GridNetExit
    TitleButtons = True
    OnGetCellParams = GridNetGetCellParams
    Columns = <
      item
        Expanded = False
        FieldName = 'NAME'
        Title.Caption = 'Наименование'
        Visible = True
      end>
  end
  object PanelSelecting: TPanel
    Left = 350
    Top = 33
    Width = 90
    Height = 221
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
  object quNetSelect: TIBQuery
    Tag = 1
    Transaction = trRead
    AfterScroll = quNetSelectAfterScroll
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
  object dsNetSelect: TDataSource
    DataSet = quNetSelect
    Left = 176
    Top = 64
  end
end
