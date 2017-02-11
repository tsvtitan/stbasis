object frmADGUIxFormsFetchOptions: TfrmADGUIxFormsFetchOptions
  Left = 0
  Top = 0
  Width = 303
  Height = 239
  Hint = 'Fetch Options'
  Color = clWindow
  Ctl3D = True
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  ParentColor = False
  ParentCtl3D = False
  ParentFont = False
  TabOrder = 0
  object fo_GroupBox1: TADGUIxFormsPanel
    Left = 8
    Top = 5
    Width = 284
    Height = 136
    Caption = ' General Fetching'
    Ctl3D = True
    ParentColor = True
    ParentCtl3D = False
    TabOrder = 0
    object fo_Label1: TLabel
      Left = 11
      Top = 10
      Width = 60
      Height = 13
      Caption = '&Fetch mode:'
      FocusControl = fo_cbxMode
    end
    object fo_Label3: TLabel
      Left = 11
      Top = 37
      Width = 61
      Height = 13
      Caption = '&Rowset size:'
      FocusControl = fo_edtRowSetSize
    end
    object fo_Label2: TLabel
      Left = 11
      Top = 56
      Width = 65
      Height = 26
      Caption = 'Maximum record &count:'
      FocusControl = fo_edtRecsMax
      WordWrap = True
    end
    object fo_Label4: TLabel
      Left = 11
      Top = 104
      Width = 60
      Height = 26
      Caption = '&Record '#13#10'count mode:'
      FocusControl = fo_cbxRecordCountMode
    end
    object fo_edtRecsMax: TEdit
      Left = 107
      Top = 59
      Width = 125
      Height = 19
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 2
      OnChange = fo_Change
    end
    object fo_edtRowSetSize: TEdit
      Left = 107
      Top = 34
      Width = 125
      Height = 19
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 1
      OnChange = fo_Change
    end
    object fo_cbxMode: TComboBox
      Left = 107
      Top = 7
      Width = 125
      Height = 21
      Style = csDropDownList
      Ctl3D = True
      ItemHeight = 13
      ParentCtl3D = False
      TabOrder = 0
      OnChange = fo_Change
      Items.Strings = (
        'fmManual'
        'fmOnDemand'
        'fmAll'
        'fmExactRecsMax')
    end
    object fo_cbAutoClose: TCheckBox
      Left = 11
      Top = 86
      Width = 222
      Height = 15
      Caption = 'C&lose command after all data is fetched'
      TabOrder = 3
      OnClick = fo_Change
    end
    object fo_cbxRecordCountMode: TComboBox
      Left = 107
      Top = 107
      Width = 125
      Height = 21
      Style = csDropDownList
      Ctl3D = True
      ItemHeight = 13
      ParentCtl3D = False
      TabOrder = 4
      OnChange = fo_Change
      Items.Strings = (
        'fmManual'
        'fmOnDemand'
        'fmAll'
        'fmExactRecsMax')
    end
  end
  object fo_gbItems: TADGUIxFormsPanel
    Left = 8
    Top = 153
    Width = 137
    Height = 84
    Caption = ' Items To Fetch'
    Ctl3D = True
    ParentColor = True
    ParentCtl3D = False
    TabOrder = 1
    object fo_cbIBlobs: TCheckBox
      Left = 11
      Top = 7
      Width = 116
      Height = 17
      Caption = '&Blobs'
      TabOrder = 0
      OnClick = fo_Change
    end
    object fo_cbIDetails: TCheckBox
      Left = 11
      Top = 32
      Width = 116
      Height = 17
      Caption = 'De&tails'
      TabOrder = 1
      OnClick = fo_Change
    end
    object fo_cbIMeta: TCheckBox
      Left = 11
      Top = 57
      Width = 116
      Height = 17
      Caption = 'Meta&data'
      TabOrder = 2
      OnClick = fo_Change
    end
  end
  object fo_gbCache: TADGUIxFormsPanel
    Left = 153
    Top = 153
    Width = 139
    Height = 84
    Caption = ' Items To Cache'
    Ctl3D = True
    ParentColor = True
    ParentCtl3D = False
    TabOrder = 2
    object fo_cbCBlobs: TCheckBox
      Left = 11
      Top = 7
      Width = 115
      Height = 17
      Caption = '&Blobs'
      TabOrder = 0
      OnClick = fo_Change
    end
    object fo_cbCDetails: TCheckBox
      Left = 11
      Top = 32
      Width = 115
      Height = 17
      Caption = '&Details'
      TabOrder = 1
      OnClick = fo_Change
    end
    object fo_cbCMeta: TCheckBox
      Left = 11
      Top = 57
      Width = 115
      Height = 17
      Caption = '&Metadata'
      TabOrder = 2
      OnClick = fo_Change
    end
  end
end
