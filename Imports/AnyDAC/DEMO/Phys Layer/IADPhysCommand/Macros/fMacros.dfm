inherited frmMacros: TfrmMacros
  Left = 383
  Top = 252
  Width = 599
  Height = 574
  Caption = 'Macros and Params'
  Font.Name = 'MS Sans Serif'
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    Width = 591
    Height = 509
    inherited pnlBorder: TPanel
      Width = 583
      Height = 501
      inherited pnlTitle: TPanel
        Width = 581
        inherited lblTitle: TLabel
          Width = 207
          Caption = 'Macros and Params'
        end
        inherited imgAnyDAC: TImage
          Left = 284
        end
        inherited imgGradient: TImage
          Left = 227
        end
        inherited pnlBottom: TPanel
          Width = 581
        end
      end
      inherited pnlMain: TPanel
        Width = 581
        Height = 446
        inherited pnlConnection: TPanel
          Width = 581
          Height = 225
          inherited lblUseConnectionDef: TLabel
            Width = 126
          end
          object btnFetch: TSpeedButton [1]
            Left = 172
            Top = 24
            Width = 76
            Height = 21
            Caption = 'Fetch'
            Enabled = False
            Flat = True
            OnClick = btnFetchClick
          end
          object lblDataType: TLabel [2]
            Left = 4
            Top = 175
            Width = 50
            Height = 13
            Alignment = taRightJustify
            Caption = 'DataType:'
          end
          inherited cbDB: TComboBox
            TabOrder = 4
          end
          object mmComment: TMemo
            Left = 282
            Top = 51
            Width = 300
            Height = 114
            BevelInner = bvSpace
            BevelKind = bkFlat
            BorderStyle = bsNone
            Color = clInfoBk
            Lines.Strings = (
              'By using this feature of IADPhysCommand, you can easy '
              'modify your SQL query. First, you create a template of '
              'query, and then substitute into it the needed values. For '
              'example, you can change values of macros in this form: try '
              'change '#39'Address'#39' to '#39'FirstName'#39' and click '#39'Fetch'#39'. Also you '
              'can change DataType of macros'#39's value and MacroType. ')
            ReadOnly = True
            TabOrder = 3
          end
          object lstMacros: TValueListEditor
            Left = 0
            Top = 51
            Width = 277
            Height = 114
            BorderStyle = bsNone
            DisplayOptions = [doColumnTitles, doKeyColFixed]
            Enabled = False
            ScrollBars = ssNone
            Strings.Strings = (
              'Column='
              'Tab='
              'Id='
              'Sign='
              'IdValue=')
            TabOrder = 0
            TitleCaptions.Strings = (
              'Macros'
              'Value')
            OnSelectCell = lstMacrosSelectCell
            OnSetEditText = lstMacrosSetEditText
            ColWidths = (
              62
              214)
          end
          object mmSQL: TMemo
            Left = 0
            Top = 208
            Width = 581
            Height = 17
            Align = alBottom
            BevelInner = bvSpace
            BevelKind = bkFlat
            BorderStyle = bsNone
            Color = clInfoBk
            Lines.Strings = (
              '')
            ReadOnly = True
            TabOrder = 1
          end
          object cbDataType: TComboBox
            Left = 62
            Top = 172
            Width = 137
            Height = 21
            BevelInner = bvSpace
            BevelKind = bkFlat
            BevelOuter = bvRaised
            Style = csDropDownList
            Enabled = False
            ItemHeight = 13
            TabOrder = 2
            OnChange = cbDataTypeChange
            Items.Strings = (
              'mdUnknown'
              'mdString'
              'mdIdentifier'
              'mdInteger'
              'mdBoolean'
              'mdFloat'
              'mdDate'
              'mdTime'
              'mdDateTime'
              'mdRaw')
          end
        end
        inherited Console: TMemo
          Top = 225
          Width = 581
          Height = 221
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 509
    Width = 591
    inherited btnClose: TButton
      Left = 512
    end
  end
end
