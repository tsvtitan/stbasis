inherited frmGetChanges: TfrmGetChanges
  Left = 359
  Top = 224
  Width = 526
  Height = 507
  Caption = 'GetChanges'
  Font.Name = 'MS Sans Serif'
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    Width = 518
    Height = 442
    inherited pnlBorder: TPanel
      Width = 510
      Height = 434
      inherited pnlTitle: TPanel
        Width = 508
        inherited lblTitle: TLabel
          Width = 129
          Caption = 'Get changes'
        end
        inherited imgAnyDAC: TImage
          Left = 211
        end
        inherited imgGradient: TImage
          Left = 154
        end
        inherited pnlBottom: TPanel
          Width = 508
        end
      end
      inherited pnlMain: TPanel
        Width = 508
        Height = 379
        inherited pnlConnection: TPanel
          Width = 508
          Height = 97
          inherited lblUseConnectionDef: TLabel
            Width = 126
          end
          object btnSelect: TSpeedButton [1]
            Left = 175
            Top = 25
            Width = 87
            Height = 21
            Caption = 'Select'
            Enabled = False
            Flat = True
            OnClick = btnSelectClick
          end
          object Label3: TLabel [2]
            Left = 274
            Top = 60
            Width = 25
            Height = 13
            Alignment = taRightJustify
            Caption = 'Filter:'
          end
          object Label1: TLabel [3]
            Left = 277
            Top = 29
            Width = 22
            Height = 13
            Alignment = taRightJustify
            Caption = 'Sort:'
          end
          inherited cbDB: TComboBox
            TabOrder = 2
          end
          object cbFilter: TComboBox
            Left = 304
            Top = 56
            Width = 137
            Height = 21
            BevelInner = bvSpace
            BevelKind = bkFlat
            Ctl3D = True
            ItemHeight = 13
            ParentCtl3D = False
            TabOrder = 0
            Items.Strings = (
              'ShipperID < 5'
              'ShipperID > 3'
              'ShipperID = 7'
              'Length(CompanyName) > 8')
          end
          object cbSort: TComboBox
            Left = 304
            Top = 25
            Width = 137
            Height = 21
            BevelInner = bvSpace
            BevelKind = bkFlat
            Ctl3D = True
            ItemHeight = 13
            ParentCtl3D = False
            TabOrder = 1
            Items.Strings = (
              'ShipperId'
              'CompanyName'
              'Phone')
          end
          object mmInfo: TMemo
            Left = 8
            Top = 56
            Width = 254
            Height = 33
            BevelInner = bvSpace
            BevelKind = bkFlat
            BorderStyle = bsNone
            Color = clInfoBk
            Ctl3D = True
            Lines.Strings = (
              'Select the values in Filter or/and Sort combo box '
              'and press Select')
            ParentCtl3D = False
            TabOrder = 3
          end
        end
        inherited Console: TMemo
          Top = 97
          Width = 508
          Height = 282
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 442
    Width = 518
    inherited btnClose: TButton
      Left = 439
    end
  end
end
