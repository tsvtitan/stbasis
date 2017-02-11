inherited fmRBKeyWords: TfmRBKeyWords
  Left = 522
  Top = 164
  Caption = 'Справочник ключевых слов'
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000000000000000000000000000000000000000000000000009909
    90CC0CC00222990990CC0CC02002990990CC0CC02002990990CC0CC002229999
    90CCCCC00002990990CC0CC00220990990CC0CC000009909900CCC0000009909
    900000000000099900000000000000000000000000000000000000000000FFFF
    0000FFFF0000FFFF0000FFFF000024980000249600002496000024980000041E
    000024990000249F0000263F000027FF00008FFF0000FFFF0000FFFF0000}
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBackGrid: TPanel
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
    end
  end
  inherited Mainqr: TIBQuery
    CachedUpdates = True
    UpdateObject = IBUpd
  end
end
