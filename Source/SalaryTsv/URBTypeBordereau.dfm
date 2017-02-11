inherited fmRBTypeBordereau: TfmRBTypeBordereau
  Left = 233
  Width = 543
  Caption = 'Справочник видов ведомостей'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBackGrid: TPanel
    Width = 535
    inherited pnBut: TPanel
      Left = 446
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
      Width = 446
    end
  end
  inherited pnFind: TPanel
    Width = 535
    inherited edSearch: TEdit
      Anchors = [akLeft, akTop, akBottom]
    end
  end
  inherited pnBottom: TPanel
    Width = 535
    inherited bibOk: TBitBtn
      Left = 372
    end
    inherited bibClose: TBitBtn
      Left = 454
    end
  end
end
