inherited frmMasterDetail: TfrmMasterDetail
  Left = 374
  Top = 43
  Width = 553
  Height = 642
  Caption = 'Master Details'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    Width = 545
    Height = 558
    inherited pnlBorder: TPanel
      Width = 537
      Height = 550
      inherited pnlTitle: TPanel
        Width = 535
        inherited lblTitle: TLabel
          Width = 152
          Caption = 'Master Details'
        end
        inherited imgAnyDAC: TImage
          Left = 235
        end
        inherited imgGradient: TImage
          Left = 178
        end
        inherited pnlBottom: TPanel
          Width = 535
        end
      end
      inherited pnlMain: TPanel
        Width = 535
        Height = 495
        inherited pnlConnection: TPanel
          Width = 535
        end
        inherited pnlSubPageControl: TPanel
          Width = 535
          Height = 436
          inherited pcMain: TADGUIxFormsPageControl
            Width = 535
            Height = 435
            ActivePage = tsData
            inherited tsData: TTabSheet
              object Splitter1: TSplitter
                Left = 0
                Top = 298
                Width = 527
                Height = 3
                Cursor = crVSplit
                Align = alTop
              end
              object DBGrid2: TDBGrid
                Left = 0
                Top = 105
                Width = 527
                Height = 193
                Align = alTop
                BorderStyle = bsNone
                DataSource = dsOrders
                TabOrder = 0
                TitleFont.Charset = DEFAULT_CHARSET
                TitleFont.Color = clWindowText
                TitleFont.Height = -11
                TitleFont.Name = 'Tahoma'
                TitleFont.Style = []
              end
              object DBGrid1: TDBGrid
                Left = 0
                Top = 301
                Width = 527
                Height = 62
                Align = alClient
                BorderStyle = bsNone
                DataSource = dsOrderDetails
                TabOrder = 1
                TitleFont.Charset = DEFAULT_CHARSET
                TitleFont.Color = clWindowText
                TitleFont.Height = -11
                TitleFont.Name = 'Tahoma'
                TitleFont.Style = []
              end
              object mmComment: TMemo
                Left = 0
                Top = 0
                Width = 527
                Height = 72
                Align = alTop
                BevelInner = bvSpace
                BevelKind = bkFlat
                BorderStyle = bsNone
                Color = clInfoBk
                Lines.Strings = (
                  
                    'To link 2 queries as master-detail, you need setup detail query:' +
                    ' add parameter[s] to SQL text,'
                  
                    'named as field[s] of master query, set DataSource to master quer' +
                    'y TDataSource. Each change of'
                  
                    'master query will fire detail query reopen. Including fiDetails ' +
                    'into detail query FetchOptions.Cache'
                  
                    'and setting IndexFieldName to the field[s] corresponding to deta' +
                    'il paramater[s], will keep all'
                  
                    'fetched records in memory. So, detail query cached updates will ' +
                    'be not purged on reopen.')
                ReadOnly = True
                TabOrder = 2
              end
              object Panel1: TPanel
                Left = 0
                Top = 72
                Width = 527
                Height = 33
                Align = alTop
                BevelOuter = bvNone
                ParentColor = True
                TabOrder = 3
                DesignSize = (
                  527
                  33)
                object cbxCacheDetails: TCheckBox
                  Left = 3
                  Top = 6
                  Width = 97
                  Height = 17
                  Anchors = [akLeft, akBottom]
                  Caption = 'Cache details'
                  TabOrder = 0
                  OnClick = cbxCacheDetailsClick
                end
                object Button1: TButton
                  Left = 102
                  Top = 4
                  Width = 107
                  Height = 21
                  Anchors = [akTop, akRight]
                  Caption = 'Refresh master'
                  TabOrder = 1
                  OnClick = Button1Click
                end
              end
            end
            inherited tsOptions: TTabSheet
              inherited ADGUIxFormsPanelTree1: TADGUIxFormsPanelTree
                Width = 527
                Height = 322
                inherited frmUpdateOptions: TfrmADGUIxFormsUpdateOptions
                  Width = 523
                  Height = 318
                end
                inherited frmResourceOptions: TfrmADGUIxFormsResourceOptions
                  Width = 523
                  Height = 318
                end
                inherited frmFormatOptions: TfrmADGUIxFormsFormatOptions
                  Width = 523
                  Height = 318
                end
                inherited frmFetchOptions: TfrmADGUIxFormsFetchOptions
                  Width = 523
                  Height = 318
                end
              end
              inherited pnlDataSet: TPanel
                Width = 527
              end
            end
          end
          inherited pnlMainSep: TPanel
            Width = 535
          end
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 558
    Width = 545
    inherited btnClose: TButton
      Left = 466
    end
  end
  inherited StatusBar1: TStatusBar
    Top = 589
    Width = 545
  end
  object qryOrders: TADQuery
    Connection = dmlMainComp.dbMain
    FetchOptions.Items = [fiBlobs, fiDetails]
    SQL.Strings = (
      'select * from {id Orders}')
    Left = 304
    Top = 176
    object qryOrdersOrderID: TIntegerField
      FieldName = 'OrderID'
      Origin = 'OrderID'
      Required = True
    end
    object qryOrdersCustomerID: TStringField
      FieldName = 'CustomerID'
      Origin = 'CustomerID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Size = 5
    end
    object qryOrdersEmployeeID: TIntegerField
      FieldName = 'EmployeeID'
      Origin = 'EmployeeID'
    end
    object qryOrdersOrderDate: TSQLTimeStampField
      FieldName = 'OrderDate'
      Origin = 'OrderDate'
    end
    object qryOrdersRequiredDate: TSQLTimeStampField
      FieldName = 'RequiredDate'
      Origin = 'RequiredDate'
    end
    object qryOrdersShippedDate: TSQLTimeStampField
      FieldName = 'ShippedDate'
      Origin = 'ShippedDate'
    end
    object qryOrdersFreight: TCurrencyField
      FieldName = 'Freight'
    end
    object qryOrdersShipVia: TIntegerField
      FieldName = 'ShipVia'
      Origin = 'ShipVia'
    end
    object qryOrdersShipName: TStringField
      FieldName = 'ShipName'
      Origin = 'ShipName'
      Size = 40
    end
    object qryOrdersShipAddress: TStringField
      FieldName = 'ShipAddress'
      Origin = 'ShipAddress'
      Size = 60
    end
    object qryOrdersShipCity: TStringField
      FieldName = 'ShipCity'
      Origin = 'ShipCity'
      Size = 15
    end
    object qryOrdersShipRegion: TStringField
      FieldName = 'ShipRegion'
      Origin = 'ShipRegion'
      Size = 15
    end
    object qryOrdersShipPostalCode: TStringField
      FieldName = 'ShipPostalCode'
      Origin = 'ShipPostalCode'
      Size = 10
    end
    object qryOrdersShipCountry: TStringField
      FieldName = 'ShipCountry'
      Origin = 'ShipCountry'
      Size = 15
    end
  end
  object dsOrders: TDataSource
    DataSet = qryOrders
    Left = 336
    Top = 176
  end
  object qryOrderDetails: TADQuery
    IndexFieldNames = 'OrderID'
    Connection = dmlMainComp.dbMain
    FetchOptions.Items = [fiBlobs, fiDetails]
    FetchOptions.Cache = [fiBlobs]
    SQL.Strings = (
      'select * from {id Order Details}'
      'where OrderID = :OrderID')
    DataSource = dsOrders
    Left = 304
    Top = 208
    ParamData = <
      item
        Name = 'OrderID'
        DataType = ftInteger
        ParamType = ptInput
        Size = 4
        Value = 10248
      end>
    object qryOrderDetailsOrderID: TIntegerField
      FieldName = 'OrderID'
      Origin = 'OrderID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryOrderDetailsProductID: TIntegerField
      FieldName = 'ProductID'
      Origin = 'ProductID'
      Required = True
    end
    object qryOrderDetailsUnitPrice: TCurrencyField
      FieldName = 'UnitPrice'
      Required = True
    end
    object qryOrderDetailsQuantity: TSmallintField
      FieldName = 'Quantity'
      Origin = 'Quantity'
      Required = True
    end
    object qryOrderDetailsDiscount: TFloatField
      FieldName = 'Discount'
      Origin = 'Discount'
      Required = True
    end
  end
  object dsOrderDetails: TDataSource
    DataSet = qryOrderDetails
    Left = 336
    Top = 208
  end
end
