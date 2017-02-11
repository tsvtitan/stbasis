object FmRbkEdit: TFmRbkEdit
  Left = 248
  Top = 160
  BorderStyle = bsDialog
  Caption = 'Редактировать'
  ClientHeight = 290
  ClientWidth = 330
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnKeyUp = FormKeyUp
  PixelsPerInch = 96
  TextHeight = 13
  object PnBtn: TPanel
    Left = 0
    Top = 250
    Width = 330
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    Constraints.MinHeight = 40
    TabOrder = 0
    object Panel1: TPanel
      Left = 153
      Top = 0
      Width = 177
      Height = 40
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object BtPost: TBitBtn
        Left = 1
        Top = 8
        Width = 75
        Height = 25
        Caption = 'OK'
        Default = True
        TabOrder = 0
        OnClick = BtPostClick
        NumGlyphs = 2
      end
      object BtCancel: TButton
        Left = 94
        Top = 8
        Width = 75
        Height = 25
        Cancel = True
        Caption = 'Отмена'
        ModalResult = 2
        TabOrder = 1
        OnClick = BtCancelClick
      end
    end
    object btClear: TBitBtn
      Left = 9
      Top = 7
      Width = 75
      Height = 25
      Hint = 'Очистить'
      Caption = 'Очистить'
      TabOrder = 1
      Visible = False
      OnClick = btClearClick
      NumGlyphs = 2
    end
  end
  object PnEdit: TPanel
    Left = 0
    Top = 0
    Width = 330
    Height = 250
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object PnFilter: TPanel
      Left = 0
      Top = 231
      Width = 330
      Height = 19
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 0
      Visible = False
      object CBInsideFilter: TCheckBox
        Left = 9
        Top = 1
        Width = 177
        Height = 17
        Caption = 'Фильтр по вхождению строки'
        TabOrder = 0
      end
    end
  end
  object IBQ: TIBQuery
    Transaction = Trans
    BufferChunks = 1000
    CachedUpdates = False
    Left = 40
    Top = 65533
  end
  object Trans: TIBTransaction
    Active = False
    Left = 104
    Top = 69
  end
end
