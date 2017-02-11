unit URBAutoReplace;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, grids, Menus, tsvDbGrid, IBUpdateSQL;

type
   TfmRBAutoReplace = class(TfmRBMainGrid)
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
  private
    isFindWhat: Boolean;
    FindWhat: String;

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
  fmRBAutoReplace: TfmRBAutoReplace;

implementation

uses UMainUnited, UAncementCode, UAncementDM, UAncementData, UEditRBAutoReplace;

{$R *.DFM}

procedure TfmRBAutoReplace.FormCreate(Sender: TObject);
var
  cl: TColumn;
begin
 inherited;
 try
  Caption:=NameRbkAutoReplace;
  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  cl:=Grid.Columns.Add;
  cl.FieldName:='What';
  cl.Title.Caption:='Что заменять (HEX)';
  cl.Width:=150;

  cl:=Grid.Columns.Add;
  cl.FieldName:='On_what';
  cl.Title.Caption:='На что (HEX)';
  cl.Width:=150;

  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBAutoReplace.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBAutoReplace:=nil;
end;

function TfmRBAutoReplace.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkAutoReplace+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBAutoReplace.ActiveQuery(CheckPerm: Boolean);
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
   SetImageFilter(isFindWhat);
   ViewCount;
  finally
   Mainqr.EnableControls; 
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBAutoReplace.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   id:=MainQr.fieldByName('Auto_Replace_id').asString;
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('Auto_Replace_id',id,[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBAutoReplace.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBAutoReplace.LoadFromIni;
begin
 inherited;
 try
    FindWhat:=ReadParam(ClassName,'what',FindWhat);
    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBAutoReplace.SaveToIni;
begin
 inherited;
 try
    WriteParam(ClassName,'what',FindWhat);
    WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBAutoReplace.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBAutoReplace.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBAutoReplace;
begin
  if not Mainqr.Active then exit;
  fm:=TfmEditRBAutoReplace.Create(nil);
  try
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('auto_replace_id',fm.oldautoreplace_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBAutoReplace.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBAutoReplace;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBAutoReplace.Create(nil);
  try
    fm.oldAutoReplace_id:=Mainqr.fieldByName('Auto_Replace_id').AsInteger;
    fm.edWhat.Text:=Mainqr.fieldByName('What').AsString;
    fm.edOnWhat.Text:=Mainqr.fieldByName('on_What').AsString;
    fm.TypeEditRBook:=terbChange;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('Auto_Replace_id',fm.oldAutoReplace_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBAutoReplace.bibDelClick(Sender: TObject);
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
     sqls:='Delete from '+tbAutoReplace+' where Auto_Replace_id='+
          Mainqr.FieldByName('Auto_Replace_id').asString;
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
  but:=DeleteWarningEx('автозамену <'+Mainqr.FieldByName('What').AsString+'> ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBAutoReplace.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBAutoReplace;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBAutoReplace.Create(nil);
  try
    fm.TypeEditRBook:=terbView;
    fm.oldAutoReplace_id:=Mainqr.fieldByName('Auto_Replace_id').AsInteger;
    fm.edWhat.Text:=Mainqr.fieldByName('What').AsString;
    fm.edOnWhat.Text:=Mainqr.fieldByName('On_What').AsString;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBAutoReplace.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBAutoReplace;
  filstr: string;
begin
 fm:=TfmEditRBAutoReplace.Create(nil);
 try
  fm.TypeEditRBook:=terbFilter;
     
  fm.lbOnWhat.Enabled:=false;
  fm.edOnWhat.Enabled:=false;
  fm.edOnWhat.Color:=clBtnFace;

  if Trim(FindWhat)<>'' then fm.edWhat.Text:=FindWhat;

  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    Inherited;

    FindWhat:=Trim(fm.edWhat.Text);

    FilterInSide:=fm.cbInString.Checked;
    if FilterInSide then filstr:='%';

    ActiveQuery(false);
    ViewCount;
  end;
 finally
  fm.Free;
 end;
end;

function TfmRBAutoReplace.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then exit;

    isFindWhat:=Trim(FindWhat)<>'';

    if isFindWhat then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindWhat then begin
        addstr1:=' Upper(What) like '+AnsiUpperCase(QuotedStr(FilInSide+FindWhat+'%'))+' ';
     end;

     Result:=wherestr+addstr1;
end;


end.
