inherited fmRBAPOperation: TfmRBAPOperation
  Left = 498
  Top = 175
  Caption = 'Группы болезней'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnTreeViewBack: TPanel
    inherited pnBut: TPanel
      inherited pnModal: TPanel
        inherited bibView: TButton
          OnClick = bibViewClick
        end
        inherited bibRefresh: TButton
          OnClick = bibRefreshClick
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
  inherited pnFind: TPanel
    inherited edSearch: TEdit
      Anchors = [akLeft, akTop, akBottom]
    end
  end
end
