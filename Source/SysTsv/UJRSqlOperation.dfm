inherited fmJRSqlOperation: TfmJRSqlOperation
  Left = 209
  Top = 154
  Width = 549
  Caption = 'Журнал SQL операций'
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000EE00000EE0000000EE00000EE0000000FE00000FE0000000000
    BBBB007BBBB0000BB0BBBBB0BB000000B0BBBBBB0B00000B00BBBBBBB000000B
    BBBBB0BBBBB0000B000B000B0000000BBB0B0B0B0BB0000BB0BB0B0B0BB0000B
    0BBB0B0B0BB0000B000B000B0BB0000BBBBBBBBBBBB000000000000000009F3F
    00000E1F00000E1F00000000000080000000C0000000C0000000C0000000C000
    0000C0000000C0000000C0000000C0000000C0000000C0000000C0000000}
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnMain: TPanel
    Width = 541
    inherited pnBut: TPanel
      Left = 452
      inherited pnModal: TPanel
        inherited bibRefresh: TBitBtn
          OnClick = bibRefreshClick
        end
        inherited bibClear: TBitBtn
          OnClick = bibClearClick
        end
      end
    end
    inherited pnGrid: TPanel
      Width = 452
      object spl: TSplitter
        Left = 0
        Top = 161
        Width = 452
        Height = 3
        Cursor = crSizeNS
        Hint = 'Растянуть'
        Align = alBottom
      end
      object pnHint: TPanel
        Left = 0
        Top = 164
        Width = 452
        Height = 80
        Align = alBottom
        BevelOuter = bvNone
        BorderWidth = 5
        Constraints.MinHeight = 80
        TabOrder = 0
        object grbHint: TGroupBox
          Left = 5
          Top = 5
          Width = 442
          Height = 70
          Align = alClient
          Caption = ' Описание '
          TabOrder = 0
          object pngrbHint: TPanel
            Left = 2
            Top = 15
            Width = 438
            Height = 53
            Align = alClient
            BevelOuter = bvNone
            BorderWidth = 5
            TabOrder = 0
            object dbmeHint: TDBMemo
              Left = 5
              Top = 5
              Width = 428
              Height = 43
              Align = alClient
              Color = clBtnFace
              DataSource = ds
              ReadOnly = True
              TabOrder = 0
            end
          end
        end
      end
    end
  end
  inherited pnFind: TPanel
    Width = 541
    inherited edSearch: TEdit
      Width = 400
    end
  end
  inherited pnBottom: TPanel
    Width = 541
    inherited bibOk: TBitBtn
      Left = 378
    end
    inherited bibClose: TBitBtn
      Left = 460
    end
  end
end
