inherited fmRBInvalid: TfmRBInvalid
  Left = 403
  Top = 187
  Width = 583
  Caption = 'Справочник инвалидов'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBackGrid: TPanel
    Width = 575
    inherited pnBut: TPanel
      Left = 491
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
      Width = 491
    end
  end
  inherited pnFind: TPanel
    Width = 575
    inherited edSearch: TEdit
      Anchors = [akLeft, akTop, akBottom]
    end
  end
  inherited pnBottom: TPanel
    Width = 575
    inherited bibOk: TBitBtn
      Left = 412
    end
    inherited bibClose: TBitBtn
      Left = 494
    end
  end
end
