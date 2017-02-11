inherited frmCachedUpdates: TfrmCachedUpdates
  Left = 317
  Top = 200
  Width = 564
  Height = 459
  Caption = 'Cached Updates'
  Font.Name = 'MS Sans Serif'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    Width = 556
    Height = 375
    inherited pnlBorder: TPanel
      Width = 548
      Height = 367
      inherited pnlTitle: TPanel
        Width = 546
        inherited lblTitle: TLabel
          Width = 169
          Caption = 'Cached Updates'
          Color = clBlack
          Font.Color = clBlack
          ParentColor = False
          Transparent = True
        end
        inherited imgAnyDAC: TImage
          Left = 249
        end
        inherited imgGradient: TImage
          Left = 192
        end
        inherited pnlBottom: TPanel
          Width = 546
        end
      end
      inherited pnlMain: TPanel
        Width = 546
        Height = 312
        object btnSavePoint: TSpeedButton [0]
          Left = 2
          Top = 28
          Width = 76
          Height = 21
          Caption = 'SavePoint'
          Flat = True
          OnClick = btnSavePointClick
        end
        object btnRevertPoint: TSpeedButton [1]
          Left = 91
          Top = 28
          Width = 76
          Height = 21
          Caption = 'RevertPoint'
          Flat = True
          OnClick = btnRevertPointClick
        end
        inherited pnlConnection: TPanel
          Width = 546
          TabOrder = 2
          inherited lblUseConnectionDef: TLabel
            Width = 126
          end
        end
        object DBGrid1: TDBGrid
          Left = 0
          Top = 87
          Width = 546
          Height = 225
          Align = alClient
          BorderStyle = bsNone
          Ctl3D = True
          DataSource = DataSource1
          ParentCtl3D = False
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
        end
        object Panel1: TPanel
          Left = 0
          Top = 57
          Width = 546
          Height = 30
          Align = alTop
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 1
          object btnRevertRecord: TSpeedButton
            Left = 11
            Top = 3
            Width = 76
            Height = 21
            Caption = 'RevertRecord'
            Flat = True
            OnClick = btnRevertRecordClick
          end
          object btnULastChange: TSpeedButton
            Left = 99
            Top = 3
            Width = 94
            Height = 21
            Caption = 'UndoLastChange'
            Flat = True
            OnClick = btnULastChangeClick
          end
          object btnCancelUpdates: TSpeedButton
            Left = 205
            Top = 3
            Width = 94
            Height = 21
            Caption = 'CancelUpdates'
            Flat = True
            OnClick = btnCancelUpdatesClick
          end
          object btnApplyUpdates: TSpeedButton
            Left = 311
            Top = 3
            Width = 94
            Height = 21
            Caption = 'ApplyUpdates'
            Flat = True
            OnClick = btnApplyUpdatesClick
          end
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 375
    Width = 556
    inherited btnClose: TButton
      Left = 477
    end
  end
  inherited StatusBar1: TStatusBar
    Top = 406
    Width = 556
  end
  object cdsOrders: TADClientDataSet
    CachedUpdates = True
    IndexFieldNames = 'OrderID'
    Adapter = ADTableAdapter1
    Left = 424
    Top = 176
  end
  object DataSource1: TDataSource
    DataSet = cdsOrders
    OnDataChange = DataSource1DataChange
    Left = 456
    Top = 176
  end
  object ADTableAdapter1: TADTableAdapter
    SelectCommand = ADCommand1
    Left = 393
    Top = 176
  end
  object ADCommand1: TADCommand
    Connection = dmlMainComp.dbMain
    CommandText.Strings = (
      'select * from {id Orders}')
    Left = 425
    Top = 211
  end
end
