inherited frmMacros: TfrmMacros
  Left = 352
  Top = 92
  Width = 596
  Height = 656
  Caption = 'Macros using Demo'
  Font.Name = 'MS Sans Serif'
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    Width = 588
    Height = 572
    inherited pnlBorder: TPanel
      Width = 580
      Height = 564
      inherited pnlTitle: TPanel
        Width = 578
        inherited lblTitle: TLabel
          Width = 76
          Caption = 'Macros'
        end
        inherited imgAnyDAC: TImage
          Left = 281
        end
        inherited imgGradient: TImage
          Left = 224
        end
        inherited pnlBottom: TPanel
          Width = 578
        end
      end
      inherited pnlMain: TPanel
        Width = 578
        Height = 509
        inherited pnlConnection: TPanel
          Width = 578
          inherited lblUseConnectionDef: TLabel
            Width = 126
          end
        end
        inherited pnlSubPageControl: TPanel
          Width = 578
          Height = 450
          inherited pcMain: TADGUIxFormsPageControl
            Width = 578
            Height = 449
            ActivePage = tsData
            inherited tsData: TTabSheet
              object Bevel1: TBevel
                Left = 0
                Top = 169
                Width = 570
                Height = 4
                Align = alTop
                Shape = bsTopLine
              end
              object DBGrid1: TDBGrid
                Left = 0
                Top = 197
                Width = 570
                Height = 180
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
              object mmSQL: TMemo
                Left = 0
                Top = 173
                Width = 570
                Height = 24
                Align = alTop
                BevelInner = bvSpace
                BevelKind = bkFlat
                BorderStyle = bsNone
                Color = clInfoBk
                Lines.Strings = (
                  '')
                ReadOnly = True
                TabOrder = 3
              end
              object Panel1: TPanel
                Left = 0
                Top = 0
                Width = 570
                Height = 129
                Align = alTop
                BevelOuter = bvNone
                ParentColor = True
                TabOrder = 1
                object mmComment: TMemo
                  Left = 277
                  Top = 0
                  Width = 293
                  Height = 129
                  Align = alClient
                  BevelInner = bvSpace
                  BevelKind = bkFlat
                  BorderStyle = bsNone
                  Color = clInfoBk
                  Lines.Strings = (
                    'The Macros allows you to parameterize parts of SQL query,'
                    'where RDBMS prohibits parameter usage. Macro values are'
                    'substituted in place of their names in SQL text at Prepare'
                    'call, so RDBMS does not see Macros. Change macro values'
                    'and DataType, then click '#39'Open Query'#39'.'
                    '')
                  ReadOnly = True
                  TabOrder = 1
                end
                object lstMacros: TValueListEditor
                  Left = 0
                  Top = 0
                  Width = 277
                  Height = 129
                  Align = alLeft
                  BorderStyle = bsNone
                  DisplayOptions = [doColumnTitles, doKeyColFixed]
                  ScrollBars = ssNone
                  Strings.Strings = (
                    'Column='
                    'Tab='
                    'Id='
                    'Sign='
                    'IdValue=')
                  TabOrder = 0
                  TitleCaptions.Strings = (
                    'Macros'
                    'Value')
                  OnSelectCell = lstMacrosSelectCell
                  ColWidths = (
                    62
                    214)
                end
              end
              object Panel2: TPanel
                Left = 0
                Top = 129
                Width = 570
                Height = 40
                Align = alTop
                BevelOuter = bvNone
                ParentColor = True
                TabOrder = 2
                object btnOpenQuery: TSpeedButton
                  Left = 221
                  Top = 8
                  Width = 76
                  Height = 21
                  Caption = 'Open Query'
                  Enabled = False
                  Flat = True
                  OnClick = btnOpenQueryClick
                end
                object lblDataType: TLabel
                  Left = 11
                  Top = 11
                  Width = 50
                  Height = 13
                  Alignment = taRightJustify
                  Caption = 'DataType:'
                end
                object cbDataType: TComboBox
                  Left = 64
                  Top = 8
                  Width = 137
                  Height = 21
                  BevelInner = bvSpace
                  BevelKind = bkFlat
                  BevelOuter = bvRaised
                  Style = csDropDownList
                  ItemHeight = 13
                  TabOrder = 0
                  OnChange = cbDataTypeChange
                  Items.Strings = (
                    'mdUnknown '
                    'mdString'
                    'mdIdentifier'
                    'mdInteger'
                    'mdBoolean'
                    'mdFloat'
                    'mdDate'
                    'mdTime'
                    'mdDateTime'
                    'mdRaw')
                end
              end
            end
            inherited tsOptions: TTabSheet
              inherited ADGUIxFormsPanelTree1: TADGUIxFormsPanelTree
                Width = 570
                Height = 336
                inherited frmUpdateOptions: TfrmADGUIxFormsUpdateOptions
                  Width = 566
                  Height = 332
                end
                inherited frmResourceOptions: TfrmADGUIxFormsResourceOptions
                  Width = 566
                  Height = 332
                end
                inherited frmFormatOptions: TfrmADGUIxFormsFormatOptions
                  Width = 566
                  Height = 332
                end
                inherited frmFetchOptions: TfrmADGUIxFormsFetchOptions
                  Width = 566
                  Height = 332
                end
              end
              inherited pnlDataSet: TPanel
                Width = 570
                inherited lblDataSet: TLabel
                  Left = 7
                  Width = 40
                end
              end
            end
          end
          inherited pnlMainSep: TPanel
            Width = 578
          end
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 572
    Width = 588
    inherited btnClose: TButton
      Left = 518
      Width = 66
    end
  end
  inherited StatusBar1: TStatusBar
    Top = 603
    Width = 588
  end
  object qryMain: TADQuery
    Connection = dmlMainComp.dbMain
    FetchOptions.Items = [fiBlobs, fiDetails]
    SQL.Strings = (
      'select !column from !tab where !id !Sign !idValue')
    Left = 112
    Top = 432
    MacroData = <
      item
        Value = 'ADDRESS'
        Name = 'COLUMN'
        DataType = mdIdentifier
      end
      item
        Value = 'Employees'
        Name = 'TAB'
        DataType = mdIdentifier
      end
      item
        Value = 'BIRTHDATE'
        Name = 'ID'
        DataType = mdIdentifier
      end
      item
        Value = '>'
        Name = 'Sign'
      end
      item
        Value = '1948-10-01'
        Name = 'IDVALUE'
        DataType = mdDate
      end>
  end
  object DataSource1: TDataSource
    DataSet = qryMain
    Left = 152
    Top = 432
  end
end
