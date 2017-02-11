object frmAveragesOptions: TfrmAveragesOptions
  Left = 339
  Top = 169
  Width = 387
  Height = 305
  Caption = 'frmAveragesOptions'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 379
    Height = 278
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'TabSheet1'
      object PanelSickOptions: TPanel
        Left = 0
        Top = 0
        Width = 371
        Height = 250
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object Label1: TLabel
          Left = 8
          Top = 16
          Width = 62
          Height = 13
          Caption = 'Больничные'
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'TabSheet2'
      ImageIndex = 1
      object PanelLeaveOptions: TPanel
        Left = 0
        Top = 0
        Width = 371
        Height = 250
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object Label2: TLabel
          Left = 8
          Top = 16
          Width = 56
          Height = 13
          Caption = 'Отпускные'
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'TabSheet3'
      ImageIndex = 2
      object PanelNoneOptions: TPanel
        Left = 0
        Top = 0
        Width = 371
        Height = 250
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
      end
    end
  end
end
