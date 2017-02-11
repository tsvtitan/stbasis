inherited fmRBCashOrders: TfmRBCashOrders
  Left = 285
  Top = 73
  Width = 520
  Height = 423
  Caption = 'fmRBCashOrders'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBackGrid: TPanel
    Width = 512
    Height = 324
    inherited pnBut: TPanel
      Left = 423
      Height = 324
      inherited pnModal: TPanel
        Top = 145
        Height = 179
        inherited bibView: TBitBtn
          OnClick = bibViewClick
        end
        inherited bibRefresh: TBitBtn
          OnClick = bibRefreshClick
        end
      end
      inherited pnSQL: TPanel
        Height = 145
        inherited bibAdd: TBitBtn
          OnClick = bibAddClick
        end
        inherited bibChange: TBitBtn
          OnClick = bibChangeClick
        end
        inherited bibDel: TBitBtn
          OnClick = bibDelClick
        end
        object bibPostings: TBitBtn
          Left = 8
          Top = 97
          Width = 75
          Height = 25
          Hint = 'Провести (F9)'
          Caption = 'Провести'
          TabOrder = 3
          OnClick = bibPostingsClick
          OnKeyDown = FormKeyDown
        end
      end
    end
    inherited pnGrid: TPanel
      Width = 423
      Height = 324
    end
  end
  inherited pnFind: TPanel
    Width = 512
  end
  inherited pnBottom: TPanel
    Top = 357
    Width = 512
    inherited bibOk: TBitBtn
      Left = 349
    end
    inherited bibClose: TBitBtn
      Left = 431
    end
    object bibPrint: TBitBtn
      Left = 268
      Top = 9
      Width = 75
      Height = 25
      Hint = 'Подтвердить'
      Anchors = [akRight, akBottom]
      Caption = 'Печать'
      Default = True
      TabOrder = 3
      OnClick = bibPrintClick
      NumGlyphs = 2
    end
  end
end
