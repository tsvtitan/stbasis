inherited fmRBToolbar: TfmRBToolbar
  Left = 342
  Top = 218
  Caption = 'Справочник панелей инструментов'
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    000000000000000000000000000000000000000000000000000000000000F777
    777777777770F888888888888870F8F00008F0000870F8F88808F8880870F8F8
    8808F8880870F8F88808F8880870F8FFFF08FFFF0870F888888888888870FFFF
    FFFFFFFFFFF0000000000000000000000000000000000000000000000000FFFF
    0000FFFF0000FFFF000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000FFFF0000FFFF0000FFFF0000}
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
