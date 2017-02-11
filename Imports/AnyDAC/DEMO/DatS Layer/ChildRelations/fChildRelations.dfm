inherited frmChildRelations: TfrmChildRelations
  Left = 354
  Top = 206
  Width = 590
  Height = 480
  Caption = 'Child relations'
  Font.Name = 'MS Sans Serif'
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    Width = 582
    Height = 415
    inherited pnlBorder: TPanel
      Width = 574
      Height = 407
      inherited pnlTitle: TPanel
        Width = 572
        inherited lblTitle: TLabel
          Width = 150
          Caption = 'Child relations'
        end
        inherited imgAnyDAC: TImage
          Left = 275
        end
        inherited imgGradient: TImage
          Left = 218
        end
        inherited pnlBottom: TPanel
          Width = 572
        end
      end
      inherited pnlMain: TPanel
        Width = 572
        Height = 352
        inherited pnlControlButtons: TPanel
          Width = 572
          Height = 41
          BorderWidth = 11
          object btnSelect: TSpeedButton
            Left = 187
            Top = 8
            Width = 76
            Height = 21
            Caption = 'Select'
            Flat = True
            OnClick = btnSelectClick
          end
          object btnChildRels: TSpeedButton
            Left = 11
            Top = 8
            Width = 76
            Height = 21
            Caption = 'ChildRelations'
            Flat = True
            OnClick = btnChildRelsClick
          end
          object btnCompute: TSpeedButton
            Left = 99
            Top = 8
            Width = 76
            Height = 21
            Caption = 'Compute'
            Flat = True
            OnClick = btnComputeClick
          end
        end
        inherited Console: TMemo
          Top = 41
          Width = 572
          Height = 311
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 415
    Width = 582
    inherited btnClose: TButton
      Left = 503
    end
  end
end
