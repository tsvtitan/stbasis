unit URBCorrectPost;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, inifiles, IBDatabase, IB, Menus;

type
  TfmRBCorrectPost = class(TfmRBMainGrid)
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
//    procedure Button1Click(Sender: TObject);
  private
    isFindDebit,isFindKredit,isFindContents: Boolean;
    FindDebit,FindKredit,FindContents: String;
  protected
    procedure GridTitleClick(Column: TColumn); override;
    procedure GridDblClick(Sender: TObject); override;
    function CheckPermission: Boolean; override;
    procedure SaveToIni;override;
    procedure LoadFromIni; override;
    function GetFilterString: string;
  public
    procedure ActiveQuery(CheckPerm: Boolean);override;
  end;

var
  fmRBCorrectPost: TfmRBCorrectPost;

implementation

uses UMainUnited, UKassaKDMCode, UKassaKDMDM, UKassaKDMData, UEditRBCorrectPost;

{$R *.DFM}

procedure TfmRBCorrectPost.FormCreate(Sender: TObject);
var
 cl: TColumn;
begin
 inherited;
 try
  Caption:=NameCorrectPost;
  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  cl:=Grid.Columns.Add;
  cl.FieldName:='pa_groupid';
  cl.Title.Caption:='Дебет';
  cl.Width:=30;

  cl:=Grid.Columns.Add;
  cl.FieldName:='pa_groupid1';
  cl.Title.Caption:='Кредит';
  cl.Width:=30;

  cl:=Grid.Columns.Add;
  cl.FieldName:='cp_contents';
  cl.Title.Caption:='Описание';
  cl.Width:=150;

  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBCorrectPost.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBCorrectPost:=nil;
end;

function TfmRBCorrectPost.CheckPermission: Boolean;
begin
  isPerm:=_isPermission(tbCorrectPost,SelConst) and
          _isPermission(tbPlanAccounts,SelConst);
  bibOk.Enabled:=isPerm;
  if not ViewSelect then begin
   bibAdd.Enabled:=isPerm and _isPermission(tbCorrectPost,InsConst);
   bibChange.Enabled:=isPerm and _isPermission(tbCorrectPost,UpdConst);
   bibDel.Enabled:=isPerm and _isPermission(tbCorrectPost,DelConst);
   bibView.Enabled:=isPerm;
   bibFilter.Enabled:=isPerm;
   bibAdjust.Enabled:=isPerm;
  end else begin
   pnSQL.Visible:=false;
  end;
  Result:=isPerm;
end;

procedure TfmRBCorrectPost.ActiveQuery(CheckPerm: Boolean);
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
   sqls:='Select cp_debit,cp_kredit,p1.pa_groupid,p2.pa_groupid,cp_contents from '+tbCorrectPost+','+tbPlanAccounts+' P1,'+tbPlanAccounts+' P2 '+
         'where cp_debit=p1.pa_id and cp_kredit=p2.pa_id '+
         GetFilterString+LastOrderStr;
   Mainqr.sql.Add(sqls);
   Mainqr.Transaction.Active:=false;
   Mainqr.Transaction.Active:=true;
   Mainqr.Active:=true;
   SetImageFilter(isFindDebit or isFindKredit or isFindContents);
   ViewCount;
  finally
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBCorrectPost.GridTitleClick(Column: TColumn);
var
  fn: string;
  id1,id2: string;
  sqls: string;
begin
 try
  if not MainQr.Active then exit;
  if MainQr.RecordCount=0 then exit;
  Screen.Cursor:=crHourGlass;
  try
   fn:=Column.FieldName;
   if UpperCase(fn)=UpperCase('pa_groupid') then fn:='p1.pa_groupid';
   if UpperCase(fn)=UpperCase('pa_groupid1') then fn:='p2.pa_groupid';
   id1:=MainQr.fieldByName('cp_debit').asString;
   id2:=MainQr.fieldByName('cp_kredit').asString;
   MainQr.Active:=false;
   MainQr.SQL.Clear;
   LastOrderStr:=' Order by '+fn;
   sqls:='Select cp_debit,cp_kredit,p1.pa_groupid,p2.pa_groupid,cp_contents from '+tbCorrectPost+','+tbPlanAccounts+' P1,'+tbPlanAccounts+' P2 '+
         'where cp_debit=p1.pa_id and cp_kredit=p2.pa_id '+
         GetFilterString+LastOrderStr;
   MainQr.SQL.Add(sqls);
   MainQr.Transaction.Active:=false;
   MainQr.Transaction.Active:=true;
   MainQr.Active:=true;
   MainQr.First;
   MainQr.Locate('cp_debit;cp_kredit',VarArrayOf([id1,id2]),[LocaseInsensitive]);
  finally
    Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBCorrectPost.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBCorrectPost.LoadFromIni;
var
  fi: TIniFile;
begin
 inherited;
 try
  fi:=TIniFile.Create(GetIniFileName);
  try
    FindDebit:=fi.ReadString(ClassName,'cp_debit',FindDebit);
    FindKredit:=fi.ReadString(ClassName,'cp_kredit',FindKredit);
    FindContents:=fi.ReadString(ClassName,'cp_Contents',FindContents);
    FilterInside:=fi.ReadBool(ClassName,'Inside',FilterInside);
  finally
   fi.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBCorrectPost.SaveToIni;
var
  fi: TIniFile;
begin
 Inherited;
 try
  fi:=TIniFile.Create(GetIniFileName);
  try
    fi.WriteString(ClassName,'cp_debit',FindDebit);
    fi.WriteString(ClassName,'cp_kredit',FindKredit);
    fi.WriteString(ClassName,'cp_contents',FindContents);
    fi.WriteBool(ClassName,'Inside',FilterInside);
  finally
   fi.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBCorrectPost.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBCorrectPost.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBCorrectPost;
begin
 try
  if not Mainqr.Active then exit;
  fm:=TfmEditRBCorrectPost.Create(nil);
  try
    fm.bibOk.OnClick:=fm.AddClick;
    fm.Caption:=CaptionAdd;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('cp_debit;cp_kredit',VarArrayOf([fm.cp_debit,fm.cp_kredit]),[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBCorrectPost.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBCorrectPost;
  qr: TIBQuery;
  sqls: string;
begin
 try
  if Mainqr.isEmpty then exit;
  fm:=TfmEditRBCorrectPost.Create(nil);
  qr := TIBQuery.Create(nil);
  qr.Database := IBDB;
  qr.Transaction := IBTran;
  try
    fm.bibOk.OnClick:=fm.ChangeClick;
    fm.Caption:=CaptionChange;
    fm.oldcp_debit:=Mainqr.fieldByName('cp_debit').AsInteger;
    fm.oldcp_kredit:=Mainqr.fieldByName('cp_kredit').AsInteger;
    fm.EContents.Text:=Mainqr.fieldByName('cp_contents').AsString;
    sqls := 'select * from '+tbPlanAccounts+' where pa_id='+IntToStr(fm.oldcp_debit);
    qr.SQL.Clear;
    qr.SQL.Add(sqls);
    qr.Open;
    if not qr.IsEmpty then
      fm.MEDebit.Text := Trim(qr.FieldByName('pa_groupid').AsString);
    sqls := 'select * from '+tbPlanAccounts+' where pa_id='+IntToStr(fm.oldcp_kredit);
    qr.SQL.Clear;
    qr.SQL.Add(sqls);
    qr.Open;
    if not qr.IsEmpty then
      fm.MEKredit.Text := Trim(qr.FieldByName('pa_groupid').AsString);
    fm.ChangeFlag := false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('cp_debit;cp_kredit',VarArrayOf([fm.cp_debit,fm.cp_kredit]),[loCaseInsensitive]);
    end;
  finally
    fm.Free;
    qr.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBCorrectPost.bibDelClick(Sender: TObject);
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
     sqls:='Delete from '+tbCorrectPost+
           ' where cp_debit='+ QuotedStr(Mainqr.FieldByName('cp_debit').asString)+
           ' and cp_kredit='+QuotedStr(Mainqr.FieldByName('cp_kredit').asString);
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

procedure TfmRBCorrectPost.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBCorrectPost;
  qr: TIBQuery;
  sqls: string;
begin
 try
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  fm:=TfmEditRBCorrectPost.Create(nil);
  qr := TIBQuery.Create(nil);
  qr.Database := IBDB;
  qr.Transaction := IBTran;
  try
    fm.bibOk.OnClick:=nil;
    fm.bibOk.Visible:=false;
    fm.bibCancel.Caption:=CaptionClose;
    fm.Caption:=CaptionView;
    fm.cp_debit:=Mainqr.fieldByName('cp_debit').AsInteger;
    fm.cp_kredit:=Mainqr.fieldByName('cp_kredit').AsInteger;
    fm.EContents.Text:=Mainqr.fieldByName('cp_contents').AsString;
    sqls := 'select * from '+tbPlanAccounts+' where pa_id='+IntToStr(fm.cp_debit);
    qr.SQL.Clear;
    qr.SQL.Add(sqls);
    qr.Open;
    if not qr.IsEmpty then
      fm.MEDebit.Text := Trim(qr.FieldByName('pa_groupid').AsString);
    sqls := 'select * from '+tbPlanAccounts+' where pa_id='+IntToStr(fm.cp_kredit);
    qr.SQL.Clear;
    qr.SQL.Add(sqls);
    qr.Open;
    if not qr.IsEmpty then
      fm.MEKredit.Text := Trim(qr.FieldByName('pa_groupid').AsString);
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
    qr.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBCorrectPost.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBCorrectPost;
  filstr: string;
begin
try
 fm:=TfmEditRBCorrectPost.Create(nil);
 try
  fm.Caption:=CaptionFilter;
  fm.bibOK.OnClick:=fm.filterClick;

  if Trim(FindDebit)<>'' then fm.MEDebit.Text:=FindDebit;
  if Trim(FindKredit)<>'' then fm.MEKredit.Text:=FindKredit;
  if Trim(FindContents)<>'' then fm.EContents.Text:=FindContents;

  fm.cbInString.Visible:=true;
  fm.bibClear.Visible:=true;
  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin
    fm.ConvertAccounts;
    FindDebit:=fm.DebitAccount;
    FindKredit:=fm.KreditAccount;
    FindContents := Trim(fm.EContents.Text);

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

function TfmRBCorrectPost.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2,addstr3,and1,and2: string;
begin
    Result:='';

    isFindDebit:=Trim(FindDebit)<>'';
    isFindKredit:=Trim(FindKredit)<>'';
    isFindContents:=Trim(FindContents)<>'';

    if isFindDebit or isFindKredit or isFindContents then begin
     wherestr:=' and ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindDebit then begin
        addstr1:=' Upper(p1.pa_groupid) like '+AnsiUpperCase(QuotedStr(FilInSide+FindDebit+'%'))+' ';
     end;
     if isFindKredit then begin
        addstr2:=' Upper(p2.pa_groupid) like '+AnsiUpperCase(QuotedStr(FilInSide+FindKredit+'%'))+' ';
     end;
     if isFindContents then begin
        addstr3:=' Upper(cp_Contents) like '+AnsiUpperCase(QuotedStr(FilInSide+FindContents+'%'))+' ';
     end;

     if isFindKredit and isFindDebit then and1 := ' and ';
     if isFindContents and (isFindDebit or isFindKredit) then and2 := ' and ';

     Result:=wherestr+addstr1+and1+addstr2+and2+addstr3;
end;


{procedure TfmRBCorrectPost.Button1Click(Sender: TObject);
var
  P: PCorrectPostParams;
begin
  GetMem(P,SizeOf(TCorrectPostParams));
  try
    FillChar(P^,SizeOf(TCorrectPostParams),0);
    P.username:='adminuser';
    if _ViewEntryFromMain(tte_rbksCorrectPost,P,true) then begin
      ShowMessage(P.username);
    end;
  finally
    FreeMem(P,SizeOf(TCorrectPostParams));
  end;

end;
}
end.
