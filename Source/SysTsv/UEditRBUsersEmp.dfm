inherited fmEditRBUsersEmp: TfmEditRBUsersEmp
  Caption = 'fmEditRBUsersEmp'
  ClientHeight = 117
  ClientWidth = 292
  PixelsPerInch = 96
  TextHeight = 13
  object lbEmp: TLabel [0]
    Left = 27
    Top = 12
    Width = 56
    Height = 13
    Caption = 'Сотрудник:'
  end
  object lbUsername: TLabel [1]
    Left = 7
    Top = 38
    Width = 76
    Height = 13
    Caption = 'Пользователь:'
  end
  inherited pnBut: TPanel
    Top = 79
    Width = 292
    TabOrder = 5
    inherited Panel2: TPanel
      Left = 107
    end
  end
  inherited cbInString: TCheckBox
    Top = 58
    TabOrder = 4
  end
  object edEmp: TEdit [4]
    Left = 92
    Top = 9
    Width = 171
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 0
    OnChange = edEmpChange
  end
  object edUsername: TEdit [5]
    Left = 92
    Top = 35
    Width = 171
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 2
    OnChange = edEmpChange
  end
  object bibEmp: TButton [6]
    Left = 263
    Top = 9
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 1
    OnClick = bibEmpClick
  end
  object bibUserName: TButton [7]
    Left = 263
    Top = 35
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 3
    OnClick = bibUserNameClick
  end
end
