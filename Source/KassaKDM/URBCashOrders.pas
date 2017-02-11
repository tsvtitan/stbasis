unit URBCashOrders;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, Menus, tsvDbGrid, IBUpdateSQL,comobj,OleCtnrs, Excel97;

type
  TfmRBCashOrders = class(TfmRBMainGrid)
    bibPostings: TBitBtn;
    bibPrint: TBitBtn;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
    procedure bibPostingsClick(Sender: TObject);
    procedure bibPrintClick(Sender: TObject);
  private
    isFindDoc,isFindNum,isFindDate,isFindKassa,isFindKorAc,
    isFindEmp,isFindBasis,isFindAppend,isFindCashier,isFindSum: Bool;
    FindDoc,FindNumBeg,FindNumFin,FindDateBeg,FindDateFin,
    FindKassa,FindKorAc,FindEmp,FindBasis,FindAppend,
    FindCashier,FindSum: string;
  protected
    procedure GridDblClick(Sender: TObject); override;
    procedure SaveToIni;override;
    procedure LoadFromIni; override;
    function GetFilterString: string;  override;
    procedure GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort); override;
    function GetSql: string; override;
  public
    procedure ActiveQuery(CheckPerm: Boolean);override;
    procedure GenerateReport;
    procedure OnRptTerminate(Sender: TObject);
  end;

var
  fmRBCashOrders: TfmRBCashOrders;

implementation

uses UMainUnited, UKassaKDMCode, UKassaKDMDM, UKassaKDMData, UEditRBCashOrders,URptThread,ActiveX;

type
  TRptExcelThreadInCO=class(TRptExcelThread)
  private
    PBHandle: LongWord;
  public
    fmParent: TfmRBCashOrders;
    procedure Execute;override;
    procedure ExecuteInCO;
    procedure ExecuteOutCO;
    destructor Destroy;override;
  end;

var
  Rpt: TRptExcelThreadInCO;

{$R *.DFM}

procedure TfmRBCashOrders.FormCreate(Sender: TObject);
var
 cl: TColumn;
begin
 inherited;
 try
  Caption:=NameRbkCashOrders;
  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);
  bibPrint.Visible := not bibOk.Visible;

    cl:=Grid.Columns.Add;
    cl.FieldName:='ICO_ID';
    cl.Title.Caption:='Номер';
    cl.Width:=20;

    cl:=Grid.Columns.Add;
    cl.FieldName:='CO_DATE';
    cl.Title.Caption:='Дата';
    cl.Width:=60;

    cl:=Grid.Columns.Add;
    cl.FieldName:='CO_TIME';
    cl.Title.Caption:='Время';
    cl.Width:=60;

    cl:=Grid.Columns.Add;
    cl.FieldName:='DOK_NAME';
    cl.Title.Caption:='Документ';
    cl.Width:=145;

    cl:=Grid.Columns.Add;
    cl.FieldName:='PA_GROUPID';
    cl.Title.Caption:='Касса';
    cl.Width:=25;

    cl:=Grid.Columns.Add;
    cl.FieldName:='PA_GROUPID1';
    cl.Title.Caption:='Корр.счет';
    cl.Width:=25;

    cl:=Grid.Columns.Add;
    cl.FieldName:='CO_DEBIT';
    cl.Title.Caption:='Дебит';
    cl.Width:=70;

    cl:=Grid.Columns.Add;
    cl.FieldName:='CO_KREDIT';
    cl.Title.Caption:='Кредит';
    cl.Width:=70;

    cl:=Grid.Columns.Add;
    cl.FieldName:='CB_TEXT';
    cl.Title.Caption:='Основание';
    cl.Width:=100;

    cl:=Grid.Columns.Add;
    cl.FieldName:='CA_TEXT';
    cl.Title.Caption:='Приложение';
    cl.Width:=100;

    cl:=Grid.Columns.Add;
    cl.FieldName:='FNAME';
    cl.Title.Caption:='Кассир';
    cl.Width:=100;

    cl:=Grid.Columns.Add;
    cl.FieldName:='FNAME1';
    cl.Title.Caption:='Сотрудник';
    cl.Width:=100;

  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBCashOrders.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBCashOrders:=nil;
end;

procedure TfmRBCashOrders.ActiveQuery(CheckPerm: Boolean);
var
 sqls: String;
begin
 try
  Mainqr.Active:=false;
  if CheckPerm then
   if not CheckPermission then exit;

  Screen.Cursor:=crHourGlass;
  try
   Mainqr.sql.Clear;
    sqls := GetSQL;
   Mainqr.sql.Add(sqls);
   Mainqr.Transaction.Active:=false;
   Mainqr.Transaction.Active:=true;
   Mainqr.Active:=true;
   SetImageFilter(isFindDoc or isFindNum or isFindDate or isFindKassa or isFindKorAc or
                  isFindEmp or isFindBasis or isFindAppend or isFindCashier or isFindSum);
   ViewCount;
  finally
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBCashOrders.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBCashOrders.LoadFromIni;
begin
 inherited;
 try
   FindDoc := ReadParam(ClassName,'FindDoc',FindDoc);
   isFindNum := ReadParam(ClassName,'isFindNum',isFindNum);
   FindNumBeg := ReadParam(ClassName,'FindNumBeg',FindNumBeg);
   FindNumFin := ReadParam(ClassName,'FindNumFin',FindNumFin);
   isFindDate:= ReadParam(ClassName,'isFindDate',isFindDate);
   FindDateBeg := ReadParam(ClassName,'FindDateBeg',FindDateBeg);
   FindDateFin := ReadParam(ClassName,'FindDateFin',FindDateFin);
   FindKassa := ReadParam(ClassName,'FindKassa',FindKassa);
   FindKorAc := ReadParam(ClassName,'FindKorAc',FindKorAc);
   FindEmp := ReadParam(ClassName,'FindEmp',FindEmp);
   FindBasis := ReadParam(ClassName,'FindBasis',FindBasis);
   FindAppend := ReadParam(ClassName,'FindAppend',FindAppend);
   FindCashier := ReadParam(ClassName,'FindCashier',FindCashier);
   FindSum := ReadParam(ClassName,'FindSum',FindSum);
   FilterInside := ReadParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBCashOrders.SaveToIni;
begin
 Inherited;
 try
   WriteParam(ClassName,'FindDoc',FindDoc);
   WriteParam(ClassName,'isFindNum',isFindNum);
   WriteParam(ClassName,'FindNumBeg',FindNumBeg);
   WriteParam(ClassName,'FindNumFin',FindNumFin);
   WriteParam(ClassName,'isFindDate',isFindDate);
   WriteParam(ClassName,'FindDateBeg',FindDateBeg);
   WriteParam(ClassName,'FindDateFin',FindDateFin);
   WriteParam(ClassName,'FindKassa',FindKassa);
   WriteParam(ClassName,'FindKorAc',FindKorAc);
   WriteParam(ClassName,'FindEmp',FindEmp);
   WriteParam(ClassName,'FindBasis',FindBasis);
   WriteParam(ClassName,'FindAppend',FindAppend);
   WriteParam(ClassName,'FindCashier',FindCashier);
   WriteParam(ClassName,'FindSum',FindSum);
   WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBCashOrders.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBCashOrders.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBCashOrders;
begin
 try
  if not Mainqr.Active then exit;
  fm:=TfmEditRBCashOrders.Create(nil);
  try
    fm.bibOk.OnClick:=fm.AddClick;
    fm.Caption:=CaptionAdd;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('dok_name;ico_id',VarArrayOf([Trim(fm.CBDoc.Text),Trim(fm.ENum.Text)]),[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBCashOrders.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBCashOrders;
  qr,qr1: TIBQuery;
  sqls: string;
  IdInSub: TStrings;
  IdRec,IdRec2:Integer;
begin
 try
  if Mainqr.isEmpty then exit;
  fm:=TfmEditRBCashOrders.Create(nil);
  qr := TIBQuery.Create(nil);
  qr.Database := IBDB;
  qr.Transaction := IBTran;
  qr.Transaction.Active:=true;
  qr1 := TIBQuery.Create(nil);
  qr1.Database := IBDB;
  qr1.Transaction := IBTran;
  qr1.Transaction.Active:=true;
  IDInSub := TStringList.Create;
  try
    fm.bibOk.OnClick:=fm.ChangeClick;
    fm.Caption:=CaptionChange;
  fm.TDocId := Mainqr.fieldByName('dok_id').AsString;
  fm.Id := Mainqr.fieldByName('ico_id').AsString;
  fm.Date1 := Mainqr.fieldByName('co_date').AsString;

  //Время?????????
//  fm.Sub1
  fm.Time1 := Mainqr.fieldByName('co_time').AsString;
  fm.KassaId := Mainqr.fieldByName('co_kindkassa').AsString;
  fm.KorAc := Mainqr.fieldByName('co_idkoraccount').AsString;
  fm.CurId := Mainqr.fieldByName('co_currency_id').AsString;
  fm.Debit := Mainqr.fieldByName('co_debit').AsString;
  fm.Kredit := Mainqr.fieldByName('co_kredit').AsString;
  fm.BasId := Mainqr.fieldByName('co_idbasis').AsString;
  fm.AppId := Mainqr.fieldByName('co_idappend').AsString;
  fm.NDS := Mainqr.fieldByName('co_nds').AsString;
  fm.NP := Mainqr.fieldByName('co_np').AsString;
  fm.CashierId := Mainqr.fieldByName('co_cashier').AsString;
  fm.MainBKId := Mainqr.fieldByName('CO_MAINBOOKKEEPER').AsString;
  fm.Director := Mainqr.fieldByName('co_director').AsString;
  fm.EmpId := Mainqr.fieldByName('co_emp_id').AsString;
  fm.OnDocId := Mainqr.fieldByName('co_persondoctype_id').AsString;
  if fm.TDocId='' then fm.TDocId := 'NULL';
  if fm.CurId='' then fm.CurId := 'NULL';
  if fm.NDS='' then fm.NDS := 'NULL';
  if fm.NP='' then fm.NP := 'NULL';
  if fm.Director='' then fm.Director := 'NULL';
  if fm.OnDocId='' then fm.OnDocId := 'NULL';

  fm.FrameSubKassa.InitData(StrToInt(fm.KassaId),Trim(Mainqr.fieldByName('co_idinsubkas').AsString));
  fm.FrameSub.InitData(StrToInt(fm.KorAc),Trim(Mainqr.fieldByName('co_idinsubkonto').AsString));

  if fm.OnDocId='NULL' then begin
    fm.PInCashOrders.Visible := true;
    fm.POutCashOrders.Visible := false;
  end
  else begin
    fm.PInCashOrders.Visible := false;
    fm.POutCashOrders.Visible := true;
  end;

  fm.CBDoc.Text := Trim(Mainqr.fieldByName('DOK_NAME').AsString);
//  fm.CBDoc.OnChange := nil;
  fm.ENum.Text := Trim(Mainqr.fieldByName('ico_id').AsString);
  fm.DateTime.Date := StrToDate(Trim(Mainqr.fieldByName('co_date').AsString));
  fm.MEKassa.Text := Trim(Mainqr.fieldByName('pa_groupid').AsString);
  fm.MEKorAc.Text := Trim(Mainqr.fieldByName('pa_groupid1').AsString);
  fm.Label3.Enabled := true;
  fm.MEKorAc.Enabled := true;
  fm.BKorAc.Enabled := true;
  if fm.CurId <> 'NULL' then begin
    fm.GBCurrency.Visible := true;
    sqls := 'select * from '+tbCurrency+' where CURRENCY_ID='+Trim(MainQr.FieldByName('CO_CURRENCY_ID').AsString);
    qr.SQL.Clear;
    qr.SQL.Add(sqls);
    qr.Open;
    if not qr.IsEmpty then
      fm.ECur.Text := qr.FieldByName('SHORTNAME').AsString;
      fm.LKursCur.Caption := Mainqr.FieldByName('CO_CURSCURRENCY').AsString;
  end;
  if fm.EmpId<>'0' then begin
    sqls := 'select * from EMP where EMP_ID='+fm.EmpId;
    qr.SQL.Clear;
    qr.SQL.Add(sqls);
    qr.Open;
    if not qr.IsEmpty then
       fm.EEmp.Text := Trim(qr.FieldByName('FNAME').AsString)+' '+Trim(qr.FieldByName('NAME').AsString)+' '+
                       Trim(qr.FieldByName('SNAME').AsString);
  end;
  sqls := 'select * from EMP where EMP_ID='+fm.CashierId;
  qr.SQL.Clear;
  qr.SQL.Add(sqls);
  qr.Open;
  if not qr.IsEmpty then
    fm.ECashier.Text := Trim(qr.FieldByName('FNAME').AsString)+' '+Trim(qr.FieldByName('NAME').AsString)+' '+
                        Trim(qr.FieldByName('SNAME').AsString);
  sqls := 'select * from CASHBASIS where CB_ID='+fm.BasId;
  qr.SQL.Clear;
  qr.SQL.Add(sqls);
  qr.Open;
  if not qr.IsEmpty then
    fm.EBasis.Text := Trim(qr.FieldByName('CB_TEXT').AsString);
  sqls := 'select * from CASHAPPEND where CA_ID='+fm.AppId;
  qr.SQL.Clear;
  qr.SQL.Add(sqls);
  qr.Open;
  if not qr.IsEmpty then
    fm.EAppend.Text := Trim(qr.FieldByName('CA_TEXT').AsString);
  if fm.POutCashOrders.Visible then begin
    fm.LOnDoc.Enabled := true;
    fm.EOnDoc.Enabled := true;
    fm.BOnDoc.Enabled := true;
    fm.ESumKredit.Text := fm.Kredit;
    sqls := 'select * from PERSONDOCTYPE where PERSONDOCTYPE_ID='+fm.OnDocId;
    qr.SQL.Clear;
    qr.SQL.Add(sqls);
    qr.Open;
    if not qr.IsEmpty then
      fm.EOnDoc.Text := Trim(qr.FieldByName('NAME').AsString);
  end
  else begin
    fm.ESum.Text := fm.Debit;
  end;

  IdRec := MainQr.FieldByName('ICO_Id').AsInteger;
  IdRec2 := MainQr.FieldByName('DOK_Id').AsInteger;
  fm.IdRec1 :=IdRec;
  fm.IdRec2 :=IdRec2;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('ico_id;dok_id',VarArrayOf([fm.Id,fm.TDocId]),[LocaseInsensitive]);
    end;
  finally
    qr.Free;
    qr1.Free;
    fm.Free;
    IdInSub.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBCashOrders.bibDelClick(Sender: TObject);
var
  but: Integer;

  function DeleteRecord: Boolean;
  var
    qr: TIBQuery;
    sqls: string;
  begin
   Screen.Cursor:=crHourGlass;
   qr:=TIBQuery.Create(nil);
   try
    result:=false;
    try
     qr.Database:=IBDB;
     qr.Transaction:=IBTran;
     qr.Transaction.Active:=true;
     sqls:='Delete from '+tbCashOrders+
           ' where ico_id='+ QuotedStr(Mainqr.FieldByName('ICO_ID').asString)+' AND '+
           'dok_id='+QuotedStr(Mainqr.FieldByName('DOK_ID').asString);
     qr.sql.Add(sqls);
     qr.ExecSQL;
     sqls:='Delete from '+tbMagazinePostings+
           ' where MP_DOKUMENT='+QuotedStr(Mainqr.FieldByName('DOK_ID').asString)+' AND '+
           'MP_DOCUMENTID='+QuotedStr(Mainqr.FieldByName('ICO_ID').asString);
     qr.SQL.Clear;      
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;
     ActiveQuery(false);
     Result:=true;
    except
     on E: EIBInterBaseError do begin
        TempStr:=TranslateIBError(E.Message);
        ShowError(Handle,TempStr);
        Assert(false,TempStr);
     end;
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   finally
    qr.Free;
    Screen.Cursor:=crDefault;
   end;

  end;

begin
  if  Mainqr.isEmpty then exit;
  but:=MessageBox(Application.Handle,
                  Pchar(CaptionDelete+' текущую запись ?'),
                  ConstWarning,MB_YESNO+MB_ICONWARNING);
  if but=ID_YES then begin
    if not deleteRecord then begin
      ShowError(Application.Handle,
               'Доступ к приложению <'+Mainqr.FieldByName('taname').AsString+
               '> у пользователя <'+Mainqr.FieldByName('tuname').AsString+'> используется.');
    end;
  end;
end;

procedure TfmRBCashOrders.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBCashOrders;
  qr,qr1: TIBQuery;
  sqls: string;
  IdInSub: TStrings;
  IdRec,IdRec2:Integer;
begin
 try
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  fm:=TfmEditRBCashOrders.Create(nil);
  qr := TIBQuery.Create(nil);
  qr.Database := IBDB;
  qr.Transaction := IBTran;
  qr.Transaction.Active:=true;
  qr1 := TIBQuery.Create(nil);
  qr1.Database := IBDB;
  qr1.Transaction := IBTran;
  qr1.Transaction.Active:=true;
  IDInSub := TStringList.Create;
  try
    fm.bibOk.OnClick:=nil;
    fm.bibOk.Visible:=false;
    fm.bibCancel.Caption:=CaptionClose;
    fm.Caption:=CaptionView;

  fm.TDocId := Mainqr.fieldByName('dok_id').AsString;
  fm.Id := Mainqr.fieldByName('ico_id').AsString;
  fm.Date1 := Mainqr.fieldByName('co_date').AsString;

  //Время?????????

  fm.Time1 := Mainqr.fieldByName('co_time').AsString;
  fm.KassaId := Mainqr.fieldByName('co_kindkassa').AsString;
  fm.KorAc := Mainqr.fieldByName('co_idkoraccount').AsString;
  fm.CurId := Mainqr.fieldByName('co_currency_id').AsString;
  fm.Debit := Mainqr.fieldByName('co_debit').AsString;
  fm.Kredit := Mainqr.fieldByName('co_kredit').AsString;
  fm.BasId := Mainqr.fieldByName('co_idbasis').AsString;
  fm.AppId := Mainqr.fieldByName('co_idappend').AsString;
  fm.NDS := Mainqr.fieldByName('co_nds').AsString;
  fm.NP := Mainqr.fieldByName('co_np').AsString;
  fm.CashierId := Mainqr.fieldByName('co_cashier').AsString;
  fm.MainBKId := Mainqr.fieldByName('CO_MAINBOOKKEEPER').AsString;
  fm.Director := Mainqr.fieldByName('co_director').AsString;
  fm.EmpId := Mainqr.fieldByName('co_emp_id').AsString;
  fm.OnDocId := Mainqr.fieldByName('co_persondoctype_id').AsString;
  if fm.TDocId='' then fm.TDocId := 'NULL';
  if fm.CurId='' then fm.CurId := 'NULL';
  if fm.NDS='' then fm.NDS := 'NULL';
  if fm.NP='' then fm.NP := 'NULL';
  if fm.Director='' then fm.Director := 'NULL';
  if fm.OnDocId='' then fm.OnDocId := 'NULL';

  fm.FrameSubKassa.InitData(StrToInt(fm.KassaId),Trim(Mainqr.fieldByName('co_idinsubkas').AsString));
  fm.FrameSub.InitData(StrToInt(fm.KorAc),Trim(Mainqr.fieldByName('co_idinsubkonto').AsString));

  if fm.OnDocId='NULL' then begin
    fm.PInCashOrders.Visible := true;
    fm.POutCashOrders.Visible := false;
  end
  else begin
    fm.PInCashOrders.Visible := false;
    fm.POutCashOrders.Visible := true;
  end;

  fm.CBDoc.Text := Trim(Mainqr.fieldByName('DOK_NAME').AsString);
//  fm.CBDoc.OnChange := nil;
  fm.ENum.Text := Trim(Mainqr.fieldByName('ico_id').AsString);
  fm.DateTime.Date := StrToDate(Trim(Mainqr.fieldByName('co_date').AsString));
  fm.MEKassa.Text := Trim(Mainqr.fieldByName('pa_groupid').AsString);
  fm.MEKorAc.Text := Trim(Mainqr.fieldByName('pa_groupid1').AsString);
  fm.Label3.Enabled := true;
  fm.MEKorAc.Enabled := true;
  fm.BKorAc.Enabled := true;
  if fm.CurId <> 'NULL' then begin
    fm.GBCurrency.Visible := true;
    sqls := 'select * from '+tbCurrency+' where CURRENCY_ID='+Trim(MainQr.FieldByName('CO_CURRENCY_ID').AsString);
    qr.SQL.Clear;
    qr.SQL.Add(sqls);
    qr.Open;
    if not qr.IsEmpty then
      fm.ECur.Text := qr.FieldByName('SHORTNAME').AsString;
      fm.LKursCur.Caption := Mainqr.FieldByName('CO_CURSCURRENCY').AsString;
  end;
  if fm.EmpId<>'0' then begin
    sqls := 'select * from EMP where EMP_ID='+fm.EmpId;
    qr.SQL.Clear;
    qr.SQL.Add(sqls);
    qr.Open;
    if not qr.IsEmpty then
       fm.EEmp.Text := Trim(qr.FieldByName('FNAME').AsString)+' '+Trim(qr.FieldByName('NAME').AsString)+' '+
                       Trim(qr.FieldByName('SNAME').AsString);
  end;
  sqls := 'select * from EMP where EMP_ID='+fm.CashierId;
  qr.SQL.Clear;
  qr.SQL.Add(sqls);
  qr.Open;
  if not qr.IsEmpty then
    fm.ECashier.Text := Trim(qr.FieldByName('FNAME').AsString)+' '+Trim(qr.FieldByName('NAME').AsString)+' '+
                        Trim(qr.FieldByName('SNAME').AsString);
  sqls := 'select * from CASHBASIS where CB_ID='+fm.BasId;
  qr.SQL.Clear;
  qr.SQL.Add(sqls);
  qr.Open;
  if not qr.IsEmpty then
    fm.EBasis.Text := Trim(qr.FieldByName('CB_TEXT').AsString);
  sqls := 'select * from CASHAPPEND where CA_ID='+fm.AppId;
  qr.SQL.Clear;
  qr.SQL.Add(sqls);
  qr.Open;
  if not qr.IsEmpty then
    fm.EAppend.Text := Trim(qr.FieldByName('CA_TEXT').AsString);
  if fm.POutCashOrders.Visible then begin
    fm.LOnDoc.Enabled := true;
    fm.EOnDoc.Enabled := true;
    fm.BOnDoc.Enabled := true;
    fm.ESumKredit.Text := fm.Kredit;
    sqls := 'select * from PERSONDOCTYPE where PERSONDOCTYPE_ID='+fm.OnDocId;
    qr.SQL.Clear;
    qr.SQL.Add(sqls);
    qr.Open;
    if not qr.IsEmpty then
      fm.EOnDoc.Text := Trim(qr.FieldByName('NAME').AsString);
  end
  else begin
    fm.ESum.Text := fm.Debit;
  end;

  fm.CBDoc.Enabled := false;
  fm.ENum.Enabled := false;
  fm.BCur.Visible := false;
  fm.BKassa.Visible := false;
  fm.BKorAc.Visible := false;
  fm.BEmp.Visible := false;
  fm.BBasis.Visible := false;
  fm.BAppend.Visible := false;
  fm.BOnDoc.Visible := false;
  fm.BCashier.Visible := false;
  fm.BNDS.Visible := false;
  fm.ESum.Enabled := false;
  fm.ESumKredit.Enabled := false;

  if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
    qr.Free;
    qr1.Free;
    IdInSub.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBCashOrders.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBCashOrders;
  filstr: string;
  LstAccount: TStrings;
  Account: string;
begin
try
 fm:=TfmEditRBCashOrders.Create(nil);
 LstAccount:=TStringList.Create;
 try
  fm.Caption:=CaptionFilter;
  fm.bibOK.OnClick := fm.filterClick;
  fm.GBKassa.Visible := false;
  fm.GBKorAc.Visible := false;
  fm.PFilter.Visible := true;
  fm.CBDoc.OnChange := nil;
  fm.ENum.Visible := false;
  fm.LNum.Visible := false;
  fm.CBNDS.Visible := false;
  fm.LNDS.Visible := false;
  fm.ENDS.Visible := false;
  fm.BNDS.Visible := false;
  fm.LNDS1.Visible := false;
  fm.ESumNDS.Visible := false;
  fm.CBDoc.Text := '';
  fm.LEmp.Top := fm.LEmp.Top-120;
  fm.EEmp.Top := fm.EEmp.Top-120;
  fm.BEmp.Top := fm.BEmp.Top-120;
  fm.LBasis.Top := fm.LBasis.Top-120;
  fm.EBasis.Top := fm.EBasis.Top-120;
  fm.BBasis.Top := fm.BBasis.Top-120;
  fm.LAppend.Top := fm.LAppend.Top-120;
  fm.EAppend.Top := fm.EAppend.Top-120;
  fm.BAppend.Top := fm.BAppend.Top-120;
  fm.PInCashOrders.Top := fm.PInCashOrders.Top-120;
  fm.LCashier.Top := fm.LCashier.Top-120;
  fm.ECashier.Top := fm.ECashier.Top-120;
  fm.BCashier.Top := fm.BCashier.Top-120;
  fm.cbInString.Top := fm.cbInString.Top-120;
  fm.pnBut.Top := fm.pnBut.Top-120;
  fm.Height := fm.Height-120;
  fm.EEmp.ReadOnly := false;
  fm.EBasis.ReadOnly := false;
  fm.EAppend.ReadOnly := false;
  fm.ECashier.ReadOnly := false;

  if Trim(FindDoc)<>'' then fm.CBDoc.Text := FindDoc;
  fm.CBNumFilter.Checked := isFindNum;
  if Trim(FindNumBeg)<>'' then fm.ENumBeg.Text := FindNumBeg;
  if Trim(FindNumFin)<>'' then fm.ENumFin.Text := FindNumFin;
  fm.CBDateFilter.Checked := isFindDate;
  if Trim(FindDateBeg)<>'' then fm.DTPBeg.Date := StrToDate(FindDateBeg);
  if Trim(FindDateFin)<>'' then fm.DTPFin.Date := StrToDate(FindDateFin);
  if Trim(FindKassa)<>'' then fm.MEKassaFilter.Text := FindKassa;
  if Trim(FindKorAc)<>'' then fm.MEKorAcFilter.Text := FindKorAc;
  if Trim(FindEmp)<>'' then fm.EEmp.Text := FindEmp;
  if Trim(FindBasis)<>'' then fm.EBasis.Text := FindBasis;
  if Trim(FindAppend)<>'' then fm.EAppend.Text := FindAppend;
  if Trim(FindCashier)<>'' then fm.ECashier.Text := FindCashier;
  if Trim(FindSum)<>'' then fm.ESum.Text := FindSum;

  fm.cbInString.Visible:=true;
  fm.bibClear.Visible:=true;
  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    LstAccount:=divide(Trim(fm.MEKassaFilter.Text));
    if (LstAccount.Strings[0]<>'') then begin
      Account := LstAccount.Strings[0];
      if (LstAccount.Strings[1]<>'') then begin
        Account := Account+'.'+LstAccount.Strings[1];
        if (LstAccount.Strings[2]<>'') then begin
          Account := Account+'.'+LstAccount.Strings[2];
        end;
      end;
    end;
    FindKassa := Account;
    LstAccount.Clear;
    Account := '';
    LstAccount:=divide(Trim(fm.MEKorAcFilter.Text));
    if (LstAccount.Strings[0]<>'') then begin
      Account := LstAccount.Strings[0];
      if (LstAccount.Strings[1]<>'') then begin
        Account := Account+'.'+LstAccount.Strings[1];
        if (LstAccount.Strings[2]<>'') then begin
          Account := Account+'.'+LstAccount.Strings[2];
        end;
      end;
    end;
    FindKorAc := Account;
    FindDoc := Trim(fm.CBDoc.Text);
    isFindNum := fm.CBNumFilter.Checked;
    FindNumBeg := Trim(fm.ENumBeg.Text);
    FindNumFin := Trim(fm.ENumFin.Text);
    isFindDate := fm.CBDateFilter.Checked;
    FindDateBeg := DateToStr(fm.DTPBeg.Date);
    FindDateFin := DateToStr(fm.DTPFin.Date);
    FindEmp := Trim(fm.EEmp.Text);
    FindBasis := Trim(fm.EBasis.Text);
    FindAppend := Trim(fm.EAppend.Text);
    FindCashier := Trim(fm.ECashier.Text);
    FindSum := Trim(fm.ESum.Text);

    FilterInSide:=fm.cbInString.Checked;
    if FilterInSide then filstr:='%';

    ActiveQuery(false);
    ViewCount;
  end;
 finally
  fm.Free;
  LstAccount.Free;
 end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

function TfmRBCashOrders.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2,addstr3,addstr4,addstr5,addstr6,addstr7,
  addstr8,addstr9,addstr10,addstr11,addstr12: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then begin
      Result := KillWhereFromWhereStr(Result); 
      exit;
    end;

    isFindDoc:=Trim(FindDoc)<>'';
    isFindKassa:=Trim(FindKassa)<>'';
    isFindKorAc:=Trim(FindKorAc)<>'';
    isFindEmp:=Trim(FindEmp)<>'';
    isFindBasis:=Trim(FindBasis)<>'';
    isFindAppend:=Trim(FindAppend)<>'';
    isFindCashier:=Trim(FindCashier)<>'';
    isFindSum:=Trim(FindSum)<>'';

    wherestr:=' AND ';

    if FilterInside then FilInSide:='%';

     if isFindDoc then begin
        addstr1:=wherestr+' Upper(D.DOK_NAME) like '+AnsiUpperCase(QuotedStr(FilInSide+FindDoc+'%'))+' ';
     end;
     if isFindKassa then begin
        addstr2:=wherestr+' Upper(P1.PA_GROUPID) like '+AnsiUpperCase(QuotedStr(FilInSide+FindKassa+'%'))+' ';
     end;
     if isFindKorAc then begin
        addstr3:=wherestr+' Upper(P2.PA_GROUPID) like '+AnsiUpperCase(QuotedStr(FilInSide+FindKorAc+'%'))+' ';
     end;
     if isFindEmp then begin
        addstr4:=wherestr+' Upper(E2.FNAME) like '+AnsiUpperCase(QuotedStr(FilInSide+FindEmp+'%'))+' ';
     end;
     if isFindBasis then begin
        addstr5:=wherestr+' Upper(CB_TEXT) like '+AnsiUpperCase(QuotedStr(FilInSide+FindBasis+'%'))+' ';
     end;
     if isFindAppend then begin
        addstr6:=wherestr+' Upper(CA_TEXT) like '+AnsiUpperCase(QuotedStr(FilInSide+FindAppend+'%'))+' ';
     end;
     if isFindCashier then begin
        addstr7:=wherestr+' Upper(E1.FNAME) like '+AnsiUpperCase(QuotedStr(FilInSide+FindCashier+'%'))+' ';
     end;
     if isFindSum then begin
        addstr8:=wherestr+' (CO_DEBIT>='+(FindSum)+' or '+' CO_KREDIT>='+(FindSum)+') ';
     end;
     if isFindNum then begin
        if FindNumBeg='' then FindNumBeg := '0';
        if FindNumFin='' then addstr9:=wherestr+' ICO_ID>='+(FindNumBeg)+' '
        else
          addstr9:=wherestr+' (ICO_ID>='+(FindNumBeg)+' and ICO_ID<='+(FindNumFin)+') ';
     end;
     if isFindDate then begin
       addstr10:=wherestr+' (CO_DATE>='+QuotedStr(FindDateBeg)+' and CO_DATE<='+QuotedStr(FindDateFin)+') ';
     end;
     Result:=addstr1+addstr2+addstr3+addstr4+addstr5+addstr6+addstr7+addstr8+addstr9+addstr10;
end;

function TfmRBCashOrders.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkCashOrders+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBCashOrders.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id1,id2: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   if fn='FNAME' then
     fn := 'E1.FNAME';
   if fn='FNAME1' then
     fn := 'E2.FNAME';
   if fn='PA_GROUPID' then
     fn := 'P1.PA_GROUPID';
   if fn='PA_GROUPID1' then
     fn := 'P2.PA_GROUPID';
   id1:=MainQr.fieldByName('ico_id').asString;
   id2:=MainQr.fieldByName('dok_id').asString;
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('ico_id;dok_id',VarArrayOf([id1,id2]),[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBCashOrders.bibPostingsClick(Sender: TObject);
var
  qrmp,qrco,qrinsert: TIBQuery;
  sqls,cur,subkas,subkorac,curscur: string;
  s: PChar;
  t: integer;
begin
  inherited;
 try
   qrmp := TIBQuery.Create(nil);
   qrco := TIBQuery.Create(nil);
   qrinsert := TIBQuery.Create(nil);
   qrmp.Database := IBDB;
   qrmp.Transaction := IBTran;
   qrco.Database := IBDB;
   qrco.Transaction := IBTran;
   qrinsert.Database := IBDB;
   qrinsert.Transaction := IBTran;
   try
     sqls := 'select c.*,cb_text from '+tbCashorders+' c,'+tbCashBasis+
             ' where co_idbasis=cb_id';
     qrco.SQL.Clear;
     qrco.SQL.Add(sqls);
     qrco.Open;
     sqls := 'select * from '+tbMagazinePostings;
     qrmp.SQL.Clear;
     qrmp.SQL.Add(sqls);
     qrmp.Open;
     qrco.First;

     while not qrco.Eof do begin
        if not qrmp.Locate('mp_dokument;mp_documentid',VarArrayOf([qrco.FieldByName('dok_id').AsInteger,qrco.FieldByName('ico_id').AsInteger]),[loCaseInsensitive]) then
          begin
            cur:='NULL';
            subkas:='NULL';
            subkorac:='NULL';
            curscur:='NULL';
            if Trim(qrco.FieldByName('co_currency_id').AsString)<>'' then cur:= Trim(qrco.FieldByName('co_currency_id').AsString);
            if Trim(qrco.FieldByName('co_idinsubkas').AsString)<>'' then subkas:= QuotedStr(Trim(qrco.FieldByName('co_idinsubkas').AsString));
            if Trim(qrco.FieldByName('co_idinsubkonto').AsString)<>'' then subkorac:= QuotedStr(Trim(qrco.FieldByName('co_idinsubkonto').AsString));
            if Trim(qrco.FieldByName('co_curscurrency').AsString)<>'' then curscur:= QuotedStr(Trim(qrco.FieldByName('co_curscurrency').AsString));

            if qrco.FieldByName('co_debit').AsFloat<>0 then begin
              s := PChar(FormatFloat('0.00',qrco.FieldByName('co_debit').AsFloat));
              t:=Pos(',',s);
              if t<>0 then
                s[t-1]:='.';
              sqls := 'Insert into MAGAZINEPOSTINGS '+
                      '(MP_ID,MP_DOKUMENT,MP_DOCUMENTID,MP_IDINDOCUMENT,MP_DATE,MP_TIME,'+
                      'MP_DEBETID,MP_CREDITID,MP_CONTENTSOPERA,MP_CONTENTSPOSTI,MP_COUNT,'+
                      'MP_SUMMA,MP_CURRENCY_ID,MP_SUBKONTODT,MP_SUBKONTOKT,MP_CURSCURRENCY) values('+
                      'gen_id(gen_mp_id,1)'+','+Trim(qrco.FieldByName('dok_id').AsString)+','+
                       Trim(qrco.FieldByName('ico_id').AsString)+','+
                       '0'+','+
                       QuotedStr(Trim(qrco.FieldByName('co_date').AsString))+','+
                       QuotedStr(Trim(qrco.FieldByName('co_time').AsString))+','+
                       Trim(qrco.FieldByName('co_kindkassa').AsString)+','+
                       Trim(qrco.FieldByName('co_idkoraccount').AsString)+','+
                       QuotedStr('Поступление в кассу:'+Trim(qrco.FieldByName('cb_text').AsString))+','+
                       QuotedStr('Приход')+','+
                       'NULL'+','+
                       QuotedStr(s)+','+
                       cur+','+
                       subkas+','+
                       subkorac+','+
                       curscur+')';
              end
            else begin
              s := PChar(FormatFloat('0.00',qrco.FieldByName('co_kredit').AsFloat));
              t:=Pos(',',s);
              if t<>0 then
                s[t-1]:='.';
              sqls := 'Insert into MAGAZINEPOSTINGS '+
                      '(MP_ID,MP_DOKUMENT,MP_DOCUMENTID,MP_IDINDOCUMENT,MP_DATE,MP_TIME,'+
                      'MP_DEBETID,MP_CREDITID,MP_CONTENTSOPERA,MP_CONTENTSPOSTI,MP_COUNT,'+
                      'MP_SUMMA,MP_CURRENCY_ID,MP_SUBKONTODT,MP_SUBKONTOKT,MP_CURSCURRENCY) values('+
                      'gen_id(gen_mp_id,1)'+','+
                       Trim(qrco.FieldByName('dok_id').AsString)+','+
                       Trim(qrco.FieldByName('ico_id').AsString)+','+
                       '0'+','+
                       QuotedStr(Trim(qrco.FieldByName('co_date').AsString))+','+
                       QuotedStr(Trim(qrco.FieldByName('co_time').AsString))+','+
                       Trim(qrco.FieldByName('co_idkoraccount').AsString)+','+
                       Trim(qrco.FieldByName('co_kindkassa').AsString)+','+
                       QuotedStr('Выдача из кассы:'+Trim(qrco.FieldByName('cb_text').AsString))+','+
                       QuotedStr('Расход')+','+
                       'NULL'+','+
                       QuotedStr(s)+','+
                       cur+','+
                       subkorac+','+
                       subkas+','+
                       curscur+')';
            end;
            qrinsert.SQL.Clear;
            qrinsert.SQl.Add(sqls);
            qrinsert.ExecSQL;
            qrinsert.Transaction.Commit;
            qrinsert.Transaction.Active := true;
            qrco.Transaction.Active := true;
            qrmp.Transaction.Active := true;
            qrco.Active:=true;
            qrmp.Active:=true;
          end;
         qrco.Next;
     end;

   finally
     qrmp.Free;
     qrco.Free;
     ActiveQuery(true);
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

procedure TfmRBCashOrders.bibPrintClick(Sender: TObject);
begin
  GenerateReport;
  Rpt.Execute;
end;

destructor TRptExcelThreadInCO.Destroy;
begin
  inherited;
  _FreeProgressBar(PBHandle);
end;

procedure TfmRBCashOrders.GenerateReport;
begin
  if Rpt<>nil then exit;
  Rpt:=TRptExcelThreadInCo.Create;
  Rpt.fmParent:=Self;
  Rpt.OnTerminate:=OnRptTerminate;
  Rpt.Resume;
end;

procedure TfmRBCashOrders.OnRptTerminate(Sender: TObject);
begin
  FreeAndNil(Rpt);
end;

procedure TRptExcelThreadInCO.ExecuteInCO;
var
  Wb: OleVariant;
  Sh: OleVariant;
  Data: OleVariant;
  Range: OleVariant;
  sqls: string;
  RecCount: Integer;
  Row,Column,i: Integer;
  dx,dy: Integer;
  TCPB: TCreateProgressBar;
  TSPBS: TSetProgressBarStatus;
  str: string;
  qr: TIBQuery;
  nds1,np1: string;
begin
 inherited;
 try
  qr := TIBQuery.Create(nil);
  qr.Database := IBDB;
  qr.Transaction := IBT;
  try
   if CoInitialize(nil)<>S_OK then exit;
   try
    if not Rpt.CreateReport then exit;
    TCPB.Min:=1;
    TCPB.Max:=14;
    TCPB.Hint:='';
    TCPB.Color:=clRed;
    Rpt.PBHandle:=_CreateProgressBar(@TCPB);
    Wb:=Rpt.Excel.Workbooks.Open(_GetOptions.DirTemp+'\'+'InCO.xls');
    Sh:=Wb.Sheets.Item[1];
   //формируем название организации;
    sqls := 'select * from '+tbConstex;
    qr.SQL.Clear;
    qr.SQL.Add(sqls);
    qr.Open;
    if qr.Locate('NAME','Предприятие',[loCaseInsensitive]) then begin
      sqls := 'select * from '+tbPlant+
              ' where plant_id='+Trim(qr.FieldByName('VALUETABLE').AsString);
      qr.SQL.Clear;
      qr.SQL.Add(sqls);
      qr.Open;
      if not qr.IsEmpty then begin
        Sh.Range[Sh.Cells[7,1],Sh.Cells[7,1]].Value := qr.FieldByName('Fullname').AsString;
        Sh.Range[Sh.Cells[3,12],Sh.Cells[3,12]].Value := qr.FieldByName('smallname').AsString;
        TSPBS.Progress:=1;
        TSPBS.Hint:='';
        _SetProgressBarStatus(Rpt.PBHandle,@TSPBS);
      end
    end;
   //конец
   Sh.Range[Sh.Cells[12,6],Sh.Cells[12,6]].Value := fmRBCashOrders.Mainqr.FieldByName('ICO_ID').AsString;
   TSPBS.Progress:=2;
   TSPBS.Hint:='';
   _SetProgressBarStatus(Rpt.PBHandle,@TSPBS);
   Sh.Range[Sh.Cells[12,8],Sh.Cells[12,8]].Value := fmRBCashOrders.Mainqr.FieldByName('CO_DATE').AsString;
   TSPBS.Progress:=3;
   TSPBS.Hint:='';
   _SetProgressBarStatus(Rpt.PBHandle,@TSPBS);
   Sh.Range[Sh.Cells[18,1],Sh.Cells[18,1]].Value := fmRBCashOrders.Mainqr.FieldByName('PA_GROUPID').AsString;
   TSPBS.Progress:=4;
   TSPBS.Hint:='';
   _SetProgressBarStatus(Rpt.PBHandle,@TSPBS);
   Sh.Range[Sh.Cells[18,4],Sh.Cells[18,4]].Value := fmRBCashOrders.Mainqr.FieldByName('PA_GROUPID1').AsString;
   TSPBS.Progress:=5;
   TSPBS.Hint:='';
   _SetProgressBarStatus(Rpt.PBHandle,@TSPBS);
   //формирование полного имени сотрудника
   sqls := 'select * from '+tbEmp+
           ' where emp_id='+fmRBCashOrders.Mainqr.FieldByName('co_emp_id').AsString;
   qr.SQL.Clear;
   qr.SQL.Add(sqls);
   qr.Open;
   if not qr.IsEmpty then begin
     Sh.Range[Sh.Cells[20,3],Sh.Cells[20,3]].Value := qr.FieldByName('fname').AsString+' '+
     qr.FieldByName('name').AsString+' '+qr.FieldByName('sname').AsString;
     Sh.Range[Sh.Cells[10,12],Sh.Cells[10,12]].Value := qr.FieldByName('fname').AsString+' '+
     qr.FieldByName('name').AsString+' '+qr.FieldByName('sname').AsString;
   end;
   TSPBS.Progress:=7;
   TSPBS.Hint:='';
   _SetProgressBarStatus(PBHandle,@TSPBS);
   //конец
   Sh.Range[Sh.Cells[22,3],Sh.Cells[22,3]].Value := fmRBCashOrders.Mainqr.FieldByName('cb_text').AsString;
   TSPBS.Progress:=8;
   TSPBS.Hint:='';
   _SetProgressBarStatus(Rpt.PBHandle,@TSPBS);
   Sh.Range[Sh.Cells[12,12],Sh.Cells[12,12]].Value := fmRBCashOrders.Mainqr.FieldByName('cb_text').AsString;
   TSPBS.Progress:=9;
   TSPBS.Hint:='';
   _SetProgressBarStatus(Rpt.PBHandle,@TSPBS);
   //формирование главного бухгалтера
   sqls := 'select * from '+tbEmp+
           ' where emp_id='+Trim(fmRBCashOrders.Mainqr.FieldByName('CO_MAINBOOKKEEPER').AsString);
   qr.SQL.Clear;
   qr.SQL.Add(sqls);
   qr.Open;
   if not qr.IsEmpty then begin
     Sh.Range[Sh.Cells[33,7],Sh.Cells[33,7]].Value := qr.FieldByName('fname').AsString;
     Sh.Range[Sh.Cells[33,13],Sh.Cells[33,13]].Value := qr.FieldByName('fname').AsString;
   end;
   //конец
   TSPBS.Progress:=10;
   TSPBS.Hint:='';
   _SetProgressBarStatus(Rpt.PBHandle,@TSPBS);
   Sh.Range[Sh.Cells[36,7],Sh.Cells[36,7]].Value := fmRbCashOrders.Mainqr.FieldByName('fname').AsString;
   TSPBS.Progress:=11;
   TSPBS.Hint:='';
   _SetProgressBarStatus(Rpt.PBHandle,@TSPBS);
   Sh.Range[Sh.Cells[36,13],Sh.Cells[36,13]].Value := fmRbCashOrders.Mainqr.FieldByName('fname').AsString;
   TSPBS.Progress:=12;
   TSPBS.Hint:='';
   _SetProgressBarStatus(Rpt.PBHandle,@TSPBS);
   Sh.Range[Sh.Cells[18,6],Sh.Cells[18,6]].Value := fmRbCashOrders.Mainqr.FieldByName('co_debit').AsFloat;
   TSPBS.Progress:=13;
   TSPBS.Hint:='';
   _SetProgressBarStatus(Rpt.PBHandle,@TSPBS);
   //формируем поле "в том числе"
   nds1:='0';
   if fmRbCashOrders.Mainqr.FieldByName('CO_NDS').AsString<>'' then nds1:=fmRbCashOrders.Mainqr.FieldByName('CO_NDS').AsString;
   np1:='0';
   if fmRbCashOrders.Mainqr.FieldByName('CO_NP').AsString<>'' then np1:=fmRbCashOrders.Mainqr.FieldByName('CO_NP').AsString;
   Sh.Range[Sh.Cells[29,'C'],Sh.Cells[29,'C']].Value := 'НДС:'+nds1+'  НП:'+np1;
   Sh.Range[Sh.Cells[23,'L'],Sh.Cells[23,'L']].Value := 'НДС:'+nds1+'  НП:'+np1;
   TSPBS.Progress:=14;
   TSPBS.Hint:='';
   _SetProgressBarStatus(PBHandle,@TSPBS);
   //конец
   finally
    if not VarIsEmpty(Rpt.Excel) then begin
     Rpt.Excel.ActiveWindow.WindowState:=xlMaximized;
     Rpt.Excel.Visible:=true;
     Rpt.Excel.WindowState:=xlMaximized;
    end;
    Rpt.DoTerminate;
   end;
  finally
   CoUninitialize;
   qr.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TRptExcelThreadInCO.Execute;
var
  rs: TResourceStream;
begin
  rs:=nil;
  try
    if AnsiUpperCase(Trim(fmRBCashOrders.Mainqr.FieldByName('DOK_NAME').AsString))='ПРИХОДНЫЙ КАССОВЫЙ ОРДЕР' then begin
      rs:=TResourceStream.Create(HInstance,'RPTINCO','REPORT');
      if not FileExists(_GetOptions.DirTemp+'\'+'InCO.xls') then
        rs.SaveToFile(_GetOptions.DirTemp+'\'+'InCO.xls');
      ExecuteInCO;
    end
    else begin
      rs:=TResourceStream.Create(HInstance,'RPTOUTCO','REPORT');
      if not FileExists(_GetOptions.DirTemp+'\'+'OutCO.xls') then
        rs.SaveToFile(_GetOptions.DirTemp+'\'+'OutCO.xls');
      Rpt.ExecuteOutCO;
    end;
  finally
    rs.Free;
  end;
end;

procedure TRptExcelThreadInCO.ExecuteOutCO;
var
  Wb: OleVariant;
  Sh: OleVariant;
  Data: OleVariant;
  Range: OleVariant;
  sqls: string;
  RecCount: Integer;
  Row,Column,i: Integer;
  dx,dy: Integer;
  TCPB: TCreateProgressBar;
  TSPBS: TSetProgressBarStatus;
  str: string;
  qr: TIBQuery;
  boss_id: integer;
begin
 try
  _SetSplashStatus(ConstReportExecute);
  qr := TIBQuery.Create(nil);
  qr.Database := IBDB;
  qr.Transaction := IBT;
  try
   if CoInitialize(nil)<>S_OK then exit;
   try
    if not CreateReport then exit;
    TCPB.Min:=1;
    TCPB.Max:=17;
    TCPB.Hint:='';
    TCPB.Color:=clRed;
    PBHandle:=_CreateProgressBar(@TCPB);
    Wb:=Excel.Workbooks.Open(_GetOptions.DirTemp+'\'+'OutCO.xls');
    Sh:=Wb.Sheets.Item[1];
    //формируем название организации;
    sqls := 'select * from '+tbConstex;
    qr.SQL.Clear;
    qr.SQL.Add(sqls);
    qr.Open;
    if qr.Locate('NAME','Руководитель',[loCaseInsensitive]) then begin
      boss_id := qr.FieldByName('VALUETABLE').AsInteger;
      Sh.Range[Sh.Cells[33,'AA'],Sh.Cells[33,'AA']].Value := qr.FieldByName('NOTE').AsString;
      TSPBS.Progress:=1;
      TSPBS.Hint:='';
      _SetProgressBarStatus(PBHandle,@TSPBS);
    end;
    if qr.Locate('NAME','Предприятие',[loCaseInsensitive]) then begin
      sqls := 'select * from '+tbPlant+
              ' where plant_id='+Trim(qr.FieldByName('VALUETABLE').AsString);
      qr.SQL.Clear;
      qr.SQL.Add(sqls);
      qr.Open;
      if not qr.IsEmpty then begin
        Sh.Range[Sh.Cells[8,'A'],Sh.Cells[8,'A']].Value := qr.FieldByName('Fullname').AsString;
        TSPBS.Progress:=2;
        TSPBS.Hint:='';
        _SetProgressBarStatus(PBHandle,@TSPBS);
      end
    end;
   //конец
   Sh.Range[Sh.Cells[14,'BG'],Sh.Cells[14,'BG']].Value := fmRBCashOrders.Mainqr.FieldByName('ico_id').AsString;
   TSPBS.Progress:=3;
   TSPBS.Hint:='';
   _SetProgressBarStatus(PBHandle,@TSPBS);
   Sh.Range[Sh.Cells[14,'BU'],Sh.Cells[14,'BU']].Value := fmRBCashOrders.Mainqr.FieldByName('co_date').AsString;
   TSPBS.Progress:=4;
   TSPBS.Hint:='';
   _SetProgressBarStatus(PBHandle,@TSPBS);
   Sh.Range[Sh.Cells[19,'AM'],Sh.Cells[19,'AM']].Value := fmRBCashOrders.Mainqr.FieldByName('pa_groupid').AsString;
   TSPBS.Progress:=5;
   TSPBS.Hint:='';
   _SetProgressBarStatus(PBHandle,@TSPBS);
   Sh.Range[Sh.Cells[19,'P'],Sh.Cells[19,'P']].Value := fmRBCashOrders.Mainqr.FieldByName('pa_groupid1').AsString;
   TSPBS.Progress:=6;
   TSPBS.Hint:='';
   _SetProgressBarStatus(PBHandle,@TSPBS);
   //формирование полного имени сотрудника
   sqls := 'select * from '+tbEmp+
           ' where emp_id='+fmRBCashOrders.Mainqr.FieldByName('co_emp_id').AsString;
   qr.SQL.Clear;
   qr.SQL.Add(sqls);
   qr.Open;
   if not qr.IsEmpty then
     Sh.Range[Sh.Cells[21,'N'],Sh.Cells[21,'N']].Value := qr.FieldByName('fname').AsString+' '+
     qr.FieldByName('name').AsString+' '+qr.FieldByName('sname').AsString;
   TSPBS.Progress:=7;
   TSPBS.Hint:='';
   _SetProgressBarStatus(PBHandle,@TSPBS);
   //конец
   //формирование руководителя организации
   sqls := 'select * from '+tbEmp+
           ' where emp_id='+IntToStr(boss_id);
   qr.SQL.Clear;
   qr.SQL.Add(sqls);
   qr.Open;
   if not qr.IsEmpty then
     Sh.Range[Sh.Cells[33,'BH'],Sh.Cells[33,'BH']].Value := qr.FieldByName('fname').AsString;
   TSPBS.Progress:=8;
   TSPBS.Hint:='';
   _SetProgressBarStatus(PBHandle,@TSPBS);
   //конец
   Sh.Range[Sh.Cells[23,'N'],Sh.Cells[23,'N']].Value := fmRBCashOrders.Mainqr.FieldByName('cb_text').AsString;
   TSPBS.Progress:=9;
   TSPBS.Hint:='';
   _SetProgressBarStatus(PBHandle,@TSPBS);
   Sh.Range[Sh.Cells[29,'O'],Sh.Cells[29,'O']].Value := fmRBCashOrders.Mainqr.FieldByName('ca_text').AsString;
   TSPBS.Progress:=10;
   TSPBS.Hint:='';
   _SetProgressBarStatus(PBHandle,@TSPBS);
   //формирование главного бухгалтера
   sqls := 'select * from '+tbEmp+
           ' where emp_id='+fmRBCashOrders.Mainqr.FieldByName('co_mainbookkeeper').AsString;;
   qr.SQL.Clear;
   qr.SQL.Add(sqls);
   qr.Open;
   if not qr.IsEmpty then begin
     Sh.Range[Sh.Cells[35,'AM'],Sh.Cells[35,'AM']].Value := qr.FieldByName('fname').AsString;
     TSPBS.Progress:=11;
     TSPBS.Hint:='';
     _SetProgressBarStatus(PBHandle,@TSPBS);
   end;
   //конец
   Sh.Range[Sh.Cells[47,'AN'],Sh.Cells[47,'AN']].Value := fmRBCashOrders.Mainqr.FieldByName('fname').AsString;;
   TSPBS.Progress:=12;
   TSPBS.Hint:='';
   _SetProgressBarStatus(PBHandle,@TSPBS);
   Sh.Range[Sh.Cells[41,'C'],Sh.Cells[41,'C']].Value := FormatDateTime('dd',StrToDate(fmRBCashOrders.Mainqr.FieldByName('co_date').AsString));
   TSPBS.Progress:=13;
   TSPBS.Hint:='';
   _SetProgressBarStatus(PBHandle,@TSPBS);
   Sh.Range[Sh.Cells[41,'J'],Sh.Cells[41,'J']].Value := FormatDateTime('mmmm',StrToDate(fmRBCashOrders.Mainqr.FieldByName('co_date').AsString));
   TSPBS.Progress:=14;
   TSPBS.Hint:='';
   _SetProgressBarStatus(PBHandle,@TSPBS);
   Sh.Range[Sh.Cells[41,'AL'],Sh.Cells[41,'AL']].Value := FormatDateTime('yyyy',StrToDate(fmRBCashOrders.Mainqr.FieldByName('co_date').AsString));
   TSPBS.Progress:=15;
   TSPBS.Hint:='';
   _SetProgressBarStatus(PBHandle,@TSPBS);
   Sh.Range[Sh.Cells[19,'AV'],Sh.Cells[19,'AV']].Value := fmRBCashOrders.Mainqr.FieldByName('co_kredit').AsString;;
   TSPBS.Progress:=16;
   TSPBS.Hint:='';
   _SetProgressBarStatus(PBHandle,@TSPBS);
   //формироваие документа выдачи
   sqls := 'select pdt.smallname as namedoc,epd.serial,epd.num,epd.datewhere,p.smallname from '+tbEmpPersonDoc+' epd,'+tbPlant+' p,'+tbPersonDocType+' pdt'+
           ' where epd.emp_id='+fmRBCashOrders.Mainqr.FieldByName('co_emp_id').AsString+' and '+
           'epd.persondoctype_id='+fmRBCashOrders.Mainqr.FieldByName('co_persondoctype_id').AsString+' and '+
           'epd.persondoctype_id=pdt.persondoctype_id and '+
           'epd.plant_id=p.plant_id ';
   qr.SQL.Clear;
   qr.SQL.Add(sqls);
   qr.Open;
   if not qr.IsEmpty then begin
     Sh.Range[Sh.Cells[43,'E'],Sh.Cells[43,'E']].Value := Trim(qr.FieldByName('namedoc').AsString)+' серия:'+
     Trim(qr.FieldByName('serial').AsString)+' номер:'+Trim(qr.FieldByName('num').AsString);
     Sh.Range[Sh.Cells[45,'A'],Sh.Cells[45,'A']].Value := 'Дата выдачи:'+Trim(qr.FieldByName('datewhere').AsString)+' Выдан:'+Trim(qr.FieldByName('smallname').AsString);
   end;
   TSPBS.Progress:=17;
   TSPBS.Hint:='';
   _SetProgressBarStatus(PBHandle,@TSPBS);
   //конец
   finally
    if not VarIsEmpty(Excel) then begin
     Excel.ActiveWindow.WindowState:=xlMaximized;
     Excel.Visible:=true;
     Excel.WindowState:=xlMaximized;
    end;
    DoTerminate;
   end;
  finally
   CoUninitialize;
   qr.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

end.
