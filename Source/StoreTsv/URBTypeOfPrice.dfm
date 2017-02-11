inherited fmRBTypeOfPrice: TfmRBTypeOfPrice
  Left = 315
  Top = 203
  Width = 562
  Caption = 'Справочник типов цен'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBackGrid: TPanel
    Width = 554
    inherited pnBut: TPanel
      Left = 465
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
      Width = 465
    end
  end
  inherited pnFind: TPanel
    Width = 554
    inherited edSearch: TEdit
      Anchors = [akLeft, akTop, akBottom]
    end
  end
  inherited pnBottom: TPanel
    Width = 554
    inherited bibOk: TBitBtn
      Left = 391
    end
    inherited bibClose: TBitBtn
      Left = 473
    end
  end
  inherited Mainqr: TIBQuery
    CachedUpdates = True
    UpdateObject = IBUpd
  end
end
