inherited fmRBAppPermColumn: TfmRBAppPermColumn
  Left = 149
  Width = 580
  Caption = 'Справочник прав на колонки'
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    000000000000000000000000000000AAAAAAA000000000AAAAAAAA00000000AA
    AAAAAA00000000AAAAAAA0000000000000000000000000000000000000000000
    000000BB000000000000BBBBB00000000002BBB0BB0002B2B22BBB000B000BBB
    BBBBBBB0BB0000000000BBBBB0000000000000BB00000000000000000000FFFF
    0000807F0000803F0000801F0000800F0000802F0000806F0000FFCF0000FF07
    0000FE03000080010000001100000001000080030000FF070000FFCF0000}
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBackGrid: TPanel
    Width = 572
    inherited pnBut: TPanel
      Left = 483
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
    inherited pnGrid: TPanel
      Width = 483
    end
  end
  inherited pnFind: TPanel
    Width = 572
    inherited edSearch: TEdit
      Anchors = [akLeft, akTop, akBottom]
    end
  end
  inherited pnBottom: TPanel
    Width = 572
    inherited bibOk: TBitBtn
      Left = 409
    end
    inherited bibClose: TBitBtn
      Left = 491
    end
  end
end
