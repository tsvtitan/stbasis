inherited fmEditRBToolbar: TfmEditRBToolbar
  Left = 521
  Caption = 'fmEditRBToolbar'
  ClientHeight = 171
  ClientWidth = 316
  PixelsPerInch = 96
  TextHeight = 13
  object lbName: TLabel [0]
    Left = 8
    Top = 14
    Width = 79
    Height = 13
    Caption = 'Наименование:'
  end
  object lbHint: TLabel [1]
    Left = 34
    Top = 37
    Width = 53
    Height = 13
    Alignment = taRightJustify
    Caption = 'Описание:'
  end
  object lbShortCut: TLabel [2]
    Left = 87
    Top = 99
    Width = 91
    Height = 13
    Alignment = taRightJustify
    Caption = 'Горячая клавиша:'
  end
  inherited pnBut: TPanel
    Top = 133
    Width = 316
    TabOrder = 4
    inherited Panel2: TPanel
      Left = 131
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 117
    TabOrder = 3
  end
  object edName: TEdit [5]
    Left = 97
    Top = 10
    Width = 210
    Height = 21
    MaxLength = 100
    TabOrder = 0
    OnChange = edNameChange
  end
  object meHint: TMemo [6]
    Left = 96
    Top = 36
    Width = 212
    Height = 55
    TabOrder = 1
    OnChange = edNameChange
  end
  object htShortCut: THotKey [7]
    Left = 187
    Top = 96
    Width = 121
    Height = 19
    HotKey = 0
    InvalidKeys = [hcShift, hcAlt, hcShiftAlt, hcShiftCtrlAlt]
    Modifiers = []
    TabOrder = 2
    OnEnter = htShortCutEnter
    OnExit = htShortCutEnter
  end
  inherited IBTran: TIBTransaction
    Left = 16
    Top = 67
  end
end
