unit URBBasisTypeDoc;

interface

{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, Menus, tsvDbGrid, IBUpdateSQL;

type
   TfmRBBasisTypeDoc = class(TfmRBMainGrid)
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
  private
    isFindFor,isFindWhat: Boolean;
    FindFor,FindWhat: String;
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
  fmRBBasisTypeDoc: TfmRBBasisTypeDoc;

implementation

uses UMainUnited, UDocTurnTsvCode, UDocTurnTsvDM, UDocTurnTsvData, UEditRBBasisTypeDoc;

{$R *.DFM}

procedure TfmRBBasisTypeDoc.FormCreate(Sender: TObject);
var
 cl: TColumn;
begin
 inherited;
 try
  Caption:=NameRbkBasisTypeDoc;

  Mainqr.Database:=IBDB;

  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  cl:=Grid.Columns.Add;
  cl.FieldName:='fortypedocname';
  cl.Title.Caption:='Основание для';
  cl.Width:=180;

  cl:=Grid.Columns.Add;
  cl.FieldName:='whattypedocname';
  cl.Title.Caption:='Который является';
  cl.Width:=180;
  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end; 
end;

procedure TfmRBBasisTypeDoc.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBBasisTypeDoc:=nil;
end;

function TfmRBBasisTypeDoc.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkBasisTypeDoc+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBBasisTypeDoc.ActiveQuery(CheckPerm: Boolean);
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
   SetImageFilter(isFindFor or isFindWhat);
   ViewCount;
  finally
   Mainqr.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBBasisTypeDoc.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id1,id2: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   if UpperCase(fn)=UpperCase('fortypedocname') then fn:='td1.name';
   if UpperCase(fn)=UpperCase('whattypedocname') then fn:='td2.name';
   id2:=MainQr.fieldByName('fortypedoc_id').asString;
   id1:=MainQr.fieldByName('whattypedoc_id').asString;
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('fortypedoc_id;whattypedoc_id',VarArrayOf([id1,id2]),[LocaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBBasisTypeDoc.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBBasisTypeDoc.LoadFromIni;
begin
 inherited;
 try
    FindFor:=ReadParam(ClassName,'For',FindFor);
    FindWhat:=ReadParam(ClassName,'What',FindWhat);
    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBBasisTypeDoc.SaveToIni;
begin
 Inherited;
 try
    WriteParam(ClassName,'For',FindFor);
    WriteParam(ClassName,'What',FindWhat);
    WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBBasisTypeDoc.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBBasisTypeDoc.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBBasisTypeDoc;
begin
 try
  if not Mainqr.Active then exit;
  fm:=TfmEditRBBasisTypeDoc.Create(nil);
  try
    fm.fmParent:=Self;
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ViewCount;
     MainQr.Locate('fortypedoc_id;whattypedoc_id',VarArrayOf([fm.fortypedoc_id,fm.whattypedoc_id]),[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBBasisTypeDoc.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBBasisTypeDoc;
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  fm:=TfmEditRBBasisTypeDoc.Create(nil);
  try
    fm.fmParent:=Self;
    fm.edFor.Text:=Mainqr.fieldByName('fortypedocname').AsString;
    fm.fortypedoc_id:=Mainqr.fieldByName('fortypedoc_id').AsInteger;
    fm.oldfortypedoc_id:=fm.fortypedoc_id;
    fm.edWhat.Text:=Mainqr.fieldByName('whattypedocname').AsString;
    fm.whattypedoc_id:=Mainqr.fieldByName('whattypedoc_id').AsInteger;
    fm.oldwhattypedoc_id:=fm.whattypedoc_id;
    fm.TypeEditRBook:=terbChange;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     MainQr.Locate('fortypedoc_id;whattypedoc_id',VarArrayOf([fm.fortypedoc_id,fm.whattypedoc_id]),[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBBasisTypeDoc.bibDelClick(Sender: TObject);
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
     sqls:='Delete from '+tbBasisTypeDoc+' where fortypedoc_id='+
          Mainqr.FieldByName('fortypedoc_id').AsString+' and whattypedoc_id='+
          Mainqr.FieldByName('whattypedoc_id').AsString;
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
  but:=DeleteWarningEx('основание для <'+Mainqr.FieldByName('fortypedocname').AsString+'> ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBBasisTypeDoc.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBBasisTypeDoc;
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  fm:=TfmEditRBBasisTypeDoc.Create(nil);
  try
    fm.TypeEditRBook:=terbView;
    fm.edFor.Text:=Mainqr.fieldByName('fortypedocname').AsString;
    fm.fortypedoc_id:=Mainqr.fieldByName('fortypedoc_id').AsInteger;
    fm.oldfortypedoc_id:=fm.fortypedoc_id;
    fm.edWhat.Text:=Mainqr.fieldByName('whattypedocname').AsString;
    fm.whattypedoc_id:=Mainqr.fieldByName('whattypedoc_id').AsInteger;
    fm.oldwhattypedoc_id:=fm.whattypedoc_id;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBBasisTypeDoc.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBBasisTypeDoc;
  filstr: string;
begin
 fm:=TfmEditRBBasisTypeDoc.Create(nil);
 try
  fm.TypeEditRBook:=terbFilter;

  fm.edWhat.Color:=clWindow;
  fm.edWhat.ReadOnly:=false;
  fm.edFor.Color:=clWindow;
  fm.edFor.ReadOnly:=false;

  if Trim(FindWhat)<>'' then fm.edWhat.Text:=FindWhat;
  if Trim(FindFor)<>'' then fm.edFor.Text:=FindFor;

  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    inherited;

    FindWhat:=Trim(fm.edWhat.Text);
    FindFor:=Trim(fm.edFor.Text);

    FilterInSide:=fm.cbInString.Checked;
    if FilterInSide then filstr:='%';

    ActiveQuery(false);
    ViewCount;
  end;        
 finally
  fm.Free;
 end;
end;

function TfmRBBasisTypeDoc.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2: string;
  and1: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then exit;

    isFindWhat:=Trim(FindWhat)<>'';
    isFindFor:=Trim(FindFor)<>'';

    if isFindWhat or isFindFor then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindWhat then begin
        addstr1:=' Upper(td2.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindWhat+'%'))+' ';
     end;

     if isFindFor then begin
        addstr2:=' Upper(td1.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindFor+'%'))+' ';
     end;

     if (isFindWhat and isFindFor)
       then and1:=' and ';

     Result:=wherestr+addstr1+and1+addstr2;
end;


end.
