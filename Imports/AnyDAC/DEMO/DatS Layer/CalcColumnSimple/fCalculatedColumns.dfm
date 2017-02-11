inherited frmCalculatedColumns: TfrmCalculatedColumns
  Left = 333
  Top = 354
  Width = 595
  Height = 421
  Caption = 'Calculated columns'
  Font.Name = 'MS Sans Serif'
  OldCreateOrder = False
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    Width = 587
    Height = 356
    inherited pnlBorder: TPanel
      Width = 579
      Height = 348
      inherited pnlTitle: TPanel
        Width = 577
        inherited lblTitle: TLabel
          Width = 203
          Caption = 'Calculated columns'
        end
        inherited imgAnyDAC: TImage
          Left = 280
        end
        inherited imgGradient: TImage
          Left = 223
        end
        inherited pnlBottom: TPanel
          Width = 577
        end
      end
      inherited pnlMain: TPanel
        Width = 577
        Height = 293
        inherited pnlControlButtons: TPanel
          Width = 577
          Height = 65
          object btnCreateTable: TSpeedButton
            Left = 6
            Top = 8
            Width = 78
            Height = 23
            Caption = 'Create table'
            Flat = True
            OnClick = btnCreateTableClick
          end
          object btnModify: TSpeedButton
            Left = 97
            Top = 8
            Width = 112
            Height = 23
            Caption = 'Modify expression'
            Enabled = False
            Flat = True
            OnClick = btnModifyClick
          end
          object edtCurExpression: TLabeledEdit
            Left = 63
            Top = 38
            Width = 146
            Height = 21
            BevelInner = bvSpace
            BevelKind = bkFlat
            BorderStyle = bsNone
            EditLabel.Width = 54
            EditLabel.Height = 13
            EditLabel.Caption = 'Expression:'
            LabelPosition = lpLeft
            TabOrder = 0
            OnKeyPress = edtCurExpressionKeyPress
          end
          object mmInfo: TMemo
            Left = 228
            Top = 8
            Width = 278
            Height = 50
            BevelInner = bvSpace
            BevelKind = bkFlat
            BorderStyle = bsNone
            Color = clInfoBk
            Lines.Strings = (
              'You may type expression by hands in the Expression edit, '
              'than press Enter')
            TabOrder = 1
          end
        end
        inherited Console: TMemo
          Top = 65
          Width = 577
          Height = 228
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 356
    Width = 587
    inherited btnClose: TButton
      Left = 508
    end
  end
end
