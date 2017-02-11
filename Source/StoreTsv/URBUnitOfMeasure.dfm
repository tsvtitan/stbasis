inherited fmRBUnitOfMeasure: TfmRBUnitOfMeasure
  Left = 315
  Top = 203
  Width = 538
  Caption = 'Справочник единиц измерений'
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    000000000000000000000000000000000000033F0000000000033000F0000000
    03300BBB0F0000C0300BBBBBB0F000C00BBBBB0BBB0000CC0BBB0BBBB00000CC
    00BBBBB0000000CC0C0BB006600000CC0CC00E06600000CC0CC0EE0660000000
    00C0000060000007F70707F7000000007F70007F70000000000000000000FFFF
    0000FF8F0000FE070000F8030000800100008001000080010000800300008003
    000080030000800300008003000080030000C0030000E0830000F0C70000}
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBackGrid: TPanel
    Width = 530
    inherited pnBut: TPanel
      Left = 441
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
      Width = 441
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
