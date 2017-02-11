object frmSchedule: TfrmSchedule
  Left = 240
  Top = 154
  Width = 631
  Height = 459
  Caption = 'frmSchedule'
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
    0000000000000000000000000000000000000000000000000000000000000000
    00000000494949490000000000000000000000949D9D9D949400000000000000
    0000D94940000009D949000000000000000D940008FFFFF00094900000000000
    00D94008FFF88FFFF0094900000000000D9408FFFFFDDFFFFFF0949000000000
    09408FFFFFFFFFFFFFFF0940000000009400F8FFFFFFFFFFFFFF009400000000
    D90F8FFFFFFFFFFFFFFFF0D90000000D9408F8FFFFFFFFFFFFFFF09490000009
    407F8F8FFFFFFFFFFFFFFF094000000D9078F8F8FFFFFFFFFFFFFF0D90000009
    407F4F8F8FFF07FFFFFD8F094000000D907848F8F8F0707FFFFD8F0D90000009
    407F8F8F8F07FF07FFFFFF094000000D9077F8F8F078FFF007FFFF0D90000009
    49078F8F078F8FF007FFF0D9400000009407780078F8F8FFFFFFF09400000000
    D9007F007F8F8F8FFFFF00D9000000000D9077F8F8F8F8F8FFFF0D9000000000
    09D907778F844F8F8F80D94000000000009D900777F8F8F8F00D940000000000
    0009D9000777777000D940000000000000009D94900000049D94000000000000
    000000D9494949494900000000000000000000009D9D9D9D0000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000FFFFFFFFFFFFFFFFFFF00FFFFFC003FFFF00
    00FFFE00007FFC00003FF800001FF000000FF000000FE0000007E0000007C000
    0003C0000003C0000003C0000003C0000003C0000003C0000003C0000003E000
    0007E0000007F000000FF000000FF800001FFC00003FFE00007FFF0000FFFFC0
    03FFFFF00FFFFFFFFFFFFFFFFFFF280000001000000020000000010004000000
    0000C00000000000000000000000000000000000000000000000000080000080
    00000080800080000000800080008080000080808000C0C0C0000000FF0000FF
    000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000000000000000
    00000000000000000D9D9D9000000009D000000D9000000D0FFDDFF0D00000D0
    8FFFFFFF09000090F8FFFFFF0D0000D04F8F0FFD0900009048F070FD0D0000D0
    8807870F090000907078F8FF0D00000D07844F80D0000009D000000D90000000
    09D9D9D0000000000000000000000000000000000000FFFF0000F81F0000E007
    0000C0030000C003000080010000800100008001000080010000800100008001
    0000C0030000C0030000E0070000F81F0000FFFF0000}
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnKeyUp = FormKeyUp
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter: TSplitter
    Left = 129
    Top = 73
    Width = 3
    Height = 325
    Cursor = crHSplit
  end
  object PanelWait: TPanel
    Left = 132
    Top = 73
    Width = 491
    Height = 325
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 4
    object PanelProgress: TPanel
      Left = 0
      Top = 0
      Width = 491
      Height = 325
      Align = alClient
      Alignment = taLeftJustify
      BevelOuter = bvNone
      BorderWidth = 70
      TabOrder = 0
      object Label7: TLabel
        Left = 70
        Top = 70
        Width = 351
        Height = 29
        Align = alTop
        AutoSize = False
        Caption = 'Загрузка...'
        Layout = tlCenter
      end
      object ProgressBar: TProgressBar
        Left = 70
        Top = 99
        Width = 351
        Height = 16
        Align = alTop
        Min = 0
        Max = 100
        Smooth = True
        Step = 1
        TabOrder = 0
      end
    end
  end
  object PanelNTime: TPanel
    Left = 132
    Top = 73
    Width = 491
    Height = 325
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object GridNormalTime: TRxDBGrid
      Left = 0
      Top = 0
      Width = 411
      Height = 224
      Align = alClient
      DataSource = dsNormalTime
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnEnter = CommonGridEnter
      OnExit = CommonGridExit
      IniStorage = FormStorage
      OnGetCellParams = GridNormalTimeGetCellParams
    end
    object PanelInfo: TPanel
      Left = 0
      Top = 224
      Width = 491
      Height = 101
      Align = alBottom
      BevelOuter = bvNone
      BorderWidth = 3
      TabOrder = 2
      object GroupBoxInfo: TGroupBox
        Left = 3
        Top = 3
        Width = 485
        Height = 95
        Align = alClient
        Caption = 'Информация'
        TabOrder = 0
        object Label2: TLabel
          Left = 12
          Top = 16
          Width = 102
          Height = 13
          Caption = 'Календарная норма'
        end
        object Label3: TLabel
          Left = 12
          Top = 40
          Width = 148
          Height = 13
          Caption = 'Расчётная норма по графику'
        end
        object Label4: TLabel
          Left = 12
          Top = 64
          Width = 146
          Height = 13
          Caption = 'Образующаяся переработка'
        end
        object Panel5: TPanel
          Left = 322
          Top = 15
          Width = 161
          Height = 78
          Align = alRight
          BevelOuter = bvNone
          TabOrder = 0
          object Label5: TLabel
            Left = 132
            Top = 4
            Width = 20
            Height = 13
            Caption = 'час.'
          end
          object Label6: TLabel
            Left = 132
            Top = 28
            Width = 20
            Height = 13
            Caption = 'час.'
          end
          object Label8: TLabel
            Left = 132
            Top = 52
            Width = 20
            Height = 13
            Caption = 'час.'
          end
          object Edit1: TEdit
            Left = 8
            Top = 0
            Width = 121
            Height = 21
            TabStop = False
            Color = clBtnFace
            TabOrder = 0
            Text = '0'
          end
          object Edit2: TEdit
            Left = 8
            Top = 24
            Width = 121
            Height = 21
            TabStop = False
            Color = clBtnFace
            TabOrder = 1
            Text = '0'
          end
          object Edit3: TEdit
            Left = 8
            Top = 48
            Width = 121
            Height = 21
            TabStop = False
            Color = clBtnFace
            TabOrder = 2
            Text = '0'
          end
        end
      end
    end
    object PanelSelecting: TPanel
      Left = 411
      Top = 0
      Width = 80
      Height = 224
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      object ButtonRefresh: TButton
        Left = 3
        Top = 28
        Width = 75
        Height = 25
        Caption = 'Обновить'
        TabOrder = 0
        OnClick = ButtonRefreshTopClick
      end
      object btnGridColsSet: TButton
        Left = 3
        Top = 60
        Width = 75
        Height = 25
        Caption = 'Настройка'
        TabOrder = 1
        OnClick = btnGridColsSetClick
      end
    end
  end
  object PanelTop: TPanel
    Left = 0
    Top = 0
    Width = 623
    Height = 73
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 10
      Width = 101
      Height = 13
      Caption = 'Графики календаря'
    end
    object ButtonSchAdd: TButton
      Left = 8
      Top = 40
      Width = 75
      Height = 25
      Caption = 'Добавить'
      TabOrder = 0
      OnClick = ButtonSchAddClick
    end
    object ButtonSchEdit: TButton
      Left = 88
      Top = 40
      Width = 75
      Height = 25
      Caption = 'Изменить'
      TabOrder = 1
      OnClick = ButtonSchEditClick
    end
    object ButtonSchDelete: TButton
      Left = 168
      Top = 40
      Width = 75
      Height = 25
      Caption = 'Удалить'
      TabOrder = 2
      OnClick = ButtonSchDeleteClick
    end
    object ButtonRefreshTop: TButton
      Left = 248
      Top = 40
      Width = 75
      Height = 25
      Caption = 'Обновить'
      TabOrder = 3
      OnClick = ButtonRefreshTopClick
    end
    object LookupCalendar: TComboBox
      Left = 120
      Top = 8
      Width = 289
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 4
      OnChange = LookupCalendarChange
    end
  end
  object PanelBottom: TPanel
    Left = 0
    Top = 398
    Width = 623
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
      Left = 534
      Top = 0
      Width = 89
      Height = 34
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      object Button1: TButton
        Left = 8
        Top = 6
        Width = 75
        Height = 25
        Caption = 'Закрыть'
        TabOrder = 0
        OnClick = Button1Click
      end
    end
    object PanelOKCancel: TPanel
      Left = 369
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
  object GridSchedule: TRxDBGrid
    Left = 0
    Top = 73
    Width = 129
    Height = 325
    Align = alLeft
    DataSource = dsScheduleSelect
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgAlwaysShowSelection]
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDblClick = ButtonSchEditClick
    OnEnter = CommonGridEnter
    OnExit = CommonGridExit
    IniStorage = FormStorage
    TitleButtons = True
    OnGetCellParams = GridNormalTimeGetCellParams
    Columns = <
      item
        Expanded = False
        FieldName = 'name'
        Title.Caption = 'Наименование'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'avgyear'
        Title.Caption = 'Среднемесячное по календарю'
        Visible = True
      end>
  end
  object FormStorage: TFormStorage
    Active = False
    MinMaxInfo.MinTrackHeight = 400
    MinMaxInfo.MinTrackWidth = 520
    StoredProps.Strings = (
      'GridSchedule.Width')
    StoredValues = <
      item
        Name = 'LastCalendar'
      end
      item
        Name = 'LastSchedule'
      end
      item
        Name = 'LastNormalTime'
      end>
    Left = 560
    Top = 8
  end
  object mdNormalTime: TRxMemoryData
    FieldDefs = <
      item
        Name = 'Info'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'ScheduleDate'
        DataType = ftDate
      end>
    Left = 440
    Top = 208
    object mdNormalTimeScheduleDate: TDateField
      DisplayLabel = 'День'
      FieldName = 'ScheduleDate'
    end
    object mdNormalTimeInfo: TStringField
      DisplayLabel = 'Информация'
      FieldName = 'Info'
    end
  end
  object dsNormalTime: TDataSource
    DataSet = mdNormalTime
    Left = 512
    Top = 208
  end
  object quCalSelect: TIBQuery
    Tag = 1
    Transaction = trRead
    AfterScroll = CommonAfterScroll
    OnCalcFields = quCalSelectCalcFields
    BufferChunks = 1000
    CachedUpdates = False
    Left = 252
    Top = 161
    object quCalSelectcalendar_id: TIntegerField
      FieldName = 'calendar_id'
    end
    object quCalSelectstartdate: TDateField
      FieldName = 'startdate'
      DisplayFormat = 'dd mmmm yyyyг.'
    end
    object quCalSelectstartdatestr: TStringField
      FieldKind = fkCalculated
      FieldName = 'startdatestr'
      Size = 100
      Calculated = True
    end
  end
  object dsCalSelect: TDataSource
    DataSet = quCalSelect
    Left = 340
    Top = 161
  end
  object trRead: TIBTransaction
    Active = False
    DefaultAction = TACommitRetaining
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    Left = 424
    Top = 24
  end
  object trWrite: TIBTransaction
    Active = False
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    Left = 488
    Top = 24
  end
  object quScheduleSelect: TIBQuery
    Tag = 2
    Transaction = trRead
    AfterScroll = CommonAfterScroll
    BufferChunks = 1000
    CachedUpdates = False
    DataSource = dsCalSelect
    SQL.Strings = (
      
        'select calendar_id,schedule_id,name,avgyear from schedule where ' +
        'calendar_id=:calendar_id')
    Left = 252
    Top = 217
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'calendar_id'
        ParamType = ptUnknown
      end>
  end
  object dsScheduleSelect: TDataSource
    DataSet = quScheduleSelect
    Left = 348
    Top = 217
  end
  object quShiftSelect: TIBQuery
    Transaction = trRead
    BufferChunks = 1000
    CachedUpdates = False
    SQL.Strings = (
      'select * from shift')
    Left = 436
    Top = 113
  end
  object quNTimeChange: TIBQuery
    Transaction = trWrite
    BufferChunks = 1000
    CachedUpdates = False
    Left = 340
    Top = 97
  end
end
