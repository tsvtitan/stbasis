inherited fmEditRBAppPermColumn: TfmEditRBAppPermColumn
  Caption = 'fmEditRBAppPermColumn'
  ClientHeight = 168
  ClientWidth = 280
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object lbApp: TLabel [0]
    Left = 9
    Top = 12
    Width = 67
    Height = 13
    Caption = 'Приложение:'
  end
  object lbCol: TLabel [1]
    Left = 30
    Top = 65
    Width = 46
    Height = 13
    Caption = 'Колонка:'
  end
  object lbPerm: TLabel [2]
    Left = 41
    Top = 91
    Width = 35
    Height = 13
    Caption = 'Право:'
  end
  object lbObj: TLabel [3]
    Left = 36
    Top = 39
    Width = 40
    Height = 13
    Caption = 'Обьект:'
  end
  inherited pnBut: TPanel
    Top = 130
    Width = 280
    TabOrder = 6
    inherited Panel2: TPanel
      Left = 95
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 114
    TabOrder = 5
  end
  object edApp: TEdit [6]
    Left = 84
    Top = 8
    Width = 165
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 0
    OnChange = edAppChange
  end
  object bibApp: TButton [7]
    Left = 249
    Top = 8
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 1
    OnClick = bibAppClick
  end
  object cmbPerm: TComboBox [8]
    Left = 84
    Top = 87
    Width = 186
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    MaxLength = 1
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    OnChange = cmbPermChange
  end
  object cmbObj: TComboBox [9]
    Left = 84
    Top = 35
    Width = 186
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnChange = edObjChange
  end
  object cmbColumn: TComboBox [10]
    Left = 84
    Top = 61
    Width = 186
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnChange = cmbColumnChange
  end
  inherited IBTran: TIBTransaction
    Left = 104
    Top = 1
  end
end
