inherited fmRBAP: TfmRBAP
  Caption = 'fmRBAP'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBackGrid: TPanel
    inherited pnBut: TPanel
      inherited pnModal: TPanel
        inherited bibView: TButton
          OnClick = bibViewClick
        end
      end
      inherited pnSQL: TPanel
        inherited bibAdd: TButton
          OnClick = bibAddClick
        end
        inherited bibChange: TButton
          OnClick = bibChangeClick
        end
        inherited bibDel: TButton
          OnClick = bibDelClick
        end
      end
    end
  end
  inherited Mainqr: TIBQuery
    CachedUpdates = True
    UpdateObject = IBUpd
  end
end
