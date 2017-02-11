inherited fmSvcSync: TfmSvcSync
  Left = 403
  Top = 224
  Width = 600
  Height = 300
  BorderIcons = [biSystemMenu]
  Caption = 'fmSvcSync'
  Constraints.MinHeight = 300
  Constraints.MinWidth = 600
  OldCreateOrder = False
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnMouseDown = FormMouseDown
  PixelsPerInch = 96
  TextHeight = 13
  object pnTop: TPanel
    Left = 0
    Top = 0
    Width = 592
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    OnMouseDown = FormMouseDown
    object pbStatus: TProgressBar
      Left = 10
      Top = 12
      Width = 372
      Height = 18
      Anchors = [akLeft, akTop, akRight]
      Min = 0
      Max = 100
      Smooth = True
      Step = 1
      TabOrder = 0
      OnMouseDown = FormMouseDown
    end
    object btSync: TButton
      Left = 392
      Top = 8
      Width = 114
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Синхронизировать'
      TabOrder = 1
      OnClick = btSyncClick
      OnMouseDown = FormMouseDown
    end
    object btCancel: TButton
      Left = 513
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Отмена'
      TabOrder = 2
      OnClick = btCancelClick
      OnMouseDown = FormMouseDown
    end
  end
  object sbBottom: TStatusBar
    Left = 0
    Top = 254
    Width = 592
    Height = 19
    Panels = <>
    SimplePanel = False
    OnMouseDown = FormMouseDown
  end
  object pnCenter: TPanel
    Left = 0
    Top = 41
    Width = 592
    Height = 213
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 3
    TabOrder = 1
    OnMouseDown = FormMouseDown
    object meHint: TMemo
      Left = 3
      Top = 3
      Width = 586
      Height = 207
      Align = alClient
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
      OnMouseDown = FormMouseDown
    end
  end
  object TimerStart: TTimer
    Interval = 5000
    OnTimer = TimerStartTimer
    Left = 128
    Top = 113
  end
  object TimerClose: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = TimerCloseTimer
    Left = 200
    Top = 113
  end
end
