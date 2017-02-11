{-------------------------------------------------------------------------------}
{ AnyDAC Component Layer: TADUpdateSQL tests                                    }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit ADQACompLayerUPD;

interface

uses
  Classes, Windows, SysUtils, DB,
  ADQAPack, ADQACompLayerCNN,
  daADStanIntf, daADStanOption, daADStanParam,
  daADDatSManager,
  daADGUIxIntf,
  daADPhysIntf,
  daADDAptIntf,
  daADCompClient;

type
  TADQACompUPDTsHolder = class (TADQACompTsHolderBase)
  private
    FUpdDet, FUpdMast: TADUpdateSQL;
    procedure UpdateRecordEvent(ASender: TDataSet; ARequest: TADPhysUpdateRequest;
      var AAction: TADErrorAction; AOptions: TADPhysUpdateRowOptions);
  public
    constructor Create(const AName: String); override;
    destructor Destroy; override;
    procedure RegisterTests; override;
    procedure TestUpdate;
  end;

implementation

uses
{$IFDEF AnyDAC_D6}
  Variants,
{$ENDIF}  
  ADQAConst, ADQAUtils,
  daADCompDataSet;

{-------------------------------------------------------------------------------}
{ TADQACompUPDTsHolder                                                          }
{-------------------------------------------------------------------------------}
procedure TADQACompUPDTsHolder.RegisterTests;
begin
  RegisterTest('UpdateSQL;DB2',       TestUpdate, mkDB2);
  RegisterTest('UpdateSQL;MS Access', TestUpdate, mkMSAccess);
  RegisterTest('UpdateSQL;MSSQL',     TestUpdate, mkMSSQL);
  RegisterTest('UpdateSQL;ASA',       TestUpdate, mkASA);
  RegisterTest('UpdateSQL;MySQL',     TestUpdate, mkMySQL);
  RegisterTest('UpdateSQL;Oracle',    TestUpdate, mkOracle);
end;

{-------------------------------------------------------------------------------}
constructor TADQACompUPDTsHolder.Create(const AName: String);
begin
  inherited Create(AName);
  FUpdDet := TADUpdateSQL.Create(nil);
  FUpdMast := TADUpdateSQL.Create(nil);
  FUpdDet.Connection := FConnection;
  FUpdMast.Connection := FConnection;
end;

{-------------------------------------------------------------------------------}
destructor TADQACompUPDTsHolder.Destroy;
begin
  FUpdDet.Free;
  FUpdDet := nil;
  FUpdMast.Free;
  FUpdMast := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompUPDTsHolder.TestUpdate;
var
  i, iErrCnt: Integer;
  V1, V2: Variant;
  sName1: String;
  lErrors: Boolean;

  procedure PrepareTest;
  begin
    with FUpdDet do begin
      InsertSQL.Text := 'INSERT INTO {id ADQA_details_autoinc} (' +
                        '  fk_id1, name2)' +
                        'VALUES (:NEW_fk_id1, :NEW_name2)';
      if FRDBMSKind = mkMSSQL then InsertSQL.Text := InsertSQL.Text +
                        'SELECT :NEW_id2 = @@identity';
      ModifySQL.Text := 'UPDATE {id ADQA_details_autoinc} SET' +
                        '  name2 = :NEW_name2, fk_id1 = :NEW_fk_id1 ' +
                        'WHERE id2 = :OLD_id2';
      DeleteSQL.Text := 'DELETE FROM {id ADQA_details_autoinc} ' +
                        'WHERE id2 = :OLD_id2';
      FetchRowSQL.Text := 'SELECT * FROM {id ADQA_details_autoinc} ' +
                          'WHERE id2 = :OLD_id2';
      Connection := FConnection;
    end;
    FUpdMast.ModifySQL.Text := 'UPDATE {id ADQA_master_autoinc} ' +
                               'SET name1 = :NEW_name1 WHERE id1 = :OLD_fk_id1';
    FUpdMast.Connection := FConnection;

    with FQuery do begin
      OnUpdateRecord := UpdateRecordEvent;
      CachedUpdates := True;
      FetchOptions.Mode := fmAll;
      FetchOptions.Items := [fiBlobs, fiDetails];
      UpdateOptions.UpdateMode := upWhereAll;
    end;
  end;

  procedure ReOpenQuery;
  begin
    FillTables;
    with FQuery do begin
      SQL.Text := 'SELECT d.*, m.name1 ' +
                  'FROM {id ADQA_details_autoinc} d, {id ADQA_master_autoinc} m ' +
                  'WHERE d.fk_id1 = m.id1 order by d.id2';
      Open;
      Fields[0].Required := False;
    end;
  end;

begin
  PrepareTest;
  lErrors := False;
  with FQuery do begin
    // 1. delete record from dataset
    ReOpenQuery;
    i := RecordCount;
    try
      Delete;
      iErrCnt := ApplyUpdates;
      CommitUpdates;
      if iErrCnt <> 0 then begin
        Error(ErrorOnUpdate(iErrCnt, 0) + '. [Delete record]');
        lErrors := True;
      end;
      if not lErrors then
        CheckRowsCount(nil, i, RecordCount + 1);
    except
      on E:Exception do
        Error(E.Message);
    end;

    // 2. update record
    ReOpenQuery;
    lErrors := False;
    iErrCnt := -1;
    try
      Edit;
      FieldByName('name2').AsString := 'UpdateSQL-Det';
      FieldByName('fk_id1').AsInteger := FieldByName('fk_id1').AsInteger + 1;
      i := FieldByName('fk_id1').AsInteger;
      FieldByName('name1').AsString := 'UpdateSQL-Mast';
      Post;
      iErrCnt := ApplyUpdates;
    except
      on E:Exception do begin
        Error(E.Message);
        lErrors := True;
      end;
    end;
    CommitUpdates;
    if iErrCnt <> 0 then begin
      Error(ErrorOnUpdate(iErrCnt, 0) + '. [Update record]');
      lErrors := True;
    end;

    if not lErrors then begin
      V1 := FieldByName('name2').AsString;
      V2 := 'UpdateSQL-Det';
      if Compare(V1, V2, ftString) <> 0 then
        Error(WrongUpdatedVals(V1, V2));

      V1 := FieldByName('name1').AsString;
      V2 := 'UpdateSQL-Mast';
      if Compare(V1, V2, ftString) <> 0 then
        Error(WrongUpdatedVals(V1, V2));

      V1 := FieldByName('fk_id1').AsInteger;
      V2 := i;
      if Compare(V1, V2, ftInteger) <> 0 then
        Error(WrongUpdatedVals(VarToStr(V1), VarToStr(V2)));
    end;

    // 3. insert record
    ReOpenQuery;
    try
      i := FieldByName('fk_id1').AsInteger;
      sName1 := FieldByName('name1').AsString;
      Append;
      FieldByName('name2').AsString := 'UpdateSQL-Det';
      FieldByName('fk_id1').AsInteger := i;
      Post;
      iErrCnt := ApplyUpdates;
    except
      on E:Exception do begin
        Error(E.Message);
        Exit;
      end;
    end;
    CommitUpdates;
    Refresh;   // I need call Refresh to fill name1 field the value from ADQA_master_autoinc
    if iErrCnt <> 0 then begin
      Error(ErrorOnUpdate(iErrCnt, 0) + '. [Insert record]');
      Exit;
    end;
    Last;

    V1 := FieldByName('name2').AsString;
    V2 := 'UpdateSQL-Det';
    if Compare(V1, V2, ftString) <> 0 then
      Error(WrongUpdatedVals(V1, V2));

    V1 := FieldByName('fk_id1').AsInteger;
    V2 := i;
    if Compare(V1, V2, ftInteger) <> 0 then
      Error(WrongUpdatedVals(VarToStr(V1), VarToStr(V2)));

    V1 := FieldByName('name1').AsString;
    V2 := sName1;
    if Compare(V1, V2, ftInteger) <> 0 then
      Error(WrongUpdatedVals(V1, V2));
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompUPDTsHolder.UpdateRecordEvent(ASender: TDataSet;
  ARequest: TADPhysUpdateRequest; var AAction: TADErrorAction;
  AOptions: TADPhysUpdateRowOptions);
begin
  try
    FUpdDet.DataSet := FQuery;
    FUpdDet.Apply(ARequest, AAction, AOptions);

    FUpdMast.DataSet := FQuery;
    FUpdMast.Apply(ARequest, AAction, AOptions);

    AAction := eaApplied;
  except
    on E: Exception do
      Error(E.Message + '. [' + UpdateReq[ARequest] + ']');
  end;
end;

initialization

  ADQAPackManager.RegisterPack('Comp Layer', TADQACompUPDTsHolder);

end.
