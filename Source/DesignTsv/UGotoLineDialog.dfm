object fmGotoLineDialog: TfmGotoLineDialog
  Left = 301
  Top = 278
  BorderStyle = bsDialog
  Caption = 'Перейти к линии'
  ClientHeight = 108
  ClientWidth = 225
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnBut: TPanel
    Left = 0
    Top = 70
    Width = 225
    Height = 38
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Panel2: TPanel
      Left = 40
      Top = 0
      Width = 185
      Height = 38
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object bibOk: TButton
        Left = 22
        Top = 5
        Width = 75
        Height = 25
        Hint = 'Подтвердить'
        Caption = 'OK'
        Default = True
        TabOrder = 0
        OnClick = bibOkClick
      end
      object bibCancel: TButton
        Left = 104
        Top = 5
        Width = 75
        Height = 25
        Hint = 'Отменить'
        Cancel = True
        Caption = 'Отмена'
        ModalResult = 2
        TabOrder = 1
      end
    end
  end
  object grbGotoLine: TGroupBox
    Left = 8
    Top = 8
    Width = 209
    Height = 57
    Caption = ' Введите номер линии '
    TabOrder = 0
    object lbLine: TLabel
      Left = 14
      Top = 26
      Width = 70
      Height = 13
      Caption = 'Номер линии:'
    end
    object cmbLine: TComboBox
      Left = 96
      Top = 23
      Width = 99
      Height = 21
      ItemHeight = 13
      MaxLength = 6
      TabOrder = 0
    end
  end
end
