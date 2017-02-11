inherited fmRBRelease: TfmRBRelease
  Width = 540
  Caption = 'Справочник выпусков газеты'
  Constraints.MinWidth = 540
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    00000000000000000000000000000000000FFFF000000000000FFF00000000FF
    FF0FFF0FFFF000F77744440FFFF000FFFF44440FFFF000F77770FF44444400FF
    FFF0FF44444400F77770FFFF000000FFFFF44444400000F777744444400000FF
    FFFFFF0000000000F7777F0000000000FFFFFF0000000000000000000000FFFF
    0000FC0F0000FC0F000080000000800000008000000080000000800000008000
    0000800700008007000080070000801F0000801F0000C01F0000E01F0000}
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBackGrid: TPanel
    Width = 532
    inherited pnBut: TPanel
      Left = 448
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
      Width = 448
    end
  end
  inherited pnFind: TPanel
    Width = 532
    inherited edSearch: TEdit
      Anchors = [akLeft, akTop, akBottom]
    end
  end
  inherited pnBottom: TPanel
    Width = 532
    inherited bibOk: TButton
      Left = 369
    end
    inherited bibClose: TButton
      Left = 451
    end
  end
end
