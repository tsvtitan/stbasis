inherited frmAddTools: TfrmAddTools
  Left = 692
  Top = 402
  ActiveControl = edtTitle
  Caption = 'Tool Properties'
  ClientHeight = 151
  ClientWidth = 552
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 20
    Top = 27
    Width = 23
    Height = 13
    Caption = '&Title:'
    FocusControl = edtTitle
  end
  object Label2: TLabel
    Left = 20
    Top = 57
    Width = 39
    Height = 13
    Caption = '&Program'
    FocusControl = edtProgram
  end
  object Label3: TLabel
    Left = 21
    Top = 87
    Width = 59
    Height = 13
    Caption = '&Working Dir:'
    FocusControl = edtWorkingDir
  end
  object Label4: TLabel
    Left = 21
    Top = 118
    Width = 56
    Height = 13
    Caption = 'P&arameters:'
    FocusControl = edtParams
  end
  object edtTitle: TEdit
    Left = 98
    Top = 17
    Width = 355
    Height = 21
    TabOrder = 0
  end
  object edtProgram: TEdit
    Left = 98
    Top = 47
    Width = 355
    Height = 21
    TabOrder = 1
  end
  object edtWorkingDir: TEdit
    Left = 98
    Top = 78
    Width = 355
    Height = 21
    TabOrder = 2
  end
  object edtParams: TEdit
    Left = 98
    Top = 108
    Width = 355
    Height = 21
    TabOrder = 3
  end
  object btnOK: TButton
    Left = 467
    Top = 21
    Width = 75
    Height = 25
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 4
  end
  object btnCancel: TButton
    Left = 467
    Top = 58
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 5
  end
  object btnBrowse: TButton
    Left = 467
    Top = 97
    Width = 75
    Height = 25
    Caption = '&Browse'
    TabOrder = 6
    OnClick = btnBrowseClick
  end
end
