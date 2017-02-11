inherited fmEditRBInterface: TfmEditRBInterface
  Left = 332
  Top = 122
  Width = 620
  Height = 416
  ActiveControl = edName
  BorderStyle = bsSizeable
  Caption = 'fmEditRBInterface'
  Constraints.MinHeight = 400
  Constraints.MinWidth = 580
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    00000000000000000000000000000000EFEFEFEF00000000F444F44E00000000
    EFEFEFEF00000000F444F44E00000000EFEFEFEF00000000F444F44E00000000
    EFEFEFEF00000000FE4444FE00000000EFEFEFEF00000000F44E444E00000000
    EFEFEFEF0000000000000000000000000000000000000000000000000000FFFF
    0000E0070000E0070000E0070000E0070000E0070000E0070000E0070000E007
    0000E0070000E0070000E0070000E0070000E0070000FFFF0000FFFF0000}
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBut: TPanel
    Top = 347
    Width = 612
    TabOrder = 2
    object imNotFound: TImage [0]
      Left = 386
      Top = 2
      Width = 33
      Height = 33
      Center = True
      Picture.Data = {
        07544269746D617036050000424D360500000000000036040000280000001000
        0000100000000100080000000000000100000000000000000000000100000000
        000000000000000080000080000000808000800000008000800080800000C0C0
        C000C0DCC000F0CAA6000020400000206000002080000020A0000020C0000020
        E00000400000004020000040400000406000004080000040A0000040C0000040
        E00000600000006020000060400000606000006080000060A0000060C0000060
        E00000800000008020000080400000806000008080000080A0000080C0000080
        E00000A0000000A0200000A0400000A0600000A0800000A0A00000A0C00000A0
        E00000C0000000C0200000C0400000C0600000C0800000C0A00000C0C00000C0
        E00000E0000000E0200000E0400000E0600000E0800000E0A00000E0C00000E0
        E00040000000400020004000400040006000400080004000A0004000C0004000
        E00040200000402020004020400040206000402080004020A0004020C0004020
        E00040400000404020004040400040406000404080004040A0004040C0004040
        E00040600000406020004060400040606000406080004060A0004060C0004060
        E00040800000408020004080400040806000408080004080A0004080C0004080
        E00040A0000040A0200040A0400040A0600040A0800040A0A00040A0C00040A0
        E00040C0000040C0200040C0400040C0600040C0800040C0A00040C0C00040C0
        E00040E0000040E0200040E0400040E0600040E0800040E0A00040E0C00040E0
        E00080000000800020008000400080006000800080008000A0008000C0008000
        E00080200000802020008020400080206000802080008020A0008020C0008020
        E00080400000804020008040400080406000804080008040A0008040C0008040
        E00080600000806020008060400080606000806080008060A0008060C0008060
        E00080800000808020008080400080806000808080008080A0008080C0008080
        E00080A0000080A0200080A0400080A0600080A0800080A0A00080A0C00080A0
        E00080C0000080C0200080C0400080C0600080C0800080C0A00080C0C00080C0
        E00080E0000080E0200080E0400080E0600080E0800080E0A00080E0C00080E0
        E000C0000000C0002000C0004000C0006000C0008000C000A000C000C000C000
        E000C0200000C0202000C0204000C0206000C0208000C020A000C020C000C020
        E000C0400000C0402000C0404000C0406000C0408000C040A000C040C000C040
        E000C0600000C0602000C0604000C0606000C0608000C060A000C060C000C060
        E000C0800000C0802000C0804000C0806000C0808000C080A000C080C000C080
        E000C0A00000C0A02000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0
        E000C0C00000C0C02000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0
        A000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
        FF00FDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFD000000000000000000000000
        FDFDFDFD00FFFFFFFFFFFFFFFFFFFF00FDFDFDFD00FFFFFFFF0000FFFFFFFF00
        FDFDFDFD00FFFFFFFF0000FFFFFFFF00FDFDFDFD00FFFFFFFFFFFFFFFFFFFF00
        FDFDFDFD00FFFFFFFF0000FFFFFFFF00FDFDFDFD00FFFFFFFF0000FFFFFFFF00
        FDFDFDFD00FFFFFFFFFF0000FFFFFF00FDFDFDFD00FFFFFFFFFFFF0000FFFF00
        FDFDFDFD00FFFF0000FFFF0000FFFF00FDFDFDFD00FFFF000000000000FFFF00
        FDFDFDFD00FFFFFF00000000FFFFFF00FDFDFDFD00FFFFFFFFFFFFFFFFFFFF00
        FDFDFDFD000000000000000000000000FDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFD
        FDFD}
      Visible = False
    end
    inherited Panel2: TPanel
      Left = 427
      inherited bibOk: TButton
        Top = 8
      end
      inherited bibCancel: TButton
        Top = 8
        OnClick = bibCancelClick
      end
    end
    inherited bibClear: TButton
      Top = 7
      TabOrder = 4
    end
    object Button1: TButton
      Left = 112
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Button1'
      TabOrder = 2
      Visible = False
      OnClick = Button1Click
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 338
  end
  object pnMain: TPanel [2]
    Left = 0
    Top = 0
    Width = 612
    Height = 337
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object pcMain: TPageControl
      Left = 0
      Top = 0
      Width = 612
      Height = 337
      ActivePage = tbsAll
      Align = alClient
      HotTrack = True
      MultiLine = True
      TabOrder = 0
      OnChange = pcMainChange
      object tbsAll: TTabSheet
        Caption = 'Общие'
        object lbName: TLabel
          Left = 51
          Top = 15
          Width = 79
          Height = 13
          Alignment = taRightJustify
          Caption = 'Наименование:'
        end
        object lbHint: TLabel
          Left = 77
          Top = 41
          Width = 53
          Height = 13
          Alignment = taRightJustify
          Caption = 'Описание:'
        end
        object lbInterpreter: TLabel
          Left = 50
          Top = 162
          Width = 80
          Height = 13
          Alignment = taRightJustify
          Caption = 'Интерпретатор:'
        end
        object lbTypeInterface: TLabel
          Left = 44
          Top = 95
          Width = 86
          Height = 13
          Alignment = taRightJustify
          Caption = 'Тип интерфейса:'
        end
        object lbPriority: TLabel
          Left = 8
          Top = 188
          Width = 122
          Height = 13
          Alignment = taRightJustify
          Caption = 'Приоритет выполнения:'
        end
        object edName: TEdit
          Left = 139
          Top = 12
          Width = 296
          Height = 21
          TabOrder = 0
          OnChange = edNameChange
        end
        object meHint: TMemo
          Left = 139
          Top = 38
          Width = 296
          Height = 49
          TabOrder = 1
          OnChange = meHintChange
        end
        object cmbInterpreter: TComboBox
          Left = 139
          Top = 159
          Width = 298
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 5
          OnChange = cmbInterpreterChange
        end
        object cmbTypeInterface: TComboBox
          Left = 139
          Top = 92
          Width = 159
          Height = 19
          Style = csOwnerDrawFixed
          ItemHeight = 13
          TabOrder = 2
          OnChange = cmbTypeInterfaceChange
          OnDrawItem = cmbTypeInterfaceDrawItem
        end
        object chbChangeFlag: TCheckBox
          Left = 139
          Top = 120
          Width = 271
          Height = 17
          Caption = 'Заменять, если уже такой существует'
          TabOrder = 3
        end
        object chbAutoRun: TCheckBox
          Left = 139
          Top = 138
          Width = 271
          Height = 17
          Caption = 'Запускать при загрузке программы'
          TabOrder = 4
        end
        object edPriority: TEdit
          Left = 139
          Top = 185
          Width = 46
          Height = 21
          ReadOnly = True
          TabOrder = 6
          Text = '1'
          OnChange = cmbInterpreterChange
        end
        object udPriority: TUpDown
          Left = 185
          Top = 185
          Width = 15
          Height = 21
          Associate = edPriority
          Min = 1
          Position = 1
          TabOrder = 7
          Wrap = False
        end
        object bibLoadInterface: TButton
          Left = 5
          Top = 278
          Width = 75
          Height = 25
          Anchors = [akLeft, akBottom]
          Caption = 'Загрузить'
          TabOrder = 8
          OnClick = bibLoadInterfaceClick
        end
        object bibSaveINterface: TButton
          Left = 88
          Top = 278
          Width = 75
          Height = 25
          Anchors = [akLeft, akBottom]
          Caption = 'Сохранить'
          TabOrder = 9
          OnClick = bibSaveINterfaceClick
        end
      end
      object tbsScript: TTabSheet
        Caption = 'Скрипт'
        ImageIndex = 1
        object ctrlBarScript: TControlBar
          Left = 0
          Top = 0
          Width = 604
          Height = 26
          Align = alTop
          AutoSize = True
          BevelEdges = []
          BevelInner = bvNone
          BevelOuter = bvNone
          BevelKind = bkNone
          DockSite = False
          TabOrder = 0
          OnBandPaint = ctrlBarScriptBandPaint
          object tlBarScript: TToolBar
            Left = 11
            Top = 2
            Width = 590
            Height = 22
            AutoSize = True
            Caption = 'tlbOle'
            EdgeBorders = []
            EdgeInner = esNone
            EdgeOuter = esNone
            Flat = True
            Images = imL
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            object tlbNewScript: TToolButton
              Left = 0
              Top = 0
              Hint = 'Новый скрипт'
              Caption = 'Новый'
              DropdownMenu = pmCodeTemplate
              ImageIndex = 0
              Style = tbsDropDown
              OnClick = tlbNewScriptClick
            end
            object tlbOpenScript: TToolButton
              Left = 36
              Top = 0
              Hint = 'Открыть скрипт'
              Caption = 'Открыть'
              ImageIndex = 1
              OnClick = tlbOpenScriptClick
            end
            object tlbSaveScript: TToolButton
              Left = 59
              Top = 0
              Hint = 'Сохранить скрипт как'
              Caption = 'Сохранить как'
              ImageIndex = 2
              OnClick = tlbSaveScriptClick
            end
            object tlbSaveToBaseScript: TToolButton
              Left = 82
              Top = 0
              Hint = 'Сохранить скрипт в базу'
              Caption = 'Сохранить скрипт в базу'
              ImageIndex = 31
              OnClick = tlbSaveToBaseScriptClick
            end
            object ToolButton2: TToolButton
              Left = 105
              Top = 0
              Width = 8
              Caption = 'ToolButton2'
              ImageIndex = 3
              Style = tbsSeparator
            end
            object tlbUndoScript: TToolButton
              Left = 113
              Top = 0
              Hint = 'Отменить'
              Caption = 'Отменить'
              ImageIndex = 14
              OnClick = tlbUndoScriptClick
            end
            object tlbRedoScript: TToolButton
              Left = 136
              Top = 0
              Hint = 'Повторить'
              Caption = 'Повторить'
              Enabled = False
              ImageIndex = 15
              OnClick = tlbRedoScriptClick
            end
            object ToolButton6: TToolButton
              Left = 159
              Top = 0
              Width = 8
              Caption = 'ToolButton6'
              ImageIndex = 10
              Style = tbsSeparator
            end
            object tlbCutScript: TToolButton
              Left = 167
              Top = 0
              Hint = 'Вырезать'
              Caption = 'Вырезать'
              ImageIndex = 10
              OnClick = tlbCutScriptClick
            end
            object tlbCopyScript: TToolButton
              Left = 190
              Top = 0
              Hint = 'Копировать'
              Caption = 'Копировать'
              ImageIndex = 11
              OnClick = tlbCopyScriptClick
            end
            object tlbPasteScript: TToolButton
              Left = 213
              Top = 0
              Hint = 'Вставить'
              Caption = 'Вставить'
              ImageIndex = 12
              OnClick = tlbPasteScriptClick
            end
            object tlbDeleteScript: TToolButton
              Left = 236
              Top = 0
              Hint = 'Удалить'
              Caption = 'Удалить'
              ImageIndex = 13
              OnClick = tlbDeleteScriptClick
            end
            object ToolButton5: TToolButton
              Left = 259
              Top = 0
              Width = 8
              Caption = 'ToolButton5'
              ImageIndex = 10
              Style = tbsSeparator
            end
            object tlbRunScript: TToolButton
              Left = 267
              Top = 0
              Hint = 'Выполнить скрипт'
              Caption = 'Выполнить'
              ImageIndex = 3
              OnClick = tlbRunScriptClick
            end
            object tlbStopScript: TToolButton
              Left = 290
              Top = 0
              Hint = 'Остановить скрипт'
              Caption = 'Остановить скрипт'
              Enabled = False
              ImageIndex = 4
              Visible = False
              OnClick = tlbStopScriptClick
            end
            object tlbResetScript: TToolButton
              Left = 313
              Top = 0
              Hint = 'Прервать скрипт'
              Caption = 'Прервать скрипт'
              Enabled = False
              ImageIndex = 5
              OnClick = tlbResetScriptClick
            end
            object tlbCompileScript: TToolButton
              Left = 336
              Top = 0
              Hint = 'Компилировать'
              Caption = 'Компилировать'
              Enabled = False
              ImageIndex = 16
              Visible = False
              OnClick = tlbCompileScriptClick
            end
            object ToolButton3: TToolButton
              Left = 359
              Top = 0
              Width = 8
              Caption = 'ToolButton3'
              ImageIndex = 6
              Style = tbsSeparator
            end
            object tlbFindScript: TToolButton
              Left = 367
              Top = 0
              Hint = 'Найти'
              Caption = 'Найти'
              ImageIndex = 6
              OnClick = tlbFindScriptClick
            end
            object tlbReplaceScript: TToolButton
              Left = 390
              Top = 0
              Hint = 'Заменить'
              Caption = 'Заменить'
              ImageIndex = 7
              OnClick = tlbReplaceScriptClick
            end
            object tlbFindAgainScript: TToolButton
              Left = 413
              Top = 0
              Hint = 'Найти далее'
              Caption = 'Найти далее'
              ImageIndex = 8
              OnClick = tlbFindAgainScriptClick
            end
            object ToolButton4: TToolButton
              Left = 436
              Top = 0
              Width = 8
              Caption = 'ToolButton4'
              ImageIndex = 9
              Style = tbsSeparator
            end
            object tlbGotoLineScript: TToolButton
              Left = 444
              Top = 0
              Hint = 'Перейти к линии'
              Caption = 'Перейти к линии'
              ImageIndex = 9
              OnClick = tlbGotoLineScriptClick
            end
            object ToolButton7: TToolButton
              Left = 467
              Top = 0
              Width = 8
              Caption = 'ToolButton7'
              ImageIndex = 12
              Style = tbsSeparator
            end
            object tlbSetBookMarkScript: TToolButton
              Left = 475
              Top = 0
              Hint = 'Установить закладку'
              Caption = 'Установить закладку'
              DropdownMenu = pmSetBookMark
              ImageIndex = 21
            end
            object tlbGotoBookMarkScript: TToolButton
              Left = 498
              Top = 0
              Hint = 'Перейти к закладке'
              Caption = 'Перейти к закладке'
              DropdownMenu = pmGotoBookMark
              ImageIndex = 22
            end
            object ToolButton9: TToolButton
              Left = 521
              Top = 0
              Width = 8
              Caption = 'ToolButton9'
              ImageIndex = 19
              Style = tbsSeparator
            end
            object tlbWathcScript: TToolButton
              Left = 529
              Top = 0
              Hint = 'Просмотр'
              Caption = 'Просмотр'
              Enabled = False
              ImageIndex = 17
              Visible = False
            end
            object ToolButton8: TToolButton
              Left = 552
              Top = 0
              Width = 8
              Caption = 'ToolButton8'
              ImageIndex = 18
              Style = tbsSeparator
              Visible = False
            end
            object tlbOptionScript: TToolButton
              Left = 560
              Top = 0
              Hint = 'Настройка'
              Caption = 'Настройка'
              ImageIndex = 18
              OnClick = tlbOptionScriptClick
            end
          end
        end
        object stbarScript: TStatusBar
          Left = 0
          Top = 290
          Width = 604
          Height = 19
          Panels = <
            item
              Alignment = taCenter
              Width = 100
            end
            item
              Width = 50
            end>
          SimplePanel = False
        end
        object pnScripts: TPanel
          Left = 0
          Top = 26
          Width = 604
          Height = 264
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 2
          TabOrder = 2
        end
      end
      object tbsForms: TTabSheet
        Caption = 'Формы'
        ImageIndex = 2
        object imDefaultComp: TImage
          Left = 16
          Top = 224
          Width = 33
          Height = 33
          Center = True
          Picture.Data = {
            07544269746D617096010000424D960100000000000076000000280000001800
            0000180000000100040000000000200100000000000000000000100000000000
            0000000000000000800000800000008080008000000080008000808000008080
            8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
            FF00888888888888888888888888888888888888888888888888888888888888
            8888888888888888888888888888888888888888888888888008888888888888
            888888880FF0888888888888888888880FF088888888888888808880FF088888
            8888888888800880FF088888888888888880F00FF0888888888888888880FFFF
            F0888888888888888880FFFFF0000888888888888880FFFFFFF0888888888888
            8880FFFFFF088888888888888880FFFFF0888888888888888880FFFF08888888
            888888888880FFF088888888888888888880FF0888888888888888888880F088
            8888888888888888888008888888888888888888888888888888888888888888
            8888888888888888888888888888888888888888888888888888888888888888
            8888}
          Visible = False
        end
        object ctrlBarForms: TControlBar
          Left = 0
          Top = 0
          Width = 604
          Height = 52
          Align = alTop
          AutoSize = True
          BevelEdges = []
          BevelInner = bvNone
          BevelOuter = bvNone
          BevelKind = bkNone
          DockSite = False
          TabOrder = 0
          OnBandPaint = ctrlBarScriptBandPaint
          OnResize = ctrlBarFormsResize
          object tlBarForms1: TToolBar
            Left = 11
            Top = 2
            Width = 233
            Height = 22
            AutoSize = True
            EdgeBorders = []
            Flat = True
            Images = imL
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            object tlbNewForms: TToolButton
              Tag = 1
              Left = 0
              Top = 0
              Hint = 'Новая форма'
              Caption = 'Новая форма'
              DropdownMenu = pmFormTemplate
              ImageIndex = 19
              Style = tbsDropDown
              OnClick = tlbNewFormsClick
            end
            object tlbOpenForms: TToolButton
              Tag = 2
              Left = 36
              Top = 0
              Hint = 'Открыть форму'
              Caption = 'Открыть'
              ImageIndex = 1
              OnClick = tlbOpenFormsClick
            end
            object tlbSaveForms: TToolButton
              Tag = 3
              Left = 59
              Top = 0
              Hint = 'Сохранить форму как'
              Caption = 'Сохранить как'
              ImageIndex = 2
              OnClick = tlbSaveFormsClick
            end
            object tlbSaveTobaseForms: TToolButton
              Left = 82
              Top = 0
              Hint = 'Сохранить формы в базу'
              Caption = 'Сохранить формы в базу'
              ImageIndex = 31
              OnClick = tlbSaveTobaseFormsClick
            end
            object ToolButton11: TToolButton
              Left = 105
              Top = 0
              Width = 8
              Caption = 'ToolButton11'
              ImageIndex = 26
              Style = tbsSeparator
            end
            object tlbCutForms: TToolButton
              Tag = 4
              Left = 113
              Top = 0
              Hint = 'Вырезать компоненты'
              Caption = 'Вырезать'
              ImageIndex = 10
              OnClick = tlbCutFormsClick
            end
            object tlbCopyForms: TToolButton
              Tag = 5
              Left = 136
              Top = 0
              Hint = 'Копировать компоненты'
              Caption = 'Копировать'
              ImageIndex = 11
              OnClick = tlbCopyFormsClick
            end
            object tlbPasteForms: TToolButton
              Tag = 6
              Left = 159
              Top = 0
              Hint = 'Вставить компоненты'
              Caption = 'Вставить'
              ImageIndex = 12
              OnClick = tlbPasteFormsClick
            end
            object tlbDeleteForms: TToolButton
              Tag = 7
              Left = 182
              Top = 0
              Hint = 'Удалить компоненты'
              Caption = 'Удалить'
              ImageIndex = 13
              OnClick = tlbDeleteFormsClick
            end
            object tlbFormsSelectAll: TToolButton
              Tag = 8
              Left = 205
              Top = 0
              Hint = 'Выделить все компоненты'
              Caption = 'Выделить все'
              ImageIndex = 30
              OnClick = tlbFormsSelectAllClick
            end
          end
          object pnComponents: TPanel
            Left = 259
            Top = 2
            Width = 312
            Height = 48
            BevelOuter = bvNone
            BiDiMode = bdLeftToRight
            Caption = 'Библиотеки с компонентами не найдены'
            ParentBiDiMode = False
            TabOrder = 1
            OnResize = pnComponentsResize
          end
          object tlBarForms2: TToolBar
            Left = 11
            Top = 28
            Width = 208
            Height = 22
            AutoSize = True
            EdgeBorders = []
            Flat = True
            Images = imL
            ParentShowHint = False
            ShowHint = True
            TabOrder = 2
            object tlbAlignToGrid: TToolButton
              Tag = 9
              Left = 0
              Top = 0
              Hint = 'Выравнивание по сетке'
              Caption = 'По сетке'
              ImageIndex = 28
              OnClick = tlbAlignToGridClick
            end
            object tlbBringToFront: TToolButton
              Tag = 10
              Left = 23
              Top = 0
              Hint = 'Переместить на верх'
              Caption = 'Вперед'
              ImageIndex = 27
              OnClick = tlbBringToFrontClick
            end
            object tlbSendToBack: TToolButton
              Tag = 11
              Left = 46
              Top = 0
              Hint = 'Переместить назад'
              Caption = 'Назад'
              ImageIndex = 26
              OnClick = tlbSendToBackClick
            end
            object ToolButton10: TToolButton
              Left = 69
              Top = 0
              Width = 8
              Caption = 'ToolButton10'
              ImageIndex = 19
              Style = tbsSeparator
            end
            object tlbLocks: TToolButton
              Left = 77
              Top = 0
              Hint = 'Блокировки'
              Caption = 'Блокировки'
              DropdownMenu = pmLocks
              ImageIndex = 29
            end
            object ToolButton12: TToolButton
              Left = 100
              Top = 0
              Width = 8
              Caption = 'ToolButton12'
              ImageIndex = 30
              Style = tbsSeparator
            end
            object tlbObjInsp: TToolButton
              Tag = 18
              Left = 108
              Top = 0
              Hint = 'Инспектор объектов'
              Caption = 'Инспектор объектов'
              ImageIndex = 23
              OnClick = tlbObjInspClick
            end
            object tlbAlignPallete: TToolButton
              Tag = 19
              Left = 131
              Top = 0
              Hint = 'Панель выравнивания'
              Caption = 'Панель выравнивания'
              ImageIndex = 24
              OnClick = tlbAlignPalleteClick
            end
            object tlbTabOrder: TToolButton
              Tag = 20
              Left = 154
              Top = 0
              Hint = 'Порядок перехода'
              Caption = 'Порядок перехода'
              ImageIndex = 25
              OnClick = tlbTabOrderClick
            end
            object ToolButton13: TToolButton
              Left = 177
              Top = 0
              Width = 8
              Caption = 'ToolButton13'
              ImageIndex = 27
              Style = tbsSeparator
            end
            object tlbOptionForms: TToolButton
              Tag = 21
              Left = 185
              Top = 0
              Hint = 'Настройка'
              Caption = 'Настройка'
              ImageIndex = 18
              OnClick = tlbOptionFormsClick
            end
          end
        end
        object pnDesignScrollBox: TPanel
          Left = 0
          Top = 52
          Width = 604
          Height = 257
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 2
          Caption = 'pn'
          TabOrder = 1
          object splFormsLeft: TSplitter
            Left = 2
            Top = 2
            Width = 3
            Height = 253
            Cursor = crSizeWE
            MinSize = 200
            Visible = False
            OnMoved = splFormsLeftMoved
          end
          object splFormsRigth: TSplitter
            Left = 599
            Top = 2
            Width = 3
            Height = 253
            Cursor = crSizeWE
            Align = alRight
            MinSize = 200
            Visible = False
            OnMoved = splFormsRigthMoved
          end
          object pnFormsLeftDock: TPanel
            Left = 5
            Top = 2
            Width = 0
            Height = 253
            Align = alLeft
            BevelOuter = bvNone
            DockSite = True
            TabOrder = 0
            OnDockDrop = pnFormsLeftDockDockDrop
            OnDockOver = pnFormsLeftDockDockOver
            OnGetSiteInfo = pnFormsLeftDockGetSiteInfo
            OnResize = pnFormsLeftDockResize
            OnUnDock = pnFormsLeftDockUnDock
          end
          object pnFormsRigthDock: TPanel
            Left = 599
            Top = 2
            Width = 0
            Height = 253
            Align = alRight
            BevelOuter = bvNone
            DockSite = True
            TabOrder = 1
            OnDockDrop = pnFormsLeftDockDockDrop
            OnDockOver = pnFormsLeftDockDockOver
            OnGetSiteInfo = pnFormsLeftDockGetSiteInfo
            OnResize = pnFormsLeftDockResize
            OnUnDock = pnFormsLeftDockUnDock
          end
        end
      end
      object tbsDocs: TTabSheet
        Caption = 'Документы'
        ImageIndex = 3
        object ctrlBarOle: TControlBar
          Left = 0
          Top = 0
          Width = 604
          Height = 26
          Align = alTop
          AutoSize = True
          BevelInner = bvNone
          BevelOuter = bvNone
          DockSite = False
          TabOrder = 0
          OnBandPaint = ctrlBarScriptBandPaint
          object tlBarOle: TToolBar
            Left = 11
            Top = 2
            Width = 126
            Height = 22
            AutoSize = True
            Caption = 'tlBarOle'
            EdgeBorders = []
            Flat = True
            Images = imL
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            object tlbOleNew: TToolButton
              Tag = 1
              Left = 0
              Top = 0
              Hint = 'Новый документ'
              Caption = 'Новый документ'
              ImageIndex = 0
              OnClick = tlbOleNewClick
            end
            object tlbOleOpen: TToolButton
              Tag = 2
              Left = 23
              Top = 0
              Hint = 'Открыть документ'
              Caption = 'Открыть документ'
              ImageIndex = 1
              OnClick = tlbOleOpenClick
            end
            object tlbOleSave: TToolButton
              Tag = 3
              Left = 46
              Top = 0
              Hint = 'Сохранить документ'
              Caption = 'Сохранить как'
              ImageIndex = 2
              OnClick = tlbOleSaveClick
            end
            object tlbSaveToBaseDocuments: TToolButton
              Left = 69
              Top = 0
              Caption = 'Сохранить документы в базу'
              ImageIndex = 31
              OnClick = tlbSaveToBaseDocumentsClick
            end
            object ToolButton1: TToolButton
              Left = 92
              Top = 0
              Width = 8
              Caption = 'ToolButton1'
              ImageIndex = 4
              Style = tbsSeparator
            end
            object tlbOptionDocs: TToolButton
              Left = 100
              Top = 0
              Caption = 'Настройка'
              ImageIndex = 18
              OnClick = tlbOptionDocsClick
            end
          end
        end
        object pnOle: TPanel
          Left = 0
          Top = 26
          Width = 604
          Height = 283
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 2
          TabOrder = 1
        end
      end
    end
  end
  inherited IBTran: TIBTransaction
    Left = 472
    Top = 208
  end
  object pmScript: TPopupMenu
    AutoHotkeys = maManual
    Images = imL
    OnPopup = pmScriptPopup
    Left = 48
    Top = 104
    object sadgafdg: TMenuItem
      Caption = 'dtsyutdyu'
    end
  end
  object OD: TOpenPictureDialog
    Filter = 'Bitmaps (*.bmp)|*.bmp|All Files (*.*)|*.*'
    Options = [ofEnableSizing]
    Left = 456
    Top = 96
  end
  object SD: TSavePictureDialog
    Filter = 'Bitmaps (*.bmp)|*.bmp|All Files (*.*)|*.*'
    Options = [ofEnableSizing]
    Left = 488
    Top = 96
  end
  object odAll: TOpenDialog
    Filter = 'All Files (*.*)|*.*'
    Options = [ofEnableSizing]
    Left = 520
    Top = 96
  end
  object sdAll: TSaveDialog
    Options = [ofEnableSizing]
    Left = 552
    Top = 96
  end
  object imL: TImageList
    Left = 472
    Top = 160
    Bitmap = {
      494C010120002200040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000009000000001002000000000000090
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
      0000000000000000000000000000000000008080800000000000000000000000
      0000000000008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000808080000000000000000000FFFFFF0000FFFF00FFFF
      FF00FFFFFF000000000000000000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000080
      8000008080000000000000000000C0C0C00000FFFF0000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000808080008080800080808000808080008080
      8000808080000000000000000000000000000000000000000000000000000080
      800000808000000000000000000000FFFF00C0C0C000FFFFFF0000FFFF00FFFF
      FF00FFFFFF00FFFFFF00C0C0C000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400000000000000
      0000000000008484840000000000000000000000000000000000000000000000
      0000848484000000000084848400000000000000000000000000000000000000
      0000000000000000000080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00808080000000000000000000000000000000000000000000000000000080
      8000008080000000000000000000C0C0C00000FFFF0000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000848484000000000000FFFF0000FF
      FF0000FFFF000000000000000000000000000000000000000000000000000000
      00000000000000FFFF0000000000000000000000000000000000000000000000
      0000808080008080800080808000808080008080800080808000808080008080
      8000808080000000000000000000000000000000000000000000000000000080
      800000808000000000000000000000FFFF00C0C0C00000000000000000000000
      000000000000C0C0C00000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000FFFF000000
      000000FFFF000000000000000000000000000000000000000000000000000000
      00000000000000FFFF0000000000848484000000000000000000000000000000
      000080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00808080000000000000000000000000000000000000000000000000000080
      80000080800000808000000000000000000000000000FFFFFF0000FFFF00FFFF
      FF0000FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000FFFF000000
      000000FFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00000000000000000000000000000000008080
      80008080800080808000808080008080800080808000FFFFFF00FFFFFF008080
      8000808080000000000000000000000000000000000000000000000000000080
      800000808000000000000000000000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000FFFF000000
      000000FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000848484000000000000000000000000008080
      8000FFFFFF00FFFFFF00FFFFFF00FFFFFF0080808000FFFFFF0080808000FFFF
      FF00808080000000000000000000000000000000000000000000000000000080
      80000000000000000000808080000000000000000000FFFFFF0000FFFF00FFFF
      FF0000FFFF000000000000808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484840000000000FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000FFFFFF00FFFFFF00FFFFFF00FFFFFF008080800080808000FFFFFF00FFFF
      FF00808080000000000000000000000000000000000000000000000000000080
      8000000000000000000000000000000000008080800000000000000000000000
      0000000000000000000000808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400000000000000
      0000000000008484840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000FFFFFF00FFFFFF00FFFFFF00FFFFFF0080808000FFFFFF00FFFFFF00FFFF
      FF00808080000000000000000000000000000000000000000000000000000080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000808000000000000000000000000000000000000000
      0000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000FFFFFF00FFFFFF00FFFFFF00FFFFFF008080800080808000808080008080
      8000808080000000000000000000000000000000000000000000000000000080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000808000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000808080008080800080808000808080008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000808000000000000000000000000000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000000000000000
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
      0000848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C60000000000C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C60000000000000000000000000000000000000000000000
      000000000000FFFFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FF
      FF00C6C6C60000FFFF0000000000000000000000000000000000000000008484
      8400FFFFFF00C6C6C600FFFFFF00C6C6C600FFFFFF00C6C6C600FFFFFF000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C60000000000C6C6C60000000000C6C6
      C60000000000C6C6C60000000000000000000000000000000000000000000000
      000000000000FFFFFF0000FFFF00C6C6C60000FFFF0000000000000000000000
      000000FFFF00C6C6C60000000000000000000000000000000000000000008484
      8400C6C6C600FFFFFF00C6C6C600FFFFFF00C6C6C600FFFFFF00C6C6C6000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C6C6
      C600000000000000000000000000C6C6C60000000000C6C6C60000000000C6C6
      C60000000000C6C6C60000000000000000000000000000000000848484000000
      000000000000FFFFFF00C6C6C60000FFFF00C6C6C60000FFFF000000000000FF
      FF00C6C6C60000FFFF0000000000000000008484840000000000000000008484
      8400FFFFFF00C6C6C600FFFFFF00C6C6C600FFFFFF00C6C6C600FFFFFF000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF0000000000848484000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C6C6
      C600C6C6C60000000000C6C6C600C6C6C60000000000C6C6C60000000000C6C6
      C60000000000C6C6C6000000000000000000000000000000000000000000FFFF
      FF0000000000FFFFFF0000FFFF00C6C6C60000FFFF00C6C6C60000000000C6C6
      C60000FFFF00C6C6C600000000000000000084848400FFFFFF00FFFF00008484
      8400C6C6C600FFFFFF00C6C6C600FFFFFF00C6C6C600FFFFFF00C6C6C6000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF00000000000000FF000000000084848400FFFFFF00FFFF0000FFFFFF00FFFF
      0000FFFFFF00FFFF0000FFFFFF0000000000000000000000000000000000C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C60000000000C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C6000000000000000000000000000000000000000000FFFF
      FF0000000000FFFFFF00C6C6C60000FFFF00C6C6C600000000000000000000FF
      FF00C6C6C60000FFFF00000000000000000084848400FFFF0000FFFFFF008484
      8400FFFFFF00C6C6C600FFFFFF00C6C6C600FFFFFF00C6C6C600FFFFFF000000
      000000000000000000000000000000000000000000000000FF00000000000000
      000000000000000000000000000084848400FFFF000000000000000000000000
      00000000000000000000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000848484000000000000000000FFFF
      FF0000000000FFFFFF0000FFFF00C6C6C600FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000084848400FFFFFF00FFFF00008484
      8400C6C6C600FFFFFF00C6C6C600FFFFFF000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF00000000000000
      000084848400000000000000000084848400FFFFFF00FFFF0000FFFFFF00FFFF
      0000FFFFFF00FFFF0000FFFFFF0000000000000000000000000000000000C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C60000000000C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600000000000000000000000000FFFFFF0000000000FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      00000000000000000000848484000000000084848400FFFF0000FFFFFF008484
      8400FFFFFF00C6C6C600FFFFFF00C6C6C60000000000C6C6C600000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084848400FFFFFF00C6C6C60084848400FFFF000000000000000000000000
      00000000000000000000FFFF000000000000000000000000000000000000C6C6
      C600C6C6C60000000000C6C6C600C6C6C60000000000C6C6C600000000000000
      000000000000C6C6C600000000000000000000000000FFFFFF0000000000FFFF
      FF0000FFFF0000000000000000000000000000FFFF00C6C6C60000FFFF00C6C6
      C6000000000000000000000000000000000084848400FFFFFF00FFFF00008484
      8400C6C6C600FFFFFF00C6C6C600FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084848400C6C6C600FFFFFF0084848400FFFFFF00FFFF0000FFFFFF00FFFF
      0000FFFFFF00FFFF0000FFFFFF0000000000000000000000000000000000C6C6
      C6000000000000000000C6C6C600C6C6C60000000000C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600000000000000000000000000FFFFFF0000000000FFFF
      FF0000FFFF00C6C6C600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000084848400FFFF0000FFFFFF008484
      8400848484008484840084848400848484008484840000000000000000000000
      000000000000000000000000FF00000000000000000000000000000000000000
      000084848400FFFFFF00C6C6C60084848400FFFF0000FFFFFF00FFFF0000FFFF
      FF0000000000000000000000000000000000000000000000000000000000C6C6
      C600C6C6C60000000000C6C6C600C6C6C60000000000C6C6C600000000000000
      000000000000C6C6C600000000000000000000000000FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      00008484840000000000000000000000000084848400FFFFFF00FFFF0000FFFF
      FF00FFFF000000000000FFFFFF00000000000000000000000000000000000000
      000000000000000000000000FF00000000000000000000000000000000000000
      000084848400C6C6C600FFFFFF0084848400FFFFFF00FFFF0000FFFFFF00FFFF
      000000000000C6C6C6000000000000000000000000000000000000000000C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C60000000000C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600000000000000000000000000FFFFFF00C6C6C6000000
      00000000000000000000C6C6C60000FFFF00C6C6C60000FFFF00000000000000
      00000000000000000000000000000000000084848400FFFF0000FFFFFF00FFFF
      0000FFFFFF0000000000000000000000000000000000000000000000FF000000
      00000000FF000000FF000000FF00000000000000000000000000000000000000
      000084848400FFFFFF00C6C6C60084848400FFFF0000FFFFFF00FFFF0000FFFF
      FF00000000000000000000000000000000000000000000000000000000008400
      0000840000008400000084000000840000008400000084000000840000008400
      00008400000084000000000000000000000000000000FFFFFF0000FFFF00C6C6
      C600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000008484840084848400848484008484
      84008484840084848400000000000000000000000000000000000000FF000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      000084848400C6C6C600FFFFFF00848484008484840084848400848484008484
      8400848484000000000000000000000000000000000000000000000000008400
      000084000000840000008400000084000000840000008400000084000000FFFF
      FF0084000000FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000848484000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      000084848400FFFFFF00C6C6C600FFFFFF00C6C6C60000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      000084848400C6C6C600FFFFFF00C6C6C600FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848484008484840084848400848484008484840084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008484840084000000840000008400000084848400000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00848484000000000084848400FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008400000084000000840000008400000084000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF008484840000000000848484000000000000FFFF0000000000848484000000
      000084848400FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      00000000000084000000840000008400000084000000840000000000FF000000
      FF000000FF000000FF0000000000000000000000000000000000FFFFFF00C6C6
      C6000000000000FFFF00848484000000000000FFFF00000000008484840000FF
      FF0000000000C6C6C600FFFFFF00000000000000000000000000000000000000
      0000FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000084000000840000008400000084000000840000000000FF000000
      FF000000FF000000000000000000000000000000000000000000FFFFFF000000
      0000848484008484840000FFFF0000FFFF0000FFFF0000FFFF0000FFFF008484
      84008484840000000000FFFFFF00000000000000000000000000000000000000
      0000FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000848484008400000084000000840000000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000FFFFFF008484
      8400000000000000000000FFFF0084848400000000008484840000FFFF000000
      00000000000084848400FFFFFF00000000000000000000000000000000000000
      0000FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000084848400000000000000000000000000848484000000FF000000
      FF00C6C6C600FFFFFF00C6C6C600000000000000000000000000FFFFFF000000
      000000FFFF0000FFFF0000FFFF0000000000FFFFFF000000000000FFFF0000FF
      FF0000FFFF0000000000FFFFFF00000000000000000000000000000000000000
      0000FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      00008484840000000000FFFFFF00FFFFFF00FFFFFF00000000000000FF000000
      FF00FFFFFF00C6C6C600FFFFFF00000000000000000000000000FFFFFF008484
      8400000000000000000000FFFF0084848400000000008484840000FFFF000000
      00000000000084848400FFFFFF00000000000000000000000000000000000000
      0000FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFF
      FF00C6C6C600FFFFFF00C6C6C600000000000000000000000000FFFFFF00FFFF
      FF00848484008484840000FFFF0000FFFF0000FFFF0000FFFF0000FFFF008484
      840084848400FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000C6C6
      C600FFFFFF00C6C6C600FFFFFF00000000000000000000000000FFFFFF00FFFF
      FF000000000000FFFF00848484000000000000FFFF00000000008484840000FF
      FF0000000000FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000008484
      8400848484008484840084848400848484000000000000000000FFFFFF00FFFF
      FF008484840000000000848484000000000000FFFF0000000000848484000000
      000084848400FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000000000000000FFFFFF00FFFFFF0000000000848484000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00848484000000000084848400FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF00FFFFFF000000000000000000000000000000000084848400000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF00FFFFFF000000
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000084000000
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
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000848484008484840084848400848484000000
      0000848484008484840084848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008484840084848400848484008484840084848400C6C6C600848484008484
      84008484840084848400C6C6C600848484000000000000000000848484000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008484840000000000000000000000000084848400FFFFFF00C6C6C600FFFF
      FF00C6C6C600FFFFFF00C6C6C600FFFFFF00C6C6C600FFFFFF00C6C6C600FFFF
      FF00C6C6C600FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400000000000000000000000000848484008484840084848400848484008484
      8400848484008484840084848400848484000000000000000000000000000000
      840000000000000000000000000000000000000000000000000000000000FFFF
      FF000000000000000000000000000000000084848400FFFFFF00FFFFFF00C6C6
      C600FFFFFF00C6C6C600FFFFFF00C6C6C600FFFFFF00C6C6C600FFFFFF00C6C6
      C600FFFFFF00C6C6C60000000000000000000000000000000000848484000000
      0000000000000000000000000000000000000000000000000000848484000000
      0000000000000000000000000000000000000000000000000000848484000000
      0000848484000000000000000000000000008484840084848400000000000000
      0000000000008484840084848400000000000000000000000000000000000000
      0000000084000000000000000000000000000000000000000000FFFFFF000000
      00000000000000000000000000000000000084848400FFFFFF00C6C6C600FFFF
      FF00C6C6C600FFFFFF00C6C6C600FFFFFF00C6C6C600FFFFFF00C6C6C600FFFF
      FF00C6C6C600FFFFFF00000000000000000000000000000000008484840000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00000000000000
      0000000000000000000000000000000000000000000084848400000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      00000000000000008400000000000000000000000000FFFFFF00000000000000
      00000000000000000000000000000000000084848400FFFFFF00FFFFFF00C6C6
      C600FFFFFF00C6C6C600FFFFFF00C6C6C600FFFFFF00C6C6C600FFFFFF00C6C6
      C600FFFFFF00C6C6C6000000000000000000000000000000000084848400FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      000000000000000000000000840000000000FFFFFF0000000000000000000000
      00000000000000000000000000000000000084848400FFFFFF00C6C6C600FFFF
      FF00C6C6C600FFFFFF00C6C6C600FFFFFF00C6C6C600FFFFFF00C6C6C600FFFF
      FF00C6C6C600FFFFFF00000000000000000084848400000000008484840000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C600FFFFFF00FFFFFF000000000000000000C6C6C600FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000084000000000000000000000000000000
      00000000000000000000000000000000000084848400FFFFFF00FFFFFF00C6C6
      C600FFFFFF00C6C6C600FFFFFF00C6C6C600FFFFFF00C6C6C600FFFFFF00C6C6
      C600FFFFFF00C6C6C60000000000000000008484840000FFFF0084848400FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848484000000000000000000000000000000000084848400000000000000
      0000000000008484840000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00000000000000840000000000000000000000
      00000000000000848400000000000000000084848400FFFFFF00C6C6C600FFFF
      FF00C6C6C600FFFFFF00C6C6C600FFFFFF00C6C6C600FFFFFF00C6C6C600FFFF
      FF00C6C6C600FFFFFF00000000000000000084848400FFFFFF00848484008484
      84008484840000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00000000000000
      0000000000000000000000000000000000000000000084848400000000008484
      8400000000000000000000000000000000000000000000000000000000008484
      8400000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000000000000000000000000000008400000000000000
      00000000000000848400008484000000000084848400FFFFFF00FFFFFF00C6C6
      C600FFFFFF00C6C6C600FFFFFF00C6C6C600FFFFFF00C6C6C600FFFFFF00C6C6
      C600FFFFFF00C6C6C60000000000000000008484840000FFFF0084848400FFFF
      FF0000FFFF008484840084848400848484008484840084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000000000000084
      84000084840000000000000000000000000084848400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000084848400FFFFFF0000FFFF008484
      840084848400FFFFFF0000FFFF00FFFFFF000000000000000000000000000000
      0000000000000000000084848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000084
      8400008484000000000000000000000000008484840084000000840000008400
      0000840000008400000084000000840000008400000084000000840000008400
      00008400000084000000000000000000000084848400848484008484840000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400848484000000
      0000000000000000000000000000000000000000000000000000008484000084
      84000084840000000000000000000000000084848400FFFFFF00840000008400
      000084000000840000008400000084000000840000008400000084000000FFFF
      FF0084000000FFFFFF00000000000000000084848400FFFFFF0000FFFF008484
      8400848484008484840084848400848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848484000000
      0000000000000000000000000000000000000084840000848400000000000000
      0000000000000000000000000000000000008484840084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484008484840084848400000000000000000084848400848484000000
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
      0000000000000000000084000000840000008400000084000000840000008400
      0000840000008400000084000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400008484008484
      8400008484008484840084000000FFFFFF000000000000000000000000000000
      00000000000000000000FFFFFF00840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000848400848484000084
      8400848484000084840084000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400008484008484
      8400008484008484840084000000FFFFFF00000000000000000000000000FFFF
      FF00840000008400000084000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000840000000000000000000000000000000000000000000000000000008400
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000848400848484000084
      8400848484000084840084000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0084000000FFFFFF0084000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000840000008400
      0000840000008400000084000000000000000000000000000000000000000000
      0000840000000000000000000000000000000000000000000000000000008400
      0000000000000000000000000000000000000000000084000000840000008400
      0000840000008400000000000000000000000000000084848400008484008484
      8400008484008484840084000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00840000008400000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000840000008400
      0000840000008400000000000000000000000000000000000000000000000000
      0000000000008400000000000000000000000000000000000000840000000000
      0000000000000000000000000000000000000000000000000000840000008400
      0000840000008400000000000000000000000000000000848400848484000084
      8400848484000084840084000000840000008400000084000000840000008400
      0000840000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000840000008400
      0000840000000000000000000000000000000000000000000000000000000000
      0000000000008400000000000000000000000000000000000000840000000000
      0000000000000000000000000000000000000000000000000000000000008400
      0000840000008400000000000000000000000000000084848400008484008484
      8400008484008484840000848400848484000084840084848400008484008484
      8400008484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000840000008400
      0000000000008400000000000000000000000000000000000000000000000000
      0000000000008400000000000000000000000000000000000000840000000000
      0000000000000000000000000000000000000000000000000000840000000000
      0000840000008400000000000000000000000000000000848400848484000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000840000000000
      0000000000000000000084000000840000000000000000000000000000000000
      0000840000000000000000000000000000000000000000000000000000008400
      0000000000000000000000000000000000008400000084000000000000000000
      0000000000008400000000000000000000000000000084848400848484000000
      0000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600000000008484
      8400008484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400000084000000840000008400
      0000000000000000000000000000000000000000000000000000000000000000
      0000840000008400000084000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000848400848484000084
      84000000000000FFFF00000000000000000000FFFF0000000000848484000084
      8400848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF0000FFFF000000000000000000000000000000
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
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084848400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000008400000084000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084848400FFFFFF0084848400848484008484840084848400848484008484
      84008484840084848400FFFFFF00000000000000000000000000000000000000
      0000840000000000000000000000840000000000000000000000840000008400
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000840000008400000084000000840000008400
      0000840000008400000084000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400000000000000000000000000
      000084848400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000840000000000000000000000840000000000000084000000000000000000
      0000840000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000084000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400000084000000000000000000
      000084848400FFFFFF0084848400848484008484840084848400848484008484
      84008484840084848400FFFFFF00000000000000000000000000000000000000
      0000840000000000000000000000840000000000000084000000000000000000
      0000840000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000084000000FFFFFF0000000000000000000000
      00000000000000000000FFFFFF00840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400000084000000840000000000
      00008484840000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000008400000084000000840000000000000084000000000000000000
      0000840000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000084000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0084000000000000000000000000000000C6C6
      C60000000000000000000000000000000000000000000000000000000000C6C6
      C600000000000000000000000000000000008400000084000000840000000000
      00008484840000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000840000000000000084000000840000008400
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0084000000FFFFFF0000000000000000000000
      00000000000000000000FFFFFF00840000000000000000000000000000000000
      0000000000008484840000000000000000000000000084848400000000000000
      0000000000000000000000000000000000008400000084000000000000000000
      00008484840000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000840000000000000084000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      000000000000000000000000000084000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400000000000000000000000000
      000084848400FFFFFF0084848400848484008484840084848400848484008484
      84008484840084848400FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0084000000FFFFFF000000000000000000FFFF
      FF0084000000840000008400000084000000000000000000000000000000C6C6
      C60000000000000000000000000000000000C6C6C60000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084848400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      000000000000000000000000000084000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0084000000FFFFFF008400000000000000000000000000000000000000C6C6
      C60000000000000000000000000000000000C6C6C60000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084848400FFFFFF0084848400848484008484840084848400FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0084000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00840000008400000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084848400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      000000000000FFFFFF0000000000840000008400000084000000840000008400
      0000840000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084848400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084848400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848484008484840084848400848484008484840084848400848484008484
      8400000000000000000000000000000000000000000000000000000000000000
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
      0000000000000000000000000000000000000000000084848400848484008484
      8400848484000000000000000000000000008484840084848400848484008484
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400000084000000840000008400
      0000848484000000000000000000840000008400000084000000840000008484
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400000084848400840000008400
      0000848484000000000000000000840000008484840084000000840000008484
      840000000000000000000000000000000000C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600000000000000000000000000FFFFFF00000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484840084000000848484008400
      0000848484000000000000000000848484008400000084848400840000008484
      840000000000000000000000000000000000C6C6C60084848400FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C6C6C600000000000000000000000000FFFFFF00000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400000084848400840000008400
      0000848484000000000000000000840000008484840084000000840000008484
      840000000000000000000000000000000000C6C6C6008484840000000000C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600FFFFFF00C6C6C60000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484840084000000848484008400
      0000848484000000000000000000848484008400000084848400840000008484
      840000000000000000000000000000000000C6C6C6008484840000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C6C6
      C600FFFFFF00C6C6C60000000000000000000000000000000000FFFFFF000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400000084848400840000008400
      0000848484000000000000000000840000008484840084000000840000008484
      840000000000000000000000000000000000C6C6C6008484840000000000FFFF
      FF00FFFFFF00FFFFFF00FF000000FF000000FFFFFF00FFFFFF00FFFFFF00C6C6
      C600FFFFFF00C6C6C60000000000000000000000000000000000FFFFFF000000
      00000000000000000000C6C6C6000000000000000000FFFFFF00000000000000
      000000000000000000000000000000000000000000000000000000000000C6C6
      C60000000000000000000000000000000000000000000000000000000000C6C6
      C600000000000000000000000000000000008484840084000000848484008400
      0000848484000000000000000000848484008400000084848400840000008484
      840000000000000000000000000000000000C6C6C6008484840000000000FFFF
      FF00FFFFFF00FF000000FFFFFF00FFFFFF00FF000000FFFFFF00FFFFFF00C6C6
      C600FFFFFF00C6C6C60000000000000000000000000000000000FFFFFF000000
      00000000000000000000C6C6C6000000000000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008484840000000000000000000000000084848400000000000000
      0000000000000000000000000000000000008400000084848400840000008400
      0000848484000000000000000000840000008484840084000000840000008484
      840000000000000000000000000000000000C6C6C6008484840000000000FFFF
      FF00FFFFFF00FF000000FFFFFF00FFFFFF00FF000000FFFFFF00FFFFFF00C6C6
      C600FFFFFF00C6C6C60000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484840084000000848484008400
      0000848484000000000000000000848484008400000084848400840000008484
      840000000000000000000000000000000000C6C6C6008484840000000000FFFF
      FF00FFFFFF00FF000000FFFFFF00FFFFFF00FF000000FFFFFF00FFFFFF00C6C6
      C600FFFFFF00C6C6C6000000000000000000000000000000000000000000FFFF
      FF000000000000000000000000000000000000000000FFFFFF00000000000000
      000000000000000000000000000000000000000000000000000000000000C6C6
      C60000000000000000000000000000000000C6C6C60000000000000000000000
      0000000000000000000000000000000000008400000084848400840000008400
      0000848484000000000000000000840000008484840084000000840000008484
      840000000000000000000000000000000000C6C6C6008484840000000000FFFF
      FF00FFFFFF00FFFFFF00FF000000FF000000FFFFFF00FFFFFF00FFFFFF00C6C6
      C600FFFFFF00C6C6C60000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C6C6
      C60000000000000000000000000000000000C6C6C60000000000000000000000
      0000000000000000000000000000000000008484840084000000848484008400
      0000848484000000000000000000848484008400000084848400840000008484
      840000000000000000000000000000000000C6C6C6008484840000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C6C6
      C600FFFFFF00C6C6C60000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400000084848400840000008400
      0000848484000000000000000000840000008484840084000000840000008484
      840000000000000000000000000000000000C6C6C60084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00C6C6C60000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000848484000000000000000000000000000000
      0000000000000000000000000000000000008484840084000000848484008400
      0000848484000000000000000000848484008400000084848400840000008484
      840000000000000000000000000000000000C6C6C60084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      840084848400C6C6C60000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400000084848400840000008400
      0000000000000000000000000000840000008484840084000000840000000000
      000000000000000000000000000000000000C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C60000000000000000000000000000000000000000000000
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
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000080
      8000008080000080800000808000008080000080800000808000008080000080
      8000000000000000000000000000000000000000000000000000000000000080
      8000008080000000000000000000000000000000000000000000000000000000
      0000000000000000000000808000000000000000000000000000000000000000
      000000FF0000C6C6C60000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000000000000000000000000000000000000000000000FFFF000000
      0000008080000080800000808000008080000080800000808000008080000080
      8000008080000000000000000000000000000000000000000000000000000080
      8000008080000000000000000000000000000000000000000000000000000000
      0000000000000000000000808000000000000000000000000000000000000000
      0000C6C6C60000FF0000C6C6C600000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000FFFFFF0000FF
      FF00000000000080800000808000008080000080800000808000008080000080
      8000008080000080800000000000000000000000000000000000000000000080
      8000008080000000000000000000000000000000000000000000000000000000
      0000000000000000000000808000000000000000000000000000000000000000
      000000FF0000C6C6C60000FF0000C6C6C6000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000000000000000000000000000000000000000000000FFFF00FFFF
      FF0000FFFF000000000000808000008080000080800000808000008080000080
      8000008080000080800000808000000000000000000000000000000000000080
      8000008080000000000000000000000000000000000000000000000000000000
      0000000000000000000000808000000000000000000000000000000000000000
      0000C6C6C60000FF0000C6C6C60000FF0000C6C6C60000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000FFFFFF0000FF
      FF00FFFFFF0000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000080
      8000008080000080800000808000008080000080800000808000008080000080
      8000008080000080800000808000000000000000000000000000000000000000
      000000FF0000C6C6C60000FF0000C6C6C60000FF0000C6C6C600000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000000000000000000000000000000000000000000000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000080
      8000008080000000000000000000000000000000000000000000000000000000
      0000000000000080800000808000000000000000000000000000000000000000
      0000C6C6C60000FF0000C6C6C60000FF0000C6C6C60000FF0000C6C6C6000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000808000000000000000000000000000000000000000
      000000FF0000C6C6C60000FF0000C6C6C60000FF0000C6C6C60000FF0000C6C6
      C60000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000000000000000000000000000000000000000000000FFFF00FFFF
      FF0000FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000808000000000000000000000000000000000000000
      0000C6C6C60000FF0000C6C6C60000FF0000C6C6C60000FF0000C6C6C6000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000808000000000000000000000000000000000000000
      000000FF0000C6C6C60000FF0000C6C6C60000FF0000C6C6C600000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000808000000000000000000000000000000000000000
      0000C6C6C60000FF0000C6C6C60000FF0000C6C6C60000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FF0000C6C6C60000FF0000C6C6C6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C6C6C60000FF0000C6C6C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FF0000C6C6C60000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000900000000100010000000000800400000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFFFFFFFFFFFF03E493FFFF9E79E000
      E493FFFF9E79C000FFFFFFFFFC07C000E49383F1FC07C000E49303F1F007C000
      FFFF0000F007C000E49300008001C000E49300008001C400FFFF03FFE007C700
      E00783FFE007C7F8E007FFFFE007C7F88007FFFFE07FC7F88007FFFF9E79C7F8
      801FFFFF9E79C000801FFFFFFFFFFFFFC001F001E00FFFFFC001F001E00FC3FF
      C001F001E00FE3FFC001C001000FC200C001C001000F8A00C001C001000FBE00
      C0010001000FB000C0010001001FF000C0010007003FF000C0010007007DF000
      C001000700FDF001C001001F01D1F003C001001F03C3F007C001001FFFC7F00F
      C0018FFFFFC3F01FFFFFFFFFFFFFF03F8000FFFFFFFFF83F8000807FFE01F83F
      8000807FFE01F8038000807FFE01F8078000807FFE01F8008000807FFE01F800
      8000807FFE01F00080008040FE01F00080008040FE01F0008000807FF601F000
      80008073F201E01F8000FFF301FFC03F8000FFC000FF83FF8001FFC001FF07FF
      8003FFF3F3FF0FFF8007FFF3F7FF9FFFEDB6FFFFFF24FFFFEAAAFFFFFF24FFFF
      EAAAFE11FFFF0001EDB6F000CFE70001FFFFEE00C7C70001C01FD001E38F0001
      C01F9003F11F0001C019B003F83F00010010B003FC7B00010019A003F8310001
      00198FE7F10000010039FFFF038100010061FFFF07830001007FFFFF07030001
      00FFFFFFC40700019FFFFFFFC61FFFFFFFFFFFFFFFFFFFFFFC00FFFFFFFFFFFF
      8000EFFDFFFFFFFF0000C7FFFFFFFFFF0000C3FBFFFFFFFF0000E3F7FFF7EFFF
      0001F1E7C1F7EF830003F8CFC3FBDFC30003FC1FC7FBDFE30003FE3FCBFBDFD3
      0003FC1FDCF7EF3B0003F8CFFF0FF0FF0003E1E7FFFFFFFF8007C3F3FFFFFFFF
      F87FC7FDFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000FFFFFFFFFE49F000F9FFFFFF
      FE49F000F6CFFE00FFFF7000F6B7FE00FFFF3000F6B7FE00C7C71000F8B78000
      C7C71000FE8F8000C3873000FE3F8000C0077000FF7F8000C007F000FE3F8001
      C007F000FEBF8003C007F000FC9F8007C007F001FDDF807FF39FF003FDDF80FF
      F39FF007FDDF81FFF39FFFFFFFFFFFFFFFFFFFFFFFFFB6E7870FFFFFFFFFB76B
      060FFFFF07C18427060F000307C1B76B060F000307C1CEE7060F00030101FFFF
      060F00030001C7C7060F00030001C7C7060F00030001C387060F00038003C007
      060F0003C107C007060F0003C107C007060F0003E38FC007060F0003E38FC007
      060F0003E38FF39F0E1F0003FFFFF39FFFFFFFFFFFFFFFFFC007800FE000F3FF
      C0078007C018F1FFC0078003C018F0FFC0078001C018F07FC0078000C000F03F
      C0078000C000F01FC007800FC000F00FC007800FC7F8F00FC007800FC7F8F01F
      C007C7F8C7F8F03FC00FFFFCC7F8F07FC01FFFBAC7F8F0FFC03FFFC7C7FAF1FF
      FFFFFFFFC000F3FFFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object pmSetBookMark: TPopupMenu
    Images = imL
    Left = 120
    Top = 104
    object miSetBookMark0: TMenuItem
      Caption = '№ 0'
      Hint = 'Установить закладку № 0'
      OnClick = miSetBookMark9Click
    end
    object miSetBookMark1: TMenuItem
      Tag = 1
      Caption = '№ 1'
      Hint = 'Установить закладку № 1'
      OnClick = miSetBookMark9Click
    end
    object miSetBookMark2: TMenuItem
      Tag = 2
      Caption = '№ 2'
      Hint = 'Установить закладку № 2'
      OnClick = miSetBookMark9Click
    end
    object miSetBookMark3: TMenuItem
      Tag = 3
      Caption = '№ 3'
      Hint = 'Установить закладку № 3'
      OnClick = miSetBookMark9Click
    end
    object miSetBookMark4: TMenuItem
      Tag = 4
      Caption = '№ 4'
      Hint = 'Установить закладку № 4'
      OnClick = miSetBookMark9Click
    end
    object miSetBookMark5: TMenuItem
      Tag = 5
      Caption = '№ 5'
      Hint = 'Установить закладку № 5'
      OnClick = miSetBookMark9Click
    end
    object miSetBookMark6: TMenuItem
      Tag = 6
      Caption = '№ 6'
      Hint = 'Установить закладку № 6'
      OnClick = miSetBookMark9Click
    end
    object miSetBookMark7: TMenuItem
      Tag = 7
      Caption = '№ 7'
      Hint = 'Установить закладку № 7'
      OnClick = miSetBookMark9Click
    end
    object miSetBookMark8: TMenuItem
      Tag = 8
      Caption = '№ 8'
      Hint = 'Установить закладку № 8'
      OnClick = miSetBookMark9Click
    end
    object miSetBookMark9: TMenuItem
      Tag = 9
      Caption = '№ 9'
      Hint = 'Установить закладку № 9'
      OnClick = miSetBookMark9Click
    end
  end
  object pmGotoBookMark: TPopupMenu
    Images = imL
    Left = 192
    Top = 104
    object miGotoBookMark0: TMenuItem
      Caption = '№ 0'
      Hint = 'Перейти к закладке № 0'
      OnClick = miGotoBookMark9Click
    end
    object miGotoBookMark1: TMenuItem
      Tag = 1
      Caption = '№ 1'
      Hint = 'Перейти к закладке № 1'
      OnClick = miGotoBookMark9Click
    end
    object miGotoBookMark2: TMenuItem
      Tag = 2
      Caption = '№ 2'
      Hint = 'Перейти к закладке № 2'
      OnClick = miGotoBookMark9Click
    end
    object miGotoBookMark3: TMenuItem
      Tag = 3
      Caption = '№ 3'
      Hint = 'Перейти к закладке № 3'
      OnClick = miGotoBookMark9Click
    end
    object miGotoBookMark4: TMenuItem
      Tag = 4
      Caption = '№ 4'
      Hint = 'Перейти к закладке № 4'
      OnClick = miGotoBookMark9Click
    end
    object miGotoBookMark5: TMenuItem
      Tag = 5
      Caption = '№ 5'
      Hint = 'Перейти к закладке № 5'
      OnClick = miGotoBookMark9Click
    end
    object miGotoBookMark6: TMenuItem
      Tag = 6
      Caption = '№ 6'
      Hint = 'Перейти к закладке № 6'
      OnClick = miGotoBookMark9Click
    end
    object miGotoBookMark7: TMenuItem
      Tag = 7
      Caption = '№ 7'
      Hint = 'Перейти к закладке № 7'
      OnClick = miGotoBookMark9Click
    end
    object miGotoBookMark8: TMenuItem
      Tag = 8
      Caption = '№ 8'
      Hint = 'Перейти к закладке № 8'
      OnClick = miGotoBookMark9Click
    end
    object miGotoBookMark9: TMenuItem
      Tag = 9
      Caption = '№ 9'
      Hint = 'Перейти к закладке № 9'
      OnClick = miGotoBookMark9Click
    end
  end
  object pmForms: TPopupMenu
    AutoHotkeys = maManual
    Images = imL
    OnPopup = pmFormsPopup
    Left = 56
    Top = 216
  end
  object imlDOI: TImageList
    Left = 504
    Top = 160
    Bitmap = {
      494C010104000900040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
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
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000C0C0C0008080
      8000808080008080800080808000808080008080800080808000808080008080
      80008080800080808000FFFFFF000000000080808000FFFFFF00C0C0C000FFFF
      FF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFF
      FF00C0C0C000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000080808000000000008080800000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000808080008080
      8000808080008080800080808000000000000000000080808000FFFFFF00C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C00080808000FFFFFF000000000080808000FFFFFF00FFFFFF00C0C0
      C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0
      C000FFFFFF00C0C0C00000000000000000000000000000000000000000008080
      800000000000808080000000000000FFFF000000000080808000000000008080
      80000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000
      0000000000000000000080808000000000000000000080808000FFFFFF00C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C00080808000FFFFFF000000000080808000FFFFFF00C0C0C000FFFF
      FF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFF
      FF00C0C0C000FFFFFF0000000000000000000000000000000000C0C0C0000000
      000000FFFF00808080000000000000FFFF00000000008080800000FFFF000000
      0000C0C0C00000000000000000000000000000000000FFFFFF00000000000000
      0000000000000000000000000000FFFFFF00FFFFFF0000000000FFFFFF000000
      0000000000000000000080808000000000000000000080808000FFFFFF00C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C00080808000FFFFFF000000000080808000FFFFFF00FFFFFF00C0C0
      C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0
      C000FFFFFF00C0C0C00000000000000000000000000000000000000000008080
      80008080800000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00808080008080
      80000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000080808000FFFFFF00C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C00080808000FFFFFF000000000080808000FFFFFF00C0C0C000FFFF
      FF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFF
      FF00C0C0C000FFFFFF0000000000000000000000000000000000808080000000
      00000000000000FFFF0080808000000000008080800000FFFF00000000000000
      00008080800000000000000000000000000000000000FFFFFF00000000000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000080808000FFFFFF00C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C00080808000FFFFFF000000000080808000FFFFFF00FFFFFF00C0C0
      C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0
      C000FFFFFF00C0C0C000000000000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF0000000000000000000000000000FFFF0000FFFF0000FF
      FF000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000808080008080
      8000808080008080800080808000000000000000000080808000FFFFFF00C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C00080808000FFFFFF000000000080808000FFFFFF00C0C0C000FFFF
      FF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFF
      FF00C0C0C000FFFFFF0000000000000000000000000000000000808080000000
      00000000000000FFFF0080808000000000008080800000FFFF00000000000000
      00008080800000000000000000000000000000000000FFFFFF00000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000
      0000000000000000000080808000000000000000000080808000FFFFFF00C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C00080808000FFFFFF000000000080808000FFFFFF00FFFFFF00C0C0
      C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0
      C000FFFFFF00C0C0C00000000000000000000000000000000000000000008080
      80008080800000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00808080008080
      80000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000
      0000000000000000000080808000000000000000000080808000FFFFFF00C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C00080808000FFFFFF000000000080808000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      000000FFFF00808080000000000000FFFF00000000008080800000FFFF000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000080808000FFFFFF00C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C00080808000FFFFFF00000000008080800080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000000000000000000000000000000000000000000008080
      800000000000808080000000000000FFFF000000000080808000000000008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000FFFFFF00C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C00080808000FFFFFF000000000080808000FFFFFF00800000008000
      000080000000800000008000000080000000800000008000000080000000FFFF
      FF0080000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000080808000000000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C000FFFFFF00000000008080800080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080008080800080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFC001
      0001FFFF000080010001FC7F000080010001E00F001480010001C00700008001
      0001C007000080010001C007000080010001C107000080010001C00700008001
      0001E00F001480010001E00F000080010001E00F000080010001FC7FFFFF8001
      0001FFFFFFFF8003FFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object pmLocks: TPopupMenu
    Images = imL
    OnPopup = pmLocksPopup
    Left = 128
    Top = 225
    object miLocksNoDelete: TMenuItem
      Tag = 12
      Caption = 'Нельзя удалить'
      Hint = 'Нельзя удалить'
      OnClick = miLocksNoDeleteClick
    end
    object miLocksNoMove: TMenuItem
      Tag = 13
      Caption = 'Нельзя передвигать'
      Hint = 'Нельзя передвигать'
      OnClick = miLocksNoMoveClick
    end
    object miLocksNoSize: TMenuItem
      Tag = 14
      Caption = 'Нельзя изменять размеры'
      Hint = 'Нельзя изменять размеры'
      OnClick = miLocksNoSizeClick
    end
    object miLocksNoInsertIn: TMenuItem
      Tag = 15
      Caption = 'Нельзя вставлять'
      Hint = 'Нельзя вставлять'
      OnClick = miLocksNoInsertInClick
    end
    object miLocksNoCopy: TMenuItem
      Tag = 16
      Caption = 'Нельзя копировать'
      Hint = 'Нельзя копировать'
      OnClick = miLocksNoCopyClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object miLockClear: TMenuItem
      Tag = 17
      Caption = 'Очистить блокировки'
      Hint = 'Очистить блокировки'
      OnClick = miLockClearClick
    end
  end
  object ilTypeInterface: TImageList
    Left = 436
    Top = 160
    Bitmap = {
      494C010108000900040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
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
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C00000000000000000000000000080808000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C00000000000000000000000000080808000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C00000000000000000000000000080808000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF00000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF000000000000000000FFFFFF00FFFFFF000000000000000000FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF0000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF000000000000000000FFFFFF000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF000000000000000000FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF000000000000000000FFFFFF00FFFFFF000000000000000000FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF0000000000FFFFFF000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF000000000000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF000000000000000000FFFFFF00FFFFFF000000000000000000FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF000000000000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF000000000000000000FFFFFF00FFFFFF000000000000000000FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF000000000000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF00000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF000000000000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF000000000000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF000000000000000000FFFFFF00FFFFFF000000000000000000FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000080808000FFFFFF00FFFF
      FF000000000000000000FFFFFF000000000000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000080808000FFFFFF00FFFF
      FF000000000000000000FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000080808000FFFFFF00FFFF
      FF000000000000000000FFFFFF00FFFFFF000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000080808000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFFFF008080
      8000C0C0C000C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFFFF008080
      8000C0C0C000C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF00000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      8000C0C0C000C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF000000000000000000FFFFFF00FFFFFF000000000000000000FFFFFF008080
      8000C0C0C000C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      8000C0C0C0000000000000000000000000000000000080808000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      8000C0C0C0000000000000000000000000000000000080808000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      8000C0C0C0000000000000000000000000000000000080808000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      8000C0C0C0000000000000000000000000000000000080808000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      8000000000000000000000000000000000000000000080808000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      8000000000000000000000000000000000000000000080808000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      8000000000000000000000000000000000000000000080808000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      8000000000000000000000000000000000000000000080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000000000000000000000000000000000000000000080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000000000000000000000000000000000000000000080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000000000000000000000000000000000000000000080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
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
      0000000000000000000000000000000000000000000080808000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C00000000000000000000000000080808000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C00000000000000000000000000080808000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C00000000000000000000000000080808000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF000000000000000000FFFFFF00FFFFFF000000000000000000FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF0000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF000000000000000000FFFFFF00FFFFFF000000000000000000FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF000000000000000000FFFFFF000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF000000000000000000FFFFFF00FFFFFF000000000000000000FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF000000000000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF000000000000000000FFFFFF000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF000000000000000000FFFFFF00000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF000000000000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF0000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF000000
      000000000000FFFFFF0000000000FFFFFF000000000000000000FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF000000000000000000FFFFFF00000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF000000000000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF00000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF000000
      000000000000FFFFFF0000000000FFFFFF000000000000000000FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF00000000000000000000000000FFFFFF000000000000000000FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF0000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF0000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF000000
      000000000000FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF00000000000000000000000000FFFFFF000000000000000000FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF000000000000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF000000000000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF000000
      000000000000FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF000000000000000000FFFFFF00FFFFFF000000000000000000FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF000000000000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF000000000000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF000000
      000000000000FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF000000000000000000FFFFFF00FFFFFF000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000080808000FFFFFF00FFFF
      FF000000000000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000080808000FFFFFF00FFFF
      FF000000000000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000080808000FFFFFF000000
      000000000000FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000080808000FFFFFF00FFFF
      FF000000000000000000FFFFFF00FFFFFF000000000000000000FFFFFF008080
      8000C0C0C000C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF0000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF008080
      8000C0C0C000C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF0000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF008080
      8000C0C0C000C0C0C00000000000000000000000000080808000FFFFFF000000
      000000000000FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF008080
      8000C0C0C000C0C0C00000000000000000000000000080808000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      8000C0C0C0000000000000000000000000000000000080808000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      8000C0C0C0000000000000000000000000000000000080808000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      8000C0C0C0000000000000000000000000000000000080808000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      8000C0C0C0000000000000000000000000000000000080808000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      8000000000000000000000000000000000000000000080808000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      8000000000000000000000000000000000000000000080808000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      8000000000000000000000000000000000000000000080808000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      8000000000000000000000000000000000000000000080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000000000000000000000000000000000000000000080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000000000000000000000000000000000000000000080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000000000000000000000000000000000000000000080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      800000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFFFFFFFFFFFFFF8001800180018001
      8001800180018001800180018001800180018001800180018001800180018001
      8001800180018001800180018001800180018001800180018001800180018001
      8001800180018001800180018001800180018001800180018003800380038003
      8007800780078007800F800F800F800FFFFFFFFFFFFFFFFF8001800180018001
      8001800180018001800180018001800180018001800180018001800180018001
      8001800180018001800180018001800180018001800180018001800180018001
      8001800180018001800180018001800180018001800180018003800380038003
      8007800780078007800F800F800F800F00000000000000000000000000000000
      000000000000}
  end
  object pmCodeTemplate: TPopupMenu
    AutoHotkeys = maManual
    Left = 52
    Top = 154
  end
  object pmFormTemplate: TPopupMenu
    AutoHotkeys = maManual
    Left = 52
    Top = 260
  end
end
