unit tsvInterpreterIB;

interface

uses Classes, UMainUnited, tsvInterpreterCore, IBDatabase, IBCustomDataSet, IBQuery;

// TIBDatabase
procedure TIBDatabase_AddTransaction(var Value: Variant; Args: TArguments);

// TIBTransaction
procedure TIBTransaction_AddDatabase(var Value: Variant; Args: TArguments);
procedure TIBTransaction_Commit(var Value: Variant; Args: TArguments);

// TIBCustomDataSet
procedure TIBCustomDataSet_FetchAll(var Value: Variant; Args: TArguments);

// TIBDataSet
procedure TIBDataSet_ExecSQL(var Value: Variant; Args: TArguments);

// TIBQuery
procedure TIBQuery_ExecSQL(var Value: Variant; Args: TArguments);

implementation


// TIBDatabase

{ function AddTransaction(TR: TIBTransaction): Integer; }
procedure TIBDatabase_AddTransaction(var Value: Variant; Args: TArguments);
begin
  Value := TIBDatabase(Args.Obj).AddTransaction(TIBTransaction(V2O(Args.Values[0])));
end;

// TIBTransaction

// function AddDatabase(db: TIBDatabase): Integer;
procedure TIBTransaction_AddDatabase(var Value: Variant; Args: TArguments);
begin
  Value := TIBTransaction(Args.Obj).AddDatabase(TIBDatabase(V2O(Args.Values[0])));
end;

procedure TIBTransaction_Commit(var Value: Variant; Args: TArguments);
begin
  TIBTransaction(Args.Obj).Commit;
end;


// TIBCustomDataSet

// procedure FetchAll;
procedure TIBCustomDataSet_FetchAll(var Value: Variant; Args: TArguments);
begin
  TIBCustomDataSet(Args.Obj).FetchAll;
end;

// TIBDataSet

procedure TIBDataSet_ExecSQL(var Value: Variant; Args: TArguments);
begin
  TIBDataSet(Args.Obj).ExecSQL;
end;


// TIBQuery

procedure TIBQuery_ExecSQL(var Value: Variant; Args: TArguments);
begin
  TIBQuery(Args.Obj).ExecSQL;
end;


end.
