inherited frmClients: TfrmClients
  Left = 312
  Top = 173
  Width = 617
  Height = 561
  Caption = 'Monitor clients'
  Font.Name = 'MS Sans Serif'
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    Width = 609
    Height = 496
    inherited pnlBorder: TPanel
      Width = 601
      Height = 488
      inherited pnlTitle: TPanel
        Width = 599
        inherited lblTitle: TLabel
          Width = 156
          Caption = 'Monitor clients'
        end
        inherited imgAnyDAC: TImage
          Left = 299
        end
        inherited imgGradient: TImage
          Left = 242
        end
        inherited pnlBottom: TPanel
          Width = 599
        end
      end
      inherited pnlMain: TPanel
        Width = 599
        Height = 433
        inherited pnlConnection: TPanel
          Width = 599
          inherited lblUseConnectionDef: TLabel
            Width = 126
          end
          object rgClients: TRadioGroup
            Left = 192
            Top = 15
            Width = 289
            Height = 33
            Caption = 'Monitor client'
            Columns = 3
            ItemIndex = 0
            Items.Strings = (
              'No monitoring'
              'Remote'
              'Flat file')
            TabOrder = 1
          end
        end
        inherited Console: TMemo
          Top = 101
          Width = 599
          Height = 332
        end
        object Panel1: TPanel
          Left = 0
          Top = 83
          Width = 599
          Height = 18
          Align = alTop
          Alignment = taLeftJustify
          BevelOuter = bvNone
          Caption = '  Flat file records'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentColor = True
          ParentFont = False
          TabOrder = 2
        end
        object Panel2: TPanel
          Left = 0
          Top = 57
          Width = 599
          Height = 26
          Align = alTop
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 3
          object mmInfo: TMemo
            Left = 0
            Top = 0
            Width = 599
            Height = 26
            Align = alClient
            BevelInner = bvSpace
            BevelKind = bkFlat
            BorderStyle = bsNone
            Color = clInfoBk
            Lines.Strings = (
              'If you wish see the Mony Indy client work run ADMonitor tool')
            ReadOnly = True
            TabOrder = 0
          end
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 496
    Width = 609
    inherited btnClose: TButton
      Left = 530
    end
  end
end
