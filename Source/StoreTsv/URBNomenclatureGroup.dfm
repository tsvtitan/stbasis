inherited fmRBNomenclatureGroup: TfmRBNomenclatureGroup
  Left = 513
  Top = 121
  Caption = 'Группы номенклатуры'
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000000000000000000000000000000000000000000000000000FFF
    F77FFFF000000FFF7887FFF000000FF788887FF0F0000FF8F88F8FF0F0000FFF
    8FF8FFF0F0F00FFFF88FFFF0F0F0000000000000F0F0000FFFFFFFFFF0F00000
    0000000000F000000FFFFFFFFFF000000000000000000000000000000000FFFF
    0000FFFF0000FFFF0000000F0000000F00000003000000030000000000000000
    00000000000000000000C0000000C0000000F0000000F0000000FFFF0000}
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
