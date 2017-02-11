object fmMain: TfmMain
  Left = 466
  Top = 218
  Width = 640
  Height = 480
  Caption = #1042#1074#1086#1076' '#1086#1073#1098#1103#1074#1083#1077#1085#1080#1081' '#1076#1083#1103' '#1075#1072#1079#1077#1090#1099' "'#1053#1086#1074#1099#1077' '#1074#1088#1077#1084#1077#1085#1072'"'
  Color = clBtnFace
  Constraints.MinHeight = 480
  Constraints.MinWidth = 640
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000000000000000000000000000000000000000000FFFFFFF00000
    0000F00F00F000000FF0FFFFFFF000000F00F00F00F000FF0FF0FFFFFFF000F0
    0F00F00F00F000FF0FF0FFFFFFF000F00F000000000000FF0FFFFFFF000000F0
    00000000000000FFFFFFF000000000000000000000000000000000000000FFFF
    0000FFFF0000FE000000FE000000F0000000F000000080000000800000008000
    000080000000800000008007000080070000803F0000803F0000FFFF0000}
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnBottom: TPanel
    Left = 0
    Top = 412
    Width = 632
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      632
      41)
    object lbRecordCount: TLabel
      Left = 398
      Top = 13
      Width = 42
      Height = 13
      Caption = #1042#1089#1077#1075#1086': 0'
    end
    object btClose: TButton
      Left = 549
      Top = 9
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #1042#1099#1093#1086#1076
      TabOrder = 0
      OnClick = btCloseClick
    end
    object DBNav: TDBNavigator
      Left = 14
      Top = 11
      Width = 369
      Height = 18
      DataSource = ds
      VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbInsert, nbDelete, nbEdit, nbPost, nbCancel]
      Anchors = [akLeft, akBottom]
      Hints.Strings = (
        #1055#1077#1088#1074#1072#1103' '#1079#1072#1087#1080#1089#1100
        #1055#1088#1077#1076#1099#1076#1091#1097#1072#1103' '#1079#1072#1087#1080#1089#1100
        #1057#1083#1077#1076#1091#1102#1097#1072#1103' '#1079#1072#1087#1080#1089#1100
        #1055#1086#1089#1083#1077#1076#1085#1103#1103' '#1079#1072#1087#1080#1089#1100
        #1042#1089#1090#1072#1074#1080#1090#1100' '#1079#1072#1087#1080#1089#1100
        #1059#1076#1072#1083#1080#1090#1100' '#1079#1072#1087#1080#1089#1100
        #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100' '#1079#1072#1087#1080#1089#1100
        #1055#1086#1090#1074#1077#1088#1076#1080#1090#1100' '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077
        #1054#1090#1084#1077#1085#1080#1090#1100' '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077
        #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077)
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
  end
  object pcMain: TPageControl
    Left = 0
    Top = 0
    Width = 632
    Height = 412
    ActivePage = tsInput
    Align = alClient
    TabOrder = 0
    OnChange = pcMainChange
    object tsInput: TTabSheet
      Caption = #1042#1074#1086#1076' '#1086#1073#1098#1103#1074#1083#1077#1085#1080#1081
      object pnInputTop: TPanel
        Left = 0
        Top = 0
        Width = 624
        Height = 37
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object pnFind: TPanel
          Left = 0
          Top = 0
          Width = 283
          Height = 37
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 0
          object lbFind: TLabel
            Left = 15
            Top = 12
            Width = 34
            Height = 13
            Caption = #1053#1072#1081#1090#1080':'
          end
          object edFind: TEdit
            Left = 57
            Top = 9
            Width = 216
            Height = 21
            TabOrder = 0
            OnKeyDown = edFindKeyDown
            OnKeyUp = edFindKeyUp
          end
        end
        object pnFilter: TPanel
          Left = 283
          Top = 0
          Width = 341
          Height = 37
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          object lbFilter: TLabel
            Left = 9
            Top = 13
            Width = 144
            Height = 13
            Caption = #1060#1080#1083#1100#1090#1088' '#1087#1086' '#1085#1086#1084#1077#1088#1091' '#1074#1099#1087#1091#1089#1082#1072':'
          end
          object edFilter: TEdit
            Left = 164
            Top = 9
            Width = 165
            Height = 21
            TabOrder = 0
            OnKeyDown = edFindKeyDown
            OnKeyUp = edFilterKeyUp
          end
        end
      end
      object pnInputGrid: TPanel
        Left = 0
        Top = 37
        Width = 624
        Height = 347
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 5
        TabOrder = 1
        object pnText: TPanel
          Left = 5
          Top = 232
          Width = 614
          Height = 110
          Align = alBottom
          BevelOuter = bvNone
          BorderWidth = 1
          TabOrder = 0
          Visible = False
          object grbText: TGroupBox
            Left = 1
            Top = 1
            Width = 612
            Height = 108
            Align = alClient
            Caption = ' '#1058#1077#1082#1089#1090' '#1086#1073#1098#1103#1074#1083#1077#1085#1080#1103' '
            TabOrder = 0
            Visible = False
            object Panel2: TPanel
              Left = 2
              Top = 15
              Width = 608
              Height = 91
              Align = alClient
              BevelOuter = bvNone
              BorderWidth = 5
              TabOrder = 0
              object dbMemoText: TDBMemo
                Left = 5
                Top = 5
                Width = 598
                Height = 81
                Align = alClient
                DataField = 'textannouncement'
                DataSource = ds
                MaxLength = 2000
                TabOrder = 0
                WordWrap = False
                OnKeyDown = dbMemoTextKeyDown
              end
            end
          end
        end
      end
    end
    object tsExport: TTabSheet
      Caption = #1069#1082#1089#1087#1086#1088#1090
      ImageIndex = 1
      object gag: TGauge
        Left = 8
        Top = 178
        Width = 448
        Height = 18
        Progress = 0
        Visible = False
      end
      object Label1: TLabel
        Left = 13
        Top = 118
        Width = 147
        Height = 13
        Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1086#1088#1075#1072#1085#1080#1079#1072#1094#1080#1080':'
      end
      object GroupBox1: TGroupBox
        Left = 9
        Top = 8
        Width = 227
        Height = 98
        Caption = ' '#1054#1087#1094#1080#1080' '
        TabOrder = 0
        object RadioButton1: TRadioButton
          Left = 16
          Top = 24
          Width = 113
          Height = 17
          Caption = #1042#1089#1077' '#1086#1073#1098#1103#1074#1083#1077#1085#1080#1103
          Checked = True
          TabOrder = 0
          TabStop = True
          OnClick = RadioButton1Click
        end
        object RadioButton2: TRadioButton
          Left = 16
          Top = 55
          Width = 129
          Height = 17
          Caption = #1058#1086#1083#1100#1082#1086' '#1087#1086' '#1074#1099#1087#1091#1089#1082#1091
          TabOrder = 1
          OnClick = RadioButton1Click
        end
        object edExportReleaseNum: TEdit
          Left = 149
          Top = 53
          Width = 61
          Height = 21
          Color = clBtnFace
          Enabled = False
          TabOrder = 2
        end
      end
      object GroupBox2: TGroupBox
        Left = 248
        Top = 8
        Width = 209
        Height = 99
        Caption = ' '#1053#1072#1089#1090#1088#1086#1081#1082#1080' '
        TabOrder = 1
        Visible = False
        object lbBeforeTree: TLabel
          Left = 34
          Top = 20
          Width = 85
          Height = 13
          Caption = #1055#1077#1088#1077#1076' '#1088#1091#1073#1088#1080#1082#1086#1081':'
        end
        object lbAfterTree: TLabel
          Left = 40
          Top = 45
          Width = 79
          Height = 13
          Caption = #1055#1086#1089#1083#1077' '#1088#1091#1073#1088#1080#1082#1080':'
        end
        object lbPointerTree: TLabel
          Left = 12
          Top = 70
          Width = 107
          Height = 13
          Caption = #1056#1072#1079#1076#1077#1083#1080#1090#1077#1083#1100' '#1088#1091#1073#1088#1080#1082':'
        end
        object edBeforeTree: TEdit
          Left = 125
          Top = 17
          Width = 73
          Height = 21
          TabOrder = 0
          Text = '['
        end
        object edAfterTree: TEdit
          Left = 125
          Top = 42
          Width = 73
          Height = 21
          TabOrder = 1
          Text = ']'
        end
        object edPointerTree: TEdit
          Left = 125
          Top = 67
          Width = 73
          Height = 21
          TabOrder = 2
          Text = '\'
        end
      end
      object btExport: TButton
        Left = 8
        Top = 144
        Width = 449
        Height = 25
        Caption = #1069#1082#1089#1087#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1074' '#1092#1072#1081#1083
        TabOrder = 3
        OnClick = btExportClick
      end
      object edOOO: TEdit
        Left = 168
        Top = 115
        Width = 289
        Height = 21
        TabOrder = 2
        OnKeyPress = edOOOKeyPress
      end
    end
  end
  object ds: TDataSource
    DataSet = cdsAncement
    Left = 532
    Top = 309
  end
  object cdsAncement: TClientDataSet
    Aggregates = <
      item
        AggregateName = 'GetMaxId'
        Expression = 'Max(treeheading_id)'
        IndexName = '0'
        Visible = False
      end>
    FieldDefs = <
      item
        Name = 'TREEHEADING_ID'
        Attributes = [faRequired, faUnNamed]
        DataType = ftInteger
      end
      item
        Name = 'TEXTANNOUNCEMENT'
        Attributes = [faUnNamed]
        DataType = ftString
        Size = 2000
      end>
    IndexDefs = <
      item
        Name = 'RELEASENUMASC'
        Fields = 'RELEASENUM'
      end
      item
        Name = 'RELEASENUMDESC'
        Fields = 'RELEASENUM'
        Options = [ixDescending]
      end
      item
        Name = 'TREEHEADING_IDASC'
        Fields = 'treeheading_id'
      end
      item
        Name = 'TREEHEADING_IDDESC'
        Fields = 'treeheading_id'
        Options = [ixDescending]
      end
      item
        Name = 'TEXTANNOUNCEMENTASC'
        Fields = 'textannouncement'
      end
      item
        Name = 'TEXTANNOUNCEMENTDESC'
        Fields = 'textannouncement'
        Options = [ixDescending]
      end>
    Params = <>
    StoreDefs = True
    AfterOpen = cdsAncementAfterOpen
    AfterInsert = cdsAncementAfterInsert
    AfterPost = cdsAncementAfterPost
    BeforeDelete = cdsAncementBeforeDelete
    AfterDelete = cdsAncementAfterDelete
    OnCalcFields = cdsAncementCalcFields
    Left = 488
    Top = 309
    object cdsAncementreleasenum: TStringField
      CustomConstraint = 'releasenum<>'#39#39
      ConstraintErrorMessage = #1042#1074#1077#1076#1080#1090#1077' '#1074#1099#1087#1091#1089#1082
      FieldName = 'releasenum'
      Size = 10
    end
    object cdsAncementtreeheading_id: TIntegerField
      CustomConstraint = 'treeheading_id<>0'
      ConstraintErrorMessage = #1042#1074#1077#1076#1080#1090#1077' '#1088#1091#1073#1088#1080#1082#1091
      FieldName = 'treeheading_id'
      Visible = False
    end
    object cdsAncementtreeheadingname: TStringField
      DisplayWidth = 2000
      FieldKind = fkCalculated
      FieldName = 'treeheadingname'
      Size = 2000
      Calculated = True
    end
    object cdsAncementtextannouncement: TStringField
      CustomConstraint = 'textannouncement<>'#39#39
      ConstraintErrorMessage = #1042#1074#1074#1077#1076#1080#1090#1077' '#1090#1077#1082#1089#1090' '#1086#1073#1098#1103#1074#1083#1077#1085#1080#1103
      FieldName = 'textannouncement'
      Size = 2000
    end
  end
  object sd: TSaveDialog
    DefaultExt = '*.rtf'
    Filter = #1060#1072#1081#1083#1099' RTF (*.rtf)|*.rtf'
    Left = 436
    Top = 312
  end
end
