unit EditCO;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  AddCO, ExtCtrls, StdCtrls, Mask, ComCtrls, IB, Data;

type
  TFEditCO = class(TFAddCO)
    procedure FormCreate(Sender: TObject);
    procedure BOkClick1(Sender: TObject);
  private
    { Private declarations }
  public
    OldTDoc : string;
    OldId : string;
  end;

var
  FEditCO: TFEditCO;

implementation

{$R *.DFM}

procedure TFEditCO.FormCreate(Sender: TObject);
begin
  inherited;
  BOk.OnClick := nil;
  BOk.OnClick := BOkClick1;
end;

procedure TFEditCO.BOkClick1(Sender: TObject);
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
     else
       KassaId := Trim(qr.FieldByName('PA_ID').AsString);// конец ввода кассы
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
     if ESumKredit.Visible then
     sqls := 'Update CASHORDERS'+
             ' set ICO_ID='+Id+','+'DOK_ID='+TDocId+','+'CO_DATE='+QuotedStr(Date1)+','+
             'CO_TIME='+QuotedStr(Time1)+','+'CO_KINDKASSA='+KassaId+','+'CO_CURRENCY_ID='+
              CurId+','+'CO_IDKORACCOUNT='+KorAc+','+'CO_IDINSUBKONTO1='+InSub1+','+
             'CO_IDINSUBKONTO2='+InSub2+','+'CO_IDINSUBKONTO3='+InSub3+','+'CO_KREDIT='+
              Kredit+','+'CO_IDBASIS='+BasId+','+'CO_IDAPPEND='+AppId+','+'CO_CASHIER='+
             CashierId+','+'CO_MAINBOOKKEEPER='+MainBKId+','+'CO_EMP_ID='+EmpId+','+
             'CO_PERSONDOCTYPE_ID='+OnDocId+','+'CO_DIRECTOR='+Director+
             ' where ICO_ID='+OldId+' AND DOK_ID='+OldTDoc
     else
     sqls := 'Update CASHORDERS'+
             ' set ICO_ID='+Id+','+'DOK_ID='+TDocId+','+'CO_DATE='+QuotedStr(Date1)+','+
             'CO_TIME='+QuotedStr(Time1)+','+'CO_KINDKASSA='+KassaId+','+'CO_CURRENCY_ID='+
              CurId+','+'CO_IDKORACCOUNT='+KorAc+','+'CO_IDINSUBKONTO1='+InSub1+','+
             'CO_IDINSUBKONTO2='+InSub2+','+'CO_IDINSUBKONTO3='+InSub3+','+'CO_DEBIT='+
              Debit+','+'CO_IDBASIS='+BasId+','+'CO_IDAPPEND='+AppId+','+'CO_IDNDS='+
              NDSId+','+'CO_CASHIER='+CashierId+','+'CO_MAINBOOKKEEPER='+MainBKId+','+
             'CO_EMP_ID='+EmpId+' where ICO_ID='+OldId+'AND DOK_ID='+OldTDoc;
     qr.SQL.Clear;
     qr.SQL.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;
     qr.Transaction.Active := True;
     sqls := 'select * from MAGAZINEPOSTINGS where MP_DOKUMENT='+TDocId+' AND '+
             'MP_DOCUMENTID='+OldId+' AND MP_IDINDOCUMENT=0';
     qr.SQL.Clear;
     qr.SQL.Add(sqls);
     qr.Open;
     if not qr.IsEmpty then begin
       Application.MessageBox(PChar('Проводка будет перепроведена!'),PChar('Предупреждение'),
           MB_OK+MB_ICONWARNING);
       if ESumKredit.Visible then begin
         sqls := 'Update MAGAZINEPOSTINGS '+
                 'set MP_DOKUMENT='+TDocId+',MP_DOCUMENTID='+Id+',MP_IDINDOCUMENT=0'+
                 ',MP_DATE='+QuotedStr(Date1)+',MP_TIME='+QuotedStr(Time1)+',MP_DEBETID='+
                 KorAc+',MP_SUBKONTODT1='+InSub1+',MP_SUBKONTODT2='+InSub2+',MP_SUBKONTODT3='+
                 InSub3+',MP_CREDITID='+KassaId+',MP_SUBKONTOKT1=NULL'+',MP_SUBKONTOKT2=NULL'+
                 ',MP_SUBKONTOKT3=NULL'+',MP_CONTENTSOPERA='+QuotedStr('Выдача из кассы:'+EBasis.Text)+
                 ',MP_CONTENTSPOSTI='+QuotedStr('Расход')+',MP_COUNT=NULL'+',MP_SUMMA='+
                 Kredit+',MP_CURRENCY_ID='+CurId+' where MP_ID='+Trim(qr.FieldByName('MP_ID').AsString);
       end
       else begin
         sqls := 'Update MAGAZINEPOSTINGS '+
                 'set MP_DOKUMENT='+TDocId+',MP_DOCUMENTID='+Id+',MP_IDINDOCUMENT=0'+
                 ',MP_DATE='+QuotedStr(Date1)+',MP_TIME='+QuotedStr(Time1)+',MP_DEBETID='+
                 KassaId+',MP_SUBKONTODT1='+'NULL'+',MP_SUBKONTODT2='+'NULL'+',MP_SUBKONTODT3='+
                 'NULL'+',MP_CREDITID='+KorAc+',MP_SUBKONTOKT1='+InSub1+',MP_SUBKONTOKT2='+InSub2+
                 ',MP_SUBKONTOKT3='+InSub3+',MP_CONTENTSOPERA='+QuotedStr('Приход в кассу:'+EBasis.Text)+
                 ',MP_CONTENTSPOSTI='+QuotedStr('Приход')+',MP_COUNT=NULL'+',MP_SUMMA='+
                 Debit+',MP_CURRENCY_ID='+CurId+' where MP_ID='+Trim(qr.FieldByName('MP_ID').AsString);
       end;
       qr.SQL.Clear;
       qr.SQL.Add(sqls);
       qr.ExecSQL;
       qr.Transaction.Commit;
     end;
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

end.
