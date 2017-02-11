inherited frmMetaIndices: TfrmMetaIndices
  Left = 361
  Top = 307
  Width = 632
  Height = 531
  Caption = 'Meta info about indices'
  Font.Name = 'MS Sans Serif'
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    Width = 624
    Height = 473
    inherited pnlBorder: TPanel
      Width = 616
      Height = 465
      inherited pnlTitle: TPanel
        Width = 614
        inherited lblTitle: TLabel
          Width = 244
          Caption = 'Meta info about indices'
        end
        inherited imgAnyDAC: TImage
          Left = 317
        end
        inherited imgGradient: TImage
          Left = 260
        end
        inherited pnlBottom: TPanel
          Width = 614
        end
      end
      inherited pnlMain: TPanel
        Width = 614
        Height = 410
        inherited pnlConnection: TPanel
          Width = 614
          Height = 157
          inherited lblUseConnectionDef: TLabel
            Width = 126
          end
          object btnFetch: TSpeedButton [1]
            Left = 11
            Top = 89
            Width = 76
            Height = 21
            Cursor = crHandPoint
            Caption = 'Fetch'
            Enabled = False
            Flat = True
            OnClick = btnFetchClick
          end
          inherited cbDB: TComboBox
            TabOrder = 4
          end
          object rgMain: TRadioGroup
            Left = 11
            Top = 49
            Width = 190
            Height = 33
            Cursor = crHandPoint
            Columns = 2
            ItemIndex = 0
            Items.Strings = (
              'mkIndexes'
              'mkIndexFields')
            TabOrder = 0
            OnClick = rgMainClick
          end
          object edtWildCard: TLabeledEdit
            Left = 257
            Top = 89
            Width = 121
            Height = 21
            BevelInner = bvSpace
            BevelKind = bkFlat
            BorderStyle = bsNone
            EditLabel.Width = 46
            EditLabel.Height = 13
            EditLabel.Caption = 'WildCard:'
            LabelPosition = lpLeft
            TabOrder = 1
          end
          object edtIndexName: TLabeledEdit
            Left = 419
            Top = 56
            Width = 121
            Height = 21
            BevelInner = bvSpace
            BevelKind = bkFlat
            BorderStyle = bsNone
            EditLabel.Width = 29
            EditLabel.Height = 13
            EditLabel.Caption = 'Index:'
            Enabled = False
            LabelPosition = lpLeft
            TabOrder = 2
            Text = '[]'
          end
          object edtTableName: TLabeledEdit
            Left = 257
            Top = 57
            Width = 121
            Height = 21
            BevelInner = bvSpace
            BevelKind = bkFlat
            BorderStyle = bsNone
            EditLabel.Width = 30
            EditLabel.Height = 13
            EditLabel.Caption = 'Table:'
            LabelPosition = lpLeft
            TabOrder = 3
            Text = '[Customers]'
          end
          object mmInfo: TMemo
            Left = 0
            Top = 118
            Width = 614
            Height = 39
            Align = alBottom
            BevelInner = bvSpace
            BevelKind = bkFlat
            BorderStyle = bsNone
            Color = clInfoBk
            Lines.Strings = (
              
                'To fetch meta information click Fetch button. In the WildCard ed' +
                'it type the required template for selecting info. Use the radio '
              'buttons group to select the kind of meta info fetching.')
            TabOrder = 5
          end
        end
        inherited Console: TMemo
          Top = 157
          Width = 614
          Height = 253
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 473
    Width = 624
    inherited btnClose: TButton
      Left = 545
    end
  end
end
