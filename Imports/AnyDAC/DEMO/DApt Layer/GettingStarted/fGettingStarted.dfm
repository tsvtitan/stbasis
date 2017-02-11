inherited frmGettingStarted: TfrmGettingStarted
  Left = 347
  Top = 254
  Width = 556
  Height = 474
  Caption = 'Getting Started'
  Font.Name = 'MS Sans Serif'
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    Width = 548
    Height = 416
    inherited pnlBorder: TPanel
      Width = 540
      Height = 408
      inherited pnlTitle: TPanel
        Width = 538
        inherited lblTitle: TLabel
          Width = 162
          Caption = 'Getting Started'
        end
        inherited imgAnyDAC: TImage
          Left = 241
        end
        inherited imgGradient: TImage
          Left = 184
        end
        inherited pnlBottom: TPanel
          Width = 538
        end
      end
      inherited pnlMain: TPanel
        Width = 538
        Height = 353
        inherited pnlConnection: TPanel
          Width = 538
          inherited lblUseConnectionDef: TLabel
            Width = 126
          end
        end
        inherited Console: TMemo
          Width = 538
          Height = 296
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 416
    Width = 548
    inherited btnClose: TButton
      Left = 469
    end
  end
end
