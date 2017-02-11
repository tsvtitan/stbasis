inherited fmEditRBEmpEncouragements: TfmEditRBEmpEncouragements
  Left = 322
  Top = 179
  Caption = 'fmEditRBEmpEncouragements'
  ClientHeight = 140
  ClientWidth = 288
  PixelsPerInch = 96
  TextHeight = 13
  object lbDocum: TLabel [0]
    Left = 6
    Top = 12
    Width = 74
    Height = 13
    Caption = 'На основании:'
  end
  object lbDateStart: TLabel [1]
    Left = 51
    Top = 67
    Width = 29
    Height = 13
    Caption = 'Дата:'
  end
  object lbtypeencouragements: TLabel [2]
    Left = 58
    Top = 39
    Width = 22
    Height = 13
    Caption = 'Вид:'
  end
  inherited pnBut: TPanel
    Top = 102
    Width = 288
    TabOrder = 6
    inherited Panel2: TPanel
      Left = 103
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 87
    TabOrder = 5
  end
  object edDocum: TEdit [5]
    Left = 88
    Top = 9
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 0
    OnChange = edDocumChange
  end
  object bibDocum: TBitBtn [6]
    Left = 257
    Top = 9
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 1
    OnClick = bibDocumClick
  end
  object dtpDateStart: TDateTimePicker [7]
    Left = 88
    Top = 63
    Width = 89
    Height = 22
    CalAlignment = dtaLeft
    Date = 37156
    Time = 37156
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 4
    OnChange = edDocumChange
  end
  object edtypeencouragements: TEdit [8]
    Left = 88
    Top = 36
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 2
    OnChange = edDocumChange
  end
  object bibtypeencouragements: TBitBtn [9]
    Left = 257
    Top = 36
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 3
    OnClick = bibtypeencouragementsClick
  end
  inherited IBTran: TIBTransaction
    Left = 229
    Top = 62
  end
end
