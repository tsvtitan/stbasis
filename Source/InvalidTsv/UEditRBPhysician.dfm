inherited fmEditRBPhysician: TfmEditRBPhysician
  Top = 303
  Caption = 'fmEditRBPhysician'
  ClientHeight = 166
  ClientWidth = 291
  PixelsPerInch = 96
  TextHeight = 13
  object lbfname: TLabel [0]
    Left = 19
    Top = 13
    Width = 52
    Height = 13
    Alignment = taRightJustify
    Caption = 'Фамилия:'
  end
  object lbName: TLabel [1]
    Left = 46
    Top = 39
    Width = 25
    Height = 13
    Alignment = taRightJustify
    Caption = 'Имя:'
  end
  object lbsname: TLabel [2]
    Left = 21
    Top = 66
    Width = 50
    Height = 13
    Alignment = taRightJustify
    Caption = 'Отчество:'
  end
  object lbSeatName: TLabel [3]
    Left = 10
    Top = 93
    Width = 61
    Height = 13
    Alignment = taRightJustify
    Caption = 'Должность:'
  end
  inherited pnBut: TPanel
    Top = 128
    Width = 291
    TabOrder = 5
    inherited Panel2: TPanel
      Left = 106
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 112
    TabOrder = 4
  end
  object edfname: TEdit [6]
    Left = 81
    Top = 9
    Width = 199
    Height = 21
    MaxLength = 100
    TabOrder = 0
    OnChange = edfnameChange
  end
  object edName: TEdit [7]
    Left = 81
    Top = 35
    Width = 199
    Height = 21
    MaxLength = 100
    TabOrder = 1
    OnChange = edfnameChange
  end
  object edsname: TEdit [8]
    Left = 81
    Top = 62
    Width = 199
    Height = 21
    MaxLength = 100
    TabOrder = 2
    OnChange = edfnameChange
  end
  object edSeatName: TEdit [9]
    Left = 81
    Top = 89
    Width = 199
    Height = 21
    MaxLength = 100
    TabOrder = 3
    OnChange = edfnameChange
  end
  inherited IBTran: TIBTransaction
    Left = 8
    Top = 26
  end
end
