inherited frmTools: TfrmTools
  Left = 1043
  Top = 240
  ActiveControl = lbTools
  Caption = 'Tools'
  ClientHeight = 255
  ClientWidth = 305
  OldCreateOrder = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 7
    Top = 0
    Width = 83
    Height = 13
    Caption = 'Configured &Tools:'
  end
  object btnAdd: TButton
    Left = 211
    Top = 15
    Width = 75
    Height = 25
    Action = ToolAdd
    Default = True
    TabOrder = 0
  end
  object btnDelete: TButton
    Left = 211
    Top = 48
    Width = 75
    Height = 25
    Action = ToolDelete
    TabOrder = 1
  end
  object btnEdit: TButton
    Left = 211
    Top = 80
    Width = 75
    Height = 25
    Action = ToolEdit
    TabOrder = 2
  end
  object lbTools: TListBox
    Left = 7
    Top = 16
    Width = 193
    Height = 226
    ItemHeight = 16
    Style = lbOwnerDrawFixed
    TabOrder = 3
    OnDrawItem = lbToolsDrawItem
  end
  object Button1: TButton
    Left = 218
    Top = 216
    Width = 75
    Height = 25
    Caption = '&Close'
    ModalResult = 1
    TabOrder = 4
  end
  object btnActions: TActionList
    Left = 236
    Top = 169
    object ToolAdd: TAction
      Caption = '&Add'
      OnExecute = ToolAddExecute
    end
    object ToolDelete: TAction
      Caption = '&Delete'
      OnExecute = ToolDeleteExecute
      OnUpdate = ToolDeleteUpdate
    end
    object ToolEdit: TAction
      Caption = '&Edit'
      OnExecute = ToolEditExecute
      OnUpdate = ToolDeleteUpdate
    end
    object ToolBtnUp: TAction
      ShortCut = 16469
    end
    object ToolBtnDown: TAction
      ShortCut = 16452
    end
    object ToolBtnClose: TAction
      Caption = '&Close'
    end
  end
end
