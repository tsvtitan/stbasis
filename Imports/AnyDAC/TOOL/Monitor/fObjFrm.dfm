object ADMoniObjectsFrm: TADMoniObjectsFrm
  Left = 353
  Top = 162
  Width = 796
  Height = 705
  Caption = 'Application Objects'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMain: TADGUIxFormsPanel
    Left = 0
    Top = 0
    Width = 788
    Height = 671
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 4
    TabOrder = 0
    object Splitter1: TSplitter
      Left = 213
      Top = 4
      Width = 4
      Height = 663
      Cursor = crHSplit
    end
    object pnlMainFrame: TADGUIxFormsPanel
      Left = 217
      Top = 4
      Width = 567
      Height = 663
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object pnlDetails: TADGUIxFormsPanel
        Left = 0
        Top = 0
        Width = 567
        Height = 663
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 1
        Color = clBtnShadow
        TabOrder = 0
        object pnlDetailsWhite: TADGUIxFormsPanel
          Left = 1
          Top = 1
          Width = 565
          Height = 661
          Align = alClient
          BevelOuter = bvNone
          Color = clWindow
          TabOrder = 0
          object Splitter2: TSplitter
            Left = 0
            Top = 576
            Width = 565
            Height = 4
            Cursor = crVSplit
            Align = alBottom
          end
          object Splitter3: TSplitter
            Left = 0
            Top = 492
            Width = 565
            Height = 4
            Cursor = crVSplit
            Align = alBottom
          end
          object Panel12: TADGUIxFormsPanel
            Left = 0
            Top = 496
            Width = 565
            Height = 80
            Align = alBottom
            BevelOuter = bvNone
            Color = clWindow
            TabOrder = 0
            object Panel13: TADGUIxFormsPanel
              Left = 0
              Top = 0
              Width = 565
              Height = 23
              Align = alTop
              Alignment = taLeftJustify
              BevelOuter = bvNone
              Color = 15780518
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 0
              object Label1: TLabel
                Left = 11
                Top = 4
                Width = 21
                Height = 13
                Caption = 'SQL'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'Tahoma'
                Font.Style = [fsBold]
                ParentFont = False
              end
              object Panel14: TADGUIxFormsPanel
                Left = 0
                Top = 22
                Width = 565
                Height = 1
                Align = alBottom
                BevelOuter = bvNone
                Color = clBtnShadow
                TabOrder = 0
              end
              object Panel1: TADGUIxFormsPanel
                Left = 0
                Top = 0
                Width = 565
                Height = 1
                Align = alTop
                BevelOuter = bvNone
                Color = clBtnShadow
                TabOrder = 1
              end
            end
            object mmSQL: TMemo
              Left = 0
              Top = 23
              Width = 565
              Height = 56
              Hint = 'Current application object SQL'
              Align = alClient
              BorderStyle = bsNone
              ReadOnly = True
              ScrollBars = ssBoth
              TabOrder = 1
            end
            object Panel8: TADGUIxFormsPanel
              Left = 0
              Top = 79
              Width = 565
              Height = 1
              Align = alBottom
              BevelOuter = bvNone
              Color = clBtnShadow
              TabOrder = 2
            end
          end
          object Panel6: TADGUIxFormsPanel
            Left = 0
            Top = 580
            Width = 565
            Height = 81
            Align = alBottom
            BevelOuter = bvNone
            Color = clWindow
            TabOrder = 1
            object Panel15: TADGUIxFormsPanel
              Left = 0
              Top = 0
              Width = 565
              Height = 23
              Align = alTop
              Alignment = taLeftJustify
              BevelOuter = bvNone
              Color = 15780518
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 0
              object Label2: TLabel
                Left = 11
                Top = 4
                Width = 67
                Height = 13
                Caption = 'Parameters'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'Tahoma'
                Font.Style = [fsBold]
                ParentFont = False
              end
              object Panel16: TADGUIxFormsPanel
                Left = 0
                Top = 22
                Width = 565
                Height = 1
                Align = alBottom
                BevelOuter = bvNone
                Color = clBtnShadow
                TabOrder = 0
              end
              object Panel2: TADGUIxFormsPanel
                Left = 0
                Top = 0
                Width = 565
                Height = 1
                Align = alTop
                BevelOuter = bvNone
                Color = clBtnShadow
                TabOrder = 1
              end
            end
            object lvParams: TListView
              Left = 0
              Top = 23
              Width = 565
              Height = 58
              Hint = 'Current application object parameters'
              Align = alClient
              BorderStyle = bsNone
              Columns = <
                item
                  Caption = 'Parameter'
                  Width = 130
                end
                item
                  Caption = 'Value'
                  Width = 70
                end>
              FlatScrollBars = True
              ReadOnly = True
              TabOrder = 1
              ViewStyle = vsReport
            end
          end
          object Panel4: TADGUIxFormsPanel
            Left = 0
            Top = 0
            Width = 565
            Height = 492
            Align = alClient
            BevelOuter = bvNone
            Color = clWindow
            TabOrder = 2
            object Panel7: TADGUIxFormsPanel
              Left = 0
              Top = 0
              Width = 565
              Height = 23
              Align = alTop
              Alignment = taLeftJustify
              BevelOuter = bvNone
              Color = 15780518
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 0
              object Label3: TLabel
                Left = 11
                Top = 4
                Width = 47
                Height = 13
                Caption = 'Statistic'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'Tahoma'
                Font.Style = [fsBold]
                ParentFont = False
              end
              object Panel3: TADGUIxFormsPanel
                Left = 0
                Top = 22
                Width = 565
                Height = 1
                Align = alBottom
                BevelOuter = bvNone
                Color = clBtnShadow
                TabOrder = 0
              end
            end
            object lvStat: TListView
              Left = 0
              Top = 23
              Width = 565
              Height = 468
              Hint = 'Current application object execution statistic'
              Align = alClient
              BorderStyle = bsNone
              Columns = <
                item
                  Caption = 'Item'
                  Width = 130
                end
                item
                  Caption = 'Value'
                  Width = 70
                end>
              FlatScrollBars = True
              ReadOnly = True
              TabOrder = 1
              ViewStyle = vsReport
            end
            object Panel5: TADGUIxFormsPanel
              Left = 0
              Top = 491
              Width = 565
              Height = 1
              Align = alBottom
              BevelOuter = bvNone
              Color = clBtnShadow
              TabOrder = 2
            end
          end
        end
      end
    end
    object pnlObjects: TADGUIxFormsPanel
      Left = 4
      Top = 4
      Width = 209
      Height = 663
      Align = alLeft
      BevelOuter = bvNone
      BorderWidth = 1
      Color = clBtnShadow
      TabOrder = 1
      object pnlObjectsWhite: TADGUIxFormsPanel
        Left = 1
        Top = 1
        Width = 207
        Height = 661
        Align = alClient
        BevelOuter = bvNone
        Color = clWindow
        TabOrder = 0
        object tvAdapters: TTreeView
          Left = 0
          Top = 23
          Width = 207
          Height = 638
          Hint = 'Application monitoring objects tree'
          Align = alClient
          BorderStyle = bsNone
          HideSelection = False
          HotTrack = True
          Indent = 19
          ParentColor = True
          ReadOnly = True
          TabOrder = 0
        end
        object pnlObjectsTitle: TADGUIxFormsPanel
          Left = 0
          Top = 0
          Width = 207
          Height = 23
          Align = alTop
          Alignment = taLeftJustify
          BevelOuter = bvNone
          Color = 15780518
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          object lblObjectsTitle: TLabel
            Left = 11
            Top = 4
            Width = 43
            Height = 13
            Caption = 'Objects'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object pnlObjectsTitleBottomLine: TADGUIxFormsPanel
            Left = 0
            Top = 22
            Width = 207
            Height = 1
            Align = alBottom
            BevelOuter = bvNone
            Color = clBtnShadow
            TabOrder = 0
          end
        end
      end
    end
  end
end
