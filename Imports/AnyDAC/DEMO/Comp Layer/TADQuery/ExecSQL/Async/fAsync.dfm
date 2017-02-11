inherited frmAsync: TfrmAsync
  Left = 265
  Top = 139
  Width = 554
  Height = 649
  Caption = 'Async ExecSQL'
  Font.Name = 'MS Sans Serif'
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    Width = 546
    Height = 565
    inherited pnlBorder: TPanel
      Width = 538
      Height = 557
      inherited pnlTitle: TPanel
        Width = 536
        inherited imgAnyDAC: TImage [0]
          Left = 236
        end
        inherited imgGradient: TImage [1]
          Left = 179
        end
        inherited lblTitle: TLabel [2]
          Width = 170
          Caption = 'Async Execution'
        end
        inherited pnlBottom: TPanel
          Width = 536
        end
      end
      inherited pnlMain: TPanel
        Width = 536
        Height = 502
        inherited pnlConnection: TPanel
          Width = 536
          inherited lblUseConnectionDef: TLabel
            Width = 126
          end
        end
        inherited pnlSubPageControl: TPanel
          Width = 536
          Height = 443
          inherited pcMain: TADGUIxFormsPageControl
            Width = 536
            Height = 442
            ActivePage = tsData
            inherited tsData: TTabSheet
              object mmExample: TMemo
                Left = 0
                Top = 41
                Width = 528
                Height = 33
                Align = alTop
                BevelInner = bvSpace
                BevelKind = bkFlat
                BorderStyle = bsNone
                Color = clInfoBk
                Enabled = False
                TabOrder = 1
              end
              object DBGrid1: TDBGrid
                Left = 0
                Top = 74
                Width = 528
                Height = 296
                Align = alClient
                BorderStyle = bsNone
                Ctl3D = True
                DataSource = DataSource1
                ParentCtl3D = False
                ReadOnly = True
                TabOrder = 0
                TitleFont.Charset = DEFAULT_CHARSET
                TitleFont.Color = clWindowText
                TitleFont.Height = -11
                TitleFont.Name = 'MS Sans Serif'
                TitleFont.Style = []
              end
              object Panel1: TPanel
                Left = 0
                Top = 0
                Width = 528
                Height = 41
                Align = alTop
                BevelOuter = bvNone
                ParentColor = True
                TabOrder = 2
                object btnExec: TSpeedButton
                  Left = 11
                  Top = 11
                  Width = 112
                  Height = 21
                  Caption = 'Exec sql command'
                  Flat = True
                  OnClick = btnExecClick
                end
                object btnExecCancelDlg: TSpeedButton
                  Left = 134
                  Top = 11
                  Width = 170
                  Height = 21
                  Caption = 'Execute/Open with CancelDialog'
                  Flat = True
                  OnClick = btnExecCancelDlgClick
                end
                object btnAsyncExec: TSpeedButton
                  Left = 314
                  Top = 11
                  Width = 138
                  Height = 21
                  Caption = 'Async executing/opening'
                  Flat = True
                  OnClick = btnAsyncExecClick
                end
              end
            end
            inherited tsOptions: TTabSheet
              inherited ADGUIxFormsPanelTree1: TADGUIxFormsPanelTree
                Width = 528
                Height = 329
                inherited frmUpdateOptions: TfrmADGUIxFormsUpdateOptions
                  Width = 524
                  Height = 325
                end
                inherited frmResourceOptions: TfrmADGUIxFormsResourceOptions
                  Width = 524
                  Height = 325
                end
                inherited frmFormatOptions: TfrmADGUIxFormsFormatOptions
                  Width = 524
                  Height = 325
                end
                inherited frmFetchOptions: TfrmADGUIxFormsFetchOptions
                  Width = 524
                  Height = 325
                end
              end
              inherited pnlDataSet: TPanel
                Width = 528
                inherited lblDataSet: TLabel
                  Left = 7
                  Width = 40
                end
              end
            end
          end
          inherited pnlMainSep: TPanel
            Width = 536
          end
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 565
    Width = 546
    inherited btnClose: TButton
      Left = 467
    end
  end
  inherited StatusBar1: TStatusBar
    Top = 596
    Width = 546
  end
  object qryExecSQL: TADQuery
    Constraints = <
      item
        FromDictionary = False
      end>
    Connection = dmlMainComp.dbMain
    FetchOptions.Items = [fiBlobs, fiDetails]
    Left = 368
    Top = 356
  end
  object DataSource1: TDataSource
    DataSet = qryExecSQL
    Left = 412
    Top = 355
  end
end
