inherited frmSearch: TfrmSearch
  Left = 385
  Top = 261
  Width = 572
  Height = 581
  Caption = 'Searching in View'
  Font.Name = 'MS Sans Serif'
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    Width = 564
    Height = 516
    inherited pnlBorder: TPanel
      Width = 556
      Height = 508
      inherited pnlTitle: TPanel
        Width = 554
        inherited lblTitle: TLabel
          Width = 185
          Caption = 'Searching in View'
        end
        inherited imgAnyDAC: TImage
          Left = 257
        end
        inherited imgGradient: TImage
          Left = 200
        end
        inherited pnlBottom: TPanel
          Width = 554
        end
      end
      inherited pnlMain: TPanel
        Width = 554
        Height = 453
        inherited pnlConnection: TPanel
          Width = 554
          Height = 153
          inherited lblUseConnectionDef: TLabel
            Width = 126
          end
          object Label3: TLabel [1]
            Left = 150
            Top = 50
            Width = 216
            Height = 13
            Caption = 'ShipperID            CompanyName          Phone'
          end
          object btnFindSorted: TSpeedButton [2]
            Left = 11
            Top = 57
            Width = 76
            Height = 21
            Caption = 'Find sorted'
            Enabled = False
            Flat = True
            OnClick = btnFindSortedClick
          end
          object btnLocate: TSpeedButton [3]
            Left = 11
            Top = 121
            Width = 76
            Height = 21
            Caption = 'Locate'
            Enabled = False
            Flat = True
            OnClick = btnLocateClick
          end
          object Label4: TLabel [4]
            Left = 109
            Top = 124
            Width = 89
            Height = 13
            Alignment = taRightJustify
            Caption = 'Locate expression:'
          end
          object btnFindUnSorted: TSpeedButton [5]
            Left = 11
            Top = 88
            Width = 76
            Height = 21
            Caption = 'Find unsorted'
            Enabled = False
            Flat = True
            OnClick = btnFindUnSortedClick
          end
          inherited cbDB: TComboBox
            TabOrder = 4
          end
          object edtShipperId: TLabeledEdit
            Left = 149
            Top = 71
            Width = 29
            Height = 21
            BevelInner = bvSpace
            BevelKind = bkFlat
            BorderStyle = bsNone
            EditLabel.Width = 35
            EditLabel.Height = 13
            EditLabel.Caption = 'Values:'
            LabelPosition = lpLeft
            TabOrder = 0
            Text = '1'
          end
          object edtCompanyName: TEdit
            Left = 232
            Top = 71
            Width = 97
            Height = 21
            BevelInner = bvSpace
            BevelKind = bkFlat
            BorderStyle = bsNone
            TabOrder = 1
            Text = 'Speedy Express'
          end
          object edtPhone: TEdit
            Left = 336
            Top = 71
            Width = 106
            Height = 21
            BevelInner = bvSpace
            BevelKind = bkFlat
            BorderStyle = bsNone
            TabOrder = 2
            Text = '(503) 555-9831'
          end
          object cbLocate: TComboBox
            Left = 203
            Top = 121
            Width = 137
            Height = 21
            BevelInner = bvSpace
            BevelKind = bkFlat
            BevelOuter = bvRaised
            ItemHeight = 13
            TabOrder = 3
            Text = 'ShipperID = 2'
            Items.Strings = (
              'ShipperID = 2'
              'CompanyName = '#39'Federal Shipping'#39)
          end
        end
        inherited Console: TMemo
          Top = 153
          Width = 554
          Height = 300
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 516
    Width = 564
    inherited btnClose: TButton
      Left = 485
    end
  end
end
