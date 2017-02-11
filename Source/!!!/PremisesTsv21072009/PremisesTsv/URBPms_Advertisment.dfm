inherited fmRBPms_Advertisment: TfmRBPms_Advertisment
  Left = 434
  Top = 314
  Width = 538
  Caption = ''
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBackGrid: TPanel
    Width = 530
    inherited pnBut: TPanel
      Left = 446
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
    inherited pnGrid: TPanel
      Width = 446
    end
  end
  inherited pnFind: TPanel
    Width = 530
    inherited edSearch: TEdit
      Anchors = [akLeft, akTop, akBottom]
    end
  end
  inherited pnBottom: TPanel
    Width = 530
    inherited bibOk: TButton
      Left = 367
    end
    inherited bibClose: TButton
      Left = 449
    end
  end
  inherited Mainqr: TIBQuery
    CachedUpdates = True
    UpdateObject = IBUpd
  end
end
