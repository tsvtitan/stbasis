inherited frmMainConnectionDefBase: TfrmMainConnectionDefBase
  OldCreateOrder = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    inherited pnlBorder: TPanel
      inherited pnlMain: TPanel
        object pnlConnection: TPanel
          Left = 0
          Top = 0
          Width = 618
          Height = 57
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object lblUseConnectionDef: TLabel
            Left = 11
            Top = 10
            Width = 127
            Height = 13
            Caption = 'Use Connection Definition:'
          end
          object cbDB: TComboBox
            Left = 11
            Top = 25
            Width = 150
            Height = 21
            BevelInner = bvSpace
            BevelKind = bkFlat
            Style = csDropDownList
            Ctl3D = True
            ItemHeight = 13
            ParentCtl3D = False
            TabOrder = 0
            OnClick = cbDBClick
          end
        end
      end
    end
  end
end
