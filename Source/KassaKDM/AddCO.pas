unit AddCO;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  WinMaket, StdCtrls, ComCtrls, Mask, IBQuery, Data, IB, PlanAccounts, DB,
  ExtCtrls;


type
  TFAddCO = class(TFMaket)
    LTitle: TLabel;
    Label2: TLabel;
    DateTime: TDateTimePicker;
    GroupBox1: TGroupBox;
    ESub1: TEdit;
    ESub2: TEdit;
    ESub3: TEdit;
    BKorAc: TButton;
    BSub1: TButton;
    BSub2: TButton;
    BSub3: TButton;
    Label3: TLabel;
    LSub1: TLabel;
    LSub2: TLabel;
    LSub3: TLabel;
    MEKorAc: TMaskEdit;
    EEmp: TEdit;
    LEmp: TLabel;
    BEmp: TButton;
    Label5: TLabel;
    EBasis: TEdit;
    BBasis: TButton;
    Label6: TLabel;
    EAppend: TEdit;
    BAppend: TButton;
    LSumDebit: TLabel;
    ESum: TEdit;
    CBNDS: TCheckBox;
    LNDS: TLabel;
    ENDS: TEdit;
    LNDS1: TLabel;
    ESumNDS: TEdit;
    BNDS: TButton;
    ENum: TEdit;
    ECur: TEdit;
    LCur: TLabel;
    BCur: TButton;
    RGKassa: TRadioGroup;
    EOnDoc: TEdit;
    LOnDoc: TLabel;
    ESumKredit: TEdit;
    LSumKredit: TLabel;
    BOnDoc: TButton;
    Label1: TLabel;
    ECashier: TEdit;
    BCashier: TButton;
    procedure FormCreate(Sender: TObject);
    procedure BOkClick(Sender: TObject);
    procedure BKorAcClick(Sender: TObject);
    procedure BSub1Click(Sender: TObject);
    procedure BSub2Click(Sender: TObject);
    procedure BSub3Click(Sender: TObject);
    procedure BEmpClick(Sender: TObject);
    procedure BBasisClick(Sender: TObject);
    procedure BAppendClick(Sender: TObject);
    procedure BCurClick(Sender: TObject);
    procedure RGKassaClick(Sender: TObject);
    procedure CBNDSClick(Sender: TObject);
    procedure BNDSClick(Sender: TObject);
    procedure BOnDocClick(Sender: TObject);
    procedure ESumKreditExit(Sender: TObject);
    procedure ESumExit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BCashierClick(Sender: TObject);
  private
  public
         TDoc,TDocId,Id,Date1,Time1,Kassa,KassaId,KorAc,CurID,Sub1,Sub2,Sub3,Debit,BasID,AppId,
         IsPay,NDSId,CashierId,MainBKId,EmpId,InSub1,InSub2,InSub3,Kredit,Director,OnDocId: string;
         qr: TIBQuery;
  end;

var
  FAddCO: TFAddCO;

implementation

uses Kassa;

{$R *.DFM}

procedure TFAddCO.FormCreate(Sender: TObject);
var
  sqls: string;
begin
  inherited;
  OnKeyDown := nil;
  OnKeyDown := FormKeyDown;
  qr:=TIBQuery.Create(nil);
  qr.Database:=Form1.IBDatabase;
  qr.Transaction:=Form1.IBTransaction;
  qr.Transaction.Active:=true;
  DateTime.Date := Date;
  TDoc := TempStr;
  TDocId := '0';

  sqls := 'select * from DOCUMENTS where Upper(DOK_NAME)='+AnsiUpperCase(QuotedStr(Trim(TDoc)));
  qr.SQL.Clear;
  qr.SQL.Add(sqls);
  qr.Open;
  if (qr.IsEmpty) then begin
    Application.MessageBox(PChar('Тип документа <'+TDoc+'> не существует'),PChar('Ошибка'),
    MB_OK+MB_ICONERROR);
    Abort;
  end
  else
    TDocId := Trim(qr.FieldByName('DOK_ID').AsString);
  qr.Active := false;

  sqls := 'select ICO_ID from CASHORDERS where DOK_ID = '+TDocId+' Order by ICO_ID';
  qr.SQL.Clear;
  qr.SQL.Add(sqls);
  qr.Open;
  qr.Last;
  ENum.Text := IntToStr(qr.FieldByName('ICO_ID').AsInteger + 1);

  Id := '0';
  Date1 := '0';
  Time1 := '0';
  Kassa := '50.1';
  KassaId :='0';
  KorAc := '0';
  CurId := 'NULL';
  Sub1 := 'NULL';
  Sub2 := 'NULL';
  Sub3 := 'NULL';
  InSub1 := 'NULL';
  InSub2 := 'NULL';
  InSub3 := 'NULL';
  Debit := '0';
  Kredit := '0';
  BasId := '0';
  AppId := '0';
//  IsPay := '';
  NDSId := 'NULL';
  CashierId := '0';
  MainBKId := '0';
  Director := 'NULL';
  EmpId := '0';
  OnDocId := 'NULL';
  if (TDoc='Расходный кассовый ордер') then begin
    LTitle.Caption := 'Расходный кассовый ордер №';
    LEmp.Caption := 'Выдать:';
    LSumDebit.Visible := false;
    ESum.Visible := false;
    LNDS.Visible := false;
    CBNDS.Visible := false;
    ENDS.Visible := false;
    BNDS.Visible := false;
    LNDS1.Visible := false;
    ESumNds.Visible := false;
    LOnDoc.Visible := true;
    EOnDoc.Visible := true;
    LSumKredit.Visible := true;
    ESumKredit.Visible := true;
    BOnDoc.Visible := true;
  end;

end;

procedure TFAddCO.BOkClick(Sender: TObject);
var
  sqls: string;
begin
  inherited;
 try
   Screen.Cursor:=crHourGlass;
   try
     //Ввод ID
     if (ENum.Text='') then begin
       Application.MessageBox(PChar('Не указан номер документа'),PChar('Ошибка'),
       MB_OK+MB_ICONERROR);
       Abort;
     end
     else begin
       try
         StrToInt(ENum.Text);
         sqls := 'select * from CASHORDERS where ICO_ID='+Id+
                 ' AND DOK_ID = '+ TDocId;
         qr.SQL.Clear;
         qr.SQL.Add(sqls);
         qr.Open;
         if qr.IsEmpty then
           Id := ENum.Text;
       except
         Application.MessageBox(PChar('Неверный номер документа'),PChar('Ошибка'),
         MB_OK+MB_ICONERROR);
         Abort;
       end;
     end;//конец ввода Id

     if KorAc='0' then begin
       Application.MessageBox(PChar('Невведен корреспондирующий счет'),PChar('Ошибка'),
       MB_OK+MB_ICONERROR);
       Abort;
     end;

     if EEmp.Text='' then begin
       Application.MessageBox(PChar('Невведен сотрудник'),PChar('Ошибка'),
       MB_OK+MB_ICONERROR);
       Abort;
     end;

     if BasId='0' then begin
       Application.MessageBox(PChar('Невведено основание'),PChar('Ошибка'),
       MB_OK+MB_ICONERROR);
       Abort;
     end;

     if (CBNDS.Checked) AND (NDSId='NULL') then begin
       Application.MessageBox(PChar('Невведена ставка НДС'),PChar('Ошибка'),
       MB_OK+MB_ICONERROR);
       Abort;
     end;

     if (Kassa='50.2') AND ((CurID='NULL') OR (CurId='0')) then begin
       Application.MessageBox(PChar('Невведена валюта'),PChar('Ошибка'),
       MB_OK+MB_ICONERROR);
       Abort;
     end;

     Date1 := DateToStr(DateTime.Date);

     Time1 := TimeToStr(Time);
     // ввод кассы
     sqls := 'select * from PLANACCOUNTS where PA_GROUPID='+QuotedStr(Kassa);
     qr.SQL.Clear;
     qr.SQL.Add(sqls);
     qr.Open;
     if (qr.IsEmpty) then begin
       Application.MessageBox(PChar('Счет <'+Kassa+'> не существует'),PChar('Ошибка'),
       MB_OK+MB_ICONERROR);
       Abort;
     end
     else begin
       KassaId := Trim(qr.FieldByName('PA_ID').AsString);
     end;// конец ввода кассы
     //проверка существования проводки
     if (TDoc='Расходный кассовый ордер') then
       sqls := 'select * from ACCOUNTTYPE where KREDIT in (select PA_ID from PLANACCOUNTS '+
               'where PA_GROUPID ='+QuotedStr(Kassa)+') AND '+
               'DEBIT = '+KorAc;
     if (TDoc='Приходный кассовый ордер') then
       sqls := 'select * from ACCOUNTTYPE where DEBIT in (select PA_ID from PLANACCOUNTS '+
               'where PA_GROUPID ='+QuotedStr(Kassa)+') AND '+
               'KREDIT = '+KorAc;
     qr.SQL.Clear;
     qr.SQL.Add(sqls);
     qr.Open;
     if (qr.IsEmpty) then begin
       if (Application.MessageBox(PChar('Для счета <'+MEKorAc.Text+'> нет корректной проводки'),PChar('Предупреждение'),
           MB_OKCANCEL+MB_ICONWARNING)=ID_CANCEL) then
         Abort;
     end;
    //конец проверки
     //ввод суммы
     if ESum.Visible then
     if ESum.Text='' then begin
       Application.MessageBox(PChar('Не указана сумма'),PChar('Ошибка'),
       MB_OK+MB_ICONERROR);
       Abort;
     end
     else begin
       try
         StrToFloat(ESum.Text);
         Debit := ESum.Text;
       except
         Application.MessageBox(PChar('Неверная сумма'),PChar('Ошибка'),
         MB_OK+MB_ICONERROR);
         Abort;
       end;
     end;//конец ввода суммы

     if (EOnDoc.Visible) AND (OnDocId='NULL')then begin
       Application.MessageBox(PChar('Невведен документ'),PChar('Ошибка'),
       MB_OK+MB_ICONERROR);
       Abort;
     end;

     //ввод суммы
     if ESumKredit.Visible then
     if ESumKredit.Text='' then begin
       Application.MessageBox(PChar('Не указана сумма'),PChar('Ошибка'),
       MB_OK+MB_ICONERROR);
       Abort;
     end
     else begin
       try
         StrToFloat(ESumKredit.Text);
         Debit := ESumKredit.Text;
       except
         Application.MessageBox(PChar('Неверная сумма'),PChar('Ошибка'),
         MB_OK+MB_ICONERROR);
         Abort;
       end;
     end;//конец ввода суммы
     //ввод кассира с главным бухгалтером и директора
     sqls := 'select EMPACCOUNT_ID,EMPBOSS_ID from CONST';
     qr.SQL.Clear;
     qr.SQL.Add(sqls);
     qr.Open;
     if (not qr.IsEmpty) then begin
       qr.Last;
//       CashierId := qr.FieldByName('CASHIER').AsString;
       MainBKId := qr.FieldByName('EMPACCOUNT_ID').AsString;
       Director := qr.FieldByName('EMPBOSS_ID').AsString;
     end;
     qr.Close;
     //конец ввода кассира с главным бухгалтером

     if CashierId='0' then begin
       Application.MessageBox(PChar('Неуказан кассир'),PChar('Ошибка'),
       MB_OK+MB_ICONERROR);
       Abort;
     end;

     if ESumKredit.Visible then begin
       sqls := 'Insert into CASHORDERS'+
               ' (ICO_ID,DOK_ID,CO_DATE,CO_TIME,CO_KINDKASSA,CO_CURRENCY_ID,CO_IDKORACCOUNT,'+
               'CO_IDINSUBKONTO1,CO_IDINSUBKONTO2,CO_IDINSUBKONTO3,CO_KREDIT,CO_IDBASIS,'+
               'CO_IDAPPEND,CO_CASHIER,CO_MAINBOOKKEEPER,CO_EMP_ID,CO_PERSONDOCTYPE_ID,CO_DIRECTOR) values ('+
                Id+','+TDocId+','+QuotedStr(Date1)+','+QuotedStr(Time1)+','+KassaId+','+CurId+','+KorAc+','+
                InSub1+','+InSub2+','+InSub3+','+Kredit+','+BasId+','+AppId+','+
                CashierId+','+MainBKId+','+EmpId+','+OnDocId+','+Director+')';
     end
     else begin
       sqls := 'Insert into CASHORDERS'+
               ' (ICO_ID,DOK_ID,CO_DATE,CO_TIME,CO_KINDKASSA,CO_CURRENCY_ID,CO_IDKORACCOUNT,'+
               'CO_IDINSUBKONTO1,CO_IDINSUBKONTO2,CO_IDINSUBKONTO3,CO_DEBIT,CO_IDBASIS,'+
               'CO_IDAPPEND,CO_IDNDS,CO_CASHIER,CO_MAINBOOKKEEPER,CO_EMP_ID,CO_DIRECTOR) values ('+
                Id+','+TDocId+','+QuotedStr(Date1)+','+QuotedStr(Time1)+','+KassaId+','+CurId+','+KorAc+','+
                InSub1+','+InSub2+','+InSub3+','+Debit+','+BasId+','+AppId+','+NDSId+','+
                CashierId+','+MainBKId+','+EmpId+','+Director+')';
     end;
     qr.SQL.Clear;
     qr.SQL.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;
     qr.Transaction.Active := True;
     
     if ESumKredit.Visible then begin
       sqls := 'Insert into MAGAZINEPOSTINGS '+
               '(MP_ID,MP_DOKUMENT,MP_DOCUMENTID,MP_IDINDOCUMENT,MP_DATE,MP_TIME,'+
               'MP_DEBETID,MP_SUBKONTODT1,MP_SUBKONTODT2,MP_SUBKONTODT3,MP_CREDITID,'+
               'MP_SUBKONTOKT1,MP_SUBKONTOKT2,MP_SUBKONTOKT3,MP_CONTENTSOPERA,'+
               'MP_CONTENTSPOSTI,MP_COUNT,MP_SUMMA,MP_CURRENCY_ID) values('+
               'gen_id(gen_mp_id,1)'+','+TDocId+','+Id+','+'0'+','+QuotedStr(Date1)+','+
               QuotedStr(Time1)+','+KorAc+','+InSub1+','+InSub2+','+InSub3+','+KassaId+
               ','+'NULL'+','+'NULL'+','+'NULL'+','+QuotedStr('Выдача из кассы:'+EBasis.Text)+
               ','+QuotedStr('Расход')+','+'NULL'+','+Kredit+','+CurId+')';
     end
     else begin
       sqls := 'Insert into MAGAZINEPOSTINGS '+
               '(MP_ID,MP_DOKUMENT,MP_DOCUMENTID,MP_IDINDOCUMENT,MP_DATE,MP_TIME,'+
               'MP_DEBETID,MP_SUBKONTODT1,MP_SUBKONTODT2,MP_SUBKONTODT3,MP_CREDITID,'+
               'MP_SUBKONTOKT1,MP_SUBKONTOKT2,MP_SUBKONTOKT3,MP_CONTENTSOPERA,'+
               'MP_CONTENTSPOSTI,MP_COUNT,MP_SUMMA,MP_CURRENCY_ID) values('+
               'gen_id(gen_mp_id,1)'+','+TDocId+','+Id+','+'0'+','+QuotedStr(Date1)+','+
               QuotedStr(Time1)+','+KassaId+','+'NULL'+','+'NULL'+','+'NULL'+','+KorAc+
               ','+InSub1+','+InSub2+','+InSub3+','+QuotedStr('Поступление в кассу:'+EBasis.Text)+
               ','+QuotedStr('Приход')+','+'NULL'+','+Debit+','+CurId+')';
     end;
     qr.SQL.Clear;
     qr.SQL.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;
     qr.Transaction.Active := True;
   finally
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

procedure TFAddCO.BKorAcClick(Sender: TObject);
var
   fm: TPlanAc;
   sqls: string;
begin
  inherited;
  try
  MView := True;
  fm := TPlanAc.Create(nil);
  MView := false;
  fm.Visible := false;
  try
    TempList.Clear;
    sqls := 'select * from PLANACCOUNTS where PA_GROUPID ='+QuotedStr(Kassa);
    qr.SQL.Clear;
    qr.SQL.Add(sqls);
    qr.Open;
    if not qr.IsEmpty then begin
      if (TDoc='Расходный кассовый ордер') then
        fm.SetCondition('PA_ID IN (select DEBIT from ACCOUNTTYPE WHERE KREDIT='+
                       qr.FieldByname('PA_ID').AsString+')');
      if (TDoc='Приходный кассовый ордер') then
        fm.SetCondition('PA_ID IN (select KREDIT from ACCOUNTTYPE WHERE DEBIT='+
                       qr.FieldByname('PA_ID').AsString+')');
    end;
    if fm.ShowModal=mrOk then begin
      KorAc := Trim(TempList[0]);
      sqls := 'select * from PLANACCOUNTS where PA_ID='+KorAc;
      qr.SQL.Clear;
      qr.SQL.Add(sqls);
      qr.Open;
      MEKorAc.Text := Trim(qr.FieldByName('PA_GROUPID').AsString);
      Sub1 := Trim(qr.FieldByName('PA_SUBKONTO1').AsString);
      Sub2 := Trim(qr.FieldByName('PA_SUBKONTO2').AsString);
      Sub3 := Trim(qr.FieldByName('PA_SUBKONTO3').AsString);
      sqls := ' select * from KINDSUBKONTO';
      qr.SQL.Clear;
      qr.SQL.Add(sqls);
      qr.Open;
      if Sub1<>'0' then begin
        BSub1.Visible := True;
        qr.Locate('SUBKONTO_ID', Sub1, [loCaseInsensitive]);
        LSub1.Caption := Trim(qr.FieldByName('SUBKONTO_NAME').AsString);
      end
      else begin
        BSub1.Visible := false;
        ESub1.Text := '';
        LSub1.Caption := '';
      end;
      if Sub2<>'0' then begin
        BSub2.Visible := True;
        qr.Locate('SUBKONTO_ID', Sub2, [loCaseInsensitive]);
        LSub2.Caption := Trim(qr.FieldByName('SUBKONTO_NAME').AsString);
      end
      else begin
        BSub2.Visible := false;
        ESub2.Text := '';
        LSub2.Caption := '';
      end;
      if Sub3<>'0' then begin
        BSub3.Visible := True;
        qr.Locate('SUBKONTO_ID', Sub3, [loCaseInsensitive]);
        LSub3.Caption := Trim(qr.FieldByName('SUBKONTO_NAME').AsString);
      end
      else begin
        BSub3.Visible := false;
        LSub3.Caption := '';
        ESub3.Text := '';
      end;
    end;
  finally
    fm.free;
    sqls := 'select * from PLANACCOUNTS where PA_PARENTID='+KorAc+' AND PA_ID<>'+KorAc;
    qr.SQL.Clear;
    qr.SQL.Add(sqls);
    qr.Open;
    if not qr.IsEmpty then begin
      Application.MessageBox(PChar('Введите субсчет счета'),PChar('Ошибка'),
      MB_OK+MB_ICONERROR);
      KorAc := '0';
      MEKorAc.Text := '';
      Abort;
    end;
    TempList.Clear;
  end;
  except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TFAddCO.BSub1Click(Sender: TObject);
var
   sqls: string;
   IdList: Tstrings;
begin
  inherited;
  try
    IdList := TStringList.Create;
    try
      sqls := ' select * from KINDSUBKONTO';
      qr.SQL.Clear;
      qr.SQL.Add(sqls);
      qr.Open;
      qr.Locate('SUBKONTO_ID', Sub1, [loCaseInsensitive]);
      IdList := CreateForms(UpperCase(qr.FieldByName('SUBKONTO_TABLENAME').AsString),'');
      if IdList.Count<>0 then begin
        InSub1 := IdList[0];
        ESub1.Text := IdList[1];
        if UpperCase(qr.FieldByName('SUBKONTO_TABLENAME').AsString)='PLANT' then begin
          EEmp.Text := ESub1.Text;
          BEmp.Enabled := false;
          EmpId:='0';
        end
        else
          BEmp.Enabled := true;
      end;
    finally
      IdList.Free;
      TempList.Clear;
    end;
  except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TFAddCO.BSub2Click(Sender: TObject);
var
   sqls: string;
   IdList: Tstrings;
begin
  inherited;
  try
    IdList := TStringList.Create;
    try
      sqls := ' select * from KINDSUBKONTO';
      qr.SQL.Clear;
      qr.SQL.Add(sqls);
      qr.Open;
      qr.Locate('SUBKONTO_ID', Sub2, [loCaseInsensitive]);
      IdList := CreateForms(UpperCase(qr.FieldByName('SUBKONTO_TABLENAME').AsString),'');
      if IdList.Count<>0 then begin
        InSub2 := IdList[0];
        ESub2.Text := IdList[1];
        if UpperCase(qr.FieldByName('SUBKONTO_TABLENAME').AsString)='PLANT' then begin
          EEmp.Text := ESub1.Text;
          BEmp.Enabled := false;
          EmpId:='0';
        end
        else
          BEmp.Enabled := true;
      end;
    finally
      IdList.Free;
      TempList.Clear;
    end;
  except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TFAddCO.BSub3Click(Sender: TObject);
var
   sqls: string;
   IdList: Tstrings;
begin
  inherited;
  try
    IdList := TStringList.Create;
    try
      sqls := ' select * from KINDSUBKONTO';
      qr.SQL.Clear;
      qr.SQL.Add(sqls);
      qr.Open;
      qr.Locate('SUBKONTO_ID', Sub3, [loCaseInsensitive]);
      IdList := CreateForms(UpperCase(qr.FieldByName('SUBKONTO_TABLENAME').AsString),'');
      if IdList.Count<>0 then begin
        InSub3 := IdList[0];
        ESub3.Text := IdList[1];
        if UpperCase(qr.FieldByName('SUBKONTO_TABLENAME').AsString)='PLANT' then begin
          EEmp.Text := ESub1.Text;
          BEmp.Enabled := false;
          EmpId:='0';
        end
        else
          BEmp.Enabled := true;
      end;
    finally
      IdList.Free;
      TempList.Clear;
    end;
  except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TFAddCO.BEmpClick(Sender: TObject);
var
   sqls: string;
   IdList: Tstrings;
begin
  inherited;
  try
    IdList := TStringList.Create;
    try
      IdList := CreateForms('EMP','');
      if IdList.Count<>0 then begin
        EmpId := IdList[0];
        EEmp.Text := IdList[1]+' '+IdList[2]+' '+IdList[3];
      end;
    finally
      IdList.Free;
      TempList.Clear;
    end;
  except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TFAddCO.BBasisClick(Sender: TObject);
var
   sqls: string;
   IdList: Tstrings;
begin
  inherited;
  try
    IdList := TStringList.Create;
    try
      IdList := CreateForms('CASHBASIS','');
      if IdList.Count<>0 then begin
        BasId := IdList[0];
        EBasis.Text := IdList[1];
      end;
    finally
      IdList.Free;
      TempList.Clear;
    end;
  except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TFAddCO.BAppendClick(Sender: TObject);
var
   sqls: string;
   IdList: Tstrings;
begin
  inherited;
  try
    IdList := TStringList.Create;
    try
      IdList := CreateForms('CASHAPPEND','');
      if IdList.Count<>0 then begin
        AppId := IdList[0];
        EAppend.Text := IdList[1];
      end;
    finally
      IdList.Free;
      TempList.Clear;
    end;
  except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TFAddCO.BCurClick(Sender: TObject);
var
   IdList: Tstrings;
begin
  inherited;
  try
    IdList := TStringList.Create;
    try
      IdList := CreateForms('CURRENCY','');
      if IdList.Count<>0 then begin
        CurId := IdList[0];
        ECur.Text := IdList[1];
      end;
    finally
      IdList.Free;
      TempList.Clear;
    end;
  except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TFAddCO.RGKassaClick(Sender: TObject);
begin
  inherited;
  if RGKassa.ItemIndex = 1 then begin
    LCur.Visible := true;
    ECur.Visible := true;
    BCur.Visible := true;
  end
  else begin
    LCur.Visible := false;
    ECur.Visible := false;
    BCur.Visible := false;
    CurId := 'NULL';
  end;
  case RGKassa.ItemIndex of
    0: Kassa := '50.1';
    1: Kassa := '50.2';
  end;
end;

procedure TFAddCO.CBNDSClick(Sender: TObject);
begin
  inherited;
  if CBNDS.Checked=true then begin
    LNDS.Enabled := true;
    BNDS.Enabled := true;
    ENDS.Enabled := true;
    LNDS1.Enabled := true;
    ESumNDS.Enabled := true;
  end
  else begin
    LNDS.Enabled := false;
    BNDS.Enabled := false;
    ENDS.Enabled := false;
    LNDS1.Enabled := false;
    ESumNDS.Enabled := false;
    ESumNDS.Text := '';
    ENDS.Text := '';
    NDSId := 'NULL';
  end;
end;

procedure TFAddCO.BNDSClick(Sender: TObject);
var
   IdList: TStrings;
   a,b,c: Double;
begin
  inherited;
  try
    IdList := TStringList.Create;
    try
      IdList := CreateForms('NDS','');
      if IdList.Count<>0 then begin
        NDSId := IdList[0];
        ENDS.Text := IdList[1];
        a := StrToInt(ENDS.Text)/100;
        b := StrToInt(ESum.Text);
        c := a*b;
        ESumNDS.Text := FloatToStr(c);
      end;
    finally
      IdList.Free;
      TempList.Clear;
    end;
  except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TFAddCO.BOnDocClick(Sender: TObject);
var
   IdList: Tstrings;
   sqls,param: string;
begin
  inherited;
  try
    IdList := TStringList.Create;
    try
      if EmpId='0' then Abort;
      param := 'EMP_ID='+EmpId;
      IdList := CreateForms('EMPPERSONDOC',param);
      if IdList.Count<>0 then begin
        OnDocId := IdList[0];
        sqls := 'select * from PERSONDOCTYPE where PERSONDOCTYPE_ID='+OnDocId;
        qr.SQL.Clear;
        qr.SQL.Add(sqls);
        qr.Open;
        if not qr.IsEmpty then
          EOnDoc.Text := Trim(qr.FieldByName('SMALLNAME').AsString)+' '+IdList[1]+
                         ' '+IdList[2];
      end;
    finally
      IdList.Free;
      TempList.Clear;
    end;
  except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TFAddCO.ESumKreditExit(Sender: TObject);
begin
  inherited;
  try
    StrToFloat(ESumKredit.Text);
    Kredit := ESumKredit.Text;
  except
     Application.MessageBox(PChar('Неверная сумма'),PChar('Ошибка'),
     MB_OK+MB_ICONERROR);
     Abort;
  end;
end;

procedure TFAddCO.ESumExit(Sender: TObject);
var
   a,b,c: Double;
begin
  inherited;
  try
    StrToFloat(ESum.Text);
    Debit := ESum.Text;
    if (CBNDS.Checked) AND (ESumNDS.TEXT<>'') then begin
      a := StrToInt(ENDS.Text)/100;
      b := StrToInt(ESum.Text);
      c := a*b;
      ESumNDS.Text := FloatToStr(c);
    end;
  except
     Application.MessageBox(PChar('Неверная сумма'),PChar('Ошибка'),
     MB_OK+MB_ICONERROR);
     Abort;
  end;

end;

procedure TFAddCO.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
 Case Key of
  VK_Enter: begin
            BOk.OnClick(nil);
            end;
  VK_ESC: begin
          BCancel.OnClick(nil);
          end;
  end;

end;

procedure TFAddCO.BCashierClick(Sender: TObject);
var
   sqls: string;
   IdList: Tstrings;
begin
  inherited;
  try
    IdList := TStringList.Create;
    try
      IdList := CreateForms('EMP','');
      if IdList.Count<>0 then begin
        CashierId := IdList[0];
        ECashier.Text := IdList[1]+' '+IdList[2]+' '+IdList[3];
      end;
    finally
      IdList.Free;
      TempList.Clear;
    end;
  except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

end.
