unit URBInterfacePermission;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, Menus , tsvDbGrid, IBUpdateSQL,
  UMainUnited;

type
   TfmRBInterfacePermission = class(TfmRBMainGrid)
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
    isFindInterfaceName,isFindAction,isFindObject,isFindPermission: Boolean;
    FindInterfaceName,FindObject: String;
    FindAction,FindPermission: Integer;
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
  fmRBInterfacePermission: TfmRBInterfacePermission;

  function GetInterfaceActionByValue(TypeInterfaceAction: TTypeInterfaceAction): String;
  function GetDbPermissionByValue(TypeDbPermission: TTypeDbPermission): String;

implementation

uses UDesignTsvCode, UDesignTsvDM, UDesignTsvData, UEditRBInterfacePermission;

{$R *.DFM}

function GetInterfaceActionByValue(TypeInterfaceAction: TTypeInterfaceAction): String;
begin
  Result:='';
  case TypeInterfaceAction of
    ttiaView: Result:='Отображение';
    ttiaAdd: Result:='Добавление';
    ttiaChange: Result:='Изменение';
    ttiaDelete: Result:='Удаление';
  end;
end;

function GetDbPermissionByValue(TypeDbPermission: TTypeDbPermission): String;
begin
  Result:='';
  case TypeDbPermission of
    ttpSelect: Result:='Выбор';
    ttpInsert: Result:='Вставка';
    ttpUpdate: Result:='Изменение';
    ttpDelete: Result:='Удаление';
    ttpExecute: Result:='Запуск';
  end;
end;

procedure TfmRBInterfacePermission.FormCreate(Sender: TObject);
var
  cl: TColumn;
  ifl: TIntegerField;
  sfl: TStringField;
begin
 inherited;
 try
  Caption:=NameRbkInterfacePermission;

  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  ifl:=TIntegerField.Create(nil);
  ifl.FieldName:='interfacepermission_id';
  ifl.Visible:=false;
  ifl.DataSet:=Mainqr;

  ifl:=TIntegerField.Create(nil);
  ifl.FieldName:='interface_id';
  ifl.Visible:=false;
  ifl.DataSet:=Mainqr;

  sfl:=TStringField.Create(nil);
  sfl.FieldName:='interfacename';
  sfl.DataSet:=Mainqr;
  sfl.Size:=DomainNameLength;

  cl:=Grid.Columns.Add;
  cl.FieldName:='interfacename';
  cl.Title.Caption:='Интрфейс';
  cl.Width:=150;

  ifl:=TIntegerField.Create(nil);
  ifl.FieldName:='interfaceaction';
  ifl.Visible:=false;
  ifl.DataSet:=Mainqr;

  sfl:=TStringField.Create(nil);
  sfl.FieldName:='interfaceactionplus';
  sfl.FieldKind:=fkCalculated;
  sfl.DataSet:=Mainqr;
  sfl.Size:=DomainSmallNameLength;

  cl:=Grid.Columns.Add;
  cl.Field:=sfl;
  cl.Title.Caption:='Действие интерфейса';
  cl.Width:=100;
  
  sfl:=TStringField.Create(nil);
  sfl.FieldName:='dbobject';
  sfl.DataSet:=Mainqr;
  sfl.Size:=DomainDBObjectName;

  cl:=Grid.Columns.Add;
  cl.Field:=sfl;
  cl.Title.Caption:='Объект базы данных';
  cl.Width:=150;

  ifl:=TIntegerField.Create(nil);
  ifl.FieldName:='permission';
  ifl.Visible:=false;
  ifl.DataSet:=Mainqr;

  sfl:=TStringField.Create(nil);
  sfl.FieldName:='permissionplus';
  sfl.FieldKind:=fkCalculated;
  sfl.DataSet:=Mainqr;
  sfl.Size:=DomainSmallNameLength;

  cl:=Grid.Columns.Add;
  cl.Field:=sfl;
  cl.Title.Caption:='Право';
  cl.Width:=100;

  FindAction:=-1;
  FindPermission:=-1;

  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBInterfacePermission.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBInterfacePermission:=nil;
end;

function TfmRBInterfacePermission.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkInterfacePermission+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBInterfacePermission.ActiveQuery(CheckPerm: Boolean);
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
   SetImageFilter(isFindInterfaceName or isFindAction or isFindObject or isFindPermission);
   ViewCount;
  finally
   Mainqr.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBInterfacePermission.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   if AnsiUpperCase(fn)=AnsiUpperCase('interfaceactionplus') then fn:='interfaceaction';
   if AnsiUpperCase(fn)=AnsiUpperCase('permissionplus') then fn:='permission';
   if AnsiUpperCase(fn)=AnsiUpperCase('interfacename') then fn:='i.name';
   id:=MainQr.fieldByName('interfacepermission_id').asString;
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('interfacepermission_id',id,[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBInterfacePermission.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBInterfacePermission.LoadFromIni;
begin
 inherited;
 try
    FindInterfaceName:=ReadParam(ClassName,'InterfaceName',FindInterfaceName);
    FindObject:=ReadParam(ClassName,'Object',FindObject);
    FindAction:=ReadParam(ClassName,'Action',FindAction);
    FindPermission:=ReadParam(ClassName,'Permission',FindPermission);
    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBInterfacePermission.SaveToIni;
begin
 inherited;
 try
    WriteParam(ClassName,'InterfaceName',FindInterfaceName);
    WriteParam(ClassName,'Object',FindObject);
    WriteParam(ClassName,'Action',FindAction);
    WriteParam(ClassName,'Permission',FindPermission);
    WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBInterfacePermission.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBInterfacePermission.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBInterfacePermission;
begin
  if not Mainqr.Active then exit;
  fm:=TfmEditRBInterfacePermission.Create(nil);
  try
    fm.fmParent:=Self;
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ViewCount;
     MainQr.Locate('interfacepermission_id',fm.oldinterfacepermission_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBInterfacePermission.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBInterfacePermission;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBInterfacePermission.Create(nil);
  try
    fm.fmParent:=Self;
    fm.TypeEditRBook:=terbChange;

    fm.edInterface.Text:=Mainqr.fieldByName('interfacename').AsString;
    fm.interface_id:=Mainqr.fieldByName('interface_id').AsInteger;
    fm.cmbInterfaceAction.ItemIndex:=Mainqr.fieldByName('interfaceaction').AsInteger;
    fm.edObject.Text:=Mainqr.fieldByName('dbobject').AsString;
    fm.cmbPermission.ItemIndex:=Mainqr.fieldByName('permission').AsInteger;
    fm.oldinterfacepermission_id:=Mainqr.fieldByName('interfacepermission_id').AsInteger;

    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     MainQr.Locate('interfacepermission_id',fm.oldinterfacepermission_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBInterfacePermission.bibDelClick(Sender: TObject);
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
     sqls:='Delete from '+tbInterfacePermission+' where interfacepermission_id='+
          Mainqr.FieldByName('interfacepermission_id').asString;
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
  but:=DeleteWarningEx('право <'+Mainqr.FieldByName('permissionplus').AsString+'> у '+
                       'интерфейса <'+Mainqr.FieldByName('interfacename').AsString+'> на '+
                       'объект <'+Mainqr.FieldByName('dbobject').AsString+'>?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBInterfacePermission.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBInterfacePermission;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBInterfacePermission.Create(nil);
  try
    fm.TypeEditRBook:=terbView;
    fm.edInterface.Text:=Mainqr.fieldByName('interfacename').AsString;
    fm.interface_id:=Mainqr.fieldByName('interface_id').AsInteger;
    fm.cmbInterfaceAction.ItemIndex:=Mainqr.fieldByName('interfaceaction').AsInteger;
    fm.edObject.Text:=Mainqr.fieldByName('dbobject').AsString;
    fm.cmbPermission.ItemIndex:=Mainqr.fieldByName('permission').AsInteger;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBInterfacePermission.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBInterfacePermission;
  filstr: string;
begin
 fm:=TfmEditRBInterfacePermission.Create(nil);
 try
  fm.TypeEditRBook:=terbFilter;

  fm.edInterface.Color:=clWindow;
  fm.edInterface.ReadOnly:=false;
  fm.cmbInterfaceAction.Style:=csDropDown;
  fm.cmbInterfaceAction.ItemIndex:=-1;
  fm.edObject.Color:=clWindow;
  fm.edObject.ReadOnly:=false;
  fm.cmbPermission.Style:=csDropDown;
  fm.cmbPermission.ItemIndex:=-1;
  
  if Trim(FindInterfaceName)<>'' then fm.edInterface.Text:=FindInterfaceName;
  if Trim(FindObject)<>'' then fm.edObject.Text:=FindObject;
  fm.cmbInterfaceAction.ItemIndex:=FindAction;
  fm.cmbPermission.ItemIndex:=FindPermission;

  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    inherited;

    FindInterfaceName:=Trim(fm.edInterface.Text);
    FindObject:=Trim(fm.edObject.Text);
    FindAction:=fm.cmbInterfaceAction.Items.IndexOf(fm.cmbInterfaceAction.Text);
    FindPermission:=fm.cmbPermission.Items.IndexOf(fm.cmbPermission.Text);

    FilterInSide:=fm.cbInString.Checked;
    if FilterInSide then filstr:='%';

    ActiveQuery(false);
    ViewCount;
  end;
 finally
  fm.Free;
 end;
end;

function TfmRBInterfacePermission.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2,addstr3,addstr4: string;
  and1,and2,and3: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then exit;

    isFindInterfaceName:=Trim(FindInterfaceName)<>'';
    isFindObject:=Trim(FindObject)<>'';
    isFindAction:=FindAction<>-1;
    isFindPermission:=FindPermission<>-1;

    if isFindInterfaceName or isFindObject or isFindAction or isFindPermission then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindInterfaceName then begin
        addstr1:=' Upper(i.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindInterfaceName+'%'))+' ';
     end;

     if isFindObject then begin
        addstr2:=' Upper(dbobject) like '+AnsiUpperCase(QuotedStr(FilInSide+FindObject+'%'))+' ';
     end;

     if isFindAction then begin
        addstr3:=' interfaceaction='+inttostr(FindAction)+' ';
     end;

     if isFindPermission then begin
        addstr4:=' permission='+inttostr(FindPermission)+' ';
     end;

     if (isFindInterfaceName and isFindObject)or
        (isFindInterfaceName and isFindAction)or
        (isFindInterfaceName and isFindPermission) then
      and1:=' and ';

     if (isFindObject and isFindAction)or
        (isFindObject and isFindPermission) then
      and2:=' and ';

     if (isFindAction and isFindPermission) then
      and3:=' and ';

     Result:=wherestr+addstr1+and1+
                      addstr2+and2+
                      addstr3+and3+
                      addstr4;
end;

procedure TfmRBInterfacePermission.MainqrCalcFields(DataSet: TDataSet);
begin
  DataSet['interfaceactionplus']:=GetInterfaceActionByValue(TTypeInterfaceAction(DataSet.fieldbyName('interfaceaction').AsInteger));
  DataSet['permissionplus']:=GetDbPermissionByValue(TTypeDbPermission(DataSet.fieldbyName('permission').AsInteger)); 
end;

end.
