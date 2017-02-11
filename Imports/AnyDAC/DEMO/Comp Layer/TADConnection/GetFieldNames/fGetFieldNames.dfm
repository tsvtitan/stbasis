inherited frmGetFieldNames: TfrmGetFieldNames
  Left = 320
  Top = 156
  Width = 561
  Height = 519
  Caption = 'GetFieldName and GetTableNames'
  Font.Name = 'MS Sans Serif'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    Width = 553
    Height = 435
    inherited pnlBorder: TPanel
      Width = 545
      Height = 427
      inherited pnlTitle: TPanel
        Width = 543
        inherited lblTitle: TLabel
          Width = 170
          Caption = 'Get Field Names'
        end
        inherited imgAnyDAC: TImage
          Left = 246
        end
        inherited imgGradient: TImage
          Left = 189
        end
        inherited pnlBottom: TPanel
          Width = 543
        end
      end
      inherited pnlMain: TPanel
        Width = 543
        Height = 372
        object Label1: TLabel [0]
          Left = 96
          Top = 40
          Width = 32
          Height = 13
          Alignment = taCenter
          Caption = 'Tables'
        end
        object Label2: TLabel [1]
          Left = 300
          Top = 40
          Width = 27
          Height = 13
          Alignment = taRightJustify
          Caption = 'Fields'
        end
        object Label3: TLabel [2]
          Left = 197
          Top = 298
          Width = 48
          Height = 13
          Alignment = taRightJustify
          Caption = 'Key Fields'
        end
        object Splitter2: TSplitter [3]
          Left = 0
          Top = 279
          Width = 543
          Height = 3
          Cursor = crVSplit
          Align = alBottom
        end
        inherited pnlConnection: TPanel
          Width = 543
          TabOrder = 2
          inherited lblUseConnectionDef: TLabel
            Width = 126
          end
        end
        object Panel2: TPanel
          Left = 0
          Top = 57
          Width = 543
          Height = 222
          Align = alClient
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 1
          object Splitter1: TSplitter
            Left = 257
            Top = 0
            Height = 222
          end
          object lbxTables: TListBox
            Left = 0
            Top = 0
            Width = 257
            Height = 222
            Align = alLeft
            BevelInner = bvSpace
            BevelKind = bkFlat
            BorderStyle = bsNone
            ItemHeight = 13
            Items.Strings = (
              '')
            Sorted = True
            TabOrder = 1
            OnClick = lbxTablesClick
          end
          object lbxFields: TListBox
            Left = 260
            Top = 0
            Width = 283
            Height = 222
            Align = alClient
            BevelInner = bvSpace
            BevelKind = bkFlat
            BorderStyle = bsNone
            ItemHeight = 13
            Items.Strings = (
              '')
            TabOrder = 0
          end
        end
        object lbxKeyFields: TListBox
          Left = 0
          Top = 282
          Width = 543
          Height = 90
          Align = alBottom
          BevelInner = bvSpace
          BevelKind = bkFlat
          BorderStyle = bsNone
          ItemHeight = 13
          TabOrder = 0
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 435
    Width = 553
    inherited btnClose: TButton
      Left = 474
    end
  end
  inherited StatusBar1: TStatusBar
    Top = 466
    Width = 553
  end
end
