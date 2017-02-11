object fmLogin: TfmLogin
  Left = 320
  Top = 302
  BorderStyle = bsDialog
  Caption = 'Идентификация'
  ClientHeight = 163
  ClientWidth = 301
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pn: TPanel
    Left = 0
    Top = 0
    Width = 301
    Height = 122
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 0
    object GroupBox1: TGroupBox
      Left = 5
      Top = 5
      Width = 291
      Height = 112
      Align = alClient
      Caption = 'Введите свои данные'
      TabOrder = 0
      object Label3: TLabel
        Left = 120
        Top = 16
        Width = 32
        Height = 13
        Caption = 'Label3'
      end
      object Panel2: TPanel
        Left = 2
        Top = 15
        Width = 287
        Height = 95
        Align = alClient
        BevelOuter = bvNone
        BevelWidth = 5
        BorderWidth = 5
        TabOrder = 0
        object lbUser: TLabel
          Left = 15
          Top = 7
          Width = 76
          Height = 13
          Caption = 'Пользователь:'
        end
        object lbPass: TLabel
          Left = 50
          Top = 37
          Width = 41
          Height = 13
          Caption = 'Пароль:'
        end
        object im: TImage
          Left = 11
          Top = 27
          Width = 32
          Height = 32
          Hint = 'test'
          ParentShowHint = False
          Picture.Data = {
            055449636F6E0000010001002020100000000000E80200001600000028000000
            2000000040000000010004000000000000020000000000000000000000000000
            0000000000000000000080000080000000808000800000008000800080800000
            C0C0C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000
            FFFFFF0000000000000000000000000000000000000000000000077000000000
            00000000000000000000F7870000000000000000000000077008078700000000
            0000000000000887770087870000000000000000000008F7878F778700000000
            00008000000008F78708F787000000000008B330000000078700078700000000
            0800BB80000000878700878700000000833BB80000008F77878F778700000000
            8BBB8030000008F7878F7787000000800BB80300000000078708F78700000833
            BB803000000000878708F78800008BBBB803000000008F77878F77F800008BBB
            8030000000008F7788F77F778000BBB803000000000008F78F77F000000BBB80
            30000000000008F8F7700888888BB8030000000000008F8F77088BBBBBBB8030
            000000000008F78F708BBBBBBBB7B30000000000008F778F70BBBB7B7B7B7300
            0000000008F77F8F0BBBB0B0B7B7B300000000008F77F78F8BBBBB0B0B7B7300
            000000008F777F788BBBBBB0B0B7B300000000008F77F7008BBB880B0B0B7300
            000000008F77708F8BB00770B0B73000000000008F77F0878BB00070BBB73000
            0000000008F7708808B00800BB73000000000000008F77000788000BB3300000
            000000000008FFF0878077773000000000000000000088808880888800000000
            0000000000000000800080000000000000000000000000000000000000000000
            00000000FFF9FFFFFFF0FFFFFE607FFFFC007FFFF8007FFFF8007FF1F8007FE0
            FC107F80F8007F00F0007F00F8007C01FC007803F8007007F000700FF000201F
            F800003FF800007FF00000FFE00001FFC00001FF800001FF000001FF000001FF
            000001FF000803FF000403FF800207FFC0000FFFE0001FFFF0107FFFFE73FFFF
            FF07FFFF}
          ShowHint = True
        end
        object lbApp: TLabel
          Left = 24
          Top = 67
          Width = 67
          Height = 13
          Caption = 'Приложение:'
        end
        object edPass: TEdit
          Left = 101
          Top = 34
          Width = 175
          Height = 21
          MaxLength = 20
          PasswordChar = '*'
          TabOrder = 1
        end
        object cbUsers: TComboBox
          Left = 101
          Top = 4
          Width = 175
          Height = 21
          ItemHeight = 13
          MaxLength = 20
          TabOrder = 0
          OnChange = cbUsersChange
        end
        object cbApp: TComboBox
          Left = 101
          Top = 64
          Width = 175
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          MaxLength = 20
          TabOrder = 2
          OnEnter = cbAppEnter
        end
      end
    end
  end
  object pnBottom: TPanel
    Left = 0
    Top = 122
    Width = 301
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Panel3: TPanel
      Left = 116
      Top = 0
      Width = 185
      Height = 41
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object bibOk: TButton
        Left = 19
        Top = 8
        Width = 75
        Height = 25
        Caption = 'OK'
        Default = True
        Enabled = False
        TabOrder = 0
        OnClick = bibOkClick
      end
      object bibCancel: TButton
        Left = 102
        Top = 8
        Width = 75
        Height = 25
        Cancel = True
        Caption = 'Отмена'
        ModalResult = 2
        TabOrder = 1
      end
    end
  end
end
