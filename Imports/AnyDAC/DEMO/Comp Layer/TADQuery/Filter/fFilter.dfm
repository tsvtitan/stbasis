inherited frmFilter: TfrmFilter
  Left = 363
  Top = 105
  Width = 530
  Height = 644
  Caption = 'Filter in ADQuery'
  Font.Name = 'MS Sans Serif'
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    Width = 522
    Height = 560
    inherited pnlBorder: TPanel
      Width = 514
      Height = 552
      inherited pnlTitle: TPanel
        Width = 512
        inherited lblTitle: TLabel
          Width = 54
          Caption = 'Filter'
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
        Height = 497
        inherited pnlConnection: TPanel
          Width = 512
          inherited lblUseConnectionDef: TLabel
            Width = 126
          end
        end
        inherited pnlSubPageControl: TPanel
          Width = 512
          Height = 438
          inherited pcMain: TADGUIxFormsPageControl
            Width = 512
            Height = 437
            ActivePage = tsData
            inherited tsData: TTabSheet
              object DBGrid1: TDBGrid
                Left = 0
                Top = 121
                Width = 504
                Height = 244
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
                Top = 0
                Width = 504
                Height = 121
                Align = alTop
                BevelOuter = bvNone
                ParentColor = True
                TabOrder = 1
                object btnFilter1: TSpeedButton
                  Left = 11
                  Top = 38
                  Width = 94
                  Height = 21
                  Caption = 'Using date field 1'
                  Flat = True
                  OnClick = btnFilter1Click
                end
                object btnFilter2: TSpeedButton
                  Left = 11
                  Top = 62
                  Width = 94
                  Height = 21
                  Caption = 'Using date field 2'
                  Flat = True
                  OnClick = btnFilter2Click
                end
                object btnFilter3: TSpeedButton
                  Left = 109
                  Top = 38
                  Width = 92
                  Height = 21
                  Caption = 'Using BETWEEN'
                  Flat = True
                  OnClick = btnFilter3Click
                end
                object btnFilter4: TSpeedButton
                  Left = 204
                  Top = 38
                  Width = 76
                  Height = 21
                  Caption = 'Using LIKE'
                  Flat = True
                  OnClick = btnFilter4Click
                end
                object btnFilter6: TSpeedButton
                  Left = 386
                  Top = 12
                  Width = 55
                  Height = 21
                  Caption = 'Set'
                  Flat = True
                  Glyph.Data = {
                    36050000424D3605000000000000360400002800000010000000100000000100
                    08000000000000010000520B0000520B000000010000000100002D2D2D001855
                    6F004544420058534E005160610054777B007C707800B56D3E00C1713500C076
                    38008A5B5200947E7500AD7B7300BD847B00EFA65A00EDA75F00F0A85C00C694
                    7B0000009A000316AC0041749600477AA9000018C6001029D600106BFF00FF00
                    FF0035A8F5004A9EED006D8AFD00B5848400BD9494009891A200C6A59C00F1BC
                    8600C6ADA500C6ADAD00CEB5AD00D6B5AD00C6B5B500D6BDB500DEBDB500F8C2
                    8C00F9C48D00EFCE9400EFCE9C00F7D69C00DEC6B500D6C6BD00EFD6AD00F7D6
                    A500FBD3A900E7C6B500EFCEB500EFCEBD00F7DEB500F7DEBD00C6C6C600E7CE
                    CE00E7D6CE00F7E7C600FFEFD600FFEFE700FFF7E700FFF7EF00FFF7F700FFFF
                    F700FFFFFF000000000000000000000000000000000000000000000000000000
                    0000000000000000000000000000000000000000000000000000000000000000
                    0000000000000000000000000000000000000000000000000000000000000000
                    0000000000000000000000000000000000000000000000000000000000000000
                    0000000000000000000000000000000000000000000000000000000000000000
                    0000000000000000000000000000000000000000000000000000000000000000
                    0000000000000000000000000000000000000000000000000000000000000000
                    0000000000000000000000000000000000000000000000000000000000000000
                    0000000000000000000000000000000000000000000000000000000000000000
                    0000000000000000000000000000000000000000000000000000000000000000
                    0000000000000000000000000000000000000000000000000000000000000000
                    0000000000000000000000000000000000000000000000000000000000000000
                    0000000000000000000000000000000000000000000000000000000000000000
                    0000000000000000000000000000000000000000000000000000000000000000
                    0000000000000000000000000000000000000000000000000000000000000000
                    0000000000000000000000000000000000000000000000000000000000000000
                    0000000000000000000000000000000000000000000000000000000000000000
                    0000000000000000000000000000000000000000000000000000000000000000
                    0000000000000000000000000000000000000000000000000000000000000000
                    0000000000000000000000000000000000000000000000000000000000000000
                    0000000000000000000000000000000000000000000000000000000000000000
                    0000000000000000000000000000000000000000000000000000000000000000
                    0000000000000000000000000000000000000000000000000000000000000000
                    000000000000000000000000000000000000000000000000000019191D1D1D1D
                    1D1D1D1D1D1D1D1D1D191919203C3B373630312C2B2B2B2D1D191919203C3838
                    383838383838382C1D191919223D00032F37302C2C2C2B2C1D191919223E0302
                    042F36302C2C2C2B1D1919192441380515010A263838382C1D19191925423F05
                    140B080A2F3030301D1919192742403F062110090A2F30301D19191927423838
                    0C322A0E090A262F1E19191928424242400C322A10080A2F231919192E424242
                    42400C32290F070A26191919334238383838380C321F1A131219191933424242
                    424242410C1B17171312191935424242424242423A161C181719191933403F3F
                    3F3F3F3F39111616191919193334343434333334270D19191919}
                  OnClick = btnFilter6Click
                end
                object btnFilter5: TSpeedButton
                  Left = 109
                  Top = 62
                  Width = 171
                  Height = 21
                  Caption = 'Using OnFilterRecord'
                  Flat = True
                  OnClick = btnFilter5Click
                end
                object edtExample: TEdit
                  Left = 11
                  Top = 12
                  Width = 367
                  Height = 21
                  BevelInner = bvSpace
                  BevelKind = bkFlat
                  BorderStyle = bsNone
                  TabOrder = 0
                end
                object mmInfo: TMemo
                  Left = 0
                  Top = 88
                  Width = 504
                  Height = 33
                  Align = alBottom
                  BevelInner = bvSpace
                  BevelKind = bkFlat
                  BorderStyle = bsNone
                  Color = clInfoBk
                  Lines.Strings = (
                    
                      'You can see the filter examples pushing the buttons '#39'Using ...'#39' ' +
                      'or type filter property value by hands in the '
                    'Edit and press '#39'Set'#39' button')
                  TabOrder = 1
                end
              end
            end
            inherited tsOptions: TTabSheet
              inherited ADGUIxFormsPanelTree1: TADGUIxFormsPanelTree
                Width = 504
                Height = 324
                inherited frmUpdateOptions: TfrmADGUIxFormsUpdateOptions
                  Width = 500
                  Height = 320
                end
                inherited frmResourceOptions: TfrmADGUIxFormsResourceOptions
                  Width = 500
                  Height = 320
                end
                inherited frmFormatOptions: TfrmADGUIxFormsFormatOptions
                  Width = 500
                  Height = 320
                end
                inherited frmFetchOptions: TfrmADGUIxFormsFetchOptions
                  Width = 500
                  Height = 320
                end
              end
              inherited pnlDataSet: TPanel
                Width = 504
                inherited lblDataSet: TLabel
                  Left = 7
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
    Top = 560
    Width = 522
    inherited btnClose: TButton
      Left = 443
    end
  end
  inherited StatusBar1: TStatusBar
    Top = 591
    Width = 522
  end
  object qryWithFilter: TADQuery
    Filtered = True
    Connection = dmlMainComp.dbMain
    FetchOptions.Items = [fiBlobs, fiDetails]
    SQL.Strings = (
      'select * from {id Orders}')
    Left = 320
    Top = 328
  end
  object DataSource1: TDataSource
    DataSet = qryWithFilter
    Left = 360
    Top = 328
  end
end
