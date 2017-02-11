object frmBlob: TfrmBlob
  Left = 665
  Top = 201
  Width = 346
  Height = 290
  BorderStyle = bsSizeToolWin
  Caption = 'Blob Data'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMain: TADGUIxFormsPanel
    Left = 0
    Top = 0
    Width = 338
    Height = 256
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 11
    TabOrder = 0
    object imgData: TImage
      Left = 11
      Top = 11
      Width = 316
      Height = 234
      Align = alClient
    end
    object mmBinary: TMemo
      Left = 11
      Top = 11
      Width = 316
      Height = 234
      Align = alClient
      BorderStyle = bsNone
      ReadOnly = True
      TabOrder = 0
    end
    object mmData: TMemo
      Left = 11
      Top = 11
      Width = 316
      Height = 234
      Align = alClient
      BorderStyle = bsNone
      ReadOnly = True
      TabOrder = 1
    end
    object wbHTML: TWebBrowser
      Left = 11
      Top = 11
      Width = 316
      Height = 234
      Align = alClient
      TabOrder = 2
      ControlData = {
        4C000000A92000002F1800000000000000000000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E126208000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 120
    Top = 32
    object Default1: TMenuItem
      Caption = '&Default'
      Checked = True
      GroupIndex = 1
      RadioItem = True
      OnClick = ForceClick
    end
    object ForceText1: TMenuItem
      Caption = 'Force &Text'
      GroupIndex = 1
      RadioItem = True
      OnClick = ForceClick
    end
    object ForceBinary1: TMenuItem
      Caption = 'Force &Binary'
      GroupIndex = 1
      RadioItem = True
      OnClick = ForceClick
    end
    object ForceGraphic1: TMenuItem
      Caption = 'Force &Graphic'
      GroupIndex = 1
      RadioItem = True
      OnClick = ForceClick
    end
    object ForceHTML1: TMenuItem
      Caption = 'Force &HTML'
      GroupIndex = 1
      RadioItem = True
      OnClick = ForceClick
    end
    object N1: TMenuItem
      Caption = '-'
      GroupIndex = 1
    end
    object StayOnTop1: TMenuItem
      Caption = 'Stay On Top'
      GroupIndex = 2
      OnClick = StayOnTop1Click
    end
  end
  object DataSource1: TDataSource
    OnDataChange = DataSource1DataChange
    Left = 152
    Top = 32
  end
end
