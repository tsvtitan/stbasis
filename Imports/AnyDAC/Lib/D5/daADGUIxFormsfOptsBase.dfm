object frmADGUIxFormsOptsBase: TfrmADGUIxFormsOptsBase
  Left = 670
  Top = 26
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Options'
  ClientHeight = 318
  ClientWidth = 355
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object pnlButtons: TADGUIxFormsPanel
    Left = 0
    Top = 284
    Width = 355
    Height = 34
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object btnOk: TButton
      Left = 193
      Top = 3
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object btnCancel: TButton
      Left = 276
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
  object pnlMain: TADGUIxFormsPanel
    Left = 0
    Top = 0
    Width = 355
    Height = 284
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 4
    TabOrder = 1
    object pnlGray: TADGUIxFormsPanel
      Left = 4
      Top = 4
      Width = 347
      Height = 276
      Align = alClient
      BevelOuter = bvNone
      BorderWidth = 1
      Color = clBtnShadow
      TabOrder = 0
      object pnlOptions: TADGUIxFormsPanel
        Left = 1
        Top = 24
        Width = 345
        Height = 251
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 3
        Color = clWindow
        TabOrder = 0
      end
      object pnlTitle: TADGUIxFormsPanel
        Left = 1
        Top = 1
        Width = 345
        Height = 23
        Align = alTop
        Alignment = taLeftJustify
        BevelOuter = bvNone
        Color = $F0CAA6
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
          Width = 91
          Height = 13
          Caption = 'AnyDAC Options'
        end
        object pnlTitleBottomLine: TADGUIxFormsPanel
          Left = 0
          Top = 22
          Width = 345
          Height = 1
          Align = alBottom
          BevelOuter = bvNone
          Color = clBtnShadow
          TabOrder = 0
        end
      end
    end
  end
end
