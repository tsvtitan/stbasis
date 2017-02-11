unit URBPms_Advertisment;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, Menus , tsvDbGrid, IBUpdateSQL, Grids;

type
   TfmRBPms_Advertisment = class(TfmRBMainGrid)
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
    isFindName,isFindNote: Boolean;
    FindName,FindNote: String;
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
  fmRBPms_Advertisment: TfmRBPms_Advertisment;

implementation

uses UMainUnited, UPremisesTsvCode, UPremisesTsvDM, UPremisesTsvData, UEditRBPms_Advertisment;

const
   ConstTypeOperationSale='Продажа';
   ConstTypeOperationLease='Аренда';
   ConstTypeOperationShare='Долевое';

function GetTypeOperationName(Value: Integer): string;
begin
  Result:='';
  case Value of
    0: Result:=ConstTypeOperationSale;
    1: Result:=ConstTypeOperationLease;
    2: Result:=ConstTypeOperationShare;
  end;
end;

{$R *.DFM}

procedure TfmRBPms_Advertisment.FormCreate(Sender: TObject);
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

  

  ifl:=TIntegerField.Create(nil);
  ifl.FieldName:='pms_advertisment_id';
  ifl.Visible:=false;
  ifl.DataSet:=Mainqr;


  sfl:=TStringField.Create(nil);
  sfl.FieldName:='name';
  sfl.DataSet:=Mainqr;
  sfl.Size:=DomainNameLength;

  cl:=Grid.Columns.Add;
  cl.Field:=sfl;
  cl.Title.Caption:='Наименование';
  cl.Width:=150;

  sfl:=TStringField.Create(nil);
  sfl.FieldName:='note';
  sfl.DataSet:=Mainqr;
  sfl.Size:=DomainNameLength;

  cl:=Grid.Columns.Add;
  cl.Field:=sfl;
  cl.Title.Caption:='Описание';
  cl.Width:=150;

  ifl:=TIntegerField.Create(nil);
  ifl.FieldName:='amount';
  ifl.Visible:=false;
  ifl.DataSet:=Mainqr;

  cl:=Grid.Columns.Add;
  cl.Field:=ifl;
  cl.Title.Caption:='Количество';
  cl.Width:=60;

  ifl:=TIntegerField.Create(nil);
  ifl.FieldName:='sortnumber';
  ifl.Visible:=false;
  ifl.DataSet:=Mainqr;

  cl:=Grid.Columns.Add;
  cl.Field:=ifl;
  cl.Title.Caption:='Порядок';
  cl.Width:=40;


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
  cl.Title.Caption:='Тип операции';
  cl.Width:=100;

  Mainqr.OnCalcFields:=MainqrCalcFields;




  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBPms_Advertisment.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBPms_Advertisment:=nil;
end;

function TfmRBPms_Advertisment.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkPms_Advertisment+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBPms_Advertisment.ActiveQuery(CheckPerm: Boolean);
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
   SetImageFilter(isFindName or isFindNote);
   ViewCount;
  finally
   Mainqr.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBPms_Advertisment.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   if AnsiSameText(fn,'typeoperationplus') then fn:='typeoperation';
   id:=MainQr.fieldByName('Pms_Advertisment_id').asString;
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('Pms_Advertisment_id',id,[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBPms_Advertisment.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBPms_Advertisment.LoadFromIni;
begin
 inherited;
 try
    FindName:=ReadParam(ClassName,'name',FindName);
    FindNote:=ReadParam(ClassName,'Note',FindNote);
    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBPms_Advertisment.SaveToIni;
begin
 inherited;
 try
    WriteParam(ClassName,'name',FindName);
    WriteParam(ClassName,'Note',FindNote);
    WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBPms_Advertisment.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBPms_Advertisment.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBPms_Advertisment;
begin
  if not Mainqr.Active then exit;
  fm:=TfmEditRBPms_Advertisment.Create(nil);
  try
    fm.fmParent:=Self;
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;

    fm.cmbTypeOperation.Items.AddObject('Продажа',TObject(0));
    fm.cmbTypeOperation.Items.AddObject('Аренда',TObject(1));
    fm.cmbTypeOperation.Items.AddObject('Долевое',TObject(2));

    if fm.ShowModal=mrok then begin
     ViewCount;
     MainQr.Locate('Pms_Advertisment_id',fm.oldPms_Advertisment_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBPms_Advertisment.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBPms_Advertisment;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBPms_Advertisment.Create(nil);
  try
    fm.fmParent:=Self;
    fm.TypeEditRBook:=terbChange;
    fm.edName.Text:=Mainqr.fieldByName('name').AsString;
    fm.edNote.Text:=Mainqr.fieldByName('Note').AsString;
    fm.udAmount.Position:=Mainqr.fieldByName('amount').AsInteger;
    fm.UpDownSortnumber.Position:=Mainqr.fieldByName('sortnumber').AsInteger;

    fm.cmbTypeOperation.Items.AddObject('Продажа',TObject(0));
    fm.cmbTypeOperation.Items.AddObject('Аренда',TObject(1));
    fm.cmbTypeOperation.Items.AddObject('Долевое',TObject(2));

    fm.cmbTypeOperation.ItemIndex:=MainQr.FieldByName('typeoperation').AsInteger;

    fm.oldPms_Advertisment_id:=MainQr.FieldByName('Pms_Advertisment_id').AsInteger;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     MainQr.Locate('Pms_Advertisment_id',fm.oldPms_Advertisment_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBPms_Advertisment.bibDelClick(Sender: TObject);
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
     sqls:='Delete from '+tbPms_Advertisment+' where Pms_Advertisment_id='+
          Mainqr.FieldByName('Pms_Advertisment_id').asString;
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
  but:=DeleteWarningEx('вид мебели <'+Mainqr.FieldByName('name').AsString+'> ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBPms_Advertisment.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBPms_Advertisment;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBPms_Advertisment.Create(nil);
  try
    fm.TypeEditRBook:=terbView;
    fm.edName.Text:=Mainqr.fieldByName('name').AsString;
    fm.edNote.Text:=Mainqr.fieldByName('Note').AsString;
    fm.udAmount.Position:=Mainqr.fieldByName('amount').AsInteger;
    fm.UpDownSortnumber.Position:=Mainqr.fieldByName('sortnumber').AsInteger;

    fm.cmbTypeOperation.Items.AddObject('Продажа',TObject(0));
    fm.cmbTypeOperation.Items.AddObject('Аренда',TObject(1));
    fm.cmbTypeOperation.Items.AddObject('Долевое',TObject(2));

    fm.cmbTypeOperation.ItemIndex:=MainQr.FieldByName('typeoperation').AsInteger;

    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBPms_Advertisment.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBPms_Advertisment;
  filstr: string;
begin
 fm:=TfmEditRBPms_Advertisment.Create(nil);
 try
  fm.TypeEditRBook:=terbFilter;

  fm.lbAmount.Enabled:=false;
  fm.edAmount.Enabled:=false;
  fm.edAmount.Color:=clBtnFace;
  fm.udAmount.Enabled:=false;

  fm.LabelSortnumber.Enabled:=false;
  fm.EditSortnumber.Enabled:=false;
  fm.EditSortnumber.Color:=clBtnFace;
  fm.UpDownSortnumber.Enabled:=false;

  fm.lbTypeOperation.Enabled:=false;
  fm.cmbTypeOperation.Enabled:=false;
  fm.cmbTypeOperation.Color:=clBtnFace;

  if Trim(FindName)<>'' then fm.edName.Text:=FindName;
  if Trim(FindNote)<>'' then fm.edNote.Text:=FindNote;

  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    inherited;

    FindName:=Trim(fm.edName.Text);
    FindNote:=Trim(fm.edNote.Text);

    FilterInSide:=fm.cbInString.Checked;
    if FilterInSide then filstr:='%';

    ActiveQuery(false);
    ViewCount;
  end;
 finally
  fm.Free;
 end;
end;

function TfmRBPms_Advertisment.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2: string;
  and1: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then exit;

    isFindName:=Trim(FindName)<>'';
    isFindNote:=Trim(FindNote)<>'';

    if isFindName or isFindNote then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindName then begin
        addstr1:=' Upper(name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindName+'%'))+' ';
     end;

     if isFindNote then begin
        addstr2:=' Upper(Note) like '+AnsiUpperCase(QuotedStr(FilInSide+FindNote+'%'))+' ';
     end;

     if (isFindName and isFindNote)then
      and1:=' and ';

     Result:=wherestr+addstr1+and1+
                      addstr2;
end;

procedure TfmRBPms_Advertisment.MainqrCalcFields(DataSet: TDataSet);
begin
  DataSet['typeoperationplus']:=GetTypeOperationName(DataSet.FieldByName('typeoperation').AsInteger);
end;

end.
