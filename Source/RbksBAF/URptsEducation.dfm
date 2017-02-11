inherited fmRptsEducation: TfmRptsEducation
  Left = 219
  Caption = 'Отчёт по образованию'
  ClientHeight = 144
  ClientWidth = 438
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBut: TPanel
    Top = 106
    Width = 438
    inherited Panel2: TPanel
      Left = 52
    end
  end
  object RGReportType: TRadioGroup [2]
    Left = 8
    Top = 0
    Width = 425
    Height = 99
    Caption = 'Вид отчёта'
    Items.Strings = (
      'по виду образования'
      'по специальности')
    TabOrder = 2
  end
  object EdEduc: TEdit [3]
    Left = 150
    Top = 23
    Width = 251
    Height = 21
    Color = clMenu
    ReadOnly = True
    TabOrder = 3
    OnKeyDown = EdEducKeyDown
  end
  object EdProfession: TEdit [4]
    Left = 150
    Top = 63
    Width = 251
    Height = 21
    Color = clMenu
    ReadOnly = True
    TabOrder = 4
    OnKeyDown = EdProfessionKeyDown
  end
  object BtTypeStudy: TButton [5]
    Left = 400
    Top = 24
    Width = 21
    Height = 20
    Caption = '...'
    TabOrder = 5
    OnClick = BtTypeStudyClick
  end
  object BtProfession: TButton [6]
    Left = 400
    Top = 63
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 6
    OnClick = BtProfessionClick
  end
  inherited IBTran: TIBTransaction
    Left = 40
    Top = 121
  end
  inherited Mainqr: TIBQuery
    Left = 8
    Top = 120
  end
end
