object Form1: TForm1
  Left = 415
  Top = 121
  Width = 697
  Height = 456
  Caption = 'Set New Security ACL'
  Color = clBtnFace
  Constraints.MinHeight = 450
  Constraints.MinWidth = 690
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lv: TListView
    Left = 0
    Top = 41
    Width = 689
    Height = 347
    Align = alClient
    Checkboxes = True
    Columns = <
      item
        Caption = 'TableName'
        Width = 150
      end
      item
        Caption = 'Description'
        Width = 100
      end
      item
        Caption = 'SecurityClass'
        Width = 100
      end
      item
        Caption = 'ACL text'
      end
      item
        Caption = 'ACL'
      end
      item
        Caption = 'DefaultClass'
        Width = 100
      end
      item
        Caption = 'Def ACL Text'
      end
      item
        Caption = 'Def ACL'
      end>
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    PopupMenu = PopupMenu1
    TabOrder = 0
    ViewStyle = vsReport
    OnChange = lvChange
  end
  object Panel1: TPanel
    Left = 0
    Top = 388
    Width = 689
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Label1: TLabel
      Left = 111
      Top = 15
      Width = 48
      Height = 13
      Anchors = [akRight, akBottom]
      Caption = 'New ACL:'
    end
    object Button1: TButton
      Left = 495
      Top = 8
      Width = 183
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Set New Security ACL for Checked'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 8
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Get tables'
      TabOrder = 1
      OnClick = Button2Click
    end
    object edACL: TEdit
      Left = 167
      Top = 11
      Width = 186
      Height = 21
      Anchors = [akRight, akBottom]
      TabOrder = 2
    end
    object chbSetToDefautl: TCheckBox
      Left = 360
      Top = 13
      Width = 97
      Height = 17
      Anchors = [akRight, akBottom]
      Caption = 'With default'
      TabOrder = 3
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 689
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object Label2: TLabel
      Left = 11
      Top = 14
      Width = 49
      Height = 13
      Caption = 'Database:'
    end
    object edDB: TEdit
      Left = 68
      Top = 11
      Width = 493
      Height = 21
      TabOrder = 0
    end
    object bibDB: TBitBtn
      Left = 571
      Top = 10
      Width = 22
      Height = 23
      Caption = '...'
      TabOrder = 1
      OnClick = bibDBClick
    end
    object bibConnect: TBitBtn
      Left = 603
      Top = 10
      Width = 70
      Height = 23
      Caption = 'Connect'
      TabOrder = 2
      OnClick = bibConnectClick
    end
  end
  object IBDB: TIBDatabase
    Params.Strings = (
      'lc_ctype=WIN1251')
    IdleTimer = 0
    SQLDialect = 3
    TraceFlags = []
    Left = 80
    Top = 88
  end
  object PopupMenu1: TPopupMenu
    Left = 136
    Top = 176
    object Checkall1: TMenuItem
      Caption = 'Check all'
      OnClick = Checkall1Click
    end
    object Uncheckall1: TMenuItem
      Caption = 'Uncheck all'
      OnClick = Uncheckall1Click
    end
  end
  object od: TOpenDialog
    Options = [ofEnableSizing]
    Left = 232
    Top = 112
  end
end
