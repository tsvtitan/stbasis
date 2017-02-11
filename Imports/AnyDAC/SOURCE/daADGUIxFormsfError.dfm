object frmADGUIxFormsError: TfrmADGUIxFormsError
  Left = 496
  Top = 202
  Width = 453
  Height = 436
  BorderIcons = [biSystemMenu]
  Caption = 'AnyDAC Error'
  Color = clBtnFace
  ParentFont = True
  FormStyle = fsStayOnTop
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMain: TADGUIxFormsPanel
    Left = 0
    Top = 0
    Width = 445
    Height = 115
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 4
    TabOrder = 1
    object pnlFrame: TADGUIxFormsPanel
      Left = 4
      Top = 4
      Width = 437
      Height = 107
      Align = alClient
      BevelOuter = bvNone
      BorderWidth = 1
      Color = clGray
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 0
      object pnlContent: TADGUIxFormsPanel
        Left = 1
        Top = 38
        Width = 435
        Height = 68
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 5
        Color = clWhite
        TabOrder = 0
        object memMsg: TMemo
          Left = 5
          Top = 5
          Width = 425
          Height = 58
          Align = alClient
          BorderStyle = bsNone
          Ctl3D = True
          Lines.Strings = (
            '1'
            '2'
            '3'
            '4'
            '5'
            '6')
          ParentCtl3D = False
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
      object pnlTitle: TADGUIxFormsPanel
        Left = 1
        Top = 1
        Width = 435
        Height = 37
        Align = alTop
        Alignment = taLeftJustify
        BevelOuter = bvNone
        Caption = '               Main Error Information'
        Color = $F0CAA6
        Ctl3D = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 1
        object imIcon: TImage
          Left = 7
          Top = 1
          Width = 32
          Height = 34
          Center = True
          Picture.Data = {
            07544269746D617076020000424D760200000000000076000000280000002000
            0000200000000100040000000000000200000000000000000000100000000000
            0000000000000000800000800000008080008000000080008000808000008080
            8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
            FF00333333333333377777777333333333333333333333777777777777773333
            3333333333333771111111177777733333333333333711199999999111777773
            3333333333719999999999999917777733333333311999999999999999911777
            7333333319999999999999999999917773333331999999999999999999999917
            773333319999999999999999999999177773331999999F9999999999F9999991
            777331999999FFF99999999FFF99999917733199999FFFFF999999FFFFF99999
            177731999999FFFFF9999FFFFF9999991777199999999FFFFF99FFFFF9999999
            91771999999999FFFFFFFFFF99999999917719999999999FFFFFFFF999999999
            9177199999999999FFFFFF99999999999177199999999999FFFFFF9999999999
            917719999999999FFFFFFFF99999999991771999999999FFFFFFFFFF99999999
            9173199999999FFFFF99FFFFF9999999917331999999FFFFF9999FFFFF999999
            17733199999FFFFF999999FFFFF99999173331999999FFF99999999FFF999999
            1333331999999F9999999999F999999173333331999999999999999999999917
            3333333199999999999999999999991333333333199999999999999999999133
            3333333331199999999999999991133333333333333199999999999999133333
            3333333333331119999999911133333333333333333333311111111333333333
            3333}
          Transparent = True
        end
        object pnlTitleBottomLine: TADGUIxFormsPanel
          Left = 0
          Top = 36
          Width = 435
          Height = 1
          Align = alBottom
          BevelOuter = bvNone
          Color = clBtnShadow
          TabOrder = 0
        end
      end
    end
  end
  object pnlButtons: TADGUIxFormsPanel
    Left = 0
    Top = 115
    Width = 445
    Height = 39
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 0
    object Bevel2: TBevel
      Left = 5
      Top = 5
      Width = 435
      Height = 29
      Align = alClient
      Shape = bsBottomLine
      Visible = False
    end
    object btnOk: TButton
      Left = 286
      Top = 2
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '&OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object btnAdvanced: TButton
      Left = 366
      Top = 2
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Advanced'
      TabOrder = 1
      OnClick = DetailsBtnClick
    end
  end
  object pcAdvanced: TPageControl
    Left = 0
    Top = 154
    Width = 445
    Height = 248
    ActivePage = tsAdvanced
    Align = alBottom
    Style = tsFlatButtons
    TabOrder = 2
    Visible = False
    object tsAdvanced: TTabSheet
      Caption = 'Error'
      object pnlAdvanced: TADGUIxFormsPanel
        Left = 0
        Top = 0
        Width = 437
        Height = 217
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 1
        Color = clGray
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 0
        object Panel2: TADGUIxFormsPanel
          Left = 1
          Top = 24
          Width = 435
          Height = 192
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 5
          Color = clWhite
          TabOrder = 0
          object Bevel1: TBevel
            Left = 8
            Top = 5
            Width = 419
            Height = 152
            Anchors = [akLeft, akRight, akBottom]
            Shape = bsBottomLine
          end
          object NativeLabel: TLabel
            Left = 8
            Top = 10
            Width = 52
            Height = 13
            Caption = 'Error code:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Label1: TLabel
            Left = 8
            Top = 104
            Width = 66
            Height = 13
            Anchors = [akLeft, akBottom]
            Caption = 'Server object:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Label2: TLabel
            Left = 125
            Top = 10
            Width = 48
            Height = 13
            Caption = 'Error kind:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Label3: TLabel
            Left = 8
            Top = 130
            Width = 99
            Height = 13
            Anchors = [akLeft, akBottom]
            Caption = 'Command text offset:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Label4: TLabel
            Left = 8
            Top = 32
            Width = 61
            Height = 13
            Caption = 'Mesage text:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object edtErrorCode: TEdit
            Left = 64
            Top = 9
            Width = 50
            Height = 19
            TabStop = False
            Ctl3D = True
            ParentColor = True
            ParentCtl3D = False
            ReadOnly = True
            TabOrder = 0
            Text = '00000'
          end
          object edtServerObject: TEdit
            Left = 111
            Top = 103
            Width = 316
            Height = 19
            TabStop = False
            Anchors = [akLeft, akRight, akBottom]
            Ctl3D = True
            ParentColor = True
            ParentCtl3D = False
            ReadOnly = True
            TabOrder = 3
            Text = 'QWE'
          end
          object edtMessage: TMemo
            Left = 8
            Top = 48
            Width = 420
            Height = 49
            TabStop = False
            Anchors = [akLeft, akTop, akRight, akBottom]
            BorderStyle = bsNone
            Ctl3D = True
            Lines.Strings = (
              'DbMessageText')
            ParentCtl3D = False
            ReadOnly = True
            ScrollBars = ssVertical
            TabOrder = 2
          end
          object edtErrorKind: TEdit
            Left = 177
            Top = 9
            Width = 117
            Height = 19
            TabStop = False
            Ctl3D = True
            ParentColor = True
            ParentCtl3D = False
            ReadOnly = True
            TabOrder = 1
            Text = 'RecordLocked'
          end
          object edtCommandTextOffset: TEdit
            Left = 111
            Top = 129
            Width = 55
            Height = 19
            TabStop = False
            Anchors = [akLeft, akBottom]
            Ctl3D = True
            ParentColor = True
            ParentCtl3D = False
            ReadOnly = True
            TabOrder = 4
            Text = '00000'
          end
          object btnPrior: TButton
            Left = 273
            Top = 161
            Width = 75
            Height = 25
            Anchors = [akRight, akBottom]
            Caption = '&<<'
            TabOrder = 5
            OnClick = BackClick
          end
          object btnNext: TButton
            Left = 353
            Top = 161
            Width = 75
            Height = 25
            Anchors = [akRight, akBottom]
            Caption = '>&>'
            TabOrder = 6
            OnClick = NextClick
          end
        end
        object pnlAdvancedCaption: TADGUIxFormsPanel
          Left = 1
          Top = 1
          Width = 435
          Height = 23
          Align = alTop
          Alignment = taLeftJustify
          BevelOuter = bvNone
          Caption = '   Advanced Error Information'
          Color = $F0CAA6
          Ctl3D = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 1
          object Panel8: TADGUIxFormsPanel
            Left = 0
            Top = 22
            Width = 435
            Height = 1
            Align = alBottom
            BevelOuter = bvNone
            Color = clBtnShadow
            TabOrder = 0
          end
        end
      end
    end
    object tsQuery: TTabSheet
      Caption = 'Query'
      ImageIndex = 1
      object Panel1: TADGUIxFormsPanel
        Left = 0
        Top = 0
        Width = 437
        Height = 217
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 1
        Color = clGray
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 0
        object Panel3: TADGUIxFormsPanel
          Left = 1
          Top = 24
          Width = 435
          Height = 192
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 5
          Color = clWhite
          TabOrder = 0
          object Label9: TLabel
            Left = 8
            Top = 8
            Width = 70
            Height = 13
            Caption = 'Command text:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Label5: TLabel
            Left = 8
            Top = 80
            Width = 105
            Height = 13
            Anchors = [akLeft, akBottom]
            Caption = 'Command parameters:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object mmCommandText: TMemo
            Left = 8
            Top = 24
            Width = 420
            Height = 49
            TabStop = False
            Anchors = [akLeft, akTop, akRight, akBottom]
            Ctl3D = True
            ParentCtl3D = False
            ReadOnly = True
            ScrollBars = ssVertical
            TabOrder = 0
          end
          object lvCommandParams: TListView
            Left = 8
            Top = 97
            Width = 420
            Height = 84
            Anchors = [akLeft, akRight, akBottom]
            BorderStyle = bsNone
            Columns = <
              item
                Caption = 'Name'
                Width = 150
              end
              item
                Caption = 'Value'
                Width = 250
              end>
            Ctl3D = True
            TabOrder = 1
            ViewStyle = vsReport
          end
        end
        object Panel4: TADGUIxFormsPanel
          Left = 1
          Top = 1
          Width = 435
          Height = 23
          Align = alTop
          Alignment = taLeftJustify
          BevelOuter = bvNone
          Caption = '   Failed Command Information'
          Color = $F0CAA6
          Ctl3D = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 1
          object Panel9: TADGUIxFormsPanel
            Left = 0
            Top = 22
            Width = 435
            Height = 1
            Align = alBottom
            BevelOuter = bvNone
            Color = clBtnShadow
            TabOrder = 0
          end
        end
      end
    end
    object tsOther: TTabSheet
      Caption = 'Other'
      ImageIndex = 2
      object Panel5: TADGUIxFormsPanel
        Left = 0
        Top = 0
        Width = 437
        Height = 217
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 1
        Color = clGray
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 0
        object Panel6: TADGUIxFormsPanel
          Left = 1
          Top = 24
          Width = 435
          Height = 192
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 5
          Color = clWhite
          TabOrder = 0
          object Label6: TLabel
            Left = 8
            Top = 10
            Width = 106
            Height = 13
            Caption = 'Exception class name:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Label7: TLabel
            Left = 8
            Top = 36
            Width = 94
            Height = 13
            Caption = 'AnyDAC error code:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object edtClassName: TEdit
            Left = 118
            Top = 9
            Width = 160
            Height = 19
            TabStop = False
            Ctl3D = True
            ParentColor = True
            ParentCtl3D = False
            ReadOnly = True
            TabOrder = 0
            Text = 'EODBCNativeException'
          end
          object edtDECode: TEdit
            Left = 118
            Top = 35
            Width = 160
            Height = 19
            TabStop = False
            Ctl3D = True
            ParentColor = True
            ParentCtl3D = False
            ReadOnly = True
            TabOrder = 1
            Text = '12345'
          end
        end
        object Panel7: TADGUIxFormsPanel
          Left = 1
          Top = 1
          Width = 435
          Height = 23
          Align = alTop
          Alignment = taLeftJustify
          BevelOuter = bvNone
          Caption = '   Exception Object Information'
          Color = $F0CAA6
          Ctl3D = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 1
          object Panel10: TADGUIxFormsPanel
            Left = 0
            Top = 22
            Width = 435
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
