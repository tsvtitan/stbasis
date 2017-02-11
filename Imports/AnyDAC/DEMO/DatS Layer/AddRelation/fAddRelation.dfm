inherited frmAddRelation: TfrmAddRelation
  Left = 345
  Top = 219
  Width = 614
  Height = 454
  Caption = 'Add relation'
  Font.Name = 'MS Sans Serif'
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    Width = 606
    Height = 389
    inherited pnlBorder: TPanel
      Width = 598
      Height = 381
      inherited pnlTitle: TPanel
        Width = 596
        inherited lblTitle: TLabel
          Width = 127
          Caption = 'Add relation'
        end
        inherited imgAnyDAC: TImage
          Left = 299
        end
        inherited imgGradient: TImage
          Left = 242
        end
        inherited pnlBottom: TPanel
          Width = 596
        end
      end
      inherited pnlMain: TPanel
        Width = 596
        Height = 326
        inherited pnlControlButtons: TPanel
          Width = 596
          Height = 41
          object btnCreateDatSManager: TSpeedButton
            Left = 11
            Top = 8
            Width = 121
            Height = 23
            Caption = 'Create DatS Manager'
            Flat = True
            OnClick = btnCreateDatSManagerClick
          end
          object btnCreateRel: TSpeedButton
            Left = 147
            Top = 8
            Width = 121
            Height = 23
            Caption = 'Create relation'
            Enabled = False
            Flat = True
            OnClick = btnCreateRelClick
          end
        end
        inherited Console: TMemo
          Top = 41
          Width = 596
          Height = 285
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 389
    Width = 606
    inherited btnClose: TButton
      Left = 527
    end
  end
end
