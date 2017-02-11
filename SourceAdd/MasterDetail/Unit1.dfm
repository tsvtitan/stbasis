object Form1: TForm1
  Left = 342
  Top = 112
  Width = 783
  Height = 540
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object grdMaster: TDBGrid
    Left = 80
    Top = 24
    Width = 521
    Height = 177
    DataSource = dsMaster
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object grdDetail: TDBGrid
    Left = 80
    Top = 216
    Width = 521
    Height = 233
    DataSource = dsDetail
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object dsMaster: TDataSource
    DataSet = qrMaster
    Left = 16
    Top = 32
  end
  object dsDetail: TDataSource
    DataSet = qrDetail
    Left = 16
    Top = 104
  end
  object IBDatabase1: TIBDatabase
    Connected = True
    DatabaseName = 'E:\Work\1STBASIS\Data\STBASIS.GDB'
    Params.Strings = (
      'user_name=adminuser'
      'password=adminuser'
      'lc_ctype=WIN1251')
    LoginPrompt = False
    DefaultTransaction = IBTransaction1
    IdleTimer = 0
    SQLDialect = 3
    TraceFlags = []
    Left = 640
    Top = 24
  end
  object IBTransaction1: TIBTransaction
    Active = True
    DefaultDatabase = IBDatabase1
    AutoStopAction = saNone
    Left = 640
    Top = 72
  end
  object qrMaster: TIBQuery
    Database = IBDatabase1
    Transaction = IBTransaction1
    Active = True
    BufferChunks = 50
    CachedUpdates = False
    ParamCheck = False
    SQL.Strings = (
      'Select * from nomenclaturegroup')
    Left = 208
    Top = 104
  end
  object qrDetail: TIBQuery
    Database = IBDatabase1
    Transaction = IBTransaction1
    Active = True
    BufferChunks = 50
    CachedUpdates = False
    DataSource = dsMaster
    SQL.Strings = (
      'select * from nomenclature'
      'where nomenclaturegroup_id=:nomenclaturegroup_id')
    Left = 208
    Top = 256
    ParamData = <
      item
        DataType = ftInteger
        Name = 'NOMENCLATUREGROUP_ID'
        ParamType = ptUnknown
      end>
  end
end
