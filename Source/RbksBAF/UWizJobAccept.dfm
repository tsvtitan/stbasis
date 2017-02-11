inherited FmWizJobAccept: TFmWizJobAccept
  Left = 164
  Top = 118
  Caption = 'Принятие на работу'
  ClientHeight = 408
  Constraints.MinHeight = 420
  OldCreateOrder = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited Bevel1: TBevel
    Top = 367
  end
  inherited Bevel2: TBevel
    Top = 52
  end
  inherited PanelBottom: TPanel
    Top = 370
    inherited Panel2: TPanel
      inherited btClose: TButton
        Top = 7
        Cancel = False
        TabStop = False
      end
      inherited btFinish: TButton
        Top = 7
        TabStop = False
        OnClick = btFinishClick
      end
      inherited btPrior: TButton
        Top = 7
      end
      inherited btNext: TButton
        Top = 7
        Default = False
      end
    end
  end
  inherited PanelTop: TPanel
    Height = 52
    inherited Label1: TLabel
      Height = 52
    end
    inherited pnImage: TPanel
      Height = 52
      inherited shpImage: TShape
        Height = 42
      end
      inherited ImageLogo: TImage
        Height = 42
      end
    end
  end
  inherited PC: TPageControl
    Top = 55
    Height = 312
    ActivePage = TSPassport
    object TSMain: TTabSheet
      BorderWidth = 2
      Caption = 'ff'
      TabVisible = False
      object LbAbout: TLabel
        Left = 20
        Top = -2
        Width = 490
        Height = 13
        Alignment = taCenter
        Caption = 
          'Помощник проведет Вас через процедуру принятия на работу нового ' +
          'сотрудника'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LbFName: TLabel
        Left = 65
        Top = 18
        Width = 52
        Height = 13
        Alignment = taRightJustify
        Caption = 'Фамилия:'
      end
      object LbName: TLabel
        Left = 92
        Top = 41
        Width = 25
        Height = 13
        Alignment = taRightJustify
        Caption = 'Имя:'
      end
      object LbSName: TLabel
        Left = 67
        Top = 64
        Width = 50
        Height = 13
        Alignment = taRightJustify
        Caption = 'Отчество:'
      end
      object LbBirthDay: TLabel
        Left = 55
        Top = 134
        Width = 61
        Height = 13
        Alignment = taRightJustify
        Caption = 'Дата рожд.:'
      end
      object LbNation: TLabel
        Left = 31
        Top = 86
        Width = 88
        Height = 13
        Caption = 'Национальность:'
      end
      object lbSex: TLabel
        Left = 95
        Top = 110
        Width = 23
        Height = 13
        Caption = 'Пол:'
      end
      object EdFName: TEdit
        Left = 124
        Top = 14
        Width = 350
        Height = 21
        TabOrder = 0
        OnChange = FormActivate
      end
      object EdName: TEdit
        Left = 124
        Top = 37
        Width = 350
        Height = 21
        TabOrder = 1
      end
      object EdSName: TEdit
        Left = 124
        Top = 60
        Width = 350
        Height = 21
        TabOrder = 2
      end
      object dpBirthDate: TDateTimePicker
        Left = 124
        Top = 130
        Width = 82
        Height = 21
        CalAlignment = dtaLeft
        Date = 37178.4628152778
        Time = 37178.4628152778
        DateFormat = dfShort
        DateMode = dmComboBox
        Kind = dtkDate
        ParseInput = False
        TabOrder = 7
      end
      object edNationname: TEdit
        Left = 124
        Top = 84
        Width = 350
        Height = 21
        TabStop = False
        Color = clMenu
        ReadOnly = True
        TabOrder = 3
      end
      object BtCallNation: TButton
        Left = 473
        Top = 84
        Width = 21
        Height = 21
        Caption = '...'
        TabOrder = 4
        OnClick = BtCallNationClick
      end
      object edSex: TEdit
        Left = 124
        Top = 107
        Width = 132
        Height = 21
        Color = clBtnFace
        MaxLength = 100
        ReadOnly = True
        TabOrder = 5
      end
      object btCallSex: TBitBtn
        Left = 254
        Top = 107
        Width = 21
        Height = 21
        Hint = 'Выбрать'
        Caption = '...'
        TabOrder = 6
        OnClick = btCallSexClick
      end
      object grbBorn: TGroupBox
        Left = 29
        Top = 157
        Width = 481
        Height = 141
        Caption = ' Место рождения '
        TabOrder = 8
        object lbCountry: TLabel
          Left = 48
          Top = 19
          Width = 39
          Height = 13
          Anchors = [akLeft]
          Caption = 'Страна:'
        end
        object lbregion: TLabel
          Left = 12
          Top = 43
          Width = 75
          Height = 13
          Anchors = [akLeft]
          Caption = 'Край, область:'
        end
        object lbstate: TLabel
          Left = 53
          Top = 67
          Width = 34
          Height = 13
          Anchors = [akLeft]
          Caption = 'Район:'
        end
        object lbTown: TLabel
          Left = 54
          Top = 91
          Width = 33
          Height = 13
          Anchors = [akLeft]
          Caption = 'Город:'
        end
        object lbplacement: TLabel
          Left = 30
          Top = 116
          Width = 57
          Height = 13
          Anchors = [akLeft]
          Caption = 'Нас. пункт:'
        end
        object edCountry: TEdit
          Left = 94
          Top = 16
          Width = 353
          Height = 21
          Anchors = [akLeft]
          Color = clBtnFace
          MaxLength = 100
          ReadOnly = True
          TabOrder = 0
        end
        object btCallCountry: TBitBtn
          Left = 446
          Top = 16
          Width = 21
          Height = 21
          Hint = 'Выбрать'
          Anchors = [akLeft]
          Caption = '...'
          TabOrder = 1
          OnClick = btCallCountryClick
        end
        object edregion: TEdit
          Left = 94
          Top = 40
          Width = 353
          Height = 21
          Anchors = [akLeft]
          Color = clBtnFace
          MaxLength = 100
          ReadOnly = True
          TabOrder = 2
        end
        object btCallRegion: TBitBtn
          Left = 446
          Top = 40
          Width = 21
          Height = 21
          Hint = 'Выбрать'
          Anchors = [akLeft]
          Caption = '...'
          TabOrder = 3
          OnClick = btCallRegionClick
        end
        object edstate: TEdit
          Left = 94
          Top = 64
          Width = 353
          Height = 21
          Anchors = [akLeft]
          Color = clBtnFace
          MaxLength = 100
          ReadOnly = True
          TabOrder = 4
        end
        object btCallState: TBitBtn
          Left = 446
          Top = 64
          Width = 21
          Height = 21
          Hint = 'Выбрать'
          Anchors = [akLeft]
          Caption = '...'
          TabOrder = 5
          OnClick = btCallStateClick
        end
        object edtown: TEdit
          Left = 94
          Top = 88
          Width = 353
          Height = 21
          Anchors = [akLeft]
          Color = clBtnFace
          MaxLength = 100
          ReadOnly = True
          TabOrder = 6
          OnKeyDown = edtownKeyDown
        end
        object btCallTown: TBitBtn
          Left = 446
          Top = 88
          Width = 21
          Height = 21
          Hint = 'Выбрать'
          Anchors = [akLeft]
          Caption = '...'
          TabOrder = 7
          OnClick = btCallTownClick
        end
        object edplacement: TEdit
          Left = 94
          Top = 112
          Width = 353
          Height = 21
          Anchors = [akLeft]
          Color = clBtnFace
          MaxLength = 100
          ReadOnly = True
          TabOrder = 8
          OnKeyDown = edplacementKeyDown
        end
        object btCallPlacement: TBitBtn
          Left = 446
          Top = 112
          Width = 21
          Height = 21
          Hint = 'Выбрать'
          Anchors = [akLeft]
          Caption = '...'
          TabOrder = 9
          OnClick = btCallPlacementClick
        end
      end
    end
    object TS2: TTabSheet
      Caption = 'TS2'
      ImageIndex = 1
      TabVisible = False
      object LbSeniority: TLabel
        Left = 102
        Top = 73
        Width = 103
        Height = 13
        Caption = 'Непрерывный стаж:'
      end
      object LbPersCardNum: TLabel
        Left = 81
        Top = 99
        Width = 124
        Height = 13
        Caption = 'Номер личной карточки:'
      end
      object LbTabNum: TLabel
        Left = 110
        Top = 125
        Width = 95
        Height = 13
        Caption = 'Табельный номер:'
      end
      object LbINN: TLabel
        Left = 178
        Top = 151
        Width = 27
        Height = 13
        Caption = 'ИНН:'
      end
      object Label2: TLabel
        Left = 15
        Top = 40
        Width = 504
        Height = 26
        Caption = 
          'Укажите непрерывный стаж сотрудника, номер личной карточки, табе' +
          'льный номер'#13#10'  и ИНН.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbConnectionString: TLabel
        Left = 131
        Top = 258
        Width = 72
        Height = 13
        Caption = 'Строка связи:'
      end
      object lbConnectionType: TLabel
        Left = 119
        Top = 230
        Width = 84
        Height = 13
        Caption = 'Средство связи:'
      end
      object Label5: TLabel
        Left = 15
        Top = 175
        Width = 509
        Height = 39
        Caption = 
          'Укажите каким образом можно связаться с сотрудником:'#13#10'   - Средс' +
          'тво связи - какой вид связи (телефон, пейджер, электронная почта' +
          ' и т.д.) '#13#10'   - Строка связи - (номера: телефона, пейдж. компани' +
          'и и  абонента, эл.адрес)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbFamilyState: TLabel
        Left = 92
        Top = 8
        Width = 113
        Height = 13
        Caption = 'Семейное положение:'
      end
      object EdPersCardNum: TEdit
        Left = 212
        Top = 95
        Width = 121
        Height = 21
        TabOrder = 1
      end
      object EdTabNum: TEdit
        Left = 212
        Top = 121
        Width = 102
        Height = 21
        TabOrder = 2
      end
      object EdINN: TEdit
        Left = 212
        Top = 147
        Width = 121
        Height = 21
        MaxLength = 12
        TabOrder = 4
      end
      object DPSeniotity: TDateTimePicker
        Left = 212
        Top = 69
        Width = 120
        Height = 21
        CalAlignment = dtaLeft
        Date = 37178.5488982639
        Time = 37178.5488982639
        DateFormat = dfShort
        DateMode = dmComboBox
        Kind = dtkDate
        ParseInput = False
        TabOrder = 0
      end
      object edConnectionString: TEdit
        Left = 212
        Top = 254
        Width = 238
        Height = 21
        MaxLength = 100
        TabOrder = 7
      end
      object edConnectionType: TEdit
        Left = 212
        Top = 226
        Width = 219
        Height = 21
        Color = clBtnFace
        MaxLength = 100
        ReadOnly = True
        TabOrder = 5
      end
      object btCallConnectionType: TBitBtn
        Left = 429
        Top = 226
        Width = 21
        Height = 21
        Hint = 'Выбрать'
        Caption = '...'
        TabOrder = 6
        OnClick = btCallConnectionTypeClick
      end
      object btCallTabNumNext: TBitBtn
        Left = 314
        Top = 121
        Width = 21
        Height = 21
        Hint = 'Выбрать'
        Caption = '<-'
        TabOrder = 3
        OnClick = btCallTabNumNextClick
      end
      object EdFamilyStateName: TEdit
        Left = 212
        Top = 4
        Width = 214
        Height = 21
        TabStop = False
        Color = clMenu
        ReadOnly = True
        TabOrder = 8
      end
      object btCallFamState: TButton
        Left = 424
        Top = 4
        Width = 21
        Height = 21
        Caption = '...'
        TabOrder = 9
        OnClick = btCallFamStateClick
      end
    end
    object TSPassport: TTabSheet
      Caption = 'TS'
      ImageIndex = 2
      TabVisible = False
      object Label3: TLabel
        Left = 30
        Top = 6
        Width = 277
        Height = 13
        Caption = 'Укажите данные паспорта нового сотрудника'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbSerial: TLabel
        Left = 115
        Top = 30
        Width = 34
        Height = 13
        Caption = 'Серия:'
      end
      object lbNum: TLabel
        Left = 112
        Top = 56
        Width = 37
        Height = 13
        Caption = 'Номер:'
      end
      object lbDateWhere: TLabel
        Left = 80
        Top = 82
        Width = 69
        Height = 13
        Caption = 'Дата выдачи:'
      end
      object lbPlantName: TLabel
        Left = 90
        Top = 107
        Width = 59
        Height = 13
        Caption = 'Кем выдан:'
      end
      object lbhousenum: TLabel
        Left = 83
        Top = 209
        Width = 66
        Height = 13
        Caption = 'Номер дома:'
      end
      object lbbuildnum: TLabel
        Left = 68
        Top = 235
        Width = 81
        Height = 13
        Caption = 'Номер корпуса:'
      end
      object lbflatnum: TLabel
        Left = 60
        Top = 261
        Width = 89
        Height = 13
        Caption = 'Номер квартиры:'
      end
      object lbStreet: TLabel
        Left = 114
        Top = 182
        Width = 35
        Height = 13
        Caption = 'Улица:'
      end
      object lbTypeLive: TLabel
        Left = 62
        Top = 158
        Width = 87
        Height = 13
        Caption = 'Тип проживания:'
      end
      object Label6: TLabel
        Left = 30
        Top = 134
        Width = 408
        Height = 13
        Caption = 'Укажите данные о месте регистрации или проживания сотрудника:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object dtpDateWhere: TDateTimePicker
        Left = 159
        Top = 77
        Width = 97
        Height = 22
        CalAlignment = dtaLeft
        Date = 37156
        Time = 37156
        ShowCheckbox = True
        Checked = False
        DateFormat = dfShort
        DateMode = dmComboBox
        Kind = dtkDate
        ParseInput = False
        TabOrder = 2
      end
      object edPlantName: TEdit
        Left = 159
        Top = 103
        Width = 301
        Height = 21
        TabStop = False
        Color = clBtnFace
        MaxLength = 100
        ReadOnly = True
        TabOrder = 3
      end
      object btCallPlantName: TBitBtn
        Left = 460
        Top = 103
        Width = 21
        Height = 21
        Hint = 'Выбрать'
        Caption = '...'
        TabOrder = 4
        OnClick = btCallPlantNameClick
      end
      object msedSerial: TMaskEdit
        Left = 159
        Top = 26
        Width = 190
        Height = 21
        TabOrder = 0
      end
      object msedNum: TMaskEdit
        Left = 159
        Top = 52
        Width = 190
        Height = 21
        TabOrder = 1
      end
      object edhousenum: TEdit
        Left = 159
        Top = 205
        Width = 190
        Height = 21
        MaxLength = 30
        TabOrder = 9
      end
      object edbuildnum: TEdit
        Left = 159
        Top = 231
        Width = 190
        Height = 21
        MaxLength = 30
        TabOrder = 10
      end
      object edflatnum: TEdit
        Left = 159
        Top = 257
        Width = 190
        Height = 21
        MaxLength = 30
        TabOrder = 11
      end
      object edStreet: TEdit
        Left = 159
        Top = 179
        Width = 301
        Height = 21
        TabStop = False
        Color = clBtnFace
        MaxLength = 100
        ReadOnly = True
        TabOrder = 7
      end
      object btCallStreet: TBitBtn
        Left = 460
        Top = 179
        Width = 21
        Height = 21
        Hint = 'Выбрать'
        Caption = '...'
        TabOrder = 8
        OnClick = btCallStreetClick
      end
      object edTypeLive: TEdit
        Left = 159
        Top = 155
        Width = 301
        Height = 21
        TabStop = False
        Color = clBtnFace
        MaxLength = 100
        ReadOnly = True
        TabOrder = 5
      end
      object btCallTypeLive: TBitBtn
        Left = 460
        Top = 155
        Width = 21
        Height = 21
        Hint = 'Выбрать'
        Caption = '...'
        TabOrder = 6
        OnClick = btCallTypeLiveClick
      end
    end
    object TSDiplom: TTabSheet
      Caption = 'TSDiplom'
      ImageIndex = 3
      TabVisible = False
      object Label4: TLabel
        Left = 25
        Top = 2
        Width = 457
        Height = 26
        Caption = 
          'Образование. Укажите образование нового сотрудника: Вид образова' +
          'ния, '#13#10'  специальность, вид обучения, квалификация и т.п.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label7: TLabel
        Left = 125
        Top = 177
        Width = 37
        Height = 13
        Caption = 'Номер:'
      end
      object Label8: TLabel
        Left = 93
        Top = 205
        Width = 69
        Height = 13
        Caption = 'Дата выдачи:'
      end
      object lbProfession: TLabel
        Left = 81
        Top = 46
        Width = 81
        Height = 13
        Caption = 'Специальность:'
      end
      object lbTypeStud: TLabel
        Left = 91
        Top = 72
        Width = 71
        Height = 13
        Caption = 'Вид обучения:'
      end
      object lbEduc: TLabel
        Left = 71
        Top = 99
        Width = 91
        Height = 13
        Caption = 'Вид образования:'
      end
      object lbCraft: TLabel
        Left = 84
        Top = 125
        Width = 78
        Height = 13
        Caption = 'Квалификация:'
      end
      object lbFinishDate: TLabel
        Left = 77
        Top = 231
        Width = 85
        Height = 13
        Caption = 'Дата окончания:'
      end
      object lbSchool: TLabel
        Left = 59
        Top = 151
        Width = 103
        Height = 13
        Caption = 'Учебное заведение:'
      end
      object edNum: TEdit
        Left = 171
        Top = 173
        Width = 190
        Height = 21
        MaxLength = 30
        TabOrder = 10
      end
      object dtpDiplomDateWhere: TDateTimePicker
        Left = 171
        Top = 200
        Width = 94
        Height = 22
        CalAlignment = dtaLeft
        Date = 37156
        Time = 37156
        DateFormat = dfShort
        DateMode = dmComboBox
        Kind = dtkDate
        ParseInput = False
        TabOrder = 11
      end
      object edProfession: TEdit
        Left = 171
        Top = 42
        Width = 291
        Height = 21
        TabStop = False
        Color = clBtnFace
        MaxLength = 100
        ReadOnly = True
        TabOrder = 0
      end
      object btCallProfession: TBitBtn
        Left = 462
        Top = 42
        Width = 21
        Height = 21
        Hint = 'Выбрать'
        Caption = '...'
        TabOrder = 1
        OnClick = btCallProfessionClick
      end
      object edTypeStud: TEdit
        Left = 171
        Top = 68
        Width = 291
        Height = 21
        TabStop = False
        Color = clBtnFace
        MaxLength = 100
        ReadOnly = True
        TabOrder = 2
      end
      object btCallTypeStud: TBitBtn
        Left = 462
        Top = 69
        Width = 21
        Height = 21
        Hint = 'Выбрать'
        Caption = '...'
        TabOrder = 3
        OnClick = btCallTypeStudClick
      end
      object edEduc: TEdit
        Left = 171
        Top = 95
        Width = 291
        Height = 21
        TabStop = False
        Color = clBtnFace
        MaxLength = 100
        ReadOnly = True
        TabOrder = 4
      end
      object btCallEduc: TBitBtn
        Left = 462
        Top = 95
        Width = 21
        Height = 21
        Hint = 'Выбрать'
        Caption = '...'
        TabOrder = 5
        OnClick = btCallEducClick
      end
      object edCraft: TEdit
        Left = 171
        Top = 121
        Width = 291
        Height = 21
        TabStop = False
        Color = clBtnFace
        MaxLength = 100
        ReadOnly = True
        TabOrder = 6
      end
      object btCallCraft: TBitBtn
        Left = 462
        Top = 122
        Width = 21
        Height = 21
        Hint = 'Выбрать'
        Caption = '...'
        TabOrder = 7
        OnClick = btCallCraftClick
      end
      object dtpFinishDate: TDateTimePicker
        Left = 171
        Top = 226
        Width = 95
        Height = 22
        CalAlignment = dtaLeft
        Date = 37156
        Time = 37156
        DateFormat = dfShort
        DateMode = dmComboBox
        Kind = dtkDate
        ParseInput = False
        TabOrder = 12
      end
      object edSchool: TEdit
        Left = 171
        Top = 147
        Width = 291
        Height = 21
        TabStop = False
        Color = clBtnFace
        MaxLength = 100
        ReadOnly = True
        TabOrder = 8
      end
      object btCallSchool: TBitBtn
        Left = 462
        Top = 147
        Width = 21
        Height = 21
        Hint = 'Выбрать'
        Caption = '...'
        TabOrder = 9
        OnClick = btCallSchoolClick
      end
    end
    object TSEmpPlant: TTabSheet
      Caption = 'TSEmpPlant'
      ImageIndex = 4
      TabVisible = False
      object lbCategory: TLabel
        Left = 109
        Top = 116
        Width = 56
        Height = 13
        Caption = 'Категория:'
      end
      object lbNet: TLabel
        Left = 132
        Top = 38
        Width = 33
        Height = 13
        Caption = 'Сетка:'
      end
      object lbClass: TLabel
        Left = 125
        Top = 63
        Width = 40
        Height = 13
        Caption = 'Разряд:'
      end
      object lbReasonDocum: TLabel
        Left = 46
        Top = 89
        Width = 119
        Height = 13
        Caption = 'На основании приказа:'
      end
      object lbSeat: TLabel
        Left = 104
        Top = 142
        Width = 61
        Height = 13
        Caption = 'Должность:'
      end
      object lbDepart: TLabel
        Left = 131
        Top = 168
        Width = 34
        Height = 13
        Caption = 'Отдел:'
      end
      object lbOrderDocum: TLabel
        Left = 65
        Top = 194
        Width = 100
        Height = 13
        Caption = 'Приказ о принятии:'
      end
      object lbProf: TLabel
        Left = 104
        Top = 220
        Width = 61
        Height = 13
        Caption = 'Профессия:'
      end
      object lbschedule: TLabel
        Left = 124
        Top = 246
        Width = 41
        Height = 13
        Caption = 'График:'
      end
      object lbDateStart: TLabel
        Left = 17
        Top = 272
        Width = 148
        Height = 13
        Caption = 'Дата поступления на работу:'
      end
      object Label9: TLabel
        Left = 45
        Top = 2
        Width = 452
        Height = 26
        Caption = 
          'Место работы. Укажите должность нового сотрудника, его рабочий о' +
          'тдел '#13#10'  график, сетку, категорию и т.п.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object edNet: TEdit
        Left = 173
        Top = 35
        Width = 281
        Height = 21
        TabStop = False
        Color = clBtnFace
        MaxLength = 100
        ReadOnly = True
        TabOrder = 0
      end
      object btCallNet: TBitBtn
        Left = 454
        Top = 35
        Width = 21
        Height = 21
        Hint = 'Выбрать'
        Caption = '...'
        TabOrder = 1
        OnClick = btCallNetClick
      end
      object edClass: TEdit
        Left = 173
        Top = 60
        Width = 281
        Height = 21
        TabStop = False
        Color = clBtnFace
        MaxLength = 100
        ReadOnly = True
        TabOrder = 2
      end
      object btCallClass: TBitBtn
        Left = 454
        Top = 60
        Width = 21
        Height = 21
        Hint = 'Выбрать'
        Caption = '...'
        TabOrder = 3
        OnClick = btCallClassClick
      end
      object edReasonDocum: TEdit
        Left = 173
        Top = 86
        Width = 281
        Height = 21
        TabStop = False
        Color = clBtnFace
        MaxLength = 100
        ReadOnly = True
        TabOrder = 4
      end
      object btCallReasonDocum: TBitBtn
        Left = 454
        Top = 86
        Width = 21
        Height = 21
        Hint = 'Выбрать'
        Caption = '...'
        TabOrder = 5
      end
      object edCategory: TEdit
        Left = 173
        Top = 112
        Width = 281
        Height = 21
        TabStop = False
        Color = clBtnFace
        MaxLength = 100
        ReadOnly = True
        TabOrder = 6
      end
      object btCallCategory: TBitBtn
        Left = 454
        Top = 112
        Width = 21
        Height = 21
        Hint = 'Выбрать'
        Caption = '...'
        TabOrder = 7
        OnClick = btCallCategoryClick
      end
      object edSeat: TEdit
        Left = 173
        Top = 138
        Width = 281
        Height = 21
        TabStop = False
        Color = clBtnFace
        MaxLength = 100
        ReadOnly = True
        TabOrder = 8
      end
      object btCallSeat: TBitBtn
        Left = 454
        Top = 138
        Width = 21
        Height = 21
        Hint = 'Выбрать'
        Caption = '...'
        TabOrder = 9
        OnClick = btCallSeatClick
      end
      object edDepart: TEdit
        Left = 173
        Top = 164
        Width = 281
        Height = 21
        TabStop = False
        Color = clBtnFace
        MaxLength = 100
        ReadOnly = True
        TabOrder = 10
      end
      object btCallDepart: TBitBtn
        Left = 454
        Top = 164
        Width = 21
        Height = 21
        Hint = 'Выбрать'
        Caption = '...'
        TabOrder = 11
        OnClick = btCallDepartClick
      end
      object edOrderDocum: TEdit
        Left = 173
        Top = 190
        Width = 281
        Height = 21
        TabStop = False
        Color = clBtnFace
        MaxLength = 100
        ReadOnly = True
        TabOrder = 12
      end
      object btCallOrderDocum: TBitBtn
        Left = 454
        Top = 190
        Width = 21
        Height = 21
        Hint = 'Выбрать'
        Caption = '...'
        TabOrder = 13
        OnClick = btCallOrderDocumClick
      end
      object edProf: TEdit
        Left = 173
        Top = 216
        Width = 281
        Height = 21
        TabStop = False
        Color = clBtnFace
        MaxLength = 100
        ReadOnly = True
        TabOrder = 14
      end
      object btCallProf: TBitBtn
        Left = 454
        Top = 216
        Width = 21
        Height = 21
        Hint = 'Выбрать'
        Caption = '...'
        TabOrder = 15
        OnClick = btCallProfClick
      end
      object edschedule: TEdit
        Left = 173
        Top = 242
        Width = 281
        Height = 21
        TabStop = False
        Color = clBtnFace
        MaxLength = 100
        ReadOnly = True
        TabOrder = 16
      end
      object btCallschedule: TBitBtn
        Left = 454
        Top = 242
        Width = 21
        Height = 21
        Hint = 'Выбрать'
        Caption = '...'
        TabOrder = 17
        OnClick = btCallscheduleClick
      end
      object dtpDateStart: TDateTimePicker
        Left = 173
        Top = 265
        Width = 94
        Height = 22
        CalAlignment = dtaLeft
        Date = 37156
        Time = 37156
        DateFormat = dfShort
        DateMode = dmComboBox
        Kind = dtkDate
        ParseInput = False
        TabOrder = 18
      end
    end
  end
  object ReadIBQ: TIBQuery
    Transaction = IBTRead
    BufferChunks = 1000
    CachedUpdates = False
    Left = 392
    Top = 103
  end
  object IBTRead: TIBTransaction
    Active = False
    DefaultAction = TARollback
    Left = 424
    Top = 103
  end
  object WriteIBQ: TIBQuery
    Transaction = IBTWrite
    BufferChunks = 1000
    CachedUpdates = False
    Left = 496
    Top = 135
  end
  object IBTWrite: TIBTransaction
    Active = False
    DefaultAction = TARollback
    Left = 496
    Top = 103
  end
end
