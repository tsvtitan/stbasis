inherited frmDbSetDesc: TfrmDbSetDesc
  Hint = 'Database object list properties'
  inherited pnlMainBG: TADGUIxFormsPanel
    inherited pcMain: TADGUIxFormsPageControl
      ActivePage = tsSummary
      object tsSummary: TTabSheet [0]
        Hint = 'List of objects'
        Caption = 'Summary'
        ImageIndex = 1
        object Panel8: TADGUIxFormsPanel
          Left = 0
          Top = 3
          Width = 412
          Height = 311
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 1
          Color = clGray
          TabOrder = 0
          object DBGrid1: TDBGrid
            Left = 1
            Top = 1
            Width = 410
            Height = 309
            Align = alClient
            BorderStyle = bsNone
            DataSource = dsSummary
            Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
            ParentShowHint = False
            PopupMenu = pmGrid
            ReadOnly = True
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
        object pnlSummarySubTitle: TADGUIxFormsPanel
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
  object qSummary: TADQuery
    FetchOptions.Items = [fiBlobs, fiDetails]
    Left = 48
    Top = 48
  end
  object dsSummary: TDataSource
    DataSet = qSummary
    Left = 80
    Top = 48
  end
  object mqSummary: TADMetaInfoQuery
    Left = 48
    Top = 80
  end
end
