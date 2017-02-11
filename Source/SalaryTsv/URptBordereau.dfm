inherited fmRptBordereau: TfmRptBordereau
  Left = 421
  Top = 139
  Caption = 'Ведомости'
  ClientHeight = 339
  ClientWidth = 381
  PixelsPerInch = 96
  TextHeight = 13
  inherited cbInString: TCheckBox [0]
    Top = 335
    TabOrder = 2
  end
  inherited pnBut: TPanel [1]
    Top = 301
    Width = 381
    TabOrder = 3
    inherited Panel2: TPanel
      Left = -5
      inherited bibClear: TBitBtn
        Caption = 'По умолчанию'
        Visible = True
      end
    end
  end
  object grbCase: TGroupBox [2]
    Left = 9
    Top = 189
    Width = 361
    Height = 103
    Caption = ' По кому формировать '
    TabOrder = 1
    object rbAll: TRadioButton
      Left = 12
      Top = 21
      Width = 93
      Height = 17
      Caption = 'по Всем'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = rbAllClick
    end
    object rbEmp: TRadioButton
      Left = 12
      Top = 46
      Width = 91
      Height = 17
      Caption = 'по Сотруднику'
      TabOrder = 1
      OnClick = rbAllClick
    end
    object rbDepart: TRadioButton
      Left = 12
      Top = 74
      Width = 91
      Height = 17
      Caption = 'по Отделу'
      TabOrder = 4
      OnClick = rbAllClick
    end
    object edEmp: TEdit
      Left = 112
      Top = 45
      Width = 216
      Height = 21
      Color = clBtnFace
      Enabled = False
      MaxLength = 100
      ReadOnly = True
      TabOrder = 2
    end
    object bibEmp: TBitBtn
      Left = 328
      Top = 45
      Width = 21
      Height = 21
      Hint = 'Выбрать'
      Caption = '...'
      Enabled = False
      TabOrder = 3
      OnClick = bibEmpClick
    end
    object eddepart: TEdit
      Left = 112
      Top = 72
      Width = 216
      Height = 21
      Color = clBtnFace
      Enabled = False
      MaxLength = 100
      ReadOnly = True
      TabOrder = 5
    end
    object bibDepart: TBitBtn
      Left = 328
      Top = 72
      Width = 21
      Height = 21
      Hint = 'Выбрать'
      Caption = '...'
      Enabled = False
      TabOrder = 6
      OnClick = bibDepartClick
    end
  end
  object grbThatDo: TGroupBox [3]
    Left = 9
    Top = 8
    Width = 361
    Height = 177
    Caption = ' Что делать '
    TabOrder = 0
    object lbSelectExist: TLabel
      Left = 14
      Top = 148
      Width = 15
      Height = 13
      Caption = 'за:'
    end
    object lbPeriod: TLabel
      Left = 49
      Top = 45
      Width = 56
      Height = 13
      Caption = 'На период:'
    end
    object lbTypeBordereau: TLabel
      Left = 25
      Top = 71
      Width = 80
      Height = 13
      Caption = 'Вид ведомости:'
    end
    object lbNumBordereau: TLabel
      Left = 10
      Top = 97
      Width = 95
      Height = 13
      Caption = 'Номер ведомости:'
    end
    object rbCreateNew: TRadioButton
      Left = 12
      Top = 19
      Width = 101
      Height = 17
      Caption = 'Создать новую'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = rbCreateNewClick
    end
    object rbSelectExist: TRadioButton
      Left = 12
      Top = 124
      Width = 181
      Height = 17
      Caption = 'Выбрать существующую'
      TabOrder = 8
      OnClick = rbCreateNewClick
    end
    object cmbBordereau: TComboBox
      Left = 38
      Top = 145
      Width = 312
      Height = 21
      Style = csDropDownList
      Color = clBtnFace
      Enabled = False
      ItemHeight = 13
      TabOrder = 9
    end
    object edPeriod: TEdit
      Left = 112
      Top = 42
      Width = 138
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 1
    end
    object bibPeriod: TBitBtn
      Left = 250
      Top = 42
      Width = 21
      Height = 21
      Hint = 'Выбрать'
      Caption = '...'
      TabOrder = 2
      OnClick = bibPeriodClick
    end
    object bibCurPeriod: TBitBtn
      Left = 277
      Top = 42
      Width = 72
      Height = 21
      Hint = 'Выбрать'
      Caption = 'Текущий'
      TabOrder = 3
      OnClick = bibCurPeriodClick
    end
    object edTypeBordereau: TEdit
      Left = 112
      Top = 68
      Width = 216
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 4
    end
    object bibTypeBordereau: TBitBtn
      Left = 328
      Top = 68
      Width = 21
      Height = 21
      Hint = 'Выбрать'
      Caption = '...'
      TabOrder = 5
      OnClick = bibTypeBordereauClick
    end
    object edNumBordereau: TEdit
      Left = 112
      Top = 94
      Width = 110
      Height = 21
      MaxLength = 100
      TabOrder = 6
    end
    object chbSendPayDesk: TCheckBox
      Left = 229
      Top = 96
      Width = 118
      Height = 17
      Caption = 'Передать в кассу'
      TabOrder = 7
      OnClick = chbSendPayDeskClick
    end
  end
  inherited IBTran: TIBTransaction
    Left = 241
    Top = 198
  end
  inherited Mainqr: TIBQuery
    Left = 201
    Top = 197
  end
end
