unit URBMagazinePostings;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, Menus, tsvDbGrid, IBUpdateSQL,UFrameSubkonto;

type
  TfmRBMagazinePostings = class(TfmRBMainGrid)
    PHeader: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    PData: TPanel;
    LDok: TLabel;
    LNumDok: TLabel;
    LNumPost: TLabel;
    LDate: TLabel;
    LTime: TLabel;
    LKredit: TLabel;
    LOper: TLabel;
    LPost: TLabel;
    LCount: TLabel;
    LSum: TLabel;
    LCur: TLabel;
    lbDSub: TListBox;
    LDebit: TLabel;
    lbKSub: TListBox;
    lbCapDSub: TListBox;
    lbCapKSub: TListBox;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure MainQrAfterScroll(DataSet: TDataSet);
  private
    isFindDoc,isFindNum,isFindDate,isFindDebit,isFindCredit,
    isFindOper,isFindPost,isFindSumma,isFindKolvo: Bool;
    FindDoc,FindNumBeg,FindNumFin,FindDateBeg,FindDateFin,
    FindDebit,FindCredit,FindOper,FindPost,FindSumma,
    FindKolvo: string;
    FrameSub: TFrameSubkonto;
  protected
    procedure GridDblClick(Sender: TObject); override;
    procedure SaveToIni;override;
    procedure LoadFromIni; override;
    function GetFilterString: string;
    procedure GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort); override;
    function GetSql: string; override;
  public
    procedure ActiveQuery(CheckPerm: Boolean);override;
  end;

var
  fmRBMagazinePostings: TfmRBMagazinePostings;

implementation

uses UMainUnited, UKassaKDMCode, UKassaKDMDM, UKassaKDMData, UEditRBMagazinePostings;

{$R *.DFM}

procedure TfmRBMagazinePostings.FormCreate(Sender: TObject);
var
 cl: TColumn;
begin
 inherited;
 try
  Caption:=NameRbkMagazinePostings;
  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);
  pnSQL.Visible := false;
  FrameSub := TFrameSubkonto.Create(nil);

    cl:=Grid.Columns.Add;
    cl.FieldName:='DOK_NAME';
    cl.Title.Caption:='Документ';
    cl.Width:=150;

    cl:=Grid.Columns.Add;
    cl.FieldName:='MP_DOCUMENTID';
    cl.Title.Caption:='№ док';
    cl.Width:=40;

    cl:=Grid.Columns.Add;
    cl.FieldName:='MP_IDINDOCUMENT';
    cl.Title.Caption:='№ проводки';
    cl.Width:=40;

    cl:=Grid.Columns.Add;
    cl.FieldName:='MP_DATE';
    cl.Title.Caption:='Дата';
    cl.Width:=60;

    cl:=Grid.Columns.Add;
    cl.FieldName:='MP_TIME';
    cl.Title.Caption:='Время';
    cl.Width:=60;

    cl:=Grid.Columns.Add;
    cl.FieldName:='PA_GROUPID';
    cl.Title.Caption:='Дебит';
    cl.Width:=50;

    cl:=Grid.Columns.Add;
    cl.FieldName:='PA_GROUPID1';
    cl.Title.Caption:='Кредит';
    cl.Width:=50;

    cl:=Grid.Columns.Add;
    cl.FieldName:='MP_CONTENTSOPERA';
    cl.Title.Caption:='Операция';
    cl.Width:=200;

    cl:=Grid.Columns.Add;
    cl.FieldName:='MP_CONTENTSPOSTI';
    cl.Title.Caption:='Проводка';
    cl.Width:=70;

    cl:=Grid.Columns.Add;
    cl.FieldName:='MP_COUNT';
    cl.Title.Caption:='Кол-во';
    cl.Width:=50;

    cl:=Grid.Columns.Add;
    cl.FieldName:='MP_SUMMA';
    cl.Title.Caption:='Сумма';
    cl.Width:=100;

  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBMagazinePostings.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBMagazinePostings:=nil;
  FrameSub.DeInitData;
  FrameSub.Free;
end;

procedure TfmRBMagazinePostings.ActiveQuery(CheckPerm: Boolean);
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
   SetImageFilter(isFindDoc or isFindNum or isFindDate or isFindDebit or isFindCredit or
                  isFindOper or isFindPost or isFindSumma or isFindKolvo);
   ViewCount;
  finally
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBMagazinePostings.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBMagazinePostings.LoadFromIni;
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
   FindDebit := ReadParam(ClassName,'FindDebit',FindDebit);
   FindCredit := ReadParam(ClassName,'FindCredit',FindCredit);
   FindOper := ReadParam(ClassName,'FindOper',FindOper);
   FindPost := ReadParam(ClassName,'FindPost',FindPost);
   FindSumma := ReadParam(ClassName,'FindSumma',FindSumma);
   FindKolvo := ReadParam(ClassName,'FindKolvo',FindKolvo);
   FilterInside := ReadParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBMagazinePostings.SaveToIni;
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
   WriteParam(ClassName,'FindDebit',FindDebit);
   WriteParam(ClassName,'FindCredit',FindCredit);
   WriteParam(ClassName,'FindOper',FindOper);
   WriteParam(ClassName,'FindPost',FindPost);
   WriteParam(ClassName,'FindSumma',FindSumma);
   WriteParam(ClassName,'FindKolvo',FindKolvo);
   WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBMagazinePostings.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBMagazinePostings.bibDelClick(Sender: TObject);
{var
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
     sqls:='Delete from '+tbMagazinePostings+
           ' where ico_id='+ QuotedStr(Mainqr.FieldByName('ICO_ID').asString)+' AND '+
           'dok_id='+QuotedStr(Mainqr.FieldByName('DOK_ID').asString);
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
     {$IFDEF DEBUG}// on E: Exception do Assert(false,E.message); {$ENDIF}
//    end;
{   finally
    qr.Free;
    Screen.Cursor:=crDefault;
   end;

  end;}

begin
{  if  Mainqr.isEmpty then exit;
  but:=MessageBox(Application.Handle,
                  Pchar(CaptionDelete+' текущую запись ?'),
                  ConstWarning,MB_YESNO+MB_ICONWARNING);
  if but=ID_YES then begin
    if not deleteRecord then begin
      ShowError(Application.Handle,
               'Доступ к приложению <'+Mainqr.FieldByName('taname').AsString+
               '> у пользователя <'+Mainqr.FieldByName('tuname').AsString+'> используется.');
    end;
  end;}
end;

procedure TfmRBMagazinePostings.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBMagazinePostings;
  IdRec: Integer;
begin
 try
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  fm:=TfmEditRBMagazinePostings.Create(nil);
  try
    fm.bibOk.OnClick:=nil;
    fm.bibOk.Visible:=false;
    fm.bibCancel.Caption:=CaptionClose;
    fm.Caption:=CaptionView;
    fm.EDoc.Text := LDok.Caption;
    fm.ENum.Text := LNumDok.Caption;
    fm.ENumPosting.Text := LNumPost.Caption;
    fm.DTPDate.Date := StrToDate(LDate.Caption);
    fm.ETime.Text := LTime.Caption;
    fm.EDebit.Text := LDebit.Caption;
    fm.ECredit.Text := LKredit.Caption;
    fm.EOper.Text := LOper.Caption;
    fm.EPosting.Text := LPost.Caption;
    fm.ESumma.Text := LSum.Caption;
    fm.ECurrency.Text := LCur.Caption;
    fm.FrameSubDT.InitData(MainQr.FieldByName('MP_DEBETID').AsInteger,Trim(MainQr.FieldByName('MP_SUBKONTODT').AsString));
    fm.FrameSubKT.InitData(MainQr.FieldByName('MP_CREDITID').AsInteger,Trim(MainQr.FieldByName('MP_SUBKONTOKT').AsString));
  if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBMagazinePostings.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBMagazinePostings;
  LstAccount: TStrings;
  Account: string;
  filstr: string;
begin
try
 fm:=TfmEditRBMagazinePostings.Create(nil);
 LstAccount := TStringList.Create;
 try
  fm.Caption:=CaptionFilter;
  fm.bibOK.OnClick:=fm.filterClick;
  fm.PFilter.Visible := true;
  fm.PView.Visible := false;
  fm.LCurrency.Visible := false;
  fm.ECurrency.Visible := false;
  fm.EDoc.Text := FindDoc;
  fm.ENumBeg.Text := FindNumBeg;
  fm.ENumFin.Text := FindNumFin;
  fm.CBNumFilter.Checked := isFindNum;
  fm.DTPBeg.Date := StrToDate(FindDateBeg);
  fm.DTPFin.Date := StrToDate(FindDateFin);
  fm.CBDateFilter.Checked := isFindDate;
  fm.MEDebitFilter.Text := FindDebit;
  fm.MECreditFilter.Text := FindCredit;
  fm.EOper.Text := FindOper;
  fm.EPosting.Text := FindPost;
  fm.ESumma.Text := FindSumma;
  fm.EKolvo.Text := FindKolvo;
  fm.Height := 450;

  fm.cbInStringCopy.Visible:=true;
  fm.bibClear.Visible:=true;
  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin
    LstAccount:=divide(Trim(fm.MEDebitFilter.Text));
    if (LstAccount.Strings[0]<>'') then begin
      Account := LstAccount.Strings[0];
      if (LstAccount.Strings[1]<>'') then begin
        Account := Account+'.'+LstAccount.Strings[1];
        if (LstAccount.Strings[2]<>'') then begin
          Account := Account+'.'+LstAccount.Strings[2];
        end;
      end;
    end;
    FindDebit := Account;
    LstAccount.Clear;
    Account := '';
    LstAccount:=divide(Trim(fm.MECreditFilter.Text));
    if (LstAccount.Strings[0]<>'') then begin
      Account := LstAccount.Strings[0];
      if (LstAccount.Strings[1]<>'') then begin
        Account := Account+'.'+LstAccount.Strings[1];
        if (LstAccount.Strings[2]<>'') then begin
          Account := Account+'.'+LstAccount.Strings[2];
        end;
      end;
    end;
    FindCredit := Account;

    FindDoc := Trim(fm.EDoc.Text);
    isFindNum := fm.CBNumFilter.Checked;
    FindNumBeg := Trim(fm.ENumBeg.Text);
    FindNumFin := Trim(fm.ENumFin.Text);
    isFindDate := fm.CBDateFilter.Checked;
    FindDateBeg := DateToStr(fm.DTPBeg.Date);
    FindDateFin := DateToStr(fm.DTPFin.Date);
    FindOper := Trim(fm.EOper.Text);
    FindPost := Trim(fm.EPosting.Text);
    FindSumma := Trim(fm.ESumma.Text);
    FindKolvo := Trim(fm.EKolvo.Text);

    FilterInSide:=fm.cbInStringCopy.Checked;
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

function TfmRBMagazinePostings.GetFilterString: string;
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
    isFindDebit:=Trim(FindDebit)<>'';
    isFindCredit:=Trim(FindCredit)<>'';
    isFindOper:=Trim(FindOper)<>'';
    isFindPost:=Trim(FindPost)<>'';
    isFindSumma:=Trim(FindSumma)<>'';
    isFindKolvo:=Trim(FindKolvo)<>'';

    wherestr:=' AND ';

    if FilterInside then FilInSide:='%';

     if isFindDoc then begin
        addstr1:=wherestr+' Upper(DOK_NAME) like '+AnsiUpperCase(QuotedStr(FilInSide+FindDoc+'%'))+' ';
     end;
     if isFindDebit then begin
        addstr2:=wherestr+' Upper(P1.PA_GROUPID) like '+AnsiUpperCase(QuotedStr(FilInSide+FindDebit+'%'))+' ';
     end;
     if isFindCredit then begin
        addstr3:=wherestr+' Upper(P2.PA_GROUPID) like '+AnsiUpperCase(QuotedStr(FilInSide+FindCredit+'%'))+' ';
     end;
     if isFindOper then begin
        addstr4:=wherestr+' Upper(MP_CONTENTSOPERA) like '+AnsiUpperCase(QuotedStr(FilInSide+FindOper+'%'))+' ';
     end;
     if isFindPost then begin
        addstr5:=wherestr+' Upper(MP_CONTENTSPOSTI) like '+AnsiUpperCase(QuotedStr(FilInSide+FindPost+'%'))+' ';
     end;
     if isFindKolvo then begin
        addstr7:=wherestr+' MP_COUNT>='+FindKolvo+') ';
     end;
     if isFindSumma then begin
        addstr8:=wherestr+' MP_SUMMA>='+FindSumma+') ';
     end;
     if isFindNum then begin
        if FindNumBeg='' then FindNumBeg := '0';
        if FindNumFin='' then addstr9:=wherestr+' MP_DOCUMENTID>='+(FindNumBeg)+' '
        else
          addstr9:=wherestr+' (MP_DOCUMENTID>='+(FindNumBeg)+' and MP_DOCUMENTID<='+(FindNumFin)+') ';
     end;
     if isFindDate then begin
       addstr10:=wherestr+' (MP_DATE>='+QuotedStr(FindDateBeg)+' and MP_DATE<='+QuotedStr(FindDateFin)+') ';
     end;
     Result:=addstr1+addstr2+addstr3+addstr4+addstr5+addstr7+addstr8+addstr9+addstr10;
end;

procedure TfmRBMagazinePostings.FormResize(Sender: TObject);
begin
  inherited;
//  edSearch.Width := pnBackGrid.Width-89;
  edSearch.Width:=pnBackGrid.Width-89-edSearch.Left;
  pnGrid.Height := pnBackGrid.Height-120;
  pnGrid.Width := pnBackGrid.Width-89;
  PHeader.Top := pnBackGrid.Height-120;
  PData.Top := pnBackGrid.Height-60;
  PHeader.Width := pnGrid.Width;
  PData.Width := pnGrid.Width;
end;

procedure TfmRBMagazinePostings.MainQrAfterScroll(DataSet: TDataSet);
var
  qr: TIBQuery;
  sqls: string;
  Sub: TStrings;
begin
inherited;
try
  qr := TIBQuery.Create(nil);
  qr.Database:=IBDB;
  qr.Transaction:=IBTran;
  qr.Transaction.Active:=true;
  Sub := TStringList.Create;
  LDok.Caption := '';
  LNumDok.Caption := '';
  LNumPost.Caption := '';
  LDate.Caption := '';
  LTime.Caption := '';
  LDebit.Caption := '';
  LKredit.Caption := '';
  LOper.Caption := '';
  LPost.Caption := '';
  LCount.Caption := '';
  LSum.Caption := '';
  LCur.Caption := '';
  try
    if Trim(MainQr.FieldByName('MP_CURRENCY_ID').AsString)<>'' then begin
      sqls := 'Select * from CURRENCY where CURRENCY_ID='+Trim(MainQr.FieldByName('MP_CURRENCY_ID').AsString);
      qr.SQL.Add(sqls);
      qr.Open;
      if not qr.IsEmpty then
        LCur.Caption := Trim(qr.FieldByName('SHORTNAME').AsString);
    end;
    LDok.Caption := Trim(MainQr.FieldByName('DOK_NAME').AsString);
    LNumDok.Caption := Trim(MainQr.FieldByName('MP_DOCUMENTID').AsString);
    LNumPost.Caption := Trim(MainQr.FieldByName('MP_IDINDOCUMENT').AsString);
    LDate.Caption := Trim(MainQr.FieldByName('MP_DATE').AsString);
    LTime.Caption := Trim(MainQr.FieldByName('MP_TIME').AsString);
    LDebit.Caption := Trim(MainQr.FieldByName('PA_GROUPID').AsString);
    LKredit.Caption := Trim(MainQr.FieldByName('PA_GROUPID1').AsString);
    LOper.Caption := Trim(MainQr.FieldByName('MP_CONTENTSOPERA').AsString);
    LPost.Caption := Trim(MainQr.FieldByName('MP_CONTENTSPOSTI').AsString);
    LSum.Caption := Trim(MainQr.FieldByName('MP_SUMMA').AsString);

    FrameSub.InitData(MainQr.FieldByName('MP_DEBETID').AsInteger,Trim(MainQr.FieldByName('MP_SUBKONTODT').AsString));
    lbDSub.Items.Clear;
    lbDSub.Items := FrameSub.DataSubkonto;
    lbCapDSub.Items.Clear;
    lbCapDSub.Items := FrameSub.NameSubkonto;

    FrameSub.ClearAll;
    FrameSub.InitData(MainQr.FieldByName('MP_CREDITID').AsInteger,Trim(MainQr.FieldByName('MP_SUBKONTOKT').AsString));
    lbKSub.Items.Clear;
    lbKSub.Items := FrameSub.DataSubkonto;
    lbCapKSub.Items.Clear;
    lbCapKSub.Items := FrameSub.NameSubkonto;

    LDok.Hint := LDok.Caption;
    LNumDok.Hint := LNumDok.Caption;
    LNumPost.Hint := LNumPost.Caption;
    LDate.Hint := LDate.Caption;
    LTime.Hint := LTime.Caption;
    LDebit.Hint := LDebit.Caption;
    LKredit.Hint := LKredit.Caption;
    LOper.Hint := LOper.Caption;
    LPost.Hint := LPost.Caption;
    LCount.Hint := LCount.Caption;
    LSum.Hint := LSum.Caption;
    LCur.Hint := LCur.Caption;
  finally
    qr.free;
    Sub.Free;
  end;
except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
end;
end;

function TfmRBMagazinePostings.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkMagazinePostings+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBMagazinePostings.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   if UpperCase(fn)=UpperCase('pa_groupid') then
     fn:='p1.pa_groupid';
   if UpperCase(fn)=UpperCase('pa_groupid1') then
     fn:='p2.pa_groupid';
   id:=MainQr.fieldByName('mp_id').asString;
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('mp_id',id,[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

end.
