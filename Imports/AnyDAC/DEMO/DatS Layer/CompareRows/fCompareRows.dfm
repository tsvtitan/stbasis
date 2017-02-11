inherited frmCompareRows: TfrmCompareRows
  Caption = 'Compare rows'
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    inherited pnlBorder: TPanel
      inherited pnlTitle: TPanel
        inherited lblTitle: TLabel
          Width = 152
          Caption = 'Compare rows'
        end
      end
      inherited pnlMain: TPanel
        inherited pnlControlButtons: TPanel
          Height = 33
          object SpeedButton1: TSpeedButton
            Left = 11
            Top = 6
            Width = 85
            Height = 21
            Caption = 'Compare rows'
            Flat = True
            OnClick = SpeedButton1Click
          end
        end
        inherited Console: TMemo
          Top = 33
          Height = 284
        end
      end
    end
  end
end
