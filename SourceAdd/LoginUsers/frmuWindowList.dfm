inherited dlgWindowList: TdlgWindowList
  Left = 638
  Top = 520
  ActiveControl = lbWindows
  Caption = 'Active Windows'
  ClientHeight = 243
  ClientWidth = 296
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object lbWindows: TListBox
    Left = 0
    Top = 0
    Width = 178
    Height = 243
    Align = alLeft
    ItemHeight = 13
    TabOrder = 0
    OnClick = lbWindowsClick
    OnDblClick = btnSwitchClick
  end
  object btnSwitch: TButton
    Left = 190
    Top = 8
    Width = 101
    Height = 25
    Caption = '&Switch To...'
    Default = True
    Enabled = False
    TabOrder = 1
    OnClick = btnSwitchClick
  end
  object btnClose: TButton
    Left = 190
    Top = 39
    Width = 102
    Height = 25
    Caption = '&Close Window'
    Enabled = False
    TabOrder = 2
    OnClick = btnCloseClick
  end
end
