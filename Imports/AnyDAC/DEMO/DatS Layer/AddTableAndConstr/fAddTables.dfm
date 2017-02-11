inherited frmAddTables: TfrmAddTables
  Left = 340
  Top = 185
  Width = 521
  Height = 425
  Caption = 'Add tables'
  Font.Name = 'MS Sans Serif'
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    Width = 513
    Height = 360
    inherited pnlBorder: TPanel
      Width = 505
      Height = 352
      inherited pnlTitle: TPanel
        Width = 503
        inherited lblTitle: TLabel
          Width = 110
          Caption = 'Add tables'
        end
        inherited imgAnyDAC: TImage
          Left = 203
        end
        inherited imgGradient: TImage
          Left = 146
        end
        inherited pnlBottom: TPanel
          Width = 503
        end
      end
      inherited pnlMain: TPanel
        Width = 503
        Height = 297
        inherited pnlControlButtons: TPanel
          Width = 503
          Height = 97
          object btnCreateTables: TSpeedButton
            Left = 11
            Top = 8
            Width = 76
            Height = 21
            Caption = 'Create tables'
            Flat = True
            OnClick = btnCreateTablesClick
          end
          object btnAddConstr: TSpeedButton
            Left = 102
            Top = 8
            Width = 105
            Height = 21
            Caption = 'Add constraints'
            Flat = True
            OnClick = btnAddConstrClick
          end
          object Memo1: TMemo
            Left = 0
            Top = 40
            Width = 503
            Height = 57
            Align = alBottom
            BevelInner = bvSpace
            BevelKind = bkFlat
            BorderStyle = bsNone
            Color = clInfoBk
            Lines.Strings = (
              
                'This demo shows how to create DatS tables, define DatS constrain' +
                'ts, fill data.'
              'For details see fAddTables unit.')
            TabOrder = 0
          end
        end
        inherited Console: TMemo
          Top = 97
          Width = 503
          Height = 200
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 360
    Width = 513
    inherited btnClose: TButton
      Left = 434
    end
  end
end
