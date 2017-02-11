inherited frmMetaStoredProc: TfrmMetaStoredProc
  Left = 310
  Top = 204
  Width = 787
  Height = 533
  Caption = 'Meta info about packages, stored procs'
  Font.Name = 'MS Sans Serif'
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    Width = 779
    Height = 468
    inherited pnlBorder: TPanel
      Width = 771
      Height = 460
      inherited pnlTitle: TPanel
        Width = 769
        inherited lblTitle: TLabel
          Width = 392
          Caption = 'Meta info about package, stored proc'
        end
        inherited imgAnyDAC: TImage
          Left = 472
        end
        inherited imgGradient: TImage
          Left = 415
        end
        inherited pnlBottom: TPanel
          Width = 769
        end
      end
      inherited pnlMain: TPanel
        Width = 769
        Height = 405
        inherited pnlConnection: TPanel
          Width = 769
          Height = 151
          inherited lblUseConnectionDef: TLabel
            Width = 126
          end
          object btnFetch: TSpeedButton [1]
            Left = 11
            Top = 90
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
            Top = 48
            Width = 270
            Height = 33
            Cursor = crHandPoint
            Columns = 3
            ItemIndex = 0
            Items.Strings = (
              'mkPackages'
              'mkProcs'
              'mkProcArgs')
            TabOrder = 0
            OnClick = rgMainClick
          end
          object edtWildCard: TLabeledEdit
            Left = 336
            Top = 88
            Width = 121
            Height = 21
            BevelInner = bvSpace
            BevelKind = bkFlat
            BorderStyle = bsNone
            EditLabel.Width = 46
            EditLabel.Height = 13
            EditLabel.Caption = 'WildCard:'
            LabelPosition = lpLeft
            LabelSpacing = 3
            TabOrder = 1
          end
          object edtProcName: TLabeledEdit
            Left = 508
            Top = 56
            Width = 121
            Height = 21
            BevelInner = bvSpace
            BevelKind = bkFlat
            BorderStyle = bsNone
            EditLabel.Width = 25
            EditLabel.Height = 13
            EditLabel.Caption = 'Proc:'
            Enabled = False
            LabelPosition = lpLeft
            LabelSpacing = 3
            TabOrder = 2
          end
          object edtPackage: TLabeledEdit
            Left = 336
            Top = 56
            Width = 121
            Height = 21
            BevelInner = bvSpace
            BevelKind = bkFlat
            BorderStyle = bsNone
            EditLabel.Width = 46
            EditLabel.Height = 13
            EditLabel.Caption = 'Package:'
            LabelPosition = lpLeft
            LabelSpacing = 3
            TabOrder = 3
          end
          object mmInfo: TMemo
            Left = 0
            Top = 118
            Width = 769
            Height = 33
            Align = alBottom
            BevelInner = bvSpace
            BevelKind = bkFlat
            BorderStyle = bsNone
            Color = clInfoBk
            Lines.Strings = (
              
                'To fetch meta information click Fetch button. In the WildCard ed' +
                'it type the required template for selecting info. Use the radio ' +
                'buttons group to select the kind of '
              'meta info fetching.')
            TabOrder = 5
          end
        end
        inherited Console: TMemo
          Top = 151
          Width = 769
          Height = 254
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 468
    Width = 779
    inherited btnClose: TButton
      Left = 699
      Width = 76
    end
  end
end
