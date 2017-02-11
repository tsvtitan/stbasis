object fmOptions: TfmOptions
  Left = 395
  Top = 166
  Width = 421
  Height = 379
  Caption = 'fmOptions'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pc: TPageControl
    Left = 0
    Top = 0
    Width = 413
    Height = 348
    ActivePage = tsDocs
    Align = alClient
    TabOrder = 0
    object tsScript: TTabSheet
      Caption = 'tsScript'
      object pnScript: TPanel
        Left = 0
        Top = 0
        Width = 405
        Height = 320
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object pnScriptBottom: TPanel
          Left = 0
          Top = 189
          Width = 405
          Height = 131
          Align = alBottom
          BevelOuter = bvNone
          BorderWidth = 5
          TabOrder = 0
          object grbScriptPreview: TGroupBox
            Left = 5
            Top = 5
            Width = 395
            Height = 121
            Align = alClient
            Caption = ' Предварительный просмотр '
            TabOrder = 0
            OnDblClick = grbScriptPreviewDblClick
            object pnScriptRAEditor: TPanel
              Left = 2
              Top = 15
              Width = 391
              Height = 104
              Align = alClient
              BevelOuter = bvNone
              BorderWidth = 5
              TabOrder = 0
            end
          end
        end
        object pcScript: TPageControl
          Left = 0
          Top = 0
          Width = 405
          Height = 189
          ActivePage = tbsScriptOther
          Align = alClient
          HotTrack = True
          TabOrder = 1
          OnChange = pcScriptChange
          object tbsScriptGeneral: TTabSheet
            Caption = 'Общие'
            ImageIndex = 1
            object lbScriptTabStops: TLabel
              Left = 214
              Top = 121
              Width = 70
              Height = 13
              Alignment = taRightJustify
              Caption = 'Табулостопы:'
            end
            object lbScriptGutterWidth: TLabel
              Left = 213
              Top = 72
              Width = 71
              Height = 13
              Caption = 'Отступ слева:'
            end
            object lbScriptRightMargin: TLabel
              Left = 216
              Top = 48
              Width = 68
              Height = 13
              Caption = 'Правое поле:'
            end
            object lbScriptSelBlockFormat: TLabel
              Left = 203
              Top = 96
              Width = 81
              Height = 13
              Caption = 'Тип выделения:'
            end
            object edScriptTabStops: TEdit
              Left = 290
              Top = 117
              Width = 104
              Height = 21
              TabOrder = 15
              Text = '3 5'
              OnChange = edScriptTabStopsChange
            end
            object cbScriptUndoAfterSave: TCheckBox
              Left = 5
              Top = 103
              Width = 161
              Height = 17
              Caption = 'Отмена после сохранения'
              TabOrder = 5
              OnClick = cbScriptUndoAfterSaveClick
            end
            object cbScriptDoubleClickLine: TCheckBox
              Left = 5
              Top = 143
              Width = 193
              Height = 17
              Caption = 'Двойной клик выделяет строку'
              TabOrder = 7
              OnClick = cbScriptDoubleClickLineClick
            end
            object cbScriptKeepTrailingBlanks: TCheckBox
              Left = 5
              Top = 123
              Width = 202
              Height = 17
              Caption = 'Сохранять завершающие пробелы'
              TabOrder = 6
              OnClick = cbScriptKeepTrailingBlanksClick
            end
            object cbScriptSytaxHighlighting: TCheckBox
              Left = 198
              Top = 3
              Width = 152
              Height = 17
              Caption = 'Выделять синтаксис'
              TabOrder = 8
              OnClick = cbScriptSytaxHighlightingClick
            end
            object cbScriptAutoIndent: TCheckBox
              Left = 5
              Top = 3
              Width = 121
              Height = 17
              Caption = 'Автоотступ'
              TabOrder = 0
              OnClick = cbScriptAutoIndentClick
            end
            object cbScriptSmartTab: TCheckBox
              Left = 5
              Top = 23
              Width = 135
              Height = 17
              Caption = 'Умный таб'
              TabOrder = 1
              OnClick = cbScriptSmartTabClick
            end
            object cbScriptBackspaceUnindents: TCheckBox
              Left = 5
              Top = 43
              Width = 135
              Height = 17
              Caption = 'Забой сдвигает назад'
              TabOrder = 2
              OnClick = cbScriptBackspaceUnindentsClick
            end
            object cbScriptGroupUndo: TCheckBox
              Left = 5
              Top = 63
              Width = 135
              Height = 17
              Caption = 'Групповая отмена'
              TabOrder = 3
              OnClick = cbScriptGroupUndoClick
            end
            object cbScriptCursorBeyondEOF: TCheckBox
              Left = 5
              Top = 83
              Width = 145
              Height = 17
              Caption = 'Курсор за конец файла'
              TabOrder = 4
              OnClick = cbScriptCursorBeyondEOFClick
            end
            object edScriptGutterWidth: TEdit
              Left = 290
              Top = 69
              Width = 37
              Height = 21
              ReadOnly = True
              TabOrder = 12
              Text = '0'
            end
            object udScriptGutterWidth: TUpDown
              Left = 327
              Top = 69
              Width = 15
              Height = 21
              Associate = edScriptGutterWidth
              Min = 0
              Position = 0
              TabOrder = 13
              Wrap = False
              OnChangingEx = udScriptGutterWidthChangingEx
            end
            object edScriptRightMargin: TEdit
              Left = 290
              Top = 45
              Width = 37
              Height = 21
              ReadOnly = True
              TabOrder = 10
              Text = '0'
            end
            object udScriptRightMargin: TUpDown
              Left = 327
              Top = 45
              Width = 15
              Height = 21
              Associate = edScriptRightMargin
              Min = 0
              Max = 999
              Position = 0
              TabOrder = 11
              Wrap = False
              OnChangingEx = udScriptRightMarginChangingEx
            end
            object cbScriptRightMarginVisisble: TCheckBox
              Left = 198
              Top = 23
              Width = 152
              Height = 17
              Caption = 'Показывать правое поле'
              TabOrder = 9
              OnClick = cbScriptRightMarginVisisbleClick
            end
            object cmbScriptSelBlockFormat: TComboBox
              Left = 290
              Top = 93
              Width = 104
              Height = 21
              Style = csDropDownList
              ItemHeight = 13
              TabOrder = 14
              OnChange = cmbScriptSelBlockFormatChange
              Items.Strings = (
                'Column'
                'Inclusive'
                'Line'
                'NonInclusive')
            end
            object edScriptAutoChange: TEdit
              Left = 341
              Top = 141
              Width = 37
              Height = 21
              Color = clBtnFace
              Enabled = False
              ReadOnly = True
              TabOrder = 17
              Text = '800'
            end
            object udScriptAutoChange: TUpDown
              Left = 378
              Top = 141
              Width = 15
              Height = 21
              Associate = edScriptAutoChange
              Enabled = False
              Min = 100
              Max = 2000
              Increment = 100
              Position = 800
              TabOrder = 18
              Wrap = False
              OnChangingEx = udScriptAutoChangeChangingEx
            end
            object cbScriptAutoChange: TCheckBox
              Left = 241
              Top = 143
              Width = 96
              Height = 17
              Caption = 'Подстановка:'
              TabOrder = 16
              OnClick = cbScriptAutoChangeClick
            end
          end
          object tbsScriptHigh: TTabSheet
            Caption = 'Подсветка'
            object lbScriptTypeHigh: TLabel
              Left = 9
              Top = 10
              Width = 84
              Height = 13
              Caption = 'Вид синтаксиса:'
            end
            object lbScriptRElement: TLabel
              Left = 226
              Top = 10
              Width = 47
              Height = 13
              Caption = 'Элемент:'
            end
            object cmbScriptTypeHigh: TComboBox
              Left = 101
              Top = 7
              Width = 116
              Height = 21
              Style = csDropDownList
              ItemHeight = 13
              TabOrder = 0
              OnChange = cmbScriptTypeHighChange
              Items.Strings = (
                'По умолчанию'
                'Pascal'
                'CBuilder'
                'Sql'
                'Python'
                'Java'
                'VB'
                'Html'
                'Perl'
                'Ini'
                'Coco/R')
            end
            object cmbScriptRElement: TComboBox
              Left = 280
              Top = 7
              Width = 110
              Height = 21
              Style = csDropDownList
              ItemHeight = 13
              TabOrder = 1
              Items.Strings = (
                'Whitespace'
                'Comment'
                'Reserved word'
                'Identifer'
                'Symbol'
                'String'
                'Number'
                'Preprocessor'
                'Declaration'
                'Function call'
                'Statement'
                'Plain text'
                'Marked block'
                'Right margin'
                'Gutter'
                'BookMark'
                'Find Text'
                'Error Line')
            end
            object grbScriptColors: TGroupBox
              Left = 9
              Top = 32
              Width = 237
              Height = 73
              Caption = ' Цвета '
              TabOrder = 2
              object lbScriptFGColor: TLabel
                Left = 6
                Top = 20
                Width = 80
                Height = 13
                Caption = 'Передний план:'
              end
              object lbScriptBGColor: TLabel
                Left = 19
                Top = 43
                Width = 67
                Height = 13
                Caption = 'Задний план:'
              end
              object cmbScriptFGColor: TComboBox
                Left = 92
                Top = 17
                Width = 136
                Height = 21
                Style = csDropDownList
                ItemHeight = 13
                TabOrder = 0
                OnChange = cmbScriptFGColorChange
                Items.Strings = (
                  'Whitespace'
                  'Comment'
                  'Reserved word'
                  'Identifer'
                  'Symbol'
                  'String'
                  'Number'
                  'Preprocessor'
                  'Declaration'
                  'Function call'
                  'Statement'
                  'Plain text'
                  'Marked block'
                  'Right margin')
              end
              object cmbScriptBGColor: TComboBox
                Left = 92
                Top = 41
                Width = 136
                Height = 21
                Style = csDropDownList
                ItemHeight = 13
                TabOrder = 1
                OnChange = cmbScriptBGColorChange
                Items.Strings = (
                  'Whitespace'
                  'Comment'
                  'Reserved word'
                  'Identifer'
                  'Symbol'
                  'String'
                  'Number'
                  'Preprocessor'
                  'Declaration'
                  'Function call'
                  'Statement'
                  'Plain text'
                  'Marked block'
                  'Right margin')
              end
            end
            object grbScriptTextAttr: TGroupBox
              Left = 252
              Top = 32
              Width = 138
              Height = 73
              Caption = ' Стиль текста '
              TabOrder = 3
              object chbScriptTextAttrBold: TCheckBox
                Left = 8
                Top = 16
                Width = 97
                Height = 17
                Caption = 'Полужирный'
                TabOrder = 0
                OnClick = chbScriptTextAttrBoldClick
              end
              object chbScriptTextAttrItalic: TCheckBox
                Left = 8
                Top = 32
                Width = 97
                Height = 17
                Caption = 'Курсив'
                TabOrder = 1
                OnClick = chbScriptTextAttrItalicClick
              end
              object chbScriptTextAttrUnderline: TCheckBox
                Left = 8
                Top = 48
                Width = 97
                Height = 17
                Caption = 'Подчеркнутый'
                TabOrder = 2
                OnClick = chbScriptTextAttrUnderlineClick
              end
            end
            object grbScriptFont: TGroupBox
              Left = 9
              Top = 107
              Width = 381
              Height = 51
              Caption = ' Шрифт '
              TabOrder = 4
              object lbScriptFontName: TLabel
                Left = 11
                Top = 23
                Width = 67
                Height = 13
                Caption = 'Имя шрифта:'
              end
              object lbScriptFontSize: TLabel
                Left = 277
                Top = 23
                Width = 42
                Height = 13
                Caption = 'Размер:'
              end
              object cmbScriptFontName: TComboBox
                Left = 85
                Top = 19
                Width = 182
                Height = 21
                Style = csDropDownList
                ItemHeight = 13
                TabOrder = 0
                OnChange = cmbScriptFontNameChange
                Items.Strings = (
                  'Whitespace'
                  'Comment'
                  'Reserved word'
                  'Identifer'
                  'Symbol'
                  'String'
                  'Number'
                  'Preprocessor'
                  'Declaration'
                  'Function call'
                  'Statement'
                  'Plain text'
                  'Marked block'
                  'Right margin')
              end
              object edScriptFontSize: TEdit
                Left = 326
                Top = 20
                Width = 29
                Height = 21
                ReadOnly = True
                TabOrder = 1
                Text = '6'
              end
              object udScriptFontSize: TUpDown
                Left = 355
                Top = 20
                Width = 15
                Height = 21
                Associate = edScriptFontSize
                Min = 6
                Max = 72
                Position = 6
                TabOrder = 2
                Wrap = False
                OnChangingEx = udScriptFontSizeChangingEx
              end
            end
          end
          object tbsScriptCodeIns: TTabSheet
            Caption = 'Заготовки кода'
            ImageIndex = 3
            TabVisible = False
            object pnScriptCodeIns: TPanel
              Left = 0
              Top = 0
              Width = 397
              Height = 165
              Align = alClient
              BevelOuter = bvNone
              BorderWidth = 5
              TabOrder = 0
              object Panel1: TPanel
                Left = 5
                Top = 131
                Width = 387
                Height = 29
                Align = alBottom
                BevelOuter = bvNone
                TabOrder = 1
                object bibScriptAddCodeIns: TButton
                  Left = 129
                  Top = 7
                  Width = 60
                  Height = 20
                  Anchors = [akRight, akBottom]
                  Caption = 'Добавить'
                  TabOrder = 0
                  OnClick = bibScriptAddCodeInsClick
                end
                object bibScriptEditCodeIns: TButton
                  Left = 195
                  Top = 7
                  Width = 60
                  Height = 20
                  Anchors = [akRight, akBottom]
                  Caption = 'Изменить'
                  TabOrder = 1
                  OnClick = bibScriptEditCodeInsClick
                end
                object bibScriptDelCodeIns: TButton
                  Left = 261
                  Top = 7
                  Width = 60
                  Height = 20
                  Anchors = [akRight, akBottom]
                  Caption = 'Удалить'
                  TabOrder = 2
                  OnClick = bibScriptDelCodeInsClick
                end
                object bibScriptResetCodeIns: TButton
                  Left = 327
                  Top = 7
                  Width = 60
                  Height = 20
                  Anchors = [akRight, akBottom]
                  Caption = 'Сброс'
                  TabOrder = 3
                  OnClick = bibScriptResetCodeInsClick
                end
              end
              object Panel2: TPanel
                Left = 5
                Top = 5
                Width = 387
                Height = 126
                Align = alClient
                BevelOuter = bvNone
                TabOrder = 0
                object Bevel1: TBevel
                  Left = 193
                  Top = 0
                  Width = 5
                  Height = 126
                  Align = alLeft
                  Shape = bsSpacer
                end
                object lvScriptCodeIns: TListView
                  Left = 0
                  Top = 0
                  Width = 193
                  Height = 126
                  Align = alLeft
                  Columns = <
                    item
                      Caption = 'Наименование'
                      MinWidth = 50
                      Width = 60
                    end
                    item
                      AutoSize = True
                      Caption = 'Описание'
                      MinWidth = 50
                    end>
                  HideSelection = False
                  MultiSelect = True
                  ReadOnly = True
                  RowSelect = True
                  TabOrder = 0
                  ViewStyle = vsReport
                  OnChange = lvScriptCodeInsChange
                  OnColumnClick = lvScriptCodeInsColumnClick
                  OnCustomDrawItem = lvScriptCodeInsCustomDrawItem
                  OnDblClick = lvScriptCodeInsDblClick
                end
                object pnScriptBackRAEditorCodeIns: TPanel
                  Left = 198
                  Top = 0
                  Width = 189
                  Height = 122
                  Align = alClient
                  BevelOuter = bvNone
                  TabOrder = 1
                end
              end
            end
          end
          object tbsScriptKey: TTabSheet
            Caption = 'Клавиши управления'
            ImageIndex = 3
            object Panel3: TPanel
              Left = 0
              Top = 0
              Width = 397
              Height = 161
              Align = alClient
              BevelOuter = bvNone
              BorderWidth = 5
              TabOrder = 0
              object lvScriptKey: TListView
                Left = 5
                Top = 5
                Width = 320
                Height = 151
                Align = alClient
                Columns = <
                  item
                    Caption = 'Команда'
                    MinWidth = 50
                    Width = 190
                  end
                  item
                    Caption = 'Клавиши'
                    MinWidth = 50
                    Width = 100
                  end>
                HideSelection = False
                MultiSelect = True
                ReadOnly = True
                RowSelect = True
                TabOrder = 0
                ViewStyle = vsReport
                OnColumnClick = lvScriptKeyColumnClick
                OnCustomDrawItem = lvScriptCodeInsCustomDrawItem
                OnDblClick = lvScriptKeyDblClick
              end
              object Panel4: TPanel
                Left = 325
                Top = 5
                Width = 67
                Height = 151
                Align = alRight
                BevelOuter = bvNone
                TabOrder = 1
                object bibScriptAddKey: TButton
                  Left = 6
                  Top = 1
                  Width = 60
                  Height = 20
                  Caption = 'Добавить'
                  TabOrder = 0
                  OnClick = bibScriptAddKeyClick
                end
                object bibScriptChangeKey: TButton
                  Left = 6
                  Top = 27
                  Width = 60
                  Height = 20
                  Caption = 'Изменить'
                  TabOrder = 1
                  OnClick = bibScriptChangeKeyClick
                end
                object bibScriptDelKey: TButton
                  Left = 6
                  Top = 53
                  Width = 60
                  Height = 20
                  Caption = 'Удалить'
                  TabOrder = 2
                  OnClick = bibScriptDelKeyClick
                end
                object bibScriptResetKey: TButton
                  Left = 6
                  Top = 79
                  Width = 60
                  Height = 20
                  Caption = 'Сброс'
                  TabOrder = 3
                  OnClick = bibScriptResetKeyClick
                end
              end
            end
          end
          object tbsScriptOther: TTabSheet
            Caption = 'Другие'
            ImageIndex = 4
            object pnIdentiferColors: TPanel
              Left = 0
              Top = 0
              Width = 397
              Height = 161
              Align = alClient
              BevelOuter = bvNone
              BorderWidth = 5
              TabOrder = 0
              object grbColorIdentifers: TGroupBox
                Left = 5
                Top = 5
                Width = 387
                Height = 151
                Align = alClient
                Caption = ' Цвета подстановок '
                TabOrder = 0
                object lbIdentiferColorBackGround: TLabel
                  Left = 14
                  Top = 20
                  Width = 67
                  Height = 13
                  Caption = 'Задний план:'
                end
                object lbIdentiferColorVar: TLabel
                  Left = 12
                  Top = 44
                  Width = 69
                  Height = 13
                  Caption = 'Переменные:'
                end
                object lbIdentiferColorConst: TLabel
                  Left = 23
                  Top = 68
                  Width = 58
                  Height = 13
                  Caption = 'Константы:'
                end
                object lbIdentiferColorFunction: TLabel
                  Left = 32
                  Top = 92
                  Width = 49
                  Height = 13
                  Caption = 'Функции:'
                end
                object lbIdentiferColorProcedure: TLabel
                  Left = 20
                  Top = 116
                  Width = 60
                  Height = 13
                  Caption = 'Процедуры:'
                end
                object lbIdentiferColorProperty: TLabel
                  Left = 213
                  Top = 20
                  Width = 51
                  Height = 13
                  Caption = 'Свойства:'
                end
                object lbIdentiferColorType: TLabel
                  Left = 234
                  Top = 44
                  Width = 30
                  Height = 13
                  Caption = 'Типы:'
                end
                object lbIdentiferColorCaption: TLabel
                  Left = 207
                  Top = 68
                  Width = 57
                  Height = 13
                  Caption = 'Заголовок:'
                end
                object lbIdentiferColorParam: TLabel
                  Left = 202
                  Top = 92
                  Width = 62
                  Height = 13
                  Caption = 'Параметры:'
                end
                object lbIdentiferColorHint: TLabel
                  Left = 211
                  Top = 116
                  Width = 53
                  Height = 13
                  Caption = 'Описание:'
                end
                object cmbIdentiferColorBackGround: TComboBox
                  Left = 92
                  Top = 17
                  Width = 95
                  Height = 21
                  Style = csDropDownList
                  ItemHeight = 0
                  TabOrder = 0
                end
                object cmbIdentiferColorVar: TComboBox
                  Left = 92
                  Top = 41
                  Width = 95
                  Height = 21
                  Style = csDropDownList
                  ItemHeight = 0
                  TabOrder = 1
                end
                object cmbIdentiferColorConst: TComboBox
                  Left = 92
                  Top = 65
                  Width = 95
                  Height = 21
                  Style = csDropDownList
                  ItemHeight = 0
                  TabOrder = 2
                end
                object cmbIdentiferColorFunction: TComboBox
                  Left = 92
                  Top = 89
                  Width = 95
                  Height = 21
                  Style = csDropDownList
                  ItemHeight = 0
                  TabOrder = 3
                end
                object cmbIdentiferColorProcedure: TComboBox
                  Left = 91
                  Top = 113
                  Width = 95
                  Height = 21
                  Style = csDropDownList
                  ItemHeight = 0
                  TabOrder = 4
                end
                object cmbIdentiferColorProperty: TComboBox
                  Left = 275
                  Top = 17
                  Width = 95
                  Height = 21
                  Style = csDropDownList
                  ItemHeight = 0
                  TabOrder = 5
                end
                object cmbIdentiferColorType: TComboBox
                  Left = 275
                  Top = 41
                  Width = 95
                  Height = 21
                  Style = csDropDownList
                  ItemHeight = 0
                  TabOrder = 6
                end
                object cmbIdentiferColorCaption: TComboBox
                  Left = 275
                  Top = 65
                  Width = 95
                  Height = 21
                  Style = csDropDownList
                  ItemHeight = 0
                  TabOrder = 7
                end
                object cmbIdentiferColorParam: TComboBox
                  Left = 275
                  Top = 89
                  Width = 95
                  Height = 21
                  Style = csDropDownList
                  ItemHeight = 0
                  TabOrder = 8
                end
                object cmbIdentiferColorHint: TComboBox
                  Left = 275
                  Top = 113
                  Width = 95
                  Height = 21
                  Style = csDropDownList
                  ItemHeight = 0
                  TabOrder = 9
                end
              end
            end
          end
        end
      end
    end
    object tsForms: TTabSheet
      Caption = 'tsForms'
      ImageIndex = 1
      object pnForms: TPanel
        Left = 0
        Top = 0
        Width = 405
        Height = 320
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object pcForms: TPageControl
          Left = 0
          Top = 0
          Width = 405
          Height = 320
          ActivePage = tsFormsKeys
          Align = alClient
          HotTrack = True
          TabOrder = 0
          object tsFormsGeneral: TTabSheet
            Caption = 'Общие'
            object lbRBRFSizeHandle: TLabel
              Left = 233
              Top = 114
              Width = 101
              Height = 13
              Caption = 'Размер выделения:'
            end
            object grbRBRFHints: TGroupBox
              Left = 208
              Top = 2
              Width = 185
              Height = 88
              Caption = ' Подсказки '
              TabOrder = 1
              object chbRBRFHintsControl: TCheckBox
                Left = 8
                Top = 16
                Width = 161
                Height = 17
                Caption = 'При наведении на объект'
                Checked = True
                State = cbChecked
                TabOrder = 0
              end
              object chbRBRFHintsSize: TCheckBox
                Left = 8
                Top = 32
                Width = 161
                Height = 17
                Caption = 'При изменении размеров'
                Checked = True
                State = cbChecked
                TabOrder = 1
              end
              object chbRBRFHintsMove: TCheckBox
                Left = 8
                Top = 48
                Width = 166
                Height = 17
                Caption = 'При передвижении'
                Checked = True
                State = cbChecked
                TabOrder = 2
              end
              object chbRBRFHintsInsert: TCheckBox
                Left = 8
                Top = 64
                Width = 161
                Height = 17
                Caption = 'При вставке'
                Checked = True
                State = cbChecked
                TabOrder = 3
              end
            end
            object grbRBRFGrid: TGroupBox
              Left = 6
              Top = 2
              Width = 195
              Height = 129
              Caption = ' Сетка '
              TabOrder = 0
              object lbRBRFGridXStep: TLabel
                Left = 50
                Top = 55
                Width = 80
                Height = 13
                Caption = 'Шаг сетки по X:'
              end
              object lbRBRFGridYStep: TLabel
                Left = 50
                Top = 79
                Width = 80
                Height = 13
                Caption = 'Шаг сетки по Y:'
              end
              object lbRBRFGridColor: TLabel
                Left = 11
                Top = 103
                Width = 28
                Height = 13
                Caption = 'Цвет:'
              end
              object chbRBRFGridVisible: TCheckBox
                Left = 8
                Top = 16
                Width = 121
                Height = 17
                Caption = 'Показать сетку'
                Checked = True
                State = cbChecked
                TabOrder = 0
              end
              object edRBRFGridXStep: TEdit
                Left = 138
                Top = 51
                Width = 34
                Height = 21
                ReadOnly = True
                TabOrder = 1
                Text = '8'
              end
              object udRBRFGridXStep: TUpDown
                Left = 172
                Top = 51
                Width = 15
                Height = 21
                Associate = edRBRFGridXStep
                Min = 2
                Max = 50
                Position = 8
                TabOrder = 2
                Wrap = False
              end
              object edRBRFGridYStep: TEdit
                Left = 138
                Top = 75
                Width = 34
                Height = 21
                ReadOnly = True
                TabOrder = 3
                Text = '8'
              end
              object udRBRFGridYStep: TUpDown
                Left = 172
                Top = 75
                Width = 15
                Height = 21
                Associate = edRBRFGridYStep
                Min = 2
                Max = 50
                Position = 8
                TabOrder = 4
                Wrap = False
              end
              object chbRBRFGridAlign: TCheckBox
                Left = 8
                Top = 32
                Width = 137
                Height = 17
                Caption = 'Привязывать к сетке'
                Checked = True
                State = cbChecked
                TabOrder = 5
              end
              object cmbRBRFGridColor: TComboBox
                Left = 46
                Top = 100
                Width = 141
                Height = 21
                Style = csDropDownList
                ItemHeight = 0
                TabOrder = 6
              end
            end
            object grbRBRFColors: TGroupBox
              Left = 6
              Top = 135
              Width = 387
              Height = 154
              Caption = ' Цвета выделения объектов '
              TabOrder = 4
              object lbRBRFColorsCurrent: TLabel
                Left = 140
                Top = 127
                Width = 74
                Height = 13
                Caption = 'Текущий цвет:'
              end
              object cmbRBRFColorsCurrent: TComboBox
                Left = 224
                Top = 123
                Width = 153
                Height = 21
                Style = csDropDownList
                ItemHeight = 0
                TabOrder = 1
                OnChange = cmbRBRFColorsCurrentChange
              end
              object lbRBRFColors: TListBox
                Left = 10
                Top = 19
                Width = 366
                Height = 97
                ItemHeight = 13
                Items.Strings = (
                  'Только одного объекта'
                  'Рамка только одного объекта'
                  'Многих объектов'
                  'Рамка многих объектов'
                  'При потере фокуса'
                  'Рамка при потере фокуса'
                  'При блокировке')
                TabOrder = 0
                OnClick = lbRBRFColorsClick
              end
            end
            object edRBRFSizeHandle: TEdit
              Left = 343
              Top = 111
              Width = 34
              Height = 21
              ReadOnly = True
              TabOrder = 2
              Text = '5'
            end
            object udRBRFSizeHandle: TUpDown
              Left = 377
              Top = 111
              Width = 15
              Height = 21
              Associate = edRBRFSizeHandle
              Min = 2
              Max = 20
              Position = 5
              TabOrder = 3
              Wrap = False
            end
            object chbViewComponentCaption: TCheckBox
              Left = 250
              Top = 92
              Width = 142
              Height = 17
              Hint = 'Показывать заголовки компонент'
              Alignment = taLeftJustify
              Caption = 'Показывать заголовки'
              TabOrder = 5
            end
          end
          object tsFormsObjInsp: TTabSheet
            Caption = 'Объектный инспектор'
            ImageIndex = 1
            object chbRBRFTranslate: TCheckBox
              Left = 7
              Top = 10
              Width = 138
              Height = 17
              Caption = 'Переводить свойства'
              Checked = True
              State = cbChecked
              TabOrder = 0
            end
            object grbObjInspColor: TGroupBox
              Left = 8
              Top = 32
              Width = 297
              Height = 121
              Caption = ' Цвета '
              TabOrder = 1
              object lbObjColorValue: TLabel
                Left = 31
                Top = 92
                Width = 95
                Height = 13
                Caption = 'Значения свойств:'
              end
              object lbObjColorProperty: TLabel
                Left = 75
                Top = 20
                Width = 51
                Height = 13
                Caption = 'Свойства:'
              end
              object lbObjColorSubProperty: TLabel
                Left = 14
                Top = 44
                Width = 112
                Height = 13
                Caption = 'Вложенные свойства:'
              end
              object lbObjColorReference: TLabel
                Left = 34
                Top = 68
                Width = 92
                Height = 13
                Caption = 'Свойства ссылки:'
              end
              object cmbObjColorValue: TComboBox
                Left = 135
                Top = 88
                Width = 153
                Height = 21
                Style = csDropDownList
                ItemHeight = 0
                TabOrder = 0
              end
              object cmbObjColorProperty: TComboBox
                Left = 135
                Top = 16
                Width = 153
                Height = 21
                Style = csDropDownList
                ItemHeight = 0
                TabOrder = 1
              end
              object cmbObjColorSubProperty: TComboBox
                Left = 135
                Top = 40
                Width = 153
                Height = 21
                Style = csDropDownList
                ItemHeight = 0
                TabOrder = 2
              end
              object cmbObjColorReference: TComboBox
                Left = 135
                Top = 64
                Width = 153
                Height = 21
                Style = csDropDownList
                ItemHeight = 0
                TabOrder = 3
              end
            end
          end
          object tsFormsKeys: TTabSheet
            Caption = 'Клавиши управления'
            ImageIndex = 2
            object pnRBRFKeys: TPanel
              Left = 0
              Top = 0
              Width = 397
              Height = 292
              Align = alClient
              BevelOuter = bvNone
              BorderWidth = 5
              TabOrder = 0
              object lvRBRFKeys: TListView
                Left = 5
                Top = 5
                Width = 320
                Height = 282
                Align = alClient
                Columns = <
                  item
                    Caption = 'Команда'
                    MinWidth = 50
                    Width = 190
                  end
                  item
                    AutoSize = True
                    Caption = 'Клавиши'
                    MinWidth = 50
                  end>
                HideSelection = False
                MultiSelect = True
                ReadOnly = True
                RowSelect = True
                TabOrder = 0
                ViewStyle = vsReport
                OnColumnClick = lvRBRFKeysColumnClick
                OnCustomDrawItem = lvScriptCodeInsCustomDrawItem
                OnDblClick = lvRBRFKeysDblClick
              end
              object pnRBRFKeysButton: TPanel
                Left = 325
                Top = 5
                Width = 67
                Height = 282
                Align = alRight
                BevelOuter = bvNone
                TabOrder = 1
                object bibRBRFKeysAdd: TButton
                  Left = 6
                  Top = 1
                  Width = 60
                  Height = 20
                  Caption = 'Добавить'
                  TabOrder = 0
                  OnClick = bibRBRFKeysAddClick
                end
                object bibRBRFKeysChange: TButton
                  Left = 6
                  Top = 27
                  Width = 60
                  Height = 20
                  Caption = 'Изменить'
                  TabOrder = 1
                  OnClick = bibRBRFKeysChangeClick
                end
                object bibRBRFKeysDelete: TButton
                  Left = 6
                  Top = 53
                  Width = 60
                  Height = 20
                  Caption = 'Удалить'
                  TabOrder = 2
                  OnClick = bibRBRFKeysDeleteClick
                end
                object bibRBRFKeysReset: TButton
                  Left = 6
                  Top = 79
                  Width = 60
                  Height = 20
                  Caption = 'Сброс'
                  TabOrder = 3
                  OnClick = bibRBRFKeysResetClick
                end
              end
            end
          end
        end
      end
    end
    object tsDocs: TTabSheet
      Caption = 'tsDocs'
      ImageIndex = 2
      object pnDocs: TPanel
        Left = 0
        Top = 0
        Width = 405
        Height = 320
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 5
        TabOrder = 0
      end
    end
  end
  object ilShortCut: TImageList
    Left = 252
    Top = 264
    Bitmap = {
      494C010103000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080008080800080808000000000000000000000000000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      800080808000808080000000000000000000000000000000000080808000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000FFFFFF0000FF
      FF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0C00000FF
      FF00C0C0C00000FFFF008080800000000000000000000000000080808000FFFF
      FF0000FFFF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0
      C00000FFFF00808080000000000000000000000000000000000080808000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000FFFFFF00C0C0
      C00000FFFF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0
      C00000FFFF00C0C0C00080808000000000000000000080808000FFFFFF0000FF
      FF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0C00000FF
      FF00C0C0C000000000008080800000000000000000000000000080808000FFFF
      FF00808080008080800080808000FFFFFF00808080008080800080808000FFFF
      FF00808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000FFFFFF0000FF
      FF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0C00000FF
      FF00C0C0C00000FFFF0080808000000000000000000080808000FFFFFF00C0C0
      C00000FFFF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0
      C00080808000000000008080800000000000000000000000000080808000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000FFFFFF00C0C0
      C00000FFFF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0
      C00000FFFF00C0C0C000808080000000000080808000FFFFFF00C0C0C00000FF
      FF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0C00000FF
      FF0000000000808080008080800000000000000000000000000080808000FFFF
      FF0080808000808080008080800080808000FFFFFF008080800080808000FFFF
      FF00808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000FFFFFF0000FF
      FF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0C00000FF
      FF00C0C0C00000FFFF00808080000000000080808000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      800000000000C0C0C0008080800000000000000000000000000080808000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000FFFFFF00C0C0
      C00000FFFF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0
      C00000FFFF00C0C0C00080808000000000008080800080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      80008080800000FFFF008080800000000000000000000000000080808000FFFF
      FF00808080008080800080808000FFFFFF008080800080808000FFFFFF00FFFF
      FF00808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000FFFFFF0000FF
      FF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0C00000FF
      FF00C0C0C00000FFFF0080808000000000000000000080808000FFFFFF00C0C0
      C00000FFFF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0
      C00000FFFF00C0C0C0008080800000000000000000000000000080808000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0080808000000000000000000080808000FFFFFF0000FF
      FF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0C000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF008080800000000000000000000000000080808000FFFF
      FF0080808000808080008080800080808000FFFFFF008080800080808000FFFF
      FF00808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000008080800000FFFF00C0C0
      C00000FFFF00C0C0C00000FFFF00C0C0C00000FFFF0080808000808080008080
      8000808080008080800080808000000000000000000080808000FFFFFF00C0C0
      C00000FFFF00C0C0C00000FFFF00C0C0C000FFFFFF0080808000808080008080
      800080808000808080008080800000000000000000000000000080808000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000008080800000FF
      FF00C0C0C00000FFFF00C0C0C00000FFFF008080800000000000000000000000
      000000000000000000000000000000000000000000000000000080808000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080800000000000000000000000
      000000000000000000000000000000000000000000000000000080808000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000808080008080800080808000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000808080008080800080808000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFFFFFF0000FFFFFFFFE0030000
      C000E000C00300008000C000C00300008000C000C003000080008000C0030000
      80008000C003000080000000C003000080000000C003000080000000C0030000
      80008000C003000080008000C003000080018001C0030000C07FC07FC0030000
      E0FFE0FFC0070000FFFFFFFFFFFF000000000000000000000000000000000000
      000000000000}
  end
  object ilOptions: TImageList
    Left = 209
    Top = 264
    Bitmap = {
      494C010101000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080808000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0C0C00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0C0C00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0C0C00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080000000
      000000000000000000000000000000000000C0C0C000C0C0C000000000000000
      000000000000C0C0C00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080000000
      0000000000000000000080808000000000000000000080808000808080000000
      000000000000C0C0C00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080000000
      00000000000000000000C0C0C000000000000000000080808000000000000000
      000000000000C0C0C00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080000000
      00000080800000FFFF0000000000808080008080800000000000000000000000
      000000000000C0C0C00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080000000
      0000000000000000000000FFFF00008080000000000000000000000000000000
      000000000000C0C0C00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080000000
      0000000000000080800000808000000000000000000000000000000000000000
      000000000000C0C0C00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0C0C00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000000000008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00C001000000000000C001000000000000
      DFF9000000000000DFF9000000000000DF39000000000000DE19000000000000
      DD09000000000000D899000000000000D039000000000000D879000000000000
      D8F9000000000000DFF9000000000000DFE1000000000000DFEB000000000000
      DFE7000000000000C00F00000000000000000000000000000000000000000000
      000000000000}
  end
  object od: TOpenDialog
    Options = [ofEnableSizing]
    Left = 59
    Top = 269
  end
  object sd: TSaveDialog
    Options = [ofEnableSizing]
    Left = 99
    Top = 269
  end
end
