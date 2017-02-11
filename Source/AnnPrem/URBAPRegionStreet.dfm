inherited fmRBAPRegionStreet: TfmRBAPRegionStreet
  Left = 217
  Top = 146
  Width = 520
  Caption = 'Справочник улицы районов'
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000000000000000000000000000000000099000000000303009900
    0000000303009000000000030300900000000003330000000000000333007700
    0000003030307700000000303030700000000030303077000000000000000000
    000000000000000000000000300000000000000030000000000000000000FFFF
    0000FFFF00001FC100001FC100001DC100003CC10000304100003C8000001D80
    00000F8000001F8000001F8000003FF70000FFE30000FFE30000FFF70000}
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
end
