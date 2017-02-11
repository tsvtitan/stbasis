inherited fmRBSubkontoSubkonto: TfmRBSubkontoSubkonto
  Left = 416
  Top = 180
  Caption = 'fmRBSubkontoSubkonto'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBackGrid: TPanel
    inherited pnBut: TPanel
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
  end
end
