object FTable: TFTable
  Left = 329
  Top = 269
  Width = 474
  Height = 344
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  Caption = 'FTable'
  Color = clBtnFace
  Constraints.MinHeight = 330
  Constraints.MinWidth = 300
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefaultSizeOnly
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object LFind: TLabel
    Left = 8
    Top = 12
    Width = 31
    Height = 13
    Caption = 'Найти'
  end
  object LSelect: TLabel
    Left = 168
    Top = 291
    Width = 80
    Height = 13
    Caption = 'Всего выбрано:'
  end
  object BAdd: TButton
    Left = 382
    Top = 32
    Width = 75
    Height = 25
    Caption = 'Добавить'
    TabOrder = 2
    OnClick = BAddClick
  end
  object BEdit: TButton
    Left = 383
    Top = 64
    Width = 75
    Height = 25
    Caption = 'Изменить'
    TabOrder = 3
    OnClick = BEditClick
  end
  object BDel: TButton
    Left = 383
    Top = 96
    Width = 75
    Height = 25
    Caption = 'Удалить'
    TabOrder = 4
    OnClick = BDelClick
  end
  object BRef: TButton
    Left = 383
    Top = 144
    Width = 75
    Height = 25
    Caption = 'Обновить'
    TabOrder = 5
    OnClick = BRefClick
  end
  object BAcc: TButton
    Left = 383
    Top = 176
    Width = 75
    Height = 25
    Caption = 'Подробнее'
    TabOrder = 6
    OnClick = BAccClick
  end
  object BFilter: TButton
    Left = 383
    Top = 208
    Width = 75
    Height = 25
    Caption = 'Фильтр'
    TabOrder = 7
  end
  object BTun: TButton
    Left = 383
    Top = 240
    Width = 75
    Height = 25
    Caption = 'Настройка'
    TabOrder = 8
  end
  object BClose: TButton
    Left = 383
    Top = 288
    Width = 75
    Height = 25
    Caption = 'Закрыть'
    TabOrder = 9
    OnClick = BCloseClick
  end
  object EFind: TEdit
    Left = 48
    Top = 8
    Width = 321
    Height = 21
    TabOrder = 0
    OnKeyDown = EFindKeyDown
    OnKeyUp = EFindKeyUp
  end
  object DBNavigator: TDBNavigator
    Left = 8
    Top = 288
    Width = 144
    Height = 18
    DataSource = DataSource
    VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
    TabOrder = 10
  end
  object DBGrid: TDBGrid
    Left = 3
    Top = 33
    Width = 366
    Height = 248
    DataSource = DataSource
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete]
    ReadOnly = True
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDblClick = DBGridDblClick
    OnTitleClick = DBGridTitleClick
    Columns = <
      item
        Expanded = False
        FieldName = 'ICO_DATE'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ICO_TIME'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DOK_NAME'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PA_GROUPID'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PA_GROUPID1'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CB_TEXT'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CA_TEXT'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'SNAME'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'SNAME1'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ICO_DEBIT'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CO_KREDIT'
        Visible = True
      end>
  end
  object DataSource: TDataSource
    DataSet = IBTable
    Left = 144
    Top = 144
  end
  object IBTable: TIBQuery
    BufferChunks = 1000
    CachedUpdates = False
    SQL.Strings = (
      
        'select INC.ICO_DATE,INC.ICO_TIME,D.DOK_NAME,P1.PA_GROUPID,P2.PA_' +
        'GROUPID,CB_TEXT,CA_TEXT,E1.SNAME,E2.SNAME,ICO_DEBIT,CO_KREDIT'
      
        'from INCASHORDERS INC, DOCUMENTS D, PLANACCOUNTS P1, PLANACCOUNT' +
        'S P2, CASHBASIS, CASHAPPEND, EMP E1, EMP E2'
      
        'where INC.DOK_ID=D.DOK_ID AND INC.ICO_KINDKASSA=P1.PA_ID AND INC' +
        '.ICO_IDKORACCOUNT=P2.PA_ID AND ICO_IDBASIS=CB_ID AND ICO_IDAPPEN' +
        'D=CA_ID AND ICO_IDCASHIER=E1.EMP_ID AND ICO_EMP_ID=E2.EMP_ID;')
    Left = 144
    Top = 192
  end
  object IBTransaction: TIBTransaction
    Active = False
    DefaultDatabase = Form1.IBDatabase
    Left = 208
    Top = 192
  end
end
