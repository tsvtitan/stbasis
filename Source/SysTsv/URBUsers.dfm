inherited fmRBUsers: TfmRBUsers
  Caption = 'Справочник пользователей'
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    000000000000000000000000000000000000000000000000E666609111000007
    EE666091110000000E0009991000003BB0FFF00000000003B0FF708FF000000B
    B0FFFF0F7000003B30FF008FFF00003B308FF08F0000003BB300300FFF000000
    BBBBB0000F00000030000000000000000000000000000000000000000000FFFF
    0000FFFF0000FFFF0000E0010000E0010000C0030000C0070000C0030000C003
    0000C0010000C0030000C0010000E0010000F0010000FF030000FFFF0000}
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
  inherited pnFind: TPanel
    inherited edSearch: TEdit
      Width = 324
      Anchors = [akLeft, akTop, akBottom]
    end
    object Button1: TButton
      Left = 383
      Top = 5
      Width = 75
      Height = 25
      Caption = 'Button1'
      TabOrder = 1
      Visible = False
      OnClick = Button1Click
    end
  end
  object IBSecServ: TIBSecurityService
    Protocol = TCP
    TraceFlags = []
    SecurityAction = ActionAddUser
    UserID = 0
    GroupID = 0
    Left = 136
    Top = 160
  end
end
