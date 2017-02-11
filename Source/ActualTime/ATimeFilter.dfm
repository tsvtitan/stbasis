object frmATimeFilter: TfrmATimeFilter
  Left = 428
  Top = 287
  BorderStyle = bsDialog
  Caption = 'Фильтры'
  ClientHeight = 241
  ClientWidth = 351
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 203
    Width = 351
    Height = 38
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object Panel2: TPanel
      Left = 184
      Top = 0
      Width = 167
      Height = 38
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object Button1: TButton
        Left = 8
        Top = 8
        Width = 75
        Height = 25
        Caption = 'ОК'
        Default = True
        ModalResult = 1
        TabOrder = 0
      end
      object Button2: TButton
        Left = 88
        Top = 8
        Width = 75
        Height = 25
        Cancel = True
        Caption = 'Отмена'
        ModalResult = 2
        TabOrder = 1
      end
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 351
    Height = 203
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Сотрудники'
    end
    object TabSheet2: TTabSheet
      Caption = 'Факты отработки'
      ImageIndex = 1
    end
  end
end
