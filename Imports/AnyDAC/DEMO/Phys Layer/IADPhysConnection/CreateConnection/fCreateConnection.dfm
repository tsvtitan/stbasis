inherited frmCreateConnection: TfrmCreateConnection
  Left = 341
  Top = 289
  Caption = 'Create Connection'
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    inherited pnlBorder: TPanel
      inherited pnlTitle: TPanel
        inherited lblTitle: TLabel
          Width = 192
          Caption = 'Create Connection'
        end
      end
      inherited pnlMain: TPanel
        object Console: TMemo
          Left = 0
          Top = 41
          Width = 618
          Height = 269
          Align = alClient
          BevelInner = bvSpace
          BevelKind = bkFlat
          BorderStyle = bsNone
          TabOrder = 0
        end
        object Panel1: TPanel
          Left = 0
          Top = 0
          Width = 618
          Height = 41
          Align = alTop
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 1
          object btnCreateConnection: TSpeedButton
            Left = 11
            Top = 8
            Width = 113
            Height = 21
            Caption = 'Create Connection'
            Flat = True
            OnClick = btnCreateConnectionClick
          end
        end
      end
    end
  end
end
