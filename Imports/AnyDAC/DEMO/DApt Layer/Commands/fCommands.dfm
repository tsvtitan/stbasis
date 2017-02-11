inherited frmCommands: TfrmCommands
  Left = 347
  Top = 254
  Width = 609
  Height = 471
  Caption = 'Commands'
  Font.Name = 'MS Sans Serif'
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    Width = 601
    Height = 413
    inherited pnlBorder: TPanel
      Width = 593
      Height = 405
      inherited pnlTitle: TPanel
        Width = 591
        inherited lblTitle: TLabel
          Width = 117
          Caption = 'Commands'
        end
        inherited imgAnyDAC: TImage
          Left = 415
        end
        inherited imgGradient: TImage
          Left = 302
        end
        inherited pnlBottom: TPanel
          Width = 591
        end
      end
      inherited pnlMain: TPanel
        Width = 591
        Height = 350
        inherited pnlConnection: TPanel
          Width = 591
          inherited lblUseConnectionDef: TLabel
            Width = 126
          end
        end
        inherited Console: TMemo
          Width = 591
          Height = 293
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 413
    Width = 601
    inherited btnClose: TButton
      Left = 522
    end
  end
end
