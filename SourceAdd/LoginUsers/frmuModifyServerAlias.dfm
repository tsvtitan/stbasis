object frmModifyServerAlias: TfrmModifyServerAlias
  Left = 331
  Top = 206
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Error Reading Alias'
  ClientHeight = 292
  ClientWidth = 336
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 10
    Top = 89
    Width = 56
    Height = 13
    Caption = '&Alias Name:'
    FocusControl = edtAliasName
  end
  object Label2: TLabel
    Left = 10
    Top = 128
    Width = 65
    Height = 13
    Caption = '&Server Name:'
    FocusControl = edtServerName
  end
  object Label3: TLabel
    Left = 10
    Top = 167
    Width = 51
    Height = 13
    Caption = '&Username:'
    FocusControl = edtUsername
  end
  object Label4: TLabel
    Left = 10
    Top = 207
    Width = 42
    Height = 13
    Caption = '&Protocol:'
    FocusControl = cbProtocol
  end
  object imgError: TImage
    Left = 0
    Top = 0
    Width = 36
    Height = 36
    AutoSize = True
    Picture.Data = {
      07544269746D617046030000424D460300000000000076000000280000002400
      0000240000000100040000000000D00200000000000000000000100000001000
      000000000000000080000080000000808000800000008000800080800000C0C0
      C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
      FF00777777777777777777777777777777777777777777777777777777788888
      8887777777777777777777777777777788888888888888777777777777777777
      7777777881111111188888877777777777777777777778111999999991118888
      8777777777777777777781999999999999991888887777777777777777711999
      9999999999999118888777777777777777199999999999999999999188877777
      7777777771999999999999999999999918887777777777777199999999999999
      9999999918888777777777771999999F9999999999F999999188877777777771
      999999FFF99999999FFF9999991887777777777199999FFFFF999999FFFFF999
      9918887777777771999999FFFFF9999FFFFF999999188877777777199999999F
      FFFF99FFFFF99999999188777777771999999999FFFFFFFFFF99999999918877
      77777719999999999FFFFFFFF999999999918877777777199999999999FFFFFF
      9999999999918877777777199999999999FFFFFF999999999991887777777719
      999999999FFFFFFFF9999999999188777777771999999999FFFFFFFFFF999999
      99918777777777199999999FFFFF99FFFFF999999991877777777771999999FF
      FFF9999FFFFF9999991887777777777199999FFFFF999999FFFFF99999187777
      77777771999999FFF99999999FFF999999177777777777771999999F99999999
      99F9999991877777777777777199999999999999999999991877777777777777
      7199999999999999999999991777777777777777771999999999999999999991
      7777777777777777777119999999999999999117777777777777777777777199
      9999999999991777777777777777777777777711199999999111777777777777
      7777777777777777711111111777777777777777777777777777777777777777
      7777777777777777777777777777777777777777777777777777777777777777
      777777777777777777777777777777777777}
  end
  object edtAliasName: TEdit
    Left = 98
    Top = 79
    Width = 218
    Height = 21
    TabStop = False
    Color = clInactiveCaptionText
    Enabled = False
    ReadOnly = True
    TabOrder = 0
  end
  object edtServerName: TEdit
    Left = 98
    Top = 118
    Width = 218
    Height = 21
    TabOrder = 1
  end
  object edtUsername: TEdit
    Left = 98
    Top = 158
    Width = 218
    Height = 21
    TabOrder = 2
  end
  object cbProtocol: TComboBox
    Left = 98
    Top = 197
    Width = 218
    Height = 21
    ItemHeight = 13
    TabOrder = 3
    Items.Strings = (
      'TCP/IP'
      'NetBEUI'
      'SPX'
      'Local Server')
  end
  object Button1: TButton
    Left = 63
    Top = 246
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 4
  end
  object Button2: TButton
    Left = 181
    Top = 246
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Delete'
    ModalResult = 2
    TabOrder = 5
  end
  object stMessage: TStaticText
    Left = 59
    Top = 10
    Width = 257
    Height = 50
    AutoSize = False
    Caption = 'stMessage'
    TabOrder = 6
  end
end
