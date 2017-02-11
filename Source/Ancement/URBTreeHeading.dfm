inherited fmRBTreeHeading: TfmRBTreeHeading
  Left = 453
  Top = 265
  Caption = 'Справочник рубрик'
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    000000000000000000000000000000000007B000000000000007770000000000
    000000000000000000000000000000007F000000000000007770000000000000
    000000000000000000000000000000007B000000000000007770000000000000
    000000000000000000000000000007F00000000000000777000000000000DE3F
    0000DE3F0000D8200000DA3F0000DBFF0000D1FF0000C1070000D1FF0000DFFF
    0000D1FF0000C1070000D1FF0000DFFF00008FFF0000083F00008FFF0000}
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnTreeViewBack: TPanel
    inherited pnBut: TPanel
      inherited pnModal: TPanel
        inherited bibView: TButton
          OnClick = bibViewClick
        end
        inherited bibRefresh: TButton
          OnClick = bibRefreshClick
        end
      end
      inherited pnSQL: TPanel
        inherited bibAdd: TButton
          OnClick = bibAddClick
        end
        inherited bibChange: TButton
          OnClick = bibChangeClick
        end
        inherited bibDel: TButton
          OnClick = bibDelClick
        end
      end
    end
  end
  inherited pnFind: TPanel
    inherited edSearch: TEdit
      Anchors = [akLeft, akTop, akBottom]
      OnChange = EdFindNodeChange
    end
  end
end
