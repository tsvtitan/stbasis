inherited ADSpeedUIDBFrm: TADSpeedUIDBFrm
  Caption = 'AnyDAC DB Benchmark Suite'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlTopFrame: TADGUIxFormsPanel
    inherited pnlToolbar: TADGUIxFormsPanel
      inherited ToolBar: TToolBar
        object ToolButton2: TToolButton
          Left = 190
          Top = 0
          Width = 8
          Caption = 'ToolButton2'
          ImageIndex = 2
          Style = tbsSeparator
        end
        object ToolButton1: TToolButton
          Left = 198
          Top = 0
          Action = actConnect
        end
      end
    end
  end
  inherited ActionList1: TActionList
    object actConnect: TAction
      Category = 'Connection'
      Caption = '&Connect'
      ImageIndex = 9
      ShortCut = 118
      OnExecute = actConnectExecute
      OnUpdate = actOtherUpdate
    end
    object actDisconnect: TAction
      Category = 'Connection'
      Caption = '&Disconnect'
      ImageIndex = 10
      OnExecute = actDisconnectExecute
      OnUpdate = actOtherUpdate
    end
    object actEditDefinition: TAction
      Category = 'Connection'
      Caption = '&Edit Definitions'
      ImageIndex = 6
      ShortCut = 16462
      OnExecute = actEditDefinitionExecute
      OnUpdate = actOtherUpdate
    end
    object actGenData: TAction
      Category = 'Connection'
      Caption = 'Generate Data...'
      ImageIndex = 11
      ShortCut = 16455
      OnExecute = actGenDataExecute
      OnUpdate = actOtherUpdate
    end
  end
  inherited MainMenu1: TMainMenu
    object Connection1: TMenuItem [2]
      Caption = '&Connection'
      object Connect1: TMenuItem
        Action = actConnect
      end
      object Disconnect1: TMenuItem
        Action = actDisconnect
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object EditDefinitions1: TMenuItem
        Action = actEditDefinition
      end
      object GenerateData1: TMenuItem
        Action = actGenData
      end
    end
  end
end
