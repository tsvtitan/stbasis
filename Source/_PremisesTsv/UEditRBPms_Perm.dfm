inherited fmEditRBPms_Perm: TfmEditRBPms_Perm
  Caption = 'fmEditRBPms_Perm'
  ClientHeight = 148
  ClientWidth = 327
  PixelsPerInch = 96
  TextHeight = 13
  object lbUserName: TLabel [0]
    Left = 6
    Top = 14
    Width = 99
    Height = 13
    Alignment = taRightJustify
    Caption = 'Имя пользователя:'
  end
  object lbPerm: TLabel [1]
    Left = 70
    Top = 41
    Width = 35
    Height = 13
    Alignment = taRightJustify
    Caption = 'Право:'
  end
  object lbTypeOperation: TLabel [2]
    Left = 32
    Top = 70
    Width = 73
    Height = 13
    Alignment = taRightJustify
    Caption = 'Тип операции:'
  end
  inherited pnBut: TPanel
    Top = 110
    Width = 327
    TabOrder = 5
    inherited Panel2: TPanel
      Left = 142
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 93
    TabOrder = 4
  end
  object edUserName: TEdit [5]
    Left = 115
    Top = 10
    Width = 176
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 0
    OnChange = edUserNameChange
  end
  object btUserName: TButton [6]
    Left = 296
    Top = 10
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 1
    OnClick = btUserNameClick
  end
  object cmbPerm: TComboBox [7]
    Left = 115
    Top = 39
    Width = 202
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    MaxLength = 1
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnChange = edUserNameChange
  end
  object cmbTypeOperation: TComboBox [8]
    Left = 115
    Top = 68
    Width = 202
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    MaxLength = 1
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnChange = edUserNameChange
  end
  inherited IBTran: TIBTransaction
    Left = 16
    Top = 33
  end
end
