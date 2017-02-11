inherited frmMain: TfrmMain
  Left = 347
  Top = 254
  Width = 609
  Height = 472
  Caption = 'Autoinc fields'
  Font.Name = 'MS Sans Serif'
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inherited StatusBar1: TStatusBar
    Top = 426
    Width = 601
  end
  inherited pnlSubstrate: TPanel
    Width = 601
    Height = 426
    inherited pnlButtons: TPanel
      Top = 385
      Width = 579
      inherited lblInfo: TLabel
        Width = 43
      end
      inherited btnClose: TButton
        Left = 514
      end
    end
    inherited pnlBorder: TPanel
      Width = 579
      Height = 374
      inherited pnlTitle: TPanel
        Width = 577
        inherited lblTitle: TLabel
          Width = 183
          Caption = 'Autoinc fields'
        end
        inherited imgAnyDAC: TImage
          Left = 477
        end
      end
      inherited pnlMain: TPanel
        Width = 577
        Height = 315
        inherited pnlConnection: TPanel
          Width = 577
          inherited lblUseConnectionDef: TLabel
            Width = 126
          end
        end
        inherited Console: TMemo
          Width = 577
          Height = 260
        end
      end
    end
  end
end
