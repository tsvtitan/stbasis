inherited Form1: TForm1
  Left = 358
  Top = 193
  Width = 531
  Height = 443
  Caption = 'Login Demo - Disconnect'
  Font.Name = 'MS Sans Serif'
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    Width = 523
    Height = 359
    inherited pnlBorder: TPanel
      Width = 515
      Height = 351
      inherited pnlTitle: TPanel
        Width = 513
        inherited lblTitle: TLabel
          Width = 124
          Caption = 'Login Demo'
        end
        inherited imgAnyDAC: TImage
          Left = 216
        end
        inherited imgGradient: TImage
          Left = 159
        end
        inherited pnlBottom: TPanel
          Width = 513
        end
      end
      inherited pnlMain: TPanel
        Width = 513
        Height = 296
        object btnConnect: TSpeedButton [0]
          Left = 12
          Top = 64
          Width = 76
          Height = 21
          Caption = 'Connect'
          Flat = True
          OnClick = btnConnectClick
        end
        object btnDisconnect: TSpeedButton [1]
          Left = 113
          Top = 64
          Width = 76
          Height = 21
          Caption = 'Disconnect'
          Flat = True
          OnClick = btnDisconnectClick
        end
        object Label3: TLabel [2]
          Left = 11
          Top = 96
          Width = 151
          Height = 13
          Alignment = taRightJustify
          Caption = 'AnyDAC Login Dialog properties'
        end
        object Bevel1: TBevel [3]
          Left = 166
          Top = 103
          Width = 339
          Height = 9
          Shape = bsTopLine
        end
        object Label1: TLabel [4]
          Left = 11
          Top = 168
          Width = 55
          Height = 13
          Alignment = taRightJustify
          Caption = 'VisibleItems'
        end
        inherited pnlConnection: TPanel
          Width = 513
          TabOrder = 8
          inherited lblUseConnectionDef: TLabel
            Width = 126
          end
        end
        object chLoginPrompt: TCheckBox
          Left = 208
          Top = 66
          Width = 97
          Height = 17
          BiDiMode = bdLeftToRight
          Caption = 'Login prompt'
          Checked = True
          Ctl3D = True
          ParentBiDiMode = False
          ParentCtl3D = False
          State = cbChecked
          TabOrder = 0
        end
        object chChangePassword: TCheckBox
          Left = 11
          Top = 120
          Width = 145
          Height = 17
          Caption = 'ChangeExpiredPassword'
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
        object chHistory: TCheckBox
          Left = 11
          Top = 144
          Width = 97
          Height = 17
          Caption = 'HistoryEnabled'
          Checked = True
          State = cbChecked
          TabOrder = 2
        end
        object edLoginRetries: TLabeledEdit
          Left = 273
          Top = 117
          Width = 32
          Height = 21
          BevelInner = bvSpace
          BevelKind = bkFlat
          BorderStyle = bsNone
          EditLabel.Width = 62
          EditLabel.Height = 13
          EditLabel.Caption = 'LoginRetries:'
          LabelPosition = lpLeft
          TabOrder = 3
          Text = '3'
        end
        object udLoginRetries: TUpDown
          Left = 305
          Top = 117
          Width = 16
          Height = 21
          Associate = edLoginRetries
          Max = 10
          Position = 3
          TabOrder = 4
        end
        object mmVisibleItems: TMemo
          Left = 11
          Top = 184
          Width = 189
          Height = 90
          BevelInner = bvSpace
          BevelKind = bkFlat
          BorderStyle = bsNone
          Lines.Strings = (
            'Database'
            'User_Name')
          TabOrder = 5
        end
        object chHistoryWithPassword: TCheckBox
          Left = 208
          Top = 144
          Width = 129
          Height = 17
          Caption = 'HistoryWithPassword'
          Checked = True
          State = cbChecked
          TabOrder = 6
        end
        object Memo1: TMemo
          Left = 208
          Top = 184
          Width = 294
          Height = 89
          BevelInner = bvSpace
          BevelKind = bkFlat
          BorderStyle = bsNone
          Color = clInfoBk
          Lines.Strings = (
            'VisibleItems is a list of Connection Definitions param names, '
            
              'which will be allowed to enter in Login Dialog. If list is empty' +
              ', '
            'then all appropriate for end user params will be accesible.')
          TabOrder = 7
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 359
    Width = 523
    inherited btnClose: TButton
      Left = 444
    end
  end
  inherited StatusBar1: TStatusBar
    Top = 390
    Width = 523
  end
end
