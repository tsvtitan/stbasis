inherited fmEditRBSubkontoSubkonto: TfmEditRBSubkontoSubkonto
  Left = 368
  Top = 153
  Caption = 'fmEditRBSubkontoSubkonto'
  ClientHeight = 218
  PixelsPerInch = 96
  TextHeight = 13
  object LSub1: TLabel [0]
    Left = 16
    Top = 16
    Width = 56
    Height = 13
    Caption = 'Субконто1:'
  end
  object LSub2: TLabel [1]
    Left = 16
    Top = 56
    Width = 56
    Height = 13
    Caption = 'Субконто2:'
    Enabled = False
  end
  object LRelField: TLabel [2]
    Left = 16
    Top = 96
    Width = 89
    Height = 13
    Caption = 'Связующее поле:'
    Enabled = False
  end
  inherited pnBut: TPanel
    Top = 180
  end
  inherited cbInString: TCheckBox
    Top = 160
  end
  object ESub1: TEdit [5]
    Left = 16
    Top = 32
    Width = 279
    Height = 21
    TabOrder = 2
  end
  object BSub1: TButton [6]
    Left = 296
    Top = 32
    Width = 17
    Height = 21
    Caption = '...'
    TabOrder = 3
    OnClick = BSub1Click
  end
  object ESub2: TEdit [7]
    Left = 16
    Top = 72
    Width = 279
    Height = 21
    Enabled = False
    TabOrder = 4
    OnChange = ESub2Change
  end
  object BSub2: TButton [8]
    Left = 296
    Top = 72
    Width = 17
    Height = 21
    Caption = '...'
    Enabled = False
    TabOrder = 5
    OnClick = BSub2Click
  end
  object cbRelField: TComboBox [9]
    Left = 16
    Top = 112
    Width = 297
    Height = 21
    Enabled = False
    ItemHeight = 13
    TabOrder = 6
  end
  inherited IBTran: TIBTransaction
    Top = 184
  end
end
