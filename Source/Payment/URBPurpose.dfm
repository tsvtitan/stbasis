inherited fmRBPurpose: TfmRBPurpose
  Left = 483
  Top = 168
  Width = 500
  Caption = ''
  Constraints.MinWidth = 500
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBackGrid: TPanel
    Width = 492
    inherited pnBut: TPanel
      Left = 408
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
      Width = 408
    end
  end
  inherited pnFind: TPanel
    Width = 492
    inherited edSearch: TEdit
      Anchors = [akLeft, akTop, akBottom]
    end
  end
  inherited pnBottom: TPanel
    Width = 492
    inherited bibOk: TBitBtn
      Left = 329
    end
    inherited bibClose: TBitBtn
      Left = 411
    end
  end
  inherited Mainqr: TIBQuery
    CachedUpdates = True
    UpdateObject = IBUpd
  end
end
