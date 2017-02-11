object frmSeatClass: TfrmSeatClass
  Left = 357
  Top = 224
  Width = 488
  Height = 342
  Caption = 'Штатное расписание'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnKeyUp = FormKeyUp
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 121
    Top = 41
    Width = 3
    Height = 240
    Cursor = crHSplit
  end
  object TreeDepart: TDBTreeView
    Left = 0
    Top = 41
    Width = 121
    Height = 240
    ShowNodeHint = True
    DataSource = dsDepart
    KeyField = 'depart_id'
    ListField = 'name'
    ParentField = 'parent_id'
    SeparatedSt = ' - '
    ReadOnly = True
    HideSelection = False
    Indent = 19
    Align = alLeft
    ParentColor = False
    Options = [trDBCanDelete, trDBConfirmDelete, trCanDBNavigate, trSmartRecordCopy, trCheckHasChildren]
    SelectedIndex = -1
    TabOrder = 1
    OnEnter = GridSeatClassEnter
    OnExit = GridSeatClassExit
  end
  object PanelBottom: TPanel
    Left = 0
    Top = 281
    Width = 480
    Height = 34
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
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
      Left = 390
      Top = 0
      Width = 90
      Height = 34
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      object ButtonClose: TButton
        Left = 8
        Top = 4
        Width = 75
        Height = 25
        Caption = 'Закрыть'
        TabOrder = 0
        OnClick = ButtonCloseClick
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
      TabOrder = 0
      object DBNavigator: TDBNavigator
        Left = 8
        Top = 8
        Width = 169
        Height = 18
        VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
        Align = alClient
        TabOrder = 0
      end
    end
  end
  object PanelTop: TPanel
    Left = 0
    Top = 0
    Width = 480
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 11
      Width = 34
      Height = 13
      Caption = 'Найти:'
    end
    object EditSearch: TEdit
      Left = 48
      Top = 8
      Width = 121
      Height = 21
      TabOrder = 0
      OnKeyUp = EditSearchKeyUp
    end
  end
  object PanelRight: TPanel
    Left = 391
    Top = 41
    Width = 89
    Height = 240
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 3
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
    object ButtonRefresh: TButton
      Left = 8
      Top = 112
      Width = 75
      Height = 25
      Caption = 'Обновить'
      TabOrder = 3
      OnClick = ButtonRefreshClick
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
  object GridSeatClass: TRxDBGrid
    Left = 124
    Top = 41
    Width = 267
    Height = 240
    Align = alClient
    DataSource = dsSeatClassSelect
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgAlwaysShowSelection]
    TabOrder = 4
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDblClick = ButtonEditClick
    OnEnter = GridSeatClassEnter
    OnExit = GridSeatClassExit
    IniStorage = FormStorage
    TitleButtons = True
    OnGetCellParams = GridSeatClassGetCellParams
  end
  object quDepartSelect: TIBQuery
    Transaction = trRead
    AfterScroll = CommontAfterScroll
    BufferChunks = 1000
    CachedUpdates = False
    SQL.Strings = (
      'select depart_id,parent_id,name from depart')
    Left = 24
    Top = 96
  end
  object dsDepart: TDataSource
    DataSet = quDepartSelect
    Left = 96
    Top = 96
  end
  object trRead: TIBTransaction
    Active = False
    DefaultAction = TARollback
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    Left = 256
    Top = 8
  end
  object trWrite: TIBTransaction
    Active = False
    DefaultAction = TARollback
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    Left = 336
    Top = 8
  end
  object quSeatClassSelect: TIBQuery
    Transaction = trRead
    AfterScroll = CommontAfterScroll
    BufferChunks = 1000
    CachedUpdates = False
    DataSource = dsDepart
    SQL.Strings = (
      
        'select sc.*,s.name as seatname,c.num as classname,d.num as docum' +
        'name from seatclass sc '
      'left join seat s on s.seat_id=sc.seat_id '
      'left join class c on c.class_id=sc.class_id '
      'left join docum d on d.docum_id=sc.docum_id '
      'where depart_id=:depart_id')
    Left = 176
    Top = 128
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'depart_id'
        ParamType = ptUnknown
      end>
  end
  object dsSeatClassSelect: TDataSource
    DataSet = quSeatClassSelect
    Left = 272
    Top = 128
  end
  object FormStorage: TFormStorage
    Active = False
    StoredValues = <
      item
        Name = 'LastDepart'
      end
      item
        Name = 'LastSeatClass'
      end>
    Left = 200
    Top = 64
  end
end
