inherited frmConnectionDefDesc: TfrmConnectionDefDesc
  Hint = 'Connection definition properties'
  inherited pnlMainBG: TADGUIxFormsPanel
    inherited pcMain: TADGUIxFormsPageControl
      Hint = 'Connection parameters'
      ActivePage = tsConnectionInfo
      object tsConnectionInfo: TTabSheet
        Caption = 'Info'
        ImageIndex = 2
        object Panel3: TADGUIxFormsPanel
          Left = 0
          Top = 3
          Width = 412
          Height = 311
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 1
          Caption = 'Panel1'
          Color = clGray
          TabOrder = 0
          object mmInfo: TMemo
            Left = 1
            Top = 1
            Width = 410
            Height = 309
            Hint = 'SQL query text'
            Align = alClient
            BorderStyle = bsNone
            ReadOnly = True
            TabOrder = 0
            OnChange = mmSQLChange
          end
        end
        object pnlInfoSubTitle: TADGUIxFormsPanel
          Left = 0
          Top = 0
          Width = 412
          Height = 3
          Align = alTop
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 1
        end
      end
    end
  end
  inherited qSQL: TADQuery
    Left = 0
    Top = 0
    Left = 0
    Top = 0
  end
end
