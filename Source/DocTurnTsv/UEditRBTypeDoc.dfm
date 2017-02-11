inherited fmEditRBTypeDoc: TfmEditRBTypeDoc
  Left = 502
  Top = 222
  Caption = 'fmEditRBTypeDoc'
  ClientHeight = 144
  ClientWidth = 318
  PixelsPerInch = 96
  TextHeight = 13
  object lbName: TLabel [0]
    Left = 19
    Top = 37
    Width = 79
    Height = 13
    Caption = 'Наименование:'
  end
  object lbInterfaceName: TLabel [1]
    Left = 9
    Top = 64
    Width = 89
    Height = 13
    Caption = 'Имя интерфейса:'
  end
  inherited pnBut: TPanel
    Top = 106
    Width = 318
    TabOrder = 4
    inherited Panel2: TPanel
      Left = 133
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 89
    TabOrder = 3
  end
  object edName: TEdit [4]
    Left = 104
    Top = 33
    Width = 208
    Height = 21
    MaxLength = 100
    TabOrder = 1
    OnChange = edNameChange
  end
  object cmbInterfaceName: TComboBox [5]
    Left = 104
    Top = 61
    Width = 208
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 2
    OnChange = edNameChange
  end
  object chbSign: TCheckBox [6]
    Left = 105
    Top = 11
    Width = 208
    Height = 17
    Caption = 'Вид документа является ссылкой'
    Checked = True
    State = cbChecked
    TabOrder = 0
    OnClick = chbSignClick
  end
  inherited IBTran: TIBTransaction
    Left = 256
    Top = 73
  end
end
