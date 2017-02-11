inherited fmEditRBPayment: TfmEditRBPayment
  Left = 560
  Top = 203
  Caption = 'fmEditRBPayment'
  ClientHeight = 248
  ClientWidth = 310
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object lbCard: TLabel [0]
    Left = 10
    Top = 12
    Width = 73
    Height = 13
    Alignment = taRightJustify
    Caption = 'Карта оплаты:'
    FocusControl = edCard
  end
  object lbPurpose: TLabel [1]
    Left = 19
    Top = 54
    Width = 64
    Height = 13
    Alignment = taRightJustify
    Caption = 'Назначение:'
    FocusControl = edPurpose
  end
  object lbDateTime: TLabel [2]
    Left = 9
    Top = 81
    Width = 73
    Height = 13
    Alignment = taRightJustify
    Caption = 'Дата и время:'
  end
  object lbHowMuch: TLabel [3]
    Left = 87
    Top = 170
    Width = 112
    Height = 13
    Alignment = taRightJustify
    Caption = 'Cумма платежа (руб.):'
    FocusControl = edHowMuch
  end
  object lbNote: TLabel [4]
    Left = 28
    Top = 107
    Width = 53
    Height = 13
    Alignment = taRightJustify
    Caption = 'Описание:'
    FocusControl = meNote
  end
  object lbLimit: TLabel [5]
    Left = 91
    Top = 32
    Width = 54
    Height = 13
    Caption = 'Остаток: 0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  inherited pnBut: TPanel
    Top = 210
    Width = 310
    TabOrder = 9
    inherited Panel2: TPanel
      Left = 125
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 192
    TabOrder = 8
  end
  object edCard: TEdit [8]
    Left = 90
    Top = 8
    Width = 190
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 0
    OnChange = edNameChange
  end
  object btCard: TBitBtn [9]
    Left = 280
    Top = 8
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 1
    OnClick = btCardClick
  end
  object edPurpose: TEdit [10]
    Left = 90
    Top = 50
    Width = 190
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 2
    OnChange = edNameChange
  end
  object btPurpose: TBitBtn [11]
    Left = 280
    Top = 50
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 3
    OnClick = btPurposeClick
  end
  object dtpDate: TDateTimePicker [12]
    Left = 90
    Top = 78
    Width = 82
    Height = 22
    CalAlignment = dtaLeft
    Date = 37147
    Time = 37147
    Checked = False
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 4
  end
  object dtpTime: TDateTimePicker [13]
    Left = 178
    Top = 78
    Width = 70
    Height = 22
    CalAlignment = dtaLeft
    Date = 37147
    Time = 37147
    Checked = False
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkTime
    ParseInput = False
    TabOrder = 5
  end
  object edHowMuch: TEdit [14]
    Left = 208
    Top = 167
    Width = 93
    Height = 21
    TabOrder = 7
    OnChange = edHowMuchChange
    OnKeyPress = edHowMuchKeyPress
  end
  object meNote: TMemo [15]
    Left = 90
    Top = 106
    Width = 211
    Height = 55
    TabOrder = 6
    OnChange = edNameChange
  end
  inherited IBTran: TIBTransaction
    Left = 248
    Top = 74
  end
end
