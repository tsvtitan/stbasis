inherited frmCreateRows: TfrmCreateRows
  Left = 342
  Top = 239
  Width = 457
  Height = 369
  Caption = 'Create rows'
  Font.Name = 'MS Sans Serif'
  OldCreateOrder = False
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    Width = 449
    Height = 304
    inherited pnlBorder: TPanel
      Width = 441
      Height = 296
      inherited pnlTitle: TPanel
        Width = 439
        inherited lblTitle: TLabel
          Width = 133
          Caption = 'Create Rows'
        end
        inherited imgAnyDAC: TImage
          Left = 142
        end
        inherited imgGradient: TImage
          Left = 85
        end
        inherited pnlBottom: TPanel
          Width = 439
        end
      end
      inherited pnlMain: TPanel
        Width = 439
        Height = 241
        inherited pnlControlButtons: TPanel
          Width = 439
          Height = 41
          object btnCreateTable: TSpeedButton
            Left = 11
            Top = 8
            Width = 77
            Height = 21
            Caption = 'Create table'
            Flat = True
            OnClick = btnCreateTableClick
          end
          object btnPopulate: TSpeedButton
            Left = 103
            Top = 8
            Width = 77
            Height = 21
            Caption = 'Populate'
            Enabled = False
            Flat = True
            OnClick = btnPopulateClick
          end
          object btnPrint: TSpeedButton
            Left = 195
            Top = 8
            Width = 76
            Height = 21
            Caption = 'Print rows'
            Enabled = False
            Flat = True
            OnClick = btnPrintClick
          end
        end
        inherited Console: TMemo
          Top = 41
          Width = 439
          Height = 200
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 304
    Width = 449
    inherited btnClose: TButton
      Left = 374
      Width = 70
    end
  end
end
