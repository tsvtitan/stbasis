inherited fmRBBasisTypeDoc: TfmRBBasisTypeDoc
  Width = 520
  Height = 370
  Caption = 'Справочник оснований вида документа'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBackGrid: TPanel
    Width = 512
    Height = 273
    inherited pnBut: TPanel
      Left = 423
      Height = 273
      inherited pnModal: TPanel
        Height = 172
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
      Width = 423
      Height = 273
    end
  end
  inherited pnFind: TPanel
    Width = 512
    inherited edSearch: TEdit
      Anchors = [akLeft, akTop, akBottom]
    end
  end
  inherited pnBottom: TPanel
    Top = 306
    Width = 512
    inherited bibOk: TBitBtn
      Left = 349
    end
    inherited bibClose: TBitBtn
      Left = 431
    end
  end
  inherited Mainqr: TIBQuery
    CachedUpdates = True
    UpdateObject = IBUpd
  end
end
