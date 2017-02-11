inherited frmPooling: TfrmPooling
  Left = 326
  Top = 223
  VertScrollBar.Range = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Pooling demo'
  ClientHeight = 425
  ClientWidth = 469
  Font.Name = 'MS Sans Serif'
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    Width = 469
    Height = 394
    inherited pnlBorder: TPanel
      Width = 461
      Height = 386
      inherited pnlTitle: TPanel
        Width = 459
        inherited lblTitle: TLabel
          Width = 78
          Caption = 'Pooling'
        end
        inherited imgAnyDAC: TImage
          Left = 162
        end
        inherited imgGradient: TImage
          Left = 105
        end
        inherited pnlBottom: TPanel
          Width = 459
        end
      end
      inherited pnlMain: TPanel
        Width = 459
        Height = 331
        inherited pnlConnection: TPanel
          Width = 459
          Height = 129
          inherited lblUseConnectionDef: TLabel
            Width = 126
          end
          object Label1: TLabel [1]
            Left = 16
            Top = 93
            Width = 81
            Height = 13
            Caption = 'Total executions:'
          end
          object lblTotalExec: TLabel [2]
            Left = 104
            Top = 93
            Width = 9
            Height = 13
            Caption = '---'
          end
          object Label2: TLabel [3]
            Left = 16
            Top = 109
            Width = 49
            Height = 13
            Caption = 'Total time:'
          end
          object lblTotalTime: TLabel [4]
            Left = 104
            Top = 109
            Width = 9
            Height = 13
            Caption = '---'
          end
          object btnRun: TSpeedButton [5]
            Left = 16
            Top = 58
            Width = 76
            Height = 23
            Caption = 'Run'
            Enabled = False
            Flat = True
            OnClick = btnRunClick
          end
          inherited cbDB: TComboBox
            TabOrder = 1
          end
          object cbPooled: TCheckBox
            Left = 99
            Top = 61
            Width = 82
            Height = 17
            Caption = 'Run pooled'
            Enabled = False
            TabOrder = 0
          end
        end
        inherited Console: TMemo
          Top = 129
          Width = 459
          Height = 202
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 394
    Width = 469
    inherited btnClose: TButton
      Left = 390
    end
  end
end
