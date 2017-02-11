inherited fmRBChargeTree: TfmRBChargeTree
  Caption = 'Справочник зависимостей начислений'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnTreeViewBack: TPanel
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
    inherited pnTreeView: TPanel
      object pnFields: TPanel
        Left = 0
        Top = 213
        Width = 373
        Height = 31
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 0
        object lbName: TLabel
          Left = 10
          Top = 8
          Width = 45
          Height = 13
          Caption = 'Краткое:'
        end
        object dbedShortName: TDBEdit
          Left = 64
          Top = 5
          Width = 305
          Height = 21
          Color = clBtnFace
          DataSource = ds
          TabOrder = 0
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
