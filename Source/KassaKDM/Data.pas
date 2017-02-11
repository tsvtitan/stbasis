unit Data;

interface

//uses Forms, Classes, Controls, IBDatabase, extctrls, comctrls;
uses Classes, forms, IBDatabase, Windows, IBQuery, graphics, sysutils, controls,
     IBServices, Excel97, db, dbgrids;

type TNotifyEvent1 = procedure (Sender: TObject; Condition: string) of object;


const
     ConstError = 'Ошибка';
     VK_Enter = 13;
     VK_ESC = 27;
     VK_Down = 40;

     ConstGetIniFileName='GetIniFileName';
     MainExe='Project1.exe';

var
  TempStr: String;
  TempList: TStrings;
  IdRec: Integer;
  OnCloseForm: Boolean;
  inside: Boolean;
  MView: Boolean;

function TranslateIBError(Message: string): string;
function ShowError(Handle: THandle; Mess: String): Integer;
function GetRecordCount(qr: TIBQuery): Integer;
function CreateForms(NameTable: string; Condition: string): TStrings;
function divide(Str: string): TStrings;
function TakeFromSubkonto(IdAc: string; IdInSub: TStrings): TStrings;
//function ProcessingSubkonto(SubId: string): TStrings;
//function _GetIniFileName: Pchar;stdcall; external MainExe name ConstGetIniFileName;

implementation

uses BankAccount, Emp, CashBasis, CashAppend, Currency, NDS,Doc, Kassa;

function TranslateIBError(Message: string): string;
var
  str: TStringList;
  APos: Integer;
  tmps: string;
const
  ExceptConst='exception';
  NewConst='Исключение №';
begin
  str:=TStringList.Create;
  try
   str.Text:=Message;
   if str.Count>1 then begin
     tmps:=str.Strings[0];
     APos:=Pos(ExceptConst,tmps);
     if APos<>0 then begin
     {      tmps:=NewConst+Copy(tmps,APos+Length(ExceptConst)+1,
                          Length(tmps)-APos+Length(ExceptConst)+1);
      str.Strings[0]:=tmps;}

     end;
     str.Delete(0);
   end;
   Result:=str.Text;
  finally
   str.Free;
  end;
end;

function ShowError(Handle: THandle; Mess: String): Integer;
begin
 Result:=MessageBox(Handle,Pchar(Mess),ConstError,MB_ICONERROR);
end;

function GetRecordCount(qr: TIBQuery): Integer;
var
 sqls: string;
 Apos: Integer;
 newsqls: string;
 qrnew: TIBQuery;
const
 from='from';
begin
 Result:=0;
 try
  if not qr.Active then exit;
  sqls:=qr.SQL.Text;
  if Trim(sqls)='' then exit;
  Apos:=Pos(AnsiUpperCase(from),AnsiUpperCase(sqls));
  if Apos=0 then exit;
  newsqls:='Select count(*) as ctn from '+
           Copy(sqls,Apos+Length(from),Length(sqls)-Apos-Length(from));
  Screen.Cursor:=crHourGlass;
  qrnew:=TIBQuery.Create(nil);
  try
   qrnew.Database:=qr.Database;
   qrnew.Transaction:=qr.Transaction;//Пусть работает в контексте передаваемой
//   qrnew.Transaction.Active:=true; //транзакции. Это позволяет сразу реагировать
                                     //на только что внесённые изменения
   qrnew.SQL.Add(newsqls);

   //Added by Volkov (needed for master-detail)
   qrnew.DataSource:=qr.DataSource;
   qrnew.Params.AssignValues(qr.Params);
   //////////////////////////////////////

   qrnew.Active:=true;
   if not qrnew.IsEmpty then begin //Так круче :-)
//   if qrnew.RecordCount=1 then begin
     Result:=qrnew.FieldByName('ctn').AsInteger;
   end;
  finally
   qrnew.free;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

function CreateForms(NameTable: string; Condition: string): TStrings;
var
  TableList,ResList: TStrings;
  fm1: TFBank;
  fm2: TFEmp;
  fm3: TFCashBasis;
  fm4: TFCashAppend;
  fm5: TFCur;
  fm6: TFNDS;
  fm7: TFDoc;
  Index: integer;
begin
  try
    TableList := TStringList.Create;
    ResList := TStringList.Create;
{    TableList.Add('BANK');
    TableList.Add('TFBank');
    Index := TableList.IndexOf(NameTable);}
    try
      if (NameTable='BANK') then begin
        MView := True;
        fm1 := TFBank.Create(nil);
        MView := False;
        fm1.FormStyle := fsNormal;
        fm1.Visible := false;
        fm1.ModeView := True;
        fm1.SetCondition(Condition);
        fm1.ShowModal;
        ResList.AddStrings(TempList);
        fm1.free;
      end;
      if (NameTable='EMP') then begin
        MView := True;
        fm2 := TFEmp.Create(nil);
        MView := False;
        fm2.FormStyle := fsNormal;
        fm2.Visible := false;
        fm2.ModeView := True;
        fm2.SetCondition(Condition);
        fm2.ShowModal;
        ResList.AddStrings(TempList);
        fm2.free;
      end;
      if (NameTable='CASHBASIS') then begin
        MView := True;
        fm3 := TFCashBasis.Create(nil);
        MView := False;
        fm3.FormStyle := fsNormal;
        fm3.Visible := false;
        fm3.ModeView := True;
        fm3.SetCondition(Condition);
        fm3.ShowModal;
        ResList.AddStrings(TempList);
        fm3.free;
      end;
      if (NameTable='CASHAPPEND') then begin
        MView := True;
        fm4 := TFCashAppend.Create(nil);
        MView := False;
        fm4.FormStyle := fsNormal;
        fm4.Visible := false;
        fm4.ModeView := True;
        fm4.SetCondition(Condition);
        fm4.ShowModal;
        ResList.AddStrings(TempList);
        fm4.free;
      end;
      if (NameTable='CURRENCY') then begin
        MView := True;
        fm5 := TFCur.Create(nil);
        MView := False;
        fm5.FormStyle := fsNormal;
        fm5.Visible := false;
        fm5.ModeView := True;
        fm5.SetCondition(Condition);
        fm5.ShowModal;
        ResList.AddStrings(TempList);
        fm5.free;
      end;
      if (NameTable='NDS') then begin
        MView := True;
        fm6 := TFNDS.Create(nil);
        MView := False;
        fm6.FormStyle := fsNormal;
        fm6.Visible := false;
        fm6.ModeView := True;
        fm6.SetCondition(Condition);
        fm6.ShowModal;
        ResList.AddStrings(TempList);
        fm6.free;
      end;
      if (NameTable='EMPPERSONDOC') then begin
        MView := True;
        fm7 := TFDoc.Create(nil);
        MView := False;
        fm7.FormStyle := fsNormal;
        fm7.Visible := false;
        fm7.ModeView := True;
        fm7.SetCondition(Condition);
        fm7.ShowModal;
        ResList.AddStrings(TempList);
        fm7.free;
      end;
{      if (NameTable='PLANT') then begin
        fm7 := TFDoc.Create(nil);
        fm7.FormStyle := fsNormal;
        fm7.Visible := false;
        fm7.ModeView := True;
        fm7.SetCondition(Condition);
        fm7.ShowModal;
        ResList.AddStrings(TempList);
        fm7.free;
      end;       }
    finally
      TableList.Free;
      TempList.Clear;
      Result := ResList;
    end;
  except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

function divide(Str: string): TStrings;
var
  DivStr: TStrings;
  Buffer: array [0..10] of char;
  Buffer1: array [0..3] of char;
  Buffer2: array [0..3] of char;
  Buffer3: array [0..3] of char;
  i,j,k: integer;
  flag: integer;
begin
  try
    DivStr := TStringlist.Create;
    flag := 0;
    i := 0;
    j := 0;
    k := StrLen(PChar(Str));
    StrCopy(Buffer1,PChar('   '));
    StrCopy(Buffer2,PChar('   '));
    StrCopy(Buffer3,PChar('   '));
    try
      StrCopy(Buffer,PChar(Str));
      for i:=0 to k do begin
        if (flag=0) and (Buffer[i]<>'.') and (Buffer[i]<>' ') then begin
          Buffer1[j] := Buffer[i];
          j := j+1;
        end;
        if (flag=1) and (Buffer[i]<>'.') and (Buffer[i]<>' ') then begin
          Buffer2[j] := Buffer[i];
          j := j+1;
        end;
        if (flag=2) and (Buffer[i]<>'.') and (Buffer[i]<>' ') then begin
          Buffer3[j] := Buffer[i];
          j := j+1;
        end;
        if Buffer[i]='.' then begin
          flag := flag+1;
          j := 0;
        end
      end;
      DivStr.Add(Trim(Buffer1));
      DivStr.Add(Trim(Buffer2));
      DivStr.Add(Trim(Buffer3));
    finally
//      DivStr.Free;
    end;
  except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
  Result := DivStr;
end;

function TakeFromSubkonto(IdAc: string; IdInSub: TStrings): TStrings;
var
  qr,qrsub: TIBQuery;
  sqls: string;
  Res,SubId: TStrings;
begin
  try
    Res := TStringList.Create;
    SubId := TStringList.Create;
    qr := TIBQuery.Create(nil);
    qr.Database:=Form1.IBDatabase;
    qr.Transaction := Form1.IBTransaction;
    qrsub := TIBQuery.Create(nil);
    qrsub.Database:=Form1.IBDatabase;
    qrsub.Transaction := Form1.IBTransaction;
     try
       sqls := 'select * from KINDSUBKONTO';
       qrsub.SQL.Add(sqls);
       qrsub.Open;
       sqls := 'Select * from PLANACCOUNTS where PA_ID='+IdAc;
       qr.SQL.Add(sqls);
       qr.Open;
       if not qr.IsEmpty then begin
         SubId.Add('');
         SubId.Add('');
         SubId.Add('');
         if (qr.FieldByName('PA_SUBKONTO1').AsString<>'0') and
            (qr.FieldByName('PA_SUBKONTO1').AsString<>'') then
           SubId[0] := qr.FieldByName('PA_SUBKONTO1').AsString;
         if (qr.FieldByName('PA_SUBKONTO2').AsString<>'0') and
            (qr.FieldByName('PA_SUBKONTO2').AsString<>'') then
           SubId[1] := qr.FieldByName('PA_SUBKONTO2').AsString;
         if (qr.FieldByName('PA_SUBKONTO3').AsString<>'0') and
            (qr.FieldByName('PA_SUBKONTO3').AsString<>'') then
           SubId[2] := qr.FieldByName('PA_SUBKONTO3').AsString;
       end;
       if (SubId[0]<>'') and (IdInSub.Count>1) then begin
         if not qrsub.Locate('SUBKONTO_ID',SubId[0],[loCaseInsensitive]) then
           Abort;
         sqls := 'select * from '+ Trim(qrsub.FieldByName('SUBKONTO_TABLENAME').AsString) +
                 ' where '+ Trim(qrsub.FieldByName('SUBKONTO_FIELDWITHID').AsString)+
                 '='+IdInSub[0];
         qr.SQL.Clear;
         qr.SQL.Add(sqls);
         qr.Open;
         if not qr.IsEmpty then
           Res.Add(Trim(qr.FieldByName(Trim(qrsub.FieldByName('SUBKONTO_FIELDWITHTEXT').AsString)).AsString));
       end;
       if (SubId[1]<>'') and (IdInSub.Count>2) then begin
         if not qrsub.Locate('SUBKONTO_ID',SubId[1],[loCaseInsensitive]) then
           Abort;
         sqls := 'select * from '+ Trim(qrsub.FieldByName('SUBKONTO_TABLENAME').AsString) +
                 ' where '+ Trim(qrsub.FieldByName('SUBKONTO_FIELDWITHID').AsString)+
                 '='+IdInSub[1];
         qr.SQL.Clear;
         qr.SQL.Add(sqls);
         qr.Open;
         if not qr.IsEmpty then
           Res.Add(Trim(qr.FieldByName(Trim(qrsub.FieldByName('SUBKONTO_FIELDWITHTEXT').AsString)).AsString));
       end;
       if (SubId[2]<>'') and (IdInSub.Count>2) then begin
         if not qrsub.Locate('SUBKONTO_ID',SubId[2],[loCaseInsensitive]) then
           Abort;
         sqls := 'select * from '+ Trim(qrsub.FieldByName('SUBKONTO_TABLENAME').AsString) +
                 ' where '+ Trim(qrsub.FieldByName('SUBKONTO_FIELDWITHID').AsString)+
                 '='+IdInSub[2];
         qr.SQL.Clear;
         qr.SQL.Add(sqls);
         qr.Open;
         if not qr.IsEmpty then
           Res.Add(Trim(qr.FieldByName(Trim(qrsub.FieldByName('SUBKONTO_FIELDWITHTEXT').AsString)).AsString));
       end;
       Result := Res;
    finally
      qr.Free;
      qrsub.Free;
      SubId.Free;
    end;
  except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

end.
