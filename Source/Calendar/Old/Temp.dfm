object Form1: TForm1
  Left = 297
  Top = 229
  Width = 696
  Height = 480
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 688
    Height = 453
    ActivePage = TabSheet4
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Недели'
      object Panel2: TPanel
        Left = 599
        Top = 0
        Width = 81
        Height = 425
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 0
        object Button3: TButton
          Left = 4
          Top = 4
          Width = 75
          Height = 25
          Caption = 'Добавить'
          TabOrder = 0
        end
        object Button4: TButton
          Left = 4
          Top = 36
          Width = 75
          Height = 25
          Caption = 'Удалить'
          TabOrder = 1
        end
        object Button5: TButton
          Left = 4
          Top = 68
          Width = 75
          Height = 25
          Caption = 'Изменить'
          TabOrder = 2
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Праздники'
      ImageIndex = 1
      object Panel3: TPanel
        Left = 262
        Top = 0
        Width = 81
        Height = 226
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 0
        object Button6: TButton
          Left = 4
          Top = 4
          Width = 75
          Height = 25
          Caption = 'Добавить'
          TabOrder = 0
        end
        object Button7: TButton
          Left = 4
          Top = 36
          Width = 75
          Height = 25
          Caption = 'Удалить'
          TabOrder = 1
        end
        object Button8: TButton
          Left = 4
          Top = 68
          Width = 75
          Height = 25
          Caption = 'Изменить'
          TabOrder = 2
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Переносы'
      ImageIndex = 2
      object Panel4: TPanel
        Left = 262
        Top = 0
        Width = 81
        Height = 226
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 0
        object Button9: TButton
          Left = 4
          Top = 4
          Width = 75
          Height = 25
          Caption = 'Добавить'
          TabOrder = 0
        end
        object Button10: TButton
          Left = 4
          Top = 36
          Width = 75
          Height = 25
          Caption = 'Удалить'
          TabOrder = 1
        end
        object Button11: TButton
          Left = 4
          Top = 68
          Width = 75
          Height = 25
          Caption = 'Изменить'
          TabOrder = 2
        end
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Исключения'
      ImageIndex = 3
      object Panel5: TPanel
        Left = 599
        Top = 105
        Width = 81
        Height = 320
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 0
        object Button12: TButton
          Left = 4
          Top = 4
          Width = 75
          Height = 25
          Caption = 'Добавить'
          TabOrder = 0
        end
        object Button13: TButton
          Left = 4
          Top = 36
          Width = 75
          Height = 25
          Caption = 'Удалить'
          TabOrder = 1
        end
        object Button14: TButton
          Left = 4
          Top = 68
          Width = 75
          Height = 25
          Caption = 'Изменить'
          TabOrder = 2
        end
      end
      object Panel6: TPanel
        Left = 0
        Top = 0
        Width = 680
        Height = 105
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object GroupBox1: TGroupBox
          Left = 4
          Top = 4
          Width = 337
          Height = 93
          Caption = 'Информация'
          TabOrder = 0
          object Label1: TLabel
            Left = 12
            Top = 16
            Width = 77
            Height = 13
            Caption = 'Годовая норма'
          end
          object Label2: TLabel
            Left = 12
            Top = 40
            Width = 148
            Height = 13
            Caption = 'Расчётная норма по графику'
          end
          object Label3: TLabel
            Left = 12
            Top = 64
            Width = 146
            Height = 13
            Caption = 'Образующаяся переработка'
          end
          object Label4: TLabel
            Left = 308
            Top = 20
            Width = 20
            Height = 13
            Caption = 'час.'
          end
          object Label5: TLabel
            Left = 308
            Top = 44
            Width = 20
            Height = 13
            Caption = 'час.'
          end
          object Label6: TLabel
            Left = 308
            Top = 68
            Width = 20
            Height = 13
            Caption = 'час.'
          end
          object Edit1: TEdit
            Left = 184
            Top = 16
            Width = 121
            Height = 21
            Color = clBtnFace
            TabOrder = 0
            Text = '0'
          end
          object Edit2: TEdit
            Left = 184
            Top = 40
            Width = 121
            Height = 21
            Color = clBtnFace
            TabOrder = 1
            Text = '0'
          end
          object Edit3: TEdit
            Left = 184
            Top = 64
            Width = 121
            Height = 21
            Color = clBtnFace
            TabOrder = 2
            Text = '0'
          end
        end
      end
    end
  end
end
