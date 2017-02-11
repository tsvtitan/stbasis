inherited frmIndices: TfrmIndices
  Left = 410
  Top = 133
  Width = 530
  Height = 647
  Caption = 'Indices'
  Font.Name = 'MS Sans Serif'
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    Width = 522
    Height = 563
    inherited pnlBorder: TPanel
      Width = 514
      Height = 555
      inherited pnlTitle: TPanel
        Width = 512
        inherited lblTitle: TLabel
          Width = 76
          Caption = 'Indices'
        end
        inherited imgAnyDAC: TImage
          Left = 212
        end
        inherited imgGradient: TImage
          Left = 155
        end
        inherited pnlBottom: TPanel
          Width = 512
        end
      end
      inherited pnlMain: TPanel
        Width = 512
        Height = 500
        inherited pnlConnection: TPanel
          Width = 512
          inherited lblUseConnectionDef: TLabel
            Width = 126
          end
        end
        inherited pnlSubPageControl: TPanel
          Width = 512
          Height = 441
          inherited pcMain: TADGUIxFormsPageControl
            Width = 512
            Height = 440
            ActivePage = tsData
            inherited tsData: TTabSheet
              object DBGrid1: TDBGrid
                Left = 0
                Top = 49
                Width = 504
                Height = 319
                Align = alClient
                BorderStyle = bsNone
                DataSource = DataSource1
                TabOrder = 0
                TitleFont.Charset = DEFAULT_CHARSET
                TitleFont.Color = clWindowText
                TitleFont.Height = -11
                TitleFont.Name = 'MS Sans Serif'
                TitleFont.Style = []
                OnTitleClick = DBGrid1TitleClick
              end
              object Panel1: TPanel
                Left = 0
                Top = 0
                Width = 504
                Height = 49
                Align = alTop
                BevelOuter = bvNone
                ParentColor = True
                TabOrder = 1
                object Label1: TLabel
                  Left = 11
                  Top = 11
                  Width = 41
                  Height = 13
                  Alignment = taRightJustify
                  Caption = 'OrderBy:'
                end
                object cbIndexes: TComboBox
                  Left = 58
                  Top = 8
                  Width = 208
                  Height = 21
                  BevelInner = bvSpace
                  BevelKind = bkFlat
                  BevelOuter = bvRaised
                  Style = csDropDownList
                  ItemHeight = 13
                  TabOrder = 1
                  OnChange = cbIndexesChange
                end
                object Memo1: TMemo
                  Left = 276
                  Top = 3
                  Width = 226
                  Height = 43
                  BevelInner = bvSpace
                  BevelKind = bkFlat
                  BorderStyle = bsNone
                  Color = clInfoBk
                  Lines.Strings = (
                    'Choose item from OrderBy combo box. Or click '
                    'on grid column title. For details see qryMain.'
                    'Indexes property.')
                  ReadOnly = True
                  TabOrder = 0
                end
              end
            end
            inherited tsOptions: TTabSheet
              inherited ADGUIxFormsPanelTree1: TADGUIxFormsPanelTree
                Width = 504
                Height = 327
                inherited frmUpdateOptions: TfrmADGUIxFormsUpdateOptions
                  Width = 500
                  Height = 323
                end
                inherited frmResourceOptions: TfrmADGUIxFormsResourceOptions
                  Width = 500
                  Height = 323
                end
                inherited frmFormatOptions: TfrmADGUIxFormsFormatOptions
                  Width = 500
                  Height = 323
                end
                inherited frmFetchOptions: TfrmADGUIxFormsFetchOptions
                  Width = 500
                  Height = 323
                end
              end
              inherited pnlDataSet: TPanel
                Width = 504
                inherited lblDataSet: TLabel
                  Left = 13
                  Width = 40
                end
              end
            end
          end
          inherited pnlMainSep: TPanel
            Width = 512
          end
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 563
    Width = 522
    inherited btnClose: TButton
      Left = 443
    end
  end
  inherited StatusBar1: TStatusBar
    Top = 594
    Width = 522
  end
  object qryMain: TADQuery
    Constraints = <
      item
        FromDictionary = False
      end>
    Indexes = <
      item
        Active = True
        Name = 'CustomerID'
        Fields = 'CustomerID'
      end
      item
        Active = True
        Name = 'ShipName (case insensitive)'
        Fields = 'ShipName'
        CaseInsFields = 'ShipName'
      end
      item
        Active = True
        Name = 'CustomerID (descending)'
        Fields = 'CustomerID'
        DescFields = 'CustomerID'
      end
      item
        Active = True
        Name = 'CustomerID (where EmployeeID = 8)'
        Fields = 'CustomerID'
        Filter = 'EmployeeID = 8'
      end
      item
        Active = True
        Name = 'OrderDate year (expression)'
        Expression = 'year(OrderDate)'
      end>
    Connection = dmlMainComp.dbMain
    FetchOptions.Items = [fiBlobs, fiDetails]
    SQL.Strings = (
      'select * from {id Orders}')
    Left = 284
    Top = 368
  end
  object DataSource1: TDataSource
    DataSet = qryMain
    Left = 316
    Top = 368
  end
end
