inherited frmMain: TfrmMain
  Left = 419
  Top = 175
  Width = 539
  Height = 541
  Caption = 'TADDataMove'
  Font.Name = 'MS Sans Serif'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    Width = 531
    Height = 457
    inherited pnlBorder: TPanel
      Width = 523
      Height = 449
      inherited pnlTitle: TPanel
        Width = 521
        inherited lblTitle: TLabel
          Width = 133
          Caption = 'Moving Data'
        end
        inherited imgAnyDAC: TImage
          Left = 224
        end
        inherited imgGradient: TImage
          Left = 167
        end
        inherited pnlBottom: TPanel
          Width = 521
        end
      end
      inherited pnlMain: TPanel
        Width = 521
        Height = 394
        object Splitter1: TSplitter [0]
          Left = 0
          Top = 227
          Width = 521
          Height = 3
          Cursor = crVSplit
          Align = alTop
        end
        inherited pnlConnection: TPanel
          Width = 521
          inherited lblUseConnectionDef: TLabel
            Width = 126
          end
        end
        object Panel1: TPanel
          Left = 0
          Top = 57
          Width = 521
          Height = 26
          Align = alTop
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 1
          object btnTabToASCMove: TSpeedButton
            Left = 11
            Top = 0
            Width = 130
            Height = 23
            Caption = '1.) Move ASCII to table'
            Enabled = False
            Flat = True
            OnClick = btnASCToTabMoveClick
          end
          object btnASCToTabMove: TSpeedButton
            Left = 152
            Top = 0
            Width = 130
            Height = 23
            Caption = '2.) Move table to table'
            Enabled = False
            Flat = True
            OnClick = btnTabToTabMoveClick
          end
          object btnTabToTabMove: TSpeedButton
            Left = 293
            Top = 0
            Width = 130
            Height = 23
            Caption = '3.) Move table to ASCII'
            Enabled = False
            Flat = True
            OnClick = btnTabToASCMoveClick
          end
        end
        object Panel2: TPanel
          Left = 0
          Top = 83
          Width = 521
          Height = 24
          Align = alTop
          Alignment = taLeftJustify
          BevelOuter = bvNone
          Caption = '   Loaded data'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentColor = True
          ParentFont = False
          TabOrder = 2
        end
        object grdLoaded: TDBGrid
          Left = 0
          Top = 107
          Width = 521
          Height = 120
          Align = alTop
          BorderStyle = bsNone
          Ctl3D = True
          DataSource = dsLoaded
          ParentCtl3D = False
          TabOrder = 3
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
        end
        object Panel3: TPanel
          Left = 0
          Top = 230
          Width = 521
          Height = 24
          Align = alTop
          Alignment = taLeftJustify
          BevelOuter = bvNone
          Caption = '   Moved data'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentColor = True
          ParentFont = False
          TabOrder = 4
        end
        object grdMoved: TDBGrid
          Left = 0
          Top = 254
          Width = 521
          Height = 140
          Align = alClient
          BorderStyle = bsNone
          Ctl3D = True
          DataSource = dsMoved
          ParentCtl3D = False
          TabOrder = 5
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 457
    Width = 531
    inherited btnClose: TButton
      Left = 452
    end
  end
  inherited StatusBar1: TStatusBar
    Top = 488
    Width = 531
  end
  object dtmMain: TADDataMove
    AsciiDataDef.Fields = <>
    AsciiDataDef.WithFieldNames = True
    AsciiFileName = 'Data.txt'
    Mappings = <>
    Options = [poOptimiseSrc, poAbortOnExc]
    LogFileName = 'Data.log'
    Left = 404
    Top = 222
  end
  object qryMoved: TADQuery
    Connection = dmlMainComp.dbMain
    FetchOptions.Items = [fiBlobs, fiDetails]
    SQL.Strings = (
      'select * from {id ADQA_LockTable}')
    Left = 444
    Top = 248
  end
  object qryLoaded: TADQuery
    Connection = dmlMainComp.dbMain
    FetchOptions.Items = [fiBlobs, fiDetails]
    SQL.Strings = (
      'select * from {id ADQA_TransTable}')
    Left = 444
    Top = 192
  end
  object dsMoved: TDataSource
    DataSet = qryMoved
    Left = 480
    Top = 248
  end
  object dsLoaded: TDataSource
    DataSet = qryLoaded
    Left = 480
    Top = 192
  end
end
