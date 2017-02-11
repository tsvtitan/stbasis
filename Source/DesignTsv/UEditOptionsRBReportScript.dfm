object fmEditOptionsRBReportScript: TfmEditOptionsRBReportScript
  Left = 265
  Top = 229
  BorderStyle = bsDialog
  Caption = 'fmEditOptionsRBReportScript'
  ClientHeight = 242
  ClientWidth = 305
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object lbName: TLabel
    Left = 8
    Top = 11
    Width = 79
    Height = 13
    Caption = 'Наименование:'
  end
  object lbHint: TLabel
    Left = 34
    Top = 38
    Width = 53
    Height = 13
    Caption = 'Описание:'
  end
  object pnBut: TPanel
    Left = 0
    Top = 204
    Width = 305
    Height = 38
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    object Panel2: TPanel
      Left = 120
      Top = 0
      Width = 185
      Height = 38
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object bibOk: TBitBtn
        Left = 22
        Top = 5
        Width = 75
        Height = 25
        Hint = 'Подтвердить'
        Caption = 'OK'
        Default = True
        TabOrder = 0
        OnClick = bibOkClick
        NumGlyphs = 2
      end
      object bibCancel: TBitBtn
        Left = 104
        Top = 5
        Width = 75
        Height = 25
        Hint = 'Отменить'
        Cancel = True
        Caption = 'Отмена'
        ModalResult = 2
        TabOrder = 1
        NumGlyphs = 2
      end
    end
  end
  object edName: TEdit
    Left = 95
    Top = 8
    Width = 203
    Height = 21
    MaxLength = 20
    TabOrder = 0
  end
  object edHint: TEdit
    Left = 95
    Top = 35
    Width = 203
    Height = 21
    MaxLength = 100
    TabOrder = 1
  end
  object grbCode: TGroupBox
    Left = 8
    Top = 59
    Width = 290
    Height = 141
    Caption = ' Код '
    TabOrder = 2
    object pnCode: TPanel
      Left = 2
      Top = 15
      Width = 286
      Height = 124
      Align = alClient
      BevelOuter = bvNone
      BorderWidth = 5
      TabOrder = 0
    end
  end
end
