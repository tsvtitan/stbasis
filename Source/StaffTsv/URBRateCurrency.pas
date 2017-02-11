unit URBRateCurrency;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, Menus, tsvDbGrid, IBUpdateSQL;

type
   TfmRBRateCurrency = class(TfmRBMainGrid)
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
  private
    isFindCurrencyName: Boolean;
    FindCurrencyName: String;
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
  fmRBRateCurrency: TfmRBRateCurrency;

implementation

uses UMainUnited, UStaffTsvCode, UStaffTsvDM, UStaffTsvData, UEditRBRateCurrency;

{$R *.DFM}

procedure TfmRBRateCurrency.FormCreate(Sender: TObject);
var
  cl: TColumn;
begin
 inherited;
 try
  Caption:=NameRbkRateCurrency;
  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);
  cl:=Grid.Columns.Add;
  cl.FieldName:='currencyname';
  cl.Title.Caption:='Валюта';
  cl.Width:=150;

  cl:=Grid.Columns.Add;
  cl.FieldName:='indate';
  cl.Title.Caption:='Дата';
  cl.Width:=70;

  cl:=Grid.Columns.Add;
  cl.FieldName:='factor';
  cl.Title.Caption:='Коэффициент';
  cl.Width:=80;

  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBRateCurrency.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBRateCurrency:=nil;
end;

function TfmRBRateCurrency.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkRateCurrency+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBRateCurrency.ActiveQuery(CheckPerm: Boolean);
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
   SetImageFilter(isFindCurrencyName);
   ViewCount;
  finally
   Mainqr.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBRateCurrency.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   id:=MainQr.fieldByName('ratecurrency_id').asString;
   if UpperCase(fn)=UpperCase('currencyname') then fn:='c.name';
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('ratecurrency_id',id,[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBRateCurrency.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBRateCurrency.LoadFromIni;
begin
 inherited;
 try
    FindCurrencyName:=ReadParam(ClassName,'currencyname',FindCurrencyName);
    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBRateCurrency.SaveToIni;
begin
 inherited;
 try
    WriteParam(ClassName,'currencyname',FindCurrencyName);
    WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBRateCurrency.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBRateCurrency.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBRateCurrency;
begin
  if not Mainqr.Active then exit;
  fm:=TfmEditRBRateCurrency.Create(nil);
  try
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('ratecurrency_id',fm.oldratecurrency_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBRateCurrency.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBRateCurrency;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBRateCurrency.Create(nil);
  try
    fm.TypeEditRBook:=terbChange;
    fm.edCurrency.Text:=Mainqr.fieldByName('currencyname').AsString;
    fm.currency_id:=Mainqr.fieldByName('currency_id').AsInteger;
    fm.dtpInDate.Date:=Mainqr.fieldByName('indate').AsDateTime;
    fm.edFactor.Text:=Mainqr.fieldByName('factor').AsString;
    fm.oldratecurrency_id:=MainQr.FieldByName('ratecurrency_id').AsInteger;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('ratecurrency_id',fm.oldratecurrency_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBRateCurrency.bibDelClick(Sender: TObject);
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
     sqls:='Delete from '+tbRateCurrency+' where ratecurrency_id='+
          Mainqr.FieldByName('ratecurrency_id').asString;
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
  but:=DeleteWarningEx('курс валюты на <'+Mainqr.FieldByName('indate').AsString+'> ?');
  if but=mrYes then begin
    if not deleteRecord then begin
{      ShowError(Application.Handle,
               'Воиский состав <'+Mainqr.FieldByName('name').AsString+'> используется.');}
    end;
  end;
end;

procedure TfmRBRateCurrency.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBRateCurrency;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBRateCurrency.Create(nil);
  try
    fm.TypeEditRBook:=terbView;
    fm.edCurrency.Text:=Mainqr.fieldByName('currencyname').AsString;
    fm.currency_id:=Mainqr.fieldByName('currency_id').AsInteger;
    fm.dtpInDate.Date:=Mainqr.fieldByName('indate').AsDateTime;
    fm.edFactor.Text:=Mainqr.fieldByName('factor').AsString;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBRateCurrency.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBRateCurrency;
  filstr: string;
begin
 fm:=TfmEditRBRateCurrency.Create(nil);
 try
  fm.TypeEditRBook:=terbFilter;

  fm.edCurrency.ReadOnly:=false;
  fm.edCurrency.Color:=clWindow;
  fm.dtpInDate.Color:=clBtnFace;
  fm.dtpInDate.Enabled:=false;
  fm.edFactor.Color:=clBtnFace;
  fm.edFactor.Enabled:=false;

  if Trim(FindCurrencyName)<>'' then fm.edCurrency.Text:=FindCurrencyName;

  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    inherited;

    FindCurrencyName:=Trim(fm.edCurrency.Text);

    FilterInSide:=fm.cbInString.Checked;
    if FilterInSide then filstr:='%';

    ActiveQuery(false);
    ViewCount;
  end;
 finally
  fm.Free;
 end;
end;

function TfmRBRateCurrency.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then exit;

    isFindCurrencyName:=Trim(FindCurrencyName)<>'';

    if isFindCurrencyName then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindCurrencyName then begin
        addstr1:=' Upper(c.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindCurrencyName+'%'))+' ';
     end;

     Result:=wherestr+addstr1;
end;


end.
