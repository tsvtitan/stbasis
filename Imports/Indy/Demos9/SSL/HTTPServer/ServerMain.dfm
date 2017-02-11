object fmHTTPServerMain: TfmHTTPServerMain
  Left = 313
  Top = 173
  Width = 383
  Height = 342
  BiDiMode = bdLeftToRight
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'HTTP Server demo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  ParentBiDiMode = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object LabelRoot: TLabel
    Left = 3
    Top = 101
    Width = 23
    Height = 13
    Caption = 'Root'
  end
  object edPort: TEdit
    Left = 88
    Top = 8
    Width = 41
    Height = 21
    TabOrder = 0
    Text = '443'
    OnChange = edPortChange
    OnExit = edPortExit
    OnKeyPress = edPortKeyPress
  end
  object cbActive: TCheckBox
    Left = 0
    Top = 32
    Width = 129
    Height = 17
    Action = acActivate
    TabOrder = 1
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 296
    Width = 375
    Height = 19
    Panels = <>
    SimplePanel = False
  end
  object edRoot: TEdit
    Left = 37
    Top = 96
    Width = 336
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 3
  end
  object cbAuthentication: TCheckBox
    Left = 136
    Top = 8
    Width = 177
    Height = 17
    Caption = 'Require authentication'
    TabOrder = 4
  end
  object cbManageSessions: TCheckBox
    Left = 136
    Top = 24
    Width = 177
    Height = 17
    Caption = 'Manage user sessions'
    TabOrder = 5
  end
  object cbEnableLog: TCheckBox
    Left = 136
    Top = 40
    Width = 177
    Height = 17
    Caption = 'Enable log'
    Checked = True
    State = cbChecked
    TabOrder = 6
  end
  object cbLocalIPList: TComboBox
    Left = 0
    Top = 8
    Width = 81
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 7
    Items.Strings = (
      '0.0.0.0'
      '127.0.0.1')
  end
  object cbSSL: TCheckBox
    Left = 136
    Top = 56
    Width = 97
    Height = 17
    Caption = 'use SSL'
    Checked = True
    State = cbChecked
    TabOrder = 8
  end
  object Panel1: TPanel
    Left = 0
    Top = 127
    Width = 375
    Height = 169
    Align = alBottom
    Caption = 'Panel1'
    TabOrder = 9
    object Splitter1: TSplitter
      Left = 1
      Top = 83
      Width = 373
      Height = 2
      Cursor = crVSplit
      Align = alBottom
    end
    object sslLog: TListBox
      Left = 1
      Top = 85
      Width = 373
      Height = 83
      Align = alBottom
      ItemHeight = 13
      TabOrder = 0
    end
    object lbLog: TListBox
      Left = 1
      Top = 1
      Width = 373
      Height = 82
      Align = alClient
      ItemHeight = 13
      TabOrder = 1
    end
  end
  object HTTPServer: TIdHTTPServer
    Active = False
    Bindings = <
      item
        Port = 80
      end>
    DefaultPort = 80
    OnConnect = HTTPServerConnect
    ThreadMgr = IdThreadMgrDefault1
    Intercept = IdServerInterceptOpenSSL1
    OnCommandGet = HTTPServerCommandGet
    SessionState = False
    AutoStartSession = True
    SessionTimeOut = 1200000
    OnSessionStart = HTTPServerSessionStart
    OnSessionEnd = HTTPServerSessionEnd
    Left = 288
  end
  object alGeneral: TActionList
    Left = 256
    object acActivate: TAction
      Caption = '&Activate'
      OnExecute = acActivateExecute
    end
  end
  object IdThreadMgrDefault1: TIdThreadMgrDefault
    Left = 288
    Top = 32
  end
  object IdServerInterceptOpenSSL1: TIdServerInterceptOpenSSL
    SSLOptions.RootCertFile = 'W:\source\Indy\Demos\SSL\HTTPServer\cert\CAcert.pem'
    SSLOptions.CertFile = 'W:\source\Indy\Demos\SSL\HTTPServer\cert\WSScert.pem'
    SSLOptions.KeyFile = 'W:\source\Indy\Demos\SSL\HTTPServer\cert\WSSkey.pem'
    SSLOptions.Method = sslvSSLv2
    SSLOptions.Mode = sslmUnassigned
    SSLOptions.VerifyMode = []
    SSLOptions.VerifyDepth = 0
    OnGetPassword = IdServerInterceptOpenSSL1GetPassword
    Left = 320
    Top = 32
  end
end
