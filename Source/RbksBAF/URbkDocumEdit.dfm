inherited FmRbkDocumEdit: TFmRbkDocumEdit
  Caption = 'FmRbkDocumEdit'
  ClientHeight = 158
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnBtn: TPanel
    Top = 118
  end
  inherited PnEdit: TPanel
    Height = 118
    object LbNum: TLabel [0]
      Left = 8
      Top = 12
      Width = 37
      Height = 13
      Caption = 'Номер:'
    end
    object LbTypeDoc: TLabel [1]
      Left = 8
      Top = 41
      Width = 22
      Height = 13
      Caption = 'Тип:'
    end
    object LbDateDoc: TLabel [2]
      Left = 8
      Top = 71
      Width = 29
      Height = 13
      Caption = 'Дата:'
    end
    inherited PnFilter: TPanel
      Top = 99
    end
    object EdNum: TEdit
      Left = 64
      Top = 8
      Width = 89
      Height = 21
      TabOrder = 1
      OnChange = EdNumChange
    end
    object EdTypeDoc: TEdit
      Left = 64
      Top = 37
      Width = 231
      Height = 21
      Color = clMenu
      ReadOnly = True
      TabOrder = 2
      OnKeyDown = EdTypeDocKeyDown
    end
    object BtCallTypeDoc: TButton
      Left = 296
      Top = 37
      Width = 21
      Height = 21
      Caption = '...'
      TabOrder = 3
      OnClick = BtCallTypeDocClick
    end
    object DPDateDoc: TDateTimePicker
      Left = 64
      Top = 67
      Width = 105
      Height = 21
      CalAlignment = dtaLeft
      Date = 37166.6274543981
      Time = 37166.6274543981
      ShowCheckbox = True
      DateFormat = dfShort
      DateMode = dmComboBox
      Kind = dtkDate
      ParseInput = False
      TabOrder = 4
      OnChange = EdNumChange
    end
  end
  inherited IBQ: TIBQuery
    Left = 248
    Top = 165
  end
  inherited Trans: TIBTransaction
    Left = 288
    Top = 165
  end
end
