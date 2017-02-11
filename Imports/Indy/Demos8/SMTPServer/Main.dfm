object Form1: TForm1
  Left = 193
  Top = 149
  BorderStyle = bsSingle
  Caption = 'IdSMTPServer Demo'
  ClientHeight = 236
  ClientWidth = 377
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 48
    Width = 16
    Height = 13
    Caption = 'To:'
  end
  object Label2: TLabel
    Left = 8
    Top = 64
    Width = 26
    Height = 13
    Caption = 'From:'
  end
  object Label3: TLabel
    Left = 8
    Top = 80
    Width = 39
    Height = 13
    Caption = 'Subject:'
  end
  object ToLabel: TLabel
    Left = 56
    Top = 48
    Width = 3
    Height = 13
  end
  object FromLabel: TLabel
    Left = 56
    Top = 64
    Width = 3
    Height = 13
  end
  object SubjectLabel: TLabel
    Left = 56
    Top = 80
    Width = 3
    Height = 13
  end
  object Memo1: TMemo
    Left = 8
    Top = 96
    Width = 361
    Height = 137
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object IdSMTPServer1: TIdSMTPServer
    Active = True
    Bindings = <>
    DefaultPort = 25
    Messages.NoopReply = 'Ok'
    Messages.RSetReply = 'Ok'
    Messages.QuitReply = 'Signing Off'
    Messages.ErrorReply = 'Syntax Error - Command not understood: %s'
    Messages.XServer = 'Indy SMTP Server'
    Messages.ReceivedHeader = 'by DNSName [127.0.0.1] running Indy SMTP'
    Messages.SyntaxErrorReply = 'Syntax Error - Command not understood: %s'
    Messages.Greeting.WelcomeBanner = 'Welcome to the INDY SMTP Server'
    Messages.Greeting.EHLONotSupported = 'Command Not Recognised'
    Messages.Greeting.HelloReply = 'Hello %s'
    Messages.Greeting.NoHello = 'Polite people say HELO'
    Messages.Greeting.AuthFailed = 'Authentication Failed'
    Messages.Greeting.EHLOReply.Strings = (
      '250-localhost'
      '250-AUTH LOGIN'
      '250 HELP')
    Messages.RcpReplies.AddressOkReply = '%s Address Okay'
    Messages.RcpReplies.AddressErrorReply = '%s Address Error'
    Messages.RcpReplies.AddressWillForwardReply = 'User not local, Will forward'
    Messages.DataReplies.StartDataReply = 'Start mail input; end with <CRLF>.<CRLF>'
    Messages.DataReplies.EndDataReply = 'Ok'
    BasicWrites = True
    EnableEHLO = False
    OnCommandQUIT = IdSMTPServer1CommandQUIT
    OnCommandMAIL = IdSMTPServer1CommandMAIL
    OnCommandDATA = IdSMTPServer1CommandDATA
    OnCommandRCPT = IdSMTPServer1CommandRCPT
    OnCommandAUTH = IdSMTPServer1CommandAUTH
    OnCommandCheckUser = IdSMTPServer1CommandCheckUser
    OnCommandX = IdSMTPServer1CommandX
    OnADDRESSError = IdSMTPServer1ADDRESSError
  end
end
