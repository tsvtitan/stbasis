inherited frmBatch: TfrmBatch
  Left = 372
  Top = 221
  Caption = 'Batch executing'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    inherited pnlBorder: TPanel
      inherited pnlTitle: TPanel
        inherited lblTitle: TLabel
          Width = 169
          Caption = 'Batch Executing'
        end
      end
      inherited pnlMain: TPanel
        inherited pnlSubPageControl: TPanel
          inherited pcMain: TADGUIxFormsPageControl
            ActivePage = tsData
            inherited tsData: TTabSheet
              object DBGrid1: TDBGrid
                Left = 0
                Top = 73
                Width = 610
                Height = 293
                Align = alClient
                BorderStyle = bsNone
                Ctl3D = True
                DataSource = DataSource1
                ParentCtl3D = False
                TabOrder = 0
                TitleFont.Charset = DEFAULT_CHARSET
                TitleFont.Color = clWindowText
                TitleFont.Height = -11
                TitleFont.Name = 'Tahoma'
                TitleFont.Style = []
              end
              object pnlControlButtons: TPanel
                Left = 0
                Top = 0
                Width = 610
                Height = 73
                Align = alTop
                BevelOuter = bvNone
                ParentColor = True
                TabOrder = 1
                object btnExecSQL: TSpeedButton
                  Left = 10
                  Top = 39
                  Width = 76
                  Height = 21
                  Caption = 'ExecSQL'
                  Enabled = False
                  Flat = True
                  OnClick = btnExecSQLClick
                end
                object btnDisconnect: TSpeedButton
                  Left = 109
                  Top = 39
                  Width = 76
                  Height = 21
                  Caption = 'Disconnect'
                  Enabled = False
                  Flat = True
                  OnClick = btnDisconnectClick
                end
                object cbxInsertBlob: TCheckBox
                  Left = 184
                  Top = 10
                  Width = 81
                  Height = 17
                  Caption = 'insert blob'
                  TabOrder = 0
                  OnClick = cbxInsertBlobClick
                end
                object cbxBatchExec: TCheckBox
                  Left = 276
                  Top = 10
                  Width = 97
                  Height = 17
                  Caption = 'batch executing'
                  Checked = True
                  State = cbChecked
                  TabOrder = 1
                end
                object edtArraySize: TLabeledEdit
                  Left = 66
                  Top = 8
                  Width = 99
                  Height = 21
                  BevelInner = bvSpace
                  BevelKind = bkFlat
                  BorderStyle = bsNone
                  EditLabel.Width = 52
                  EditLabel.Height = 13
                  EditLabel.Caption = 'Array size:'
                  LabelPosition = lpLeft
                  TabOrder = 2
                  Text = '10000'
                end
              end
            end
          end
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 561
  end
  inherited StatusBar1: TStatusBar
    Top = 592
  end
  object qryBatch: TADQuery
    Connection = dmlMainComp.dbMain
    FetchOptions.Items = [fiBlobs, fiDetails]
    SQL.Strings = (
      
        'insert into {id ADQA_Batch_test}(tint, tstring, tblob) values(:f' +
        '1, :f2, :f3)')
    Left = 300
    Top = 267
    ParamData = <
      item
        Name = 'F1'
        ParamType = ptInput
      end
      item
        Name = 'F2'
        ParamType = ptInput
      end
      item
        Name = 'F3'
        ParamType = ptInput
      end>
  end
  object DataSource1: TDataSource
    DataSet = qrySelect
    Left = 340
    Top = 267
  end
  object qrySelect: TADQuery
    Connection = dmlMainComp.dbMain
    FetchOptions.Items = [fiBlobs, fiDetails]
    SQL.Strings = (
      'select * from {id ADQA_Batch_test}')
    Left = 300
    Top = 307
  end
end
