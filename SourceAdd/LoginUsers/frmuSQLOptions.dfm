inherited frmSQLOptions: TfrmSQLOptions
  Left = 370
  Top = 364
  Caption = 'SQL Options'
  ClientHeight = 328
  ClientWidth = 309
  OldCreateOrder = True
  Position = poOwnerFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object btnApply: TButton
    Left = 231
    Top = 295
    Width = 75
    Height = 25
    Caption = '&Apply'
    Enabled = False
    TabOrder = 0
    OnClick = btnApplyClick
  end
  object Button1: TButton
    Left = 69
    Top = 295
    Width = 75
    Height = 25
    Caption = '&OK'
    TabOrder = 1
    OnClick = Button1Click
  end
  object pgControl: TPageControl
    Left = 0
    Top = 0
    Width = 309
    Height = 288
    ActivePage = TabSheet2
    Align = alTop
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = 'Options'
      object sgOptions: TStringGrid
        Left = 3
        Top = 6
        Width = 294
        Height = 203
        Color = clSilver
        ColCount = 2
        DefaultColWidth = 90
        DefaultRowHeight = 21
        FixedCols = 0
        RowCount = 9
        FixedRows = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goColSizing]
        ScrollBars = ssNone
        TabOrder = 0
        OnDblClick = sgOptionsDblClick
        OnDrawCell = sgOptionsDrawCell
        OnSelectCell = sgOptionsSelectCell
        ColWidths = (
          174
          113)
      end
      object pnlOptionName: TPanel
        Left = 6
        Top = 5
        Width = 172
        Height = 25
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvLowered
        TabOrder = 1
      end
      object cbOptions: TComboBox
        Left = 179
        Top = 7
        Width = 116
        Height = 21
        TabStop = False
        ItemHeight = 0
        ParentShowHint = False
        ShowHint = False
        TabOrder = 2
        OnChange = cbOptionsChange
        OnDblClick = cbOptionsDblClick
        OnExit = cbOptionsExit
        OnKeyDown = cbOptionsKeyDown
      end
      object cbClearInput: TCheckBox
        Left = 9
        Top = 225
        Width = 188
        Height = 17
        Caption = '&Clear input window on success'
        TabOrder = 3
        OnClick = cbOptionsChange
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Advanced'
      ImageIndex = 1
      object GroupBox1: TGroupBox
        Left = 5
        Top = 4
        Width = 292
        Height = 166
        Caption = 'SQL Events'
        TabOrder = 0
        object Label1: TLabel
          Left = 10
          Top = 79
          Width = 39
          Height = 13
          Caption = 'NOTE:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object cbUpdateConnect: TCheckBox
          Left = 7
          Top = 21
          Width = 179
          Height = 17
          Caption = 'Update IBConsole on C&onnect'
          TabOrder = 0
          OnClick = cbOptionsChange
        end
        object cbUpdateCreate: TCheckBox
          Left = 7
          Top = 45
          Width = 171
          Height = 17
          Caption = 'Update IBConsole on C&reate'
          TabOrder = 1
          OnClick = cbOptionsChange
        end
        object Memo1: TMemo
          Left = 20
          Top = 93
          Width = 259
          Height = 46
          BorderStyle = bsNone
          Lines.Strings = (
            'Enabling either option may result in an additional '
            'connection to the server.')
          ParentColor = True
          TabOrder = 2
        end
      end
      object rgTransactions: TRadioGroup
        Left = 6
        Top = 172
        Width = 292
        Height = 82
        Caption = 'Transactions'
        ItemIndex = 0
        Items.Strings = (
          '&Commit on exit'
          'Ro&llback on exit')
        TabOrder = 1
        OnClick = cbOptionsChange
      end
    end
  end
  object Button2: TButton
    Left = 150
    Top = 295
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
    OnClick = Button2Click
  end
end
