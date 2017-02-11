inherited frmAutoInc: TfrmAutoInc
  Left = 339
  Top = 168
  Width = 556
  Height = 510
  Caption = 'Auto inc fields'
  Font.Name = 'MS Sans Serif'
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    Width = 548
    Height = 445
    inherited pnlBorder: TPanel
      Width = 540
      Height = 437
      inherited pnlTitle: TPanel
        Width = 538
        inherited lblTitle: TLabel
          Width = 155
          Caption = 'Auto Inc Fields'
        end
        inherited imgAnyDAC: TImage
          Left = 241
        end
        inherited imgGradient: TImage
          Left = 184
        end
        inherited pnlBottom: TPanel
          Width = 538
        end
      end
      inherited pnlMain: TPanel
        Width = 538
        Height = 382
        inherited pnlConnection: TPanel
          Width = 538
          Height = 121
          inherited lblUseConnectionDef: TLabel
            Width = 126
          end
          object btnInsert: TSpeedButton [1]
            Left = 125
            Top = 53
            Width = 76
            Height = 21
            Caption = 'Insert rows'
            Enabled = False
            Flat = True
            OnClick = btnInsertClick
          end
          inherited cbDB: TComboBox
            TabOrder = 2
          end
          object edtSeed: TLabeledEdit
            Left = 80
            Top = 53
            Width = 33
            Height = 21
            BevelInner = bvSpace
            BevelKind = bkFlat
            BorderStyle = bsNone
            EditLabel.Width = 65
            EditLabel.Height = 13
            EditLabel.Caption = 'AutoIncSeed:'
            LabelPosition = lpLeft
            TabOrder = 0
            Text = '-1'
          end
          object edtStep: TLabeledEdit
            Left = 80
            Top = 82
            Width = 33
            Height = 21
            BevelInner = bvSpace
            BevelKind = bkFlat
            BorderStyle = bsNone
            EditLabel.Width = 62
            EditLabel.Height = 13
            EditLabel.Caption = 'AutoIncStep:'
            LabelPosition = lpLeft
            TabOrder = 1
            Text = '-1'
          end
        end
        inherited Console: TMemo
          Top = 121
          Width = 538
          Height = 261
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 445
    Width = 548
    inherited btnClose: TButton
      Left = 469
    end
  end
end
