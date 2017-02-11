inherited fmBuildingTree: TfmBuildingTree
  Left = 222
  Top = 155
  Caption = 'Рассчет заработной платы '
  ClientHeight = 183
  ClientWidth = 399
  PixelsPerInch = 96
  TextHeight = 13
  object lbPeriod: TLabel [0]
    Left = 15
    Top = 11
    Width = 55
    Height = 13
    Caption = 'За период:'
  end
  inherited pnBut: TPanel
    Top = 145
    Width = 399
    TabOrder = 5
    inherited Panel2: TPanel
      Left = 13
      inherited bibGen: TBitBtn
        Hint = 'Начислить'
        Caption = 'Начислить'
        TabOrder = 1
      end
      inherited bibClose: TBitBtn
        TabOrder = 3
      end
      inherited bibBreak: TBitBtn
        TabOrder = 2
      end
      inherited bibClear: TBitBtn
        Left = 4
        Width = 98
        Hint = 'По умолчанию'
        Caption = 'По умолчанию'
        TabOrder = 0
        Visible = True
      end
    end
  end
  inherited cbInString: TCheckBox
    Left = 408
    Top = 17
    TabOrder = 4
  end
  object edPeriod: TEdit [3]
    Left = 80
    Top = 9
    Width = 193
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 0
  end
  object bibPeriod: TBitBtn [4]
    Left = 275
    Top = 9
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 1
    OnClick = bibPeriodClick
  end
  object bibCurPeriod: TBitBtn [5]
    Left = 307
    Top = 9
    Width = 72
    Height = 21
    Hint = 'Выбрать'
    Caption = 'Текущий'
    TabOrder = 2
    OnClick = bibCurPeriodClick
  end
  object grbCase: TGroupBox [6]
    Left = 13
    Top = 34
    Width = 372
    Height = 103
    Caption = ' Кому рассчитать '
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
      Width = 225
      Height = 21
      Color = clBtnFace
      Enabled = False
      MaxLength = 100
      ReadOnly = True
      TabOrder = 2
    end
    object bibEmp: TBitBtn
      Left = 344
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
      Width = 225
      Height = 21
      Color = clBtnFace
      Enabled = False
      MaxLength = 100
      ReadOnly = True
      TabOrder = 5
    end
    object bibDepart: TBitBtn
      Left = 344
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
  inherited IBTran: TIBTransaction
    Left = 144
    Top = 81
  end
  inherited Mainqr: TIBQuery
    Left = 248
    Top = 48
  end
  object qr: TIBQuery
    BufferChunks = 1000
    CachedUpdates = False
    SQL.Strings = (
      'select ct.*,c.name as chargename, al.*, c.* from chargetree ct'
      
        'join charge c on ct.charge_id=c.charge_id join algorithm al on c' +
        '.algorithm_id = al.algorithm_id'
      'order by parent_id')
    Left = 128
    Top = 48
  end
  object IBTransaction: TIBTransaction
    Active = False
    Left = 168
    Top = 48
  end
  object IBQ1: TIBQuery
    BufferChunks = 1000
    CachedUpdates = False
    Left = 104
    Top = 80
  end
  object IBQ2: TIBQuery
    BufferChunks = 1000
    CachedUpdates = False
    SQL.Strings = (
      
        'select e.name as name,  factpay.pay, em.category_id as category,' +
        ' em.datestart, em.releasedate from empplant em join factpay fp  ' +
        'on fp.empplant_id=em.empplant_id join emp e on em.emp_id=e.emp_i' +
        'd')
    Left = 16
    Top = 80
  end
  object ibtranCharge: TIBTransaction
    Active = False
    DefaultAction = TARollback
    Left = 56
    Top = 81
  end
  object qrCharge: TIBQuery
    Transaction = ibtranCharge
    BufferChunks = 1000
    CachedUpdates = False
    Left = 304
    Top = 80
  end
  object ibtranChargeConst: TIBTransaction
    Active = False
    DefaultAction = TARollback
    Left = 368
    Top = 49
  end
  object qrChargeConst: TIBQuery
    Transaction = ibtranChargeConst
    BufferChunks = 1000
    CachedUpdates = False
    Left = 336
    Top = 48
  end
  object qrconst: TIBQuery
    BufferChunks = 1000
    CachedUpdates = False
    Left = 304
    Top = 48
  end
  object ibtUpdate: TIBTransaction
    Active = False
    DefaultAction = TARollback
    Left = 56
    Top = 49
  end
  object UpdateQr: TIBQuery
    BufferChunks = 1000
    CachedUpdates = False
    Left = 16
    Top = 48
  end
  object qrChargeSumm: TIBQuery
    Transaction = ibtranCharge
    BufferChunks = 1000
    CachedUpdates = False
    Left = 336
    Top = 80
  end
  object qrYearSumm: TIBQuery
    BufferChunks = 1000
    CachedUpdates = False
    Left = 248
    Top = 80
  end
  object qrCount: TIBQuery
    BufferChunks = 1000
    CachedUpdates = False
    Left = 368
    Top = 80
  end
end
