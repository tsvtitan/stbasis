inherited fmEditRBUser: TfmEditRBUser
  Caption = 'fmEditRBUser'
  PixelsPerInch = 96
  TextHeight = 13
  object lbName: TLabel [0]
    Left = 37
    Top = 12
    Width = 99
    Height = 13
    Caption = 'Имя пользователя:'
  end
  object lbPass: TLabel [1]
    Left = 95
    Top = 64
    Width = 41
    Height = 13
    Caption = 'Пароль:'
  end
  object lbSqlname: TLabel [2]
    Left = 13
    Top = 39
    Width = 123
    Height = 13
    Caption = 'Имя пользователя SQL:'
  end
  inherited pnBut: TPanel
    TabOrder = 5
  end
  inherited cbInString: TCheckBox
    TabOrder = 4
  end
  object edName: TEdit [5]
    Left = 142
    Top = 8
    Width = 180
    Height = 21
    MaxLength = 100
    TabOrder = 0
    OnChange = edNameChange
    OnKeyPress = edNameKeyPress
  end
  object edPass: TEdit [6]
    Left = 142
    Top = 62
    Width = 111
    Height = 21
    MaxLength = 30
    PasswordChar = '*'
    TabOrder = 2
    OnChange = edNameChange
    OnKeyPress = edNameKeyPress
  end
  object chbHidePass: TCheckBox [7]
    Left = 265
    Top = 65
    Width = 63
    Height = 16
    Caption = 'Скрыть'
    Checked = True
    State = cbChecked
    TabOrder = 3
    OnClick = chbHidePassClick
  end
  object edSqlName: TEdit [8]
    Left = 142
    Top = 35
    Width = 180
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 128
    TabOrder = 1
    OnChange = edNameChange
    OnKeyPress = edSqlNameKeyPress
  end
  object IBSecServ: TIBSecurityService [9]
    Protocol = TCP
    TraceFlags = []
    SecurityAction = ActionAddUser
    UserID = 0
    GroupID = 0
    Left = 88
    Top = 88
  end
  inherited IBTran: TIBTransaction
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    Left = 120
  end
end
