object frmClass: TfrmClass
  Left = 419
  Top = 230
  Width = 538
  Height = 315
  Caption = 'Разряды'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010002002020100000000000E80200002600000010101000000000002801
    00000E0300002800000020000000400000000100040000000000800200000000
    0000000000000000000000000000000000000000800000800000008080008000
    0000800080008080000080808000C0C0C0000000FF0000FF000000FFFF00FF00
    0000FF00FF00FFFF0000FFFFFF00000000000000000000000000000000000000
    0000000000000000000000000000000300000000000000000000000000000000
    30000000000000000000000000000000B3000000000000000000000000000000
    0B3000000000000000000000000000000BB30000000000000000000000000000
    00BB300000000000000000000000000000BBB300000000000000000000000000
    000BBB30000000000000000000000000000BBBB3000000000000000000000000
    0000BBBB3000000000000000000000000000BBBBB30000000000000000000000
    00000BBBBB300000000000000000000000000BBBBBB300000000000000000000
    000BBBBBBBBB300000000000000000000000BBBBBB3333000000000000000000
    0000BBBBBB300000000000000000000000000BBBBBB300000000000000000000
    00000BBBBBBB30000000000000000000000000BBBBBBB3000000000000000000
    000000BBBBBBBB3000000000000000000000000BBBBBBBB30000000000000000
    0000000BBBBBBBBB300000000000000000000000BBBBBBBBB300000000000000
    00000000BBBBBBBBBB30000000000000000000000BBBBBBBBBB3000000000000
    000000000BBBBBBBBBBB3000000000000000000000BBBBBBBBBBB30000000000
    0000000000BBBBBBBBBBBB300000000000000000000BBBBBBBBBBBB300000000
    0000000000000000000000000000FFFFFFFFCFFFFFFFC7FFFFFFE3FFFFFFE1FF
    FFFFF0FFFFFFF07FFFFFF83FFFFFF81FFFFFFC0FFFFFFC07FFFFFE03FFFFFE01
    FFFFFF00FFFFFC007FFFFC003FFFFE001FFFFE000FFFFF007FFFFF003FFFFF80
    1FFFFF800FFFFFC007FFFFC003FFFFE001FFFFE000FFFFF0007FFFF0003FFFF8
    001FFFF8000FFFFC0007FFFC0003280000001000000020000000010004000000
    0000C00000000000000000000000000000000000000000000000000080000080
    00000080800080000000800080008080000080808000C0C0C0000000FF0000FF
    000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000000000000000
    00000000000000300000000000000003000000000000000B3000000000000000
    B300000000000000BB30000000000000BBB3000000000000BBB0000000000000
    0BB30000000000000BBB30000000000000BBB3000000000000BBBB3000000000
    000BBBB300000000000BBBBB30000000000000000000BFFF00009FFF00008FFF
    0000C7FF0000C3FF0000E1FF0000C0FF0000E07F0000E03F0000F07F0000F03F
    0000F81F0000F80F0000FC070000FC030000FE010000}
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
        DataSource = dsClassSelect
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
  object GridClass: TRxDBGrid
    Left = 0
    Top = 33
    Width = 350
    Height = 221
    Align = alClient
    DataSource = dsClassSelect
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgAlwaysShowSelection]
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDblClick = ButtonEditClick
    OnEnter = GridClassEnter
    OnExit = GridClassExit
    IniStorage = FormStorage
    TitleButtons = True
    OnGetCellParams = GridClassGetCellParams
    Columns = <
      item
        Expanded = False
        FieldName = 'NUM'
        Title.Caption = 'Номер разряда'
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
  object FormStorage: TFormStorage
    Active = False
    MinMaxInfo.MinTrackHeight = 300
    MinMaxInfo.MinTrackWidth = 480
    StoredValues = <
      item
        Name = 'LastClass'
        Value = ''
      end>
    Left = 160
    Top = 120
  end
  object quClassSelect: TIBQuery
    Tag = 1
    Transaction = trRead
    AfterScroll = quClassSelectAfterScroll
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
  object dsClassSelect: TDataSource
    DataSet = quClassSelect
    Left = 176
    Top = 64
  end
end
