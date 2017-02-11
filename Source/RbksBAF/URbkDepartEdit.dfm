inherited FmRbkDepartEdit: TFmRbkDepartEdit
  Caption = 'Редактирование'
  ClientHeight = 166
  ClientWidth = 386
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnBtn: TPanel
    Top = 126
    Width = 386
    inherited Panel1: TPanel
      Left = 209
    end
  end
  inherited PnEdit: TPanel
    Width = 386
    Height = 126
    object LbCode: TLabel [0]
      Left = 10
      Top = 9
      Width = 22
      Height = 13
      Caption = 'Код:'
    end
    object LbName: TLabel [1]
      Left = 10
      Top = 34
      Width = 79
      Height = 13
      Caption = 'Наименование:'
    end
    object LbFType: TLabel [2]
      Left = 10
      Top = 59
      Width = 22
      Height = 13
      Caption = 'Тип:'
    end
    object LbParent: TLabel [3]
      Left = 10
      Top = 84
      Width = 51
      Height = 13
      Caption = 'Родитель:'
    end
    inherited PnFilter: TPanel
      Top = 108
      Width = 386
      Height = 18
    end
    object EdCode: TEdit
      Left = 98
      Top = 5
      Width = 63
      Height = 21
      TabOrder = 1
      OnChange = EdCodeChange
    end
    object Edname: TEdit
      Left = 98
      Top = 30
      Width = 275
      Height = 21
      TabOrder = 2
      OnChange = EdnameChange
    end
    object EdFType: TEdit
      Left = 98
      Top = 55
      Width = 63
      Height = 21
      TabOrder = 3
      OnChange = EdFTypeChange
    end
    object EdParent: TEdit
      Left = 98
      Top = 80
      Width = 254
      Height = 21
      Color = clMenu
      ReadOnly = True
      TabOrder = 4
    end
    object BtCallParent: TButton
      Left = 352
      Top = 80
      Width = 21
      Height = 21
      Caption = '...'
      TabOrder = 5
      OnClick = BtCallParentClick
    end
  end
  inherited IBQ: TIBQuery
    Left = 176
    Top = 141
  end
  inherited Trans: TIBTransaction
    Left = 144
    Top = 141
  end
end
