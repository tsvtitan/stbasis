inherited frmAggregates: TfrmAggregates
  Left = 322
  Top = 266
  Width = 580
  Height = 419
  Caption = 'Aggregates'
  Font.Name = 'MS Sans Serif'
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    Width = 572
    Height = 354
    inherited pnlBorder: TPanel
      Width = 564
      Height = 346
      inherited pnlTitle: TPanel
        Width = 562
        inherited lblTitle: TLabel
          Width = 119
          Caption = 'Aggregates'
        end
        inherited imgAnyDAC: TImage
          Left = 262
        end
        inherited imgGradient: TImage
          Left = 205
        end
        inherited pnlBottom: TPanel
          Width = 562
        end
      end
      inherited pnlMain: TPanel
        Width = 562
        Height = 291
        inherited pnlControlButtons: TPanel
          Width = 562
          Height = 103
          object btnCreateTable: TSpeedButton
            Left = 11
            Top = 8
            Width = 97
            Height = 21
            Caption = 'Create table'
            Flat = True
            OnClick = btnCreateTableClick
          end
          object btnCreateView: TSpeedButton
            Left = 115
            Top = 8
            Width = 97
            Height = 21
            Caption = 'Create view'
            Enabled = False
            Flat = True
            OnClick = btnCreateViewClick
          end
          object btnInsert: TSpeedButton
            Left = 11
            Top = 36
            Width = 97
            Height = 21
            Caption = 'Insert a row'
            Enabled = False
            Flat = True
            OnClick = btnInsertClick
          end
          object Memo1: TMemo
            Left = 0
            Top = 67
            Width = 562
            Height = 36
            Align = alBottom
            BevelInner = bvSpace
            BevelKind = bkFlat
            BorderStyle = bsNone
            Color = clInfoBk
            Lines.Strings = (
              
                'This demo shows how to create DatS aggregates, create DatS views' +
                ', fill data.'
              'For details see fAggregates unit.')
            TabOrder = 0
          end
        end
        inherited Console: TMemo
          Top = 103
          Width = 562
          Height = 188
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 354
    Width = 572
    inherited btnClose: TButton
      Left = 493
    end
  end
end
