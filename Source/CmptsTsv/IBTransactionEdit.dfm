object IBTransactionEditForm: TIBTransactionEditForm
  Left = 289
  Top = 237
  ActiveControl = OKBtn
  BorderStyle = bsDialog
  BorderWidth = 5
  Caption = 'Редактор транзакций'
  ClientHeight = 158
  ClientWidth = 313
  Color = clBtnFace
  ParentFont = True
  HelpFile = 'ibx.hlp'
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 313
    Height = 124
    Align = alClient
    Caption = ' Свойства транзакций '
    TabOrder = 0
    object Label1: TLabel
      Left = 163
      Top = 13
      Width = 58
      Height = 13
      Caption = 'Нас&тройка:'
      FocusControl = TransactionParams
    end
    object rbSnapShot: TRadioButton
      Left = 7
      Top = 26
      Width = 150
      Height = 14
      Caption = '&Snapshot'
      TabOrder = 0
      OnClick = rbSnapShotClick
    end
    object rbReadCommitted: TRadioButton
      Left = 7
      Top = 48
      Width = 150
      Height = 14
      Caption = 'Read &Committed'
      TabOrder = 1
      OnClick = rbReadCommittedClick
    end
    object rbReadOnlyTableStability: TRadioButton
      Left = 7
      Top = 69
      Width = 150
      Height = 14
      Caption = '&Read-Only Table Stability'
      TabOrder = 2
      OnClick = rbReadOnlyTableStabilityClick
    end
    object rbReadWriteTableStability: TRadioButton
      Left = 7
      Top = 91
      Width = 150
      Height = 14
      Caption = 'Read-&Write Table Stability '
      TabOrder = 3
      OnClick = rbReadWriteTableStabilityClick
    end
    object TransactionParams: TMemo
      Left = 163
      Top = 26
      Width = 139
      Height = 79
      Lines.Strings = (
        '')
      ScrollBars = ssBoth
      TabOrder = 4
      WordWrap = False
      OnClick = TransactionParamsClick
      OnExit = TransactionParamsExit
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 124
    Width = 313
    Height = 34
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 1
    object HelpBtn: TButton
      Left = 237
      Top = 8
      Width = 75
      Height = 25
      Caption = '&Help'
      Enabled = False
      TabOrder = 0
      OnClick = HelpBtnClick
    end
    object Cancelbtn: TButton
      Left = 153
      Top = 8
      Width = 74
      Height = 25
      Cancel = True
      Caption = 'Отмена'
      ModalResult = 2
      TabOrder = 2
    end
    object OKBtn: TButton
      Left = 68
      Top = 8
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      TabOrder = 1
      OnClick = OKBtnClick
    end
  end
end
