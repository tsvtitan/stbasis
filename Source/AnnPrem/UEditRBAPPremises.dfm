inherited fmEditRBAPPremises: TfmEditRBAPPremises
  Left = 499
  Top = 155
  ActiveControl = edRelease
  Caption = 'fmEditRBAPPremises'
  ClientHeight = 490
  ClientWidth = 692
  PixelsPerInch = 96
  TextHeight = 13
  object bvPaymentInfo: TBevel [0]
    Left = 459
    Top = 232
    Width = 223
    Height = 5
    Shape = bsBottomLine
  end
  object lbName: TLabel [1]
    Left = 312
    Top = 55
    Width = 25
    Height = 13
    Alignment = taRightJustify
    Caption = 'Имя:'
    FocusControl = edName
  end
  object lbNN: TLabel [2]
    Left = 35
    Top = 55
    Width = 37
    Height = 13
    Alignment = taRightJustify
    Caption = 'Номер:'
    FocusControl = edNN
  end
  object bvGeneralINfo: TBevel [3]
    Left = 11
    Top = 9
    Width = 670
    Height = 5
    Shape = bsBottomLine
  end
  object lbGeneralInfo: TLabel [4]
    Left = 33
    Top = 5
    Width = 127
    Height = 13
    Caption = ' Общая информация '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbDeliveryDateFrom: TLabel [5]
    Left = 356
    Top = 20
    Width = 67
    Height = 26
    Alignment = taRightJustify
    Caption = 'Дата поступления:'
    FocusControl = dtpDeliveryDateFrom
    WordWrap = True
  end
  object lbDeliveryDateTo: TLabel [6]
    Left = 535
    Top = 28
    Width = 15
    Height = 13
    Alignment = taRightJustify
    Caption = 'по:'
    FocusControl = dtpDeliveryDateTo
  end
  object lbOperation: TLabel [7]
    Left = 159
    Top = 27
    Width = 53
    Height = 13
    Alignment = taRightJustify
    Caption = 'Операция:'
    FocusControl = edOperation
  end
  object lbPhones: TLabel [8]
    Left = 156
    Top = 55
    Width = 56
    Height = 13
    Alignment = taRightJustify
    Caption = 'Телефоны:'
    FocusControl = edPhones
  end
  object lbAgency: TLabel [9]
    Left = 459
    Top = 55
    Width = 50
    Height = 13
    Alignment = taRightJustify
    Caption = 'Агенство:'
    FocusControl = cmbAgency
  end
  object bvAddressInfo: TBevel [10]
    Left = 12
    Top = 81
    Width = 275
    Height = 5
    Shape = bsBottomLine
  end
  object lbAddressInfo: TLabel [11]
    Left = 34
    Top = 77
    Width = 45
    Height = 13
    Caption = ' Адрес '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbRegion: TLabel [12]
    Left = 38
    Top = 149
    Width = 34
    Height = 13
    Alignment = taRightJustify
    Caption = 'Район:'
    FocusControl = cmbRegion
  end
  object lbHouse: TLabel [13]
    Left = 29
    Top = 228
    Width = 43
    Height = 13
    Alignment = taRightJustify
    Caption = '№ дома:'
    FocusControl = edHouse
  end
  object lbApartment: TLabel [14]
    Left = 147
    Top = 228
    Width = 66
    Height = 13
    Alignment = taRightJustify
    Caption = '№ квартиры:'
    FocusControl = edApartment
  end
  object lbTown: TLabel [15]
    Left = 39
    Top = 123
    Width = 33
    Height = 13
    Alignment = taRightJustify
    Caption = 'Город:'
    FocusControl = cmbTown
  end
  object lbLandmark: TLabel [16]
    Left = 20
    Top = 175
    Width = 52
    Height = 13
    Alignment = taRightJustify
    Caption = 'Ориентир:'
    FocusControl = cmbLandmark
  end
  object lbStreet: TLabel [17]
    Left = 37
    Top = 201
    Width = 35
    Height = 13
    Alignment = taRightJustify
    Caption = 'Улица:'
    FocusControl = cmbStreet
  end
  object bvHouseInfo: TBevel [18]
    Left = 12
    Top = 255
    Width = 275
    Height = 5
    Shape = bsBottomLine
  end
  object lbHouseInfo: TLabel [19]
    Left = 34
    Top = 251
    Width = 35
    Height = 13
    Caption = ' Дом '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbFloorCount: TLabel [20]
    Left = 14
    Top = 300
    Width = 58
    Height = 13
    Alignment = taRightJustify
    Caption = 'Этажность:'
    FocusControl = edFloorCount
  end
  object lbTypeHouse: TLabel [21]
    Left = 162
    Top = 300
    Width = 51
    Height = 13
    Alignment = taRightJustify
    Caption = 'Тип дома:'
    FocusControl = cmbTypeHouse
  end
  object lbTypeWater: TLabel [22]
    Left = 9
    Top = 327
    Width = 63
    Height = 13
    Alignment = taRightJustify
    Caption = 'Водоснабж.:'
    FocusControl = cmbTypeWater
  end
  object lbTypeHeat: TLabel [23]
    Left = 155
    Top = 327
    Width = 58
    Height = 13
    Alignment = taRightJustify
    Caption = 'Отопление:'
    FocusControl = cmbTypeHeat
  end
  object lbDelivery: TLabel [24]
    Left = 180
    Top = 354
    Width = 33
    Height = 13
    Alignment = taRightJustify
    Caption = 'Сдача:'
    FocusControl = edDelivery
  end
  object lbBuilder: TLabel [25]
    Left = 50
    Top = 380
    Width = 66
    Height = 13
    Alignment = taRightJustify
    Caption = 'Застройщик:'
    FocusControl = cmbBuilder
  end
  object lbTypePremises: TLabel [26]
    Left = 16
    Top = 274
    Width = 100
    Height = 13
    Alignment = taRightJustify
    Caption = 'Тип недвижимости:'
    FocusControl = cmbTypePremises
  end
  object bvApartmentInfo: TBevel [27]
    Left = 298
    Top = 81
    Width = 383
    Height = 5
    Shape = bsBottomLine
  end
  object lbApartmentInfo: TLabel [28]
    Left = 320
    Top = 77
    Width = 109
    Height = 13
    Caption = ' Квартира - Офис '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbSewerage: TLabel [29]
    Left = 11
    Top = 353
    Width = 61
    Height = 13
    Alignment = taRightJustify
    Caption = 'Канализац.:'
    FocusControl = cmbSewerage
  end
  object lbFloor: TLabel [30]
    Left = 335
    Top = 100
    Width = 29
    Height = 13
    Alignment = taRightJustify
    Caption = 'Этаж:'
    FocusControl = edFloor
  end
  object lbCountRoom: TLabel [31]
    Left = 294
    Top = 126
    Width = 70
    Height = 13
    Alignment = taRightJustify
    Caption = 'Комнатность:'
    FocusControl = cmbCountRoom
  end
  object lbPlanning: TLabel [32]
    Left = 299
    Top = 152
    Width = 65
    Height = 13
    Alignment = taRightJustify
    Caption = 'Планировка:'
    FocusControl = cmbPlanning
  end
  object lbTypeApartment: TLabel [33]
    Left = 290
    Top = 178
    Width = 74
    Height = 13
    Alignment = taRightJustify
    Caption = 'Тип квартиры:'
    FocusControl = cmbTypeApartment
  end
  object lbTypeCondition: TLabel [34]
    Left = 307
    Top = 204
    Width = 57
    Height = 13
    Alignment = taRightJustify
    Caption = 'Состояние:'
    FocusControl = cmbTypeCondition
  end
  object lbTypePnone: TLabel [35]
    Left = 441
    Top = 100
    Width = 48
    Height = 13
    Alignment = taRightJustify
    Caption = 'Телефон:'
    FocusControl = cmbPhone
  end
  object lbTypeBalcony: TLabel [36]
    Left = 449
    Top = 126
    Width = 40
    Height = 13
    Alignment = taRightJustify
    Caption = 'Балкон:'
    FocusControl = cmbTypeBalcony
  end
  object lbTypeDoor: TLabel [37]
    Left = 453
    Top = 152
    Width = 36
    Height = 13
    Alignment = taRightJustify
    Caption = 'Двери:'
    FocusControl = cmbTypeDoor
  end
  object lbTypeSanitary: TLabel [38]
    Left = 441
    Top = 178
    Width = 48
    Height = 13
    Alignment = taRightJustify
    Caption = 'Сан.узел:'
    FocusControl = cmbTypeSanitary
  end
  object lbTypeFurniture: TLabel [39]
    Left = 447
    Top = 204
    Width = 42
    Height = 13
    Alignment = taRightJustify
    Caption = 'Мебель:'
    FocusControl = cmbTypeFurniture
  end
  object lbHomeTech: TLabel [40]
    Left = 569
    Top = 100
    Width = 45
    Height = 13
    Alignment = taRightJustify
    Caption = 'Быт.тех.:'
    FocusControl = cmbHomeTech
  end
  object lbTypePlate: TLabel [41]
    Left = 580
    Top = 126
    Width = 34
    Height = 13
    Alignment = taRightJustify
    Caption = 'Плита:'
    FocusControl = cmbTypePlate
  end
  object lbTypeInternet: TLabel [42]
    Left = 563
    Top = 152
    Width = 51
    Height = 13
    Alignment = taRightJustify
    Caption = 'Интернет:'
    FocusControl = cmbTypeInternet
  end
  object bvAreaInfo: TBevel [43]
    Left = 298
    Top = 231
    Width = 151
    Height = 6
    Shape = bsBottomLine
  end
  object lbAreaInfo: TLabel [44]
    Left = 320
    Top = 228
    Width = 63
    Height = 13
    Caption = ' Площади '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbGeneralArea: TLabel [45]
    Left = 326
    Top = 251
    Width = 38
    Height = 13
    Alignment = taRightJustify
    Caption = 'Общая:'
    FocusControl = edGeneralArea
  end
  object lbDwellingArea: TLabel [46]
    Left = 326
    Top = 277
    Width = 38
    Height = 13
    Alignment = taRightJustify
    Caption = 'Жилая:'
    FocusControl = edDwelling
  end
  object lbKitchenArea: TLabel [47]
    Left = 332
    Top = 304
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Кухня:'
    FocusControl = edKitchenArea
  end
  object lbGroundArea: TLabel [48]
    Left = 298
    Top = 331
    Width = 66
    Height = 13
    Alignment = taRightJustify
    Caption = 'Зем.участок:'
    FocusControl = edGroundArea
  end
  object lbPaymentInfo: TLabel [49]
    Left = 481
    Top = 228
    Width = 102
    Height = 13
    Caption = ' Оплата и сроки '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbPrice: TLabel [50]
    Left = 459
    Top = 251
    Width = 29
    Height = 13
    Alignment = taRightJustify
    Caption = 'Цена:'
    FocusControl = edPrice
  end
  object lbPeriod: TLabel [51]
    Left = 461
    Top = 277
    Width = 28
    Height = 13
    Alignment = taRightJustify
    Caption = 'Срок:'
    FocusControl = edPeriod
  end
  object lbPaymentFor: TLabel [52]
    Left = 557
    Top = 277
    Width = 55
    Height = 13
    Alignment = taRightJustify
    Caption = 'Оплата за:'
    FocusControl = edPaymentFor
  end
  object bvBuildingsInfo: TBevel [53]
    Left = 10
    Top = 407
    Width = 277
    Height = 5
    Shape = bsBottomLine
  end
  object lbBuildingsInfo: TLabel [54]
    Left = 32
    Top = 403
    Width = 73
    Height = 13
    Caption = ' Постройки '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbTypeGarage: TLabel [55]
    Left = 35
    Top = 426
    Width = 35
    Height = 13
    Alignment = taRightJustify
    Caption = 'Гараж:'
    FocusControl = cmbTypeGarage
  end
  object lbTypeBath: TLabel [56]
    Left = 176
    Top = 426
    Width = 28
    Height = 13
    Alignment = taRightJustify
    Caption = 'Баня:'
    FocusControl = cmbBath
  end
  object bvAdditionalInfo: TBevel [57]
    Left = 459
    Top = 309
    Width = 223
    Height = 5
    Shape = bsBottomLine
  end
  object lbAdditionalInfo: TLabel [58]
    Left = 481
    Top = 305
    Width = 102
    Height = 13
    Caption = ' Дополнительно '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbNote: TLabel [59]
    Left = 455
    Top = 330
    Width = 34
    Height = 13
    Alignment = taRightJustify
    Caption = 'Прим.:'
    FocusControl = edNote
  end
  object bvRegistrationInfo: TBevel [60]
    Left = 305
    Top = 357
    Width = 151
    Height = 6
    Shape = bsBottomLine
  end
  object lbRegistrationInfo: TLabel [61]
    Left = 327
    Top = 354
    Width = 85
    Height = 13
    Caption = ' Оформление '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbStyle: TLabel [62]
    Left = 331
    Top = 377
    Width = 33
    Height = 13
    Alignment = taRightJustify
    Caption = 'Стиль:'
    FocusControl = cmbStyle
  end
  object lbWhoInsert: TLabel [63]
    Left = 496
    Top = 357
    Width = 48
    Height = 13
    Alignment = taRightJustify
    Caption = 'Кто ввел:'
    FocusControl = edWhoInsert
  end
  object lbWhoUpdate: TLabel [64]
    Left = 476
    Top = 384
    Width = 68
    Height = 13
    Alignment = taRightJustify
    Caption = 'Кто изменил:'
    FocusControl = edWhoUpdate
  end
  object lbRelease: TLabel [65]
    Left = 32
    Top = 27
    Width = 41
    Height = 13
    Alignment = taRightJustify
    Caption = 'Выпуск:'
    FocusControl = edRelease
  end
  object lbDirection: TLabel [66]
    Left = 82
    Top = 97
    Width = 71
    Height = 13
    Alignment = taRightJustify
    Caption = 'Направление:'
    FocusControl = cmbDirection
  end
  inherited pnBut: TPanel
    Top = 452
    Width = 692
    TabOrder = 55
    inherited Panel2: TPanel
      Left = 507
    end
  end
  inherited cbInString: TCheckBox
    Left = 308
    Top = 423
    TabOrder = 53
  end
  object edName: TEdit [69]
    Left = 343
    Top = 52
    Width = 105
    Height = 21
    Hint = 'Имя'
    MaxLength = 100
    TabOrder = 8
    OnChange = edNameChange
  end
  object edNN: TEdit [70]
    Left = 79
    Top = 52
    Width = 69
    Height = 21
    Hint = 'Номер'
    MaxLength = 100
    TabOrder = 3
    OnChange = edNameChange
  end
  object dtpDeliveryDateFrom: TDateTimePicker [71]
    Left = 432
    Top = 24
    Width = 95
    Height = 22
    Hint = 'Дата поступления'
    CalAlignment = dtaLeft
    Date = 38875.9402674537
    Time = 38875.9402674537
    Checked = False
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 4
    OnChange = edNameChange
  end
  object dtpDeliveryDateTo: TDateTimePicker [72]
    Left = 558
    Top = 24
    Width = 95
    Height = 22
    Hint = 'Дата поступления'
    CalAlignment = dtaLeft
    Date = 38875.9402674537
    Time = 38875.9402674537
    Checked = False
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 5
    OnChange = edNameChange
  end
  object edOperation: TEdit [73]
    Left = 219
    Top = 25
    Width = 103
    Height = 21
    Hint = 'Операция'
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 54
    OnChange = edNameChange
    OnKeyDown = edOperationKeyDown
  end
  object btOperation: TButton [74]
    Left = 327
    Top = 25
    Width = 22
    Height = 21
    Hint = 'Операция'
    Caption = '...'
    TabOrder = 2
    OnClick = btOperationClick
  end
  object edPhones: TEdit [75]
    Left = 219
    Top = 52
    Width = 85
    Height = 21
    Hint = 'Телефоны'
    MaxLength = 100
    TabOrder = 7
    OnChange = edNameChange
  end
  object cmbAgency: TComboBox [76]
    Left = 515
    Top = 52
    Width = 167
    Height = 21
    Hint = 'Агенство'
    ItemHeight = 13
    TabOrder = 9
    OnEnter = cmbAgencyEnter
    OnExit = cmbAgencyExit
    OnKeyDown = cmbAgencyKeyDown
    OnKeyUp = cmbAgencyKeyUp
  end
  object cmbRegion: TComboBox [77]
    Left = 79
    Top = 146
    Width = 203
    Height = 21
    Hint = 'Район'
    ItemHeight = 13
    TabOrder = 12
    OnChange = cmbRegionChange
    OnEnter = cmbAgencyEnter
    OnExit = cmbAgencyExit
    OnKeyDown = cmbAgencyKeyDown
    OnKeyUp = cmbAgencyKeyUp
  end
  object edHouse: TEdit [78]
    Left = 79
    Top = 225
    Width = 61
    Height = 21
    Hint = 'Дом'
    TabOrder = 15
    OnChange = edNameChange
  end
  object edApartment: TEdit [79]
    Left = 220
    Top = 225
    Width = 61
    Height = 21
    Hint = 'Квартира'
    TabOrder = 16
    OnChange = edNameChange
  end
  object cmbTown: TComboBox [80]
    Left = 79
    Top = 120
    Width = 203
    Height = 21
    Hint = 'Город'
    ItemHeight = 13
    TabOrder = 11
    OnChange = edNameChange
    OnEnter = cmbAgencyEnter
    OnExit = cmbAgencyExit
    OnKeyDown = cmbAgencyKeyDown
    OnKeyUp = cmbAgencyKeyUp
  end
  object cmbLandmark: TComboBox [81]
    Left = 79
    Top = 172
    Width = 203
    Height = 21
    Hint = 'Ориентир'
    ItemHeight = 13
    TabOrder = 13
    OnChange = edNameChange
    OnEnter = cmbAgencyEnter
    OnExit = cmbAgencyExit
    OnKeyDown = cmbAgencyKeyDown
    OnKeyUp = cmbAgencyKeyUp
  end
  object cmbStreet: TComboBox [82]
    Left = 79
    Top = 198
    Width = 203
    Height = 21
    Hint = 'Улица'
    ItemHeight = 13
    TabOrder = 14
    OnChange = edNameChange
    OnEnter = cmbAgencyEnter
    OnExit = cmbAgencyExit
    OnKeyDown = cmbAgencyKeyDown
    OnKeyUp = cmbAgencyKeyUp
  end
  object edFloorCount: TEdit [83]
    Left = 79
    Top = 297
    Width = 61
    Height = 21
    Hint = 'Этажность'
    TabOrder = 18
    OnChange = edNameChange
  end
  object cmbTypeHouse: TComboBox [84]
    Left = 220
    Top = 297
    Width = 61
    Height = 21
    Hint = 'Тип дома'
    ItemHeight = 13
    TabOrder = 19
    OnChange = edNameChange
    OnEnter = cmbAgencyEnter
    OnExit = cmbAgencyExit
    OnKeyDown = cmbAgencyKeyDown
    OnKeyUp = cmbAgencyKeyUp
  end
  object cmbTypeWater: TComboBox [85]
    Left = 79
    Top = 324
    Width = 61
    Height = 21
    Hint = 'Водоснабжение'
    ItemHeight = 13
    TabOrder = 20
    OnChange = edNameChange
    OnEnter = cmbAgencyEnter
    OnExit = cmbAgencyExit
    OnKeyDown = cmbAgencyKeyDown
    OnKeyUp = cmbAgencyKeyUp
  end
  object cmbTypeHeat: TComboBox [86]
    Left = 220
    Top = 324
    Width = 61
    Height = 21
    Hint = 'Отопление'
    ItemHeight = 13
    TabOrder = 21
    OnChange = edNameChange
    OnEnter = cmbAgencyEnter
    OnExit = cmbAgencyExit
    OnKeyDown = cmbAgencyKeyDown
    OnKeyUp = cmbAgencyKeyUp
  end
  object edDelivery: TEdit [87]
    Left = 220
    Top = 351
    Width = 61
    Height = 21
    Hint = 'Сдача'
    TabOrder = 23
    OnChange = edNameChange
  end
  object cmbBuilder: TComboBox [88]
    Left = 122
    Top = 377
    Width = 159
    Height = 21
    Hint = 'Застройщик'
    ItemHeight = 13
    TabOrder = 24
    OnChange = edNameChange
    OnEnter = cmbAgencyEnter
    OnExit = cmbAgencyExit
    OnKeyDown = cmbAgencyKeyDown
    OnKeyUp = cmbAgencyKeyUp
  end
  object cmbTypePremises: TComboBox [89]
    Left = 122
    Top = 271
    Width = 159
    Height = 21
    Hint = 'Тип недвижимости'
    ItemHeight = 13
    TabOrder = 17
    OnChange = edNameChange
    OnEnter = cmbAgencyEnter
    OnExit = cmbAgencyExit
    OnKeyDown = cmbAgencyKeyDown
    OnKeyUp = cmbAgencyKeyUp
  end
  object cmbSewerage: TComboBox [90]
    Left = 79
    Top = 350
    Width = 61
    Height = 21
    Hint = 'Канализация'
    ItemHeight = 13
    TabOrder = 22
    OnChange = edNameChange
    OnEnter = cmbAgencyEnter
    OnExit = cmbAgencyExit
    OnKeyDown = cmbAgencyKeyDown
    OnKeyUp = cmbAgencyKeyUp
  end
  object edFloor: TEdit [91]
    Left = 371
    Top = 97
    Width = 61
    Height = 21
    Hint = 'Этаж'
    TabOrder = 27
    OnChange = edNameChange
  end
  object cmbCountRoom: TComboBox [92]
    Left = 371
    Top = 123
    Width = 61
    Height = 21
    Hint = 'Комнатность'
    ItemHeight = 13
    TabOrder = 28
    OnChange = edNameChange
    OnEnter = cmbAgencyEnter
    OnExit = cmbAgencyExit
    OnKeyDown = cmbAgencyKeyDown
    OnKeyUp = cmbAgencyKeyUp
  end
  object cmbPlanning: TComboBox [93]
    Left = 371
    Top = 149
    Width = 61
    Height = 21
    Hint = 'Планировка'
    ItemHeight = 13
    TabOrder = 29
    OnChange = edNameChange
    OnEnter = cmbAgencyEnter
    OnExit = cmbAgencyExit
    OnKeyDown = cmbAgencyKeyDown
    OnKeyUp = cmbAgencyKeyUp
  end
  object cmbTypeApartment: TComboBox [94]
    Left = 371
    Top = 175
    Width = 61
    Height = 21
    Hint = 'Тип квартиры'
    ItemHeight = 13
    TabOrder = 30
    OnChange = edNameChange
    OnEnter = cmbAgencyEnter
    OnExit = cmbAgencyExit
    OnKeyDown = cmbAgencyKeyDown
    OnKeyUp = cmbAgencyKeyUp
  end
  object cmbTypeCondition: TComboBox [95]
    Left = 371
    Top = 201
    Width = 61
    Height = 21
    Hint = 'Состояние'
    ItemHeight = 13
    TabOrder = 31
    OnChange = edNameChange
    OnEnter = cmbAgencyEnter
    OnExit = cmbAgencyExit
    OnKeyDown = cmbAgencyKeyDown
    OnKeyUp = cmbAgencyKeyUp
  end
  object cmbPhone: TComboBox [96]
    Left = 496
    Top = 97
    Width = 61
    Height = 21
    Hint = 'Вид телефона'
    ItemHeight = 13
    TabOrder = 32
    OnChange = edNameChange
    OnEnter = cmbAgencyEnter
    OnExit = cmbAgencyExit
    OnKeyDown = cmbAgencyKeyDown
    OnKeyUp = cmbAgencyKeyUp
  end
  object cmbTypeBalcony: TComboBox [97]
    Left = 496
    Top = 123
    Width = 61
    Height = 21
    Hint = 'Балкон'
    ItemHeight = 13
    TabOrder = 33
    OnChange = edNameChange
    OnEnter = cmbAgencyEnter
    OnExit = cmbAgencyExit
    OnKeyDown = cmbAgencyKeyDown
    OnKeyUp = cmbAgencyKeyUp
  end
  object cmbTypeDoor: TComboBox [98]
    Left = 496
    Top = 149
    Width = 61
    Height = 21
    Hint = 'Двери'
    ItemHeight = 13
    TabOrder = 34
    OnChange = edNameChange
    OnEnter = cmbAgencyEnter
    OnExit = cmbAgencyExit
    OnKeyDown = cmbAgencyKeyDown
    OnKeyUp = cmbAgencyKeyUp
  end
  object cmbTypeSanitary: TComboBox [99]
    Left = 496
    Top = 175
    Width = 61
    Height = 21
    Hint = 'Сан.узел'
    ItemHeight = 13
    TabOrder = 35
    OnChange = edNameChange
    OnEnter = cmbAgencyEnter
    OnExit = cmbAgencyExit
    OnKeyDown = cmbAgencyKeyDown
    OnKeyUp = cmbAgencyKeyUp
  end
  object cmbTypeFurniture: TComboBox [100]
    Left = 496
    Top = 201
    Width = 61
    Height = 21
    Hint = 'Мебель'
    ItemHeight = 13
    TabOrder = 36
    OnChange = edNameChange
    OnEnter = cmbAgencyEnter
    OnExit = cmbAgencyExit
    OnKeyDown = cmbAgencyKeyDown
    OnKeyUp = cmbAgencyKeyUp
  end
  object cmbHomeTech: TComboBox [101]
    Left = 621
    Top = 97
    Width = 61
    Height = 21
    Hint = 'Бытовая техника'
    ItemHeight = 13
    TabOrder = 37
    OnChange = edNameChange
    OnEnter = cmbAgencyEnter
    OnExit = cmbAgencyExit
    OnKeyDown = cmbAgencyKeyDown
    OnKeyUp = cmbAgencyKeyUp
  end
  object cmbTypePlate: TComboBox [102]
    Left = 621
    Top = 123
    Width = 61
    Height = 21
    Hint = 'Плита'
    ItemHeight = 13
    TabOrder = 38
    OnChange = edNameChange
    OnEnter = cmbAgencyEnter
    OnExit = cmbAgencyExit
    OnKeyDown = cmbAgencyKeyDown
    OnKeyUp = cmbAgencyKeyUp
  end
  object cmbTypeInternet: TComboBox [103]
    Left = 621
    Top = 149
    Width = 61
    Height = 21
    Hint = 'Вид интернета'
    ItemHeight = 13
    TabOrder = 39
    OnChange = edNameChange
    OnEnter = cmbAgencyEnter
    OnExit = cmbAgencyExit
    OnKeyDown = cmbAgencyKeyDown
    OnKeyUp = cmbAgencyKeyUp
  end
  object edGeneralArea: TEdit [104]
    Left = 371
    Top = 248
    Width = 61
    Height = 21
    Hint = 'Общая площадь'
    TabOrder = 40
    OnChange = edNameChange
  end
  object edDwelling: TEdit [105]
    Left = 371
    Top = 274
    Width = 61
    Height = 21
    Hint = 'Жилая пложадь'
    TabOrder = 41
    OnChange = edNameChange
  end
  object edKitchenArea: TEdit [106]
    Left = 371
    Top = 301
    Width = 61
    Height = 21
    Hint = 'Площадь кухни'
    TabOrder = 42
    OnChange = edNameChange
  end
  object edGroundArea: TEdit [107]
    Left = 371
    Top = 328
    Width = 61
    Height = 21
    Hint = 'Площадь земельного участка'
    TabOrder = 43
    OnChange = edNameChange
  end
  object cmbPriceCondition: TComboBox [108]
    Left = 496
    Top = 248
    Width = 50
    Height = 21
    Hint = 'Цена'
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 44
    OnChange = edNameChange
    Items.Strings = (
      '='
      '>'
      '<'
      '<>'
      '>='
      '<=')
  end
  object edPrice: TEdit [109]
    Left = 550
    Top = 248
    Width = 64
    Height = 21
    Hint = 'Цена'
    TabOrder = 45
    OnChange = edNameChange
  end
  object cmbUnitPrice: TComboBox [110]
    Left = 619
    Top = 248
    Width = 63
    Height = 21
    Hint = 'Единица измерения цены'
    ItemHeight = 13
    TabOrder = 46
    OnChange = edNameChange
    OnEnter = cmbAgencyEnter
    OnExit = cmbAgencyExit
    OnKeyDown = cmbAgencyKeyDown
    OnKeyUp = cmbAgencyKeyUp
  end
  object edPeriod: TEdit [111]
    Left = 496
    Top = 274
    Width = 48
    Height = 21
    Hint = 'Срок'
    TabOrder = 47
    OnChange = edNameChange
  end
  object edPaymentFor: TEdit [112]
    Left = 619
    Top = 274
    Width = 62
    Height = 21
    Hint = 'Оплата за'
    TabOrder = 48
    OnChange = edNameChange
  end
  object cmbTypeGarage: TComboBox [113]
    Left = 77
    Top = 423
    Width = 70
    Height = 21
    Hint = 'Гараж'
    ItemHeight = 13
    TabOrder = 25
    OnChange = edNameChange
    OnEnter = cmbAgencyEnter
    OnExit = cmbAgencyExit
    OnKeyDown = cmbAgencyKeyDown
    OnKeyUp = cmbAgencyKeyUp
  end
  object cmbBath: TComboBox [114]
    Left = 211
    Top = 423
    Width = 70
    Height = 21
    Hint = 'Баня'
    ItemHeight = 13
    TabOrder = 26
    OnChange = edNameChange
    OnEnter = cmbAgencyEnter
    OnExit = cmbAgencyExit
    OnKeyDown = cmbAgencyKeyDown
    OnKeyUp = cmbAgencyKeyUp
  end
  object edNote: TEdit [115]
    Left = 495
    Top = 327
    Width = 186
    Height = 21
    Hint = 'Примечание'
    MaxLength = 100
    TabOrder = 49
    OnChange = edNameChange
  end
  object cmbStyle: TComboBox [116]
    Left = 371
    Top = 374
    Width = 61
    Height = 21
    Hint = 'Стиль'
    ItemHeight = 13
    TabOrder = 50
    OnChange = edNameChange
    OnEnter = cmbAgencyEnter
    OnExit = cmbAgencyExit
    OnKeyDown = cmbAgencyKeyDown
    OnKeyUp = cmbAgencyKeyUp
  end
  object edWhoInsert: TEdit [117]
    Left = 551
    Top = 354
    Width = 130
    Height = 21
    Hint = 'Кто добавил'
    MaxLength = 100
    TabOrder = 51
    OnChange = edNameChange
  end
  object edWhoUpdate: TEdit [118]
    Left = 551
    Top = 381
    Width = 130
    Height = 21
    Hint = 'Кто изменил'
    MaxLength = 100
    TabOrder = 52
    OnChange = edNameChange
  end
  object btDeliveryDate: TButton [119]
    Left = 658
    Top = 24
    Width = 22
    Height = 21
    Hint = 'Дата поступления'
    Caption = '...'
    TabOrder = 6
    OnClick = btDeliveryDateClick
  end
  object edRelease: TEdit [120]
    Left = 80
    Top = 25
    Width = 42
    Height = 21
    Hint = 'Выпуск'
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 0
    OnChange = edNameChange
    OnKeyDown = edReleaseKeyDown
  end
  object btRelease: TButton [121]
    Left = 127
    Top = 25
    Width = 22
    Height = 21
    Hint = 'Выпуск'
    Caption = '...'
    TabOrder = 1
    OnClick = btReleaseClick
  end
  object cmbDirection: TComboBox [122]
    Left = 159
    Top = 94
    Width = 122
    Height = 21
    Hint = 'Направление'
    ItemHeight = 13
    TabOrder = 10
    OnChange = edNameChange
    OnEnter = cmbAgencyEnter
    OnExit = cmbAgencyExit
    OnKeyDown = cmbAgencyKeyDown
    OnKeyUp = cmbAgencyKeyUp
  end
  inherited IBTran: TIBTransaction
    Left = 160
    Top = 149
  end
end
