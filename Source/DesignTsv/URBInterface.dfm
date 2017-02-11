inherited fmRBInterface: TfmRBInterface
  Left = 201
  Width = 528
  Caption = 'Справочник интерфейсов'
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    000000000000000000FEFEF000000000F04F44E00000000000FEFEF08000000F
    444F44E08000000EFEFEFEF08000000F444F44E08000000EFEFEFEF08000000F
    E4444FE08000000EFEFEFEF08000000F44E444E08000000EFEFEFEF080000000
    00000000E00000000EFEFEFEF00000000000000000000000000000000000F80F
    0000F80F0000E0030000C0030000C0030000C0030000C0030000C0030000C003
    0000C0030000C0030000C0030000C0030000F0030000F0030000FFFF0000}
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBackGrid: TPanel
    Width = 520
    inherited pnBut: TPanel
      Left = 436
      inherited pnModal: TPanel
        inherited bibView: TBitBtn
          OnClick = bibViewClick
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
      Width = 436
    end
  end
  inherited pnFind: TPanel
    Width = 520
    inherited edSearch: TEdit
      Anchors = [akLeft, akTop, akBottom]
    end
  end
  inherited pnBottom: TPanel
    Width = 520
    inherited bibOk: TBitBtn
      Left = 357
    end
    inherited bibClose: TBitBtn
      Left = 439
    end
  end
  inherited ds: TDataSource
    Left = 232
    Top = 64
  end
  inherited Mainqr: TIBQuery
    OnCalcFields = MainqrCalcFields
    CachedUpdates = True
    ParamCheck = True
    UpdateObject = IBUpd
    Left = 96
    Top = 104
  end
  inherited IBTran: TIBTransaction
    Left = 168
    Top = 105
  end
  inherited pmGrid: TPopupMenu
    Left = 128
    Top = 105
  end
end
