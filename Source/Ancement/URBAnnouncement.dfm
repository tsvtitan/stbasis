inherited fmRBAnnouncement: TfmRBAnnouncement
  Left = 314
  Top = 161
  Caption = 'Объявления'
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000000000000000000000000000000000000000000FFFFFFF00000
    0000F00F00F000000FF0FFFFFFF000000F00F00F00F000FF0FF0FFFFFFF000F0
    0F00F00F00F000FF0FF0FFFFFFF000F00F000000000000FF0FFFFFFF000000F0
    00000000000000FFFFFFF000000000000000000000000000000000000000FFFF
    0000FFFF0000FE000000FE000000F0000000F000000080000000800000008000
    000080000000800000008007000080070000803F0000803F0000FFFF0000}
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBackGrid: TPanel
    inherited pnBut: TPanel
      inherited pnModal: TPanel
        inherited bibView: TButton
          OnClick = bibViewClick
        end
      end
      inherited pnSQL: TPanel
        inherited bibAdd: TButton
          Top = 0
          Height = 26
          OnClick = bibAddClick
        end
        inherited bibChange: TButton
          Top = 33
          OnClick = bibChangeClick
        end
        inherited bibDel: TButton
          Top = 65
          OnClick = bibDelClick
        end
      end
    end
    inherited pnGrid: TPanel
      object spl: TSplitter
        Left = 5
        Top = 162
        Width = 368
        Height = 3
        Cursor = crSizeNS
        Align = alBottom
        MinSize = 85
        OnMoved = splMoved
      end
      object pnTreePath: TPanel
        Left = 5
        Top = 238
        Width = 368
        Height = 28
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
        object lbTreePath: TLabel
          Left = 8
          Top = 9
          Width = 94
          Height = 13
          Anchors = [akLeft, akBottom]
          Caption = 'Путь рубрикатора:'
        end
        object edTreePath: TDBEdit
          Left = 110
          Top = 6
          Width = 243
          Height = 21
          Color = clBtnFace
          DataSource = ds
          ReadOnly = True
          TabOrder = 0
        end
      end
      object pnDouble: TPanel
        Left = 5
        Top = 165
        Width = 368
        Height = 73
        Align = alBottom
        BevelOuter = bvNone
        Constraints.MinHeight = 50
        TabOrder = 0
        object pnDoubleBut: TPanel
          Left = 297
          Top = 0
          Width = 71
          Height = 73
          Align = alRight
          BevelOuter = bvNone
          TabOrder = 0
          object bibDoubleDel: TButton
            Left = 5
            Top = 5
            Width = 65
            Height = 21
            Hint = 'Удалить'
            Anchors = [akTop, akRight]
            Caption = 'Удалить'
            TabOrder = 0
            OnClick = bibDoubleDelClick
          end
          object bibDoubleAdjust: TButton
            Left = 5
            Top = 32
            Width = 65
            Height = 21
            Anchors = [akTop, akRight]
            Caption = 'Настройка'
            TabOrder = 1
            OnClick = bibDoubleAdjustClick
          end
        end
      end
    end
  end
  inherited pnFind: TPanel
    inherited edSearch: TEdit
      Anchors = [akLeft, akTop, akBottom]
    end
  end
  inherited Mainqr: TIBQuery
    AfterScroll = MainqrAfterScroll
    CachedUpdates = True
    UpdateObject = IBUpd
  end
  object dsDouble: TDataSource
    DataSet = qrDouble
    Left = 101
    Top = 188
  end
  object qrDouble: TIBQuery
    Transaction = trDouble
    BufferChunks = 20
    CachedUpdates = True
    UpdateObject = updDouble
    Left = 141
    Top = 188
  end
  object trDouble: TIBTransaction
    Active = False
    DefaultAction = TARollback
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    AutoStopAction = saNone
    Left = 181
    Top = 188
  end
  object updDouble: TIBUpdateSQL
    Left = 224
    Top = 188
  end
end
