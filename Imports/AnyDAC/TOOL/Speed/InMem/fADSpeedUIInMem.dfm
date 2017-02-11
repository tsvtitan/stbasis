inherited ADSpeedUIInMemFrm: TADSpeedUIInMemFrm
  Height = 693
  Caption = 'AnyDAC Benchmark Suite [InMemory mode]'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl1: TPageControl
    Height = 573
    ActivePage = TabSheet2
    inherited TabSheet1: TTabSheet
      inherited Panel6: TADGUIxFormsPanel
        Height = 542
        inherited lvTests: TListView
          Height = 514
        end
      end
    end
    inherited TabSheet3: TTabSheet
      inherited Panel4: TADGUIxFormsPanel
        Height = 542
        inherited lvDSs: TListView
          Height = 514
        end
      end
    end
    inherited TabSheet2: TTabSheet
      inherited Panel2: TADGUIxFormsPanel
        Height = 542
        inherited grdResults: TStringGrid
          Height = 499
        end
        inherited Panel9: TADGUIxFormsPanel
          Top = 500
        end
      end
    end
  end
  inherited stbDown: TStatusBar
    Top = 608
  end
  inherited pnlTopFrame: TADGUIxFormsPanel
    inherited pnlToolbar: TADGUIxFormsPanel
      inherited ToolBar: TToolBar
        Height = 26
        ButtonHeight = 22
        object ToolButton1: TToolButton
          Left = 216
          Top = 0
          Width = 8
          Caption = 'ToolButton1'
          ImageIndex = 2
          Style = tbsSeparator
        end
        object Label3: TLabel
          Left = 224
          Top = 0
          Width = 70
          Height = 22
          Caption = 'Record Count:'
        end
        object edtRecordCount: TEdit
          Left = 294
          Top = 0
          Width = 77
          Height = 22
          TabOrder = 0
          Text = '100000'
          OnExit = edtRecordCountExit
          OnKeyDown = edtRecordCountKeyDown
        end
        object ToolButton2: TToolButton
          Left = 371
          Top = 0
          Width = 8
          Caption = 'ToolButton2'
          ImageIndex = 3
          Style = tbsSeparator
        end
        object cbUseBatch: TCheckBox
          Left = 379
          Top = 0
          Width = 136
          Height = 22
          Caption = 'Use Batch Capabilities'
          TabOrder = 1
          OnClick = cbUseBatchClick
        end
      end
    end
  end
end
