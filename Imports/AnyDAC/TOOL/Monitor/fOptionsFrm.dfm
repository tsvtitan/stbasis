inherited frmOptions: TfrmOptions
  Left = 257
  Top = 105
  Caption = 'AnyDAC Monitor'
  ClientHeight = 274
  ClientWidth = 368
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlButtons: TADGUIxFormsPanel
    Top = 240
    Width = 368
    inherited btnOk: TButton
      Left = 206
    end
    inherited btnCancel: TButton
      Left = 289
    end
  end
  inherited pnlMain: TADGUIxFormsPanel
    Width = 368
    Height = 240
    inherited pnlGray: TADGUIxFormsPanel
      Width = 360
      Height = 232
      ParentCtl3D = False
      inherited pnlOptions: TADGUIxFormsPanel
        Width = 358
        Height = 207
        object pnlContainer: TADGUIxFormsPanel
          Left = 3
          Top = 3
          Width = 352
          Height = 201
          Align = alClient
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 0
          object tcPages: TADGUIxFormsTabControl
            Left = 0
            Top = 0
            Width = 352
            Height = 29
            Colors.InactiveTabBG = clWindow
            OnChange = tcPagesChange
            Position = tpTop
            TabIndex = 0
            Tabs.Strings = (
              'Categories'
              'Buffer'
              'Listening')
            Align = alTop
          end
          object pnlData: TADGUIxFormsPanel
            Left = 0
            Top = 29
            Width = 352
            Height = 171
            Align = alClient
            BevelOuter = bvNone
            ParentColor = True
            TabOrder = 1
            object pnlCategories: TADGUIxFormsPanel
              Left = 0
              Top = 0
              Width = 352
              Height = 171
              Align = alClient
              BevelOuter = bvNone
              ParentColor = True
              TabOrder = 0
              DesignSize = (
                352
                171)
              object clbCategories: TCheckListBox
                Left = 11
                Top = 11
                Width = 330
                Height = 149
                Anchors = [akLeft, akTop, akRight, akBottom]
                BevelInner = bvSpace
                BevelKind = bkFlat
                BorderStyle = bsNone
                ItemHeight = 13
                Items.Strings = (
                  'Live cycle'
                  'Errors'
                  'Connection connect / disconnect'
                  'Connection transact'
                  'Connection other'
                  'Command prepare / unprepare'
                  'Command execute / open'
                  'Command data input'
                  'Command data output'
                  'Adapter update'
                  'Vendor calls')
                ParentColor = True
                TabOrder = 0
              end
            end
            object pnlListening: TADGUIxFormsPanel
              Left = 0
              Top = 0
              Width = 352
              Height = 171
              Align = alClient
              BevelOuter = bvNone
              ParentColor = True
              TabOrder = 2
              Visible = False
              object lblPort: TLabel
                Left = 11
                Top = 14
                Width = 24
                Height = 13
                Caption = '&Port:'
                FocusControl = edtPort
              end
              object edtPort: TEdit
                Left = 38
                Top = 11
                Width = 59
                Height = 21
                BevelInner = bvSpace
                BevelKind = bkFlat
                BorderStyle = bsNone
                ParentColor = True
                TabOrder = 0
              end
            end
            object pnlBuffer: TADGUIxFormsPanel
              Left = 0
              Top = 0
              Width = 352
              Height = 171
              Align = alClient
              BevelOuter = bvNone
              ParentColor = True
              TabOrder = 1
              Visible = False
              object Label1: TLabel
                Left = 11
                Top = 14
                Width = 63
                Height = 13
                Caption = '&Buffer mode:'
                FocusControl = cbxBufferMode
              end
              object lblCount: TLabel
                Left = 11
                Top = 42
                Width = 33
                Height = 13
                Caption = '&Count:'
                FocusControl = edtCount
              end
              object lblMemory: TLabel
                Left = 11
                Top = 69
                Width = 42
                Height = 13
                Caption = '&Memory:'
                FocusControl = edtMemory
              end
              object btnPageFile: TSpeedButton
                Left = 319
                Top = 94
                Width = 23
                Height = 20
                Caption = '...'
                Flat = True
                OnClick = btnPageFileClick
              end
              object lblPageFile: TLabel
                Left = 11
                Top = 96
                Width = 64
                Height = 13
                Caption = '&Page out file:'
                FocusControl = edtPageFile
              end
              object cbxBufferMode: TComboBox
                Left = 77
                Top = 11
                Width = 240
                Height = 21
                BevelInner = bvSpace
                BevelKind = bkFlat
                Style = csDropDownList
                Ctl3D = True
                ItemHeight = 13
                ParentColor = True
                ParentCtl3D = False
                TabOrder = 0
                OnChange = cbxBufferModeChange
                Items.Strings = (
                  'Limit by count, overwrite'
                  'Limit by count, page out'
                  'Limit by memory, overwrite'
                  'Limit by memory, page out')
              end
              object edtCount: TEdit
                Left = 77
                Top = 39
                Width = 121
                Height = 21
                BevelInner = bvSpace
                BevelKind = bkFlat
                BorderStyle = bsNone
                ParentColor = True
                TabOrder = 1
              end
              object edtMemory: TEdit
                Left = 77
                Top = 66
                Width = 121
                Height = 21
                BevelInner = bvSpace
                BevelKind = bkFlat
                BorderStyle = bsNone
                ParentColor = True
                TabOrder = 2
              end
              object edtPageFile: TEdit
                Left = 77
                Top = 93
                Width = 241
                Height = 21
                BevelInner = bvSpace
                BevelKind = bkFlat
                BorderStyle = bsNone
                ParentColor = True
                TabOrder = 3
              end
            end
          end
          object pnlBottomSep: TADGUIxFormsPanel
            Left = 0
            Top = 200
            Width = 352
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
            Height = 172
            Align = alCustom
            Anchors = [akLeft, akTop, akBottom]
            BevelOuter = bvNone
            Color = clBtnShadow
            TabOrder = 3
          end
          object pnlRightSep: TADGUIxFormsPanel
            Left = 351
            Top = 28
            Width = 1
            Height = 172
            Align = alCustom
            Anchors = [akTop, akRight, akBottom]
            BevelOuter = bvNone
            Color = clBtnShadow
            TabOrder = 4
          end
        end
      end
      inherited pnlTitle: TADGUIxFormsPanel
        Width = 358
        inherited lblTitle: TLabel
          Width = 78
          Caption = 'Trace Options'
        end
        inherited pnlTitleBottomLine: TADGUIxFormsPanel
          Width = 358
        end
      end
    end
  end
  object SaveDialog1: TSaveDialog
    Left = 335
    Top = 4
  end
end
