inherited FMPosting: TFMPosting
  Left = 204
  Top = 127
  Width = 467
  Height = 341
  Caption = 'Журнал проводок'
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited BAdd: TButton
    Visible = False
  end
  inherited BEdit: TButton
    Visible = False
  end
  inherited BDel: TButton
    Visible = False
  end
  inherited BAcc: TButton
    Visible = False
  end
  inherited DBNavigator: TDBNavigator
    Hints.Strings = ()
  end
  inherited DBGrid: TDBGrid
    Height = 120
  end
  object PHeader: TPanel [13]
    Left = 4
    Top = 156
    Width = 365
    Height = 60
    TabOrder = 11
    object Label1: TLabel
      Left = 4
      Top = 5
      Width = 51
      Height = 13
      Caption = 'Документ'
    end
    object Label2: TLabel
      Left = 4
      Top = 21
      Width = 32
      Height = 13
      Caption = '№ док'
    end
    object Label3: TLabel
      Left = 64
      Top = 21
      Width = 38
      Height = 13
      Caption = '№ пров'
    end
    object Label4: TLabel
      Left = 5
      Top = 37
      Width = 26
      Height = 13
      Caption = 'Дата'
    end
    object Label5: TLabel
      Left = 64
      Top = 37
      Width = 33
      Height = 13
      Caption = 'Время'
    end
    object Label6: TLabel
      Left = 184
      Top = 5
      Width = 32
      Height = 13
      Caption = 'Дебет'
    end
    object Label7: TLabel
      Left = 184
      Top = 17
      Width = 53
      Height = 13
      Caption = 'Субконто1'
    end
    object Label8: TLabel
      Left = 184
      Top = 29
      Width = 53
      Height = 13
      Caption = 'Субконто2'
    end
    object Label9: TLabel
      Left = 184
      Top = 41
      Width = 53
      Height = 13
      Caption = 'Субконто3'
    end
    object Label10: TLabel
      Left = 336
      Top = 41
      Width = 53
      Height = 13
      Caption = 'Субконто3'
    end
    object Label11: TLabel
      Left = 336
      Top = 29
      Width = 53
      Height = 13
      Caption = 'Субконто2'
    end
    object Label12: TLabel
      Left = 336
      Top = 17
      Width = 53
      Height = 13
      Caption = 'Субконто1'
    end
    object Label13: TLabel
      Left = 336
      Top = 5
      Width = 36
      Height = 13
      Caption = 'Кредит'
    end
    object Label14: TLabel
      Left = 472
      Top = 2
      Width = 50
      Height = 13
      Caption = 'Операция'
    end
    object Label15: TLabel
      Left = 472
      Top = 14
      Width = 50
      Height = 13
      Caption = 'Проводка'
    end
    object Label16: TLabel
      Left = 473
      Top = 27
      Width = 34
      Height = 13
      Caption = 'Кол-во'
    end
    object Label17: TLabel
      Left = 472
      Top = 43
      Width = 34
      Height = 13
      Caption = 'Сумма'
    end
    object Label18: TLabel
      Left = 529
      Top = 28
      Width = 38
      Height = 13
      Caption = 'Валюта'
    end
  end
  object PData: TPanel [14]
    Left = 4
    Top = 216
    Width = 365
    Height = 60
    TabOrder = 12
    object LDok: TLabel
      Left = 4
      Top = 5
      Width = 3
      Height = 13
      Constraints.MaxWidth = 177
      ParentShowHint = False
      ShowHint = True
    end
    object LNumDok: TLabel
      Left = 4
      Top = 21
      Width = 3
      Height = 13
      Constraints.MaxWidth = 57
      ParentShowHint = False
      ShowHint = True
    end
    object LNumPost: TLabel
      Left = 64
      Top = 21
      Width = 3
      Height = 13
      Constraints.MaxWidth = 117
      ParentShowHint = False
      ShowHint = True
    end
    object LDate: TLabel
      Left = 4
      Top = 37
      Width = 3
      Height = 13
      Constraints.MaxWidth = 57
      ParentShowHint = False
      ShowHint = True
    end
    object LTime: TLabel
      Left = 64
      Top = 37
      Width = 3
      Height = 13
      Constraints.MaxWidth = 117
      ParentShowHint = False
      ShowHint = True
    end
    object LDebit: TLabel
      Left = 184
      Top = 5
      Width = 3
      Height = 13
      Constraints.MaxWidth = 149
      ParentShowHint = False
      ShowHint = True
    end
    object LDSub1: TLabel
      Left = 184
      Top = 17
      Width = 3
      Height = 13
      Constraints.MaxWidth = 149
      ParentShowHint = False
      ShowHint = True
    end
    object LDSub2: TLabel
      Left = 184
      Top = 29
      Width = 3
      Height = 13
      Constraints.MaxWidth = 149
      ParentShowHint = False
      ShowHint = True
    end
    object LDSub3: TLabel
      Left = 184
      Top = 41
      Width = 3
      Height = 13
      Constraints.MaxWidth = 149
      ParentShowHint = False
      ShowHint = True
    end
    object LKSub3: TLabel
      Left = 336
      Top = 41
      Width = 3
      Height = 13
      Constraints.MaxWidth = 133
      ParentShowHint = False
      ShowHint = True
    end
    object LKSub2: TLabel
      Left = 336
      Top = 29
      Width = 3
      Height = 13
      Constraints.MaxWidth = 133
      ParentShowHint = False
      ShowHint = True
    end
    object LKSub1: TLabel
      Left = 336
      Top = 17
      Width = 3
      Height = 13
      Constraints.MaxWidth = 133
      ParentShowHint = False
      ShowHint = True
    end
    object LKredit: TLabel
      Left = 336
      Top = 5
      Width = 3
      Height = 13
      Constraints.MaxWidth = 133
      ParentShowHint = False
      ShowHint = True
    end
    object LOper: TLabel
      Left = 472
      Top = 5
      Width = 3
      Height = 13
      ParentShowHint = False
      ShowHint = True
    end
    object LPost: TLabel
      Left = 472
      Top = 17
      Width = 3
      Height = 13
      ParentShowHint = False
      ShowHint = True
    end
    object LCount: TLabel
      Left = 472
      Top = 30
      Width = 3
      Height = 13
      ParentShowHint = False
      ShowHint = True
    end
    object LSum: TLabel
      Left = 472
      Top = 42
      Width = 3
      Height = 13
      ParentShowHint = False
      ShowHint = True
    end
    object LCur: TLabel
      Left = 529
      Top = 28
      Width = 3
      Height = 13
      ParentShowHint = False
      ShowHint = True
    end
  end
  inherited DataSource: TDataSource
    Top = 112
  end
  inherited IBTable: TIBQuery
    Database = Form1.IBDatabase
    Transaction = Form1.IBTransaction
    AfterScroll = IBTableAfterScroll
    SQL.Strings = (
      
        'select DOK_NAME,MP_DOCUMENTID,MP_IDINDOCUMENT,MP_DATE,MP_TIME,P1' +
        '.PA_GROUPID, P2.PA_GROUPID,MP_CONTENTSOPERA,MP_CONTENTSPOSTI,MP_' +
        'COUNT,MP_SUMMA from MAGAZINEPOSTINGS,PLANACCOUNTS P1, PLANACCOUN' +
        'TS P2, DOCUMENTS where MP_DEBETID=P1.PA_ID AND MP_CREDITID=P2.PA' +
        '_ID AND MP_DOKUMENT=DOK_ID ')
    Left = 88
    Top = 112
  end
  inherited IBTransaction: TIBTransaction
    Left = 216
    Top = 104
  end
end
