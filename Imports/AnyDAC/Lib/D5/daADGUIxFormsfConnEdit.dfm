object frmADGUIxFormsConnEdit: TfrmADGUIxFormsConnEdit
  Left = 363
  Top = 119
  Width = 526
  Height = 520
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'frmADGUIxFormsConnEdit'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object pnlButtons: TADGUIxFormsPanel
    Left = 0
    Top = 450
    Width = 518
    Height = 36
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object btnDefaults: TButton
      Left = 10
      Top = 0
      Width = 75
      Height = 25
      Caption = 'Set &Defaults'
      TabOrder = 0
      OnClick = btnDefaultsClick
    end
    object btnTest: TButton
      Left = 91
      Top = 0
      Width = 75
      Height = 25
      Caption = '&Test'
      TabOrder = 1
      OnClick = btnTestClick
    end
    object btnOk: TButton
      Left = 350
      Top = 0
      Width = 75
      Height = 25
      Caption = '&OK'
      Default = True
      ModalResult = 1
      TabOrder = 2
    end
    object btnCancel: TButton
      Left = 432
      Top = 0
      Width = 75
      Height = 25
      Cancel = True
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 3
    end
    object btnWizard: TButton
      Left = 172
      Top = 0
      Width = 75
      Height = 25
      Caption = '&Wizard'
      TabOrder = 4
      OnClick = btnWizardClick
    end
  end
  object pnlMain: TADGUIxFormsPanel
    Left = 0
    Top = 0
    Width = 518
    Height = 450
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 11
    ParentColor = True
    TabOrder = 1
    object pnlGray: TADGUIxFormsPanel
      Left = 11
      Top = 11
      Width = 496
      Height = 428
      Align = alClient
      BevelOuter = bvNone
      BorderWidth = 1
      Color = clBtnShadow
      TabOrder = 0
      object Panel1: TADGUIxFormsPanel
        Left = 1
        Top = 1
        Width = 494
        Height = 426
        Align = alClient
        BevelOuter = bvNone
        Color = clWindow
        TabOrder = 0
        object pcMain: TADGUIxFormsPageControl
          Left = 0
          Top = 0
          Width = 494
          Height = 426
          ActivePage = tsConnection
          Align = alClient
          Style = tsFlatButtons
          TabOrder = 0
          object tsConnection: TTabSheet
            Caption = 'Definition'
            object sgParams: TStringGrid
              Left = 0
              Top = 79
              Width = 486
              Height = 275
              Align = alClient
              BorderStyle = bsNone
              ColCount = 3
              Ctl3D = False
              FixedCols = 0
              RowCount = 4
              Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goColSizing]
              ParentCtl3D = False
              ScrollBars = ssVertical
              TabOrder = 3
              OnDrawCell = sgParamsDrawCell
              OnKeyDown = sgParamsKeyDown
              OnMouseUp = sgParamsMouseUp
              OnSelectCell = sgParamsSelectCell
              OnTopLeftChanged = sgParamsTopLeftChanged
              ColWidths = (
                200
                206
                58)
            end
            object cbParams: TComboBox
              Left = 232
              Top = 168
              Width = 145
              Height = 21
              Ctl3D = True
              ItemHeight = 13
              ParentCtl3D = False
              TabOrder = 1
              Visible = False
              OnDblClick = cbParamsDblClick
              OnExit = EditorExit
              OnKeyDown = EditorKeyDown
            end
            object edtParams: TEdit
              Left = 232
              Top = 200
              Width = 121
              Height = 21
              Ctl3D = True
              ParentCtl3D = False
              TabOrder = 2
              Visible = False
              OnExit = EditorExit
              OnKeyDown = EditorKeyDown
            end
            object pnlTitle: TADGUIxFormsPanel
              Left = 0
              Top = 0
              Width = 486
              Height = 70
              Align = alTop
              BevelOuter = bvNone
              Color = clWindow
              TabOrder = 0
              object Label1: TLabel
                Left = 7
                Top = 14
                Width = 45
                Height = 13
                Caption = '&Driver ID:'
                FocusControl = cbServerID
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object Label2: TLabel
                Left = 7
                Top = 41
                Width = 54
                Height = 13
                Caption = '&Alias name:'
                FocusControl = cbConnectionDefName
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object cbServerID: TComboBox
                Left = 67
                Top = 11
                Width = 134
                Height = 21
                Ctl3D = True
                ItemHeight = 13
                ParentCtl3D = False
                TabOrder = 0
                OnClick = cbServerIDClick
              end
              object cbConnectionDefName: TComboBox
                Left = 67
                Top = 38
                Width = 134
                Height = 21
                Ctl3D = True
                ItemHeight = 13
                ParentCtl3D = False
                TabOrder = 1
                OnClick = cbConnectionDefNameClick
              end
              object Panel2: TADGUIxFormsPanel
                Left = 0
                Top = 69
                Width = 486
                Height = 1
                Align = alBottom
                BevelOuter = bvNone
                Color = clBtnShadow
                TabOrder = 2
              end
            end
            object Panel3: TADGUIxFormsPanel
              Left = 0
              Top = 70
              Width = 486
              Height = 9
              Align = alTop
              BevelOuter = bvNone
              ParentColor = True
              TabOrder = 4
            end
          end
          object tsAdvanced: TTabSheet
            Caption = 'Advanced'
            ImageIndex = 1
            object ptreeAdvanced: TADGUIxFormsPanelTree
              Left = 0
              Top = 0
              Width = 486
              Height = 354
              BorderStyle = bsNone
              HorzScrollBar.Smooth = True
              HorzScrollBar.Style = ssFlat
              HorzScrollBar.Tracking = True
              VertScrollBar.Smooth = True
              VertScrollBar.Style = ssFlat
              VertScrollBar.Tracking = True
              Align = alClient
              Color = clWindow
              Ctl3D = False
              ParentColor = False
              TabOrder = 0
              object frmFormatOptions: TfrmADGUIxFormsFormatOptions
                Left = 1
                Top = 1
                Width = 504
                Height = 368
                Hint = 'Format Options'
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
                TabStop = True
                OnModified = frmOptionsModified
              end
              object frmFetchOptions: TfrmADGUIxFormsFetchOptions
                Left = 8
                Top = 136
                Width = 425
                Height = 185
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
                TabOrder = 1
                OnModified = frmOptionsModified
              end
              object frmUpdateOptions: TfrmADGUIxFormsUpdateOptions
                Left = 32
                Top = 88
                Width = 441
                Height = 249
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
                TabOrder = 2
                OnModified = frmOptionsModified
              end
              object frmResourceOptions: TfrmADGUIxFormsResourceOptions
                Left = 80
                Top = 136
                Width = 313
                Height = 193
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
                TabOrder = 3
                OnModified = frmOptionsModified
              end
            end
          end
        end
      end
    end
  end
end
