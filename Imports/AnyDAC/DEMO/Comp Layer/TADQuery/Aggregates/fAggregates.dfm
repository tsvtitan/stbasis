inherited frmAggregates: TfrmAggregates
  Left = 439
  Top = 144
  Width = 512
  Height = 639
  Caption = 'Aggregates'
  Font.Name = 'MS Sans Serif'
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    Width = 504
    Height = 555
    inherited pnlBorder: TPanel
      Width = 496
      Height = 547
      inherited pnlTitle: TPanel
        Width = 494
        inherited lblTitle: TLabel
          Width = 119
          Caption = 'Aggregates'
        end
        inherited imgAnyDAC: TImage
          Left = 197
        end
        inherited imgGradient: TImage
          Left = 140
        end
        inherited pnlBottom: TPanel
          Width = 494
        end
      end
      inherited pnlMain: TPanel
        Width = 494
        Height = 492
        inherited pnlConnection: TPanel
          Width = 494
          inherited lblUseConnectionDef: TLabel
            Width = 126
          end
        end
        inherited pnlSubPageControl: TPanel
          Width = 494
          Height = 433
          inherited pcMain: TADGUIxFormsPageControl
            Width = 494
            Height = 432
            ActivePage = tsData
            inherited tsData: TTabSheet
              object Panel1: TPanel
                Left = 0
                Top = 0
                Width = 486
                Height = 153
                Align = alTop
                BevelOuter = bvNone
                ParentColor = True
                TabOrder = 0
                object edtUser: TLabeledEdit
                  Left = 85
                  Top = 95
                  Width = 121
                  Height = 21
                  BevelInner = bvSpace
                  BevelKind = bkFlat
                  BorderStyle = bsNone
                  EditLabel.Width = 18
                  EditLabel.Height = 13
                  EditLabel.Caption = 'Try:'
                  LabelPosition = lpLeft
                  TabOrder = 0
                  OnKeyPress = edtUserKeyPress
                end
                object edtMax: TLabeledEdit
                  Left = 85
                  Top = 68
                  Width = 121
                  Height = 21
                  BevelInner = bvSpace
                  BevelKind = bkFlat
                  BorderStyle = bsNone
                  EditLabel.Width = 72
                  EditLabel.Height = 13
                  EditLabel.Caption = 'Max(OrderID)= '
                  LabelPosition = lpLeft
                  ReadOnly = True
                  TabOrder = 1
                end
                object edtAvg: TLabeledEdit
                  Left = 320
                  Top = 67
                  Width = 121
                  Height = 21
                  BevelInner = bvSpace
                  BevelKind = bkFlat
                  BorderStyle = bsNone
                  EditLabel.Width = 69
                  EditLabel.Height = 13
                  EditLabel.Caption = 'Avg(Freight) = '
                  LabelPosition = lpLeft
                  ReadOnly = True
                  TabOrder = 2
                end
                object edtSum: TLabeledEdit
                  Left = 320
                  Top = 95
                  Width = 121
                  Height = 21
                  BevelInner = bvSpace
                  BevelKind = bkFlat
                  BorderStyle = bsNone
                  EditLabel.Width = 71
                  EditLabel.Height = 13
                  EditLabel.Caption = 'Sum(Freight) = '
                  LabelPosition = lpLeft
                  ReadOnly = True
                  TabOrder = 4
                end
                object edtUsrRes: TLabeledEdit
                  Left = 85
                  Top = 123
                  Width = 121
                  Height = 21
                  BevelInner = bvSpace
                  BevelKind = bkFlat
                  BorderStyle = bsNone
                  EditLabel.Width = 42
                  EditLabel.Height = 13
                  EditLabel.Caption = 'Result = '
                  LabelPosition = lpLeft
                  TabOrder = 3
                end
                object Memo1: TMemo
                  Left = 0
                  Top = 0
                  Width = 486
                  Height = 57
                  Align = alTop
                  BevelInner = bvSpace
                  BevelKind = bkFlat
                  BorderStyle = bsNone
                  Color = clInfoBk
                  Lines.Strings = (
                    
                      'Type an aggregate expression in the "Try" edit box and press Ent' +
                      'er for evaluation.'
                    
                      'Also, see qryAggregates.Aggregates collection, where already are' +
                      ' defined 3 items.')
                  TabOrder = 5
                end
              end
              object DBGrid1: TDBGrid
                Left = 0
                Top = 153
                Width = 486
                Height = 207
                Align = alClient
                BorderStyle = bsNone
                Ctl3D = True
                DataSource = DataSource1
                ParentCtl3D = False
                TabOrder = 1
                TitleFont.Charset = DEFAULT_CHARSET
                TitleFont.Color = clWindowText
                TitleFont.Height = -11
                TitleFont.Name = 'MS Sans Serif'
                TitleFont.Style = []
              end
            end
            inherited tsOptions: TTabSheet
              inherited ADGUIxFormsPanelTree1: TADGUIxFormsPanelTree
                Width = 486
                Height = 319
                inherited frmUpdateOptions: TfrmADGUIxFormsUpdateOptions
                  Width = 482
                  Height = 315
                end
                inherited frmResourceOptions: TfrmADGUIxFormsResourceOptions
                  Width = 482
                  Height = 315
                end
                inherited frmFormatOptions: TfrmADGUIxFormsFormatOptions
                  Width = 482
                  Height = 315
                end
                inherited frmFetchOptions: TfrmADGUIxFormsFetchOptions
                  Width = 482
                  Height = 315
                end
              end
              inherited pnlDataSet: TPanel
                Width = 486
                inherited lblDataSet: TLabel
                  Left = 7
                  Width = 40
                end
              end
            end
          end
          inherited pnlMainSep: TPanel
            Width = 494
          end
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 555
    Width = 504
    inherited btnClose: TButton
      Left = 425
    end
  end
  inherited StatusBar1: TStatusBar
    Top = 586
    Width = 504
  end
  object qryAggregates: TADQuery
    Aggregates = <
      item
        Name = 'Avg of Freight'
        Expression = 'Avg(Freight)'
        Active = True
      end
      item
        Name = 'Sum of Freight'
        Expression = 'Sum(Freight)'
        Active = True
      end
      item
        Name = 'Max of OrderID'
        Expression = 'Max(OrderID)'
        Active = True
      end
      item
        Name = 'User'
      end>
    AggregatesActive = True
    Connection = dmlMainComp.dbMain
    FetchOptions.Items = [fiBlobs, fiDetails]
    SQL.Strings = (
      'select * from {id Orders}')
    Left = 256
    Top = 344
  end
  object DataSource1: TDataSource
    DataSet = qryAggregates
    OnDataChange = DataSource1DataChange
    Left = 288
    Top = 344
  end
end
