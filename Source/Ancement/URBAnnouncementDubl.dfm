inherited fmRBAnnouncementDubl: TfmRBAnnouncementDubl
  Left = 116
  Top = 137
  Width = 667
  Height = 503
  Caption = 'Дублированные объявления'
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000000000000000000000000000000000000000000999999900000
    00009009009000000FF09999999000000F009009009000FF0FF09999999000F0
    0F009009009000FF0FF09999999000F00F000000000000FF0FFFFFFF000000F0
    00000000000000FFFFFFF000000000000000000000000000000000000000FFFF
    0000FFFF0000FE000000FE000000F0000000F000000080000000800000008000
    000080000000800000008007000080070000803F0000803F0000FFFF0000}
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBackGrid: TPanel
    Width = 659
    Height = 413
    inherited pnBut: TPanel
      Left = 575
      Height = 413
      inherited pnModal: TPanel
        Top = 177
        Height = 236
        object Label2: TLabel [0]
          Left = 65
          Top = 191
          Width = 14
          Height = 20
          Caption = '%'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          Visible = False
        end
        inherited bibFilter: TButton
          Top = 117
          Visible = False
        end
        inherited bibView: TButton
          Top = 53
          OnClick = bibViewClick
        end
        inherited bibRefresh: TButton
          Top = 21
        end
        inherited bibAdjust: TButton
          Top = 85
        end
        inherited bibPreview: TButton
          TabOrder = 6
        end
        object CBtreeheadingnameheading: TCheckBox
          Left = 5
          Top = 162
          Width = 97
          Height = 17
          Caption = 'Уч.рубрики'
          Checked = True
          State = cbChecked
          TabOrder = 4
          Visible = False
          OnClick = CBtreeheadingnameheadingClick
        end
        object SEPercent: TSpinEdit
          Left = 8
          Top = 192
          Width = 49
          Height = 22
          MaxValue = 100
          MinValue = 1
          TabOrder = 5
          Value = 100
          Visible = False
          OnChange = SEPercentChange
        end
      end
      inherited pnSQL: TPanel
        Height = 177
        object lbNumRelease: TLabel [0]
          Left = 9
          Top = -1
          Width = 41
          Height = 13
          Caption = 'Выпуск:'
        end
        inherited bibAdd: TButton
          Top = 89
          Visible = False
          OnClick = bibAddClick
        end
        inherited bibChange: TButton
          Top = 89
          Visible = False
          OnClick = bibChangeClick
        end
        inherited bibDel: TButton
          Top = 145
          OnClick = bibDelClick
        end
        object bibFind: TButton
          Left = 3
          Top = 45
          Width = 75
          Height = 25
          Caption = 'Поиск'
          TabOrder = 3
          OnClick = bibFindClick
        end
        object bibNextDubl: TButton
          Left = 3
          Top = 77
          Width = 75
          Height = 25
          Caption = 'Следующие'
          Enabled = False
          TabOrder = 4
          OnClick = bibNextDublClick
        end
        object bibPrevDubl: TButton
          Left = 3
          Top = 111
          Width = 75
          Height = 25
          Caption = 'Предыдущие'
          Enabled = False
          TabOrder = 5
          OnClick = bibPrevDublClick
        end
        object edNumRelease: TEdit
          Left = 3
          Top = 18
          Width = 51
          Height = 21
          Color = clBtnFace
          MaxLength = 100
          ReadOnly = True
          TabOrder = 6
        end
        object bibNumRelease: TButton
          Left = 57
          Top = 18
          Width = 21
          Height = 21
          Hint = 'Выбрать'
          Caption = '...'
          TabOrder = 7
          OnClick = bibNumReleaseClick
        end
      end
    end
    inherited pnGrid: TPanel
      Width = 575
      Height = 413
      object pnTreePath: TPanel
        Left = 5
        Top = 380
        Width = 565
        Height = 28
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 0
        object lbTreePath: TLabel
          Left = 8
          Top = 9
          Width = 94
          Height = 13
          Anchors = [akLeft, akBottom]
          Caption = 'Путь рубрикатора:'
        end
        object edTreePath: TEdit
          Left = 112
          Top = 5
          Width = 227
          Height = 21
          Anchors = [akLeft, akBottom]
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 0
        end
      end
    end
  end
  inherited pnFind: TPanel
    Width = 659
    inherited edSearch: TEdit
      Left = 48
      Anchors = [akLeft, akTop, akBottom]
    end
  end
  inherited pnBottom: TPanel
    Top = 441
    Width = 659
    inherited bibOk: TButton
      Left = 496
    end
    inherited DBNav: TDBNavigator
      DataSource = DS1
    end
    inherited bibClose: TButton
      Left = 578
    end
  end
  object qr: TIBQuery
    BufferChunks = 50
    CachedUpdates = False
    ParamCheck = False
    SQL.Strings = (
      
        'select count(announcement.announcement_id),contactphone, homepho' +
        'ne, workphone'
      '        from ANNOUNCEMENT'
      '        group by contactphone, homephone, workphone')
    Left = 272
    Top = 289
  end
  object IBTransaction: TIBTransaction
    Active = False
    AutoStopAction = saNone
    Left = 312
    Top = 281
  end
  object qrFind: TIBQuery
    BufferChunks = 100000
    CachedUpdates = False
    ParamCheck = False
    UniDirectional = True
    Left = 264
    Top = 209
  end
  object IBTrFind: TIBTransaction
    Active = False
    AutoStopAction = saNone
    Left = 312
    Top = 209
  end
  object DSFind: TDataSource
    Left = 88
    Top = 225
  end
  object DS1: TDataSource
    DataSet = MemDS
    Left = 48
    Top = 273
  end
  object MemDS: TRxMemoryData
    FieldDefs = <>
    AfterScroll = MemDSAfterScroll
    Left = 80
    Top = 169
  end
  object MemoryTable1: TMemoryTable
    SessionName = 'Default'
    TableName = 'DublList'
    Left = 168
    Top = 185
  end
  object ds2: TDataSource
    Left = 80
    Top = 73
  end
  object IBQr: TQuery
    Left = 152
    Top = 73
  end
  object ds3: TDataSource
    Left = 24
    Top = 153
  end
end
