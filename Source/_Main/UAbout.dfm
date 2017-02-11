object fmAbout: TfmAbout
  Left = 306
  Top = 200
  BorderStyle = bsDialog
  Caption = 'О программе'
  ClientHeight = 232
  ClientWidth = 310
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lbTel: TLabel
    Left = 0
    Top = 45
    Width = 310
    Height = 18
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Layout = tlCenter
  end
  object lbCorp: TLabel
    Left = 0
    Top = 32
    Width = 310
    Height = 13
    Align = alTop
    Alignment = taCenter
  end
  object lbVer: TLabel
    Left = 0
    Top = 19
    Width = 310
    Height = 13
    Align = alTop
    Alignment = taCenter
    Caption = 'Версии нет'
  end
  object lbMain: TLabel
    Left = 0
    Top = 0
    Width = 310
    Height = 19
    Align = alTop
    Alignment = taCenter
    Caption = 'Это тест'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    OnDblClick = lbMainDblClick
  end
  object Bevel1: TBevel
    Left = 0
    Top = 183
    Width = 310
    Height = 9
    Align = alBottom
    Shape = bsBottomLine
  end
  object lbMemAll: TLabel
    Left = 5
    Top = 156
    Width = 73
    Height = 13
    Caption = 'Всего памяти:'
  end
  object lbMemUse: TLabel
    Left = 5
    Top = 171
    Width = 118
    Height = 13
    Caption = 'Используемой памяти:'
  end
  object Bevel2: TBevel
    Left = 0
    Top = 63
    Width = 310
    Height = 3
    Align = alTop
    Shape = bsBottomLine
  end
  object imEXE: TImage
    Left = 8
    Top = 17
    Width = 32
    Height = 32
    OnClick = imEXEClick
  end
  object pnBottom: TPanel
    Left = 0
    Top = 192
    Width = 310
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object btOk: TButton
      Left = 223
      Top = 9
      Width = 80
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Закрыть'
      ModalResult = 2
      TabOrder = 0
    end
  end
  object pnRule: TPanel
    Left = 6
    Top = 73
    Width = 299
    Height = 80
    BevelOuter = bvLowered
    Color = clBlack
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
end
