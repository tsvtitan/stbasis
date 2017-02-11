object frmObjectView: TfrmObjectView
  Left = 664
  Top = 325
  Width = 639
  Height = 479
  BorderIcons = [biSystemMenu, biHelp]
  Caption = 'frmObjectView'
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar: TStatusBar
    Left = 0
    Top = 433
    Width = 631
    Height = 19
    Panels = <
      item
        Width = 200
      end
      item
        Width = 200
      end>
    SimplePanel = False
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 631
    Height = 29
    ButtonHeight = 25
    ButtonWidth = 26
    Caption = 'ToolBar1'
    EdgeBorders = [ebBottom]
    Flat = True
    Images = frmMain.imgToolBarsEnabled
    TabOrder = 1
    object cbObjectList: TComboBox
      Left = 0
      Top = 2
      Width = 270
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
      OnChange = cbObjectListChange
      OnDropDown = cbGetIndex
      OnEnter = cbGetIndex
    end
  end
  object pgcProperties: TPageControl
    Left = 0
    Top = 29
    Width = 631
    Height = 404
    ActivePage = tabData
    Align = alClient
    HotTrack = True
    TabOrder = 2
    OnChange = pgcPropertiesChange
    object tabProperties: TTabSheet
      Caption = 'Properties'
      object btnApply: TButton
        Left = 686
        Top = 443
        Width = 80
        Height = 31
        Anchors = [akRight, akBottom]
        Caption = '&Apply'
        Enabled = False
        TabOrder = 0
        Visible = False
      end
      object objControl: TPageControl
        Left = 0
        Top = 0
        Width = 623
        Height = 376
        ActivePage = tabTables
        Align = alClient
        MultiLine = True
        TabOrder = 1
        object tabDomains: TTabSheet
          Caption = 'tabDomains'
          object Label5: TLabel
            Left = 3
            Top = 108
            Width = 84
            Height = 13
            Caption = '&Check Constraint:'
            FocusControl = reConstraint
          end
          object lblFileName: TLabel
            Left = 317
            Top = 110
            Width = 54
            Height = 13
            Caption = 'lblFileName'
            Visible = False
          end
          object reConstraint: TRichEditX
            Left = 0
            Top = 127
            Width = 615
            Height = 221
            Align = alBottom
            Anchors = [akLeft, akTop, akRight, akBottom]
            Color = clBtnFace
            ReadOnly = True
            ScrollBars = ssBoth
            TabOrder = 0
            OnChange = ObjectChange
          end
          object lvDomains: TListView
            Left = 0
            Top = 0
            Width = 615
            Height = 103
            Align = alTop
            Columns = <>
            ColumnClick = False
            TabOrder = 1
            ViewStyle = vsReport
          end
        end
        object tabTables: TTabSheet
          Caption = 'tabTables'
          ImageIndex = 1
          object SplitterWnd: TSplitter
            Left = 0
            Top = 243
            Width = 615
            Height = 3
            Cursor = crVSplit
            Align = alTop
          end
          object ToolBar2: TToolBar
            Left = 0
            Top = 0
            Width = 615
            Height = 29
            ButtonHeight = 24
            ButtonWidth = 27
            Caption = 'ToolBar2'
            EdgeBorders = [ebTop, ebBottom]
            Flat = True
            Images = frmMain.imgTreeview
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            object tbCols: TToolButton
              Left = 0
              Top = 0
              Action = ShowColumns
              Down = True
              Grouped = True
              Style = tbsCheck
            end
            object tbTriggers: TToolButton
              Left = 27
              Top = 0
              Action = ShowTriggers
              Grouped = True
              Style = tbsCheck
            end
            object tbChkConst: TToolButton
              Left = 54
              Top = 0
              Action = ShowCheckConstraints
              Grouped = True
              Style = tbsCheck
            end
            object tbIndexes: TToolButton
              Left = 81
              Top = 0
              Action = ShowIndexes
              Grouped = True
              Style = tbsCheck
            end
            object tbUnique: TToolButton
              Left = 108
              Top = 0
              Action = ShowUniqueConstraints
              Grouped = True
              Style = tbsCheck
            end
            object tbRef: TToolButton
              Left = 135
              Top = 0
              Action = ShowReferentialConstraints
              Grouped = True
              Style = tbsCheck
            end
          end
          object lvTableObjects: TListView
            Left = 0
            Top = 29
            Width = 615
            Height = 214
            Align = alTop
            Anchors = [akLeft, akTop, akRight, akBottom]
            Columns = <>
            ColumnClick = False
            ReadOnly = True
            TabOrder = 1
            ViewStyle = vsReport
          end
          object reTriggerSource: TRichEditX
            Left = 0
            Top = 246
            Width = 615
            Height = 102
            TabStop = False
            Align = alClient
            Color = clBtnFace
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            ParentFont = False
            PopupMenu = frmMain.EditPopup
            ReadOnly = True
            ScrollBars = ssBoth
            TabOrder = 2
            WordWrap = False
          end
        end
        object tabProcedures: TTabSheet
          Caption = 'tabProcedures'
          ImageIndex = 2
          object Splitter2: TSplitter
            Left = 0
            Top = 144
            Width = 615
            Height = 3
            Cursor = crVSplit
            Align = alTop
          end
          object reProcSource: TRichEditX
            Left = 0
            Top = 147
            Width = 615
            Height = 201
            TabStop = False
            Align = alClient
            Color = clBtnFace
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            ScrollBars = ssBoth
            TabOrder = 0
          end
          object lvParams: TListView
            Left = 0
            Top = 0
            Width = 615
            Height = 144
            Align = alTop
            Columns = <>
            ColumnClick = False
            ReadOnly = True
            TabOrder = 1
            ViewStyle = vsReport
            OnChange = ShowProcSource
          end
        end
        object tabFunctions: TTabSheet
          Caption = 'tabFunctions'
          ImageIndex = 3
          object lvFuncView: TListView
            Left = 0
            Top = 171
            Width = 615
            Height = 177
            Align = alClient
            Columns = <>
            ColumnClick = False
            ReadOnly = True
            TabOrder = 0
            ViewStyle = vsReport
          end
          object Panel5: TPanel
            Left = 0
            Top = 0
            Width = 615
            Height = 171
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 1
            object Label8: TLabel
              Left = 10
              Top = 6
              Width = 69
              Height = 13
              Caption = '&Module Name:'
              FocusControl = edModName
            end
            object Label9: TLabel
              Left = 10
              Top = 62
              Width = 50
              Height = 13
              Caption = '&Entrypoint:'
              FocusControl = edEntrypoint
            end
            object Label10: TLabel
              Left = 10
              Top = 116
              Width = 40
              Height = 13
              Caption = '&Returns:'
              FocusControl = edReturnVal
            end
            object edReturnVal: TEdit
              Left = 20
              Top = 135
              Width = 268
              Height = 21
              Color = clBtnFace
              ReadOnly = True
              TabOrder = 0
            end
            object edEntrypoint: TEdit
              Left = 20
              Top = 84
              Width = 268
              Height = 21
              Color = clBtnFace
              ReadOnly = True
              TabOrder = 1
            end
            object edModName: TEdit
              Left = 20
              Top = 26
              Width = 268
              Height = 21
              Color = clBtnFace
              ReadOnly = True
              TabOrder = 2
            end
          end
        end
        object tabExceptions: TTabSheet
          Caption = 'tabExceptions'
          ImageIndex = 5
          object Label18: TLabel
            Left = 10
            Top = 5
            Width = 90
            Height = 13
            Caption = 'Exception &Number:'
          end
          object Label19: TLabel
            Left = 10
            Top = 77
            Width = 96
            Height = 13
            Caption = 'Exception &Message:'
          end
          object edExceptionNumber: TEdit
            Left = 20
            Top = 32
            Width = 149
            Height = 21
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 0
          end
          object edMessage: TEdit
            Left = 20
            Top = 101
            Width = 515
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 1
          end
        end
        object tabGenerators: TTabSheet
          Caption = 'tabGenerators'
          ImageIndex = 8
          object Label3: TLabel
            Left = 10
            Top = 6
            Width = 64
            Height = 13
            Caption = 'Generator &ID:'
          end
          object Label21: TLabel
            Left = 10
            Top = 69
            Width = 67
            Height = 13
            Caption = 'Current &Value:'
          end
          object edGenID: TEdit
            Left = 20
            Top = 27
            Width = 149
            Height = 21
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 0
          end
          object edNextValue: TEdit
            Left = 20
            Top = 92
            Width = 149
            Height = 21
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 1
          end
        end
        object tabFilters: TTabSheet
          Caption = 'tabFilters'
          ImageIndex = 8
          object Label11: TLabel
            Left = 6
            Top = 6
            Width = 69
            Height = 13
            Caption = '&Module Name:'
            FocusControl = edFilterModule
          end
          object Label12: TLabel
            Left = 6
            Top = 70
            Width = 50
            Height = 13
            Caption = '&Entrypoint:'
            FocusControl = edFilterEntry
          end
          object Label13: TLabel
            Left = 6
            Top = 124
            Width = 73
            Height = 13
            Caption = '&Input SubType:'
            FocusControl = edFilterInput
          end
          object Label14: TLabel
            Left = 6
            Top = 175
            Width = 81
            Height = 13
            Caption = '&Output SubType:'
            FocusControl = edFilterOutput
          end
          object edFilterModule: TEdit
            Left = 16
            Top = 30
            Width = 149
            Height = 21
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 0
            Text = 'edFilterModule'
          end
          object edFilterEntry: TEdit
            Left = 16
            Top = 90
            Width = 149
            Height = 21
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 1
            Text = 'edFilterEntry'
          end
          object edFilterInput: TEdit
            Left = 16
            Top = 143
            Width = 149
            Height = 21
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 2
            Text = 'edFilterInput'
          end
          object edFilterOutput: TEdit
            Left = 16
            Top = 196
            Width = 149
            Height = 21
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 3
            Text = 'edFilterOutput'
          end
        end
      end
    end
    object tabMetadata: TTabSheet
      Caption = 'Metadata'
      ImageIndex = 1
      object reMetadata: TRichEditX
        Left = 0
        Top = 0
        Width = 623
        Height = 376
        Align = alClient
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        PopupMenu = frmMain.EditPopup
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 0
        WordWrap = False
      end
    end
    object tabPermissions: TTabSheet
      Caption = 'Permissions'
      ImageIndex = 2
      object lvPermissions: TListView
        Left = 0
        Top = 0
        Width = 623
        Height = 335
        Align = alClient
        Columns = <
          item
            AutoSize = True
            Caption = 'Object'
          end
          item
            Alignment = taCenter
            AutoSize = True
            Caption = 'Select'
          end
          item
            Alignment = taCenter
            AutoSize = True
            Caption = 'Delete'
          end
          item
            Alignment = taCenter
            AutoSize = True
            Caption = 'Insert'
          end
          item
            Alignment = taCenter
            AutoSize = True
            Caption = 'Update'
          end
          item
            Alignment = taCenter
            AutoSize = True
            Caption = 'Reference'
          end
          item
            Alignment = taCenter
            AutoSize = True
            Caption = 'Execute'
          end
          item
            Alignment = taCenter
            AutoSize = True
            Caption = 'Member Of'
          end>
        ColumnClick = False
        GridLines = True
        ReadOnly = True
        SmallImages = frmMain.imgToolBarsEnabled
        TabOrder = 0
        ViewStyle = vsReport
      end
      object Panel1: TPanel
        Left = 0
        Top = 335
        Width = 623
        Height = 41
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
        object Image1: TImage
          Left = 18
          Top = 9
          Width = 33
          Height = 24
          Center = True
          Picture.Data = {
            07544269746D6170F6000000424DF60000000000000076000000280000001000
            0000100000000100040000000000800000000000000000000000100000000000
            0000000000000000800000800000008080008000000080008000808000008080
            8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
            FF00FFFFFFF00000FFFF00000F0888880FFF4444008FF0000FFF444408FF080F
            FFFF444408FFF0FFFFFFCCCC07777FFFFFFF4444FFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFF}
          Stretch = True
          Transparent = True
        end
        object Label1: TLabel
          Left = 59
          Top = 20
          Width = 199
          Height = 13
          Caption = 'This permission includes GRANT OPTION'
        end
      end
    end
    object tabData: TTabSheet
      Caption = 'Data'
      ImageIndex = 3
      object dbgData: TDBGrid
        Left = 0
        Top = 0
        Width = 623
        Height = 351
        Align = alClient
        DataSource = dbgDataSource
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        OnCellClick = dbgDataCellClick
        OnDrawColumnCell = dbgDataDrawColumnCell
        OnEditButtonClick = dbgDataEditButtonClick
      end
      object DBNavigator1: TDBNavigator
        Left = 0
        Top = 351
        Width = 623
        Height = 25
        DataSource = dbgDataSource
        Align = alBottom
        Flat = True
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
      end
    end
    object tabDependencies: TTabSheet
      Caption = 'Dependencies'
      ImageIndex = 4
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 623
        Height = 41
        Align = alTop
        BevelOuter = bvNone
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        object rbDependent: TRadioButton
          Left = 32
          Top = 12
          Width = 175
          Height = 17
          Hint = 'Displays objects which depend on the currently selected object'
          Caption = 'Show &Dependent Objects'
          TabOrder = 0
          OnClick = rbDependentClick
        end
        object rbDependedOn: TRadioButton
          Left = 375
          Top = 12
          Width = 216
          Height = 17
          Hint = 'Shows the objects the current object depends on'
          Caption = 'Show Depended &On Objects'
          TabOrder = 1
          OnClick = rbDependedOnClick
        end
      end
      object pnlDependents: TPanel
        Left = 0
        Top = 41
        Width = 623
        Height = 335
        Align = alClient
        BevelOuter = bvNone
        Caption = 'pnlDependents'
        TabOrder = 1
        object tvDependents: TTreeView
          Left = 0
          Top = 0
          Width = 623
          Height = 335
          Align = alClient
          Images = frmMain.imgTreeview
          Indent = 23
          StateImages = frmMain.imgTreeview
          TabOrder = 0
        end
      end
      object pnlDependencies: TPanel
        Left = 0
        Top = 41
        Width = 623
        Height = 335
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 2
        object tvDependencies: TTreeView
          Left = 0
          Top = 0
          Width = 623
          Height = 335
          Align = alClient
          Images = frmMain.imgTreeview
          Indent = 23
          StateImages = frmMain.imgTreeview
          TabOrder = 0
        end
      end
    end
  end
  object dbgDataSource: TDataSource
    DataSet = IBTable
    Left = 356
    Top = 200
  end
  object TableActions: TActionList
    Images = frmMain.imgTreeview
    Left = 297
    Top = 200
    object ShowColumns: TAction
      Caption = 'Columns'
      Hint = 'Show Columns for the table'
      ImageIndex = 15
      ShortCut = 49219
      OnExecute = ShowColumnsExecute
    end
    object ShowTriggers: TAction
      Caption = 'Triggers'
      Hint = 'Show triggers for the table'
      ImageIndex = 20
      ShortCut = 49236
      OnExecute = ShowTriggersExecute
    end
    object ShowCheckConstraints: TAction
      Caption = 'Check Constraints'
      Hint = 'Show Check Constraints'
      ImageIndex = 19
      ShortCut = 49224
      OnExecute = ShowCheckConstraintsExecute
    end
    object ShowIndexes: TAction
      Caption = 'Indexes'
      Hint = 'Show indexes'
      ImageIndex = 16
      ShortCut = 49225
      OnExecute = ShowIndexesExecute
    end
    object ShowUniqueConstraints: TAction
      Caption = 'Unique Constraints'
      Hint = 'Show unique constraints for the table'
      ImageIndex = 18
      ShortCut = 49237
      OnExecute = ShowUniqueConstraintsExecute
    end
    object ShowReferentialConstraints: TAction
      Caption = 'Referential Constraints'
      Hint = 'Show referential constraints'
      ImageIndex = 17
      ShortCut = 49234
      OnExecute = ShowReferentialConstraintsExecute
    end
  end
  object IBTable: TIBTable
    ObjectView = True
    BufferChunks = 1000
    CachedUpdates = False
    Left = 326
    Top = 200
  end
end
