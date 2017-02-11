inherited frmADGUIxFormsQBldrLink: TfrmADGUIxFormsQBldrLink
  Left = 587
  Top = 134
  ActiveControl = RadioOpt
  BorderStyle = bsSingle
  Caption = 'AnyDAC QB'
  ClientHeight = 354
  ClientWidth = 250
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlButtons: TADGUIxFormsPanel
    Top = 320
    Width = 250
    inherited btnOk: TButton
      Left = 90
    end
    inherited btnCancel: TButton
      Left = 171
    end
  end
  inherited pnlMain: TADGUIxFormsPanel
    Width = 250
    Height = 320
    inherited pnlGray: TADGUIxFormsPanel
      Width = 242
      Height = 312
      inherited pnlOptions: TADGUIxFormsPanel
        Top = 38
        Width = 240
        Height = 273
        object Label1: TLabel
          Left = 8
          Top = 14
          Width = 39
          Height = 13
          Caption = 'Table 1:'
        end
        object Label3: TLabel
          Left = 8
          Top = 39
          Width = 48
          Height = 13
          Caption = 'Column 1:'
        end
        object Label2: TLabel
          Left = 8
          Top = 64
          Width = 39
          Height = 13
          Caption = 'Table 2:'
        end
        object Label4: TLabel
          Left = 8
          Top = 89
          Width = 48
          Height = 13
          Caption = 'Column 2:'
        end
        object txtTable1: TEdit
          Left = 61
          Top = 12
          Width = 169
          Height = 19
          AutoSize = False
          Ctl3D = True
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 0
          Text = '[1]'
        end
        object txtCol1: TEdit
          Left = 61
          Top = 37
          Width = 169
          Height = 19
          AutoSize = False
          Ctl3D = True
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 1
          Text = '[1]'
        end
        object txtTable2: TEdit
          Left = 61
          Top = 62
          Width = 170
          Height = 19
          AutoSize = False
          Ctl3D = True
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 2
          Text = '[1]'
        end
        object txtCol2: TEdit
          Left = 61
          Top = 87
          Width = 170
          Height = 19
          AutoSize = False
          Ctl3D = True
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 3
          Text = '[1]'
        end
        object RadioOpt: TRadioGroup
          Left = 10
          Top = 114
          Width = 102
          Height = 150
          Caption = 'Join Operator'
          Ctl3D = True
          ItemIndex = 0
          Items.Strings = (
            '='
            '<'
            '>'
            '<='
            '>='
            '<>')
          ParentCtl3D = False
          TabOrder = 4
        end
        object RadioType: TRadioGroup
          Left = 124
          Top = 114
          Width = 107
          Height = 150
          Caption = 'Join Type'
          Ctl3D = True
          ItemIndex = 0
          Items.Strings = (
            'Inner'
            'Left Outer'
            'Right Outer'
            'Full Outer')
          ParentCtl3D = False
          TabOrder = 5
        end
      end
      inherited pnlTitle: TADGUIxFormsPanel
        Width = 240
        Height = 37
        inherited lblTitle: TLabel
          Left = 39
          Top = 12
          Caption = 'Set Link Options'
        end
        object Image1: TImage [1]
          Left = 7
          Top = 6
          Width = 24
          Height = 24
          AutoSize = True
          Picture.Data = {
            07544269746D617076060000424D760600000000000036040000280000001800
            000018000000010008000000000040020000D30E0000D30E0000000100000001
            000031293100214239004A4A4A00636363006B6B6B0073736B00737373007B7B
            7B008C8C8C009C9C9C00ADA5AD009CB5AD00BDBDBD00BDC6CE00CECECE00D6D6
            D600F7F7F700FF00FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00111111111111111111111111111111111111111111111111111111111111
            1111111111111111110302020311111111111111111111111111111111111111
            0203070507031111111111111111111111111111111111020306070906040811
            11111111111111111111111111110303060811110E0708111111111111111111
            111111111102030608111111090808111111111111111111111111110A000304
            0E11110A0A0D0B1111111111111111111111111105020202030E0A0A100E1111
            1111111111111111111111110806020808090A100E1111111111111111111111
            111111110A060808080A100E111111111111111111111111090507090203080C
            0E0D0E111111111111111111111111030307040307080E0B0A0E111111111111
            11111111111103050302030E090E111111111111111111111111111111030506
            0B030E09070A11111111111111111111111111110305060A0C070808080A1111
            11111111111111111111110702060E11110C0A0A080E11111111111111111111
            11111101060A1111110A0C100E111111111111111111111111111102020C1111
            0A0D100E1111111111111111111111111111110703060A090D100E1111111111
            111111111111111111111111070F0D0F0D0E1111111111111111111111111111
            11111111110A0A0A0E1111111111111111111111111111111111111111111111
            1111111111111111111111111111111111111111111111111111111111111111
            1111111111111111111111111111111111111111111111111111111111111111
            1111}
          Transparent = True
        end
        inherited pnlTitleBottomLine: TADGUIxFormsPanel
          Top = 36
          Width = 240
        end
      end
    end
  end
end
