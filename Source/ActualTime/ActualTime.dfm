object frmActualTime: TfrmActualTime
  Left = 218
  Top = 144
  Width = 726
  Height = 488
  Caption = 'Фактические отработки'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  Icon.Data = {
    0000010002002020100000000000E80200002600000010101000000000002801
    00000E0300002800000020000000400000000100040000000000800200000000
    0000000000000000000000000000000000000000800000800000008080008000
    0000800080008080000080808000C0C0C0000000FF0000FF000000FFFF00FF00
    0000FF00FF00FFFF0000FFFFFF00000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0777777777777777777777700000000007FFFFFFFFFFFFFFFFFFFF7000000000
    07FFFFFFFFFFFFFFFFFFFF700000000007FFFFFFFFFFFFFFFFFFFF7000000000
    07FFFFFF888FFFFFFFFFFF700000000007FFFFF81188FFFFFFFFFF7000000000
    07FFFF8111188FFFFFFFFF700000000007FFF81111118FFFFFFFFF7000000000
    07FF8111111178FFFFFFFF700000000007FF1111F711188FFFFFFF7000000000
    07FF111FFF811188FFFFFF700000000007FFF1FFFFF81178FFFFFF7000000000
    07FFFFFFFFFF81178FFFFF700000000007FFFFFFFFFFFF1188FFFF7000000000
    07FFFFFFFFFFFFF1188FFF700000000007FFFFFFFFFFFFFF1188FF7000000000
    07FFFFFFFFFFFFFFF118FF700000000007FFFFFFFFFFFFFFFF11FF7000000000
    07FFFFFFFFFFFFFFFFF18F700000000007FFFFFFFFFFFFFFFFFF1F7000000000
    07FFFFFFFFFFFFFFFFFFFF700000000007FFFFF000000000008FFF7000000000
    07FFFFF777777777808FFF700000000000777777F77777778077770000000000
    00000007F88888878000000000000000000000007FFFFFF70000000000000000
    0000000007777777000000000000000000000000000000000000000000000000
    0000000000000000000000000000FFFFFFFFFFFFFFFFFC00001FF800000FF800
    000FF800000FF800000FF800000FF800000FF800000FF800000FF800000FF800
    000FF800000FF800000FF800000FF800000FF800000FF800000FF800000FF800
    000FF800000FF800000FF800000FF800000FF800000FFC00003FFFE003FFFFF0
    07FFFFF80FFFFFFFFFFFFFFFFFFF280000001000000020000000010004000000
    0000C00000000000000000000000000000000000000000000000000080000080
    000000808000800000008000800080800000C0C0C000808080000000FF0000FF
    000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000000000000000
    000000000000000FFFFFFFFFF000000FFF77FFFFF000000FF7177FFFF000000F
    711177FFF000000F11F117FFF000000FFFFF187FF000000FFFFFF177F000000F
    FFFFFF17F000000FFFFFFFF1F000000FFFFFFFFFF000000FF000000FF0000000
    00F77700000000000000000000000000000000000000FFFF0000E0070000C003
    0000C0030000C0030000C0030000C0030000C0030000C0030000C0030000C003
    0000C0030000C0030000E0070000FC3F0000FFFF0000}
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  Visible = True
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
  object SplitterV: TSplitter
    Left = 185
    Top = 41
    Width = 3
    Height = 386
    Cursor = crHSplit
  end
  object PanelBottom: TPanel
    Left = 0
    Top = 427
    Width = 718
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
      Left = 629
      Top = 0
      Width = 89
      Height = 34
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      object ButtonClose: TButton
        Left = 8
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
    Width = 718
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object LabelCalendar: TLabel
      Left = 8
      Top = 11
      Width = 55
      Height = 13
      Caption = 'Календарь'
    end
    object LookupCalendar: TComboBox
      Left = 72
      Top = 8
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
      OnChange = LookupCalendarChange
    end
    object PanelTop2: TPanel
      Left = 392
      Top = 0
      Width = 326
      Height = 41
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      object ButtonFilter: TButton
        Left = 170
        Top = 8
        Width = 75
        Height = 25
        Caption = 'Фильтр'
        TabOrder = 2
        OnClick = ButtonFilterClick
      end
      object btnSetup: TButton
        Left = 90
        Top = 8
        Width = 75
        Height = 25
        Caption = 'Настройка'
        PopupMenu = pmSetup
        TabOrder = 1
        OnClick = btnSetupClick
      end
      object ButtonRefresh: TButton
        Left = 8
        Top = 8
        Width = 75
        Height = 25
        Caption = 'Обновить'
        TabOrder = 0
        OnClick = ButtonRefreshClick
      end
      object Button5: TButton
        Left = 248
        Top = 8
        Width = 75
        Height = 25
        Caption = 'Инфо...'
        TabOrder = 3
        OnClick = Button5Click
      end
    end
  end
  object PanelRight: TPanel
    Left = 188
    Top = 41
    Width = 530
    Height = 386
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object SplitterH: TSplitter
      Left = 0
      Top = 240
      Width = 530
      Height = 3
      Cursor = crVSplit
      Align = alBottom
    end
    object PageControl: TPageControl
      Left = 0
      Top = 0
      Width = 530
      Height = 240
      ActivePage = TabSheet1
      Align = alClient
      TabOrder = 0
      object TabSheet1: TTabSheet
        Caption = 'Основной'
        object GridActualTime: TRxDBGrid
          Left = 0
          Top = 41
          Width = 522
          Height = 171
          Align = alClient
          DataSource = dsActualTime
          DefaultDrawing = False
          Options = [dgEditing, dgTitles, dgColLines, dgRowLines, dgAlwaysShowSelection]
          TabOrder = 1
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          OnCellClick = GridActualTimeCellClick
          OnDrawColumnCell = GridActualTimeDrawColumnCell
          OnEnter = CommonGridEnter
          OnExit = CommonGridExit
          OnKeyDown = GridActualTimeKeyDown
          OnMouseDown = GridActualTimeMouseDown
          OnMouseMove = GridActualTimeMouseMove
          OnMouseUp = GridActualTimeMouseUp
          TitleButtons = True
          OnGetCellParams = GridActualTimeGetCellParams
          OnGetBtnParams = GridActualTimeGetBtnParams
          OnEditChange = GridActualTimeEditChange
          OnShowEditor = GridActualTimeShowEditor
          OnTitleBtnClick = GridActualTimeTitleBtnClick
        end
        object PanelActualTime: TPanel
          Left = 0
          Top = 0
          Width = 522
          Height = 41
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          OnResize = PanelActualTimeResize
          object Bevel1: TBevel
            Left = 144
            Top = 8
            Width = 9
            Height = 26
            Shape = bsLeftLine
          end
          object Button4: TButton
            Left = 0
            Top = 8
            Width = 137
            Height = 25
            Caption = 'Добавить совмещение'
            Enabled = False
            TabOrder = 0
            OnClick = Button4Click
          end
          object ButtonCopy: TButton
            Left = 440
            Top = 8
            Width = 75
            Height = 25
            Anchors = [akTop, akRight]
            Caption = 'Из норм'
            TabOrder = 3
            OnClick = ButtonCopyClick
          end
          object RxDBGrid1: TRxDBGrid
            Left = 152
            Top = 8
            Width = 201
            Height = 24
            Anchors = [akLeft, akTop, akRight]
            DataSource = DataSource1
            Options = [dgColLines, dgRowLines, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
            TabOrder = 1
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'MS Sans Serif'
            TitleFont.Style = []
            Columns = <
              item
                Expanded = False
                FieldName = 'name'
                Title.Caption = 'Наименование'
                Width = 90
                Visible = True
              end>
          end
          object ButtonReplace: TButton
            Left = 360
            Top = 8
            Width = 75
            Height = 25
            Anchors = [akTop, akRight]
            Caption = 'Заменить'
            TabOrder = 2
            OnClick = ButtonReplaceClick
          end
        end
      end
    end
    object PanelDivergence: TPanel
      Left = 0
      Top = 243
      Width = 530
      Height = 143
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object LabelDivergence: TLabel
        Left = 0
        Top = 0
        Width = 530
        Height = 13
        Align = alTop
        Caption = 'Отклонения от нормы'
        Color = clHighlight
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clHighlightText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Layout = tlCenter
      end
      object GridDivergence: TRxDBGrid
        Left = 0
        Top = 13
        Width = 441
        Height = 130
        Align = alClient
        DataSource = dsDivergence
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgAlwaysShowSelection]
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        OnDblClick = btnDivergenceEditClick
        OnEnter = CommonGridEnter
        OnExit = CommonGridExit
        TitleButtons = True
        OnGetCellParams = CommonGetCellParams
        Columns = <
          item
            Expanded = False
            FieldName = 'STARTDATE'
            Title.Caption = 'Дата начала'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'SCHEDULEName'
            Title.Caption = 'График'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'NETName'
            Title.Caption = 'Сетка'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CLASSNum'
            Title.Caption = 'Разряд'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CATEGORYName'
            Title.Caption = 'Категория'
            Visible = True
          end>
      end
      object PanelDivergenceEdit: TPanel
        Left = 441
        Top = 13
        Width = 89
        Height = 130
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 1
        object btnDivergenceAdd: TButton
          Left = 8
          Top = 8
          Width = 75
          Height = 25
          Caption = 'Добавить'
          TabOrder = 0
          OnClick = btnDivergenceAddClick
        end
        object btnDivergenceEdit: TButton
          Left = 8
          Top = 40
          Width = 75
          Height = 25
          Caption = 'Изменить'
          TabOrder = 1
          OnClick = btnDivergenceEditClick
        end
        object btnDivergenceDelete: TButton
          Left = 8
          Top = 72
          Width = 75
          Height = 25
          Caption = 'Удалить'
          TabOrder = 2
          OnClick = btnDivergenceDeleteClick
        end
      end
    end
  end
  object PanelLeft: TPanel
    Left = 0
    Top = 41
    Width = 185
    Height = 386
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 1
    object GridEmp: TRxDBGrid
      Left = 0
      Top = 33
      Width = 185
      Height = 353
      Align = alClient
      DataSource = dsEmpSelect
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgAlwaysShowSelection]
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnEnter = CommonGridEnter
      OnExit = CommonGridExit
      TitleButtons = True
      OnGetCellParams = CommonGetCellParams
      Columns = <
        item
          Expanded = False
          FieldName = 'plantname'
          Title.Caption = 'Предприятие'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'departname'
          Title.Caption = 'Отдел'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'tabnum'
          Title.Caption = 'Табельный номер'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'perscardnum'
          Title.Caption = 'Персональная карточка'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'fname'
          Title.Caption = 'Фамилия'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'name'
          Title.Caption = 'Имя'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'sname'
          Title.Caption = 'Отчество'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'seatname'
          Title.Caption = 'Должность'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'categoryname'
          Title.Caption = 'Категория'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'classnum'
          Title.Caption = 'Разряд'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'netname'
          Title.Caption = 'Сетка'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'profname'
          Title.Caption = 'Профессия'
          Visible = True
        end>
    end
    object PanelEmpSearch: TPanel
      Left = 0
      Top = 0
      Width = 185
      Height = 33
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      OnResize = PanelEmpSearchResize
      object EditEmpSearch: TEdit
        Left = 8
        Top = 4
        Width = 169
        Height = 21
        TabOrder = 0
        OnKeyUp = EditEmpSearchKeyUp
      end
    end
  end
  object pmSetup: TPopupMenu
    AutoPopup = False
    Left = 528
    Top = 137
    object N1: TMenuItem
      Tag = 1
      Caption = 'Сотрудники...'
      OnClick = SetupClick
    end
    object N3: TMenuItem
      Tag = 3
      Caption = 'Отклонения...'
      OnClick = SetupClick
    end
  end
  object trRead: TIBTransaction
    Active = False
    DefaultAction = TARollback
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    AutoStopAction = saNone
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
    AutoStopAction = saNone
    Left = 328
    Top = 8
  end
  object quCalSelect: TIBQuery
    Tag = 1
    Transaction = trRead
    AfterScroll = CommonAfterScroll
    BufferChunks = 1000
    CachedUpdates = False
    Left = 80
    Top = 8
  end
  object quEmpSelect: TIBQuery
    Tag = 2
    Transaction = trRead
    AfterScroll = CommonAfterScroll
    BufferChunks = 1000
    CachedUpdates = False
    Left = 40
    Top = 193
  end
  object quActualTime: TIBQuery
    Transaction = trRead
    BufferChunks = 1000
    CachedUpdates = False
    Left = 296
    Top = 153
  end
  object quDivergence: TIBQuery
    Tag = 3
    Transaction = trRead
    AfterScroll = CommonAfterScroll
    BufferChunks = 1000
    CachedUpdates = False
    DataSource = dsEmpSelect
    SQL.Strings = (
      
        'select d.SCHEDULE_ID, d.NET_ID, d.CLASS_ID, d.CATEGORY_ID, d.STA' +
        'RTDATE, d.EMPPLANT_ID, d.DIVERGENCE_ID, s.name as schedulename, ' +
        'n.name as netname, c.num as classnum, cat.name as categoryname f' +
        'rom divergence d'
      'left join schedule s on d.schedule_id=s.schedule_id '
      'left join net n on d.net_id=n.net_id '
      'left join class c on d.class_id=c.class_id '
      'left join category cat on d.category_id=cat.category_id '
      'where (empplant_id=:empplant_id)')
    Left = 332
    Top = 333
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'empplant_id'
        ParamType = ptUnknown
      end>
  end
  object dsCalSelect: TDataSource
    DataSet = quCalSelect
    Left = 152
    Top = 8
  end
  object dsEmpSelect: TDataSource
    DataSet = quEmpSelect
    Left = 104
    Top = 193
  end
  object dsActualTime: TDataSource
    DataSet = mdActualTime
    Left = 480
    Top = 209
  end
  object dsDivergence: TDataSource
    DataSet = quDivergence
    Left = 404
    Top = 333
  end
  object mdActualTime: TRxMemoryData
    Tag = 4
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
    AfterScroll = CommonAfterScroll
    Left = 400
    Top = 208
    object mdActualTimeLeft: TIntegerField
      DisplayLabel = ' '
      FieldName = 'Left'
      KeyFields = 'none'
      OnGetText = mdActualTimeLeftGetText
    end
    object mdActualTimeScheduleDate: TDateField
      DisplayLabel = 'День'
      FieldName = 'ScheduleDate'
      KeyFields = 'none'
    end
    object mdActualTimeInfo: TStringField
      DisplayLabel = 'Информация'
      FieldName = 'Info'
      KeyFields = 'none'
    end
  end
  object quShiftSelect: TIBQuery
    Transaction = trRead
    BufferChunks = 1000
    CachedUpdates = False
    SQL.Strings = (
      'select * from shift')
    Left = 436
    Top = 129
  end
  object quATimeChange: TIBQuery
    Transaction = trWrite
    BufferChunks = 1000
    CachedUpdates = False
    Left = 340
    Top = 97
  end
  object quAbsenceSelect: TIBQuery
    Transaction = trRead
    BufferChunks = 1000
    CachedUpdates = False
    SQL.Strings = (
      'select absence_id,name,shortname from absence')
    Left = 56
    Top = 121
  end
  object DataSource1: TDataSource
    DataSet = quAbsenceSelect
    Left = 128
    Top = 137
  end
end
