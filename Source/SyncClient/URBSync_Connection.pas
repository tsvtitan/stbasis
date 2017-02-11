unit URBSync_Connection;

interface

{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, grids, Menus, tsvDbGrid, IBUpdateSQL;

type
   TfmRBSync_Connection = class(TfmRBMainGrid)
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
  private
    isFindName: Boolean;
    FindName: String;

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
  fmRBSync_Connection: TfmRBSync_Connection;

implementation

uses UMainUnited, USyncClientCode, USyncClientDM, USyncClientData, UEditRBSync_Connection;

{$R *.DFM}

procedure TfmRBSync_Connection.FormCreate(Sender: TObject);
var
  cl: TColumn;
begin
 inherited;
 try
  Caption:=NameRbkSync_Connection;
  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  cl:=Grid.Columns.Add;
  cl.FieldName:='display_name';
  cl.Title.Caption:='Наименование';
  cl.Width:=150;

  cl:=Grid.Columns.Add;
  cl.FieldName:='server_name';
  cl.Title.Caption:='Сервер';
  cl.Width:=120;

  cl:=Grid.Columns.Add;
  cl.FieldName:='server_port';
  cl.Title.Caption:='Порт';
  cl.Width:=60;

  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBSync_Connection.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBSync_Connection:=nil;
end;

function TfmRBSync_Connection.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkSync_Connection+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBSync_Connection.ActiveQuery(CheckPerm: Boolean);
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
   SetImageFilter(isFindName);
   ViewCount;
  finally
   Mainqr.EnableControls; 
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBSync_Connection.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   id:=MainQr.fieldByName('sync_connection_id').asString;
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('sync_connection_id',id,[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBSync_Connection.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBSync_Connection.LoadFromIni;
begin
 inherited;
 try
    FindName:=ReadParam(ClassName,'name',FindName);
    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBSync_Connection.SaveToIni;
begin
 inherited;
 try
    WriteParam(ClassName,'name',FindName);
    WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBSync_Connection.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBSync_Connection.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBSync_Connection;
begin
  if not Mainqr.Active then exit;
  fm:=TfmEditRBSync_Connection.Create(nil);
  try
    fm.fmParent:=Self;
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
      ViewCount;
      MainQr.Locate('sync_connection_id',fm.oldsync_connection_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBSync_Connection.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBSync_Connection;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBSync_Connection.Create(nil);
  try
    fm.fmParent:=Self;
    fm.bibOk.OnClick:=fm.ChangeClick;
    fm.Caption:=CaptionChange;
    fm.oldsync_connection_id:=Mainqr.fieldByName('sync_connection_id').AsInteger;
    fm.chbUsed.Checked:=Boolean(Mainqr.fieldByName('used').AsInteger);
    fm.edDisplayName.Text:=Mainqr.fieldByName('display_name').AsString;
    fm.cmbConnectionType.ItemIndex:=Mainqr.fieldByName('connection_type').AsInteger;
    fm.edServerName.Text:=Mainqr.fieldByName('server_name').AsString;
    fm.edServerPort.Text:=Mainqr.fieldByName('server_port').AsString;
    fm.edOfficeName.Text:=Mainqr.fieldByName('office_name').AsString;
    fm.edOfficeKey.Text:=Mainqr.fieldByName('office_key').AsString;
    fm.edProxyName.Text:=Mainqr.fieldByName('proxy_name').AsString;
    fm.edProxyPort.Text:=Mainqr.fieldByName('proxy_port').AsString;
    fm.edProxyUserName.Text:=Mainqr.fieldByName('proxy_user_name').AsString;
    fm.edProxyUserPass.Text:=Mainqr.fieldByName('proxy_user_pass').AsString;
    fm.edProxyByPass.Text:=Mainqr.fieldByName('proxy_by_pass').AsString;
    fm.chbInetAuto.Checked:=Boolean(Mainqr.fieldByName('inet_auto').AsInteger);
    fm.chbInetAutoClick(nil);
    fm.cmbRemoteName.ItemIndex:=fm.cmbRemoteName.Items.IndexOf(Mainqr.fieldByName('remote_name').AsString);
    fm.edModemUserName.Text:=Mainqr.fieldByName('modem_user_name').AsString;
    fm.edModemUserPass.Text:=Mainqr.fieldByName('modem_user_pass').AsString;
    fm.edModemDomain.Text:=Mainqr.fieldByName('modem_domain').AsString;
    fm.edModemPhone.Text:=Mainqr.fieldByName('modem_phone').AsString;
    fm.udRetryCount.Position:=Mainqr.fieldByName('retry_count').AsInteger;
    fm.udPriority.Position:=Mainqr.fieldByName('priority').AsInteger;

    fm.cmbConnectionTypeChange(nil);
    fm.TypeEditRBook:=terbChange;
    fm.ChangeFlag:=false;
    
    if fm.ShowModal=mrok then begin
      MainQr.Locate('sync_connection_id',fm.oldsync_connection_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBSync_Connection.bibDelClick(Sender: TObject);
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
     sqls:='Delete from '+tbSync_Connection+' where sync_connection_id='+
            Mainqr.FieldByName('sync_connection_id').asString;
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;
//     ActiveQuery(false);

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
  but:=DeleteWarningEx('наименование <'+Mainqr.FieldByName('display_name').AsString+'> ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBSync_Connection.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBSync_Connection;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBSync_Connection.Create(nil);
  try

    fm.oldsync_connection_id:=Mainqr.fieldByName('sync_connection_id').AsInteger;
    fm.chbUsed.Checked:=Boolean(Mainqr.fieldByName('used').AsInteger);
    fm.edDisplayName.Text:=Mainqr.fieldByName('display_name').AsString;
    fm.cmbConnectionType.ItemIndex:=Mainqr.fieldByName('connection_type').AsInteger;
    fm.edServerName.Text:=Mainqr.fieldByName('server_name').AsString;
    fm.edServerPort.Text:=Mainqr.fieldByName('server_port').AsString;
    fm.edOfficeName.Text:=Mainqr.fieldByName('office_name').AsString;
    fm.edOfficeKey.Text:=Mainqr.fieldByName('office_key').AsString;
    fm.edProxyName.Text:=Mainqr.fieldByName('proxy_name').AsString;
    fm.edProxyPort.Text:=Mainqr.fieldByName('proxy_port').AsString;
    fm.edProxyUserName.Text:=Mainqr.fieldByName('proxy_user_name').AsString;
    fm.edProxyUserPass.Text:=Mainqr.fieldByName('proxy_user_pass').AsString;
    fm.edProxyByPass.Text:=Mainqr.fieldByName('proxy_by_pass').AsString;
    fm.chbInetAuto.Checked:=Boolean(Mainqr.fieldByName('inet_auto').AsInteger);
    fm.chbInetAutoClick(nil);
    fm.cmbRemoteName.ItemIndex:=fm.cmbRemoteName.Items.IndexOf(Mainqr.fieldByName('remote_name').AsString);
    fm.edModemUserName.Text:=Mainqr.fieldByName('modem_user_name').AsString;
    fm.edModemUserPass.Text:=Mainqr.fieldByName('modem_user_pass').AsString;
    fm.edModemDomain.Text:=Mainqr.fieldByName('modem_domain').AsString;
    fm.edModemPhone.Text:=Mainqr.fieldByName('modem_phone').AsString;
    fm.udRetryCount.Position:=Mainqr.fieldByName('retry_count').AsInteger;
    fm.udPriority.Position:=Mainqr.fieldByName('priority').AsInteger;

    fm.cmbConnectionTypeChange(nil);
    fm.TypeEditRBook:=terbView;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBSync_Connection.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBSync_Connection;
  filstr: string;
begin
 fm:=TfmEditRBSync_Connection.Create(nil);
 try
  fm.TypeEditRBook:=terbFilter;

  if Trim(FindName)<>'' then fm.edDisplayName.Text:=FindName;

   fm.chbUsed.Enabled:=false;

   fm.cmbConnectionType.Enabled:=false;
   fm.cmbConnectionType.Color:=clBtnFace;
   fm.lbConnectionType.Enabled:=false;

   fm.edServerName.Enabled:=false;
   fm.edServerName.Color:=clBtnFace;
   fm.lbServerName.Enabled:=false;

   fm.edServerPort.Enabled:=false;
   fm.edServerPort.Color:=clBtnFace;
   fm.lbServerPort.Enabled:=false;

   fm.edOfficeName.Enabled:=false;
   fm.edOfficeName.Color:=clBtnFace;
   fm.edOfficeName.Enabled:=false;

   fm.edOfficeKey.Enabled:=false;
   fm.edOfficeKey.Color:=clBtnFace;
   fm.lbOfficeKey.Enabled:=false;

   fm.edProxyName.Enabled:=false;
   fm.edProxyName.Color:=clBtnFace;
   fm.lbProxyName.Enabled:=false;

   fm.edProxyPort.Enabled:=false;
   fm.edProxyPort.Color:=clBtnFace;
   fm.lbProxyPort.Enabled:=false;

   fm.edProxyUserName.Enabled:=false;
   fm.edProxyUserName.Color:=clBtnFace;
   fm.lbProxyUserName.Enabled:=false;

   fm.edProxyUserPass.Enabled:=false;
   fm.edProxyUserPass.Color:=clBtnFace;
   fm.lbProxyUserPass.Enabled:=false;

   fm.edProxyByPass.Enabled:=false;
   fm.edProxyByPass.Color:=clBtnFace;
   fm.lbProxyByPass.Enabled:=false;

   fm.chbInetAuto.Enabled:=false;

   fm.cmbRemoteName.Enabled:=false;
   fm.cmbRemoteName.Color:=clBtnFace;
   fm.lbRemoteName.Enabled:=false;

   fm.edModemUserName.Enabled:=false;
   fm.edModemUserName.Color:=clBtnFace;
   fm.lbModemUserName.Enabled:=false;

   fm.edModemUserPass.Enabled:=false;
   fm.edModemUserPass.Color:=clBtnFace;
   fm.lbModemUserPass.Enabled:=false;

   fm.edModemDomain.Enabled:=false;
   fm.edModemDomain.Color:=clBtnFace;
   fm.lbModemDomain.Enabled:=false;

   fm.edModemPhone.Enabled:=false;
   fm.edModemPhone.Color:=clBtnFace;
   fm.lbModemPhone.Enabled:=false;

   fm.edRetryCount.Enabled:=false;
   fm.edRetryCount.Color:=clBtnFace;
   fm.lbRetryCount.Enabled:=false;
   fm.udRetryCount.Enabled:=false;

   fm.edPriority.Enabled:=false;
   fm.edPriority.Color:=clBtnFace;
   fm.lbPriority.Enabled:=false;
   fm.udPriority.Enabled:=false;

   fm.cbInString.Checked:=FilterInSide;

   fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    Inherited;

    FindName:=Trim(fm.edDisplayName.Text);

    FilterInSide:=fm.cbInString.Checked;
    if FilterInSide then filstr:='%';

    ActiveQuery(false);
    ViewCount;
  end;
 finally
  fm.Free;
 end;
end;

function TfmRBSync_Connection.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then exit;

    isFindName:=Trim(FindName)<>'';

    if isFindName then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindName then begin
        addstr1:=' Upper(display_name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindName+'%'))+' ';
     end;

     Result:=wherestr+addstr1;
end;


end.


