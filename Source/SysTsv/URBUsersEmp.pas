unit URBUsersEmp;

interface

{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, Menus, tsvDbGrid, IBUpdateSQL;

type
   TfmRBUsersEmp = class(TfmRBMainGrid)
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
  private
    isFindUserName,isFindEmp: Boolean;
    FindUserName,FindEmp: String;
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
  fmRBUsersEmp: TfmRBUsersEmp;

implementation

uses UMainUnited, USysTsvCode, USysTsvDM, USysTsvData, UEditRBUsersEmp;

{$R *.DFM}

procedure TfmRBUsersEmp.FormCreate(Sender: TObject);
var
 cl: TColumn;
begin
 inherited;
 try
  Caption:=NameRbkUsersEmp;
  
  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  cl:=Grid.Columns.Add;
  cl.FieldName:='username';
  cl.Title.Caption:='Пользователь';
  cl.Width:=180;

  cl:=Grid.Columns.Add;
  cl.FieldName:='empname';
  cl.Title.Caption:='Сотрудник';
  cl.Width:=180;
  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end; 
end;

procedure TfmRBUsersEmp.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBUsersEmp:=nil;
end;

function TfmRBUsersEmp.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkUsersEmp+GetFilterString+GetLastOrderStr;
end;


procedure TfmRBUsersEmp.ActiveQuery(CheckPerm: Boolean);
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
   SetImageFilter(isFindUserName or isFindEmp);
   ViewCount;
  finally
   Mainqr.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBUsersEmp.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id1,id2: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   if UpperCase(fn)=UpperCase('empname') then fn:='2';
   if UpperCase(fn)=UpperCase('username') then fn:='u.name';
   id1:=MainQr.fieldByName('user_id').asString;
   id2:=MainQr.fieldByName('emp_id').asString;
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('user_id;emp_id',VarArrayOf([id1,id2]),[LocaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBUsersEmp.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBUsersEmp.LoadFromIni;
begin
 inherited;
 try
   FindUserName:=ReadParam(ClassName,'username',FindUserName);
   FindEmp:=ReadParam(ClassName,'emp',FindEmp);
   FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBUsersEmp.SaveToIni;
begin
 Inherited;
 try
    WriteParam(ClassName,'username',FindUserName);
    WriteParam(ClassName,'emp',FindEmp);
    WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBUsersEmp.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBUsersEmp.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBUsersEmp;
begin
 try
  if not Mainqr.Active then exit;
  fm:=TfmEditRBUsersEmp.Create(nil);
  try
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('user_id;emp_id',VarArrayOf([fm.user_id,fm.emp_id]),[LocaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBUsersEmp.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBUsersEmp;
begin
 try
  if Mainqr.isEmpty then exit;
  fm:=TfmEditRBUsersEmp.Create(nil);
  try
    fm.TypeEditRBook:=terbChange;
    fm.emp_id:=Mainqr.fieldByName('emp_id').AsInteger;
    fm.oldemp_id:=fm.emp_id;
    fm.edEmp.Text:=Mainqr.fieldByName('empname').AsString;
    fm.user_id:=Mainqr.fieldByName('user_id').AsInteger;
    fm.olduser_id:=fm.user_id;
    fm.edUserName.Text:=Mainqr.fieldByName('username').AsString;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('user_id;emp_id',VarArrayOf([fm.user_id,fm.emp_id]),[LocaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBUsersEmp.bibDelClick(Sender: TObject);
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
     sqls:='Delete from '+tbUsersEmp+
           ' where user_id='+ QuotedStr(Mainqr.FieldByName('user_id').asString)+
           ' and emp_id='+Mainqr.FieldByName('emp_id').asString;
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
  if  Mainqr.isEmpty then exit;
  but:=DeleteWarningEx('текущую запись ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBUsersEmp.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBUsersEmp;
begin
 try
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  fm:=TfmEditRBUsersEmp.Create(nil);
  try
    fm.TypeEditRBook:=terbView;
    fm.emp_id:=Mainqr.fieldByName('emp_id').AsInteger;
    fm.oldemp_id:=fm.emp_id;
    fm.edEmp.Text:=Mainqr.fieldByName('empname').AsString;
    fm.user_id:=Mainqr.fieldByName('user_id').AsInteger;
    fm.olduser_id:=fm.user_id;
    fm.edUserName.Text:=Mainqr.fieldByName('username').AsString;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBUsersEmp.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBUsersEmp;
  filstr: string;
begin
try
 fm:=TfmEditRBUsersEmp.Create(nil);
 try
  fm.TypeEditRBook:=terbFilter;

  fm.edEmp.Color:=clWindow;
  fm.edEmp.ReadOnly:=false;
  fm.edUsername.Color:=clWindow;
  fm.edUsername.ReadOnly:=false;

  if Trim(FindEmp)<>'' then fm.edEmp.Text:=FindEmp;
  if Trim(FindUserName)<>'' then fm.edUsername.Text:=FindUserName;

  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    inherited;

    FindEmp:=Trim(fm.edEmp.Text);
    FindUserName:=Trim(fm.edUserName.Text);

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

function TfmRBUsersEmp.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2: string;
  and1: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then exit;

    isFindEmp:=Trim(FindEmp)<>'';
    isFindUserName:=Trim(FindUserName)<>'';

    if isFindEmp or isFindUserName then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindEmp then begin
        addstr1:=' Upper(e.fname||'' ''||e.name||'' ''||e.sname) like '+AnsiUpperCase(QuotedStr(FilInSide+Findemp+'%'))+' ';
     end;

     if isFindUserName then begin
        addstr2:=' Upper(u.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindUserName+'%'))+' ';
     end;

     if (isFindEmp and isFindUserName)
       then and1:=' and ';

     Result:=wherestr+addstr1+and1+addstr2;
end;


end.
