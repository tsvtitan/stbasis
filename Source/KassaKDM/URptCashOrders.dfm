inherited fmRptCashOrders: TfmRptCashOrders
  Left = 404
  Top = 184
  Caption = 'fmRptCashOrders'
  ClientHeight = 165
  ClientWidth = 372
  PixelsPerInch = 96
  TextHeight = 13
  object lCO: TLabel [0]
    Left = 8
    Top = 32
    Width = 87
    Height = 13
    Caption = 'Кассовый ордер:'
  end
  inherited pnBut: TPanel
    Top = 127
    Width = 372
    inherited Panel2: TPanel
      Left = -14
    end
  end
  inherited cbInString: TCheckBox
    Left = 16
    Top = 100
  end
  object eCO: TEdit [3]
    Left = 108
    Top = 28
    Width = 189
    Height = 21
    TabOrder = 2
  end
  object bCO: TButton [4]
    Left = 299
    Top = 27
    Width = 17
    Height = 23
    Caption = '...'
    TabOrder = 3
    OnClick = bibCOClick
  end
  inherited IBTran: TIBTransaction
    Left = 160
    Top = 89
  end
  inherited Mainqr: TIBQuery
    Left = 192
    Top = 96
  end
end
