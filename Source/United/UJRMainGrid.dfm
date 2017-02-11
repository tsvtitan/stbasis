object fmJRMainGrid: TfmJRMainGrid
  Left = 610
  Top = 161
  Width = 470
  Height = 340
  Caption = 'Журнал'
  Color = clBtnFace
  Constraints.MinHeight = 340
  Constraints.MinWidth = 470
  Font.Charset = DEFAULT_CHARSET
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
    F00FFFFFF80007FF0000FFFFF80007FF0F00FFFFF80007FFFF00FFFFF80007FF
    FF00FFFFF80007FFFF00FFFFF80007FFFFFFFFFFF80007FFFF00FFF0000007FF
    FF00FFF7880007FFFFFFFFF7800007FFFFFFFFF700000777777777770000FFFF
    0000800100008001000080010000800100008001000080010000800100008001
    0000800100008001000080010000800100008003000080070000800F0000}
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object pnMain: TPanel
    Left = 0
    Top = 33
    Width = 462
    Height = 240
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object pnBut: TPanel
      Left = 373
      Top = 0
      Width = 89
      Height = 240
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object pnModal: TPanel
        Left = 0
        Top = 0
        Width = 89
        Height = 240
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object bibRefresh: TButton
          Left = 8
          Top = 8
          Width = 75
          Height = 25
          Hint = 'Обновить (F5)'
          Caption = 'Обновить'
          TabOrder = 0
          OnKeyDown = FormKeyDown
        end
        object bibClear: TButton
          Left = 8
          Top = 40
          Width = 75
          Height = 25
          Hint = 'Очистить'
          Caption = 'Очистить'
          TabOrder = 1
          OnKeyDown = FormKeyDown
        end
        object bibFilter: TButton
          Left = 8
          Top = 72
          Width = 75
          Height = 25
          Hint = 'Фильтр (F7)'
          Caption = 'Фильтр'
          TabOrder = 2
          OnClick = bibFilterClick
          OnKeyDown = FormKeyDown
        end
        object bibAdjust: TButton
          Left = 8
          Top = 104
          Width = 75
          Height = 25
          Hint = 'Настройка (F8)'
          Caption = 'Настройка'
          TabOrder = 3
          OnClick = bibAdjustClick
          OnKeyDown = FormKeyDown
        end
      end
    end
    object pnGrid: TPanel
      Left = 0
      Top = 0
      Width = 373
      Height = 240
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
    end
  end
  object pnFind: TPanel
    Left = 0
    Top = 0
    Width = 462
    Height = 33
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lbSearch: TLabel
      Left = 9
      Top = 9
      Width = 34
      Height = 13
      Caption = 'Найти:'
    end
    object edSearch: TEdit
      Left = 50
      Top = 6
      Width = 315
      Height = 21
      MaxLength = 30
      TabOrder = 0
      OnKeyDown = edSearchKeyDown
      OnKeyUp = edSearchKeyUp
    end
  end
  object pnBottom: TPanel
    Left = 0
    Top = 273
    Width = 462
    Height = 36
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object lbCount: TLabel
      Left = 166
      Top = 14
      Width = 89
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = 'Всего выбрано: 0'
    end
    object bibOk: TButton
      Left = 299
      Top = 6
      Width = 75
      Height = 25
      Hint = 'Подтвердить'
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      Default = True
      TabOrder = 0
      Visible = False
    end
    object DBNav: TDBNavigator
      Left = 7
      Top = 11
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
      TabOrder = 1
    end
    object bibClose: TButton
      Left = 381
      Top = 6
      Width = 75
      Height = 25
      Hint = 'Закрыть'
      Anchors = [akRight, akBottom]
      Caption = 'Закрыть'
      TabOrder = 2
      OnClick = bibCloseClick
    end
  end
  object ds: TDataSource
    AutoEdit = False
    DataSet = Mainqr
    Left = 96
    Top = 112
  end
  object Mainqr: TIBQuery
    Transaction = IBTran
    BufferChunks = 50
    CachedUpdates = False
    ParamCheck = False
    Left = 136
    Top = 112
  end
  object IBTran: TIBTransaction
    Active = False
    DefaultAction = TARollback
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    AutoStopAction = saNone
    Left = 176
    Top = 113
  end
  object pmGrid: TPopupMenu
    OnPopup = pmGridPopup
    Left = 224
    Top = 113
  end
  object IBUpd: TIBUpdateSQL
    Left = 176
    Top = 161
  end
end
