unit URBInterface;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, grids, menus, DBTables, Tabs,
  tsvDbGrid, IBUpdateSQL;

type
   TfmRBInterface = class(TfmRBMainGrid)
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

    isFindName,isFindHint,isFindTypeInterface: Boolean;
    FindName,FindHint: string;
    FindTypeInterface: Integer;
    procedure GridDrawColumnCell(Sender: TObject; const Rect: TRect;
                                 DataCol: Integer; Column: TColumn; State: TGridDrawState);

  protected
    procedure GridDblClick(Sender: TObject); override;
    procedure SaveToIni;override;
    procedure LoadFromIni; override;
    function GetFilterString: string; override;
    procedure GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort); override;
    function GetSql: string; override;
  public
    procedure ActiveQuery(CheckPerm: Boolean);override;
    procedure SetParamsFromOptions(Index: Integer);
  end;

var
  fmRBInterface: TfmRBInterface;

  function GetTypeInterfaceByIndex(Index: Integer): String;

implementation

uses UMainUnited, UDesignTsvCode, UDesignTsvDM, UDesignTsvData, UEditRBInterface,
     tsvPicture;

{$R *.DFM}

function GetTypeInterfaceByIndex(Index: Integer): String;
begin
  Result:='';
  case TTypeInterface(Index) of
    ttiNone: Result:='Неизвестно';
    ttiRBook: Result:='Справочник';
    ttiReport: Result:='Отчет';
    ttiWizard: Result:='Мастер';
    ttiJournal: Result:='Журнал';
    ttiService: Result:='Сервис';
    ttiDocument: Result:='Документ';
    ttiHelp: Result:='Помощь';
  end;
end;

procedure TfmRBInterface.FormCreate(Sender: TObject);
var
  cl,clSort: TColumn;
  ifl: TIntegerField;
  sfl: TStringField;
  gfl: TGuidField;
begin
 inherited;
 try
  Caption:=NameRbkInterface;
  Mainqr.Database:=IBDB;

  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  FindTypeInterface:=-1;

  ifl:=TIntegerField.Create(nil);
  ifl.FieldName:='interface_id';
  ifl.Visible:=false;
  ifl.DataSet:=Mainqr;

  sfl:=TStringField.Create(nil);
  sfl.FieldName:='name';
  sfl.Size:=250;
  sfl.DataSet:=Mainqr;

  cl:=Grid.Columns.Add;
  cl.Field:=sfl;
  cl.Title.Caption:='Наименование';
  cl.Width:=150;
  clSort:=cl;

  sfl:=TStringField.Create(nil);
  sfl.FieldName:='hint';
  sfl.Size:=255;
  sfl.DataSet:=Mainqr;

  cl:=Grid.Columns.Add;
  cl.Field:=sfl;
  cl.Title.Caption:='Описание';
  cl.Width:=150;

  ifl:=TIntegerField.Create(nil);
  ifl.FieldName:='interfacetype';
  ifl.Visible:=false;
  ifl.DataSet:=Mainqr;

  sfl:=TStringField.Create(nil);
  sfl.FieldName:='interfacetypeplus';
  sfl.FieldKind:=fkCalculated;
  sfl.DataSet:=Mainqr;

  cl:=Grid.Columns.Add;
  cl.Field:=sfl;
  cl.Title.Caption:='Тип интерфейса';
  cl.Width:=100;

  ifl:=TIntegerField.Create(nil);
  ifl.FieldName:='changeflag';
  ifl.Visible:=false;
  ifl.DataSet:=Mainqr;

  cl:=Grid.Columns.Add;
  cl.FieldName:='changeflagplus';
  cl.Title.Caption:='Замена';
  cl.Width:=60;

  ifl:=TIntegerField.Create(nil);
  ifl.FieldName:='autoflag';
  ifl.Visible:=false;
  ifl.DataSet:=Mainqr;

  cl:=Grid.Columns.Add;
  cl.FieldName:='autoflagplus';
  cl.Title.Caption:='Автозапуск';
  cl.Width:=60;
  
  ifl:=TIntegerField.Create(nil);
  ifl.FieldName:='priority';
  ifl.Visible:=false;
  ifl.DataSet:=Mainqr;

  cl:=Grid.Columns.Add;
  cl.Field:=ifl;
  cl.Title.Caption:='Приоритет запуска';
  cl.Width:=60;

  gfl:=TGuidField.Create(nil);
  gfl.FieldName:='interpreterguid';
  gfl.Visible:=false;
  gfl.DataSet:=Mainqr;

  DefaultOrders.Add('Наименование','name');
  Grid.ColumnSort:=clSort;

  Grid.OnDrawColumnCell:=GridDrawColumnCell;
  
  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBInterface.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  inherited;
  for i:=0 to ListEditInterfaceForms.Count-1 do
    TfmEditRBInterface(ListEditInterfaceForms.Items[i]).fmParent:=nil;
  if FormState=[fsCreatedMDIChild] then
   fmRBInterface:=nil;
end;

function TfmRBInterface.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkInterface+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBInterface.ActiveQuery(CheckPerm: Boolean);
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
   SetImageFilter(isFindName or isFindHint or isFindTypeInterface);
   ViewCount;
  finally
   Mainqr.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBInterface.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   if AnsiUpperCase(fn)=AnsiUpperCase('changeflagplus') then fn:='changeflag';
   if AnsiUpperCase(fn)=AnsiUpperCase('autoflagplus') then fn:='autoflag';
   if AnsiUpperCase(fn)=AnsiUpperCase('interfacetypeplus') then fn:='interfacetype';

   id:=MainQr.fieldByName('interface_id').asString;
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('interface_id',id,[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBInterface.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBInterface.LoadFromIni;
begin
 inherited;
 try
    FindName:=ReadParam(ClassName,'Name',FindName);
    FindHint:=ReadParam(ClassName,'Hint',FindHint);
    FindTypeInterface:=ReadParam(ClassName,'TypeInterface',FindTypeInterface);
    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBInterface.SaveToIni;
begin
 inherited;
 try
    WriteParam(ClassName,'Name',FindName);
    WriteParam(ClassName,'Hint',FindHint);
    WriteParam(ClassName,'TypeInterface',FindTypeInterface);
    WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBInterface.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBInterface.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBInterface;
begin
  if not Mainqr.Active then exit;
  fm:=TfmEditRBInterface.Create(nil);
  fm.fmParent:=Self;
  fm.pcMain.Align:=alClient;
  fm.TypeEditRBook:=terbAdd;
  fm.ChangeFlag:=false;
  fm.LoadFromIni;
  fm.FormStyle:=fsMDIChild;
end;

procedure TfmRBInterface.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBInterface;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBInterface.Create(nil);
  fm.fmParent:=Self;
  fm.edName.Text:=Mainqr.fieldByName('name').AsString;
  fm.InterfaceName:=fm.edName.Text;
  fm.meHint.Lines.Text:=Mainqr.fieldByName('hint').AsString;
  fm.cmbTypeInterface.ItemIndex:=Mainqr.fieldByName('interfacetype').AsInteger;
  fm.cmbTypeInterfaceChange(fm.cmbTypeInterface);
  fm.chbChangeFlag.Checked:=Boolean(Mainqr.fieldByName('changeflag').AsInteger);
  fm.chbAutoRun.Checked:=Boolean(Mainqr.fieldByName('autoflag').AsInteger);
  fm.cmbInterpreter.ItemIndex:=fm.GetInterpreterItemIndexByGuid(Mainqr.fieldByName('interpreterguid').Value);
  fm.udPriority.Position:=Mainqr.fieldByName('priority').AsInteger;
  fm.oldInterface_id:=MainQr.FieldByName('interface_id').AsInteger;
  fm.pcMain.Align:=alClient;
  fm.TypeEditRBook:=terbChange;
  fm.LoadFromIni;
  fm.Caption:=Format('%s интерфейс <%s>',[CaptionChange,fm.InterfaceName]);
  fm.ChangeFlag:=false;
  fm.NotChangeLoaded:=true;
  fm.FormStyle:=fsMDIChild;
end;

procedure TfmRBInterface.bibDelClick(Sender: TObject);
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
     sqls:='Delete from '+tbInterface+' where interface_id='+
          Mainqr.FieldByName('interface_id').asString;
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
  but:=DeleteWarningEx('интерфейс <'+Mainqr.FieldByName('name').AsString+'> ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBInterface.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBInterface;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBInterface.Create(nil);
  fm.fmParent:=Self;
  fm.edName.Text:=Mainqr.fieldByName('name').AsString;
  fm.InterfaceName:=fm.edName.Text;
  fm.meHint.Lines.Text:=Mainqr.fieldByName('hint').AsString;
  fm.cmbTypeInterface.ItemIndex:=Mainqr.fieldByName('interfacetype').AsInteger;
  fm.cmbTypeInterfaceChange(fm.cmbTypeInterface);
  fm.chbChangeFlag.Checked:=Boolean(Mainqr.fieldByName('changeflag').AsInteger);
  fm.chbAutoRun.Checked:=Boolean(Mainqr.fieldByName('autoflag').AsInteger);
  fm.cmbInterpreter.ItemIndex:=fm.GetInterpreterItemIndexByGuid(Mainqr.fieldByName('interpreterguid').Value);
  fm.udPriority.Position:=Mainqr.fieldByName('priority').AsInteger;
  fm.oldInterface_id:=MainQr.FieldByName('interface_id').AsInteger;
  fm.pcMain.Align:=alClient;
  fm.tbsScript.TabVisible:=false;
  fm.tbsForms.TabVisible:=false;
  fm.tbsDocs.TabVisible:=false;
  fm.TypeEditRBook:=terbView;
  fm.LoadFromIni;
  fm.Caption:=Format('%s интерфейс <%s>',[CaptionChange,fm.InterfaceName]);
  fm.ChangeFlag:=false;
  fm.NotChangeLoaded:=true;
  fm.FormStyle:=fsMDIChild;
end;

procedure TfmRBInterface.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBInterface;
  filstr: string;
begin
 fm:=TfmEditRBInterface.Create(nil);
 try
  fm.tbsScript.TabVisible:=false;
  fm.tbsForms.TabVisible:=false;
  fm.tbsDocs.TabVisible:=false;

  fm.BorderStyle:=bsDialog;


  fm.chbChangeFlag.Enabled:=false;
  fm.chbAutoRun.Enabled:=false;

  fm.cmbTypeInterface.ItemIndex:=-1;

  fm.cmbInterpreter.ItemIndex:=-1;
  fm.cmbInterpreter.Enabled:=false;
  fm.cmbInterpreter.Color:=clBtnFace;
  fm.lbInterpreter.Enabled:=false;

  fm.edPriority.ReadOnly:=true;
  fm.edPriority.Color:=clBtnFace;
  fm.edPriority.Enabled:=false;
  fm.edPriority.Text:='';
  fm.lbPriority.Enabled:=false;
  fm.udPriority.Enabled:=false;

  if Trim(FindName)<>'' then fm.edName.Text:=FindName;
  if Trim(FindHint)<>'' then fm.meHint.Lines.Text:=FindHint;
  fm.cmbTypeInterface.ItemIndex:=FindTypeInterface;

  fm.cbInString.Visible:=true;
  fm.bibClear.Visible:=true;
  fm.cbInString.Checked:=FilterInSide;

  fm.TypeEditRBook:=terbFilter;
  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    inherited;
    FindName:=fm.edName.Text;
    FindHint:=fm.meHint.Lines.Text;
    FindTypeInterface:=fm.cmbTypeInterface.Items.IndexOf(fm.cmbTypeInterface.Text);
   
    FilterInSide:=fm.cbInString.Checked;
    if FilterInSide then filstr:='%';

    ActiveQuery(false);
    ViewCount;
  end;
 finally
  fm.Free;
 end;
end;

function TfmRBInterface.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2,addstr3: string;
  and1,and2: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then exit;

    isFindName:=Trim(FindName)<>'';
    isFindHint:=Trim(FindHint)<>'';
    isFindTypeInterface:=FindTypeInterface<>-1;

    if isFindName or isFindHint or isFindTypeInterface then
    begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindName then begin
        addstr1:=' Upper(name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindName+'%'))+' ';
     end;

     if isFindHint then begin
        addstr2:=' Upper(hint) like '+AnsiUpperCase(QuotedStr(FilInSide+FindHint+'%'))+' ';
     end;

     if isFindTypeInterface then begin
        addstr3:=' interfacetype='+inttostr(FindTypeInterface)+' ';
     end;

     if (isFindName and isFindHint) or
        (isFindName and isFindTypeInterface)
        then and1:=' and ';

     if (isFindHint and isFindTypeInterface)
        then and2:=' and ';

     Result:=wherestr+addstr1+and1+addstr2
                             +and2+addstr3;
end;

procedure TfmRBInterface.SetParamsFromOptions(Index: Integer);
var
  i: Integer;
begin
  for i:=0 to ListEditInterfaceForms.Count-1 do begin
    TfmEditRBInterface(ListEditInterfaceForms.Items[i]).SetParamsFromOptions(Index);
  end;
end;

procedure TfmRBInterface.MainqrCalcFields(DataSet: TDataSet);
begin
  DataSet['interfacetypeplus']:=GetTypeInterfaceByIndex(DataSet.fieldbyName('interfacetype').AsInteger);
end;

procedure TfmRBInterface.GridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  rt: TRect;
  chk: Boolean;
begin
  if not Mainqr.Active then exit;
  if Mainqr.isEmpty then exit;
  rt.Right:=rect.Right;
  rt.Left:=rect.Left;
  rt.Top:=rect.Top+2;
  rt.Bottom:=rect.Bottom-2;
  if Column.Title.Caption='Замена' then begin
    chk:=Boolean(Mainqr.FieldByName('changeflag').AsInteger);
    if not chk then Begin
     DrawFrameControl(Grid.Canvas.Handle,Rt,DFC_BUTTON,DFCS_BUTTONCHECK);
    end else begin
     DrawFrameControl(Grid.Canvas.Handle,Rt,DFC_BUTTON,DFCS_CHECKED);
    end;
  end;
  if Column.Title.Caption='Автозапуск' then begin
    chk:=Boolean(Mainqr.FieldByName('autoflag').AsInteger);
    if not chk then Begin
     DrawFrameControl(Grid.Canvas.Handle,Rt,DFC_BUTTON,DFCS_BUTTONCHECK);
    end else begin
     DrawFrameControl(Grid.Canvas.Handle,Rt,DFC_BUTTON,DFCS_CHECKED);
    end;
  end;
end;

end.
