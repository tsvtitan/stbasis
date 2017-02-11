inherited fmEditRBNumerators: TfmEditRBNumerators
  Left = 362
  Top = 184
  Caption = 'fmEditRBRespondents'
  ClientHeight = 333
  ClientWidth = 361
  PixelsPerInch = 96
  TextHeight = 13
  object lbNameNumerator: TLabel [0]
    Left = 38
    Top = 11
    Width = 59
    Height = 13
    Alignment = taRightJustify
    Caption = 'Нумератор:'
  end
  object lbAbout: TLabel [1]
    Left = 30
    Top = 128
    Width = 66
    Height = 13
    Alignment = taRightJustify
    Caption = 'Примечание:'
  end
  object lbSuffix: TLabel [2]
    Left = 48
    Top = 83
    Width = 49
    Height = 13
    Alignment = taRightJustify
    Caption = 'Суффикс:'
  end
  object lbPrefix: TLabel [3]
    Left = 55
    Top = 59
    Width = 42
    Height = 13
    Alignment = taRightJustify
    Caption = 'Префих:'
  end
  object lbStartDate: TLabel [4]
    Left = 33
    Top = 107
    Width = 66
    Height = 13
    Alignment = taRightJustify
    Caption = 'Действует с:'
  end
  object lbStartNum: TLabel [5]
    Left = 34
    Top = 248
    Width = 60
    Height = 13
    Alignment = taRightJustify
    Caption = 'Начинать с:'
    Enabled = False
  end
  object lbNAmeTypeNumerator: TLabel [6]
    Left = 12
    Top = 35
    Width = 85
    Height = 13
    Alignment = taRightJustify
    Caption = 'Тип нумератора:'
  end
  object SpeedButton1: TSpeedButton [7]
    Left = 188
    Top = 244
    Width = 23
    Height = 22
    Glyph.Data = {
      CE000000424DCE000000000000007600000028000000100000000B0000000100
      0400000000005800000000000000000000001000000010000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00CCCCCCCCCCCC
      CCCC000000000000000008888888888888800F770707070777800F7000000000
      77800F707070707077800F700000000077800F770707070777800FFFFFFFFFFF
      FF800000000000000000CCCCCCCCCCCCCCCC}
    OnClick = SpeedButton1Click
  end
  inherited pnBut: TPanel
    Top = 295
    Width = 361
    TabOrder = 10
    inherited Panel2: TPanel
      Left = 176
    end
  end
  inherited cbInString: TCheckBox
    Left = 4
    Top = 276
    TabOrder = 9
  end
  object edNameNumerator: TEdit [10]
    Left = 104
    Top = 7
    Width = 245
    Height = 21
    MaxLength = 100
    TabOrder = 0
    OnChange = edNameNumeratorChange
  end
  object meAbout: TMemo [11]
    Left = 104
    Top = 126
    Width = 245
    Height = 113
    TabOrder = 6
    OnChange = edNameNumeratorChange
  end
  object edSuffix: TEdit [12]
    Left = 104
    Top = 79
    Width = 245
    Height = 21
    MaxLength = 100
    TabOrder = 4
    OnChange = edNameNumeratorChange
  end
  object edPrefix: TEdit [13]
    Left = 104
    Top = 55
    Width = 245
    Height = 21
    MaxLength = 100
    TabOrder = 3
    OnChange = edNameNumeratorChange
  end
  object DTPStartDate: TDateTimePicker [14]
    Left = 104
    Top = 103
    Width = 186
    Height = 21
    CalAlignment = dtaLeft
    Date = 37546.9296588889
    Time = 37546.9296588889
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 5
    OnChange = edNameNumeratorChange
  end
  object edStartNum: TEdit [15]
    Left = 104
    Top = 245
    Width = 85
    Height = 21
    Enabled = False
    TabOrder = 7
    Text = '0'
  end
  object bibStartNum: TButton [16]
    Left = 213
    Top = 243
    Width = 75
    Height = 25
    Caption = 'Запомнить'
    Enabled = False
    TabOrder = 8
    OnClick = bibStartNumClick
  end
  object bNameTypeNumerator: TButton [17]
    Left = 329
    Top = 30
    Width = 20
    Height = 21
    Caption = '...'
    TabOrder = 2
    OnClick = bNameTypeNumeratorClick
  end
  object edNameTypeNumerator: TEdit [18]
    Left = 104
    Top = 30
    Width = 224
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 1
    OnChange = edNameNumeratorChange
    OnKeyDown = edNameTypeNumeratorKeyDown
  end
  inherited IBTran: TIBTransaction
    Left = 0
    Top = 1
  end
end
