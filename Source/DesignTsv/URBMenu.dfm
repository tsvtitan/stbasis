inherited fmRBMenu: TfmRBMenu
  Left = 503
  Top = 165
  Caption = 'Μενώ'
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    00000000000000000000000000000070000000000000007FFFFFFFFF0000007F
    444444FF000000744444444400000074FFFFFFF400000074444444440000007F
    444444FF0000007FFFFFFFFF0000007F4444FFFF0000007FFFFFFFFF0000007F
    44444FFF0000007FFFFFFFFF000000777777777770000000000000000000FFFF
    0000FFFF0000C0070000C0070000C0070000C0070000C0070000C0070000C007
    0000C0070000C0070000C0070000C0070000C0070000C0070000FFFF0000}
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnTreeViewBack: TPanel
    inherited pnBut: TPanel
      inherited pnModal: TPanel
        inherited bibView: TBitBtn
          OnClick = bibViewClick
        end
        inherited bibRefresh: TBitBtn
          OnClick = bibRefreshClick
        end
      end
      inherited pnSQL: TPanel
        inherited bibAdd: TBitBtn
          OnClick = bibAddClick
        end
        inherited bibChange: TBitBtn
          OnClick = bibChangeClick
        end
        inherited bibDel: TBitBtn
          OnClick = bibDelClick
        end
      end
    end
  end
  inherited pnFind: TPanel
    inherited edSearch: TEdit
      Anchors = [akLeft, akTop, akBottom]
    end
  end
end
