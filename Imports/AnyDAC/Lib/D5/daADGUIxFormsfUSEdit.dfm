inherited frmADGUIxFormsUSEdit: TfrmADGUIxFormsUSEdit
  Left = 357
  Top = 163
  Caption = 'frmADGUIxFormsUSEdit'
  ClientHeight = 427
  ClientWidth = 602
  Font.Charset = RUSSIAN_CHARSET
  OldCreateOrder = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlButtons: TADGUIxFormsPanel
    Top = 393
    Width = 602
    inherited btnOk: TButton
      Left = 439
    end
    inherited btnCancel: TButton
      Left = 520
    end
  end
  inherited pnlMain: TADGUIxFormsPanel
    Width = 602
    Height = 393
    inherited pnlGray: TADGUIxFormsPanel
      Width = 594
      Height = 385
      inherited pnlOptions: TADGUIxFormsPanel
        Top = 38
        Width = 592
        Height = 346
        object pcMain: TADGUIxFormsPageControl
          Left = 3
          Top = 3
          Width = 586
          Height = 340
          ActivePage = tsOptions
          Align = alClient
          Style = tsFlatButtons
          TabOrder = 0
          object tsOptions: TTabSheet
            Caption = 'Main Settings'
            ImageIndex = 1
            object Label1: TLabel
              Left = 0
              Top = 2
              Width = 56
              Height = 13
              Caption = '&Table Name'
              FocusControl = cbxTableName
            end
            object GroupBox2: TLabel
              Left = 0
              Top = 46
              Width = 48
              Height = 13
              Caption = 'Key Fields'
            end
            object GroupBox3: TLabel
              Left = 196
              Top = 46
              Width = 73
              Height = 13
              Caption = 'Updating Fields'
            end
            object GroupBox4: TLabel
              Left = 392
              Top = 46
              Width = 82
              Height = 13
              Caption = 'Refreshing Fields'
            end
            object Bevel2: TBevel
              Left = 53
              Top = 46
              Width = 133
              Height = 9
              Shape = bsBottomLine
            end
            object Bevel3: TBevel
              Left = 274
              Top = 46
              Width = 107
              Height = 9
              Shape = bsBottomLine
            end
            object Bevel4: TBevel
              Left = 478
              Top = 46
              Width = 98
              Height = 9
              Shape = bsBottomLine
            end
            object cbxTableName: TComboBox
              Left = 0
              Top = 18
              Width = 129
              Height = 21
              Ctl3D = True
              ItemHeight = 13
              ParentCtl3D = False
              TabOrder = 4
              OnChange = cbxTableNameChange
              OnClick = cbxTableNameClick
              OnDropDown = cbxTableNameDropDown
            end
            object btnDSDefaults: TButton
              Left = 272
              Top = 15
              Width = 129
              Height = 25
              Caption = 'Get &Dataset Props'
              TabOrder = 1
              OnClick = btnDSDefaultsClick
            end
            object btnGenSQL: TButton
              Left = 408
              Top = 15
              Width = 129
              Height = 25
              Caption = '&Generate SQL'
              TabOrder = 2
              OnClick = btnGenSQLClick
            end
            object btnServerInfo: TButton
              Left = 136
              Top = 15
              Width = 129
              Height = 25
              Caption = 'Get D&BMS Info'
              TabOrder = 3
              OnClick = btnServerInfoClick
            end
            object lbKeyFields: TListBox
              Left = 0
              Top = 65
              Width = 186
              Height = 243
              Anchors = [akLeft, akTop, akBottom]
              Color = clInfoBk
              Ctl3D = True
              ItemHeight = 13
              MultiSelect = True
              ParentCtl3D = False
              TabOrder = 5
            end
            object lbUpdateFields: TListBox
              Left = 196
              Top = 65
              Width = 186
              Height = 243
              Anchors = [akLeft, akTop, akBottom]
              Color = clInfoBk
              Ctl3D = True
              ItemHeight = 13
              MultiSelect = True
              ParentCtl3D = False
              TabOrder = 6
            end
            object lbRefetchFields: TListBox
              Left = 392
              Top = 65
              Width = 185
              Height = 243
              Anchors = [akLeft, akTop, akBottom]
              Color = clInfoBk
              Ctl3D = True
              ItemHeight = 13
              MultiSelect = True
              ParentCtl3D = False
              TabOrder = 0
            end
          end
          object tsAdvanced: TTabSheet
            Caption = 'Advanced Options'
            ImageIndex = 2
            object ptreeAdvanced: TADGUIxFormsPanelTree
              Left = 0
              Top = 0
              Width = 578
              Height = 268
              HorzScrollBar.Smooth = True
              HorzScrollBar.Style = ssFlat
              HorzScrollBar.Tracking = True
              VertScrollBar.Smooth = True
              VertScrollBar.Style = ssFlat
              VertScrollBar.Tracking = True
              Align = alClient
              TabOrder = 0
              object GroupBox5: TADGUIxFormsPanel
                Left = 3
                Top = 241
                Width = 190
                Height = 63
                Caption = 'SQL generation'
                Color = clWindow
                Ctl3D = True
                ParentCtl3D = False
                TabOrder = 0
                object cbQuoteTabName: TCheckBox
                  Left = 11
                  Top = 34
                  Width = 121
                  Height = 17
                  Caption = 'Quote Table Name'
                  TabOrder = 0
                end
                object cbQuoteColName: TCheckBox
                  Left = 11
                  Top = 11
                  Width = 129
                  Height = 17
                  Caption = 'Quote Column Names'
                  TabOrder = 1
                end
              end
              object frmUpdateOptions: TfrmADGUIxFormsUpdateOptions
                Left = 0
                Top = 0
                Width = 558
                Height = 240
                Hint = 'Update Options'
                Align = alTop
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
                TabOrder = 1
              end
            end
          end
          object tsSQL: TTabSheet
            Caption = 'SQL Kinds'
            ImageIndex = 1
            object Panel1: TADGUIxFormsPanel
              Left = 0
              Top = 0
              Width = 578
              Height = 268
              Align = alClient
              BevelOuter = bvNone
              Color = clWhite
              Ctl3D = False
              ParentCtl3D = False
              TabOrder = 0
              object tcSQLKind: TADGUIxFormsTabControl
                Left = 0
                Top = 0
                Width = 578
                Height = 41
                OnChange = rgSQLKindClick
                Position = tpTop
                TabIndex = 0
                Tabs.Strings = (
                  'Insert'
                  'Modify'
                  'Delete'
                  'Lock'
                  'Unlock'
                  'FetchRow')
                Align = alTop
              end
            end
          end
        end
      end
      inherited pnlTitle: TADGUIxFormsPanel
        Width = 592
        Height = 37
        inherited lblTitle: TLabel
          Left = 39
          Top = 12
          Width = 191
          Caption = 'Setup And Generate Update SQL'#39's'
        end
        object Image1: TImage [1]
          Left = 7
          Top = 6
          Width = 24
          Height = 24
          AutoSize = True
          Picture.Data = {
            07544269746D617076060000424D760600000000000036040000280000001800
            000018000000010008000000000040020000E30E0000E30E0000000100000001
            00002D2D2D006B31180052392900633921004A4239005A423100524239005A4A
            3900734221007B42210018556F0045444200524A42005A4A420052524A005853
            4E005A525200635A52005160610054777B00636363006B6B6B007B6B63007373
            6B007C7078007B7B7B0084391000A5390000BD520800B5521000BD5A1000B552
            18008C4A21008C522100945221009C5221009C5A2100A55A2100B55A21009C63
            31009C6B3900AD632100B56B2900BD6B2900AD633100B5633100BD633100B56B
            3100B56D3E00BD6B3900C65A0000C65A0800CE630000CE630800CE6B0800C663
            1800D66B1000D6731000C6632100C66B2900C6732900CE732900D67B2100D67B
            2900C6733100C1713500C6733900C07638008A5B5200BD734200947E7500AD7B
            7300C67B4200C67B5200DE842900DE8C3900BD9C6B00AD9C7300A5947B00AD9C
            7B00BDA57300CE845200C6845A00CE9C5A00D69C5200DE945A00EFA55200EFA6
            5A00EDA75F00F0A85C00CE8C6B00CE946300CE9C6B00D6946B00CE9C7B00CEA5
            6B00EFBD6B00FFBD6300F7B56B00E7A57300EFB57B00F7BD730000009A000316
            AC0041749600477AA9000018C6001029D600106BFF00FF00FF00009CCE0035A8
            F5004AADCE0052B5D60063BDCE007BBDCE006BBDD6004A9EED006D8AFD008484
            84009C9484009891A200D6A58400DEAD8C00EFB58400F1BC8600E7BD9C00E7BD
            A500FFCE8400F8C28C00F9C48D00FFCE8C00EFC69C00F7C69C00C6CEBD00EFC6
            A500EFCEAD00FFD6A500FBD3A900E7C6B500F7CEB500F7DEB500FFDEB500F7D6
            BD00F7DEBD00FFE7BD008CC6CE009CC6C6009CCECE008CC6D60094CED6009CCE
            D60094CEDE00A5C6C600ADCED600A5D6DE00B5D6DE00C6D6CE00DEDEC600CEDE
            D600EFD6C600EFDEC600EFDED600CEE7DE00D6E7DE00FFE7C600F7E7CE00FFE7
            CE00FFEFCE00EFE7D600EFEFDE00FFEFD600F7E7DE00F7EFDE00FFEFDE00C6DE
            E700CEE7E700F7EFEF00EFF7EF00F7F7E700FFF7E700F7F7EF00FFF7EF00F7F7
            F700FFFFF700FFFFFF0000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            00006D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D
            6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D160D0C1015776D6D6D6D6D6D
            6D6D6D6D6D6D6D6D6D6D6D6D211B1A0102040E1419776D6D6D6D6D6D6D6D6D6D
            6D6D6D6D221D5D5D31230903060C1117776D6D6D6D6D6D6D6D6D6D6D241F87A8
            8E8463512C2008050C146D6D6D6D6D6D6D6D6D6D251F87A7A591918E857C5531
            20026D6D6D6D6D6D6D6D6D6D29268CA7A590908D8E8980622D026D6D6D6D6D6D
            6D6D6D6D29268FABA79E99868E8361622F026D6D6D6D6D6D6D6D6D6D2A2EA6AE
            A99270938E6560642F026D6D6D6D6D6D6D6D6D6D2A31ACAA94706E7388000F5C
            2F026D6D6D6D6D6D6D6D6D6D2B45B39C71979A6E860F0B122F026D6D6D6D6D6D
            6D6D6D6D3C45B5AF9BAA9F70938A13690A446D6D6D6D6D6D6D6D6D6D3C49B8B5
            B3AEA99570A613684641446D6D6D6D6D6D6D6D6D3F52B9B6B6B4AD9C729D8A18
            7D5943446D6D6D6D6D6D6D6D3D5AB9B8B6B6B4A47492AD478A825743446D6D6D
            6D6D6D6D3D5EB9B9B8B6B6B398729F87478A825941446D6D6D6D6D6D3D5EB9B9
            B9B8B8B6B096A37E27478A815830446D6D6D6D6D3D457B8BA2B1B7B8B7B2B37E
            2702478A796F67666D6D6D6D3E1C1E3A3B485B7A7FA0AC7E27026D47756B6B67
            666D6D6D563835323233331E373A424022026D6D6A766C6B6D6D6D6D4F505F54
            4B4B4A393634323207076D6D6D6A6A6D6D6D6D6D6D6D6D4F50784E4D4C53544B
            286D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D
            6D6D}
          Transparent = True
        end
        inherited pnlTitleBottomLine: TADGUIxFormsPanel
          Top = 36
          Width = 592
        end
      end
    end
  end
end
