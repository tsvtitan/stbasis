object Form1: TForm1
  Left = 362
  Top = 107
  Width = 769
  Height = 640
  Caption = 'Data Adapter Tester'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    761
    606)
  PixelsPerInch = 96
  TextHeight = 13
  object bTestDS: TButton
    Left = 568
    Top = 75
    Width = 87
    Height = 25
    Caption = 'Test Datasets'
    TabOrder = 0
    OnClick = bTestDSClick
  end
  object Memo: TMemo
    Left = 4
    Top = 3
    Width = 557
    Height = 137
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object DBGrid1: TDBGrid
    Left = 4
    Top = 179
    Width = 753
    Height = 209
    Anchors = [akLeft, akTop, akRight]
    DataSource = dsCustomers
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object DBGrid2: TDBGrid
    Left = 4
    Top = 419
    Width = 753
    Height = 190
    Anchors = [akLeft, akTop, akRight, akBottom]
    DataSource = dsOrders
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object cbApplyCustomersSchema: TCheckBox
    Left = 4
    Top = 155
    Width = 141
    Height = 17
    Caption = 'Apply Customers Schema'
    Checked = True
    State = cbChecked
    TabOrder = 4
  end
  object cbApplyOrdersSchema: TCheckBox
    Left = 4
    Top = 395
    Width = 133
    Height = 17
    Caption = 'Apply Orders Schema'
    Checked = True
    State = cbChecked
    TabOrder = 5
  end
  object Button2: TButton
    Left = 160
    Top = 151
    Width = 75
    Height = 25
    Caption = 'Open/Close'
    TabOrder = 6
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 152
    Top = 391
    Width = 75
    Height = 25
    Caption = 'Open/Close'
    TabOrder = 7
    OnClick = Button3Click
  end
  object cbSkipCustomers: TCheckBox
    Left = 568
    Top = 32
    Width = 97
    Height = 17
    Caption = 'Skip Customers'
    TabOrder = 8
  end
  object cbSkipOrders: TCheckBox
    Left = 568
    Top = 48
    Width = 97
    Height = 17
    Caption = 'Skip Orders'
    TabOrder = 9
  end
  object Button4: TButton
    Left = 624
    Top = 115
    Width = 75
    Height = 25
    Caption = 'Switch M/D'
    TabOrder = 10
    OnClick = Button4Click
  end
  object cbCloseBeforeTest: TCheckBox
    Left = 568
    Top = 3
    Width = 113
    Height = 17
    Caption = 'Close Before Test'
    Checked = True
    State = cbChecked
    TabOrder = 11
  end
  object Button5: TButton
    Left = 600
    Top = 144
    Width = 129
    Height = 25
    Caption = 'Show Delta Counters'
    TabOrder = 12
    OnClick = Button5Click
  end
  object DBNavigator1: TDBNavigator
    Left = 248
    Top = 151
    Width = 240
    Height = 25
    DataSource = dsCustomers
    TabOrder = 13
  end
  object DBNavigator2: TDBNavigator
    Left = 240
    Top = 391
    Width = 240
    Height = 25
    DataSource = dsOrders
    TabOrder = 14
  end
  object Button6: TButton
    Left = 671
    Top = 75
    Width = 87
    Height = 25
    Caption = 'Test Deltas'
    TabOrder = 15
    OnClick = Button6Click
  end
  object Button1: TButton
    Left = 672
    Top = 32
    Width = 87
    Height = 25
    Caption = 'Clear Memo'
    TabOrder = 16
    OnClick = Button1Click
  end
  object DADriverManager1: TDADriverManager
    DriverDirectory = '%SYSTEM%\'
    AutoLoad = False
    TraceActive = False
    TraceFlags = []
    Left = 12
    Top = 11
  end
  object DAConnectionManager1: TDAConnectionManager
    MaxPoolSize = 10
    PoolTimeoutSeconds = 60
    PoolBehaviour = pbWait
    WaitIntervalSeconds = 1
    Connections = <
      item
        Name = 'AnyDAC'
        ConnectionString = 'AnyDAC?ConnectionDefName=MSSQL2000_Demo'
        Default = True
        Tag = 0
      end>
    DriverManager = DADriverManager1
    PoolingEnabled = True
    Left = 76
    Top = 11
  end
  object DASchema1: TDASchema
    ConnectionManager = DAConnectionManager1
    Datasets = <
      item
        Params = <>
        Statements = <
          item
            Connection = 'AnyDAC'
            TargetTable = 'Customers'
            SQL = 
              'SELECT '#13#10'    CustomerID, CompanyName, ContactName, ContactTitle,' +
              ' '#13#10'    Address, City, Region, PostalCode, Country, Phone, '#13#10'    ' +
              'Fax'#13#10'  FROM'#13#10'    Customers'
            StatementType = stSQL
            ColumnMappings = <
              item
                DatasetField = 'CustomerID'
                TableField = 'CustomerID'
              end
              item
                DatasetField = 'CompanyName'
                TableField = 'CompanyName'
              end
              item
                DatasetField = 'ContactName'
                TableField = 'ContactName'
              end
              item
                DatasetField = 'ContactTitle'
                TableField = 'ContactTitle'
              end
              item
                DatasetField = 'Address'
                TableField = 'Address'
              end
              item
                DatasetField = 'City'
                TableField = 'City'
              end
              item
                DatasetField = 'Region'
                TableField = 'Region'
              end
              item
                DatasetField = 'PostalCode'
                TableField = 'PostalCode'
              end
              item
                DatasetField = 'Country'
                TableField = 'Country'
              end
              item
                DatasetField = 'Phone'
                TableField = 'Phone'
              end
              item
                DatasetField = 'Fax'
                TableField = 'Fax'
              end>
          end>
        Name = 'Customers'
        Fields = <
          item
            Name = 'CustomerID'
            DataType = datString
            Size = 5
            BlobType = dabtUnknown
            DisplayWidth = 0
            Alignment = taLeftJustify
            InPrimaryKey = True
            Calculated = False
            Lookup = False
            LookupCache = False
          end
          item
            Name = 'CompanyName'
            DataType = datString
            Size = 40
            BlobType = dabtUnknown
            DisplayWidth = 0
            Alignment = taLeftJustify
            InPrimaryKey = False
            Calculated = False
            Lookup = False
            LookupCache = False
          end
          item
            Name = 'ContactName'
            DataType = datString
            Size = 30
            BlobType = dabtUnknown
            DisplayWidth = 0
            Alignment = taLeftJustify
            InPrimaryKey = False
            Calculated = False
            Lookup = False
            LookupCache = False
          end
          item
            Name = 'ContactTitle'
            DataType = datString
            Size = 30
            BlobType = dabtUnknown
            DisplayWidth = 0
            Alignment = taLeftJustify
            InPrimaryKey = False
            Calculated = False
            Lookup = False
            LookupCache = False
          end
          item
            Name = 'Address'
            DataType = datString
            Size = 60
            BlobType = dabtUnknown
            DisplayWidth = 0
            Alignment = taLeftJustify
            InPrimaryKey = False
            Calculated = False
            Lookup = False
            LookupCache = False
          end
          item
            Name = 'City'
            DataType = datString
            Size = 15
            BlobType = dabtUnknown
            DisplayWidth = 0
            Alignment = taLeftJustify
            InPrimaryKey = False
            Calculated = False
            Lookup = False
            LookupCache = False
          end
          item
            Name = 'Region'
            DataType = datString
            Size = 15
            BlobType = dabtUnknown
            DisplayWidth = 0
            Alignment = taLeftJustify
            InPrimaryKey = False
            Calculated = False
            Lookup = False
            LookupCache = False
          end
          item
            Name = 'PostalCode'
            DataType = datString
            Size = 10
            BlobType = dabtUnknown
            DisplayWidth = 0
            Alignment = taLeftJustify
            InPrimaryKey = False
            Calculated = False
            Lookup = False
            LookupCache = False
          end
          item
            Name = 'Country'
            DataType = datString
            Size = 15
            BlobType = dabtUnknown
            DisplayWidth = 0
            Alignment = taLeftJustify
            InPrimaryKey = False
            Calculated = False
            Lookup = False
            LookupCache = False
          end
          item
            Name = 'Phone'
            DataType = datString
            Size = 24
            BlobType = dabtUnknown
            DisplayWidth = 0
            Alignment = taLeftJustify
            InPrimaryKey = False
            Calculated = False
            Lookup = False
            LookupCache = False
          end
          item
            Name = 'Fax'
            DataType = datString
            Size = 24
            BlobType = dabtUnknown
            DisplayWidth = 0
            Alignment = taLeftJustify
            InPrimaryKey = False
            Calculated = False
            Lookup = False
            LookupCache = False
          end>
        BusinessRulesClient.ScriptLanguage = rslPascalScript
        BusinessRulesServer.ScriptLanguage = rslPascalScript
      end
      item
        Params = <>
        Statements = <
          item
            Connection = 'AnyDAC'
            TargetTable = 'Orders'
            SQL = 
              'SELECT '#13#10'    OrderID, CustomerID, EmployeeID, OrderDate, Require' +
              'dDate, '#13#10'    ShippedDate, ShipVia, Freight, ShipName, ShipAddres' +
              's, '#13#10'    ShipCity, ShipRegion, ShipPostalCode, ShipCountry'#13#10'  FR' +
              'OM'#13#10'    Orders'
            StatementType = stSQL
            ColumnMappings = <
              item
                DatasetField = 'OrderID'
                TableField = 'OrderID'
              end
              item
                DatasetField = 'CustomerID'
                TableField = 'CustomerID'
              end
              item
                DatasetField = 'EmployeeID'
                TableField = 'EmployeeID'
              end
              item
                DatasetField = 'OrderDate'
                TableField = 'OrderDate'
              end
              item
                DatasetField = 'RequiredDate'
                TableField = 'RequiredDate'
              end
              item
                DatasetField = 'ShippedDate'
                TableField = 'ShippedDate'
              end
              item
                DatasetField = 'ShipVia'
                TableField = 'ShipVia'
              end
              item
                DatasetField = 'Freight'
                TableField = 'Freight'
              end
              item
                DatasetField = 'ShipName'
                TableField = 'ShipName'
              end
              item
                DatasetField = 'ShipAddress'
                TableField = 'ShipAddress'
              end
              item
                DatasetField = 'ShipCity'
                TableField = 'ShipCity'
              end
              item
                DatasetField = 'ShipRegion'
                TableField = 'ShipRegion'
              end
              item
                DatasetField = 'ShipPostalCode'
                TableField = 'ShipPostalCode'
              end
              item
                DatasetField = 'ShipCountry'
                TableField = 'ShipCountry'
              end>
          end>
        Name = 'Orders'
        Fields = <
          item
            Name = 'OrderID'
            DataType = datInteger
            BlobType = dabtUnknown
            DisplayWidth = 0
            Alignment = taLeftJustify
            InPrimaryKey = True
            Calculated = False
            Lookup = False
            LookupCache = False
          end
          item
            Name = 'CustomerID'
            DataType = datString
            Size = 5
            BlobType = dabtUnknown
            DisplayWidth = 0
            Alignment = taLeftJustify
            InPrimaryKey = False
            Calculated = False
            Lookup = False
            LookupCache = False
          end
          item
            Name = 'EmployeeID'
            DataType = datInteger
            BlobType = dabtUnknown
            DisplayWidth = 0
            Alignment = taLeftJustify
            InPrimaryKey = False
            Calculated = False
            Lookup = False
            LookupCache = False
          end
          item
            Name = 'OrderDate'
            DataType = datDateTime
            BlobType = dabtUnknown
            DisplayWidth = 0
            Alignment = taLeftJustify
            InPrimaryKey = False
            Calculated = False
            Lookup = False
            LookupCache = False
          end
          item
            Name = 'RequiredDate'
            DataType = datDateTime
            BlobType = dabtUnknown
            DisplayWidth = 0
            Alignment = taLeftJustify
            InPrimaryKey = False
            Calculated = False
            Lookup = False
            LookupCache = False
          end
          item
            Name = 'ShippedDate'
            DataType = datDateTime
            BlobType = dabtUnknown
            DisplayWidth = 0
            Alignment = taLeftJustify
            InPrimaryKey = False
            Calculated = False
            Lookup = False
            LookupCache = False
          end
          item
            Name = 'ShipVia'
            DataType = datInteger
            BlobType = dabtUnknown
            DisplayWidth = 0
            Alignment = taLeftJustify
            InPrimaryKey = False
            Calculated = False
            Lookup = False
            LookupCache = False
          end
          item
            Name = 'Freight'
            DataType = datFloat
            BlobType = dabtUnknown
            DisplayWidth = 0
            Alignment = taLeftJustify
            InPrimaryKey = False
            Calculated = False
            Lookup = False
            LookupCache = False
          end
          item
            Name = 'ShipName'
            DataType = datString
            Size = 40
            BlobType = dabtUnknown
            DisplayWidth = 0
            Alignment = taLeftJustify
            InPrimaryKey = False
            Calculated = False
            Lookup = False
            LookupCache = False
          end
          item
            Name = 'ShipAddress'
            DataType = datString
            Size = 60
            BlobType = dabtUnknown
            DisplayWidth = 0
            Alignment = taLeftJustify
            InPrimaryKey = False
            Calculated = False
            Lookup = False
            LookupCache = False
          end
          item
            Name = 'ShipCity'
            DataType = datString
            Size = 15
            BlobType = dabtUnknown
            DisplayWidth = 0
            Alignment = taLeftJustify
            InPrimaryKey = False
            Calculated = False
            Lookup = False
            LookupCache = False
          end
          item
            Name = 'ShipRegion'
            DataType = datString
            Size = 15
            BlobType = dabtUnknown
            DisplayWidth = 0
            Alignment = taLeftJustify
            InPrimaryKey = False
            Calculated = False
            Lookup = False
            LookupCache = False
          end
          item
            Name = 'ShipPostalCode'
            DataType = datString
            Size = 10
            BlobType = dabtUnknown
            DisplayWidth = 0
            Alignment = taLeftJustify
            InPrimaryKey = False
            Calculated = False
            Lookup = False
            LookupCache = False
          end
          item
            Name = 'ShipCountry'
            DataType = datString
            Size = 15
            BlobType = dabtUnknown
            DisplayWidth = 0
            Alignment = taLeftJustify
            InPrimaryKey = False
            Calculated = False
            Lookup = False
            LookupCache = False
          end>
        BusinessRulesClient.ScriptLanguage = rslPascalScript
        BusinessRulesServer.ScriptLanguage = rslPascalScript
      end>
    Commands = <>
    RelationShips = <>
    UpdateRules = <>
    Left = 44
    Top = 11
  end
  object dtCustomers: TDACDSDataTable
    RemoteUpdatesOptions = []
    Fields = <>
    Params = <>
    MasterMappingMode = mmDataRequest
    StreamingOptions = [soDisableEventsWhileStreaming]
    RemoteFetchEnabled = False
    SchemaCall.Params = <>
    DataRequestCall.Params = <>
    DataUpdateCall.Params = <>
    ScriptCall.Params = <>
    ReadOnly = False
    Adapter = DABINAdapter1
    LocalSchema = DASchema1
    DetailOptions = [dtCascadeOpenClose, dtCascadeApplyUpdates, dtAutoFetch, dtCascadeDelete, dtCascadeUpdate, dtDisableLogOfCascadeDeletes, dtDisableLogOfCascadeUpdates]
    MasterOptions = [moCascadeOpenClose, moCascadeApplyUpdates, moCascadeDelete, moCascadeUpdate, moDisableLogOfCascadeDeletes, moDisableLogOfCascadeUpdates]
    LogicalName = 'Customers'
    IndexDefs = <>
    Left = 276
    Top = 27
  end
  object dsCustomers: TDADataSource
    DataTable = dtCustomers
    Left = 292
    Top = 43
  end
  object dtOrders: TDACDSDataTable
    RemoteUpdatesOptions = []
    Fields = <>
    Params = <>
    MasterMappingMode = mmDataRequest
    StreamingOptions = [soDisableEventsWhileStreaming]
    RemoteFetchEnabled = False
    SchemaCall.Params = <>
    DataRequestCall.Params = <>
    DataUpdateCall.Params = <>
    ScriptCall.Params = <>
    ReadOnly = False
    Adapter = DABINAdapter1
    LocalSchema = DASchema1
    DetailOptions = [dtCascadeOpenClose, dtCascadeApplyUpdates, dtAutoFetch, dtCascadeDelete, dtCascadeUpdate, dtDisableLogOfCascadeDeletes, dtDisableLogOfCascadeUpdates]
    MasterOptions = [moCascadeOpenClose, moCascadeApplyUpdates, moCascadeDelete, moCascadeUpdate, moDisableLogOfCascadeDeletes, moDisableLogOfCascadeUpdates]
    LogicalName = 'Orders'
    IndexDefs = <>
    Left = 340
    Top = 27
  end
  object dsOrders: TDADataSource
    DataTable = dtOrders
    Left = 356
    Top = 43
  end
  object ADPhysMSSQLDriverLink1: TADPhysMSSQLDriverLink
    Left = 141
    Top = 48
  end
  object ADGUIxWaitCursor1: TADGUIxWaitCursor
    Left = 141
    Top = 80
  end
  object DABINAdapter1: TDABINAdapter
    Left = 56
    Top = 64
  end
  object ADPhysMySQLDriverLink1: TADPhysMySQLDriverLink
    Left = 176
    Top = 48
  end
end
