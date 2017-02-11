inherited fmEditRBCalcPeriod: TfmEditRBCalcPeriod
  Left = 391
  Top = 256
  Caption = 'fmEditRBCalcPeriod'
  ClientHeight = 122
  PixelsPerInch = 96
  TextHeight = 13
  object Lbname: TLabel [0]
    Left = 19
    Top = 17
    Width = 76
    Height = 13
    Caption = 'Наименование'
  end
  object Label1: TLabel [1]
    Left = 32
    Top = 44
    Width = 63
    Height = 13
    Caption = 'Действует с'
  end
  object LStatus: TLabel [2]
    Left = 0
    Top = 64
    Width = 329
    Height = 20
    Alignment = taCenter
    AutoSize = False
    Caption = 'Не использован'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
  end
  inherited pnBut: TPanel
    Top = 84
  end
  inherited cbInString: TCheckBox
    Left = 3
    Top = 64
  end
  object EdName: TEdit [5]
    Left = 100
    Top = 13
    Width = 185
    Height = 21
    TabOrder = 2
    OnChange = EdNameChange
  end
  object DTP1: TDateTimePicker [6]
    Left = 100
    Top = 39
    Width = 185
    Height = 21
    CalAlignment = dtaLeft
    Date = 37238.6076974884
    Time = 37238.6076974884
    DateFormat = dfLong
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 3
  end
  inherited IBTran: TIBTransaction
    Left = 96
    Top = 97
  end
end
