unit EditPA;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  AddPlanAc, Db, IBCustomDataSet, IBTable, StdCtrls, ExtCtrls, Mask, IBQuery,
  Kassa, IB, Data;

type
  TFEditAccount = class(TFAddAccount)
  procedure CreateForm(Sender: TObject);
  procedure BOkClick1(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FEditAccount: TFEditAccount;

implementation

procedure TFEditAccount.CreateForm(Sender: TObject);
begin
 Caption:='Изменить';
 BOk.OnClick := BOkClick1;
end;

procedure TFEditAccount.BOkClick1(Sender: TObject);
var
  qr: TIBQuery;
  sqls, SaldoStr, TempStr, Account: string;
  Cur,Amo,Bal,ParentSaldo: string;
  SaldoID,Sub1Id,Sub2Id,Sub3Id,ParentId: string;
  List: TStrings;
begin
  inherited;
// Result:=false;
 try
  // инициализация начальных значений
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  List := TStringList.Create;
  Cur := '';
  Amo := '';
  Bal := '';
  Sub1Id := '0';
  Sub2Id := '0';
  Sub3Id := '0';
  ParentId := IntToStr(IdRec);
  ParentSaldo := '';
  qr.Database:=Form1.IBDatabase;
  qr.Transaction:=Form1.IBTransaction;
  qr.Transaction.Active:=true;
  try
//    id:=inttostr(oldalgorithm_id);//fmRBMilrank.MainQr.FieldByName('milrank_id').AsString;
    //проверка выбранного типа счета
    if (CBCur.Checked) then Cur := '*';
    if (CBAmount.Checked) then Amo := '*';
    if (CBBal.Checked) then Bal := '*';
    //формируем SaldoStr для организации поиска соответствующего ID в таблице типов сальдо
    if RBAct.Checked then
      SaldoStr := RBAct.Caption;
    if RBPas.Checked then
      SaldoStr := RBPas.Caption;
    if RBActPas.Checked then
      SaldoStr := RBActPas.Caption;
    //сам поиск
    sqls := 'Select KS_ID from KINDSALDO where KS_NAME='+''#39''+SaldoStr+''#39'';
    qr.SQL.Add(sqls);
    qr.Open;
    SaldoId := Trim(qr.FieldByName('KS_ID').AsString);
    qr.Active := false;
    // определяем какие субконто заполнены и фомируем соответсвующие ID
    if CBSub1.Text<>'' then begin
      IBTable.Locate('SUBKONTO_NAME',CBSub1.Text,[loCaseInsensitive]);
      Sub1Id := Trim(IBTable.FieldByName('SUBKONTO_ID').AsString);
    end;
    if CBSub2.Text<>'' then begin
      IBTable.Locate('SUBKONTO_NAME',CBSub2.Text,[loCaseInsensitive]);
      Sub2Id := Trim(IBTable.FieldByName('SUBKONTO_ID').AsString);
    end;
    if CBSub3.Text<>'' then begin
      IBTable.Locate('SUBKONTO_NAME',CBSub3.Text,[loCaseInsensitive]);
      Sub3Id := Trim(IBTable.FieldByName('SUBKONTO_ID').AsString);
    end;
    //разбираем код счета по составляющим в -- List
    List := divide(MENum.Text);
    //анализируем код счета во избежаний противоречий
    if (List.Strings[2]<>'') and ((List.Strings[0]='') or (List.Strings[1]='')) then begin
      Application.MessageBox(PChar('Некорректный ввод номера счета'),PChar('Ошибка'),
      MB_OK+MB_ICONERROR);
      Abort;
    end;
    if (List.Strings[1]<>'') and (List.Strings[2]='') and (List.Strings[0]='') then begin
      Application.MessageBox(PChar('Некорректный ввод номера счета'),PChar('Ошибка'),
      MB_OK+MB_ICONERROR);
      Abort;
    end;
    //анализируем код счета - для правильной организации древовидной структуры
    if List.Strings[2]<>'' then begin
      //поиск папки родителя
      sqls := 'Select * from PLANACCOUNTS'+
              ' where PA_GROUPID Like('#39''+List.Strings[0]+'.'+List.Strings[1]+''#39')';
      qr.Active := false;
      qr.SQL.Clear;
      qr.SQL.Add(sqls);
      qr.Open;
      if (qr.IsEmpty) then begin
        Application.MessageBox(PChar('Для создаваемого субсчета <'+List.Strings[0]+'.'+
        List.Strings[1]+'.'+List.Strings[2]+'> нет счета-папки <'+List.Strings[0]+'.'+
        List.Strings[1]+'>'),PChar('Ошибка'), MB_OK+MB_ICONERROR);
        Abort;
      end
      else begin
        ParentId := Trim(qr.FieldByName('PA_ID').AsString);
        ParentSaldo := Trim(qr.FieldByName('PA_KS_ID').AsString);
      end;
    end;
    if (List.Strings[1]<>'') and (List.Strings[2]='') then begin
      sqls := 'Select * from PLANACCOUNTS'+
              ' where PA_GROUPID Like('#39''+List.Strings[0]+''#39')';
      qr.Active := false;
      qr.SQL.Clear;
      qr.SQL.Add(sqls);
      qr.Open;
      if (qr.IsEmpty) then begin
        Application.MessageBox(PChar('Для создаваемого субсчета <'+List.Strings[0]+'.'+
        List.Strings[1]+'> нет счета-папки <'+List.Strings[0]+'>'),PChar('Ошибка'), MB_OK+MB_ICONERROR);
        Abort;
      end
      else begin
        ParentId := Trim(qr.FieldByName('PA_ID').AsString);
        ParentSaldo := Trim(qr.FieldByName('PA_KS_ID').AsString);
      end;
    end;
    //исключаем возможность пустого ввода значения
    if (ENam.Text='')or (ENamAc.Text='') then begin
      Application.MessageBox(PChar('Введите имя и полное наименование'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
      Abort;
    end;
    // тип сальдо у субсчета - такой же как у счета-папки
    if (ParentSaldo<>SaldoId) and (List.Strings[1]<>'') then begin
        Application.MessageBox(PChar('Для изменяемого субсчета сальдо'+
        ' должно быть таким же как у счета-папки'),PChar('Ошибка'), MB_OK+MB_ICONERROR);
        Abort;
    end;
    // тип сальдо у изменяемой счета-папки - должен остаться прежним
    sqls := 'Select * from PLANACCOUNTS where PA_ID Like('+QuotedStr(IntToStr(IdRec)+'%')+')'+
            ' and PA_ID<>'+IntToStr(IdRec);
    qr.SQL.Clear;
    qr.SQL.Add(sqls);
    qr.Open;
    if not qr.IsEmpty then begin
      if (Trim(qr.FieldByName('PA_KS_ID').AsString)<>SaldoId) then begin
        Application.MessageBox(PChar('Для изменяемого счета-папки сальдо'+
        ' должно быть таким же как и у его субсчета'),PChar('Ошибка'), MB_OK+MB_ICONERROR);
        Abort;
      end;
    end;
    //формируем код счета
    if (List.Strings[0]<>'') then begin
      Account := List.Strings[0];
      if (List.Strings[1]<>'') then begin
        Account := Account+'.'+List.Strings[1];
        if (List.Strings[2]<>'') then begin
          Account := Account+'.'+List.Strings[2];
        end;
      end;
    end;
        sqls:='Update PLANACCOUNTS'+
          ' set PA_GROUPID='+QuotedStr(Trim(Account))+','+'PA_PARENTID='+Trim(ParentId)+','+
          'PA_SHORTNAME='+QuotedStr(Trim(ENam.Text))+','+'PA_CURRENCY='+QuotedStr(Trim(Cur))+','+
          'PA_AMOUNT='+QuotedStr(Trim(Amo))+','+'PA_BALANCE='+QuotedStr(Trim(Bal))+','+
          'PA_KS_ID='+QuotedStr(Trim(SaldoId))+','+'PA_SUBKONTO1='+Trim(Sub1Id)+','+
          'PA_SUBKONTO2='+Trim(Sub2Id)+','+'PA_SUBKONTO3='+Trim(Sub3Id)+','+
          'PA_NAMEACCOUNT='+QuotedStr(Trim(ENamAc.Text))+
          ' where PA_ID=' + IntToStr(IdRec);


    qr.SQL.Clear;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

//    Result:=true;
  finally
    qr.Free;
    List.Free;
    Screen.Cursor:=crDefault;
  end;
 except
  on E: EIBInterBaseError do begin
    TempStr:=TranslateIBError(E.Message);
    ShowError(Handle,TempStr);
    Assert(false,TempStr);
  end;
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
 ModalResult := mrOk;
end;

end.
