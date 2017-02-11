inherited frmFetchTable: TfrmFetchTable
  Left = 383
  Top = 267
  Width = 547
  Height = 471
  Caption = 'Fetch a table'
  Font.Name = 'MS Sans Serif'
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    Width = 539
    Height = 413
    inherited pnlBorder: TPanel
      Width = 531
      Height = 405
      inherited pnlTitle: TPanel
        Width = 529
        inherited lblTitle: TLabel
          Width = 135
          Caption = 'Fetch a table'
        end
        inherited imgAnyDAC: TImage
          Left = 232
        end
        inherited imgGradient: TImage
          Left = 175
        end
        inherited pnlBottom: TPanel
          Width = 529
        end
      end
      inherited pnlMain: TPanel
        Width = 529
        Height = 350
        inherited pnlConnection: TPanel
          Width = 529
          inherited lblUseConnectionDef: TLabel
            Width = 126
          end
        end
        inherited Console: TMemo
          Width = 529
          Height = 293
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 413
    Width = 539
    inherited btnClose: TButton
      Left = 460
    end
  end
end
