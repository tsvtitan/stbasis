unit tsvInterbase;

interface

uses Classes, Controls, Forms, IBQuery, IBDatabase, UMainUnited,
     StbasisSClientDataSet;

type
  TProgressProc=procedure (Progess: Integer) of object;
  TCheckBreakProc=function: Boolean of object;
  TLogProcCallback=procedure (const S: String) of object;

procedure ExecSql(IBDB: TIBDatabase; SqlValue: string);
procedure CompareAndModify(ADatabase: TIBDatabase;
                           AName,AFields_Sync,AFileds_Key,ACondition,
                           ASqlBefore,ASqlAfter: string; Data: TStbasisSClientDataSet;
                           AProc: TProgressProc=nil;
                           ABreak: TCheckBreakProc=nil;
                           ALog: TLogProcCallback=nil);
function GetFirstValueBySQL(ADatabase: TIbDatabase; ASQL, AField: string): Variant;
procedure FillDataSetByQuery(ADatabase: TIbDatabase; ADataSet: TStbasisSClientDataSet; ASQL: String);
procedure FillStringsByQuery(ADatabase: TIbDatabase; AStrings: TStringList; ASQL, AFieldId, AFieldValue: String);

implementation

uses DB, SysUtils,
     StbasisSUtils;

const
  DefaultTransactionParamsTwo='read_committed'+#13+
                              'rec_version'+#13+
                              'nowait';
     
procedure ExecSql(IBDB: TIBDatabase; SqlValue: string);
var
  qr: TIBQuery;
  tran: TIBTransaction;
  sqls: string;
begin
  qr:=TIBQuery.Create(nil);
  tran:=TIBTransaction.Create(nil);
  try
    qr.Database:=IBDB;
    tran.AddDatabase(IBDB);
    IBDB.AddTransaction(tran);
    tran.Params.Text:=DefaultTransactionParamsTwo;
    qr.ParamCheck:=false;
    qr.Transaction:=tran;
    qr.Transaction.Active:=true;
    sqls:=SqlValue;
    qr.SQL.Text:=sqls;
    qr.ExecSQL;
    qr.Transaction.Commit;
  finally
   qr.Free;
   tran.Free;
  end;
end;

procedure CompareAndModify(ADatabase: TIbDatabase;
                           AName,AFields_Sync,AFileds_Key,ACondition,
                           ASqlBefore,ASqlAfter: string; Data: TStbasisSClientDataSet;
                           AProc: TProgressProc=nil;
                           ABreak: TCheckBreakProc=nil;
                           ALog: TLogProcCallback=nil);

  procedure Log(S: String);
  begin
    if Assigned(ALog) then
      ALog(S);
  end;

  function GetNewValue(Field: TField): String;
  begin
    Result:=Field.AsString;
    case Field.DataType of
      ftFloat, ftCurrency, ftBCD: begin
        Result:=ChangeChar(Result,DecimalSeparator,'.');
      end;
    end;
  end;
                           
  function GetUpdateSql(FieldsKey: TStringList): String;
  var
    Fields: string;
    wheres: String;
    i: Integer;
    Field: TField;
    NewValue: String;
  begin
    for i:=0 to FieldsKey.Count-1 do begin
      Field:=Data.FieldByName(FieldsKey[i]);
      NewValue:=iff(VarIsNull(Field.Value),'NULL',QuotedStr(GetNewValue(Field)));
      if i=0 then wheres:=Format('%s=%s',[FieldsKey[i],NewValue])
      else wheres:=Format('%s AND %s=%s',[wheres,FieldsKey[i],NewValue]);
    end;
    for i:=0 to Data.Fields.Count-1 do begin
      Field:=Data.Fields[i];
      NewValue:=iff(VarIsNull(Field.Value),'NULL',QuotedStr(GetNewValue(Field)));
      if i=0 then Fields:=Format('%s=%s',[Field.FieldName,NewValue])
      else Fields:=Format('%s,%s=%s',[Fields,Field.FieldName,NewValue]);
    end;
    Result:=Format('UPDATE %s SET %s WHERE %s',[AName,Fields,wheres]);
  end;

  function GetInsertSql: String;
  var
    Fields, Values: string;
    NewValue: string;
    i: Integer;
    Field: TField;
  begin
    for i:=0 to Data.Fields.Count-1 do begin
      Field:=Data.Fields[i];
      NewValue:=iff(VarIsNull(Field.Value),'NULL',QuotedStr(GetNewValue(Field)));
      if i=0 then begin
        Values:=Format('%s',[NewValue]);
        Fields:=Field.FieldName;
      end else begin
        Values:=Format('%s,%s',[Values,NewValue]);
        Fields:=Format('%s,%s',[Fields,Field.FieldName])
      end;  
    end;
    Result:=Format('INSERT INTO %s (%s) VALUES (%s)',[AName,Fields,Values]);
  end;

  procedure SqlByList(AList: String);
  var
    Tran: TIBTransaction;
    Query: TIBQuery;
    str: TStringList;
    i: Integer;
  begin
    if Trim(AList)<>'' then begin
      Tran:=TIBTransaction.Create(nil);
      Query:=TIBQuery.Create(nil);
      str:=TStringList.Create;
      try
        ADatabase.AddTransaction(Tran);
        Tran.AddDatabase(ADatabase);
        Tran.Params.Text:=DefaultTransactionParamsTwo;
        Tran.DefaultAction:=TARollback;
        Query.Database:=ADatabase;
        Query.Transaction:=Tran;
        Query.Transaction.Active:=true;

        str.Clear;
        StrParseDelim(AList,';',str);
        for i:=0 to str.Count-1 do begin
          Query.SQL.Clear;
          Query.SQL.Add(str.Strings[i]);
          try
            Query.ExecSQL;
            Query.Transaction.CommitRetaining;
            Log(Format('SqlByList: %s successed',[str.Strings[i]]));
          except
            on E: Exception do begin
              Log(Format('SqlByList: %s failed: %s',[str.Strings[i],E.Message]));
            end;
          end;
        end;

        Query.Transaction.Commit;
      finally
        str.Free;
        Query.Free;
        Tran.Free;
      end;
    end;  
  end;

  procedure UpdateOrInsertRecord(FieldsKey: TStringList; IsNew: Boolean);
  var
    sqls: string;
    Tran: TIBTransaction;
    Query: TIBQuery;
    str: TStringList;
  begin
    if IsNew then sqls:=GetInsertSql
    else sqls:=GetUpdateSql(FieldsKey);
    Tran:=TIBTransaction.Create(nil);
    Query:=TIBQuery.Create(nil);
    str:=TStringList.Create;
    try
      ADatabase.AddTransaction(Tran);
      Tran.AddDatabase(ADatabase);
      Tran.Params.Text:=DefaultTransactionParamsTwo;
      Tran.DefaultAction:=TARollback;
      Query.Database:=ADatabase;
      Query.Transaction:=Tran;
      Query.Transaction.Active:=true;

      Query.SQL.Clear;
      Query.SQL.Add(sqls);
      try
        Query.ExecSQL;
        Query.Transaction.CommitRetaining;
        Log(Format('UpdateOrInsertRecord: %s successed',[sqls]));
      except
        on E: Exception do begin
          Log(Format('UpdateOrInsertRecord: %s failed: %s',[sqls,E.Message]));
        end;
      end;

      Query.Transaction.Commit;
    finally
      str.Free;
      Query.Free;
      Tran.Free;
    end;
  end;

  function FoundRecord(FieldsKey: TStringList; Values: array of Variant): Boolean;
  var
    Tran: TIBTransaction;
    Query: TIBQuery;
    sqls: string;
    WhereStr: string;
    i: Integer;
  begin
    Result:=false;
    Tran:=TIBTransaction.Create(nil);
    Query:=TIBQuery.Create(nil);
    try
      ADatabase.AddTransaction(Tran);
      Tran.AddDatabase(ADatabase);
      Tran.Params.Text:=DefaultTransactionParamsTwo;
      Query.Database:=ADatabase;
      Query.Transaction:=Tran;
      Query.Transaction.Active:=true;
      for i:=0 to FieldsKey.Count-1 do begin
        if i=0 then
          WhereStr:=Format('%s=%s',[FieldsKey[i],QuotedStr(Values[i])])
        else WhereStr:=Format('%s AND %s=%s',[WhereStr,FieldsKey[i],QuotedStr(Values[i])]);
      end;
      sqls:=Format('SELECT COUNT(*) AS CNT FROM %s%s',[AName,iff(Trim(WhereStr)<>'',Format(' WHERE %s',[WhereStr]),'')]);
      Query.Sql.Add(sqls);
      try
        Query.Active:=true;
        if not Query.IsEmpty then begin
          Result:=Query.FieldByName('CNT').AsInteger>0;
          Log(Format('FoundRecord: %s with count: %d successed',[sqls,Query.FieldByName('CNT').AsInteger]));
        end;
      except
        on E: Exception do begin
          Log(Format('FoundRecord: %s failed: %s',[sqls,E.Message]));
        end;
      end;    
    finally
      Query.Free;
      Tran.Free;
    end;
  end;

var
  FieldsKey: TStringList;
  LocateValues: array of Variant;
  isFound: Boolean;
  i: Integer;
  Progress: Integer;
begin
  if Data.Active and not Data.IsEmpty then begin
    FieldsKey:=TStringList.Create;
    try
      SqlByList(ASqlBefore);
      StrParseDelim(AFileds_Key,',',FieldsKey);
      SetLength(LocateValues,FieldsKey.Count);
      Progress:=0;
      Data.First;
      while not Data.Eof do begin
        if Assigned(ABreak) then
          if ABreak then break;
        for i:=0 to FieldsKey.Count-1 do begin
          LocateValues[i]:=Data.FieldByName(FieldsKey[i]).Value;
        end;
        IsFound:=FoundRecord(FieldsKey,LocateValues);
        UpdateOrInsertRecord(FieldsKey,not IsFound);
        Inc(Progress);
        if Assigned(AProc) then
          AProc(Progress);
        Data.Next;
      end;
      SqlByList(ASqlAfter);
    finally
      FieldsKey.Free;
    end;
  end;
end;

function GetFirstValueBySQL(ADatabase: TIbDatabase; ASQL, AField: string): Variant;
var
  qr: TIBQuery;
  tran: TIBTransaction;
begin
  Result:=NULL;
  qr:=TIBQuery.Create(nil);
  tran:=TIBTransaction.Create(nil);
  try
    tran.AddDatabase(ADatabase);
    ADatabase.AddTransaction(tran);
    tran.Params.Text:=DefaultTransactionParamsTwo;
    qr.Database:=ADatabase;
    qr.Transaction:=tran;
    qr.Transaction.Active:=true;
    qr.SQL.Add(ASQL);
    qr.Open;
    if not qr.IsEmpty then
      Result:=qr.FieldByName(AField).Value;

    if VarIsNull(qr.FieldByName(AField).Value) then
      case qr.FieldByName(AField).DataType of
        ftSmallint, ftWord, ftInteger, ftLargeint: Result:=0;
        ftString, ftMemo, ftFixedChar, ftWideString: Result:='';
      end;
  finally
    tran.Free;
    qr.Free;
  end;
end;

procedure FillDataSetByQuery(ADatabase: TIbDatabase; ADataSet: TStbasisSClientDataSet; ASQL: String);
var
  qr: TIBQuery;
  tran: TIBTransaction;
begin
  qr:=TIBQuery.Create(nil);
  tran:=TIBTransaction.Create(nil);
  try
    tran.AddDatabase(ADatabase);
    ADatabase.AddTransaction(tran);
    tran.Params.Text:=DefaultTransactionParamsTwo;
    qr.Database:=ADatabase;
    qr.Transaction:=tran;
    qr.Transaction.Active:=true;
    qr.SQL.Add(ASQL);
    qr.Active:=true;
    ADataSet.CreateDataSetBySource(qr);
  finally
    tran.Free;
    qr.Free;
  end;
end;

procedure FillStringsByQuery(ADatabase: TIbDatabase; AStrings: TStringList; ASQL, AFieldId, AFieldValue: String);
var
  qr: TIBQuery;
  tran: TIBTransaction;
begin
  qr:=TIBQuery.Create(nil);
  tran:=TIBTransaction.Create(nil);
  try
    AStrings.Clear;
    tran.AddDatabase(ADatabase);
    ADatabase.AddTransaction(tran);
    tran.Params.Text:=DefaultTransactionParamsTwo;
    qr.Database:=ADatabase;
    qr.Transaction:=tran;
    qr.Transaction.Active:=true;
    qr.SQL.Add(ASQL);
    qr.Active:=true;
    qr.First;
    if not qr.IsEmpty then begin
      while not qr.Eof do begin
        AStrings.AddObject(qr.FieldByName(AFieldValue).AsString,TObject(qr.FieldByName(AFieldId).AsInteger));
        qr.Next;
      end;
    end;
  finally
    tran.Free;
    qr.Free;
  end;
end;

end.
