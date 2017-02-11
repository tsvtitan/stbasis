inherited fmEditRBGTD: TfmEditRBGTD
  Caption = 'fmEditRBGTD'
  ClientWidth = 288
  PixelsPerInch = 96
  TextHeight = 13
  object lbNum: TLabel [0]
    Left = 31
    Top = 13
    Width = 37
    Height = 13
    Caption = 'Номер:'
  end
  object lbNote: TLabel [1]
    Left = 6
    Top = 37
    Width = 66
    Height = 13
    Caption = 'Примечание:'
  end
  inherited pnBut: TPanel
    Width = 288
    TabOrder = 3
    inherited Panel2: TPanel
      Left = 103
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 95
    TabOrder = 2
  end
  object edNum: TEdit [4]
    Left = 80
    Top = 9
    Width = 199
    Height = 21
    MaxLength = 100
    TabOrder = 0
    OnChange = edNumChange
  end
  object meNote: TMemo [5]
    Left = 80
    Top = 36
    Width = 199
    Height = 55
    TabOrder = 1
    OnChange = edNumChange
  end
  inherited IBTran: TIBTransaction
    Left = 216
    Top = 26
  end
end
