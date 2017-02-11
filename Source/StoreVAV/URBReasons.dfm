inherited fmRBReasons: TfmRBReasons
  Left = 168
  Top = 241
  Caption = 'Справочник выпусков газеты'
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    00000000000000000000000000000000000FFFF000000000000FFF00000000FF
    FF0FFF0FFFF000F77744440FFFF000FFFF44440FFFF000F77770FF44444400FF
    FFF0FF44444400F77770FFFF000000FFFFF44444400000F777744444400000FF
    FFFFFF0000000000F7777F0000000000FFFFFF0000000000000000000000FFFF
    0000FC0F0000FC0F000080000000800000008000000080000000800000008000
    0000800700008007000080070000801F0000801F0000C01F0000E01F0000}
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBackGrid: TPanel
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
