inherited fmEditRBPlanAccounts: TfmEditRBPlanAccounts
  Left = 627
  Top = 282
  Caption = 'fmEditRBPlanAccounts'
  ClientHeight = 389
  ClientWidth = 381
  OnClose = nil
  OnDestroy = FormDestroy
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
  inherited pnBut: TPanel
    Top = 351
    Width = 381
    inherited Panel2: TPanel
      Left = 196
    end
  end
  inherited cbInString: TCheckBox
    Left = 14
    Top = 328
  end
  object MENum: TMaskEdit [5]
    Left = 16
    Top = 32
    Width = 57
    Height = 21
    EditMask = 'aaa\.aaa\.a;1; '
    MaxLength = 9
    TabOrder = 2
    Text = '   .   . '
    OnChange = EditChange
  end
  object ENam: TEdit [6]
    Left = 88
    Top = 32
    Width = 289
    Height = 21
    MaxLength = 20
    TabOrder = 3
    OnChange = EditChange
  end
  object ENamAc: TEdit [7]
    Left = 16
    Top = 88
    Width = 361
    Height = 21
    MaxLength = 100
    TabOrder = 4
    OnChange = EditChange
  end
  object Panel1: TPanel [8]
    Left = 16
    Top = 120
    Width = 361
    Height = 89
    BorderStyle = bsSingle
    TabOrder = 5
    object CBCur: TCheckBox
      Left = 48
      Top = 8
      Width = 97
      Height = 17
      Caption = 'Валютный'
      TabOrder = 0
      OnClick = EditChange
    end
    object CBAmount: TCheckBox
      Left = 48
      Top = 32
      Width = 97
      Height = 17
      Caption = 'Количественный'
      TabOrder = 1
      OnClick = EditChange
    end
    object CBBal: TCheckBox
      Left = 48
      Top = 56
      Width = 97
      Height = 17
      Caption = 'Забалансовый'
      TabOrder = 2
      OnClick = EditChange
    end
    object PSaldo: TPanel
      Left = 162
      Top = 8
      Width = 185
      Height = 70
      BevelOuter = bvNone
      TabOrder = 3
      object RBActPas: TRadioButton
        Left = 16
        Top = 48
        Width = 121
        Height = 17
        Caption = 'Активно-пассивный'
        TabOrder = 0
        OnClick = RBActPasClick
      end
      object RBPas: TRadioButton
        Left = 16
        Top = 24
        Width = 113
        Height = 17
        Caption = 'Пассивный'
        TabOrder = 1
        OnClick = RBPasClick
      end
      object RBAct: TRadioButton
        Left = 16
        Top = 0
        Width = 113
        Height = 17
        Caption = 'Активный'
        Checked = True
        TabOrder = 2
        TabStop = True
        OnClick = RBActClick
      end
    end
  end
  object PFindSaldo: TPanel [9]
    Left = 183
    Top = 126
    Width = 185
    Height = 70
    BevelOuter = bvNone
    TabOrder = 6
    Visible = False
    object CBAct: TCheckBox
      Left = 16
      Top = 3
      Width = 97
      Height = 17
      Caption = 'Активный'
      TabOrder = 0
    end
    object CBPas: TCheckBox
      Left = 16
      Top = 27
      Width = 97
      Height = 17
      Caption = 'Пассивный'
      TabOrder = 1
    end
    object CBActPas: TCheckBox
      Left = 16
      Top = 51
      Width = 145
      Height = 17
      Caption = 'Активно-пассивный'
      TabOrder = 2
    end
  end
  object Panel3: TPanel [10]
    Left = 16
    Top = 216
    Width = 360
    Height = 81
    BorderStyle = bsSingle
    TabOrder = 7
    inline FrameSub: TFrameSubkonto
      Left = 2
      Width = 352
      Height = 77
      inherited ESub1: TEdit
        Left = 93
      end
      inherited BSub1: TButton
        Left = 316
      end
      inherited ESub2: TEdit
        Left = 93
      end
      inherited BSub2: TButton
        Left = 316
      end
      inherited ESub3: TEdit
        Left = 93
      end
      inherited BSub3: TButton
        Left = 316
      end
      inherited ESub4: TEdit
        Left = 93
      end
      inherited BSub4: TButton
        Left = 316
      end
      inherited ESub5: TEdit
        Left = 93
      end
      inherited BSub5: TButton
        Left = 316
      end
      inherited ESub6: TEdit
        Left = 93
      end
      inherited BSub6: TButton
        Left = 316
      end
      inherited ESub7: TEdit
        Left = 93
      end
      inherited BSub7: TButton
        Left = 316
      end
      inherited ESub8: TEdit
        Left = 93
      end
      inherited BSub8: TButton
        Left = 316
      end
      inherited ESub9: TEdit
        Left = 93
      end
      inherited BSub9: TButton
        Left = 316
      end
      inherited ESub10: TEdit
        Left = 93
      end
      inherited BSub10: TButton
        Left = 316
      end
    end
  end
  inherited IBTran: TIBTransaction
    Left = 144
    Top = 353
  end
  object IBTable: TIBTable
    BufferChunks = 1000
    CachedUpdates = False
    Left = 216
    Top = 320
  end
end
