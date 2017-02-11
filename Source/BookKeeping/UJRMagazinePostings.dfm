inherited fmJRMagazinePostings: TfmJRMagazinePostings
  Left = 351
  Top = 108
  Caption = 'Журнал проводок'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnMain: TPanel
    inherited pnBut: TPanel
      inherited pnModal: TPanel
        Top = 101
        Height = 143
        inherited bibRefresh: TBitBtn
          OnClick = bibRefreshClick
        end
        object bibView: TBitBtn
          Left = 8
          Top = 40
          Width = 75
          Height = 25
          Hint = 'Подробнее (F6)'
          Caption = 'Подробнее'
          TabOrder = 4
          OnClick = bibViewClick
          OnKeyDown = FormKeyDown
        end
      end
      object pnSQL: TPanel
        Left = 0
        Top = 0
        Width = 89
        Height = 101
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object bibAdd: TBitBtn
          Left = 8
          Top = 1
          Width = 75
          Height = 25
          Hint = 'Добавить (F2)'
          Caption = 'Добавить'
          TabOrder = 0
          OnClick = bibAddClick
          OnKeyDown = FormKeyDown
        end
        object bibChange: TBitBtn
          Left = 8
          Top = 33
          Width = 75
          Height = 25
          Hint = 'Изменить (F3)'
          Caption = 'Изменить'
          TabOrder = 1
          OnClick = bibChangeClick
          OnKeyDown = FormKeyDown
        end
        object bibDel: TBitBtn
          Left = 8
          Top = 65
          Width = 75
          Height = 25
          Hint = 'Удалить (F4)'
          Caption = 'Удалить'
          TabOrder = 2
          OnClick = bibDelClick
          OnKeyDown = FormKeyDown
        end
      end
    end
    inherited pnGrid: TPanel
      Height = 129
      Align = alNone
    end
    object PHeader: TPanel
      Left = 0
      Top = 124
      Width = 373
      Height = 60
      TabOrder = 2
      object Label2: TLabel
        Left = 4
        Top = 5
        Width = 51
        Height = 13
        Caption = 'Документ'
      end
      object Label3: TLabel
        Left = 4
        Top = 21
        Width = 32
        Height = 13
        Caption = '№ док'
      end
      object Label4: TLabel
        Left = 64
        Top = 21
        Width = 38
        Height = 13
        Caption = '№ пров'
      end
      object Label5: TLabel
        Left = 5
        Top = 37
        Width = 26
        Height = 13
        Caption = 'Дата'
      end
      object Label6: TLabel
        Left = 64
        Top = 37
        Width = 33
        Height = 13
        Caption = 'Время'
      end
      object Label7: TLabel
        Left = 184
        Top = 5
        Width = 32
        Height = 13
        Caption = 'Дебет'
      end
      object Label14: TLabel
        Left = 336
        Top = 5
        Width = 36
        Height = 13
        Caption = 'Кредит'
      end
      object Label15: TLabel
        Left = 472
        Top = 2
        Width = 50
        Height = 13
        Caption = 'Операция'
      end
      object Label16: TLabel
        Left = 472
        Top = 14
        Width = 50
        Height = 13
        Caption = 'Проводка'
      end
      object Label17: TLabel
        Left = 473
        Top = 27
        Width = 34
        Height = 13
        Caption = 'Кол-во'
      end
      object Label18: TLabel
        Left = 472
        Top = 43
        Width = 34
        Height = 13
        Caption = 'Сумма'
      end
      object Label19: TLabel
        Left = 529
        Top = 28
        Width = 38
        Height = 13
        Caption = 'Валюта'
      end
      object lbCapDSub: TListBox
        Left = 183
        Top = 20
        Width = 138
        Height = 39
        BorderStyle = bsNone
        Color = clScrollBar
        ItemHeight = 13
        TabOrder = 0
      end
      object lbCapKSub: TListBox
        Left = 334
        Top = 18
        Width = 135
        Height = 39
        BorderStyle = bsNone
        Color = clScrollBar
        ItemHeight = 13
        TabOrder = 1
      end
    end
    object PData: TPanel
      Left = 0
      Top = 181
      Width = 373
      Height = 60
      TabOrder = 3
      object LDok: TLabel
        Left = 4
        Top = 5
        Width = 3
        Height = 13
        Constraints.MaxWidth = 177
        ParentShowHint = False
        ShowHint = True
      end
      object LNumDok: TLabel
        Left = 4
        Top = 21
        Width = 3
        Height = 13
        Constraints.MaxWidth = 57
        ParentShowHint = False
        ShowHint = True
      end
      object LNumPost: TLabel
        Left = 64
        Top = 21
        Width = 3
        Height = 13
        Constraints.MaxWidth = 117
        ParentShowHint = False
        ShowHint = True
      end
      object LDate: TLabel
        Left = 4
        Top = 37
        Width = 3
        Height = 13
        Constraints.MaxWidth = 57
        ParentShowHint = False
        ShowHint = True
      end
      object LTime: TLabel
        Left = 64
        Top = 37
        Width = 3
        Height = 13
        Constraints.MaxWidth = 117
        ParentShowHint = False
        ShowHint = True
      end
      object LKredit: TLabel
        Left = 336
        Top = 5
        Width = 3
        Height = 13
        Constraints.MaxWidth = 133
        ParentShowHint = False
        ShowHint = True
      end
      object LOper: TLabel
        Left = 472
        Top = 5
        Width = 3
        Height = 13
        ParentShowHint = False
        ShowHint = True
      end
      object LPost: TLabel
        Left = 472
        Top = 17
        Width = 3
        Height = 13
        ParentShowHint = False
        ShowHint = True
      end
      object LCount: TLabel
        Left = 472
        Top = 30
        Width = 3
        Height = 13
        ParentShowHint = False
        ShowHint = True
      end
      object LSum: TLabel
        Left = 472
        Top = 42
        Width = 3
        Height = 13
        ParentShowHint = False
        ShowHint = True
      end
      object LCur: TLabel
        Left = 529
        Top = 28
        Width = 3
        Height = 13
        ParentShowHint = False
        ShowHint = True
      end
      object LDebit: TLabel
        Left = 185
        Top = 3
        Width = 3
        Height = 13
      end
      object lbDSub: TListBox
        Left = 183
        Top = 20
        Width = 138
        Height = 39
        BorderStyle = bsNone
        Color = clScrollBar
        ItemHeight = 13
        TabOrder = 0
      end
      object lbKSub: TListBox
        Left = 335
        Top = 20
        Width = 135
        Height = 39
        BorderStyle = bsNone
        Color = clScrollBar
        ItemHeight = 13
        TabOrder = 1
      end
    end
  end
  inherited Mainqr: TIBQuery
    AfterScroll = MainqrAfterScroll
    CachedUpdates = True
  end
  inherited IBUpd: TIBUpdateSQL
    Left = 256
    Top = 113
  end
end
