object frmADGUIxFormsResourceOptions: TfrmADGUIxFormsResourceOptions
  Left = 0
  Top = 0
  Width = 417
  Height = 254
  Hint = 'Resource Options'
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
  object ro_gbCmdTextProcess: TADGUIxFormsPanel
    Left = 0
    Top = 83
    Width = 281
    Height = 158
    Caption = ' Command Text Processing '
    Ctl3D = True
    ParentColor = True
    ParentCtl3D = False
    TabOrder = 0
    object ro_Label4: TLabel
      Left = 11
      Top = 131
      Width = 96
      Height = 13
      Caption = 'Default ParamT&ype:'
    end
    object ro_cbCreateParams: TCheckBox
      Left = 11
      Top = 7
      Width = 107
      Height = 17
      Caption = 'Create &params'
      TabOrder = 0
      OnClick = ro_Change
    end
    object ro_cbCreateMacros: TCheckBox
      Left = 11
      Top = 32
      Width = 107
      Height = 17
      Caption = 'Create &macros'
      TabOrder = 1
      OnClick = ro_Change
    end
    object ro_cbExpandParams: TCheckBox
      Left = 11
      Top = 57
      Width = 107
      Height = 17
      Caption = 'Expand &params'
      TabOrder = 2
      OnClick = ro_Change
    end
    object ro_cbExpandMacros: TCheckBox
      Left = 11
      Top = 82
      Width = 107
      Height = 17
      Caption = 'Expand &macros'
      TabOrder = 3
      OnClick = ro_Change
    end
    object ro_cbExpandEscapes: TCheckBox
      Left = 11
      Top = 107
      Width = 107
      Height = 17
      Caption = 'Expand &escapes'
      TabOrder = 4
      OnClick = ro_Change
    end
    object ro_cbxDefaultParamType: TComboBox
      Left = 107
      Top = 127
      Width = 125
      Height = 21
      Style = csDropDownList
      Ctl3D = True
      ItemHeight = 13
      ParentCtl3D = False
      TabOrder = 5
      OnChange = ro_Change
      Items.Strings = (
        'ptUnknown'
        'ptInput'
        'ptOutput'
        'ptInputOutput'
        'ptResult')
    end
  end
  object ro_gbCursors: TADGUIxFormsPanel
    Left = 145
    Top = 83
    Width = 244
    Height = 61
    Caption = ' Cursors Usage '
    Ctl3D = True
    ParentColor = True
    ParentCtl3D = False
    TabOrder = 2
    object ro_Label1: TLabel
      Left = 11
      Top = 32
      Width = 62
      Height = 13
      Caption = 'Max &cursors:'
    end
    object ro_cbDisconnectable: TCheckBox
      Left = 11
      Top = 7
      Width = 157
      Height = 17
      Caption = '&Disconnectable'
      TabOrder = 0
      OnClick = ro_Change
    end
    object ro_edtMaxCursors: TEdit
      Left = 107
      Top = 31
      Width = 125
      Height = 21
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 1
      Text = '-1'
      OnChange = ro_Change
    end
  end
  object ro_gbAsync: TADGUIxFormsPanel
    Left = 0
    Top = 0
    Width = 284
    Height = 61
    Caption = ' Async Command Processing '
    Ctl3D = True
    ParentColor = True
    ParentCtl3D = False
    TabOrder = 1
    object ro_Label2: TLabel
      Left = 11
      Top = 11
      Width = 30
      Height = 13
      Caption = '&Mode:'
    end
    object ro_Label3: TLabel
      Left = 11
      Top = 36
      Width = 42
      Height = 13
      Caption = '&Timeout:'
    end
    object ro_cbxAsyncCmdMode: TComboBox
      Left = 107
      Top = 7
      Width = 125
      Height = 21
      Style = csDropDownList
      Ctl3D = True
      ItemHeight = 13
      ParentCtl3D = False
      TabOrder = 0
      OnChange = ro_Change
      Items.Strings = (
        'amBlocking'
        'amNonBlocking'
        'amCancelDialog'
        'amAsync')
    end
    object ro_edtAsyncCmdTimeout: TEdit
      Left = 107
      Top = 34
      Width = 125
      Height = 21
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 1
      Text = '-1'
      OnChange = ro_Change
    end
  end
end
