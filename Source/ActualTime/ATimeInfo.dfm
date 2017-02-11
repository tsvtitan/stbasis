object ftmATimeInfo: TftmATimeInfo
  Left = 428
  Top = 290
  Width = 358
  Height = 233
  BorderIcons = [biSystemMenu]
  Caption = 'Суммы неявок'
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
    Top = 33
    Width = 350
    Height = 173
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
    Width = 350
    Height = 33
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 56
      Height = 13
      Caption = 'Сотрудник:'
    end
    object Label2: TLabel
      Left = 72
      Top = 8
      Width = 31
      Height = 13
      Caption = '<Нет>'
    end
    object ButtonRefresh: TButton
      Left = 272
      Top = 3
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Обновить'
      TabOrder = 0
      OnClick = ButtonRefreshClick
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
    Top = 64
    object mdInfoAbsenceName: TStringField
      DisplayLabel = 'Неявка'
      FieldName = 'AbsenceName'
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
    Left = 244
    Top = 97
  end
  object trRead: TIBTransaction
    Active = False
    DefaultAction = TARollback
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    AutoStopAction = saNone
    Left = 176
    Top = 8
  end
  object quAbsenceSelect: TIBQuery
    Transaction = trRead
    BufferChunks = 1000
    CachedUpdates = False
    SQL.Strings = (
      'select absence_id,name from absence')
    Left = 56
    Top = 121
  end
end
