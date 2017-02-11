inherited fmRptAccountSheets: TfmRptAccountSheets
  Left = 365
  Top = 105
  Caption = 'Расчетные листы'
  ClientHeight = 181
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    00000000000000000000000000000000000FFFFFF0000000000FFFFFF0000000
    0F0FFFFFF00000000F0FFFFFF000000F0F0FFFFFF000000F0F0FFF000000000F
    0F0FFF0F0000000F0F0FFF000000000F0F0000000000000F0FFFF0000000000F
    000000000000000FFFF00000000000000000000000000000000000000000FFFF
    0000FC030000FC030000F0030000F0030000C0030000C0030000C0030000C007
    0000C00F0000C01F0000C01F0000C03F0000C07F0000C0FF0000FFFF0000}
  PixelsPerInch = 96
  TextHeight = 13
  object lbPeriod: TLabel [0]
    Left = 63
    Top = 11
    Width = 55
    Height = 13
    Caption = 'За период:'
  end
  inherited pnBut: TPanel
    Top = 143
    TabOrder = 5
    inherited Panel2: TPanel
      inherited bibClear: TBitBtn
        Caption = 'По умолчанию'
        Visible = True
      end
    end
  end
  inherited cbInString: TCheckBox
    Left = 0
    Top = 257
    TabOrder = 4
  end
  object grbCase: TGroupBox [3]
    Left = 13
    Top = 34
    Width = 358
    Height = 103
    Caption = ' Кому выдать '
    TabOrder = 3
    object rbAll: TRadioButton
      Left = 12
      Top = 21
      Width = 93
      Height = 17
      Caption = 'Всем'
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
      Caption = 'Сотруднику'
      TabOrder = 1
      OnClick = rbAllClick
    end
    object rbDepart: TRadioButton
      Left = 12
      Top = 74
      Width = 91
      Height = 17
      Caption = 'Отделу'
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
  object edPeriod: TEdit [4]
    Left = 124
    Top = 9
    Width = 151
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 0
  end
  object bibPeriod: TBitBtn [5]
    Left = 275
    Top = 9
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 1
    OnClick = bibPeriodClick
  end
  object bibCurPeriod: TBitBtn [6]
    Left = 299
    Top = 9
    Width = 72
    Height = 21
    Hint = 'Выбрать'
    Caption = 'Текущий'
    TabOrder = 2
    OnClick = bibCurPeriodClick
  end
  inherited IBTran: TIBTransaction
    Left = 302
    Top = 41
  end
  inherited Mainqr: TIBQuery
    Left = 262
    Top = 40
  end
end
