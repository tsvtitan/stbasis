inherited fmRBViewPlace: TfmRBViewPlace
  Caption = 'Справочник мест осмотра'
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
