object frmADQASearch: TfrmADQASearch
  Left = 494
  Top = 338
  BorderStyle = bsDialog
  Caption = 'Find'
  ClientHeight = 111
  ClientWidth = 278
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMain: TADGUIxFormsPanel
    Left = 0
    Top = 0
    Width = 278
    Height = 77
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 4
    TabOrder = 0
    object pnlGray: TADGUIxFormsPanel
      Left = 4
      Top = 4
      Width = 270
      Height = 69
      Align = alClient
      BevelOuter = bvNone
      BorderWidth = 1
      Color = clBtnShadow
      TabOrder = 0
      object pnlOptions: TADGUIxFormsPanel
        Left = 1
        Top = 24
        Width = 268
        Height = 44
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 3
        Color = clWindow
        TabOrder = 0
        object Label3: TLabel
          Left = 9
          Top = 14
          Width = 55
          Height = 13
          Alignment = taRightJustify
          Caption = '&Test Name:'
          FocusControl = cbTestName
        end
        object cbTestName: TComboBox
          Left = 68
          Top = 11
          Width = 189
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          ItemHeight = 13
          TabOrder = 0
        end
      end
      object pnlTitle: TADGUIxFormsPanel
        Left = 1
        Top = 1
        Width = 268
        Height = 23
        Align = alTop
        Alignment = taLeftJustify
        BevelOuter = bvNone
        Color = 15780518
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        object lblTitle: TLabel
          Left = 11
          Top = 4
          Width = 51
          Height = 13
          Caption = 'Find Test'
        end
        object pnlTitleBottomLine: TADGUIxFormsPanel
          Left = 0
          Top = 22
          Width = 268
          Height = 1
          Align = alBottom
          BevelOuter = bvNone
          Color = clBtnShadow
          TabOrder = 0
        end
      end
    end
  end
  object pnlButtons: TADGUIxFormsPanel
    Left = 0
    Top = 77
    Width = 278
    Height = 34
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnOk: TButton
      Left = 116
      Top = 3
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Find'
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = btnFindClick
    end
    object Button1: TButton
      Left = 199
      Top = 3
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
end
