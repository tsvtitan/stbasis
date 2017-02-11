inherited frmOptions: TfrmOptions
  Left = 473
  Top = 263
  Caption = 'AnyDAC Explorer Options'
  ClientHeight = 216
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlButtons: TADGUIxFormsPanel
    Top = 182
  end
  inherited pnlMain: TADGUIxFormsPanel
    Height = 182
    inherited pnlGray: TADGUIxFormsPanel
      Height = 174
      inherited pnlOptions: TADGUIxFormsPanel
        Height = 149
        object pnlContainer: TADGUIxFormsPanel
          Left = 3
          Top = 3
          Width = 339
          Height = 143
          Align = alClient
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 0
          object tcPages: TADGUIxFormsTabControl
            Left = 0
            Top = 0
            Width = 339
            Height = 29
            Colors.InactiveTabBG = clWindow
            OnChange = tcPagesChange
            Position = tpTop
            TabIndex = 0
            Tabs.Strings = (
              'General'
              'BDE compatibility defaults')
            Align = alTop
          end
          object pnlData: TADGUIxFormsPanel
            Left = 0
            Top = 29
            Width = 339
            Height = 113
            Align = alClient
            BevelOuter = bvNone
            ParentColor = True
            TabOrder = 1
            object pnlBDEDefaults: TADGUIxFormsPanel
              Left = 0
              Top = 0
              Width = 339
              Height = 113
              Align = alClient
              BevelOuter = bvNone
              ParentColor = True
              TabOrder = 1
              Visible = False
              object cbEnableBCD: TCheckBox
                Left = 11
                Top = 11
                Width = 97
                Height = 17
                Caption = 'Enable &BCD'
                TabOrder = 0
              end
              object cbEnableIntegers: TCheckBox
                Left = 11
                Top = 35
                Width = 97
                Height = 17
                Caption = 'Enable &Integers'
                TabOrder = 1
              end
              object cbOverwriteConnDef: TCheckBox
                Left = 11
                Top = 59
                Width = 185
                Height = 17
                Caption = 'Overwrite Connection Definitions'
                TabOrder = 2
              end
            end
            object pnlGeneral: TADGUIxFormsPanel
              Left = 0
              Top = 0
              Width = 339
              Height = 113
              Align = alClient
              BevelOuter = bvNone
              ParentColor = True
              TabOrder = 0
              object Label1: TLabel
                Left = 11
                Top = 14
                Width = 110
                Height = 13
                Caption = '&Prefered explore type:'
                FocusControl = cbxHierarchy
              end
              object cbxHierarchy: TComboBox
                Left = 124
                Top = 11
                Width = 206
                Height = 21
                Hint = 'Allows to choose representation of object tree'
                Style = csDropDownList
                Ctl3D = True
                ItemHeight = 13
                ParentCtl3D = False
                TabOrder = 0
                Text = 'all objects grouped by users'
                Items.Strings = (
                  'all objects grouped by users'
                  'all objects grouped by object types')
              end
              object cbConfirmations: TCheckBox
                Left = 11
                Top = 38
                Width = 153
                Height = 17
                Hint = 
                  'Turns of / off confirmation of some (delete, cancel, etc) AnyDAC' +
                  ' Explorer operations'
                Caption = '&Confirm critical operations'
                TabOrder = 1
              end
              object cbTracing: TCheckBox
                Left = 11
                Top = 62
                Width = 201
                Height = 17
                Hint = 'Turns on / off debug monitor output'
                Caption = 'Produce debug &monitor output'
                TabOrder = 2
              end
              object cbDblclickMemo: TCheckBox
                Left = 11
                Top = 86
                Width = 201
                Height = 17
                Hint = 'Popup blob viewer on double click or through popup menu'
                Caption = '&Popup blob viewer on double click'
                TabOrder = 3
              end
            end
          end
          object pnlBottomSep: TADGUIxFormsPanel
            Left = 0
            Top = 142
            Width = 339
            Height = 1
            Align = alBottom
            BevelOuter = bvNone
            Color = clBtnShadow
            TabOrder = 2
          end
          object pnlLeftSep: TADGUIxFormsPanel
            Left = 0
            Top = 28
            Width = 1
            Height = 114
            Anchors = [akLeft, akTop, akBottom]
            BevelOuter = bvNone
            Color = clBtnShadow
            TabOrder = 3
          end
          object pnlRightSep: TADGUIxFormsPanel
            Left = 338
            Top = 28
            Width = 1
            Height = 114
            Anchors = [akTop, akRight, akBottom]
            BevelOuter = bvNone
            Color = clBtnShadow
            TabOrder = 4
          end
        end
      end
      inherited pnlTitle: TADGUIxFormsPanel
        inherited lblTitle: TLabel
          Width = 162
          Caption = 'Set AnyDAC Explorer options'
        end
      end
    end
  end
end
