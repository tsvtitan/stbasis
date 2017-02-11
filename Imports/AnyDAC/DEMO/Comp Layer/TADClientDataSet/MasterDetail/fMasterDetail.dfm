inherited frmMasterDetail: TfrmMasterDetail
  Left = 368
  Top = 200
  Width = 565
  Height = 559
  Caption = 'Master Details'
  Font.Name = 'MS Sans Serif'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    Width = 557
    Height = 475
    inherited pnlBorder: TPanel
      Width = 549
      Height = 467
      inherited pnlTitle: TPanel
        Width = 547
        inherited lblTitle: TLabel
          Width = 152
          Caption = 'Master Details'
        end
        inherited imgAnyDAC: TImage
          Left = 250
        end
        inherited imgGradient: TImage
          Left = 193
        end
        inherited pnlBottom: TPanel
          Width = 547
        end
      end
      inherited pnlMain: TPanel
        Width = 547
        Height = 412
        object Splitter1: TSplitter [0]
          Left = 0
          Top = 278
          Width = 547
          Height = 3
          Cursor = crVSplit
          Align = alTop
        end
        inherited pnlConnection: TPanel
          Width = 547
          TabOrder = 2
          inherited lblUseConnectionDef: TLabel
            Width = 126
          end
        end
        object DBGrid1: TDBGrid
          Left = 0
          Top = 84
          Width = 547
          Height = 194
          Align = alTop
          BorderStyle = bsNone
          Ctl3D = True
          DataSource = dsOrders
          ParentCtl3D = False
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
        end
        object DBGrid2: TDBGrid
          Left = 0
          Top = 281
          Width = 547
          Height = 131
          Align = alClient
          BorderStyle = bsNone
          Ctl3D = True
          DataSource = dsOrdDetails
          ParentCtl3D = False
          TabOrder = 1
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
        end
        object pnlFetchOnDemand: TPanel
          Left = 0
          Top = 57
          Width = 547
          Height = 27
          Align = alTop
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 3
          object chbFetchOnDemand: TCheckBox
            Left = 11
            Top = 6
            Width = 110
            Height = 17
            Caption = 'Fetch On Demand'
            TabOrder = 0
            OnClick = chbFetchOnDemandClick
          end
          object Button1: TButton
            Left = 200
            Top = 0
            Width = 75
            Height = 25
            Caption = 'Apply updates'
            TabOrder = 1
            OnClick = Button1Click
          end
          object Button2: TButton
            Left = 281
            Top = 1
            Width = 96
            Height = 25
            Caption = 'Cancel updates'
            TabOrder = 2
            OnClick = Button2Click
          end
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 475
    Width = 557
    inherited btnClose: TButton
      Left = 478
    end
  end
  inherited StatusBar1: TStatusBar
    Top = 506
    Width = 557
  end
  object cdsOrders: TADClientDataSet
    Adapter = adOrders
    Left = 448
    Top = 136
  end
  object cdsOrdDetails: TADClientDataSet
    IndexFieldNames = 'OrderID'
    MasterSource = dsOrders
    MasterFields = 'OrderID'
    Adapter = adOrderDetails
    Left = 448
    Top = 333
  end
  object dsOrders: TDataSource
    DataSet = cdsOrders
    Left = 480
    Top = 136
  end
  object dsOrdDetails: TDataSource
    DataSet = cdsOrdDetails
    Left = 480
    Top = 333
  end
  object adOrders: TADTableAdapter
    SelectCommand = cmOrders
    Left = 412
    Top = 136
  end
  object adOrderDetails: TADTableAdapter
    SelectCommand = cmOrderDetails
    Left = 412
    Top = 333
  end
  object cmOrders: TADCommand
    Connection = dmlMainComp.dbMain
    CommandText.Strings = (
      'select * from {id Orders}')
    Left = 448
    Top = 171
  end
  object cmOrderDetails: TADCommand
    Connection = dmlMainComp.dbMain
    CommandText.Strings = (
      'select * from {id Order Details}')
    Left = 448
    Top = 370
  end
end
