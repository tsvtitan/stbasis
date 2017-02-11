inherited FmRbkDepart: TFmRbkDepart
  Left = 253
  Top = 171
  Caption = 'Отделы'
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBottom: TPanel
    Top = 273
    Height = 40
    inherited lbCount: TLabel
      Top = 16
    end
    inherited btOk: TBitBtn
      Top = 10
      ModalResult = 1
    end
    inherited DBNav: TDBNavigator
      Top = 13
      Hints.Strings = (
        'Первая запись'
        'Предыдущая запись'
        'Следующая запись'
        'Последняя запись')
    end
    inherited btClose: TBitBtn
      Left = 382
      Top = 10
    end
  end
  inherited pnTV: TPanel
    Height = 240
    object PnFields: TPanel
      Left = 0
      Top = 184
      Width = 374
      Height = 56
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 0
      object Label2: TLabel
        Left = 7
        Top = 35
        Width = 22
        Height = 13
        Caption = 'Код:'
      end
      object Label3: TLabel
        Left = 6
        Top = 9
        Width = 22
        Height = 13
        Caption = 'Тип:'
      end
      object DBEdCode: TDBEdit
        Left = 38
        Top = 32
        Width = 117
        Height = 21
        Color = clMenu
        DataSource = DS
        ReadOnly = True
        TabOrder = 0
      end
      object DBEdFtype: TDBEdit
        Left = 38
        Top = 5
        Width = 117
        Height = 21
        Color = clMenu
        DataSource = DS
        ReadOnly = True
        TabOrder = 1
      end
    end
  end
  inherited PnBtns: TPanel
    Height = 240
    inherited pnSQL: TPanel
      inherited btInsert: TBitBtn
        OnClick = btInsertClick
      end
      inherited btEdit: TBitBtn
        OnClick = btEditClick
      end
      inherited btDel: TBitBtn
        OnClick = btDelClick
      end
    end
    inherited pnModal: TPanel
      Height = 139
      inherited btFilter: TBitBtn
        OnClick = btFilterClick
      end
      inherited btMore: TBitBtn
        OnClick = btMoreClick
      end
      inherited btRefresh: TBitBtn
        OnClick = btRefreshClick
      end
    end
  end
end
