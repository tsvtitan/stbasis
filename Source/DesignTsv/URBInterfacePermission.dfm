inherited fmRBInterfacePermission: TfmRBInterfacePermission
  Left = 363
  Top = 218
  Width = 589
  Caption = 'Справочник прав интерфейса'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBackGrid: TPanel
    Width = 581
    inherited pnBut: TPanel
      Left = 497
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
      Width = 497
    end
  end
  inherited pnFind: TPanel
    Width = 581
    inherited edSearch: TEdit
      Anchors = [akLeft, akTop, akBottom]
    end
  end
  inherited pnBottom: TPanel
    Width = 581
    inherited bibOk: TBitBtn
      Left = 418
    end
    inherited bibClose: TBitBtn
      Left = 500
    end
  end
  inherited Mainqr: TIBQuery
    OnCalcFields = MainqrCalcFields
    CachedUpdates = True
    UpdateObject = IBUpd
  end
end
