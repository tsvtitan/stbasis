object dlgWisql: TdlgWisql
  Left = 460
  Top = 515
  ActiveControl = reSqlInput
  AutoScroll = False
  Caption = 'Interactive SQL'
  ClientHeight = 434
  ClientWidth = 634
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object splISQLHorizontal: TSplitter
    Left = 0
    Top = 183
    Width = 634
    Height = 6
    Cursor = crVSplit
    Align = alTop
    Beveled = True
  end
  object lblFileName: TLabel
    Left = 378
    Top = 423
    Width = 54
    Height = 13
    Caption = 'lblFileName'
    Visible = False
  end
  object pgcOutput: TPageControl
    Left = 0
    Top = 189
    Width = 634
    Height = 226
    ActivePage = TabData
    Align = alClient
    DockSite = True
    TabOrder = 0
    object TabData: TTabSheet
      Caption = 'Data'
      object dbgSQLResults: TDBGrid
        Left = 0
        Top = 0
        Width = 626
        Height = 198
        Align = alClient
        DataSource = GridSource
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        OnCellClick = dbgSQLResultsCellClick
        OnDrawColumnCell = dbgSQLResultsDrawColumnCell
        OnEditButtonClick = dbgSQLResultsEditButtonClick
      end
    end
    object TabResults: TTabSheet
      Caption = 'Plan'
      ImageIndex = 1
      object reSqlOutput: TRichEditX
        Left = 0
        Top = 0
        Width = 626
        Height = 198
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
        Lines.Strings = (
          'reSqlOutput')
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
    object TabStats: TTabSheet
      Caption = 'Statistics'
      ImageIndex = 2
      object lvStats: TListView
        Left = 0
        Top = 0
        Width = 626
        Height = 198
        Align = alClient
        Columns = <
          item
            AutoSize = True
            Caption = 'Statistic'
          end
          item
            AutoSize = True
            Caption = 'Value'
          end>
        ColumnClick = False
        ReadOnly = True
        TabOrder = 0
        ViewStyle = vsReport
      end
    end
  end
  object pnlEnterSQL: TPanel
    Left = 0
    Top = 30
    Width = 634
    Height = 153
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object reSqlInput: TRichEditX
      Left = 0
      Top = 0
      Width = 634
      Height = 133
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
      HideSelection = False
      Lines.Strings = (
        'reSqlInput')
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 0
      WordWrap = False
      OnEnter = UpdateCursor
      OnKeyDown = reSqlInputKeyDown
      OnKeyPress = reSqlInputKeyPress
      OnSelectionChange = UpdateCursor
    end
    object stbISQL: TStatusBar
      Left = 0
      Top = 133
      Width = 634
      Height = 20
      Hint = 'Right-Click to change client dialect'
      Panels = <
        item
          Alignment = taCenter
          Width = 100
        end
        item
          Alignment = taCenter
          Width = 80
        end
        item
          Width = 100
        end
        item
          Width = 150
        end
        item
          Width = 50
        end>
      ParentShowHint = False
      PopupMenu = pmClientDialect
      ShowHint = True
      SimplePanel = False
      SizeGrip = False
    end
  end
  object sbData: TStatusBar
    Left = 0
    Top = 415
    Width = 634
    Height = 19
    Panels = <
      item
        Width = 300
      end
      item
        Width = 50
      end>
    SimplePanel = False
  end
  object ToolBar3: TToolBar
    Left = 0
    Top = 0
    Width = 634
    Height = 30
    AutoSize = True
    ButtonHeight = 26
    ButtonWidth = 26
    Caption = 'Query'
    EdgeBorders = [ebLeft, ebTop, ebRight, ebBottom]
    Flat = True
    Images = frmMain.imgToolBarsEnabled
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    object ToolButton7: TToolButton
      Left = 0
      Top = 0
      Action = QueryPrevious
      AutoSize = True
    end
    object ToolButton8: TToolButton
      Left = 26
      Top = 0
      Action = QueryNext
      AutoSize = True
    end
    object ToolButton9: TToolButton
      Left = 52
      Top = 0
      Action = QueryExecute
      AutoSize = True
    end
    object ToolButton5: TToolButton
      Left = 78
      Top = 0
      Action = QueryPrepare
      AutoSize = True
    end
    object ToolButton10: TToolButton
      Left = 104
      Top = 0
      Width = 8
      Caption = 'ToolButton10'
      ImageIndex = 12
      Style = tbsSeparator
    end
    object ToolButton2: TToolButton
      Left = 112
      Top = 0
      Action = TransactionCommit
      AutoSize = True
    end
    object ToolButton3: TToolButton
      Left = 138
      Top = 0
      Action = TransactionRollback
      AutoSize = True
    end
    object ToolButton4: TToolButton
      Left = 164
      Top = 0
      Width = 8
      Caption = 'ToolButton4'
      ImageIndex = 15
      Style = tbsSeparator
    end
    object ToolButton11: TToolButton
      Left = 172
      Top = 0
      Action = QueryLoadScript
      AutoSize = True
    end
    object ToolButton12: TToolButton
      Left = 198
      Top = 0
      Action = QuerySaveScript
      AutoSize = True
    end
    object ToolButton13: TToolButton
      Left = 224
      Top = 0
      Width = 8
      Caption = 'ToolButton13'
      ImageIndex = 11
      Style = tbsSeparator
    end
    object ToolButton20: TToolButton
      Left = 232
      Top = 0
      Action = EditFind
      AutoSize = True
    end
  end
  object GridSource: TDataSource
    Left = 479
    Top = 91
  end
  object pmClientDialect: TPopupMenu
    Left = 399
    Top = 129
    object Dialect1: TMenuItem
      Action = DialectAction1
      RadioItem = True
    end
    object Dialect2: TMenuItem
      Action = DialectAction2
      RadioItem = True
    end
    object Dialect3: TMenuItem
      Action = DialectAction3
      RadioItem = True
    end
  end
  object MainMenu1: TMainMenu
    Images = frmMain.imgToolBarsEnabled
    Left = 317
    Top = 79
    object File1: TMenuItem
      Caption = '&File'
      Hint = 'Close the ISQL window'
      ShortCut = 16499
      object Print1: TMenuItem
        Caption = '&Print'
        ImageIndex = 9
        OnClick = Print1Click
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object Close1: TMenuItem
        Action = FileClose
      end
    end
    object mnuEdit1: TMenuItem
      Caption = '&Edit'
      object Undo2: TMenuItem
        Action = EditUndo1
      end
      object N9: TMenuItem
        Caption = '-'
      end
      object mnuEdCopy1: TMenuItem
        Action = EditCopy1
      end
      object Cut2: TMenuItem
        Action = EditCut1
      end
      object Paste2: TMenuItem
        Action = EditPaste1
      end
      object SelectAll2: TMenuItem
        Action = EditSelectAll1
      end
      object mnuEdN1: TMenuItem
        Caption = '-'
      end
      object mnuEdFind1: TMenuItem
        Action = EditFind
      end
      object Font2: TMenuItem
        Action = EditFont
      end
      object N8: TMenuItem
        Caption = '-'
      end
      object Options1: TMenuItem
        Action = FileOptions
      end
    end
    object Edit1: TMenuItem
      Caption = '&Query'
      object QueryLoadScript1: TMenuItem
        Action = QueryLoadScript
      end
      object QuerySaveScript1: TMenuItem
        Action = QuerySaveScript
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object QueryNext1: TMenuItem
        Action = QueryNext
      end
      object QueryPrevious1: TMenuItem
        Action = QueryPrevious
      end
      object QueryPrevious2: TMenuItem
        Action = QueryExecute
      end
      object Prepare1: TMenuItem
        Action = QueryPrepare
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object SaveOutput1: TMenuItem
        Action = QuerySaveOutput
      end
    end
    object Database1: TMenuItem
      Caption = '&Database'
      object Connect1: TMenuItem
        Action = DatabaseConnectAs
      end
      object Disconnect1: TMenuItem
        Action = DatabaseDisconnect
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object Create1: TMenuItem
        Action = DatabaseCreate
      end
      object Drop1: TMenuItem
        Action = DatabaseDrop
      end
    end
    object Transactions1: TMenuItem
      Caption = '&Transactions'
      object Commit1: TMenuItem
        Action = TransactionCommit
      end
      object Rollback1: TMenuItem
        Action = TransactionRollback
      end
    end
    object Windows1: TMenuItem
      Caption = '&Windows'
      OnClick = Windows1Click
    end
    object Help1: TMenuItem
      Caption = '&Help'
      object SQLReference1: TMenuItem
        Caption = '&SQL Reference'
        OnClick = SQLReference1Click
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object About1: TMenuItem
        Action = frmMain.HelpAbout
      end
    end
  end
  object TransactionActions: TActionList
    Images = frmMain.imgToolBarsEnabled
    Left = 277
    Top = 131
    object TransactionCommit: TAction
      Tag = 1
      Caption = '&Commit'
      Hint = 'Commit Work'
      ImageIndex = 41
      OnExecute = TransactionExecute
    end
    object TransactionRollback: TAction
      Caption = '&Rollback'
      Hint = 'Rollback Work'
      ImageIndex = 42
      OnExecute = TransactionExecute
    end
  end
  object DialectActions: TActionList
    Images = frmMain.imgToolBarsEnabled
    Left = 360
    Top = 95
    object DialectAction1: TAction
      Tag = 1
      Caption = 'Dialect &1'
      OnExecute = DialectChange
      OnUpdate = DialectUpdate
    end
    object DialectAction2: TAction
      Tag = 2
      Caption = 'Dialect &2'
      OnExecute = DialectChange
      OnUpdate = DialectUpdate
    end
    object DialectAction3: TAction
      Tag = 3
      Caption = 'Dialect &3'
      OnExecute = DialectChange
      OnUpdate = DialectUpdate
    end
  end
  object QueryActions: TActionList
    Images = frmMain.imgToolBarsEnabled
    Left = 413
    Top = 84
    object QueryPrevious: TAction
      Caption = '&Previous'
      Hint = 'Previous Query'
      ImageIndex = 20
      ShortCut = 16464
      OnExecute = QueryPreviousExecute
      OnUpdate = QueryPreviousUpdate
    end
    object QueryNext: TAction
      Caption = '&Next'
      Hint = 'Next Query'
      ImageIndex = 19
      ShortCut = 16462
      OnExecute = QueryNextExecute
      OnUpdate = QueryNextUpdate
    end
    object QueryExecute: TAction
      Caption = '&Execute'
      Hint = 'Execute Query'
      ImageIndex = 18
      ShortCut = 16453
      OnExecute = QueryExecuteExecute
      OnUpdate = QueryUpdate
    end
    object QueryLoadScript: TAction
      Caption = '&Load Script'
      Hint = 'Load SQL Script'
      ImageIndex = 16
      OnExecute = QueryLoadScriptExecute
    end
    object QuerySaveScript: TAction
      Caption = '&Save Script'
      Hint = 'Save Script'
      ImageIndex = 17
      OnExecute = QuerySaveScriptExecute
      OnUpdate = QueryUpdate
    end
    object QueryOptions: TAction
      Caption = 'O&ptions ...'
      Hint = 'Query Options'
    end
    object QuerySaveOutput: TAction
      Caption = 'Save &Output'
      Hint = 'Save the query ouput'
      OnExecute = QuerySaveOutputExecute
      OnUpdate = QuerySaveOutputUpdate
    end
    object QueryPrepare: TAction
      Caption = '&Prepare'
      Hint = 'Prepare the current query before execution'
      ImageIndex = 43
      OnExecute = QueryPrepareExecute
      OnUpdate = QueryUpdate
    end
  end
  object pmLastFiles: TPopupMenu
    Left = 548
    Top = 81
  end
  object FileActions: TActionList
    Images = frmMain.imgToolBarsEnabled
    Left = 266
    Top = 86
    object FileOptions: TAction
      Caption = '&Options ...'
      Hint = 'Show ISQL Options'
      ImageIndex = 21
      OnExecute = FileOptionsExecute
    end
    object FileClose: TAction
      Caption = '&Close'
      Hint = 'Close the ISQL window'
      ShortCut = 16499
      OnExecute = FileCloseExecute
    end
    object EditFind: TAction
      Caption = '&Find ...'
      ImageIndex = 14
      OnExecute = EditFindExecute
      OnUpdate = EditFindUpdate
    end
    object EditFont: TAction
      Caption = '&Font ...'
      ImageIndex = 15
      OnExecute = EditFontExecute
    end
    object EditCopy1: TEditCopy
      Caption = '&Copy'
      Hint = 'Copy'
      ImageIndex = 12
      ShortCut = 16451
    end
    object EditCut1: TEditCut
      Caption = 'Cu&t'
      Hint = 'Cut'
      ImageIndex = 11
      ShortCut = 16472
    end
    object EditPaste1: TEditPaste
      Caption = '&Paste'
      Hint = 'Paste'
      ImageIndex = 13
      ShortCut = 16470
    end
    object EditSelectAll1: TEditSelectAll
      Caption = 'Select &All'
    end
    object EditUndo1: TEditUndo
      Caption = '&Undo'
      ImageIndex = 10
      ShortCut = 32776
    end
  end
  object DatabaseActions: TActionList
    Images = frmMain.imgToolBarsEnabled
    Left = 95
    Top = 97
    object DatabaseConnectAs: TAction
      Caption = 'Connect &As ...'
      ImageIndex = 7
      OnExecute = Connect1Click
      OnUpdate = DatabaseConnectAsUpdate
    end
    object DatabaseDisconnect: TAction
      Caption = '&Disconnect'
      ImageIndex = 8
      OnExecute = Disconnect1Click
      OnUpdate = DatabaseDisconnectUpdate
    end
    object DatabaseCreate: TAction
      Caption = '&Create Database ...'
      ImageIndex = 4
      OnExecute = Create1Click
      OnUpdate = DatabaseConnectAsUpdate
    end
    object DatabaseDrop: TAction
      Caption = 'D&rop Database'
      OnExecute = Drop1Click
      OnUpdate = DatabaseDisconnectUpdate
    end
  end
end
