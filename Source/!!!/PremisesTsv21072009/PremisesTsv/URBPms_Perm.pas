unit URBPms_Perm;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, Menus , tsvDbGrid, IBUpdateSQL;

type
   TfmRBPms_Perm = class(TfmRBMainGrid)
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
    procedure MainqrCalcFields(DataSet: TDataSet);
  private
    isFindUserName,isFindPerm,isFindTypeOperation: Boolean;
    FindUserName,FindPerm: String;
    FindTypeOperation: Integer;
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
  fmRBPms_Perm: TfmRBPms_Perm;

implementation

uses UMainUnited, UPremisesTsvCode, UPremisesTsvDM, UPremisesTsvData, UEditRBPms_Perm;

{$R *.DFM}

procedure TfmRBPms_Perm.FormCreate(Sender: TObject);
var
  cl: TColumn;
  ifl: TIntegerField;
  sfl: TStringField;
begin
 inherited;
 try
  Caption:=NameRbkPms_Perm;
  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  FindTypeOperation:=-1;

  ifl:=TIntegerField.Create(nil);
  ifl.FieldName:='pms_perm_id';
  ifl.Visible:=false;
  ifl.DataSet:=Mainqr;

  ifl:=TIntegerField.Create(nil);
  ifl.FieldName:='user_id';
  ifl.Visible:=false;
  ifl.DataSet:=Mainqr;

  sfl:=TStringField.Create(nil);
  sfl.FieldName:='username';
  sfl.DataSet:=Mainqr;
  sfl.Size:=DomainNameLength;

  cl:=Grid.Columns.Add;
  cl.Field:=sfl;
  cl.Title.Caption:='Имя пользователя';
  cl.Width:=150;

  sfl:=TStringField.Create(nil);
  sfl.FieldName:='perm';
  sfl.DataSet:=Mainqr;
  sfl.Size:=DomainShortNameLength;

  cl:=Grid.Columns.Add;
  cl.Field:=sfl;
  cl.Title.Caption:='Право';
  cl.Width:=60;

  ifl:=TIntegerField.Create(nil);
  ifl.FieldName:='typeoperation';
  ifl.Visible:=false;
  ifl.DataSet:=Mainqr;

  sfl:=TStringField.Create(nil);
  sfl.FieldName:='typeoperationplus';
  sfl.FieldKind:=fkCalculated;
  sfl.Size:=DomainShortNameLength;
  sfl.DataSet:=Mainqr;

  cl:=Grid.Columns.Add;
  cl.Field:=sfl;
  cl.Title.Caption:='Тип операции с недвижимостью';
  cl.Width:=100;

  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBPms_Perm.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBPms_Perm:=nil;
end;

function TfmRBPms_Perm.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkPms_Perm+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBPms_Perm.ActiveQuery(CheckPerm: Boolean);
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
   SetImageFilter(isFindUserName or isFindPerm or isFindTypeOperation);
   ViewCount;
  finally
   Mainqr.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBPms_Perm.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   if AnsiSameText(fn,'typeoperationplus') then fn:='typeoperation';
   if AnsiSameText(fn,'username') then fn:='u.name';
   id:=MainQr.fieldByName('Pms_Perm_id').asString;
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('Pms_Perm_id',id,[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBPms_Perm.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBPms_Perm.LoadFromIni;
begin
 inherited;
 try
    FindUserName:=ReadParam(ClassName,'username',FindUserName);
    FindPerm:=ReadParam(ClassName,'perm',FindPerm);
    FindTypeOperation:=ReadParam(ClassName,'typeoperation',FindTypeOperation);
    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBPms_Perm.SaveToIni;
begin
 inherited;
 try
    WriteParam(ClassName,'username',FindUserName);
    WriteParam(ClassName,'perm',FindPerm);
    WriteParam(ClassName,'typeoperation',FindTypeOperation);
    WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBPms_Perm.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBPms_Perm.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBPms_Perm;
begin
  if not Mainqr.Active then exit;
  fm:=TfmEditRBPms_Perm.Create(nil);
  try
    fm.fmParent:=Self;
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ViewCount;
     MainQr.Locate('Pms_Perm_id',fm.oldPms_Perm_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBPms_Perm.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBPms_Perm;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBPms_Perm.Create(nil);
  try
    fm.fmParent:=Self;
    fm.TypeEditRBook:=terbChange;
    fm.user_id:=Mainqr.fieldByName('user_id').Value;
    fm.edUserName.Text:=Mainqr.fieldByName('username').AsString;
    fm.SetPerm(Mainqr.fieldByName('perm').AsString);
    fm.cmbTypeOperation.ItemIndex:=Mainqr.fieldByName('typeoperation').AsInteger;
    fm.oldPms_Perm_id:=MainQr.FieldByName('Pms_Perm_id').AsInteger;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     MainQr.Locate('Pms_Perm_id',fm.oldPms_Perm_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBPms_Perm.bibDelClick(Sender: TObject);
var
  but: Integer;

  function DeleteRecord: Boolean;
  var
    qr: TIBQuery;
    tran: TIBTransaction;
    sqls: string;
  begin
   Screen.Cursor:=crHourGlass;
   qr:=TIBQuery.Create(nil);
   tran:=TIBTransaction.Create(nil);
   try
    result:=false;
    try
     tran.AddDatabase(IBDB);
     IBDB.AddTransaction(tran);
     tran.Params.Text:=DefaultTransactionParamsTwo;
     qr.Database:=IBDB;
     qr.Transaction:=tran;
     qr.Transaction.Active:=true;
     sqls:='Delete from '+tbPms_Perm+' where Pms_Perm_id='+
          Mainqr.FieldByName('Pms_Perm_id').asString;
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;

     IBUpd.DeleteSQL.Clear;
     IBUpd.DeleteSQL.Add(sqls);
     Mainqr.Delete;
     
     ViewCount;

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
    tran.Free; 
    qr.Free;
    Screen.Cursor:=crDefault;
   end;

  end;

begin
  if Mainqr.RecordCount=0 then exit;
  but:=DeleteWarningEx('право на <'+Mainqr.FieldByName('typeoperationplus').AsString+'> ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBPms_Perm.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBPms_Perm;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBPms_Perm.Create(nil);
  try
    fm.TypeEditRBook:=terbView;
    fm.user_id:=Mainqr.fieldByName('user_id').Value;
    fm.edUserName.Text:=Mainqr.fieldByName('username').AsString;
    fm.SetPerm(Mainqr.fieldByName('perm').AsString);
    fm.cmbTypeOperation.ItemIndex:=Mainqr.fieldByName('typeoperation').AsInteger;
    fm.oldPms_Perm_id:=MainQr.FieldByName('Pms_Perm_id').AsInteger;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBPms_Perm.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBPms_Perm;
  filstr: string;
begin
 fm:=TfmEditRBPms_Perm.Create(nil);
 try
  fm.TypeEditRBook:=terbFilter;
  fm.edUserName.ReadOnly:=false;
  fm.edUserName.Color:=clWindow;
  fm.cmbPerm.Style:=csDropDown;
  fm.cmbPerm.ItemIndex:=-1;
  fm.cmbTypeOperation.Style:=csDropDown;
  fm.cmbTypeOperation.ItemIndex:=-1;

  if Trim(FindUserName)<>'' then fm.edUserName.Text:=FindUserName;
  if Trim(FindPerm)<>'' then fm.SetPerm(FindPerm);
  if FindTypeOperation in [0..2] then
    fm.cmbTypeOperation.ItemIndex:=FindTypeOperation;

  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    inherited;

    FindUserName:=Trim(fm.edUserName.Text);
    FindPerm:=Trim(Copy(fm.cmbPerm.Text,1,1));
    FindTypeOperation:=fm.cmbTypeOperation.Items.IndexOf(fm.cmbTypeOperation.Text);

    FilterInSide:=fm.cbInString.Checked;
    if FilterInSide then filstr:='%';

    ActiveQuery(false);
    ViewCount;
  end;
 finally
  fm.Free;
 end;
end;

function TfmRBPms_Perm.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2,addstr3: string;
  and1,and2: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then exit;

    isFindUserName:=Trim(FindUserName)<>'';
    isFindPerm:=Trim(FindPerm)<>'';
    isFindTypeOperation:=FindTypeOperation in [0..2];

    if isFindUserName or isFindPerm or isFindTypeOperation then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindUserName then begin
        addstr1:=' Upper(u.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindUserName+'%'))+' ';
     end;

     if isFindPerm then begin
        addstr2:=' Upper(perm) like '+AnsiUpperCase(QuotedStr(FilInSide+FindPerm+'%'))+' ';
     end;

     if isFindTypeOperation then begin
        addstr3:=' typeoperation= '+inttostr(FindTypeOperation)+' ';
     end;

     if (isFindUserName and isFindPerm)or
        (isFindUserName and isFindTypeOperation)then
      and1:=' and ';

     if (isFindPerm and isFindTypeOperation)then
      and2:=' and ';

     Result:=wherestr+addstr1+and1+
                      addstr2+and2+
                      addstr3;
end;


procedure TfmRBPms_Perm.MainqrCalcFields(DataSet: TDataSet);
begin
  DataSet['typeoperationplus']:=GetTypeOperationName(DataSet.FieldByName('typeoperation').AsInteger);
end;

end.
