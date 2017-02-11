inherited frmAcceptChanges: TfrmAcceptChanges
  Left = 315
  Top = 197
  Width = 658
  Height = 504
  Caption = 'Schema Accept/Reject changes'
  Font.Name = 'MS Sans Serif'
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    Width = 650
    Height = 439
    inherited pnlBorder: TPanel
      Width = 642
      Height = 431
      inherited pnlTitle: TPanel
        Width = 640
        inherited lblTitle: TLabel
          Width = 237
          Caption = 'Schema Accept/Reject'
        end
        inherited imgAnyDAC: TImage
          Left = 343
        end
        inherited imgGradient: TImage
          Left = 286
        end
        inherited pnlBottom: TPanel
          Width = 640
        end
      end
      inherited pnlMain: TPanel
        Width = 640
        Height = 376
        inherited pnlConnection: TPanel
          Width = 640
          Height = 81
          inherited lblUseConnectionDef: TLabel
            Width = 126
          end
          object btnChange: TSpeedButton [1]
            Left = 11
            Top = 51
            Width = 76
            Height = 21
            Caption = 'Change rows'
            Enabled = False
            Flat = True
            OnClick = btnChangeClick
          end
          object btnAccept: TSpeedButton [2]
            Left = 96
            Top = 51
            Width = 76
            Height = 21
            Caption = 'Accept'
            Enabled = False
            Flat = True
            OnClick = btnAcceptClick
          end
          object btnReject: TSpeedButton [3]
            Left = 181
            Top = 51
            Width = 76
            Height = 21
            Caption = 'Reject'
            Enabled = False
            Flat = True
            OnClick = btnRejectClick
          end
          object btnJournal: TSpeedButton [4]
            Left = 266
            Top = 51
            Width = 76
            Height = 21
            Caption = 'Journal'
            Enabled = False
            Flat = True
            OnClick = btnJournalClick
          end
        end
        inherited Console: TMemo
          Top = 81
          Width = 640
          Height = 295
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 439
    Width = 650
    inherited btnClose: TButton
      Left = 571
    end
  end
end
