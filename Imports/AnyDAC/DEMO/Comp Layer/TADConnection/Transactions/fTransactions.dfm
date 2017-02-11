inherited frmTransactions: TfrmTransactions
  Left = 394
  Top = 216
  Width = 533
  Height = 469
  Caption = 'Transactions'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    Width = 525
    Height = 385
    inherited pnlBorder: TPanel
      Width = 517
      Height = 377
      inherited pnlTitle: TPanel
        Width = 515
        inherited lblTitle: TLabel
          Width = 135
          Caption = 'Transactions'
        end
        inherited imgAnyDAC: TImage
          Left = 218
        end
        inherited imgGradient: TImage
          Left = 161
        end
        inherited pnlBottom: TPanel
          Width = 515
        end
      end
      inherited pnlMain: TPanel
        Width = 515
        Height = 322
        Ctl3D = False
        ParentCtl3D = False
        object lblPInfo: TLabel [0]
          Left = 7
          Top = 58
          Width = 64
          Height = 13
          Caption = 'Process Info:'
        end
        inherited pnlConnection: TPanel
          Width = 515
          TabOrder = 1
        end
        object mmInfo: TMemo
          Left = 0
          Top = 57
          Width = 515
          Height = 265
          Align = alClient
          BevelInner = bvSpace
          BevelKind = bkFlat
          BorderStyle = bsNone
          Ctl3D = True
          Lines.Strings = (
            '')
          ParentCtl3D = False
          TabOrder = 0
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 385
    Width = 525
    inherited btnClose: TButton
      Left = 446
    end
  end
  inherited StatusBar1: TStatusBar
    Top = 416
    Width = 525
  end
  object ADQuery1: TADQuery
    Connection = dmlMainComp.dbMain
    FetchOptions.Items = [fiBlobs, fiDetails]
    Left = 188
    Top = 75
  end
end
