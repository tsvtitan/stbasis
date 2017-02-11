object frmCalWeekEdit: TfrmCalWeekEdit
  Left = 386
  Top = 185
  BorderStyle = bsDialog
  Caption = 'frmCalWeekEdit'
  ClientHeight = 350
  ClientWidth = 286
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 32
    Width = 115
    Height = 13
    Caption = 'Наименование недели'
  end
  object Label11: TLabel
    Left = 8
    Top = 8
    Width = 102
    Height = 13
    Caption = 'Текущий календарь'
  end
  object EditWeekName: TEdit
    Left = 152
    Top = 32
    Width = 121
    Height = 21
    TabOrder = 1
    Text = '<Укажите имя>'
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 56
    Width = 273
    Height = 257
    Caption = 'Рабочие часы'
    TabOrder = 2
    object Label2: TLabel
      Left = 8
      Top = 18
      Width = 68
      Height = 13
      Caption = 'Понедельник'
    end
    object Label3: TLabel
      Left = 8
      Top = 42
      Width = 42
      Height = 13
      Caption = 'Вторник'
    end
    object Label4: TLabel
      Left = 8
      Top = 66
      Width = 31
      Height = 13
      Caption = 'Среда'
    end
    object Label5: TLabel
      Left = 8
      Top = 90
      Width = 42
      Height = 13
      Caption = 'Четверг'
    end
    object Label6: TLabel
      Left = 8
      Top = 114
      Width = 43
      Height = 13
      Caption = 'Пятница'
    end
    object Label7: TLabel
      Left = 8
      Top = 138
      Width = 41
      Height = 13
      Caption = 'Суббота'
    end
    object Label8: TLabel
      Left = 8
      Top = 162
      Width = 67
      Height = 13
      Caption = 'Воскресенье'
    end
    object Label9: TLabel
      Left = 8
      Top = 194
      Width = 120
      Height = 13
      Caption = 'Предпраздничный день'
    end
    object Label10: TLabel
      Left = 8
      Top = 226
      Width = 126
      Height = 13
      Caption = 'Среднемесячное по году'
    end
    object Bevel1: TBevel
      Left = 8
      Top = 186
      Width = 257
      Height = 9
      Shape = bsTopLine
    end
    object Bevel2: TBevel
      Left = 8
      Top = 218
      Width = 257
      Height = 9
      Shape = bsTopLine
    end
    object RxSpinEdit1: TRxSpinEdit
      Left = 144
      Top = 16
      Width = 121
      Height = 21
      ButtonKind = bkStandard
      Increment = 0.25
      ValueType = vtFloat
      Value = 7
      TabOrder = 0
    end
    object RxSpinEdit2: TRxSpinEdit
      Left = 144
      Top = 40
      Width = 121
      Height = 21
      ButtonKind = bkStandard
      Increment = 0.25
      ValueType = vtFloat
      Value = 7
      TabOrder = 1
    end
    object RxSpinEdit3: TRxSpinEdit
      Left = 144
      Top = 64
      Width = 121
      Height = 21
      ButtonKind = bkStandard
      Increment = 0.25
      ValueType = vtFloat
      Value = 7
      TabOrder = 2
    end
    object RxSpinEdit4: TRxSpinEdit
      Left = 144
      Top = 88
      Width = 121
      Height = 21
      ButtonKind = bkStandard
      Increment = 0.25
      ValueType = vtFloat
      Value = 7
      TabOrder = 3
    end
    object RxSpinEdit5: TRxSpinEdit
      Left = 144
      Top = 112
      Width = 121
      Height = 21
      ButtonKind = bkStandard
      Increment = 0.25
      ValueType = vtFloat
      Value = 7
      TabOrder = 4
    end
    object RxSpinEdit6: TRxSpinEdit
      Left = 144
      Top = 136
      Width = 121
      Height = 21
      ButtonKind = bkStandard
      Increment = 0.25
      ValueType = vtFloat
      TabOrder = 5
    end
    object RxSpinEdit7: TRxSpinEdit
      Left = 144
      Top = 160
      Width = 121
      Height = 21
      ButtonKind = bkStandard
      Increment = 0.25
      ValueType = vtFloat
      TabOrder = 6
    end
    object RxSpinEdit8: TRxSpinEdit
      Left = 144
      Top = 192
      Width = 121
      Height = 21
      ButtonKind = bkStandard
      Increment = 0.25
      ValueType = vtFloat
      Value = 6
      TabOrder = 7
    end
    object RxSpinEdit9: TRxSpinEdit
      Left = 144
      Top = 224
      Width = 121
      Height = 21
      ButtonKind = bkStandard
      Increment = 0.25
      ValueType = vtFloat
      TabOrder = 8
    end
  end
  object btnOK: TButton
    Left = 128
    Top = 320
    Width = 75
    Height = 25
    Caption = 'ОК'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object btnCancel: TButton
    Left = 208
    Top = 320
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Отмена'
    ModalResult = 2
    TabOrder = 4
  end
  object EditCurDate: TEdit
    Left = 152
    Top = 8
    Width = 121
    Height = 21
    TabStop = False
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 0
  end
  object quTemp: TIBQuery
    Transaction = trTemp
    BufferChunks = 1000
    CachedUpdates = False
    Left = 80
    Top = 96
  end
  object trTemp: TIBTransaction
    Active = False
    DefaultAction = TACommitRetaining
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    Left = 152
    Top = 96
  end
end
