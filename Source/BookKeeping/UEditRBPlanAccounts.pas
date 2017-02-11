unit UEditRBPlanAccounts;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase,
  IB, IBCustomDataSet, IBTable, Mask, UFrameSubkonto{, UFrameSubkonto1};

type
  TfmEditRBPlanAccounts = class(TfmEditRB)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    MENum: TMaskEdit;
    ENam: TEdit;
    ENamAc: TEdit;
    Panel1: TPanel;
    CBCur: TCheckBox;
    CBAmount: TCheckBox;
    CBBal: TCheckBox;
    IBTable: TIBTable;
    PFindSaldo: TPanel;
    CBAct: TCheckBox;
    CBPas: TCheckBox;
    CBActPas: TCheckBox;
    PSaldo: TPanel;
    RBActPas: TRadioButton;
    RBPas: TRadioButton;
    RBAct: TRadioButton;
    Panel3: TPanel;
    FrameSub: TFrameSubkonto;
    procedure FormCreate(Sender: TObject);
    procedure EditChange(Sender: TObject);
    procedure RBActClick(Sender: TObject);
    procedure RBPasClick(Sender: TObject);
    procedure RBActPasClick(Sender: TObject);
    procedure bibClearClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    IdRec: Integer;
    Cur,Amo,Bal,ParentSaldo: string;
    SaldoID,ParentId: string;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBPlanAccounts: TfmEditRBPlanAccounts;

implementation

uses UBookKeepingCode, UBookKeepingData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBPlanAccounts.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;


function TfmEditRBPlanAccounts.AddToRBooks: Boolean;
var
  qr: TIBQuery;
  sqls, SaldoStr, TempStr, Account: string;
  List: TStrings;
  i: Integer;
begin
//  inherited;
// Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  List := TStringList.Create;
 try
//    id:=inttostr(oldalgorithm_id);//fmRBMilrank.MainQr.FieldByName('milrank_id').AsString;
    if (CBCur.Checked) then Cur := '*';
    if (CBAmount.Checked) then Amo := '*';
    if (CBBal.Checked) then Bal := '*';
    if RBAct.Checked then
      SaldoStr := RBAct.Caption;
    if RBPas.Checked then
      SaldoStr := RBPas.Caption;
    if RBActPas.Checked then
      SaldoStr := RBActPas.Caption;

    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;

    sqls := 'Select KS_ID from '+tbKindSaldo+' where KS_NAME='+''#39''+SaldoStr+''#39'';
    qr.SQL.Add(sqls);
    qr.Open;
    SaldoId := Trim(qr.FieldByName('KS_ID').AsString);
    qr.Active := false;

    List := divide(MENum.Text);

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

    if List.Strings[2]<>'' then begin
      sqls := 'Select * from '+tbPlanAccounts+' '+
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
      sqls := 'Select * from '+tbPlanAccounts+' '+
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

    if (ParentSaldo<>SaldoId) and (List.Strings[1]<>'') then begin
        Application.MessageBox(PChar('Для создаваемого субсчета сальдо'+
        ' должно быть таким же как у счета-папки'),PChar('Ошибка'), MB_OK+MB_ICONERROR);
        Abort;

    end;
    if (List.Strings[0]<>'') then begin
      Account := List.Strings[0];
      if (List.Strings[1]<>'') then begin
        Account := Account+'.'+List.Strings[1];
        if (List.Strings[2]<>'') then begin
          Account := Account+'.'+List.Strings[2];
        end;
      end;
    end;

    if not FrameSub.CheckFieldsFill then exit;

        sqls:='Insert into '+tbPlanAccounts+
          ' (PA_ID,PA_GROUPID,PA_PARENTID,PA_SHORTNAME,PA_CURRENCY,PA_AMOUNT,'+
          'PA_BALANCE,PA_KS_ID,PA_NAMEACCOUNT) values '+
          ' (gen_id(gen_planaccounts_id,1),'+QuotedStr(Trim(Account))+','+(Trim(ParentId))+','+QuotedStr(Trim(ENam.Text))+','+
           QuotedStr(Trim(Cur))+','+QuotedStr(Trim(Amo))+','+QuotedStr(Trim(Bal))+','+QuotedStr(Trim(SaldoId))+','+
           QuotedStr(Trim(ENamAc.Text))+')';

    qr.SQL.Clear;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    i:=1;
    while FrameSub.idSub[i]<>0 do begin
      sqls := 'Insert into '+tbPlanAccounts_KindSubkonto+
              '(PAKS_PA_ID,PAKS_SUBKONTO_ID,PAKS_LEVEL) values('+
              'gen_id(gen_planaccounts_id,0),'+
              QuotedStr(IntToStr(FrameSub.idSub[i]))+','+
              IntToStr(i+1)+')';
      qr.SQL.Clear;
      qr.SQL.Add(sqls);
      qr.ExecSQL;
      qr.Transaction.Commit;
      i:=i+1;
    end;

    Result:=true;

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
end;

procedure TfmEditRBPlanAccounts.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBPlanAccounts.UpdateRBooks: Boolean;
var
  qr: TIBQuery;
  sqls, SaldoStr, TempStr, Account: string;
  List: TStrings;
  i: Integer;
begin
 Result:=false;
 try
  // инициализация начальных значений
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  List := TStringList.Create;
  qr.Database:=IBDB;
  qr.Transaction:=IBTran;
  qr.Transaction.Active:=true;
  ParentId := IntToStr(IdRec);
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
    sqls := 'Select KS_ID from '+tbKindSaldo+' where KS_NAME='+''#39''+SaldoStr+''#39'';
    qr.SQL.Add(sqls);
    qr.Open;
    SaldoId := Trim(qr.FieldByName('KS_ID').AsString);
    qr.Active := false;
    //разбираем код счета по составляющим в -- List
    List := divide(MENum.Text);
    //анализируем код счета во избежания противоречий
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
      sqls := 'Select * from '+tbPlanAccounts+
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
      sqls := 'Select * from '+tbPlanAccounts+
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
    // тип сальдо у субсчета - такой же как у счета-папки
    if (ParentSaldo<>SaldoId) and (List.Strings[1]<>'') then begin
        Application.MessageBox(PChar('Для изменяемого субсчета сальдо'+
        ' должно быть таким же как у счета-папки'),PChar('Ошибка'), MB_OK+MB_ICONERROR);
        Abort;
    end;
    // тип сальдо у изменяемой счета-папки - должен остаться прежним
{    sqls := 'Select * from '+tbPlanAccounts+' where PA_ID Like('+QuotedStr(IntToStr(IdRec)+'%')+')'+
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
    end;}
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
        sqls:='Update '+tbPlanAccounts+
          ' set PA_GROUPID='+QuotedStr(Trim(Account))+','+'PA_PARENTID='+Trim(ParentId)+','+
          'PA_SHORTNAME='+QuotedStr(Trim(ENam.Text))+','+'PA_CURRENCY='+QuotedStr(Trim(Cur))+','+
          'PA_AMOUNT='+QuotedStr(Trim(Amo))+','+'PA_BALANCE='+QuotedStr(Trim(Bal))+','+
          'PA_KS_ID='+QuotedStr(Trim(SaldoId))+','+
          'PA_NAMEACCOUNT='+QuotedStr(Trim(ENamAc.Text))+
          ' where PA_ID=' + IntToStr(IdRec);


    qr.SQL.Clear;
    qr.SQL.Add(sqls);
    qr.ExecSQL;

    if FrameSub.ChangeFlag then begin
      sqls:='delete from '+tbPlanAccounts_KindSubkonto+
            ' where PAKS_PA_ID=' + IntToStr(IdRec);
      qr.SQL.Clear;
      qr.SQL.Add(sqls);
      qr.ExecSQL;
      i:=1;
      while FrameSub.idSub[i]<>0 do begin
        sqls := 'Insert into '+tbPlanAccounts_KindSubkonto+
                '(PAKS_PA_ID,PAKS_SUBKONTO_ID) values('+
                IntToStr(IdRec)+','+QuotedStr(IntToStr(FrameSub.idSub[i]))+')';
        qr.SQL.Clear;
        qr.SQL.Add(sqls);
        qr.ExecSQL;
        i:=i+1;
      end;
    end;

    qr.Transaction.Commit;

    Result:=true;
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
end;

procedure TfmEditRBPlanAccounts.ChangeClick(Sender: TObject);
begin
  if ChangeFlag or FrameSub.ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end;
  ModalResult:=mrOk;
end;

function TfmEditRBPlanAccounts.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(MENum.Text)='.   .' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[Label1.Caption]));
    MENum.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(ENam.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[Label2.Caption]));
    ENam.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(ENamAc.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[Label3.Caption]));
    ENamAc.SetFocus;
    Result:=false;
    exit;
  end;
  if not FrameSub.CheckFieldsFill then begin
    Result := false;
    exit;
  end;  
end;

procedure TfmEditRBPlanAccounts.EditChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBPlanAccounts.FormCreate(Sender: TObject);
var
  i,c: integer;
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);
  IBTable.Database:=IBDB;
  IBTable.TableName := AnsiUpperCase(tbKindSubkonto);
  IBTable.Active := True;
  Cur := '';
  Amo := '';
  Bal := '';
  ParentId := 'Null';
  ParentSaldo := '';
end;

procedure TfmEditRBPlanAccounts.RBActClick(Sender: TObject);
begin
  inherited;
//  RBAct.Checked := not RBAct.Checked;
  ChangeFlag:=true;
end;

procedure TfmEditRBPlanAccounts.RBPasClick(Sender: TObject);
begin
  inherited;
//  RBPas.Checked := not RBPas.Checked;
  ChangeFlag:=true;
end;

procedure TfmEditRBPlanAccounts.RBActPasClick(Sender: TObject);
begin
  inherited;
//  RBActPas.Checked := not RBActPas.Checked;
  ChangeFlag:=true;
end;

procedure TfmEditRBPlanAccounts.bibClearClick(Sender: TObject);
begin
  inherited;
  CBCur.Checked := false;
  CBAmount.Checked := false;
  CBBal.Checked := false;
  CBAct.Checked := false;
  CBPas.Checked := false;
  CBActPas.Checked := false;
end;

procedure TfmEditRBPlanAccounts.FormDestroy(Sender: TObject);
begin
  inherited;
  FrameSub.DeInitData;
end;

end.
