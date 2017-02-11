inherited FmRbkExperiencePercent: TFmRbkExperiencePercent
  Left = 186
  Top = 103
  Width = 499
  Height = 437
  Caption = 'Проценты доплат от стажа'
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnFind: TPanel
    Width = 491
  end
  inherited PnOk: TPanel
    Top = 370
    Width = 491
    inherited BtOk: TBitBtn
      Left = 327
    end
    inherited BtClose: TButton
      Left = 410
    end
  end
  inherited PnWorkArea: TPanel
    Width = 491
    Height = 336
    inherited PnSqlBtn: TPanel
      Left = 404
      Height = 332
      inherited PnOption: TPanel
        Height = 227
      end
    end
    inherited PnGrid: TPanel
      Width = 402
      Height = 332
      object Spl: TSplitter
        Left = 0
        Top = 197
        Width = 402
        Height = 3
        Cursor = crVSplit
        Align = alBottom
      end
      object PnDetailGrid: TPanel
        Left = 0
        Top = 200
        Width = 402
        Height = 132
        Align = alBottom
        BevelInner = bvRaised
        BevelOuter = bvLowered
        Constraints.MinHeight = 130
        TabOrder = 0
        object Panel1: TPanel
          Left = 315
          Top = 2
          Width = 85
          Height = 128
          Align = alRight
          BevelOuter = bvNone
          TabOrder = 0
          object PnDetailBtns: TPanel
            Left = 0
            Top = 0
            Width = 85
            Height = 128
            Align = alRight
            BevelOuter = bvNone
            TabOrder = 0
            object BtPercInsert: TButton
              Left = 5
              Top = 7
              Width = 75
              Height = 25
              Caption = 'Добавить'
              TabOrder = 0
              OnClick = BtPercInsertClick
            end
            object BtPercEdit: TButton
              Left = 5
              Top = 37
              Width = 75
              Height = 25
              Caption = 'Изменить'
              TabOrder = 1
              OnClick = BtPercEditClick
            end
            object BtPercDel: TButton
              Left = 5
              Top = 67
              Width = 75
              Height = 25
              Caption = 'Удалить'
              TabOrder = 2
              OnClick = BtPercDelClick
            end
            object BtPercOptions: TButton
              Left = 5
              Top = 96
              Width = 75
              Height = 25
              Caption = 'Настройка'
              TabOrder = 3
              OnClick = BtPercOptionsClick
            end
          end
        end
      end
    end
  end
  inherited DS: TDataSource
    Left = 24
    Top = 66
  end
  inherited RbkQuery: TIBQuery
    AfterScroll = RbkQueryAfterScroll
    Left = 56
    Top = 66
  end
  inherited RbkTrans: TIBTransaction
    Left = 88
    Top = 66
  end
  object IBDetail: TIBQuery
    Transaction = IBTranDetail
    BufferChunks = 1000
    CachedUpdates = False
    Left = 58
    Top = 192
  end
  object IBTranDetail: TIBTransaction
    Active = False
    Left = 90
    Top = 192
  end
  object DetailDS: TDataSource
    DataSet = IBDetail
    Left = 26
    Top = 192
  end
end
