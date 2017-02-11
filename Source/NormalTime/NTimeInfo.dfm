object ftmNTimeInfo: TftmNTimeInfo
  Left = 408
  Top = 220
  Width = 387
  Height = 309
  BorderIcons = [biSystemMenu]
  Caption = 'Нормы'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object GridInfo: TRxDBGrid
    Left = 0
    Top = 65
    Width = 379
    Height = 217
    Align = alClient
    DataSource = dsInfo
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    TitleButtons = True
    OnGetCellParams = GridInfoGetCellParams
    OnTitleBtnClick = GridInfoTitleBtnClick
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 379
    Height = 65
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    OnResize = Panel1Resize
    object Label1: TLabel
      Left = 8
      Top = 40
      Width = 41
      Height = 13
      Caption = 'График:'
    end
    object LabelSchedule: TLabel
      Left = 72
      Top = 40
      Width = 31
      Height = 13
      Caption = '<Нет>'
    end
    object Label3: TLabel
      Left = 8
      Top = 8
      Width = 58
      Height = 13
      Caption = 'Календарь:'
    end
    object SpeedButton1: TSpeedButton
      Left = 288
      Top = 8
      Width = 41
      Height = 22
      Anchors = [akTop, akRight]
      GroupIndex = 1
      Down = True
      Caption = 'Часы'
      OnClick = SpeedButtonsClick
    end
    object SpeedButton2: TSpeedButton
      Left = 336
      Top = 8
      Width = 41
      Height = 22
      Anchors = [akTop, akRight]
      GroupIndex = 1
      Caption = 'Дни'
      OnClick = SpeedButtonsClick
    end
    object ButtonRefresh: TButton
      Left = 288
      Top = 36
      Width = 88
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Обновить'
      TabOrder = 1
      OnClick = ButtonRefreshClick
    end
    object ComboBoxCalendar: TComboBox
      Left = 72
      Top = 8
      Width = 209
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
      OnChange = ComboBoxCalendarChange
      Items.Strings = (
        'Весь календарь'
        'Январь'
        'Февраль'
        'Март')
    end
  end
  object mdInfo: TRxMemoryData
    FieldDefs = <
      item
        Name = 'AbsenceName'
        DataType = ftString
        Size = 100
      end>
    OnCalcFields = mdInfoCalcFields
    Left = 88
    Top = 120
    object mdInfoName: TStringField
      DisplayLabel = 'Вид'
      FieldName = 'Name'
      Size = 100
    end
    object mdInfoCommonSumma: TFloatField
      DisplayLabel = 'Общая сумма'
      FieldKind = fkCalculated
      FieldName = 'CommonSumma'
      Calculated = True
    end
  end
  object dsInfo: TDataSource
    DataSet = mdInfo
    Left = 136
    Top = 112
  end
  object quShiftSelect: TIBQuery
    Transaction = trRead
    BufferChunks = 1000
    CachedUpdates = False
    SQL.Strings = (
      'select * from shift')
    Left = 92
    Top = 185
  end
  object trRead: TIBTransaction
    Active = False
    DefaultAction = TARollback
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    AutoStopAction = saNone
    Left = 328
    Top = 96
  end
end
