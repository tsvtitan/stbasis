inherited frmMechanisms: TfrmMechanisms
  Left = 339
  Top = 283
  Width = 528
  Height = 428
  Caption = 'Mechanisms'
  Font.Name = 'MS Sans Serif'
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    Width = 520
    Height = 363
    inherited pnlBorder: TPanel
      Width = 512
      Height = 355
      inherited pnlTitle: TPanel
        Width = 510
        inherited lblTitle: TLabel
          Width = 129
          Caption = 'Mechanisms'
        end
        inherited imgAnyDAC: TImage
          Left = 213
        end
        inherited imgGradient: TImage
          Left = 156
        end
        inherited pnlBottom: TPanel
          Width = 510
        end
      end
      inherited pnlMain: TPanel
        Width = 510
        Height = 300
        inherited pnlConnection: TPanel
          Width = 510
          Height = 89
          inherited lblUseConnectionDef: TLabel
            Width = 126
          end
          object btnCreateTable: TSpeedButton [1]
            Left = 11
            Top = 56
            Width = 97
            Height = 21
            Caption = 'Create table'
            Flat = True
            OnClick = btnCreateTableClick
          end
          object btnCreateView: TSpeedButton [2]
            Left = 121
            Top = 56
            Width = 97
            Height = 21
            Caption = 'Create views'
            Enabled = False
            Flat = True
            OnClick = btnCreateViewClick
          end
          object btnPrint: TSpeedButton [3]
            Left = 231
            Top = 56
            Width = 89
            Height = 21
            Caption = 'Print'
            Enabled = False
            Flat = True
            OnClick = btnPrintClick
          end
        end
        inherited Console: TMemo
          Top = 89
          Width = 510
          Height = 211
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 363
    Width = 520
    inherited btnClose: TButton
      Left = 441
    end
  end
end
