inherited fmOTSalary: TfmOTSalary
  Left = 111
  Top = 66
  Width = 812
  Height = 612
  Caption = 'Начисление зарплаты'
  Constraints.MinHeight = 480
  Constraints.MinWidth = 600
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000000000000000000000000000000000022222222000000000000
    0000207000002222222200770000000000002037700000A2AA2A00330000000A
    AAAAA033200000000000003302000000FBBBBBB3202000000000000002000000
    000A2AA2A020000000000000000000000000000000000000000000000000FFFF
    0000FFFF000000FF0000007F0000001F0000000F00000007000080070000C003
    0000E0010000F0010000F8010000FC010000FE010000FFFF0000FFFF0000}
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBackGrid: TPanel
    Width = 804
    Height = 522
    inherited pnBut: TPanel
      Left = 715
      Height = 522
      Visible = False
      inherited pnModal: TPanel
        Height = 421
        inherited bibView: TBitBtn
          OnClick = bibViewClick
        end
        inherited bibRefresh: TBitBtn
          OnClick = bibRefreshClick
        end
      end
    end
    inherited pnGrid: TPanel
      Width = 715
      Height = 522
      BorderWidth = 5
      object splTop: TSplitter
        Left = 5
        Top = 145
        Width = 705
        Height = 3
        Cursor = crSizeNS
        Align = alTop
      end
      object Splitter1: TSplitter
        Left = 5
        Top = 258
        Width = 705
        Height = 3
        Cursor = crSizeNS
        Align = alTop
        MinSize = 100
      end
      object grbEmpPlant: TGroupBox
        Left = 5
        Top = 148
        Width = 705
        Height = 110
        Align = alTop
        Caption = ' Места работы сотрудников '
        Constraints.MinHeight = 110
        TabOrder = 0
        object pnGridEmpPlant: TPanel
          Left = 2
          Top = 15
          Width = 701
          Height = 93
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 5
          TabOrder = 0
          object pnButEmpPlant: TPanel
            Left = 612
            Top = 5
            Width = 84
            Height = 83
            Align = alRight
            BevelOuter = bvNone
            TabOrder = 0
            object bibEmpPlantRefresh: TBitBtn
              Left = 9
              Top = 0
              Width = 75
              Height = 25
              Hint = 'Обновить (F5)'
              Caption = 'Обновить'
              TabOrder = 0
              OnClick = bibEmpPlantRefreshClick
              OnKeyDown = FormKeyDown
            end
            object bibEmpPlantView: TBitBtn
              Left = 9
              Top = 29
              Width = 75
              Height = 25
              Hint = 'Подробнее (F6)'
              Caption = 'Подробнее'
              TabOrder = 1
              OnClick = bibEmpPlantViewClick
              OnKeyDown = FormKeyDown
            end
            object bibEmpPlantAdjust: TBitBtn
              Left = 9
              Top = 58
              Width = 75
              Height = 25
              Hint = 'Настройка (F8)'
              Caption = 'Настройка'
              TabOrder = 2
              OnClick = bibEmpPlantAdjustClick
              OnKeyDown = FormKeyDown
            end
          end
        end
      end
      object grbEmp: TGroupBox
        Left = 5
        Top = 5
        Width = 705
        Height = 140
        Align = alTop
        Caption = ' Сотрудники '
        Constraints.MinHeight = 140
        TabOrder = 1
        object pnGridEmp: TPanel
          Left = 2
          Top = 15
          Width = 701
          Height = 123
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 5
          TabOrder = 0
          object pnButEmp: TPanel
            Left = 612
            Top = 5
            Width = 84
            Height = 113
            Align = alRight
            BevelOuter = bvNone
            TabOrder = 0
            object bibEmpRefresh: TBitBtn
              Left = 9
              Top = 0
              Width = 75
              Height = 25
              Hint = 'Обновить (F5)'
              Caption = 'Обновить'
              TabOrder = 0
              OnClick = bibRefreshClick
              OnKeyDown = FormKeyDown
            end
            object bibEmpView: TBitBtn
              Left = 9
              Top = 29
              Width = 75
              Height = 25
              Hint = 'Подробнее (F6)'
              Caption = 'Подробнее'
              TabOrder = 1
              OnClick = bibViewClick
              OnKeyDown = FormKeyDown
            end
            object bibEmpFilter: TBitBtn
              Left = 9
              Top = 58
              Width = 75
              Height = 25
              Hint = 'Фильтр (F7)'
              Caption = 'Фильтр'
              TabOrder = 2
              OnClick = bibFilterClick
              OnKeyDown = FormKeyDown
            end
            object bibEmpAdjust: TBitBtn
              Left = 9
              Top = 87
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
      end
      object grbSalary: TGroupBox
        Left = 5
        Top = 261
        Width = 705
        Height = 256
        Align = alClient
        Caption = ' Зарплата '
        Constraints.MinHeight = 100
        TabOrder = 2
        object pnGridSalary: TPanel
          Left = 2
          Top = 15
          Width = 701
          Height = 239
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 5
          TabOrder = 0
          object pnButSalary: TPanel
            Left = 612
            Top = 5
            Width = 84
            Height = 205
            Align = alRight
            BevelOuter = bvNone
            TabOrder = 0
            object bibCalcItogy: TBitBtn
              Left = 9
              Top = 133
              Width = 75
              Height = 25
              Hint = 'Пересчитать'
              Caption = 'Пересчитать'
              TabOrder = 0
              OnClick = bibCalcItogyClick
              OnKeyDown = FormKeyDown
            end
            object BitBtn12: TBitBtn
              Left = 9
              Top = 108
              Width = 75
              Height = 25
              Hint = 'Настройка (F8)'
              Caption = 'Настройка'
              TabOrder = 1
              OnClick = BitBtn12Click
              OnKeyDown = FormKeyDown
            end
            object BitBtn9: TBitBtn
              Left = 9
              Top = 83
              Width = 75
              Height = 25
              Hint = 'Обновить (F5)'
              Caption = 'Обновить'
              TabOrder = 2
              OnClick = Button2Click
              OnKeyDown = FormKeyDown
            end
            object BitBtn1: TBitBtn
              Left = 9
              Top = 8
              Width = 75
              Height = 25
              Caption = 'Добавить'
              TabOrder = 3
              OnClick = BitBtn1Click
              OnKeyDown = FormKeyDown
            end
            object BitBtn2: TBitBtn
              Left = 9
              Top = 33
              Width = 75
              Height = 25
              Caption = 'Изменить'
              TabOrder = 4
              OnKeyDown = FormKeyDown
            end
            object bibDelete: TBitBtn
              Left = 9
              Top = 58
              Width = 75
              Height = 25
              Hint = 'Фильтр (F7)'
              Caption = 'Удалить'
              TabOrder = 5
              OnClick = bibDeleteClick
              OnKeyDown = FormKeyDown
            end
          end
          object PC2: TPageControl
            Left = 5
            Top = 5
            Width = 607
            Height = 205
            ActivePage = TSChargeOn
            Align = alClient
            TabOrder = 1
            OnChange = Button2Click
            object TSChargeOn: TTabSheet
              Caption = 'Начисления'
            end
            object TSChargeOff: TTabSheet
              Caption = 'Удержания'
              ImageIndex = 1
            end
            object TSChargeConst: TTabSheet
              Caption = 'Постоянные начисления и удержания'
              ImageIndex = 2
            end
            object TabSheet1: TTabSheet
              Caption = 'Карточка сотрудника'
              ImageIndex = 4
              object Label6: TLabel
                Left = 8
                Top = 16
                Width = 21
                Height = 13
                Caption = 'ЕТС'
              end
              object Label7: TLabel
                Left = 8
                Top = 37
                Width = 170
                Height = 13
                Caption = 'Совокупный доход с начала года:'
              end
              object Label8: TLabel
                Left = 8
                Top = 58
                Width = 106
                Height = 13
                Caption = 'Льгот с начала года:'
              end
              object Label9: TLabel
                Left = 8
                Top = 79
                Width = 84
                Height = 13
                Caption = 'Норма времени:'
              end
              object Label10: TLabel
                Left = 8
                Top = 99
                Width = 78
                Height = 13
                Caption = 'Факт времени:'
              end
              object Label12: TLabel
                Left = 280
                Top = 87
                Width = 30
                Height = 13
                Caption = 'День:'
              end
              object Label11: TLabel
                Left = 365
                Top = 87
                Width = 33
                Height = 13
                Caption = 'Вечер:'
              end
              object Label13: TLabel
                Left = 452
                Top = 87
                Width = 28
                Height = 13
                Caption = 'Ночь:'
              end
              object cedOklad: TCurrencyEdit
                Left = 184
                Top = 11
                Width = 89
                Height = 21
                AutoSize = False
                Color = clBtnFace
                ReadOnly = True
                TabOrder = 0
              end
              object CurrencyEdit4: TCurrencyEdit
                Left = 184
                Top = 32
                Width = 89
                Height = 21
                AutoSize = False
                Color = clBtnFace
                ReadOnly = True
                TabOrder = 1
              end
              object cePrivelege: TCurrencyEdit
                Left = 184
                Top = 53
                Width = 89
                Height = 21
                AutoSize = False
                Color = clBtnFace
                ReadOnly = True
                TabOrder = 2
              end
              object cedNorma: TCurrencyEdit
                Left = 184
                Top = 74
                Width = 89
                Height = 21
                AutoSize = False
                Color = clBtnFace
                DisplayFormat = ',0.00;-,0.00'
                ReadOnly = True
                TabOrder = 3
              end
              object cedFact: TCurrencyEdit
                Left = 184
                Top = 94
                Width = 89
                Height = 21
                AutoSize = False
                Color = clBtnFace
                DisplayFormat = ',0.00;-,0.00'
                ReadOnly = True
                TabOrder = 4
              end
              object Button1: TButton
                Left = 285
                Top = 52
                Width = 75
                Height = 22
                Caption = 'Подробнее'
                TabOrder = 5
                OnClick = Button1Click
              end
              object ceNormDay: TCurrencyEdit
                Left = 315
                Top = 74
                Width = 45
                Height = 21
                AutoSize = False
                Color = clBtnFace
                DisplayFormat = ',0.00;-,0.00'
                ReadOnly = True
                TabOrder = 6
              end
              object ceFactDay: TCurrencyEdit
                Left = 315
                Top = 94
                Width = 45
                Height = 21
                AutoSize = False
                Color = clBtnFace
                DisplayFormat = ',0.00;-,0.00'
                ReadOnly = True
                TabOrder = 7
              end
              object ceNormNight: TCurrencyEdit
                Left = 485
                Top = 74
                Width = 45
                Height = 21
                AutoSize = False
                Color = clBtnFace
                DisplayFormat = ',0.00;-,0.00'
                ReadOnly = True
                TabOrder = 8
              end
              object ceFactNight: TCurrencyEdit
                Left = 485
                Top = 94
                Width = 45
                Height = 21
                AutoSize = False
                Color = clBtnFace
                DisplayFormat = ',0.00;-,0.00'
                ReadOnly = True
                TabOrder = 9
              end
              object ceNormEvening: TCurrencyEdit
                Left = 400
                Top = 74
                Width = 45
                Height = 21
                AutoSize = False
                Color = clBtnFace
                DisplayFormat = ',0.00;-,0.00'
                ReadOnly = True
                TabOrder = 10
              end
              object ceFactEvening: TCurrencyEdit
                Left = 400
                Top = 94
                Width = 45
                Height = 21
                AutoSize = False
                Color = clBtnFace
                DisplayFormat = ',0.00;-,0.00'
                ReadOnly = True
                TabOrder = 11
              end
              object Button2: TButton
                Left = 440
                Top = 136
                Width = 75
                Height = 25
                Caption = 'Button2'
                TabOrder = 12
                TabStop = False
                Visible = False
                OnClick = Button2Click
              end
            end
          end
          object Panel1: TPanel
            Left = 5
            Top = 210
            Width = 691
            Height = 24
            Align = alBottom
            TabOrder = 2
            object Label3: TLabel
              Left = 4
              Top = 4
              Width = 89
              Height = 13
              Caption = 'Всего начислено:'
            end
            object Label4: TLabel
              Left = 191
              Top = 5
              Width = 85
              Height = 13
              Caption = 'Всего удержано:'
            end
            object Label5: TLabel
              Left = 376
              Top = 6
              Width = 50
              Height = 13
              Caption = 'К выдаче:'
            end
            object cedSummaOn: TCurrencyEdit
              Left = 96
              Top = 1
              Width = 89
              Height = 21
              AutoSize = False
              Color = clBtnFace
              TabOrder = 0
            end
            object cedSummaOff: TCurrencyEdit
              Left = 280
              Top = 1
              Width = 89
              Height = 21
              AutoSize = False
              Color = clBtnFace
              TabOrder = 1
            end
            object cedItog: TCurrencyEdit
              Left = 430
              Top = 1
              Width = 89
              Height = 21
              AutoSize = False
              Color = clBtnFace
              TabOrder = 2
            end
          end
        end
      end
    end
  end
  inherited pnFind: TPanel
    Width = 804
    inherited Label1: TLabel
      Left = 348
    end
    object Label2: TLabel [1]
      Left = 12
      Top = 9
      Width = 41
      Height = 13
      Caption = 'Период:'
    end
    inherited edSearch: TEdit
      Left = 389
      Anchors = [akLeft, akTop, akBottom]
    end
    object edCalcPeriod: TEdit
      Left = 56
      Top = 7
      Width = 169
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 1
      OnChange = edCalcPeriodChange
    end
    object bibCalcPeriod: TBitBtn
      Left = 225
      Top = 7
      Width = 21
      Height = 21
      Hint = 'Выбрать'
      Caption = '...'
      TabOrder = 2
      OnClick = bibCalcPeriodClick
    end
    object bibCurCalcPeriod: TBitBtn
      Left = 249
      Top = 7
      Width = 72
      Height = 21
      Hint = 'Выбрать'
      Caption = 'Текущий'
      TabOrder = 3
      OnClick = bibCurCalcPeriodClick
    end
  end
  inherited pnBottom: TPanel
    Top = 555
    Width = 804
    Height = 30
    inherited lbCount: TLabel
      Top = 6
    end
    inherited bibOk: TBitBtn
      Left = 644
      Top = 0
    end
    inherited DBNav: TDBNavigator
      Top = 3
    end
    inherited bibClose: TBitBtn
      Left = 726
      Top = 0
    end
  end
  inherited ds: TDataSource
    Left = 104
    Top = 56
  end
  inherited Mainqr: TIBQuery
    AfterScroll = MainqrAfterScroll
    Left = 72
    Top = 56
  end
  inherited IBTran: TIBTransaction
    Left = 40
    Top = 57
  end
  object ibtranEmpPlant: TIBTransaction
    Active = False
    DefaultAction = TARollback
    Left = 24
    Top = 209
  end
  object qrEmpPlant: TIBQuery
    Transaction = ibtranEmpPlant
    AfterScroll = qrEmpPlantAfterScroll
    BufferChunks = 1000
    CachedUpdates = False
    Left = 88
    Top = 208
  end
  object dsEmpPlant: TDataSource
    AutoEdit = False
    DataSet = qrEmpPlant
    Left = 136
    Top = 208
  end
  object ibtranChargeOn: TIBTransaction
    Active = False
    DefaultAction = TARollback
    Left = 384
    Top = 217
  end
  object dsChargeEmpPlantOn: TDataSource
    AutoEdit = False
    DataSet = qrChargeOn
    Left = 600
    Top = 416
  end
  object qrChargeOn: TIBQuery
    Transaction = ibtranChargeOn
    BufferChunks = 1000
    CachedUpdates = False
    Left = 432
    Top = 216
  end
  object ibtranChargeOff: TIBTransaction
    Active = False
    DefaultAction = TARollback
    Left = 504
    Top = 345
  end
  object qrChargeOff: TIBQuery
    Transaction = ibtranChargeOff
    BufferChunks = 1000
    CachedUpdates = False
    Left = 552
    Top = 344
  end
  object dsChargeEmpPlantOff: TDataSource
    AutoEdit = False
    DataSet = qrChargeOff
    Left = 600
    Top = 344
  end
  object ibtranChargeConst: TIBTransaction
    Active = False
    DefaultAction = TARollback
    Left = 504
    Top = 377
  end
  object qrChargeConst: TIBQuery
    Transaction = ibtranChargeConst
    BufferChunks = 1000
    CachedUpdates = False
    Left = 544
    Top = 376
  end
  object dsChargeEmpPlantConst: TDataSource
    AutoEdit = False
    DataSet = qrChargeConst
    Left = 600
    Top = 384
  end
  object ibtUpdate: TIBTransaction
    Active = False
    DefaultAction = TARollback
    Left = 312
    Top = 217
  end
  object UpdateQr: TIBQuery
    BufferChunks = 1000
    CachedUpdates = False
    Left = 344
    Top = 216
  end
  object qrChargeSumm: TIBQuery
    BufferChunks = 1000
    CachedUpdates = False
    Left = 312
    Top = 248
  end
  object qrCharge: TIBQuery
    BufferChunks = 1000
    CachedUpdates = False
    Left = 328
    Top = 346
  end
  object ibtranCharge: TIBTransaction
    Active = False
    DefaultAction = TARollback
    Left = 352
    Top = 249
  end
  object qrPrivelege: TIBQuery
    Transaction = ibtranPrivelege
    BufferChunks = 1000
    CachedUpdates = False
    Left = 368
    Top = 346
  end
  object ibtranPrivelege: TIBTransaction
    Active = False
    DefaultAction = TARollback
    Left = 400
    Top = 338
  end
  object ibtranPrivelege1: TIBTransaction
    Active = False
    DefaultAction = TARollback
    Left = 456
    Top = 346
  end
  object qrPrivelege1: TIBQuery
    Transaction = ibtranPrivelege1
    BufferChunks = 1000
    CachedUpdates = False
    Left = 416
    Top = 346
  end
  object IBTranYearSumm: TIBTransaction
    Active = False
    Left = 231
    Top = 109
  end
  object qrYearSumm: TIBQuery
    BufferChunks = 1000
    CachedUpdates = False
    Left = 191
    Top = 109
  end
end
