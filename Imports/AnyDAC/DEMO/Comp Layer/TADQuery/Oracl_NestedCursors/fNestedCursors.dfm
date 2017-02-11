inherited frmNestedCursors: TfrmNestedCursors
  Left = 335
  Top = 154
  Height = 639
  Caption = 'Nested Cursors'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    Height = 562
    inherited pnlBorder: TPanel
      Height = 554
      inherited pnlTitle: TPanel
        inherited lblTitle: TLabel
          Width = 159
          Caption = 'Nested Cursors'
        end
      end
      inherited pnlMain: TPanel
        Height = 499
        inherited pnlConnection: TPanel
          inherited cbDB: TComboBox
            Enabled = False
          end
        end
        inherited pnlSubPageControl: TPanel
          Height = 440
          inherited pcMain: TADGUIxFormsPageControl
            Height = 439
            ActivePage = tsData
            inherited tsData: TTabSheet
              object Splitter1: TSplitter
                Left = 0
                Top = 209
                Width = 532
                Height = 3
                Cursor = crVSplit
                Align = alTop
              end
              object DBGrid1: TDBGrid
                Left = 0
                Top = 33
                Width = 532
                Height = 176
                Align = alTop
                BorderStyle = bsNone
                DataSource = DataSource1
                Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete]
                TabOrder = 0
                TitleFont.Charset = DEFAULT_CHARSET
                TitleFont.Color = clWindowText
                TitleFont.Height = -11
                TitleFont.Name = 'Tahoma'
                TitleFont.Style = []
              end
              object DBGrid2: TDBGrid
                Left = 0
                Top = 212
                Width = 532
                Height = 155
                Align = alClient
                BorderStyle = bsNone
                DataSource = DataSource2
                Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete]
                TabOrder = 1
                TitleFont.Charset = DEFAULT_CHARSET
                TitleFont.Color = clWindowText
                TitleFont.Height = -11
                TitleFont.Name = 'Tahoma'
                TitleFont.Style = []
              end
              object Panel1: TPanel
                Left = 0
                Top = 0
                Width = 532
                Height = 33
                Align = alTop
                BevelOuter = bvNone
                ParentColor = True
                TabOrder = 2
                object btnOpenClose: TSpeedButton
                  Left = 11
                  Top = 2
                  Width = 75
                  Height = 21
                  Caption = 'Open/Close'
                  Flat = True
                  OnClick = btnOpenCloseClick
                end
                object btnPrepUnprep: TSpeedButton
                  Left = 103
                  Top = 2
                  Width = 75
                  Height = 21
                  Caption = 'Prep/Unprep'
                  Flat = True
                  OnClick = btnPrepUnprepClick
                end
              end
            end
            inherited tsOptions: TTabSheet
              inherited ADGUIxFormsPanelTree1: TADGUIxFormsPanelTree
                Height = 326
                inherited frmUpdateOptions: TfrmADGUIxFormsUpdateOptions
                  Height = 322
                end
                inherited frmResourceOptions: TfrmADGUIxFormsResourceOptions
                  Height = 322
                end
                inherited frmFormatOptions: TfrmADGUIxFormsFormatOptions
                  Height = 322
                end
                inherited frmFetchOptions: TfrmADGUIxFormsFetchOptions
                  Height = 322
                end
              end
            end
          end
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 562
  end
  inherited StatusBar1: TStatusBar
    Top = 593
  end
  object ADQuery1: TADQuery
    Connection = dmlMainComp.dbMain
    FetchOptions.Items = [fiBlobs, fiDetails]
    SQL.Strings = (
      
        'select CURSOR(select p.* from "Products" p WHERE p.categoryid = ' +
        'c.categoryid) as crs, c.categoryid '
      'from "Categories" c'
      'order by c.categoryid')
    Left = 200
    Top = 272
    object ADQuery1CRS: TDataSetField
      FieldName = 'CRS'
      ReadOnly = True
    end
    object ADQuery1CATEGORYID: TIntegerField
      FieldName = 'CATEGORYID'
    end
  end
  object DataSource1: TDataSource
    DataSet = ADQuery1
    Left = 232
    Top = 272
  end
  object ADClientDataSet1: TADClientDataSet
    DataSetField = ADQuery1CRS
    FetchOptions.Mode = fmAll
    Left = 200
    Top = 312
  end
  object DataSource2: TDataSource
    DataSet = ADClientDataSet1
    Left = 232
    Top = 312
  end
end
