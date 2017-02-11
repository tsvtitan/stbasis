inherited frmMainQueryBase: TfrmMainQueryBase
  Left = 307
  Top = 55
  Height = 645
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    Height = 561
    inherited pnlBorder: TPanel
      Height = 553
      inherited pnlMain: TPanel
        Height = 498
        inherited pnlConnection: TPanel
          Height = 59
          inherited cbDB: TComboBox
            Top = 27
          end
        end
        object pnlSubPageControl: TPanel
          Left = 0
          Top = 59
          Width = 618
          Height = 439
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          object pcMain: TADGUIxFormsPageControl
            Left = 0
            Top = 1
            Width = 618
            Height = 438
            ActivePage = tsOptions
            Align = alClient
            Style = tsFlatButtons
            TabIndex = 1
            TabOrder = 0
            OnChanging = pcMainChanging
            object tsData: TTabSheet
              Caption = 'Data'
            end
            object tsOptions: TTabSheet
              Caption = 'Options'
              ImageIndex = 1
              object ADGUIxFormsPanelTree1: TADGUIxFormsPanelTree
                Left = 0
                Top = 41
                Width = 610
                Height = 325
                HorzScrollBar.Smooth = True
                HorzScrollBar.Style = ssFlat
                HorzScrollBar.Tracking = True
                VertScrollBar.Smooth = True
                VertScrollBar.Style = ssFlat
                VertScrollBar.Tracking = True
                Align = alClient
                TabOrder = 1
                object frmUpdateOptions: TfrmADGUIxFormsUpdateOptions
                  Left = 0
                  Top = 0
                  Width = 606
                  Height = 321
                  Hint = 'Update Options'
                  Align = alClient
                  Color = clWindow
                  Ctl3D = False
                  Font.Charset = RUSSIAN_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -11
                  Font.Name = 'Tahoma'
                  Font.Style = []
                  ParentColor = False
                  ParentCtl3D = False
                  ParentFont = False
                  TabOrder = 0
                end
                object frmResourceOptions: TfrmADGUIxFormsResourceOptions
                  Left = 0
                  Top = 0
                  Width = 606
                  Height = 321
                  Hint = 'Resource Options'
                  Align = alClient
                  Color = clWindow
                  Ctl3D = False
                  Font.Charset = RUSSIAN_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -11
                  Font.Name = 'Tahoma'
                  Font.Style = []
                  ParentColor = False
                  ParentCtl3D = False
                  ParentFont = False
                  TabOrder = 1
                end
                object frmFormatOptions: TfrmADGUIxFormsFormatOptions
                  Left = 0
                  Top = 0
                  Width = 606
                  Height = 321
                  Hint = 'Format Options'
                  Align = alClient
                  Color = clWindow
                  Ctl3D = False
                  Font.Charset = RUSSIAN_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -11
                  Font.Name = 'Tahoma'
                  Font.Style = []
                  ParentColor = False
                  ParentCtl3D = False
                  ParentFont = False
                  TabOrder = 2
                end
                object frmFetchOptions: TfrmADGUIxFormsFetchOptions
                  Left = 0
                  Top = 0
                  Width = 606
                  Height = 321
                  Hint = 'Fetch Options'
                  Align = alClient
                  Color = clWindow
                  Ctl3D = True
                  Font.Charset = RUSSIAN_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -11
                  Font.Name = 'Tahoma'
                  Font.Style = []
                  ParentColor = False
                  ParentCtl3D = False
                  ParentFont = False
                  TabOrder = 3
                end
              end
              object pnlDataSet: TPanel
                Left = 0
                Top = 0
                Width = 610
                Height = 41
                Align = alTop
                BevelOuter = bvNone
                ParentColor = True
                TabOrder = 0
                object btnSave: TSpeedButton
                  Left = 198
                  Top = 8
                  Width = 76
                  Height = 21
                  Caption = 'Save'
                  Flat = True
                  OnClick = btnSaveClick
                end
                object lblDataSet: TLabel
                  Left = 11
                  Top = 11
                  Width = 42
                  Height = 13
                  Alignment = taRightJustify
                  Caption = 'Dataset:'
                end
                object cbDataSet: TComboBox
                  Left = 55
                  Top = 8
                  Width = 137
                  Height = 21
                  BevelInner = bvSpace
                  BevelKind = bkFlat
                  BevelOuter = bvRaised
                  Style = csDropDownList
                  ItemHeight = 13
                  TabOrder = 0
                  OnChange = cbDataSetClick
                end
              end
            end
          end
          object pnlMainSep: TPanel
            Left = 0
            Top = 0
            Width = 618
            Height = 1
            Align = alTop
            BevelOuter = bvNone
            Color = clBtnShadow
            TabOrder = 1
          end
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 580
  end
  inherited StatusBar1: TStatusBar
    Top = 561
  end
end
