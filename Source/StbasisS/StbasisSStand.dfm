object StbasisSStandForm: TStbasisSStandForm
  Left = 718
  Top = 267
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'StbasisSStandForm'
  ClientHeight = 47
  ClientWidth = 183
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object LabelTime: TLabel
    Left = 16
    Top = 16
    Width = 147
    Height = 13
    Caption = 'Stand up time: 0 days 00:00:00'
  end
  object Timer: TTimer
    Enabled = False
    OnTimer = TimerTimer
    Left = 112
    Top = 8
  end
end
