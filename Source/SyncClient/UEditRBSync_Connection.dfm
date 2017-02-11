inherited fmEditRBSync_Connection: TfmEditRBSync_Connection
  Left = 397
  Top = 231
  Caption = 'fmEditRBSync_Connection'
  ClientHeight = 430
  ClientWidth = 302
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object lbDisplayName: TLabel [0]
    Left = 13
    Top = 29
    Width = 79
    Height = 13
    Alignment = taRightJustify
    Caption = 'Наименование:'
    FocusControl = edDisplayName
  end
  object lbConnectionType: TLabel [1]
    Left = 7
    Top = 55
    Width = 85
    Height = 13
    Alignment = taRightJustify
    Caption = 'Тип соединения:'
    FocusControl = cmbConnectionType
  end
  object lbServerName: TLabel [2]
    Left = 52
    Top = 81
    Width = 40
    Height = 13
    Alignment = taRightJustify
    Caption = 'Сервер:'
    FocusControl = edServerName
  end
  object lbServerPort: TLabel [3]
    Left = 222
    Top = 81
    Width = 28
    Height = 13
    Alignment = taRightJustify
    Caption = 'Порт:'
    FocusControl = edServerPort
  end
  object lbOfficeName: TLabel [4]
    Left = 32
    Top = 107
    Width = 60
    Height = 13
    Alignment = taRightJustify
    Caption = 'Имя офиса:'
    FocusControl = edOfficeName
  end
  object lbOfficeKey: TLabel [5]
    Left = 28
    Top = 133
    Width = 64
    Height = 13
    Alignment = taRightJustify
    Caption = 'Ключ офиса:'
    FocusControl = edOfficeKey
  end
  object lbRetryCount: TLabel [6]
    Left = 68
    Top = 355
    Width = 48
    Height = 13
    Alignment = taRightJustify
    Caption = 'Попыток:'
    FocusControl = edRetryCount
  end
  object lbPriority: TLabel [7]
    Left = 182
    Top = 355
    Width = 57
    Height = 13
    Alignment = taRightJustify
    Caption = 'Приоритет:'
    FocusControl = edPriority
  end
  inherited pnBut: TPanel
    Top = 392
    Width = 302
    TabOrder = 9
    inherited Panel2: TPanel
      Left = 117
    end
  end
  inherited cbInString: TCheckBox
    Left = 10
    Top = 374
    TabOrder = 8
  end
  object edDisplayName: TEdit [10]
    Left = 98
    Top = 26
    Width = 197
    Height = 21
    MaxLength = 100
    TabOrder = 0
    OnChange = edDisplayNameChange
  end
  object chbUsed: TCheckBox [11]
    Left = 14
    Top = 5
    Width = 195
    Height = 17
    Caption = 'Использовать для синхронизации'
    Checked = True
    State = cbChecked
    TabOrder = 7
    OnClick = chbUsedClick
  end
  object cmbConnectionType: TComboBox [12]
    Left = 98
    Top = 52
    Width = 197
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
    OnChange = cmbConnectionTypeChange
    Items.Strings = (
      'Прямое соединение'
      'Удаленный доступ'
      'Модем')
  end
  object edServerName: TEdit [13]
    Left = 98
    Top = 78
    Width = 116
    Height = 21
    MaxLength = 100
    TabOrder = 2
    OnChange = edDisplayNameChange
  end
  object edServerPort: TEdit [14]
    Left = 256
    Top = 78
    Width = 39
    Height = 21
    MaxLength = 100
    TabOrder = 3
    OnChange = edDisplayNameChange
  end
  object edOfficeName: TEdit [15]
    Left = 98
    Top = 104
    Width = 197
    Height = 21
    MaxLength = 100
    TabOrder = 4
    OnChange = edDisplayNameChange
  end
  object edOfficeKey: TEdit [16]
    Left = 98
    Top = 130
    Width = 197
    Height = 21
    MaxLength = 100
    TabOrder = 5
    OnChange = edDisplayNameChange
  end
  object grbConnection: TGroupBox [17]
    Left = 7
    Top = 154
    Width = 289
    Height = 192
    TabOrder = 6
    object pnConnection: TPanel
      Left = 2
      Top = 15
      Width = 285
      Height = 175
      Align = alClient
      BevelOuter = bvNone
      BorderWidth = 3
      TabOrder = 0
      object pcConnection: TPageControl
        Left = 3
        Top = 3
        Width = 279
        Height = 169
        ActivePage = tsModem
        Align = alClient
        Style = tsButtons
        TabOrder = 0
        object tsDirect: TTabSheet
          Caption = 'tsDirect'
          TabVisible = False
          object Label1: TLabel
            Left = 0
            Top = 0
            Width = 233
            Height = 26
            Align = alTop
            Alignment = taCenter
            Caption = 
              'Данный тип соединения не применяется для удаленных, модемных или' +
              ' VPN-соединений'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            Layout = tlCenter
            WordWrap = True
          end
          object Label2: TLabel
            Left = 8
            Top = 32
            Width = 91
            Height = 13
            Caption = 'Прокси-сервер'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Bevel1: TBevel
            Left = 104
            Top = 39
            Width = 161
            Height = 3
            Shape = bsTopLine
          end
          object lbProxyName: TLabel
            Left = 18
            Top = 55
            Width = 40
            Height = 13
            Alignment = taRightJustify
            Caption = 'Сервер:'
            FocusControl = edProxyName
          end
          object lbProxyPort: TLabel
            Left = 191
            Top = 55
            Width = 28
            Height = 13
            Alignment = taRightJustify
            Caption = 'Порт:'
            FocusControl = edProxyPort
          end
          object lbProxyUserName: TLabel
            Left = 24
            Top = 82
            Width = 76
            Height = 13
            Alignment = taRightJustify
            Caption = 'Пользователь:'
            FocusControl = edProxyUserName
          end
          object lbProxyUserPass: TLabel
            Left = 59
            Top = 108
            Width = 41
            Height = 13
            Alignment = taRightJustify
            Caption = 'Пароль:'
            FocusControl = edProxyUserPass
          end
          object lbProxyByPass: TLabel
            Left = 9
            Top = 134
            Width = 91
            Height = 13
            Alignment = taRightJustify
            Caption = 'Не использовать:'
            FocusControl = edProxyByPass
          end
          object edProxyName: TEdit
            Left = 64
            Top = 52
            Width = 116
            Height = 21
            MaxLength = 100
            TabOrder = 0
            OnChange = edDisplayNameChange
          end
          object edProxyPort: TEdit
            Left = 225
            Top = 52
            Width = 39
            Height = 21
            MaxLength = 100
            TabOrder = 1
            OnChange = edDisplayNameChange
          end
          object edProxyUserName: TEdit
            Left = 106
            Top = 78
            Width = 159
            Height = 21
            MaxLength = 100
            TabOrder = 2
            OnChange = edDisplayNameChange
          end
          object edProxyUserPass: TEdit
            Left = 106
            Top = 104
            Width = 159
            Height = 21
            MaxLength = 100
            PasswordChar = '*'
            TabOrder = 3
            OnChange = edDisplayNameChange
          end
          object edProxyByPass: TEdit
            Left = 106
            Top = 130
            Width = 159
            Height = 21
            MaxLength = 100
            TabOrder = 4
            OnChange = edDisplayNameChange
          end
        end
        object tsRemote: TTabSheet
          Caption = 'tsRemote'
          ImageIndex = 1
          TabVisible = False
          object lbRemoteName: TLabel
            Left = 8
            Top = 57
            Width = 64
            Height = 13
            Alignment = taRightJustify
            Caption = 'Соединение:'
            Enabled = False
            FocusControl = cmbRemoteName
          end
          object Label3: TLabel
            Left = 0
            Top = 0
            Width = 233
            Height = 26
            Align = alTop
            Alignment = taCenter
            Caption = 
              'Данный тип соединения не применяется для прямых и выделенных сое' +
              'динений'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            Layout = tlCenter
            WordWrap = True
          end
          object chbInetAuto: TCheckBox
            Left = 7
            Top = 35
            Width = 250
            Height = 17
            Caption = 'Автоматическое определение настроек'
            Checked = True
            State = cbChecked
            TabOrder = 0
            OnClick = chbInetAutoClick
          end
          object cmbRemoteName: TComboBox
            Left = 8
            Top = 76
            Width = 257
            Height = 21
            Style = csDropDownList
            Color = clBtnFace
            Enabled = False
            ItemHeight = 0
            TabOrder = 1
          end
        end
        object tsModem: TTabSheet
          Caption = 'tsModem'
          ImageIndex = 2
          TabVisible = False
          object Label4: TLabel
            Left = 0
            Top = 0
            Width = 271
            Height = 26
            Align = alTop
            Alignment = taCenter
            Caption = 
              'Данный тип соединения не применяется для прямых и выделенных сое' +
              'динений'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            Layout = tlCenter
            WordWrap = True
          end
          object lbModemUserName: TLabel
            Left = 21
            Top = 43
            Width = 76
            Height = 13
            Alignment = taRightJustify
            Caption = 'Пользователь:'
            FocusControl = edModemUserName
          end
          object lbModemUserPass: TLabel
            Left = 56
            Top = 69
            Width = 41
            Height = 13
            Alignment = taRightJustify
            Caption = 'Пароль:'
            FocusControl = edModemUserPass
          end
          object lbModemDomain: TLabel
            Left = 59
            Top = 95
            Width = 38
            Height = 13
            Alignment = taRightJustify
            Caption = 'Домен:'
            FocusControl = edModemDomain
          end
          object lbModemPhone: TLabel
            Left = 49
            Top = 121
            Width = 48
            Height = 13
            Alignment = taRightJustify
            Caption = 'Телефон:'
            FocusControl = edModemPhone
          end
          object edModemUserName: TEdit
            Left = 103
            Top = 39
            Width = 159
            Height = 21
            MaxLength = 100
            TabOrder = 0
            OnChange = edDisplayNameChange
          end
          object edModemUserPass: TEdit
            Left = 103
            Top = 65
            Width = 159
            Height = 21
            MaxLength = 100
            PasswordChar = '*'
            TabOrder = 1
            OnChange = edDisplayNameChange
          end
          object edModemDomain: TEdit
            Left = 103
            Top = 91
            Width = 159
            Height = 21
            MaxLength = 100
            TabOrder = 2
            OnChange = edDisplayNameChange
          end
          object edModemPhone: TEdit
            Left = 103
            Top = 117
            Width = 159
            Height = 21
            MaxLength = 100
            TabOrder = 3
            OnChange = edDisplayNameChange
          end
        end
      end
    end
  end
  object edRetryCount: TEdit [18]
    Left = 122
    Top = 352
    Width = 34
    Height = 21
    TabOrder = 10
    Text = '1'
    OnChange = edDisplayNameChange
  end
  object udRetryCount: TUpDown [19]
    Left = 156
    Top = 352
    Width = 15
    Height = 21
    Associate = edRetryCount
    Min = 1
    Max = 10
    Position = 1
    TabOrder = 11
    Wrap = False
  end
  object edPriority: TEdit [20]
    Left = 246
    Top = 352
    Width = 34
    Height = 21
    TabOrder = 12
    Text = '1'
    OnChange = edDisplayNameChange
  end
  object udPriority: TUpDown [21]
    Left = 280
    Top = 352
    Width = 15
    Height = 21
    Associate = edPriority
    Min = 1
    Max = 10
    Position = 1
    TabOrder = 13
    Wrap = False
  end
  inherited IBTran: TIBTransaction
    Left = 26
    Top = 250
  end
end
