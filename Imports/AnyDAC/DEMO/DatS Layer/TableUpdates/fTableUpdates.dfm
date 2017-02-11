inherited frmTableUpdates: TfrmTableUpdates
  Left = 417
  Top = 257
  Width = 549
  Height = 553
  Caption = 'Table Updates'
  Font.Name = 'MS Sans Serif'
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    Width = 541
    Height = 488
    inherited pnlBorder: TPanel
      Width = 533
      Height = 480
      inherited pnlTitle: TPanel
        Width = 531
        inherited lblTitle: TLabel
          Width = 150
          Caption = 'Table Updates'
        end
        inherited imgAnyDAC: TImage
          Left = 234
        end
        inherited imgGradient: TImage
          Left = 177
        end
        inherited pnlBottom: TPanel
          Width = 531
        end
      end
      inherited pnlMain: TPanel
        Width = 531
        Height = 425
        inherited pnlConnection: TPanel
          Width = 531
          Height = 129
          inherited lblUseConnectionDef: TLabel
            Width = 126
          end
          object btnChange: TSpeedButton [1]
            Left = 11
            Top = 52
            Width = 76
            Height = 21
            Caption = 'Change rows'
            Enabled = False
            Flat = True
            OnClick = btnChangeClick
          end
          object btnAccept: TSpeedButton [2]
            Left = 11
            Top = 76
            Width = 76
            Height = 21
            Caption = 'Accept'
            Enabled = False
            Flat = True
            OnClick = btnAcceptClick
          end
          object btnReject: TSpeedButton [3]
            Left = 96
            Top = 76
            Width = 76
            Height = 21
            Caption = 'Reject'
            Enabled = False
            Flat = True
            OnClick = btnRejectClick
          end
          object btnFirstChange: TSpeedButton [4]
            Left = 11
            Top = 100
            Width = 76
            Height = 21
            Caption = 'First change'
            Enabled = False
            Flat = True
            OnClick = btnFirstChangeClick
          end
          object btnSavePoint: TSpeedButton [5]
            Left = 96
            Top = 52
            Width = 76
            Height = 21
            Caption = 'SavePoint'
            Enabled = False
            Flat = True
            OnClick = btnSavePointClick
          end
          object btnNextChange: TSpeedButton [6]
            Left = 96
            Top = 100
            Width = 76
            Height = 21
            Caption = 'Next change'
            Enabled = False
            Flat = True
            OnClick = btnNextChangeClick
          end
          object btnLastChange: TSpeedButton [7]
            Left = 181
            Top = 100
            Width = 76
            Height = 21
            Caption = 'Last change'
            Enabled = False
            Flat = True
            OnClick = btnLastChangeClick
          end
          object btnRestorePoint: TSpeedButton [8]
            Left = 181
            Top = 52
            Width = 76
            Height = 21
            Caption = 'RestorePoint'
            Enabled = False
            Flat = True
            OnClick = btnRestorePointClick
          end
        end
        inherited Console: TMemo
          Top = 129
          Width = 531
          Height = 296
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 488
    Width = 541
    inherited btnClose: TButton
      Left = 462
    end
  end
end
