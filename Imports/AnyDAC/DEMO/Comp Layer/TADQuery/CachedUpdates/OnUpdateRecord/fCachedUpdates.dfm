inherited frmCachedUpdates: TfrmCachedUpdates
  Left = 243
  Top = 79
  Width = 566
  Height = 655
  Caption = 'Cached updates'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    Width = 558
    Height = 571
    inherited pnlBorder: TPanel
      Width = 550
      Height = 563
      inherited pnlTitle: TPanel
        Width = 548
        inherited lblTitle: TLabel
          Width = 169
          Caption = 'Cached Updates'
        end
        inherited imgAnyDAC: TImage
          Left = 251
        end
        inherited imgGradient: TImage
          Left = 194
        end
        inherited pnlBottom: TPanel
          Width = 548
        end
      end
      inherited pnlMain: TPanel
        Width = 548
        Height = 508
        inherited pnlConnection: TPanel
          Width = 548
        end
        inherited pnlSubPageControl: TPanel
          Width = 548
          Height = 449
          inherited pcMain: TADGUIxFormsPageControl
            Width = 548
            Height = 448
            ActivePage = tsData
            inherited tsData: TTabSheet
              object Panel2: TPanel
                Left = 0
                Top = 0
                Width = 540
                Height = 376
                Align = alClient
                BevelOuter = bvNone
                ParentColor = True
                TabOrder = 0
                object DBGrid1: TDBGrid
                  Left = 0
                  Top = 0
                  Width = 540
                  Height = 334
                  Align = alClient
                  BorderStyle = bsNone
                  DataSource = dsProducts
                  TabOrder = 0
                  TitleFont.Charset = DEFAULT_CHARSET
                  TitleFont.Color = clWindowText
                  TitleFont.Height = -11
                  TitleFont.Name = 'Tahoma'
                  TitleFont.Style = []
                end
                object Panel1: TPanel
                  Left = 0
                  Top = 334
                  Width = 540
                  Height = 42
                  Align = alBottom
                  BevelOuter = bvNone
                  ParentColor = True
                  TabOrder = 1
                  object btnApply: TSpeedButton
                    Left = 11
                    Top = 8
                    Width = 84
                    Height = 21
                    Caption = 'Apply Updates'
                    Flat = True
                    OnClick = btnApplyClick
                  end
                  object btnCancel: TSpeedButton
                    Left = 103
                    Top = 8
                    Width = 100
                    Height = 21
                    Caption = 'Cancel Updates'
                    Flat = True
                    OnClick = btnCancelClick
                  end
                  object btnCommit: TSpeedButton
                    Left = 211
                    Top = 8
                    Width = 89
                    Height = 21
                    Caption = 'Commit Updates'
                    Flat = True
                    OnClick = btnCommitClick
                  end
                  object btnRevert: TSpeedButton
                    Left = 307
                    Top = 8
                    Width = 83
                    Height = 21
                    Caption = 'Revert Record'
                    Flat = True
                    OnClick = btnRevertClick
                  end
                  object btnUndoLast: TSpeedButton
                    Left = 397
                    Top = 8
                    Width = 97
                    Height = 21
                    Caption = 'Undo Last Change'
                    Flat = True
                    OnClick = btnUndoLastClick
                  end
                end
              end
            end
            inherited tsOptions: TTabSheet
              inherited ADGUIxFormsPanelTree1: TADGUIxFormsPanelTree
                Width = 540
                Height = 335
                inherited frmUpdateOptions: TfrmADGUIxFormsUpdateOptions
                  Width = 536
                  Height = 331
                end
                inherited frmResourceOptions: TfrmADGUIxFormsResourceOptions
                  Width = 536
                  Height = 331
                end
                inherited frmFormatOptions: TfrmADGUIxFormsFormatOptions
                  Width = 536
                  Height = 331
                end
                inherited frmFetchOptions: TfrmADGUIxFormsFetchOptions
                  Width = 536
                  Height = 331
                end
              end
              inherited pnlDataSet: TPanel
                Width = 540
              end
            end
          end
          inherited pnlMainSep: TPanel
            Width = 548
          end
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 571
    Width = 558
    inherited btnClose: TButton
      Left = 479
    end
  end
  inherited StatusBar1: TStatusBar
    Top = 602
    Width = 558
  end
  object qryProducts: TADQuery
    OnUpdateRecord = qryProductsUpdateRecord
    Connection = dmlMainComp.dbMain
    FetchOptions.Mode = fmAll
    FetchOptions.Items = [fiBlobs, fiDetails]
    CachedUpdates = True
    SQL.Strings = (
      'select p.*, c.CategoryName'
      'from {id Products} p, {id Categories} c'
      'where p.CategoryID = c.CategoryID')
    Left = 432
    Top = 240
    object qryProductsProductID: TIntegerField
      FieldName = 'ProductID'
      Origin = 'ProductID'
      ProviderFlags = [pfInWhere, pfInKey]
    end
    object qryProductsProductName: TStringField
      FieldName = 'ProductName'
      Origin = 'ProductName'
      Required = True
      Size = 40
    end
    object qryProductsSupplierID: TIntegerField
      FieldName = 'SupplierID'
      Origin = 'SupplierID'
    end
    object qryProductsCategoryID: TIntegerField
      FieldName = 'CategoryID'
      Origin = 'CategoryID'
    end
    object qryProductsQuantityPerUnit: TStringField
      FieldName = 'QuantityPerUnit'
      Origin = 'QuantityPerUnit'
    end
    object qryProductsUnitPrice: TCurrencyField
      FieldName = 'UnitPrice'
      Origin = 'UnitPrice'
    end
    object qryProductsUnitsInStock: TSmallintField
      FieldName = 'UnitsInStock'
      Origin = 'UnitsInStock'
    end
    object qryProductsUnitsOnOrder: TSmallintField
      FieldName = 'UnitsOnOrder'
      Origin = 'UnitsOnOrder'
    end
    object qryProductsReorderLevel: TSmallintField
      FieldName = 'ReorderLevel'
      Origin = 'ReorderLevel'
    end
    object qryProductsDiscontinued: TBooleanField
      FieldName = 'Discontinued'
      Origin = 'Discontinued'
      Required = True
    end
    object qryProductsCategoryName: TStringField
      FieldName = 'CategoryName'
      Origin = 'CategoryName'
      Size = 15
    end
  end
  object usProducts: TADUpdateSQL
    ConnectionName = 'MainDB'
    InsertSQL.Strings = (
      'INSERT INTO {id Products} ('
      '  ProductName, SupplierID, CategoryID, '
      '  QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, '
      '  ReorderLevel, Discontinued)'
      'VALUES ('
      '  :NEW_ProductName, :NEW_SupplierID, '
      '  :NEW_CategoryID, :NEW_QuantityPerUnit, :NEW_UnitPrice, '
      '  :NEW_UnitsInStock, :NEW_UnitsOnOrder, :NEW_ReorderLevel, '
      '  :NEW_Discontinued'
      ')'
      'select :NEW_ProductID = @@identity')
    ModifySQL.Strings = (
      'UPDATE {id Products} SET'
      '  ProductName = :NEW_ProductName, '
      '  SupplierID = :NEW_SupplierID, CategoryID = :NEW_CategoryID, '
      
        '  QuantityPerUnit = :NEW_QuantityPerUnit, UnitPrice = :NEW_UnitP' +
        'rice, '
      
        '  UnitsInStock = :NEW_UnitsInStock, UnitsOnOrder = :NEW_UnitsOnO' +
        'rder, '
      
        '  ReorderLevel = :NEW_ReorderLevel, Discontinued = :NEW_Disconti' +
        'nued'
      'WHERE'
      '  ProductID = :OLD_ProductID')
    DeleteSQL.Strings = (
      'DELETE FROM {id Products}'
      'WHERE'
      '  ProductID = :OLD_ProductID')
    FetchRowSQL.Strings = (
      'SELECT *'
      'FROM {id Products}'
      'WHERE'
      '  ProductID = :OLD_ProductID')
    Left = 432
    Top = 272
  end
  object usCategories: TADUpdateSQL
    ConnectionName = 'MainDB'
    ModifySQL.Strings = (
      'UPDATE {id Categories} SET'
      '  CategoryName = :NEW_CategoryName'
      'WHERE'
      '  CategoryID = :OLD_CategoryID')
    Left = 432
    Top = 304
  end
  object dsProducts: TDataSource
    DataSet = qryProducts
    Left = 464
    Top = 240
  end
end
