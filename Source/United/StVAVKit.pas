unit StVAVKit;

{$I stbasis.inc}
interface

uses   Classes, SysUtils, Controls, Forms,Db, IBQuery, TSVdbgrid, dbgrids, IBDatabase, IB, UMainUnited;




  procedure FillGridColumnsFromDs (IBDB: TIBDatabase;ds:TDataSet;dbg: TNewdbGrid;DoJoin:Boolean=false); ///:TColumn; //Функция заполнения Grid'a
  procedure FillGridColumnsFromTb (IBDB: TIBDatabase;TableName:AnsiString; dbg: TNewdbGrid);
procedure GetNumerDoc (IBDB: TIBDatabase;TypeDoc_id:Integer;var Prefix,Suffix:AnsiString;var NumerDoc:Integer;ForDate:TDateTime);//??????? ????????? ?????? ? ??????????
implementation

procedure FillGridColumnsFromTb (IBDB: TIBDatabase;TableName:AnsiString; dbg: TNewdbGrid);//:TColumn;//Функция заполнения Grid'a
var
  tran: TIBTransaction;
  cl: TColumn;
  qr: TIBQuery;
  newsql:string;
begin
  Screen.Cursor:=crHourGlass;
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
   //Список колонок
   try
   newsql:= 'select R.RDB$RELATION_NAME, R.RDB$FIELD_POSITION, R.RDB$FIELD_NAME,t.rdb$type_name , r.rdb$description ,'+
            ' F.RDB$FIELD_LENGTH, F.RDB$FIELD_SCALE, F.RDB$FIELD_SUB_TYPE'+
            ' from RDB$FIELDS F, RDB$RELATION_FIELDS R , rdb$types T'+
            ' where F.RDB$FIELD_NAME = R.RDB$FIELD_SOURCE and R.RDB$SYSTEM_FLAG = 0 and'+
            ' T.rdb$field_name = ''RDB$FIELD_TYPE'' and t.rdb$type = f.rdb$field_type and'+
            ' r.rdb$relation_name=UPPER(''' + Trim(TableName) +''')'+
            ' order by R.RDB$FIELD_POSITION';

   qr.SQL.Add(newsql);
   qr.Active:=true;
          while not qr.Eof do
            begin
              if (Trim(qr.FieldByName('rdb$description').AsString)<>'') then
                  begin
                    cl:=dbg.Columns.Add;
                    cl.FieldName:=Trim(qr.FieldByName('RDB$FIELD_NAME').AsString);
                    cl.Title.Caption:=Trim(qr.FieldByName('rdb$description').AsString);
                    case qr.FieldByName('RDB$FIELD_LENGTH').AsInteger of
                         1..50: cl.Width:=50;
                         250..5000 :cl.Width:=250;
                           else
                             cl.Width:=qr.FieldByName('RDB$FIELD_LENGTH').AsInteger;
                     end;
                  end;
              qr.Next;
            end;
   except
   end;
     qr.Transaction.RollbackRetaining;
   finally
      qr.Free;
      tran.Free;
      Screen.Cursor:=crDefault;
  end;
end;


procedure FillGridColumnsFromDS (IBDB: TIBDatabase;ds:TDataSet; dbg: TNewdbGrid; DoJoin:Boolean=false);//:TColumn;//Функция заполнения Grid'a
var
  tran: TIBTransaction;
  cl: TColumn;
  qr: TIBQuery;
  newsql:string;
  i:integer;
begin
  Screen.Cursor:=crHourGlass;
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
   //Список колонок
   try
   newsql:= 'select R.RDB$RELATION_NAME, R.RDB$FIELD_POSITION, R.RDB$FIELD_NAME,t.rdb$type_name , r.rdb$description ,'+
            ' F.RDB$FIELD_LENGTH, F.RDB$FIELD_SCALE, F.RDB$FIELD_SUB_TYPE'+
            ' from RDB$FIELDS F, RDB$RELATION_FIELDS R , rdb$types T'+
            ' where F.RDB$FIELD_NAME = R.RDB$FIELD_SOURCE and R.RDB$SYSTEM_FLAG = 0 and'+
            ' T.rdb$field_name = ''RDB$FIELD_TYPE'' and t.rdb$type = f.rdb$field_type'+
//            ' order by R.RDB$RELATION_NAME, R.RDB$FIELD_POSITION';
            ' order by r.rdb$description,R.RDB$RELATION_NAME, R.RDB$FIELD_POSITION';
   qr.SQL.Add(newsql);
   qr.Active:=true;
        if not qr.IsEmpty then begin
              for i:=0 to ds.FieldCount-1 do
                begin
                  qr.First;
                  if qr.Locate('RDB$FIELD_NAME',Trim(ds.Fields[i].FieldName),[]) then
                    if (Trim(qr.FieldByName('rdb$description').AsString)<>'') then
                      begin
                          cl:=dbg.Columns.Add;
                          cl.FieldName:=Trim(qr.FieldByName('RDB$FIELD_NAME').AsString);
                          cl.Title.Caption:=Trim(qr.FieldByName('rdb$description').AsString);
                          case qr.FieldByName('RDB$FIELD_LENGTH').AsInteger of
                            1..50: cl.Width:=50;
                            250..5000 :cl.Width:=250;
                          else
                            cl.Width:=qr.FieldByName('RDB$FIELD_LENGTH').AsInteger;
                          end;
                      end;
                end;

        end;
   except
   end;
   qr.Transaction.RollbackRetaining;
  finally
   qr.Free;
   tran.Free;
   Screen.Cursor:=crDefault;
  end;
end;

procedure GetNumerDoc (IBDB: TIBDatabase;TypeDoc_id:Integer;var Prefix,Suffix:AnsiString;var NumerDoc:Integer;ForDate:TDateTime);//??????? ????????? ?????? ? ??????????
var
  tran: TIBTransaction;
//  cl: TColumn;
  qr: TIBQuery;
  newsql:string;
//  Num:Integer;
begin
  Screen.Cursor:=crHourGlass;
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

   try
   newsql:= 'select n.suffix,n.prefix,n.namegenerator,n.numerators_id from numerators N'+
                ' join typenumerator tn on tn.typenumerator_id=n.typenumerator_id'+
                ' join linktypedocnumerator ltdn on ltdn.typenumerator_id=tn.typenumerator_id'+
                ' WHERE N.startdate<='''+DateToStr(ForDate)+''' and ltdn.typedoc_id='+ IntToStr(TypeDoc_id)+
                ' order by n.startdate desc';
   qr.SQL.Add(newsql);
   qr.Active:=true;
   if not qr.Eof then
      begin
        NumerDoc:=GetGenId(IBDB,'NUMERATOR_'+qr.FieldByName('numerators_id').AsString,1);
        Prefix:=qr.FieldByName('Prefix').AsString;
        Suffix:=qr.FieldByName('Suffix').AsString;
      end;
   except
   end;
     qr.Transaction.RollbackRetaining;
   finally
      qr.Free;
      tran.Free;
      Screen.Cursor:=crDefault;
  end;
end;
end.
