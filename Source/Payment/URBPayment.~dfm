inherited fmRBPayment: TfmRBPayment
  Left = 363
  Top = 218
  Width = 610
  Caption = 'Справочник элементов панелей'
  Constraints.MinWidth = 610
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBackGrid: TPanel
    Width = 602
    inherited pnBut: TPanel
      Left = 518
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
      Width = 518
    end
  end
  inherited pnFind: TPanel
    Width = 602
    inherited edSearch: TEdit
      Anchors = [akLeft, akTop, akBottom]
    end
  end
  inherited pnBottom: TPanel
    Width = 602
    inherited bibOk: TBitBtn
      Left = 439
    end
    inherited bibClose: TBitBtn
      Left = 521
    end
  end
  inherited Mainqr: TIBQuery
    CachedUpdates = True
    UpdateObject = IBUpd
  end
end
