object fmEditRB: TfmEditRB
  Left = 672
  Top = 344
  BorderStyle = bsDialog
  Caption = 'fmEditRB'
  ClientHeight = 149
  ClientWidth = 330
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnKeyUp = FormKeyUp
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnBut: TPanel
    Left = 0
    Top = 111
    Width = 330
    Height = 38
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object Panel2: TPanel
      Left = 145
      Top = 0
      Width = 185
      Height = 38
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 3
      object bibOk: TButton
        Left = 22
        Top = 5
        Width = 75
        Height = 25
        Hint = 'Подтвердить'
        Caption = 'OK'
        Default = True
        TabOrder = 0
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
    object bibClear: TButton
      Left = 7
      Top = 5
      Width = 75
      Height = 25
      Hint = 'Очистить'
      Caption = 'Очистить'
      TabOrder = 2
      Visible = False
      OnClick = bibClearClick
    end
    object bibPrev: TButton
      Left = 8
      Top = 6
      Width = 37
      Height = 23
      Hint = 'Предыдущая запись'
      TabOrder = 0
      Visible = False
    end
    object bibNext: TButton
      Left = 45
      Top = 6
      Width = 37
      Height = 23
      Hint = 'Следующая запись'
      TabOrder = 1
      Visible = False
    end
  end
  object cbInString: TCheckBox
    Left = 6
    Top = 88
    Width = 186
    Height = 17
    Caption = 'Фильтр по вхождению строки'
    TabOrder = 1
    Visible = False
  end
  object IBTran: TIBTransaction
    Active = False
    DefaultAction = TARollback
    AutoStopAction = saNone
    Left = 24
    Top = 17
  end
end
