unit UEditRBCorrectPost;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase,
  IB, IBCustomDataSet, IBTable, Mask, ComCtrls;

type
  TfmEditRBCorrectPost = class(TfmEditRB)
    LDebit: TLabel;
    BDebit: TButton;
    LKredit: TLabel;
    BKredit: TButton;
    LContents: TLabel;
    EContents: TEdit;
    MEDebit: TMaskEdit;
    MEKredit: TMaskEdit;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure EditChange(Sender: TObject);
    procedure BDebitClick(Sender: TObject);
    procedure BKreditClick(Sender: TObject);
    procedure bibClearClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
//    oldcb_text: string;
//    cb_id: Integer;
//    cb_text: string;
    cp_debit,cp_kredit: integer;
    oldcp_debit,oldcp_kredit: integer;
    DebitAccount,KreditAccount: string;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
    procedure ConvertAccounts; 
  end;

var
  fmEditRBCorrectPost: TfmEditRBCorrectPost;

implementation

uses UKassaKDMCode, UKassaKDMData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBCorrectPost.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;


function TfmEditRBCorrectPost.AddToRBooks: Boolean;
var
  qr: TIBQuery;
  sqls,addstr: string;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    if Trim(EContents.Text)<>'' then
      addstr := QuotedStr(Trim(EContents.Text))
    else
      addstr := 'NULL';  
    sqls:='Insert into '+tbCorrectPost+
          ' (cp_debit,cp_kredit,cp_contents) values ('+
          IntToStr(cp_debit)+','+IntToStr(cp_kredit)+','+addstr+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

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

procedure TfmEditRBCorrectPost.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBCorrectPost.UpdateRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id1,id2: string;
begin
 result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try
    id1:=IntToStr(oldcp_debit);//fmRBCorrectPost.MainQr.FieldByname('username').AsString;
    id2:=IntToStr(oldcp_kredit);//fmRBCorrectPost.MainQr.FieldByname('username').AsString;
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbCorrectPost+
          ' set cp_debit='+IntToStr(cp_debit)+' , '+
          ' cp_kredit='+IntToStr(cp_kredit)+' , '+
          ' cp_contents='+QuotedStr(Trim(EContents.Text))+
          ' where cp_debit='+id1+' and '+'cp_kredit='+id2;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

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

procedure TfmEditRBCorrectPost.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end;
  ModalResult:=mrOk;
end;

function TfmEditRBCorrectPost.CheckFieldsFill: Boolean;
var
  qr: TIBQuery;
  sqls: string;
begin
 try
 qr := TIBQuery.Create(nil);
 qr.Database := IBDB;
 qr.Transaction := IBTran;
 try
  Result:=true;
  if trim(MEDebit.Text)='.  .' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[LDebit.Caption]));
    MEDebit.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(MEKredit.Text)='.  .' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[LKredit.Caption]));
    MEKredit.SetFocus;
    Result:=false;
    exit;
  end;
  if (trim(MEDebit.Text)<>'.  .') and (cp_debit=0) then begin
    ConvertAccounts;
    sqls := 'select * from '+tbPlanAccounts+' where pa_groupid='+QuotedStr(DebitAccount);
    qr.SQL.Clear;
    qr.SQL.Add(sqls);
    qr.Open;
    if not qr.IsEmpty then
      cp_debit := qr.FieldByName('pa_id').AsInteger
    else begin
      ShowMessage('—чет <'+DebitAccount+'> не существует');
      MEDebit.SetFocus;
      Result:=false;
      exit
    end;
  end;
  if (trim(MEKredit.Text)<>'.  .') and (cp_kredit=0) then begin
    ConvertAccounts;
    sqls := 'select * from '+tbPlanAccounts+' where pa_groupid='+QuotedStr(KreditAccount);
    qr.SQL.Clear;
    qr.SQL.Add(sqls);
    qr.Open;
    if not qr.IsEmpty then
      cp_kredit := qr.FieldByName('pa_id').AsInteger
    else begin
      ShowMessage('—чет <'+KreditAccount+'> не существует');
      MEKredit.SetFocus;
      Result:=false;
      exit
    end;
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

procedure TfmEditRBCorrectPost.EditChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBCorrectPost.FormCreate(Sender: TObject);
var
  isPerm: Boolean;
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);
  isPerm := _isPermission(tbPlanAccounts,SelConst);
  BDebit.Enabled := isPerm;
  BKredit.Enabled := isPerm;
end;

procedure TfmEditRBCorrectPost.BDebitClick(Sender: TObject);
var
  P: PPlanAccountsParams;
begin
  GetMem(P,SizeOf(TPlanAccountsParams));
  try
    FillChar(P^,SizeOf(TPlanAccountsParams),0);
    P.PA_ID := oldcp_debit;
    if _ViewEntryFromMain(tte_rbksPlanAccounts,P,true) then begin
      cp_debit := p.pa_id;
      MEDebit.Text := P.PA_GROUPID;
      EditChange(Sender);
//      ShowMessage(P.username);
    end;
  finally
    FreeMem(P,SizeOf(TPlanAccountsParams));
  end;
end;

procedure TfmEditRBCorrectPost.ConvertAccounts;
var
 Account: TStrings;
begin
 Account := TStringList.Create;
 try
   Account := divide(MEDebit.Text);
   if (Account[0]<>'') then begin
    DebitAccount := Account[0];
    if (Account[1]<>'') then begin
      DebitAccount := DebitAccount+'.'+Account[1];
      if (Account[2]<>'') then begin
        DebitAccount := DebitAccount+'.'+Account[2];
      end;
    end;
   end;
   Account := divide(MEKredit.Text);
   if (Account[0]<>'') then begin
    KreditAccount := Account[0];
    if (Account[1]<>'') then begin
      KreditAccount := KreditAccount+'.'+Account[1];
      if (Account[2]<>'') then begin
        KreditAccount := KreditAccount+'.'+Account[2];
      end;
    end;
   end;
 finally
   Account.Free;
 end;
end;

procedure TfmEditRBCorrectPost.BKreditClick(Sender: TObject);
var
  P: PPlanAccountsParams;
begin
  GetMem(P,SizeOf(TPlanAccountsParams));
  try
    FillChar(P^,SizeOf(TPlanAccountsParams),0);
    P.pa_id:=oldcp_kredit;
    if _ViewEntryFromMain(tte_rbksPlanAccounts,P,true) then begin
      cp_kredit := p.pa_id;
      MEKredit.Text := P.PA_GROUPID;
      EditChange(Sender);
//      ShowMessage(P.username);
    end;
  finally
    FreeMem(P,SizeOf(TPlanAccountsParams));
  end;
end;

procedure TfmEditRBCorrectPost.bibClearClick(Sender: TObject);
begin
  inherited;
  MEDebit.Text := '';
  MEKredit.Text := '';
end;

procedure TfmEditRBCorrectPost.Button1Click(Sender: TObject);
var
  P: PEmpParams;
begin
  GetMem(P,SizeOf(TEmpParams));
  try
    FillChar(P^,SizeOf(TEmpParams),0);
//    P. := oldcp_debit;
    if _ViewEntryFromMain(tte_rbksemp,P,true) then begin
      cp_debit := p.emp_id;
      MEDebit.Text := P.fname;
      EditChange(Sender);
//      ShowMessage(P.username);
    end;
  finally
    FreeMem(P,SizeOf(TEmpParams));
  end;
end;

end.
