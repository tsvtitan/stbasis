inherited fmEditRBAPAgency: TfmEditRBAPAgency
  Left = 492
  Top = 236
  Caption = 'fmEditRBAPAgency'
  ClientHeight = 413
  ClientWidth = 314
  PixelsPerInch = 96
  TextHeight = 13
  inherited lbExport: TLabel [0]
    Left = 51
    Top = 171
  end
  inherited lbLink: TLabel [1]
    Left = 54
    Top = 145
  end
  inherited lbName: TLabel [2]
    Left = 17
  end
  inherited lbFullName: TLabel [3]
    Left = 55
    Top = 44
  end
  inherited lbPriority: TLabel [4]
    Left = 49
    Top = 301
  end
  object lbPhones: TLabel [5]
    Left = 40
    Top = 197
    Width = 56
    Height = 13
    Alignment = taRightJustify
    Caption = 'Телефоны:'
    FocusControl = edPhones
  end
  object lbAddress: TLabel [6]
    Left = 62
    Top = 224
    Width = 34
    Height = 13
    Alignment = taRightJustify
    Caption = 'Адрес:'
    FocusControl = edAddress
  end
  object lbSite: TLabel [7]
    Left = 69
    Top = 250
    Width = 27
    Height = 13
    Alignment = taRightJustify
    Caption = 'Сайт:'
    FocusControl = edSite
  end
  object lbEmail: TLabel [8]
    Left = 49
    Top = 276
    Width = 47
    Height = 13
    Alignment = taRightJustify
    Caption = 'Эл.почта:'
    FocusControl = edEmail
  end
  object lbFieldViewName: TLabel [9]
    Left = 14
    Top = 328
    Width = 82
    Height = 13
    Alignment = taRightJustify
    Caption = 'Представление:'
    FocusControl = edFieldViewName
  end
  inherited lbVariant: TLabel [10]
    Left = 43
    Top = 66
  end
  inherited edExport: TEdit [11]
    Left = 104
    Top = 168
  end
  inherited pnBut: TPanel [12]
    Top = 375
    Width = 314
    TabOrder = 14
    inherited Panel2: TPanel
      Left = 129
    end
  end
  inherited cbInString: TCheckBox [13]
    Left = 102
    Top = 349
    TabOrder = 13
  end
  inherited edName: TEdit [14]
    Left = 103
  end
  inherited edFullName: TEdit [15]
    Left = 103
    Top = 40
  end
  inherited edPriority: TEdit [16]
    Left = 103
    Top = 298
    TabOrder = 9
  end
  object edPhones: TEdit [17]
    Left = 103
    Top = 194
    Width = 199
    Height = 21
    MaxLength = 100
    TabOrder = 5
    OnChange = edNameChange
  end
  object edAddress: TEdit [18]
    Left = 103
    Top = 220
    Width = 199
    Height = 21
    MaxLength = 100
    TabOrder = 6
    OnChange = edNameChange
  end
  object edSite: TEdit [19]
    Left = 103
    Top = 246
    Width = 199
    Height = 21
    MaxLength = 100
    TabOrder = 7
    OnChange = edNameChange
  end
  object edEmail: TEdit [20]
    Left = 103
    Top = 272
    Width = 199
    Height = 21
    MaxLength = 100
    TabOrder = 8
    OnChange = edNameChange
  end
  object edFieldViewName: TEdit [21]
    Left = 102
    Top = 324
    Width = 173
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 11
    OnChange = edNameChange
    OnKeyDown = edFieldViewNameKeyDown
  end
  object btFieldViewName: TButton [22]
    Left = 279
    Top = 324
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 12
    OnClick = btFieldViewNameClick
  end
  inherited udPriority: TUpDown [23]
    Left = 149
    Top = 298
    TabOrder = 10
  end
  inherited meVariant: TMemo [24]
    Left = 103
    Top = 66
  end
  inherited edLink: TEdit [25]
    Left = 104
    Top = 142
  end
  inherited IBTran: TIBTransaction
    Left = 190
    Top = 23
  end
end
