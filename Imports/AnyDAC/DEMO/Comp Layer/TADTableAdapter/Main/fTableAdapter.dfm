inherited frmTableAdapter: TfrmTableAdapter
  Left = 361
  Top = 207
  Width = 554
  Height = 406
  Caption = 'Table Adapter'
  Font.Name = 'MS Sans Serif'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    Width = 546
    Height = 329
    inherited pnlBorder: TPanel
      Width = 538
      Height = 321
      inherited pnlTitle: TPanel
        Width = 536
        inherited lblTitle: TLabel
          Width = 146
          Caption = 'Table Adapter'
        end
        inherited imgAnyDAC: TImage
          Left = 239
        end
        inherited imgGradient: TImage
          Left = 182
        end
        inherited pnlBottom: TPanel
          Width = 536
        end
      end
      inherited pnlMain: TPanel
        Width = 536
        Height = 266
        inherited pnlConnection: TPanel
          Width = 536
          TabOrder = 2
          inherited lblUseConnectionDef: TLabel
            Width = 126
          end
        end
        object DBGrid1: TDBGrid
          Left = 0
          Top = 82
          Width = 536
          Height = 184
          Align = alClient
          BorderStyle = bsNone
          DataSource = DataSource1
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
        end
        object DBNavigator1: TDBNavigator
          Left = 0
          Top = 57
          Width = 536
          Height = 25
          DataSource = DataSource1
          Align = alTop
          Flat = True
          TabOrder = 1
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 329
    Width = 546
    inherited btnClose: TButton
      Left = 467
    end
  end
  inherited StatusBar1: TStatusBar
    Top = 360
    Width = 546
  end
  object adOrders: TADTableAdapter
    SelectCommand = cmSelect
    InsertCommand = cmInsert
    UpdateCommand = cmUpdate
    DeleteCommand = cmDelete
    Left = 288
    Top = 184
  end
  object cmSelect: TADCommand
    Connection = dmlMainComp.dbMain
    Left = 248
    Top = 217
  end
  object cmDelete: TADCommand
    Connection = dmlMainComp.dbMain
    Left = 288
    Top = 217
  end
  object cmUpdate: TADCommand
    Connection = dmlMainComp.dbMain
    Left = 328
    Top = 217
  end
  object cmInsert: TADCommand
    Connection = dmlMainComp.dbMain
    Left = 368
    Top = 217
  end
  object cdsOrders: TADClientDataSet
    Indexes = <
      item
        Active = True
        Selected = True
        Name = 'OrderID'
        Fields = 'OrderID'
      end>
    IndexFieldNames = 'OrderID'
    Adapter = adOrders
    Left = 328
    Top = 184
  end
  object DataSource1: TDataSource
    DataSet = cdsOrders
    Left = 368
    Top = 184
  end
end
