inherited frmMain: TfrmMain
  Left = 314
  Top = 197
  Width = 528
  Height = 470
  Caption = 'Batch'
  Font.Name = 'MS Sans Serif'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    Width = 520
    Height = 386
    inherited pnlBorder: TPanel
      Width = 512
      Height = 378
      inherited pnlTitle: TPanel
        Width = 510
        inherited lblTitle: TLabel
          Width = 60
          Caption = 'Batch'
        end
        inherited imgAnyDAC: TImage
          Left = 213
        end
        inherited imgGradient: TImage
          Left = 156
        end
        inherited pnlBottom: TPanel
          Width = 510
        end
      end
      inherited pnlMain: TPanel
        Width = 510
        Height = 323
        inherited pnlConnection: TPanel
          Width = 510
          inherited lblUseConnectionDef: TLabel
            Width = 126
          end
          object Label1: TLabel [1]
            Left = 184
            Top = 27
            Width = 80
            Height = 13
            Caption = 'Records to insert'
          end
          inherited cbDB: TComboBox
            TabOrder = 1
          end
          object chbBlobs: TCheckBox
            Left = 352
            Top = 27
            Width = 97
            Height = 17
            Caption = 'Insert blobs'
            TabOrder = 0
          end
          object edtRecordsToInsert: TEdit
            Left = 272
            Top = 24
            Width = 65
            Height = 21
            TabOrder = 2
            Text = '10000'
          end
        end
        inherited Console: TMemo
          Width = 510
          Height = 266
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 386
    Width = 520
    inherited btnClose: TButton
      Left = 441
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 417
    Width = 520
    Height = 19
    Panels = <
      item
        Width = 270
      end
      item
        Width = 270
      end>
  end
end
