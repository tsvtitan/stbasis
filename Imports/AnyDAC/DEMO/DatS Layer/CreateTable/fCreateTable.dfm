inherited frmCreateTable: TfrmCreateTable
  Left = 361
  Top = 230
  Width = 550
  Height = 380
  Caption = 'Create a table'
  Font.Name = 'MS Sans Serif'
  OldCreateOrder = False
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    Width = 542
    Height = 322
    inherited pnlBorder: TPanel
      Width = 534
      Height = 314
      inherited pnlTitle: TPanel
        Width = 532
        inherited lblTitle: TLabel
          Width = 147
          Caption = 'Create a table'
        end
        inherited imgAnyDAC: TImage
          Left = 235
        end
        inherited imgGradient: TImage
          Left = 178
        end
        inherited pnlBottom: TPanel
          Width = 532
        end
      end
      inherited pnlMain: TPanel
        Width = 532
        Height = 259
        inherited pnlControlButtons: TPanel
          Width = 532
          Height = 41
          object btnCreateTable: TSpeedButton
            Left = 11
            Top = 8
            Width = 89
            Height = 23
            Caption = 'Create table'
            Flat = True
            OnClick = btnCreateTableClick
          end
          object btnDefColumns: TSpeedButton
            Left = 116
            Top = 8
            Width = 89
            Height = 23
            Caption = 'Define Columns'
            Enabled = False
            Flat = True
            OnClick = btnDefColumnsClick
          end
        end
        inherited Console: TMemo
          Top = 41
          Width = 532
          Height = 218
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 322
    Width = 542
    inherited btnClose: TButton
      Left = 463
    end
  end
end
