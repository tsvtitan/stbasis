unit URBPlanAccounts;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, Menus, IBUpdateSQL, tsvDbGrid;

type
  TfmRBPlanAccounts = class(TfmRBMainGrid)
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
  private
    isFindNum,isFindNam,isFindNamAc,isFindCur,isFindAmo,
    isFindBal,isFindSalAct,isFindSalPas,isFindSalActPas,isAddCondition: Bool;
    FindNum,FindNam,FindNamAc,FindCur,FindAmo,
    FindBal,FindSalAct,FindSalPas,FindSalActPas: string;
  protected
    procedure GridDblClick(Sender: TObject); override;
    procedure SaveToIni;override;
    procedure LoadFromIni; override;
    function GetFilterString: string; override;
    procedure GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort); override;
    function GetSql: string; override;
  public
    procedure ActiveQuery(CheckPerm: Boolean);override;
  end;

var
  fmRBPlanAccounts: TfmRBPlanAccounts;

implementation

uses UMainUnited, UBookKeepingCode, UBookKeepingDM, UBookKeepingData, UEditRBPlanAccounts,
  UFrameSubkonto;

{$R *.DFM}

procedure TfmRBPlanAccounts.FormCreate(Sender: TObject);
var
 cl: TColumn;
begin
 inherited;
 try
  Caption:=NameRbkPlanAccounts;
  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

    cl:=Grid.Columns.Add;
    cl.FieldName:='PA_GROUPID';
    cl.Title.Caption:='№ счета';
    cl.Width:=100;

    cl:=Grid.Columns.Add;
    cl.FieldName:='PA_SHORTNAME';
    cl.Title.Caption:='Наименование';
    cl.Width:=100;

    cl:=Grid.Columns.Add;
    cl.FieldName:='PA_CURRENCY';
    cl.Title.Caption:='Валюта';
    cl.Width:=50;

    cl:=Grid.Columns.Add;
    cl.FieldName:='PA_AMOUNT';
    cl.Title.Caption:='Количественный';
    cl.Width:=50;

    cl:=Grid.Columns.Add;
    cl.FieldName:='PA_BALANCE';
    cl.Title.Caption:='Баланс';
    cl.Width:=50;

    cl:=Grid.Columns.Add;
    cl.FieldName:='KS_SHORTNAME';
    cl.Title.Caption:='Сальдо';
    cl.Width:=50;

    cl:=Grid.Columns.Add;
    cl.FieldName:='PA_NAMEACCOUNT';
    cl.Title.Caption:='Наименование счета';
    cl.Width:=100;

  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBPlanAccounts.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBPlanAccounts:=nil;
end;

procedure TfmRBPlanAccounts.ActiveQuery(CheckPerm: Boolean);
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
   sqls :=  GetSQL;
   Mainqr.sql.Add(sqls);
   Mainqr.Transaction.Active:=false;
   Mainqr.Transaction.Active:=true;
   Mainqr.Active:=true;
   SetImageFilter(isFindNum or isFindNam or isFindNamAc or isFindCur or isFindAmo or
                  isFindBal  or isFindSalAct or isFindSalPas  or isFindSalActPas);
   ViewCount;
  finally
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBPlanAccounts.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBPlanAccounts.LoadFromIni;
begin
 inherited;
 try
   FindNum := ReadParam(ClassName,'FindNum',FindNum);
   FindNam := ReadParam(ClassName,'FindNam',FindNam);
   FindNamAc := ReadParam(ClassName,'FindNamAc',FindNamAc);
   FindCur := ReadParam(ClassName,'FindCur',FindCur);
   FindAmo := ReadParam(ClassName,'FindAmo',FindAmo);
   FindBal := ReadParam(ClassName,'FindBal',FindBal);
   FindSalAct := ReadParam(ClassName,'FindSalAct',FindSalAct);
   FindSalPas := ReadParam(ClassName,'FindSalPas',FindSalPas);
   FindSalActPas :=ReadParam(ClassName,'FindSalActPas',FindSalActPas);
   FilterInside := ReadParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBPlanAccounts.SaveToIni;
begin
 Inherited;
 try
   WriteParam(ClassName,'FindNum',FindNum);
   WriteParam(ClassName,'FindNam',FindNam);
   WriteParam(ClassName,'FindNamAc',FindNamAc);
   WriteParam(ClassName,'FindCur',FindCur);
   WriteParam(ClassName,'FindAmo',FindAmo);
   WriteParam(ClassName,'FindBal',FindBal);
   WriteParam(ClassName,'FindSalAct',FindSalAct);
   WriteParam(ClassName,'FindSalPas',FindSalPas);
   WriteParam(ClassName,'FindSalActPas',FindSalActPas);
   WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBPlanAccounts.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBPlanAccounts.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBPlanAccounts;
begin
 try
  if not Mainqr.Active then exit;
  fm:=TfmEditRBPlanAccounts.Create(nil);
  try
    fm.bibOk.OnClick:=fm.AddClick;
    fm.Caption:=CaptionAdd;
    fm.FrameSub.InitData(-1,0,'','','','',true);
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('pa_shortname',Trim(fm.ENam.Text),[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBPlanAccounts.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBPlanAccounts;
  qr: TIBQuery;
  sqls: string;
  Index,IdRec:Integer;
begin
 try
  if Mainqr.isEmpty then exit;
  fm:=TfmEditRBPlanAccounts.Create(nil);
  try
    fm.bibOk.OnClick:=fm.ChangeClick;
    fm.Caption:=CaptionChange;
    IdRec := MainQr.FieldByName('PA_Id').AsInteger;
    fm.IdRec :=IdRec;
    qr := TIBQuery.Create(nil);
    qr.Database := IBDB;
    qr.Transaction := IBTran;
    qr.Transaction.Active:=true;

    fm.MENum.Text := Trim(MainQr.FieldByName('PA_GROUPID').AsString);
    fm.ENam.Text := Trim(MainQr.FieldByName('PA_SHORTNAME').AsString);
    fm.ENamAc.Text := Trim(MainQr.FieldByName('PA_NAMEACCOUNT').AsString);
    if Trim(MainQr.FieldByName('PA_CURRENCY').AsString)='*'then
      fm.CBCur.Checked := True;
    if Trim(MainQr.FieldByName('PA_AMOUNT').AsString)='*'then
      fm.CBAmount.Checked := True;
    if Trim(MainQr.FieldByName('PA_BALANCE').AsString)='*'then
      fm.CBBal.Checked := True;
    if Trim(MainQr.FieldByName('KS_SHORTNAME').AsString)='А' then
      fm.RBAct.Checked := true;
    if Trim(MainQr.FieldByName('KS_SHORTNAME').AsString)='П' then
      fm.RBPas.Checked := true;
    if Trim(MainQr.FieldByName('KS_SHORTNAME').AsString)='АП' then
      fm.RBActPas.Checked := true;

    IdRec := MainQr.FieldByName('PA_ID').AsInteger;
    fm.FrameSub.InitData(IdRec,0,'','','','',true);
    sqls := 'Select * from '+tbPlanAccounts+' where PA_PARENTID='+Trim(MainQr.FieldByName('PA_ID').AsString)+
            ' and PA_ID<>'+IntToStr(IdRec);
    qr.SQL.Clear;
    qr.SQL.Add(sqls);
    qr.Open;
    if not qr.IsEmpty then begin
      fm.MENum.Enabled := false;
      fm.RBAct.Enabled := false;
      fm.RBPas.Enabled := false;
      fm.RBActPas.Enabled := false;
    end;
    fm.ChangeFlag := false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('pa_id',IdREc,[loCaseInsensitive]);
    end;
  finally
    qr.Free;
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBPlanAccounts.bibDelClick(Sender: TObject);
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
     sqls := 'Delete from '+tbPlanAccounts_KindSubkonto+
             ' where PAKS_PA_ID='+QuotedStr(Mainqr.FieldByName('PA_ID').asString);
     qr.SQL.Clear;
     qr.sql.Add(sqls);
     qr.ExecSQL;
     sqls:='Delete from '+tbPlanAccounts+
           ' where pa_id='+ QuotedStr(Mainqr.FieldByName('PA_ID').asString);
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

procedure TfmRBPlanAccounts.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBPlanAccounts;
  index: Integer;
begin
 try
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  fm:=TfmEditRBPlanAccounts.Create(nil);
  try
    fm.bibOk.OnClick:=nil;
    fm.bibOk.Visible:=false;
    fm.bibCancel.Caption:=CaptionClose;
    fm.Caption:=CaptionView;
    fm.MENum.Text := Trim(MainQr.FieldByName('PA_GROUPID').AsString);
    fm.ENam.Text := Trim(MainQr.FieldByName('PA_SHORTNAME').AsString);
    fm.ENamAc.Text := Trim(MainQr.FieldByName('PA_NAMEACCOUNT').AsString);
    if Trim(MainQr.FieldByName('PA_CURRENCY').AsString)='*'then
      fm.CBCur.Checked := True;
    if Trim(MainQr.FieldByName('PA_AMOUNT').AsString)='*'then
      fm.CBAmount.Checked := True;
    if Trim(MainQr.FieldByName('PA_BALANCE').AsString)='*'then
      fm.CBBal.Checked := True;
    if Trim(MainQr.FieldByName('KS_SHORTNAME').AsString)='А' then
       fm.RBAct.Checked := true;
    if Trim(MainQr.FieldByName('KS_SHORTNAME').AsString)='П' then
       fm.RBPas.Checked := true;
    if Trim(MainQr.FieldByName('KS_SHORTNAME').AsString)='АП' then
       fm.RBActPas.Checked := true;

    fm.FrameSub.InitData(MainQr.FieldByName('pa_id').AsInteger,0,'','','','',true);

    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBPlanAccounts.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBPlanAccounts;
  filstr: string;
  LstAccount: TStrings;
  Account: string;
begin
try
 fm:=TfmEditRBPlanAccounts.Create(nil);
 LstAccount:=TStringList.Create;
 try
  fm.Caption:=CaptionFilter;
  fm.bibOK.OnClick:=fm.filterClick;
  fm.PSaldo.Visible := false;
  fm.PFindSaldo.Visible := true;
  fm.FrameSub.Visible := false;
  fm.Panel3.Visible := false;
//  fm.Edit.Color:=clWindow;
//  fm.Edit.ReadOnly:=false;
    if Trim(FindNum)<>'' then fm.MENum.Text := FindNum;
    if Trim(FindNam)<>'' then fm.ENam.Text := FindNam;
    if Trim(FindNamAc)<>'' then fm.ENamAc.Text := FindNamAc;
    if Trim(FindCur)<>'' then fm.CBCur.Checked := True;
    if Trim(FindAmo)<>'' then fm.CBAmount.Checked := True;
    if Trim(FindBal)<>'' then fm.CBBal.Checked := True;
    if Trim(FindSalAct)='А' then fm.CBAct.Checked := true;
    if Trim(FindSalPas)='П' then fm.CBPas.Checked := true;
    if Trim(FindSalActPas)='АП' then fm.CBActPas.Checked := true;

  fm.cbInString.Visible:=true;
  fm.bibClear.Visible:=true;
  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

//    FindCA_Text:=Trim(fm.Edit.Text);
    LstAccount:=divide(Trim(fm.MENum.Text));
    if (LstAccount.Strings[0]<>'') then begin
      Account := LstAccount.Strings[0];
      if (LstAccount.Strings[1]<>'') then begin
        Account := Account+'.'+LstAccount.Strings[1];
        if (LstAccount.Strings[2]<>'') then begin
          Account := Account+'.'+LstAccount.Strings[2];
        end;
      end;
    end;
    FindNum := Account;
    FindNam := Trim(fm.ENam.Text);
    FindNamAc := Trim(fm.ENamAc.Text);
    if fm.CBCur.Checked then FindCur := '*' else FindCur := '';
    if fm.CBAmount.Checked then FindAmo := '*' else FindAmo := '';
    if fm.CBBal.Checked then FindBal := '*' else FindBal := '';
    FindSalAct := '';
    FindSalPas := '';
    FindSalActPas := '';
    if fm.CBAct.Checked then FindSalAct := 'А';
    if fm.CBPas.Checked then FindSalPas := 'П';
    if fm.CBActPas.Checked then FindSalActPas := 'АП';

    FilterInSide:=fm.cbInString.Checked;
    if FilterInSide then filstr:='%';

    ActiveQuery(false);
    ViewCount;
  end;
 finally
  fm.Free;
 end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

function TfmRBPlanAccounts.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2,addstr3,addstr4,addstr5,addstr6,addstr7,
  addstr8,addstr9,addstr10,addstr11,addstr12,addstr13: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then begin
      Result := KillWhereFromWhereStr(Result);
      exit;
    end;

    isFindNum:=Trim(FindNum)<>'';
    isFindNam:=Trim(FindNam)<>'';
    isFindNamAc:=Trim(FindNamAc)<>'';
    isFindCur:=Trim(FindCur)<>'';
    isFindAmo:=Trim(FindAmo)<>'';
    isFindBal:=Trim(FindBal)<>'';
    isFindSalAct:=Trim(FindSalAct)<>'';
    isFindSalPas:=Trim(FindSalPas)<>'';
    isFindSalActPas:=Trim(FindSalActPas)<>'';

    if (isFindNum or isFindNam or isFindNamAc or isFindCur or isFindAmo or
       isFindBal  or isFindSalAct or isFindSalPas or isFindSalActPas) then begin
     wherestr:=' AND ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindNum then begin
        addstr1:=wherestr+' Upper(pa_groupid) like '+AnsiUpperCase(QuotedStr(FilInSide+FindNum+'%'))+' ';
     end;
     if isFindNam then begin
        addstr2:=wherestr+' Upper(pa_shortname) like '+AnsiUpperCase(QuotedStr(FilInSide+FindNam+'%'))+' ';
     end;
     if isFindNamAc then begin
        addstr3:=wherestr+' Upper(pa_nameaccount) like '+AnsiUpperCase(QuotedStr(FilInSide+FindNamAc+'%'))+' ';
     end;
     if isFindCur then begin
        addstr4:=wherestr+' Upper(pa_currency) like '+AnsiUpperCase(QuotedStr(FilInSide+FindCur+'%'))+' ';
     end;
     if isFindAmo then begin
        addstr5:=wherestr+' Upper(pa_amount) like '+AnsiUpperCase(QuotedStr(FilInSide+FindAmo+'%'))+' ';
     end;
     if isFindBal then begin
        addstr6:=wherestr+' Upper(pa_balance) like '+AnsiUpperCase(QuotedStr(FilInSide+FindBal+'%'))+' ';
     end;
     if isFindSalAct then begin
        addstr7:=' and ('+' Upper(ks_shortname) like '+AnsiUpperCase(QuotedStr(FindSalAct))+' ';
        if (not isFindSalPas) and (not isFindSalActPas) then
        addstr7 := addstr7+')';
     end;
     if isFindSalPas then begin
        if not isFindSalAct then
          addstr11:=' and ( '+' Upper(ks_shortname) like '+AnsiUpperCase(QuotedStr(FindSalPas))+' '
        else
          addstr11:=' or '+' Upper(ks_shortname) like '+AnsiUpperCase(QuotedStr(FindSalPas))+' ';
        if (not isFindSalActPas) then
        addstr11 := addstr11+')';
     end;
     if isFindSalActPas then begin
         if (not isFindsalPas) and (not isFindSalAct) then
            addstr12:=' and ( '+' Upper(ks_shortname) like '+AnsiUpperCase(QuotedStr(FindSalActPas))+' )'
         else
            addstr12:=' or '+' Upper(ks_shortname) like '+AnsiUpperCase(QuotedStr(FindSalActPas))+' )';
     end;

     Result:=addstr1+addstr2+addstr3+addstr4+addstr5+addstr6+addstr7+addstr11+addstr12+addstr13;
end;

function TfmRBPlanAccounts.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkPlanAccounts+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBPlanAccounts.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   id:=MainQr.fieldByName('pa_id').asString;
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('pa_id',id,[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

end.
