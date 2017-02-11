inherited fmEditRBConsts: TfmEditRBConsts
  Left = 470
  Top = 167
  Caption = 'fmEditRBConsts'
  ClientHeight = 336
  ClientWidth = 317
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object lbType: TLabel [0]
    Left = 10
    Top = 11
    Width = 79
    Height = 13
    Caption = 'Тип константы:'
  end
  object lbName: TLabel [1]
    Left = 10
    Top = 35
    Width = 79
    Height = 13
    Caption = 'Наименование:'
  end
  object lbValueView: TLabel [2]
    Left = 9
    Top = 144
    Width = 80
    Height = 26
    Alignment = taRightJustify
    Caption = 'Отображаемое значение:'
    Layout = tlCenter
    WordWrap = True
  end
  object lbAbout: TLabel [3]
    Left = 23
    Top = 62
    Width = 66
    Height = 13
    Caption = 'Примечание:'
  end
  inherited pnBut: TPanel
    Top = 298
    Width = 317
    TabOrder = 6
    inherited Panel2: TPanel
      Left = 132
    end
    inherited bibPrev: TButton
      OnClick = bibPrevClick
    end
    inherited bibNext: TButton
      OnClick = bibNextClick
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 280
    TabOrder = 5
  end
  object cmbType: TComboBox [6]
    Left = 97
    Top = 7
    Width = 146
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    MaxLength = 1
    ParentShowHint = False
    ShowHint = False
    TabOrder = 0
    OnChange = cmbTypeChange
  end
  object edName: TEdit [7]
    Left = 97
    Top = 32
    Width = 209
    Height = 21
    MaxLength = 100
    TabOrder = 1
    OnChange = edNameChange
  end
  object edValueView: TEdit [8]
    Left = 97
    Top = 148
    Width = 209
    Height = 21
    MaxLength = 100
    TabOrder = 3
    OnChange = edNameChange
  end
  object meAbout: TMemo [9]
    Left = 97
    Top = 58
    Width = 209
    Height = 85
    TabOrder = 2
    OnChange = edNameChange
  end
  object grbLink: TGroupBox [10]
    Left = 8
    Top = 173
    Width = 299
    Height = 102
    Caption = ' Ссылка '
    TabOrder = 4
    object lbCol: TLabel
      Left = 27
      Top = 45
      Width = 46
      Height = 13
      Caption = 'Колонка:'
    end
    object lbObj: TLabel
      Left = 27
      Top = 20
      Width = 46
      Height = 13
      Caption = 'Таблица:'
    end
    object lbValueTable: TLabel
      Left = 13
      Top = 66
      Width = 60
      Height = 26
      Alignment = taRightJustify
      Caption = 'Значение в таблице:'
      WordWrap = True
    end
    object cmbObj: TComboBox
      Left = 81
      Top = 16
      Width = 209
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnChange = edObjChange
    end
    object cmbColumn: TComboBox
      Left = 81
      Top = 42
      Width = 209
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnChange = cmbColumnChange
    end
    object edValueTable: TEdit
      Left = 81
      Top = 69
      Width = 187
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 2
      OnChange = edNameChange
    end
    object bibValueTable: TButton
      Left = 268
      Top = 69
      Width = 21
      Height = 21
      Caption = '...'
      TabOrder = 3
      OnClick = bibValueTableClick
    end
  end
  inherited IBTran: TIBTransaction
    Left = 26
    Top = 89
  end
end
