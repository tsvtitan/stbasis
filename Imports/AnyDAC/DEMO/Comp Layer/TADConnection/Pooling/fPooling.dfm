inherited frmMain: TfrmMain
  Left = 378
  Top = 185
  VertScrollBar.Range = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Pooling demo'
  ClientHeight = 299
  ClientWidth = 462
  Font.Name = 'MS Sans Serif'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    Width = 462
    Height = 248
    inherited pnlBorder: TPanel
      Width = 454
      Height = 240
      inherited pnlTitle: TPanel
        Width = 452
        inherited lblTitle: TLabel
          Width = 78
          Caption = 'Pooling'
        end
        inherited imgAnyDAC: TImage
          Left = 155
        end
        inherited imgGradient: TImage
          Left = 98
        end
        inherited pnlBottom: TPanel
          Width = 452
        end
      end
      inherited pnlMain: TPanel
        Width = 452
        Height = 185
        object Label1: TLabel [0]
          Left = 11
          Top = 130
          Width = 81
          Height = 13
          Caption = 'Total executions:'
        end
        object lblTotalExec: TLabel [1]
          Left = 100
          Top = 130
          Width = 9
          Height = 13
          Caption = '---'
        end
        object Label2: TLabel [2]
          Left = 11
          Top = 146
          Width = 49
          Height = 13
          Caption = 'Total time:'
        end
        object lblTotalTime: TLabel [3]
          Left = 100
          Top = 146
          Width = 9
          Height = 13
          Caption = '---'
        end
        object btnRun: TSpeedButton [4]
          Left = 11
          Top = 93
          Width = 75
          Height = 21
          Caption = 'Run'
          Enabled = False
          Flat = True
          OnClick = btnRunClick
        end
        object Bevel1: TBevel [5]
          Left = 0
          Top = 119
          Width = 265
          Height = 7
          Shape = bsBottomLine
        end
        inherited pnlConnection: TPanel
          Width = 452
          TabOrder = 1
          inherited lblUseConnectionDef: TLabel
            Width = 126
          end
        end
        object chPooled: TCheckBox
          Left = 11
          Top = 64
          Width = 82
          Height = 17
          Caption = 'Run pooled'
          TabOrder = 0
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 248
    Width = 462
    inherited btnClose: TButton
      Left = 383
    end
  end
  inherited StatusBar1: TStatusBar
    Top = 279
    Width = 462
    Height = 20
  end
end
