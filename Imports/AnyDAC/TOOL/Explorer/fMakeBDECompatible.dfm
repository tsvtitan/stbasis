inherited frmMakeBDECompatible: TfrmMakeBDECompatible
  Left = 388
  Top = 365
  Caption = 'AnyDAC BDE Compatibility'
  ClientHeight = 129
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlButtons: TADGUIxFormsPanel
    Top = 95
  end
  inherited pnlMain: TADGUIxFormsPanel
    Height = 95
    inherited pnlGray: TADGUIxFormsPanel
      Height = 87
      inherited pnlOptions: TADGUIxFormsPanel
        Height = 62
        object cbEnableBCD: TCheckBox
          Left = 11
          Top = 11
          Width = 97
          Height = 17
          Caption = 'Enable &BCD'
          TabOrder = 0
        end
        object cbEnableIntegers: TCheckBox
          Left = 11
          Top = 35
          Width = 97
          Height = 17
          Caption = 'Enable &Integers'
          TabOrder = 1
        end
      end
      inherited pnlTitle: TADGUIxFormsPanel
        inherited lblTitle: TLabel
          Width = 286
          Caption = 'Set connection definition BDE compatibility options'
        end
      end
    end
  end
end
