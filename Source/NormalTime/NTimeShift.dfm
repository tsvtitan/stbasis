object frmShift: TfrmShift
  Left = 413
  Top = 208
  Width = 453
  Height = 293
  Caption = 'Смены'
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
    0000FF00FF00FFFF0000FFFFFF00000000000000077777770000000000000000
    0000007700000007777000000000000000007000000000000077700000000000
    00000000000FBFB00000770000000000000000000BFBFBFBFB00077000000000
    00000000BFBFBFBFBFB00077000000000000000BFBFBFBFBFBFBF00770000000
    000000BFBFBFBFBFBFBFBF007700000000000BFBFBFBFBFBFBFBFB0007000000
    00000FBFBFBFBFBFBFBFBFB0077000000000FBFBFBFBFBFBFBFBFBFB00700000
    0000BFBFBFBFBFBFBFBFBFBF007000000000FBFBFBFBFBFBFBFBFBFB00770000
    000FBFBFBFBFBFBFBFBFBFBFB0070000000BFBFBFBFBFBFBFBFBFBFBF0070000
    000FBFBFBFBFBFBFBFBFBFBFB0070000000BFBFBFBFBFBFBFBFBFBFBF0070000
    000FBFBFBFBFBFBFBFBFBFBFB0070000000BFBFBFBFBFBFBFBFBFBFBF0070000
    000FBFBFBFBFBFBFBFBFBFBFB00000000000FBFBFBFBFBFBFBFBFBFB00700000
    0000BFBFBFBFBFBFBFBFBFBF007000000000FBFBFBFBFBFBFBFBFBFB00000000
    00000FBFBFBFBFBFBFBFBFB00700000000000BFBFBFBFBFBFBFBFB0000000000
    000000BFBFBFBFBFBFBFBF00000000000000000BFBFBFBFBFBFBF00000000000
    00000000BFBFBFBFBFB0000000000000000000000BFBFBFBFB00000000000000
    00000000000FBFB0000000000000000000000000000000000000000000000000
    0000000000000000000000000000FFF80FFFFFC001FFFF00007FFE00003FFC00
    001FF800000FF0000007E0000003C0000003C000000180000001800000018000
    0000000000000000000000000000000000000000000000000000000000018000
    00018000000180000003C0000003C0000007E000000FF000001FF800003FFC00
    007FFE0000FFFF8003FFFFF01FFF280000001000000020000000010004000000
    0000C00000000000000000000000000000000000000000000000000080000080
    00000080800080000000800080008080000080808000C0C0C0000000FF0000FF
    000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000000000000000
    0000BF0000000000000BFBFB0000000000BFBFBFB00000000BFBFBFBFB000000
    0FBFBFBFBF000000FBFBFBFBFBF00000BFBFBFBFBFB00000FBFBFBFBFBF00000
    BFBFBFBFBFB00000FBFBFBFBFB0000000FBFBFBFBF0000000BFBFBFBF0000000
    00BFBFBF000000000000FB0000000000000000000000F81F0000E0070000C003
    0000800100008001000000000000000000000000000000000000000000000000
    00008001000080010000C0030000E0070000F81F0000}
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
    Width = 445
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
    Top = 232
    Width = 445
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
      Left = 363
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
      Left = 202
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
        DataSource = dsShiftSelect
        VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
        Align = alClient
        TabOrder = 0
      end
    end
  end
  object PanelRight: TPanel
    Left = 355
    Top = 33
    Width = 90
    Height = 199
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
  object GridShift: TRxDBGrid
    Left = 0
    Top = 33
    Width = 265
    Height = 199
    Align = alClient
    DataSource = dsShiftSelect
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgAlwaysShowSelection]
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDblClick = ButtonEditClick
    OnEnter = GridShiftEnter
    OnExit = GridShiftExit
    TitleButtons = True
    OnGetCellParams = GridShiftGetCellParams
    Columns = <
      item
        Expanded = False
        FieldName = 'NAME'
        Title.Caption = 'Наименование'
        Width = 86
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'AddPayPercent'
        Title.Caption = 'Процент доплаты'
        Width = 99
        Visible = True
      end>
  end
  object PanelSelecting: TPanel
    Left = 265
    Top = 33
    Width = 90
    Height = 199
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
  object quShiftSelect: TIBQuery
    Tag = 1
    Transaction = trRead
    AfterScroll = quShiftSelectAfterScroll
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
    AutoStopAction = saRollback
    Left = 248
    Top = 64
  end
  object dsShiftSelect: TDataSource
    DataSet = quShiftSelect
    Left = 176
    Top = 64
  end
end
