object fmHtmlView: TfmHtmlView
  Left = 345
  Top = 205
  Width = 450
  Height = 350
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Просмотр Html'
  Color = clBtnFace
  Constraints.MinHeight = 350
  Constraints.MinWidth = 450
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    000000000000000074444447000000074CCCCCC470000074CCCCCCC34700004C
    C33CCCC3F40007F33F3CCCC3F47007FFF3CCCCC3FF4007FFF3CCCCC3FF4007FF
    F3CCCCC3334007FFF3CCCCC33340077FFF3CCC3FF47000733F3CC3FFF4000077
    C33CCC3F470000077CCCCC34700000007777777700000000000000000000FFFF
    0000F00F0000E0070000C0030000C00300008001000080010000800100008001
    00008001000080010000C0030000C0030000E0070000F00F0000FFFF0000}
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pnBottom: TPanel
    Left = 0
    Top = 282
    Width = 442
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btClose: TButton
      Left = 359
      Top = 9
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Закрыть'
      TabOrder = 0
      OnClick = btCloseClick
    end
  end
  object pnView: TPanel
    Left = 0
    Top = 0
    Width = 442
    Height = 282
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object wbView: TWebBrowser
      Left = 0
      Top = 0
      Width = 442
      Height = 282
      Align = alClient
      TabOrder = 0
      OnProgressChange = wbViewProgressChange
      OnDownloadBegin = wbViewDownloadBegin
      OnDownloadComplete = wbViewDownloadComplete
      ControlData = {
        4C000000AF2D0000251D00000000000000000000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E126208000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
  end
end
