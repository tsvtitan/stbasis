inherited fmRBPlant: TfmRBPlant
  Left = 201
  Width = 528
  Caption = 'Справочник контрагентов'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBackGrid: TPanel
    Width = 520
    inherited pnBut: TPanel
      Left = 436
      inherited pnModal: TPanel
        inherited bibView: TBitBtn
          OnClick = bibViewClick
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
      Width = 436
    end
  end
  inherited pnFind: TPanel
    Width = 520
    inherited edSearch: TEdit
      Anchors = [akLeft, akTop, akBottom]
    end
  end
  inherited pnBottom: TPanel
    Width = 520
    inherited bibOk: TBitBtn
      Left = 357
    end
    inherited bibClose: TBitBtn
      Left = 439
    end
  end
end
