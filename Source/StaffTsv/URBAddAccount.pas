unit URBAddAccount;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, Menus , tsvDbGrid, IBUpdateSQL;

type
   TfmRBAddAccount = class(TfmRBMainGrid)
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
  private
    isFindBank,isFindAccount: Boolean;
    FindBank,FindAccount: string;
  protected
    procedure GridDblClick(Sender: TObject); override;
    procedure SaveToIni;override;
    procedure LoadFromIni; override;
    function GetFilterString: string; override;
    procedure GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort); override;
    function GetSql: string; override;
  public
    plant_id: Integer;
    procedure ActiveQuery(CheckPerm: Boolean);override;
  end;

var
  fmRBAddAccount: TfmRBAddAccount;

implementation

uses UMainUnited, UStaffTsvCode, UStaffTsvDM, UStaffTsvData, UEditRBAddAccount;

{$R *.DFM}

procedure TfmRBAddAccount.FormCreate(Sender: TObject);
var
  cl: TColumn;
begin
 inherited;
 try
  Caption:=NameRbkAddAccount;
  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  cl:=Grid.Columns.Add;
  cl.FieldName:='account';
  cl.Title.Caption:='Расчетный счет';
  cl.Width:=120;

  cl:=Grid.Columns.Add;
  cl.FieldName:='bankname';
  cl.Title.Caption:='Банк';
  cl.Width:=100;

  cl:=Grid.Columns.Add;
  cl.FieldName:='plantname';
  cl.Title.Caption:='Контрагент';
  cl.Width:=100;

  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBAddAccount.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBAddAccount:=nil;
end;

function TfmRBAddAccount.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkAddAccount+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBAddAccount.ActiveQuery(CheckPerm: Boolean);
var
 sqls: String;
begin
 try
  Mainqr.Active:=false;
  if CheckPerm then
   if not CheckPermission then exit;

  Screen.Cursor:=crHourGlass;
  Mainqr.DisableControls;
  try
   Mainqr.sql.Clear;
   sqls:=GetSql;
   Mainqr.sql.Add(sqls);
   Mainqr.Transaction.Active:=false;
   Mainqr.Transaction.Active:=true;
   Mainqr.Active:=true;
   SetImageFilter(isFindBank or isFindAccount);
   ViewCount;
  finally
   Mainqr.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBAddAccount.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: string;
begin
 try
   if not MainQr.Active then exit; 
   fn:=Column.FieldName;
   id:=MainQr.fieldByName('addaccount_id').asString;
   if UpperCase(fn)=UpperCase('plantname') then fn:='p.smallname';
   if UpperCase(fn)=UpperCase('bankname') then fn:='b.name';
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('addaccount_id',id,[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBAddAccount.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBAddAccount.LoadFromIni;
begin
 inherited;
 try
    FindBank:=ReadParam(ClassName,'Bank',FindBank);
    FindAccount:=ReadParam(ClassName,'Account',FindAccount);
    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBAddAccount.SaveToIni;
begin
 inherited;
 try
    WriteParam(ClassName,'Account',FindAccount);
    WriteParam(ClassName,'Bank',FindBank);
    WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBAddAccount.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBAddAccount.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBAddAccount;
begin
  if not Mainqr.Active then exit;
  fm:=TfmEditRBAddAccount.Create(nil);
  try
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    fm.oldplant_id:=plant_id;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('addaccount_id',fm.oldaddaccount_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBAddAccount.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBAddAccount;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBAddAccount.Create(nil);
  try
    fm.TypeEditRBook:=terbChange;
    fm.edBank.Text:=Mainqr.fieldByName('bankname').AsString;
    fm.bank_id:=Mainqr.fieldByName('bank_id').AsInteger;
    fm.edAccount.Text:=Mainqr.fieldByName('account').AsString;
    fm.oldaddaccount_id:=MainQr.FieldByName('addaccount_id').AsInteger;
    fm.oldplant_id:=plant_id;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('addaccount_id',fm.oldaddaccount_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBAddAccount.bibDelClick(Sender: TObject);
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
     sqls:='Delete from '+tbAddAccount+' where addaccount_id='+
          Mainqr.FieldByName('addaccount_id').asString;
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;
     ActiveQuery(false);
     Result:=true;
    except
     on E: EIBInterBaseError do begin
        TempStr:=TranslateIBError(E.Message);
        ShowErrorEx(TempStr);
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
  if Mainqr.RecordCount=0 then exit;
  but:=DeleteWarningEx('дополнительный р/счет <'+Mainqr.FieldByName('account').AsString+'> ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBAddAccount.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBAddAccount;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBAddAccount.Create(nil);
  try
    fm.TypeEditRBook:=terbView;
    fm.edBank.Text:=Mainqr.fieldByName('bankname').AsString;
    fm.bank_id:=Mainqr.fieldByName('bank_id').AsInteger;
    fm.edAccount.Text:=Mainqr.fieldByName('account').AsString;
    
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBAddAccount.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBAddAccount;
  filstr: string;
begin
 fm:=TfmEditRBAddAccount.Create(nil);
 try
  fm.TypeEditRBook:=terbFilter;

  fm.edBank.ReadOnly:=false;
  fm.edBank.Color:=clWindow;

  if Trim(FindAccount)<>'' then fm.edAccount.Text:=FindAccount;
  if Trim(FindBank)<>'' then fm.edBank.Text:=FindBank;

  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    inherited;

    FindAccount:=fm.edAccount.Text;
    FindBank:=fm.edBank.Text;

    FilterInSide:=fm.cbInString.Checked;
    if FilterInSide then filstr:='%';

    ActiveQuery(false);
    ViewCount;
  end;
 finally
  fm.Free;
 end;
end;

function TfmRBAddAccount.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2: string;
  and1,and2: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then exit;

    isFindAccount:=Trim(FindAccount)<>'';
    isFindBank:=Trim(FindBank)<>'';

    if isFindAccount or isFindBank then
    begin
     wherestr:=' where ';
    end else begin
     wherestr:=' where ';
    end;

    if FilterInside then FilInSide:='%';

     if isFindAccount then begin
        addstr1:=' Upper(account) like '+AnsiUpperCase(QuotedStr(FilInSide+FindAccount+'%'))+' ';
        and2:=' and ';
     end;

     if isFindBank then begin
       addstr2:=' Upper(b.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindBank+'%'))+' ';
       and2:=' and ';
     end;

     if (isFindAccount and isFindBank)
        then begin
         and1:=' and ';
        end;

 
     Result:=wherestr+addstr1+and1+
                      addstr2+and2+' ac.plant_id='+inttostr(plant_id);
end;


end.
