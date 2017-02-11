inherited fmRBInterfacePermission: TfmRBInterfacePermission
  Left = 363
  Top = 218
  Caption = 'Справочник прав интерфейса'
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000000000000000000000000000F000000000000000F8880000000
    000F0F8880000000000F8F88800000000F0F8FFFF00000000F8F88800000000F
    0F8FFFF00000000F8F88800000000F0F8FFFF00000000F8F8880000000000F8F
    FFF0000000000F888000000000000FFFF000000000000000000000000000FFFF
    0000FFFF0000FF830000FF830000FE030000FE030000F8030000F80F0000E00F
    0000E03F0000803F000080FF000080FF000083FF000083FF0000FFFF0000}
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
  inherited Mainqr: TIBQuery
    OnCalcFields = MainqrCalcFields
    CachedUpdates = True
    UpdateObject = IBUpd
  end
end
