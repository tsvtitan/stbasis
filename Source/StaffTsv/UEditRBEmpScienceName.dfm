inherited fmEditRBEmpScienceName: TfmEditRBEmpScienceName
  Caption = 'fmEditRBEmpScienceName'
  ClientHeight = 120
  ClientWidth = 312
  PixelsPerInch = 96
  TextHeight = 13
  object lbScienceName: TLabel [0]
    Left = 34
    Top = 16
    Width = 79
    Height = 13
    Caption = 'Ученое звание:'
  end
  object lbSchool: TLabel [1]
    Left = 10
    Top = 43
    Width = 103
    Height = 13
    Caption = 'Учебное заведение:'
  end
  inherited pnBut: TPanel
    Top = 82
    Width = 312
    TabOrder = 5
    inherited Panel2: TPanel
      Left = 127
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 66
    TabOrder = 4
  end
  object edScienceName: TEdit [4]
    Left = 119
    Top = 14
    Width = 164
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 0
    OnChange = edScienceNameChange
  end
  object bibScienceName: TBitBtn [5]
    Left = 283
    Top = 14
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 1
    OnClick = bibScienceNameClick
  end
  object edSchool: TEdit [6]
    Left = 119
    Top = 41
    Width = 164
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 2
    OnChange = edScienceNameChange
  end
  object bibSchool: TBitBtn [7]
    Left = 283
    Top = 41
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 3
    OnClick = bibSchoolClick
  end
  inherited IBTran: TIBTransaction
    Left = 96
    Top = 89
  end
end
