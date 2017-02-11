inherited frmCachedUpdates: TfrmCachedUpdates
  Left = 333
  Top = 69
  Width = 578
  Height = 583
  Caption = 'Update SQL - Cached updates'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    Width = 570
    Height = 499
    inherited pnlBorder: TPanel
      Width = 562
      Height = 491
      inherited pnlTitle: TPanel
        Width = 560
        inherited lblTitle: TLabel
          Width = 166
          Caption = 'Cached updates'
        end
        inherited imgAnyDAC: TImage
          Left = 263
        end
        inherited imgGradient: TImage
          Left = 206
        end
        inherited pnlBottom: TPanel
          Width = 560
        end
      end
      inherited pnlMain: TPanel
        Width = 560
        Height = 436
        inherited pnlConnection: TPanel
          Width = 560
        end
        inherited pnlSubPageControl: TPanel
          Width = 560
          Height = 377
          inherited pcMain: TADGUIxFormsPageControl
            Width = 560
            Height = 376
            ActivePage = tsData
            inherited tsData: TTabSheet
              object DBGrid1: TDBGrid
                Left = 0
                Top = 60
                Width = 552
                Height = 244
                Align = alClient
                BorderStyle = bsNone
                Ctl3D = True
                DataSource = dsProducts
                ParentCtl3D = False
                TabOrder = 0
                TitleFont.Charset = DEFAULT_CHARSET
                TitleFont.Color = clWindowText
                TitleFont.Height = -11
                TitleFont.Name = 'Tahoma'
                TitleFont.Style = []
              end
              object DBNavigator1: TDBNavigator
                Left = 0
                Top = 0
                Width = 552
                Height = 25
                DataSource = dsProducts
                Align = alTop
                Flat = True
                TabOrder = 2
              end
              object Panel1: TPanel
                Left = 0
                Top = 25
                Width = 552
                Height = 35
                Align = alTop
                BevelOuter = bvNone
                ParentColor = True
                TabOrder = 1
                DesignSize = (
                  552
                  35)
                object btnApply: TSpeedButton
                  Left = 11
                  Top = 7
                  Width = 61
                  Height = 21
                  Anchors = [akLeft, akBottom]
                  Caption = 'Apply'
                  Flat = True
                  OnClick = btnApplyClick
                end
                object btnCancel: TSpeedButton
                  Left = 79
                  Top = 7
                  Width = 57
                  Height = 21
                  Anchors = [akLeft, akBottom]
                  Caption = 'Cancel'
                  Flat = True
                  OnClick = btnCancelClick
                end
                object btnCommit: TSpeedButton
                  Left = 143
                  Top = 7
                  Width = 65
                  Height = 21
                  Anchors = [akLeft, akBottom]
                  Caption = 'Commit'
                  Flat = True
                  OnClick = btnCommitClick
                end
                object btnRevert: TSpeedButton
                  Left = 215
                  Top = 7
                  Width = 83
                  Height = 21
                  Anchors = [akLeft, akBottom]
                  Caption = 'Revert record'
                  Flat = True
                  OnClick = btnRevertClick
                end
                object btnUndoLast: TSpeedButton
                  Left = 305
                  Top = 7
                  Width = 105
                  Height = 21
                  Anchors = [akLeft, akBottom]
                  Caption = 'Undo last change'
                  Flat = True
                  OnClick = btnUndoLastClick
                end
              end
            end
            inherited tsOptions: TTabSheet
              inherited ADGUIxFormsPanelTree1: TADGUIxFormsPanelTree
                Width = 552
                Height = 263
                inherited frmUpdateOptions: TfrmADGUIxFormsUpdateOptions
                  Width = 548
                  Height = 259
                end
                inherited frmResourceOptions: TfrmADGUIxFormsResourceOptions
                  Width = 548
                  Height = 259
                end
                inherited frmFormatOptions: TfrmADGUIxFormsFormatOptions
                  Width = 548
                  Height = 259
                end
                inherited frmFetchOptions: TfrmADGUIxFormsFetchOptions
                  Width = 548
                  Height = 259
                end
              end
              inherited pnlDataSet: TPanel
                Width = 552
              end
            end
          end
          inherited pnlMainSep: TPanel
            Width = 560
          end
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 499
    Width = 570
    inherited btnClose: TButton
      Left = 491
    end
  end
  inherited StatusBar1: TStatusBar
    Top = 530
    Width = 570
  end
  object qrProducts: TADQuery
    OnUpdateRecord = qrProductsUpdateRecord
    Connection = dmlMainComp.dbMain
    FetchOptions.Mode = fmAll
    FetchOptions.Items = [fiBlobs, fiDetails]
    CachedUpdates = True
    SQL.Strings = (
      'select p.*, c.CategoryName'
      'from {id Products} p, {id Categories} c'
      'where p.CategoryID = c.CategoryID')
    Left = 320
    Top = 336
    object qrProductsProductID: TIntegerField
      FieldName = 'ProductID'
      Origin = 'ProductID'
      ProviderFlags = [pfInWhere, pfInKey]
    end
    object qrProductsProductName: TStringField
      FieldName = 'ProductName'
      Origin = 'ProductName'
      Required = True
      Size = 40
    end
    object qrProductsSupplierID: TIntegerField
      FieldName = 'SupplierID'
      Origin = 'SupplierID'
    end
    object qrProductsCategoryID: TIntegerField
      FieldName = 'CategoryID'
      Origin = 'CategoryID'
    end
    object qrProductsQuantityPerUnit: TStringField
      FieldName = 'QuantityPerUnit'
      Origin = 'QuantityPerUnit'
    end
    object qrProductsUnitPrice: TCurrencyField
      FieldName = 'UnitPrice'
    end
    object qrProductsUnitsInStock: TSmallintField
      FieldName = 'UnitsInStock'
      Origin = 'UnitsInStock'
    end
    object qrProductsUnitsOnOrder: TSmallintField
      FieldName = 'UnitsOnOrder'
      Origin = 'UnitsOnOrder'
    end
    object qrProductsReorderLevel: TSmallintField
      FieldName = 'ReorderLevel'
      Origin = 'ReorderLevel'
    end
    object qrProductsDiscontinued: TBooleanField
      FieldName = 'Discontinued'
      Origin = 'Discontinued'
      Required = True
    end
    object qrProductsCategoryName: TStringField
      FieldName = 'CategoryName'
      Origin = 'CategoryName'
      Size = 15
    end
  end
  object usProducts: TADUpdateSQL
    ConnectionName = 'MainDB'
    InsertSQL.Strings = (
      'INSERT INTO {Products} ('
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
    Left = 320
    Top = 368
  end
  object usCategories: TADUpdateSQL
    ConnectionName = 'MainDB'
    ModifySQL.Strings = (
      'UPDATE {id Categories} SET'
      '  CategoryName = :NEW_CategoryName'
      'WHERE'
      '  CategoryID = :OLD_CategoryID')
    Left = 320
    Top = 400
  end
  object dsProducts: TDataSource
    DataSet = qrProducts
    Left = 352
    Top = 336
  end
end
