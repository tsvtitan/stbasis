unit UKassaKDMData;

interface

{$I stbasis.inc}

uses Windows, Forms, Classes, Controls, IBDatabase, UMainUnited, stdctrls,Sysutils,IBQuery,DB,extctrls;

var
  isInitAll: Boolean=false;
  IBDB,IBDBSec: TIBDatabase;
  IBT,IBTSec: TIBTransaction;
  TempStr: String;
  inistr: string;
  MainTypeLib: TTypeLib=ttleDefault;
  ListOptionHandles: TList;
  ListToolBarHandles: TList;
  ListInterfaceHandles: TList;
  ListMenuHandles: TList;

  // handles

  hInterfaceRbkCashBasis: THandle;
  hInterfaceRbkCashAppend: THandle;
  hInterfaceRbkKindSubkonto: THandle;
  hInterfaceRbkPlanAccounts: THandle;
  hInterfaceRbkCashOrders: THandle;
  hInterfaceRbkMagazinePostings: THandle;
  hInterfaceRbkSubkontoSubkonto: THandle;
  hInterfaceRptCashOrders: THandle;

  hMenuRBooks: THandle;
  hMenuRBooksKassa: THandle;
  hMenuRBooksCashBasis: THandle;
  hMenuRBooksCashAppend: THandle;
  hMenuRBooksKindSubkonto: THandle;
  hMenuRBooksPlanAccounts: THandle;
  hMenuRBooksCashOrders: THandle;
  hMenuRBooksMagazinePostings: THandle;
  hMenuRBooksSubkontoSubkonto: THandle;
  hMenuRpts: THandle;
  hMenuRptsKassa: THandle;
  hMenuRptsCashOrders: THandle;

  function divide(Str: string): TStrings;
  function TakeFromSubkonto(IdAc: string; IdInSub: TStrings): TStrings;
  function KillWhereFromWhereStr(WhereStr: String): String;
const
  LibraryHint='Библиотека содержит ...';
  ConstKassaAccount='50';
  ConstNowLevel='3';
//  ConstCashier = '';
 // ConstCurrency = '';

  // Ini Section
//  ConstSectionShortCut='KassaKDMHotKeys';

  // Interface Names
  ConstsMenuKassa='Касса';
  ConstsMenuRptKassa='Касса';
  NameRbkCashBasis='Справочник оснований';
  NameRbkCashAppend='Справочник приложений';
  NameRbkKindSubkonto='Справочник видов субконто';
  NameRbkPlanAccounts='План счетов';
  NameRbkCashOrders='Кассовые ордера';
  NameRbkEmp='Справочник сотрудников';
  NameRbkPersonDocType='Справочник видов документов удостоверяющих личность';
  NameRbkMagazinePostings='Журнал проводок';
  NameRbkCurrency='Справочник валют';
  NameRbkPlant='Справочник контрагентов';
  NameRbkBAnk='Справочник банков';
  NameRbkSubkontoSubkonto='Справочник связей субконто';
  NameRbkRateCurrency='Справочник курса валют';
  NameRptCashOrders='Отчет по кассовым ордерам';
  // Db Objects
  tbCashBasis='cashbasis';
  tbCashAppend='cashappend';
  tbKindSubkonto='kindsubkonto';
  tbPlanAccounts='planaccounts';
  tbKindSaldo='kindsaldo';
  tbCashOrders='cashorders';
  tbDocuments='documents';
  tbEmp='emp';
  tbMagazinePostings='magazinepostings';
  tbAccountType='accounttype';
  tbPersonDocType='persondoctype';
  tbConsts='consts';
  tbCurrency='currency';
  tbRateCurrency='ratecurrency';
  tbSubkontoSubkonto='Subkonto_Subkonto';
  tbPlanAccounts_KindSubkonto='PlanAccounts_KindSubkonto';
  tbConst='const';
  tbPlant='plant';
  tbConstex='constex';
  tbEmpPersonDoc='EmpPersonDoc';
  // Sqls

  SQLRbkCashBasis='Select * from '+tbCashBasis+' ';
  SQLRbkCashAppend='Select * from '+tbCashAppend+' ';
  SQLRbkKindSubkonto='Select * from '+tbKindSubkonto+' ';
  SQLRbkPlanAccounts='select p.*, KS_SHORTNAME '+
                     'from '+tbPlanAccounts+' p, '+tbKindSaldo+
                     ' where PA_KS_ID=KS_ID';
  SQLRbkCashOrders='select INC.*,D.DOK_NAME,P1.PA_GROUPID,P2.PA_GROUPID,'+
                   ' CB_TEXT,CA_TEXT,E1.FNAME,E2.FNAME '+
                   ' from '+tbCashOrders+' INC, '+tbDocuments+' D, '+tbPlanAccounts+' P1, '+tbPlanAccounts+' P2,'+
                    tbCashBasis+','+tbCashAppend+','+tbEmp+' E1, '+tbEmp+' E2'+
                   ' where INC.DOK_ID=D.DOK_ID AND INC.CO_KINDKASSA=P1.PA_ID AND INC.CO_IDKORACCOUNT=P2.PA_ID'+
                   ' AND CO_IDBASIS=CB_ID AND CO_IDAPPEND=CA_ID AND CO_CASHIER=E1.EMP_ID AND CO_EMP_ID=E2.EMP_ID';
  SQLRbkMagazinePostings='select DOK_NAME,m.*,P1.PA_GROUPID,P2.PA_GROUPID '+
                         'from '+tbMAGAZINEPOSTINGS+' m,'+tbPLANACCOUNTS+' P1,'+ tbPLANACCOUNTS+' P2,'+tbDOCUMENTS +
                         ' where MP_DEBETID=P1.PA_ID AND MP_CREDITID=P2.PA_ID AND MP_DOKUMENT=DOK_ID ';
  SQLRbkSubkontoSubkonto='select ss.*,ks1.subkonto_name,ks2.subkonto_name from '+tbSubkontoSubkonto+' ss,'+tbKindSubkonto+' ks1,'+tbKindSubkonto+' ks2 '+
                         'where ss_subkonto1=ks1.subkonto_id and ss_subkonto2=ks2.subkonto_id';

implementation
Uses UKassaKDMCode;
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
  TPRBI: TParamRBookInterface;
  qr,qrsub: TIBQuery;
  sqls: string;
  Res,SubId: TStrings;
  ch: Boolean;
begin
  try
    Res := TStringList.Create;
    Res.Add('');
    Res.Add('');
    Res.Add('');
    SubId := TStringList.Create;
    qr := TIBQuery.Create(nil);
    qr.Database:=IBDB;
    qr.Transaction := IBT;
    qrsub := TIBQuery.Create(nil);
    qrsub.Database:=IBDB;
    qrsub.Transaction := IBT;
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
         ch := qrsub.Locate('SUBKONTO_ID',SubId[0],[loCaseInsensitive]);
         if not qrsub.Locate('SUBKONTO_ID',SubId[0],[loCaseInsensitive]) then
           Abort;
         if IdInSub[0]<>'' then begin
            sqls := 'select * from '+ Trim(qrsub.FieldByName('SUBKONTO_TABLENAME').AsString) +
                   ' where '+ Trim(qrsub.FieldByName('SUBKONTO_FIELDWITHID').AsString)+
                   '='+IdInSub[0];
           qr.SQL.Clear;
           qr.SQL.Add(sqls);
           qr.Open;
           if not qr.IsEmpty then
             Res[0] := Trim(qr.FieldByName(Trim(qrsub.FieldByName('SUBKONTO_FIELDWITHTEXT').AsString)).AsString);
         end;
       end;
       if (SubId[1]<>'') and (IdInSub.Count>2) then begin
         if not qrsub.Locate('SUBKONTO_ID',SubId[1],[loCaseInsensitive]) then
           Abort;
         if IdInSub[1]<>'' then begin
           sqls := 'select * from '+ Trim(qrsub.FieldByName('SUBKONTO_TABLENAME').AsString) +
                   ' where '+ Trim(qrsub.FieldByName('SUBKONTO_FIELDWITHID').AsString)+
                   '='+IdInSub[1];
           qr.SQL.Clear;
           qr.SQL.Add(sqls);
           qr.Open;
           if not qr.IsEmpty then
             Res[1] := Trim(qr.FieldByName(Trim(qrsub.FieldByName('SUBKONTO_FIELDWITHTEXT').AsString)).AsString);
         end;
       end;
       if (SubId[2]<>'') and (IdInSub.Count>2) then begin
         if not qrsub.Locate('SUBKONTO_ID',SubId[2],[loCaseInsensitive]) then
           Abort;
         if IdInSub[2]<>'' then begin
           sqls := 'select * from '+ Trim(qrsub.FieldByName('SUBKONTO_TABLENAME').AsString) +
                   ' where '+ Trim(qrsub.FieldByName('SUBKONTO_FIELDWITHID').AsString)+
                   '='+IdInSub[2];
           qr.SQL.Clear;
           qr.SQL.Add(sqls);
           qr.Open;
           if not qr.IsEmpty then
             Res[2] := Trim(qr.FieldByName(Trim(qrsub.FieldByName('SUBKONTO_FIELDWITHTEXT').AsString)).AsString);
         end;
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

function KillWhereFromWhereStr(WhereStr: String): String;
begin
 Result := WhereStr;
 if AnsiPos('where',WhereStr)>0 then begin
   WhereStr := ' AND '+Copy(WhereStr,AnsiPos('where',WhereStr)+5,Length(WhereStr)-AnsiPos('where',WhereStr)-4);
   Result := WhereStr;
 end;
end;

end.
