inherited fmRptPms_Price: TfmRptPms_Price
  Left = 565
  Top = 167
  Width = 530
  Height = 455
  BorderStyle = bsSizeable
  Caption = 'Прайсы'
  Constraints.MaxHeight = 455
  Constraints.MaxWidth = 540
  Constraints.MinHeight = 455
  Constraints.MinWidth = 530
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBut: TPanel
    Top = 383
    Width = 522
    TabOrder = 5
    inherited Panel2: TPanel
      Left = 136
      inherited bibGen: TButton
        Top = 6
      end
      inherited bibClose: TButton
        Top = 6
      end
      inherited bibBreak: TButton
        Top = 6
      end
      inherited bibClear: TButton
        Left = 11
        Top = 6
        Hint = 'Значения по умолчанию'
        Caption = 'По умолчанию'
      end
    end
  end
  inherited cbInString: TCheckBox
    Left = 13
    Top = 305
    TabOrder = 4
  end
  object grbPrice: TGroupBox [2]
    Left = 7
    Top = 129
    Width = 506
    Height = 253
    Caption = ' Операция с недвижимостью '
    TabOrder = 3
    object lbStatus: TLabel
      Left = 12
      Top = 98
      Width = 37
      Height = 13
      Caption = 'Статус:'
    end
    object lbColumns: TLabel
      Left = 148
      Top = 98
      Width = 46
      Height = 13
      Caption = 'Колонки:'
    end
    object rbSale: TRadioButton
      Left = 10
      Top = 17
      Width = 80
      Height = 17
      Caption = 'Продажа'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = rbSaleClick
    end
    object rbLease: TRadioButton
      Left = 133
      Top = 17
      Width = 80
      Height = 17
      Caption = 'Аренда'
      TabOrder = 1
      OnClick = rbSaleClick
    end
    object rbShare: TRadioButton
      Left = 256
      Top = 17
      Width = 80
      Height = 17
      Caption = 'Долевое'
      TabOrder = 2
      OnClick = rbSaleClick
    end
    object cmbSale: TComboBox
      Left = 10
      Top = 38
      Width = 122
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 3
      OnChange = cmbSaleChange
      Items.Strings = (
        'Клиентский'
        'Агентский'
        'Инспекторский')
    end
    object cmbLease: TComboBox
      Left = 133
      Top = 38
      Width = 122
      Height = 21
      Style = csDropDownList
      Color = clBtnFace
      Enabled = False
      ItemHeight = 13
      TabOrder = 4
      OnChange = cmbSaleChange
      Items.Strings = (
        'Клиентский'
        'Агентский'
        'Инспекторский №1'
        'Инспекторский №2'
        'Агентский №2')
    end
    object cmbShare: TComboBox
      Left = 256
      Top = 38
      Width = 122
      Height = 21
      Style = csDropDownList
      Color = clBtnFace
      Enabled = False
      ItemHeight = 13
      TabOrder = 5
      OnChange = cmbSaleChange
      Items.Strings = (
        'Клиентский'
        'Агентский'
        'Инспекторский'
        'Агентский №2'
        'Инспекторский №2'
        'Клиентский №2'
        'Клиентский №3')
    end
    object lbxStatus: TCheckListBox
      Left = 10
      Top = 115
      Width = 120
      Height = 128
      Hint = 'Выберите необходимые для обработки статусы'
      OnClickCheck = lbxStatusClickCheck
      ItemHeight = 13
      ParentShowHint = False
      PopupMenu = pmStatus
      ShowHint = True
      TabOrder = 10
    end
    object bibMore: TButton
      Left = 10
      Top = 66
      Width = 75
      Height = 22
      Hint = 'Открыть/Закрыть дополнительные опции'
      Caption = 'больше'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
      OnClick = bibMoreClick
    end
    object chbFirstSortByStation: TCheckBox
      Left = 93
      Top = 68
      Width = 148
      Height = 17
      Caption = 'сортировать по статусу'
      TabOrder = 8
    end
    object lbxColumns: TCheckListBox
      Left = 146
      Top = 115
      Width = 230
      Height = 128
      Hint = 'Выберите или переставьте необходимые для отображения колонки'
      OnClickCheck = lbxColumnsClickCheck
      ItemHeight = 13
      ParentShowHint = False
      PopupMenu = pmColumns
      ShowHint = True
      TabOrder = 11
      OnDragDrop = lbxColumnsDragDrop
      OnDragOver = lbxColumnsDragOver
      OnMouseMove = lbxColumnsMouseMove
    end
    object btUpColumns: TBitBtn
      Left = 381
      Top = 114
      Width = 24
      Height = 22
      Hint = 'Вверх'
      TabOrder = 12
      OnClick = btUpColumnsClick
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000010000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
        8888888888888888888888888888888888888888888888888888888880000088
        8888888880666088888888888066608888888888806660888888880000666000
        0888888066666660888888880666660888888888806660888888888888060888
        8888888888808888888888888888888888888888888888888888}
    end
    object btDownColumns: TBitBtn
      Left = 381
      Top = 141
      Width = 24
      Height = 22
      Hint = 'Вниз'
      TabOrder = 13
      OnClick = btDownColumnsClick
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000010000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
        8888888888888888888888888888888888888888888888888888888888808888
        8888888888060888888888888066608888888888066666088888888066666660
        8888880000666000088888888066608888888888806660888888888880666088
        8888888880000088888888888888888888888888888888888888}
    end
    object chbUseStyle: TCheckBox
      Left = 245
      Top = 68
      Width = 148
      Height = 17
      Caption = 'использовать стили'
      TabOrder = 9
    end
    object cmbLand: TComboBox
      Left = 379
      Top = 38
      Width = 122
      Height = 21
      Style = csDropDownList
      Color = clBtnFace
      Enabled = False
      ItemHeight = 13
      TabOrder = 6
      OnChange = cmbSaleChange
      Items.Strings = (
        'Клиентский(земля)'
        'Клиентский(дома)'
        'Агентский')
    end
    object rbLand: TRadioButton
      Left = 381
      Top = 17
      Width = 80
      Height = 17
      Caption = 'Земля'
      TabOrder = 14
      OnClick = rbSaleClick
    end
  end
  object grbRealyRecyled: TGroupBox [3]
    Left = 8
    Top = 84
    Width = 411
    Height = 43
    Caption = ' Какие предложения '
    TabOrder = 2
    object rbRealy: TRadioButton
      Left = 9
      Top = 17
      Width = 145
      Height = 17
      Caption = 'Реальные предложения'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object rbRecyled: TRadioButton
      Left = 161
      Top = 17
      Width = 73
      Height = 17
      Caption = 'Корзина'
      TabOrder = 1
    end
    object rbAll: TRadioButton
      Left = 235
      Top = 17
      Width = 151
      Height = 17
      Caption = 'Реальные и корзина'
      TabOrder = 2
    end
  end
  object grbOffice: TGroupBox [4]
    Left = 8
    Top = 6
    Width = 243
    Height = 76
    Caption = ' Офисы '
    TabOrder = 0
    object chbOffice: TCheckListBox
      Left = 8
      Top = 16
      Width = 225
      Height = 50
      ItemHeight = 13
      TabOrder = 0
    end
  end
  object grbPeriod: TGroupBox [5]
    Left = 257
    Top = 6
    Width = 162
    Height = 76
    Caption = ' Период '
    TabOrder = 1
    object lbDateFrom: TLabel
      Left = 15
      Top = 23
      Width = 9
      Height = 13
      Alignment = taRightJustify
      Caption = 'с:'
    end
    object lbDateTo: TLabel
      Left = 9
      Top = 45
      Width = 15
      Height = 13
      Alignment = taRightJustify
      Caption = 'по:'
    end
    object dtpDateFrom: TDateTimePicker
      Left = 31
      Top = 18
      Width = 94
      Height = 22
      CalAlignment = dtaLeft
      Date = 37147
      Time = 37147
      Checked = False
      DateFormat = dfShort
      DateMode = dmComboBox
      Kind = dtkDate
      ParseInput = False
      TabOrder = 0
    end
    object dtpDateTo: TDateTimePicker
      Left = 31
      Top = 43
      Width = 94
      Height = 22
      CalAlignment = dtaLeft
      Date = 37147
      Time = 37147
      Checked = False
      DateFormat = dfShort
      DateMode = dmComboBox
      Kind = dtkDate
      ParseInput = False
      TabOrder = 1
    end
    object bibDate: TButton
      Left = 130
      Top = 19
      Width = 23
      Height = 46
      Hint = 'Выбрать'
      Caption = '...'
      TabOrder = 2
      OnClick = bibDateClick
    end
  end
  inherited IBTran: TIBTransaction
    Left = 280
    Top = 292
  end
  inherited Mainqr: TIBQuery
    Left = 232
    Top = 283
  end
  object pmStatus: TPopupMenu
    Left = 55
    Top = 279
    object miCheckAll: TMenuItem
      Caption = 'Выбрать все'
      Hint = 'Установить флаг для всех элементов'
      OnClick = miCheckAllClick
    end
    object miUnCheckAll: TMenuItem
      Caption = 'Убрать все'
      Hint = 'Убрать флаг для всех элементов'
      OnClick = miUnCheckAllClick
    end
  end
  object pmColumns: TPopupMenu
    Left = 175
    Top = 287
    object miColumnsCheckAll: TMenuItem
      Caption = 'Выбрать все'
      Hint = 'Установить флаг для всех элементов'
      OnClick = miColumnsCheckAllClick
    end
    object miColumnsUnCheckAll: TMenuItem
      Caption = 'Убрать все'
      Hint = 'Убрать флаг для всех элементов'
      OnClick = miColumnsUnCheckAllClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object miColumnsDefault: TMenuItem
      Caption = 'По умолчанию'
      Hint = 'Первоночальное состояние'
      OnClick = miColumnsDefaultClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object miColumnsSave: TMenuItem
      Caption = 'Сохранить'
      Hint = 'Сохранить порядок в файл'
      OnClick = miColumnsSaveClick
    end
    object miColumnsLoad: TMenuItem
      Caption = 'Загрузить'
      Hint = 'Загрузить порядок из файла'
      OnClick = miColumnsLoadClick
    end
  end
end
