inherited frmSchemaAdapter: TfrmSchemaAdapter
  Left = 361
  Top = 207
  Width = 587
  Height = 500
  Caption = 'Schema Adapter'
  Font.Name = 'MS Sans Serif'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    Width = 579
    Height = 423
    inherited pnlBorder: TPanel
      Width = 571
      Height = 415
      inherited pnlTitle: TPanel
        Width = 569
        inherited imgAnyDAC: TImage [0]
          Left = 272
        end
        inherited imgGradient: TImage [1]
          Left = 215
        end
        inherited lblTitle: TLabel [2]
          Width = 171
          Caption = 'Schema Adapter'
        end
        inherited pnlBottom: TPanel
          Width = 569
        end
      end
      inherited pnlMain: TPanel
        Width = 569
        Height = 360
        inherited pnlConnection: TPanel
          Width = 569
          inherited lblUseConnectionDef: TLabel
            Width = 126
          end
          object Button1: TButton
            Left = 184
            Top = 24
            Width = 97
            Height = 25
            Caption = 'Apply updates'
            TabOrder = 1
            OnClick = Button1Click
          end
        end
        object DBGrid1: TDBGrid
          Left = 8
          Top = 56
          Width = 553
          Height = 145
          Anchors = [akLeft, akTop, akRight]
          DataSource = DataSource1
          TabOrder = 1
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
        end
        object DBGrid2: TDBGrid
          Left = 7
          Top = 209
          Width = 554
          Height = 144
          Anchors = [akLeft, akTop, akRight, akBottom]
          DataSource = DataSource2
          TabOrder = 2
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 423
    Width = 579
    inherited btnClose: TButton
      Left = 582
    end
  end
  inherited StatusBar1: TStatusBar
    Top = 454
    Width = 579
  end
  object ADSchemaAdapter1: TADSchemaAdapter
    Left = 64
    Top = 120
  end
  object ADTableAdapter1: TADTableAdapter
    SchemaAdapter = ADSchemaAdapter1
    SelectCommand = ADCommand1
    Left = 40
    Top = 224
  end
  object ADTableAdapter2: TADTableAdapter
    SchemaAdapter = ADSchemaAdapter1
    SelectCommand = ADCommand2
    Left = 88
    Top = 224
  end
  object ADCommand1: TADCommand
    Connection = dmlMainComp.dbMain
    CommandKind = skSelect
    CommandText.Strings = (
      'select * from {id Orders}')
    Left = 40
    Top = 256
  end
  object ADCommand2: TADCommand
    Connection = dmlMainComp.dbMain
    CommandKind = skSelect
    CommandText.Strings = (
      'select * from {id Order Details}')
    Left = 88
    Top = 256
  end
  object ADClientDataSet1: TADClientDataSet
    CachedUpdates = True
    Adapter = ADTableAdapter1
    Left = 40
    Top = 192
    object ADClientDataSet1OrderID: TADAutoIncField
      AutoGenerateValue = arAutoInc
      FieldName = 'OrderID'
      Origin = 'OrderID'
      ProviderFlags = [pfInWhere]
      ServerAutoIncrement = True
      AutoIncrementSeed = -1
      AutoIncrementStep = -1
    end
    object ADClientDataSet1CustomerID: TStringField
      FieldName = 'CustomerID'
      Origin = 'CustomerID'
      Size = 5
    end
    object ADClientDataSet1EmployeeID: TIntegerField
      FieldName = 'EmployeeID'
      Origin = 'EmployeeID'
    end
    object ADClientDataSet1OrderDate: TSQLTimeStampField
      FieldName = 'OrderDate'
      Origin = 'OrderDate'
    end
    object ADClientDataSet1RequiredDate: TSQLTimeStampField
      FieldName = 'RequiredDate'
      Origin = 'RequiredDate'
    end
    object ADClientDataSet1ShippedDate: TSQLTimeStampField
      FieldName = 'ShippedDate'
      Origin = 'ShippedDate'
    end
    object ADClientDataSet1ShipVia: TIntegerField
      FieldName = 'ShipVia'
      Origin = 'ShipVia'
    end
    object ADClientDataSet1Freight: TCurrencyField
      FieldName = 'Freight'
      Origin = 'Freight'
    end
    object ADClientDataSet1ShipName: TStringField
      FieldName = 'ShipName'
      Origin = 'ShipName'
      Size = 40
    end
    object ADClientDataSet1ShipAddress: TStringField
      FieldName = 'ShipAddress'
      Origin = 'ShipAddress'
      Size = 60
    end
    object ADClientDataSet1ShipCity: TStringField
      FieldName = 'ShipCity'
      Origin = 'ShipCity'
      Size = 15
    end
    object ADClientDataSet1ShipRegion: TStringField
      FieldName = 'ShipRegion'
      Origin = 'ShipRegion'
      Size = 15
    end
    object ADClientDataSet1ShipPostalCode: TStringField
      FieldName = 'ShipPostalCode'
      Origin = 'ShipPostalCode'
      Size = 10
    end
    object ADClientDataSet1ShipCountry: TStringField
      FieldName = 'ShipCountry'
      Origin = 'ShipCountry'
      Size = 15
    end
  end
  object ADClientDataSet2: TADClientDataSet
    IndexFieldNames = 'OrderID'
    CachedUpdates = True
    MasterSource = DataSource1
    MasterFields = 'OrderID'
    Adapter = ADTableAdapter2
    Left = 88
    Top = 192
  end
  object DataSource1: TDataSource
    DataSet = ADClientDataSet1
    Left = 40
    Top = 160
  end
  object DataSource2: TDataSource
    DataSet = ADClientDataSet2
    Left = 88
    Top = 160
  end
end
