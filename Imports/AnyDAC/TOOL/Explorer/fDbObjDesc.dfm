inherited frmDbObjDesc: TfrmDbObjDesc
  Height = 405
  inherited pnlMainBG: TADGUIxFormsPanel
    Height = 405
    inherited pcMain: TADGUIxFormsPageControl
      Height = 405
      ActivePage = tsDef
      object tsDef: TTabSheet [0]
        Hint = 'Properties of current selected object'
        Caption = 'Properties'
        object Panel5: TADGUIxFormsPanel
          Left = 0
          Top = 3
          Width = 412
          Height = 330
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 1
          Color = clGray
          TabOrder = 0
          object sgDef: TStringGrid
            Left = 1
            Top = 1
            Width = 410
            Height = 328
            Hint = 'Definition of current selected object'
            Align = alClient
            BorderStyle = bsNone
            ColCount = 2
            DefaultRowHeight = 16
            FixedCols = 0
            Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing]
            TabOrder = 0
            ColWidths = (
              205
              194)
          end
        end
        object pnlPropertiesSubTitle: TADGUIxFormsPanel
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
      object tsData: TTabSheet [1]
        Hint = 'Rows of current selected object'
        Caption = 'Data'
        ImageIndex = 1
        object Panel6: TADGUIxFormsPanel
          Left = 0
          Top = 3
          Width = 412
          Height = 330
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 1
          Color = clGray
          TabOrder = 0
          object dbgData: TDBGrid
            Left = 1
            Top = 1
            Width = 410
            Height = 328
            Align = alClient
            BorderStyle = bsNone
            Ctl3D = False
            DataSource = dsData
            ParentCtl3D = False
            ParentShowHint = False
            PopupMenu = pmGrid
            ShowHint = False
            TabOrder = 0
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'Tahoma'
            TitleFont.Style = []
            OnColEnter = dbgColEnter
            OnDblClick = dbgDblClick
          end
        end
        object pnlDataSubTitle: TADGUIxFormsPanel
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
      inherited tsSQL: TTabSheet
        inherited Panel4: TADGUIxFormsPanel
          Height = 197
          inherited dbgSQL: TDBGrid
            Height = 195
          end
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
  object dsData: TDataSource
    DataSet = qData
    Left = 144
    Top = 80
  end
  object qData: TADQuery
    FetchOptions.Items = [fiBlobs, fiDetails]
    UpdateOptions.UseProviderFlags = False
    Left = 112
    Top = 80
  end
end
