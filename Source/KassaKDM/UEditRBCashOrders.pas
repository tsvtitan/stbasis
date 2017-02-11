unit UEditRBCashOrders;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase,
  IB, IBCustomDataSet, IBTable, Mask, ComCtrls, UFrameSubkonto;

type
  TfmEditRBCashOrders = class(TfmEditRB)
    LNum: TLabel;
    Label2: TLabel;
    LEmp: TLabel;
    LBasis: TLabel;
    LAppend: TLabel;
    DateTime: TDateTimePicker;
    GBKorAc: TGroupBox;
    Label3: TLabel;
    BKorAc: TButton;
    MEKorAc: TMaskEdit;
    EEmp: TEdit;
    BEmp: TButton;
    EBasis: TEdit;
    BBasis: TButton;
    EAppend: TEdit;
    BAppend: TButton;
    ENum: TEdit;
    POutCashOrders: TPanel;
    LOnDoc: TLabel;
    EOnDoc: TEdit;
    BOnDoc: TButton;
    LSumKredit: TLabel;
    ESumKredit: TEdit;
    PInCashOrders: TPanel;
    LSumDebit: TLabel;
    LNDS: TLabel;
    LNDS1: TLabel;
    ESum: TEdit;
    CBNDS: TCheckBox;
    ENDS: TEdit;
    ESumNDS: TEdit;
    BNDS: TButton;
    LCashier: TLabel;
    ECashier: TEdit;
    BCashier: TButton;
    GBCurrency: TGroupBox;
    LCur: TLabel;
    ECur: TEdit;
    BCur: TButton;
    LKursCur: TLabel;
    CBDoc: TComboBox;
    GBKassa: TGroupBox;
    BKassa: TButton;
    MEKassa: TMaskEdit;
    LKassa: TLabel;
    PFilter: TPanel;
    DTPBeg: TDateTimePicker;
    Label4: TLabel;
    CBDateFilter: TCheckBox;
    Label7: TLabel;
    DTPFin: TDateTimePicker;
    CBNumFilter: TCheckBox;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    ENumBeg: TEdit;
    ENumFin: TEdit;
    BKassaFilter: TButton;
    MEKassaFilter: TMaskEdit;
    Label8: TLabel;
    Label13: TLabel;
    MEKorAcFilter: TMaskEdit;
    BKorAcFilter: TButton;
    FrameSub: TFrameSubkonto;
    FrameSubKassa: TFrameSubkonto;
    cbNP: TCheckBox;
    lNP: TLabel;
    eNP: TEdit;
    bNP: TButton;
    lNP1: TLabel;
    eSumNP: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure EditChange(Sender: TObject);
    procedure CBDocChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BKassaClick(Sender: TObject);
    procedure BKorAcClick(Sender: TObject);
    procedure BEmpClick(Sender: TObject);
    procedure BBasisClick(Sender: TObject);
    procedure BAppendClick(Sender: TObject);
    procedure BCashierClick(Sender: TObject);
    procedure BCurClick(Sender: TObject);
    procedure BOnDocClick(Sender: TObject);
    procedure CBNDSClick(Sender: TObject);
    procedure CBNumFilterClick(Sender: TObject);
    procedure CBDateFilterClick(Sender: TObject);
    procedure BKassaFilterClick(Sender: TObject);
    procedure BKorAcFilterClick(Sender: TObject);
    procedure bibClearClick(Sender: TObject);
    procedure cbNPClick(Sender: TObject);
    procedure BNDSClick(Sender: TObject);
    procedure bNPClick(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    TDocId,Id,Date1,Time1,Kassa,KassaId,KorAc,CurID,Debit,BasID,AppId,
    IsPay,NDS,CashierId,MainBKId,EmpId,Kredit,Director,OnDocId,sqls,CursCur,NP: string;
    IdRec1,IdRec2: Integer;
    qr: TIBQuery;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBCashOrders: TfmEditRBCashOrders;

implementation

uses UKassaKDMCode, UKassaKDMData, UMainUnited;

{type
  TRptExcelThreadInCO=class(TRptExcelThread)
  private
    PBHandle: LongWord;
  public
    fmParent: TfmEditRBCashOrders;
    procedure Execute;override;
    destructor Destroy;override;
  end;

var
  Rpt: TRptExcelThreadInCO;
}
{$R *.DFM}

procedure TfmEditRBCashOrders.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;


function TfmEditRBCashOrders.AddToRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
begin
//  inherited;
// Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr := TIBQuery.Create(nil);
  qr.Database := IBDB;
  qr.Transaction := IBTran;
  try
    Date1 := DateToStr(_GetDateTimeFromServer);
    Time1 := TimeToStr(_GetDateTimeFromServer);
    //ввод главного бухгалтера и директора
    sqls := 'select EMPACCOUNT_ID,EMPBOSS_ID from CONST';
    qr.SQL.Clear;
    qr.SQL.Add(sqls);
    qr.Open;
    if (not qr.IsEmpty) then begin
      qr.Last;
      MainBKId := qr.FieldByName('EMPACCOUNT_ID').AsString;
      Director := qr.FieldByName('EMPBOSS_ID').AsString;
    end;
    qr.Close;
     //конец ввода кассира с главным бухгалтером

    if POutCashOrders.Visible then begin
      sqls := 'Insert into CASHORDERS'+
              ' (ICO_ID,DOK_ID,CO_DATE,CO_TIME,CO_KINDKASSA,CO_CURRENCY_ID,'+
              'CO_IDKORACCOUNT,CO_KREDIT,CO_IDBASIS,CO_IDAPPEND,CO_CASHIER,'+
              'CO_MAINBOOKKEEPER,CO_EMP_ID,CO_PERSONDOCTYPE_ID,CO_DIRECTOR,'+
              'CO_IDINSUBKAS,CO_IDINSUBKONTO,CO_CURSCURRENCY) '+
              'values ('+Id+','+TDocId+','+QuotedStr(Date1)+','+QuotedStr(Time1)+','+KassaId+','+
              CurId+','+KorAc+','+Kredit+','+BasId+','+AppId+','+CashierId+','+MainBKId+','+
              EmpId+','+OnDocId+','+Director+','+QuotedStr(FrameSubKassa.GetStringForInsert)+','+
              QuotedStr(FrameSub.GetStringForInsert)+','+CursCur+')';
    end
    else begin
      sqls := 'Insert into CASHORDERS'+
              ' (ICO_ID,DOK_ID,CO_DATE,CO_TIME,CO_KINDKASSA,CO_CURRENCY_ID,'+
              'CO_IDKORACCOUNT,CO_DEBIT,CO_IDBASIS,CO_IDAPPEND,CO_NDS,CO_NP,CO_CASHIER,'+
              'CO_MAINBOOKKEEPER,CO_EMP_ID,CO_DIRECTOR,CO_IDINSUBKAS,CO_IDINSUBKONTO,CO_CURSCURRENCY) values ('+
               Id+','+TDocId+','+QuotedStr(Date1)+','+QuotedStr(Time1)+','+KassaId+','+
               CurId+','+KorAc+','+Debit+','+BasId+','+AppId+','+NDS+','+NP+','+CashierId+','+MainBKId+','+
               EmpId+','+Director+','+QuotedStr(FrameSubKassa.GetStringForInsert)+','+
               QuotedStr(FrameSub.GetStringForInsert)+','+CursCur+')';
    end;
    qr.SQL.Clear;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    qr.Transaction.Active := True;

{    if POutCashOrders.Visible then begin
      sqls := 'Insert into MAGAZINEPOSTINGS '+
              '(MP_ID,MP_DOKUMENT,MP_DOCUMENTID,MP_IDINDOCUMENT,MP_DATE,MP_TIME,'+
              'MP_DEBETID,MP_CREDITID,MP_CONTENTSOPERA,MP_CONTENTSPOSTI,MP_COUNT,'+
              'MP_SUMMA,MP_CURRENCY_ID,MP_SUBKONTODT,MP_SUBKONTOKT,MP_CURSCURRENCY) values('+
              'gen_id(gen_mp_id,1)'+','+TDocId+','+Id+','+'0'+','+QuotedStr(Date1)+','+
              QuotedStr(Time1)+','+KorAc+','+KassaId+','+QuotedStr('Выдача из кассы:'+EBasis.Text)+
              ','+QuotedStr('Расход')+','+'NULL'+','+Kredit+','+CurId+','+QuotedStr(FrameSub.GetStringForInsert)+','+
              QuotedStr(FrameSubKassa.GetStringForInsert)+','+CursCur+')';
    end
    else begin
      sqls := 'Insert into MAGAZINEPOSTINGS '+
              '(MP_ID,MP_DOKUMENT,MP_DOCUMENTID,MP_IDINDOCUMENT,MP_DATE,MP_TIME,'+
              'MP_DEBETID,MP_CREDITID,MP_CONTENTSOPERA,MP_CONTENTSPOSTI,MP_COUNT,'+
              'MP_SUMMA,MP_CURRENCY_ID,MP_SUBKONTODT,MP_SUBKONTOKT,MP_CURSCURRENCY) values('+
              'gen_id(gen_mp_id,1)'+','+TDocId+','+Id+','+'0'+','+QuotedStr(Date1)+','+
              QuotedStr(Time1)+','+KassaId+','+KorAc+','+QuotedStr('Поступление в кассу:'+EBasis.Text)+
              ','+QuotedStr('Приход')+','+'NULL'+','+Debit+','+CurId+','+QuotedStr(FrameSubKassa.GetStringForInsert)+','+
              QuotedStr(FrameSub.GetStringForInsert)+','+CursCur+')';
    end;
    qr.SQL.Clear;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    qr.Transaction.Active := True;}

    Result:=true;

  finally
    qr.Free;
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

procedure TfmEditRBCashOrders.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBCashOrders.UpdateRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  qr.Database := IBDB;
  qr.Transaction := IBTran;
  try
    Date1 := DateToStr(_GetDateTimeFromServer);
    Time1 := TimeToStr(_GetDateTimeFromServer);
    //ввод главного бухгалтера и директора
    sqls := 'select EMPACCOUNT_ID,EMPBOSS_ID from CONST';
    qr.SQL.Clear;
    qr.SQL.Add(sqls);
    qr.Open;
    if (not qr.IsEmpty) then begin
      qr.Last;
      MainBKId := qr.FieldByName('EMPACCOUNT_ID').AsString;
      Director := qr.FieldByName('EMPBOSS_ID').AsString;
    end;
    qr.Close;
     //конец ввода кассира с главным бухгалтером
    if (Application.MessageBox('Документ будет перепроведен!','Внимание',MB_OKCANCEL)<>ID_OK) then Exit;
    if POutCashOrders.Visible then begin
      sqls := 'Update '+ tbCashOrders+
              ' set ICO_ID='+Id+','+'DOK_ID='+TDocId+','+'CO_DATE='+QuotedStr(Date1)+','+
              'CO_TIME='+QuotedStr(Time1)+','+'CO_KINDKASSA='+KassaId+','+'CO_CURRENCY_ID='+CurId+','+
              'CO_IDKORACCOUNT='+KorAc+','+'CO_KREDIT='+Kredit+','+'CO_IDBASIS='+BasId+','+
              'CO_IDAPPEND='+AppId+','+'CO_CASHIER='+CashierId+','+'CO_MAINBOOKKEEPER='+MainBKId+','+
              'CO_EMP_ID='+EmpId+','+'CO_PERSONDOCTYPE_ID='+OnDocId+','+'CO_DIRECTOR='+Director+','+
              'CO_IDNDS=NULL,CO_DEBIT=0'+','+
              'CO_IDINSUBKAS='+QuotedStr(FrameSubKassa.GetStringForInsert)+','+
              'CO_IDINSUBKONTO='+QuotedStr(FrameSub.GetStringForInsert)+','+
              'CO_CURSCURRENCY='+CursCur+
              ' where ICO_Id='+IntToStr(IdRec1)+' and DOK_Id='+IntToStr(IdRec2);
    end
    else begin
      sqls := 'Update '+ tbCashOrders+
              ' set ICO_ID='+Id+','+'DOK_ID='+TDocId+','+'CO_DATE='+QuotedStr(Date1)+','+
              'CO_TIME='+QuotedStr(Time1)+','+'CO_KINDKASSA='+KassaId+','+'CO_CURRENCY_ID='+CurId+','+
              'CO_IDKORACCOUNT='+KorAc+','+'CO_DEBIT='+Debit+','+'CO_IDBASIS='+BasId+','+
              'CO_IDAPPEND='+AppId+','+'CO_NDS='+NDS+','+'CO_NP='+NP+','+'CO_CASHIER='+CashierId+','+'CO_MAINBOOKKEEPER='+MainBKId+','+
              'CO_EMP_ID='+EmpId+','+'CO_DIRECTOR='+Director+','+'CO_KREDIT=0,CO_PERSONDOCTYPE_ID=NULL'+','+
              'CO_IDINSUBKAS='+QuotedStr(FrameSubKassa.GetStringForInsert)+','+
              'CO_IDINSUBKONTO='+QuotedStr(FrameSub.GetStringForInsert)+','+
              'CO_CURSCURRENCY='+CursCur+
              ' where ICO_Id='+IntToStr(IdRec1)+' and DOK_Id='+IntToStr(IdRec2);
    end;
    qr.SQL.Clear;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    qr.Transaction.Active := True;

    if POutCashOrders.Visible then begin
      sqls := 'Update '+ tbMAGAZINEPOSTINGS +
              ' set MP_DOKUMENT='+TDocId+','+'MP_DOCUMENTID='+Id+','+'MP_IDINDOCUMENT='+'0'+','+
              'MP_DATE='+QuotedStr(Date1)+','+'MP_TIME='+QuotedStr(Time1)+','+'MP_DEBETID='+KorAc+','+
              'MP_CREDITID='+KassaId+','+'MP_CONTENTSOPERA='+QuotedStr('Выдача из кассы:'+EBasis.Text)+','+
              'MP_CONTENTSPOSTI='+QuotedStr('Расход')+','+'MP_COUNT='+'NULL'+','+'MP_SUMMA='+Kredit+','+
              'MP_CURRENCY_ID='+CurId+','+
              'MP_SUBKONTODT='+QuotedStr(FrameSub.GetStringForInsert)+','+
              'MP_SUBKONTOKT='+QuotedStr(FrameSubKassa.GetStringForInsert)+','+
              'MP_CURSCURRENCY='+CursCur+
              ' where mp_documentid='+IntToStr(IdRec1)+' and mp_dokument='+IntToStr(IdRec2);
    end
    else begin
      sqls := 'Update '+ tbMAGAZINEPOSTINGS +
              ' set MP_DOKUMENT='+TDocId+','+'MP_DOCUMENTID='+Id+','+'MP_IDINDOCUMENT='+'0'+','+
              'MP_DATE='+QuotedStr(Date1)+','+'MP_TIME='+QuotedStr(Time1)+','+'MP_DEBETID='+KassaId+','+
              'MP_CREDITID='+KorAc+','+'MP_CONTENTSOPERA='+QuotedStr('Поступление в кассу:'+EBasis.Text)+','+
              'MP_CONTENTSPOSTI='+QuotedStr('Приход')+','+'MP_COUNT='+'NULL'+','+'MP_SUMMA='+Debit+','+
              'MP_CURRENCY_ID='+CurId+','+
              'MP_SUBKONTODT='+QuotedStr(FrameSubKassa.GetStringForInsert)+','+
              'MP_SUBKONTOKT='+QuotedStr(FrameSub.GetStringForInsert)+','+
              'MP_CURSCURRENCY='+CursCur+
              ' where mp_documentid='+IntToStr(IdRec1)+' and mp_dokument='+IntToStr(IdRec2);
    end;
    qr.SQL.Clear;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    qr.Transaction.Active := True;

    Result:=true;
  finally
    qr.Free;
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

procedure TfmEditRBCashOrders.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end;
  ModalResult:=mrOk;
end;

function TfmEditRBCashOrders.CheckFieldsFill: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  t,t1: integer;
  s:PChar;
begin
  qr := TIBQuery.Create(nil);
  qr.Database := IBDB;
  qr.Transaction := IBTran;
  Result:=true;
  try
  if (TDocId='NULL') then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,['Тип документа']));
    CBDoc.SetFocus;
    Result:=false;
    exit;
  end;
  if (trim(ENum.Text)='') then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,['Номер документа']));
    ENum.SetFocus;
    Result:=false;
    exit;
  end
  else begin
  try
    StrToInt(ENum.Text);
    Id := Trim(ENum.Text);
  except
    Application.MessageBox(PChar('Неверный номер документа'),PChar('Ошибка'),
    MB_OK+MB_ICONERROR);
    ENum.SetFocus;
    Result := false;
    exit;
  end;
  end;
  if (trim(MEKassa.Text)='.   .') or (KassaId='0') then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[LKassa.Caption]));
    MEKassa.SetFocus;
    Result:=false;
    exit;
  end;
  if (trim(MEKorAc.Text)='.   .') or (KorAc='0') then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[Label3.Caption]));
    MEKorAc.SetFocus;
    Result:=false;
    exit;
  end
  else begin
    if PInCashOrders.Visible then
      sqls := 'select * from '+tbACCOUNTTYPE+' where DEBIT ='+KassaId+
              ' AND KREDIT = '+KorAc;
    if POutCashOrders.Visible then
      sqls := 'select * from '+tbACCOUNTTYPE+' where KREDIT ='+KassaID+
              ' AND DEBIT = '+KorAc;
    qr.SQL.Clear;
    qr.SQL.Add(sqls);
    qr.Open;
    if (qr.IsEmpty) then begin
      if (Application.MessageBox(PChar('Для счета <'+MEKorAc.Text+'> нет корректной проводки'),PChar('Предупреждение'),
          MB_OKCANCEL+MB_ICONWARNING)=ID_CANCEL) then begin
        Result := false;
        exit;
      end;
    end;
  end;
  if (trim(EEmp.Text)='') or (EmpId='0') then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[LEmp.Caption]));
    EEmp.SetFocus;
    Result:=false;
    exit;
  end;
  if (not FrameSub.CheckFieldsFill) or (not FrameSubKassa.CheckFieldsFill) then begin
    Result:=false;
    exit;
  end;
  if (trim(EBasis.Text)='')or(BasId='0') then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[LBasis.Caption]));
    EBasis.SetFocus;
    Result:=false;
    exit;
  end;
  //ввод суммы
  if PInCashOrders.Visible then
  if ESum.Text='' then begin
    Application.MessageBox(PChar('Не указана сумма'),PChar('Ошибка'),
    MB_OK+MB_ICONERROR);
    ESum.SetFocus;
    Result := false;
    exit;
  end
  else begin
    try
      s := PChar(FormatFloat('0.00',StrToFloat(ESum.Text)));
      t:=Pos(',',s);
      if t<>0 then
        s[t-1]:='.';
      Debit := s;
    except
      Application.MessageBox(PChar('Неверная сумма'),PChar('Ошибка'),
      MB_OK+MB_ICONERROR);
      ESum.SetFocus;
      Result := false;
      exit;
    end;
  end;//конец ввода суммы
  //ввод суммы
  if POutCashOrders.Visible then
  if ESumKredit.Text='' then begin
    Application.MessageBox(PChar('Не указана сумма'),PChar('Ошибка'),
    MB_OK+MB_ICONERROR);
    ESumKredit.SetFocus;
    Result := false;
    exit;
  end
  else begin
    try
      s := PChar(FormatFloat('0.00',StrToFloat(ESum.Text)));
      t:=Pos(',',s);
      if t<>0 then
        s[t-1]:='.';
      Kredit := s;
    except
     Application.MessageBox(PChar('Неверная сумма'),PChar('Ошибка'),
     MB_OK+MB_ICONERROR);
     ESumKredit.SetFocus;
     Result := false;
     exit;
    end;
  end;//конец ввода суммы
  if (PInCashOrders.Visible)and(CBNDS.Checked)and (NDS='NULL') then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[LNDS.Caption]));
    ENDS.SetFocus;
    Result:=false;
    exit;
  end;
  if (PInCashOrders.Visible)and(CBNP.Checked)and (NP='NULL') then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[LNP.Caption]));
    ENP.SetFocus;
    Result:=false;
    exit;
  end;
  if ECashier.Text='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[LCashier.Caption]));
    ECashier.SetFocus;
    Result:=false;
    exit;
  end;
  if (POutCashOrders.Visible)and(OnDocId='NULL') then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[LOnDoc.Caption]));
    EOnDoc.SetFocus;
    Result:=false;
    exit;
  end;
  if (GBCurrency.Visible)and(CurId='NULL') then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[LCur.Caption]));
    ECur.SetFocus;
    Result:=false;
    exit;
  end;
  finally
  qr.Free;
  end;
end;

procedure TfmEditRBCashOrders.EditChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBCashOrders.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);
  TDocId := 'NULL';
  Id := '0';
  Date1 := '0';
  Time1 := '0';
//  Kassa := '50.1';
  KassaId :='0';
  KorAc := '0';
  CurId := 'NULL';
  Debit := '0';
  Kredit := '0';
  BasId := '0';
  AppId := '0';
//  IsPay := '';
  NDS := 'NULL';
  NP := 'NULL';
  CashierId := '0';
  MainBKId := '0';
  Director := 'NULL';
  EmpId := '0';
  OnDocId := 'NULL';
  CursCur := 'NULL';
  qr := TIBQuery.Create(nil);
  qr.Database := IBDB;
  qr.Transaction := IBTran;
  CBDoc.OnChange(Sender);
  DateTime.Date := _GetDateTimeFromServer;
end;

procedure TfmEditRBCashOrders.CBDocChange(Sender: TObject);
begin
  inherited;
  if(CBDoc.Items.IndexOf(Trim(CBDoc.Text))=0) then begin
     POutCashOrders.Visible:=false;
     PInCashOrders.Visible:=True;
  end;
  if(CBDoc.Items.IndexOf(Trim(CBDoc.Text))=1) then begin
     PInCashOrders.Visible:=false;
     POutCashOrders.Visible:=true;
     if EmpId<>'0' then begin
       LOnDoc.Enabled := true;
       EOnDoc.Enabled := true;
       BOnDoc.Enabled := true;
     end
     else begin
       LOnDoc.Enabled := false;
       EOnDoc.Enabled := false;
       BOnDoc.Enabled := false;
     end;
  end;
  if(CBDoc.Items.IndexOf(Trim(CBDoc.Text))<>-1) then begin
     sqls := 'select * from DOCUMENTS where Upper(DOK_NAME)='+AnsiUpperCase(QuotedStr(Trim(CBDoc.Text)));
     qr.SQL.Clear;
     qr.SQL.Add(sqls);
     qr.Open;
     if (qr.IsEmpty) then begin
       Application.MessageBox(PChar('Тип документа <'+CBDoc.Text+'> не существует'),PChar('Ошибка'),
       MB_OK+MB_ICONERROR);
       exit;
     end
     else
       TDocId := Trim(qr.FieldByName('DOK_ID').AsString);
    sqls := 'select ICO_ID from CASHORDERS where DOK_ID = '+TDocId+' Order by ICO_ID';
    qr.SQL.Clear;
    qr.SQL.Add(sqls);
    qr.Open;
    qr.Last;
    ENum.Text := IntToStr(qr.FieldByName('ICO_ID').AsInteger + 1);
  end
  else begin
    TDocId := 'NULL';
  end;
end;

procedure TfmEditRBCashOrders.FormDestroy(Sender: TObject);
begin
  inherited;
  qr.Free;
  FrameSub.DeInitData;
  FrameSubKassa.DeInitData;
end;

procedure TfmEditRBCashOrders.BKassaClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
  sqls: string;
  IdParentKassa: Integer;
  qr: TIBQuery;
begin
  try
   FillChar(TPRBI,SizeOf(TPRBI),0);
   if not _isPermission(tbPlanAccounts,SelConst) then
     exit;
   qr := TIBQuery.Create(nil);
   qr.Database := IBDB;
   qr.Transaction := IBTran;
   try
     TPRBI.Visual.TypeView:=tvibvModal;
     TPRBI.Locate.KeyFields:='pa_id';
     TPRBI.Locate.KeyValues:=KassaId;
     TPRBI.Locate.Options:=[loCaseInsensitive];
     sqls := 'select * from '+tbPlanAccounts+' where Upper(pa_groupid)='+QuotedStr(ConstKassaAccount);
     qr.SQL.Clear;
     qr.SQL.Add(sqls);
     qr.Open;
     if not qr.IsEmpty then
       IdParentKassa := qr.FieldByName('pa_id').AsInteger;
     sqls := ' PA_PARENTID='+IntToStr(IdParentKassa);
     TPRBI.Condition.WhereStr := PChar(sqls);
     if _ViewInterfaceFromName(NameRbkPlanAccounts,@TPRBI) then begin
       ChangeFlag:=true;
       KassaId := GetFirstValueFromParamRBookInterface(@TPRBI,'pa_id');
       KorAc := '0';
       MEKorAc.Text := '';
       FrameSubKassa.InitData(StrToInt(KassaId),GetFirstValueFromParamRBookInterface(@TPRBI,'pa_idinsubkas'));
       FrameSub.ClearAll;
       if KassaId='0' then begin
         Label3.Enabled := false;
         MEKorAc.Enabled := false;
         BKorAc.Enabled := false;
       end
       else begin
         Label3.Enabled := true;
         MEKorAc.Enabled := true;
         BKorAc.Enabled := true;
       end;
       if GetFirstValueFromParamRBookInterface(@TPRBI,'PA_CURRENCY')='*' then begin
         GBCurrency.Visible := True;
         sqls := 'select * from '+tbConst;
         qr.SQL.Clear;
         qr.SQL.Add(sqls);
         qr.Open;
         CurId := qr.FieldByName('DEFAULTCURRENCY_ID').AsString;
         sqls := 'select * from '+tbCurrency+
                 ' where currency_id='+CurId;
         qr.SQL.Clear;
         qr.SQL.Add(sqls);
         qr.Open;
         if not qr.isEmpty then begin
           ECur.Text := Trim(qr.FieldByName('NAME').AsString);
           sqls := 'select * from '+tbRateCurrency+
                   ' where currency_id='+CurId+
                   ' order by indate asc';
           qr.SQL.Clear;
           qr.SQL.Add(sqls);
           qr.Open;
           qr.Last;
           LKursCur.Caption := Trim(qr.FieldByName('Factor').AsString);
         end;
       end
       else begin
         GBCurrency.Visible := false;
         CurId := 'NULL';
         CursCur := 'NULL';
         ECur.Text := '';
         LKursCur.Caption := '';
       end;
       MEKassa.Text := GetFirstValueFromParamRBookInterface(@TPRBI,'PA_GROUPID');
       EditChange(Sender);
     end;
   finally
     qr.Free;
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

procedure TfmEditRBCashOrders.BKorAcClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
  sqls: string;
//  IdParentKassa: Integer;
  qr: TIBQuery;
begin
  try
   FillChar(TPRBI,SizeOf(TPRBI),0);
   if not _isPermission(tbPlanAccounts,SelConst) then
     exit;
   qr := TIBQuery.Create(nil);
   qr.Database := IBDB;
   qr.Transaction := IBTran;
   try
     TPRBI.Visual.TypeView:=tvibvModal;
     TPRBI.Locate.KeyFields:='pa_id';
     TPRBI.Locate.KeyValues:=KorAc;
     TPRBI.Locate.Options:=[loCaseInsensitive];
     if KassaId='0'  then begin
       Application.MessageBox(PChar('Не введена касса'),PChar('Ошибка'),
       MB_OK+MB_ICONERROR);
       Abort;
     end;
//     if not qr.IsEmpty then begin
      if (CBDoc.Text='Расходный кассовый ордер') then
        sqls := 'PA_ID IN (select DEBIT from ACCOUNTTYPE WHERE KREDIT='+
                       KassaId+')';
      if (CBDoc.Text='Приходный кассовый ордер') then
        sqls := 'PA_ID IN (select KREDIT from ACCOUNTTYPE WHERE DEBIT='+
                       KassaId+')';
//    end;
//     sqls := ' PA_PARENTID='+IntToStr(IdParentKassa);
     TPRBI.Condition.wherestr:=PChar(sqls);
     if _ViewInterfaceFromName(NameRbkPlanAccounts,@TPRBI) then begin
       ChangeFlag:=true;
       KorAc := GetFirstValueFromParamRBookInterface(@TPRBI,'pa_id');
       MEKorAc.Text := GetFirstValueFromParamRBookInterface(@TPRBI,'PA_GROUPID');
       EditChange(Sender);
       FrameSub.InitData(StrToInt(KorAc),GetFirstValueFromParamRBookInterface(@TPRBI,'PA_IDINSUBKONTO'));
     end;
   finally
     qr.Free;
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

procedure TfmEditRBCashOrders.BEmpClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
  sqls: string;
begin
  try
   if not _isPermission(tbEmp,SelConst) then
     exit;
   try
     FillChar(TPRBI,SizeOf(TPRBI),0);
     TPRBI.Visual.TypeView:=tvibvModal;
     TPRBI.Locate.KeyFields:='emp_id';
     TPRBI.Locate.KeyValues:=EmpId;
     TPRBI.Locate.Options:=[loCaseInsensitive];
     if _ViewInterfaceFromName(NameRbkEmp,@TPRBI) then begin
       ChangeFlag:=true;
       EmpId := GetFirstValueFromParamRBookInterface(@TPRBI,'emp_id');
       OnDocId := 'NULL';
       EOnDoc.Text := '';
       EEmp.Text := GetFirstValueFromParamRBookInterface(@TPRBI,'fname')+' '+
                    GetFirstValueFromParamRBookInterface(@TPRBI,'name')+' '+
                    GetFirstValueFromParamRBookInterface(@TPRBI,'sname');
       if EmpId='0' then begin
         POutCashOrders.Enabled := false;
         LOnDoc.Enabled := false;
         EOnDoc.Enabled := false;
         BOnDoc.Enabled := false;
       end
       else begin
         POutCashOrders.Enabled := true;
         LOnDoc.Enabled := true;
         EOnDoc.Enabled := true;
         BOnDoc.Enabled := true;
       end;
       EditChange(Sender);
     end;
   finally
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

procedure TfmEditRBCashOrders.BBasisClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
  sqls: string;
begin
  try
   FillChar(TPRBI,SizeOf(TPRBI),0);
   if not _isPermission(tbCashBasis,SelConst) then
     exit;
   try
     TPRBI.Visual.TypeView:=tvibvModal;
     TPRBI.Locate.KeyFields:='cb_id';
     TPRBI.Locate.KeyValues:=BasId;
     TPRBI.Locate.Options:=[loCaseInsensitive];
     if _ViewInterfaceFromName(NameRbkCashBasis,@TPRBI) then begin
       ChangeFlag:=true;
       BasId := GetFirstValueFromParamRBookInterface(@TPRBI,'cb_id');
       EBasis.Text := GetFirstValueFromParamRBookInterface(@TPRBI,'cb_text');
       EditChange(Sender);
     end;
   finally
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

procedure TfmEditRBCashOrders.BAppendClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
  sqls: string;
begin
  try
    FillChar(TPRBI,SizeOf(TPRBI),0);
   if not _isPermission(tbCashAppend,SelConst) then
     exit;
   try
     TPRBI.Visual.TypeView:=tvibvModal;
     TPRBI.Locate.KeyFields:='ca_id';
     TPRBI.Locate.KeyValues:=AppId;
     TPRBI.Locate.Options:=[loCaseInsensitive];
     if _ViewInterfaceFromName(NameRbkCashAppend,@TPRBI) then begin
       ChangeFlag:=true;
       AppId := GetFirstValueFromParamRBookInterface(@TPRBI,'ca_id');
       EAppend.Text := GetFirstValueFromParamRBookInterface(@TPRBI,'ca_text');
       EditChange(Sender);
     end;
   finally
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

procedure TfmEditRBCashOrders.BCashierClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
  sqls: string;
begin
  try
   if not _isPermission(tbEmp,SelConst) then
     exit;
   try
    FillChar(TPRBI,SizeOf(TPRBI),0);
    TPRBI.Visual.TypeView:=tvibvModal;
    TPRBI.Locate.KeyFields:='emp_id';
    TPRBI.Locate.KeyValues:=CashierId;
    TPRBI.Locate.Options:=[loCaseInsensitive];
    if _ViewInterfaceFromName(NameRbkEmp,@TPRBI) then begin
       CashierId := GetFirstValueFromParamRBookInterface(@TPRBI,'emp_id');
       ECashier.Text := GetFirstValueFromParamRBookInterface(@TPRBI,'fname')+' '+
                        GetFirstValueFromParamRBookInterface(@TPRBI,'name')+' '+
                        GetFirstValueFromParamRBookInterface(@TPRBI,'sname');
       EditChange(Sender);
     end;
   finally
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

procedure TfmEditRBCashOrders.BCurClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
  sqls: string;
  qr: TIBQuery;
  s: PChar;
  t: integer;
begin
  try
   if not _isPermission(tbCurrency,SelConst) then
     exit;
   qr := TIBQuery.Create(nil);
   qr.Database := IBDB;
   qr.Transaction := IBTran;
   try
     FillChar(TPRBI,SizeOf(TPRBI),0);
     TPRBI.Visual.TypeView:=tvibvModal;
     if CurId<>'NULL' then begin
       TPRBI.Locate.KeyFields:='currency_id';
       TPRBI.Locate.KeyValues:=CurId;
       TPRBI.Locate.Options:=[loCaseInsensitive];
     end;
     if _ViewInterfaceFromName(NameRbkCurrency,@TPRBI) then begin
       CurId := GetFirstValueFromParamRBookInterface(@TPRBI,'currency_id');
       ECur.Text := GetFirstValueFromParamRBookInterface(@TPRBI,'shortname');
       sqls := 'select * from ratecurrency where currency_id = '+CurId+
               'Order by indate';
       qr.SQL.Clear;
       qr.SQL.Add(sqls);
       qr.Open;
       qr.Last;
       if not qr.IsEmpty then begin
         LKursCur.Caption := Trim(qr.FieldByName('factor').AsString);
         s:=PChar(LKursCur.Caption);
         t := Pos(',',s);
         s[t-1]:='.';
         CursCur := s;
       end
       else begin
         LKursCur.Caption := '';
         CursCur := 'NULL';
       end;
       EditChange(Sender);
     end;
   finally
     qr.Free;
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

procedure TfmEditRBCashOrders.BOnDocClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
  sqls: string;
  qr: TIBQuery;
  AllowDoc: string;
  RecCount,i: integer;
begin
  try
   qr := TIBQuery.Create(nil);
   qr.Database := IBDB;
   qr.Transaction := IBTran;
   if not _isPermission(tbPersonDocType,SelConst) then
     exit;
   try
     FillChar(TPRBI,SizeOf(TPRBI),0);
     TPRBI.Visual.TypeView:=tvibvModal;
     sqls := 'select count(*) as ctn from emppersondoc where emp_id='+EmpId;
     qr.SQL.Clear;
     qr.SQL.Add(sqls);
     qr.Open;
     RecCount := qr.FieldByName('ctn').AsInteger;
     sqls := 'select * from emppersondoc where emp_id='+EmpId;
     qr.SQL.Clear;
     qr.SQL.Add(sqls);
     qr.Open;
     if not qr.IsEmpty then begin
       for i:=0 to RecCount-1 do begin
         if i=RecCount-1 then
           AllowDoc := AllowDoc+Trim(qr.FieldByName('persondoctype_id').AsString)
         else
           AllowDoc := AllowDoc+Trim(qr.FieldByName('persondoctype_id').AsString)+',';
         Next;
       end;
     end;
     if OnDocId<>'NULL' then begin
       TPRBI.Locate.KeyFields:='id';
       TPRBI.Locate.KeyValues:=OnDocId;
       TPRBI.Locate.Options:=[loCaseInsensitive];
     end;
     if AllowDoc='' then
        AllowDoc:='-1';
     sqls := ' persondoctype_id in ('+ AllowDoc+')';
     TPRBI.Condition.WhereStr := PChar(sqls);
     if _ViewInterfaceFromName(NameRbkPersonDocType,@TPRBI) then begin
       OnDocId := GetFirstValueFromParamRBookInterface(@TPRBI,'persondoctype_id');
       EOnDoc.Text := GetFirstValueFromParamRBookInterface(@TPRBI,'name');
       EditChange(Sender);
     end;
   finally
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

procedure TfmEditRBCashOrders.CBNDSClick(Sender: TObject);
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
    NDS := 'NULL';
  end;
end;

procedure TfmEditRBCashOrders.CBNumFilterClick(Sender: TObject);
begin
  inherited;
  Label11.Enabled := CBNumFilter.Checked;
  ENumBeg.Enabled := CBNumFilter.Checked;
  Label12.Enabled := CBNumFilter.Checked;
  ENumFin.Enabled := CBNumFilter.Checked;
end;

procedure TfmEditRBCashOrders.CBDateFilterClick(Sender: TObject);
begin
  inherited;
  Label4.Enabled := CBDateFilter.Checked;
  DTPBeg.Enabled := CBDateFilter.Checked;
  Label7.Enabled := CBDateFilter.Checked;
  DTPFin.Enabled := CBDateFilter.Checked;
end;

procedure TfmEditRBCashOrders.BKassaFilterClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
  sqls: string;
//  IdParentKassa: Integer;
  qr: TIBQuery;
begin
  try
  FillChar(TPRBI,SizeOf(TPRBI),0);
   if not _isPermission(tbPlanAccounts,SelConst) then
     exit;
   qr := TIBQuery.Create(nil);
   qr.Database := IBDB;
   qr.Transaction := IBTran;
   try
     TPRBI.Visual.TypeView:=tvibvModal;
     TPRBI.Locate.KeyFields:='pa_id';
     TPRBI.Locate.KeyValues:=KassaId;
     TPRBI.Locate.Options:=[loCaseInsensitive];
     if _ViewInterfaceFromName(NameRbkPlanAccounts,@TPRBI) then begin
       KassaId := GetFirstValueFromParamRBookInterface(@TPRBI,'pa_id');
       MEKassaFilter.Text := GetFirstValueFromParamRBookInterface(@TPRBI,'PA_GROUPID');
       EditChange(Sender);
//       ShowMessage(P.username);
     end;
   finally
     qr.Free;
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

procedure TfmEditRBCashOrders.BKorAcFilterClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
  sqls: string;
//  IdParentKassa: Integer;
  qr: TIBQuery;
begin
  try
   FillChar(TPRBI,SizeOf(TPRBI),0);
   if not _isPermission(tbPlanAccounts,selConst) then
     exit;
   qr := TIBQuery.Create(nil);
   qr.Database := IBDB;
   qr.Transaction := IBTran;
   try
     TPRBI.Visual.TypeView:=tvibvModal;
     TPRBI.Locate.KeyFields:='pa_id';
     TPRBI.Locate.KeyValues:=KassaId;
     TPRBI.Locate.Options:=[loCaseInsensitive];
     if _ViewInterfaceFromName(NameRbkPlanAccounts,@TPRBI) then begin
       KassaId := GetFirstValueFromParamRBookInterface(@TPRBI,'pa_id');
       MEKorAcFilter.Text := GetFirstValueFromParamRBookInterface(@TPRBI,'PA_GROUPID');
       EditChange(Sender);
//       ShowMessage(P.username);
     end;
   finally
     qr.Free;
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

procedure TfmEditRBCashOrders.bibClearClick(Sender: TObject);
begin
  inherited;
  MEKassaFilter.Text := '';
  MEKorAcFilter.Text := '';
  CBNumFilter.Checked := false;
  CBDateFilter.Checked := false;
end;


procedure TfmEditRBCashOrders.cbNPClick(Sender: TObject);
begin
  inherited;
  if CBNDS.Checked=true then begin
    LNP.Enabled := true;
    BNP.Enabled := true;
    ENP.Enabled := true;
    LNP1.Enabled := true;
    ESumNP.Enabled := true;
  end
  else begin
    LNP.Enabled := false;
    BNP.Enabled := false;
    ENP.Enabled := false;
    LNP1.Enabled := false;
    ESumNP.Enabled := false;
    ESumNP.Text := '';
    ENP.Text := '';
    NP := 'NULL';
  end;
end;

procedure TfmEditRBCashOrders.BNDSClick(Sender: TObject);
var
  t: integer;
  s: PChar;
begin
  inherited;
  s := PChar(FormatFloat('0.00',StrToFloat(NDS)));
  t:=Pos(',',s);
  if t<>0 then
    s[t-1]:='.';
  NDS := s;
end;

procedure TfmEditRBCashOrders.bNPClick(Sender: TObject);
var
  t: integer;
  s: PChar;
begin
  inherited;
  s := PChar(FormatFloat('0.00',StrToFloat(NP)));
  t:=Pos(',',s);
  if t<>0 then
    s[t-1]:='.';
  NP := s;
end;

end.

