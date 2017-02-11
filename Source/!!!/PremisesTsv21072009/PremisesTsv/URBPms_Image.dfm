inherited fmRBPms_Image: TfmRBPms_Image
  Left = 423
  Top = 184
  Width = 538
  Caption = 'Изображения домов'
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
      object splBottom: TSplitter
        Left = 5
        Top = 182
        Width = 436
        Height = 3
        Cursor = crSizeNS
        Align = alBottom
        MinSize = 50
      end
      object pnImage: TPanel
        Left = 5
        Top = 185
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
