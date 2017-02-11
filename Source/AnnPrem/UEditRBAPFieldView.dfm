inherited fmEditRBAPFieldView: TfmEditRBAPFieldView
  Left = 582
  Top = 179
  Caption = 'fmEditRBAPFieldView'
  ClientHeight = 433
  ClientWidth = 369
  PixelsPerInch = 96
  TextHeight = 13
  inherited lbExport: TLabel [0]
    Top = 151
    Visible = False
  end
  inherited lbLink: TLabel [1]
  end
  inherited lbName: TLabel [2]
  end
  inherited lbFullName: TLabel [3]
  end
  inherited lbPriority: TLabel [4]
    Top = 151
  end
  object lbFields: TLabel [5]
    Left = 62
    Top = 178
    Width = 29
    Height = 13
    Alignment = taRightJustify
    Caption = 'Поля:'
    FocusControl = meFields
  end
  object lbCondition: TLabel [6]
    Left = 44
    Top = 320
    Width = 47
    Height = 13
    Alignment = taRightJustify
    Caption = 'Условие:'
    FocusControl = meCondition
  end
  inherited lbVariant: TLabel [7]
  end
  inherited edExport: TEdit [8]
    Top = 148
    Visible = False
  end
  inherited pnBut: TPanel [9]
    Top = 395
    Width = 369
    TabOrder = 9
    inherited Panel2: TPanel
      Left = 184
    end
  end
  inherited cbInString: TCheckBox [10]
    Top = 371
    TabOrder = 8
  end
  inherited edName: TEdit [11]
    Width = 260
  end
  inherited edFullName: TEdit [12]
    Width = 260
  end
  inherited edPriority: TEdit [13]
    Top = 148
    TabOrder = 3
  end
  object meFields: TMemo [14]
    Left = 97
    Top = 176
    Width = 260
    Height = 135
    Lines.Strings = (
      '[Колонки]')
    ScrollBars = ssVertical
    TabOrder = 6
    OnChange = edNameChange
  end
  object meCondition: TMemo [15]
    Left = 97
    Top = 318
    Width = 260
    Height = 49
    ScrollBars = ssVertical
    TabOrder = 7
    OnChange = edNameChange
  end
  inherited udPriority: TUpDown [16]
    Top = 148
    TabOrder = 10
  end
  inherited meVariant: TMemo [17]
    Height = 72
  end
  inherited edLink: TEdit [18]
    TabOrder = 5
    Visible = False
  end
end
