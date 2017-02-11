inherited FCOFilter1: TFCOFilter1
  Left = 299
  Top = 106
  Caption = 'Фильтр'
  PixelsPerInch = 96
  TextHeight = 13
  inherited LTitle: TLabel
    Visible = False
  end
  inherited LNDS: TLabel
    Left = 11
  end
  inherited LNDS1: TLabel
    Left = 216
    Top = 314
    Visible = False
  end
  inherited LCur: TLabel
    Visible = True
  end
  inherited LOnDoc: TLabel
    Top = 331
  end
  inherited LSumKredit: TLabel
    Left = 23
    Top = 355
  end
  inherited DateTime: TDateTimePicker
    Visible = False
  end
  inherited GroupBox1: TGroupBox
    inherited ESub1: TEdit
      Visible = False
    end
    inherited ESub2: TEdit
      Visible = False
    end
    inherited ESub3: TEdit
      Visible = False
    end
    inherited BKorAc: TButton
      Visible = False
    end
    inherited MEKorAc: TMaskEdit
      ReadOnly = False
    end
  end
  inherited EEmp: TEdit
    ReadOnly = False
  end
  inherited BEmp: TButton
    Visible = False
  end
  inherited EBasis: TEdit
    ReadOnly = False
  end
  inherited BBasis: TButton
    Visible = False
  end
  inherited EAppend: TEdit
    ReadOnly = False
  end
  inherited BAppend: TButton
    Visible = False
  end
  inherited CBNDS: TCheckBox
    Left = 208
    Top = 352
    Visible = False
  end
  inherited ENDS: TEdit
    Left = 80
  end
  inherited ESumNDS: TEdit
    Left = 245
    Top = 310
    Visible = False
  end
  inherited BNDS: TButton
    Left = 129
  end
  inherited ECur: TEdit
    Visible = True
  end
  inherited BCur: TButton
    Visible = True
  end
  inherited RGKassa: TRadioGroup
    Visible = False
  end
  inherited EOnDoc: TEdit
    Top = 328
  end
  inherited ESumKredit: TEdit
    Top = 352
  end
  inherited BOnDoc: TButton
    Left = 385
    Top = 311
  end
  object CBTOrder: TComboBox
    Left = 24
    Top = 16
    Width = 217
    Height = 21
    ItemHeight = 13
    TabOrder = 22
  end
  object EDate: TEdit
    Left = 408
    Top = 16
    Width = 89
    Height = 21
    TabOrder = 23
  end
  object GBKassa: TGroupBox
    Left = 384
    Top = 48
    Width = 129
    Height = 65
    Caption = 'Касса ...'
    TabOrder = 24
    object MEKassa: TMaskEdit
      Left = 8
      Top = 24
      Width = 113
      Height = 21
      EditMask = 'aaa\.aaa\.a;1; '
      MaxLength = 9
      TabOrder = 0
      Text = '   .   . '
    end
  end
end
