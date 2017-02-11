inherited frmDatSLayerBase: TfrmDatSLayerBase
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    inherited pnlBorder: TPanel
      inherited pnlMain: TPanel
        object pnlControlButtons: TPanel
          Left = 0
          Top = 0
          Width = 540
          Height = 57
          Align = alTop
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 0
        end
        object Console: TMemo
          Left = 0
          Top = 57
          Width = 540
          Height = 260
          Align = alClient
          BevelInner = bvSpace
          BevelKind = bkFlat
          BorderStyle = bsNone
          Ctl3D = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          ScrollBars = ssBoth
          TabOrder = 1
        end
      end
    end
  end
end
