inherited frmAsync: TfrmAsync
  Left = 359
  Top = 214
  Height = 440
  Caption = 'Async Execute'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    Height = 375
    inherited pnlBorder: TPanel
      Height = 367
      inherited pnlTitle: TPanel
        inherited lblTitle: TLabel
          Width = 142
          Caption = 'Async Command Execution'
        end
      end
      inherited pnlMain: TPanel
        Height = 312
        inherited pnlConnection: TPanel
          Height = 101
          object Label1: TLabel [1]
            Left = 376
            Top = 48
            Width = 38
            Height = 13
            Caption = 'Timeout'
          end
          object btnExecute: TSpeedButton [2]
            Left = 172
            Top = 24
            Width = 76
            Height = 21
            Caption = 'Execute'
            Enabled = False
            Flat = True
            OnClick = btnExecuteClick
          end
          object rgMode: TRadioGroup
            Left = 11
            Top = 52
            Width = 345
            Height = 39
            Caption = 'Async execution mode'
            Columns = 4
            ItemIndex = 2
            Items.Strings = (
              'Blocking'
              'Non blocking'
              'Cancel dialog'
              'Async')
            TabOrder = 1
          end
          object edtTimeout: TEdit
            Left = 376
            Top = 64
            Width = 121
            Height = 21
            TabOrder = 2
            Text = '$FFFFFFFF'
          end
        end
        inherited Console: TMemo
          Top = 101
          Height = 211
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 375
  end
end
