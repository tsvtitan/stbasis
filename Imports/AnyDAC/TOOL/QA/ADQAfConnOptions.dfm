inherited frmConnOptions: TfrmConnOptions
  Left = 467
  Top = 282
  Caption = 'Connection Definition Selector'
  ClientHeight = 251
  ClientWidth = 275
  OldCreateOrder = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlButtons: TADGUIxFormsPanel
    Top = 217
    Width = 275
    inherited btnOk: TButton
      Left = 113
    end
    inherited btnCancel: TButton
      Left = 196
    end
  end
  inherited pnlMain: TADGUIxFormsPanel
    Width = 275
    Height = 217
    inherited pnlGray: TADGUIxFormsPanel
      Width = 267
      Height = 209
      inherited pnlOptions: TADGUIxFormsPanel
        Width = 265
        Height = 184
        object Label3: TLabel
          Left = 11
          Top = 15
          Width = 35
          Height = 13
          Alignment = taRightJustify
          Caption = '&Oracle:'
          FocusControl = cbOracle
        end
        object Label1: TLabel
          Left = 11
          Top = 43
          Width = 37
          Height = 13
          Alignment = taRightJustify
          Caption = '&MSSQL:'
          FocusControl = cbMSSQL
        end
        object Label2: TLabel
          Left = 11
          Top = 71
          Width = 54
          Height = 13
          Alignment = taRightJustify
          Caption = 'M&S Access:'
          FocusControl = cbMSAccess
        end
        object Label4: TLabel
          Left = 11
          Top = 99
          Width = 37
          Height = 13
          Alignment = taRightJustify
          Caption = 'M&ySQL:'
          FocusControl = cbMySQL
        end
        object Label5: TLabel
          Left = 11
          Top = 127
          Width = 23
          Height = 13
          Alignment = taRightJustify
          Caption = '&DB2:'
          FocusControl = cbDB2
        end
        object Label6: TLabel
          Left = 11
          Top = 156
          Width = 24
          Height = 13
          Alignment = taRightJustify
          Caption = '&ASA:'
          FocusControl = cbASA
        end
        object cbOracle: TComboBox
          Left = 72
          Top = 11
          Width = 184
          Height = 21
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          ItemHeight = 13
          TabOrder = 0
        end
        object cbMSAccess: TComboBox
          Left = 72
          Top = 67
          Width = 184
          Height = 21
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          ItemHeight = 13
          TabOrder = 1
        end
        object cbMySQL: TComboBox
          Left = 72
          Top = 95
          Width = 184
          Height = 21
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          ItemHeight = 13
          TabOrder = 2
        end
        object cbMSSQL: TComboBox
          Left = 72
          Top = 39
          Width = 184
          Height = 21
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          ItemHeight = 13
          TabOrder = 3
        end
        object cbDB2: TComboBox
          Left = 72
          Top = 123
          Width = 184
          Height = 21
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          ItemHeight = 13
          TabOrder = 4
        end
        object cbASA: TComboBox
          Left = 72
          Top = 151
          Width = 184
          Height = 21
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          ItemHeight = 13
          TabOrder = 5
        end
      end
      inherited pnlTitle: TADGUIxFormsPanel
        Width = 265
        inherited lblTitle: TLabel
          Width = 126
          Caption = 'Connection Definitions'
        end
        inherited pnlTitleBottomLine: TADGUIxFormsPanel
          Width = 265
        end
      end
    end
  end
end
