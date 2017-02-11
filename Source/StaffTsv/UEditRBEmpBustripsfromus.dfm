inherited fmEditRBEmpBustripsfromus: TfmEditRBEmpBustripsfromus
  Left = 322
  Top = 179
  Caption = 'fmEditRBEmpBustripsfromus'
  ClientHeight = 262
  ClientWidth = 352
  PixelsPerInch = 96
  TextHeight = 13
  object lbEmpProj: TLabel [0]
    Left = 45
    Top = 12
    Width = 104
    Height = 13
    Caption = 'К кому ушел проект:'
  end
  object lbDateStart: TLabel [1]
    Left = 41
    Top = 145
    Width = 108
    Height = 13
    Caption = 'Дата факт. выбытия:'
  end
  object lbDateFinish: TLabel [2]
    Left = 37
    Top = 170
    Width = 112
    Height = 13
    Caption = 'Дата факт. прибытия:'
  end
  object lbEmpDirect: TLabel [3]
    Left = 77
    Top = 38
    Width = 72
    Height = 13
    Caption = 'Кто направил:'
  end
  object lbDocum: TLabel [4]
    Left = 75
    Top = 64
    Width = 74
    Height = 13
    Caption = 'На основании:'
  end
  object lbNum: TLabel [5]
    Left = 7
    Top = 119
    Width = 142
    Height = 13
    Caption = 'Номер ком. удостоверения:'
  end
  object lbAbsence: TLabel [6]
    Left = 88
    Top = 91
    Width = 61
    Height = 13
    Caption = 'Вид неявки:'
  end
  inherited pnBut: TPanel
    Top = 224
    Width = 352
    TabOrder = 13
    inherited Panel2: TPanel
      Left = 167
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 208
    TabOrder = 12
  end
  object edEmpProj: TEdit [9]
    Left = 156
    Top = 9
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 0
    OnChange = edEmpProjChange
  end
  object bibEmpProj: TBitBtn [10]
    Left = 325
    Top = 9
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 1
    OnClick = bibEmpProjClick
  end
  object dtpDateStart: TDateTimePicker [11]
    Left = 156
    Top = 141
    Width = 89
    Height = 22
    CalAlignment = dtaLeft
    Date = 37156
    Time = 37156
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 9
    OnChange = edEmpProjChange
  end
  object dtpDateFinish: TDateTimePicker [12]
    Left = 156
    Top = 168
    Width = 89
    Height = 22
    CalAlignment = dtaLeft
    Date = 37156
    Time = 37156
    Checked = False
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 10
    OnChange = edEmpProjChange
  end
  object edEmpDirect: TEdit [13]
    Left = 156
    Top = 35
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 2
    OnChange = edEmpProjChange
  end
  object bibEmpDirect: TBitBtn [14]
    Left = 325
    Top = 35
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 3
    OnClick = bibEmpDirectClick
  end
  object edDocum: TEdit [15]
    Left = 156
    Top = 61
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 4
    OnChange = edEmpProjChange
  end
  object bibDocum: TBitBtn [16]
    Left = 325
    Top = 61
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 5
    OnClick = bibDocumClick
  end
  object chbOk: TCheckBox [17]
    Left = 156
    Top = 193
    Width = 79
    Height = 17
    Caption = 'Заверено'
    TabOrder = 11
    OnClick = edEmpProjChange
  end
  object edNum: TEdit [18]
    Left = 156
    Top = 115
    Width = 89
    Height = 21
    MaxLength = 30
    TabOrder = 8
    OnChange = edEmpProjChange
    OnKeyPress = edNumKeyPress
  end
  object edAbsence: TEdit [19]
    Left = 156
    Top = 88
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 6
    OnChange = edEmpProjChange
  end
  object bibAbsence: TBitBtn [20]
    Left = 325
    Top = 88
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 7
    OnClick = bibAbsenceClick
  end
  inherited IBTran: TIBTransaction
    Left = 288
    Top = 126
  end
end
