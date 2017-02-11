unit URBTypeBordereau;

interface
{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, Menus, tsvDbGrid, IBUpdateSQL;

type
   TfmRBTypeBordereau = class(TfmRBMainGrid)
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
  private
    isFindName,isFindChargeName: Boolean;
    FindName,FindChargeName: String;
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
  fmRBTypeBordereau: TfmRBTypeBordereau;

implementation

uses UMainUnited, USalaryTsvCode, USalaryTsvDM, USalaryTsvData, UEditRBTypeBordereau;

{$R *.DFM}

procedure TfmRBTypeBordereau.FormCreate(Sender: TObject);
var
  cl: TColumn;
begin
 inherited;
 try
  Caption:=NameRbkTypeBordereau;
  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  cl:=Grid.Columns.Add;
  cl.FieldName:='name';
  cl.Title.Caption:='Наименование';
  cl.Width:=200;

  cl:=Grid.Columns.Add;
  cl.FieldName:='periodsback';
  cl.Title.Caption:='Сколько брать периодов назад';
  cl.Width:=100;

  cl:=Grid.Columns.Add;
  cl.FieldName:='percent';
  cl.Title.Caption:='Какой брать процент';
  cl.Width:=100;

  cl:=Grid.Columns.Add;
  cl.FieldName:='chargename';
  cl.Title.Caption:='Вид начесления - удержания';
  cl.Width:=150;
  
  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBTypeBordereau.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBTypeBordereau:=nil;
end;

function TfmRBTypeBordereau.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkTypeBordereau+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBTypeBordereau.ActiveQuery(CheckPerm: Boolean);
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
   SetImageFilter(isFindName or isFindChargeName);
   ViewCount;
  finally
   Mainqr.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBTypeBordereau.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   id:=MainQr.fieldByName('typebordereau_id').asString;
   if UpperCase(fn)=UpperCase('chargename') then fn:='ch.name';
   if UpperCase(fn)=UpperCase('name') then fn:='tb.name';
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('typebordereau_id',id,[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBTypeBordereau.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBTypeBordereau.LoadFromIni;
begin
 inherited;
 try
    FindName:=ReadParam(ClassName,'name',FindName);
    FindChargeName:=ReadParam(ClassName,'chargename',FindChargeName);
    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBTypeBordereau.SaveToIni;
begin
 inherited;
 try
    WriteParam(ClassName,'name',FindName);
    WriteParam(ClassName,'chargename',FindChargeName);
    WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBTypeBordereau.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBTypeBordereau.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBTypeBordereau;
begin
  if not Mainqr.Active then exit;
  fm:=TfmEditRBTypeBordereau.Create(nil);
  try
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('typebordereau_id',fm.oldtypebordereau_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure FillPeriods(lb: TListBox; typebordereau_id: Integer);
var
 sqls: string;
 qrnew: TIBQuery;
 tran: TIBTransaction;
begin
 try
  Screen.Cursor:=crHourGlass;
  qrnew:=TIBQuery.Create(nil);
  tran:=TIBTransaction.Create(nil);
  try
   qrnew.Database:=IBDB;
   tran.AddDatabase(IBDB);
   tran.Params.Text:=DefaultTransactionParamsTwo;
   IBDB.AddTransaction(tran);
   qrnew.Transaction:=tran;
   qrnew.Transaction.Active:=true;
   sqls:='Select tbcp.*,cp.name as calcperiodname from '+
         tbTypeBordereauCalcPeriod+' tbcp '+
         'join '+tbCalcPeriod+' cp on tbcp.calcperiod_id=cp.calcperiod_id '+
         'where tbcp.typebordereau_id='+inttostr(typebordereau_id);
   qrnew.SQL.Add(sqls);
   qrnew.Active:=true;
   qrnew.First;
   while not qrnew.Eof do begin
     lb.Items.AddObject(qrnew.FieldByName('calcperiodname').AsString,
                        TObject(Pointer(qrnew.FieldByName('calcperiod_id').AsInteger)));
     qrnew.Next;
   end;
  finally
   tran.free;
   qrnew.free;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBTypeBordereau.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBTypeBordereau;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBTypeBordereau.Create(nil);
  try
    fm.TypeEditRBook:=terbChange;
    fm.edName.Text:=Mainqr.fieldByName('name').AsString;
    fm.charge_id:=Mainqr.fieldByName('charge_id').AsInteger;
    fm.edChargeName.Text:=Mainqr.fieldByName('chargename').AsString;
    fm.oldtypebordereau_id:=MainQr.FieldByName('typebordereau_id').AsInteger;
    fm.udPeriodsBack.Position:=MainQr.FieldByName('periodsback').AsInteger;
    fm.edPercent.Text:=Mainqr.fieldByName('percent').AsString;
    FillPeriods(fm.lbPeriods,fm.oldtypebordereau_id);
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('typebordereau_id',fm.oldtypebordereau_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBTypeBordereau.bibDelClick(Sender: TObject);
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

 {    sqls:='Delete from '+tbTypeBordereauCalcPeriod+' where typebordereau_id='+
           Mainqr.FieldByName('typebordereau_id').asString;
     qr.sql.Add(sqls);
     qr.ExecSQL;

     qr.sql.Clear;}
     sqls:='Delete from '+tbTypeBordereau+' where typebordereau_id='+
           Mainqr.FieldByName('typebordereau_id').asString;
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
  but:=DeleteWarningEx('вид ведомости <'+Mainqr.FieldByName('name').AsString+'> ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBTypeBordereau.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBTypeBordereau;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBTypeBordereau.Create(nil);
  try
    fm.TypeEditRBook:=terbView;
    fm.edName.Text:=Mainqr.fieldByName('name').AsString;
    fm.charge_id:=Mainqr.fieldByName('charge_id').AsInteger;
    fm.edChargeName.Text:=Mainqr.fieldByName('chargename').AsString;
    fm.oldtypebordereau_id:=MainQr.FieldByName('typebordereau_id').AsInteger;
    fm.udPeriodsBack.Position:=MainQr.FieldByName('periodsback').AsInteger;
    fm.edPercent.Text:=Mainqr.fieldByName('percent').AsString;
    FillPeriods(fm.lbPeriods,fm.oldtypebordereau_id);
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBTypeBordereau.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBTypeBordereau;
  filstr: string;
begin
 fm:=TfmEditRBTypeBordereau.Create(nil);
 try
  fm.TypeEditRBook:=terbFilter;

  fm.edChargeName.ReadOnly:=false;
  fm.edChargeName.Color:=clWindow;
  fm.edChargeName.OnKeyPress:=nil;

  fm.lbPeriodsBack.Enabled:=false;
  fm.edPeriodsBack.Enabled:=false;
  fm.edPeriodsBack.Color:=clBtnFace;
  fm.udPeriodsBack.Enabled:=false;

  fm.lbPercent.Enabled:=false;
  fm.edPercent.Enabled:=false;
  fm.edPercent.Color:=clBtnFace;

  fm.grbPeriods.Enabled:=false;
  fm.lbperiods.Enabled:=false;
  fm.lbperiods.Color:=clBtnFace;
  fm.bibAddPeriod.Enabled:=false;
  fm.bibDelPeriod.Enabled:=false;


  if Trim(FindName)<>'' then fm.edName.Text:=FindName;
  if Trim(FindChargeName)<>'' then fm.edChargeName.Text:=FindChargeName;

  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    inherited;
    
    FindName:=Trim(fm.edName.Text);
    FindChargeName:=Trim(fm.edChargeName.Text);

    FilterInSide:=fm.cbInString.Checked;
    if FilterInSide then filstr:='%';

    ActiveQuery(false);
    ViewCount;
  end;
 finally
  fm.Free;
 end;
end;

function TfmRBTypeBordereau.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2: string;
  and1: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then exit;

    isFindName:=Trim(FindName)<>'';
    isFindChargeName:=Trim(FindChargeName)<>'';

    if isFindName or isFindChargeName then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindName then begin
        addstr1:=' Upper(tb.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindName+'%'))+' ';
     end;

     if isFindChargeName then begin
        addstr2:=' Upper(ch.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindChargeName+'%'))+' ';
     end;

     if isFindName and isFindChargeName then
      and1:=' and ';

     Result:=wherestr+addstr1+and1+addstr2;
end;


end.
