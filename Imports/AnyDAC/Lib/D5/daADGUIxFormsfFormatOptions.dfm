object frmADGUIxFormsFormatOptions: TfrmADGUIxFormsFormatOptions
  Left = 0
  Top = 0
  Width = 577
  Height = 361
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
  object mo_GroupBox1: TADGUIxFormsPanel
    Left = 0
    Top = 0
    Width = 561
    Height = 194
    Caption = ' Data Mapping Rules '
    Ctl3D = True
    ParentColor = True
    ParentCtl3D = False
    TabOrder = 2
    object mo_Panel3: TADGUIxFormsPanel
      Left = 1
      Top = 26
      Width = 559
      Height = 167
      Align = alClient
      BevelOuter = bvNone
      BorderWidth = 11
      ParentColor = True
      TabOrder = 0
      object mo_Panel11: TADGUIxFormsPanel
        Left = 11
        Top = 11
        Width = 543
        Height = 115
        BevelOuter = bvNone
        BorderWidth = 1
        Color = clGray
        TabOrder = 0
        object mo_sgMapRules: TStringGrid
          Left = 1
          Top = 1
          Width = 541
          Height = 113
          Align = alClient
          BorderStyle = bsNone
          ColCount = 8
          Ctl3D = False
          DefaultRowHeight = 19
          FixedCols = 0
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing]
          ParentCtl3D = False
          TabOrder = 0
          OnEnter = mo_sgMapRulesEnter
          OnKeyDown = mo_sgMapRulesKeyDown
          OnSelectCell = mo_sgMapRulesSelectCell
          OnTopLeftChanged = mo_sgMapRulesTopLeftChanged
        end
      end
      object mo_cbxDataType: TComboBox
        Left = 76
        Top = 30
        Width = 66
        Height = 21
        Style = csDropDownList
        Ctl3D = True
        ItemHeight = 13
        ParentCtl3D = False
        TabOrder = 1
        Visible = False
        OnExit = mo_cbxDataTypeExit
        OnKeyDown = mo_cbxDataTypeKeyDown
        Items.Strings = (
          'dtUnknown'
          'dtBoolean'
          'dtSByte'
          'dtInt16'
          'dtInt32'
          'dtInt64'
          'dtByte'
          'dtUInt16'
          'dtUInt32'
          'dtUInt64'
          'dtDouble'
          'dtCurrency'
          'dtBCD'
          'dtFmtBCD'
          'dtDateTime'
          'dtTime'
          'dtDate'
          'dtDateTimeStamp'
          'dtAnsiString'
          'dtWideString'
          'dtByteString'
          'dtBlob'
          'dtMemo'
          'dtHBlob'
          'dtHMemo'
          'dtRowSetRef'
          'dtRowRef'
          'dtArrayRef'
          'dtParentRowRef'
          'dtObject')
      end
      object mo_Panel2: TADGUIxFormsPanel
        Left = 11
        Top = 126
        Width = 537
        Height = 30
        Align = alBottom
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 2
        object Panel1: TADGUIxFormsPanel
          Left = 0
          Top = 8
          Width = 75
          Height = 22
          BevelOuter = bvNone
          BorderWidth = 1
          Color = clBtnShadow
          Ctl3D = True
          ParentCtl3D = False
          TabOrder = 0
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
            object mo_btnAddRule: TSpeedButton
              Left = 0
              Top = 0
              Width = 73
              Height = 20
              Anchors = [akLeft, akTop, akRight, akBottom]
              Caption = '&Add Rule'
              Flat = True
              OnClick = mo_btnAddRuleClick
            end
          end
        end
        object Panel3: TADGUIxFormsPanel
          Left = 82
          Top = 8
          Width = 75
          Height = 22
          BevelOuter = bvNone
          BorderWidth = 1
          Color = clBtnShadow
          Ctl3D = True
          ParentCtl3D = False
          TabOrder = 1
          object Panel4: TADGUIxFormsPanel
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
            object mo_btnRemRule: TSpeedButton
              Left = 0
              Top = 0
              Width = 73
              Height = 20
              Anchors = [akLeft, akTop, akRight, akBottom]
              Caption = '&Delete Rule'
              Flat = True
              OnClick = mo_btnRemRuleClick
            end
          end
        end
      end
    end
    object mo_Panel5: TADGUIxFormsPanel
      Left = 1
      Top = 1
      Width = 559
      Height = 25
      Align = alTop
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 1
      object mo_cbOwnMapRules: TCheckBox
        Left = 11
        Top = 7
        Width = 199
        Height = 17
        Caption = 'I&gnore inherited rules'
        TabOrder = 0
        OnClick = mo_cbOwnMapRulesClick
      end
    end
  end
  object mo_gb1: TADGUIxFormsPanel
    Left = 253
    Top = 198
    Width = 244
    Height = 66
    Caption = ' Handling BCD Type '
    Ctl3D = True
    ParentColor = True
    ParentCtl3D = False
    TabOrder = 0
    object mo_Label2: TLabel
      Left = 11
      Top = 35
      Width = 93
      Height = 13
      Caption = 'Maximum &precision:'
      FocusControl = mo_edtMaxBcdPrecision
    end
    object mo_Label3: TLabel
      Left = 11
      Top = 10
      Width = 75
      Height = 13
      Caption = 'Maximum &scale:'
      FocusControl = mo_edtMaxBcdScale
    end
    object mo_edtMaxBcdPrecision: TEdit
      Left = 107
      Top = 32
      Width = 125
      Height = 21
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 1
      OnChange = mo_Change
    end
    object mo_edtMaxBcdScale: TEdit
      Left = 107
      Top = 7
      Width = 125
      Height = 21
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 0
      OnChange = mo_Change
    end
  end
  object mo_gb2: TADGUIxFormsPanel
    Left = 0
    Top = 199
    Width = 244
    Height = 139
    Caption = ' Handling String Type '
    Ctl3D = True
    ParentColor = True
    ParentCtl3D = False
    TabOrder = 1
    object mo_Label1: TLabel
      Left = 11
      Top = 10
      Width = 69
      Height = 13
      Caption = 'Ma&ximum size:'
      FocusControl = mo_edtMaxStringSize
    end
    object mo_Label10: TLabel
      Left = 11
      Top = 37
      Width = 76
      Height = 13
      Caption = '&Inline data size:'
      FocusControl = mo_edtInlineDataSize
    end
    object mo_cbStrsEmpty2Null: TCheckBox
      Left = 11
      Top = 63
      Width = 167
      Height = 17
      Caption = '&Convert empty strings to Null'
      TabOrder = 2
      OnClick = mo_Change
    end
    object mo_cbStrsTrim: TCheckBox
      Left = 11
      Top = 88
      Width = 167
      Height = 17
      Caption = '&Trim strings'
      TabOrder = 3
      OnClick = mo_Change
    end
    object mo_edtMaxStringSize: TEdit
      Left = 107
      Top = 7
      Width = 125
      Height = 21
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 0
      OnChange = mo_Change
    end
    object mo_edtInlineDataSize: TEdit
      Left = 107
      Top = 34
      Width = 125
      Height = 21
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 1
      OnChange = mo_Change
    end
    object mo_cbStrsDivLen2: TCheckBox
      Left = 11
      Top = 113
      Width = 167
      Height = 17
      Caption = 'Di&vide length by 2'
      TabOrder = 4
      OnClick = mo_Change
    end
  end
  object mo_Panel6: TADGUIxFormsPanel
    Left = 250
    Top = 270
    Width = 244
    Height = 40
    Caption = ' Paramaters Default Type '
    Ctl3D = True
    ParentColor = True
    ParentCtl3D = False
    TabOrder = 3
    object mo_Label6: TLabel
      Left = 11
      Top = 10
      Width = 52
      Height = 13
      Caption = 'Data t&ype:'
      FocusControl = mo_cbDefaultParamDataType
    end
    object mo_cbDefaultParamDataType: TComboBox
      Left = 107
      Top = 7
      Width = 125
      Height = 21
      Style = csDropDownList
      Ctl3D = True
      ItemHeight = 13
      ParentCtl3D = False
      TabOrder = 0
      OnChange = mo_Change
      Items.Strings = (
        'ftUnknown'
        'ftString'
        'ftSmallint'
        'ftInteger'
        'ftWord'
        'ftBoolean'
        'ftFloat'
        'ftCurrency'
        'ftBCD'
        'ftDate'
        'ftTime'
        'ftDateTime'
        'ftBytes'
        'ftVarBytes'
        'ftAutoInc'
        'ftBlob'
        'ftMemo'
        'ftGraphic'
        'ftFmtMemo'
        'ftParadoxOle'
        'ftDBaseOle'
        'ftTypedBinary'
        'ftCursor'
        'ftFixedChar'
        'ftWideString'
        'ftLargeint'
        'ftADT'
        'ftArray'
        'ftReference'
        'ftDataSet'
        'ftOraBlob'
        'ftOraClob'
        'ftVariant'
        'ftInterface'
        'ftIDispatch'
        'ftGuid'
        'ftTimeStamp'
        'ftFMTBcd'
        'ftFixedWideChar'
        'ftWideMemo'
        'ftOraTimeStamp'
        'ftOraInterval')
    end
  end
end
