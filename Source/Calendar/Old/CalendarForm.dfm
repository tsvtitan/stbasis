object frmCalendar: TfrmCalendar
  Left = 339
  Top = 201
  Width = 496
  Height = 326
  Caption = 'Календари'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnKeyUp = FormKeyUp
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter: TSplitter
    Left = 133
    Top = 33
    Width = 4
    Height = 232
    Cursor = crSizeWE
    ResizeStyle = rsUpdate
  end
  object PanelTop: TPanel
    Left = 0
    Top = 0
    Width = 488
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
    object btnRefresh: TButton
      Left = 164
      Top = 4
      Width = 75
      Height = 25
      Caption = 'Обновить'
      TabOrder = 2
      OnClick = btnRefreshClick
    end
  end
  object PageControl: TPageControl
    Left = 137
    Top = 33
    Width = 351
    Height = 232
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = 'Недели'
      object PanelWeek: TPanel
        Left = 262
        Top = 0
        Width = 81
        Height = 204
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 1
        object ButtonWeekAdd: TButton
          Left = 4
          Top = 4
          Width = 75
          Height = 25
          Caption = 'Добавить'
          TabOrder = 0
          OnClick = ButtonWeekAddClick
        end
        object ButtonWeekDelete: TButton
          Left = 4
          Top = 36
          Width = 75
          Height = 25
          Caption = 'Удалить'
          TabOrder = 1
          OnClick = ButtonWeekDeleteClick
        end
        object ButtonWeekEdit: TButton
          Left = 4
          Top = 68
          Width = 75
          Height = 25
          Caption = 'Изменить'
          TabOrder = 2
          OnClick = ButtonWeekEditClick
        end
      end
      object GridWeek: TRxDBGrid
        Left = 0
        Top = 0
        Width = 262
        Height = 204
        Align = alClient
        DataSource = dsWeekSelect
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgRowSelect, dgAlwaysShowSelection]
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        OnEnter = CommonGridEnter
        OnExit = CommonGridExit
        IniStorage = FormStorage
        TitleButtons = True
        Columns = <
          item
            Expanded = False
            FieldName = 'Name'
            Title.Caption = 'Имя'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'd1'
            Title.Caption = 'Понед.'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'd2'
            Title.Caption = 'Вторн.'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'd3'
            Title.Caption = 'Среда'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'd4'
            Title.Caption = 'Четв.'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'd5'
            Title.Caption = 'Пятн.'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'd6'
            Title.Caption = 'Суббота'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'd7'
            Title.Caption = 'Воскр.'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'beforeholiday'
            Title.Caption = 'Предпразд.'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'avgyear'
            Title.Caption = 'Среднемесячное по году'
            Visible = True
          end>
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Праздники'
      ImageIndex = 1
      object Panel3: TPanel
        Left = 262
        Top = 0
        Width = 81
        Height = 204
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
          Top = 36
          Width = 75
          Height = 25
          Caption = 'Удалить'
          TabOrder = 1
          OnClick = ButtonHolidayDeleteClick
        end
        object ButtonHolidayEdit: TButton
          Left = 4
          Top = 68
          Width = 75
          Height = 25
          Caption = 'Изменить'
          TabOrder = 2
          OnClick = ButtonHolidayEditClick
        end
      end
      object GridHoliday: TRxDBGrid
        Left = 0
        Top = 0
        Width = 262
        Height = 204
        Align = alClient
        DataSource = dsHolidaySelect
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgRowSelect, dgAlwaysShowSelection]
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        OnEnter = CommonGridEnter
        OnExit = CommonGridExit
        IniStorage = FormStorage
        TitleButtons = True
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
      Caption = 'Переносы'
      ImageIndex = 2
      object Panel4: TPanel
        Left = 262
        Top = 0
        Width = 81
        Height = 204
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
          Top = 36
          Width = 75
          Height = 25
          Caption = 'Удалить'
          TabOrder = 1
          OnClick = ButtonCarryDeleteClick
        end
        object ButtonCarryEdit: TButton
          Left = 4
          Top = 68
          Width = 75
          Height = 25
          Caption = 'Изменить'
          TabOrder = 2
          OnClick = ButtonCarryEditClick
        end
      end
      object GridCarry: TRxDBGrid
        Left = 0
        Top = 0
        Width = 262
        Height = 204
        Align = alClient
        DataSource = dsCarrySelect
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgRowSelect, dgAlwaysShowSelection]
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        OnEnter = CommonGridEnter
        OnExit = CommonGridExit
        IniStorage = FormStorage
        TitleButtons = True
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
    object TabSheet4: TTabSheet
      Caption = 'Исключения'
      ImageIndex = 3
      object Panel5: TPanel
        Left = 262
        Top = 105
        Width = 81
        Height = 99
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 0
        object ButtonExceptAdd: TButton
          Left = 4
          Top = 4
          Width = 75
          Height = 25
          Caption = 'Добавить'
          TabOrder = 0
          OnClick = ButtonExceptAddClick
        end
        object ButtonExceptDelete: TButton
          Left = 4
          Top = 36
          Width = 75
          Height = 25
          Caption = 'Удалить'
          TabOrder = 1
          OnClick = ButtonExceptDeleteClick
        end
        object ButtonExceptEdit: TButton
          Left = 4
          Top = 68
          Width = 75
          Height = 25
          Caption = 'Изменить'
          TabOrder = 2
          OnClick = ButtonExceptEditClick
        end
      end
      object Panel6: TPanel
        Left = 0
        Top = 0
        Width = 343
        Height = 105
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object GroupBox1: TGroupBox
          Left = 4
          Top = 4
          Width = 337
          Height = 93
          Caption = 'Информация'
          TabOrder = 0
          object Label1: TLabel
            Left = 12
            Top = 16
            Width = 77
            Height = 13
            Caption = 'Годовая норма'
          end
          object Label2: TLabel
            Left = 12
            Top = 40
            Width = 148
            Height = 13
            Caption = 'Расчётная норма по графику'
          end
          object Label3: TLabel
            Left = 12
            Top = 64
            Width = 146
            Height = 13
            Caption = 'Образующаяся переработка'
          end
          object Label4: TLabel
            Left = 308
            Top = 20
            Width = 20
            Height = 13
            Caption = 'час.'
          end
          object Label5: TLabel
            Left = 308
            Top = 44
            Width = 20
            Height = 13
            Caption = 'час.'
          end
          object Label6: TLabel
            Left = 308
            Top = 68
            Width = 20
            Height = 13
            Caption = 'час.'
          end
          object Edit1: TEdit
            Left = 184
            Top = 16
            Width = 121
            Height = 21
            Color = clBtnFace
            TabOrder = 0
            Text = '0'
          end
          object Edit2: TEdit
            Left = 184
            Top = 40
            Width = 121
            Height = 21
            Color = clBtnFace
            TabOrder = 1
            Text = '0'
          end
          object Edit3: TEdit
            Left = 184
            Top = 64
            Width = 121
            Height = 21
            Color = clBtnFace
            TabOrder = 2
            Text = '0'
          end
        end
      end
      object GridExcept: TRxDBGrid
        Left = 0
        Top = 105
        Width = 262
        Height = 99
        Align = alClient
        DataSource = dsExceptSelect
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgRowSelect, dgAlwaysShowSelection]
        TabOrder = 2
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        OnEnter = CommonGridEnter
        OnExit = CommonGridExit
        IniStorage = FormStorage
        TitleButtons = True
        Columns = <
          item
            Expanded = False
            FieldName = 'dateexcept'
            Title.Caption = 'Дата'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'timecount'
            Title.Caption = 'Рабочих часов'
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
  object GridYear: TRxDBGrid
    Left = 0
    Top = 33
    Width = 133
    Height = 232
    Align = alLeft
    DataSource = dsYearSelect
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgRowSelect, dgAlwaysShowSelection]
    ReadOnly = True
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnEnter = CommonGridEnter
    OnExit = CommonGridExit
    IniStorage = FormStorage
    TitleButtons = True
    OnCheckButton = GridYearCheckButton
    OnGetBtnParams = GridYearGetBtnParams
    OnTitleBtnClick = GridYearTitleBtnClick
    Columns = <
      item
        Expanded = False
        FieldName = 'FYEAR'
        Title.Caption = 'Дата вступления в силу'
        Visible = True
      end>
  end
  object PanelBottom: TPanel
    Left = 0
    Top = 265
    Width = 488
    Height = 34
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    object PanelClose: TPanel
      Left = 408
      Top = 0
      Width = 80
      Height = 34
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      object btnClose: TButton
        Left = 4
        Top = 4
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
  end
  object quYearSelect: TIBQuery
    Transaction = trRead
    BufferChunks = 1000
    CachedUpdates = False
    SQL.Strings = (
      'select * from fyear')
    Left = 64
    Top = 96
  end
  object dsYearSelect: TDataSource
    DataSet = quYearSelect
    Left = 140
    Top = 96
  end
  object trRead: TIBTransaction
    Active = False
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    Left = 357
    Top = 1
  end
  object FormStorage: TFormStorage
    Active = False
    MinMaxInfo.MinTrackHeight = 324
    MinMaxInfo.MinTrackWidth = 500
    StoredProps.Strings = (
      'GridYear.Width')
    StoredValues = <
      item
        Name = 'YearOrder'
        Value = 0
      end>
    Left = 453
    Top = 5
  end
  object quWeekSelect: TIBQuery
    Transaction = trRead
    BufferChunks = 1000
    CachedUpdates = False
    DataSource = dsYearSelect
    SQL.Strings = (
      'select * from week where fyear_id=:fyear_id')
    Left = 64
    Top = 156
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'fyear_id'
        ParamType = ptUnknown
      end>
  end
  object dsWeekSelect: TDataSource
    DataSet = quWeekSelect
    Left = 140
    Top = 156
  end
  object quYearDelete: TIBQuery
    Transaction = trWrite
    BufferChunks = 1000
    CachedUpdates = False
    SQL.Strings = (
      'delete from fyear where fyear_id=:id')
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
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    Left = 409
    Top = 1
  end
  object quHolidaySelect: TIBQuery
    Transaction = trRead
    BufferChunks = 1000
    CachedUpdates = False
    DataSource = dsYearSelect
    SQL.Strings = (
      'select * from holiday where fyear_id=:fyear_id')
    Left = 229
    Top = 97
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'fyear_id'
        ParamType = ptUnknown
      end>
    object quHolidaySelectholiday: TDateField
      FieldName = 'holiday'
      DisplayFormat = 'dd mmmm'
    end
    object quHolidaySelectname: TStringField
      FieldName = 'name'
      Size = 100
    end
  end
  object dsHolidaySelect: TDataSource
    DataSet = quHolidaySelect
    Left = 317
    Top = 97
  end
  object dsCarrySelect: TDataSource
    DataSet = quCarrySelect
    Left = 317
    Top = 153
  end
  object quCarrySelect: TIBQuery
    Transaction = trRead
    BufferChunks = 1000
    CachedUpdates = False
    DataSource = dsYearSelect
    SQL.Strings = (
      'select * from carry where fyear_id=:fyear_id')
    Left = 229
    Top = 153
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'fyear_id'
        ParamType = ptUnknown
      end>
  end
  object quExceptSelect: TIBQuery
    Transaction = trRead
    BufferChunks = 1000
    CachedUpdates = False
    DataSource = dsYearSelect
    SQL.Strings = (
      'select * from dateexcept where fyear_id=:fyear_id')
    Left = 229
    Top = 209
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'fyear_id'
        ParamType = ptUnknown
      end>
  end
  object dsExceptSelect: TDataSource
    DataSet = quExceptSelect
    Left = 317
    Top = 209
  end
end
