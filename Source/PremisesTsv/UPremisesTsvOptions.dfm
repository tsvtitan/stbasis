object fmOptions: TfmOptions
  Left = 473
  Top = 159
  Width = 424
  Height = 383
  Caption = 'fmOptions'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pc: TPageControl
    Left = 0
    Top = 0
    Width = 416
    Height = 352
    ActivePage = tsPremises
    Align = alClient
    TabOrder = 0
    object tsPremises: TTabSheet
      Caption = 'tsPremises'
      object pnPremises: TPanel
        Left = 0
        Top = 0
        Width = 408
        Height = 324
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object lbForDeleteTorecyled: TLabel
          Left = 7
          Top = 103
          Width = 240
          Height = 13
          Alignment = taRightJustify
          Caption = 'При удалении в корзину устанавливать статус:'
          WordWrap = True
        end
        object lbMoveFromRecyled: TLabel
          Left = 9
          Top = 127
          Width = 237
          Height = 39
          Alignment = taRightJustify
          Caption = 
            'Переносить при загрузке программы из корзины в реальные со стату' +
            'сом, если рабочая дата >= даты извлечения из корзины:'
          WordWrap = True
        end
        object lbSaleUnitPrice: TLabel
          Left = 45
          Top = 183
          Width = 202
          Height = 13
          Alignment = taRightJustify
          Caption = 'Единица измерения цены для продажи:'
        end
        object lbLeaseUnitPrice: TLabel
          Left = 51
          Top = 207
          Width = 196
          Height = 13
          Alignment = taRightJustify
          Caption = 'Единица измерения цены для аренды:'
        end
        object lbShareUnitPrice: TLabel
          Left = 42
          Top = 231
          Width = 205
          Height = 13
          Alignment = taRightJustify
          Caption = 'Единица измерения цены для долевого:'
        end
        object grbExportFonts: TGroupBox
          Left = 5
          Top = 6
          Width = 301
          Height = 60
          Caption = ' Шрифты '
          TabOrder = 0
          object lbPhoneColumn: TLabel
            Left = 16
            Top = 26
            Width = 92
            Height = 13
            Caption = 'Колонка телефон:'
          end
          object edPhoneColumn: TEdit
            Left = 119
            Top = 22
            Width = 145
            Height = 20
            Font.Charset = SYMBOL_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Wingdings'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            Text = 'АаБбВв'
          end
          object bibPhoneColumn: TButton
            Left = 264
            Top = 22
            Width = 21
            Height = 21
            Caption = '...'
            Constraints.MaxHeight = 21
            Constraints.MaxWidth = 21
            TabOrder = 1
            OnClick = bibPhoneColumnClick
          end
        end
        object chbUseSpecialTabOrderDel: TCheckBox
          Left = 6
          Top = 74
          Width = 353
          Height = 17
          Caption = 'Использовать специальный переход между элементами ввода'
          Checked = True
          State = cbChecked
          TabOrder = 1
          Visible = False
        end
        object edForDeleteTorecyled: TEdit
          Left = 254
          Top = 100
          Width = 73
          Height = 21
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 2
          OnKeyDown = edForDeleteTorecyledKeyDown
        end
        object btForDeleteTorecyled: TButton
          Left = 333
          Top = 100
          Width = 21
          Height = 21
          Caption = '...'
          TabOrder = 3
          OnClick = btForDeleteTorecyledClick
        end
        object edMoveFromRecyled: TEdit
          Left = 254
          Top = 138
          Width = 73
          Height = 21
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 4
          OnKeyDown = edMoveFromRecyledKeyDown
        end
        object btMoveFromRecyled: TButton
          Left = 333
          Top = 138
          Width = 21
          Height = 21
          Caption = '...'
          TabOrder = 5
          OnClick = btMoveFromRecyledClick
        end
        object edSaleUnitPrice: TEdit
          Left = 254
          Top = 180
          Width = 73
          Height = 21
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 6
          OnKeyDown = edSaleUnitPriceKeyDown
        end
        object btSaleUnitPrice: TButton
          Left = 332
          Top = 180
          Width = 21
          Height = 21
          Caption = '...'
          TabOrder = 7
          OnClick = btSaleUnitPriceClick
        end
        object edLeaseUnitPrice: TEdit
          Left = 254
          Top = 204
          Width = 73
          Height = 21
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 8
          OnKeyDown = edLeaseUnitPriceKeyDown
        end
        object btLeaseUnitPrice: TButton
          Left = 332
          Top = 204
          Width = 21
          Height = 21
          Caption = '...'
          TabOrder = 9
          OnClick = btLeaseUnitPriceClick
        end
        object edShareUnitPrice: TEdit
          Left = 254
          Top = 228
          Width = 73
          Height = 21
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 10
          OnKeyDown = edShareUnitPriceKeyDown
        end
        object btShareUnitPrice: TButton
          Left = 332
          Top = 228
          Width = 21
          Height = 21
          Caption = '...'
          TabOrder = 11
          OnClick = btShareUnitPriceClick
        end
        object chbCheckDoubleOnEdit: TCheckBox
          Left = 8
          Top = 264
          Width = 193
          Height = 17
          Caption = 'Проверять на дубль при вводе'
          Checked = True
          State = cbChecked
          TabOrder = 12
        end
        object chbClearFilterOnEnter: TCheckBox
          Left = 8
          Top = 280
          Width = 177
          Height = 17
          Caption = 'Очищать фильтр при входе'
          Checked = True
          State = cbChecked
          TabOrder = 13
        end
      end
    end
    object tsRptPrice: TTabSheet
      Caption = 'tsRptPrice'
      ImageIndex = 1
      object pnPrice: TPanel
        Left = 0
        Top = 0
        Width = 408
        Height = 324
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 5
        TabOrder = 0
        object GroupBox1: TGroupBox
          Left = 5
          Top = 5
          Width = 398
          Height = 52
          Align = alTop
          Caption = ' Директория шаблонов '
          TabOrder = 0
          object Panel5: TPanel
            Left = 2
            Top = 15
            Width = 394
            Height = 35
            Align = alClient
            BevelOuter = bvNone
            BorderWidth = 7
            TabOrder = 0
            object Panel6: TPanel
              Left = 361
              Top = 7
              Width = 26
              Height = 21
              Align = alRight
              BevelOuter = bvNone
              TabOrder = 0
              object bibReportDir: TButton
                Left = 1
                Top = 0
                Width = 21
                Height = 21
                Caption = '...'
                TabOrder = 0
                OnClick = bibReportDirClick
              end
            end
            object edReportDir: TEdit
              Left = 14
              Top = 6
              Width = 339
              Height = 21
              TabOrder = 1
            end
          end
        end
      end
    end
    object tsImport: TTabSheet
      Caption = 'tsImport'
      ImageIndex = 2
      object pnImport: TPanel
        Left = 0
        Top = 0
        Width = 408
        Height = 324
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 5
        TabOrder = 0
        object chbCheckDoubleOnImport: TCheckBox
          Left = 8
          Top = 8
          Width = 145
          Height = 17
          Caption = 'Проверять на дубли'
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
      end
    end
  end
  object fd: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MinFontSize = 8
    MaxFontSize = 8
    Options = [fdEffects, fdLimitSize]
    Left = 316
    Top = 56
  end
end
