inherited frmADSettingsDesc: TfrmADSettingsDesc
  Width = 470
  Height = 294
  object cbMoniInDelphiIDE: TCheckBox
    Left = 11
    Top = 35
    Width = 230
    Height = 17
    Caption = 'Produce monitoring output in &Delphi IDE'
    TabOrder = 0
    OnClick = CtrlChange
  end
  object GroupBox1: TGroupBox
    Left = 11
    Top = 59
    Width = 441
    Height = 113
    Caption = ' Monitor event kinds '
    Ctl3D = True
    ParentCtl3D = False
    TabOrder = 1
    object cbMoniLiveCycle: TCheckBox
      Left = 16
      Top = 16
      Width = 73
      Height = 17
      Caption = '&Live cycle'
      TabOrder = 0
      OnClick = CtrlChange
    end
    object cbMoniError: TCheckBox
      Left = 16
      Top = 40
      Width = 57
      Height = 17
      Caption = '&Error'
      TabOrder = 1
      OnClick = CtrlChange
    end
    object cbMoniConnection: TCheckBox
      Left = 104
      Top = 16
      Width = 97
      Height = 17
      Caption = '&Connection'
      TabOrder = 2
      OnClick = CtrlChange
    end
    object cbMoniTransaction: TCheckBox
      Left = 104
      Top = 40
      Width = 97
      Height = 17
      Caption = '&Transaction'
      TabOrder = 3
      OnClick = CtrlChange
    end
    object cbMoniService: TCheckBox
      Left = 104
      Top = 64
      Width = 121
      Height = 17
      Caption = 'Connection &service'
      TabOrder = 4
      OnClick = CtrlChange
    end
    object cbMoniPrepare: TCheckBox
      Left = 232
      Top = 16
      Width = 97
      Height = 17
      Caption = 'Cmd &prepare'
      TabOrder = 5
      OnClick = CtrlChange
    end
    object cbMoniExecute: TCheckBox
      Left = 232
      Top = 40
      Width = 97
      Height = 17
      Caption = 'Cmd e&xecute'
      TabOrder = 6
      OnClick = CtrlChange
    end
    object cbMoniDataIn: TCheckBox
      Left = 232
      Top = 64
      Width = 97
      Height = 17
      Caption = 'Cmd data &input'
      TabOrder = 7
      OnClick = CtrlChange
    end
    object cbMoniDataOut: TCheckBox
      Left = 232
      Top = 88
      Width = 97
      Height = 17
      Caption = 'Cmd data &output'
      TabOrder = 8
      OnClick = CtrlChange
    end
    object cbMoniUpdate: TCheckBox
      Left = 344
      Top = 16
      Width = 81
      Height = 17
      Caption = '&Update'
      TabOrder = 9
      OnClick = CtrlChange
    end
    object cbMoniVendor: TCheckBox
      Left = 344
      Top = 40
      Width = 81
      Height = 17
      Caption = '&Vendor calls'
      TabOrder = 10
      OnClick = CtrlChange
    end
  end
  object GroupBox2: TGroupBox
    Left = 11
    Top = 179
    Width = 193
    Height = 105
    Caption = ' &Remote monitor '
    Ctl3D = True
    ParentCtl3D = False
    TabOrder = 2
    object Label1: TLabel
      Left = 16
      Top = 24
      Width = 22
      Height = 13
      Caption = 'Host'
      FocusControl = edtMoniHost
    end
    object Label2: TLabel
      Left = 16
      Top = 48
      Width = 19
      Height = 13
      Caption = 'Port'
      FocusControl = edtMoniPort
    end
    object Label3: TLabel
      Left = 16
      Top = 72
      Width = 38
      Height = 13
      Caption = 'Timeout'
      FocusControl = edtMoniTimeout
    end
    object edtMoniHost: TEdit
      Left = 60
      Top = 21
      Width = 121
      Height = 19
      TabOrder = 0
      OnChange = CtrlChange
    end
    object edtMoniPort: TEdit
      Left = 60
      Top = 45
      Width = 121
      Height = 19
      TabOrder = 1
      OnChange = CtrlChange
    end
    object edtMoniTimeout: TEdit
      Left = 60
      Top = 69
      Width = 121
      Height = 19
      TabOrder = 2
      OnChange = CtrlChange
    end
  end
  object GroupBox3: TGroupBox
    Left = 215
    Top = 179
    Width = 237
    Height = 105
    Caption = ' &Flat file monitor '
    Ctl3D = True
    ParentCtl3D = False
    TabOrder = 3
    object Label4: TLabel
      Left = 16
      Top = 24
      Width = 45
      Height = 13
      Caption = 'File name'
    end
    object edtMoniFileName: TEdit
      Left = 67
      Top = 22
      Width = 158
      Height = 21
      TabOrder = 0
      OnChange = CtrlChange
    end
    object cbMoniAppend: TCheckBox
      Left = 16
      Top = 48
      Width = 97
      Height = 17
      Caption = 'Append'
      TabOrder = 1
      OnClick = CtrlChange
    end
  end
  object pnlInstructionName: TADGUIxFormsPanel
    Left = 0
    Top = 0
    Width = 470
    Height = 26
    Align = alTop
    Alignment = taLeftJustify
    BevelOuter = bvNone
    Color = $F0CAA6
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    object Label5: TLabel
      Left = 5
      Top = 5
      Width = 87
      Height = 13
      Caption = 'Monitor control'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Panel7: TADGUIxFormsPanel
      Left = 0
      Top = 25
      Width = 470
      Height = 1
      Align = alBottom
      Alignment = taLeftJustify
      BevelOuter = bvNone
      BorderWidth = 1
      Color = clBtnShadow
      TabOrder = 0
    end
  end
end
