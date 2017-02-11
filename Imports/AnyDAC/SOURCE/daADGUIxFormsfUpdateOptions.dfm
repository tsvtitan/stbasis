object frmADGUIxFormsUpdateOptions: TfrmADGUIxFormsUpdateOptions
  Left = 0
  Top = 0
  Width = 538
  Height = 327
  Hint = 'Update Options'
  Color = clWindow
  Ctl3D = False
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  ParentColor = False
  ParentCtl3D = False
  ParentFont = False
  TabOrder = 0
  object uo_Panel6: TADGUIxFormsPanel
    Left = 0
    Top = 0
    Width = 413
    Height = 127
    BevelOuter = bvNone
    Caption = ' General Updating'
    ParentColor = True
    TabOrder = 2
    object uo_cbEnableInsert: TCheckBox
      Left = 11
      Top = 12
      Width = 94
      Height = 17
      Caption = 'Enable &insert'
      TabOrder = 0
      OnClick = uo_Change
    end
    object uo_cbEnableUpdate: TCheckBox
      Left = 11
      Top = 37
      Width = 90
      Height = 17
      Caption = 'Enable u&pdate'
      TabOrder = 1
      OnClick = uo_Change
    end
    object uo_cbEnableDelete: TCheckBox
      Left = 11
      Top = 62
      Width = 94
      Height = 17
      Caption = 'Enable &delete'
      TabOrder = 2
      OnClick = uo_Change
    end
    object Panel1: TADGUIxFormsPanel
      Left = 11
      Top = 91
      Width = 75
      Height = 22
      BevelOuter = bvNone
      BorderWidth = 1
      Color = clBtnShadow
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 3
      object Panel2: TADGUIxFormsPanel
        Left = 1
        Top = 1
        Width = 73
        Height = 20
        Align = alClient
        BevelOuter = bvNone
        Color = clWindow
        Ctl3D = True
        ParentCtl3D = False
        TabOrder = 0
        object uo_SpeedButton1: TSpeedButton
          Left = 0
          Top = 0
          Width = 73
          Height = 20
          Anchors = [akLeft, akTop, akRight, akBottom]
          Caption = 'Shortcuts ...'
          Flat = True
          PopupMenu = uo_PopupMenu1
          OnClick = uo_SpeedButton1Click
        end
      end
    end
  end
  object uo_GroupBox3: TADGUIxFormsPanel
    Left = 8
    Top = 159
    Width = 244
    Height = 166
    Caption = ' Posting Changes'
    Ctl3D = True
    ParentColor = True
    ParentCtl3D = False
    TabOrder = 3
    object uo_Label4: TLabel
      Left = 11
      Top = 10
      Width = 68
      Height = 13
      Caption = 'Update &mode:'
      FocusControl = uo_cbxUpdateMode
    end
    object uo_Label5: TLabel
      Left = 11
      Top = 37
      Width = 66
      Height = 13
      Caption = 'Update &table:'
      FocusControl = uo_edtUpdateTableName
    end
    object uo_edtUpdateTableName: TEdit
      Left = 107
      Top = 34
      Width = 125
      Height = 21
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 1
      OnChange = uo_Change
    end
    object uo_cbxUpdateMode: TComboBox
      Left = 107
      Top = 7
      Width = 125
      Height = 21
      Style = csDropDownList
      Ctl3D = True
      ItemHeight = 13
      ParentCtl3D = False
      TabOrder = 0
      OnClick = uo_Change
      Items.Strings = (
        'upWhereAll'
        'upWhereChanged'
        'upWhereKeyOnly')
    end
    object uo_cbUpdateChangedFields: TCheckBox
      Left = 11
      Top = 65
      Width = 163
      Height = 17
      Caption = '&Update changed fields'
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 2
      OnClick = uo_Change
    end
    object uo_cbCountUpdatedRecords: TCheckBox
      Left = 11
      Top = 90
      Width = 163
      Height = 17
      Caption = '&Check updated records count'
      TabOrder = 3
      OnClick = uo_Change
    end
    object uo_cbCacheUpdateCommands: TCheckBox
      Left = 11
      Top = 115
      Width = 163
      Height = 17
      Caption = 'Cac&he update commands'
      TabOrder = 4
      OnClick = uo_Change
    end
    object uo_cbUseProviderFlags: TCheckBox
      Left = 11
      Top = 140
      Width = 163
      Height = 17
      Caption = 'Use &provider flags'
      TabOrder = 5
      OnClick = uo_Change
    end
  end
  object uo_GroupBox2: TADGUIxFormsPanel
    Left = 264
    Top = 156
    Width = 244
    Height = 93
    Caption = ' Locking '
    Ctl3D = True
    ParentColor = True
    ParentCtl3D = False
    TabOrder = 0
    object uo_Label1: TLabel
      Left = 11
      Top = 11
      Width = 54
      Height = 13
      Caption = '&Lock mode:'
      FocusControl = uo_cbxLockMode
    end
    object uo_Label2: TLabel
      Left = 12
      Top = 36
      Width = 52
      Height = 13
      Caption = 'Lock &point:'
      FocusControl = uo_cbxLockPoint
    end
    object uo_cbxLockMode: TComboBox
      Left = 107
      Top = 7
      Width = 125
      Height = 21
      Style = csDropDownList
      Ctl3D = True
      ItemHeight = 13
      ParentCtl3D = False
      TabOrder = 0
      OnClick = uo_Change
      Items.Strings = (
        'lmPessimistic'
        'lmOptimistic'
        'lmRely')
    end
    object uo_cbxLockPoint: TComboBox
      Left = 107
      Top = 32
      Width = 125
      Height = 21
      Style = csDropDownList
      Ctl3D = True
      ItemHeight = 13
      ParentCtl3D = False
      TabOrder = 1
      OnClick = uo_Change
      Items.Strings = (
        'lpImmediate'
        'lpDeferred')
    end
    object uo_cbLockWait: TCheckBox
      Left = 11
      Top = 66
      Width = 97
      Height = 16
      Caption = '&Wait for lock'
      TabOrder = 2
      OnClick = uo_Change
    end
  end
  object uo_GroupBox4: TADGUIxFormsPanel
    Left = 264
    Top = 273
    Width = 179
    Height = 32
    Caption = ' Refreshing  '
    Ctl3D = True
    ParentColor = True
    ParentCtl3D = False
    TabOrder = 1
    object Label1: TLabel
      Left = 11
      Top = 11
      Width = 71
      Height = 13
      Caption = '&Refresh mode:'
      FocusControl = uo_cbRefreshMode
    end
    object uo_cbRefreshMode: TComboBox
      Left = 107
      Top = 7
      Width = 125
      Height = 21
      Style = csDropDownList
      Ctl3D = True
      ItemHeight = 13
      ParentCtl3D = False
      TabOrder = 0
      OnClick = uo_Change
      Items.Strings = (
        'rmManual'
        'rmOnDemand'
        'rmAll')
    end
  end
  object uo_PopupMenu1: TPopupMenu
    AutoPopup = False
    Left = 152
    Top = 24
    object uo_ReadOnly1: TMenuItem
      Caption = 'Read only'
      OnClick = uo_ReadOnly1Click
    end
    object uo_ReadWrite1: TMenuItem
      Caption = 'Read, write'
      OnClick = uo_ReadWrite1Click
    end
    object uo_N1: TMenuItem
      Caption = '-'
    end
    object uo_Fastupdates1: TMenuItem
      Caption = 'Fast updates'
      OnClick = uo_Fastupdates1Click
    end
    object uo_Standardupdates1: TMenuItem
      Caption = 'Standard updates'
      OnClick = uo_Standardupdates1Click
    end
  end
end
