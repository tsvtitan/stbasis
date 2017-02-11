inherited fmRptsMilRank: TfmRptsMilRank
  Caption = 'fmRptsMilRank'
  ClientHeight = 87
  ClientWidth = 422
  PixelsPerInch = 96
  TextHeight = 13
  object LbMilrank: TLabel [0]
    Left = 9
    Top = 20
    Width = 91
    Height = 13
    Caption = 'Воинское звание:'
  end
  inherited pnBut: TPanel
    Top = 49
    Width = 422
    inherited Panel2: TPanel
      Left = 36
    end
  end
  inherited cbInString: TCheckBox
    Left = 19
    Top = 124
  end
  object EdMilrank: TEdit [3]
    Left = 105
    Top = 16
    Width = 277
    Height = 21
    Color = clMenu
    ReadOnly = True
    TabOrder = 2
    OnKeyDown = EdMilrankKeyDown
  end
  object BtMilRank: TButton [4]
    Left = 382
    Top = 16
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 3
    OnClick = BtMilRankClick
  end
end
