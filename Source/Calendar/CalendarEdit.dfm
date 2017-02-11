object frmCalendar: TfrmCalendar
  Left = 338
  Top = 163
  Width = 600
  Height = 503
  Caption = 'Календари'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010002002020080000000000E80200002600000010100800000000002801
    00000E0300002800000020000000400000000100040000000000800200000000
    0000000000000000000000000000000000000000800000800000008080008000
    0000800080008080000080808000C0C0C0000000FF0000FF000000FFFF00FF00
    0000FF00FF00FFFF0000FFFFFF00000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000007
    77777777777777777777777700000007FFF8FFF8FFF8FFF88888888800000007
    FFF8FFF8FFF8FFF88888888800000007FFF8FFF8FFF8FFF88888888800000007
    88888888888888888888888800000007FFF8FFF8FFF8FFF8FFF8FFF800000007
    FFF8FFF8FFF8FFF8FFF8FFF800000007FFF8FFF8FFF8FFF8FFF8FFF800000007
    88888888888888888888888800000007FFF8FFF8FFF8FFF8FFF8FFF800000007
    FFF8FFF8FFF8FFF8FFF8FFF800000007FFF8FFF8FFF8FFF8FFF8FFF800000007
    88888888888888881118888800000007FFF8FFF8FFF8FFF18F81FFF800000007
    FFF8FFF8FFF8FFF1FFF1FFF800000007FFF8FFF8FFF8FFF18F81FFF800000007
    88888888888888881118888800000007888888888888FFF8FFF8FFF800000007
    888888888888FFF8FFF8FFF800000007888888888888FFF8FFF8FFF800000007
    7777777777777777777777770000000744444444444477777777777700000007
    4444444444447777777777770000000777777777777777777777777700000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE000
    0007E0000007E0000007E0000007E0000007E0000007E0000007E0000007E000
    0007E0000007E0000007E0000007E0000007E0000007E0000007E0000007E000
    0007E0000007E0000007E0000007E0000007E0000007E0000007E0000007E000
    0007FFFFFFFFFFFFFFFFFFFFFFFF280000001000000020000000010004000000
    0000C00000000000000000000000000000000000000000000000000080000080
    000000808000800000008000800080800000C0C0C000808080000000FF0000FF
    000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000000000000000
    0000000000008FF7FF7FF7FF7FF08FF7FF7FF7FF7FF087777777777777708FF7
    FF7FF7FF7FF08FF7FF7FF7FF7FF087777777711117708FF7FF7FF1FF1FF08FF7
    FF7FF1FF1FF087777777711117708FF7FF7FF7FF7FF08FF7FF7FF7FF7FF08444
    44448888888084444444888888808888888888888880FFFF0000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    00000000000000000000000000000000000000000000}
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
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter: TSplitter
    Left = 133
    Top = 33
    Width = 4
    Height = 409
    Cursor = crSizeWE
    ResizeStyle = rsUpdate
  end
  object PanelTop: TPanel
    Left = 0
    Top = 0
    Width = 592
    Height = 33
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object btnCalNew: TButton
      Left = 4
      Top = 4
      Width = 75
      Height = 25
      Caption = 'Создать'
      TabOrder = 0
      OnClick = btnCalNewClick
    end
    object btnCalDelete: TButton
      Left = 84
      Top = 4
      Width = 75
      Height = 25
      Caption = 'Удалить'
      TabOrder = 1
      OnClick = btnCalDeleteClick
    end
    object ButtonRefresh: TButton
      Left = 164
      Top = 4
      Width = 75
      Height = 25
      Caption = 'Обновить'
      TabOrder = 2
      OnClick = ButtonRefreshClick
    end
  end
  object PageControl: TPageControl
    Left = 137
    Top = 33
    Width = 375
    Height = 409
    ActivePage = TabSheet2
    Align = alClient
    TabOrder = 2
    object TabSheet2: TTabSheet
      Caption = 'Праздники'
      ImageIndex = 1
      object PanelHolidayEdit: TPanel
        Left = 286
        Top = 0
        Width = 81
        Height = 381
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 0
        object ButtonHolidayAdd: TButton
          Left = 4
          Top = 4
          Width = 75
          Height = 25
          Caption = 'Добавить'
          TabOrder = 0
          OnClick = ButtonHolidayAddClick
        end
        object ButtonHolidayDelete: TButton
          Left = 4
          Top = 68
          Width = 75
          Height = 25
          Caption = 'Удалить'
          TabOrder = 2
          OnClick = ButtonHolidayDeleteClick
        end
        object ButtonHolidayEdit: TButton
          Left = 4
          Top = 36
          Width = 75
          Height = 25
          Caption = 'Изменить'
          TabOrder = 1
          OnClick = ButtonHolidayEditClick
        end
        object btnHolidayGridColsSet: TButton
          Tag = 1
          Left = 4
          Top = 112
          Width = 75
          Height = 25
          Caption = 'Настройка'
          TabOrder = 3
          OnClick = btnWeekGridColsSetClick
        end
        object ButtonRefreshHoliday: TButton
          Left = 4
          Top = 144
          Width = 75
          Height = 25
          Caption = 'Обновить'
          TabOrder = 4
          OnClick = ButtonRefreshClick
        end
      end
      object GridHoliday: TRxDBGrid
        Left = 0
        Top = 0
        Width = 286
        Height = 381
        Align = alClient
        DataSource = dsHolidaySelect
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgAlwaysShowSelection]
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        OnDblClick = ButtonHolidayEditClick
        OnEnter = CommonGridEnter
        OnExit = CommonGridExit
        TitleButtons = True
        OnGetCellParams = CommonGetCellParams
        Columns = <
          item
            Expanded = False
            FieldName = 'holiday'
            Title.Caption = 'Дата'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'name'
            Title.Caption = 'Наименование'
            Visible = True
          end>
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Переносы выходных'
      ImageIndex = 2
      object PanelCarryEdit: TPanel
        Left = 286
        Top = 0
        Width = 81
        Height = 381
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 0
        object ButtonCarryAdd: TButton
          Left = 4
          Top = 4
          Width = 75
          Height = 25
          Caption = 'Добавить'
          TabOrder = 0
          OnClick = ButtonCarryAddClick
        end
        object ButtonCarryDelete: TButton
          Left = 4
          Top = 68
          Width = 75
          Height = 25
          Caption = 'Удалить'
          TabOrder = 2
          OnClick = ButtonCarryDeleteClick
        end
        object ButtonCarryEdit: TButton
          Left = 4
          Top = 36
          Width = 75
          Height = 25
          Caption = 'Изменить'
          TabOrder = 1
          OnClick = ButtonCarryEditClick
        end
        object btnCarryGridColsSet: TButton
          Tag = 2
          Left = 4
          Top = 112
          Width = 75
          Height = 25
          Caption = 'Настройка'
          TabOrder = 3
          OnClick = btnWeekGridColsSetClick
        end
        object ButtonRefreshCarry: TButton
          Left = 4
          Top = 144
          Width = 75
          Height = 25
          Caption = 'Обновить'
          TabOrder = 4
          OnClick = ButtonRefreshClick
        end
      end
      object GridCarry: TRxDBGrid
        Left = 0
        Top = 0
        Width = 286
        Height = 381
        Align = alClient
        DataSource = dsCarrySelect
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgAlwaysShowSelection]
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        OnDblClick = ButtonCarryEditClick
        OnEnter = CommonGridEnter
        OnExit = CommonGridExit
        TitleButtons = True
        OnGetCellParams = CommonGetCellParams
        Columns = <
          item
            Expanded = False
            FieldName = 'fromdate'
            Title.Caption = 'Из даты'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'todate'
            Title.Caption = 'В дату'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'description'
            Title.Caption = 'Описание'
            Visible = True
          end>
      end
    end
  end
  object GridCalendar: TRxDBGrid
    Left = 0
    Top = 33
    Width = 133
    Height = 409
    Align = alLeft
    DataSource = dsCalendarSelect
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgAlwaysShowSelection]
    ReadOnly = True
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDblClick = GridCalendarDblClick
    OnEnter = CommonGridEnter
    OnExit = CommonGridExit
    TitleButtons = True
    OnCheckButton = GridCalendarCheckButton
    OnGetCellParams = CommonGetCellParams
    OnGetBtnParams = GridCalendarGetBtnParams
    OnTitleBtnClick = GridCalendarTitleBtnClick
    Columns = <
      item
        Expanded = False
        FieldName = 'startdate'
        Title.Caption = 'Дата вступления в силу'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'HolidaysAddPayPercent'
        Title.Caption = '% доплаты за праздники'
        Visible = True
      end>
  end
  object PanelBottom: TPanel
    Left = 0
    Top = 442
    Width = 592
    Height = 34
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
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
      Left = 511
      Top = 0
      Width = 81
      Height = 34
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      object btnClose: TButton
        Left = 4
        Top = 6
        Width = 75
        Height = 25
        Caption = 'Закрыть'
        TabOrder = 0
        OnClick = btnCloseClick
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
    object PanelOKCancel: TPanel
      Left = 346
      Top = 0
      Width = 165
      Height = 34
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 2
      Visible = False
      object ButtonOK: TButton
        Left = 8
        Top = 6
        Width = 75
        Height = 25
        Caption = 'Выбрать'
        Default = True
        ModalResult = 1
        TabOrder = 0
      end
      object ButtonCancel: TButton
        Left = 88
        Top = 6
        Width = 75
        Height = 25
        Cancel = True
        Caption = 'Отмена'
        ModalResult = 2
        TabOrder = 1
      end
    end
  end
  object PanelSelecting: TPanel
    Left = 512
    Top = 33
    Width = 80
    Height = 409
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 4
    object ButtonRefreshSel: TButton
      Left = 3
      Top = 28
      Width = 75
      Height = 25
      Caption = 'Обновить'
      TabOrder = 0
      OnClick = ButtonRefreshClick
    end
    object btnGridColsSet: TButton
      Left = 3
      Top = 60
      Width = 75
      Height = 25
      Caption = 'Настройка'
      TabOrder = 1
      OnClick = btnWeekGridColsSetClick
    end
  end
  object quCalendarSelect: TIBQuery
    Tag = 1
    Transaction = trRead
    AfterScroll = CommonAfterScroll
    BufferChunks = 1000
    CachedUpdates = False
    SQL.Strings = (
      'select calendar_id,startdate from calendar')
    Left = 64
    Top = 96
    object quCalendarSelectcalendar_id: TIntegerField
      FieldName = 'calendar_id'
    end
    object quCalendarSelectstartdate: TDateField
      FieldName = 'startdate'
      DisplayFormat = 'dd mmmm yyyyг.'
    end
    object quCalendarSelectHolidaysAddPayPercent: TIntegerField
      FieldName = 'HolidaysAddPayPercent'
    end
  end
  object dsCalendarSelect: TDataSource
    DataSet = quCalendarSelect
    Left = 148
    Top = 96
  end
  object trRead: TIBTransaction
    Active = False
    DefaultAction = TARollback
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    AutoStopAction = saNone
    Left = 357
    Top = 1
  end
  object quCalendarDelete: TIBQuery
    Transaction = trWrite
    BufferChunks = 1000
    CachedUpdates = False
    SQL.Strings = (
      'delete from calendar where calendar_id=:id')
    Left = 64
    Top = 212
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'id'
        ParamType = ptUnknown
      end>
  end
  object trWrite: TIBTransaction
    Active = False
    DefaultAction = TARollback
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    AutoStopAction = saNone
    Left = 409
    Top = 1
  end
  object quHolidaySelect: TIBQuery
    Tag = 2
    Transaction = trRead
    AfterScroll = CommonAfterScroll
    BufferChunks = 1000
    CachedUpdates = False
    DataSource = dsCalendarSelect
    SQL.Strings = (
      'select * from holiday where calendar_id=:calendar_id')
    Left = 229
    Top = 97
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'calendar_id'
        ParamType = ptUnknown
      end>
    object quHolidaySelectholiday_id: TIntegerField
      FieldName = 'holiday_id'
    end
    object quHolidaySelectholiday: TDateField
      FieldName = 'holiday'
      DisplayFormat = 'dd mmmm'
    end
    object quHolidaySelectname: TStringField
      FieldName = 'name'
      Size = 30
    end
  end
  object dsHolidaySelect: TDataSource
    DataSet = quHolidaySelect
    Left = 317
    Top = 97
  end
  object dsCarrySelect: TDataSource
    DataSet = quCarrySelect
    Left = 333
    Top = 153
  end
  object quCarrySelect: TIBQuery
    Tag = 3
    Transaction = trRead
    AfterScroll = CommonAfterScroll
    BufferChunks = 1000
    CachedUpdates = False
    DataSource = dsCalendarSelect
    SQL.Strings = (
      'select * from carry where calendar_id=:calendar_id')
    Left = 229
    Top = 153
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'calendar_id'
        ParamType = ptUnknown
      end>
  end
end
