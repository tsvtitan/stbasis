object frmCalExcept: TfrmCalExcept
  Left = 367
  Top = 204
  BorderStyle = bsDialog
  Caption = 'Исключения'
  ClientHeight = 299
  ClientWidth = 419
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object GridExcept: TRxDBGrid
    Left = 0
    Top = 41
    Width = 338
    Height = 223
    Align = alClient
    DataSource = dsExceptSelect
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgAlwaysShowSelection]
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    IniStorage = FormStorage
    TitleButtons = True
    OnGetCellParams = GridExceptGetCellParams
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
  object PanelExceptEdit: TPanel
    Left = 338
    Top = 41
    Width = 81
    Height = 223
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 1
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 81
      Height = 223
      Align = alClient
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
        Top = 68
        Width = 75
        Height = 25
        Caption = 'Удалить'
        TabOrder = 2
        OnClick = ButtonExceptDeleteClick
      end
      object ButtonExceptEdit: TButton
        Left = 4
        Top = 36
        Width = 75
        Height = 25
        Caption = 'Изменить'
        TabOrder = 1
        OnClick = ButtonExceptEditClick
      end
      object btnExceptGridColsSet: TButton
        Tag = 5
        Left = 4
        Top = 144
        Width = 75
        Height = 25
        Caption = 'Настройка'
        TabOrder = 4
        OnClick = btnExceptGridColsSetClick
      end
      object ButtonRefresh: TButton
        Left = 4
        Top = 112
        Width = 75
        Height = 25
        Caption = 'Обновить'
        TabOrder = 3
        OnClick = ButtonRefreshClick
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 264
    Width = 419
    Height = 35
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object LabelCount: TLabel
      Left = 185
      Top = 0
      Width = 87
      Height = 35
      Align = alLeft
      Caption = 'Всего записей: 0'
      Layout = tlCenter
    end
    object Panel4: TPanel
      Left = 338
      Top = 0
      Width = 81
      Height = 35
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object ButtonClose: TButton
        Left = 4
        Top = 6
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
      Height = 35
      Align = alLeft
      BevelOuter = bvNone
      BorderWidth = 8
      TabOrder = 1
      object DBNavigator: TDBNavigator
        Left = 8
        Top = 8
        Width = 169
        Height = 19
        DataSource = dsExceptSelect
        VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
        Align = alClient
        TabOrder = 0
      end
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 419
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    object Label11: TLabel
      Left = 8
      Top = 11
      Width = 55
      Height = 13
      Caption = 'Календарь'
    end
    object Label1: TLabel
      Left = 184
      Top = 11
      Width = 38
      Height = 13
      Caption = 'Неделя'
    end
    object EditCurDate: TEdit
      Left = 72
      Top = 8
      Width = 105
      Height = 21
      TabStop = False
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
    object EditCurWeek: TEdit
      Left = 232
      Top = 8
      Width = 105
      Height = 21
      TabStop = False
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 1
    end
  end
  object quExceptSelect: TIBQuery
    Tag = 5
    Transaction = frmCalendar.trRead
    BufferChunks = 1000
    CachedUpdates = False
    DataSource = frmCalendar.dsWeekSelect
    SQL.Strings = (
      'select * from dateexcept where week_id=:week_id')
    Left = 117
    Top = 121
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'week_id'
        ParamType = ptUnknown
      end>
  end
  object dsExceptSelect: TDataSource
    DataSet = quExceptSelect
    Left = 205
    Top = 121
  end
  object FormStorage: TFormStorage
    Active = False
    Options = []
    StoredValues = <
      item
        Name = 'YearOrder'
        Value = 0
      end
      item
        Name = 'LastYear'
        Value = ''
      end
      item
        Name = 'LastWeek'
        Value = ''
      end
      item
        Name = 'LastHoliday'
        Value = ''
      end
      item
        Name = 'LastCarry'
        Value = ''
      end
      item
        Name = 'LastExcept'
        Value = ''
      end>
    Left = 253
    Top = 53
  end
end
