inherited fmEditRBAPBuilder: TfmEditRBAPBuilder
  Left = 570
  Top = 182
  Caption = 'fmEditRBAPBuilder'
  ClientHeight = 348
  ClientWidth = 314
  PixelsPerInch = 96
  TextHeight = 13
  inherited lbExport: TLabel [0]
    Left = 50
    Visible = False
  end
  inherited lbLink: TLabel [1]
  end
  inherited lbName: TLabel [2]
    Left = 17
  end
  inherited lbFullName: TLabel [3]
    Left = 55
  end
  inherited lbPriority: TLabel [4]
    Left = 49
    Top = 263
  end
  object lbPhones: TLabel [5]
    Left = 40
    Top = 151
    Width = 56
    Height = 13
    Alignment = taRightJustify
    Caption = 'Телефоны:'
    FocusControl = edPhones
  end
  object lbAddress: TLabel [6]
    Left = 62
    Top = 180
    Width = 34
    Height = 13
    Alignment = taRightJustify
    Caption = 'Адрес:'
    FocusControl = edAddress
  end
  object lbSite: TLabel [7]
    Left = 69
    Top = 208
    Width = 27
    Height = 13
    Alignment = taRightJustify
    Caption = 'Сайт:'
    FocusControl = edSite
  end
  object lbEmail: TLabel [8]
    Left = 49
    Top = 236
    Width = 47
    Height = 13
    Alignment = taRightJustify
    Caption = 'Эл.почта:'
    FocusControl = edEmail
  end
  inherited lbVariant: TLabel [9]
    Left = 43
  end
  inherited edExport: TEdit [10]
    Left = 104
    Visible = False
  end
  inherited pnBut: TPanel [11]
    Top = 310
    Width = 314
    TabOrder = 11
    inherited Panel2: TPanel
      Left = 129
    end
  end
  inherited cbInString: TCheckBox [12]
    Left = 102
    Top = 288
    TabOrder = 10
  end
  inherited edName: TEdit [13]
    Left = 103
  end
  inherited edFullName: TEdit [14]
    Left = 103
  end
  inherited edPriority: TEdit [15]
    Left = 103
    Top = 260
    TabOrder = 8
  end
  object edPhones: TEdit [16]
    Left = 103
    Top = 148
    Width = 199
    Height = 21
    MaxLength = 100
    TabOrder = 3
    OnChange = edNameChange
  end
  object edAddress: TEdit [17]
    Left = 103
    Top = 176
    Width = 199
    Height = 21
    MaxLength = 100
    TabOrder = 5
    OnChange = edNameChange
  end
  object edSite: TEdit [18]
    Left = 103
    Top = 204
    Width = 199
    Height = 21
    MaxLength = 100
    TabOrder = 6
    OnChange = edNameChange
  end
  object edEmail: TEdit [19]
    Left = 103
    Top = 232
    Width = 199
    Height = 21
    MaxLength = 100
    TabOrder = 7
    OnChange = edNameChange
  end
  inherited udPriority: TUpDown [20]
    Left = 149
    Top = 260
    TabOrder = 9
  end
  inherited meVariant: TMemo [21]
    Left = 103
  end
  inherited edLink: TEdit [22]
    Left = 103
    TabOrder = 12
    Visible = False
  end
  inherited IBTran: TIBTransaction
    Left = 190
  end
end
