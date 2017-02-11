inherited frmRowFilter: TfrmRowFilter
  Left = 404
  Top = 283
  Width = 505
  Height = 576
  Caption = 'Row filter'
  Font.Name = 'MS Sans Serif'
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    Width = 497
    Height = 511
    inherited pnlBorder: TPanel
      Width = 489
      Height = 503
      inherited pnlTitle: TPanel
        Width = 487
        inherited lblTitle: TLabel
          Width = 107
          Caption = 'Row Filter'
        end
        inherited imgAnyDAC: TImage
          Left = 190
        end
        inherited imgGradient: TImage
          Left = 133
        end
        inherited pnlBottom: TPanel
          Width = 487
        end
      end
      inherited pnlMain: TPanel
        Width = 487
        Height = 448
        inherited pnlConnection: TPanel
          Width = 487
          Height = 130
          inherited lblUseConnectionDef: TLabel
            Width = 126
          end
          object Label3: TLabel [1]
            Left = 11
            Top = 53
            Width = 89
            Height = 13
            Alignment = taRightJustify
            Caption = 'RowFilter example:'
          end
          object Label1: TLabel [2]
            Left = 175
            Top = 55
            Width = 72
            Height = 13
            Alignment = taRightJustify
            Caption = 'RowStateFilter:'
          end
          object btnChange: TSpeedButton [3]
            Left = 11
            Top = 100
            Width = 89
            Height = 21
            Caption = 'Change data'
            Enabled = False
            Flat = True
            OnClick = btnChangeClick
          end
          object btnAccept: TSpeedButton [4]
            Left = 111
            Top = 100
            Width = 96
            Height = 21
            Caption = 'Accept Changes'
            Enabled = False
            Flat = True
            OnClick = btnAcceptClick
          end
          object btnResetFilters: TSpeedButton [5]
            Left = 340
            Top = 70
            Width = 96
            Height = 21
            Caption = 'Reset filters'
            Enabled = False
            Flat = True
            OnClick = btnResetFiltersClick
          end
          inherited cbDB: TComboBox
            TabOrder = 2
          end
          object cbRowStates: TComboBox
            Left = 175
            Top = 70
            Width = 150
            Height = 21
            BevelInner = bvSpace
            BevelKind = bkFlat
            BevelOuter = bvRaised
            Style = csDropDownList
            Enabled = False
            ItemHeight = 13
            TabOrder = 0
            OnChange = cbRowStatesChange
            Items.Strings = (
              'rsDetached'
              'rsInserted'
              'rsDeleted'
              'rsModified'
              'rsUnchanged')
          end
          object cbRowFilter: TComboBox
            Left = 11
            Top = 70
            Width = 150
            Height = 21
            BevelInner = bvSpace
            BevelKind = bkFlat
            BevelOuter = bvRaised
            Enabled = False
            ItemHeight = 13
            TabOrder = 1
            OnChange = cbRowFilterChange
            Items.Strings = (
              'ShipperID < 2'
              'left(CompanyName, 1) = '#39'S'#39)
          end
        end
        inherited Console: TMemo
          Top = 130
          Width = 487
          Height = 318
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 511
    Width = 497
    inherited btnClose: TButton
      Left = 418
    end
  end
end
