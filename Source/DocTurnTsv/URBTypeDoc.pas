unit URBTypeDoc;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, Menus , tsvDbGrid, IBUpdateSQL, grids;

type
   TfmRBTypeDoc = class(TfmRBMainGrid)
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
  private
    isFindName,isFindInterfaceName: Boolean;
    FindName,FindInterfaceName: String;
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
  end;

var
  fmRBTypeDoc: TfmRBTypeDoc;

implementation

uses UMainUnited, UDocTurnTsvCode, UDocTurnTsvDM, UDocTurnTsvData, UEditRBTypeDoc;

{$R *.DFM}

procedure TfmRBTypeDoc.FormCreate(Sender: TObject);
var
  cl: TColumn;
begin
 inherited;
 try
  Caption:=NameRbkTypeDoc;
  
  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);
  
  cl:=Grid.Columns.Add;
  cl.FieldName:='name';
  cl.Title.Caption:='Наименование';
  cl.Width:=150;
  
  cl:=Grid.Columns.Add;
  cl.FieldName:='interfacename';
  cl.Title.Caption:='Интерфейс';
  cl.Width:=150;

  cl:=Grid.Columns.Add;
  cl.FieldName:='signplus';
  cl.Title.Caption:='Это ссылка';
  cl.Width:=60;

  Grid.OnDrawColumnCell:=GridDrawColumnCell;

  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBTypeDoc.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBTypeDoc:=nil;
end;

function TfmRBTypeDoc.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkTypeDoc+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBTypeDoc.ActiveQuery(CheckPerm: Boolean);
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
   SetImageFilter(isFindName or isFindInterfaceName);
   ViewCount;
  finally
   Mainqr.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBTypeDoc.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   if AnsiUpperCase(fn)=AnsiUpperCase('signplus') then fn:='sign';
   id:=MainQr.fieldByName('typedoc_id').asString;
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('typedoc_id',id,[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBTypeDoc.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBTypeDoc.LoadFromIni;
begin
 inherited;
 try
    FindName:=ReadParam(ClassName,'name',FindName);
    FindInterfaceName:=ReadParam(ClassName,'interfacename',FindInterfaceName);
    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBTypeDoc.SaveToIni;
begin
 inherited;
 try
    WriteParam(ClassName,'name',FindName);
    WriteParam(ClassName,'interfacename',FindInterfaceName);
    WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBTypeDoc.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBTypeDoc.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBTypeDoc;
begin
  if not Mainqr.Active then exit;
  fm:=TfmEditRBTypeDoc.Create(nil);
  try
    fm.fmParent:=Self;
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ViewCount;
     MainQr.Locate('typedoc_id',fm.oldtypedoc_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBTypeDoc.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBTypeDoc;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBTypeDoc.Create(nil);
  try
    fm.fmParent:=Self;
    fm.chbSign.Checked:=Boolean(Mainqr.fieldByName('sign').AsInteger);
    fm.edName.Text:=Mainqr.fieldByName('name').AsString;
    fm.cmbInterfaceName.ItemIndex:=fm.cmbInterfaceName.Items.IndexOf(Mainqr.fieldByName('interfacename').AsString);
    fm.oldtypedoc_id:=MainQr.FieldByName('typedoc_id').AsInteger;
    fm.TypeEditRBook:=terbChange;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     MainQr.Locate('typedoc_id',fm.oldtypedoc_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBTypeDoc.bibDelClick(Sender: TObject);
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
     sqls:='Delete from '+tbTypeDoc+' where typedoc_id='+
          Mainqr.FieldByName('typedoc_id').AsString;
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
  but:=DeleteWarningEx('вид документа <'+Mainqr.FieldByName('name').AsString+'> ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBTypeDoc.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBTypeDoc;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBTypeDoc.Create(nil);
  try
    fm.TypeEditRBook:=terbView;
    fm.chbSign.Checked:=Boolean(Mainqr.fieldByName('sign').AsInteger);
    fm.edName.Text:=Mainqr.fieldByName('name').AsString;
    fm.cmbInterfaceName.ItemIndex:=fm.cmbInterfaceName.Items.IndexOf(Mainqr.fieldByName('interfacename').AsString);
    fm.oldtypedoc_id:=MainQr.FieldByName('typedoc_id').AsInteger;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBTypeDoc.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBTypeDoc;
  filstr: string;
begin
 fm:=TfmEditRBTypeDoc.Create(nil);
 try
  fm.TypeEditRBook:=terbFilter;

  fm.chbSign.Enabled:=false;
  fm.cmbInterfaceName.Style:=csDropDown;
  if Trim(FindName)<>'' then fm.edName.Text:=FindName;
  if Trim(FindInterfaceName)<>'' then fm.cmbInterfaceName.Text:=FindInterfaceName;

  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    inherited;

    FindName:=Trim(fm.edName.Text);
    FindInterfaceName:=Trim(fm.cmbInterfaceName.Text);

    FilterInSide:=fm.cbInString.Checked;
    if FilterInSide then filstr:='%';

    ActiveQuery(false);
    ViewCount;
  end;
 finally
  fm.Free;
 end;
end;

function TfmRBTypeDoc.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2: string;
  and1: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then exit;

    isFindName:=Trim(FindName)<>'';
    isFindInterfaceName:=Trim(FindInterfaceName)<>'';

    if isFindName or isFindInterfaceName then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindName then begin
        addstr1:=' Upper(name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindName+'%'))+' ';
     end;

     if isFindInterfaceName then begin
        addstr2:=' Upper(interfacename) like '+AnsiUpperCase(QuotedStr(FilInSide+FindInterfaceName+'%'))+' ';
     end;

     if (isFindName and isFindInterfaceName)then
      and1:=' and ';

     Result:=wherestr+addstr1+and1+
                      addstr2;
end;

procedure TfmRBTypeDoc.GridDrawColumnCell(Sender: TObject; const Rect: TRect;
                                          DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  rt: TRect;
  chk: Boolean;
begin
  if not MainQr.Active then exit;
  if MainQr.isEmpty then exit;
  rt:=Rect;
  rt.Top:=rect.Top+2;
  rt.Bottom:=rect.Bottom-2;
  if Column.Title.Caption='Это ссылка' then begin
    chk:=Boolean(MainQr.FieldByName('sign').AsInteger);
    if not chk then Begin
     DrawFrameControl(Grid.Canvas.Handle,Rt,DFC_BUTTON,DFCS_BUTTONCHECK);
    end else begin
     DrawFrameControl(Grid.Canvas.Handle,Rt,DFC_BUTTON,DFCS_CHECKED);
    end;
  end;
end;



end.
