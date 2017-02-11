inherited fmEditRBEmpConnect: TfmEditRBEmpConnect
  Caption = 'fmEditRBEmpConnect'
  ClientHeight = 118
  ClientWidth = 292
  PixelsPerInch = 96
  TextHeight = 13
  object lbConnectionString: TLabel [0]
    Left = 22
    Top = 44
    Width = 72
    Height = 13
    Caption = 'Строка связи:'
  end
  object lbConnectionType: TLabel [1]
    Left = 10
    Top = 16
    Width = 84
    Height = 13
    Caption = 'Средство связи:'
  end
  inherited pnBut: TPanel
    Top = 80
    Width = 292
    TabOrder = 4
    inherited Panel2: TPanel
      Left = 107
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 64
    TabOrder = 3
  end
  object edConnectionString: TEdit [4]
    Left = 102
    Top = 40
    Width = 179
    Height = 21
    MaxLength = 100
    TabOrder = 2
    OnChange = edConnectionStringChange
  end
  object edConnectionType: TEdit [5]
    Left = 102
    Top = 14
    Width = 159
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 0
    OnChange = edConnectionTypeChange
  end
  object bibConnectionType: TBitBtn [6]
    Left = 261
    Top = 14
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 1
    OnClick = bibConnectionTypeClick
  end
  inherited IBTran: TIBTransaction
    Left = 96
    Top = 89
  end
end
