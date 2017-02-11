object fmEditOptionsKeyRBInterfaceScript: TfmEditOptionsKeyRBInterfaceScript
  Left = 265
  Top = 229
  BorderStyle = bsDialog
  Caption = 'fmEditOptionsKeyRBInterfaceScript'
  ClientHeight = 185
  ClientWidth = 264
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
  PixelsPerInch = 96
  TextHeight = 13
  object lbCommand: TLabel
    Left = 8
    Top = 68
    Width = 48
    Height = 13
    Caption = 'Команда:'
  end
  object lbKeyOne: TLabel
    Left = 8
    Top = 96
    Width = 113
    Height = 13
    Caption = 'Клавиша для первого:'
  end
  object lbKeyTwo: TLabel
    Left = 8
    Top = 122
    Width = 112
    Height = 13
    Caption = 'Клавиша для второго:'
  end
  object pnBut: TPanel
    Left = 0
    Top = 147
    Width = 264
    Height = 38
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 4
    object Panel2: TPanel
      Left = 79
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
  object rgCase: TRadioGroup
    Left = 8
    Top = 8
    Width = 249
    Height = 49
    Caption = ' Тип клавиш '
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'Первый'
      'Второй')
    TabOrder = 0
    OnClick = rgCaseClick
  end
  object cmbCommand: TComboBox
    Left = 64
    Top = 65
    Width = 193
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
  end
  object hkKeyOne: THotKey
    Left = 130
    Top = 94
    Width = 127
    Height = 19
    HotKey = 0
    InvalidKeys = [hcNone, hcShift]
    Modifiers = []
    TabOrder = 2
  end
  object hkKeyTwo: THotKey
    Left = 130
    Top = 120
    Width = 127
    Height = 19
    HotKey = 0
    InvalidKeys = [hcNone, hcShift]
    Modifiers = []
    TabOrder = 3
  end
end
