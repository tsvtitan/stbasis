inherited fmRBUserApp: TfmRBUserApp
  Width = 520
  Caption = '—правочник приложений доступных пользователю'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBackGrid: TPanel
    Width = 512
    inherited pnBut: TPanel
      Left = 428
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
      Width = 428
    end
  end
  inherited pnFind: TPanel
    Width = 512
    inherited edSearch: TEdit
      Anchors = [akLeft, akTop, akBottom]
    end
  end
  inherited pnBottom: TPanel
    Width = 512
    inherited bibOk: TButton
      Left = 349
    end
    inherited bibClose: TButton
      Left = 431
    end
  end
  inherited IBTran: TIBTransaction
    Top = 161
  end
  object IBTranNew: TIBTransaction
    Active = False
    DefaultAction = TARollback
    AutoStopAction = saNone
    Left = 176
    Top = 113
  end
end
