inherited frmMetaTables: TfrmMetaTables
  Left = 337
  Top = 230
  Width = 679
  Height = 518
  Caption = 'Meta info about tables'
  Font.Name = 'MS Sans Serif'
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    Width = 671
    Height = 460
    inherited pnlBorder: TPanel
      Width = 663
      Height = 452
      inherited pnlTitle: TPanel
        Width = 661
        inherited lblTitle: TLabel
          Width = 236
          Caption = 'Meta info about tables'
        end
        inherited imgAnyDAC: TImage
          Left = 364
        end
        inherited imgGradient: TImage
          Left = 307
        end
        inherited pnlBottom: TPanel
          Width = 661
        end
      end
      inherited pnlMain: TPanel
        Width = 661
        Height = 397
        inherited pnlConnection: TPanel
          Width = 661
          Height = 129
          inherited lblUseConnectionDef: TLabel
            Width = 126
          end
          object btnFetch: TSpeedButton [1]
            Left = 571
            Top = 63
            Width = 76
            Height = 21
            Cursor = crHandPoint
            Caption = 'Fetch'
            Enabled = False
            Flat = True
            OnClick = btnFetchClick
          end
          object Label1: TLabel [2]
            Left = 384
            Top = 66
            Width = 30
            Height = 13
            Alignment = taRightJustify
            Caption = 'Table:'
          end
          inherited cbDB: TComboBox
            TabOrder = 3
          end
          object rgMain: TRadioGroup
            Left = 11
            Top = 53
            Width = 190
            Height = 33
            Cursor = crHandPoint
            Columns = 2
            ItemIndex = 0
            Items.Strings = (
              'mkTables'
              'mkTableFields')
            TabOrder = 0
            OnClick = rgMainClick
          end
          object edtWildCard: TLabeledEdit
            Left = 261
            Top = 63
            Width = 107
            Height = 21
            BevelInner = bvSpace
            BevelKind = bkFlat
            BorderStyle = bsNone
            EditLabel.Width = 46
            EditLabel.Height = 13
            EditLabel.Caption = 'WildCard:'
            LabelPosition = lpLeft
            TabOrder = 1
            Text = '%ustom%'
          end
          object cbTable: TComboBox
            Left = 416
            Top = 63
            Width = 137
            Height = 21
            BevelInner = bvSpace
            BevelKind = bkFlat
            BevelOuter = bvRaised
            Enabled = False
            ItemHeight = 13
            TabOrder = 2
            Items.Strings = (
              'Categories'
              'Customers'
              'Orders'
              'Products')
          end
          object mmInfo: TMemo
            Left = 0
            Top = 96
            Width = 661
            Height = 33
            Align = alBottom
            BevelInner = bvSpace
            BevelKind = bkFlat
            BorderStyle = bsNone
            Color = clInfoBk
            Lines.Strings = (
              
                'To fetch meta information click Fetch button. In the WildCard ed' +
                'it type the required template for selecting info. Use the radio ' +
                'buttons group '
              'to select the kind of meta info fetching.')
            TabOrder = 4
          end
        end
        inherited Console: TMemo
          Top = 129
          Width = 661
          Height = 268
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 460
    Width = 671
    inherited btnClose: TButton
      Left = 592
    end
  end
end
