object ADMoniTraceFrm: TADMoniTraceFrm
  Left = 282
  Top = 76
  Width = 696
  Height = 480
  Caption = 'Trace Ouput'
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
    Width = 688
    Height = 446
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 4
    TabOrder = 0
    object pnlMainFrame: TADGUIxFormsPanel
      Left = 4
      Top = 4
      Width = 680
      Height = 438
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object splDetailSpliter: TSplitter
        Left = 0
        Top = 307
        Width = 680
        Height = 4
        Cursor = crVSplit
        Align = alBottom
      end
      object Panel4: TADGUIxFormsPanel
        Left = 0
        Top = 0
        Width = 680
        Height = 307
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 1
        Color = clBtnShadow
        TabOrder = 0
        object Panel10: TADGUIxFormsPanel
          Left = 1
          Top = 1
          Width = 678
          Height = 305
          Align = alClient
          BevelOuter = bvNone
          Color = clWindow
          TabOrder = 0
          object TreeView1: TTreeView
            Left = 0
            Top = 40
            Width = 678
            Height = 265
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
          object pnlTraceTitle: TADGUIxFormsPanel
            Left = 0
            Top = 0
            Width = 678
            Height = 23
            Align = alTop
            Alignment = taLeftJustify
            BevelOuter = bvNone
            Color = 15780518
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 1
            object lblTraceTitle: TLabel
              Left = 11
              Top = 4
              Width = 32
              Height = 13
              Caption = 'Trace'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object pnlTraceTitleBottomLine: TADGUIxFormsPanel
              Left = 0
              Top = 22
              Width = 678
              Height = 1
              Align = alBottom
              BevelOuter = bvNone
              Color = clBtnShadow
              TabOrder = 0
            end
          end
          object HeaderControl1: THeaderControl
            Left = 0
            Top = 23
            Width = 678
            Height = 17
            DragReorder = False
            Enabled = False
            Sections = <
              item
                AllowClick = False
                ImageIndex = -1
                Text = 'No'
                Width = 50
              end
              item
                AllowClick = False
                ImageIndex = -1
                Text = 'Time'
                Width = 80
              end
              item
                AllowClick = False
                ImageIndex = -1
                Text = 'Text'
                Width = 400
              end>
            Style = hsFlat
          end
          object lbTrace: TListBox
            Left = 0
            Top = 40
            Width = 678
            Height = 265
            Hint = 'Trace log'
            Align = alClient
            BorderStyle = bsNone
            ItemHeight = 13
            MultiSelect = True
            TabOrder = 3
          end
        end
      end
      object pnlDetails: TADGUIxFormsPanel
        Left = 0
        Top = 311
        Width = 680
        Height = 127
        Align = alBottom
        BevelOuter = bvNone
        BorderWidth = 1
        Color = clBtnShadow
        TabOrder = 1
        object pnlDetailsWhite: TADGUIxFormsPanel
          Left = 1
          Top = 1
          Width = 678
          Height = 125
          Align = alClient
          BevelOuter = bvNone
          Color = clWindow
          TabOrder = 0
          object pnlDetailTitle: TADGUIxFormsPanel
            Left = 0
            Top = 0
            Width = 678
            Height = 23
            Align = alTop
            Alignment = taLeftJustify
            BevelOuter = bvNone
            Color = 15780518
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 0
            object lblDetailTitle: TLabel
              Left = 11
              Top = 4
              Width = 50
              Height = 13
              Caption = 'Message'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Panel1: TADGUIxFormsPanel
              Left = 0
              Top = 22
              Width = 678
              Height = 1
              Align = alBottom
              BevelOuter = bvNone
              Color = clBtnShadow
              TabOrder = 0
            end
          end
          object mmDetails: TMemo
            Left = 0
            Top = 23
            Width = 678
            Height = 102
            Hint = 'Current trace log item'
            Align = alClient
            BorderStyle = bsNone
            Ctl3D = True
            ParentCtl3D = False
            ReadOnly = True
            ScrollBars = ssVertical
            TabOrder = 1
          end
        end
      end
    end
  end
end
