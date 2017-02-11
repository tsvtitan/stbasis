object dlgProgress: TdlgProgress
  Left = 282
  Top = 433
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = 'Query Process'
  ClientHeight = 79
  ClientWidth = 460
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object Bevel1: TBevel
    Left = 0
    Top = 87
    Width = 460
    Height = 16
    Shape = bsTopLine
  end
  object txtCurrentStatement: TMemo
    Left = 0
    Top = 107
    Width = 460
    Height = 151
    TabStop = False
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 0
  end
  object ProgressBar: TProgressBar
    Left = 9
    Top = 9
    Width = 443
    Height = 19
    Min = 0
    Max = 100
    Smooth = True
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 178
    Top = 39
    Width = 93
    Height = 31
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
    OnClick = Cancel
  end
  object btnDetails: TButton
    Left = 348
    Top = 39
    Width = 93
    Height = 31
    Caption = 'Details >>'
    TabOrder = 3
    Visible = False
    OnClick = btnDetailsClick
  end
end
