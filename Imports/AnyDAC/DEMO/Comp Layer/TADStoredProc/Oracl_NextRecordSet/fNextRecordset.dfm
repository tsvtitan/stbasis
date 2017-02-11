inherited frmNextRecordset: TfrmNextRecordset
  Left = 357
  Top = 242
  VertScrollBar.Range = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Oracle Stored procedures - Next recordset'
  ClientHeight = 525
  ClientWidth = 584
  Font.Charset = RUSSIAN_CHARSET
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    Width = 584
    Height = 475
    inherited pnlBorder: TPanel
      Width = 576
      Height = 467
      inherited pnlTitle: TPanel
        Width = 574
        inherited lblTitle: TLabel
          Width = 191
          Caption = 'Stored procedures'
        end
        inherited imgAnyDAC: TImage
          Left = 274
        end
        inherited imgGradient: TImage
          Left = 217
        end
        inherited pnlBottom: TPanel
          Width = 574
        end
      end
      inherited pnlMain: TPanel
        Width = 574
        Height = 412
        object Label1: TLabel [0]
          Left = 11
          Top = 272
          Width = 20
          Height = 13
          Caption = 'pin1'
        end
        object Label2: TLabel [1]
          Left = 11
          Top = 296
          Width = 20
          Height = 13
          Caption = 'pin2'
        end
        object Label3: TLabel [2]
          Left = 11
          Top = 359
          Width = 28
          Height = 13
          Caption = 'pout1'
        end
        object Label4: TLabel [3]
          Left = 11
          Top = 383
          Width = 28
          Height = 13
          Caption = 'pout2'
        end
        object Label5: TLabel [4]
          Left = 0
          Top = 29
          Width = 268
          Height = 13
          Caption = ' Result of fetching from DEMO_TESTPRC.REFCRS'
          Color = clBackground
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWhite
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object Label6: TLabel [5]
          Left = 0
          Top = 245
          Width = 574
          Height = 13
          Align = alTop
          Caption = ' Input / output parameters of DEMO_TESTPRC.INOUTPARS'
          Color = clSkyBlue
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object Label7: TLabel [6]
          Left = 0
          Top = 57
          Width = 574
          Height = 13
          Align = alTop
          Caption = ' Cursor parameters of DEMO_TESTPRC.REFCRS'
          Color = clSkyBlue
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        inherited pnlConnection: TPanel
          Width = 574
          TabOrder = 7
          inherited cbDB: TComboBox
            Enabled = False
          end
          object Memo1: TMemo
            Left = 232
            Top = 8
            Width = 336
            Height = 42
            BevelInner = bvSpace
            BevelKind = bkFlat
            BorderStyle = bsNone
            Color = clInfoBk
            Lines.Strings = (
              'For cursor parameters, as for multiple result sets, you should'
              'set FetchOptions.AutoClose to False.')
            ReadOnly = True
            TabOrder = 1
          end
        end
        object DBGrid1: TDBGrid
          Left = 0
          Top = 103
          Width = 574
          Height = 142
          Align = alTop
          BorderStyle = bsNone
          Ctl3D = True
          DataSource = dsRefCrs
          ParentCtl3D = False
          TabOrder = 0
          TitleFont.Charset = RUSSIAN_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
        end
        object edtPin1: TEdit
          Left = 44
          Top = 269
          Width = 121
          Height = 21
          BevelInner = bvSpace
          BevelKind = bkFlat
          BorderStyle = bsNone
          TabOrder = 1
          Text = '10'
        end
        object edtPin2: TEdit
          Left = 44
          Top = 293
          Width = 121
          Height = 21
          BevelInner = bvSpace
          BevelKind = bkFlat
          BorderStyle = bsNone
          TabOrder = 2
          Text = 'qq'
        end
        object edtPout1: TEdit
          Left = 44
          Top = 356
          Width = 121
          Height = 21
          BevelInner = bvSpace
          BevelKind = bkFlat
          BorderStyle = bsNone
          TabOrder = 3
        end
        object edtPout2: TEdit
          Left = 44
          Top = 380
          Width = 121
          Height = 21
          BevelInner = bvSpace
          BevelKind = bkFlat
          BorderStyle = bsNone
          TabOrder = 4
        end
        object btnExecProc: TButton
          Left = 44
          Top = 319
          Width = 75
          Height = 25
          Caption = 'ExecProc'
          TabOrder = 5
          OnClick = btnExecProcClick
        end
        object Panel1: TPanel
          Left = 0
          Top = 70
          Width = 574
          Height = 33
          Align = alTop
          BevelOuter = bvLowered
          TabOrder = 6
          object btnReopen: TSpeedButton
            Left = 11
            Top = 5
            Width = 49
            Height = 22
            Caption = 'Reopen'
            Flat = True
            OnClick = btnReopenClick
          end
          object btnNextRS: TSpeedButton
            Left = 71
            Top = 5
            Width = 94
            Height = 22
            Caption = 'Next record set'
            Flat = True
            OnClick = btnNextRSClick
          end
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 475
    Width = 584
    inherited btnClose: TButton
      Left = 505
    end
  end
  inherited StatusBar1: TStatusBar
    Top = 506
    Width = 584
  end
  object spRefCrs: TADStoredProc
    Connection = dmlMainComp.dbMain
    FetchOptions.AutoClose = False
    PackageName = 'DEMO_TESTPRC'
    StoredProcName = 'REFCRS'
    Left = 248
    Top = 197
  end
  object dsRefCrs: TDataSource
    DataSet = spRefCrs
    Left = 280
    Top = 197
  end
  object spInOutPars: TADStoredProc
    Connection = dmlMainComp.dbMain
    PackageName = 'DEMO_TESTPRC'
    StoredProcName = 'INOUTPARS'
    Left = 248
    Top = 245
  end
end
