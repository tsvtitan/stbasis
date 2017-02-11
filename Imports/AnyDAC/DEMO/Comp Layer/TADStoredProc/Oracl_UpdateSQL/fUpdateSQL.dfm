inherited frmUpdateSQL: TfrmUpdateSQL
  Left = 322
  Top = 251
  Caption = 'Posting updates using TADUpdateSQL & StoredProc'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    inherited pnlBorder: TPanel
      inherited pnlTitle: TPanel
        inherited lblTitle: TLabel
          Width = 123
          Caption = 'Update SQL'
        end
      end
      inherited pnlMain: TPanel
        object DBNavigator1: TDBNavigator
          Left = 0
          Top = 57
          Width = 618
          Height = 25
          DataSource = dsSel
          Align = alTop
          Flat = True
          TabOrder = 1
        end
        object DBGrid1: TDBGrid
          Left = 0
          Top = 82
          Width = 618
          Height = 209
          Align = alClient
          BorderStyle = bsNone
          Ctl3D = True
          DataSource = dsSel
          ParentCtl3D = False
          TabOrder = 2
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
        end
      end
    end
  end
  object spSel: TADStoredProc
    Connection = dmlMainComp.dbMain
    UpdateOptions.UpdateMode = upWhereKeyOnly
    UpdateOptions.CountUpdatedRecords = False
    UpdateObject = ADUpdateSQL1
    PackageName = 'DEMO_TESTUPDSQL'
    StoredProcName = 'SEL'
    Left = 26
    Top = 190
    object spSelREGIONID: TIntegerField
      FieldName = 'REGIONID'
      Origin = 'REGIONID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object spSelREGIONDESCRIPTION: TStringField
      FieldName = 'REGIONDESCRIPTION'
      Origin = 'REGIONDESCRIPTION'
      Required = True
      Size = 100
    end
  end
  object dsSel: TDataSource
    DataSet = spSel
    Left = 58
    Top = 190
  end
  object ADUpdateSQL1: TADUpdateSQL
    Connection = dmlMainComp.dbMain
    InsertSQL.Strings = (
      'begin'
      '  DEMO_TESTUPDSQL.Ins(:NEW_REGIONID, :NEW_REGIONDESCRIPTION);'
      'end;')
    ModifySQL.Strings = (
      'begin'
      
        '  DEMO_TESTUPDSQL.Upd(:OLD_REGIONID, :NEW_REGIONID, :NEW_REGIOND' +
        'ESCRIPTION);'
      'end;')
    DeleteSQL.Strings = (
      'begin'
      '  DEMO_TESTUPDSQL.Del(:OLD_REGIONID);'
      'end;')
    Left = 26
    Top = 222
  end
end
