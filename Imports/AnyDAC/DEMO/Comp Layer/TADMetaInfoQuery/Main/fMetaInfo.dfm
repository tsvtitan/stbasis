inherited frmMetaInfo: TfrmMetaInfo
  Top = 180
  Height = 605
  Caption = 'MetaInfo xRDBMS demo'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    Height = 528
    inherited pnlBorder: TPanel
      Height = 520
      inherited pnlTitle: TPanel
        inherited lblTitle: TLabel
          Width = 97
          Caption = 'MetaInfo'
        end
      end
      inherited pnlMain: TPanel
        Height = 465
        inherited pnlConnection: TPanel
          inherited cbDB: TComboBox
            TabOrder = 1
          end
          object mmInfo: TMemo
            Left = 395
            Top = 0
            Width = 223
            Height = 57
            TabStop = False
            Align = alRight
            BevelInner = bvSpace
            BevelKind = bkFlat
            BorderStyle = bsNone
            Color = clInfoBk
            Lines.Strings = (
              'In case of MSAccess error will be raised on '
              'getting structure of some of system tables '
              '(MSysACEs, MSysObjects, etc).')
            ReadOnly = True
            TabOrder = 0
          end
        end
        object pcMain: TPageControl
          Left = 0
          Top = 57
          Width = 618
          Height = 408
          ActivePage = tsData
          Align = alClient
          Style = tsFlatButtons
          TabOrder = 1
          object tsData: TTabSheet
            Caption = 'Data'
            object PageControl1: TPageControl
              Left = 0
              Top = 0
              Width = 610
              Height = 377
              ActivePage = TabSheet1
              Align = alClient
              Style = tsFlatButtons
              TabOrder = 0
              object TabSheet1: TTabSheet
                Caption = 'Tables'
                object Splitter1: TSplitter
                  Left = 0
                  Top = 120
                  Width = 602
                  Height = 3
                  Cursor = crVSplit
                  Align = alTop
                end
                object dbgTables: TDBGrid
                  Left = 0
                  Top = 0
                  Width = 602
                  Height = 120
                  Align = alTop
                  Ctl3D = False
                  DataSource = dsTables
                  ParentCtl3D = False
                  TabOrder = 0
                  TitleFont.Charset = DEFAULT_CHARSET
                  TitleFont.Color = clWindowText
                  TitleFont.Height = -11
                  TitleFont.Name = 'Tahoma'
                  TitleFont.Style = []
                end
                object PageControl2: TPageControl
                  Left = 0
                  Top = 123
                  Width = 602
                  Height = 223
                  ActivePage = TabSheet4
                  Align = alClient
                  Style = tsFlatButtons
                  TabOrder = 1
                  object TabSheet4: TTabSheet
                    Caption = 'Fields'
                    object dbgFields: TDBGrid
                      Left = 0
                      Top = 0
                      Width = 594
                      Height = 192
                      Align = alClient
                      Ctl3D = False
                      DataSource = dsFields
                      ParentCtl3D = False
                      TabOrder = 0
                      TitleFont.Charset = DEFAULT_CHARSET
                      TitleFont.Color = clWindowText
                      TitleFont.Height = -11
                      TitleFont.Name = 'Tahoma'
                      TitleFont.Style = []
                    end
                  end
                  object TabSheet5: TTabSheet
                    Caption = 'Indexes'
                    ImageIndex = 1
                    object Splitter2: TSplitter
                      Left = 0
                      Top = 81
                      Width = 433
                      Height = 3
                      Cursor = crVSplit
                      Align = alTop
                    end
                    object dbgIndexes: TDBGrid
                      Left = 0
                      Top = 0
                      Width = 433
                      Height = 81
                      Align = alTop
                      DataSource = dsIndexes
                      TabOrder = 0
                      TitleFont.Charset = DEFAULT_CHARSET
                      TitleFont.Color = clWindowText
                      TitleFont.Height = -11
                      TitleFont.Name = 'Tahoma'
                      TitleFont.Style = []
                    end
                    object dbgIndexFields: TDBGrid
                      Left = 0
                      Top = 84
                      Width = 433
                      Height = 110
                      Align = alClient
                      DataSource = dsIndexFields
                      TabOrder = 1
                      TitleFont.Charset = DEFAULT_CHARSET
                      TitleFont.Color = clWindowText
                      TitleFont.Height = -11
                      TitleFont.Name = 'Tahoma'
                      TitleFont.Style = []
                    end
                  end
                  object TabSheet6: TTabSheet
                    Caption = 'PK'#39's'
                    ImageIndex = 2
                    object Splitter3: TSplitter
                      Left = 0
                      Top = 81
                      Width = 433
                      Height = 3
                      Cursor = crVSplit
                      Align = alTop
                    end
                    object dbgPrimaryKeys: TDBGrid
                      Left = 0
                      Top = 0
                      Width = 433
                      Height = 81
                      Align = alTop
                      DataSource = dsPrimaryKeys
                      TabOrder = 0
                      TitleFont.Charset = DEFAULT_CHARSET
                      TitleFont.Color = clWindowText
                      TitleFont.Height = -11
                      TitleFont.Name = 'Tahoma'
                      TitleFont.Style = []
                    end
                    object dbgPrimaryKeyFields: TDBGrid
                      Left = 0
                      Top = 84
                      Width = 433
                      Height = 97
                      Align = alClient
                      DataSource = dsPrimaryKeyFields
                      TabOrder = 1
                      TitleFont.Charset = DEFAULT_CHARSET
                      TitleFont.Color = clWindowText
                      TitleFont.Height = -11
                      TitleFont.Name = 'Tahoma'
                      TitleFont.Style = []
                    end
                  end
                end
              end
              object TabSheet2: TTabSheet
                Caption = 'Packages'
                ImageIndex = 1
                object Splitter4: TSplitter
                  Left = 0
                  Top = 120
                  Width = 510
                  Height = 3
                  Cursor = crVSplit
                  Align = alTop
                end
                object Splitter5: TSplitter
                  Left = 0
                  Top = 243
                  Width = 510
                  Height = 3
                  Cursor = crVSplit
                  Align = alTop
                end
                object dbgPackages: TDBGrid
                  Left = 0
                  Top = 0
                  Width = 510
                  Height = 120
                  Align = alTop
                  Ctl3D = False
                  DataSource = dsPackages
                  ParentCtl3D = False
                  TabOrder = 0
                  TitleFont.Charset = DEFAULT_CHARSET
                  TitleFont.Color = clWindowText
                  TitleFont.Height = -11
                  TitleFont.Name = 'Tahoma'
                  TitleFont.Style = []
                end
                object dbgPackProcs: TDBGrid
                  Left = 0
                  Top = 123
                  Width = 510
                  Height = 120
                  Align = alTop
                  Ctl3D = False
                  DataSource = dsPackProcs
                  ParentCtl3D = False
                  TabOrder = 1
                  TitleFont.Charset = DEFAULT_CHARSET
                  TitleFont.Color = clWindowText
                  TitleFont.Height = -11
                  TitleFont.Name = 'Tahoma'
                  TitleFont.Style = []
                end
                object dbgPackProcArgs: TDBGrid
                  Left = 0
                  Top = 246
                  Width = 510
                  Height = 55
                  Align = alClient
                  Ctl3D = False
                  DataSource = dsPackProcArgs
                  ParentCtl3D = False
                  TabOrder = 2
                  TitleFont.Charset = DEFAULT_CHARSET
                  TitleFont.Color = clWindowText
                  TitleFont.Height = -11
                  TitleFont.Name = 'Tahoma'
                  TitleFont.Style = []
                end
              end
              object TabSheet3: TTabSheet
                Caption = 'Procedures'
                ImageIndex = 2
                object Splitter6: TSplitter
                  Left = 0
                  Top = 120
                  Width = 510
                  Height = 3
                  Cursor = crVSplit
                  Align = alTop
                end
                object dbgProcs: TDBGrid
                  Left = 0
                  Top = 0
                  Width = 510
                  Height = 120
                  Align = alTop
                  Ctl3D = False
                  DataSource = dsProcs
                  ParentCtl3D = False
                  TabOrder = 0
                  TitleFont.Charset = DEFAULT_CHARSET
                  TitleFont.Color = clWindowText
                  TitleFont.Height = -11
                  TitleFont.Name = 'Tahoma'
                  TitleFont.Style = []
                end
                object DBGrid11: TDBGrid
                  Left = 0
                  Top = 123
                  Width = 510
                  Height = 178
                  Align = alClient
                  Ctl3D = False
                  DataSource = dsProcArgs
                  ParentCtl3D = False
                  TabOrder = 1
                  TitleFont.Charset = DEFAULT_CHARSET
                  TitleFont.Color = clWindowText
                  TitleFont.Height = -11
                  TitleFont.Name = 'Tahoma'
                  TitleFont.Style = []
                end
              end
            end
          end
          object tsOptions: TTabSheet
            Caption = 'Options'
            ImageIndex = 1
            object Label3: TLabel
              Left = 11
              Top = 10
              Width = 41
              Height = 13
              Caption = 'Catalog:'
            end
            object Label4: TLabel
              Left = 11
              Top = 36
              Width = 41
              Height = 13
              Caption = 'Schema:'
            end
            object edtCatalog: TEdit
              Left = 56
              Top = 8
              Width = 121
              Height = 21
              BevelInner = bvSpace
              BevelKind = bkFlat
              BorderStyle = bsNone
              TabOrder = 0
            end
            object edtSchema: TEdit
              Left = 56
              Top = 32
              Width = 121
              Height = 21
              BevelInner = bvSpace
              BevelKind = bkFlat
              BorderStyle = bsNone
              TabOrder = 1
            end
            object GroupBox1: TGroupBox
              Left = 11
              Top = 55
              Width = 89
              Height = 73
              Caption = 'Object scopes'
              TabOrder = 2
              object cbMy: TCheckBox
                Left = 8
                Top = 16
                Width = 65
                Height = 17
                Caption = 'My'
                Checked = True
                State = cbChecked
                TabOrder = 0
              end
              object cbOther: TCheckBox
                Left = 8
                Top = 32
                Width = 65
                Height = 17
                Caption = 'Other'
                Checked = True
                State = cbChecked
                TabOrder = 1
              end
              object cbSystem: TCheckBox
                Left = 8
                Top = 48
                Width = 65
                Height = 17
                Caption = 'System'
                Checked = True
                State = cbChecked
                TabOrder = 2
              end
            end
            object GroupBox2: TGroupBox
              Left = 105
              Top = 55
              Width = 161
              Height = 73
              Caption = 'Table kinds'
              TabOrder = 3
              object cbSynonym: TCheckBox
                Left = 8
                Top = 16
                Width = 68
                Height = 17
                Caption = 'Synonym'
                Checked = True
                State = cbChecked
                TabOrder = 0
              end
              object cbTable: TCheckBox
                Left = 8
                Top = 32
                Width = 68
                Height = 17
                Caption = 'Table'
                Checked = True
                State = cbChecked
                TabOrder = 1
              end
              object cbView: TCheckBox
                Left = 8
                Top = 48
                Width = 68
                Height = 17
                Caption = 'View'
                Checked = True
                State = cbChecked
                TabOrder = 2
              end
              object cbTempTable: TCheckBox
                Left = 80
                Top = 16
                Width = 78
                Height = 17
                Caption = 'TempTable'
                TabOrder = 3
              end
              object cbLocalTable: TCheckBox
                Left = 80
                Top = 32
                Width = 78
                Height = 17
                Caption = 'LocalTable'
                TabOrder = 4
              end
            end
          end
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 528
  end
  inherited StatusBar1: TStatusBar
    Top = 559
  end
  object miTables: TADMetaInfoQuery
    AfterOpen = miTablesAfterOpen
    Connection = dmlMainComp.dbMain
    ObjectScopes = [osMy, osOther, osSystem]
    Left = 272
    Top = 217
  end
  object miFields: TADMetaInfoQuery
    AfterOpen = miTablesAfterOpen
    Connection = dmlMainComp.dbMain
    MetaInfoKind = mkTableFields
    ObjectScopes = [osMy, osOther, osSystem]
    Left = 304
    Top = 217
  end
  object miIndexes: TADMetaInfoQuery
    AfterOpen = miTablesAfterOpen
    Connection = dmlMainComp.dbMain
    MetaInfoKind = mkIndexes
    ObjectScopes = [osMy, osOther, osSystem]
    Left = 336
    Top = 217
  end
  object miIndexFields: TADMetaInfoQuery
    AfterOpen = miTablesAfterOpen
    Connection = dmlMainComp.dbMain
    MetaInfoKind = mkIndexFields
    ObjectScopes = [osMy, osOther, osSystem]
    Left = 368
    Top = 217
  end
  object miPrimaryKeys: TADMetaInfoQuery
    AfterOpen = miTablesAfterOpen
    Connection = dmlMainComp.dbMain
    MetaInfoKind = mkPrimaryKey
    ObjectScopes = [osMy, osOther, osSystem]
    Left = 400
    Top = 217
  end
  object miPrimaryKeyFields: TADMetaInfoQuery
    AfterOpen = miTablesAfterOpen
    Connection = dmlMainComp.dbMain
    MetaInfoKind = mkPrimaryKeyFields
    ObjectScopes = [osMy, osOther, osSystem]
    Left = 432
    Top = 217
  end
  object dsTables: TDataSource
    DataSet = miTables
    OnDataChange = dsTablesDataChange
    Left = 272
    Top = 249
  end
  object dsFields: TDataSource
    DataSet = miFields
    Left = 304
    Top = 249
  end
  object dsIndexes: TDataSource
    DataSet = miIndexes
    OnDataChange = dsIndexesDataChange
    Left = 336
    Top = 249
  end
  object dsIndexFields: TDataSource
    DataSet = miIndexFields
    Left = 368
    Top = 249
  end
  object dsPrimaryKeys: TDataSource
    DataSet = miPrimaryKeys
    OnDataChange = dsPrimaryKeysDataChange
    Left = 400
    Top = 249
  end
  object dsPrimaryKeyFields: TDataSource
    DataSet = miPrimaryKeyFields
    Left = 432
    Top = 249
  end
  object miPackages: TADMetaInfoQuery
    AfterOpen = miTablesAfterOpen
    Connection = dmlMainComp.dbMain
    MetaInfoKind = mkPackages
    ObjectScopes = [osMy, osOther, osSystem]
    Left = 272
    Top = 369
  end
  object miPackProcs: TADMetaInfoQuery
    AfterOpen = miTablesAfterOpen
    Connection = dmlMainComp.dbMain
    MetaInfoKind = mkProcs
    ObjectScopes = [osMy, osOther, osSystem]
    Left = 304
    Top = 369
  end
  object miPackProcArgs: TADMetaInfoQuery
    AfterOpen = miTablesAfterOpen
    Connection = dmlMainComp.dbMain
    MetaInfoKind = mkProcArgs
    ObjectScopes = [osMy, osOther, osSystem]
    Left = 336
    Top = 369
  end
  object miProcs: TADMetaInfoQuery
    AfterOpen = miTablesAfterOpen
    Connection = dmlMainComp.dbMain
    MetaInfoKind = mkProcs
    ObjectScopes = [osMy, osOther, osSystem]
    Left = 272
    Top = 441
  end
  object miProcArgs: TADMetaInfoQuery
    AfterOpen = miTablesAfterOpen
    Connection = dmlMainComp.dbMain
    MetaInfoKind = mkProcArgs
    ObjectScopes = [osMy, osOther, osSystem]
    Left = 304
    Top = 441
  end
  object dsPackages: TDataSource
    DataSet = miPackages
    OnDataChange = dsPackagesDataChange
    Left = 272
    Top = 401
  end
  object dsPackProcs: TDataSource
    DataSet = miPackProcs
    OnDataChange = dsPackProcsDataChange
    Left = 304
    Top = 401
  end
  object dsPackProcArgs: TDataSource
    DataSet = miPackProcArgs
    Left = 336
    Top = 401
  end
  object dsProcs: TDataSource
    DataSet = miProcs
    OnDataChange = dsProcsDataChange
    Left = 272
    Top = 473
  end
  object dsProcArgs: TDataSource
    DataSet = miProcArgs
    Left = 304
    Top = 473
  end
end
