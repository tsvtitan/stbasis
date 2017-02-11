inherited frmMainLayers: TfrmMainLayers
  Left = 466
  Top = 279
  Position = poDesktopCenter
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    inherited pnlBorder: TPanel
      inherited pnlMain: TPanel
        object Console: TMemo
          Left = 0
          Top = 57
          Width = 618
          Height = 253
          Align = alClient
          BevelInner = bvSpace
          BevelKind = bkFlat
          BorderStyle = bsNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          ParentFont = False
          ScrollBars = ssBoth
          TabOrder = 1
        end
      end
    end
  end
end
