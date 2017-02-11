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
  inherited pnlSubstrate: TPanel
    Width = 601
    Height = 414
    inherited pnlBorder: TPanel
      Width = 593
      Height = 406
      inherited pnlTitle: TPanel
        Width = 591
        inherited lblTitle: TLabel
          Width = 141
          Caption = 'Autoinc fields'
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
        Height = 351
        inherited pnlConnection: TPanel
          Width = 591
          inherited lblUseConnectionDef: TLabel
            Width = 126
          end
        end
        inherited Console: TMemo
          Width = 591
          Height = 294
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 414
    Width = 601
    inherited btnClose: TButton
      Left = 522
    end
  end
end
