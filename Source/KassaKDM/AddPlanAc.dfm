inherited FAddAccount: TFAddAccount
  Left = 306
  Top = 162
  ClientHeight = 398
  ClientWidth = 388
  OldCreateOrder = True
  OnKeyUp = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 16
    Top = 16
    Width = 34
    Height = 13
    Caption = 'Номер'
  end
  object Label2: TLabel [1]
    Left = 88
    Top = 16
    Width = 22
    Height = 13
    Caption = 'Имя'
  end
  object Label3: TLabel [2]
    Left = 16
    Top = 72
    Width = 115
    Height = 13
    Caption = 'Полное наименование'
  end
  object Label4: TLabel [3]
    Left = 16
    Top = 232
    Width = 56
    Height = 13
    Caption = 'Субконто1:'
  end
  object Label5: TLabel [4]
    Left = 16
    Top = 264
    Width = 56
    Height = 13
    Caption = 'Субконто2:'
  end
  object Label6: TLabel [5]
    Left = 16
    Top = 296
    Width = 56
    Height = 13
    Caption = 'Субконто3:'
  end
  inherited BOk: TButton
    Left = 216
    Top = 368
    TabOrder = 7
  end
  inherited BCancel: TButton
    Left = 304
    Top = 368
    TabOrder = 8
  end
  object MENum: TMaskEdit
    Left = 16
    Top = 32
    Width = 57
    Height = 21
    EditMask = 'aaa\.aaa\.a;1; '
    MaxLength = 9
    TabOrder = 0
    Text = '   .   . '
  end
  object ENam: TEdit
    Left = 88
    Top = 32
    Width = 281
    Height = 21
    MaxLength = 20
    TabOrder = 1
  end
  object ENamAc: TEdit
    Left = 16
    Top = 88
    Width = 353
    Height = 21
    MaxLength = 100
    TabOrder = 2
  end
  object Panel1: TPanel
    Left = 16
    Top = 120
    Width = 353
    Height = 89
    BorderStyle = bsSingle
    TabOrder = 3
    object CBCur: TCheckBox
      Left = 48
      Top = 8
      Width = 97
      Height = 17
      Caption = 'Валютный'
      TabOrder = 0
    end
    object CBAmount: TCheckBox
      Left = 48
      Top = 32
      Width = 97
      Height = 17
      Caption = 'Количественный'
      TabOrder = 1
    end
    object CBBal: TCheckBox
      Left = 48
      Top = 56
      Width = 97
      Height = 17
      Caption = 'Забалансовый'
      TabOrder = 2
    end
    object RBAct: TRadioButton
      Left = 184
      Top = 8
      Width = 113
      Height = 17
      Caption = 'Активный'
      Checked = True
      TabOrder = 3
      TabStop = True
    end
    object RBPas: TRadioButton
      Left = 184
      Top = 32
      Width = 113
      Height = 17
      Caption = 'Пассивный'
      TabOrder = 4
    end
    object RBActPas: TRadioButton
      Left = 184
      Top = 56
      Width = 121
      Height = 17
      Caption = 'Активно-пассивный'
      TabOrder = 5
    end
  end
  object CBSub1: TComboBox
    Left = 80
    Top = 229
    Width = 289
    Height = 21
    ItemHeight = 13
    TabOrder = 4
  end
  object CBSub2: TComboBox
    Left = 80
    Top = 261
    Width = 289
    Height = 21
    ItemHeight = 13
    TabOrder = 5
  end
  object CBSub3: TComboBox
    Left = 80
    Top = 293
    Width = 289
    Height = 21
    ItemHeight = 13
    TabOrder = 6
  end
  object IBTable: TIBQuery
    Database = Form1.IBDatabase
    Transaction = Form1.IBTransaction
    Active = True
    BufferChunks = 1000
    CachedUpdates = False
    SQL.Strings = (
      'select * from  KINDSUBKONTO')
    Left = 80
    Top = 328
  end
end
