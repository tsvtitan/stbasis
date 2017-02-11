object fmRBMainTreeView: TfmRBMainTreeView
  Left = 470
  Top = 199
  Width = 470
  Height = 340
  Caption = '����������'
  Color = clBtnFace
  Constraints.MinHeight = 340
  Constraints.MinWidth = 470
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
    0000000000000000000000000000078888888888880007FFFFFFFFFFF80007FF
    0000FFFFF80007FF00FF0FFFF80007FF00FF0FFFF80007FF00FF0FFFF80007FF
    0000FFFFF80007FF00FF0FFFF80007FF00FF0FFFF80007FF00FF0FF0000007FF
    0000FFF7880007FFFFFFFFF7800007FFFFFFFFF700000777777777770000FFFF
    0000800100008001000080010000800100008001000080010000800100008001
    0000800100008001000080010000800100008003000080070000800F0000}
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object pnTreeViewBack: TPanel
    Left = 0
    Top = 28
    Width = 462
    Height = 245
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object pnBut: TPanel
      Left = 378
      Top = 0
      Width = 84
      Height = 245
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      object pnModal: TPanel
        Left = 0
        Top = 101
        Width = 84
        Height = 144
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object bibFilter: TButton
          Left = 3
          Top = 72
          Width = 75
          Height = 25
          Hint = '������ (F7)'
          Caption = '������'
          TabOrder = 2
          OnClick = bibFilterClick
          OnKeyDown = FormKeyDown
        end
        object bibView: TButton
          Left = 3
          Top = 40
          Width = 75
          Height = 25
          Hint = '��������� (F6)'
          Caption = '���������'
          TabOrder = 1
          OnKeyDown = FormKeyDown
        end
        object bibRefresh: TButton
          Left = 3
          Top = 8
          Width = 75
          Height = 25
          Hint = '�������� (F5)'
          Caption = '��������'
          TabOrder = 0
          OnKeyDown = FormKeyDown
        end
        object bibAdjust: TButton
          Left = 3
          Top = 104
          Width = 75
          Height = 25
          Hint = '��������� (F8)'
          Caption = '���������'
          TabOrder = 3
          Visible = False
          OnKeyDown = FormKeyDown
        end
      end
      object pnSQL: TPanel
        Left = 0
        Top = 0
        Width = 84
        Height = 101
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object bibAdd: TButton
          Left = 3
          Top = 1
          Width = 75
          Height = 25
          Hint = '�������� (F2)'
          Caption = '��������'
          TabOrder = 0
          OnKeyDown = FormKeyDown
        end
        object bibChange: TButton
          Left = 3
          Top = 33
          Width = 75
          Height = 25
          Hint = '�������� (F3)'
          Caption = '��������'
          TabOrder = 1
          OnKeyDown = FormKeyDown
        end
        object bibDel: TButton
          Left = 3
          Top = 65
          Width = 75
          Height = 25
          Hint = '������� (F4)'
          Caption = '�������'
          TabOrder = 2
          OnKeyDown = FormKeyDown
        end
      end
    end
    object pnTreeView: TPanel
      Left = 0
      Top = 0
      Width = 378
      Height = 245
      Align = alClient
      BevelOuter = bvNone
      BorderWidth = 5
      TabOrder = 0
    end
  end
  object pnFind: TPanel
    Left = 0
    Top = 0
    Width = 462
    Height = 28
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Label1: TLabel
      Left = 9
      Top = 9
      Width = 34
      Height = 13
      Caption = '�����:'
    end
    object edSearch: TEdit
      Left = 50
      Top = 6
      Width = 315
      Height = 21
      MaxLength = 30
      TabOrder = 0
      OnKeyDown = edSearchKeyDown
      OnKeyUp = edSearchKeyUp
    end
  end
  object pnBottom: TPanel
    Left = 0
    Top = 273
    Width = 462
    Height = 36
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object lbCount: TLabel
      Left = 165
      Top = 15
      Width = 89
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = '����� �������: 0'
    end
    object bibOk: TButton
      Left = 299
      Top = 6
      Width = 75
      Height = 25
      Hint = '�����������'
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      Default = True
      TabOrder = 0
      Visible = False
    end
    object DBNav: TDBNavigator
      Left = 6
      Top = 12
      Width = 148
      Height = 18
      DataSource = ds
      VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
      Anchors = [akLeft, akBottom]
      Hints.Strings = (
        '������ ������'
        '���������� ������'
        '��������� ������'
        '��������� ������'
        '�������� ������'
        '������� ������'
        '������������� ������'
        '���������� ��������������'
        '�������� ��������������'
        '�������� ������')
      ParentShowHint = False
      ShowHint = False
      TabOrder = 1
    end
    object bibClose: TButton
      Left = 381
      Top = 6
      Width = 75
      Height = 25
      Hint = '�������'
      Anchors = [akRight, akBottom]
      Caption = '�������'
      TabOrder = 2
      OnClick = bibCloseClick
    end
  end
  object ds: TDataSource
    AutoEdit = False
    DataSet = Mainqr
    Left = 96
    Top = 112
  end
  object Mainqr: TIBQuery
    Transaction = IBTran
    BufferChunks = 1000
    CachedUpdates = False
    Left = 136
    Top = 112
  end
  object IBTran: TIBTransaction
    Active = False
    DefaultAction = TARollback
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    AutoStopAction = saNone
    Left = 176
    Top = 113
  end
  object IL: TImageList
    Left = 272
    Top = 113
    Bitmap = {
      494C010103000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484008484840084848400000000000000000000000000848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      840084848400848484000000000000000000000000000000000084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400FFFFFF0000FF
      FF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FF
      FF00C6C6C60000FFFF008484840000000000000000000000000084848400FFFF
      FF0000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6
      C60000FFFF00848484000000000000000000000000000000000084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400FFFFFF00C6C6
      C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6
      C60000FFFF00C6C6C60084848400000000000000000084848400FFFFFF0000FF
      FF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FF
      FF00C6C6C600000000008484840000000000000000000000000084848400FFFF
      FF00848484008484840084848400FFFFFF00848484008484840084848400FFFF
      FF00848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400FFFFFF0000FF
      FF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FF
      FF00C6C6C60000FFFF0084848400000000000000000084848400FFFFFF00C6C6
      C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6
      C60084848400000000008484840000000000000000000000000084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400FFFFFF00C6C6
      C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6
      C60000FFFF00C6C6C600848484000000000084848400FFFFFF00C6C6C60000FF
      FF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FF
      FF0000000000848484008484840000000000000000000000000084848400FFFF
      FF0084848400848484008484840084848400FFFFFF008484840084848400FFFF
      FF00848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400FFFFFF0000FF
      FF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FF
      FF00C6C6C60000FFFF00848484000000000084848400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008484
      840000000000C6C6C6008484840000000000000000000000000084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400FFFFFF00C6C6
      C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6
      C60000FFFF00C6C6C60084848400000000008484840084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      84008484840000FFFF008484840000000000000000000000000084848400FFFF
      FF00848484008484840084848400FFFFFF008484840084848400FFFFFF00FFFF
      FF00848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400FFFFFF0000FF
      FF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FF
      FF00C6C6C60000FFFF0084848400000000000000000084848400FFFFFF00C6C6
      C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6
      C60000FFFF00C6C6C6008484840000000000000000000000000084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0084848400000000000000000084848400FFFFFF0000FF
      FF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C600FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF008484840000000000000000000000000084848400FFFF
      FF0084848400848484008484840084848400FFFFFF008484840084848400FFFF
      FF00848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000008484840000FFFF00C6C6
      C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF0084848400848484008484
      8400848484008484840084848400000000000000000084848400FFFFFF00C6C6
      C60000FFFF00C6C6C60000FFFF00C6C6C600FFFFFF0084848400848484008484
      840084848400848484008484840000000000000000000000000084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000008484840000FF
      FF00C6C6C60000FFFF00C6C6C60000FFFF008484840000000000000000000000
      000000000000000000000000000000000000000000000000000084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008484840000000000000000000000
      000000000000000000000000000000000000000000000000000084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400848484008484840084848400848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400848484008484840084848400848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFFFFFF0000FFFFFFFFE0030000
      C000E000C00300008000C000C00300008000C000C003000080008000C0030000
      80008000C003000080000000C003000080000000C003000080000000C0030000
      80008000C003000080008000C003000080018001C0030000C07FC07FC0030000
      E0FFE0FFC0070000FFFFFFFFFFFF000000000000000000000000000000000000
      000000000000}
  end
  object pmTV: TPopupMenu
    OnPopup = pmTVPopup
    Left = 224
    Top = 113
  end
end