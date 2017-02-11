inherited fmRBPms_Planning: TfmRBPms_Planning
  Left = 315
  Top = 203
  Width = 538
  Caption = 'Справочник планировок'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBackGrid: TPanel
    Width = 530
    inherited pnBut: TPanel
      Left = 446
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
      Width = 446
      object splBottom: TSplitter
        Left = 5
        Top = 142
        Width = 436
        Height = 3
        Cursor = crSizeNS
        Align = alBottom
        MinSize = 100
      end
      object pnImage: TPanel
        Left = 5
        Top = 145
        Width = 436
        Height = 100
        Align = alBottom
        BevelOuter = bvNone
        Constraints.MaxHeight = 200
        Constraints.MinHeight = 100
        TabOrder = 0
        object dbi: TDBImage
          Left = 0
          Top = 0
          Width = 436
          Height = 100
          Align = alClient
          DataField = 'Image'
          DataSource = ds
          ReadOnly = True
          Stretch = True
          TabOrder = 0
        end
      end
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
    inherited bibOk: TBitBtn
      Left = 367
    end
    inherited bibClose: TBitBtn
      Left = 449
    end
  end
  inherited Mainqr: TIBQuery
    CachedUpdates = True
    UpdateObject = IBUpd
  end
end
