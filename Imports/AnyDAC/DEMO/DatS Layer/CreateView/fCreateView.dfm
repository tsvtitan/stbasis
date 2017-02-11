inherited frmCreateView: TfrmCreateView
  Left = 355
  Top = 234
  Width = 576
  Height = 503
  Caption = 'Create DatS View'
  Font.Name = 'MS Sans Serif'
  OldCreateOrder = False
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    Width = 568
    Height = 438
    inherited pnlBorder: TPanel
      Width = 560
      Height = 430
      inherited pnlTitle: TPanel
        Width = 558
        inherited lblTitle: TLabel
          Width = 183
          Caption = 'Create DatS View'
        end
        inherited imgAnyDAC: TImage
          Left = 261
        end
        inherited imgGradient: TImage
          Left = 204
        end
        inherited pnlBottom: TPanel
          Width = 558
        end
      end
      inherited pnlMain: TPanel
        Width = 558
        Height = 375
        inherited pnlControlButtons: TPanel
          Width = 558
          Height = 39
          object btnCreateTable: TSpeedButton
            Left = 11
            Top = 8
            Width = 97
            Height = 21
            Caption = 'Create table'
            Flat = True
            OnClick = btnCreateTableClick
          end
          object btnCreateView: TSpeedButton
            Left = 115
            Top = 8
            Width = 97
            Height = 21
            Caption = 'Create view'
            Enabled = False
            Flat = True
            OnClick = btnCreateViewClick
          end
          object btnPrint: TSpeedButton
            Left = 219
            Top = 8
            Width = 89
            Height = 21
            Caption = 'Print'
            Enabled = False
            Flat = True
            OnClick = btnPrintClick
          end
        end
        inherited Console: TMemo
          Top = 39
          Width = 558
          Height = 336
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 438
    Width = 568
    inherited btnClose: TButton
      Left = 489
    end
  end
end
