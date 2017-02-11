inherited frmMasterDetails: TfrmMasterDetails
  Left = 277
  Top = 195
  Width = 716
  Height = 501
  Caption = 'Master details and auto incremental fields'
  Font.Name = 'MS Sans Serif'
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    Width = 708
    Height = 436
    inherited pnlBorder: TPanel
      Width = 700
      Height = 428
      inherited pnlTitle: TPanel
        Width = 698
        inherited lblTitle: TLabel
          Width = 324
          Caption = 'Master Details (auto inc fields)'
        end
        inherited imgAnyDAC: TImage
          Left = 401
        end
        inherited imgGradient: TImage
          Left = 344
        end
        inherited pnlBottom: TPanel
          Width = 698
        end
      end
      inherited pnlMain: TPanel
        Width = 698
        Height = 373
        inherited pnlConnection: TPanel
          Width = 698
          Height = 81
          inherited lblUseConnectionDef: TLabel
            Width = 126
          end
          object btnInsertMast: TSpeedButton [1]
            Left = 11
            Top = 52
            Width = 92
            Height = 21
            Caption = 'Insert into master'
            Enabled = False
            Flat = True
            OnClick = btnInsertMastClick
          end
          object btnInsertDet: TSpeedButton [2]
            Left = 114
            Top = 52
            Width = 90
            Height = 21
            Caption = 'Insert into details'
            Enabled = False
            Flat = True
            OnClick = btnInsertDetClick
          end
          object btnPrint: TSpeedButton [3]
            Left = 215
            Top = 52
            Width = 64
            Height = 21
            Caption = 'Print'
            Enabled = False
            Flat = True
            OnClick = btnPrintClick
          end
        end
        inherited Console: TMemo
          Top = 81
          Width = 698
          Height = 292
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 436
    Width = 708
    inherited btnClose: TButton
      Left = 629
    end
  end
end
