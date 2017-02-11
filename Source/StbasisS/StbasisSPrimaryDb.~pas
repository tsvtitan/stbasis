unit StbasisSPrimaryDb;

interface

uses Windows, Classes, SyncObjs,
     IBDatabase, IBQuery, DB, dbclient,
     StbasisSConfig, StbasisSLog, StbasisSClientDataSet;

type

  TStbasisSPrimaryDb=class(TComponent)
  private
    FConfig: TStbasisSConfig;
    FLog: TStbasisSLog;
    FDatabase: TIBDataBase;
    FTransaction: TIBTransaction;
    FDatabaseName: string;
    FUserName: string;
    FPassword: string;
    FRoleName: string;
    FLock: TCriticalSection;
    procedure AddDescProc(Source,Dest: TDataSet);
    procedure AddValueProc(Source,Dest: TDataSet);
    procedure LogProc(const S: String);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Init;
    procedure Done;
    procedure Connect;
    procedure Disconnect;
    function CheckOffice(OfficeName: string; var OfficeId: Integer; var OfficeKey: String): Boolean;
    procedure GetOutDataDesc(OfficeId: Integer; Stream: TMemoryStream);
    procedure SetNewData(Stream: TMemoryStream);
    procedure GetOutData(OfficeId: Integer; Stream: TStream);
    procedure UpdateConstex;

    property Config: TStbasisSConfig read FConfig write FConfig;
    property Log: TStbasisSLog read FLog write FLog;
  end;

implementation

uses SysUtils,
     StbasisSData, StbasisSUtils, tsvInterbase, StbasisSGlobal;

{ TStbasisSPrimaryDb }

constructor TStbasisSPrimaryDb.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDatabase:=TIBDataBase.Create(nil);
  FTransaction:=TIBTransaction.Create(nil);
  FTransaction.AddDatabase(FDatabase);
  FTransaction.Params.Text:=SParamTransaction;
  FDatabase.AddTransaction(FTransaction);
  FLock:=TCriticalSection.Create;
end;

destructor TStbasisSPrimaryDb.Destroy;
begin
  FLock.Free;
  FTransaction.Free;
  FDatabase.Free;
  inherited Destroy;
end;

procedure TStbasisSPrimaryDb.Init;
begin
  FDatabaseName:=FConfig.ReadString(SSectionPrimaryDb,SParamDatabaseName,FDatabaseName);
  FUserName:=FConfig.ReadString(SSectionPrimaryDb,SParamUserName,FUserName);
  FPassword:=FConfig.ReadString(SSectionPrimaryDb,SParamPassword,FPassword);
  FRoleName:=FConfig.ReadString(SSectionPrimaryDb,SParamRoleName,FRoleName);
end;

procedure TStbasisSPrimaryDb.Done;
begin
end;

procedure TStbasisSPrimaryDb.Connect;
var
  i: Integer;
begin
  for i:=0 to FDatabase.TransactionCount-1 do
    if Assigned(FDatabase.Transactions[i]) then
      FDatabase.Transactions[i].Active:=False;

  FDatabase.Connected:=false;
  FDatabase.DatabaseName:=FDatabaseName;
  FDatabase.LoginPrompt:=false;
  FDatabase.Params.Clear;
  FDatabase.Params.Add('user_name='+FUserName);
  FDatabase.Params.Add('password='+FPassword);
  FDatabase.Params.Add(SParamCodePage);
  if Trim(FRoleName)<>'' then
    FDatabase.Params.Add('sql_role_name='+FRoleName);

  FDatabase.Connected:=true;
  FLog.WriteToFile('Primary Db connect success',ltInformation);
end;

procedure TStbasisSPrimaryDb.Disconnect;
var
  i: Integer;
begin
  for i:=0 to FDatabase.TransactionCount-1 do
    if Assigned(FDatabase.Transactions[i]) then
      FDatabase.Transactions[i].Active:=False;

  FDatabase.Connected:=false;
  FLog.WriteToFile('Primary Db disconnect success',ltInformation);
end;

procedure TStbasisSPrimaryDb.LogProc(const S: String);
begin
  if Assigned(Flog) then
    Flog.WriteToFile(S,ltInformation);
end;

function TStbasisSPrimaryDb.CheckOffice(OfficeName: string; var OfficeId: Integer; var OfficeKey: String): Boolean;
var
  Tran: TIBTransaction;
  Query: TIBQuery;
  sqls: string;
begin
  FLog.WriteToFile(Format('CheckOffice OfficeName: %s',[OfficeName]),ltInformation);
  Result:=false;
  FLock.Enter;
  Tran:=TIBTransaction.Create(nil);
  Query:=TIBQuery.Create(nil);
  try
    FDatabase.AddTransaction(Tran);
    Tran.AddDatabase(FDatabase);
    Tran.Params.Text:=SParamTransaction;
    Query.Database:=FDatabase;
    Query.Transaction:=Tran;
    Query.Transaction.Active:=true;

    sqls:=Format('SELECT * FROM SYNC_OFFICE WHERE UPPER(NAME)=%s',[QuotedStr(AnsiUpperCase(OfficeName))]);
    Query.SQL.Add(sqls);
    Query.Active:=true;
    if not Query.IsEmpty then begin
      OfficeId:=Query.FieldByName('SYNC_OFFICE_ID').AsInteger;
      OfficeKey:=Query.FieldByName('KEYS').AsString;
      FLog.WriteToFile(Format('CheckOffice OfficeName: %s successed',[OfficeName]),ltInformation);
      Result:=true;
    end else begin
      FLog.WriteToFile(Format('CheckOffice OfficeName: %s failed',[OfficeName]),ltError);
      raise Exception.Create('Неизвестный офис');
    end;
  finally
    Query.Free;
    Tran.Free;
    FLock.Leave;
  end;
end;

procedure TStbasisSPrimaryDb.GetOutDataDesc(OfficeId: Integer; Stream: TMemoryStream);
var
  Tran: TIBTransaction;
  Query: TIBQuery;
  Data: TStbasisSClientDataSet;
  sqls: string;
begin
  FLock.Enter;
  Tran:=TIBTransaction.Create(nil);
  Query:=TIBQuery.Create(nil);
  Data:=TStbasisSClientDataSet.Create(nil);
  try
    FDatabase.AddTransaction(Tran);
    Tran.AddDatabase(FDatabase);
    Tran.Params.Text:=SParamTransaction;
    Query.Database:=FDatabase;
    Query.Transaction:=Tran;
    Query.Transaction.Active:=true;

    sqls:=Format('SELECT SO.SYNC_OBJECT_ID, SO.NAME, SO.FIELDS_SYNC, SO.CONDITION FROM '+
                 'SYNC_OFFICE_PACKAGE SOP JOIN '+
                 'SYNC_OBJECT SO ON SO.SYNC_PACKAGE_ID=SOP.SYNC_PACKAGE_ID '+
                 'WHERE SOP.SYNC_OFFICE_ID=%d AND SOP.DIRECTION=0 '+
                 'ORDER BY SOP.PRIORITY',
                 [OfficeId]);
    Query.SQL.Add(sqls);
    Query.Active:=true;
    Data.CreateDataSetBySource(Query);
    while not Query.Eof do begin
      Data.FieldValuesBySource(Query);
      Query.Next;
    end;
    Data.MergeChangeLog;
    Data.SaveToStream(Stream);

  finally
    Data.Free;
    Query.Free;
    Tran.Free;
    FLock.Leave;
  end;
end;


procedure TStbasisSPrimaryDb.SetNewData(Stream: TMemoryStream);
var
  Tran: TIBTransaction;
  Query: TIBQuery;
  Data,TempData: TStbasisSClientDataSet;
  AObjectId: Integer;
  TempStream: TMemoryStream;
  sqls: string;
begin
  FLock.Enter;
  Tran:=TIBTransaction.Create(nil);
  Query:=TIBQuery.Create(nil);
  Data:=TStbasisSClientDataSet.Create(nil);
  try
    try
      Data.LoadFromStream(Stream);
    except
      raise Exception.Create('Данные имеют неверный формат');
    end;
    if Data.Active then begin
      FDatabase.AddTransaction(Tran);
      Tran.AddDatabase(FDatabase);
      Tran.Params.Text:=SParamTransaction;
      Query.Database:=FDatabase;
      Query.Transaction:=Tran;
      Query.Transaction.Active:=true;

      Data.First;
      while not Data.Eof do begin
        AObjectId:=Data.FieldByName('SYNC_OBJECT_ID').AsInteger;
        sqls:=Format('SELECT NAME, FIELDS_SYNC, FIELDS_KEY, CONDITION, SQL_BEFORE, SQL_AFTER FROM '+
                     'SYNC_OBJECT WHERE SYNC_OBJECT_ID=%d',[AObjectId]);

        Query.Transaction.Active:=false;
        Query.Active:=false;
        Query.Transaction.Active:=true;
        Query.Sql.Clear;
        Query.Sql.Add(sqls);
        Query.Active:=true;

        TempData:=TStbasisSClientDataSet.Create(nil);
        TempStream:=TMemoryStream.Create;
        try
          TBlobField(Data.FieldByName('DATA')).SaveToStream(TempStream);
          TempStream.Position:=0;
          TempData.LoadFromStream(TempStream);
          CompareAndModify(FDatabase,
                           Query.FieldByName('NAME').AsString,
                           Query.FieldByName('FIELDS_SYNC').AsString,
                           Query.FieldByName('FIELDS_KEY').AsString,
                           Query.FieldByName('CONDITION').AsString,
                           Query.FieldByName('SQL_BEFORE').AsString,
                           Query.FieldByName('SQL_AFTER').AsString,
                           TempData,nil,nil,LogProc);
        finally
          TempStream.Free;
          TempData.Free;
        end;
        Data.Next;
      end;
      
    end;  
  finally
    Data.Free;
    Query.Free;
    Tran.Free;
    FLock.Leave;
  end;
end;

procedure TStbasisSPrimaryDb.AddDescProc(Source,Dest: TDataSet);
begin
  with Dest.FieldDefs.AddFieldDef do begin
    Name:='DATA';
    DataType:=ftBlob;
  end;
end;

procedure TStbasisSPrimaryDb.AddValueProc(Source,Dest: TDataSet);
var
  Tran: TIBTransaction;
  Query: TIBQuery;
  sqls: string;
  AName,AFields_Sync,ACondition: String;
  NewFields: string;
  Data: TStbasisSClientDataSet;
  TempStream: TMemoryStream;
begin
  Tran:=TIBTransaction.Create(nil);
  Query:=TIBQuery.Create(nil);
  Data:=TStbasisSClientDataSet.Create(nil);
  try
    FDatabase.AddTransaction(Tran);
    Tran.AddDatabase(FDatabase);
    Tran.Params.Text:=SParamTransaction;
    Query.Database:=FDatabase;
    Query.Transaction:=Tran;

    AName:=Source.FieldByName('NAME').AsString;
    AFields_Sync:=Source.FieldByName('FIELDS_SYNC').AsString;
    ACondition:=Source.FieldByName('CONDITION').AsString;
    NewFields:=AFields_Sync;
    sqls:=Format('SELECT %s FROM %s%s',[NewFields,AName,iff(Trim(ACondition)<>'',Format(' WHERE %s',[ACondition]),'')]);

    Query.Transaction.Active:=true;
    Query.Sql.Clear;
    Query.Sql.Add(sqls);
    Query.Active:=true;

    TempStream:=TMemoryStream.Create;
    try
      Query.First;
      Data.CreateDataSetBySource(Query);
      while not Query.Eof do begin
        Data.FieldValuesBySource(Query);
        Query.Next;
      end;
      Data.MergeChangeLog;
      Data.SaveToStream(TempStream);
      TempStream.Position:=0;
      TBlobField(Dest.FieldByName('DATA')).LoadFromStream(TempStream);
    finally
      TempStream.Free;
    end;

  finally
    Data.Free;
    Query.Free;
    Tran.Free;
  end;
end;

procedure TStbasisSPrimaryDb.GetOutData(OfficeId: Integer; Stream: TStream);
var
  Tran: TIBTransaction;
  Query: TIBQuery;
  Data: TStbasisSClientDataSet;
  sqls: string;
begin
  FLock.Enter;
  Tran:=TIBTransaction.Create(nil);
  Query:=TIBQuery.Create(nil);
  Data:=TStbasisSClientDataSet.Create(nil);
  try
    FDatabase.AddTransaction(Tran);
    Tran.AddDatabase(FDatabase);
    Tran.Params.Text:=SParamTransaction;
    Query.Database:=FDatabase;
    Query.Transaction:=Tran;
    Query.Transaction.Active:=true;

    sqls:=Format('SELECT SO.NAME, SO.FIELDS_SYNC, SO.FIELDS_KEY, SO.CONDITION, SO.SQL_BEFORE, SO.SQL_AFTER FROM '+
                 'SYNC_OFFICE_PACKAGE SOP JOIN '+
                 'SYNC_OBJECT SO ON SO.SYNC_PACKAGE_ID=SOP.SYNC_PACKAGE_ID '+
                 'WHERE SOP.SYNC_OFFICE_ID=%d AND SOP.DIRECTION=1 '+
                 'ORDER BY SOP.PRIORITY',
                 [OfficeId]);
    Query.SQL.Add(sqls);
    Query.Active:=true;
    Data.CreateDataSetBySource(Query,AddDescProc);
    while not Query.Eof do begin
      Data.FieldValuesBySource(Query,AddValueProc);
      Query.Next;
    end;
    Data.MergeChangeLog;
    Data.SaveToStream(Stream);

  finally
    Data.Free;
    Query.Free;
    Tran.Free;
    FLock.Leave;
  end;
end;

procedure TStbasisSPrimaryDb.UpdateConstex;
begin
  FLock.Enter;
  try
    ExecSql(FDatabase,Format('UPDATE CONSTEX SET VALUEVIEW=%s WHERE NAME=%s',[QuotedStr(DateToStr(Now)),QuotedStr(SDateSync)]));
  finally
    FLock.Leave;
  end;
end;

end.
