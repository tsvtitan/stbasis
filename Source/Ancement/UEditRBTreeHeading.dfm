inherited fmEditRBTreeheading: TfmEditRBTreeheading
  Left = 427
  Top = 223
  Caption = 'fmEditRBTreeheading'
  ClientHeight = 229
  ClientWidth = 337
  PixelsPerInch = 96
  TextHeight = 13
  object lbNameHeading: TLabel [0]
    Left = 18
    Top = 16
    Width = 123
    Height = 13
    Caption = 'Наименование рубрики:'
    FocusControl = edNameHeading
  end
  object lbParent: TLabel [1]
    Left = 9
    Top = 42
    Width = 132
    Height = 13
    Caption = 'Рубрика верхнего уровня:'
    FocusControl = edParent
  end
  object lbSortNumber: TLabel [2]
    Left = 32
    Top = 68
    Width = 109
    Height = 13
    Caption = 'Порядок сортировки:'
    FocusControl = edSortNumber
  end
  inherited pnBut: TPanel
    Top = 191
    Width = 337
    TabOrder = 7
    inherited Panel2: TPanel
      Left = 152
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 175
    TabOrder = 6
  end
  object edNameHeading: TEdit [5]
    Left = 149
    Top = 12
    Width = 178
    Height = 21
    MaxLength = 100
    TabOrder = 0
    OnChange = edNameHeadingChange
  end
  object edParent: TEdit [6]
    Left = 149
    Top = 38
    Width = 157
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 1
    OnChange = edNameHeadingChange
    OnKeyDown = edParentKeyDown
  end
  object bibParent: TButton [7]
    Left = 306
    Top = 38
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 2
    OnClick = bibParentClick
  end
  object edSortNumber: TEdit [8]
    Left = 149
    Top = 65
    Width = 59
    Height = 21
    MaxLength = 6
    ReadOnly = True
    TabOrder = 3
    Text = '1'
    OnChange = edNameHeadingChange
  end
  object udSortNumber: TUpDown [9]
    Left = 208
    Top = 65
    Width = 16
    Height = 21
    Associate = edSortNumber
    Min = 1
    Position = 1
    TabOrder = 4
    Thousands = False
    Wrap = False
  end
  object GrbFont: TGroupBox [10]
    Left = 8
    Top = 92
    Width = 320
    Height = 80
    Caption = ' Шрифт при экспорте '
    TabOrder = 5
    object meFont: TMemo
      Left = 10
      Top = 22
      Width = 277
      Height = 50
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
      OnChange = edNameHeadingChange
    end
    object bibFont: TButton
      Left = 287
      Top = 21
      Width = 21
      Height = 50
      Caption = '...'
      TabOrder = 1
      OnClick = bibFontClick
    end
  end
  inherited IBTran: TIBTransaction
    Left = 104
    Top = 153
  end
  object fd: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MinFontSize = 0
    MaxFontSize = 0
    Left = 144
    Top = 160
  end
end
