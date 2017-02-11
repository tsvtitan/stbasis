unit URBPms_Direction_Correspond;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, Menus , tsvDbGrid, IBUpdateSQL;

type
   TfmRBPms_Direction_Correspond = class(TfmRBMainGrid)
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
  private
    isFindCityRegion,isFindDirection: Boolean;
    FindCityRegion,FindDirection: String;
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
  fmRBPms_Direction_Correspond: TfmRBPms_Direction_Correspond;

implementation

uses UMainUnited, UPremisesTsvCode, UPremisesTsvDM, UPremisesTsvData, UEditRBPms_Direction_Correspond;

{$R *.DFM}

procedure TfmRBPms_Direction_Correspond.FormCreate(Sender: TObject);
var
  cl: TColumn;
begin
 inherited;
 try
  Caption:=NameRbkPms_Direction_Correspond;
  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  cl:=Grid.Columns.Add;
  cl.FieldName:='CITY_REGION';
  cl.Title.Caption:='Район города';
  cl.Width:=150;

  cl:=Grid.Columns.Add;
  cl.FieldName:='DIRECTION';
  cl.Title.Caption:='Направление';
  cl.Width:=150;


 // LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBPms_Direction_Correspond.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBPms_Direction_Correspond:=nil;
end;

function TfmRBPms_Direction_Correspond.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkPms_Direction_Correspond+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBPms_Direction_Correspond.ActiveQuery(CheckPerm: Boolean);
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
   SetImageFilter(isFindCityRegion or isFindDirection);
   ViewCount;
  finally
   Mainqr.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBPms_Direction_Correspond.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id1,id2: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   if UpperCase(fn)=UpperCase('city_region') then fn:='PCR.NAME';
   if UpperCase(fn)=UpperCase('direction') then fn:='PR.NAME';
   id1:=MainQr.fieldByName('pms_city_region_id').asString;
   id2:=MainQr.fieldByName('pms_direction_id').asString;
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('pms_city_region_id;pms_direction_id',VarArrayOf([id1,id2]),[LocaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBPms_Direction_Correspond.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBPms_Direction_Correspond.LoadFromIni;
begin
 inherited;
 try
    FindCityRegion:=ReadParam(ClassName,'CityRegion',FindCityRegion);
    FindDirection:=ReadParam(ClassName,'Direction',FindDirection);
    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBPms_Direction_Correspond.SaveToIni;
begin
 inherited;
 try

    WriteParam(ClassName,'CityRegion',FindCityRegion);
    WriteParam(ClassName,'Direction',FindDirection);
    WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBPms_Direction_Correspond.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBPms_Direction_Correspond.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBPms_Direction_Correspond;
begin
  if not Mainqr.Active then exit;
  fm:=TfmEditRBPms_Direction_Correspond.Create(nil);
  try
    fm.fmParent:=Self;
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ViewCount;
     MainQr.Locate('pms_city_region_id;pms_direction_id',VarArrayOf([fm.oldpms_city_region_id,fm.pms_direction_id]),[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBPms_Direction_Correspond.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBPms_Direction_Correspond;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBPms_Direction_Correspond.Create(nil);
  try
    fm.fmParent:=Self;


    fm.edCityRegion.Text:=Mainqr.fieldByName('CITY_REGION').AsString;
    fm.edDirection.Text:=Mainqr.fieldByName('DIRECTION').AsString;

    fm.oldpms_city_region_id:=MainQr.FieldByName('pms_city_region_id').AsInteger;
    fm.oldpms_direction_id:=MainQr.FieldByName('pms_direction_id').AsInteger;

    fm.pms_city_region_id:=MainQr.FieldByName('pms_city_region_id').AsInteger;
    fm.pms_direction_id:=MainQr.FieldByName('pms_direction_id').AsInteger;

    fm.ChangeFlag:=false;

    fm.TypeEditRBook:=terbChange;
    if fm.ShowModal=mrok then begin
    MainQr.Locate('pms_city_region_id;pms_direction_id',VarArrayOf([fm.oldpms_city_region_id,fm.pms_direction_id]),[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBPms_Direction_Correspond.bibDelClick(Sender: TObject);
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
     sqls:='Delete from '+tbPms_Direction_Correspond+' where pms_city_region_id='+
          Mainqr.FieldByName('pms_city_region_id').asString+ ' and '+' pms_direction_id='+
          Mainqr.FieldByName('pms_direction_id').asString;
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
  but:=DeleteWarningEx('Соответствие <района : '+Mainqr.FieldByName('CITY_REGION').AsString+' и направления : '+Mainqr.FieldByName('DIRECTION').AsString+'> ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBPms_Direction_Correspond.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBPms_Direction_Correspond;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBPms_Direction_Correspond.Create(nil);
  try
    fm.TypeEditRBook:=terbView;
    fm.btCityRegion.Visible:=false;
    fm.btDirection.Visible:=false;
    fm.edCityRegion.Text:=Mainqr.fieldByName('CITY_REGION').AsString;
    fm.edDirection.Text:=Mainqr.fieldByName('DIRECTION').AsString;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBPms_Direction_Correspond.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBPms_Direction_Correspond;
  filstr: string;
begin
 fm:=TfmEditRBPms_Direction_Correspond.Create(nil);
 try
  fm.TypeEditRBook:=terbFilter;

  fm.edCityRegion.ReadOnly:=False;
  fm.edDirection.ReadOnly:=False;




  fm.edCityRegion.Color:=clWindow;
  fm.edDirection.Color:=clWindow;


  fm.btCityRegion.Visible:=true;
  fm.btDirection.Visible:=true;

  if Trim(FindCityRegion)<>'' then fm.edCityRegion.Text:=FindCityRegion;
  if Trim(FindDirection)<>'' then fm.edDirection.Text:=FindDirection;


  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    inherited;

    FindCityRegion:=Trim(fm.edCityRegion.Text);
    FindDirection:=Trim(fm.edDirection.Text);


    FilterInSide:=fm.cbInString.Checked;
    if FilterInSide then filstr:='%';

    ActiveQuery(false);
    ViewCount;
  end;
 finally
  fm.Free;
 end;
end;

function TfmRBPms_Direction_Correspond.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2: string;
  and1: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then exit;

    isFindCityRegion:=Trim(FindCityRegion)<>'';
    isFindDirection:=Trim(FindDirection)<>'';

    if isFindCityRegion or isFindDirection then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindCityRegion then begin
        addstr1:=' Upper(PCR.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindCityRegion+'%'))+' ';
     end;

     if isFindDirection then begin
        addstr2:=' Upper(DR.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindDirection+'%'))+' ';
     end;

     if (isFindCityRegion and isFindDirection)
     then and1:=' and ';
     Result:=wherestr+addstr1+and1+
                      addstr2;
end;


end.
