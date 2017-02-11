inherited frmCloneCursor: TfrmCloneCursor
  Left = 267
  Top = 151
  Width = 695
  Height = 526
  Caption = 'CloneCursor'
  Font.Name = 'MS Sans Serif'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    Width = 687
    Height = 442
    inherited pnlBorder: TPanel
      Width = 679
      Height = 434
      inherited pnlTitle: TPanel
        Width = 677
        inherited lblTitle: TLabel
          Width = 133
          Caption = 'Clone Cursor'
        end
        inherited imgAnyDAC: TImage
          Left = 380
        end
        inherited imgGradient: TImage
          Left = 323
        end
        inherited pnlBottom: TPanel
          Width = 677
        end
      end
      inherited pnlMain: TPanel
        Width = 677
        Height = 379
        inherited pnlConnection: TPanel
          Width = 677
          Height = 58
          TabOrder = 1
          inherited lblUseConnectionDef: TLabel
            Width = 126
          end
          object mmHint: TMemo
            Left = 232
            Top = 0
            Width = 445
            Height = 58
            Align = alRight
            BevelInner = bvSpace
            BevelKind = bkFlat
            BorderStyle = bsNone
            Color = clInfoBk
            Lines.Strings = (
              
                'The following example uses a cloned dataset to determine whether' +
                ' the current record is within'
              
                'a specified range. Using the cloned dataset the application may ' +
                'have few "views" of the '
              'same data.'
              '')
            ReadOnly = True
            TabOrder = 1
          end
        end
        object Panel1: TPanel
          Left = 0
          Top = 58
          Width = 677
          Height = 321
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          object Splitter1: TSplitter
            Left = 353
            Top = 36
            Height = 285
          end
          object DBGrid1: TDBGrid
            Left = 0
            Top = 36
            Width = 353
            Height = 285
            Align = alLeft
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
          object DBGrid2: TDBGrid
            Left = 356
            Top = 36
            Width = 321
            Height = 285
            Align = alClient
            BorderStyle = bsNone
            Ctl3D = True
            DataSource = DataSource2
            ParentCtl3D = False
            TabOrder = 1
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'MS Sans Serif'
            TitleFont.Style = []
          end
          object Panel2: TPanel
            Left = 0
            Top = 0
            Width = 677
            Height = 36
            Align = alTop
            BevelOuter = bvNone
            ParentColor = True
            TabOrder = 2
            object btnClone: TSpeedButton
              Left = 11
              Top = 8
              Width = 76
              Height = 21
              Caption = 'CloneCursor'
              Flat = True
              OnClick = btnCloneClick
            end
            object btnCheck: TSpeedButton
              Left = 100
              Top = 8
              Width = 76
              Height = 21
              Caption = 'CheckRange'
              Flat = True
              OnClick = btnCheckClick
            end
            object btnCancelRange: TSpeedButton
              Left = 191
              Top = 8
              Width = 76
              Height = 21
              Caption = 'CancelRange'
              Flat = True
              OnClick = btnCancelRangeClick
            end
            object edtEnd: TLabeledEdit
              Left = 587
              Top = 8
              Width = 75
              Height = 21
              BevelInner = bvSpace
              BevelKind = bkFlat
              BorderStyle = bsNone
              Ctl3D = True
              EditLabel.Width = 98
              EditLabel.Height = 13
              EditLabel.Caption = 'End range (OrderID):'
              LabelPosition = lpLeft
              ParentCtl3D = False
              TabOrder = 1
            end
            object edtStart: TLabeledEdit
              Left = 404
              Top = 8
              Width = 75
              Height = 21
              BevelInner = bvSpace
              BevelKind = bkFlat
              BorderStyle = bsNone
              Ctl3D = True
              EditLabel.Width = 101
              EditLabel.Height = 13
              EditLabel.Caption = 'Start range (OrderID):'
              LabelPosition = lpLeft
              ParentCtl3D = False
              TabOrder = 0
            end
          end
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 442
    Width = 687
    inherited btnClose: TButton
      Left = 608
    end
  end
  inherited StatusBar1: TStatusBar
    Top = 473
    Width = 687
  end
  object cdsOrders: TADClientDataSet
    Indexes = <
      item
        Active = True
        Selected = True
        Name = 'OrderID'
        Fields = 'OrderID'
      end>
    IndexName = 'OrderID'
    CachedUpdates = True
    Adapter = ADTableAdapter1
    Left = 88
    Top = 200
  end
  object DataSource1: TDataSource
    DataSet = cdsOrders
    Left = 120
    Top = 200
  end
  object cdsClone: TADClientDataSet
    Left = 440
    Top = 200
  end
  object DataSource2: TDataSource
    DataSet = cdsClone
    Left = 472
    Top = 200
  end
  object ADTableAdapter1: TADTableAdapter
    SelectCommand = ADCommand1
    Left = 57
    Top = 200
  end
  object ADCommand1: TADCommand
    Connection = dmlMainComp.dbMain
    CommandText.Strings = (
      'select * from {id Orders}')
    Left = 88
    Top = 234
  end
end
