unit URBAlgorithm;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, Menus, tsvDbGrid, IBUpdateSQL;

type
   TfmRBAlgorithm = class(TfmRBMainGrid)
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
  fmRBAlgorithm: TfmRBAlgorithm;

implementation

uses UMainUnited, USalaryTsvCode, USalaryTsvDM, USalaryTsvData, UEditRBAlgorithm;

{$R *.DFM}

procedure TfmRBAlgorithm.FormCreate(Sender: TObject);
var
  cl: TColumn;
begin
 inherited;
 try
  Caption:=NameRbkAlgorithm;
  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  cl:=Grid.Columns.Add;
  cl.FieldName:='name';
  cl.Title.Caption:='Наименование';
  cl.Width:=250;
  
  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBAlgorithm.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBAlgorithm:=nil;
end;

function TfmRBAlgorithm.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkAlgorithm+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBAlgorithm.ActiveQuery(CheckPerm: Boolean);
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
   Screen.Cursor:=crDefault;
   Mainqr.EnableControls;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBAlgorithm.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   if UpperCase(fn)='NAME' then fn:='al.name';
   id:=MainQr.fieldByName('algorithm_id').asString;
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('algorithm_id',id,[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBAlgorithm.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBAlgorithm.LoadFromIni;
begin
 inherited;
 try
    FindName:=ReadParam(ClassName,'name',FindName);
    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBAlgorithm.SaveToIni;
begin
 inherited;
 try
    WriteParam(ClassName,'name',FindName);
    WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBAlgorithm.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBAlgorithm.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBAlgorithm;
begin
  if not Mainqr.Active then exit;
  fm:=TfmEditRBAlgorithm.Create(nil);
  try
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('algorithm_id',fm.oldalgorithm_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBAlgorithm.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBAlgorithm;
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  fm:=TfmEditRBAlgorithm.Create(nil);
  try
    fm.TypeEditRBook:=terbChange;
    fm.edName.Text:=Mainqr.fieldByName('name').AsString;
    fm.oldalgorithm_id:=MainQr.FieldByName('algorithm_id').AsInteger;
    fm.cmbTypeFactor.ItemIndex:=MainQr.FieldByName('typefactorworktime').AsInteger;
    fm.ChangeTypeFactor;
    fm.cmbTypeBaseSumm.ItemIndex:=MainQr.FieldByName('typebaseamount').AsInteger;
    fm.ChangeBaseSumm;
    fm.cmbTypePercent.ItemIndex:=MainQr.FieldByName('typepercent').AsInteger;
    fm.ChangePercent;
    fm.cmbTypeMultiply.ItemIndex:=MainQr.FieldByName('typemultiply').AsInteger;
    fm.ChangeMultiply;
    fm.edbs_amountmonthsback.Text:=MainQr.FieldByName('bs_amountmonthsback').AsString;
    fm.udbs_amountmonthsback.Position:=MainQr.FieldByName('bs_amountmonthsback').AsInteger;
    fm.edbs_totalamountmonths.Text:=MainQr.FieldByName('bs_totalamountmonths').AsString;
    fm.udbs_totalamountmonths.Position:=MainQr.FieldByName('bs_totalamountmonths').AsInteger;
    fm.edbs_divideamountperiod.Text:=MainQr.FieldByName('bs_divideamountperiod').AsString;
    fm.udbs_divideamountperiod.Position:=MainQr.FieldByName('bs_divideamountperiod').AsInteger;
    fm.edbs_multiplyfactoraverage.Text:=MainQr.FieldByName('bs_multiplyfactoraverage').AsString;
    fm.edbs_salary.Text:=MainQr.FieldByName('bs_salary').AsString;
    fm.edbs_tariffrate.Text:=MainQr.FieldByName('bs_tariffrate').AsString;
    fm.edbs_averagemonthsbonus.Text:=MainQr.FieldByName('bs_averagemonthsbonus').AsString;
    fm.edbs_annualbonuses.Text:=MainQr.FieldByName('bs_annualbonuses').AsString;
    fm.edbs_minsalary.Text:=MainQr.FieldByName('bs_minsalary').AsString;
    fm.edkrv_typeratetime.Text:=MainQr.FieldByName('krv_typeratetime').AsString;
    fm.udkrv_typeratetime.Position:=MainQr.FieldByName('krv_typeratetime').AsInteger;
    fm.edkrv_amountmonthsback.Text:=MainQr.FieldByName('krv_amountmonthsback').AsString;
    fm.udkrv_amountmonthsback.Position:=MainQr.FieldByName('krv_amountmonthsback').AsInteger;
    fm.edkrv_totalamountmonths.Text:=MainQr.FieldByName('krv_totalamountmonths').AsString;
    fm.udkrv_totalamountmonths.Position:=MainQr.FieldByName('krv_totalamountmonths').AsInteger;
    fm.edu_besiderowtable.Text:=MainQr.FieldByName('abname').AsString;
    fm.absence_id:=MainQr.FieldByName('u_besiderowtable').AsInteger;
    fm.edp_percentadditionalcharge.Text:=MainQr.FieldByName('typepayname').AsString;
    fm.typepay_id:=MainQr.FieldByName('typepay_id').AsInteger;

    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('algorithm_id',fm.oldalgorithm_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBAlgorithm.bibDelClick(Sender: TObject);
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
     sqls:='Delete from '+tbAlgorithm+' where algorithm_id='+
          Mainqr.FieldByName('algorithm_id').asString;
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
  but:=DeleteWarningEx('алгоритм <'+Mainqr.FieldByName('name').AsString+'> ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBAlgorithm.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBAlgorithm;
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  fm:=TfmEditRBAlgorithm.Create(nil);
  try
    fm.TypeEditRBook:=terbView;
    fm.edName.Text:=Mainqr.fieldByName('name').AsString;
    fm.oldalgorithm_id:=MainQr.FieldByName('algorithm_id').AsInteger;
    fm.cmbTypeFactor.ItemIndex:=MainQr.FieldByName('typefactorworktime').AsInteger;
    fm.ChangeTypeFactor;
    fm.cmbTypeBaseSumm.ItemIndex:=MainQr.FieldByName('typebaseamount').AsInteger;
    fm.ChangeBaseSumm;
    fm.cmbTypePercent.ItemIndex:=MainQr.FieldByName('typepercent').AsInteger;
    fm.ChangePercent;
    fm.cmbTypeMultiply.ItemIndex:=MainQr.FieldByName('typemultiply').AsInteger;
    fm.ChangeMultiply;
    fm.edbs_amountmonthsback.Text:=MainQr.FieldByName('bs_amountmonthsback').AsString;
    fm.udbs_amountmonthsback.Position:=MainQr.FieldByName('bs_amountmonthsback').AsInteger;
    fm.edbs_totalamountmonths.Text:=MainQr.FieldByName('bs_totalamountmonths').AsString;
    fm.udbs_totalamountmonths.Position:=MainQr.FieldByName('bs_totalamountmonths').AsInteger;
    fm.edbs_divideamountperiod.Text:=MainQr.FieldByName('bs_divideamountperiod').AsString;
    fm.udbs_divideamountperiod.Position:=MainQr.FieldByName('bs_divideamountperiod').AsInteger;
    fm.edbs_multiplyfactoraverage.Text:=MainQr.FieldByName('bs_multiplyfactoraverage').AsString;
    fm.edbs_salary.Text:=MainQr.FieldByName('bs_salary').AsString;
    fm.edbs_tariffrate.Text:=MainQr.FieldByName('bs_tariffrate').AsString;
    fm.edbs_averagemonthsbonus.Text:=MainQr.FieldByName('bs_averagemonthsbonus').AsString;
    fm.edbs_annualbonuses.Text:=MainQr.FieldByName('bs_annualbonuses').AsString;
    fm.edbs_minsalary.Text:=MainQr.FieldByName('bs_minsalary').AsString;
    fm.edkrv_typeratetime.Text:=MainQr.FieldByName('krv_typeratetime').AsString;
    fm.udkrv_typeratetime.Position:=MainQr.FieldByName('krv_typeratetime').AsInteger;
    fm.edkrv_amountmonthsback.Text:=MainQr.FieldByName('krv_amountmonthsback').AsString;
    fm.udkrv_amountmonthsback.Position:=MainQr.FieldByName('krv_amountmonthsback').AsInteger;
    fm.edkrv_totalamountmonths.Text:=MainQr.FieldByName('krv_totalamountmonths').AsString;
    fm.udkrv_totalamountmonths.Position:=MainQr.FieldByName('krv_totalamountmonths').AsInteger;
    fm.edu_besiderowtable.Text:=MainQr.FieldByName('abname').AsString;
    fm.absence_id:=MainQr.FieldByName('u_besiderowtable').AsInteger;
    fm.edp_percentadditionalcharge.Text:=MainQr.FieldByName('typepayname').AsString;
    fm.typepay_id:=MainQr.FieldByName('typepay_id').AsInteger;

    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBAlgorithm.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBAlgorithm;
  filstr: string;
begin
 fm:=TfmEditRBAlgorithm.Create(nil);
 try
  fm.TypeEditRBook:=terbFilter;

  if Trim(FindName)<>'' then fm.edName.Text:=FindName;

  fm.cmbTypeFactor.Enabled:=false;
  fm.cmbTypeBaseSumm.Enabled:=false;
  fm.cmbTypePercent.Enabled:=false;
  fm.cmbTypeMultiply.Enabled:=false;
  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    inherited;

    FindName:=Trim(fm.edName.Text);

    FilterInSide:=fm.cbInString.Checked;
    if FilterInSide then filstr:='%';

    ActiveQuery(false);
    ViewCount;
  end;
 finally
  fm.Free;
 end;
end;

function TfmRBAlgorithm.GetFilterString: string;
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
        addstr1:=' Upper(al.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindName+'%'))+' ';
     end;

     Result:=wherestr+addstr1;
end;


end.
