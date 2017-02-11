object fmDocMainGrid: TfmDocMainGrid
  Left = 376
  Top = 174
  Width = 420
  Height = 350
  ActiveControl = edNumber
  Caption = 'Документ'
  Color = clBtnFace
  Constraints.MinHeight = 340
  Constraints.MinWidth = 420
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000000000000000000078888888888880007FFFFFFFFFFF80007FF
    000FFFFFF80007FF00F0FFFFF80007FF00FF0FFFF80007FF00FF0FFFF80007FF
    00FF0FFFF80007FF00FF0FFFF80007FF00FF0FFFF80007FF00F0FFF0000007FF
    000FFFF7880007FFFFFFFFF7800007FFFFFFFFF700000777777777770000FFFF
    0000800100008001000080010000800100008001000080010000800100008001
    0000800100008001000080010000800100008003000080070000800F0000}
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object pnBottom: TPanel
    Left = 0
    Top = 280
    Width = 412
    Height = 39
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object bibOk: TButton
      Left = 250
      Top = 9
      Width = 75
      Height = 25
      Hint = 'Подтвердить'
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 2
    end
    object bibClose: TButton
      Left = 332
      Top = 9
      Width = 75
      Height = 25
      Hint = 'Закрыть'
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Отмена'
      ModalResult = 2
      TabOrder = 3
      OnClick = bibCloseClick
    end
    object bibConduct: TButton
      Left = 168
      Top = 9
      Width = 75
      Height = 25
      Hint = 'Провести'
      Anchors = [akRight, akBottom]
      Caption = 'Провести'
      TabOrder = 1
    end
    object bibPrint: TButton
      Left = 6
      Top = 9
      Width = 75
      Height = 25
      Hint = 'Печать'
      Anchors = [akLeft, akBottom]
      Caption = 'Печать'
      TabOrder = 0
    end
  end
  object pnTop: TPanel
    Left = 0
    Top = 0
    Width = 412
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object lbNumber: TLabel
      Left = 12
      Top = 14
      Width = 111
      Height = 13
      Caption = 'Номер документа:'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbDate: TLabel
      Left = 267
      Top = 14
      Width = 18
      Height = 13
      Caption = 'от:'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edNumber: TEdit
      Left = 131
      Top = 11
      Width = 100
      Height = 21
      TabOrder = 0
      OnChange = edNumberChange
      OnKeyPress = edNumberKeyPress
    end
    object dtpDate: TDateTimePicker
      Left = 294
      Top = 11
      Width = 97
      Height = 21
      CalAlignment = dtaLeft
      Date = 37540.7731366782
      Time = 37540.7731366782
      DateFormat = dfShort
      DateMode = dmComboBox
      Kind = dtkDate
      ParseInput = False
      TabOrder = 2
      OnChange = dtpDateChange
    end
    object bibNumber: TButton
      Left = 231
      Top = 11
      Width = 21
      Height = 21
      Hint = 'Следующий номер'
      Caption = '<-'
      TabOrder = 1
      OnClick = bibNumberClick
    end
  end
  object pcMain: TPageControl
    Left = 0
    Top = 41
    Width = 412
    Height = 239
    ActivePage = tsRequisitions
    Align = alClient
    HotTrack = True
    TabOrder = 2
    object tsRequisitions: TTabSheet
      Hint = 'Реквизиты документа'
      Caption = 'Реквизиты'
    end
    object tsData: TTabSheet
      Hint = 'Данные документа'
      Caption = 'Данные'
      ImageIndex = 1
      object pnBackGrid: TPanel
        Left = 0
        Top = 33
        Width = 404
        Height = 178
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object pnBut: TPanel
          Left = 315
          Top = 0
          Width = 89
          Height = 178
          Align = alRight
          BevelOuter = bvNone
          TabOrder = 1
          object bibAdjust: TButton
            Left = 8
            Top = 129
            Width = 75
            Height = 25
            Hint = 'Настройка (F8)'
            Caption = 'Настройка'
            TabOrder = 4
            OnClick = bibAdjustClick
            OnKeyDown = FormKeyDown
          end
          object bibDel: TButton
            Left = 8
            Top = 65
            Width = 75
            Height = 25
            Hint = 'Удалить (F4)'
            Caption = 'Удалить'
            TabOrder = 2
            OnKeyDown = FormKeyDown
          end
          object bibChange: TButton
            Left = 8
            Top = 33
            Width = 75
            Height = 25
            Hint = 'Изменить (F3)'
            Caption = 'Изменить'
            TabOrder = 1
            OnKeyDown = FormKeyDown
          end
          object bibAdd: TButton
            Left = 8
            Top = 1
            Width = 75
            Height = 25
            Hint = 'Добавить (F2)'
            Caption = 'Добавить'
            TabOrder = 0
            OnKeyDown = FormKeyDown
          end
          object bibView: TButton
            Left = 8
            Top = 97
            Width = 75
            Height = 25
            Hint = 'Просмотр (F6)'
            Caption = 'Просмотр'
            TabOrder = 3
            OnKeyDown = FormKeyDown
          end
        end
        object pnGrid: TPanel
          Left = 0
          Top = 0
          Width = 315
          Height = 178
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          object pnBottomGrid: TPanel
            Left = 0
            Top = 146
            Width = 315
            Height = 32
            Align = alBottom
            BevelOuter = bvNone
            TabOrder = 0
            object lbCount: TLabel
              Left = 165
              Top = 11
              Width = 113
              Height = 13
              Anchors = [akLeft, akBottom]
              Caption = 'Всего по документу: 0'
            end
            object DBNav: TDBNavigator
              Left = 6
              Top = 8
              Width = 148
              Height = 18
              DataSource = ds
              VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
              Anchors = [akLeft, akBottom]
              Hints.Strings = (
                'Первая запись'
                'Предыдущая запись'
                'Следующая запись'
                'Последняя запись'
                'Вставить запись'
                'Удалить запись'
                'Редактировать запись'
                'Потвердить редактирование'
                'Отменить редактирование'
                'Обновить данные')
              ParentShowHint = False
              ShowHint = False
              TabOrder = 0
            end
          end
        end
      end
      object pnFind: TPanel
        Left = 0
        Top = 0
        Width = 404
        Height = 33
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object lbSearch: TLabel
          Left = 9
          Top = 8
          Width = 34
          Height = 13
          Caption = 'Найти:'
        end
        object edSearch: TEdit
          Left = 50
          Top = 5
          Width = 263
          Height = 21
          MaxLength = 30
          TabOrder = 0
          OnKeyDown = edSearchKeyDown
          OnKeyUp = edSearchKeyUp
        end
      end
    end
  end
  object ds: TDataSource
    AutoEdit = False
    Left = 80
    Top = 120
  end
  object IBTran: TIBTransaction
    Active = False
    DefaultAction = TARollback
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    AutoStopAction = saNone
    Left = 112
    Top = 121
  end
  object pmGrid: TPopupMenu
    OnPopup = pmGridPopup
    Left = 144
    Top = 121
  end
end
